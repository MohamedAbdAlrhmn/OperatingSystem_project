
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
  80008d:	68 80 38 80 00       	push   $0x803880
  800092:	6a 13                	push   $0x13
  800094:	68 9c 38 80 00       	push   $0x80389c
  800099:	e8 1d 04 00 00       	call   8004bb <_panic>
	}
	uint32 *x, *y, *z ;

	//x: Readonly
	int freeFrames = sys_calculate_free_frames() ;
  80009e:	e8 01 19 00 00       	call   8019a4 <sys_calculate_free_frames>
  8000a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	x = smalloc("x", 4, 0);
  8000a6:	83 ec 04             	sub    $0x4,%esp
  8000a9:	6a 00                	push   $0x0
  8000ab:	6a 04                	push   $0x4
  8000ad:	68 ba 38 80 00       	push   $0x8038ba
  8000b2:	e8 88 16 00 00       	call   80173f <smalloc>
  8000b7:	83 c4 10             	add    $0x10,%esp
  8000ba:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if (x != (uint32*)USER_HEAP_START) panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8000bd:	81 7d e8 00 00 00 80 	cmpl   $0x80000000,-0x18(%ebp)
  8000c4:	74 14                	je     8000da <_main+0xa2>
  8000c6:	83 ec 04             	sub    $0x4,%esp
  8000c9:	68 bc 38 80 00       	push   $0x8038bc
  8000ce:	6a 1a                	push   $0x1a
  8000d0:	68 9c 38 80 00       	push   $0x80389c
  8000d5:	e8 e1 03 00 00       	call   8004bb <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Create(): Wrong allocation- make sure that you allocate the required space in the user environment and add its frames to frames_storage %d %d %d", freeFrames, sys_calculate_free_frames(), freeFrames - sys_calculate_free_frames());
  8000da:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000dd:	e8 c2 18 00 00       	call   8019a4 <sys_calculate_free_frames>
  8000e2:	29 c3                	sub    %eax,%ebx
  8000e4:	89 d8                	mov    %ebx,%eax
  8000e6:	83 f8 04             	cmp    $0x4,%eax
  8000e9:	74 28                	je     800113 <_main+0xdb>
  8000eb:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000ee:	e8 b1 18 00 00       	call   8019a4 <sys_calculate_free_frames>
  8000f3:	29 c3                	sub    %eax,%ebx
  8000f5:	e8 aa 18 00 00       	call   8019a4 <sys_calculate_free_frames>
  8000fa:	83 ec 08             	sub    $0x8,%esp
  8000fd:	53                   	push   %ebx
  8000fe:	50                   	push   %eax
  8000ff:	ff 75 ec             	pushl  -0x14(%ebp)
  800102:	68 20 39 80 00       	push   $0x803920
  800107:	6a 1b                	push   $0x1b
  800109:	68 9c 38 80 00       	push   $0x80389c
  80010e:	e8 a8 03 00 00       	call   8004bb <_panic>

	//y: Readonly
	freeFrames = sys_calculate_free_frames() ;
  800113:	e8 8c 18 00 00       	call   8019a4 <sys_calculate_free_frames>
  800118:	89 45 ec             	mov    %eax,-0x14(%ebp)
	y = smalloc("y", 4, 0);
  80011b:	83 ec 04             	sub    $0x4,%esp
  80011e:	6a 00                	push   $0x0
  800120:	6a 04                	push   $0x4
  800122:	68 b1 39 80 00       	push   $0x8039b1
  800127:	e8 13 16 00 00       	call   80173f <smalloc>
  80012c:	83 c4 10             	add    $0x10,%esp
  80012f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (y != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  800132:	81 7d e4 00 10 00 80 	cmpl   $0x80001000,-0x1c(%ebp)
  800139:	74 14                	je     80014f <_main+0x117>
  80013b:	83 ec 04             	sub    $0x4,%esp
  80013e:	68 bc 38 80 00       	push   $0x8038bc
  800143:	6a 20                	push   $0x20
  800145:	68 9c 38 80 00       	push   $0x80389c
  80014a:	e8 6c 03 00 00       	call   8004bb <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1+0+2) panic("Create(): Wrong allocation- make sure that you allocate the required space in the user environment and add its frames to frames_storage %d %d %d", freeFrames, sys_calculate_free_frames(), freeFrames - sys_calculate_free_frames());
  80014f:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  800152:	e8 4d 18 00 00       	call   8019a4 <sys_calculate_free_frames>
  800157:	29 c3                	sub    %eax,%ebx
  800159:	89 d8                	mov    %ebx,%eax
  80015b:	83 f8 03             	cmp    $0x3,%eax
  80015e:	74 28                	je     800188 <_main+0x150>
  800160:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  800163:	e8 3c 18 00 00       	call   8019a4 <sys_calculate_free_frames>
  800168:	29 c3                	sub    %eax,%ebx
  80016a:	e8 35 18 00 00       	call   8019a4 <sys_calculate_free_frames>
  80016f:	83 ec 08             	sub    $0x8,%esp
  800172:	53                   	push   %ebx
  800173:	50                   	push   %eax
  800174:	ff 75 ec             	pushl  -0x14(%ebp)
  800177:	68 20 39 80 00       	push   $0x803920
  80017c:	6a 21                	push   $0x21
  80017e:	68 9c 38 80 00       	push   $0x80389c
  800183:	e8 33 03 00 00       	call   8004bb <_panic>

	//z: Writable
	freeFrames = sys_calculate_free_frames() ;
  800188:	e8 17 18 00 00       	call   8019a4 <sys_calculate_free_frames>
  80018d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	z = smalloc("z", 4, 1);
  800190:	83 ec 04             	sub    $0x4,%esp
  800193:	6a 01                	push   $0x1
  800195:	6a 04                	push   $0x4
  800197:	68 b3 39 80 00       	push   $0x8039b3
  80019c:	e8 9e 15 00 00       	call   80173f <smalloc>
  8001a1:	83 c4 10             	add    $0x10,%esp
  8001a4:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (z != (uint32*)(USER_HEAP_START + 2 * PAGE_SIZE)) panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8001a7:	81 7d e0 00 20 00 80 	cmpl   $0x80002000,-0x20(%ebp)
  8001ae:	74 14                	je     8001c4 <_main+0x18c>
  8001b0:	83 ec 04             	sub    $0x4,%esp
  8001b3:	68 bc 38 80 00       	push   $0x8038bc
  8001b8:	6a 26                	push   $0x26
  8001ba:	68 9c 38 80 00       	push   $0x80389c
  8001bf:	e8 f7 02 00 00       	call   8004bb <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1+0+2) panic("Create(): Wrong allocation- make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8001c4:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8001c7:	e8 d8 17 00 00       	call   8019a4 <sys_calculate_free_frames>
  8001cc:	29 c3                	sub    %eax,%ebx
  8001ce:	89 d8                	mov    %ebx,%eax
  8001d0:	83 f8 03             	cmp    $0x3,%eax
  8001d3:	74 14                	je     8001e9 <_main+0x1b1>
  8001d5:	83 ec 04             	sub    $0x4,%esp
  8001d8:	68 b8 39 80 00       	push   $0x8039b8
  8001dd:	6a 27                	push   $0x27
  8001df:	68 9c 38 80 00       	push   $0x80389c
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
  800214:	68 40 3a 80 00       	push   $0x803a40
  800219:	e8 f8 19 00 00       	call   801c16 <sys_create_env>
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
  80023d:	68 40 3a 80 00       	push   $0x803a40
  800242:	e8 cf 19 00 00       	call   801c16 <sys_create_env>
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
  800266:	68 40 3a 80 00       	push   $0x803a40
  80026b:	e8 a6 19 00 00       	call   801c16 <sys_create_env>
  800270:	83 c4 10             	add    $0x10,%esp
  800273:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	//to check that the slave environments completed successfully
	rsttst();
  800276:	e8 e7 1a 00 00       	call   801d62 <rsttst>

	int* finish_children = smalloc("finish_children", sizeof(int), 1);
  80027b:	83 ec 04             	sub    $0x4,%esp
  80027e:	6a 01                	push   $0x1
  800280:	6a 04                	push   $0x4
  800282:	68 4e 3a 80 00       	push   $0x803a4e
  800287:	e8 b3 14 00 00       	call   80173f <smalloc>
  80028c:	83 c4 10             	add    $0x10,%esp
  80028f:	89 45 d0             	mov    %eax,-0x30(%ebp)

	sys_run_env(id1);
  800292:	83 ec 0c             	sub    $0xc,%esp
  800295:	ff 75 dc             	pushl  -0x24(%ebp)
  800298:	e8 97 19 00 00       	call   801c34 <sys_run_env>
  80029d:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id2);
  8002a0:	83 ec 0c             	sub    $0xc,%esp
  8002a3:	ff 75 d8             	pushl  -0x28(%ebp)
  8002a6:	e8 89 19 00 00       	call   801c34 <sys_run_env>
  8002ab:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id3);
  8002ae:	83 ec 0c             	sub    $0xc,%esp
  8002b1:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002b4:	e8 7b 19 00 00       	call   801c34 <sys_run_env>
  8002b9:	83 c4 10             	add    $0x10,%esp

	env_sleep(15000) ;
  8002bc:	83 ec 0c             	sub    $0xc,%esp
  8002bf:	68 98 3a 00 00       	push   $0x3a98
  8002c4:	e8 9d 32 00 00       	call   803566 <env_sleep>
  8002c9:	83 c4 10             	add    $0x10,%esp

	//to ensure that the slave environments completed successfully
	if (gettst()!=3) panic("test failed");
  8002cc:	e8 0b 1b 00 00       	call   801ddc <gettst>
  8002d1:	83 f8 03             	cmp    $0x3,%eax
  8002d4:	74 14                	je     8002ea <_main+0x2b2>
  8002d6:	83 ec 04             	sub    $0x4,%esp
  8002d9:	68 5e 3a 80 00       	push   $0x803a5e
  8002de:	6a 3d                	push   $0x3d
  8002e0:	68 9c 38 80 00       	push   $0x80389c
  8002e5:	e8 d1 01 00 00       	call   8004bb <_panic>


	if (*z != 30)
  8002ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002ed:	8b 00                	mov    (%eax),%eax
  8002ef:	83 f8 1e             	cmp    $0x1e,%eax
  8002f2:	74 14                	je     800308 <_main+0x2d0>
		panic("Error!! Please check the creation (or the getting) of shared 2variables!!\n\n\n");
  8002f4:	83 ec 04             	sub    $0x4,%esp
  8002f7:	68 6c 3a 80 00       	push   $0x803a6c
  8002fc:	6a 41                	push   $0x41
  8002fe:	68 9c 38 80 00       	push   $0x80389c
  800303:	e8 b3 01 00 00       	call   8004bb <_panic>
	else
		cprintf("Congratulations!! Test of Shared Variables [Create & Get] [2] completed successfully!!\n\n\n");
  800308:	83 ec 0c             	sub    $0xc,%esp
  80030b:	68 bc 3a 80 00       	push   $0x803abc
  800310:	e8 5a 04 00 00       	call   80076f <cprintf>
  800315:	83 c4 10             	add    $0x10,%esp


	if (sys_getparentenvid() > 0) {
  800318:	e8 80 19 00 00       	call   801c9d <sys_getparentenvid>
  80031d:	85 c0                	test   %eax,%eax
  80031f:	7e 58                	jle    800379 <_main+0x341>
		sys_destroy_env(id1);
  800321:	83 ec 0c             	sub    $0xc,%esp
  800324:	ff 75 dc             	pushl  -0x24(%ebp)
  800327:	e8 24 19 00 00       	call   801c50 <sys_destroy_env>
  80032c:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(id2);
  80032f:	83 ec 0c             	sub    $0xc,%esp
  800332:	ff 75 d8             	pushl  -0x28(%ebp)
  800335:	e8 16 19 00 00       	call   801c50 <sys_destroy_env>
  80033a:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(id3);
  80033d:	83 ec 0c             	sub    $0xc,%esp
  800340:	ff 75 d4             	pushl  -0x2c(%ebp)
  800343:	e8 08 19 00 00       	call   801c50 <sys_destroy_env>
  800348:	83 c4 10             	add    $0x10,%esp
		int *finishedCount = NULL;
  80034b:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
		finishedCount = sget(sys_getparentenvid(), "finishedCount") ;
  800352:	e8 46 19 00 00       	call   801c9d <sys_getparentenvid>
  800357:	83 ec 08             	sub    $0x8,%esp
  80035a:	68 16 3b 80 00       	push   $0x803b16
  80035f:	50                   	push   %eax
  800360:	e8 9b 14 00 00       	call   801800 <sget>
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
  800385:	e8 fa 18 00 00       	call   801c84 <sys_getenvindex>
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
  8003f0:	e8 9c 16 00 00       	call   801a91 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8003f5:	83 ec 0c             	sub    $0xc,%esp
  8003f8:	68 3c 3b 80 00       	push   $0x803b3c
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
  800420:	68 64 3b 80 00       	push   $0x803b64
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
  800451:	68 8c 3b 80 00       	push   $0x803b8c
  800456:	e8 14 03 00 00       	call   80076f <cprintf>
  80045b:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80045e:	a1 20 50 80 00       	mov    0x805020,%eax
  800463:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800469:	83 ec 08             	sub    $0x8,%esp
  80046c:	50                   	push   %eax
  80046d:	68 e4 3b 80 00       	push   $0x803be4
  800472:	e8 f8 02 00 00       	call   80076f <cprintf>
  800477:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80047a:	83 ec 0c             	sub    $0xc,%esp
  80047d:	68 3c 3b 80 00       	push   $0x803b3c
  800482:	e8 e8 02 00 00       	call   80076f <cprintf>
  800487:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80048a:	e8 1c 16 00 00       	call   801aab <sys_enable_interrupt>

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
  8004a2:	e8 a9 17 00 00       	call   801c50 <sys_destroy_env>
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
  8004b3:	e8 fe 17 00 00       	call   801cb6 <sys_exit_env>
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
  8004dc:	68 f8 3b 80 00       	push   $0x803bf8
  8004e1:	e8 89 02 00 00       	call   80076f <cprintf>
  8004e6:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8004e9:	a1 00 50 80 00       	mov    0x805000,%eax
  8004ee:	ff 75 0c             	pushl  0xc(%ebp)
  8004f1:	ff 75 08             	pushl  0x8(%ebp)
  8004f4:	50                   	push   %eax
  8004f5:	68 fd 3b 80 00       	push   $0x803bfd
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
  800519:	68 19 3c 80 00       	push   $0x803c19
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
  800545:	68 1c 3c 80 00       	push   $0x803c1c
  80054a:	6a 26                	push   $0x26
  80054c:	68 68 3c 80 00       	push   $0x803c68
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
  800617:	68 74 3c 80 00       	push   $0x803c74
  80061c:	6a 3a                	push   $0x3a
  80061e:	68 68 3c 80 00       	push   $0x803c68
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
  800687:	68 c8 3c 80 00       	push   $0x803cc8
  80068c:	6a 44                	push   $0x44
  80068e:	68 68 3c 80 00       	push   $0x803c68
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
  8006e1:	e8 fd 11 00 00       	call   8018e3 <sys_cputs>
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
  800758:	e8 86 11 00 00       	call   8018e3 <sys_cputs>
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
  8007a2:	e8 ea 12 00 00       	call   801a91 <sys_disable_interrupt>
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
  8007c2:	e8 e4 12 00 00       	call   801aab <sys_enable_interrupt>
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
  80080c:	e8 0b 2e 00 00       	call   80361c <__udivdi3>
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
  80085c:	e8 cb 2e 00 00       	call   80372c <__umoddi3>
  800861:	83 c4 10             	add    $0x10,%esp
  800864:	05 34 3f 80 00       	add    $0x803f34,%eax
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
  8009b7:	8b 04 85 58 3f 80 00 	mov    0x803f58(,%eax,4),%eax
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
  800a98:	8b 34 9d a0 3d 80 00 	mov    0x803da0(,%ebx,4),%esi
  800a9f:	85 f6                	test   %esi,%esi
  800aa1:	75 19                	jne    800abc <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800aa3:	53                   	push   %ebx
  800aa4:	68 45 3f 80 00       	push   $0x803f45
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
  800abd:	68 4e 3f 80 00       	push   $0x803f4e
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
  800aea:	be 51 3f 80 00       	mov    $0x803f51,%esi
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
  801510:	68 b0 40 80 00       	push   $0x8040b0
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
  8015e0:	e8 42 04 00 00       	call   801a27 <sys_allocate_chunk>
  8015e5:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8015e8:	a1 20 51 80 00       	mov    0x805120,%eax
  8015ed:	83 ec 0c             	sub    $0xc,%esp
  8015f0:	50                   	push   %eax
  8015f1:	e8 b7 0a 00 00       	call   8020ad <initialize_MemBlocksList>
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
  80161e:	68 d5 40 80 00       	push   $0x8040d5
  801623:	6a 33                	push   $0x33
  801625:	68 f3 40 80 00       	push   $0x8040f3
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
  80169d:	68 00 41 80 00       	push   $0x804100
  8016a2:	6a 34                	push   $0x34
  8016a4:	68 f3 40 80 00       	push   $0x8040f3
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
  801712:	68 24 41 80 00       	push   $0x804124
  801717:	6a 46                	push   $0x46
  801719:	68 f3 40 80 00       	push   $0x8040f3
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
  80172e:	68 4c 41 80 00       	push   $0x80414c
  801733:	6a 61                	push   $0x61
  801735:	68 f3 40 80 00       	push   $0x8040f3
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
  801754:	75 0a                	jne    801760 <smalloc+0x21>
  801756:	b8 00 00 00 00       	mov    $0x0,%eax
  80175b:	e9 9e 00 00 00       	jmp    8017fe <smalloc+0xbf>
	//3-If the Kernel successfully creates the shared variable, return its virtual address
	//4-Else, return NULL



	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801760:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801767:	8b 55 0c             	mov    0xc(%ebp),%edx
  80176a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80176d:	01 d0                	add    %edx,%eax
  80176f:	48                   	dec    %eax
  801770:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801773:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801776:	ba 00 00 00 00       	mov    $0x0,%edx
  80177b:	f7 75 f0             	divl   -0x10(%ebp)
  80177e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801781:	29 d0                	sub    %edx,%eax
  801783:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801786:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  80178d:	e8 63 06 00 00       	call   801df5 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801792:	85 c0                	test   %eax,%eax
  801794:	74 11                	je     8017a7 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  801796:	83 ec 0c             	sub    $0xc,%esp
  801799:	ff 75 e8             	pushl  -0x18(%ebp)
  80179c:	e8 ce 0c 00 00       	call   80246f <alloc_block_FF>
  8017a1:	83 c4 10             	add    $0x10,%esp
  8017a4:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  8017a7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8017ab:	74 4c                	je     8017f9 <smalloc+0xba>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8017ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017b0:	8b 40 08             	mov    0x8(%eax),%eax
  8017b3:	89 c2                	mov    %eax,%edx
  8017b5:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8017b9:	52                   	push   %edx
  8017ba:	50                   	push   %eax
  8017bb:	ff 75 0c             	pushl  0xc(%ebp)
  8017be:	ff 75 08             	pushl  0x8(%ebp)
  8017c1:	e8 b4 03 00 00       	call   801b7a <sys_createSharedObject>
  8017c6:	83 c4 10             	add    $0x10,%esp
  8017c9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cprintf("Output is :  %d \n" , result);
  8017cc:	83 ec 08             	sub    $0x8,%esp
  8017cf:	ff 75 e0             	pushl  -0x20(%ebp)
  8017d2:	68 6f 41 80 00       	push   $0x80416f
  8017d7:	e8 93 ef ff ff       	call   80076f <cprintf>
  8017dc:	83 c4 10             	add    $0x10,%esp
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  8017df:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  8017e3:	74 14                	je     8017f9 <smalloc+0xba>
  8017e5:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  8017e9:	74 0e                	je     8017f9 <smalloc+0xba>
  8017eb:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  8017ef:	74 08                	je     8017f9 <smalloc+0xba>
			return (void*) mem_block->sva;
  8017f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017f4:	8b 40 08             	mov    0x8(%eax),%eax
  8017f7:	eb 05                	jmp    8017fe <smalloc+0xbf>
	}
	return NULL;
  8017f9:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8017fe:	c9                   	leave  
  8017ff:	c3                   	ret    

00801800 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801800:	55                   	push   %ebp
  801801:	89 e5                	mov    %esp,%ebp
  801803:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801806:	e8 ee fc ff ff       	call   8014f9 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  80180b:	83 ec 04             	sub    $0x4,%esp
  80180e:	68 84 41 80 00       	push   $0x804184
  801813:	68 ab 00 00 00       	push   $0xab
  801818:	68 f3 40 80 00       	push   $0x8040f3
  80181d:	e8 99 ec ff ff       	call   8004bb <_panic>

00801822 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801822:	55                   	push   %ebp
  801823:	89 e5                	mov    %esp,%ebp
  801825:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801828:	e8 cc fc ff ff       	call   8014f9 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80182d:	83 ec 04             	sub    $0x4,%esp
  801830:	68 a8 41 80 00       	push   $0x8041a8
  801835:	68 ef 00 00 00       	push   $0xef
  80183a:	68 f3 40 80 00       	push   $0x8040f3
  80183f:	e8 77 ec ff ff       	call   8004bb <_panic>

00801844 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801844:	55                   	push   %ebp
  801845:	89 e5                	mov    %esp,%ebp
  801847:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80184a:	83 ec 04             	sub    $0x4,%esp
  80184d:	68 d0 41 80 00       	push   $0x8041d0
  801852:	68 03 01 00 00       	push   $0x103
  801857:	68 f3 40 80 00       	push   $0x8040f3
  80185c:	e8 5a ec ff ff       	call   8004bb <_panic>

00801861 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801861:	55                   	push   %ebp
  801862:	89 e5                	mov    %esp,%ebp
  801864:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801867:	83 ec 04             	sub    $0x4,%esp
  80186a:	68 f4 41 80 00       	push   $0x8041f4
  80186f:	68 0e 01 00 00       	push   $0x10e
  801874:	68 f3 40 80 00       	push   $0x8040f3
  801879:	e8 3d ec ff ff       	call   8004bb <_panic>

0080187e <shrink>:

}
void shrink(uint32 newSize)
{
  80187e:	55                   	push   %ebp
  80187f:	89 e5                	mov    %esp,%ebp
  801881:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801884:	83 ec 04             	sub    $0x4,%esp
  801887:	68 f4 41 80 00       	push   $0x8041f4
  80188c:	68 13 01 00 00       	push   $0x113
  801891:	68 f3 40 80 00       	push   $0x8040f3
  801896:	e8 20 ec ff ff       	call   8004bb <_panic>

0080189b <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80189b:	55                   	push   %ebp
  80189c:	89 e5                	mov    %esp,%ebp
  80189e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018a1:	83 ec 04             	sub    $0x4,%esp
  8018a4:	68 f4 41 80 00       	push   $0x8041f4
  8018a9:	68 18 01 00 00       	push   $0x118
  8018ae:	68 f3 40 80 00       	push   $0x8040f3
  8018b3:	e8 03 ec ff ff       	call   8004bb <_panic>

008018b8 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8018b8:	55                   	push   %ebp
  8018b9:	89 e5                	mov    %esp,%ebp
  8018bb:	57                   	push   %edi
  8018bc:	56                   	push   %esi
  8018bd:	53                   	push   %ebx
  8018be:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018c7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018ca:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018cd:	8b 7d 18             	mov    0x18(%ebp),%edi
  8018d0:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8018d3:	cd 30                	int    $0x30
  8018d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8018d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018db:	83 c4 10             	add    $0x10,%esp
  8018de:	5b                   	pop    %ebx
  8018df:	5e                   	pop    %esi
  8018e0:	5f                   	pop    %edi
  8018e1:	5d                   	pop    %ebp
  8018e2:	c3                   	ret    

008018e3 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8018e3:	55                   	push   %ebp
  8018e4:	89 e5                	mov    %esp,%ebp
  8018e6:	83 ec 04             	sub    $0x4,%esp
  8018e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8018ec:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8018ef:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f6:	6a 00                	push   $0x0
  8018f8:	6a 00                	push   $0x0
  8018fa:	52                   	push   %edx
  8018fb:	ff 75 0c             	pushl  0xc(%ebp)
  8018fe:	50                   	push   %eax
  8018ff:	6a 00                	push   $0x0
  801901:	e8 b2 ff ff ff       	call   8018b8 <syscall>
  801906:	83 c4 18             	add    $0x18,%esp
}
  801909:	90                   	nop
  80190a:	c9                   	leave  
  80190b:	c3                   	ret    

0080190c <sys_cgetc>:

int
sys_cgetc(void)
{
  80190c:	55                   	push   %ebp
  80190d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80190f:	6a 00                	push   $0x0
  801911:	6a 00                	push   $0x0
  801913:	6a 00                	push   $0x0
  801915:	6a 00                	push   $0x0
  801917:	6a 00                	push   $0x0
  801919:	6a 01                	push   $0x1
  80191b:	e8 98 ff ff ff       	call   8018b8 <syscall>
  801920:	83 c4 18             	add    $0x18,%esp
}
  801923:	c9                   	leave  
  801924:	c3                   	ret    

00801925 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801925:	55                   	push   %ebp
  801926:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801928:	8b 55 0c             	mov    0xc(%ebp),%edx
  80192b:	8b 45 08             	mov    0x8(%ebp),%eax
  80192e:	6a 00                	push   $0x0
  801930:	6a 00                	push   $0x0
  801932:	6a 00                	push   $0x0
  801934:	52                   	push   %edx
  801935:	50                   	push   %eax
  801936:	6a 05                	push   $0x5
  801938:	e8 7b ff ff ff       	call   8018b8 <syscall>
  80193d:	83 c4 18             	add    $0x18,%esp
}
  801940:	c9                   	leave  
  801941:	c3                   	ret    

00801942 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801942:	55                   	push   %ebp
  801943:	89 e5                	mov    %esp,%ebp
  801945:	56                   	push   %esi
  801946:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801947:	8b 75 18             	mov    0x18(%ebp),%esi
  80194a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80194d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801950:	8b 55 0c             	mov    0xc(%ebp),%edx
  801953:	8b 45 08             	mov    0x8(%ebp),%eax
  801956:	56                   	push   %esi
  801957:	53                   	push   %ebx
  801958:	51                   	push   %ecx
  801959:	52                   	push   %edx
  80195a:	50                   	push   %eax
  80195b:	6a 06                	push   $0x6
  80195d:	e8 56 ff ff ff       	call   8018b8 <syscall>
  801962:	83 c4 18             	add    $0x18,%esp
}
  801965:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801968:	5b                   	pop    %ebx
  801969:	5e                   	pop    %esi
  80196a:	5d                   	pop    %ebp
  80196b:	c3                   	ret    

0080196c <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80196c:	55                   	push   %ebp
  80196d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80196f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801972:	8b 45 08             	mov    0x8(%ebp),%eax
  801975:	6a 00                	push   $0x0
  801977:	6a 00                	push   $0x0
  801979:	6a 00                	push   $0x0
  80197b:	52                   	push   %edx
  80197c:	50                   	push   %eax
  80197d:	6a 07                	push   $0x7
  80197f:	e8 34 ff ff ff       	call   8018b8 <syscall>
  801984:	83 c4 18             	add    $0x18,%esp
}
  801987:	c9                   	leave  
  801988:	c3                   	ret    

00801989 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801989:	55                   	push   %ebp
  80198a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80198c:	6a 00                	push   $0x0
  80198e:	6a 00                	push   $0x0
  801990:	6a 00                	push   $0x0
  801992:	ff 75 0c             	pushl  0xc(%ebp)
  801995:	ff 75 08             	pushl  0x8(%ebp)
  801998:	6a 08                	push   $0x8
  80199a:	e8 19 ff ff ff       	call   8018b8 <syscall>
  80199f:	83 c4 18             	add    $0x18,%esp
}
  8019a2:	c9                   	leave  
  8019a3:	c3                   	ret    

008019a4 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8019a4:	55                   	push   %ebp
  8019a5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8019a7:	6a 00                	push   $0x0
  8019a9:	6a 00                	push   $0x0
  8019ab:	6a 00                	push   $0x0
  8019ad:	6a 00                	push   $0x0
  8019af:	6a 00                	push   $0x0
  8019b1:	6a 09                	push   $0x9
  8019b3:	e8 00 ff ff ff       	call   8018b8 <syscall>
  8019b8:	83 c4 18             	add    $0x18,%esp
}
  8019bb:	c9                   	leave  
  8019bc:	c3                   	ret    

008019bd <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8019bd:	55                   	push   %ebp
  8019be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8019c0:	6a 00                	push   $0x0
  8019c2:	6a 00                	push   $0x0
  8019c4:	6a 00                	push   $0x0
  8019c6:	6a 00                	push   $0x0
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 0a                	push   $0xa
  8019cc:	e8 e7 fe ff ff       	call   8018b8 <syscall>
  8019d1:	83 c4 18             	add    $0x18,%esp
}
  8019d4:	c9                   	leave  
  8019d5:	c3                   	ret    

008019d6 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8019d6:	55                   	push   %ebp
  8019d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8019d9:	6a 00                	push   $0x0
  8019db:	6a 00                	push   $0x0
  8019dd:	6a 00                	push   $0x0
  8019df:	6a 00                	push   $0x0
  8019e1:	6a 00                	push   $0x0
  8019e3:	6a 0b                	push   $0xb
  8019e5:	e8 ce fe ff ff       	call   8018b8 <syscall>
  8019ea:	83 c4 18             	add    $0x18,%esp
}
  8019ed:	c9                   	leave  
  8019ee:	c3                   	ret    

008019ef <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8019ef:	55                   	push   %ebp
  8019f0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8019f2:	6a 00                	push   $0x0
  8019f4:	6a 00                	push   $0x0
  8019f6:	6a 00                	push   $0x0
  8019f8:	ff 75 0c             	pushl  0xc(%ebp)
  8019fb:	ff 75 08             	pushl  0x8(%ebp)
  8019fe:	6a 0f                	push   $0xf
  801a00:	e8 b3 fe ff ff       	call   8018b8 <syscall>
  801a05:	83 c4 18             	add    $0x18,%esp
	return;
  801a08:	90                   	nop
}
  801a09:	c9                   	leave  
  801a0a:	c3                   	ret    

00801a0b <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a0b:	55                   	push   %ebp
  801a0c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801a0e:	6a 00                	push   $0x0
  801a10:	6a 00                	push   $0x0
  801a12:	6a 00                	push   $0x0
  801a14:	ff 75 0c             	pushl  0xc(%ebp)
  801a17:	ff 75 08             	pushl  0x8(%ebp)
  801a1a:	6a 10                	push   $0x10
  801a1c:	e8 97 fe ff ff       	call   8018b8 <syscall>
  801a21:	83 c4 18             	add    $0x18,%esp
	return ;
  801a24:	90                   	nop
}
  801a25:	c9                   	leave  
  801a26:	c3                   	ret    

00801a27 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801a27:	55                   	push   %ebp
  801a28:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 00                	push   $0x0
  801a2e:	ff 75 10             	pushl  0x10(%ebp)
  801a31:	ff 75 0c             	pushl  0xc(%ebp)
  801a34:	ff 75 08             	pushl  0x8(%ebp)
  801a37:	6a 11                	push   $0x11
  801a39:	e8 7a fe ff ff       	call   8018b8 <syscall>
  801a3e:	83 c4 18             	add    $0x18,%esp
	return ;
  801a41:	90                   	nop
}
  801a42:	c9                   	leave  
  801a43:	c3                   	ret    

00801a44 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a44:	55                   	push   %ebp
  801a45:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a47:	6a 00                	push   $0x0
  801a49:	6a 00                	push   $0x0
  801a4b:	6a 00                	push   $0x0
  801a4d:	6a 00                	push   $0x0
  801a4f:	6a 00                	push   $0x0
  801a51:	6a 0c                	push   $0xc
  801a53:	e8 60 fe ff ff       	call   8018b8 <syscall>
  801a58:	83 c4 18             	add    $0x18,%esp
}
  801a5b:	c9                   	leave  
  801a5c:	c3                   	ret    

00801a5d <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a5d:	55                   	push   %ebp
  801a5e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a60:	6a 00                	push   $0x0
  801a62:	6a 00                	push   $0x0
  801a64:	6a 00                	push   $0x0
  801a66:	6a 00                	push   $0x0
  801a68:	ff 75 08             	pushl  0x8(%ebp)
  801a6b:	6a 0d                	push   $0xd
  801a6d:	e8 46 fe ff ff       	call   8018b8 <syscall>
  801a72:	83 c4 18             	add    $0x18,%esp
}
  801a75:	c9                   	leave  
  801a76:	c3                   	ret    

00801a77 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a77:	55                   	push   %ebp
  801a78:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a7a:	6a 00                	push   $0x0
  801a7c:	6a 00                	push   $0x0
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 00                	push   $0x0
  801a82:	6a 00                	push   $0x0
  801a84:	6a 0e                	push   $0xe
  801a86:	e8 2d fe ff ff       	call   8018b8 <syscall>
  801a8b:	83 c4 18             	add    $0x18,%esp
}
  801a8e:	90                   	nop
  801a8f:	c9                   	leave  
  801a90:	c3                   	ret    

00801a91 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801a91:	55                   	push   %ebp
  801a92:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801a94:	6a 00                	push   $0x0
  801a96:	6a 00                	push   $0x0
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 13                	push   $0x13
  801aa0:	e8 13 fe ff ff       	call   8018b8 <syscall>
  801aa5:	83 c4 18             	add    $0x18,%esp
}
  801aa8:	90                   	nop
  801aa9:	c9                   	leave  
  801aaa:	c3                   	ret    

00801aab <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801aab:	55                   	push   %ebp
  801aac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801aae:	6a 00                	push   $0x0
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 14                	push   $0x14
  801aba:	e8 f9 fd ff ff       	call   8018b8 <syscall>
  801abf:	83 c4 18             	add    $0x18,%esp
}
  801ac2:	90                   	nop
  801ac3:	c9                   	leave  
  801ac4:	c3                   	ret    

00801ac5 <sys_cputc>:


void
sys_cputc(const char c)
{
  801ac5:	55                   	push   %ebp
  801ac6:	89 e5                	mov    %esp,%ebp
  801ac8:	83 ec 04             	sub    $0x4,%esp
  801acb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ace:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801ad1:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ad5:	6a 00                	push   $0x0
  801ad7:	6a 00                	push   $0x0
  801ad9:	6a 00                	push   $0x0
  801adb:	6a 00                	push   $0x0
  801add:	50                   	push   %eax
  801ade:	6a 15                	push   $0x15
  801ae0:	e8 d3 fd ff ff       	call   8018b8 <syscall>
  801ae5:	83 c4 18             	add    $0x18,%esp
}
  801ae8:	90                   	nop
  801ae9:	c9                   	leave  
  801aea:	c3                   	ret    

00801aeb <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801aeb:	55                   	push   %ebp
  801aec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801aee:	6a 00                	push   $0x0
  801af0:	6a 00                	push   $0x0
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	6a 00                	push   $0x0
  801af8:	6a 16                	push   $0x16
  801afa:	e8 b9 fd ff ff       	call   8018b8 <syscall>
  801aff:	83 c4 18             	add    $0x18,%esp
}
  801b02:	90                   	nop
  801b03:	c9                   	leave  
  801b04:	c3                   	ret    

00801b05 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801b05:	55                   	push   %ebp
  801b06:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801b08:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 00                	push   $0x0
  801b11:	ff 75 0c             	pushl  0xc(%ebp)
  801b14:	50                   	push   %eax
  801b15:	6a 17                	push   $0x17
  801b17:	e8 9c fd ff ff       	call   8018b8 <syscall>
  801b1c:	83 c4 18             	add    $0x18,%esp
}
  801b1f:	c9                   	leave  
  801b20:	c3                   	ret    

00801b21 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801b21:	55                   	push   %ebp
  801b22:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b24:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b27:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2a:	6a 00                	push   $0x0
  801b2c:	6a 00                	push   $0x0
  801b2e:	6a 00                	push   $0x0
  801b30:	52                   	push   %edx
  801b31:	50                   	push   %eax
  801b32:	6a 1a                	push   $0x1a
  801b34:	e8 7f fd ff ff       	call   8018b8 <syscall>
  801b39:	83 c4 18             	add    $0x18,%esp
}
  801b3c:	c9                   	leave  
  801b3d:	c3                   	ret    

00801b3e <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b3e:	55                   	push   %ebp
  801b3f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b41:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b44:	8b 45 08             	mov    0x8(%ebp),%eax
  801b47:	6a 00                	push   $0x0
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 00                	push   $0x0
  801b4d:	52                   	push   %edx
  801b4e:	50                   	push   %eax
  801b4f:	6a 18                	push   $0x18
  801b51:	e8 62 fd ff ff       	call   8018b8 <syscall>
  801b56:	83 c4 18             	add    $0x18,%esp
}
  801b59:	90                   	nop
  801b5a:	c9                   	leave  
  801b5b:	c3                   	ret    

00801b5c <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b5c:	55                   	push   %ebp
  801b5d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b5f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b62:	8b 45 08             	mov    0x8(%ebp),%eax
  801b65:	6a 00                	push   $0x0
  801b67:	6a 00                	push   $0x0
  801b69:	6a 00                	push   $0x0
  801b6b:	52                   	push   %edx
  801b6c:	50                   	push   %eax
  801b6d:	6a 19                	push   $0x19
  801b6f:	e8 44 fd ff ff       	call   8018b8 <syscall>
  801b74:	83 c4 18             	add    $0x18,%esp
}
  801b77:	90                   	nop
  801b78:	c9                   	leave  
  801b79:	c3                   	ret    

00801b7a <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b7a:	55                   	push   %ebp
  801b7b:	89 e5                	mov    %esp,%ebp
  801b7d:	83 ec 04             	sub    $0x4,%esp
  801b80:	8b 45 10             	mov    0x10(%ebp),%eax
  801b83:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b86:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b89:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b90:	6a 00                	push   $0x0
  801b92:	51                   	push   %ecx
  801b93:	52                   	push   %edx
  801b94:	ff 75 0c             	pushl  0xc(%ebp)
  801b97:	50                   	push   %eax
  801b98:	6a 1b                	push   $0x1b
  801b9a:	e8 19 fd ff ff       	call   8018b8 <syscall>
  801b9f:	83 c4 18             	add    $0x18,%esp
}
  801ba2:	c9                   	leave  
  801ba3:	c3                   	ret    

00801ba4 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801ba4:	55                   	push   %ebp
  801ba5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801ba7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801baa:	8b 45 08             	mov    0x8(%ebp),%eax
  801bad:	6a 00                	push   $0x0
  801baf:	6a 00                	push   $0x0
  801bb1:	6a 00                	push   $0x0
  801bb3:	52                   	push   %edx
  801bb4:	50                   	push   %eax
  801bb5:	6a 1c                	push   $0x1c
  801bb7:	e8 fc fc ff ff       	call   8018b8 <syscall>
  801bbc:	83 c4 18             	add    $0x18,%esp
}
  801bbf:	c9                   	leave  
  801bc0:	c3                   	ret    

00801bc1 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801bc1:	55                   	push   %ebp
  801bc2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801bc4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bc7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bca:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcd:	6a 00                	push   $0x0
  801bcf:	6a 00                	push   $0x0
  801bd1:	51                   	push   %ecx
  801bd2:	52                   	push   %edx
  801bd3:	50                   	push   %eax
  801bd4:	6a 1d                	push   $0x1d
  801bd6:	e8 dd fc ff ff       	call   8018b8 <syscall>
  801bdb:	83 c4 18             	add    $0x18,%esp
}
  801bde:	c9                   	leave  
  801bdf:	c3                   	ret    

00801be0 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801be0:	55                   	push   %ebp
  801be1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801be3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801be6:	8b 45 08             	mov    0x8(%ebp),%eax
  801be9:	6a 00                	push   $0x0
  801beb:	6a 00                	push   $0x0
  801bed:	6a 00                	push   $0x0
  801bef:	52                   	push   %edx
  801bf0:	50                   	push   %eax
  801bf1:	6a 1e                	push   $0x1e
  801bf3:	e8 c0 fc ff ff       	call   8018b8 <syscall>
  801bf8:	83 c4 18             	add    $0x18,%esp
}
  801bfb:	c9                   	leave  
  801bfc:	c3                   	ret    

00801bfd <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801bfd:	55                   	push   %ebp
  801bfe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801c00:	6a 00                	push   $0x0
  801c02:	6a 00                	push   $0x0
  801c04:	6a 00                	push   $0x0
  801c06:	6a 00                	push   $0x0
  801c08:	6a 00                	push   $0x0
  801c0a:	6a 1f                	push   $0x1f
  801c0c:	e8 a7 fc ff ff       	call   8018b8 <syscall>
  801c11:	83 c4 18             	add    $0x18,%esp
}
  801c14:	c9                   	leave  
  801c15:	c3                   	ret    

00801c16 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c16:	55                   	push   %ebp
  801c17:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c19:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1c:	6a 00                	push   $0x0
  801c1e:	ff 75 14             	pushl  0x14(%ebp)
  801c21:	ff 75 10             	pushl  0x10(%ebp)
  801c24:	ff 75 0c             	pushl  0xc(%ebp)
  801c27:	50                   	push   %eax
  801c28:	6a 20                	push   $0x20
  801c2a:	e8 89 fc ff ff       	call   8018b8 <syscall>
  801c2f:	83 c4 18             	add    $0x18,%esp
}
  801c32:	c9                   	leave  
  801c33:	c3                   	ret    

00801c34 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801c34:	55                   	push   %ebp
  801c35:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c37:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3a:	6a 00                	push   $0x0
  801c3c:	6a 00                	push   $0x0
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 00                	push   $0x0
  801c42:	50                   	push   %eax
  801c43:	6a 21                	push   $0x21
  801c45:	e8 6e fc ff ff       	call   8018b8 <syscall>
  801c4a:	83 c4 18             	add    $0x18,%esp
}
  801c4d:	90                   	nop
  801c4e:	c9                   	leave  
  801c4f:	c3                   	ret    

00801c50 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c50:	55                   	push   %ebp
  801c51:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c53:	8b 45 08             	mov    0x8(%ebp),%eax
  801c56:	6a 00                	push   $0x0
  801c58:	6a 00                	push   $0x0
  801c5a:	6a 00                	push   $0x0
  801c5c:	6a 00                	push   $0x0
  801c5e:	50                   	push   %eax
  801c5f:	6a 22                	push   $0x22
  801c61:	e8 52 fc ff ff       	call   8018b8 <syscall>
  801c66:	83 c4 18             	add    $0x18,%esp
}
  801c69:	c9                   	leave  
  801c6a:	c3                   	ret    

00801c6b <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c6b:	55                   	push   %ebp
  801c6c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c6e:	6a 00                	push   $0x0
  801c70:	6a 00                	push   $0x0
  801c72:	6a 00                	push   $0x0
  801c74:	6a 00                	push   $0x0
  801c76:	6a 00                	push   $0x0
  801c78:	6a 02                	push   $0x2
  801c7a:	e8 39 fc ff ff       	call   8018b8 <syscall>
  801c7f:	83 c4 18             	add    $0x18,%esp
}
  801c82:	c9                   	leave  
  801c83:	c3                   	ret    

00801c84 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c84:	55                   	push   %ebp
  801c85:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c87:	6a 00                	push   $0x0
  801c89:	6a 00                	push   $0x0
  801c8b:	6a 00                	push   $0x0
  801c8d:	6a 00                	push   $0x0
  801c8f:	6a 00                	push   $0x0
  801c91:	6a 03                	push   $0x3
  801c93:	e8 20 fc ff ff       	call   8018b8 <syscall>
  801c98:	83 c4 18             	add    $0x18,%esp
}
  801c9b:	c9                   	leave  
  801c9c:	c3                   	ret    

00801c9d <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c9d:	55                   	push   %ebp
  801c9e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801ca0:	6a 00                	push   $0x0
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 00                	push   $0x0
  801ca8:	6a 00                	push   $0x0
  801caa:	6a 04                	push   $0x4
  801cac:	e8 07 fc ff ff       	call   8018b8 <syscall>
  801cb1:	83 c4 18             	add    $0x18,%esp
}
  801cb4:	c9                   	leave  
  801cb5:	c3                   	ret    

00801cb6 <sys_exit_env>:


void sys_exit_env(void)
{
  801cb6:	55                   	push   %ebp
  801cb7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801cb9:	6a 00                	push   $0x0
  801cbb:	6a 00                	push   $0x0
  801cbd:	6a 00                	push   $0x0
  801cbf:	6a 00                	push   $0x0
  801cc1:	6a 00                	push   $0x0
  801cc3:	6a 23                	push   $0x23
  801cc5:	e8 ee fb ff ff       	call   8018b8 <syscall>
  801cca:	83 c4 18             	add    $0x18,%esp
}
  801ccd:	90                   	nop
  801cce:	c9                   	leave  
  801ccf:	c3                   	ret    

00801cd0 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801cd0:	55                   	push   %ebp
  801cd1:	89 e5                	mov    %esp,%ebp
  801cd3:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801cd6:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cd9:	8d 50 04             	lea    0x4(%eax),%edx
  801cdc:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cdf:	6a 00                	push   $0x0
  801ce1:	6a 00                	push   $0x0
  801ce3:	6a 00                	push   $0x0
  801ce5:	52                   	push   %edx
  801ce6:	50                   	push   %eax
  801ce7:	6a 24                	push   $0x24
  801ce9:	e8 ca fb ff ff       	call   8018b8 <syscall>
  801cee:	83 c4 18             	add    $0x18,%esp
	return result;
  801cf1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cf4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801cf7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801cfa:	89 01                	mov    %eax,(%ecx)
  801cfc:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801cff:	8b 45 08             	mov    0x8(%ebp),%eax
  801d02:	c9                   	leave  
  801d03:	c2 04 00             	ret    $0x4

00801d06 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d06:	55                   	push   %ebp
  801d07:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d09:	6a 00                	push   $0x0
  801d0b:	6a 00                	push   $0x0
  801d0d:	ff 75 10             	pushl  0x10(%ebp)
  801d10:	ff 75 0c             	pushl  0xc(%ebp)
  801d13:	ff 75 08             	pushl  0x8(%ebp)
  801d16:	6a 12                	push   $0x12
  801d18:	e8 9b fb ff ff       	call   8018b8 <syscall>
  801d1d:	83 c4 18             	add    $0x18,%esp
	return ;
  801d20:	90                   	nop
}
  801d21:	c9                   	leave  
  801d22:	c3                   	ret    

00801d23 <sys_rcr2>:
uint32 sys_rcr2()
{
  801d23:	55                   	push   %ebp
  801d24:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d26:	6a 00                	push   $0x0
  801d28:	6a 00                	push   $0x0
  801d2a:	6a 00                	push   $0x0
  801d2c:	6a 00                	push   $0x0
  801d2e:	6a 00                	push   $0x0
  801d30:	6a 25                	push   $0x25
  801d32:	e8 81 fb ff ff       	call   8018b8 <syscall>
  801d37:	83 c4 18             	add    $0x18,%esp
}
  801d3a:	c9                   	leave  
  801d3b:	c3                   	ret    

00801d3c <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801d3c:	55                   	push   %ebp
  801d3d:	89 e5                	mov    %esp,%ebp
  801d3f:	83 ec 04             	sub    $0x4,%esp
  801d42:	8b 45 08             	mov    0x8(%ebp),%eax
  801d45:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d48:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d4c:	6a 00                	push   $0x0
  801d4e:	6a 00                	push   $0x0
  801d50:	6a 00                	push   $0x0
  801d52:	6a 00                	push   $0x0
  801d54:	50                   	push   %eax
  801d55:	6a 26                	push   $0x26
  801d57:	e8 5c fb ff ff       	call   8018b8 <syscall>
  801d5c:	83 c4 18             	add    $0x18,%esp
	return ;
  801d5f:	90                   	nop
}
  801d60:	c9                   	leave  
  801d61:	c3                   	ret    

00801d62 <rsttst>:
void rsttst()
{
  801d62:	55                   	push   %ebp
  801d63:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d65:	6a 00                	push   $0x0
  801d67:	6a 00                	push   $0x0
  801d69:	6a 00                	push   $0x0
  801d6b:	6a 00                	push   $0x0
  801d6d:	6a 00                	push   $0x0
  801d6f:	6a 28                	push   $0x28
  801d71:	e8 42 fb ff ff       	call   8018b8 <syscall>
  801d76:	83 c4 18             	add    $0x18,%esp
	return ;
  801d79:	90                   	nop
}
  801d7a:	c9                   	leave  
  801d7b:	c3                   	ret    

00801d7c <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d7c:	55                   	push   %ebp
  801d7d:	89 e5                	mov    %esp,%ebp
  801d7f:	83 ec 04             	sub    $0x4,%esp
  801d82:	8b 45 14             	mov    0x14(%ebp),%eax
  801d85:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d88:	8b 55 18             	mov    0x18(%ebp),%edx
  801d8b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d8f:	52                   	push   %edx
  801d90:	50                   	push   %eax
  801d91:	ff 75 10             	pushl  0x10(%ebp)
  801d94:	ff 75 0c             	pushl  0xc(%ebp)
  801d97:	ff 75 08             	pushl  0x8(%ebp)
  801d9a:	6a 27                	push   $0x27
  801d9c:	e8 17 fb ff ff       	call   8018b8 <syscall>
  801da1:	83 c4 18             	add    $0x18,%esp
	return ;
  801da4:	90                   	nop
}
  801da5:	c9                   	leave  
  801da6:	c3                   	ret    

00801da7 <chktst>:
void chktst(uint32 n)
{
  801da7:	55                   	push   %ebp
  801da8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801daa:	6a 00                	push   $0x0
  801dac:	6a 00                	push   $0x0
  801dae:	6a 00                	push   $0x0
  801db0:	6a 00                	push   $0x0
  801db2:	ff 75 08             	pushl  0x8(%ebp)
  801db5:	6a 29                	push   $0x29
  801db7:	e8 fc fa ff ff       	call   8018b8 <syscall>
  801dbc:	83 c4 18             	add    $0x18,%esp
	return ;
  801dbf:	90                   	nop
}
  801dc0:	c9                   	leave  
  801dc1:	c3                   	ret    

00801dc2 <inctst>:

void inctst()
{
  801dc2:	55                   	push   %ebp
  801dc3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801dc5:	6a 00                	push   $0x0
  801dc7:	6a 00                	push   $0x0
  801dc9:	6a 00                	push   $0x0
  801dcb:	6a 00                	push   $0x0
  801dcd:	6a 00                	push   $0x0
  801dcf:	6a 2a                	push   $0x2a
  801dd1:	e8 e2 fa ff ff       	call   8018b8 <syscall>
  801dd6:	83 c4 18             	add    $0x18,%esp
	return ;
  801dd9:	90                   	nop
}
  801dda:	c9                   	leave  
  801ddb:	c3                   	ret    

00801ddc <gettst>:
uint32 gettst()
{
  801ddc:	55                   	push   %ebp
  801ddd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801ddf:	6a 00                	push   $0x0
  801de1:	6a 00                	push   $0x0
  801de3:	6a 00                	push   $0x0
  801de5:	6a 00                	push   $0x0
  801de7:	6a 00                	push   $0x0
  801de9:	6a 2b                	push   $0x2b
  801deb:	e8 c8 fa ff ff       	call   8018b8 <syscall>
  801df0:	83 c4 18             	add    $0x18,%esp
}
  801df3:	c9                   	leave  
  801df4:	c3                   	ret    

00801df5 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801df5:	55                   	push   %ebp
  801df6:	89 e5                	mov    %esp,%ebp
  801df8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dfb:	6a 00                	push   $0x0
  801dfd:	6a 00                	push   $0x0
  801dff:	6a 00                	push   $0x0
  801e01:	6a 00                	push   $0x0
  801e03:	6a 00                	push   $0x0
  801e05:	6a 2c                	push   $0x2c
  801e07:	e8 ac fa ff ff       	call   8018b8 <syscall>
  801e0c:	83 c4 18             	add    $0x18,%esp
  801e0f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801e12:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e16:	75 07                	jne    801e1f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e18:	b8 01 00 00 00       	mov    $0x1,%eax
  801e1d:	eb 05                	jmp    801e24 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e1f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e24:	c9                   	leave  
  801e25:	c3                   	ret    

00801e26 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e26:	55                   	push   %ebp
  801e27:	89 e5                	mov    %esp,%ebp
  801e29:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e2c:	6a 00                	push   $0x0
  801e2e:	6a 00                	push   $0x0
  801e30:	6a 00                	push   $0x0
  801e32:	6a 00                	push   $0x0
  801e34:	6a 00                	push   $0x0
  801e36:	6a 2c                	push   $0x2c
  801e38:	e8 7b fa ff ff       	call   8018b8 <syscall>
  801e3d:	83 c4 18             	add    $0x18,%esp
  801e40:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e43:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e47:	75 07                	jne    801e50 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e49:	b8 01 00 00 00       	mov    $0x1,%eax
  801e4e:	eb 05                	jmp    801e55 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e50:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e55:	c9                   	leave  
  801e56:	c3                   	ret    

00801e57 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e57:	55                   	push   %ebp
  801e58:	89 e5                	mov    %esp,%ebp
  801e5a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e5d:	6a 00                	push   $0x0
  801e5f:	6a 00                	push   $0x0
  801e61:	6a 00                	push   $0x0
  801e63:	6a 00                	push   $0x0
  801e65:	6a 00                	push   $0x0
  801e67:	6a 2c                	push   $0x2c
  801e69:	e8 4a fa ff ff       	call   8018b8 <syscall>
  801e6e:	83 c4 18             	add    $0x18,%esp
  801e71:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e74:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e78:	75 07                	jne    801e81 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e7a:	b8 01 00 00 00       	mov    $0x1,%eax
  801e7f:	eb 05                	jmp    801e86 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e81:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e86:	c9                   	leave  
  801e87:	c3                   	ret    

00801e88 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e88:	55                   	push   %ebp
  801e89:	89 e5                	mov    %esp,%ebp
  801e8b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e8e:	6a 00                	push   $0x0
  801e90:	6a 00                	push   $0x0
  801e92:	6a 00                	push   $0x0
  801e94:	6a 00                	push   $0x0
  801e96:	6a 00                	push   $0x0
  801e98:	6a 2c                	push   $0x2c
  801e9a:	e8 19 fa ff ff       	call   8018b8 <syscall>
  801e9f:	83 c4 18             	add    $0x18,%esp
  801ea2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801ea5:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801ea9:	75 07                	jne    801eb2 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801eab:	b8 01 00 00 00       	mov    $0x1,%eax
  801eb0:	eb 05                	jmp    801eb7 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801eb2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eb7:	c9                   	leave  
  801eb8:	c3                   	ret    

00801eb9 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801eb9:	55                   	push   %ebp
  801eba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801ebc:	6a 00                	push   $0x0
  801ebe:	6a 00                	push   $0x0
  801ec0:	6a 00                	push   $0x0
  801ec2:	6a 00                	push   $0x0
  801ec4:	ff 75 08             	pushl  0x8(%ebp)
  801ec7:	6a 2d                	push   $0x2d
  801ec9:	e8 ea f9 ff ff       	call   8018b8 <syscall>
  801ece:	83 c4 18             	add    $0x18,%esp
	return ;
  801ed1:	90                   	nop
}
  801ed2:	c9                   	leave  
  801ed3:	c3                   	ret    

00801ed4 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801ed4:	55                   	push   %ebp
  801ed5:	89 e5                	mov    %esp,%ebp
  801ed7:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801ed8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801edb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ede:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee4:	6a 00                	push   $0x0
  801ee6:	53                   	push   %ebx
  801ee7:	51                   	push   %ecx
  801ee8:	52                   	push   %edx
  801ee9:	50                   	push   %eax
  801eea:	6a 2e                	push   $0x2e
  801eec:	e8 c7 f9 ff ff       	call   8018b8 <syscall>
  801ef1:	83 c4 18             	add    $0x18,%esp
}
  801ef4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ef7:	c9                   	leave  
  801ef8:	c3                   	ret    

00801ef9 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ef9:	55                   	push   %ebp
  801efa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801efc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eff:	8b 45 08             	mov    0x8(%ebp),%eax
  801f02:	6a 00                	push   $0x0
  801f04:	6a 00                	push   $0x0
  801f06:	6a 00                	push   $0x0
  801f08:	52                   	push   %edx
  801f09:	50                   	push   %eax
  801f0a:	6a 2f                	push   $0x2f
  801f0c:	e8 a7 f9 ff ff       	call   8018b8 <syscall>
  801f11:	83 c4 18             	add    $0x18,%esp
}
  801f14:	c9                   	leave  
  801f15:	c3                   	ret    

00801f16 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801f16:	55                   	push   %ebp
  801f17:	89 e5                	mov    %esp,%ebp
  801f19:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801f1c:	83 ec 0c             	sub    $0xc,%esp
  801f1f:	68 04 42 80 00       	push   $0x804204
  801f24:	e8 46 e8 ff ff       	call   80076f <cprintf>
  801f29:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801f2c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801f33:	83 ec 0c             	sub    $0xc,%esp
  801f36:	68 30 42 80 00       	push   $0x804230
  801f3b:	e8 2f e8 ff ff       	call   80076f <cprintf>
  801f40:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801f43:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f47:	a1 38 51 80 00       	mov    0x805138,%eax
  801f4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f4f:	eb 56                	jmp    801fa7 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f51:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f55:	74 1c                	je     801f73 <print_mem_block_lists+0x5d>
  801f57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f5a:	8b 50 08             	mov    0x8(%eax),%edx
  801f5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f60:	8b 48 08             	mov    0x8(%eax),%ecx
  801f63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f66:	8b 40 0c             	mov    0xc(%eax),%eax
  801f69:	01 c8                	add    %ecx,%eax
  801f6b:	39 c2                	cmp    %eax,%edx
  801f6d:	73 04                	jae    801f73 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801f6f:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f76:	8b 50 08             	mov    0x8(%eax),%edx
  801f79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f7c:	8b 40 0c             	mov    0xc(%eax),%eax
  801f7f:	01 c2                	add    %eax,%edx
  801f81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f84:	8b 40 08             	mov    0x8(%eax),%eax
  801f87:	83 ec 04             	sub    $0x4,%esp
  801f8a:	52                   	push   %edx
  801f8b:	50                   	push   %eax
  801f8c:	68 45 42 80 00       	push   $0x804245
  801f91:	e8 d9 e7 ff ff       	call   80076f <cprintf>
  801f96:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f9c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f9f:	a1 40 51 80 00       	mov    0x805140,%eax
  801fa4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fa7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fab:	74 07                	je     801fb4 <print_mem_block_lists+0x9e>
  801fad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb0:	8b 00                	mov    (%eax),%eax
  801fb2:	eb 05                	jmp    801fb9 <print_mem_block_lists+0xa3>
  801fb4:	b8 00 00 00 00       	mov    $0x0,%eax
  801fb9:	a3 40 51 80 00       	mov    %eax,0x805140
  801fbe:	a1 40 51 80 00       	mov    0x805140,%eax
  801fc3:	85 c0                	test   %eax,%eax
  801fc5:	75 8a                	jne    801f51 <print_mem_block_lists+0x3b>
  801fc7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fcb:	75 84                	jne    801f51 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801fcd:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801fd1:	75 10                	jne    801fe3 <print_mem_block_lists+0xcd>
  801fd3:	83 ec 0c             	sub    $0xc,%esp
  801fd6:	68 54 42 80 00       	push   $0x804254
  801fdb:	e8 8f e7 ff ff       	call   80076f <cprintf>
  801fe0:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801fe3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801fea:	83 ec 0c             	sub    $0xc,%esp
  801fed:	68 78 42 80 00       	push   $0x804278
  801ff2:	e8 78 e7 ff ff       	call   80076f <cprintf>
  801ff7:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801ffa:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801ffe:	a1 40 50 80 00       	mov    0x805040,%eax
  802003:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802006:	eb 56                	jmp    80205e <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802008:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80200c:	74 1c                	je     80202a <print_mem_block_lists+0x114>
  80200e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802011:	8b 50 08             	mov    0x8(%eax),%edx
  802014:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802017:	8b 48 08             	mov    0x8(%eax),%ecx
  80201a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80201d:	8b 40 0c             	mov    0xc(%eax),%eax
  802020:	01 c8                	add    %ecx,%eax
  802022:	39 c2                	cmp    %eax,%edx
  802024:	73 04                	jae    80202a <print_mem_block_lists+0x114>
			sorted = 0 ;
  802026:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80202a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80202d:	8b 50 08             	mov    0x8(%eax),%edx
  802030:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802033:	8b 40 0c             	mov    0xc(%eax),%eax
  802036:	01 c2                	add    %eax,%edx
  802038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80203b:	8b 40 08             	mov    0x8(%eax),%eax
  80203e:	83 ec 04             	sub    $0x4,%esp
  802041:	52                   	push   %edx
  802042:	50                   	push   %eax
  802043:	68 45 42 80 00       	push   $0x804245
  802048:	e8 22 e7 ff ff       	call   80076f <cprintf>
  80204d:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802050:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802053:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802056:	a1 48 50 80 00       	mov    0x805048,%eax
  80205b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80205e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802062:	74 07                	je     80206b <print_mem_block_lists+0x155>
  802064:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802067:	8b 00                	mov    (%eax),%eax
  802069:	eb 05                	jmp    802070 <print_mem_block_lists+0x15a>
  80206b:	b8 00 00 00 00       	mov    $0x0,%eax
  802070:	a3 48 50 80 00       	mov    %eax,0x805048
  802075:	a1 48 50 80 00       	mov    0x805048,%eax
  80207a:	85 c0                	test   %eax,%eax
  80207c:	75 8a                	jne    802008 <print_mem_block_lists+0xf2>
  80207e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802082:	75 84                	jne    802008 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802084:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802088:	75 10                	jne    80209a <print_mem_block_lists+0x184>
  80208a:	83 ec 0c             	sub    $0xc,%esp
  80208d:	68 90 42 80 00       	push   $0x804290
  802092:	e8 d8 e6 ff ff       	call   80076f <cprintf>
  802097:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80209a:	83 ec 0c             	sub    $0xc,%esp
  80209d:	68 04 42 80 00       	push   $0x804204
  8020a2:	e8 c8 e6 ff ff       	call   80076f <cprintf>
  8020a7:	83 c4 10             	add    $0x10,%esp

}
  8020aa:	90                   	nop
  8020ab:	c9                   	leave  
  8020ac:	c3                   	ret    

008020ad <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8020ad:	55                   	push   %ebp
  8020ae:	89 e5                	mov    %esp,%ebp
  8020b0:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  8020b3:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8020ba:	00 00 00 
  8020bd:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8020c4:	00 00 00 
  8020c7:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8020ce:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  8020d1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8020d8:	e9 9e 00 00 00       	jmp    80217b <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  8020dd:	a1 50 50 80 00       	mov    0x805050,%eax
  8020e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020e5:	c1 e2 04             	shl    $0x4,%edx
  8020e8:	01 d0                	add    %edx,%eax
  8020ea:	85 c0                	test   %eax,%eax
  8020ec:	75 14                	jne    802102 <initialize_MemBlocksList+0x55>
  8020ee:	83 ec 04             	sub    $0x4,%esp
  8020f1:	68 b8 42 80 00       	push   $0x8042b8
  8020f6:	6a 46                	push   $0x46
  8020f8:	68 db 42 80 00       	push   $0x8042db
  8020fd:	e8 b9 e3 ff ff       	call   8004bb <_panic>
  802102:	a1 50 50 80 00       	mov    0x805050,%eax
  802107:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80210a:	c1 e2 04             	shl    $0x4,%edx
  80210d:	01 d0                	add    %edx,%eax
  80210f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802115:	89 10                	mov    %edx,(%eax)
  802117:	8b 00                	mov    (%eax),%eax
  802119:	85 c0                	test   %eax,%eax
  80211b:	74 18                	je     802135 <initialize_MemBlocksList+0x88>
  80211d:	a1 48 51 80 00       	mov    0x805148,%eax
  802122:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802128:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80212b:	c1 e1 04             	shl    $0x4,%ecx
  80212e:	01 ca                	add    %ecx,%edx
  802130:	89 50 04             	mov    %edx,0x4(%eax)
  802133:	eb 12                	jmp    802147 <initialize_MemBlocksList+0x9a>
  802135:	a1 50 50 80 00       	mov    0x805050,%eax
  80213a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80213d:	c1 e2 04             	shl    $0x4,%edx
  802140:	01 d0                	add    %edx,%eax
  802142:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802147:	a1 50 50 80 00       	mov    0x805050,%eax
  80214c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80214f:	c1 e2 04             	shl    $0x4,%edx
  802152:	01 d0                	add    %edx,%eax
  802154:	a3 48 51 80 00       	mov    %eax,0x805148
  802159:	a1 50 50 80 00       	mov    0x805050,%eax
  80215e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802161:	c1 e2 04             	shl    $0x4,%edx
  802164:	01 d0                	add    %edx,%eax
  802166:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80216d:	a1 54 51 80 00       	mov    0x805154,%eax
  802172:	40                   	inc    %eax
  802173:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802178:	ff 45 f4             	incl   -0xc(%ebp)
  80217b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80217e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802181:	0f 82 56 ff ff ff    	jb     8020dd <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802187:	90                   	nop
  802188:	c9                   	leave  
  802189:	c3                   	ret    

0080218a <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80218a:	55                   	push   %ebp
  80218b:	89 e5                	mov    %esp,%ebp
  80218d:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802190:	8b 45 08             	mov    0x8(%ebp),%eax
  802193:	8b 00                	mov    (%eax),%eax
  802195:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802198:	eb 19                	jmp    8021b3 <find_block+0x29>
	{
		if(va==point->sva)
  80219a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80219d:	8b 40 08             	mov    0x8(%eax),%eax
  8021a0:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8021a3:	75 05                	jne    8021aa <find_block+0x20>
		   return point;
  8021a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021a8:	eb 36                	jmp    8021e0 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8021aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ad:	8b 40 08             	mov    0x8(%eax),%eax
  8021b0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8021b3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021b7:	74 07                	je     8021c0 <find_block+0x36>
  8021b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021bc:	8b 00                	mov    (%eax),%eax
  8021be:	eb 05                	jmp    8021c5 <find_block+0x3b>
  8021c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8021c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8021c8:	89 42 08             	mov    %eax,0x8(%edx)
  8021cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ce:	8b 40 08             	mov    0x8(%eax),%eax
  8021d1:	85 c0                	test   %eax,%eax
  8021d3:	75 c5                	jne    80219a <find_block+0x10>
  8021d5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021d9:	75 bf                	jne    80219a <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  8021db:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021e0:	c9                   	leave  
  8021e1:	c3                   	ret    

008021e2 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8021e2:	55                   	push   %ebp
  8021e3:	89 e5                	mov    %esp,%ebp
  8021e5:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  8021e8:	a1 40 50 80 00       	mov    0x805040,%eax
  8021ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  8021f0:	a1 44 50 80 00       	mov    0x805044,%eax
  8021f5:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8021f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021fb:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8021fe:	74 24                	je     802224 <insert_sorted_allocList+0x42>
  802200:	8b 45 08             	mov    0x8(%ebp),%eax
  802203:	8b 50 08             	mov    0x8(%eax),%edx
  802206:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802209:	8b 40 08             	mov    0x8(%eax),%eax
  80220c:	39 c2                	cmp    %eax,%edx
  80220e:	76 14                	jbe    802224 <insert_sorted_allocList+0x42>
  802210:	8b 45 08             	mov    0x8(%ebp),%eax
  802213:	8b 50 08             	mov    0x8(%eax),%edx
  802216:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802219:	8b 40 08             	mov    0x8(%eax),%eax
  80221c:	39 c2                	cmp    %eax,%edx
  80221e:	0f 82 60 01 00 00    	jb     802384 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802224:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802228:	75 65                	jne    80228f <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  80222a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80222e:	75 14                	jne    802244 <insert_sorted_allocList+0x62>
  802230:	83 ec 04             	sub    $0x4,%esp
  802233:	68 b8 42 80 00       	push   $0x8042b8
  802238:	6a 6b                	push   $0x6b
  80223a:	68 db 42 80 00       	push   $0x8042db
  80223f:	e8 77 e2 ff ff       	call   8004bb <_panic>
  802244:	8b 15 40 50 80 00    	mov    0x805040,%edx
  80224a:	8b 45 08             	mov    0x8(%ebp),%eax
  80224d:	89 10                	mov    %edx,(%eax)
  80224f:	8b 45 08             	mov    0x8(%ebp),%eax
  802252:	8b 00                	mov    (%eax),%eax
  802254:	85 c0                	test   %eax,%eax
  802256:	74 0d                	je     802265 <insert_sorted_allocList+0x83>
  802258:	a1 40 50 80 00       	mov    0x805040,%eax
  80225d:	8b 55 08             	mov    0x8(%ebp),%edx
  802260:	89 50 04             	mov    %edx,0x4(%eax)
  802263:	eb 08                	jmp    80226d <insert_sorted_allocList+0x8b>
  802265:	8b 45 08             	mov    0x8(%ebp),%eax
  802268:	a3 44 50 80 00       	mov    %eax,0x805044
  80226d:	8b 45 08             	mov    0x8(%ebp),%eax
  802270:	a3 40 50 80 00       	mov    %eax,0x805040
  802275:	8b 45 08             	mov    0x8(%ebp),%eax
  802278:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80227f:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802284:	40                   	inc    %eax
  802285:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80228a:	e9 dc 01 00 00       	jmp    80246b <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  80228f:	8b 45 08             	mov    0x8(%ebp),%eax
  802292:	8b 50 08             	mov    0x8(%eax),%edx
  802295:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802298:	8b 40 08             	mov    0x8(%eax),%eax
  80229b:	39 c2                	cmp    %eax,%edx
  80229d:	77 6c                	ja     80230b <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  80229f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022a3:	74 06                	je     8022ab <insert_sorted_allocList+0xc9>
  8022a5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022a9:	75 14                	jne    8022bf <insert_sorted_allocList+0xdd>
  8022ab:	83 ec 04             	sub    $0x4,%esp
  8022ae:	68 f4 42 80 00       	push   $0x8042f4
  8022b3:	6a 6f                	push   $0x6f
  8022b5:	68 db 42 80 00       	push   $0x8042db
  8022ba:	e8 fc e1 ff ff       	call   8004bb <_panic>
  8022bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022c2:	8b 50 04             	mov    0x4(%eax),%edx
  8022c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c8:	89 50 04             	mov    %edx,0x4(%eax)
  8022cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ce:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022d1:	89 10                	mov    %edx,(%eax)
  8022d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022d6:	8b 40 04             	mov    0x4(%eax),%eax
  8022d9:	85 c0                	test   %eax,%eax
  8022db:	74 0d                	je     8022ea <insert_sorted_allocList+0x108>
  8022dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022e0:	8b 40 04             	mov    0x4(%eax),%eax
  8022e3:	8b 55 08             	mov    0x8(%ebp),%edx
  8022e6:	89 10                	mov    %edx,(%eax)
  8022e8:	eb 08                	jmp    8022f2 <insert_sorted_allocList+0x110>
  8022ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ed:	a3 40 50 80 00       	mov    %eax,0x805040
  8022f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022f5:	8b 55 08             	mov    0x8(%ebp),%edx
  8022f8:	89 50 04             	mov    %edx,0x4(%eax)
  8022fb:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802300:	40                   	inc    %eax
  802301:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802306:	e9 60 01 00 00       	jmp    80246b <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  80230b:	8b 45 08             	mov    0x8(%ebp),%eax
  80230e:	8b 50 08             	mov    0x8(%eax),%edx
  802311:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802314:	8b 40 08             	mov    0x8(%eax),%eax
  802317:	39 c2                	cmp    %eax,%edx
  802319:	0f 82 4c 01 00 00    	jb     80246b <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  80231f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802323:	75 14                	jne    802339 <insert_sorted_allocList+0x157>
  802325:	83 ec 04             	sub    $0x4,%esp
  802328:	68 2c 43 80 00       	push   $0x80432c
  80232d:	6a 73                	push   $0x73
  80232f:	68 db 42 80 00       	push   $0x8042db
  802334:	e8 82 e1 ff ff       	call   8004bb <_panic>
  802339:	8b 15 44 50 80 00    	mov    0x805044,%edx
  80233f:	8b 45 08             	mov    0x8(%ebp),%eax
  802342:	89 50 04             	mov    %edx,0x4(%eax)
  802345:	8b 45 08             	mov    0x8(%ebp),%eax
  802348:	8b 40 04             	mov    0x4(%eax),%eax
  80234b:	85 c0                	test   %eax,%eax
  80234d:	74 0c                	je     80235b <insert_sorted_allocList+0x179>
  80234f:	a1 44 50 80 00       	mov    0x805044,%eax
  802354:	8b 55 08             	mov    0x8(%ebp),%edx
  802357:	89 10                	mov    %edx,(%eax)
  802359:	eb 08                	jmp    802363 <insert_sorted_allocList+0x181>
  80235b:	8b 45 08             	mov    0x8(%ebp),%eax
  80235e:	a3 40 50 80 00       	mov    %eax,0x805040
  802363:	8b 45 08             	mov    0x8(%ebp),%eax
  802366:	a3 44 50 80 00       	mov    %eax,0x805044
  80236b:	8b 45 08             	mov    0x8(%ebp),%eax
  80236e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802374:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802379:	40                   	inc    %eax
  80237a:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80237f:	e9 e7 00 00 00       	jmp    80246b <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802384:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802387:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  80238a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802391:	a1 40 50 80 00       	mov    0x805040,%eax
  802396:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802399:	e9 9d 00 00 00       	jmp    80243b <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  80239e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a1:	8b 00                	mov    (%eax),%eax
  8023a3:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8023a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a9:	8b 50 08             	mov    0x8(%eax),%edx
  8023ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023af:	8b 40 08             	mov    0x8(%eax),%eax
  8023b2:	39 c2                	cmp    %eax,%edx
  8023b4:	76 7d                	jbe    802433 <insert_sorted_allocList+0x251>
  8023b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b9:	8b 50 08             	mov    0x8(%eax),%edx
  8023bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8023bf:	8b 40 08             	mov    0x8(%eax),%eax
  8023c2:	39 c2                	cmp    %eax,%edx
  8023c4:	73 6d                	jae    802433 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8023c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023ca:	74 06                	je     8023d2 <insert_sorted_allocList+0x1f0>
  8023cc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023d0:	75 14                	jne    8023e6 <insert_sorted_allocList+0x204>
  8023d2:	83 ec 04             	sub    $0x4,%esp
  8023d5:	68 50 43 80 00       	push   $0x804350
  8023da:	6a 7f                	push   $0x7f
  8023dc:	68 db 42 80 00       	push   $0x8042db
  8023e1:	e8 d5 e0 ff ff       	call   8004bb <_panic>
  8023e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e9:	8b 10                	mov    (%eax),%edx
  8023eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ee:	89 10                	mov    %edx,(%eax)
  8023f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f3:	8b 00                	mov    (%eax),%eax
  8023f5:	85 c0                	test   %eax,%eax
  8023f7:	74 0b                	je     802404 <insert_sorted_allocList+0x222>
  8023f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fc:	8b 00                	mov    (%eax),%eax
  8023fe:	8b 55 08             	mov    0x8(%ebp),%edx
  802401:	89 50 04             	mov    %edx,0x4(%eax)
  802404:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802407:	8b 55 08             	mov    0x8(%ebp),%edx
  80240a:	89 10                	mov    %edx,(%eax)
  80240c:	8b 45 08             	mov    0x8(%ebp),%eax
  80240f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802412:	89 50 04             	mov    %edx,0x4(%eax)
  802415:	8b 45 08             	mov    0x8(%ebp),%eax
  802418:	8b 00                	mov    (%eax),%eax
  80241a:	85 c0                	test   %eax,%eax
  80241c:	75 08                	jne    802426 <insert_sorted_allocList+0x244>
  80241e:	8b 45 08             	mov    0x8(%ebp),%eax
  802421:	a3 44 50 80 00       	mov    %eax,0x805044
  802426:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80242b:	40                   	inc    %eax
  80242c:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802431:	eb 39                	jmp    80246c <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802433:	a1 48 50 80 00       	mov    0x805048,%eax
  802438:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80243b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80243f:	74 07                	je     802448 <insert_sorted_allocList+0x266>
  802441:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802444:	8b 00                	mov    (%eax),%eax
  802446:	eb 05                	jmp    80244d <insert_sorted_allocList+0x26b>
  802448:	b8 00 00 00 00       	mov    $0x0,%eax
  80244d:	a3 48 50 80 00       	mov    %eax,0x805048
  802452:	a1 48 50 80 00       	mov    0x805048,%eax
  802457:	85 c0                	test   %eax,%eax
  802459:	0f 85 3f ff ff ff    	jne    80239e <insert_sorted_allocList+0x1bc>
  80245f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802463:	0f 85 35 ff ff ff    	jne    80239e <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802469:	eb 01                	jmp    80246c <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80246b:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80246c:	90                   	nop
  80246d:	c9                   	leave  
  80246e:	c3                   	ret    

0080246f <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80246f:	55                   	push   %ebp
  802470:	89 e5                	mov    %esp,%ebp
  802472:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802475:	a1 38 51 80 00       	mov    0x805138,%eax
  80247a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80247d:	e9 85 01 00 00       	jmp    802607 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802482:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802485:	8b 40 0c             	mov    0xc(%eax),%eax
  802488:	3b 45 08             	cmp    0x8(%ebp),%eax
  80248b:	0f 82 6e 01 00 00    	jb     8025ff <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802491:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802494:	8b 40 0c             	mov    0xc(%eax),%eax
  802497:	3b 45 08             	cmp    0x8(%ebp),%eax
  80249a:	0f 85 8a 00 00 00    	jne    80252a <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8024a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024a4:	75 17                	jne    8024bd <alloc_block_FF+0x4e>
  8024a6:	83 ec 04             	sub    $0x4,%esp
  8024a9:	68 84 43 80 00       	push   $0x804384
  8024ae:	68 93 00 00 00       	push   $0x93
  8024b3:	68 db 42 80 00       	push   $0x8042db
  8024b8:	e8 fe df ff ff       	call   8004bb <_panic>
  8024bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c0:	8b 00                	mov    (%eax),%eax
  8024c2:	85 c0                	test   %eax,%eax
  8024c4:	74 10                	je     8024d6 <alloc_block_FF+0x67>
  8024c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c9:	8b 00                	mov    (%eax),%eax
  8024cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024ce:	8b 52 04             	mov    0x4(%edx),%edx
  8024d1:	89 50 04             	mov    %edx,0x4(%eax)
  8024d4:	eb 0b                	jmp    8024e1 <alloc_block_FF+0x72>
  8024d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d9:	8b 40 04             	mov    0x4(%eax),%eax
  8024dc:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8024e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e4:	8b 40 04             	mov    0x4(%eax),%eax
  8024e7:	85 c0                	test   %eax,%eax
  8024e9:	74 0f                	je     8024fa <alloc_block_FF+0x8b>
  8024eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ee:	8b 40 04             	mov    0x4(%eax),%eax
  8024f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024f4:	8b 12                	mov    (%edx),%edx
  8024f6:	89 10                	mov    %edx,(%eax)
  8024f8:	eb 0a                	jmp    802504 <alloc_block_FF+0x95>
  8024fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fd:	8b 00                	mov    (%eax),%eax
  8024ff:	a3 38 51 80 00       	mov    %eax,0x805138
  802504:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802507:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80250d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802510:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802517:	a1 44 51 80 00       	mov    0x805144,%eax
  80251c:	48                   	dec    %eax
  80251d:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802522:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802525:	e9 10 01 00 00       	jmp    80263a <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  80252a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252d:	8b 40 0c             	mov    0xc(%eax),%eax
  802530:	3b 45 08             	cmp    0x8(%ebp),%eax
  802533:	0f 86 c6 00 00 00    	jbe    8025ff <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802539:	a1 48 51 80 00       	mov    0x805148,%eax
  80253e:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802541:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802544:	8b 50 08             	mov    0x8(%eax),%edx
  802547:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80254a:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  80254d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802550:	8b 55 08             	mov    0x8(%ebp),%edx
  802553:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802556:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80255a:	75 17                	jne    802573 <alloc_block_FF+0x104>
  80255c:	83 ec 04             	sub    $0x4,%esp
  80255f:	68 84 43 80 00       	push   $0x804384
  802564:	68 9b 00 00 00       	push   $0x9b
  802569:	68 db 42 80 00       	push   $0x8042db
  80256e:	e8 48 df ff ff       	call   8004bb <_panic>
  802573:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802576:	8b 00                	mov    (%eax),%eax
  802578:	85 c0                	test   %eax,%eax
  80257a:	74 10                	je     80258c <alloc_block_FF+0x11d>
  80257c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80257f:	8b 00                	mov    (%eax),%eax
  802581:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802584:	8b 52 04             	mov    0x4(%edx),%edx
  802587:	89 50 04             	mov    %edx,0x4(%eax)
  80258a:	eb 0b                	jmp    802597 <alloc_block_FF+0x128>
  80258c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80258f:	8b 40 04             	mov    0x4(%eax),%eax
  802592:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802597:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80259a:	8b 40 04             	mov    0x4(%eax),%eax
  80259d:	85 c0                	test   %eax,%eax
  80259f:	74 0f                	je     8025b0 <alloc_block_FF+0x141>
  8025a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025a4:	8b 40 04             	mov    0x4(%eax),%eax
  8025a7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025aa:	8b 12                	mov    (%edx),%edx
  8025ac:	89 10                	mov    %edx,(%eax)
  8025ae:	eb 0a                	jmp    8025ba <alloc_block_FF+0x14b>
  8025b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025b3:	8b 00                	mov    (%eax),%eax
  8025b5:	a3 48 51 80 00       	mov    %eax,0x805148
  8025ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025bd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025c6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025cd:	a1 54 51 80 00       	mov    0x805154,%eax
  8025d2:	48                   	dec    %eax
  8025d3:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  8025d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025db:	8b 50 08             	mov    0x8(%eax),%edx
  8025de:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e1:	01 c2                	add    %eax,%edx
  8025e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e6:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8025e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ec:	8b 40 0c             	mov    0xc(%eax),%eax
  8025ef:	2b 45 08             	sub    0x8(%ebp),%eax
  8025f2:	89 c2                	mov    %eax,%edx
  8025f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f7:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8025fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025fd:	eb 3b                	jmp    80263a <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8025ff:	a1 40 51 80 00       	mov    0x805140,%eax
  802604:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802607:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80260b:	74 07                	je     802614 <alloc_block_FF+0x1a5>
  80260d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802610:	8b 00                	mov    (%eax),%eax
  802612:	eb 05                	jmp    802619 <alloc_block_FF+0x1aa>
  802614:	b8 00 00 00 00       	mov    $0x0,%eax
  802619:	a3 40 51 80 00       	mov    %eax,0x805140
  80261e:	a1 40 51 80 00       	mov    0x805140,%eax
  802623:	85 c0                	test   %eax,%eax
  802625:	0f 85 57 fe ff ff    	jne    802482 <alloc_block_FF+0x13>
  80262b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80262f:	0f 85 4d fe ff ff    	jne    802482 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802635:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80263a:	c9                   	leave  
  80263b:	c3                   	ret    

0080263c <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80263c:	55                   	push   %ebp
  80263d:	89 e5                	mov    %esp,%ebp
  80263f:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802642:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802649:	a1 38 51 80 00       	mov    0x805138,%eax
  80264e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802651:	e9 df 00 00 00       	jmp    802735 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802656:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802659:	8b 40 0c             	mov    0xc(%eax),%eax
  80265c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80265f:	0f 82 c8 00 00 00    	jb     80272d <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802665:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802668:	8b 40 0c             	mov    0xc(%eax),%eax
  80266b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80266e:	0f 85 8a 00 00 00    	jne    8026fe <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802674:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802678:	75 17                	jne    802691 <alloc_block_BF+0x55>
  80267a:	83 ec 04             	sub    $0x4,%esp
  80267d:	68 84 43 80 00       	push   $0x804384
  802682:	68 b7 00 00 00       	push   $0xb7
  802687:	68 db 42 80 00       	push   $0x8042db
  80268c:	e8 2a de ff ff       	call   8004bb <_panic>
  802691:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802694:	8b 00                	mov    (%eax),%eax
  802696:	85 c0                	test   %eax,%eax
  802698:	74 10                	je     8026aa <alloc_block_BF+0x6e>
  80269a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269d:	8b 00                	mov    (%eax),%eax
  80269f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026a2:	8b 52 04             	mov    0x4(%edx),%edx
  8026a5:	89 50 04             	mov    %edx,0x4(%eax)
  8026a8:	eb 0b                	jmp    8026b5 <alloc_block_BF+0x79>
  8026aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ad:	8b 40 04             	mov    0x4(%eax),%eax
  8026b0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8026b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b8:	8b 40 04             	mov    0x4(%eax),%eax
  8026bb:	85 c0                	test   %eax,%eax
  8026bd:	74 0f                	je     8026ce <alloc_block_BF+0x92>
  8026bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c2:	8b 40 04             	mov    0x4(%eax),%eax
  8026c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026c8:	8b 12                	mov    (%edx),%edx
  8026ca:	89 10                	mov    %edx,(%eax)
  8026cc:	eb 0a                	jmp    8026d8 <alloc_block_BF+0x9c>
  8026ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d1:	8b 00                	mov    (%eax),%eax
  8026d3:	a3 38 51 80 00       	mov    %eax,0x805138
  8026d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026db:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026eb:	a1 44 51 80 00       	mov    0x805144,%eax
  8026f0:	48                   	dec    %eax
  8026f1:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  8026f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f9:	e9 4d 01 00 00       	jmp    80284b <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8026fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802701:	8b 40 0c             	mov    0xc(%eax),%eax
  802704:	3b 45 08             	cmp    0x8(%ebp),%eax
  802707:	76 24                	jbe    80272d <alloc_block_BF+0xf1>
  802709:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270c:	8b 40 0c             	mov    0xc(%eax),%eax
  80270f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802712:	73 19                	jae    80272d <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802714:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  80271b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271e:	8b 40 0c             	mov    0xc(%eax),%eax
  802721:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802724:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802727:	8b 40 08             	mov    0x8(%eax),%eax
  80272a:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80272d:	a1 40 51 80 00       	mov    0x805140,%eax
  802732:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802735:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802739:	74 07                	je     802742 <alloc_block_BF+0x106>
  80273b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273e:	8b 00                	mov    (%eax),%eax
  802740:	eb 05                	jmp    802747 <alloc_block_BF+0x10b>
  802742:	b8 00 00 00 00       	mov    $0x0,%eax
  802747:	a3 40 51 80 00       	mov    %eax,0x805140
  80274c:	a1 40 51 80 00       	mov    0x805140,%eax
  802751:	85 c0                	test   %eax,%eax
  802753:	0f 85 fd fe ff ff    	jne    802656 <alloc_block_BF+0x1a>
  802759:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80275d:	0f 85 f3 fe ff ff    	jne    802656 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802763:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802767:	0f 84 d9 00 00 00    	je     802846 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  80276d:	a1 48 51 80 00       	mov    0x805148,%eax
  802772:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802775:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802778:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80277b:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  80277e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802781:	8b 55 08             	mov    0x8(%ebp),%edx
  802784:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802787:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80278b:	75 17                	jne    8027a4 <alloc_block_BF+0x168>
  80278d:	83 ec 04             	sub    $0x4,%esp
  802790:	68 84 43 80 00       	push   $0x804384
  802795:	68 c7 00 00 00       	push   $0xc7
  80279a:	68 db 42 80 00       	push   $0x8042db
  80279f:	e8 17 dd ff ff       	call   8004bb <_panic>
  8027a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027a7:	8b 00                	mov    (%eax),%eax
  8027a9:	85 c0                	test   %eax,%eax
  8027ab:	74 10                	je     8027bd <alloc_block_BF+0x181>
  8027ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027b0:	8b 00                	mov    (%eax),%eax
  8027b2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027b5:	8b 52 04             	mov    0x4(%edx),%edx
  8027b8:	89 50 04             	mov    %edx,0x4(%eax)
  8027bb:	eb 0b                	jmp    8027c8 <alloc_block_BF+0x18c>
  8027bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027c0:	8b 40 04             	mov    0x4(%eax),%eax
  8027c3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8027c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027cb:	8b 40 04             	mov    0x4(%eax),%eax
  8027ce:	85 c0                	test   %eax,%eax
  8027d0:	74 0f                	je     8027e1 <alloc_block_BF+0x1a5>
  8027d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027d5:	8b 40 04             	mov    0x4(%eax),%eax
  8027d8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027db:	8b 12                	mov    (%edx),%edx
  8027dd:	89 10                	mov    %edx,(%eax)
  8027df:	eb 0a                	jmp    8027eb <alloc_block_BF+0x1af>
  8027e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027e4:	8b 00                	mov    (%eax),%eax
  8027e6:	a3 48 51 80 00       	mov    %eax,0x805148
  8027eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027ee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027f7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027fe:	a1 54 51 80 00       	mov    0x805154,%eax
  802803:	48                   	dec    %eax
  802804:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802809:	83 ec 08             	sub    $0x8,%esp
  80280c:	ff 75 ec             	pushl  -0x14(%ebp)
  80280f:	68 38 51 80 00       	push   $0x805138
  802814:	e8 71 f9 ff ff       	call   80218a <find_block>
  802819:	83 c4 10             	add    $0x10,%esp
  80281c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  80281f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802822:	8b 50 08             	mov    0x8(%eax),%edx
  802825:	8b 45 08             	mov    0x8(%ebp),%eax
  802828:	01 c2                	add    %eax,%edx
  80282a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80282d:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802830:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802833:	8b 40 0c             	mov    0xc(%eax),%eax
  802836:	2b 45 08             	sub    0x8(%ebp),%eax
  802839:	89 c2                	mov    %eax,%edx
  80283b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80283e:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802841:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802844:	eb 05                	jmp    80284b <alloc_block_BF+0x20f>
	}
	return NULL;
  802846:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80284b:	c9                   	leave  
  80284c:	c3                   	ret    

0080284d <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  80284d:	55                   	push   %ebp
  80284e:	89 e5                	mov    %esp,%ebp
  802850:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802853:	a1 28 50 80 00       	mov    0x805028,%eax
  802858:	85 c0                	test   %eax,%eax
  80285a:	0f 85 de 01 00 00    	jne    802a3e <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802860:	a1 38 51 80 00       	mov    0x805138,%eax
  802865:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802868:	e9 9e 01 00 00       	jmp    802a0b <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  80286d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802870:	8b 40 0c             	mov    0xc(%eax),%eax
  802873:	3b 45 08             	cmp    0x8(%ebp),%eax
  802876:	0f 82 87 01 00 00    	jb     802a03 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  80287c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287f:	8b 40 0c             	mov    0xc(%eax),%eax
  802882:	3b 45 08             	cmp    0x8(%ebp),%eax
  802885:	0f 85 95 00 00 00    	jne    802920 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  80288b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80288f:	75 17                	jne    8028a8 <alloc_block_NF+0x5b>
  802891:	83 ec 04             	sub    $0x4,%esp
  802894:	68 84 43 80 00       	push   $0x804384
  802899:	68 e0 00 00 00       	push   $0xe0
  80289e:	68 db 42 80 00       	push   $0x8042db
  8028a3:	e8 13 dc ff ff       	call   8004bb <_panic>
  8028a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ab:	8b 00                	mov    (%eax),%eax
  8028ad:	85 c0                	test   %eax,%eax
  8028af:	74 10                	je     8028c1 <alloc_block_NF+0x74>
  8028b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b4:	8b 00                	mov    (%eax),%eax
  8028b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028b9:	8b 52 04             	mov    0x4(%edx),%edx
  8028bc:	89 50 04             	mov    %edx,0x4(%eax)
  8028bf:	eb 0b                	jmp    8028cc <alloc_block_NF+0x7f>
  8028c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c4:	8b 40 04             	mov    0x4(%eax),%eax
  8028c7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8028cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cf:	8b 40 04             	mov    0x4(%eax),%eax
  8028d2:	85 c0                	test   %eax,%eax
  8028d4:	74 0f                	je     8028e5 <alloc_block_NF+0x98>
  8028d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d9:	8b 40 04             	mov    0x4(%eax),%eax
  8028dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028df:	8b 12                	mov    (%edx),%edx
  8028e1:	89 10                	mov    %edx,(%eax)
  8028e3:	eb 0a                	jmp    8028ef <alloc_block_NF+0xa2>
  8028e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e8:	8b 00                	mov    (%eax),%eax
  8028ea:	a3 38 51 80 00       	mov    %eax,0x805138
  8028ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802902:	a1 44 51 80 00       	mov    0x805144,%eax
  802907:	48                   	dec    %eax
  802908:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  80290d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802910:	8b 40 08             	mov    0x8(%eax),%eax
  802913:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802918:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291b:	e9 f8 04 00 00       	jmp    802e18 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802920:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802923:	8b 40 0c             	mov    0xc(%eax),%eax
  802926:	3b 45 08             	cmp    0x8(%ebp),%eax
  802929:	0f 86 d4 00 00 00    	jbe    802a03 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80292f:	a1 48 51 80 00       	mov    0x805148,%eax
  802934:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802937:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293a:	8b 50 08             	mov    0x8(%eax),%edx
  80293d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802940:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802943:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802946:	8b 55 08             	mov    0x8(%ebp),%edx
  802949:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80294c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802950:	75 17                	jne    802969 <alloc_block_NF+0x11c>
  802952:	83 ec 04             	sub    $0x4,%esp
  802955:	68 84 43 80 00       	push   $0x804384
  80295a:	68 e9 00 00 00       	push   $0xe9
  80295f:	68 db 42 80 00       	push   $0x8042db
  802964:	e8 52 db ff ff       	call   8004bb <_panic>
  802969:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80296c:	8b 00                	mov    (%eax),%eax
  80296e:	85 c0                	test   %eax,%eax
  802970:	74 10                	je     802982 <alloc_block_NF+0x135>
  802972:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802975:	8b 00                	mov    (%eax),%eax
  802977:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80297a:	8b 52 04             	mov    0x4(%edx),%edx
  80297d:	89 50 04             	mov    %edx,0x4(%eax)
  802980:	eb 0b                	jmp    80298d <alloc_block_NF+0x140>
  802982:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802985:	8b 40 04             	mov    0x4(%eax),%eax
  802988:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80298d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802990:	8b 40 04             	mov    0x4(%eax),%eax
  802993:	85 c0                	test   %eax,%eax
  802995:	74 0f                	je     8029a6 <alloc_block_NF+0x159>
  802997:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80299a:	8b 40 04             	mov    0x4(%eax),%eax
  80299d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029a0:	8b 12                	mov    (%edx),%edx
  8029a2:	89 10                	mov    %edx,(%eax)
  8029a4:	eb 0a                	jmp    8029b0 <alloc_block_NF+0x163>
  8029a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a9:	8b 00                	mov    (%eax),%eax
  8029ab:	a3 48 51 80 00       	mov    %eax,0x805148
  8029b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029b3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029bc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029c3:	a1 54 51 80 00       	mov    0x805154,%eax
  8029c8:	48                   	dec    %eax
  8029c9:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  8029ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029d1:	8b 40 08             	mov    0x8(%eax),%eax
  8029d4:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  8029d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029dc:	8b 50 08             	mov    0x8(%eax),%edx
  8029df:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e2:	01 c2                	add    %eax,%edx
  8029e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e7:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  8029ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ed:	8b 40 0c             	mov    0xc(%eax),%eax
  8029f0:	2b 45 08             	sub    0x8(%ebp),%eax
  8029f3:	89 c2                	mov    %eax,%edx
  8029f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f8:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  8029fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029fe:	e9 15 04 00 00       	jmp    802e18 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802a03:	a1 40 51 80 00       	mov    0x805140,%eax
  802a08:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a0b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a0f:	74 07                	je     802a18 <alloc_block_NF+0x1cb>
  802a11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a14:	8b 00                	mov    (%eax),%eax
  802a16:	eb 05                	jmp    802a1d <alloc_block_NF+0x1d0>
  802a18:	b8 00 00 00 00       	mov    $0x0,%eax
  802a1d:	a3 40 51 80 00       	mov    %eax,0x805140
  802a22:	a1 40 51 80 00       	mov    0x805140,%eax
  802a27:	85 c0                	test   %eax,%eax
  802a29:	0f 85 3e fe ff ff    	jne    80286d <alloc_block_NF+0x20>
  802a2f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a33:	0f 85 34 fe ff ff    	jne    80286d <alloc_block_NF+0x20>
  802a39:	e9 d5 03 00 00       	jmp    802e13 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a3e:	a1 38 51 80 00       	mov    0x805138,%eax
  802a43:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a46:	e9 b1 01 00 00       	jmp    802bfc <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802a4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4e:	8b 50 08             	mov    0x8(%eax),%edx
  802a51:	a1 28 50 80 00       	mov    0x805028,%eax
  802a56:	39 c2                	cmp    %eax,%edx
  802a58:	0f 82 96 01 00 00    	jb     802bf4 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802a5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a61:	8b 40 0c             	mov    0xc(%eax),%eax
  802a64:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a67:	0f 82 87 01 00 00    	jb     802bf4 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802a6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a70:	8b 40 0c             	mov    0xc(%eax),%eax
  802a73:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a76:	0f 85 95 00 00 00    	jne    802b11 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802a7c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a80:	75 17                	jne    802a99 <alloc_block_NF+0x24c>
  802a82:	83 ec 04             	sub    $0x4,%esp
  802a85:	68 84 43 80 00       	push   $0x804384
  802a8a:	68 fc 00 00 00       	push   $0xfc
  802a8f:	68 db 42 80 00       	push   $0x8042db
  802a94:	e8 22 da ff ff       	call   8004bb <_panic>
  802a99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9c:	8b 00                	mov    (%eax),%eax
  802a9e:	85 c0                	test   %eax,%eax
  802aa0:	74 10                	je     802ab2 <alloc_block_NF+0x265>
  802aa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa5:	8b 00                	mov    (%eax),%eax
  802aa7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802aaa:	8b 52 04             	mov    0x4(%edx),%edx
  802aad:	89 50 04             	mov    %edx,0x4(%eax)
  802ab0:	eb 0b                	jmp    802abd <alloc_block_NF+0x270>
  802ab2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab5:	8b 40 04             	mov    0x4(%eax),%eax
  802ab8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802abd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac0:	8b 40 04             	mov    0x4(%eax),%eax
  802ac3:	85 c0                	test   %eax,%eax
  802ac5:	74 0f                	je     802ad6 <alloc_block_NF+0x289>
  802ac7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aca:	8b 40 04             	mov    0x4(%eax),%eax
  802acd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ad0:	8b 12                	mov    (%edx),%edx
  802ad2:	89 10                	mov    %edx,(%eax)
  802ad4:	eb 0a                	jmp    802ae0 <alloc_block_NF+0x293>
  802ad6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad9:	8b 00                	mov    (%eax),%eax
  802adb:	a3 38 51 80 00       	mov    %eax,0x805138
  802ae0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ae9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aec:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802af3:	a1 44 51 80 00       	mov    0x805144,%eax
  802af8:	48                   	dec    %eax
  802af9:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802afe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b01:	8b 40 08             	mov    0x8(%eax),%eax
  802b04:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802b09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0c:	e9 07 03 00 00       	jmp    802e18 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802b11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b14:	8b 40 0c             	mov    0xc(%eax),%eax
  802b17:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b1a:	0f 86 d4 00 00 00    	jbe    802bf4 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b20:	a1 48 51 80 00       	mov    0x805148,%eax
  802b25:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802b28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2b:	8b 50 08             	mov    0x8(%eax),%edx
  802b2e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b31:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802b34:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b37:	8b 55 08             	mov    0x8(%ebp),%edx
  802b3a:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802b3d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802b41:	75 17                	jne    802b5a <alloc_block_NF+0x30d>
  802b43:	83 ec 04             	sub    $0x4,%esp
  802b46:	68 84 43 80 00       	push   $0x804384
  802b4b:	68 04 01 00 00       	push   $0x104
  802b50:	68 db 42 80 00       	push   $0x8042db
  802b55:	e8 61 d9 ff ff       	call   8004bb <_panic>
  802b5a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b5d:	8b 00                	mov    (%eax),%eax
  802b5f:	85 c0                	test   %eax,%eax
  802b61:	74 10                	je     802b73 <alloc_block_NF+0x326>
  802b63:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b66:	8b 00                	mov    (%eax),%eax
  802b68:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b6b:	8b 52 04             	mov    0x4(%edx),%edx
  802b6e:	89 50 04             	mov    %edx,0x4(%eax)
  802b71:	eb 0b                	jmp    802b7e <alloc_block_NF+0x331>
  802b73:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b76:	8b 40 04             	mov    0x4(%eax),%eax
  802b79:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b7e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b81:	8b 40 04             	mov    0x4(%eax),%eax
  802b84:	85 c0                	test   %eax,%eax
  802b86:	74 0f                	je     802b97 <alloc_block_NF+0x34a>
  802b88:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b8b:	8b 40 04             	mov    0x4(%eax),%eax
  802b8e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b91:	8b 12                	mov    (%edx),%edx
  802b93:	89 10                	mov    %edx,(%eax)
  802b95:	eb 0a                	jmp    802ba1 <alloc_block_NF+0x354>
  802b97:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b9a:	8b 00                	mov    (%eax),%eax
  802b9c:	a3 48 51 80 00       	mov    %eax,0x805148
  802ba1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ba4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802baa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bad:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bb4:	a1 54 51 80 00       	mov    0x805154,%eax
  802bb9:	48                   	dec    %eax
  802bba:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802bbf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bc2:	8b 40 08             	mov    0x8(%eax),%eax
  802bc5:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802bca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bcd:	8b 50 08             	mov    0x8(%eax),%edx
  802bd0:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd3:	01 c2                	add    %eax,%edx
  802bd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd8:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802bdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bde:	8b 40 0c             	mov    0xc(%eax),%eax
  802be1:	2b 45 08             	sub    0x8(%ebp),%eax
  802be4:	89 c2                	mov    %eax,%edx
  802be6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be9:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802bec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bef:	e9 24 02 00 00       	jmp    802e18 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802bf4:	a1 40 51 80 00       	mov    0x805140,%eax
  802bf9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bfc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c00:	74 07                	je     802c09 <alloc_block_NF+0x3bc>
  802c02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c05:	8b 00                	mov    (%eax),%eax
  802c07:	eb 05                	jmp    802c0e <alloc_block_NF+0x3c1>
  802c09:	b8 00 00 00 00       	mov    $0x0,%eax
  802c0e:	a3 40 51 80 00       	mov    %eax,0x805140
  802c13:	a1 40 51 80 00       	mov    0x805140,%eax
  802c18:	85 c0                	test   %eax,%eax
  802c1a:	0f 85 2b fe ff ff    	jne    802a4b <alloc_block_NF+0x1fe>
  802c20:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c24:	0f 85 21 fe ff ff    	jne    802a4b <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c2a:	a1 38 51 80 00       	mov    0x805138,%eax
  802c2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c32:	e9 ae 01 00 00       	jmp    802de5 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802c37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3a:	8b 50 08             	mov    0x8(%eax),%edx
  802c3d:	a1 28 50 80 00       	mov    0x805028,%eax
  802c42:	39 c2                	cmp    %eax,%edx
  802c44:	0f 83 93 01 00 00    	jae    802ddd <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802c4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4d:	8b 40 0c             	mov    0xc(%eax),%eax
  802c50:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c53:	0f 82 84 01 00 00    	jb     802ddd <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802c59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5c:	8b 40 0c             	mov    0xc(%eax),%eax
  802c5f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c62:	0f 85 95 00 00 00    	jne    802cfd <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802c68:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c6c:	75 17                	jne    802c85 <alloc_block_NF+0x438>
  802c6e:	83 ec 04             	sub    $0x4,%esp
  802c71:	68 84 43 80 00       	push   $0x804384
  802c76:	68 14 01 00 00       	push   $0x114
  802c7b:	68 db 42 80 00       	push   $0x8042db
  802c80:	e8 36 d8 ff ff       	call   8004bb <_panic>
  802c85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c88:	8b 00                	mov    (%eax),%eax
  802c8a:	85 c0                	test   %eax,%eax
  802c8c:	74 10                	je     802c9e <alloc_block_NF+0x451>
  802c8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c91:	8b 00                	mov    (%eax),%eax
  802c93:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c96:	8b 52 04             	mov    0x4(%edx),%edx
  802c99:	89 50 04             	mov    %edx,0x4(%eax)
  802c9c:	eb 0b                	jmp    802ca9 <alloc_block_NF+0x45c>
  802c9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca1:	8b 40 04             	mov    0x4(%eax),%eax
  802ca4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ca9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cac:	8b 40 04             	mov    0x4(%eax),%eax
  802caf:	85 c0                	test   %eax,%eax
  802cb1:	74 0f                	je     802cc2 <alloc_block_NF+0x475>
  802cb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb6:	8b 40 04             	mov    0x4(%eax),%eax
  802cb9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cbc:	8b 12                	mov    (%edx),%edx
  802cbe:	89 10                	mov    %edx,(%eax)
  802cc0:	eb 0a                	jmp    802ccc <alloc_block_NF+0x47f>
  802cc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc5:	8b 00                	mov    (%eax),%eax
  802cc7:	a3 38 51 80 00       	mov    %eax,0x805138
  802ccc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ccf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cdf:	a1 44 51 80 00       	mov    0x805144,%eax
  802ce4:	48                   	dec    %eax
  802ce5:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802cea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ced:	8b 40 08             	mov    0x8(%eax),%eax
  802cf0:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802cf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf8:	e9 1b 01 00 00       	jmp    802e18 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802cfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d00:	8b 40 0c             	mov    0xc(%eax),%eax
  802d03:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d06:	0f 86 d1 00 00 00    	jbe    802ddd <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802d0c:	a1 48 51 80 00       	mov    0x805148,%eax
  802d11:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802d14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d17:	8b 50 08             	mov    0x8(%eax),%edx
  802d1a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d1d:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802d20:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d23:	8b 55 08             	mov    0x8(%ebp),%edx
  802d26:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802d29:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802d2d:	75 17                	jne    802d46 <alloc_block_NF+0x4f9>
  802d2f:	83 ec 04             	sub    $0x4,%esp
  802d32:	68 84 43 80 00       	push   $0x804384
  802d37:	68 1c 01 00 00       	push   $0x11c
  802d3c:	68 db 42 80 00       	push   $0x8042db
  802d41:	e8 75 d7 ff ff       	call   8004bb <_panic>
  802d46:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d49:	8b 00                	mov    (%eax),%eax
  802d4b:	85 c0                	test   %eax,%eax
  802d4d:	74 10                	je     802d5f <alloc_block_NF+0x512>
  802d4f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d52:	8b 00                	mov    (%eax),%eax
  802d54:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d57:	8b 52 04             	mov    0x4(%edx),%edx
  802d5a:	89 50 04             	mov    %edx,0x4(%eax)
  802d5d:	eb 0b                	jmp    802d6a <alloc_block_NF+0x51d>
  802d5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d62:	8b 40 04             	mov    0x4(%eax),%eax
  802d65:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d6a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d6d:	8b 40 04             	mov    0x4(%eax),%eax
  802d70:	85 c0                	test   %eax,%eax
  802d72:	74 0f                	je     802d83 <alloc_block_NF+0x536>
  802d74:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d77:	8b 40 04             	mov    0x4(%eax),%eax
  802d7a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d7d:	8b 12                	mov    (%edx),%edx
  802d7f:	89 10                	mov    %edx,(%eax)
  802d81:	eb 0a                	jmp    802d8d <alloc_block_NF+0x540>
  802d83:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d86:	8b 00                	mov    (%eax),%eax
  802d88:	a3 48 51 80 00       	mov    %eax,0x805148
  802d8d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d90:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d96:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d99:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802da0:	a1 54 51 80 00       	mov    0x805154,%eax
  802da5:	48                   	dec    %eax
  802da6:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802dab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dae:	8b 40 08             	mov    0x8(%eax),%eax
  802db1:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802db6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db9:	8b 50 08             	mov    0x8(%eax),%edx
  802dbc:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbf:	01 c2                	add    %eax,%edx
  802dc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc4:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802dc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dca:	8b 40 0c             	mov    0xc(%eax),%eax
  802dcd:	2b 45 08             	sub    0x8(%ebp),%eax
  802dd0:	89 c2                	mov    %eax,%edx
  802dd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd5:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802dd8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ddb:	eb 3b                	jmp    802e18 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802ddd:	a1 40 51 80 00       	mov    0x805140,%eax
  802de2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802de5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802de9:	74 07                	je     802df2 <alloc_block_NF+0x5a5>
  802deb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dee:	8b 00                	mov    (%eax),%eax
  802df0:	eb 05                	jmp    802df7 <alloc_block_NF+0x5aa>
  802df2:	b8 00 00 00 00       	mov    $0x0,%eax
  802df7:	a3 40 51 80 00       	mov    %eax,0x805140
  802dfc:	a1 40 51 80 00       	mov    0x805140,%eax
  802e01:	85 c0                	test   %eax,%eax
  802e03:	0f 85 2e fe ff ff    	jne    802c37 <alloc_block_NF+0x3ea>
  802e09:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e0d:	0f 85 24 fe ff ff    	jne    802c37 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802e13:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e18:	c9                   	leave  
  802e19:	c3                   	ret    

00802e1a <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802e1a:	55                   	push   %ebp
  802e1b:	89 e5                	mov    %esp,%ebp
  802e1d:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802e20:	a1 38 51 80 00       	mov    0x805138,%eax
  802e25:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802e28:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802e2d:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802e30:	a1 38 51 80 00       	mov    0x805138,%eax
  802e35:	85 c0                	test   %eax,%eax
  802e37:	74 14                	je     802e4d <insert_sorted_with_merge_freeList+0x33>
  802e39:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3c:	8b 50 08             	mov    0x8(%eax),%edx
  802e3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e42:	8b 40 08             	mov    0x8(%eax),%eax
  802e45:	39 c2                	cmp    %eax,%edx
  802e47:	0f 87 9b 01 00 00    	ja     802fe8 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802e4d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e51:	75 17                	jne    802e6a <insert_sorted_with_merge_freeList+0x50>
  802e53:	83 ec 04             	sub    $0x4,%esp
  802e56:	68 b8 42 80 00       	push   $0x8042b8
  802e5b:	68 38 01 00 00       	push   $0x138
  802e60:	68 db 42 80 00       	push   $0x8042db
  802e65:	e8 51 d6 ff ff       	call   8004bb <_panic>
  802e6a:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802e70:	8b 45 08             	mov    0x8(%ebp),%eax
  802e73:	89 10                	mov    %edx,(%eax)
  802e75:	8b 45 08             	mov    0x8(%ebp),%eax
  802e78:	8b 00                	mov    (%eax),%eax
  802e7a:	85 c0                	test   %eax,%eax
  802e7c:	74 0d                	je     802e8b <insert_sorted_with_merge_freeList+0x71>
  802e7e:	a1 38 51 80 00       	mov    0x805138,%eax
  802e83:	8b 55 08             	mov    0x8(%ebp),%edx
  802e86:	89 50 04             	mov    %edx,0x4(%eax)
  802e89:	eb 08                	jmp    802e93 <insert_sorted_with_merge_freeList+0x79>
  802e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e93:	8b 45 08             	mov    0x8(%ebp),%eax
  802e96:	a3 38 51 80 00       	mov    %eax,0x805138
  802e9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ea5:	a1 44 51 80 00       	mov    0x805144,%eax
  802eaa:	40                   	inc    %eax
  802eab:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802eb0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802eb4:	0f 84 a8 06 00 00    	je     803562 <insert_sorted_with_merge_freeList+0x748>
  802eba:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebd:	8b 50 08             	mov    0x8(%eax),%edx
  802ec0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec3:	8b 40 0c             	mov    0xc(%eax),%eax
  802ec6:	01 c2                	add    %eax,%edx
  802ec8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ecb:	8b 40 08             	mov    0x8(%eax),%eax
  802ece:	39 c2                	cmp    %eax,%edx
  802ed0:	0f 85 8c 06 00 00    	jne    803562 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802ed6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed9:	8b 50 0c             	mov    0xc(%eax),%edx
  802edc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802edf:	8b 40 0c             	mov    0xc(%eax),%eax
  802ee2:	01 c2                	add    %eax,%edx
  802ee4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee7:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802eea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802eee:	75 17                	jne    802f07 <insert_sorted_with_merge_freeList+0xed>
  802ef0:	83 ec 04             	sub    $0x4,%esp
  802ef3:	68 84 43 80 00       	push   $0x804384
  802ef8:	68 3c 01 00 00       	push   $0x13c
  802efd:	68 db 42 80 00       	push   $0x8042db
  802f02:	e8 b4 d5 ff ff       	call   8004bb <_panic>
  802f07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f0a:	8b 00                	mov    (%eax),%eax
  802f0c:	85 c0                	test   %eax,%eax
  802f0e:	74 10                	je     802f20 <insert_sorted_with_merge_freeList+0x106>
  802f10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f13:	8b 00                	mov    (%eax),%eax
  802f15:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f18:	8b 52 04             	mov    0x4(%edx),%edx
  802f1b:	89 50 04             	mov    %edx,0x4(%eax)
  802f1e:	eb 0b                	jmp    802f2b <insert_sorted_with_merge_freeList+0x111>
  802f20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f23:	8b 40 04             	mov    0x4(%eax),%eax
  802f26:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f2e:	8b 40 04             	mov    0x4(%eax),%eax
  802f31:	85 c0                	test   %eax,%eax
  802f33:	74 0f                	je     802f44 <insert_sorted_with_merge_freeList+0x12a>
  802f35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f38:	8b 40 04             	mov    0x4(%eax),%eax
  802f3b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f3e:	8b 12                	mov    (%edx),%edx
  802f40:	89 10                	mov    %edx,(%eax)
  802f42:	eb 0a                	jmp    802f4e <insert_sorted_with_merge_freeList+0x134>
  802f44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f47:	8b 00                	mov    (%eax),%eax
  802f49:	a3 38 51 80 00       	mov    %eax,0x805138
  802f4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f51:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f5a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f61:	a1 44 51 80 00       	mov    0x805144,%eax
  802f66:	48                   	dec    %eax
  802f67:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802f6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f6f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802f76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f79:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802f80:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f84:	75 17                	jne    802f9d <insert_sorted_with_merge_freeList+0x183>
  802f86:	83 ec 04             	sub    $0x4,%esp
  802f89:	68 b8 42 80 00       	push   $0x8042b8
  802f8e:	68 3f 01 00 00       	push   $0x13f
  802f93:	68 db 42 80 00       	push   $0x8042db
  802f98:	e8 1e d5 ff ff       	call   8004bb <_panic>
  802f9d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802fa3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fa6:	89 10                	mov    %edx,(%eax)
  802fa8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fab:	8b 00                	mov    (%eax),%eax
  802fad:	85 c0                	test   %eax,%eax
  802faf:	74 0d                	je     802fbe <insert_sorted_with_merge_freeList+0x1a4>
  802fb1:	a1 48 51 80 00       	mov    0x805148,%eax
  802fb6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fb9:	89 50 04             	mov    %edx,0x4(%eax)
  802fbc:	eb 08                	jmp    802fc6 <insert_sorted_with_merge_freeList+0x1ac>
  802fbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fc1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802fc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fc9:	a3 48 51 80 00       	mov    %eax,0x805148
  802fce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fd1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fd8:	a1 54 51 80 00       	mov    0x805154,%eax
  802fdd:	40                   	inc    %eax
  802fde:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802fe3:	e9 7a 05 00 00       	jmp    803562 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802fe8:	8b 45 08             	mov    0x8(%ebp),%eax
  802feb:	8b 50 08             	mov    0x8(%eax),%edx
  802fee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ff1:	8b 40 08             	mov    0x8(%eax),%eax
  802ff4:	39 c2                	cmp    %eax,%edx
  802ff6:	0f 82 14 01 00 00    	jb     803110 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802ffc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fff:	8b 50 08             	mov    0x8(%eax),%edx
  803002:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803005:	8b 40 0c             	mov    0xc(%eax),%eax
  803008:	01 c2                	add    %eax,%edx
  80300a:	8b 45 08             	mov    0x8(%ebp),%eax
  80300d:	8b 40 08             	mov    0x8(%eax),%eax
  803010:	39 c2                	cmp    %eax,%edx
  803012:	0f 85 90 00 00 00    	jne    8030a8 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  803018:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80301b:	8b 50 0c             	mov    0xc(%eax),%edx
  80301e:	8b 45 08             	mov    0x8(%ebp),%eax
  803021:	8b 40 0c             	mov    0xc(%eax),%eax
  803024:	01 c2                	add    %eax,%edx
  803026:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803029:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  80302c:	8b 45 08             	mov    0x8(%ebp),%eax
  80302f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  803036:	8b 45 08             	mov    0x8(%ebp),%eax
  803039:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803040:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803044:	75 17                	jne    80305d <insert_sorted_with_merge_freeList+0x243>
  803046:	83 ec 04             	sub    $0x4,%esp
  803049:	68 b8 42 80 00       	push   $0x8042b8
  80304e:	68 49 01 00 00       	push   $0x149
  803053:	68 db 42 80 00       	push   $0x8042db
  803058:	e8 5e d4 ff ff       	call   8004bb <_panic>
  80305d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803063:	8b 45 08             	mov    0x8(%ebp),%eax
  803066:	89 10                	mov    %edx,(%eax)
  803068:	8b 45 08             	mov    0x8(%ebp),%eax
  80306b:	8b 00                	mov    (%eax),%eax
  80306d:	85 c0                	test   %eax,%eax
  80306f:	74 0d                	je     80307e <insert_sorted_with_merge_freeList+0x264>
  803071:	a1 48 51 80 00       	mov    0x805148,%eax
  803076:	8b 55 08             	mov    0x8(%ebp),%edx
  803079:	89 50 04             	mov    %edx,0x4(%eax)
  80307c:	eb 08                	jmp    803086 <insert_sorted_with_merge_freeList+0x26c>
  80307e:	8b 45 08             	mov    0x8(%ebp),%eax
  803081:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803086:	8b 45 08             	mov    0x8(%ebp),%eax
  803089:	a3 48 51 80 00       	mov    %eax,0x805148
  80308e:	8b 45 08             	mov    0x8(%ebp),%eax
  803091:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803098:	a1 54 51 80 00       	mov    0x805154,%eax
  80309d:	40                   	inc    %eax
  80309e:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8030a3:	e9 bb 04 00 00       	jmp    803563 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  8030a8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030ac:	75 17                	jne    8030c5 <insert_sorted_with_merge_freeList+0x2ab>
  8030ae:	83 ec 04             	sub    $0x4,%esp
  8030b1:	68 2c 43 80 00       	push   $0x80432c
  8030b6:	68 4c 01 00 00       	push   $0x14c
  8030bb:	68 db 42 80 00       	push   $0x8042db
  8030c0:	e8 f6 d3 ff ff       	call   8004bb <_panic>
  8030c5:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8030cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ce:	89 50 04             	mov    %edx,0x4(%eax)
  8030d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d4:	8b 40 04             	mov    0x4(%eax),%eax
  8030d7:	85 c0                	test   %eax,%eax
  8030d9:	74 0c                	je     8030e7 <insert_sorted_with_merge_freeList+0x2cd>
  8030db:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8030e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8030e3:	89 10                	mov    %edx,(%eax)
  8030e5:	eb 08                	jmp    8030ef <insert_sorted_with_merge_freeList+0x2d5>
  8030e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ea:	a3 38 51 80 00       	mov    %eax,0x805138
  8030ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030fa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803100:	a1 44 51 80 00       	mov    0x805144,%eax
  803105:	40                   	inc    %eax
  803106:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80310b:	e9 53 04 00 00       	jmp    803563 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803110:	a1 38 51 80 00       	mov    0x805138,%eax
  803115:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803118:	e9 15 04 00 00       	jmp    803532 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  80311d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803120:	8b 00                	mov    (%eax),%eax
  803122:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803125:	8b 45 08             	mov    0x8(%ebp),%eax
  803128:	8b 50 08             	mov    0x8(%eax),%edx
  80312b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80312e:	8b 40 08             	mov    0x8(%eax),%eax
  803131:	39 c2                	cmp    %eax,%edx
  803133:	0f 86 f1 03 00 00    	jbe    80352a <insert_sorted_with_merge_freeList+0x710>
  803139:	8b 45 08             	mov    0x8(%ebp),%eax
  80313c:	8b 50 08             	mov    0x8(%eax),%edx
  80313f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803142:	8b 40 08             	mov    0x8(%eax),%eax
  803145:	39 c2                	cmp    %eax,%edx
  803147:	0f 83 dd 03 00 00    	jae    80352a <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  80314d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803150:	8b 50 08             	mov    0x8(%eax),%edx
  803153:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803156:	8b 40 0c             	mov    0xc(%eax),%eax
  803159:	01 c2                	add    %eax,%edx
  80315b:	8b 45 08             	mov    0x8(%ebp),%eax
  80315e:	8b 40 08             	mov    0x8(%eax),%eax
  803161:	39 c2                	cmp    %eax,%edx
  803163:	0f 85 b9 01 00 00    	jne    803322 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803169:	8b 45 08             	mov    0x8(%ebp),%eax
  80316c:	8b 50 08             	mov    0x8(%eax),%edx
  80316f:	8b 45 08             	mov    0x8(%ebp),%eax
  803172:	8b 40 0c             	mov    0xc(%eax),%eax
  803175:	01 c2                	add    %eax,%edx
  803177:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80317a:	8b 40 08             	mov    0x8(%eax),%eax
  80317d:	39 c2                	cmp    %eax,%edx
  80317f:	0f 85 0d 01 00 00    	jne    803292 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803185:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803188:	8b 50 0c             	mov    0xc(%eax),%edx
  80318b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80318e:	8b 40 0c             	mov    0xc(%eax),%eax
  803191:	01 c2                	add    %eax,%edx
  803193:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803196:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803199:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80319d:	75 17                	jne    8031b6 <insert_sorted_with_merge_freeList+0x39c>
  80319f:	83 ec 04             	sub    $0x4,%esp
  8031a2:	68 84 43 80 00       	push   $0x804384
  8031a7:	68 5c 01 00 00       	push   $0x15c
  8031ac:	68 db 42 80 00       	push   $0x8042db
  8031b1:	e8 05 d3 ff ff       	call   8004bb <_panic>
  8031b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031b9:	8b 00                	mov    (%eax),%eax
  8031bb:	85 c0                	test   %eax,%eax
  8031bd:	74 10                	je     8031cf <insert_sorted_with_merge_freeList+0x3b5>
  8031bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c2:	8b 00                	mov    (%eax),%eax
  8031c4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031c7:	8b 52 04             	mov    0x4(%edx),%edx
  8031ca:	89 50 04             	mov    %edx,0x4(%eax)
  8031cd:	eb 0b                	jmp    8031da <insert_sorted_with_merge_freeList+0x3c0>
  8031cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d2:	8b 40 04             	mov    0x4(%eax),%eax
  8031d5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031dd:	8b 40 04             	mov    0x4(%eax),%eax
  8031e0:	85 c0                	test   %eax,%eax
  8031e2:	74 0f                	je     8031f3 <insert_sorted_with_merge_freeList+0x3d9>
  8031e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e7:	8b 40 04             	mov    0x4(%eax),%eax
  8031ea:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031ed:	8b 12                	mov    (%edx),%edx
  8031ef:	89 10                	mov    %edx,(%eax)
  8031f1:	eb 0a                	jmp    8031fd <insert_sorted_with_merge_freeList+0x3e3>
  8031f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f6:	8b 00                	mov    (%eax),%eax
  8031f8:	a3 38 51 80 00       	mov    %eax,0x805138
  8031fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803200:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803206:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803209:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803210:	a1 44 51 80 00       	mov    0x805144,%eax
  803215:	48                   	dec    %eax
  803216:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  80321b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80321e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803225:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803228:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80322f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803233:	75 17                	jne    80324c <insert_sorted_with_merge_freeList+0x432>
  803235:	83 ec 04             	sub    $0x4,%esp
  803238:	68 b8 42 80 00       	push   $0x8042b8
  80323d:	68 5f 01 00 00       	push   $0x15f
  803242:	68 db 42 80 00       	push   $0x8042db
  803247:	e8 6f d2 ff ff       	call   8004bb <_panic>
  80324c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803252:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803255:	89 10                	mov    %edx,(%eax)
  803257:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80325a:	8b 00                	mov    (%eax),%eax
  80325c:	85 c0                	test   %eax,%eax
  80325e:	74 0d                	je     80326d <insert_sorted_with_merge_freeList+0x453>
  803260:	a1 48 51 80 00       	mov    0x805148,%eax
  803265:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803268:	89 50 04             	mov    %edx,0x4(%eax)
  80326b:	eb 08                	jmp    803275 <insert_sorted_with_merge_freeList+0x45b>
  80326d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803270:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803275:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803278:	a3 48 51 80 00       	mov    %eax,0x805148
  80327d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803280:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803287:	a1 54 51 80 00       	mov    0x805154,%eax
  80328c:	40                   	inc    %eax
  80328d:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803292:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803295:	8b 50 0c             	mov    0xc(%eax),%edx
  803298:	8b 45 08             	mov    0x8(%ebp),%eax
  80329b:	8b 40 0c             	mov    0xc(%eax),%eax
  80329e:	01 c2                	add    %eax,%edx
  8032a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a3:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8032a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8032b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8032ba:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032be:	75 17                	jne    8032d7 <insert_sorted_with_merge_freeList+0x4bd>
  8032c0:	83 ec 04             	sub    $0x4,%esp
  8032c3:	68 b8 42 80 00       	push   $0x8042b8
  8032c8:	68 64 01 00 00       	push   $0x164
  8032cd:	68 db 42 80 00       	push   $0x8042db
  8032d2:	e8 e4 d1 ff ff       	call   8004bb <_panic>
  8032d7:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8032dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e0:	89 10                	mov    %edx,(%eax)
  8032e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e5:	8b 00                	mov    (%eax),%eax
  8032e7:	85 c0                	test   %eax,%eax
  8032e9:	74 0d                	je     8032f8 <insert_sorted_with_merge_freeList+0x4de>
  8032eb:	a1 48 51 80 00       	mov    0x805148,%eax
  8032f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8032f3:	89 50 04             	mov    %edx,0x4(%eax)
  8032f6:	eb 08                	jmp    803300 <insert_sorted_with_merge_freeList+0x4e6>
  8032f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fb:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803300:	8b 45 08             	mov    0x8(%ebp),%eax
  803303:	a3 48 51 80 00       	mov    %eax,0x805148
  803308:	8b 45 08             	mov    0x8(%ebp),%eax
  80330b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803312:	a1 54 51 80 00       	mov    0x805154,%eax
  803317:	40                   	inc    %eax
  803318:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80331d:	e9 41 02 00 00       	jmp    803563 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803322:	8b 45 08             	mov    0x8(%ebp),%eax
  803325:	8b 50 08             	mov    0x8(%eax),%edx
  803328:	8b 45 08             	mov    0x8(%ebp),%eax
  80332b:	8b 40 0c             	mov    0xc(%eax),%eax
  80332e:	01 c2                	add    %eax,%edx
  803330:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803333:	8b 40 08             	mov    0x8(%eax),%eax
  803336:	39 c2                	cmp    %eax,%edx
  803338:	0f 85 7c 01 00 00    	jne    8034ba <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  80333e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803342:	74 06                	je     80334a <insert_sorted_with_merge_freeList+0x530>
  803344:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803348:	75 17                	jne    803361 <insert_sorted_with_merge_freeList+0x547>
  80334a:	83 ec 04             	sub    $0x4,%esp
  80334d:	68 f4 42 80 00       	push   $0x8042f4
  803352:	68 69 01 00 00       	push   $0x169
  803357:	68 db 42 80 00       	push   $0x8042db
  80335c:	e8 5a d1 ff ff       	call   8004bb <_panic>
  803361:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803364:	8b 50 04             	mov    0x4(%eax),%edx
  803367:	8b 45 08             	mov    0x8(%ebp),%eax
  80336a:	89 50 04             	mov    %edx,0x4(%eax)
  80336d:	8b 45 08             	mov    0x8(%ebp),%eax
  803370:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803373:	89 10                	mov    %edx,(%eax)
  803375:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803378:	8b 40 04             	mov    0x4(%eax),%eax
  80337b:	85 c0                	test   %eax,%eax
  80337d:	74 0d                	je     80338c <insert_sorted_with_merge_freeList+0x572>
  80337f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803382:	8b 40 04             	mov    0x4(%eax),%eax
  803385:	8b 55 08             	mov    0x8(%ebp),%edx
  803388:	89 10                	mov    %edx,(%eax)
  80338a:	eb 08                	jmp    803394 <insert_sorted_with_merge_freeList+0x57a>
  80338c:	8b 45 08             	mov    0x8(%ebp),%eax
  80338f:	a3 38 51 80 00       	mov    %eax,0x805138
  803394:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803397:	8b 55 08             	mov    0x8(%ebp),%edx
  80339a:	89 50 04             	mov    %edx,0x4(%eax)
  80339d:	a1 44 51 80 00       	mov    0x805144,%eax
  8033a2:	40                   	inc    %eax
  8033a3:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  8033a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ab:	8b 50 0c             	mov    0xc(%eax),%edx
  8033ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033b1:	8b 40 0c             	mov    0xc(%eax),%eax
  8033b4:	01 c2                	add    %eax,%edx
  8033b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b9:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8033bc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8033c0:	75 17                	jne    8033d9 <insert_sorted_with_merge_freeList+0x5bf>
  8033c2:	83 ec 04             	sub    $0x4,%esp
  8033c5:	68 84 43 80 00       	push   $0x804384
  8033ca:	68 6b 01 00 00       	push   $0x16b
  8033cf:	68 db 42 80 00       	push   $0x8042db
  8033d4:	e8 e2 d0 ff ff       	call   8004bb <_panic>
  8033d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033dc:	8b 00                	mov    (%eax),%eax
  8033de:	85 c0                	test   %eax,%eax
  8033e0:	74 10                	je     8033f2 <insert_sorted_with_merge_freeList+0x5d8>
  8033e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033e5:	8b 00                	mov    (%eax),%eax
  8033e7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033ea:	8b 52 04             	mov    0x4(%edx),%edx
  8033ed:	89 50 04             	mov    %edx,0x4(%eax)
  8033f0:	eb 0b                	jmp    8033fd <insert_sorted_with_merge_freeList+0x5e3>
  8033f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033f5:	8b 40 04             	mov    0x4(%eax),%eax
  8033f8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8033fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803400:	8b 40 04             	mov    0x4(%eax),%eax
  803403:	85 c0                	test   %eax,%eax
  803405:	74 0f                	je     803416 <insert_sorted_with_merge_freeList+0x5fc>
  803407:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80340a:	8b 40 04             	mov    0x4(%eax),%eax
  80340d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803410:	8b 12                	mov    (%edx),%edx
  803412:	89 10                	mov    %edx,(%eax)
  803414:	eb 0a                	jmp    803420 <insert_sorted_with_merge_freeList+0x606>
  803416:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803419:	8b 00                	mov    (%eax),%eax
  80341b:	a3 38 51 80 00       	mov    %eax,0x805138
  803420:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803423:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803429:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80342c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803433:	a1 44 51 80 00       	mov    0x805144,%eax
  803438:	48                   	dec    %eax
  803439:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  80343e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803441:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803448:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80344b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803452:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803456:	75 17                	jne    80346f <insert_sorted_with_merge_freeList+0x655>
  803458:	83 ec 04             	sub    $0x4,%esp
  80345b:	68 b8 42 80 00       	push   $0x8042b8
  803460:	68 6e 01 00 00       	push   $0x16e
  803465:	68 db 42 80 00       	push   $0x8042db
  80346a:	e8 4c d0 ff ff       	call   8004bb <_panic>
  80346f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803475:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803478:	89 10                	mov    %edx,(%eax)
  80347a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80347d:	8b 00                	mov    (%eax),%eax
  80347f:	85 c0                	test   %eax,%eax
  803481:	74 0d                	je     803490 <insert_sorted_with_merge_freeList+0x676>
  803483:	a1 48 51 80 00       	mov    0x805148,%eax
  803488:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80348b:	89 50 04             	mov    %edx,0x4(%eax)
  80348e:	eb 08                	jmp    803498 <insert_sorted_with_merge_freeList+0x67e>
  803490:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803493:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803498:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80349b:	a3 48 51 80 00       	mov    %eax,0x805148
  8034a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034a3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034aa:	a1 54 51 80 00       	mov    0x805154,%eax
  8034af:	40                   	inc    %eax
  8034b0:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8034b5:	e9 a9 00 00 00       	jmp    803563 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8034ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034be:	74 06                	je     8034c6 <insert_sorted_with_merge_freeList+0x6ac>
  8034c0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034c4:	75 17                	jne    8034dd <insert_sorted_with_merge_freeList+0x6c3>
  8034c6:	83 ec 04             	sub    $0x4,%esp
  8034c9:	68 50 43 80 00       	push   $0x804350
  8034ce:	68 73 01 00 00       	push   $0x173
  8034d3:	68 db 42 80 00       	push   $0x8042db
  8034d8:	e8 de cf ff ff       	call   8004bb <_panic>
  8034dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034e0:	8b 10                	mov    (%eax),%edx
  8034e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e5:	89 10                	mov    %edx,(%eax)
  8034e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ea:	8b 00                	mov    (%eax),%eax
  8034ec:	85 c0                	test   %eax,%eax
  8034ee:	74 0b                	je     8034fb <insert_sorted_with_merge_freeList+0x6e1>
  8034f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034f3:	8b 00                	mov    (%eax),%eax
  8034f5:	8b 55 08             	mov    0x8(%ebp),%edx
  8034f8:	89 50 04             	mov    %edx,0x4(%eax)
  8034fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034fe:	8b 55 08             	mov    0x8(%ebp),%edx
  803501:	89 10                	mov    %edx,(%eax)
  803503:	8b 45 08             	mov    0x8(%ebp),%eax
  803506:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803509:	89 50 04             	mov    %edx,0x4(%eax)
  80350c:	8b 45 08             	mov    0x8(%ebp),%eax
  80350f:	8b 00                	mov    (%eax),%eax
  803511:	85 c0                	test   %eax,%eax
  803513:	75 08                	jne    80351d <insert_sorted_with_merge_freeList+0x703>
  803515:	8b 45 08             	mov    0x8(%ebp),%eax
  803518:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80351d:	a1 44 51 80 00       	mov    0x805144,%eax
  803522:	40                   	inc    %eax
  803523:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803528:	eb 39                	jmp    803563 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80352a:	a1 40 51 80 00       	mov    0x805140,%eax
  80352f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803532:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803536:	74 07                	je     80353f <insert_sorted_with_merge_freeList+0x725>
  803538:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80353b:	8b 00                	mov    (%eax),%eax
  80353d:	eb 05                	jmp    803544 <insert_sorted_with_merge_freeList+0x72a>
  80353f:	b8 00 00 00 00       	mov    $0x0,%eax
  803544:	a3 40 51 80 00       	mov    %eax,0x805140
  803549:	a1 40 51 80 00       	mov    0x805140,%eax
  80354e:	85 c0                	test   %eax,%eax
  803550:	0f 85 c7 fb ff ff    	jne    80311d <insert_sorted_with_merge_freeList+0x303>
  803556:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80355a:	0f 85 bd fb ff ff    	jne    80311d <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803560:	eb 01                	jmp    803563 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803562:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803563:	90                   	nop
  803564:	c9                   	leave  
  803565:	c3                   	ret    

00803566 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803566:	55                   	push   %ebp
  803567:	89 e5                	mov    %esp,%ebp
  803569:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  80356c:	8b 55 08             	mov    0x8(%ebp),%edx
  80356f:	89 d0                	mov    %edx,%eax
  803571:	c1 e0 02             	shl    $0x2,%eax
  803574:	01 d0                	add    %edx,%eax
  803576:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80357d:	01 d0                	add    %edx,%eax
  80357f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803586:	01 d0                	add    %edx,%eax
  803588:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80358f:	01 d0                	add    %edx,%eax
  803591:	c1 e0 04             	shl    $0x4,%eax
  803594:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803597:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  80359e:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8035a1:	83 ec 0c             	sub    $0xc,%esp
  8035a4:	50                   	push   %eax
  8035a5:	e8 26 e7 ff ff       	call   801cd0 <sys_get_virtual_time>
  8035aa:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8035ad:	eb 41                	jmp    8035f0 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8035af:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8035b2:	83 ec 0c             	sub    $0xc,%esp
  8035b5:	50                   	push   %eax
  8035b6:	e8 15 e7 ff ff       	call   801cd0 <sys_get_virtual_time>
  8035bb:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8035be:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8035c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035c4:	29 c2                	sub    %eax,%edx
  8035c6:	89 d0                	mov    %edx,%eax
  8035c8:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8035cb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035d1:	89 d1                	mov    %edx,%ecx
  8035d3:	29 c1                	sub    %eax,%ecx
  8035d5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8035d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035db:	39 c2                	cmp    %eax,%edx
  8035dd:	0f 97 c0             	seta   %al
  8035e0:	0f b6 c0             	movzbl %al,%eax
  8035e3:	29 c1                	sub    %eax,%ecx
  8035e5:	89 c8                	mov    %ecx,%eax
  8035e7:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8035ea:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8035ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8035f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035f3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8035f6:	72 b7                	jb     8035af <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8035f8:	90                   	nop
  8035f9:	c9                   	leave  
  8035fa:	c3                   	ret    

008035fb <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8035fb:	55                   	push   %ebp
  8035fc:	89 e5                	mov    %esp,%ebp
  8035fe:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803601:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803608:	eb 03                	jmp    80360d <busy_wait+0x12>
  80360a:	ff 45 fc             	incl   -0x4(%ebp)
  80360d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803610:	3b 45 08             	cmp    0x8(%ebp),%eax
  803613:	72 f5                	jb     80360a <busy_wait+0xf>
	return i;
  803615:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803618:	c9                   	leave  
  803619:	c3                   	ret    
  80361a:	66 90                	xchg   %ax,%ax

0080361c <__udivdi3>:
  80361c:	55                   	push   %ebp
  80361d:	57                   	push   %edi
  80361e:	56                   	push   %esi
  80361f:	53                   	push   %ebx
  803620:	83 ec 1c             	sub    $0x1c,%esp
  803623:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803627:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80362b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80362f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803633:	89 ca                	mov    %ecx,%edx
  803635:	89 f8                	mov    %edi,%eax
  803637:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80363b:	85 f6                	test   %esi,%esi
  80363d:	75 2d                	jne    80366c <__udivdi3+0x50>
  80363f:	39 cf                	cmp    %ecx,%edi
  803641:	77 65                	ja     8036a8 <__udivdi3+0x8c>
  803643:	89 fd                	mov    %edi,%ebp
  803645:	85 ff                	test   %edi,%edi
  803647:	75 0b                	jne    803654 <__udivdi3+0x38>
  803649:	b8 01 00 00 00       	mov    $0x1,%eax
  80364e:	31 d2                	xor    %edx,%edx
  803650:	f7 f7                	div    %edi
  803652:	89 c5                	mov    %eax,%ebp
  803654:	31 d2                	xor    %edx,%edx
  803656:	89 c8                	mov    %ecx,%eax
  803658:	f7 f5                	div    %ebp
  80365a:	89 c1                	mov    %eax,%ecx
  80365c:	89 d8                	mov    %ebx,%eax
  80365e:	f7 f5                	div    %ebp
  803660:	89 cf                	mov    %ecx,%edi
  803662:	89 fa                	mov    %edi,%edx
  803664:	83 c4 1c             	add    $0x1c,%esp
  803667:	5b                   	pop    %ebx
  803668:	5e                   	pop    %esi
  803669:	5f                   	pop    %edi
  80366a:	5d                   	pop    %ebp
  80366b:	c3                   	ret    
  80366c:	39 ce                	cmp    %ecx,%esi
  80366e:	77 28                	ja     803698 <__udivdi3+0x7c>
  803670:	0f bd fe             	bsr    %esi,%edi
  803673:	83 f7 1f             	xor    $0x1f,%edi
  803676:	75 40                	jne    8036b8 <__udivdi3+0x9c>
  803678:	39 ce                	cmp    %ecx,%esi
  80367a:	72 0a                	jb     803686 <__udivdi3+0x6a>
  80367c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803680:	0f 87 9e 00 00 00    	ja     803724 <__udivdi3+0x108>
  803686:	b8 01 00 00 00       	mov    $0x1,%eax
  80368b:	89 fa                	mov    %edi,%edx
  80368d:	83 c4 1c             	add    $0x1c,%esp
  803690:	5b                   	pop    %ebx
  803691:	5e                   	pop    %esi
  803692:	5f                   	pop    %edi
  803693:	5d                   	pop    %ebp
  803694:	c3                   	ret    
  803695:	8d 76 00             	lea    0x0(%esi),%esi
  803698:	31 ff                	xor    %edi,%edi
  80369a:	31 c0                	xor    %eax,%eax
  80369c:	89 fa                	mov    %edi,%edx
  80369e:	83 c4 1c             	add    $0x1c,%esp
  8036a1:	5b                   	pop    %ebx
  8036a2:	5e                   	pop    %esi
  8036a3:	5f                   	pop    %edi
  8036a4:	5d                   	pop    %ebp
  8036a5:	c3                   	ret    
  8036a6:	66 90                	xchg   %ax,%ax
  8036a8:	89 d8                	mov    %ebx,%eax
  8036aa:	f7 f7                	div    %edi
  8036ac:	31 ff                	xor    %edi,%edi
  8036ae:	89 fa                	mov    %edi,%edx
  8036b0:	83 c4 1c             	add    $0x1c,%esp
  8036b3:	5b                   	pop    %ebx
  8036b4:	5e                   	pop    %esi
  8036b5:	5f                   	pop    %edi
  8036b6:	5d                   	pop    %ebp
  8036b7:	c3                   	ret    
  8036b8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8036bd:	89 eb                	mov    %ebp,%ebx
  8036bf:	29 fb                	sub    %edi,%ebx
  8036c1:	89 f9                	mov    %edi,%ecx
  8036c3:	d3 e6                	shl    %cl,%esi
  8036c5:	89 c5                	mov    %eax,%ebp
  8036c7:	88 d9                	mov    %bl,%cl
  8036c9:	d3 ed                	shr    %cl,%ebp
  8036cb:	89 e9                	mov    %ebp,%ecx
  8036cd:	09 f1                	or     %esi,%ecx
  8036cf:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8036d3:	89 f9                	mov    %edi,%ecx
  8036d5:	d3 e0                	shl    %cl,%eax
  8036d7:	89 c5                	mov    %eax,%ebp
  8036d9:	89 d6                	mov    %edx,%esi
  8036db:	88 d9                	mov    %bl,%cl
  8036dd:	d3 ee                	shr    %cl,%esi
  8036df:	89 f9                	mov    %edi,%ecx
  8036e1:	d3 e2                	shl    %cl,%edx
  8036e3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8036e7:	88 d9                	mov    %bl,%cl
  8036e9:	d3 e8                	shr    %cl,%eax
  8036eb:	09 c2                	or     %eax,%edx
  8036ed:	89 d0                	mov    %edx,%eax
  8036ef:	89 f2                	mov    %esi,%edx
  8036f1:	f7 74 24 0c          	divl   0xc(%esp)
  8036f5:	89 d6                	mov    %edx,%esi
  8036f7:	89 c3                	mov    %eax,%ebx
  8036f9:	f7 e5                	mul    %ebp
  8036fb:	39 d6                	cmp    %edx,%esi
  8036fd:	72 19                	jb     803718 <__udivdi3+0xfc>
  8036ff:	74 0b                	je     80370c <__udivdi3+0xf0>
  803701:	89 d8                	mov    %ebx,%eax
  803703:	31 ff                	xor    %edi,%edi
  803705:	e9 58 ff ff ff       	jmp    803662 <__udivdi3+0x46>
  80370a:	66 90                	xchg   %ax,%ax
  80370c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803710:	89 f9                	mov    %edi,%ecx
  803712:	d3 e2                	shl    %cl,%edx
  803714:	39 c2                	cmp    %eax,%edx
  803716:	73 e9                	jae    803701 <__udivdi3+0xe5>
  803718:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80371b:	31 ff                	xor    %edi,%edi
  80371d:	e9 40 ff ff ff       	jmp    803662 <__udivdi3+0x46>
  803722:	66 90                	xchg   %ax,%ax
  803724:	31 c0                	xor    %eax,%eax
  803726:	e9 37 ff ff ff       	jmp    803662 <__udivdi3+0x46>
  80372b:	90                   	nop

0080372c <__umoddi3>:
  80372c:	55                   	push   %ebp
  80372d:	57                   	push   %edi
  80372e:	56                   	push   %esi
  80372f:	53                   	push   %ebx
  803730:	83 ec 1c             	sub    $0x1c,%esp
  803733:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803737:	8b 74 24 34          	mov    0x34(%esp),%esi
  80373b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80373f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803743:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803747:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80374b:	89 f3                	mov    %esi,%ebx
  80374d:	89 fa                	mov    %edi,%edx
  80374f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803753:	89 34 24             	mov    %esi,(%esp)
  803756:	85 c0                	test   %eax,%eax
  803758:	75 1a                	jne    803774 <__umoddi3+0x48>
  80375a:	39 f7                	cmp    %esi,%edi
  80375c:	0f 86 a2 00 00 00    	jbe    803804 <__umoddi3+0xd8>
  803762:	89 c8                	mov    %ecx,%eax
  803764:	89 f2                	mov    %esi,%edx
  803766:	f7 f7                	div    %edi
  803768:	89 d0                	mov    %edx,%eax
  80376a:	31 d2                	xor    %edx,%edx
  80376c:	83 c4 1c             	add    $0x1c,%esp
  80376f:	5b                   	pop    %ebx
  803770:	5e                   	pop    %esi
  803771:	5f                   	pop    %edi
  803772:	5d                   	pop    %ebp
  803773:	c3                   	ret    
  803774:	39 f0                	cmp    %esi,%eax
  803776:	0f 87 ac 00 00 00    	ja     803828 <__umoddi3+0xfc>
  80377c:	0f bd e8             	bsr    %eax,%ebp
  80377f:	83 f5 1f             	xor    $0x1f,%ebp
  803782:	0f 84 ac 00 00 00    	je     803834 <__umoddi3+0x108>
  803788:	bf 20 00 00 00       	mov    $0x20,%edi
  80378d:	29 ef                	sub    %ebp,%edi
  80378f:	89 fe                	mov    %edi,%esi
  803791:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803795:	89 e9                	mov    %ebp,%ecx
  803797:	d3 e0                	shl    %cl,%eax
  803799:	89 d7                	mov    %edx,%edi
  80379b:	89 f1                	mov    %esi,%ecx
  80379d:	d3 ef                	shr    %cl,%edi
  80379f:	09 c7                	or     %eax,%edi
  8037a1:	89 e9                	mov    %ebp,%ecx
  8037a3:	d3 e2                	shl    %cl,%edx
  8037a5:	89 14 24             	mov    %edx,(%esp)
  8037a8:	89 d8                	mov    %ebx,%eax
  8037aa:	d3 e0                	shl    %cl,%eax
  8037ac:	89 c2                	mov    %eax,%edx
  8037ae:	8b 44 24 08          	mov    0x8(%esp),%eax
  8037b2:	d3 e0                	shl    %cl,%eax
  8037b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8037b8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8037bc:	89 f1                	mov    %esi,%ecx
  8037be:	d3 e8                	shr    %cl,%eax
  8037c0:	09 d0                	or     %edx,%eax
  8037c2:	d3 eb                	shr    %cl,%ebx
  8037c4:	89 da                	mov    %ebx,%edx
  8037c6:	f7 f7                	div    %edi
  8037c8:	89 d3                	mov    %edx,%ebx
  8037ca:	f7 24 24             	mull   (%esp)
  8037cd:	89 c6                	mov    %eax,%esi
  8037cf:	89 d1                	mov    %edx,%ecx
  8037d1:	39 d3                	cmp    %edx,%ebx
  8037d3:	0f 82 87 00 00 00    	jb     803860 <__umoddi3+0x134>
  8037d9:	0f 84 91 00 00 00    	je     803870 <__umoddi3+0x144>
  8037df:	8b 54 24 04          	mov    0x4(%esp),%edx
  8037e3:	29 f2                	sub    %esi,%edx
  8037e5:	19 cb                	sbb    %ecx,%ebx
  8037e7:	89 d8                	mov    %ebx,%eax
  8037e9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8037ed:	d3 e0                	shl    %cl,%eax
  8037ef:	89 e9                	mov    %ebp,%ecx
  8037f1:	d3 ea                	shr    %cl,%edx
  8037f3:	09 d0                	or     %edx,%eax
  8037f5:	89 e9                	mov    %ebp,%ecx
  8037f7:	d3 eb                	shr    %cl,%ebx
  8037f9:	89 da                	mov    %ebx,%edx
  8037fb:	83 c4 1c             	add    $0x1c,%esp
  8037fe:	5b                   	pop    %ebx
  8037ff:	5e                   	pop    %esi
  803800:	5f                   	pop    %edi
  803801:	5d                   	pop    %ebp
  803802:	c3                   	ret    
  803803:	90                   	nop
  803804:	89 fd                	mov    %edi,%ebp
  803806:	85 ff                	test   %edi,%edi
  803808:	75 0b                	jne    803815 <__umoddi3+0xe9>
  80380a:	b8 01 00 00 00       	mov    $0x1,%eax
  80380f:	31 d2                	xor    %edx,%edx
  803811:	f7 f7                	div    %edi
  803813:	89 c5                	mov    %eax,%ebp
  803815:	89 f0                	mov    %esi,%eax
  803817:	31 d2                	xor    %edx,%edx
  803819:	f7 f5                	div    %ebp
  80381b:	89 c8                	mov    %ecx,%eax
  80381d:	f7 f5                	div    %ebp
  80381f:	89 d0                	mov    %edx,%eax
  803821:	e9 44 ff ff ff       	jmp    80376a <__umoddi3+0x3e>
  803826:	66 90                	xchg   %ax,%ax
  803828:	89 c8                	mov    %ecx,%eax
  80382a:	89 f2                	mov    %esi,%edx
  80382c:	83 c4 1c             	add    $0x1c,%esp
  80382f:	5b                   	pop    %ebx
  803830:	5e                   	pop    %esi
  803831:	5f                   	pop    %edi
  803832:	5d                   	pop    %ebp
  803833:	c3                   	ret    
  803834:	3b 04 24             	cmp    (%esp),%eax
  803837:	72 06                	jb     80383f <__umoddi3+0x113>
  803839:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80383d:	77 0f                	ja     80384e <__umoddi3+0x122>
  80383f:	89 f2                	mov    %esi,%edx
  803841:	29 f9                	sub    %edi,%ecx
  803843:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803847:	89 14 24             	mov    %edx,(%esp)
  80384a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80384e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803852:	8b 14 24             	mov    (%esp),%edx
  803855:	83 c4 1c             	add    $0x1c,%esp
  803858:	5b                   	pop    %ebx
  803859:	5e                   	pop    %esi
  80385a:	5f                   	pop    %edi
  80385b:	5d                   	pop    %ebp
  80385c:	c3                   	ret    
  80385d:	8d 76 00             	lea    0x0(%esi),%esi
  803860:	2b 04 24             	sub    (%esp),%eax
  803863:	19 fa                	sbb    %edi,%edx
  803865:	89 d1                	mov    %edx,%ecx
  803867:	89 c6                	mov    %eax,%esi
  803869:	e9 71 ff ff ff       	jmp    8037df <__umoddi3+0xb3>
  80386e:	66 90                	xchg   %ax,%ax
  803870:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803874:	72 ea                	jb     803860 <__umoddi3+0x134>
  803876:	89 d9                	mov    %ebx,%ecx
  803878:	e9 62 ff ff ff       	jmp    8037df <__umoddi3+0xb3>
