
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
  80008d:	68 60 38 80 00       	push   $0x803860
  800092:	6a 13                	push   $0x13
  800094:	68 7c 38 80 00       	push   $0x80387c
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
  8000ab:	e8 bb 18 00 00       	call   80196b <sys_calculate_free_frames>
  8000b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	x = smalloc("x", 4, 0);
  8000b3:	83 ec 04             	sub    $0x4,%esp
  8000b6:	6a 00                	push   $0x0
  8000b8:	6a 04                	push   $0x4
  8000ba:	68 97 38 80 00       	push   $0x803897
  8000bf:	e8 67 16 00 00       	call   80172b <smalloc>
  8000c4:	83 c4 10             	add    $0x10,%esp
  8000c7:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if (x != (uint32*)USER_HEAP_START) panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8000ca:	81 7d e8 00 00 00 80 	cmpl   $0x80000000,-0x18(%ebp)
  8000d1:	74 14                	je     8000e7 <_main+0xaf>
  8000d3:	83 ec 04             	sub    $0x4,%esp
  8000d6:	68 9c 38 80 00       	push   $0x80389c
  8000db:	6a 1e                	push   $0x1e
  8000dd:	68 7c 38 80 00       	push   $0x80387c
  8000e2:	e8 c0 03 00 00       	call   8004a7 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Create(): Wrong allocation- make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8000e7:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000ea:	e8 7c 18 00 00       	call   80196b <sys_calculate_free_frames>
  8000ef:	29 c3                	sub    %eax,%ebx
  8000f1:	89 d8                	mov    %ebx,%eax
  8000f3:	83 f8 04             	cmp    $0x4,%eax
  8000f6:	74 14                	je     80010c <_main+0xd4>
  8000f8:	83 ec 04             	sub    $0x4,%esp
  8000fb:	68 00 39 80 00       	push   $0x803900
  800100:	6a 1f                	push   $0x1f
  800102:	68 7c 38 80 00       	push   $0x80387c
  800107:	e8 9b 03 00 00       	call   8004a7 <_panic>

	//y: Readonly
	freeFrames = sys_calculate_free_frames() ;
  80010c:	e8 5a 18 00 00       	call   80196b <sys_calculate_free_frames>
  800111:	89 45 ec             	mov    %eax,-0x14(%ebp)
	y = smalloc("y", 4, 0);
  800114:	83 ec 04             	sub    $0x4,%esp
  800117:	6a 00                	push   $0x0
  800119:	6a 04                	push   $0x4
  80011b:	68 88 39 80 00       	push   $0x803988
  800120:	e8 06 16 00 00       	call   80172b <smalloc>
  800125:	83 c4 10             	add    $0x10,%esp
  800128:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (y != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  80012b:	81 7d e4 00 10 00 80 	cmpl   $0x80001000,-0x1c(%ebp)
  800132:	74 14                	je     800148 <_main+0x110>
  800134:	83 ec 04             	sub    $0x4,%esp
  800137:	68 9c 38 80 00       	push   $0x80389c
  80013c:	6a 24                	push   $0x24
  80013e:	68 7c 38 80 00       	push   $0x80387c
  800143:	e8 5f 03 00 00       	call   8004a7 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1+0+2) panic("Create(): Wrong allocation- make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800148:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  80014b:	e8 1b 18 00 00       	call   80196b <sys_calculate_free_frames>
  800150:	29 c3                	sub    %eax,%ebx
  800152:	89 d8                	mov    %ebx,%eax
  800154:	83 f8 03             	cmp    $0x3,%eax
  800157:	74 14                	je     80016d <_main+0x135>
  800159:	83 ec 04             	sub    $0x4,%esp
  80015c:	68 00 39 80 00       	push   $0x803900
  800161:	6a 25                	push   $0x25
  800163:	68 7c 38 80 00       	push   $0x80387c
  800168:	e8 3a 03 00 00       	call   8004a7 <_panic>

	//z: Writable
	freeFrames = sys_calculate_free_frames() ;
  80016d:	e8 f9 17 00 00       	call   80196b <sys_calculate_free_frames>
  800172:	89 45 ec             	mov    %eax,-0x14(%ebp)
	z = smalloc("z", 4, 1);
  800175:	83 ec 04             	sub    $0x4,%esp
  800178:	6a 01                	push   $0x1
  80017a:	6a 04                	push   $0x4
  80017c:	68 8a 39 80 00       	push   $0x80398a
  800181:	e8 a5 15 00 00       	call   80172b <smalloc>
  800186:	83 c4 10             	add    $0x10,%esp
  800189:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (z != (uint32*)(USER_HEAP_START + 2 * PAGE_SIZE)) panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  80018c:	81 7d e0 00 20 00 80 	cmpl   $0x80002000,-0x20(%ebp)
  800193:	74 14                	je     8001a9 <_main+0x171>
  800195:	83 ec 04             	sub    $0x4,%esp
  800198:	68 9c 38 80 00       	push   $0x80389c
  80019d:	6a 2a                	push   $0x2a
  80019f:	68 7c 38 80 00       	push   $0x80387c
  8001a4:	e8 fe 02 00 00       	call   8004a7 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1+0+2) panic("Create(): Wrong allocation- make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8001a9:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8001ac:	e8 ba 17 00 00       	call   80196b <sys_calculate_free_frames>
  8001b1:	29 c3                	sub    %eax,%ebx
  8001b3:	89 d8                	mov    %ebx,%eax
  8001b5:	83 f8 03             	cmp    $0x3,%eax
  8001b8:	74 14                	je     8001ce <_main+0x196>
  8001ba:	83 ec 04             	sub    $0x4,%esp
  8001bd:	68 00 39 80 00       	push   $0x803900
  8001c2:	6a 2b                	push   $0x2b
  8001c4:	68 7c 38 80 00       	push   $0x80387c
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
  800203:	68 8c 39 80 00       	push   $0x80398c
  800208:	e8 d0 19 00 00       	call   801bdd <sys_create_env>
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
  800236:	68 8c 39 80 00       	push   $0x80398c
  80023b:	e8 9d 19 00 00       	call   801bdd <sys_create_env>
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
  800269:	68 8c 39 80 00       	push   $0x80398c
  80026e:	e8 6a 19 00 00       	call   801bdd <sys_create_env>
  800273:	83 c4 10             	add    $0x10,%esp
  800276:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	//to check that the slave environments completed successfully
	rsttst();
  800279:	e8 ab 1a 00 00       	call   801d29 <rsttst>

	sys_run_env(id1);
  80027e:	83 ec 0c             	sub    $0xc,%esp
  800281:	ff 75 dc             	pushl  -0x24(%ebp)
  800284:	e8 72 19 00 00       	call   801bfb <sys_run_env>
  800289:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id2);
  80028c:	83 ec 0c             	sub    $0xc,%esp
  80028f:	ff 75 d8             	pushl  -0x28(%ebp)
  800292:	e8 64 19 00 00       	call   801bfb <sys_run_env>
  800297:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id3);
  80029a:	83 ec 0c             	sub    $0xc,%esp
  80029d:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002a0:	e8 56 19 00 00       	call   801bfb <sys_run_env>
  8002a5:	83 c4 10             	add    $0x10,%esp

	env_sleep(12000) ;
  8002a8:	83 ec 0c             	sub    $0xc,%esp
  8002ab:	68 e0 2e 00 00       	push   $0x2ee0
  8002b0:	e8 78 32 00 00       	call   80352d <env_sleep>
  8002b5:	83 c4 10             	add    $0x10,%esp

	//to ensure that the slave environments completed successfully
	if (gettst()!=3) panic("test failed");
  8002b8:	e8 e6 1a 00 00       	call   801da3 <gettst>
  8002bd:	83 f8 03             	cmp    $0x3,%eax
  8002c0:	74 14                	je     8002d6 <_main+0x29e>
  8002c2:	83 ec 04             	sub    $0x4,%esp
  8002c5:	68 97 39 80 00       	push   $0x803997
  8002ca:	6a 3f                	push   $0x3f
  8002cc:	68 7c 38 80 00       	push   $0x80387c
  8002d1:	e8 d1 01 00 00       	call   8004a7 <_panic>


	if (*z != 30)
  8002d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002d9:	8b 00                	mov    (%eax),%eax
  8002db:	83 f8 1e             	cmp    $0x1e,%eax
  8002de:	74 14                	je     8002f4 <_main+0x2bc>
		panic("Error!! Please check the creation (or the getting) of shared variables!!\n\n\n");
  8002e0:	83 ec 04             	sub    $0x4,%esp
  8002e3:	68 a4 39 80 00       	push   $0x8039a4
  8002e8:	6a 43                	push   $0x43
  8002ea:	68 7c 38 80 00       	push   $0x80387c
  8002ef:	e8 b3 01 00 00       	call   8004a7 <_panic>
	else
		cprintf("Congratulations!! Test of Shared Variables [Create & Get] [2] completed successfully!!\n\n\n");
  8002f4:	83 ec 0c             	sub    $0xc,%esp
  8002f7:	68 f0 39 80 00       	push   $0x8039f0
  8002fc:	e8 5a 04 00 00       	call   80075b <cprintf>
  800301:	83 c4 10             	add    $0x10,%esp

	cprintf("Now, ILLEGAL MEM ACCESS should be occur, due to attempting to write a ReadOnly variable\n\n\n");
  800304:	83 ec 0c             	sub    $0xc,%esp
  800307:	68 4c 3a 80 00       	push   $0x803a4c
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
  800337:	68 a7 3a 80 00       	push   $0x803aa7
  80033c:	e8 9c 18 00 00       	call   801bdd <sys_create_env>
  800341:	83 c4 10             	add    $0x10,%esp
  800344:	89 45 dc             	mov    %eax,-0x24(%ebp)

	env_sleep(3000) ;
  800347:	83 ec 0c             	sub    $0xc,%esp
  80034a:	68 b8 0b 00 00       	push   $0xbb8
  80034f:	e8 d9 31 00 00       	call   80352d <env_sleep>
  800354:	83 c4 10             	add    $0x10,%esp

	sys_run_env(id1);
  800357:	83 ec 0c             	sub    $0xc,%esp
  80035a:	ff 75 dc             	pushl  -0x24(%ebp)
  80035d:	e8 99 18 00 00       	call   801bfb <sys_run_env>
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
  800371:	e8 d5 18 00 00       	call   801c4b <sys_getenvindex>
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
  8003dc:	e8 77 16 00 00       	call   801a58 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8003e1:	83 ec 0c             	sub    $0xc,%esp
  8003e4:	68 cc 3a 80 00       	push   $0x803acc
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
  80040c:	68 f4 3a 80 00       	push   $0x803af4
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
  80043d:	68 1c 3b 80 00       	push   $0x803b1c
  800442:	e8 14 03 00 00       	call   80075b <cprintf>
  800447:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80044a:	a1 20 50 80 00       	mov    0x805020,%eax
  80044f:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800455:	83 ec 08             	sub    $0x8,%esp
  800458:	50                   	push   %eax
  800459:	68 74 3b 80 00       	push   $0x803b74
  80045e:	e8 f8 02 00 00       	call   80075b <cprintf>
  800463:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800466:	83 ec 0c             	sub    $0xc,%esp
  800469:	68 cc 3a 80 00       	push   $0x803acc
  80046e:	e8 e8 02 00 00       	call   80075b <cprintf>
  800473:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800476:	e8 f7 15 00 00       	call   801a72 <sys_enable_interrupt>

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
  80048e:	e8 84 17 00 00       	call   801c17 <sys_destroy_env>
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
  80049f:	e8 d9 17 00 00       	call   801c7d <sys_exit_env>
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
  8004c8:	68 88 3b 80 00       	push   $0x803b88
  8004cd:	e8 89 02 00 00       	call   80075b <cprintf>
  8004d2:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8004d5:	a1 00 50 80 00       	mov    0x805000,%eax
  8004da:	ff 75 0c             	pushl  0xc(%ebp)
  8004dd:	ff 75 08             	pushl  0x8(%ebp)
  8004e0:	50                   	push   %eax
  8004e1:	68 8d 3b 80 00       	push   $0x803b8d
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
  800505:	68 a9 3b 80 00       	push   $0x803ba9
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
  800531:	68 ac 3b 80 00       	push   $0x803bac
  800536:	6a 26                	push   $0x26
  800538:	68 f8 3b 80 00       	push   $0x803bf8
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
  800603:	68 04 3c 80 00       	push   $0x803c04
  800608:	6a 3a                	push   $0x3a
  80060a:	68 f8 3b 80 00       	push   $0x803bf8
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
  800673:	68 58 3c 80 00       	push   $0x803c58
  800678:	6a 44                	push   $0x44
  80067a:	68 f8 3b 80 00       	push   $0x803bf8
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
  8006cd:	e8 d8 11 00 00       	call   8018aa <sys_cputs>
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
  800744:	e8 61 11 00 00       	call   8018aa <sys_cputs>
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
  80078e:	e8 c5 12 00 00       	call   801a58 <sys_disable_interrupt>
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
  8007ae:	e8 bf 12 00 00       	call   801a72 <sys_enable_interrupt>
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
  8007f8:	e8 e7 2d 00 00       	call   8035e4 <__udivdi3>
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
  800848:	e8 a7 2e 00 00       	call   8036f4 <__umoddi3>
  80084d:	83 c4 10             	add    $0x10,%esp
  800850:	05 d4 3e 80 00       	add    $0x803ed4,%eax
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
  8009a3:	8b 04 85 f8 3e 80 00 	mov    0x803ef8(,%eax,4),%eax
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
  800a84:	8b 34 9d 40 3d 80 00 	mov    0x803d40(,%ebx,4),%esi
  800a8b:	85 f6                	test   %esi,%esi
  800a8d:	75 19                	jne    800aa8 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a8f:	53                   	push   %ebx
  800a90:	68 e5 3e 80 00       	push   $0x803ee5
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
  800aa9:	68 ee 3e 80 00       	push   $0x803eee
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
  800ad6:	be f1 3e 80 00       	mov    $0x803ef1,%esi
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
  8014fc:	68 50 40 80 00       	push   $0x804050
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
  8015cc:	e8 1d 04 00 00       	call   8019ee <sys_allocate_chunk>
  8015d1:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8015d4:	a1 20 51 80 00       	mov    0x805120,%eax
  8015d9:	83 ec 0c             	sub    $0xc,%esp
  8015dc:	50                   	push   %eax
  8015dd:	e8 92 0a 00 00       	call   802074 <initialize_MemBlocksList>
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
  80160a:	68 75 40 80 00       	push   $0x804075
  80160f:	6a 33                	push   $0x33
  801611:	68 93 40 80 00       	push   $0x804093
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
  801689:	68 a0 40 80 00       	push   $0x8040a0
  80168e:	6a 34                	push   $0x34
  801690:	68 93 40 80 00       	push   $0x804093
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
  8016e6:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016e9:	e8 f7 fd ff ff       	call   8014e5 <InitializeUHeap>
	if (size == 0) return NULL ;
  8016ee:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8016f2:	75 07                	jne    8016fb <malloc+0x18>
  8016f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8016f9:	eb 14                	jmp    80170f <malloc+0x2c>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  8016fb:	83 ec 04             	sub    $0x4,%esp
  8016fe:	68 c4 40 80 00       	push   $0x8040c4
  801703:	6a 46                	push   $0x46
  801705:	68 93 40 80 00       	push   $0x804093
  80170a:	e8 98 ed ff ff       	call   8004a7 <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  80170f:	c9                   	leave  
  801710:	c3                   	ret    

00801711 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801711:	55                   	push   %ebp
  801712:	89 e5                	mov    %esp,%ebp
  801714:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801717:	83 ec 04             	sub    $0x4,%esp
  80171a:	68 ec 40 80 00       	push   $0x8040ec
  80171f:	6a 61                	push   $0x61
  801721:	68 93 40 80 00       	push   $0x804093
  801726:	e8 7c ed ff ff       	call   8004a7 <_panic>

0080172b <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80172b:	55                   	push   %ebp
  80172c:	89 e5                	mov    %esp,%ebp
  80172e:	83 ec 38             	sub    $0x38,%esp
  801731:	8b 45 10             	mov    0x10(%ebp),%eax
  801734:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801737:	e8 a9 fd ff ff       	call   8014e5 <InitializeUHeap>
	if (size == 0) return NULL ;
  80173c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801740:	75 07                	jne    801749 <smalloc+0x1e>
  801742:	b8 00 00 00 00       	mov    $0x0,%eax
  801747:	eb 7c                	jmp    8017c5 <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801749:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801750:	8b 55 0c             	mov    0xc(%ebp),%edx
  801753:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801756:	01 d0                	add    %edx,%eax
  801758:	48                   	dec    %eax
  801759:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80175c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80175f:	ba 00 00 00 00       	mov    $0x0,%edx
  801764:	f7 75 f0             	divl   -0x10(%ebp)
  801767:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80176a:	29 d0                	sub    %edx,%eax
  80176c:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  80176f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801776:	e8 41 06 00 00       	call   801dbc <sys_isUHeapPlacementStrategyFIRSTFIT>
  80177b:	85 c0                	test   %eax,%eax
  80177d:	74 11                	je     801790 <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  80177f:	83 ec 0c             	sub    $0xc,%esp
  801782:	ff 75 e8             	pushl  -0x18(%ebp)
  801785:	e8 ac 0c 00 00       	call   802436 <alloc_block_FF>
  80178a:	83 c4 10             	add    $0x10,%esp
  80178d:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  801790:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801794:	74 2a                	je     8017c0 <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801796:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801799:	8b 40 08             	mov    0x8(%eax),%eax
  80179c:	89 c2                	mov    %eax,%edx
  80179e:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8017a2:	52                   	push   %edx
  8017a3:	50                   	push   %eax
  8017a4:	ff 75 0c             	pushl  0xc(%ebp)
  8017a7:	ff 75 08             	pushl  0x8(%ebp)
  8017aa:	e8 92 03 00 00       	call   801b41 <sys_createSharedObject>
  8017af:	83 c4 10             	add    $0x10,%esp
  8017b2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  8017b5:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  8017b9:	74 05                	je     8017c0 <smalloc+0x95>
			return (void*)virtual_address;
  8017bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017be:	eb 05                	jmp    8017c5 <smalloc+0x9a>
	}
	return NULL;
  8017c0:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8017c5:	c9                   	leave  
  8017c6:	c3                   	ret    

008017c7 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8017c7:	55                   	push   %ebp
  8017c8:	89 e5                	mov    %esp,%ebp
  8017ca:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017cd:	e8 13 fd ff ff       	call   8014e5 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8017d2:	83 ec 04             	sub    $0x4,%esp
  8017d5:	68 10 41 80 00       	push   $0x804110
  8017da:	68 a2 00 00 00       	push   $0xa2
  8017df:	68 93 40 80 00       	push   $0x804093
  8017e4:	e8 be ec ff ff       	call   8004a7 <_panic>

008017e9 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8017e9:	55                   	push   %ebp
  8017ea:	89 e5                	mov    %esp,%ebp
  8017ec:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017ef:	e8 f1 fc ff ff       	call   8014e5 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8017f4:	83 ec 04             	sub    $0x4,%esp
  8017f7:	68 34 41 80 00       	push   $0x804134
  8017fc:	68 e6 00 00 00       	push   $0xe6
  801801:	68 93 40 80 00       	push   $0x804093
  801806:	e8 9c ec ff ff       	call   8004a7 <_panic>

0080180b <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80180b:	55                   	push   %ebp
  80180c:	89 e5                	mov    %esp,%ebp
  80180e:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801811:	83 ec 04             	sub    $0x4,%esp
  801814:	68 5c 41 80 00       	push   $0x80415c
  801819:	68 fa 00 00 00       	push   $0xfa
  80181e:	68 93 40 80 00       	push   $0x804093
  801823:	e8 7f ec ff ff       	call   8004a7 <_panic>

00801828 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801828:	55                   	push   %ebp
  801829:	89 e5                	mov    %esp,%ebp
  80182b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80182e:	83 ec 04             	sub    $0x4,%esp
  801831:	68 80 41 80 00       	push   $0x804180
  801836:	68 05 01 00 00       	push   $0x105
  80183b:	68 93 40 80 00       	push   $0x804093
  801840:	e8 62 ec ff ff       	call   8004a7 <_panic>

00801845 <shrink>:

}
void shrink(uint32 newSize)
{
  801845:	55                   	push   %ebp
  801846:	89 e5                	mov    %esp,%ebp
  801848:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80184b:	83 ec 04             	sub    $0x4,%esp
  80184e:	68 80 41 80 00       	push   $0x804180
  801853:	68 0a 01 00 00       	push   $0x10a
  801858:	68 93 40 80 00       	push   $0x804093
  80185d:	e8 45 ec ff ff       	call   8004a7 <_panic>

00801862 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801862:	55                   	push   %ebp
  801863:	89 e5                	mov    %esp,%ebp
  801865:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801868:	83 ec 04             	sub    $0x4,%esp
  80186b:	68 80 41 80 00       	push   $0x804180
  801870:	68 0f 01 00 00       	push   $0x10f
  801875:	68 93 40 80 00       	push   $0x804093
  80187a:	e8 28 ec ff ff       	call   8004a7 <_panic>

0080187f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80187f:	55                   	push   %ebp
  801880:	89 e5                	mov    %esp,%ebp
  801882:	57                   	push   %edi
  801883:	56                   	push   %esi
  801884:	53                   	push   %ebx
  801885:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801888:	8b 45 08             	mov    0x8(%ebp),%eax
  80188b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80188e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801891:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801894:	8b 7d 18             	mov    0x18(%ebp),%edi
  801897:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80189a:	cd 30                	int    $0x30
  80189c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80189f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018a2:	83 c4 10             	add    $0x10,%esp
  8018a5:	5b                   	pop    %ebx
  8018a6:	5e                   	pop    %esi
  8018a7:	5f                   	pop    %edi
  8018a8:	5d                   	pop    %ebp
  8018a9:	c3                   	ret    

008018aa <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8018aa:	55                   	push   %ebp
  8018ab:	89 e5                	mov    %esp,%ebp
  8018ad:	83 ec 04             	sub    $0x4,%esp
  8018b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8018b3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8018b6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bd:	6a 00                	push   $0x0
  8018bf:	6a 00                	push   $0x0
  8018c1:	52                   	push   %edx
  8018c2:	ff 75 0c             	pushl  0xc(%ebp)
  8018c5:	50                   	push   %eax
  8018c6:	6a 00                	push   $0x0
  8018c8:	e8 b2 ff ff ff       	call   80187f <syscall>
  8018cd:	83 c4 18             	add    $0x18,%esp
}
  8018d0:	90                   	nop
  8018d1:	c9                   	leave  
  8018d2:	c3                   	ret    

008018d3 <sys_cgetc>:

int
sys_cgetc(void)
{
  8018d3:	55                   	push   %ebp
  8018d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8018d6:	6a 00                	push   $0x0
  8018d8:	6a 00                	push   $0x0
  8018da:	6a 00                	push   $0x0
  8018dc:	6a 00                	push   $0x0
  8018de:	6a 00                	push   $0x0
  8018e0:	6a 01                	push   $0x1
  8018e2:	e8 98 ff ff ff       	call   80187f <syscall>
  8018e7:	83 c4 18             	add    $0x18,%esp
}
  8018ea:	c9                   	leave  
  8018eb:	c3                   	ret    

008018ec <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8018ec:	55                   	push   %ebp
  8018ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8018ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f5:	6a 00                	push   $0x0
  8018f7:	6a 00                	push   $0x0
  8018f9:	6a 00                	push   $0x0
  8018fb:	52                   	push   %edx
  8018fc:	50                   	push   %eax
  8018fd:	6a 05                	push   $0x5
  8018ff:	e8 7b ff ff ff       	call   80187f <syscall>
  801904:	83 c4 18             	add    $0x18,%esp
}
  801907:	c9                   	leave  
  801908:	c3                   	ret    

00801909 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801909:	55                   	push   %ebp
  80190a:	89 e5                	mov    %esp,%ebp
  80190c:	56                   	push   %esi
  80190d:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80190e:	8b 75 18             	mov    0x18(%ebp),%esi
  801911:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801914:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801917:	8b 55 0c             	mov    0xc(%ebp),%edx
  80191a:	8b 45 08             	mov    0x8(%ebp),%eax
  80191d:	56                   	push   %esi
  80191e:	53                   	push   %ebx
  80191f:	51                   	push   %ecx
  801920:	52                   	push   %edx
  801921:	50                   	push   %eax
  801922:	6a 06                	push   $0x6
  801924:	e8 56 ff ff ff       	call   80187f <syscall>
  801929:	83 c4 18             	add    $0x18,%esp
}
  80192c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80192f:	5b                   	pop    %ebx
  801930:	5e                   	pop    %esi
  801931:	5d                   	pop    %ebp
  801932:	c3                   	ret    

00801933 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801933:	55                   	push   %ebp
  801934:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801936:	8b 55 0c             	mov    0xc(%ebp),%edx
  801939:	8b 45 08             	mov    0x8(%ebp),%eax
  80193c:	6a 00                	push   $0x0
  80193e:	6a 00                	push   $0x0
  801940:	6a 00                	push   $0x0
  801942:	52                   	push   %edx
  801943:	50                   	push   %eax
  801944:	6a 07                	push   $0x7
  801946:	e8 34 ff ff ff       	call   80187f <syscall>
  80194b:	83 c4 18             	add    $0x18,%esp
}
  80194e:	c9                   	leave  
  80194f:	c3                   	ret    

00801950 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801950:	55                   	push   %ebp
  801951:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801953:	6a 00                	push   $0x0
  801955:	6a 00                	push   $0x0
  801957:	6a 00                	push   $0x0
  801959:	ff 75 0c             	pushl  0xc(%ebp)
  80195c:	ff 75 08             	pushl  0x8(%ebp)
  80195f:	6a 08                	push   $0x8
  801961:	e8 19 ff ff ff       	call   80187f <syscall>
  801966:	83 c4 18             	add    $0x18,%esp
}
  801969:	c9                   	leave  
  80196a:	c3                   	ret    

0080196b <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80196b:	55                   	push   %ebp
  80196c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80196e:	6a 00                	push   $0x0
  801970:	6a 00                	push   $0x0
  801972:	6a 00                	push   $0x0
  801974:	6a 00                	push   $0x0
  801976:	6a 00                	push   $0x0
  801978:	6a 09                	push   $0x9
  80197a:	e8 00 ff ff ff       	call   80187f <syscall>
  80197f:	83 c4 18             	add    $0x18,%esp
}
  801982:	c9                   	leave  
  801983:	c3                   	ret    

00801984 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801984:	55                   	push   %ebp
  801985:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801987:	6a 00                	push   $0x0
  801989:	6a 00                	push   $0x0
  80198b:	6a 00                	push   $0x0
  80198d:	6a 00                	push   $0x0
  80198f:	6a 00                	push   $0x0
  801991:	6a 0a                	push   $0xa
  801993:	e8 e7 fe ff ff       	call   80187f <syscall>
  801998:	83 c4 18             	add    $0x18,%esp
}
  80199b:	c9                   	leave  
  80199c:	c3                   	ret    

0080199d <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80199d:	55                   	push   %ebp
  80199e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8019a0:	6a 00                	push   $0x0
  8019a2:	6a 00                	push   $0x0
  8019a4:	6a 00                	push   $0x0
  8019a6:	6a 00                	push   $0x0
  8019a8:	6a 00                	push   $0x0
  8019aa:	6a 0b                	push   $0xb
  8019ac:	e8 ce fe ff ff       	call   80187f <syscall>
  8019b1:	83 c4 18             	add    $0x18,%esp
}
  8019b4:	c9                   	leave  
  8019b5:	c3                   	ret    

008019b6 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8019b6:	55                   	push   %ebp
  8019b7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8019b9:	6a 00                	push   $0x0
  8019bb:	6a 00                	push   $0x0
  8019bd:	6a 00                	push   $0x0
  8019bf:	ff 75 0c             	pushl  0xc(%ebp)
  8019c2:	ff 75 08             	pushl  0x8(%ebp)
  8019c5:	6a 0f                	push   $0xf
  8019c7:	e8 b3 fe ff ff       	call   80187f <syscall>
  8019cc:	83 c4 18             	add    $0x18,%esp
	return;
  8019cf:	90                   	nop
}
  8019d0:	c9                   	leave  
  8019d1:	c3                   	ret    

008019d2 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8019d2:	55                   	push   %ebp
  8019d3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8019d5:	6a 00                	push   $0x0
  8019d7:	6a 00                	push   $0x0
  8019d9:	6a 00                	push   $0x0
  8019db:	ff 75 0c             	pushl  0xc(%ebp)
  8019de:	ff 75 08             	pushl  0x8(%ebp)
  8019e1:	6a 10                	push   $0x10
  8019e3:	e8 97 fe ff ff       	call   80187f <syscall>
  8019e8:	83 c4 18             	add    $0x18,%esp
	return ;
  8019eb:	90                   	nop
}
  8019ec:	c9                   	leave  
  8019ed:	c3                   	ret    

008019ee <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8019ee:	55                   	push   %ebp
  8019ef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8019f1:	6a 00                	push   $0x0
  8019f3:	6a 00                	push   $0x0
  8019f5:	ff 75 10             	pushl  0x10(%ebp)
  8019f8:	ff 75 0c             	pushl  0xc(%ebp)
  8019fb:	ff 75 08             	pushl  0x8(%ebp)
  8019fe:	6a 11                	push   $0x11
  801a00:	e8 7a fe ff ff       	call   80187f <syscall>
  801a05:	83 c4 18             	add    $0x18,%esp
	return ;
  801a08:	90                   	nop
}
  801a09:	c9                   	leave  
  801a0a:	c3                   	ret    

00801a0b <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a0b:	55                   	push   %ebp
  801a0c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a0e:	6a 00                	push   $0x0
  801a10:	6a 00                	push   $0x0
  801a12:	6a 00                	push   $0x0
  801a14:	6a 00                	push   $0x0
  801a16:	6a 00                	push   $0x0
  801a18:	6a 0c                	push   $0xc
  801a1a:	e8 60 fe ff ff       	call   80187f <syscall>
  801a1f:	83 c4 18             	add    $0x18,%esp
}
  801a22:	c9                   	leave  
  801a23:	c3                   	ret    

00801a24 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a24:	55                   	push   %ebp
  801a25:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a27:	6a 00                	push   $0x0
  801a29:	6a 00                	push   $0x0
  801a2b:	6a 00                	push   $0x0
  801a2d:	6a 00                	push   $0x0
  801a2f:	ff 75 08             	pushl  0x8(%ebp)
  801a32:	6a 0d                	push   $0xd
  801a34:	e8 46 fe ff ff       	call   80187f <syscall>
  801a39:	83 c4 18             	add    $0x18,%esp
}
  801a3c:	c9                   	leave  
  801a3d:	c3                   	ret    

00801a3e <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a3e:	55                   	push   %ebp
  801a3f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a41:	6a 00                	push   $0x0
  801a43:	6a 00                	push   $0x0
  801a45:	6a 00                	push   $0x0
  801a47:	6a 00                	push   $0x0
  801a49:	6a 00                	push   $0x0
  801a4b:	6a 0e                	push   $0xe
  801a4d:	e8 2d fe ff ff       	call   80187f <syscall>
  801a52:	83 c4 18             	add    $0x18,%esp
}
  801a55:	90                   	nop
  801a56:	c9                   	leave  
  801a57:	c3                   	ret    

00801a58 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801a58:	55                   	push   %ebp
  801a59:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801a5b:	6a 00                	push   $0x0
  801a5d:	6a 00                	push   $0x0
  801a5f:	6a 00                	push   $0x0
  801a61:	6a 00                	push   $0x0
  801a63:	6a 00                	push   $0x0
  801a65:	6a 13                	push   $0x13
  801a67:	e8 13 fe ff ff       	call   80187f <syscall>
  801a6c:	83 c4 18             	add    $0x18,%esp
}
  801a6f:	90                   	nop
  801a70:	c9                   	leave  
  801a71:	c3                   	ret    

00801a72 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801a72:	55                   	push   %ebp
  801a73:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801a75:	6a 00                	push   $0x0
  801a77:	6a 00                	push   $0x0
  801a79:	6a 00                	push   $0x0
  801a7b:	6a 00                	push   $0x0
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 14                	push   $0x14
  801a81:	e8 f9 fd ff ff       	call   80187f <syscall>
  801a86:	83 c4 18             	add    $0x18,%esp
}
  801a89:	90                   	nop
  801a8a:	c9                   	leave  
  801a8b:	c3                   	ret    

00801a8c <sys_cputc>:


void
sys_cputc(const char c)
{
  801a8c:	55                   	push   %ebp
  801a8d:	89 e5                	mov    %esp,%ebp
  801a8f:	83 ec 04             	sub    $0x4,%esp
  801a92:	8b 45 08             	mov    0x8(%ebp),%eax
  801a95:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a98:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 00                	push   $0x0
  801aa0:	6a 00                	push   $0x0
  801aa2:	6a 00                	push   $0x0
  801aa4:	50                   	push   %eax
  801aa5:	6a 15                	push   $0x15
  801aa7:	e8 d3 fd ff ff       	call   80187f <syscall>
  801aac:	83 c4 18             	add    $0x18,%esp
}
  801aaf:	90                   	nop
  801ab0:	c9                   	leave  
  801ab1:	c3                   	ret    

00801ab2 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801ab2:	55                   	push   %ebp
  801ab3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801ab5:	6a 00                	push   $0x0
  801ab7:	6a 00                	push   $0x0
  801ab9:	6a 00                	push   $0x0
  801abb:	6a 00                	push   $0x0
  801abd:	6a 00                	push   $0x0
  801abf:	6a 16                	push   $0x16
  801ac1:	e8 b9 fd ff ff       	call   80187f <syscall>
  801ac6:	83 c4 18             	add    $0x18,%esp
}
  801ac9:	90                   	nop
  801aca:	c9                   	leave  
  801acb:	c3                   	ret    

00801acc <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801acc:	55                   	push   %ebp
  801acd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801acf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad2:	6a 00                	push   $0x0
  801ad4:	6a 00                	push   $0x0
  801ad6:	6a 00                	push   $0x0
  801ad8:	ff 75 0c             	pushl  0xc(%ebp)
  801adb:	50                   	push   %eax
  801adc:	6a 17                	push   $0x17
  801ade:	e8 9c fd ff ff       	call   80187f <syscall>
  801ae3:	83 c4 18             	add    $0x18,%esp
}
  801ae6:	c9                   	leave  
  801ae7:	c3                   	ret    

00801ae8 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801ae8:	55                   	push   %ebp
  801ae9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801aeb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aee:	8b 45 08             	mov    0x8(%ebp),%eax
  801af1:	6a 00                	push   $0x0
  801af3:	6a 00                	push   $0x0
  801af5:	6a 00                	push   $0x0
  801af7:	52                   	push   %edx
  801af8:	50                   	push   %eax
  801af9:	6a 1a                	push   $0x1a
  801afb:	e8 7f fd ff ff       	call   80187f <syscall>
  801b00:	83 c4 18             	add    $0x18,%esp
}
  801b03:	c9                   	leave  
  801b04:	c3                   	ret    

00801b05 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b05:	55                   	push   %ebp
  801b06:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b08:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0e:	6a 00                	push   $0x0
  801b10:	6a 00                	push   $0x0
  801b12:	6a 00                	push   $0x0
  801b14:	52                   	push   %edx
  801b15:	50                   	push   %eax
  801b16:	6a 18                	push   $0x18
  801b18:	e8 62 fd ff ff       	call   80187f <syscall>
  801b1d:	83 c4 18             	add    $0x18,%esp
}
  801b20:	90                   	nop
  801b21:	c9                   	leave  
  801b22:	c3                   	ret    

00801b23 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b23:	55                   	push   %ebp
  801b24:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b26:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b29:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2c:	6a 00                	push   $0x0
  801b2e:	6a 00                	push   $0x0
  801b30:	6a 00                	push   $0x0
  801b32:	52                   	push   %edx
  801b33:	50                   	push   %eax
  801b34:	6a 19                	push   $0x19
  801b36:	e8 44 fd ff ff       	call   80187f <syscall>
  801b3b:	83 c4 18             	add    $0x18,%esp
}
  801b3e:	90                   	nop
  801b3f:	c9                   	leave  
  801b40:	c3                   	ret    

00801b41 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b41:	55                   	push   %ebp
  801b42:	89 e5                	mov    %esp,%ebp
  801b44:	83 ec 04             	sub    $0x4,%esp
  801b47:	8b 45 10             	mov    0x10(%ebp),%eax
  801b4a:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b4d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b50:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b54:	8b 45 08             	mov    0x8(%ebp),%eax
  801b57:	6a 00                	push   $0x0
  801b59:	51                   	push   %ecx
  801b5a:	52                   	push   %edx
  801b5b:	ff 75 0c             	pushl  0xc(%ebp)
  801b5e:	50                   	push   %eax
  801b5f:	6a 1b                	push   $0x1b
  801b61:	e8 19 fd ff ff       	call   80187f <syscall>
  801b66:	83 c4 18             	add    $0x18,%esp
}
  801b69:	c9                   	leave  
  801b6a:	c3                   	ret    

00801b6b <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b6b:	55                   	push   %ebp
  801b6c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b6e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b71:	8b 45 08             	mov    0x8(%ebp),%eax
  801b74:	6a 00                	push   $0x0
  801b76:	6a 00                	push   $0x0
  801b78:	6a 00                	push   $0x0
  801b7a:	52                   	push   %edx
  801b7b:	50                   	push   %eax
  801b7c:	6a 1c                	push   $0x1c
  801b7e:	e8 fc fc ff ff       	call   80187f <syscall>
  801b83:	83 c4 18             	add    $0x18,%esp
}
  801b86:	c9                   	leave  
  801b87:	c3                   	ret    

00801b88 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b88:	55                   	push   %ebp
  801b89:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b8b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b8e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b91:	8b 45 08             	mov    0x8(%ebp),%eax
  801b94:	6a 00                	push   $0x0
  801b96:	6a 00                	push   $0x0
  801b98:	51                   	push   %ecx
  801b99:	52                   	push   %edx
  801b9a:	50                   	push   %eax
  801b9b:	6a 1d                	push   $0x1d
  801b9d:	e8 dd fc ff ff       	call   80187f <syscall>
  801ba2:	83 c4 18             	add    $0x18,%esp
}
  801ba5:	c9                   	leave  
  801ba6:	c3                   	ret    

00801ba7 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801ba7:	55                   	push   %ebp
  801ba8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801baa:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bad:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb0:	6a 00                	push   $0x0
  801bb2:	6a 00                	push   $0x0
  801bb4:	6a 00                	push   $0x0
  801bb6:	52                   	push   %edx
  801bb7:	50                   	push   %eax
  801bb8:	6a 1e                	push   $0x1e
  801bba:	e8 c0 fc ff ff       	call   80187f <syscall>
  801bbf:	83 c4 18             	add    $0x18,%esp
}
  801bc2:	c9                   	leave  
  801bc3:	c3                   	ret    

00801bc4 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801bc4:	55                   	push   %ebp
  801bc5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801bc7:	6a 00                	push   $0x0
  801bc9:	6a 00                	push   $0x0
  801bcb:	6a 00                	push   $0x0
  801bcd:	6a 00                	push   $0x0
  801bcf:	6a 00                	push   $0x0
  801bd1:	6a 1f                	push   $0x1f
  801bd3:	e8 a7 fc ff ff       	call   80187f <syscall>
  801bd8:	83 c4 18             	add    $0x18,%esp
}
  801bdb:	c9                   	leave  
  801bdc:	c3                   	ret    

00801bdd <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801bdd:	55                   	push   %ebp
  801bde:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801be0:	8b 45 08             	mov    0x8(%ebp),%eax
  801be3:	6a 00                	push   $0x0
  801be5:	ff 75 14             	pushl  0x14(%ebp)
  801be8:	ff 75 10             	pushl  0x10(%ebp)
  801beb:	ff 75 0c             	pushl  0xc(%ebp)
  801bee:	50                   	push   %eax
  801bef:	6a 20                	push   $0x20
  801bf1:	e8 89 fc ff ff       	call   80187f <syscall>
  801bf6:	83 c4 18             	add    $0x18,%esp
}
  801bf9:	c9                   	leave  
  801bfa:	c3                   	ret    

00801bfb <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801bfb:	55                   	push   %ebp
  801bfc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  801c01:	6a 00                	push   $0x0
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	6a 00                	push   $0x0
  801c09:	50                   	push   %eax
  801c0a:	6a 21                	push   $0x21
  801c0c:	e8 6e fc ff ff       	call   80187f <syscall>
  801c11:	83 c4 18             	add    $0x18,%esp
}
  801c14:	90                   	nop
  801c15:	c9                   	leave  
  801c16:	c3                   	ret    

00801c17 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c17:	55                   	push   %ebp
  801c18:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 00                	push   $0x0
  801c23:	6a 00                	push   $0x0
  801c25:	50                   	push   %eax
  801c26:	6a 22                	push   $0x22
  801c28:	e8 52 fc ff ff       	call   80187f <syscall>
  801c2d:	83 c4 18             	add    $0x18,%esp
}
  801c30:	c9                   	leave  
  801c31:	c3                   	ret    

00801c32 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c32:	55                   	push   %ebp
  801c33:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c35:	6a 00                	push   $0x0
  801c37:	6a 00                	push   $0x0
  801c39:	6a 00                	push   $0x0
  801c3b:	6a 00                	push   $0x0
  801c3d:	6a 00                	push   $0x0
  801c3f:	6a 02                	push   $0x2
  801c41:	e8 39 fc ff ff       	call   80187f <syscall>
  801c46:	83 c4 18             	add    $0x18,%esp
}
  801c49:	c9                   	leave  
  801c4a:	c3                   	ret    

00801c4b <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c4b:	55                   	push   %ebp
  801c4c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c4e:	6a 00                	push   $0x0
  801c50:	6a 00                	push   $0x0
  801c52:	6a 00                	push   $0x0
  801c54:	6a 00                	push   $0x0
  801c56:	6a 00                	push   $0x0
  801c58:	6a 03                	push   $0x3
  801c5a:	e8 20 fc ff ff       	call   80187f <syscall>
  801c5f:	83 c4 18             	add    $0x18,%esp
}
  801c62:	c9                   	leave  
  801c63:	c3                   	ret    

00801c64 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c64:	55                   	push   %ebp
  801c65:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c67:	6a 00                	push   $0x0
  801c69:	6a 00                	push   $0x0
  801c6b:	6a 00                	push   $0x0
  801c6d:	6a 00                	push   $0x0
  801c6f:	6a 00                	push   $0x0
  801c71:	6a 04                	push   $0x4
  801c73:	e8 07 fc ff ff       	call   80187f <syscall>
  801c78:	83 c4 18             	add    $0x18,%esp
}
  801c7b:	c9                   	leave  
  801c7c:	c3                   	ret    

00801c7d <sys_exit_env>:


void sys_exit_env(void)
{
  801c7d:	55                   	push   %ebp
  801c7e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c80:	6a 00                	push   $0x0
  801c82:	6a 00                	push   $0x0
  801c84:	6a 00                	push   $0x0
  801c86:	6a 00                	push   $0x0
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 23                	push   $0x23
  801c8c:	e8 ee fb ff ff       	call   80187f <syscall>
  801c91:	83 c4 18             	add    $0x18,%esp
}
  801c94:	90                   	nop
  801c95:	c9                   	leave  
  801c96:	c3                   	ret    

00801c97 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801c97:	55                   	push   %ebp
  801c98:	89 e5                	mov    %esp,%ebp
  801c9a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c9d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ca0:	8d 50 04             	lea    0x4(%eax),%edx
  801ca3:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ca6:	6a 00                	push   $0x0
  801ca8:	6a 00                	push   $0x0
  801caa:	6a 00                	push   $0x0
  801cac:	52                   	push   %edx
  801cad:	50                   	push   %eax
  801cae:	6a 24                	push   $0x24
  801cb0:	e8 ca fb ff ff       	call   80187f <syscall>
  801cb5:	83 c4 18             	add    $0x18,%esp
	return result;
  801cb8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cbb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801cbe:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801cc1:	89 01                	mov    %eax,(%ecx)
  801cc3:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc9:	c9                   	leave  
  801cca:	c2 04 00             	ret    $0x4

00801ccd <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801ccd:	55                   	push   %ebp
  801cce:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801cd0:	6a 00                	push   $0x0
  801cd2:	6a 00                	push   $0x0
  801cd4:	ff 75 10             	pushl  0x10(%ebp)
  801cd7:	ff 75 0c             	pushl  0xc(%ebp)
  801cda:	ff 75 08             	pushl  0x8(%ebp)
  801cdd:	6a 12                	push   $0x12
  801cdf:	e8 9b fb ff ff       	call   80187f <syscall>
  801ce4:	83 c4 18             	add    $0x18,%esp
	return ;
  801ce7:	90                   	nop
}
  801ce8:	c9                   	leave  
  801ce9:	c3                   	ret    

00801cea <sys_rcr2>:
uint32 sys_rcr2()
{
  801cea:	55                   	push   %ebp
  801ceb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801ced:	6a 00                	push   $0x0
  801cef:	6a 00                	push   $0x0
  801cf1:	6a 00                	push   $0x0
  801cf3:	6a 00                	push   $0x0
  801cf5:	6a 00                	push   $0x0
  801cf7:	6a 25                	push   $0x25
  801cf9:	e8 81 fb ff ff       	call   80187f <syscall>
  801cfe:	83 c4 18             	add    $0x18,%esp
}
  801d01:	c9                   	leave  
  801d02:	c3                   	ret    

00801d03 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801d03:	55                   	push   %ebp
  801d04:	89 e5                	mov    %esp,%ebp
  801d06:	83 ec 04             	sub    $0x4,%esp
  801d09:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d0f:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d13:	6a 00                	push   $0x0
  801d15:	6a 00                	push   $0x0
  801d17:	6a 00                	push   $0x0
  801d19:	6a 00                	push   $0x0
  801d1b:	50                   	push   %eax
  801d1c:	6a 26                	push   $0x26
  801d1e:	e8 5c fb ff ff       	call   80187f <syscall>
  801d23:	83 c4 18             	add    $0x18,%esp
	return ;
  801d26:	90                   	nop
}
  801d27:	c9                   	leave  
  801d28:	c3                   	ret    

00801d29 <rsttst>:
void rsttst()
{
  801d29:	55                   	push   %ebp
  801d2a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d2c:	6a 00                	push   $0x0
  801d2e:	6a 00                	push   $0x0
  801d30:	6a 00                	push   $0x0
  801d32:	6a 00                	push   $0x0
  801d34:	6a 00                	push   $0x0
  801d36:	6a 28                	push   $0x28
  801d38:	e8 42 fb ff ff       	call   80187f <syscall>
  801d3d:	83 c4 18             	add    $0x18,%esp
	return ;
  801d40:	90                   	nop
}
  801d41:	c9                   	leave  
  801d42:	c3                   	ret    

00801d43 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d43:	55                   	push   %ebp
  801d44:	89 e5                	mov    %esp,%ebp
  801d46:	83 ec 04             	sub    $0x4,%esp
  801d49:	8b 45 14             	mov    0x14(%ebp),%eax
  801d4c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d4f:	8b 55 18             	mov    0x18(%ebp),%edx
  801d52:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d56:	52                   	push   %edx
  801d57:	50                   	push   %eax
  801d58:	ff 75 10             	pushl  0x10(%ebp)
  801d5b:	ff 75 0c             	pushl  0xc(%ebp)
  801d5e:	ff 75 08             	pushl  0x8(%ebp)
  801d61:	6a 27                	push   $0x27
  801d63:	e8 17 fb ff ff       	call   80187f <syscall>
  801d68:	83 c4 18             	add    $0x18,%esp
	return ;
  801d6b:	90                   	nop
}
  801d6c:	c9                   	leave  
  801d6d:	c3                   	ret    

00801d6e <chktst>:
void chktst(uint32 n)
{
  801d6e:	55                   	push   %ebp
  801d6f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d71:	6a 00                	push   $0x0
  801d73:	6a 00                	push   $0x0
  801d75:	6a 00                	push   $0x0
  801d77:	6a 00                	push   $0x0
  801d79:	ff 75 08             	pushl  0x8(%ebp)
  801d7c:	6a 29                	push   $0x29
  801d7e:	e8 fc fa ff ff       	call   80187f <syscall>
  801d83:	83 c4 18             	add    $0x18,%esp
	return ;
  801d86:	90                   	nop
}
  801d87:	c9                   	leave  
  801d88:	c3                   	ret    

00801d89 <inctst>:

void inctst()
{
  801d89:	55                   	push   %ebp
  801d8a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d8c:	6a 00                	push   $0x0
  801d8e:	6a 00                	push   $0x0
  801d90:	6a 00                	push   $0x0
  801d92:	6a 00                	push   $0x0
  801d94:	6a 00                	push   $0x0
  801d96:	6a 2a                	push   $0x2a
  801d98:	e8 e2 fa ff ff       	call   80187f <syscall>
  801d9d:	83 c4 18             	add    $0x18,%esp
	return ;
  801da0:	90                   	nop
}
  801da1:	c9                   	leave  
  801da2:	c3                   	ret    

00801da3 <gettst>:
uint32 gettst()
{
  801da3:	55                   	push   %ebp
  801da4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801da6:	6a 00                	push   $0x0
  801da8:	6a 00                	push   $0x0
  801daa:	6a 00                	push   $0x0
  801dac:	6a 00                	push   $0x0
  801dae:	6a 00                	push   $0x0
  801db0:	6a 2b                	push   $0x2b
  801db2:	e8 c8 fa ff ff       	call   80187f <syscall>
  801db7:	83 c4 18             	add    $0x18,%esp
}
  801dba:	c9                   	leave  
  801dbb:	c3                   	ret    

00801dbc <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801dbc:	55                   	push   %ebp
  801dbd:	89 e5                	mov    %esp,%ebp
  801dbf:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dc2:	6a 00                	push   $0x0
  801dc4:	6a 00                	push   $0x0
  801dc6:	6a 00                	push   $0x0
  801dc8:	6a 00                	push   $0x0
  801dca:	6a 00                	push   $0x0
  801dcc:	6a 2c                	push   $0x2c
  801dce:	e8 ac fa ff ff       	call   80187f <syscall>
  801dd3:	83 c4 18             	add    $0x18,%esp
  801dd6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801dd9:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801ddd:	75 07                	jne    801de6 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801ddf:	b8 01 00 00 00       	mov    $0x1,%eax
  801de4:	eb 05                	jmp    801deb <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801de6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801deb:	c9                   	leave  
  801dec:	c3                   	ret    

00801ded <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801ded:	55                   	push   %ebp
  801dee:	89 e5                	mov    %esp,%ebp
  801df0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801df3:	6a 00                	push   $0x0
  801df5:	6a 00                	push   $0x0
  801df7:	6a 00                	push   $0x0
  801df9:	6a 00                	push   $0x0
  801dfb:	6a 00                	push   $0x0
  801dfd:	6a 2c                	push   $0x2c
  801dff:	e8 7b fa ff ff       	call   80187f <syscall>
  801e04:	83 c4 18             	add    $0x18,%esp
  801e07:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e0a:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e0e:	75 07                	jne    801e17 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e10:	b8 01 00 00 00       	mov    $0x1,%eax
  801e15:	eb 05                	jmp    801e1c <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e17:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e1c:	c9                   	leave  
  801e1d:	c3                   	ret    

00801e1e <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e1e:	55                   	push   %ebp
  801e1f:	89 e5                	mov    %esp,%ebp
  801e21:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e24:	6a 00                	push   $0x0
  801e26:	6a 00                	push   $0x0
  801e28:	6a 00                	push   $0x0
  801e2a:	6a 00                	push   $0x0
  801e2c:	6a 00                	push   $0x0
  801e2e:	6a 2c                	push   $0x2c
  801e30:	e8 4a fa ff ff       	call   80187f <syscall>
  801e35:	83 c4 18             	add    $0x18,%esp
  801e38:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e3b:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e3f:	75 07                	jne    801e48 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e41:	b8 01 00 00 00       	mov    $0x1,%eax
  801e46:	eb 05                	jmp    801e4d <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e48:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e4d:	c9                   	leave  
  801e4e:	c3                   	ret    

00801e4f <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e4f:	55                   	push   %ebp
  801e50:	89 e5                	mov    %esp,%ebp
  801e52:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e55:	6a 00                	push   $0x0
  801e57:	6a 00                	push   $0x0
  801e59:	6a 00                	push   $0x0
  801e5b:	6a 00                	push   $0x0
  801e5d:	6a 00                	push   $0x0
  801e5f:	6a 2c                	push   $0x2c
  801e61:	e8 19 fa ff ff       	call   80187f <syscall>
  801e66:	83 c4 18             	add    $0x18,%esp
  801e69:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e6c:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e70:	75 07                	jne    801e79 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e72:	b8 01 00 00 00       	mov    $0x1,%eax
  801e77:	eb 05                	jmp    801e7e <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e79:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e7e:	c9                   	leave  
  801e7f:	c3                   	ret    

00801e80 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e80:	55                   	push   %ebp
  801e81:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e83:	6a 00                	push   $0x0
  801e85:	6a 00                	push   $0x0
  801e87:	6a 00                	push   $0x0
  801e89:	6a 00                	push   $0x0
  801e8b:	ff 75 08             	pushl  0x8(%ebp)
  801e8e:	6a 2d                	push   $0x2d
  801e90:	e8 ea f9 ff ff       	call   80187f <syscall>
  801e95:	83 c4 18             	add    $0x18,%esp
	return ;
  801e98:	90                   	nop
}
  801e99:	c9                   	leave  
  801e9a:	c3                   	ret    

00801e9b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e9b:	55                   	push   %ebp
  801e9c:	89 e5                	mov    %esp,%ebp
  801e9e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e9f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ea2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ea5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ea8:	8b 45 08             	mov    0x8(%ebp),%eax
  801eab:	6a 00                	push   $0x0
  801ead:	53                   	push   %ebx
  801eae:	51                   	push   %ecx
  801eaf:	52                   	push   %edx
  801eb0:	50                   	push   %eax
  801eb1:	6a 2e                	push   $0x2e
  801eb3:	e8 c7 f9 ff ff       	call   80187f <syscall>
  801eb8:	83 c4 18             	add    $0x18,%esp
}
  801ebb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ebe:	c9                   	leave  
  801ebf:	c3                   	ret    

00801ec0 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ec0:	55                   	push   %ebp
  801ec1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801ec3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ec6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec9:	6a 00                	push   $0x0
  801ecb:	6a 00                	push   $0x0
  801ecd:	6a 00                	push   $0x0
  801ecf:	52                   	push   %edx
  801ed0:	50                   	push   %eax
  801ed1:	6a 2f                	push   $0x2f
  801ed3:	e8 a7 f9 ff ff       	call   80187f <syscall>
  801ed8:	83 c4 18             	add    $0x18,%esp
}
  801edb:	c9                   	leave  
  801edc:	c3                   	ret    

00801edd <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801edd:	55                   	push   %ebp
  801ede:	89 e5                	mov    %esp,%ebp
  801ee0:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801ee3:	83 ec 0c             	sub    $0xc,%esp
  801ee6:	68 90 41 80 00       	push   $0x804190
  801eeb:	e8 6b e8 ff ff       	call   80075b <cprintf>
  801ef0:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801ef3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801efa:	83 ec 0c             	sub    $0xc,%esp
  801efd:	68 bc 41 80 00       	push   $0x8041bc
  801f02:	e8 54 e8 ff ff       	call   80075b <cprintf>
  801f07:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801f0a:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f0e:	a1 38 51 80 00       	mov    0x805138,%eax
  801f13:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f16:	eb 56                	jmp    801f6e <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f18:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f1c:	74 1c                	je     801f3a <print_mem_block_lists+0x5d>
  801f1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f21:	8b 50 08             	mov    0x8(%eax),%edx
  801f24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f27:	8b 48 08             	mov    0x8(%eax),%ecx
  801f2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f2d:	8b 40 0c             	mov    0xc(%eax),%eax
  801f30:	01 c8                	add    %ecx,%eax
  801f32:	39 c2                	cmp    %eax,%edx
  801f34:	73 04                	jae    801f3a <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801f36:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f3d:	8b 50 08             	mov    0x8(%eax),%edx
  801f40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f43:	8b 40 0c             	mov    0xc(%eax),%eax
  801f46:	01 c2                	add    %eax,%edx
  801f48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f4b:	8b 40 08             	mov    0x8(%eax),%eax
  801f4e:	83 ec 04             	sub    $0x4,%esp
  801f51:	52                   	push   %edx
  801f52:	50                   	push   %eax
  801f53:	68 d1 41 80 00       	push   $0x8041d1
  801f58:	e8 fe e7 ff ff       	call   80075b <cprintf>
  801f5d:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f63:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f66:	a1 40 51 80 00       	mov    0x805140,%eax
  801f6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f6e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f72:	74 07                	je     801f7b <print_mem_block_lists+0x9e>
  801f74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f77:	8b 00                	mov    (%eax),%eax
  801f79:	eb 05                	jmp    801f80 <print_mem_block_lists+0xa3>
  801f7b:	b8 00 00 00 00       	mov    $0x0,%eax
  801f80:	a3 40 51 80 00       	mov    %eax,0x805140
  801f85:	a1 40 51 80 00       	mov    0x805140,%eax
  801f8a:	85 c0                	test   %eax,%eax
  801f8c:	75 8a                	jne    801f18 <print_mem_block_lists+0x3b>
  801f8e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f92:	75 84                	jne    801f18 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801f94:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f98:	75 10                	jne    801faa <print_mem_block_lists+0xcd>
  801f9a:	83 ec 0c             	sub    $0xc,%esp
  801f9d:	68 e0 41 80 00       	push   $0x8041e0
  801fa2:	e8 b4 e7 ff ff       	call   80075b <cprintf>
  801fa7:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801faa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801fb1:	83 ec 0c             	sub    $0xc,%esp
  801fb4:	68 04 42 80 00       	push   $0x804204
  801fb9:	e8 9d e7 ff ff       	call   80075b <cprintf>
  801fbe:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801fc1:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801fc5:	a1 40 50 80 00       	mov    0x805040,%eax
  801fca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fcd:	eb 56                	jmp    802025 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801fcf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fd3:	74 1c                	je     801ff1 <print_mem_block_lists+0x114>
  801fd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd8:	8b 50 08             	mov    0x8(%eax),%edx
  801fdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fde:	8b 48 08             	mov    0x8(%eax),%ecx
  801fe1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fe4:	8b 40 0c             	mov    0xc(%eax),%eax
  801fe7:	01 c8                	add    %ecx,%eax
  801fe9:	39 c2                	cmp    %eax,%edx
  801feb:	73 04                	jae    801ff1 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801fed:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801ff1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff4:	8b 50 08             	mov    0x8(%eax),%edx
  801ff7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ffa:	8b 40 0c             	mov    0xc(%eax),%eax
  801ffd:	01 c2                	add    %eax,%edx
  801fff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802002:	8b 40 08             	mov    0x8(%eax),%eax
  802005:	83 ec 04             	sub    $0x4,%esp
  802008:	52                   	push   %edx
  802009:	50                   	push   %eax
  80200a:	68 d1 41 80 00       	push   $0x8041d1
  80200f:	e8 47 e7 ff ff       	call   80075b <cprintf>
  802014:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802017:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80201a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80201d:	a1 48 50 80 00       	mov    0x805048,%eax
  802022:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802025:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802029:	74 07                	je     802032 <print_mem_block_lists+0x155>
  80202b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80202e:	8b 00                	mov    (%eax),%eax
  802030:	eb 05                	jmp    802037 <print_mem_block_lists+0x15a>
  802032:	b8 00 00 00 00       	mov    $0x0,%eax
  802037:	a3 48 50 80 00       	mov    %eax,0x805048
  80203c:	a1 48 50 80 00       	mov    0x805048,%eax
  802041:	85 c0                	test   %eax,%eax
  802043:	75 8a                	jne    801fcf <print_mem_block_lists+0xf2>
  802045:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802049:	75 84                	jne    801fcf <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80204b:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80204f:	75 10                	jne    802061 <print_mem_block_lists+0x184>
  802051:	83 ec 0c             	sub    $0xc,%esp
  802054:	68 1c 42 80 00       	push   $0x80421c
  802059:	e8 fd e6 ff ff       	call   80075b <cprintf>
  80205e:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802061:	83 ec 0c             	sub    $0xc,%esp
  802064:	68 90 41 80 00       	push   $0x804190
  802069:	e8 ed e6 ff ff       	call   80075b <cprintf>
  80206e:	83 c4 10             	add    $0x10,%esp

}
  802071:	90                   	nop
  802072:	c9                   	leave  
  802073:	c3                   	ret    

00802074 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802074:	55                   	push   %ebp
  802075:	89 e5                	mov    %esp,%ebp
  802077:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  80207a:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802081:	00 00 00 
  802084:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80208b:	00 00 00 
  80208e:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802095:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  802098:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80209f:	e9 9e 00 00 00       	jmp    802142 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  8020a4:	a1 50 50 80 00       	mov    0x805050,%eax
  8020a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020ac:	c1 e2 04             	shl    $0x4,%edx
  8020af:	01 d0                	add    %edx,%eax
  8020b1:	85 c0                	test   %eax,%eax
  8020b3:	75 14                	jne    8020c9 <initialize_MemBlocksList+0x55>
  8020b5:	83 ec 04             	sub    $0x4,%esp
  8020b8:	68 44 42 80 00       	push   $0x804244
  8020bd:	6a 46                	push   $0x46
  8020bf:	68 67 42 80 00       	push   $0x804267
  8020c4:	e8 de e3 ff ff       	call   8004a7 <_panic>
  8020c9:	a1 50 50 80 00       	mov    0x805050,%eax
  8020ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020d1:	c1 e2 04             	shl    $0x4,%edx
  8020d4:	01 d0                	add    %edx,%eax
  8020d6:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8020dc:	89 10                	mov    %edx,(%eax)
  8020de:	8b 00                	mov    (%eax),%eax
  8020e0:	85 c0                	test   %eax,%eax
  8020e2:	74 18                	je     8020fc <initialize_MemBlocksList+0x88>
  8020e4:	a1 48 51 80 00       	mov    0x805148,%eax
  8020e9:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8020ef:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8020f2:	c1 e1 04             	shl    $0x4,%ecx
  8020f5:	01 ca                	add    %ecx,%edx
  8020f7:	89 50 04             	mov    %edx,0x4(%eax)
  8020fa:	eb 12                	jmp    80210e <initialize_MemBlocksList+0x9a>
  8020fc:	a1 50 50 80 00       	mov    0x805050,%eax
  802101:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802104:	c1 e2 04             	shl    $0x4,%edx
  802107:	01 d0                	add    %edx,%eax
  802109:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80210e:	a1 50 50 80 00       	mov    0x805050,%eax
  802113:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802116:	c1 e2 04             	shl    $0x4,%edx
  802119:	01 d0                	add    %edx,%eax
  80211b:	a3 48 51 80 00       	mov    %eax,0x805148
  802120:	a1 50 50 80 00       	mov    0x805050,%eax
  802125:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802128:	c1 e2 04             	shl    $0x4,%edx
  80212b:	01 d0                	add    %edx,%eax
  80212d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802134:	a1 54 51 80 00       	mov    0x805154,%eax
  802139:	40                   	inc    %eax
  80213a:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  80213f:	ff 45 f4             	incl   -0xc(%ebp)
  802142:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802145:	3b 45 08             	cmp    0x8(%ebp),%eax
  802148:	0f 82 56 ff ff ff    	jb     8020a4 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  80214e:	90                   	nop
  80214f:	c9                   	leave  
  802150:	c3                   	ret    

00802151 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802151:	55                   	push   %ebp
  802152:	89 e5                	mov    %esp,%ebp
  802154:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802157:	8b 45 08             	mov    0x8(%ebp),%eax
  80215a:	8b 00                	mov    (%eax),%eax
  80215c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80215f:	eb 19                	jmp    80217a <find_block+0x29>
	{
		if(va==point->sva)
  802161:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802164:	8b 40 08             	mov    0x8(%eax),%eax
  802167:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80216a:	75 05                	jne    802171 <find_block+0x20>
		   return point;
  80216c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80216f:	eb 36                	jmp    8021a7 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802171:	8b 45 08             	mov    0x8(%ebp),%eax
  802174:	8b 40 08             	mov    0x8(%eax),%eax
  802177:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80217a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80217e:	74 07                	je     802187 <find_block+0x36>
  802180:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802183:	8b 00                	mov    (%eax),%eax
  802185:	eb 05                	jmp    80218c <find_block+0x3b>
  802187:	b8 00 00 00 00       	mov    $0x0,%eax
  80218c:	8b 55 08             	mov    0x8(%ebp),%edx
  80218f:	89 42 08             	mov    %eax,0x8(%edx)
  802192:	8b 45 08             	mov    0x8(%ebp),%eax
  802195:	8b 40 08             	mov    0x8(%eax),%eax
  802198:	85 c0                	test   %eax,%eax
  80219a:	75 c5                	jne    802161 <find_block+0x10>
  80219c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021a0:	75 bf                	jne    802161 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  8021a2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021a7:	c9                   	leave  
  8021a8:	c3                   	ret    

008021a9 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8021a9:	55                   	push   %ebp
  8021aa:	89 e5                	mov    %esp,%ebp
  8021ac:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  8021af:	a1 40 50 80 00       	mov    0x805040,%eax
  8021b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  8021b7:	a1 44 50 80 00       	mov    0x805044,%eax
  8021bc:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8021bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021c2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8021c5:	74 24                	je     8021eb <insert_sorted_allocList+0x42>
  8021c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ca:	8b 50 08             	mov    0x8(%eax),%edx
  8021cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021d0:	8b 40 08             	mov    0x8(%eax),%eax
  8021d3:	39 c2                	cmp    %eax,%edx
  8021d5:	76 14                	jbe    8021eb <insert_sorted_allocList+0x42>
  8021d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021da:	8b 50 08             	mov    0x8(%eax),%edx
  8021dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021e0:	8b 40 08             	mov    0x8(%eax),%eax
  8021e3:	39 c2                	cmp    %eax,%edx
  8021e5:	0f 82 60 01 00 00    	jb     80234b <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8021eb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021ef:	75 65                	jne    802256 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8021f1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021f5:	75 14                	jne    80220b <insert_sorted_allocList+0x62>
  8021f7:	83 ec 04             	sub    $0x4,%esp
  8021fa:	68 44 42 80 00       	push   $0x804244
  8021ff:	6a 6b                	push   $0x6b
  802201:	68 67 42 80 00       	push   $0x804267
  802206:	e8 9c e2 ff ff       	call   8004a7 <_panic>
  80220b:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802211:	8b 45 08             	mov    0x8(%ebp),%eax
  802214:	89 10                	mov    %edx,(%eax)
  802216:	8b 45 08             	mov    0x8(%ebp),%eax
  802219:	8b 00                	mov    (%eax),%eax
  80221b:	85 c0                	test   %eax,%eax
  80221d:	74 0d                	je     80222c <insert_sorted_allocList+0x83>
  80221f:	a1 40 50 80 00       	mov    0x805040,%eax
  802224:	8b 55 08             	mov    0x8(%ebp),%edx
  802227:	89 50 04             	mov    %edx,0x4(%eax)
  80222a:	eb 08                	jmp    802234 <insert_sorted_allocList+0x8b>
  80222c:	8b 45 08             	mov    0x8(%ebp),%eax
  80222f:	a3 44 50 80 00       	mov    %eax,0x805044
  802234:	8b 45 08             	mov    0x8(%ebp),%eax
  802237:	a3 40 50 80 00       	mov    %eax,0x805040
  80223c:	8b 45 08             	mov    0x8(%ebp),%eax
  80223f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802246:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80224b:	40                   	inc    %eax
  80224c:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802251:	e9 dc 01 00 00       	jmp    802432 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802256:	8b 45 08             	mov    0x8(%ebp),%eax
  802259:	8b 50 08             	mov    0x8(%eax),%edx
  80225c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80225f:	8b 40 08             	mov    0x8(%eax),%eax
  802262:	39 c2                	cmp    %eax,%edx
  802264:	77 6c                	ja     8022d2 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802266:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80226a:	74 06                	je     802272 <insert_sorted_allocList+0xc9>
  80226c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802270:	75 14                	jne    802286 <insert_sorted_allocList+0xdd>
  802272:	83 ec 04             	sub    $0x4,%esp
  802275:	68 80 42 80 00       	push   $0x804280
  80227a:	6a 6f                	push   $0x6f
  80227c:	68 67 42 80 00       	push   $0x804267
  802281:	e8 21 e2 ff ff       	call   8004a7 <_panic>
  802286:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802289:	8b 50 04             	mov    0x4(%eax),%edx
  80228c:	8b 45 08             	mov    0x8(%ebp),%eax
  80228f:	89 50 04             	mov    %edx,0x4(%eax)
  802292:	8b 45 08             	mov    0x8(%ebp),%eax
  802295:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802298:	89 10                	mov    %edx,(%eax)
  80229a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80229d:	8b 40 04             	mov    0x4(%eax),%eax
  8022a0:	85 c0                	test   %eax,%eax
  8022a2:	74 0d                	je     8022b1 <insert_sorted_allocList+0x108>
  8022a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022a7:	8b 40 04             	mov    0x4(%eax),%eax
  8022aa:	8b 55 08             	mov    0x8(%ebp),%edx
  8022ad:	89 10                	mov    %edx,(%eax)
  8022af:	eb 08                	jmp    8022b9 <insert_sorted_allocList+0x110>
  8022b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b4:	a3 40 50 80 00       	mov    %eax,0x805040
  8022b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8022bf:	89 50 04             	mov    %edx,0x4(%eax)
  8022c2:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8022c7:	40                   	inc    %eax
  8022c8:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8022cd:	e9 60 01 00 00       	jmp    802432 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8022d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d5:	8b 50 08             	mov    0x8(%eax),%edx
  8022d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022db:	8b 40 08             	mov    0x8(%eax),%eax
  8022de:	39 c2                	cmp    %eax,%edx
  8022e0:	0f 82 4c 01 00 00    	jb     802432 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8022e6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022ea:	75 14                	jne    802300 <insert_sorted_allocList+0x157>
  8022ec:	83 ec 04             	sub    $0x4,%esp
  8022ef:	68 b8 42 80 00       	push   $0x8042b8
  8022f4:	6a 73                	push   $0x73
  8022f6:	68 67 42 80 00       	push   $0x804267
  8022fb:	e8 a7 e1 ff ff       	call   8004a7 <_panic>
  802300:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802306:	8b 45 08             	mov    0x8(%ebp),%eax
  802309:	89 50 04             	mov    %edx,0x4(%eax)
  80230c:	8b 45 08             	mov    0x8(%ebp),%eax
  80230f:	8b 40 04             	mov    0x4(%eax),%eax
  802312:	85 c0                	test   %eax,%eax
  802314:	74 0c                	je     802322 <insert_sorted_allocList+0x179>
  802316:	a1 44 50 80 00       	mov    0x805044,%eax
  80231b:	8b 55 08             	mov    0x8(%ebp),%edx
  80231e:	89 10                	mov    %edx,(%eax)
  802320:	eb 08                	jmp    80232a <insert_sorted_allocList+0x181>
  802322:	8b 45 08             	mov    0x8(%ebp),%eax
  802325:	a3 40 50 80 00       	mov    %eax,0x805040
  80232a:	8b 45 08             	mov    0x8(%ebp),%eax
  80232d:	a3 44 50 80 00       	mov    %eax,0x805044
  802332:	8b 45 08             	mov    0x8(%ebp),%eax
  802335:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80233b:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802340:	40                   	inc    %eax
  802341:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802346:	e9 e7 00 00 00       	jmp    802432 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  80234b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80234e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802351:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802358:	a1 40 50 80 00       	mov    0x805040,%eax
  80235d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802360:	e9 9d 00 00 00       	jmp    802402 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802365:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802368:	8b 00                	mov    (%eax),%eax
  80236a:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  80236d:	8b 45 08             	mov    0x8(%ebp),%eax
  802370:	8b 50 08             	mov    0x8(%eax),%edx
  802373:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802376:	8b 40 08             	mov    0x8(%eax),%eax
  802379:	39 c2                	cmp    %eax,%edx
  80237b:	76 7d                	jbe    8023fa <insert_sorted_allocList+0x251>
  80237d:	8b 45 08             	mov    0x8(%ebp),%eax
  802380:	8b 50 08             	mov    0x8(%eax),%edx
  802383:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802386:	8b 40 08             	mov    0x8(%eax),%eax
  802389:	39 c2                	cmp    %eax,%edx
  80238b:	73 6d                	jae    8023fa <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  80238d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802391:	74 06                	je     802399 <insert_sorted_allocList+0x1f0>
  802393:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802397:	75 14                	jne    8023ad <insert_sorted_allocList+0x204>
  802399:	83 ec 04             	sub    $0x4,%esp
  80239c:	68 dc 42 80 00       	push   $0x8042dc
  8023a1:	6a 7f                	push   $0x7f
  8023a3:	68 67 42 80 00       	push   $0x804267
  8023a8:	e8 fa e0 ff ff       	call   8004a7 <_panic>
  8023ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b0:	8b 10                	mov    (%eax),%edx
  8023b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b5:	89 10                	mov    %edx,(%eax)
  8023b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ba:	8b 00                	mov    (%eax),%eax
  8023bc:	85 c0                	test   %eax,%eax
  8023be:	74 0b                	je     8023cb <insert_sorted_allocList+0x222>
  8023c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c3:	8b 00                	mov    (%eax),%eax
  8023c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8023c8:	89 50 04             	mov    %edx,0x4(%eax)
  8023cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8023d1:	89 10                	mov    %edx,(%eax)
  8023d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023d9:	89 50 04             	mov    %edx,0x4(%eax)
  8023dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8023df:	8b 00                	mov    (%eax),%eax
  8023e1:	85 c0                	test   %eax,%eax
  8023e3:	75 08                	jne    8023ed <insert_sorted_allocList+0x244>
  8023e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e8:	a3 44 50 80 00       	mov    %eax,0x805044
  8023ed:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8023f2:	40                   	inc    %eax
  8023f3:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8023f8:	eb 39                	jmp    802433 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8023fa:	a1 48 50 80 00       	mov    0x805048,%eax
  8023ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802402:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802406:	74 07                	je     80240f <insert_sorted_allocList+0x266>
  802408:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240b:	8b 00                	mov    (%eax),%eax
  80240d:	eb 05                	jmp    802414 <insert_sorted_allocList+0x26b>
  80240f:	b8 00 00 00 00       	mov    $0x0,%eax
  802414:	a3 48 50 80 00       	mov    %eax,0x805048
  802419:	a1 48 50 80 00       	mov    0x805048,%eax
  80241e:	85 c0                	test   %eax,%eax
  802420:	0f 85 3f ff ff ff    	jne    802365 <insert_sorted_allocList+0x1bc>
  802426:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80242a:	0f 85 35 ff ff ff    	jne    802365 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802430:	eb 01                	jmp    802433 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802432:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802433:	90                   	nop
  802434:	c9                   	leave  
  802435:	c3                   	ret    

00802436 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802436:	55                   	push   %ebp
  802437:	89 e5                	mov    %esp,%ebp
  802439:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80243c:	a1 38 51 80 00       	mov    0x805138,%eax
  802441:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802444:	e9 85 01 00 00       	jmp    8025ce <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802449:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244c:	8b 40 0c             	mov    0xc(%eax),%eax
  80244f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802452:	0f 82 6e 01 00 00    	jb     8025c6 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802458:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245b:	8b 40 0c             	mov    0xc(%eax),%eax
  80245e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802461:	0f 85 8a 00 00 00    	jne    8024f1 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802467:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80246b:	75 17                	jne    802484 <alloc_block_FF+0x4e>
  80246d:	83 ec 04             	sub    $0x4,%esp
  802470:	68 10 43 80 00       	push   $0x804310
  802475:	68 93 00 00 00       	push   $0x93
  80247a:	68 67 42 80 00       	push   $0x804267
  80247f:	e8 23 e0 ff ff       	call   8004a7 <_panic>
  802484:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802487:	8b 00                	mov    (%eax),%eax
  802489:	85 c0                	test   %eax,%eax
  80248b:	74 10                	je     80249d <alloc_block_FF+0x67>
  80248d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802490:	8b 00                	mov    (%eax),%eax
  802492:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802495:	8b 52 04             	mov    0x4(%edx),%edx
  802498:	89 50 04             	mov    %edx,0x4(%eax)
  80249b:	eb 0b                	jmp    8024a8 <alloc_block_FF+0x72>
  80249d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a0:	8b 40 04             	mov    0x4(%eax),%eax
  8024a3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8024a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ab:	8b 40 04             	mov    0x4(%eax),%eax
  8024ae:	85 c0                	test   %eax,%eax
  8024b0:	74 0f                	je     8024c1 <alloc_block_FF+0x8b>
  8024b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b5:	8b 40 04             	mov    0x4(%eax),%eax
  8024b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024bb:	8b 12                	mov    (%edx),%edx
  8024bd:	89 10                	mov    %edx,(%eax)
  8024bf:	eb 0a                	jmp    8024cb <alloc_block_FF+0x95>
  8024c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c4:	8b 00                	mov    (%eax),%eax
  8024c6:	a3 38 51 80 00       	mov    %eax,0x805138
  8024cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024de:	a1 44 51 80 00       	mov    0x805144,%eax
  8024e3:	48                   	dec    %eax
  8024e4:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  8024e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ec:	e9 10 01 00 00       	jmp    802601 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8024f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f4:	8b 40 0c             	mov    0xc(%eax),%eax
  8024f7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024fa:	0f 86 c6 00 00 00    	jbe    8025c6 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802500:	a1 48 51 80 00       	mov    0x805148,%eax
  802505:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802508:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250b:	8b 50 08             	mov    0x8(%eax),%edx
  80250e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802511:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802514:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802517:	8b 55 08             	mov    0x8(%ebp),%edx
  80251a:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80251d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802521:	75 17                	jne    80253a <alloc_block_FF+0x104>
  802523:	83 ec 04             	sub    $0x4,%esp
  802526:	68 10 43 80 00       	push   $0x804310
  80252b:	68 9b 00 00 00       	push   $0x9b
  802530:	68 67 42 80 00       	push   $0x804267
  802535:	e8 6d df ff ff       	call   8004a7 <_panic>
  80253a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80253d:	8b 00                	mov    (%eax),%eax
  80253f:	85 c0                	test   %eax,%eax
  802541:	74 10                	je     802553 <alloc_block_FF+0x11d>
  802543:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802546:	8b 00                	mov    (%eax),%eax
  802548:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80254b:	8b 52 04             	mov    0x4(%edx),%edx
  80254e:	89 50 04             	mov    %edx,0x4(%eax)
  802551:	eb 0b                	jmp    80255e <alloc_block_FF+0x128>
  802553:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802556:	8b 40 04             	mov    0x4(%eax),%eax
  802559:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80255e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802561:	8b 40 04             	mov    0x4(%eax),%eax
  802564:	85 c0                	test   %eax,%eax
  802566:	74 0f                	je     802577 <alloc_block_FF+0x141>
  802568:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80256b:	8b 40 04             	mov    0x4(%eax),%eax
  80256e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802571:	8b 12                	mov    (%edx),%edx
  802573:	89 10                	mov    %edx,(%eax)
  802575:	eb 0a                	jmp    802581 <alloc_block_FF+0x14b>
  802577:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80257a:	8b 00                	mov    (%eax),%eax
  80257c:	a3 48 51 80 00       	mov    %eax,0x805148
  802581:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802584:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80258a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80258d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802594:	a1 54 51 80 00       	mov    0x805154,%eax
  802599:	48                   	dec    %eax
  80259a:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  80259f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a2:	8b 50 08             	mov    0x8(%eax),%edx
  8025a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a8:	01 c2                	add    %eax,%edx
  8025aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ad:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8025b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b3:	8b 40 0c             	mov    0xc(%eax),%eax
  8025b6:	2b 45 08             	sub    0x8(%ebp),%eax
  8025b9:	89 c2                	mov    %eax,%edx
  8025bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025be:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8025c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025c4:	eb 3b                	jmp    802601 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8025c6:	a1 40 51 80 00       	mov    0x805140,%eax
  8025cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025d2:	74 07                	je     8025db <alloc_block_FF+0x1a5>
  8025d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d7:	8b 00                	mov    (%eax),%eax
  8025d9:	eb 05                	jmp    8025e0 <alloc_block_FF+0x1aa>
  8025db:	b8 00 00 00 00       	mov    $0x0,%eax
  8025e0:	a3 40 51 80 00       	mov    %eax,0x805140
  8025e5:	a1 40 51 80 00       	mov    0x805140,%eax
  8025ea:	85 c0                	test   %eax,%eax
  8025ec:	0f 85 57 fe ff ff    	jne    802449 <alloc_block_FF+0x13>
  8025f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025f6:	0f 85 4d fe ff ff    	jne    802449 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8025fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802601:	c9                   	leave  
  802602:	c3                   	ret    

00802603 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802603:	55                   	push   %ebp
  802604:	89 e5                	mov    %esp,%ebp
  802606:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802609:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802610:	a1 38 51 80 00       	mov    0x805138,%eax
  802615:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802618:	e9 df 00 00 00       	jmp    8026fc <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  80261d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802620:	8b 40 0c             	mov    0xc(%eax),%eax
  802623:	3b 45 08             	cmp    0x8(%ebp),%eax
  802626:	0f 82 c8 00 00 00    	jb     8026f4 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  80262c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262f:	8b 40 0c             	mov    0xc(%eax),%eax
  802632:	3b 45 08             	cmp    0x8(%ebp),%eax
  802635:	0f 85 8a 00 00 00    	jne    8026c5 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  80263b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80263f:	75 17                	jne    802658 <alloc_block_BF+0x55>
  802641:	83 ec 04             	sub    $0x4,%esp
  802644:	68 10 43 80 00       	push   $0x804310
  802649:	68 b7 00 00 00       	push   $0xb7
  80264e:	68 67 42 80 00       	push   $0x804267
  802653:	e8 4f de ff ff       	call   8004a7 <_panic>
  802658:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265b:	8b 00                	mov    (%eax),%eax
  80265d:	85 c0                	test   %eax,%eax
  80265f:	74 10                	je     802671 <alloc_block_BF+0x6e>
  802661:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802664:	8b 00                	mov    (%eax),%eax
  802666:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802669:	8b 52 04             	mov    0x4(%edx),%edx
  80266c:	89 50 04             	mov    %edx,0x4(%eax)
  80266f:	eb 0b                	jmp    80267c <alloc_block_BF+0x79>
  802671:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802674:	8b 40 04             	mov    0x4(%eax),%eax
  802677:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80267c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267f:	8b 40 04             	mov    0x4(%eax),%eax
  802682:	85 c0                	test   %eax,%eax
  802684:	74 0f                	je     802695 <alloc_block_BF+0x92>
  802686:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802689:	8b 40 04             	mov    0x4(%eax),%eax
  80268c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80268f:	8b 12                	mov    (%edx),%edx
  802691:	89 10                	mov    %edx,(%eax)
  802693:	eb 0a                	jmp    80269f <alloc_block_BF+0x9c>
  802695:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802698:	8b 00                	mov    (%eax),%eax
  80269a:	a3 38 51 80 00       	mov    %eax,0x805138
  80269f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026b2:	a1 44 51 80 00       	mov    0x805144,%eax
  8026b7:	48                   	dec    %eax
  8026b8:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  8026bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c0:	e9 4d 01 00 00       	jmp    802812 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8026c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c8:	8b 40 0c             	mov    0xc(%eax),%eax
  8026cb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026ce:	76 24                	jbe    8026f4 <alloc_block_BF+0xf1>
  8026d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d3:	8b 40 0c             	mov    0xc(%eax),%eax
  8026d6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8026d9:	73 19                	jae    8026f4 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8026db:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8026e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e5:	8b 40 0c             	mov    0xc(%eax),%eax
  8026e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8026eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ee:	8b 40 08             	mov    0x8(%eax),%eax
  8026f1:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8026f4:	a1 40 51 80 00       	mov    0x805140,%eax
  8026f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802700:	74 07                	je     802709 <alloc_block_BF+0x106>
  802702:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802705:	8b 00                	mov    (%eax),%eax
  802707:	eb 05                	jmp    80270e <alloc_block_BF+0x10b>
  802709:	b8 00 00 00 00       	mov    $0x0,%eax
  80270e:	a3 40 51 80 00       	mov    %eax,0x805140
  802713:	a1 40 51 80 00       	mov    0x805140,%eax
  802718:	85 c0                	test   %eax,%eax
  80271a:	0f 85 fd fe ff ff    	jne    80261d <alloc_block_BF+0x1a>
  802720:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802724:	0f 85 f3 fe ff ff    	jne    80261d <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  80272a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80272e:	0f 84 d9 00 00 00    	je     80280d <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802734:	a1 48 51 80 00       	mov    0x805148,%eax
  802739:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  80273c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80273f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802742:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802745:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802748:	8b 55 08             	mov    0x8(%ebp),%edx
  80274b:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  80274e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802752:	75 17                	jne    80276b <alloc_block_BF+0x168>
  802754:	83 ec 04             	sub    $0x4,%esp
  802757:	68 10 43 80 00       	push   $0x804310
  80275c:	68 c7 00 00 00       	push   $0xc7
  802761:	68 67 42 80 00       	push   $0x804267
  802766:	e8 3c dd ff ff       	call   8004a7 <_panic>
  80276b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80276e:	8b 00                	mov    (%eax),%eax
  802770:	85 c0                	test   %eax,%eax
  802772:	74 10                	je     802784 <alloc_block_BF+0x181>
  802774:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802777:	8b 00                	mov    (%eax),%eax
  802779:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80277c:	8b 52 04             	mov    0x4(%edx),%edx
  80277f:	89 50 04             	mov    %edx,0x4(%eax)
  802782:	eb 0b                	jmp    80278f <alloc_block_BF+0x18c>
  802784:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802787:	8b 40 04             	mov    0x4(%eax),%eax
  80278a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80278f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802792:	8b 40 04             	mov    0x4(%eax),%eax
  802795:	85 c0                	test   %eax,%eax
  802797:	74 0f                	je     8027a8 <alloc_block_BF+0x1a5>
  802799:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80279c:	8b 40 04             	mov    0x4(%eax),%eax
  80279f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027a2:	8b 12                	mov    (%edx),%edx
  8027a4:	89 10                	mov    %edx,(%eax)
  8027a6:	eb 0a                	jmp    8027b2 <alloc_block_BF+0x1af>
  8027a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027ab:	8b 00                	mov    (%eax),%eax
  8027ad:	a3 48 51 80 00       	mov    %eax,0x805148
  8027b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027b5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027be:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027c5:	a1 54 51 80 00       	mov    0x805154,%eax
  8027ca:	48                   	dec    %eax
  8027cb:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8027d0:	83 ec 08             	sub    $0x8,%esp
  8027d3:	ff 75 ec             	pushl  -0x14(%ebp)
  8027d6:	68 38 51 80 00       	push   $0x805138
  8027db:	e8 71 f9 ff ff       	call   802151 <find_block>
  8027e0:	83 c4 10             	add    $0x10,%esp
  8027e3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8027e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027e9:	8b 50 08             	mov    0x8(%eax),%edx
  8027ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ef:	01 c2                	add    %eax,%edx
  8027f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027f4:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8027f7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027fa:	8b 40 0c             	mov    0xc(%eax),%eax
  8027fd:	2b 45 08             	sub    0x8(%ebp),%eax
  802800:	89 c2                	mov    %eax,%edx
  802802:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802805:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802808:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80280b:	eb 05                	jmp    802812 <alloc_block_BF+0x20f>
	}
	return NULL;
  80280d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802812:	c9                   	leave  
  802813:	c3                   	ret    

00802814 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802814:	55                   	push   %ebp
  802815:	89 e5                	mov    %esp,%ebp
  802817:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  80281a:	a1 28 50 80 00       	mov    0x805028,%eax
  80281f:	85 c0                	test   %eax,%eax
  802821:	0f 85 de 01 00 00    	jne    802a05 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802827:	a1 38 51 80 00       	mov    0x805138,%eax
  80282c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80282f:	e9 9e 01 00 00       	jmp    8029d2 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802834:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802837:	8b 40 0c             	mov    0xc(%eax),%eax
  80283a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80283d:	0f 82 87 01 00 00    	jb     8029ca <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802843:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802846:	8b 40 0c             	mov    0xc(%eax),%eax
  802849:	3b 45 08             	cmp    0x8(%ebp),%eax
  80284c:	0f 85 95 00 00 00    	jne    8028e7 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802852:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802856:	75 17                	jne    80286f <alloc_block_NF+0x5b>
  802858:	83 ec 04             	sub    $0x4,%esp
  80285b:	68 10 43 80 00       	push   $0x804310
  802860:	68 e0 00 00 00       	push   $0xe0
  802865:	68 67 42 80 00       	push   $0x804267
  80286a:	e8 38 dc ff ff       	call   8004a7 <_panic>
  80286f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802872:	8b 00                	mov    (%eax),%eax
  802874:	85 c0                	test   %eax,%eax
  802876:	74 10                	je     802888 <alloc_block_NF+0x74>
  802878:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287b:	8b 00                	mov    (%eax),%eax
  80287d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802880:	8b 52 04             	mov    0x4(%edx),%edx
  802883:	89 50 04             	mov    %edx,0x4(%eax)
  802886:	eb 0b                	jmp    802893 <alloc_block_NF+0x7f>
  802888:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288b:	8b 40 04             	mov    0x4(%eax),%eax
  80288e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802893:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802896:	8b 40 04             	mov    0x4(%eax),%eax
  802899:	85 c0                	test   %eax,%eax
  80289b:	74 0f                	je     8028ac <alloc_block_NF+0x98>
  80289d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a0:	8b 40 04             	mov    0x4(%eax),%eax
  8028a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028a6:	8b 12                	mov    (%edx),%edx
  8028a8:	89 10                	mov    %edx,(%eax)
  8028aa:	eb 0a                	jmp    8028b6 <alloc_block_NF+0xa2>
  8028ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028af:	8b 00                	mov    (%eax),%eax
  8028b1:	a3 38 51 80 00       	mov    %eax,0x805138
  8028b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028c9:	a1 44 51 80 00       	mov    0x805144,%eax
  8028ce:	48                   	dec    %eax
  8028cf:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  8028d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d7:	8b 40 08             	mov    0x8(%eax),%eax
  8028da:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  8028df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e2:	e9 f8 04 00 00       	jmp    802ddf <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8028e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ea:	8b 40 0c             	mov    0xc(%eax),%eax
  8028ed:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028f0:	0f 86 d4 00 00 00    	jbe    8029ca <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8028f6:	a1 48 51 80 00       	mov    0x805148,%eax
  8028fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8028fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802901:	8b 50 08             	mov    0x8(%eax),%edx
  802904:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802907:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  80290a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80290d:	8b 55 08             	mov    0x8(%ebp),%edx
  802910:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802913:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802917:	75 17                	jne    802930 <alloc_block_NF+0x11c>
  802919:	83 ec 04             	sub    $0x4,%esp
  80291c:	68 10 43 80 00       	push   $0x804310
  802921:	68 e9 00 00 00       	push   $0xe9
  802926:	68 67 42 80 00       	push   $0x804267
  80292b:	e8 77 db ff ff       	call   8004a7 <_panic>
  802930:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802933:	8b 00                	mov    (%eax),%eax
  802935:	85 c0                	test   %eax,%eax
  802937:	74 10                	je     802949 <alloc_block_NF+0x135>
  802939:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80293c:	8b 00                	mov    (%eax),%eax
  80293e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802941:	8b 52 04             	mov    0x4(%edx),%edx
  802944:	89 50 04             	mov    %edx,0x4(%eax)
  802947:	eb 0b                	jmp    802954 <alloc_block_NF+0x140>
  802949:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80294c:	8b 40 04             	mov    0x4(%eax),%eax
  80294f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802954:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802957:	8b 40 04             	mov    0x4(%eax),%eax
  80295a:	85 c0                	test   %eax,%eax
  80295c:	74 0f                	je     80296d <alloc_block_NF+0x159>
  80295e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802961:	8b 40 04             	mov    0x4(%eax),%eax
  802964:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802967:	8b 12                	mov    (%edx),%edx
  802969:	89 10                	mov    %edx,(%eax)
  80296b:	eb 0a                	jmp    802977 <alloc_block_NF+0x163>
  80296d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802970:	8b 00                	mov    (%eax),%eax
  802972:	a3 48 51 80 00       	mov    %eax,0x805148
  802977:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80297a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802980:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802983:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80298a:	a1 54 51 80 00       	mov    0x805154,%eax
  80298f:	48                   	dec    %eax
  802990:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802995:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802998:	8b 40 08             	mov    0x8(%eax),%eax
  80299b:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  8029a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a3:	8b 50 08             	mov    0x8(%eax),%edx
  8029a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a9:	01 c2                	add    %eax,%edx
  8029ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ae:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  8029b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b4:	8b 40 0c             	mov    0xc(%eax),%eax
  8029b7:	2b 45 08             	sub    0x8(%ebp),%eax
  8029ba:	89 c2                	mov    %eax,%edx
  8029bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bf:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  8029c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029c5:	e9 15 04 00 00       	jmp    802ddf <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8029ca:	a1 40 51 80 00       	mov    0x805140,%eax
  8029cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029d6:	74 07                	je     8029df <alloc_block_NF+0x1cb>
  8029d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029db:	8b 00                	mov    (%eax),%eax
  8029dd:	eb 05                	jmp    8029e4 <alloc_block_NF+0x1d0>
  8029df:	b8 00 00 00 00       	mov    $0x0,%eax
  8029e4:	a3 40 51 80 00       	mov    %eax,0x805140
  8029e9:	a1 40 51 80 00       	mov    0x805140,%eax
  8029ee:	85 c0                	test   %eax,%eax
  8029f0:	0f 85 3e fe ff ff    	jne    802834 <alloc_block_NF+0x20>
  8029f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029fa:	0f 85 34 fe ff ff    	jne    802834 <alloc_block_NF+0x20>
  802a00:	e9 d5 03 00 00       	jmp    802dda <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a05:	a1 38 51 80 00       	mov    0x805138,%eax
  802a0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a0d:	e9 b1 01 00 00       	jmp    802bc3 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802a12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a15:	8b 50 08             	mov    0x8(%eax),%edx
  802a18:	a1 28 50 80 00       	mov    0x805028,%eax
  802a1d:	39 c2                	cmp    %eax,%edx
  802a1f:	0f 82 96 01 00 00    	jb     802bbb <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802a25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a28:	8b 40 0c             	mov    0xc(%eax),%eax
  802a2b:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a2e:	0f 82 87 01 00 00    	jb     802bbb <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802a34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a37:	8b 40 0c             	mov    0xc(%eax),%eax
  802a3a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a3d:	0f 85 95 00 00 00    	jne    802ad8 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802a43:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a47:	75 17                	jne    802a60 <alloc_block_NF+0x24c>
  802a49:	83 ec 04             	sub    $0x4,%esp
  802a4c:	68 10 43 80 00       	push   $0x804310
  802a51:	68 fc 00 00 00       	push   $0xfc
  802a56:	68 67 42 80 00       	push   $0x804267
  802a5b:	e8 47 da ff ff       	call   8004a7 <_panic>
  802a60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a63:	8b 00                	mov    (%eax),%eax
  802a65:	85 c0                	test   %eax,%eax
  802a67:	74 10                	je     802a79 <alloc_block_NF+0x265>
  802a69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6c:	8b 00                	mov    (%eax),%eax
  802a6e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a71:	8b 52 04             	mov    0x4(%edx),%edx
  802a74:	89 50 04             	mov    %edx,0x4(%eax)
  802a77:	eb 0b                	jmp    802a84 <alloc_block_NF+0x270>
  802a79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7c:	8b 40 04             	mov    0x4(%eax),%eax
  802a7f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a87:	8b 40 04             	mov    0x4(%eax),%eax
  802a8a:	85 c0                	test   %eax,%eax
  802a8c:	74 0f                	je     802a9d <alloc_block_NF+0x289>
  802a8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a91:	8b 40 04             	mov    0x4(%eax),%eax
  802a94:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a97:	8b 12                	mov    (%edx),%edx
  802a99:	89 10                	mov    %edx,(%eax)
  802a9b:	eb 0a                	jmp    802aa7 <alloc_block_NF+0x293>
  802a9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa0:	8b 00                	mov    (%eax),%eax
  802aa2:	a3 38 51 80 00       	mov    %eax,0x805138
  802aa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aaa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ab0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802aba:	a1 44 51 80 00       	mov    0x805144,%eax
  802abf:	48                   	dec    %eax
  802ac0:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802ac5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac8:	8b 40 08             	mov    0x8(%eax),%eax
  802acb:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802ad0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad3:	e9 07 03 00 00       	jmp    802ddf <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802ad8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802adb:	8b 40 0c             	mov    0xc(%eax),%eax
  802ade:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ae1:	0f 86 d4 00 00 00    	jbe    802bbb <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802ae7:	a1 48 51 80 00       	mov    0x805148,%eax
  802aec:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802aef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af2:	8b 50 08             	mov    0x8(%eax),%edx
  802af5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802af8:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802afb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802afe:	8b 55 08             	mov    0x8(%ebp),%edx
  802b01:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802b04:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802b08:	75 17                	jne    802b21 <alloc_block_NF+0x30d>
  802b0a:	83 ec 04             	sub    $0x4,%esp
  802b0d:	68 10 43 80 00       	push   $0x804310
  802b12:	68 04 01 00 00       	push   $0x104
  802b17:	68 67 42 80 00       	push   $0x804267
  802b1c:	e8 86 d9 ff ff       	call   8004a7 <_panic>
  802b21:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b24:	8b 00                	mov    (%eax),%eax
  802b26:	85 c0                	test   %eax,%eax
  802b28:	74 10                	je     802b3a <alloc_block_NF+0x326>
  802b2a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b2d:	8b 00                	mov    (%eax),%eax
  802b2f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b32:	8b 52 04             	mov    0x4(%edx),%edx
  802b35:	89 50 04             	mov    %edx,0x4(%eax)
  802b38:	eb 0b                	jmp    802b45 <alloc_block_NF+0x331>
  802b3a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b3d:	8b 40 04             	mov    0x4(%eax),%eax
  802b40:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b45:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b48:	8b 40 04             	mov    0x4(%eax),%eax
  802b4b:	85 c0                	test   %eax,%eax
  802b4d:	74 0f                	je     802b5e <alloc_block_NF+0x34a>
  802b4f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b52:	8b 40 04             	mov    0x4(%eax),%eax
  802b55:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b58:	8b 12                	mov    (%edx),%edx
  802b5a:	89 10                	mov    %edx,(%eax)
  802b5c:	eb 0a                	jmp    802b68 <alloc_block_NF+0x354>
  802b5e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b61:	8b 00                	mov    (%eax),%eax
  802b63:	a3 48 51 80 00       	mov    %eax,0x805148
  802b68:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b6b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b71:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b74:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b7b:	a1 54 51 80 00       	mov    0x805154,%eax
  802b80:	48                   	dec    %eax
  802b81:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802b86:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b89:	8b 40 08             	mov    0x8(%eax),%eax
  802b8c:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802b91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b94:	8b 50 08             	mov    0x8(%eax),%edx
  802b97:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9a:	01 c2                	add    %eax,%edx
  802b9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9f:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802ba2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba5:	8b 40 0c             	mov    0xc(%eax),%eax
  802ba8:	2b 45 08             	sub    0x8(%ebp),%eax
  802bab:	89 c2                	mov    %eax,%edx
  802bad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb0:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802bb3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bb6:	e9 24 02 00 00       	jmp    802ddf <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802bbb:	a1 40 51 80 00       	mov    0x805140,%eax
  802bc0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bc3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bc7:	74 07                	je     802bd0 <alloc_block_NF+0x3bc>
  802bc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bcc:	8b 00                	mov    (%eax),%eax
  802bce:	eb 05                	jmp    802bd5 <alloc_block_NF+0x3c1>
  802bd0:	b8 00 00 00 00       	mov    $0x0,%eax
  802bd5:	a3 40 51 80 00       	mov    %eax,0x805140
  802bda:	a1 40 51 80 00       	mov    0x805140,%eax
  802bdf:	85 c0                	test   %eax,%eax
  802be1:	0f 85 2b fe ff ff    	jne    802a12 <alloc_block_NF+0x1fe>
  802be7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802beb:	0f 85 21 fe ff ff    	jne    802a12 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802bf1:	a1 38 51 80 00       	mov    0x805138,%eax
  802bf6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bf9:	e9 ae 01 00 00       	jmp    802dac <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802bfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c01:	8b 50 08             	mov    0x8(%eax),%edx
  802c04:	a1 28 50 80 00       	mov    0x805028,%eax
  802c09:	39 c2                	cmp    %eax,%edx
  802c0b:	0f 83 93 01 00 00    	jae    802da4 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802c11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c14:	8b 40 0c             	mov    0xc(%eax),%eax
  802c17:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c1a:	0f 82 84 01 00 00    	jb     802da4 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802c20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c23:	8b 40 0c             	mov    0xc(%eax),%eax
  802c26:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c29:	0f 85 95 00 00 00    	jne    802cc4 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802c2f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c33:	75 17                	jne    802c4c <alloc_block_NF+0x438>
  802c35:	83 ec 04             	sub    $0x4,%esp
  802c38:	68 10 43 80 00       	push   $0x804310
  802c3d:	68 14 01 00 00       	push   $0x114
  802c42:	68 67 42 80 00       	push   $0x804267
  802c47:	e8 5b d8 ff ff       	call   8004a7 <_panic>
  802c4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4f:	8b 00                	mov    (%eax),%eax
  802c51:	85 c0                	test   %eax,%eax
  802c53:	74 10                	je     802c65 <alloc_block_NF+0x451>
  802c55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c58:	8b 00                	mov    (%eax),%eax
  802c5a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c5d:	8b 52 04             	mov    0x4(%edx),%edx
  802c60:	89 50 04             	mov    %edx,0x4(%eax)
  802c63:	eb 0b                	jmp    802c70 <alloc_block_NF+0x45c>
  802c65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c68:	8b 40 04             	mov    0x4(%eax),%eax
  802c6b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c73:	8b 40 04             	mov    0x4(%eax),%eax
  802c76:	85 c0                	test   %eax,%eax
  802c78:	74 0f                	je     802c89 <alloc_block_NF+0x475>
  802c7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7d:	8b 40 04             	mov    0x4(%eax),%eax
  802c80:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c83:	8b 12                	mov    (%edx),%edx
  802c85:	89 10                	mov    %edx,(%eax)
  802c87:	eb 0a                	jmp    802c93 <alloc_block_NF+0x47f>
  802c89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8c:	8b 00                	mov    (%eax),%eax
  802c8e:	a3 38 51 80 00       	mov    %eax,0x805138
  802c93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c96:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ca6:	a1 44 51 80 00       	mov    0x805144,%eax
  802cab:	48                   	dec    %eax
  802cac:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802cb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb4:	8b 40 08             	mov    0x8(%eax),%eax
  802cb7:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802cbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbf:	e9 1b 01 00 00       	jmp    802ddf <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802cc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc7:	8b 40 0c             	mov    0xc(%eax),%eax
  802cca:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ccd:	0f 86 d1 00 00 00    	jbe    802da4 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802cd3:	a1 48 51 80 00       	mov    0x805148,%eax
  802cd8:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802cdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cde:	8b 50 08             	mov    0x8(%eax),%edx
  802ce1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ce4:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802ce7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cea:	8b 55 08             	mov    0x8(%ebp),%edx
  802ced:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802cf0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802cf4:	75 17                	jne    802d0d <alloc_block_NF+0x4f9>
  802cf6:	83 ec 04             	sub    $0x4,%esp
  802cf9:	68 10 43 80 00       	push   $0x804310
  802cfe:	68 1c 01 00 00       	push   $0x11c
  802d03:	68 67 42 80 00       	push   $0x804267
  802d08:	e8 9a d7 ff ff       	call   8004a7 <_panic>
  802d0d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d10:	8b 00                	mov    (%eax),%eax
  802d12:	85 c0                	test   %eax,%eax
  802d14:	74 10                	je     802d26 <alloc_block_NF+0x512>
  802d16:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d19:	8b 00                	mov    (%eax),%eax
  802d1b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d1e:	8b 52 04             	mov    0x4(%edx),%edx
  802d21:	89 50 04             	mov    %edx,0x4(%eax)
  802d24:	eb 0b                	jmp    802d31 <alloc_block_NF+0x51d>
  802d26:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d29:	8b 40 04             	mov    0x4(%eax),%eax
  802d2c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d31:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d34:	8b 40 04             	mov    0x4(%eax),%eax
  802d37:	85 c0                	test   %eax,%eax
  802d39:	74 0f                	je     802d4a <alloc_block_NF+0x536>
  802d3b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d3e:	8b 40 04             	mov    0x4(%eax),%eax
  802d41:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d44:	8b 12                	mov    (%edx),%edx
  802d46:	89 10                	mov    %edx,(%eax)
  802d48:	eb 0a                	jmp    802d54 <alloc_block_NF+0x540>
  802d4a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d4d:	8b 00                	mov    (%eax),%eax
  802d4f:	a3 48 51 80 00       	mov    %eax,0x805148
  802d54:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d57:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d60:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d67:	a1 54 51 80 00       	mov    0x805154,%eax
  802d6c:	48                   	dec    %eax
  802d6d:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802d72:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d75:	8b 40 08             	mov    0x8(%eax),%eax
  802d78:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802d7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d80:	8b 50 08             	mov    0x8(%eax),%edx
  802d83:	8b 45 08             	mov    0x8(%ebp),%eax
  802d86:	01 c2                	add    %eax,%edx
  802d88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8b:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802d8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d91:	8b 40 0c             	mov    0xc(%eax),%eax
  802d94:	2b 45 08             	sub    0x8(%ebp),%eax
  802d97:	89 c2                	mov    %eax,%edx
  802d99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9c:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802d9f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802da2:	eb 3b                	jmp    802ddf <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802da4:	a1 40 51 80 00       	mov    0x805140,%eax
  802da9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802dac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802db0:	74 07                	je     802db9 <alloc_block_NF+0x5a5>
  802db2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db5:	8b 00                	mov    (%eax),%eax
  802db7:	eb 05                	jmp    802dbe <alloc_block_NF+0x5aa>
  802db9:	b8 00 00 00 00       	mov    $0x0,%eax
  802dbe:	a3 40 51 80 00       	mov    %eax,0x805140
  802dc3:	a1 40 51 80 00       	mov    0x805140,%eax
  802dc8:	85 c0                	test   %eax,%eax
  802dca:	0f 85 2e fe ff ff    	jne    802bfe <alloc_block_NF+0x3ea>
  802dd0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dd4:	0f 85 24 fe ff ff    	jne    802bfe <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802dda:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ddf:	c9                   	leave  
  802de0:	c3                   	ret    

00802de1 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802de1:	55                   	push   %ebp
  802de2:	89 e5                	mov    %esp,%ebp
  802de4:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802de7:	a1 38 51 80 00       	mov    0x805138,%eax
  802dec:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802def:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802df4:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802df7:	a1 38 51 80 00       	mov    0x805138,%eax
  802dfc:	85 c0                	test   %eax,%eax
  802dfe:	74 14                	je     802e14 <insert_sorted_with_merge_freeList+0x33>
  802e00:	8b 45 08             	mov    0x8(%ebp),%eax
  802e03:	8b 50 08             	mov    0x8(%eax),%edx
  802e06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e09:	8b 40 08             	mov    0x8(%eax),%eax
  802e0c:	39 c2                	cmp    %eax,%edx
  802e0e:	0f 87 9b 01 00 00    	ja     802faf <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802e14:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e18:	75 17                	jne    802e31 <insert_sorted_with_merge_freeList+0x50>
  802e1a:	83 ec 04             	sub    $0x4,%esp
  802e1d:	68 44 42 80 00       	push   $0x804244
  802e22:	68 38 01 00 00       	push   $0x138
  802e27:	68 67 42 80 00       	push   $0x804267
  802e2c:	e8 76 d6 ff ff       	call   8004a7 <_panic>
  802e31:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802e37:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3a:	89 10                	mov    %edx,(%eax)
  802e3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3f:	8b 00                	mov    (%eax),%eax
  802e41:	85 c0                	test   %eax,%eax
  802e43:	74 0d                	je     802e52 <insert_sorted_with_merge_freeList+0x71>
  802e45:	a1 38 51 80 00       	mov    0x805138,%eax
  802e4a:	8b 55 08             	mov    0x8(%ebp),%edx
  802e4d:	89 50 04             	mov    %edx,0x4(%eax)
  802e50:	eb 08                	jmp    802e5a <insert_sorted_with_merge_freeList+0x79>
  802e52:	8b 45 08             	mov    0x8(%ebp),%eax
  802e55:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5d:	a3 38 51 80 00       	mov    %eax,0x805138
  802e62:	8b 45 08             	mov    0x8(%ebp),%eax
  802e65:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e6c:	a1 44 51 80 00       	mov    0x805144,%eax
  802e71:	40                   	inc    %eax
  802e72:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802e77:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e7b:	0f 84 a8 06 00 00    	je     803529 <insert_sorted_with_merge_freeList+0x748>
  802e81:	8b 45 08             	mov    0x8(%ebp),%eax
  802e84:	8b 50 08             	mov    0x8(%eax),%edx
  802e87:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8a:	8b 40 0c             	mov    0xc(%eax),%eax
  802e8d:	01 c2                	add    %eax,%edx
  802e8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e92:	8b 40 08             	mov    0x8(%eax),%eax
  802e95:	39 c2                	cmp    %eax,%edx
  802e97:	0f 85 8c 06 00 00    	jne    803529 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802e9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea0:	8b 50 0c             	mov    0xc(%eax),%edx
  802ea3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ea6:	8b 40 0c             	mov    0xc(%eax),%eax
  802ea9:	01 c2                	add    %eax,%edx
  802eab:	8b 45 08             	mov    0x8(%ebp),%eax
  802eae:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802eb1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802eb5:	75 17                	jne    802ece <insert_sorted_with_merge_freeList+0xed>
  802eb7:	83 ec 04             	sub    $0x4,%esp
  802eba:	68 10 43 80 00       	push   $0x804310
  802ebf:	68 3c 01 00 00       	push   $0x13c
  802ec4:	68 67 42 80 00       	push   $0x804267
  802ec9:	e8 d9 d5 ff ff       	call   8004a7 <_panic>
  802ece:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ed1:	8b 00                	mov    (%eax),%eax
  802ed3:	85 c0                	test   %eax,%eax
  802ed5:	74 10                	je     802ee7 <insert_sorted_with_merge_freeList+0x106>
  802ed7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eda:	8b 00                	mov    (%eax),%eax
  802edc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802edf:	8b 52 04             	mov    0x4(%edx),%edx
  802ee2:	89 50 04             	mov    %edx,0x4(%eax)
  802ee5:	eb 0b                	jmp    802ef2 <insert_sorted_with_merge_freeList+0x111>
  802ee7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eea:	8b 40 04             	mov    0x4(%eax),%eax
  802eed:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ef2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ef5:	8b 40 04             	mov    0x4(%eax),%eax
  802ef8:	85 c0                	test   %eax,%eax
  802efa:	74 0f                	je     802f0b <insert_sorted_with_merge_freeList+0x12a>
  802efc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eff:	8b 40 04             	mov    0x4(%eax),%eax
  802f02:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f05:	8b 12                	mov    (%edx),%edx
  802f07:	89 10                	mov    %edx,(%eax)
  802f09:	eb 0a                	jmp    802f15 <insert_sorted_with_merge_freeList+0x134>
  802f0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f0e:	8b 00                	mov    (%eax),%eax
  802f10:	a3 38 51 80 00       	mov    %eax,0x805138
  802f15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f18:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f21:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f28:	a1 44 51 80 00       	mov    0x805144,%eax
  802f2d:	48                   	dec    %eax
  802f2e:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802f33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f36:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802f3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f40:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802f47:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f4b:	75 17                	jne    802f64 <insert_sorted_with_merge_freeList+0x183>
  802f4d:	83 ec 04             	sub    $0x4,%esp
  802f50:	68 44 42 80 00       	push   $0x804244
  802f55:	68 3f 01 00 00       	push   $0x13f
  802f5a:	68 67 42 80 00       	push   $0x804267
  802f5f:	e8 43 d5 ff ff       	call   8004a7 <_panic>
  802f64:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802f6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f6d:	89 10                	mov    %edx,(%eax)
  802f6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f72:	8b 00                	mov    (%eax),%eax
  802f74:	85 c0                	test   %eax,%eax
  802f76:	74 0d                	je     802f85 <insert_sorted_with_merge_freeList+0x1a4>
  802f78:	a1 48 51 80 00       	mov    0x805148,%eax
  802f7d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f80:	89 50 04             	mov    %edx,0x4(%eax)
  802f83:	eb 08                	jmp    802f8d <insert_sorted_with_merge_freeList+0x1ac>
  802f85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f88:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f90:	a3 48 51 80 00       	mov    %eax,0x805148
  802f95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f98:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f9f:	a1 54 51 80 00       	mov    0x805154,%eax
  802fa4:	40                   	inc    %eax
  802fa5:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802faa:	e9 7a 05 00 00       	jmp    803529 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802faf:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb2:	8b 50 08             	mov    0x8(%eax),%edx
  802fb5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fb8:	8b 40 08             	mov    0x8(%eax),%eax
  802fbb:	39 c2                	cmp    %eax,%edx
  802fbd:	0f 82 14 01 00 00    	jb     8030d7 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802fc3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fc6:	8b 50 08             	mov    0x8(%eax),%edx
  802fc9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fcc:	8b 40 0c             	mov    0xc(%eax),%eax
  802fcf:	01 c2                	add    %eax,%edx
  802fd1:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd4:	8b 40 08             	mov    0x8(%eax),%eax
  802fd7:	39 c2                	cmp    %eax,%edx
  802fd9:	0f 85 90 00 00 00    	jne    80306f <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802fdf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fe2:	8b 50 0c             	mov    0xc(%eax),%edx
  802fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe8:	8b 40 0c             	mov    0xc(%eax),%eax
  802feb:	01 c2                	add    %eax,%edx
  802fed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ff0:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802ff3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802ffd:	8b 45 08             	mov    0x8(%ebp),%eax
  803000:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803007:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80300b:	75 17                	jne    803024 <insert_sorted_with_merge_freeList+0x243>
  80300d:	83 ec 04             	sub    $0x4,%esp
  803010:	68 44 42 80 00       	push   $0x804244
  803015:	68 49 01 00 00       	push   $0x149
  80301a:	68 67 42 80 00       	push   $0x804267
  80301f:	e8 83 d4 ff ff       	call   8004a7 <_panic>
  803024:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80302a:	8b 45 08             	mov    0x8(%ebp),%eax
  80302d:	89 10                	mov    %edx,(%eax)
  80302f:	8b 45 08             	mov    0x8(%ebp),%eax
  803032:	8b 00                	mov    (%eax),%eax
  803034:	85 c0                	test   %eax,%eax
  803036:	74 0d                	je     803045 <insert_sorted_with_merge_freeList+0x264>
  803038:	a1 48 51 80 00       	mov    0x805148,%eax
  80303d:	8b 55 08             	mov    0x8(%ebp),%edx
  803040:	89 50 04             	mov    %edx,0x4(%eax)
  803043:	eb 08                	jmp    80304d <insert_sorted_with_merge_freeList+0x26c>
  803045:	8b 45 08             	mov    0x8(%ebp),%eax
  803048:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80304d:	8b 45 08             	mov    0x8(%ebp),%eax
  803050:	a3 48 51 80 00       	mov    %eax,0x805148
  803055:	8b 45 08             	mov    0x8(%ebp),%eax
  803058:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80305f:	a1 54 51 80 00       	mov    0x805154,%eax
  803064:	40                   	inc    %eax
  803065:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80306a:	e9 bb 04 00 00       	jmp    80352a <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  80306f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803073:	75 17                	jne    80308c <insert_sorted_with_merge_freeList+0x2ab>
  803075:	83 ec 04             	sub    $0x4,%esp
  803078:	68 b8 42 80 00       	push   $0x8042b8
  80307d:	68 4c 01 00 00       	push   $0x14c
  803082:	68 67 42 80 00       	push   $0x804267
  803087:	e8 1b d4 ff ff       	call   8004a7 <_panic>
  80308c:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803092:	8b 45 08             	mov    0x8(%ebp),%eax
  803095:	89 50 04             	mov    %edx,0x4(%eax)
  803098:	8b 45 08             	mov    0x8(%ebp),%eax
  80309b:	8b 40 04             	mov    0x4(%eax),%eax
  80309e:	85 c0                	test   %eax,%eax
  8030a0:	74 0c                	je     8030ae <insert_sorted_with_merge_freeList+0x2cd>
  8030a2:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8030a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8030aa:	89 10                	mov    %edx,(%eax)
  8030ac:	eb 08                	jmp    8030b6 <insert_sorted_with_merge_freeList+0x2d5>
  8030ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b1:	a3 38 51 80 00       	mov    %eax,0x805138
  8030b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030be:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030c7:	a1 44 51 80 00       	mov    0x805144,%eax
  8030cc:	40                   	inc    %eax
  8030cd:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8030d2:	e9 53 04 00 00       	jmp    80352a <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8030d7:	a1 38 51 80 00       	mov    0x805138,%eax
  8030dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030df:	e9 15 04 00 00       	jmp    8034f9 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  8030e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e7:	8b 00                	mov    (%eax),%eax
  8030e9:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  8030ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ef:	8b 50 08             	mov    0x8(%eax),%edx
  8030f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f5:	8b 40 08             	mov    0x8(%eax),%eax
  8030f8:	39 c2                	cmp    %eax,%edx
  8030fa:	0f 86 f1 03 00 00    	jbe    8034f1 <insert_sorted_with_merge_freeList+0x710>
  803100:	8b 45 08             	mov    0x8(%ebp),%eax
  803103:	8b 50 08             	mov    0x8(%eax),%edx
  803106:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803109:	8b 40 08             	mov    0x8(%eax),%eax
  80310c:	39 c2                	cmp    %eax,%edx
  80310e:	0f 83 dd 03 00 00    	jae    8034f1 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803114:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803117:	8b 50 08             	mov    0x8(%eax),%edx
  80311a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80311d:	8b 40 0c             	mov    0xc(%eax),%eax
  803120:	01 c2                	add    %eax,%edx
  803122:	8b 45 08             	mov    0x8(%ebp),%eax
  803125:	8b 40 08             	mov    0x8(%eax),%eax
  803128:	39 c2                	cmp    %eax,%edx
  80312a:	0f 85 b9 01 00 00    	jne    8032e9 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803130:	8b 45 08             	mov    0x8(%ebp),%eax
  803133:	8b 50 08             	mov    0x8(%eax),%edx
  803136:	8b 45 08             	mov    0x8(%ebp),%eax
  803139:	8b 40 0c             	mov    0xc(%eax),%eax
  80313c:	01 c2                	add    %eax,%edx
  80313e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803141:	8b 40 08             	mov    0x8(%eax),%eax
  803144:	39 c2                	cmp    %eax,%edx
  803146:	0f 85 0d 01 00 00    	jne    803259 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  80314c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80314f:	8b 50 0c             	mov    0xc(%eax),%edx
  803152:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803155:	8b 40 0c             	mov    0xc(%eax),%eax
  803158:	01 c2                	add    %eax,%edx
  80315a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80315d:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803160:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803164:	75 17                	jne    80317d <insert_sorted_with_merge_freeList+0x39c>
  803166:	83 ec 04             	sub    $0x4,%esp
  803169:	68 10 43 80 00       	push   $0x804310
  80316e:	68 5c 01 00 00       	push   $0x15c
  803173:	68 67 42 80 00       	push   $0x804267
  803178:	e8 2a d3 ff ff       	call   8004a7 <_panic>
  80317d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803180:	8b 00                	mov    (%eax),%eax
  803182:	85 c0                	test   %eax,%eax
  803184:	74 10                	je     803196 <insert_sorted_with_merge_freeList+0x3b5>
  803186:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803189:	8b 00                	mov    (%eax),%eax
  80318b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80318e:	8b 52 04             	mov    0x4(%edx),%edx
  803191:	89 50 04             	mov    %edx,0x4(%eax)
  803194:	eb 0b                	jmp    8031a1 <insert_sorted_with_merge_freeList+0x3c0>
  803196:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803199:	8b 40 04             	mov    0x4(%eax),%eax
  80319c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031a4:	8b 40 04             	mov    0x4(%eax),%eax
  8031a7:	85 c0                	test   %eax,%eax
  8031a9:	74 0f                	je     8031ba <insert_sorted_with_merge_freeList+0x3d9>
  8031ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ae:	8b 40 04             	mov    0x4(%eax),%eax
  8031b1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031b4:	8b 12                	mov    (%edx),%edx
  8031b6:	89 10                	mov    %edx,(%eax)
  8031b8:	eb 0a                	jmp    8031c4 <insert_sorted_with_merge_freeList+0x3e3>
  8031ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031bd:	8b 00                	mov    (%eax),%eax
  8031bf:	a3 38 51 80 00       	mov    %eax,0x805138
  8031c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031d7:	a1 44 51 80 00       	mov    0x805144,%eax
  8031dc:	48                   	dec    %eax
  8031dd:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  8031e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8031ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ef:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8031f6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031fa:	75 17                	jne    803213 <insert_sorted_with_merge_freeList+0x432>
  8031fc:	83 ec 04             	sub    $0x4,%esp
  8031ff:	68 44 42 80 00       	push   $0x804244
  803204:	68 5f 01 00 00       	push   $0x15f
  803209:	68 67 42 80 00       	push   $0x804267
  80320e:	e8 94 d2 ff ff       	call   8004a7 <_panic>
  803213:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803219:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80321c:	89 10                	mov    %edx,(%eax)
  80321e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803221:	8b 00                	mov    (%eax),%eax
  803223:	85 c0                	test   %eax,%eax
  803225:	74 0d                	je     803234 <insert_sorted_with_merge_freeList+0x453>
  803227:	a1 48 51 80 00       	mov    0x805148,%eax
  80322c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80322f:	89 50 04             	mov    %edx,0x4(%eax)
  803232:	eb 08                	jmp    80323c <insert_sorted_with_merge_freeList+0x45b>
  803234:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803237:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80323c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80323f:	a3 48 51 80 00       	mov    %eax,0x805148
  803244:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803247:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80324e:	a1 54 51 80 00       	mov    0x805154,%eax
  803253:	40                   	inc    %eax
  803254:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803259:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80325c:	8b 50 0c             	mov    0xc(%eax),%edx
  80325f:	8b 45 08             	mov    0x8(%ebp),%eax
  803262:	8b 40 0c             	mov    0xc(%eax),%eax
  803265:	01 c2                	add    %eax,%edx
  803267:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80326a:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  80326d:	8b 45 08             	mov    0x8(%ebp),%eax
  803270:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803277:	8b 45 08             	mov    0x8(%ebp),%eax
  80327a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803281:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803285:	75 17                	jne    80329e <insert_sorted_with_merge_freeList+0x4bd>
  803287:	83 ec 04             	sub    $0x4,%esp
  80328a:	68 44 42 80 00       	push   $0x804244
  80328f:	68 64 01 00 00       	push   $0x164
  803294:	68 67 42 80 00       	push   $0x804267
  803299:	e8 09 d2 ff ff       	call   8004a7 <_panic>
  80329e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8032a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a7:	89 10                	mov    %edx,(%eax)
  8032a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ac:	8b 00                	mov    (%eax),%eax
  8032ae:	85 c0                	test   %eax,%eax
  8032b0:	74 0d                	je     8032bf <insert_sorted_with_merge_freeList+0x4de>
  8032b2:	a1 48 51 80 00       	mov    0x805148,%eax
  8032b7:	8b 55 08             	mov    0x8(%ebp),%edx
  8032ba:	89 50 04             	mov    %edx,0x4(%eax)
  8032bd:	eb 08                	jmp    8032c7 <insert_sorted_with_merge_freeList+0x4e6>
  8032bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ca:	a3 48 51 80 00       	mov    %eax,0x805148
  8032cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032d9:	a1 54 51 80 00       	mov    0x805154,%eax
  8032de:	40                   	inc    %eax
  8032df:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8032e4:	e9 41 02 00 00       	jmp    80352a <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8032e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ec:	8b 50 08             	mov    0x8(%eax),%edx
  8032ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f2:	8b 40 0c             	mov    0xc(%eax),%eax
  8032f5:	01 c2                	add    %eax,%edx
  8032f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032fa:	8b 40 08             	mov    0x8(%eax),%eax
  8032fd:	39 c2                	cmp    %eax,%edx
  8032ff:	0f 85 7c 01 00 00    	jne    803481 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803305:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803309:	74 06                	je     803311 <insert_sorted_with_merge_freeList+0x530>
  80330b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80330f:	75 17                	jne    803328 <insert_sorted_with_merge_freeList+0x547>
  803311:	83 ec 04             	sub    $0x4,%esp
  803314:	68 80 42 80 00       	push   $0x804280
  803319:	68 69 01 00 00       	push   $0x169
  80331e:	68 67 42 80 00       	push   $0x804267
  803323:	e8 7f d1 ff ff       	call   8004a7 <_panic>
  803328:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80332b:	8b 50 04             	mov    0x4(%eax),%edx
  80332e:	8b 45 08             	mov    0x8(%ebp),%eax
  803331:	89 50 04             	mov    %edx,0x4(%eax)
  803334:	8b 45 08             	mov    0x8(%ebp),%eax
  803337:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80333a:	89 10                	mov    %edx,(%eax)
  80333c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80333f:	8b 40 04             	mov    0x4(%eax),%eax
  803342:	85 c0                	test   %eax,%eax
  803344:	74 0d                	je     803353 <insert_sorted_with_merge_freeList+0x572>
  803346:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803349:	8b 40 04             	mov    0x4(%eax),%eax
  80334c:	8b 55 08             	mov    0x8(%ebp),%edx
  80334f:	89 10                	mov    %edx,(%eax)
  803351:	eb 08                	jmp    80335b <insert_sorted_with_merge_freeList+0x57a>
  803353:	8b 45 08             	mov    0x8(%ebp),%eax
  803356:	a3 38 51 80 00       	mov    %eax,0x805138
  80335b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80335e:	8b 55 08             	mov    0x8(%ebp),%edx
  803361:	89 50 04             	mov    %edx,0x4(%eax)
  803364:	a1 44 51 80 00       	mov    0x805144,%eax
  803369:	40                   	inc    %eax
  80336a:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  80336f:	8b 45 08             	mov    0x8(%ebp),%eax
  803372:	8b 50 0c             	mov    0xc(%eax),%edx
  803375:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803378:	8b 40 0c             	mov    0xc(%eax),%eax
  80337b:	01 c2                	add    %eax,%edx
  80337d:	8b 45 08             	mov    0x8(%ebp),%eax
  803380:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803383:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803387:	75 17                	jne    8033a0 <insert_sorted_with_merge_freeList+0x5bf>
  803389:	83 ec 04             	sub    $0x4,%esp
  80338c:	68 10 43 80 00       	push   $0x804310
  803391:	68 6b 01 00 00       	push   $0x16b
  803396:	68 67 42 80 00       	push   $0x804267
  80339b:	e8 07 d1 ff ff       	call   8004a7 <_panic>
  8033a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033a3:	8b 00                	mov    (%eax),%eax
  8033a5:	85 c0                	test   %eax,%eax
  8033a7:	74 10                	je     8033b9 <insert_sorted_with_merge_freeList+0x5d8>
  8033a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033ac:	8b 00                	mov    (%eax),%eax
  8033ae:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033b1:	8b 52 04             	mov    0x4(%edx),%edx
  8033b4:	89 50 04             	mov    %edx,0x4(%eax)
  8033b7:	eb 0b                	jmp    8033c4 <insert_sorted_with_merge_freeList+0x5e3>
  8033b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033bc:	8b 40 04             	mov    0x4(%eax),%eax
  8033bf:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8033c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033c7:	8b 40 04             	mov    0x4(%eax),%eax
  8033ca:	85 c0                	test   %eax,%eax
  8033cc:	74 0f                	je     8033dd <insert_sorted_with_merge_freeList+0x5fc>
  8033ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033d1:	8b 40 04             	mov    0x4(%eax),%eax
  8033d4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033d7:	8b 12                	mov    (%edx),%edx
  8033d9:	89 10                	mov    %edx,(%eax)
  8033db:	eb 0a                	jmp    8033e7 <insert_sorted_with_merge_freeList+0x606>
  8033dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033e0:	8b 00                	mov    (%eax),%eax
  8033e2:	a3 38 51 80 00       	mov    %eax,0x805138
  8033e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033ea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033f3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033fa:	a1 44 51 80 00       	mov    0x805144,%eax
  8033ff:	48                   	dec    %eax
  803400:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803405:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803408:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  80340f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803412:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803419:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80341d:	75 17                	jne    803436 <insert_sorted_with_merge_freeList+0x655>
  80341f:	83 ec 04             	sub    $0x4,%esp
  803422:	68 44 42 80 00       	push   $0x804244
  803427:	68 6e 01 00 00       	push   $0x16e
  80342c:	68 67 42 80 00       	push   $0x804267
  803431:	e8 71 d0 ff ff       	call   8004a7 <_panic>
  803436:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80343c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80343f:	89 10                	mov    %edx,(%eax)
  803441:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803444:	8b 00                	mov    (%eax),%eax
  803446:	85 c0                	test   %eax,%eax
  803448:	74 0d                	je     803457 <insert_sorted_with_merge_freeList+0x676>
  80344a:	a1 48 51 80 00       	mov    0x805148,%eax
  80344f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803452:	89 50 04             	mov    %edx,0x4(%eax)
  803455:	eb 08                	jmp    80345f <insert_sorted_with_merge_freeList+0x67e>
  803457:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80345a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80345f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803462:	a3 48 51 80 00       	mov    %eax,0x805148
  803467:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80346a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803471:	a1 54 51 80 00       	mov    0x805154,%eax
  803476:	40                   	inc    %eax
  803477:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80347c:	e9 a9 00 00 00       	jmp    80352a <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803481:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803485:	74 06                	je     80348d <insert_sorted_with_merge_freeList+0x6ac>
  803487:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80348b:	75 17                	jne    8034a4 <insert_sorted_with_merge_freeList+0x6c3>
  80348d:	83 ec 04             	sub    $0x4,%esp
  803490:	68 dc 42 80 00       	push   $0x8042dc
  803495:	68 73 01 00 00       	push   $0x173
  80349a:	68 67 42 80 00       	push   $0x804267
  80349f:	e8 03 d0 ff ff       	call   8004a7 <_panic>
  8034a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a7:	8b 10                	mov    (%eax),%edx
  8034a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ac:	89 10                	mov    %edx,(%eax)
  8034ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b1:	8b 00                	mov    (%eax),%eax
  8034b3:	85 c0                	test   %eax,%eax
  8034b5:	74 0b                	je     8034c2 <insert_sorted_with_merge_freeList+0x6e1>
  8034b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ba:	8b 00                	mov    (%eax),%eax
  8034bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8034bf:	89 50 04             	mov    %edx,0x4(%eax)
  8034c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8034c8:	89 10                	mov    %edx,(%eax)
  8034ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8034cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034d0:	89 50 04             	mov    %edx,0x4(%eax)
  8034d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d6:	8b 00                	mov    (%eax),%eax
  8034d8:	85 c0                	test   %eax,%eax
  8034da:	75 08                	jne    8034e4 <insert_sorted_with_merge_freeList+0x703>
  8034dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8034df:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8034e4:	a1 44 51 80 00       	mov    0x805144,%eax
  8034e9:	40                   	inc    %eax
  8034ea:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  8034ef:	eb 39                	jmp    80352a <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8034f1:	a1 40 51 80 00       	mov    0x805140,%eax
  8034f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8034f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034fd:	74 07                	je     803506 <insert_sorted_with_merge_freeList+0x725>
  8034ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803502:	8b 00                	mov    (%eax),%eax
  803504:	eb 05                	jmp    80350b <insert_sorted_with_merge_freeList+0x72a>
  803506:	b8 00 00 00 00       	mov    $0x0,%eax
  80350b:	a3 40 51 80 00       	mov    %eax,0x805140
  803510:	a1 40 51 80 00       	mov    0x805140,%eax
  803515:	85 c0                	test   %eax,%eax
  803517:	0f 85 c7 fb ff ff    	jne    8030e4 <insert_sorted_with_merge_freeList+0x303>
  80351d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803521:	0f 85 bd fb ff ff    	jne    8030e4 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803527:	eb 01                	jmp    80352a <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803529:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80352a:	90                   	nop
  80352b:	c9                   	leave  
  80352c:	c3                   	ret    

0080352d <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  80352d:	55                   	push   %ebp
  80352e:	89 e5                	mov    %esp,%ebp
  803530:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803533:	8b 55 08             	mov    0x8(%ebp),%edx
  803536:	89 d0                	mov    %edx,%eax
  803538:	c1 e0 02             	shl    $0x2,%eax
  80353b:	01 d0                	add    %edx,%eax
  80353d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803544:	01 d0                	add    %edx,%eax
  803546:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80354d:	01 d0                	add    %edx,%eax
  80354f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803556:	01 d0                	add    %edx,%eax
  803558:	c1 e0 04             	shl    $0x4,%eax
  80355b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  80355e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  803565:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803568:	83 ec 0c             	sub    $0xc,%esp
  80356b:	50                   	push   %eax
  80356c:	e8 26 e7 ff ff       	call   801c97 <sys_get_virtual_time>
  803571:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803574:	eb 41                	jmp    8035b7 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  803576:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803579:	83 ec 0c             	sub    $0xc,%esp
  80357c:	50                   	push   %eax
  80357d:	e8 15 e7 ff ff       	call   801c97 <sys_get_virtual_time>
  803582:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803585:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803588:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80358b:	29 c2                	sub    %eax,%edx
  80358d:	89 d0                	mov    %edx,%eax
  80358f:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803592:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803595:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803598:	89 d1                	mov    %edx,%ecx
  80359a:	29 c1                	sub    %eax,%ecx
  80359c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80359f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035a2:	39 c2                	cmp    %eax,%edx
  8035a4:	0f 97 c0             	seta   %al
  8035a7:	0f b6 c0             	movzbl %al,%eax
  8035aa:	29 c1                	sub    %eax,%ecx
  8035ac:	89 c8                	mov    %ecx,%eax
  8035ae:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8035b1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8035b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8035b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ba:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8035bd:	72 b7                	jb     803576 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8035bf:	90                   	nop
  8035c0:	c9                   	leave  
  8035c1:	c3                   	ret    

008035c2 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8035c2:	55                   	push   %ebp
  8035c3:	89 e5                	mov    %esp,%ebp
  8035c5:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8035c8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8035cf:	eb 03                	jmp    8035d4 <busy_wait+0x12>
  8035d1:	ff 45 fc             	incl   -0x4(%ebp)
  8035d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8035d7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8035da:	72 f5                	jb     8035d1 <busy_wait+0xf>
	return i;
  8035dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8035df:	c9                   	leave  
  8035e0:	c3                   	ret    
  8035e1:	66 90                	xchg   %ax,%ax
  8035e3:	90                   	nop

008035e4 <__udivdi3>:
  8035e4:	55                   	push   %ebp
  8035e5:	57                   	push   %edi
  8035e6:	56                   	push   %esi
  8035e7:	53                   	push   %ebx
  8035e8:	83 ec 1c             	sub    $0x1c,%esp
  8035eb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8035ef:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8035f3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8035f7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8035fb:	89 ca                	mov    %ecx,%edx
  8035fd:	89 f8                	mov    %edi,%eax
  8035ff:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803603:	85 f6                	test   %esi,%esi
  803605:	75 2d                	jne    803634 <__udivdi3+0x50>
  803607:	39 cf                	cmp    %ecx,%edi
  803609:	77 65                	ja     803670 <__udivdi3+0x8c>
  80360b:	89 fd                	mov    %edi,%ebp
  80360d:	85 ff                	test   %edi,%edi
  80360f:	75 0b                	jne    80361c <__udivdi3+0x38>
  803611:	b8 01 00 00 00       	mov    $0x1,%eax
  803616:	31 d2                	xor    %edx,%edx
  803618:	f7 f7                	div    %edi
  80361a:	89 c5                	mov    %eax,%ebp
  80361c:	31 d2                	xor    %edx,%edx
  80361e:	89 c8                	mov    %ecx,%eax
  803620:	f7 f5                	div    %ebp
  803622:	89 c1                	mov    %eax,%ecx
  803624:	89 d8                	mov    %ebx,%eax
  803626:	f7 f5                	div    %ebp
  803628:	89 cf                	mov    %ecx,%edi
  80362a:	89 fa                	mov    %edi,%edx
  80362c:	83 c4 1c             	add    $0x1c,%esp
  80362f:	5b                   	pop    %ebx
  803630:	5e                   	pop    %esi
  803631:	5f                   	pop    %edi
  803632:	5d                   	pop    %ebp
  803633:	c3                   	ret    
  803634:	39 ce                	cmp    %ecx,%esi
  803636:	77 28                	ja     803660 <__udivdi3+0x7c>
  803638:	0f bd fe             	bsr    %esi,%edi
  80363b:	83 f7 1f             	xor    $0x1f,%edi
  80363e:	75 40                	jne    803680 <__udivdi3+0x9c>
  803640:	39 ce                	cmp    %ecx,%esi
  803642:	72 0a                	jb     80364e <__udivdi3+0x6a>
  803644:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803648:	0f 87 9e 00 00 00    	ja     8036ec <__udivdi3+0x108>
  80364e:	b8 01 00 00 00       	mov    $0x1,%eax
  803653:	89 fa                	mov    %edi,%edx
  803655:	83 c4 1c             	add    $0x1c,%esp
  803658:	5b                   	pop    %ebx
  803659:	5e                   	pop    %esi
  80365a:	5f                   	pop    %edi
  80365b:	5d                   	pop    %ebp
  80365c:	c3                   	ret    
  80365d:	8d 76 00             	lea    0x0(%esi),%esi
  803660:	31 ff                	xor    %edi,%edi
  803662:	31 c0                	xor    %eax,%eax
  803664:	89 fa                	mov    %edi,%edx
  803666:	83 c4 1c             	add    $0x1c,%esp
  803669:	5b                   	pop    %ebx
  80366a:	5e                   	pop    %esi
  80366b:	5f                   	pop    %edi
  80366c:	5d                   	pop    %ebp
  80366d:	c3                   	ret    
  80366e:	66 90                	xchg   %ax,%ax
  803670:	89 d8                	mov    %ebx,%eax
  803672:	f7 f7                	div    %edi
  803674:	31 ff                	xor    %edi,%edi
  803676:	89 fa                	mov    %edi,%edx
  803678:	83 c4 1c             	add    $0x1c,%esp
  80367b:	5b                   	pop    %ebx
  80367c:	5e                   	pop    %esi
  80367d:	5f                   	pop    %edi
  80367e:	5d                   	pop    %ebp
  80367f:	c3                   	ret    
  803680:	bd 20 00 00 00       	mov    $0x20,%ebp
  803685:	89 eb                	mov    %ebp,%ebx
  803687:	29 fb                	sub    %edi,%ebx
  803689:	89 f9                	mov    %edi,%ecx
  80368b:	d3 e6                	shl    %cl,%esi
  80368d:	89 c5                	mov    %eax,%ebp
  80368f:	88 d9                	mov    %bl,%cl
  803691:	d3 ed                	shr    %cl,%ebp
  803693:	89 e9                	mov    %ebp,%ecx
  803695:	09 f1                	or     %esi,%ecx
  803697:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80369b:	89 f9                	mov    %edi,%ecx
  80369d:	d3 e0                	shl    %cl,%eax
  80369f:	89 c5                	mov    %eax,%ebp
  8036a1:	89 d6                	mov    %edx,%esi
  8036a3:	88 d9                	mov    %bl,%cl
  8036a5:	d3 ee                	shr    %cl,%esi
  8036a7:	89 f9                	mov    %edi,%ecx
  8036a9:	d3 e2                	shl    %cl,%edx
  8036ab:	8b 44 24 08          	mov    0x8(%esp),%eax
  8036af:	88 d9                	mov    %bl,%cl
  8036b1:	d3 e8                	shr    %cl,%eax
  8036b3:	09 c2                	or     %eax,%edx
  8036b5:	89 d0                	mov    %edx,%eax
  8036b7:	89 f2                	mov    %esi,%edx
  8036b9:	f7 74 24 0c          	divl   0xc(%esp)
  8036bd:	89 d6                	mov    %edx,%esi
  8036bf:	89 c3                	mov    %eax,%ebx
  8036c1:	f7 e5                	mul    %ebp
  8036c3:	39 d6                	cmp    %edx,%esi
  8036c5:	72 19                	jb     8036e0 <__udivdi3+0xfc>
  8036c7:	74 0b                	je     8036d4 <__udivdi3+0xf0>
  8036c9:	89 d8                	mov    %ebx,%eax
  8036cb:	31 ff                	xor    %edi,%edi
  8036cd:	e9 58 ff ff ff       	jmp    80362a <__udivdi3+0x46>
  8036d2:	66 90                	xchg   %ax,%ax
  8036d4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8036d8:	89 f9                	mov    %edi,%ecx
  8036da:	d3 e2                	shl    %cl,%edx
  8036dc:	39 c2                	cmp    %eax,%edx
  8036de:	73 e9                	jae    8036c9 <__udivdi3+0xe5>
  8036e0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8036e3:	31 ff                	xor    %edi,%edi
  8036e5:	e9 40 ff ff ff       	jmp    80362a <__udivdi3+0x46>
  8036ea:	66 90                	xchg   %ax,%ax
  8036ec:	31 c0                	xor    %eax,%eax
  8036ee:	e9 37 ff ff ff       	jmp    80362a <__udivdi3+0x46>
  8036f3:	90                   	nop

008036f4 <__umoddi3>:
  8036f4:	55                   	push   %ebp
  8036f5:	57                   	push   %edi
  8036f6:	56                   	push   %esi
  8036f7:	53                   	push   %ebx
  8036f8:	83 ec 1c             	sub    $0x1c,%esp
  8036fb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8036ff:	8b 74 24 34          	mov    0x34(%esp),%esi
  803703:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803707:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80370b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80370f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803713:	89 f3                	mov    %esi,%ebx
  803715:	89 fa                	mov    %edi,%edx
  803717:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80371b:	89 34 24             	mov    %esi,(%esp)
  80371e:	85 c0                	test   %eax,%eax
  803720:	75 1a                	jne    80373c <__umoddi3+0x48>
  803722:	39 f7                	cmp    %esi,%edi
  803724:	0f 86 a2 00 00 00    	jbe    8037cc <__umoddi3+0xd8>
  80372a:	89 c8                	mov    %ecx,%eax
  80372c:	89 f2                	mov    %esi,%edx
  80372e:	f7 f7                	div    %edi
  803730:	89 d0                	mov    %edx,%eax
  803732:	31 d2                	xor    %edx,%edx
  803734:	83 c4 1c             	add    $0x1c,%esp
  803737:	5b                   	pop    %ebx
  803738:	5e                   	pop    %esi
  803739:	5f                   	pop    %edi
  80373a:	5d                   	pop    %ebp
  80373b:	c3                   	ret    
  80373c:	39 f0                	cmp    %esi,%eax
  80373e:	0f 87 ac 00 00 00    	ja     8037f0 <__umoddi3+0xfc>
  803744:	0f bd e8             	bsr    %eax,%ebp
  803747:	83 f5 1f             	xor    $0x1f,%ebp
  80374a:	0f 84 ac 00 00 00    	je     8037fc <__umoddi3+0x108>
  803750:	bf 20 00 00 00       	mov    $0x20,%edi
  803755:	29 ef                	sub    %ebp,%edi
  803757:	89 fe                	mov    %edi,%esi
  803759:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80375d:	89 e9                	mov    %ebp,%ecx
  80375f:	d3 e0                	shl    %cl,%eax
  803761:	89 d7                	mov    %edx,%edi
  803763:	89 f1                	mov    %esi,%ecx
  803765:	d3 ef                	shr    %cl,%edi
  803767:	09 c7                	or     %eax,%edi
  803769:	89 e9                	mov    %ebp,%ecx
  80376b:	d3 e2                	shl    %cl,%edx
  80376d:	89 14 24             	mov    %edx,(%esp)
  803770:	89 d8                	mov    %ebx,%eax
  803772:	d3 e0                	shl    %cl,%eax
  803774:	89 c2                	mov    %eax,%edx
  803776:	8b 44 24 08          	mov    0x8(%esp),%eax
  80377a:	d3 e0                	shl    %cl,%eax
  80377c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803780:	8b 44 24 08          	mov    0x8(%esp),%eax
  803784:	89 f1                	mov    %esi,%ecx
  803786:	d3 e8                	shr    %cl,%eax
  803788:	09 d0                	or     %edx,%eax
  80378a:	d3 eb                	shr    %cl,%ebx
  80378c:	89 da                	mov    %ebx,%edx
  80378e:	f7 f7                	div    %edi
  803790:	89 d3                	mov    %edx,%ebx
  803792:	f7 24 24             	mull   (%esp)
  803795:	89 c6                	mov    %eax,%esi
  803797:	89 d1                	mov    %edx,%ecx
  803799:	39 d3                	cmp    %edx,%ebx
  80379b:	0f 82 87 00 00 00    	jb     803828 <__umoddi3+0x134>
  8037a1:	0f 84 91 00 00 00    	je     803838 <__umoddi3+0x144>
  8037a7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8037ab:	29 f2                	sub    %esi,%edx
  8037ad:	19 cb                	sbb    %ecx,%ebx
  8037af:	89 d8                	mov    %ebx,%eax
  8037b1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8037b5:	d3 e0                	shl    %cl,%eax
  8037b7:	89 e9                	mov    %ebp,%ecx
  8037b9:	d3 ea                	shr    %cl,%edx
  8037bb:	09 d0                	or     %edx,%eax
  8037bd:	89 e9                	mov    %ebp,%ecx
  8037bf:	d3 eb                	shr    %cl,%ebx
  8037c1:	89 da                	mov    %ebx,%edx
  8037c3:	83 c4 1c             	add    $0x1c,%esp
  8037c6:	5b                   	pop    %ebx
  8037c7:	5e                   	pop    %esi
  8037c8:	5f                   	pop    %edi
  8037c9:	5d                   	pop    %ebp
  8037ca:	c3                   	ret    
  8037cb:	90                   	nop
  8037cc:	89 fd                	mov    %edi,%ebp
  8037ce:	85 ff                	test   %edi,%edi
  8037d0:	75 0b                	jne    8037dd <__umoddi3+0xe9>
  8037d2:	b8 01 00 00 00       	mov    $0x1,%eax
  8037d7:	31 d2                	xor    %edx,%edx
  8037d9:	f7 f7                	div    %edi
  8037db:	89 c5                	mov    %eax,%ebp
  8037dd:	89 f0                	mov    %esi,%eax
  8037df:	31 d2                	xor    %edx,%edx
  8037e1:	f7 f5                	div    %ebp
  8037e3:	89 c8                	mov    %ecx,%eax
  8037e5:	f7 f5                	div    %ebp
  8037e7:	89 d0                	mov    %edx,%eax
  8037e9:	e9 44 ff ff ff       	jmp    803732 <__umoddi3+0x3e>
  8037ee:	66 90                	xchg   %ax,%ax
  8037f0:	89 c8                	mov    %ecx,%eax
  8037f2:	89 f2                	mov    %esi,%edx
  8037f4:	83 c4 1c             	add    $0x1c,%esp
  8037f7:	5b                   	pop    %ebx
  8037f8:	5e                   	pop    %esi
  8037f9:	5f                   	pop    %edi
  8037fa:	5d                   	pop    %ebp
  8037fb:	c3                   	ret    
  8037fc:	3b 04 24             	cmp    (%esp),%eax
  8037ff:	72 06                	jb     803807 <__umoddi3+0x113>
  803801:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803805:	77 0f                	ja     803816 <__umoddi3+0x122>
  803807:	89 f2                	mov    %esi,%edx
  803809:	29 f9                	sub    %edi,%ecx
  80380b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80380f:	89 14 24             	mov    %edx,(%esp)
  803812:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803816:	8b 44 24 04          	mov    0x4(%esp),%eax
  80381a:	8b 14 24             	mov    (%esp),%edx
  80381d:	83 c4 1c             	add    $0x1c,%esp
  803820:	5b                   	pop    %ebx
  803821:	5e                   	pop    %esi
  803822:	5f                   	pop    %edi
  803823:	5d                   	pop    %ebp
  803824:	c3                   	ret    
  803825:	8d 76 00             	lea    0x0(%esi),%esi
  803828:	2b 04 24             	sub    (%esp),%eax
  80382b:	19 fa                	sbb    %edi,%edx
  80382d:	89 d1                	mov    %edx,%ecx
  80382f:	89 c6                	mov    %eax,%esi
  803831:	e9 71 ff ff ff       	jmp    8037a7 <__umoddi3+0xb3>
  803836:	66 90                	xchg   %ax,%ax
  803838:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80383c:	72 ea                	jb     803828 <__umoddi3+0x134>
  80383e:	89 d9                	mov    %ebx,%ecx
  803840:	e9 62 ff ff ff       	jmp    8037a7 <__umoddi3+0xb3>
