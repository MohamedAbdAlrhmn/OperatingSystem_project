
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
  80008d:	68 00 38 80 00       	push   $0x803800
  800092:	6a 13                	push   $0x13
  800094:	68 1c 38 80 00       	push   $0x80381c
  800099:	e8 1d 04 00 00       	call   8004bb <_panic>
	}
	uint32 *x, *y, *z ;

	//x: Readonly
	int freeFrames = sys_calculate_free_frames() ;
  80009e:	e8 74 18 00 00       	call   801917 <sys_calculate_free_frames>
  8000a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	x = smalloc("x", 4, 0);
  8000a6:	83 ec 04             	sub    $0x4,%esp
  8000a9:	6a 00                	push   $0x0
  8000ab:	6a 04                	push   $0x4
  8000ad:	68 3a 38 80 00       	push   $0x80383a
  8000b2:	e8 88 16 00 00       	call   80173f <smalloc>
  8000b7:	83 c4 10             	add    $0x10,%esp
  8000ba:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if (x != (uint32*)USER_HEAP_START) panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8000bd:	81 7d e8 00 00 00 80 	cmpl   $0x80000000,-0x18(%ebp)
  8000c4:	74 14                	je     8000da <_main+0xa2>
  8000c6:	83 ec 04             	sub    $0x4,%esp
  8000c9:	68 3c 38 80 00       	push   $0x80383c
  8000ce:	6a 1a                	push   $0x1a
  8000d0:	68 1c 38 80 00       	push   $0x80381c
  8000d5:	e8 e1 03 00 00       	call   8004bb <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Create(): Wrong allocation- make sure that you allocate the required space in the user environment and add its frames to frames_storage %d %d %d", freeFrames, sys_calculate_free_frames(), freeFrames - sys_calculate_free_frames());
  8000da:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000dd:	e8 35 18 00 00       	call   801917 <sys_calculate_free_frames>
  8000e2:	29 c3                	sub    %eax,%ebx
  8000e4:	89 d8                	mov    %ebx,%eax
  8000e6:	83 f8 04             	cmp    $0x4,%eax
  8000e9:	74 28                	je     800113 <_main+0xdb>
  8000eb:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000ee:	e8 24 18 00 00       	call   801917 <sys_calculate_free_frames>
  8000f3:	29 c3                	sub    %eax,%ebx
  8000f5:	e8 1d 18 00 00       	call   801917 <sys_calculate_free_frames>
  8000fa:	83 ec 08             	sub    $0x8,%esp
  8000fd:	53                   	push   %ebx
  8000fe:	50                   	push   %eax
  8000ff:	ff 75 ec             	pushl  -0x14(%ebp)
  800102:	68 a0 38 80 00       	push   $0x8038a0
  800107:	6a 1b                	push   $0x1b
  800109:	68 1c 38 80 00       	push   $0x80381c
  80010e:	e8 a8 03 00 00       	call   8004bb <_panic>

	//y: Readonly
	freeFrames = sys_calculate_free_frames() ;
  800113:	e8 ff 17 00 00       	call   801917 <sys_calculate_free_frames>
  800118:	89 45 ec             	mov    %eax,-0x14(%ebp)
	y = smalloc("y", 4, 0);
  80011b:	83 ec 04             	sub    $0x4,%esp
  80011e:	6a 00                	push   $0x0
  800120:	6a 04                	push   $0x4
  800122:	68 31 39 80 00       	push   $0x803931
  800127:	e8 13 16 00 00       	call   80173f <smalloc>
  80012c:	83 c4 10             	add    $0x10,%esp
  80012f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (y != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  800132:	81 7d e4 00 10 00 80 	cmpl   $0x80001000,-0x1c(%ebp)
  800139:	74 14                	je     80014f <_main+0x117>
  80013b:	83 ec 04             	sub    $0x4,%esp
  80013e:	68 3c 38 80 00       	push   $0x80383c
  800143:	6a 20                	push   $0x20
  800145:	68 1c 38 80 00       	push   $0x80381c
  80014a:	e8 6c 03 00 00       	call   8004bb <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1+0+2) panic("Create(): Wrong allocation- make sure that you allocate the required space in the user environment and add its frames to frames_storage %d %d %d", freeFrames, sys_calculate_free_frames(), freeFrames - sys_calculate_free_frames());
  80014f:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  800152:	e8 c0 17 00 00       	call   801917 <sys_calculate_free_frames>
  800157:	29 c3                	sub    %eax,%ebx
  800159:	89 d8                	mov    %ebx,%eax
  80015b:	83 f8 03             	cmp    $0x3,%eax
  80015e:	74 28                	je     800188 <_main+0x150>
  800160:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  800163:	e8 af 17 00 00       	call   801917 <sys_calculate_free_frames>
  800168:	29 c3                	sub    %eax,%ebx
  80016a:	e8 a8 17 00 00       	call   801917 <sys_calculate_free_frames>
  80016f:	83 ec 08             	sub    $0x8,%esp
  800172:	53                   	push   %ebx
  800173:	50                   	push   %eax
  800174:	ff 75 ec             	pushl  -0x14(%ebp)
  800177:	68 a0 38 80 00       	push   $0x8038a0
  80017c:	6a 21                	push   $0x21
  80017e:	68 1c 38 80 00       	push   $0x80381c
  800183:	e8 33 03 00 00       	call   8004bb <_panic>

	//z: Writable
	freeFrames = sys_calculate_free_frames() ;
  800188:	e8 8a 17 00 00       	call   801917 <sys_calculate_free_frames>
  80018d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	z = smalloc("z", 4, 1);
  800190:	83 ec 04             	sub    $0x4,%esp
  800193:	6a 01                	push   $0x1
  800195:	6a 04                	push   $0x4
  800197:	68 33 39 80 00       	push   $0x803933
  80019c:	e8 9e 15 00 00       	call   80173f <smalloc>
  8001a1:	83 c4 10             	add    $0x10,%esp
  8001a4:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (z != (uint32*)(USER_HEAP_START + 2 * PAGE_SIZE)) panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8001a7:	81 7d e0 00 20 00 80 	cmpl   $0x80002000,-0x20(%ebp)
  8001ae:	74 14                	je     8001c4 <_main+0x18c>
  8001b0:	83 ec 04             	sub    $0x4,%esp
  8001b3:	68 3c 38 80 00       	push   $0x80383c
  8001b8:	6a 26                	push   $0x26
  8001ba:	68 1c 38 80 00       	push   $0x80381c
  8001bf:	e8 f7 02 00 00       	call   8004bb <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1+0+2) panic("Create(): Wrong allocation- make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8001c4:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8001c7:	e8 4b 17 00 00       	call   801917 <sys_calculate_free_frames>
  8001cc:	29 c3                	sub    %eax,%ebx
  8001ce:	89 d8                	mov    %ebx,%eax
  8001d0:	83 f8 03             	cmp    $0x3,%eax
  8001d3:	74 14                	je     8001e9 <_main+0x1b1>
  8001d5:	83 ec 04             	sub    $0x4,%esp
  8001d8:	68 38 39 80 00       	push   $0x803938
  8001dd:	6a 27                	push   $0x27
  8001df:	68 1c 38 80 00       	push   $0x80381c
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
  800214:	68 c0 39 80 00       	push   $0x8039c0
  800219:	e8 6b 19 00 00       	call   801b89 <sys_create_env>
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
  80023d:	68 c0 39 80 00       	push   $0x8039c0
  800242:	e8 42 19 00 00       	call   801b89 <sys_create_env>
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
  800266:	68 c0 39 80 00       	push   $0x8039c0
  80026b:	e8 19 19 00 00       	call   801b89 <sys_create_env>
  800270:	83 c4 10             	add    $0x10,%esp
  800273:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	//to check that the slave environments completed successfully
	rsttst();
  800276:	e8 5a 1a 00 00       	call   801cd5 <rsttst>

	int* finish_children = smalloc("finish_children", sizeof(int), 1);
  80027b:	83 ec 04             	sub    $0x4,%esp
  80027e:	6a 01                	push   $0x1
  800280:	6a 04                	push   $0x4
  800282:	68 ce 39 80 00       	push   $0x8039ce
  800287:	e8 b3 14 00 00       	call   80173f <smalloc>
  80028c:	83 c4 10             	add    $0x10,%esp
  80028f:	89 45 d0             	mov    %eax,-0x30(%ebp)

	sys_run_env(id1);
  800292:	83 ec 0c             	sub    $0xc,%esp
  800295:	ff 75 dc             	pushl  -0x24(%ebp)
  800298:	e8 0a 19 00 00       	call   801ba7 <sys_run_env>
  80029d:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id2);
  8002a0:	83 ec 0c             	sub    $0xc,%esp
  8002a3:	ff 75 d8             	pushl  -0x28(%ebp)
  8002a6:	e8 fc 18 00 00       	call   801ba7 <sys_run_env>
  8002ab:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id3);
  8002ae:	83 ec 0c             	sub    $0xc,%esp
  8002b1:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002b4:	e8 ee 18 00 00       	call   801ba7 <sys_run_env>
  8002b9:	83 c4 10             	add    $0x10,%esp

	env_sleep(15000) ;
  8002bc:	83 ec 0c             	sub    $0xc,%esp
  8002bf:	68 98 3a 00 00       	push   $0x3a98
  8002c4:	e8 10 32 00 00       	call   8034d9 <env_sleep>
  8002c9:	83 c4 10             	add    $0x10,%esp

	//to ensure that the slave environments completed successfully
	if (gettst()!=3) panic("test failed");
  8002cc:	e8 7e 1a 00 00       	call   801d4f <gettst>
  8002d1:	83 f8 03             	cmp    $0x3,%eax
  8002d4:	74 14                	je     8002ea <_main+0x2b2>
  8002d6:	83 ec 04             	sub    $0x4,%esp
  8002d9:	68 de 39 80 00       	push   $0x8039de
  8002de:	6a 3d                	push   $0x3d
  8002e0:	68 1c 38 80 00       	push   $0x80381c
  8002e5:	e8 d1 01 00 00       	call   8004bb <_panic>


	if (*z != 30)
  8002ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002ed:	8b 00                	mov    (%eax),%eax
  8002ef:	83 f8 1e             	cmp    $0x1e,%eax
  8002f2:	74 14                	je     800308 <_main+0x2d0>
		panic("Error!! Please check the creation (or the getting) of shared 2variables!!\n\n\n");
  8002f4:	83 ec 04             	sub    $0x4,%esp
  8002f7:	68 ec 39 80 00       	push   $0x8039ec
  8002fc:	6a 41                	push   $0x41
  8002fe:	68 1c 38 80 00       	push   $0x80381c
  800303:	e8 b3 01 00 00       	call   8004bb <_panic>
	else
		cprintf("Congratulations!! Test of Shared Variables [Create & Get] [2] completed successfully!!\n\n\n");
  800308:	83 ec 0c             	sub    $0xc,%esp
  80030b:	68 3c 3a 80 00       	push   $0x803a3c
  800310:	e8 5a 04 00 00       	call   80076f <cprintf>
  800315:	83 c4 10             	add    $0x10,%esp


	if (sys_getparentenvid() > 0) {
  800318:	e8 f3 18 00 00       	call   801c10 <sys_getparentenvid>
  80031d:	85 c0                	test   %eax,%eax
  80031f:	7e 58                	jle    800379 <_main+0x341>
		sys_destroy_env(id1);
  800321:	83 ec 0c             	sub    $0xc,%esp
  800324:	ff 75 dc             	pushl  -0x24(%ebp)
  800327:	e8 97 18 00 00       	call   801bc3 <sys_destroy_env>
  80032c:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(id2);
  80032f:	83 ec 0c             	sub    $0xc,%esp
  800332:	ff 75 d8             	pushl  -0x28(%ebp)
  800335:	e8 89 18 00 00       	call   801bc3 <sys_destroy_env>
  80033a:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(id3);
  80033d:	83 ec 0c             	sub    $0xc,%esp
  800340:	ff 75 d4             	pushl  -0x2c(%ebp)
  800343:	e8 7b 18 00 00       	call   801bc3 <sys_destroy_env>
  800348:	83 c4 10             	add    $0x10,%esp
		int *finishedCount = NULL;
  80034b:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
		finishedCount = sget(sys_getparentenvid(), "finishedCount") ;
  800352:	e8 b9 18 00 00       	call   801c10 <sys_getparentenvid>
  800357:	83 ec 08             	sub    $0x8,%esp
  80035a:	68 96 3a 80 00       	push   $0x803a96
  80035f:	50                   	push   %eax
  800360:	e8 0e 14 00 00       	call   801773 <sget>
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
  800385:	e8 6d 18 00 00       	call   801bf7 <sys_getenvindex>
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
  8003f0:	e8 0f 16 00 00       	call   801a04 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8003f5:	83 ec 0c             	sub    $0xc,%esp
  8003f8:	68 bc 3a 80 00       	push   $0x803abc
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
  800420:	68 e4 3a 80 00       	push   $0x803ae4
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
  800451:	68 0c 3b 80 00       	push   $0x803b0c
  800456:	e8 14 03 00 00       	call   80076f <cprintf>
  80045b:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80045e:	a1 20 50 80 00       	mov    0x805020,%eax
  800463:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800469:	83 ec 08             	sub    $0x8,%esp
  80046c:	50                   	push   %eax
  80046d:	68 64 3b 80 00       	push   $0x803b64
  800472:	e8 f8 02 00 00       	call   80076f <cprintf>
  800477:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80047a:	83 ec 0c             	sub    $0xc,%esp
  80047d:	68 bc 3a 80 00       	push   $0x803abc
  800482:	e8 e8 02 00 00       	call   80076f <cprintf>
  800487:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80048a:	e8 8f 15 00 00       	call   801a1e <sys_enable_interrupt>

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
  8004a2:	e8 1c 17 00 00       	call   801bc3 <sys_destroy_env>
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
  8004b3:	e8 71 17 00 00       	call   801c29 <sys_exit_env>
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
  8004dc:	68 78 3b 80 00       	push   $0x803b78
  8004e1:	e8 89 02 00 00       	call   80076f <cprintf>
  8004e6:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8004e9:	a1 00 50 80 00       	mov    0x805000,%eax
  8004ee:	ff 75 0c             	pushl  0xc(%ebp)
  8004f1:	ff 75 08             	pushl  0x8(%ebp)
  8004f4:	50                   	push   %eax
  8004f5:	68 7d 3b 80 00       	push   $0x803b7d
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
  800519:	68 99 3b 80 00       	push   $0x803b99
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
  800545:	68 9c 3b 80 00       	push   $0x803b9c
  80054a:	6a 26                	push   $0x26
  80054c:	68 e8 3b 80 00       	push   $0x803be8
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
  800617:	68 f4 3b 80 00       	push   $0x803bf4
  80061c:	6a 3a                	push   $0x3a
  80061e:	68 e8 3b 80 00       	push   $0x803be8
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
  800687:	68 48 3c 80 00       	push   $0x803c48
  80068c:	6a 44                	push   $0x44
  80068e:	68 e8 3b 80 00       	push   $0x803be8
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
  8006e1:	e8 70 11 00 00       	call   801856 <sys_cputs>
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
  800758:	e8 f9 10 00 00       	call   801856 <sys_cputs>
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
  8007a2:	e8 5d 12 00 00       	call   801a04 <sys_disable_interrupt>
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
  8007c2:	e8 57 12 00 00       	call   801a1e <sys_enable_interrupt>
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
  80080c:	e8 7f 2d 00 00       	call   803590 <__udivdi3>
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
  80085c:	e8 3f 2e 00 00       	call   8036a0 <__umoddi3>
  800861:	83 c4 10             	add    $0x10,%esp
  800864:	05 b4 3e 80 00       	add    $0x803eb4,%eax
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
  8009b7:	8b 04 85 d8 3e 80 00 	mov    0x803ed8(,%eax,4),%eax
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
  800a98:	8b 34 9d 20 3d 80 00 	mov    0x803d20(,%ebx,4),%esi
  800a9f:	85 f6                	test   %esi,%esi
  800aa1:	75 19                	jne    800abc <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800aa3:	53                   	push   %ebx
  800aa4:	68 c5 3e 80 00       	push   $0x803ec5
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
  800abd:	68 ce 3e 80 00       	push   $0x803ece
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
  800aea:	be d1 3e 80 00       	mov    $0x803ed1,%esi
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
  801510:	68 30 40 80 00       	push   $0x804030
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
  8015e0:	e8 b5 03 00 00       	call   80199a <sys_allocate_chunk>
  8015e5:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8015e8:	a1 20 51 80 00       	mov    0x805120,%eax
  8015ed:	83 ec 0c             	sub    $0xc,%esp
  8015f0:	50                   	push   %eax
  8015f1:	e8 2a 0a 00 00       	call   802020 <initialize_MemBlocksList>
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
  80161e:	68 55 40 80 00       	push   $0x804055
  801623:	6a 33                	push   $0x33
  801625:	68 73 40 80 00       	push   $0x804073
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
  80169d:	68 80 40 80 00       	push   $0x804080
  8016a2:	6a 34                	push   $0x34
  8016a4:	68 73 40 80 00       	push   $0x804073
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
  801712:	68 a4 40 80 00       	push   $0x8040a4
  801717:	6a 46                	push   $0x46
  801719:	68 73 40 80 00       	push   $0x804073
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
  80172e:	68 cc 40 80 00       	push   $0x8040cc
  801733:	6a 61                	push   $0x61
  801735:	68 73 40 80 00       	push   $0x804073
  80173a:	e8 7c ed ff ff       	call   8004bb <_panic>

0080173f <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80173f:	55                   	push   %ebp
  801740:	89 e5                	mov    %esp,%ebp
  801742:	83 ec 18             	sub    $0x18,%esp
  801745:	8b 45 10             	mov    0x10(%ebp),%eax
  801748:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80174b:	e8 a9 fd ff ff       	call   8014f9 <InitializeUHeap>
	if (size == 0) return NULL ;
  801750:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801754:	75 07                	jne    80175d <smalloc+0x1e>
  801756:	b8 00 00 00 00       	mov    $0x0,%eax
  80175b:	eb 14                	jmp    801771 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  80175d:	83 ec 04             	sub    $0x4,%esp
  801760:	68 f0 40 80 00       	push   $0x8040f0
  801765:	6a 76                	push   $0x76
  801767:	68 73 40 80 00       	push   $0x804073
  80176c:	e8 4a ed ff ff       	call   8004bb <_panic>

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

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
  801776:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801779:	e8 7b fd ff ff       	call   8014f9 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  80177e:	83 ec 04             	sub    $0x4,%esp
  801781:	68 18 41 80 00       	push   $0x804118
  801786:	68 93 00 00 00       	push   $0x93
  80178b:	68 73 40 80 00       	push   $0x804073
  801790:	e8 26 ed ff ff       	call   8004bb <_panic>

00801795 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801795:	55                   	push   %ebp
  801796:	89 e5                	mov    %esp,%ebp
  801798:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80179b:	e8 59 fd ff ff       	call   8014f9 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8017a0:	83 ec 04             	sub    $0x4,%esp
  8017a3:	68 3c 41 80 00       	push   $0x80413c
  8017a8:	68 c5 00 00 00       	push   $0xc5
  8017ad:	68 73 40 80 00       	push   $0x804073
  8017b2:	e8 04 ed ff ff       	call   8004bb <_panic>

008017b7 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8017b7:	55                   	push   %ebp
  8017b8:	89 e5                	mov    %esp,%ebp
  8017ba:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8017bd:	83 ec 04             	sub    $0x4,%esp
  8017c0:	68 64 41 80 00       	push   $0x804164
  8017c5:	68 d9 00 00 00       	push   $0xd9
  8017ca:	68 73 40 80 00       	push   $0x804073
  8017cf:	e8 e7 ec ff ff       	call   8004bb <_panic>

008017d4 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8017d4:	55                   	push   %ebp
  8017d5:	89 e5                	mov    %esp,%ebp
  8017d7:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017da:	83 ec 04             	sub    $0x4,%esp
  8017dd:	68 88 41 80 00       	push   $0x804188
  8017e2:	68 e4 00 00 00       	push   $0xe4
  8017e7:	68 73 40 80 00       	push   $0x804073
  8017ec:	e8 ca ec ff ff       	call   8004bb <_panic>

008017f1 <shrink>:

}
void shrink(uint32 newSize)
{
  8017f1:	55                   	push   %ebp
  8017f2:	89 e5                	mov    %esp,%ebp
  8017f4:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017f7:	83 ec 04             	sub    $0x4,%esp
  8017fa:	68 88 41 80 00       	push   $0x804188
  8017ff:	68 e9 00 00 00       	push   $0xe9
  801804:	68 73 40 80 00       	push   $0x804073
  801809:	e8 ad ec ff ff       	call   8004bb <_panic>

0080180e <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80180e:	55                   	push   %ebp
  80180f:	89 e5                	mov    %esp,%ebp
  801811:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801814:	83 ec 04             	sub    $0x4,%esp
  801817:	68 88 41 80 00       	push   $0x804188
  80181c:	68 ee 00 00 00       	push   $0xee
  801821:	68 73 40 80 00       	push   $0x804073
  801826:	e8 90 ec ff ff       	call   8004bb <_panic>

0080182b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80182b:	55                   	push   %ebp
  80182c:	89 e5                	mov    %esp,%ebp
  80182e:	57                   	push   %edi
  80182f:	56                   	push   %esi
  801830:	53                   	push   %ebx
  801831:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801834:	8b 45 08             	mov    0x8(%ebp),%eax
  801837:	8b 55 0c             	mov    0xc(%ebp),%edx
  80183a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80183d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801840:	8b 7d 18             	mov    0x18(%ebp),%edi
  801843:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801846:	cd 30                	int    $0x30
  801848:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80184b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80184e:	83 c4 10             	add    $0x10,%esp
  801851:	5b                   	pop    %ebx
  801852:	5e                   	pop    %esi
  801853:	5f                   	pop    %edi
  801854:	5d                   	pop    %ebp
  801855:	c3                   	ret    

00801856 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801856:	55                   	push   %ebp
  801857:	89 e5                	mov    %esp,%ebp
  801859:	83 ec 04             	sub    $0x4,%esp
  80185c:	8b 45 10             	mov    0x10(%ebp),%eax
  80185f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801862:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801866:	8b 45 08             	mov    0x8(%ebp),%eax
  801869:	6a 00                	push   $0x0
  80186b:	6a 00                	push   $0x0
  80186d:	52                   	push   %edx
  80186e:	ff 75 0c             	pushl  0xc(%ebp)
  801871:	50                   	push   %eax
  801872:	6a 00                	push   $0x0
  801874:	e8 b2 ff ff ff       	call   80182b <syscall>
  801879:	83 c4 18             	add    $0x18,%esp
}
  80187c:	90                   	nop
  80187d:	c9                   	leave  
  80187e:	c3                   	ret    

0080187f <sys_cgetc>:

int
sys_cgetc(void)
{
  80187f:	55                   	push   %ebp
  801880:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801882:	6a 00                	push   $0x0
  801884:	6a 00                	push   $0x0
  801886:	6a 00                	push   $0x0
  801888:	6a 00                	push   $0x0
  80188a:	6a 00                	push   $0x0
  80188c:	6a 01                	push   $0x1
  80188e:	e8 98 ff ff ff       	call   80182b <syscall>
  801893:	83 c4 18             	add    $0x18,%esp
}
  801896:	c9                   	leave  
  801897:	c3                   	ret    

00801898 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801898:	55                   	push   %ebp
  801899:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80189b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80189e:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a1:	6a 00                	push   $0x0
  8018a3:	6a 00                	push   $0x0
  8018a5:	6a 00                	push   $0x0
  8018a7:	52                   	push   %edx
  8018a8:	50                   	push   %eax
  8018a9:	6a 05                	push   $0x5
  8018ab:	e8 7b ff ff ff       	call   80182b <syscall>
  8018b0:	83 c4 18             	add    $0x18,%esp
}
  8018b3:	c9                   	leave  
  8018b4:	c3                   	ret    

008018b5 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8018b5:	55                   	push   %ebp
  8018b6:	89 e5                	mov    %esp,%ebp
  8018b8:	56                   	push   %esi
  8018b9:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8018ba:	8b 75 18             	mov    0x18(%ebp),%esi
  8018bd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018c0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c9:	56                   	push   %esi
  8018ca:	53                   	push   %ebx
  8018cb:	51                   	push   %ecx
  8018cc:	52                   	push   %edx
  8018cd:	50                   	push   %eax
  8018ce:	6a 06                	push   $0x6
  8018d0:	e8 56 ff ff ff       	call   80182b <syscall>
  8018d5:	83 c4 18             	add    $0x18,%esp
}
  8018d8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018db:	5b                   	pop    %ebx
  8018dc:	5e                   	pop    %esi
  8018dd:	5d                   	pop    %ebp
  8018de:	c3                   	ret    

008018df <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8018df:	55                   	push   %ebp
  8018e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8018e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e8:	6a 00                	push   $0x0
  8018ea:	6a 00                	push   $0x0
  8018ec:	6a 00                	push   $0x0
  8018ee:	52                   	push   %edx
  8018ef:	50                   	push   %eax
  8018f0:	6a 07                	push   $0x7
  8018f2:	e8 34 ff ff ff       	call   80182b <syscall>
  8018f7:	83 c4 18             	add    $0x18,%esp
}
  8018fa:	c9                   	leave  
  8018fb:	c3                   	ret    

008018fc <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8018fc:	55                   	push   %ebp
  8018fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8018ff:	6a 00                	push   $0x0
  801901:	6a 00                	push   $0x0
  801903:	6a 00                	push   $0x0
  801905:	ff 75 0c             	pushl  0xc(%ebp)
  801908:	ff 75 08             	pushl  0x8(%ebp)
  80190b:	6a 08                	push   $0x8
  80190d:	e8 19 ff ff ff       	call   80182b <syscall>
  801912:	83 c4 18             	add    $0x18,%esp
}
  801915:	c9                   	leave  
  801916:	c3                   	ret    

00801917 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801917:	55                   	push   %ebp
  801918:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80191a:	6a 00                	push   $0x0
  80191c:	6a 00                	push   $0x0
  80191e:	6a 00                	push   $0x0
  801920:	6a 00                	push   $0x0
  801922:	6a 00                	push   $0x0
  801924:	6a 09                	push   $0x9
  801926:	e8 00 ff ff ff       	call   80182b <syscall>
  80192b:	83 c4 18             	add    $0x18,%esp
}
  80192e:	c9                   	leave  
  80192f:	c3                   	ret    

00801930 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801930:	55                   	push   %ebp
  801931:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801933:	6a 00                	push   $0x0
  801935:	6a 00                	push   $0x0
  801937:	6a 00                	push   $0x0
  801939:	6a 00                	push   $0x0
  80193b:	6a 00                	push   $0x0
  80193d:	6a 0a                	push   $0xa
  80193f:	e8 e7 fe ff ff       	call   80182b <syscall>
  801944:	83 c4 18             	add    $0x18,%esp
}
  801947:	c9                   	leave  
  801948:	c3                   	ret    

00801949 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801949:	55                   	push   %ebp
  80194a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80194c:	6a 00                	push   $0x0
  80194e:	6a 00                	push   $0x0
  801950:	6a 00                	push   $0x0
  801952:	6a 00                	push   $0x0
  801954:	6a 00                	push   $0x0
  801956:	6a 0b                	push   $0xb
  801958:	e8 ce fe ff ff       	call   80182b <syscall>
  80195d:	83 c4 18             	add    $0x18,%esp
}
  801960:	c9                   	leave  
  801961:	c3                   	ret    

00801962 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801962:	55                   	push   %ebp
  801963:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801965:	6a 00                	push   $0x0
  801967:	6a 00                	push   $0x0
  801969:	6a 00                	push   $0x0
  80196b:	ff 75 0c             	pushl  0xc(%ebp)
  80196e:	ff 75 08             	pushl  0x8(%ebp)
  801971:	6a 0f                	push   $0xf
  801973:	e8 b3 fe ff ff       	call   80182b <syscall>
  801978:	83 c4 18             	add    $0x18,%esp
	return;
  80197b:	90                   	nop
}
  80197c:	c9                   	leave  
  80197d:	c3                   	ret    

0080197e <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80197e:	55                   	push   %ebp
  80197f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801981:	6a 00                	push   $0x0
  801983:	6a 00                	push   $0x0
  801985:	6a 00                	push   $0x0
  801987:	ff 75 0c             	pushl  0xc(%ebp)
  80198a:	ff 75 08             	pushl  0x8(%ebp)
  80198d:	6a 10                	push   $0x10
  80198f:	e8 97 fe ff ff       	call   80182b <syscall>
  801994:	83 c4 18             	add    $0x18,%esp
	return ;
  801997:	90                   	nop
}
  801998:	c9                   	leave  
  801999:	c3                   	ret    

0080199a <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80199a:	55                   	push   %ebp
  80199b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80199d:	6a 00                	push   $0x0
  80199f:	6a 00                	push   $0x0
  8019a1:	ff 75 10             	pushl  0x10(%ebp)
  8019a4:	ff 75 0c             	pushl  0xc(%ebp)
  8019a7:	ff 75 08             	pushl  0x8(%ebp)
  8019aa:	6a 11                	push   $0x11
  8019ac:	e8 7a fe ff ff       	call   80182b <syscall>
  8019b1:	83 c4 18             	add    $0x18,%esp
	return ;
  8019b4:	90                   	nop
}
  8019b5:	c9                   	leave  
  8019b6:	c3                   	ret    

008019b7 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8019b7:	55                   	push   %ebp
  8019b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 00                	push   $0x0
  8019c0:	6a 00                	push   $0x0
  8019c2:	6a 00                	push   $0x0
  8019c4:	6a 0c                	push   $0xc
  8019c6:	e8 60 fe ff ff       	call   80182b <syscall>
  8019cb:	83 c4 18             	add    $0x18,%esp
}
  8019ce:	c9                   	leave  
  8019cf:	c3                   	ret    

008019d0 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8019d0:	55                   	push   %ebp
  8019d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 00                	push   $0x0
  8019d7:	6a 00                	push   $0x0
  8019d9:	6a 00                	push   $0x0
  8019db:	ff 75 08             	pushl  0x8(%ebp)
  8019de:	6a 0d                	push   $0xd
  8019e0:	e8 46 fe ff ff       	call   80182b <syscall>
  8019e5:	83 c4 18             	add    $0x18,%esp
}
  8019e8:	c9                   	leave  
  8019e9:	c3                   	ret    

008019ea <sys_scarce_memory>:

void sys_scarce_memory()
{
  8019ea:	55                   	push   %ebp
  8019eb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 00                	push   $0x0
  8019f1:	6a 00                	push   $0x0
  8019f3:	6a 00                	push   $0x0
  8019f5:	6a 00                	push   $0x0
  8019f7:	6a 0e                	push   $0xe
  8019f9:	e8 2d fe ff ff       	call   80182b <syscall>
  8019fe:	83 c4 18             	add    $0x18,%esp
}
  801a01:	90                   	nop
  801a02:	c9                   	leave  
  801a03:	c3                   	ret    

00801a04 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801a04:	55                   	push   %ebp
  801a05:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801a07:	6a 00                	push   $0x0
  801a09:	6a 00                	push   $0x0
  801a0b:	6a 00                	push   $0x0
  801a0d:	6a 00                	push   $0x0
  801a0f:	6a 00                	push   $0x0
  801a11:	6a 13                	push   $0x13
  801a13:	e8 13 fe ff ff       	call   80182b <syscall>
  801a18:	83 c4 18             	add    $0x18,%esp
}
  801a1b:	90                   	nop
  801a1c:	c9                   	leave  
  801a1d:	c3                   	ret    

00801a1e <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801a1e:	55                   	push   %ebp
  801a1f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801a21:	6a 00                	push   $0x0
  801a23:	6a 00                	push   $0x0
  801a25:	6a 00                	push   $0x0
  801a27:	6a 00                	push   $0x0
  801a29:	6a 00                	push   $0x0
  801a2b:	6a 14                	push   $0x14
  801a2d:	e8 f9 fd ff ff       	call   80182b <syscall>
  801a32:	83 c4 18             	add    $0x18,%esp
}
  801a35:	90                   	nop
  801a36:	c9                   	leave  
  801a37:	c3                   	ret    

00801a38 <sys_cputc>:


void
sys_cputc(const char c)
{
  801a38:	55                   	push   %ebp
  801a39:	89 e5                	mov    %esp,%ebp
  801a3b:	83 ec 04             	sub    $0x4,%esp
  801a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a41:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a44:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a48:	6a 00                	push   $0x0
  801a4a:	6a 00                	push   $0x0
  801a4c:	6a 00                	push   $0x0
  801a4e:	6a 00                	push   $0x0
  801a50:	50                   	push   %eax
  801a51:	6a 15                	push   $0x15
  801a53:	e8 d3 fd ff ff       	call   80182b <syscall>
  801a58:	83 c4 18             	add    $0x18,%esp
}
  801a5b:	90                   	nop
  801a5c:	c9                   	leave  
  801a5d:	c3                   	ret    

00801a5e <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a5e:	55                   	push   %ebp
  801a5f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a61:	6a 00                	push   $0x0
  801a63:	6a 00                	push   $0x0
  801a65:	6a 00                	push   $0x0
  801a67:	6a 00                	push   $0x0
  801a69:	6a 00                	push   $0x0
  801a6b:	6a 16                	push   $0x16
  801a6d:	e8 b9 fd ff ff       	call   80182b <syscall>
  801a72:	83 c4 18             	add    $0x18,%esp
}
  801a75:	90                   	nop
  801a76:	c9                   	leave  
  801a77:	c3                   	ret    

00801a78 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a78:	55                   	push   %ebp
  801a79:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 00                	push   $0x0
  801a82:	6a 00                	push   $0x0
  801a84:	ff 75 0c             	pushl  0xc(%ebp)
  801a87:	50                   	push   %eax
  801a88:	6a 17                	push   $0x17
  801a8a:	e8 9c fd ff ff       	call   80182b <syscall>
  801a8f:	83 c4 18             	add    $0x18,%esp
}
  801a92:	c9                   	leave  
  801a93:	c3                   	ret    

00801a94 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801a94:	55                   	push   %ebp
  801a95:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a97:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9d:	6a 00                	push   $0x0
  801a9f:	6a 00                	push   $0x0
  801aa1:	6a 00                	push   $0x0
  801aa3:	52                   	push   %edx
  801aa4:	50                   	push   %eax
  801aa5:	6a 1a                	push   $0x1a
  801aa7:	e8 7f fd ff ff       	call   80182b <syscall>
  801aac:	83 c4 18             	add    $0x18,%esp
}
  801aaf:	c9                   	leave  
  801ab0:	c3                   	ret    

00801ab1 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ab1:	55                   	push   %ebp
  801ab2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ab4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ab7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aba:	6a 00                	push   $0x0
  801abc:	6a 00                	push   $0x0
  801abe:	6a 00                	push   $0x0
  801ac0:	52                   	push   %edx
  801ac1:	50                   	push   %eax
  801ac2:	6a 18                	push   $0x18
  801ac4:	e8 62 fd ff ff       	call   80182b <syscall>
  801ac9:	83 c4 18             	add    $0x18,%esp
}
  801acc:	90                   	nop
  801acd:	c9                   	leave  
  801ace:	c3                   	ret    

00801acf <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801acf:	55                   	push   %ebp
  801ad0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ad2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ad5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad8:	6a 00                	push   $0x0
  801ada:	6a 00                	push   $0x0
  801adc:	6a 00                	push   $0x0
  801ade:	52                   	push   %edx
  801adf:	50                   	push   %eax
  801ae0:	6a 19                	push   $0x19
  801ae2:	e8 44 fd ff ff       	call   80182b <syscall>
  801ae7:	83 c4 18             	add    $0x18,%esp
}
  801aea:	90                   	nop
  801aeb:	c9                   	leave  
  801aec:	c3                   	ret    

00801aed <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801aed:	55                   	push   %ebp
  801aee:	89 e5                	mov    %esp,%ebp
  801af0:	83 ec 04             	sub    $0x4,%esp
  801af3:	8b 45 10             	mov    0x10(%ebp),%eax
  801af6:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801af9:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801afc:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b00:	8b 45 08             	mov    0x8(%ebp),%eax
  801b03:	6a 00                	push   $0x0
  801b05:	51                   	push   %ecx
  801b06:	52                   	push   %edx
  801b07:	ff 75 0c             	pushl  0xc(%ebp)
  801b0a:	50                   	push   %eax
  801b0b:	6a 1b                	push   $0x1b
  801b0d:	e8 19 fd ff ff       	call   80182b <syscall>
  801b12:	83 c4 18             	add    $0x18,%esp
}
  801b15:	c9                   	leave  
  801b16:	c3                   	ret    

00801b17 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b17:	55                   	push   %ebp
  801b18:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b1a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b20:	6a 00                	push   $0x0
  801b22:	6a 00                	push   $0x0
  801b24:	6a 00                	push   $0x0
  801b26:	52                   	push   %edx
  801b27:	50                   	push   %eax
  801b28:	6a 1c                	push   $0x1c
  801b2a:	e8 fc fc ff ff       	call   80182b <syscall>
  801b2f:	83 c4 18             	add    $0x18,%esp
}
  801b32:	c9                   	leave  
  801b33:	c3                   	ret    

00801b34 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b34:	55                   	push   %ebp
  801b35:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b37:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b40:	6a 00                	push   $0x0
  801b42:	6a 00                	push   $0x0
  801b44:	51                   	push   %ecx
  801b45:	52                   	push   %edx
  801b46:	50                   	push   %eax
  801b47:	6a 1d                	push   $0x1d
  801b49:	e8 dd fc ff ff       	call   80182b <syscall>
  801b4e:	83 c4 18             	add    $0x18,%esp
}
  801b51:	c9                   	leave  
  801b52:	c3                   	ret    

00801b53 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b53:	55                   	push   %ebp
  801b54:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b56:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b59:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5c:	6a 00                	push   $0x0
  801b5e:	6a 00                	push   $0x0
  801b60:	6a 00                	push   $0x0
  801b62:	52                   	push   %edx
  801b63:	50                   	push   %eax
  801b64:	6a 1e                	push   $0x1e
  801b66:	e8 c0 fc ff ff       	call   80182b <syscall>
  801b6b:	83 c4 18             	add    $0x18,%esp
}
  801b6e:	c9                   	leave  
  801b6f:	c3                   	ret    

00801b70 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b70:	55                   	push   %ebp
  801b71:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b73:	6a 00                	push   $0x0
  801b75:	6a 00                	push   $0x0
  801b77:	6a 00                	push   $0x0
  801b79:	6a 00                	push   $0x0
  801b7b:	6a 00                	push   $0x0
  801b7d:	6a 1f                	push   $0x1f
  801b7f:	e8 a7 fc ff ff       	call   80182b <syscall>
  801b84:	83 c4 18             	add    $0x18,%esp
}
  801b87:	c9                   	leave  
  801b88:	c3                   	ret    

00801b89 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b89:	55                   	push   %ebp
  801b8a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8f:	6a 00                	push   $0x0
  801b91:	ff 75 14             	pushl  0x14(%ebp)
  801b94:	ff 75 10             	pushl  0x10(%ebp)
  801b97:	ff 75 0c             	pushl  0xc(%ebp)
  801b9a:	50                   	push   %eax
  801b9b:	6a 20                	push   $0x20
  801b9d:	e8 89 fc ff ff       	call   80182b <syscall>
  801ba2:	83 c4 18             	add    $0x18,%esp
}
  801ba5:	c9                   	leave  
  801ba6:	c3                   	ret    

00801ba7 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801ba7:	55                   	push   %ebp
  801ba8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801baa:	8b 45 08             	mov    0x8(%ebp),%eax
  801bad:	6a 00                	push   $0x0
  801baf:	6a 00                	push   $0x0
  801bb1:	6a 00                	push   $0x0
  801bb3:	6a 00                	push   $0x0
  801bb5:	50                   	push   %eax
  801bb6:	6a 21                	push   $0x21
  801bb8:	e8 6e fc ff ff       	call   80182b <syscall>
  801bbd:	83 c4 18             	add    $0x18,%esp
}
  801bc0:	90                   	nop
  801bc1:	c9                   	leave  
  801bc2:	c3                   	ret    

00801bc3 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801bc3:	55                   	push   %ebp
  801bc4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801bc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc9:	6a 00                	push   $0x0
  801bcb:	6a 00                	push   $0x0
  801bcd:	6a 00                	push   $0x0
  801bcf:	6a 00                	push   $0x0
  801bd1:	50                   	push   %eax
  801bd2:	6a 22                	push   $0x22
  801bd4:	e8 52 fc ff ff       	call   80182b <syscall>
  801bd9:	83 c4 18             	add    $0x18,%esp
}
  801bdc:	c9                   	leave  
  801bdd:	c3                   	ret    

00801bde <sys_getenvid>:

int32 sys_getenvid(void)
{
  801bde:	55                   	push   %ebp
  801bdf:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801be1:	6a 00                	push   $0x0
  801be3:	6a 00                	push   $0x0
  801be5:	6a 00                	push   $0x0
  801be7:	6a 00                	push   $0x0
  801be9:	6a 00                	push   $0x0
  801beb:	6a 02                	push   $0x2
  801bed:	e8 39 fc ff ff       	call   80182b <syscall>
  801bf2:	83 c4 18             	add    $0x18,%esp
}
  801bf5:	c9                   	leave  
  801bf6:	c3                   	ret    

00801bf7 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801bf7:	55                   	push   %ebp
  801bf8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801bfa:	6a 00                	push   $0x0
  801bfc:	6a 00                	push   $0x0
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 00                	push   $0x0
  801c02:	6a 00                	push   $0x0
  801c04:	6a 03                	push   $0x3
  801c06:	e8 20 fc ff ff       	call   80182b <syscall>
  801c0b:	83 c4 18             	add    $0x18,%esp
}
  801c0e:	c9                   	leave  
  801c0f:	c3                   	ret    

00801c10 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c10:	55                   	push   %ebp
  801c11:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c13:	6a 00                	push   $0x0
  801c15:	6a 00                	push   $0x0
  801c17:	6a 00                	push   $0x0
  801c19:	6a 00                	push   $0x0
  801c1b:	6a 00                	push   $0x0
  801c1d:	6a 04                	push   $0x4
  801c1f:	e8 07 fc ff ff       	call   80182b <syscall>
  801c24:	83 c4 18             	add    $0x18,%esp
}
  801c27:	c9                   	leave  
  801c28:	c3                   	ret    

00801c29 <sys_exit_env>:


void sys_exit_env(void)
{
  801c29:	55                   	push   %ebp
  801c2a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c2c:	6a 00                	push   $0x0
  801c2e:	6a 00                	push   $0x0
  801c30:	6a 00                	push   $0x0
  801c32:	6a 00                	push   $0x0
  801c34:	6a 00                	push   $0x0
  801c36:	6a 23                	push   $0x23
  801c38:	e8 ee fb ff ff       	call   80182b <syscall>
  801c3d:	83 c4 18             	add    $0x18,%esp
}
  801c40:	90                   	nop
  801c41:	c9                   	leave  
  801c42:	c3                   	ret    

00801c43 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801c43:	55                   	push   %ebp
  801c44:	89 e5                	mov    %esp,%ebp
  801c46:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c49:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c4c:	8d 50 04             	lea    0x4(%eax),%edx
  801c4f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c52:	6a 00                	push   $0x0
  801c54:	6a 00                	push   $0x0
  801c56:	6a 00                	push   $0x0
  801c58:	52                   	push   %edx
  801c59:	50                   	push   %eax
  801c5a:	6a 24                	push   $0x24
  801c5c:	e8 ca fb ff ff       	call   80182b <syscall>
  801c61:	83 c4 18             	add    $0x18,%esp
	return result;
  801c64:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c67:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c6a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c6d:	89 01                	mov    %eax,(%ecx)
  801c6f:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c72:	8b 45 08             	mov    0x8(%ebp),%eax
  801c75:	c9                   	leave  
  801c76:	c2 04 00             	ret    $0x4

00801c79 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c79:	55                   	push   %ebp
  801c7a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c7c:	6a 00                	push   $0x0
  801c7e:	6a 00                	push   $0x0
  801c80:	ff 75 10             	pushl  0x10(%ebp)
  801c83:	ff 75 0c             	pushl  0xc(%ebp)
  801c86:	ff 75 08             	pushl  0x8(%ebp)
  801c89:	6a 12                	push   $0x12
  801c8b:	e8 9b fb ff ff       	call   80182b <syscall>
  801c90:	83 c4 18             	add    $0x18,%esp
	return ;
  801c93:	90                   	nop
}
  801c94:	c9                   	leave  
  801c95:	c3                   	ret    

00801c96 <sys_rcr2>:
uint32 sys_rcr2()
{
  801c96:	55                   	push   %ebp
  801c97:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c99:	6a 00                	push   $0x0
  801c9b:	6a 00                	push   $0x0
  801c9d:	6a 00                	push   $0x0
  801c9f:	6a 00                	push   $0x0
  801ca1:	6a 00                	push   $0x0
  801ca3:	6a 25                	push   $0x25
  801ca5:	e8 81 fb ff ff       	call   80182b <syscall>
  801caa:	83 c4 18             	add    $0x18,%esp
}
  801cad:	c9                   	leave  
  801cae:	c3                   	ret    

00801caf <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801caf:	55                   	push   %ebp
  801cb0:	89 e5                	mov    %esp,%ebp
  801cb2:	83 ec 04             	sub    $0x4,%esp
  801cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801cbb:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801cbf:	6a 00                	push   $0x0
  801cc1:	6a 00                	push   $0x0
  801cc3:	6a 00                	push   $0x0
  801cc5:	6a 00                	push   $0x0
  801cc7:	50                   	push   %eax
  801cc8:	6a 26                	push   $0x26
  801cca:	e8 5c fb ff ff       	call   80182b <syscall>
  801ccf:	83 c4 18             	add    $0x18,%esp
	return ;
  801cd2:	90                   	nop
}
  801cd3:	c9                   	leave  
  801cd4:	c3                   	ret    

00801cd5 <rsttst>:
void rsttst()
{
  801cd5:	55                   	push   %ebp
  801cd6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801cd8:	6a 00                	push   $0x0
  801cda:	6a 00                	push   $0x0
  801cdc:	6a 00                	push   $0x0
  801cde:	6a 00                	push   $0x0
  801ce0:	6a 00                	push   $0x0
  801ce2:	6a 28                	push   $0x28
  801ce4:	e8 42 fb ff ff       	call   80182b <syscall>
  801ce9:	83 c4 18             	add    $0x18,%esp
	return ;
  801cec:	90                   	nop
}
  801ced:	c9                   	leave  
  801cee:	c3                   	ret    

00801cef <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801cef:	55                   	push   %ebp
  801cf0:	89 e5                	mov    %esp,%ebp
  801cf2:	83 ec 04             	sub    $0x4,%esp
  801cf5:	8b 45 14             	mov    0x14(%ebp),%eax
  801cf8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801cfb:	8b 55 18             	mov    0x18(%ebp),%edx
  801cfe:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d02:	52                   	push   %edx
  801d03:	50                   	push   %eax
  801d04:	ff 75 10             	pushl  0x10(%ebp)
  801d07:	ff 75 0c             	pushl  0xc(%ebp)
  801d0a:	ff 75 08             	pushl  0x8(%ebp)
  801d0d:	6a 27                	push   $0x27
  801d0f:	e8 17 fb ff ff       	call   80182b <syscall>
  801d14:	83 c4 18             	add    $0x18,%esp
	return ;
  801d17:	90                   	nop
}
  801d18:	c9                   	leave  
  801d19:	c3                   	ret    

00801d1a <chktst>:
void chktst(uint32 n)
{
  801d1a:	55                   	push   %ebp
  801d1b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d1d:	6a 00                	push   $0x0
  801d1f:	6a 00                	push   $0x0
  801d21:	6a 00                	push   $0x0
  801d23:	6a 00                	push   $0x0
  801d25:	ff 75 08             	pushl  0x8(%ebp)
  801d28:	6a 29                	push   $0x29
  801d2a:	e8 fc fa ff ff       	call   80182b <syscall>
  801d2f:	83 c4 18             	add    $0x18,%esp
	return ;
  801d32:	90                   	nop
}
  801d33:	c9                   	leave  
  801d34:	c3                   	ret    

00801d35 <inctst>:

void inctst()
{
  801d35:	55                   	push   %ebp
  801d36:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d38:	6a 00                	push   $0x0
  801d3a:	6a 00                	push   $0x0
  801d3c:	6a 00                	push   $0x0
  801d3e:	6a 00                	push   $0x0
  801d40:	6a 00                	push   $0x0
  801d42:	6a 2a                	push   $0x2a
  801d44:	e8 e2 fa ff ff       	call   80182b <syscall>
  801d49:	83 c4 18             	add    $0x18,%esp
	return ;
  801d4c:	90                   	nop
}
  801d4d:	c9                   	leave  
  801d4e:	c3                   	ret    

00801d4f <gettst>:
uint32 gettst()
{
  801d4f:	55                   	push   %ebp
  801d50:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d52:	6a 00                	push   $0x0
  801d54:	6a 00                	push   $0x0
  801d56:	6a 00                	push   $0x0
  801d58:	6a 00                	push   $0x0
  801d5a:	6a 00                	push   $0x0
  801d5c:	6a 2b                	push   $0x2b
  801d5e:	e8 c8 fa ff ff       	call   80182b <syscall>
  801d63:	83 c4 18             	add    $0x18,%esp
}
  801d66:	c9                   	leave  
  801d67:	c3                   	ret    

00801d68 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d68:	55                   	push   %ebp
  801d69:	89 e5                	mov    %esp,%ebp
  801d6b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d6e:	6a 00                	push   $0x0
  801d70:	6a 00                	push   $0x0
  801d72:	6a 00                	push   $0x0
  801d74:	6a 00                	push   $0x0
  801d76:	6a 00                	push   $0x0
  801d78:	6a 2c                	push   $0x2c
  801d7a:	e8 ac fa ff ff       	call   80182b <syscall>
  801d7f:	83 c4 18             	add    $0x18,%esp
  801d82:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d85:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d89:	75 07                	jne    801d92 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d8b:	b8 01 00 00 00       	mov    $0x1,%eax
  801d90:	eb 05                	jmp    801d97 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d92:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d97:	c9                   	leave  
  801d98:	c3                   	ret    

00801d99 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d99:	55                   	push   %ebp
  801d9a:	89 e5                	mov    %esp,%ebp
  801d9c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d9f:	6a 00                	push   $0x0
  801da1:	6a 00                	push   $0x0
  801da3:	6a 00                	push   $0x0
  801da5:	6a 00                	push   $0x0
  801da7:	6a 00                	push   $0x0
  801da9:	6a 2c                	push   $0x2c
  801dab:	e8 7b fa ff ff       	call   80182b <syscall>
  801db0:	83 c4 18             	add    $0x18,%esp
  801db3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801db6:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801dba:	75 07                	jne    801dc3 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801dbc:	b8 01 00 00 00       	mov    $0x1,%eax
  801dc1:	eb 05                	jmp    801dc8 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801dc3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dc8:	c9                   	leave  
  801dc9:	c3                   	ret    

00801dca <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801dca:	55                   	push   %ebp
  801dcb:	89 e5                	mov    %esp,%ebp
  801dcd:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dd0:	6a 00                	push   $0x0
  801dd2:	6a 00                	push   $0x0
  801dd4:	6a 00                	push   $0x0
  801dd6:	6a 00                	push   $0x0
  801dd8:	6a 00                	push   $0x0
  801dda:	6a 2c                	push   $0x2c
  801ddc:	e8 4a fa ff ff       	call   80182b <syscall>
  801de1:	83 c4 18             	add    $0x18,%esp
  801de4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801de7:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801deb:	75 07                	jne    801df4 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801ded:	b8 01 00 00 00       	mov    $0x1,%eax
  801df2:	eb 05                	jmp    801df9 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801df4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801df9:	c9                   	leave  
  801dfa:	c3                   	ret    

00801dfb <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801dfb:	55                   	push   %ebp
  801dfc:	89 e5                	mov    %esp,%ebp
  801dfe:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e01:	6a 00                	push   $0x0
  801e03:	6a 00                	push   $0x0
  801e05:	6a 00                	push   $0x0
  801e07:	6a 00                	push   $0x0
  801e09:	6a 00                	push   $0x0
  801e0b:	6a 2c                	push   $0x2c
  801e0d:	e8 19 fa ff ff       	call   80182b <syscall>
  801e12:	83 c4 18             	add    $0x18,%esp
  801e15:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e18:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e1c:	75 07                	jne    801e25 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e1e:	b8 01 00 00 00       	mov    $0x1,%eax
  801e23:	eb 05                	jmp    801e2a <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e25:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e2a:	c9                   	leave  
  801e2b:	c3                   	ret    

00801e2c <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e2c:	55                   	push   %ebp
  801e2d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e2f:	6a 00                	push   $0x0
  801e31:	6a 00                	push   $0x0
  801e33:	6a 00                	push   $0x0
  801e35:	6a 00                	push   $0x0
  801e37:	ff 75 08             	pushl  0x8(%ebp)
  801e3a:	6a 2d                	push   $0x2d
  801e3c:	e8 ea f9 ff ff       	call   80182b <syscall>
  801e41:	83 c4 18             	add    $0x18,%esp
	return ;
  801e44:	90                   	nop
}
  801e45:	c9                   	leave  
  801e46:	c3                   	ret    

00801e47 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e47:	55                   	push   %ebp
  801e48:	89 e5                	mov    %esp,%ebp
  801e4a:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e4b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e4e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e51:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e54:	8b 45 08             	mov    0x8(%ebp),%eax
  801e57:	6a 00                	push   $0x0
  801e59:	53                   	push   %ebx
  801e5a:	51                   	push   %ecx
  801e5b:	52                   	push   %edx
  801e5c:	50                   	push   %eax
  801e5d:	6a 2e                	push   $0x2e
  801e5f:	e8 c7 f9 ff ff       	call   80182b <syscall>
  801e64:	83 c4 18             	add    $0x18,%esp
}
  801e67:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e6a:	c9                   	leave  
  801e6b:	c3                   	ret    

00801e6c <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e6c:	55                   	push   %ebp
  801e6d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e6f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e72:	8b 45 08             	mov    0x8(%ebp),%eax
  801e75:	6a 00                	push   $0x0
  801e77:	6a 00                	push   $0x0
  801e79:	6a 00                	push   $0x0
  801e7b:	52                   	push   %edx
  801e7c:	50                   	push   %eax
  801e7d:	6a 2f                	push   $0x2f
  801e7f:	e8 a7 f9 ff ff       	call   80182b <syscall>
  801e84:	83 c4 18             	add    $0x18,%esp
}
  801e87:	c9                   	leave  
  801e88:	c3                   	ret    

00801e89 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801e89:	55                   	push   %ebp
  801e8a:	89 e5                	mov    %esp,%ebp
  801e8c:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801e8f:	83 ec 0c             	sub    $0xc,%esp
  801e92:	68 98 41 80 00       	push   $0x804198
  801e97:	e8 d3 e8 ff ff       	call   80076f <cprintf>
  801e9c:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801e9f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801ea6:	83 ec 0c             	sub    $0xc,%esp
  801ea9:	68 c4 41 80 00       	push   $0x8041c4
  801eae:	e8 bc e8 ff ff       	call   80076f <cprintf>
  801eb3:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801eb6:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801eba:	a1 38 51 80 00       	mov    0x805138,%eax
  801ebf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ec2:	eb 56                	jmp    801f1a <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801ec4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ec8:	74 1c                	je     801ee6 <print_mem_block_lists+0x5d>
  801eca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ecd:	8b 50 08             	mov    0x8(%eax),%edx
  801ed0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ed3:	8b 48 08             	mov    0x8(%eax),%ecx
  801ed6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ed9:	8b 40 0c             	mov    0xc(%eax),%eax
  801edc:	01 c8                	add    %ecx,%eax
  801ede:	39 c2                	cmp    %eax,%edx
  801ee0:	73 04                	jae    801ee6 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801ee2:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801ee6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee9:	8b 50 08             	mov    0x8(%eax),%edx
  801eec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eef:	8b 40 0c             	mov    0xc(%eax),%eax
  801ef2:	01 c2                	add    %eax,%edx
  801ef4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef7:	8b 40 08             	mov    0x8(%eax),%eax
  801efa:	83 ec 04             	sub    $0x4,%esp
  801efd:	52                   	push   %edx
  801efe:	50                   	push   %eax
  801eff:	68 d9 41 80 00       	push   $0x8041d9
  801f04:	e8 66 e8 ff ff       	call   80076f <cprintf>
  801f09:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f0f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f12:	a1 40 51 80 00       	mov    0x805140,%eax
  801f17:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f1a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f1e:	74 07                	je     801f27 <print_mem_block_lists+0x9e>
  801f20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f23:	8b 00                	mov    (%eax),%eax
  801f25:	eb 05                	jmp    801f2c <print_mem_block_lists+0xa3>
  801f27:	b8 00 00 00 00       	mov    $0x0,%eax
  801f2c:	a3 40 51 80 00       	mov    %eax,0x805140
  801f31:	a1 40 51 80 00       	mov    0x805140,%eax
  801f36:	85 c0                	test   %eax,%eax
  801f38:	75 8a                	jne    801ec4 <print_mem_block_lists+0x3b>
  801f3a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f3e:	75 84                	jne    801ec4 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801f40:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f44:	75 10                	jne    801f56 <print_mem_block_lists+0xcd>
  801f46:	83 ec 0c             	sub    $0xc,%esp
  801f49:	68 e8 41 80 00       	push   $0x8041e8
  801f4e:	e8 1c e8 ff ff       	call   80076f <cprintf>
  801f53:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801f56:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801f5d:	83 ec 0c             	sub    $0xc,%esp
  801f60:	68 0c 42 80 00       	push   $0x80420c
  801f65:	e8 05 e8 ff ff       	call   80076f <cprintf>
  801f6a:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801f6d:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f71:	a1 40 50 80 00       	mov    0x805040,%eax
  801f76:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f79:	eb 56                	jmp    801fd1 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f7b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f7f:	74 1c                	je     801f9d <print_mem_block_lists+0x114>
  801f81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f84:	8b 50 08             	mov    0x8(%eax),%edx
  801f87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f8a:	8b 48 08             	mov    0x8(%eax),%ecx
  801f8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f90:	8b 40 0c             	mov    0xc(%eax),%eax
  801f93:	01 c8                	add    %ecx,%eax
  801f95:	39 c2                	cmp    %eax,%edx
  801f97:	73 04                	jae    801f9d <print_mem_block_lists+0x114>
			sorted = 0 ;
  801f99:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa0:	8b 50 08             	mov    0x8(%eax),%edx
  801fa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa6:	8b 40 0c             	mov    0xc(%eax),%eax
  801fa9:	01 c2                	add    %eax,%edx
  801fab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fae:	8b 40 08             	mov    0x8(%eax),%eax
  801fb1:	83 ec 04             	sub    $0x4,%esp
  801fb4:	52                   	push   %edx
  801fb5:	50                   	push   %eax
  801fb6:	68 d9 41 80 00       	push   $0x8041d9
  801fbb:	e8 af e7 ff ff       	call   80076f <cprintf>
  801fc0:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801fc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801fc9:	a1 48 50 80 00       	mov    0x805048,%eax
  801fce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fd1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fd5:	74 07                	je     801fde <print_mem_block_lists+0x155>
  801fd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fda:	8b 00                	mov    (%eax),%eax
  801fdc:	eb 05                	jmp    801fe3 <print_mem_block_lists+0x15a>
  801fde:	b8 00 00 00 00       	mov    $0x0,%eax
  801fe3:	a3 48 50 80 00       	mov    %eax,0x805048
  801fe8:	a1 48 50 80 00       	mov    0x805048,%eax
  801fed:	85 c0                	test   %eax,%eax
  801fef:	75 8a                	jne    801f7b <print_mem_block_lists+0xf2>
  801ff1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ff5:	75 84                	jne    801f7b <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801ff7:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801ffb:	75 10                	jne    80200d <print_mem_block_lists+0x184>
  801ffd:	83 ec 0c             	sub    $0xc,%esp
  802000:	68 24 42 80 00       	push   $0x804224
  802005:	e8 65 e7 ff ff       	call   80076f <cprintf>
  80200a:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80200d:	83 ec 0c             	sub    $0xc,%esp
  802010:	68 98 41 80 00       	push   $0x804198
  802015:	e8 55 e7 ff ff       	call   80076f <cprintf>
  80201a:	83 c4 10             	add    $0x10,%esp

}
  80201d:	90                   	nop
  80201e:	c9                   	leave  
  80201f:	c3                   	ret    

00802020 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802020:	55                   	push   %ebp
  802021:	89 e5                	mov    %esp,%ebp
  802023:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  802026:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  80202d:	00 00 00 
  802030:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802037:	00 00 00 
  80203a:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802041:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  802044:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80204b:	e9 9e 00 00 00       	jmp    8020ee <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802050:	a1 50 50 80 00       	mov    0x805050,%eax
  802055:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802058:	c1 e2 04             	shl    $0x4,%edx
  80205b:	01 d0                	add    %edx,%eax
  80205d:	85 c0                	test   %eax,%eax
  80205f:	75 14                	jne    802075 <initialize_MemBlocksList+0x55>
  802061:	83 ec 04             	sub    $0x4,%esp
  802064:	68 4c 42 80 00       	push   $0x80424c
  802069:	6a 46                	push   $0x46
  80206b:	68 6f 42 80 00       	push   $0x80426f
  802070:	e8 46 e4 ff ff       	call   8004bb <_panic>
  802075:	a1 50 50 80 00       	mov    0x805050,%eax
  80207a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80207d:	c1 e2 04             	shl    $0x4,%edx
  802080:	01 d0                	add    %edx,%eax
  802082:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802088:	89 10                	mov    %edx,(%eax)
  80208a:	8b 00                	mov    (%eax),%eax
  80208c:	85 c0                	test   %eax,%eax
  80208e:	74 18                	je     8020a8 <initialize_MemBlocksList+0x88>
  802090:	a1 48 51 80 00       	mov    0x805148,%eax
  802095:	8b 15 50 50 80 00    	mov    0x805050,%edx
  80209b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80209e:	c1 e1 04             	shl    $0x4,%ecx
  8020a1:	01 ca                	add    %ecx,%edx
  8020a3:	89 50 04             	mov    %edx,0x4(%eax)
  8020a6:	eb 12                	jmp    8020ba <initialize_MemBlocksList+0x9a>
  8020a8:	a1 50 50 80 00       	mov    0x805050,%eax
  8020ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020b0:	c1 e2 04             	shl    $0x4,%edx
  8020b3:	01 d0                	add    %edx,%eax
  8020b5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8020ba:	a1 50 50 80 00       	mov    0x805050,%eax
  8020bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020c2:	c1 e2 04             	shl    $0x4,%edx
  8020c5:	01 d0                	add    %edx,%eax
  8020c7:	a3 48 51 80 00       	mov    %eax,0x805148
  8020cc:	a1 50 50 80 00       	mov    0x805050,%eax
  8020d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020d4:	c1 e2 04             	shl    $0x4,%edx
  8020d7:	01 d0                	add    %edx,%eax
  8020d9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020e0:	a1 54 51 80 00       	mov    0x805154,%eax
  8020e5:	40                   	inc    %eax
  8020e6:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  8020eb:	ff 45 f4             	incl   -0xc(%ebp)
  8020ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8020f4:	0f 82 56 ff ff ff    	jb     802050 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  8020fa:	90                   	nop
  8020fb:	c9                   	leave  
  8020fc:	c3                   	ret    

008020fd <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8020fd:	55                   	push   %ebp
  8020fe:	89 e5                	mov    %esp,%ebp
  802100:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802103:	8b 45 08             	mov    0x8(%ebp),%eax
  802106:	8b 00                	mov    (%eax),%eax
  802108:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80210b:	eb 19                	jmp    802126 <find_block+0x29>
	{
		if(va==point->sva)
  80210d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802110:	8b 40 08             	mov    0x8(%eax),%eax
  802113:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802116:	75 05                	jne    80211d <find_block+0x20>
		   return point;
  802118:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80211b:	eb 36                	jmp    802153 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80211d:	8b 45 08             	mov    0x8(%ebp),%eax
  802120:	8b 40 08             	mov    0x8(%eax),%eax
  802123:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802126:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80212a:	74 07                	je     802133 <find_block+0x36>
  80212c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80212f:	8b 00                	mov    (%eax),%eax
  802131:	eb 05                	jmp    802138 <find_block+0x3b>
  802133:	b8 00 00 00 00       	mov    $0x0,%eax
  802138:	8b 55 08             	mov    0x8(%ebp),%edx
  80213b:	89 42 08             	mov    %eax,0x8(%edx)
  80213e:	8b 45 08             	mov    0x8(%ebp),%eax
  802141:	8b 40 08             	mov    0x8(%eax),%eax
  802144:	85 c0                	test   %eax,%eax
  802146:	75 c5                	jne    80210d <find_block+0x10>
  802148:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80214c:	75 bf                	jne    80210d <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  80214e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802153:	c9                   	leave  
  802154:	c3                   	ret    

00802155 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802155:	55                   	push   %ebp
  802156:	89 e5                	mov    %esp,%ebp
  802158:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  80215b:	a1 40 50 80 00       	mov    0x805040,%eax
  802160:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802163:	a1 44 50 80 00       	mov    0x805044,%eax
  802168:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  80216b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80216e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802171:	74 24                	je     802197 <insert_sorted_allocList+0x42>
  802173:	8b 45 08             	mov    0x8(%ebp),%eax
  802176:	8b 50 08             	mov    0x8(%eax),%edx
  802179:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80217c:	8b 40 08             	mov    0x8(%eax),%eax
  80217f:	39 c2                	cmp    %eax,%edx
  802181:	76 14                	jbe    802197 <insert_sorted_allocList+0x42>
  802183:	8b 45 08             	mov    0x8(%ebp),%eax
  802186:	8b 50 08             	mov    0x8(%eax),%edx
  802189:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80218c:	8b 40 08             	mov    0x8(%eax),%eax
  80218f:	39 c2                	cmp    %eax,%edx
  802191:	0f 82 60 01 00 00    	jb     8022f7 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802197:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80219b:	75 65                	jne    802202 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  80219d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021a1:	75 14                	jne    8021b7 <insert_sorted_allocList+0x62>
  8021a3:	83 ec 04             	sub    $0x4,%esp
  8021a6:	68 4c 42 80 00       	push   $0x80424c
  8021ab:	6a 6b                	push   $0x6b
  8021ad:	68 6f 42 80 00       	push   $0x80426f
  8021b2:	e8 04 e3 ff ff       	call   8004bb <_panic>
  8021b7:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8021bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c0:	89 10                	mov    %edx,(%eax)
  8021c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c5:	8b 00                	mov    (%eax),%eax
  8021c7:	85 c0                	test   %eax,%eax
  8021c9:	74 0d                	je     8021d8 <insert_sorted_allocList+0x83>
  8021cb:	a1 40 50 80 00       	mov    0x805040,%eax
  8021d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8021d3:	89 50 04             	mov    %edx,0x4(%eax)
  8021d6:	eb 08                	jmp    8021e0 <insert_sorted_allocList+0x8b>
  8021d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021db:	a3 44 50 80 00       	mov    %eax,0x805044
  8021e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e3:	a3 40 50 80 00       	mov    %eax,0x805040
  8021e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021eb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021f2:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8021f7:	40                   	inc    %eax
  8021f8:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8021fd:	e9 dc 01 00 00       	jmp    8023de <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802202:	8b 45 08             	mov    0x8(%ebp),%eax
  802205:	8b 50 08             	mov    0x8(%eax),%edx
  802208:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80220b:	8b 40 08             	mov    0x8(%eax),%eax
  80220e:	39 c2                	cmp    %eax,%edx
  802210:	77 6c                	ja     80227e <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802212:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802216:	74 06                	je     80221e <insert_sorted_allocList+0xc9>
  802218:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80221c:	75 14                	jne    802232 <insert_sorted_allocList+0xdd>
  80221e:	83 ec 04             	sub    $0x4,%esp
  802221:	68 88 42 80 00       	push   $0x804288
  802226:	6a 6f                	push   $0x6f
  802228:	68 6f 42 80 00       	push   $0x80426f
  80222d:	e8 89 e2 ff ff       	call   8004bb <_panic>
  802232:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802235:	8b 50 04             	mov    0x4(%eax),%edx
  802238:	8b 45 08             	mov    0x8(%ebp),%eax
  80223b:	89 50 04             	mov    %edx,0x4(%eax)
  80223e:	8b 45 08             	mov    0x8(%ebp),%eax
  802241:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802244:	89 10                	mov    %edx,(%eax)
  802246:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802249:	8b 40 04             	mov    0x4(%eax),%eax
  80224c:	85 c0                	test   %eax,%eax
  80224e:	74 0d                	je     80225d <insert_sorted_allocList+0x108>
  802250:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802253:	8b 40 04             	mov    0x4(%eax),%eax
  802256:	8b 55 08             	mov    0x8(%ebp),%edx
  802259:	89 10                	mov    %edx,(%eax)
  80225b:	eb 08                	jmp    802265 <insert_sorted_allocList+0x110>
  80225d:	8b 45 08             	mov    0x8(%ebp),%eax
  802260:	a3 40 50 80 00       	mov    %eax,0x805040
  802265:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802268:	8b 55 08             	mov    0x8(%ebp),%edx
  80226b:	89 50 04             	mov    %edx,0x4(%eax)
  80226e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802273:	40                   	inc    %eax
  802274:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802279:	e9 60 01 00 00       	jmp    8023de <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  80227e:	8b 45 08             	mov    0x8(%ebp),%eax
  802281:	8b 50 08             	mov    0x8(%eax),%edx
  802284:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802287:	8b 40 08             	mov    0x8(%eax),%eax
  80228a:	39 c2                	cmp    %eax,%edx
  80228c:	0f 82 4c 01 00 00    	jb     8023de <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802292:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802296:	75 14                	jne    8022ac <insert_sorted_allocList+0x157>
  802298:	83 ec 04             	sub    $0x4,%esp
  80229b:	68 c0 42 80 00       	push   $0x8042c0
  8022a0:	6a 73                	push   $0x73
  8022a2:	68 6f 42 80 00       	push   $0x80426f
  8022a7:	e8 0f e2 ff ff       	call   8004bb <_panic>
  8022ac:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8022b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b5:	89 50 04             	mov    %edx,0x4(%eax)
  8022b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bb:	8b 40 04             	mov    0x4(%eax),%eax
  8022be:	85 c0                	test   %eax,%eax
  8022c0:	74 0c                	je     8022ce <insert_sorted_allocList+0x179>
  8022c2:	a1 44 50 80 00       	mov    0x805044,%eax
  8022c7:	8b 55 08             	mov    0x8(%ebp),%edx
  8022ca:	89 10                	mov    %edx,(%eax)
  8022cc:	eb 08                	jmp    8022d6 <insert_sorted_allocList+0x181>
  8022ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d1:	a3 40 50 80 00       	mov    %eax,0x805040
  8022d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d9:	a3 44 50 80 00       	mov    %eax,0x805044
  8022de:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022e7:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8022ec:	40                   	inc    %eax
  8022ed:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8022f2:	e9 e7 00 00 00       	jmp    8023de <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8022f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8022fd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802304:	a1 40 50 80 00       	mov    0x805040,%eax
  802309:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80230c:	e9 9d 00 00 00       	jmp    8023ae <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802311:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802314:	8b 00                	mov    (%eax),%eax
  802316:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802319:	8b 45 08             	mov    0x8(%ebp),%eax
  80231c:	8b 50 08             	mov    0x8(%eax),%edx
  80231f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802322:	8b 40 08             	mov    0x8(%eax),%eax
  802325:	39 c2                	cmp    %eax,%edx
  802327:	76 7d                	jbe    8023a6 <insert_sorted_allocList+0x251>
  802329:	8b 45 08             	mov    0x8(%ebp),%eax
  80232c:	8b 50 08             	mov    0x8(%eax),%edx
  80232f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802332:	8b 40 08             	mov    0x8(%eax),%eax
  802335:	39 c2                	cmp    %eax,%edx
  802337:	73 6d                	jae    8023a6 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802339:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80233d:	74 06                	je     802345 <insert_sorted_allocList+0x1f0>
  80233f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802343:	75 14                	jne    802359 <insert_sorted_allocList+0x204>
  802345:	83 ec 04             	sub    $0x4,%esp
  802348:	68 e4 42 80 00       	push   $0x8042e4
  80234d:	6a 7f                	push   $0x7f
  80234f:	68 6f 42 80 00       	push   $0x80426f
  802354:	e8 62 e1 ff ff       	call   8004bb <_panic>
  802359:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235c:	8b 10                	mov    (%eax),%edx
  80235e:	8b 45 08             	mov    0x8(%ebp),%eax
  802361:	89 10                	mov    %edx,(%eax)
  802363:	8b 45 08             	mov    0x8(%ebp),%eax
  802366:	8b 00                	mov    (%eax),%eax
  802368:	85 c0                	test   %eax,%eax
  80236a:	74 0b                	je     802377 <insert_sorted_allocList+0x222>
  80236c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236f:	8b 00                	mov    (%eax),%eax
  802371:	8b 55 08             	mov    0x8(%ebp),%edx
  802374:	89 50 04             	mov    %edx,0x4(%eax)
  802377:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237a:	8b 55 08             	mov    0x8(%ebp),%edx
  80237d:	89 10                	mov    %edx,(%eax)
  80237f:	8b 45 08             	mov    0x8(%ebp),%eax
  802382:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802385:	89 50 04             	mov    %edx,0x4(%eax)
  802388:	8b 45 08             	mov    0x8(%ebp),%eax
  80238b:	8b 00                	mov    (%eax),%eax
  80238d:	85 c0                	test   %eax,%eax
  80238f:	75 08                	jne    802399 <insert_sorted_allocList+0x244>
  802391:	8b 45 08             	mov    0x8(%ebp),%eax
  802394:	a3 44 50 80 00       	mov    %eax,0x805044
  802399:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80239e:	40                   	inc    %eax
  80239f:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8023a4:	eb 39                	jmp    8023df <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8023a6:	a1 48 50 80 00       	mov    0x805048,%eax
  8023ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023b2:	74 07                	je     8023bb <insert_sorted_allocList+0x266>
  8023b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b7:	8b 00                	mov    (%eax),%eax
  8023b9:	eb 05                	jmp    8023c0 <insert_sorted_allocList+0x26b>
  8023bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8023c0:	a3 48 50 80 00       	mov    %eax,0x805048
  8023c5:	a1 48 50 80 00       	mov    0x805048,%eax
  8023ca:	85 c0                	test   %eax,%eax
  8023cc:	0f 85 3f ff ff ff    	jne    802311 <insert_sorted_allocList+0x1bc>
  8023d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023d6:	0f 85 35 ff ff ff    	jne    802311 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8023dc:	eb 01                	jmp    8023df <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8023de:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8023df:	90                   	nop
  8023e0:	c9                   	leave  
  8023e1:	c3                   	ret    

008023e2 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8023e2:	55                   	push   %ebp
  8023e3:	89 e5                	mov    %esp,%ebp
  8023e5:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8023e8:	a1 38 51 80 00       	mov    0x805138,%eax
  8023ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023f0:	e9 85 01 00 00       	jmp    80257a <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8023f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f8:	8b 40 0c             	mov    0xc(%eax),%eax
  8023fb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023fe:	0f 82 6e 01 00 00    	jb     802572 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802404:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802407:	8b 40 0c             	mov    0xc(%eax),%eax
  80240a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80240d:	0f 85 8a 00 00 00    	jne    80249d <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802413:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802417:	75 17                	jne    802430 <alloc_block_FF+0x4e>
  802419:	83 ec 04             	sub    $0x4,%esp
  80241c:	68 18 43 80 00       	push   $0x804318
  802421:	68 93 00 00 00       	push   $0x93
  802426:	68 6f 42 80 00       	push   $0x80426f
  80242b:	e8 8b e0 ff ff       	call   8004bb <_panic>
  802430:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802433:	8b 00                	mov    (%eax),%eax
  802435:	85 c0                	test   %eax,%eax
  802437:	74 10                	je     802449 <alloc_block_FF+0x67>
  802439:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243c:	8b 00                	mov    (%eax),%eax
  80243e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802441:	8b 52 04             	mov    0x4(%edx),%edx
  802444:	89 50 04             	mov    %edx,0x4(%eax)
  802447:	eb 0b                	jmp    802454 <alloc_block_FF+0x72>
  802449:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244c:	8b 40 04             	mov    0x4(%eax),%eax
  80244f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802454:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802457:	8b 40 04             	mov    0x4(%eax),%eax
  80245a:	85 c0                	test   %eax,%eax
  80245c:	74 0f                	je     80246d <alloc_block_FF+0x8b>
  80245e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802461:	8b 40 04             	mov    0x4(%eax),%eax
  802464:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802467:	8b 12                	mov    (%edx),%edx
  802469:	89 10                	mov    %edx,(%eax)
  80246b:	eb 0a                	jmp    802477 <alloc_block_FF+0x95>
  80246d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802470:	8b 00                	mov    (%eax),%eax
  802472:	a3 38 51 80 00       	mov    %eax,0x805138
  802477:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802480:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802483:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80248a:	a1 44 51 80 00       	mov    0x805144,%eax
  80248f:	48                   	dec    %eax
  802490:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802495:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802498:	e9 10 01 00 00       	jmp    8025ad <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  80249d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a0:	8b 40 0c             	mov    0xc(%eax),%eax
  8024a3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024a6:	0f 86 c6 00 00 00    	jbe    802572 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8024ac:	a1 48 51 80 00       	mov    0x805148,%eax
  8024b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8024b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b7:	8b 50 08             	mov    0x8(%eax),%edx
  8024ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024bd:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8024c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8024c6:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8024c9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024cd:	75 17                	jne    8024e6 <alloc_block_FF+0x104>
  8024cf:	83 ec 04             	sub    $0x4,%esp
  8024d2:	68 18 43 80 00       	push   $0x804318
  8024d7:	68 9b 00 00 00       	push   $0x9b
  8024dc:	68 6f 42 80 00       	push   $0x80426f
  8024e1:	e8 d5 df ff ff       	call   8004bb <_panic>
  8024e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024e9:	8b 00                	mov    (%eax),%eax
  8024eb:	85 c0                	test   %eax,%eax
  8024ed:	74 10                	je     8024ff <alloc_block_FF+0x11d>
  8024ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024f2:	8b 00                	mov    (%eax),%eax
  8024f4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024f7:	8b 52 04             	mov    0x4(%edx),%edx
  8024fa:	89 50 04             	mov    %edx,0x4(%eax)
  8024fd:	eb 0b                	jmp    80250a <alloc_block_FF+0x128>
  8024ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802502:	8b 40 04             	mov    0x4(%eax),%eax
  802505:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80250a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80250d:	8b 40 04             	mov    0x4(%eax),%eax
  802510:	85 c0                	test   %eax,%eax
  802512:	74 0f                	je     802523 <alloc_block_FF+0x141>
  802514:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802517:	8b 40 04             	mov    0x4(%eax),%eax
  80251a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80251d:	8b 12                	mov    (%edx),%edx
  80251f:	89 10                	mov    %edx,(%eax)
  802521:	eb 0a                	jmp    80252d <alloc_block_FF+0x14b>
  802523:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802526:	8b 00                	mov    (%eax),%eax
  802528:	a3 48 51 80 00       	mov    %eax,0x805148
  80252d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802530:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802536:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802539:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802540:	a1 54 51 80 00       	mov    0x805154,%eax
  802545:	48                   	dec    %eax
  802546:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  80254b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254e:	8b 50 08             	mov    0x8(%eax),%edx
  802551:	8b 45 08             	mov    0x8(%ebp),%eax
  802554:	01 c2                	add    %eax,%edx
  802556:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802559:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  80255c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255f:	8b 40 0c             	mov    0xc(%eax),%eax
  802562:	2b 45 08             	sub    0x8(%ebp),%eax
  802565:	89 c2                	mov    %eax,%edx
  802567:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256a:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  80256d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802570:	eb 3b                	jmp    8025ad <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802572:	a1 40 51 80 00       	mov    0x805140,%eax
  802577:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80257a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80257e:	74 07                	je     802587 <alloc_block_FF+0x1a5>
  802580:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802583:	8b 00                	mov    (%eax),%eax
  802585:	eb 05                	jmp    80258c <alloc_block_FF+0x1aa>
  802587:	b8 00 00 00 00       	mov    $0x0,%eax
  80258c:	a3 40 51 80 00       	mov    %eax,0x805140
  802591:	a1 40 51 80 00       	mov    0x805140,%eax
  802596:	85 c0                	test   %eax,%eax
  802598:	0f 85 57 fe ff ff    	jne    8023f5 <alloc_block_FF+0x13>
  80259e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025a2:	0f 85 4d fe ff ff    	jne    8023f5 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8025a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025ad:	c9                   	leave  
  8025ae:	c3                   	ret    

008025af <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8025af:	55                   	push   %ebp
  8025b0:	89 e5                	mov    %esp,%ebp
  8025b2:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8025b5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8025bc:	a1 38 51 80 00       	mov    0x805138,%eax
  8025c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025c4:	e9 df 00 00 00       	jmp    8026a8 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8025c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cc:	8b 40 0c             	mov    0xc(%eax),%eax
  8025cf:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025d2:	0f 82 c8 00 00 00    	jb     8026a0 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8025d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025db:	8b 40 0c             	mov    0xc(%eax),%eax
  8025de:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025e1:	0f 85 8a 00 00 00    	jne    802671 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8025e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025eb:	75 17                	jne    802604 <alloc_block_BF+0x55>
  8025ed:	83 ec 04             	sub    $0x4,%esp
  8025f0:	68 18 43 80 00       	push   $0x804318
  8025f5:	68 b7 00 00 00       	push   $0xb7
  8025fa:	68 6f 42 80 00       	push   $0x80426f
  8025ff:	e8 b7 de ff ff       	call   8004bb <_panic>
  802604:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802607:	8b 00                	mov    (%eax),%eax
  802609:	85 c0                	test   %eax,%eax
  80260b:	74 10                	je     80261d <alloc_block_BF+0x6e>
  80260d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802610:	8b 00                	mov    (%eax),%eax
  802612:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802615:	8b 52 04             	mov    0x4(%edx),%edx
  802618:	89 50 04             	mov    %edx,0x4(%eax)
  80261b:	eb 0b                	jmp    802628 <alloc_block_BF+0x79>
  80261d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802620:	8b 40 04             	mov    0x4(%eax),%eax
  802623:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802628:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262b:	8b 40 04             	mov    0x4(%eax),%eax
  80262e:	85 c0                	test   %eax,%eax
  802630:	74 0f                	je     802641 <alloc_block_BF+0x92>
  802632:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802635:	8b 40 04             	mov    0x4(%eax),%eax
  802638:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80263b:	8b 12                	mov    (%edx),%edx
  80263d:	89 10                	mov    %edx,(%eax)
  80263f:	eb 0a                	jmp    80264b <alloc_block_BF+0x9c>
  802641:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802644:	8b 00                	mov    (%eax),%eax
  802646:	a3 38 51 80 00       	mov    %eax,0x805138
  80264b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802654:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802657:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80265e:	a1 44 51 80 00       	mov    0x805144,%eax
  802663:	48                   	dec    %eax
  802664:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802669:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266c:	e9 4d 01 00 00       	jmp    8027be <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802671:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802674:	8b 40 0c             	mov    0xc(%eax),%eax
  802677:	3b 45 08             	cmp    0x8(%ebp),%eax
  80267a:	76 24                	jbe    8026a0 <alloc_block_BF+0xf1>
  80267c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267f:	8b 40 0c             	mov    0xc(%eax),%eax
  802682:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802685:	73 19                	jae    8026a0 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802687:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  80268e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802691:	8b 40 0c             	mov    0xc(%eax),%eax
  802694:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802697:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269a:	8b 40 08             	mov    0x8(%eax),%eax
  80269d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8026a0:	a1 40 51 80 00       	mov    0x805140,%eax
  8026a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026ac:	74 07                	je     8026b5 <alloc_block_BF+0x106>
  8026ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b1:	8b 00                	mov    (%eax),%eax
  8026b3:	eb 05                	jmp    8026ba <alloc_block_BF+0x10b>
  8026b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8026ba:	a3 40 51 80 00       	mov    %eax,0x805140
  8026bf:	a1 40 51 80 00       	mov    0x805140,%eax
  8026c4:	85 c0                	test   %eax,%eax
  8026c6:	0f 85 fd fe ff ff    	jne    8025c9 <alloc_block_BF+0x1a>
  8026cc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026d0:	0f 85 f3 fe ff ff    	jne    8025c9 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  8026d6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8026da:	0f 84 d9 00 00 00    	je     8027b9 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8026e0:	a1 48 51 80 00       	mov    0x805148,%eax
  8026e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8026e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026eb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026ee:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8026f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026f4:	8b 55 08             	mov    0x8(%ebp),%edx
  8026f7:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  8026fa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8026fe:	75 17                	jne    802717 <alloc_block_BF+0x168>
  802700:	83 ec 04             	sub    $0x4,%esp
  802703:	68 18 43 80 00       	push   $0x804318
  802708:	68 c7 00 00 00       	push   $0xc7
  80270d:	68 6f 42 80 00       	push   $0x80426f
  802712:	e8 a4 dd ff ff       	call   8004bb <_panic>
  802717:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80271a:	8b 00                	mov    (%eax),%eax
  80271c:	85 c0                	test   %eax,%eax
  80271e:	74 10                	je     802730 <alloc_block_BF+0x181>
  802720:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802723:	8b 00                	mov    (%eax),%eax
  802725:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802728:	8b 52 04             	mov    0x4(%edx),%edx
  80272b:	89 50 04             	mov    %edx,0x4(%eax)
  80272e:	eb 0b                	jmp    80273b <alloc_block_BF+0x18c>
  802730:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802733:	8b 40 04             	mov    0x4(%eax),%eax
  802736:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80273b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80273e:	8b 40 04             	mov    0x4(%eax),%eax
  802741:	85 c0                	test   %eax,%eax
  802743:	74 0f                	je     802754 <alloc_block_BF+0x1a5>
  802745:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802748:	8b 40 04             	mov    0x4(%eax),%eax
  80274b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80274e:	8b 12                	mov    (%edx),%edx
  802750:	89 10                	mov    %edx,(%eax)
  802752:	eb 0a                	jmp    80275e <alloc_block_BF+0x1af>
  802754:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802757:	8b 00                	mov    (%eax),%eax
  802759:	a3 48 51 80 00       	mov    %eax,0x805148
  80275e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802761:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802767:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80276a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802771:	a1 54 51 80 00       	mov    0x805154,%eax
  802776:	48                   	dec    %eax
  802777:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  80277c:	83 ec 08             	sub    $0x8,%esp
  80277f:	ff 75 ec             	pushl  -0x14(%ebp)
  802782:	68 38 51 80 00       	push   $0x805138
  802787:	e8 71 f9 ff ff       	call   8020fd <find_block>
  80278c:	83 c4 10             	add    $0x10,%esp
  80278f:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802792:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802795:	8b 50 08             	mov    0x8(%eax),%edx
  802798:	8b 45 08             	mov    0x8(%ebp),%eax
  80279b:	01 c2                	add    %eax,%edx
  80279d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027a0:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8027a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027a6:	8b 40 0c             	mov    0xc(%eax),%eax
  8027a9:	2b 45 08             	sub    0x8(%ebp),%eax
  8027ac:	89 c2                	mov    %eax,%edx
  8027ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027b1:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8027b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027b7:	eb 05                	jmp    8027be <alloc_block_BF+0x20f>
	}
	return NULL;
  8027b9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027be:	c9                   	leave  
  8027bf:	c3                   	ret    

008027c0 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8027c0:	55                   	push   %ebp
  8027c1:	89 e5                	mov    %esp,%ebp
  8027c3:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  8027c6:	a1 28 50 80 00       	mov    0x805028,%eax
  8027cb:	85 c0                	test   %eax,%eax
  8027cd:	0f 85 de 01 00 00    	jne    8029b1 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8027d3:	a1 38 51 80 00       	mov    0x805138,%eax
  8027d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027db:	e9 9e 01 00 00       	jmp    80297e <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8027e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e3:	8b 40 0c             	mov    0xc(%eax),%eax
  8027e6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027e9:	0f 82 87 01 00 00    	jb     802976 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  8027ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f2:	8b 40 0c             	mov    0xc(%eax),%eax
  8027f5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027f8:	0f 85 95 00 00 00    	jne    802893 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  8027fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802802:	75 17                	jne    80281b <alloc_block_NF+0x5b>
  802804:	83 ec 04             	sub    $0x4,%esp
  802807:	68 18 43 80 00       	push   $0x804318
  80280c:	68 e0 00 00 00       	push   $0xe0
  802811:	68 6f 42 80 00       	push   $0x80426f
  802816:	e8 a0 dc ff ff       	call   8004bb <_panic>
  80281b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281e:	8b 00                	mov    (%eax),%eax
  802820:	85 c0                	test   %eax,%eax
  802822:	74 10                	je     802834 <alloc_block_NF+0x74>
  802824:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802827:	8b 00                	mov    (%eax),%eax
  802829:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80282c:	8b 52 04             	mov    0x4(%edx),%edx
  80282f:	89 50 04             	mov    %edx,0x4(%eax)
  802832:	eb 0b                	jmp    80283f <alloc_block_NF+0x7f>
  802834:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802837:	8b 40 04             	mov    0x4(%eax),%eax
  80283a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80283f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802842:	8b 40 04             	mov    0x4(%eax),%eax
  802845:	85 c0                	test   %eax,%eax
  802847:	74 0f                	je     802858 <alloc_block_NF+0x98>
  802849:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284c:	8b 40 04             	mov    0x4(%eax),%eax
  80284f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802852:	8b 12                	mov    (%edx),%edx
  802854:	89 10                	mov    %edx,(%eax)
  802856:	eb 0a                	jmp    802862 <alloc_block_NF+0xa2>
  802858:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285b:	8b 00                	mov    (%eax),%eax
  80285d:	a3 38 51 80 00       	mov    %eax,0x805138
  802862:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802865:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80286b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802875:	a1 44 51 80 00       	mov    0x805144,%eax
  80287a:	48                   	dec    %eax
  80287b:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802880:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802883:	8b 40 08             	mov    0x8(%eax),%eax
  802886:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  80288b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288e:	e9 f8 04 00 00       	jmp    802d8b <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802893:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802896:	8b 40 0c             	mov    0xc(%eax),%eax
  802899:	3b 45 08             	cmp    0x8(%ebp),%eax
  80289c:	0f 86 d4 00 00 00    	jbe    802976 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8028a2:	a1 48 51 80 00       	mov    0x805148,%eax
  8028a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8028aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ad:	8b 50 08             	mov    0x8(%eax),%edx
  8028b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028b3:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8028b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8028bc:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8028bf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028c3:	75 17                	jne    8028dc <alloc_block_NF+0x11c>
  8028c5:	83 ec 04             	sub    $0x4,%esp
  8028c8:	68 18 43 80 00       	push   $0x804318
  8028cd:	68 e9 00 00 00       	push   $0xe9
  8028d2:	68 6f 42 80 00       	push   $0x80426f
  8028d7:	e8 df db ff ff       	call   8004bb <_panic>
  8028dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028df:	8b 00                	mov    (%eax),%eax
  8028e1:	85 c0                	test   %eax,%eax
  8028e3:	74 10                	je     8028f5 <alloc_block_NF+0x135>
  8028e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e8:	8b 00                	mov    (%eax),%eax
  8028ea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028ed:	8b 52 04             	mov    0x4(%edx),%edx
  8028f0:	89 50 04             	mov    %edx,0x4(%eax)
  8028f3:	eb 0b                	jmp    802900 <alloc_block_NF+0x140>
  8028f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028f8:	8b 40 04             	mov    0x4(%eax),%eax
  8028fb:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802900:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802903:	8b 40 04             	mov    0x4(%eax),%eax
  802906:	85 c0                	test   %eax,%eax
  802908:	74 0f                	je     802919 <alloc_block_NF+0x159>
  80290a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80290d:	8b 40 04             	mov    0x4(%eax),%eax
  802910:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802913:	8b 12                	mov    (%edx),%edx
  802915:	89 10                	mov    %edx,(%eax)
  802917:	eb 0a                	jmp    802923 <alloc_block_NF+0x163>
  802919:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80291c:	8b 00                	mov    (%eax),%eax
  80291e:	a3 48 51 80 00       	mov    %eax,0x805148
  802923:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802926:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80292c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80292f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802936:	a1 54 51 80 00       	mov    0x805154,%eax
  80293b:	48                   	dec    %eax
  80293c:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802941:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802944:	8b 40 08             	mov    0x8(%eax),%eax
  802947:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  80294c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294f:	8b 50 08             	mov    0x8(%eax),%edx
  802952:	8b 45 08             	mov    0x8(%ebp),%eax
  802955:	01 c2                	add    %eax,%edx
  802957:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295a:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  80295d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802960:	8b 40 0c             	mov    0xc(%eax),%eax
  802963:	2b 45 08             	sub    0x8(%ebp),%eax
  802966:	89 c2                	mov    %eax,%edx
  802968:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296b:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  80296e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802971:	e9 15 04 00 00       	jmp    802d8b <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802976:	a1 40 51 80 00       	mov    0x805140,%eax
  80297b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80297e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802982:	74 07                	je     80298b <alloc_block_NF+0x1cb>
  802984:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802987:	8b 00                	mov    (%eax),%eax
  802989:	eb 05                	jmp    802990 <alloc_block_NF+0x1d0>
  80298b:	b8 00 00 00 00       	mov    $0x0,%eax
  802990:	a3 40 51 80 00       	mov    %eax,0x805140
  802995:	a1 40 51 80 00       	mov    0x805140,%eax
  80299a:	85 c0                	test   %eax,%eax
  80299c:	0f 85 3e fe ff ff    	jne    8027e0 <alloc_block_NF+0x20>
  8029a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029a6:	0f 85 34 fe ff ff    	jne    8027e0 <alloc_block_NF+0x20>
  8029ac:	e9 d5 03 00 00       	jmp    802d86 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8029b1:	a1 38 51 80 00       	mov    0x805138,%eax
  8029b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029b9:	e9 b1 01 00 00       	jmp    802b6f <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  8029be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c1:	8b 50 08             	mov    0x8(%eax),%edx
  8029c4:	a1 28 50 80 00       	mov    0x805028,%eax
  8029c9:	39 c2                	cmp    %eax,%edx
  8029cb:	0f 82 96 01 00 00    	jb     802b67 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  8029d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d4:	8b 40 0c             	mov    0xc(%eax),%eax
  8029d7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029da:	0f 82 87 01 00 00    	jb     802b67 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  8029e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e3:	8b 40 0c             	mov    0xc(%eax),%eax
  8029e6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029e9:	0f 85 95 00 00 00    	jne    802a84 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8029ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029f3:	75 17                	jne    802a0c <alloc_block_NF+0x24c>
  8029f5:	83 ec 04             	sub    $0x4,%esp
  8029f8:	68 18 43 80 00       	push   $0x804318
  8029fd:	68 fc 00 00 00       	push   $0xfc
  802a02:	68 6f 42 80 00       	push   $0x80426f
  802a07:	e8 af da ff ff       	call   8004bb <_panic>
  802a0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0f:	8b 00                	mov    (%eax),%eax
  802a11:	85 c0                	test   %eax,%eax
  802a13:	74 10                	je     802a25 <alloc_block_NF+0x265>
  802a15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a18:	8b 00                	mov    (%eax),%eax
  802a1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a1d:	8b 52 04             	mov    0x4(%edx),%edx
  802a20:	89 50 04             	mov    %edx,0x4(%eax)
  802a23:	eb 0b                	jmp    802a30 <alloc_block_NF+0x270>
  802a25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a28:	8b 40 04             	mov    0x4(%eax),%eax
  802a2b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a33:	8b 40 04             	mov    0x4(%eax),%eax
  802a36:	85 c0                	test   %eax,%eax
  802a38:	74 0f                	je     802a49 <alloc_block_NF+0x289>
  802a3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3d:	8b 40 04             	mov    0x4(%eax),%eax
  802a40:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a43:	8b 12                	mov    (%edx),%edx
  802a45:	89 10                	mov    %edx,(%eax)
  802a47:	eb 0a                	jmp    802a53 <alloc_block_NF+0x293>
  802a49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4c:	8b 00                	mov    (%eax),%eax
  802a4e:	a3 38 51 80 00       	mov    %eax,0x805138
  802a53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a56:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a66:	a1 44 51 80 00       	mov    0x805144,%eax
  802a6b:	48                   	dec    %eax
  802a6c:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802a71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a74:	8b 40 08             	mov    0x8(%eax),%eax
  802a77:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802a7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7f:	e9 07 03 00 00       	jmp    802d8b <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802a84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a87:	8b 40 0c             	mov    0xc(%eax),%eax
  802a8a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a8d:	0f 86 d4 00 00 00    	jbe    802b67 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802a93:	a1 48 51 80 00       	mov    0x805148,%eax
  802a98:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802a9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9e:	8b 50 08             	mov    0x8(%eax),%edx
  802aa1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802aa4:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802aa7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802aaa:	8b 55 08             	mov    0x8(%ebp),%edx
  802aad:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802ab0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ab4:	75 17                	jne    802acd <alloc_block_NF+0x30d>
  802ab6:	83 ec 04             	sub    $0x4,%esp
  802ab9:	68 18 43 80 00       	push   $0x804318
  802abe:	68 04 01 00 00       	push   $0x104
  802ac3:	68 6f 42 80 00       	push   $0x80426f
  802ac8:	e8 ee d9 ff ff       	call   8004bb <_panic>
  802acd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ad0:	8b 00                	mov    (%eax),%eax
  802ad2:	85 c0                	test   %eax,%eax
  802ad4:	74 10                	je     802ae6 <alloc_block_NF+0x326>
  802ad6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ad9:	8b 00                	mov    (%eax),%eax
  802adb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ade:	8b 52 04             	mov    0x4(%edx),%edx
  802ae1:	89 50 04             	mov    %edx,0x4(%eax)
  802ae4:	eb 0b                	jmp    802af1 <alloc_block_NF+0x331>
  802ae6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ae9:	8b 40 04             	mov    0x4(%eax),%eax
  802aec:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802af1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802af4:	8b 40 04             	mov    0x4(%eax),%eax
  802af7:	85 c0                	test   %eax,%eax
  802af9:	74 0f                	je     802b0a <alloc_block_NF+0x34a>
  802afb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802afe:	8b 40 04             	mov    0x4(%eax),%eax
  802b01:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b04:	8b 12                	mov    (%edx),%edx
  802b06:	89 10                	mov    %edx,(%eax)
  802b08:	eb 0a                	jmp    802b14 <alloc_block_NF+0x354>
  802b0a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b0d:	8b 00                	mov    (%eax),%eax
  802b0f:	a3 48 51 80 00       	mov    %eax,0x805148
  802b14:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b17:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b1d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b20:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b27:	a1 54 51 80 00       	mov    0x805154,%eax
  802b2c:	48                   	dec    %eax
  802b2d:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802b32:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b35:	8b 40 08             	mov    0x8(%eax),%eax
  802b38:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802b3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b40:	8b 50 08             	mov    0x8(%eax),%edx
  802b43:	8b 45 08             	mov    0x8(%ebp),%eax
  802b46:	01 c2                	add    %eax,%edx
  802b48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4b:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802b4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b51:	8b 40 0c             	mov    0xc(%eax),%eax
  802b54:	2b 45 08             	sub    0x8(%ebp),%eax
  802b57:	89 c2                	mov    %eax,%edx
  802b59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5c:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802b5f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b62:	e9 24 02 00 00       	jmp    802d8b <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b67:	a1 40 51 80 00       	mov    0x805140,%eax
  802b6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b6f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b73:	74 07                	je     802b7c <alloc_block_NF+0x3bc>
  802b75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b78:	8b 00                	mov    (%eax),%eax
  802b7a:	eb 05                	jmp    802b81 <alloc_block_NF+0x3c1>
  802b7c:	b8 00 00 00 00       	mov    $0x0,%eax
  802b81:	a3 40 51 80 00       	mov    %eax,0x805140
  802b86:	a1 40 51 80 00       	mov    0x805140,%eax
  802b8b:	85 c0                	test   %eax,%eax
  802b8d:	0f 85 2b fe ff ff    	jne    8029be <alloc_block_NF+0x1fe>
  802b93:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b97:	0f 85 21 fe ff ff    	jne    8029be <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b9d:	a1 38 51 80 00       	mov    0x805138,%eax
  802ba2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ba5:	e9 ae 01 00 00       	jmp    802d58 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802baa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bad:	8b 50 08             	mov    0x8(%eax),%edx
  802bb0:	a1 28 50 80 00       	mov    0x805028,%eax
  802bb5:	39 c2                	cmp    %eax,%edx
  802bb7:	0f 83 93 01 00 00    	jae    802d50 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802bbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc0:	8b 40 0c             	mov    0xc(%eax),%eax
  802bc3:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bc6:	0f 82 84 01 00 00    	jb     802d50 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802bcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bcf:	8b 40 0c             	mov    0xc(%eax),%eax
  802bd2:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bd5:	0f 85 95 00 00 00    	jne    802c70 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802bdb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bdf:	75 17                	jne    802bf8 <alloc_block_NF+0x438>
  802be1:	83 ec 04             	sub    $0x4,%esp
  802be4:	68 18 43 80 00       	push   $0x804318
  802be9:	68 14 01 00 00       	push   $0x114
  802bee:	68 6f 42 80 00       	push   $0x80426f
  802bf3:	e8 c3 d8 ff ff       	call   8004bb <_panic>
  802bf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfb:	8b 00                	mov    (%eax),%eax
  802bfd:	85 c0                	test   %eax,%eax
  802bff:	74 10                	je     802c11 <alloc_block_NF+0x451>
  802c01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c04:	8b 00                	mov    (%eax),%eax
  802c06:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c09:	8b 52 04             	mov    0x4(%edx),%edx
  802c0c:	89 50 04             	mov    %edx,0x4(%eax)
  802c0f:	eb 0b                	jmp    802c1c <alloc_block_NF+0x45c>
  802c11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c14:	8b 40 04             	mov    0x4(%eax),%eax
  802c17:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1f:	8b 40 04             	mov    0x4(%eax),%eax
  802c22:	85 c0                	test   %eax,%eax
  802c24:	74 0f                	je     802c35 <alloc_block_NF+0x475>
  802c26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c29:	8b 40 04             	mov    0x4(%eax),%eax
  802c2c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c2f:	8b 12                	mov    (%edx),%edx
  802c31:	89 10                	mov    %edx,(%eax)
  802c33:	eb 0a                	jmp    802c3f <alloc_block_NF+0x47f>
  802c35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c38:	8b 00                	mov    (%eax),%eax
  802c3a:	a3 38 51 80 00       	mov    %eax,0x805138
  802c3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c42:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c52:	a1 44 51 80 00       	mov    0x805144,%eax
  802c57:	48                   	dec    %eax
  802c58:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802c5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c60:	8b 40 08             	mov    0x8(%eax),%eax
  802c63:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802c68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6b:	e9 1b 01 00 00       	jmp    802d8b <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802c70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c73:	8b 40 0c             	mov    0xc(%eax),%eax
  802c76:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c79:	0f 86 d1 00 00 00    	jbe    802d50 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802c7f:	a1 48 51 80 00       	mov    0x805148,%eax
  802c84:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802c87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8a:	8b 50 08             	mov    0x8(%eax),%edx
  802c8d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c90:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802c93:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c96:	8b 55 08             	mov    0x8(%ebp),%edx
  802c99:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802c9c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802ca0:	75 17                	jne    802cb9 <alloc_block_NF+0x4f9>
  802ca2:	83 ec 04             	sub    $0x4,%esp
  802ca5:	68 18 43 80 00       	push   $0x804318
  802caa:	68 1c 01 00 00       	push   $0x11c
  802caf:	68 6f 42 80 00       	push   $0x80426f
  802cb4:	e8 02 d8 ff ff       	call   8004bb <_panic>
  802cb9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cbc:	8b 00                	mov    (%eax),%eax
  802cbe:	85 c0                	test   %eax,%eax
  802cc0:	74 10                	je     802cd2 <alloc_block_NF+0x512>
  802cc2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cc5:	8b 00                	mov    (%eax),%eax
  802cc7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802cca:	8b 52 04             	mov    0x4(%edx),%edx
  802ccd:	89 50 04             	mov    %edx,0x4(%eax)
  802cd0:	eb 0b                	jmp    802cdd <alloc_block_NF+0x51d>
  802cd2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cd5:	8b 40 04             	mov    0x4(%eax),%eax
  802cd8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802cdd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ce0:	8b 40 04             	mov    0x4(%eax),%eax
  802ce3:	85 c0                	test   %eax,%eax
  802ce5:	74 0f                	je     802cf6 <alloc_block_NF+0x536>
  802ce7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cea:	8b 40 04             	mov    0x4(%eax),%eax
  802ced:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802cf0:	8b 12                	mov    (%edx),%edx
  802cf2:	89 10                	mov    %edx,(%eax)
  802cf4:	eb 0a                	jmp    802d00 <alloc_block_NF+0x540>
  802cf6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cf9:	8b 00                	mov    (%eax),%eax
  802cfb:	a3 48 51 80 00       	mov    %eax,0x805148
  802d00:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d03:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d09:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d0c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d13:	a1 54 51 80 00       	mov    0x805154,%eax
  802d18:	48                   	dec    %eax
  802d19:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802d1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d21:	8b 40 08             	mov    0x8(%eax),%eax
  802d24:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802d29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2c:	8b 50 08             	mov    0x8(%eax),%edx
  802d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d32:	01 c2                	add    %eax,%edx
  802d34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d37:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802d3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3d:	8b 40 0c             	mov    0xc(%eax),%eax
  802d40:	2b 45 08             	sub    0x8(%ebp),%eax
  802d43:	89 c2                	mov    %eax,%edx
  802d45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d48:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802d4b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d4e:	eb 3b                	jmp    802d8b <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802d50:	a1 40 51 80 00       	mov    0x805140,%eax
  802d55:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d58:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d5c:	74 07                	je     802d65 <alloc_block_NF+0x5a5>
  802d5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d61:	8b 00                	mov    (%eax),%eax
  802d63:	eb 05                	jmp    802d6a <alloc_block_NF+0x5aa>
  802d65:	b8 00 00 00 00       	mov    $0x0,%eax
  802d6a:	a3 40 51 80 00       	mov    %eax,0x805140
  802d6f:	a1 40 51 80 00       	mov    0x805140,%eax
  802d74:	85 c0                	test   %eax,%eax
  802d76:	0f 85 2e fe ff ff    	jne    802baa <alloc_block_NF+0x3ea>
  802d7c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d80:	0f 85 24 fe ff ff    	jne    802baa <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802d86:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d8b:	c9                   	leave  
  802d8c:	c3                   	ret    

00802d8d <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802d8d:	55                   	push   %ebp
  802d8e:	89 e5                	mov    %esp,%ebp
  802d90:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802d93:	a1 38 51 80 00       	mov    0x805138,%eax
  802d98:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802d9b:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802da0:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802da3:	a1 38 51 80 00       	mov    0x805138,%eax
  802da8:	85 c0                	test   %eax,%eax
  802daa:	74 14                	je     802dc0 <insert_sorted_with_merge_freeList+0x33>
  802dac:	8b 45 08             	mov    0x8(%ebp),%eax
  802daf:	8b 50 08             	mov    0x8(%eax),%edx
  802db2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802db5:	8b 40 08             	mov    0x8(%eax),%eax
  802db8:	39 c2                	cmp    %eax,%edx
  802dba:	0f 87 9b 01 00 00    	ja     802f5b <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802dc0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dc4:	75 17                	jne    802ddd <insert_sorted_with_merge_freeList+0x50>
  802dc6:	83 ec 04             	sub    $0x4,%esp
  802dc9:	68 4c 42 80 00       	push   $0x80424c
  802dce:	68 38 01 00 00       	push   $0x138
  802dd3:	68 6f 42 80 00       	push   $0x80426f
  802dd8:	e8 de d6 ff ff       	call   8004bb <_panic>
  802ddd:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802de3:	8b 45 08             	mov    0x8(%ebp),%eax
  802de6:	89 10                	mov    %edx,(%eax)
  802de8:	8b 45 08             	mov    0x8(%ebp),%eax
  802deb:	8b 00                	mov    (%eax),%eax
  802ded:	85 c0                	test   %eax,%eax
  802def:	74 0d                	je     802dfe <insert_sorted_with_merge_freeList+0x71>
  802df1:	a1 38 51 80 00       	mov    0x805138,%eax
  802df6:	8b 55 08             	mov    0x8(%ebp),%edx
  802df9:	89 50 04             	mov    %edx,0x4(%eax)
  802dfc:	eb 08                	jmp    802e06 <insert_sorted_with_merge_freeList+0x79>
  802dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  802e01:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e06:	8b 45 08             	mov    0x8(%ebp),%eax
  802e09:	a3 38 51 80 00       	mov    %eax,0x805138
  802e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e11:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e18:	a1 44 51 80 00       	mov    0x805144,%eax
  802e1d:	40                   	inc    %eax
  802e1e:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802e23:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e27:	0f 84 a8 06 00 00    	je     8034d5 <insert_sorted_with_merge_freeList+0x748>
  802e2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e30:	8b 50 08             	mov    0x8(%eax),%edx
  802e33:	8b 45 08             	mov    0x8(%ebp),%eax
  802e36:	8b 40 0c             	mov    0xc(%eax),%eax
  802e39:	01 c2                	add    %eax,%edx
  802e3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e3e:	8b 40 08             	mov    0x8(%eax),%eax
  802e41:	39 c2                	cmp    %eax,%edx
  802e43:	0f 85 8c 06 00 00    	jne    8034d5 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802e49:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4c:	8b 50 0c             	mov    0xc(%eax),%edx
  802e4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e52:	8b 40 0c             	mov    0xc(%eax),%eax
  802e55:	01 c2                	add    %eax,%edx
  802e57:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5a:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802e5d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e61:	75 17                	jne    802e7a <insert_sorted_with_merge_freeList+0xed>
  802e63:	83 ec 04             	sub    $0x4,%esp
  802e66:	68 18 43 80 00       	push   $0x804318
  802e6b:	68 3c 01 00 00       	push   $0x13c
  802e70:	68 6f 42 80 00       	push   $0x80426f
  802e75:	e8 41 d6 ff ff       	call   8004bb <_panic>
  802e7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e7d:	8b 00                	mov    (%eax),%eax
  802e7f:	85 c0                	test   %eax,%eax
  802e81:	74 10                	je     802e93 <insert_sorted_with_merge_freeList+0x106>
  802e83:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e86:	8b 00                	mov    (%eax),%eax
  802e88:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e8b:	8b 52 04             	mov    0x4(%edx),%edx
  802e8e:	89 50 04             	mov    %edx,0x4(%eax)
  802e91:	eb 0b                	jmp    802e9e <insert_sorted_with_merge_freeList+0x111>
  802e93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e96:	8b 40 04             	mov    0x4(%eax),%eax
  802e99:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ea1:	8b 40 04             	mov    0x4(%eax),%eax
  802ea4:	85 c0                	test   %eax,%eax
  802ea6:	74 0f                	je     802eb7 <insert_sorted_with_merge_freeList+0x12a>
  802ea8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eab:	8b 40 04             	mov    0x4(%eax),%eax
  802eae:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802eb1:	8b 12                	mov    (%edx),%edx
  802eb3:	89 10                	mov    %edx,(%eax)
  802eb5:	eb 0a                	jmp    802ec1 <insert_sorted_with_merge_freeList+0x134>
  802eb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eba:	8b 00                	mov    (%eax),%eax
  802ebc:	a3 38 51 80 00       	mov    %eax,0x805138
  802ec1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ec4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802eca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ecd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ed4:	a1 44 51 80 00       	mov    0x805144,%eax
  802ed9:	48                   	dec    %eax
  802eda:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802edf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ee2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802ee9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eec:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802ef3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ef7:	75 17                	jne    802f10 <insert_sorted_with_merge_freeList+0x183>
  802ef9:	83 ec 04             	sub    $0x4,%esp
  802efc:	68 4c 42 80 00       	push   $0x80424c
  802f01:	68 3f 01 00 00       	push   $0x13f
  802f06:	68 6f 42 80 00       	push   $0x80426f
  802f0b:	e8 ab d5 ff ff       	call   8004bb <_panic>
  802f10:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802f16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f19:	89 10                	mov    %edx,(%eax)
  802f1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f1e:	8b 00                	mov    (%eax),%eax
  802f20:	85 c0                	test   %eax,%eax
  802f22:	74 0d                	je     802f31 <insert_sorted_with_merge_freeList+0x1a4>
  802f24:	a1 48 51 80 00       	mov    0x805148,%eax
  802f29:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f2c:	89 50 04             	mov    %edx,0x4(%eax)
  802f2f:	eb 08                	jmp    802f39 <insert_sorted_with_merge_freeList+0x1ac>
  802f31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f34:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f3c:	a3 48 51 80 00       	mov    %eax,0x805148
  802f41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f44:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f4b:	a1 54 51 80 00       	mov    0x805154,%eax
  802f50:	40                   	inc    %eax
  802f51:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802f56:	e9 7a 05 00 00       	jmp    8034d5 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802f5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5e:	8b 50 08             	mov    0x8(%eax),%edx
  802f61:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f64:	8b 40 08             	mov    0x8(%eax),%eax
  802f67:	39 c2                	cmp    %eax,%edx
  802f69:	0f 82 14 01 00 00    	jb     803083 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802f6f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f72:	8b 50 08             	mov    0x8(%eax),%edx
  802f75:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f78:	8b 40 0c             	mov    0xc(%eax),%eax
  802f7b:	01 c2                	add    %eax,%edx
  802f7d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f80:	8b 40 08             	mov    0x8(%eax),%eax
  802f83:	39 c2                	cmp    %eax,%edx
  802f85:	0f 85 90 00 00 00    	jne    80301b <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802f8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f8e:	8b 50 0c             	mov    0xc(%eax),%edx
  802f91:	8b 45 08             	mov    0x8(%ebp),%eax
  802f94:	8b 40 0c             	mov    0xc(%eax),%eax
  802f97:	01 c2                	add    %eax,%edx
  802f99:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f9c:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802f9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802fa9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fac:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802fb3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fb7:	75 17                	jne    802fd0 <insert_sorted_with_merge_freeList+0x243>
  802fb9:	83 ec 04             	sub    $0x4,%esp
  802fbc:	68 4c 42 80 00       	push   $0x80424c
  802fc1:	68 49 01 00 00       	push   $0x149
  802fc6:	68 6f 42 80 00       	push   $0x80426f
  802fcb:	e8 eb d4 ff ff       	call   8004bb <_panic>
  802fd0:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802fd6:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd9:	89 10                	mov    %edx,(%eax)
  802fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  802fde:	8b 00                	mov    (%eax),%eax
  802fe0:	85 c0                	test   %eax,%eax
  802fe2:	74 0d                	je     802ff1 <insert_sorted_with_merge_freeList+0x264>
  802fe4:	a1 48 51 80 00       	mov    0x805148,%eax
  802fe9:	8b 55 08             	mov    0x8(%ebp),%edx
  802fec:	89 50 04             	mov    %edx,0x4(%eax)
  802fef:	eb 08                	jmp    802ff9 <insert_sorted_with_merge_freeList+0x26c>
  802ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffc:	a3 48 51 80 00       	mov    %eax,0x805148
  803001:	8b 45 08             	mov    0x8(%ebp),%eax
  803004:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80300b:	a1 54 51 80 00       	mov    0x805154,%eax
  803010:	40                   	inc    %eax
  803011:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803016:	e9 bb 04 00 00       	jmp    8034d6 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  80301b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80301f:	75 17                	jne    803038 <insert_sorted_with_merge_freeList+0x2ab>
  803021:	83 ec 04             	sub    $0x4,%esp
  803024:	68 c0 42 80 00       	push   $0x8042c0
  803029:	68 4c 01 00 00       	push   $0x14c
  80302e:	68 6f 42 80 00       	push   $0x80426f
  803033:	e8 83 d4 ff ff       	call   8004bb <_panic>
  803038:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  80303e:	8b 45 08             	mov    0x8(%ebp),%eax
  803041:	89 50 04             	mov    %edx,0x4(%eax)
  803044:	8b 45 08             	mov    0x8(%ebp),%eax
  803047:	8b 40 04             	mov    0x4(%eax),%eax
  80304a:	85 c0                	test   %eax,%eax
  80304c:	74 0c                	je     80305a <insert_sorted_with_merge_freeList+0x2cd>
  80304e:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803053:	8b 55 08             	mov    0x8(%ebp),%edx
  803056:	89 10                	mov    %edx,(%eax)
  803058:	eb 08                	jmp    803062 <insert_sorted_with_merge_freeList+0x2d5>
  80305a:	8b 45 08             	mov    0x8(%ebp),%eax
  80305d:	a3 38 51 80 00       	mov    %eax,0x805138
  803062:	8b 45 08             	mov    0x8(%ebp),%eax
  803065:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80306a:	8b 45 08             	mov    0x8(%ebp),%eax
  80306d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803073:	a1 44 51 80 00       	mov    0x805144,%eax
  803078:	40                   	inc    %eax
  803079:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80307e:	e9 53 04 00 00       	jmp    8034d6 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803083:	a1 38 51 80 00       	mov    0x805138,%eax
  803088:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80308b:	e9 15 04 00 00       	jmp    8034a5 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  803090:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803093:	8b 00                	mov    (%eax),%eax
  803095:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803098:	8b 45 08             	mov    0x8(%ebp),%eax
  80309b:	8b 50 08             	mov    0x8(%eax),%edx
  80309e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a1:	8b 40 08             	mov    0x8(%eax),%eax
  8030a4:	39 c2                	cmp    %eax,%edx
  8030a6:	0f 86 f1 03 00 00    	jbe    80349d <insert_sorted_with_merge_freeList+0x710>
  8030ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8030af:	8b 50 08             	mov    0x8(%eax),%edx
  8030b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030b5:	8b 40 08             	mov    0x8(%eax),%eax
  8030b8:	39 c2                	cmp    %eax,%edx
  8030ba:	0f 83 dd 03 00 00    	jae    80349d <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  8030c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c3:	8b 50 08             	mov    0x8(%eax),%edx
  8030c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c9:	8b 40 0c             	mov    0xc(%eax),%eax
  8030cc:	01 c2                	add    %eax,%edx
  8030ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d1:	8b 40 08             	mov    0x8(%eax),%eax
  8030d4:	39 c2                	cmp    %eax,%edx
  8030d6:	0f 85 b9 01 00 00    	jne    803295 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8030dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8030df:	8b 50 08             	mov    0x8(%eax),%edx
  8030e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e5:	8b 40 0c             	mov    0xc(%eax),%eax
  8030e8:	01 c2                	add    %eax,%edx
  8030ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ed:	8b 40 08             	mov    0x8(%eax),%eax
  8030f0:	39 c2                	cmp    %eax,%edx
  8030f2:	0f 85 0d 01 00 00    	jne    803205 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  8030f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030fb:	8b 50 0c             	mov    0xc(%eax),%edx
  8030fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803101:	8b 40 0c             	mov    0xc(%eax),%eax
  803104:	01 c2                	add    %eax,%edx
  803106:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803109:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80310c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803110:	75 17                	jne    803129 <insert_sorted_with_merge_freeList+0x39c>
  803112:	83 ec 04             	sub    $0x4,%esp
  803115:	68 18 43 80 00       	push   $0x804318
  80311a:	68 5c 01 00 00       	push   $0x15c
  80311f:	68 6f 42 80 00       	push   $0x80426f
  803124:	e8 92 d3 ff ff       	call   8004bb <_panic>
  803129:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80312c:	8b 00                	mov    (%eax),%eax
  80312e:	85 c0                	test   %eax,%eax
  803130:	74 10                	je     803142 <insert_sorted_with_merge_freeList+0x3b5>
  803132:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803135:	8b 00                	mov    (%eax),%eax
  803137:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80313a:	8b 52 04             	mov    0x4(%edx),%edx
  80313d:	89 50 04             	mov    %edx,0x4(%eax)
  803140:	eb 0b                	jmp    80314d <insert_sorted_with_merge_freeList+0x3c0>
  803142:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803145:	8b 40 04             	mov    0x4(%eax),%eax
  803148:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80314d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803150:	8b 40 04             	mov    0x4(%eax),%eax
  803153:	85 c0                	test   %eax,%eax
  803155:	74 0f                	je     803166 <insert_sorted_with_merge_freeList+0x3d9>
  803157:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80315a:	8b 40 04             	mov    0x4(%eax),%eax
  80315d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803160:	8b 12                	mov    (%edx),%edx
  803162:	89 10                	mov    %edx,(%eax)
  803164:	eb 0a                	jmp    803170 <insert_sorted_with_merge_freeList+0x3e3>
  803166:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803169:	8b 00                	mov    (%eax),%eax
  80316b:	a3 38 51 80 00       	mov    %eax,0x805138
  803170:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803173:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803179:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80317c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803183:	a1 44 51 80 00       	mov    0x805144,%eax
  803188:	48                   	dec    %eax
  803189:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  80318e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803191:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803198:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80319b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8031a2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031a6:	75 17                	jne    8031bf <insert_sorted_with_merge_freeList+0x432>
  8031a8:	83 ec 04             	sub    $0x4,%esp
  8031ab:	68 4c 42 80 00       	push   $0x80424c
  8031b0:	68 5f 01 00 00       	push   $0x15f
  8031b5:	68 6f 42 80 00       	push   $0x80426f
  8031ba:	e8 fc d2 ff ff       	call   8004bb <_panic>
  8031bf:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8031c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c8:	89 10                	mov    %edx,(%eax)
  8031ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031cd:	8b 00                	mov    (%eax),%eax
  8031cf:	85 c0                	test   %eax,%eax
  8031d1:	74 0d                	je     8031e0 <insert_sorted_with_merge_freeList+0x453>
  8031d3:	a1 48 51 80 00       	mov    0x805148,%eax
  8031d8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031db:	89 50 04             	mov    %edx,0x4(%eax)
  8031de:	eb 08                	jmp    8031e8 <insert_sorted_with_merge_freeList+0x45b>
  8031e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031eb:	a3 48 51 80 00       	mov    %eax,0x805148
  8031f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031fa:	a1 54 51 80 00       	mov    0x805154,%eax
  8031ff:	40                   	inc    %eax
  803200:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803205:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803208:	8b 50 0c             	mov    0xc(%eax),%edx
  80320b:	8b 45 08             	mov    0x8(%ebp),%eax
  80320e:	8b 40 0c             	mov    0xc(%eax),%eax
  803211:	01 c2                	add    %eax,%edx
  803213:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803216:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803219:	8b 45 08             	mov    0x8(%ebp),%eax
  80321c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803223:	8b 45 08             	mov    0x8(%ebp),%eax
  803226:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80322d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803231:	75 17                	jne    80324a <insert_sorted_with_merge_freeList+0x4bd>
  803233:	83 ec 04             	sub    $0x4,%esp
  803236:	68 4c 42 80 00       	push   $0x80424c
  80323b:	68 64 01 00 00       	push   $0x164
  803240:	68 6f 42 80 00       	push   $0x80426f
  803245:	e8 71 d2 ff ff       	call   8004bb <_panic>
  80324a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803250:	8b 45 08             	mov    0x8(%ebp),%eax
  803253:	89 10                	mov    %edx,(%eax)
  803255:	8b 45 08             	mov    0x8(%ebp),%eax
  803258:	8b 00                	mov    (%eax),%eax
  80325a:	85 c0                	test   %eax,%eax
  80325c:	74 0d                	je     80326b <insert_sorted_with_merge_freeList+0x4de>
  80325e:	a1 48 51 80 00       	mov    0x805148,%eax
  803263:	8b 55 08             	mov    0x8(%ebp),%edx
  803266:	89 50 04             	mov    %edx,0x4(%eax)
  803269:	eb 08                	jmp    803273 <insert_sorted_with_merge_freeList+0x4e6>
  80326b:	8b 45 08             	mov    0x8(%ebp),%eax
  80326e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803273:	8b 45 08             	mov    0x8(%ebp),%eax
  803276:	a3 48 51 80 00       	mov    %eax,0x805148
  80327b:	8b 45 08             	mov    0x8(%ebp),%eax
  80327e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803285:	a1 54 51 80 00       	mov    0x805154,%eax
  80328a:	40                   	inc    %eax
  80328b:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803290:	e9 41 02 00 00       	jmp    8034d6 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803295:	8b 45 08             	mov    0x8(%ebp),%eax
  803298:	8b 50 08             	mov    0x8(%eax),%edx
  80329b:	8b 45 08             	mov    0x8(%ebp),%eax
  80329e:	8b 40 0c             	mov    0xc(%eax),%eax
  8032a1:	01 c2                	add    %eax,%edx
  8032a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032a6:	8b 40 08             	mov    0x8(%eax),%eax
  8032a9:	39 c2                	cmp    %eax,%edx
  8032ab:	0f 85 7c 01 00 00    	jne    80342d <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8032b1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032b5:	74 06                	je     8032bd <insert_sorted_with_merge_freeList+0x530>
  8032b7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032bb:	75 17                	jne    8032d4 <insert_sorted_with_merge_freeList+0x547>
  8032bd:	83 ec 04             	sub    $0x4,%esp
  8032c0:	68 88 42 80 00       	push   $0x804288
  8032c5:	68 69 01 00 00       	push   $0x169
  8032ca:	68 6f 42 80 00       	push   $0x80426f
  8032cf:	e8 e7 d1 ff ff       	call   8004bb <_panic>
  8032d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032d7:	8b 50 04             	mov    0x4(%eax),%edx
  8032da:	8b 45 08             	mov    0x8(%ebp),%eax
  8032dd:	89 50 04             	mov    %edx,0x4(%eax)
  8032e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032e6:	89 10                	mov    %edx,(%eax)
  8032e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032eb:	8b 40 04             	mov    0x4(%eax),%eax
  8032ee:	85 c0                	test   %eax,%eax
  8032f0:	74 0d                	je     8032ff <insert_sorted_with_merge_freeList+0x572>
  8032f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032f5:	8b 40 04             	mov    0x4(%eax),%eax
  8032f8:	8b 55 08             	mov    0x8(%ebp),%edx
  8032fb:	89 10                	mov    %edx,(%eax)
  8032fd:	eb 08                	jmp    803307 <insert_sorted_with_merge_freeList+0x57a>
  8032ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803302:	a3 38 51 80 00       	mov    %eax,0x805138
  803307:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80330a:	8b 55 08             	mov    0x8(%ebp),%edx
  80330d:	89 50 04             	mov    %edx,0x4(%eax)
  803310:	a1 44 51 80 00       	mov    0x805144,%eax
  803315:	40                   	inc    %eax
  803316:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  80331b:	8b 45 08             	mov    0x8(%ebp),%eax
  80331e:	8b 50 0c             	mov    0xc(%eax),%edx
  803321:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803324:	8b 40 0c             	mov    0xc(%eax),%eax
  803327:	01 c2                	add    %eax,%edx
  803329:	8b 45 08             	mov    0x8(%ebp),%eax
  80332c:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80332f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803333:	75 17                	jne    80334c <insert_sorted_with_merge_freeList+0x5bf>
  803335:	83 ec 04             	sub    $0x4,%esp
  803338:	68 18 43 80 00       	push   $0x804318
  80333d:	68 6b 01 00 00       	push   $0x16b
  803342:	68 6f 42 80 00       	push   $0x80426f
  803347:	e8 6f d1 ff ff       	call   8004bb <_panic>
  80334c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80334f:	8b 00                	mov    (%eax),%eax
  803351:	85 c0                	test   %eax,%eax
  803353:	74 10                	je     803365 <insert_sorted_with_merge_freeList+0x5d8>
  803355:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803358:	8b 00                	mov    (%eax),%eax
  80335a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80335d:	8b 52 04             	mov    0x4(%edx),%edx
  803360:	89 50 04             	mov    %edx,0x4(%eax)
  803363:	eb 0b                	jmp    803370 <insert_sorted_with_merge_freeList+0x5e3>
  803365:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803368:	8b 40 04             	mov    0x4(%eax),%eax
  80336b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803370:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803373:	8b 40 04             	mov    0x4(%eax),%eax
  803376:	85 c0                	test   %eax,%eax
  803378:	74 0f                	je     803389 <insert_sorted_with_merge_freeList+0x5fc>
  80337a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80337d:	8b 40 04             	mov    0x4(%eax),%eax
  803380:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803383:	8b 12                	mov    (%edx),%edx
  803385:	89 10                	mov    %edx,(%eax)
  803387:	eb 0a                	jmp    803393 <insert_sorted_with_merge_freeList+0x606>
  803389:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80338c:	8b 00                	mov    (%eax),%eax
  80338e:	a3 38 51 80 00       	mov    %eax,0x805138
  803393:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803396:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80339c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80339f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033a6:	a1 44 51 80 00       	mov    0x805144,%eax
  8033ab:	48                   	dec    %eax
  8033ac:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  8033b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033b4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8033bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033be:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8033c5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8033c9:	75 17                	jne    8033e2 <insert_sorted_with_merge_freeList+0x655>
  8033cb:	83 ec 04             	sub    $0x4,%esp
  8033ce:	68 4c 42 80 00       	push   $0x80424c
  8033d3:	68 6e 01 00 00       	push   $0x16e
  8033d8:	68 6f 42 80 00       	push   $0x80426f
  8033dd:	e8 d9 d0 ff ff       	call   8004bb <_panic>
  8033e2:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8033e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033eb:	89 10                	mov    %edx,(%eax)
  8033ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033f0:	8b 00                	mov    (%eax),%eax
  8033f2:	85 c0                	test   %eax,%eax
  8033f4:	74 0d                	je     803403 <insert_sorted_with_merge_freeList+0x676>
  8033f6:	a1 48 51 80 00       	mov    0x805148,%eax
  8033fb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033fe:	89 50 04             	mov    %edx,0x4(%eax)
  803401:	eb 08                	jmp    80340b <insert_sorted_with_merge_freeList+0x67e>
  803403:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803406:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80340b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80340e:	a3 48 51 80 00       	mov    %eax,0x805148
  803413:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803416:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80341d:	a1 54 51 80 00       	mov    0x805154,%eax
  803422:	40                   	inc    %eax
  803423:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803428:	e9 a9 00 00 00       	jmp    8034d6 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  80342d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803431:	74 06                	je     803439 <insert_sorted_with_merge_freeList+0x6ac>
  803433:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803437:	75 17                	jne    803450 <insert_sorted_with_merge_freeList+0x6c3>
  803439:	83 ec 04             	sub    $0x4,%esp
  80343c:	68 e4 42 80 00       	push   $0x8042e4
  803441:	68 73 01 00 00       	push   $0x173
  803446:	68 6f 42 80 00       	push   $0x80426f
  80344b:	e8 6b d0 ff ff       	call   8004bb <_panic>
  803450:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803453:	8b 10                	mov    (%eax),%edx
  803455:	8b 45 08             	mov    0x8(%ebp),%eax
  803458:	89 10                	mov    %edx,(%eax)
  80345a:	8b 45 08             	mov    0x8(%ebp),%eax
  80345d:	8b 00                	mov    (%eax),%eax
  80345f:	85 c0                	test   %eax,%eax
  803461:	74 0b                	je     80346e <insert_sorted_with_merge_freeList+0x6e1>
  803463:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803466:	8b 00                	mov    (%eax),%eax
  803468:	8b 55 08             	mov    0x8(%ebp),%edx
  80346b:	89 50 04             	mov    %edx,0x4(%eax)
  80346e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803471:	8b 55 08             	mov    0x8(%ebp),%edx
  803474:	89 10                	mov    %edx,(%eax)
  803476:	8b 45 08             	mov    0x8(%ebp),%eax
  803479:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80347c:	89 50 04             	mov    %edx,0x4(%eax)
  80347f:	8b 45 08             	mov    0x8(%ebp),%eax
  803482:	8b 00                	mov    (%eax),%eax
  803484:	85 c0                	test   %eax,%eax
  803486:	75 08                	jne    803490 <insert_sorted_with_merge_freeList+0x703>
  803488:	8b 45 08             	mov    0x8(%ebp),%eax
  80348b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803490:	a1 44 51 80 00       	mov    0x805144,%eax
  803495:	40                   	inc    %eax
  803496:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  80349b:	eb 39                	jmp    8034d6 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80349d:	a1 40 51 80 00       	mov    0x805140,%eax
  8034a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8034a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034a9:	74 07                	je     8034b2 <insert_sorted_with_merge_freeList+0x725>
  8034ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ae:	8b 00                	mov    (%eax),%eax
  8034b0:	eb 05                	jmp    8034b7 <insert_sorted_with_merge_freeList+0x72a>
  8034b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8034b7:	a3 40 51 80 00       	mov    %eax,0x805140
  8034bc:	a1 40 51 80 00       	mov    0x805140,%eax
  8034c1:	85 c0                	test   %eax,%eax
  8034c3:	0f 85 c7 fb ff ff    	jne    803090 <insert_sorted_with_merge_freeList+0x303>
  8034c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034cd:	0f 85 bd fb ff ff    	jne    803090 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8034d3:	eb 01                	jmp    8034d6 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8034d5:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8034d6:	90                   	nop
  8034d7:	c9                   	leave  
  8034d8:	c3                   	ret    

008034d9 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8034d9:	55                   	push   %ebp
  8034da:	89 e5                	mov    %esp,%ebp
  8034dc:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8034df:	8b 55 08             	mov    0x8(%ebp),%edx
  8034e2:	89 d0                	mov    %edx,%eax
  8034e4:	c1 e0 02             	shl    $0x2,%eax
  8034e7:	01 d0                	add    %edx,%eax
  8034e9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8034f0:	01 d0                	add    %edx,%eax
  8034f2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8034f9:	01 d0                	add    %edx,%eax
  8034fb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803502:	01 d0                	add    %edx,%eax
  803504:	c1 e0 04             	shl    $0x4,%eax
  803507:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  80350a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  803511:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803514:	83 ec 0c             	sub    $0xc,%esp
  803517:	50                   	push   %eax
  803518:	e8 26 e7 ff ff       	call   801c43 <sys_get_virtual_time>
  80351d:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803520:	eb 41                	jmp    803563 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  803522:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803525:	83 ec 0c             	sub    $0xc,%esp
  803528:	50                   	push   %eax
  803529:	e8 15 e7 ff ff       	call   801c43 <sys_get_virtual_time>
  80352e:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803531:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803534:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803537:	29 c2                	sub    %eax,%edx
  803539:	89 d0                	mov    %edx,%eax
  80353b:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  80353e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803541:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803544:	89 d1                	mov    %edx,%ecx
  803546:	29 c1                	sub    %eax,%ecx
  803548:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80354b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80354e:	39 c2                	cmp    %eax,%edx
  803550:	0f 97 c0             	seta   %al
  803553:	0f b6 c0             	movzbl %al,%eax
  803556:	29 c1                	sub    %eax,%ecx
  803558:	89 c8                	mov    %ecx,%eax
  80355a:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  80355d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803560:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  803563:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803566:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803569:	72 b7                	jb     803522 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  80356b:	90                   	nop
  80356c:	c9                   	leave  
  80356d:	c3                   	ret    

0080356e <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  80356e:	55                   	push   %ebp
  80356f:	89 e5                	mov    %esp,%ebp
  803571:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803574:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  80357b:	eb 03                	jmp    803580 <busy_wait+0x12>
  80357d:	ff 45 fc             	incl   -0x4(%ebp)
  803580:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803583:	3b 45 08             	cmp    0x8(%ebp),%eax
  803586:	72 f5                	jb     80357d <busy_wait+0xf>
	return i;
  803588:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80358b:	c9                   	leave  
  80358c:	c3                   	ret    
  80358d:	66 90                	xchg   %ax,%ax
  80358f:	90                   	nop

00803590 <__udivdi3>:
  803590:	55                   	push   %ebp
  803591:	57                   	push   %edi
  803592:	56                   	push   %esi
  803593:	53                   	push   %ebx
  803594:	83 ec 1c             	sub    $0x1c,%esp
  803597:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80359b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80359f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8035a3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8035a7:	89 ca                	mov    %ecx,%edx
  8035a9:	89 f8                	mov    %edi,%eax
  8035ab:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8035af:	85 f6                	test   %esi,%esi
  8035b1:	75 2d                	jne    8035e0 <__udivdi3+0x50>
  8035b3:	39 cf                	cmp    %ecx,%edi
  8035b5:	77 65                	ja     80361c <__udivdi3+0x8c>
  8035b7:	89 fd                	mov    %edi,%ebp
  8035b9:	85 ff                	test   %edi,%edi
  8035bb:	75 0b                	jne    8035c8 <__udivdi3+0x38>
  8035bd:	b8 01 00 00 00       	mov    $0x1,%eax
  8035c2:	31 d2                	xor    %edx,%edx
  8035c4:	f7 f7                	div    %edi
  8035c6:	89 c5                	mov    %eax,%ebp
  8035c8:	31 d2                	xor    %edx,%edx
  8035ca:	89 c8                	mov    %ecx,%eax
  8035cc:	f7 f5                	div    %ebp
  8035ce:	89 c1                	mov    %eax,%ecx
  8035d0:	89 d8                	mov    %ebx,%eax
  8035d2:	f7 f5                	div    %ebp
  8035d4:	89 cf                	mov    %ecx,%edi
  8035d6:	89 fa                	mov    %edi,%edx
  8035d8:	83 c4 1c             	add    $0x1c,%esp
  8035db:	5b                   	pop    %ebx
  8035dc:	5e                   	pop    %esi
  8035dd:	5f                   	pop    %edi
  8035de:	5d                   	pop    %ebp
  8035df:	c3                   	ret    
  8035e0:	39 ce                	cmp    %ecx,%esi
  8035e2:	77 28                	ja     80360c <__udivdi3+0x7c>
  8035e4:	0f bd fe             	bsr    %esi,%edi
  8035e7:	83 f7 1f             	xor    $0x1f,%edi
  8035ea:	75 40                	jne    80362c <__udivdi3+0x9c>
  8035ec:	39 ce                	cmp    %ecx,%esi
  8035ee:	72 0a                	jb     8035fa <__udivdi3+0x6a>
  8035f0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8035f4:	0f 87 9e 00 00 00    	ja     803698 <__udivdi3+0x108>
  8035fa:	b8 01 00 00 00       	mov    $0x1,%eax
  8035ff:	89 fa                	mov    %edi,%edx
  803601:	83 c4 1c             	add    $0x1c,%esp
  803604:	5b                   	pop    %ebx
  803605:	5e                   	pop    %esi
  803606:	5f                   	pop    %edi
  803607:	5d                   	pop    %ebp
  803608:	c3                   	ret    
  803609:	8d 76 00             	lea    0x0(%esi),%esi
  80360c:	31 ff                	xor    %edi,%edi
  80360e:	31 c0                	xor    %eax,%eax
  803610:	89 fa                	mov    %edi,%edx
  803612:	83 c4 1c             	add    $0x1c,%esp
  803615:	5b                   	pop    %ebx
  803616:	5e                   	pop    %esi
  803617:	5f                   	pop    %edi
  803618:	5d                   	pop    %ebp
  803619:	c3                   	ret    
  80361a:	66 90                	xchg   %ax,%ax
  80361c:	89 d8                	mov    %ebx,%eax
  80361e:	f7 f7                	div    %edi
  803620:	31 ff                	xor    %edi,%edi
  803622:	89 fa                	mov    %edi,%edx
  803624:	83 c4 1c             	add    $0x1c,%esp
  803627:	5b                   	pop    %ebx
  803628:	5e                   	pop    %esi
  803629:	5f                   	pop    %edi
  80362a:	5d                   	pop    %ebp
  80362b:	c3                   	ret    
  80362c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803631:	89 eb                	mov    %ebp,%ebx
  803633:	29 fb                	sub    %edi,%ebx
  803635:	89 f9                	mov    %edi,%ecx
  803637:	d3 e6                	shl    %cl,%esi
  803639:	89 c5                	mov    %eax,%ebp
  80363b:	88 d9                	mov    %bl,%cl
  80363d:	d3 ed                	shr    %cl,%ebp
  80363f:	89 e9                	mov    %ebp,%ecx
  803641:	09 f1                	or     %esi,%ecx
  803643:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803647:	89 f9                	mov    %edi,%ecx
  803649:	d3 e0                	shl    %cl,%eax
  80364b:	89 c5                	mov    %eax,%ebp
  80364d:	89 d6                	mov    %edx,%esi
  80364f:	88 d9                	mov    %bl,%cl
  803651:	d3 ee                	shr    %cl,%esi
  803653:	89 f9                	mov    %edi,%ecx
  803655:	d3 e2                	shl    %cl,%edx
  803657:	8b 44 24 08          	mov    0x8(%esp),%eax
  80365b:	88 d9                	mov    %bl,%cl
  80365d:	d3 e8                	shr    %cl,%eax
  80365f:	09 c2                	or     %eax,%edx
  803661:	89 d0                	mov    %edx,%eax
  803663:	89 f2                	mov    %esi,%edx
  803665:	f7 74 24 0c          	divl   0xc(%esp)
  803669:	89 d6                	mov    %edx,%esi
  80366b:	89 c3                	mov    %eax,%ebx
  80366d:	f7 e5                	mul    %ebp
  80366f:	39 d6                	cmp    %edx,%esi
  803671:	72 19                	jb     80368c <__udivdi3+0xfc>
  803673:	74 0b                	je     803680 <__udivdi3+0xf0>
  803675:	89 d8                	mov    %ebx,%eax
  803677:	31 ff                	xor    %edi,%edi
  803679:	e9 58 ff ff ff       	jmp    8035d6 <__udivdi3+0x46>
  80367e:	66 90                	xchg   %ax,%ax
  803680:	8b 54 24 08          	mov    0x8(%esp),%edx
  803684:	89 f9                	mov    %edi,%ecx
  803686:	d3 e2                	shl    %cl,%edx
  803688:	39 c2                	cmp    %eax,%edx
  80368a:	73 e9                	jae    803675 <__udivdi3+0xe5>
  80368c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80368f:	31 ff                	xor    %edi,%edi
  803691:	e9 40 ff ff ff       	jmp    8035d6 <__udivdi3+0x46>
  803696:	66 90                	xchg   %ax,%ax
  803698:	31 c0                	xor    %eax,%eax
  80369a:	e9 37 ff ff ff       	jmp    8035d6 <__udivdi3+0x46>
  80369f:	90                   	nop

008036a0 <__umoddi3>:
  8036a0:	55                   	push   %ebp
  8036a1:	57                   	push   %edi
  8036a2:	56                   	push   %esi
  8036a3:	53                   	push   %ebx
  8036a4:	83 ec 1c             	sub    $0x1c,%esp
  8036a7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8036ab:	8b 74 24 34          	mov    0x34(%esp),%esi
  8036af:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8036b3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8036b7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8036bb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8036bf:	89 f3                	mov    %esi,%ebx
  8036c1:	89 fa                	mov    %edi,%edx
  8036c3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8036c7:	89 34 24             	mov    %esi,(%esp)
  8036ca:	85 c0                	test   %eax,%eax
  8036cc:	75 1a                	jne    8036e8 <__umoddi3+0x48>
  8036ce:	39 f7                	cmp    %esi,%edi
  8036d0:	0f 86 a2 00 00 00    	jbe    803778 <__umoddi3+0xd8>
  8036d6:	89 c8                	mov    %ecx,%eax
  8036d8:	89 f2                	mov    %esi,%edx
  8036da:	f7 f7                	div    %edi
  8036dc:	89 d0                	mov    %edx,%eax
  8036de:	31 d2                	xor    %edx,%edx
  8036e0:	83 c4 1c             	add    $0x1c,%esp
  8036e3:	5b                   	pop    %ebx
  8036e4:	5e                   	pop    %esi
  8036e5:	5f                   	pop    %edi
  8036e6:	5d                   	pop    %ebp
  8036e7:	c3                   	ret    
  8036e8:	39 f0                	cmp    %esi,%eax
  8036ea:	0f 87 ac 00 00 00    	ja     80379c <__umoddi3+0xfc>
  8036f0:	0f bd e8             	bsr    %eax,%ebp
  8036f3:	83 f5 1f             	xor    $0x1f,%ebp
  8036f6:	0f 84 ac 00 00 00    	je     8037a8 <__umoddi3+0x108>
  8036fc:	bf 20 00 00 00       	mov    $0x20,%edi
  803701:	29 ef                	sub    %ebp,%edi
  803703:	89 fe                	mov    %edi,%esi
  803705:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803709:	89 e9                	mov    %ebp,%ecx
  80370b:	d3 e0                	shl    %cl,%eax
  80370d:	89 d7                	mov    %edx,%edi
  80370f:	89 f1                	mov    %esi,%ecx
  803711:	d3 ef                	shr    %cl,%edi
  803713:	09 c7                	or     %eax,%edi
  803715:	89 e9                	mov    %ebp,%ecx
  803717:	d3 e2                	shl    %cl,%edx
  803719:	89 14 24             	mov    %edx,(%esp)
  80371c:	89 d8                	mov    %ebx,%eax
  80371e:	d3 e0                	shl    %cl,%eax
  803720:	89 c2                	mov    %eax,%edx
  803722:	8b 44 24 08          	mov    0x8(%esp),%eax
  803726:	d3 e0                	shl    %cl,%eax
  803728:	89 44 24 04          	mov    %eax,0x4(%esp)
  80372c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803730:	89 f1                	mov    %esi,%ecx
  803732:	d3 e8                	shr    %cl,%eax
  803734:	09 d0                	or     %edx,%eax
  803736:	d3 eb                	shr    %cl,%ebx
  803738:	89 da                	mov    %ebx,%edx
  80373a:	f7 f7                	div    %edi
  80373c:	89 d3                	mov    %edx,%ebx
  80373e:	f7 24 24             	mull   (%esp)
  803741:	89 c6                	mov    %eax,%esi
  803743:	89 d1                	mov    %edx,%ecx
  803745:	39 d3                	cmp    %edx,%ebx
  803747:	0f 82 87 00 00 00    	jb     8037d4 <__umoddi3+0x134>
  80374d:	0f 84 91 00 00 00    	je     8037e4 <__umoddi3+0x144>
  803753:	8b 54 24 04          	mov    0x4(%esp),%edx
  803757:	29 f2                	sub    %esi,%edx
  803759:	19 cb                	sbb    %ecx,%ebx
  80375b:	89 d8                	mov    %ebx,%eax
  80375d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803761:	d3 e0                	shl    %cl,%eax
  803763:	89 e9                	mov    %ebp,%ecx
  803765:	d3 ea                	shr    %cl,%edx
  803767:	09 d0                	or     %edx,%eax
  803769:	89 e9                	mov    %ebp,%ecx
  80376b:	d3 eb                	shr    %cl,%ebx
  80376d:	89 da                	mov    %ebx,%edx
  80376f:	83 c4 1c             	add    $0x1c,%esp
  803772:	5b                   	pop    %ebx
  803773:	5e                   	pop    %esi
  803774:	5f                   	pop    %edi
  803775:	5d                   	pop    %ebp
  803776:	c3                   	ret    
  803777:	90                   	nop
  803778:	89 fd                	mov    %edi,%ebp
  80377a:	85 ff                	test   %edi,%edi
  80377c:	75 0b                	jne    803789 <__umoddi3+0xe9>
  80377e:	b8 01 00 00 00       	mov    $0x1,%eax
  803783:	31 d2                	xor    %edx,%edx
  803785:	f7 f7                	div    %edi
  803787:	89 c5                	mov    %eax,%ebp
  803789:	89 f0                	mov    %esi,%eax
  80378b:	31 d2                	xor    %edx,%edx
  80378d:	f7 f5                	div    %ebp
  80378f:	89 c8                	mov    %ecx,%eax
  803791:	f7 f5                	div    %ebp
  803793:	89 d0                	mov    %edx,%eax
  803795:	e9 44 ff ff ff       	jmp    8036de <__umoddi3+0x3e>
  80379a:	66 90                	xchg   %ax,%ax
  80379c:	89 c8                	mov    %ecx,%eax
  80379e:	89 f2                	mov    %esi,%edx
  8037a0:	83 c4 1c             	add    $0x1c,%esp
  8037a3:	5b                   	pop    %ebx
  8037a4:	5e                   	pop    %esi
  8037a5:	5f                   	pop    %edi
  8037a6:	5d                   	pop    %ebp
  8037a7:	c3                   	ret    
  8037a8:	3b 04 24             	cmp    (%esp),%eax
  8037ab:	72 06                	jb     8037b3 <__umoddi3+0x113>
  8037ad:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8037b1:	77 0f                	ja     8037c2 <__umoddi3+0x122>
  8037b3:	89 f2                	mov    %esi,%edx
  8037b5:	29 f9                	sub    %edi,%ecx
  8037b7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8037bb:	89 14 24             	mov    %edx,(%esp)
  8037be:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8037c2:	8b 44 24 04          	mov    0x4(%esp),%eax
  8037c6:	8b 14 24             	mov    (%esp),%edx
  8037c9:	83 c4 1c             	add    $0x1c,%esp
  8037cc:	5b                   	pop    %ebx
  8037cd:	5e                   	pop    %esi
  8037ce:	5f                   	pop    %edi
  8037cf:	5d                   	pop    %ebp
  8037d0:	c3                   	ret    
  8037d1:	8d 76 00             	lea    0x0(%esi),%esi
  8037d4:	2b 04 24             	sub    (%esp),%eax
  8037d7:	19 fa                	sbb    %edi,%edx
  8037d9:	89 d1                	mov    %edx,%ecx
  8037db:	89 c6                	mov    %eax,%esi
  8037dd:	e9 71 ff ff ff       	jmp    803753 <__umoddi3+0xb3>
  8037e2:	66 90                	xchg   %ax,%ax
  8037e4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8037e8:	72 ea                	jb     8037d4 <__umoddi3+0x134>
  8037ea:	89 d9                	mov    %ebx,%ecx
  8037ec:	e9 62 ff ff ff       	jmp    803753 <__umoddi3+0xb3>
