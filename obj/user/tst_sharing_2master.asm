
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
  800031:	e8 35 03 00 00       	call   80036b <libmain>
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
  80008d:	68 a0 38 80 00       	push   $0x8038a0
  800092:	6a 13                	push   $0x13
  800094:	68 bc 38 80 00       	push   $0x8038bc
  800099:	e8 09 04 00 00       	call   8004a7 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	6a 00                	push   $0x0
  8000a3:	e8 3b 16 00 00       	call   8016e3 <malloc>
  8000a8:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	uint32 *x, *y, *z ;

	//x: Readonly
	int freeFrames = sys_calculate_free_frames() ;
  8000ab:	e8 08 19 00 00       	call   8019b8 <sys_calculate_free_frames>
  8000b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	x = smalloc("x", 4, 0);
  8000b3:	83 ec 04             	sub    $0x4,%esp
  8000b6:	6a 00                	push   $0x0
  8000b8:	6a 04                	push   $0x4
  8000ba:	68 d7 38 80 00       	push   $0x8038d7
  8000bf:	e8 b4 16 00 00       	call   801778 <smalloc>
  8000c4:	83 c4 10             	add    $0x10,%esp
  8000c7:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if (x != (uint32*)USER_HEAP_START) panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8000ca:	81 7d e8 00 00 00 80 	cmpl   $0x80000000,-0x18(%ebp)
  8000d1:	74 14                	je     8000e7 <_main+0xaf>
  8000d3:	83 ec 04             	sub    $0x4,%esp
  8000d6:	68 dc 38 80 00       	push   $0x8038dc
  8000db:	6a 1e                	push   $0x1e
  8000dd:	68 bc 38 80 00       	push   $0x8038bc
  8000e2:	e8 c0 03 00 00       	call   8004a7 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Create(): Wrong allocation- make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8000e7:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000ea:	e8 c9 18 00 00       	call   8019b8 <sys_calculate_free_frames>
  8000ef:	29 c3                	sub    %eax,%ebx
  8000f1:	89 d8                	mov    %ebx,%eax
  8000f3:	83 f8 04             	cmp    $0x4,%eax
  8000f6:	74 14                	je     80010c <_main+0xd4>
  8000f8:	83 ec 04             	sub    $0x4,%esp
  8000fb:	68 40 39 80 00       	push   $0x803940
  800100:	6a 1f                	push   $0x1f
  800102:	68 bc 38 80 00       	push   $0x8038bc
  800107:	e8 9b 03 00 00       	call   8004a7 <_panic>

	//y: Readonly
	freeFrames = sys_calculate_free_frames() ;
  80010c:	e8 a7 18 00 00       	call   8019b8 <sys_calculate_free_frames>
  800111:	89 45 ec             	mov    %eax,-0x14(%ebp)
	y = smalloc("y", 4, 0);
  800114:	83 ec 04             	sub    $0x4,%esp
  800117:	6a 00                	push   $0x0
  800119:	6a 04                	push   $0x4
  80011b:	68 c8 39 80 00       	push   $0x8039c8
  800120:	e8 53 16 00 00       	call   801778 <smalloc>
  800125:	83 c4 10             	add    $0x10,%esp
  800128:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (y != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  80012b:	81 7d e4 00 10 00 80 	cmpl   $0x80001000,-0x1c(%ebp)
  800132:	74 14                	je     800148 <_main+0x110>
  800134:	83 ec 04             	sub    $0x4,%esp
  800137:	68 dc 38 80 00       	push   $0x8038dc
  80013c:	6a 24                	push   $0x24
  80013e:	68 bc 38 80 00       	push   $0x8038bc
  800143:	e8 5f 03 00 00       	call   8004a7 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1+0+2) panic("Create(): Wrong allocation- make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800148:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  80014b:	e8 68 18 00 00       	call   8019b8 <sys_calculate_free_frames>
  800150:	29 c3                	sub    %eax,%ebx
  800152:	89 d8                	mov    %ebx,%eax
  800154:	83 f8 03             	cmp    $0x3,%eax
  800157:	74 14                	je     80016d <_main+0x135>
  800159:	83 ec 04             	sub    $0x4,%esp
  80015c:	68 40 39 80 00       	push   $0x803940
  800161:	6a 25                	push   $0x25
  800163:	68 bc 38 80 00       	push   $0x8038bc
  800168:	e8 3a 03 00 00       	call   8004a7 <_panic>

	//z: Writable
	freeFrames = sys_calculate_free_frames() ;
  80016d:	e8 46 18 00 00       	call   8019b8 <sys_calculate_free_frames>
  800172:	89 45 ec             	mov    %eax,-0x14(%ebp)
	z = smalloc("z", 4, 1);
  800175:	83 ec 04             	sub    $0x4,%esp
  800178:	6a 01                	push   $0x1
  80017a:	6a 04                	push   $0x4
  80017c:	68 ca 39 80 00       	push   $0x8039ca
  800181:	e8 f2 15 00 00       	call   801778 <smalloc>
  800186:	83 c4 10             	add    $0x10,%esp
  800189:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (z != (uint32*)(USER_HEAP_START + 2 * PAGE_SIZE)) panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  80018c:	81 7d e0 00 20 00 80 	cmpl   $0x80002000,-0x20(%ebp)
  800193:	74 14                	je     8001a9 <_main+0x171>
  800195:	83 ec 04             	sub    $0x4,%esp
  800198:	68 dc 38 80 00       	push   $0x8038dc
  80019d:	6a 2a                	push   $0x2a
  80019f:	68 bc 38 80 00       	push   $0x8038bc
  8001a4:	e8 fe 02 00 00       	call   8004a7 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1+0+2) panic("Create(): Wrong allocation- make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8001a9:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8001ac:	e8 07 18 00 00       	call   8019b8 <sys_calculate_free_frames>
  8001b1:	29 c3                	sub    %eax,%ebx
  8001b3:	89 d8                	mov    %ebx,%eax
  8001b5:	83 f8 03             	cmp    $0x3,%eax
  8001b8:	74 14                	je     8001ce <_main+0x196>
  8001ba:	83 ec 04             	sub    $0x4,%esp
  8001bd:	68 40 39 80 00       	push   $0x803940
  8001c2:	6a 2b                	push   $0x2b
  8001c4:	68 bc 38 80 00       	push   $0x8038bc
  8001c9:	e8 d9 02 00 00       	call   8004a7 <_panic>

	*x = 10 ;
  8001ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001d1:	c7 00 0a 00 00 00    	movl   $0xa,(%eax)
	*y = 20 ;
  8001d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001da:	c7 00 14 00 00 00    	movl   $0x14,(%eax)

	int id1, id2, id3;
	id1 = sys_create_env("shr2Slave1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8001e0:	a1 20 50 80 00       	mov    0x805020,%eax
  8001e5:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  8001eb:	a1 20 50 80 00       	mov    0x805020,%eax
  8001f0:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8001f6:	89 c1                	mov    %eax,%ecx
  8001f8:	a1 20 50 80 00       	mov    0x805020,%eax
  8001fd:	8b 40 74             	mov    0x74(%eax),%eax
  800200:	52                   	push   %edx
  800201:	51                   	push   %ecx
  800202:	50                   	push   %eax
  800203:	68 cc 39 80 00       	push   $0x8039cc
  800208:	e8 1d 1a 00 00       	call   801c2a <sys_create_env>
  80020d:	83 c4 10             	add    $0x10,%esp
  800210:	89 45 dc             	mov    %eax,-0x24(%ebp)
	id2 = sys_create_env("shr2Slave1", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  800213:	a1 20 50 80 00       	mov    0x805020,%eax
  800218:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  80021e:	a1 20 50 80 00       	mov    0x805020,%eax
  800223:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800229:	89 c1                	mov    %eax,%ecx
  80022b:	a1 20 50 80 00       	mov    0x805020,%eax
  800230:	8b 40 74             	mov    0x74(%eax),%eax
  800233:	52                   	push   %edx
  800234:	51                   	push   %ecx
  800235:	50                   	push   %eax
  800236:	68 cc 39 80 00       	push   $0x8039cc
  80023b:	e8 ea 19 00 00       	call   801c2a <sys_create_env>
  800240:	83 c4 10             	add    $0x10,%esp
  800243:	89 45 d8             	mov    %eax,-0x28(%ebp)
	id3 = sys_create_env("shr2Slave1", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  800246:	a1 20 50 80 00       	mov    0x805020,%eax
  80024b:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  800251:	a1 20 50 80 00       	mov    0x805020,%eax
  800256:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80025c:	89 c1                	mov    %eax,%ecx
  80025e:	a1 20 50 80 00       	mov    0x805020,%eax
  800263:	8b 40 74             	mov    0x74(%eax),%eax
  800266:	52                   	push   %edx
  800267:	51                   	push   %ecx
  800268:	50                   	push   %eax
  800269:	68 cc 39 80 00       	push   $0x8039cc
  80026e:	e8 b7 19 00 00       	call   801c2a <sys_create_env>
  800273:	83 c4 10             	add    $0x10,%esp
  800276:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	//to check that the slave environments completed successfully
	rsttst();
  800279:	e8 f8 1a 00 00       	call   801d76 <rsttst>

	sys_run_env(id1);
  80027e:	83 ec 0c             	sub    $0xc,%esp
  800281:	ff 75 dc             	pushl  -0x24(%ebp)
  800284:	e8 bf 19 00 00       	call   801c48 <sys_run_env>
  800289:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id2);
  80028c:	83 ec 0c             	sub    $0xc,%esp
  80028f:	ff 75 d8             	pushl  -0x28(%ebp)
  800292:	e8 b1 19 00 00       	call   801c48 <sys_run_env>
  800297:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id3);
  80029a:	83 ec 0c             	sub    $0xc,%esp
  80029d:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002a0:	e8 a3 19 00 00       	call   801c48 <sys_run_env>
  8002a5:	83 c4 10             	add    $0x10,%esp

	env_sleep(12000) ;
  8002a8:	83 ec 0c             	sub    $0xc,%esp
  8002ab:	68 e0 2e 00 00       	push   $0x2ee0
  8002b0:	e8 c5 32 00 00       	call   80357a <env_sleep>
  8002b5:	83 c4 10             	add    $0x10,%esp

	//to ensure that the slave environments completed successfully
	if (gettst()!=3) panic("test failed");
  8002b8:	e8 33 1b 00 00       	call   801df0 <gettst>
  8002bd:	83 f8 03             	cmp    $0x3,%eax
  8002c0:	74 14                	je     8002d6 <_main+0x29e>
  8002c2:	83 ec 04             	sub    $0x4,%esp
  8002c5:	68 d7 39 80 00       	push   $0x8039d7
  8002ca:	6a 3f                	push   $0x3f
  8002cc:	68 bc 38 80 00       	push   $0x8038bc
  8002d1:	e8 d1 01 00 00       	call   8004a7 <_panic>


	if (*z != 30)
  8002d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002d9:	8b 00                	mov    (%eax),%eax
  8002db:	83 f8 1e             	cmp    $0x1e,%eax
  8002de:	74 14                	je     8002f4 <_main+0x2bc>
		panic("Error!! Please check the creation (or the getting) of shared variables!!\n\n\n");
  8002e0:	83 ec 04             	sub    $0x4,%esp
  8002e3:	68 e4 39 80 00       	push   $0x8039e4
  8002e8:	6a 43                	push   $0x43
  8002ea:	68 bc 38 80 00       	push   $0x8038bc
  8002ef:	e8 b3 01 00 00       	call   8004a7 <_panic>
	else
		cprintf("Congratulations!! Test of Shared Variables [Create & Get] [2] completed successfully!!\n\n\n");
  8002f4:	83 ec 0c             	sub    $0xc,%esp
  8002f7:	68 30 3a 80 00       	push   $0x803a30
  8002fc:	e8 5a 04 00 00       	call   80075b <cprintf>
  800301:	83 c4 10             	add    $0x10,%esp

	cprintf("Now, ILLEGAL MEM ACCESS should be occur, due to attempting to write a ReadOnly variable\n\n\n");
  800304:	83 ec 0c             	sub    $0xc,%esp
  800307:	68 8c 3a 80 00       	push   $0x803a8c
  80030c:	e8 4a 04 00 00       	call   80075b <cprintf>
  800311:	83 c4 10             	add    $0x10,%esp

	id1 = sys_create_env("shr2Slave2", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  800314:	a1 20 50 80 00       	mov    0x805020,%eax
  800319:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  80031f:	a1 20 50 80 00       	mov    0x805020,%eax
  800324:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80032a:	89 c1                	mov    %eax,%ecx
  80032c:	a1 20 50 80 00       	mov    0x805020,%eax
  800331:	8b 40 74             	mov    0x74(%eax),%eax
  800334:	52                   	push   %edx
  800335:	51                   	push   %ecx
  800336:	50                   	push   %eax
  800337:	68 e7 3a 80 00       	push   $0x803ae7
  80033c:	e8 e9 18 00 00       	call   801c2a <sys_create_env>
  800341:	83 c4 10             	add    $0x10,%esp
  800344:	89 45 dc             	mov    %eax,-0x24(%ebp)

	env_sleep(3000) ;
  800347:	83 ec 0c             	sub    $0xc,%esp
  80034a:	68 b8 0b 00 00       	push   $0xbb8
  80034f:	e8 26 32 00 00       	call   80357a <env_sleep>
  800354:	83 c4 10             	add    $0x10,%esp

	sys_run_env(id1);
  800357:	83 ec 0c             	sub    $0xc,%esp
  80035a:	ff 75 dc             	pushl  -0x24(%ebp)
  80035d:	e8 e6 18 00 00       	call   801c48 <sys_run_env>
  800362:	83 c4 10             	add    $0x10,%esp

	return;
  800365:	90                   	nop
}
  800366:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800369:	c9                   	leave  
  80036a:	c3                   	ret    

0080036b <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80036b:	55                   	push   %ebp
  80036c:	89 e5                	mov    %esp,%ebp
  80036e:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800371:	e8 22 19 00 00       	call   801c98 <sys_getenvindex>
  800376:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800379:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80037c:	89 d0                	mov    %edx,%eax
  80037e:	c1 e0 03             	shl    $0x3,%eax
  800381:	01 d0                	add    %edx,%eax
  800383:	01 c0                	add    %eax,%eax
  800385:	01 d0                	add    %edx,%eax
  800387:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80038e:	01 d0                	add    %edx,%eax
  800390:	c1 e0 04             	shl    $0x4,%eax
  800393:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800398:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80039d:	a1 20 50 80 00       	mov    0x805020,%eax
  8003a2:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8003a8:	84 c0                	test   %al,%al
  8003aa:	74 0f                	je     8003bb <libmain+0x50>
		binaryname = myEnv->prog_name;
  8003ac:	a1 20 50 80 00       	mov    0x805020,%eax
  8003b1:	05 5c 05 00 00       	add    $0x55c,%eax
  8003b6:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003bb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8003bf:	7e 0a                	jle    8003cb <libmain+0x60>
		binaryname = argv[0];
  8003c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003c4:	8b 00                	mov    (%eax),%eax
  8003c6:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8003cb:	83 ec 08             	sub    $0x8,%esp
  8003ce:	ff 75 0c             	pushl  0xc(%ebp)
  8003d1:	ff 75 08             	pushl  0x8(%ebp)
  8003d4:	e8 5f fc ff ff       	call   800038 <_main>
  8003d9:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8003dc:	e8 c4 16 00 00       	call   801aa5 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8003e1:	83 ec 0c             	sub    $0xc,%esp
  8003e4:	68 0c 3b 80 00       	push   $0x803b0c
  8003e9:	e8 6d 03 00 00       	call   80075b <cprintf>
  8003ee:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8003f1:	a1 20 50 80 00       	mov    0x805020,%eax
  8003f6:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8003fc:	a1 20 50 80 00       	mov    0x805020,%eax
  800401:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800407:	83 ec 04             	sub    $0x4,%esp
  80040a:	52                   	push   %edx
  80040b:	50                   	push   %eax
  80040c:	68 34 3b 80 00       	push   $0x803b34
  800411:	e8 45 03 00 00       	call   80075b <cprintf>
  800416:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800419:	a1 20 50 80 00       	mov    0x805020,%eax
  80041e:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800424:	a1 20 50 80 00       	mov    0x805020,%eax
  800429:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80042f:	a1 20 50 80 00       	mov    0x805020,%eax
  800434:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80043a:	51                   	push   %ecx
  80043b:	52                   	push   %edx
  80043c:	50                   	push   %eax
  80043d:	68 5c 3b 80 00       	push   $0x803b5c
  800442:	e8 14 03 00 00       	call   80075b <cprintf>
  800447:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80044a:	a1 20 50 80 00       	mov    0x805020,%eax
  80044f:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800455:	83 ec 08             	sub    $0x8,%esp
  800458:	50                   	push   %eax
  800459:	68 b4 3b 80 00       	push   $0x803bb4
  80045e:	e8 f8 02 00 00       	call   80075b <cprintf>
  800463:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800466:	83 ec 0c             	sub    $0xc,%esp
  800469:	68 0c 3b 80 00       	push   $0x803b0c
  80046e:	e8 e8 02 00 00       	call   80075b <cprintf>
  800473:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800476:	e8 44 16 00 00       	call   801abf <sys_enable_interrupt>

	// exit gracefully
	exit();
  80047b:	e8 19 00 00 00       	call   800499 <exit>
}
  800480:	90                   	nop
  800481:	c9                   	leave  
  800482:	c3                   	ret    

00800483 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800483:	55                   	push   %ebp
  800484:	89 e5                	mov    %esp,%ebp
  800486:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800489:	83 ec 0c             	sub    $0xc,%esp
  80048c:	6a 00                	push   $0x0
  80048e:	e8 d1 17 00 00       	call   801c64 <sys_destroy_env>
  800493:	83 c4 10             	add    $0x10,%esp
}
  800496:	90                   	nop
  800497:	c9                   	leave  
  800498:	c3                   	ret    

00800499 <exit>:

void
exit(void)
{
  800499:	55                   	push   %ebp
  80049a:	89 e5                	mov    %esp,%ebp
  80049c:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80049f:	e8 26 18 00 00       	call   801cca <sys_exit_env>
}
  8004a4:	90                   	nop
  8004a5:	c9                   	leave  
  8004a6:	c3                   	ret    

008004a7 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8004a7:	55                   	push   %ebp
  8004a8:	89 e5                	mov    %esp,%ebp
  8004aa:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8004ad:	8d 45 10             	lea    0x10(%ebp),%eax
  8004b0:	83 c0 04             	add    $0x4,%eax
  8004b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8004b6:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8004bb:	85 c0                	test   %eax,%eax
  8004bd:	74 16                	je     8004d5 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8004bf:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8004c4:	83 ec 08             	sub    $0x8,%esp
  8004c7:	50                   	push   %eax
  8004c8:	68 c8 3b 80 00       	push   $0x803bc8
  8004cd:	e8 89 02 00 00       	call   80075b <cprintf>
  8004d2:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8004d5:	a1 00 50 80 00       	mov    0x805000,%eax
  8004da:	ff 75 0c             	pushl  0xc(%ebp)
  8004dd:	ff 75 08             	pushl  0x8(%ebp)
  8004e0:	50                   	push   %eax
  8004e1:	68 cd 3b 80 00       	push   $0x803bcd
  8004e6:	e8 70 02 00 00       	call   80075b <cprintf>
  8004eb:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8004ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8004f1:	83 ec 08             	sub    $0x8,%esp
  8004f4:	ff 75 f4             	pushl  -0xc(%ebp)
  8004f7:	50                   	push   %eax
  8004f8:	e8 f3 01 00 00       	call   8006f0 <vcprintf>
  8004fd:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800500:	83 ec 08             	sub    $0x8,%esp
  800503:	6a 00                	push   $0x0
  800505:	68 e9 3b 80 00       	push   $0x803be9
  80050a:	e8 e1 01 00 00       	call   8006f0 <vcprintf>
  80050f:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800512:	e8 82 ff ff ff       	call   800499 <exit>

	// should not return here
	while (1) ;
  800517:	eb fe                	jmp    800517 <_panic+0x70>

00800519 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800519:	55                   	push   %ebp
  80051a:	89 e5                	mov    %esp,%ebp
  80051c:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80051f:	a1 20 50 80 00       	mov    0x805020,%eax
  800524:	8b 50 74             	mov    0x74(%eax),%edx
  800527:	8b 45 0c             	mov    0xc(%ebp),%eax
  80052a:	39 c2                	cmp    %eax,%edx
  80052c:	74 14                	je     800542 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80052e:	83 ec 04             	sub    $0x4,%esp
  800531:	68 ec 3b 80 00       	push   $0x803bec
  800536:	6a 26                	push   $0x26
  800538:	68 38 3c 80 00       	push   $0x803c38
  80053d:	e8 65 ff ff ff       	call   8004a7 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800542:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800549:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800550:	e9 c2 00 00 00       	jmp    800617 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800555:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800558:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80055f:	8b 45 08             	mov    0x8(%ebp),%eax
  800562:	01 d0                	add    %edx,%eax
  800564:	8b 00                	mov    (%eax),%eax
  800566:	85 c0                	test   %eax,%eax
  800568:	75 08                	jne    800572 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80056a:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80056d:	e9 a2 00 00 00       	jmp    800614 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800572:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800579:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800580:	eb 69                	jmp    8005eb <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800582:	a1 20 50 80 00       	mov    0x805020,%eax
  800587:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80058d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800590:	89 d0                	mov    %edx,%eax
  800592:	01 c0                	add    %eax,%eax
  800594:	01 d0                	add    %edx,%eax
  800596:	c1 e0 03             	shl    $0x3,%eax
  800599:	01 c8                	add    %ecx,%eax
  80059b:	8a 40 04             	mov    0x4(%eax),%al
  80059e:	84 c0                	test   %al,%al
  8005a0:	75 46                	jne    8005e8 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005a2:	a1 20 50 80 00       	mov    0x805020,%eax
  8005a7:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8005ad:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005b0:	89 d0                	mov    %edx,%eax
  8005b2:	01 c0                	add    %eax,%eax
  8005b4:	01 d0                	add    %edx,%eax
  8005b6:	c1 e0 03             	shl    $0x3,%eax
  8005b9:	01 c8                	add    %ecx,%eax
  8005bb:	8b 00                	mov    (%eax),%eax
  8005bd:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005c0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005c3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005c8:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8005ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005cd:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d7:	01 c8                	add    %ecx,%eax
  8005d9:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005db:	39 c2                	cmp    %eax,%edx
  8005dd:	75 09                	jne    8005e8 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8005df:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8005e6:	eb 12                	jmp    8005fa <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005e8:	ff 45 e8             	incl   -0x18(%ebp)
  8005eb:	a1 20 50 80 00       	mov    0x805020,%eax
  8005f0:	8b 50 74             	mov    0x74(%eax),%edx
  8005f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005f6:	39 c2                	cmp    %eax,%edx
  8005f8:	77 88                	ja     800582 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8005fa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8005fe:	75 14                	jne    800614 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800600:	83 ec 04             	sub    $0x4,%esp
  800603:	68 44 3c 80 00       	push   $0x803c44
  800608:	6a 3a                	push   $0x3a
  80060a:	68 38 3c 80 00       	push   $0x803c38
  80060f:	e8 93 fe ff ff       	call   8004a7 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800614:	ff 45 f0             	incl   -0x10(%ebp)
  800617:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80061a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80061d:	0f 8c 32 ff ff ff    	jl     800555 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800623:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80062a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800631:	eb 26                	jmp    800659 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800633:	a1 20 50 80 00       	mov    0x805020,%eax
  800638:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80063e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800641:	89 d0                	mov    %edx,%eax
  800643:	01 c0                	add    %eax,%eax
  800645:	01 d0                	add    %edx,%eax
  800647:	c1 e0 03             	shl    $0x3,%eax
  80064a:	01 c8                	add    %ecx,%eax
  80064c:	8a 40 04             	mov    0x4(%eax),%al
  80064f:	3c 01                	cmp    $0x1,%al
  800651:	75 03                	jne    800656 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800653:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800656:	ff 45 e0             	incl   -0x20(%ebp)
  800659:	a1 20 50 80 00       	mov    0x805020,%eax
  80065e:	8b 50 74             	mov    0x74(%eax),%edx
  800661:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800664:	39 c2                	cmp    %eax,%edx
  800666:	77 cb                	ja     800633 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800668:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80066b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80066e:	74 14                	je     800684 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800670:	83 ec 04             	sub    $0x4,%esp
  800673:	68 98 3c 80 00       	push   $0x803c98
  800678:	6a 44                	push   $0x44
  80067a:	68 38 3c 80 00       	push   $0x803c38
  80067f:	e8 23 fe ff ff       	call   8004a7 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800684:	90                   	nop
  800685:	c9                   	leave  
  800686:	c3                   	ret    

00800687 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800687:	55                   	push   %ebp
  800688:	89 e5                	mov    %esp,%ebp
  80068a:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80068d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800690:	8b 00                	mov    (%eax),%eax
  800692:	8d 48 01             	lea    0x1(%eax),%ecx
  800695:	8b 55 0c             	mov    0xc(%ebp),%edx
  800698:	89 0a                	mov    %ecx,(%edx)
  80069a:	8b 55 08             	mov    0x8(%ebp),%edx
  80069d:	88 d1                	mov    %dl,%cl
  80069f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006a2:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8006a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006a9:	8b 00                	mov    (%eax),%eax
  8006ab:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006b0:	75 2c                	jne    8006de <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8006b2:	a0 24 50 80 00       	mov    0x805024,%al
  8006b7:	0f b6 c0             	movzbl %al,%eax
  8006ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006bd:	8b 12                	mov    (%edx),%edx
  8006bf:	89 d1                	mov    %edx,%ecx
  8006c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006c4:	83 c2 08             	add    $0x8,%edx
  8006c7:	83 ec 04             	sub    $0x4,%esp
  8006ca:	50                   	push   %eax
  8006cb:	51                   	push   %ecx
  8006cc:	52                   	push   %edx
  8006cd:	e8 25 12 00 00       	call   8018f7 <sys_cputs>
  8006d2:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006d8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006e1:	8b 40 04             	mov    0x4(%eax),%eax
  8006e4:	8d 50 01             	lea    0x1(%eax),%edx
  8006e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006ea:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006ed:	90                   	nop
  8006ee:	c9                   	leave  
  8006ef:	c3                   	ret    

008006f0 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006f0:	55                   	push   %ebp
  8006f1:	89 e5                	mov    %esp,%ebp
  8006f3:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006f9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800700:	00 00 00 
	b.cnt = 0;
  800703:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80070a:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80070d:	ff 75 0c             	pushl  0xc(%ebp)
  800710:	ff 75 08             	pushl  0x8(%ebp)
  800713:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800719:	50                   	push   %eax
  80071a:	68 87 06 80 00       	push   $0x800687
  80071f:	e8 11 02 00 00       	call   800935 <vprintfmt>
  800724:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800727:	a0 24 50 80 00       	mov    0x805024,%al
  80072c:	0f b6 c0             	movzbl %al,%eax
  80072f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800735:	83 ec 04             	sub    $0x4,%esp
  800738:	50                   	push   %eax
  800739:	52                   	push   %edx
  80073a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800740:	83 c0 08             	add    $0x8,%eax
  800743:	50                   	push   %eax
  800744:	e8 ae 11 00 00       	call   8018f7 <sys_cputs>
  800749:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80074c:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  800753:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800759:	c9                   	leave  
  80075a:	c3                   	ret    

0080075b <cprintf>:

int cprintf(const char *fmt, ...) {
  80075b:	55                   	push   %ebp
  80075c:	89 e5                	mov    %esp,%ebp
  80075e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800761:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800768:	8d 45 0c             	lea    0xc(%ebp),%eax
  80076b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80076e:	8b 45 08             	mov    0x8(%ebp),%eax
  800771:	83 ec 08             	sub    $0x8,%esp
  800774:	ff 75 f4             	pushl  -0xc(%ebp)
  800777:	50                   	push   %eax
  800778:	e8 73 ff ff ff       	call   8006f0 <vcprintf>
  80077d:	83 c4 10             	add    $0x10,%esp
  800780:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800783:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800786:	c9                   	leave  
  800787:	c3                   	ret    

00800788 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800788:	55                   	push   %ebp
  800789:	89 e5                	mov    %esp,%ebp
  80078b:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80078e:	e8 12 13 00 00       	call   801aa5 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800793:	8d 45 0c             	lea    0xc(%ebp),%eax
  800796:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800799:	8b 45 08             	mov    0x8(%ebp),%eax
  80079c:	83 ec 08             	sub    $0x8,%esp
  80079f:	ff 75 f4             	pushl  -0xc(%ebp)
  8007a2:	50                   	push   %eax
  8007a3:	e8 48 ff ff ff       	call   8006f0 <vcprintf>
  8007a8:	83 c4 10             	add    $0x10,%esp
  8007ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8007ae:	e8 0c 13 00 00       	call   801abf <sys_enable_interrupt>
	return cnt;
  8007b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007b6:	c9                   	leave  
  8007b7:	c3                   	ret    

008007b8 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007b8:	55                   	push   %ebp
  8007b9:	89 e5                	mov    %esp,%ebp
  8007bb:	53                   	push   %ebx
  8007bc:	83 ec 14             	sub    $0x14,%esp
  8007bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8007c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007cb:	8b 45 18             	mov    0x18(%ebp),%eax
  8007ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8007d3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007d6:	77 55                	ja     80082d <printnum+0x75>
  8007d8:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007db:	72 05                	jb     8007e2 <printnum+0x2a>
  8007dd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8007e0:	77 4b                	ja     80082d <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8007e2:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8007e5:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8007e8:	8b 45 18             	mov    0x18(%ebp),%eax
  8007eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8007f0:	52                   	push   %edx
  8007f1:	50                   	push   %eax
  8007f2:	ff 75 f4             	pushl  -0xc(%ebp)
  8007f5:	ff 75 f0             	pushl  -0x10(%ebp)
  8007f8:	e8 33 2e 00 00       	call   803630 <__udivdi3>
  8007fd:	83 c4 10             	add    $0x10,%esp
  800800:	83 ec 04             	sub    $0x4,%esp
  800803:	ff 75 20             	pushl  0x20(%ebp)
  800806:	53                   	push   %ebx
  800807:	ff 75 18             	pushl  0x18(%ebp)
  80080a:	52                   	push   %edx
  80080b:	50                   	push   %eax
  80080c:	ff 75 0c             	pushl  0xc(%ebp)
  80080f:	ff 75 08             	pushl  0x8(%ebp)
  800812:	e8 a1 ff ff ff       	call   8007b8 <printnum>
  800817:	83 c4 20             	add    $0x20,%esp
  80081a:	eb 1a                	jmp    800836 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80081c:	83 ec 08             	sub    $0x8,%esp
  80081f:	ff 75 0c             	pushl  0xc(%ebp)
  800822:	ff 75 20             	pushl  0x20(%ebp)
  800825:	8b 45 08             	mov    0x8(%ebp),%eax
  800828:	ff d0                	call   *%eax
  80082a:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80082d:	ff 4d 1c             	decl   0x1c(%ebp)
  800830:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800834:	7f e6                	jg     80081c <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800836:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800839:	bb 00 00 00 00       	mov    $0x0,%ebx
  80083e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800841:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800844:	53                   	push   %ebx
  800845:	51                   	push   %ecx
  800846:	52                   	push   %edx
  800847:	50                   	push   %eax
  800848:	e8 f3 2e 00 00       	call   803740 <__umoddi3>
  80084d:	83 c4 10             	add    $0x10,%esp
  800850:	05 14 3f 80 00       	add    $0x803f14,%eax
  800855:	8a 00                	mov    (%eax),%al
  800857:	0f be c0             	movsbl %al,%eax
  80085a:	83 ec 08             	sub    $0x8,%esp
  80085d:	ff 75 0c             	pushl  0xc(%ebp)
  800860:	50                   	push   %eax
  800861:	8b 45 08             	mov    0x8(%ebp),%eax
  800864:	ff d0                	call   *%eax
  800866:	83 c4 10             	add    $0x10,%esp
}
  800869:	90                   	nop
  80086a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80086d:	c9                   	leave  
  80086e:	c3                   	ret    

0080086f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80086f:	55                   	push   %ebp
  800870:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800872:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800876:	7e 1c                	jle    800894 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800878:	8b 45 08             	mov    0x8(%ebp),%eax
  80087b:	8b 00                	mov    (%eax),%eax
  80087d:	8d 50 08             	lea    0x8(%eax),%edx
  800880:	8b 45 08             	mov    0x8(%ebp),%eax
  800883:	89 10                	mov    %edx,(%eax)
  800885:	8b 45 08             	mov    0x8(%ebp),%eax
  800888:	8b 00                	mov    (%eax),%eax
  80088a:	83 e8 08             	sub    $0x8,%eax
  80088d:	8b 50 04             	mov    0x4(%eax),%edx
  800890:	8b 00                	mov    (%eax),%eax
  800892:	eb 40                	jmp    8008d4 <getuint+0x65>
	else if (lflag)
  800894:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800898:	74 1e                	je     8008b8 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80089a:	8b 45 08             	mov    0x8(%ebp),%eax
  80089d:	8b 00                	mov    (%eax),%eax
  80089f:	8d 50 04             	lea    0x4(%eax),%edx
  8008a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a5:	89 10                	mov    %edx,(%eax)
  8008a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008aa:	8b 00                	mov    (%eax),%eax
  8008ac:	83 e8 04             	sub    $0x4,%eax
  8008af:	8b 00                	mov    (%eax),%eax
  8008b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8008b6:	eb 1c                	jmp    8008d4 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bb:	8b 00                	mov    (%eax),%eax
  8008bd:	8d 50 04             	lea    0x4(%eax),%edx
  8008c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c3:	89 10                	mov    %edx,(%eax)
  8008c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c8:	8b 00                	mov    (%eax),%eax
  8008ca:	83 e8 04             	sub    $0x4,%eax
  8008cd:	8b 00                	mov    (%eax),%eax
  8008cf:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8008d4:	5d                   	pop    %ebp
  8008d5:	c3                   	ret    

008008d6 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008d6:	55                   	push   %ebp
  8008d7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008d9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008dd:	7e 1c                	jle    8008fb <getint+0x25>
		return va_arg(*ap, long long);
  8008df:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e2:	8b 00                	mov    (%eax),%eax
  8008e4:	8d 50 08             	lea    0x8(%eax),%edx
  8008e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ea:	89 10                	mov    %edx,(%eax)
  8008ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ef:	8b 00                	mov    (%eax),%eax
  8008f1:	83 e8 08             	sub    $0x8,%eax
  8008f4:	8b 50 04             	mov    0x4(%eax),%edx
  8008f7:	8b 00                	mov    (%eax),%eax
  8008f9:	eb 38                	jmp    800933 <getint+0x5d>
	else if (lflag)
  8008fb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008ff:	74 1a                	je     80091b <getint+0x45>
		return va_arg(*ap, long);
  800901:	8b 45 08             	mov    0x8(%ebp),%eax
  800904:	8b 00                	mov    (%eax),%eax
  800906:	8d 50 04             	lea    0x4(%eax),%edx
  800909:	8b 45 08             	mov    0x8(%ebp),%eax
  80090c:	89 10                	mov    %edx,(%eax)
  80090e:	8b 45 08             	mov    0x8(%ebp),%eax
  800911:	8b 00                	mov    (%eax),%eax
  800913:	83 e8 04             	sub    $0x4,%eax
  800916:	8b 00                	mov    (%eax),%eax
  800918:	99                   	cltd   
  800919:	eb 18                	jmp    800933 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80091b:	8b 45 08             	mov    0x8(%ebp),%eax
  80091e:	8b 00                	mov    (%eax),%eax
  800920:	8d 50 04             	lea    0x4(%eax),%edx
  800923:	8b 45 08             	mov    0x8(%ebp),%eax
  800926:	89 10                	mov    %edx,(%eax)
  800928:	8b 45 08             	mov    0x8(%ebp),%eax
  80092b:	8b 00                	mov    (%eax),%eax
  80092d:	83 e8 04             	sub    $0x4,%eax
  800930:	8b 00                	mov    (%eax),%eax
  800932:	99                   	cltd   
}
  800933:	5d                   	pop    %ebp
  800934:	c3                   	ret    

00800935 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800935:	55                   	push   %ebp
  800936:	89 e5                	mov    %esp,%ebp
  800938:	56                   	push   %esi
  800939:	53                   	push   %ebx
  80093a:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80093d:	eb 17                	jmp    800956 <vprintfmt+0x21>
			if (ch == '\0')
  80093f:	85 db                	test   %ebx,%ebx
  800941:	0f 84 af 03 00 00    	je     800cf6 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800947:	83 ec 08             	sub    $0x8,%esp
  80094a:	ff 75 0c             	pushl  0xc(%ebp)
  80094d:	53                   	push   %ebx
  80094e:	8b 45 08             	mov    0x8(%ebp),%eax
  800951:	ff d0                	call   *%eax
  800953:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800956:	8b 45 10             	mov    0x10(%ebp),%eax
  800959:	8d 50 01             	lea    0x1(%eax),%edx
  80095c:	89 55 10             	mov    %edx,0x10(%ebp)
  80095f:	8a 00                	mov    (%eax),%al
  800961:	0f b6 d8             	movzbl %al,%ebx
  800964:	83 fb 25             	cmp    $0x25,%ebx
  800967:	75 d6                	jne    80093f <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800969:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80096d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800974:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80097b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800982:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800989:	8b 45 10             	mov    0x10(%ebp),%eax
  80098c:	8d 50 01             	lea    0x1(%eax),%edx
  80098f:	89 55 10             	mov    %edx,0x10(%ebp)
  800992:	8a 00                	mov    (%eax),%al
  800994:	0f b6 d8             	movzbl %al,%ebx
  800997:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80099a:	83 f8 55             	cmp    $0x55,%eax
  80099d:	0f 87 2b 03 00 00    	ja     800cce <vprintfmt+0x399>
  8009a3:	8b 04 85 38 3f 80 00 	mov    0x803f38(,%eax,4),%eax
  8009aa:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009ac:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009b0:	eb d7                	jmp    800989 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009b2:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009b6:	eb d1                	jmp    800989 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009b8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009bf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009c2:	89 d0                	mov    %edx,%eax
  8009c4:	c1 e0 02             	shl    $0x2,%eax
  8009c7:	01 d0                	add    %edx,%eax
  8009c9:	01 c0                	add    %eax,%eax
  8009cb:	01 d8                	add    %ebx,%eax
  8009cd:	83 e8 30             	sub    $0x30,%eax
  8009d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8009d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8009d6:	8a 00                	mov    (%eax),%al
  8009d8:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009db:	83 fb 2f             	cmp    $0x2f,%ebx
  8009de:	7e 3e                	jle    800a1e <vprintfmt+0xe9>
  8009e0:	83 fb 39             	cmp    $0x39,%ebx
  8009e3:	7f 39                	jg     800a1e <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009e5:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009e8:	eb d5                	jmp    8009bf <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8009ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ed:	83 c0 04             	add    $0x4,%eax
  8009f0:	89 45 14             	mov    %eax,0x14(%ebp)
  8009f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f6:	83 e8 04             	sub    $0x4,%eax
  8009f9:	8b 00                	mov    (%eax),%eax
  8009fb:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8009fe:	eb 1f                	jmp    800a1f <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a00:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a04:	79 83                	jns    800989 <vprintfmt+0x54>
				width = 0;
  800a06:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a0d:	e9 77 ff ff ff       	jmp    800989 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a12:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a19:	e9 6b ff ff ff       	jmp    800989 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a1e:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a1f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a23:	0f 89 60 ff ff ff    	jns    800989 <vprintfmt+0x54>
				width = precision, precision = -1;
  800a29:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a2c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a2f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a36:	e9 4e ff ff ff       	jmp    800989 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a3b:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a3e:	e9 46 ff ff ff       	jmp    800989 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a43:	8b 45 14             	mov    0x14(%ebp),%eax
  800a46:	83 c0 04             	add    $0x4,%eax
  800a49:	89 45 14             	mov    %eax,0x14(%ebp)
  800a4c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a4f:	83 e8 04             	sub    $0x4,%eax
  800a52:	8b 00                	mov    (%eax),%eax
  800a54:	83 ec 08             	sub    $0x8,%esp
  800a57:	ff 75 0c             	pushl  0xc(%ebp)
  800a5a:	50                   	push   %eax
  800a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5e:	ff d0                	call   *%eax
  800a60:	83 c4 10             	add    $0x10,%esp
			break;
  800a63:	e9 89 02 00 00       	jmp    800cf1 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a68:	8b 45 14             	mov    0x14(%ebp),%eax
  800a6b:	83 c0 04             	add    $0x4,%eax
  800a6e:	89 45 14             	mov    %eax,0x14(%ebp)
  800a71:	8b 45 14             	mov    0x14(%ebp),%eax
  800a74:	83 e8 04             	sub    $0x4,%eax
  800a77:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a79:	85 db                	test   %ebx,%ebx
  800a7b:	79 02                	jns    800a7f <vprintfmt+0x14a>
				err = -err;
  800a7d:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a7f:	83 fb 64             	cmp    $0x64,%ebx
  800a82:	7f 0b                	jg     800a8f <vprintfmt+0x15a>
  800a84:	8b 34 9d 80 3d 80 00 	mov    0x803d80(,%ebx,4),%esi
  800a8b:	85 f6                	test   %esi,%esi
  800a8d:	75 19                	jne    800aa8 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a8f:	53                   	push   %ebx
  800a90:	68 25 3f 80 00       	push   $0x803f25
  800a95:	ff 75 0c             	pushl  0xc(%ebp)
  800a98:	ff 75 08             	pushl  0x8(%ebp)
  800a9b:	e8 5e 02 00 00       	call   800cfe <printfmt>
  800aa0:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800aa3:	e9 49 02 00 00       	jmp    800cf1 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800aa8:	56                   	push   %esi
  800aa9:	68 2e 3f 80 00       	push   $0x803f2e
  800aae:	ff 75 0c             	pushl  0xc(%ebp)
  800ab1:	ff 75 08             	pushl  0x8(%ebp)
  800ab4:	e8 45 02 00 00       	call   800cfe <printfmt>
  800ab9:	83 c4 10             	add    $0x10,%esp
			break;
  800abc:	e9 30 02 00 00       	jmp    800cf1 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800ac1:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac4:	83 c0 04             	add    $0x4,%eax
  800ac7:	89 45 14             	mov    %eax,0x14(%ebp)
  800aca:	8b 45 14             	mov    0x14(%ebp),%eax
  800acd:	83 e8 04             	sub    $0x4,%eax
  800ad0:	8b 30                	mov    (%eax),%esi
  800ad2:	85 f6                	test   %esi,%esi
  800ad4:	75 05                	jne    800adb <vprintfmt+0x1a6>
				p = "(null)";
  800ad6:	be 31 3f 80 00       	mov    $0x803f31,%esi
			if (width > 0 && padc != '-')
  800adb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800adf:	7e 6d                	jle    800b4e <vprintfmt+0x219>
  800ae1:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800ae5:	74 67                	je     800b4e <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ae7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800aea:	83 ec 08             	sub    $0x8,%esp
  800aed:	50                   	push   %eax
  800aee:	56                   	push   %esi
  800aef:	e8 0c 03 00 00       	call   800e00 <strnlen>
  800af4:	83 c4 10             	add    $0x10,%esp
  800af7:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800afa:	eb 16                	jmp    800b12 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800afc:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b00:	83 ec 08             	sub    $0x8,%esp
  800b03:	ff 75 0c             	pushl  0xc(%ebp)
  800b06:	50                   	push   %eax
  800b07:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0a:	ff d0                	call   *%eax
  800b0c:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b0f:	ff 4d e4             	decl   -0x1c(%ebp)
  800b12:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b16:	7f e4                	jg     800afc <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b18:	eb 34                	jmp    800b4e <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b1a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b1e:	74 1c                	je     800b3c <vprintfmt+0x207>
  800b20:	83 fb 1f             	cmp    $0x1f,%ebx
  800b23:	7e 05                	jle    800b2a <vprintfmt+0x1f5>
  800b25:	83 fb 7e             	cmp    $0x7e,%ebx
  800b28:	7e 12                	jle    800b3c <vprintfmt+0x207>
					putch('?', putdat);
  800b2a:	83 ec 08             	sub    $0x8,%esp
  800b2d:	ff 75 0c             	pushl  0xc(%ebp)
  800b30:	6a 3f                	push   $0x3f
  800b32:	8b 45 08             	mov    0x8(%ebp),%eax
  800b35:	ff d0                	call   *%eax
  800b37:	83 c4 10             	add    $0x10,%esp
  800b3a:	eb 0f                	jmp    800b4b <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b3c:	83 ec 08             	sub    $0x8,%esp
  800b3f:	ff 75 0c             	pushl  0xc(%ebp)
  800b42:	53                   	push   %ebx
  800b43:	8b 45 08             	mov    0x8(%ebp),%eax
  800b46:	ff d0                	call   *%eax
  800b48:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b4b:	ff 4d e4             	decl   -0x1c(%ebp)
  800b4e:	89 f0                	mov    %esi,%eax
  800b50:	8d 70 01             	lea    0x1(%eax),%esi
  800b53:	8a 00                	mov    (%eax),%al
  800b55:	0f be d8             	movsbl %al,%ebx
  800b58:	85 db                	test   %ebx,%ebx
  800b5a:	74 24                	je     800b80 <vprintfmt+0x24b>
  800b5c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b60:	78 b8                	js     800b1a <vprintfmt+0x1e5>
  800b62:	ff 4d e0             	decl   -0x20(%ebp)
  800b65:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b69:	79 af                	jns    800b1a <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b6b:	eb 13                	jmp    800b80 <vprintfmt+0x24b>
				putch(' ', putdat);
  800b6d:	83 ec 08             	sub    $0x8,%esp
  800b70:	ff 75 0c             	pushl  0xc(%ebp)
  800b73:	6a 20                	push   $0x20
  800b75:	8b 45 08             	mov    0x8(%ebp),%eax
  800b78:	ff d0                	call   *%eax
  800b7a:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b7d:	ff 4d e4             	decl   -0x1c(%ebp)
  800b80:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b84:	7f e7                	jg     800b6d <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800b86:	e9 66 01 00 00       	jmp    800cf1 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b8b:	83 ec 08             	sub    $0x8,%esp
  800b8e:	ff 75 e8             	pushl  -0x18(%ebp)
  800b91:	8d 45 14             	lea    0x14(%ebp),%eax
  800b94:	50                   	push   %eax
  800b95:	e8 3c fd ff ff       	call   8008d6 <getint>
  800b9a:	83 c4 10             	add    $0x10,%esp
  800b9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ba0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800ba3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ba6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ba9:	85 d2                	test   %edx,%edx
  800bab:	79 23                	jns    800bd0 <vprintfmt+0x29b>
				putch('-', putdat);
  800bad:	83 ec 08             	sub    $0x8,%esp
  800bb0:	ff 75 0c             	pushl  0xc(%ebp)
  800bb3:	6a 2d                	push   $0x2d
  800bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb8:	ff d0                	call   *%eax
  800bba:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800bbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bc0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bc3:	f7 d8                	neg    %eax
  800bc5:	83 d2 00             	adc    $0x0,%edx
  800bc8:	f7 da                	neg    %edx
  800bca:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bcd:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800bd0:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bd7:	e9 bc 00 00 00       	jmp    800c98 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800bdc:	83 ec 08             	sub    $0x8,%esp
  800bdf:	ff 75 e8             	pushl  -0x18(%ebp)
  800be2:	8d 45 14             	lea    0x14(%ebp),%eax
  800be5:	50                   	push   %eax
  800be6:	e8 84 fc ff ff       	call   80086f <getuint>
  800beb:	83 c4 10             	add    $0x10,%esp
  800bee:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bf1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800bf4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bfb:	e9 98 00 00 00       	jmp    800c98 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c00:	83 ec 08             	sub    $0x8,%esp
  800c03:	ff 75 0c             	pushl  0xc(%ebp)
  800c06:	6a 58                	push   $0x58
  800c08:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0b:	ff d0                	call   *%eax
  800c0d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c10:	83 ec 08             	sub    $0x8,%esp
  800c13:	ff 75 0c             	pushl  0xc(%ebp)
  800c16:	6a 58                	push   $0x58
  800c18:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1b:	ff d0                	call   *%eax
  800c1d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c20:	83 ec 08             	sub    $0x8,%esp
  800c23:	ff 75 0c             	pushl  0xc(%ebp)
  800c26:	6a 58                	push   $0x58
  800c28:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2b:	ff d0                	call   *%eax
  800c2d:	83 c4 10             	add    $0x10,%esp
			break;
  800c30:	e9 bc 00 00 00       	jmp    800cf1 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800c35:	83 ec 08             	sub    $0x8,%esp
  800c38:	ff 75 0c             	pushl  0xc(%ebp)
  800c3b:	6a 30                	push   $0x30
  800c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c40:	ff d0                	call   *%eax
  800c42:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c45:	83 ec 08             	sub    $0x8,%esp
  800c48:	ff 75 0c             	pushl  0xc(%ebp)
  800c4b:	6a 78                	push   $0x78
  800c4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c50:	ff d0                	call   *%eax
  800c52:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c55:	8b 45 14             	mov    0x14(%ebp),%eax
  800c58:	83 c0 04             	add    $0x4,%eax
  800c5b:	89 45 14             	mov    %eax,0x14(%ebp)
  800c5e:	8b 45 14             	mov    0x14(%ebp),%eax
  800c61:	83 e8 04             	sub    $0x4,%eax
  800c64:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c66:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c69:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c70:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c77:	eb 1f                	jmp    800c98 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c79:	83 ec 08             	sub    $0x8,%esp
  800c7c:	ff 75 e8             	pushl  -0x18(%ebp)
  800c7f:	8d 45 14             	lea    0x14(%ebp),%eax
  800c82:	50                   	push   %eax
  800c83:	e8 e7 fb ff ff       	call   80086f <getuint>
  800c88:	83 c4 10             	add    $0x10,%esp
  800c8b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c8e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800c91:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c98:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800c9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c9f:	83 ec 04             	sub    $0x4,%esp
  800ca2:	52                   	push   %edx
  800ca3:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ca6:	50                   	push   %eax
  800ca7:	ff 75 f4             	pushl  -0xc(%ebp)
  800caa:	ff 75 f0             	pushl  -0x10(%ebp)
  800cad:	ff 75 0c             	pushl  0xc(%ebp)
  800cb0:	ff 75 08             	pushl  0x8(%ebp)
  800cb3:	e8 00 fb ff ff       	call   8007b8 <printnum>
  800cb8:	83 c4 20             	add    $0x20,%esp
			break;
  800cbb:	eb 34                	jmp    800cf1 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800cbd:	83 ec 08             	sub    $0x8,%esp
  800cc0:	ff 75 0c             	pushl  0xc(%ebp)
  800cc3:	53                   	push   %ebx
  800cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc7:	ff d0                	call   *%eax
  800cc9:	83 c4 10             	add    $0x10,%esp
			break;
  800ccc:	eb 23                	jmp    800cf1 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800cce:	83 ec 08             	sub    $0x8,%esp
  800cd1:	ff 75 0c             	pushl  0xc(%ebp)
  800cd4:	6a 25                	push   $0x25
  800cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd9:	ff d0                	call   *%eax
  800cdb:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800cde:	ff 4d 10             	decl   0x10(%ebp)
  800ce1:	eb 03                	jmp    800ce6 <vprintfmt+0x3b1>
  800ce3:	ff 4d 10             	decl   0x10(%ebp)
  800ce6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ce9:	48                   	dec    %eax
  800cea:	8a 00                	mov    (%eax),%al
  800cec:	3c 25                	cmp    $0x25,%al
  800cee:	75 f3                	jne    800ce3 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800cf0:	90                   	nop
		}
	}
  800cf1:	e9 47 fc ff ff       	jmp    80093d <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800cf6:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800cf7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800cfa:	5b                   	pop    %ebx
  800cfb:	5e                   	pop    %esi
  800cfc:	5d                   	pop    %ebp
  800cfd:	c3                   	ret    

00800cfe <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800cfe:	55                   	push   %ebp
  800cff:	89 e5                	mov    %esp,%ebp
  800d01:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d04:	8d 45 10             	lea    0x10(%ebp),%eax
  800d07:	83 c0 04             	add    $0x4,%eax
  800d0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d0d:	8b 45 10             	mov    0x10(%ebp),%eax
  800d10:	ff 75 f4             	pushl  -0xc(%ebp)
  800d13:	50                   	push   %eax
  800d14:	ff 75 0c             	pushl  0xc(%ebp)
  800d17:	ff 75 08             	pushl  0x8(%ebp)
  800d1a:	e8 16 fc ff ff       	call   800935 <vprintfmt>
  800d1f:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d22:	90                   	nop
  800d23:	c9                   	leave  
  800d24:	c3                   	ret    

00800d25 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d25:	55                   	push   %ebp
  800d26:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2b:	8b 40 08             	mov    0x8(%eax),%eax
  800d2e:	8d 50 01             	lea    0x1(%eax),%edx
  800d31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d34:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d37:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3a:	8b 10                	mov    (%eax),%edx
  800d3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3f:	8b 40 04             	mov    0x4(%eax),%eax
  800d42:	39 c2                	cmp    %eax,%edx
  800d44:	73 12                	jae    800d58 <sprintputch+0x33>
		*b->buf++ = ch;
  800d46:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d49:	8b 00                	mov    (%eax),%eax
  800d4b:	8d 48 01             	lea    0x1(%eax),%ecx
  800d4e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d51:	89 0a                	mov    %ecx,(%edx)
  800d53:	8b 55 08             	mov    0x8(%ebp),%edx
  800d56:	88 10                	mov    %dl,(%eax)
}
  800d58:	90                   	nop
  800d59:	5d                   	pop    %ebp
  800d5a:	c3                   	ret    

00800d5b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d5b:	55                   	push   %ebp
  800d5c:	89 e5                	mov    %esp,%ebp
  800d5e:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d61:	8b 45 08             	mov    0x8(%ebp),%eax
  800d64:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d67:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d70:	01 d0                	add    %edx,%eax
  800d72:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d75:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d7c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d80:	74 06                	je     800d88 <vsnprintf+0x2d>
  800d82:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d86:	7f 07                	jg     800d8f <vsnprintf+0x34>
		return -E_INVAL;
  800d88:	b8 03 00 00 00       	mov    $0x3,%eax
  800d8d:	eb 20                	jmp    800daf <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d8f:	ff 75 14             	pushl  0x14(%ebp)
  800d92:	ff 75 10             	pushl  0x10(%ebp)
  800d95:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d98:	50                   	push   %eax
  800d99:	68 25 0d 80 00       	push   $0x800d25
  800d9e:	e8 92 fb ff ff       	call   800935 <vprintfmt>
  800da3:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800da6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800da9:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800dac:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800daf:	c9                   	leave  
  800db0:	c3                   	ret    

00800db1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800db1:	55                   	push   %ebp
  800db2:	89 e5                	mov    %esp,%ebp
  800db4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800db7:	8d 45 10             	lea    0x10(%ebp),%eax
  800dba:	83 c0 04             	add    $0x4,%eax
  800dbd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800dc0:	8b 45 10             	mov    0x10(%ebp),%eax
  800dc3:	ff 75 f4             	pushl  -0xc(%ebp)
  800dc6:	50                   	push   %eax
  800dc7:	ff 75 0c             	pushl  0xc(%ebp)
  800dca:	ff 75 08             	pushl  0x8(%ebp)
  800dcd:	e8 89 ff ff ff       	call   800d5b <vsnprintf>
  800dd2:	83 c4 10             	add    $0x10,%esp
  800dd5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800dd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ddb:	c9                   	leave  
  800ddc:	c3                   	ret    

00800ddd <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800ddd:	55                   	push   %ebp
  800dde:	89 e5                	mov    %esp,%ebp
  800de0:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800de3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dea:	eb 06                	jmp    800df2 <strlen+0x15>
		n++;
  800dec:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800def:	ff 45 08             	incl   0x8(%ebp)
  800df2:	8b 45 08             	mov    0x8(%ebp),%eax
  800df5:	8a 00                	mov    (%eax),%al
  800df7:	84 c0                	test   %al,%al
  800df9:	75 f1                	jne    800dec <strlen+0xf>
		n++;
	return n;
  800dfb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800dfe:	c9                   	leave  
  800dff:	c3                   	ret    

00800e00 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e00:	55                   	push   %ebp
  800e01:	89 e5                	mov    %esp,%ebp
  800e03:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e06:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e0d:	eb 09                	jmp    800e18 <strnlen+0x18>
		n++;
  800e0f:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e12:	ff 45 08             	incl   0x8(%ebp)
  800e15:	ff 4d 0c             	decl   0xc(%ebp)
  800e18:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e1c:	74 09                	je     800e27 <strnlen+0x27>
  800e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e21:	8a 00                	mov    (%eax),%al
  800e23:	84 c0                	test   %al,%al
  800e25:	75 e8                	jne    800e0f <strnlen+0xf>
		n++;
	return n;
  800e27:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e2a:	c9                   	leave  
  800e2b:	c3                   	ret    

00800e2c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e2c:	55                   	push   %ebp
  800e2d:	89 e5                	mov    %esp,%ebp
  800e2f:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e32:	8b 45 08             	mov    0x8(%ebp),%eax
  800e35:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e38:	90                   	nop
  800e39:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3c:	8d 50 01             	lea    0x1(%eax),%edx
  800e3f:	89 55 08             	mov    %edx,0x8(%ebp)
  800e42:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e45:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e48:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e4b:	8a 12                	mov    (%edx),%dl
  800e4d:	88 10                	mov    %dl,(%eax)
  800e4f:	8a 00                	mov    (%eax),%al
  800e51:	84 c0                	test   %al,%al
  800e53:	75 e4                	jne    800e39 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e55:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e58:	c9                   	leave  
  800e59:	c3                   	ret    

00800e5a <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e5a:	55                   	push   %ebp
  800e5b:	89 e5                	mov    %esp,%ebp
  800e5d:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e60:	8b 45 08             	mov    0x8(%ebp),%eax
  800e63:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e66:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e6d:	eb 1f                	jmp    800e8e <strncpy+0x34>
		*dst++ = *src;
  800e6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e72:	8d 50 01             	lea    0x1(%eax),%edx
  800e75:	89 55 08             	mov    %edx,0x8(%ebp)
  800e78:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e7b:	8a 12                	mov    (%edx),%dl
  800e7d:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800e7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e82:	8a 00                	mov    (%eax),%al
  800e84:	84 c0                	test   %al,%al
  800e86:	74 03                	je     800e8b <strncpy+0x31>
			src++;
  800e88:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e8b:	ff 45 fc             	incl   -0x4(%ebp)
  800e8e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e91:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e94:	72 d9                	jb     800e6f <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800e96:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e99:	c9                   	leave  
  800e9a:	c3                   	ret    

00800e9b <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800e9b:	55                   	push   %ebp
  800e9c:	89 e5                	mov    %esp,%ebp
  800e9e:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ea1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ea7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eab:	74 30                	je     800edd <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ead:	eb 16                	jmp    800ec5 <strlcpy+0x2a>
			*dst++ = *src++;
  800eaf:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb2:	8d 50 01             	lea    0x1(%eax),%edx
  800eb5:	89 55 08             	mov    %edx,0x8(%ebp)
  800eb8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ebb:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ebe:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ec1:	8a 12                	mov    (%edx),%dl
  800ec3:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ec5:	ff 4d 10             	decl   0x10(%ebp)
  800ec8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ecc:	74 09                	je     800ed7 <strlcpy+0x3c>
  800ece:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed1:	8a 00                	mov    (%eax),%al
  800ed3:	84 c0                	test   %al,%al
  800ed5:	75 d8                	jne    800eaf <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ed7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eda:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800edd:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee3:	29 c2                	sub    %eax,%edx
  800ee5:	89 d0                	mov    %edx,%eax
}
  800ee7:	c9                   	leave  
  800ee8:	c3                   	ret    

00800ee9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ee9:	55                   	push   %ebp
  800eea:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800eec:	eb 06                	jmp    800ef4 <strcmp+0xb>
		p++, q++;
  800eee:	ff 45 08             	incl   0x8(%ebp)
  800ef1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ef4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef7:	8a 00                	mov    (%eax),%al
  800ef9:	84 c0                	test   %al,%al
  800efb:	74 0e                	je     800f0b <strcmp+0x22>
  800efd:	8b 45 08             	mov    0x8(%ebp),%eax
  800f00:	8a 10                	mov    (%eax),%dl
  800f02:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f05:	8a 00                	mov    (%eax),%al
  800f07:	38 c2                	cmp    %al,%dl
  800f09:	74 e3                	je     800eee <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0e:	8a 00                	mov    (%eax),%al
  800f10:	0f b6 d0             	movzbl %al,%edx
  800f13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f16:	8a 00                	mov    (%eax),%al
  800f18:	0f b6 c0             	movzbl %al,%eax
  800f1b:	29 c2                	sub    %eax,%edx
  800f1d:	89 d0                	mov    %edx,%eax
}
  800f1f:	5d                   	pop    %ebp
  800f20:	c3                   	ret    

00800f21 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f21:	55                   	push   %ebp
  800f22:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f24:	eb 09                	jmp    800f2f <strncmp+0xe>
		n--, p++, q++;
  800f26:	ff 4d 10             	decl   0x10(%ebp)
  800f29:	ff 45 08             	incl   0x8(%ebp)
  800f2c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f2f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f33:	74 17                	je     800f4c <strncmp+0x2b>
  800f35:	8b 45 08             	mov    0x8(%ebp),%eax
  800f38:	8a 00                	mov    (%eax),%al
  800f3a:	84 c0                	test   %al,%al
  800f3c:	74 0e                	je     800f4c <strncmp+0x2b>
  800f3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f41:	8a 10                	mov    (%eax),%dl
  800f43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f46:	8a 00                	mov    (%eax),%al
  800f48:	38 c2                	cmp    %al,%dl
  800f4a:	74 da                	je     800f26 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f4c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f50:	75 07                	jne    800f59 <strncmp+0x38>
		return 0;
  800f52:	b8 00 00 00 00       	mov    $0x0,%eax
  800f57:	eb 14                	jmp    800f6d <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f59:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5c:	8a 00                	mov    (%eax),%al
  800f5e:	0f b6 d0             	movzbl %al,%edx
  800f61:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f64:	8a 00                	mov    (%eax),%al
  800f66:	0f b6 c0             	movzbl %al,%eax
  800f69:	29 c2                	sub    %eax,%edx
  800f6b:	89 d0                	mov    %edx,%eax
}
  800f6d:	5d                   	pop    %ebp
  800f6e:	c3                   	ret    

00800f6f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f6f:	55                   	push   %ebp
  800f70:	89 e5                	mov    %esp,%ebp
  800f72:	83 ec 04             	sub    $0x4,%esp
  800f75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f78:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f7b:	eb 12                	jmp    800f8f <strchr+0x20>
		if (*s == c)
  800f7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f80:	8a 00                	mov    (%eax),%al
  800f82:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f85:	75 05                	jne    800f8c <strchr+0x1d>
			return (char *) s;
  800f87:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8a:	eb 11                	jmp    800f9d <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800f8c:	ff 45 08             	incl   0x8(%ebp)
  800f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f92:	8a 00                	mov    (%eax),%al
  800f94:	84 c0                	test   %al,%al
  800f96:	75 e5                	jne    800f7d <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800f98:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f9d:	c9                   	leave  
  800f9e:	c3                   	ret    

00800f9f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f9f:	55                   	push   %ebp
  800fa0:	89 e5                	mov    %esp,%ebp
  800fa2:	83 ec 04             	sub    $0x4,%esp
  800fa5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa8:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fab:	eb 0d                	jmp    800fba <strfind+0x1b>
		if (*s == c)
  800fad:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb0:	8a 00                	mov    (%eax),%al
  800fb2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fb5:	74 0e                	je     800fc5 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800fb7:	ff 45 08             	incl   0x8(%ebp)
  800fba:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbd:	8a 00                	mov    (%eax),%al
  800fbf:	84 c0                	test   %al,%al
  800fc1:	75 ea                	jne    800fad <strfind+0xe>
  800fc3:	eb 01                	jmp    800fc6 <strfind+0x27>
		if (*s == c)
			break;
  800fc5:	90                   	nop
	return (char *) s;
  800fc6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fc9:	c9                   	leave  
  800fca:	c3                   	ret    

00800fcb <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800fcb:	55                   	push   %ebp
  800fcc:	89 e5                	mov    %esp,%ebp
  800fce:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800fd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800fd7:	8b 45 10             	mov    0x10(%ebp),%eax
  800fda:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800fdd:	eb 0e                	jmp    800fed <memset+0x22>
		*p++ = c;
  800fdf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fe2:	8d 50 01             	lea    0x1(%eax),%edx
  800fe5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800fe8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800feb:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800fed:	ff 4d f8             	decl   -0x8(%ebp)
  800ff0:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800ff4:	79 e9                	jns    800fdf <memset+0x14>
		*p++ = c;

	return v;
  800ff6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ff9:	c9                   	leave  
  800ffa:	c3                   	ret    

00800ffb <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800ffb:	55                   	push   %ebp
  800ffc:	89 e5                	mov    %esp,%ebp
  800ffe:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801001:	8b 45 0c             	mov    0xc(%ebp),%eax
  801004:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801007:	8b 45 08             	mov    0x8(%ebp),%eax
  80100a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80100d:	eb 16                	jmp    801025 <memcpy+0x2a>
		*d++ = *s++;
  80100f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801012:	8d 50 01             	lea    0x1(%eax),%edx
  801015:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801018:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80101b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80101e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801021:	8a 12                	mov    (%edx),%dl
  801023:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801025:	8b 45 10             	mov    0x10(%ebp),%eax
  801028:	8d 50 ff             	lea    -0x1(%eax),%edx
  80102b:	89 55 10             	mov    %edx,0x10(%ebp)
  80102e:	85 c0                	test   %eax,%eax
  801030:	75 dd                	jne    80100f <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801032:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801035:	c9                   	leave  
  801036:	c3                   	ret    

00801037 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801037:	55                   	push   %ebp
  801038:	89 e5                	mov    %esp,%ebp
  80103a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80103d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801040:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801043:	8b 45 08             	mov    0x8(%ebp),%eax
  801046:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801049:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80104c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80104f:	73 50                	jae    8010a1 <memmove+0x6a>
  801051:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801054:	8b 45 10             	mov    0x10(%ebp),%eax
  801057:	01 d0                	add    %edx,%eax
  801059:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80105c:	76 43                	jbe    8010a1 <memmove+0x6a>
		s += n;
  80105e:	8b 45 10             	mov    0x10(%ebp),%eax
  801061:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801064:	8b 45 10             	mov    0x10(%ebp),%eax
  801067:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80106a:	eb 10                	jmp    80107c <memmove+0x45>
			*--d = *--s;
  80106c:	ff 4d f8             	decl   -0x8(%ebp)
  80106f:	ff 4d fc             	decl   -0x4(%ebp)
  801072:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801075:	8a 10                	mov    (%eax),%dl
  801077:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80107a:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80107c:	8b 45 10             	mov    0x10(%ebp),%eax
  80107f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801082:	89 55 10             	mov    %edx,0x10(%ebp)
  801085:	85 c0                	test   %eax,%eax
  801087:	75 e3                	jne    80106c <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801089:	eb 23                	jmp    8010ae <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80108b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80108e:	8d 50 01             	lea    0x1(%eax),%edx
  801091:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801094:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801097:	8d 4a 01             	lea    0x1(%edx),%ecx
  80109a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80109d:	8a 12                	mov    (%edx),%dl
  80109f:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8010a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8010a4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010a7:	89 55 10             	mov    %edx,0x10(%ebp)
  8010aa:	85 c0                	test   %eax,%eax
  8010ac:	75 dd                	jne    80108b <memmove+0x54>
			*d++ = *s++;

	return dst;
  8010ae:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010b1:	c9                   	leave  
  8010b2:	c3                   	ret    

008010b3 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8010b3:	55                   	push   %ebp
  8010b4:	89 e5                	mov    %esp,%ebp
  8010b6:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8010b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8010bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c2:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8010c5:	eb 2a                	jmp    8010f1 <memcmp+0x3e>
		if (*s1 != *s2)
  8010c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ca:	8a 10                	mov    (%eax),%dl
  8010cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010cf:	8a 00                	mov    (%eax),%al
  8010d1:	38 c2                	cmp    %al,%dl
  8010d3:	74 16                	je     8010eb <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8010d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010d8:	8a 00                	mov    (%eax),%al
  8010da:	0f b6 d0             	movzbl %al,%edx
  8010dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010e0:	8a 00                	mov    (%eax),%al
  8010e2:	0f b6 c0             	movzbl %al,%eax
  8010e5:	29 c2                	sub    %eax,%edx
  8010e7:	89 d0                	mov    %edx,%eax
  8010e9:	eb 18                	jmp    801103 <memcmp+0x50>
		s1++, s2++;
  8010eb:	ff 45 fc             	incl   -0x4(%ebp)
  8010ee:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8010f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010f7:	89 55 10             	mov    %edx,0x10(%ebp)
  8010fa:	85 c0                	test   %eax,%eax
  8010fc:	75 c9                	jne    8010c7 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8010fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801103:	c9                   	leave  
  801104:	c3                   	ret    

00801105 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801105:	55                   	push   %ebp
  801106:	89 e5                	mov    %esp,%ebp
  801108:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80110b:	8b 55 08             	mov    0x8(%ebp),%edx
  80110e:	8b 45 10             	mov    0x10(%ebp),%eax
  801111:	01 d0                	add    %edx,%eax
  801113:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801116:	eb 15                	jmp    80112d <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801118:	8b 45 08             	mov    0x8(%ebp),%eax
  80111b:	8a 00                	mov    (%eax),%al
  80111d:	0f b6 d0             	movzbl %al,%edx
  801120:	8b 45 0c             	mov    0xc(%ebp),%eax
  801123:	0f b6 c0             	movzbl %al,%eax
  801126:	39 c2                	cmp    %eax,%edx
  801128:	74 0d                	je     801137 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80112a:	ff 45 08             	incl   0x8(%ebp)
  80112d:	8b 45 08             	mov    0x8(%ebp),%eax
  801130:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801133:	72 e3                	jb     801118 <memfind+0x13>
  801135:	eb 01                	jmp    801138 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801137:	90                   	nop
	return (void *) s;
  801138:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80113b:	c9                   	leave  
  80113c:	c3                   	ret    

0080113d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80113d:	55                   	push   %ebp
  80113e:	89 e5                	mov    %esp,%ebp
  801140:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801143:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80114a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801151:	eb 03                	jmp    801156 <strtol+0x19>
		s++;
  801153:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801156:	8b 45 08             	mov    0x8(%ebp),%eax
  801159:	8a 00                	mov    (%eax),%al
  80115b:	3c 20                	cmp    $0x20,%al
  80115d:	74 f4                	je     801153 <strtol+0x16>
  80115f:	8b 45 08             	mov    0x8(%ebp),%eax
  801162:	8a 00                	mov    (%eax),%al
  801164:	3c 09                	cmp    $0x9,%al
  801166:	74 eb                	je     801153 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801168:	8b 45 08             	mov    0x8(%ebp),%eax
  80116b:	8a 00                	mov    (%eax),%al
  80116d:	3c 2b                	cmp    $0x2b,%al
  80116f:	75 05                	jne    801176 <strtol+0x39>
		s++;
  801171:	ff 45 08             	incl   0x8(%ebp)
  801174:	eb 13                	jmp    801189 <strtol+0x4c>
	else if (*s == '-')
  801176:	8b 45 08             	mov    0x8(%ebp),%eax
  801179:	8a 00                	mov    (%eax),%al
  80117b:	3c 2d                	cmp    $0x2d,%al
  80117d:	75 0a                	jne    801189 <strtol+0x4c>
		s++, neg = 1;
  80117f:	ff 45 08             	incl   0x8(%ebp)
  801182:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801189:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80118d:	74 06                	je     801195 <strtol+0x58>
  80118f:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801193:	75 20                	jne    8011b5 <strtol+0x78>
  801195:	8b 45 08             	mov    0x8(%ebp),%eax
  801198:	8a 00                	mov    (%eax),%al
  80119a:	3c 30                	cmp    $0x30,%al
  80119c:	75 17                	jne    8011b5 <strtol+0x78>
  80119e:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a1:	40                   	inc    %eax
  8011a2:	8a 00                	mov    (%eax),%al
  8011a4:	3c 78                	cmp    $0x78,%al
  8011a6:	75 0d                	jne    8011b5 <strtol+0x78>
		s += 2, base = 16;
  8011a8:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8011ac:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8011b3:	eb 28                	jmp    8011dd <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8011b5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011b9:	75 15                	jne    8011d0 <strtol+0x93>
  8011bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011be:	8a 00                	mov    (%eax),%al
  8011c0:	3c 30                	cmp    $0x30,%al
  8011c2:	75 0c                	jne    8011d0 <strtol+0x93>
		s++, base = 8;
  8011c4:	ff 45 08             	incl   0x8(%ebp)
  8011c7:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8011ce:	eb 0d                	jmp    8011dd <strtol+0xa0>
	else if (base == 0)
  8011d0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011d4:	75 07                	jne    8011dd <strtol+0xa0>
		base = 10;
  8011d6:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8011dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e0:	8a 00                	mov    (%eax),%al
  8011e2:	3c 2f                	cmp    $0x2f,%al
  8011e4:	7e 19                	jle    8011ff <strtol+0xc2>
  8011e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e9:	8a 00                	mov    (%eax),%al
  8011eb:	3c 39                	cmp    $0x39,%al
  8011ed:	7f 10                	jg     8011ff <strtol+0xc2>
			dig = *s - '0';
  8011ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f2:	8a 00                	mov    (%eax),%al
  8011f4:	0f be c0             	movsbl %al,%eax
  8011f7:	83 e8 30             	sub    $0x30,%eax
  8011fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011fd:	eb 42                	jmp    801241 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8011ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801202:	8a 00                	mov    (%eax),%al
  801204:	3c 60                	cmp    $0x60,%al
  801206:	7e 19                	jle    801221 <strtol+0xe4>
  801208:	8b 45 08             	mov    0x8(%ebp),%eax
  80120b:	8a 00                	mov    (%eax),%al
  80120d:	3c 7a                	cmp    $0x7a,%al
  80120f:	7f 10                	jg     801221 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801211:	8b 45 08             	mov    0x8(%ebp),%eax
  801214:	8a 00                	mov    (%eax),%al
  801216:	0f be c0             	movsbl %al,%eax
  801219:	83 e8 57             	sub    $0x57,%eax
  80121c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80121f:	eb 20                	jmp    801241 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801221:	8b 45 08             	mov    0x8(%ebp),%eax
  801224:	8a 00                	mov    (%eax),%al
  801226:	3c 40                	cmp    $0x40,%al
  801228:	7e 39                	jle    801263 <strtol+0x126>
  80122a:	8b 45 08             	mov    0x8(%ebp),%eax
  80122d:	8a 00                	mov    (%eax),%al
  80122f:	3c 5a                	cmp    $0x5a,%al
  801231:	7f 30                	jg     801263 <strtol+0x126>
			dig = *s - 'A' + 10;
  801233:	8b 45 08             	mov    0x8(%ebp),%eax
  801236:	8a 00                	mov    (%eax),%al
  801238:	0f be c0             	movsbl %al,%eax
  80123b:	83 e8 37             	sub    $0x37,%eax
  80123e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801241:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801244:	3b 45 10             	cmp    0x10(%ebp),%eax
  801247:	7d 19                	jge    801262 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801249:	ff 45 08             	incl   0x8(%ebp)
  80124c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80124f:	0f af 45 10          	imul   0x10(%ebp),%eax
  801253:	89 c2                	mov    %eax,%edx
  801255:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801258:	01 d0                	add    %edx,%eax
  80125a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80125d:	e9 7b ff ff ff       	jmp    8011dd <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801262:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801263:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801267:	74 08                	je     801271 <strtol+0x134>
		*endptr = (char *) s;
  801269:	8b 45 0c             	mov    0xc(%ebp),%eax
  80126c:	8b 55 08             	mov    0x8(%ebp),%edx
  80126f:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801271:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801275:	74 07                	je     80127e <strtol+0x141>
  801277:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80127a:	f7 d8                	neg    %eax
  80127c:	eb 03                	jmp    801281 <strtol+0x144>
  80127e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801281:	c9                   	leave  
  801282:	c3                   	ret    

00801283 <ltostr>:

void
ltostr(long value, char *str)
{
  801283:	55                   	push   %ebp
  801284:	89 e5                	mov    %esp,%ebp
  801286:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801289:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801290:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801297:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80129b:	79 13                	jns    8012b0 <ltostr+0x2d>
	{
		neg = 1;
  80129d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8012a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a7:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8012aa:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8012ad:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8012b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b3:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8012b8:	99                   	cltd   
  8012b9:	f7 f9                	idiv   %ecx
  8012bb:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8012be:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012c1:	8d 50 01             	lea    0x1(%eax),%edx
  8012c4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012c7:	89 c2                	mov    %eax,%edx
  8012c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012cc:	01 d0                	add    %edx,%eax
  8012ce:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012d1:	83 c2 30             	add    $0x30,%edx
  8012d4:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8012d6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012d9:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012de:	f7 e9                	imul   %ecx
  8012e0:	c1 fa 02             	sar    $0x2,%edx
  8012e3:	89 c8                	mov    %ecx,%eax
  8012e5:	c1 f8 1f             	sar    $0x1f,%eax
  8012e8:	29 c2                	sub    %eax,%edx
  8012ea:	89 d0                	mov    %edx,%eax
  8012ec:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8012ef:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012f2:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012f7:	f7 e9                	imul   %ecx
  8012f9:	c1 fa 02             	sar    $0x2,%edx
  8012fc:	89 c8                	mov    %ecx,%eax
  8012fe:	c1 f8 1f             	sar    $0x1f,%eax
  801301:	29 c2                	sub    %eax,%edx
  801303:	89 d0                	mov    %edx,%eax
  801305:	c1 e0 02             	shl    $0x2,%eax
  801308:	01 d0                	add    %edx,%eax
  80130a:	01 c0                	add    %eax,%eax
  80130c:	29 c1                	sub    %eax,%ecx
  80130e:	89 ca                	mov    %ecx,%edx
  801310:	85 d2                	test   %edx,%edx
  801312:	75 9c                	jne    8012b0 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801314:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80131b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80131e:	48                   	dec    %eax
  80131f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801322:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801326:	74 3d                	je     801365 <ltostr+0xe2>
		start = 1 ;
  801328:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80132f:	eb 34                	jmp    801365 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801331:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801334:	8b 45 0c             	mov    0xc(%ebp),%eax
  801337:	01 d0                	add    %edx,%eax
  801339:	8a 00                	mov    (%eax),%al
  80133b:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80133e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801341:	8b 45 0c             	mov    0xc(%ebp),%eax
  801344:	01 c2                	add    %eax,%edx
  801346:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801349:	8b 45 0c             	mov    0xc(%ebp),%eax
  80134c:	01 c8                	add    %ecx,%eax
  80134e:	8a 00                	mov    (%eax),%al
  801350:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801352:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801355:	8b 45 0c             	mov    0xc(%ebp),%eax
  801358:	01 c2                	add    %eax,%edx
  80135a:	8a 45 eb             	mov    -0x15(%ebp),%al
  80135d:	88 02                	mov    %al,(%edx)
		start++ ;
  80135f:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801362:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801365:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801368:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80136b:	7c c4                	jl     801331 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80136d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801370:	8b 45 0c             	mov    0xc(%ebp),%eax
  801373:	01 d0                	add    %edx,%eax
  801375:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801378:	90                   	nop
  801379:	c9                   	leave  
  80137a:	c3                   	ret    

0080137b <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80137b:	55                   	push   %ebp
  80137c:	89 e5                	mov    %esp,%ebp
  80137e:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801381:	ff 75 08             	pushl  0x8(%ebp)
  801384:	e8 54 fa ff ff       	call   800ddd <strlen>
  801389:	83 c4 04             	add    $0x4,%esp
  80138c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80138f:	ff 75 0c             	pushl  0xc(%ebp)
  801392:	e8 46 fa ff ff       	call   800ddd <strlen>
  801397:	83 c4 04             	add    $0x4,%esp
  80139a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80139d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8013a4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013ab:	eb 17                	jmp    8013c4 <strcconcat+0x49>
		final[s] = str1[s] ;
  8013ad:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8013b3:	01 c2                	add    %eax,%edx
  8013b5:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bb:	01 c8                	add    %ecx,%eax
  8013bd:	8a 00                	mov    (%eax),%al
  8013bf:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8013c1:	ff 45 fc             	incl   -0x4(%ebp)
  8013c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013c7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8013ca:	7c e1                	jl     8013ad <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8013cc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8013d3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8013da:	eb 1f                	jmp    8013fb <strcconcat+0x80>
		final[s++] = str2[i] ;
  8013dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013df:	8d 50 01             	lea    0x1(%eax),%edx
  8013e2:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8013e5:	89 c2                	mov    %eax,%edx
  8013e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8013ea:	01 c2                	add    %eax,%edx
  8013ec:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8013ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f2:	01 c8                	add    %ecx,%eax
  8013f4:	8a 00                	mov    (%eax),%al
  8013f6:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8013f8:	ff 45 f8             	incl   -0x8(%ebp)
  8013fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013fe:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801401:	7c d9                	jl     8013dc <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801403:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801406:	8b 45 10             	mov    0x10(%ebp),%eax
  801409:	01 d0                	add    %edx,%eax
  80140b:	c6 00 00             	movb   $0x0,(%eax)
}
  80140e:	90                   	nop
  80140f:	c9                   	leave  
  801410:	c3                   	ret    

00801411 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801411:	55                   	push   %ebp
  801412:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801414:	8b 45 14             	mov    0x14(%ebp),%eax
  801417:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80141d:	8b 45 14             	mov    0x14(%ebp),%eax
  801420:	8b 00                	mov    (%eax),%eax
  801422:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801429:	8b 45 10             	mov    0x10(%ebp),%eax
  80142c:	01 d0                	add    %edx,%eax
  80142e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801434:	eb 0c                	jmp    801442 <strsplit+0x31>
			*string++ = 0;
  801436:	8b 45 08             	mov    0x8(%ebp),%eax
  801439:	8d 50 01             	lea    0x1(%eax),%edx
  80143c:	89 55 08             	mov    %edx,0x8(%ebp)
  80143f:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801442:	8b 45 08             	mov    0x8(%ebp),%eax
  801445:	8a 00                	mov    (%eax),%al
  801447:	84 c0                	test   %al,%al
  801449:	74 18                	je     801463 <strsplit+0x52>
  80144b:	8b 45 08             	mov    0x8(%ebp),%eax
  80144e:	8a 00                	mov    (%eax),%al
  801450:	0f be c0             	movsbl %al,%eax
  801453:	50                   	push   %eax
  801454:	ff 75 0c             	pushl  0xc(%ebp)
  801457:	e8 13 fb ff ff       	call   800f6f <strchr>
  80145c:	83 c4 08             	add    $0x8,%esp
  80145f:	85 c0                	test   %eax,%eax
  801461:	75 d3                	jne    801436 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801463:	8b 45 08             	mov    0x8(%ebp),%eax
  801466:	8a 00                	mov    (%eax),%al
  801468:	84 c0                	test   %al,%al
  80146a:	74 5a                	je     8014c6 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80146c:	8b 45 14             	mov    0x14(%ebp),%eax
  80146f:	8b 00                	mov    (%eax),%eax
  801471:	83 f8 0f             	cmp    $0xf,%eax
  801474:	75 07                	jne    80147d <strsplit+0x6c>
		{
			return 0;
  801476:	b8 00 00 00 00       	mov    $0x0,%eax
  80147b:	eb 66                	jmp    8014e3 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80147d:	8b 45 14             	mov    0x14(%ebp),%eax
  801480:	8b 00                	mov    (%eax),%eax
  801482:	8d 48 01             	lea    0x1(%eax),%ecx
  801485:	8b 55 14             	mov    0x14(%ebp),%edx
  801488:	89 0a                	mov    %ecx,(%edx)
  80148a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801491:	8b 45 10             	mov    0x10(%ebp),%eax
  801494:	01 c2                	add    %eax,%edx
  801496:	8b 45 08             	mov    0x8(%ebp),%eax
  801499:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80149b:	eb 03                	jmp    8014a0 <strsplit+0x8f>
			string++;
  80149d:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a3:	8a 00                	mov    (%eax),%al
  8014a5:	84 c0                	test   %al,%al
  8014a7:	74 8b                	je     801434 <strsplit+0x23>
  8014a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ac:	8a 00                	mov    (%eax),%al
  8014ae:	0f be c0             	movsbl %al,%eax
  8014b1:	50                   	push   %eax
  8014b2:	ff 75 0c             	pushl  0xc(%ebp)
  8014b5:	e8 b5 fa ff ff       	call   800f6f <strchr>
  8014ba:	83 c4 08             	add    $0x8,%esp
  8014bd:	85 c0                	test   %eax,%eax
  8014bf:	74 dc                	je     80149d <strsplit+0x8c>
			string++;
	}
  8014c1:	e9 6e ff ff ff       	jmp    801434 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8014c6:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8014c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8014ca:	8b 00                	mov    (%eax),%eax
  8014cc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8014d6:	01 d0                	add    %edx,%eax
  8014d8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8014de:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8014e3:	c9                   	leave  
  8014e4:	c3                   	ret    

008014e5 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8014e5:	55                   	push   %ebp
  8014e6:	89 e5                	mov    %esp,%ebp
  8014e8:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8014eb:	a1 04 50 80 00       	mov    0x805004,%eax
  8014f0:	85 c0                	test   %eax,%eax
  8014f2:	74 1f                	je     801513 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8014f4:	e8 1d 00 00 00       	call   801516 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8014f9:	83 ec 0c             	sub    $0xc,%esp
  8014fc:	68 90 40 80 00       	push   $0x804090
  801501:	e8 55 f2 ff ff       	call   80075b <cprintf>
  801506:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801509:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801510:	00 00 00 
	}
}
  801513:	90                   	nop
  801514:	c9                   	leave  
  801515:	c3                   	ret    

00801516 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801516:	55                   	push   %ebp
  801517:	89 e5                	mov    %esp,%ebp
  801519:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	LIST_INIT(&AllocMemBlocksList);
  80151c:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801523:	00 00 00 
  801526:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  80152d:	00 00 00 
  801530:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801537:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  80153a:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801541:	00 00 00 
  801544:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  80154b:	00 00 00 
  80154e:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801555:	00 00 00 
	uint32 arr_size = 0;
  801558:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	MemBlockNodes  =(struct MemBlock*) USER_DYN_BLKS_ARRAY;
  80155f:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801566:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801569:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80156e:	2d 00 10 00 00       	sub    $0x1000,%eax
  801573:	a3 50 50 80 00       	mov    %eax,0x805050
	MAX_MEM_BLOCK_CNT = (USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE;
  801578:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  80157f:	00 02 00 
	arr_size =  ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock), PAGE_SIZE);
  801582:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801589:	a1 20 51 80 00       	mov    0x805120,%eax
  80158e:	c1 e0 04             	shl    $0x4,%eax
  801591:	89 c2                	mov    %eax,%edx
  801593:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801596:	01 d0                	add    %edx,%eax
  801598:	48                   	dec    %eax
  801599:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80159c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80159f:	ba 00 00 00 00       	mov    $0x0,%edx
  8015a4:	f7 75 ec             	divl   -0x14(%ebp)
  8015a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015aa:	29 d0                	sub    %edx,%eax
  8015ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_USER);
  8015af:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  8015b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015b9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015be:	2d 00 10 00 00       	sub    $0x1000,%eax
  8015c3:	83 ec 04             	sub    $0x4,%esp
  8015c6:	6a 06                	push   $0x6
  8015c8:	ff 75 f4             	pushl  -0xc(%ebp)
  8015cb:	50                   	push   %eax
  8015cc:	e8 6a 04 00 00       	call   801a3b <sys_allocate_chunk>
  8015d1:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8015d4:	a1 20 51 80 00       	mov    0x805120,%eax
  8015d9:	83 ec 0c             	sub    $0xc,%esp
  8015dc:	50                   	push   %eax
  8015dd:	e8 df 0a 00 00       	call   8020c1 <initialize_MemBlocksList>
  8015e2:	83 c4 10             	add    $0x10,%esp
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	struct MemBlock * NewBlock = LIST_FIRST(&AvailableMemBlocksList);
  8015e5:	a1 48 51 80 00       	mov    0x805148,%eax
  8015ea:	89 45 e0             	mov    %eax,-0x20(%ebp)
	NewBlock->sva = USER_HEAP_START;
  8015ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015f0:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	NewBlock->size = (USER_HEAP_MAX-USER_HEAP_START);
  8015f7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015fa:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	LIST_REMOVE(&AvailableMemBlocksList,NewBlock);
  801601:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801605:	75 14                	jne    80161b <initialize_dyn_block_system+0x105>
  801607:	83 ec 04             	sub    $0x4,%esp
  80160a:	68 b5 40 80 00       	push   $0x8040b5
  80160f:	6a 33                	push   $0x33
  801611:	68 d3 40 80 00       	push   $0x8040d3
  801616:	e8 8c ee ff ff       	call   8004a7 <_panic>
  80161b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80161e:	8b 00                	mov    (%eax),%eax
  801620:	85 c0                	test   %eax,%eax
  801622:	74 10                	je     801634 <initialize_dyn_block_system+0x11e>
  801624:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801627:	8b 00                	mov    (%eax),%eax
  801629:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80162c:	8b 52 04             	mov    0x4(%edx),%edx
  80162f:	89 50 04             	mov    %edx,0x4(%eax)
  801632:	eb 0b                	jmp    80163f <initialize_dyn_block_system+0x129>
  801634:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801637:	8b 40 04             	mov    0x4(%eax),%eax
  80163a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80163f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801642:	8b 40 04             	mov    0x4(%eax),%eax
  801645:	85 c0                	test   %eax,%eax
  801647:	74 0f                	je     801658 <initialize_dyn_block_system+0x142>
  801649:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80164c:	8b 40 04             	mov    0x4(%eax),%eax
  80164f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801652:	8b 12                	mov    (%edx),%edx
  801654:	89 10                	mov    %edx,(%eax)
  801656:	eb 0a                	jmp    801662 <initialize_dyn_block_system+0x14c>
  801658:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80165b:	8b 00                	mov    (%eax),%eax
  80165d:	a3 48 51 80 00       	mov    %eax,0x805148
  801662:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801665:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80166b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80166e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801675:	a1 54 51 80 00       	mov    0x805154,%eax
  80167a:	48                   	dec    %eax
  80167b:	a3 54 51 80 00       	mov    %eax,0x805154
	LIST_INSERT_HEAD(&FreeMemBlocksList, NewBlock);
  801680:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801684:	75 14                	jne    80169a <initialize_dyn_block_system+0x184>
  801686:	83 ec 04             	sub    $0x4,%esp
  801689:	68 e0 40 80 00       	push   $0x8040e0
  80168e:	6a 34                	push   $0x34
  801690:	68 d3 40 80 00       	push   $0x8040d3
  801695:	e8 0d ee ff ff       	call   8004a7 <_panic>
  80169a:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8016a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016a3:	89 10                	mov    %edx,(%eax)
  8016a5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016a8:	8b 00                	mov    (%eax),%eax
  8016aa:	85 c0                	test   %eax,%eax
  8016ac:	74 0d                	je     8016bb <initialize_dyn_block_system+0x1a5>
  8016ae:	a1 38 51 80 00       	mov    0x805138,%eax
  8016b3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8016b6:	89 50 04             	mov    %edx,0x4(%eax)
  8016b9:	eb 08                	jmp    8016c3 <initialize_dyn_block_system+0x1ad>
  8016bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016be:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8016c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016c6:	a3 38 51 80 00       	mov    %eax,0x805138
  8016cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016ce:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8016d5:	a1 44 51 80 00       	mov    0x805144,%eax
  8016da:	40                   	inc    %eax
  8016db:	a3 44 51 80 00       	mov    %eax,0x805144
}
  8016e0:	90                   	nop
  8016e1:	c9                   	leave  
  8016e2:	c3                   	ret    

008016e3 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8016e3:	55                   	push   %ebp
  8016e4:	89 e5                	mov    %esp,%ebp
  8016e6:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016e9:	e8 f7 fd ff ff       	call   8014e5 <InitializeUHeap>
	if (size == 0) return NULL ;
  8016ee:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8016f2:	75 07                	jne    8016fb <malloc+0x18>
  8016f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8016f9:	eb 61                	jmp    80175c <malloc+0x79>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
	uint32 malloc_allocsize=ROUNDUP(size,PAGE_SIZE);
  8016fb:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801702:	8b 55 08             	mov    0x8(%ebp),%edx
  801705:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801708:	01 d0                	add    %edx,%eax
  80170a:	48                   	dec    %eax
  80170b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80170e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801711:	ba 00 00 00 00       	mov    $0x0,%edx
  801716:	f7 75 f0             	divl   -0x10(%ebp)
  801719:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80171c:	29 d0                	sub    %edx,%eax
  80171e:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 //int ret=0;
	struct MemBlock * user_block;
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801721:	e8 e3 06 00 00       	call   801e09 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801726:	85 c0                	test   %eax,%eax
  801728:	74 11                	je     80173b <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  80172a:	83 ec 0c             	sub    $0xc,%esp
  80172d:	ff 75 e8             	pushl  -0x18(%ebp)
  801730:	e8 4e 0d 00 00       	call   802483 <alloc_block_FF>
  801735:	83 c4 10             	add    $0x10,%esp
  801738:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(user_block!=NULL)
  80173b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80173f:	74 16                	je     801757 <malloc+0x74>
	{
		//sys_allocate_chunk(user_block->sva,malloc_allocsize,PERM_WRITEABLE| PERM_PRESENT);
		insert_sorted_allocList(user_block);
  801741:	83 ec 0c             	sub    $0xc,%esp
  801744:	ff 75 f4             	pushl  -0xc(%ebp)
  801747:	e8 aa 0a 00 00       	call   8021f6 <insert_sorted_allocList>
  80174c:	83 c4 10             	add    $0x10,%esp
		return (uint32 *)user_block->sva;
  80174f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801752:	8b 40 08             	mov    0x8(%eax),%eax
  801755:	eb 05                	jmp    80175c <malloc+0x79>
	}

    return NULL;
  801757:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80175c:	c9                   	leave  
  80175d:	c3                   	ret    

0080175e <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80175e:	55                   	push   %ebp
  80175f:	89 e5                	mov    %esp,%ebp
  801761:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801764:	83 ec 04             	sub    $0x4,%esp
  801767:	68 04 41 80 00       	push   $0x804104
  80176c:	6a 6f                	push   $0x6f
  80176e:	68 d3 40 80 00       	push   $0x8040d3
  801773:	e8 2f ed ff ff       	call   8004a7 <_panic>

00801778 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801778:	55                   	push   %ebp
  801779:	89 e5                	mov    %esp,%ebp
  80177b:	83 ec 38             	sub    $0x38,%esp
  80177e:	8b 45 10             	mov    0x10(%ebp),%eax
  801781:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801784:	e8 5c fd ff ff       	call   8014e5 <InitializeUHeap>
	if (size == 0) return NULL ;
  801789:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80178d:	75 07                	jne    801796 <smalloc+0x1e>
  80178f:	b8 00 00 00 00       	mov    $0x0,%eax
  801794:	eb 7c                	jmp    801812 <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801796:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80179d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017a3:	01 d0                	add    %edx,%eax
  8017a5:	48                   	dec    %eax
  8017a6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8017a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017ac:	ba 00 00 00 00       	mov    $0x0,%edx
  8017b1:	f7 75 f0             	divl   -0x10(%ebp)
  8017b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017b7:	29 d0                	sub    %edx,%eax
  8017b9:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  8017bc:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8017c3:	e8 41 06 00 00       	call   801e09 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8017c8:	85 c0                	test   %eax,%eax
  8017ca:	74 11                	je     8017dd <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  8017cc:	83 ec 0c             	sub    $0xc,%esp
  8017cf:	ff 75 e8             	pushl  -0x18(%ebp)
  8017d2:	e8 ac 0c 00 00       	call   802483 <alloc_block_FF>
  8017d7:	83 c4 10             	add    $0x10,%esp
  8017da:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  8017dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8017e1:	74 2a                	je     80180d <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8017e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017e6:	8b 40 08             	mov    0x8(%eax),%eax
  8017e9:	89 c2                	mov    %eax,%edx
  8017eb:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8017ef:	52                   	push   %edx
  8017f0:	50                   	push   %eax
  8017f1:	ff 75 0c             	pushl  0xc(%ebp)
  8017f4:	ff 75 08             	pushl  0x8(%ebp)
  8017f7:	e8 92 03 00 00       	call   801b8e <sys_createSharedObject>
  8017fc:	83 c4 10             	add    $0x10,%esp
  8017ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  801802:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  801806:	74 05                	je     80180d <smalloc+0x95>
			return (void*)virtual_address;
  801808:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80180b:	eb 05                	jmp    801812 <smalloc+0x9a>
	}
	return NULL;
  80180d:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801812:	c9                   	leave  
  801813:	c3                   	ret    

00801814 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801814:	55                   	push   %ebp
  801815:	89 e5                	mov    %esp,%ebp
  801817:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80181a:	e8 c6 fc ff ff       	call   8014e5 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  80181f:	83 ec 04             	sub    $0x4,%esp
  801822:	68 28 41 80 00       	push   $0x804128
  801827:	68 b0 00 00 00       	push   $0xb0
  80182c:	68 d3 40 80 00       	push   $0x8040d3
  801831:	e8 71 ec ff ff       	call   8004a7 <_panic>

00801836 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801836:	55                   	push   %ebp
  801837:	89 e5                	mov    %esp,%ebp
  801839:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80183c:	e8 a4 fc ff ff       	call   8014e5 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801841:	83 ec 04             	sub    $0x4,%esp
  801844:	68 4c 41 80 00       	push   $0x80414c
  801849:	68 f4 00 00 00       	push   $0xf4
  80184e:	68 d3 40 80 00       	push   $0x8040d3
  801853:	e8 4f ec ff ff       	call   8004a7 <_panic>

00801858 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801858:	55                   	push   %ebp
  801859:	89 e5                	mov    %esp,%ebp
  80185b:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80185e:	83 ec 04             	sub    $0x4,%esp
  801861:	68 74 41 80 00       	push   $0x804174
  801866:	68 08 01 00 00       	push   $0x108
  80186b:	68 d3 40 80 00       	push   $0x8040d3
  801870:	e8 32 ec ff ff       	call   8004a7 <_panic>

00801875 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801875:	55                   	push   %ebp
  801876:	89 e5                	mov    %esp,%ebp
  801878:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80187b:	83 ec 04             	sub    $0x4,%esp
  80187e:	68 98 41 80 00       	push   $0x804198
  801883:	68 13 01 00 00       	push   $0x113
  801888:	68 d3 40 80 00       	push   $0x8040d3
  80188d:	e8 15 ec ff ff       	call   8004a7 <_panic>

00801892 <shrink>:

}
void shrink(uint32 newSize)
{
  801892:	55                   	push   %ebp
  801893:	89 e5                	mov    %esp,%ebp
  801895:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801898:	83 ec 04             	sub    $0x4,%esp
  80189b:	68 98 41 80 00       	push   $0x804198
  8018a0:	68 18 01 00 00       	push   $0x118
  8018a5:	68 d3 40 80 00       	push   $0x8040d3
  8018aa:	e8 f8 eb ff ff       	call   8004a7 <_panic>

008018af <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8018af:	55                   	push   %ebp
  8018b0:	89 e5                	mov    %esp,%ebp
  8018b2:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018b5:	83 ec 04             	sub    $0x4,%esp
  8018b8:	68 98 41 80 00       	push   $0x804198
  8018bd:	68 1d 01 00 00       	push   $0x11d
  8018c2:	68 d3 40 80 00       	push   $0x8040d3
  8018c7:	e8 db eb ff ff       	call   8004a7 <_panic>

008018cc <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8018cc:	55                   	push   %ebp
  8018cd:	89 e5                	mov    %esp,%ebp
  8018cf:	57                   	push   %edi
  8018d0:	56                   	push   %esi
  8018d1:	53                   	push   %ebx
  8018d2:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018db:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018de:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018e1:	8b 7d 18             	mov    0x18(%ebp),%edi
  8018e4:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8018e7:	cd 30                	int    $0x30
  8018e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8018ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018ef:	83 c4 10             	add    $0x10,%esp
  8018f2:	5b                   	pop    %ebx
  8018f3:	5e                   	pop    %esi
  8018f4:	5f                   	pop    %edi
  8018f5:	5d                   	pop    %ebp
  8018f6:	c3                   	ret    

008018f7 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8018f7:	55                   	push   %ebp
  8018f8:	89 e5                	mov    %esp,%ebp
  8018fa:	83 ec 04             	sub    $0x4,%esp
  8018fd:	8b 45 10             	mov    0x10(%ebp),%eax
  801900:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801903:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801907:	8b 45 08             	mov    0x8(%ebp),%eax
  80190a:	6a 00                	push   $0x0
  80190c:	6a 00                	push   $0x0
  80190e:	52                   	push   %edx
  80190f:	ff 75 0c             	pushl  0xc(%ebp)
  801912:	50                   	push   %eax
  801913:	6a 00                	push   $0x0
  801915:	e8 b2 ff ff ff       	call   8018cc <syscall>
  80191a:	83 c4 18             	add    $0x18,%esp
}
  80191d:	90                   	nop
  80191e:	c9                   	leave  
  80191f:	c3                   	ret    

00801920 <sys_cgetc>:

int
sys_cgetc(void)
{
  801920:	55                   	push   %ebp
  801921:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801923:	6a 00                	push   $0x0
  801925:	6a 00                	push   $0x0
  801927:	6a 00                	push   $0x0
  801929:	6a 00                	push   $0x0
  80192b:	6a 00                	push   $0x0
  80192d:	6a 01                	push   $0x1
  80192f:	e8 98 ff ff ff       	call   8018cc <syscall>
  801934:	83 c4 18             	add    $0x18,%esp
}
  801937:	c9                   	leave  
  801938:	c3                   	ret    

00801939 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801939:	55                   	push   %ebp
  80193a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80193c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80193f:	8b 45 08             	mov    0x8(%ebp),%eax
  801942:	6a 00                	push   $0x0
  801944:	6a 00                	push   $0x0
  801946:	6a 00                	push   $0x0
  801948:	52                   	push   %edx
  801949:	50                   	push   %eax
  80194a:	6a 05                	push   $0x5
  80194c:	e8 7b ff ff ff       	call   8018cc <syscall>
  801951:	83 c4 18             	add    $0x18,%esp
}
  801954:	c9                   	leave  
  801955:	c3                   	ret    

00801956 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801956:	55                   	push   %ebp
  801957:	89 e5                	mov    %esp,%ebp
  801959:	56                   	push   %esi
  80195a:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80195b:	8b 75 18             	mov    0x18(%ebp),%esi
  80195e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801961:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801964:	8b 55 0c             	mov    0xc(%ebp),%edx
  801967:	8b 45 08             	mov    0x8(%ebp),%eax
  80196a:	56                   	push   %esi
  80196b:	53                   	push   %ebx
  80196c:	51                   	push   %ecx
  80196d:	52                   	push   %edx
  80196e:	50                   	push   %eax
  80196f:	6a 06                	push   $0x6
  801971:	e8 56 ff ff ff       	call   8018cc <syscall>
  801976:	83 c4 18             	add    $0x18,%esp
}
  801979:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80197c:	5b                   	pop    %ebx
  80197d:	5e                   	pop    %esi
  80197e:	5d                   	pop    %ebp
  80197f:	c3                   	ret    

00801980 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801980:	55                   	push   %ebp
  801981:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801983:	8b 55 0c             	mov    0xc(%ebp),%edx
  801986:	8b 45 08             	mov    0x8(%ebp),%eax
  801989:	6a 00                	push   $0x0
  80198b:	6a 00                	push   $0x0
  80198d:	6a 00                	push   $0x0
  80198f:	52                   	push   %edx
  801990:	50                   	push   %eax
  801991:	6a 07                	push   $0x7
  801993:	e8 34 ff ff ff       	call   8018cc <syscall>
  801998:	83 c4 18             	add    $0x18,%esp
}
  80199b:	c9                   	leave  
  80199c:	c3                   	ret    

0080199d <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80199d:	55                   	push   %ebp
  80199e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8019a0:	6a 00                	push   $0x0
  8019a2:	6a 00                	push   $0x0
  8019a4:	6a 00                	push   $0x0
  8019a6:	ff 75 0c             	pushl  0xc(%ebp)
  8019a9:	ff 75 08             	pushl  0x8(%ebp)
  8019ac:	6a 08                	push   $0x8
  8019ae:	e8 19 ff ff ff       	call   8018cc <syscall>
  8019b3:	83 c4 18             	add    $0x18,%esp
}
  8019b6:	c9                   	leave  
  8019b7:	c3                   	ret    

008019b8 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8019b8:	55                   	push   %ebp
  8019b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8019bb:	6a 00                	push   $0x0
  8019bd:	6a 00                	push   $0x0
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 00                	push   $0x0
  8019c5:	6a 09                	push   $0x9
  8019c7:	e8 00 ff ff ff       	call   8018cc <syscall>
  8019cc:	83 c4 18             	add    $0x18,%esp
}
  8019cf:	c9                   	leave  
  8019d0:	c3                   	ret    

008019d1 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8019d1:	55                   	push   %ebp
  8019d2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8019d4:	6a 00                	push   $0x0
  8019d6:	6a 00                	push   $0x0
  8019d8:	6a 00                	push   $0x0
  8019da:	6a 00                	push   $0x0
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 0a                	push   $0xa
  8019e0:	e8 e7 fe ff ff       	call   8018cc <syscall>
  8019e5:	83 c4 18             	add    $0x18,%esp
}
  8019e8:	c9                   	leave  
  8019e9:	c3                   	ret    

008019ea <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8019ea:	55                   	push   %ebp
  8019eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 00                	push   $0x0
  8019f1:	6a 00                	push   $0x0
  8019f3:	6a 00                	push   $0x0
  8019f5:	6a 00                	push   $0x0
  8019f7:	6a 0b                	push   $0xb
  8019f9:	e8 ce fe ff ff       	call   8018cc <syscall>
  8019fe:	83 c4 18             	add    $0x18,%esp
}
  801a01:	c9                   	leave  
  801a02:	c3                   	ret    

00801a03 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801a03:	55                   	push   %ebp
  801a04:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801a06:	6a 00                	push   $0x0
  801a08:	6a 00                	push   $0x0
  801a0a:	6a 00                	push   $0x0
  801a0c:	ff 75 0c             	pushl  0xc(%ebp)
  801a0f:	ff 75 08             	pushl  0x8(%ebp)
  801a12:	6a 0f                	push   $0xf
  801a14:	e8 b3 fe ff ff       	call   8018cc <syscall>
  801a19:	83 c4 18             	add    $0x18,%esp
	return;
  801a1c:	90                   	nop
}
  801a1d:	c9                   	leave  
  801a1e:	c3                   	ret    

00801a1f <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a1f:	55                   	push   %ebp
  801a20:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801a22:	6a 00                	push   $0x0
  801a24:	6a 00                	push   $0x0
  801a26:	6a 00                	push   $0x0
  801a28:	ff 75 0c             	pushl  0xc(%ebp)
  801a2b:	ff 75 08             	pushl  0x8(%ebp)
  801a2e:	6a 10                	push   $0x10
  801a30:	e8 97 fe ff ff       	call   8018cc <syscall>
  801a35:	83 c4 18             	add    $0x18,%esp
	return ;
  801a38:	90                   	nop
}
  801a39:	c9                   	leave  
  801a3a:	c3                   	ret    

00801a3b <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801a3b:	55                   	push   %ebp
  801a3c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a3e:	6a 00                	push   $0x0
  801a40:	6a 00                	push   $0x0
  801a42:	ff 75 10             	pushl  0x10(%ebp)
  801a45:	ff 75 0c             	pushl  0xc(%ebp)
  801a48:	ff 75 08             	pushl  0x8(%ebp)
  801a4b:	6a 11                	push   $0x11
  801a4d:	e8 7a fe ff ff       	call   8018cc <syscall>
  801a52:	83 c4 18             	add    $0x18,%esp
	return ;
  801a55:	90                   	nop
}
  801a56:	c9                   	leave  
  801a57:	c3                   	ret    

00801a58 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a58:	55                   	push   %ebp
  801a59:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a5b:	6a 00                	push   $0x0
  801a5d:	6a 00                	push   $0x0
  801a5f:	6a 00                	push   $0x0
  801a61:	6a 00                	push   $0x0
  801a63:	6a 00                	push   $0x0
  801a65:	6a 0c                	push   $0xc
  801a67:	e8 60 fe ff ff       	call   8018cc <syscall>
  801a6c:	83 c4 18             	add    $0x18,%esp
}
  801a6f:	c9                   	leave  
  801a70:	c3                   	ret    

00801a71 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a71:	55                   	push   %ebp
  801a72:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a74:	6a 00                	push   $0x0
  801a76:	6a 00                	push   $0x0
  801a78:	6a 00                	push   $0x0
  801a7a:	6a 00                	push   $0x0
  801a7c:	ff 75 08             	pushl  0x8(%ebp)
  801a7f:	6a 0d                	push   $0xd
  801a81:	e8 46 fe ff ff       	call   8018cc <syscall>
  801a86:	83 c4 18             	add    $0x18,%esp
}
  801a89:	c9                   	leave  
  801a8a:	c3                   	ret    

00801a8b <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a8b:	55                   	push   %ebp
  801a8c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a8e:	6a 00                	push   $0x0
  801a90:	6a 00                	push   $0x0
  801a92:	6a 00                	push   $0x0
  801a94:	6a 00                	push   $0x0
  801a96:	6a 00                	push   $0x0
  801a98:	6a 0e                	push   $0xe
  801a9a:	e8 2d fe ff ff       	call   8018cc <syscall>
  801a9f:	83 c4 18             	add    $0x18,%esp
}
  801aa2:	90                   	nop
  801aa3:	c9                   	leave  
  801aa4:	c3                   	ret    

00801aa5 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801aa5:	55                   	push   %ebp
  801aa6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801aa8:	6a 00                	push   $0x0
  801aaa:	6a 00                	push   $0x0
  801aac:	6a 00                	push   $0x0
  801aae:	6a 00                	push   $0x0
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 13                	push   $0x13
  801ab4:	e8 13 fe ff ff       	call   8018cc <syscall>
  801ab9:	83 c4 18             	add    $0x18,%esp
}
  801abc:	90                   	nop
  801abd:	c9                   	leave  
  801abe:	c3                   	ret    

00801abf <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801abf:	55                   	push   %ebp
  801ac0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801ac2:	6a 00                	push   $0x0
  801ac4:	6a 00                	push   $0x0
  801ac6:	6a 00                	push   $0x0
  801ac8:	6a 00                	push   $0x0
  801aca:	6a 00                	push   $0x0
  801acc:	6a 14                	push   $0x14
  801ace:	e8 f9 fd ff ff       	call   8018cc <syscall>
  801ad3:	83 c4 18             	add    $0x18,%esp
}
  801ad6:	90                   	nop
  801ad7:	c9                   	leave  
  801ad8:	c3                   	ret    

00801ad9 <sys_cputc>:


void
sys_cputc(const char c)
{
  801ad9:	55                   	push   %ebp
  801ada:	89 e5                	mov    %esp,%ebp
  801adc:	83 ec 04             	sub    $0x4,%esp
  801adf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801ae5:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ae9:	6a 00                	push   $0x0
  801aeb:	6a 00                	push   $0x0
  801aed:	6a 00                	push   $0x0
  801aef:	6a 00                	push   $0x0
  801af1:	50                   	push   %eax
  801af2:	6a 15                	push   $0x15
  801af4:	e8 d3 fd ff ff       	call   8018cc <syscall>
  801af9:	83 c4 18             	add    $0x18,%esp
}
  801afc:	90                   	nop
  801afd:	c9                   	leave  
  801afe:	c3                   	ret    

00801aff <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801aff:	55                   	push   %ebp
  801b00:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b02:	6a 00                	push   $0x0
  801b04:	6a 00                	push   $0x0
  801b06:	6a 00                	push   $0x0
  801b08:	6a 00                	push   $0x0
  801b0a:	6a 00                	push   $0x0
  801b0c:	6a 16                	push   $0x16
  801b0e:	e8 b9 fd ff ff       	call   8018cc <syscall>
  801b13:	83 c4 18             	add    $0x18,%esp
}
  801b16:	90                   	nop
  801b17:	c9                   	leave  
  801b18:	c3                   	ret    

00801b19 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801b19:	55                   	push   %ebp
  801b1a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801b1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1f:	6a 00                	push   $0x0
  801b21:	6a 00                	push   $0x0
  801b23:	6a 00                	push   $0x0
  801b25:	ff 75 0c             	pushl  0xc(%ebp)
  801b28:	50                   	push   %eax
  801b29:	6a 17                	push   $0x17
  801b2b:	e8 9c fd ff ff       	call   8018cc <syscall>
  801b30:	83 c4 18             	add    $0x18,%esp
}
  801b33:	c9                   	leave  
  801b34:	c3                   	ret    

00801b35 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801b35:	55                   	push   %ebp
  801b36:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b38:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3e:	6a 00                	push   $0x0
  801b40:	6a 00                	push   $0x0
  801b42:	6a 00                	push   $0x0
  801b44:	52                   	push   %edx
  801b45:	50                   	push   %eax
  801b46:	6a 1a                	push   $0x1a
  801b48:	e8 7f fd ff ff       	call   8018cc <syscall>
  801b4d:	83 c4 18             	add    $0x18,%esp
}
  801b50:	c9                   	leave  
  801b51:	c3                   	ret    

00801b52 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b52:	55                   	push   %ebp
  801b53:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b55:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b58:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5b:	6a 00                	push   $0x0
  801b5d:	6a 00                	push   $0x0
  801b5f:	6a 00                	push   $0x0
  801b61:	52                   	push   %edx
  801b62:	50                   	push   %eax
  801b63:	6a 18                	push   $0x18
  801b65:	e8 62 fd ff ff       	call   8018cc <syscall>
  801b6a:	83 c4 18             	add    $0x18,%esp
}
  801b6d:	90                   	nop
  801b6e:	c9                   	leave  
  801b6f:	c3                   	ret    

00801b70 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b70:	55                   	push   %ebp
  801b71:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b73:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b76:	8b 45 08             	mov    0x8(%ebp),%eax
  801b79:	6a 00                	push   $0x0
  801b7b:	6a 00                	push   $0x0
  801b7d:	6a 00                	push   $0x0
  801b7f:	52                   	push   %edx
  801b80:	50                   	push   %eax
  801b81:	6a 19                	push   $0x19
  801b83:	e8 44 fd ff ff       	call   8018cc <syscall>
  801b88:	83 c4 18             	add    $0x18,%esp
}
  801b8b:	90                   	nop
  801b8c:	c9                   	leave  
  801b8d:	c3                   	ret    

00801b8e <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b8e:	55                   	push   %ebp
  801b8f:	89 e5                	mov    %esp,%ebp
  801b91:	83 ec 04             	sub    $0x4,%esp
  801b94:	8b 45 10             	mov    0x10(%ebp),%eax
  801b97:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b9a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b9d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba4:	6a 00                	push   $0x0
  801ba6:	51                   	push   %ecx
  801ba7:	52                   	push   %edx
  801ba8:	ff 75 0c             	pushl  0xc(%ebp)
  801bab:	50                   	push   %eax
  801bac:	6a 1b                	push   $0x1b
  801bae:	e8 19 fd ff ff       	call   8018cc <syscall>
  801bb3:	83 c4 18             	add    $0x18,%esp
}
  801bb6:	c9                   	leave  
  801bb7:	c3                   	ret    

00801bb8 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801bb8:	55                   	push   %ebp
  801bb9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801bbb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc1:	6a 00                	push   $0x0
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 00                	push   $0x0
  801bc7:	52                   	push   %edx
  801bc8:	50                   	push   %eax
  801bc9:	6a 1c                	push   $0x1c
  801bcb:	e8 fc fc ff ff       	call   8018cc <syscall>
  801bd0:	83 c4 18             	add    $0x18,%esp
}
  801bd3:	c9                   	leave  
  801bd4:	c3                   	ret    

00801bd5 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801bd5:	55                   	push   %ebp
  801bd6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801bd8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bdb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bde:	8b 45 08             	mov    0x8(%ebp),%eax
  801be1:	6a 00                	push   $0x0
  801be3:	6a 00                	push   $0x0
  801be5:	51                   	push   %ecx
  801be6:	52                   	push   %edx
  801be7:	50                   	push   %eax
  801be8:	6a 1d                	push   $0x1d
  801bea:	e8 dd fc ff ff       	call   8018cc <syscall>
  801bef:	83 c4 18             	add    $0x18,%esp
}
  801bf2:	c9                   	leave  
  801bf3:	c3                   	ret    

00801bf4 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801bf4:	55                   	push   %ebp
  801bf5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801bf7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bfa:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfd:	6a 00                	push   $0x0
  801bff:	6a 00                	push   $0x0
  801c01:	6a 00                	push   $0x0
  801c03:	52                   	push   %edx
  801c04:	50                   	push   %eax
  801c05:	6a 1e                	push   $0x1e
  801c07:	e8 c0 fc ff ff       	call   8018cc <syscall>
  801c0c:	83 c4 18             	add    $0x18,%esp
}
  801c0f:	c9                   	leave  
  801c10:	c3                   	ret    

00801c11 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801c11:	55                   	push   %ebp
  801c12:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801c14:	6a 00                	push   $0x0
  801c16:	6a 00                	push   $0x0
  801c18:	6a 00                	push   $0x0
  801c1a:	6a 00                	push   $0x0
  801c1c:	6a 00                	push   $0x0
  801c1e:	6a 1f                	push   $0x1f
  801c20:	e8 a7 fc ff ff       	call   8018cc <syscall>
  801c25:	83 c4 18             	add    $0x18,%esp
}
  801c28:	c9                   	leave  
  801c29:	c3                   	ret    

00801c2a <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c2a:	55                   	push   %ebp
  801c2b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c30:	6a 00                	push   $0x0
  801c32:	ff 75 14             	pushl  0x14(%ebp)
  801c35:	ff 75 10             	pushl  0x10(%ebp)
  801c38:	ff 75 0c             	pushl  0xc(%ebp)
  801c3b:	50                   	push   %eax
  801c3c:	6a 20                	push   $0x20
  801c3e:	e8 89 fc ff ff       	call   8018cc <syscall>
  801c43:	83 c4 18             	add    $0x18,%esp
}
  801c46:	c9                   	leave  
  801c47:	c3                   	ret    

00801c48 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801c48:	55                   	push   %ebp
  801c49:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4e:	6a 00                	push   $0x0
  801c50:	6a 00                	push   $0x0
  801c52:	6a 00                	push   $0x0
  801c54:	6a 00                	push   $0x0
  801c56:	50                   	push   %eax
  801c57:	6a 21                	push   $0x21
  801c59:	e8 6e fc ff ff       	call   8018cc <syscall>
  801c5e:	83 c4 18             	add    $0x18,%esp
}
  801c61:	90                   	nop
  801c62:	c9                   	leave  
  801c63:	c3                   	ret    

00801c64 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c64:	55                   	push   %ebp
  801c65:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c67:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6a:	6a 00                	push   $0x0
  801c6c:	6a 00                	push   $0x0
  801c6e:	6a 00                	push   $0x0
  801c70:	6a 00                	push   $0x0
  801c72:	50                   	push   %eax
  801c73:	6a 22                	push   $0x22
  801c75:	e8 52 fc ff ff       	call   8018cc <syscall>
  801c7a:	83 c4 18             	add    $0x18,%esp
}
  801c7d:	c9                   	leave  
  801c7e:	c3                   	ret    

00801c7f <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c7f:	55                   	push   %ebp
  801c80:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c82:	6a 00                	push   $0x0
  801c84:	6a 00                	push   $0x0
  801c86:	6a 00                	push   $0x0
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 02                	push   $0x2
  801c8e:	e8 39 fc ff ff       	call   8018cc <syscall>
  801c93:	83 c4 18             	add    $0x18,%esp
}
  801c96:	c9                   	leave  
  801c97:	c3                   	ret    

00801c98 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c98:	55                   	push   %ebp
  801c99:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c9b:	6a 00                	push   $0x0
  801c9d:	6a 00                	push   $0x0
  801c9f:	6a 00                	push   $0x0
  801ca1:	6a 00                	push   $0x0
  801ca3:	6a 00                	push   $0x0
  801ca5:	6a 03                	push   $0x3
  801ca7:	e8 20 fc ff ff       	call   8018cc <syscall>
  801cac:	83 c4 18             	add    $0x18,%esp
}
  801caf:	c9                   	leave  
  801cb0:	c3                   	ret    

00801cb1 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801cb1:	55                   	push   %ebp
  801cb2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801cb4:	6a 00                	push   $0x0
  801cb6:	6a 00                	push   $0x0
  801cb8:	6a 00                	push   $0x0
  801cba:	6a 00                	push   $0x0
  801cbc:	6a 00                	push   $0x0
  801cbe:	6a 04                	push   $0x4
  801cc0:	e8 07 fc ff ff       	call   8018cc <syscall>
  801cc5:	83 c4 18             	add    $0x18,%esp
}
  801cc8:	c9                   	leave  
  801cc9:	c3                   	ret    

00801cca <sys_exit_env>:


void sys_exit_env(void)
{
  801cca:	55                   	push   %ebp
  801ccb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801ccd:	6a 00                	push   $0x0
  801ccf:	6a 00                	push   $0x0
  801cd1:	6a 00                	push   $0x0
  801cd3:	6a 00                	push   $0x0
  801cd5:	6a 00                	push   $0x0
  801cd7:	6a 23                	push   $0x23
  801cd9:	e8 ee fb ff ff       	call   8018cc <syscall>
  801cde:	83 c4 18             	add    $0x18,%esp
}
  801ce1:	90                   	nop
  801ce2:	c9                   	leave  
  801ce3:	c3                   	ret    

00801ce4 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801ce4:	55                   	push   %ebp
  801ce5:	89 e5                	mov    %esp,%ebp
  801ce7:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801cea:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ced:	8d 50 04             	lea    0x4(%eax),%edx
  801cf0:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cf3:	6a 00                	push   $0x0
  801cf5:	6a 00                	push   $0x0
  801cf7:	6a 00                	push   $0x0
  801cf9:	52                   	push   %edx
  801cfa:	50                   	push   %eax
  801cfb:	6a 24                	push   $0x24
  801cfd:	e8 ca fb ff ff       	call   8018cc <syscall>
  801d02:	83 c4 18             	add    $0x18,%esp
	return result;
  801d05:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d08:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d0b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d0e:	89 01                	mov    %eax,(%ecx)
  801d10:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801d13:	8b 45 08             	mov    0x8(%ebp),%eax
  801d16:	c9                   	leave  
  801d17:	c2 04 00             	ret    $0x4

00801d1a <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d1a:	55                   	push   %ebp
  801d1b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d1d:	6a 00                	push   $0x0
  801d1f:	6a 00                	push   $0x0
  801d21:	ff 75 10             	pushl  0x10(%ebp)
  801d24:	ff 75 0c             	pushl  0xc(%ebp)
  801d27:	ff 75 08             	pushl  0x8(%ebp)
  801d2a:	6a 12                	push   $0x12
  801d2c:	e8 9b fb ff ff       	call   8018cc <syscall>
  801d31:	83 c4 18             	add    $0x18,%esp
	return ;
  801d34:	90                   	nop
}
  801d35:	c9                   	leave  
  801d36:	c3                   	ret    

00801d37 <sys_rcr2>:
uint32 sys_rcr2()
{
  801d37:	55                   	push   %ebp
  801d38:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d3a:	6a 00                	push   $0x0
  801d3c:	6a 00                	push   $0x0
  801d3e:	6a 00                	push   $0x0
  801d40:	6a 00                	push   $0x0
  801d42:	6a 00                	push   $0x0
  801d44:	6a 25                	push   $0x25
  801d46:	e8 81 fb ff ff       	call   8018cc <syscall>
  801d4b:	83 c4 18             	add    $0x18,%esp
}
  801d4e:	c9                   	leave  
  801d4f:	c3                   	ret    

00801d50 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801d50:	55                   	push   %ebp
  801d51:	89 e5                	mov    %esp,%ebp
  801d53:	83 ec 04             	sub    $0x4,%esp
  801d56:	8b 45 08             	mov    0x8(%ebp),%eax
  801d59:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d5c:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d60:	6a 00                	push   $0x0
  801d62:	6a 00                	push   $0x0
  801d64:	6a 00                	push   $0x0
  801d66:	6a 00                	push   $0x0
  801d68:	50                   	push   %eax
  801d69:	6a 26                	push   $0x26
  801d6b:	e8 5c fb ff ff       	call   8018cc <syscall>
  801d70:	83 c4 18             	add    $0x18,%esp
	return ;
  801d73:	90                   	nop
}
  801d74:	c9                   	leave  
  801d75:	c3                   	ret    

00801d76 <rsttst>:
void rsttst()
{
  801d76:	55                   	push   %ebp
  801d77:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d79:	6a 00                	push   $0x0
  801d7b:	6a 00                	push   $0x0
  801d7d:	6a 00                	push   $0x0
  801d7f:	6a 00                	push   $0x0
  801d81:	6a 00                	push   $0x0
  801d83:	6a 28                	push   $0x28
  801d85:	e8 42 fb ff ff       	call   8018cc <syscall>
  801d8a:	83 c4 18             	add    $0x18,%esp
	return ;
  801d8d:	90                   	nop
}
  801d8e:	c9                   	leave  
  801d8f:	c3                   	ret    

00801d90 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d90:	55                   	push   %ebp
  801d91:	89 e5                	mov    %esp,%ebp
  801d93:	83 ec 04             	sub    $0x4,%esp
  801d96:	8b 45 14             	mov    0x14(%ebp),%eax
  801d99:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d9c:	8b 55 18             	mov    0x18(%ebp),%edx
  801d9f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801da3:	52                   	push   %edx
  801da4:	50                   	push   %eax
  801da5:	ff 75 10             	pushl  0x10(%ebp)
  801da8:	ff 75 0c             	pushl  0xc(%ebp)
  801dab:	ff 75 08             	pushl  0x8(%ebp)
  801dae:	6a 27                	push   $0x27
  801db0:	e8 17 fb ff ff       	call   8018cc <syscall>
  801db5:	83 c4 18             	add    $0x18,%esp
	return ;
  801db8:	90                   	nop
}
  801db9:	c9                   	leave  
  801dba:	c3                   	ret    

00801dbb <chktst>:
void chktst(uint32 n)
{
  801dbb:	55                   	push   %ebp
  801dbc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801dbe:	6a 00                	push   $0x0
  801dc0:	6a 00                	push   $0x0
  801dc2:	6a 00                	push   $0x0
  801dc4:	6a 00                	push   $0x0
  801dc6:	ff 75 08             	pushl  0x8(%ebp)
  801dc9:	6a 29                	push   $0x29
  801dcb:	e8 fc fa ff ff       	call   8018cc <syscall>
  801dd0:	83 c4 18             	add    $0x18,%esp
	return ;
  801dd3:	90                   	nop
}
  801dd4:	c9                   	leave  
  801dd5:	c3                   	ret    

00801dd6 <inctst>:

void inctst()
{
  801dd6:	55                   	push   %ebp
  801dd7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801dd9:	6a 00                	push   $0x0
  801ddb:	6a 00                	push   $0x0
  801ddd:	6a 00                	push   $0x0
  801ddf:	6a 00                	push   $0x0
  801de1:	6a 00                	push   $0x0
  801de3:	6a 2a                	push   $0x2a
  801de5:	e8 e2 fa ff ff       	call   8018cc <syscall>
  801dea:	83 c4 18             	add    $0x18,%esp
	return ;
  801ded:	90                   	nop
}
  801dee:	c9                   	leave  
  801def:	c3                   	ret    

00801df0 <gettst>:
uint32 gettst()
{
  801df0:	55                   	push   %ebp
  801df1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801df3:	6a 00                	push   $0x0
  801df5:	6a 00                	push   $0x0
  801df7:	6a 00                	push   $0x0
  801df9:	6a 00                	push   $0x0
  801dfb:	6a 00                	push   $0x0
  801dfd:	6a 2b                	push   $0x2b
  801dff:	e8 c8 fa ff ff       	call   8018cc <syscall>
  801e04:	83 c4 18             	add    $0x18,%esp
}
  801e07:	c9                   	leave  
  801e08:	c3                   	ret    

00801e09 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801e09:	55                   	push   %ebp
  801e0a:	89 e5                	mov    %esp,%ebp
  801e0c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e0f:	6a 00                	push   $0x0
  801e11:	6a 00                	push   $0x0
  801e13:	6a 00                	push   $0x0
  801e15:	6a 00                	push   $0x0
  801e17:	6a 00                	push   $0x0
  801e19:	6a 2c                	push   $0x2c
  801e1b:	e8 ac fa ff ff       	call   8018cc <syscall>
  801e20:	83 c4 18             	add    $0x18,%esp
  801e23:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801e26:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e2a:	75 07                	jne    801e33 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e2c:	b8 01 00 00 00       	mov    $0x1,%eax
  801e31:	eb 05                	jmp    801e38 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e33:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e38:	c9                   	leave  
  801e39:	c3                   	ret    

00801e3a <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e3a:	55                   	push   %ebp
  801e3b:	89 e5                	mov    %esp,%ebp
  801e3d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e40:	6a 00                	push   $0x0
  801e42:	6a 00                	push   $0x0
  801e44:	6a 00                	push   $0x0
  801e46:	6a 00                	push   $0x0
  801e48:	6a 00                	push   $0x0
  801e4a:	6a 2c                	push   $0x2c
  801e4c:	e8 7b fa ff ff       	call   8018cc <syscall>
  801e51:	83 c4 18             	add    $0x18,%esp
  801e54:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e57:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e5b:	75 07                	jne    801e64 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e5d:	b8 01 00 00 00       	mov    $0x1,%eax
  801e62:	eb 05                	jmp    801e69 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e64:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e69:	c9                   	leave  
  801e6a:	c3                   	ret    

00801e6b <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e6b:	55                   	push   %ebp
  801e6c:	89 e5                	mov    %esp,%ebp
  801e6e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e71:	6a 00                	push   $0x0
  801e73:	6a 00                	push   $0x0
  801e75:	6a 00                	push   $0x0
  801e77:	6a 00                	push   $0x0
  801e79:	6a 00                	push   $0x0
  801e7b:	6a 2c                	push   $0x2c
  801e7d:	e8 4a fa ff ff       	call   8018cc <syscall>
  801e82:	83 c4 18             	add    $0x18,%esp
  801e85:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e88:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e8c:	75 07                	jne    801e95 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e8e:	b8 01 00 00 00       	mov    $0x1,%eax
  801e93:	eb 05                	jmp    801e9a <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e95:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e9a:	c9                   	leave  
  801e9b:	c3                   	ret    

00801e9c <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e9c:	55                   	push   %ebp
  801e9d:	89 e5                	mov    %esp,%ebp
  801e9f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ea2:	6a 00                	push   $0x0
  801ea4:	6a 00                	push   $0x0
  801ea6:	6a 00                	push   $0x0
  801ea8:	6a 00                	push   $0x0
  801eaa:	6a 00                	push   $0x0
  801eac:	6a 2c                	push   $0x2c
  801eae:	e8 19 fa ff ff       	call   8018cc <syscall>
  801eb3:	83 c4 18             	add    $0x18,%esp
  801eb6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801eb9:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801ebd:	75 07                	jne    801ec6 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801ebf:	b8 01 00 00 00       	mov    $0x1,%eax
  801ec4:	eb 05                	jmp    801ecb <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801ec6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ecb:	c9                   	leave  
  801ecc:	c3                   	ret    

00801ecd <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801ecd:	55                   	push   %ebp
  801ece:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801ed0:	6a 00                	push   $0x0
  801ed2:	6a 00                	push   $0x0
  801ed4:	6a 00                	push   $0x0
  801ed6:	6a 00                	push   $0x0
  801ed8:	ff 75 08             	pushl  0x8(%ebp)
  801edb:	6a 2d                	push   $0x2d
  801edd:	e8 ea f9 ff ff       	call   8018cc <syscall>
  801ee2:	83 c4 18             	add    $0x18,%esp
	return ;
  801ee5:	90                   	nop
}
  801ee6:	c9                   	leave  
  801ee7:	c3                   	ret    

00801ee8 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801ee8:	55                   	push   %ebp
  801ee9:	89 e5                	mov    %esp,%ebp
  801eeb:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801eec:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801eef:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ef2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ef5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef8:	6a 00                	push   $0x0
  801efa:	53                   	push   %ebx
  801efb:	51                   	push   %ecx
  801efc:	52                   	push   %edx
  801efd:	50                   	push   %eax
  801efe:	6a 2e                	push   $0x2e
  801f00:	e8 c7 f9 ff ff       	call   8018cc <syscall>
  801f05:	83 c4 18             	add    $0x18,%esp
}
  801f08:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f0b:	c9                   	leave  
  801f0c:	c3                   	ret    

00801f0d <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801f0d:	55                   	push   %ebp
  801f0e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801f10:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f13:	8b 45 08             	mov    0x8(%ebp),%eax
  801f16:	6a 00                	push   $0x0
  801f18:	6a 00                	push   $0x0
  801f1a:	6a 00                	push   $0x0
  801f1c:	52                   	push   %edx
  801f1d:	50                   	push   %eax
  801f1e:	6a 2f                	push   $0x2f
  801f20:	e8 a7 f9 ff ff       	call   8018cc <syscall>
  801f25:	83 c4 18             	add    $0x18,%esp
}
  801f28:	c9                   	leave  
  801f29:	c3                   	ret    

00801f2a <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801f2a:	55                   	push   %ebp
  801f2b:	89 e5                	mov    %esp,%ebp
  801f2d:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801f30:	83 ec 0c             	sub    $0xc,%esp
  801f33:	68 a8 41 80 00       	push   $0x8041a8
  801f38:	e8 1e e8 ff ff       	call   80075b <cprintf>
  801f3d:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801f40:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801f47:	83 ec 0c             	sub    $0xc,%esp
  801f4a:	68 d4 41 80 00       	push   $0x8041d4
  801f4f:	e8 07 e8 ff ff       	call   80075b <cprintf>
  801f54:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801f57:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f5b:	a1 38 51 80 00       	mov    0x805138,%eax
  801f60:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f63:	eb 56                	jmp    801fbb <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f65:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f69:	74 1c                	je     801f87 <print_mem_block_lists+0x5d>
  801f6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f6e:	8b 50 08             	mov    0x8(%eax),%edx
  801f71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f74:	8b 48 08             	mov    0x8(%eax),%ecx
  801f77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f7a:	8b 40 0c             	mov    0xc(%eax),%eax
  801f7d:	01 c8                	add    %ecx,%eax
  801f7f:	39 c2                	cmp    %eax,%edx
  801f81:	73 04                	jae    801f87 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801f83:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f8a:	8b 50 08             	mov    0x8(%eax),%edx
  801f8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f90:	8b 40 0c             	mov    0xc(%eax),%eax
  801f93:	01 c2                	add    %eax,%edx
  801f95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f98:	8b 40 08             	mov    0x8(%eax),%eax
  801f9b:	83 ec 04             	sub    $0x4,%esp
  801f9e:	52                   	push   %edx
  801f9f:	50                   	push   %eax
  801fa0:	68 e9 41 80 00       	push   $0x8041e9
  801fa5:	e8 b1 e7 ff ff       	call   80075b <cprintf>
  801faa:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801fad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801fb3:	a1 40 51 80 00       	mov    0x805140,%eax
  801fb8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fbb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fbf:	74 07                	je     801fc8 <print_mem_block_lists+0x9e>
  801fc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc4:	8b 00                	mov    (%eax),%eax
  801fc6:	eb 05                	jmp    801fcd <print_mem_block_lists+0xa3>
  801fc8:	b8 00 00 00 00       	mov    $0x0,%eax
  801fcd:	a3 40 51 80 00       	mov    %eax,0x805140
  801fd2:	a1 40 51 80 00       	mov    0x805140,%eax
  801fd7:	85 c0                	test   %eax,%eax
  801fd9:	75 8a                	jne    801f65 <print_mem_block_lists+0x3b>
  801fdb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fdf:	75 84                	jne    801f65 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801fe1:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801fe5:	75 10                	jne    801ff7 <print_mem_block_lists+0xcd>
  801fe7:	83 ec 0c             	sub    $0xc,%esp
  801fea:	68 f8 41 80 00       	push   $0x8041f8
  801fef:	e8 67 e7 ff ff       	call   80075b <cprintf>
  801ff4:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801ff7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801ffe:	83 ec 0c             	sub    $0xc,%esp
  802001:	68 1c 42 80 00       	push   $0x80421c
  802006:	e8 50 e7 ff ff       	call   80075b <cprintf>
  80200b:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80200e:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802012:	a1 40 50 80 00       	mov    0x805040,%eax
  802017:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80201a:	eb 56                	jmp    802072 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80201c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802020:	74 1c                	je     80203e <print_mem_block_lists+0x114>
  802022:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802025:	8b 50 08             	mov    0x8(%eax),%edx
  802028:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80202b:	8b 48 08             	mov    0x8(%eax),%ecx
  80202e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802031:	8b 40 0c             	mov    0xc(%eax),%eax
  802034:	01 c8                	add    %ecx,%eax
  802036:	39 c2                	cmp    %eax,%edx
  802038:	73 04                	jae    80203e <print_mem_block_lists+0x114>
			sorted = 0 ;
  80203a:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80203e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802041:	8b 50 08             	mov    0x8(%eax),%edx
  802044:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802047:	8b 40 0c             	mov    0xc(%eax),%eax
  80204a:	01 c2                	add    %eax,%edx
  80204c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80204f:	8b 40 08             	mov    0x8(%eax),%eax
  802052:	83 ec 04             	sub    $0x4,%esp
  802055:	52                   	push   %edx
  802056:	50                   	push   %eax
  802057:	68 e9 41 80 00       	push   $0x8041e9
  80205c:	e8 fa e6 ff ff       	call   80075b <cprintf>
  802061:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802064:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802067:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80206a:	a1 48 50 80 00       	mov    0x805048,%eax
  80206f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802072:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802076:	74 07                	je     80207f <print_mem_block_lists+0x155>
  802078:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80207b:	8b 00                	mov    (%eax),%eax
  80207d:	eb 05                	jmp    802084 <print_mem_block_lists+0x15a>
  80207f:	b8 00 00 00 00       	mov    $0x0,%eax
  802084:	a3 48 50 80 00       	mov    %eax,0x805048
  802089:	a1 48 50 80 00       	mov    0x805048,%eax
  80208e:	85 c0                	test   %eax,%eax
  802090:	75 8a                	jne    80201c <print_mem_block_lists+0xf2>
  802092:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802096:	75 84                	jne    80201c <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802098:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80209c:	75 10                	jne    8020ae <print_mem_block_lists+0x184>
  80209e:	83 ec 0c             	sub    $0xc,%esp
  8020a1:	68 34 42 80 00       	push   $0x804234
  8020a6:	e8 b0 e6 ff ff       	call   80075b <cprintf>
  8020ab:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8020ae:	83 ec 0c             	sub    $0xc,%esp
  8020b1:	68 a8 41 80 00       	push   $0x8041a8
  8020b6:	e8 a0 e6 ff ff       	call   80075b <cprintf>
  8020bb:	83 c4 10             	add    $0x10,%esp

}
  8020be:	90                   	nop
  8020bf:	c9                   	leave  
  8020c0:	c3                   	ret    

008020c1 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8020c1:	55                   	push   %ebp
  8020c2:	89 e5                	mov    %esp,%ebp
  8020c4:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  8020c7:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8020ce:	00 00 00 
  8020d1:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8020d8:	00 00 00 
  8020db:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8020e2:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  8020e5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8020ec:	e9 9e 00 00 00       	jmp    80218f <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  8020f1:	a1 50 50 80 00       	mov    0x805050,%eax
  8020f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020f9:	c1 e2 04             	shl    $0x4,%edx
  8020fc:	01 d0                	add    %edx,%eax
  8020fe:	85 c0                	test   %eax,%eax
  802100:	75 14                	jne    802116 <initialize_MemBlocksList+0x55>
  802102:	83 ec 04             	sub    $0x4,%esp
  802105:	68 5c 42 80 00       	push   $0x80425c
  80210a:	6a 46                	push   $0x46
  80210c:	68 7f 42 80 00       	push   $0x80427f
  802111:	e8 91 e3 ff ff       	call   8004a7 <_panic>
  802116:	a1 50 50 80 00       	mov    0x805050,%eax
  80211b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80211e:	c1 e2 04             	shl    $0x4,%edx
  802121:	01 d0                	add    %edx,%eax
  802123:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802129:	89 10                	mov    %edx,(%eax)
  80212b:	8b 00                	mov    (%eax),%eax
  80212d:	85 c0                	test   %eax,%eax
  80212f:	74 18                	je     802149 <initialize_MemBlocksList+0x88>
  802131:	a1 48 51 80 00       	mov    0x805148,%eax
  802136:	8b 15 50 50 80 00    	mov    0x805050,%edx
  80213c:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80213f:	c1 e1 04             	shl    $0x4,%ecx
  802142:	01 ca                	add    %ecx,%edx
  802144:	89 50 04             	mov    %edx,0x4(%eax)
  802147:	eb 12                	jmp    80215b <initialize_MemBlocksList+0x9a>
  802149:	a1 50 50 80 00       	mov    0x805050,%eax
  80214e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802151:	c1 e2 04             	shl    $0x4,%edx
  802154:	01 d0                	add    %edx,%eax
  802156:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80215b:	a1 50 50 80 00       	mov    0x805050,%eax
  802160:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802163:	c1 e2 04             	shl    $0x4,%edx
  802166:	01 d0                	add    %edx,%eax
  802168:	a3 48 51 80 00       	mov    %eax,0x805148
  80216d:	a1 50 50 80 00       	mov    0x805050,%eax
  802172:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802175:	c1 e2 04             	shl    $0x4,%edx
  802178:	01 d0                	add    %edx,%eax
  80217a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802181:	a1 54 51 80 00       	mov    0x805154,%eax
  802186:	40                   	inc    %eax
  802187:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  80218c:	ff 45 f4             	incl   -0xc(%ebp)
  80218f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802192:	3b 45 08             	cmp    0x8(%ebp),%eax
  802195:	0f 82 56 ff ff ff    	jb     8020f1 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  80219b:	90                   	nop
  80219c:	c9                   	leave  
  80219d:	c3                   	ret    

0080219e <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80219e:	55                   	push   %ebp
  80219f:	89 e5                	mov    %esp,%ebp
  8021a1:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8021a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a7:	8b 00                	mov    (%eax),%eax
  8021a9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8021ac:	eb 19                	jmp    8021c7 <find_block+0x29>
	{
		if(va==point->sva)
  8021ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021b1:	8b 40 08             	mov    0x8(%eax),%eax
  8021b4:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8021b7:	75 05                	jne    8021be <find_block+0x20>
		   return point;
  8021b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021bc:	eb 36                	jmp    8021f4 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8021be:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c1:	8b 40 08             	mov    0x8(%eax),%eax
  8021c4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8021c7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021cb:	74 07                	je     8021d4 <find_block+0x36>
  8021cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021d0:	8b 00                	mov    (%eax),%eax
  8021d2:	eb 05                	jmp    8021d9 <find_block+0x3b>
  8021d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8021d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8021dc:	89 42 08             	mov    %eax,0x8(%edx)
  8021df:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e2:	8b 40 08             	mov    0x8(%eax),%eax
  8021e5:	85 c0                	test   %eax,%eax
  8021e7:	75 c5                	jne    8021ae <find_block+0x10>
  8021e9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021ed:	75 bf                	jne    8021ae <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  8021ef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021f4:	c9                   	leave  
  8021f5:	c3                   	ret    

008021f6 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8021f6:	55                   	push   %ebp
  8021f7:	89 e5                	mov    %esp,%ebp
  8021f9:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  8021fc:	a1 40 50 80 00       	mov    0x805040,%eax
  802201:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802204:	a1 44 50 80 00       	mov    0x805044,%eax
  802209:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  80220c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80220f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802212:	74 24                	je     802238 <insert_sorted_allocList+0x42>
  802214:	8b 45 08             	mov    0x8(%ebp),%eax
  802217:	8b 50 08             	mov    0x8(%eax),%edx
  80221a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80221d:	8b 40 08             	mov    0x8(%eax),%eax
  802220:	39 c2                	cmp    %eax,%edx
  802222:	76 14                	jbe    802238 <insert_sorted_allocList+0x42>
  802224:	8b 45 08             	mov    0x8(%ebp),%eax
  802227:	8b 50 08             	mov    0x8(%eax),%edx
  80222a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80222d:	8b 40 08             	mov    0x8(%eax),%eax
  802230:	39 c2                	cmp    %eax,%edx
  802232:	0f 82 60 01 00 00    	jb     802398 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802238:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80223c:	75 65                	jne    8022a3 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  80223e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802242:	75 14                	jne    802258 <insert_sorted_allocList+0x62>
  802244:	83 ec 04             	sub    $0x4,%esp
  802247:	68 5c 42 80 00       	push   $0x80425c
  80224c:	6a 6b                	push   $0x6b
  80224e:	68 7f 42 80 00       	push   $0x80427f
  802253:	e8 4f e2 ff ff       	call   8004a7 <_panic>
  802258:	8b 15 40 50 80 00    	mov    0x805040,%edx
  80225e:	8b 45 08             	mov    0x8(%ebp),%eax
  802261:	89 10                	mov    %edx,(%eax)
  802263:	8b 45 08             	mov    0x8(%ebp),%eax
  802266:	8b 00                	mov    (%eax),%eax
  802268:	85 c0                	test   %eax,%eax
  80226a:	74 0d                	je     802279 <insert_sorted_allocList+0x83>
  80226c:	a1 40 50 80 00       	mov    0x805040,%eax
  802271:	8b 55 08             	mov    0x8(%ebp),%edx
  802274:	89 50 04             	mov    %edx,0x4(%eax)
  802277:	eb 08                	jmp    802281 <insert_sorted_allocList+0x8b>
  802279:	8b 45 08             	mov    0x8(%ebp),%eax
  80227c:	a3 44 50 80 00       	mov    %eax,0x805044
  802281:	8b 45 08             	mov    0x8(%ebp),%eax
  802284:	a3 40 50 80 00       	mov    %eax,0x805040
  802289:	8b 45 08             	mov    0x8(%ebp),%eax
  80228c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802293:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802298:	40                   	inc    %eax
  802299:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80229e:	e9 dc 01 00 00       	jmp    80247f <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8022a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a6:	8b 50 08             	mov    0x8(%eax),%edx
  8022a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022ac:	8b 40 08             	mov    0x8(%eax),%eax
  8022af:	39 c2                	cmp    %eax,%edx
  8022b1:	77 6c                	ja     80231f <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8022b3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022b7:	74 06                	je     8022bf <insert_sorted_allocList+0xc9>
  8022b9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022bd:	75 14                	jne    8022d3 <insert_sorted_allocList+0xdd>
  8022bf:	83 ec 04             	sub    $0x4,%esp
  8022c2:	68 98 42 80 00       	push   $0x804298
  8022c7:	6a 6f                	push   $0x6f
  8022c9:	68 7f 42 80 00       	push   $0x80427f
  8022ce:	e8 d4 e1 ff ff       	call   8004a7 <_panic>
  8022d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022d6:	8b 50 04             	mov    0x4(%eax),%edx
  8022d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022dc:	89 50 04             	mov    %edx,0x4(%eax)
  8022df:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022e5:	89 10                	mov    %edx,(%eax)
  8022e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022ea:	8b 40 04             	mov    0x4(%eax),%eax
  8022ed:	85 c0                	test   %eax,%eax
  8022ef:	74 0d                	je     8022fe <insert_sorted_allocList+0x108>
  8022f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022f4:	8b 40 04             	mov    0x4(%eax),%eax
  8022f7:	8b 55 08             	mov    0x8(%ebp),%edx
  8022fa:	89 10                	mov    %edx,(%eax)
  8022fc:	eb 08                	jmp    802306 <insert_sorted_allocList+0x110>
  8022fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802301:	a3 40 50 80 00       	mov    %eax,0x805040
  802306:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802309:	8b 55 08             	mov    0x8(%ebp),%edx
  80230c:	89 50 04             	mov    %edx,0x4(%eax)
  80230f:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802314:	40                   	inc    %eax
  802315:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80231a:	e9 60 01 00 00       	jmp    80247f <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  80231f:	8b 45 08             	mov    0x8(%ebp),%eax
  802322:	8b 50 08             	mov    0x8(%eax),%edx
  802325:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802328:	8b 40 08             	mov    0x8(%eax),%eax
  80232b:	39 c2                	cmp    %eax,%edx
  80232d:	0f 82 4c 01 00 00    	jb     80247f <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802333:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802337:	75 14                	jne    80234d <insert_sorted_allocList+0x157>
  802339:	83 ec 04             	sub    $0x4,%esp
  80233c:	68 d0 42 80 00       	push   $0x8042d0
  802341:	6a 73                	push   $0x73
  802343:	68 7f 42 80 00       	push   $0x80427f
  802348:	e8 5a e1 ff ff       	call   8004a7 <_panic>
  80234d:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802353:	8b 45 08             	mov    0x8(%ebp),%eax
  802356:	89 50 04             	mov    %edx,0x4(%eax)
  802359:	8b 45 08             	mov    0x8(%ebp),%eax
  80235c:	8b 40 04             	mov    0x4(%eax),%eax
  80235f:	85 c0                	test   %eax,%eax
  802361:	74 0c                	je     80236f <insert_sorted_allocList+0x179>
  802363:	a1 44 50 80 00       	mov    0x805044,%eax
  802368:	8b 55 08             	mov    0x8(%ebp),%edx
  80236b:	89 10                	mov    %edx,(%eax)
  80236d:	eb 08                	jmp    802377 <insert_sorted_allocList+0x181>
  80236f:	8b 45 08             	mov    0x8(%ebp),%eax
  802372:	a3 40 50 80 00       	mov    %eax,0x805040
  802377:	8b 45 08             	mov    0x8(%ebp),%eax
  80237a:	a3 44 50 80 00       	mov    %eax,0x805044
  80237f:	8b 45 08             	mov    0x8(%ebp),%eax
  802382:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802388:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80238d:	40                   	inc    %eax
  80238e:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802393:	e9 e7 00 00 00       	jmp    80247f <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802398:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80239b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  80239e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8023a5:	a1 40 50 80 00       	mov    0x805040,%eax
  8023aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023ad:	e9 9d 00 00 00       	jmp    80244f <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8023b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b5:	8b 00                	mov    (%eax),%eax
  8023b7:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8023ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bd:	8b 50 08             	mov    0x8(%eax),%edx
  8023c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c3:	8b 40 08             	mov    0x8(%eax),%eax
  8023c6:	39 c2                	cmp    %eax,%edx
  8023c8:	76 7d                	jbe    802447 <insert_sorted_allocList+0x251>
  8023ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8023cd:	8b 50 08             	mov    0x8(%eax),%edx
  8023d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8023d3:	8b 40 08             	mov    0x8(%eax),%eax
  8023d6:	39 c2                	cmp    %eax,%edx
  8023d8:	73 6d                	jae    802447 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8023da:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023de:	74 06                	je     8023e6 <insert_sorted_allocList+0x1f0>
  8023e0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023e4:	75 14                	jne    8023fa <insert_sorted_allocList+0x204>
  8023e6:	83 ec 04             	sub    $0x4,%esp
  8023e9:	68 f4 42 80 00       	push   $0x8042f4
  8023ee:	6a 7f                	push   $0x7f
  8023f0:	68 7f 42 80 00       	push   $0x80427f
  8023f5:	e8 ad e0 ff ff       	call   8004a7 <_panic>
  8023fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fd:	8b 10                	mov    (%eax),%edx
  8023ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802402:	89 10                	mov    %edx,(%eax)
  802404:	8b 45 08             	mov    0x8(%ebp),%eax
  802407:	8b 00                	mov    (%eax),%eax
  802409:	85 c0                	test   %eax,%eax
  80240b:	74 0b                	je     802418 <insert_sorted_allocList+0x222>
  80240d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802410:	8b 00                	mov    (%eax),%eax
  802412:	8b 55 08             	mov    0x8(%ebp),%edx
  802415:	89 50 04             	mov    %edx,0x4(%eax)
  802418:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241b:	8b 55 08             	mov    0x8(%ebp),%edx
  80241e:	89 10                	mov    %edx,(%eax)
  802420:	8b 45 08             	mov    0x8(%ebp),%eax
  802423:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802426:	89 50 04             	mov    %edx,0x4(%eax)
  802429:	8b 45 08             	mov    0x8(%ebp),%eax
  80242c:	8b 00                	mov    (%eax),%eax
  80242e:	85 c0                	test   %eax,%eax
  802430:	75 08                	jne    80243a <insert_sorted_allocList+0x244>
  802432:	8b 45 08             	mov    0x8(%ebp),%eax
  802435:	a3 44 50 80 00       	mov    %eax,0x805044
  80243a:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80243f:	40                   	inc    %eax
  802440:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802445:	eb 39                	jmp    802480 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802447:	a1 48 50 80 00       	mov    0x805048,%eax
  80244c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80244f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802453:	74 07                	je     80245c <insert_sorted_allocList+0x266>
  802455:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802458:	8b 00                	mov    (%eax),%eax
  80245a:	eb 05                	jmp    802461 <insert_sorted_allocList+0x26b>
  80245c:	b8 00 00 00 00       	mov    $0x0,%eax
  802461:	a3 48 50 80 00       	mov    %eax,0x805048
  802466:	a1 48 50 80 00       	mov    0x805048,%eax
  80246b:	85 c0                	test   %eax,%eax
  80246d:	0f 85 3f ff ff ff    	jne    8023b2 <insert_sorted_allocList+0x1bc>
  802473:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802477:	0f 85 35 ff ff ff    	jne    8023b2 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80247d:	eb 01                	jmp    802480 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80247f:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802480:	90                   	nop
  802481:	c9                   	leave  
  802482:	c3                   	ret    

00802483 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802483:	55                   	push   %ebp
  802484:	89 e5                	mov    %esp,%ebp
  802486:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802489:	a1 38 51 80 00       	mov    0x805138,%eax
  80248e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802491:	e9 85 01 00 00       	jmp    80261b <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802496:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802499:	8b 40 0c             	mov    0xc(%eax),%eax
  80249c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80249f:	0f 82 6e 01 00 00    	jb     802613 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8024a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a8:	8b 40 0c             	mov    0xc(%eax),%eax
  8024ab:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024ae:	0f 85 8a 00 00 00    	jne    80253e <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8024b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024b8:	75 17                	jne    8024d1 <alloc_block_FF+0x4e>
  8024ba:	83 ec 04             	sub    $0x4,%esp
  8024bd:	68 28 43 80 00       	push   $0x804328
  8024c2:	68 93 00 00 00       	push   $0x93
  8024c7:	68 7f 42 80 00       	push   $0x80427f
  8024cc:	e8 d6 df ff ff       	call   8004a7 <_panic>
  8024d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d4:	8b 00                	mov    (%eax),%eax
  8024d6:	85 c0                	test   %eax,%eax
  8024d8:	74 10                	je     8024ea <alloc_block_FF+0x67>
  8024da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024dd:	8b 00                	mov    (%eax),%eax
  8024df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024e2:	8b 52 04             	mov    0x4(%edx),%edx
  8024e5:	89 50 04             	mov    %edx,0x4(%eax)
  8024e8:	eb 0b                	jmp    8024f5 <alloc_block_FF+0x72>
  8024ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ed:	8b 40 04             	mov    0x4(%eax),%eax
  8024f0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8024f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f8:	8b 40 04             	mov    0x4(%eax),%eax
  8024fb:	85 c0                	test   %eax,%eax
  8024fd:	74 0f                	je     80250e <alloc_block_FF+0x8b>
  8024ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802502:	8b 40 04             	mov    0x4(%eax),%eax
  802505:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802508:	8b 12                	mov    (%edx),%edx
  80250a:	89 10                	mov    %edx,(%eax)
  80250c:	eb 0a                	jmp    802518 <alloc_block_FF+0x95>
  80250e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802511:	8b 00                	mov    (%eax),%eax
  802513:	a3 38 51 80 00       	mov    %eax,0x805138
  802518:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802521:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802524:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80252b:	a1 44 51 80 00       	mov    0x805144,%eax
  802530:	48                   	dec    %eax
  802531:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802536:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802539:	e9 10 01 00 00       	jmp    80264e <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  80253e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802541:	8b 40 0c             	mov    0xc(%eax),%eax
  802544:	3b 45 08             	cmp    0x8(%ebp),%eax
  802547:	0f 86 c6 00 00 00    	jbe    802613 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80254d:	a1 48 51 80 00       	mov    0x805148,%eax
  802552:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802555:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802558:	8b 50 08             	mov    0x8(%eax),%edx
  80255b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80255e:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802561:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802564:	8b 55 08             	mov    0x8(%ebp),%edx
  802567:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80256a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80256e:	75 17                	jne    802587 <alloc_block_FF+0x104>
  802570:	83 ec 04             	sub    $0x4,%esp
  802573:	68 28 43 80 00       	push   $0x804328
  802578:	68 9b 00 00 00       	push   $0x9b
  80257d:	68 7f 42 80 00       	push   $0x80427f
  802582:	e8 20 df ff ff       	call   8004a7 <_panic>
  802587:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80258a:	8b 00                	mov    (%eax),%eax
  80258c:	85 c0                	test   %eax,%eax
  80258e:	74 10                	je     8025a0 <alloc_block_FF+0x11d>
  802590:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802593:	8b 00                	mov    (%eax),%eax
  802595:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802598:	8b 52 04             	mov    0x4(%edx),%edx
  80259b:	89 50 04             	mov    %edx,0x4(%eax)
  80259e:	eb 0b                	jmp    8025ab <alloc_block_FF+0x128>
  8025a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025a3:	8b 40 04             	mov    0x4(%eax),%eax
  8025a6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8025ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025ae:	8b 40 04             	mov    0x4(%eax),%eax
  8025b1:	85 c0                	test   %eax,%eax
  8025b3:	74 0f                	je     8025c4 <alloc_block_FF+0x141>
  8025b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025b8:	8b 40 04             	mov    0x4(%eax),%eax
  8025bb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025be:	8b 12                	mov    (%edx),%edx
  8025c0:	89 10                	mov    %edx,(%eax)
  8025c2:	eb 0a                	jmp    8025ce <alloc_block_FF+0x14b>
  8025c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025c7:	8b 00                	mov    (%eax),%eax
  8025c9:	a3 48 51 80 00       	mov    %eax,0x805148
  8025ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025d1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025da:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025e1:	a1 54 51 80 00       	mov    0x805154,%eax
  8025e6:	48                   	dec    %eax
  8025e7:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  8025ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ef:	8b 50 08             	mov    0x8(%eax),%edx
  8025f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f5:	01 c2                	add    %eax,%edx
  8025f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fa:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8025fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802600:	8b 40 0c             	mov    0xc(%eax),%eax
  802603:	2b 45 08             	sub    0x8(%ebp),%eax
  802606:	89 c2                	mov    %eax,%edx
  802608:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260b:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  80260e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802611:	eb 3b                	jmp    80264e <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802613:	a1 40 51 80 00       	mov    0x805140,%eax
  802618:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80261b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80261f:	74 07                	je     802628 <alloc_block_FF+0x1a5>
  802621:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802624:	8b 00                	mov    (%eax),%eax
  802626:	eb 05                	jmp    80262d <alloc_block_FF+0x1aa>
  802628:	b8 00 00 00 00       	mov    $0x0,%eax
  80262d:	a3 40 51 80 00       	mov    %eax,0x805140
  802632:	a1 40 51 80 00       	mov    0x805140,%eax
  802637:	85 c0                	test   %eax,%eax
  802639:	0f 85 57 fe ff ff    	jne    802496 <alloc_block_FF+0x13>
  80263f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802643:	0f 85 4d fe ff ff    	jne    802496 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802649:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80264e:	c9                   	leave  
  80264f:	c3                   	ret    

00802650 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802650:	55                   	push   %ebp
  802651:	89 e5                	mov    %esp,%ebp
  802653:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802656:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80265d:	a1 38 51 80 00       	mov    0x805138,%eax
  802662:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802665:	e9 df 00 00 00       	jmp    802749 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  80266a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266d:	8b 40 0c             	mov    0xc(%eax),%eax
  802670:	3b 45 08             	cmp    0x8(%ebp),%eax
  802673:	0f 82 c8 00 00 00    	jb     802741 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802679:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267c:	8b 40 0c             	mov    0xc(%eax),%eax
  80267f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802682:	0f 85 8a 00 00 00    	jne    802712 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802688:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80268c:	75 17                	jne    8026a5 <alloc_block_BF+0x55>
  80268e:	83 ec 04             	sub    $0x4,%esp
  802691:	68 28 43 80 00       	push   $0x804328
  802696:	68 b7 00 00 00       	push   $0xb7
  80269b:	68 7f 42 80 00       	push   $0x80427f
  8026a0:	e8 02 de ff ff       	call   8004a7 <_panic>
  8026a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a8:	8b 00                	mov    (%eax),%eax
  8026aa:	85 c0                	test   %eax,%eax
  8026ac:	74 10                	je     8026be <alloc_block_BF+0x6e>
  8026ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b1:	8b 00                	mov    (%eax),%eax
  8026b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026b6:	8b 52 04             	mov    0x4(%edx),%edx
  8026b9:	89 50 04             	mov    %edx,0x4(%eax)
  8026bc:	eb 0b                	jmp    8026c9 <alloc_block_BF+0x79>
  8026be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c1:	8b 40 04             	mov    0x4(%eax),%eax
  8026c4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8026c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cc:	8b 40 04             	mov    0x4(%eax),%eax
  8026cf:	85 c0                	test   %eax,%eax
  8026d1:	74 0f                	je     8026e2 <alloc_block_BF+0x92>
  8026d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d6:	8b 40 04             	mov    0x4(%eax),%eax
  8026d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026dc:	8b 12                	mov    (%edx),%edx
  8026de:	89 10                	mov    %edx,(%eax)
  8026e0:	eb 0a                	jmp    8026ec <alloc_block_BF+0x9c>
  8026e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e5:	8b 00                	mov    (%eax),%eax
  8026e7:	a3 38 51 80 00       	mov    %eax,0x805138
  8026ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026ff:	a1 44 51 80 00       	mov    0x805144,%eax
  802704:	48                   	dec    %eax
  802705:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  80270a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270d:	e9 4d 01 00 00       	jmp    80285f <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802712:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802715:	8b 40 0c             	mov    0xc(%eax),%eax
  802718:	3b 45 08             	cmp    0x8(%ebp),%eax
  80271b:	76 24                	jbe    802741 <alloc_block_BF+0xf1>
  80271d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802720:	8b 40 0c             	mov    0xc(%eax),%eax
  802723:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802726:	73 19                	jae    802741 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802728:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  80272f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802732:	8b 40 0c             	mov    0xc(%eax),%eax
  802735:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802738:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273b:	8b 40 08             	mov    0x8(%eax),%eax
  80273e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802741:	a1 40 51 80 00       	mov    0x805140,%eax
  802746:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802749:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80274d:	74 07                	je     802756 <alloc_block_BF+0x106>
  80274f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802752:	8b 00                	mov    (%eax),%eax
  802754:	eb 05                	jmp    80275b <alloc_block_BF+0x10b>
  802756:	b8 00 00 00 00       	mov    $0x0,%eax
  80275b:	a3 40 51 80 00       	mov    %eax,0x805140
  802760:	a1 40 51 80 00       	mov    0x805140,%eax
  802765:	85 c0                	test   %eax,%eax
  802767:	0f 85 fd fe ff ff    	jne    80266a <alloc_block_BF+0x1a>
  80276d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802771:	0f 85 f3 fe ff ff    	jne    80266a <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802777:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80277b:	0f 84 d9 00 00 00    	je     80285a <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802781:	a1 48 51 80 00       	mov    0x805148,%eax
  802786:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802789:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80278c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80278f:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802792:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802795:	8b 55 08             	mov    0x8(%ebp),%edx
  802798:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  80279b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80279f:	75 17                	jne    8027b8 <alloc_block_BF+0x168>
  8027a1:	83 ec 04             	sub    $0x4,%esp
  8027a4:	68 28 43 80 00       	push   $0x804328
  8027a9:	68 c7 00 00 00       	push   $0xc7
  8027ae:	68 7f 42 80 00       	push   $0x80427f
  8027b3:	e8 ef dc ff ff       	call   8004a7 <_panic>
  8027b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027bb:	8b 00                	mov    (%eax),%eax
  8027bd:	85 c0                	test   %eax,%eax
  8027bf:	74 10                	je     8027d1 <alloc_block_BF+0x181>
  8027c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027c4:	8b 00                	mov    (%eax),%eax
  8027c6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027c9:	8b 52 04             	mov    0x4(%edx),%edx
  8027cc:	89 50 04             	mov    %edx,0x4(%eax)
  8027cf:	eb 0b                	jmp    8027dc <alloc_block_BF+0x18c>
  8027d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027d4:	8b 40 04             	mov    0x4(%eax),%eax
  8027d7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8027dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027df:	8b 40 04             	mov    0x4(%eax),%eax
  8027e2:	85 c0                	test   %eax,%eax
  8027e4:	74 0f                	je     8027f5 <alloc_block_BF+0x1a5>
  8027e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027e9:	8b 40 04             	mov    0x4(%eax),%eax
  8027ec:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027ef:	8b 12                	mov    (%edx),%edx
  8027f1:	89 10                	mov    %edx,(%eax)
  8027f3:	eb 0a                	jmp    8027ff <alloc_block_BF+0x1af>
  8027f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027f8:	8b 00                	mov    (%eax),%eax
  8027fa:	a3 48 51 80 00       	mov    %eax,0x805148
  8027ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802802:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802808:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80280b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802812:	a1 54 51 80 00       	mov    0x805154,%eax
  802817:	48                   	dec    %eax
  802818:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  80281d:	83 ec 08             	sub    $0x8,%esp
  802820:	ff 75 ec             	pushl  -0x14(%ebp)
  802823:	68 38 51 80 00       	push   $0x805138
  802828:	e8 71 f9 ff ff       	call   80219e <find_block>
  80282d:	83 c4 10             	add    $0x10,%esp
  802830:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802833:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802836:	8b 50 08             	mov    0x8(%eax),%edx
  802839:	8b 45 08             	mov    0x8(%ebp),%eax
  80283c:	01 c2                	add    %eax,%edx
  80283e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802841:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802844:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802847:	8b 40 0c             	mov    0xc(%eax),%eax
  80284a:	2b 45 08             	sub    0x8(%ebp),%eax
  80284d:	89 c2                	mov    %eax,%edx
  80284f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802852:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802855:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802858:	eb 05                	jmp    80285f <alloc_block_BF+0x20f>
	}
	return NULL;
  80285a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80285f:	c9                   	leave  
  802860:	c3                   	ret    

00802861 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802861:	55                   	push   %ebp
  802862:	89 e5                	mov    %esp,%ebp
  802864:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802867:	a1 28 50 80 00       	mov    0x805028,%eax
  80286c:	85 c0                	test   %eax,%eax
  80286e:	0f 85 de 01 00 00    	jne    802a52 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802874:	a1 38 51 80 00       	mov    0x805138,%eax
  802879:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80287c:	e9 9e 01 00 00       	jmp    802a1f <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802881:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802884:	8b 40 0c             	mov    0xc(%eax),%eax
  802887:	3b 45 08             	cmp    0x8(%ebp),%eax
  80288a:	0f 82 87 01 00 00    	jb     802a17 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802890:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802893:	8b 40 0c             	mov    0xc(%eax),%eax
  802896:	3b 45 08             	cmp    0x8(%ebp),%eax
  802899:	0f 85 95 00 00 00    	jne    802934 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  80289f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028a3:	75 17                	jne    8028bc <alloc_block_NF+0x5b>
  8028a5:	83 ec 04             	sub    $0x4,%esp
  8028a8:	68 28 43 80 00       	push   $0x804328
  8028ad:	68 e0 00 00 00       	push   $0xe0
  8028b2:	68 7f 42 80 00       	push   $0x80427f
  8028b7:	e8 eb db ff ff       	call   8004a7 <_panic>
  8028bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bf:	8b 00                	mov    (%eax),%eax
  8028c1:	85 c0                	test   %eax,%eax
  8028c3:	74 10                	je     8028d5 <alloc_block_NF+0x74>
  8028c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c8:	8b 00                	mov    (%eax),%eax
  8028ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028cd:	8b 52 04             	mov    0x4(%edx),%edx
  8028d0:	89 50 04             	mov    %edx,0x4(%eax)
  8028d3:	eb 0b                	jmp    8028e0 <alloc_block_NF+0x7f>
  8028d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d8:	8b 40 04             	mov    0x4(%eax),%eax
  8028db:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8028e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e3:	8b 40 04             	mov    0x4(%eax),%eax
  8028e6:	85 c0                	test   %eax,%eax
  8028e8:	74 0f                	je     8028f9 <alloc_block_NF+0x98>
  8028ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ed:	8b 40 04             	mov    0x4(%eax),%eax
  8028f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028f3:	8b 12                	mov    (%edx),%edx
  8028f5:	89 10                	mov    %edx,(%eax)
  8028f7:	eb 0a                	jmp    802903 <alloc_block_NF+0xa2>
  8028f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fc:	8b 00                	mov    (%eax),%eax
  8028fe:	a3 38 51 80 00       	mov    %eax,0x805138
  802903:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802906:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80290c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802916:	a1 44 51 80 00       	mov    0x805144,%eax
  80291b:	48                   	dec    %eax
  80291c:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802921:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802924:	8b 40 08             	mov    0x8(%eax),%eax
  802927:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  80292c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292f:	e9 f8 04 00 00       	jmp    802e2c <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802934:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802937:	8b 40 0c             	mov    0xc(%eax),%eax
  80293a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80293d:	0f 86 d4 00 00 00    	jbe    802a17 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802943:	a1 48 51 80 00       	mov    0x805148,%eax
  802948:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  80294b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294e:	8b 50 08             	mov    0x8(%eax),%edx
  802951:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802954:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802957:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80295a:	8b 55 08             	mov    0x8(%ebp),%edx
  80295d:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802960:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802964:	75 17                	jne    80297d <alloc_block_NF+0x11c>
  802966:	83 ec 04             	sub    $0x4,%esp
  802969:	68 28 43 80 00       	push   $0x804328
  80296e:	68 e9 00 00 00       	push   $0xe9
  802973:	68 7f 42 80 00       	push   $0x80427f
  802978:	e8 2a db ff ff       	call   8004a7 <_panic>
  80297d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802980:	8b 00                	mov    (%eax),%eax
  802982:	85 c0                	test   %eax,%eax
  802984:	74 10                	je     802996 <alloc_block_NF+0x135>
  802986:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802989:	8b 00                	mov    (%eax),%eax
  80298b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80298e:	8b 52 04             	mov    0x4(%edx),%edx
  802991:	89 50 04             	mov    %edx,0x4(%eax)
  802994:	eb 0b                	jmp    8029a1 <alloc_block_NF+0x140>
  802996:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802999:	8b 40 04             	mov    0x4(%eax),%eax
  80299c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8029a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a4:	8b 40 04             	mov    0x4(%eax),%eax
  8029a7:	85 c0                	test   %eax,%eax
  8029a9:	74 0f                	je     8029ba <alloc_block_NF+0x159>
  8029ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ae:	8b 40 04             	mov    0x4(%eax),%eax
  8029b1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029b4:	8b 12                	mov    (%edx),%edx
  8029b6:	89 10                	mov    %edx,(%eax)
  8029b8:	eb 0a                	jmp    8029c4 <alloc_block_NF+0x163>
  8029ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029bd:	8b 00                	mov    (%eax),%eax
  8029bf:	a3 48 51 80 00       	mov    %eax,0x805148
  8029c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029c7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029d0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029d7:	a1 54 51 80 00       	mov    0x805154,%eax
  8029dc:	48                   	dec    %eax
  8029dd:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  8029e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029e5:	8b 40 08             	mov    0x8(%eax),%eax
  8029e8:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  8029ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f0:	8b 50 08             	mov    0x8(%eax),%edx
  8029f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f6:	01 c2                	add    %eax,%edx
  8029f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fb:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  8029fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a01:	8b 40 0c             	mov    0xc(%eax),%eax
  802a04:	2b 45 08             	sub    0x8(%ebp),%eax
  802a07:	89 c2                	mov    %eax,%edx
  802a09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0c:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802a0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a12:	e9 15 04 00 00       	jmp    802e2c <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802a17:	a1 40 51 80 00       	mov    0x805140,%eax
  802a1c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a1f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a23:	74 07                	je     802a2c <alloc_block_NF+0x1cb>
  802a25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a28:	8b 00                	mov    (%eax),%eax
  802a2a:	eb 05                	jmp    802a31 <alloc_block_NF+0x1d0>
  802a2c:	b8 00 00 00 00       	mov    $0x0,%eax
  802a31:	a3 40 51 80 00       	mov    %eax,0x805140
  802a36:	a1 40 51 80 00       	mov    0x805140,%eax
  802a3b:	85 c0                	test   %eax,%eax
  802a3d:	0f 85 3e fe ff ff    	jne    802881 <alloc_block_NF+0x20>
  802a43:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a47:	0f 85 34 fe ff ff    	jne    802881 <alloc_block_NF+0x20>
  802a4d:	e9 d5 03 00 00       	jmp    802e27 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a52:	a1 38 51 80 00       	mov    0x805138,%eax
  802a57:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a5a:	e9 b1 01 00 00       	jmp    802c10 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802a5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a62:	8b 50 08             	mov    0x8(%eax),%edx
  802a65:	a1 28 50 80 00       	mov    0x805028,%eax
  802a6a:	39 c2                	cmp    %eax,%edx
  802a6c:	0f 82 96 01 00 00    	jb     802c08 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802a72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a75:	8b 40 0c             	mov    0xc(%eax),%eax
  802a78:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a7b:	0f 82 87 01 00 00    	jb     802c08 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802a81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a84:	8b 40 0c             	mov    0xc(%eax),%eax
  802a87:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a8a:	0f 85 95 00 00 00    	jne    802b25 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802a90:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a94:	75 17                	jne    802aad <alloc_block_NF+0x24c>
  802a96:	83 ec 04             	sub    $0x4,%esp
  802a99:	68 28 43 80 00       	push   $0x804328
  802a9e:	68 fc 00 00 00       	push   $0xfc
  802aa3:	68 7f 42 80 00       	push   $0x80427f
  802aa8:	e8 fa d9 ff ff       	call   8004a7 <_panic>
  802aad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab0:	8b 00                	mov    (%eax),%eax
  802ab2:	85 c0                	test   %eax,%eax
  802ab4:	74 10                	je     802ac6 <alloc_block_NF+0x265>
  802ab6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab9:	8b 00                	mov    (%eax),%eax
  802abb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802abe:	8b 52 04             	mov    0x4(%edx),%edx
  802ac1:	89 50 04             	mov    %edx,0x4(%eax)
  802ac4:	eb 0b                	jmp    802ad1 <alloc_block_NF+0x270>
  802ac6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac9:	8b 40 04             	mov    0x4(%eax),%eax
  802acc:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ad1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad4:	8b 40 04             	mov    0x4(%eax),%eax
  802ad7:	85 c0                	test   %eax,%eax
  802ad9:	74 0f                	je     802aea <alloc_block_NF+0x289>
  802adb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ade:	8b 40 04             	mov    0x4(%eax),%eax
  802ae1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ae4:	8b 12                	mov    (%edx),%edx
  802ae6:	89 10                	mov    %edx,(%eax)
  802ae8:	eb 0a                	jmp    802af4 <alloc_block_NF+0x293>
  802aea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aed:	8b 00                	mov    (%eax),%eax
  802aef:	a3 38 51 80 00       	mov    %eax,0x805138
  802af4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802afd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b00:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b07:	a1 44 51 80 00       	mov    0x805144,%eax
  802b0c:	48                   	dec    %eax
  802b0d:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802b12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b15:	8b 40 08             	mov    0x8(%eax),%eax
  802b18:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802b1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b20:	e9 07 03 00 00       	jmp    802e2c <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802b25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b28:	8b 40 0c             	mov    0xc(%eax),%eax
  802b2b:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b2e:	0f 86 d4 00 00 00    	jbe    802c08 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b34:	a1 48 51 80 00       	mov    0x805148,%eax
  802b39:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802b3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3f:	8b 50 08             	mov    0x8(%eax),%edx
  802b42:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b45:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802b48:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b4b:	8b 55 08             	mov    0x8(%ebp),%edx
  802b4e:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802b51:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802b55:	75 17                	jne    802b6e <alloc_block_NF+0x30d>
  802b57:	83 ec 04             	sub    $0x4,%esp
  802b5a:	68 28 43 80 00       	push   $0x804328
  802b5f:	68 04 01 00 00       	push   $0x104
  802b64:	68 7f 42 80 00       	push   $0x80427f
  802b69:	e8 39 d9 ff ff       	call   8004a7 <_panic>
  802b6e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b71:	8b 00                	mov    (%eax),%eax
  802b73:	85 c0                	test   %eax,%eax
  802b75:	74 10                	je     802b87 <alloc_block_NF+0x326>
  802b77:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b7a:	8b 00                	mov    (%eax),%eax
  802b7c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b7f:	8b 52 04             	mov    0x4(%edx),%edx
  802b82:	89 50 04             	mov    %edx,0x4(%eax)
  802b85:	eb 0b                	jmp    802b92 <alloc_block_NF+0x331>
  802b87:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b8a:	8b 40 04             	mov    0x4(%eax),%eax
  802b8d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b92:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b95:	8b 40 04             	mov    0x4(%eax),%eax
  802b98:	85 c0                	test   %eax,%eax
  802b9a:	74 0f                	je     802bab <alloc_block_NF+0x34a>
  802b9c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b9f:	8b 40 04             	mov    0x4(%eax),%eax
  802ba2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ba5:	8b 12                	mov    (%edx),%edx
  802ba7:	89 10                	mov    %edx,(%eax)
  802ba9:	eb 0a                	jmp    802bb5 <alloc_block_NF+0x354>
  802bab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bae:	8b 00                	mov    (%eax),%eax
  802bb0:	a3 48 51 80 00       	mov    %eax,0x805148
  802bb5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bb8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bbe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bc1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bc8:	a1 54 51 80 00       	mov    0x805154,%eax
  802bcd:	48                   	dec    %eax
  802bce:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802bd3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bd6:	8b 40 08             	mov    0x8(%eax),%eax
  802bd9:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802bde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be1:	8b 50 08             	mov    0x8(%eax),%edx
  802be4:	8b 45 08             	mov    0x8(%ebp),%eax
  802be7:	01 c2                	add    %eax,%edx
  802be9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bec:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802bef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf2:	8b 40 0c             	mov    0xc(%eax),%eax
  802bf5:	2b 45 08             	sub    0x8(%ebp),%eax
  802bf8:	89 c2                	mov    %eax,%edx
  802bfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfd:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802c00:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c03:	e9 24 02 00 00       	jmp    802e2c <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c08:	a1 40 51 80 00       	mov    0x805140,%eax
  802c0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c10:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c14:	74 07                	je     802c1d <alloc_block_NF+0x3bc>
  802c16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c19:	8b 00                	mov    (%eax),%eax
  802c1b:	eb 05                	jmp    802c22 <alloc_block_NF+0x3c1>
  802c1d:	b8 00 00 00 00       	mov    $0x0,%eax
  802c22:	a3 40 51 80 00       	mov    %eax,0x805140
  802c27:	a1 40 51 80 00       	mov    0x805140,%eax
  802c2c:	85 c0                	test   %eax,%eax
  802c2e:	0f 85 2b fe ff ff    	jne    802a5f <alloc_block_NF+0x1fe>
  802c34:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c38:	0f 85 21 fe ff ff    	jne    802a5f <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c3e:	a1 38 51 80 00       	mov    0x805138,%eax
  802c43:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c46:	e9 ae 01 00 00       	jmp    802df9 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802c4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4e:	8b 50 08             	mov    0x8(%eax),%edx
  802c51:	a1 28 50 80 00       	mov    0x805028,%eax
  802c56:	39 c2                	cmp    %eax,%edx
  802c58:	0f 83 93 01 00 00    	jae    802df1 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802c5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c61:	8b 40 0c             	mov    0xc(%eax),%eax
  802c64:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c67:	0f 82 84 01 00 00    	jb     802df1 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802c6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c70:	8b 40 0c             	mov    0xc(%eax),%eax
  802c73:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c76:	0f 85 95 00 00 00    	jne    802d11 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802c7c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c80:	75 17                	jne    802c99 <alloc_block_NF+0x438>
  802c82:	83 ec 04             	sub    $0x4,%esp
  802c85:	68 28 43 80 00       	push   $0x804328
  802c8a:	68 14 01 00 00       	push   $0x114
  802c8f:	68 7f 42 80 00       	push   $0x80427f
  802c94:	e8 0e d8 ff ff       	call   8004a7 <_panic>
  802c99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9c:	8b 00                	mov    (%eax),%eax
  802c9e:	85 c0                	test   %eax,%eax
  802ca0:	74 10                	je     802cb2 <alloc_block_NF+0x451>
  802ca2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca5:	8b 00                	mov    (%eax),%eax
  802ca7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802caa:	8b 52 04             	mov    0x4(%edx),%edx
  802cad:	89 50 04             	mov    %edx,0x4(%eax)
  802cb0:	eb 0b                	jmp    802cbd <alloc_block_NF+0x45c>
  802cb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb5:	8b 40 04             	mov    0x4(%eax),%eax
  802cb8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802cbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc0:	8b 40 04             	mov    0x4(%eax),%eax
  802cc3:	85 c0                	test   %eax,%eax
  802cc5:	74 0f                	je     802cd6 <alloc_block_NF+0x475>
  802cc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cca:	8b 40 04             	mov    0x4(%eax),%eax
  802ccd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cd0:	8b 12                	mov    (%edx),%edx
  802cd2:	89 10                	mov    %edx,(%eax)
  802cd4:	eb 0a                	jmp    802ce0 <alloc_block_NF+0x47f>
  802cd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd9:	8b 00                	mov    (%eax),%eax
  802cdb:	a3 38 51 80 00       	mov    %eax,0x805138
  802ce0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ce9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cec:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cf3:	a1 44 51 80 00       	mov    0x805144,%eax
  802cf8:	48                   	dec    %eax
  802cf9:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802cfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d01:	8b 40 08             	mov    0x8(%eax),%eax
  802d04:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802d09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0c:	e9 1b 01 00 00       	jmp    802e2c <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802d11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d14:	8b 40 0c             	mov    0xc(%eax),%eax
  802d17:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d1a:	0f 86 d1 00 00 00    	jbe    802df1 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802d20:	a1 48 51 80 00       	mov    0x805148,%eax
  802d25:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802d28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2b:	8b 50 08             	mov    0x8(%eax),%edx
  802d2e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d31:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802d34:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d37:	8b 55 08             	mov    0x8(%ebp),%edx
  802d3a:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802d3d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802d41:	75 17                	jne    802d5a <alloc_block_NF+0x4f9>
  802d43:	83 ec 04             	sub    $0x4,%esp
  802d46:	68 28 43 80 00       	push   $0x804328
  802d4b:	68 1c 01 00 00       	push   $0x11c
  802d50:	68 7f 42 80 00       	push   $0x80427f
  802d55:	e8 4d d7 ff ff       	call   8004a7 <_panic>
  802d5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d5d:	8b 00                	mov    (%eax),%eax
  802d5f:	85 c0                	test   %eax,%eax
  802d61:	74 10                	je     802d73 <alloc_block_NF+0x512>
  802d63:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d66:	8b 00                	mov    (%eax),%eax
  802d68:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d6b:	8b 52 04             	mov    0x4(%edx),%edx
  802d6e:	89 50 04             	mov    %edx,0x4(%eax)
  802d71:	eb 0b                	jmp    802d7e <alloc_block_NF+0x51d>
  802d73:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d76:	8b 40 04             	mov    0x4(%eax),%eax
  802d79:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d81:	8b 40 04             	mov    0x4(%eax),%eax
  802d84:	85 c0                	test   %eax,%eax
  802d86:	74 0f                	je     802d97 <alloc_block_NF+0x536>
  802d88:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d8b:	8b 40 04             	mov    0x4(%eax),%eax
  802d8e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d91:	8b 12                	mov    (%edx),%edx
  802d93:	89 10                	mov    %edx,(%eax)
  802d95:	eb 0a                	jmp    802da1 <alloc_block_NF+0x540>
  802d97:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d9a:	8b 00                	mov    (%eax),%eax
  802d9c:	a3 48 51 80 00       	mov    %eax,0x805148
  802da1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802da4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802daa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dad:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802db4:	a1 54 51 80 00       	mov    0x805154,%eax
  802db9:	48                   	dec    %eax
  802dba:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802dbf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dc2:	8b 40 08             	mov    0x8(%eax),%eax
  802dc5:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802dca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dcd:	8b 50 08             	mov    0x8(%eax),%edx
  802dd0:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd3:	01 c2                	add    %eax,%edx
  802dd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd8:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802ddb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dde:	8b 40 0c             	mov    0xc(%eax),%eax
  802de1:	2b 45 08             	sub    0x8(%ebp),%eax
  802de4:	89 c2                	mov    %eax,%edx
  802de6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de9:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802dec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802def:	eb 3b                	jmp    802e2c <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802df1:	a1 40 51 80 00       	mov    0x805140,%eax
  802df6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802df9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dfd:	74 07                	je     802e06 <alloc_block_NF+0x5a5>
  802dff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e02:	8b 00                	mov    (%eax),%eax
  802e04:	eb 05                	jmp    802e0b <alloc_block_NF+0x5aa>
  802e06:	b8 00 00 00 00       	mov    $0x0,%eax
  802e0b:	a3 40 51 80 00       	mov    %eax,0x805140
  802e10:	a1 40 51 80 00       	mov    0x805140,%eax
  802e15:	85 c0                	test   %eax,%eax
  802e17:	0f 85 2e fe ff ff    	jne    802c4b <alloc_block_NF+0x3ea>
  802e1d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e21:	0f 85 24 fe ff ff    	jne    802c4b <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802e27:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e2c:	c9                   	leave  
  802e2d:	c3                   	ret    

00802e2e <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802e2e:	55                   	push   %ebp
  802e2f:	89 e5                	mov    %esp,%ebp
  802e31:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802e34:	a1 38 51 80 00       	mov    0x805138,%eax
  802e39:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802e3c:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802e41:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802e44:	a1 38 51 80 00       	mov    0x805138,%eax
  802e49:	85 c0                	test   %eax,%eax
  802e4b:	74 14                	je     802e61 <insert_sorted_with_merge_freeList+0x33>
  802e4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e50:	8b 50 08             	mov    0x8(%eax),%edx
  802e53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e56:	8b 40 08             	mov    0x8(%eax),%eax
  802e59:	39 c2                	cmp    %eax,%edx
  802e5b:	0f 87 9b 01 00 00    	ja     802ffc <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802e61:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e65:	75 17                	jne    802e7e <insert_sorted_with_merge_freeList+0x50>
  802e67:	83 ec 04             	sub    $0x4,%esp
  802e6a:	68 5c 42 80 00       	push   $0x80425c
  802e6f:	68 38 01 00 00       	push   $0x138
  802e74:	68 7f 42 80 00       	push   $0x80427f
  802e79:	e8 29 d6 ff ff       	call   8004a7 <_panic>
  802e7e:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802e84:	8b 45 08             	mov    0x8(%ebp),%eax
  802e87:	89 10                	mov    %edx,(%eax)
  802e89:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8c:	8b 00                	mov    (%eax),%eax
  802e8e:	85 c0                	test   %eax,%eax
  802e90:	74 0d                	je     802e9f <insert_sorted_with_merge_freeList+0x71>
  802e92:	a1 38 51 80 00       	mov    0x805138,%eax
  802e97:	8b 55 08             	mov    0x8(%ebp),%edx
  802e9a:	89 50 04             	mov    %edx,0x4(%eax)
  802e9d:	eb 08                	jmp    802ea7 <insert_sorted_with_merge_freeList+0x79>
  802e9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ea7:	8b 45 08             	mov    0x8(%ebp),%eax
  802eaa:	a3 38 51 80 00       	mov    %eax,0x805138
  802eaf:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eb9:	a1 44 51 80 00       	mov    0x805144,%eax
  802ebe:	40                   	inc    %eax
  802ebf:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802ec4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ec8:	0f 84 a8 06 00 00    	je     803576 <insert_sorted_with_merge_freeList+0x748>
  802ece:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed1:	8b 50 08             	mov    0x8(%eax),%edx
  802ed4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed7:	8b 40 0c             	mov    0xc(%eax),%eax
  802eda:	01 c2                	add    %eax,%edx
  802edc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802edf:	8b 40 08             	mov    0x8(%eax),%eax
  802ee2:	39 c2                	cmp    %eax,%edx
  802ee4:	0f 85 8c 06 00 00    	jne    803576 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802eea:	8b 45 08             	mov    0x8(%ebp),%eax
  802eed:	8b 50 0c             	mov    0xc(%eax),%edx
  802ef0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ef3:	8b 40 0c             	mov    0xc(%eax),%eax
  802ef6:	01 c2                	add    %eax,%edx
  802ef8:	8b 45 08             	mov    0x8(%ebp),%eax
  802efb:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802efe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f02:	75 17                	jne    802f1b <insert_sorted_with_merge_freeList+0xed>
  802f04:	83 ec 04             	sub    $0x4,%esp
  802f07:	68 28 43 80 00       	push   $0x804328
  802f0c:	68 3c 01 00 00       	push   $0x13c
  802f11:	68 7f 42 80 00       	push   $0x80427f
  802f16:	e8 8c d5 ff ff       	call   8004a7 <_panic>
  802f1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f1e:	8b 00                	mov    (%eax),%eax
  802f20:	85 c0                	test   %eax,%eax
  802f22:	74 10                	je     802f34 <insert_sorted_with_merge_freeList+0x106>
  802f24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f27:	8b 00                	mov    (%eax),%eax
  802f29:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f2c:	8b 52 04             	mov    0x4(%edx),%edx
  802f2f:	89 50 04             	mov    %edx,0x4(%eax)
  802f32:	eb 0b                	jmp    802f3f <insert_sorted_with_merge_freeList+0x111>
  802f34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f37:	8b 40 04             	mov    0x4(%eax),%eax
  802f3a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f42:	8b 40 04             	mov    0x4(%eax),%eax
  802f45:	85 c0                	test   %eax,%eax
  802f47:	74 0f                	je     802f58 <insert_sorted_with_merge_freeList+0x12a>
  802f49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f4c:	8b 40 04             	mov    0x4(%eax),%eax
  802f4f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f52:	8b 12                	mov    (%edx),%edx
  802f54:	89 10                	mov    %edx,(%eax)
  802f56:	eb 0a                	jmp    802f62 <insert_sorted_with_merge_freeList+0x134>
  802f58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f5b:	8b 00                	mov    (%eax),%eax
  802f5d:	a3 38 51 80 00       	mov    %eax,0x805138
  802f62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f65:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f6e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f75:	a1 44 51 80 00       	mov    0x805144,%eax
  802f7a:	48                   	dec    %eax
  802f7b:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802f80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f83:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802f8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f8d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802f94:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f98:	75 17                	jne    802fb1 <insert_sorted_with_merge_freeList+0x183>
  802f9a:	83 ec 04             	sub    $0x4,%esp
  802f9d:	68 5c 42 80 00       	push   $0x80425c
  802fa2:	68 3f 01 00 00       	push   $0x13f
  802fa7:	68 7f 42 80 00       	push   $0x80427f
  802fac:	e8 f6 d4 ff ff       	call   8004a7 <_panic>
  802fb1:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802fb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fba:	89 10                	mov    %edx,(%eax)
  802fbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fbf:	8b 00                	mov    (%eax),%eax
  802fc1:	85 c0                	test   %eax,%eax
  802fc3:	74 0d                	je     802fd2 <insert_sorted_with_merge_freeList+0x1a4>
  802fc5:	a1 48 51 80 00       	mov    0x805148,%eax
  802fca:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fcd:	89 50 04             	mov    %edx,0x4(%eax)
  802fd0:	eb 08                	jmp    802fda <insert_sorted_with_merge_freeList+0x1ac>
  802fd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fd5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802fda:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fdd:	a3 48 51 80 00       	mov    %eax,0x805148
  802fe2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fe5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fec:	a1 54 51 80 00       	mov    0x805154,%eax
  802ff1:	40                   	inc    %eax
  802ff2:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802ff7:	e9 7a 05 00 00       	jmp    803576 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  802fff:	8b 50 08             	mov    0x8(%eax),%edx
  803002:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803005:	8b 40 08             	mov    0x8(%eax),%eax
  803008:	39 c2                	cmp    %eax,%edx
  80300a:	0f 82 14 01 00 00    	jb     803124 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  803010:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803013:	8b 50 08             	mov    0x8(%eax),%edx
  803016:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803019:	8b 40 0c             	mov    0xc(%eax),%eax
  80301c:	01 c2                	add    %eax,%edx
  80301e:	8b 45 08             	mov    0x8(%ebp),%eax
  803021:	8b 40 08             	mov    0x8(%eax),%eax
  803024:	39 c2                	cmp    %eax,%edx
  803026:	0f 85 90 00 00 00    	jne    8030bc <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  80302c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80302f:	8b 50 0c             	mov    0xc(%eax),%edx
  803032:	8b 45 08             	mov    0x8(%ebp),%eax
  803035:	8b 40 0c             	mov    0xc(%eax),%eax
  803038:	01 c2                	add    %eax,%edx
  80303a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80303d:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  803040:	8b 45 08             	mov    0x8(%ebp),%eax
  803043:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  80304a:	8b 45 08             	mov    0x8(%ebp),%eax
  80304d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803054:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803058:	75 17                	jne    803071 <insert_sorted_with_merge_freeList+0x243>
  80305a:	83 ec 04             	sub    $0x4,%esp
  80305d:	68 5c 42 80 00       	push   $0x80425c
  803062:	68 49 01 00 00       	push   $0x149
  803067:	68 7f 42 80 00       	push   $0x80427f
  80306c:	e8 36 d4 ff ff       	call   8004a7 <_panic>
  803071:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803077:	8b 45 08             	mov    0x8(%ebp),%eax
  80307a:	89 10                	mov    %edx,(%eax)
  80307c:	8b 45 08             	mov    0x8(%ebp),%eax
  80307f:	8b 00                	mov    (%eax),%eax
  803081:	85 c0                	test   %eax,%eax
  803083:	74 0d                	je     803092 <insert_sorted_with_merge_freeList+0x264>
  803085:	a1 48 51 80 00       	mov    0x805148,%eax
  80308a:	8b 55 08             	mov    0x8(%ebp),%edx
  80308d:	89 50 04             	mov    %edx,0x4(%eax)
  803090:	eb 08                	jmp    80309a <insert_sorted_with_merge_freeList+0x26c>
  803092:	8b 45 08             	mov    0x8(%ebp),%eax
  803095:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80309a:	8b 45 08             	mov    0x8(%ebp),%eax
  80309d:	a3 48 51 80 00       	mov    %eax,0x805148
  8030a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030ac:	a1 54 51 80 00       	mov    0x805154,%eax
  8030b1:	40                   	inc    %eax
  8030b2:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8030b7:	e9 bb 04 00 00       	jmp    803577 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  8030bc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030c0:	75 17                	jne    8030d9 <insert_sorted_with_merge_freeList+0x2ab>
  8030c2:	83 ec 04             	sub    $0x4,%esp
  8030c5:	68 d0 42 80 00       	push   $0x8042d0
  8030ca:	68 4c 01 00 00       	push   $0x14c
  8030cf:	68 7f 42 80 00       	push   $0x80427f
  8030d4:	e8 ce d3 ff ff       	call   8004a7 <_panic>
  8030d9:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8030df:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e2:	89 50 04             	mov    %edx,0x4(%eax)
  8030e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e8:	8b 40 04             	mov    0x4(%eax),%eax
  8030eb:	85 c0                	test   %eax,%eax
  8030ed:	74 0c                	je     8030fb <insert_sorted_with_merge_freeList+0x2cd>
  8030ef:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8030f4:	8b 55 08             	mov    0x8(%ebp),%edx
  8030f7:	89 10                	mov    %edx,(%eax)
  8030f9:	eb 08                	jmp    803103 <insert_sorted_with_merge_freeList+0x2d5>
  8030fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8030fe:	a3 38 51 80 00       	mov    %eax,0x805138
  803103:	8b 45 08             	mov    0x8(%ebp),%eax
  803106:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80310b:	8b 45 08             	mov    0x8(%ebp),%eax
  80310e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803114:	a1 44 51 80 00       	mov    0x805144,%eax
  803119:	40                   	inc    %eax
  80311a:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80311f:	e9 53 04 00 00       	jmp    803577 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803124:	a1 38 51 80 00       	mov    0x805138,%eax
  803129:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80312c:	e9 15 04 00 00       	jmp    803546 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  803131:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803134:	8b 00                	mov    (%eax),%eax
  803136:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803139:	8b 45 08             	mov    0x8(%ebp),%eax
  80313c:	8b 50 08             	mov    0x8(%eax),%edx
  80313f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803142:	8b 40 08             	mov    0x8(%eax),%eax
  803145:	39 c2                	cmp    %eax,%edx
  803147:	0f 86 f1 03 00 00    	jbe    80353e <insert_sorted_with_merge_freeList+0x710>
  80314d:	8b 45 08             	mov    0x8(%ebp),%eax
  803150:	8b 50 08             	mov    0x8(%eax),%edx
  803153:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803156:	8b 40 08             	mov    0x8(%eax),%eax
  803159:	39 c2                	cmp    %eax,%edx
  80315b:	0f 83 dd 03 00 00    	jae    80353e <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803161:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803164:	8b 50 08             	mov    0x8(%eax),%edx
  803167:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80316a:	8b 40 0c             	mov    0xc(%eax),%eax
  80316d:	01 c2                	add    %eax,%edx
  80316f:	8b 45 08             	mov    0x8(%ebp),%eax
  803172:	8b 40 08             	mov    0x8(%eax),%eax
  803175:	39 c2                	cmp    %eax,%edx
  803177:	0f 85 b9 01 00 00    	jne    803336 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80317d:	8b 45 08             	mov    0x8(%ebp),%eax
  803180:	8b 50 08             	mov    0x8(%eax),%edx
  803183:	8b 45 08             	mov    0x8(%ebp),%eax
  803186:	8b 40 0c             	mov    0xc(%eax),%eax
  803189:	01 c2                	add    %eax,%edx
  80318b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80318e:	8b 40 08             	mov    0x8(%eax),%eax
  803191:	39 c2                	cmp    %eax,%edx
  803193:	0f 85 0d 01 00 00    	jne    8032a6 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803199:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80319c:	8b 50 0c             	mov    0xc(%eax),%edx
  80319f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031a2:	8b 40 0c             	mov    0xc(%eax),%eax
  8031a5:	01 c2                	add    %eax,%edx
  8031a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031aa:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8031ad:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031b1:	75 17                	jne    8031ca <insert_sorted_with_merge_freeList+0x39c>
  8031b3:	83 ec 04             	sub    $0x4,%esp
  8031b6:	68 28 43 80 00       	push   $0x804328
  8031bb:	68 5c 01 00 00       	push   $0x15c
  8031c0:	68 7f 42 80 00       	push   $0x80427f
  8031c5:	e8 dd d2 ff ff       	call   8004a7 <_panic>
  8031ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031cd:	8b 00                	mov    (%eax),%eax
  8031cf:	85 c0                	test   %eax,%eax
  8031d1:	74 10                	je     8031e3 <insert_sorted_with_merge_freeList+0x3b5>
  8031d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d6:	8b 00                	mov    (%eax),%eax
  8031d8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031db:	8b 52 04             	mov    0x4(%edx),%edx
  8031de:	89 50 04             	mov    %edx,0x4(%eax)
  8031e1:	eb 0b                	jmp    8031ee <insert_sorted_with_merge_freeList+0x3c0>
  8031e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e6:	8b 40 04             	mov    0x4(%eax),%eax
  8031e9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f1:	8b 40 04             	mov    0x4(%eax),%eax
  8031f4:	85 c0                	test   %eax,%eax
  8031f6:	74 0f                	je     803207 <insert_sorted_with_merge_freeList+0x3d9>
  8031f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031fb:	8b 40 04             	mov    0x4(%eax),%eax
  8031fe:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803201:	8b 12                	mov    (%edx),%edx
  803203:	89 10                	mov    %edx,(%eax)
  803205:	eb 0a                	jmp    803211 <insert_sorted_with_merge_freeList+0x3e3>
  803207:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80320a:	8b 00                	mov    (%eax),%eax
  80320c:	a3 38 51 80 00       	mov    %eax,0x805138
  803211:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803214:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80321a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80321d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803224:	a1 44 51 80 00       	mov    0x805144,%eax
  803229:	48                   	dec    %eax
  80322a:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  80322f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803232:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803239:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80323c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803243:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803247:	75 17                	jne    803260 <insert_sorted_with_merge_freeList+0x432>
  803249:	83 ec 04             	sub    $0x4,%esp
  80324c:	68 5c 42 80 00       	push   $0x80425c
  803251:	68 5f 01 00 00       	push   $0x15f
  803256:	68 7f 42 80 00       	push   $0x80427f
  80325b:	e8 47 d2 ff ff       	call   8004a7 <_panic>
  803260:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803266:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803269:	89 10                	mov    %edx,(%eax)
  80326b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80326e:	8b 00                	mov    (%eax),%eax
  803270:	85 c0                	test   %eax,%eax
  803272:	74 0d                	je     803281 <insert_sorted_with_merge_freeList+0x453>
  803274:	a1 48 51 80 00       	mov    0x805148,%eax
  803279:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80327c:	89 50 04             	mov    %edx,0x4(%eax)
  80327f:	eb 08                	jmp    803289 <insert_sorted_with_merge_freeList+0x45b>
  803281:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803284:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803289:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80328c:	a3 48 51 80 00       	mov    %eax,0x805148
  803291:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803294:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80329b:	a1 54 51 80 00       	mov    0x805154,%eax
  8032a0:	40                   	inc    %eax
  8032a1:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  8032a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a9:	8b 50 0c             	mov    0xc(%eax),%edx
  8032ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8032af:	8b 40 0c             	mov    0xc(%eax),%eax
  8032b2:	01 c2                	add    %eax,%edx
  8032b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b7:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8032ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8032bd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8032c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8032ce:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032d2:	75 17                	jne    8032eb <insert_sorted_with_merge_freeList+0x4bd>
  8032d4:	83 ec 04             	sub    $0x4,%esp
  8032d7:	68 5c 42 80 00       	push   $0x80425c
  8032dc:	68 64 01 00 00       	push   $0x164
  8032e1:	68 7f 42 80 00       	push   $0x80427f
  8032e6:	e8 bc d1 ff ff       	call   8004a7 <_panic>
  8032eb:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8032f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f4:	89 10                	mov    %edx,(%eax)
  8032f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f9:	8b 00                	mov    (%eax),%eax
  8032fb:	85 c0                	test   %eax,%eax
  8032fd:	74 0d                	je     80330c <insert_sorted_with_merge_freeList+0x4de>
  8032ff:	a1 48 51 80 00       	mov    0x805148,%eax
  803304:	8b 55 08             	mov    0x8(%ebp),%edx
  803307:	89 50 04             	mov    %edx,0x4(%eax)
  80330a:	eb 08                	jmp    803314 <insert_sorted_with_merge_freeList+0x4e6>
  80330c:	8b 45 08             	mov    0x8(%ebp),%eax
  80330f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803314:	8b 45 08             	mov    0x8(%ebp),%eax
  803317:	a3 48 51 80 00       	mov    %eax,0x805148
  80331c:	8b 45 08             	mov    0x8(%ebp),%eax
  80331f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803326:	a1 54 51 80 00       	mov    0x805154,%eax
  80332b:	40                   	inc    %eax
  80332c:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803331:	e9 41 02 00 00       	jmp    803577 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803336:	8b 45 08             	mov    0x8(%ebp),%eax
  803339:	8b 50 08             	mov    0x8(%eax),%edx
  80333c:	8b 45 08             	mov    0x8(%ebp),%eax
  80333f:	8b 40 0c             	mov    0xc(%eax),%eax
  803342:	01 c2                	add    %eax,%edx
  803344:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803347:	8b 40 08             	mov    0x8(%eax),%eax
  80334a:	39 c2                	cmp    %eax,%edx
  80334c:	0f 85 7c 01 00 00    	jne    8034ce <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803352:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803356:	74 06                	je     80335e <insert_sorted_with_merge_freeList+0x530>
  803358:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80335c:	75 17                	jne    803375 <insert_sorted_with_merge_freeList+0x547>
  80335e:	83 ec 04             	sub    $0x4,%esp
  803361:	68 98 42 80 00       	push   $0x804298
  803366:	68 69 01 00 00       	push   $0x169
  80336b:	68 7f 42 80 00       	push   $0x80427f
  803370:	e8 32 d1 ff ff       	call   8004a7 <_panic>
  803375:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803378:	8b 50 04             	mov    0x4(%eax),%edx
  80337b:	8b 45 08             	mov    0x8(%ebp),%eax
  80337e:	89 50 04             	mov    %edx,0x4(%eax)
  803381:	8b 45 08             	mov    0x8(%ebp),%eax
  803384:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803387:	89 10                	mov    %edx,(%eax)
  803389:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80338c:	8b 40 04             	mov    0x4(%eax),%eax
  80338f:	85 c0                	test   %eax,%eax
  803391:	74 0d                	je     8033a0 <insert_sorted_with_merge_freeList+0x572>
  803393:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803396:	8b 40 04             	mov    0x4(%eax),%eax
  803399:	8b 55 08             	mov    0x8(%ebp),%edx
  80339c:	89 10                	mov    %edx,(%eax)
  80339e:	eb 08                	jmp    8033a8 <insert_sorted_with_merge_freeList+0x57a>
  8033a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a3:	a3 38 51 80 00       	mov    %eax,0x805138
  8033a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033ab:	8b 55 08             	mov    0x8(%ebp),%edx
  8033ae:	89 50 04             	mov    %edx,0x4(%eax)
  8033b1:	a1 44 51 80 00       	mov    0x805144,%eax
  8033b6:	40                   	inc    %eax
  8033b7:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  8033bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8033bf:	8b 50 0c             	mov    0xc(%eax),%edx
  8033c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033c5:	8b 40 0c             	mov    0xc(%eax),%eax
  8033c8:	01 c2                	add    %eax,%edx
  8033ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8033cd:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8033d0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8033d4:	75 17                	jne    8033ed <insert_sorted_with_merge_freeList+0x5bf>
  8033d6:	83 ec 04             	sub    $0x4,%esp
  8033d9:	68 28 43 80 00       	push   $0x804328
  8033de:	68 6b 01 00 00       	push   $0x16b
  8033e3:	68 7f 42 80 00       	push   $0x80427f
  8033e8:	e8 ba d0 ff ff       	call   8004a7 <_panic>
  8033ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033f0:	8b 00                	mov    (%eax),%eax
  8033f2:	85 c0                	test   %eax,%eax
  8033f4:	74 10                	je     803406 <insert_sorted_with_merge_freeList+0x5d8>
  8033f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033f9:	8b 00                	mov    (%eax),%eax
  8033fb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033fe:	8b 52 04             	mov    0x4(%edx),%edx
  803401:	89 50 04             	mov    %edx,0x4(%eax)
  803404:	eb 0b                	jmp    803411 <insert_sorted_with_merge_freeList+0x5e3>
  803406:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803409:	8b 40 04             	mov    0x4(%eax),%eax
  80340c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803411:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803414:	8b 40 04             	mov    0x4(%eax),%eax
  803417:	85 c0                	test   %eax,%eax
  803419:	74 0f                	je     80342a <insert_sorted_with_merge_freeList+0x5fc>
  80341b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80341e:	8b 40 04             	mov    0x4(%eax),%eax
  803421:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803424:	8b 12                	mov    (%edx),%edx
  803426:	89 10                	mov    %edx,(%eax)
  803428:	eb 0a                	jmp    803434 <insert_sorted_with_merge_freeList+0x606>
  80342a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80342d:	8b 00                	mov    (%eax),%eax
  80342f:	a3 38 51 80 00       	mov    %eax,0x805138
  803434:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803437:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80343d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803440:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803447:	a1 44 51 80 00       	mov    0x805144,%eax
  80344c:	48                   	dec    %eax
  80344d:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803452:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803455:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  80345c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80345f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803466:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80346a:	75 17                	jne    803483 <insert_sorted_with_merge_freeList+0x655>
  80346c:	83 ec 04             	sub    $0x4,%esp
  80346f:	68 5c 42 80 00       	push   $0x80425c
  803474:	68 6e 01 00 00       	push   $0x16e
  803479:	68 7f 42 80 00       	push   $0x80427f
  80347e:	e8 24 d0 ff ff       	call   8004a7 <_panic>
  803483:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803489:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80348c:	89 10                	mov    %edx,(%eax)
  80348e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803491:	8b 00                	mov    (%eax),%eax
  803493:	85 c0                	test   %eax,%eax
  803495:	74 0d                	je     8034a4 <insert_sorted_with_merge_freeList+0x676>
  803497:	a1 48 51 80 00       	mov    0x805148,%eax
  80349c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80349f:	89 50 04             	mov    %edx,0x4(%eax)
  8034a2:	eb 08                	jmp    8034ac <insert_sorted_with_merge_freeList+0x67e>
  8034a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034a7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8034ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034af:	a3 48 51 80 00       	mov    %eax,0x805148
  8034b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034b7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034be:	a1 54 51 80 00       	mov    0x805154,%eax
  8034c3:	40                   	inc    %eax
  8034c4:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8034c9:	e9 a9 00 00 00       	jmp    803577 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8034ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034d2:	74 06                	je     8034da <insert_sorted_with_merge_freeList+0x6ac>
  8034d4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034d8:	75 17                	jne    8034f1 <insert_sorted_with_merge_freeList+0x6c3>
  8034da:	83 ec 04             	sub    $0x4,%esp
  8034dd:	68 f4 42 80 00       	push   $0x8042f4
  8034e2:	68 73 01 00 00       	push   $0x173
  8034e7:	68 7f 42 80 00       	push   $0x80427f
  8034ec:	e8 b6 cf ff ff       	call   8004a7 <_panic>
  8034f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034f4:	8b 10                	mov    (%eax),%edx
  8034f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f9:	89 10                	mov    %edx,(%eax)
  8034fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8034fe:	8b 00                	mov    (%eax),%eax
  803500:	85 c0                	test   %eax,%eax
  803502:	74 0b                	je     80350f <insert_sorted_with_merge_freeList+0x6e1>
  803504:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803507:	8b 00                	mov    (%eax),%eax
  803509:	8b 55 08             	mov    0x8(%ebp),%edx
  80350c:	89 50 04             	mov    %edx,0x4(%eax)
  80350f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803512:	8b 55 08             	mov    0x8(%ebp),%edx
  803515:	89 10                	mov    %edx,(%eax)
  803517:	8b 45 08             	mov    0x8(%ebp),%eax
  80351a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80351d:	89 50 04             	mov    %edx,0x4(%eax)
  803520:	8b 45 08             	mov    0x8(%ebp),%eax
  803523:	8b 00                	mov    (%eax),%eax
  803525:	85 c0                	test   %eax,%eax
  803527:	75 08                	jne    803531 <insert_sorted_with_merge_freeList+0x703>
  803529:	8b 45 08             	mov    0x8(%ebp),%eax
  80352c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803531:	a1 44 51 80 00       	mov    0x805144,%eax
  803536:	40                   	inc    %eax
  803537:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  80353c:	eb 39                	jmp    803577 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80353e:	a1 40 51 80 00       	mov    0x805140,%eax
  803543:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803546:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80354a:	74 07                	je     803553 <insert_sorted_with_merge_freeList+0x725>
  80354c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80354f:	8b 00                	mov    (%eax),%eax
  803551:	eb 05                	jmp    803558 <insert_sorted_with_merge_freeList+0x72a>
  803553:	b8 00 00 00 00       	mov    $0x0,%eax
  803558:	a3 40 51 80 00       	mov    %eax,0x805140
  80355d:	a1 40 51 80 00       	mov    0x805140,%eax
  803562:	85 c0                	test   %eax,%eax
  803564:	0f 85 c7 fb ff ff    	jne    803131 <insert_sorted_with_merge_freeList+0x303>
  80356a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80356e:	0f 85 bd fb ff ff    	jne    803131 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803574:	eb 01                	jmp    803577 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803576:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803577:	90                   	nop
  803578:	c9                   	leave  
  803579:	c3                   	ret    

0080357a <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  80357a:	55                   	push   %ebp
  80357b:	89 e5                	mov    %esp,%ebp
  80357d:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803580:	8b 55 08             	mov    0x8(%ebp),%edx
  803583:	89 d0                	mov    %edx,%eax
  803585:	c1 e0 02             	shl    $0x2,%eax
  803588:	01 d0                	add    %edx,%eax
  80358a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803591:	01 d0                	add    %edx,%eax
  803593:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80359a:	01 d0                	add    %edx,%eax
  80359c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8035a3:	01 d0                	add    %edx,%eax
  8035a5:	c1 e0 04             	shl    $0x4,%eax
  8035a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8035ab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8035b2:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8035b5:	83 ec 0c             	sub    $0xc,%esp
  8035b8:	50                   	push   %eax
  8035b9:	e8 26 e7 ff ff       	call   801ce4 <sys_get_virtual_time>
  8035be:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8035c1:	eb 41                	jmp    803604 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8035c3:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8035c6:	83 ec 0c             	sub    $0xc,%esp
  8035c9:	50                   	push   %eax
  8035ca:	e8 15 e7 ff ff       	call   801ce4 <sys_get_virtual_time>
  8035cf:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8035d2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8035d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035d8:	29 c2                	sub    %eax,%edx
  8035da:	89 d0                	mov    %edx,%eax
  8035dc:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8035df:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035e5:	89 d1                	mov    %edx,%ecx
  8035e7:	29 c1                	sub    %eax,%ecx
  8035e9:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8035ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035ef:	39 c2                	cmp    %eax,%edx
  8035f1:	0f 97 c0             	seta   %al
  8035f4:	0f b6 c0             	movzbl %al,%eax
  8035f7:	29 c1                	sub    %eax,%ecx
  8035f9:	89 c8                	mov    %ecx,%eax
  8035fb:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8035fe:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803601:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  803604:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803607:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80360a:	72 b7                	jb     8035c3 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  80360c:	90                   	nop
  80360d:	c9                   	leave  
  80360e:	c3                   	ret    

0080360f <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  80360f:	55                   	push   %ebp
  803610:	89 e5                	mov    %esp,%ebp
  803612:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803615:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  80361c:	eb 03                	jmp    803621 <busy_wait+0x12>
  80361e:	ff 45 fc             	incl   -0x4(%ebp)
  803621:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803624:	3b 45 08             	cmp    0x8(%ebp),%eax
  803627:	72 f5                	jb     80361e <busy_wait+0xf>
	return i;
  803629:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80362c:	c9                   	leave  
  80362d:	c3                   	ret    
  80362e:	66 90                	xchg   %ax,%ax

00803630 <__udivdi3>:
  803630:	55                   	push   %ebp
  803631:	57                   	push   %edi
  803632:	56                   	push   %esi
  803633:	53                   	push   %ebx
  803634:	83 ec 1c             	sub    $0x1c,%esp
  803637:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80363b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80363f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803643:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803647:	89 ca                	mov    %ecx,%edx
  803649:	89 f8                	mov    %edi,%eax
  80364b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80364f:	85 f6                	test   %esi,%esi
  803651:	75 2d                	jne    803680 <__udivdi3+0x50>
  803653:	39 cf                	cmp    %ecx,%edi
  803655:	77 65                	ja     8036bc <__udivdi3+0x8c>
  803657:	89 fd                	mov    %edi,%ebp
  803659:	85 ff                	test   %edi,%edi
  80365b:	75 0b                	jne    803668 <__udivdi3+0x38>
  80365d:	b8 01 00 00 00       	mov    $0x1,%eax
  803662:	31 d2                	xor    %edx,%edx
  803664:	f7 f7                	div    %edi
  803666:	89 c5                	mov    %eax,%ebp
  803668:	31 d2                	xor    %edx,%edx
  80366a:	89 c8                	mov    %ecx,%eax
  80366c:	f7 f5                	div    %ebp
  80366e:	89 c1                	mov    %eax,%ecx
  803670:	89 d8                	mov    %ebx,%eax
  803672:	f7 f5                	div    %ebp
  803674:	89 cf                	mov    %ecx,%edi
  803676:	89 fa                	mov    %edi,%edx
  803678:	83 c4 1c             	add    $0x1c,%esp
  80367b:	5b                   	pop    %ebx
  80367c:	5e                   	pop    %esi
  80367d:	5f                   	pop    %edi
  80367e:	5d                   	pop    %ebp
  80367f:	c3                   	ret    
  803680:	39 ce                	cmp    %ecx,%esi
  803682:	77 28                	ja     8036ac <__udivdi3+0x7c>
  803684:	0f bd fe             	bsr    %esi,%edi
  803687:	83 f7 1f             	xor    $0x1f,%edi
  80368a:	75 40                	jne    8036cc <__udivdi3+0x9c>
  80368c:	39 ce                	cmp    %ecx,%esi
  80368e:	72 0a                	jb     80369a <__udivdi3+0x6a>
  803690:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803694:	0f 87 9e 00 00 00    	ja     803738 <__udivdi3+0x108>
  80369a:	b8 01 00 00 00       	mov    $0x1,%eax
  80369f:	89 fa                	mov    %edi,%edx
  8036a1:	83 c4 1c             	add    $0x1c,%esp
  8036a4:	5b                   	pop    %ebx
  8036a5:	5e                   	pop    %esi
  8036a6:	5f                   	pop    %edi
  8036a7:	5d                   	pop    %ebp
  8036a8:	c3                   	ret    
  8036a9:	8d 76 00             	lea    0x0(%esi),%esi
  8036ac:	31 ff                	xor    %edi,%edi
  8036ae:	31 c0                	xor    %eax,%eax
  8036b0:	89 fa                	mov    %edi,%edx
  8036b2:	83 c4 1c             	add    $0x1c,%esp
  8036b5:	5b                   	pop    %ebx
  8036b6:	5e                   	pop    %esi
  8036b7:	5f                   	pop    %edi
  8036b8:	5d                   	pop    %ebp
  8036b9:	c3                   	ret    
  8036ba:	66 90                	xchg   %ax,%ax
  8036bc:	89 d8                	mov    %ebx,%eax
  8036be:	f7 f7                	div    %edi
  8036c0:	31 ff                	xor    %edi,%edi
  8036c2:	89 fa                	mov    %edi,%edx
  8036c4:	83 c4 1c             	add    $0x1c,%esp
  8036c7:	5b                   	pop    %ebx
  8036c8:	5e                   	pop    %esi
  8036c9:	5f                   	pop    %edi
  8036ca:	5d                   	pop    %ebp
  8036cb:	c3                   	ret    
  8036cc:	bd 20 00 00 00       	mov    $0x20,%ebp
  8036d1:	89 eb                	mov    %ebp,%ebx
  8036d3:	29 fb                	sub    %edi,%ebx
  8036d5:	89 f9                	mov    %edi,%ecx
  8036d7:	d3 e6                	shl    %cl,%esi
  8036d9:	89 c5                	mov    %eax,%ebp
  8036db:	88 d9                	mov    %bl,%cl
  8036dd:	d3 ed                	shr    %cl,%ebp
  8036df:	89 e9                	mov    %ebp,%ecx
  8036e1:	09 f1                	or     %esi,%ecx
  8036e3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8036e7:	89 f9                	mov    %edi,%ecx
  8036e9:	d3 e0                	shl    %cl,%eax
  8036eb:	89 c5                	mov    %eax,%ebp
  8036ed:	89 d6                	mov    %edx,%esi
  8036ef:	88 d9                	mov    %bl,%cl
  8036f1:	d3 ee                	shr    %cl,%esi
  8036f3:	89 f9                	mov    %edi,%ecx
  8036f5:	d3 e2                	shl    %cl,%edx
  8036f7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8036fb:	88 d9                	mov    %bl,%cl
  8036fd:	d3 e8                	shr    %cl,%eax
  8036ff:	09 c2                	or     %eax,%edx
  803701:	89 d0                	mov    %edx,%eax
  803703:	89 f2                	mov    %esi,%edx
  803705:	f7 74 24 0c          	divl   0xc(%esp)
  803709:	89 d6                	mov    %edx,%esi
  80370b:	89 c3                	mov    %eax,%ebx
  80370d:	f7 e5                	mul    %ebp
  80370f:	39 d6                	cmp    %edx,%esi
  803711:	72 19                	jb     80372c <__udivdi3+0xfc>
  803713:	74 0b                	je     803720 <__udivdi3+0xf0>
  803715:	89 d8                	mov    %ebx,%eax
  803717:	31 ff                	xor    %edi,%edi
  803719:	e9 58 ff ff ff       	jmp    803676 <__udivdi3+0x46>
  80371e:	66 90                	xchg   %ax,%ax
  803720:	8b 54 24 08          	mov    0x8(%esp),%edx
  803724:	89 f9                	mov    %edi,%ecx
  803726:	d3 e2                	shl    %cl,%edx
  803728:	39 c2                	cmp    %eax,%edx
  80372a:	73 e9                	jae    803715 <__udivdi3+0xe5>
  80372c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80372f:	31 ff                	xor    %edi,%edi
  803731:	e9 40 ff ff ff       	jmp    803676 <__udivdi3+0x46>
  803736:	66 90                	xchg   %ax,%ax
  803738:	31 c0                	xor    %eax,%eax
  80373a:	e9 37 ff ff ff       	jmp    803676 <__udivdi3+0x46>
  80373f:	90                   	nop

00803740 <__umoddi3>:
  803740:	55                   	push   %ebp
  803741:	57                   	push   %edi
  803742:	56                   	push   %esi
  803743:	53                   	push   %ebx
  803744:	83 ec 1c             	sub    $0x1c,%esp
  803747:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80374b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80374f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803753:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803757:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80375b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80375f:	89 f3                	mov    %esi,%ebx
  803761:	89 fa                	mov    %edi,%edx
  803763:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803767:	89 34 24             	mov    %esi,(%esp)
  80376a:	85 c0                	test   %eax,%eax
  80376c:	75 1a                	jne    803788 <__umoddi3+0x48>
  80376e:	39 f7                	cmp    %esi,%edi
  803770:	0f 86 a2 00 00 00    	jbe    803818 <__umoddi3+0xd8>
  803776:	89 c8                	mov    %ecx,%eax
  803778:	89 f2                	mov    %esi,%edx
  80377a:	f7 f7                	div    %edi
  80377c:	89 d0                	mov    %edx,%eax
  80377e:	31 d2                	xor    %edx,%edx
  803780:	83 c4 1c             	add    $0x1c,%esp
  803783:	5b                   	pop    %ebx
  803784:	5e                   	pop    %esi
  803785:	5f                   	pop    %edi
  803786:	5d                   	pop    %ebp
  803787:	c3                   	ret    
  803788:	39 f0                	cmp    %esi,%eax
  80378a:	0f 87 ac 00 00 00    	ja     80383c <__umoddi3+0xfc>
  803790:	0f bd e8             	bsr    %eax,%ebp
  803793:	83 f5 1f             	xor    $0x1f,%ebp
  803796:	0f 84 ac 00 00 00    	je     803848 <__umoddi3+0x108>
  80379c:	bf 20 00 00 00       	mov    $0x20,%edi
  8037a1:	29 ef                	sub    %ebp,%edi
  8037a3:	89 fe                	mov    %edi,%esi
  8037a5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8037a9:	89 e9                	mov    %ebp,%ecx
  8037ab:	d3 e0                	shl    %cl,%eax
  8037ad:	89 d7                	mov    %edx,%edi
  8037af:	89 f1                	mov    %esi,%ecx
  8037b1:	d3 ef                	shr    %cl,%edi
  8037b3:	09 c7                	or     %eax,%edi
  8037b5:	89 e9                	mov    %ebp,%ecx
  8037b7:	d3 e2                	shl    %cl,%edx
  8037b9:	89 14 24             	mov    %edx,(%esp)
  8037bc:	89 d8                	mov    %ebx,%eax
  8037be:	d3 e0                	shl    %cl,%eax
  8037c0:	89 c2                	mov    %eax,%edx
  8037c2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8037c6:	d3 e0                	shl    %cl,%eax
  8037c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8037cc:	8b 44 24 08          	mov    0x8(%esp),%eax
  8037d0:	89 f1                	mov    %esi,%ecx
  8037d2:	d3 e8                	shr    %cl,%eax
  8037d4:	09 d0                	or     %edx,%eax
  8037d6:	d3 eb                	shr    %cl,%ebx
  8037d8:	89 da                	mov    %ebx,%edx
  8037da:	f7 f7                	div    %edi
  8037dc:	89 d3                	mov    %edx,%ebx
  8037de:	f7 24 24             	mull   (%esp)
  8037e1:	89 c6                	mov    %eax,%esi
  8037e3:	89 d1                	mov    %edx,%ecx
  8037e5:	39 d3                	cmp    %edx,%ebx
  8037e7:	0f 82 87 00 00 00    	jb     803874 <__umoddi3+0x134>
  8037ed:	0f 84 91 00 00 00    	je     803884 <__umoddi3+0x144>
  8037f3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8037f7:	29 f2                	sub    %esi,%edx
  8037f9:	19 cb                	sbb    %ecx,%ebx
  8037fb:	89 d8                	mov    %ebx,%eax
  8037fd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803801:	d3 e0                	shl    %cl,%eax
  803803:	89 e9                	mov    %ebp,%ecx
  803805:	d3 ea                	shr    %cl,%edx
  803807:	09 d0                	or     %edx,%eax
  803809:	89 e9                	mov    %ebp,%ecx
  80380b:	d3 eb                	shr    %cl,%ebx
  80380d:	89 da                	mov    %ebx,%edx
  80380f:	83 c4 1c             	add    $0x1c,%esp
  803812:	5b                   	pop    %ebx
  803813:	5e                   	pop    %esi
  803814:	5f                   	pop    %edi
  803815:	5d                   	pop    %ebp
  803816:	c3                   	ret    
  803817:	90                   	nop
  803818:	89 fd                	mov    %edi,%ebp
  80381a:	85 ff                	test   %edi,%edi
  80381c:	75 0b                	jne    803829 <__umoddi3+0xe9>
  80381e:	b8 01 00 00 00       	mov    $0x1,%eax
  803823:	31 d2                	xor    %edx,%edx
  803825:	f7 f7                	div    %edi
  803827:	89 c5                	mov    %eax,%ebp
  803829:	89 f0                	mov    %esi,%eax
  80382b:	31 d2                	xor    %edx,%edx
  80382d:	f7 f5                	div    %ebp
  80382f:	89 c8                	mov    %ecx,%eax
  803831:	f7 f5                	div    %ebp
  803833:	89 d0                	mov    %edx,%eax
  803835:	e9 44 ff ff ff       	jmp    80377e <__umoddi3+0x3e>
  80383a:	66 90                	xchg   %ax,%ax
  80383c:	89 c8                	mov    %ecx,%eax
  80383e:	89 f2                	mov    %esi,%edx
  803840:	83 c4 1c             	add    $0x1c,%esp
  803843:	5b                   	pop    %ebx
  803844:	5e                   	pop    %esi
  803845:	5f                   	pop    %edi
  803846:	5d                   	pop    %ebp
  803847:	c3                   	ret    
  803848:	3b 04 24             	cmp    (%esp),%eax
  80384b:	72 06                	jb     803853 <__umoddi3+0x113>
  80384d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803851:	77 0f                	ja     803862 <__umoddi3+0x122>
  803853:	89 f2                	mov    %esi,%edx
  803855:	29 f9                	sub    %edi,%ecx
  803857:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80385b:	89 14 24             	mov    %edx,(%esp)
  80385e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803862:	8b 44 24 04          	mov    0x4(%esp),%eax
  803866:	8b 14 24             	mov    (%esp),%edx
  803869:	83 c4 1c             	add    $0x1c,%esp
  80386c:	5b                   	pop    %ebx
  80386d:	5e                   	pop    %esi
  80386e:	5f                   	pop    %edi
  80386f:	5d                   	pop    %ebp
  803870:	c3                   	ret    
  803871:	8d 76 00             	lea    0x0(%esi),%esi
  803874:	2b 04 24             	sub    (%esp),%eax
  803877:	19 fa                	sbb    %edi,%edx
  803879:	89 d1                	mov    %edx,%ecx
  80387b:	89 c6                	mov    %eax,%esi
  80387d:	e9 71 ff ff ff       	jmp    8037f3 <__umoddi3+0xb3>
  803882:	66 90                	xchg   %ax,%ax
  803884:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803888:	72 ea                	jb     803874 <__umoddi3+0x134>
  80388a:	89 d9                	mov    %ebx,%ecx
  80388c:	e9 62 ff ff ff       	jmp    8037f3 <__umoddi3+0xb3>
