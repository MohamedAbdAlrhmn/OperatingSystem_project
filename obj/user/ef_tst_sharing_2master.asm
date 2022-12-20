
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
  80008d:	68 00 3a 80 00       	push   $0x803a00
  800092:	6a 13                	push   $0x13
  800094:	68 1c 3a 80 00       	push   $0x803a1c
  800099:	e8 1d 04 00 00       	call   8004bb <_panic>
	}
	uint32 *x, *y, *z ;

	//x: Readonly
	int freeFrames = sys_calculate_free_frames() ;
  80009e:	e8 71 1a 00 00       	call   801b14 <sys_calculate_free_frames>
  8000a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	x = smalloc("x", 4, 0);
  8000a6:	83 ec 04             	sub    $0x4,%esp
  8000a9:	6a 00                	push   $0x0
  8000ab:	6a 04                	push   $0x4
  8000ad:	68 3a 3a 80 00       	push   $0x803a3a
  8000b2:	e8 8b 17 00 00       	call   801842 <smalloc>
  8000b7:	83 c4 10             	add    $0x10,%esp
  8000ba:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if (x != (uint32*)USER_HEAP_START) panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8000bd:	81 7d e8 00 00 00 80 	cmpl   $0x80000000,-0x18(%ebp)
  8000c4:	74 14                	je     8000da <_main+0xa2>
  8000c6:	83 ec 04             	sub    $0x4,%esp
  8000c9:	68 3c 3a 80 00       	push   $0x803a3c
  8000ce:	6a 1a                	push   $0x1a
  8000d0:	68 1c 3a 80 00       	push   $0x803a1c
  8000d5:	e8 e1 03 00 00       	call   8004bb <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Create(): Wrong allocation- make sure that you allocate the required space in the user environment and add its frames to frames_storage %d %d %d", freeFrames, sys_calculate_free_frames(), freeFrames - sys_calculate_free_frames());
  8000da:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000dd:	e8 32 1a 00 00       	call   801b14 <sys_calculate_free_frames>
  8000e2:	29 c3                	sub    %eax,%ebx
  8000e4:	89 d8                	mov    %ebx,%eax
  8000e6:	83 f8 04             	cmp    $0x4,%eax
  8000e9:	74 28                	je     800113 <_main+0xdb>
  8000eb:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000ee:	e8 21 1a 00 00       	call   801b14 <sys_calculate_free_frames>
  8000f3:	29 c3                	sub    %eax,%ebx
  8000f5:	e8 1a 1a 00 00       	call   801b14 <sys_calculate_free_frames>
  8000fa:	83 ec 08             	sub    $0x8,%esp
  8000fd:	53                   	push   %ebx
  8000fe:	50                   	push   %eax
  8000ff:	ff 75 ec             	pushl  -0x14(%ebp)
  800102:	68 a0 3a 80 00       	push   $0x803aa0
  800107:	6a 1b                	push   $0x1b
  800109:	68 1c 3a 80 00       	push   $0x803a1c
  80010e:	e8 a8 03 00 00       	call   8004bb <_panic>

	//y: Readonly
	freeFrames = sys_calculate_free_frames() ;
  800113:	e8 fc 19 00 00       	call   801b14 <sys_calculate_free_frames>
  800118:	89 45 ec             	mov    %eax,-0x14(%ebp)
	y = smalloc("y", 4, 0);
  80011b:	83 ec 04             	sub    $0x4,%esp
  80011e:	6a 00                	push   $0x0
  800120:	6a 04                	push   $0x4
  800122:	68 31 3b 80 00       	push   $0x803b31
  800127:	e8 16 17 00 00       	call   801842 <smalloc>
  80012c:	83 c4 10             	add    $0x10,%esp
  80012f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (y != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  800132:	81 7d e4 00 10 00 80 	cmpl   $0x80001000,-0x1c(%ebp)
  800139:	74 14                	je     80014f <_main+0x117>
  80013b:	83 ec 04             	sub    $0x4,%esp
  80013e:	68 3c 3a 80 00       	push   $0x803a3c
  800143:	6a 20                	push   $0x20
  800145:	68 1c 3a 80 00       	push   $0x803a1c
  80014a:	e8 6c 03 00 00       	call   8004bb <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1+0+2) panic("Create(): Wrong allocation- make sure that you allocate the required space in the user environment and add its frames to frames_storage %d %d %d", freeFrames, sys_calculate_free_frames(), freeFrames - sys_calculate_free_frames());
  80014f:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  800152:	e8 bd 19 00 00       	call   801b14 <sys_calculate_free_frames>
  800157:	29 c3                	sub    %eax,%ebx
  800159:	89 d8                	mov    %ebx,%eax
  80015b:	83 f8 03             	cmp    $0x3,%eax
  80015e:	74 28                	je     800188 <_main+0x150>
  800160:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  800163:	e8 ac 19 00 00       	call   801b14 <sys_calculate_free_frames>
  800168:	29 c3                	sub    %eax,%ebx
  80016a:	e8 a5 19 00 00       	call   801b14 <sys_calculate_free_frames>
  80016f:	83 ec 08             	sub    $0x8,%esp
  800172:	53                   	push   %ebx
  800173:	50                   	push   %eax
  800174:	ff 75 ec             	pushl  -0x14(%ebp)
  800177:	68 a0 3a 80 00       	push   $0x803aa0
  80017c:	6a 21                	push   $0x21
  80017e:	68 1c 3a 80 00       	push   $0x803a1c
  800183:	e8 33 03 00 00       	call   8004bb <_panic>

	//z: Writable
	freeFrames = sys_calculate_free_frames() ;
  800188:	e8 87 19 00 00       	call   801b14 <sys_calculate_free_frames>
  80018d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	z = smalloc("z", 4, 1);
  800190:	83 ec 04             	sub    $0x4,%esp
  800193:	6a 01                	push   $0x1
  800195:	6a 04                	push   $0x4
  800197:	68 33 3b 80 00       	push   $0x803b33
  80019c:	e8 a1 16 00 00       	call   801842 <smalloc>
  8001a1:	83 c4 10             	add    $0x10,%esp
  8001a4:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (z != (uint32*)(USER_HEAP_START + 2 * PAGE_SIZE)) panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8001a7:	81 7d e0 00 20 00 80 	cmpl   $0x80002000,-0x20(%ebp)
  8001ae:	74 14                	je     8001c4 <_main+0x18c>
  8001b0:	83 ec 04             	sub    $0x4,%esp
  8001b3:	68 3c 3a 80 00       	push   $0x803a3c
  8001b8:	6a 26                	push   $0x26
  8001ba:	68 1c 3a 80 00       	push   $0x803a1c
  8001bf:	e8 f7 02 00 00       	call   8004bb <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1+0+2) panic("Create(): Wrong allocation- make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8001c4:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8001c7:	e8 48 19 00 00       	call   801b14 <sys_calculate_free_frames>
  8001cc:	29 c3                	sub    %eax,%ebx
  8001ce:	89 d8                	mov    %ebx,%eax
  8001d0:	83 f8 03             	cmp    $0x3,%eax
  8001d3:	74 14                	je     8001e9 <_main+0x1b1>
  8001d5:	83 ec 04             	sub    $0x4,%esp
  8001d8:	68 38 3b 80 00       	push   $0x803b38
  8001dd:	6a 27                	push   $0x27
  8001df:	68 1c 3a 80 00       	push   $0x803a1c
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
  800214:	68 c0 3b 80 00       	push   $0x803bc0
  800219:	e8 68 1b 00 00       	call   801d86 <sys_create_env>
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
  80023d:	68 c0 3b 80 00       	push   $0x803bc0
  800242:	e8 3f 1b 00 00       	call   801d86 <sys_create_env>
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
  800266:	68 c0 3b 80 00       	push   $0x803bc0
  80026b:	e8 16 1b 00 00       	call   801d86 <sys_create_env>
  800270:	83 c4 10             	add    $0x10,%esp
  800273:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	//to check that the slave environments completed successfully
	rsttst();
  800276:	e8 57 1c 00 00       	call   801ed2 <rsttst>

	int* finish_children = smalloc("finish_children", sizeof(int), 1);
  80027b:	83 ec 04             	sub    $0x4,%esp
  80027e:	6a 01                	push   $0x1
  800280:	6a 04                	push   $0x4
  800282:	68 ce 3b 80 00       	push   $0x803bce
  800287:	e8 b6 15 00 00       	call   801842 <smalloc>
  80028c:	83 c4 10             	add    $0x10,%esp
  80028f:	89 45 d0             	mov    %eax,-0x30(%ebp)

	sys_run_env(id1);
  800292:	83 ec 0c             	sub    $0xc,%esp
  800295:	ff 75 dc             	pushl  -0x24(%ebp)
  800298:	e8 07 1b 00 00       	call   801da4 <sys_run_env>
  80029d:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id2);
  8002a0:	83 ec 0c             	sub    $0xc,%esp
  8002a3:	ff 75 d8             	pushl  -0x28(%ebp)
  8002a6:	e8 f9 1a 00 00       	call   801da4 <sys_run_env>
  8002ab:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id3);
  8002ae:	83 ec 0c             	sub    $0xc,%esp
  8002b1:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002b4:	e8 eb 1a 00 00       	call   801da4 <sys_run_env>
  8002b9:	83 c4 10             	add    $0x10,%esp

	env_sleep(15000) ;
  8002bc:	83 ec 0c             	sub    $0xc,%esp
  8002bf:	68 98 3a 00 00       	push   $0x3a98
  8002c4:	e8 0d 34 00 00       	call   8036d6 <env_sleep>
  8002c9:	83 c4 10             	add    $0x10,%esp

	//to ensure that the slave environments completed successfully
	if (gettst()!=3) panic("test failed");
  8002cc:	e8 7b 1c 00 00       	call   801f4c <gettst>
  8002d1:	83 f8 03             	cmp    $0x3,%eax
  8002d4:	74 14                	je     8002ea <_main+0x2b2>
  8002d6:	83 ec 04             	sub    $0x4,%esp
  8002d9:	68 de 3b 80 00       	push   $0x803bde
  8002de:	6a 3d                	push   $0x3d
  8002e0:	68 1c 3a 80 00       	push   $0x803a1c
  8002e5:	e8 d1 01 00 00       	call   8004bb <_panic>


	if (*z != 30)
  8002ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002ed:	8b 00                	mov    (%eax),%eax
  8002ef:	83 f8 1e             	cmp    $0x1e,%eax
  8002f2:	74 14                	je     800308 <_main+0x2d0>
		panic("Error!! Please check the creation (or the getting) of shared 2variables!!\n\n\n");
  8002f4:	83 ec 04             	sub    $0x4,%esp
  8002f7:	68 ec 3b 80 00       	push   $0x803bec
  8002fc:	6a 41                	push   $0x41
  8002fe:	68 1c 3a 80 00       	push   $0x803a1c
  800303:	e8 b3 01 00 00       	call   8004bb <_panic>
	else
		cprintf("Congratulations!! Test of Shared Variables [Create & Get] [2] completed successfully!!\n\n\n");
  800308:	83 ec 0c             	sub    $0xc,%esp
  80030b:	68 3c 3c 80 00       	push   $0x803c3c
  800310:	e8 5a 04 00 00       	call   80076f <cprintf>
  800315:	83 c4 10             	add    $0x10,%esp


	if (sys_getparentenvid() > 0) {
  800318:	e8 f0 1a 00 00       	call   801e0d <sys_getparentenvid>
  80031d:	85 c0                	test   %eax,%eax
  80031f:	7e 58                	jle    800379 <_main+0x341>
		sys_destroy_env(id1);
  800321:	83 ec 0c             	sub    $0xc,%esp
  800324:	ff 75 dc             	pushl  -0x24(%ebp)
  800327:	e8 94 1a 00 00       	call   801dc0 <sys_destroy_env>
  80032c:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(id2);
  80032f:	83 ec 0c             	sub    $0xc,%esp
  800332:	ff 75 d8             	pushl  -0x28(%ebp)
  800335:	e8 86 1a 00 00       	call   801dc0 <sys_destroy_env>
  80033a:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(id3);
  80033d:	83 ec 0c             	sub    $0xc,%esp
  800340:	ff 75 d4             	pushl  -0x2c(%ebp)
  800343:	e8 78 1a 00 00       	call   801dc0 <sys_destroy_env>
  800348:	83 c4 10             	add    $0x10,%esp
		int *finishedCount = NULL;
  80034b:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
		finishedCount = sget(sys_getparentenvid(), "finishedCount") ;
  800352:	e8 b6 1a 00 00       	call   801e0d <sys_getparentenvid>
  800357:	83 ec 08             	sub    $0x8,%esp
  80035a:	68 96 3c 80 00       	push   $0x803c96
  80035f:	50                   	push   %eax
  800360:	e8 8b 15 00 00       	call   8018f0 <sget>
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
  800385:	e8 6a 1a 00 00       	call   801df4 <sys_getenvindex>
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
  8003f0:	e8 0c 18 00 00       	call   801c01 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8003f5:	83 ec 0c             	sub    $0xc,%esp
  8003f8:	68 bc 3c 80 00       	push   $0x803cbc
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
  800420:	68 e4 3c 80 00       	push   $0x803ce4
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
  800451:	68 0c 3d 80 00       	push   $0x803d0c
  800456:	e8 14 03 00 00       	call   80076f <cprintf>
  80045b:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80045e:	a1 20 50 80 00       	mov    0x805020,%eax
  800463:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800469:	83 ec 08             	sub    $0x8,%esp
  80046c:	50                   	push   %eax
  80046d:	68 64 3d 80 00       	push   $0x803d64
  800472:	e8 f8 02 00 00       	call   80076f <cprintf>
  800477:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80047a:	83 ec 0c             	sub    $0xc,%esp
  80047d:	68 bc 3c 80 00       	push   $0x803cbc
  800482:	e8 e8 02 00 00       	call   80076f <cprintf>
  800487:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80048a:	e8 8c 17 00 00       	call   801c1b <sys_enable_interrupt>

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
  8004a2:	e8 19 19 00 00       	call   801dc0 <sys_destroy_env>
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
  8004b3:	e8 6e 19 00 00       	call   801e26 <sys_exit_env>
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
  8004dc:	68 78 3d 80 00       	push   $0x803d78
  8004e1:	e8 89 02 00 00       	call   80076f <cprintf>
  8004e6:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8004e9:	a1 00 50 80 00       	mov    0x805000,%eax
  8004ee:	ff 75 0c             	pushl  0xc(%ebp)
  8004f1:	ff 75 08             	pushl  0x8(%ebp)
  8004f4:	50                   	push   %eax
  8004f5:	68 7d 3d 80 00       	push   $0x803d7d
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
  800519:	68 99 3d 80 00       	push   $0x803d99
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
  800545:	68 9c 3d 80 00       	push   $0x803d9c
  80054a:	6a 26                	push   $0x26
  80054c:	68 e8 3d 80 00       	push   $0x803de8
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
  800617:	68 f4 3d 80 00       	push   $0x803df4
  80061c:	6a 3a                	push   $0x3a
  80061e:	68 e8 3d 80 00       	push   $0x803de8
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
  800687:	68 48 3e 80 00       	push   $0x803e48
  80068c:	6a 44                	push   $0x44
  80068e:	68 e8 3d 80 00       	push   $0x803de8
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
  8006e1:	e8 6d 13 00 00       	call   801a53 <sys_cputs>
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
  800758:	e8 f6 12 00 00       	call   801a53 <sys_cputs>
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
  8007a2:	e8 5a 14 00 00       	call   801c01 <sys_disable_interrupt>
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
  8007c2:	e8 54 14 00 00       	call   801c1b <sys_enable_interrupt>
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
  80080c:	e8 7b 2f 00 00       	call   80378c <__udivdi3>
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
  80085c:	e8 3b 30 00 00       	call   80389c <__umoddi3>
  800861:	83 c4 10             	add    $0x10,%esp
  800864:	05 b4 40 80 00       	add    $0x8040b4,%eax
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
  8009b7:	8b 04 85 d8 40 80 00 	mov    0x8040d8(,%eax,4),%eax
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
  800a98:	8b 34 9d 20 3f 80 00 	mov    0x803f20(,%ebx,4),%esi
  800a9f:	85 f6                	test   %esi,%esi
  800aa1:	75 19                	jne    800abc <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800aa3:	53                   	push   %ebx
  800aa4:	68 c5 40 80 00       	push   $0x8040c5
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
  800abd:	68 ce 40 80 00       	push   $0x8040ce
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
  800aea:	be d1 40 80 00       	mov    $0x8040d1,%esi
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
  801510:	68 30 42 80 00       	push   $0x804230
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
  8015e0:	e8 b2 05 00 00       	call   801b97 <sys_allocate_chunk>
  8015e5:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8015e8:	a1 20 51 80 00       	mov    0x805120,%eax
  8015ed:	83 ec 0c             	sub    $0xc,%esp
  8015f0:	50                   	push   %eax
  8015f1:	e8 27 0c 00 00       	call   80221d <initialize_MemBlocksList>
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
  80161e:	68 55 42 80 00       	push   $0x804255
  801623:	6a 33                	push   $0x33
  801625:	68 73 42 80 00       	push   $0x804273
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
  80169d:	68 80 42 80 00       	push   $0x804280
  8016a2:	6a 34                	push   $0x34
  8016a4:	68 73 42 80 00       	push   $0x804273
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
  801735:	e8 2b 08 00 00       	call   801f65 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80173a:	85 c0                	test   %eax,%eax
  80173c:	74 11                	je     80174f <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  80173e:	83 ec 0c             	sub    $0xc,%esp
  801741:	ff 75 e8             	pushl  -0x18(%ebp)
  801744:	e8 96 0e 00 00       	call   8025df <alloc_block_FF>
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
  80175b:	e8 f2 0b 00 00       	call   802352 <insert_sorted_allocList>
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
  801775:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	struct MemBlock * free_block=find_block(&AllocMemBlocksList,(uint32)virtual_address);
  801778:	8b 45 08             	mov    0x8(%ebp),%eax
  80177b:	83 ec 08             	sub    $0x8,%esp
  80177e:	50                   	push   %eax
  80177f:	68 40 50 80 00       	push   $0x805040
  801784:	e8 71 0b 00 00       	call   8022fa <find_block>
  801789:	83 c4 10             	add    $0x10,%esp
  80178c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(free_block!=NULL)
  80178f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801793:	0f 84 a6 00 00 00    	je     80183f <free+0xcd>
	{
		sys_free_user_mem(free_block->sva,free_block->size);
  801799:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80179c:	8b 50 0c             	mov    0xc(%eax),%edx
  80179f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017a2:	8b 40 08             	mov    0x8(%eax),%eax
  8017a5:	83 ec 08             	sub    $0x8,%esp
  8017a8:	52                   	push   %edx
  8017a9:	50                   	push   %eax
  8017aa:	e8 b0 03 00 00       	call   801b5f <sys_free_user_mem>
  8017af:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,free_block);
  8017b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8017b6:	75 14                	jne    8017cc <free+0x5a>
  8017b8:	83 ec 04             	sub    $0x4,%esp
  8017bb:	68 55 42 80 00       	push   $0x804255
  8017c0:	6a 74                	push   $0x74
  8017c2:	68 73 42 80 00       	push   $0x804273
  8017c7:	e8 ef ec ff ff       	call   8004bb <_panic>
  8017cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017cf:	8b 00                	mov    (%eax),%eax
  8017d1:	85 c0                	test   %eax,%eax
  8017d3:	74 10                	je     8017e5 <free+0x73>
  8017d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017d8:	8b 00                	mov    (%eax),%eax
  8017da:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017dd:	8b 52 04             	mov    0x4(%edx),%edx
  8017e0:	89 50 04             	mov    %edx,0x4(%eax)
  8017e3:	eb 0b                	jmp    8017f0 <free+0x7e>
  8017e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017e8:	8b 40 04             	mov    0x4(%eax),%eax
  8017eb:	a3 44 50 80 00       	mov    %eax,0x805044
  8017f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017f3:	8b 40 04             	mov    0x4(%eax),%eax
  8017f6:	85 c0                	test   %eax,%eax
  8017f8:	74 0f                	je     801809 <free+0x97>
  8017fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017fd:	8b 40 04             	mov    0x4(%eax),%eax
  801800:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801803:	8b 12                	mov    (%edx),%edx
  801805:	89 10                	mov    %edx,(%eax)
  801807:	eb 0a                	jmp    801813 <free+0xa1>
  801809:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80180c:	8b 00                	mov    (%eax),%eax
  80180e:	a3 40 50 80 00       	mov    %eax,0x805040
  801813:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801816:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80181c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80181f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801826:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80182b:	48                   	dec    %eax
  80182c:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(free_block);
  801831:	83 ec 0c             	sub    $0xc,%esp
  801834:	ff 75 f4             	pushl  -0xc(%ebp)
  801837:	e8 4e 17 00 00       	call   802f8a <insert_sorted_with_merge_freeList>
  80183c:	83 c4 10             	add    $0x10,%esp
	}

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  80183f:	90                   	nop
  801840:	c9                   	leave  
  801841:	c3                   	ret    

00801842 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801842:	55                   	push   %ebp
  801843:	89 e5                	mov    %esp,%ebp
  801845:	83 ec 38             	sub    $0x38,%esp
  801848:	8b 45 10             	mov    0x10(%ebp),%eax
  80184b:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80184e:	e8 a6 fc ff ff       	call   8014f9 <InitializeUHeap>
	if (size == 0) return NULL ;
  801853:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801857:	75 0a                	jne    801863 <smalloc+0x21>
  801859:	b8 00 00 00 00       	mov    $0x0,%eax
  80185e:	e9 8b 00 00 00       	jmp    8018ee <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801863:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80186a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80186d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801870:	01 d0                	add    %edx,%eax
  801872:	48                   	dec    %eax
  801873:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801876:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801879:	ba 00 00 00 00       	mov    $0x0,%edx
  80187e:	f7 75 f0             	divl   -0x10(%ebp)
  801881:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801884:	29 d0                	sub    %edx,%eax
  801886:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801889:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801890:	e8 d0 06 00 00       	call   801f65 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801895:	85 c0                	test   %eax,%eax
  801897:	74 11                	je     8018aa <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  801899:	83 ec 0c             	sub    $0xc,%esp
  80189c:	ff 75 e8             	pushl  -0x18(%ebp)
  80189f:	e8 3b 0d 00 00       	call   8025df <alloc_block_FF>
  8018a4:	83 c4 10             	add    $0x10,%esp
  8018a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  8018aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8018ae:	74 39                	je     8018e9 <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8018b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018b3:	8b 40 08             	mov    0x8(%eax),%eax
  8018b6:	89 c2                	mov    %eax,%edx
  8018b8:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8018bc:	52                   	push   %edx
  8018bd:	50                   	push   %eax
  8018be:	ff 75 0c             	pushl  0xc(%ebp)
  8018c1:	ff 75 08             	pushl  0x8(%ebp)
  8018c4:	e8 21 04 00 00       	call   801cea <sys_createSharedObject>
  8018c9:	83 c4 10             	add    $0x10,%esp
  8018cc:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  8018cf:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  8018d3:	74 14                	je     8018e9 <smalloc+0xa7>
  8018d5:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  8018d9:	74 0e                	je     8018e9 <smalloc+0xa7>
  8018db:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  8018df:	74 08                	je     8018e9 <smalloc+0xa7>
			return (void*) mem_block->sva;
  8018e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018e4:	8b 40 08             	mov    0x8(%eax),%eax
  8018e7:	eb 05                	jmp    8018ee <smalloc+0xac>
	}
	return NULL;
  8018e9:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8018ee:	c9                   	leave  
  8018ef:	c3                   	ret    

008018f0 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8018f0:	55                   	push   %ebp
  8018f1:	89 e5                	mov    %esp,%ebp
  8018f3:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8018f6:	e8 fe fb ff ff       	call   8014f9 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8018fb:	83 ec 08             	sub    $0x8,%esp
  8018fe:	ff 75 0c             	pushl  0xc(%ebp)
  801901:	ff 75 08             	pushl  0x8(%ebp)
  801904:	e8 0b 04 00 00       	call   801d14 <sys_getSizeOfSharedObject>
  801909:	83 c4 10             	add    $0x10,%esp
  80190c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  80190f:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  801913:	74 76                	je     80198b <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801915:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80191c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80191f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801922:	01 d0                	add    %edx,%eax
  801924:	48                   	dec    %eax
  801925:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801928:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80192b:	ba 00 00 00 00       	mov    $0x0,%edx
  801930:	f7 75 ec             	divl   -0x14(%ebp)
  801933:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801936:	29 d0                	sub    %edx,%eax
  801938:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  80193b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801942:	e8 1e 06 00 00       	call   801f65 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801947:	85 c0                	test   %eax,%eax
  801949:	74 11                	je     80195c <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  80194b:	83 ec 0c             	sub    $0xc,%esp
  80194e:	ff 75 e4             	pushl  -0x1c(%ebp)
  801951:	e8 89 0c 00 00       	call   8025df <alloc_block_FF>
  801956:	83 c4 10             	add    $0x10,%esp
  801959:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  80195c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801960:	74 29                	je     80198b <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  801962:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801965:	8b 40 08             	mov    0x8(%eax),%eax
  801968:	83 ec 04             	sub    $0x4,%esp
  80196b:	50                   	push   %eax
  80196c:	ff 75 0c             	pushl  0xc(%ebp)
  80196f:	ff 75 08             	pushl  0x8(%ebp)
  801972:	e8 ba 03 00 00       	call   801d31 <sys_getSharedObject>
  801977:	83 c4 10             	add    $0x10,%esp
  80197a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  80197d:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  801981:	74 08                	je     80198b <sget+0x9b>
				return (void *)mem_block->sva;
  801983:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801986:	8b 40 08             	mov    0x8(%eax),%eax
  801989:	eb 05                	jmp    801990 <sget+0xa0>
		}
	}
	return NULL;
  80198b:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801990:	c9                   	leave  
  801991:	c3                   	ret    

00801992 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801992:	55                   	push   %ebp
  801993:	89 e5                	mov    %esp,%ebp
  801995:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801998:	e8 5c fb ff ff       	call   8014f9 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80199d:	83 ec 04             	sub    $0x4,%esp
  8019a0:	68 a4 42 80 00       	push   $0x8042a4
  8019a5:	68 f7 00 00 00       	push   $0xf7
  8019aa:	68 73 42 80 00       	push   $0x804273
  8019af:	e8 07 eb ff ff       	call   8004bb <_panic>

008019b4 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8019b4:	55                   	push   %ebp
  8019b5:	89 e5                	mov    %esp,%ebp
  8019b7:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()


	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8019ba:	83 ec 04             	sub    $0x4,%esp
  8019bd:	68 cc 42 80 00       	push   $0x8042cc
  8019c2:	68 0c 01 00 00       	push   $0x10c
  8019c7:	68 73 42 80 00       	push   $0x804273
  8019cc:	e8 ea ea ff ff       	call   8004bb <_panic>

008019d1 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8019d1:	55                   	push   %ebp
  8019d2:	89 e5                	mov    %esp,%ebp
  8019d4:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019d7:	83 ec 04             	sub    $0x4,%esp
  8019da:	68 f0 42 80 00       	push   $0x8042f0
  8019df:	68 44 01 00 00       	push   $0x144
  8019e4:	68 73 42 80 00       	push   $0x804273
  8019e9:	e8 cd ea ff ff       	call   8004bb <_panic>

008019ee <shrink>:

}
void shrink(uint32 newSize)
{
  8019ee:	55                   	push   %ebp
  8019ef:	89 e5                	mov    %esp,%ebp
  8019f1:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019f4:	83 ec 04             	sub    $0x4,%esp
  8019f7:	68 f0 42 80 00       	push   $0x8042f0
  8019fc:	68 49 01 00 00       	push   $0x149
  801a01:	68 73 42 80 00       	push   $0x804273
  801a06:	e8 b0 ea ff ff       	call   8004bb <_panic>

00801a0b <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801a0b:	55                   	push   %ebp
  801a0c:	89 e5                	mov    %esp,%ebp
  801a0e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a11:	83 ec 04             	sub    $0x4,%esp
  801a14:	68 f0 42 80 00       	push   $0x8042f0
  801a19:	68 4e 01 00 00       	push   $0x14e
  801a1e:	68 73 42 80 00       	push   $0x804273
  801a23:	e8 93 ea ff ff       	call   8004bb <_panic>

00801a28 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801a28:	55                   	push   %ebp
  801a29:	89 e5                	mov    %esp,%ebp
  801a2b:	57                   	push   %edi
  801a2c:	56                   	push   %esi
  801a2d:	53                   	push   %ebx
  801a2e:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a31:	8b 45 08             	mov    0x8(%ebp),%eax
  801a34:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a37:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a3a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a3d:	8b 7d 18             	mov    0x18(%ebp),%edi
  801a40:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801a43:	cd 30                	int    $0x30
  801a45:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801a48:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801a4b:	83 c4 10             	add    $0x10,%esp
  801a4e:	5b                   	pop    %ebx
  801a4f:	5e                   	pop    %esi
  801a50:	5f                   	pop    %edi
  801a51:	5d                   	pop    %ebp
  801a52:	c3                   	ret    

00801a53 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801a53:	55                   	push   %ebp
  801a54:	89 e5                	mov    %esp,%ebp
  801a56:	83 ec 04             	sub    $0x4,%esp
  801a59:	8b 45 10             	mov    0x10(%ebp),%eax
  801a5c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801a5f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a63:	8b 45 08             	mov    0x8(%ebp),%eax
  801a66:	6a 00                	push   $0x0
  801a68:	6a 00                	push   $0x0
  801a6a:	52                   	push   %edx
  801a6b:	ff 75 0c             	pushl  0xc(%ebp)
  801a6e:	50                   	push   %eax
  801a6f:	6a 00                	push   $0x0
  801a71:	e8 b2 ff ff ff       	call   801a28 <syscall>
  801a76:	83 c4 18             	add    $0x18,%esp
}
  801a79:	90                   	nop
  801a7a:	c9                   	leave  
  801a7b:	c3                   	ret    

00801a7c <sys_cgetc>:

int
sys_cgetc(void)
{
  801a7c:	55                   	push   %ebp
  801a7d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801a7f:	6a 00                	push   $0x0
  801a81:	6a 00                	push   $0x0
  801a83:	6a 00                	push   $0x0
  801a85:	6a 00                	push   $0x0
  801a87:	6a 00                	push   $0x0
  801a89:	6a 01                	push   $0x1
  801a8b:	e8 98 ff ff ff       	call   801a28 <syscall>
  801a90:	83 c4 18             	add    $0x18,%esp
}
  801a93:	c9                   	leave  
  801a94:	c3                   	ret    

00801a95 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801a95:	55                   	push   %ebp
  801a96:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801a98:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9e:	6a 00                	push   $0x0
  801aa0:	6a 00                	push   $0x0
  801aa2:	6a 00                	push   $0x0
  801aa4:	52                   	push   %edx
  801aa5:	50                   	push   %eax
  801aa6:	6a 05                	push   $0x5
  801aa8:	e8 7b ff ff ff       	call   801a28 <syscall>
  801aad:	83 c4 18             	add    $0x18,%esp
}
  801ab0:	c9                   	leave  
  801ab1:	c3                   	ret    

00801ab2 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801ab2:	55                   	push   %ebp
  801ab3:	89 e5                	mov    %esp,%ebp
  801ab5:	56                   	push   %esi
  801ab6:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801ab7:	8b 75 18             	mov    0x18(%ebp),%esi
  801aba:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801abd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ac0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac6:	56                   	push   %esi
  801ac7:	53                   	push   %ebx
  801ac8:	51                   	push   %ecx
  801ac9:	52                   	push   %edx
  801aca:	50                   	push   %eax
  801acb:	6a 06                	push   $0x6
  801acd:	e8 56 ff ff ff       	call   801a28 <syscall>
  801ad2:	83 c4 18             	add    $0x18,%esp
}
  801ad5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ad8:	5b                   	pop    %ebx
  801ad9:	5e                   	pop    %esi
  801ada:	5d                   	pop    %ebp
  801adb:	c3                   	ret    

00801adc <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801adc:	55                   	push   %ebp
  801add:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801adf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae5:	6a 00                	push   $0x0
  801ae7:	6a 00                	push   $0x0
  801ae9:	6a 00                	push   $0x0
  801aeb:	52                   	push   %edx
  801aec:	50                   	push   %eax
  801aed:	6a 07                	push   $0x7
  801aef:	e8 34 ff ff ff       	call   801a28 <syscall>
  801af4:	83 c4 18             	add    $0x18,%esp
}
  801af7:	c9                   	leave  
  801af8:	c3                   	ret    

00801af9 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801af9:	55                   	push   %ebp
  801afa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801afc:	6a 00                	push   $0x0
  801afe:	6a 00                	push   $0x0
  801b00:	6a 00                	push   $0x0
  801b02:	ff 75 0c             	pushl  0xc(%ebp)
  801b05:	ff 75 08             	pushl  0x8(%ebp)
  801b08:	6a 08                	push   $0x8
  801b0a:	e8 19 ff ff ff       	call   801a28 <syscall>
  801b0f:	83 c4 18             	add    $0x18,%esp
}
  801b12:	c9                   	leave  
  801b13:	c3                   	ret    

00801b14 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801b14:	55                   	push   %ebp
  801b15:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801b17:	6a 00                	push   $0x0
  801b19:	6a 00                	push   $0x0
  801b1b:	6a 00                	push   $0x0
  801b1d:	6a 00                	push   $0x0
  801b1f:	6a 00                	push   $0x0
  801b21:	6a 09                	push   $0x9
  801b23:	e8 00 ff ff ff       	call   801a28 <syscall>
  801b28:	83 c4 18             	add    $0x18,%esp
}
  801b2b:	c9                   	leave  
  801b2c:	c3                   	ret    

00801b2d <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801b2d:	55                   	push   %ebp
  801b2e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801b30:	6a 00                	push   $0x0
  801b32:	6a 00                	push   $0x0
  801b34:	6a 00                	push   $0x0
  801b36:	6a 00                	push   $0x0
  801b38:	6a 00                	push   $0x0
  801b3a:	6a 0a                	push   $0xa
  801b3c:	e8 e7 fe ff ff       	call   801a28 <syscall>
  801b41:	83 c4 18             	add    $0x18,%esp
}
  801b44:	c9                   	leave  
  801b45:	c3                   	ret    

00801b46 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801b46:	55                   	push   %ebp
  801b47:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 00                	push   $0x0
  801b4f:	6a 00                	push   $0x0
  801b51:	6a 00                	push   $0x0
  801b53:	6a 0b                	push   $0xb
  801b55:	e8 ce fe ff ff       	call   801a28 <syscall>
  801b5a:	83 c4 18             	add    $0x18,%esp
}
  801b5d:	c9                   	leave  
  801b5e:	c3                   	ret    

00801b5f <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801b5f:	55                   	push   %ebp
  801b60:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801b62:	6a 00                	push   $0x0
  801b64:	6a 00                	push   $0x0
  801b66:	6a 00                	push   $0x0
  801b68:	ff 75 0c             	pushl  0xc(%ebp)
  801b6b:	ff 75 08             	pushl  0x8(%ebp)
  801b6e:	6a 0f                	push   $0xf
  801b70:	e8 b3 fe ff ff       	call   801a28 <syscall>
  801b75:	83 c4 18             	add    $0x18,%esp
	return;
  801b78:	90                   	nop
}
  801b79:	c9                   	leave  
  801b7a:	c3                   	ret    

00801b7b <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801b7b:	55                   	push   %ebp
  801b7c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801b7e:	6a 00                	push   $0x0
  801b80:	6a 00                	push   $0x0
  801b82:	6a 00                	push   $0x0
  801b84:	ff 75 0c             	pushl  0xc(%ebp)
  801b87:	ff 75 08             	pushl  0x8(%ebp)
  801b8a:	6a 10                	push   $0x10
  801b8c:	e8 97 fe ff ff       	call   801a28 <syscall>
  801b91:	83 c4 18             	add    $0x18,%esp
	return ;
  801b94:	90                   	nop
}
  801b95:	c9                   	leave  
  801b96:	c3                   	ret    

00801b97 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801b97:	55                   	push   %ebp
  801b98:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801b9a:	6a 00                	push   $0x0
  801b9c:	6a 00                	push   $0x0
  801b9e:	ff 75 10             	pushl  0x10(%ebp)
  801ba1:	ff 75 0c             	pushl  0xc(%ebp)
  801ba4:	ff 75 08             	pushl  0x8(%ebp)
  801ba7:	6a 11                	push   $0x11
  801ba9:	e8 7a fe ff ff       	call   801a28 <syscall>
  801bae:	83 c4 18             	add    $0x18,%esp
	return ;
  801bb1:	90                   	nop
}
  801bb2:	c9                   	leave  
  801bb3:	c3                   	ret    

00801bb4 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801bb4:	55                   	push   %ebp
  801bb5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801bb7:	6a 00                	push   $0x0
  801bb9:	6a 00                	push   $0x0
  801bbb:	6a 00                	push   $0x0
  801bbd:	6a 00                	push   $0x0
  801bbf:	6a 00                	push   $0x0
  801bc1:	6a 0c                	push   $0xc
  801bc3:	e8 60 fe ff ff       	call   801a28 <syscall>
  801bc8:	83 c4 18             	add    $0x18,%esp
}
  801bcb:	c9                   	leave  
  801bcc:	c3                   	ret    

00801bcd <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801bcd:	55                   	push   %ebp
  801bce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801bd0:	6a 00                	push   $0x0
  801bd2:	6a 00                	push   $0x0
  801bd4:	6a 00                	push   $0x0
  801bd6:	6a 00                	push   $0x0
  801bd8:	ff 75 08             	pushl  0x8(%ebp)
  801bdb:	6a 0d                	push   $0xd
  801bdd:	e8 46 fe ff ff       	call   801a28 <syscall>
  801be2:	83 c4 18             	add    $0x18,%esp
}
  801be5:	c9                   	leave  
  801be6:	c3                   	ret    

00801be7 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801be7:	55                   	push   %ebp
  801be8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801bea:	6a 00                	push   $0x0
  801bec:	6a 00                	push   $0x0
  801bee:	6a 00                	push   $0x0
  801bf0:	6a 00                	push   $0x0
  801bf2:	6a 00                	push   $0x0
  801bf4:	6a 0e                	push   $0xe
  801bf6:	e8 2d fe ff ff       	call   801a28 <syscall>
  801bfb:	83 c4 18             	add    $0x18,%esp
}
  801bfe:	90                   	nop
  801bff:	c9                   	leave  
  801c00:	c3                   	ret    

00801c01 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801c01:	55                   	push   %ebp
  801c02:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801c04:	6a 00                	push   $0x0
  801c06:	6a 00                	push   $0x0
  801c08:	6a 00                	push   $0x0
  801c0a:	6a 00                	push   $0x0
  801c0c:	6a 00                	push   $0x0
  801c0e:	6a 13                	push   $0x13
  801c10:	e8 13 fe ff ff       	call   801a28 <syscall>
  801c15:	83 c4 18             	add    $0x18,%esp
}
  801c18:	90                   	nop
  801c19:	c9                   	leave  
  801c1a:	c3                   	ret    

00801c1b <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801c1b:	55                   	push   %ebp
  801c1c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 00                	push   $0x0
  801c22:	6a 00                	push   $0x0
  801c24:	6a 00                	push   $0x0
  801c26:	6a 00                	push   $0x0
  801c28:	6a 14                	push   $0x14
  801c2a:	e8 f9 fd ff ff       	call   801a28 <syscall>
  801c2f:	83 c4 18             	add    $0x18,%esp
}
  801c32:	90                   	nop
  801c33:	c9                   	leave  
  801c34:	c3                   	ret    

00801c35 <sys_cputc>:


void
sys_cputc(const char c)
{
  801c35:	55                   	push   %ebp
  801c36:	89 e5                	mov    %esp,%ebp
  801c38:	83 ec 04             	sub    $0x4,%esp
  801c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801c41:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c45:	6a 00                	push   $0x0
  801c47:	6a 00                	push   $0x0
  801c49:	6a 00                	push   $0x0
  801c4b:	6a 00                	push   $0x0
  801c4d:	50                   	push   %eax
  801c4e:	6a 15                	push   $0x15
  801c50:	e8 d3 fd ff ff       	call   801a28 <syscall>
  801c55:	83 c4 18             	add    $0x18,%esp
}
  801c58:	90                   	nop
  801c59:	c9                   	leave  
  801c5a:	c3                   	ret    

00801c5b <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801c5b:	55                   	push   %ebp
  801c5c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801c5e:	6a 00                	push   $0x0
  801c60:	6a 00                	push   $0x0
  801c62:	6a 00                	push   $0x0
  801c64:	6a 00                	push   $0x0
  801c66:	6a 00                	push   $0x0
  801c68:	6a 16                	push   $0x16
  801c6a:	e8 b9 fd ff ff       	call   801a28 <syscall>
  801c6f:	83 c4 18             	add    $0x18,%esp
}
  801c72:	90                   	nop
  801c73:	c9                   	leave  
  801c74:	c3                   	ret    

00801c75 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801c75:	55                   	push   %ebp
  801c76:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801c78:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7b:	6a 00                	push   $0x0
  801c7d:	6a 00                	push   $0x0
  801c7f:	6a 00                	push   $0x0
  801c81:	ff 75 0c             	pushl  0xc(%ebp)
  801c84:	50                   	push   %eax
  801c85:	6a 17                	push   $0x17
  801c87:	e8 9c fd ff ff       	call   801a28 <syscall>
  801c8c:	83 c4 18             	add    $0x18,%esp
}
  801c8f:	c9                   	leave  
  801c90:	c3                   	ret    

00801c91 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801c91:	55                   	push   %ebp
  801c92:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c94:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c97:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9a:	6a 00                	push   $0x0
  801c9c:	6a 00                	push   $0x0
  801c9e:	6a 00                	push   $0x0
  801ca0:	52                   	push   %edx
  801ca1:	50                   	push   %eax
  801ca2:	6a 1a                	push   $0x1a
  801ca4:	e8 7f fd ff ff       	call   801a28 <syscall>
  801ca9:	83 c4 18             	add    $0x18,%esp
}
  801cac:	c9                   	leave  
  801cad:	c3                   	ret    

00801cae <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801cae:	55                   	push   %ebp
  801caf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801cb1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cb4:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb7:	6a 00                	push   $0x0
  801cb9:	6a 00                	push   $0x0
  801cbb:	6a 00                	push   $0x0
  801cbd:	52                   	push   %edx
  801cbe:	50                   	push   %eax
  801cbf:	6a 18                	push   $0x18
  801cc1:	e8 62 fd ff ff       	call   801a28 <syscall>
  801cc6:	83 c4 18             	add    $0x18,%esp
}
  801cc9:	90                   	nop
  801cca:	c9                   	leave  
  801ccb:	c3                   	ret    

00801ccc <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ccc:	55                   	push   %ebp
  801ccd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ccf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd5:	6a 00                	push   $0x0
  801cd7:	6a 00                	push   $0x0
  801cd9:	6a 00                	push   $0x0
  801cdb:	52                   	push   %edx
  801cdc:	50                   	push   %eax
  801cdd:	6a 19                	push   $0x19
  801cdf:	e8 44 fd ff ff       	call   801a28 <syscall>
  801ce4:	83 c4 18             	add    $0x18,%esp
}
  801ce7:	90                   	nop
  801ce8:	c9                   	leave  
  801ce9:	c3                   	ret    

00801cea <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801cea:	55                   	push   %ebp
  801ceb:	89 e5                	mov    %esp,%ebp
  801ced:	83 ec 04             	sub    $0x4,%esp
  801cf0:	8b 45 10             	mov    0x10(%ebp),%eax
  801cf3:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801cf6:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801cf9:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801cfd:	8b 45 08             	mov    0x8(%ebp),%eax
  801d00:	6a 00                	push   $0x0
  801d02:	51                   	push   %ecx
  801d03:	52                   	push   %edx
  801d04:	ff 75 0c             	pushl  0xc(%ebp)
  801d07:	50                   	push   %eax
  801d08:	6a 1b                	push   $0x1b
  801d0a:	e8 19 fd ff ff       	call   801a28 <syscall>
  801d0f:	83 c4 18             	add    $0x18,%esp
}
  801d12:	c9                   	leave  
  801d13:	c3                   	ret    

00801d14 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801d14:	55                   	push   %ebp
  801d15:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801d17:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1d:	6a 00                	push   $0x0
  801d1f:	6a 00                	push   $0x0
  801d21:	6a 00                	push   $0x0
  801d23:	52                   	push   %edx
  801d24:	50                   	push   %eax
  801d25:	6a 1c                	push   $0x1c
  801d27:	e8 fc fc ff ff       	call   801a28 <syscall>
  801d2c:	83 c4 18             	add    $0x18,%esp
}
  801d2f:	c9                   	leave  
  801d30:	c3                   	ret    

00801d31 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801d31:	55                   	push   %ebp
  801d32:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801d34:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d37:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3d:	6a 00                	push   $0x0
  801d3f:	6a 00                	push   $0x0
  801d41:	51                   	push   %ecx
  801d42:	52                   	push   %edx
  801d43:	50                   	push   %eax
  801d44:	6a 1d                	push   $0x1d
  801d46:	e8 dd fc ff ff       	call   801a28 <syscall>
  801d4b:	83 c4 18             	add    $0x18,%esp
}
  801d4e:	c9                   	leave  
  801d4f:	c3                   	ret    

00801d50 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801d50:	55                   	push   %ebp
  801d51:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801d53:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d56:	8b 45 08             	mov    0x8(%ebp),%eax
  801d59:	6a 00                	push   $0x0
  801d5b:	6a 00                	push   $0x0
  801d5d:	6a 00                	push   $0x0
  801d5f:	52                   	push   %edx
  801d60:	50                   	push   %eax
  801d61:	6a 1e                	push   $0x1e
  801d63:	e8 c0 fc ff ff       	call   801a28 <syscall>
  801d68:	83 c4 18             	add    $0x18,%esp
}
  801d6b:	c9                   	leave  
  801d6c:	c3                   	ret    

00801d6d <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801d6d:	55                   	push   %ebp
  801d6e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801d70:	6a 00                	push   $0x0
  801d72:	6a 00                	push   $0x0
  801d74:	6a 00                	push   $0x0
  801d76:	6a 00                	push   $0x0
  801d78:	6a 00                	push   $0x0
  801d7a:	6a 1f                	push   $0x1f
  801d7c:	e8 a7 fc ff ff       	call   801a28 <syscall>
  801d81:	83 c4 18             	add    $0x18,%esp
}
  801d84:	c9                   	leave  
  801d85:	c3                   	ret    

00801d86 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801d86:	55                   	push   %ebp
  801d87:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801d89:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8c:	6a 00                	push   $0x0
  801d8e:	ff 75 14             	pushl  0x14(%ebp)
  801d91:	ff 75 10             	pushl  0x10(%ebp)
  801d94:	ff 75 0c             	pushl  0xc(%ebp)
  801d97:	50                   	push   %eax
  801d98:	6a 20                	push   $0x20
  801d9a:	e8 89 fc ff ff       	call   801a28 <syscall>
  801d9f:	83 c4 18             	add    $0x18,%esp
}
  801da2:	c9                   	leave  
  801da3:	c3                   	ret    

00801da4 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801da4:	55                   	push   %ebp
  801da5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801da7:	8b 45 08             	mov    0x8(%ebp),%eax
  801daa:	6a 00                	push   $0x0
  801dac:	6a 00                	push   $0x0
  801dae:	6a 00                	push   $0x0
  801db0:	6a 00                	push   $0x0
  801db2:	50                   	push   %eax
  801db3:	6a 21                	push   $0x21
  801db5:	e8 6e fc ff ff       	call   801a28 <syscall>
  801dba:	83 c4 18             	add    $0x18,%esp
}
  801dbd:	90                   	nop
  801dbe:	c9                   	leave  
  801dbf:	c3                   	ret    

00801dc0 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801dc0:	55                   	push   %ebp
  801dc1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc6:	6a 00                	push   $0x0
  801dc8:	6a 00                	push   $0x0
  801dca:	6a 00                	push   $0x0
  801dcc:	6a 00                	push   $0x0
  801dce:	50                   	push   %eax
  801dcf:	6a 22                	push   $0x22
  801dd1:	e8 52 fc ff ff       	call   801a28 <syscall>
  801dd6:	83 c4 18             	add    $0x18,%esp
}
  801dd9:	c9                   	leave  
  801dda:	c3                   	ret    

00801ddb <sys_getenvid>:

int32 sys_getenvid(void)
{
  801ddb:	55                   	push   %ebp
  801ddc:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801dde:	6a 00                	push   $0x0
  801de0:	6a 00                	push   $0x0
  801de2:	6a 00                	push   $0x0
  801de4:	6a 00                	push   $0x0
  801de6:	6a 00                	push   $0x0
  801de8:	6a 02                	push   $0x2
  801dea:	e8 39 fc ff ff       	call   801a28 <syscall>
  801def:	83 c4 18             	add    $0x18,%esp
}
  801df2:	c9                   	leave  
  801df3:	c3                   	ret    

00801df4 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801df4:	55                   	push   %ebp
  801df5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801df7:	6a 00                	push   $0x0
  801df9:	6a 00                	push   $0x0
  801dfb:	6a 00                	push   $0x0
  801dfd:	6a 00                	push   $0x0
  801dff:	6a 00                	push   $0x0
  801e01:	6a 03                	push   $0x3
  801e03:	e8 20 fc ff ff       	call   801a28 <syscall>
  801e08:	83 c4 18             	add    $0x18,%esp
}
  801e0b:	c9                   	leave  
  801e0c:	c3                   	ret    

00801e0d <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801e0d:	55                   	push   %ebp
  801e0e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801e10:	6a 00                	push   $0x0
  801e12:	6a 00                	push   $0x0
  801e14:	6a 00                	push   $0x0
  801e16:	6a 00                	push   $0x0
  801e18:	6a 00                	push   $0x0
  801e1a:	6a 04                	push   $0x4
  801e1c:	e8 07 fc ff ff       	call   801a28 <syscall>
  801e21:	83 c4 18             	add    $0x18,%esp
}
  801e24:	c9                   	leave  
  801e25:	c3                   	ret    

00801e26 <sys_exit_env>:


void sys_exit_env(void)
{
  801e26:	55                   	push   %ebp
  801e27:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801e29:	6a 00                	push   $0x0
  801e2b:	6a 00                	push   $0x0
  801e2d:	6a 00                	push   $0x0
  801e2f:	6a 00                	push   $0x0
  801e31:	6a 00                	push   $0x0
  801e33:	6a 23                	push   $0x23
  801e35:	e8 ee fb ff ff       	call   801a28 <syscall>
  801e3a:	83 c4 18             	add    $0x18,%esp
}
  801e3d:	90                   	nop
  801e3e:	c9                   	leave  
  801e3f:	c3                   	ret    

00801e40 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801e40:	55                   	push   %ebp
  801e41:	89 e5                	mov    %esp,%ebp
  801e43:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801e46:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e49:	8d 50 04             	lea    0x4(%eax),%edx
  801e4c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e4f:	6a 00                	push   $0x0
  801e51:	6a 00                	push   $0x0
  801e53:	6a 00                	push   $0x0
  801e55:	52                   	push   %edx
  801e56:	50                   	push   %eax
  801e57:	6a 24                	push   $0x24
  801e59:	e8 ca fb ff ff       	call   801a28 <syscall>
  801e5e:	83 c4 18             	add    $0x18,%esp
	return result;
  801e61:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e64:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e67:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e6a:	89 01                	mov    %eax,(%ecx)
  801e6c:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801e6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e72:	c9                   	leave  
  801e73:	c2 04 00             	ret    $0x4

00801e76 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801e76:	55                   	push   %ebp
  801e77:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801e79:	6a 00                	push   $0x0
  801e7b:	6a 00                	push   $0x0
  801e7d:	ff 75 10             	pushl  0x10(%ebp)
  801e80:	ff 75 0c             	pushl  0xc(%ebp)
  801e83:	ff 75 08             	pushl  0x8(%ebp)
  801e86:	6a 12                	push   $0x12
  801e88:	e8 9b fb ff ff       	call   801a28 <syscall>
  801e8d:	83 c4 18             	add    $0x18,%esp
	return ;
  801e90:	90                   	nop
}
  801e91:	c9                   	leave  
  801e92:	c3                   	ret    

00801e93 <sys_rcr2>:
uint32 sys_rcr2()
{
  801e93:	55                   	push   %ebp
  801e94:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801e96:	6a 00                	push   $0x0
  801e98:	6a 00                	push   $0x0
  801e9a:	6a 00                	push   $0x0
  801e9c:	6a 00                	push   $0x0
  801e9e:	6a 00                	push   $0x0
  801ea0:	6a 25                	push   $0x25
  801ea2:	e8 81 fb ff ff       	call   801a28 <syscall>
  801ea7:	83 c4 18             	add    $0x18,%esp
}
  801eaa:	c9                   	leave  
  801eab:	c3                   	ret    

00801eac <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801eac:	55                   	push   %ebp
  801ead:	89 e5                	mov    %esp,%ebp
  801eaf:	83 ec 04             	sub    $0x4,%esp
  801eb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801eb8:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801ebc:	6a 00                	push   $0x0
  801ebe:	6a 00                	push   $0x0
  801ec0:	6a 00                	push   $0x0
  801ec2:	6a 00                	push   $0x0
  801ec4:	50                   	push   %eax
  801ec5:	6a 26                	push   $0x26
  801ec7:	e8 5c fb ff ff       	call   801a28 <syscall>
  801ecc:	83 c4 18             	add    $0x18,%esp
	return ;
  801ecf:	90                   	nop
}
  801ed0:	c9                   	leave  
  801ed1:	c3                   	ret    

00801ed2 <rsttst>:
void rsttst()
{
  801ed2:	55                   	push   %ebp
  801ed3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801ed5:	6a 00                	push   $0x0
  801ed7:	6a 00                	push   $0x0
  801ed9:	6a 00                	push   $0x0
  801edb:	6a 00                	push   $0x0
  801edd:	6a 00                	push   $0x0
  801edf:	6a 28                	push   $0x28
  801ee1:	e8 42 fb ff ff       	call   801a28 <syscall>
  801ee6:	83 c4 18             	add    $0x18,%esp
	return ;
  801ee9:	90                   	nop
}
  801eea:	c9                   	leave  
  801eeb:	c3                   	ret    

00801eec <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801eec:	55                   	push   %ebp
  801eed:	89 e5                	mov    %esp,%ebp
  801eef:	83 ec 04             	sub    $0x4,%esp
  801ef2:	8b 45 14             	mov    0x14(%ebp),%eax
  801ef5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ef8:	8b 55 18             	mov    0x18(%ebp),%edx
  801efb:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801eff:	52                   	push   %edx
  801f00:	50                   	push   %eax
  801f01:	ff 75 10             	pushl  0x10(%ebp)
  801f04:	ff 75 0c             	pushl  0xc(%ebp)
  801f07:	ff 75 08             	pushl  0x8(%ebp)
  801f0a:	6a 27                	push   $0x27
  801f0c:	e8 17 fb ff ff       	call   801a28 <syscall>
  801f11:	83 c4 18             	add    $0x18,%esp
	return ;
  801f14:	90                   	nop
}
  801f15:	c9                   	leave  
  801f16:	c3                   	ret    

00801f17 <chktst>:
void chktst(uint32 n)
{
  801f17:	55                   	push   %ebp
  801f18:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801f1a:	6a 00                	push   $0x0
  801f1c:	6a 00                	push   $0x0
  801f1e:	6a 00                	push   $0x0
  801f20:	6a 00                	push   $0x0
  801f22:	ff 75 08             	pushl  0x8(%ebp)
  801f25:	6a 29                	push   $0x29
  801f27:	e8 fc fa ff ff       	call   801a28 <syscall>
  801f2c:	83 c4 18             	add    $0x18,%esp
	return ;
  801f2f:	90                   	nop
}
  801f30:	c9                   	leave  
  801f31:	c3                   	ret    

00801f32 <inctst>:

void inctst()
{
  801f32:	55                   	push   %ebp
  801f33:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801f35:	6a 00                	push   $0x0
  801f37:	6a 00                	push   $0x0
  801f39:	6a 00                	push   $0x0
  801f3b:	6a 00                	push   $0x0
  801f3d:	6a 00                	push   $0x0
  801f3f:	6a 2a                	push   $0x2a
  801f41:	e8 e2 fa ff ff       	call   801a28 <syscall>
  801f46:	83 c4 18             	add    $0x18,%esp
	return ;
  801f49:	90                   	nop
}
  801f4a:	c9                   	leave  
  801f4b:	c3                   	ret    

00801f4c <gettst>:
uint32 gettst()
{
  801f4c:	55                   	push   %ebp
  801f4d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801f4f:	6a 00                	push   $0x0
  801f51:	6a 00                	push   $0x0
  801f53:	6a 00                	push   $0x0
  801f55:	6a 00                	push   $0x0
  801f57:	6a 00                	push   $0x0
  801f59:	6a 2b                	push   $0x2b
  801f5b:	e8 c8 fa ff ff       	call   801a28 <syscall>
  801f60:	83 c4 18             	add    $0x18,%esp
}
  801f63:	c9                   	leave  
  801f64:	c3                   	ret    

00801f65 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801f65:	55                   	push   %ebp
  801f66:	89 e5                	mov    %esp,%ebp
  801f68:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f6b:	6a 00                	push   $0x0
  801f6d:	6a 00                	push   $0x0
  801f6f:	6a 00                	push   $0x0
  801f71:	6a 00                	push   $0x0
  801f73:	6a 00                	push   $0x0
  801f75:	6a 2c                	push   $0x2c
  801f77:	e8 ac fa ff ff       	call   801a28 <syscall>
  801f7c:	83 c4 18             	add    $0x18,%esp
  801f7f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801f82:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801f86:	75 07                	jne    801f8f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801f88:	b8 01 00 00 00       	mov    $0x1,%eax
  801f8d:	eb 05                	jmp    801f94 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801f8f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f94:	c9                   	leave  
  801f95:	c3                   	ret    

00801f96 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801f96:	55                   	push   %ebp
  801f97:	89 e5                	mov    %esp,%ebp
  801f99:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f9c:	6a 00                	push   $0x0
  801f9e:	6a 00                	push   $0x0
  801fa0:	6a 00                	push   $0x0
  801fa2:	6a 00                	push   $0x0
  801fa4:	6a 00                	push   $0x0
  801fa6:	6a 2c                	push   $0x2c
  801fa8:	e8 7b fa ff ff       	call   801a28 <syscall>
  801fad:	83 c4 18             	add    $0x18,%esp
  801fb0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801fb3:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801fb7:	75 07                	jne    801fc0 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801fb9:	b8 01 00 00 00       	mov    $0x1,%eax
  801fbe:	eb 05                	jmp    801fc5 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801fc0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fc5:	c9                   	leave  
  801fc6:	c3                   	ret    

00801fc7 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801fc7:	55                   	push   %ebp
  801fc8:	89 e5                	mov    %esp,%ebp
  801fca:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fcd:	6a 00                	push   $0x0
  801fcf:	6a 00                	push   $0x0
  801fd1:	6a 00                	push   $0x0
  801fd3:	6a 00                	push   $0x0
  801fd5:	6a 00                	push   $0x0
  801fd7:	6a 2c                	push   $0x2c
  801fd9:	e8 4a fa ff ff       	call   801a28 <syscall>
  801fde:	83 c4 18             	add    $0x18,%esp
  801fe1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801fe4:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801fe8:	75 07                	jne    801ff1 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801fea:	b8 01 00 00 00       	mov    $0x1,%eax
  801fef:	eb 05                	jmp    801ff6 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801ff1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ff6:	c9                   	leave  
  801ff7:	c3                   	ret    

00801ff8 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801ff8:	55                   	push   %ebp
  801ff9:	89 e5                	mov    %esp,%ebp
  801ffb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ffe:	6a 00                	push   $0x0
  802000:	6a 00                	push   $0x0
  802002:	6a 00                	push   $0x0
  802004:	6a 00                	push   $0x0
  802006:	6a 00                	push   $0x0
  802008:	6a 2c                	push   $0x2c
  80200a:	e8 19 fa ff ff       	call   801a28 <syscall>
  80200f:	83 c4 18             	add    $0x18,%esp
  802012:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802015:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802019:	75 07                	jne    802022 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80201b:	b8 01 00 00 00       	mov    $0x1,%eax
  802020:	eb 05                	jmp    802027 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802022:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802027:	c9                   	leave  
  802028:	c3                   	ret    

00802029 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802029:	55                   	push   %ebp
  80202a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80202c:	6a 00                	push   $0x0
  80202e:	6a 00                	push   $0x0
  802030:	6a 00                	push   $0x0
  802032:	6a 00                	push   $0x0
  802034:	ff 75 08             	pushl  0x8(%ebp)
  802037:	6a 2d                	push   $0x2d
  802039:	e8 ea f9 ff ff       	call   801a28 <syscall>
  80203e:	83 c4 18             	add    $0x18,%esp
	return ;
  802041:	90                   	nop
}
  802042:	c9                   	leave  
  802043:	c3                   	ret    

00802044 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802044:	55                   	push   %ebp
  802045:	89 e5                	mov    %esp,%ebp
  802047:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802048:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80204b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80204e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802051:	8b 45 08             	mov    0x8(%ebp),%eax
  802054:	6a 00                	push   $0x0
  802056:	53                   	push   %ebx
  802057:	51                   	push   %ecx
  802058:	52                   	push   %edx
  802059:	50                   	push   %eax
  80205a:	6a 2e                	push   $0x2e
  80205c:	e8 c7 f9 ff ff       	call   801a28 <syscall>
  802061:	83 c4 18             	add    $0x18,%esp
}
  802064:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802067:	c9                   	leave  
  802068:	c3                   	ret    

00802069 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802069:	55                   	push   %ebp
  80206a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80206c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80206f:	8b 45 08             	mov    0x8(%ebp),%eax
  802072:	6a 00                	push   $0x0
  802074:	6a 00                	push   $0x0
  802076:	6a 00                	push   $0x0
  802078:	52                   	push   %edx
  802079:	50                   	push   %eax
  80207a:	6a 2f                	push   $0x2f
  80207c:	e8 a7 f9 ff ff       	call   801a28 <syscall>
  802081:	83 c4 18             	add    $0x18,%esp
}
  802084:	c9                   	leave  
  802085:	c3                   	ret    

00802086 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802086:	55                   	push   %ebp
  802087:	89 e5                	mov    %esp,%ebp
  802089:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  80208c:	83 ec 0c             	sub    $0xc,%esp
  80208f:	68 00 43 80 00       	push   $0x804300
  802094:	e8 d6 e6 ff ff       	call   80076f <cprintf>
  802099:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80209c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8020a3:	83 ec 0c             	sub    $0xc,%esp
  8020a6:	68 2c 43 80 00       	push   $0x80432c
  8020ab:	e8 bf e6 ff ff       	call   80076f <cprintf>
  8020b0:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8020b3:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8020b7:	a1 38 51 80 00       	mov    0x805138,%eax
  8020bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020bf:	eb 56                	jmp    802117 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8020c1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020c5:	74 1c                	je     8020e3 <print_mem_block_lists+0x5d>
  8020c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ca:	8b 50 08             	mov    0x8(%eax),%edx
  8020cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020d0:	8b 48 08             	mov    0x8(%eax),%ecx
  8020d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020d6:	8b 40 0c             	mov    0xc(%eax),%eax
  8020d9:	01 c8                	add    %ecx,%eax
  8020db:	39 c2                	cmp    %eax,%edx
  8020dd:	73 04                	jae    8020e3 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8020df:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8020e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e6:	8b 50 08             	mov    0x8(%eax),%edx
  8020e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ec:	8b 40 0c             	mov    0xc(%eax),%eax
  8020ef:	01 c2                	add    %eax,%edx
  8020f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f4:	8b 40 08             	mov    0x8(%eax),%eax
  8020f7:	83 ec 04             	sub    $0x4,%esp
  8020fa:	52                   	push   %edx
  8020fb:	50                   	push   %eax
  8020fc:	68 41 43 80 00       	push   $0x804341
  802101:	e8 69 e6 ff ff       	call   80076f <cprintf>
  802106:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802109:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80210c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80210f:	a1 40 51 80 00       	mov    0x805140,%eax
  802114:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802117:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80211b:	74 07                	je     802124 <print_mem_block_lists+0x9e>
  80211d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802120:	8b 00                	mov    (%eax),%eax
  802122:	eb 05                	jmp    802129 <print_mem_block_lists+0xa3>
  802124:	b8 00 00 00 00       	mov    $0x0,%eax
  802129:	a3 40 51 80 00       	mov    %eax,0x805140
  80212e:	a1 40 51 80 00       	mov    0x805140,%eax
  802133:	85 c0                	test   %eax,%eax
  802135:	75 8a                	jne    8020c1 <print_mem_block_lists+0x3b>
  802137:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80213b:	75 84                	jne    8020c1 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  80213d:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802141:	75 10                	jne    802153 <print_mem_block_lists+0xcd>
  802143:	83 ec 0c             	sub    $0xc,%esp
  802146:	68 50 43 80 00       	push   $0x804350
  80214b:	e8 1f e6 ff ff       	call   80076f <cprintf>
  802150:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802153:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80215a:	83 ec 0c             	sub    $0xc,%esp
  80215d:	68 74 43 80 00       	push   $0x804374
  802162:	e8 08 e6 ff ff       	call   80076f <cprintf>
  802167:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80216a:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80216e:	a1 40 50 80 00       	mov    0x805040,%eax
  802173:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802176:	eb 56                	jmp    8021ce <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802178:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80217c:	74 1c                	je     80219a <print_mem_block_lists+0x114>
  80217e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802181:	8b 50 08             	mov    0x8(%eax),%edx
  802184:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802187:	8b 48 08             	mov    0x8(%eax),%ecx
  80218a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80218d:	8b 40 0c             	mov    0xc(%eax),%eax
  802190:	01 c8                	add    %ecx,%eax
  802192:	39 c2                	cmp    %eax,%edx
  802194:	73 04                	jae    80219a <print_mem_block_lists+0x114>
			sorted = 0 ;
  802196:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80219a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80219d:	8b 50 08             	mov    0x8(%eax),%edx
  8021a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a3:	8b 40 0c             	mov    0xc(%eax),%eax
  8021a6:	01 c2                	add    %eax,%edx
  8021a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ab:	8b 40 08             	mov    0x8(%eax),%eax
  8021ae:	83 ec 04             	sub    $0x4,%esp
  8021b1:	52                   	push   %edx
  8021b2:	50                   	push   %eax
  8021b3:	68 41 43 80 00       	push   $0x804341
  8021b8:	e8 b2 e5 ff ff       	call   80076f <cprintf>
  8021bd:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8021c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8021c6:	a1 48 50 80 00       	mov    0x805048,%eax
  8021cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021d2:	74 07                	je     8021db <print_mem_block_lists+0x155>
  8021d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d7:	8b 00                	mov    (%eax),%eax
  8021d9:	eb 05                	jmp    8021e0 <print_mem_block_lists+0x15a>
  8021db:	b8 00 00 00 00       	mov    $0x0,%eax
  8021e0:	a3 48 50 80 00       	mov    %eax,0x805048
  8021e5:	a1 48 50 80 00       	mov    0x805048,%eax
  8021ea:	85 c0                	test   %eax,%eax
  8021ec:	75 8a                	jne    802178 <print_mem_block_lists+0xf2>
  8021ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021f2:	75 84                	jne    802178 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8021f4:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8021f8:	75 10                	jne    80220a <print_mem_block_lists+0x184>
  8021fa:	83 ec 0c             	sub    $0xc,%esp
  8021fd:	68 8c 43 80 00       	push   $0x80438c
  802202:	e8 68 e5 ff ff       	call   80076f <cprintf>
  802207:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80220a:	83 ec 0c             	sub    $0xc,%esp
  80220d:	68 00 43 80 00       	push   $0x804300
  802212:	e8 58 e5 ff ff       	call   80076f <cprintf>
  802217:	83 c4 10             	add    $0x10,%esp

}
  80221a:	90                   	nop
  80221b:	c9                   	leave  
  80221c:	c3                   	ret    

0080221d <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80221d:	55                   	push   %ebp
  80221e:	89 e5                	mov    %esp,%ebp
  802220:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  802223:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  80222a:	00 00 00 
  80222d:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802234:	00 00 00 
  802237:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  80223e:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  802241:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802248:	e9 9e 00 00 00       	jmp    8022eb <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  80224d:	a1 50 50 80 00       	mov    0x805050,%eax
  802252:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802255:	c1 e2 04             	shl    $0x4,%edx
  802258:	01 d0                	add    %edx,%eax
  80225a:	85 c0                	test   %eax,%eax
  80225c:	75 14                	jne    802272 <initialize_MemBlocksList+0x55>
  80225e:	83 ec 04             	sub    $0x4,%esp
  802261:	68 b4 43 80 00       	push   $0x8043b4
  802266:	6a 46                	push   $0x46
  802268:	68 d7 43 80 00       	push   $0x8043d7
  80226d:	e8 49 e2 ff ff       	call   8004bb <_panic>
  802272:	a1 50 50 80 00       	mov    0x805050,%eax
  802277:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80227a:	c1 e2 04             	shl    $0x4,%edx
  80227d:	01 d0                	add    %edx,%eax
  80227f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802285:	89 10                	mov    %edx,(%eax)
  802287:	8b 00                	mov    (%eax),%eax
  802289:	85 c0                	test   %eax,%eax
  80228b:	74 18                	je     8022a5 <initialize_MemBlocksList+0x88>
  80228d:	a1 48 51 80 00       	mov    0x805148,%eax
  802292:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802298:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80229b:	c1 e1 04             	shl    $0x4,%ecx
  80229e:	01 ca                	add    %ecx,%edx
  8022a0:	89 50 04             	mov    %edx,0x4(%eax)
  8022a3:	eb 12                	jmp    8022b7 <initialize_MemBlocksList+0x9a>
  8022a5:	a1 50 50 80 00       	mov    0x805050,%eax
  8022aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022ad:	c1 e2 04             	shl    $0x4,%edx
  8022b0:	01 d0                	add    %edx,%eax
  8022b2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8022b7:	a1 50 50 80 00       	mov    0x805050,%eax
  8022bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022bf:	c1 e2 04             	shl    $0x4,%edx
  8022c2:	01 d0                	add    %edx,%eax
  8022c4:	a3 48 51 80 00       	mov    %eax,0x805148
  8022c9:	a1 50 50 80 00       	mov    0x805050,%eax
  8022ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022d1:	c1 e2 04             	shl    $0x4,%edx
  8022d4:	01 d0                	add    %edx,%eax
  8022d6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022dd:	a1 54 51 80 00       	mov    0x805154,%eax
  8022e2:	40                   	inc    %eax
  8022e3:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  8022e8:	ff 45 f4             	incl   -0xc(%ebp)
  8022eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ee:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022f1:	0f 82 56 ff ff ff    	jb     80224d <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  8022f7:	90                   	nop
  8022f8:	c9                   	leave  
  8022f9:	c3                   	ret    

008022fa <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8022fa:	55                   	push   %ebp
  8022fb:	89 e5                	mov    %esp,%ebp
  8022fd:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802300:	8b 45 08             	mov    0x8(%ebp),%eax
  802303:	8b 00                	mov    (%eax),%eax
  802305:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802308:	eb 19                	jmp    802323 <find_block+0x29>
	{
		if(va==point->sva)
  80230a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80230d:	8b 40 08             	mov    0x8(%eax),%eax
  802310:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802313:	75 05                	jne    80231a <find_block+0x20>
		   return point;
  802315:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802318:	eb 36                	jmp    802350 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80231a:	8b 45 08             	mov    0x8(%ebp),%eax
  80231d:	8b 40 08             	mov    0x8(%eax),%eax
  802320:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802323:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802327:	74 07                	je     802330 <find_block+0x36>
  802329:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80232c:	8b 00                	mov    (%eax),%eax
  80232e:	eb 05                	jmp    802335 <find_block+0x3b>
  802330:	b8 00 00 00 00       	mov    $0x0,%eax
  802335:	8b 55 08             	mov    0x8(%ebp),%edx
  802338:	89 42 08             	mov    %eax,0x8(%edx)
  80233b:	8b 45 08             	mov    0x8(%ebp),%eax
  80233e:	8b 40 08             	mov    0x8(%eax),%eax
  802341:	85 c0                	test   %eax,%eax
  802343:	75 c5                	jne    80230a <find_block+0x10>
  802345:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802349:	75 bf                	jne    80230a <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  80234b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802350:	c9                   	leave  
  802351:	c3                   	ret    

00802352 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802352:	55                   	push   %ebp
  802353:	89 e5                	mov    %esp,%ebp
  802355:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802358:	a1 40 50 80 00       	mov    0x805040,%eax
  80235d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802360:	a1 44 50 80 00       	mov    0x805044,%eax
  802365:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802368:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80236b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80236e:	74 24                	je     802394 <insert_sorted_allocList+0x42>
  802370:	8b 45 08             	mov    0x8(%ebp),%eax
  802373:	8b 50 08             	mov    0x8(%eax),%edx
  802376:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802379:	8b 40 08             	mov    0x8(%eax),%eax
  80237c:	39 c2                	cmp    %eax,%edx
  80237e:	76 14                	jbe    802394 <insert_sorted_allocList+0x42>
  802380:	8b 45 08             	mov    0x8(%ebp),%eax
  802383:	8b 50 08             	mov    0x8(%eax),%edx
  802386:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802389:	8b 40 08             	mov    0x8(%eax),%eax
  80238c:	39 c2                	cmp    %eax,%edx
  80238e:	0f 82 60 01 00 00    	jb     8024f4 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802394:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802398:	75 65                	jne    8023ff <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  80239a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80239e:	75 14                	jne    8023b4 <insert_sorted_allocList+0x62>
  8023a0:	83 ec 04             	sub    $0x4,%esp
  8023a3:	68 b4 43 80 00       	push   $0x8043b4
  8023a8:	6a 6b                	push   $0x6b
  8023aa:	68 d7 43 80 00       	push   $0x8043d7
  8023af:	e8 07 e1 ff ff       	call   8004bb <_panic>
  8023b4:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8023ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bd:	89 10                	mov    %edx,(%eax)
  8023bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c2:	8b 00                	mov    (%eax),%eax
  8023c4:	85 c0                	test   %eax,%eax
  8023c6:	74 0d                	je     8023d5 <insert_sorted_allocList+0x83>
  8023c8:	a1 40 50 80 00       	mov    0x805040,%eax
  8023cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8023d0:	89 50 04             	mov    %edx,0x4(%eax)
  8023d3:	eb 08                	jmp    8023dd <insert_sorted_allocList+0x8b>
  8023d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d8:	a3 44 50 80 00       	mov    %eax,0x805044
  8023dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e0:	a3 40 50 80 00       	mov    %eax,0x805040
  8023e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023ef:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8023f4:	40                   	inc    %eax
  8023f5:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8023fa:	e9 dc 01 00 00       	jmp    8025db <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8023ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802402:	8b 50 08             	mov    0x8(%eax),%edx
  802405:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802408:	8b 40 08             	mov    0x8(%eax),%eax
  80240b:	39 c2                	cmp    %eax,%edx
  80240d:	77 6c                	ja     80247b <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  80240f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802413:	74 06                	je     80241b <insert_sorted_allocList+0xc9>
  802415:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802419:	75 14                	jne    80242f <insert_sorted_allocList+0xdd>
  80241b:	83 ec 04             	sub    $0x4,%esp
  80241e:	68 f0 43 80 00       	push   $0x8043f0
  802423:	6a 6f                	push   $0x6f
  802425:	68 d7 43 80 00       	push   $0x8043d7
  80242a:	e8 8c e0 ff ff       	call   8004bb <_panic>
  80242f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802432:	8b 50 04             	mov    0x4(%eax),%edx
  802435:	8b 45 08             	mov    0x8(%ebp),%eax
  802438:	89 50 04             	mov    %edx,0x4(%eax)
  80243b:	8b 45 08             	mov    0x8(%ebp),%eax
  80243e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802441:	89 10                	mov    %edx,(%eax)
  802443:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802446:	8b 40 04             	mov    0x4(%eax),%eax
  802449:	85 c0                	test   %eax,%eax
  80244b:	74 0d                	je     80245a <insert_sorted_allocList+0x108>
  80244d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802450:	8b 40 04             	mov    0x4(%eax),%eax
  802453:	8b 55 08             	mov    0x8(%ebp),%edx
  802456:	89 10                	mov    %edx,(%eax)
  802458:	eb 08                	jmp    802462 <insert_sorted_allocList+0x110>
  80245a:	8b 45 08             	mov    0x8(%ebp),%eax
  80245d:	a3 40 50 80 00       	mov    %eax,0x805040
  802462:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802465:	8b 55 08             	mov    0x8(%ebp),%edx
  802468:	89 50 04             	mov    %edx,0x4(%eax)
  80246b:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802470:	40                   	inc    %eax
  802471:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802476:	e9 60 01 00 00       	jmp    8025db <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  80247b:	8b 45 08             	mov    0x8(%ebp),%eax
  80247e:	8b 50 08             	mov    0x8(%eax),%edx
  802481:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802484:	8b 40 08             	mov    0x8(%eax),%eax
  802487:	39 c2                	cmp    %eax,%edx
  802489:	0f 82 4c 01 00 00    	jb     8025db <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  80248f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802493:	75 14                	jne    8024a9 <insert_sorted_allocList+0x157>
  802495:	83 ec 04             	sub    $0x4,%esp
  802498:	68 28 44 80 00       	push   $0x804428
  80249d:	6a 73                	push   $0x73
  80249f:	68 d7 43 80 00       	push   $0x8043d7
  8024a4:	e8 12 e0 ff ff       	call   8004bb <_panic>
  8024a9:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8024af:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b2:	89 50 04             	mov    %edx,0x4(%eax)
  8024b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b8:	8b 40 04             	mov    0x4(%eax),%eax
  8024bb:	85 c0                	test   %eax,%eax
  8024bd:	74 0c                	je     8024cb <insert_sorted_allocList+0x179>
  8024bf:	a1 44 50 80 00       	mov    0x805044,%eax
  8024c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8024c7:	89 10                	mov    %edx,(%eax)
  8024c9:	eb 08                	jmp    8024d3 <insert_sorted_allocList+0x181>
  8024cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ce:	a3 40 50 80 00       	mov    %eax,0x805040
  8024d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d6:	a3 44 50 80 00       	mov    %eax,0x805044
  8024db:	8b 45 08             	mov    0x8(%ebp),%eax
  8024de:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024e4:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8024e9:	40                   	inc    %eax
  8024ea:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8024ef:	e9 e7 00 00 00       	jmp    8025db <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8024f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8024fa:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802501:	a1 40 50 80 00       	mov    0x805040,%eax
  802506:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802509:	e9 9d 00 00 00       	jmp    8025ab <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  80250e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802511:	8b 00                	mov    (%eax),%eax
  802513:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802516:	8b 45 08             	mov    0x8(%ebp),%eax
  802519:	8b 50 08             	mov    0x8(%eax),%edx
  80251c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251f:	8b 40 08             	mov    0x8(%eax),%eax
  802522:	39 c2                	cmp    %eax,%edx
  802524:	76 7d                	jbe    8025a3 <insert_sorted_allocList+0x251>
  802526:	8b 45 08             	mov    0x8(%ebp),%eax
  802529:	8b 50 08             	mov    0x8(%eax),%edx
  80252c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80252f:	8b 40 08             	mov    0x8(%eax),%eax
  802532:	39 c2                	cmp    %eax,%edx
  802534:	73 6d                	jae    8025a3 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802536:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80253a:	74 06                	je     802542 <insert_sorted_allocList+0x1f0>
  80253c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802540:	75 14                	jne    802556 <insert_sorted_allocList+0x204>
  802542:	83 ec 04             	sub    $0x4,%esp
  802545:	68 4c 44 80 00       	push   $0x80444c
  80254a:	6a 7f                	push   $0x7f
  80254c:	68 d7 43 80 00       	push   $0x8043d7
  802551:	e8 65 df ff ff       	call   8004bb <_panic>
  802556:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802559:	8b 10                	mov    (%eax),%edx
  80255b:	8b 45 08             	mov    0x8(%ebp),%eax
  80255e:	89 10                	mov    %edx,(%eax)
  802560:	8b 45 08             	mov    0x8(%ebp),%eax
  802563:	8b 00                	mov    (%eax),%eax
  802565:	85 c0                	test   %eax,%eax
  802567:	74 0b                	je     802574 <insert_sorted_allocList+0x222>
  802569:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256c:	8b 00                	mov    (%eax),%eax
  80256e:	8b 55 08             	mov    0x8(%ebp),%edx
  802571:	89 50 04             	mov    %edx,0x4(%eax)
  802574:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802577:	8b 55 08             	mov    0x8(%ebp),%edx
  80257a:	89 10                	mov    %edx,(%eax)
  80257c:	8b 45 08             	mov    0x8(%ebp),%eax
  80257f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802582:	89 50 04             	mov    %edx,0x4(%eax)
  802585:	8b 45 08             	mov    0x8(%ebp),%eax
  802588:	8b 00                	mov    (%eax),%eax
  80258a:	85 c0                	test   %eax,%eax
  80258c:	75 08                	jne    802596 <insert_sorted_allocList+0x244>
  80258e:	8b 45 08             	mov    0x8(%ebp),%eax
  802591:	a3 44 50 80 00       	mov    %eax,0x805044
  802596:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80259b:	40                   	inc    %eax
  80259c:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8025a1:	eb 39                	jmp    8025dc <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8025a3:	a1 48 50 80 00       	mov    0x805048,%eax
  8025a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025af:	74 07                	je     8025b8 <insert_sorted_allocList+0x266>
  8025b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b4:	8b 00                	mov    (%eax),%eax
  8025b6:	eb 05                	jmp    8025bd <insert_sorted_allocList+0x26b>
  8025b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8025bd:	a3 48 50 80 00       	mov    %eax,0x805048
  8025c2:	a1 48 50 80 00       	mov    0x805048,%eax
  8025c7:	85 c0                	test   %eax,%eax
  8025c9:	0f 85 3f ff ff ff    	jne    80250e <insert_sorted_allocList+0x1bc>
  8025cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025d3:	0f 85 35 ff ff ff    	jne    80250e <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8025d9:	eb 01                	jmp    8025dc <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8025db:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8025dc:	90                   	nop
  8025dd:	c9                   	leave  
  8025de:	c3                   	ret    

008025df <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8025df:	55                   	push   %ebp
  8025e0:	89 e5                	mov    %esp,%ebp
  8025e2:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8025e5:	a1 38 51 80 00       	mov    0x805138,%eax
  8025ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025ed:	e9 85 01 00 00       	jmp    802777 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8025f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f5:	8b 40 0c             	mov    0xc(%eax),%eax
  8025f8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025fb:	0f 82 6e 01 00 00    	jb     80276f <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802601:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802604:	8b 40 0c             	mov    0xc(%eax),%eax
  802607:	3b 45 08             	cmp    0x8(%ebp),%eax
  80260a:	0f 85 8a 00 00 00    	jne    80269a <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802610:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802614:	75 17                	jne    80262d <alloc_block_FF+0x4e>
  802616:	83 ec 04             	sub    $0x4,%esp
  802619:	68 80 44 80 00       	push   $0x804480
  80261e:	68 93 00 00 00       	push   $0x93
  802623:	68 d7 43 80 00       	push   $0x8043d7
  802628:	e8 8e de ff ff       	call   8004bb <_panic>
  80262d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802630:	8b 00                	mov    (%eax),%eax
  802632:	85 c0                	test   %eax,%eax
  802634:	74 10                	je     802646 <alloc_block_FF+0x67>
  802636:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802639:	8b 00                	mov    (%eax),%eax
  80263b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80263e:	8b 52 04             	mov    0x4(%edx),%edx
  802641:	89 50 04             	mov    %edx,0x4(%eax)
  802644:	eb 0b                	jmp    802651 <alloc_block_FF+0x72>
  802646:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802649:	8b 40 04             	mov    0x4(%eax),%eax
  80264c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802651:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802654:	8b 40 04             	mov    0x4(%eax),%eax
  802657:	85 c0                	test   %eax,%eax
  802659:	74 0f                	je     80266a <alloc_block_FF+0x8b>
  80265b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265e:	8b 40 04             	mov    0x4(%eax),%eax
  802661:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802664:	8b 12                	mov    (%edx),%edx
  802666:	89 10                	mov    %edx,(%eax)
  802668:	eb 0a                	jmp    802674 <alloc_block_FF+0x95>
  80266a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266d:	8b 00                	mov    (%eax),%eax
  80266f:	a3 38 51 80 00       	mov    %eax,0x805138
  802674:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802677:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80267d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802680:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802687:	a1 44 51 80 00       	mov    0x805144,%eax
  80268c:	48                   	dec    %eax
  80268d:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802692:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802695:	e9 10 01 00 00       	jmp    8027aa <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  80269a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269d:	8b 40 0c             	mov    0xc(%eax),%eax
  8026a0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026a3:	0f 86 c6 00 00 00    	jbe    80276f <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8026a9:	a1 48 51 80 00       	mov    0x805148,%eax
  8026ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8026b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b4:	8b 50 08             	mov    0x8(%eax),%edx
  8026b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026ba:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8026bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026c0:	8b 55 08             	mov    0x8(%ebp),%edx
  8026c3:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8026c6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026ca:	75 17                	jne    8026e3 <alloc_block_FF+0x104>
  8026cc:	83 ec 04             	sub    $0x4,%esp
  8026cf:	68 80 44 80 00       	push   $0x804480
  8026d4:	68 9b 00 00 00       	push   $0x9b
  8026d9:	68 d7 43 80 00       	push   $0x8043d7
  8026de:	e8 d8 dd ff ff       	call   8004bb <_panic>
  8026e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026e6:	8b 00                	mov    (%eax),%eax
  8026e8:	85 c0                	test   %eax,%eax
  8026ea:	74 10                	je     8026fc <alloc_block_FF+0x11d>
  8026ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026ef:	8b 00                	mov    (%eax),%eax
  8026f1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026f4:	8b 52 04             	mov    0x4(%edx),%edx
  8026f7:	89 50 04             	mov    %edx,0x4(%eax)
  8026fa:	eb 0b                	jmp    802707 <alloc_block_FF+0x128>
  8026fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026ff:	8b 40 04             	mov    0x4(%eax),%eax
  802702:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802707:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80270a:	8b 40 04             	mov    0x4(%eax),%eax
  80270d:	85 c0                	test   %eax,%eax
  80270f:	74 0f                	je     802720 <alloc_block_FF+0x141>
  802711:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802714:	8b 40 04             	mov    0x4(%eax),%eax
  802717:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80271a:	8b 12                	mov    (%edx),%edx
  80271c:	89 10                	mov    %edx,(%eax)
  80271e:	eb 0a                	jmp    80272a <alloc_block_FF+0x14b>
  802720:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802723:	8b 00                	mov    (%eax),%eax
  802725:	a3 48 51 80 00       	mov    %eax,0x805148
  80272a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80272d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802733:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802736:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80273d:	a1 54 51 80 00       	mov    0x805154,%eax
  802742:	48                   	dec    %eax
  802743:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802748:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274b:	8b 50 08             	mov    0x8(%eax),%edx
  80274e:	8b 45 08             	mov    0x8(%ebp),%eax
  802751:	01 c2                	add    %eax,%edx
  802753:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802756:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802759:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275c:	8b 40 0c             	mov    0xc(%eax),%eax
  80275f:	2b 45 08             	sub    0x8(%ebp),%eax
  802762:	89 c2                	mov    %eax,%edx
  802764:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802767:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  80276a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80276d:	eb 3b                	jmp    8027aa <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80276f:	a1 40 51 80 00       	mov    0x805140,%eax
  802774:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802777:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80277b:	74 07                	je     802784 <alloc_block_FF+0x1a5>
  80277d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802780:	8b 00                	mov    (%eax),%eax
  802782:	eb 05                	jmp    802789 <alloc_block_FF+0x1aa>
  802784:	b8 00 00 00 00       	mov    $0x0,%eax
  802789:	a3 40 51 80 00       	mov    %eax,0x805140
  80278e:	a1 40 51 80 00       	mov    0x805140,%eax
  802793:	85 c0                	test   %eax,%eax
  802795:	0f 85 57 fe ff ff    	jne    8025f2 <alloc_block_FF+0x13>
  80279b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80279f:	0f 85 4d fe ff ff    	jne    8025f2 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8027a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027aa:	c9                   	leave  
  8027ab:	c3                   	ret    

008027ac <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8027ac:	55                   	push   %ebp
  8027ad:	89 e5                	mov    %esp,%ebp
  8027af:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8027b2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8027b9:	a1 38 51 80 00       	mov    0x805138,%eax
  8027be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027c1:	e9 df 00 00 00       	jmp    8028a5 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8027c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c9:	8b 40 0c             	mov    0xc(%eax),%eax
  8027cc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027cf:	0f 82 c8 00 00 00    	jb     80289d <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8027d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d8:	8b 40 0c             	mov    0xc(%eax),%eax
  8027db:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027de:	0f 85 8a 00 00 00    	jne    80286e <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8027e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027e8:	75 17                	jne    802801 <alloc_block_BF+0x55>
  8027ea:	83 ec 04             	sub    $0x4,%esp
  8027ed:	68 80 44 80 00       	push   $0x804480
  8027f2:	68 b7 00 00 00       	push   $0xb7
  8027f7:	68 d7 43 80 00       	push   $0x8043d7
  8027fc:	e8 ba dc ff ff       	call   8004bb <_panic>
  802801:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802804:	8b 00                	mov    (%eax),%eax
  802806:	85 c0                	test   %eax,%eax
  802808:	74 10                	je     80281a <alloc_block_BF+0x6e>
  80280a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280d:	8b 00                	mov    (%eax),%eax
  80280f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802812:	8b 52 04             	mov    0x4(%edx),%edx
  802815:	89 50 04             	mov    %edx,0x4(%eax)
  802818:	eb 0b                	jmp    802825 <alloc_block_BF+0x79>
  80281a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281d:	8b 40 04             	mov    0x4(%eax),%eax
  802820:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802825:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802828:	8b 40 04             	mov    0x4(%eax),%eax
  80282b:	85 c0                	test   %eax,%eax
  80282d:	74 0f                	je     80283e <alloc_block_BF+0x92>
  80282f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802832:	8b 40 04             	mov    0x4(%eax),%eax
  802835:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802838:	8b 12                	mov    (%edx),%edx
  80283a:	89 10                	mov    %edx,(%eax)
  80283c:	eb 0a                	jmp    802848 <alloc_block_BF+0x9c>
  80283e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802841:	8b 00                	mov    (%eax),%eax
  802843:	a3 38 51 80 00       	mov    %eax,0x805138
  802848:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802851:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802854:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80285b:	a1 44 51 80 00       	mov    0x805144,%eax
  802860:	48                   	dec    %eax
  802861:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802866:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802869:	e9 4d 01 00 00       	jmp    8029bb <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  80286e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802871:	8b 40 0c             	mov    0xc(%eax),%eax
  802874:	3b 45 08             	cmp    0x8(%ebp),%eax
  802877:	76 24                	jbe    80289d <alloc_block_BF+0xf1>
  802879:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287c:	8b 40 0c             	mov    0xc(%eax),%eax
  80287f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802882:	73 19                	jae    80289d <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802884:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  80288b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288e:	8b 40 0c             	mov    0xc(%eax),%eax
  802891:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802894:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802897:	8b 40 08             	mov    0x8(%eax),%eax
  80289a:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80289d:	a1 40 51 80 00       	mov    0x805140,%eax
  8028a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028a9:	74 07                	je     8028b2 <alloc_block_BF+0x106>
  8028ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ae:	8b 00                	mov    (%eax),%eax
  8028b0:	eb 05                	jmp    8028b7 <alloc_block_BF+0x10b>
  8028b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8028b7:	a3 40 51 80 00       	mov    %eax,0x805140
  8028bc:	a1 40 51 80 00       	mov    0x805140,%eax
  8028c1:	85 c0                	test   %eax,%eax
  8028c3:	0f 85 fd fe ff ff    	jne    8027c6 <alloc_block_BF+0x1a>
  8028c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028cd:	0f 85 f3 fe ff ff    	jne    8027c6 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  8028d3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8028d7:	0f 84 d9 00 00 00    	je     8029b6 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8028dd:	a1 48 51 80 00       	mov    0x805148,%eax
  8028e2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8028e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028e8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028eb:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8028ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8028f4:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  8028f7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8028fb:	75 17                	jne    802914 <alloc_block_BF+0x168>
  8028fd:	83 ec 04             	sub    $0x4,%esp
  802900:	68 80 44 80 00       	push   $0x804480
  802905:	68 c7 00 00 00       	push   $0xc7
  80290a:	68 d7 43 80 00       	push   $0x8043d7
  80290f:	e8 a7 db ff ff       	call   8004bb <_panic>
  802914:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802917:	8b 00                	mov    (%eax),%eax
  802919:	85 c0                	test   %eax,%eax
  80291b:	74 10                	je     80292d <alloc_block_BF+0x181>
  80291d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802920:	8b 00                	mov    (%eax),%eax
  802922:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802925:	8b 52 04             	mov    0x4(%edx),%edx
  802928:	89 50 04             	mov    %edx,0x4(%eax)
  80292b:	eb 0b                	jmp    802938 <alloc_block_BF+0x18c>
  80292d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802930:	8b 40 04             	mov    0x4(%eax),%eax
  802933:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802938:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80293b:	8b 40 04             	mov    0x4(%eax),%eax
  80293e:	85 c0                	test   %eax,%eax
  802940:	74 0f                	je     802951 <alloc_block_BF+0x1a5>
  802942:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802945:	8b 40 04             	mov    0x4(%eax),%eax
  802948:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80294b:	8b 12                	mov    (%edx),%edx
  80294d:	89 10                	mov    %edx,(%eax)
  80294f:	eb 0a                	jmp    80295b <alloc_block_BF+0x1af>
  802951:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802954:	8b 00                	mov    (%eax),%eax
  802956:	a3 48 51 80 00       	mov    %eax,0x805148
  80295b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80295e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802964:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802967:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80296e:	a1 54 51 80 00       	mov    0x805154,%eax
  802973:	48                   	dec    %eax
  802974:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802979:	83 ec 08             	sub    $0x8,%esp
  80297c:	ff 75 ec             	pushl  -0x14(%ebp)
  80297f:	68 38 51 80 00       	push   $0x805138
  802984:	e8 71 f9 ff ff       	call   8022fa <find_block>
  802989:	83 c4 10             	add    $0x10,%esp
  80298c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  80298f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802992:	8b 50 08             	mov    0x8(%eax),%edx
  802995:	8b 45 08             	mov    0x8(%ebp),%eax
  802998:	01 c2                	add    %eax,%edx
  80299a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80299d:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8029a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029a3:	8b 40 0c             	mov    0xc(%eax),%eax
  8029a6:	2b 45 08             	sub    0x8(%ebp),%eax
  8029a9:	89 c2                	mov    %eax,%edx
  8029ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029ae:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8029b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029b4:	eb 05                	jmp    8029bb <alloc_block_BF+0x20f>
	}
	return NULL;
  8029b6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029bb:	c9                   	leave  
  8029bc:	c3                   	ret    

008029bd <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8029bd:	55                   	push   %ebp
  8029be:	89 e5                	mov    %esp,%ebp
  8029c0:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  8029c3:	a1 28 50 80 00       	mov    0x805028,%eax
  8029c8:	85 c0                	test   %eax,%eax
  8029ca:	0f 85 de 01 00 00    	jne    802bae <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8029d0:	a1 38 51 80 00       	mov    0x805138,%eax
  8029d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029d8:	e9 9e 01 00 00       	jmp    802b7b <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8029dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e0:	8b 40 0c             	mov    0xc(%eax),%eax
  8029e3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029e6:	0f 82 87 01 00 00    	jb     802b73 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  8029ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ef:	8b 40 0c             	mov    0xc(%eax),%eax
  8029f2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029f5:	0f 85 95 00 00 00    	jne    802a90 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  8029fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029ff:	75 17                	jne    802a18 <alloc_block_NF+0x5b>
  802a01:	83 ec 04             	sub    $0x4,%esp
  802a04:	68 80 44 80 00       	push   $0x804480
  802a09:	68 e0 00 00 00       	push   $0xe0
  802a0e:	68 d7 43 80 00       	push   $0x8043d7
  802a13:	e8 a3 da ff ff       	call   8004bb <_panic>
  802a18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1b:	8b 00                	mov    (%eax),%eax
  802a1d:	85 c0                	test   %eax,%eax
  802a1f:	74 10                	je     802a31 <alloc_block_NF+0x74>
  802a21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a24:	8b 00                	mov    (%eax),%eax
  802a26:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a29:	8b 52 04             	mov    0x4(%edx),%edx
  802a2c:	89 50 04             	mov    %edx,0x4(%eax)
  802a2f:	eb 0b                	jmp    802a3c <alloc_block_NF+0x7f>
  802a31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a34:	8b 40 04             	mov    0x4(%eax),%eax
  802a37:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3f:	8b 40 04             	mov    0x4(%eax),%eax
  802a42:	85 c0                	test   %eax,%eax
  802a44:	74 0f                	je     802a55 <alloc_block_NF+0x98>
  802a46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a49:	8b 40 04             	mov    0x4(%eax),%eax
  802a4c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a4f:	8b 12                	mov    (%edx),%edx
  802a51:	89 10                	mov    %edx,(%eax)
  802a53:	eb 0a                	jmp    802a5f <alloc_block_NF+0xa2>
  802a55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a58:	8b 00                	mov    (%eax),%eax
  802a5a:	a3 38 51 80 00       	mov    %eax,0x805138
  802a5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a62:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a72:	a1 44 51 80 00       	mov    0x805144,%eax
  802a77:	48                   	dec    %eax
  802a78:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802a7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a80:	8b 40 08             	mov    0x8(%eax),%eax
  802a83:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802a88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8b:	e9 f8 04 00 00       	jmp    802f88 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802a90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a93:	8b 40 0c             	mov    0xc(%eax),%eax
  802a96:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a99:	0f 86 d4 00 00 00    	jbe    802b73 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802a9f:	a1 48 51 80 00       	mov    0x805148,%eax
  802aa4:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802aa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aaa:	8b 50 08             	mov    0x8(%eax),%edx
  802aad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ab0:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802ab3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ab6:	8b 55 08             	mov    0x8(%ebp),%edx
  802ab9:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802abc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ac0:	75 17                	jne    802ad9 <alloc_block_NF+0x11c>
  802ac2:	83 ec 04             	sub    $0x4,%esp
  802ac5:	68 80 44 80 00       	push   $0x804480
  802aca:	68 e9 00 00 00       	push   $0xe9
  802acf:	68 d7 43 80 00       	push   $0x8043d7
  802ad4:	e8 e2 d9 ff ff       	call   8004bb <_panic>
  802ad9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802adc:	8b 00                	mov    (%eax),%eax
  802ade:	85 c0                	test   %eax,%eax
  802ae0:	74 10                	je     802af2 <alloc_block_NF+0x135>
  802ae2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae5:	8b 00                	mov    (%eax),%eax
  802ae7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802aea:	8b 52 04             	mov    0x4(%edx),%edx
  802aed:	89 50 04             	mov    %edx,0x4(%eax)
  802af0:	eb 0b                	jmp    802afd <alloc_block_NF+0x140>
  802af2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802af5:	8b 40 04             	mov    0x4(%eax),%eax
  802af8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802afd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b00:	8b 40 04             	mov    0x4(%eax),%eax
  802b03:	85 c0                	test   %eax,%eax
  802b05:	74 0f                	je     802b16 <alloc_block_NF+0x159>
  802b07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b0a:	8b 40 04             	mov    0x4(%eax),%eax
  802b0d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b10:	8b 12                	mov    (%edx),%edx
  802b12:	89 10                	mov    %edx,(%eax)
  802b14:	eb 0a                	jmp    802b20 <alloc_block_NF+0x163>
  802b16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b19:	8b 00                	mov    (%eax),%eax
  802b1b:	a3 48 51 80 00       	mov    %eax,0x805148
  802b20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b23:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b2c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b33:	a1 54 51 80 00       	mov    0x805154,%eax
  802b38:	48                   	dec    %eax
  802b39:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802b3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b41:	8b 40 08             	mov    0x8(%eax),%eax
  802b44:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802b49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4c:	8b 50 08             	mov    0x8(%eax),%edx
  802b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b52:	01 c2                	add    %eax,%edx
  802b54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b57:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802b5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5d:	8b 40 0c             	mov    0xc(%eax),%eax
  802b60:	2b 45 08             	sub    0x8(%ebp),%eax
  802b63:	89 c2                	mov    %eax,%edx
  802b65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b68:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802b6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b6e:	e9 15 04 00 00       	jmp    802f88 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802b73:	a1 40 51 80 00       	mov    0x805140,%eax
  802b78:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b7b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b7f:	74 07                	je     802b88 <alloc_block_NF+0x1cb>
  802b81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b84:	8b 00                	mov    (%eax),%eax
  802b86:	eb 05                	jmp    802b8d <alloc_block_NF+0x1d0>
  802b88:	b8 00 00 00 00       	mov    $0x0,%eax
  802b8d:	a3 40 51 80 00       	mov    %eax,0x805140
  802b92:	a1 40 51 80 00       	mov    0x805140,%eax
  802b97:	85 c0                	test   %eax,%eax
  802b99:	0f 85 3e fe ff ff    	jne    8029dd <alloc_block_NF+0x20>
  802b9f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ba3:	0f 85 34 fe ff ff    	jne    8029dd <alloc_block_NF+0x20>
  802ba9:	e9 d5 03 00 00       	jmp    802f83 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802bae:	a1 38 51 80 00       	mov    0x805138,%eax
  802bb3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bb6:	e9 b1 01 00 00       	jmp    802d6c <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802bbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bbe:	8b 50 08             	mov    0x8(%eax),%edx
  802bc1:	a1 28 50 80 00       	mov    0x805028,%eax
  802bc6:	39 c2                	cmp    %eax,%edx
  802bc8:	0f 82 96 01 00 00    	jb     802d64 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802bce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd1:	8b 40 0c             	mov    0xc(%eax),%eax
  802bd4:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bd7:	0f 82 87 01 00 00    	jb     802d64 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802bdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be0:	8b 40 0c             	mov    0xc(%eax),%eax
  802be3:	3b 45 08             	cmp    0x8(%ebp),%eax
  802be6:	0f 85 95 00 00 00    	jne    802c81 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802bec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bf0:	75 17                	jne    802c09 <alloc_block_NF+0x24c>
  802bf2:	83 ec 04             	sub    $0x4,%esp
  802bf5:	68 80 44 80 00       	push   $0x804480
  802bfa:	68 fc 00 00 00       	push   $0xfc
  802bff:	68 d7 43 80 00       	push   $0x8043d7
  802c04:	e8 b2 d8 ff ff       	call   8004bb <_panic>
  802c09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0c:	8b 00                	mov    (%eax),%eax
  802c0e:	85 c0                	test   %eax,%eax
  802c10:	74 10                	je     802c22 <alloc_block_NF+0x265>
  802c12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c15:	8b 00                	mov    (%eax),%eax
  802c17:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c1a:	8b 52 04             	mov    0x4(%edx),%edx
  802c1d:	89 50 04             	mov    %edx,0x4(%eax)
  802c20:	eb 0b                	jmp    802c2d <alloc_block_NF+0x270>
  802c22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c25:	8b 40 04             	mov    0x4(%eax),%eax
  802c28:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c30:	8b 40 04             	mov    0x4(%eax),%eax
  802c33:	85 c0                	test   %eax,%eax
  802c35:	74 0f                	je     802c46 <alloc_block_NF+0x289>
  802c37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3a:	8b 40 04             	mov    0x4(%eax),%eax
  802c3d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c40:	8b 12                	mov    (%edx),%edx
  802c42:	89 10                	mov    %edx,(%eax)
  802c44:	eb 0a                	jmp    802c50 <alloc_block_NF+0x293>
  802c46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c49:	8b 00                	mov    (%eax),%eax
  802c4b:	a3 38 51 80 00       	mov    %eax,0x805138
  802c50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c53:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c63:	a1 44 51 80 00       	mov    0x805144,%eax
  802c68:	48                   	dec    %eax
  802c69:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802c6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c71:	8b 40 08             	mov    0x8(%eax),%eax
  802c74:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802c79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7c:	e9 07 03 00 00       	jmp    802f88 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802c81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c84:	8b 40 0c             	mov    0xc(%eax),%eax
  802c87:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c8a:	0f 86 d4 00 00 00    	jbe    802d64 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802c90:	a1 48 51 80 00       	mov    0x805148,%eax
  802c95:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802c98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9b:	8b 50 08             	mov    0x8(%eax),%edx
  802c9e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ca1:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802ca4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ca7:	8b 55 08             	mov    0x8(%ebp),%edx
  802caa:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802cad:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802cb1:	75 17                	jne    802cca <alloc_block_NF+0x30d>
  802cb3:	83 ec 04             	sub    $0x4,%esp
  802cb6:	68 80 44 80 00       	push   $0x804480
  802cbb:	68 04 01 00 00       	push   $0x104
  802cc0:	68 d7 43 80 00       	push   $0x8043d7
  802cc5:	e8 f1 d7 ff ff       	call   8004bb <_panic>
  802cca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ccd:	8b 00                	mov    (%eax),%eax
  802ccf:	85 c0                	test   %eax,%eax
  802cd1:	74 10                	je     802ce3 <alloc_block_NF+0x326>
  802cd3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cd6:	8b 00                	mov    (%eax),%eax
  802cd8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802cdb:	8b 52 04             	mov    0x4(%edx),%edx
  802cde:	89 50 04             	mov    %edx,0x4(%eax)
  802ce1:	eb 0b                	jmp    802cee <alloc_block_NF+0x331>
  802ce3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ce6:	8b 40 04             	mov    0x4(%eax),%eax
  802ce9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802cee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cf1:	8b 40 04             	mov    0x4(%eax),%eax
  802cf4:	85 c0                	test   %eax,%eax
  802cf6:	74 0f                	je     802d07 <alloc_block_NF+0x34a>
  802cf8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cfb:	8b 40 04             	mov    0x4(%eax),%eax
  802cfe:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d01:	8b 12                	mov    (%edx),%edx
  802d03:	89 10                	mov    %edx,(%eax)
  802d05:	eb 0a                	jmp    802d11 <alloc_block_NF+0x354>
  802d07:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d0a:	8b 00                	mov    (%eax),%eax
  802d0c:	a3 48 51 80 00       	mov    %eax,0x805148
  802d11:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d14:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d1a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d1d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d24:	a1 54 51 80 00       	mov    0x805154,%eax
  802d29:	48                   	dec    %eax
  802d2a:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802d2f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d32:	8b 40 08             	mov    0x8(%eax),%eax
  802d35:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802d3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3d:	8b 50 08             	mov    0x8(%eax),%edx
  802d40:	8b 45 08             	mov    0x8(%ebp),%eax
  802d43:	01 c2                	add    %eax,%edx
  802d45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d48:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802d4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4e:	8b 40 0c             	mov    0xc(%eax),%eax
  802d51:	2b 45 08             	sub    0x8(%ebp),%eax
  802d54:	89 c2                	mov    %eax,%edx
  802d56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d59:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802d5c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d5f:	e9 24 02 00 00       	jmp    802f88 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802d64:	a1 40 51 80 00       	mov    0x805140,%eax
  802d69:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d6c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d70:	74 07                	je     802d79 <alloc_block_NF+0x3bc>
  802d72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d75:	8b 00                	mov    (%eax),%eax
  802d77:	eb 05                	jmp    802d7e <alloc_block_NF+0x3c1>
  802d79:	b8 00 00 00 00       	mov    $0x0,%eax
  802d7e:	a3 40 51 80 00       	mov    %eax,0x805140
  802d83:	a1 40 51 80 00       	mov    0x805140,%eax
  802d88:	85 c0                	test   %eax,%eax
  802d8a:	0f 85 2b fe ff ff    	jne    802bbb <alloc_block_NF+0x1fe>
  802d90:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d94:	0f 85 21 fe ff ff    	jne    802bbb <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802d9a:	a1 38 51 80 00       	mov    0x805138,%eax
  802d9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802da2:	e9 ae 01 00 00       	jmp    802f55 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802da7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802daa:	8b 50 08             	mov    0x8(%eax),%edx
  802dad:	a1 28 50 80 00       	mov    0x805028,%eax
  802db2:	39 c2                	cmp    %eax,%edx
  802db4:	0f 83 93 01 00 00    	jae    802f4d <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802dba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbd:	8b 40 0c             	mov    0xc(%eax),%eax
  802dc0:	3b 45 08             	cmp    0x8(%ebp),%eax
  802dc3:	0f 82 84 01 00 00    	jb     802f4d <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802dc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dcc:	8b 40 0c             	mov    0xc(%eax),%eax
  802dcf:	3b 45 08             	cmp    0x8(%ebp),%eax
  802dd2:	0f 85 95 00 00 00    	jne    802e6d <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802dd8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ddc:	75 17                	jne    802df5 <alloc_block_NF+0x438>
  802dde:	83 ec 04             	sub    $0x4,%esp
  802de1:	68 80 44 80 00       	push   $0x804480
  802de6:	68 14 01 00 00       	push   $0x114
  802deb:	68 d7 43 80 00       	push   $0x8043d7
  802df0:	e8 c6 d6 ff ff       	call   8004bb <_panic>
  802df5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df8:	8b 00                	mov    (%eax),%eax
  802dfa:	85 c0                	test   %eax,%eax
  802dfc:	74 10                	je     802e0e <alloc_block_NF+0x451>
  802dfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e01:	8b 00                	mov    (%eax),%eax
  802e03:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e06:	8b 52 04             	mov    0x4(%edx),%edx
  802e09:	89 50 04             	mov    %edx,0x4(%eax)
  802e0c:	eb 0b                	jmp    802e19 <alloc_block_NF+0x45c>
  802e0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e11:	8b 40 04             	mov    0x4(%eax),%eax
  802e14:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1c:	8b 40 04             	mov    0x4(%eax),%eax
  802e1f:	85 c0                	test   %eax,%eax
  802e21:	74 0f                	je     802e32 <alloc_block_NF+0x475>
  802e23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e26:	8b 40 04             	mov    0x4(%eax),%eax
  802e29:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e2c:	8b 12                	mov    (%edx),%edx
  802e2e:	89 10                	mov    %edx,(%eax)
  802e30:	eb 0a                	jmp    802e3c <alloc_block_NF+0x47f>
  802e32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e35:	8b 00                	mov    (%eax),%eax
  802e37:	a3 38 51 80 00       	mov    %eax,0x805138
  802e3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e48:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e4f:	a1 44 51 80 00       	mov    0x805144,%eax
  802e54:	48                   	dec    %eax
  802e55:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802e5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5d:	8b 40 08             	mov    0x8(%eax),%eax
  802e60:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802e65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e68:	e9 1b 01 00 00       	jmp    802f88 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802e6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e70:	8b 40 0c             	mov    0xc(%eax),%eax
  802e73:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e76:	0f 86 d1 00 00 00    	jbe    802f4d <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802e7c:	a1 48 51 80 00       	mov    0x805148,%eax
  802e81:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802e84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e87:	8b 50 08             	mov    0x8(%eax),%edx
  802e8a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e8d:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802e90:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e93:	8b 55 08             	mov    0x8(%ebp),%edx
  802e96:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802e99:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802e9d:	75 17                	jne    802eb6 <alloc_block_NF+0x4f9>
  802e9f:	83 ec 04             	sub    $0x4,%esp
  802ea2:	68 80 44 80 00       	push   $0x804480
  802ea7:	68 1c 01 00 00       	push   $0x11c
  802eac:	68 d7 43 80 00       	push   $0x8043d7
  802eb1:	e8 05 d6 ff ff       	call   8004bb <_panic>
  802eb6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eb9:	8b 00                	mov    (%eax),%eax
  802ebb:	85 c0                	test   %eax,%eax
  802ebd:	74 10                	je     802ecf <alloc_block_NF+0x512>
  802ebf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ec2:	8b 00                	mov    (%eax),%eax
  802ec4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ec7:	8b 52 04             	mov    0x4(%edx),%edx
  802eca:	89 50 04             	mov    %edx,0x4(%eax)
  802ecd:	eb 0b                	jmp    802eda <alloc_block_NF+0x51d>
  802ecf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ed2:	8b 40 04             	mov    0x4(%eax),%eax
  802ed5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802eda:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802edd:	8b 40 04             	mov    0x4(%eax),%eax
  802ee0:	85 c0                	test   %eax,%eax
  802ee2:	74 0f                	je     802ef3 <alloc_block_NF+0x536>
  802ee4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ee7:	8b 40 04             	mov    0x4(%eax),%eax
  802eea:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802eed:	8b 12                	mov    (%edx),%edx
  802eef:	89 10                	mov    %edx,(%eax)
  802ef1:	eb 0a                	jmp    802efd <alloc_block_NF+0x540>
  802ef3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ef6:	8b 00                	mov    (%eax),%eax
  802ef8:	a3 48 51 80 00       	mov    %eax,0x805148
  802efd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f00:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f06:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f09:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f10:	a1 54 51 80 00       	mov    0x805154,%eax
  802f15:	48                   	dec    %eax
  802f16:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802f1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f1e:	8b 40 08             	mov    0x8(%eax),%eax
  802f21:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802f26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f29:	8b 50 08             	mov    0x8(%eax),%edx
  802f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2f:	01 c2                	add    %eax,%edx
  802f31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f34:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802f37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3a:	8b 40 0c             	mov    0xc(%eax),%eax
  802f3d:	2b 45 08             	sub    0x8(%ebp),%eax
  802f40:	89 c2                	mov    %eax,%edx
  802f42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f45:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802f48:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f4b:	eb 3b                	jmp    802f88 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802f4d:	a1 40 51 80 00       	mov    0x805140,%eax
  802f52:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f55:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f59:	74 07                	je     802f62 <alloc_block_NF+0x5a5>
  802f5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5e:	8b 00                	mov    (%eax),%eax
  802f60:	eb 05                	jmp    802f67 <alloc_block_NF+0x5aa>
  802f62:	b8 00 00 00 00       	mov    $0x0,%eax
  802f67:	a3 40 51 80 00       	mov    %eax,0x805140
  802f6c:	a1 40 51 80 00       	mov    0x805140,%eax
  802f71:	85 c0                	test   %eax,%eax
  802f73:	0f 85 2e fe ff ff    	jne    802da7 <alloc_block_NF+0x3ea>
  802f79:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f7d:	0f 85 24 fe ff ff    	jne    802da7 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802f83:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f88:	c9                   	leave  
  802f89:	c3                   	ret    

00802f8a <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802f8a:	55                   	push   %ebp
  802f8b:	89 e5                	mov    %esp,%ebp
  802f8d:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802f90:	a1 38 51 80 00       	mov    0x805138,%eax
  802f95:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802f98:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802f9d:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802fa0:	a1 38 51 80 00       	mov    0x805138,%eax
  802fa5:	85 c0                	test   %eax,%eax
  802fa7:	74 14                	je     802fbd <insert_sorted_with_merge_freeList+0x33>
  802fa9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fac:	8b 50 08             	mov    0x8(%eax),%edx
  802faf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fb2:	8b 40 08             	mov    0x8(%eax),%eax
  802fb5:	39 c2                	cmp    %eax,%edx
  802fb7:	0f 87 9b 01 00 00    	ja     803158 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802fbd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fc1:	75 17                	jne    802fda <insert_sorted_with_merge_freeList+0x50>
  802fc3:	83 ec 04             	sub    $0x4,%esp
  802fc6:	68 b4 43 80 00       	push   $0x8043b4
  802fcb:	68 38 01 00 00       	push   $0x138
  802fd0:	68 d7 43 80 00       	push   $0x8043d7
  802fd5:	e8 e1 d4 ff ff       	call   8004bb <_panic>
  802fda:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe3:	89 10                	mov    %edx,(%eax)
  802fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe8:	8b 00                	mov    (%eax),%eax
  802fea:	85 c0                	test   %eax,%eax
  802fec:	74 0d                	je     802ffb <insert_sorted_with_merge_freeList+0x71>
  802fee:	a1 38 51 80 00       	mov    0x805138,%eax
  802ff3:	8b 55 08             	mov    0x8(%ebp),%edx
  802ff6:	89 50 04             	mov    %edx,0x4(%eax)
  802ff9:	eb 08                	jmp    803003 <insert_sorted_with_merge_freeList+0x79>
  802ffb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffe:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803003:	8b 45 08             	mov    0x8(%ebp),%eax
  803006:	a3 38 51 80 00       	mov    %eax,0x805138
  80300b:	8b 45 08             	mov    0x8(%ebp),%eax
  80300e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803015:	a1 44 51 80 00       	mov    0x805144,%eax
  80301a:	40                   	inc    %eax
  80301b:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803020:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803024:	0f 84 a8 06 00 00    	je     8036d2 <insert_sorted_with_merge_freeList+0x748>
  80302a:	8b 45 08             	mov    0x8(%ebp),%eax
  80302d:	8b 50 08             	mov    0x8(%eax),%edx
  803030:	8b 45 08             	mov    0x8(%ebp),%eax
  803033:	8b 40 0c             	mov    0xc(%eax),%eax
  803036:	01 c2                	add    %eax,%edx
  803038:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80303b:	8b 40 08             	mov    0x8(%eax),%eax
  80303e:	39 c2                	cmp    %eax,%edx
  803040:	0f 85 8c 06 00 00    	jne    8036d2 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  803046:	8b 45 08             	mov    0x8(%ebp),%eax
  803049:	8b 50 0c             	mov    0xc(%eax),%edx
  80304c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80304f:	8b 40 0c             	mov    0xc(%eax),%eax
  803052:	01 c2                	add    %eax,%edx
  803054:	8b 45 08             	mov    0x8(%ebp),%eax
  803057:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  80305a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80305e:	75 17                	jne    803077 <insert_sorted_with_merge_freeList+0xed>
  803060:	83 ec 04             	sub    $0x4,%esp
  803063:	68 80 44 80 00       	push   $0x804480
  803068:	68 3c 01 00 00       	push   $0x13c
  80306d:	68 d7 43 80 00       	push   $0x8043d7
  803072:	e8 44 d4 ff ff       	call   8004bb <_panic>
  803077:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80307a:	8b 00                	mov    (%eax),%eax
  80307c:	85 c0                	test   %eax,%eax
  80307e:	74 10                	je     803090 <insert_sorted_with_merge_freeList+0x106>
  803080:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803083:	8b 00                	mov    (%eax),%eax
  803085:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803088:	8b 52 04             	mov    0x4(%edx),%edx
  80308b:	89 50 04             	mov    %edx,0x4(%eax)
  80308e:	eb 0b                	jmp    80309b <insert_sorted_with_merge_freeList+0x111>
  803090:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803093:	8b 40 04             	mov    0x4(%eax),%eax
  803096:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80309b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80309e:	8b 40 04             	mov    0x4(%eax),%eax
  8030a1:	85 c0                	test   %eax,%eax
  8030a3:	74 0f                	je     8030b4 <insert_sorted_with_merge_freeList+0x12a>
  8030a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030a8:	8b 40 04             	mov    0x4(%eax),%eax
  8030ab:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030ae:	8b 12                	mov    (%edx),%edx
  8030b0:	89 10                	mov    %edx,(%eax)
  8030b2:	eb 0a                	jmp    8030be <insert_sorted_with_merge_freeList+0x134>
  8030b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030b7:	8b 00                	mov    (%eax),%eax
  8030b9:	a3 38 51 80 00       	mov    %eax,0x805138
  8030be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030ca:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030d1:	a1 44 51 80 00       	mov    0x805144,%eax
  8030d6:	48                   	dec    %eax
  8030d7:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  8030dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030df:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  8030e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030e9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  8030f0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8030f4:	75 17                	jne    80310d <insert_sorted_with_merge_freeList+0x183>
  8030f6:	83 ec 04             	sub    $0x4,%esp
  8030f9:	68 b4 43 80 00       	push   $0x8043b4
  8030fe:	68 3f 01 00 00       	push   $0x13f
  803103:	68 d7 43 80 00       	push   $0x8043d7
  803108:	e8 ae d3 ff ff       	call   8004bb <_panic>
  80310d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803113:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803116:	89 10                	mov    %edx,(%eax)
  803118:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80311b:	8b 00                	mov    (%eax),%eax
  80311d:	85 c0                	test   %eax,%eax
  80311f:	74 0d                	je     80312e <insert_sorted_with_merge_freeList+0x1a4>
  803121:	a1 48 51 80 00       	mov    0x805148,%eax
  803126:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803129:	89 50 04             	mov    %edx,0x4(%eax)
  80312c:	eb 08                	jmp    803136 <insert_sorted_with_merge_freeList+0x1ac>
  80312e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803131:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803136:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803139:	a3 48 51 80 00       	mov    %eax,0x805148
  80313e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803141:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803148:	a1 54 51 80 00       	mov    0x805154,%eax
  80314d:	40                   	inc    %eax
  80314e:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803153:	e9 7a 05 00 00       	jmp    8036d2 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  803158:	8b 45 08             	mov    0x8(%ebp),%eax
  80315b:	8b 50 08             	mov    0x8(%eax),%edx
  80315e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803161:	8b 40 08             	mov    0x8(%eax),%eax
  803164:	39 c2                	cmp    %eax,%edx
  803166:	0f 82 14 01 00 00    	jb     803280 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  80316c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80316f:	8b 50 08             	mov    0x8(%eax),%edx
  803172:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803175:	8b 40 0c             	mov    0xc(%eax),%eax
  803178:	01 c2                	add    %eax,%edx
  80317a:	8b 45 08             	mov    0x8(%ebp),%eax
  80317d:	8b 40 08             	mov    0x8(%eax),%eax
  803180:	39 c2                	cmp    %eax,%edx
  803182:	0f 85 90 00 00 00    	jne    803218 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  803188:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80318b:	8b 50 0c             	mov    0xc(%eax),%edx
  80318e:	8b 45 08             	mov    0x8(%ebp),%eax
  803191:	8b 40 0c             	mov    0xc(%eax),%eax
  803194:	01 c2                	add    %eax,%edx
  803196:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803199:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  80319c:	8b 45 08             	mov    0x8(%ebp),%eax
  80319f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  8031a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8031b0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031b4:	75 17                	jne    8031cd <insert_sorted_with_merge_freeList+0x243>
  8031b6:	83 ec 04             	sub    $0x4,%esp
  8031b9:	68 b4 43 80 00       	push   $0x8043b4
  8031be:	68 49 01 00 00       	push   $0x149
  8031c3:	68 d7 43 80 00       	push   $0x8043d7
  8031c8:	e8 ee d2 ff ff       	call   8004bb <_panic>
  8031cd:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8031d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d6:	89 10                	mov    %edx,(%eax)
  8031d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8031db:	8b 00                	mov    (%eax),%eax
  8031dd:	85 c0                	test   %eax,%eax
  8031df:	74 0d                	je     8031ee <insert_sorted_with_merge_freeList+0x264>
  8031e1:	a1 48 51 80 00       	mov    0x805148,%eax
  8031e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8031e9:	89 50 04             	mov    %edx,0x4(%eax)
  8031ec:	eb 08                	jmp    8031f6 <insert_sorted_with_merge_freeList+0x26c>
  8031ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f9:	a3 48 51 80 00       	mov    %eax,0x805148
  8031fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803201:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803208:	a1 54 51 80 00       	mov    0x805154,%eax
  80320d:	40                   	inc    %eax
  80320e:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803213:	e9 bb 04 00 00       	jmp    8036d3 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803218:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80321c:	75 17                	jne    803235 <insert_sorted_with_merge_freeList+0x2ab>
  80321e:	83 ec 04             	sub    $0x4,%esp
  803221:	68 28 44 80 00       	push   $0x804428
  803226:	68 4c 01 00 00       	push   $0x14c
  80322b:	68 d7 43 80 00       	push   $0x8043d7
  803230:	e8 86 d2 ff ff       	call   8004bb <_panic>
  803235:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  80323b:	8b 45 08             	mov    0x8(%ebp),%eax
  80323e:	89 50 04             	mov    %edx,0x4(%eax)
  803241:	8b 45 08             	mov    0x8(%ebp),%eax
  803244:	8b 40 04             	mov    0x4(%eax),%eax
  803247:	85 c0                	test   %eax,%eax
  803249:	74 0c                	je     803257 <insert_sorted_with_merge_freeList+0x2cd>
  80324b:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803250:	8b 55 08             	mov    0x8(%ebp),%edx
  803253:	89 10                	mov    %edx,(%eax)
  803255:	eb 08                	jmp    80325f <insert_sorted_with_merge_freeList+0x2d5>
  803257:	8b 45 08             	mov    0x8(%ebp),%eax
  80325a:	a3 38 51 80 00       	mov    %eax,0x805138
  80325f:	8b 45 08             	mov    0x8(%ebp),%eax
  803262:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803267:	8b 45 08             	mov    0x8(%ebp),%eax
  80326a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803270:	a1 44 51 80 00       	mov    0x805144,%eax
  803275:	40                   	inc    %eax
  803276:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80327b:	e9 53 04 00 00       	jmp    8036d3 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803280:	a1 38 51 80 00       	mov    0x805138,%eax
  803285:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803288:	e9 15 04 00 00       	jmp    8036a2 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  80328d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803290:	8b 00                	mov    (%eax),%eax
  803292:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803295:	8b 45 08             	mov    0x8(%ebp),%eax
  803298:	8b 50 08             	mov    0x8(%eax),%edx
  80329b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80329e:	8b 40 08             	mov    0x8(%eax),%eax
  8032a1:	39 c2                	cmp    %eax,%edx
  8032a3:	0f 86 f1 03 00 00    	jbe    80369a <insert_sorted_with_merge_freeList+0x710>
  8032a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ac:	8b 50 08             	mov    0x8(%eax),%edx
  8032af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032b2:	8b 40 08             	mov    0x8(%eax),%eax
  8032b5:	39 c2                	cmp    %eax,%edx
  8032b7:	0f 83 dd 03 00 00    	jae    80369a <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  8032bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c0:	8b 50 08             	mov    0x8(%eax),%edx
  8032c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c6:	8b 40 0c             	mov    0xc(%eax),%eax
  8032c9:	01 c2                	add    %eax,%edx
  8032cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ce:	8b 40 08             	mov    0x8(%eax),%eax
  8032d1:	39 c2                	cmp    %eax,%edx
  8032d3:	0f 85 b9 01 00 00    	jne    803492 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8032d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032dc:	8b 50 08             	mov    0x8(%eax),%edx
  8032df:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8032e5:	01 c2                	add    %eax,%edx
  8032e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032ea:	8b 40 08             	mov    0x8(%eax),%eax
  8032ed:	39 c2                	cmp    %eax,%edx
  8032ef:	0f 85 0d 01 00 00    	jne    803402 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  8032f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f8:	8b 50 0c             	mov    0xc(%eax),%edx
  8032fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032fe:	8b 40 0c             	mov    0xc(%eax),%eax
  803301:	01 c2                	add    %eax,%edx
  803303:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803306:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803309:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80330d:	75 17                	jne    803326 <insert_sorted_with_merge_freeList+0x39c>
  80330f:	83 ec 04             	sub    $0x4,%esp
  803312:	68 80 44 80 00       	push   $0x804480
  803317:	68 5c 01 00 00       	push   $0x15c
  80331c:	68 d7 43 80 00       	push   $0x8043d7
  803321:	e8 95 d1 ff ff       	call   8004bb <_panic>
  803326:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803329:	8b 00                	mov    (%eax),%eax
  80332b:	85 c0                	test   %eax,%eax
  80332d:	74 10                	je     80333f <insert_sorted_with_merge_freeList+0x3b5>
  80332f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803332:	8b 00                	mov    (%eax),%eax
  803334:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803337:	8b 52 04             	mov    0x4(%edx),%edx
  80333a:	89 50 04             	mov    %edx,0x4(%eax)
  80333d:	eb 0b                	jmp    80334a <insert_sorted_with_merge_freeList+0x3c0>
  80333f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803342:	8b 40 04             	mov    0x4(%eax),%eax
  803345:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80334a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80334d:	8b 40 04             	mov    0x4(%eax),%eax
  803350:	85 c0                	test   %eax,%eax
  803352:	74 0f                	je     803363 <insert_sorted_with_merge_freeList+0x3d9>
  803354:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803357:	8b 40 04             	mov    0x4(%eax),%eax
  80335a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80335d:	8b 12                	mov    (%edx),%edx
  80335f:	89 10                	mov    %edx,(%eax)
  803361:	eb 0a                	jmp    80336d <insert_sorted_with_merge_freeList+0x3e3>
  803363:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803366:	8b 00                	mov    (%eax),%eax
  803368:	a3 38 51 80 00       	mov    %eax,0x805138
  80336d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803370:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803376:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803379:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803380:	a1 44 51 80 00       	mov    0x805144,%eax
  803385:	48                   	dec    %eax
  803386:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  80338b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80338e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803395:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803398:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80339f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8033a3:	75 17                	jne    8033bc <insert_sorted_with_merge_freeList+0x432>
  8033a5:	83 ec 04             	sub    $0x4,%esp
  8033a8:	68 b4 43 80 00       	push   $0x8043b4
  8033ad:	68 5f 01 00 00       	push   $0x15f
  8033b2:	68 d7 43 80 00       	push   $0x8043d7
  8033b7:	e8 ff d0 ff ff       	call   8004bb <_panic>
  8033bc:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8033c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033c5:	89 10                	mov    %edx,(%eax)
  8033c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033ca:	8b 00                	mov    (%eax),%eax
  8033cc:	85 c0                	test   %eax,%eax
  8033ce:	74 0d                	je     8033dd <insert_sorted_with_merge_freeList+0x453>
  8033d0:	a1 48 51 80 00       	mov    0x805148,%eax
  8033d5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033d8:	89 50 04             	mov    %edx,0x4(%eax)
  8033db:	eb 08                	jmp    8033e5 <insert_sorted_with_merge_freeList+0x45b>
  8033dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033e0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8033e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033e8:	a3 48 51 80 00       	mov    %eax,0x805148
  8033ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033f0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033f7:	a1 54 51 80 00       	mov    0x805154,%eax
  8033fc:	40                   	inc    %eax
  8033fd:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803402:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803405:	8b 50 0c             	mov    0xc(%eax),%edx
  803408:	8b 45 08             	mov    0x8(%ebp),%eax
  80340b:	8b 40 0c             	mov    0xc(%eax),%eax
  80340e:	01 c2                	add    %eax,%edx
  803410:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803413:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803416:	8b 45 08             	mov    0x8(%ebp),%eax
  803419:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803420:	8b 45 08             	mov    0x8(%ebp),%eax
  803423:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80342a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80342e:	75 17                	jne    803447 <insert_sorted_with_merge_freeList+0x4bd>
  803430:	83 ec 04             	sub    $0x4,%esp
  803433:	68 b4 43 80 00       	push   $0x8043b4
  803438:	68 64 01 00 00       	push   $0x164
  80343d:	68 d7 43 80 00       	push   $0x8043d7
  803442:	e8 74 d0 ff ff       	call   8004bb <_panic>
  803447:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80344d:	8b 45 08             	mov    0x8(%ebp),%eax
  803450:	89 10                	mov    %edx,(%eax)
  803452:	8b 45 08             	mov    0x8(%ebp),%eax
  803455:	8b 00                	mov    (%eax),%eax
  803457:	85 c0                	test   %eax,%eax
  803459:	74 0d                	je     803468 <insert_sorted_with_merge_freeList+0x4de>
  80345b:	a1 48 51 80 00       	mov    0x805148,%eax
  803460:	8b 55 08             	mov    0x8(%ebp),%edx
  803463:	89 50 04             	mov    %edx,0x4(%eax)
  803466:	eb 08                	jmp    803470 <insert_sorted_with_merge_freeList+0x4e6>
  803468:	8b 45 08             	mov    0x8(%ebp),%eax
  80346b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803470:	8b 45 08             	mov    0x8(%ebp),%eax
  803473:	a3 48 51 80 00       	mov    %eax,0x805148
  803478:	8b 45 08             	mov    0x8(%ebp),%eax
  80347b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803482:	a1 54 51 80 00       	mov    0x805154,%eax
  803487:	40                   	inc    %eax
  803488:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80348d:	e9 41 02 00 00       	jmp    8036d3 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803492:	8b 45 08             	mov    0x8(%ebp),%eax
  803495:	8b 50 08             	mov    0x8(%eax),%edx
  803498:	8b 45 08             	mov    0x8(%ebp),%eax
  80349b:	8b 40 0c             	mov    0xc(%eax),%eax
  80349e:	01 c2                	add    %eax,%edx
  8034a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034a3:	8b 40 08             	mov    0x8(%eax),%eax
  8034a6:	39 c2                	cmp    %eax,%edx
  8034a8:	0f 85 7c 01 00 00    	jne    80362a <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8034ae:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8034b2:	74 06                	je     8034ba <insert_sorted_with_merge_freeList+0x530>
  8034b4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034b8:	75 17                	jne    8034d1 <insert_sorted_with_merge_freeList+0x547>
  8034ba:	83 ec 04             	sub    $0x4,%esp
  8034bd:	68 f0 43 80 00       	push   $0x8043f0
  8034c2:	68 69 01 00 00       	push   $0x169
  8034c7:	68 d7 43 80 00       	push   $0x8043d7
  8034cc:	e8 ea cf ff ff       	call   8004bb <_panic>
  8034d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034d4:	8b 50 04             	mov    0x4(%eax),%edx
  8034d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8034da:	89 50 04             	mov    %edx,0x4(%eax)
  8034dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8034e3:	89 10                	mov    %edx,(%eax)
  8034e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034e8:	8b 40 04             	mov    0x4(%eax),%eax
  8034eb:	85 c0                	test   %eax,%eax
  8034ed:	74 0d                	je     8034fc <insert_sorted_with_merge_freeList+0x572>
  8034ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034f2:	8b 40 04             	mov    0x4(%eax),%eax
  8034f5:	8b 55 08             	mov    0x8(%ebp),%edx
  8034f8:	89 10                	mov    %edx,(%eax)
  8034fa:	eb 08                	jmp    803504 <insert_sorted_with_merge_freeList+0x57a>
  8034fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ff:	a3 38 51 80 00       	mov    %eax,0x805138
  803504:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803507:	8b 55 08             	mov    0x8(%ebp),%edx
  80350a:	89 50 04             	mov    %edx,0x4(%eax)
  80350d:	a1 44 51 80 00       	mov    0x805144,%eax
  803512:	40                   	inc    %eax
  803513:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803518:	8b 45 08             	mov    0x8(%ebp),%eax
  80351b:	8b 50 0c             	mov    0xc(%eax),%edx
  80351e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803521:	8b 40 0c             	mov    0xc(%eax),%eax
  803524:	01 c2                	add    %eax,%edx
  803526:	8b 45 08             	mov    0x8(%ebp),%eax
  803529:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80352c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803530:	75 17                	jne    803549 <insert_sorted_with_merge_freeList+0x5bf>
  803532:	83 ec 04             	sub    $0x4,%esp
  803535:	68 80 44 80 00       	push   $0x804480
  80353a:	68 6b 01 00 00       	push   $0x16b
  80353f:	68 d7 43 80 00       	push   $0x8043d7
  803544:	e8 72 cf ff ff       	call   8004bb <_panic>
  803549:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80354c:	8b 00                	mov    (%eax),%eax
  80354e:	85 c0                	test   %eax,%eax
  803550:	74 10                	je     803562 <insert_sorted_with_merge_freeList+0x5d8>
  803552:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803555:	8b 00                	mov    (%eax),%eax
  803557:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80355a:	8b 52 04             	mov    0x4(%edx),%edx
  80355d:	89 50 04             	mov    %edx,0x4(%eax)
  803560:	eb 0b                	jmp    80356d <insert_sorted_with_merge_freeList+0x5e3>
  803562:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803565:	8b 40 04             	mov    0x4(%eax),%eax
  803568:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80356d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803570:	8b 40 04             	mov    0x4(%eax),%eax
  803573:	85 c0                	test   %eax,%eax
  803575:	74 0f                	je     803586 <insert_sorted_with_merge_freeList+0x5fc>
  803577:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80357a:	8b 40 04             	mov    0x4(%eax),%eax
  80357d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803580:	8b 12                	mov    (%edx),%edx
  803582:	89 10                	mov    %edx,(%eax)
  803584:	eb 0a                	jmp    803590 <insert_sorted_with_merge_freeList+0x606>
  803586:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803589:	8b 00                	mov    (%eax),%eax
  80358b:	a3 38 51 80 00       	mov    %eax,0x805138
  803590:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803593:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803599:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80359c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035a3:	a1 44 51 80 00       	mov    0x805144,%eax
  8035a8:	48                   	dec    %eax
  8035a9:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  8035ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035b1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8035b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035bb:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8035c2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8035c6:	75 17                	jne    8035df <insert_sorted_with_merge_freeList+0x655>
  8035c8:	83 ec 04             	sub    $0x4,%esp
  8035cb:	68 b4 43 80 00       	push   $0x8043b4
  8035d0:	68 6e 01 00 00       	push   $0x16e
  8035d5:	68 d7 43 80 00       	push   $0x8043d7
  8035da:	e8 dc ce ff ff       	call   8004bb <_panic>
  8035df:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8035e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035e8:	89 10                	mov    %edx,(%eax)
  8035ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035ed:	8b 00                	mov    (%eax),%eax
  8035ef:	85 c0                	test   %eax,%eax
  8035f1:	74 0d                	je     803600 <insert_sorted_with_merge_freeList+0x676>
  8035f3:	a1 48 51 80 00       	mov    0x805148,%eax
  8035f8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8035fb:	89 50 04             	mov    %edx,0x4(%eax)
  8035fe:	eb 08                	jmp    803608 <insert_sorted_with_merge_freeList+0x67e>
  803600:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803603:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803608:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80360b:	a3 48 51 80 00       	mov    %eax,0x805148
  803610:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803613:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80361a:	a1 54 51 80 00       	mov    0x805154,%eax
  80361f:	40                   	inc    %eax
  803620:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803625:	e9 a9 00 00 00       	jmp    8036d3 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  80362a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80362e:	74 06                	je     803636 <insert_sorted_with_merge_freeList+0x6ac>
  803630:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803634:	75 17                	jne    80364d <insert_sorted_with_merge_freeList+0x6c3>
  803636:	83 ec 04             	sub    $0x4,%esp
  803639:	68 4c 44 80 00       	push   $0x80444c
  80363e:	68 73 01 00 00       	push   $0x173
  803643:	68 d7 43 80 00       	push   $0x8043d7
  803648:	e8 6e ce ff ff       	call   8004bb <_panic>
  80364d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803650:	8b 10                	mov    (%eax),%edx
  803652:	8b 45 08             	mov    0x8(%ebp),%eax
  803655:	89 10                	mov    %edx,(%eax)
  803657:	8b 45 08             	mov    0x8(%ebp),%eax
  80365a:	8b 00                	mov    (%eax),%eax
  80365c:	85 c0                	test   %eax,%eax
  80365e:	74 0b                	je     80366b <insert_sorted_with_merge_freeList+0x6e1>
  803660:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803663:	8b 00                	mov    (%eax),%eax
  803665:	8b 55 08             	mov    0x8(%ebp),%edx
  803668:	89 50 04             	mov    %edx,0x4(%eax)
  80366b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80366e:	8b 55 08             	mov    0x8(%ebp),%edx
  803671:	89 10                	mov    %edx,(%eax)
  803673:	8b 45 08             	mov    0x8(%ebp),%eax
  803676:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803679:	89 50 04             	mov    %edx,0x4(%eax)
  80367c:	8b 45 08             	mov    0x8(%ebp),%eax
  80367f:	8b 00                	mov    (%eax),%eax
  803681:	85 c0                	test   %eax,%eax
  803683:	75 08                	jne    80368d <insert_sorted_with_merge_freeList+0x703>
  803685:	8b 45 08             	mov    0x8(%ebp),%eax
  803688:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80368d:	a1 44 51 80 00       	mov    0x805144,%eax
  803692:	40                   	inc    %eax
  803693:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803698:	eb 39                	jmp    8036d3 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80369a:	a1 40 51 80 00       	mov    0x805140,%eax
  80369f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8036a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036a6:	74 07                	je     8036af <insert_sorted_with_merge_freeList+0x725>
  8036a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036ab:	8b 00                	mov    (%eax),%eax
  8036ad:	eb 05                	jmp    8036b4 <insert_sorted_with_merge_freeList+0x72a>
  8036af:	b8 00 00 00 00       	mov    $0x0,%eax
  8036b4:	a3 40 51 80 00       	mov    %eax,0x805140
  8036b9:	a1 40 51 80 00       	mov    0x805140,%eax
  8036be:	85 c0                	test   %eax,%eax
  8036c0:	0f 85 c7 fb ff ff    	jne    80328d <insert_sorted_with_merge_freeList+0x303>
  8036c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036ca:	0f 85 bd fb ff ff    	jne    80328d <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8036d0:	eb 01                	jmp    8036d3 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8036d2:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8036d3:	90                   	nop
  8036d4:	c9                   	leave  
  8036d5:	c3                   	ret    

008036d6 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8036d6:	55                   	push   %ebp
  8036d7:	89 e5                	mov    %esp,%ebp
  8036d9:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8036dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8036df:	89 d0                	mov    %edx,%eax
  8036e1:	c1 e0 02             	shl    $0x2,%eax
  8036e4:	01 d0                	add    %edx,%eax
  8036e6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8036ed:	01 d0                	add    %edx,%eax
  8036ef:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8036f6:	01 d0                	add    %edx,%eax
  8036f8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8036ff:	01 d0                	add    %edx,%eax
  803701:	c1 e0 04             	shl    $0x4,%eax
  803704:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803707:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  80370e:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803711:	83 ec 0c             	sub    $0xc,%esp
  803714:	50                   	push   %eax
  803715:	e8 26 e7 ff ff       	call   801e40 <sys_get_virtual_time>
  80371a:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  80371d:	eb 41                	jmp    803760 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  80371f:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803722:	83 ec 0c             	sub    $0xc,%esp
  803725:	50                   	push   %eax
  803726:	e8 15 e7 ff ff       	call   801e40 <sys_get_virtual_time>
  80372b:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  80372e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803731:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803734:	29 c2                	sub    %eax,%edx
  803736:	89 d0                	mov    %edx,%eax
  803738:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  80373b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80373e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803741:	89 d1                	mov    %edx,%ecx
  803743:	29 c1                	sub    %eax,%ecx
  803745:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803748:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80374b:	39 c2                	cmp    %eax,%edx
  80374d:	0f 97 c0             	seta   %al
  803750:	0f b6 c0             	movzbl %al,%eax
  803753:	29 c1                	sub    %eax,%ecx
  803755:	89 c8                	mov    %ecx,%eax
  803757:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  80375a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80375d:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  803760:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803763:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803766:	72 b7                	jb     80371f <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803768:	90                   	nop
  803769:	c9                   	leave  
  80376a:	c3                   	ret    

0080376b <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  80376b:	55                   	push   %ebp
  80376c:	89 e5                	mov    %esp,%ebp
  80376e:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803771:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803778:	eb 03                	jmp    80377d <busy_wait+0x12>
  80377a:	ff 45 fc             	incl   -0x4(%ebp)
  80377d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803780:	3b 45 08             	cmp    0x8(%ebp),%eax
  803783:	72 f5                	jb     80377a <busy_wait+0xf>
	return i;
  803785:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803788:	c9                   	leave  
  803789:	c3                   	ret    
  80378a:	66 90                	xchg   %ax,%ax

0080378c <__udivdi3>:
  80378c:	55                   	push   %ebp
  80378d:	57                   	push   %edi
  80378e:	56                   	push   %esi
  80378f:	53                   	push   %ebx
  803790:	83 ec 1c             	sub    $0x1c,%esp
  803793:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803797:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80379b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80379f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8037a3:	89 ca                	mov    %ecx,%edx
  8037a5:	89 f8                	mov    %edi,%eax
  8037a7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8037ab:	85 f6                	test   %esi,%esi
  8037ad:	75 2d                	jne    8037dc <__udivdi3+0x50>
  8037af:	39 cf                	cmp    %ecx,%edi
  8037b1:	77 65                	ja     803818 <__udivdi3+0x8c>
  8037b3:	89 fd                	mov    %edi,%ebp
  8037b5:	85 ff                	test   %edi,%edi
  8037b7:	75 0b                	jne    8037c4 <__udivdi3+0x38>
  8037b9:	b8 01 00 00 00       	mov    $0x1,%eax
  8037be:	31 d2                	xor    %edx,%edx
  8037c0:	f7 f7                	div    %edi
  8037c2:	89 c5                	mov    %eax,%ebp
  8037c4:	31 d2                	xor    %edx,%edx
  8037c6:	89 c8                	mov    %ecx,%eax
  8037c8:	f7 f5                	div    %ebp
  8037ca:	89 c1                	mov    %eax,%ecx
  8037cc:	89 d8                	mov    %ebx,%eax
  8037ce:	f7 f5                	div    %ebp
  8037d0:	89 cf                	mov    %ecx,%edi
  8037d2:	89 fa                	mov    %edi,%edx
  8037d4:	83 c4 1c             	add    $0x1c,%esp
  8037d7:	5b                   	pop    %ebx
  8037d8:	5e                   	pop    %esi
  8037d9:	5f                   	pop    %edi
  8037da:	5d                   	pop    %ebp
  8037db:	c3                   	ret    
  8037dc:	39 ce                	cmp    %ecx,%esi
  8037de:	77 28                	ja     803808 <__udivdi3+0x7c>
  8037e0:	0f bd fe             	bsr    %esi,%edi
  8037e3:	83 f7 1f             	xor    $0x1f,%edi
  8037e6:	75 40                	jne    803828 <__udivdi3+0x9c>
  8037e8:	39 ce                	cmp    %ecx,%esi
  8037ea:	72 0a                	jb     8037f6 <__udivdi3+0x6a>
  8037ec:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8037f0:	0f 87 9e 00 00 00    	ja     803894 <__udivdi3+0x108>
  8037f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8037fb:	89 fa                	mov    %edi,%edx
  8037fd:	83 c4 1c             	add    $0x1c,%esp
  803800:	5b                   	pop    %ebx
  803801:	5e                   	pop    %esi
  803802:	5f                   	pop    %edi
  803803:	5d                   	pop    %ebp
  803804:	c3                   	ret    
  803805:	8d 76 00             	lea    0x0(%esi),%esi
  803808:	31 ff                	xor    %edi,%edi
  80380a:	31 c0                	xor    %eax,%eax
  80380c:	89 fa                	mov    %edi,%edx
  80380e:	83 c4 1c             	add    $0x1c,%esp
  803811:	5b                   	pop    %ebx
  803812:	5e                   	pop    %esi
  803813:	5f                   	pop    %edi
  803814:	5d                   	pop    %ebp
  803815:	c3                   	ret    
  803816:	66 90                	xchg   %ax,%ax
  803818:	89 d8                	mov    %ebx,%eax
  80381a:	f7 f7                	div    %edi
  80381c:	31 ff                	xor    %edi,%edi
  80381e:	89 fa                	mov    %edi,%edx
  803820:	83 c4 1c             	add    $0x1c,%esp
  803823:	5b                   	pop    %ebx
  803824:	5e                   	pop    %esi
  803825:	5f                   	pop    %edi
  803826:	5d                   	pop    %ebp
  803827:	c3                   	ret    
  803828:	bd 20 00 00 00       	mov    $0x20,%ebp
  80382d:	89 eb                	mov    %ebp,%ebx
  80382f:	29 fb                	sub    %edi,%ebx
  803831:	89 f9                	mov    %edi,%ecx
  803833:	d3 e6                	shl    %cl,%esi
  803835:	89 c5                	mov    %eax,%ebp
  803837:	88 d9                	mov    %bl,%cl
  803839:	d3 ed                	shr    %cl,%ebp
  80383b:	89 e9                	mov    %ebp,%ecx
  80383d:	09 f1                	or     %esi,%ecx
  80383f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803843:	89 f9                	mov    %edi,%ecx
  803845:	d3 e0                	shl    %cl,%eax
  803847:	89 c5                	mov    %eax,%ebp
  803849:	89 d6                	mov    %edx,%esi
  80384b:	88 d9                	mov    %bl,%cl
  80384d:	d3 ee                	shr    %cl,%esi
  80384f:	89 f9                	mov    %edi,%ecx
  803851:	d3 e2                	shl    %cl,%edx
  803853:	8b 44 24 08          	mov    0x8(%esp),%eax
  803857:	88 d9                	mov    %bl,%cl
  803859:	d3 e8                	shr    %cl,%eax
  80385b:	09 c2                	or     %eax,%edx
  80385d:	89 d0                	mov    %edx,%eax
  80385f:	89 f2                	mov    %esi,%edx
  803861:	f7 74 24 0c          	divl   0xc(%esp)
  803865:	89 d6                	mov    %edx,%esi
  803867:	89 c3                	mov    %eax,%ebx
  803869:	f7 e5                	mul    %ebp
  80386b:	39 d6                	cmp    %edx,%esi
  80386d:	72 19                	jb     803888 <__udivdi3+0xfc>
  80386f:	74 0b                	je     80387c <__udivdi3+0xf0>
  803871:	89 d8                	mov    %ebx,%eax
  803873:	31 ff                	xor    %edi,%edi
  803875:	e9 58 ff ff ff       	jmp    8037d2 <__udivdi3+0x46>
  80387a:	66 90                	xchg   %ax,%ax
  80387c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803880:	89 f9                	mov    %edi,%ecx
  803882:	d3 e2                	shl    %cl,%edx
  803884:	39 c2                	cmp    %eax,%edx
  803886:	73 e9                	jae    803871 <__udivdi3+0xe5>
  803888:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80388b:	31 ff                	xor    %edi,%edi
  80388d:	e9 40 ff ff ff       	jmp    8037d2 <__udivdi3+0x46>
  803892:	66 90                	xchg   %ax,%ax
  803894:	31 c0                	xor    %eax,%eax
  803896:	e9 37 ff ff ff       	jmp    8037d2 <__udivdi3+0x46>
  80389b:	90                   	nop

0080389c <__umoddi3>:
  80389c:	55                   	push   %ebp
  80389d:	57                   	push   %edi
  80389e:	56                   	push   %esi
  80389f:	53                   	push   %ebx
  8038a0:	83 ec 1c             	sub    $0x1c,%esp
  8038a3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8038a7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8038ab:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8038af:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8038b3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8038b7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8038bb:	89 f3                	mov    %esi,%ebx
  8038bd:	89 fa                	mov    %edi,%edx
  8038bf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8038c3:	89 34 24             	mov    %esi,(%esp)
  8038c6:	85 c0                	test   %eax,%eax
  8038c8:	75 1a                	jne    8038e4 <__umoddi3+0x48>
  8038ca:	39 f7                	cmp    %esi,%edi
  8038cc:	0f 86 a2 00 00 00    	jbe    803974 <__umoddi3+0xd8>
  8038d2:	89 c8                	mov    %ecx,%eax
  8038d4:	89 f2                	mov    %esi,%edx
  8038d6:	f7 f7                	div    %edi
  8038d8:	89 d0                	mov    %edx,%eax
  8038da:	31 d2                	xor    %edx,%edx
  8038dc:	83 c4 1c             	add    $0x1c,%esp
  8038df:	5b                   	pop    %ebx
  8038e0:	5e                   	pop    %esi
  8038e1:	5f                   	pop    %edi
  8038e2:	5d                   	pop    %ebp
  8038e3:	c3                   	ret    
  8038e4:	39 f0                	cmp    %esi,%eax
  8038e6:	0f 87 ac 00 00 00    	ja     803998 <__umoddi3+0xfc>
  8038ec:	0f bd e8             	bsr    %eax,%ebp
  8038ef:	83 f5 1f             	xor    $0x1f,%ebp
  8038f2:	0f 84 ac 00 00 00    	je     8039a4 <__umoddi3+0x108>
  8038f8:	bf 20 00 00 00       	mov    $0x20,%edi
  8038fd:	29 ef                	sub    %ebp,%edi
  8038ff:	89 fe                	mov    %edi,%esi
  803901:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803905:	89 e9                	mov    %ebp,%ecx
  803907:	d3 e0                	shl    %cl,%eax
  803909:	89 d7                	mov    %edx,%edi
  80390b:	89 f1                	mov    %esi,%ecx
  80390d:	d3 ef                	shr    %cl,%edi
  80390f:	09 c7                	or     %eax,%edi
  803911:	89 e9                	mov    %ebp,%ecx
  803913:	d3 e2                	shl    %cl,%edx
  803915:	89 14 24             	mov    %edx,(%esp)
  803918:	89 d8                	mov    %ebx,%eax
  80391a:	d3 e0                	shl    %cl,%eax
  80391c:	89 c2                	mov    %eax,%edx
  80391e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803922:	d3 e0                	shl    %cl,%eax
  803924:	89 44 24 04          	mov    %eax,0x4(%esp)
  803928:	8b 44 24 08          	mov    0x8(%esp),%eax
  80392c:	89 f1                	mov    %esi,%ecx
  80392e:	d3 e8                	shr    %cl,%eax
  803930:	09 d0                	or     %edx,%eax
  803932:	d3 eb                	shr    %cl,%ebx
  803934:	89 da                	mov    %ebx,%edx
  803936:	f7 f7                	div    %edi
  803938:	89 d3                	mov    %edx,%ebx
  80393a:	f7 24 24             	mull   (%esp)
  80393d:	89 c6                	mov    %eax,%esi
  80393f:	89 d1                	mov    %edx,%ecx
  803941:	39 d3                	cmp    %edx,%ebx
  803943:	0f 82 87 00 00 00    	jb     8039d0 <__umoddi3+0x134>
  803949:	0f 84 91 00 00 00    	je     8039e0 <__umoddi3+0x144>
  80394f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803953:	29 f2                	sub    %esi,%edx
  803955:	19 cb                	sbb    %ecx,%ebx
  803957:	89 d8                	mov    %ebx,%eax
  803959:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80395d:	d3 e0                	shl    %cl,%eax
  80395f:	89 e9                	mov    %ebp,%ecx
  803961:	d3 ea                	shr    %cl,%edx
  803963:	09 d0                	or     %edx,%eax
  803965:	89 e9                	mov    %ebp,%ecx
  803967:	d3 eb                	shr    %cl,%ebx
  803969:	89 da                	mov    %ebx,%edx
  80396b:	83 c4 1c             	add    $0x1c,%esp
  80396e:	5b                   	pop    %ebx
  80396f:	5e                   	pop    %esi
  803970:	5f                   	pop    %edi
  803971:	5d                   	pop    %ebp
  803972:	c3                   	ret    
  803973:	90                   	nop
  803974:	89 fd                	mov    %edi,%ebp
  803976:	85 ff                	test   %edi,%edi
  803978:	75 0b                	jne    803985 <__umoddi3+0xe9>
  80397a:	b8 01 00 00 00       	mov    $0x1,%eax
  80397f:	31 d2                	xor    %edx,%edx
  803981:	f7 f7                	div    %edi
  803983:	89 c5                	mov    %eax,%ebp
  803985:	89 f0                	mov    %esi,%eax
  803987:	31 d2                	xor    %edx,%edx
  803989:	f7 f5                	div    %ebp
  80398b:	89 c8                	mov    %ecx,%eax
  80398d:	f7 f5                	div    %ebp
  80398f:	89 d0                	mov    %edx,%eax
  803991:	e9 44 ff ff ff       	jmp    8038da <__umoddi3+0x3e>
  803996:	66 90                	xchg   %ax,%ax
  803998:	89 c8                	mov    %ecx,%eax
  80399a:	89 f2                	mov    %esi,%edx
  80399c:	83 c4 1c             	add    $0x1c,%esp
  80399f:	5b                   	pop    %ebx
  8039a0:	5e                   	pop    %esi
  8039a1:	5f                   	pop    %edi
  8039a2:	5d                   	pop    %ebp
  8039a3:	c3                   	ret    
  8039a4:	3b 04 24             	cmp    (%esp),%eax
  8039a7:	72 06                	jb     8039af <__umoddi3+0x113>
  8039a9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8039ad:	77 0f                	ja     8039be <__umoddi3+0x122>
  8039af:	89 f2                	mov    %esi,%edx
  8039b1:	29 f9                	sub    %edi,%ecx
  8039b3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8039b7:	89 14 24             	mov    %edx,(%esp)
  8039ba:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8039be:	8b 44 24 04          	mov    0x4(%esp),%eax
  8039c2:	8b 14 24             	mov    (%esp),%edx
  8039c5:	83 c4 1c             	add    $0x1c,%esp
  8039c8:	5b                   	pop    %ebx
  8039c9:	5e                   	pop    %esi
  8039ca:	5f                   	pop    %edi
  8039cb:	5d                   	pop    %ebp
  8039cc:	c3                   	ret    
  8039cd:	8d 76 00             	lea    0x0(%esi),%esi
  8039d0:	2b 04 24             	sub    (%esp),%eax
  8039d3:	19 fa                	sbb    %edi,%edx
  8039d5:	89 d1                	mov    %edx,%ecx
  8039d7:	89 c6                	mov    %eax,%esi
  8039d9:	e9 71 ff ff ff       	jmp    80394f <__umoddi3+0xb3>
  8039de:	66 90                	xchg   %ax,%ax
  8039e0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8039e4:	72 ea                	jb     8039d0 <__umoddi3+0x134>
  8039e6:	89 d9                	mov    %ebx,%ecx
  8039e8:	e9 62 ff ff ff       	jmp    80394f <__umoddi3+0xb3>
