
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
  80008d:	68 c0 38 80 00       	push   $0x8038c0
  800092:	6a 13                	push   $0x13
  800094:	68 dc 38 80 00       	push   $0x8038dc
  800099:	e8 1d 04 00 00       	call   8004bb <_panic>
	}
	uint32 *x, *y, *z ;

	//x: Readonly
	int freeFrames = sys_calculate_free_frames() ;
  80009e:	e8 29 19 00 00       	call   8019cc <sys_calculate_free_frames>
  8000a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	x = smalloc("x", 4, 0);
  8000a6:	83 ec 04             	sub    $0x4,%esp
  8000a9:	6a 00                	push   $0x0
  8000ab:	6a 04                	push   $0x4
  8000ad:	68 fa 38 80 00       	push   $0x8038fa
  8000b2:	e8 d5 16 00 00       	call   80178c <smalloc>
  8000b7:	83 c4 10             	add    $0x10,%esp
  8000ba:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if (x != (uint32*)USER_HEAP_START) panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8000bd:	81 7d e8 00 00 00 80 	cmpl   $0x80000000,-0x18(%ebp)
  8000c4:	74 14                	je     8000da <_main+0xa2>
  8000c6:	83 ec 04             	sub    $0x4,%esp
  8000c9:	68 fc 38 80 00       	push   $0x8038fc
  8000ce:	6a 1a                	push   $0x1a
  8000d0:	68 dc 38 80 00       	push   $0x8038dc
  8000d5:	e8 e1 03 00 00       	call   8004bb <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Create(): Wrong allocation- make sure that you allocate the required space in the user environment and add its frames to frames_storage %d %d %d", freeFrames, sys_calculate_free_frames(), freeFrames - sys_calculate_free_frames());
  8000da:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000dd:	e8 ea 18 00 00       	call   8019cc <sys_calculate_free_frames>
  8000e2:	29 c3                	sub    %eax,%ebx
  8000e4:	89 d8                	mov    %ebx,%eax
  8000e6:	83 f8 04             	cmp    $0x4,%eax
  8000e9:	74 28                	je     800113 <_main+0xdb>
  8000eb:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000ee:	e8 d9 18 00 00       	call   8019cc <sys_calculate_free_frames>
  8000f3:	29 c3                	sub    %eax,%ebx
  8000f5:	e8 d2 18 00 00       	call   8019cc <sys_calculate_free_frames>
  8000fa:	83 ec 08             	sub    $0x8,%esp
  8000fd:	53                   	push   %ebx
  8000fe:	50                   	push   %eax
  8000ff:	ff 75 ec             	pushl  -0x14(%ebp)
  800102:	68 60 39 80 00       	push   $0x803960
  800107:	6a 1b                	push   $0x1b
  800109:	68 dc 38 80 00       	push   $0x8038dc
  80010e:	e8 a8 03 00 00       	call   8004bb <_panic>

	//y: Readonly
	freeFrames = sys_calculate_free_frames() ;
  800113:	e8 b4 18 00 00       	call   8019cc <sys_calculate_free_frames>
  800118:	89 45 ec             	mov    %eax,-0x14(%ebp)
	y = smalloc("y", 4, 0);
  80011b:	83 ec 04             	sub    $0x4,%esp
  80011e:	6a 00                	push   $0x0
  800120:	6a 04                	push   $0x4
  800122:	68 f1 39 80 00       	push   $0x8039f1
  800127:	e8 60 16 00 00       	call   80178c <smalloc>
  80012c:	83 c4 10             	add    $0x10,%esp
  80012f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (y != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  800132:	81 7d e4 00 10 00 80 	cmpl   $0x80001000,-0x1c(%ebp)
  800139:	74 14                	je     80014f <_main+0x117>
  80013b:	83 ec 04             	sub    $0x4,%esp
  80013e:	68 fc 38 80 00       	push   $0x8038fc
  800143:	6a 20                	push   $0x20
  800145:	68 dc 38 80 00       	push   $0x8038dc
  80014a:	e8 6c 03 00 00       	call   8004bb <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1+0+2) panic("Create(): Wrong allocation- make sure that you allocate the required space in the user environment and add its frames to frames_storage %d %d %d", freeFrames, sys_calculate_free_frames(), freeFrames - sys_calculate_free_frames());
  80014f:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  800152:	e8 75 18 00 00       	call   8019cc <sys_calculate_free_frames>
  800157:	29 c3                	sub    %eax,%ebx
  800159:	89 d8                	mov    %ebx,%eax
  80015b:	83 f8 03             	cmp    $0x3,%eax
  80015e:	74 28                	je     800188 <_main+0x150>
  800160:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  800163:	e8 64 18 00 00       	call   8019cc <sys_calculate_free_frames>
  800168:	29 c3                	sub    %eax,%ebx
  80016a:	e8 5d 18 00 00       	call   8019cc <sys_calculate_free_frames>
  80016f:	83 ec 08             	sub    $0x8,%esp
  800172:	53                   	push   %ebx
  800173:	50                   	push   %eax
  800174:	ff 75 ec             	pushl  -0x14(%ebp)
  800177:	68 60 39 80 00       	push   $0x803960
  80017c:	6a 21                	push   $0x21
  80017e:	68 dc 38 80 00       	push   $0x8038dc
  800183:	e8 33 03 00 00       	call   8004bb <_panic>

	//z: Writable
	freeFrames = sys_calculate_free_frames() ;
  800188:	e8 3f 18 00 00       	call   8019cc <sys_calculate_free_frames>
  80018d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	z = smalloc("z", 4, 1);
  800190:	83 ec 04             	sub    $0x4,%esp
  800193:	6a 01                	push   $0x1
  800195:	6a 04                	push   $0x4
  800197:	68 f3 39 80 00       	push   $0x8039f3
  80019c:	e8 eb 15 00 00       	call   80178c <smalloc>
  8001a1:	83 c4 10             	add    $0x10,%esp
  8001a4:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (z != (uint32*)(USER_HEAP_START + 2 * PAGE_SIZE)) panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8001a7:	81 7d e0 00 20 00 80 	cmpl   $0x80002000,-0x20(%ebp)
  8001ae:	74 14                	je     8001c4 <_main+0x18c>
  8001b0:	83 ec 04             	sub    $0x4,%esp
  8001b3:	68 fc 38 80 00       	push   $0x8038fc
  8001b8:	6a 26                	push   $0x26
  8001ba:	68 dc 38 80 00       	push   $0x8038dc
  8001bf:	e8 f7 02 00 00       	call   8004bb <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1+0+2) panic("Create(): Wrong allocation- make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8001c4:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8001c7:	e8 00 18 00 00       	call   8019cc <sys_calculate_free_frames>
  8001cc:	29 c3                	sub    %eax,%ebx
  8001ce:	89 d8                	mov    %ebx,%eax
  8001d0:	83 f8 03             	cmp    $0x3,%eax
  8001d3:	74 14                	je     8001e9 <_main+0x1b1>
  8001d5:	83 ec 04             	sub    $0x4,%esp
  8001d8:	68 f8 39 80 00       	push   $0x8039f8
  8001dd:	6a 27                	push   $0x27
  8001df:	68 dc 38 80 00       	push   $0x8038dc
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
  800214:	68 80 3a 80 00       	push   $0x803a80
  800219:	e8 20 1a 00 00       	call   801c3e <sys_create_env>
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
  80023d:	68 80 3a 80 00       	push   $0x803a80
  800242:	e8 f7 19 00 00       	call   801c3e <sys_create_env>
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
  800266:	68 80 3a 80 00       	push   $0x803a80
  80026b:	e8 ce 19 00 00       	call   801c3e <sys_create_env>
  800270:	83 c4 10             	add    $0x10,%esp
  800273:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	//to check that the slave environments completed successfully
	rsttst();
  800276:	e8 0f 1b 00 00       	call   801d8a <rsttst>

	int* finish_children = smalloc("finish_children", sizeof(int), 1);
  80027b:	83 ec 04             	sub    $0x4,%esp
  80027e:	6a 01                	push   $0x1
  800280:	6a 04                	push   $0x4
  800282:	68 8e 3a 80 00       	push   $0x803a8e
  800287:	e8 00 15 00 00       	call   80178c <smalloc>
  80028c:	83 c4 10             	add    $0x10,%esp
  80028f:	89 45 d0             	mov    %eax,-0x30(%ebp)

	sys_run_env(id1);
  800292:	83 ec 0c             	sub    $0xc,%esp
  800295:	ff 75 dc             	pushl  -0x24(%ebp)
  800298:	e8 bf 19 00 00       	call   801c5c <sys_run_env>
  80029d:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id2);
  8002a0:	83 ec 0c             	sub    $0xc,%esp
  8002a3:	ff 75 d8             	pushl  -0x28(%ebp)
  8002a6:	e8 b1 19 00 00       	call   801c5c <sys_run_env>
  8002ab:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id3);
  8002ae:	83 ec 0c             	sub    $0xc,%esp
  8002b1:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002b4:	e8 a3 19 00 00       	call   801c5c <sys_run_env>
  8002b9:	83 c4 10             	add    $0x10,%esp

	env_sleep(15000) ;
  8002bc:	83 ec 0c             	sub    $0xc,%esp
  8002bf:	68 98 3a 00 00       	push   $0x3a98
  8002c4:	e8 c5 32 00 00       	call   80358e <env_sleep>
  8002c9:	83 c4 10             	add    $0x10,%esp

	//to ensure that the slave environments completed successfully
	if (gettst()!=3) panic("test failed");
  8002cc:	e8 33 1b 00 00       	call   801e04 <gettst>
  8002d1:	83 f8 03             	cmp    $0x3,%eax
  8002d4:	74 14                	je     8002ea <_main+0x2b2>
  8002d6:	83 ec 04             	sub    $0x4,%esp
  8002d9:	68 9e 3a 80 00       	push   $0x803a9e
  8002de:	6a 3d                	push   $0x3d
  8002e0:	68 dc 38 80 00       	push   $0x8038dc
  8002e5:	e8 d1 01 00 00       	call   8004bb <_panic>


	if (*z != 30)
  8002ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002ed:	8b 00                	mov    (%eax),%eax
  8002ef:	83 f8 1e             	cmp    $0x1e,%eax
  8002f2:	74 14                	je     800308 <_main+0x2d0>
		panic("Error!! Please check the creation (or the getting) of shared 2variables!!\n\n\n");
  8002f4:	83 ec 04             	sub    $0x4,%esp
  8002f7:	68 ac 3a 80 00       	push   $0x803aac
  8002fc:	6a 41                	push   $0x41
  8002fe:	68 dc 38 80 00       	push   $0x8038dc
  800303:	e8 b3 01 00 00       	call   8004bb <_panic>
	else
		cprintf("Congratulations!! Test of Shared Variables [Create & Get] [2] completed successfully!!\n\n\n");
  800308:	83 ec 0c             	sub    $0xc,%esp
  80030b:	68 fc 3a 80 00       	push   $0x803afc
  800310:	e8 5a 04 00 00       	call   80076f <cprintf>
  800315:	83 c4 10             	add    $0x10,%esp


	if (sys_getparentenvid() > 0) {
  800318:	e8 a8 19 00 00       	call   801cc5 <sys_getparentenvid>
  80031d:	85 c0                	test   %eax,%eax
  80031f:	7e 58                	jle    800379 <_main+0x341>
		sys_destroy_env(id1);
  800321:	83 ec 0c             	sub    $0xc,%esp
  800324:	ff 75 dc             	pushl  -0x24(%ebp)
  800327:	e8 4c 19 00 00       	call   801c78 <sys_destroy_env>
  80032c:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(id2);
  80032f:	83 ec 0c             	sub    $0xc,%esp
  800332:	ff 75 d8             	pushl  -0x28(%ebp)
  800335:	e8 3e 19 00 00       	call   801c78 <sys_destroy_env>
  80033a:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(id3);
  80033d:	83 ec 0c             	sub    $0xc,%esp
  800340:	ff 75 d4             	pushl  -0x2c(%ebp)
  800343:	e8 30 19 00 00       	call   801c78 <sys_destroy_env>
  800348:	83 c4 10             	add    $0x10,%esp
		int *finishedCount = NULL;
  80034b:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
		finishedCount = sget(sys_getparentenvid(), "finishedCount") ;
  800352:	e8 6e 19 00 00       	call   801cc5 <sys_getparentenvid>
  800357:	83 ec 08             	sub    $0x8,%esp
  80035a:	68 56 3b 80 00       	push   $0x803b56
  80035f:	50                   	push   %eax
  800360:	e8 c3 14 00 00       	call   801828 <sget>
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
  800385:	e8 22 19 00 00       	call   801cac <sys_getenvindex>
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
  8003f0:	e8 c4 16 00 00       	call   801ab9 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8003f5:	83 ec 0c             	sub    $0xc,%esp
  8003f8:	68 7c 3b 80 00       	push   $0x803b7c
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
  800420:	68 a4 3b 80 00       	push   $0x803ba4
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
  800451:	68 cc 3b 80 00       	push   $0x803bcc
  800456:	e8 14 03 00 00       	call   80076f <cprintf>
  80045b:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80045e:	a1 20 50 80 00       	mov    0x805020,%eax
  800463:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800469:	83 ec 08             	sub    $0x8,%esp
  80046c:	50                   	push   %eax
  80046d:	68 24 3c 80 00       	push   $0x803c24
  800472:	e8 f8 02 00 00       	call   80076f <cprintf>
  800477:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80047a:	83 ec 0c             	sub    $0xc,%esp
  80047d:	68 7c 3b 80 00       	push   $0x803b7c
  800482:	e8 e8 02 00 00       	call   80076f <cprintf>
  800487:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80048a:	e8 44 16 00 00       	call   801ad3 <sys_enable_interrupt>

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
  8004a2:	e8 d1 17 00 00       	call   801c78 <sys_destroy_env>
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
  8004b3:	e8 26 18 00 00       	call   801cde <sys_exit_env>
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
  8004dc:	68 38 3c 80 00       	push   $0x803c38
  8004e1:	e8 89 02 00 00       	call   80076f <cprintf>
  8004e6:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8004e9:	a1 00 50 80 00       	mov    0x805000,%eax
  8004ee:	ff 75 0c             	pushl  0xc(%ebp)
  8004f1:	ff 75 08             	pushl  0x8(%ebp)
  8004f4:	50                   	push   %eax
  8004f5:	68 3d 3c 80 00       	push   $0x803c3d
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
  800519:	68 59 3c 80 00       	push   $0x803c59
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
  800545:	68 5c 3c 80 00       	push   $0x803c5c
  80054a:	6a 26                	push   $0x26
  80054c:	68 a8 3c 80 00       	push   $0x803ca8
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
  800617:	68 b4 3c 80 00       	push   $0x803cb4
  80061c:	6a 3a                	push   $0x3a
  80061e:	68 a8 3c 80 00       	push   $0x803ca8
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
  800687:	68 08 3d 80 00       	push   $0x803d08
  80068c:	6a 44                	push   $0x44
  80068e:	68 a8 3c 80 00       	push   $0x803ca8
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
  8006e1:	e8 25 12 00 00       	call   80190b <sys_cputs>
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
  800758:	e8 ae 11 00 00       	call   80190b <sys_cputs>
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
  8007a2:	e8 12 13 00 00       	call   801ab9 <sys_disable_interrupt>
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
  8007c2:	e8 0c 13 00 00       	call   801ad3 <sys_enable_interrupt>
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
  80080c:	e8 33 2e 00 00       	call   803644 <__udivdi3>
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
  80085c:	e8 f3 2e 00 00       	call   803754 <__umoddi3>
  800861:	83 c4 10             	add    $0x10,%esp
  800864:	05 74 3f 80 00       	add    $0x803f74,%eax
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
  8009b7:	8b 04 85 98 3f 80 00 	mov    0x803f98(,%eax,4),%eax
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
  800a98:	8b 34 9d e0 3d 80 00 	mov    0x803de0(,%ebx,4),%esi
  800a9f:	85 f6                	test   %esi,%esi
  800aa1:	75 19                	jne    800abc <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800aa3:	53                   	push   %ebx
  800aa4:	68 85 3f 80 00       	push   $0x803f85
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
  800abd:	68 8e 3f 80 00       	push   $0x803f8e
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
  800aea:	be 91 3f 80 00       	mov    $0x803f91,%esi
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
  801510:	68 f0 40 80 00       	push   $0x8040f0
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
  8015e0:	e8 6a 04 00 00       	call   801a4f <sys_allocate_chunk>
  8015e5:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8015e8:	a1 20 51 80 00       	mov    0x805120,%eax
  8015ed:	83 ec 0c             	sub    $0xc,%esp
  8015f0:	50                   	push   %eax
  8015f1:	e8 df 0a 00 00       	call   8020d5 <initialize_MemBlocksList>
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
  80161e:	68 15 41 80 00       	push   $0x804115
  801623:	6a 33                	push   $0x33
  801625:	68 33 41 80 00       	push   $0x804133
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
  80169d:	68 40 41 80 00       	push   $0x804140
  8016a2:	6a 34                	push   $0x34
  8016a4:	68 33 41 80 00       	push   $0x804133
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
  801735:	e8 e3 06 00 00       	call   801e1d <sys_isUHeapPlacementStrategyFIRSTFIT>
  80173a:	85 c0                	test   %eax,%eax
  80173c:	74 11                	je     80174f <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  80173e:	83 ec 0c             	sub    $0xc,%esp
  801741:	ff 75 e8             	pushl  -0x18(%ebp)
  801744:	e8 4e 0d 00 00       	call   802497 <alloc_block_FF>
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
  80175b:	e8 aa 0a 00 00       	call   80220a <insert_sorted_allocList>
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
  80177b:	68 64 41 80 00       	push   $0x804164
  801780:	6a 6f                	push   $0x6f
  801782:	68 33 41 80 00       	push   $0x804133
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
  8017a1:	75 07                	jne    8017aa <smalloc+0x1e>
  8017a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8017a8:	eb 7c                	jmp    801826 <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  8017aa:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8017b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017b7:	01 d0                	add    %edx,%eax
  8017b9:	48                   	dec    %eax
  8017ba:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8017bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8017c5:	f7 75 f0             	divl   -0x10(%ebp)
  8017c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017cb:	29 d0                	sub    %edx,%eax
  8017cd:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  8017d0:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8017d7:	e8 41 06 00 00       	call   801e1d <sys_isUHeapPlacementStrategyFIRSTFIT>
  8017dc:	85 c0                	test   %eax,%eax
  8017de:	74 11                	je     8017f1 <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  8017e0:	83 ec 0c             	sub    $0xc,%esp
  8017e3:	ff 75 e8             	pushl  -0x18(%ebp)
  8017e6:	e8 ac 0c 00 00       	call   802497 <alloc_block_FF>
  8017eb:	83 c4 10             	add    $0x10,%esp
  8017ee:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  8017f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8017f5:	74 2a                	je     801821 <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8017f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017fa:	8b 40 08             	mov    0x8(%eax),%eax
  8017fd:	89 c2                	mov    %eax,%edx
  8017ff:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801803:	52                   	push   %edx
  801804:	50                   	push   %eax
  801805:	ff 75 0c             	pushl  0xc(%ebp)
  801808:	ff 75 08             	pushl  0x8(%ebp)
  80180b:	e8 92 03 00 00       	call   801ba2 <sys_createSharedObject>
  801810:	83 c4 10             	add    $0x10,%esp
  801813:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  801816:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  80181a:	74 05                	je     801821 <smalloc+0x95>
			return (void*)virtual_address;
  80181c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80181f:	eb 05                	jmp    801826 <smalloc+0x9a>
	}
	return NULL;
  801821:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801826:	c9                   	leave  
  801827:	c3                   	ret    

00801828 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801828:	55                   	push   %ebp
  801829:	89 e5                	mov    %esp,%ebp
  80182b:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80182e:	e8 c6 fc ff ff       	call   8014f9 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801833:	83 ec 04             	sub    $0x4,%esp
  801836:	68 88 41 80 00       	push   $0x804188
  80183b:	68 b0 00 00 00       	push   $0xb0
  801840:	68 33 41 80 00       	push   $0x804133
  801845:	e8 71 ec ff ff       	call   8004bb <_panic>

0080184a <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80184a:	55                   	push   %ebp
  80184b:	89 e5                	mov    %esp,%ebp
  80184d:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801850:	e8 a4 fc ff ff       	call   8014f9 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801855:	83 ec 04             	sub    $0x4,%esp
  801858:	68 ac 41 80 00       	push   $0x8041ac
  80185d:	68 f4 00 00 00       	push   $0xf4
  801862:	68 33 41 80 00       	push   $0x804133
  801867:	e8 4f ec ff ff       	call   8004bb <_panic>

0080186c <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80186c:	55                   	push   %ebp
  80186d:	89 e5                	mov    %esp,%ebp
  80186f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801872:	83 ec 04             	sub    $0x4,%esp
  801875:	68 d4 41 80 00       	push   $0x8041d4
  80187a:	68 08 01 00 00       	push   $0x108
  80187f:	68 33 41 80 00       	push   $0x804133
  801884:	e8 32 ec ff ff       	call   8004bb <_panic>

00801889 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801889:	55                   	push   %ebp
  80188a:	89 e5                	mov    %esp,%ebp
  80188c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80188f:	83 ec 04             	sub    $0x4,%esp
  801892:	68 f8 41 80 00       	push   $0x8041f8
  801897:	68 13 01 00 00       	push   $0x113
  80189c:	68 33 41 80 00       	push   $0x804133
  8018a1:	e8 15 ec ff ff       	call   8004bb <_panic>

008018a6 <shrink>:

}
void shrink(uint32 newSize)
{
  8018a6:	55                   	push   %ebp
  8018a7:	89 e5                	mov    %esp,%ebp
  8018a9:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018ac:	83 ec 04             	sub    $0x4,%esp
  8018af:	68 f8 41 80 00       	push   $0x8041f8
  8018b4:	68 18 01 00 00       	push   $0x118
  8018b9:	68 33 41 80 00       	push   $0x804133
  8018be:	e8 f8 eb ff ff       	call   8004bb <_panic>

008018c3 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8018c3:	55                   	push   %ebp
  8018c4:	89 e5                	mov    %esp,%ebp
  8018c6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018c9:	83 ec 04             	sub    $0x4,%esp
  8018cc:	68 f8 41 80 00       	push   $0x8041f8
  8018d1:	68 1d 01 00 00       	push   $0x11d
  8018d6:	68 33 41 80 00       	push   $0x804133
  8018db:	e8 db eb ff ff       	call   8004bb <_panic>

008018e0 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8018e0:	55                   	push   %ebp
  8018e1:	89 e5                	mov    %esp,%ebp
  8018e3:	57                   	push   %edi
  8018e4:	56                   	push   %esi
  8018e5:	53                   	push   %ebx
  8018e6:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ef:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018f2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018f5:	8b 7d 18             	mov    0x18(%ebp),%edi
  8018f8:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8018fb:	cd 30                	int    $0x30
  8018fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801900:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801903:	83 c4 10             	add    $0x10,%esp
  801906:	5b                   	pop    %ebx
  801907:	5e                   	pop    %esi
  801908:	5f                   	pop    %edi
  801909:	5d                   	pop    %ebp
  80190a:	c3                   	ret    

0080190b <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80190b:	55                   	push   %ebp
  80190c:	89 e5                	mov    %esp,%ebp
  80190e:	83 ec 04             	sub    $0x4,%esp
  801911:	8b 45 10             	mov    0x10(%ebp),%eax
  801914:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801917:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80191b:	8b 45 08             	mov    0x8(%ebp),%eax
  80191e:	6a 00                	push   $0x0
  801920:	6a 00                	push   $0x0
  801922:	52                   	push   %edx
  801923:	ff 75 0c             	pushl  0xc(%ebp)
  801926:	50                   	push   %eax
  801927:	6a 00                	push   $0x0
  801929:	e8 b2 ff ff ff       	call   8018e0 <syscall>
  80192e:	83 c4 18             	add    $0x18,%esp
}
  801931:	90                   	nop
  801932:	c9                   	leave  
  801933:	c3                   	ret    

00801934 <sys_cgetc>:

int
sys_cgetc(void)
{
  801934:	55                   	push   %ebp
  801935:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801937:	6a 00                	push   $0x0
  801939:	6a 00                	push   $0x0
  80193b:	6a 00                	push   $0x0
  80193d:	6a 00                	push   $0x0
  80193f:	6a 00                	push   $0x0
  801941:	6a 01                	push   $0x1
  801943:	e8 98 ff ff ff       	call   8018e0 <syscall>
  801948:	83 c4 18             	add    $0x18,%esp
}
  80194b:	c9                   	leave  
  80194c:	c3                   	ret    

0080194d <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80194d:	55                   	push   %ebp
  80194e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801950:	8b 55 0c             	mov    0xc(%ebp),%edx
  801953:	8b 45 08             	mov    0x8(%ebp),%eax
  801956:	6a 00                	push   $0x0
  801958:	6a 00                	push   $0x0
  80195a:	6a 00                	push   $0x0
  80195c:	52                   	push   %edx
  80195d:	50                   	push   %eax
  80195e:	6a 05                	push   $0x5
  801960:	e8 7b ff ff ff       	call   8018e0 <syscall>
  801965:	83 c4 18             	add    $0x18,%esp
}
  801968:	c9                   	leave  
  801969:	c3                   	ret    

0080196a <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80196a:	55                   	push   %ebp
  80196b:	89 e5                	mov    %esp,%ebp
  80196d:	56                   	push   %esi
  80196e:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80196f:	8b 75 18             	mov    0x18(%ebp),%esi
  801972:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801975:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801978:	8b 55 0c             	mov    0xc(%ebp),%edx
  80197b:	8b 45 08             	mov    0x8(%ebp),%eax
  80197e:	56                   	push   %esi
  80197f:	53                   	push   %ebx
  801980:	51                   	push   %ecx
  801981:	52                   	push   %edx
  801982:	50                   	push   %eax
  801983:	6a 06                	push   $0x6
  801985:	e8 56 ff ff ff       	call   8018e0 <syscall>
  80198a:	83 c4 18             	add    $0x18,%esp
}
  80198d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801990:	5b                   	pop    %ebx
  801991:	5e                   	pop    %esi
  801992:	5d                   	pop    %ebp
  801993:	c3                   	ret    

00801994 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801994:	55                   	push   %ebp
  801995:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801997:	8b 55 0c             	mov    0xc(%ebp),%edx
  80199a:	8b 45 08             	mov    0x8(%ebp),%eax
  80199d:	6a 00                	push   $0x0
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	52                   	push   %edx
  8019a4:	50                   	push   %eax
  8019a5:	6a 07                	push   $0x7
  8019a7:	e8 34 ff ff ff       	call   8018e0 <syscall>
  8019ac:	83 c4 18             	add    $0x18,%esp
}
  8019af:	c9                   	leave  
  8019b0:	c3                   	ret    

008019b1 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8019b1:	55                   	push   %ebp
  8019b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8019b4:	6a 00                	push   $0x0
  8019b6:	6a 00                	push   $0x0
  8019b8:	6a 00                	push   $0x0
  8019ba:	ff 75 0c             	pushl  0xc(%ebp)
  8019bd:	ff 75 08             	pushl  0x8(%ebp)
  8019c0:	6a 08                	push   $0x8
  8019c2:	e8 19 ff ff ff       	call   8018e0 <syscall>
  8019c7:	83 c4 18             	add    $0x18,%esp
}
  8019ca:	c9                   	leave  
  8019cb:	c3                   	ret    

008019cc <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8019cc:	55                   	push   %ebp
  8019cd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 00                	push   $0x0
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 00                	push   $0x0
  8019d7:	6a 00                	push   $0x0
  8019d9:	6a 09                	push   $0x9
  8019db:	e8 00 ff ff ff       	call   8018e0 <syscall>
  8019e0:	83 c4 18             	add    $0x18,%esp
}
  8019e3:	c9                   	leave  
  8019e4:	c3                   	ret    

008019e5 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8019e5:	55                   	push   %ebp
  8019e6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8019e8:	6a 00                	push   $0x0
  8019ea:	6a 00                	push   $0x0
  8019ec:	6a 00                	push   $0x0
  8019ee:	6a 00                	push   $0x0
  8019f0:	6a 00                	push   $0x0
  8019f2:	6a 0a                	push   $0xa
  8019f4:	e8 e7 fe ff ff       	call   8018e0 <syscall>
  8019f9:	83 c4 18             	add    $0x18,%esp
}
  8019fc:	c9                   	leave  
  8019fd:	c3                   	ret    

008019fe <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8019fe:	55                   	push   %ebp
  8019ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a01:	6a 00                	push   $0x0
  801a03:	6a 00                	push   $0x0
  801a05:	6a 00                	push   $0x0
  801a07:	6a 00                	push   $0x0
  801a09:	6a 00                	push   $0x0
  801a0b:	6a 0b                	push   $0xb
  801a0d:	e8 ce fe ff ff       	call   8018e0 <syscall>
  801a12:	83 c4 18             	add    $0x18,%esp
}
  801a15:	c9                   	leave  
  801a16:	c3                   	ret    

00801a17 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801a17:	55                   	push   %ebp
  801a18:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801a1a:	6a 00                	push   $0x0
  801a1c:	6a 00                	push   $0x0
  801a1e:	6a 00                	push   $0x0
  801a20:	ff 75 0c             	pushl  0xc(%ebp)
  801a23:	ff 75 08             	pushl  0x8(%ebp)
  801a26:	6a 0f                	push   $0xf
  801a28:	e8 b3 fe ff ff       	call   8018e0 <syscall>
  801a2d:	83 c4 18             	add    $0x18,%esp
	return;
  801a30:	90                   	nop
}
  801a31:	c9                   	leave  
  801a32:	c3                   	ret    

00801a33 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a33:	55                   	push   %ebp
  801a34:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801a36:	6a 00                	push   $0x0
  801a38:	6a 00                	push   $0x0
  801a3a:	6a 00                	push   $0x0
  801a3c:	ff 75 0c             	pushl  0xc(%ebp)
  801a3f:	ff 75 08             	pushl  0x8(%ebp)
  801a42:	6a 10                	push   $0x10
  801a44:	e8 97 fe ff ff       	call   8018e0 <syscall>
  801a49:	83 c4 18             	add    $0x18,%esp
	return ;
  801a4c:	90                   	nop
}
  801a4d:	c9                   	leave  
  801a4e:	c3                   	ret    

00801a4f <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801a4f:	55                   	push   %ebp
  801a50:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a52:	6a 00                	push   $0x0
  801a54:	6a 00                	push   $0x0
  801a56:	ff 75 10             	pushl  0x10(%ebp)
  801a59:	ff 75 0c             	pushl  0xc(%ebp)
  801a5c:	ff 75 08             	pushl  0x8(%ebp)
  801a5f:	6a 11                	push   $0x11
  801a61:	e8 7a fe ff ff       	call   8018e0 <syscall>
  801a66:	83 c4 18             	add    $0x18,%esp
	return ;
  801a69:	90                   	nop
}
  801a6a:	c9                   	leave  
  801a6b:	c3                   	ret    

00801a6c <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a6c:	55                   	push   %ebp
  801a6d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a6f:	6a 00                	push   $0x0
  801a71:	6a 00                	push   $0x0
  801a73:	6a 00                	push   $0x0
  801a75:	6a 00                	push   $0x0
  801a77:	6a 00                	push   $0x0
  801a79:	6a 0c                	push   $0xc
  801a7b:	e8 60 fe ff ff       	call   8018e0 <syscall>
  801a80:	83 c4 18             	add    $0x18,%esp
}
  801a83:	c9                   	leave  
  801a84:	c3                   	ret    

00801a85 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a85:	55                   	push   %ebp
  801a86:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a88:	6a 00                	push   $0x0
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 00                	push   $0x0
  801a8e:	6a 00                	push   $0x0
  801a90:	ff 75 08             	pushl  0x8(%ebp)
  801a93:	6a 0d                	push   $0xd
  801a95:	e8 46 fe ff ff       	call   8018e0 <syscall>
  801a9a:	83 c4 18             	add    $0x18,%esp
}
  801a9d:	c9                   	leave  
  801a9e:	c3                   	ret    

00801a9f <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a9f:	55                   	push   %ebp
  801aa0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801aa2:	6a 00                	push   $0x0
  801aa4:	6a 00                	push   $0x0
  801aa6:	6a 00                	push   $0x0
  801aa8:	6a 00                	push   $0x0
  801aaa:	6a 00                	push   $0x0
  801aac:	6a 0e                	push   $0xe
  801aae:	e8 2d fe ff ff       	call   8018e0 <syscall>
  801ab3:	83 c4 18             	add    $0x18,%esp
}
  801ab6:	90                   	nop
  801ab7:	c9                   	leave  
  801ab8:	c3                   	ret    

00801ab9 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801ab9:	55                   	push   %ebp
  801aba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801abc:	6a 00                	push   $0x0
  801abe:	6a 00                	push   $0x0
  801ac0:	6a 00                	push   $0x0
  801ac2:	6a 00                	push   $0x0
  801ac4:	6a 00                	push   $0x0
  801ac6:	6a 13                	push   $0x13
  801ac8:	e8 13 fe ff ff       	call   8018e0 <syscall>
  801acd:	83 c4 18             	add    $0x18,%esp
}
  801ad0:	90                   	nop
  801ad1:	c9                   	leave  
  801ad2:	c3                   	ret    

00801ad3 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801ad3:	55                   	push   %ebp
  801ad4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801ad6:	6a 00                	push   $0x0
  801ad8:	6a 00                	push   $0x0
  801ada:	6a 00                	push   $0x0
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	6a 14                	push   $0x14
  801ae2:	e8 f9 fd ff ff       	call   8018e0 <syscall>
  801ae7:	83 c4 18             	add    $0x18,%esp
}
  801aea:	90                   	nop
  801aeb:	c9                   	leave  
  801aec:	c3                   	ret    

00801aed <sys_cputc>:


void
sys_cputc(const char c)
{
  801aed:	55                   	push   %ebp
  801aee:	89 e5                	mov    %esp,%ebp
  801af0:	83 ec 04             	sub    $0x4,%esp
  801af3:	8b 45 08             	mov    0x8(%ebp),%eax
  801af6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801af9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801afd:	6a 00                	push   $0x0
  801aff:	6a 00                	push   $0x0
  801b01:	6a 00                	push   $0x0
  801b03:	6a 00                	push   $0x0
  801b05:	50                   	push   %eax
  801b06:	6a 15                	push   $0x15
  801b08:	e8 d3 fd ff ff       	call   8018e0 <syscall>
  801b0d:	83 c4 18             	add    $0x18,%esp
}
  801b10:	90                   	nop
  801b11:	c9                   	leave  
  801b12:	c3                   	ret    

00801b13 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b13:	55                   	push   %ebp
  801b14:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b16:	6a 00                	push   $0x0
  801b18:	6a 00                	push   $0x0
  801b1a:	6a 00                	push   $0x0
  801b1c:	6a 00                	push   $0x0
  801b1e:	6a 00                	push   $0x0
  801b20:	6a 16                	push   $0x16
  801b22:	e8 b9 fd ff ff       	call   8018e0 <syscall>
  801b27:	83 c4 18             	add    $0x18,%esp
}
  801b2a:	90                   	nop
  801b2b:	c9                   	leave  
  801b2c:	c3                   	ret    

00801b2d <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801b2d:	55                   	push   %ebp
  801b2e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801b30:	8b 45 08             	mov    0x8(%ebp),%eax
  801b33:	6a 00                	push   $0x0
  801b35:	6a 00                	push   $0x0
  801b37:	6a 00                	push   $0x0
  801b39:	ff 75 0c             	pushl  0xc(%ebp)
  801b3c:	50                   	push   %eax
  801b3d:	6a 17                	push   $0x17
  801b3f:	e8 9c fd ff ff       	call   8018e0 <syscall>
  801b44:	83 c4 18             	add    $0x18,%esp
}
  801b47:	c9                   	leave  
  801b48:	c3                   	ret    

00801b49 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801b49:	55                   	push   %ebp
  801b4a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b4c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b52:	6a 00                	push   $0x0
  801b54:	6a 00                	push   $0x0
  801b56:	6a 00                	push   $0x0
  801b58:	52                   	push   %edx
  801b59:	50                   	push   %eax
  801b5a:	6a 1a                	push   $0x1a
  801b5c:	e8 7f fd ff ff       	call   8018e0 <syscall>
  801b61:	83 c4 18             	add    $0x18,%esp
}
  801b64:	c9                   	leave  
  801b65:	c3                   	ret    

00801b66 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b66:	55                   	push   %ebp
  801b67:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b69:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6f:	6a 00                	push   $0x0
  801b71:	6a 00                	push   $0x0
  801b73:	6a 00                	push   $0x0
  801b75:	52                   	push   %edx
  801b76:	50                   	push   %eax
  801b77:	6a 18                	push   $0x18
  801b79:	e8 62 fd ff ff       	call   8018e0 <syscall>
  801b7e:	83 c4 18             	add    $0x18,%esp
}
  801b81:	90                   	nop
  801b82:	c9                   	leave  
  801b83:	c3                   	ret    

00801b84 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b84:	55                   	push   %ebp
  801b85:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b87:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8d:	6a 00                	push   $0x0
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 00                	push   $0x0
  801b93:	52                   	push   %edx
  801b94:	50                   	push   %eax
  801b95:	6a 19                	push   $0x19
  801b97:	e8 44 fd ff ff       	call   8018e0 <syscall>
  801b9c:	83 c4 18             	add    $0x18,%esp
}
  801b9f:	90                   	nop
  801ba0:	c9                   	leave  
  801ba1:	c3                   	ret    

00801ba2 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801ba2:	55                   	push   %ebp
  801ba3:	89 e5                	mov    %esp,%ebp
  801ba5:	83 ec 04             	sub    $0x4,%esp
  801ba8:	8b 45 10             	mov    0x10(%ebp),%eax
  801bab:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801bae:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801bb1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb8:	6a 00                	push   $0x0
  801bba:	51                   	push   %ecx
  801bbb:	52                   	push   %edx
  801bbc:	ff 75 0c             	pushl  0xc(%ebp)
  801bbf:	50                   	push   %eax
  801bc0:	6a 1b                	push   $0x1b
  801bc2:	e8 19 fd ff ff       	call   8018e0 <syscall>
  801bc7:	83 c4 18             	add    $0x18,%esp
}
  801bca:	c9                   	leave  
  801bcb:	c3                   	ret    

00801bcc <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801bcc:	55                   	push   %ebp
  801bcd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801bcf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd5:	6a 00                	push   $0x0
  801bd7:	6a 00                	push   $0x0
  801bd9:	6a 00                	push   $0x0
  801bdb:	52                   	push   %edx
  801bdc:	50                   	push   %eax
  801bdd:	6a 1c                	push   $0x1c
  801bdf:	e8 fc fc ff ff       	call   8018e0 <syscall>
  801be4:	83 c4 18             	add    $0x18,%esp
}
  801be7:	c9                   	leave  
  801be8:	c3                   	ret    

00801be9 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801be9:	55                   	push   %ebp
  801bea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801bec:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bef:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bf2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf5:	6a 00                	push   $0x0
  801bf7:	6a 00                	push   $0x0
  801bf9:	51                   	push   %ecx
  801bfa:	52                   	push   %edx
  801bfb:	50                   	push   %eax
  801bfc:	6a 1d                	push   $0x1d
  801bfe:	e8 dd fc ff ff       	call   8018e0 <syscall>
  801c03:	83 c4 18             	add    $0x18,%esp
}
  801c06:	c9                   	leave  
  801c07:	c3                   	ret    

00801c08 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801c08:	55                   	push   %ebp
  801c09:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801c0b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c11:	6a 00                	push   $0x0
  801c13:	6a 00                	push   $0x0
  801c15:	6a 00                	push   $0x0
  801c17:	52                   	push   %edx
  801c18:	50                   	push   %eax
  801c19:	6a 1e                	push   $0x1e
  801c1b:	e8 c0 fc ff ff       	call   8018e0 <syscall>
  801c20:	83 c4 18             	add    $0x18,%esp
}
  801c23:	c9                   	leave  
  801c24:	c3                   	ret    

00801c25 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801c25:	55                   	push   %ebp
  801c26:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801c28:	6a 00                	push   $0x0
  801c2a:	6a 00                	push   $0x0
  801c2c:	6a 00                	push   $0x0
  801c2e:	6a 00                	push   $0x0
  801c30:	6a 00                	push   $0x0
  801c32:	6a 1f                	push   $0x1f
  801c34:	e8 a7 fc ff ff       	call   8018e0 <syscall>
  801c39:	83 c4 18             	add    $0x18,%esp
}
  801c3c:	c9                   	leave  
  801c3d:	c3                   	ret    

00801c3e <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c3e:	55                   	push   %ebp
  801c3f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c41:	8b 45 08             	mov    0x8(%ebp),%eax
  801c44:	6a 00                	push   $0x0
  801c46:	ff 75 14             	pushl  0x14(%ebp)
  801c49:	ff 75 10             	pushl  0x10(%ebp)
  801c4c:	ff 75 0c             	pushl  0xc(%ebp)
  801c4f:	50                   	push   %eax
  801c50:	6a 20                	push   $0x20
  801c52:	e8 89 fc ff ff       	call   8018e0 <syscall>
  801c57:	83 c4 18             	add    $0x18,%esp
}
  801c5a:	c9                   	leave  
  801c5b:	c3                   	ret    

00801c5c <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801c5c:	55                   	push   %ebp
  801c5d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c62:	6a 00                	push   $0x0
  801c64:	6a 00                	push   $0x0
  801c66:	6a 00                	push   $0x0
  801c68:	6a 00                	push   $0x0
  801c6a:	50                   	push   %eax
  801c6b:	6a 21                	push   $0x21
  801c6d:	e8 6e fc ff ff       	call   8018e0 <syscall>
  801c72:	83 c4 18             	add    $0x18,%esp
}
  801c75:	90                   	nop
  801c76:	c9                   	leave  
  801c77:	c3                   	ret    

00801c78 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c78:	55                   	push   %ebp
  801c79:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7e:	6a 00                	push   $0x0
  801c80:	6a 00                	push   $0x0
  801c82:	6a 00                	push   $0x0
  801c84:	6a 00                	push   $0x0
  801c86:	50                   	push   %eax
  801c87:	6a 22                	push   $0x22
  801c89:	e8 52 fc ff ff       	call   8018e0 <syscall>
  801c8e:	83 c4 18             	add    $0x18,%esp
}
  801c91:	c9                   	leave  
  801c92:	c3                   	ret    

00801c93 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c93:	55                   	push   %ebp
  801c94:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c96:	6a 00                	push   $0x0
  801c98:	6a 00                	push   $0x0
  801c9a:	6a 00                	push   $0x0
  801c9c:	6a 00                	push   $0x0
  801c9e:	6a 00                	push   $0x0
  801ca0:	6a 02                	push   $0x2
  801ca2:	e8 39 fc ff ff       	call   8018e0 <syscall>
  801ca7:	83 c4 18             	add    $0x18,%esp
}
  801caa:	c9                   	leave  
  801cab:	c3                   	ret    

00801cac <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801cac:	55                   	push   %ebp
  801cad:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801caf:	6a 00                	push   $0x0
  801cb1:	6a 00                	push   $0x0
  801cb3:	6a 00                	push   $0x0
  801cb5:	6a 00                	push   $0x0
  801cb7:	6a 00                	push   $0x0
  801cb9:	6a 03                	push   $0x3
  801cbb:	e8 20 fc ff ff       	call   8018e0 <syscall>
  801cc0:	83 c4 18             	add    $0x18,%esp
}
  801cc3:	c9                   	leave  
  801cc4:	c3                   	ret    

00801cc5 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801cc5:	55                   	push   %ebp
  801cc6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801cc8:	6a 00                	push   $0x0
  801cca:	6a 00                	push   $0x0
  801ccc:	6a 00                	push   $0x0
  801cce:	6a 00                	push   $0x0
  801cd0:	6a 00                	push   $0x0
  801cd2:	6a 04                	push   $0x4
  801cd4:	e8 07 fc ff ff       	call   8018e0 <syscall>
  801cd9:	83 c4 18             	add    $0x18,%esp
}
  801cdc:	c9                   	leave  
  801cdd:	c3                   	ret    

00801cde <sys_exit_env>:


void sys_exit_env(void)
{
  801cde:	55                   	push   %ebp
  801cdf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801ce1:	6a 00                	push   $0x0
  801ce3:	6a 00                	push   $0x0
  801ce5:	6a 00                	push   $0x0
  801ce7:	6a 00                	push   $0x0
  801ce9:	6a 00                	push   $0x0
  801ceb:	6a 23                	push   $0x23
  801ced:	e8 ee fb ff ff       	call   8018e0 <syscall>
  801cf2:	83 c4 18             	add    $0x18,%esp
}
  801cf5:	90                   	nop
  801cf6:	c9                   	leave  
  801cf7:	c3                   	ret    

00801cf8 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801cf8:	55                   	push   %ebp
  801cf9:	89 e5                	mov    %esp,%ebp
  801cfb:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801cfe:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d01:	8d 50 04             	lea    0x4(%eax),%edx
  801d04:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d07:	6a 00                	push   $0x0
  801d09:	6a 00                	push   $0x0
  801d0b:	6a 00                	push   $0x0
  801d0d:	52                   	push   %edx
  801d0e:	50                   	push   %eax
  801d0f:	6a 24                	push   $0x24
  801d11:	e8 ca fb ff ff       	call   8018e0 <syscall>
  801d16:	83 c4 18             	add    $0x18,%esp
	return result;
  801d19:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d1c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d1f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d22:	89 01                	mov    %eax,(%ecx)
  801d24:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801d27:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2a:	c9                   	leave  
  801d2b:	c2 04 00             	ret    $0x4

00801d2e <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d2e:	55                   	push   %ebp
  801d2f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d31:	6a 00                	push   $0x0
  801d33:	6a 00                	push   $0x0
  801d35:	ff 75 10             	pushl  0x10(%ebp)
  801d38:	ff 75 0c             	pushl  0xc(%ebp)
  801d3b:	ff 75 08             	pushl  0x8(%ebp)
  801d3e:	6a 12                	push   $0x12
  801d40:	e8 9b fb ff ff       	call   8018e0 <syscall>
  801d45:	83 c4 18             	add    $0x18,%esp
	return ;
  801d48:	90                   	nop
}
  801d49:	c9                   	leave  
  801d4a:	c3                   	ret    

00801d4b <sys_rcr2>:
uint32 sys_rcr2()
{
  801d4b:	55                   	push   %ebp
  801d4c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d4e:	6a 00                	push   $0x0
  801d50:	6a 00                	push   $0x0
  801d52:	6a 00                	push   $0x0
  801d54:	6a 00                	push   $0x0
  801d56:	6a 00                	push   $0x0
  801d58:	6a 25                	push   $0x25
  801d5a:	e8 81 fb ff ff       	call   8018e0 <syscall>
  801d5f:	83 c4 18             	add    $0x18,%esp
}
  801d62:	c9                   	leave  
  801d63:	c3                   	ret    

00801d64 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801d64:	55                   	push   %ebp
  801d65:	89 e5                	mov    %esp,%ebp
  801d67:	83 ec 04             	sub    $0x4,%esp
  801d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d70:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d74:	6a 00                	push   $0x0
  801d76:	6a 00                	push   $0x0
  801d78:	6a 00                	push   $0x0
  801d7a:	6a 00                	push   $0x0
  801d7c:	50                   	push   %eax
  801d7d:	6a 26                	push   $0x26
  801d7f:	e8 5c fb ff ff       	call   8018e0 <syscall>
  801d84:	83 c4 18             	add    $0x18,%esp
	return ;
  801d87:	90                   	nop
}
  801d88:	c9                   	leave  
  801d89:	c3                   	ret    

00801d8a <rsttst>:
void rsttst()
{
  801d8a:	55                   	push   %ebp
  801d8b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d8d:	6a 00                	push   $0x0
  801d8f:	6a 00                	push   $0x0
  801d91:	6a 00                	push   $0x0
  801d93:	6a 00                	push   $0x0
  801d95:	6a 00                	push   $0x0
  801d97:	6a 28                	push   $0x28
  801d99:	e8 42 fb ff ff       	call   8018e0 <syscall>
  801d9e:	83 c4 18             	add    $0x18,%esp
	return ;
  801da1:	90                   	nop
}
  801da2:	c9                   	leave  
  801da3:	c3                   	ret    

00801da4 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801da4:	55                   	push   %ebp
  801da5:	89 e5                	mov    %esp,%ebp
  801da7:	83 ec 04             	sub    $0x4,%esp
  801daa:	8b 45 14             	mov    0x14(%ebp),%eax
  801dad:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801db0:	8b 55 18             	mov    0x18(%ebp),%edx
  801db3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801db7:	52                   	push   %edx
  801db8:	50                   	push   %eax
  801db9:	ff 75 10             	pushl  0x10(%ebp)
  801dbc:	ff 75 0c             	pushl  0xc(%ebp)
  801dbf:	ff 75 08             	pushl  0x8(%ebp)
  801dc2:	6a 27                	push   $0x27
  801dc4:	e8 17 fb ff ff       	call   8018e0 <syscall>
  801dc9:	83 c4 18             	add    $0x18,%esp
	return ;
  801dcc:	90                   	nop
}
  801dcd:	c9                   	leave  
  801dce:	c3                   	ret    

00801dcf <chktst>:
void chktst(uint32 n)
{
  801dcf:	55                   	push   %ebp
  801dd0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801dd2:	6a 00                	push   $0x0
  801dd4:	6a 00                	push   $0x0
  801dd6:	6a 00                	push   $0x0
  801dd8:	6a 00                	push   $0x0
  801dda:	ff 75 08             	pushl  0x8(%ebp)
  801ddd:	6a 29                	push   $0x29
  801ddf:	e8 fc fa ff ff       	call   8018e0 <syscall>
  801de4:	83 c4 18             	add    $0x18,%esp
	return ;
  801de7:	90                   	nop
}
  801de8:	c9                   	leave  
  801de9:	c3                   	ret    

00801dea <inctst>:

void inctst()
{
  801dea:	55                   	push   %ebp
  801deb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801ded:	6a 00                	push   $0x0
  801def:	6a 00                	push   $0x0
  801df1:	6a 00                	push   $0x0
  801df3:	6a 00                	push   $0x0
  801df5:	6a 00                	push   $0x0
  801df7:	6a 2a                	push   $0x2a
  801df9:	e8 e2 fa ff ff       	call   8018e0 <syscall>
  801dfe:	83 c4 18             	add    $0x18,%esp
	return ;
  801e01:	90                   	nop
}
  801e02:	c9                   	leave  
  801e03:	c3                   	ret    

00801e04 <gettst>:
uint32 gettst()
{
  801e04:	55                   	push   %ebp
  801e05:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801e07:	6a 00                	push   $0x0
  801e09:	6a 00                	push   $0x0
  801e0b:	6a 00                	push   $0x0
  801e0d:	6a 00                	push   $0x0
  801e0f:	6a 00                	push   $0x0
  801e11:	6a 2b                	push   $0x2b
  801e13:	e8 c8 fa ff ff       	call   8018e0 <syscall>
  801e18:	83 c4 18             	add    $0x18,%esp
}
  801e1b:	c9                   	leave  
  801e1c:	c3                   	ret    

00801e1d <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801e1d:	55                   	push   %ebp
  801e1e:	89 e5                	mov    %esp,%ebp
  801e20:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e23:	6a 00                	push   $0x0
  801e25:	6a 00                	push   $0x0
  801e27:	6a 00                	push   $0x0
  801e29:	6a 00                	push   $0x0
  801e2b:	6a 00                	push   $0x0
  801e2d:	6a 2c                	push   $0x2c
  801e2f:	e8 ac fa ff ff       	call   8018e0 <syscall>
  801e34:	83 c4 18             	add    $0x18,%esp
  801e37:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801e3a:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e3e:	75 07                	jne    801e47 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e40:	b8 01 00 00 00       	mov    $0x1,%eax
  801e45:	eb 05                	jmp    801e4c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e47:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e4c:	c9                   	leave  
  801e4d:	c3                   	ret    

00801e4e <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e4e:	55                   	push   %ebp
  801e4f:	89 e5                	mov    %esp,%ebp
  801e51:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e54:	6a 00                	push   $0x0
  801e56:	6a 00                	push   $0x0
  801e58:	6a 00                	push   $0x0
  801e5a:	6a 00                	push   $0x0
  801e5c:	6a 00                	push   $0x0
  801e5e:	6a 2c                	push   $0x2c
  801e60:	e8 7b fa ff ff       	call   8018e0 <syscall>
  801e65:	83 c4 18             	add    $0x18,%esp
  801e68:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e6b:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e6f:	75 07                	jne    801e78 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e71:	b8 01 00 00 00       	mov    $0x1,%eax
  801e76:	eb 05                	jmp    801e7d <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e78:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e7d:	c9                   	leave  
  801e7e:	c3                   	ret    

00801e7f <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e7f:	55                   	push   %ebp
  801e80:	89 e5                	mov    %esp,%ebp
  801e82:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e85:	6a 00                	push   $0x0
  801e87:	6a 00                	push   $0x0
  801e89:	6a 00                	push   $0x0
  801e8b:	6a 00                	push   $0x0
  801e8d:	6a 00                	push   $0x0
  801e8f:	6a 2c                	push   $0x2c
  801e91:	e8 4a fa ff ff       	call   8018e0 <syscall>
  801e96:	83 c4 18             	add    $0x18,%esp
  801e99:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e9c:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801ea0:	75 07                	jne    801ea9 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801ea2:	b8 01 00 00 00       	mov    $0x1,%eax
  801ea7:	eb 05                	jmp    801eae <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801ea9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eae:	c9                   	leave  
  801eaf:	c3                   	ret    

00801eb0 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801eb0:	55                   	push   %ebp
  801eb1:	89 e5                	mov    %esp,%ebp
  801eb3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801eb6:	6a 00                	push   $0x0
  801eb8:	6a 00                	push   $0x0
  801eba:	6a 00                	push   $0x0
  801ebc:	6a 00                	push   $0x0
  801ebe:	6a 00                	push   $0x0
  801ec0:	6a 2c                	push   $0x2c
  801ec2:	e8 19 fa ff ff       	call   8018e0 <syscall>
  801ec7:	83 c4 18             	add    $0x18,%esp
  801eca:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801ecd:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801ed1:	75 07                	jne    801eda <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801ed3:	b8 01 00 00 00       	mov    $0x1,%eax
  801ed8:	eb 05                	jmp    801edf <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801eda:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801edf:	c9                   	leave  
  801ee0:	c3                   	ret    

00801ee1 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801ee1:	55                   	push   %ebp
  801ee2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801ee4:	6a 00                	push   $0x0
  801ee6:	6a 00                	push   $0x0
  801ee8:	6a 00                	push   $0x0
  801eea:	6a 00                	push   $0x0
  801eec:	ff 75 08             	pushl  0x8(%ebp)
  801eef:	6a 2d                	push   $0x2d
  801ef1:	e8 ea f9 ff ff       	call   8018e0 <syscall>
  801ef6:	83 c4 18             	add    $0x18,%esp
	return ;
  801ef9:	90                   	nop
}
  801efa:	c9                   	leave  
  801efb:	c3                   	ret    

00801efc <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801efc:	55                   	push   %ebp
  801efd:	89 e5                	mov    %esp,%ebp
  801eff:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801f00:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f03:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f06:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f09:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0c:	6a 00                	push   $0x0
  801f0e:	53                   	push   %ebx
  801f0f:	51                   	push   %ecx
  801f10:	52                   	push   %edx
  801f11:	50                   	push   %eax
  801f12:	6a 2e                	push   $0x2e
  801f14:	e8 c7 f9 ff ff       	call   8018e0 <syscall>
  801f19:	83 c4 18             	add    $0x18,%esp
}
  801f1c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f1f:	c9                   	leave  
  801f20:	c3                   	ret    

00801f21 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801f21:	55                   	push   %ebp
  801f22:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801f24:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f27:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2a:	6a 00                	push   $0x0
  801f2c:	6a 00                	push   $0x0
  801f2e:	6a 00                	push   $0x0
  801f30:	52                   	push   %edx
  801f31:	50                   	push   %eax
  801f32:	6a 2f                	push   $0x2f
  801f34:	e8 a7 f9 ff ff       	call   8018e0 <syscall>
  801f39:	83 c4 18             	add    $0x18,%esp
}
  801f3c:	c9                   	leave  
  801f3d:	c3                   	ret    

00801f3e <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801f3e:	55                   	push   %ebp
  801f3f:	89 e5                	mov    %esp,%ebp
  801f41:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801f44:	83 ec 0c             	sub    $0xc,%esp
  801f47:	68 08 42 80 00       	push   $0x804208
  801f4c:	e8 1e e8 ff ff       	call   80076f <cprintf>
  801f51:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801f54:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801f5b:	83 ec 0c             	sub    $0xc,%esp
  801f5e:	68 34 42 80 00       	push   $0x804234
  801f63:	e8 07 e8 ff ff       	call   80076f <cprintf>
  801f68:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801f6b:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f6f:	a1 38 51 80 00       	mov    0x805138,%eax
  801f74:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f77:	eb 56                	jmp    801fcf <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f79:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f7d:	74 1c                	je     801f9b <print_mem_block_lists+0x5d>
  801f7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f82:	8b 50 08             	mov    0x8(%eax),%edx
  801f85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f88:	8b 48 08             	mov    0x8(%eax),%ecx
  801f8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f8e:	8b 40 0c             	mov    0xc(%eax),%eax
  801f91:	01 c8                	add    %ecx,%eax
  801f93:	39 c2                	cmp    %eax,%edx
  801f95:	73 04                	jae    801f9b <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801f97:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f9e:	8b 50 08             	mov    0x8(%eax),%edx
  801fa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa4:	8b 40 0c             	mov    0xc(%eax),%eax
  801fa7:	01 c2                	add    %eax,%edx
  801fa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fac:	8b 40 08             	mov    0x8(%eax),%eax
  801faf:	83 ec 04             	sub    $0x4,%esp
  801fb2:	52                   	push   %edx
  801fb3:	50                   	push   %eax
  801fb4:	68 49 42 80 00       	push   $0x804249
  801fb9:	e8 b1 e7 ff ff       	call   80076f <cprintf>
  801fbe:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801fc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801fc7:	a1 40 51 80 00       	mov    0x805140,%eax
  801fcc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fcf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fd3:	74 07                	je     801fdc <print_mem_block_lists+0x9e>
  801fd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd8:	8b 00                	mov    (%eax),%eax
  801fda:	eb 05                	jmp    801fe1 <print_mem_block_lists+0xa3>
  801fdc:	b8 00 00 00 00       	mov    $0x0,%eax
  801fe1:	a3 40 51 80 00       	mov    %eax,0x805140
  801fe6:	a1 40 51 80 00       	mov    0x805140,%eax
  801feb:	85 c0                	test   %eax,%eax
  801fed:	75 8a                	jne    801f79 <print_mem_block_lists+0x3b>
  801fef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ff3:	75 84                	jne    801f79 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801ff5:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801ff9:	75 10                	jne    80200b <print_mem_block_lists+0xcd>
  801ffb:	83 ec 0c             	sub    $0xc,%esp
  801ffe:	68 58 42 80 00       	push   $0x804258
  802003:	e8 67 e7 ff ff       	call   80076f <cprintf>
  802008:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80200b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802012:	83 ec 0c             	sub    $0xc,%esp
  802015:	68 7c 42 80 00       	push   $0x80427c
  80201a:	e8 50 e7 ff ff       	call   80076f <cprintf>
  80201f:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802022:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802026:	a1 40 50 80 00       	mov    0x805040,%eax
  80202b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80202e:	eb 56                	jmp    802086 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802030:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802034:	74 1c                	je     802052 <print_mem_block_lists+0x114>
  802036:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802039:	8b 50 08             	mov    0x8(%eax),%edx
  80203c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80203f:	8b 48 08             	mov    0x8(%eax),%ecx
  802042:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802045:	8b 40 0c             	mov    0xc(%eax),%eax
  802048:	01 c8                	add    %ecx,%eax
  80204a:	39 c2                	cmp    %eax,%edx
  80204c:	73 04                	jae    802052 <print_mem_block_lists+0x114>
			sorted = 0 ;
  80204e:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802052:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802055:	8b 50 08             	mov    0x8(%eax),%edx
  802058:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80205b:	8b 40 0c             	mov    0xc(%eax),%eax
  80205e:	01 c2                	add    %eax,%edx
  802060:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802063:	8b 40 08             	mov    0x8(%eax),%eax
  802066:	83 ec 04             	sub    $0x4,%esp
  802069:	52                   	push   %edx
  80206a:	50                   	push   %eax
  80206b:	68 49 42 80 00       	push   $0x804249
  802070:	e8 fa e6 ff ff       	call   80076f <cprintf>
  802075:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802078:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80207b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80207e:	a1 48 50 80 00       	mov    0x805048,%eax
  802083:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802086:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80208a:	74 07                	je     802093 <print_mem_block_lists+0x155>
  80208c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80208f:	8b 00                	mov    (%eax),%eax
  802091:	eb 05                	jmp    802098 <print_mem_block_lists+0x15a>
  802093:	b8 00 00 00 00       	mov    $0x0,%eax
  802098:	a3 48 50 80 00       	mov    %eax,0x805048
  80209d:	a1 48 50 80 00       	mov    0x805048,%eax
  8020a2:	85 c0                	test   %eax,%eax
  8020a4:	75 8a                	jne    802030 <print_mem_block_lists+0xf2>
  8020a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020aa:	75 84                	jne    802030 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8020ac:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8020b0:	75 10                	jne    8020c2 <print_mem_block_lists+0x184>
  8020b2:	83 ec 0c             	sub    $0xc,%esp
  8020b5:	68 94 42 80 00       	push   $0x804294
  8020ba:	e8 b0 e6 ff ff       	call   80076f <cprintf>
  8020bf:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8020c2:	83 ec 0c             	sub    $0xc,%esp
  8020c5:	68 08 42 80 00       	push   $0x804208
  8020ca:	e8 a0 e6 ff ff       	call   80076f <cprintf>
  8020cf:	83 c4 10             	add    $0x10,%esp

}
  8020d2:	90                   	nop
  8020d3:	c9                   	leave  
  8020d4:	c3                   	ret    

008020d5 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8020d5:	55                   	push   %ebp
  8020d6:	89 e5                	mov    %esp,%ebp
  8020d8:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  8020db:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8020e2:	00 00 00 
  8020e5:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8020ec:	00 00 00 
  8020ef:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8020f6:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  8020f9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802100:	e9 9e 00 00 00       	jmp    8021a3 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802105:	a1 50 50 80 00       	mov    0x805050,%eax
  80210a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80210d:	c1 e2 04             	shl    $0x4,%edx
  802110:	01 d0                	add    %edx,%eax
  802112:	85 c0                	test   %eax,%eax
  802114:	75 14                	jne    80212a <initialize_MemBlocksList+0x55>
  802116:	83 ec 04             	sub    $0x4,%esp
  802119:	68 bc 42 80 00       	push   $0x8042bc
  80211e:	6a 46                	push   $0x46
  802120:	68 df 42 80 00       	push   $0x8042df
  802125:	e8 91 e3 ff ff       	call   8004bb <_panic>
  80212a:	a1 50 50 80 00       	mov    0x805050,%eax
  80212f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802132:	c1 e2 04             	shl    $0x4,%edx
  802135:	01 d0                	add    %edx,%eax
  802137:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80213d:	89 10                	mov    %edx,(%eax)
  80213f:	8b 00                	mov    (%eax),%eax
  802141:	85 c0                	test   %eax,%eax
  802143:	74 18                	je     80215d <initialize_MemBlocksList+0x88>
  802145:	a1 48 51 80 00       	mov    0x805148,%eax
  80214a:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802150:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802153:	c1 e1 04             	shl    $0x4,%ecx
  802156:	01 ca                	add    %ecx,%edx
  802158:	89 50 04             	mov    %edx,0x4(%eax)
  80215b:	eb 12                	jmp    80216f <initialize_MemBlocksList+0x9a>
  80215d:	a1 50 50 80 00       	mov    0x805050,%eax
  802162:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802165:	c1 e2 04             	shl    $0x4,%edx
  802168:	01 d0                	add    %edx,%eax
  80216a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80216f:	a1 50 50 80 00       	mov    0x805050,%eax
  802174:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802177:	c1 e2 04             	shl    $0x4,%edx
  80217a:	01 d0                	add    %edx,%eax
  80217c:	a3 48 51 80 00       	mov    %eax,0x805148
  802181:	a1 50 50 80 00       	mov    0x805050,%eax
  802186:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802189:	c1 e2 04             	shl    $0x4,%edx
  80218c:	01 d0                	add    %edx,%eax
  80218e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802195:	a1 54 51 80 00       	mov    0x805154,%eax
  80219a:	40                   	inc    %eax
  80219b:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  8021a0:	ff 45 f4             	incl   -0xc(%ebp)
  8021a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8021a9:	0f 82 56 ff ff ff    	jb     802105 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  8021af:	90                   	nop
  8021b0:	c9                   	leave  
  8021b1:	c3                   	ret    

008021b2 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8021b2:	55                   	push   %ebp
  8021b3:	89 e5                	mov    %esp,%ebp
  8021b5:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8021b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bb:	8b 00                	mov    (%eax),%eax
  8021bd:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8021c0:	eb 19                	jmp    8021db <find_block+0x29>
	{
		if(va==point->sva)
  8021c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021c5:	8b 40 08             	mov    0x8(%eax),%eax
  8021c8:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8021cb:	75 05                	jne    8021d2 <find_block+0x20>
		   return point;
  8021cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021d0:	eb 36                	jmp    802208 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8021d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d5:	8b 40 08             	mov    0x8(%eax),%eax
  8021d8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8021db:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021df:	74 07                	je     8021e8 <find_block+0x36>
  8021e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021e4:	8b 00                	mov    (%eax),%eax
  8021e6:	eb 05                	jmp    8021ed <find_block+0x3b>
  8021e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8021ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8021f0:	89 42 08             	mov    %eax,0x8(%edx)
  8021f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f6:	8b 40 08             	mov    0x8(%eax),%eax
  8021f9:	85 c0                	test   %eax,%eax
  8021fb:	75 c5                	jne    8021c2 <find_block+0x10>
  8021fd:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802201:	75 bf                	jne    8021c2 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802203:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802208:	c9                   	leave  
  802209:	c3                   	ret    

0080220a <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80220a:	55                   	push   %ebp
  80220b:	89 e5                	mov    %esp,%ebp
  80220d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802210:	a1 40 50 80 00       	mov    0x805040,%eax
  802215:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802218:	a1 44 50 80 00       	mov    0x805044,%eax
  80221d:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802220:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802223:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802226:	74 24                	je     80224c <insert_sorted_allocList+0x42>
  802228:	8b 45 08             	mov    0x8(%ebp),%eax
  80222b:	8b 50 08             	mov    0x8(%eax),%edx
  80222e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802231:	8b 40 08             	mov    0x8(%eax),%eax
  802234:	39 c2                	cmp    %eax,%edx
  802236:	76 14                	jbe    80224c <insert_sorted_allocList+0x42>
  802238:	8b 45 08             	mov    0x8(%ebp),%eax
  80223b:	8b 50 08             	mov    0x8(%eax),%edx
  80223e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802241:	8b 40 08             	mov    0x8(%eax),%eax
  802244:	39 c2                	cmp    %eax,%edx
  802246:	0f 82 60 01 00 00    	jb     8023ac <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  80224c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802250:	75 65                	jne    8022b7 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802252:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802256:	75 14                	jne    80226c <insert_sorted_allocList+0x62>
  802258:	83 ec 04             	sub    $0x4,%esp
  80225b:	68 bc 42 80 00       	push   $0x8042bc
  802260:	6a 6b                	push   $0x6b
  802262:	68 df 42 80 00       	push   $0x8042df
  802267:	e8 4f e2 ff ff       	call   8004bb <_panic>
  80226c:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802272:	8b 45 08             	mov    0x8(%ebp),%eax
  802275:	89 10                	mov    %edx,(%eax)
  802277:	8b 45 08             	mov    0x8(%ebp),%eax
  80227a:	8b 00                	mov    (%eax),%eax
  80227c:	85 c0                	test   %eax,%eax
  80227e:	74 0d                	je     80228d <insert_sorted_allocList+0x83>
  802280:	a1 40 50 80 00       	mov    0x805040,%eax
  802285:	8b 55 08             	mov    0x8(%ebp),%edx
  802288:	89 50 04             	mov    %edx,0x4(%eax)
  80228b:	eb 08                	jmp    802295 <insert_sorted_allocList+0x8b>
  80228d:	8b 45 08             	mov    0x8(%ebp),%eax
  802290:	a3 44 50 80 00       	mov    %eax,0x805044
  802295:	8b 45 08             	mov    0x8(%ebp),%eax
  802298:	a3 40 50 80 00       	mov    %eax,0x805040
  80229d:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022a7:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8022ac:	40                   	inc    %eax
  8022ad:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8022b2:	e9 dc 01 00 00       	jmp    802493 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8022b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ba:	8b 50 08             	mov    0x8(%eax),%edx
  8022bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022c0:	8b 40 08             	mov    0x8(%eax),%eax
  8022c3:	39 c2                	cmp    %eax,%edx
  8022c5:	77 6c                	ja     802333 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8022c7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022cb:	74 06                	je     8022d3 <insert_sorted_allocList+0xc9>
  8022cd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022d1:	75 14                	jne    8022e7 <insert_sorted_allocList+0xdd>
  8022d3:	83 ec 04             	sub    $0x4,%esp
  8022d6:	68 f8 42 80 00       	push   $0x8042f8
  8022db:	6a 6f                	push   $0x6f
  8022dd:	68 df 42 80 00       	push   $0x8042df
  8022e2:	e8 d4 e1 ff ff       	call   8004bb <_panic>
  8022e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022ea:	8b 50 04             	mov    0x4(%eax),%edx
  8022ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f0:	89 50 04             	mov    %edx,0x4(%eax)
  8022f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022f9:	89 10                	mov    %edx,(%eax)
  8022fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022fe:	8b 40 04             	mov    0x4(%eax),%eax
  802301:	85 c0                	test   %eax,%eax
  802303:	74 0d                	je     802312 <insert_sorted_allocList+0x108>
  802305:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802308:	8b 40 04             	mov    0x4(%eax),%eax
  80230b:	8b 55 08             	mov    0x8(%ebp),%edx
  80230e:	89 10                	mov    %edx,(%eax)
  802310:	eb 08                	jmp    80231a <insert_sorted_allocList+0x110>
  802312:	8b 45 08             	mov    0x8(%ebp),%eax
  802315:	a3 40 50 80 00       	mov    %eax,0x805040
  80231a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80231d:	8b 55 08             	mov    0x8(%ebp),%edx
  802320:	89 50 04             	mov    %edx,0x4(%eax)
  802323:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802328:	40                   	inc    %eax
  802329:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80232e:	e9 60 01 00 00       	jmp    802493 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802333:	8b 45 08             	mov    0x8(%ebp),%eax
  802336:	8b 50 08             	mov    0x8(%eax),%edx
  802339:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80233c:	8b 40 08             	mov    0x8(%eax),%eax
  80233f:	39 c2                	cmp    %eax,%edx
  802341:	0f 82 4c 01 00 00    	jb     802493 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802347:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80234b:	75 14                	jne    802361 <insert_sorted_allocList+0x157>
  80234d:	83 ec 04             	sub    $0x4,%esp
  802350:	68 30 43 80 00       	push   $0x804330
  802355:	6a 73                	push   $0x73
  802357:	68 df 42 80 00       	push   $0x8042df
  80235c:	e8 5a e1 ff ff       	call   8004bb <_panic>
  802361:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802367:	8b 45 08             	mov    0x8(%ebp),%eax
  80236a:	89 50 04             	mov    %edx,0x4(%eax)
  80236d:	8b 45 08             	mov    0x8(%ebp),%eax
  802370:	8b 40 04             	mov    0x4(%eax),%eax
  802373:	85 c0                	test   %eax,%eax
  802375:	74 0c                	je     802383 <insert_sorted_allocList+0x179>
  802377:	a1 44 50 80 00       	mov    0x805044,%eax
  80237c:	8b 55 08             	mov    0x8(%ebp),%edx
  80237f:	89 10                	mov    %edx,(%eax)
  802381:	eb 08                	jmp    80238b <insert_sorted_allocList+0x181>
  802383:	8b 45 08             	mov    0x8(%ebp),%eax
  802386:	a3 40 50 80 00       	mov    %eax,0x805040
  80238b:	8b 45 08             	mov    0x8(%ebp),%eax
  80238e:	a3 44 50 80 00       	mov    %eax,0x805044
  802393:	8b 45 08             	mov    0x8(%ebp),%eax
  802396:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80239c:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8023a1:	40                   	inc    %eax
  8023a2:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8023a7:	e9 e7 00 00 00       	jmp    802493 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8023ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023af:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8023b2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8023b9:	a1 40 50 80 00       	mov    0x805040,%eax
  8023be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023c1:	e9 9d 00 00 00       	jmp    802463 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8023c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c9:	8b 00                	mov    (%eax),%eax
  8023cb:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8023ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d1:	8b 50 08             	mov    0x8(%eax),%edx
  8023d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d7:	8b 40 08             	mov    0x8(%eax),%eax
  8023da:	39 c2                	cmp    %eax,%edx
  8023dc:	76 7d                	jbe    80245b <insert_sorted_allocList+0x251>
  8023de:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e1:	8b 50 08             	mov    0x8(%eax),%edx
  8023e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8023e7:	8b 40 08             	mov    0x8(%eax),%eax
  8023ea:	39 c2                	cmp    %eax,%edx
  8023ec:	73 6d                	jae    80245b <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8023ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023f2:	74 06                	je     8023fa <insert_sorted_allocList+0x1f0>
  8023f4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023f8:	75 14                	jne    80240e <insert_sorted_allocList+0x204>
  8023fa:	83 ec 04             	sub    $0x4,%esp
  8023fd:	68 54 43 80 00       	push   $0x804354
  802402:	6a 7f                	push   $0x7f
  802404:	68 df 42 80 00       	push   $0x8042df
  802409:	e8 ad e0 ff ff       	call   8004bb <_panic>
  80240e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802411:	8b 10                	mov    (%eax),%edx
  802413:	8b 45 08             	mov    0x8(%ebp),%eax
  802416:	89 10                	mov    %edx,(%eax)
  802418:	8b 45 08             	mov    0x8(%ebp),%eax
  80241b:	8b 00                	mov    (%eax),%eax
  80241d:	85 c0                	test   %eax,%eax
  80241f:	74 0b                	je     80242c <insert_sorted_allocList+0x222>
  802421:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802424:	8b 00                	mov    (%eax),%eax
  802426:	8b 55 08             	mov    0x8(%ebp),%edx
  802429:	89 50 04             	mov    %edx,0x4(%eax)
  80242c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242f:	8b 55 08             	mov    0x8(%ebp),%edx
  802432:	89 10                	mov    %edx,(%eax)
  802434:	8b 45 08             	mov    0x8(%ebp),%eax
  802437:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80243a:	89 50 04             	mov    %edx,0x4(%eax)
  80243d:	8b 45 08             	mov    0x8(%ebp),%eax
  802440:	8b 00                	mov    (%eax),%eax
  802442:	85 c0                	test   %eax,%eax
  802444:	75 08                	jne    80244e <insert_sorted_allocList+0x244>
  802446:	8b 45 08             	mov    0x8(%ebp),%eax
  802449:	a3 44 50 80 00       	mov    %eax,0x805044
  80244e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802453:	40                   	inc    %eax
  802454:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802459:	eb 39                	jmp    802494 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80245b:	a1 48 50 80 00       	mov    0x805048,%eax
  802460:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802463:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802467:	74 07                	je     802470 <insert_sorted_allocList+0x266>
  802469:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246c:	8b 00                	mov    (%eax),%eax
  80246e:	eb 05                	jmp    802475 <insert_sorted_allocList+0x26b>
  802470:	b8 00 00 00 00       	mov    $0x0,%eax
  802475:	a3 48 50 80 00       	mov    %eax,0x805048
  80247a:	a1 48 50 80 00       	mov    0x805048,%eax
  80247f:	85 c0                	test   %eax,%eax
  802481:	0f 85 3f ff ff ff    	jne    8023c6 <insert_sorted_allocList+0x1bc>
  802487:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80248b:	0f 85 35 ff ff ff    	jne    8023c6 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802491:	eb 01                	jmp    802494 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802493:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802494:	90                   	nop
  802495:	c9                   	leave  
  802496:	c3                   	ret    

00802497 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802497:	55                   	push   %ebp
  802498:	89 e5                	mov    %esp,%ebp
  80249a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80249d:	a1 38 51 80 00       	mov    0x805138,%eax
  8024a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024a5:	e9 85 01 00 00       	jmp    80262f <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8024aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ad:	8b 40 0c             	mov    0xc(%eax),%eax
  8024b0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024b3:	0f 82 6e 01 00 00    	jb     802627 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8024b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024bc:	8b 40 0c             	mov    0xc(%eax),%eax
  8024bf:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024c2:	0f 85 8a 00 00 00    	jne    802552 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8024c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024cc:	75 17                	jne    8024e5 <alloc_block_FF+0x4e>
  8024ce:	83 ec 04             	sub    $0x4,%esp
  8024d1:	68 88 43 80 00       	push   $0x804388
  8024d6:	68 93 00 00 00       	push   $0x93
  8024db:	68 df 42 80 00       	push   $0x8042df
  8024e0:	e8 d6 df ff ff       	call   8004bb <_panic>
  8024e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e8:	8b 00                	mov    (%eax),%eax
  8024ea:	85 c0                	test   %eax,%eax
  8024ec:	74 10                	je     8024fe <alloc_block_FF+0x67>
  8024ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f1:	8b 00                	mov    (%eax),%eax
  8024f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024f6:	8b 52 04             	mov    0x4(%edx),%edx
  8024f9:	89 50 04             	mov    %edx,0x4(%eax)
  8024fc:	eb 0b                	jmp    802509 <alloc_block_FF+0x72>
  8024fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802501:	8b 40 04             	mov    0x4(%eax),%eax
  802504:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802509:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250c:	8b 40 04             	mov    0x4(%eax),%eax
  80250f:	85 c0                	test   %eax,%eax
  802511:	74 0f                	je     802522 <alloc_block_FF+0x8b>
  802513:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802516:	8b 40 04             	mov    0x4(%eax),%eax
  802519:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80251c:	8b 12                	mov    (%edx),%edx
  80251e:	89 10                	mov    %edx,(%eax)
  802520:	eb 0a                	jmp    80252c <alloc_block_FF+0x95>
  802522:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802525:	8b 00                	mov    (%eax),%eax
  802527:	a3 38 51 80 00       	mov    %eax,0x805138
  80252c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802535:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802538:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80253f:	a1 44 51 80 00       	mov    0x805144,%eax
  802544:	48                   	dec    %eax
  802545:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  80254a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254d:	e9 10 01 00 00       	jmp    802662 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802552:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802555:	8b 40 0c             	mov    0xc(%eax),%eax
  802558:	3b 45 08             	cmp    0x8(%ebp),%eax
  80255b:	0f 86 c6 00 00 00    	jbe    802627 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802561:	a1 48 51 80 00       	mov    0x805148,%eax
  802566:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802569:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256c:	8b 50 08             	mov    0x8(%eax),%edx
  80256f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802572:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802575:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802578:	8b 55 08             	mov    0x8(%ebp),%edx
  80257b:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80257e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802582:	75 17                	jne    80259b <alloc_block_FF+0x104>
  802584:	83 ec 04             	sub    $0x4,%esp
  802587:	68 88 43 80 00       	push   $0x804388
  80258c:	68 9b 00 00 00       	push   $0x9b
  802591:	68 df 42 80 00       	push   $0x8042df
  802596:	e8 20 df ff ff       	call   8004bb <_panic>
  80259b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80259e:	8b 00                	mov    (%eax),%eax
  8025a0:	85 c0                	test   %eax,%eax
  8025a2:	74 10                	je     8025b4 <alloc_block_FF+0x11d>
  8025a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025a7:	8b 00                	mov    (%eax),%eax
  8025a9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025ac:	8b 52 04             	mov    0x4(%edx),%edx
  8025af:	89 50 04             	mov    %edx,0x4(%eax)
  8025b2:	eb 0b                	jmp    8025bf <alloc_block_FF+0x128>
  8025b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025b7:	8b 40 04             	mov    0x4(%eax),%eax
  8025ba:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8025bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025c2:	8b 40 04             	mov    0x4(%eax),%eax
  8025c5:	85 c0                	test   %eax,%eax
  8025c7:	74 0f                	je     8025d8 <alloc_block_FF+0x141>
  8025c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025cc:	8b 40 04             	mov    0x4(%eax),%eax
  8025cf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025d2:	8b 12                	mov    (%edx),%edx
  8025d4:	89 10                	mov    %edx,(%eax)
  8025d6:	eb 0a                	jmp    8025e2 <alloc_block_FF+0x14b>
  8025d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025db:	8b 00                	mov    (%eax),%eax
  8025dd:	a3 48 51 80 00       	mov    %eax,0x805148
  8025e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025e5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025ee:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025f5:	a1 54 51 80 00       	mov    0x805154,%eax
  8025fa:	48                   	dec    %eax
  8025fb:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802600:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802603:	8b 50 08             	mov    0x8(%eax),%edx
  802606:	8b 45 08             	mov    0x8(%ebp),%eax
  802609:	01 c2                	add    %eax,%edx
  80260b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260e:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802611:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802614:	8b 40 0c             	mov    0xc(%eax),%eax
  802617:	2b 45 08             	sub    0x8(%ebp),%eax
  80261a:	89 c2                	mov    %eax,%edx
  80261c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261f:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802622:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802625:	eb 3b                	jmp    802662 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802627:	a1 40 51 80 00       	mov    0x805140,%eax
  80262c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80262f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802633:	74 07                	je     80263c <alloc_block_FF+0x1a5>
  802635:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802638:	8b 00                	mov    (%eax),%eax
  80263a:	eb 05                	jmp    802641 <alloc_block_FF+0x1aa>
  80263c:	b8 00 00 00 00       	mov    $0x0,%eax
  802641:	a3 40 51 80 00       	mov    %eax,0x805140
  802646:	a1 40 51 80 00       	mov    0x805140,%eax
  80264b:	85 c0                	test   %eax,%eax
  80264d:	0f 85 57 fe ff ff    	jne    8024aa <alloc_block_FF+0x13>
  802653:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802657:	0f 85 4d fe ff ff    	jne    8024aa <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  80265d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802662:	c9                   	leave  
  802663:	c3                   	ret    

00802664 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802664:	55                   	push   %ebp
  802665:	89 e5                	mov    %esp,%ebp
  802667:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  80266a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802671:	a1 38 51 80 00       	mov    0x805138,%eax
  802676:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802679:	e9 df 00 00 00       	jmp    80275d <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  80267e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802681:	8b 40 0c             	mov    0xc(%eax),%eax
  802684:	3b 45 08             	cmp    0x8(%ebp),%eax
  802687:	0f 82 c8 00 00 00    	jb     802755 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  80268d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802690:	8b 40 0c             	mov    0xc(%eax),%eax
  802693:	3b 45 08             	cmp    0x8(%ebp),%eax
  802696:	0f 85 8a 00 00 00    	jne    802726 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  80269c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026a0:	75 17                	jne    8026b9 <alloc_block_BF+0x55>
  8026a2:	83 ec 04             	sub    $0x4,%esp
  8026a5:	68 88 43 80 00       	push   $0x804388
  8026aa:	68 b7 00 00 00       	push   $0xb7
  8026af:	68 df 42 80 00       	push   $0x8042df
  8026b4:	e8 02 de ff ff       	call   8004bb <_panic>
  8026b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bc:	8b 00                	mov    (%eax),%eax
  8026be:	85 c0                	test   %eax,%eax
  8026c0:	74 10                	je     8026d2 <alloc_block_BF+0x6e>
  8026c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c5:	8b 00                	mov    (%eax),%eax
  8026c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026ca:	8b 52 04             	mov    0x4(%edx),%edx
  8026cd:	89 50 04             	mov    %edx,0x4(%eax)
  8026d0:	eb 0b                	jmp    8026dd <alloc_block_BF+0x79>
  8026d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d5:	8b 40 04             	mov    0x4(%eax),%eax
  8026d8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8026dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e0:	8b 40 04             	mov    0x4(%eax),%eax
  8026e3:	85 c0                	test   %eax,%eax
  8026e5:	74 0f                	je     8026f6 <alloc_block_BF+0x92>
  8026e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ea:	8b 40 04             	mov    0x4(%eax),%eax
  8026ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026f0:	8b 12                	mov    (%edx),%edx
  8026f2:	89 10                	mov    %edx,(%eax)
  8026f4:	eb 0a                	jmp    802700 <alloc_block_BF+0x9c>
  8026f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f9:	8b 00                	mov    (%eax),%eax
  8026fb:	a3 38 51 80 00       	mov    %eax,0x805138
  802700:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802703:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802709:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802713:	a1 44 51 80 00       	mov    0x805144,%eax
  802718:	48                   	dec    %eax
  802719:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  80271e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802721:	e9 4d 01 00 00       	jmp    802873 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802726:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802729:	8b 40 0c             	mov    0xc(%eax),%eax
  80272c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80272f:	76 24                	jbe    802755 <alloc_block_BF+0xf1>
  802731:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802734:	8b 40 0c             	mov    0xc(%eax),%eax
  802737:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80273a:	73 19                	jae    802755 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  80273c:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802743:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802746:	8b 40 0c             	mov    0xc(%eax),%eax
  802749:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  80274c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274f:	8b 40 08             	mov    0x8(%eax),%eax
  802752:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802755:	a1 40 51 80 00       	mov    0x805140,%eax
  80275a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80275d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802761:	74 07                	je     80276a <alloc_block_BF+0x106>
  802763:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802766:	8b 00                	mov    (%eax),%eax
  802768:	eb 05                	jmp    80276f <alloc_block_BF+0x10b>
  80276a:	b8 00 00 00 00       	mov    $0x0,%eax
  80276f:	a3 40 51 80 00       	mov    %eax,0x805140
  802774:	a1 40 51 80 00       	mov    0x805140,%eax
  802779:	85 c0                	test   %eax,%eax
  80277b:	0f 85 fd fe ff ff    	jne    80267e <alloc_block_BF+0x1a>
  802781:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802785:	0f 85 f3 fe ff ff    	jne    80267e <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  80278b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80278f:	0f 84 d9 00 00 00    	je     80286e <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802795:	a1 48 51 80 00       	mov    0x805148,%eax
  80279a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  80279d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027a0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027a3:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8027a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8027ac:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  8027af:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8027b3:	75 17                	jne    8027cc <alloc_block_BF+0x168>
  8027b5:	83 ec 04             	sub    $0x4,%esp
  8027b8:	68 88 43 80 00       	push   $0x804388
  8027bd:	68 c7 00 00 00       	push   $0xc7
  8027c2:	68 df 42 80 00       	push   $0x8042df
  8027c7:	e8 ef dc ff ff       	call   8004bb <_panic>
  8027cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027cf:	8b 00                	mov    (%eax),%eax
  8027d1:	85 c0                	test   %eax,%eax
  8027d3:	74 10                	je     8027e5 <alloc_block_BF+0x181>
  8027d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027d8:	8b 00                	mov    (%eax),%eax
  8027da:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027dd:	8b 52 04             	mov    0x4(%edx),%edx
  8027e0:	89 50 04             	mov    %edx,0x4(%eax)
  8027e3:	eb 0b                	jmp    8027f0 <alloc_block_BF+0x18c>
  8027e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027e8:	8b 40 04             	mov    0x4(%eax),%eax
  8027eb:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8027f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027f3:	8b 40 04             	mov    0x4(%eax),%eax
  8027f6:	85 c0                	test   %eax,%eax
  8027f8:	74 0f                	je     802809 <alloc_block_BF+0x1a5>
  8027fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027fd:	8b 40 04             	mov    0x4(%eax),%eax
  802800:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802803:	8b 12                	mov    (%edx),%edx
  802805:	89 10                	mov    %edx,(%eax)
  802807:	eb 0a                	jmp    802813 <alloc_block_BF+0x1af>
  802809:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80280c:	8b 00                	mov    (%eax),%eax
  80280e:	a3 48 51 80 00       	mov    %eax,0x805148
  802813:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802816:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80281c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80281f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802826:	a1 54 51 80 00       	mov    0x805154,%eax
  80282b:	48                   	dec    %eax
  80282c:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802831:	83 ec 08             	sub    $0x8,%esp
  802834:	ff 75 ec             	pushl  -0x14(%ebp)
  802837:	68 38 51 80 00       	push   $0x805138
  80283c:	e8 71 f9 ff ff       	call   8021b2 <find_block>
  802841:	83 c4 10             	add    $0x10,%esp
  802844:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802847:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80284a:	8b 50 08             	mov    0x8(%eax),%edx
  80284d:	8b 45 08             	mov    0x8(%ebp),%eax
  802850:	01 c2                	add    %eax,%edx
  802852:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802855:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802858:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80285b:	8b 40 0c             	mov    0xc(%eax),%eax
  80285e:	2b 45 08             	sub    0x8(%ebp),%eax
  802861:	89 c2                	mov    %eax,%edx
  802863:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802866:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802869:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80286c:	eb 05                	jmp    802873 <alloc_block_BF+0x20f>
	}
	return NULL;
  80286e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802873:	c9                   	leave  
  802874:	c3                   	ret    

00802875 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802875:	55                   	push   %ebp
  802876:	89 e5                	mov    %esp,%ebp
  802878:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  80287b:	a1 28 50 80 00       	mov    0x805028,%eax
  802880:	85 c0                	test   %eax,%eax
  802882:	0f 85 de 01 00 00    	jne    802a66 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802888:	a1 38 51 80 00       	mov    0x805138,%eax
  80288d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802890:	e9 9e 01 00 00       	jmp    802a33 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802895:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802898:	8b 40 0c             	mov    0xc(%eax),%eax
  80289b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80289e:	0f 82 87 01 00 00    	jb     802a2b <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  8028a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a7:	8b 40 0c             	mov    0xc(%eax),%eax
  8028aa:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028ad:	0f 85 95 00 00 00    	jne    802948 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  8028b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028b7:	75 17                	jne    8028d0 <alloc_block_NF+0x5b>
  8028b9:	83 ec 04             	sub    $0x4,%esp
  8028bc:	68 88 43 80 00       	push   $0x804388
  8028c1:	68 e0 00 00 00       	push   $0xe0
  8028c6:	68 df 42 80 00       	push   $0x8042df
  8028cb:	e8 eb db ff ff       	call   8004bb <_panic>
  8028d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d3:	8b 00                	mov    (%eax),%eax
  8028d5:	85 c0                	test   %eax,%eax
  8028d7:	74 10                	je     8028e9 <alloc_block_NF+0x74>
  8028d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028dc:	8b 00                	mov    (%eax),%eax
  8028de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028e1:	8b 52 04             	mov    0x4(%edx),%edx
  8028e4:	89 50 04             	mov    %edx,0x4(%eax)
  8028e7:	eb 0b                	jmp    8028f4 <alloc_block_NF+0x7f>
  8028e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ec:	8b 40 04             	mov    0x4(%eax),%eax
  8028ef:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8028f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f7:	8b 40 04             	mov    0x4(%eax),%eax
  8028fa:	85 c0                	test   %eax,%eax
  8028fc:	74 0f                	je     80290d <alloc_block_NF+0x98>
  8028fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802901:	8b 40 04             	mov    0x4(%eax),%eax
  802904:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802907:	8b 12                	mov    (%edx),%edx
  802909:	89 10                	mov    %edx,(%eax)
  80290b:	eb 0a                	jmp    802917 <alloc_block_NF+0xa2>
  80290d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802910:	8b 00                	mov    (%eax),%eax
  802912:	a3 38 51 80 00       	mov    %eax,0x805138
  802917:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802920:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802923:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80292a:	a1 44 51 80 00       	mov    0x805144,%eax
  80292f:	48                   	dec    %eax
  802930:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802935:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802938:	8b 40 08             	mov    0x8(%eax),%eax
  80293b:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802940:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802943:	e9 f8 04 00 00       	jmp    802e40 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802948:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294b:	8b 40 0c             	mov    0xc(%eax),%eax
  80294e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802951:	0f 86 d4 00 00 00    	jbe    802a2b <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802957:	a1 48 51 80 00       	mov    0x805148,%eax
  80295c:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  80295f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802962:	8b 50 08             	mov    0x8(%eax),%edx
  802965:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802968:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  80296b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80296e:	8b 55 08             	mov    0x8(%ebp),%edx
  802971:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802974:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802978:	75 17                	jne    802991 <alloc_block_NF+0x11c>
  80297a:	83 ec 04             	sub    $0x4,%esp
  80297d:	68 88 43 80 00       	push   $0x804388
  802982:	68 e9 00 00 00       	push   $0xe9
  802987:	68 df 42 80 00       	push   $0x8042df
  80298c:	e8 2a db ff ff       	call   8004bb <_panic>
  802991:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802994:	8b 00                	mov    (%eax),%eax
  802996:	85 c0                	test   %eax,%eax
  802998:	74 10                	je     8029aa <alloc_block_NF+0x135>
  80299a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80299d:	8b 00                	mov    (%eax),%eax
  80299f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029a2:	8b 52 04             	mov    0x4(%edx),%edx
  8029a5:	89 50 04             	mov    %edx,0x4(%eax)
  8029a8:	eb 0b                	jmp    8029b5 <alloc_block_NF+0x140>
  8029aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ad:	8b 40 04             	mov    0x4(%eax),%eax
  8029b0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8029b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029b8:	8b 40 04             	mov    0x4(%eax),%eax
  8029bb:	85 c0                	test   %eax,%eax
  8029bd:	74 0f                	je     8029ce <alloc_block_NF+0x159>
  8029bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029c2:	8b 40 04             	mov    0x4(%eax),%eax
  8029c5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029c8:	8b 12                	mov    (%edx),%edx
  8029ca:	89 10                	mov    %edx,(%eax)
  8029cc:	eb 0a                	jmp    8029d8 <alloc_block_NF+0x163>
  8029ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029d1:	8b 00                	mov    (%eax),%eax
  8029d3:	a3 48 51 80 00       	mov    %eax,0x805148
  8029d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029db:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029e4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029eb:	a1 54 51 80 00       	mov    0x805154,%eax
  8029f0:	48                   	dec    %eax
  8029f1:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  8029f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f9:	8b 40 08             	mov    0x8(%eax),%eax
  8029fc:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802a01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a04:	8b 50 08             	mov    0x8(%eax),%edx
  802a07:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0a:	01 c2                	add    %eax,%edx
  802a0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0f:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802a12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a15:	8b 40 0c             	mov    0xc(%eax),%eax
  802a18:	2b 45 08             	sub    0x8(%ebp),%eax
  802a1b:	89 c2                	mov    %eax,%edx
  802a1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a20:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802a23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a26:	e9 15 04 00 00       	jmp    802e40 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802a2b:	a1 40 51 80 00       	mov    0x805140,%eax
  802a30:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a33:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a37:	74 07                	je     802a40 <alloc_block_NF+0x1cb>
  802a39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3c:	8b 00                	mov    (%eax),%eax
  802a3e:	eb 05                	jmp    802a45 <alloc_block_NF+0x1d0>
  802a40:	b8 00 00 00 00       	mov    $0x0,%eax
  802a45:	a3 40 51 80 00       	mov    %eax,0x805140
  802a4a:	a1 40 51 80 00       	mov    0x805140,%eax
  802a4f:	85 c0                	test   %eax,%eax
  802a51:	0f 85 3e fe ff ff    	jne    802895 <alloc_block_NF+0x20>
  802a57:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a5b:	0f 85 34 fe ff ff    	jne    802895 <alloc_block_NF+0x20>
  802a61:	e9 d5 03 00 00       	jmp    802e3b <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a66:	a1 38 51 80 00       	mov    0x805138,%eax
  802a6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a6e:	e9 b1 01 00 00       	jmp    802c24 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802a73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a76:	8b 50 08             	mov    0x8(%eax),%edx
  802a79:	a1 28 50 80 00       	mov    0x805028,%eax
  802a7e:	39 c2                	cmp    %eax,%edx
  802a80:	0f 82 96 01 00 00    	jb     802c1c <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802a86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a89:	8b 40 0c             	mov    0xc(%eax),%eax
  802a8c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a8f:	0f 82 87 01 00 00    	jb     802c1c <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802a95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a98:	8b 40 0c             	mov    0xc(%eax),%eax
  802a9b:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a9e:	0f 85 95 00 00 00    	jne    802b39 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802aa4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aa8:	75 17                	jne    802ac1 <alloc_block_NF+0x24c>
  802aaa:	83 ec 04             	sub    $0x4,%esp
  802aad:	68 88 43 80 00       	push   $0x804388
  802ab2:	68 fc 00 00 00       	push   $0xfc
  802ab7:	68 df 42 80 00       	push   $0x8042df
  802abc:	e8 fa d9 ff ff       	call   8004bb <_panic>
  802ac1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac4:	8b 00                	mov    (%eax),%eax
  802ac6:	85 c0                	test   %eax,%eax
  802ac8:	74 10                	je     802ada <alloc_block_NF+0x265>
  802aca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acd:	8b 00                	mov    (%eax),%eax
  802acf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ad2:	8b 52 04             	mov    0x4(%edx),%edx
  802ad5:	89 50 04             	mov    %edx,0x4(%eax)
  802ad8:	eb 0b                	jmp    802ae5 <alloc_block_NF+0x270>
  802ada:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802add:	8b 40 04             	mov    0x4(%eax),%eax
  802ae0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ae5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae8:	8b 40 04             	mov    0x4(%eax),%eax
  802aeb:	85 c0                	test   %eax,%eax
  802aed:	74 0f                	je     802afe <alloc_block_NF+0x289>
  802aef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af2:	8b 40 04             	mov    0x4(%eax),%eax
  802af5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802af8:	8b 12                	mov    (%edx),%edx
  802afa:	89 10                	mov    %edx,(%eax)
  802afc:	eb 0a                	jmp    802b08 <alloc_block_NF+0x293>
  802afe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b01:	8b 00                	mov    (%eax),%eax
  802b03:	a3 38 51 80 00       	mov    %eax,0x805138
  802b08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b14:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b1b:	a1 44 51 80 00       	mov    0x805144,%eax
  802b20:	48                   	dec    %eax
  802b21:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802b26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b29:	8b 40 08             	mov    0x8(%eax),%eax
  802b2c:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802b31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b34:	e9 07 03 00 00       	jmp    802e40 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802b39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3c:	8b 40 0c             	mov    0xc(%eax),%eax
  802b3f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b42:	0f 86 d4 00 00 00    	jbe    802c1c <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b48:	a1 48 51 80 00       	mov    0x805148,%eax
  802b4d:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802b50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b53:	8b 50 08             	mov    0x8(%eax),%edx
  802b56:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b59:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802b5c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b5f:	8b 55 08             	mov    0x8(%ebp),%edx
  802b62:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802b65:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802b69:	75 17                	jne    802b82 <alloc_block_NF+0x30d>
  802b6b:	83 ec 04             	sub    $0x4,%esp
  802b6e:	68 88 43 80 00       	push   $0x804388
  802b73:	68 04 01 00 00       	push   $0x104
  802b78:	68 df 42 80 00       	push   $0x8042df
  802b7d:	e8 39 d9 ff ff       	call   8004bb <_panic>
  802b82:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b85:	8b 00                	mov    (%eax),%eax
  802b87:	85 c0                	test   %eax,%eax
  802b89:	74 10                	je     802b9b <alloc_block_NF+0x326>
  802b8b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b8e:	8b 00                	mov    (%eax),%eax
  802b90:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b93:	8b 52 04             	mov    0x4(%edx),%edx
  802b96:	89 50 04             	mov    %edx,0x4(%eax)
  802b99:	eb 0b                	jmp    802ba6 <alloc_block_NF+0x331>
  802b9b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b9e:	8b 40 04             	mov    0x4(%eax),%eax
  802ba1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ba6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ba9:	8b 40 04             	mov    0x4(%eax),%eax
  802bac:	85 c0                	test   %eax,%eax
  802bae:	74 0f                	je     802bbf <alloc_block_NF+0x34a>
  802bb0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bb3:	8b 40 04             	mov    0x4(%eax),%eax
  802bb6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802bb9:	8b 12                	mov    (%edx),%edx
  802bbb:	89 10                	mov    %edx,(%eax)
  802bbd:	eb 0a                	jmp    802bc9 <alloc_block_NF+0x354>
  802bbf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bc2:	8b 00                	mov    (%eax),%eax
  802bc4:	a3 48 51 80 00       	mov    %eax,0x805148
  802bc9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bcc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bd2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bd5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bdc:	a1 54 51 80 00       	mov    0x805154,%eax
  802be1:	48                   	dec    %eax
  802be2:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802be7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bea:	8b 40 08             	mov    0x8(%eax),%eax
  802bed:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802bf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf5:	8b 50 08             	mov    0x8(%eax),%edx
  802bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  802bfb:	01 c2                	add    %eax,%edx
  802bfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c00:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802c03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c06:	8b 40 0c             	mov    0xc(%eax),%eax
  802c09:	2b 45 08             	sub    0x8(%ebp),%eax
  802c0c:	89 c2                	mov    %eax,%edx
  802c0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c11:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802c14:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c17:	e9 24 02 00 00       	jmp    802e40 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c1c:	a1 40 51 80 00       	mov    0x805140,%eax
  802c21:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c24:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c28:	74 07                	je     802c31 <alloc_block_NF+0x3bc>
  802c2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2d:	8b 00                	mov    (%eax),%eax
  802c2f:	eb 05                	jmp    802c36 <alloc_block_NF+0x3c1>
  802c31:	b8 00 00 00 00       	mov    $0x0,%eax
  802c36:	a3 40 51 80 00       	mov    %eax,0x805140
  802c3b:	a1 40 51 80 00       	mov    0x805140,%eax
  802c40:	85 c0                	test   %eax,%eax
  802c42:	0f 85 2b fe ff ff    	jne    802a73 <alloc_block_NF+0x1fe>
  802c48:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c4c:	0f 85 21 fe ff ff    	jne    802a73 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c52:	a1 38 51 80 00       	mov    0x805138,%eax
  802c57:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c5a:	e9 ae 01 00 00       	jmp    802e0d <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802c5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c62:	8b 50 08             	mov    0x8(%eax),%edx
  802c65:	a1 28 50 80 00       	mov    0x805028,%eax
  802c6a:	39 c2                	cmp    %eax,%edx
  802c6c:	0f 83 93 01 00 00    	jae    802e05 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802c72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c75:	8b 40 0c             	mov    0xc(%eax),%eax
  802c78:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c7b:	0f 82 84 01 00 00    	jb     802e05 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802c81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c84:	8b 40 0c             	mov    0xc(%eax),%eax
  802c87:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c8a:	0f 85 95 00 00 00    	jne    802d25 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802c90:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c94:	75 17                	jne    802cad <alloc_block_NF+0x438>
  802c96:	83 ec 04             	sub    $0x4,%esp
  802c99:	68 88 43 80 00       	push   $0x804388
  802c9e:	68 14 01 00 00       	push   $0x114
  802ca3:	68 df 42 80 00       	push   $0x8042df
  802ca8:	e8 0e d8 ff ff       	call   8004bb <_panic>
  802cad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb0:	8b 00                	mov    (%eax),%eax
  802cb2:	85 c0                	test   %eax,%eax
  802cb4:	74 10                	je     802cc6 <alloc_block_NF+0x451>
  802cb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb9:	8b 00                	mov    (%eax),%eax
  802cbb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cbe:	8b 52 04             	mov    0x4(%edx),%edx
  802cc1:	89 50 04             	mov    %edx,0x4(%eax)
  802cc4:	eb 0b                	jmp    802cd1 <alloc_block_NF+0x45c>
  802cc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc9:	8b 40 04             	mov    0x4(%eax),%eax
  802ccc:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802cd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd4:	8b 40 04             	mov    0x4(%eax),%eax
  802cd7:	85 c0                	test   %eax,%eax
  802cd9:	74 0f                	je     802cea <alloc_block_NF+0x475>
  802cdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cde:	8b 40 04             	mov    0x4(%eax),%eax
  802ce1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ce4:	8b 12                	mov    (%edx),%edx
  802ce6:	89 10                	mov    %edx,(%eax)
  802ce8:	eb 0a                	jmp    802cf4 <alloc_block_NF+0x47f>
  802cea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ced:	8b 00                	mov    (%eax),%eax
  802cef:	a3 38 51 80 00       	mov    %eax,0x805138
  802cf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d00:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d07:	a1 44 51 80 00       	mov    0x805144,%eax
  802d0c:	48                   	dec    %eax
  802d0d:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802d12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d15:	8b 40 08             	mov    0x8(%eax),%eax
  802d18:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802d1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d20:	e9 1b 01 00 00       	jmp    802e40 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802d25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d28:	8b 40 0c             	mov    0xc(%eax),%eax
  802d2b:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d2e:	0f 86 d1 00 00 00    	jbe    802e05 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802d34:	a1 48 51 80 00       	mov    0x805148,%eax
  802d39:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802d3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3f:	8b 50 08             	mov    0x8(%eax),%edx
  802d42:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d45:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802d48:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d4b:	8b 55 08             	mov    0x8(%ebp),%edx
  802d4e:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802d51:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802d55:	75 17                	jne    802d6e <alloc_block_NF+0x4f9>
  802d57:	83 ec 04             	sub    $0x4,%esp
  802d5a:	68 88 43 80 00       	push   $0x804388
  802d5f:	68 1c 01 00 00       	push   $0x11c
  802d64:	68 df 42 80 00       	push   $0x8042df
  802d69:	e8 4d d7 ff ff       	call   8004bb <_panic>
  802d6e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d71:	8b 00                	mov    (%eax),%eax
  802d73:	85 c0                	test   %eax,%eax
  802d75:	74 10                	je     802d87 <alloc_block_NF+0x512>
  802d77:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d7a:	8b 00                	mov    (%eax),%eax
  802d7c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d7f:	8b 52 04             	mov    0x4(%edx),%edx
  802d82:	89 50 04             	mov    %edx,0x4(%eax)
  802d85:	eb 0b                	jmp    802d92 <alloc_block_NF+0x51d>
  802d87:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d8a:	8b 40 04             	mov    0x4(%eax),%eax
  802d8d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d92:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d95:	8b 40 04             	mov    0x4(%eax),%eax
  802d98:	85 c0                	test   %eax,%eax
  802d9a:	74 0f                	je     802dab <alloc_block_NF+0x536>
  802d9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d9f:	8b 40 04             	mov    0x4(%eax),%eax
  802da2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802da5:	8b 12                	mov    (%edx),%edx
  802da7:	89 10                	mov    %edx,(%eax)
  802da9:	eb 0a                	jmp    802db5 <alloc_block_NF+0x540>
  802dab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dae:	8b 00                	mov    (%eax),%eax
  802db0:	a3 48 51 80 00       	mov    %eax,0x805148
  802db5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802db8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dbe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dc1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dc8:	a1 54 51 80 00       	mov    0x805154,%eax
  802dcd:	48                   	dec    %eax
  802dce:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802dd3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dd6:	8b 40 08             	mov    0x8(%eax),%eax
  802dd9:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802dde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de1:	8b 50 08             	mov    0x8(%eax),%edx
  802de4:	8b 45 08             	mov    0x8(%ebp),%eax
  802de7:	01 c2                	add    %eax,%edx
  802de9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dec:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802def:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df2:	8b 40 0c             	mov    0xc(%eax),%eax
  802df5:	2b 45 08             	sub    0x8(%ebp),%eax
  802df8:	89 c2                	mov    %eax,%edx
  802dfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dfd:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802e00:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e03:	eb 3b                	jmp    802e40 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802e05:	a1 40 51 80 00       	mov    0x805140,%eax
  802e0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e0d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e11:	74 07                	je     802e1a <alloc_block_NF+0x5a5>
  802e13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e16:	8b 00                	mov    (%eax),%eax
  802e18:	eb 05                	jmp    802e1f <alloc_block_NF+0x5aa>
  802e1a:	b8 00 00 00 00       	mov    $0x0,%eax
  802e1f:	a3 40 51 80 00       	mov    %eax,0x805140
  802e24:	a1 40 51 80 00       	mov    0x805140,%eax
  802e29:	85 c0                	test   %eax,%eax
  802e2b:	0f 85 2e fe ff ff    	jne    802c5f <alloc_block_NF+0x3ea>
  802e31:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e35:	0f 85 24 fe ff ff    	jne    802c5f <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802e3b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e40:	c9                   	leave  
  802e41:	c3                   	ret    

00802e42 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802e42:	55                   	push   %ebp
  802e43:	89 e5                	mov    %esp,%ebp
  802e45:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802e48:	a1 38 51 80 00       	mov    0x805138,%eax
  802e4d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802e50:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802e55:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802e58:	a1 38 51 80 00       	mov    0x805138,%eax
  802e5d:	85 c0                	test   %eax,%eax
  802e5f:	74 14                	je     802e75 <insert_sorted_with_merge_freeList+0x33>
  802e61:	8b 45 08             	mov    0x8(%ebp),%eax
  802e64:	8b 50 08             	mov    0x8(%eax),%edx
  802e67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e6a:	8b 40 08             	mov    0x8(%eax),%eax
  802e6d:	39 c2                	cmp    %eax,%edx
  802e6f:	0f 87 9b 01 00 00    	ja     803010 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802e75:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e79:	75 17                	jne    802e92 <insert_sorted_with_merge_freeList+0x50>
  802e7b:	83 ec 04             	sub    $0x4,%esp
  802e7e:	68 bc 42 80 00       	push   $0x8042bc
  802e83:	68 38 01 00 00       	push   $0x138
  802e88:	68 df 42 80 00       	push   $0x8042df
  802e8d:	e8 29 d6 ff ff       	call   8004bb <_panic>
  802e92:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802e98:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9b:	89 10                	mov    %edx,(%eax)
  802e9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea0:	8b 00                	mov    (%eax),%eax
  802ea2:	85 c0                	test   %eax,%eax
  802ea4:	74 0d                	je     802eb3 <insert_sorted_with_merge_freeList+0x71>
  802ea6:	a1 38 51 80 00       	mov    0x805138,%eax
  802eab:	8b 55 08             	mov    0x8(%ebp),%edx
  802eae:	89 50 04             	mov    %edx,0x4(%eax)
  802eb1:	eb 08                	jmp    802ebb <insert_sorted_with_merge_freeList+0x79>
  802eb3:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ebb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebe:	a3 38 51 80 00       	mov    %eax,0x805138
  802ec3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ecd:	a1 44 51 80 00       	mov    0x805144,%eax
  802ed2:	40                   	inc    %eax
  802ed3:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802ed8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802edc:	0f 84 a8 06 00 00    	je     80358a <insert_sorted_with_merge_freeList+0x748>
  802ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee5:	8b 50 08             	mov    0x8(%eax),%edx
  802ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  802eeb:	8b 40 0c             	mov    0xc(%eax),%eax
  802eee:	01 c2                	add    %eax,%edx
  802ef0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ef3:	8b 40 08             	mov    0x8(%eax),%eax
  802ef6:	39 c2                	cmp    %eax,%edx
  802ef8:	0f 85 8c 06 00 00    	jne    80358a <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802efe:	8b 45 08             	mov    0x8(%ebp),%eax
  802f01:	8b 50 0c             	mov    0xc(%eax),%edx
  802f04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f07:	8b 40 0c             	mov    0xc(%eax),%eax
  802f0a:	01 c2                	add    %eax,%edx
  802f0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0f:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802f12:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f16:	75 17                	jne    802f2f <insert_sorted_with_merge_freeList+0xed>
  802f18:	83 ec 04             	sub    $0x4,%esp
  802f1b:	68 88 43 80 00       	push   $0x804388
  802f20:	68 3c 01 00 00       	push   $0x13c
  802f25:	68 df 42 80 00       	push   $0x8042df
  802f2a:	e8 8c d5 ff ff       	call   8004bb <_panic>
  802f2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f32:	8b 00                	mov    (%eax),%eax
  802f34:	85 c0                	test   %eax,%eax
  802f36:	74 10                	je     802f48 <insert_sorted_with_merge_freeList+0x106>
  802f38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f3b:	8b 00                	mov    (%eax),%eax
  802f3d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f40:	8b 52 04             	mov    0x4(%edx),%edx
  802f43:	89 50 04             	mov    %edx,0x4(%eax)
  802f46:	eb 0b                	jmp    802f53 <insert_sorted_with_merge_freeList+0x111>
  802f48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f4b:	8b 40 04             	mov    0x4(%eax),%eax
  802f4e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f56:	8b 40 04             	mov    0x4(%eax),%eax
  802f59:	85 c0                	test   %eax,%eax
  802f5b:	74 0f                	je     802f6c <insert_sorted_with_merge_freeList+0x12a>
  802f5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f60:	8b 40 04             	mov    0x4(%eax),%eax
  802f63:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f66:	8b 12                	mov    (%edx),%edx
  802f68:	89 10                	mov    %edx,(%eax)
  802f6a:	eb 0a                	jmp    802f76 <insert_sorted_with_merge_freeList+0x134>
  802f6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f6f:	8b 00                	mov    (%eax),%eax
  802f71:	a3 38 51 80 00       	mov    %eax,0x805138
  802f76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f79:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f82:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f89:	a1 44 51 80 00       	mov    0x805144,%eax
  802f8e:	48                   	dec    %eax
  802f8f:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802f94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f97:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802f9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fa1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802fa8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802fac:	75 17                	jne    802fc5 <insert_sorted_with_merge_freeList+0x183>
  802fae:	83 ec 04             	sub    $0x4,%esp
  802fb1:	68 bc 42 80 00       	push   $0x8042bc
  802fb6:	68 3f 01 00 00       	push   $0x13f
  802fbb:	68 df 42 80 00       	push   $0x8042df
  802fc0:	e8 f6 d4 ff ff       	call   8004bb <_panic>
  802fc5:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802fcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fce:	89 10                	mov    %edx,(%eax)
  802fd0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fd3:	8b 00                	mov    (%eax),%eax
  802fd5:	85 c0                	test   %eax,%eax
  802fd7:	74 0d                	je     802fe6 <insert_sorted_with_merge_freeList+0x1a4>
  802fd9:	a1 48 51 80 00       	mov    0x805148,%eax
  802fde:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fe1:	89 50 04             	mov    %edx,0x4(%eax)
  802fe4:	eb 08                	jmp    802fee <insert_sorted_with_merge_freeList+0x1ac>
  802fe6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fe9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802fee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ff1:	a3 48 51 80 00       	mov    %eax,0x805148
  802ff6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ff9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803000:	a1 54 51 80 00       	mov    0x805154,%eax
  803005:	40                   	inc    %eax
  803006:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80300b:	e9 7a 05 00 00       	jmp    80358a <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  803010:	8b 45 08             	mov    0x8(%ebp),%eax
  803013:	8b 50 08             	mov    0x8(%eax),%edx
  803016:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803019:	8b 40 08             	mov    0x8(%eax),%eax
  80301c:	39 c2                	cmp    %eax,%edx
  80301e:	0f 82 14 01 00 00    	jb     803138 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  803024:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803027:	8b 50 08             	mov    0x8(%eax),%edx
  80302a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80302d:	8b 40 0c             	mov    0xc(%eax),%eax
  803030:	01 c2                	add    %eax,%edx
  803032:	8b 45 08             	mov    0x8(%ebp),%eax
  803035:	8b 40 08             	mov    0x8(%eax),%eax
  803038:	39 c2                	cmp    %eax,%edx
  80303a:	0f 85 90 00 00 00    	jne    8030d0 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  803040:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803043:	8b 50 0c             	mov    0xc(%eax),%edx
  803046:	8b 45 08             	mov    0x8(%ebp),%eax
  803049:	8b 40 0c             	mov    0xc(%eax),%eax
  80304c:	01 c2                	add    %eax,%edx
  80304e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803051:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  803054:	8b 45 08             	mov    0x8(%ebp),%eax
  803057:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  80305e:	8b 45 08             	mov    0x8(%ebp),%eax
  803061:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803068:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80306c:	75 17                	jne    803085 <insert_sorted_with_merge_freeList+0x243>
  80306e:	83 ec 04             	sub    $0x4,%esp
  803071:	68 bc 42 80 00       	push   $0x8042bc
  803076:	68 49 01 00 00       	push   $0x149
  80307b:	68 df 42 80 00       	push   $0x8042df
  803080:	e8 36 d4 ff ff       	call   8004bb <_panic>
  803085:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80308b:	8b 45 08             	mov    0x8(%ebp),%eax
  80308e:	89 10                	mov    %edx,(%eax)
  803090:	8b 45 08             	mov    0x8(%ebp),%eax
  803093:	8b 00                	mov    (%eax),%eax
  803095:	85 c0                	test   %eax,%eax
  803097:	74 0d                	je     8030a6 <insert_sorted_with_merge_freeList+0x264>
  803099:	a1 48 51 80 00       	mov    0x805148,%eax
  80309e:	8b 55 08             	mov    0x8(%ebp),%edx
  8030a1:	89 50 04             	mov    %edx,0x4(%eax)
  8030a4:	eb 08                	jmp    8030ae <insert_sorted_with_merge_freeList+0x26c>
  8030a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b1:	a3 48 51 80 00       	mov    %eax,0x805148
  8030b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030c0:	a1 54 51 80 00       	mov    0x805154,%eax
  8030c5:	40                   	inc    %eax
  8030c6:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8030cb:	e9 bb 04 00 00       	jmp    80358b <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  8030d0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030d4:	75 17                	jne    8030ed <insert_sorted_with_merge_freeList+0x2ab>
  8030d6:	83 ec 04             	sub    $0x4,%esp
  8030d9:	68 30 43 80 00       	push   $0x804330
  8030de:	68 4c 01 00 00       	push   $0x14c
  8030e3:	68 df 42 80 00       	push   $0x8042df
  8030e8:	e8 ce d3 ff ff       	call   8004bb <_panic>
  8030ed:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8030f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f6:	89 50 04             	mov    %edx,0x4(%eax)
  8030f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030fc:	8b 40 04             	mov    0x4(%eax),%eax
  8030ff:	85 c0                	test   %eax,%eax
  803101:	74 0c                	je     80310f <insert_sorted_with_merge_freeList+0x2cd>
  803103:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803108:	8b 55 08             	mov    0x8(%ebp),%edx
  80310b:	89 10                	mov    %edx,(%eax)
  80310d:	eb 08                	jmp    803117 <insert_sorted_with_merge_freeList+0x2d5>
  80310f:	8b 45 08             	mov    0x8(%ebp),%eax
  803112:	a3 38 51 80 00       	mov    %eax,0x805138
  803117:	8b 45 08             	mov    0x8(%ebp),%eax
  80311a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80311f:	8b 45 08             	mov    0x8(%ebp),%eax
  803122:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803128:	a1 44 51 80 00       	mov    0x805144,%eax
  80312d:	40                   	inc    %eax
  80312e:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803133:	e9 53 04 00 00       	jmp    80358b <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803138:	a1 38 51 80 00       	mov    0x805138,%eax
  80313d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803140:	e9 15 04 00 00       	jmp    80355a <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  803145:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803148:	8b 00                	mov    (%eax),%eax
  80314a:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  80314d:	8b 45 08             	mov    0x8(%ebp),%eax
  803150:	8b 50 08             	mov    0x8(%eax),%edx
  803153:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803156:	8b 40 08             	mov    0x8(%eax),%eax
  803159:	39 c2                	cmp    %eax,%edx
  80315b:	0f 86 f1 03 00 00    	jbe    803552 <insert_sorted_with_merge_freeList+0x710>
  803161:	8b 45 08             	mov    0x8(%ebp),%eax
  803164:	8b 50 08             	mov    0x8(%eax),%edx
  803167:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80316a:	8b 40 08             	mov    0x8(%eax),%eax
  80316d:	39 c2                	cmp    %eax,%edx
  80316f:	0f 83 dd 03 00 00    	jae    803552 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803175:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803178:	8b 50 08             	mov    0x8(%eax),%edx
  80317b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80317e:	8b 40 0c             	mov    0xc(%eax),%eax
  803181:	01 c2                	add    %eax,%edx
  803183:	8b 45 08             	mov    0x8(%ebp),%eax
  803186:	8b 40 08             	mov    0x8(%eax),%eax
  803189:	39 c2                	cmp    %eax,%edx
  80318b:	0f 85 b9 01 00 00    	jne    80334a <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803191:	8b 45 08             	mov    0x8(%ebp),%eax
  803194:	8b 50 08             	mov    0x8(%eax),%edx
  803197:	8b 45 08             	mov    0x8(%ebp),%eax
  80319a:	8b 40 0c             	mov    0xc(%eax),%eax
  80319d:	01 c2                	add    %eax,%edx
  80319f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031a2:	8b 40 08             	mov    0x8(%eax),%eax
  8031a5:	39 c2                	cmp    %eax,%edx
  8031a7:	0f 85 0d 01 00 00    	jne    8032ba <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  8031ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b0:	8b 50 0c             	mov    0xc(%eax),%edx
  8031b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031b6:	8b 40 0c             	mov    0xc(%eax),%eax
  8031b9:	01 c2                	add    %eax,%edx
  8031bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031be:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8031c1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031c5:	75 17                	jne    8031de <insert_sorted_with_merge_freeList+0x39c>
  8031c7:	83 ec 04             	sub    $0x4,%esp
  8031ca:	68 88 43 80 00       	push   $0x804388
  8031cf:	68 5c 01 00 00       	push   $0x15c
  8031d4:	68 df 42 80 00       	push   $0x8042df
  8031d9:	e8 dd d2 ff ff       	call   8004bb <_panic>
  8031de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e1:	8b 00                	mov    (%eax),%eax
  8031e3:	85 c0                	test   %eax,%eax
  8031e5:	74 10                	je     8031f7 <insert_sorted_with_merge_freeList+0x3b5>
  8031e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ea:	8b 00                	mov    (%eax),%eax
  8031ec:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031ef:	8b 52 04             	mov    0x4(%edx),%edx
  8031f2:	89 50 04             	mov    %edx,0x4(%eax)
  8031f5:	eb 0b                	jmp    803202 <insert_sorted_with_merge_freeList+0x3c0>
  8031f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031fa:	8b 40 04             	mov    0x4(%eax),%eax
  8031fd:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803202:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803205:	8b 40 04             	mov    0x4(%eax),%eax
  803208:	85 c0                	test   %eax,%eax
  80320a:	74 0f                	je     80321b <insert_sorted_with_merge_freeList+0x3d9>
  80320c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80320f:	8b 40 04             	mov    0x4(%eax),%eax
  803212:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803215:	8b 12                	mov    (%edx),%edx
  803217:	89 10                	mov    %edx,(%eax)
  803219:	eb 0a                	jmp    803225 <insert_sorted_with_merge_freeList+0x3e3>
  80321b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80321e:	8b 00                	mov    (%eax),%eax
  803220:	a3 38 51 80 00       	mov    %eax,0x805138
  803225:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803228:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80322e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803231:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803238:	a1 44 51 80 00       	mov    0x805144,%eax
  80323d:	48                   	dec    %eax
  80323e:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803243:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803246:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  80324d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803250:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803257:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80325b:	75 17                	jne    803274 <insert_sorted_with_merge_freeList+0x432>
  80325d:	83 ec 04             	sub    $0x4,%esp
  803260:	68 bc 42 80 00       	push   $0x8042bc
  803265:	68 5f 01 00 00       	push   $0x15f
  80326a:	68 df 42 80 00       	push   $0x8042df
  80326f:	e8 47 d2 ff ff       	call   8004bb <_panic>
  803274:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80327a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80327d:	89 10                	mov    %edx,(%eax)
  80327f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803282:	8b 00                	mov    (%eax),%eax
  803284:	85 c0                	test   %eax,%eax
  803286:	74 0d                	je     803295 <insert_sorted_with_merge_freeList+0x453>
  803288:	a1 48 51 80 00       	mov    0x805148,%eax
  80328d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803290:	89 50 04             	mov    %edx,0x4(%eax)
  803293:	eb 08                	jmp    80329d <insert_sorted_with_merge_freeList+0x45b>
  803295:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803298:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80329d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032a0:	a3 48 51 80 00       	mov    %eax,0x805148
  8032a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032a8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032af:	a1 54 51 80 00       	mov    0x805154,%eax
  8032b4:	40                   	inc    %eax
  8032b5:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  8032ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032bd:	8b 50 0c             	mov    0xc(%eax),%edx
  8032c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c3:	8b 40 0c             	mov    0xc(%eax),%eax
  8032c6:	01 c2                	add    %eax,%edx
  8032c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032cb:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8032ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8032d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032db:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8032e2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032e6:	75 17                	jne    8032ff <insert_sorted_with_merge_freeList+0x4bd>
  8032e8:	83 ec 04             	sub    $0x4,%esp
  8032eb:	68 bc 42 80 00       	push   $0x8042bc
  8032f0:	68 64 01 00 00       	push   $0x164
  8032f5:	68 df 42 80 00       	push   $0x8042df
  8032fa:	e8 bc d1 ff ff       	call   8004bb <_panic>
  8032ff:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803305:	8b 45 08             	mov    0x8(%ebp),%eax
  803308:	89 10                	mov    %edx,(%eax)
  80330a:	8b 45 08             	mov    0x8(%ebp),%eax
  80330d:	8b 00                	mov    (%eax),%eax
  80330f:	85 c0                	test   %eax,%eax
  803311:	74 0d                	je     803320 <insert_sorted_with_merge_freeList+0x4de>
  803313:	a1 48 51 80 00       	mov    0x805148,%eax
  803318:	8b 55 08             	mov    0x8(%ebp),%edx
  80331b:	89 50 04             	mov    %edx,0x4(%eax)
  80331e:	eb 08                	jmp    803328 <insert_sorted_with_merge_freeList+0x4e6>
  803320:	8b 45 08             	mov    0x8(%ebp),%eax
  803323:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803328:	8b 45 08             	mov    0x8(%ebp),%eax
  80332b:	a3 48 51 80 00       	mov    %eax,0x805148
  803330:	8b 45 08             	mov    0x8(%ebp),%eax
  803333:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80333a:	a1 54 51 80 00       	mov    0x805154,%eax
  80333f:	40                   	inc    %eax
  803340:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803345:	e9 41 02 00 00       	jmp    80358b <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80334a:	8b 45 08             	mov    0x8(%ebp),%eax
  80334d:	8b 50 08             	mov    0x8(%eax),%edx
  803350:	8b 45 08             	mov    0x8(%ebp),%eax
  803353:	8b 40 0c             	mov    0xc(%eax),%eax
  803356:	01 c2                	add    %eax,%edx
  803358:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80335b:	8b 40 08             	mov    0x8(%eax),%eax
  80335e:	39 c2                	cmp    %eax,%edx
  803360:	0f 85 7c 01 00 00    	jne    8034e2 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803366:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80336a:	74 06                	je     803372 <insert_sorted_with_merge_freeList+0x530>
  80336c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803370:	75 17                	jne    803389 <insert_sorted_with_merge_freeList+0x547>
  803372:	83 ec 04             	sub    $0x4,%esp
  803375:	68 f8 42 80 00       	push   $0x8042f8
  80337a:	68 69 01 00 00       	push   $0x169
  80337f:	68 df 42 80 00       	push   $0x8042df
  803384:	e8 32 d1 ff ff       	call   8004bb <_panic>
  803389:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80338c:	8b 50 04             	mov    0x4(%eax),%edx
  80338f:	8b 45 08             	mov    0x8(%ebp),%eax
  803392:	89 50 04             	mov    %edx,0x4(%eax)
  803395:	8b 45 08             	mov    0x8(%ebp),%eax
  803398:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80339b:	89 10                	mov    %edx,(%eax)
  80339d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033a0:	8b 40 04             	mov    0x4(%eax),%eax
  8033a3:	85 c0                	test   %eax,%eax
  8033a5:	74 0d                	je     8033b4 <insert_sorted_with_merge_freeList+0x572>
  8033a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033aa:	8b 40 04             	mov    0x4(%eax),%eax
  8033ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8033b0:	89 10                	mov    %edx,(%eax)
  8033b2:	eb 08                	jmp    8033bc <insert_sorted_with_merge_freeList+0x57a>
  8033b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b7:	a3 38 51 80 00       	mov    %eax,0x805138
  8033bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8033c2:	89 50 04             	mov    %edx,0x4(%eax)
  8033c5:	a1 44 51 80 00       	mov    0x805144,%eax
  8033ca:	40                   	inc    %eax
  8033cb:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  8033d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d3:	8b 50 0c             	mov    0xc(%eax),%edx
  8033d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033d9:	8b 40 0c             	mov    0xc(%eax),%eax
  8033dc:	01 c2                	add    %eax,%edx
  8033de:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e1:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8033e4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8033e8:	75 17                	jne    803401 <insert_sorted_with_merge_freeList+0x5bf>
  8033ea:	83 ec 04             	sub    $0x4,%esp
  8033ed:	68 88 43 80 00       	push   $0x804388
  8033f2:	68 6b 01 00 00       	push   $0x16b
  8033f7:	68 df 42 80 00       	push   $0x8042df
  8033fc:	e8 ba d0 ff ff       	call   8004bb <_panic>
  803401:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803404:	8b 00                	mov    (%eax),%eax
  803406:	85 c0                	test   %eax,%eax
  803408:	74 10                	je     80341a <insert_sorted_with_merge_freeList+0x5d8>
  80340a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80340d:	8b 00                	mov    (%eax),%eax
  80340f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803412:	8b 52 04             	mov    0x4(%edx),%edx
  803415:	89 50 04             	mov    %edx,0x4(%eax)
  803418:	eb 0b                	jmp    803425 <insert_sorted_with_merge_freeList+0x5e3>
  80341a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80341d:	8b 40 04             	mov    0x4(%eax),%eax
  803420:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803425:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803428:	8b 40 04             	mov    0x4(%eax),%eax
  80342b:	85 c0                	test   %eax,%eax
  80342d:	74 0f                	je     80343e <insert_sorted_with_merge_freeList+0x5fc>
  80342f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803432:	8b 40 04             	mov    0x4(%eax),%eax
  803435:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803438:	8b 12                	mov    (%edx),%edx
  80343a:	89 10                	mov    %edx,(%eax)
  80343c:	eb 0a                	jmp    803448 <insert_sorted_with_merge_freeList+0x606>
  80343e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803441:	8b 00                	mov    (%eax),%eax
  803443:	a3 38 51 80 00       	mov    %eax,0x805138
  803448:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80344b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803451:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803454:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80345b:	a1 44 51 80 00       	mov    0x805144,%eax
  803460:	48                   	dec    %eax
  803461:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803466:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803469:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803470:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803473:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80347a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80347e:	75 17                	jne    803497 <insert_sorted_with_merge_freeList+0x655>
  803480:	83 ec 04             	sub    $0x4,%esp
  803483:	68 bc 42 80 00       	push   $0x8042bc
  803488:	68 6e 01 00 00       	push   $0x16e
  80348d:	68 df 42 80 00       	push   $0x8042df
  803492:	e8 24 d0 ff ff       	call   8004bb <_panic>
  803497:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80349d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034a0:	89 10                	mov    %edx,(%eax)
  8034a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034a5:	8b 00                	mov    (%eax),%eax
  8034a7:	85 c0                	test   %eax,%eax
  8034a9:	74 0d                	je     8034b8 <insert_sorted_with_merge_freeList+0x676>
  8034ab:	a1 48 51 80 00       	mov    0x805148,%eax
  8034b0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8034b3:	89 50 04             	mov    %edx,0x4(%eax)
  8034b6:	eb 08                	jmp    8034c0 <insert_sorted_with_merge_freeList+0x67e>
  8034b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034bb:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8034c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034c3:	a3 48 51 80 00       	mov    %eax,0x805148
  8034c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034cb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034d2:	a1 54 51 80 00       	mov    0x805154,%eax
  8034d7:	40                   	inc    %eax
  8034d8:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8034dd:	e9 a9 00 00 00       	jmp    80358b <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8034e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034e6:	74 06                	je     8034ee <insert_sorted_with_merge_freeList+0x6ac>
  8034e8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034ec:	75 17                	jne    803505 <insert_sorted_with_merge_freeList+0x6c3>
  8034ee:	83 ec 04             	sub    $0x4,%esp
  8034f1:	68 54 43 80 00       	push   $0x804354
  8034f6:	68 73 01 00 00       	push   $0x173
  8034fb:	68 df 42 80 00       	push   $0x8042df
  803500:	e8 b6 cf ff ff       	call   8004bb <_panic>
  803505:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803508:	8b 10                	mov    (%eax),%edx
  80350a:	8b 45 08             	mov    0x8(%ebp),%eax
  80350d:	89 10                	mov    %edx,(%eax)
  80350f:	8b 45 08             	mov    0x8(%ebp),%eax
  803512:	8b 00                	mov    (%eax),%eax
  803514:	85 c0                	test   %eax,%eax
  803516:	74 0b                	je     803523 <insert_sorted_with_merge_freeList+0x6e1>
  803518:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80351b:	8b 00                	mov    (%eax),%eax
  80351d:	8b 55 08             	mov    0x8(%ebp),%edx
  803520:	89 50 04             	mov    %edx,0x4(%eax)
  803523:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803526:	8b 55 08             	mov    0x8(%ebp),%edx
  803529:	89 10                	mov    %edx,(%eax)
  80352b:	8b 45 08             	mov    0x8(%ebp),%eax
  80352e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803531:	89 50 04             	mov    %edx,0x4(%eax)
  803534:	8b 45 08             	mov    0x8(%ebp),%eax
  803537:	8b 00                	mov    (%eax),%eax
  803539:	85 c0                	test   %eax,%eax
  80353b:	75 08                	jne    803545 <insert_sorted_with_merge_freeList+0x703>
  80353d:	8b 45 08             	mov    0x8(%ebp),%eax
  803540:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803545:	a1 44 51 80 00       	mov    0x805144,%eax
  80354a:	40                   	inc    %eax
  80354b:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803550:	eb 39                	jmp    80358b <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803552:	a1 40 51 80 00       	mov    0x805140,%eax
  803557:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80355a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80355e:	74 07                	je     803567 <insert_sorted_with_merge_freeList+0x725>
  803560:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803563:	8b 00                	mov    (%eax),%eax
  803565:	eb 05                	jmp    80356c <insert_sorted_with_merge_freeList+0x72a>
  803567:	b8 00 00 00 00       	mov    $0x0,%eax
  80356c:	a3 40 51 80 00       	mov    %eax,0x805140
  803571:	a1 40 51 80 00       	mov    0x805140,%eax
  803576:	85 c0                	test   %eax,%eax
  803578:	0f 85 c7 fb ff ff    	jne    803145 <insert_sorted_with_merge_freeList+0x303>
  80357e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803582:	0f 85 bd fb ff ff    	jne    803145 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803588:	eb 01                	jmp    80358b <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80358a:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80358b:	90                   	nop
  80358c:	c9                   	leave  
  80358d:	c3                   	ret    

0080358e <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  80358e:	55                   	push   %ebp
  80358f:	89 e5                	mov    %esp,%ebp
  803591:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803594:	8b 55 08             	mov    0x8(%ebp),%edx
  803597:	89 d0                	mov    %edx,%eax
  803599:	c1 e0 02             	shl    $0x2,%eax
  80359c:	01 d0                	add    %edx,%eax
  80359e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8035a5:	01 d0                	add    %edx,%eax
  8035a7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8035ae:	01 d0                	add    %edx,%eax
  8035b0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8035b7:	01 d0                	add    %edx,%eax
  8035b9:	c1 e0 04             	shl    $0x4,%eax
  8035bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8035bf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8035c6:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8035c9:	83 ec 0c             	sub    $0xc,%esp
  8035cc:	50                   	push   %eax
  8035cd:	e8 26 e7 ff ff       	call   801cf8 <sys_get_virtual_time>
  8035d2:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8035d5:	eb 41                	jmp    803618 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8035d7:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8035da:	83 ec 0c             	sub    $0xc,%esp
  8035dd:	50                   	push   %eax
  8035de:	e8 15 e7 ff ff       	call   801cf8 <sys_get_virtual_time>
  8035e3:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8035e6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8035e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035ec:	29 c2                	sub    %eax,%edx
  8035ee:	89 d0                	mov    %edx,%eax
  8035f0:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8035f3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035f9:	89 d1                	mov    %edx,%ecx
  8035fb:	29 c1                	sub    %eax,%ecx
  8035fd:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803600:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803603:	39 c2                	cmp    %eax,%edx
  803605:	0f 97 c0             	seta   %al
  803608:	0f b6 c0             	movzbl %al,%eax
  80360b:	29 c1                	sub    %eax,%ecx
  80360d:	89 c8                	mov    %ecx,%eax
  80360f:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803612:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803615:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  803618:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80361b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80361e:	72 b7                	jb     8035d7 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803620:	90                   	nop
  803621:	c9                   	leave  
  803622:	c3                   	ret    

00803623 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803623:	55                   	push   %ebp
  803624:	89 e5                	mov    %esp,%ebp
  803626:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803629:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803630:	eb 03                	jmp    803635 <busy_wait+0x12>
  803632:	ff 45 fc             	incl   -0x4(%ebp)
  803635:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803638:	3b 45 08             	cmp    0x8(%ebp),%eax
  80363b:	72 f5                	jb     803632 <busy_wait+0xf>
	return i;
  80363d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803640:	c9                   	leave  
  803641:	c3                   	ret    
  803642:	66 90                	xchg   %ax,%ax

00803644 <__udivdi3>:
  803644:	55                   	push   %ebp
  803645:	57                   	push   %edi
  803646:	56                   	push   %esi
  803647:	53                   	push   %ebx
  803648:	83 ec 1c             	sub    $0x1c,%esp
  80364b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80364f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803653:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803657:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80365b:	89 ca                	mov    %ecx,%edx
  80365d:	89 f8                	mov    %edi,%eax
  80365f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803663:	85 f6                	test   %esi,%esi
  803665:	75 2d                	jne    803694 <__udivdi3+0x50>
  803667:	39 cf                	cmp    %ecx,%edi
  803669:	77 65                	ja     8036d0 <__udivdi3+0x8c>
  80366b:	89 fd                	mov    %edi,%ebp
  80366d:	85 ff                	test   %edi,%edi
  80366f:	75 0b                	jne    80367c <__udivdi3+0x38>
  803671:	b8 01 00 00 00       	mov    $0x1,%eax
  803676:	31 d2                	xor    %edx,%edx
  803678:	f7 f7                	div    %edi
  80367a:	89 c5                	mov    %eax,%ebp
  80367c:	31 d2                	xor    %edx,%edx
  80367e:	89 c8                	mov    %ecx,%eax
  803680:	f7 f5                	div    %ebp
  803682:	89 c1                	mov    %eax,%ecx
  803684:	89 d8                	mov    %ebx,%eax
  803686:	f7 f5                	div    %ebp
  803688:	89 cf                	mov    %ecx,%edi
  80368a:	89 fa                	mov    %edi,%edx
  80368c:	83 c4 1c             	add    $0x1c,%esp
  80368f:	5b                   	pop    %ebx
  803690:	5e                   	pop    %esi
  803691:	5f                   	pop    %edi
  803692:	5d                   	pop    %ebp
  803693:	c3                   	ret    
  803694:	39 ce                	cmp    %ecx,%esi
  803696:	77 28                	ja     8036c0 <__udivdi3+0x7c>
  803698:	0f bd fe             	bsr    %esi,%edi
  80369b:	83 f7 1f             	xor    $0x1f,%edi
  80369e:	75 40                	jne    8036e0 <__udivdi3+0x9c>
  8036a0:	39 ce                	cmp    %ecx,%esi
  8036a2:	72 0a                	jb     8036ae <__udivdi3+0x6a>
  8036a4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8036a8:	0f 87 9e 00 00 00    	ja     80374c <__udivdi3+0x108>
  8036ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8036b3:	89 fa                	mov    %edi,%edx
  8036b5:	83 c4 1c             	add    $0x1c,%esp
  8036b8:	5b                   	pop    %ebx
  8036b9:	5e                   	pop    %esi
  8036ba:	5f                   	pop    %edi
  8036bb:	5d                   	pop    %ebp
  8036bc:	c3                   	ret    
  8036bd:	8d 76 00             	lea    0x0(%esi),%esi
  8036c0:	31 ff                	xor    %edi,%edi
  8036c2:	31 c0                	xor    %eax,%eax
  8036c4:	89 fa                	mov    %edi,%edx
  8036c6:	83 c4 1c             	add    $0x1c,%esp
  8036c9:	5b                   	pop    %ebx
  8036ca:	5e                   	pop    %esi
  8036cb:	5f                   	pop    %edi
  8036cc:	5d                   	pop    %ebp
  8036cd:	c3                   	ret    
  8036ce:	66 90                	xchg   %ax,%ax
  8036d0:	89 d8                	mov    %ebx,%eax
  8036d2:	f7 f7                	div    %edi
  8036d4:	31 ff                	xor    %edi,%edi
  8036d6:	89 fa                	mov    %edi,%edx
  8036d8:	83 c4 1c             	add    $0x1c,%esp
  8036db:	5b                   	pop    %ebx
  8036dc:	5e                   	pop    %esi
  8036dd:	5f                   	pop    %edi
  8036de:	5d                   	pop    %ebp
  8036df:	c3                   	ret    
  8036e0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8036e5:	89 eb                	mov    %ebp,%ebx
  8036e7:	29 fb                	sub    %edi,%ebx
  8036e9:	89 f9                	mov    %edi,%ecx
  8036eb:	d3 e6                	shl    %cl,%esi
  8036ed:	89 c5                	mov    %eax,%ebp
  8036ef:	88 d9                	mov    %bl,%cl
  8036f1:	d3 ed                	shr    %cl,%ebp
  8036f3:	89 e9                	mov    %ebp,%ecx
  8036f5:	09 f1                	or     %esi,%ecx
  8036f7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8036fb:	89 f9                	mov    %edi,%ecx
  8036fd:	d3 e0                	shl    %cl,%eax
  8036ff:	89 c5                	mov    %eax,%ebp
  803701:	89 d6                	mov    %edx,%esi
  803703:	88 d9                	mov    %bl,%cl
  803705:	d3 ee                	shr    %cl,%esi
  803707:	89 f9                	mov    %edi,%ecx
  803709:	d3 e2                	shl    %cl,%edx
  80370b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80370f:	88 d9                	mov    %bl,%cl
  803711:	d3 e8                	shr    %cl,%eax
  803713:	09 c2                	or     %eax,%edx
  803715:	89 d0                	mov    %edx,%eax
  803717:	89 f2                	mov    %esi,%edx
  803719:	f7 74 24 0c          	divl   0xc(%esp)
  80371d:	89 d6                	mov    %edx,%esi
  80371f:	89 c3                	mov    %eax,%ebx
  803721:	f7 e5                	mul    %ebp
  803723:	39 d6                	cmp    %edx,%esi
  803725:	72 19                	jb     803740 <__udivdi3+0xfc>
  803727:	74 0b                	je     803734 <__udivdi3+0xf0>
  803729:	89 d8                	mov    %ebx,%eax
  80372b:	31 ff                	xor    %edi,%edi
  80372d:	e9 58 ff ff ff       	jmp    80368a <__udivdi3+0x46>
  803732:	66 90                	xchg   %ax,%ax
  803734:	8b 54 24 08          	mov    0x8(%esp),%edx
  803738:	89 f9                	mov    %edi,%ecx
  80373a:	d3 e2                	shl    %cl,%edx
  80373c:	39 c2                	cmp    %eax,%edx
  80373e:	73 e9                	jae    803729 <__udivdi3+0xe5>
  803740:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803743:	31 ff                	xor    %edi,%edi
  803745:	e9 40 ff ff ff       	jmp    80368a <__udivdi3+0x46>
  80374a:	66 90                	xchg   %ax,%ax
  80374c:	31 c0                	xor    %eax,%eax
  80374e:	e9 37 ff ff ff       	jmp    80368a <__udivdi3+0x46>
  803753:	90                   	nop

00803754 <__umoddi3>:
  803754:	55                   	push   %ebp
  803755:	57                   	push   %edi
  803756:	56                   	push   %esi
  803757:	53                   	push   %ebx
  803758:	83 ec 1c             	sub    $0x1c,%esp
  80375b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80375f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803763:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803767:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80376b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80376f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803773:	89 f3                	mov    %esi,%ebx
  803775:	89 fa                	mov    %edi,%edx
  803777:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80377b:	89 34 24             	mov    %esi,(%esp)
  80377e:	85 c0                	test   %eax,%eax
  803780:	75 1a                	jne    80379c <__umoddi3+0x48>
  803782:	39 f7                	cmp    %esi,%edi
  803784:	0f 86 a2 00 00 00    	jbe    80382c <__umoddi3+0xd8>
  80378a:	89 c8                	mov    %ecx,%eax
  80378c:	89 f2                	mov    %esi,%edx
  80378e:	f7 f7                	div    %edi
  803790:	89 d0                	mov    %edx,%eax
  803792:	31 d2                	xor    %edx,%edx
  803794:	83 c4 1c             	add    $0x1c,%esp
  803797:	5b                   	pop    %ebx
  803798:	5e                   	pop    %esi
  803799:	5f                   	pop    %edi
  80379a:	5d                   	pop    %ebp
  80379b:	c3                   	ret    
  80379c:	39 f0                	cmp    %esi,%eax
  80379e:	0f 87 ac 00 00 00    	ja     803850 <__umoddi3+0xfc>
  8037a4:	0f bd e8             	bsr    %eax,%ebp
  8037a7:	83 f5 1f             	xor    $0x1f,%ebp
  8037aa:	0f 84 ac 00 00 00    	je     80385c <__umoddi3+0x108>
  8037b0:	bf 20 00 00 00       	mov    $0x20,%edi
  8037b5:	29 ef                	sub    %ebp,%edi
  8037b7:	89 fe                	mov    %edi,%esi
  8037b9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8037bd:	89 e9                	mov    %ebp,%ecx
  8037bf:	d3 e0                	shl    %cl,%eax
  8037c1:	89 d7                	mov    %edx,%edi
  8037c3:	89 f1                	mov    %esi,%ecx
  8037c5:	d3 ef                	shr    %cl,%edi
  8037c7:	09 c7                	or     %eax,%edi
  8037c9:	89 e9                	mov    %ebp,%ecx
  8037cb:	d3 e2                	shl    %cl,%edx
  8037cd:	89 14 24             	mov    %edx,(%esp)
  8037d0:	89 d8                	mov    %ebx,%eax
  8037d2:	d3 e0                	shl    %cl,%eax
  8037d4:	89 c2                	mov    %eax,%edx
  8037d6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8037da:	d3 e0                	shl    %cl,%eax
  8037dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8037e0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8037e4:	89 f1                	mov    %esi,%ecx
  8037e6:	d3 e8                	shr    %cl,%eax
  8037e8:	09 d0                	or     %edx,%eax
  8037ea:	d3 eb                	shr    %cl,%ebx
  8037ec:	89 da                	mov    %ebx,%edx
  8037ee:	f7 f7                	div    %edi
  8037f0:	89 d3                	mov    %edx,%ebx
  8037f2:	f7 24 24             	mull   (%esp)
  8037f5:	89 c6                	mov    %eax,%esi
  8037f7:	89 d1                	mov    %edx,%ecx
  8037f9:	39 d3                	cmp    %edx,%ebx
  8037fb:	0f 82 87 00 00 00    	jb     803888 <__umoddi3+0x134>
  803801:	0f 84 91 00 00 00    	je     803898 <__umoddi3+0x144>
  803807:	8b 54 24 04          	mov    0x4(%esp),%edx
  80380b:	29 f2                	sub    %esi,%edx
  80380d:	19 cb                	sbb    %ecx,%ebx
  80380f:	89 d8                	mov    %ebx,%eax
  803811:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803815:	d3 e0                	shl    %cl,%eax
  803817:	89 e9                	mov    %ebp,%ecx
  803819:	d3 ea                	shr    %cl,%edx
  80381b:	09 d0                	or     %edx,%eax
  80381d:	89 e9                	mov    %ebp,%ecx
  80381f:	d3 eb                	shr    %cl,%ebx
  803821:	89 da                	mov    %ebx,%edx
  803823:	83 c4 1c             	add    $0x1c,%esp
  803826:	5b                   	pop    %ebx
  803827:	5e                   	pop    %esi
  803828:	5f                   	pop    %edi
  803829:	5d                   	pop    %ebp
  80382a:	c3                   	ret    
  80382b:	90                   	nop
  80382c:	89 fd                	mov    %edi,%ebp
  80382e:	85 ff                	test   %edi,%edi
  803830:	75 0b                	jne    80383d <__umoddi3+0xe9>
  803832:	b8 01 00 00 00       	mov    $0x1,%eax
  803837:	31 d2                	xor    %edx,%edx
  803839:	f7 f7                	div    %edi
  80383b:	89 c5                	mov    %eax,%ebp
  80383d:	89 f0                	mov    %esi,%eax
  80383f:	31 d2                	xor    %edx,%edx
  803841:	f7 f5                	div    %ebp
  803843:	89 c8                	mov    %ecx,%eax
  803845:	f7 f5                	div    %ebp
  803847:	89 d0                	mov    %edx,%eax
  803849:	e9 44 ff ff ff       	jmp    803792 <__umoddi3+0x3e>
  80384e:	66 90                	xchg   %ax,%ax
  803850:	89 c8                	mov    %ecx,%eax
  803852:	89 f2                	mov    %esi,%edx
  803854:	83 c4 1c             	add    $0x1c,%esp
  803857:	5b                   	pop    %ebx
  803858:	5e                   	pop    %esi
  803859:	5f                   	pop    %edi
  80385a:	5d                   	pop    %ebp
  80385b:	c3                   	ret    
  80385c:	3b 04 24             	cmp    (%esp),%eax
  80385f:	72 06                	jb     803867 <__umoddi3+0x113>
  803861:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803865:	77 0f                	ja     803876 <__umoddi3+0x122>
  803867:	89 f2                	mov    %esi,%edx
  803869:	29 f9                	sub    %edi,%ecx
  80386b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80386f:	89 14 24             	mov    %edx,(%esp)
  803872:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803876:	8b 44 24 04          	mov    0x4(%esp),%eax
  80387a:	8b 14 24             	mov    (%esp),%edx
  80387d:	83 c4 1c             	add    $0x1c,%esp
  803880:	5b                   	pop    %ebx
  803881:	5e                   	pop    %esi
  803882:	5f                   	pop    %edi
  803883:	5d                   	pop    %ebp
  803884:	c3                   	ret    
  803885:	8d 76 00             	lea    0x0(%esi),%esi
  803888:	2b 04 24             	sub    (%esp),%eax
  80388b:	19 fa                	sbb    %edi,%edx
  80388d:	89 d1                	mov    %edx,%ecx
  80388f:	89 c6                	mov    %eax,%esi
  803891:	e9 71 ff ff ff       	jmp    803807 <__umoddi3+0xb3>
  803896:	66 90                	xchg   %ax,%ax
  803898:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80389c:	72 ea                	jb     803888 <__umoddi3+0x134>
  80389e:	89 d9                	mov    %ebx,%ecx
  8038a0:	e9 62 ff ff ff       	jmp    803807 <__umoddi3+0xb3>
