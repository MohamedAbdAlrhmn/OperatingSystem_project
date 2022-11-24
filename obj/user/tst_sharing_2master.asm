
obj/user/tst_sharing_2master:     file format elf32-i386


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
  800031:	e8 28 03 00 00       	call   80035e <libmain>
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
  80004c:	a1 20 30 80 00       	mov    0x803020,%eax
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
  800075:	a1 20 30 80 00       	mov    0x803020,%eax
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
  80008d:	68 a0 1f 80 00       	push   $0x801fa0
  800092:	6a 13                	push   $0x13
  800094:	68 bc 1f 80 00       	push   $0x801fbc
  800099:	e8 fc 03 00 00       	call   80049a <_panic>
	}
	uint32 *x, *y, *z ;

	//x: Readonly
	int freeFrames = sys_calculate_free_frames() ;
  80009e:	e8 5e 16 00 00       	call   801701 <sys_calculate_free_frames>
  8000a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	x = smalloc("x", 4, 0);
  8000a6:	83 ec 04             	sub    $0x4,%esp
  8000a9:	6a 00                	push   $0x0
  8000ab:	6a 04                	push   $0x4
  8000ad:	68 d7 1f 80 00       	push   $0x801fd7
  8000b2:	e8 96 14 00 00       	call   80154d <smalloc>
  8000b7:	83 c4 10             	add    $0x10,%esp
  8000ba:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if (x != (uint32*)USER_HEAP_START) panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8000bd:	81 7d e8 00 00 00 80 	cmpl   $0x80000000,-0x18(%ebp)
  8000c4:	74 14                	je     8000da <_main+0xa2>
  8000c6:	83 ec 04             	sub    $0x4,%esp
  8000c9:	68 dc 1f 80 00       	push   $0x801fdc
  8000ce:	6a 1a                	push   $0x1a
  8000d0:	68 bc 1f 80 00       	push   $0x801fbc
  8000d5:	e8 c0 03 00 00       	call   80049a <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Create(): Wrong allocation- make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8000da:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000dd:	e8 1f 16 00 00       	call   801701 <sys_calculate_free_frames>
  8000e2:	29 c3                	sub    %eax,%ebx
  8000e4:	89 d8                	mov    %ebx,%eax
  8000e6:	83 f8 04             	cmp    $0x4,%eax
  8000e9:	74 14                	je     8000ff <_main+0xc7>
  8000eb:	83 ec 04             	sub    $0x4,%esp
  8000ee:	68 40 20 80 00       	push   $0x802040
  8000f3:	6a 1b                	push   $0x1b
  8000f5:	68 bc 1f 80 00       	push   $0x801fbc
  8000fa:	e8 9b 03 00 00       	call   80049a <_panic>

	//y: Readonly
	freeFrames = sys_calculate_free_frames() ;
  8000ff:	e8 fd 15 00 00       	call   801701 <sys_calculate_free_frames>
  800104:	89 45 ec             	mov    %eax,-0x14(%ebp)
	y = smalloc("y", 4, 0);
  800107:	83 ec 04             	sub    $0x4,%esp
  80010a:	6a 00                	push   $0x0
  80010c:	6a 04                	push   $0x4
  80010e:	68 c8 20 80 00       	push   $0x8020c8
  800113:	e8 35 14 00 00       	call   80154d <smalloc>
  800118:	83 c4 10             	add    $0x10,%esp
  80011b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (y != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  80011e:	81 7d e4 00 10 00 80 	cmpl   $0x80001000,-0x1c(%ebp)
  800125:	74 14                	je     80013b <_main+0x103>
  800127:	83 ec 04             	sub    $0x4,%esp
  80012a:	68 dc 1f 80 00       	push   $0x801fdc
  80012f:	6a 20                	push   $0x20
  800131:	68 bc 1f 80 00       	push   $0x801fbc
  800136:	e8 5f 03 00 00       	call   80049a <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1+0+2) panic("Create(): Wrong allocation- make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  80013b:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  80013e:	e8 be 15 00 00       	call   801701 <sys_calculate_free_frames>
  800143:	29 c3                	sub    %eax,%ebx
  800145:	89 d8                	mov    %ebx,%eax
  800147:	83 f8 03             	cmp    $0x3,%eax
  80014a:	74 14                	je     800160 <_main+0x128>
  80014c:	83 ec 04             	sub    $0x4,%esp
  80014f:	68 40 20 80 00       	push   $0x802040
  800154:	6a 21                	push   $0x21
  800156:	68 bc 1f 80 00       	push   $0x801fbc
  80015b:	e8 3a 03 00 00       	call   80049a <_panic>

	//z: Writable
	freeFrames = sys_calculate_free_frames() ;
  800160:	e8 9c 15 00 00       	call   801701 <sys_calculate_free_frames>
  800165:	89 45 ec             	mov    %eax,-0x14(%ebp)
	z = smalloc("z", 4, 1);
  800168:	83 ec 04             	sub    $0x4,%esp
  80016b:	6a 01                	push   $0x1
  80016d:	6a 04                	push   $0x4
  80016f:	68 ca 20 80 00       	push   $0x8020ca
  800174:	e8 d4 13 00 00       	call   80154d <smalloc>
  800179:	83 c4 10             	add    $0x10,%esp
  80017c:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (z != (uint32*)(USER_HEAP_START + 2 * PAGE_SIZE)) panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  80017f:	81 7d e0 00 20 00 80 	cmpl   $0x80002000,-0x20(%ebp)
  800186:	74 14                	je     80019c <_main+0x164>
  800188:	83 ec 04             	sub    $0x4,%esp
  80018b:	68 dc 1f 80 00       	push   $0x801fdc
  800190:	6a 26                	push   $0x26
  800192:	68 bc 1f 80 00       	push   $0x801fbc
  800197:	e8 fe 02 00 00       	call   80049a <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1+0+2) panic("Create(): Wrong allocation- make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  80019c:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  80019f:	e8 5d 15 00 00       	call   801701 <sys_calculate_free_frames>
  8001a4:	29 c3                	sub    %eax,%ebx
  8001a6:	89 d8                	mov    %ebx,%eax
  8001a8:	83 f8 03             	cmp    $0x3,%eax
  8001ab:	74 14                	je     8001c1 <_main+0x189>
  8001ad:	83 ec 04             	sub    $0x4,%esp
  8001b0:	68 40 20 80 00       	push   $0x802040
  8001b5:	6a 27                	push   $0x27
  8001b7:	68 bc 1f 80 00       	push   $0x801fbc
  8001bc:	e8 d9 02 00 00       	call   80049a <_panic>

	*x = 10 ;
  8001c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001c4:	c7 00 0a 00 00 00    	movl   $0xa,(%eax)
	*y = 20 ;
  8001ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001cd:	c7 00 14 00 00 00    	movl   $0x14,(%eax)

	int id1, id2, id3;
	id1 = sys_create_env("shr2Slave1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8001d3:	a1 20 30 80 00       	mov    0x803020,%eax
  8001d8:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  8001de:	a1 20 30 80 00       	mov    0x803020,%eax
  8001e3:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8001e9:	89 c1                	mov    %eax,%ecx
  8001eb:	a1 20 30 80 00       	mov    0x803020,%eax
  8001f0:	8b 40 74             	mov    0x74(%eax),%eax
  8001f3:	52                   	push   %edx
  8001f4:	51                   	push   %ecx
  8001f5:	50                   	push   %eax
  8001f6:	68 cc 20 80 00       	push   $0x8020cc
  8001fb:	e8 73 17 00 00       	call   801973 <sys_create_env>
  800200:	83 c4 10             	add    $0x10,%esp
  800203:	89 45 dc             	mov    %eax,-0x24(%ebp)
	id2 = sys_create_env("shr2Slave1", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  800206:	a1 20 30 80 00       	mov    0x803020,%eax
  80020b:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  800211:	a1 20 30 80 00       	mov    0x803020,%eax
  800216:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80021c:	89 c1                	mov    %eax,%ecx
  80021e:	a1 20 30 80 00       	mov    0x803020,%eax
  800223:	8b 40 74             	mov    0x74(%eax),%eax
  800226:	52                   	push   %edx
  800227:	51                   	push   %ecx
  800228:	50                   	push   %eax
  800229:	68 cc 20 80 00       	push   $0x8020cc
  80022e:	e8 40 17 00 00       	call   801973 <sys_create_env>
  800233:	83 c4 10             	add    $0x10,%esp
  800236:	89 45 d8             	mov    %eax,-0x28(%ebp)
	id3 = sys_create_env("shr2Slave1", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  800239:	a1 20 30 80 00       	mov    0x803020,%eax
  80023e:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  800244:	a1 20 30 80 00       	mov    0x803020,%eax
  800249:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80024f:	89 c1                	mov    %eax,%ecx
  800251:	a1 20 30 80 00       	mov    0x803020,%eax
  800256:	8b 40 74             	mov    0x74(%eax),%eax
  800259:	52                   	push   %edx
  80025a:	51                   	push   %ecx
  80025b:	50                   	push   %eax
  80025c:	68 cc 20 80 00       	push   $0x8020cc
  800261:	e8 0d 17 00 00       	call   801973 <sys_create_env>
  800266:	83 c4 10             	add    $0x10,%esp
  800269:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	//to check that the slave environments completed successfully
	rsttst();
  80026c:	e8 4e 18 00 00       	call   801abf <rsttst>

	sys_run_env(id1);
  800271:	83 ec 0c             	sub    $0xc,%esp
  800274:	ff 75 dc             	pushl  -0x24(%ebp)
  800277:	e8 15 17 00 00       	call   801991 <sys_run_env>
  80027c:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id2);
  80027f:	83 ec 0c             	sub    $0xc,%esp
  800282:	ff 75 d8             	pushl  -0x28(%ebp)
  800285:	e8 07 17 00 00       	call   801991 <sys_run_env>
  80028a:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id3);
  80028d:	83 ec 0c             	sub    $0xc,%esp
  800290:	ff 75 d4             	pushl  -0x2c(%ebp)
  800293:	e8 f9 16 00 00       	call   801991 <sys_run_env>
  800298:	83 c4 10             	add    $0x10,%esp

	env_sleep(12000) ;
  80029b:	83 ec 0c             	sub    $0xc,%esp
  80029e:	68 e0 2e 00 00       	push   $0x2ee0
  8002a3:	e8 cb 19 00 00       	call   801c73 <env_sleep>
  8002a8:	83 c4 10             	add    $0x10,%esp

	//to ensure that the slave environments completed successfully
	if (gettst()!=3) panic("test failed");
  8002ab:	e8 89 18 00 00       	call   801b39 <gettst>
  8002b0:	83 f8 03             	cmp    $0x3,%eax
  8002b3:	74 14                	je     8002c9 <_main+0x291>
  8002b5:	83 ec 04             	sub    $0x4,%esp
  8002b8:	68 d7 20 80 00       	push   $0x8020d7
  8002bd:	6a 3b                	push   $0x3b
  8002bf:	68 bc 1f 80 00       	push   $0x801fbc
  8002c4:	e8 d1 01 00 00       	call   80049a <_panic>


	if (*z != 30)
  8002c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002cc:	8b 00                	mov    (%eax),%eax
  8002ce:	83 f8 1e             	cmp    $0x1e,%eax
  8002d1:	74 14                	je     8002e7 <_main+0x2af>
		panic("Error!! Please check the creation (or the getting) of shared variables!!\n\n\n");
  8002d3:	83 ec 04             	sub    $0x4,%esp
  8002d6:	68 e4 20 80 00       	push   $0x8020e4
  8002db:	6a 3f                	push   $0x3f
  8002dd:	68 bc 1f 80 00       	push   $0x801fbc
  8002e2:	e8 b3 01 00 00       	call   80049a <_panic>
	else
		cprintf("Congratulations!! Test of Shared Variables [Create & Get] [2] completed successfully!!\n\n\n");
  8002e7:	83 ec 0c             	sub    $0xc,%esp
  8002ea:	68 30 21 80 00       	push   $0x802130
  8002ef:	e8 5a 04 00 00       	call   80074e <cprintf>
  8002f4:	83 c4 10             	add    $0x10,%esp

	cprintf("Now, ILLEGAL MEM ACCESS should be occur, due to attempting to write a ReadOnly variable\n\n\n");
  8002f7:	83 ec 0c             	sub    $0xc,%esp
  8002fa:	68 8c 21 80 00       	push   $0x80218c
  8002ff:	e8 4a 04 00 00       	call   80074e <cprintf>
  800304:	83 c4 10             	add    $0x10,%esp

	id1 = sys_create_env("shr2Slave2", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  800307:	a1 20 30 80 00       	mov    0x803020,%eax
  80030c:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  800312:	a1 20 30 80 00       	mov    0x803020,%eax
  800317:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80031d:	89 c1                	mov    %eax,%ecx
  80031f:	a1 20 30 80 00       	mov    0x803020,%eax
  800324:	8b 40 74             	mov    0x74(%eax),%eax
  800327:	52                   	push   %edx
  800328:	51                   	push   %ecx
  800329:	50                   	push   %eax
  80032a:	68 e7 21 80 00       	push   $0x8021e7
  80032f:	e8 3f 16 00 00       	call   801973 <sys_create_env>
  800334:	83 c4 10             	add    $0x10,%esp
  800337:	89 45 dc             	mov    %eax,-0x24(%ebp)

	env_sleep(3000) ;
  80033a:	83 ec 0c             	sub    $0xc,%esp
  80033d:	68 b8 0b 00 00       	push   $0xbb8
  800342:	e8 2c 19 00 00       	call   801c73 <env_sleep>
  800347:	83 c4 10             	add    $0x10,%esp

	sys_run_env(id1);
  80034a:	83 ec 0c             	sub    $0xc,%esp
  80034d:	ff 75 dc             	pushl  -0x24(%ebp)
  800350:	e8 3c 16 00 00       	call   801991 <sys_run_env>
  800355:	83 c4 10             	add    $0x10,%esp

	return;
  800358:	90                   	nop
}
  800359:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80035c:	c9                   	leave  
  80035d:	c3                   	ret    

0080035e <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80035e:	55                   	push   %ebp
  80035f:	89 e5                	mov    %esp,%ebp
  800361:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800364:	e8 78 16 00 00       	call   8019e1 <sys_getenvindex>
  800369:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80036c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80036f:	89 d0                	mov    %edx,%eax
  800371:	c1 e0 03             	shl    $0x3,%eax
  800374:	01 d0                	add    %edx,%eax
  800376:	01 c0                	add    %eax,%eax
  800378:	01 d0                	add    %edx,%eax
  80037a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800381:	01 d0                	add    %edx,%eax
  800383:	c1 e0 04             	shl    $0x4,%eax
  800386:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80038b:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800390:	a1 20 30 80 00       	mov    0x803020,%eax
  800395:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80039b:	84 c0                	test   %al,%al
  80039d:	74 0f                	je     8003ae <libmain+0x50>
		binaryname = myEnv->prog_name;
  80039f:	a1 20 30 80 00       	mov    0x803020,%eax
  8003a4:	05 5c 05 00 00       	add    $0x55c,%eax
  8003a9:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003ae:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8003b2:	7e 0a                	jle    8003be <libmain+0x60>
		binaryname = argv[0];
  8003b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003b7:	8b 00                	mov    (%eax),%eax
  8003b9:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8003be:	83 ec 08             	sub    $0x8,%esp
  8003c1:	ff 75 0c             	pushl  0xc(%ebp)
  8003c4:	ff 75 08             	pushl  0x8(%ebp)
  8003c7:	e8 6c fc ff ff       	call   800038 <_main>
  8003cc:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8003cf:	e8 1a 14 00 00       	call   8017ee <sys_disable_interrupt>
	cprintf("**************************************\n");
  8003d4:	83 ec 0c             	sub    $0xc,%esp
  8003d7:	68 0c 22 80 00       	push   $0x80220c
  8003dc:	e8 6d 03 00 00       	call   80074e <cprintf>
  8003e1:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8003e4:	a1 20 30 80 00       	mov    0x803020,%eax
  8003e9:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8003ef:	a1 20 30 80 00       	mov    0x803020,%eax
  8003f4:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8003fa:	83 ec 04             	sub    $0x4,%esp
  8003fd:	52                   	push   %edx
  8003fe:	50                   	push   %eax
  8003ff:	68 34 22 80 00       	push   $0x802234
  800404:	e8 45 03 00 00       	call   80074e <cprintf>
  800409:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80040c:	a1 20 30 80 00       	mov    0x803020,%eax
  800411:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800417:	a1 20 30 80 00       	mov    0x803020,%eax
  80041c:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800422:	a1 20 30 80 00       	mov    0x803020,%eax
  800427:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80042d:	51                   	push   %ecx
  80042e:	52                   	push   %edx
  80042f:	50                   	push   %eax
  800430:	68 5c 22 80 00       	push   $0x80225c
  800435:	e8 14 03 00 00       	call   80074e <cprintf>
  80043a:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80043d:	a1 20 30 80 00       	mov    0x803020,%eax
  800442:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800448:	83 ec 08             	sub    $0x8,%esp
  80044b:	50                   	push   %eax
  80044c:	68 b4 22 80 00       	push   $0x8022b4
  800451:	e8 f8 02 00 00       	call   80074e <cprintf>
  800456:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800459:	83 ec 0c             	sub    $0xc,%esp
  80045c:	68 0c 22 80 00       	push   $0x80220c
  800461:	e8 e8 02 00 00       	call   80074e <cprintf>
  800466:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800469:	e8 9a 13 00 00       	call   801808 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80046e:	e8 19 00 00 00       	call   80048c <exit>
}
  800473:	90                   	nop
  800474:	c9                   	leave  
  800475:	c3                   	ret    

00800476 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800476:	55                   	push   %ebp
  800477:	89 e5                	mov    %esp,%ebp
  800479:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80047c:	83 ec 0c             	sub    $0xc,%esp
  80047f:	6a 00                	push   $0x0
  800481:	e8 27 15 00 00       	call   8019ad <sys_destroy_env>
  800486:	83 c4 10             	add    $0x10,%esp
}
  800489:	90                   	nop
  80048a:	c9                   	leave  
  80048b:	c3                   	ret    

0080048c <exit>:

void
exit(void)
{
  80048c:	55                   	push   %ebp
  80048d:	89 e5                	mov    %esp,%ebp
  80048f:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800492:	e8 7c 15 00 00       	call   801a13 <sys_exit_env>
}
  800497:	90                   	nop
  800498:	c9                   	leave  
  800499:	c3                   	ret    

0080049a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80049a:	55                   	push   %ebp
  80049b:	89 e5                	mov    %esp,%ebp
  80049d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8004a0:	8d 45 10             	lea    0x10(%ebp),%eax
  8004a3:	83 c0 04             	add    $0x4,%eax
  8004a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8004a9:	a1 5c 31 80 00       	mov    0x80315c,%eax
  8004ae:	85 c0                	test   %eax,%eax
  8004b0:	74 16                	je     8004c8 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8004b2:	a1 5c 31 80 00       	mov    0x80315c,%eax
  8004b7:	83 ec 08             	sub    $0x8,%esp
  8004ba:	50                   	push   %eax
  8004bb:	68 c8 22 80 00       	push   $0x8022c8
  8004c0:	e8 89 02 00 00       	call   80074e <cprintf>
  8004c5:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8004c8:	a1 00 30 80 00       	mov    0x803000,%eax
  8004cd:	ff 75 0c             	pushl  0xc(%ebp)
  8004d0:	ff 75 08             	pushl  0x8(%ebp)
  8004d3:	50                   	push   %eax
  8004d4:	68 cd 22 80 00       	push   $0x8022cd
  8004d9:	e8 70 02 00 00       	call   80074e <cprintf>
  8004de:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8004e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8004e4:	83 ec 08             	sub    $0x8,%esp
  8004e7:	ff 75 f4             	pushl  -0xc(%ebp)
  8004ea:	50                   	push   %eax
  8004eb:	e8 f3 01 00 00       	call   8006e3 <vcprintf>
  8004f0:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8004f3:	83 ec 08             	sub    $0x8,%esp
  8004f6:	6a 00                	push   $0x0
  8004f8:	68 e9 22 80 00       	push   $0x8022e9
  8004fd:	e8 e1 01 00 00       	call   8006e3 <vcprintf>
  800502:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800505:	e8 82 ff ff ff       	call   80048c <exit>

	// should not return here
	while (1) ;
  80050a:	eb fe                	jmp    80050a <_panic+0x70>

0080050c <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80050c:	55                   	push   %ebp
  80050d:	89 e5                	mov    %esp,%ebp
  80050f:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800512:	a1 20 30 80 00       	mov    0x803020,%eax
  800517:	8b 50 74             	mov    0x74(%eax),%edx
  80051a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80051d:	39 c2                	cmp    %eax,%edx
  80051f:	74 14                	je     800535 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800521:	83 ec 04             	sub    $0x4,%esp
  800524:	68 ec 22 80 00       	push   $0x8022ec
  800529:	6a 26                	push   $0x26
  80052b:	68 38 23 80 00       	push   $0x802338
  800530:	e8 65 ff ff ff       	call   80049a <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800535:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80053c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800543:	e9 c2 00 00 00       	jmp    80060a <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800548:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80054b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800552:	8b 45 08             	mov    0x8(%ebp),%eax
  800555:	01 d0                	add    %edx,%eax
  800557:	8b 00                	mov    (%eax),%eax
  800559:	85 c0                	test   %eax,%eax
  80055b:	75 08                	jne    800565 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80055d:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800560:	e9 a2 00 00 00       	jmp    800607 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800565:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80056c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800573:	eb 69                	jmp    8005de <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800575:	a1 20 30 80 00       	mov    0x803020,%eax
  80057a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800580:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800583:	89 d0                	mov    %edx,%eax
  800585:	01 c0                	add    %eax,%eax
  800587:	01 d0                	add    %edx,%eax
  800589:	c1 e0 03             	shl    $0x3,%eax
  80058c:	01 c8                	add    %ecx,%eax
  80058e:	8a 40 04             	mov    0x4(%eax),%al
  800591:	84 c0                	test   %al,%al
  800593:	75 46                	jne    8005db <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800595:	a1 20 30 80 00       	mov    0x803020,%eax
  80059a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8005a0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005a3:	89 d0                	mov    %edx,%eax
  8005a5:	01 c0                	add    %eax,%eax
  8005a7:	01 d0                	add    %edx,%eax
  8005a9:	c1 e0 03             	shl    $0x3,%eax
  8005ac:	01 c8                	add    %ecx,%eax
  8005ae:	8b 00                	mov    (%eax),%eax
  8005b0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005b6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005bb:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8005bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005c0:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ca:	01 c8                	add    %ecx,%eax
  8005cc:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005ce:	39 c2                	cmp    %eax,%edx
  8005d0:	75 09                	jne    8005db <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8005d2:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8005d9:	eb 12                	jmp    8005ed <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005db:	ff 45 e8             	incl   -0x18(%ebp)
  8005de:	a1 20 30 80 00       	mov    0x803020,%eax
  8005e3:	8b 50 74             	mov    0x74(%eax),%edx
  8005e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005e9:	39 c2                	cmp    %eax,%edx
  8005eb:	77 88                	ja     800575 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8005ed:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8005f1:	75 14                	jne    800607 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8005f3:	83 ec 04             	sub    $0x4,%esp
  8005f6:	68 44 23 80 00       	push   $0x802344
  8005fb:	6a 3a                	push   $0x3a
  8005fd:	68 38 23 80 00       	push   $0x802338
  800602:	e8 93 fe ff ff       	call   80049a <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800607:	ff 45 f0             	incl   -0x10(%ebp)
  80060a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80060d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800610:	0f 8c 32 ff ff ff    	jl     800548 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800616:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80061d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800624:	eb 26                	jmp    80064c <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800626:	a1 20 30 80 00       	mov    0x803020,%eax
  80062b:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800631:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800634:	89 d0                	mov    %edx,%eax
  800636:	01 c0                	add    %eax,%eax
  800638:	01 d0                	add    %edx,%eax
  80063a:	c1 e0 03             	shl    $0x3,%eax
  80063d:	01 c8                	add    %ecx,%eax
  80063f:	8a 40 04             	mov    0x4(%eax),%al
  800642:	3c 01                	cmp    $0x1,%al
  800644:	75 03                	jne    800649 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800646:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800649:	ff 45 e0             	incl   -0x20(%ebp)
  80064c:	a1 20 30 80 00       	mov    0x803020,%eax
  800651:	8b 50 74             	mov    0x74(%eax),%edx
  800654:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800657:	39 c2                	cmp    %eax,%edx
  800659:	77 cb                	ja     800626 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80065b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80065e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800661:	74 14                	je     800677 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800663:	83 ec 04             	sub    $0x4,%esp
  800666:	68 98 23 80 00       	push   $0x802398
  80066b:	6a 44                	push   $0x44
  80066d:	68 38 23 80 00       	push   $0x802338
  800672:	e8 23 fe ff ff       	call   80049a <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800677:	90                   	nop
  800678:	c9                   	leave  
  800679:	c3                   	ret    

0080067a <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80067a:	55                   	push   %ebp
  80067b:	89 e5                	mov    %esp,%ebp
  80067d:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800680:	8b 45 0c             	mov    0xc(%ebp),%eax
  800683:	8b 00                	mov    (%eax),%eax
  800685:	8d 48 01             	lea    0x1(%eax),%ecx
  800688:	8b 55 0c             	mov    0xc(%ebp),%edx
  80068b:	89 0a                	mov    %ecx,(%edx)
  80068d:	8b 55 08             	mov    0x8(%ebp),%edx
  800690:	88 d1                	mov    %dl,%cl
  800692:	8b 55 0c             	mov    0xc(%ebp),%edx
  800695:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800699:	8b 45 0c             	mov    0xc(%ebp),%eax
  80069c:	8b 00                	mov    (%eax),%eax
  80069e:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006a3:	75 2c                	jne    8006d1 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8006a5:	a0 24 30 80 00       	mov    0x803024,%al
  8006aa:	0f b6 c0             	movzbl %al,%eax
  8006ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006b0:	8b 12                	mov    (%edx),%edx
  8006b2:	89 d1                	mov    %edx,%ecx
  8006b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006b7:	83 c2 08             	add    $0x8,%edx
  8006ba:	83 ec 04             	sub    $0x4,%esp
  8006bd:	50                   	push   %eax
  8006be:	51                   	push   %ecx
  8006bf:	52                   	push   %edx
  8006c0:	e8 7b 0f 00 00       	call   801640 <sys_cputs>
  8006c5:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006cb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006d4:	8b 40 04             	mov    0x4(%eax),%eax
  8006d7:	8d 50 01             	lea    0x1(%eax),%edx
  8006da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006dd:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006e0:	90                   	nop
  8006e1:	c9                   	leave  
  8006e2:	c3                   	ret    

008006e3 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006e3:	55                   	push   %ebp
  8006e4:	89 e5                	mov    %esp,%ebp
  8006e6:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006ec:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006f3:	00 00 00 
	b.cnt = 0;
  8006f6:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8006fd:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800700:	ff 75 0c             	pushl  0xc(%ebp)
  800703:	ff 75 08             	pushl  0x8(%ebp)
  800706:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80070c:	50                   	push   %eax
  80070d:	68 7a 06 80 00       	push   $0x80067a
  800712:	e8 11 02 00 00       	call   800928 <vprintfmt>
  800717:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80071a:	a0 24 30 80 00       	mov    0x803024,%al
  80071f:	0f b6 c0             	movzbl %al,%eax
  800722:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800728:	83 ec 04             	sub    $0x4,%esp
  80072b:	50                   	push   %eax
  80072c:	52                   	push   %edx
  80072d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800733:	83 c0 08             	add    $0x8,%eax
  800736:	50                   	push   %eax
  800737:	e8 04 0f 00 00       	call   801640 <sys_cputs>
  80073c:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80073f:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800746:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80074c:	c9                   	leave  
  80074d:	c3                   	ret    

0080074e <cprintf>:

int cprintf(const char *fmt, ...) {
  80074e:	55                   	push   %ebp
  80074f:	89 e5                	mov    %esp,%ebp
  800751:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800754:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  80075b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80075e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800761:	8b 45 08             	mov    0x8(%ebp),%eax
  800764:	83 ec 08             	sub    $0x8,%esp
  800767:	ff 75 f4             	pushl  -0xc(%ebp)
  80076a:	50                   	push   %eax
  80076b:	e8 73 ff ff ff       	call   8006e3 <vcprintf>
  800770:	83 c4 10             	add    $0x10,%esp
  800773:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800776:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800779:	c9                   	leave  
  80077a:	c3                   	ret    

0080077b <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80077b:	55                   	push   %ebp
  80077c:	89 e5                	mov    %esp,%ebp
  80077e:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800781:	e8 68 10 00 00       	call   8017ee <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800786:	8d 45 0c             	lea    0xc(%ebp),%eax
  800789:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80078c:	8b 45 08             	mov    0x8(%ebp),%eax
  80078f:	83 ec 08             	sub    $0x8,%esp
  800792:	ff 75 f4             	pushl  -0xc(%ebp)
  800795:	50                   	push   %eax
  800796:	e8 48 ff ff ff       	call   8006e3 <vcprintf>
  80079b:	83 c4 10             	add    $0x10,%esp
  80079e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8007a1:	e8 62 10 00 00       	call   801808 <sys_enable_interrupt>
	return cnt;
  8007a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007a9:	c9                   	leave  
  8007aa:	c3                   	ret    

008007ab <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007ab:	55                   	push   %ebp
  8007ac:	89 e5                	mov    %esp,%ebp
  8007ae:	53                   	push   %ebx
  8007af:	83 ec 14             	sub    $0x14,%esp
  8007b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8007b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007be:	8b 45 18             	mov    0x18(%ebp),%eax
  8007c1:	ba 00 00 00 00       	mov    $0x0,%edx
  8007c6:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007c9:	77 55                	ja     800820 <printnum+0x75>
  8007cb:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007ce:	72 05                	jb     8007d5 <printnum+0x2a>
  8007d0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8007d3:	77 4b                	ja     800820 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8007d5:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8007d8:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8007db:	8b 45 18             	mov    0x18(%ebp),%eax
  8007de:	ba 00 00 00 00       	mov    $0x0,%edx
  8007e3:	52                   	push   %edx
  8007e4:	50                   	push   %eax
  8007e5:	ff 75 f4             	pushl  -0xc(%ebp)
  8007e8:	ff 75 f0             	pushl  -0x10(%ebp)
  8007eb:	e8 38 15 00 00       	call   801d28 <__udivdi3>
  8007f0:	83 c4 10             	add    $0x10,%esp
  8007f3:	83 ec 04             	sub    $0x4,%esp
  8007f6:	ff 75 20             	pushl  0x20(%ebp)
  8007f9:	53                   	push   %ebx
  8007fa:	ff 75 18             	pushl  0x18(%ebp)
  8007fd:	52                   	push   %edx
  8007fe:	50                   	push   %eax
  8007ff:	ff 75 0c             	pushl  0xc(%ebp)
  800802:	ff 75 08             	pushl  0x8(%ebp)
  800805:	e8 a1 ff ff ff       	call   8007ab <printnum>
  80080a:	83 c4 20             	add    $0x20,%esp
  80080d:	eb 1a                	jmp    800829 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80080f:	83 ec 08             	sub    $0x8,%esp
  800812:	ff 75 0c             	pushl  0xc(%ebp)
  800815:	ff 75 20             	pushl  0x20(%ebp)
  800818:	8b 45 08             	mov    0x8(%ebp),%eax
  80081b:	ff d0                	call   *%eax
  80081d:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800820:	ff 4d 1c             	decl   0x1c(%ebp)
  800823:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800827:	7f e6                	jg     80080f <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800829:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80082c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800831:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800834:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800837:	53                   	push   %ebx
  800838:	51                   	push   %ecx
  800839:	52                   	push   %edx
  80083a:	50                   	push   %eax
  80083b:	e8 f8 15 00 00       	call   801e38 <__umoddi3>
  800840:	83 c4 10             	add    $0x10,%esp
  800843:	05 14 26 80 00       	add    $0x802614,%eax
  800848:	8a 00                	mov    (%eax),%al
  80084a:	0f be c0             	movsbl %al,%eax
  80084d:	83 ec 08             	sub    $0x8,%esp
  800850:	ff 75 0c             	pushl  0xc(%ebp)
  800853:	50                   	push   %eax
  800854:	8b 45 08             	mov    0x8(%ebp),%eax
  800857:	ff d0                	call   *%eax
  800859:	83 c4 10             	add    $0x10,%esp
}
  80085c:	90                   	nop
  80085d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800860:	c9                   	leave  
  800861:	c3                   	ret    

00800862 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800862:	55                   	push   %ebp
  800863:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800865:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800869:	7e 1c                	jle    800887 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80086b:	8b 45 08             	mov    0x8(%ebp),%eax
  80086e:	8b 00                	mov    (%eax),%eax
  800870:	8d 50 08             	lea    0x8(%eax),%edx
  800873:	8b 45 08             	mov    0x8(%ebp),%eax
  800876:	89 10                	mov    %edx,(%eax)
  800878:	8b 45 08             	mov    0x8(%ebp),%eax
  80087b:	8b 00                	mov    (%eax),%eax
  80087d:	83 e8 08             	sub    $0x8,%eax
  800880:	8b 50 04             	mov    0x4(%eax),%edx
  800883:	8b 00                	mov    (%eax),%eax
  800885:	eb 40                	jmp    8008c7 <getuint+0x65>
	else if (lflag)
  800887:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80088b:	74 1e                	je     8008ab <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80088d:	8b 45 08             	mov    0x8(%ebp),%eax
  800890:	8b 00                	mov    (%eax),%eax
  800892:	8d 50 04             	lea    0x4(%eax),%edx
  800895:	8b 45 08             	mov    0x8(%ebp),%eax
  800898:	89 10                	mov    %edx,(%eax)
  80089a:	8b 45 08             	mov    0x8(%ebp),%eax
  80089d:	8b 00                	mov    (%eax),%eax
  80089f:	83 e8 04             	sub    $0x4,%eax
  8008a2:	8b 00                	mov    (%eax),%eax
  8008a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8008a9:	eb 1c                	jmp    8008c7 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ae:	8b 00                	mov    (%eax),%eax
  8008b0:	8d 50 04             	lea    0x4(%eax),%edx
  8008b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b6:	89 10                	mov    %edx,(%eax)
  8008b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bb:	8b 00                	mov    (%eax),%eax
  8008bd:	83 e8 04             	sub    $0x4,%eax
  8008c0:	8b 00                	mov    (%eax),%eax
  8008c2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8008c7:	5d                   	pop    %ebp
  8008c8:	c3                   	ret    

008008c9 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008c9:	55                   	push   %ebp
  8008ca:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008cc:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008d0:	7e 1c                	jle    8008ee <getint+0x25>
		return va_arg(*ap, long long);
  8008d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d5:	8b 00                	mov    (%eax),%eax
  8008d7:	8d 50 08             	lea    0x8(%eax),%edx
  8008da:	8b 45 08             	mov    0x8(%ebp),%eax
  8008dd:	89 10                	mov    %edx,(%eax)
  8008df:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e2:	8b 00                	mov    (%eax),%eax
  8008e4:	83 e8 08             	sub    $0x8,%eax
  8008e7:	8b 50 04             	mov    0x4(%eax),%edx
  8008ea:	8b 00                	mov    (%eax),%eax
  8008ec:	eb 38                	jmp    800926 <getint+0x5d>
	else if (lflag)
  8008ee:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008f2:	74 1a                	je     80090e <getint+0x45>
		return va_arg(*ap, long);
  8008f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f7:	8b 00                	mov    (%eax),%eax
  8008f9:	8d 50 04             	lea    0x4(%eax),%edx
  8008fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ff:	89 10                	mov    %edx,(%eax)
  800901:	8b 45 08             	mov    0x8(%ebp),%eax
  800904:	8b 00                	mov    (%eax),%eax
  800906:	83 e8 04             	sub    $0x4,%eax
  800909:	8b 00                	mov    (%eax),%eax
  80090b:	99                   	cltd   
  80090c:	eb 18                	jmp    800926 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80090e:	8b 45 08             	mov    0x8(%ebp),%eax
  800911:	8b 00                	mov    (%eax),%eax
  800913:	8d 50 04             	lea    0x4(%eax),%edx
  800916:	8b 45 08             	mov    0x8(%ebp),%eax
  800919:	89 10                	mov    %edx,(%eax)
  80091b:	8b 45 08             	mov    0x8(%ebp),%eax
  80091e:	8b 00                	mov    (%eax),%eax
  800920:	83 e8 04             	sub    $0x4,%eax
  800923:	8b 00                	mov    (%eax),%eax
  800925:	99                   	cltd   
}
  800926:	5d                   	pop    %ebp
  800927:	c3                   	ret    

00800928 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800928:	55                   	push   %ebp
  800929:	89 e5                	mov    %esp,%ebp
  80092b:	56                   	push   %esi
  80092c:	53                   	push   %ebx
  80092d:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800930:	eb 17                	jmp    800949 <vprintfmt+0x21>
			if (ch == '\0')
  800932:	85 db                	test   %ebx,%ebx
  800934:	0f 84 af 03 00 00    	je     800ce9 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80093a:	83 ec 08             	sub    $0x8,%esp
  80093d:	ff 75 0c             	pushl  0xc(%ebp)
  800940:	53                   	push   %ebx
  800941:	8b 45 08             	mov    0x8(%ebp),%eax
  800944:	ff d0                	call   *%eax
  800946:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800949:	8b 45 10             	mov    0x10(%ebp),%eax
  80094c:	8d 50 01             	lea    0x1(%eax),%edx
  80094f:	89 55 10             	mov    %edx,0x10(%ebp)
  800952:	8a 00                	mov    (%eax),%al
  800954:	0f b6 d8             	movzbl %al,%ebx
  800957:	83 fb 25             	cmp    $0x25,%ebx
  80095a:	75 d6                	jne    800932 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80095c:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800960:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800967:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80096e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800975:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80097c:	8b 45 10             	mov    0x10(%ebp),%eax
  80097f:	8d 50 01             	lea    0x1(%eax),%edx
  800982:	89 55 10             	mov    %edx,0x10(%ebp)
  800985:	8a 00                	mov    (%eax),%al
  800987:	0f b6 d8             	movzbl %al,%ebx
  80098a:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80098d:	83 f8 55             	cmp    $0x55,%eax
  800990:	0f 87 2b 03 00 00    	ja     800cc1 <vprintfmt+0x399>
  800996:	8b 04 85 38 26 80 00 	mov    0x802638(,%eax,4),%eax
  80099d:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80099f:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009a3:	eb d7                	jmp    80097c <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009a5:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009a9:	eb d1                	jmp    80097c <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009ab:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009b2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009b5:	89 d0                	mov    %edx,%eax
  8009b7:	c1 e0 02             	shl    $0x2,%eax
  8009ba:	01 d0                	add    %edx,%eax
  8009bc:	01 c0                	add    %eax,%eax
  8009be:	01 d8                	add    %ebx,%eax
  8009c0:	83 e8 30             	sub    $0x30,%eax
  8009c3:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8009c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8009c9:	8a 00                	mov    (%eax),%al
  8009cb:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009ce:	83 fb 2f             	cmp    $0x2f,%ebx
  8009d1:	7e 3e                	jle    800a11 <vprintfmt+0xe9>
  8009d3:	83 fb 39             	cmp    $0x39,%ebx
  8009d6:	7f 39                	jg     800a11 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009d8:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009db:	eb d5                	jmp    8009b2 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8009dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e0:	83 c0 04             	add    $0x4,%eax
  8009e3:	89 45 14             	mov    %eax,0x14(%ebp)
  8009e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e9:	83 e8 04             	sub    $0x4,%eax
  8009ec:	8b 00                	mov    (%eax),%eax
  8009ee:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8009f1:	eb 1f                	jmp    800a12 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8009f3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009f7:	79 83                	jns    80097c <vprintfmt+0x54>
				width = 0;
  8009f9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a00:	e9 77 ff ff ff       	jmp    80097c <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a05:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a0c:	e9 6b ff ff ff       	jmp    80097c <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a11:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a12:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a16:	0f 89 60 ff ff ff    	jns    80097c <vprintfmt+0x54>
				width = precision, precision = -1;
  800a1c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a1f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a22:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a29:	e9 4e ff ff ff       	jmp    80097c <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a2e:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a31:	e9 46 ff ff ff       	jmp    80097c <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a36:	8b 45 14             	mov    0x14(%ebp),%eax
  800a39:	83 c0 04             	add    $0x4,%eax
  800a3c:	89 45 14             	mov    %eax,0x14(%ebp)
  800a3f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a42:	83 e8 04             	sub    $0x4,%eax
  800a45:	8b 00                	mov    (%eax),%eax
  800a47:	83 ec 08             	sub    $0x8,%esp
  800a4a:	ff 75 0c             	pushl  0xc(%ebp)
  800a4d:	50                   	push   %eax
  800a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a51:	ff d0                	call   *%eax
  800a53:	83 c4 10             	add    $0x10,%esp
			break;
  800a56:	e9 89 02 00 00       	jmp    800ce4 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a5b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a5e:	83 c0 04             	add    $0x4,%eax
  800a61:	89 45 14             	mov    %eax,0x14(%ebp)
  800a64:	8b 45 14             	mov    0x14(%ebp),%eax
  800a67:	83 e8 04             	sub    $0x4,%eax
  800a6a:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a6c:	85 db                	test   %ebx,%ebx
  800a6e:	79 02                	jns    800a72 <vprintfmt+0x14a>
				err = -err;
  800a70:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a72:	83 fb 64             	cmp    $0x64,%ebx
  800a75:	7f 0b                	jg     800a82 <vprintfmt+0x15a>
  800a77:	8b 34 9d 80 24 80 00 	mov    0x802480(,%ebx,4),%esi
  800a7e:	85 f6                	test   %esi,%esi
  800a80:	75 19                	jne    800a9b <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a82:	53                   	push   %ebx
  800a83:	68 25 26 80 00       	push   $0x802625
  800a88:	ff 75 0c             	pushl  0xc(%ebp)
  800a8b:	ff 75 08             	pushl  0x8(%ebp)
  800a8e:	e8 5e 02 00 00       	call   800cf1 <printfmt>
  800a93:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a96:	e9 49 02 00 00       	jmp    800ce4 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a9b:	56                   	push   %esi
  800a9c:	68 2e 26 80 00       	push   $0x80262e
  800aa1:	ff 75 0c             	pushl  0xc(%ebp)
  800aa4:	ff 75 08             	pushl  0x8(%ebp)
  800aa7:	e8 45 02 00 00       	call   800cf1 <printfmt>
  800aac:	83 c4 10             	add    $0x10,%esp
			break;
  800aaf:	e9 30 02 00 00       	jmp    800ce4 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800ab4:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab7:	83 c0 04             	add    $0x4,%eax
  800aba:	89 45 14             	mov    %eax,0x14(%ebp)
  800abd:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac0:	83 e8 04             	sub    $0x4,%eax
  800ac3:	8b 30                	mov    (%eax),%esi
  800ac5:	85 f6                	test   %esi,%esi
  800ac7:	75 05                	jne    800ace <vprintfmt+0x1a6>
				p = "(null)";
  800ac9:	be 31 26 80 00       	mov    $0x802631,%esi
			if (width > 0 && padc != '-')
  800ace:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ad2:	7e 6d                	jle    800b41 <vprintfmt+0x219>
  800ad4:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800ad8:	74 67                	je     800b41 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ada:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800add:	83 ec 08             	sub    $0x8,%esp
  800ae0:	50                   	push   %eax
  800ae1:	56                   	push   %esi
  800ae2:	e8 0c 03 00 00       	call   800df3 <strnlen>
  800ae7:	83 c4 10             	add    $0x10,%esp
  800aea:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800aed:	eb 16                	jmp    800b05 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800aef:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800af3:	83 ec 08             	sub    $0x8,%esp
  800af6:	ff 75 0c             	pushl  0xc(%ebp)
  800af9:	50                   	push   %eax
  800afa:	8b 45 08             	mov    0x8(%ebp),%eax
  800afd:	ff d0                	call   *%eax
  800aff:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b02:	ff 4d e4             	decl   -0x1c(%ebp)
  800b05:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b09:	7f e4                	jg     800aef <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b0b:	eb 34                	jmp    800b41 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b0d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b11:	74 1c                	je     800b2f <vprintfmt+0x207>
  800b13:	83 fb 1f             	cmp    $0x1f,%ebx
  800b16:	7e 05                	jle    800b1d <vprintfmt+0x1f5>
  800b18:	83 fb 7e             	cmp    $0x7e,%ebx
  800b1b:	7e 12                	jle    800b2f <vprintfmt+0x207>
					putch('?', putdat);
  800b1d:	83 ec 08             	sub    $0x8,%esp
  800b20:	ff 75 0c             	pushl  0xc(%ebp)
  800b23:	6a 3f                	push   $0x3f
  800b25:	8b 45 08             	mov    0x8(%ebp),%eax
  800b28:	ff d0                	call   *%eax
  800b2a:	83 c4 10             	add    $0x10,%esp
  800b2d:	eb 0f                	jmp    800b3e <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b2f:	83 ec 08             	sub    $0x8,%esp
  800b32:	ff 75 0c             	pushl  0xc(%ebp)
  800b35:	53                   	push   %ebx
  800b36:	8b 45 08             	mov    0x8(%ebp),%eax
  800b39:	ff d0                	call   *%eax
  800b3b:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b3e:	ff 4d e4             	decl   -0x1c(%ebp)
  800b41:	89 f0                	mov    %esi,%eax
  800b43:	8d 70 01             	lea    0x1(%eax),%esi
  800b46:	8a 00                	mov    (%eax),%al
  800b48:	0f be d8             	movsbl %al,%ebx
  800b4b:	85 db                	test   %ebx,%ebx
  800b4d:	74 24                	je     800b73 <vprintfmt+0x24b>
  800b4f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b53:	78 b8                	js     800b0d <vprintfmt+0x1e5>
  800b55:	ff 4d e0             	decl   -0x20(%ebp)
  800b58:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b5c:	79 af                	jns    800b0d <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b5e:	eb 13                	jmp    800b73 <vprintfmt+0x24b>
				putch(' ', putdat);
  800b60:	83 ec 08             	sub    $0x8,%esp
  800b63:	ff 75 0c             	pushl  0xc(%ebp)
  800b66:	6a 20                	push   $0x20
  800b68:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6b:	ff d0                	call   *%eax
  800b6d:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b70:	ff 4d e4             	decl   -0x1c(%ebp)
  800b73:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b77:	7f e7                	jg     800b60 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800b79:	e9 66 01 00 00       	jmp    800ce4 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b7e:	83 ec 08             	sub    $0x8,%esp
  800b81:	ff 75 e8             	pushl  -0x18(%ebp)
  800b84:	8d 45 14             	lea    0x14(%ebp),%eax
  800b87:	50                   	push   %eax
  800b88:	e8 3c fd ff ff       	call   8008c9 <getint>
  800b8d:	83 c4 10             	add    $0x10,%esp
  800b90:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b93:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800b96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b99:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b9c:	85 d2                	test   %edx,%edx
  800b9e:	79 23                	jns    800bc3 <vprintfmt+0x29b>
				putch('-', putdat);
  800ba0:	83 ec 08             	sub    $0x8,%esp
  800ba3:	ff 75 0c             	pushl  0xc(%ebp)
  800ba6:	6a 2d                	push   $0x2d
  800ba8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bab:	ff d0                	call   *%eax
  800bad:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800bb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bb3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bb6:	f7 d8                	neg    %eax
  800bb8:	83 d2 00             	adc    $0x0,%edx
  800bbb:	f7 da                	neg    %edx
  800bbd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bc0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800bc3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bca:	e9 bc 00 00 00       	jmp    800c8b <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800bcf:	83 ec 08             	sub    $0x8,%esp
  800bd2:	ff 75 e8             	pushl  -0x18(%ebp)
  800bd5:	8d 45 14             	lea    0x14(%ebp),%eax
  800bd8:	50                   	push   %eax
  800bd9:	e8 84 fc ff ff       	call   800862 <getuint>
  800bde:	83 c4 10             	add    $0x10,%esp
  800be1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800be4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800be7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bee:	e9 98 00 00 00       	jmp    800c8b <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800bf3:	83 ec 08             	sub    $0x8,%esp
  800bf6:	ff 75 0c             	pushl  0xc(%ebp)
  800bf9:	6a 58                	push   $0x58
  800bfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfe:	ff d0                	call   *%eax
  800c00:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c03:	83 ec 08             	sub    $0x8,%esp
  800c06:	ff 75 0c             	pushl  0xc(%ebp)
  800c09:	6a 58                	push   $0x58
  800c0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0e:	ff d0                	call   *%eax
  800c10:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c13:	83 ec 08             	sub    $0x8,%esp
  800c16:	ff 75 0c             	pushl  0xc(%ebp)
  800c19:	6a 58                	push   $0x58
  800c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1e:	ff d0                	call   *%eax
  800c20:	83 c4 10             	add    $0x10,%esp
			break;
  800c23:	e9 bc 00 00 00       	jmp    800ce4 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800c28:	83 ec 08             	sub    $0x8,%esp
  800c2b:	ff 75 0c             	pushl  0xc(%ebp)
  800c2e:	6a 30                	push   $0x30
  800c30:	8b 45 08             	mov    0x8(%ebp),%eax
  800c33:	ff d0                	call   *%eax
  800c35:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c38:	83 ec 08             	sub    $0x8,%esp
  800c3b:	ff 75 0c             	pushl  0xc(%ebp)
  800c3e:	6a 78                	push   $0x78
  800c40:	8b 45 08             	mov    0x8(%ebp),%eax
  800c43:	ff d0                	call   *%eax
  800c45:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c48:	8b 45 14             	mov    0x14(%ebp),%eax
  800c4b:	83 c0 04             	add    $0x4,%eax
  800c4e:	89 45 14             	mov    %eax,0x14(%ebp)
  800c51:	8b 45 14             	mov    0x14(%ebp),%eax
  800c54:	83 e8 04             	sub    $0x4,%eax
  800c57:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c59:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c5c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c63:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c6a:	eb 1f                	jmp    800c8b <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c6c:	83 ec 08             	sub    $0x8,%esp
  800c6f:	ff 75 e8             	pushl  -0x18(%ebp)
  800c72:	8d 45 14             	lea    0x14(%ebp),%eax
  800c75:	50                   	push   %eax
  800c76:	e8 e7 fb ff ff       	call   800862 <getuint>
  800c7b:	83 c4 10             	add    $0x10,%esp
  800c7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c81:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800c84:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c8b:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800c8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c92:	83 ec 04             	sub    $0x4,%esp
  800c95:	52                   	push   %edx
  800c96:	ff 75 e4             	pushl  -0x1c(%ebp)
  800c99:	50                   	push   %eax
  800c9a:	ff 75 f4             	pushl  -0xc(%ebp)
  800c9d:	ff 75 f0             	pushl  -0x10(%ebp)
  800ca0:	ff 75 0c             	pushl  0xc(%ebp)
  800ca3:	ff 75 08             	pushl  0x8(%ebp)
  800ca6:	e8 00 fb ff ff       	call   8007ab <printnum>
  800cab:	83 c4 20             	add    $0x20,%esp
			break;
  800cae:	eb 34                	jmp    800ce4 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800cb0:	83 ec 08             	sub    $0x8,%esp
  800cb3:	ff 75 0c             	pushl  0xc(%ebp)
  800cb6:	53                   	push   %ebx
  800cb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cba:	ff d0                	call   *%eax
  800cbc:	83 c4 10             	add    $0x10,%esp
			break;
  800cbf:	eb 23                	jmp    800ce4 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800cc1:	83 ec 08             	sub    $0x8,%esp
  800cc4:	ff 75 0c             	pushl  0xc(%ebp)
  800cc7:	6a 25                	push   $0x25
  800cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccc:	ff d0                	call   *%eax
  800cce:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800cd1:	ff 4d 10             	decl   0x10(%ebp)
  800cd4:	eb 03                	jmp    800cd9 <vprintfmt+0x3b1>
  800cd6:	ff 4d 10             	decl   0x10(%ebp)
  800cd9:	8b 45 10             	mov    0x10(%ebp),%eax
  800cdc:	48                   	dec    %eax
  800cdd:	8a 00                	mov    (%eax),%al
  800cdf:	3c 25                	cmp    $0x25,%al
  800ce1:	75 f3                	jne    800cd6 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800ce3:	90                   	nop
		}
	}
  800ce4:	e9 47 fc ff ff       	jmp    800930 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ce9:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800cea:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ced:	5b                   	pop    %ebx
  800cee:	5e                   	pop    %esi
  800cef:	5d                   	pop    %ebp
  800cf0:	c3                   	ret    

00800cf1 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800cf1:	55                   	push   %ebp
  800cf2:	89 e5                	mov    %esp,%ebp
  800cf4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800cf7:	8d 45 10             	lea    0x10(%ebp),%eax
  800cfa:	83 c0 04             	add    $0x4,%eax
  800cfd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d00:	8b 45 10             	mov    0x10(%ebp),%eax
  800d03:	ff 75 f4             	pushl  -0xc(%ebp)
  800d06:	50                   	push   %eax
  800d07:	ff 75 0c             	pushl  0xc(%ebp)
  800d0a:	ff 75 08             	pushl  0x8(%ebp)
  800d0d:	e8 16 fc ff ff       	call   800928 <vprintfmt>
  800d12:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d15:	90                   	nop
  800d16:	c9                   	leave  
  800d17:	c3                   	ret    

00800d18 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d18:	55                   	push   %ebp
  800d19:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1e:	8b 40 08             	mov    0x8(%eax),%eax
  800d21:	8d 50 01             	lea    0x1(%eax),%edx
  800d24:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d27:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2d:	8b 10                	mov    (%eax),%edx
  800d2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d32:	8b 40 04             	mov    0x4(%eax),%eax
  800d35:	39 c2                	cmp    %eax,%edx
  800d37:	73 12                	jae    800d4b <sprintputch+0x33>
		*b->buf++ = ch;
  800d39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3c:	8b 00                	mov    (%eax),%eax
  800d3e:	8d 48 01             	lea    0x1(%eax),%ecx
  800d41:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d44:	89 0a                	mov    %ecx,(%edx)
  800d46:	8b 55 08             	mov    0x8(%ebp),%edx
  800d49:	88 10                	mov    %dl,(%eax)
}
  800d4b:	90                   	nop
  800d4c:	5d                   	pop    %ebp
  800d4d:	c3                   	ret    

00800d4e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d4e:	55                   	push   %ebp
  800d4f:	89 e5                	mov    %esp,%ebp
  800d51:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d54:	8b 45 08             	mov    0x8(%ebp),%eax
  800d57:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d60:	8b 45 08             	mov    0x8(%ebp),%eax
  800d63:	01 d0                	add    %edx,%eax
  800d65:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d68:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d6f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d73:	74 06                	je     800d7b <vsnprintf+0x2d>
  800d75:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d79:	7f 07                	jg     800d82 <vsnprintf+0x34>
		return -E_INVAL;
  800d7b:	b8 03 00 00 00       	mov    $0x3,%eax
  800d80:	eb 20                	jmp    800da2 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d82:	ff 75 14             	pushl  0x14(%ebp)
  800d85:	ff 75 10             	pushl  0x10(%ebp)
  800d88:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d8b:	50                   	push   %eax
  800d8c:	68 18 0d 80 00       	push   $0x800d18
  800d91:	e8 92 fb ff ff       	call   800928 <vprintfmt>
  800d96:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800d99:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d9c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800da2:	c9                   	leave  
  800da3:	c3                   	ret    

00800da4 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800da4:	55                   	push   %ebp
  800da5:	89 e5                	mov    %esp,%ebp
  800da7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800daa:	8d 45 10             	lea    0x10(%ebp),%eax
  800dad:	83 c0 04             	add    $0x4,%eax
  800db0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800db3:	8b 45 10             	mov    0x10(%ebp),%eax
  800db6:	ff 75 f4             	pushl  -0xc(%ebp)
  800db9:	50                   	push   %eax
  800dba:	ff 75 0c             	pushl  0xc(%ebp)
  800dbd:	ff 75 08             	pushl  0x8(%ebp)
  800dc0:	e8 89 ff ff ff       	call   800d4e <vsnprintf>
  800dc5:	83 c4 10             	add    $0x10,%esp
  800dc8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800dcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800dce:	c9                   	leave  
  800dcf:	c3                   	ret    

00800dd0 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800dd0:	55                   	push   %ebp
  800dd1:	89 e5                	mov    %esp,%ebp
  800dd3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800dd6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ddd:	eb 06                	jmp    800de5 <strlen+0x15>
		n++;
  800ddf:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800de2:	ff 45 08             	incl   0x8(%ebp)
  800de5:	8b 45 08             	mov    0x8(%ebp),%eax
  800de8:	8a 00                	mov    (%eax),%al
  800dea:	84 c0                	test   %al,%al
  800dec:	75 f1                	jne    800ddf <strlen+0xf>
		n++;
	return n;
  800dee:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800df1:	c9                   	leave  
  800df2:	c3                   	ret    

00800df3 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800df3:	55                   	push   %ebp
  800df4:	89 e5                	mov    %esp,%ebp
  800df6:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800df9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e00:	eb 09                	jmp    800e0b <strnlen+0x18>
		n++;
  800e02:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e05:	ff 45 08             	incl   0x8(%ebp)
  800e08:	ff 4d 0c             	decl   0xc(%ebp)
  800e0b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e0f:	74 09                	je     800e1a <strnlen+0x27>
  800e11:	8b 45 08             	mov    0x8(%ebp),%eax
  800e14:	8a 00                	mov    (%eax),%al
  800e16:	84 c0                	test   %al,%al
  800e18:	75 e8                	jne    800e02 <strnlen+0xf>
		n++;
	return n;
  800e1a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e1d:	c9                   	leave  
  800e1e:	c3                   	ret    

00800e1f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e1f:	55                   	push   %ebp
  800e20:	89 e5                	mov    %esp,%ebp
  800e22:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e25:	8b 45 08             	mov    0x8(%ebp),%eax
  800e28:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e2b:	90                   	nop
  800e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2f:	8d 50 01             	lea    0x1(%eax),%edx
  800e32:	89 55 08             	mov    %edx,0x8(%ebp)
  800e35:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e38:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e3b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e3e:	8a 12                	mov    (%edx),%dl
  800e40:	88 10                	mov    %dl,(%eax)
  800e42:	8a 00                	mov    (%eax),%al
  800e44:	84 c0                	test   %al,%al
  800e46:	75 e4                	jne    800e2c <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e48:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e4b:	c9                   	leave  
  800e4c:	c3                   	ret    

00800e4d <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e4d:	55                   	push   %ebp
  800e4e:	89 e5                	mov    %esp,%ebp
  800e50:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e53:	8b 45 08             	mov    0x8(%ebp),%eax
  800e56:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e59:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e60:	eb 1f                	jmp    800e81 <strncpy+0x34>
		*dst++ = *src;
  800e62:	8b 45 08             	mov    0x8(%ebp),%eax
  800e65:	8d 50 01             	lea    0x1(%eax),%edx
  800e68:	89 55 08             	mov    %edx,0x8(%ebp)
  800e6b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e6e:	8a 12                	mov    (%edx),%dl
  800e70:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800e72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e75:	8a 00                	mov    (%eax),%al
  800e77:	84 c0                	test   %al,%al
  800e79:	74 03                	je     800e7e <strncpy+0x31>
			src++;
  800e7b:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e7e:	ff 45 fc             	incl   -0x4(%ebp)
  800e81:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e84:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e87:	72 d9                	jb     800e62 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800e89:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e8c:	c9                   	leave  
  800e8d:	c3                   	ret    

00800e8e <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800e8e:	55                   	push   %ebp
  800e8f:	89 e5                	mov    %esp,%ebp
  800e91:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800e94:	8b 45 08             	mov    0x8(%ebp),%eax
  800e97:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800e9a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e9e:	74 30                	je     800ed0 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ea0:	eb 16                	jmp    800eb8 <strlcpy+0x2a>
			*dst++ = *src++;
  800ea2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea5:	8d 50 01             	lea    0x1(%eax),%edx
  800ea8:	89 55 08             	mov    %edx,0x8(%ebp)
  800eab:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eae:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eb1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800eb4:	8a 12                	mov    (%edx),%dl
  800eb6:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800eb8:	ff 4d 10             	decl   0x10(%ebp)
  800ebb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ebf:	74 09                	je     800eca <strlcpy+0x3c>
  800ec1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec4:	8a 00                	mov    (%eax),%al
  800ec6:	84 c0                	test   %al,%al
  800ec8:	75 d8                	jne    800ea2 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800eca:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecd:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ed0:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ed6:	29 c2                	sub    %eax,%edx
  800ed8:	89 d0                	mov    %edx,%eax
}
  800eda:	c9                   	leave  
  800edb:	c3                   	ret    

00800edc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800edc:	55                   	push   %ebp
  800edd:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800edf:	eb 06                	jmp    800ee7 <strcmp+0xb>
		p++, q++;
  800ee1:	ff 45 08             	incl   0x8(%ebp)
  800ee4:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ee7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eea:	8a 00                	mov    (%eax),%al
  800eec:	84 c0                	test   %al,%al
  800eee:	74 0e                	je     800efe <strcmp+0x22>
  800ef0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef3:	8a 10                	mov    (%eax),%dl
  800ef5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef8:	8a 00                	mov    (%eax),%al
  800efa:	38 c2                	cmp    %al,%dl
  800efc:	74 e3                	je     800ee1 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800efe:	8b 45 08             	mov    0x8(%ebp),%eax
  800f01:	8a 00                	mov    (%eax),%al
  800f03:	0f b6 d0             	movzbl %al,%edx
  800f06:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f09:	8a 00                	mov    (%eax),%al
  800f0b:	0f b6 c0             	movzbl %al,%eax
  800f0e:	29 c2                	sub    %eax,%edx
  800f10:	89 d0                	mov    %edx,%eax
}
  800f12:	5d                   	pop    %ebp
  800f13:	c3                   	ret    

00800f14 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f14:	55                   	push   %ebp
  800f15:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f17:	eb 09                	jmp    800f22 <strncmp+0xe>
		n--, p++, q++;
  800f19:	ff 4d 10             	decl   0x10(%ebp)
  800f1c:	ff 45 08             	incl   0x8(%ebp)
  800f1f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f22:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f26:	74 17                	je     800f3f <strncmp+0x2b>
  800f28:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2b:	8a 00                	mov    (%eax),%al
  800f2d:	84 c0                	test   %al,%al
  800f2f:	74 0e                	je     800f3f <strncmp+0x2b>
  800f31:	8b 45 08             	mov    0x8(%ebp),%eax
  800f34:	8a 10                	mov    (%eax),%dl
  800f36:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f39:	8a 00                	mov    (%eax),%al
  800f3b:	38 c2                	cmp    %al,%dl
  800f3d:	74 da                	je     800f19 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f3f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f43:	75 07                	jne    800f4c <strncmp+0x38>
		return 0;
  800f45:	b8 00 00 00 00       	mov    $0x0,%eax
  800f4a:	eb 14                	jmp    800f60 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4f:	8a 00                	mov    (%eax),%al
  800f51:	0f b6 d0             	movzbl %al,%edx
  800f54:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f57:	8a 00                	mov    (%eax),%al
  800f59:	0f b6 c0             	movzbl %al,%eax
  800f5c:	29 c2                	sub    %eax,%edx
  800f5e:	89 d0                	mov    %edx,%eax
}
  800f60:	5d                   	pop    %ebp
  800f61:	c3                   	ret    

00800f62 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f62:	55                   	push   %ebp
  800f63:	89 e5                	mov    %esp,%ebp
  800f65:	83 ec 04             	sub    $0x4,%esp
  800f68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f6e:	eb 12                	jmp    800f82 <strchr+0x20>
		if (*s == c)
  800f70:	8b 45 08             	mov    0x8(%ebp),%eax
  800f73:	8a 00                	mov    (%eax),%al
  800f75:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f78:	75 05                	jne    800f7f <strchr+0x1d>
			return (char *) s;
  800f7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7d:	eb 11                	jmp    800f90 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800f7f:	ff 45 08             	incl   0x8(%ebp)
  800f82:	8b 45 08             	mov    0x8(%ebp),%eax
  800f85:	8a 00                	mov    (%eax),%al
  800f87:	84 c0                	test   %al,%al
  800f89:	75 e5                	jne    800f70 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800f8b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f90:	c9                   	leave  
  800f91:	c3                   	ret    

00800f92 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f92:	55                   	push   %ebp
  800f93:	89 e5                	mov    %esp,%ebp
  800f95:	83 ec 04             	sub    $0x4,%esp
  800f98:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f9b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f9e:	eb 0d                	jmp    800fad <strfind+0x1b>
		if (*s == c)
  800fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa3:	8a 00                	mov    (%eax),%al
  800fa5:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fa8:	74 0e                	je     800fb8 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800faa:	ff 45 08             	incl   0x8(%ebp)
  800fad:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb0:	8a 00                	mov    (%eax),%al
  800fb2:	84 c0                	test   %al,%al
  800fb4:	75 ea                	jne    800fa0 <strfind+0xe>
  800fb6:	eb 01                	jmp    800fb9 <strfind+0x27>
		if (*s == c)
			break;
  800fb8:	90                   	nop
	return (char *) s;
  800fb9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fbc:	c9                   	leave  
  800fbd:	c3                   	ret    

00800fbe <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800fbe:	55                   	push   %ebp
  800fbf:	89 e5                	mov    %esp,%ebp
  800fc1:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800fc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800fca:	8b 45 10             	mov    0x10(%ebp),%eax
  800fcd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800fd0:	eb 0e                	jmp    800fe0 <memset+0x22>
		*p++ = c;
  800fd2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fd5:	8d 50 01             	lea    0x1(%eax),%edx
  800fd8:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800fdb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fde:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800fe0:	ff 4d f8             	decl   -0x8(%ebp)
  800fe3:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800fe7:	79 e9                	jns    800fd2 <memset+0x14>
		*p++ = c;

	return v;
  800fe9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fec:	c9                   	leave  
  800fed:	c3                   	ret    

00800fee <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800fee:	55                   	push   %ebp
  800fef:	89 e5                	mov    %esp,%ebp
  800ff1:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ff4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ffa:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801000:	eb 16                	jmp    801018 <memcpy+0x2a>
		*d++ = *s++;
  801002:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801005:	8d 50 01             	lea    0x1(%eax),%edx
  801008:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80100b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80100e:	8d 4a 01             	lea    0x1(%edx),%ecx
  801011:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801014:	8a 12                	mov    (%edx),%dl
  801016:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801018:	8b 45 10             	mov    0x10(%ebp),%eax
  80101b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80101e:	89 55 10             	mov    %edx,0x10(%ebp)
  801021:	85 c0                	test   %eax,%eax
  801023:	75 dd                	jne    801002 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801025:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801028:	c9                   	leave  
  801029:	c3                   	ret    

0080102a <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80102a:	55                   	push   %ebp
  80102b:	89 e5                	mov    %esp,%ebp
  80102d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801030:	8b 45 0c             	mov    0xc(%ebp),%eax
  801033:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801036:	8b 45 08             	mov    0x8(%ebp),%eax
  801039:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80103c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80103f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801042:	73 50                	jae    801094 <memmove+0x6a>
  801044:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801047:	8b 45 10             	mov    0x10(%ebp),%eax
  80104a:	01 d0                	add    %edx,%eax
  80104c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80104f:	76 43                	jbe    801094 <memmove+0x6a>
		s += n;
  801051:	8b 45 10             	mov    0x10(%ebp),%eax
  801054:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801057:	8b 45 10             	mov    0x10(%ebp),%eax
  80105a:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80105d:	eb 10                	jmp    80106f <memmove+0x45>
			*--d = *--s;
  80105f:	ff 4d f8             	decl   -0x8(%ebp)
  801062:	ff 4d fc             	decl   -0x4(%ebp)
  801065:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801068:	8a 10                	mov    (%eax),%dl
  80106a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80106d:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80106f:	8b 45 10             	mov    0x10(%ebp),%eax
  801072:	8d 50 ff             	lea    -0x1(%eax),%edx
  801075:	89 55 10             	mov    %edx,0x10(%ebp)
  801078:	85 c0                	test   %eax,%eax
  80107a:	75 e3                	jne    80105f <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80107c:	eb 23                	jmp    8010a1 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80107e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801081:	8d 50 01             	lea    0x1(%eax),%edx
  801084:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801087:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80108a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80108d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801090:	8a 12                	mov    (%edx),%dl
  801092:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801094:	8b 45 10             	mov    0x10(%ebp),%eax
  801097:	8d 50 ff             	lea    -0x1(%eax),%edx
  80109a:	89 55 10             	mov    %edx,0x10(%ebp)
  80109d:	85 c0                	test   %eax,%eax
  80109f:	75 dd                	jne    80107e <memmove+0x54>
			*d++ = *s++;

	return dst;
  8010a1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010a4:	c9                   	leave  
  8010a5:	c3                   	ret    

008010a6 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8010a6:	55                   	push   %ebp
  8010a7:	89 e5                	mov    %esp,%ebp
  8010a9:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8010ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8010af:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8010b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b5:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8010b8:	eb 2a                	jmp    8010e4 <memcmp+0x3e>
		if (*s1 != *s2)
  8010ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010bd:	8a 10                	mov    (%eax),%dl
  8010bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010c2:	8a 00                	mov    (%eax),%al
  8010c4:	38 c2                	cmp    %al,%dl
  8010c6:	74 16                	je     8010de <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8010c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010cb:	8a 00                	mov    (%eax),%al
  8010cd:	0f b6 d0             	movzbl %al,%edx
  8010d0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010d3:	8a 00                	mov    (%eax),%al
  8010d5:	0f b6 c0             	movzbl %al,%eax
  8010d8:	29 c2                	sub    %eax,%edx
  8010da:	89 d0                	mov    %edx,%eax
  8010dc:	eb 18                	jmp    8010f6 <memcmp+0x50>
		s1++, s2++;
  8010de:	ff 45 fc             	incl   -0x4(%ebp)
  8010e1:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8010e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8010e7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010ea:	89 55 10             	mov    %edx,0x10(%ebp)
  8010ed:	85 c0                	test   %eax,%eax
  8010ef:	75 c9                	jne    8010ba <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8010f1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010f6:	c9                   	leave  
  8010f7:	c3                   	ret    

008010f8 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8010f8:	55                   	push   %ebp
  8010f9:	89 e5                	mov    %esp,%ebp
  8010fb:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8010fe:	8b 55 08             	mov    0x8(%ebp),%edx
  801101:	8b 45 10             	mov    0x10(%ebp),%eax
  801104:	01 d0                	add    %edx,%eax
  801106:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801109:	eb 15                	jmp    801120 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80110b:	8b 45 08             	mov    0x8(%ebp),%eax
  80110e:	8a 00                	mov    (%eax),%al
  801110:	0f b6 d0             	movzbl %al,%edx
  801113:	8b 45 0c             	mov    0xc(%ebp),%eax
  801116:	0f b6 c0             	movzbl %al,%eax
  801119:	39 c2                	cmp    %eax,%edx
  80111b:	74 0d                	je     80112a <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80111d:	ff 45 08             	incl   0x8(%ebp)
  801120:	8b 45 08             	mov    0x8(%ebp),%eax
  801123:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801126:	72 e3                	jb     80110b <memfind+0x13>
  801128:	eb 01                	jmp    80112b <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80112a:	90                   	nop
	return (void *) s;
  80112b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80112e:	c9                   	leave  
  80112f:	c3                   	ret    

00801130 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801130:	55                   	push   %ebp
  801131:	89 e5                	mov    %esp,%ebp
  801133:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801136:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80113d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801144:	eb 03                	jmp    801149 <strtol+0x19>
		s++;
  801146:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801149:	8b 45 08             	mov    0x8(%ebp),%eax
  80114c:	8a 00                	mov    (%eax),%al
  80114e:	3c 20                	cmp    $0x20,%al
  801150:	74 f4                	je     801146 <strtol+0x16>
  801152:	8b 45 08             	mov    0x8(%ebp),%eax
  801155:	8a 00                	mov    (%eax),%al
  801157:	3c 09                	cmp    $0x9,%al
  801159:	74 eb                	je     801146 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80115b:	8b 45 08             	mov    0x8(%ebp),%eax
  80115e:	8a 00                	mov    (%eax),%al
  801160:	3c 2b                	cmp    $0x2b,%al
  801162:	75 05                	jne    801169 <strtol+0x39>
		s++;
  801164:	ff 45 08             	incl   0x8(%ebp)
  801167:	eb 13                	jmp    80117c <strtol+0x4c>
	else if (*s == '-')
  801169:	8b 45 08             	mov    0x8(%ebp),%eax
  80116c:	8a 00                	mov    (%eax),%al
  80116e:	3c 2d                	cmp    $0x2d,%al
  801170:	75 0a                	jne    80117c <strtol+0x4c>
		s++, neg = 1;
  801172:	ff 45 08             	incl   0x8(%ebp)
  801175:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80117c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801180:	74 06                	je     801188 <strtol+0x58>
  801182:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801186:	75 20                	jne    8011a8 <strtol+0x78>
  801188:	8b 45 08             	mov    0x8(%ebp),%eax
  80118b:	8a 00                	mov    (%eax),%al
  80118d:	3c 30                	cmp    $0x30,%al
  80118f:	75 17                	jne    8011a8 <strtol+0x78>
  801191:	8b 45 08             	mov    0x8(%ebp),%eax
  801194:	40                   	inc    %eax
  801195:	8a 00                	mov    (%eax),%al
  801197:	3c 78                	cmp    $0x78,%al
  801199:	75 0d                	jne    8011a8 <strtol+0x78>
		s += 2, base = 16;
  80119b:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80119f:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8011a6:	eb 28                	jmp    8011d0 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8011a8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011ac:	75 15                	jne    8011c3 <strtol+0x93>
  8011ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b1:	8a 00                	mov    (%eax),%al
  8011b3:	3c 30                	cmp    $0x30,%al
  8011b5:	75 0c                	jne    8011c3 <strtol+0x93>
		s++, base = 8;
  8011b7:	ff 45 08             	incl   0x8(%ebp)
  8011ba:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8011c1:	eb 0d                	jmp    8011d0 <strtol+0xa0>
	else if (base == 0)
  8011c3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011c7:	75 07                	jne    8011d0 <strtol+0xa0>
		base = 10;
  8011c9:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8011d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d3:	8a 00                	mov    (%eax),%al
  8011d5:	3c 2f                	cmp    $0x2f,%al
  8011d7:	7e 19                	jle    8011f2 <strtol+0xc2>
  8011d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011dc:	8a 00                	mov    (%eax),%al
  8011de:	3c 39                	cmp    $0x39,%al
  8011e0:	7f 10                	jg     8011f2 <strtol+0xc2>
			dig = *s - '0';
  8011e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e5:	8a 00                	mov    (%eax),%al
  8011e7:	0f be c0             	movsbl %al,%eax
  8011ea:	83 e8 30             	sub    $0x30,%eax
  8011ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011f0:	eb 42                	jmp    801234 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8011f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f5:	8a 00                	mov    (%eax),%al
  8011f7:	3c 60                	cmp    $0x60,%al
  8011f9:	7e 19                	jle    801214 <strtol+0xe4>
  8011fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fe:	8a 00                	mov    (%eax),%al
  801200:	3c 7a                	cmp    $0x7a,%al
  801202:	7f 10                	jg     801214 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801204:	8b 45 08             	mov    0x8(%ebp),%eax
  801207:	8a 00                	mov    (%eax),%al
  801209:	0f be c0             	movsbl %al,%eax
  80120c:	83 e8 57             	sub    $0x57,%eax
  80120f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801212:	eb 20                	jmp    801234 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801214:	8b 45 08             	mov    0x8(%ebp),%eax
  801217:	8a 00                	mov    (%eax),%al
  801219:	3c 40                	cmp    $0x40,%al
  80121b:	7e 39                	jle    801256 <strtol+0x126>
  80121d:	8b 45 08             	mov    0x8(%ebp),%eax
  801220:	8a 00                	mov    (%eax),%al
  801222:	3c 5a                	cmp    $0x5a,%al
  801224:	7f 30                	jg     801256 <strtol+0x126>
			dig = *s - 'A' + 10;
  801226:	8b 45 08             	mov    0x8(%ebp),%eax
  801229:	8a 00                	mov    (%eax),%al
  80122b:	0f be c0             	movsbl %al,%eax
  80122e:	83 e8 37             	sub    $0x37,%eax
  801231:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801234:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801237:	3b 45 10             	cmp    0x10(%ebp),%eax
  80123a:	7d 19                	jge    801255 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80123c:	ff 45 08             	incl   0x8(%ebp)
  80123f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801242:	0f af 45 10          	imul   0x10(%ebp),%eax
  801246:	89 c2                	mov    %eax,%edx
  801248:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80124b:	01 d0                	add    %edx,%eax
  80124d:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801250:	e9 7b ff ff ff       	jmp    8011d0 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801255:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801256:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80125a:	74 08                	je     801264 <strtol+0x134>
		*endptr = (char *) s;
  80125c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125f:	8b 55 08             	mov    0x8(%ebp),%edx
  801262:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801264:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801268:	74 07                	je     801271 <strtol+0x141>
  80126a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80126d:	f7 d8                	neg    %eax
  80126f:	eb 03                	jmp    801274 <strtol+0x144>
  801271:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801274:	c9                   	leave  
  801275:	c3                   	ret    

00801276 <ltostr>:

void
ltostr(long value, char *str)
{
  801276:	55                   	push   %ebp
  801277:	89 e5                	mov    %esp,%ebp
  801279:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80127c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801283:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80128a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80128e:	79 13                	jns    8012a3 <ltostr+0x2d>
	{
		neg = 1;
  801290:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801297:	8b 45 0c             	mov    0xc(%ebp),%eax
  80129a:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80129d:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8012a0:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8012a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a6:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8012ab:	99                   	cltd   
  8012ac:	f7 f9                	idiv   %ecx
  8012ae:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8012b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012b4:	8d 50 01             	lea    0x1(%eax),%edx
  8012b7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012ba:	89 c2                	mov    %eax,%edx
  8012bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012bf:	01 d0                	add    %edx,%eax
  8012c1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012c4:	83 c2 30             	add    $0x30,%edx
  8012c7:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8012c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012cc:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012d1:	f7 e9                	imul   %ecx
  8012d3:	c1 fa 02             	sar    $0x2,%edx
  8012d6:	89 c8                	mov    %ecx,%eax
  8012d8:	c1 f8 1f             	sar    $0x1f,%eax
  8012db:	29 c2                	sub    %eax,%edx
  8012dd:	89 d0                	mov    %edx,%eax
  8012df:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8012e2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012e5:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012ea:	f7 e9                	imul   %ecx
  8012ec:	c1 fa 02             	sar    $0x2,%edx
  8012ef:	89 c8                	mov    %ecx,%eax
  8012f1:	c1 f8 1f             	sar    $0x1f,%eax
  8012f4:	29 c2                	sub    %eax,%edx
  8012f6:	89 d0                	mov    %edx,%eax
  8012f8:	c1 e0 02             	shl    $0x2,%eax
  8012fb:	01 d0                	add    %edx,%eax
  8012fd:	01 c0                	add    %eax,%eax
  8012ff:	29 c1                	sub    %eax,%ecx
  801301:	89 ca                	mov    %ecx,%edx
  801303:	85 d2                	test   %edx,%edx
  801305:	75 9c                	jne    8012a3 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801307:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80130e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801311:	48                   	dec    %eax
  801312:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801315:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801319:	74 3d                	je     801358 <ltostr+0xe2>
		start = 1 ;
  80131b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801322:	eb 34                	jmp    801358 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801324:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801327:	8b 45 0c             	mov    0xc(%ebp),%eax
  80132a:	01 d0                	add    %edx,%eax
  80132c:	8a 00                	mov    (%eax),%al
  80132e:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801331:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801334:	8b 45 0c             	mov    0xc(%ebp),%eax
  801337:	01 c2                	add    %eax,%edx
  801339:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80133c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80133f:	01 c8                	add    %ecx,%eax
  801341:	8a 00                	mov    (%eax),%al
  801343:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801345:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801348:	8b 45 0c             	mov    0xc(%ebp),%eax
  80134b:	01 c2                	add    %eax,%edx
  80134d:	8a 45 eb             	mov    -0x15(%ebp),%al
  801350:	88 02                	mov    %al,(%edx)
		start++ ;
  801352:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801355:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801358:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80135b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80135e:	7c c4                	jl     801324 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801360:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801363:	8b 45 0c             	mov    0xc(%ebp),%eax
  801366:	01 d0                	add    %edx,%eax
  801368:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80136b:	90                   	nop
  80136c:	c9                   	leave  
  80136d:	c3                   	ret    

0080136e <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80136e:	55                   	push   %ebp
  80136f:	89 e5                	mov    %esp,%ebp
  801371:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801374:	ff 75 08             	pushl  0x8(%ebp)
  801377:	e8 54 fa ff ff       	call   800dd0 <strlen>
  80137c:	83 c4 04             	add    $0x4,%esp
  80137f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801382:	ff 75 0c             	pushl  0xc(%ebp)
  801385:	e8 46 fa ff ff       	call   800dd0 <strlen>
  80138a:	83 c4 04             	add    $0x4,%esp
  80138d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801390:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801397:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80139e:	eb 17                	jmp    8013b7 <strcconcat+0x49>
		final[s] = str1[s] ;
  8013a0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8013a6:	01 c2                	add    %eax,%edx
  8013a8:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ae:	01 c8                	add    %ecx,%eax
  8013b0:	8a 00                	mov    (%eax),%al
  8013b2:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8013b4:	ff 45 fc             	incl   -0x4(%ebp)
  8013b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013ba:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8013bd:	7c e1                	jl     8013a0 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8013bf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8013c6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8013cd:	eb 1f                	jmp    8013ee <strcconcat+0x80>
		final[s++] = str2[i] ;
  8013cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013d2:	8d 50 01             	lea    0x1(%eax),%edx
  8013d5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8013d8:	89 c2                	mov    %eax,%edx
  8013da:	8b 45 10             	mov    0x10(%ebp),%eax
  8013dd:	01 c2                	add    %eax,%edx
  8013df:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8013e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e5:	01 c8                	add    %ecx,%eax
  8013e7:	8a 00                	mov    (%eax),%al
  8013e9:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8013eb:	ff 45 f8             	incl   -0x8(%ebp)
  8013ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013f1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013f4:	7c d9                	jl     8013cf <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8013f6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8013fc:	01 d0                	add    %edx,%eax
  8013fe:	c6 00 00             	movb   $0x0,(%eax)
}
  801401:	90                   	nop
  801402:	c9                   	leave  
  801403:	c3                   	ret    

00801404 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801404:	55                   	push   %ebp
  801405:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801407:	8b 45 14             	mov    0x14(%ebp),%eax
  80140a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801410:	8b 45 14             	mov    0x14(%ebp),%eax
  801413:	8b 00                	mov    (%eax),%eax
  801415:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80141c:	8b 45 10             	mov    0x10(%ebp),%eax
  80141f:	01 d0                	add    %edx,%eax
  801421:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801427:	eb 0c                	jmp    801435 <strsplit+0x31>
			*string++ = 0;
  801429:	8b 45 08             	mov    0x8(%ebp),%eax
  80142c:	8d 50 01             	lea    0x1(%eax),%edx
  80142f:	89 55 08             	mov    %edx,0x8(%ebp)
  801432:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801435:	8b 45 08             	mov    0x8(%ebp),%eax
  801438:	8a 00                	mov    (%eax),%al
  80143a:	84 c0                	test   %al,%al
  80143c:	74 18                	je     801456 <strsplit+0x52>
  80143e:	8b 45 08             	mov    0x8(%ebp),%eax
  801441:	8a 00                	mov    (%eax),%al
  801443:	0f be c0             	movsbl %al,%eax
  801446:	50                   	push   %eax
  801447:	ff 75 0c             	pushl  0xc(%ebp)
  80144a:	e8 13 fb ff ff       	call   800f62 <strchr>
  80144f:	83 c4 08             	add    $0x8,%esp
  801452:	85 c0                	test   %eax,%eax
  801454:	75 d3                	jne    801429 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801456:	8b 45 08             	mov    0x8(%ebp),%eax
  801459:	8a 00                	mov    (%eax),%al
  80145b:	84 c0                	test   %al,%al
  80145d:	74 5a                	je     8014b9 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80145f:	8b 45 14             	mov    0x14(%ebp),%eax
  801462:	8b 00                	mov    (%eax),%eax
  801464:	83 f8 0f             	cmp    $0xf,%eax
  801467:	75 07                	jne    801470 <strsplit+0x6c>
		{
			return 0;
  801469:	b8 00 00 00 00       	mov    $0x0,%eax
  80146e:	eb 66                	jmp    8014d6 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801470:	8b 45 14             	mov    0x14(%ebp),%eax
  801473:	8b 00                	mov    (%eax),%eax
  801475:	8d 48 01             	lea    0x1(%eax),%ecx
  801478:	8b 55 14             	mov    0x14(%ebp),%edx
  80147b:	89 0a                	mov    %ecx,(%edx)
  80147d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801484:	8b 45 10             	mov    0x10(%ebp),%eax
  801487:	01 c2                	add    %eax,%edx
  801489:	8b 45 08             	mov    0x8(%ebp),%eax
  80148c:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80148e:	eb 03                	jmp    801493 <strsplit+0x8f>
			string++;
  801490:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801493:	8b 45 08             	mov    0x8(%ebp),%eax
  801496:	8a 00                	mov    (%eax),%al
  801498:	84 c0                	test   %al,%al
  80149a:	74 8b                	je     801427 <strsplit+0x23>
  80149c:	8b 45 08             	mov    0x8(%ebp),%eax
  80149f:	8a 00                	mov    (%eax),%al
  8014a1:	0f be c0             	movsbl %al,%eax
  8014a4:	50                   	push   %eax
  8014a5:	ff 75 0c             	pushl  0xc(%ebp)
  8014a8:	e8 b5 fa ff ff       	call   800f62 <strchr>
  8014ad:	83 c4 08             	add    $0x8,%esp
  8014b0:	85 c0                	test   %eax,%eax
  8014b2:	74 dc                	je     801490 <strsplit+0x8c>
			string++;
	}
  8014b4:	e9 6e ff ff ff       	jmp    801427 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8014b9:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8014ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8014bd:	8b 00                	mov    (%eax),%eax
  8014bf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8014c9:	01 d0                	add    %edx,%eax
  8014cb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8014d1:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8014d6:	c9                   	leave  
  8014d7:	c3                   	ret    

008014d8 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8014d8:	55                   	push   %ebp
  8014d9:	89 e5                	mov    %esp,%ebp
  8014db:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	panic("initialize_dyn_block_system() is not implemented yet...!!");
  8014de:	83 ec 04             	sub    $0x4,%esp
  8014e1:	68 90 27 80 00       	push   $0x802790
  8014e6:	6a 0e                	push   $0xe
  8014e8:	68 ca 27 80 00       	push   $0x8027ca
  8014ed:	e8 a8 ef ff ff       	call   80049a <_panic>

008014f2 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
int FirstTimeFlag = 1;
void* malloc(uint32 size)
{
  8014f2:	55                   	push   %ebp
  8014f3:	89 e5                	mov    %esp,%ebp
  8014f5:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if(FirstTimeFlag)
  8014f8:	a1 04 30 80 00       	mov    0x803004,%eax
  8014fd:	85 c0                	test   %eax,%eax
  8014ff:	74 0f                	je     801510 <malloc+0x1e>
	{
		initialize_dyn_block_system();
  801501:	e8 d2 ff ff ff       	call   8014d8 <initialize_dyn_block_system>
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801506:	c7 05 04 30 80 00 00 	movl   $0x0,0x803004
  80150d:	00 00 00 
	}
	if (size == 0) return NULL ;
  801510:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801514:	75 07                	jne    80151d <malloc+0x2b>
  801516:	b8 00 00 00 00       	mov    $0x0,%eax
  80151b:	eb 14                	jmp    801531 <malloc+0x3f>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  80151d:	83 ec 04             	sub    $0x4,%esp
  801520:	68 d8 27 80 00       	push   $0x8027d8
  801525:	6a 2e                	push   $0x2e
  801527:	68 ca 27 80 00       	push   $0x8027ca
  80152c:	e8 69 ef ff ff       	call   80049a <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyNEXTFIT()... to check the current strategy
}
  801531:	c9                   	leave  
  801532:	c3                   	ret    

00801533 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801533:	55                   	push   %ebp
  801534:	89 e5                	mov    %esp,%ebp
  801536:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801539:	83 ec 04             	sub    $0x4,%esp
  80153c:	68 00 28 80 00       	push   $0x802800
  801541:	6a 49                	push   $0x49
  801543:	68 ca 27 80 00       	push   $0x8027ca
  801548:	e8 4d ef ff ff       	call   80049a <_panic>

0080154d <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80154d:	55                   	push   %ebp
  80154e:	89 e5                	mov    %esp,%ebp
  801550:	83 ec 18             	sub    $0x18,%esp
  801553:	8b 45 10             	mov    0x10(%ebp),%eax
  801556:	88 45 f4             	mov    %al,-0xc(%ebp)
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801559:	83 ec 04             	sub    $0x4,%esp
  80155c:	68 24 28 80 00       	push   $0x802824
  801561:	6a 57                	push   $0x57
  801563:	68 ca 27 80 00       	push   $0x8027ca
  801568:	e8 2d ef ff ff       	call   80049a <_panic>

0080156d <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80156d:	55                   	push   %ebp
  80156e:	89 e5                	mov    %esp,%ebp
  801570:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801573:	83 ec 04             	sub    $0x4,%esp
  801576:	68 4c 28 80 00       	push   $0x80284c
  80157b:	6a 60                	push   $0x60
  80157d:	68 ca 27 80 00       	push   $0x8027ca
  801582:	e8 13 ef ff ff       	call   80049a <_panic>

00801587 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801587:	55                   	push   %ebp
  801588:	89 e5                	mov    %esp,%ebp
  80158a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80158d:	83 ec 04             	sub    $0x4,%esp
  801590:	68 70 28 80 00       	push   $0x802870
  801595:	6a 7c                	push   $0x7c
  801597:	68 ca 27 80 00       	push   $0x8027ca
  80159c:	e8 f9 ee ff ff       	call   80049a <_panic>

008015a1 <sfree>:

//=================================
// FREE SHARED VARIABLE:
//=================================
void sfree(void* virtual_address)
{
  8015a1:	55                   	push   %ebp
  8015a2:	89 e5                	mov    %esp,%ebp
  8015a4:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8015a7:	83 ec 04             	sub    $0x4,%esp
  8015aa:	68 98 28 80 00       	push   $0x802898
  8015af:	68 86 00 00 00       	push   $0x86
  8015b4:	68 ca 27 80 00       	push   $0x8027ca
  8015b9:	e8 dc ee ff ff       	call   80049a <_panic>

008015be <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8015be:	55                   	push   %ebp
  8015bf:	89 e5                	mov    %esp,%ebp
  8015c1:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015c4:	83 ec 04             	sub    $0x4,%esp
  8015c7:	68 bc 28 80 00       	push   $0x8028bc
  8015cc:	68 91 00 00 00       	push   $0x91
  8015d1:	68 ca 27 80 00       	push   $0x8027ca
  8015d6:	e8 bf ee ff ff       	call   80049a <_panic>

008015db <shrink>:

}
void shrink(uint32 newSize)
{
  8015db:	55                   	push   %ebp
  8015dc:	89 e5                	mov    %esp,%ebp
  8015de:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015e1:	83 ec 04             	sub    $0x4,%esp
  8015e4:	68 bc 28 80 00       	push   $0x8028bc
  8015e9:	68 96 00 00 00       	push   $0x96
  8015ee:	68 ca 27 80 00       	push   $0x8027ca
  8015f3:	e8 a2 ee ff ff       	call   80049a <_panic>

008015f8 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8015f8:	55                   	push   %ebp
  8015f9:	89 e5                	mov    %esp,%ebp
  8015fb:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015fe:	83 ec 04             	sub    $0x4,%esp
  801601:	68 bc 28 80 00       	push   $0x8028bc
  801606:	68 9b 00 00 00       	push   $0x9b
  80160b:	68 ca 27 80 00       	push   $0x8027ca
  801610:	e8 85 ee ff ff       	call   80049a <_panic>

00801615 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801615:	55                   	push   %ebp
  801616:	89 e5                	mov    %esp,%ebp
  801618:	57                   	push   %edi
  801619:	56                   	push   %esi
  80161a:	53                   	push   %ebx
  80161b:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80161e:	8b 45 08             	mov    0x8(%ebp),%eax
  801621:	8b 55 0c             	mov    0xc(%ebp),%edx
  801624:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801627:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80162a:	8b 7d 18             	mov    0x18(%ebp),%edi
  80162d:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801630:	cd 30                	int    $0x30
  801632:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801635:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801638:	83 c4 10             	add    $0x10,%esp
  80163b:	5b                   	pop    %ebx
  80163c:	5e                   	pop    %esi
  80163d:	5f                   	pop    %edi
  80163e:	5d                   	pop    %ebp
  80163f:	c3                   	ret    

00801640 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801640:	55                   	push   %ebp
  801641:	89 e5                	mov    %esp,%ebp
  801643:	83 ec 04             	sub    $0x4,%esp
  801646:	8b 45 10             	mov    0x10(%ebp),%eax
  801649:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80164c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801650:	8b 45 08             	mov    0x8(%ebp),%eax
  801653:	6a 00                	push   $0x0
  801655:	6a 00                	push   $0x0
  801657:	52                   	push   %edx
  801658:	ff 75 0c             	pushl  0xc(%ebp)
  80165b:	50                   	push   %eax
  80165c:	6a 00                	push   $0x0
  80165e:	e8 b2 ff ff ff       	call   801615 <syscall>
  801663:	83 c4 18             	add    $0x18,%esp
}
  801666:	90                   	nop
  801667:	c9                   	leave  
  801668:	c3                   	ret    

00801669 <sys_cgetc>:

int
sys_cgetc(void)
{
  801669:	55                   	push   %ebp
  80166a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80166c:	6a 00                	push   $0x0
  80166e:	6a 00                	push   $0x0
  801670:	6a 00                	push   $0x0
  801672:	6a 00                	push   $0x0
  801674:	6a 00                	push   $0x0
  801676:	6a 01                	push   $0x1
  801678:	e8 98 ff ff ff       	call   801615 <syscall>
  80167d:	83 c4 18             	add    $0x18,%esp
}
  801680:	c9                   	leave  
  801681:	c3                   	ret    

00801682 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801682:	55                   	push   %ebp
  801683:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801685:	8b 55 0c             	mov    0xc(%ebp),%edx
  801688:	8b 45 08             	mov    0x8(%ebp),%eax
  80168b:	6a 00                	push   $0x0
  80168d:	6a 00                	push   $0x0
  80168f:	6a 00                	push   $0x0
  801691:	52                   	push   %edx
  801692:	50                   	push   %eax
  801693:	6a 05                	push   $0x5
  801695:	e8 7b ff ff ff       	call   801615 <syscall>
  80169a:	83 c4 18             	add    $0x18,%esp
}
  80169d:	c9                   	leave  
  80169e:	c3                   	ret    

0080169f <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80169f:	55                   	push   %ebp
  8016a0:	89 e5                	mov    %esp,%ebp
  8016a2:	56                   	push   %esi
  8016a3:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8016a4:	8b 75 18             	mov    0x18(%ebp),%esi
  8016a7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016aa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b3:	56                   	push   %esi
  8016b4:	53                   	push   %ebx
  8016b5:	51                   	push   %ecx
  8016b6:	52                   	push   %edx
  8016b7:	50                   	push   %eax
  8016b8:	6a 06                	push   $0x6
  8016ba:	e8 56 ff ff ff       	call   801615 <syscall>
  8016bf:	83 c4 18             	add    $0x18,%esp
}
  8016c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016c5:	5b                   	pop    %ebx
  8016c6:	5e                   	pop    %esi
  8016c7:	5d                   	pop    %ebp
  8016c8:	c3                   	ret    

008016c9 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8016c9:	55                   	push   %ebp
  8016ca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8016cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d2:	6a 00                	push   $0x0
  8016d4:	6a 00                	push   $0x0
  8016d6:	6a 00                	push   $0x0
  8016d8:	52                   	push   %edx
  8016d9:	50                   	push   %eax
  8016da:	6a 07                	push   $0x7
  8016dc:	e8 34 ff ff ff       	call   801615 <syscall>
  8016e1:	83 c4 18             	add    $0x18,%esp
}
  8016e4:	c9                   	leave  
  8016e5:	c3                   	ret    

008016e6 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8016e6:	55                   	push   %ebp
  8016e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8016e9:	6a 00                	push   $0x0
  8016eb:	6a 00                	push   $0x0
  8016ed:	6a 00                	push   $0x0
  8016ef:	ff 75 0c             	pushl  0xc(%ebp)
  8016f2:	ff 75 08             	pushl  0x8(%ebp)
  8016f5:	6a 08                	push   $0x8
  8016f7:	e8 19 ff ff ff       	call   801615 <syscall>
  8016fc:	83 c4 18             	add    $0x18,%esp
}
  8016ff:	c9                   	leave  
  801700:	c3                   	ret    

00801701 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801701:	55                   	push   %ebp
  801702:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801704:	6a 00                	push   $0x0
  801706:	6a 00                	push   $0x0
  801708:	6a 00                	push   $0x0
  80170a:	6a 00                	push   $0x0
  80170c:	6a 00                	push   $0x0
  80170e:	6a 09                	push   $0x9
  801710:	e8 00 ff ff ff       	call   801615 <syscall>
  801715:	83 c4 18             	add    $0x18,%esp
}
  801718:	c9                   	leave  
  801719:	c3                   	ret    

0080171a <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80171a:	55                   	push   %ebp
  80171b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80171d:	6a 00                	push   $0x0
  80171f:	6a 00                	push   $0x0
  801721:	6a 00                	push   $0x0
  801723:	6a 00                	push   $0x0
  801725:	6a 00                	push   $0x0
  801727:	6a 0a                	push   $0xa
  801729:	e8 e7 fe ff ff       	call   801615 <syscall>
  80172e:	83 c4 18             	add    $0x18,%esp
}
  801731:	c9                   	leave  
  801732:	c3                   	ret    

00801733 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801733:	55                   	push   %ebp
  801734:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801736:	6a 00                	push   $0x0
  801738:	6a 00                	push   $0x0
  80173a:	6a 00                	push   $0x0
  80173c:	6a 00                	push   $0x0
  80173e:	6a 00                	push   $0x0
  801740:	6a 0b                	push   $0xb
  801742:	e8 ce fe ff ff       	call   801615 <syscall>
  801747:	83 c4 18             	add    $0x18,%esp
}
  80174a:	c9                   	leave  
  80174b:	c3                   	ret    

0080174c <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80174c:	55                   	push   %ebp
  80174d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80174f:	6a 00                	push   $0x0
  801751:	6a 00                	push   $0x0
  801753:	6a 00                	push   $0x0
  801755:	ff 75 0c             	pushl  0xc(%ebp)
  801758:	ff 75 08             	pushl  0x8(%ebp)
  80175b:	6a 0f                	push   $0xf
  80175d:	e8 b3 fe ff ff       	call   801615 <syscall>
  801762:	83 c4 18             	add    $0x18,%esp
	return;
  801765:	90                   	nop
}
  801766:	c9                   	leave  
  801767:	c3                   	ret    

00801768 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801768:	55                   	push   %ebp
  801769:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80176b:	6a 00                	push   $0x0
  80176d:	6a 00                	push   $0x0
  80176f:	6a 00                	push   $0x0
  801771:	ff 75 0c             	pushl  0xc(%ebp)
  801774:	ff 75 08             	pushl  0x8(%ebp)
  801777:	6a 10                	push   $0x10
  801779:	e8 97 fe ff ff       	call   801615 <syscall>
  80177e:	83 c4 18             	add    $0x18,%esp
	return ;
  801781:	90                   	nop
}
  801782:	c9                   	leave  
  801783:	c3                   	ret    

00801784 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801784:	55                   	push   %ebp
  801785:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801787:	6a 00                	push   $0x0
  801789:	6a 00                	push   $0x0
  80178b:	ff 75 10             	pushl  0x10(%ebp)
  80178e:	ff 75 0c             	pushl  0xc(%ebp)
  801791:	ff 75 08             	pushl  0x8(%ebp)
  801794:	6a 11                	push   $0x11
  801796:	e8 7a fe ff ff       	call   801615 <syscall>
  80179b:	83 c4 18             	add    $0x18,%esp
	return ;
  80179e:	90                   	nop
}
  80179f:	c9                   	leave  
  8017a0:	c3                   	ret    

008017a1 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8017a1:	55                   	push   %ebp
  8017a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8017a4:	6a 00                	push   $0x0
  8017a6:	6a 00                	push   $0x0
  8017a8:	6a 00                	push   $0x0
  8017aa:	6a 00                	push   $0x0
  8017ac:	6a 00                	push   $0x0
  8017ae:	6a 0c                	push   $0xc
  8017b0:	e8 60 fe ff ff       	call   801615 <syscall>
  8017b5:	83 c4 18             	add    $0x18,%esp
}
  8017b8:	c9                   	leave  
  8017b9:	c3                   	ret    

008017ba <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8017ba:	55                   	push   %ebp
  8017bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8017bd:	6a 00                	push   $0x0
  8017bf:	6a 00                	push   $0x0
  8017c1:	6a 00                	push   $0x0
  8017c3:	6a 00                	push   $0x0
  8017c5:	ff 75 08             	pushl  0x8(%ebp)
  8017c8:	6a 0d                	push   $0xd
  8017ca:	e8 46 fe ff ff       	call   801615 <syscall>
  8017cf:	83 c4 18             	add    $0x18,%esp
}
  8017d2:	c9                   	leave  
  8017d3:	c3                   	ret    

008017d4 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8017d4:	55                   	push   %ebp
  8017d5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8017d7:	6a 00                	push   $0x0
  8017d9:	6a 00                	push   $0x0
  8017db:	6a 00                	push   $0x0
  8017dd:	6a 00                	push   $0x0
  8017df:	6a 00                	push   $0x0
  8017e1:	6a 0e                	push   $0xe
  8017e3:	e8 2d fe ff ff       	call   801615 <syscall>
  8017e8:	83 c4 18             	add    $0x18,%esp
}
  8017eb:	90                   	nop
  8017ec:	c9                   	leave  
  8017ed:	c3                   	ret    

008017ee <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8017ee:	55                   	push   %ebp
  8017ef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8017f1:	6a 00                	push   $0x0
  8017f3:	6a 00                	push   $0x0
  8017f5:	6a 00                	push   $0x0
  8017f7:	6a 00                	push   $0x0
  8017f9:	6a 00                	push   $0x0
  8017fb:	6a 13                	push   $0x13
  8017fd:	e8 13 fe ff ff       	call   801615 <syscall>
  801802:	83 c4 18             	add    $0x18,%esp
}
  801805:	90                   	nop
  801806:	c9                   	leave  
  801807:	c3                   	ret    

00801808 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801808:	55                   	push   %ebp
  801809:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80180b:	6a 00                	push   $0x0
  80180d:	6a 00                	push   $0x0
  80180f:	6a 00                	push   $0x0
  801811:	6a 00                	push   $0x0
  801813:	6a 00                	push   $0x0
  801815:	6a 14                	push   $0x14
  801817:	e8 f9 fd ff ff       	call   801615 <syscall>
  80181c:	83 c4 18             	add    $0x18,%esp
}
  80181f:	90                   	nop
  801820:	c9                   	leave  
  801821:	c3                   	ret    

00801822 <sys_cputc>:


void
sys_cputc(const char c)
{
  801822:	55                   	push   %ebp
  801823:	89 e5                	mov    %esp,%ebp
  801825:	83 ec 04             	sub    $0x4,%esp
  801828:	8b 45 08             	mov    0x8(%ebp),%eax
  80182b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80182e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801832:	6a 00                	push   $0x0
  801834:	6a 00                	push   $0x0
  801836:	6a 00                	push   $0x0
  801838:	6a 00                	push   $0x0
  80183a:	50                   	push   %eax
  80183b:	6a 15                	push   $0x15
  80183d:	e8 d3 fd ff ff       	call   801615 <syscall>
  801842:	83 c4 18             	add    $0x18,%esp
}
  801845:	90                   	nop
  801846:	c9                   	leave  
  801847:	c3                   	ret    

00801848 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801848:	55                   	push   %ebp
  801849:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80184b:	6a 00                	push   $0x0
  80184d:	6a 00                	push   $0x0
  80184f:	6a 00                	push   $0x0
  801851:	6a 00                	push   $0x0
  801853:	6a 00                	push   $0x0
  801855:	6a 16                	push   $0x16
  801857:	e8 b9 fd ff ff       	call   801615 <syscall>
  80185c:	83 c4 18             	add    $0x18,%esp
}
  80185f:	90                   	nop
  801860:	c9                   	leave  
  801861:	c3                   	ret    

00801862 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801862:	55                   	push   %ebp
  801863:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801865:	8b 45 08             	mov    0x8(%ebp),%eax
  801868:	6a 00                	push   $0x0
  80186a:	6a 00                	push   $0x0
  80186c:	6a 00                	push   $0x0
  80186e:	ff 75 0c             	pushl  0xc(%ebp)
  801871:	50                   	push   %eax
  801872:	6a 17                	push   $0x17
  801874:	e8 9c fd ff ff       	call   801615 <syscall>
  801879:	83 c4 18             	add    $0x18,%esp
}
  80187c:	c9                   	leave  
  80187d:	c3                   	ret    

0080187e <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80187e:	55                   	push   %ebp
  80187f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801881:	8b 55 0c             	mov    0xc(%ebp),%edx
  801884:	8b 45 08             	mov    0x8(%ebp),%eax
  801887:	6a 00                	push   $0x0
  801889:	6a 00                	push   $0x0
  80188b:	6a 00                	push   $0x0
  80188d:	52                   	push   %edx
  80188e:	50                   	push   %eax
  80188f:	6a 1a                	push   $0x1a
  801891:	e8 7f fd ff ff       	call   801615 <syscall>
  801896:	83 c4 18             	add    $0x18,%esp
}
  801899:	c9                   	leave  
  80189a:	c3                   	ret    

0080189b <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80189b:	55                   	push   %ebp
  80189c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80189e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a4:	6a 00                	push   $0x0
  8018a6:	6a 00                	push   $0x0
  8018a8:	6a 00                	push   $0x0
  8018aa:	52                   	push   %edx
  8018ab:	50                   	push   %eax
  8018ac:	6a 18                	push   $0x18
  8018ae:	e8 62 fd ff ff       	call   801615 <syscall>
  8018b3:	83 c4 18             	add    $0x18,%esp
}
  8018b6:	90                   	nop
  8018b7:	c9                   	leave  
  8018b8:	c3                   	ret    

008018b9 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8018b9:	55                   	push   %ebp
  8018ba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c2:	6a 00                	push   $0x0
  8018c4:	6a 00                	push   $0x0
  8018c6:	6a 00                	push   $0x0
  8018c8:	52                   	push   %edx
  8018c9:	50                   	push   %eax
  8018ca:	6a 19                	push   $0x19
  8018cc:	e8 44 fd ff ff       	call   801615 <syscall>
  8018d1:	83 c4 18             	add    $0x18,%esp
}
  8018d4:	90                   	nop
  8018d5:	c9                   	leave  
  8018d6:	c3                   	ret    

008018d7 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8018d7:	55                   	push   %ebp
  8018d8:	89 e5                	mov    %esp,%ebp
  8018da:	83 ec 04             	sub    $0x4,%esp
  8018dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8018e0:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8018e3:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8018e6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ed:	6a 00                	push   $0x0
  8018ef:	51                   	push   %ecx
  8018f0:	52                   	push   %edx
  8018f1:	ff 75 0c             	pushl  0xc(%ebp)
  8018f4:	50                   	push   %eax
  8018f5:	6a 1b                	push   $0x1b
  8018f7:	e8 19 fd ff ff       	call   801615 <syscall>
  8018fc:	83 c4 18             	add    $0x18,%esp
}
  8018ff:	c9                   	leave  
  801900:	c3                   	ret    

00801901 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801901:	55                   	push   %ebp
  801902:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801904:	8b 55 0c             	mov    0xc(%ebp),%edx
  801907:	8b 45 08             	mov    0x8(%ebp),%eax
  80190a:	6a 00                	push   $0x0
  80190c:	6a 00                	push   $0x0
  80190e:	6a 00                	push   $0x0
  801910:	52                   	push   %edx
  801911:	50                   	push   %eax
  801912:	6a 1c                	push   $0x1c
  801914:	e8 fc fc ff ff       	call   801615 <syscall>
  801919:	83 c4 18             	add    $0x18,%esp
}
  80191c:	c9                   	leave  
  80191d:	c3                   	ret    

0080191e <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80191e:	55                   	push   %ebp
  80191f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801921:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801924:	8b 55 0c             	mov    0xc(%ebp),%edx
  801927:	8b 45 08             	mov    0x8(%ebp),%eax
  80192a:	6a 00                	push   $0x0
  80192c:	6a 00                	push   $0x0
  80192e:	51                   	push   %ecx
  80192f:	52                   	push   %edx
  801930:	50                   	push   %eax
  801931:	6a 1d                	push   $0x1d
  801933:	e8 dd fc ff ff       	call   801615 <syscall>
  801938:	83 c4 18             	add    $0x18,%esp
}
  80193b:	c9                   	leave  
  80193c:	c3                   	ret    

0080193d <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80193d:	55                   	push   %ebp
  80193e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801940:	8b 55 0c             	mov    0xc(%ebp),%edx
  801943:	8b 45 08             	mov    0x8(%ebp),%eax
  801946:	6a 00                	push   $0x0
  801948:	6a 00                	push   $0x0
  80194a:	6a 00                	push   $0x0
  80194c:	52                   	push   %edx
  80194d:	50                   	push   %eax
  80194e:	6a 1e                	push   $0x1e
  801950:	e8 c0 fc ff ff       	call   801615 <syscall>
  801955:	83 c4 18             	add    $0x18,%esp
}
  801958:	c9                   	leave  
  801959:	c3                   	ret    

0080195a <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80195a:	55                   	push   %ebp
  80195b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80195d:	6a 00                	push   $0x0
  80195f:	6a 00                	push   $0x0
  801961:	6a 00                	push   $0x0
  801963:	6a 00                	push   $0x0
  801965:	6a 00                	push   $0x0
  801967:	6a 1f                	push   $0x1f
  801969:	e8 a7 fc ff ff       	call   801615 <syscall>
  80196e:	83 c4 18             	add    $0x18,%esp
}
  801971:	c9                   	leave  
  801972:	c3                   	ret    

00801973 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801973:	55                   	push   %ebp
  801974:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801976:	8b 45 08             	mov    0x8(%ebp),%eax
  801979:	6a 00                	push   $0x0
  80197b:	ff 75 14             	pushl  0x14(%ebp)
  80197e:	ff 75 10             	pushl  0x10(%ebp)
  801981:	ff 75 0c             	pushl  0xc(%ebp)
  801984:	50                   	push   %eax
  801985:	6a 20                	push   $0x20
  801987:	e8 89 fc ff ff       	call   801615 <syscall>
  80198c:	83 c4 18             	add    $0x18,%esp
}
  80198f:	c9                   	leave  
  801990:	c3                   	ret    

00801991 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801991:	55                   	push   %ebp
  801992:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801994:	8b 45 08             	mov    0x8(%ebp),%eax
  801997:	6a 00                	push   $0x0
  801999:	6a 00                	push   $0x0
  80199b:	6a 00                	push   $0x0
  80199d:	6a 00                	push   $0x0
  80199f:	50                   	push   %eax
  8019a0:	6a 21                	push   $0x21
  8019a2:	e8 6e fc ff ff       	call   801615 <syscall>
  8019a7:	83 c4 18             	add    $0x18,%esp
}
  8019aa:	90                   	nop
  8019ab:	c9                   	leave  
  8019ac:	c3                   	ret    

008019ad <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8019ad:	55                   	push   %ebp
  8019ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8019b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b3:	6a 00                	push   $0x0
  8019b5:	6a 00                	push   $0x0
  8019b7:	6a 00                	push   $0x0
  8019b9:	6a 00                	push   $0x0
  8019bb:	50                   	push   %eax
  8019bc:	6a 22                	push   $0x22
  8019be:	e8 52 fc ff ff       	call   801615 <syscall>
  8019c3:	83 c4 18             	add    $0x18,%esp
}
  8019c6:	c9                   	leave  
  8019c7:	c3                   	ret    

008019c8 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8019c8:	55                   	push   %ebp
  8019c9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8019cb:	6a 00                	push   $0x0
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 00                	push   $0x0
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 02                	push   $0x2
  8019d7:	e8 39 fc ff ff       	call   801615 <syscall>
  8019dc:	83 c4 18             	add    $0x18,%esp
}
  8019df:	c9                   	leave  
  8019e0:	c3                   	ret    

008019e1 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8019e1:	55                   	push   %ebp
  8019e2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8019e4:	6a 00                	push   $0x0
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 00                	push   $0x0
  8019ea:	6a 00                	push   $0x0
  8019ec:	6a 00                	push   $0x0
  8019ee:	6a 03                	push   $0x3
  8019f0:	e8 20 fc ff ff       	call   801615 <syscall>
  8019f5:	83 c4 18             	add    $0x18,%esp
}
  8019f8:	c9                   	leave  
  8019f9:	c3                   	ret    

008019fa <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8019fa:	55                   	push   %ebp
  8019fb:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8019fd:	6a 00                	push   $0x0
  8019ff:	6a 00                	push   $0x0
  801a01:	6a 00                	push   $0x0
  801a03:	6a 00                	push   $0x0
  801a05:	6a 00                	push   $0x0
  801a07:	6a 04                	push   $0x4
  801a09:	e8 07 fc ff ff       	call   801615 <syscall>
  801a0e:	83 c4 18             	add    $0x18,%esp
}
  801a11:	c9                   	leave  
  801a12:	c3                   	ret    

00801a13 <sys_exit_env>:


void sys_exit_env(void)
{
  801a13:	55                   	push   %ebp
  801a14:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801a16:	6a 00                	push   $0x0
  801a18:	6a 00                	push   $0x0
  801a1a:	6a 00                	push   $0x0
  801a1c:	6a 00                	push   $0x0
  801a1e:	6a 00                	push   $0x0
  801a20:	6a 23                	push   $0x23
  801a22:	e8 ee fb ff ff       	call   801615 <syscall>
  801a27:	83 c4 18             	add    $0x18,%esp
}
  801a2a:	90                   	nop
  801a2b:	c9                   	leave  
  801a2c:	c3                   	ret    

00801a2d <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801a2d:	55                   	push   %ebp
  801a2e:	89 e5                	mov    %esp,%ebp
  801a30:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801a33:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a36:	8d 50 04             	lea    0x4(%eax),%edx
  801a39:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a3c:	6a 00                	push   $0x0
  801a3e:	6a 00                	push   $0x0
  801a40:	6a 00                	push   $0x0
  801a42:	52                   	push   %edx
  801a43:	50                   	push   %eax
  801a44:	6a 24                	push   $0x24
  801a46:	e8 ca fb ff ff       	call   801615 <syscall>
  801a4b:	83 c4 18             	add    $0x18,%esp
	return result;
  801a4e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a51:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a54:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a57:	89 01                	mov    %eax,(%ecx)
  801a59:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5f:	c9                   	leave  
  801a60:	c2 04 00             	ret    $0x4

00801a63 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801a63:	55                   	push   %ebp
  801a64:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801a66:	6a 00                	push   $0x0
  801a68:	6a 00                	push   $0x0
  801a6a:	ff 75 10             	pushl  0x10(%ebp)
  801a6d:	ff 75 0c             	pushl  0xc(%ebp)
  801a70:	ff 75 08             	pushl  0x8(%ebp)
  801a73:	6a 12                	push   $0x12
  801a75:	e8 9b fb ff ff       	call   801615 <syscall>
  801a7a:	83 c4 18             	add    $0x18,%esp
	return ;
  801a7d:	90                   	nop
}
  801a7e:	c9                   	leave  
  801a7f:	c3                   	ret    

00801a80 <sys_rcr2>:
uint32 sys_rcr2()
{
  801a80:	55                   	push   %ebp
  801a81:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801a83:	6a 00                	push   $0x0
  801a85:	6a 00                	push   $0x0
  801a87:	6a 00                	push   $0x0
  801a89:	6a 00                	push   $0x0
  801a8b:	6a 00                	push   $0x0
  801a8d:	6a 25                	push   $0x25
  801a8f:	e8 81 fb ff ff       	call   801615 <syscall>
  801a94:	83 c4 18             	add    $0x18,%esp
}
  801a97:	c9                   	leave  
  801a98:	c3                   	ret    

00801a99 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801a99:	55                   	push   %ebp
  801a9a:	89 e5                	mov    %esp,%ebp
  801a9c:	83 ec 04             	sub    $0x4,%esp
  801a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801aa5:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801aa9:	6a 00                	push   $0x0
  801aab:	6a 00                	push   $0x0
  801aad:	6a 00                	push   $0x0
  801aaf:	6a 00                	push   $0x0
  801ab1:	50                   	push   %eax
  801ab2:	6a 26                	push   $0x26
  801ab4:	e8 5c fb ff ff       	call   801615 <syscall>
  801ab9:	83 c4 18             	add    $0x18,%esp
	return ;
  801abc:	90                   	nop
}
  801abd:	c9                   	leave  
  801abe:	c3                   	ret    

00801abf <rsttst>:
void rsttst()
{
  801abf:	55                   	push   %ebp
  801ac0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801ac2:	6a 00                	push   $0x0
  801ac4:	6a 00                	push   $0x0
  801ac6:	6a 00                	push   $0x0
  801ac8:	6a 00                	push   $0x0
  801aca:	6a 00                	push   $0x0
  801acc:	6a 28                	push   $0x28
  801ace:	e8 42 fb ff ff       	call   801615 <syscall>
  801ad3:	83 c4 18             	add    $0x18,%esp
	return ;
  801ad6:	90                   	nop
}
  801ad7:	c9                   	leave  
  801ad8:	c3                   	ret    

00801ad9 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801ad9:	55                   	push   %ebp
  801ada:	89 e5                	mov    %esp,%ebp
  801adc:	83 ec 04             	sub    $0x4,%esp
  801adf:	8b 45 14             	mov    0x14(%ebp),%eax
  801ae2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ae5:	8b 55 18             	mov    0x18(%ebp),%edx
  801ae8:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801aec:	52                   	push   %edx
  801aed:	50                   	push   %eax
  801aee:	ff 75 10             	pushl  0x10(%ebp)
  801af1:	ff 75 0c             	pushl  0xc(%ebp)
  801af4:	ff 75 08             	pushl  0x8(%ebp)
  801af7:	6a 27                	push   $0x27
  801af9:	e8 17 fb ff ff       	call   801615 <syscall>
  801afe:	83 c4 18             	add    $0x18,%esp
	return ;
  801b01:	90                   	nop
}
  801b02:	c9                   	leave  
  801b03:	c3                   	ret    

00801b04 <chktst>:
void chktst(uint32 n)
{
  801b04:	55                   	push   %ebp
  801b05:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801b07:	6a 00                	push   $0x0
  801b09:	6a 00                	push   $0x0
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 00                	push   $0x0
  801b0f:	ff 75 08             	pushl  0x8(%ebp)
  801b12:	6a 29                	push   $0x29
  801b14:	e8 fc fa ff ff       	call   801615 <syscall>
  801b19:	83 c4 18             	add    $0x18,%esp
	return ;
  801b1c:	90                   	nop
}
  801b1d:	c9                   	leave  
  801b1e:	c3                   	ret    

00801b1f <inctst>:

void inctst()
{
  801b1f:	55                   	push   %ebp
  801b20:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801b22:	6a 00                	push   $0x0
  801b24:	6a 00                	push   $0x0
  801b26:	6a 00                	push   $0x0
  801b28:	6a 00                	push   $0x0
  801b2a:	6a 00                	push   $0x0
  801b2c:	6a 2a                	push   $0x2a
  801b2e:	e8 e2 fa ff ff       	call   801615 <syscall>
  801b33:	83 c4 18             	add    $0x18,%esp
	return ;
  801b36:	90                   	nop
}
  801b37:	c9                   	leave  
  801b38:	c3                   	ret    

00801b39 <gettst>:
uint32 gettst()
{
  801b39:	55                   	push   %ebp
  801b3a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801b3c:	6a 00                	push   $0x0
  801b3e:	6a 00                	push   $0x0
  801b40:	6a 00                	push   $0x0
  801b42:	6a 00                	push   $0x0
  801b44:	6a 00                	push   $0x0
  801b46:	6a 2b                	push   $0x2b
  801b48:	e8 c8 fa ff ff       	call   801615 <syscall>
  801b4d:	83 c4 18             	add    $0x18,%esp
}
  801b50:	c9                   	leave  
  801b51:	c3                   	ret    

00801b52 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801b52:	55                   	push   %ebp
  801b53:	89 e5                	mov    %esp,%ebp
  801b55:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b58:	6a 00                	push   $0x0
  801b5a:	6a 00                	push   $0x0
  801b5c:	6a 00                	push   $0x0
  801b5e:	6a 00                	push   $0x0
  801b60:	6a 00                	push   $0x0
  801b62:	6a 2c                	push   $0x2c
  801b64:	e8 ac fa ff ff       	call   801615 <syscall>
  801b69:	83 c4 18             	add    $0x18,%esp
  801b6c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801b6f:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801b73:	75 07                	jne    801b7c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801b75:	b8 01 00 00 00       	mov    $0x1,%eax
  801b7a:	eb 05                	jmp    801b81 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801b7c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b81:	c9                   	leave  
  801b82:	c3                   	ret    

00801b83 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801b83:	55                   	push   %ebp
  801b84:	89 e5                	mov    %esp,%ebp
  801b86:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b89:	6a 00                	push   $0x0
  801b8b:	6a 00                	push   $0x0
  801b8d:	6a 00                	push   $0x0
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 00                	push   $0x0
  801b93:	6a 2c                	push   $0x2c
  801b95:	e8 7b fa ff ff       	call   801615 <syscall>
  801b9a:	83 c4 18             	add    $0x18,%esp
  801b9d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801ba0:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801ba4:	75 07                	jne    801bad <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801ba6:	b8 01 00 00 00       	mov    $0x1,%eax
  801bab:	eb 05                	jmp    801bb2 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801bad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bb2:	c9                   	leave  
  801bb3:	c3                   	ret    

00801bb4 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801bb4:	55                   	push   %ebp
  801bb5:	89 e5                	mov    %esp,%ebp
  801bb7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bba:	6a 00                	push   $0x0
  801bbc:	6a 00                	push   $0x0
  801bbe:	6a 00                	push   $0x0
  801bc0:	6a 00                	push   $0x0
  801bc2:	6a 00                	push   $0x0
  801bc4:	6a 2c                	push   $0x2c
  801bc6:	e8 4a fa ff ff       	call   801615 <syscall>
  801bcb:	83 c4 18             	add    $0x18,%esp
  801bce:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801bd1:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801bd5:	75 07                	jne    801bde <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801bd7:	b8 01 00 00 00       	mov    $0x1,%eax
  801bdc:	eb 05                	jmp    801be3 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801bde:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801be3:	c9                   	leave  
  801be4:	c3                   	ret    

00801be5 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801be5:	55                   	push   %ebp
  801be6:	89 e5                	mov    %esp,%ebp
  801be8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801beb:	6a 00                	push   $0x0
  801bed:	6a 00                	push   $0x0
  801bef:	6a 00                	push   $0x0
  801bf1:	6a 00                	push   $0x0
  801bf3:	6a 00                	push   $0x0
  801bf5:	6a 2c                	push   $0x2c
  801bf7:	e8 19 fa ff ff       	call   801615 <syscall>
  801bfc:	83 c4 18             	add    $0x18,%esp
  801bff:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801c02:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801c06:	75 07                	jne    801c0f <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801c08:	b8 01 00 00 00       	mov    $0x1,%eax
  801c0d:	eb 05                	jmp    801c14 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801c0f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c14:	c9                   	leave  
  801c15:	c3                   	ret    

00801c16 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801c16:	55                   	push   %ebp
  801c17:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801c19:	6a 00                	push   $0x0
  801c1b:	6a 00                	push   $0x0
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 00                	push   $0x0
  801c21:	ff 75 08             	pushl  0x8(%ebp)
  801c24:	6a 2d                	push   $0x2d
  801c26:	e8 ea f9 ff ff       	call   801615 <syscall>
  801c2b:	83 c4 18             	add    $0x18,%esp
	return ;
  801c2e:	90                   	nop
}
  801c2f:	c9                   	leave  
  801c30:	c3                   	ret    

00801c31 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801c31:	55                   	push   %ebp
  801c32:	89 e5                	mov    %esp,%ebp
  801c34:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801c35:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c38:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c41:	6a 00                	push   $0x0
  801c43:	53                   	push   %ebx
  801c44:	51                   	push   %ecx
  801c45:	52                   	push   %edx
  801c46:	50                   	push   %eax
  801c47:	6a 2e                	push   $0x2e
  801c49:	e8 c7 f9 ff ff       	call   801615 <syscall>
  801c4e:	83 c4 18             	add    $0x18,%esp
}
  801c51:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c54:	c9                   	leave  
  801c55:	c3                   	ret    

00801c56 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801c56:	55                   	push   %ebp
  801c57:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801c59:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5f:	6a 00                	push   $0x0
  801c61:	6a 00                	push   $0x0
  801c63:	6a 00                	push   $0x0
  801c65:	52                   	push   %edx
  801c66:	50                   	push   %eax
  801c67:	6a 2f                	push   $0x2f
  801c69:	e8 a7 f9 ff ff       	call   801615 <syscall>
  801c6e:	83 c4 18             	add    $0x18,%esp
}
  801c71:	c9                   	leave  
  801c72:	c3                   	ret    

00801c73 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801c73:	55                   	push   %ebp
  801c74:	89 e5                	mov    %esp,%ebp
  801c76:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801c79:	8b 55 08             	mov    0x8(%ebp),%edx
  801c7c:	89 d0                	mov    %edx,%eax
  801c7e:	c1 e0 02             	shl    $0x2,%eax
  801c81:	01 d0                	add    %edx,%eax
  801c83:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c8a:	01 d0                	add    %edx,%eax
  801c8c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c93:	01 d0                	add    %edx,%eax
  801c95:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c9c:	01 d0                	add    %edx,%eax
  801c9e:	c1 e0 04             	shl    $0x4,%eax
  801ca1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  801ca4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  801cab:	8d 45 e8             	lea    -0x18(%ebp),%eax
  801cae:	83 ec 0c             	sub    $0xc,%esp
  801cb1:	50                   	push   %eax
  801cb2:	e8 76 fd ff ff       	call   801a2d <sys_get_virtual_time>
  801cb7:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  801cba:	eb 41                	jmp    801cfd <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  801cbc:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801cbf:	83 ec 0c             	sub    $0xc,%esp
  801cc2:	50                   	push   %eax
  801cc3:	e8 65 fd ff ff       	call   801a2d <sys_get_virtual_time>
  801cc8:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801ccb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801cce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801cd1:	29 c2                	sub    %eax,%edx
  801cd3:	89 d0                	mov    %edx,%eax
  801cd5:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801cd8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801cdb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cde:	89 d1                	mov    %edx,%ecx
  801ce0:	29 c1                	sub    %eax,%ecx
  801ce2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801ce5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ce8:	39 c2                	cmp    %eax,%edx
  801cea:	0f 97 c0             	seta   %al
  801ced:	0f b6 c0             	movzbl %al,%eax
  801cf0:	29 c1                	sub    %eax,%ecx
  801cf2:	89 c8                	mov    %ecx,%eax
  801cf4:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801cf7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801cfa:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  801cfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d00:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801d03:	72 b7                	jb     801cbc <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801d05:	90                   	nop
  801d06:	c9                   	leave  
  801d07:	c3                   	ret    

00801d08 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801d08:	55                   	push   %ebp
  801d09:	89 e5                	mov    %esp,%ebp
  801d0b:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801d0e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801d15:	eb 03                	jmp    801d1a <busy_wait+0x12>
  801d17:	ff 45 fc             	incl   -0x4(%ebp)
  801d1a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d1d:	3b 45 08             	cmp    0x8(%ebp),%eax
  801d20:	72 f5                	jb     801d17 <busy_wait+0xf>
	return i;
  801d22:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801d25:	c9                   	leave  
  801d26:	c3                   	ret    
  801d27:	90                   	nop

00801d28 <__udivdi3>:
  801d28:	55                   	push   %ebp
  801d29:	57                   	push   %edi
  801d2a:	56                   	push   %esi
  801d2b:	53                   	push   %ebx
  801d2c:	83 ec 1c             	sub    $0x1c,%esp
  801d2f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801d33:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801d37:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d3b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d3f:	89 ca                	mov    %ecx,%edx
  801d41:	89 f8                	mov    %edi,%eax
  801d43:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801d47:	85 f6                	test   %esi,%esi
  801d49:	75 2d                	jne    801d78 <__udivdi3+0x50>
  801d4b:	39 cf                	cmp    %ecx,%edi
  801d4d:	77 65                	ja     801db4 <__udivdi3+0x8c>
  801d4f:	89 fd                	mov    %edi,%ebp
  801d51:	85 ff                	test   %edi,%edi
  801d53:	75 0b                	jne    801d60 <__udivdi3+0x38>
  801d55:	b8 01 00 00 00       	mov    $0x1,%eax
  801d5a:	31 d2                	xor    %edx,%edx
  801d5c:	f7 f7                	div    %edi
  801d5e:	89 c5                	mov    %eax,%ebp
  801d60:	31 d2                	xor    %edx,%edx
  801d62:	89 c8                	mov    %ecx,%eax
  801d64:	f7 f5                	div    %ebp
  801d66:	89 c1                	mov    %eax,%ecx
  801d68:	89 d8                	mov    %ebx,%eax
  801d6a:	f7 f5                	div    %ebp
  801d6c:	89 cf                	mov    %ecx,%edi
  801d6e:	89 fa                	mov    %edi,%edx
  801d70:	83 c4 1c             	add    $0x1c,%esp
  801d73:	5b                   	pop    %ebx
  801d74:	5e                   	pop    %esi
  801d75:	5f                   	pop    %edi
  801d76:	5d                   	pop    %ebp
  801d77:	c3                   	ret    
  801d78:	39 ce                	cmp    %ecx,%esi
  801d7a:	77 28                	ja     801da4 <__udivdi3+0x7c>
  801d7c:	0f bd fe             	bsr    %esi,%edi
  801d7f:	83 f7 1f             	xor    $0x1f,%edi
  801d82:	75 40                	jne    801dc4 <__udivdi3+0x9c>
  801d84:	39 ce                	cmp    %ecx,%esi
  801d86:	72 0a                	jb     801d92 <__udivdi3+0x6a>
  801d88:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801d8c:	0f 87 9e 00 00 00    	ja     801e30 <__udivdi3+0x108>
  801d92:	b8 01 00 00 00       	mov    $0x1,%eax
  801d97:	89 fa                	mov    %edi,%edx
  801d99:	83 c4 1c             	add    $0x1c,%esp
  801d9c:	5b                   	pop    %ebx
  801d9d:	5e                   	pop    %esi
  801d9e:	5f                   	pop    %edi
  801d9f:	5d                   	pop    %ebp
  801da0:	c3                   	ret    
  801da1:	8d 76 00             	lea    0x0(%esi),%esi
  801da4:	31 ff                	xor    %edi,%edi
  801da6:	31 c0                	xor    %eax,%eax
  801da8:	89 fa                	mov    %edi,%edx
  801daa:	83 c4 1c             	add    $0x1c,%esp
  801dad:	5b                   	pop    %ebx
  801dae:	5e                   	pop    %esi
  801daf:	5f                   	pop    %edi
  801db0:	5d                   	pop    %ebp
  801db1:	c3                   	ret    
  801db2:	66 90                	xchg   %ax,%ax
  801db4:	89 d8                	mov    %ebx,%eax
  801db6:	f7 f7                	div    %edi
  801db8:	31 ff                	xor    %edi,%edi
  801dba:	89 fa                	mov    %edi,%edx
  801dbc:	83 c4 1c             	add    $0x1c,%esp
  801dbf:	5b                   	pop    %ebx
  801dc0:	5e                   	pop    %esi
  801dc1:	5f                   	pop    %edi
  801dc2:	5d                   	pop    %ebp
  801dc3:	c3                   	ret    
  801dc4:	bd 20 00 00 00       	mov    $0x20,%ebp
  801dc9:	89 eb                	mov    %ebp,%ebx
  801dcb:	29 fb                	sub    %edi,%ebx
  801dcd:	89 f9                	mov    %edi,%ecx
  801dcf:	d3 e6                	shl    %cl,%esi
  801dd1:	89 c5                	mov    %eax,%ebp
  801dd3:	88 d9                	mov    %bl,%cl
  801dd5:	d3 ed                	shr    %cl,%ebp
  801dd7:	89 e9                	mov    %ebp,%ecx
  801dd9:	09 f1                	or     %esi,%ecx
  801ddb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801ddf:	89 f9                	mov    %edi,%ecx
  801de1:	d3 e0                	shl    %cl,%eax
  801de3:	89 c5                	mov    %eax,%ebp
  801de5:	89 d6                	mov    %edx,%esi
  801de7:	88 d9                	mov    %bl,%cl
  801de9:	d3 ee                	shr    %cl,%esi
  801deb:	89 f9                	mov    %edi,%ecx
  801ded:	d3 e2                	shl    %cl,%edx
  801def:	8b 44 24 08          	mov    0x8(%esp),%eax
  801df3:	88 d9                	mov    %bl,%cl
  801df5:	d3 e8                	shr    %cl,%eax
  801df7:	09 c2                	or     %eax,%edx
  801df9:	89 d0                	mov    %edx,%eax
  801dfb:	89 f2                	mov    %esi,%edx
  801dfd:	f7 74 24 0c          	divl   0xc(%esp)
  801e01:	89 d6                	mov    %edx,%esi
  801e03:	89 c3                	mov    %eax,%ebx
  801e05:	f7 e5                	mul    %ebp
  801e07:	39 d6                	cmp    %edx,%esi
  801e09:	72 19                	jb     801e24 <__udivdi3+0xfc>
  801e0b:	74 0b                	je     801e18 <__udivdi3+0xf0>
  801e0d:	89 d8                	mov    %ebx,%eax
  801e0f:	31 ff                	xor    %edi,%edi
  801e11:	e9 58 ff ff ff       	jmp    801d6e <__udivdi3+0x46>
  801e16:	66 90                	xchg   %ax,%ax
  801e18:	8b 54 24 08          	mov    0x8(%esp),%edx
  801e1c:	89 f9                	mov    %edi,%ecx
  801e1e:	d3 e2                	shl    %cl,%edx
  801e20:	39 c2                	cmp    %eax,%edx
  801e22:	73 e9                	jae    801e0d <__udivdi3+0xe5>
  801e24:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801e27:	31 ff                	xor    %edi,%edi
  801e29:	e9 40 ff ff ff       	jmp    801d6e <__udivdi3+0x46>
  801e2e:	66 90                	xchg   %ax,%ax
  801e30:	31 c0                	xor    %eax,%eax
  801e32:	e9 37 ff ff ff       	jmp    801d6e <__udivdi3+0x46>
  801e37:	90                   	nop

00801e38 <__umoddi3>:
  801e38:	55                   	push   %ebp
  801e39:	57                   	push   %edi
  801e3a:	56                   	push   %esi
  801e3b:	53                   	push   %ebx
  801e3c:	83 ec 1c             	sub    $0x1c,%esp
  801e3f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801e43:	8b 74 24 34          	mov    0x34(%esp),%esi
  801e47:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801e4b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801e4f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e53:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801e57:	89 f3                	mov    %esi,%ebx
  801e59:	89 fa                	mov    %edi,%edx
  801e5b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801e5f:	89 34 24             	mov    %esi,(%esp)
  801e62:	85 c0                	test   %eax,%eax
  801e64:	75 1a                	jne    801e80 <__umoddi3+0x48>
  801e66:	39 f7                	cmp    %esi,%edi
  801e68:	0f 86 a2 00 00 00    	jbe    801f10 <__umoddi3+0xd8>
  801e6e:	89 c8                	mov    %ecx,%eax
  801e70:	89 f2                	mov    %esi,%edx
  801e72:	f7 f7                	div    %edi
  801e74:	89 d0                	mov    %edx,%eax
  801e76:	31 d2                	xor    %edx,%edx
  801e78:	83 c4 1c             	add    $0x1c,%esp
  801e7b:	5b                   	pop    %ebx
  801e7c:	5e                   	pop    %esi
  801e7d:	5f                   	pop    %edi
  801e7e:	5d                   	pop    %ebp
  801e7f:	c3                   	ret    
  801e80:	39 f0                	cmp    %esi,%eax
  801e82:	0f 87 ac 00 00 00    	ja     801f34 <__umoddi3+0xfc>
  801e88:	0f bd e8             	bsr    %eax,%ebp
  801e8b:	83 f5 1f             	xor    $0x1f,%ebp
  801e8e:	0f 84 ac 00 00 00    	je     801f40 <__umoddi3+0x108>
  801e94:	bf 20 00 00 00       	mov    $0x20,%edi
  801e99:	29 ef                	sub    %ebp,%edi
  801e9b:	89 fe                	mov    %edi,%esi
  801e9d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801ea1:	89 e9                	mov    %ebp,%ecx
  801ea3:	d3 e0                	shl    %cl,%eax
  801ea5:	89 d7                	mov    %edx,%edi
  801ea7:	89 f1                	mov    %esi,%ecx
  801ea9:	d3 ef                	shr    %cl,%edi
  801eab:	09 c7                	or     %eax,%edi
  801ead:	89 e9                	mov    %ebp,%ecx
  801eaf:	d3 e2                	shl    %cl,%edx
  801eb1:	89 14 24             	mov    %edx,(%esp)
  801eb4:	89 d8                	mov    %ebx,%eax
  801eb6:	d3 e0                	shl    %cl,%eax
  801eb8:	89 c2                	mov    %eax,%edx
  801eba:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ebe:	d3 e0                	shl    %cl,%eax
  801ec0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ec4:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ec8:	89 f1                	mov    %esi,%ecx
  801eca:	d3 e8                	shr    %cl,%eax
  801ecc:	09 d0                	or     %edx,%eax
  801ece:	d3 eb                	shr    %cl,%ebx
  801ed0:	89 da                	mov    %ebx,%edx
  801ed2:	f7 f7                	div    %edi
  801ed4:	89 d3                	mov    %edx,%ebx
  801ed6:	f7 24 24             	mull   (%esp)
  801ed9:	89 c6                	mov    %eax,%esi
  801edb:	89 d1                	mov    %edx,%ecx
  801edd:	39 d3                	cmp    %edx,%ebx
  801edf:	0f 82 87 00 00 00    	jb     801f6c <__umoddi3+0x134>
  801ee5:	0f 84 91 00 00 00    	je     801f7c <__umoddi3+0x144>
  801eeb:	8b 54 24 04          	mov    0x4(%esp),%edx
  801eef:	29 f2                	sub    %esi,%edx
  801ef1:	19 cb                	sbb    %ecx,%ebx
  801ef3:	89 d8                	mov    %ebx,%eax
  801ef5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801ef9:	d3 e0                	shl    %cl,%eax
  801efb:	89 e9                	mov    %ebp,%ecx
  801efd:	d3 ea                	shr    %cl,%edx
  801eff:	09 d0                	or     %edx,%eax
  801f01:	89 e9                	mov    %ebp,%ecx
  801f03:	d3 eb                	shr    %cl,%ebx
  801f05:	89 da                	mov    %ebx,%edx
  801f07:	83 c4 1c             	add    $0x1c,%esp
  801f0a:	5b                   	pop    %ebx
  801f0b:	5e                   	pop    %esi
  801f0c:	5f                   	pop    %edi
  801f0d:	5d                   	pop    %ebp
  801f0e:	c3                   	ret    
  801f0f:	90                   	nop
  801f10:	89 fd                	mov    %edi,%ebp
  801f12:	85 ff                	test   %edi,%edi
  801f14:	75 0b                	jne    801f21 <__umoddi3+0xe9>
  801f16:	b8 01 00 00 00       	mov    $0x1,%eax
  801f1b:	31 d2                	xor    %edx,%edx
  801f1d:	f7 f7                	div    %edi
  801f1f:	89 c5                	mov    %eax,%ebp
  801f21:	89 f0                	mov    %esi,%eax
  801f23:	31 d2                	xor    %edx,%edx
  801f25:	f7 f5                	div    %ebp
  801f27:	89 c8                	mov    %ecx,%eax
  801f29:	f7 f5                	div    %ebp
  801f2b:	89 d0                	mov    %edx,%eax
  801f2d:	e9 44 ff ff ff       	jmp    801e76 <__umoddi3+0x3e>
  801f32:	66 90                	xchg   %ax,%ax
  801f34:	89 c8                	mov    %ecx,%eax
  801f36:	89 f2                	mov    %esi,%edx
  801f38:	83 c4 1c             	add    $0x1c,%esp
  801f3b:	5b                   	pop    %ebx
  801f3c:	5e                   	pop    %esi
  801f3d:	5f                   	pop    %edi
  801f3e:	5d                   	pop    %ebp
  801f3f:	c3                   	ret    
  801f40:	3b 04 24             	cmp    (%esp),%eax
  801f43:	72 06                	jb     801f4b <__umoddi3+0x113>
  801f45:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801f49:	77 0f                	ja     801f5a <__umoddi3+0x122>
  801f4b:	89 f2                	mov    %esi,%edx
  801f4d:	29 f9                	sub    %edi,%ecx
  801f4f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801f53:	89 14 24             	mov    %edx,(%esp)
  801f56:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801f5a:	8b 44 24 04          	mov    0x4(%esp),%eax
  801f5e:	8b 14 24             	mov    (%esp),%edx
  801f61:	83 c4 1c             	add    $0x1c,%esp
  801f64:	5b                   	pop    %ebx
  801f65:	5e                   	pop    %esi
  801f66:	5f                   	pop    %edi
  801f67:	5d                   	pop    %ebp
  801f68:	c3                   	ret    
  801f69:	8d 76 00             	lea    0x0(%esi),%esi
  801f6c:	2b 04 24             	sub    (%esp),%eax
  801f6f:	19 fa                	sbb    %edi,%edx
  801f71:	89 d1                	mov    %edx,%ecx
  801f73:	89 c6                	mov    %eax,%esi
  801f75:	e9 71 ff ff ff       	jmp    801eeb <__umoddi3+0xb3>
  801f7a:	66 90                	xchg   %ax,%ax
  801f7c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801f80:	72 ea                	jb     801f6c <__umoddi3+0x134>
  801f82:	89 d9                	mov    %ebx,%ecx
  801f84:	e9 62 ff ff ff       	jmp    801eeb <__umoddi3+0xb3>
