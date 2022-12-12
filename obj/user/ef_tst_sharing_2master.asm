
obj/user/ef_tst_sharing_2master:     file format elf32-i386


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
  800031:	e8 49 03 00 00       	call   80037f <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Master program: create the shared variables, initialize them and run slaves
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 34             	sub    $0x34,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80003f:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800043:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80004a:	eb 29                	jmp    800075 <_main+0x3d>
		{
			if (myEnv->__uptr_pws[i].empty)
  80004c:	a1 20 50 80 00       	mov    0x805020,%eax
  800051:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800057:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80005a:	89 d0                	mov    %edx,%eax
  80005c:	01 c0                	add    %eax,%eax
  80005e:	01 d0                	add    %edx,%eax
  800060:	c1 e0 03             	shl    $0x3,%eax
  800063:	01 c8                	add    %ecx,%eax
  800065:	8a 40 04             	mov    0x4(%eax),%al
  800068:	84 c0                	test   %al,%al
  80006a:	74 06                	je     800072 <_main+0x3a>
			{
				fullWS = 0;
  80006c:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  800070:	eb 12                	jmp    800084 <_main+0x4c>
_main(void)
{
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800072:	ff 45 f0             	incl   -0x10(%ebp)
  800075:	a1 20 50 80 00       	mov    0x805020,%eax
  80007a:	8b 50 74             	mov    0x74(%eax),%edx
  80007d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800080:	39 c2                	cmp    %eax,%edx
  800082:	77 c8                	ja     80004c <_main+0x14>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800084:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800088:	74 14                	je     80009e <_main+0x66>
  80008a:	83 ec 04             	sub    $0x4,%esp
  80008d:	68 60 38 80 00       	push   $0x803860
  800092:	6a 13                	push   $0x13
  800094:	68 7c 38 80 00       	push   $0x80387c
  800099:	e8 1d 04 00 00       	call   8004bb <_panic>
	}
	uint32 *x, *y, *z ;

	//x: Readonly
	int freeFrames = sys_calculate_free_frames() ;
  80009e:	e8 dc 18 00 00       	call   80197f <sys_calculate_free_frames>
  8000a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	x = smalloc("x", 4, 0);
  8000a6:	83 ec 04             	sub    $0x4,%esp
  8000a9:	6a 00                	push   $0x0
  8000ab:	6a 04                	push   $0x4
  8000ad:	68 9a 38 80 00       	push   $0x80389a
  8000b2:	e8 88 16 00 00       	call   80173f <smalloc>
  8000b7:	83 c4 10             	add    $0x10,%esp
  8000ba:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if (x != (uint32*)USER_HEAP_START) panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8000bd:	81 7d e8 00 00 00 80 	cmpl   $0x80000000,-0x18(%ebp)
  8000c4:	74 14                	je     8000da <_main+0xa2>
  8000c6:	83 ec 04             	sub    $0x4,%esp
  8000c9:	68 9c 38 80 00       	push   $0x80389c
  8000ce:	6a 1a                	push   $0x1a
  8000d0:	68 7c 38 80 00       	push   $0x80387c
  8000d5:	e8 e1 03 00 00       	call   8004bb <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Create(): Wrong allocation- make sure that you allocate the required space in the user environment and add its frames to frames_storage %d %d %d", freeFrames, sys_calculate_free_frames(), freeFrames - sys_calculate_free_frames());
  8000da:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000dd:	e8 9d 18 00 00       	call   80197f <sys_calculate_free_frames>
  8000e2:	29 c3                	sub    %eax,%ebx
  8000e4:	89 d8                	mov    %ebx,%eax
  8000e6:	83 f8 04             	cmp    $0x4,%eax
  8000e9:	74 28                	je     800113 <_main+0xdb>
  8000eb:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000ee:	e8 8c 18 00 00       	call   80197f <sys_calculate_free_frames>
  8000f3:	29 c3                	sub    %eax,%ebx
  8000f5:	e8 85 18 00 00       	call   80197f <sys_calculate_free_frames>
  8000fa:	83 ec 08             	sub    $0x8,%esp
  8000fd:	53                   	push   %ebx
  8000fe:	50                   	push   %eax
  8000ff:	ff 75 ec             	pushl  -0x14(%ebp)
  800102:	68 00 39 80 00       	push   $0x803900
  800107:	6a 1b                	push   $0x1b
  800109:	68 7c 38 80 00       	push   $0x80387c
  80010e:	e8 a8 03 00 00       	call   8004bb <_panic>

	//y: Readonly
	freeFrames = sys_calculate_free_frames() ;
  800113:	e8 67 18 00 00       	call   80197f <sys_calculate_free_frames>
  800118:	89 45 ec             	mov    %eax,-0x14(%ebp)
	y = smalloc("y", 4, 0);
  80011b:	83 ec 04             	sub    $0x4,%esp
  80011e:	6a 00                	push   $0x0
  800120:	6a 04                	push   $0x4
  800122:	68 91 39 80 00       	push   $0x803991
  800127:	e8 13 16 00 00       	call   80173f <smalloc>
  80012c:	83 c4 10             	add    $0x10,%esp
  80012f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (y != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  800132:	81 7d e4 00 10 00 80 	cmpl   $0x80001000,-0x1c(%ebp)
  800139:	74 14                	je     80014f <_main+0x117>
  80013b:	83 ec 04             	sub    $0x4,%esp
  80013e:	68 9c 38 80 00       	push   $0x80389c
  800143:	6a 20                	push   $0x20
  800145:	68 7c 38 80 00       	push   $0x80387c
  80014a:	e8 6c 03 00 00       	call   8004bb <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1+0+2) panic("Create(): Wrong allocation- make sure that you allocate the required space in the user environment and add its frames to frames_storage %d %d %d", freeFrames, sys_calculate_free_frames(), freeFrames - sys_calculate_free_frames());
  80014f:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  800152:	e8 28 18 00 00       	call   80197f <sys_calculate_free_frames>
  800157:	29 c3                	sub    %eax,%ebx
  800159:	89 d8                	mov    %ebx,%eax
  80015b:	83 f8 03             	cmp    $0x3,%eax
  80015e:	74 28                	je     800188 <_main+0x150>
  800160:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  800163:	e8 17 18 00 00       	call   80197f <sys_calculate_free_frames>
  800168:	29 c3                	sub    %eax,%ebx
  80016a:	e8 10 18 00 00       	call   80197f <sys_calculate_free_frames>
  80016f:	83 ec 08             	sub    $0x8,%esp
  800172:	53                   	push   %ebx
  800173:	50                   	push   %eax
  800174:	ff 75 ec             	pushl  -0x14(%ebp)
  800177:	68 00 39 80 00       	push   $0x803900
  80017c:	6a 21                	push   $0x21
  80017e:	68 7c 38 80 00       	push   $0x80387c
  800183:	e8 33 03 00 00       	call   8004bb <_panic>

	//z: Writable
	freeFrames = sys_calculate_free_frames() ;
  800188:	e8 f2 17 00 00       	call   80197f <sys_calculate_free_frames>
  80018d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	z = smalloc("z", 4, 1);
  800190:	83 ec 04             	sub    $0x4,%esp
  800193:	6a 01                	push   $0x1
  800195:	6a 04                	push   $0x4
  800197:	68 93 39 80 00       	push   $0x803993
  80019c:	e8 9e 15 00 00       	call   80173f <smalloc>
  8001a1:	83 c4 10             	add    $0x10,%esp
  8001a4:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (z != (uint32*)(USER_HEAP_START + 2 * PAGE_SIZE)) panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8001a7:	81 7d e0 00 20 00 80 	cmpl   $0x80002000,-0x20(%ebp)
  8001ae:	74 14                	je     8001c4 <_main+0x18c>
  8001b0:	83 ec 04             	sub    $0x4,%esp
  8001b3:	68 9c 38 80 00       	push   $0x80389c
  8001b8:	6a 26                	push   $0x26
  8001ba:	68 7c 38 80 00       	push   $0x80387c
  8001bf:	e8 f7 02 00 00       	call   8004bb <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1+0+2) panic("Create(): Wrong allocation- make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8001c4:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8001c7:	e8 b3 17 00 00       	call   80197f <sys_calculate_free_frames>
  8001cc:	29 c3                	sub    %eax,%ebx
  8001ce:	89 d8                	mov    %ebx,%eax
  8001d0:	83 f8 03             	cmp    $0x3,%eax
  8001d3:	74 14                	je     8001e9 <_main+0x1b1>
  8001d5:	83 ec 04             	sub    $0x4,%esp
  8001d8:	68 98 39 80 00       	push   $0x803998
  8001dd:	6a 27                	push   $0x27
  8001df:	68 7c 38 80 00       	push   $0x80387c
  8001e4:	e8 d2 02 00 00       	call   8004bb <_panic>

	*x = 10 ;
  8001e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001ec:	c7 00 0a 00 00 00    	movl   $0xa,(%eax)
	*y = 20 ;
  8001f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001f5:	c7 00 14 00 00 00    	movl   $0x14,(%eax)

	int id1, id2, id3;
	id1 = sys_create_env("ef_shr2Slave1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  8001fb:	a1 20 50 80 00       	mov    0x805020,%eax
  800200:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800206:	89 c2                	mov    %eax,%edx
  800208:	a1 20 50 80 00       	mov    0x805020,%eax
  80020d:	8b 40 74             	mov    0x74(%eax),%eax
  800210:	6a 32                	push   $0x32
  800212:	52                   	push   %edx
  800213:	50                   	push   %eax
  800214:	68 20 3a 80 00       	push   $0x803a20
  800219:	e8 d3 19 00 00       	call   801bf1 <sys_create_env>
  80021e:	83 c4 10             	add    $0x10,%esp
  800221:	89 45 dc             	mov    %eax,-0x24(%ebp)
	id2 = sys_create_env("ef_shr2Slave1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  800224:	a1 20 50 80 00       	mov    0x805020,%eax
  800229:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80022f:	89 c2                	mov    %eax,%edx
  800231:	a1 20 50 80 00       	mov    0x805020,%eax
  800236:	8b 40 74             	mov    0x74(%eax),%eax
  800239:	6a 32                	push   $0x32
  80023b:	52                   	push   %edx
  80023c:	50                   	push   %eax
  80023d:	68 20 3a 80 00       	push   $0x803a20
  800242:	e8 aa 19 00 00       	call   801bf1 <sys_create_env>
  800247:	83 c4 10             	add    $0x10,%esp
  80024a:	89 45 d8             	mov    %eax,-0x28(%ebp)
	id3 = sys_create_env("ef_shr2Slave1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  80024d:	a1 20 50 80 00       	mov    0x805020,%eax
  800252:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800258:	89 c2                	mov    %eax,%edx
  80025a:	a1 20 50 80 00       	mov    0x805020,%eax
  80025f:	8b 40 74             	mov    0x74(%eax),%eax
  800262:	6a 32                	push   $0x32
  800264:	52                   	push   %edx
  800265:	50                   	push   %eax
  800266:	68 20 3a 80 00       	push   $0x803a20
  80026b:	e8 81 19 00 00       	call   801bf1 <sys_create_env>
  800270:	83 c4 10             	add    $0x10,%esp
  800273:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	//to check that the slave environments completed successfully
	rsttst();
  800276:	e8 c2 1a 00 00       	call   801d3d <rsttst>

	int* finish_children = smalloc("finish_children", sizeof(int), 1);
  80027b:	83 ec 04             	sub    $0x4,%esp
  80027e:	6a 01                	push   $0x1
  800280:	6a 04                	push   $0x4
  800282:	68 2e 3a 80 00       	push   $0x803a2e
  800287:	e8 b3 14 00 00       	call   80173f <smalloc>
  80028c:	83 c4 10             	add    $0x10,%esp
  80028f:	89 45 d0             	mov    %eax,-0x30(%ebp)

	sys_run_env(id1);
  800292:	83 ec 0c             	sub    $0xc,%esp
  800295:	ff 75 dc             	pushl  -0x24(%ebp)
  800298:	e8 72 19 00 00       	call   801c0f <sys_run_env>
  80029d:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id2);
  8002a0:	83 ec 0c             	sub    $0xc,%esp
  8002a3:	ff 75 d8             	pushl  -0x28(%ebp)
  8002a6:	e8 64 19 00 00       	call   801c0f <sys_run_env>
  8002ab:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id3);
  8002ae:	83 ec 0c             	sub    $0xc,%esp
  8002b1:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002b4:	e8 56 19 00 00       	call   801c0f <sys_run_env>
  8002b9:	83 c4 10             	add    $0x10,%esp

	env_sleep(15000) ;
  8002bc:	83 ec 0c             	sub    $0xc,%esp
  8002bf:	68 98 3a 00 00       	push   $0x3a98
  8002c4:	e8 78 32 00 00       	call   803541 <env_sleep>
  8002c9:	83 c4 10             	add    $0x10,%esp

	//to ensure that the slave environments completed successfully
	if (gettst()!=3) panic("test failed");
  8002cc:	e8 e6 1a 00 00       	call   801db7 <gettst>
  8002d1:	83 f8 03             	cmp    $0x3,%eax
  8002d4:	74 14                	je     8002ea <_main+0x2b2>
  8002d6:	83 ec 04             	sub    $0x4,%esp
  8002d9:	68 3e 3a 80 00       	push   $0x803a3e
  8002de:	6a 3d                	push   $0x3d
  8002e0:	68 7c 38 80 00       	push   $0x80387c
  8002e5:	e8 d1 01 00 00       	call   8004bb <_panic>


	if (*z != 30)
  8002ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002ed:	8b 00                	mov    (%eax),%eax
  8002ef:	83 f8 1e             	cmp    $0x1e,%eax
  8002f2:	74 14                	je     800308 <_main+0x2d0>
		panic("Error!! Please check the creation (or the getting) of shared 2variables!!\n\n\n");
  8002f4:	83 ec 04             	sub    $0x4,%esp
  8002f7:	68 4c 3a 80 00       	push   $0x803a4c
  8002fc:	6a 41                	push   $0x41
  8002fe:	68 7c 38 80 00       	push   $0x80387c
  800303:	e8 b3 01 00 00       	call   8004bb <_panic>
	else
		cprintf("Congratulations!! Test of Shared Variables [Create & Get] [2] completed successfully!!\n\n\n");
  800308:	83 ec 0c             	sub    $0xc,%esp
  80030b:	68 9c 3a 80 00       	push   $0x803a9c
  800310:	e8 5a 04 00 00       	call   80076f <cprintf>
  800315:	83 c4 10             	add    $0x10,%esp


	if (sys_getparentenvid() > 0) {
  800318:	e8 5b 19 00 00       	call   801c78 <sys_getparentenvid>
  80031d:	85 c0                	test   %eax,%eax
  80031f:	7e 58                	jle    800379 <_main+0x341>
		sys_destroy_env(id1);
  800321:	83 ec 0c             	sub    $0xc,%esp
  800324:	ff 75 dc             	pushl  -0x24(%ebp)
  800327:	e8 ff 18 00 00       	call   801c2b <sys_destroy_env>
  80032c:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(id2);
  80032f:	83 ec 0c             	sub    $0xc,%esp
  800332:	ff 75 d8             	pushl  -0x28(%ebp)
  800335:	e8 f1 18 00 00       	call   801c2b <sys_destroy_env>
  80033a:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(id3);
  80033d:	83 ec 0c             	sub    $0xc,%esp
  800340:	ff 75 d4             	pushl  -0x2c(%ebp)
  800343:	e8 e3 18 00 00       	call   801c2b <sys_destroy_env>
  800348:	83 c4 10             	add    $0x10,%esp
		int *finishedCount = NULL;
  80034b:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
		finishedCount = sget(sys_getparentenvid(), "finishedCount") ;
  800352:	e8 21 19 00 00       	call   801c78 <sys_getparentenvid>
  800357:	83 ec 08             	sub    $0x8,%esp
  80035a:	68 f6 3a 80 00       	push   $0x803af6
  80035f:	50                   	push   %eax
  800360:	e8 76 14 00 00       	call   8017db <sget>
  800365:	83 c4 10             	add    $0x10,%esp
  800368:	89 45 cc             	mov    %eax,-0x34(%ebp)
		(*finishedCount)++ ;
  80036b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80036e:	8b 00                	mov    (%eax),%eax
  800370:	8d 50 01             	lea    0x1(%eax),%edx
  800373:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800376:	89 10                	mov    %edx,(%eax)
	}
	return;
  800378:	90                   	nop
  800379:	90                   	nop
}
  80037a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80037d:	c9                   	leave  
  80037e:	c3                   	ret    

0080037f <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80037f:	55                   	push   %ebp
  800380:	89 e5                	mov    %esp,%ebp
  800382:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800385:	e8 d5 18 00 00       	call   801c5f <sys_getenvindex>
  80038a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80038d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800390:	89 d0                	mov    %edx,%eax
  800392:	c1 e0 03             	shl    $0x3,%eax
  800395:	01 d0                	add    %edx,%eax
  800397:	01 c0                	add    %eax,%eax
  800399:	01 d0                	add    %edx,%eax
  80039b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003a2:	01 d0                	add    %edx,%eax
  8003a4:	c1 e0 04             	shl    $0x4,%eax
  8003a7:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8003ac:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8003b1:	a1 20 50 80 00       	mov    0x805020,%eax
  8003b6:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8003bc:	84 c0                	test   %al,%al
  8003be:	74 0f                	je     8003cf <libmain+0x50>
		binaryname = myEnv->prog_name;
  8003c0:	a1 20 50 80 00       	mov    0x805020,%eax
  8003c5:	05 5c 05 00 00       	add    $0x55c,%eax
  8003ca:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003cf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8003d3:	7e 0a                	jle    8003df <libmain+0x60>
		binaryname = argv[0];
  8003d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003d8:	8b 00                	mov    (%eax),%eax
  8003da:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8003df:	83 ec 08             	sub    $0x8,%esp
  8003e2:	ff 75 0c             	pushl  0xc(%ebp)
  8003e5:	ff 75 08             	pushl  0x8(%ebp)
  8003e8:	e8 4b fc ff ff       	call   800038 <_main>
  8003ed:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8003f0:	e8 77 16 00 00       	call   801a6c <sys_disable_interrupt>
	cprintf("**************************************\n");
  8003f5:	83 ec 0c             	sub    $0xc,%esp
  8003f8:	68 1c 3b 80 00       	push   $0x803b1c
  8003fd:	e8 6d 03 00 00       	call   80076f <cprintf>
  800402:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800405:	a1 20 50 80 00       	mov    0x805020,%eax
  80040a:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800410:	a1 20 50 80 00       	mov    0x805020,%eax
  800415:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80041b:	83 ec 04             	sub    $0x4,%esp
  80041e:	52                   	push   %edx
  80041f:	50                   	push   %eax
  800420:	68 44 3b 80 00       	push   $0x803b44
  800425:	e8 45 03 00 00       	call   80076f <cprintf>
  80042a:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80042d:	a1 20 50 80 00       	mov    0x805020,%eax
  800432:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800438:	a1 20 50 80 00       	mov    0x805020,%eax
  80043d:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800443:	a1 20 50 80 00       	mov    0x805020,%eax
  800448:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80044e:	51                   	push   %ecx
  80044f:	52                   	push   %edx
  800450:	50                   	push   %eax
  800451:	68 6c 3b 80 00       	push   $0x803b6c
  800456:	e8 14 03 00 00       	call   80076f <cprintf>
  80045b:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80045e:	a1 20 50 80 00       	mov    0x805020,%eax
  800463:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800469:	83 ec 08             	sub    $0x8,%esp
  80046c:	50                   	push   %eax
  80046d:	68 c4 3b 80 00       	push   $0x803bc4
  800472:	e8 f8 02 00 00       	call   80076f <cprintf>
  800477:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80047a:	83 ec 0c             	sub    $0xc,%esp
  80047d:	68 1c 3b 80 00       	push   $0x803b1c
  800482:	e8 e8 02 00 00       	call   80076f <cprintf>
  800487:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80048a:	e8 f7 15 00 00       	call   801a86 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80048f:	e8 19 00 00 00       	call   8004ad <exit>
}
  800494:	90                   	nop
  800495:	c9                   	leave  
  800496:	c3                   	ret    

00800497 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800497:	55                   	push   %ebp
  800498:	89 e5                	mov    %esp,%ebp
  80049a:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80049d:	83 ec 0c             	sub    $0xc,%esp
  8004a0:	6a 00                	push   $0x0
  8004a2:	e8 84 17 00 00       	call   801c2b <sys_destroy_env>
  8004a7:	83 c4 10             	add    $0x10,%esp
}
  8004aa:	90                   	nop
  8004ab:	c9                   	leave  
  8004ac:	c3                   	ret    

008004ad <exit>:

void
exit(void)
{
  8004ad:	55                   	push   %ebp
  8004ae:	89 e5                	mov    %esp,%ebp
  8004b0:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8004b3:	e8 d9 17 00 00       	call   801c91 <sys_exit_env>
}
  8004b8:	90                   	nop
  8004b9:	c9                   	leave  
  8004ba:	c3                   	ret    

008004bb <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8004bb:	55                   	push   %ebp
  8004bc:	89 e5                	mov    %esp,%ebp
  8004be:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8004c1:	8d 45 10             	lea    0x10(%ebp),%eax
  8004c4:	83 c0 04             	add    $0x4,%eax
  8004c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8004ca:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8004cf:	85 c0                	test   %eax,%eax
  8004d1:	74 16                	je     8004e9 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8004d3:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8004d8:	83 ec 08             	sub    $0x8,%esp
  8004db:	50                   	push   %eax
  8004dc:	68 d8 3b 80 00       	push   $0x803bd8
  8004e1:	e8 89 02 00 00       	call   80076f <cprintf>
  8004e6:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8004e9:	a1 00 50 80 00       	mov    0x805000,%eax
  8004ee:	ff 75 0c             	pushl  0xc(%ebp)
  8004f1:	ff 75 08             	pushl  0x8(%ebp)
  8004f4:	50                   	push   %eax
  8004f5:	68 dd 3b 80 00       	push   $0x803bdd
  8004fa:	e8 70 02 00 00       	call   80076f <cprintf>
  8004ff:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800502:	8b 45 10             	mov    0x10(%ebp),%eax
  800505:	83 ec 08             	sub    $0x8,%esp
  800508:	ff 75 f4             	pushl  -0xc(%ebp)
  80050b:	50                   	push   %eax
  80050c:	e8 f3 01 00 00       	call   800704 <vcprintf>
  800511:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800514:	83 ec 08             	sub    $0x8,%esp
  800517:	6a 00                	push   $0x0
  800519:	68 f9 3b 80 00       	push   $0x803bf9
  80051e:	e8 e1 01 00 00       	call   800704 <vcprintf>
  800523:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800526:	e8 82 ff ff ff       	call   8004ad <exit>

	// should not return here
	while (1) ;
  80052b:	eb fe                	jmp    80052b <_panic+0x70>

0080052d <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80052d:	55                   	push   %ebp
  80052e:	89 e5                	mov    %esp,%ebp
  800530:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800533:	a1 20 50 80 00       	mov    0x805020,%eax
  800538:	8b 50 74             	mov    0x74(%eax),%edx
  80053b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80053e:	39 c2                	cmp    %eax,%edx
  800540:	74 14                	je     800556 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800542:	83 ec 04             	sub    $0x4,%esp
  800545:	68 fc 3b 80 00       	push   $0x803bfc
  80054a:	6a 26                	push   $0x26
  80054c:	68 48 3c 80 00       	push   $0x803c48
  800551:	e8 65 ff ff ff       	call   8004bb <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800556:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80055d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800564:	e9 c2 00 00 00       	jmp    80062b <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800569:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80056c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800573:	8b 45 08             	mov    0x8(%ebp),%eax
  800576:	01 d0                	add    %edx,%eax
  800578:	8b 00                	mov    (%eax),%eax
  80057a:	85 c0                	test   %eax,%eax
  80057c:	75 08                	jne    800586 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80057e:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800581:	e9 a2 00 00 00       	jmp    800628 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800586:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80058d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800594:	eb 69                	jmp    8005ff <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800596:	a1 20 50 80 00       	mov    0x805020,%eax
  80059b:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8005a1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005a4:	89 d0                	mov    %edx,%eax
  8005a6:	01 c0                	add    %eax,%eax
  8005a8:	01 d0                	add    %edx,%eax
  8005aa:	c1 e0 03             	shl    $0x3,%eax
  8005ad:	01 c8                	add    %ecx,%eax
  8005af:	8a 40 04             	mov    0x4(%eax),%al
  8005b2:	84 c0                	test   %al,%al
  8005b4:	75 46                	jne    8005fc <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005b6:	a1 20 50 80 00       	mov    0x805020,%eax
  8005bb:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8005c1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005c4:	89 d0                	mov    %edx,%eax
  8005c6:	01 c0                	add    %eax,%eax
  8005c8:	01 d0                	add    %edx,%eax
  8005ca:	c1 e0 03             	shl    $0x3,%eax
  8005cd:	01 c8                	add    %ecx,%eax
  8005cf:	8b 00                	mov    (%eax),%eax
  8005d1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005d4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005d7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005dc:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8005de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005e1:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005eb:	01 c8                	add    %ecx,%eax
  8005ed:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005ef:	39 c2                	cmp    %eax,%edx
  8005f1:	75 09                	jne    8005fc <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8005f3:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8005fa:	eb 12                	jmp    80060e <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005fc:	ff 45 e8             	incl   -0x18(%ebp)
  8005ff:	a1 20 50 80 00       	mov    0x805020,%eax
  800604:	8b 50 74             	mov    0x74(%eax),%edx
  800607:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80060a:	39 c2                	cmp    %eax,%edx
  80060c:	77 88                	ja     800596 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80060e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800612:	75 14                	jne    800628 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800614:	83 ec 04             	sub    $0x4,%esp
  800617:	68 54 3c 80 00       	push   $0x803c54
  80061c:	6a 3a                	push   $0x3a
  80061e:	68 48 3c 80 00       	push   $0x803c48
  800623:	e8 93 fe ff ff       	call   8004bb <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800628:	ff 45 f0             	incl   -0x10(%ebp)
  80062b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80062e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800631:	0f 8c 32 ff ff ff    	jl     800569 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800637:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80063e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800645:	eb 26                	jmp    80066d <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800647:	a1 20 50 80 00       	mov    0x805020,%eax
  80064c:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800652:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800655:	89 d0                	mov    %edx,%eax
  800657:	01 c0                	add    %eax,%eax
  800659:	01 d0                	add    %edx,%eax
  80065b:	c1 e0 03             	shl    $0x3,%eax
  80065e:	01 c8                	add    %ecx,%eax
  800660:	8a 40 04             	mov    0x4(%eax),%al
  800663:	3c 01                	cmp    $0x1,%al
  800665:	75 03                	jne    80066a <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800667:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80066a:	ff 45 e0             	incl   -0x20(%ebp)
  80066d:	a1 20 50 80 00       	mov    0x805020,%eax
  800672:	8b 50 74             	mov    0x74(%eax),%edx
  800675:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800678:	39 c2                	cmp    %eax,%edx
  80067a:	77 cb                	ja     800647 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80067c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80067f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800682:	74 14                	je     800698 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800684:	83 ec 04             	sub    $0x4,%esp
  800687:	68 a8 3c 80 00       	push   $0x803ca8
  80068c:	6a 44                	push   $0x44
  80068e:	68 48 3c 80 00       	push   $0x803c48
  800693:	e8 23 fe ff ff       	call   8004bb <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800698:	90                   	nop
  800699:	c9                   	leave  
  80069a:	c3                   	ret    

0080069b <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80069b:	55                   	push   %ebp
  80069c:	89 e5                	mov    %esp,%ebp
  80069e:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8006a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006a4:	8b 00                	mov    (%eax),%eax
  8006a6:	8d 48 01             	lea    0x1(%eax),%ecx
  8006a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006ac:	89 0a                	mov    %ecx,(%edx)
  8006ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8006b1:	88 d1                	mov    %dl,%cl
  8006b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006b6:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8006ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006bd:	8b 00                	mov    (%eax),%eax
  8006bf:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006c4:	75 2c                	jne    8006f2 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8006c6:	a0 24 50 80 00       	mov    0x805024,%al
  8006cb:	0f b6 c0             	movzbl %al,%eax
  8006ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006d1:	8b 12                	mov    (%edx),%edx
  8006d3:	89 d1                	mov    %edx,%ecx
  8006d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006d8:	83 c2 08             	add    $0x8,%edx
  8006db:	83 ec 04             	sub    $0x4,%esp
  8006de:	50                   	push   %eax
  8006df:	51                   	push   %ecx
  8006e0:	52                   	push   %edx
  8006e1:	e8 d8 11 00 00       	call   8018be <sys_cputs>
  8006e6:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006ec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006f5:	8b 40 04             	mov    0x4(%eax),%eax
  8006f8:	8d 50 01             	lea    0x1(%eax),%edx
  8006fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006fe:	89 50 04             	mov    %edx,0x4(%eax)
}
  800701:	90                   	nop
  800702:	c9                   	leave  
  800703:	c3                   	ret    

00800704 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800704:	55                   	push   %ebp
  800705:	89 e5                	mov    %esp,%ebp
  800707:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80070d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800714:	00 00 00 
	b.cnt = 0;
  800717:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80071e:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800721:	ff 75 0c             	pushl  0xc(%ebp)
  800724:	ff 75 08             	pushl  0x8(%ebp)
  800727:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80072d:	50                   	push   %eax
  80072e:	68 9b 06 80 00       	push   $0x80069b
  800733:	e8 11 02 00 00       	call   800949 <vprintfmt>
  800738:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80073b:	a0 24 50 80 00       	mov    0x805024,%al
  800740:	0f b6 c0             	movzbl %al,%eax
  800743:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800749:	83 ec 04             	sub    $0x4,%esp
  80074c:	50                   	push   %eax
  80074d:	52                   	push   %edx
  80074e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800754:	83 c0 08             	add    $0x8,%eax
  800757:	50                   	push   %eax
  800758:	e8 61 11 00 00       	call   8018be <sys_cputs>
  80075d:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800760:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  800767:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80076d:	c9                   	leave  
  80076e:	c3                   	ret    

0080076f <cprintf>:

int cprintf(const char *fmt, ...) {
  80076f:	55                   	push   %ebp
  800770:	89 e5                	mov    %esp,%ebp
  800772:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800775:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  80077c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80077f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800782:	8b 45 08             	mov    0x8(%ebp),%eax
  800785:	83 ec 08             	sub    $0x8,%esp
  800788:	ff 75 f4             	pushl  -0xc(%ebp)
  80078b:	50                   	push   %eax
  80078c:	e8 73 ff ff ff       	call   800704 <vcprintf>
  800791:	83 c4 10             	add    $0x10,%esp
  800794:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800797:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80079a:	c9                   	leave  
  80079b:	c3                   	ret    

0080079c <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80079c:	55                   	push   %ebp
  80079d:	89 e5                	mov    %esp,%ebp
  80079f:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8007a2:	e8 c5 12 00 00       	call   801a6c <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8007a7:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b0:	83 ec 08             	sub    $0x8,%esp
  8007b3:	ff 75 f4             	pushl  -0xc(%ebp)
  8007b6:	50                   	push   %eax
  8007b7:	e8 48 ff ff ff       	call   800704 <vcprintf>
  8007bc:	83 c4 10             	add    $0x10,%esp
  8007bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8007c2:	e8 bf 12 00 00       	call   801a86 <sys_enable_interrupt>
	return cnt;
  8007c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007ca:	c9                   	leave  
  8007cb:	c3                   	ret    

008007cc <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007cc:	55                   	push   %ebp
  8007cd:	89 e5                	mov    %esp,%ebp
  8007cf:	53                   	push   %ebx
  8007d0:	83 ec 14             	sub    $0x14,%esp
  8007d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8007d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007df:	8b 45 18             	mov    0x18(%ebp),%eax
  8007e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8007e7:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007ea:	77 55                	ja     800841 <printnum+0x75>
  8007ec:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007ef:	72 05                	jb     8007f6 <printnum+0x2a>
  8007f1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8007f4:	77 4b                	ja     800841 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8007f6:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8007f9:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8007fc:	8b 45 18             	mov    0x18(%ebp),%eax
  8007ff:	ba 00 00 00 00       	mov    $0x0,%edx
  800804:	52                   	push   %edx
  800805:	50                   	push   %eax
  800806:	ff 75 f4             	pushl  -0xc(%ebp)
  800809:	ff 75 f0             	pushl  -0x10(%ebp)
  80080c:	e8 e7 2d 00 00       	call   8035f8 <__udivdi3>
  800811:	83 c4 10             	add    $0x10,%esp
  800814:	83 ec 04             	sub    $0x4,%esp
  800817:	ff 75 20             	pushl  0x20(%ebp)
  80081a:	53                   	push   %ebx
  80081b:	ff 75 18             	pushl  0x18(%ebp)
  80081e:	52                   	push   %edx
  80081f:	50                   	push   %eax
  800820:	ff 75 0c             	pushl  0xc(%ebp)
  800823:	ff 75 08             	pushl  0x8(%ebp)
  800826:	e8 a1 ff ff ff       	call   8007cc <printnum>
  80082b:	83 c4 20             	add    $0x20,%esp
  80082e:	eb 1a                	jmp    80084a <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800830:	83 ec 08             	sub    $0x8,%esp
  800833:	ff 75 0c             	pushl  0xc(%ebp)
  800836:	ff 75 20             	pushl  0x20(%ebp)
  800839:	8b 45 08             	mov    0x8(%ebp),%eax
  80083c:	ff d0                	call   *%eax
  80083e:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800841:	ff 4d 1c             	decl   0x1c(%ebp)
  800844:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800848:	7f e6                	jg     800830 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80084a:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80084d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800852:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800855:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800858:	53                   	push   %ebx
  800859:	51                   	push   %ecx
  80085a:	52                   	push   %edx
  80085b:	50                   	push   %eax
  80085c:	e8 a7 2e 00 00       	call   803708 <__umoddi3>
  800861:	83 c4 10             	add    $0x10,%esp
  800864:	05 14 3f 80 00       	add    $0x803f14,%eax
  800869:	8a 00                	mov    (%eax),%al
  80086b:	0f be c0             	movsbl %al,%eax
  80086e:	83 ec 08             	sub    $0x8,%esp
  800871:	ff 75 0c             	pushl  0xc(%ebp)
  800874:	50                   	push   %eax
  800875:	8b 45 08             	mov    0x8(%ebp),%eax
  800878:	ff d0                	call   *%eax
  80087a:	83 c4 10             	add    $0x10,%esp
}
  80087d:	90                   	nop
  80087e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800881:	c9                   	leave  
  800882:	c3                   	ret    

00800883 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800883:	55                   	push   %ebp
  800884:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800886:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80088a:	7e 1c                	jle    8008a8 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80088c:	8b 45 08             	mov    0x8(%ebp),%eax
  80088f:	8b 00                	mov    (%eax),%eax
  800891:	8d 50 08             	lea    0x8(%eax),%edx
  800894:	8b 45 08             	mov    0x8(%ebp),%eax
  800897:	89 10                	mov    %edx,(%eax)
  800899:	8b 45 08             	mov    0x8(%ebp),%eax
  80089c:	8b 00                	mov    (%eax),%eax
  80089e:	83 e8 08             	sub    $0x8,%eax
  8008a1:	8b 50 04             	mov    0x4(%eax),%edx
  8008a4:	8b 00                	mov    (%eax),%eax
  8008a6:	eb 40                	jmp    8008e8 <getuint+0x65>
	else if (lflag)
  8008a8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008ac:	74 1e                	je     8008cc <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b1:	8b 00                	mov    (%eax),%eax
  8008b3:	8d 50 04             	lea    0x4(%eax),%edx
  8008b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b9:	89 10                	mov    %edx,(%eax)
  8008bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008be:	8b 00                	mov    (%eax),%eax
  8008c0:	83 e8 04             	sub    $0x4,%eax
  8008c3:	8b 00                	mov    (%eax),%eax
  8008c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8008ca:	eb 1c                	jmp    8008e8 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cf:	8b 00                	mov    (%eax),%eax
  8008d1:	8d 50 04             	lea    0x4(%eax),%edx
  8008d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d7:	89 10                	mov    %edx,(%eax)
  8008d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008dc:	8b 00                	mov    (%eax),%eax
  8008de:	83 e8 04             	sub    $0x4,%eax
  8008e1:	8b 00                	mov    (%eax),%eax
  8008e3:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8008e8:	5d                   	pop    %ebp
  8008e9:	c3                   	ret    

008008ea <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008ea:	55                   	push   %ebp
  8008eb:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008ed:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008f1:	7e 1c                	jle    80090f <getint+0x25>
		return va_arg(*ap, long long);
  8008f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f6:	8b 00                	mov    (%eax),%eax
  8008f8:	8d 50 08             	lea    0x8(%eax),%edx
  8008fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fe:	89 10                	mov    %edx,(%eax)
  800900:	8b 45 08             	mov    0x8(%ebp),%eax
  800903:	8b 00                	mov    (%eax),%eax
  800905:	83 e8 08             	sub    $0x8,%eax
  800908:	8b 50 04             	mov    0x4(%eax),%edx
  80090b:	8b 00                	mov    (%eax),%eax
  80090d:	eb 38                	jmp    800947 <getint+0x5d>
	else if (lflag)
  80090f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800913:	74 1a                	je     80092f <getint+0x45>
		return va_arg(*ap, long);
  800915:	8b 45 08             	mov    0x8(%ebp),%eax
  800918:	8b 00                	mov    (%eax),%eax
  80091a:	8d 50 04             	lea    0x4(%eax),%edx
  80091d:	8b 45 08             	mov    0x8(%ebp),%eax
  800920:	89 10                	mov    %edx,(%eax)
  800922:	8b 45 08             	mov    0x8(%ebp),%eax
  800925:	8b 00                	mov    (%eax),%eax
  800927:	83 e8 04             	sub    $0x4,%eax
  80092a:	8b 00                	mov    (%eax),%eax
  80092c:	99                   	cltd   
  80092d:	eb 18                	jmp    800947 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80092f:	8b 45 08             	mov    0x8(%ebp),%eax
  800932:	8b 00                	mov    (%eax),%eax
  800934:	8d 50 04             	lea    0x4(%eax),%edx
  800937:	8b 45 08             	mov    0x8(%ebp),%eax
  80093a:	89 10                	mov    %edx,(%eax)
  80093c:	8b 45 08             	mov    0x8(%ebp),%eax
  80093f:	8b 00                	mov    (%eax),%eax
  800941:	83 e8 04             	sub    $0x4,%eax
  800944:	8b 00                	mov    (%eax),%eax
  800946:	99                   	cltd   
}
  800947:	5d                   	pop    %ebp
  800948:	c3                   	ret    

00800949 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800949:	55                   	push   %ebp
  80094a:	89 e5                	mov    %esp,%ebp
  80094c:	56                   	push   %esi
  80094d:	53                   	push   %ebx
  80094e:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800951:	eb 17                	jmp    80096a <vprintfmt+0x21>
			if (ch == '\0')
  800953:	85 db                	test   %ebx,%ebx
  800955:	0f 84 af 03 00 00    	je     800d0a <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80095b:	83 ec 08             	sub    $0x8,%esp
  80095e:	ff 75 0c             	pushl  0xc(%ebp)
  800961:	53                   	push   %ebx
  800962:	8b 45 08             	mov    0x8(%ebp),%eax
  800965:	ff d0                	call   *%eax
  800967:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80096a:	8b 45 10             	mov    0x10(%ebp),%eax
  80096d:	8d 50 01             	lea    0x1(%eax),%edx
  800970:	89 55 10             	mov    %edx,0x10(%ebp)
  800973:	8a 00                	mov    (%eax),%al
  800975:	0f b6 d8             	movzbl %al,%ebx
  800978:	83 fb 25             	cmp    $0x25,%ebx
  80097b:	75 d6                	jne    800953 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80097d:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800981:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800988:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80098f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800996:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80099d:	8b 45 10             	mov    0x10(%ebp),%eax
  8009a0:	8d 50 01             	lea    0x1(%eax),%edx
  8009a3:	89 55 10             	mov    %edx,0x10(%ebp)
  8009a6:	8a 00                	mov    (%eax),%al
  8009a8:	0f b6 d8             	movzbl %al,%ebx
  8009ab:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009ae:	83 f8 55             	cmp    $0x55,%eax
  8009b1:	0f 87 2b 03 00 00    	ja     800ce2 <vprintfmt+0x399>
  8009b7:	8b 04 85 38 3f 80 00 	mov    0x803f38(,%eax,4),%eax
  8009be:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009c0:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009c4:	eb d7                	jmp    80099d <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009c6:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009ca:	eb d1                	jmp    80099d <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009cc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009d3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009d6:	89 d0                	mov    %edx,%eax
  8009d8:	c1 e0 02             	shl    $0x2,%eax
  8009db:	01 d0                	add    %edx,%eax
  8009dd:	01 c0                	add    %eax,%eax
  8009df:	01 d8                	add    %ebx,%eax
  8009e1:	83 e8 30             	sub    $0x30,%eax
  8009e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8009e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ea:	8a 00                	mov    (%eax),%al
  8009ec:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009ef:	83 fb 2f             	cmp    $0x2f,%ebx
  8009f2:	7e 3e                	jle    800a32 <vprintfmt+0xe9>
  8009f4:	83 fb 39             	cmp    $0x39,%ebx
  8009f7:	7f 39                	jg     800a32 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009f9:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009fc:	eb d5                	jmp    8009d3 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8009fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800a01:	83 c0 04             	add    $0x4,%eax
  800a04:	89 45 14             	mov    %eax,0x14(%ebp)
  800a07:	8b 45 14             	mov    0x14(%ebp),%eax
  800a0a:	83 e8 04             	sub    $0x4,%eax
  800a0d:	8b 00                	mov    (%eax),%eax
  800a0f:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a12:	eb 1f                	jmp    800a33 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a14:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a18:	79 83                	jns    80099d <vprintfmt+0x54>
				width = 0;
  800a1a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a21:	e9 77 ff ff ff       	jmp    80099d <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a26:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a2d:	e9 6b ff ff ff       	jmp    80099d <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a32:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a33:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a37:	0f 89 60 ff ff ff    	jns    80099d <vprintfmt+0x54>
				width = precision, precision = -1;
  800a3d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a40:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a43:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a4a:	e9 4e ff ff ff       	jmp    80099d <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a4f:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a52:	e9 46 ff ff ff       	jmp    80099d <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a57:	8b 45 14             	mov    0x14(%ebp),%eax
  800a5a:	83 c0 04             	add    $0x4,%eax
  800a5d:	89 45 14             	mov    %eax,0x14(%ebp)
  800a60:	8b 45 14             	mov    0x14(%ebp),%eax
  800a63:	83 e8 04             	sub    $0x4,%eax
  800a66:	8b 00                	mov    (%eax),%eax
  800a68:	83 ec 08             	sub    $0x8,%esp
  800a6b:	ff 75 0c             	pushl  0xc(%ebp)
  800a6e:	50                   	push   %eax
  800a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a72:	ff d0                	call   *%eax
  800a74:	83 c4 10             	add    $0x10,%esp
			break;
  800a77:	e9 89 02 00 00       	jmp    800d05 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a7c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a7f:	83 c0 04             	add    $0x4,%eax
  800a82:	89 45 14             	mov    %eax,0x14(%ebp)
  800a85:	8b 45 14             	mov    0x14(%ebp),%eax
  800a88:	83 e8 04             	sub    $0x4,%eax
  800a8b:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a8d:	85 db                	test   %ebx,%ebx
  800a8f:	79 02                	jns    800a93 <vprintfmt+0x14a>
				err = -err;
  800a91:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a93:	83 fb 64             	cmp    $0x64,%ebx
  800a96:	7f 0b                	jg     800aa3 <vprintfmt+0x15a>
  800a98:	8b 34 9d 80 3d 80 00 	mov    0x803d80(,%ebx,4),%esi
  800a9f:	85 f6                	test   %esi,%esi
  800aa1:	75 19                	jne    800abc <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800aa3:	53                   	push   %ebx
  800aa4:	68 25 3f 80 00       	push   $0x803f25
  800aa9:	ff 75 0c             	pushl  0xc(%ebp)
  800aac:	ff 75 08             	pushl  0x8(%ebp)
  800aaf:	e8 5e 02 00 00       	call   800d12 <printfmt>
  800ab4:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ab7:	e9 49 02 00 00       	jmp    800d05 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800abc:	56                   	push   %esi
  800abd:	68 2e 3f 80 00       	push   $0x803f2e
  800ac2:	ff 75 0c             	pushl  0xc(%ebp)
  800ac5:	ff 75 08             	pushl  0x8(%ebp)
  800ac8:	e8 45 02 00 00       	call   800d12 <printfmt>
  800acd:	83 c4 10             	add    $0x10,%esp
			break;
  800ad0:	e9 30 02 00 00       	jmp    800d05 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800ad5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad8:	83 c0 04             	add    $0x4,%eax
  800adb:	89 45 14             	mov    %eax,0x14(%ebp)
  800ade:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae1:	83 e8 04             	sub    $0x4,%eax
  800ae4:	8b 30                	mov    (%eax),%esi
  800ae6:	85 f6                	test   %esi,%esi
  800ae8:	75 05                	jne    800aef <vprintfmt+0x1a6>
				p = "(null)";
  800aea:	be 31 3f 80 00       	mov    $0x803f31,%esi
			if (width > 0 && padc != '-')
  800aef:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800af3:	7e 6d                	jle    800b62 <vprintfmt+0x219>
  800af5:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800af9:	74 67                	je     800b62 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800afb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800afe:	83 ec 08             	sub    $0x8,%esp
  800b01:	50                   	push   %eax
  800b02:	56                   	push   %esi
  800b03:	e8 0c 03 00 00       	call   800e14 <strnlen>
  800b08:	83 c4 10             	add    $0x10,%esp
  800b0b:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b0e:	eb 16                	jmp    800b26 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b10:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b14:	83 ec 08             	sub    $0x8,%esp
  800b17:	ff 75 0c             	pushl  0xc(%ebp)
  800b1a:	50                   	push   %eax
  800b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1e:	ff d0                	call   *%eax
  800b20:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b23:	ff 4d e4             	decl   -0x1c(%ebp)
  800b26:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b2a:	7f e4                	jg     800b10 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b2c:	eb 34                	jmp    800b62 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b2e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b32:	74 1c                	je     800b50 <vprintfmt+0x207>
  800b34:	83 fb 1f             	cmp    $0x1f,%ebx
  800b37:	7e 05                	jle    800b3e <vprintfmt+0x1f5>
  800b39:	83 fb 7e             	cmp    $0x7e,%ebx
  800b3c:	7e 12                	jle    800b50 <vprintfmt+0x207>
					putch('?', putdat);
  800b3e:	83 ec 08             	sub    $0x8,%esp
  800b41:	ff 75 0c             	pushl  0xc(%ebp)
  800b44:	6a 3f                	push   $0x3f
  800b46:	8b 45 08             	mov    0x8(%ebp),%eax
  800b49:	ff d0                	call   *%eax
  800b4b:	83 c4 10             	add    $0x10,%esp
  800b4e:	eb 0f                	jmp    800b5f <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b50:	83 ec 08             	sub    $0x8,%esp
  800b53:	ff 75 0c             	pushl  0xc(%ebp)
  800b56:	53                   	push   %ebx
  800b57:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5a:	ff d0                	call   *%eax
  800b5c:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b5f:	ff 4d e4             	decl   -0x1c(%ebp)
  800b62:	89 f0                	mov    %esi,%eax
  800b64:	8d 70 01             	lea    0x1(%eax),%esi
  800b67:	8a 00                	mov    (%eax),%al
  800b69:	0f be d8             	movsbl %al,%ebx
  800b6c:	85 db                	test   %ebx,%ebx
  800b6e:	74 24                	je     800b94 <vprintfmt+0x24b>
  800b70:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b74:	78 b8                	js     800b2e <vprintfmt+0x1e5>
  800b76:	ff 4d e0             	decl   -0x20(%ebp)
  800b79:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b7d:	79 af                	jns    800b2e <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b7f:	eb 13                	jmp    800b94 <vprintfmt+0x24b>
				putch(' ', putdat);
  800b81:	83 ec 08             	sub    $0x8,%esp
  800b84:	ff 75 0c             	pushl  0xc(%ebp)
  800b87:	6a 20                	push   $0x20
  800b89:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8c:	ff d0                	call   *%eax
  800b8e:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b91:	ff 4d e4             	decl   -0x1c(%ebp)
  800b94:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b98:	7f e7                	jg     800b81 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800b9a:	e9 66 01 00 00       	jmp    800d05 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b9f:	83 ec 08             	sub    $0x8,%esp
  800ba2:	ff 75 e8             	pushl  -0x18(%ebp)
  800ba5:	8d 45 14             	lea    0x14(%ebp),%eax
  800ba8:	50                   	push   %eax
  800ba9:	e8 3c fd ff ff       	call   8008ea <getint>
  800bae:	83 c4 10             	add    $0x10,%esp
  800bb1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bb4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800bb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bbd:	85 d2                	test   %edx,%edx
  800bbf:	79 23                	jns    800be4 <vprintfmt+0x29b>
				putch('-', putdat);
  800bc1:	83 ec 08             	sub    $0x8,%esp
  800bc4:	ff 75 0c             	pushl  0xc(%ebp)
  800bc7:	6a 2d                	push   $0x2d
  800bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcc:	ff d0                	call   *%eax
  800bce:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800bd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bd4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bd7:	f7 d8                	neg    %eax
  800bd9:	83 d2 00             	adc    $0x0,%edx
  800bdc:	f7 da                	neg    %edx
  800bde:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800be1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800be4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800beb:	e9 bc 00 00 00       	jmp    800cac <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800bf0:	83 ec 08             	sub    $0x8,%esp
  800bf3:	ff 75 e8             	pushl  -0x18(%ebp)
  800bf6:	8d 45 14             	lea    0x14(%ebp),%eax
  800bf9:	50                   	push   %eax
  800bfa:	e8 84 fc ff ff       	call   800883 <getuint>
  800bff:	83 c4 10             	add    $0x10,%esp
  800c02:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c05:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c08:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c0f:	e9 98 00 00 00       	jmp    800cac <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c14:	83 ec 08             	sub    $0x8,%esp
  800c17:	ff 75 0c             	pushl  0xc(%ebp)
  800c1a:	6a 58                	push   $0x58
  800c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1f:	ff d0                	call   *%eax
  800c21:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c24:	83 ec 08             	sub    $0x8,%esp
  800c27:	ff 75 0c             	pushl  0xc(%ebp)
  800c2a:	6a 58                	push   $0x58
  800c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2f:	ff d0                	call   *%eax
  800c31:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c34:	83 ec 08             	sub    $0x8,%esp
  800c37:	ff 75 0c             	pushl  0xc(%ebp)
  800c3a:	6a 58                	push   $0x58
  800c3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3f:	ff d0                	call   *%eax
  800c41:	83 c4 10             	add    $0x10,%esp
			break;
  800c44:	e9 bc 00 00 00       	jmp    800d05 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800c49:	83 ec 08             	sub    $0x8,%esp
  800c4c:	ff 75 0c             	pushl  0xc(%ebp)
  800c4f:	6a 30                	push   $0x30
  800c51:	8b 45 08             	mov    0x8(%ebp),%eax
  800c54:	ff d0                	call   *%eax
  800c56:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c59:	83 ec 08             	sub    $0x8,%esp
  800c5c:	ff 75 0c             	pushl  0xc(%ebp)
  800c5f:	6a 78                	push   $0x78
  800c61:	8b 45 08             	mov    0x8(%ebp),%eax
  800c64:	ff d0                	call   *%eax
  800c66:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c69:	8b 45 14             	mov    0x14(%ebp),%eax
  800c6c:	83 c0 04             	add    $0x4,%eax
  800c6f:	89 45 14             	mov    %eax,0x14(%ebp)
  800c72:	8b 45 14             	mov    0x14(%ebp),%eax
  800c75:	83 e8 04             	sub    $0x4,%eax
  800c78:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c7d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c84:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c8b:	eb 1f                	jmp    800cac <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c8d:	83 ec 08             	sub    $0x8,%esp
  800c90:	ff 75 e8             	pushl  -0x18(%ebp)
  800c93:	8d 45 14             	lea    0x14(%ebp),%eax
  800c96:	50                   	push   %eax
  800c97:	e8 e7 fb ff ff       	call   800883 <getuint>
  800c9c:	83 c4 10             	add    $0x10,%esp
  800c9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ca2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800ca5:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cac:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800cb0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cb3:	83 ec 04             	sub    $0x4,%esp
  800cb6:	52                   	push   %edx
  800cb7:	ff 75 e4             	pushl  -0x1c(%ebp)
  800cba:	50                   	push   %eax
  800cbb:	ff 75 f4             	pushl  -0xc(%ebp)
  800cbe:	ff 75 f0             	pushl  -0x10(%ebp)
  800cc1:	ff 75 0c             	pushl  0xc(%ebp)
  800cc4:	ff 75 08             	pushl  0x8(%ebp)
  800cc7:	e8 00 fb ff ff       	call   8007cc <printnum>
  800ccc:	83 c4 20             	add    $0x20,%esp
			break;
  800ccf:	eb 34                	jmp    800d05 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800cd1:	83 ec 08             	sub    $0x8,%esp
  800cd4:	ff 75 0c             	pushl  0xc(%ebp)
  800cd7:	53                   	push   %ebx
  800cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdb:	ff d0                	call   *%eax
  800cdd:	83 c4 10             	add    $0x10,%esp
			break;
  800ce0:	eb 23                	jmp    800d05 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ce2:	83 ec 08             	sub    $0x8,%esp
  800ce5:	ff 75 0c             	pushl  0xc(%ebp)
  800ce8:	6a 25                	push   $0x25
  800cea:	8b 45 08             	mov    0x8(%ebp),%eax
  800ced:	ff d0                	call   *%eax
  800cef:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800cf2:	ff 4d 10             	decl   0x10(%ebp)
  800cf5:	eb 03                	jmp    800cfa <vprintfmt+0x3b1>
  800cf7:	ff 4d 10             	decl   0x10(%ebp)
  800cfa:	8b 45 10             	mov    0x10(%ebp),%eax
  800cfd:	48                   	dec    %eax
  800cfe:	8a 00                	mov    (%eax),%al
  800d00:	3c 25                	cmp    $0x25,%al
  800d02:	75 f3                	jne    800cf7 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800d04:	90                   	nop
		}
	}
  800d05:	e9 47 fc ff ff       	jmp    800951 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d0a:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d0b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d0e:	5b                   	pop    %ebx
  800d0f:	5e                   	pop    %esi
  800d10:	5d                   	pop    %ebp
  800d11:	c3                   	ret    

00800d12 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d12:	55                   	push   %ebp
  800d13:	89 e5                	mov    %esp,%ebp
  800d15:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d18:	8d 45 10             	lea    0x10(%ebp),%eax
  800d1b:	83 c0 04             	add    $0x4,%eax
  800d1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d21:	8b 45 10             	mov    0x10(%ebp),%eax
  800d24:	ff 75 f4             	pushl  -0xc(%ebp)
  800d27:	50                   	push   %eax
  800d28:	ff 75 0c             	pushl  0xc(%ebp)
  800d2b:	ff 75 08             	pushl  0x8(%ebp)
  800d2e:	e8 16 fc ff ff       	call   800949 <vprintfmt>
  800d33:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d36:	90                   	nop
  800d37:	c9                   	leave  
  800d38:	c3                   	ret    

00800d39 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d39:	55                   	push   %ebp
  800d3a:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3f:	8b 40 08             	mov    0x8(%eax),%eax
  800d42:	8d 50 01             	lea    0x1(%eax),%edx
  800d45:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d48:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d4e:	8b 10                	mov    (%eax),%edx
  800d50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d53:	8b 40 04             	mov    0x4(%eax),%eax
  800d56:	39 c2                	cmp    %eax,%edx
  800d58:	73 12                	jae    800d6c <sprintputch+0x33>
		*b->buf++ = ch;
  800d5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5d:	8b 00                	mov    (%eax),%eax
  800d5f:	8d 48 01             	lea    0x1(%eax),%ecx
  800d62:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d65:	89 0a                	mov    %ecx,(%edx)
  800d67:	8b 55 08             	mov    0x8(%ebp),%edx
  800d6a:	88 10                	mov    %dl,(%eax)
}
  800d6c:	90                   	nop
  800d6d:	5d                   	pop    %ebp
  800d6e:	c3                   	ret    

00800d6f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d6f:	55                   	push   %ebp
  800d70:	89 e5                	mov    %esp,%ebp
  800d72:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d75:	8b 45 08             	mov    0x8(%ebp),%eax
  800d78:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d7e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d81:	8b 45 08             	mov    0x8(%ebp),%eax
  800d84:	01 d0                	add    %edx,%eax
  800d86:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d89:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d90:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d94:	74 06                	je     800d9c <vsnprintf+0x2d>
  800d96:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d9a:	7f 07                	jg     800da3 <vsnprintf+0x34>
		return -E_INVAL;
  800d9c:	b8 03 00 00 00       	mov    $0x3,%eax
  800da1:	eb 20                	jmp    800dc3 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800da3:	ff 75 14             	pushl  0x14(%ebp)
  800da6:	ff 75 10             	pushl  0x10(%ebp)
  800da9:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800dac:	50                   	push   %eax
  800dad:	68 39 0d 80 00       	push   $0x800d39
  800db2:	e8 92 fb ff ff       	call   800949 <vprintfmt>
  800db7:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800dba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800dbd:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800dc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800dc3:	c9                   	leave  
  800dc4:	c3                   	ret    

00800dc5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800dc5:	55                   	push   %ebp
  800dc6:	89 e5                	mov    %esp,%ebp
  800dc8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800dcb:	8d 45 10             	lea    0x10(%ebp),%eax
  800dce:	83 c0 04             	add    $0x4,%eax
  800dd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800dd4:	8b 45 10             	mov    0x10(%ebp),%eax
  800dd7:	ff 75 f4             	pushl  -0xc(%ebp)
  800dda:	50                   	push   %eax
  800ddb:	ff 75 0c             	pushl  0xc(%ebp)
  800dde:	ff 75 08             	pushl  0x8(%ebp)
  800de1:	e8 89 ff ff ff       	call   800d6f <vsnprintf>
  800de6:	83 c4 10             	add    $0x10,%esp
  800de9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800dec:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800def:	c9                   	leave  
  800df0:	c3                   	ret    

00800df1 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800df1:	55                   	push   %ebp
  800df2:	89 e5                	mov    %esp,%ebp
  800df4:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800df7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dfe:	eb 06                	jmp    800e06 <strlen+0x15>
		n++;
  800e00:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e03:	ff 45 08             	incl   0x8(%ebp)
  800e06:	8b 45 08             	mov    0x8(%ebp),%eax
  800e09:	8a 00                	mov    (%eax),%al
  800e0b:	84 c0                	test   %al,%al
  800e0d:	75 f1                	jne    800e00 <strlen+0xf>
		n++;
	return n;
  800e0f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e12:	c9                   	leave  
  800e13:	c3                   	ret    

00800e14 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e14:	55                   	push   %ebp
  800e15:	89 e5                	mov    %esp,%ebp
  800e17:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e1a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e21:	eb 09                	jmp    800e2c <strnlen+0x18>
		n++;
  800e23:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e26:	ff 45 08             	incl   0x8(%ebp)
  800e29:	ff 4d 0c             	decl   0xc(%ebp)
  800e2c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e30:	74 09                	je     800e3b <strnlen+0x27>
  800e32:	8b 45 08             	mov    0x8(%ebp),%eax
  800e35:	8a 00                	mov    (%eax),%al
  800e37:	84 c0                	test   %al,%al
  800e39:	75 e8                	jne    800e23 <strnlen+0xf>
		n++;
	return n;
  800e3b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e3e:	c9                   	leave  
  800e3f:	c3                   	ret    

00800e40 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e40:	55                   	push   %ebp
  800e41:	89 e5                	mov    %esp,%ebp
  800e43:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e46:	8b 45 08             	mov    0x8(%ebp),%eax
  800e49:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e4c:	90                   	nop
  800e4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e50:	8d 50 01             	lea    0x1(%eax),%edx
  800e53:	89 55 08             	mov    %edx,0x8(%ebp)
  800e56:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e59:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e5c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e5f:	8a 12                	mov    (%edx),%dl
  800e61:	88 10                	mov    %dl,(%eax)
  800e63:	8a 00                	mov    (%eax),%al
  800e65:	84 c0                	test   %al,%al
  800e67:	75 e4                	jne    800e4d <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e69:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e6c:	c9                   	leave  
  800e6d:	c3                   	ret    

00800e6e <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e6e:	55                   	push   %ebp
  800e6f:	89 e5                	mov    %esp,%ebp
  800e71:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e74:	8b 45 08             	mov    0x8(%ebp),%eax
  800e77:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e7a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e81:	eb 1f                	jmp    800ea2 <strncpy+0x34>
		*dst++ = *src;
  800e83:	8b 45 08             	mov    0x8(%ebp),%eax
  800e86:	8d 50 01             	lea    0x1(%eax),%edx
  800e89:	89 55 08             	mov    %edx,0x8(%ebp)
  800e8c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e8f:	8a 12                	mov    (%edx),%dl
  800e91:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800e93:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e96:	8a 00                	mov    (%eax),%al
  800e98:	84 c0                	test   %al,%al
  800e9a:	74 03                	je     800e9f <strncpy+0x31>
			src++;
  800e9c:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e9f:	ff 45 fc             	incl   -0x4(%ebp)
  800ea2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ea5:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ea8:	72 d9                	jb     800e83 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800eaa:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ead:	c9                   	leave  
  800eae:	c3                   	ret    

00800eaf <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800eaf:	55                   	push   %ebp
  800eb0:	89 e5                	mov    %esp,%ebp
  800eb2:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ebb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ebf:	74 30                	je     800ef1 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ec1:	eb 16                	jmp    800ed9 <strlcpy+0x2a>
			*dst++ = *src++;
  800ec3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec6:	8d 50 01             	lea    0x1(%eax),%edx
  800ec9:	89 55 08             	mov    %edx,0x8(%ebp)
  800ecc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ecf:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ed2:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ed5:	8a 12                	mov    (%edx),%dl
  800ed7:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ed9:	ff 4d 10             	decl   0x10(%ebp)
  800edc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ee0:	74 09                	je     800eeb <strlcpy+0x3c>
  800ee2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee5:	8a 00                	mov    (%eax),%al
  800ee7:	84 c0                	test   %al,%al
  800ee9:	75 d8                	jne    800ec3 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800eeb:	8b 45 08             	mov    0x8(%ebp),%eax
  800eee:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ef1:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ef7:	29 c2                	sub    %eax,%edx
  800ef9:	89 d0                	mov    %edx,%eax
}
  800efb:	c9                   	leave  
  800efc:	c3                   	ret    

00800efd <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800efd:	55                   	push   %ebp
  800efe:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f00:	eb 06                	jmp    800f08 <strcmp+0xb>
		p++, q++;
  800f02:	ff 45 08             	incl   0x8(%ebp)
  800f05:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f08:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0b:	8a 00                	mov    (%eax),%al
  800f0d:	84 c0                	test   %al,%al
  800f0f:	74 0e                	je     800f1f <strcmp+0x22>
  800f11:	8b 45 08             	mov    0x8(%ebp),%eax
  800f14:	8a 10                	mov    (%eax),%dl
  800f16:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f19:	8a 00                	mov    (%eax),%al
  800f1b:	38 c2                	cmp    %al,%dl
  800f1d:	74 e3                	je     800f02 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f22:	8a 00                	mov    (%eax),%al
  800f24:	0f b6 d0             	movzbl %al,%edx
  800f27:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2a:	8a 00                	mov    (%eax),%al
  800f2c:	0f b6 c0             	movzbl %al,%eax
  800f2f:	29 c2                	sub    %eax,%edx
  800f31:	89 d0                	mov    %edx,%eax
}
  800f33:	5d                   	pop    %ebp
  800f34:	c3                   	ret    

00800f35 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f35:	55                   	push   %ebp
  800f36:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f38:	eb 09                	jmp    800f43 <strncmp+0xe>
		n--, p++, q++;
  800f3a:	ff 4d 10             	decl   0x10(%ebp)
  800f3d:	ff 45 08             	incl   0x8(%ebp)
  800f40:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f43:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f47:	74 17                	je     800f60 <strncmp+0x2b>
  800f49:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4c:	8a 00                	mov    (%eax),%al
  800f4e:	84 c0                	test   %al,%al
  800f50:	74 0e                	je     800f60 <strncmp+0x2b>
  800f52:	8b 45 08             	mov    0x8(%ebp),%eax
  800f55:	8a 10                	mov    (%eax),%dl
  800f57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f5a:	8a 00                	mov    (%eax),%al
  800f5c:	38 c2                	cmp    %al,%dl
  800f5e:	74 da                	je     800f3a <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f60:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f64:	75 07                	jne    800f6d <strncmp+0x38>
		return 0;
  800f66:	b8 00 00 00 00       	mov    $0x0,%eax
  800f6b:	eb 14                	jmp    800f81 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f70:	8a 00                	mov    (%eax),%al
  800f72:	0f b6 d0             	movzbl %al,%edx
  800f75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f78:	8a 00                	mov    (%eax),%al
  800f7a:	0f b6 c0             	movzbl %al,%eax
  800f7d:	29 c2                	sub    %eax,%edx
  800f7f:	89 d0                	mov    %edx,%eax
}
  800f81:	5d                   	pop    %ebp
  800f82:	c3                   	ret    

00800f83 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f83:	55                   	push   %ebp
  800f84:	89 e5                	mov    %esp,%ebp
  800f86:	83 ec 04             	sub    $0x4,%esp
  800f89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f8c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f8f:	eb 12                	jmp    800fa3 <strchr+0x20>
		if (*s == c)
  800f91:	8b 45 08             	mov    0x8(%ebp),%eax
  800f94:	8a 00                	mov    (%eax),%al
  800f96:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f99:	75 05                	jne    800fa0 <strchr+0x1d>
			return (char *) s;
  800f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9e:	eb 11                	jmp    800fb1 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800fa0:	ff 45 08             	incl   0x8(%ebp)
  800fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa6:	8a 00                	mov    (%eax),%al
  800fa8:	84 c0                	test   %al,%al
  800faa:	75 e5                	jne    800f91 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800fac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fb1:	c9                   	leave  
  800fb2:	c3                   	ret    

00800fb3 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800fb3:	55                   	push   %ebp
  800fb4:	89 e5                	mov    %esp,%ebp
  800fb6:	83 ec 04             	sub    $0x4,%esp
  800fb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fbc:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fbf:	eb 0d                	jmp    800fce <strfind+0x1b>
		if (*s == c)
  800fc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc4:	8a 00                	mov    (%eax),%al
  800fc6:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fc9:	74 0e                	je     800fd9 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800fcb:	ff 45 08             	incl   0x8(%ebp)
  800fce:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd1:	8a 00                	mov    (%eax),%al
  800fd3:	84 c0                	test   %al,%al
  800fd5:	75 ea                	jne    800fc1 <strfind+0xe>
  800fd7:	eb 01                	jmp    800fda <strfind+0x27>
		if (*s == c)
			break;
  800fd9:	90                   	nop
	return (char *) s;
  800fda:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fdd:	c9                   	leave  
  800fde:	c3                   	ret    

00800fdf <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800fdf:	55                   	push   %ebp
  800fe0:	89 e5                	mov    %esp,%ebp
  800fe2:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800feb:	8b 45 10             	mov    0x10(%ebp),%eax
  800fee:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800ff1:	eb 0e                	jmp    801001 <memset+0x22>
		*p++ = c;
  800ff3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ff6:	8d 50 01             	lea    0x1(%eax),%edx
  800ff9:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800ffc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fff:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801001:	ff 4d f8             	decl   -0x8(%ebp)
  801004:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801008:	79 e9                	jns    800ff3 <memset+0x14>
		*p++ = c;

	return v;
  80100a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80100d:	c9                   	leave  
  80100e:	c3                   	ret    

0080100f <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80100f:	55                   	push   %ebp
  801010:	89 e5                	mov    %esp,%ebp
  801012:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801015:	8b 45 0c             	mov    0xc(%ebp),%eax
  801018:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80101b:	8b 45 08             	mov    0x8(%ebp),%eax
  80101e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801021:	eb 16                	jmp    801039 <memcpy+0x2a>
		*d++ = *s++;
  801023:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801026:	8d 50 01             	lea    0x1(%eax),%edx
  801029:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80102c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80102f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801032:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801035:	8a 12                	mov    (%edx),%dl
  801037:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801039:	8b 45 10             	mov    0x10(%ebp),%eax
  80103c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80103f:	89 55 10             	mov    %edx,0x10(%ebp)
  801042:	85 c0                	test   %eax,%eax
  801044:	75 dd                	jne    801023 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801046:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801049:	c9                   	leave  
  80104a:	c3                   	ret    

0080104b <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80104b:	55                   	push   %ebp
  80104c:	89 e5                	mov    %esp,%ebp
  80104e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801051:	8b 45 0c             	mov    0xc(%ebp),%eax
  801054:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801057:	8b 45 08             	mov    0x8(%ebp),%eax
  80105a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80105d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801060:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801063:	73 50                	jae    8010b5 <memmove+0x6a>
  801065:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801068:	8b 45 10             	mov    0x10(%ebp),%eax
  80106b:	01 d0                	add    %edx,%eax
  80106d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801070:	76 43                	jbe    8010b5 <memmove+0x6a>
		s += n;
  801072:	8b 45 10             	mov    0x10(%ebp),%eax
  801075:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801078:	8b 45 10             	mov    0x10(%ebp),%eax
  80107b:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80107e:	eb 10                	jmp    801090 <memmove+0x45>
			*--d = *--s;
  801080:	ff 4d f8             	decl   -0x8(%ebp)
  801083:	ff 4d fc             	decl   -0x4(%ebp)
  801086:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801089:	8a 10                	mov    (%eax),%dl
  80108b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80108e:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801090:	8b 45 10             	mov    0x10(%ebp),%eax
  801093:	8d 50 ff             	lea    -0x1(%eax),%edx
  801096:	89 55 10             	mov    %edx,0x10(%ebp)
  801099:	85 c0                	test   %eax,%eax
  80109b:	75 e3                	jne    801080 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80109d:	eb 23                	jmp    8010c2 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80109f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010a2:	8d 50 01             	lea    0x1(%eax),%edx
  8010a5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010a8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010ab:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010ae:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010b1:	8a 12                	mov    (%edx),%dl
  8010b3:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8010b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010bb:	89 55 10             	mov    %edx,0x10(%ebp)
  8010be:	85 c0                	test   %eax,%eax
  8010c0:	75 dd                	jne    80109f <memmove+0x54>
			*d++ = *s++;

	return dst;
  8010c2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010c5:	c9                   	leave  
  8010c6:	c3                   	ret    

008010c7 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8010c7:	55                   	push   %ebp
  8010c8:	89 e5                	mov    %esp,%ebp
  8010ca:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8010cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8010d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d6:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8010d9:	eb 2a                	jmp    801105 <memcmp+0x3e>
		if (*s1 != *s2)
  8010db:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010de:	8a 10                	mov    (%eax),%dl
  8010e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010e3:	8a 00                	mov    (%eax),%al
  8010e5:	38 c2                	cmp    %al,%dl
  8010e7:	74 16                	je     8010ff <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8010e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ec:	8a 00                	mov    (%eax),%al
  8010ee:	0f b6 d0             	movzbl %al,%edx
  8010f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010f4:	8a 00                	mov    (%eax),%al
  8010f6:	0f b6 c0             	movzbl %al,%eax
  8010f9:	29 c2                	sub    %eax,%edx
  8010fb:	89 d0                	mov    %edx,%eax
  8010fd:	eb 18                	jmp    801117 <memcmp+0x50>
		s1++, s2++;
  8010ff:	ff 45 fc             	incl   -0x4(%ebp)
  801102:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801105:	8b 45 10             	mov    0x10(%ebp),%eax
  801108:	8d 50 ff             	lea    -0x1(%eax),%edx
  80110b:	89 55 10             	mov    %edx,0x10(%ebp)
  80110e:	85 c0                	test   %eax,%eax
  801110:	75 c9                	jne    8010db <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801112:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801117:	c9                   	leave  
  801118:	c3                   	ret    

00801119 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801119:	55                   	push   %ebp
  80111a:	89 e5                	mov    %esp,%ebp
  80111c:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80111f:	8b 55 08             	mov    0x8(%ebp),%edx
  801122:	8b 45 10             	mov    0x10(%ebp),%eax
  801125:	01 d0                	add    %edx,%eax
  801127:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80112a:	eb 15                	jmp    801141 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80112c:	8b 45 08             	mov    0x8(%ebp),%eax
  80112f:	8a 00                	mov    (%eax),%al
  801131:	0f b6 d0             	movzbl %al,%edx
  801134:	8b 45 0c             	mov    0xc(%ebp),%eax
  801137:	0f b6 c0             	movzbl %al,%eax
  80113a:	39 c2                	cmp    %eax,%edx
  80113c:	74 0d                	je     80114b <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80113e:	ff 45 08             	incl   0x8(%ebp)
  801141:	8b 45 08             	mov    0x8(%ebp),%eax
  801144:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801147:	72 e3                	jb     80112c <memfind+0x13>
  801149:	eb 01                	jmp    80114c <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80114b:	90                   	nop
	return (void *) s;
  80114c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80114f:	c9                   	leave  
  801150:	c3                   	ret    

00801151 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801151:	55                   	push   %ebp
  801152:	89 e5                	mov    %esp,%ebp
  801154:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801157:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80115e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801165:	eb 03                	jmp    80116a <strtol+0x19>
		s++;
  801167:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80116a:	8b 45 08             	mov    0x8(%ebp),%eax
  80116d:	8a 00                	mov    (%eax),%al
  80116f:	3c 20                	cmp    $0x20,%al
  801171:	74 f4                	je     801167 <strtol+0x16>
  801173:	8b 45 08             	mov    0x8(%ebp),%eax
  801176:	8a 00                	mov    (%eax),%al
  801178:	3c 09                	cmp    $0x9,%al
  80117a:	74 eb                	je     801167 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80117c:	8b 45 08             	mov    0x8(%ebp),%eax
  80117f:	8a 00                	mov    (%eax),%al
  801181:	3c 2b                	cmp    $0x2b,%al
  801183:	75 05                	jne    80118a <strtol+0x39>
		s++;
  801185:	ff 45 08             	incl   0x8(%ebp)
  801188:	eb 13                	jmp    80119d <strtol+0x4c>
	else if (*s == '-')
  80118a:	8b 45 08             	mov    0x8(%ebp),%eax
  80118d:	8a 00                	mov    (%eax),%al
  80118f:	3c 2d                	cmp    $0x2d,%al
  801191:	75 0a                	jne    80119d <strtol+0x4c>
		s++, neg = 1;
  801193:	ff 45 08             	incl   0x8(%ebp)
  801196:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80119d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011a1:	74 06                	je     8011a9 <strtol+0x58>
  8011a3:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8011a7:	75 20                	jne    8011c9 <strtol+0x78>
  8011a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ac:	8a 00                	mov    (%eax),%al
  8011ae:	3c 30                	cmp    $0x30,%al
  8011b0:	75 17                	jne    8011c9 <strtol+0x78>
  8011b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b5:	40                   	inc    %eax
  8011b6:	8a 00                	mov    (%eax),%al
  8011b8:	3c 78                	cmp    $0x78,%al
  8011ba:	75 0d                	jne    8011c9 <strtol+0x78>
		s += 2, base = 16;
  8011bc:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8011c0:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8011c7:	eb 28                	jmp    8011f1 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8011c9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011cd:	75 15                	jne    8011e4 <strtol+0x93>
  8011cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d2:	8a 00                	mov    (%eax),%al
  8011d4:	3c 30                	cmp    $0x30,%al
  8011d6:	75 0c                	jne    8011e4 <strtol+0x93>
		s++, base = 8;
  8011d8:	ff 45 08             	incl   0x8(%ebp)
  8011db:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8011e2:	eb 0d                	jmp    8011f1 <strtol+0xa0>
	else if (base == 0)
  8011e4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011e8:	75 07                	jne    8011f1 <strtol+0xa0>
		base = 10;
  8011ea:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8011f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f4:	8a 00                	mov    (%eax),%al
  8011f6:	3c 2f                	cmp    $0x2f,%al
  8011f8:	7e 19                	jle    801213 <strtol+0xc2>
  8011fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fd:	8a 00                	mov    (%eax),%al
  8011ff:	3c 39                	cmp    $0x39,%al
  801201:	7f 10                	jg     801213 <strtol+0xc2>
			dig = *s - '0';
  801203:	8b 45 08             	mov    0x8(%ebp),%eax
  801206:	8a 00                	mov    (%eax),%al
  801208:	0f be c0             	movsbl %al,%eax
  80120b:	83 e8 30             	sub    $0x30,%eax
  80120e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801211:	eb 42                	jmp    801255 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801213:	8b 45 08             	mov    0x8(%ebp),%eax
  801216:	8a 00                	mov    (%eax),%al
  801218:	3c 60                	cmp    $0x60,%al
  80121a:	7e 19                	jle    801235 <strtol+0xe4>
  80121c:	8b 45 08             	mov    0x8(%ebp),%eax
  80121f:	8a 00                	mov    (%eax),%al
  801221:	3c 7a                	cmp    $0x7a,%al
  801223:	7f 10                	jg     801235 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801225:	8b 45 08             	mov    0x8(%ebp),%eax
  801228:	8a 00                	mov    (%eax),%al
  80122a:	0f be c0             	movsbl %al,%eax
  80122d:	83 e8 57             	sub    $0x57,%eax
  801230:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801233:	eb 20                	jmp    801255 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801235:	8b 45 08             	mov    0x8(%ebp),%eax
  801238:	8a 00                	mov    (%eax),%al
  80123a:	3c 40                	cmp    $0x40,%al
  80123c:	7e 39                	jle    801277 <strtol+0x126>
  80123e:	8b 45 08             	mov    0x8(%ebp),%eax
  801241:	8a 00                	mov    (%eax),%al
  801243:	3c 5a                	cmp    $0x5a,%al
  801245:	7f 30                	jg     801277 <strtol+0x126>
			dig = *s - 'A' + 10;
  801247:	8b 45 08             	mov    0x8(%ebp),%eax
  80124a:	8a 00                	mov    (%eax),%al
  80124c:	0f be c0             	movsbl %al,%eax
  80124f:	83 e8 37             	sub    $0x37,%eax
  801252:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801255:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801258:	3b 45 10             	cmp    0x10(%ebp),%eax
  80125b:	7d 19                	jge    801276 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80125d:	ff 45 08             	incl   0x8(%ebp)
  801260:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801263:	0f af 45 10          	imul   0x10(%ebp),%eax
  801267:	89 c2                	mov    %eax,%edx
  801269:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80126c:	01 d0                	add    %edx,%eax
  80126e:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801271:	e9 7b ff ff ff       	jmp    8011f1 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801276:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801277:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80127b:	74 08                	je     801285 <strtol+0x134>
		*endptr = (char *) s;
  80127d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801280:	8b 55 08             	mov    0x8(%ebp),%edx
  801283:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801285:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801289:	74 07                	je     801292 <strtol+0x141>
  80128b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80128e:	f7 d8                	neg    %eax
  801290:	eb 03                	jmp    801295 <strtol+0x144>
  801292:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801295:	c9                   	leave  
  801296:	c3                   	ret    

00801297 <ltostr>:

void
ltostr(long value, char *str)
{
  801297:	55                   	push   %ebp
  801298:	89 e5                	mov    %esp,%ebp
  80129a:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80129d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8012a4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8012ab:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012af:	79 13                	jns    8012c4 <ltostr+0x2d>
	{
		neg = 1;
  8012b1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8012b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012bb:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8012be:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8012c1:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8012c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c7:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8012cc:	99                   	cltd   
  8012cd:	f7 f9                	idiv   %ecx
  8012cf:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8012d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012d5:	8d 50 01             	lea    0x1(%eax),%edx
  8012d8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012db:	89 c2                	mov    %eax,%edx
  8012dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e0:	01 d0                	add    %edx,%eax
  8012e2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012e5:	83 c2 30             	add    $0x30,%edx
  8012e8:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8012ea:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012ed:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012f2:	f7 e9                	imul   %ecx
  8012f4:	c1 fa 02             	sar    $0x2,%edx
  8012f7:	89 c8                	mov    %ecx,%eax
  8012f9:	c1 f8 1f             	sar    $0x1f,%eax
  8012fc:	29 c2                	sub    %eax,%edx
  8012fe:	89 d0                	mov    %edx,%eax
  801300:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801303:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801306:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80130b:	f7 e9                	imul   %ecx
  80130d:	c1 fa 02             	sar    $0x2,%edx
  801310:	89 c8                	mov    %ecx,%eax
  801312:	c1 f8 1f             	sar    $0x1f,%eax
  801315:	29 c2                	sub    %eax,%edx
  801317:	89 d0                	mov    %edx,%eax
  801319:	c1 e0 02             	shl    $0x2,%eax
  80131c:	01 d0                	add    %edx,%eax
  80131e:	01 c0                	add    %eax,%eax
  801320:	29 c1                	sub    %eax,%ecx
  801322:	89 ca                	mov    %ecx,%edx
  801324:	85 d2                	test   %edx,%edx
  801326:	75 9c                	jne    8012c4 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801328:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80132f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801332:	48                   	dec    %eax
  801333:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801336:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80133a:	74 3d                	je     801379 <ltostr+0xe2>
		start = 1 ;
  80133c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801343:	eb 34                	jmp    801379 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801345:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801348:	8b 45 0c             	mov    0xc(%ebp),%eax
  80134b:	01 d0                	add    %edx,%eax
  80134d:	8a 00                	mov    (%eax),%al
  80134f:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801352:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801355:	8b 45 0c             	mov    0xc(%ebp),%eax
  801358:	01 c2                	add    %eax,%edx
  80135a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80135d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801360:	01 c8                	add    %ecx,%eax
  801362:	8a 00                	mov    (%eax),%al
  801364:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801366:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801369:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136c:	01 c2                	add    %eax,%edx
  80136e:	8a 45 eb             	mov    -0x15(%ebp),%al
  801371:	88 02                	mov    %al,(%edx)
		start++ ;
  801373:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801376:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801379:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80137c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80137f:	7c c4                	jl     801345 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801381:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801384:	8b 45 0c             	mov    0xc(%ebp),%eax
  801387:	01 d0                	add    %edx,%eax
  801389:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80138c:	90                   	nop
  80138d:	c9                   	leave  
  80138e:	c3                   	ret    

0080138f <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80138f:	55                   	push   %ebp
  801390:	89 e5                	mov    %esp,%ebp
  801392:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801395:	ff 75 08             	pushl  0x8(%ebp)
  801398:	e8 54 fa ff ff       	call   800df1 <strlen>
  80139d:	83 c4 04             	add    $0x4,%esp
  8013a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8013a3:	ff 75 0c             	pushl  0xc(%ebp)
  8013a6:	e8 46 fa ff ff       	call   800df1 <strlen>
  8013ab:	83 c4 04             	add    $0x4,%esp
  8013ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8013b1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8013b8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013bf:	eb 17                	jmp    8013d8 <strcconcat+0x49>
		final[s] = str1[s] ;
  8013c1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8013c7:	01 c2                	add    %eax,%edx
  8013c9:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cf:	01 c8                	add    %ecx,%eax
  8013d1:	8a 00                	mov    (%eax),%al
  8013d3:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8013d5:	ff 45 fc             	incl   -0x4(%ebp)
  8013d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013db:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8013de:	7c e1                	jl     8013c1 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8013e0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8013e7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8013ee:	eb 1f                	jmp    80140f <strcconcat+0x80>
		final[s++] = str2[i] ;
  8013f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013f3:	8d 50 01             	lea    0x1(%eax),%edx
  8013f6:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8013f9:	89 c2                	mov    %eax,%edx
  8013fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8013fe:	01 c2                	add    %eax,%edx
  801400:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801403:	8b 45 0c             	mov    0xc(%ebp),%eax
  801406:	01 c8                	add    %ecx,%eax
  801408:	8a 00                	mov    (%eax),%al
  80140a:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80140c:	ff 45 f8             	incl   -0x8(%ebp)
  80140f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801412:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801415:	7c d9                	jl     8013f0 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801417:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80141a:	8b 45 10             	mov    0x10(%ebp),%eax
  80141d:	01 d0                	add    %edx,%eax
  80141f:	c6 00 00             	movb   $0x0,(%eax)
}
  801422:	90                   	nop
  801423:	c9                   	leave  
  801424:	c3                   	ret    

00801425 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801425:	55                   	push   %ebp
  801426:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801428:	8b 45 14             	mov    0x14(%ebp),%eax
  80142b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801431:	8b 45 14             	mov    0x14(%ebp),%eax
  801434:	8b 00                	mov    (%eax),%eax
  801436:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80143d:	8b 45 10             	mov    0x10(%ebp),%eax
  801440:	01 d0                	add    %edx,%eax
  801442:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801448:	eb 0c                	jmp    801456 <strsplit+0x31>
			*string++ = 0;
  80144a:	8b 45 08             	mov    0x8(%ebp),%eax
  80144d:	8d 50 01             	lea    0x1(%eax),%edx
  801450:	89 55 08             	mov    %edx,0x8(%ebp)
  801453:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801456:	8b 45 08             	mov    0x8(%ebp),%eax
  801459:	8a 00                	mov    (%eax),%al
  80145b:	84 c0                	test   %al,%al
  80145d:	74 18                	je     801477 <strsplit+0x52>
  80145f:	8b 45 08             	mov    0x8(%ebp),%eax
  801462:	8a 00                	mov    (%eax),%al
  801464:	0f be c0             	movsbl %al,%eax
  801467:	50                   	push   %eax
  801468:	ff 75 0c             	pushl  0xc(%ebp)
  80146b:	e8 13 fb ff ff       	call   800f83 <strchr>
  801470:	83 c4 08             	add    $0x8,%esp
  801473:	85 c0                	test   %eax,%eax
  801475:	75 d3                	jne    80144a <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801477:	8b 45 08             	mov    0x8(%ebp),%eax
  80147a:	8a 00                	mov    (%eax),%al
  80147c:	84 c0                	test   %al,%al
  80147e:	74 5a                	je     8014da <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801480:	8b 45 14             	mov    0x14(%ebp),%eax
  801483:	8b 00                	mov    (%eax),%eax
  801485:	83 f8 0f             	cmp    $0xf,%eax
  801488:	75 07                	jne    801491 <strsplit+0x6c>
		{
			return 0;
  80148a:	b8 00 00 00 00       	mov    $0x0,%eax
  80148f:	eb 66                	jmp    8014f7 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801491:	8b 45 14             	mov    0x14(%ebp),%eax
  801494:	8b 00                	mov    (%eax),%eax
  801496:	8d 48 01             	lea    0x1(%eax),%ecx
  801499:	8b 55 14             	mov    0x14(%ebp),%edx
  80149c:	89 0a                	mov    %ecx,(%edx)
  80149e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8014a8:	01 c2                	add    %eax,%edx
  8014aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ad:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014af:	eb 03                	jmp    8014b4 <strsplit+0x8f>
			string++;
  8014b1:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b7:	8a 00                	mov    (%eax),%al
  8014b9:	84 c0                	test   %al,%al
  8014bb:	74 8b                	je     801448 <strsplit+0x23>
  8014bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c0:	8a 00                	mov    (%eax),%al
  8014c2:	0f be c0             	movsbl %al,%eax
  8014c5:	50                   	push   %eax
  8014c6:	ff 75 0c             	pushl  0xc(%ebp)
  8014c9:	e8 b5 fa ff ff       	call   800f83 <strchr>
  8014ce:	83 c4 08             	add    $0x8,%esp
  8014d1:	85 c0                	test   %eax,%eax
  8014d3:	74 dc                	je     8014b1 <strsplit+0x8c>
			string++;
	}
  8014d5:	e9 6e ff ff ff       	jmp    801448 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8014da:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8014db:	8b 45 14             	mov    0x14(%ebp),%eax
  8014de:	8b 00                	mov    (%eax),%eax
  8014e0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ea:	01 d0                	add    %edx,%eax
  8014ec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8014f2:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8014f7:	c9                   	leave  
  8014f8:	c3                   	ret    

008014f9 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8014f9:	55                   	push   %ebp
  8014fa:	89 e5                	mov    %esp,%ebp
  8014fc:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8014ff:	a1 04 50 80 00       	mov    0x805004,%eax
  801504:	85 c0                	test   %eax,%eax
  801506:	74 1f                	je     801527 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801508:	e8 1d 00 00 00       	call   80152a <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  80150d:	83 ec 0c             	sub    $0xc,%esp
  801510:	68 90 40 80 00       	push   $0x804090
  801515:	e8 55 f2 ff ff       	call   80076f <cprintf>
  80151a:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80151d:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801524:	00 00 00 
	}
}
  801527:	90                   	nop
  801528:	c9                   	leave  
  801529:	c3                   	ret    

0080152a <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80152a:	55                   	push   %ebp
  80152b:	89 e5                	mov    %esp,%ebp
  80152d:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	LIST_INIT(&AllocMemBlocksList);
  801530:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801537:	00 00 00 
  80153a:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801541:	00 00 00 
  801544:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  80154b:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  80154e:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801555:	00 00 00 
  801558:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  80155f:	00 00 00 
  801562:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801569:	00 00 00 
	uint32 arr_size = 0;
  80156c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	MemBlockNodes  =(struct MemBlock*) USER_DYN_BLKS_ARRAY;
  801573:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  80157a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80157d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801582:	2d 00 10 00 00       	sub    $0x1000,%eax
  801587:	a3 50 50 80 00       	mov    %eax,0x805050
	MAX_MEM_BLOCK_CNT = (USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE;
  80158c:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801593:	00 02 00 
	arr_size =  ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock), PAGE_SIZE);
  801596:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80159d:	a1 20 51 80 00       	mov    0x805120,%eax
  8015a2:	c1 e0 04             	shl    $0x4,%eax
  8015a5:	89 c2                	mov    %eax,%edx
  8015a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015aa:	01 d0                	add    %edx,%eax
  8015ac:	48                   	dec    %eax
  8015ad:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8015b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8015b8:	f7 75 ec             	divl   -0x14(%ebp)
  8015bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015be:	29 d0                	sub    %edx,%eax
  8015c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_USER);
  8015c3:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  8015ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015cd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015d2:	2d 00 10 00 00       	sub    $0x1000,%eax
  8015d7:	83 ec 04             	sub    $0x4,%esp
  8015da:	6a 06                	push   $0x6
  8015dc:	ff 75 f4             	pushl  -0xc(%ebp)
  8015df:	50                   	push   %eax
  8015e0:	e8 1d 04 00 00       	call   801a02 <sys_allocate_chunk>
  8015e5:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8015e8:	a1 20 51 80 00       	mov    0x805120,%eax
  8015ed:	83 ec 0c             	sub    $0xc,%esp
  8015f0:	50                   	push   %eax
  8015f1:	e8 92 0a 00 00       	call   802088 <initialize_MemBlocksList>
  8015f6:	83 c4 10             	add    $0x10,%esp
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	struct MemBlock * NewBlock = LIST_FIRST(&AvailableMemBlocksList);
  8015f9:	a1 48 51 80 00       	mov    0x805148,%eax
  8015fe:	89 45 e0             	mov    %eax,-0x20(%ebp)
	NewBlock->sva = USER_HEAP_START;
  801601:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801604:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	NewBlock->size = (USER_HEAP_MAX-USER_HEAP_START);
  80160b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80160e:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	LIST_REMOVE(&AvailableMemBlocksList,NewBlock);
  801615:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801619:	75 14                	jne    80162f <initialize_dyn_block_system+0x105>
  80161b:	83 ec 04             	sub    $0x4,%esp
  80161e:	68 b5 40 80 00       	push   $0x8040b5
  801623:	6a 33                	push   $0x33
  801625:	68 d3 40 80 00       	push   $0x8040d3
  80162a:	e8 8c ee ff ff       	call   8004bb <_panic>
  80162f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801632:	8b 00                	mov    (%eax),%eax
  801634:	85 c0                	test   %eax,%eax
  801636:	74 10                	je     801648 <initialize_dyn_block_system+0x11e>
  801638:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80163b:	8b 00                	mov    (%eax),%eax
  80163d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801640:	8b 52 04             	mov    0x4(%edx),%edx
  801643:	89 50 04             	mov    %edx,0x4(%eax)
  801646:	eb 0b                	jmp    801653 <initialize_dyn_block_system+0x129>
  801648:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80164b:	8b 40 04             	mov    0x4(%eax),%eax
  80164e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801653:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801656:	8b 40 04             	mov    0x4(%eax),%eax
  801659:	85 c0                	test   %eax,%eax
  80165b:	74 0f                	je     80166c <initialize_dyn_block_system+0x142>
  80165d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801660:	8b 40 04             	mov    0x4(%eax),%eax
  801663:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801666:	8b 12                	mov    (%edx),%edx
  801668:	89 10                	mov    %edx,(%eax)
  80166a:	eb 0a                	jmp    801676 <initialize_dyn_block_system+0x14c>
  80166c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80166f:	8b 00                	mov    (%eax),%eax
  801671:	a3 48 51 80 00       	mov    %eax,0x805148
  801676:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801679:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80167f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801682:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801689:	a1 54 51 80 00       	mov    0x805154,%eax
  80168e:	48                   	dec    %eax
  80168f:	a3 54 51 80 00       	mov    %eax,0x805154
	LIST_INSERT_HEAD(&FreeMemBlocksList, NewBlock);
  801694:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801698:	75 14                	jne    8016ae <initialize_dyn_block_system+0x184>
  80169a:	83 ec 04             	sub    $0x4,%esp
  80169d:	68 e0 40 80 00       	push   $0x8040e0
  8016a2:	6a 34                	push   $0x34
  8016a4:	68 d3 40 80 00       	push   $0x8040d3
  8016a9:	e8 0d ee ff ff       	call   8004bb <_panic>
  8016ae:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8016b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016b7:	89 10                	mov    %edx,(%eax)
  8016b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016bc:	8b 00                	mov    (%eax),%eax
  8016be:	85 c0                	test   %eax,%eax
  8016c0:	74 0d                	je     8016cf <initialize_dyn_block_system+0x1a5>
  8016c2:	a1 38 51 80 00       	mov    0x805138,%eax
  8016c7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8016ca:	89 50 04             	mov    %edx,0x4(%eax)
  8016cd:	eb 08                	jmp    8016d7 <initialize_dyn_block_system+0x1ad>
  8016cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016d2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8016d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016da:	a3 38 51 80 00       	mov    %eax,0x805138
  8016df:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016e2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8016e9:	a1 44 51 80 00       	mov    0x805144,%eax
  8016ee:	40                   	inc    %eax
  8016ef:	a3 44 51 80 00       	mov    %eax,0x805144
}
  8016f4:	90                   	nop
  8016f5:	c9                   	leave  
  8016f6:	c3                   	ret    

008016f7 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8016f7:	55                   	push   %ebp
  8016f8:	89 e5                	mov    %esp,%ebp
  8016fa:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016fd:	e8 f7 fd ff ff       	call   8014f9 <InitializeUHeap>
	if (size == 0) return NULL ;
  801702:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801706:	75 07                	jne    80170f <malloc+0x18>
  801708:	b8 00 00 00 00       	mov    $0x0,%eax
  80170d:	eb 14                	jmp    801723 <malloc+0x2c>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  80170f:	83 ec 04             	sub    $0x4,%esp
  801712:	68 04 41 80 00       	push   $0x804104
  801717:	6a 46                	push   $0x46
  801719:	68 d3 40 80 00       	push   $0x8040d3
  80171e:	e8 98 ed ff ff       	call   8004bb <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801723:	c9                   	leave  
  801724:	c3                   	ret    

00801725 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801725:	55                   	push   %ebp
  801726:	89 e5                	mov    %esp,%ebp
  801728:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  80172b:	83 ec 04             	sub    $0x4,%esp
  80172e:	68 2c 41 80 00       	push   $0x80412c
  801733:	6a 61                	push   $0x61
  801735:	68 d3 40 80 00       	push   $0x8040d3
  80173a:	e8 7c ed ff ff       	call   8004bb <_panic>

0080173f <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80173f:	55                   	push   %ebp
  801740:	89 e5                	mov    %esp,%ebp
  801742:	83 ec 38             	sub    $0x38,%esp
  801745:	8b 45 10             	mov    0x10(%ebp),%eax
  801748:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80174b:	e8 a9 fd ff ff       	call   8014f9 <InitializeUHeap>
	if (size == 0) return NULL ;
  801750:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801754:	75 07                	jne    80175d <smalloc+0x1e>
  801756:	b8 00 00 00 00       	mov    $0x0,%eax
  80175b:	eb 7c                	jmp    8017d9 <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  80175d:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801764:	8b 55 0c             	mov    0xc(%ebp),%edx
  801767:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80176a:	01 d0                	add    %edx,%eax
  80176c:	48                   	dec    %eax
  80176d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801770:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801773:	ba 00 00 00 00       	mov    $0x0,%edx
  801778:	f7 75 f0             	divl   -0x10(%ebp)
  80177b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80177e:	29 d0                	sub    %edx,%eax
  801780:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801783:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  80178a:	e8 41 06 00 00       	call   801dd0 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80178f:	85 c0                	test   %eax,%eax
  801791:	74 11                	je     8017a4 <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  801793:	83 ec 0c             	sub    $0xc,%esp
  801796:	ff 75 e8             	pushl  -0x18(%ebp)
  801799:	e8 ac 0c 00 00       	call   80244a <alloc_block_FF>
  80179e:	83 c4 10             	add    $0x10,%esp
  8017a1:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  8017a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8017a8:	74 2a                	je     8017d4 <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8017aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017ad:	8b 40 08             	mov    0x8(%eax),%eax
  8017b0:	89 c2                	mov    %eax,%edx
  8017b2:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8017b6:	52                   	push   %edx
  8017b7:	50                   	push   %eax
  8017b8:	ff 75 0c             	pushl  0xc(%ebp)
  8017bb:	ff 75 08             	pushl  0x8(%ebp)
  8017be:	e8 92 03 00 00       	call   801b55 <sys_createSharedObject>
  8017c3:	83 c4 10             	add    $0x10,%esp
  8017c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  8017c9:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  8017cd:	74 05                	je     8017d4 <smalloc+0x95>
			return (void*)virtual_address;
  8017cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017d2:	eb 05                	jmp    8017d9 <smalloc+0x9a>
	}
	return NULL;
  8017d4:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8017d9:	c9                   	leave  
  8017da:	c3                   	ret    

008017db <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8017db:	55                   	push   %ebp
  8017dc:	89 e5                	mov    %esp,%ebp
  8017de:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017e1:	e8 13 fd ff ff       	call   8014f9 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8017e6:	83 ec 04             	sub    $0x4,%esp
  8017e9:	68 50 41 80 00       	push   $0x804150
  8017ee:	68 a2 00 00 00       	push   $0xa2
  8017f3:	68 d3 40 80 00       	push   $0x8040d3
  8017f8:	e8 be ec ff ff       	call   8004bb <_panic>

008017fd <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8017fd:	55                   	push   %ebp
  8017fe:	89 e5                	mov    %esp,%ebp
  801800:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801803:	e8 f1 fc ff ff       	call   8014f9 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801808:	83 ec 04             	sub    $0x4,%esp
  80180b:	68 74 41 80 00       	push   $0x804174
  801810:	68 e6 00 00 00       	push   $0xe6
  801815:	68 d3 40 80 00       	push   $0x8040d3
  80181a:	e8 9c ec ff ff       	call   8004bb <_panic>

0080181f <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80181f:	55                   	push   %ebp
  801820:	89 e5                	mov    %esp,%ebp
  801822:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801825:	83 ec 04             	sub    $0x4,%esp
  801828:	68 9c 41 80 00       	push   $0x80419c
  80182d:	68 fa 00 00 00       	push   $0xfa
  801832:	68 d3 40 80 00       	push   $0x8040d3
  801837:	e8 7f ec ff ff       	call   8004bb <_panic>

0080183c <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80183c:	55                   	push   %ebp
  80183d:	89 e5                	mov    %esp,%ebp
  80183f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801842:	83 ec 04             	sub    $0x4,%esp
  801845:	68 c0 41 80 00       	push   $0x8041c0
  80184a:	68 05 01 00 00       	push   $0x105
  80184f:	68 d3 40 80 00       	push   $0x8040d3
  801854:	e8 62 ec ff ff       	call   8004bb <_panic>

00801859 <shrink>:

}
void shrink(uint32 newSize)
{
  801859:	55                   	push   %ebp
  80185a:	89 e5                	mov    %esp,%ebp
  80185c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80185f:	83 ec 04             	sub    $0x4,%esp
  801862:	68 c0 41 80 00       	push   $0x8041c0
  801867:	68 0a 01 00 00       	push   $0x10a
  80186c:	68 d3 40 80 00       	push   $0x8040d3
  801871:	e8 45 ec ff ff       	call   8004bb <_panic>

00801876 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801876:	55                   	push   %ebp
  801877:	89 e5                	mov    %esp,%ebp
  801879:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80187c:	83 ec 04             	sub    $0x4,%esp
  80187f:	68 c0 41 80 00       	push   $0x8041c0
  801884:	68 0f 01 00 00       	push   $0x10f
  801889:	68 d3 40 80 00       	push   $0x8040d3
  80188e:	e8 28 ec ff ff       	call   8004bb <_panic>

00801893 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801893:	55                   	push   %ebp
  801894:	89 e5                	mov    %esp,%ebp
  801896:	57                   	push   %edi
  801897:	56                   	push   %esi
  801898:	53                   	push   %ebx
  801899:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80189c:	8b 45 08             	mov    0x8(%ebp),%eax
  80189f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018a2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018a5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018a8:	8b 7d 18             	mov    0x18(%ebp),%edi
  8018ab:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8018ae:	cd 30                	int    $0x30
  8018b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8018b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018b6:	83 c4 10             	add    $0x10,%esp
  8018b9:	5b                   	pop    %ebx
  8018ba:	5e                   	pop    %esi
  8018bb:	5f                   	pop    %edi
  8018bc:	5d                   	pop    %ebp
  8018bd:	c3                   	ret    

008018be <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8018be:	55                   	push   %ebp
  8018bf:	89 e5                	mov    %esp,%ebp
  8018c1:	83 ec 04             	sub    $0x4,%esp
  8018c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8018c7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8018ca:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d1:	6a 00                	push   $0x0
  8018d3:	6a 00                	push   $0x0
  8018d5:	52                   	push   %edx
  8018d6:	ff 75 0c             	pushl  0xc(%ebp)
  8018d9:	50                   	push   %eax
  8018da:	6a 00                	push   $0x0
  8018dc:	e8 b2 ff ff ff       	call   801893 <syscall>
  8018e1:	83 c4 18             	add    $0x18,%esp
}
  8018e4:	90                   	nop
  8018e5:	c9                   	leave  
  8018e6:	c3                   	ret    

008018e7 <sys_cgetc>:

int
sys_cgetc(void)
{
  8018e7:	55                   	push   %ebp
  8018e8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8018ea:	6a 00                	push   $0x0
  8018ec:	6a 00                	push   $0x0
  8018ee:	6a 00                	push   $0x0
  8018f0:	6a 00                	push   $0x0
  8018f2:	6a 00                	push   $0x0
  8018f4:	6a 01                	push   $0x1
  8018f6:	e8 98 ff ff ff       	call   801893 <syscall>
  8018fb:	83 c4 18             	add    $0x18,%esp
}
  8018fe:	c9                   	leave  
  8018ff:	c3                   	ret    

00801900 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801900:	55                   	push   %ebp
  801901:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801903:	8b 55 0c             	mov    0xc(%ebp),%edx
  801906:	8b 45 08             	mov    0x8(%ebp),%eax
  801909:	6a 00                	push   $0x0
  80190b:	6a 00                	push   $0x0
  80190d:	6a 00                	push   $0x0
  80190f:	52                   	push   %edx
  801910:	50                   	push   %eax
  801911:	6a 05                	push   $0x5
  801913:	e8 7b ff ff ff       	call   801893 <syscall>
  801918:	83 c4 18             	add    $0x18,%esp
}
  80191b:	c9                   	leave  
  80191c:	c3                   	ret    

0080191d <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80191d:	55                   	push   %ebp
  80191e:	89 e5                	mov    %esp,%ebp
  801920:	56                   	push   %esi
  801921:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801922:	8b 75 18             	mov    0x18(%ebp),%esi
  801925:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801928:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80192b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80192e:	8b 45 08             	mov    0x8(%ebp),%eax
  801931:	56                   	push   %esi
  801932:	53                   	push   %ebx
  801933:	51                   	push   %ecx
  801934:	52                   	push   %edx
  801935:	50                   	push   %eax
  801936:	6a 06                	push   $0x6
  801938:	e8 56 ff ff ff       	call   801893 <syscall>
  80193d:	83 c4 18             	add    $0x18,%esp
}
  801940:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801943:	5b                   	pop    %ebx
  801944:	5e                   	pop    %esi
  801945:	5d                   	pop    %ebp
  801946:	c3                   	ret    

00801947 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801947:	55                   	push   %ebp
  801948:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80194a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80194d:	8b 45 08             	mov    0x8(%ebp),%eax
  801950:	6a 00                	push   $0x0
  801952:	6a 00                	push   $0x0
  801954:	6a 00                	push   $0x0
  801956:	52                   	push   %edx
  801957:	50                   	push   %eax
  801958:	6a 07                	push   $0x7
  80195a:	e8 34 ff ff ff       	call   801893 <syscall>
  80195f:	83 c4 18             	add    $0x18,%esp
}
  801962:	c9                   	leave  
  801963:	c3                   	ret    

00801964 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801964:	55                   	push   %ebp
  801965:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801967:	6a 00                	push   $0x0
  801969:	6a 00                	push   $0x0
  80196b:	6a 00                	push   $0x0
  80196d:	ff 75 0c             	pushl  0xc(%ebp)
  801970:	ff 75 08             	pushl  0x8(%ebp)
  801973:	6a 08                	push   $0x8
  801975:	e8 19 ff ff ff       	call   801893 <syscall>
  80197a:	83 c4 18             	add    $0x18,%esp
}
  80197d:	c9                   	leave  
  80197e:	c3                   	ret    

0080197f <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80197f:	55                   	push   %ebp
  801980:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801982:	6a 00                	push   $0x0
  801984:	6a 00                	push   $0x0
  801986:	6a 00                	push   $0x0
  801988:	6a 00                	push   $0x0
  80198a:	6a 00                	push   $0x0
  80198c:	6a 09                	push   $0x9
  80198e:	e8 00 ff ff ff       	call   801893 <syscall>
  801993:	83 c4 18             	add    $0x18,%esp
}
  801996:	c9                   	leave  
  801997:	c3                   	ret    

00801998 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801998:	55                   	push   %ebp
  801999:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80199b:	6a 00                	push   $0x0
  80199d:	6a 00                	push   $0x0
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 0a                	push   $0xa
  8019a7:	e8 e7 fe ff ff       	call   801893 <syscall>
  8019ac:	83 c4 18             	add    $0x18,%esp
}
  8019af:	c9                   	leave  
  8019b0:	c3                   	ret    

008019b1 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8019b1:	55                   	push   %ebp
  8019b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8019b4:	6a 00                	push   $0x0
  8019b6:	6a 00                	push   $0x0
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 0b                	push   $0xb
  8019c0:	e8 ce fe ff ff       	call   801893 <syscall>
  8019c5:	83 c4 18             	add    $0x18,%esp
}
  8019c8:	c9                   	leave  
  8019c9:	c3                   	ret    

008019ca <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8019ca:	55                   	push   %ebp
  8019cb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 00                	push   $0x0
  8019d3:	ff 75 0c             	pushl  0xc(%ebp)
  8019d6:	ff 75 08             	pushl  0x8(%ebp)
  8019d9:	6a 0f                	push   $0xf
  8019db:	e8 b3 fe ff ff       	call   801893 <syscall>
  8019e0:	83 c4 18             	add    $0x18,%esp
	return;
  8019e3:	90                   	nop
}
  8019e4:	c9                   	leave  
  8019e5:	c3                   	ret    

008019e6 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8019e6:	55                   	push   %ebp
  8019e7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 00                	push   $0x0
  8019ef:	ff 75 0c             	pushl  0xc(%ebp)
  8019f2:	ff 75 08             	pushl  0x8(%ebp)
  8019f5:	6a 10                	push   $0x10
  8019f7:	e8 97 fe ff ff       	call   801893 <syscall>
  8019fc:	83 c4 18             	add    $0x18,%esp
	return ;
  8019ff:	90                   	nop
}
  801a00:	c9                   	leave  
  801a01:	c3                   	ret    

00801a02 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801a02:	55                   	push   %ebp
  801a03:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a05:	6a 00                	push   $0x0
  801a07:	6a 00                	push   $0x0
  801a09:	ff 75 10             	pushl  0x10(%ebp)
  801a0c:	ff 75 0c             	pushl  0xc(%ebp)
  801a0f:	ff 75 08             	pushl  0x8(%ebp)
  801a12:	6a 11                	push   $0x11
  801a14:	e8 7a fe ff ff       	call   801893 <syscall>
  801a19:	83 c4 18             	add    $0x18,%esp
	return ;
  801a1c:	90                   	nop
}
  801a1d:	c9                   	leave  
  801a1e:	c3                   	ret    

00801a1f <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a1f:	55                   	push   %ebp
  801a20:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a22:	6a 00                	push   $0x0
  801a24:	6a 00                	push   $0x0
  801a26:	6a 00                	push   $0x0
  801a28:	6a 00                	push   $0x0
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 0c                	push   $0xc
  801a2e:	e8 60 fe ff ff       	call   801893 <syscall>
  801a33:	83 c4 18             	add    $0x18,%esp
}
  801a36:	c9                   	leave  
  801a37:	c3                   	ret    

00801a38 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a38:	55                   	push   %ebp
  801a39:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a3b:	6a 00                	push   $0x0
  801a3d:	6a 00                	push   $0x0
  801a3f:	6a 00                	push   $0x0
  801a41:	6a 00                	push   $0x0
  801a43:	ff 75 08             	pushl  0x8(%ebp)
  801a46:	6a 0d                	push   $0xd
  801a48:	e8 46 fe ff ff       	call   801893 <syscall>
  801a4d:	83 c4 18             	add    $0x18,%esp
}
  801a50:	c9                   	leave  
  801a51:	c3                   	ret    

00801a52 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a52:	55                   	push   %ebp
  801a53:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a55:	6a 00                	push   $0x0
  801a57:	6a 00                	push   $0x0
  801a59:	6a 00                	push   $0x0
  801a5b:	6a 00                	push   $0x0
  801a5d:	6a 00                	push   $0x0
  801a5f:	6a 0e                	push   $0xe
  801a61:	e8 2d fe ff ff       	call   801893 <syscall>
  801a66:	83 c4 18             	add    $0x18,%esp
}
  801a69:	90                   	nop
  801a6a:	c9                   	leave  
  801a6b:	c3                   	ret    

00801a6c <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801a6c:	55                   	push   %ebp
  801a6d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801a6f:	6a 00                	push   $0x0
  801a71:	6a 00                	push   $0x0
  801a73:	6a 00                	push   $0x0
  801a75:	6a 00                	push   $0x0
  801a77:	6a 00                	push   $0x0
  801a79:	6a 13                	push   $0x13
  801a7b:	e8 13 fe ff ff       	call   801893 <syscall>
  801a80:	83 c4 18             	add    $0x18,%esp
}
  801a83:	90                   	nop
  801a84:	c9                   	leave  
  801a85:	c3                   	ret    

00801a86 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801a86:	55                   	push   %ebp
  801a87:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801a89:	6a 00                	push   $0x0
  801a8b:	6a 00                	push   $0x0
  801a8d:	6a 00                	push   $0x0
  801a8f:	6a 00                	push   $0x0
  801a91:	6a 00                	push   $0x0
  801a93:	6a 14                	push   $0x14
  801a95:	e8 f9 fd ff ff       	call   801893 <syscall>
  801a9a:	83 c4 18             	add    $0x18,%esp
}
  801a9d:	90                   	nop
  801a9e:	c9                   	leave  
  801a9f:	c3                   	ret    

00801aa0 <sys_cputc>:


void
sys_cputc(const char c)
{
  801aa0:	55                   	push   %ebp
  801aa1:	89 e5                	mov    %esp,%ebp
  801aa3:	83 ec 04             	sub    $0x4,%esp
  801aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801aac:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 00                	push   $0x0
  801ab8:	50                   	push   %eax
  801ab9:	6a 15                	push   $0x15
  801abb:	e8 d3 fd ff ff       	call   801893 <syscall>
  801ac0:	83 c4 18             	add    $0x18,%esp
}
  801ac3:	90                   	nop
  801ac4:	c9                   	leave  
  801ac5:	c3                   	ret    

00801ac6 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801ac6:	55                   	push   %ebp
  801ac7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801ac9:	6a 00                	push   $0x0
  801acb:	6a 00                	push   $0x0
  801acd:	6a 00                	push   $0x0
  801acf:	6a 00                	push   $0x0
  801ad1:	6a 00                	push   $0x0
  801ad3:	6a 16                	push   $0x16
  801ad5:	e8 b9 fd ff ff       	call   801893 <syscall>
  801ada:	83 c4 18             	add    $0x18,%esp
}
  801add:	90                   	nop
  801ade:	c9                   	leave  
  801adf:	c3                   	ret    

00801ae0 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801ae0:	55                   	push   %ebp
  801ae1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801ae3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae6:	6a 00                	push   $0x0
  801ae8:	6a 00                	push   $0x0
  801aea:	6a 00                	push   $0x0
  801aec:	ff 75 0c             	pushl  0xc(%ebp)
  801aef:	50                   	push   %eax
  801af0:	6a 17                	push   $0x17
  801af2:	e8 9c fd ff ff       	call   801893 <syscall>
  801af7:	83 c4 18             	add    $0x18,%esp
}
  801afa:	c9                   	leave  
  801afb:	c3                   	ret    

00801afc <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801afc:	55                   	push   %ebp
  801afd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801aff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b02:	8b 45 08             	mov    0x8(%ebp),%eax
  801b05:	6a 00                	push   $0x0
  801b07:	6a 00                	push   $0x0
  801b09:	6a 00                	push   $0x0
  801b0b:	52                   	push   %edx
  801b0c:	50                   	push   %eax
  801b0d:	6a 1a                	push   $0x1a
  801b0f:	e8 7f fd ff ff       	call   801893 <syscall>
  801b14:	83 c4 18             	add    $0x18,%esp
}
  801b17:	c9                   	leave  
  801b18:	c3                   	ret    

00801b19 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b19:	55                   	push   %ebp
  801b1a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b1c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b22:	6a 00                	push   $0x0
  801b24:	6a 00                	push   $0x0
  801b26:	6a 00                	push   $0x0
  801b28:	52                   	push   %edx
  801b29:	50                   	push   %eax
  801b2a:	6a 18                	push   $0x18
  801b2c:	e8 62 fd ff ff       	call   801893 <syscall>
  801b31:	83 c4 18             	add    $0x18,%esp
}
  801b34:	90                   	nop
  801b35:	c9                   	leave  
  801b36:	c3                   	ret    

00801b37 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b37:	55                   	push   %ebp
  801b38:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b40:	6a 00                	push   $0x0
  801b42:	6a 00                	push   $0x0
  801b44:	6a 00                	push   $0x0
  801b46:	52                   	push   %edx
  801b47:	50                   	push   %eax
  801b48:	6a 19                	push   $0x19
  801b4a:	e8 44 fd ff ff       	call   801893 <syscall>
  801b4f:	83 c4 18             	add    $0x18,%esp
}
  801b52:	90                   	nop
  801b53:	c9                   	leave  
  801b54:	c3                   	ret    

00801b55 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b55:	55                   	push   %ebp
  801b56:	89 e5                	mov    %esp,%ebp
  801b58:	83 ec 04             	sub    $0x4,%esp
  801b5b:	8b 45 10             	mov    0x10(%ebp),%eax
  801b5e:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b61:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b64:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b68:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6b:	6a 00                	push   $0x0
  801b6d:	51                   	push   %ecx
  801b6e:	52                   	push   %edx
  801b6f:	ff 75 0c             	pushl  0xc(%ebp)
  801b72:	50                   	push   %eax
  801b73:	6a 1b                	push   $0x1b
  801b75:	e8 19 fd ff ff       	call   801893 <syscall>
  801b7a:	83 c4 18             	add    $0x18,%esp
}
  801b7d:	c9                   	leave  
  801b7e:	c3                   	ret    

00801b7f <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b7f:	55                   	push   %ebp
  801b80:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b82:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b85:	8b 45 08             	mov    0x8(%ebp),%eax
  801b88:	6a 00                	push   $0x0
  801b8a:	6a 00                	push   $0x0
  801b8c:	6a 00                	push   $0x0
  801b8e:	52                   	push   %edx
  801b8f:	50                   	push   %eax
  801b90:	6a 1c                	push   $0x1c
  801b92:	e8 fc fc ff ff       	call   801893 <syscall>
  801b97:	83 c4 18             	add    $0x18,%esp
}
  801b9a:	c9                   	leave  
  801b9b:	c3                   	ret    

00801b9c <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b9c:	55                   	push   %ebp
  801b9d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b9f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ba2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ba5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba8:	6a 00                	push   $0x0
  801baa:	6a 00                	push   $0x0
  801bac:	51                   	push   %ecx
  801bad:	52                   	push   %edx
  801bae:	50                   	push   %eax
  801baf:	6a 1d                	push   $0x1d
  801bb1:	e8 dd fc ff ff       	call   801893 <syscall>
  801bb6:	83 c4 18             	add    $0x18,%esp
}
  801bb9:	c9                   	leave  
  801bba:	c3                   	ret    

00801bbb <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801bbb:	55                   	push   %ebp
  801bbc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801bbe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bc1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc4:	6a 00                	push   $0x0
  801bc6:	6a 00                	push   $0x0
  801bc8:	6a 00                	push   $0x0
  801bca:	52                   	push   %edx
  801bcb:	50                   	push   %eax
  801bcc:	6a 1e                	push   $0x1e
  801bce:	e8 c0 fc ff ff       	call   801893 <syscall>
  801bd3:	83 c4 18             	add    $0x18,%esp
}
  801bd6:	c9                   	leave  
  801bd7:	c3                   	ret    

00801bd8 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801bd8:	55                   	push   %ebp
  801bd9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 00                	push   $0x0
  801be3:	6a 00                	push   $0x0
  801be5:	6a 1f                	push   $0x1f
  801be7:	e8 a7 fc ff ff       	call   801893 <syscall>
  801bec:	83 c4 18             	add    $0x18,%esp
}
  801bef:	c9                   	leave  
  801bf0:	c3                   	ret    

00801bf1 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801bf1:	55                   	push   %ebp
  801bf2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf7:	6a 00                	push   $0x0
  801bf9:	ff 75 14             	pushl  0x14(%ebp)
  801bfc:	ff 75 10             	pushl  0x10(%ebp)
  801bff:	ff 75 0c             	pushl  0xc(%ebp)
  801c02:	50                   	push   %eax
  801c03:	6a 20                	push   $0x20
  801c05:	e8 89 fc ff ff       	call   801893 <syscall>
  801c0a:	83 c4 18             	add    $0x18,%esp
}
  801c0d:	c9                   	leave  
  801c0e:	c3                   	ret    

00801c0f <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801c0f:	55                   	push   %ebp
  801c10:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c12:	8b 45 08             	mov    0x8(%ebp),%eax
  801c15:	6a 00                	push   $0x0
  801c17:	6a 00                	push   $0x0
  801c19:	6a 00                	push   $0x0
  801c1b:	6a 00                	push   $0x0
  801c1d:	50                   	push   %eax
  801c1e:	6a 21                	push   $0x21
  801c20:	e8 6e fc ff ff       	call   801893 <syscall>
  801c25:	83 c4 18             	add    $0x18,%esp
}
  801c28:	90                   	nop
  801c29:	c9                   	leave  
  801c2a:	c3                   	ret    

00801c2b <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c2b:	55                   	push   %ebp
  801c2c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c31:	6a 00                	push   $0x0
  801c33:	6a 00                	push   $0x0
  801c35:	6a 00                	push   $0x0
  801c37:	6a 00                	push   $0x0
  801c39:	50                   	push   %eax
  801c3a:	6a 22                	push   $0x22
  801c3c:	e8 52 fc ff ff       	call   801893 <syscall>
  801c41:	83 c4 18             	add    $0x18,%esp
}
  801c44:	c9                   	leave  
  801c45:	c3                   	ret    

00801c46 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c46:	55                   	push   %ebp
  801c47:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c49:	6a 00                	push   $0x0
  801c4b:	6a 00                	push   $0x0
  801c4d:	6a 00                	push   $0x0
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 00                	push   $0x0
  801c53:	6a 02                	push   $0x2
  801c55:	e8 39 fc ff ff       	call   801893 <syscall>
  801c5a:	83 c4 18             	add    $0x18,%esp
}
  801c5d:	c9                   	leave  
  801c5e:	c3                   	ret    

00801c5f <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c5f:	55                   	push   %ebp
  801c60:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c62:	6a 00                	push   $0x0
  801c64:	6a 00                	push   $0x0
  801c66:	6a 00                	push   $0x0
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 00                	push   $0x0
  801c6c:	6a 03                	push   $0x3
  801c6e:	e8 20 fc ff ff       	call   801893 <syscall>
  801c73:	83 c4 18             	add    $0x18,%esp
}
  801c76:	c9                   	leave  
  801c77:	c3                   	ret    

00801c78 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c78:	55                   	push   %ebp
  801c79:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c7b:	6a 00                	push   $0x0
  801c7d:	6a 00                	push   $0x0
  801c7f:	6a 00                	push   $0x0
  801c81:	6a 00                	push   $0x0
  801c83:	6a 00                	push   $0x0
  801c85:	6a 04                	push   $0x4
  801c87:	e8 07 fc ff ff       	call   801893 <syscall>
  801c8c:	83 c4 18             	add    $0x18,%esp
}
  801c8f:	c9                   	leave  
  801c90:	c3                   	ret    

00801c91 <sys_exit_env>:


void sys_exit_env(void)
{
  801c91:	55                   	push   %ebp
  801c92:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c94:	6a 00                	push   $0x0
  801c96:	6a 00                	push   $0x0
  801c98:	6a 00                	push   $0x0
  801c9a:	6a 00                	push   $0x0
  801c9c:	6a 00                	push   $0x0
  801c9e:	6a 23                	push   $0x23
  801ca0:	e8 ee fb ff ff       	call   801893 <syscall>
  801ca5:	83 c4 18             	add    $0x18,%esp
}
  801ca8:	90                   	nop
  801ca9:	c9                   	leave  
  801caa:	c3                   	ret    

00801cab <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801cab:	55                   	push   %ebp
  801cac:	89 e5                	mov    %esp,%ebp
  801cae:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801cb1:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cb4:	8d 50 04             	lea    0x4(%eax),%edx
  801cb7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cba:	6a 00                	push   $0x0
  801cbc:	6a 00                	push   $0x0
  801cbe:	6a 00                	push   $0x0
  801cc0:	52                   	push   %edx
  801cc1:	50                   	push   %eax
  801cc2:	6a 24                	push   $0x24
  801cc4:	e8 ca fb ff ff       	call   801893 <syscall>
  801cc9:	83 c4 18             	add    $0x18,%esp
	return result;
  801ccc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ccf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801cd2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801cd5:	89 01                	mov    %eax,(%ecx)
  801cd7:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801cda:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdd:	c9                   	leave  
  801cde:	c2 04 00             	ret    $0x4

00801ce1 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801ce1:	55                   	push   %ebp
  801ce2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801ce4:	6a 00                	push   $0x0
  801ce6:	6a 00                	push   $0x0
  801ce8:	ff 75 10             	pushl  0x10(%ebp)
  801ceb:	ff 75 0c             	pushl  0xc(%ebp)
  801cee:	ff 75 08             	pushl  0x8(%ebp)
  801cf1:	6a 12                	push   $0x12
  801cf3:	e8 9b fb ff ff       	call   801893 <syscall>
  801cf8:	83 c4 18             	add    $0x18,%esp
	return ;
  801cfb:	90                   	nop
}
  801cfc:	c9                   	leave  
  801cfd:	c3                   	ret    

00801cfe <sys_rcr2>:
uint32 sys_rcr2()
{
  801cfe:	55                   	push   %ebp
  801cff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d01:	6a 00                	push   $0x0
  801d03:	6a 00                	push   $0x0
  801d05:	6a 00                	push   $0x0
  801d07:	6a 00                	push   $0x0
  801d09:	6a 00                	push   $0x0
  801d0b:	6a 25                	push   $0x25
  801d0d:	e8 81 fb ff ff       	call   801893 <syscall>
  801d12:	83 c4 18             	add    $0x18,%esp
}
  801d15:	c9                   	leave  
  801d16:	c3                   	ret    

00801d17 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801d17:	55                   	push   %ebp
  801d18:	89 e5                	mov    %esp,%ebp
  801d1a:	83 ec 04             	sub    $0x4,%esp
  801d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d20:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d23:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d27:	6a 00                	push   $0x0
  801d29:	6a 00                	push   $0x0
  801d2b:	6a 00                	push   $0x0
  801d2d:	6a 00                	push   $0x0
  801d2f:	50                   	push   %eax
  801d30:	6a 26                	push   $0x26
  801d32:	e8 5c fb ff ff       	call   801893 <syscall>
  801d37:	83 c4 18             	add    $0x18,%esp
	return ;
  801d3a:	90                   	nop
}
  801d3b:	c9                   	leave  
  801d3c:	c3                   	ret    

00801d3d <rsttst>:
void rsttst()
{
  801d3d:	55                   	push   %ebp
  801d3e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d40:	6a 00                	push   $0x0
  801d42:	6a 00                	push   $0x0
  801d44:	6a 00                	push   $0x0
  801d46:	6a 00                	push   $0x0
  801d48:	6a 00                	push   $0x0
  801d4a:	6a 28                	push   $0x28
  801d4c:	e8 42 fb ff ff       	call   801893 <syscall>
  801d51:	83 c4 18             	add    $0x18,%esp
	return ;
  801d54:	90                   	nop
}
  801d55:	c9                   	leave  
  801d56:	c3                   	ret    

00801d57 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d57:	55                   	push   %ebp
  801d58:	89 e5                	mov    %esp,%ebp
  801d5a:	83 ec 04             	sub    $0x4,%esp
  801d5d:	8b 45 14             	mov    0x14(%ebp),%eax
  801d60:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d63:	8b 55 18             	mov    0x18(%ebp),%edx
  801d66:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d6a:	52                   	push   %edx
  801d6b:	50                   	push   %eax
  801d6c:	ff 75 10             	pushl  0x10(%ebp)
  801d6f:	ff 75 0c             	pushl  0xc(%ebp)
  801d72:	ff 75 08             	pushl  0x8(%ebp)
  801d75:	6a 27                	push   $0x27
  801d77:	e8 17 fb ff ff       	call   801893 <syscall>
  801d7c:	83 c4 18             	add    $0x18,%esp
	return ;
  801d7f:	90                   	nop
}
  801d80:	c9                   	leave  
  801d81:	c3                   	ret    

00801d82 <chktst>:
void chktst(uint32 n)
{
  801d82:	55                   	push   %ebp
  801d83:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d85:	6a 00                	push   $0x0
  801d87:	6a 00                	push   $0x0
  801d89:	6a 00                	push   $0x0
  801d8b:	6a 00                	push   $0x0
  801d8d:	ff 75 08             	pushl  0x8(%ebp)
  801d90:	6a 29                	push   $0x29
  801d92:	e8 fc fa ff ff       	call   801893 <syscall>
  801d97:	83 c4 18             	add    $0x18,%esp
	return ;
  801d9a:	90                   	nop
}
  801d9b:	c9                   	leave  
  801d9c:	c3                   	ret    

00801d9d <inctst>:

void inctst()
{
  801d9d:	55                   	push   %ebp
  801d9e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801da0:	6a 00                	push   $0x0
  801da2:	6a 00                	push   $0x0
  801da4:	6a 00                	push   $0x0
  801da6:	6a 00                	push   $0x0
  801da8:	6a 00                	push   $0x0
  801daa:	6a 2a                	push   $0x2a
  801dac:	e8 e2 fa ff ff       	call   801893 <syscall>
  801db1:	83 c4 18             	add    $0x18,%esp
	return ;
  801db4:	90                   	nop
}
  801db5:	c9                   	leave  
  801db6:	c3                   	ret    

00801db7 <gettst>:
uint32 gettst()
{
  801db7:	55                   	push   %ebp
  801db8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801dba:	6a 00                	push   $0x0
  801dbc:	6a 00                	push   $0x0
  801dbe:	6a 00                	push   $0x0
  801dc0:	6a 00                	push   $0x0
  801dc2:	6a 00                	push   $0x0
  801dc4:	6a 2b                	push   $0x2b
  801dc6:	e8 c8 fa ff ff       	call   801893 <syscall>
  801dcb:	83 c4 18             	add    $0x18,%esp
}
  801dce:	c9                   	leave  
  801dcf:	c3                   	ret    

00801dd0 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801dd0:	55                   	push   %ebp
  801dd1:	89 e5                	mov    %esp,%ebp
  801dd3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dd6:	6a 00                	push   $0x0
  801dd8:	6a 00                	push   $0x0
  801dda:	6a 00                	push   $0x0
  801ddc:	6a 00                	push   $0x0
  801dde:	6a 00                	push   $0x0
  801de0:	6a 2c                	push   $0x2c
  801de2:	e8 ac fa ff ff       	call   801893 <syscall>
  801de7:	83 c4 18             	add    $0x18,%esp
  801dea:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801ded:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801df1:	75 07                	jne    801dfa <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801df3:	b8 01 00 00 00       	mov    $0x1,%eax
  801df8:	eb 05                	jmp    801dff <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801dfa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dff:	c9                   	leave  
  801e00:	c3                   	ret    

00801e01 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e01:	55                   	push   %ebp
  801e02:	89 e5                	mov    %esp,%ebp
  801e04:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e07:	6a 00                	push   $0x0
  801e09:	6a 00                	push   $0x0
  801e0b:	6a 00                	push   $0x0
  801e0d:	6a 00                	push   $0x0
  801e0f:	6a 00                	push   $0x0
  801e11:	6a 2c                	push   $0x2c
  801e13:	e8 7b fa ff ff       	call   801893 <syscall>
  801e18:	83 c4 18             	add    $0x18,%esp
  801e1b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e1e:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e22:	75 07                	jne    801e2b <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e24:	b8 01 00 00 00       	mov    $0x1,%eax
  801e29:	eb 05                	jmp    801e30 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e2b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e30:	c9                   	leave  
  801e31:	c3                   	ret    

00801e32 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e32:	55                   	push   %ebp
  801e33:	89 e5                	mov    %esp,%ebp
  801e35:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e38:	6a 00                	push   $0x0
  801e3a:	6a 00                	push   $0x0
  801e3c:	6a 00                	push   $0x0
  801e3e:	6a 00                	push   $0x0
  801e40:	6a 00                	push   $0x0
  801e42:	6a 2c                	push   $0x2c
  801e44:	e8 4a fa ff ff       	call   801893 <syscall>
  801e49:	83 c4 18             	add    $0x18,%esp
  801e4c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e4f:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e53:	75 07                	jne    801e5c <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e55:	b8 01 00 00 00       	mov    $0x1,%eax
  801e5a:	eb 05                	jmp    801e61 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e5c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e61:	c9                   	leave  
  801e62:	c3                   	ret    

00801e63 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e63:	55                   	push   %ebp
  801e64:	89 e5                	mov    %esp,%ebp
  801e66:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e69:	6a 00                	push   $0x0
  801e6b:	6a 00                	push   $0x0
  801e6d:	6a 00                	push   $0x0
  801e6f:	6a 00                	push   $0x0
  801e71:	6a 00                	push   $0x0
  801e73:	6a 2c                	push   $0x2c
  801e75:	e8 19 fa ff ff       	call   801893 <syscall>
  801e7a:	83 c4 18             	add    $0x18,%esp
  801e7d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e80:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e84:	75 07                	jne    801e8d <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e86:	b8 01 00 00 00       	mov    $0x1,%eax
  801e8b:	eb 05                	jmp    801e92 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e8d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e92:	c9                   	leave  
  801e93:	c3                   	ret    

00801e94 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e94:	55                   	push   %ebp
  801e95:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e97:	6a 00                	push   $0x0
  801e99:	6a 00                	push   $0x0
  801e9b:	6a 00                	push   $0x0
  801e9d:	6a 00                	push   $0x0
  801e9f:	ff 75 08             	pushl  0x8(%ebp)
  801ea2:	6a 2d                	push   $0x2d
  801ea4:	e8 ea f9 ff ff       	call   801893 <syscall>
  801ea9:	83 c4 18             	add    $0x18,%esp
	return ;
  801eac:	90                   	nop
}
  801ead:	c9                   	leave  
  801eae:	c3                   	ret    

00801eaf <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801eaf:	55                   	push   %ebp
  801eb0:	89 e5                	mov    %esp,%ebp
  801eb2:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801eb3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801eb6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801eb9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ebc:	8b 45 08             	mov    0x8(%ebp),%eax
  801ebf:	6a 00                	push   $0x0
  801ec1:	53                   	push   %ebx
  801ec2:	51                   	push   %ecx
  801ec3:	52                   	push   %edx
  801ec4:	50                   	push   %eax
  801ec5:	6a 2e                	push   $0x2e
  801ec7:	e8 c7 f9 ff ff       	call   801893 <syscall>
  801ecc:	83 c4 18             	add    $0x18,%esp
}
  801ecf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ed2:	c9                   	leave  
  801ed3:	c3                   	ret    

00801ed4 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ed4:	55                   	push   %ebp
  801ed5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801ed7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eda:	8b 45 08             	mov    0x8(%ebp),%eax
  801edd:	6a 00                	push   $0x0
  801edf:	6a 00                	push   $0x0
  801ee1:	6a 00                	push   $0x0
  801ee3:	52                   	push   %edx
  801ee4:	50                   	push   %eax
  801ee5:	6a 2f                	push   $0x2f
  801ee7:	e8 a7 f9 ff ff       	call   801893 <syscall>
  801eec:	83 c4 18             	add    $0x18,%esp
}
  801eef:	c9                   	leave  
  801ef0:	c3                   	ret    

00801ef1 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801ef1:	55                   	push   %ebp
  801ef2:	89 e5                	mov    %esp,%ebp
  801ef4:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801ef7:	83 ec 0c             	sub    $0xc,%esp
  801efa:	68 d0 41 80 00       	push   $0x8041d0
  801eff:	e8 6b e8 ff ff       	call   80076f <cprintf>
  801f04:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801f07:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801f0e:	83 ec 0c             	sub    $0xc,%esp
  801f11:	68 fc 41 80 00       	push   $0x8041fc
  801f16:	e8 54 e8 ff ff       	call   80076f <cprintf>
  801f1b:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801f1e:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f22:	a1 38 51 80 00       	mov    0x805138,%eax
  801f27:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f2a:	eb 56                	jmp    801f82 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f2c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f30:	74 1c                	je     801f4e <print_mem_block_lists+0x5d>
  801f32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f35:	8b 50 08             	mov    0x8(%eax),%edx
  801f38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f3b:	8b 48 08             	mov    0x8(%eax),%ecx
  801f3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f41:	8b 40 0c             	mov    0xc(%eax),%eax
  801f44:	01 c8                	add    %ecx,%eax
  801f46:	39 c2                	cmp    %eax,%edx
  801f48:	73 04                	jae    801f4e <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801f4a:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f51:	8b 50 08             	mov    0x8(%eax),%edx
  801f54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f57:	8b 40 0c             	mov    0xc(%eax),%eax
  801f5a:	01 c2                	add    %eax,%edx
  801f5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f5f:	8b 40 08             	mov    0x8(%eax),%eax
  801f62:	83 ec 04             	sub    $0x4,%esp
  801f65:	52                   	push   %edx
  801f66:	50                   	push   %eax
  801f67:	68 11 42 80 00       	push   $0x804211
  801f6c:	e8 fe e7 ff ff       	call   80076f <cprintf>
  801f71:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f77:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f7a:	a1 40 51 80 00       	mov    0x805140,%eax
  801f7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f82:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f86:	74 07                	je     801f8f <print_mem_block_lists+0x9e>
  801f88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f8b:	8b 00                	mov    (%eax),%eax
  801f8d:	eb 05                	jmp    801f94 <print_mem_block_lists+0xa3>
  801f8f:	b8 00 00 00 00       	mov    $0x0,%eax
  801f94:	a3 40 51 80 00       	mov    %eax,0x805140
  801f99:	a1 40 51 80 00       	mov    0x805140,%eax
  801f9e:	85 c0                	test   %eax,%eax
  801fa0:	75 8a                	jne    801f2c <print_mem_block_lists+0x3b>
  801fa2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fa6:	75 84                	jne    801f2c <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801fa8:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801fac:	75 10                	jne    801fbe <print_mem_block_lists+0xcd>
  801fae:	83 ec 0c             	sub    $0xc,%esp
  801fb1:	68 20 42 80 00       	push   $0x804220
  801fb6:	e8 b4 e7 ff ff       	call   80076f <cprintf>
  801fbb:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801fbe:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801fc5:	83 ec 0c             	sub    $0xc,%esp
  801fc8:	68 44 42 80 00       	push   $0x804244
  801fcd:	e8 9d e7 ff ff       	call   80076f <cprintf>
  801fd2:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801fd5:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801fd9:	a1 40 50 80 00       	mov    0x805040,%eax
  801fde:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fe1:	eb 56                	jmp    802039 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801fe3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fe7:	74 1c                	je     802005 <print_mem_block_lists+0x114>
  801fe9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fec:	8b 50 08             	mov    0x8(%eax),%edx
  801fef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ff2:	8b 48 08             	mov    0x8(%eax),%ecx
  801ff5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ff8:	8b 40 0c             	mov    0xc(%eax),%eax
  801ffb:	01 c8                	add    %ecx,%eax
  801ffd:	39 c2                	cmp    %eax,%edx
  801fff:	73 04                	jae    802005 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802001:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802005:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802008:	8b 50 08             	mov    0x8(%eax),%edx
  80200b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80200e:	8b 40 0c             	mov    0xc(%eax),%eax
  802011:	01 c2                	add    %eax,%edx
  802013:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802016:	8b 40 08             	mov    0x8(%eax),%eax
  802019:	83 ec 04             	sub    $0x4,%esp
  80201c:	52                   	push   %edx
  80201d:	50                   	push   %eax
  80201e:	68 11 42 80 00       	push   $0x804211
  802023:	e8 47 e7 ff ff       	call   80076f <cprintf>
  802028:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80202b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80202e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802031:	a1 48 50 80 00       	mov    0x805048,%eax
  802036:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802039:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80203d:	74 07                	je     802046 <print_mem_block_lists+0x155>
  80203f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802042:	8b 00                	mov    (%eax),%eax
  802044:	eb 05                	jmp    80204b <print_mem_block_lists+0x15a>
  802046:	b8 00 00 00 00       	mov    $0x0,%eax
  80204b:	a3 48 50 80 00       	mov    %eax,0x805048
  802050:	a1 48 50 80 00       	mov    0x805048,%eax
  802055:	85 c0                	test   %eax,%eax
  802057:	75 8a                	jne    801fe3 <print_mem_block_lists+0xf2>
  802059:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80205d:	75 84                	jne    801fe3 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80205f:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802063:	75 10                	jne    802075 <print_mem_block_lists+0x184>
  802065:	83 ec 0c             	sub    $0xc,%esp
  802068:	68 5c 42 80 00       	push   $0x80425c
  80206d:	e8 fd e6 ff ff       	call   80076f <cprintf>
  802072:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802075:	83 ec 0c             	sub    $0xc,%esp
  802078:	68 d0 41 80 00       	push   $0x8041d0
  80207d:	e8 ed e6 ff ff       	call   80076f <cprintf>
  802082:	83 c4 10             	add    $0x10,%esp

}
  802085:	90                   	nop
  802086:	c9                   	leave  
  802087:	c3                   	ret    

00802088 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802088:	55                   	push   %ebp
  802089:	89 e5                	mov    %esp,%ebp
  80208b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  80208e:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802095:	00 00 00 
  802098:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80209f:	00 00 00 
  8020a2:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8020a9:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  8020ac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8020b3:	e9 9e 00 00 00       	jmp    802156 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  8020b8:	a1 50 50 80 00       	mov    0x805050,%eax
  8020bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020c0:	c1 e2 04             	shl    $0x4,%edx
  8020c3:	01 d0                	add    %edx,%eax
  8020c5:	85 c0                	test   %eax,%eax
  8020c7:	75 14                	jne    8020dd <initialize_MemBlocksList+0x55>
  8020c9:	83 ec 04             	sub    $0x4,%esp
  8020cc:	68 84 42 80 00       	push   $0x804284
  8020d1:	6a 46                	push   $0x46
  8020d3:	68 a7 42 80 00       	push   $0x8042a7
  8020d8:	e8 de e3 ff ff       	call   8004bb <_panic>
  8020dd:	a1 50 50 80 00       	mov    0x805050,%eax
  8020e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020e5:	c1 e2 04             	shl    $0x4,%edx
  8020e8:	01 d0                	add    %edx,%eax
  8020ea:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8020f0:	89 10                	mov    %edx,(%eax)
  8020f2:	8b 00                	mov    (%eax),%eax
  8020f4:	85 c0                	test   %eax,%eax
  8020f6:	74 18                	je     802110 <initialize_MemBlocksList+0x88>
  8020f8:	a1 48 51 80 00       	mov    0x805148,%eax
  8020fd:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802103:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802106:	c1 e1 04             	shl    $0x4,%ecx
  802109:	01 ca                	add    %ecx,%edx
  80210b:	89 50 04             	mov    %edx,0x4(%eax)
  80210e:	eb 12                	jmp    802122 <initialize_MemBlocksList+0x9a>
  802110:	a1 50 50 80 00       	mov    0x805050,%eax
  802115:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802118:	c1 e2 04             	shl    $0x4,%edx
  80211b:	01 d0                	add    %edx,%eax
  80211d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802122:	a1 50 50 80 00       	mov    0x805050,%eax
  802127:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80212a:	c1 e2 04             	shl    $0x4,%edx
  80212d:	01 d0                	add    %edx,%eax
  80212f:	a3 48 51 80 00       	mov    %eax,0x805148
  802134:	a1 50 50 80 00       	mov    0x805050,%eax
  802139:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80213c:	c1 e2 04             	shl    $0x4,%edx
  80213f:	01 d0                	add    %edx,%eax
  802141:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802148:	a1 54 51 80 00       	mov    0x805154,%eax
  80214d:	40                   	inc    %eax
  80214e:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802153:	ff 45 f4             	incl   -0xc(%ebp)
  802156:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802159:	3b 45 08             	cmp    0x8(%ebp),%eax
  80215c:	0f 82 56 ff ff ff    	jb     8020b8 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802162:	90                   	nop
  802163:	c9                   	leave  
  802164:	c3                   	ret    

00802165 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802165:	55                   	push   %ebp
  802166:	89 e5                	mov    %esp,%ebp
  802168:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80216b:	8b 45 08             	mov    0x8(%ebp),%eax
  80216e:	8b 00                	mov    (%eax),%eax
  802170:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802173:	eb 19                	jmp    80218e <find_block+0x29>
	{
		if(va==point->sva)
  802175:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802178:	8b 40 08             	mov    0x8(%eax),%eax
  80217b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80217e:	75 05                	jne    802185 <find_block+0x20>
		   return point;
  802180:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802183:	eb 36                	jmp    8021bb <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802185:	8b 45 08             	mov    0x8(%ebp),%eax
  802188:	8b 40 08             	mov    0x8(%eax),%eax
  80218b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80218e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802192:	74 07                	je     80219b <find_block+0x36>
  802194:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802197:	8b 00                	mov    (%eax),%eax
  802199:	eb 05                	jmp    8021a0 <find_block+0x3b>
  80219b:	b8 00 00 00 00       	mov    $0x0,%eax
  8021a0:	8b 55 08             	mov    0x8(%ebp),%edx
  8021a3:	89 42 08             	mov    %eax,0x8(%edx)
  8021a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a9:	8b 40 08             	mov    0x8(%eax),%eax
  8021ac:	85 c0                	test   %eax,%eax
  8021ae:	75 c5                	jne    802175 <find_block+0x10>
  8021b0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021b4:	75 bf                	jne    802175 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  8021b6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021bb:	c9                   	leave  
  8021bc:	c3                   	ret    

008021bd <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8021bd:	55                   	push   %ebp
  8021be:	89 e5                	mov    %esp,%ebp
  8021c0:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  8021c3:	a1 40 50 80 00       	mov    0x805040,%eax
  8021c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  8021cb:	a1 44 50 80 00       	mov    0x805044,%eax
  8021d0:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8021d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021d6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8021d9:	74 24                	je     8021ff <insert_sorted_allocList+0x42>
  8021db:	8b 45 08             	mov    0x8(%ebp),%eax
  8021de:	8b 50 08             	mov    0x8(%eax),%edx
  8021e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021e4:	8b 40 08             	mov    0x8(%eax),%eax
  8021e7:	39 c2                	cmp    %eax,%edx
  8021e9:	76 14                	jbe    8021ff <insert_sorted_allocList+0x42>
  8021eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ee:	8b 50 08             	mov    0x8(%eax),%edx
  8021f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021f4:	8b 40 08             	mov    0x8(%eax),%eax
  8021f7:	39 c2                	cmp    %eax,%edx
  8021f9:	0f 82 60 01 00 00    	jb     80235f <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8021ff:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802203:	75 65                	jne    80226a <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802205:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802209:	75 14                	jne    80221f <insert_sorted_allocList+0x62>
  80220b:	83 ec 04             	sub    $0x4,%esp
  80220e:	68 84 42 80 00       	push   $0x804284
  802213:	6a 6b                	push   $0x6b
  802215:	68 a7 42 80 00       	push   $0x8042a7
  80221a:	e8 9c e2 ff ff       	call   8004bb <_panic>
  80221f:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802225:	8b 45 08             	mov    0x8(%ebp),%eax
  802228:	89 10                	mov    %edx,(%eax)
  80222a:	8b 45 08             	mov    0x8(%ebp),%eax
  80222d:	8b 00                	mov    (%eax),%eax
  80222f:	85 c0                	test   %eax,%eax
  802231:	74 0d                	je     802240 <insert_sorted_allocList+0x83>
  802233:	a1 40 50 80 00       	mov    0x805040,%eax
  802238:	8b 55 08             	mov    0x8(%ebp),%edx
  80223b:	89 50 04             	mov    %edx,0x4(%eax)
  80223e:	eb 08                	jmp    802248 <insert_sorted_allocList+0x8b>
  802240:	8b 45 08             	mov    0x8(%ebp),%eax
  802243:	a3 44 50 80 00       	mov    %eax,0x805044
  802248:	8b 45 08             	mov    0x8(%ebp),%eax
  80224b:	a3 40 50 80 00       	mov    %eax,0x805040
  802250:	8b 45 08             	mov    0x8(%ebp),%eax
  802253:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80225a:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80225f:	40                   	inc    %eax
  802260:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802265:	e9 dc 01 00 00       	jmp    802446 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  80226a:	8b 45 08             	mov    0x8(%ebp),%eax
  80226d:	8b 50 08             	mov    0x8(%eax),%edx
  802270:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802273:	8b 40 08             	mov    0x8(%eax),%eax
  802276:	39 c2                	cmp    %eax,%edx
  802278:	77 6c                	ja     8022e6 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  80227a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80227e:	74 06                	je     802286 <insert_sorted_allocList+0xc9>
  802280:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802284:	75 14                	jne    80229a <insert_sorted_allocList+0xdd>
  802286:	83 ec 04             	sub    $0x4,%esp
  802289:	68 c0 42 80 00       	push   $0x8042c0
  80228e:	6a 6f                	push   $0x6f
  802290:	68 a7 42 80 00       	push   $0x8042a7
  802295:	e8 21 e2 ff ff       	call   8004bb <_panic>
  80229a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80229d:	8b 50 04             	mov    0x4(%eax),%edx
  8022a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a3:	89 50 04             	mov    %edx,0x4(%eax)
  8022a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022ac:	89 10                	mov    %edx,(%eax)
  8022ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022b1:	8b 40 04             	mov    0x4(%eax),%eax
  8022b4:	85 c0                	test   %eax,%eax
  8022b6:	74 0d                	je     8022c5 <insert_sorted_allocList+0x108>
  8022b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022bb:	8b 40 04             	mov    0x4(%eax),%eax
  8022be:	8b 55 08             	mov    0x8(%ebp),%edx
  8022c1:	89 10                	mov    %edx,(%eax)
  8022c3:	eb 08                	jmp    8022cd <insert_sorted_allocList+0x110>
  8022c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c8:	a3 40 50 80 00       	mov    %eax,0x805040
  8022cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8022d3:	89 50 04             	mov    %edx,0x4(%eax)
  8022d6:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8022db:	40                   	inc    %eax
  8022dc:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8022e1:	e9 60 01 00 00       	jmp    802446 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8022e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e9:	8b 50 08             	mov    0x8(%eax),%edx
  8022ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022ef:	8b 40 08             	mov    0x8(%eax),%eax
  8022f2:	39 c2                	cmp    %eax,%edx
  8022f4:	0f 82 4c 01 00 00    	jb     802446 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8022fa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022fe:	75 14                	jne    802314 <insert_sorted_allocList+0x157>
  802300:	83 ec 04             	sub    $0x4,%esp
  802303:	68 f8 42 80 00       	push   $0x8042f8
  802308:	6a 73                	push   $0x73
  80230a:	68 a7 42 80 00       	push   $0x8042a7
  80230f:	e8 a7 e1 ff ff       	call   8004bb <_panic>
  802314:	8b 15 44 50 80 00    	mov    0x805044,%edx
  80231a:	8b 45 08             	mov    0x8(%ebp),%eax
  80231d:	89 50 04             	mov    %edx,0x4(%eax)
  802320:	8b 45 08             	mov    0x8(%ebp),%eax
  802323:	8b 40 04             	mov    0x4(%eax),%eax
  802326:	85 c0                	test   %eax,%eax
  802328:	74 0c                	je     802336 <insert_sorted_allocList+0x179>
  80232a:	a1 44 50 80 00       	mov    0x805044,%eax
  80232f:	8b 55 08             	mov    0x8(%ebp),%edx
  802332:	89 10                	mov    %edx,(%eax)
  802334:	eb 08                	jmp    80233e <insert_sorted_allocList+0x181>
  802336:	8b 45 08             	mov    0x8(%ebp),%eax
  802339:	a3 40 50 80 00       	mov    %eax,0x805040
  80233e:	8b 45 08             	mov    0x8(%ebp),%eax
  802341:	a3 44 50 80 00       	mov    %eax,0x805044
  802346:	8b 45 08             	mov    0x8(%ebp),%eax
  802349:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80234f:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802354:	40                   	inc    %eax
  802355:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80235a:	e9 e7 00 00 00       	jmp    802446 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  80235f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802362:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802365:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80236c:	a1 40 50 80 00       	mov    0x805040,%eax
  802371:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802374:	e9 9d 00 00 00       	jmp    802416 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802379:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237c:	8b 00                	mov    (%eax),%eax
  80237e:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802381:	8b 45 08             	mov    0x8(%ebp),%eax
  802384:	8b 50 08             	mov    0x8(%eax),%edx
  802387:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238a:	8b 40 08             	mov    0x8(%eax),%eax
  80238d:	39 c2                	cmp    %eax,%edx
  80238f:	76 7d                	jbe    80240e <insert_sorted_allocList+0x251>
  802391:	8b 45 08             	mov    0x8(%ebp),%eax
  802394:	8b 50 08             	mov    0x8(%eax),%edx
  802397:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80239a:	8b 40 08             	mov    0x8(%eax),%eax
  80239d:	39 c2                	cmp    %eax,%edx
  80239f:	73 6d                	jae    80240e <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8023a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023a5:	74 06                	je     8023ad <insert_sorted_allocList+0x1f0>
  8023a7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023ab:	75 14                	jne    8023c1 <insert_sorted_allocList+0x204>
  8023ad:	83 ec 04             	sub    $0x4,%esp
  8023b0:	68 1c 43 80 00       	push   $0x80431c
  8023b5:	6a 7f                	push   $0x7f
  8023b7:	68 a7 42 80 00       	push   $0x8042a7
  8023bc:	e8 fa e0 ff ff       	call   8004bb <_panic>
  8023c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c4:	8b 10                	mov    (%eax),%edx
  8023c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c9:	89 10                	mov    %edx,(%eax)
  8023cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ce:	8b 00                	mov    (%eax),%eax
  8023d0:	85 c0                	test   %eax,%eax
  8023d2:	74 0b                	je     8023df <insert_sorted_allocList+0x222>
  8023d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d7:	8b 00                	mov    (%eax),%eax
  8023d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8023dc:	89 50 04             	mov    %edx,0x4(%eax)
  8023df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8023e5:	89 10                	mov    %edx,(%eax)
  8023e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023ed:	89 50 04             	mov    %edx,0x4(%eax)
  8023f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f3:	8b 00                	mov    (%eax),%eax
  8023f5:	85 c0                	test   %eax,%eax
  8023f7:	75 08                	jne    802401 <insert_sorted_allocList+0x244>
  8023f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fc:	a3 44 50 80 00       	mov    %eax,0x805044
  802401:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802406:	40                   	inc    %eax
  802407:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  80240c:	eb 39                	jmp    802447 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80240e:	a1 48 50 80 00       	mov    0x805048,%eax
  802413:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802416:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80241a:	74 07                	je     802423 <insert_sorted_allocList+0x266>
  80241c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241f:	8b 00                	mov    (%eax),%eax
  802421:	eb 05                	jmp    802428 <insert_sorted_allocList+0x26b>
  802423:	b8 00 00 00 00       	mov    $0x0,%eax
  802428:	a3 48 50 80 00       	mov    %eax,0x805048
  80242d:	a1 48 50 80 00       	mov    0x805048,%eax
  802432:	85 c0                	test   %eax,%eax
  802434:	0f 85 3f ff ff ff    	jne    802379 <insert_sorted_allocList+0x1bc>
  80243a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80243e:	0f 85 35 ff ff ff    	jne    802379 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802444:	eb 01                	jmp    802447 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802446:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802447:	90                   	nop
  802448:	c9                   	leave  
  802449:	c3                   	ret    

0080244a <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80244a:	55                   	push   %ebp
  80244b:	89 e5                	mov    %esp,%ebp
  80244d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802450:	a1 38 51 80 00       	mov    0x805138,%eax
  802455:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802458:	e9 85 01 00 00       	jmp    8025e2 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  80245d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802460:	8b 40 0c             	mov    0xc(%eax),%eax
  802463:	3b 45 08             	cmp    0x8(%ebp),%eax
  802466:	0f 82 6e 01 00 00    	jb     8025da <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  80246c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246f:	8b 40 0c             	mov    0xc(%eax),%eax
  802472:	3b 45 08             	cmp    0x8(%ebp),%eax
  802475:	0f 85 8a 00 00 00    	jne    802505 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  80247b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80247f:	75 17                	jne    802498 <alloc_block_FF+0x4e>
  802481:	83 ec 04             	sub    $0x4,%esp
  802484:	68 50 43 80 00       	push   $0x804350
  802489:	68 93 00 00 00       	push   $0x93
  80248e:	68 a7 42 80 00       	push   $0x8042a7
  802493:	e8 23 e0 ff ff       	call   8004bb <_panic>
  802498:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249b:	8b 00                	mov    (%eax),%eax
  80249d:	85 c0                	test   %eax,%eax
  80249f:	74 10                	je     8024b1 <alloc_block_FF+0x67>
  8024a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a4:	8b 00                	mov    (%eax),%eax
  8024a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024a9:	8b 52 04             	mov    0x4(%edx),%edx
  8024ac:	89 50 04             	mov    %edx,0x4(%eax)
  8024af:	eb 0b                	jmp    8024bc <alloc_block_FF+0x72>
  8024b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b4:	8b 40 04             	mov    0x4(%eax),%eax
  8024b7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8024bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024bf:	8b 40 04             	mov    0x4(%eax),%eax
  8024c2:	85 c0                	test   %eax,%eax
  8024c4:	74 0f                	je     8024d5 <alloc_block_FF+0x8b>
  8024c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c9:	8b 40 04             	mov    0x4(%eax),%eax
  8024cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024cf:	8b 12                	mov    (%edx),%edx
  8024d1:	89 10                	mov    %edx,(%eax)
  8024d3:	eb 0a                	jmp    8024df <alloc_block_FF+0x95>
  8024d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d8:	8b 00                	mov    (%eax),%eax
  8024da:	a3 38 51 80 00       	mov    %eax,0x805138
  8024df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024eb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024f2:	a1 44 51 80 00       	mov    0x805144,%eax
  8024f7:	48                   	dec    %eax
  8024f8:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  8024fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802500:	e9 10 01 00 00       	jmp    802615 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802505:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802508:	8b 40 0c             	mov    0xc(%eax),%eax
  80250b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80250e:	0f 86 c6 00 00 00    	jbe    8025da <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802514:	a1 48 51 80 00       	mov    0x805148,%eax
  802519:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  80251c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251f:	8b 50 08             	mov    0x8(%eax),%edx
  802522:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802525:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802528:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80252b:	8b 55 08             	mov    0x8(%ebp),%edx
  80252e:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802531:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802535:	75 17                	jne    80254e <alloc_block_FF+0x104>
  802537:	83 ec 04             	sub    $0x4,%esp
  80253a:	68 50 43 80 00       	push   $0x804350
  80253f:	68 9b 00 00 00       	push   $0x9b
  802544:	68 a7 42 80 00       	push   $0x8042a7
  802549:	e8 6d df ff ff       	call   8004bb <_panic>
  80254e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802551:	8b 00                	mov    (%eax),%eax
  802553:	85 c0                	test   %eax,%eax
  802555:	74 10                	je     802567 <alloc_block_FF+0x11d>
  802557:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80255a:	8b 00                	mov    (%eax),%eax
  80255c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80255f:	8b 52 04             	mov    0x4(%edx),%edx
  802562:	89 50 04             	mov    %edx,0x4(%eax)
  802565:	eb 0b                	jmp    802572 <alloc_block_FF+0x128>
  802567:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80256a:	8b 40 04             	mov    0x4(%eax),%eax
  80256d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802572:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802575:	8b 40 04             	mov    0x4(%eax),%eax
  802578:	85 c0                	test   %eax,%eax
  80257a:	74 0f                	je     80258b <alloc_block_FF+0x141>
  80257c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80257f:	8b 40 04             	mov    0x4(%eax),%eax
  802582:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802585:	8b 12                	mov    (%edx),%edx
  802587:	89 10                	mov    %edx,(%eax)
  802589:	eb 0a                	jmp    802595 <alloc_block_FF+0x14b>
  80258b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80258e:	8b 00                	mov    (%eax),%eax
  802590:	a3 48 51 80 00       	mov    %eax,0x805148
  802595:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802598:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80259e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025a1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025a8:	a1 54 51 80 00       	mov    0x805154,%eax
  8025ad:	48                   	dec    %eax
  8025ae:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  8025b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b6:	8b 50 08             	mov    0x8(%eax),%edx
  8025b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025bc:	01 c2                	add    %eax,%edx
  8025be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c1:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8025c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c7:	8b 40 0c             	mov    0xc(%eax),%eax
  8025ca:	2b 45 08             	sub    0x8(%ebp),%eax
  8025cd:	89 c2                	mov    %eax,%edx
  8025cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d2:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8025d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025d8:	eb 3b                	jmp    802615 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8025da:	a1 40 51 80 00       	mov    0x805140,%eax
  8025df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025e6:	74 07                	je     8025ef <alloc_block_FF+0x1a5>
  8025e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025eb:	8b 00                	mov    (%eax),%eax
  8025ed:	eb 05                	jmp    8025f4 <alloc_block_FF+0x1aa>
  8025ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8025f4:	a3 40 51 80 00       	mov    %eax,0x805140
  8025f9:	a1 40 51 80 00       	mov    0x805140,%eax
  8025fe:	85 c0                	test   %eax,%eax
  802600:	0f 85 57 fe ff ff    	jne    80245d <alloc_block_FF+0x13>
  802606:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80260a:	0f 85 4d fe ff ff    	jne    80245d <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802610:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802615:	c9                   	leave  
  802616:	c3                   	ret    

00802617 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802617:	55                   	push   %ebp
  802618:	89 e5                	mov    %esp,%ebp
  80261a:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  80261d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802624:	a1 38 51 80 00       	mov    0x805138,%eax
  802629:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80262c:	e9 df 00 00 00       	jmp    802710 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802631:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802634:	8b 40 0c             	mov    0xc(%eax),%eax
  802637:	3b 45 08             	cmp    0x8(%ebp),%eax
  80263a:	0f 82 c8 00 00 00    	jb     802708 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802640:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802643:	8b 40 0c             	mov    0xc(%eax),%eax
  802646:	3b 45 08             	cmp    0x8(%ebp),%eax
  802649:	0f 85 8a 00 00 00    	jne    8026d9 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  80264f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802653:	75 17                	jne    80266c <alloc_block_BF+0x55>
  802655:	83 ec 04             	sub    $0x4,%esp
  802658:	68 50 43 80 00       	push   $0x804350
  80265d:	68 b7 00 00 00       	push   $0xb7
  802662:	68 a7 42 80 00       	push   $0x8042a7
  802667:	e8 4f de ff ff       	call   8004bb <_panic>
  80266c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266f:	8b 00                	mov    (%eax),%eax
  802671:	85 c0                	test   %eax,%eax
  802673:	74 10                	je     802685 <alloc_block_BF+0x6e>
  802675:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802678:	8b 00                	mov    (%eax),%eax
  80267a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80267d:	8b 52 04             	mov    0x4(%edx),%edx
  802680:	89 50 04             	mov    %edx,0x4(%eax)
  802683:	eb 0b                	jmp    802690 <alloc_block_BF+0x79>
  802685:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802688:	8b 40 04             	mov    0x4(%eax),%eax
  80268b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802690:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802693:	8b 40 04             	mov    0x4(%eax),%eax
  802696:	85 c0                	test   %eax,%eax
  802698:	74 0f                	je     8026a9 <alloc_block_BF+0x92>
  80269a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269d:	8b 40 04             	mov    0x4(%eax),%eax
  8026a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026a3:	8b 12                	mov    (%edx),%edx
  8026a5:	89 10                	mov    %edx,(%eax)
  8026a7:	eb 0a                	jmp    8026b3 <alloc_block_BF+0x9c>
  8026a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ac:	8b 00                	mov    (%eax),%eax
  8026ae:	a3 38 51 80 00       	mov    %eax,0x805138
  8026b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026c6:	a1 44 51 80 00       	mov    0x805144,%eax
  8026cb:	48                   	dec    %eax
  8026cc:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  8026d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d4:	e9 4d 01 00 00       	jmp    802826 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8026d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026dc:	8b 40 0c             	mov    0xc(%eax),%eax
  8026df:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026e2:	76 24                	jbe    802708 <alloc_block_BF+0xf1>
  8026e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e7:	8b 40 0c             	mov    0xc(%eax),%eax
  8026ea:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8026ed:	73 19                	jae    802708 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8026ef:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8026f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f9:	8b 40 0c             	mov    0xc(%eax),%eax
  8026fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8026ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802702:	8b 40 08             	mov    0x8(%eax),%eax
  802705:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802708:	a1 40 51 80 00       	mov    0x805140,%eax
  80270d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802710:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802714:	74 07                	je     80271d <alloc_block_BF+0x106>
  802716:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802719:	8b 00                	mov    (%eax),%eax
  80271b:	eb 05                	jmp    802722 <alloc_block_BF+0x10b>
  80271d:	b8 00 00 00 00       	mov    $0x0,%eax
  802722:	a3 40 51 80 00       	mov    %eax,0x805140
  802727:	a1 40 51 80 00       	mov    0x805140,%eax
  80272c:	85 c0                	test   %eax,%eax
  80272e:	0f 85 fd fe ff ff    	jne    802631 <alloc_block_BF+0x1a>
  802734:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802738:	0f 85 f3 fe ff ff    	jne    802631 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  80273e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802742:	0f 84 d9 00 00 00    	je     802821 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802748:	a1 48 51 80 00       	mov    0x805148,%eax
  80274d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802750:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802753:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802756:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802759:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80275c:	8b 55 08             	mov    0x8(%ebp),%edx
  80275f:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802762:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802766:	75 17                	jne    80277f <alloc_block_BF+0x168>
  802768:	83 ec 04             	sub    $0x4,%esp
  80276b:	68 50 43 80 00       	push   $0x804350
  802770:	68 c7 00 00 00       	push   $0xc7
  802775:	68 a7 42 80 00       	push   $0x8042a7
  80277a:	e8 3c dd ff ff       	call   8004bb <_panic>
  80277f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802782:	8b 00                	mov    (%eax),%eax
  802784:	85 c0                	test   %eax,%eax
  802786:	74 10                	je     802798 <alloc_block_BF+0x181>
  802788:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80278b:	8b 00                	mov    (%eax),%eax
  80278d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802790:	8b 52 04             	mov    0x4(%edx),%edx
  802793:	89 50 04             	mov    %edx,0x4(%eax)
  802796:	eb 0b                	jmp    8027a3 <alloc_block_BF+0x18c>
  802798:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80279b:	8b 40 04             	mov    0x4(%eax),%eax
  80279e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8027a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027a6:	8b 40 04             	mov    0x4(%eax),%eax
  8027a9:	85 c0                	test   %eax,%eax
  8027ab:	74 0f                	je     8027bc <alloc_block_BF+0x1a5>
  8027ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027b0:	8b 40 04             	mov    0x4(%eax),%eax
  8027b3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027b6:	8b 12                	mov    (%edx),%edx
  8027b8:	89 10                	mov    %edx,(%eax)
  8027ba:	eb 0a                	jmp    8027c6 <alloc_block_BF+0x1af>
  8027bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027bf:	8b 00                	mov    (%eax),%eax
  8027c1:	a3 48 51 80 00       	mov    %eax,0x805148
  8027c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027d2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027d9:	a1 54 51 80 00       	mov    0x805154,%eax
  8027de:	48                   	dec    %eax
  8027df:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8027e4:	83 ec 08             	sub    $0x8,%esp
  8027e7:	ff 75 ec             	pushl  -0x14(%ebp)
  8027ea:	68 38 51 80 00       	push   $0x805138
  8027ef:	e8 71 f9 ff ff       	call   802165 <find_block>
  8027f4:	83 c4 10             	add    $0x10,%esp
  8027f7:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8027fa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027fd:	8b 50 08             	mov    0x8(%eax),%edx
  802800:	8b 45 08             	mov    0x8(%ebp),%eax
  802803:	01 c2                	add    %eax,%edx
  802805:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802808:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  80280b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80280e:	8b 40 0c             	mov    0xc(%eax),%eax
  802811:	2b 45 08             	sub    0x8(%ebp),%eax
  802814:	89 c2                	mov    %eax,%edx
  802816:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802819:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  80281c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80281f:	eb 05                	jmp    802826 <alloc_block_BF+0x20f>
	}
	return NULL;
  802821:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802826:	c9                   	leave  
  802827:	c3                   	ret    

00802828 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802828:	55                   	push   %ebp
  802829:	89 e5                	mov    %esp,%ebp
  80282b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  80282e:	a1 28 50 80 00       	mov    0x805028,%eax
  802833:	85 c0                	test   %eax,%eax
  802835:	0f 85 de 01 00 00    	jne    802a19 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80283b:	a1 38 51 80 00       	mov    0x805138,%eax
  802840:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802843:	e9 9e 01 00 00       	jmp    8029e6 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802848:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284b:	8b 40 0c             	mov    0xc(%eax),%eax
  80284e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802851:	0f 82 87 01 00 00    	jb     8029de <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802857:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285a:	8b 40 0c             	mov    0xc(%eax),%eax
  80285d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802860:	0f 85 95 00 00 00    	jne    8028fb <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802866:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80286a:	75 17                	jne    802883 <alloc_block_NF+0x5b>
  80286c:	83 ec 04             	sub    $0x4,%esp
  80286f:	68 50 43 80 00       	push   $0x804350
  802874:	68 e0 00 00 00       	push   $0xe0
  802879:	68 a7 42 80 00       	push   $0x8042a7
  80287e:	e8 38 dc ff ff       	call   8004bb <_panic>
  802883:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802886:	8b 00                	mov    (%eax),%eax
  802888:	85 c0                	test   %eax,%eax
  80288a:	74 10                	je     80289c <alloc_block_NF+0x74>
  80288c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288f:	8b 00                	mov    (%eax),%eax
  802891:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802894:	8b 52 04             	mov    0x4(%edx),%edx
  802897:	89 50 04             	mov    %edx,0x4(%eax)
  80289a:	eb 0b                	jmp    8028a7 <alloc_block_NF+0x7f>
  80289c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289f:	8b 40 04             	mov    0x4(%eax),%eax
  8028a2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8028a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028aa:	8b 40 04             	mov    0x4(%eax),%eax
  8028ad:	85 c0                	test   %eax,%eax
  8028af:	74 0f                	je     8028c0 <alloc_block_NF+0x98>
  8028b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b4:	8b 40 04             	mov    0x4(%eax),%eax
  8028b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028ba:	8b 12                	mov    (%edx),%edx
  8028bc:	89 10                	mov    %edx,(%eax)
  8028be:	eb 0a                	jmp    8028ca <alloc_block_NF+0xa2>
  8028c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c3:	8b 00                	mov    (%eax),%eax
  8028c5:	a3 38 51 80 00       	mov    %eax,0x805138
  8028ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028dd:	a1 44 51 80 00       	mov    0x805144,%eax
  8028e2:	48                   	dec    %eax
  8028e3:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  8028e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028eb:	8b 40 08             	mov    0x8(%eax),%eax
  8028ee:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  8028f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f6:	e9 f8 04 00 00       	jmp    802df3 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8028fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fe:	8b 40 0c             	mov    0xc(%eax),%eax
  802901:	3b 45 08             	cmp    0x8(%ebp),%eax
  802904:	0f 86 d4 00 00 00    	jbe    8029de <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80290a:	a1 48 51 80 00       	mov    0x805148,%eax
  80290f:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802912:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802915:	8b 50 08             	mov    0x8(%eax),%edx
  802918:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80291b:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  80291e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802921:	8b 55 08             	mov    0x8(%ebp),%edx
  802924:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802927:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80292b:	75 17                	jne    802944 <alloc_block_NF+0x11c>
  80292d:	83 ec 04             	sub    $0x4,%esp
  802930:	68 50 43 80 00       	push   $0x804350
  802935:	68 e9 00 00 00       	push   $0xe9
  80293a:	68 a7 42 80 00       	push   $0x8042a7
  80293f:	e8 77 db ff ff       	call   8004bb <_panic>
  802944:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802947:	8b 00                	mov    (%eax),%eax
  802949:	85 c0                	test   %eax,%eax
  80294b:	74 10                	je     80295d <alloc_block_NF+0x135>
  80294d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802950:	8b 00                	mov    (%eax),%eax
  802952:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802955:	8b 52 04             	mov    0x4(%edx),%edx
  802958:	89 50 04             	mov    %edx,0x4(%eax)
  80295b:	eb 0b                	jmp    802968 <alloc_block_NF+0x140>
  80295d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802960:	8b 40 04             	mov    0x4(%eax),%eax
  802963:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802968:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80296b:	8b 40 04             	mov    0x4(%eax),%eax
  80296e:	85 c0                	test   %eax,%eax
  802970:	74 0f                	je     802981 <alloc_block_NF+0x159>
  802972:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802975:	8b 40 04             	mov    0x4(%eax),%eax
  802978:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80297b:	8b 12                	mov    (%edx),%edx
  80297d:	89 10                	mov    %edx,(%eax)
  80297f:	eb 0a                	jmp    80298b <alloc_block_NF+0x163>
  802981:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802984:	8b 00                	mov    (%eax),%eax
  802986:	a3 48 51 80 00       	mov    %eax,0x805148
  80298b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80298e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802994:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802997:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80299e:	a1 54 51 80 00       	mov    0x805154,%eax
  8029a3:	48                   	dec    %eax
  8029a4:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  8029a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ac:	8b 40 08             	mov    0x8(%eax),%eax
  8029af:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  8029b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b7:	8b 50 08             	mov    0x8(%eax),%edx
  8029ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8029bd:	01 c2                	add    %eax,%edx
  8029bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c2:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  8029c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c8:	8b 40 0c             	mov    0xc(%eax),%eax
  8029cb:	2b 45 08             	sub    0x8(%ebp),%eax
  8029ce:	89 c2                	mov    %eax,%edx
  8029d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d3:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  8029d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029d9:	e9 15 04 00 00       	jmp    802df3 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8029de:	a1 40 51 80 00       	mov    0x805140,%eax
  8029e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029ea:	74 07                	je     8029f3 <alloc_block_NF+0x1cb>
  8029ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ef:	8b 00                	mov    (%eax),%eax
  8029f1:	eb 05                	jmp    8029f8 <alloc_block_NF+0x1d0>
  8029f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8029f8:	a3 40 51 80 00       	mov    %eax,0x805140
  8029fd:	a1 40 51 80 00       	mov    0x805140,%eax
  802a02:	85 c0                	test   %eax,%eax
  802a04:	0f 85 3e fe ff ff    	jne    802848 <alloc_block_NF+0x20>
  802a0a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a0e:	0f 85 34 fe ff ff    	jne    802848 <alloc_block_NF+0x20>
  802a14:	e9 d5 03 00 00       	jmp    802dee <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a19:	a1 38 51 80 00       	mov    0x805138,%eax
  802a1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a21:	e9 b1 01 00 00       	jmp    802bd7 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802a26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a29:	8b 50 08             	mov    0x8(%eax),%edx
  802a2c:	a1 28 50 80 00       	mov    0x805028,%eax
  802a31:	39 c2                	cmp    %eax,%edx
  802a33:	0f 82 96 01 00 00    	jb     802bcf <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802a39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3c:	8b 40 0c             	mov    0xc(%eax),%eax
  802a3f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a42:	0f 82 87 01 00 00    	jb     802bcf <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802a48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4b:	8b 40 0c             	mov    0xc(%eax),%eax
  802a4e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a51:	0f 85 95 00 00 00    	jne    802aec <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802a57:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a5b:	75 17                	jne    802a74 <alloc_block_NF+0x24c>
  802a5d:	83 ec 04             	sub    $0x4,%esp
  802a60:	68 50 43 80 00       	push   $0x804350
  802a65:	68 fc 00 00 00       	push   $0xfc
  802a6a:	68 a7 42 80 00       	push   $0x8042a7
  802a6f:	e8 47 da ff ff       	call   8004bb <_panic>
  802a74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a77:	8b 00                	mov    (%eax),%eax
  802a79:	85 c0                	test   %eax,%eax
  802a7b:	74 10                	je     802a8d <alloc_block_NF+0x265>
  802a7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a80:	8b 00                	mov    (%eax),%eax
  802a82:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a85:	8b 52 04             	mov    0x4(%edx),%edx
  802a88:	89 50 04             	mov    %edx,0x4(%eax)
  802a8b:	eb 0b                	jmp    802a98 <alloc_block_NF+0x270>
  802a8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a90:	8b 40 04             	mov    0x4(%eax),%eax
  802a93:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9b:	8b 40 04             	mov    0x4(%eax),%eax
  802a9e:	85 c0                	test   %eax,%eax
  802aa0:	74 0f                	je     802ab1 <alloc_block_NF+0x289>
  802aa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa5:	8b 40 04             	mov    0x4(%eax),%eax
  802aa8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802aab:	8b 12                	mov    (%edx),%edx
  802aad:	89 10                	mov    %edx,(%eax)
  802aaf:	eb 0a                	jmp    802abb <alloc_block_NF+0x293>
  802ab1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab4:	8b 00                	mov    (%eax),%eax
  802ab6:	a3 38 51 80 00       	mov    %eax,0x805138
  802abb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802abe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ac4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ace:	a1 44 51 80 00       	mov    0x805144,%eax
  802ad3:	48                   	dec    %eax
  802ad4:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802ad9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802adc:	8b 40 08             	mov    0x8(%eax),%eax
  802adf:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802ae4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae7:	e9 07 03 00 00       	jmp    802df3 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802aec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aef:	8b 40 0c             	mov    0xc(%eax),%eax
  802af2:	3b 45 08             	cmp    0x8(%ebp),%eax
  802af5:	0f 86 d4 00 00 00    	jbe    802bcf <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802afb:	a1 48 51 80 00       	mov    0x805148,%eax
  802b00:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802b03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b06:	8b 50 08             	mov    0x8(%eax),%edx
  802b09:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b0c:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802b0f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b12:	8b 55 08             	mov    0x8(%ebp),%edx
  802b15:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802b18:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802b1c:	75 17                	jne    802b35 <alloc_block_NF+0x30d>
  802b1e:	83 ec 04             	sub    $0x4,%esp
  802b21:	68 50 43 80 00       	push   $0x804350
  802b26:	68 04 01 00 00       	push   $0x104
  802b2b:	68 a7 42 80 00       	push   $0x8042a7
  802b30:	e8 86 d9 ff ff       	call   8004bb <_panic>
  802b35:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b38:	8b 00                	mov    (%eax),%eax
  802b3a:	85 c0                	test   %eax,%eax
  802b3c:	74 10                	je     802b4e <alloc_block_NF+0x326>
  802b3e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b41:	8b 00                	mov    (%eax),%eax
  802b43:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b46:	8b 52 04             	mov    0x4(%edx),%edx
  802b49:	89 50 04             	mov    %edx,0x4(%eax)
  802b4c:	eb 0b                	jmp    802b59 <alloc_block_NF+0x331>
  802b4e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b51:	8b 40 04             	mov    0x4(%eax),%eax
  802b54:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b59:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b5c:	8b 40 04             	mov    0x4(%eax),%eax
  802b5f:	85 c0                	test   %eax,%eax
  802b61:	74 0f                	je     802b72 <alloc_block_NF+0x34a>
  802b63:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b66:	8b 40 04             	mov    0x4(%eax),%eax
  802b69:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b6c:	8b 12                	mov    (%edx),%edx
  802b6e:	89 10                	mov    %edx,(%eax)
  802b70:	eb 0a                	jmp    802b7c <alloc_block_NF+0x354>
  802b72:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b75:	8b 00                	mov    (%eax),%eax
  802b77:	a3 48 51 80 00       	mov    %eax,0x805148
  802b7c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b7f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b85:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b88:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b8f:	a1 54 51 80 00       	mov    0x805154,%eax
  802b94:	48                   	dec    %eax
  802b95:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802b9a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b9d:	8b 40 08             	mov    0x8(%eax),%eax
  802ba0:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802ba5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba8:	8b 50 08             	mov    0x8(%eax),%edx
  802bab:	8b 45 08             	mov    0x8(%ebp),%eax
  802bae:	01 c2                	add    %eax,%edx
  802bb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb3:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802bb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb9:	8b 40 0c             	mov    0xc(%eax),%eax
  802bbc:	2b 45 08             	sub    0x8(%ebp),%eax
  802bbf:	89 c2                	mov    %eax,%edx
  802bc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc4:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802bc7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bca:	e9 24 02 00 00       	jmp    802df3 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802bcf:	a1 40 51 80 00       	mov    0x805140,%eax
  802bd4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bd7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bdb:	74 07                	je     802be4 <alloc_block_NF+0x3bc>
  802bdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be0:	8b 00                	mov    (%eax),%eax
  802be2:	eb 05                	jmp    802be9 <alloc_block_NF+0x3c1>
  802be4:	b8 00 00 00 00       	mov    $0x0,%eax
  802be9:	a3 40 51 80 00       	mov    %eax,0x805140
  802bee:	a1 40 51 80 00       	mov    0x805140,%eax
  802bf3:	85 c0                	test   %eax,%eax
  802bf5:	0f 85 2b fe ff ff    	jne    802a26 <alloc_block_NF+0x1fe>
  802bfb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bff:	0f 85 21 fe ff ff    	jne    802a26 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c05:	a1 38 51 80 00       	mov    0x805138,%eax
  802c0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c0d:	e9 ae 01 00 00       	jmp    802dc0 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802c12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c15:	8b 50 08             	mov    0x8(%eax),%edx
  802c18:	a1 28 50 80 00       	mov    0x805028,%eax
  802c1d:	39 c2                	cmp    %eax,%edx
  802c1f:	0f 83 93 01 00 00    	jae    802db8 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802c25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c28:	8b 40 0c             	mov    0xc(%eax),%eax
  802c2b:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c2e:	0f 82 84 01 00 00    	jb     802db8 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802c34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c37:	8b 40 0c             	mov    0xc(%eax),%eax
  802c3a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c3d:	0f 85 95 00 00 00    	jne    802cd8 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802c43:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c47:	75 17                	jne    802c60 <alloc_block_NF+0x438>
  802c49:	83 ec 04             	sub    $0x4,%esp
  802c4c:	68 50 43 80 00       	push   $0x804350
  802c51:	68 14 01 00 00       	push   $0x114
  802c56:	68 a7 42 80 00       	push   $0x8042a7
  802c5b:	e8 5b d8 ff ff       	call   8004bb <_panic>
  802c60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c63:	8b 00                	mov    (%eax),%eax
  802c65:	85 c0                	test   %eax,%eax
  802c67:	74 10                	je     802c79 <alloc_block_NF+0x451>
  802c69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6c:	8b 00                	mov    (%eax),%eax
  802c6e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c71:	8b 52 04             	mov    0x4(%edx),%edx
  802c74:	89 50 04             	mov    %edx,0x4(%eax)
  802c77:	eb 0b                	jmp    802c84 <alloc_block_NF+0x45c>
  802c79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7c:	8b 40 04             	mov    0x4(%eax),%eax
  802c7f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c87:	8b 40 04             	mov    0x4(%eax),%eax
  802c8a:	85 c0                	test   %eax,%eax
  802c8c:	74 0f                	je     802c9d <alloc_block_NF+0x475>
  802c8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c91:	8b 40 04             	mov    0x4(%eax),%eax
  802c94:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c97:	8b 12                	mov    (%edx),%edx
  802c99:	89 10                	mov    %edx,(%eax)
  802c9b:	eb 0a                	jmp    802ca7 <alloc_block_NF+0x47f>
  802c9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca0:	8b 00                	mov    (%eax),%eax
  802ca2:	a3 38 51 80 00       	mov    %eax,0x805138
  802ca7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802caa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cba:	a1 44 51 80 00       	mov    0x805144,%eax
  802cbf:	48                   	dec    %eax
  802cc0:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802cc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc8:	8b 40 08             	mov    0x8(%eax),%eax
  802ccb:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802cd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd3:	e9 1b 01 00 00       	jmp    802df3 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802cd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cdb:	8b 40 0c             	mov    0xc(%eax),%eax
  802cde:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ce1:	0f 86 d1 00 00 00    	jbe    802db8 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802ce7:	a1 48 51 80 00       	mov    0x805148,%eax
  802cec:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802cef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf2:	8b 50 08             	mov    0x8(%eax),%edx
  802cf5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cf8:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802cfb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cfe:	8b 55 08             	mov    0x8(%ebp),%edx
  802d01:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802d04:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802d08:	75 17                	jne    802d21 <alloc_block_NF+0x4f9>
  802d0a:	83 ec 04             	sub    $0x4,%esp
  802d0d:	68 50 43 80 00       	push   $0x804350
  802d12:	68 1c 01 00 00       	push   $0x11c
  802d17:	68 a7 42 80 00       	push   $0x8042a7
  802d1c:	e8 9a d7 ff ff       	call   8004bb <_panic>
  802d21:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d24:	8b 00                	mov    (%eax),%eax
  802d26:	85 c0                	test   %eax,%eax
  802d28:	74 10                	je     802d3a <alloc_block_NF+0x512>
  802d2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d2d:	8b 00                	mov    (%eax),%eax
  802d2f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d32:	8b 52 04             	mov    0x4(%edx),%edx
  802d35:	89 50 04             	mov    %edx,0x4(%eax)
  802d38:	eb 0b                	jmp    802d45 <alloc_block_NF+0x51d>
  802d3a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d3d:	8b 40 04             	mov    0x4(%eax),%eax
  802d40:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d45:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d48:	8b 40 04             	mov    0x4(%eax),%eax
  802d4b:	85 c0                	test   %eax,%eax
  802d4d:	74 0f                	je     802d5e <alloc_block_NF+0x536>
  802d4f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d52:	8b 40 04             	mov    0x4(%eax),%eax
  802d55:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d58:	8b 12                	mov    (%edx),%edx
  802d5a:	89 10                	mov    %edx,(%eax)
  802d5c:	eb 0a                	jmp    802d68 <alloc_block_NF+0x540>
  802d5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d61:	8b 00                	mov    (%eax),%eax
  802d63:	a3 48 51 80 00       	mov    %eax,0x805148
  802d68:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d6b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d71:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d74:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d7b:	a1 54 51 80 00       	mov    0x805154,%eax
  802d80:	48                   	dec    %eax
  802d81:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802d86:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d89:	8b 40 08             	mov    0x8(%eax),%eax
  802d8c:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802d91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d94:	8b 50 08             	mov    0x8(%eax),%edx
  802d97:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9a:	01 c2                	add    %eax,%edx
  802d9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9f:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802da2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da5:	8b 40 0c             	mov    0xc(%eax),%eax
  802da8:	2b 45 08             	sub    0x8(%ebp),%eax
  802dab:	89 c2                	mov    %eax,%edx
  802dad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db0:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802db3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802db6:	eb 3b                	jmp    802df3 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802db8:	a1 40 51 80 00       	mov    0x805140,%eax
  802dbd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802dc0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dc4:	74 07                	je     802dcd <alloc_block_NF+0x5a5>
  802dc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc9:	8b 00                	mov    (%eax),%eax
  802dcb:	eb 05                	jmp    802dd2 <alloc_block_NF+0x5aa>
  802dcd:	b8 00 00 00 00       	mov    $0x0,%eax
  802dd2:	a3 40 51 80 00       	mov    %eax,0x805140
  802dd7:	a1 40 51 80 00       	mov    0x805140,%eax
  802ddc:	85 c0                	test   %eax,%eax
  802dde:	0f 85 2e fe ff ff    	jne    802c12 <alloc_block_NF+0x3ea>
  802de4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802de8:	0f 85 24 fe ff ff    	jne    802c12 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802dee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802df3:	c9                   	leave  
  802df4:	c3                   	ret    

00802df5 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802df5:	55                   	push   %ebp
  802df6:	89 e5                	mov    %esp,%ebp
  802df8:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802dfb:	a1 38 51 80 00       	mov    0x805138,%eax
  802e00:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802e03:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802e08:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802e0b:	a1 38 51 80 00       	mov    0x805138,%eax
  802e10:	85 c0                	test   %eax,%eax
  802e12:	74 14                	je     802e28 <insert_sorted_with_merge_freeList+0x33>
  802e14:	8b 45 08             	mov    0x8(%ebp),%eax
  802e17:	8b 50 08             	mov    0x8(%eax),%edx
  802e1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e1d:	8b 40 08             	mov    0x8(%eax),%eax
  802e20:	39 c2                	cmp    %eax,%edx
  802e22:	0f 87 9b 01 00 00    	ja     802fc3 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802e28:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e2c:	75 17                	jne    802e45 <insert_sorted_with_merge_freeList+0x50>
  802e2e:	83 ec 04             	sub    $0x4,%esp
  802e31:	68 84 42 80 00       	push   $0x804284
  802e36:	68 38 01 00 00       	push   $0x138
  802e3b:	68 a7 42 80 00       	push   $0x8042a7
  802e40:	e8 76 d6 ff ff       	call   8004bb <_panic>
  802e45:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4e:	89 10                	mov    %edx,(%eax)
  802e50:	8b 45 08             	mov    0x8(%ebp),%eax
  802e53:	8b 00                	mov    (%eax),%eax
  802e55:	85 c0                	test   %eax,%eax
  802e57:	74 0d                	je     802e66 <insert_sorted_with_merge_freeList+0x71>
  802e59:	a1 38 51 80 00       	mov    0x805138,%eax
  802e5e:	8b 55 08             	mov    0x8(%ebp),%edx
  802e61:	89 50 04             	mov    %edx,0x4(%eax)
  802e64:	eb 08                	jmp    802e6e <insert_sorted_with_merge_freeList+0x79>
  802e66:	8b 45 08             	mov    0x8(%ebp),%eax
  802e69:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e71:	a3 38 51 80 00       	mov    %eax,0x805138
  802e76:	8b 45 08             	mov    0x8(%ebp),%eax
  802e79:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e80:	a1 44 51 80 00       	mov    0x805144,%eax
  802e85:	40                   	inc    %eax
  802e86:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802e8b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e8f:	0f 84 a8 06 00 00    	je     80353d <insert_sorted_with_merge_freeList+0x748>
  802e95:	8b 45 08             	mov    0x8(%ebp),%eax
  802e98:	8b 50 08             	mov    0x8(%eax),%edx
  802e9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9e:	8b 40 0c             	mov    0xc(%eax),%eax
  802ea1:	01 c2                	add    %eax,%edx
  802ea3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ea6:	8b 40 08             	mov    0x8(%eax),%eax
  802ea9:	39 c2                	cmp    %eax,%edx
  802eab:	0f 85 8c 06 00 00    	jne    80353d <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb4:	8b 50 0c             	mov    0xc(%eax),%edx
  802eb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eba:	8b 40 0c             	mov    0xc(%eax),%eax
  802ebd:	01 c2                	add    %eax,%edx
  802ebf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec2:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802ec5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ec9:	75 17                	jne    802ee2 <insert_sorted_with_merge_freeList+0xed>
  802ecb:	83 ec 04             	sub    $0x4,%esp
  802ece:	68 50 43 80 00       	push   $0x804350
  802ed3:	68 3c 01 00 00       	push   $0x13c
  802ed8:	68 a7 42 80 00       	push   $0x8042a7
  802edd:	e8 d9 d5 ff ff       	call   8004bb <_panic>
  802ee2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ee5:	8b 00                	mov    (%eax),%eax
  802ee7:	85 c0                	test   %eax,%eax
  802ee9:	74 10                	je     802efb <insert_sorted_with_merge_freeList+0x106>
  802eeb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eee:	8b 00                	mov    (%eax),%eax
  802ef0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ef3:	8b 52 04             	mov    0x4(%edx),%edx
  802ef6:	89 50 04             	mov    %edx,0x4(%eax)
  802ef9:	eb 0b                	jmp    802f06 <insert_sorted_with_merge_freeList+0x111>
  802efb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802efe:	8b 40 04             	mov    0x4(%eax),%eax
  802f01:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f09:	8b 40 04             	mov    0x4(%eax),%eax
  802f0c:	85 c0                	test   %eax,%eax
  802f0e:	74 0f                	je     802f1f <insert_sorted_with_merge_freeList+0x12a>
  802f10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f13:	8b 40 04             	mov    0x4(%eax),%eax
  802f16:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f19:	8b 12                	mov    (%edx),%edx
  802f1b:	89 10                	mov    %edx,(%eax)
  802f1d:	eb 0a                	jmp    802f29 <insert_sorted_with_merge_freeList+0x134>
  802f1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f22:	8b 00                	mov    (%eax),%eax
  802f24:	a3 38 51 80 00       	mov    %eax,0x805138
  802f29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f2c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f35:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f3c:	a1 44 51 80 00       	mov    0x805144,%eax
  802f41:	48                   	dec    %eax
  802f42:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802f47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f4a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802f51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f54:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802f5b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f5f:	75 17                	jne    802f78 <insert_sorted_with_merge_freeList+0x183>
  802f61:	83 ec 04             	sub    $0x4,%esp
  802f64:	68 84 42 80 00       	push   $0x804284
  802f69:	68 3f 01 00 00       	push   $0x13f
  802f6e:	68 a7 42 80 00       	push   $0x8042a7
  802f73:	e8 43 d5 ff ff       	call   8004bb <_panic>
  802f78:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802f7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f81:	89 10                	mov    %edx,(%eax)
  802f83:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f86:	8b 00                	mov    (%eax),%eax
  802f88:	85 c0                	test   %eax,%eax
  802f8a:	74 0d                	je     802f99 <insert_sorted_with_merge_freeList+0x1a4>
  802f8c:	a1 48 51 80 00       	mov    0x805148,%eax
  802f91:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f94:	89 50 04             	mov    %edx,0x4(%eax)
  802f97:	eb 08                	jmp    802fa1 <insert_sorted_with_merge_freeList+0x1ac>
  802f99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f9c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802fa1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fa4:	a3 48 51 80 00       	mov    %eax,0x805148
  802fa9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fac:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fb3:	a1 54 51 80 00       	mov    0x805154,%eax
  802fb8:	40                   	inc    %eax
  802fb9:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802fbe:	e9 7a 05 00 00       	jmp    80353d <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802fc3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc6:	8b 50 08             	mov    0x8(%eax),%edx
  802fc9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fcc:	8b 40 08             	mov    0x8(%eax),%eax
  802fcf:	39 c2                	cmp    %eax,%edx
  802fd1:	0f 82 14 01 00 00    	jb     8030eb <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802fd7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fda:	8b 50 08             	mov    0x8(%eax),%edx
  802fdd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fe0:	8b 40 0c             	mov    0xc(%eax),%eax
  802fe3:	01 c2                	add    %eax,%edx
  802fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe8:	8b 40 08             	mov    0x8(%eax),%eax
  802feb:	39 c2                	cmp    %eax,%edx
  802fed:	0f 85 90 00 00 00    	jne    803083 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802ff3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ff6:	8b 50 0c             	mov    0xc(%eax),%edx
  802ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffc:	8b 40 0c             	mov    0xc(%eax),%eax
  802fff:	01 c2                	add    %eax,%edx
  803001:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803004:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  803007:	8b 45 08             	mov    0x8(%ebp),%eax
  80300a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  803011:	8b 45 08             	mov    0x8(%ebp),%eax
  803014:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80301b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80301f:	75 17                	jne    803038 <insert_sorted_with_merge_freeList+0x243>
  803021:	83 ec 04             	sub    $0x4,%esp
  803024:	68 84 42 80 00       	push   $0x804284
  803029:	68 49 01 00 00       	push   $0x149
  80302e:	68 a7 42 80 00       	push   $0x8042a7
  803033:	e8 83 d4 ff ff       	call   8004bb <_panic>
  803038:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80303e:	8b 45 08             	mov    0x8(%ebp),%eax
  803041:	89 10                	mov    %edx,(%eax)
  803043:	8b 45 08             	mov    0x8(%ebp),%eax
  803046:	8b 00                	mov    (%eax),%eax
  803048:	85 c0                	test   %eax,%eax
  80304a:	74 0d                	je     803059 <insert_sorted_with_merge_freeList+0x264>
  80304c:	a1 48 51 80 00       	mov    0x805148,%eax
  803051:	8b 55 08             	mov    0x8(%ebp),%edx
  803054:	89 50 04             	mov    %edx,0x4(%eax)
  803057:	eb 08                	jmp    803061 <insert_sorted_with_merge_freeList+0x26c>
  803059:	8b 45 08             	mov    0x8(%ebp),%eax
  80305c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803061:	8b 45 08             	mov    0x8(%ebp),%eax
  803064:	a3 48 51 80 00       	mov    %eax,0x805148
  803069:	8b 45 08             	mov    0x8(%ebp),%eax
  80306c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803073:	a1 54 51 80 00       	mov    0x805154,%eax
  803078:	40                   	inc    %eax
  803079:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80307e:	e9 bb 04 00 00       	jmp    80353e <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803083:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803087:	75 17                	jne    8030a0 <insert_sorted_with_merge_freeList+0x2ab>
  803089:	83 ec 04             	sub    $0x4,%esp
  80308c:	68 f8 42 80 00       	push   $0x8042f8
  803091:	68 4c 01 00 00       	push   $0x14c
  803096:	68 a7 42 80 00       	push   $0x8042a7
  80309b:	e8 1b d4 ff ff       	call   8004bb <_panic>
  8030a0:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8030a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a9:	89 50 04             	mov    %edx,0x4(%eax)
  8030ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8030af:	8b 40 04             	mov    0x4(%eax),%eax
  8030b2:	85 c0                	test   %eax,%eax
  8030b4:	74 0c                	je     8030c2 <insert_sorted_with_merge_freeList+0x2cd>
  8030b6:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8030bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8030be:	89 10                	mov    %edx,(%eax)
  8030c0:	eb 08                	jmp    8030ca <insert_sorted_with_merge_freeList+0x2d5>
  8030c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c5:	a3 38 51 80 00       	mov    %eax,0x805138
  8030ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8030cd:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030db:	a1 44 51 80 00       	mov    0x805144,%eax
  8030e0:	40                   	inc    %eax
  8030e1:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8030e6:	e9 53 04 00 00       	jmp    80353e <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8030eb:	a1 38 51 80 00       	mov    0x805138,%eax
  8030f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030f3:	e9 15 04 00 00       	jmp    80350d <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  8030f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030fb:	8b 00                	mov    (%eax),%eax
  8030fd:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803100:	8b 45 08             	mov    0x8(%ebp),%eax
  803103:	8b 50 08             	mov    0x8(%eax),%edx
  803106:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803109:	8b 40 08             	mov    0x8(%eax),%eax
  80310c:	39 c2                	cmp    %eax,%edx
  80310e:	0f 86 f1 03 00 00    	jbe    803505 <insert_sorted_with_merge_freeList+0x710>
  803114:	8b 45 08             	mov    0x8(%ebp),%eax
  803117:	8b 50 08             	mov    0x8(%eax),%edx
  80311a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80311d:	8b 40 08             	mov    0x8(%eax),%eax
  803120:	39 c2                	cmp    %eax,%edx
  803122:	0f 83 dd 03 00 00    	jae    803505 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803128:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80312b:	8b 50 08             	mov    0x8(%eax),%edx
  80312e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803131:	8b 40 0c             	mov    0xc(%eax),%eax
  803134:	01 c2                	add    %eax,%edx
  803136:	8b 45 08             	mov    0x8(%ebp),%eax
  803139:	8b 40 08             	mov    0x8(%eax),%eax
  80313c:	39 c2                	cmp    %eax,%edx
  80313e:	0f 85 b9 01 00 00    	jne    8032fd <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803144:	8b 45 08             	mov    0x8(%ebp),%eax
  803147:	8b 50 08             	mov    0x8(%eax),%edx
  80314a:	8b 45 08             	mov    0x8(%ebp),%eax
  80314d:	8b 40 0c             	mov    0xc(%eax),%eax
  803150:	01 c2                	add    %eax,%edx
  803152:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803155:	8b 40 08             	mov    0x8(%eax),%eax
  803158:	39 c2                	cmp    %eax,%edx
  80315a:	0f 85 0d 01 00 00    	jne    80326d <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803160:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803163:	8b 50 0c             	mov    0xc(%eax),%edx
  803166:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803169:	8b 40 0c             	mov    0xc(%eax),%eax
  80316c:	01 c2                	add    %eax,%edx
  80316e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803171:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803174:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803178:	75 17                	jne    803191 <insert_sorted_with_merge_freeList+0x39c>
  80317a:	83 ec 04             	sub    $0x4,%esp
  80317d:	68 50 43 80 00       	push   $0x804350
  803182:	68 5c 01 00 00       	push   $0x15c
  803187:	68 a7 42 80 00       	push   $0x8042a7
  80318c:	e8 2a d3 ff ff       	call   8004bb <_panic>
  803191:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803194:	8b 00                	mov    (%eax),%eax
  803196:	85 c0                	test   %eax,%eax
  803198:	74 10                	je     8031aa <insert_sorted_with_merge_freeList+0x3b5>
  80319a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80319d:	8b 00                	mov    (%eax),%eax
  80319f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031a2:	8b 52 04             	mov    0x4(%edx),%edx
  8031a5:	89 50 04             	mov    %edx,0x4(%eax)
  8031a8:	eb 0b                	jmp    8031b5 <insert_sorted_with_merge_freeList+0x3c0>
  8031aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ad:	8b 40 04             	mov    0x4(%eax),%eax
  8031b0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031b8:	8b 40 04             	mov    0x4(%eax),%eax
  8031bb:	85 c0                	test   %eax,%eax
  8031bd:	74 0f                	je     8031ce <insert_sorted_with_merge_freeList+0x3d9>
  8031bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c2:	8b 40 04             	mov    0x4(%eax),%eax
  8031c5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031c8:	8b 12                	mov    (%edx),%edx
  8031ca:	89 10                	mov    %edx,(%eax)
  8031cc:	eb 0a                	jmp    8031d8 <insert_sorted_with_merge_freeList+0x3e3>
  8031ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d1:	8b 00                	mov    (%eax),%eax
  8031d3:	a3 38 51 80 00       	mov    %eax,0x805138
  8031d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031db:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031eb:	a1 44 51 80 00       	mov    0x805144,%eax
  8031f0:	48                   	dec    %eax
  8031f1:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  8031f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803200:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803203:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80320a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80320e:	75 17                	jne    803227 <insert_sorted_with_merge_freeList+0x432>
  803210:	83 ec 04             	sub    $0x4,%esp
  803213:	68 84 42 80 00       	push   $0x804284
  803218:	68 5f 01 00 00       	push   $0x15f
  80321d:	68 a7 42 80 00       	push   $0x8042a7
  803222:	e8 94 d2 ff ff       	call   8004bb <_panic>
  803227:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80322d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803230:	89 10                	mov    %edx,(%eax)
  803232:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803235:	8b 00                	mov    (%eax),%eax
  803237:	85 c0                	test   %eax,%eax
  803239:	74 0d                	je     803248 <insert_sorted_with_merge_freeList+0x453>
  80323b:	a1 48 51 80 00       	mov    0x805148,%eax
  803240:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803243:	89 50 04             	mov    %edx,0x4(%eax)
  803246:	eb 08                	jmp    803250 <insert_sorted_with_merge_freeList+0x45b>
  803248:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80324b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803250:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803253:	a3 48 51 80 00       	mov    %eax,0x805148
  803258:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80325b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803262:	a1 54 51 80 00       	mov    0x805154,%eax
  803267:	40                   	inc    %eax
  803268:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  80326d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803270:	8b 50 0c             	mov    0xc(%eax),%edx
  803273:	8b 45 08             	mov    0x8(%ebp),%eax
  803276:	8b 40 0c             	mov    0xc(%eax),%eax
  803279:	01 c2                	add    %eax,%edx
  80327b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80327e:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803281:	8b 45 08             	mov    0x8(%ebp),%eax
  803284:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  80328b:	8b 45 08             	mov    0x8(%ebp),%eax
  80328e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803295:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803299:	75 17                	jne    8032b2 <insert_sorted_with_merge_freeList+0x4bd>
  80329b:	83 ec 04             	sub    $0x4,%esp
  80329e:	68 84 42 80 00       	push   $0x804284
  8032a3:	68 64 01 00 00       	push   $0x164
  8032a8:	68 a7 42 80 00       	push   $0x8042a7
  8032ad:	e8 09 d2 ff ff       	call   8004bb <_panic>
  8032b2:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8032b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032bb:	89 10                	mov    %edx,(%eax)
  8032bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c0:	8b 00                	mov    (%eax),%eax
  8032c2:	85 c0                	test   %eax,%eax
  8032c4:	74 0d                	je     8032d3 <insert_sorted_with_merge_freeList+0x4de>
  8032c6:	a1 48 51 80 00       	mov    0x805148,%eax
  8032cb:	8b 55 08             	mov    0x8(%ebp),%edx
  8032ce:	89 50 04             	mov    %edx,0x4(%eax)
  8032d1:	eb 08                	jmp    8032db <insert_sorted_with_merge_freeList+0x4e6>
  8032d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032db:	8b 45 08             	mov    0x8(%ebp),%eax
  8032de:	a3 48 51 80 00       	mov    %eax,0x805148
  8032e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032ed:	a1 54 51 80 00       	mov    0x805154,%eax
  8032f2:	40                   	inc    %eax
  8032f3:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8032f8:	e9 41 02 00 00       	jmp    80353e <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8032fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803300:	8b 50 08             	mov    0x8(%eax),%edx
  803303:	8b 45 08             	mov    0x8(%ebp),%eax
  803306:	8b 40 0c             	mov    0xc(%eax),%eax
  803309:	01 c2                	add    %eax,%edx
  80330b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80330e:	8b 40 08             	mov    0x8(%eax),%eax
  803311:	39 c2                	cmp    %eax,%edx
  803313:	0f 85 7c 01 00 00    	jne    803495 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803319:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80331d:	74 06                	je     803325 <insert_sorted_with_merge_freeList+0x530>
  80331f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803323:	75 17                	jne    80333c <insert_sorted_with_merge_freeList+0x547>
  803325:	83 ec 04             	sub    $0x4,%esp
  803328:	68 c0 42 80 00       	push   $0x8042c0
  80332d:	68 69 01 00 00       	push   $0x169
  803332:	68 a7 42 80 00       	push   $0x8042a7
  803337:	e8 7f d1 ff ff       	call   8004bb <_panic>
  80333c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80333f:	8b 50 04             	mov    0x4(%eax),%edx
  803342:	8b 45 08             	mov    0x8(%ebp),%eax
  803345:	89 50 04             	mov    %edx,0x4(%eax)
  803348:	8b 45 08             	mov    0x8(%ebp),%eax
  80334b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80334e:	89 10                	mov    %edx,(%eax)
  803350:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803353:	8b 40 04             	mov    0x4(%eax),%eax
  803356:	85 c0                	test   %eax,%eax
  803358:	74 0d                	je     803367 <insert_sorted_with_merge_freeList+0x572>
  80335a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80335d:	8b 40 04             	mov    0x4(%eax),%eax
  803360:	8b 55 08             	mov    0x8(%ebp),%edx
  803363:	89 10                	mov    %edx,(%eax)
  803365:	eb 08                	jmp    80336f <insert_sorted_with_merge_freeList+0x57a>
  803367:	8b 45 08             	mov    0x8(%ebp),%eax
  80336a:	a3 38 51 80 00       	mov    %eax,0x805138
  80336f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803372:	8b 55 08             	mov    0x8(%ebp),%edx
  803375:	89 50 04             	mov    %edx,0x4(%eax)
  803378:	a1 44 51 80 00       	mov    0x805144,%eax
  80337d:	40                   	inc    %eax
  80337e:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803383:	8b 45 08             	mov    0x8(%ebp),%eax
  803386:	8b 50 0c             	mov    0xc(%eax),%edx
  803389:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80338c:	8b 40 0c             	mov    0xc(%eax),%eax
  80338f:	01 c2                	add    %eax,%edx
  803391:	8b 45 08             	mov    0x8(%ebp),%eax
  803394:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803397:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80339b:	75 17                	jne    8033b4 <insert_sorted_with_merge_freeList+0x5bf>
  80339d:	83 ec 04             	sub    $0x4,%esp
  8033a0:	68 50 43 80 00       	push   $0x804350
  8033a5:	68 6b 01 00 00       	push   $0x16b
  8033aa:	68 a7 42 80 00       	push   $0x8042a7
  8033af:	e8 07 d1 ff ff       	call   8004bb <_panic>
  8033b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033b7:	8b 00                	mov    (%eax),%eax
  8033b9:	85 c0                	test   %eax,%eax
  8033bb:	74 10                	je     8033cd <insert_sorted_with_merge_freeList+0x5d8>
  8033bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033c0:	8b 00                	mov    (%eax),%eax
  8033c2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033c5:	8b 52 04             	mov    0x4(%edx),%edx
  8033c8:	89 50 04             	mov    %edx,0x4(%eax)
  8033cb:	eb 0b                	jmp    8033d8 <insert_sorted_with_merge_freeList+0x5e3>
  8033cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033d0:	8b 40 04             	mov    0x4(%eax),%eax
  8033d3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8033d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033db:	8b 40 04             	mov    0x4(%eax),%eax
  8033de:	85 c0                	test   %eax,%eax
  8033e0:	74 0f                	je     8033f1 <insert_sorted_with_merge_freeList+0x5fc>
  8033e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033e5:	8b 40 04             	mov    0x4(%eax),%eax
  8033e8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033eb:	8b 12                	mov    (%edx),%edx
  8033ed:	89 10                	mov    %edx,(%eax)
  8033ef:	eb 0a                	jmp    8033fb <insert_sorted_with_merge_freeList+0x606>
  8033f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033f4:	8b 00                	mov    (%eax),%eax
  8033f6:	a3 38 51 80 00       	mov    %eax,0x805138
  8033fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033fe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803404:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803407:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80340e:	a1 44 51 80 00       	mov    0x805144,%eax
  803413:	48                   	dec    %eax
  803414:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803419:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80341c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803423:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803426:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80342d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803431:	75 17                	jne    80344a <insert_sorted_with_merge_freeList+0x655>
  803433:	83 ec 04             	sub    $0x4,%esp
  803436:	68 84 42 80 00       	push   $0x804284
  80343b:	68 6e 01 00 00       	push   $0x16e
  803440:	68 a7 42 80 00       	push   $0x8042a7
  803445:	e8 71 d0 ff ff       	call   8004bb <_panic>
  80344a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803450:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803453:	89 10                	mov    %edx,(%eax)
  803455:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803458:	8b 00                	mov    (%eax),%eax
  80345a:	85 c0                	test   %eax,%eax
  80345c:	74 0d                	je     80346b <insert_sorted_with_merge_freeList+0x676>
  80345e:	a1 48 51 80 00       	mov    0x805148,%eax
  803463:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803466:	89 50 04             	mov    %edx,0x4(%eax)
  803469:	eb 08                	jmp    803473 <insert_sorted_with_merge_freeList+0x67e>
  80346b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80346e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803473:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803476:	a3 48 51 80 00       	mov    %eax,0x805148
  80347b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80347e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803485:	a1 54 51 80 00       	mov    0x805154,%eax
  80348a:	40                   	inc    %eax
  80348b:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803490:	e9 a9 00 00 00       	jmp    80353e <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803495:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803499:	74 06                	je     8034a1 <insert_sorted_with_merge_freeList+0x6ac>
  80349b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80349f:	75 17                	jne    8034b8 <insert_sorted_with_merge_freeList+0x6c3>
  8034a1:	83 ec 04             	sub    $0x4,%esp
  8034a4:	68 1c 43 80 00       	push   $0x80431c
  8034a9:	68 73 01 00 00       	push   $0x173
  8034ae:	68 a7 42 80 00       	push   $0x8042a7
  8034b3:	e8 03 d0 ff ff       	call   8004bb <_panic>
  8034b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034bb:	8b 10                	mov    (%eax),%edx
  8034bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c0:	89 10                	mov    %edx,(%eax)
  8034c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c5:	8b 00                	mov    (%eax),%eax
  8034c7:	85 c0                	test   %eax,%eax
  8034c9:	74 0b                	je     8034d6 <insert_sorted_with_merge_freeList+0x6e1>
  8034cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ce:	8b 00                	mov    (%eax),%eax
  8034d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8034d3:	89 50 04             	mov    %edx,0x4(%eax)
  8034d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8034dc:	89 10                	mov    %edx,(%eax)
  8034de:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034e4:	89 50 04             	mov    %edx,0x4(%eax)
  8034e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ea:	8b 00                	mov    (%eax),%eax
  8034ec:	85 c0                	test   %eax,%eax
  8034ee:	75 08                	jne    8034f8 <insert_sorted_with_merge_freeList+0x703>
  8034f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8034f8:	a1 44 51 80 00       	mov    0x805144,%eax
  8034fd:	40                   	inc    %eax
  8034fe:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803503:	eb 39                	jmp    80353e <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803505:	a1 40 51 80 00       	mov    0x805140,%eax
  80350a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80350d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803511:	74 07                	je     80351a <insert_sorted_with_merge_freeList+0x725>
  803513:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803516:	8b 00                	mov    (%eax),%eax
  803518:	eb 05                	jmp    80351f <insert_sorted_with_merge_freeList+0x72a>
  80351a:	b8 00 00 00 00       	mov    $0x0,%eax
  80351f:	a3 40 51 80 00       	mov    %eax,0x805140
  803524:	a1 40 51 80 00       	mov    0x805140,%eax
  803529:	85 c0                	test   %eax,%eax
  80352b:	0f 85 c7 fb ff ff    	jne    8030f8 <insert_sorted_with_merge_freeList+0x303>
  803531:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803535:	0f 85 bd fb ff ff    	jne    8030f8 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80353b:	eb 01                	jmp    80353e <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80353d:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80353e:	90                   	nop
  80353f:	c9                   	leave  
  803540:	c3                   	ret    

00803541 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803541:	55                   	push   %ebp
  803542:	89 e5                	mov    %esp,%ebp
  803544:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803547:	8b 55 08             	mov    0x8(%ebp),%edx
  80354a:	89 d0                	mov    %edx,%eax
  80354c:	c1 e0 02             	shl    $0x2,%eax
  80354f:	01 d0                	add    %edx,%eax
  803551:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803558:	01 d0                	add    %edx,%eax
  80355a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803561:	01 d0                	add    %edx,%eax
  803563:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80356a:	01 d0                	add    %edx,%eax
  80356c:	c1 e0 04             	shl    $0x4,%eax
  80356f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803572:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  803579:	8d 45 e8             	lea    -0x18(%ebp),%eax
  80357c:	83 ec 0c             	sub    $0xc,%esp
  80357f:	50                   	push   %eax
  803580:	e8 26 e7 ff ff       	call   801cab <sys_get_virtual_time>
  803585:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803588:	eb 41                	jmp    8035cb <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  80358a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80358d:	83 ec 0c             	sub    $0xc,%esp
  803590:	50                   	push   %eax
  803591:	e8 15 e7 ff ff       	call   801cab <sys_get_virtual_time>
  803596:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803599:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80359c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80359f:	29 c2                	sub    %eax,%edx
  8035a1:	89 d0                	mov    %edx,%eax
  8035a3:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8035a6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035ac:	89 d1                	mov    %edx,%ecx
  8035ae:	29 c1                	sub    %eax,%ecx
  8035b0:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8035b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035b6:	39 c2                	cmp    %eax,%edx
  8035b8:	0f 97 c0             	seta   %al
  8035bb:	0f b6 c0             	movzbl %al,%eax
  8035be:	29 c1                	sub    %eax,%ecx
  8035c0:	89 c8                	mov    %ecx,%eax
  8035c2:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8035c5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8035c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8035cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ce:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8035d1:	72 b7                	jb     80358a <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8035d3:	90                   	nop
  8035d4:	c9                   	leave  
  8035d5:	c3                   	ret    

008035d6 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8035d6:	55                   	push   %ebp
  8035d7:	89 e5                	mov    %esp,%ebp
  8035d9:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8035dc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8035e3:	eb 03                	jmp    8035e8 <busy_wait+0x12>
  8035e5:	ff 45 fc             	incl   -0x4(%ebp)
  8035e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8035eb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8035ee:	72 f5                	jb     8035e5 <busy_wait+0xf>
	return i;
  8035f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8035f3:	c9                   	leave  
  8035f4:	c3                   	ret    
  8035f5:	66 90                	xchg   %ax,%ax
  8035f7:	90                   	nop

008035f8 <__udivdi3>:
  8035f8:	55                   	push   %ebp
  8035f9:	57                   	push   %edi
  8035fa:	56                   	push   %esi
  8035fb:	53                   	push   %ebx
  8035fc:	83 ec 1c             	sub    $0x1c,%esp
  8035ff:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803603:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803607:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80360b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80360f:	89 ca                	mov    %ecx,%edx
  803611:	89 f8                	mov    %edi,%eax
  803613:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803617:	85 f6                	test   %esi,%esi
  803619:	75 2d                	jne    803648 <__udivdi3+0x50>
  80361b:	39 cf                	cmp    %ecx,%edi
  80361d:	77 65                	ja     803684 <__udivdi3+0x8c>
  80361f:	89 fd                	mov    %edi,%ebp
  803621:	85 ff                	test   %edi,%edi
  803623:	75 0b                	jne    803630 <__udivdi3+0x38>
  803625:	b8 01 00 00 00       	mov    $0x1,%eax
  80362a:	31 d2                	xor    %edx,%edx
  80362c:	f7 f7                	div    %edi
  80362e:	89 c5                	mov    %eax,%ebp
  803630:	31 d2                	xor    %edx,%edx
  803632:	89 c8                	mov    %ecx,%eax
  803634:	f7 f5                	div    %ebp
  803636:	89 c1                	mov    %eax,%ecx
  803638:	89 d8                	mov    %ebx,%eax
  80363a:	f7 f5                	div    %ebp
  80363c:	89 cf                	mov    %ecx,%edi
  80363e:	89 fa                	mov    %edi,%edx
  803640:	83 c4 1c             	add    $0x1c,%esp
  803643:	5b                   	pop    %ebx
  803644:	5e                   	pop    %esi
  803645:	5f                   	pop    %edi
  803646:	5d                   	pop    %ebp
  803647:	c3                   	ret    
  803648:	39 ce                	cmp    %ecx,%esi
  80364a:	77 28                	ja     803674 <__udivdi3+0x7c>
  80364c:	0f bd fe             	bsr    %esi,%edi
  80364f:	83 f7 1f             	xor    $0x1f,%edi
  803652:	75 40                	jne    803694 <__udivdi3+0x9c>
  803654:	39 ce                	cmp    %ecx,%esi
  803656:	72 0a                	jb     803662 <__udivdi3+0x6a>
  803658:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80365c:	0f 87 9e 00 00 00    	ja     803700 <__udivdi3+0x108>
  803662:	b8 01 00 00 00       	mov    $0x1,%eax
  803667:	89 fa                	mov    %edi,%edx
  803669:	83 c4 1c             	add    $0x1c,%esp
  80366c:	5b                   	pop    %ebx
  80366d:	5e                   	pop    %esi
  80366e:	5f                   	pop    %edi
  80366f:	5d                   	pop    %ebp
  803670:	c3                   	ret    
  803671:	8d 76 00             	lea    0x0(%esi),%esi
  803674:	31 ff                	xor    %edi,%edi
  803676:	31 c0                	xor    %eax,%eax
  803678:	89 fa                	mov    %edi,%edx
  80367a:	83 c4 1c             	add    $0x1c,%esp
  80367d:	5b                   	pop    %ebx
  80367e:	5e                   	pop    %esi
  80367f:	5f                   	pop    %edi
  803680:	5d                   	pop    %ebp
  803681:	c3                   	ret    
  803682:	66 90                	xchg   %ax,%ax
  803684:	89 d8                	mov    %ebx,%eax
  803686:	f7 f7                	div    %edi
  803688:	31 ff                	xor    %edi,%edi
  80368a:	89 fa                	mov    %edi,%edx
  80368c:	83 c4 1c             	add    $0x1c,%esp
  80368f:	5b                   	pop    %ebx
  803690:	5e                   	pop    %esi
  803691:	5f                   	pop    %edi
  803692:	5d                   	pop    %ebp
  803693:	c3                   	ret    
  803694:	bd 20 00 00 00       	mov    $0x20,%ebp
  803699:	89 eb                	mov    %ebp,%ebx
  80369b:	29 fb                	sub    %edi,%ebx
  80369d:	89 f9                	mov    %edi,%ecx
  80369f:	d3 e6                	shl    %cl,%esi
  8036a1:	89 c5                	mov    %eax,%ebp
  8036a3:	88 d9                	mov    %bl,%cl
  8036a5:	d3 ed                	shr    %cl,%ebp
  8036a7:	89 e9                	mov    %ebp,%ecx
  8036a9:	09 f1                	or     %esi,%ecx
  8036ab:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8036af:	89 f9                	mov    %edi,%ecx
  8036b1:	d3 e0                	shl    %cl,%eax
  8036b3:	89 c5                	mov    %eax,%ebp
  8036b5:	89 d6                	mov    %edx,%esi
  8036b7:	88 d9                	mov    %bl,%cl
  8036b9:	d3 ee                	shr    %cl,%esi
  8036bb:	89 f9                	mov    %edi,%ecx
  8036bd:	d3 e2                	shl    %cl,%edx
  8036bf:	8b 44 24 08          	mov    0x8(%esp),%eax
  8036c3:	88 d9                	mov    %bl,%cl
  8036c5:	d3 e8                	shr    %cl,%eax
  8036c7:	09 c2                	or     %eax,%edx
  8036c9:	89 d0                	mov    %edx,%eax
  8036cb:	89 f2                	mov    %esi,%edx
  8036cd:	f7 74 24 0c          	divl   0xc(%esp)
  8036d1:	89 d6                	mov    %edx,%esi
  8036d3:	89 c3                	mov    %eax,%ebx
  8036d5:	f7 e5                	mul    %ebp
  8036d7:	39 d6                	cmp    %edx,%esi
  8036d9:	72 19                	jb     8036f4 <__udivdi3+0xfc>
  8036db:	74 0b                	je     8036e8 <__udivdi3+0xf0>
  8036dd:	89 d8                	mov    %ebx,%eax
  8036df:	31 ff                	xor    %edi,%edi
  8036e1:	e9 58 ff ff ff       	jmp    80363e <__udivdi3+0x46>
  8036e6:	66 90                	xchg   %ax,%ax
  8036e8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8036ec:	89 f9                	mov    %edi,%ecx
  8036ee:	d3 e2                	shl    %cl,%edx
  8036f0:	39 c2                	cmp    %eax,%edx
  8036f2:	73 e9                	jae    8036dd <__udivdi3+0xe5>
  8036f4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8036f7:	31 ff                	xor    %edi,%edi
  8036f9:	e9 40 ff ff ff       	jmp    80363e <__udivdi3+0x46>
  8036fe:	66 90                	xchg   %ax,%ax
  803700:	31 c0                	xor    %eax,%eax
  803702:	e9 37 ff ff ff       	jmp    80363e <__udivdi3+0x46>
  803707:	90                   	nop

00803708 <__umoddi3>:
  803708:	55                   	push   %ebp
  803709:	57                   	push   %edi
  80370a:	56                   	push   %esi
  80370b:	53                   	push   %ebx
  80370c:	83 ec 1c             	sub    $0x1c,%esp
  80370f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803713:	8b 74 24 34          	mov    0x34(%esp),%esi
  803717:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80371b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80371f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803723:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803727:	89 f3                	mov    %esi,%ebx
  803729:	89 fa                	mov    %edi,%edx
  80372b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80372f:	89 34 24             	mov    %esi,(%esp)
  803732:	85 c0                	test   %eax,%eax
  803734:	75 1a                	jne    803750 <__umoddi3+0x48>
  803736:	39 f7                	cmp    %esi,%edi
  803738:	0f 86 a2 00 00 00    	jbe    8037e0 <__umoddi3+0xd8>
  80373e:	89 c8                	mov    %ecx,%eax
  803740:	89 f2                	mov    %esi,%edx
  803742:	f7 f7                	div    %edi
  803744:	89 d0                	mov    %edx,%eax
  803746:	31 d2                	xor    %edx,%edx
  803748:	83 c4 1c             	add    $0x1c,%esp
  80374b:	5b                   	pop    %ebx
  80374c:	5e                   	pop    %esi
  80374d:	5f                   	pop    %edi
  80374e:	5d                   	pop    %ebp
  80374f:	c3                   	ret    
  803750:	39 f0                	cmp    %esi,%eax
  803752:	0f 87 ac 00 00 00    	ja     803804 <__umoddi3+0xfc>
  803758:	0f bd e8             	bsr    %eax,%ebp
  80375b:	83 f5 1f             	xor    $0x1f,%ebp
  80375e:	0f 84 ac 00 00 00    	je     803810 <__umoddi3+0x108>
  803764:	bf 20 00 00 00       	mov    $0x20,%edi
  803769:	29 ef                	sub    %ebp,%edi
  80376b:	89 fe                	mov    %edi,%esi
  80376d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803771:	89 e9                	mov    %ebp,%ecx
  803773:	d3 e0                	shl    %cl,%eax
  803775:	89 d7                	mov    %edx,%edi
  803777:	89 f1                	mov    %esi,%ecx
  803779:	d3 ef                	shr    %cl,%edi
  80377b:	09 c7                	or     %eax,%edi
  80377d:	89 e9                	mov    %ebp,%ecx
  80377f:	d3 e2                	shl    %cl,%edx
  803781:	89 14 24             	mov    %edx,(%esp)
  803784:	89 d8                	mov    %ebx,%eax
  803786:	d3 e0                	shl    %cl,%eax
  803788:	89 c2                	mov    %eax,%edx
  80378a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80378e:	d3 e0                	shl    %cl,%eax
  803790:	89 44 24 04          	mov    %eax,0x4(%esp)
  803794:	8b 44 24 08          	mov    0x8(%esp),%eax
  803798:	89 f1                	mov    %esi,%ecx
  80379a:	d3 e8                	shr    %cl,%eax
  80379c:	09 d0                	or     %edx,%eax
  80379e:	d3 eb                	shr    %cl,%ebx
  8037a0:	89 da                	mov    %ebx,%edx
  8037a2:	f7 f7                	div    %edi
  8037a4:	89 d3                	mov    %edx,%ebx
  8037a6:	f7 24 24             	mull   (%esp)
  8037a9:	89 c6                	mov    %eax,%esi
  8037ab:	89 d1                	mov    %edx,%ecx
  8037ad:	39 d3                	cmp    %edx,%ebx
  8037af:	0f 82 87 00 00 00    	jb     80383c <__umoddi3+0x134>
  8037b5:	0f 84 91 00 00 00    	je     80384c <__umoddi3+0x144>
  8037bb:	8b 54 24 04          	mov    0x4(%esp),%edx
  8037bf:	29 f2                	sub    %esi,%edx
  8037c1:	19 cb                	sbb    %ecx,%ebx
  8037c3:	89 d8                	mov    %ebx,%eax
  8037c5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8037c9:	d3 e0                	shl    %cl,%eax
  8037cb:	89 e9                	mov    %ebp,%ecx
  8037cd:	d3 ea                	shr    %cl,%edx
  8037cf:	09 d0                	or     %edx,%eax
  8037d1:	89 e9                	mov    %ebp,%ecx
  8037d3:	d3 eb                	shr    %cl,%ebx
  8037d5:	89 da                	mov    %ebx,%edx
  8037d7:	83 c4 1c             	add    $0x1c,%esp
  8037da:	5b                   	pop    %ebx
  8037db:	5e                   	pop    %esi
  8037dc:	5f                   	pop    %edi
  8037dd:	5d                   	pop    %ebp
  8037de:	c3                   	ret    
  8037df:	90                   	nop
  8037e0:	89 fd                	mov    %edi,%ebp
  8037e2:	85 ff                	test   %edi,%edi
  8037e4:	75 0b                	jne    8037f1 <__umoddi3+0xe9>
  8037e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8037eb:	31 d2                	xor    %edx,%edx
  8037ed:	f7 f7                	div    %edi
  8037ef:	89 c5                	mov    %eax,%ebp
  8037f1:	89 f0                	mov    %esi,%eax
  8037f3:	31 d2                	xor    %edx,%edx
  8037f5:	f7 f5                	div    %ebp
  8037f7:	89 c8                	mov    %ecx,%eax
  8037f9:	f7 f5                	div    %ebp
  8037fb:	89 d0                	mov    %edx,%eax
  8037fd:	e9 44 ff ff ff       	jmp    803746 <__umoddi3+0x3e>
  803802:	66 90                	xchg   %ax,%ax
  803804:	89 c8                	mov    %ecx,%eax
  803806:	89 f2                	mov    %esi,%edx
  803808:	83 c4 1c             	add    $0x1c,%esp
  80380b:	5b                   	pop    %ebx
  80380c:	5e                   	pop    %esi
  80380d:	5f                   	pop    %edi
  80380e:	5d                   	pop    %ebp
  80380f:	c3                   	ret    
  803810:	3b 04 24             	cmp    (%esp),%eax
  803813:	72 06                	jb     80381b <__umoddi3+0x113>
  803815:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803819:	77 0f                	ja     80382a <__umoddi3+0x122>
  80381b:	89 f2                	mov    %esi,%edx
  80381d:	29 f9                	sub    %edi,%ecx
  80381f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803823:	89 14 24             	mov    %edx,(%esp)
  803826:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80382a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80382e:	8b 14 24             	mov    (%esp),%edx
  803831:	83 c4 1c             	add    $0x1c,%esp
  803834:	5b                   	pop    %ebx
  803835:	5e                   	pop    %esi
  803836:	5f                   	pop    %edi
  803837:	5d                   	pop    %ebp
  803838:	c3                   	ret    
  803839:	8d 76 00             	lea    0x0(%esi),%esi
  80383c:	2b 04 24             	sub    (%esp),%eax
  80383f:	19 fa                	sbb    %edi,%edx
  803841:	89 d1                	mov    %edx,%ecx
  803843:	89 c6                	mov    %eax,%esi
  803845:	e9 71 ff ff ff       	jmp    8037bb <__umoddi3+0xb3>
  80384a:	66 90                	xchg   %ax,%ax
  80384c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803850:	72 ea                	jb     80383c <__umoddi3+0x134>
  803852:	89 d9                	mov    %ebx,%ecx
  803854:	e9 62 ff ff ff       	jmp    8037bb <__umoddi3+0xb3>
