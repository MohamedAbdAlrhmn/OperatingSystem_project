
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
  80008d:	68 40 39 80 00       	push   $0x803940
  800092:	6a 13                	push   $0x13
  800094:	68 5c 39 80 00       	push   $0x80395c
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
  8000ab:	e8 9a 19 00 00       	call   801a4a <sys_calculate_free_frames>
  8000b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	x = smalloc("x", 4, 0);
  8000b3:	83 ec 04             	sub    $0x4,%esp
  8000b6:	6a 00                	push   $0x0
  8000b8:	6a 04                	push   $0x4
  8000ba:	68 77 39 80 00       	push   $0x803977
  8000bf:	e8 b4 16 00 00       	call   801778 <smalloc>
  8000c4:	83 c4 10             	add    $0x10,%esp
  8000c7:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if (x != (uint32*)USER_HEAP_START) panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8000ca:	81 7d e8 00 00 00 80 	cmpl   $0x80000000,-0x18(%ebp)
  8000d1:	74 14                	je     8000e7 <_main+0xaf>
  8000d3:	83 ec 04             	sub    $0x4,%esp
  8000d6:	68 7c 39 80 00       	push   $0x80397c
  8000db:	6a 1e                	push   $0x1e
  8000dd:	68 5c 39 80 00       	push   $0x80395c
  8000e2:	e8 c0 03 00 00       	call   8004a7 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Create(): Wrong allocation- make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8000e7:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000ea:	e8 5b 19 00 00       	call   801a4a <sys_calculate_free_frames>
  8000ef:	29 c3                	sub    %eax,%ebx
  8000f1:	89 d8                	mov    %ebx,%eax
  8000f3:	83 f8 04             	cmp    $0x4,%eax
  8000f6:	74 14                	je     80010c <_main+0xd4>
  8000f8:	83 ec 04             	sub    $0x4,%esp
  8000fb:	68 e0 39 80 00       	push   $0x8039e0
  800100:	6a 1f                	push   $0x1f
  800102:	68 5c 39 80 00       	push   $0x80395c
  800107:	e8 9b 03 00 00       	call   8004a7 <_panic>

	//y: Readonly
	freeFrames = sys_calculate_free_frames() ;
  80010c:	e8 39 19 00 00       	call   801a4a <sys_calculate_free_frames>
  800111:	89 45 ec             	mov    %eax,-0x14(%ebp)
	y = smalloc("y", 4, 0);
  800114:	83 ec 04             	sub    $0x4,%esp
  800117:	6a 00                	push   $0x0
  800119:	6a 04                	push   $0x4
  80011b:	68 68 3a 80 00       	push   $0x803a68
  800120:	e8 53 16 00 00       	call   801778 <smalloc>
  800125:	83 c4 10             	add    $0x10,%esp
  800128:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (y != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  80012b:	81 7d e4 00 10 00 80 	cmpl   $0x80001000,-0x1c(%ebp)
  800132:	74 14                	je     800148 <_main+0x110>
  800134:	83 ec 04             	sub    $0x4,%esp
  800137:	68 7c 39 80 00       	push   $0x80397c
  80013c:	6a 24                	push   $0x24
  80013e:	68 5c 39 80 00       	push   $0x80395c
  800143:	e8 5f 03 00 00       	call   8004a7 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1+0+2) panic("Create(): Wrong allocation- make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800148:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  80014b:	e8 fa 18 00 00       	call   801a4a <sys_calculate_free_frames>
  800150:	29 c3                	sub    %eax,%ebx
  800152:	89 d8                	mov    %ebx,%eax
  800154:	83 f8 03             	cmp    $0x3,%eax
  800157:	74 14                	je     80016d <_main+0x135>
  800159:	83 ec 04             	sub    $0x4,%esp
  80015c:	68 e0 39 80 00       	push   $0x8039e0
  800161:	6a 25                	push   $0x25
  800163:	68 5c 39 80 00       	push   $0x80395c
  800168:	e8 3a 03 00 00       	call   8004a7 <_panic>

	//z: Writable
	freeFrames = sys_calculate_free_frames() ;
  80016d:	e8 d8 18 00 00       	call   801a4a <sys_calculate_free_frames>
  800172:	89 45 ec             	mov    %eax,-0x14(%ebp)
	z = smalloc("z", 4, 1);
  800175:	83 ec 04             	sub    $0x4,%esp
  800178:	6a 01                	push   $0x1
  80017a:	6a 04                	push   $0x4
  80017c:	68 6a 3a 80 00       	push   $0x803a6a
  800181:	e8 f2 15 00 00       	call   801778 <smalloc>
  800186:	83 c4 10             	add    $0x10,%esp
  800189:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (z != (uint32*)(USER_HEAP_START + 2 * PAGE_SIZE)) panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  80018c:	81 7d e0 00 20 00 80 	cmpl   $0x80002000,-0x20(%ebp)
  800193:	74 14                	je     8001a9 <_main+0x171>
  800195:	83 ec 04             	sub    $0x4,%esp
  800198:	68 7c 39 80 00       	push   $0x80397c
  80019d:	6a 2a                	push   $0x2a
  80019f:	68 5c 39 80 00       	push   $0x80395c
  8001a4:	e8 fe 02 00 00       	call   8004a7 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1+0+2) panic("Create(): Wrong allocation- make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8001a9:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8001ac:	e8 99 18 00 00       	call   801a4a <sys_calculate_free_frames>
  8001b1:	29 c3                	sub    %eax,%ebx
  8001b3:	89 d8                	mov    %ebx,%eax
  8001b5:	83 f8 03             	cmp    $0x3,%eax
  8001b8:	74 14                	je     8001ce <_main+0x196>
  8001ba:	83 ec 04             	sub    $0x4,%esp
  8001bd:	68 e0 39 80 00       	push   $0x8039e0
  8001c2:	6a 2b                	push   $0x2b
  8001c4:	68 5c 39 80 00       	push   $0x80395c
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
  800203:	68 6c 3a 80 00       	push   $0x803a6c
  800208:	e8 af 1a 00 00       	call   801cbc <sys_create_env>
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
  800236:	68 6c 3a 80 00       	push   $0x803a6c
  80023b:	e8 7c 1a 00 00       	call   801cbc <sys_create_env>
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
  800269:	68 6c 3a 80 00       	push   $0x803a6c
  80026e:	e8 49 1a 00 00       	call   801cbc <sys_create_env>
  800273:	83 c4 10             	add    $0x10,%esp
  800276:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	//to check that the slave environments completed successfully
	rsttst();
  800279:	e8 8a 1b 00 00       	call   801e08 <rsttst>

	sys_run_env(id1);
  80027e:	83 ec 0c             	sub    $0xc,%esp
  800281:	ff 75 dc             	pushl  -0x24(%ebp)
  800284:	e8 51 1a 00 00       	call   801cda <sys_run_env>
  800289:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id2);
  80028c:	83 ec 0c             	sub    $0xc,%esp
  80028f:	ff 75 d8             	pushl  -0x28(%ebp)
  800292:	e8 43 1a 00 00       	call   801cda <sys_run_env>
  800297:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id3);
  80029a:	83 ec 0c             	sub    $0xc,%esp
  80029d:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002a0:	e8 35 1a 00 00       	call   801cda <sys_run_env>
  8002a5:	83 c4 10             	add    $0x10,%esp

	env_sleep(12000) ;
  8002a8:	83 ec 0c             	sub    $0xc,%esp
  8002ab:	68 e0 2e 00 00       	push   $0x2ee0
  8002b0:	e8 57 33 00 00       	call   80360c <env_sleep>
  8002b5:	83 c4 10             	add    $0x10,%esp

	//to ensure that the slave environments completed successfully
	if (gettst()!=3) panic("test failed");
  8002b8:	e8 c5 1b 00 00       	call   801e82 <gettst>
  8002bd:	83 f8 03             	cmp    $0x3,%eax
  8002c0:	74 14                	je     8002d6 <_main+0x29e>
  8002c2:	83 ec 04             	sub    $0x4,%esp
  8002c5:	68 77 3a 80 00       	push   $0x803a77
  8002ca:	6a 3f                	push   $0x3f
  8002cc:	68 5c 39 80 00       	push   $0x80395c
  8002d1:	e8 d1 01 00 00       	call   8004a7 <_panic>


	if (*z != 30)
  8002d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002d9:	8b 00                	mov    (%eax),%eax
  8002db:	83 f8 1e             	cmp    $0x1e,%eax
  8002de:	74 14                	je     8002f4 <_main+0x2bc>
		panic("Error!! Please check the creation (or the getting) of shared variables!!\n\n\n");
  8002e0:	83 ec 04             	sub    $0x4,%esp
  8002e3:	68 84 3a 80 00       	push   $0x803a84
  8002e8:	6a 43                	push   $0x43
  8002ea:	68 5c 39 80 00       	push   $0x80395c
  8002ef:	e8 b3 01 00 00       	call   8004a7 <_panic>
	else
		cprintf("Congratulations!! Test of Shared Variables [Create & Get] [2] completed successfully!!\n\n\n");
  8002f4:	83 ec 0c             	sub    $0xc,%esp
  8002f7:	68 d0 3a 80 00       	push   $0x803ad0
  8002fc:	e8 5a 04 00 00       	call   80075b <cprintf>
  800301:	83 c4 10             	add    $0x10,%esp

	cprintf("Now, ILLEGAL MEM ACCESS should be occur, due to attempting to write a ReadOnly variable\n\n\n");
  800304:	83 ec 0c             	sub    $0xc,%esp
  800307:	68 2c 3b 80 00       	push   $0x803b2c
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
  800337:	68 87 3b 80 00       	push   $0x803b87
  80033c:	e8 7b 19 00 00       	call   801cbc <sys_create_env>
  800341:	83 c4 10             	add    $0x10,%esp
  800344:	89 45 dc             	mov    %eax,-0x24(%ebp)

	env_sleep(3000) ;
  800347:	83 ec 0c             	sub    $0xc,%esp
  80034a:	68 b8 0b 00 00       	push   $0xbb8
  80034f:	e8 b8 32 00 00       	call   80360c <env_sleep>
  800354:	83 c4 10             	add    $0x10,%esp

	sys_run_env(id1);
  800357:	83 ec 0c             	sub    $0xc,%esp
  80035a:	ff 75 dc             	pushl  -0x24(%ebp)
  80035d:	e8 78 19 00 00       	call   801cda <sys_run_env>
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
  800371:	e8 b4 19 00 00       	call   801d2a <sys_getenvindex>
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
  8003dc:	e8 56 17 00 00       	call   801b37 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8003e1:	83 ec 0c             	sub    $0xc,%esp
  8003e4:	68 ac 3b 80 00       	push   $0x803bac
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
  80040c:	68 d4 3b 80 00       	push   $0x803bd4
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
  80043d:	68 fc 3b 80 00       	push   $0x803bfc
  800442:	e8 14 03 00 00       	call   80075b <cprintf>
  800447:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80044a:	a1 20 50 80 00       	mov    0x805020,%eax
  80044f:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800455:	83 ec 08             	sub    $0x8,%esp
  800458:	50                   	push   %eax
  800459:	68 54 3c 80 00       	push   $0x803c54
  80045e:	e8 f8 02 00 00       	call   80075b <cprintf>
  800463:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800466:	83 ec 0c             	sub    $0xc,%esp
  800469:	68 ac 3b 80 00       	push   $0x803bac
  80046e:	e8 e8 02 00 00       	call   80075b <cprintf>
  800473:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800476:	e8 d6 16 00 00       	call   801b51 <sys_enable_interrupt>

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
  80048e:	e8 63 18 00 00       	call   801cf6 <sys_destroy_env>
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
  80049f:	e8 b8 18 00 00       	call   801d5c <sys_exit_env>
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
  8004c8:	68 68 3c 80 00       	push   $0x803c68
  8004cd:	e8 89 02 00 00       	call   80075b <cprintf>
  8004d2:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8004d5:	a1 00 50 80 00       	mov    0x805000,%eax
  8004da:	ff 75 0c             	pushl  0xc(%ebp)
  8004dd:	ff 75 08             	pushl  0x8(%ebp)
  8004e0:	50                   	push   %eax
  8004e1:	68 6d 3c 80 00       	push   $0x803c6d
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
  800505:	68 89 3c 80 00       	push   $0x803c89
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
  800531:	68 8c 3c 80 00       	push   $0x803c8c
  800536:	6a 26                	push   $0x26
  800538:	68 d8 3c 80 00       	push   $0x803cd8
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
  800603:	68 e4 3c 80 00       	push   $0x803ce4
  800608:	6a 3a                	push   $0x3a
  80060a:	68 d8 3c 80 00       	push   $0x803cd8
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
  800673:	68 38 3d 80 00       	push   $0x803d38
  800678:	6a 44                	push   $0x44
  80067a:	68 d8 3c 80 00       	push   $0x803cd8
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
  8006cd:	e8 b7 12 00 00       	call   801989 <sys_cputs>
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
  800744:	e8 40 12 00 00       	call   801989 <sys_cputs>
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
  80078e:	e8 a4 13 00 00       	call   801b37 <sys_disable_interrupt>
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
  8007ae:	e8 9e 13 00 00       	call   801b51 <sys_enable_interrupt>
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
  8007f8:	e8 c3 2e 00 00       	call   8036c0 <__udivdi3>
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
  800848:	e8 83 2f 00 00       	call   8037d0 <__umoddi3>
  80084d:	83 c4 10             	add    $0x10,%esp
  800850:	05 b4 3f 80 00       	add    $0x803fb4,%eax
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
  8009a3:	8b 04 85 d8 3f 80 00 	mov    0x803fd8(,%eax,4),%eax
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
  800a84:	8b 34 9d 20 3e 80 00 	mov    0x803e20(,%ebx,4),%esi
  800a8b:	85 f6                	test   %esi,%esi
  800a8d:	75 19                	jne    800aa8 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a8f:	53                   	push   %ebx
  800a90:	68 c5 3f 80 00       	push   $0x803fc5
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
  800aa9:	68 ce 3f 80 00       	push   $0x803fce
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
  800ad6:	be d1 3f 80 00       	mov    $0x803fd1,%esi
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
  8014fc:	68 30 41 80 00       	push   $0x804130
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
  8015cc:	e8 fc 04 00 00       	call   801acd <sys_allocate_chunk>
  8015d1:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8015d4:	a1 20 51 80 00       	mov    0x805120,%eax
  8015d9:	83 ec 0c             	sub    $0xc,%esp
  8015dc:	50                   	push   %eax
  8015dd:	e8 71 0b 00 00       	call   802153 <initialize_MemBlocksList>
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
  80160a:	68 55 41 80 00       	push   $0x804155
  80160f:	6a 33                	push   $0x33
  801611:	68 73 41 80 00       	push   $0x804173
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
  801689:	68 80 41 80 00       	push   $0x804180
  80168e:	6a 34                	push   $0x34
  801690:	68 73 41 80 00       	push   $0x804173
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
  801721:	e8 75 07 00 00       	call   801e9b <sys_isUHeapPlacementStrategyFIRSTFIT>
  801726:	85 c0                	test   %eax,%eax
  801728:	74 11                	je     80173b <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  80172a:	83 ec 0c             	sub    $0xc,%esp
  80172d:	ff 75 e8             	pushl  -0x18(%ebp)
  801730:	e8 e0 0d 00 00       	call   802515 <alloc_block_FF>
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
  801747:	e8 3c 0b 00 00       	call   802288 <insert_sorted_allocList>
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
  801767:	68 a4 41 80 00       	push   $0x8041a4
  80176c:	6a 6f                	push   $0x6f
  80176e:	68 73 41 80 00       	push   $0x804173
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
  80178d:	75 0a                	jne    801799 <smalloc+0x21>
  80178f:	b8 00 00 00 00       	mov    $0x0,%eax
  801794:	e9 8b 00 00 00       	jmp    801824 <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801799:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8017a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017a6:	01 d0                	add    %edx,%eax
  8017a8:	48                   	dec    %eax
  8017a9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8017ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017af:	ba 00 00 00 00       	mov    $0x0,%edx
  8017b4:	f7 75 f0             	divl   -0x10(%ebp)
  8017b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017ba:	29 d0                	sub    %edx,%eax
  8017bc:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  8017bf:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8017c6:	e8 d0 06 00 00       	call   801e9b <sys_isUHeapPlacementStrategyFIRSTFIT>
  8017cb:	85 c0                	test   %eax,%eax
  8017cd:	74 11                	je     8017e0 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  8017cf:	83 ec 0c             	sub    $0xc,%esp
  8017d2:	ff 75 e8             	pushl  -0x18(%ebp)
  8017d5:	e8 3b 0d 00 00       	call   802515 <alloc_block_FF>
  8017da:	83 c4 10             	add    $0x10,%esp
  8017dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  8017e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8017e4:	74 39                	je     80181f <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8017e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017e9:	8b 40 08             	mov    0x8(%eax),%eax
  8017ec:	89 c2                	mov    %eax,%edx
  8017ee:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8017f2:	52                   	push   %edx
  8017f3:	50                   	push   %eax
  8017f4:	ff 75 0c             	pushl  0xc(%ebp)
  8017f7:	ff 75 08             	pushl  0x8(%ebp)
  8017fa:	e8 21 04 00 00       	call   801c20 <sys_createSharedObject>
  8017ff:	83 c4 10             	add    $0x10,%esp
  801802:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  801805:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  801809:	74 14                	je     80181f <smalloc+0xa7>
  80180b:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  80180f:	74 0e                	je     80181f <smalloc+0xa7>
  801811:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  801815:	74 08                	je     80181f <smalloc+0xa7>
			return (void*) mem_block->sva;
  801817:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80181a:	8b 40 08             	mov    0x8(%eax),%eax
  80181d:	eb 05                	jmp    801824 <smalloc+0xac>
	}
	return NULL;
  80181f:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801824:	c9                   	leave  
  801825:	c3                   	ret    

00801826 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801826:	55                   	push   %ebp
  801827:	89 e5                	mov    %esp,%ebp
  801829:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80182c:	e8 b4 fc ff ff       	call   8014e5 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801831:	83 ec 08             	sub    $0x8,%esp
  801834:	ff 75 0c             	pushl  0xc(%ebp)
  801837:	ff 75 08             	pushl  0x8(%ebp)
  80183a:	e8 0b 04 00 00       	call   801c4a <sys_getSizeOfSharedObject>
  80183f:	83 c4 10             	add    $0x10,%esp
  801842:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  801845:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  801849:	74 76                	je     8018c1 <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  80184b:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801852:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801855:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801858:	01 d0                	add    %edx,%eax
  80185a:	48                   	dec    %eax
  80185b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80185e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801861:	ba 00 00 00 00       	mov    $0x0,%edx
  801866:	f7 75 ec             	divl   -0x14(%ebp)
  801869:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80186c:	29 d0                	sub    %edx,%eax
  80186e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  801871:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801878:	e8 1e 06 00 00       	call   801e9b <sys_isUHeapPlacementStrategyFIRSTFIT>
  80187d:	85 c0                	test   %eax,%eax
  80187f:	74 11                	je     801892 <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  801881:	83 ec 0c             	sub    $0xc,%esp
  801884:	ff 75 e4             	pushl  -0x1c(%ebp)
  801887:	e8 89 0c 00 00       	call   802515 <alloc_block_FF>
  80188c:	83 c4 10             	add    $0x10,%esp
  80188f:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  801892:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801896:	74 29                	je     8018c1 <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  801898:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80189b:	8b 40 08             	mov    0x8(%eax),%eax
  80189e:	83 ec 04             	sub    $0x4,%esp
  8018a1:	50                   	push   %eax
  8018a2:	ff 75 0c             	pushl  0xc(%ebp)
  8018a5:	ff 75 08             	pushl  0x8(%ebp)
  8018a8:	e8 ba 03 00 00       	call   801c67 <sys_getSharedObject>
  8018ad:	83 c4 10             	add    $0x10,%esp
  8018b0:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  8018b3:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  8018b7:	74 08                	je     8018c1 <sget+0x9b>
				return (void *)mem_block->sva;
  8018b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018bc:	8b 40 08             	mov    0x8(%eax),%eax
  8018bf:	eb 05                	jmp    8018c6 <sget+0xa0>
		}
	}
	return NULL;
  8018c1:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8018c6:	c9                   	leave  
  8018c7:	c3                   	ret    

008018c8 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8018c8:	55                   	push   %ebp
  8018c9:	89 e5                	mov    %esp,%ebp
  8018cb:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8018ce:	e8 12 fc ff ff       	call   8014e5 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8018d3:	83 ec 04             	sub    $0x4,%esp
  8018d6:	68 c8 41 80 00       	push   $0x8041c8
  8018db:	68 f1 00 00 00       	push   $0xf1
  8018e0:	68 73 41 80 00       	push   $0x804173
  8018e5:	e8 bd eb ff ff       	call   8004a7 <_panic>

008018ea <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8018ea:	55                   	push   %ebp
  8018eb:	89 e5                	mov    %esp,%ebp
  8018ed:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8018f0:	83 ec 04             	sub    $0x4,%esp
  8018f3:	68 f0 41 80 00       	push   $0x8041f0
  8018f8:	68 05 01 00 00       	push   $0x105
  8018fd:	68 73 41 80 00       	push   $0x804173
  801902:	e8 a0 eb ff ff       	call   8004a7 <_panic>

00801907 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801907:	55                   	push   %ebp
  801908:	89 e5                	mov    %esp,%ebp
  80190a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80190d:	83 ec 04             	sub    $0x4,%esp
  801910:	68 14 42 80 00       	push   $0x804214
  801915:	68 10 01 00 00       	push   $0x110
  80191a:	68 73 41 80 00       	push   $0x804173
  80191f:	e8 83 eb ff ff       	call   8004a7 <_panic>

00801924 <shrink>:

}
void shrink(uint32 newSize)
{
  801924:	55                   	push   %ebp
  801925:	89 e5                	mov    %esp,%ebp
  801927:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80192a:	83 ec 04             	sub    $0x4,%esp
  80192d:	68 14 42 80 00       	push   $0x804214
  801932:	68 15 01 00 00       	push   $0x115
  801937:	68 73 41 80 00       	push   $0x804173
  80193c:	e8 66 eb ff ff       	call   8004a7 <_panic>

00801941 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801941:	55                   	push   %ebp
  801942:	89 e5                	mov    %esp,%ebp
  801944:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801947:	83 ec 04             	sub    $0x4,%esp
  80194a:	68 14 42 80 00       	push   $0x804214
  80194f:	68 1a 01 00 00       	push   $0x11a
  801954:	68 73 41 80 00       	push   $0x804173
  801959:	e8 49 eb ff ff       	call   8004a7 <_panic>

0080195e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80195e:	55                   	push   %ebp
  80195f:	89 e5                	mov    %esp,%ebp
  801961:	57                   	push   %edi
  801962:	56                   	push   %esi
  801963:	53                   	push   %ebx
  801964:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801967:	8b 45 08             	mov    0x8(%ebp),%eax
  80196a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80196d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801970:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801973:	8b 7d 18             	mov    0x18(%ebp),%edi
  801976:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801979:	cd 30                	int    $0x30
  80197b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80197e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801981:	83 c4 10             	add    $0x10,%esp
  801984:	5b                   	pop    %ebx
  801985:	5e                   	pop    %esi
  801986:	5f                   	pop    %edi
  801987:	5d                   	pop    %ebp
  801988:	c3                   	ret    

00801989 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801989:	55                   	push   %ebp
  80198a:	89 e5                	mov    %esp,%ebp
  80198c:	83 ec 04             	sub    $0x4,%esp
  80198f:	8b 45 10             	mov    0x10(%ebp),%eax
  801992:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801995:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801999:	8b 45 08             	mov    0x8(%ebp),%eax
  80199c:	6a 00                	push   $0x0
  80199e:	6a 00                	push   $0x0
  8019a0:	52                   	push   %edx
  8019a1:	ff 75 0c             	pushl  0xc(%ebp)
  8019a4:	50                   	push   %eax
  8019a5:	6a 00                	push   $0x0
  8019a7:	e8 b2 ff ff ff       	call   80195e <syscall>
  8019ac:	83 c4 18             	add    $0x18,%esp
}
  8019af:	90                   	nop
  8019b0:	c9                   	leave  
  8019b1:	c3                   	ret    

008019b2 <sys_cgetc>:

int
sys_cgetc(void)
{
  8019b2:	55                   	push   %ebp
  8019b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8019b5:	6a 00                	push   $0x0
  8019b7:	6a 00                	push   $0x0
  8019b9:	6a 00                	push   $0x0
  8019bb:	6a 00                	push   $0x0
  8019bd:	6a 00                	push   $0x0
  8019bf:	6a 01                	push   $0x1
  8019c1:	e8 98 ff ff ff       	call   80195e <syscall>
  8019c6:	83 c4 18             	add    $0x18,%esp
}
  8019c9:	c9                   	leave  
  8019ca:	c3                   	ret    

008019cb <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8019cb:	55                   	push   %ebp
  8019cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8019ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d4:	6a 00                	push   $0x0
  8019d6:	6a 00                	push   $0x0
  8019d8:	6a 00                	push   $0x0
  8019da:	52                   	push   %edx
  8019db:	50                   	push   %eax
  8019dc:	6a 05                	push   $0x5
  8019de:	e8 7b ff ff ff       	call   80195e <syscall>
  8019e3:	83 c4 18             	add    $0x18,%esp
}
  8019e6:	c9                   	leave  
  8019e7:	c3                   	ret    

008019e8 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8019e8:	55                   	push   %ebp
  8019e9:	89 e5                	mov    %esp,%ebp
  8019eb:	56                   	push   %esi
  8019ec:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8019ed:	8b 75 18             	mov    0x18(%ebp),%esi
  8019f0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019f3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fc:	56                   	push   %esi
  8019fd:	53                   	push   %ebx
  8019fe:	51                   	push   %ecx
  8019ff:	52                   	push   %edx
  801a00:	50                   	push   %eax
  801a01:	6a 06                	push   $0x6
  801a03:	e8 56 ff ff ff       	call   80195e <syscall>
  801a08:	83 c4 18             	add    $0x18,%esp
}
  801a0b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a0e:	5b                   	pop    %ebx
  801a0f:	5e                   	pop    %esi
  801a10:	5d                   	pop    %ebp
  801a11:	c3                   	ret    

00801a12 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801a12:	55                   	push   %ebp
  801a13:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801a15:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a18:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 00                	push   $0x0
  801a1f:	6a 00                	push   $0x0
  801a21:	52                   	push   %edx
  801a22:	50                   	push   %eax
  801a23:	6a 07                	push   $0x7
  801a25:	e8 34 ff ff ff       	call   80195e <syscall>
  801a2a:	83 c4 18             	add    $0x18,%esp
}
  801a2d:	c9                   	leave  
  801a2e:	c3                   	ret    

00801a2f <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801a2f:	55                   	push   %ebp
  801a30:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801a32:	6a 00                	push   $0x0
  801a34:	6a 00                	push   $0x0
  801a36:	6a 00                	push   $0x0
  801a38:	ff 75 0c             	pushl  0xc(%ebp)
  801a3b:	ff 75 08             	pushl  0x8(%ebp)
  801a3e:	6a 08                	push   $0x8
  801a40:	e8 19 ff ff ff       	call   80195e <syscall>
  801a45:	83 c4 18             	add    $0x18,%esp
}
  801a48:	c9                   	leave  
  801a49:	c3                   	ret    

00801a4a <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801a4a:	55                   	push   %ebp
  801a4b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801a4d:	6a 00                	push   $0x0
  801a4f:	6a 00                	push   $0x0
  801a51:	6a 00                	push   $0x0
  801a53:	6a 00                	push   $0x0
  801a55:	6a 00                	push   $0x0
  801a57:	6a 09                	push   $0x9
  801a59:	e8 00 ff ff ff       	call   80195e <syscall>
  801a5e:	83 c4 18             	add    $0x18,%esp
}
  801a61:	c9                   	leave  
  801a62:	c3                   	ret    

00801a63 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801a63:	55                   	push   %ebp
  801a64:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801a66:	6a 00                	push   $0x0
  801a68:	6a 00                	push   $0x0
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 00                	push   $0x0
  801a70:	6a 0a                	push   $0xa
  801a72:	e8 e7 fe ff ff       	call   80195e <syscall>
  801a77:	83 c4 18             	add    $0x18,%esp
}
  801a7a:	c9                   	leave  
  801a7b:	c3                   	ret    

00801a7c <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a7c:	55                   	push   %ebp
  801a7d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a7f:	6a 00                	push   $0x0
  801a81:	6a 00                	push   $0x0
  801a83:	6a 00                	push   $0x0
  801a85:	6a 00                	push   $0x0
  801a87:	6a 00                	push   $0x0
  801a89:	6a 0b                	push   $0xb
  801a8b:	e8 ce fe ff ff       	call   80195e <syscall>
  801a90:	83 c4 18             	add    $0x18,%esp
}
  801a93:	c9                   	leave  
  801a94:	c3                   	ret    

00801a95 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801a95:	55                   	push   %ebp
  801a96:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 00                	push   $0x0
  801a9e:	ff 75 0c             	pushl  0xc(%ebp)
  801aa1:	ff 75 08             	pushl  0x8(%ebp)
  801aa4:	6a 0f                	push   $0xf
  801aa6:	e8 b3 fe ff ff       	call   80195e <syscall>
  801aab:	83 c4 18             	add    $0x18,%esp
	return;
  801aae:	90                   	nop
}
  801aaf:	c9                   	leave  
  801ab0:	c3                   	ret    

00801ab1 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801ab1:	55                   	push   %ebp
  801ab2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	ff 75 0c             	pushl  0xc(%ebp)
  801abd:	ff 75 08             	pushl  0x8(%ebp)
  801ac0:	6a 10                	push   $0x10
  801ac2:	e8 97 fe ff ff       	call   80195e <syscall>
  801ac7:	83 c4 18             	add    $0x18,%esp
	return ;
  801aca:	90                   	nop
}
  801acb:	c9                   	leave  
  801acc:	c3                   	ret    

00801acd <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801acd:	55                   	push   %ebp
  801ace:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801ad0:	6a 00                	push   $0x0
  801ad2:	6a 00                	push   $0x0
  801ad4:	ff 75 10             	pushl  0x10(%ebp)
  801ad7:	ff 75 0c             	pushl  0xc(%ebp)
  801ada:	ff 75 08             	pushl  0x8(%ebp)
  801add:	6a 11                	push   $0x11
  801adf:	e8 7a fe ff ff       	call   80195e <syscall>
  801ae4:	83 c4 18             	add    $0x18,%esp
	return ;
  801ae7:	90                   	nop
}
  801ae8:	c9                   	leave  
  801ae9:	c3                   	ret    

00801aea <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801aea:	55                   	push   %ebp
  801aeb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801aed:	6a 00                	push   $0x0
  801aef:	6a 00                	push   $0x0
  801af1:	6a 00                	push   $0x0
  801af3:	6a 00                	push   $0x0
  801af5:	6a 00                	push   $0x0
  801af7:	6a 0c                	push   $0xc
  801af9:	e8 60 fe ff ff       	call   80195e <syscall>
  801afe:	83 c4 18             	add    $0x18,%esp
}
  801b01:	c9                   	leave  
  801b02:	c3                   	ret    

00801b03 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801b03:	55                   	push   %ebp
  801b04:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801b06:	6a 00                	push   $0x0
  801b08:	6a 00                	push   $0x0
  801b0a:	6a 00                	push   $0x0
  801b0c:	6a 00                	push   $0x0
  801b0e:	ff 75 08             	pushl  0x8(%ebp)
  801b11:	6a 0d                	push   $0xd
  801b13:	e8 46 fe ff ff       	call   80195e <syscall>
  801b18:	83 c4 18             	add    $0x18,%esp
}
  801b1b:	c9                   	leave  
  801b1c:	c3                   	ret    

00801b1d <sys_scarce_memory>:

void sys_scarce_memory()
{
  801b1d:	55                   	push   %ebp
  801b1e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801b20:	6a 00                	push   $0x0
  801b22:	6a 00                	push   $0x0
  801b24:	6a 00                	push   $0x0
  801b26:	6a 00                	push   $0x0
  801b28:	6a 00                	push   $0x0
  801b2a:	6a 0e                	push   $0xe
  801b2c:	e8 2d fe ff ff       	call   80195e <syscall>
  801b31:	83 c4 18             	add    $0x18,%esp
}
  801b34:	90                   	nop
  801b35:	c9                   	leave  
  801b36:	c3                   	ret    

00801b37 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801b37:	55                   	push   %ebp
  801b38:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801b3a:	6a 00                	push   $0x0
  801b3c:	6a 00                	push   $0x0
  801b3e:	6a 00                	push   $0x0
  801b40:	6a 00                	push   $0x0
  801b42:	6a 00                	push   $0x0
  801b44:	6a 13                	push   $0x13
  801b46:	e8 13 fe ff ff       	call   80195e <syscall>
  801b4b:	83 c4 18             	add    $0x18,%esp
}
  801b4e:	90                   	nop
  801b4f:	c9                   	leave  
  801b50:	c3                   	ret    

00801b51 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801b51:	55                   	push   %ebp
  801b52:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801b54:	6a 00                	push   $0x0
  801b56:	6a 00                	push   $0x0
  801b58:	6a 00                	push   $0x0
  801b5a:	6a 00                	push   $0x0
  801b5c:	6a 00                	push   $0x0
  801b5e:	6a 14                	push   $0x14
  801b60:	e8 f9 fd ff ff       	call   80195e <syscall>
  801b65:	83 c4 18             	add    $0x18,%esp
}
  801b68:	90                   	nop
  801b69:	c9                   	leave  
  801b6a:	c3                   	ret    

00801b6b <sys_cputc>:


void
sys_cputc(const char c)
{
  801b6b:	55                   	push   %ebp
  801b6c:	89 e5                	mov    %esp,%ebp
  801b6e:	83 ec 04             	sub    $0x4,%esp
  801b71:	8b 45 08             	mov    0x8(%ebp),%eax
  801b74:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b77:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b7b:	6a 00                	push   $0x0
  801b7d:	6a 00                	push   $0x0
  801b7f:	6a 00                	push   $0x0
  801b81:	6a 00                	push   $0x0
  801b83:	50                   	push   %eax
  801b84:	6a 15                	push   $0x15
  801b86:	e8 d3 fd ff ff       	call   80195e <syscall>
  801b8b:	83 c4 18             	add    $0x18,%esp
}
  801b8e:	90                   	nop
  801b8f:	c9                   	leave  
  801b90:	c3                   	ret    

00801b91 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b91:	55                   	push   %ebp
  801b92:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b94:	6a 00                	push   $0x0
  801b96:	6a 00                	push   $0x0
  801b98:	6a 00                	push   $0x0
  801b9a:	6a 00                	push   $0x0
  801b9c:	6a 00                	push   $0x0
  801b9e:	6a 16                	push   $0x16
  801ba0:	e8 b9 fd ff ff       	call   80195e <syscall>
  801ba5:	83 c4 18             	add    $0x18,%esp
}
  801ba8:	90                   	nop
  801ba9:	c9                   	leave  
  801baa:	c3                   	ret    

00801bab <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801bab:	55                   	push   %ebp
  801bac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801bae:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb1:	6a 00                	push   $0x0
  801bb3:	6a 00                	push   $0x0
  801bb5:	6a 00                	push   $0x0
  801bb7:	ff 75 0c             	pushl  0xc(%ebp)
  801bba:	50                   	push   %eax
  801bbb:	6a 17                	push   $0x17
  801bbd:	e8 9c fd ff ff       	call   80195e <syscall>
  801bc2:	83 c4 18             	add    $0x18,%esp
}
  801bc5:	c9                   	leave  
  801bc6:	c3                   	ret    

00801bc7 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801bc7:	55                   	push   %ebp
  801bc8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801bca:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd0:	6a 00                	push   $0x0
  801bd2:	6a 00                	push   $0x0
  801bd4:	6a 00                	push   $0x0
  801bd6:	52                   	push   %edx
  801bd7:	50                   	push   %eax
  801bd8:	6a 1a                	push   $0x1a
  801bda:	e8 7f fd ff ff       	call   80195e <syscall>
  801bdf:	83 c4 18             	add    $0x18,%esp
}
  801be2:	c9                   	leave  
  801be3:	c3                   	ret    

00801be4 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801be4:	55                   	push   %ebp
  801be5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801be7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bea:	8b 45 08             	mov    0x8(%ebp),%eax
  801bed:	6a 00                	push   $0x0
  801bef:	6a 00                	push   $0x0
  801bf1:	6a 00                	push   $0x0
  801bf3:	52                   	push   %edx
  801bf4:	50                   	push   %eax
  801bf5:	6a 18                	push   $0x18
  801bf7:	e8 62 fd ff ff       	call   80195e <syscall>
  801bfc:	83 c4 18             	add    $0x18,%esp
}
  801bff:	90                   	nop
  801c00:	c9                   	leave  
  801c01:	c3                   	ret    

00801c02 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801c02:	55                   	push   %ebp
  801c03:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c05:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c08:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0b:	6a 00                	push   $0x0
  801c0d:	6a 00                	push   $0x0
  801c0f:	6a 00                	push   $0x0
  801c11:	52                   	push   %edx
  801c12:	50                   	push   %eax
  801c13:	6a 19                	push   $0x19
  801c15:	e8 44 fd ff ff       	call   80195e <syscall>
  801c1a:	83 c4 18             	add    $0x18,%esp
}
  801c1d:	90                   	nop
  801c1e:	c9                   	leave  
  801c1f:	c3                   	ret    

00801c20 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801c20:	55                   	push   %ebp
  801c21:	89 e5                	mov    %esp,%ebp
  801c23:	83 ec 04             	sub    $0x4,%esp
  801c26:	8b 45 10             	mov    0x10(%ebp),%eax
  801c29:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801c2c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801c2f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c33:	8b 45 08             	mov    0x8(%ebp),%eax
  801c36:	6a 00                	push   $0x0
  801c38:	51                   	push   %ecx
  801c39:	52                   	push   %edx
  801c3a:	ff 75 0c             	pushl  0xc(%ebp)
  801c3d:	50                   	push   %eax
  801c3e:	6a 1b                	push   $0x1b
  801c40:	e8 19 fd ff ff       	call   80195e <syscall>
  801c45:	83 c4 18             	add    $0x18,%esp
}
  801c48:	c9                   	leave  
  801c49:	c3                   	ret    

00801c4a <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801c4a:	55                   	push   %ebp
  801c4b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801c4d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c50:	8b 45 08             	mov    0x8(%ebp),%eax
  801c53:	6a 00                	push   $0x0
  801c55:	6a 00                	push   $0x0
  801c57:	6a 00                	push   $0x0
  801c59:	52                   	push   %edx
  801c5a:	50                   	push   %eax
  801c5b:	6a 1c                	push   $0x1c
  801c5d:	e8 fc fc ff ff       	call   80195e <syscall>
  801c62:	83 c4 18             	add    $0x18,%esp
}
  801c65:	c9                   	leave  
  801c66:	c3                   	ret    

00801c67 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801c67:	55                   	push   %ebp
  801c68:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801c6a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c6d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c70:	8b 45 08             	mov    0x8(%ebp),%eax
  801c73:	6a 00                	push   $0x0
  801c75:	6a 00                	push   $0x0
  801c77:	51                   	push   %ecx
  801c78:	52                   	push   %edx
  801c79:	50                   	push   %eax
  801c7a:	6a 1d                	push   $0x1d
  801c7c:	e8 dd fc ff ff       	call   80195e <syscall>
  801c81:	83 c4 18             	add    $0x18,%esp
}
  801c84:	c9                   	leave  
  801c85:	c3                   	ret    

00801c86 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801c86:	55                   	push   %ebp
  801c87:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801c89:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8f:	6a 00                	push   $0x0
  801c91:	6a 00                	push   $0x0
  801c93:	6a 00                	push   $0x0
  801c95:	52                   	push   %edx
  801c96:	50                   	push   %eax
  801c97:	6a 1e                	push   $0x1e
  801c99:	e8 c0 fc ff ff       	call   80195e <syscall>
  801c9e:	83 c4 18             	add    $0x18,%esp
}
  801ca1:	c9                   	leave  
  801ca2:	c3                   	ret    

00801ca3 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801ca3:	55                   	push   %ebp
  801ca4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801ca6:	6a 00                	push   $0x0
  801ca8:	6a 00                	push   $0x0
  801caa:	6a 00                	push   $0x0
  801cac:	6a 00                	push   $0x0
  801cae:	6a 00                	push   $0x0
  801cb0:	6a 1f                	push   $0x1f
  801cb2:	e8 a7 fc ff ff       	call   80195e <syscall>
  801cb7:	83 c4 18             	add    $0x18,%esp
}
  801cba:	c9                   	leave  
  801cbb:	c3                   	ret    

00801cbc <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801cbc:	55                   	push   %ebp
  801cbd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801cbf:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc2:	6a 00                	push   $0x0
  801cc4:	ff 75 14             	pushl  0x14(%ebp)
  801cc7:	ff 75 10             	pushl  0x10(%ebp)
  801cca:	ff 75 0c             	pushl  0xc(%ebp)
  801ccd:	50                   	push   %eax
  801cce:	6a 20                	push   $0x20
  801cd0:	e8 89 fc ff ff       	call   80195e <syscall>
  801cd5:	83 c4 18             	add    $0x18,%esp
}
  801cd8:	c9                   	leave  
  801cd9:	c3                   	ret    

00801cda <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801cda:	55                   	push   %ebp
  801cdb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce0:	6a 00                	push   $0x0
  801ce2:	6a 00                	push   $0x0
  801ce4:	6a 00                	push   $0x0
  801ce6:	6a 00                	push   $0x0
  801ce8:	50                   	push   %eax
  801ce9:	6a 21                	push   $0x21
  801ceb:	e8 6e fc ff ff       	call   80195e <syscall>
  801cf0:	83 c4 18             	add    $0x18,%esp
}
  801cf3:	90                   	nop
  801cf4:	c9                   	leave  
  801cf5:	c3                   	ret    

00801cf6 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801cf6:	55                   	push   %ebp
  801cf7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfc:	6a 00                	push   $0x0
  801cfe:	6a 00                	push   $0x0
  801d00:	6a 00                	push   $0x0
  801d02:	6a 00                	push   $0x0
  801d04:	50                   	push   %eax
  801d05:	6a 22                	push   $0x22
  801d07:	e8 52 fc ff ff       	call   80195e <syscall>
  801d0c:	83 c4 18             	add    $0x18,%esp
}
  801d0f:	c9                   	leave  
  801d10:	c3                   	ret    

00801d11 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801d11:	55                   	push   %ebp
  801d12:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801d14:	6a 00                	push   $0x0
  801d16:	6a 00                	push   $0x0
  801d18:	6a 00                	push   $0x0
  801d1a:	6a 00                	push   $0x0
  801d1c:	6a 00                	push   $0x0
  801d1e:	6a 02                	push   $0x2
  801d20:	e8 39 fc ff ff       	call   80195e <syscall>
  801d25:	83 c4 18             	add    $0x18,%esp
}
  801d28:	c9                   	leave  
  801d29:	c3                   	ret    

00801d2a <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801d2a:	55                   	push   %ebp
  801d2b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801d2d:	6a 00                	push   $0x0
  801d2f:	6a 00                	push   $0x0
  801d31:	6a 00                	push   $0x0
  801d33:	6a 00                	push   $0x0
  801d35:	6a 00                	push   $0x0
  801d37:	6a 03                	push   $0x3
  801d39:	e8 20 fc ff ff       	call   80195e <syscall>
  801d3e:	83 c4 18             	add    $0x18,%esp
}
  801d41:	c9                   	leave  
  801d42:	c3                   	ret    

00801d43 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801d43:	55                   	push   %ebp
  801d44:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801d46:	6a 00                	push   $0x0
  801d48:	6a 00                	push   $0x0
  801d4a:	6a 00                	push   $0x0
  801d4c:	6a 00                	push   $0x0
  801d4e:	6a 00                	push   $0x0
  801d50:	6a 04                	push   $0x4
  801d52:	e8 07 fc ff ff       	call   80195e <syscall>
  801d57:	83 c4 18             	add    $0x18,%esp
}
  801d5a:	c9                   	leave  
  801d5b:	c3                   	ret    

00801d5c <sys_exit_env>:


void sys_exit_env(void)
{
  801d5c:	55                   	push   %ebp
  801d5d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801d5f:	6a 00                	push   $0x0
  801d61:	6a 00                	push   $0x0
  801d63:	6a 00                	push   $0x0
  801d65:	6a 00                	push   $0x0
  801d67:	6a 00                	push   $0x0
  801d69:	6a 23                	push   $0x23
  801d6b:	e8 ee fb ff ff       	call   80195e <syscall>
  801d70:	83 c4 18             	add    $0x18,%esp
}
  801d73:	90                   	nop
  801d74:	c9                   	leave  
  801d75:	c3                   	ret    

00801d76 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801d76:	55                   	push   %ebp
  801d77:	89 e5                	mov    %esp,%ebp
  801d79:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801d7c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d7f:	8d 50 04             	lea    0x4(%eax),%edx
  801d82:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d85:	6a 00                	push   $0x0
  801d87:	6a 00                	push   $0x0
  801d89:	6a 00                	push   $0x0
  801d8b:	52                   	push   %edx
  801d8c:	50                   	push   %eax
  801d8d:	6a 24                	push   $0x24
  801d8f:	e8 ca fb ff ff       	call   80195e <syscall>
  801d94:	83 c4 18             	add    $0x18,%esp
	return result;
  801d97:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d9a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d9d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801da0:	89 01                	mov    %eax,(%ecx)
  801da2:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801da5:	8b 45 08             	mov    0x8(%ebp),%eax
  801da8:	c9                   	leave  
  801da9:	c2 04 00             	ret    $0x4

00801dac <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801dac:	55                   	push   %ebp
  801dad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801daf:	6a 00                	push   $0x0
  801db1:	6a 00                	push   $0x0
  801db3:	ff 75 10             	pushl  0x10(%ebp)
  801db6:	ff 75 0c             	pushl  0xc(%ebp)
  801db9:	ff 75 08             	pushl  0x8(%ebp)
  801dbc:	6a 12                	push   $0x12
  801dbe:	e8 9b fb ff ff       	call   80195e <syscall>
  801dc3:	83 c4 18             	add    $0x18,%esp
	return ;
  801dc6:	90                   	nop
}
  801dc7:	c9                   	leave  
  801dc8:	c3                   	ret    

00801dc9 <sys_rcr2>:
uint32 sys_rcr2()
{
  801dc9:	55                   	push   %ebp
  801dca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801dcc:	6a 00                	push   $0x0
  801dce:	6a 00                	push   $0x0
  801dd0:	6a 00                	push   $0x0
  801dd2:	6a 00                	push   $0x0
  801dd4:	6a 00                	push   $0x0
  801dd6:	6a 25                	push   $0x25
  801dd8:	e8 81 fb ff ff       	call   80195e <syscall>
  801ddd:	83 c4 18             	add    $0x18,%esp
}
  801de0:	c9                   	leave  
  801de1:	c3                   	ret    

00801de2 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801de2:	55                   	push   %ebp
  801de3:	89 e5                	mov    %esp,%ebp
  801de5:	83 ec 04             	sub    $0x4,%esp
  801de8:	8b 45 08             	mov    0x8(%ebp),%eax
  801deb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801dee:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801df2:	6a 00                	push   $0x0
  801df4:	6a 00                	push   $0x0
  801df6:	6a 00                	push   $0x0
  801df8:	6a 00                	push   $0x0
  801dfa:	50                   	push   %eax
  801dfb:	6a 26                	push   $0x26
  801dfd:	e8 5c fb ff ff       	call   80195e <syscall>
  801e02:	83 c4 18             	add    $0x18,%esp
	return ;
  801e05:	90                   	nop
}
  801e06:	c9                   	leave  
  801e07:	c3                   	ret    

00801e08 <rsttst>:
void rsttst()
{
  801e08:	55                   	push   %ebp
  801e09:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801e0b:	6a 00                	push   $0x0
  801e0d:	6a 00                	push   $0x0
  801e0f:	6a 00                	push   $0x0
  801e11:	6a 00                	push   $0x0
  801e13:	6a 00                	push   $0x0
  801e15:	6a 28                	push   $0x28
  801e17:	e8 42 fb ff ff       	call   80195e <syscall>
  801e1c:	83 c4 18             	add    $0x18,%esp
	return ;
  801e1f:	90                   	nop
}
  801e20:	c9                   	leave  
  801e21:	c3                   	ret    

00801e22 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801e22:	55                   	push   %ebp
  801e23:	89 e5                	mov    %esp,%ebp
  801e25:	83 ec 04             	sub    $0x4,%esp
  801e28:	8b 45 14             	mov    0x14(%ebp),%eax
  801e2b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801e2e:	8b 55 18             	mov    0x18(%ebp),%edx
  801e31:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e35:	52                   	push   %edx
  801e36:	50                   	push   %eax
  801e37:	ff 75 10             	pushl  0x10(%ebp)
  801e3a:	ff 75 0c             	pushl  0xc(%ebp)
  801e3d:	ff 75 08             	pushl  0x8(%ebp)
  801e40:	6a 27                	push   $0x27
  801e42:	e8 17 fb ff ff       	call   80195e <syscall>
  801e47:	83 c4 18             	add    $0x18,%esp
	return ;
  801e4a:	90                   	nop
}
  801e4b:	c9                   	leave  
  801e4c:	c3                   	ret    

00801e4d <chktst>:
void chktst(uint32 n)
{
  801e4d:	55                   	push   %ebp
  801e4e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801e50:	6a 00                	push   $0x0
  801e52:	6a 00                	push   $0x0
  801e54:	6a 00                	push   $0x0
  801e56:	6a 00                	push   $0x0
  801e58:	ff 75 08             	pushl  0x8(%ebp)
  801e5b:	6a 29                	push   $0x29
  801e5d:	e8 fc fa ff ff       	call   80195e <syscall>
  801e62:	83 c4 18             	add    $0x18,%esp
	return ;
  801e65:	90                   	nop
}
  801e66:	c9                   	leave  
  801e67:	c3                   	ret    

00801e68 <inctst>:

void inctst()
{
  801e68:	55                   	push   %ebp
  801e69:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801e6b:	6a 00                	push   $0x0
  801e6d:	6a 00                	push   $0x0
  801e6f:	6a 00                	push   $0x0
  801e71:	6a 00                	push   $0x0
  801e73:	6a 00                	push   $0x0
  801e75:	6a 2a                	push   $0x2a
  801e77:	e8 e2 fa ff ff       	call   80195e <syscall>
  801e7c:	83 c4 18             	add    $0x18,%esp
	return ;
  801e7f:	90                   	nop
}
  801e80:	c9                   	leave  
  801e81:	c3                   	ret    

00801e82 <gettst>:
uint32 gettst()
{
  801e82:	55                   	push   %ebp
  801e83:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801e85:	6a 00                	push   $0x0
  801e87:	6a 00                	push   $0x0
  801e89:	6a 00                	push   $0x0
  801e8b:	6a 00                	push   $0x0
  801e8d:	6a 00                	push   $0x0
  801e8f:	6a 2b                	push   $0x2b
  801e91:	e8 c8 fa ff ff       	call   80195e <syscall>
  801e96:	83 c4 18             	add    $0x18,%esp
}
  801e99:	c9                   	leave  
  801e9a:	c3                   	ret    

00801e9b <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801e9b:	55                   	push   %ebp
  801e9c:	89 e5                	mov    %esp,%ebp
  801e9e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ea1:	6a 00                	push   $0x0
  801ea3:	6a 00                	push   $0x0
  801ea5:	6a 00                	push   $0x0
  801ea7:	6a 00                	push   $0x0
  801ea9:	6a 00                	push   $0x0
  801eab:	6a 2c                	push   $0x2c
  801ead:	e8 ac fa ff ff       	call   80195e <syscall>
  801eb2:	83 c4 18             	add    $0x18,%esp
  801eb5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801eb8:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801ebc:	75 07                	jne    801ec5 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801ebe:	b8 01 00 00 00       	mov    $0x1,%eax
  801ec3:	eb 05                	jmp    801eca <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801ec5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eca:	c9                   	leave  
  801ecb:	c3                   	ret    

00801ecc <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801ecc:	55                   	push   %ebp
  801ecd:	89 e5                	mov    %esp,%ebp
  801ecf:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ed2:	6a 00                	push   $0x0
  801ed4:	6a 00                	push   $0x0
  801ed6:	6a 00                	push   $0x0
  801ed8:	6a 00                	push   $0x0
  801eda:	6a 00                	push   $0x0
  801edc:	6a 2c                	push   $0x2c
  801ede:	e8 7b fa ff ff       	call   80195e <syscall>
  801ee3:	83 c4 18             	add    $0x18,%esp
  801ee6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801ee9:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801eed:	75 07                	jne    801ef6 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801eef:	b8 01 00 00 00       	mov    $0x1,%eax
  801ef4:	eb 05                	jmp    801efb <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801ef6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801efb:	c9                   	leave  
  801efc:	c3                   	ret    

00801efd <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801efd:	55                   	push   %ebp
  801efe:	89 e5                	mov    %esp,%ebp
  801f00:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f03:	6a 00                	push   $0x0
  801f05:	6a 00                	push   $0x0
  801f07:	6a 00                	push   $0x0
  801f09:	6a 00                	push   $0x0
  801f0b:	6a 00                	push   $0x0
  801f0d:	6a 2c                	push   $0x2c
  801f0f:	e8 4a fa ff ff       	call   80195e <syscall>
  801f14:	83 c4 18             	add    $0x18,%esp
  801f17:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801f1a:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801f1e:	75 07                	jne    801f27 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801f20:	b8 01 00 00 00       	mov    $0x1,%eax
  801f25:	eb 05                	jmp    801f2c <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801f27:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f2c:	c9                   	leave  
  801f2d:	c3                   	ret    

00801f2e <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801f2e:	55                   	push   %ebp
  801f2f:	89 e5                	mov    %esp,%ebp
  801f31:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f34:	6a 00                	push   $0x0
  801f36:	6a 00                	push   $0x0
  801f38:	6a 00                	push   $0x0
  801f3a:	6a 00                	push   $0x0
  801f3c:	6a 00                	push   $0x0
  801f3e:	6a 2c                	push   $0x2c
  801f40:	e8 19 fa ff ff       	call   80195e <syscall>
  801f45:	83 c4 18             	add    $0x18,%esp
  801f48:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801f4b:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801f4f:	75 07                	jne    801f58 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801f51:	b8 01 00 00 00       	mov    $0x1,%eax
  801f56:	eb 05                	jmp    801f5d <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801f58:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f5d:	c9                   	leave  
  801f5e:	c3                   	ret    

00801f5f <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801f5f:	55                   	push   %ebp
  801f60:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801f62:	6a 00                	push   $0x0
  801f64:	6a 00                	push   $0x0
  801f66:	6a 00                	push   $0x0
  801f68:	6a 00                	push   $0x0
  801f6a:	ff 75 08             	pushl  0x8(%ebp)
  801f6d:	6a 2d                	push   $0x2d
  801f6f:	e8 ea f9 ff ff       	call   80195e <syscall>
  801f74:	83 c4 18             	add    $0x18,%esp
	return ;
  801f77:	90                   	nop
}
  801f78:	c9                   	leave  
  801f79:	c3                   	ret    

00801f7a <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801f7a:	55                   	push   %ebp
  801f7b:	89 e5                	mov    %esp,%ebp
  801f7d:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801f7e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f81:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f84:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f87:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8a:	6a 00                	push   $0x0
  801f8c:	53                   	push   %ebx
  801f8d:	51                   	push   %ecx
  801f8e:	52                   	push   %edx
  801f8f:	50                   	push   %eax
  801f90:	6a 2e                	push   $0x2e
  801f92:	e8 c7 f9 ff ff       	call   80195e <syscall>
  801f97:	83 c4 18             	add    $0x18,%esp
}
  801f9a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f9d:	c9                   	leave  
  801f9e:	c3                   	ret    

00801f9f <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801f9f:	55                   	push   %ebp
  801fa0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801fa2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa8:	6a 00                	push   $0x0
  801faa:	6a 00                	push   $0x0
  801fac:	6a 00                	push   $0x0
  801fae:	52                   	push   %edx
  801faf:	50                   	push   %eax
  801fb0:	6a 2f                	push   $0x2f
  801fb2:	e8 a7 f9 ff ff       	call   80195e <syscall>
  801fb7:	83 c4 18             	add    $0x18,%esp
}
  801fba:	c9                   	leave  
  801fbb:	c3                   	ret    

00801fbc <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801fbc:	55                   	push   %ebp
  801fbd:	89 e5                	mov    %esp,%ebp
  801fbf:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801fc2:	83 ec 0c             	sub    $0xc,%esp
  801fc5:	68 24 42 80 00       	push   $0x804224
  801fca:	e8 8c e7 ff ff       	call   80075b <cprintf>
  801fcf:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801fd2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801fd9:	83 ec 0c             	sub    $0xc,%esp
  801fdc:	68 50 42 80 00       	push   $0x804250
  801fe1:	e8 75 e7 ff ff       	call   80075b <cprintf>
  801fe6:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801fe9:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801fed:	a1 38 51 80 00       	mov    0x805138,%eax
  801ff2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ff5:	eb 56                	jmp    80204d <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801ff7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ffb:	74 1c                	je     802019 <print_mem_block_lists+0x5d>
  801ffd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802000:	8b 50 08             	mov    0x8(%eax),%edx
  802003:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802006:	8b 48 08             	mov    0x8(%eax),%ecx
  802009:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80200c:	8b 40 0c             	mov    0xc(%eax),%eax
  80200f:	01 c8                	add    %ecx,%eax
  802011:	39 c2                	cmp    %eax,%edx
  802013:	73 04                	jae    802019 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802015:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802019:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80201c:	8b 50 08             	mov    0x8(%eax),%edx
  80201f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802022:	8b 40 0c             	mov    0xc(%eax),%eax
  802025:	01 c2                	add    %eax,%edx
  802027:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80202a:	8b 40 08             	mov    0x8(%eax),%eax
  80202d:	83 ec 04             	sub    $0x4,%esp
  802030:	52                   	push   %edx
  802031:	50                   	push   %eax
  802032:	68 65 42 80 00       	push   $0x804265
  802037:	e8 1f e7 ff ff       	call   80075b <cprintf>
  80203c:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80203f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802042:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802045:	a1 40 51 80 00       	mov    0x805140,%eax
  80204a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80204d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802051:	74 07                	je     80205a <print_mem_block_lists+0x9e>
  802053:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802056:	8b 00                	mov    (%eax),%eax
  802058:	eb 05                	jmp    80205f <print_mem_block_lists+0xa3>
  80205a:	b8 00 00 00 00       	mov    $0x0,%eax
  80205f:	a3 40 51 80 00       	mov    %eax,0x805140
  802064:	a1 40 51 80 00       	mov    0x805140,%eax
  802069:	85 c0                	test   %eax,%eax
  80206b:	75 8a                	jne    801ff7 <print_mem_block_lists+0x3b>
  80206d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802071:	75 84                	jne    801ff7 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802073:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802077:	75 10                	jne    802089 <print_mem_block_lists+0xcd>
  802079:	83 ec 0c             	sub    $0xc,%esp
  80207c:	68 74 42 80 00       	push   $0x804274
  802081:	e8 d5 e6 ff ff       	call   80075b <cprintf>
  802086:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802089:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802090:	83 ec 0c             	sub    $0xc,%esp
  802093:	68 98 42 80 00       	push   $0x804298
  802098:	e8 be e6 ff ff       	call   80075b <cprintf>
  80209d:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8020a0:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8020a4:	a1 40 50 80 00       	mov    0x805040,%eax
  8020a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020ac:	eb 56                	jmp    802104 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8020ae:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020b2:	74 1c                	je     8020d0 <print_mem_block_lists+0x114>
  8020b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b7:	8b 50 08             	mov    0x8(%eax),%edx
  8020ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020bd:	8b 48 08             	mov    0x8(%eax),%ecx
  8020c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020c3:	8b 40 0c             	mov    0xc(%eax),%eax
  8020c6:	01 c8                	add    %ecx,%eax
  8020c8:	39 c2                	cmp    %eax,%edx
  8020ca:	73 04                	jae    8020d0 <print_mem_block_lists+0x114>
			sorted = 0 ;
  8020cc:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8020d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d3:	8b 50 08             	mov    0x8(%eax),%edx
  8020d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d9:	8b 40 0c             	mov    0xc(%eax),%eax
  8020dc:	01 c2                	add    %eax,%edx
  8020de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e1:	8b 40 08             	mov    0x8(%eax),%eax
  8020e4:	83 ec 04             	sub    $0x4,%esp
  8020e7:	52                   	push   %edx
  8020e8:	50                   	push   %eax
  8020e9:	68 65 42 80 00       	push   $0x804265
  8020ee:	e8 68 e6 ff ff       	call   80075b <cprintf>
  8020f3:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8020f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8020fc:	a1 48 50 80 00       	mov    0x805048,%eax
  802101:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802104:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802108:	74 07                	je     802111 <print_mem_block_lists+0x155>
  80210a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80210d:	8b 00                	mov    (%eax),%eax
  80210f:	eb 05                	jmp    802116 <print_mem_block_lists+0x15a>
  802111:	b8 00 00 00 00       	mov    $0x0,%eax
  802116:	a3 48 50 80 00       	mov    %eax,0x805048
  80211b:	a1 48 50 80 00       	mov    0x805048,%eax
  802120:	85 c0                	test   %eax,%eax
  802122:	75 8a                	jne    8020ae <print_mem_block_lists+0xf2>
  802124:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802128:	75 84                	jne    8020ae <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80212a:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80212e:	75 10                	jne    802140 <print_mem_block_lists+0x184>
  802130:	83 ec 0c             	sub    $0xc,%esp
  802133:	68 b0 42 80 00       	push   $0x8042b0
  802138:	e8 1e e6 ff ff       	call   80075b <cprintf>
  80213d:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802140:	83 ec 0c             	sub    $0xc,%esp
  802143:	68 24 42 80 00       	push   $0x804224
  802148:	e8 0e e6 ff ff       	call   80075b <cprintf>
  80214d:	83 c4 10             	add    $0x10,%esp

}
  802150:	90                   	nop
  802151:	c9                   	leave  
  802152:	c3                   	ret    

00802153 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802153:	55                   	push   %ebp
  802154:	89 e5                	mov    %esp,%ebp
  802156:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  802159:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802160:	00 00 00 
  802163:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80216a:	00 00 00 
  80216d:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802174:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  802177:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80217e:	e9 9e 00 00 00       	jmp    802221 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802183:	a1 50 50 80 00       	mov    0x805050,%eax
  802188:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80218b:	c1 e2 04             	shl    $0x4,%edx
  80218e:	01 d0                	add    %edx,%eax
  802190:	85 c0                	test   %eax,%eax
  802192:	75 14                	jne    8021a8 <initialize_MemBlocksList+0x55>
  802194:	83 ec 04             	sub    $0x4,%esp
  802197:	68 d8 42 80 00       	push   $0x8042d8
  80219c:	6a 46                	push   $0x46
  80219e:	68 fb 42 80 00       	push   $0x8042fb
  8021a3:	e8 ff e2 ff ff       	call   8004a7 <_panic>
  8021a8:	a1 50 50 80 00       	mov    0x805050,%eax
  8021ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021b0:	c1 e2 04             	shl    $0x4,%edx
  8021b3:	01 d0                	add    %edx,%eax
  8021b5:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8021bb:	89 10                	mov    %edx,(%eax)
  8021bd:	8b 00                	mov    (%eax),%eax
  8021bf:	85 c0                	test   %eax,%eax
  8021c1:	74 18                	je     8021db <initialize_MemBlocksList+0x88>
  8021c3:	a1 48 51 80 00       	mov    0x805148,%eax
  8021c8:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8021ce:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8021d1:	c1 e1 04             	shl    $0x4,%ecx
  8021d4:	01 ca                	add    %ecx,%edx
  8021d6:	89 50 04             	mov    %edx,0x4(%eax)
  8021d9:	eb 12                	jmp    8021ed <initialize_MemBlocksList+0x9a>
  8021db:	a1 50 50 80 00       	mov    0x805050,%eax
  8021e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021e3:	c1 e2 04             	shl    $0x4,%edx
  8021e6:	01 d0                	add    %edx,%eax
  8021e8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8021ed:	a1 50 50 80 00       	mov    0x805050,%eax
  8021f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021f5:	c1 e2 04             	shl    $0x4,%edx
  8021f8:	01 d0                	add    %edx,%eax
  8021fa:	a3 48 51 80 00       	mov    %eax,0x805148
  8021ff:	a1 50 50 80 00       	mov    0x805050,%eax
  802204:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802207:	c1 e2 04             	shl    $0x4,%edx
  80220a:	01 d0                	add    %edx,%eax
  80220c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802213:	a1 54 51 80 00       	mov    0x805154,%eax
  802218:	40                   	inc    %eax
  802219:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  80221e:	ff 45 f4             	incl   -0xc(%ebp)
  802221:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802224:	3b 45 08             	cmp    0x8(%ebp),%eax
  802227:	0f 82 56 ff ff ff    	jb     802183 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  80222d:	90                   	nop
  80222e:	c9                   	leave  
  80222f:	c3                   	ret    

00802230 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802230:	55                   	push   %ebp
  802231:	89 e5                	mov    %esp,%ebp
  802233:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802236:	8b 45 08             	mov    0x8(%ebp),%eax
  802239:	8b 00                	mov    (%eax),%eax
  80223b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80223e:	eb 19                	jmp    802259 <find_block+0x29>
	{
		if(va==point->sva)
  802240:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802243:	8b 40 08             	mov    0x8(%eax),%eax
  802246:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802249:	75 05                	jne    802250 <find_block+0x20>
		   return point;
  80224b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80224e:	eb 36                	jmp    802286 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802250:	8b 45 08             	mov    0x8(%ebp),%eax
  802253:	8b 40 08             	mov    0x8(%eax),%eax
  802256:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802259:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80225d:	74 07                	je     802266 <find_block+0x36>
  80225f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802262:	8b 00                	mov    (%eax),%eax
  802264:	eb 05                	jmp    80226b <find_block+0x3b>
  802266:	b8 00 00 00 00       	mov    $0x0,%eax
  80226b:	8b 55 08             	mov    0x8(%ebp),%edx
  80226e:	89 42 08             	mov    %eax,0x8(%edx)
  802271:	8b 45 08             	mov    0x8(%ebp),%eax
  802274:	8b 40 08             	mov    0x8(%eax),%eax
  802277:	85 c0                	test   %eax,%eax
  802279:	75 c5                	jne    802240 <find_block+0x10>
  80227b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80227f:	75 bf                	jne    802240 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802281:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802286:	c9                   	leave  
  802287:	c3                   	ret    

00802288 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802288:	55                   	push   %ebp
  802289:	89 e5                	mov    %esp,%ebp
  80228b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  80228e:	a1 40 50 80 00       	mov    0x805040,%eax
  802293:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802296:	a1 44 50 80 00       	mov    0x805044,%eax
  80229b:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  80229e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022a1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8022a4:	74 24                	je     8022ca <insert_sorted_allocList+0x42>
  8022a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a9:	8b 50 08             	mov    0x8(%eax),%edx
  8022ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022af:	8b 40 08             	mov    0x8(%eax),%eax
  8022b2:	39 c2                	cmp    %eax,%edx
  8022b4:	76 14                	jbe    8022ca <insert_sorted_allocList+0x42>
  8022b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b9:	8b 50 08             	mov    0x8(%eax),%edx
  8022bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022bf:	8b 40 08             	mov    0x8(%eax),%eax
  8022c2:	39 c2                	cmp    %eax,%edx
  8022c4:	0f 82 60 01 00 00    	jb     80242a <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8022ca:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022ce:	75 65                	jne    802335 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8022d0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022d4:	75 14                	jne    8022ea <insert_sorted_allocList+0x62>
  8022d6:	83 ec 04             	sub    $0x4,%esp
  8022d9:	68 d8 42 80 00       	push   $0x8042d8
  8022de:	6a 6b                	push   $0x6b
  8022e0:	68 fb 42 80 00       	push   $0x8042fb
  8022e5:	e8 bd e1 ff ff       	call   8004a7 <_panic>
  8022ea:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8022f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f3:	89 10                	mov    %edx,(%eax)
  8022f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f8:	8b 00                	mov    (%eax),%eax
  8022fa:	85 c0                	test   %eax,%eax
  8022fc:	74 0d                	je     80230b <insert_sorted_allocList+0x83>
  8022fe:	a1 40 50 80 00       	mov    0x805040,%eax
  802303:	8b 55 08             	mov    0x8(%ebp),%edx
  802306:	89 50 04             	mov    %edx,0x4(%eax)
  802309:	eb 08                	jmp    802313 <insert_sorted_allocList+0x8b>
  80230b:	8b 45 08             	mov    0x8(%ebp),%eax
  80230e:	a3 44 50 80 00       	mov    %eax,0x805044
  802313:	8b 45 08             	mov    0x8(%ebp),%eax
  802316:	a3 40 50 80 00       	mov    %eax,0x805040
  80231b:	8b 45 08             	mov    0x8(%ebp),%eax
  80231e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802325:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80232a:	40                   	inc    %eax
  80232b:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802330:	e9 dc 01 00 00       	jmp    802511 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802335:	8b 45 08             	mov    0x8(%ebp),%eax
  802338:	8b 50 08             	mov    0x8(%eax),%edx
  80233b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80233e:	8b 40 08             	mov    0x8(%eax),%eax
  802341:	39 c2                	cmp    %eax,%edx
  802343:	77 6c                	ja     8023b1 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802345:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802349:	74 06                	je     802351 <insert_sorted_allocList+0xc9>
  80234b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80234f:	75 14                	jne    802365 <insert_sorted_allocList+0xdd>
  802351:	83 ec 04             	sub    $0x4,%esp
  802354:	68 14 43 80 00       	push   $0x804314
  802359:	6a 6f                	push   $0x6f
  80235b:	68 fb 42 80 00       	push   $0x8042fb
  802360:	e8 42 e1 ff ff       	call   8004a7 <_panic>
  802365:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802368:	8b 50 04             	mov    0x4(%eax),%edx
  80236b:	8b 45 08             	mov    0x8(%ebp),%eax
  80236e:	89 50 04             	mov    %edx,0x4(%eax)
  802371:	8b 45 08             	mov    0x8(%ebp),%eax
  802374:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802377:	89 10                	mov    %edx,(%eax)
  802379:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80237c:	8b 40 04             	mov    0x4(%eax),%eax
  80237f:	85 c0                	test   %eax,%eax
  802381:	74 0d                	je     802390 <insert_sorted_allocList+0x108>
  802383:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802386:	8b 40 04             	mov    0x4(%eax),%eax
  802389:	8b 55 08             	mov    0x8(%ebp),%edx
  80238c:	89 10                	mov    %edx,(%eax)
  80238e:	eb 08                	jmp    802398 <insert_sorted_allocList+0x110>
  802390:	8b 45 08             	mov    0x8(%ebp),%eax
  802393:	a3 40 50 80 00       	mov    %eax,0x805040
  802398:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80239b:	8b 55 08             	mov    0x8(%ebp),%edx
  80239e:	89 50 04             	mov    %edx,0x4(%eax)
  8023a1:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8023a6:	40                   	inc    %eax
  8023a7:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8023ac:	e9 60 01 00 00       	jmp    802511 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8023b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b4:	8b 50 08             	mov    0x8(%eax),%edx
  8023b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023ba:	8b 40 08             	mov    0x8(%eax),%eax
  8023bd:	39 c2                	cmp    %eax,%edx
  8023bf:	0f 82 4c 01 00 00    	jb     802511 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8023c5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023c9:	75 14                	jne    8023df <insert_sorted_allocList+0x157>
  8023cb:	83 ec 04             	sub    $0x4,%esp
  8023ce:	68 4c 43 80 00       	push   $0x80434c
  8023d3:	6a 73                	push   $0x73
  8023d5:	68 fb 42 80 00       	push   $0x8042fb
  8023da:	e8 c8 e0 ff ff       	call   8004a7 <_panic>
  8023df:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8023e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e8:	89 50 04             	mov    %edx,0x4(%eax)
  8023eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ee:	8b 40 04             	mov    0x4(%eax),%eax
  8023f1:	85 c0                	test   %eax,%eax
  8023f3:	74 0c                	je     802401 <insert_sorted_allocList+0x179>
  8023f5:	a1 44 50 80 00       	mov    0x805044,%eax
  8023fa:	8b 55 08             	mov    0x8(%ebp),%edx
  8023fd:	89 10                	mov    %edx,(%eax)
  8023ff:	eb 08                	jmp    802409 <insert_sorted_allocList+0x181>
  802401:	8b 45 08             	mov    0x8(%ebp),%eax
  802404:	a3 40 50 80 00       	mov    %eax,0x805040
  802409:	8b 45 08             	mov    0x8(%ebp),%eax
  80240c:	a3 44 50 80 00       	mov    %eax,0x805044
  802411:	8b 45 08             	mov    0x8(%ebp),%eax
  802414:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80241a:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80241f:	40                   	inc    %eax
  802420:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802425:	e9 e7 00 00 00       	jmp    802511 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  80242a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80242d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802430:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802437:	a1 40 50 80 00       	mov    0x805040,%eax
  80243c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80243f:	e9 9d 00 00 00       	jmp    8024e1 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802444:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802447:	8b 00                	mov    (%eax),%eax
  802449:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  80244c:	8b 45 08             	mov    0x8(%ebp),%eax
  80244f:	8b 50 08             	mov    0x8(%eax),%edx
  802452:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802455:	8b 40 08             	mov    0x8(%eax),%eax
  802458:	39 c2                	cmp    %eax,%edx
  80245a:	76 7d                	jbe    8024d9 <insert_sorted_allocList+0x251>
  80245c:	8b 45 08             	mov    0x8(%ebp),%eax
  80245f:	8b 50 08             	mov    0x8(%eax),%edx
  802462:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802465:	8b 40 08             	mov    0x8(%eax),%eax
  802468:	39 c2                	cmp    %eax,%edx
  80246a:	73 6d                	jae    8024d9 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  80246c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802470:	74 06                	je     802478 <insert_sorted_allocList+0x1f0>
  802472:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802476:	75 14                	jne    80248c <insert_sorted_allocList+0x204>
  802478:	83 ec 04             	sub    $0x4,%esp
  80247b:	68 70 43 80 00       	push   $0x804370
  802480:	6a 7f                	push   $0x7f
  802482:	68 fb 42 80 00       	push   $0x8042fb
  802487:	e8 1b e0 ff ff       	call   8004a7 <_panic>
  80248c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248f:	8b 10                	mov    (%eax),%edx
  802491:	8b 45 08             	mov    0x8(%ebp),%eax
  802494:	89 10                	mov    %edx,(%eax)
  802496:	8b 45 08             	mov    0x8(%ebp),%eax
  802499:	8b 00                	mov    (%eax),%eax
  80249b:	85 c0                	test   %eax,%eax
  80249d:	74 0b                	je     8024aa <insert_sorted_allocList+0x222>
  80249f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a2:	8b 00                	mov    (%eax),%eax
  8024a4:	8b 55 08             	mov    0x8(%ebp),%edx
  8024a7:	89 50 04             	mov    %edx,0x4(%eax)
  8024aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8024b0:	89 10                	mov    %edx,(%eax)
  8024b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024b8:	89 50 04             	mov    %edx,0x4(%eax)
  8024bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8024be:	8b 00                	mov    (%eax),%eax
  8024c0:	85 c0                	test   %eax,%eax
  8024c2:	75 08                	jne    8024cc <insert_sorted_allocList+0x244>
  8024c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c7:	a3 44 50 80 00       	mov    %eax,0x805044
  8024cc:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8024d1:	40                   	inc    %eax
  8024d2:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8024d7:	eb 39                	jmp    802512 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8024d9:	a1 48 50 80 00       	mov    0x805048,%eax
  8024de:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024e5:	74 07                	je     8024ee <insert_sorted_allocList+0x266>
  8024e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ea:	8b 00                	mov    (%eax),%eax
  8024ec:	eb 05                	jmp    8024f3 <insert_sorted_allocList+0x26b>
  8024ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8024f3:	a3 48 50 80 00       	mov    %eax,0x805048
  8024f8:	a1 48 50 80 00       	mov    0x805048,%eax
  8024fd:	85 c0                	test   %eax,%eax
  8024ff:	0f 85 3f ff ff ff    	jne    802444 <insert_sorted_allocList+0x1bc>
  802505:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802509:	0f 85 35 ff ff ff    	jne    802444 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80250f:	eb 01                	jmp    802512 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802511:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802512:	90                   	nop
  802513:	c9                   	leave  
  802514:	c3                   	ret    

00802515 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802515:	55                   	push   %ebp
  802516:	89 e5                	mov    %esp,%ebp
  802518:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80251b:	a1 38 51 80 00       	mov    0x805138,%eax
  802520:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802523:	e9 85 01 00 00       	jmp    8026ad <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802528:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252b:	8b 40 0c             	mov    0xc(%eax),%eax
  80252e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802531:	0f 82 6e 01 00 00    	jb     8026a5 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802537:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253a:	8b 40 0c             	mov    0xc(%eax),%eax
  80253d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802540:	0f 85 8a 00 00 00    	jne    8025d0 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802546:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80254a:	75 17                	jne    802563 <alloc_block_FF+0x4e>
  80254c:	83 ec 04             	sub    $0x4,%esp
  80254f:	68 a4 43 80 00       	push   $0x8043a4
  802554:	68 93 00 00 00       	push   $0x93
  802559:	68 fb 42 80 00       	push   $0x8042fb
  80255e:	e8 44 df ff ff       	call   8004a7 <_panic>
  802563:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802566:	8b 00                	mov    (%eax),%eax
  802568:	85 c0                	test   %eax,%eax
  80256a:	74 10                	je     80257c <alloc_block_FF+0x67>
  80256c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256f:	8b 00                	mov    (%eax),%eax
  802571:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802574:	8b 52 04             	mov    0x4(%edx),%edx
  802577:	89 50 04             	mov    %edx,0x4(%eax)
  80257a:	eb 0b                	jmp    802587 <alloc_block_FF+0x72>
  80257c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257f:	8b 40 04             	mov    0x4(%eax),%eax
  802582:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802587:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258a:	8b 40 04             	mov    0x4(%eax),%eax
  80258d:	85 c0                	test   %eax,%eax
  80258f:	74 0f                	je     8025a0 <alloc_block_FF+0x8b>
  802591:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802594:	8b 40 04             	mov    0x4(%eax),%eax
  802597:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80259a:	8b 12                	mov    (%edx),%edx
  80259c:	89 10                	mov    %edx,(%eax)
  80259e:	eb 0a                	jmp    8025aa <alloc_block_FF+0x95>
  8025a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a3:	8b 00                	mov    (%eax),%eax
  8025a5:	a3 38 51 80 00       	mov    %eax,0x805138
  8025aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025bd:	a1 44 51 80 00       	mov    0x805144,%eax
  8025c2:	48                   	dec    %eax
  8025c3:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  8025c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cb:	e9 10 01 00 00       	jmp    8026e0 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8025d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d3:	8b 40 0c             	mov    0xc(%eax),%eax
  8025d6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025d9:	0f 86 c6 00 00 00    	jbe    8026a5 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8025df:	a1 48 51 80 00       	mov    0x805148,%eax
  8025e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8025e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ea:	8b 50 08             	mov    0x8(%eax),%edx
  8025ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025f0:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8025f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8025f9:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8025fc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802600:	75 17                	jne    802619 <alloc_block_FF+0x104>
  802602:	83 ec 04             	sub    $0x4,%esp
  802605:	68 a4 43 80 00       	push   $0x8043a4
  80260a:	68 9b 00 00 00       	push   $0x9b
  80260f:	68 fb 42 80 00       	push   $0x8042fb
  802614:	e8 8e de ff ff       	call   8004a7 <_panic>
  802619:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80261c:	8b 00                	mov    (%eax),%eax
  80261e:	85 c0                	test   %eax,%eax
  802620:	74 10                	je     802632 <alloc_block_FF+0x11d>
  802622:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802625:	8b 00                	mov    (%eax),%eax
  802627:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80262a:	8b 52 04             	mov    0x4(%edx),%edx
  80262d:	89 50 04             	mov    %edx,0x4(%eax)
  802630:	eb 0b                	jmp    80263d <alloc_block_FF+0x128>
  802632:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802635:	8b 40 04             	mov    0x4(%eax),%eax
  802638:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80263d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802640:	8b 40 04             	mov    0x4(%eax),%eax
  802643:	85 c0                	test   %eax,%eax
  802645:	74 0f                	je     802656 <alloc_block_FF+0x141>
  802647:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80264a:	8b 40 04             	mov    0x4(%eax),%eax
  80264d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802650:	8b 12                	mov    (%edx),%edx
  802652:	89 10                	mov    %edx,(%eax)
  802654:	eb 0a                	jmp    802660 <alloc_block_FF+0x14b>
  802656:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802659:	8b 00                	mov    (%eax),%eax
  80265b:	a3 48 51 80 00       	mov    %eax,0x805148
  802660:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802663:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802669:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80266c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802673:	a1 54 51 80 00       	mov    0x805154,%eax
  802678:	48                   	dec    %eax
  802679:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  80267e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802681:	8b 50 08             	mov    0x8(%eax),%edx
  802684:	8b 45 08             	mov    0x8(%ebp),%eax
  802687:	01 c2                	add    %eax,%edx
  802689:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268c:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  80268f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802692:	8b 40 0c             	mov    0xc(%eax),%eax
  802695:	2b 45 08             	sub    0x8(%ebp),%eax
  802698:	89 c2                	mov    %eax,%edx
  80269a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269d:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8026a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026a3:	eb 3b                	jmp    8026e0 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8026a5:	a1 40 51 80 00       	mov    0x805140,%eax
  8026aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026b1:	74 07                	je     8026ba <alloc_block_FF+0x1a5>
  8026b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b6:	8b 00                	mov    (%eax),%eax
  8026b8:	eb 05                	jmp    8026bf <alloc_block_FF+0x1aa>
  8026ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8026bf:	a3 40 51 80 00       	mov    %eax,0x805140
  8026c4:	a1 40 51 80 00       	mov    0x805140,%eax
  8026c9:	85 c0                	test   %eax,%eax
  8026cb:	0f 85 57 fe ff ff    	jne    802528 <alloc_block_FF+0x13>
  8026d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026d5:	0f 85 4d fe ff ff    	jne    802528 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8026db:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026e0:	c9                   	leave  
  8026e1:	c3                   	ret    

008026e2 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8026e2:	55                   	push   %ebp
  8026e3:	89 e5                	mov    %esp,%ebp
  8026e5:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8026e8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8026ef:	a1 38 51 80 00       	mov    0x805138,%eax
  8026f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026f7:	e9 df 00 00 00       	jmp    8027db <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8026fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ff:	8b 40 0c             	mov    0xc(%eax),%eax
  802702:	3b 45 08             	cmp    0x8(%ebp),%eax
  802705:	0f 82 c8 00 00 00    	jb     8027d3 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  80270b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270e:	8b 40 0c             	mov    0xc(%eax),%eax
  802711:	3b 45 08             	cmp    0x8(%ebp),%eax
  802714:	0f 85 8a 00 00 00    	jne    8027a4 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  80271a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80271e:	75 17                	jne    802737 <alloc_block_BF+0x55>
  802720:	83 ec 04             	sub    $0x4,%esp
  802723:	68 a4 43 80 00       	push   $0x8043a4
  802728:	68 b7 00 00 00       	push   $0xb7
  80272d:	68 fb 42 80 00       	push   $0x8042fb
  802732:	e8 70 dd ff ff       	call   8004a7 <_panic>
  802737:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273a:	8b 00                	mov    (%eax),%eax
  80273c:	85 c0                	test   %eax,%eax
  80273e:	74 10                	je     802750 <alloc_block_BF+0x6e>
  802740:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802743:	8b 00                	mov    (%eax),%eax
  802745:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802748:	8b 52 04             	mov    0x4(%edx),%edx
  80274b:	89 50 04             	mov    %edx,0x4(%eax)
  80274e:	eb 0b                	jmp    80275b <alloc_block_BF+0x79>
  802750:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802753:	8b 40 04             	mov    0x4(%eax),%eax
  802756:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80275b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275e:	8b 40 04             	mov    0x4(%eax),%eax
  802761:	85 c0                	test   %eax,%eax
  802763:	74 0f                	je     802774 <alloc_block_BF+0x92>
  802765:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802768:	8b 40 04             	mov    0x4(%eax),%eax
  80276b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80276e:	8b 12                	mov    (%edx),%edx
  802770:	89 10                	mov    %edx,(%eax)
  802772:	eb 0a                	jmp    80277e <alloc_block_BF+0x9c>
  802774:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802777:	8b 00                	mov    (%eax),%eax
  802779:	a3 38 51 80 00       	mov    %eax,0x805138
  80277e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802781:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802787:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802791:	a1 44 51 80 00       	mov    0x805144,%eax
  802796:	48                   	dec    %eax
  802797:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  80279c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279f:	e9 4d 01 00 00       	jmp    8028f1 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8027a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a7:	8b 40 0c             	mov    0xc(%eax),%eax
  8027aa:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027ad:	76 24                	jbe    8027d3 <alloc_block_BF+0xf1>
  8027af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b2:	8b 40 0c             	mov    0xc(%eax),%eax
  8027b5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8027b8:	73 19                	jae    8027d3 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8027ba:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8027c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c4:	8b 40 0c             	mov    0xc(%eax),%eax
  8027c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8027ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cd:	8b 40 08             	mov    0x8(%eax),%eax
  8027d0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8027d3:	a1 40 51 80 00       	mov    0x805140,%eax
  8027d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027db:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027df:	74 07                	je     8027e8 <alloc_block_BF+0x106>
  8027e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e4:	8b 00                	mov    (%eax),%eax
  8027e6:	eb 05                	jmp    8027ed <alloc_block_BF+0x10b>
  8027e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8027ed:	a3 40 51 80 00       	mov    %eax,0x805140
  8027f2:	a1 40 51 80 00       	mov    0x805140,%eax
  8027f7:	85 c0                	test   %eax,%eax
  8027f9:	0f 85 fd fe ff ff    	jne    8026fc <alloc_block_BF+0x1a>
  8027ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802803:	0f 85 f3 fe ff ff    	jne    8026fc <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802809:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80280d:	0f 84 d9 00 00 00    	je     8028ec <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802813:	a1 48 51 80 00       	mov    0x805148,%eax
  802818:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  80281b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80281e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802821:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802824:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802827:	8b 55 08             	mov    0x8(%ebp),%edx
  80282a:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  80282d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802831:	75 17                	jne    80284a <alloc_block_BF+0x168>
  802833:	83 ec 04             	sub    $0x4,%esp
  802836:	68 a4 43 80 00       	push   $0x8043a4
  80283b:	68 c7 00 00 00       	push   $0xc7
  802840:	68 fb 42 80 00       	push   $0x8042fb
  802845:	e8 5d dc ff ff       	call   8004a7 <_panic>
  80284a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80284d:	8b 00                	mov    (%eax),%eax
  80284f:	85 c0                	test   %eax,%eax
  802851:	74 10                	je     802863 <alloc_block_BF+0x181>
  802853:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802856:	8b 00                	mov    (%eax),%eax
  802858:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80285b:	8b 52 04             	mov    0x4(%edx),%edx
  80285e:	89 50 04             	mov    %edx,0x4(%eax)
  802861:	eb 0b                	jmp    80286e <alloc_block_BF+0x18c>
  802863:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802866:	8b 40 04             	mov    0x4(%eax),%eax
  802869:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80286e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802871:	8b 40 04             	mov    0x4(%eax),%eax
  802874:	85 c0                	test   %eax,%eax
  802876:	74 0f                	je     802887 <alloc_block_BF+0x1a5>
  802878:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80287b:	8b 40 04             	mov    0x4(%eax),%eax
  80287e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802881:	8b 12                	mov    (%edx),%edx
  802883:	89 10                	mov    %edx,(%eax)
  802885:	eb 0a                	jmp    802891 <alloc_block_BF+0x1af>
  802887:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80288a:	8b 00                	mov    (%eax),%eax
  80288c:	a3 48 51 80 00       	mov    %eax,0x805148
  802891:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802894:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80289a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80289d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028a4:	a1 54 51 80 00       	mov    0x805154,%eax
  8028a9:	48                   	dec    %eax
  8028aa:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8028af:	83 ec 08             	sub    $0x8,%esp
  8028b2:	ff 75 ec             	pushl  -0x14(%ebp)
  8028b5:	68 38 51 80 00       	push   $0x805138
  8028ba:	e8 71 f9 ff ff       	call   802230 <find_block>
  8028bf:	83 c4 10             	add    $0x10,%esp
  8028c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8028c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028c8:	8b 50 08             	mov    0x8(%eax),%edx
  8028cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ce:	01 c2                	add    %eax,%edx
  8028d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028d3:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8028d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028d9:	8b 40 0c             	mov    0xc(%eax),%eax
  8028dc:	2b 45 08             	sub    0x8(%ebp),%eax
  8028df:	89 c2                	mov    %eax,%edx
  8028e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028e4:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8028e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028ea:	eb 05                	jmp    8028f1 <alloc_block_BF+0x20f>
	}
	return NULL;
  8028ec:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028f1:	c9                   	leave  
  8028f2:	c3                   	ret    

008028f3 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8028f3:	55                   	push   %ebp
  8028f4:	89 e5                	mov    %esp,%ebp
  8028f6:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  8028f9:	a1 28 50 80 00       	mov    0x805028,%eax
  8028fe:	85 c0                	test   %eax,%eax
  802900:	0f 85 de 01 00 00    	jne    802ae4 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802906:	a1 38 51 80 00       	mov    0x805138,%eax
  80290b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80290e:	e9 9e 01 00 00       	jmp    802ab1 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802913:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802916:	8b 40 0c             	mov    0xc(%eax),%eax
  802919:	3b 45 08             	cmp    0x8(%ebp),%eax
  80291c:	0f 82 87 01 00 00    	jb     802aa9 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802922:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802925:	8b 40 0c             	mov    0xc(%eax),%eax
  802928:	3b 45 08             	cmp    0x8(%ebp),%eax
  80292b:	0f 85 95 00 00 00    	jne    8029c6 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802931:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802935:	75 17                	jne    80294e <alloc_block_NF+0x5b>
  802937:	83 ec 04             	sub    $0x4,%esp
  80293a:	68 a4 43 80 00       	push   $0x8043a4
  80293f:	68 e0 00 00 00       	push   $0xe0
  802944:	68 fb 42 80 00       	push   $0x8042fb
  802949:	e8 59 db ff ff       	call   8004a7 <_panic>
  80294e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802951:	8b 00                	mov    (%eax),%eax
  802953:	85 c0                	test   %eax,%eax
  802955:	74 10                	je     802967 <alloc_block_NF+0x74>
  802957:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295a:	8b 00                	mov    (%eax),%eax
  80295c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80295f:	8b 52 04             	mov    0x4(%edx),%edx
  802962:	89 50 04             	mov    %edx,0x4(%eax)
  802965:	eb 0b                	jmp    802972 <alloc_block_NF+0x7f>
  802967:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296a:	8b 40 04             	mov    0x4(%eax),%eax
  80296d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802972:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802975:	8b 40 04             	mov    0x4(%eax),%eax
  802978:	85 c0                	test   %eax,%eax
  80297a:	74 0f                	je     80298b <alloc_block_NF+0x98>
  80297c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297f:	8b 40 04             	mov    0x4(%eax),%eax
  802982:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802985:	8b 12                	mov    (%edx),%edx
  802987:	89 10                	mov    %edx,(%eax)
  802989:	eb 0a                	jmp    802995 <alloc_block_NF+0xa2>
  80298b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298e:	8b 00                	mov    (%eax),%eax
  802990:	a3 38 51 80 00       	mov    %eax,0x805138
  802995:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802998:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80299e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029a8:	a1 44 51 80 00       	mov    0x805144,%eax
  8029ad:	48                   	dec    %eax
  8029ae:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  8029b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b6:	8b 40 08             	mov    0x8(%eax),%eax
  8029b9:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  8029be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c1:	e9 f8 04 00 00       	jmp    802ebe <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8029c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c9:	8b 40 0c             	mov    0xc(%eax),%eax
  8029cc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029cf:	0f 86 d4 00 00 00    	jbe    802aa9 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8029d5:	a1 48 51 80 00       	mov    0x805148,%eax
  8029da:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8029dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e0:	8b 50 08             	mov    0x8(%eax),%edx
  8029e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029e6:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8029e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ec:	8b 55 08             	mov    0x8(%ebp),%edx
  8029ef:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8029f2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029f6:	75 17                	jne    802a0f <alloc_block_NF+0x11c>
  8029f8:	83 ec 04             	sub    $0x4,%esp
  8029fb:	68 a4 43 80 00       	push   $0x8043a4
  802a00:	68 e9 00 00 00       	push   $0xe9
  802a05:	68 fb 42 80 00       	push   $0x8042fb
  802a0a:	e8 98 da ff ff       	call   8004a7 <_panic>
  802a0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a12:	8b 00                	mov    (%eax),%eax
  802a14:	85 c0                	test   %eax,%eax
  802a16:	74 10                	je     802a28 <alloc_block_NF+0x135>
  802a18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a1b:	8b 00                	mov    (%eax),%eax
  802a1d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a20:	8b 52 04             	mov    0x4(%edx),%edx
  802a23:	89 50 04             	mov    %edx,0x4(%eax)
  802a26:	eb 0b                	jmp    802a33 <alloc_block_NF+0x140>
  802a28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a2b:	8b 40 04             	mov    0x4(%eax),%eax
  802a2e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a36:	8b 40 04             	mov    0x4(%eax),%eax
  802a39:	85 c0                	test   %eax,%eax
  802a3b:	74 0f                	je     802a4c <alloc_block_NF+0x159>
  802a3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a40:	8b 40 04             	mov    0x4(%eax),%eax
  802a43:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a46:	8b 12                	mov    (%edx),%edx
  802a48:	89 10                	mov    %edx,(%eax)
  802a4a:	eb 0a                	jmp    802a56 <alloc_block_NF+0x163>
  802a4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a4f:	8b 00                	mov    (%eax),%eax
  802a51:	a3 48 51 80 00       	mov    %eax,0x805148
  802a56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a59:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a62:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a69:	a1 54 51 80 00       	mov    0x805154,%eax
  802a6e:	48                   	dec    %eax
  802a6f:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802a74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a77:	8b 40 08             	mov    0x8(%eax),%eax
  802a7a:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802a7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a82:	8b 50 08             	mov    0x8(%eax),%edx
  802a85:	8b 45 08             	mov    0x8(%ebp),%eax
  802a88:	01 c2                	add    %eax,%edx
  802a8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8d:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802a90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a93:	8b 40 0c             	mov    0xc(%eax),%eax
  802a96:	2b 45 08             	sub    0x8(%ebp),%eax
  802a99:	89 c2                	mov    %eax,%edx
  802a9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9e:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802aa1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aa4:	e9 15 04 00 00       	jmp    802ebe <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802aa9:	a1 40 51 80 00       	mov    0x805140,%eax
  802aae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ab1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ab5:	74 07                	je     802abe <alloc_block_NF+0x1cb>
  802ab7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aba:	8b 00                	mov    (%eax),%eax
  802abc:	eb 05                	jmp    802ac3 <alloc_block_NF+0x1d0>
  802abe:	b8 00 00 00 00       	mov    $0x0,%eax
  802ac3:	a3 40 51 80 00       	mov    %eax,0x805140
  802ac8:	a1 40 51 80 00       	mov    0x805140,%eax
  802acd:	85 c0                	test   %eax,%eax
  802acf:	0f 85 3e fe ff ff    	jne    802913 <alloc_block_NF+0x20>
  802ad5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ad9:	0f 85 34 fe ff ff    	jne    802913 <alloc_block_NF+0x20>
  802adf:	e9 d5 03 00 00       	jmp    802eb9 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802ae4:	a1 38 51 80 00       	mov    0x805138,%eax
  802ae9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802aec:	e9 b1 01 00 00       	jmp    802ca2 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802af1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af4:	8b 50 08             	mov    0x8(%eax),%edx
  802af7:	a1 28 50 80 00       	mov    0x805028,%eax
  802afc:	39 c2                	cmp    %eax,%edx
  802afe:	0f 82 96 01 00 00    	jb     802c9a <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802b04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b07:	8b 40 0c             	mov    0xc(%eax),%eax
  802b0a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b0d:	0f 82 87 01 00 00    	jb     802c9a <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802b13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b16:	8b 40 0c             	mov    0xc(%eax),%eax
  802b19:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b1c:	0f 85 95 00 00 00    	jne    802bb7 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802b22:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b26:	75 17                	jne    802b3f <alloc_block_NF+0x24c>
  802b28:	83 ec 04             	sub    $0x4,%esp
  802b2b:	68 a4 43 80 00       	push   $0x8043a4
  802b30:	68 fc 00 00 00       	push   $0xfc
  802b35:	68 fb 42 80 00       	push   $0x8042fb
  802b3a:	e8 68 d9 ff ff       	call   8004a7 <_panic>
  802b3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b42:	8b 00                	mov    (%eax),%eax
  802b44:	85 c0                	test   %eax,%eax
  802b46:	74 10                	je     802b58 <alloc_block_NF+0x265>
  802b48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4b:	8b 00                	mov    (%eax),%eax
  802b4d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b50:	8b 52 04             	mov    0x4(%edx),%edx
  802b53:	89 50 04             	mov    %edx,0x4(%eax)
  802b56:	eb 0b                	jmp    802b63 <alloc_block_NF+0x270>
  802b58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5b:	8b 40 04             	mov    0x4(%eax),%eax
  802b5e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b66:	8b 40 04             	mov    0x4(%eax),%eax
  802b69:	85 c0                	test   %eax,%eax
  802b6b:	74 0f                	je     802b7c <alloc_block_NF+0x289>
  802b6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b70:	8b 40 04             	mov    0x4(%eax),%eax
  802b73:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b76:	8b 12                	mov    (%edx),%edx
  802b78:	89 10                	mov    %edx,(%eax)
  802b7a:	eb 0a                	jmp    802b86 <alloc_block_NF+0x293>
  802b7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7f:	8b 00                	mov    (%eax),%eax
  802b81:	a3 38 51 80 00       	mov    %eax,0x805138
  802b86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b89:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b92:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b99:	a1 44 51 80 00       	mov    0x805144,%eax
  802b9e:	48                   	dec    %eax
  802b9f:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802ba4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba7:	8b 40 08             	mov    0x8(%eax),%eax
  802baa:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802baf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb2:	e9 07 03 00 00       	jmp    802ebe <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802bb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bba:	8b 40 0c             	mov    0xc(%eax),%eax
  802bbd:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bc0:	0f 86 d4 00 00 00    	jbe    802c9a <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802bc6:	a1 48 51 80 00       	mov    0x805148,%eax
  802bcb:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802bce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd1:	8b 50 08             	mov    0x8(%eax),%edx
  802bd4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bd7:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802bda:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bdd:	8b 55 08             	mov    0x8(%ebp),%edx
  802be0:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802be3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802be7:	75 17                	jne    802c00 <alloc_block_NF+0x30d>
  802be9:	83 ec 04             	sub    $0x4,%esp
  802bec:	68 a4 43 80 00       	push   $0x8043a4
  802bf1:	68 04 01 00 00       	push   $0x104
  802bf6:	68 fb 42 80 00       	push   $0x8042fb
  802bfb:	e8 a7 d8 ff ff       	call   8004a7 <_panic>
  802c00:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c03:	8b 00                	mov    (%eax),%eax
  802c05:	85 c0                	test   %eax,%eax
  802c07:	74 10                	je     802c19 <alloc_block_NF+0x326>
  802c09:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c0c:	8b 00                	mov    (%eax),%eax
  802c0e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c11:	8b 52 04             	mov    0x4(%edx),%edx
  802c14:	89 50 04             	mov    %edx,0x4(%eax)
  802c17:	eb 0b                	jmp    802c24 <alloc_block_NF+0x331>
  802c19:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c1c:	8b 40 04             	mov    0x4(%eax),%eax
  802c1f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c24:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c27:	8b 40 04             	mov    0x4(%eax),%eax
  802c2a:	85 c0                	test   %eax,%eax
  802c2c:	74 0f                	je     802c3d <alloc_block_NF+0x34a>
  802c2e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c31:	8b 40 04             	mov    0x4(%eax),%eax
  802c34:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c37:	8b 12                	mov    (%edx),%edx
  802c39:	89 10                	mov    %edx,(%eax)
  802c3b:	eb 0a                	jmp    802c47 <alloc_block_NF+0x354>
  802c3d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c40:	8b 00                	mov    (%eax),%eax
  802c42:	a3 48 51 80 00       	mov    %eax,0x805148
  802c47:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c4a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c50:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c53:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c5a:	a1 54 51 80 00       	mov    0x805154,%eax
  802c5f:	48                   	dec    %eax
  802c60:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802c65:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c68:	8b 40 08             	mov    0x8(%eax),%eax
  802c6b:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802c70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c73:	8b 50 08             	mov    0x8(%eax),%edx
  802c76:	8b 45 08             	mov    0x8(%ebp),%eax
  802c79:	01 c2                	add    %eax,%edx
  802c7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7e:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802c81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c84:	8b 40 0c             	mov    0xc(%eax),%eax
  802c87:	2b 45 08             	sub    0x8(%ebp),%eax
  802c8a:	89 c2                	mov    %eax,%edx
  802c8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8f:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802c92:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c95:	e9 24 02 00 00       	jmp    802ebe <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c9a:	a1 40 51 80 00       	mov    0x805140,%eax
  802c9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ca2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ca6:	74 07                	je     802caf <alloc_block_NF+0x3bc>
  802ca8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cab:	8b 00                	mov    (%eax),%eax
  802cad:	eb 05                	jmp    802cb4 <alloc_block_NF+0x3c1>
  802caf:	b8 00 00 00 00       	mov    $0x0,%eax
  802cb4:	a3 40 51 80 00       	mov    %eax,0x805140
  802cb9:	a1 40 51 80 00       	mov    0x805140,%eax
  802cbe:	85 c0                	test   %eax,%eax
  802cc0:	0f 85 2b fe ff ff    	jne    802af1 <alloc_block_NF+0x1fe>
  802cc6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cca:	0f 85 21 fe ff ff    	jne    802af1 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802cd0:	a1 38 51 80 00       	mov    0x805138,%eax
  802cd5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cd8:	e9 ae 01 00 00       	jmp    802e8b <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802cdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce0:	8b 50 08             	mov    0x8(%eax),%edx
  802ce3:	a1 28 50 80 00       	mov    0x805028,%eax
  802ce8:	39 c2                	cmp    %eax,%edx
  802cea:	0f 83 93 01 00 00    	jae    802e83 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802cf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf3:	8b 40 0c             	mov    0xc(%eax),%eax
  802cf6:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cf9:	0f 82 84 01 00 00    	jb     802e83 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802cff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d02:	8b 40 0c             	mov    0xc(%eax),%eax
  802d05:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d08:	0f 85 95 00 00 00    	jne    802da3 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802d0e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d12:	75 17                	jne    802d2b <alloc_block_NF+0x438>
  802d14:	83 ec 04             	sub    $0x4,%esp
  802d17:	68 a4 43 80 00       	push   $0x8043a4
  802d1c:	68 14 01 00 00       	push   $0x114
  802d21:	68 fb 42 80 00       	push   $0x8042fb
  802d26:	e8 7c d7 ff ff       	call   8004a7 <_panic>
  802d2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2e:	8b 00                	mov    (%eax),%eax
  802d30:	85 c0                	test   %eax,%eax
  802d32:	74 10                	je     802d44 <alloc_block_NF+0x451>
  802d34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d37:	8b 00                	mov    (%eax),%eax
  802d39:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d3c:	8b 52 04             	mov    0x4(%edx),%edx
  802d3f:	89 50 04             	mov    %edx,0x4(%eax)
  802d42:	eb 0b                	jmp    802d4f <alloc_block_NF+0x45c>
  802d44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d47:	8b 40 04             	mov    0x4(%eax),%eax
  802d4a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d52:	8b 40 04             	mov    0x4(%eax),%eax
  802d55:	85 c0                	test   %eax,%eax
  802d57:	74 0f                	je     802d68 <alloc_block_NF+0x475>
  802d59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5c:	8b 40 04             	mov    0x4(%eax),%eax
  802d5f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d62:	8b 12                	mov    (%edx),%edx
  802d64:	89 10                	mov    %edx,(%eax)
  802d66:	eb 0a                	jmp    802d72 <alloc_block_NF+0x47f>
  802d68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6b:	8b 00                	mov    (%eax),%eax
  802d6d:	a3 38 51 80 00       	mov    %eax,0x805138
  802d72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d75:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d85:	a1 44 51 80 00       	mov    0x805144,%eax
  802d8a:	48                   	dec    %eax
  802d8b:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802d90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d93:	8b 40 08             	mov    0x8(%eax),%eax
  802d96:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802d9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9e:	e9 1b 01 00 00       	jmp    802ebe <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802da3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da6:	8b 40 0c             	mov    0xc(%eax),%eax
  802da9:	3b 45 08             	cmp    0x8(%ebp),%eax
  802dac:	0f 86 d1 00 00 00    	jbe    802e83 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802db2:	a1 48 51 80 00       	mov    0x805148,%eax
  802db7:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802dba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbd:	8b 50 08             	mov    0x8(%eax),%edx
  802dc0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dc3:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802dc6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dc9:	8b 55 08             	mov    0x8(%ebp),%edx
  802dcc:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802dcf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802dd3:	75 17                	jne    802dec <alloc_block_NF+0x4f9>
  802dd5:	83 ec 04             	sub    $0x4,%esp
  802dd8:	68 a4 43 80 00       	push   $0x8043a4
  802ddd:	68 1c 01 00 00       	push   $0x11c
  802de2:	68 fb 42 80 00       	push   $0x8042fb
  802de7:	e8 bb d6 ff ff       	call   8004a7 <_panic>
  802dec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802def:	8b 00                	mov    (%eax),%eax
  802df1:	85 c0                	test   %eax,%eax
  802df3:	74 10                	je     802e05 <alloc_block_NF+0x512>
  802df5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802df8:	8b 00                	mov    (%eax),%eax
  802dfa:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802dfd:	8b 52 04             	mov    0x4(%edx),%edx
  802e00:	89 50 04             	mov    %edx,0x4(%eax)
  802e03:	eb 0b                	jmp    802e10 <alloc_block_NF+0x51d>
  802e05:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e08:	8b 40 04             	mov    0x4(%eax),%eax
  802e0b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e10:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e13:	8b 40 04             	mov    0x4(%eax),%eax
  802e16:	85 c0                	test   %eax,%eax
  802e18:	74 0f                	je     802e29 <alloc_block_NF+0x536>
  802e1a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e1d:	8b 40 04             	mov    0x4(%eax),%eax
  802e20:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e23:	8b 12                	mov    (%edx),%edx
  802e25:	89 10                	mov    %edx,(%eax)
  802e27:	eb 0a                	jmp    802e33 <alloc_block_NF+0x540>
  802e29:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e2c:	8b 00                	mov    (%eax),%eax
  802e2e:	a3 48 51 80 00       	mov    %eax,0x805148
  802e33:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e36:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e3f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e46:	a1 54 51 80 00       	mov    0x805154,%eax
  802e4b:	48                   	dec    %eax
  802e4c:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802e51:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e54:	8b 40 08             	mov    0x8(%eax),%eax
  802e57:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802e5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5f:	8b 50 08             	mov    0x8(%eax),%edx
  802e62:	8b 45 08             	mov    0x8(%ebp),%eax
  802e65:	01 c2                	add    %eax,%edx
  802e67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6a:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802e6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e70:	8b 40 0c             	mov    0xc(%eax),%eax
  802e73:	2b 45 08             	sub    0x8(%ebp),%eax
  802e76:	89 c2                	mov    %eax,%edx
  802e78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7b:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802e7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e81:	eb 3b                	jmp    802ebe <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802e83:	a1 40 51 80 00       	mov    0x805140,%eax
  802e88:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e8b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e8f:	74 07                	je     802e98 <alloc_block_NF+0x5a5>
  802e91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e94:	8b 00                	mov    (%eax),%eax
  802e96:	eb 05                	jmp    802e9d <alloc_block_NF+0x5aa>
  802e98:	b8 00 00 00 00       	mov    $0x0,%eax
  802e9d:	a3 40 51 80 00       	mov    %eax,0x805140
  802ea2:	a1 40 51 80 00       	mov    0x805140,%eax
  802ea7:	85 c0                	test   %eax,%eax
  802ea9:	0f 85 2e fe ff ff    	jne    802cdd <alloc_block_NF+0x3ea>
  802eaf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802eb3:	0f 85 24 fe ff ff    	jne    802cdd <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802eb9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ebe:	c9                   	leave  
  802ebf:	c3                   	ret    

00802ec0 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802ec0:	55                   	push   %ebp
  802ec1:	89 e5                	mov    %esp,%ebp
  802ec3:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802ec6:	a1 38 51 80 00       	mov    0x805138,%eax
  802ecb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802ece:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802ed3:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802ed6:	a1 38 51 80 00       	mov    0x805138,%eax
  802edb:	85 c0                	test   %eax,%eax
  802edd:	74 14                	je     802ef3 <insert_sorted_with_merge_freeList+0x33>
  802edf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee2:	8b 50 08             	mov    0x8(%eax),%edx
  802ee5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ee8:	8b 40 08             	mov    0x8(%eax),%eax
  802eeb:	39 c2                	cmp    %eax,%edx
  802eed:	0f 87 9b 01 00 00    	ja     80308e <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802ef3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ef7:	75 17                	jne    802f10 <insert_sorted_with_merge_freeList+0x50>
  802ef9:	83 ec 04             	sub    $0x4,%esp
  802efc:	68 d8 42 80 00       	push   $0x8042d8
  802f01:	68 38 01 00 00       	push   $0x138
  802f06:	68 fb 42 80 00       	push   $0x8042fb
  802f0b:	e8 97 d5 ff ff       	call   8004a7 <_panic>
  802f10:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802f16:	8b 45 08             	mov    0x8(%ebp),%eax
  802f19:	89 10                	mov    %edx,(%eax)
  802f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1e:	8b 00                	mov    (%eax),%eax
  802f20:	85 c0                	test   %eax,%eax
  802f22:	74 0d                	je     802f31 <insert_sorted_with_merge_freeList+0x71>
  802f24:	a1 38 51 80 00       	mov    0x805138,%eax
  802f29:	8b 55 08             	mov    0x8(%ebp),%edx
  802f2c:	89 50 04             	mov    %edx,0x4(%eax)
  802f2f:	eb 08                	jmp    802f39 <insert_sorted_with_merge_freeList+0x79>
  802f31:	8b 45 08             	mov    0x8(%ebp),%eax
  802f34:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f39:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3c:	a3 38 51 80 00       	mov    %eax,0x805138
  802f41:	8b 45 08             	mov    0x8(%ebp),%eax
  802f44:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f4b:	a1 44 51 80 00       	mov    0x805144,%eax
  802f50:	40                   	inc    %eax
  802f51:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802f56:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f5a:	0f 84 a8 06 00 00    	je     803608 <insert_sorted_with_merge_freeList+0x748>
  802f60:	8b 45 08             	mov    0x8(%ebp),%eax
  802f63:	8b 50 08             	mov    0x8(%eax),%edx
  802f66:	8b 45 08             	mov    0x8(%ebp),%eax
  802f69:	8b 40 0c             	mov    0xc(%eax),%eax
  802f6c:	01 c2                	add    %eax,%edx
  802f6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f71:	8b 40 08             	mov    0x8(%eax),%eax
  802f74:	39 c2                	cmp    %eax,%edx
  802f76:	0f 85 8c 06 00 00    	jne    803608 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802f7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7f:	8b 50 0c             	mov    0xc(%eax),%edx
  802f82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f85:	8b 40 0c             	mov    0xc(%eax),%eax
  802f88:	01 c2                	add    %eax,%edx
  802f8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8d:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802f90:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f94:	75 17                	jne    802fad <insert_sorted_with_merge_freeList+0xed>
  802f96:	83 ec 04             	sub    $0x4,%esp
  802f99:	68 a4 43 80 00       	push   $0x8043a4
  802f9e:	68 3c 01 00 00       	push   $0x13c
  802fa3:	68 fb 42 80 00       	push   $0x8042fb
  802fa8:	e8 fa d4 ff ff       	call   8004a7 <_panic>
  802fad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fb0:	8b 00                	mov    (%eax),%eax
  802fb2:	85 c0                	test   %eax,%eax
  802fb4:	74 10                	je     802fc6 <insert_sorted_with_merge_freeList+0x106>
  802fb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fb9:	8b 00                	mov    (%eax),%eax
  802fbb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fbe:	8b 52 04             	mov    0x4(%edx),%edx
  802fc1:	89 50 04             	mov    %edx,0x4(%eax)
  802fc4:	eb 0b                	jmp    802fd1 <insert_sorted_with_merge_freeList+0x111>
  802fc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fc9:	8b 40 04             	mov    0x4(%eax),%eax
  802fcc:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fd4:	8b 40 04             	mov    0x4(%eax),%eax
  802fd7:	85 c0                	test   %eax,%eax
  802fd9:	74 0f                	je     802fea <insert_sorted_with_merge_freeList+0x12a>
  802fdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fde:	8b 40 04             	mov    0x4(%eax),%eax
  802fe1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fe4:	8b 12                	mov    (%edx),%edx
  802fe6:	89 10                	mov    %edx,(%eax)
  802fe8:	eb 0a                	jmp    802ff4 <insert_sorted_with_merge_freeList+0x134>
  802fea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fed:	8b 00                	mov    (%eax),%eax
  802fef:	a3 38 51 80 00       	mov    %eax,0x805138
  802ff4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ff7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ffd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803000:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803007:	a1 44 51 80 00       	mov    0x805144,%eax
  80300c:	48                   	dec    %eax
  80300d:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  803012:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803015:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  80301c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80301f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  803026:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80302a:	75 17                	jne    803043 <insert_sorted_with_merge_freeList+0x183>
  80302c:	83 ec 04             	sub    $0x4,%esp
  80302f:	68 d8 42 80 00       	push   $0x8042d8
  803034:	68 3f 01 00 00       	push   $0x13f
  803039:	68 fb 42 80 00       	push   $0x8042fb
  80303e:	e8 64 d4 ff ff       	call   8004a7 <_panic>
  803043:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803049:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80304c:	89 10                	mov    %edx,(%eax)
  80304e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803051:	8b 00                	mov    (%eax),%eax
  803053:	85 c0                	test   %eax,%eax
  803055:	74 0d                	je     803064 <insert_sorted_with_merge_freeList+0x1a4>
  803057:	a1 48 51 80 00       	mov    0x805148,%eax
  80305c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80305f:	89 50 04             	mov    %edx,0x4(%eax)
  803062:	eb 08                	jmp    80306c <insert_sorted_with_merge_freeList+0x1ac>
  803064:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803067:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80306c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80306f:	a3 48 51 80 00       	mov    %eax,0x805148
  803074:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803077:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80307e:	a1 54 51 80 00       	mov    0x805154,%eax
  803083:	40                   	inc    %eax
  803084:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803089:	e9 7a 05 00 00       	jmp    803608 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  80308e:	8b 45 08             	mov    0x8(%ebp),%eax
  803091:	8b 50 08             	mov    0x8(%eax),%edx
  803094:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803097:	8b 40 08             	mov    0x8(%eax),%eax
  80309a:	39 c2                	cmp    %eax,%edx
  80309c:	0f 82 14 01 00 00    	jb     8031b6 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  8030a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030a5:	8b 50 08             	mov    0x8(%eax),%edx
  8030a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030ab:	8b 40 0c             	mov    0xc(%eax),%eax
  8030ae:	01 c2                	add    %eax,%edx
  8030b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b3:	8b 40 08             	mov    0x8(%eax),%eax
  8030b6:	39 c2                	cmp    %eax,%edx
  8030b8:	0f 85 90 00 00 00    	jne    80314e <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  8030be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030c1:	8b 50 0c             	mov    0xc(%eax),%edx
  8030c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c7:	8b 40 0c             	mov    0xc(%eax),%eax
  8030ca:	01 c2                	add    %eax,%edx
  8030cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030cf:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  8030d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  8030dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8030df:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8030e6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030ea:	75 17                	jne    803103 <insert_sorted_with_merge_freeList+0x243>
  8030ec:	83 ec 04             	sub    $0x4,%esp
  8030ef:	68 d8 42 80 00       	push   $0x8042d8
  8030f4:	68 49 01 00 00       	push   $0x149
  8030f9:	68 fb 42 80 00       	push   $0x8042fb
  8030fe:	e8 a4 d3 ff ff       	call   8004a7 <_panic>
  803103:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803109:	8b 45 08             	mov    0x8(%ebp),%eax
  80310c:	89 10                	mov    %edx,(%eax)
  80310e:	8b 45 08             	mov    0x8(%ebp),%eax
  803111:	8b 00                	mov    (%eax),%eax
  803113:	85 c0                	test   %eax,%eax
  803115:	74 0d                	je     803124 <insert_sorted_with_merge_freeList+0x264>
  803117:	a1 48 51 80 00       	mov    0x805148,%eax
  80311c:	8b 55 08             	mov    0x8(%ebp),%edx
  80311f:	89 50 04             	mov    %edx,0x4(%eax)
  803122:	eb 08                	jmp    80312c <insert_sorted_with_merge_freeList+0x26c>
  803124:	8b 45 08             	mov    0x8(%ebp),%eax
  803127:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80312c:	8b 45 08             	mov    0x8(%ebp),%eax
  80312f:	a3 48 51 80 00       	mov    %eax,0x805148
  803134:	8b 45 08             	mov    0x8(%ebp),%eax
  803137:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80313e:	a1 54 51 80 00       	mov    0x805154,%eax
  803143:	40                   	inc    %eax
  803144:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803149:	e9 bb 04 00 00       	jmp    803609 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  80314e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803152:	75 17                	jne    80316b <insert_sorted_with_merge_freeList+0x2ab>
  803154:	83 ec 04             	sub    $0x4,%esp
  803157:	68 4c 43 80 00       	push   $0x80434c
  80315c:	68 4c 01 00 00       	push   $0x14c
  803161:	68 fb 42 80 00       	push   $0x8042fb
  803166:	e8 3c d3 ff ff       	call   8004a7 <_panic>
  80316b:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803171:	8b 45 08             	mov    0x8(%ebp),%eax
  803174:	89 50 04             	mov    %edx,0x4(%eax)
  803177:	8b 45 08             	mov    0x8(%ebp),%eax
  80317a:	8b 40 04             	mov    0x4(%eax),%eax
  80317d:	85 c0                	test   %eax,%eax
  80317f:	74 0c                	je     80318d <insert_sorted_with_merge_freeList+0x2cd>
  803181:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803186:	8b 55 08             	mov    0x8(%ebp),%edx
  803189:	89 10                	mov    %edx,(%eax)
  80318b:	eb 08                	jmp    803195 <insert_sorted_with_merge_freeList+0x2d5>
  80318d:	8b 45 08             	mov    0x8(%ebp),%eax
  803190:	a3 38 51 80 00       	mov    %eax,0x805138
  803195:	8b 45 08             	mov    0x8(%ebp),%eax
  803198:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80319d:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031a6:	a1 44 51 80 00       	mov    0x805144,%eax
  8031ab:	40                   	inc    %eax
  8031ac:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8031b1:	e9 53 04 00 00       	jmp    803609 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8031b6:	a1 38 51 80 00       	mov    0x805138,%eax
  8031bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031be:	e9 15 04 00 00       	jmp    8035d8 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  8031c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c6:	8b 00                	mov    (%eax),%eax
  8031c8:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  8031cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ce:	8b 50 08             	mov    0x8(%eax),%edx
  8031d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d4:	8b 40 08             	mov    0x8(%eax),%eax
  8031d7:	39 c2                	cmp    %eax,%edx
  8031d9:	0f 86 f1 03 00 00    	jbe    8035d0 <insert_sorted_with_merge_freeList+0x710>
  8031df:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e2:	8b 50 08             	mov    0x8(%eax),%edx
  8031e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e8:	8b 40 08             	mov    0x8(%eax),%eax
  8031eb:	39 c2                	cmp    %eax,%edx
  8031ed:	0f 83 dd 03 00 00    	jae    8035d0 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  8031f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f6:	8b 50 08             	mov    0x8(%eax),%edx
  8031f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031fc:	8b 40 0c             	mov    0xc(%eax),%eax
  8031ff:	01 c2                	add    %eax,%edx
  803201:	8b 45 08             	mov    0x8(%ebp),%eax
  803204:	8b 40 08             	mov    0x8(%eax),%eax
  803207:	39 c2                	cmp    %eax,%edx
  803209:	0f 85 b9 01 00 00    	jne    8033c8 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80320f:	8b 45 08             	mov    0x8(%ebp),%eax
  803212:	8b 50 08             	mov    0x8(%eax),%edx
  803215:	8b 45 08             	mov    0x8(%ebp),%eax
  803218:	8b 40 0c             	mov    0xc(%eax),%eax
  80321b:	01 c2                	add    %eax,%edx
  80321d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803220:	8b 40 08             	mov    0x8(%eax),%eax
  803223:	39 c2                	cmp    %eax,%edx
  803225:	0f 85 0d 01 00 00    	jne    803338 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  80322b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80322e:	8b 50 0c             	mov    0xc(%eax),%edx
  803231:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803234:	8b 40 0c             	mov    0xc(%eax),%eax
  803237:	01 c2                	add    %eax,%edx
  803239:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80323c:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80323f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803243:	75 17                	jne    80325c <insert_sorted_with_merge_freeList+0x39c>
  803245:	83 ec 04             	sub    $0x4,%esp
  803248:	68 a4 43 80 00       	push   $0x8043a4
  80324d:	68 5c 01 00 00       	push   $0x15c
  803252:	68 fb 42 80 00       	push   $0x8042fb
  803257:	e8 4b d2 ff ff       	call   8004a7 <_panic>
  80325c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80325f:	8b 00                	mov    (%eax),%eax
  803261:	85 c0                	test   %eax,%eax
  803263:	74 10                	je     803275 <insert_sorted_with_merge_freeList+0x3b5>
  803265:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803268:	8b 00                	mov    (%eax),%eax
  80326a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80326d:	8b 52 04             	mov    0x4(%edx),%edx
  803270:	89 50 04             	mov    %edx,0x4(%eax)
  803273:	eb 0b                	jmp    803280 <insert_sorted_with_merge_freeList+0x3c0>
  803275:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803278:	8b 40 04             	mov    0x4(%eax),%eax
  80327b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803280:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803283:	8b 40 04             	mov    0x4(%eax),%eax
  803286:	85 c0                	test   %eax,%eax
  803288:	74 0f                	je     803299 <insert_sorted_with_merge_freeList+0x3d9>
  80328a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80328d:	8b 40 04             	mov    0x4(%eax),%eax
  803290:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803293:	8b 12                	mov    (%edx),%edx
  803295:	89 10                	mov    %edx,(%eax)
  803297:	eb 0a                	jmp    8032a3 <insert_sorted_with_merge_freeList+0x3e3>
  803299:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80329c:	8b 00                	mov    (%eax),%eax
  80329e:	a3 38 51 80 00       	mov    %eax,0x805138
  8032a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032a6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032af:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032b6:	a1 44 51 80 00       	mov    0x805144,%eax
  8032bb:	48                   	dec    %eax
  8032bc:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  8032c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032c4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8032cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032ce:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8032d5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032d9:	75 17                	jne    8032f2 <insert_sorted_with_merge_freeList+0x432>
  8032db:	83 ec 04             	sub    $0x4,%esp
  8032de:	68 d8 42 80 00       	push   $0x8042d8
  8032e3:	68 5f 01 00 00       	push   $0x15f
  8032e8:	68 fb 42 80 00       	push   $0x8042fb
  8032ed:	e8 b5 d1 ff ff       	call   8004a7 <_panic>
  8032f2:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8032f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032fb:	89 10                	mov    %edx,(%eax)
  8032fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803300:	8b 00                	mov    (%eax),%eax
  803302:	85 c0                	test   %eax,%eax
  803304:	74 0d                	je     803313 <insert_sorted_with_merge_freeList+0x453>
  803306:	a1 48 51 80 00       	mov    0x805148,%eax
  80330b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80330e:	89 50 04             	mov    %edx,0x4(%eax)
  803311:	eb 08                	jmp    80331b <insert_sorted_with_merge_freeList+0x45b>
  803313:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803316:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80331b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80331e:	a3 48 51 80 00       	mov    %eax,0x805148
  803323:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803326:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80332d:	a1 54 51 80 00       	mov    0x805154,%eax
  803332:	40                   	inc    %eax
  803333:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803338:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80333b:	8b 50 0c             	mov    0xc(%eax),%edx
  80333e:	8b 45 08             	mov    0x8(%ebp),%eax
  803341:	8b 40 0c             	mov    0xc(%eax),%eax
  803344:	01 c2                	add    %eax,%edx
  803346:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803349:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  80334c:	8b 45 08             	mov    0x8(%ebp),%eax
  80334f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803356:	8b 45 08             	mov    0x8(%ebp),%eax
  803359:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803360:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803364:	75 17                	jne    80337d <insert_sorted_with_merge_freeList+0x4bd>
  803366:	83 ec 04             	sub    $0x4,%esp
  803369:	68 d8 42 80 00       	push   $0x8042d8
  80336e:	68 64 01 00 00       	push   $0x164
  803373:	68 fb 42 80 00       	push   $0x8042fb
  803378:	e8 2a d1 ff ff       	call   8004a7 <_panic>
  80337d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803383:	8b 45 08             	mov    0x8(%ebp),%eax
  803386:	89 10                	mov    %edx,(%eax)
  803388:	8b 45 08             	mov    0x8(%ebp),%eax
  80338b:	8b 00                	mov    (%eax),%eax
  80338d:	85 c0                	test   %eax,%eax
  80338f:	74 0d                	je     80339e <insert_sorted_with_merge_freeList+0x4de>
  803391:	a1 48 51 80 00       	mov    0x805148,%eax
  803396:	8b 55 08             	mov    0x8(%ebp),%edx
  803399:	89 50 04             	mov    %edx,0x4(%eax)
  80339c:	eb 08                	jmp    8033a6 <insert_sorted_with_merge_freeList+0x4e6>
  80339e:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8033a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a9:	a3 48 51 80 00       	mov    %eax,0x805148
  8033ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033b8:	a1 54 51 80 00       	mov    0x805154,%eax
  8033bd:	40                   	inc    %eax
  8033be:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8033c3:	e9 41 02 00 00       	jmp    803609 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8033c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8033cb:	8b 50 08             	mov    0x8(%eax),%edx
  8033ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d1:	8b 40 0c             	mov    0xc(%eax),%eax
  8033d4:	01 c2                	add    %eax,%edx
  8033d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033d9:	8b 40 08             	mov    0x8(%eax),%eax
  8033dc:	39 c2                	cmp    %eax,%edx
  8033de:	0f 85 7c 01 00 00    	jne    803560 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8033e4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8033e8:	74 06                	je     8033f0 <insert_sorted_with_merge_freeList+0x530>
  8033ea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033ee:	75 17                	jne    803407 <insert_sorted_with_merge_freeList+0x547>
  8033f0:	83 ec 04             	sub    $0x4,%esp
  8033f3:	68 14 43 80 00       	push   $0x804314
  8033f8:	68 69 01 00 00       	push   $0x169
  8033fd:	68 fb 42 80 00       	push   $0x8042fb
  803402:	e8 a0 d0 ff ff       	call   8004a7 <_panic>
  803407:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80340a:	8b 50 04             	mov    0x4(%eax),%edx
  80340d:	8b 45 08             	mov    0x8(%ebp),%eax
  803410:	89 50 04             	mov    %edx,0x4(%eax)
  803413:	8b 45 08             	mov    0x8(%ebp),%eax
  803416:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803419:	89 10                	mov    %edx,(%eax)
  80341b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80341e:	8b 40 04             	mov    0x4(%eax),%eax
  803421:	85 c0                	test   %eax,%eax
  803423:	74 0d                	je     803432 <insert_sorted_with_merge_freeList+0x572>
  803425:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803428:	8b 40 04             	mov    0x4(%eax),%eax
  80342b:	8b 55 08             	mov    0x8(%ebp),%edx
  80342e:	89 10                	mov    %edx,(%eax)
  803430:	eb 08                	jmp    80343a <insert_sorted_with_merge_freeList+0x57a>
  803432:	8b 45 08             	mov    0x8(%ebp),%eax
  803435:	a3 38 51 80 00       	mov    %eax,0x805138
  80343a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80343d:	8b 55 08             	mov    0x8(%ebp),%edx
  803440:	89 50 04             	mov    %edx,0x4(%eax)
  803443:	a1 44 51 80 00       	mov    0x805144,%eax
  803448:	40                   	inc    %eax
  803449:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  80344e:	8b 45 08             	mov    0x8(%ebp),%eax
  803451:	8b 50 0c             	mov    0xc(%eax),%edx
  803454:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803457:	8b 40 0c             	mov    0xc(%eax),%eax
  80345a:	01 c2                	add    %eax,%edx
  80345c:	8b 45 08             	mov    0x8(%ebp),%eax
  80345f:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803462:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803466:	75 17                	jne    80347f <insert_sorted_with_merge_freeList+0x5bf>
  803468:	83 ec 04             	sub    $0x4,%esp
  80346b:	68 a4 43 80 00       	push   $0x8043a4
  803470:	68 6b 01 00 00       	push   $0x16b
  803475:	68 fb 42 80 00       	push   $0x8042fb
  80347a:	e8 28 d0 ff ff       	call   8004a7 <_panic>
  80347f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803482:	8b 00                	mov    (%eax),%eax
  803484:	85 c0                	test   %eax,%eax
  803486:	74 10                	je     803498 <insert_sorted_with_merge_freeList+0x5d8>
  803488:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80348b:	8b 00                	mov    (%eax),%eax
  80348d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803490:	8b 52 04             	mov    0x4(%edx),%edx
  803493:	89 50 04             	mov    %edx,0x4(%eax)
  803496:	eb 0b                	jmp    8034a3 <insert_sorted_with_merge_freeList+0x5e3>
  803498:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80349b:	8b 40 04             	mov    0x4(%eax),%eax
  80349e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8034a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034a6:	8b 40 04             	mov    0x4(%eax),%eax
  8034a9:	85 c0                	test   %eax,%eax
  8034ab:	74 0f                	je     8034bc <insert_sorted_with_merge_freeList+0x5fc>
  8034ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034b0:	8b 40 04             	mov    0x4(%eax),%eax
  8034b3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8034b6:	8b 12                	mov    (%edx),%edx
  8034b8:	89 10                	mov    %edx,(%eax)
  8034ba:	eb 0a                	jmp    8034c6 <insert_sorted_with_merge_freeList+0x606>
  8034bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034bf:	8b 00                	mov    (%eax),%eax
  8034c1:	a3 38 51 80 00       	mov    %eax,0x805138
  8034c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034d2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034d9:	a1 44 51 80 00       	mov    0x805144,%eax
  8034de:	48                   	dec    %eax
  8034df:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  8034e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034e7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8034ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034f1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8034f8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8034fc:	75 17                	jne    803515 <insert_sorted_with_merge_freeList+0x655>
  8034fe:	83 ec 04             	sub    $0x4,%esp
  803501:	68 d8 42 80 00       	push   $0x8042d8
  803506:	68 6e 01 00 00       	push   $0x16e
  80350b:	68 fb 42 80 00       	push   $0x8042fb
  803510:	e8 92 cf ff ff       	call   8004a7 <_panic>
  803515:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80351b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80351e:	89 10                	mov    %edx,(%eax)
  803520:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803523:	8b 00                	mov    (%eax),%eax
  803525:	85 c0                	test   %eax,%eax
  803527:	74 0d                	je     803536 <insert_sorted_with_merge_freeList+0x676>
  803529:	a1 48 51 80 00       	mov    0x805148,%eax
  80352e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803531:	89 50 04             	mov    %edx,0x4(%eax)
  803534:	eb 08                	jmp    80353e <insert_sorted_with_merge_freeList+0x67e>
  803536:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803539:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80353e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803541:	a3 48 51 80 00       	mov    %eax,0x805148
  803546:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803549:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803550:	a1 54 51 80 00       	mov    0x805154,%eax
  803555:	40                   	inc    %eax
  803556:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80355b:	e9 a9 00 00 00       	jmp    803609 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803560:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803564:	74 06                	je     80356c <insert_sorted_with_merge_freeList+0x6ac>
  803566:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80356a:	75 17                	jne    803583 <insert_sorted_with_merge_freeList+0x6c3>
  80356c:	83 ec 04             	sub    $0x4,%esp
  80356f:	68 70 43 80 00       	push   $0x804370
  803574:	68 73 01 00 00       	push   $0x173
  803579:	68 fb 42 80 00       	push   $0x8042fb
  80357e:	e8 24 cf ff ff       	call   8004a7 <_panic>
  803583:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803586:	8b 10                	mov    (%eax),%edx
  803588:	8b 45 08             	mov    0x8(%ebp),%eax
  80358b:	89 10                	mov    %edx,(%eax)
  80358d:	8b 45 08             	mov    0x8(%ebp),%eax
  803590:	8b 00                	mov    (%eax),%eax
  803592:	85 c0                	test   %eax,%eax
  803594:	74 0b                	je     8035a1 <insert_sorted_with_merge_freeList+0x6e1>
  803596:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803599:	8b 00                	mov    (%eax),%eax
  80359b:	8b 55 08             	mov    0x8(%ebp),%edx
  80359e:	89 50 04             	mov    %edx,0x4(%eax)
  8035a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035a4:	8b 55 08             	mov    0x8(%ebp),%edx
  8035a7:	89 10                	mov    %edx,(%eax)
  8035a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035af:	89 50 04             	mov    %edx,0x4(%eax)
  8035b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b5:	8b 00                	mov    (%eax),%eax
  8035b7:	85 c0                	test   %eax,%eax
  8035b9:	75 08                	jne    8035c3 <insert_sorted_with_merge_freeList+0x703>
  8035bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8035be:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8035c3:	a1 44 51 80 00       	mov    0x805144,%eax
  8035c8:	40                   	inc    %eax
  8035c9:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  8035ce:	eb 39                	jmp    803609 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8035d0:	a1 40 51 80 00       	mov    0x805140,%eax
  8035d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8035d8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035dc:	74 07                	je     8035e5 <insert_sorted_with_merge_freeList+0x725>
  8035de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035e1:	8b 00                	mov    (%eax),%eax
  8035e3:	eb 05                	jmp    8035ea <insert_sorted_with_merge_freeList+0x72a>
  8035e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8035ea:	a3 40 51 80 00       	mov    %eax,0x805140
  8035ef:	a1 40 51 80 00       	mov    0x805140,%eax
  8035f4:	85 c0                	test   %eax,%eax
  8035f6:	0f 85 c7 fb ff ff    	jne    8031c3 <insert_sorted_with_merge_freeList+0x303>
  8035fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803600:	0f 85 bd fb ff ff    	jne    8031c3 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803606:	eb 01                	jmp    803609 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803608:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803609:	90                   	nop
  80360a:	c9                   	leave  
  80360b:	c3                   	ret    

0080360c <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  80360c:	55                   	push   %ebp
  80360d:	89 e5                	mov    %esp,%ebp
  80360f:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803612:	8b 55 08             	mov    0x8(%ebp),%edx
  803615:	89 d0                	mov    %edx,%eax
  803617:	c1 e0 02             	shl    $0x2,%eax
  80361a:	01 d0                	add    %edx,%eax
  80361c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803623:	01 d0                	add    %edx,%eax
  803625:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80362c:	01 d0                	add    %edx,%eax
  80362e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803635:	01 d0                	add    %edx,%eax
  803637:	c1 e0 04             	shl    $0x4,%eax
  80363a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  80363d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  803644:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803647:	83 ec 0c             	sub    $0xc,%esp
  80364a:	50                   	push   %eax
  80364b:	e8 26 e7 ff ff       	call   801d76 <sys_get_virtual_time>
  803650:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803653:	eb 41                	jmp    803696 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  803655:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803658:	83 ec 0c             	sub    $0xc,%esp
  80365b:	50                   	push   %eax
  80365c:	e8 15 e7 ff ff       	call   801d76 <sys_get_virtual_time>
  803661:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803664:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803667:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80366a:	29 c2                	sub    %eax,%edx
  80366c:	89 d0                	mov    %edx,%eax
  80366e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803671:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803674:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803677:	89 d1                	mov    %edx,%ecx
  803679:	29 c1                	sub    %eax,%ecx
  80367b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80367e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803681:	39 c2                	cmp    %eax,%edx
  803683:	0f 97 c0             	seta   %al
  803686:	0f b6 c0             	movzbl %al,%eax
  803689:	29 c1                	sub    %eax,%ecx
  80368b:	89 c8                	mov    %ecx,%eax
  80368d:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803690:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803693:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  803696:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803699:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80369c:	72 b7                	jb     803655 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  80369e:	90                   	nop
  80369f:	c9                   	leave  
  8036a0:	c3                   	ret    

008036a1 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8036a1:	55                   	push   %ebp
  8036a2:	89 e5                	mov    %esp,%ebp
  8036a4:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8036a7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8036ae:	eb 03                	jmp    8036b3 <busy_wait+0x12>
  8036b0:	ff 45 fc             	incl   -0x4(%ebp)
  8036b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8036b6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8036b9:	72 f5                	jb     8036b0 <busy_wait+0xf>
	return i;
  8036bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8036be:	c9                   	leave  
  8036bf:	c3                   	ret    

008036c0 <__udivdi3>:
  8036c0:	55                   	push   %ebp
  8036c1:	57                   	push   %edi
  8036c2:	56                   	push   %esi
  8036c3:	53                   	push   %ebx
  8036c4:	83 ec 1c             	sub    $0x1c,%esp
  8036c7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8036cb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8036cf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8036d3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8036d7:	89 ca                	mov    %ecx,%edx
  8036d9:	89 f8                	mov    %edi,%eax
  8036db:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8036df:	85 f6                	test   %esi,%esi
  8036e1:	75 2d                	jne    803710 <__udivdi3+0x50>
  8036e3:	39 cf                	cmp    %ecx,%edi
  8036e5:	77 65                	ja     80374c <__udivdi3+0x8c>
  8036e7:	89 fd                	mov    %edi,%ebp
  8036e9:	85 ff                	test   %edi,%edi
  8036eb:	75 0b                	jne    8036f8 <__udivdi3+0x38>
  8036ed:	b8 01 00 00 00       	mov    $0x1,%eax
  8036f2:	31 d2                	xor    %edx,%edx
  8036f4:	f7 f7                	div    %edi
  8036f6:	89 c5                	mov    %eax,%ebp
  8036f8:	31 d2                	xor    %edx,%edx
  8036fa:	89 c8                	mov    %ecx,%eax
  8036fc:	f7 f5                	div    %ebp
  8036fe:	89 c1                	mov    %eax,%ecx
  803700:	89 d8                	mov    %ebx,%eax
  803702:	f7 f5                	div    %ebp
  803704:	89 cf                	mov    %ecx,%edi
  803706:	89 fa                	mov    %edi,%edx
  803708:	83 c4 1c             	add    $0x1c,%esp
  80370b:	5b                   	pop    %ebx
  80370c:	5e                   	pop    %esi
  80370d:	5f                   	pop    %edi
  80370e:	5d                   	pop    %ebp
  80370f:	c3                   	ret    
  803710:	39 ce                	cmp    %ecx,%esi
  803712:	77 28                	ja     80373c <__udivdi3+0x7c>
  803714:	0f bd fe             	bsr    %esi,%edi
  803717:	83 f7 1f             	xor    $0x1f,%edi
  80371a:	75 40                	jne    80375c <__udivdi3+0x9c>
  80371c:	39 ce                	cmp    %ecx,%esi
  80371e:	72 0a                	jb     80372a <__udivdi3+0x6a>
  803720:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803724:	0f 87 9e 00 00 00    	ja     8037c8 <__udivdi3+0x108>
  80372a:	b8 01 00 00 00       	mov    $0x1,%eax
  80372f:	89 fa                	mov    %edi,%edx
  803731:	83 c4 1c             	add    $0x1c,%esp
  803734:	5b                   	pop    %ebx
  803735:	5e                   	pop    %esi
  803736:	5f                   	pop    %edi
  803737:	5d                   	pop    %ebp
  803738:	c3                   	ret    
  803739:	8d 76 00             	lea    0x0(%esi),%esi
  80373c:	31 ff                	xor    %edi,%edi
  80373e:	31 c0                	xor    %eax,%eax
  803740:	89 fa                	mov    %edi,%edx
  803742:	83 c4 1c             	add    $0x1c,%esp
  803745:	5b                   	pop    %ebx
  803746:	5e                   	pop    %esi
  803747:	5f                   	pop    %edi
  803748:	5d                   	pop    %ebp
  803749:	c3                   	ret    
  80374a:	66 90                	xchg   %ax,%ax
  80374c:	89 d8                	mov    %ebx,%eax
  80374e:	f7 f7                	div    %edi
  803750:	31 ff                	xor    %edi,%edi
  803752:	89 fa                	mov    %edi,%edx
  803754:	83 c4 1c             	add    $0x1c,%esp
  803757:	5b                   	pop    %ebx
  803758:	5e                   	pop    %esi
  803759:	5f                   	pop    %edi
  80375a:	5d                   	pop    %ebp
  80375b:	c3                   	ret    
  80375c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803761:	89 eb                	mov    %ebp,%ebx
  803763:	29 fb                	sub    %edi,%ebx
  803765:	89 f9                	mov    %edi,%ecx
  803767:	d3 e6                	shl    %cl,%esi
  803769:	89 c5                	mov    %eax,%ebp
  80376b:	88 d9                	mov    %bl,%cl
  80376d:	d3 ed                	shr    %cl,%ebp
  80376f:	89 e9                	mov    %ebp,%ecx
  803771:	09 f1                	or     %esi,%ecx
  803773:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803777:	89 f9                	mov    %edi,%ecx
  803779:	d3 e0                	shl    %cl,%eax
  80377b:	89 c5                	mov    %eax,%ebp
  80377d:	89 d6                	mov    %edx,%esi
  80377f:	88 d9                	mov    %bl,%cl
  803781:	d3 ee                	shr    %cl,%esi
  803783:	89 f9                	mov    %edi,%ecx
  803785:	d3 e2                	shl    %cl,%edx
  803787:	8b 44 24 08          	mov    0x8(%esp),%eax
  80378b:	88 d9                	mov    %bl,%cl
  80378d:	d3 e8                	shr    %cl,%eax
  80378f:	09 c2                	or     %eax,%edx
  803791:	89 d0                	mov    %edx,%eax
  803793:	89 f2                	mov    %esi,%edx
  803795:	f7 74 24 0c          	divl   0xc(%esp)
  803799:	89 d6                	mov    %edx,%esi
  80379b:	89 c3                	mov    %eax,%ebx
  80379d:	f7 e5                	mul    %ebp
  80379f:	39 d6                	cmp    %edx,%esi
  8037a1:	72 19                	jb     8037bc <__udivdi3+0xfc>
  8037a3:	74 0b                	je     8037b0 <__udivdi3+0xf0>
  8037a5:	89 d8                	mov    %ebx,%eax
  8037a7:	31 ff                	xor    %edi,%edi
  8037a9:	e9 58 ff ff ff       	jmp    803706 <__udivdi3+0x46>
  8037ae:	66 90                	xchg   %ax,%ax
  8037b0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8037b4:	89 f9                	mov    %edi,%ecx
  8037b6:	d3 e2                	shl    %cl,%edx
  8037b8:	39 c2                	cmp    %eax,%edx
  8037ba:	73 e9                	jae    8037a5 <__udivdi3+0xe5>
  8037bc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8037bf:	31 ff                	xor    %edi,%edi
  8037c1:	e9 40 ff ff ff       	jmp    803706 <__udivdi3+0x46>
  8037c6:	66 90                	xchg   %ax,%ax
  8037c8:	31 c0                	xor    %eax,%eax
  8037ca:	e9 37 ff ff ff       	jmp    803706 <__udivdi3+0x46>
  8037cf:	90                   	nop

008037d0 <__umoddi3>:
  8037d0:	55                   	push   %ebp
  8037d1:	57                   	push   %edi
  8037d2:	56                   	push   %esi
  8037d3:	53                   	push   %ebx
  8037d4:	83 ec 1c             	sub    $0x1c,%esp
  8037d7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8037db:	8b 74 24 34          	mov    0x34(%esp),%esi
  8037df:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8037e3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8037e7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8037eb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8037ef:	89 f3                	mov    %esi,%ebx
  8037f1:	89 fa                	mov    %edi,%edx
  8037f3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8037f7:	89 34 24             	mov    %esi,(%esp)
  8037fa:	85 c0                	test   %eax,%eax
  8037fc:	75 1a                	jne    803818 <__umoddi3+0x48>
  8037fe:	39 f7                	cmp    %esi,%edi
  803800:	0f 86 a2 00 00 00    	jbe    8038a8 <__umoddi3+0xd8>
  803806:	89 c8                	mov    %ecx,%eax
  803808:	89 f2                	mov    %esi,%edx
  80380a:	f7 f7                	div    %edi
  80380c:	89 d0                	mov    %edx,%eax
  80380e:	31 d2                	xor    %edx,%edx
  803810:	83 c4 1c             	add    $0x1c,%esp
  803813:	5b                   	pop    %ebx
  803814:	5e                   	pop    %esi
  803815:	5f                   	pop    %edi
  803816:	5d                   	pop    %ebp
  803817:	c3                   	ret    
  803818:	39 f0                	cmp    %esi,%eax
  80381a:	0f 87 ac 00 00 00    	ja     8038cc <__umoddi3+0xfc>
  803820:	0f bd e8             	bsr    %eax,%ebp
  803823:	83 f5 1f             	xor    $0x1f,%ebp
  803826:	0f 84 ac 00 00 00    	je     8038d8 <__umoddi3+0x108>
  80382c:	bf 20 00 00 00       	mov    $0x20,%edi
  803831:	29 ef                	sub    %ebp,%edi
  803833:	89 fe                	mov    %edi,%esi
  803835:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803839:	89 e9                	mov    %ebp,%ecx
  80383b:	d3 e0                	shl    %cl,%eax
  80383d:	89 d7                	mov    %edx,%edi
  80383f:	89 f1                	mov    %esi,%ecx
  803841:	d3 ef                	shr    %cl,%edi
  803843:	09 c7                	or     %eax,%edi
  803845:	89 e9                	mov    %ebp,%ecx
  803847:	d3 e2                	shl    %cl,%edx
  803849:	89 14 24             	mov    %edx,(%esp)
  80384c:	89 d8                	mov    %ebx,%eax
  80384e:	d3 e0                	shl    %cl,%eax
  803850:	89 c2                	mov    %eax,%edx
  803852:	8b 44 24 08          	mov    0x8(%esp),%eax
  803856:	d3 e0                	shl    %cl,%eax
  803858:	89 44 24 04          	mov    %eax,0x4(%esp)
  80385c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803860:	89 f1                	mov    %esi,%ecx
  803862:	d3 e8                	shr    %cl,%eax
  803864:	09 d0                	or     %edx,%eax
  803866:	d3 eb                	shr    %cl,%ebx
  803868:	89 da                	mov    %ebx,%edx
  80386a:	f7 f7                	div    %edi
  80386c:	89 d3                	mov    %edx,%ebx
  80386e:	f7 24 24             	mull   (%esp)
  803871:	89 c6                	mov    %eax,%esi
  803873:	89 d1                	mov    %edx,%ecx
  803875:	39 d3                	cmp    %edx,%ebx
  803877:	0f 82 87 00 00 00    	jb     803904 <__umoddi3+0x134>
  80387d:	0f 84 91 00 00 00    	je     803914 <__umoddi3+0x144>
  803883:	8b 54 24 04          	mov    0x4(%esp),%edx
  803887:	29 f2                	sub    %esi,%edx
  803889:	19 cb                	sbb    %ecx,%ebx
  80388b:	89 d8                	mov    %ebx,%eax
  80388d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803891:	d3 e0                	shl    %cl,%eax
  803893:	89 e9                	mov    %ebp,%ecx
  803895:	d3 ea                	shr    %cl,%edx
  803897:	09 d0                	or     %edx,%eax
  803899:	89 e9                	mov    %ebp,%ecx
  80389b:	d3 eb                	shr    %cl,%ebx
  80389d:	89 da                	mov    %ebx,%edx
  80389f:	83 c4 1c             	add    $0x1c,%esp
  8038a2:	5b                   	pop    %ebx
  8038a3:	5e                   	pop    %esi
  8038a4:	5f                   	pop    %edi
  8038a5:	5d                   	pop    %ebp
  8038a6:	c3                   	ret    
  8038a7:	90                   	nop
  8038a8:	89 fd                	mov    %edi,%ebp
  8038aa:	85 ff                	test   %edi,%edi
  8038ac:	75 0b                	jne    8038b9 <__umoddi3+0xe9>
  8038ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8038b3:	31 d2                	xor    %edx,%edx
  8038b5:	f7 f7                	div    %edi
  8038b7:	89 c5                	mov    %eax,%ebp
  8038b9:	89 f0                	mov    %esi,%eax
  8038bb:	31 d2                	xor    %edx,%edx
  8038bd:	f7 f5                	div    %ebp
  8038bf:	89 c8                	mov    %ecx,%eax
  8038c1:	f7 f5                	div    %ebp
  8038c3:	89 d0                	mov    %edx,%eax
  8038c5:	e9 44 ff ff ff       	jmp    80380e <__umoddi3+0x3e>
  8038ca:	66 90                	xchg   %ax,%ax
  8038cc:	89 c8                	mov    %ecx,%eax
  8038ce:	89 f2                	mov    %esi,%edx
  8038d0:	83 c4 1c             	add    $0x1c,%esp
  8038d3:	5b                   	pop    %ebx
  8038d4:	5e                   	pop    %esi
  8038d5:	5f                   	pop    %edi
  8038d6:	5d                   	pop    %ebp
  8038d7:	c3                   	ret    
  8038d8:	3b 04 24             	cmp    (%esp),%eax
  8038db:	72 06                	jb     8038e3 <__umoddi3+0x113>
  8038dd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8038e1:	77 0f                	ja     8038f2 <__umoddi3+0x122>
  8038e3:	89 f2                	mov    %esi,%edx
  8038e5:	29 f9                	sub    %edi,%ecx
  8038e7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8038eb:	89 14 24             	mov    %edx,(%esp)
  8038ee:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8038f2:	8b 44 24 04          	mov    0x4(%esp),%eax
  8038f6:	8b 14 24             	mov    (%esp),%edx
  8038f9:	83 c4 1c             	add    $0x1c,%esp
  8038fc:	5b                   	pop    %ebx
  8038fd:	5e                   	pop    %esi
  8038fe:	5f                   	pop    %edi
  8038ff:	5d                   	pop    %ebp
  803900:	c3                   	ret    
  803901:	8d 76 00             	lea    0x0(%esi),%esi
  803904:	2b 04 24             	sub    (%esp),%eax
  803907:	19 fa                	sbb    %edi,%edx
  803909:	89 d1                	mov    %edx,%ecx
  80390b:	89 c6                	mov    %eax,%esi
  80390d:	e9 71 ff ff ff       	jmp    803883 <__umoddi3+0xb3>
  803912:	66 90                	xchg   %ax,%ax
  803914:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803918:	72 ea                	jb     803904 <__umoddi3+0x134>
  80391a:	89 d9                	mov    %ebx,%ecx
  80391c:	e9 62 ff ff ff       	jmp    803883 <__umoddi3+0xb3>
