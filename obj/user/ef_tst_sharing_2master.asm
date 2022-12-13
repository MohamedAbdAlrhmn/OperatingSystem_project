
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
  80008d:	68 40 39 80 00       	push   $0x803940
  800092:	6a 13                	push   $0x13
  800094:	68 5c 39 80 00       	push   $0x80395c
  800099:	e8 1d 04 00 00       	call   8004bb <_panic>
	}
	uint32 *x, *y, *z ;

	//x: Readonly
	int freeFrames = sys_calculate_free_frames() ;
  80009e:	e8 bb 19 00 00       	call   801a5e <sys_calculate_free_frames>
  8000a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	x = smalloc("x", 4, 0);
  8000a6:	83 ec 04             	sub    $0x4,%esp
  8000a9:	6a 00                	push   $0x0
  8000ab:	6a 04                	push   $0x4
  8000ad:	68 7a 39 80 00       	push   $0x80397a
  8000b2:	e8 d5 16 00 00       	call   80178c <smalloc>
  8000b7:	83 c4 10             	add    $0x10,%esp
  8000ba:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if (x != (uint32*)USER_HEAP_START) panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8000bd:	81 7d e8 00 00 00 80 	cmpl   $0x80000000,-0x18(%ebp)
  8000c4:	74 14                	je     8000da <_main+0xa2>
  8000c6:	83 ec 04             	sub    $0x4,%esp
  8000c9:	68 7c 39 80 00       	push   $0x80397c
  8000ce:	6a 1a                	push   $0x1a
  8000d0:	68 5c 39 80 00       	push   $0x80395c
  8000d5:	e8 e1 03 00 00       	call   8004bb <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Create(): Wrong allocation- make sure that you allocate the required space in the user environment and add its frames to frames_storage %d %d %d", freeFrames, sys_calculate_free_frames(), freeFrames - sys_calculate_free_frames());
  8000da:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000dd:	e8 7c 19 00 00       	call   801a5e <sys_calculate_free_frames>
  8000e2:	29 c3                	sub    %eax,%ebx
  8000e4:	89 d8                	mov    %ebx,%eax
  8000e6:	83 f8 04             	cmp    $0x4,%eax
  8000e9:	74 28                	je     800113 <_main+0xdb>
  8000eb:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000ee:	e8 6b 19 00 00       	call   801a5e <sys_calculate_free_frames>
  8000f3:	29 c3                	sub    %eax,%ebx
  8000f5:	e8 64 19 00 00       	call   801a5e <sys_calculate_free_frames>
  8000fa:	83 ec 08             	sub    $0x8,%esp
  8000fd:	53                   	push   %ebx
  8000fe:	50                   	push   %eax
  8000ff:	ff 75 ec             	pushl  -0x14(%ebp)
  800102:	68 e0 39 80 00       	push   $0x8039e0
  800107:	6a 1b                	push   $0x1b
  800109:	68 5c 39 80 00       	push   $0x80395c
  80010e:	e8 a8 03 00 00       	call   8004bb <_panic>

	//y: Readonly
	freeFrames = sys_calculate_free_frames() ;
  800113:	e8 46 19 00 00       	call   801a5e <sys_calculate_free_frames>
  800118:	89 45 ec             	mov    %eax,-0x14(%ebp)
	y = smalloc("y", 4, 0);
  80011b:	83 ec 04             	sub    $0x4,%esp
  80011e:	6a 00                	push   $0x0
  800120:	6a 04                	push   $0x4
  800122:	68 71 3a 80 00       	push   $0x803a71
  800127:	e8 60 16 00 00       	call   80178c <smalloc>
  80012c:	83 c4 10             	add    $0x10,%esp
  80012f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (y != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  800132:	81 7d e4 00 10 00 80 	cmpl   $0x80001000,-0x1c(%ebp)
  800139:	74 14                	je     80014f <_main+0x117>
  80013b:	83 ec 04             	sub    $0x4,%esp
  80013e:	68 7c 39 80 00       	push   $0x80397c
  800143:	6a 20                	push   $0x20
  800145:	68 5c 39 80 00       	push   $0x80395c
  80014a:	e8 6c 03 00 00       	call   8004bb <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1+0+2) panic("Create(): Wrong allocation- make sure that you allocate the required space in the user environment and add its frames to frames_storage %d %d %d", freeFrames, sys_calculate_free_frames(), freeFrames - sys_calculate_free_frames());
  80014f:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  800152:	e8 07 19 00 00       	call   801a5e <sys_calculate_free_frames>
  800157:	29 c3                	sub    %eax,%ebx
  800159:	89 d8                	mov    %ebx,%eax
  80015b:	83 f8 03             	cmp    $0x3,%eax
  80015e:	74 28                	je     800188 <_main+0x150>
  800160:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  800163:	e8 f6 18 00 00       	call   801a5e <sys_calculate_free_frames>
  800168:	29 c3                	sub    %eax,%ebx
  80016a:	e8 ef 18 00 00       	call   801a5e <sys_calculate_free_frames>
  80016f:	83 ec 08             	sub    $0x8,%esp
  800172:	53                   	push   %ebx
  800173:	50                   	push   %eax
  800174:	ff 75 ec             	pushl  -0x14(%ebp)
  800177:	68 e0 39 80 00       	push   $0x8039e0
  80017c:	6a 21                	push   $0x21
  80017e:	68 5c 39 80 00       	push   $0x80395c
  800183:	e8 33 03 00 00       	call   8004bb <_panic>

	//z: Writable
	freeFrames = sys_calculate_free_frames() ;
  800188:	e8 d1 18 00 00       	call   801a5e <sys_calculate_free_frames>
  80018d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	z = smalloc("z", 4, 1);
  800190:	83 ec 04             	sub    $0x4,%esp
  800193:	6a 01                	push   $0x1
  800195:	6a 04                	push   $0x4
  800197:	68 73 3a 80 00       	push   $0x803a73
  80019c:	e8 eb 15 00 00       	call   80178c <smalloc>
  8001a1:	83 c4 10             	add    $0x10,%esp
  8001a4:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (z != (uint32*)(USER_HEAP_START + 2 * PAGE_SIZE)) panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8001a7:	81 7d e0 00 20 00 80 	cmpl   $0x80002000,-0x20(%ebp)
  8001ae:	74 14                	je     8001c4 <_main+0x18c>
  8001b0:	83 ec 04             	sub    $0x4,%esp
  8001b3:	68 7c 39 80 00       	push   $0x80397c
  8001b8:	6a 26                	push   $0x26
  8001ba:	68 5c 39 80 00       	push   $0x80395c
  8001bf:	e8 f7 02 00 00       	call   8004bb <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1+0+2) panic("Create(): Wrong allocation- make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8001c4:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8001c7:	e8 92 18 00 00       	call   801a5e <sys_calculate_free_frames>
  8001cc:	29 c3                	sub    %eax,%ebx
  8001ce:	89 d8                	mov    %ebx,%eax
  8001d0:	83 f8 03             	cmp    $0x3,%eax
  8001d3:	74 14                	je     8001e9 <_main+0x1b1>
  8001d5:	83 ec 04             	sub    $0x4,%esp
  8001d8:	68 78 3a 80 00       	push   $0x803a78
  8001dd:	6a 27                	push   $0x27
  8001df:	68 5c 39 80 00       	push   $0x80395c
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
  800214:	68 00 3b 80 00       	push   $0x803b00
  800219:	e8 b2 1a 00 00       	call   801cd0 <sys_create_env>
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
  80023d:	68 00 3b 80 00       	push   $0x803b00
  800242:	e8 89 1a 00 00       	call   801cd0 <sys_create_env>
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
  800266:	68 00 3b 80 00       	push   $0x803b00
  80026b:	e8 60 1a 00 00       	call   801cd0 <sys_create_env>
  800270:	83 c4 10             	add    $0x10,%esp
  800273:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	//to check that the slave environments completed successfully
	rsttst();
  800276:	e8 a1 1b 00 00       	call   801e1c <rsttst>

	int* finish_children = smalloc("finish_children", sizeof(int), 1);
  80027b:	83 ec 04             	sub    $0x4,%esp
  80027e:	6a 01                	push   $0x1
  800280:	6a 04                	push   $0x4
  800282:	68 0e 3b 80 00       	push   $0x803b0e
  800287:	e8 00 15 00 00       	call   80178c <smalloc>
  80028c:	83 c4 10             	add    $0x10,%esp
  80028f:	89 45 d0             	mov    %eax,-0x30(%ebp)

	sys_run_env(id1);
  800292:	83 ec 0c             	sub    $0xc,%esp
  800295:	ff 75 dc             	pushl  -0x24(%ebp)
  800298:	e8 51 1a 00 00       	call   801cee <sys_run_env>
  80029d:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id2);
  8002a0:	83 ec 0c             	sub    $0xc,%esp
  8002a3:	ff 75 d8             	pushl  -0x28(%ebp)
  8002a6:	e8 43 1a 00 00       	call   801cee <sys_run_env>
  8002ab:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id3);
  8002ae:	83 ec 0c             	sub    $0xc,%esp
  8002b1:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002b4:	e8 35 1a 00 00       	call   801cee <sys_run_env>
  8002b9:	83 c4 10             	add    $0x10,%esp

	env_sleep(15000) ;
  8002bc:	83 ec 0c             	sub    $0xc,%esp
  8002bf:	68 98 3a 00 00       	push   $0x3a98
  8002c4:	e8 57 33 00 00       	call   803620 <env_sleep>
  8002c9:	83 c4 10             	add    $0x10,%esp

	//to ensure that the slave environments completed successfully
	if (gettst()!=3) panic("test failed");
  8002cc:	e8 c5 1b 00 00       	call   801e96 <gettst>
  8002d1:	83 f8 03             	cmp    $0x3,%eax
  8002d4:	74 14                	je     8002ea <_main+0x2b2>
  8002d6:	83 ec 04             	sub    $0x4,%esp
  8002d9:	68 1e 3b 80 00       	push   $0x803b1e
  8002de:	6a 3d                	push   $0x3d
  8002e0:	68 5c 39 80 00       	push   $0x80395c
  8002e5:	e8 d1 01 00 00       	call   8004bb <_panic>


	if (*z != 30)
  8002ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002ed:	8b 00                	mov    (%eax),%eax
  8002ef:	83 f8 1e             	cmp    $0x1e,%eax
  8002f2:	74 14                	je     800308 <_main+0x2d0>
		panic("Error!! Please check the creation (or the getting) of shared 2variables!!\n\n\n");
  8002f4:	83 ec 04             	sub    $0x4,%esp
  8002f7:	68 2c 3b 80 00       	push   $0x803b2c
  8002fc:	6a 41                	push   $0x41
  8002fe:	68 5c 39 80 00       	push   $0x80395c
  800303:	e8 b3 01 00 00       	call   8004bb <_panic>
	else
		cprintf("Congratulations!! Test of Shared Variables [Create & Get] [2] completed successfully!!\n\n\n");
  800308:	83 ec 0c             	sub    $0xc,%esp
  80030b:	68 7c 3b 80 00       	push   $0x803b7c
  800310:	e8 5a 04 00 00       	call   80076f <cprintf>
  800315:	83 c4 10             	add    $0x10,%esp


	if (sys_getparentenvid() > 0) {
  800318:	e8 3a 1a 00 00       	call   801d57 <sys_getparentenvid>
  80031d:	85 c0                	test   %eax,%eax
  80031f:	7e 58                	jle    800379 <_main+0x341>
		sys_destroy_env(id1);
  800321:	83 ec 0c             	sub    $0xc,%esp
  800324:	ff 75 dc             	pushl  -0x24(%ebp)
  800327:	e8 de 19 00 00       	call   801d0a <sys_destroy_env>
  80032c:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(id2);
  80032f:	83 ec 0c             	sub    $0xc,%esp
  800332:	ff 75 d8             	pushl  -0x28(%ebp)
  800335:	e8 d0 19 00 00       	call   801d0a <sys_destroy_env>
  80033a:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(id3);
  80033d:	83 ec 0c             	sub    $0xc,%esp
  800340:	ff 75 d4             	pushl  -0x2c(%ebp)
  800343:	e8 c2 19 00 00       	call   801d0a <sys_destroy_env>
  800348:	83 c4 10             	add    $0x10,%esp
		int *finishedCount = NULL;
  80034b:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
		finishedCount = sget(sys_getparentenvid(), "finishedCount") ;
  800352:	e8 00 1a 00 00       	call   801d57 <sys_getparentenvid>
  800357:	83 ec 08             	sub    $0x8,%esp
  80035a:	68 d6 3b 80 00       	push   $0x803bd6
  80035f:	50                   	push   %eax
  800360:	e8 d5 14 00 00       	call   80183a <sget>
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
  800385:	e8 b4 19 00 00       	call   801d3e <sys_getenvindex>
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
  8003f0:	e8 56 17 00 00       	call   801b4b <sys_disable_interrupt>
	cprintf("**************************************\n");
  8003f5:	83 ec 0c             	sub    $0xc,%esp
  8003f8:	68 fc 3b 80 00       	push   $0x803bfc
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
  800420:	68 24 3c 80 00       	push   $0x803c24
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
  800451:	68 4c 3c 80 00       	push   $0x803c4c
  800456:	e8 14 03 00 00       	call   80076f <cprintf>
  80045b:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80045e:	a1 20 50 80 00       	mov    0x805020,%eax
  800463:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800469:	83 ec 08             	sub    $0x8,%esp
  80046c:	50                   	push   %eax
  80046d:	68 a4 3c 80 00       	push   $0x803ca4
  800472:	e8 f8 02 00 00       	call   80076f <cprintf>
  800477:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80047a:	83 ec 0c             	sub    $0xc,%esp
  80047d:	68 fc 3b 80 00       	push   $0x803bfc
  800482:	e8 e8 02 00 00       	call   80076f <cprintf>
  800487:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80048a:	e8 d6 16 00 00       	call   801b65 <sys_enable_interrupt>

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
  8004a2:	e8 63 18 00 00       	call   801d0a <sys_destroy_env>
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
  8004b3:	e8 b8 18 00 00       	call   801d70 <sys_exit_env>
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
  8004dc:	68 b8 3c 80 00       	push   $0x803cb8
  8004e1:	e8 89 02 00 00       	call   80076f <cprintf>
  8004e6:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8004e9:	a1 00 50 80 00       	mov    0x805000,%eax
  8004ee:	ff 75 0c             	pushl  0xc(%ebp)
  8004f1:	ff 75 08             	pushl  0x8(%ebp)
  8004f4:	50                   	push   %eax
  8004f5:	68 bd 3c 80 00       	push   $0x803cbd
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
  800519:	68 d9 3c 80 00       	push   $0x803cd9
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
  800545:	68 dc 3c 80 00       	push   $0x803cdc
  80054a:	6a 26                	push   $0x26
  80054c:	68 28 3d 80 00       	push   $0x803d28
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
  800617:	68 34 3d 80 00       	push   $0x803d34
  80061c:	6a 3a                	push   $0x3a
  80061e:	68 28 3d 80 00       	push   $0x803d28
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
  800687:	68 88 3d 80 00       	push   $0x803d88
  80068c:	6a 44                	push   $0x44
  80068e:	68 28 3d 80 00       	push   $0x803d28
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
  8006e1:	e8 b7 12 00 00       	call   80199d <sys_cputs>
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
  800758:	e8 40 12 00 00       	call   80199d <sys_cputs>
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
  8007a2:	e8 a4 13 00 00       	call   801b4b <sys_disable_interrupt>
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
  8007c2:	e8 9e 13 00 00       	call   801b65 <sys_enable_interrupt>
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
  80080c:	e8 c3 2e 00 00       	call   8036d4 <__udivdi3>
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
  80085c:	e8 83 2f 00 00       	call   8037e4 <__umoddi3>
  800861:	83 c4 10             	add    $0x10,%esp
  800864:	05 f4 3f 80 00       	add    $0x803ff4,%eax
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
  8009b7:	8b 04 85 18 40 80 00 	mov    0x804018(,%eax,4),%eax
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
  800a98:	8b 34 9d 60 3e 80 00 	mov    0x803e60(,%ebx,4),%esi
  800a9f:	85 f6                	test   %esi,%esi
  800aa1:	75 19                	jne    800abc <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800aa3:	53                   	push   %ebx
  800aa4:	68 05 40 80 00       	push   $0x804005
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
  800abd:	68 0e 40 80 00       	push   $0x80400e
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
  800aea:	be 11 40 80 00       	mov    $0x804011,%esi
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
  801510:	68 70 41 80 00       	push   $0x804170
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
  8015e0:	e8 fc 04 00 00       	call   801ae1 <sys_allocate_chunk>
  8015e5:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8015e8:	a1 20 51 80 00       	mov    0x805120,%eax
  8015ed:	83 ec 0c             	sub    $0xc,%esp
  8015f0:	50                   	push   %eax
  8015f1:	e8 71 0b 00 00       	call   802167 <initialize_MemBlocksList>
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
  80161e:	68 95 41 80 00       	push   $0x804195
  801623:	6a 33                	push   $0x33
  801625:	68 b3 41 80 00       	push   $0x8041b3
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
  80169d:	68 c0 41 80 00       	push   $0x8041c0
  8016a2:	6a 34                	push   $0x34
  8016a4:	68 b3 41 80 00       	push   $0x8041b3
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
  8016fa:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016fd:	e8 f7 fd ff ff       	call   8014f9 <InitializeUHeap>
	if (size == 0) return NULL ;
  801702:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801706:	75 07                	jne    80170f <malloc+0x18>
  801708:	b8 00 00 00 00       	mov    $0x0,%eax
  80170d:	eb 61                	jmp    801770 <malloc+0x79>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
	uint32 malloc_allocsize=ROUNDUP(size,PAGE_SIZE);
  80170f:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801716:	8b 55 08             	mov    0x8(%ebp),%edx
  801719:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80171c:	01 d0                	add    %edx,%eax
  80171e:	48                   	dec    %eax
  80171f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801722:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801725:	ba 00 00 00 00       	mov    $0x0,%edx
  80172a:	f7 75 f0             	divl   -0x10(%ebp)
  80172d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801730:	29 d0                	sub    %edx,%eax
  801732:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 //int ret=0;
	struct MemBlock * user_block;
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801735:	e8 75 07 00 00       	call   801eaf <sys_isUHeapPlacementStrategyFIRSTFIT>
  80173a:	85 c0                	test   %eax,%eax
  80173c:	74 11                	je     80174f <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  80173e:	83 ec 0c             	sub    $0xc,%esp
  801741:	ff 75 e8             	pushl  -0x18(%ebp)
  801744:	e8 e0 0d 00 00       	call   802529 <alloc_block_FF>
  801749:	83 c4 10             	add    $0x10,%esp
  80174c:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(user_block!=NULL)
  80174f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801753:	74 16                	je     80176b <malloc+0x74>
	{
		//sys_allocate_chunk(user_block->sva,malloc_allocsize,PERM_WRITEABLE| PERM_PRESENT);
		insert_sorted_allocList(user_block);
  801755:	83 ec 0c             	sub    $0xc,%esp
  801758:	ff 75 f4             	pushl  -0xc(%ebp)
  80175b:	e8 3c 0b 00 00       	call   80229c <insert_sorted_allocList>
  801760:	83 c4 10             	add    $0x10,%esp
		return (uint32 *)user_block->sva;
  801763:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801766:	8b 40 08             	mov    0x8(%eax),%eax
  801769:	eb 05                	jmp    801770 <malloc+0x79>
	}

    return NULL;
  80176b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801770:	c9                   	leave  
  801771:	c3                   	ret    

00801772 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801772:	55                   	push   %ebp
  801773:	89 e5                	mov    %esp,%ebp
  801775:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801778:	83 ec 04             	sub    $0x4,%esp
  80177b:	68 e4 41 80 00       	push   $0x8041e4
  801780:	6a 6f                	push   $0x6f
  801782:	68 b3 41 80 00       	push   $0x8041b3
  801787:	e8 2f ed ff ff       	call   8004bb <_panic>

0080178c <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80178c:	55                   	push   %ebp
  80178d:	89 e5                	mov    %esp,%ebp
  80178f:	83 ec 38             	sub    $0x38,%esp
  801792:	8b 45 10             	mov    0x10(%ebp),%eax
  801795:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801798:	e8 5c fd ff ff       	call   8014f9 <InitializeUHeap>
	if (size == 0) return NULL ;
  80179d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8017a1:	75 0a                	jne    8017ad <smalloc+0x21>
  8017a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8017a8:	e9 8b 00 00 00       	jmp    801838 <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  8017ad:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8017b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017ba:	01 d0                	add    %edx,%eax
  8017bc:	48                   	dec    %eax
  8017bd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8017c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8017c8:	f7 75 f0             	divl   -0x10(%ebp)
  8017cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017ce:	29 d0                	sub    %edx,%eax
  8017d0:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  8017d3:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8017da:	e8 d0 06 00 00       	call   801eaf <sys_isUHeapPlacementStrategyFIRSTFIT>
  8017df:	85 c0                	test   %eax,%eax
  8017e1:	74 11                	je     8017f4 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  8017e3:	83 ec 0c             	sub    $0xc,%esp
  8017e6:	ff 75 e8             	pushl  -0x18(%ebp)
  8017e9:	e8 3b 0d 00 00       	call   802529 <alloc_block_FF>
  8017ee:	83 c4 10             	add    $0x10,%esp
  8017f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  8017f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8017f8:	74 39                	je     801833 <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8017fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017fd:	8b 40 08             	mov    0x8(%eax),%eax
  801800:	89 c2                	mov    %eax,%edx
  801802:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801806:	52                   	push   %edx
  801807:	50                   	push   %eax
  801808:	ff 75 0c             	pushl  0xc(%ebp)
  80180b:	ff 75 08             	pushl  0x8(%ebp)
  80180e:	e8 21 04 00 00       	call   801c34 <sys_createSharedObject>
  801813:	83 c4 10             	add    $0x10,%esp
  801816:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  801819:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  80181d:	74 14                	je     801833 <smalloc+0xa7>
  80181f:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  801823:	74 0e                	je     801833 <smalloc+0xa7>
  801825:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  801829:	74 08                	je     801833 <smalloc+0xa7>
			return (void*) mem_block->sva;
  80182b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80182e:	8b 40 08             	mov    0x8(%eax),%eax
  801831:	eb 05                	jmp    801838 <smalloc+0xac>
	}
	return NULL;
  801833:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801838:	c9                   	leave  
  801839:	c3                   	ret    

0080183a <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80183a:	55                   	push   %ebp
  80183b:	89 e5                	mov    %esp,%ebp
  80183d:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801840:	e8 b4 fc ff ff       	call   8014f9 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801845:	83 ec 08             	sub    $0x8,%esp
  801848:	ff 75 0c             	pushl  0xc(%ebp)
  80184b:	ff 75 08             	pushl  0x8(%ebp)
  80184e:	e8 0b 04 00 00       	call   801c5e <sys_getSizeOfSharedObject>
  801853:	83 c4 10             	add    $0x10,%esp
  801856:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  801859:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  80185d:	74 76                	je     8018d5 <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  80185f:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801866:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801869:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80186c:	01 d0                	add    %edx,%eax
  80186e:	48                   	dec    %eax
  80186f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801872:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801875:	ba 00 00 00 00       	mov    $0x0,%edx
  80187a:	f7 75 ec             	divl   -0x14(%ebp)
  80187d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801880:	29 d0                	sub    %edx,%eax
  801882:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  801885:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  80188c:	e8 1e 06 00 00       	call   801eaf <sys_isUHeapPlacementStrategyFIRSTFIT>
  801891:	85 c0                	test   %eax,%eax
  801893:	74 11                	je     8018a6 <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  801895:	83 ec 0c             	sub    $0xc,%esp
  801898:	ff 75 e4             	pushl  -0x1c(%ebp)
  80189b:	e8 89 0c 00 00       	call   802529 <alloc_block_FF>
  8018a0:	83 c4 10             	add    $0x10,%esp
  8018a3:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  8018a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8018aa:	74 29                	je     8018d5 <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  8018ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018af:	8b 40 08             	mov    0x8(%eax),%eax
  8018b2:	83 ec 04             	sub    $0x4,%esp
  8018b5:	50                   	push   %eax
  8018b6:	ff 75 0c             	pushl  0xc(%ebp)
  8018b9:	ff 75 08             	pushl  0x8(%ebp)
  8018bc:	e8 ba 03 00 00       	call   801c7b <sys_getSharedObject>
  8018c1:	83 c4 10             	add    $0x10,%esp
  8018c4:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  8018c7:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  8018cb:	74 08                	je     8018d5 <sget+0x9b>
				return (void *)mem_block->sva;
  8018cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018d0:	8b 40 08             	mov    0x8(%eax),%eax
  8018d3:	eb 05                	jmp    8018da <sget+0xa0>
		}
	}
	return (void *)NULL;
  8018d5:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8018da:	c9                   	leave  
  8018db:	c3                   	ret    

008018dc <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8018dc:	55                   	push   %ebp
  8018dd:	89 e5                	mov    %esp,%ebp
  8018df:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8018e2:	e8 12 fc ff ff       	call   8014f9 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8018e7:	83 ec 04             	sub    $0x4,%esp
  8018ea:	68 08 42 80 00       	push   $0x804208
  8018ef:	68 f1 00 00 00       	push   $0xf1
  8018f4:	68 b3 41 80 00       	push   $0x8041b3
  8018f9:	e8 bd eb ff ff       	call   8004bb <_panic>

008018fe <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8018fe:	55                   	push   %ebp
  8018ff:	89 e5                	mov    %esp,%ebp
  801901:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801904:	83 ec 04             	sub    $0x4,%esp
  801907:	68 30 42 80 00       	push   $0x804230
  80190c:	68 05 01 00 00       	push   $0x105
  801911:	68 b3 41 80 00       	push   $0x8041b3
  801916:	e8 a0 eb ff ff       	call   8004bb <_panic>

0080191b <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80191b:	55                   	push   %ebp
  80191c:	89 e5                	mov    %esp,%ebp
  80191e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801921:	83 ec 04             	sub    $0x4,%esp
  801924:	68 54 42 80 00       	push   $0x804254
  801929:	68 10 01 00 00       	push   $0x110
  80192e:	68 b3 41 80 00       	push   $0x8041b3
  801933:	e8 83 eb ff ff       	call   8004bb <_panic>

00801938 <shrink>:

}
void shrink(uint32 newSize)
{
  801938:	55                   	push   %ebp
  801939:	89 e5                	mov    %esp,%ebp
  80193b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80193e:	83 ec 04             	sub    $0x4,%esp
  801941:	68 54 42 80 00       	push   $0x804254
  801946:	68 15 01 00 00       	push   $0x115
  80194b:	68 b3 41 80 00       	push   $0x8041b3
  801950:	e8 66 eb ff ff       	call   8004bb <_panic>

00801955 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801955:	55                   	push   %ebp
  801956:	89 e5                	mov    %esp,%ebp
  801958:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80195b:	83 ec 04             	sub    $0x4,%esp
  80195e:	68 54 42 80 00       	push   $0x804254
  801963:	68 1a 01 00 00       	push   $0x11a
  801968:	68 b3 41 80 00       	push   $0x8041b3
  80196d:	e8 49 eb ff ff       	call   8004bb <_panic>

00801972 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801972:	55                   	push   %ebp
  801973:	89 e5                	mov    %esp,%ebp
  801975:	57                   	push   %edi
  801976:	56                   	push   %esi
  801977:	53                   	push   %ebx
  801978:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80197b:	8b 45 08             	mov    0x8(%ebp),%eax
  80197e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801981:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801984:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801987:	8b 7d 18             	mov    0x18(%ebp),%edi
  80198a:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80198d:	cd 30                	int    $0x30
  80198f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801992:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801995:	83 c4 10             	add    $0x10,%esp
  801998:	5b                   	pop    %ebx
  801999:	5e                   	pop    %esi
  80199a:	5f                   	pop    %edi
  80199b:	5d                   	pop    %ebp
  80199c:	c3                   	ret    

0080199d <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80199d:	55                   	push   %ebp
  80199e:	89 e5                	mov    %esp,%ebp
  8019a0:	83 ec 04             	sub    $0x4,%esp
  8019a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8019a6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8019a9:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b0:	6a 00                	push   $0x0
  8019b2:	6a 00                	push   $0x0
  8019b4:	52                   	push   %edx
  8019b5:	ff 75 0c             	pushl  0xc(%ebp)
  8019b8:	50                   	push   %eax
  8019b9:	6a 00                	push   $0x0
  8019bb:	e8 b2 ff ff ff       	call   801972 <syscall>
  8019c0:	83 c4 18             	add    $0x18,%esp
}
  8019c3:	90                   	nop
  8019c4:	c9                   	leave  
  8019c5:	c3                   	ret    

008019c6 <sys_cgetc>:

int
sys_cgetc(void)
{
  8019c6:	55                   	push   %ebp
  8019c7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8019c9:	6a 00                	push   $0x0
  8019cb:	6a 00                	push   $0x0
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 00                	push   $0x0
  8019d3:	6a 01                	push   $0x1
  8019d5:	e8 98 ff ff ff       	call   801972 <syscall>
  8019da:	83 c4 18             	add    $0x18,%esp
}
  8019dd:	c9                   	leave  
  8019de:	c3                   	ret    

008019df <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8019df:	55                   	push   %ebp
  8019e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8019e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e8:	6a 00                	push   $0x0
  8019ea:	6a 00                	push   $0x0
  8019ec:	6a 00                	push   $0x0
  8019ee:	52                   	push   %edx
  8019ef:	50                   	push   %eax
  8019f0:	6a 05                	push   $0x5
  8019f2:	e8 7b ff ff ff       	call   801972 <syscall>
  8019f7:	83 c4 18             	add    $0x18,%esp
}
  8019fa:	c9                   	leave  
  8019fb:	c3                   	ret    

008019fc <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8019fc:	55                   	push   %ebp
  8019fd:	89 e5                	mov    %esp,%ebp
  8019ff:	56                   	push   %esi
  801a00:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801a01:	8b 75 18             	mov    0x18(%ebp),%esi
  801a04:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a07:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a0a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a10:	56                   	push   %esi
  801a11:	53                   	push   %ebx
  801a12:	51                   	push   %ecx
  801a13:	52                   	push   %edx
  801a14:	50                   	push   %eax
  801a15:	6a 06                	push   $0x6
  801a17:	e8 56 ff ff ff       	call   801972 <syscall>
  801a1c:	83 c4 18             	add    $0x18,%esp
}
  801a1f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a22:	5b                   	pop    %ebx
  801a23:	5e                   	pop    %esi
  801a24:	5d                   	pop    %ebp
  801a25:	c3                   	ret    

00801a26 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801a26:	55                   	push   %ebp
  801a27:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801a29:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2f:	6a 00                	push   $0x0
  801a31:	6a 00                	push   $0x0
  801a33:	6a 00                	push   $0x0
  801a35:	52                   	push   %edx
  801a36:	50                   	push   %eax
  801a37:	6a 07                	push   $0x7
  801a39:	e8 34 ff ff ff       	call   801972 <syscall>
  801a3e:	83 c4 18             	add    $0x18,%esp
}
  801a41:	c9                   	leave  
  801a42:	c3                   	ret    

00801a43 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801a43:	55                   	push   %ebp
  801a44:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801a46:	6a 00                	push   $0x0
  801a48:	6a 00                	push   $0x0
  801a4a:	6a 00                	push   $0x0
  801a4c:	ff 75 0c             	pushl  0xc(%ebp)
  801a4f:	ff 75 08             	pushl  0x8(%ebp)
  801a52:	6a 08                	push   $0x8
  801a54:	e8 19 ff ff ff       	call   801972 <syscall>
  801a59:	83 c4 18             	add    $0x18,%esp
}
  801a5c:	c9                   	leave  
  801a5d:	c3                   	ret    

00801a5e <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801a5e:	55                   	push   %ebp
  801a5f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801a61:	6a 00                	push   $0x0
  801a63:	6a 00                	push   $0x0
  801a65:	6a 00                	push   $0x0
  801a67:	6a 00                	push   $0x0
  801a69:	6a 00                	push   $0x0
  801a6b:	6a 09                	push   $0x9
  801a6d:	e8 00 ff ff ff       	call   801972 <syscall>
  801a72:	83 c4 18             	add    $0x18,%esp
}
  801a75:	c9                   	leave  
  801a76:	c3                   	ret    

00801a77 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801a77:	55                   	push   %ebp
  801a78:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801a7a:	6a 00                	push   $0x0
  801a7c:	6a 00                	push   $0x0
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 00                	push   $0x0
  801a82:	6a 00                	push   $0x0
  801a84:	6a 0a                	push   $0xa
  801a86:	e8 e7 fe ff ff       	call   801972 <syscall>
  801a8b:	83 c4 18             	add    $0x18,%esp
}
  801a8e:	c9                   	leave  
  801a8f:	c3                   	ret    

00801a90 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a90:	55                   	push   %ebp
  801a91:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a93:	6a 00                	push   $0x0
  801a95:	6a 00                	push   $0x0
  801a97:	6a 00                	push   $0x0
  801a99:	6a 00                	push   $0x0
  801a9b:	6a 00                	push   $0x0
  801a9d:	6a 0b                	push   $0xb
  801a9f:	e8 ce fe ff ff       	call   801972 <syscall>
  801aa4:	83 c4 18             	add    $0x18,%esp
}
  801aa7:	c9                   	leave  
  801aa8:	c3                   	ret    

00801aa9 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801aa9:	55                   	push   %ebp
  801aaa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801aac:	6a 00                	push   $0x0
  801aae:	6a 00                	push   $0x0
  801ab0:	6a 00                	push   $0x0
  801ab2:	ff 75 0c             	pushl  0xc(%ebp)
  801ab5:	ff 75 08             	pushl  0x8(%ebp)
  801ab8:	6a 0f                	push   $0xf
  801aba:	e8 b3 fe ff ff       	call   801972 <syscall>
  801abf:	83 c4 18             	add    $0x18,%esp
	return;
  801ac2:	90                   	nop
}
  801ac3:	c9                   	leave  
  801ac4:	c3                   	ret    

00801ac5 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801ac5:	55                   	push   %ebp
  801ac6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801ac8:	6a 00                	push   $0x0
  801aca:	6a 00                	push   $0x0
  801acc:	6a 00                	push   $0x0
  801ace:	ff 75 0c             	pushl  0xc(%ebp)
  801ad1:	ff 75 08             	pushl  0x8(%ebp)
  801ad4:	6a 10                	push   $0x10
  801ad6:	e8 97 fe ff ff       	call   801972 <syscall>
  801adb:	83 c4 18             	add    $0x18,%esp
	return ;
  801ade:	90                   	nop
}
  801adf:	c9                   	leave  
  801ae0:	c3                   	ret    

00801ae1 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801ae1:	55                   	push   %ebp
  801ae2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801ae4:	6a 00                	push   $0x0
  801ae6:	6a 00                	push   $0x0
  801ae8:	ff 75 10             	pushl  0x10(%ebp)
  801aeb:	ff 75 0c             	pushl  0xc(%ebp)
  801aee:	ff 75 08             	pushl  0x8(%ebp)
  801af1:	6a 11                	push   $0x11
  801af3:	e8 7a fe ff ff       	call   801972 <syscall>
  801af8:	83 c4 18             	add    $0x18,%esp
	return ;
  801afb:	90                   	nop
}
  801afc:	c9                   	leave  
  801afd:	c3                   	ret    

00801afe <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801afe:	55                   	push   %ebp
  801aff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801b01:	6a 00                	push   $0x0
  801b03:	6a 00                	push   $0x0
  801b05:	6a 00                	push   $0x0
  801b07:	6a 00                	push   $0x0
  801b09:	6a 00                	push   $0x0
  801b0b:	6a 0c                	push   $0xc
  801b0d:	e8 60 fe ff ff       	call   801972 <syscall>
  801b12:	83 c4 18             	add    $0x18,%esp
}
  801b15:	c9                   	leave  
  801b16:	c3                   	ret    

00801b17 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801b17:	55                   	push   %ebp
  801b18:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801b1a:	6a 00                	push   $0x0
  801b1c:	6a 00                	push   $0x0
  801b1e:	6a 00                	push   $0x0
  801b20:	6a 00                	push   $0x0
  801b22:	ff 75 08             	pushl  0x8(%ebp)
  801b25:	6a 0d                	push   $0xd
  801b27:	e8 46 fe ff ff       	call   801972 <syscall>
  801b2c:	83 c4 18             	add    $0x18,%esp
}
  801b2f:	c9                   	leave  
  801b30:	c3                   	ret    

00801b31 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801b31:	55                   	push   %ebp
  801b32:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801b34:	6a 00                	push   $0x0
  801b36:	6a 00                	push   $0x0
  801b38:	6a 00                	push   $0x0
  801b3a:	6a 00                	push   $0x0
  801b3c:	6a 00                	push   $0x0
  801b3e:	6a 0e                	push   $0xe
  801b40:	e8 2d fe ff ff       	call   801972 <syscall>
  801b45:	83 c4 18             	add    $0x18,%esp
}
  801b48:	90                   	nop
  801b49:	c9                   	leave  
  801b4a:	c3                   	ret    

00801b4b <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801b4b:	55                   	push   %ebp
  801b4c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801b4e:	6a 00                	push   $0x0
  801b50:	6a 00                	push   $0x0
  801b52:	6a 00                	push   $0x0
  801b54:	6a 00                	push   $0x0
  801b56:	6a 00                	push   $0x0
  801b58:	6a 13                	push   $0x13
  801b5a:	e8 13 fe ff ff       	call   801972 <syscall>
  801b5f:	83 c4 18             	add    $0x18,%esp
}
  801b62:	90                   	nop
  801b63:	c9                   	leave  
  801b64:	c3                   	ret    

00801b65 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801b65:	55                   	push   %ebp
  801b66:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801b68:	6a 00                	push   $0x0
  801b6a:	6a 00                	push   $0x0
  801b6c:	6a 00                	push   $0x0
  801b6e:	6a 00                	push   $0x0
  801b70:	6a 00                	push   $0x0
  801b72:	6a 14                	push   $0x14
  801b74:	e8 f9 fd ff ff       	call   801972 <syscall>
  801b79:	83 c4 18             	add    $0x18,%esp
}
  801b7c:	90                   	nop
  801b7d:	c9                   	leave  
  801b7e:	c3                   	ret    

00801b7f <sys_cputc>:


void
sys_cputc(const char c)
{
  801b7f:	55                   	push   %ebp
  801b80:	89 e5                	mov    %esp,%ebp
  801b82:	83 ec 04             	sub    $0x4,%esp
  801b85:	8b 45 08             	mov    0x8(%ebp),%eax
  801b88:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b8b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 00                	push   $0x0
  801b93:	6a 00                	push   $0x0
  801b95:	6a 00                	push   $0x0
  801b97:	50                   	push   %eax
  801b98:	6a 15                	push   $0x15
  801b9a:	e8 d3 fd ff ff       	call   801972 <syscall>
  801b9f:	83 c4 18             	add    $0x18,%esp
}
  801ba2:	90                   	nop
  801ba3:	c9                   	leave  
  801ba4:	c3                   	ret    

00801ba5 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801ba5:	55                   	push   %ebp
  801ba6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801ba8:	6a 00                	push   $0x0
  801baa:	6a 00                	push   $0x0
  801bac:	6a 00                	push   $0x0
  801bae:	6a 00                	push   $0x0
  801bb0:	6a 00                	push   $0x0
  801bb2:	6a 16                	push   $0x16
  801bb4:	e8 b9 fd ff ff       	call   801972 <syscall>
  801bb9:	83 c4 18             	add    $0x18,%esp
}
  801bbc:	90                   	nop
  801bbd:	c9                   	leave  
  801bbe:	c3                   	ret    

00801bbf <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801bbf:	55                   	push   %ebp
  801bc0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc5:	6a 00                	push   $0x0
  801bc7:	6a 00                	push   $0x0
  801bc9:	6a 00                	push   $0x0
  801bcb:	ff 75 0c             	pushl  0xc(%ebp)
  801bce:	50                   	push   %eax
  801bcf:	6a 17                	push   $0x17
  801bd1:	e8 9c fd ff ff       	call   801972 <syscall>
  801bd6:	83 c4 18             	add    $0x18,%esp
}
  801bd9:	c9                   	leave  
  801bda:	c3                   	ret    

00801bdb <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801bdb:	55                   	push   %ebp
  801bdc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801bde:	8b 55 0c             	mov    0xc(%ebp),%edx
  801be1:	8b 45 08             	mov    0x8(%ebp),%eax
  801be4:	6a 00                	push   $0x0
  801be6:	6a 00                	push   $0x0
  801be8:	6a 00                	push   $0x0
  801bea:	52                   	push   %edx
  801beb:	50                   	push   %eax
  801bec:	6a 1a                	push   $0x1a
  801bee:	e8 7f fd ff ff       	call   801972 <syscall>
  801bf3:	83 c4 18             	add    $0x18,%esp
}
  801bf6:	c9                   	leave  
  801bf7:	c3                   	ret    

00801bf8 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801bf8:	55                   	push   %ebp
  801bf9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801bfb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  801c01:	6a 00                	push   $0x0
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	52                   	push   %edx
  801c08:	50                   	push   %eax
  801c09:	6a 18                	push   $0x18
  801c0b:	e8 62 fd ff ff       	call   801972 <syscall>
  801c10:	83 c4 18             	add    $0x18,%esp
}
  801c13:	90                   	nop
  801c14:	c9                   	leave  
  801c15:	c3                   	ret    

00801c16 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801c16:	55                   	push   %ebp
  801c17:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c19:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 00                	push   $0x0
  801c23:	6a 00                	push   $0x0
  801c25:	52                   	push   %edx
  801c26:	50                   	push   %eax
  801c27:	6a 19                	push   $0x19
  801c29:	e8 44 fd ff ff       	call   801972 <syscall>
  801c2e:	83 c4 18             	add    $0x18,%esp
}
  801c31:	90                   	nop
  801c32:	c9                   	leave  
  801c33:	c3                   	ret    

00801c34 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801c34:	55                   	push   %ebp
  801c35:	89 e5                	mov    %esp,%ebp
  801c37:	83 ec 04             	sub    $0x4,%esp
  801c3a:	8b 45 10             	mov    0x10(%ebp),%eax
  801c3d:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801c40:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801c43:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c47:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4a:	6a 00                	push   $0x0
  801c4c:	51                   	push   %ecx
  801c4d:	52                   	push   %edx
  801c4e:	ff 75 0c             	pushl  0xc(%ebp)
  801c51:	50                   	push   %eax
  801c52:	6a 1b                	push   $0x1b
  801c54:	e8 19 fd ff ff       	call   801972 <syscall>
  801c59:	83 c4 18             	add    $0x18,%esp
}
  801c5c:	c9                   	leave  
  801c5d:	c3                   	ret    

00801c5e <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801c5e:	55                   	push   %ebp
  801c5f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801c61:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c64:	8b 45 08             	mov    0x8(%ebp),%eax
  801c67:	6a 00                	push   $0x0
  801c69:	6a 00                	push   $0x0
  801c6b:	6a 00                	push   $0x0
  801c6d:	52                   	push   %edx
  801c6e:	50                   	push   %eax
  801c6f:	6a 1c                	push   $0x1c
  801c71:	e8 fc fc ff ff       	call   801972 <syscall>
  801c76:	83 c4 18             	add    $0x18,%esp
}
  801c79:	c9                   	leave  
  801c7a:	c3                   	ret    

00801c7b <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801c7b:	55                   	push   %ebp
  801c7c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801c7e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c81:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c84:	8b 45 08             	mov    0x8(%ebp),%eax
  801c87:	6a 00                	push   $0x0
  801c89:	6a 00                	push   $0x0
  801c8b:	51                   	push   %ecx
  801c8c:	52                   	push   %edx
  801c8d:	50                   	push   %eax
  801c8e:	6a 1d                	push   $0x1d
  801c90:	e8 dd fc ff ff       	call   801972 <syscall>
  801c95:	83 c4 18             	add    $0x18,%esp
}
  801c98:	c9                   	leave  
  801c99:	c3                   	ret    

00801c9a <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801c9a:	55                   	push   %ebp
  801c9b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801c9d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ca0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca3:	6a 00                	push   $0x0
  801ca5:	6a 00                	push   $0x0
  801ca7:	6a 00                	push   $0x0
  801ca9:	52                   	push   %edx
  801caa:	50                   	push   %eax
  801cab:	6a 1e                	push   $0x1e
  801cad:	e8 c0 fc ff ff       	call   801972 <syscall>
  801cb2:	83 c4 18             	add    $0x18,%esp
}
  801cb5:	c9                   	leave  
  801cb6:	c3                   	ret    

00801cb7 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801cb7:	55                   	push   %ebp
  801cb8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801cba:	6a 00                	push   $0x0
  801cbc:	6a 00                	push   $0x0
  801cbe:	6a 00                	push   $0x0
  801cc0:	6a 00                	push   $0x0
  801cc2:	6a 00                	push   $0x0
  801cc4:	6a 1f                	push   $0x1f
  801cc6:	e8 a7 fc ff ff       	call   801972 <syscall>
  801ccb:	83 c4 18             	add    $0x18,%esp
}
  801cce:	c9                   	leave  
  801ccf:	c3                   	ret    

00801cd0 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801cd0:	55                   	push   %ebp
  801cd1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801cd3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd6:	6a 00                	push   $0x0
  801cd8:	ff 75 14             	pushl  0x14(%ebp)
  801cdb:	ff 75 10             	pushl  0x10(%ebp)
  801cde:	ff 75 0c             	pushl  0xc(%ebp)
  801ce1:	50                   	push   %eax
  801ce2:	6a 20                	push   $0x20
  801ce4:	e8 89 fc ff ff       	call   801972 <syscall>
  801ce9:	83 c4 18             	add    $0x18,%esp
}
  801cec:	c9                   	leave  
  801ced:	c3                   	ret    

00801cee <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801cee:	55                   	push   %ebp
  801cef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801cf1:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf4:	6a 00                	push   $0x0
  801cf6:	6a 00                	push   $0x0
  801cf8:	6a 00                	push   $0x0
  801cfa:	6a 00                	push   $0x0
  801cfc:	50                   	push   %eax
  801cfd:	6a 21                	push   $0x21
  801cff:	e8 6e fc ff ff       	call   801972 <syscall>
  801d04:	83 c4 18             	add    $0x18,%esp
}
  801d07:	90                   	nop
  801d08:	c9                   	leave  
  801d09:	c3                   	ret    

00801d0a <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801d0a:	55                   	push   %ebp
  801d0b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d10:	6a 00                	push   $0x0
  801d12:	6a 00                	push   $0x0
  801d14:	6a 00                	push   $0x0
  801d16:	6a 00                	push   $0x0
  801d18:	50                   	push   %eax
  801d19:	6a 22                	push   $0x22
  801d1b:	e8 52 fc ff ff       	call   801972 <syscall>
  801d20:	83 c4 18             	add    $0x18,%esp
}
  801d23:	c9                   	leave  
  801d24:	c3                   	ret    

00801d25 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801d25:	55                   	push   %ebp
  801d26:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801d28:	6a 00                	push   $0x0
  801d2a:	6a 00                	push   $0x0
  801d2c:	6a 00                	push   $0x0
  801d2e:	6a 00                	push   $0x0
  801d30:	6a 00                	push   $0x0
  801d32:	6a 02                	push   $0x2
  801d34:	e8 39 fc ff ff       	call   801972 <syscall>
  801d39:	83 c4 18             	add    $0x18,%esp
}
  801d3c:	c9                   	leave  
  801d3d:	c3                   	ret    

00801d3e <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801d3e:	55                   	push   %ebp
  801d3f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801d41:	6a 00                	push   $0x0
  801d43:	6a 00                	push   $0x0
  801d45:	6a 00                	push   $0x0
  801d47:	6a 00                	push   $0x0
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 03                	push   $0x3
  801d4d:	e8 20 fc ff ff       	call   801972 <syscall>
  801d52:	83 c4 18             	add    $0x18,%esp
}
  801d55:	c9                   	leave  
  801d56:	c3                   	ret    

00801d57 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801d57:	55                   	push   %ebp
  801d58:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801d5a:	6a 00                	push   $0x0
  801d5c:	6a 00                	push   $0x0
  801d5e:	6a 00                	push   $0x0
  801d60:	6a 00                	push   $0x0
  801d62:	6a 00                	push   $0x0
  801d64:	6a 04                	push   $0x4
  801d66:	e8 07 fc ff ff       	call   801972 <syscall>
  801d6b:	83 c4 18             	add    $0x18,%esp
}
  801d6e:	c9                   	leave  
  801d6f:	c3                   	ret    

00801d70 <sys_exit_env>:


void sys_exit_env(void)
{
  801d70:	55                   	push   %ebp
  801d71:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801d73:	6a 00                	push   $0x0
  801d75:	6a 00                	push   $0x0
  801d77:	6a 00                	push   $0x0
  801d79:	6a 00                	push   $0x0
  801d7b:	6a 00                	push   $0x0
  801d7d:	6a 23                	push   $0x23
  801d7f:	e8 ee fb ff ff       	call   801972 <syscall>
  801d84:	83 c4 18             	add    $0x18,%esp
}
  801d87:	90                   	nop
  801d88:	c9                   	leave  
  801d89:	c3                   	ret    

00801d8a <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801d8a:	55                   	push   %ebp
  801d8b:	89 e5                	mov    %esp,%ebp
  801d8d:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801d90:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d93:	8d 50 04             	lea    0x4(%eax),%edx
  801d96:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d99:	6a 00                	push   $0x0
  801d9b:	6a 00                	push   $0x0
  801d9d:	6a 00                	push   $0x0
  801d9f:	52                   	push   %edx
  801da0:	50                   	push   %eax
  801da1:	6a 24                	push   $0x24
  801da3:	e8 ca fb ff ff       	call   801972 <syscall>
  801da8:	83 c4 18             	add    $0x18,%esp
	return result;
  801dab:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801dae:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801db1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801db4:	89 01                	mov    %eax,(%ecx)
  801db6:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801db9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbc:	c9                   	leave  
  801dbd:	c2 04 00             	ret    $0x4

00801dc0 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801dc0:	55                   	push   %ebp
  801dc1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801dc3:	6a 00                	push   $0x0
  801dc5:	6a 00                	push   $0x0
  801dc7:	ff 75 10             	pushl  0x10(%ebp)
  801dca:	ff 75 0c             	pushl  0xc(%ebp)
  801dcd:	ff 75 08             	pushl  0x8(%ebp)
  801dd0:	6a 12                	push   $0x12
  801dd2:	e8 9b fb ff ff       	call   801972 <syscall>
  801dd7:	83 c4 18             	add    $0x18,%esp
	return ;
  801dda:	90                   	nop
}
  801ddb:	c9                   	leave  
  801ddc:	c3                   	ret    

00801ddd <sys_rcr2>:
uint32 sys_rcr2()
{
  801ddd:	55                   	push   %ebp
  801dde:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801de0:	6a 00                	push   $0x0
  801de2:	6a 00                	push   $0x0
  801de4:	6a 00                	push   $0x0
  801de6:	6a 00                	push   $0x0
  801de8:	6a 00                	push   $0x0
  801dea:	6a 25                	push   $0x25
  801dec:	e8 81 fb ff ff       	call   801972 <syscall>
  801df1:	83 c4 18             	add    $0x18,%esp
}
  801df4:	c9                   	leave  
  801df5:	c3                   	ret    

00801df6 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801df6:	55                   	push   %ebp
  801df7:	89 e5                	mov    %esp,%ebp
  801df9:	83 ec 04             	sub    $0x4,%esp
  801dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  801dff:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801e02:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801e06:	6a 00                	push   $0x0
  801e08:	6a 00                	push   $0x0
  801e0a:	6a 00                	push   $0x0
  801e0c:	6a 00                	push   $0x0
  801e0e:	50                   	push   %eax
  801e0f:	6a 26                	push   $0x26
  801e11:	e8 5c fb ff ff       	call   801972 <syscall>
  801e16:	83 c4 18             	add    $0x18,%esp
	return ;
  801e19:	90                   	nop
}
  801e1a:	c9                   	leave  
  801e1b:	c3                   	ret    

00801e1c <rsttst>:
void rsttst()
{
  801e1c:	55                   	push   %ebp
  801e1d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801e1f:	6a 00                	push   $0x0
  801e21:	6a 00                	push   $0x0
  801e23:	6a 00                	push   $0x0
  801e25:	6a 00                	push   $0x0
  801e27:	6a 00                	push   $0x0
  801e29:	6a 28                	push   $0x28
  801e2b:	e8 42 fb ff ff       	call   801972 <syscall>
  801e30:	83 c4 18             	add    $0x18,%esp
	return ;
  801e33:	90                   	nop
}
  801e34:	c9                   	leave  
  801e35:	c3                   	ret    

00801e36 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801e36:	55                   	push   %ebp
  801e37:	89 e5                	mov    %esp,%ebp
  801e39:	83 ec 04             	sub    $0x4,%esp
  801e3c:	8b 45 14             	mov    0x14(%ebp),%eax
  801e3f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801e42:	8b 55 18             	mov    0x18(%ebp),%edx
  801e45:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e49:	52                   	push   %edx
  801e4a:	50                   	push   %eax
  801e4b:	ff 75 10             	pushl  0x10(%ebp)
  801e4e:	ff 75 0c             	pushl  0xc(%ebp)
  801e51:	ff 75 08             	pushl  0x8(%ebp)
  801e54:	6a 27                	push   $0x27
  801e56:	e8 17 fb ff ff       	call   801972 <syscall>
  801e5b:	83 c4 18             	add    $0x18,%esp
	return ;
  801e5e:	90                   	nop
}
  801e5f:	c9                   	leave  
  801e60:	c3                   	ret    

00801e61 <chktst>:
void chktst(uint32 n)
{
  801e61:	55                   	push   %ebp
  801e62:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801e64:	6a 00                	push   $0x0
  801e66:	6a 00                	push   $0x0
  801e68:	6a 00                	push   $0x0
  801e6a:	6a 00                	push   $0x0
  801e6c:	ff 75 08             	pushl  0x8(%ebp)
  801e6f:	6a 29                	push   $0x29
  801e71:	e8 fc fa ff ff       	call   801972 <syscall>
  801e76:	83 c4 18             	add    $0x18,%esp
	return ;
  801e79:	90                   	nop
}
  801e7a:	c9                   	leave  
  801e7b:	c3                   	ret    

00801e7c <inctst>:

void inctst()
{
  801e7c:	55                   	push   %ebp
  801e7d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801e7f:	6a 00                	push   $0x0
  801e81:	6a 00                	push   $0x0
  801e83:	6a 00                	push   $0x0
  801e85:	6a 00                	push   $0x0
  801e87:	6a 00                	push   $0x0
  801e89:	6a 2a                	push   $0x2a
  801e8b:	e8 e2 fa ff ff       	call   801972 <syscall>
  801e90:	83 c4 18             	add    $0x18,%esp
	return ;
  801e93:	90                   	nop
}
  801e94:	c9                   	leave  
  801e95:	c3                   	ret    

00801e96 <gettst>:
uint32 gettst()
{
  801e96:	55                   	push   %ebp
  801e97:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801e99:	6a 00                	push   $0x0
  801e9b:	6a 00                	push   $0x0
  801e9d:	6a 00                	push   $0x0
  801e9f:	6a 00                	push   $0x0
  801ea1:	6a 00                	push   $0x0
  801ea3:	6a 2b                	push   $0x2b
  801ea5:	e8 c8 fa ff ff       	call   801972 <syscall>
  801eaa:	83 c4 18             	add    $0x18,%esp
}
  801ead:	c9                   	leave  
  801eae:	c3                   	ret    

00801eaf <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801eaf:	55                   	push   %ebp
  801eb0:	89 e5                	mov    %esp,%ebp
  801eb2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801eb5:	6a 00                	push   $0x0
  801eb7:	6a 00                	push   $0x0
  801eb9:	6a 00                	push   $0x0
  801ebb:	6a 00                	push   $0x0
  801ebd:	6a 00                	push   $0x0
  801ebf:	6a 2c                	push   $0x2c
  801ec1:	e8 ac fa ff ff       	call   801972 <syscall>
  801ec6:	83 c4 18             	add    $0x18,%esp
  801ec9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801ecc:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801ed0:	75 07                	jne    801ed9 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801ed2:	b8 01 00 00 00       	mov    $0x1,%eax
  801ed7:	eb 05                	jmp    801ede <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801ed9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ede:	c9                   	leave  
  801edf:	c3                   	ret    

00801ee0 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801ee0:	55                   	push   %ebp
  801ee1:	89 e5                	mov    %esp,%ebp
  801ee3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ee6:	6a 00                	push   $0x0
  801ee8:	6a 00                	push   $0x0
  801eea:	6a 00                	push   $0x0
  801eec:	6a 00                	push   $0x0
  801eee:	6a 00                	push   $0x0
  801ef0:	6a 2c                	push   $0x2c
  801ef2:	e8 7b fa ff ff       	call   801972 <syscall>
  801ef7:	83 c4 18             	add    $0x18,%esp
  801efa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801efd:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801f01:	75 07                	jne    801f0a <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801f03:	b8 01 00 00 00       	mov    $0x1,%eax
  801f08:	eb 05                	jmp    801f0f <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801f0a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f0f:	c9                   	leave  
  801f10:	c3                   	ret    

00801f11 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801f11:	55                   	push   %ebp
  801f12:	89 e5                	mov    %esp,%ebp
  801f14:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f17:	6a 00                	push   $0x0
  801f19:	6a 00                	push   $0x0
  801f1b:	6a 00                	push   $0x0
  801f1d:	6a 00                	push   $0x0
  801f1f:	6a 00                	push   $0x0
  801f21:	6a 2c                	push   $0x2c
  801f23:	e8 4a fa ff ff       	call   801972 <syscall>
  801f28:	83 c4 18             	add    $0x18,%esp
  801f2b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801f2e:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801f32:	75 07                	jne    801f3b <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801f34:	b8 01 00 00 00       	mov    $0x1,%eax
  801f39:	eb 05                	jmp    801f40 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801f3b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f40:	c9                   	leave  
  801f41:	c3                   	ret    

00801f42 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801f42:	55                   	push   %ebp
  801f43:	89 e5                	mov    %esp,%ebp
  801f45:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f48:	6a 00                	push   $0x0
  801f4a:	6a 00                	push   $0x0
  801f4c:	6a 00                	push   $0x0
  801f4e:	6a 00                	push   $0x0
  801f50:	6a 00                	push   $0x0
  801f52:	6a 2c                	push   $0x2c
  801f54:	e8 19 fa ff ff       	call   801972 <syscall>
  801f59:	83 c4 18             	add    $0x18,%esp
  801f5c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801f5f:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801f63:	75 07                	jne    801f6c <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801f65:	b8 01 00 00 00       	mov    $0x1,%eax
  801f6a:	eb 05                	jmp    801f71 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801f6c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f71:	c9                   	leave  
  801f72:	c3                   	ret    

00801f73 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801f73:	55                   	push   %ebp
  801f74:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801f76:	6a 00                	push   $0x0
  801f78:	6a 00                	push   $0x0
  801f7a:	6a 00                	push   $0x0
  801f7c:	6a 00                	push   $0x0
  801f7e:	ff 75 08             	pushl  0x8(%ebp)
  801f81:	6a 2d                	push   $0x2d
  801f83:	e8 ea f9 ff ff       	call   801972 <syscall>
  801f88:	83 c4 18             	add    $0x18,%esp
	return ;
  801f8b:	90                   	nop
}
  801f8c:	c9                   	leave  
  801f8d:	c3                   	ret    

00801f8e <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801f8e:	55                   	push   %ebp
  801f8f:	89 e5                	mov    %esp,%ebp
  801f91:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801f92:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f95:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f98:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9e:	6a 00                	push   $0x0
  801fa0:	53                   	push   %ebx
  801fa1:	51                   	push   %ecx
  801fa2:	52                   	push   %edx
  801fa3:	50                   	push   %eax
  801fa4:	6a 2e                	push   $0x2e
  801fa6:	e8 c7 f9 ff ff       	call   801972 <syscall>
  801fab:	83 c4 18             	add    $0x18,%esp
}
  801fae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fb1:	c9                   	leave  
  801fb2:	c3                   	ret    

00801fb3 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801fb3:	55                   	push   %ebp
  801fb4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801fb6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fb9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fbc:	6a 00                	push   $0x0
  801fbe:	6a 00                	push   $0x0
  801fc0:	6a 00                	push   $0x0
  801fc2:	52                   	push   %edx
  801fc3:	50                   	push   %eax
  801fc4:	6a 2f                	push   $0x2f
  801fc6:	e8 a7 f9 ff ff       	call   801972 <syscall>
  801fcb:	83 c4 18             	add    $0x18,%esp
}
  801fce:	c9                   	leave  
  801fcf:	c3                   	ret    

00801fd0 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801fd0:	55                   	push   %ebp
  801fd1:	89 e5                	mov    %esp,%ebp
  801fd3:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801fd6:	83 ec 0c             	sub    $0xc,%esp
  801fd9:	68 64 42 80 00       	push   $0x804264
  801fde:	e8 8c e7 ff ff       	call   80076f <cprintf>
  801fe3:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801fe6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801fed:	83 ec 0c             	sub    $0xc,%esp
  801ff0:	68 90 42 80 00       	push   $0x804290
  801ff5:	e8 75 e7 ff ff       	call   80076f <cprintf>
  801ffa:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801ffd:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802001:	a1 38 51 80 00       	mov    0x805138,%eax
  802006:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802009:	eb 56                	jmp    802061 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80200b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80200f:	74 1c                	je     80202d <print_mem_block_lists+0x5d>
  802011:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802014:	8b 50 08             	mov    0x8(%eax),%edx
  802017:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80201a:	8b 48 08             	mov    0x8(%eax),%ecx
  80201d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802020:	8b 40 0c             	mov    0xc(%eax),%eax
  802023:	01 c8                	add    %ecx,%eax
  802025:	39 c2                	cmp    %eax,%edx
  802027:	73 04                	jae    80202d <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802029:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80202d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802030:	8b 50 08             	mov    0x8(%eax),%edx
  802033:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802036:	8b 40 0c             	mov    0xc(%eax),%eax
  802039:	01 c2                	add    %eax,%edx
  80203b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80203e:	8b 40 08             	mov    0x8(%eax),%eax
  802041:	83 ec 04             	sub    $0x4,%esp
  802044:	52                   	push   %edx
  802045:	50                   	push   %eax
  802046:	68 a5 42 80 00       	push   $0x8042a5
  80204b:	e8 1f e7 ff ff       	call   80076f <cprintf>
  802050:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802053:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802056:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802059:	a1 40 51 80 00       	mov    0x805140,%eax
  80205e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802061:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802065:	74 07                	je     80206e <print_mem_block_lists+0x9e>
  802067:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80206a:	8b 00                	mov    (%eax),%eax
  80206c:	eb 05                	jmp    802073 <print_mem_block_lists+0xa3>
  80206e:	b8 00 00 00 00       	mov    $0x0,%eax
  802073:	a3 40 51 80 00       	mov    %eax,0x805140
  802078:	a1 40 51 80 00       	mov    0x805140,%eax
  80207d:	85 c0                	test   %eax,%eax
  80207f:	75 8a                	jne    80200b <print_mem_block_lists+0x3b>
  802081:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802085:	75 84                	jne    80200b <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802087:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80208b:	75 10                	jne    80209d <print_mem_block_lists+0xcd>
  80208d:	83 ec 0c             	sub    $0xc,%esp
  802090:	68 b4 42 80 00       	push   $0x8042b4
  802095:	e8 d5 e6 ff ff       	call   80076f <cprintf>
  80209a:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80209d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8020a4:	83 ec 0c             	sub    $0xc,%esp
  8020a7:	68 d8 42 80 00       	push   $0x8042d8
  8020ac:	e8 be e6 ff ff       	call   80076f <cprintf>
  8020b1:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8020b4:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8020b8:	a1 40 50 80 00       	mov    0x805040,%eax
  8020bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020c0:	eb 56                	jmp    802118 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8020c2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020c6:	74 1c                	je     8020e4 <print_mem_block_lists+0x114>
  8020c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020cb:	8b 50 08             	mov    0x8(%eax),%edx
  8020ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020d1:	8b 48 08             	mov    0x8(%eax),%ecx
  8020d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020d7:	8b 40 0c             	mov    0xc(%eax),%eax
  8020da:	01 c8                	add    %ecx,%eax
  8020dc:	39 c2                	cmp    %eax,%edx
  8020de:	73 04                	jae    8020e4 <print_mem_block_lists+0x114>
			sorted = 0 ;
  8020e0:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8020e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e7:	8b 50 08             	mov    0x8(%eax),%edx
  8020ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ed:	8b 40 0c             	mov    0xc(%eax),%eax
  8020f0:	01 c2                	add    %eax,%edx
  8020f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f5:	8b 40 08             	mov    0x8(%eax),%eax
  8020f8:	83 ec 04             	sub    $0x4,%esp
  8020fb:	52                   	push   %edx
  8020fc:	50                   	push   %eax
  8020fd:	68 a5 42 80 00       	push   $0x8042a5
  802102:	e8 68 e6 ff ff       	call   80076f <cprintf>
  802107:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80210a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80210d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802110:	a1 48 50 80 00       	mov    0x805048,%eax
  802115:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802118:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80211c:	74 07                	je     802125 <print_mem_block_lists+0x155>
  80211e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802121:	8b 00                	mov    (%eax),%eax
  802123:	eb 05                	jmp    80212a <print_mem_block_lists+0x15a>
  802125:	b8 00 00 00 00       	mov    $0x0,%eax
  80212a:	a3 48 50 80 00       	mov    %eax,0x805048
  80212f:	a1 48 50 80 00       	mov    0x805048,%eax
  802134:	85 c0                	test   %eax,%eax
  802136:	75 8a                	jne    8020c2 <print_mem_block_lists+0xf2>
  802138:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80213c:	75 84                	jne    8020c2 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80213e:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802142:	75 10                	jne    802154 <print_mem_block_lists+0x184>
  802144:	83 ec 0c             	sub    $0xc,%esp
  802147:	68 f0 42 80 00       	push   $0x8042f0
  80214c:	e8 1e e6 ff ff       	call   80076f <cprintf>
  802151:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802154:	83 ec 0c             	sub    $0xc,%esp
  802157:	68 64 42 80 00       	push   $0x804264
  80215c:	e8 0e e6 ff ff       	call   80076f <cprintf>
  802161:	83 c4 10             	add    $0x10,%esp

}
  802164:	90                   	nop
  802165:	c9                   	leave  
  802166:	c3                   	ret    

00802167 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802167:	55                   	push   %ebp
  802168:	89 e5                	mov    %esp,%ebp
  80216a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  80216d:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802174:	00 00 00 
  802177:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80217e:	00 00 00 
  802181:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802188:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  80218b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802192:	e9 9e 00 00 00       	jmp    802235 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802197:	a1 50 50 80 00       	mov    0x805050,%eax
  80219c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80219f:	c1 e2 04             	shl    $0x4,%edx
  8021a2:	01 d0                	add    %edx,%eax
  8021a4:	85 c0                	test   %eax,%eax
  8021a6:	75 14                	jne    8021bc <initialize_MemBlocksList+0x55>
  8021a8:	83 ec 04             	sub    $0x4,%esp
  8021ab:	68 18 43 80 00       	push   $0x804318
  8021b0:	6a 46                	push   $0x46
  8021b2:	68 3b 43 80 00       	push   $0x80433b
  8021b7:	e8 ff e2 ff ff       	call   8004bb <_panic>
  8021bc:	a1 50 50 80 00       	mov    0x805050,%eax
  8021c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021c4:	c1 e2 04             	shl    $0x4,%edx
  8021c7:	01 d0                	add    %edx,%eax
  8021c9:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8021cf:	89 10                	mov    %edx,(%eax)
  8021d1:	8b 00                	mov    (%eax),%eax
  8021d3:	85 c0                	test   %eax,%eax
  8021d5:	74 18                	je     8021ef <initialize_MemBlocksList+0x88>
  8021d7:	a1 48 51 80 00       	mov    0x805148,%eax
  8021dc:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8021e2:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8021e5:	c1 e1 04             	shl    $0x4,%ecx
  8021e8:	01 ca                	add    %ecx,%edx
  8021ea:	89 50 04             	mov    %edx,0x4(%eax)
  8021ed:	eb 12                	jmp    802201 <initialize_MemBlocksList+0x9a>
  8021ef:	a1 50 50 80 00       	mov    0x805050,%eax
  8021f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021f7:	c1 e2 04             	shl    $0x4,%edx
  8021fa:	01 d0                	add    %edx,%eax
  8021fc:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802201:	a1 50 50 80 00       	mov    0x805050,%eax
  802206:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802209:	c1 e2 04             	shl    $0x4,%edx
  80220c:	01 d0                	add    %edx,%eax
  80220e:	a3 48 51 80 00       	mov    %eax,0x805148
  802213:	a1 50 50 80 00       	mov    0x805050,%eax
  802218:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80221b:	c1 e2 04             	shl    $0x4,%edx
  80221e:	01 d0                	add    %edx,%eax
  802220:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802227:	a1 54 51 80 00       	mov    0x805154,%eax
  80222c:	40                   	inc    %eax
  80222d:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802232:	ff 45 f4             	incl   -0xc(%ebp)
  802235:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802238:	3b 45 08             	cmp    0x8(%ebp),%eax
  80223b:	0f 82 56 ff ff ff    	jb     802197 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802241:	90                   	nop
  802242:	c9                   	leave  
  802243:	c3                   	ret    

00802244 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802244:	55                   	push   %ebp
  802245:	89 e5                	mov    %esp,%ebp
  802247:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80224a:	8b 45 08             	mov    0x8(%ebp),%eax
  80224d:	8b 00                	mov    (%eax),%eax
  80224f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802252:	eb 19                	jmp    80226d <find_block+0x29>
	{
		if(va==point->sva)
  802254:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802257:	8b 40 08             	mov    0x8(%eax),%eax
  80225a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80225d:	75 05                	jne    802264 <find_block+0x20>
		   return point;
  80225f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802262:	eb 36                	jmp    80229a <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802264:	8b 45 08             	mov    0x8(%ebp),%eax
  802267:	8b 40 08             	mov    0x8(%eax),%eax
  80226a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80226d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802271:	74 07                	je     80227a <find_block+0x36>
  802273:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802276:	8b 00                	mov    (%eax),%eax
  802278:	eb 05                	jmp    80227f <find_block+0x3b>
  80227a:	b8 00 00 00 00       	mov    $0x0,%eax
  80227f:	8b 55 08             	mov    0x8(%ebp),%edx
  802282:	89 42 08             	mov    %eax,0x8(%edx)
  802285:	8b 45 08             	mov    0x8(%ebp),%eax
  802288:	8b 40 08             	mov    0x8(%eax),%eax
  80228b:	85 c0                	test   %eax,%eax
  80228d:	75 c5                	jne    802254 <find_block+0x10>
  80228f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802293:	75 bf                	jne    802254 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802295:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80229a:	c9                   	leave  
  80229b:	c3                   	ret    

0080229c <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80229c:	55                   	push   %ebp
  80229d:	89 e5                	mov    %esp,%ebp
  80229f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  8022a2:	a1 40 50 80 00       	mov    0x805040,%eax
  8022a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  8022aa:	a1 44 50 80 00       	mov    0x805044,%eax
  8022af:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8022b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022b5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8022b8:	74 24                	je     8022de <insert_sorted_allocList+0x42>
  8022ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bd:	8b 50 08             	mov    0x8(%eax),%edx
  8022c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022c3:	8b 40 08             	mov    0x8(%eax),%eax
  8022c6:	39 c2                	cmp    %eax,%edx
  8022c8:	76 14                	jbe    8022de <insert_sorted_allocList+0x42>
  8022ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8022cd:	8b 50 08             	mov    0x8(%eax),%edx
  8022d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022d3:	8b 40 08             	mov    0x8(%eax),%eax
  8022d6:	39 c2                	cmp    %eax,%edx
  8022d8:	0f 82 60 01 00 00    	jb     80243e <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8022de:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022e2:	75 65                	jne    802349 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8022e4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022e8:	75 14                	jne    8022fe <insert_sorted_allocList+0x62>
  8022ea:	83 ec 04             	sub    $0x4,%esp
  8022ed:	68 18 43 80 00       	push   $0x804318
  8022f2:	6a 6b                	push   $0x6b
  8022f4:	68 3b 43 80 00       	push   $0x80433b
  8022f9:	e8 bd e1 ff ff       	call   8004bb <_panic>
  8022fe:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802304:	8b 45 08             	mov    0x8(%ebp),%eax
  802307:	89 10                	mov    %edx,(%eax)
  802309:	8b 45 08             	mov    0x8(%ebp),%eax
  80230c:	8b 00                	mov    (%eax),%eax
  80230e:	85 c0                	test   %eax,%eax
  802310:	74 0d                	je     80231f <insert_sorted_allocList+0x83>
  802312:	a1 40 50 80 00       	mov    0x805040,%eax
  802317:	8b 55 08             	mov    0x8(%ebp),%edx
  80231a:	89 50 04             	mov    %edx,0x4(%eax)
  80231d:	eb 08                	jmp    802327 <insert_sorted_allocList+0x8b>
  80231f:	8b 45 08             	mov    0x8(%ebp),%eax
  802322:	a3 44 50 80 00       	mov    %eax,0x805044
  802327:	8b 45 08             	mov    0x8(%ebp),%eax
  80232a:	a3 40 50 80 00       	mov    %eax,0x805040
  80232f:	8b 45 08             	mov    0x8(%ebp),%eax
  802332:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802339:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80233e:	40                   	inc    %eax
  80233f:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802344:	e9 dc 01 00 00       	jmp    802525 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802349:	8b 45 08             	mov    0x8(%ebp),%eax
  80234c:	8b 50 08             	mov    0x8(%eax),%edx
  80234f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802352:	8b 40 08             	mov    0x8(%eax),%eax
  802355:	39 c2                	cmp    %eax,%edx
  802357:	77 6c                	ja     8023c5 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802359:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80235d:	74 06                	je     802365 <insert_sorted_allocList+0xc9>
  80235f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802363:	75 14                	jne    802379 <insert_sorted_allocList+0xdd>
  802365:	83 ec 04             	sub    $0x4,%esp
  802368:	68 54 43 80 00       	push   $0x804354
  80236d:	6a 6f                	push   $0x6f
  80236f:	68 3b 43 80 00       	push   $0x80433b
  802374:	e8 42 e1 ff ff       	call   8004bb <_panic>
  802379:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80237c:	8b 50 04             	mov    0x4(%eax),%edx
  80237f:	8b 45 08             	mov    0x8(%ebp),%eax
  802382:	89 50 04             	mov    %edx,0x4(%eax)
  802385:	8b 45 08             	mov    0x8(%ebp),%eax
  802388:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80238b:	89 10                	mov    %edx,(%eax)
  80238d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802390:	8b 40 04             	mov    0x4(%eax),%eax
  802393:	85 c0                	test   %eax,%eax
  802395:	74 0d                	je     8023a4 <insert_sorted_allocList+0x108>
  802397:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80239a:	8b 40 04             	mov    0x4(%eax),%eax
  80239d:	8b 55 08             	mov    0x8(%ebp),%edx
  8023a0:	89 10                	mov    %edx,(%eax)
  8023a2:	eb 08                	jmp    8023ac <insert_sorted_allocList+0x110>
  8023a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a7:	a3 40 50 80 00       	mov    %eax,0x805040
  8023ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023af:	8b 55 08             	mov    0x8(%ebp),%edx
  8023b2:	89 50 04             	mov    %edx,0x4(%eax)
  8023b5:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8023ba:	40                   	inc    %eax
  8023bb:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8023c0:	e9 60 01 00 00       	jmp    802525 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8023c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c8:	8b 50 08             	mov    0x8(%eax),%edx
  8023cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023ce:	8b 40 08             	mov    0x8(%eax),%eax
  8023d1:	39 c2                	cmp    %eax,%edx
  8023d3:	0f 82 4c 01 00 00    	jb     802525 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8023d9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023dd:	75 14                	jne    8023f3 <insert_sorted_allocList+0x157>
  8023df:	83 ec 04             	sub    $0x4,%esp
  8023e2:	68 8c 43 80 00       	push   $0x80438c
  8023e7:	6a 73                	push   $0x73
  8023e9:	68 3b 43 80 00       	push   $0x80433b
  8023ee:	e8 c8 e0 ff ff       	call   8004bb <_panic>
  8023f3:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8023f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fc:	89 50 04             	mov    %edx,0x4(%eax)
  8023ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802402:	8b 40 04             	mov    0x4(%eax),%eax
  802405:	85 c0                	test   %eax,%eax
  802407:	74 0c                	je     802415 <insert_sorted_allocList+0x179>
  802409:	a1 44 50 80 00       	mov    0x805044,%eax
  80240e:	8b 55 08             	mov    0x8(%ebp),%edx
  802411:	89 10                	mov    %edx,(%eax)
  802413:	eb 08                	jmp    80241d <insert_sorted_allocList+0x181>
  802415:	8b 45 08             	mov    0x8(%ebp),%eax
  802418:	a3 40 50 80 00       	mov    %eax,0x805040
  80241d:	8b 45 08             	mov    0x8(%ebp),%eax
  802420:	a3 44 50 80 00       	mov    %eax,0x805044
  802425:	8b 45 08             	mov    0x8(%ebp),%eax
  802428:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80242e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802433:	40                   	inc    %eax
  802434:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802439:	e9 e7 00 00 00       	jmp    802525 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  80243e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802441:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802444:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80244b:	a1 40 50 80 00       	mov    0x805040,%eax
  802450:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802453:	e9 9d 00 00 00       	jmp    8024f5 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802458:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245b:	8b 00                	mov    (%eax),%eax
  80245d:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802460:	8b 45 08             	mov    0x8(%ebp),%eax
  802463:	8b 50 08             	mov    0x8(%eax),%edx
  802466:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802469:	8b 40 08             	mov    0x8(%eax),%eax
  80246c:	39 c2                	cmp    %eax,%edx
  80246e:	76 7d                	jbe    8024ed <insert_sorted_allocList+0x251>
  802470:	8b 45 08             	mov    0x8(%ebp),%eax
  802473:	8b 50 08             	mov    0x8(%eax),%edx
  802476:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802479:	8b 40 08             	mov    0x8(%eax),%eax
  80247c:	39 c2                	cmp    %eax,%edx
  80247e:	73 6d                	jae    8024ed <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802480:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802484:	74 06                	je     80248c <insert_sorted_allocList+0x1f0>
  802486:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80248a:	75 14                	jne    8024a0 <insert_sorted_allocList+0x204>
  80248c:	83 ec 04             	sub    $0x4,%esp
  80248f:	68 b0 43 80 00       	push   $0x8043b0
  802494:	6a 7f                	push   $0x7f
  802496:	68 3b 43 80 00       	push   $0x80433b
  80249b:	e8 1b e0 ff ff       	call   8004bb <_panic>
  8024a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a3:	8b 10                	mov    (%eax),%edx
  8024a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a8:	89 10                	mov    %edx,(%eax)
  8024aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ad:	8b 00                	mov    (%eax),%eax
  8024af:	85 c0                	test   %eax,%eax
  8024b1:	74 0b                	je     8024be <insert_sorted_allocList+0x222>
  8024b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b6:	8b 00                	mov    (%eax),%eax
  8024b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8024bb:	89 50 04             	mov    %edx,0x4(%eax)
  8024be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8024c4:	89 10                	mov    %edx,(%eax)
  8024c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024cc:	89 50 04             	mov    %edx,0x4(%eax)
  8024cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d2:	8b 00                	mov    (%eax),%eax
  8024d4:	85 c0                	test   %eax,%eax
  8024d6:	75 08                	jne    8024e0 <insert_sorted_allocList+0x244>
  8024d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8024db:	a3 44 50 80 00       	mov    %eax,0x805044
  8024e0:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8024e5:	40                   	inc    %eax
  8024e6:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8024eb:	eb 39                	jmp    802526 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8024ed:	a1 48 50 80 00       	mov    0x805048,%eax
  8024f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024f9:	74 07                	je     802502 <insert_sorted_allocList+0x266>
  8024fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fe:	8b 00                	mov    (%eax),%eax
  802500:	eb 05                	jmp    802507 <insert_sorted_allocList+0x26b>
  802502:	b8 00 00 00 00       	mov    $0x0,%eax
  802507:	a3 48 50 80 00       	mov    %eax,0x805048
  80250c:	a1 48 50 80 00       	mov    0x805048,%eax
  802511:	85 c0                	test   %eax,%eax
  802513:	0f 85 3f ff ff ff    	jne    802458 <insert_sorted_allocList+0x1bc>
  802519:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80251d:	0f 85 35 ff ff ff    	jne    802458 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802523:	eb 01                	jmp    802526 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802525:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802526:	90                   	nop
  802527:	c9                   	leave  
  802528:	c3                   	ret    

00802529 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802529:	55                   	push   %ebp
  80252a:	89 e5                	mov    %esp,%ebp
  80252c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80252f:	a1 38 51 80 00       	mov    0x805138,%eax
  802534:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802537:	e9 85 01 00 00       	jmp    8026c1 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  80253c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253f:	8b 40 0c             	mov    0xc(%eax),%eax
  802542:	3b 45 08             	cmp    0x8(%ebp),%eax
  802545:	0f 82 6e 01 00 00    	jb     8026b9 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  80254b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254e:	8b 40 0c             	mov    0xc(%eax),%eax
  802551:	3b 45 08             	cmp    0x8(%ebp),%eax
  802554:	0f 85 8a 00 00 00    	jne    8025e4 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  80255a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80255e:	75 17                	jne    802577 <alloc_block_FF+0x4e>
  802560:	83 ec 04             	sub    $0x4,%esp
  802563:	68 e4 43 80 00       	push   $0x8043e4
  802568:	68 93 00 00 00       	push   $0x93
  80256d:	68 3b 43 80 00       	push   $0x80433b
  802572:	e8 44 df ff ff       	call   8004bb <_panic>
  802577:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257a:	8b 00                	mov    (%eax),%eax
  80257c:	85 c0                	test   %eax,%eax
  80257e:	74 10                	je     802590 <alloc_block_FF+0x67>
  802580:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802583:	8b 00                	mov    (%eax),%eax
  802585:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802588:	8b 52 04             	mov    0x4(%edx),%edx
  80258b:	89 50 04             	mov    %edx,0x4(%eax)
  80258e:	eb 0b                	jmp    80259b <alloc_block_FF+0x72>
  802590:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802593:	8b 40 04             	mov    0x4(%eax),%eax
  802596:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80259b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259e:	8b 40 04             	mov    0x4(%eax),%eax
  8025a1:	85 c0                	test   %eax,%eax
  8025a3:	74 0f                	je     8025b4 <alloc_block_FF+0x8b>
  8025a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a8:	8b 40 04             	mov    0x4(%eax),%eax
  8025ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025ae:	8b 12                	mov    (%edx),%edx
  8025b0:	89 10                	mov    %edx,(%eax)
  8025b2:	eb 0a                	jmp    8025be <alloc_block_FF+0x95>
  8025b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b7:	8b 00                	mov    (%eax),%eax
  8025b9:	a3 38 51 80 00       	mov    %eax,0x805138
  8025be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ca:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025d1:	a1 44 51 80 00       	mov    0x805144,%eax
  8025d6:	48                   	dec    %eax
  8025d7:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  8025dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025df:	e9 10 01 00 00       	jmp    8026f4 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8025e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e7:	8b 40 0c             	mov    0xc(%eax),%eax
  8025ea:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025ed:	0f 86 c6 00 00 00    	jbe    8026b9 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8025f3:	a1 48 51 80 00       	mov    0x805148,%eax
  8025f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8025fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fe:	8b 50 08             	mov    0x8(%eax),%edx
  802601:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802604:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802607:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80260a:	8b 55 08             	mov    0x8(%ebp),%edx
  80260d:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802610:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802614:	75 17                	jne    80262d <alloc_block_FF+0x104>
  802616:	83 ec 04             	sub    $0x4,%esp
  802619:	68 e4 43 80 00       	push   $0x8043e4
  80261e:	68 9b 00 00 00       	push   $0x9b
  802623:	68 3b 43 80 00       	push   $0x80433b
  802628:	e8 8e de ff ff       	call   8004bb <_panic>
  80262d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802630:	8b 00                	mov    (%eax),%eax
  802632:	85 c0                	test   %eax,%eax
  802634:	74 10                	je     802646 <alloc_block_FF+0x11d>
  802636:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802639:	8b 00                	mov    (%eax),%eax
  80263b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80263e:	8b 52 04             	mov    0x4(%edx),%edx
  802641:	89 50 04             	mov    %edx,0x4(%eax)
  802644:	eb 0b                	jmp    802651 <alloc_block_FF+0x128>
  802646:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802649:	8b 40 04             	mov    0x4(%eax),%eax
  80264c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802651:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802654:	8b 40 04             	mov    0x4(%eax),%eax
  802657:	85 c0                	test   %eax,%eax
  802659:	74 0f                	je     80266a <alloc_block_FF+0x141>
  80265b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80265e:	8b 40 04             	mov    0x4(%eax),%eax
  802661:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802664:	8b 12                	mov    (%edx),%edx
  802666:	89 10                	mov    %edx,(%eax)
  802668:	eb 0a                	jmp    802674 <alloc_block_FF+0x14b>
  80266a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80266d:	8b 00                	mov    (%eax),%eax
  80266f:	a3 48 51 80 00       	mov    %eax,0x805148
  802674:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802677:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80267d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802680:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802687:	a1 54 51 80 00       	mov    0x805154,%eax
  80268c:	48                   	dec    %eax
  80268d:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802692:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802695:	8b 50 08             	mov    0x8(%eax),%edx
  802698:	8b 45 08             	mov    0x8(%ebp),%eax
  80269b:	01 c2                	add    %eax,%edx
  80269d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a0:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8026a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a6:	8b 40 0c             	mov    0xc(%eax),%eax
  8026a9:	2b 45 08             	sub    0x8(%ebp),%eax
  8026ac:	89 c2                	mov    %eax,%edx
  8026ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b1:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8026b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026b7:	eb 3b                	jmp    8026f4 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8026b9:	a1 40 51 80 00       	mov    0x805140,%eax
  8026be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026c5:	74 07                	je     8026ce <alloc_block_FF+0x1a5>
  8026c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ca:	8b 00                	mov    (%eax),%eax
  8026cc:	eb 05                	jmp    8026d3 <alloc_block_FF+0x1aa>
  8026ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8026d3:	a3 40 51 80 00       	mov    %eax,0x805140
  8026d8:	a1 40 51 80 00       	mov    0x805140,%eax
  8026dd:	85 c0                	test   %eax,%eax
  8026df:	0f 85 57 fe ff ff    	jne    80253c <alloc_block_FF+0x13>
  8026e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026e9:	0f 85 4d fe ff ff    	jne    80253c <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8026ef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026f4:	c9                   	leave  
  8026f5:	c3                   	ret    

008026f6 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8026f6:	55                   	push   %ebp
  8026f7:	89 e5                	mov    %esp,%ebp
  8026f9:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8026fc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802703:	a1 38 51 80 00       	mov    0x805138,%eax
  802708:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80270b:	e9 df 00 00 00       	jmp    8027ef <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802710:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802713:	8b 40 0c             	mov    0xc(%eax),%eax
  802716:	3b 45 08             	cmp    0x8(%ebp),%eax
  802719:	0f 82 c8 00 00 00    	jb     8027e7 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  80271f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802722:	8b 40 0c             	mov    0xc(%eax),%eax
  802725:	3b 45 08             	cmp    0x8(%ebp),%eax
  802728:	0f 85 8a 00 00 00    	jne    8027b8 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  80272e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802732:	75 17                	jne    80274b <alloc_block_BF+0x55>
  802734:	83 ec 04             	sub    $0x4,%esp
  802737:	68 e4 43 80 00       	push   $0x8043e4
  80273c:	68 b7 00 00 00       	push   $0xb7
  802741:	68 3b 43 80 00       	push   $0x80433b
  802746:	e8 70 dd ff ff       	call   8004bb <_panic>
  80274b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274e:	8b 00                	mov    (%eax),%eax
  802750:	85 c0                	test   %eax,%eax
  802752:	74 10                	je     802764 <alloc_block_BF+0x6e>
  802754:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802757:	8b 00                	mov    (%eax),%eax
  802759:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80275c:	8b 52 04             	mov    0x4(%edx),%edx
  80275f:	89 50 04             	mov    %edx,0x4(%eax)
  802762:	eb 0b                	jmp    80276f <alloc_block_BF+0x79>
  802764:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802767:	8b 40 04             	mov    0x4(%eax),%eax
  80276a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80276f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802772:	8b 40 04             	mov    0x4(%eax),%eax
  802775:	85 c0                	test   %eax,%eax
  802777:	74 0f                	je     802788 <alloc_block_BF+0x92>
  802779:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277c:	8b 40 04             	mov    0x4(%eax),%eax
  80277f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802782:	8b 12                	mov    (%edx),%edx
  802784:	89 10                	mov    %edx,(%eax)
  802786:	eb 0a                	jmp    802792 <alloc_block_BF+0x9c>
  802788:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278b:	8b 00                	mov    (%eax),%eax
  80278d:	a3 38 51 80 00       	mov    %eax,0x805138
  802792:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802795:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80279b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027a5:	a1 44 51 80 00       	mov    0x805144,%eax
  8027aa:	48                   	dec    %eax
  8027ab:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  8027b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b3:	e9 4d 01 00 00       	jmp    802905 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8027b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027bb:	8b 40 0c             	mov    0xc(%eax),%eax
  8027be:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027c1:	76 24                	jbe    8027e7 <alloc_block_BF+0xf1>
  8027c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c6:	8b 40 0c             	mov    0xc(%eax),%eax
  8027c9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8027cc:	73 19                	jae    8027e7 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8027ce:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8027d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d8:	8b 40 0c             	mov    0xc(%eax),%eax
  8027db:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8027de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e1:	8b 40 08             	mov    0x8(%eax),%eax
  8027e4:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8027e7:	a1 40 51 80 00       	mov    0x805140,%eax
  8027ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027f3:	74 07                	je     8027fc <alloc_block_BF+0x106>
  8027f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f8:	8b 00                	mov    (%eax),%eax
  8027fa:	eb 05                	jmp    802801 <alloc_block_BF+0x10b>
  8027fc:	b8 00 00 00 00       	mov    $0x0,%eax
  802801:	a3 40 51 80 00       	mov    %eax,0x805140
  802806:	a1 40 51 80 00       	mov    0x805140,%eax
  80280b:	85 c0                	test   %eax,%eax
  80280d:	0f 85 fd fe ff ff    	jne    802710 <alloc_block_BF+0x1a>
  802813:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802817:	0f 85 f3 fe ff ff    	jne    802710 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  80281d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802821:	0f 84 d9 00 00 00    	je     802900 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802827:	a1 48 51 80 00       	mov    0x805148,%eax
  80282c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  80282f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802832:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802835:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802838:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80283b:	8b 55 08             	mov    0x8(%ebp),%edx
  80283e:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802841:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802845:	75 17                	jne    80285e <alloc_block_BF+0x168>
  802847:	83 ec 04             	sub    $0x4,%esp
  80284a:	68 e4 43 80 00       	push   $0x8043e4
  80284f:	68 c7 00 00 00       	push   $0xc7
  802854:	68 3b 43 80 00       	push   $0x80433b
  802859:	e8 5d dc ff ff       	call   8004bb <_panic>
  80285e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802861:	8b 00                	mov    (%eax),%eax
  802863:	85 c0                	test   %eax,%eax
  802865:	74 10                	je     802877 <alloc_block_BF+0x181>
  802867:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80286a:	8b 00                	mov    (%eax),%eax
  80286c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80286f:	8b 52 04             	mov    0x4(%edx),%edx
  802872:	89 50 04             	mov    %edx,0x4(%eax)
  802875:	eb 0b                	jmp    802882 <alloc_block_BF+0x18c>
  802877:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80287a:	8b 40 04             	mov    0x4(%eax),%eax
  80287d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802882:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802885:	8b 40 04             	mov    0x4(%eax),%eax
  802888:	85 c0                	test   %eax,%eax
  80288a:	74 0f                	je     80289b <alloc_block_BF+0x1a5>
  80288c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80288f:	8b 40 04             	mov    0x4(%eax),%eax
  802892:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802895:	8b 12                	mov    (%edx),%edx
  802897:	89 10                	mov    %edx,(%eax)
  802899:	eb 0a                	jmp    8028a5 <alloc_block_BF+0x1af>
  80289b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80289e:	8b 00                	mov    (%eax),%eax
  8028a0:	a3 48 51 80 00       	mov    %eax,0x805148
  8028a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028a8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028b1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028b8:	a1 54 51 80 00       	mov    0x805154,%eax
  8028bd:	48                   	dec    %eax
  8028be:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8028c3:	83 ec 08             	sub    $0x8,%esp
  8028c6:	ff 75 ec             	pushl  -0x14(%ebp)
  8028c9:	68 38 51 80 00       	push   $0x805138
  8028ce:	e8 71 f9 ff ff       	call   802244 <find_block>
  8028d3:	83 c4 10             	add    $0x10,%esp
  8028d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8028d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028dc:	8b 50 08             	mov    0x8(%eax),%edx
  8028df:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e2:	01 c2                	add    %eax,%edx
  8028e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028e7:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8028ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028ed:	8b 40 0c             	mov    0xc(%eax),%eax
  8028f0:	2b 45 08             	sub    0x8(%ebp),%eax
  8028f3:	89 c2                	mov    %eax,%edx
  8028f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028f8:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8028fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028fe:	eb 05                	jmp    802905 <alloc_block_BF+0x20f>
	}
	return NULL;
  802900:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802905:	c9                   	leave  
  802906:	c3                   	ret    

00802907 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802907:	55                   	push   %ebp
  802908:	89 e5                	mov    %esp,%ebp
  80290a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  80290d:	a1 28 50 80 00       	mov    0x805028,%eax
  802912:	85 c0                	test   %eax,%eax
  802914:	0f 85 de 01 00 00    	jne    802af8 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80291a:	a1 38 51 80 00       	mov    0x805138,%eax
  80291f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802922:	e9 9e 01 00 00       	jmp    802ac5 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802927:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292a:	8b 40 0c             	mov    0xc(%eax),%eax
  80292d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802930:	0f 82 87 01 00 00    	jb     802abd <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802936:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802939:	8b 40 0c             	mov    0xc(%eax),%eax
  80293c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80293f:	0f 85 95 00 00 00    	jne    8029da <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802945:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802949:	75 17                	jne    802962 <alloc_block_NF+0x5b>
  80294b:	83 ec 04             	sub    $0x4,%esp
  80294e:	68 e4 43 80 00       	push   $0x8043e4
  802953:	68 e0 00 00 00       	push   $0xe0
  802958:	68 3b 43 80 00       	push   $0x80433b
  80295d:	e8 59 db ff ff       	call   8004bb <_panic>
  802962:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802965:	8b 00                	mov    (%eax),%eax
  802967:	85 c0                	test   %eax,%eax
  802969:	74 10                	je     80297b <alloc_block_NF+0x74>
  80296b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296e:	8b 00                	mov    (%eax),%eax
  802970:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802973:	8b 52 04             	mov    0x4(%edx),%edx
  802976:	89 50 04             	mov    %edx,0x4(%eax)
  802979:	eb 0b                	jmp    802986 <alloc_block_NF+0x7f>
  80297b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297e:	8b 40 04             	mov    0x4(%eax),%eax
  802981:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802986:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802989:	8b 40 04             	mov    0x4(%eax),%eax
  80298c:	85 c0                	test   %eax,%eax
  80298e:	74 0f                	je     80299f <alloc_block_NF+0x98>
  802990:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802993:	8b 40 04             	mov    0x4(%eax),%eax
  802996:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802999:	8b 12                	mov    (%edx),%edx
  80299b:	89 10                	mov    %edx,(%eax)
  80299d:	eb 0a                	jmp    8029a9 <alloc_block_NF+0xa2>
  80299f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a2:	8b 00                	mov    (%eax),%eax
  8029a4:	a3 38 51 80 00       	mov    %eax,0x805138
  8029a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029bc:	a1 44 51 80 00       	mov    0x805144,%eax
  8029c1:	48                   	dec    %eax
  8029c2:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  8029c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ca:	8b 40 08             	mov    0x8(%eax),%eax
  8029cd:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  8029d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d5:	e9 f8 04 00 00       	jmp    802ed2 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8029da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029dd:	8b 40 0c             	mov    0xc(%eax),%eax
  8029e0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029e3:	0f 86 d4 00 00 00    	jbe    802abd <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8029e9:	a1 48 51 80 00       	mov    0x805148,%eax
  8029ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8029f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f4:	8b 50 08             	mov    0x8(%eax),%edx
  8029f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029fa:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8029fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a00:	8b 55 08             	mov    0x8(%ebp),%edx
  802a03:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802a06:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a0a:	75 17                	jne    802a23 <alloc_block_NF+0x11c>
  802a0c:	83 ec 04             	sub    $0x4,%esp
  802a0f:	68 e4 43 80 00       	push   $0x8043e4
  802a14:	68 e9 00 00 00       	push   $0xe9
  802a19:	68 3b 43 80 00       	push   $0x80433b
  802a1e:	e8 98 da ff ff       	call   8004bb <_panic>
  802a23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a26:	8b 00                	mov    (%eax),%eax
  802a28:	85 c0                	test   %eax,%eax
  802a2a:	74 10                	je     802a3c <alloc_block_NF+0x135>
  802a2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a2f:	8b 00                	mov    (%eax),%eax
  802a31:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a34:	8b 52 04             	mov    0x4(%edx),%edx
  802a37:	89 50 04             	mov    %edx,0x4(%eax)
  802a3a:	eb 0b                	jmp    802a47 <alloc_block_NF+0x140>
  802a3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a3f:	8b 40 04             	mov    0x4(%eax),%eax
  802a42:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a4a:	8b 40 04             	mov    0x4(%eax),%eax
  802a4d:	85 c0                	test   %eax,%eax
  802a4f:	74 0f                	je     802a60 <alloc_block_NF+0x159>
  802a51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a54:	8b 40 04             	mov    0x4(%eax),%eax
  802a57:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a5a:	8b 12                	mov    (%edx),%edx
  802a5c:	89 10                	mov    %edx,(%eax)
  802a5e:	eb 0a                	jmp    802a6a <alloc_block_NF+0x163>
  802a60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a63:	8b 00                	mov    (%eax),%eax
  802a65:	a3 48 51 80 00       	mov    %eax,0x805148
  802a6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a6d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a76:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a7d:	a1 54 51 80 00       	mov    0x805154,%eax
  802a82:	48                   	dec    %eax
  802a83:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802a88:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a8b:	8b 40 08             	mov    0x8(%eax),%eax
  802a8e:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802a93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a96:	8b 50 08             	mov    0x8(%eax),%edx
  802a99:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9c:	01 c2                	add    %eax,%edx
  802a9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa1:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802aa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa7:	8b 40 0c             	mov    0xc(%eax),%eax
  802aaa:	2b 45 08             	sub    0x8(%ebp),%eax
  802aad:	89 c2                	mov    %eax,%edx
  802aaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab2:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802ab5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ab8:	e9 15 04 00 00       	jmp    802ed2 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802abd:	a1 40 51 80 00       	mov    0x805140,%eax
  802ac2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ac5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ac9:	74 07                	je     802ad2 <alloc_block_NF+0x1cb>
  802acb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ace:	8b 00                	mov    (%eax),%eax
  802ad0:	eb 05                	jmp    802ad7 <alloc_block_NF+0x1d0>
  802ad2:	b8 00 00 00 00       	mov    $0x0,%eax
  802ad7:	a3 40 51 80 00       	mov    %eax,0x805140
  802adc:	a1 40 51 80 00       	mov    0x805140,%eax
  802ae1:	85 c0                	test   %eax,%eax
  802ae3:	0f 85 3e fe ff ff    	jne    802927 <alloc_block_NF+0x20>
  802ae9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aed:	0f 85 34 fe ff ff    	jne    802927 <alloc_block_NF+0x20>
  802af3:	e9 d5 03 00 00       	jmp    802ecd <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802af8:	a1 38 51 80 00       	mov    0x805138,%eax
  802afd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b00:	e9 b1 01 00 00       	jmp    802cb6 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802b05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b08:	8b 50 08             	mov    0x8(%eax),%edx
  802b0b:	a1 28 50 80 00       	mov    0x805028,%eax
  802b10:	39 c2                	cmp    %eax,%edx
  802b12:	0f 82 96 01 00 00    	jb     802cae <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802b18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1b:	8b 40 0c             	mov    0xc(%eax),%eax
  802b1e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b21:	0f 82 87 01 00 00    	jb     802cae <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802b27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2a:	8b 40 0c             	mov    0xc(%eax),%eax
  802b2d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b30:	0f 85 95 00 00 00    	jne    802bcb <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802b36:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b3a:	75 17                	jne    802b53 <alloc_block_NF+0x24c>
  802b3c:	83 ec 04             	sub    $0x4,%esp
  802b3f:	68 e4 43 80 00       	push   $0x8043e4
  802b44:	68 fc 00 00 00       	push   $0xfc
  802b49:	68 3b 43 80 00       	push   $0x80433b
  802b4e:	e8 68 d9 ff ff       	call   8004bb <_panic>
  802b53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b56:	8b 00                	mov    (%eax),%eax
  802b58:	85 c0                	test   %eax,%eax
  802b5a:	74 10                	je     802b6c <alloc_block_NF+0x265>
  802b5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5f:	8b 00                	mov    (%eax),%eax
  802b61:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b64:	8b 52 04             	mov    0x4(%edx),%edx
  802b67:	89 50 04             	mov    %edx,0x4(%eax)
  802b6a:	eb 0b                	jmp    802b77 <alloc_block_NF+0x270>
  802b6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6f:	8b 40 04             	mov    0x4(%eax),%eax
  802b72:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7a:	8b 40 04             	mov    0x4(%eax),%eax
  802b7d:	85 c0                	test   %eax,%eax
  802b7f:	74 0f                	je     802b90 <alloc_block_NF+0x289>
  802b81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b84:	8b 40 04             	mov    0x4(%eax),%eax
  802b87:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b8a:	8b 12                	mov    (%edx),%edx
  802b8c:	89 10                	mov    %edx,(%eax)
  802b8e:	eb 0a                	jmp    802b9a <alloc_block_NF+0x293>
  802b90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b93:	8b 00                	mov    (%eax),%eax
  802b95:	a3 38 51 80 00       	mov    %eax,0x805138
  802b9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ba3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bad:	a1 44 51 80 00       	mov    0x805144,%eax
  802bb2:	48                   	dec    %eax
  802bb3:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802bb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bbb:	8b 40 08             	mov    0x8(%eax),%eax
  802bbe:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802bc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc6:	e9 07 03 00 00       	jmp    802ed2 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802bcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bce:	8b 40 0c             	mov    0xc(%eax),%eax
  802bd1:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bd4:	0f 86 d4 00 00 00    	jbe    802cae <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802bda:	a1 48 51 80 00       	mov    0x805148,%eax
  802bdf:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802be2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be5:	8b 50 08             	mov    0x8(%eax),%edx
  802be8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802beb:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802bee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bf1:	8b 55 08             	mov    0x8(%ebp),%edx
  802bf4:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802bf7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802bfb:	75 17                	jne    802c14 <alloc_block_NF+0x30d>
  802bfd:	83 ec 04             	sub    $0x4,%esp
  802c00:	68 e4 43 80 00       	push   $0x8043e4
  802c05:	68 04 01 00 00       	push   $0x104
  802c0a:	68 3b 43 80 00       	push   $0x80433b
  802c0f:	e8 a7 d8 ff ff       	call   8004bb <_panic>
  802c14:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c17:	8b 00                	mov    (%eax),%eax
  802c19:	85 c0                	test   %eax,%eax
  802c1b:	74 10                	je     802c2d <alloc_block_NF+0x326>
  802c1d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c20:	8b 00                	mov    (%eax),%eax
  802c22:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c25:	8b 52 04             	mov    0x4(%edx),%edx
  802c28:	89 50 04             	mov    %edx,0x4(%eax)
  802c2b:	eb 0b                	jmp    802c38 <alloc_block_NF+0x331>
  802c2d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c30:	8b 40 04             	mov    0x4(%eax),%eax
  802c33:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c38:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c3b:	8b 40 04             	mov    0x4(%eax),%eax
  802c3e:	85 c0                	test   %eax,%eax
  802c40:	74 0f                	je     802c51 <alloc_block_NF+0x34a>
  802c42:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c45:	8b 40 04             	mov    0x4(%eax),%eax
  802c48:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c4b:	8b 12                	mov    (%edx),%edx
  802c4d:	89 10                	mov    %edx,(%eax)
  802c4f:	eb 0a                	jmp    802c5b <alloc_block_NF+0x354>
  802c51:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c54:	8b 00                	mov    (%eax),%eax
  802c56:	a3 48 51 80 00       	mov    %eax,0x805148
  802c5b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c5e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c64:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c67:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c6e:	a1 54 51 80 00       	mov    0x805154,%eax
  802c73:	48                   	dec    %eax
  802c74:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802c79:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c7c:	8b 40 08             	mov    0x8(%eax),%eax
  802c7f:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802c84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c87:	8b 50 08             	mov    0x8(%eax),%edx
  802c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8d:	01 c2                	add    %eax,%edx
  802c8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c92:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802c95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c98:	8b 40 0c             	mov    0xc(%eax),%eax
  802c9b:	2b 45 08             	sub    0x8(%ebp),%eax
  802c9e:	89 c2                	mov    %eax,%edx
  802ca0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca3:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802ca6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ca9:	e9 24 02 00 00       	jmp    802ed2 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802cae:	a1 40 51 80 00       	mov    0x805140,%eax
  802cb3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cb6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cba:	74 07                	je     802cc3 <alloc_block_NF+0x3bc>
  802cbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbf:	8b 00                	mov    (%eax),%eax
  802cc1:	eb 05                	jmp    802cc8 <alloc_block_NF+0x3c1>
  802cc3:	b8 00 00 00 00       	mov    $0x0,%eax
  802cc8:	a3 40 51 80 00       	mov    %eax,0x805140
  802ccd:	a1 40 51 80 00       	mov    0x805140,%eax
  802cd2:	85 c0                	test   %eax,%eax
  802cd4:	0f 85 2b fe ff ff    	jne    802b05 <alloc_block_NF+0x1fe>
  802cda:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cde:	0f 85 21 fe ff ff    	jne    802b05 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802ce4:	a1 38 51 80 00       	mov    0x805138,%eax
  802ce9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cec:	e9 ae 01 00 00       	jmp    802e9f <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802cf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf4:	8b 50 08             	mov    0x8(%eax),%edx
  802cf7:	a1 28 50 80 00       	mov    0x805028,%eax
  802cfc:	39 c2                	cmp    %eax,%edx
  802cfe:	0f 83 93 01 00 00    	jae    802e97 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802d04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d07:	8b 40 0c             	mov    0xc(%eax),%eax
  802d0a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d0d:	0f 82 84 01 00 00    	jb     802e97 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802d13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d16:	8b 40 0c             	mov    0xc(%eax),%eax
  802d19:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d1c:	0f 85 95 00 00 00    	jne    802db7 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802d22:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d26:	75 17                	jne    802d3f <alloc_block_NF+0x438>
  802d28:	83 ec 04             	sub    $0x4,%esp
  802d2b:	68 e4 43 80 00       	push   $0x8043e4
  802d30:	68 14 01 00 00       	push   $0x114
  802d35:	68 3b 43 80 00       	push   $0x80433b
  802d3a:	e8 7c d7 ff ff       	call   8004bb <_panic>
  802d3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d42:	8b 00                	mov    (%eax),%eax
  802d44:	85 c0                	test   %eax,%eax
  802d46:	74 10                	je     802d58 <alloc_block_NF+0x451>
  802d48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4b:	8b 00                	mov    (%eax),%eax
  802d4d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d50:	8b 52 04             	mov    0x4(%edx),%edx
  802d53:	89 50 04             	mov    %edx,0x4(%eax)
  802d56:	eb 0b                	jmp    802d63 <alloc_block_NF+0x45c>
  802d58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5b:	8b 40 04             	mov    0x4(%eax),%eax
  802d5e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d66:	8b 40 04             	mov    0x4(%eax),%eax
  802d69:	85 c0                	test   %eax,%eax
  802d6b:	74 0f                	je     802d7c <alloc_block_NF+0x475>
  802d6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d70:	8b 40 04             	mov    0x4(%eax),%eax
  802d73:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d76:	8b 12                	mov    (%edx),%edx
  802d78:	89 10                	mov    %edx,(%eax)
  802d7a:	eb 0a                	jmp    802d86 <alloc_block_NF+0x47f>
  802d7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7f:	8b 00                	mov    (%eax),%eax
  802d81:	a3 38 51 80 00       	mov    %eax,0x805138
  802d86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d89:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d92:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d99:	a1 44 51 80 00       	mov    0x805144,%eax
  802d9e:	48                   	dec    %eax
  802d9f:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802da4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da7:	8b 40 08             	mov    0x8(%eax),%eax
  802daa:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802daf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db2:	e9 1b 01 00 00       	jmp    802ed2 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802db7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dba:	8b 40 0c             	mov    0xc(%eax),%eax
  802dbd:	3b 45 08             	cmp    0x8(%ebp),%eax
  802dc0:	0f 86 d1 00 00 00    	jbe    802e97 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802dc6:	a1 48 51 80 00       	mov    0x805148,%eax
  802dcb:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802dce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd1:	8b 50 08             	mov    0x8(%eax),%edx
  802dd4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dd7:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802dda:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ddd:	8b 55 08             	mov    0x8(%ebp),%edx
  802de0:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802de3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802de7:	75 17                	jne    802e00 <alloc_block_NF+0x4f9>
  802de9:	83 ec 04             	sub    $0x4,%esp
  802dec:	68 e4 43 80 00       	push   $0x8043e4
  802df1:	68 1c 01 00 00       	push   $0x11c
  802df6:	68 3b 43 80 00       	push   $0x80433b
  802dfb:	e8 bb d6 ff ff       	call   8004bb <_panic>
  802e00:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e03:	8b 00                	mov    (%eax),%eax
  802e05:	85 c0                	test   %eax,%eax
  802e07:	74 10                	je     802e19 <alloc_block_NF+0x512>
  802e09:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e0c:	8b 00                	mov    (%eax),%eax
  802e0e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e11:	8b 52 04             	mov    0x4(%edx),%edx
  802e14:	89 50 04             	mov    %edx,0x4(%eax)
  802e17:	eb 0b                	jmp    802e24 <alloc_block_NF+0x51d>
  802e19:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e1c:	8b 40 04             	mov    0x4(%eax),%eax
  802e1f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e24:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e27:	8b 40 04             	mov    0x4(%eax),%eax
  802e2a:	85 c0                	test   %eax,%eax
  802e2c:	74 0f                	je     802e3d <alloc_block_NF+0x536>
  802e2e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e31:	8b 40 04             	mov    0x4(%eax),%eax
  802e34:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e37:	8b 12                	mov    (%edx),%edx
  802e39:	89 10                	mov    %edx,(%eax)
  802e3b:	eb 0a                	jmp    802e47 <alloc_block_NF+0x540>
  802e3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e40:	8b 00                	mov    (%eax),%eax
  802e42:	a3 48 51 80 00       	mov    %eax,0x805148
  802e47:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e4a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e50:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e53:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e5a:	a1 54 51 80 00       	mov    0x805154,%eax
  802e5f:	48                   	dec    %eax
  802e60:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802e65:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e68:	8b 40 08             	mov    0x8(%eax),%eax
  802e6b:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802e70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e73:	8b 50 08             	mov    0x8(%eax),%edx
  802e76:	8b 45 08             	mov    0x8(%ebp),%eax
  802e79:	01 c2                	add    %eax,%edx
  802e7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7e:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802e81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e84:	8b 40 0c             	mov    0xc(%eax),%eax
  802e87:	2b 45 08             	sub    0x8(%ebp),%eax
  802e8a:	89 c2                	mov    %eax,%edx
  802e8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8f:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802e92:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e95:	eb 3b                	jmp    802ed2 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802e97:	a1 40 51 80 00       	mov    0x805140,%eax
  802e9c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e9f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ea3:	74 07                	je     802eac <alloc_block_NF+0x5a5>
  802ea5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea8:	8b 00                	mov    (%eax),%eax
  802eaa:	eb 05                	jmp    802eb1 <alloc_block_NF+0x5aa>
  802eac:	b8 00 00 00 00       	mov    $0x0,%eax
  802eb1:	a3 40 51 80 00       	mov    %eax,0x805140
  802eb6:	a1 40 51 80 00       	mov    0x805140,%eax
  802ebb:	85 c0                	test   %eax,%eax
  802ebd:	0f 85 2e fe ff ff    	jne    802cf1 <alloc_block_NF+0x3ea>
  802ec3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ec7:	0f 85 24 fe ff ff    	jne    802cf1 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802ecd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ed2:	c9                   	leave  
  802ed3:	c3                   	ret    

00802ed4 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802ed4:	55                   	push   %ebp
  802ed5:	89 e5                	mov    %esp,%ebp
  802ed7:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802eda:	a1 38 51 80 00       	mov    0x805138,%eax
  802edf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802ee2:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802ee7:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802eea:	a1 38 51 80 00       	mov    0x805138,%eax
  802eef:	85 c0                	test   %eax,%eax
  802ef1:	74 14                	je     802f07 <insert_sorted_with_merge_freeList+0x33>
  802ef3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef6:	8b 50 08             	mov    0x8(%eax),%edx
  802ef9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802efc:	8b 40 08             	mov    0x8(%eax),%eax
  802eff:	39 c2                	cmp    %eax,%edx
  802f01:	0f 87 9b 01 00 00    	ja     8030a2 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802f07:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f0b:	75 17                	jne    802f24 <insert_sorted_with_merge_freeList+0x50>
  802f0d:	83 ec 04             	sub    $0x4,%esp
  802f10:	68 18 43 80 00       	push   $0x804318
  802f15:	68 38 01 00 00       	push   $0x138
  802f1a:	68 3b 43 80 00       	push   $0x80433b
  802f1f:	e8 97 d5 ff ff       	call   8004bb <_panic>
  802f24:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2d:	89 10                	mov    %edx,(%eax)
  802f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f32:	8b 00                	mov    (%eax),%eax
  802f34:	85 c0                	test   %eax,%eax
  802f36:	74 0d                	je     802f45 <insert_sorted_with_merge_freeList+0x71>
  802f38:	a1 38 51 80 00       	mov    0x805138,%eax
  802f3d:	8b 55 08             	mov    0x8(%ebp),%edx
  802f40:	89 50 04             	mov    %edx,0x4(%eax)
  802f43:	eb 08                	jmp    802f4d <insert_sorted_with_merge_freeList+0x79>
  802f45:	8b 45 08             	mov    0x8(%ebp),%eax
  802f48:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f50:	a3 38 51 80 00       	mov    %eax,0x805138
  802f55:	8b 45 08             	mov    0x8(%ebp),%eax
  802f58:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f5f:	a1 44 51 80 00       	mov    0x805144,%eax
  802f64:	40                   	inc    %eax
  802f65:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802f6a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f6e:	0f 84 a8 06 00 00    	je     80361c <insert_sorted_with_merge_freeList+0x748>
  802f74:	8b 45 08             	mov    0x8(%ebp),%eax
  802f77:	8b 50 08             	mov    0x8(%eax),%edx
  802f7a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7d:	8b 40 0c             	mov    0xc(%eax),%eax
  802f80:	01 c2                	add    %eax,%edx
  802f82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f85:	8b 40 08             	mov    0x8(%eax),%eax
  802f88:	39 c2                	cmp    %eax,%edx
  802f8a:	0f 85 8c 06 00 00    	jne    80361c <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802f90:	8b 45 08             	mov    0x8(%ebp),%eax
  802f93:	8b 50 0c             	mov    0xc(%eax),%edx
  802f96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f99:	8b 40 0c             	mov    0xc(%eax),%eax
  802f9c:	01 c2                	add    %eax,%edx
  802f9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa1:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802fa4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802fa8:	75 17                	jne    802fc1 <insert_sorted_with_merge_freeList+0xed>
  802faa:	83 ec 04             	sub    $0x4,%esp
  802fad:	68 e4 43 80 00       	push   $0x8043e4
  802fb2:	68 3c 01 00 00       	push   $0x13c
  802fb7:	68 3b 43 80 00       	push   $0x80433b
  802fbc:	e8 fa d4 ff ff       	call   8004bb <_panic>
  802fc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fc4:	8b 00                	mov    (%eax),%eax
  802fc6:	85 c0                	test   %eax,%eax
  802fc8:	74 10                	je     802fda <insert_sorted_with_merge_freeList+0x106>
  802fca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fcd:	8b 00                	mov    (%eax),%eax
  802fcf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fd2:	8b 52 04             	mov    0x4(%edx),%edx
  802fd5:	89 50 04             	mov    %edx,0x4(%eax)
  802fd8:	eb 0b                	jmp    802fe5 <insert_sorted_with_merge_freeList+0x111>
  802fda:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fdd:	8b 40 04             	mov    0x4(%eax),%eax
  802fe0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fe5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fe8:	8b 40 04             	mov    0x4(%eax),%eax
  802feb:	85 c0                	test   %eax,%eax
  802fed:	74 0f                	je     802ffe <insert_sorted_with_merge_freeList+0x12a>
  802fef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ff2:	8b 40 04             	mov    0x4(%eax),%eax
  802ff5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ff8:	8b 12                	mov    (%edx),%edx
  802ffa:	89 10                	mov    %edx,(%eax)
  802ffc:	eb 0a                	jmp    803008 <insert_sorted_with_merge_freeList+0x134>
  802ffe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803001:	8b 00                	mov    (%eax),%eax
  803003:	a3 38 51 80 00       	mov    %eax,0x805138
  803008:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80300b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803011:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803014:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80301b:	a1 44 51 80 00       	mov    0x805144,%eax
  803020:	48                   	dec    %eax
  803021:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  803026:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803029:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  803030:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803033:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  80303a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80303e:	75 17                	jne    803057 <insert_sorted_with_merge_freeList+0x183>
  803040:	83 ec 04             	sub    $0x4,%esp
  803043:	68 18 43 80 00       	push   $0x804318
  803048:	68 3f 01 00 00       	push   $0x13f
  80304d:	68 3b 43 80 00       	push   $0x80433b
  803052:	e8 64 d4 ff ff       	call   8004bb <_panic>
  803057:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80305d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803060:	89 10                	mov    %edx,(%eax)
  803062:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803065:	8b 00                	mov    (%eax),%eax
  803067:	85 c0                	test   %eax,%eax
  803069:	74 0d                	je     803078 <insert_sorted_with_merge_freeList+0x1a4>
  80306b:	a1 48 51 80 00       	mov    0x805148,%eax
  803070:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803073:	89 50 04             	mov    %edx,0x4(%eax)
  803076:	eb 08                	jmp    803080 <insert_sorted_with_merge_freeList+0x1ac>
  803078:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80307b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803080:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803083:	a3 48 51 80 00       	mov    %eax,0x805148
  803088:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80308b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803092:	a1 54 51 80 00       	mov    0x805154,%eax
  803097:	40                   	inc    %eax
  803098:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80309d:	e9 7a 05 00 00       	jmp    80361c <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  8030a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a5:	8b 50 08             	mov    0x8(%eax),%edx
  8030a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030ab:	8b 40 08             	mov    0x8(%eax),%eax
  8030ae:	39 c2                	cmp    %eax,%edx
  8030b0:	0f 82 14 01 00 00    	jb     8031ca <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  8030b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030b9:	8b 50 08             	mov    0x8(%eax),%edx
  8030bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030bf:	8b 40 0c             	mov    0xc(%eax),%eax
  8030c2:	01 c2                	add    %eax,%edx
  8030c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c7:	8b 40 08             	mov    0x8(%eax),%eax
  8030ca:	39 c2                	cmp    %eax,%edx
  8030cc:	0f 85 90 00 00 00    	jne    803162 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  8030d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030d5:	8b 50 0c             	mov    0xc(%eax),%edx
  8030d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030db:	8b 40 0c             	mov    0xc(%eax),%eax
  8030de:	01 c2                	add    %eax,%edx
  8030e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030e3:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  8030e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  8030f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8030fa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030fe:	75 17                	jne    803117 <insert_sorted_with_merge_freeList+0x243>
  803100:	83 ec 04             	sub    $0x4,%esp
  803103:	68 18 43 80 00       	push   $0x804318
  803108:	68 49 01 00 00       	push   $0x149
  80310d:	68 3b 43 80 00       	push   $0x80433b
  803112:	e8 a4 d3 ff ff       	call   8004bb <_panic>
  803117:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80311d:	8b 45 08             	mov    0x8(%ebp),%eax
  803120:	89 10                	mov    %edx,(%eax)
  803122:	8b 45 08             	mov    0x8(%ebp),%eax
  803125:	8b 00                	mov    (%eax),%eax
  803127:	85 c0                	test   %eax,%eax
  803129:	74 0d                	je     803138 <insert_sorted_with_merge_freeList+0x264>
  80312b:	a1 48 51 80 00       	mov    0x805148,%eax
  803130:	8b 55 08             	mov    0x8(%ebp),%edx
  803133:	89 50 04             	mov    %edx,0x4(%eax)
  803136:	eb 08                	jmp    803140 <insert_sorted_with_merge_freeList+0x26c>
  803138:	8b 45 08             	mov    0x8(%ebp),%eax
  80313b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803140:	8b 45 08             	mov    0x8(%ebp),%eax
  803143:	a3 48 51 80 00       	mov    %eax,0x805148
  803148:	8b 45 08             	mov    0x8(%ebp),%eax
  80314b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803152:	a1 54 51 80 00       	mov    0x805154,%eax
  803157:	40                   	inc    %eax
  803158:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80315d:	e9 bb 04 00 00       	jmp    80361d <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803162:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803166:	75 17                	jne    80317f <insert_sorted_with_merge_freeList+0x2ab>
  803168:	83 ec 04             	sub    $0x4,%esp
  80316b:	68 8c 43 80 00       	push   $0x80438c
  803170:	68 4c 01 00 00       	push   $0x14c
  803175:	68 3b 43 80 00       	push   $0x80433b
  80317a:	e8 3c d3 ff ff       	call   8004bb <_panic>
  80317f:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803185:	8b 45 08             	mov    0x8(%ebp),%eax
  803188:	89 50 04             	mov    %edx,0x4(%eax)
  80318b:	8b 45 08             	mov    0x8(%ebp),%eax
  80318e:	8b 40 04             	mov    0x4(%eax),%eax
  803191:	85 c0                	test   %eax,%eax
  803193:	74 0c                	je     8031a1 <insert_sorted_with_merge_freeList+0x2cd>
  803195:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80319a:	8b 55 08             	mov    0x8(%ebp),%edx
  80319d:	89 10                	mov    %edx,(%eax)
  80319f:	eb 08                	jmp    8031a9 <insert_sorted_with_merge_freeList+0x2d5>
  8031a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a4:	a3 38 51 80 00       	mov    %eax,0x805138
  8031a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ac:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031ba:	a1 44 51 80 00       	mov    0x805144,%eax
  8031bf:	40                   	inc    %eax
  8031c0:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8031c5:	e9 53 04 00 00       	jmp    80361d <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8031ca:	a1 38 51 80 00       	mov    0x805138,%eax
  8031cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031d2:	e9 15 04 00 00       	jmp    8035ec <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  8031d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031da:	8b 00                	mov    (%eax),%eax
  8031dc:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  8031df:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e2:	8b 50 08             	mov    0x8(%eax),%edx
  8031e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e8:	8b 40 08             	mov    0x8(%eax),%eax
  8031eb:	39 c2                	cmp    %eax,%edx
  8031ed:	0f 86 f1 03 00 00    	jbe    8035e4 <insert_sorted_with_merge_freeList+0x710>
  8031f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f6:	8b 50 08             	mov    0x8(%eax),%edx
  8031f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031fc:	8b 40 08             	mov    0x8(%eax),%eax
  8031ff:	39 c2                	cmp    %eax,%edx
  803201:	0f 83 dd 03 00 00    	jae    8035e4 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803207:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80320a:	8b 50 08             	mov    0x8(%eax),%edx
  80320d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803210:	8b 40 0c             	mov    0xc(%eax),%eax
  803213:	01 c2                	add    %eax,%edx
  803215:	8b 45 08             	mov    0x8(%ebp),%eax
  803218:	8b 40 08             	mov    0x8(%eax),%eax
  80321b:	39 c2                	cmp    %eax,%edx
  80321d:	0f 85 b9 01 00 00    	jne    8033dc <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803223:	8b 45 08             	mov    0x8(%ebp),%eax
  803226:	8b 50 08             	mov    0x8(%eax),%edx
  803229:	8b 45 08             	mov    0x8(%ebp),%eax
  80322c:	8b 40 0c             	mov    0xc(%eax),%eax
  80322f:	01 c2                	add    %eax,%edx
  803231:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803234:	8b 40 08             	mov    0x8(%eax),%eax
  803237:	39 c2                	cmp    %eax,%edx
  803239:	0f 85 0d 01 00 00    	jne    80334c <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  80323f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803242:	8b 50 0c             	mov    0xc(%eax),%edx
  803245:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803248:	8b 40 0c             	mov    0xc(%eax),%eax
  80324b:	01 c2                	add    %eax,%edx
  80324d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803250:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803253:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803257:	75 17                	jne    803270 <insert_sorted_with_merge_freeList+0x39c>
  803259:	83 ec 04             	sub    $0x4,%esp
  80325c:	68 e4 43 80 00       	push   $0x8043e4
  803261:	68 5c 01 00 00       	push   $0x15c
  803266:	68 3b 43 80 00       	push   $0x80433b
  80326b:	e8 4b d2 ff ff       	call   8004bb <_panic>
  803270:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803273:	8b 00                	mov    (%eax),%eax
  803275:	85 c0                	test   %eax,%eax
  803277:	74 10                	je     803289 <insert_sorted_with_merge_freeList+0x3b5>
  803279:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80327c:	8b 00                	mov    (%eax),%eax
  80327e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803281:	8b 52 04             	mov    0x4(%edx),%edx
  803284:	89 50 04             	mov    %edx,0x4(%eax)
  803287:	eb 0b                	jmp    803294 <insert_sorted_with_merge_freeList+0x3c0>
  803289:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80328c:	8b 40 04             	mov    0x4(%eax),%eax
  80328f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803294:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803297:	8b 40 04             	mov    0x4(%eax),%eax
  80329a:	85 c0                	test   %eax,%eax
  80329c:	74 0f                	je     8032ad <insert_sorted_with_merge_freeList+0x3d9>
  80329e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032a1:	8b 40 04             	mov    0x4(%eax),%eax
  8032a4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032a7:	8b 12                	mov    (%edx),%edx
  8032a9:	89 10                	mov    %edx,(%eax)
  8032ab:	eb 0a                	jmp    8032b7 <insert_sorted_with_merge_freeList+0x3e3>
  8032ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032b0:	8b 00                	mov    (%eax),%eax
  8032b2:	a3 38 51 80 00       	mov    %eax,0x805138
  8032b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032c3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032ca:	a1 44 51 80 00       	mov    0x805144,%eax
  8032cf:	48                   	dec    %eax
  8032d0:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  8032d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032d8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8032df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032e2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8032e9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032ed:	75 17                	jne    803306 <insert_sorted_with_merge_freeList+0x432>
  8032ef:	83 ec 04             	sub    $0x4,%esp
  8032f2:	68 18 43 80 00       	push   $0x804318
  8032f7:	68 5f 01 00 00       	push   $0x15f
  8032fc:	68 3b 43 80 00       	push   $0x80433b
  803301:	e8 b5 d1 ff ff       	call   8004bb <_panic>
  803306:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80330c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80330f:	89 10                	mov    %edx,(%eax)
  803311:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803314:	8b 00                	mov    (%eax),%eax
  803316:	85 c0                	test   %eax,%eax
  803318:	74 0d                	je     803327 <insert_sorted_with_merge_freeList+0x453>
  80331a:	a1 48 51 80 00       	mov    0x805148,%eax
  80331f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803322:	89 50 04             	mov    %edx,0x4(%eax)
  803325:	eb 08                	jmp    80332f <insert_sorted_with_merge_freeList+0x45b>
  803327:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80332a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80332f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803332:	a3 48 51 80 00       	mov    %eax,0x805148
  803337:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80333a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803341:	a1 54 51 80 00       	mov    0x805154,%eax
  803346:	40                   	inc    %eax
  803347:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  80334c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80334f:	8b 50 0c             	mov    0xc(%eax),%edx
  803352:	8b 45 08             	mov    0x8(%ebp),%eax
  803355:	8b 40 0c             	mov    0xc(%eax),%eax
  803358:	01 c2                	add    %eax,%edx
  80335a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80335d:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803360:	8b 45 08             	mov    0x8(%ebp),%eax
  803363:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  80336a:	8b 45 08             	mov    0x8(%ebp),%eax
  80336d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803374:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803378:	75 17                	jne    803391 <insert_sorted_with_merge_freeList+0x4bd>
  80337a:	83 ec 04             	sub    $0x4,%esp
  80337d:	68 18 43 80 00       	push   $0x804318
  803382:	68 64 01 00 00       	push   $0x164
  803387:	68 3b 43 80 00       	push   $0x80433b
  80338c:	e8 2a d1 ff ff       	call   8004bb <_panic>
  803391:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803397:	8b 45 08             	mov    0x8(%ebp),%eax
  80339a:	89 10                	mov    %edx,(%eax)
  80339c:	8b 45 08             	mov    0x8(%ebp),%eax
  80339f:	8b 00                	mov    (%eax),%eax
  8033a1:	85 c0                	test   %eax,%eax
  8033a3:	74 0d                	je     8033b2 <insert_sorted_with_merge_freeList+0x4de>
  8033a5:	a1 48 51 80 00       	mov    0x805148,%eax
  8033aa:	8b 55 08             	mov    0x8(%ebp),%edx
  8033ad:	89 50 04             	mov    %edx,0x4(%eax)
  8033b0:	eb 08                	jmp    8033ba <insert_sorted_with_merge_freeList+0x4e6>
  8033b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8033ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8033bd:	a3 48 51 80 00       	mov    %eax,0x805148
  8033c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033cc:	a1 54 51 80 00       	mov    0x805154,%eax
  8033d1:	40                   	inc    %eax
  8033d2:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8033d7:	e9 41 02 00 00       	jmp    80361d <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8033dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8033df:	8b 50 08             	mov    0x8(%eax),%edx
  8033e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e5:	8b 40 0c             	mov    0xc(%eax),%eax
  8033e8:	01 c2                	add    %eax,%edx
  8033ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033ed:	8b 40 08             	mov    0x8(%eax),%eax
  8033f0:	39 c2                	cmp    %eax,%edx
  8033f2:	0f 85 7c 01 00 00    	jne    803574 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8033f8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8033fc:	74 06                	je     803404 <insert_sorted_with_merge_freeList+0x530>
  8033fe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803402:	75 17                	jne    80341b <insert_sorted_with_merge_freeList+0x547>
  803404:	83 ec 04             	sub    $0x4,%esp
  803407:	68 54 43 80 00       	push   $0x804354
  80340c:	68 69 01 00 00       	push   $0x169
  803411:	68 3b 43 80 00       	push   $0x80433b
  803416:	e8 a0 d0 ff ff       	call   8004bb <_panic>
  80341b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80341e:	8b 50 04             	mov    0x4(%eax),%edx
  803421:	8b 45 08             	mov    0x8(%ebp),%eax
  803424:	89 50 04             	mov    %edx,0x4(%eax)
  803427:	8b 45 08             	mov    0x8(%ebp),%eax
  80342a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80342d:	89 10                	mov    %edx,(%eax)
  80342f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803432:	8b 40 04             	mov    0x4(%eax),%eax
  803435:	85 c0                	test   %eax,%eax
  803437:	74 0d                	je     803446 <insert_sorted_with_merge_freeList+0x572>
  803439:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80343c:	8b 40 04             	mov    0x4(%eax),%eax
  80343f:	8b 55 08             	mov    0x8(%ebp),%edx
  803442:	89 10                	mov    %edx,(%eax)
  803444:	eb 08                	jmp    80344e <insert_sorted_with_merge_freeList+0x57a>
  803446:	8b 45 08             	mov    0x8(%ebp),%eax
  803449:	a3 38 51 80 00       	mov    %eax,0x805138
  80344e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803451:	8b 55 08             	mov    0x8(%ebp),%edx
  803454:	89 50 04             	mov    %edx,0x4(%eax)
  803457:	a1 44 51 80 00       	mov    0x805144,%eax
  80345c:	40                   	inc    %eax
  80345d:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803462:	8b 45 08             	mov    0x8(%ebp),%eax
  803465:	8b 50 0c             	mov    0xc(%eax),%edx
  803468:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80346b:	8b 40 0c             	mov    0xc(%eax),%eax
  80346e:	01 c2                	add    %eax,%edx
  803470:	8b 45 08             	mov    0x8(%ebp),%eax
  803473:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803476:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80347a:	75 17                	jne    803493 <insert_sorted_with_merge_freeList+0x5bf>
  80347c:	83 ec 04             	sub    $0x4,%esp
  80347f:	68 e4 43 80 00       	push   $0x8043e4
  803484:	68 6b 01 00 00       	push   $0x16b
  803489:	68 3b 43 80 00       	push   $0x80433b
  80348e:	e8 28 d0 ff ff       	call   8004bb <_panic>
  803493:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803496:	8b 00                	mov    (%eax),%eax
  803498:	85 c0                	test   %eax,%eax
  80349a:	74 10                	je     8034ac <insert_sorted_with_merge_freeList+0x5d8>
  80349c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80349f:	8b 00                	mov    (%eax),%eax
  8034a1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8034a4:	8b 52 04             	mov    0x4(%edx),%edx
  8034a7:	89 50 04             	mov    %edx,0x4(%eax)
  8034aa:	eb 0b                	jmp    8034b7 <insert_sorted_with_merge_freeList+0x5e3>
  8034ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034af:	8b 40 04             	mov    0x4(%eax),%eax
  8034b2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8034b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034ba:	8b 40 04             	mov    0x4(%eax),%eax
  8034bd:	85 c0                	test   %eax,%eax
  8034bf:	74 0f                	je     8034d0 <insert_sorted_with_merge_freeList+0x5fc>
  8034c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034c4:	8b 40 04             	mov    0x4(%eax),%eax
  8034c7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8034ca:	8b 12                	mov    (%edx),%edx
  8034cc:	89 10                	mov    %edx,(%eax)
  8034ce:	eb 0a                	jmp    8034da <insert_sorted_with_merge_freeList+0x606>
  8034d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034d3:	8b 00                	mov    (%eax),%eax
  8034d5:	a3 38 51 80 00       	mov    %eax,0x805138
  8034da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034dd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034e6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034ed:	a1 44 51 80 00       	mov    0x805144,%eax
  8034f2:	48                   	dec    %eax
  8034f3:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  8034f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034fb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803502:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803505:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80350c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803510:	75 17                	jne    803529 <insert_sorted_with_merge_freeList+0x655>
  803512:	83 ec 04             	sub    $0x4,%esp
  803515:	68 18 43 80 00       	push   $0x804318
  80351a:	68 6e 01 00 00       	push   $0x16e
  80351f:	68 3b 43 80 00       	push   $0x80433b
  803524:	e8 92 cf ff ff       	call   8004bb <_panic>
  803529:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80352f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803532:	89 10                	mov    %edx,(%eax)
  803534:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803537:	8b 00                	mov    (%eax),%eax
  803539:	85 c0                	test   %eax,%eax
  80353b:	74 0d                	je     80354a <insert_sorted_with_merge_freeList+0x676>
  80353d:	a1 48 51 80 00       	mov    0x805148,%eax
  803542:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803545:	89 50 04             	mov    %edx,0x4(%eax)
  803548:	eb 08                	jmp    803552 <insert_sorted_with_merge_freeList+0x67e>
  80354a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80354d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803552:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803555:	a3 48 51 80 00       	mov    %eax,0x805148
  80355a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80355d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803564:	a1 54 51 80 00       	mov    0x805154,%eax
  803569:	40                   	inc    %eax
  80356a:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80356f:	e9 a9 00 00 00       	jmp    80361d <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803574:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803578:	74 06                	je     803580 <insert_sorted_with_merge_freeList+0x6ac>
  80357a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80357e:	75 17                	jne    803597 <insert_sorted_with_merge_freeList+0x6c3>
  803580:	83 ec 04             	sub    $0x4,%esp
  803583:	68 b0 43 80 00       	push   $0x8043b0
  803588:	68 73 01 00 00       	push   $0x173
  80358d:	68 3b 43 80 00       	push   $0x80433b
  803592:	e8 24 cf ff ff       	call   8004bb <_panic>
  803597:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80359a:	8b 10                	mov    (%eax),%edx
  80359c:	8b 45 08             	mov    0x8(%ebp),%eax
  80359f:	89 10                	mov    %edx,(%eax)
  8035a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a4:	8b 00                	mov    (%eax),%eax
  8035a6:	85 c0                	test   %eax,%eax
  8035a8:	74 0b                	je     8035b5 <insert_sorted_with_merge_freeList+0x6e1>
  8035aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ad:	8b 00                	mov    (%eax),%eax
  8035af:	8b 55 08             	mov    0x8(%ebp),%edx
  8035b2:	89 50 04             	mov    %edx,0x4(%eax)
  8035b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8035bb:	89 10                	mov    %edx,(%eax)
  8035bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035c3:	89 50 04             	mov    %edx,0x4(%eax)
  8035c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c9:	8b 00                	mov    (%eax),%eax
  8035cb:	85 c0                	test   %eax,%eax
  8035cd:	75 08                	jne    8035d7 <insert_sorted_with_merge_freeList+0x703>
  8035cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8035d7:	a1 44 51 80 00       	mov    0x805144,%eax
  8035dc:	40                   	inc    %eax
  8035dd:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  8035e2:	eb 39                	jmp    80361d <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8035e4:	a1 40 51 80 00       	mov    0x805140,%eax
  8035e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8035ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035f0:	74 07                	je     8035f9 <insert_sorted_with_merge_freeList+0x725>
  8035f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035f5:	8b 00                	mov    (%eax),%eax
  8035f7:	eb 05                	jmp    8035fe <insert_sorted_with_merge_freeList+0x72a>
  8035f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8035fe:	a3 40 51 80 00       	mov    %eax,0x805140
  803603:	a1 40 51 80 00       	mov    0x805140,%eax
  803608:	85 c0                	test   %eax,%eax
  80360a:	0f 85 c7 fb ff ff    	jne    8031d7 <insert_sorted_with_merge_freeList+0x303>
  803610:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803614:	0f 85 bd fb ff ff    	jne    8031d7 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80361a:	eb 01                	jmp    80361d <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80361c:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80361d:	90                   	nop
  80361e:	c9                   	leave  
  80361f:	c3                   	ret    

00803620 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803620:	55                   	push   %ebp
  803621:	89 e5                	mov    %esp,%ebp
  803623:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803626:	8b 55 08             	mov    0x8(%ebp),%edx
  803629:	89 d0                	mov    %edx,%eax
  80362b:	c1 e0 02             	shl    $0x2,%eax
  80362e:	01 d0                	add    %edx,%eax
  803630:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803637:	01 d0                	add    %edx,%eax
  803639:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803640:	01 d0                	add    %edx,%eax
  803642:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803649:	01 d0                	add    %edx,%eax
  80364b:	c1 e0 04             	shl    $0x4,%eax
  80364e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803651:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  803658:	8d 45 e8             	lea    -0x18(%ebp),%eax
  80365b:	83 ec 0c             	sub    $0xc,%esp
  80365e:	50                   	push   %eax
  80365f:	e8 26 e7 ff ff       	call   801d8a <sys_get_virtual_time>
  803664:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803667:	eb 41                	jmp    8036aa <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  803669:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80366c:	83 ec 0c             	sub    $0xc,%esp
  80366f:	50                   	push   %eax
  803670:	e8 15 e7 ff ff       	call   801d8a <sys_get_virtual_time>
  803675:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803678:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80367b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80367e:	29 c2                	sub    %eax,%edx
  803680:	89 d0                	mov    %edx,%eax
  803682:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803685:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803688:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80368b:	89 d1                	mov    %edx,%ecx
  80368d:	29 c1                	sub    %eax,%ecx
  80368f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803692:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803695:	39 c2                	cmp    %eax,%edx
  803697:	0f 97 c0             	seta   %al
  80369a:	0f b6 c0             	movzbl %al,%eax
  80369d:	29 c1                	sub    %eax,%ecx
  80369f:	89 c8                	mov    %ecx,%eax
  8036a1:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8036a4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8036a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8036aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036ad:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8036b0:	72 b7                	jb     803669 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8036b2:	90                   	nop
  8036b3:	c9                   	leave  
  8036b4:	c3                   	ret    

008036b5 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8036b5:	55                   	push   %ebp
  8036b6:	89 e5                	mov    %esp,%ebp
  8036b8:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8036bb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8036c2:	eb 03                	jmp    8036c7 <busy_wait+0x12>
  8036c4:	ff 45 fc             	incl   -0x4(%ebp)
  8036c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8036ca:	3b 45 08             	cmp    0x8(%ebp),%eax
  8036cd:	72 f5                	jb     8036c4 <busy_wait+0xf>
	return i;
  8036cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8036d2:	c9                   	leave  
  8036d3:	c3                   	ret    

008036d4 <__udivdi3>:
  8036d4:	55                   	push   %ebp
  8036d5:	57                   	push   %edi
  8036d6:	56                   	push   %esi
  8036d7:	53                   	push   %ebx
  8036d8:	83 ec 1c             	sub    $0x1c,%esp
  8036db:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8036df:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8036e3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8036e7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8036eb:	89 ca                	mov    %ecx,%edx
  8036ed:	89 f8                	mov    %edi,%eax
  8036ef:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8036f3:	85 f6                	test   %esi,%esi
  8036f5:	75 2d                	jne    803724 <__udivdi3+0x50>
  8036f7:	39 cf                	cmp    %ecx,%edi
  8036f9:	77 65                	ja     803760 <__udivdi3+0x8c>
  8036fb:	89 fd                	mov    %edi,%ebp
  8036fd:	85 ff                	test   %edi,%edi
  8036ff:	75 0b                	jne    80370c <__udivdi3+0x38>
  803701:	b8 01 00 00 00       	mov    $0x1,%eax
  803706:	31 d2                	xor    %edx,%edx
  803708:	f7 f7                	div    %edi
  80370a:	89 c5                	mov    %eax,%ebp
  80370c:	31 d2                	xor    %edx,%edx
  80370e:	89 c8                	mov    %ecx,%eax
  803710:	f7 f5                	div    %ebp
  803712:	89 c1                	mov    %eax,%ecx
  803714:	89 d8                	mov    %ebx,%eax
  803716:	f7 f5                	div    %ebp
  803718:	89 cf                	mov    %ecx,%edi
  80371a:	89 fa                	mov    %edi,%edx
  80371c:	83 c4 1c             	add    $0x1c,%esp
  80371f:	5b                   	pop    %ebx
  803720:	5e                   	pop    %esi
  803721:	5f                   	pop    %edi
  803722:	5d                   	pop    %ebp
  803723:	c3                   	ret    
  803724:	39 ce                	cmp    %ecx,%esi
  803726:	77 28                	ja     803750 <__udivdi3+0x7c>
  803728:	0f bd fe             	bsr    %esi,%edi
  80372b:	83 f7 1f             	xor    $0x1f,%edi
  80372e:	75 40                	jne    803770 <__udivdi3+0x9c>
  803730:	39 ce                	cmp    %ecx,%esi
  803732:	72 0a                	jb     80373e <__udivdi3+0x6a>
  803734:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803738:	0f 87 9e 00 00 00    	ja     8037dc <__udivdi3+0x108>
  80373e:	b8 01 00 00 00       	mov    $0x1,%eax
  803743:	89 fa                	mov    %edi,%edx
  803745:	83 c4 1c             	add    $0x1c,%esp
  803748:	5b                   	pop    %ebx
  803749:	5e                   	pop    %esi
  80374a:	5f                   	pop    %edi
  80374b:	5d                   	pop    %ebp
  80374c:	c3                   	ret    
  80374d:	8d 76 00             	lea    0x0(%esi),%esi
  803750:	31 ff                	xor    %edi,%edi
  803752:	31 c0                	xor    %eax,%eax
  803754:	89 fa                	mov    %edi,%edx
  803756:	83 c4 1c             	add    $0x1c,%esp
  803759:	5b                   	pop    %ebx
  80375a:	5e                   	pop    %esi
  80375b:	5f                   	pop    %edi
  80375c:	5d                   	pop    %ebp
  80375d:	c3                   	ret    
  80375e:	66 90                	xchg   %ax,%ax
  803760:	89 d8                	mov    %ebx,%eax
  803762:	f7 f7                	div    %edi
  803764:	31 ff                	xor    %edi,%edi
  803766:	89 fa                	mov    %edi,%edx
  803768:	83 c4 1c             	add    $0x1c,%esp
  80376b:	5b                   	pop    %ebx
  80376c:	5e                   	pop    %esi
  80376d:	5f                   	pop    %edi
  80376e:	5d                   	pop    %ebp
  80376f:	c3                   	ret    
  803770:	bd 20 00 00 00       	mov    $0x20,%ebp
  803775:	89 eb                	mov    %ebp,%ebx
  803777:	29 fb                	sub    %edi,%ebx
  803779:	89 f9                	mov    %edi,%ecx
  80377b:	d3 e6                	shl    %cl,%esi
  80377d:	89 c5                	mov    %eax,%ebp
  80377f:	88 d9                	mov    %bl,%cl
  803781:	d3 ed                	shr    %cl,%ebp
  803783:	89 e9                	mov    %ebp,%ecx
  803785:	09 f1                	or     %esi,%ecx
  803787:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80378b:	89 f9                	mov    %edi,%ecx
  80378d:	d3 e0                	shl    %cl,%eax
  80378f:	89 c5                	mov    %eax,%ebp
  803791:	89 d6                	mov    %edx,%esi
  803793:	88 d9                	mov    %bl,%cl
  803795:	d3 ee                	shr    %cl,%esi
  803797:	89 f9                	mov    %edi,%ecx
  803799:	d3 e2                	shl    %cl,%edx
  80379b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80379f:	88 d9                	mov    %bl,%cl
  8037a1:	d3 e8                	shr    %cl,%eax
  8037a3:	09 c2                	or     %eax,%edx
  8037a5:	89 d0                	mov    %edx,%eax
  8037a7:	89 f2                	mov    %esi,%edx
  8037a9:	f7 74 24 0c          	divl   0xc(%esp)
  8037ad:	89 d6                	mov    %edx,%esi
  8037af:	89 c3                	mov    %eax,%ebx
  8037b1:	f7 e5                	mul    %ebp
  8037b3:	39 d6                	cmp    %edx,%esi
  8037b5:	72 19                	jb     8037d0 <__udivdi3+0xfc>
  8037b7:	74 0b                	je     8037c4 <__udivdi3+0xf0>
  8037b9:	89 d8                	mov    %ebx,%eax
  8037bb:	31 ff                	xor    %edi,%edi
  8037bd:	e9 58 ff ff ff       	jmp    80371a <__udivdi3+0x46>
  8037c2:	66 90                	xchg   %ax,%ax
  8037c4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8037c8:	89 f9                	mov    %edi,%ecx
  8037ca:	d3 e2                	shl    %cl,%edx
  8037cc:	39 c2                	cmp    %eax,%edx
  8037ce:	73 e9                	jae    8037b9 <__udivdi3+0xe5>
  8037d0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8037d3:	31 ff                	xor    %edi,%edi
  8037d5:	e9 40 ff ff ff       	jmp    80371a <__udivdi3+0x46>
  8037da:	66 90                	xchg   %ax,%ax
  8037dc:	31 c0                	xor    %eax,%eax
  8037de:	e9 37 ff ff ff       	jmp    80371a <__udivdi3+0x46>
  8037e3:	90                   	nop

008037e4 <__umoddi3>:
  8037e4:	55                   	push   %ebp
  8037e5:	57                   	push   %edi
  8037e6:	56                   	push   %esi
  8037e7:	53                   	push   %ebx
  8037e8:	83 ec 1c             	sub    $0x1c,%esp
  8037eb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8037ef:	8b 74 24 34          	mov    0x34(%esp),%esi
  8037f3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8037f7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8037fb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8037ff:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803803:	89 f3                	mov    %esi,%ebx
  803805:	89 fa                	mov    %edi,%edx
  803807:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80380b:	89 34 24             	mov    %esi,(%esp)
  80380e:	85 c0                	test   %eax,%eax
  803810:	75 1a                	jne    80382c <__umoddi3+0x48>
  803812:	39 f7                	cmp    %esi,%edi
  803814:	0f 86 a2 00 00 00    	jbe    8038bc <__umoddi3+0xd8>
  80381a:	89 c8                	mov    %ecx,%eax
  80381c:	89 f2                	mov    %esi,%edx
  80381e:	f7 f7                	div    %edi
  803820:	89 d0                	mov    %edx,%eax
  803822:	31 d2                	xor    %edx,%edx
  803824:	83 c4 1c             	add    $0x1c,%esp
  803827:	5b                   	pop    %ebx
  803828:	5e                   	pop    %esi
  803829:	5f                   	pop    %edi
  80382a:	5d                   	pop    %ebp
  80382b:	c3                   	ret    
  80382c:	39 f0                	cmp    %esi,%eax
  80382e:	0f 87 ac 00 00 00    	ja     8038e0 <__umoddi3+0xfc>
  803834:	0f bd e8             	bsr    %eax,%ebp
  803837:	83 f5 1f             	xor    $0x1f,%ebp
  80383a:	0f 84 ac 00 00 00    	je     8038ec <__umoddi3+0x108>
  803840:	bf 20 00 00 00       	mov    $0x20,%edi
  803845:	29 ef                	sub    %ebp,%edi
  803847:	89 fe                	mov    %edi,%esi
  803849:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80384d:	89 e9                	mov    %ebp,%ecx
  80384f:	d3 e0                	shl    %cl,%eax
  803851:	89 d7                	mov    %edx,%edi
  803853:	89 f1                	mov    %esi,%ecx
  803855:	d3 ef                	shr    %cl,%edi
  803857:	09 c7                	or     %eax,%edi
  803859:	89 e9                	mov    %ebp,%ecx
  80385b:	d3 e2                	shl    %cl,%edx
  80385d:	89 14 24             	mov    %edx,(%esp)
  803860:	89 d8                	mov    %ebx,%eax
  803862:	d3 e0                	shl    %cl,%eax
  803864:	89 c2                	mov    %eax,%edx
  803866:	8b 44 24 08          	mov    0x8(%esp),%eax
  80386a:	d3 e0                	shl    %cl,%eax
  80386c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803870:	8b 44 24 08          	mov    0x8(%esp),%eax
  803874:	89 f1                	mov    %esi,%ecx
  803876:	d3 e8                	shr    %cl,%eax
  803878:	09 d0                	or     %edx,%eax
  80387a:	d3 eb                	shr    %cl,%ebx
  80387c:	89 da                	mov    %ebx,%edx
  80387e:	f7 f7                	div    %edi
  803880:	89 d3                	mov    %edx,%ebx
  803882:	f7 24 24             	mull   (%esp)
  803885:	89 c6                	mov    %eax,%esi
  803887:	89 d1                	mov    %edx,%ecx
  803889:	39 d3                	cmp    %edx,%ebx
  80388b:	0f 82 87 00 00 00    	jb     803918 <__umoddi3+0x134>
  803891:	0f 84 91 00 00 00    	je     803928 <__umoddi3+0x144>
  803897:	8b 54 24 04          	mov    0x4(%esp),%edx
  80389b:	29 f2                	sub    %esi,%edx
  80389d:	19 cb                	sbb    %ecx,%ebx
  80389f:	89 d8                	mov    %ebx,%eax
  8038a1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8038a5:	d3 e0                	shl    %cl,%eax
  8038a7:	89 e9                	mov    %ebp,%ecx
  8038a9:	d3 ea                	shr    %cl,%edx
  8038ab:	09 d0                	or     %edx,%eax
  8038ad:	89 e9                	mov    %ebp,%ecx
  8038af:	d3 eb                	shr    %cl,%ebx
  8038b1:	89 da                	mov    %ebx,%edx
  8038b3:	83 c4 1c             	add    $0x1c,%esp
  8038b6:	5b                   	pop    %ebx
  8038b7:	5e                   	pop    %esi
  8038b8:	5f                   	pop    %edi
  8038b9:	5d                   	pop    %ebp
  8038ba:	c3                   	ret    
  8038bb:	90                   	nop
  8038bc:	89 fd                	mov    %edi,%ebp
  8038be:	85 ff                	test   %edi,%edi
  8038c0:	75 0b                	jne    8038cd <__umoddi3+0xe9>
  8038c2:	b8 01 00 00 00       	mov    $0x1,%eax
  8038c7:	31 d2                	xor    %edx,%edx
  8038c9:	f7 f7                	div    %edi
  8038cb:	89 c5                	mov    %eax,%ebp
  8038cd:	89 f0                	mov    %esi,%eax
  8038cf:	31 d2                	xor    %edx,%edx
  8038d1:	f7 f5                	div    %ebp
  8038d3:	89 c8                	mov    %ecx,%eax
  8038d5:	f7 f5                	div    %ebp
  8038d7:	89 d0                	mov    %edx,%eax
  8038d9:	e9 44 ff ff ff       	jmp    803822 <__umoddi3+0x3e>
  8038de:	66 90                	xchg   %ax,%ax
  8038e0:	89 c8                	mov    %ecx,%eax
  8038e2:	89 f2                	mov    %esi,%edx
  8038e4:	83 c4 1c             	add    $0x1c,%esp
  8038e7:	5b                   	pop    %ebx
  8038e8:	5e                   	pop    %esi
  8038e9:	5f                   	pop    %edi
  8038ea:	5d                   	pop    %ebp
  8038eb:	c3                   	ret    
  8038ec:	3b 04 24             	cmp    (%esp),%eax
  8038ef:	72 06                	jb     8038f7 <__umoddi3+0x113>
  8038f1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8038f5:	77 0f                	ja     803906 <__umoddi3+0x122>
  8038f7:	89 f2                	mov    %esi,%edx
  8038f9:	29 f9                	sub    %edi,%ecx
  8038fb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8038ff:	89 14 24             	mov    %edx,(%esp)
  803902:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803906:	8b 44 24 04          	mov    0x4(%esp),%eax
  80390a:	8b 14 24             	mov    (%esp),%edx
  80390d:	83 c4 1c             	add    $0x1c,%esp
  803910:	5b                   	pop    %ebx
  803911:	5e                   	pop    %esi
  803912:	5f                   	pop    %edi
  803913:	5d                   	pop    %ebp
  803914:	c3                   	ret    
  803915:	8d 76 00             	lea    0x0(%esi),%esi
  803918:	2b 04 24             	sub    (%esp),%eax
  80391b:	19 fa                	sbb    %edi,%edx
  80391d:	89 d1                	mov    %edx,%ecx
  80391f:	89 c6                	mov    %eax,%esi
  803921:	e9 71 ff ff ff       	jmp    803897 <__umoddi3+0xb3>
  803926:	66 90                	xchg   %ax,%ax
  803928:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80392c:	72 ea                	jb     803918 <__umoddi3+0x134>
  80392e:	89 d9                	mov    %ebx,%ecx
  803930:	e9 62 ff ff ff       	jmp    803897 <__umoddi3+0xb3>
