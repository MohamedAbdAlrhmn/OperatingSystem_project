
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
  80008d:	68 80 38 80 00       	push   $0x803880
  800092:	6a 13                	push   $0x13
  800094:	68 9c 38 80 00       	push   $0x80389c
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
  8000ab:	e8 e0 18 00 00       	call   801990 <sys_calculate_free_frames>
  8000b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	x = smalloc("x", 4, 0);
  8000b3:	83 ec 04             	sub    $0x4,%esp
  8000b6:	6a 00                	push   $0x0
  8000b8:	6a 04                	push   $0x4
  8000ba:	68 b7 38 80 00       	push   $0x8038b7
  8000bf:	e8 67 16 00 00       	call   80172b <smalloc>
  8000c4:	83 c4 10             	add    $0x10,%esp
  8000c7:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if (x != (uint32*)USER_HEAP_START) panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8000ca:	81 7d e8 00 00 00 80 	cmpl   $0x80000000,-0x18(%ebp)
  8000d1:	74 14                	je     8000e7 <_main+0xaf>
  8000d3:	83 ec 04             	sub    $0x4,%esp
  8000d6:	68 bc 38 80 00       	push   $0x8038bc
  8000db:	6a 1e                	push   $0x1e
  8000dd:	68 9c 38 80 00       	push   $0x80389c
  8000e2:	e8 c0 03 00 00       	call   8004a7 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Create(): Wrong allocation- make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8000e7:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000ea:	e8 a1 18 00 00       	call   801990 <sys_calculate_free_frames>
  8000ef:	29 c3                	sub    %eax,%ebx
  8000f1:	89 d8                	mov    %ebx,%eax
  8000f3:	83 f8 04             	cmp    $0x4,%eax
  8000f6:	74 14                	je     80010c <_main+0xd4>
  8000f8:	83 ec 04             	sub    $0x4,%esp
  8000fb:	68 20 39 80 00       	push   $0x803920
  800100:	6a 1f                	push   $0x1f
  800102:	68 9c 38 80 00       	push   $0x80389c
  800107:	e8 9b 03 00 00       	call   8004a7 <_panic>

	//y: Readonly
	freeFrames = sys_calculate_free_frames() ;
  80010c:	e8 7f 18 00 00       	call   801990 <sys_calculate_free_frames>
  800111:	89 45 ec             	mov    %eax,-0x14(%ebp)
	y = smalloc("y", 4, 0);
  800114:	83 ec 04             	sub    $0x4,%esp
  800117:	6a 00                	push   $0x0
  800119:	6a 04                	push   $0x4
  80011b:	68 a8 39 80 00       	push   $0x8039a8
  800120:	e8 06 16 00 00       	call   80172b <smalloc>
  800125:	83 c4 10             	add    $0x10,%esp
  800128:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (y != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  80012b:	81 7d e4 00 10 00 80 	cmpl   $0x80001000,-0x1c(%ebp)
  800132:	74 14                	je     800148 <_main+0x110>
  800134:	83 ec 04             	sub    $0x4,%esp
  800137:	68 bc 38 80 00       	push   $0x8038bc
  80013c:	6a 24                	push   $0x24
  80013e:	68 9c 38 80 00       	push   $0x80389c
  800143:	e8 5f 03 00 00       	call   8004a7 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1+0+2) panic("Create(): Wrong allocation- make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800148:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  80014b:	e8 40 18 00 00       	call   801990 <sys_calculate_free_frames>
  800150:	29 c3                	sub    %eax,%ebx
  800152:	89 d8                	mov    %ebx,%eax
  800154:	83 f8 03             	cmp    $0x3,%eax
  800157:	74 14                	je     80016d <_main+0x135>
  800159:	83 ec 04             	sub    $0x4,%esp
  80015c:	68 20 39 80 00       	push   $0x803920
  800161:	6a 25                	push   $0x25
  800163:	68 9c 38 80 00       	push   $0x80389c
  800168:	e8 3a 03 00 00       	call   8004a7 <_panic>

	//z: Writable
	freeFrames = sys_calculate_free_frames() ;
  80016d:	e8 1e 18 00 00       	call   801990 <sys_calculate_free_frames>
  800172:	89 45 ec             	mov    %eax,-0x14(%ebp)
	z = smalloc("z", 4, 1);
  800175:	83 ec 04             	sub    $0x4,%esp
  800178:	6a 01                	push   $0x1
  80017a:	6a 04                	push   $0x4
  80017c:	68 aa 39 80 00       	push   $0x8039aa
  800181:	e8 a5 15 00 00       	call   80172b <smalloc>
  800186:	83 c4 10             	add    $0x10,%esp
  800189:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (z != (uint32*)(USER_HEAP_START + 2 * PAGE_SIZE)) panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  80018c:	81 7d e0 00 20 00 80 	cmpl   $0x80002000,-0x20(%ebp)
  800193:	74 14                	je     8001a9 <_main+0x171>
  800195:	83 ec 04             	sub    $0x4,%esp
  800198:	68 bc 38 80 00       	push   $0x8038bc
  80019d:	6a 2a                	push   $0x2a
  80019f:	68 9c 38 80 00       	push   $0x80389c
  8001a4:	e8 fe 02 00 00       	call   8004a7 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1+0+2) panic("Create(): Wrong allocation- make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8001a9:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8001ac:	e8 df 17 00 00       	call   801990 <sys_calculate_free_frames>
  8001b1:	29 c3                	sub    %eax,%ebx
  8001b3:	89 d8                	mov    %ebx,%eax
  8001b5:	83 f8 03             	cmp    $0x3,%eax
  8001b8:	74 14                	je     8001ce <_main+0x196>
  8001ba:	83 ec 04             	sub    $0x4,%esp
  8001bd:	68 20 39 80 00       	push   $0x803920
  8001c2:	6a 2b                	push   $0x2b
  8001c4:	68 9c 38 80 00       	push   $0x80389c
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
  800203:	68 ac 39 80 00       	push   $0x8039ac
  800208:	e8 f5 19 00 00       	call   801c02 <sys_create_env>
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
  800236:	68 ac 39 80 00       	push   $0x8039ac
  80023b:	e8 c2 19 00 00       	call   801c02 <sys_create_env>
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
  800269:	68 ac 39 80 00       	push   $0x8039ac
  80026e:	e8 8f 19 00 00       	call   801c02 <sys_create_env>
  800273:	83 c4 10             	add    $0x10,%esp
  800276:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	//to check that the slave environments completed successfully
	rsttst();
  800279:	e8 d0 1a 00 00       	call   801d4e <rsttst>

	sys_run_env(id1);
  80027e:	83 ec 0c             	sub    $0xc,%esp
  800281:	ff 75 dc             	pushl  -0x24(%ebp)
  800284:	e8 97 19 00 00       	call   801c20 <sys_run_env>
  800289:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id2);
  80028c:	83 ec 0c             	sub    $0xc,%esp
  80028f:	ff 75 d8             	pushl  -0x28(%ebp)
  800292:	e8 89 19 00 00       	call   801c20 <sys_run_env>
  800297:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id3);
  80029a:	83 ec 0c             	sub    $0xc,%esp
  80029d:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002a0:	e8 7b 19 00 00       	call   801c20 <sys_run_env>
  8002a5:	83 c4 10             	add    $0x10,%esp

	env_sleep(12000) ;
  8002a8:	83 ec 0c             	sub    $0xc,%esp
  8002ab:	68 e0 2e 00 00       	push   $0x2ee0
  8002b0:	e8 9d 32 00 00       	call   803552 <env_sleep>
  8002b5:	83 c4 10             	add    $0x10,%esp

	//to ensure that the slave environments completed successfully
	if (gettst()!=3) panic("test failed");
  8002b8:	e8 0b 1b 00 00       	call   801dc8 <gettst>
  8002bd:	83 f8 03             	cmp    $0x3,%eax
  8002c0:	74 14                	je     8002d6 <_main+0x29e>
  8002c2:	83 ec 04             	sub    $0x4,%esp
  8002c5:	68 b7 39 80 00       	push   $0x8039b7
  8002ca:	6a 3f                	push   $0x3f
  8002cc:	68 9c 38 80 00       	push   $0x80389c
  8002d1:	e8 d1 01 00 00       	call   8004a7 <_panic>


	if (*z != 30)
  8002d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002d9:	8b 00                	mov    (%eax),%eax
  8002db:	83 f8 1e             	cmp    $0x1e,%eax
  8002de:	74 14                	je     8002f4 <_main+0x2bc>
		panic("Error!! Please check the creation (or the getting) of shared variables!!\n\n\n");
  8002e0:	83 ec 04             	sub    $0x4,%esp
  8002e3:	68 c4 39 80 00       	push   $0x8039c4
  8002e8:	6a 43                	push   $0x43
  8002ea:	68 9c 38 80 00       	push   $0x80389c
  8002ef:	e8 b3 01 00 00       	call   8004a7 <_panic>
	else
		cprintf("Congratulations!! Test of Shared Variables [Create & Get] [2] completed successfully!!\n\n\n");
  8002f4:	83 ec 0c             	sub    $0xc,%esp
  8002f7:	68 10 3a 80 00       	push   $0x803a10
  8002fc:	e8 5a 04 00 00       	call   80075b <cprintf>
  800301:	83 c4 10             	add    $0x10,%esp

	cprintf("Now, ILLEGAL MEM ACCESS should be occur, due to attempting to write a ReadOnly variable\n\n\n");
  800304:	83 ec 0c             	sub    $0xc,%esp
  800307:	68 6c 3a 80 00       	push   $0x803a6c
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
  800337:	68 c7 3a 80 00       	push   $0x803ac7
  80033c:	e8 c1 18 00 00       	call   801c02 <sys_create_env>
  800341:	83 c4 10             	add    $0x10,%esp
  800344:	89 45 dc             	mov    %eax,-0x24(%ebp)

	env_sleep(3000) ;
  800347:	83 ec 0c             	sub    $0xc,%esp
  80034a:	68 b8 0b 00 00       	push   $0xbb8
  80034f:	e8 fe 31 00 00       	call   803552 <env_sleep>
  800354:	83 c4 10             	add    $0x10,%esp

	sys_run_env(id1);
  800357:	83 ec 0c             	sub    $0xc,%esp
  80035a:	ff 75 dc             	pushl  -0x24(%ebp)
  80035d:	e8 be 18 00 00       	call   801c20 <sys_run_env>
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
  800371:	e8 fa 18 00 00       	call   801c70 <sys_getenvindex>
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
  8003dc:	e8 9c 16 00 00       	call   801a7d <sys_disable_interrupt>
	cprintf("**************************************\n");
  8003e1:	83 ec 0c             	sub    $0xc,%esp
  8003e4:	68 ec 3a 80 00       	push   $0x803aec
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
  80040c:	68 14 3b 80 00       	push   $0x803b14
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
  80043d:	68 3c 3b 80 00       	push   $0x803b3c
  800442:	e8 14 03 00 00       	call   80075b <cprintf>
  800447:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80044a:	a1 20 50 80 00       	mov    0x805020,%eax
  80044f:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800455:	83 ec 08             	sub    $0x8,%esp
  800458:	50                   	push   %eax
  800459:	68 94 3b 80 00       	push   $0x803b94
  80045e:	e8 f8 02 00 00       	call   80075b <cprintf>
  800463:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800466:	83 ec 0c             	sub    $0xc,%esp
  800469:	68 ec 3a 80 00       	push   $0x803aec
  80046e:	e8 e8 02 00 00       	call   80075b <cprintf>
  800473:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800476:	e8 1c 16 00 00       	call   801a97 <sys_enable_interrupt>

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
  80048e:	e8 a9 17 00 00       	call   801c3c <sys_destroy_env>
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
  80049f:	e8 fe 17 00 00       	call   801ca2 <sys_exit_env>
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
  8004c8:	68 a8 3b 80 00       	push   $0x803ba8
  8004cd:	e8 89 02 00 00       	call   80075b <cprintf>
  8004d2:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8004d5:	a1 00 50 80 00       	mov    0x805000,%eax
  8004da:	ff 75 0c             	pushl  0xc(%ebp)
  8004dd:	ff 75 08             	pushl  0x8(%ebp)
  8004e0:	50                   	push   %eax
  8004e1:	68 ad 3b 80 00       	push   $0x803bad
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
  800505:	68 c9 3b 80 00       	push   $0x803bc9
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
  800531:	68 cc 3b 80 00       	push   $0x803bcc
  800536:	6a 26                	push   $0x26
  800538:	68 18 3c 80 00       	push   $0x803c18
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
  800603:	68 24 3c 80 00       	push   $0x803c24
  800608:	6a 3a                	push   $0x3a
  80060a:	68 18 3c 80 00       	push   $0x803c18
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
  800673:	68 78 3c 80 00       	push   $0x803c78
  800678:	6a 44                	push   $0x44
  80067a:	68 18 3c 80 00       	push   $0x803c18
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
  8006cd:	e8 fd 11 00 00       	call   8018cf <sys_cputs>
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
  800744:	e8 86 11 00 00       	call   8018cf <sys_cputs>
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
  80078e:	e8 ea 12 00 00       	call   801a7d <sys_disable_interrupt>
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
  8007ae:	e8 e4 12 00 00       	call   801a97 <sys_enable_interrupt>
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
  8007f8:	e8 0b 2e 00 00       	call   803608 <__udivdi3>
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
  800848:	e8 cb 2e 00 00       	call   803718 <__umoddi3>
  80084d:	83 c4 10             	add    $0x10,%esp
  800850:	05 f4 3e 80 00       	add    $0x803ef4,%eax
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
  8009a3:	8b 04 85 18 3f 80 00 	mov    0x803f18(,%eax,4),%eax
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
  800a84:	8b 34 9d 60 3d 80 00 	mov    0x803d60(,%ebx,4),%esi
  800a8b:	85 f6                	test   %esi,%esi
  800a8d:	75 19                	jne    800aa8 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a8f:	53                   	push   %ebx
  800a90:	68 05 3f 80 00       	push   $0x803f05
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
  800aa9:	68 0e 3f 80 00       	push   $0x803f0e
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
  800ad6:	be 11 3f 80 00       	mov    $0x803f11,%esi
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
  8014fc:	68 70 40 80 00       	push   $0x804070
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
  8015cc:	e8 42 04 00 00       	call   801a13 <sys_allocate_chunk>
  8015d1:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8015d4:	a1 20 51 80 00       	mov    0x805120,%eax
  8015d9:	83 ec 0c             	sub    $0xc,%esp
  8015dc:	50                   	push   %eax
  8015dd:	e8 b7 0a 00 00       	call   802099 <initialize_MemBlocksList>
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
  80160a:	68 95 40 80 00       	push   $0x804095
  80160f:	6a 33                	push   $0x33
  801611:	68 b3 40 80 00       	push   $0x8040b3
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
  801689:	68 c0 40 80 00       	push   $0x8040c0
  80168e:	6a 34                	push   $0x34
  801690:	68 b3 40 80 00       	push   $0x8040b3
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
  8016fe:	68 e4 40 80 00       	push   $0x8040e4
  801703:	6a 46                	push   $0x46
  801705:	68 b3 40 80 00       	push   $0x8040b3
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
  80171a:	68 0c 41 80 00       	push   $0x80410c
  80171f:	6a 61                	push   $0x61
  801721:	68 b3 40 80 00       	push   $0x8040b3
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
  801740:	75 0a                	jne    80174c <smalloc+0x21>
  801742:	b8 00 00 00 00       	mov    $0x0,%eax
  801747:	e9 9e 00 00 00       	jmp    8017ea <smalloc+0xbf>
	//3-If the Kernel successfully creates the shared variable, return its virtual address
	//4-Else, return NULL



	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  80174c:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801753:	8b 55 0c             	mov    0xc(%ebp),%edx
  801756:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801759:	01 d0                	add    %edx,%eax
  80175b:	48                   	dec    %eax
  80175c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80175f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801762:	ba 00 00 00 00       	mov    $0x0,%edx
  801767:	f7 75 f0             	divl   -0x10(%ebp)
  80176a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80176d:	29 d0                	sub    %edx,%eax
  80176f:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801772:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801779:	e8 63 06 00 00       	call   801de1 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80177e:	85 c0                	test   %eax,%eax
  801780:	74 11                	je     801793 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  801782:	83 ec 0c             	sub    $0xc,%esp
  801785:	ff 75 e8             	pushl  -0x18(%ebp)
  801788:	e8 ce 0c 00 00       	call   80245b <alloc_block_FF>
  80178d:	83 c4 10             	add    $0x10,%esp
  801790:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  801793:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801797:	74 4c                	je     8017e5 <smalloc+0xba>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801799:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80179c:	8b 40 08             	mov    0x8(%eax),%eax
  80179f:	89 c2                	mov    %eax,%edx
  8017a1:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8017a5:	52                   	push   %edx
  8017a6:	50                   	push   %eax
  8017a7:	ff 75 0c             	pushl  0xc(%ebp)
  8017aa:	ff 75 08             	pushl  0x8(%ebp)
  8017ad:	e8 b4 03 00 00       	call   801b66 <sys_createSharedObject>
  8017b2:	83 c4 10             	add    $0x10,%esp
  8017b5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cprintf("Output is :  %d \n" , result);
  8017b8:	83 ec 08             	sub    $0x8,%esp
  8017bb:	ff 75 e0             	pushl  -0x20(%ebp)
  8017be:	68 2f 41 80 00       	push   $0x80412f
  8017c3:	e8 93 ef ff ff       	call   80075b <cprintf>
  8017c8:	83 c4 10             	add    $0x10,%esp
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  8017cb:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  8017cf:	74 14                	je     8017e5 <smalloc+0xba>
  8017d1:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  8017d5:	74 0e                	je     8017e5 <smalloc+0xba>
  8017d7:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  8017db:	74 08                	je     8017e5 <smalloc+0xba>
			return (void*) mem_block->sva;
  8017dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017e0:	8b 40 08             	mov    0x8(%eax),%eax
  8017e3:	eb 05                	jmp    8017ea <smalloc+0xbf>
	}
	return NULL;
  8017e5:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8017ea:	c9                   	leave  
  8017eb:	c3                   	ret    

008017ec <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8017ec:	55                   	push   %ebp
  8017ed:	89 e5                	mov    %esp,%ebp
  8017ef:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017f2:	e8 ee fc ff ff       	call   8014e5 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8017f7:	83 ec 04             	sub    $0x4,%esp
  8017fa:	68 44 41 80 00       	push   $0x804144
  8017ff:	68 ab 00 00 00       	push   $0xab
  801804:	68 b3 40 80 00       	push   $0x8040b3
  801809:	e8 99 ec ff ff       	call   8004a7 <_panic>

0080180e <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80180e:	55                   	push   %ebp
  80180f:	89 e5                	mov    %esp,%ebp
  801811:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801814:	e8 cc fc ff ff       	call   8014e5 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801819:	83 ec 04             	sub    $0x4,%esp
  80181c:	68 68 41 80 00       	push   $0x804168
  801821:	68 ef 00 00 00       	push   $0xef
  801826:	68 b3 40 80 00       	push   $0x8040b3
  80182b:	e8 77 ec ff ff       	call   8004a7 <_panic>

00801830 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801830:	55                   	push   %ebp
  801831:	89 e5                	mov    %esp,%ebp
  801833:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801836:	83 ec 04             	sub    $0x4,%esp
  801839:	68 90 41 80 00       	push   $0x804190
  80183e:	68 03 01 00 00       	push   $0x103
  801843:	68 b3 40 80 00       	push   $0x8040b3
  801848:	e8 5a ec ff ff       	call   8004a7 <_panic>

0080184d <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80184d:	55                   	push   %ebp
  80184e:	89 e5                	mov    %esp,%ebp
  801850:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801853:	83 ec 04             	sub    $0x4,%esp
  801856:	68 b4 41 80 00       	push   $0x8041b4
  80185b:	68 0e 01 00 00       	push   $0x10e
  801860:	68 b3 40 80 00       	push   $0x8040b3
  801865:	e8 3d ec ff ff       	call   8004a7 <_panic>

0080186a <shrink>:

}
void shrink(uint32 newSize)
{
  80186a:	55                   	push   %ebp
  80186b:	89 e5                	mov    %esp,%ebp
  80186d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801870:	83 ec 04             	sub    $0x4,%esp
  801873:	68 b4 41 80 00       	push   $0x8041b4
  801878:	68 13 01 00 00       	push   $0x113
  80187d:	68 b3 40 80 00       	push   $0x8040b3
  801882:	e8 20 ec ff ff       	call   8004a7 <_panic>

00801887 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801887:	55                   	push   %ebp
  801888:	89 e5                	mov    %esp,%ebp
  80188a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80188d:	83 ec 04             	sub    $0x4,%esp
  801890:	68 b4 41 80 00       	push   $0x8041b4
  801895:	68 18 01 00 00       	push   $0x118
  80189a:	68 b3 40 80 00       	push   $0x8040b3
  80189f:	e8 03 ec ff ff       	call   8004a7 <_panic>

008018a4 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8018a4:	55                   	push   %ebp
  8018a5:	89 e5                	mov    %esp,%ebp
  8018a7:	57                   	push   %edi
  8018a8:	56                   	push   %esi
  8018a9:	53                   	push   %ebx
  8018aa:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018b6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018b9:	8b 7d 18             	mov    0x18(%ebp),%edi
  8018bc:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8018bf:	cd 30                	int    $0x30
  8018c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8018c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018c7:	83 c4 10             	add    $0x10,%esp
  8018ca:	5b                   	pop    %ebx
  8018cb:	5e                   	pop    %esi
  8018cc:	5f                   	pop    %edi
  8018cd:	5d                   	pop    %ebp
  8018ce:	c3                   	ret    

008018cf <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8018cf:	55                   	push   %ebp
  8018d0:	89 e5                	mov    %esp,%ebp
  8018d2:	83 ec 04             	sub    $0x4,%esp
  8018d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8018d8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8018db:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018df:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e2:	6a 00                	push   $0x0
  8018e4:	6a 00                	push   $0x0
  8018e6:	52                   	push   %edx
  8018e7:	ff 75 0c             	pushl  0xc(%ebp)
  8018ea:	50                   	push   %eax
  8018eb:	6a 00                	push   $0x0
  8018ed:	e8 b2 ff ff ff       	call   8018a4 <syscall>
  8018f2:	83 c4 18             	add    $0x18,%esp
}
  8018f5:	90                   	nop
  8018f6:	c9                   	leave  
  8018f7:	c3                   	ret    

008018f8 <sys_cgetc>:

int
sys_cgetc(void)
{
  8018f8:	55                   	push   %ebp
  8018f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8018fb:	6a 00                	push   $0x0
  8018fd:	6a 00                	push   $0x0
  8018ff:	6a 00                	push   $0x0
  801901:	6a 00                	push   $0x0
  801903:	6a 00                	push   $0x0
  801905:	6a 01                	push   $0x1
  801907:	e8 98 ff ff ff       	call   8018a4 <syscall>
  80190c:	83 c4 18             	add    $0x18,%esp
}
  80190f:	c9                   	leave  
  801910:	c3                   	ret    

00801911 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801911:	55                   	push   %ebp
  801912:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801914:	8b 55 0c             	mov    0xc(%ebp),%edx
  801917:	8b 45 08             	mov    0x8(%ebp),%eax
  80191a:	6a 00                	push   $0x0
  80191c:	6a 00                	push   $0x0
  80191e:	6a 00                	push   $0x0
  801920:	52                   	push   %edx
  801921:	50                   	push   %eax
  801922:	6a 05                	push   $0x5
  801924:	e8 7b ff ff ff       	call   8018a4 <syscall>
  801929:	83 c4 18             	add    $0x18,%esp
}
  80192c:	c9                   	leave  
  80192d:	c3                   	ret    

0080192e <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80192e:	55                   	push   %ebp
  80192f:	89 e5                	mov    %esp,%ebp
  801931:	56                   	push   %esi
  801932:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801933:	8b 75 18             	mov    0x18(%ebp),%esi
  801936:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801939:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80193c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80193f:	8b 45 08             	mov    0x8(%ebp),%eax
  801942:	56                   	push   %esi
  801943:	53                   	push   %ebx
  801944:	51                   	push   %ecx
  801945:	52                   	push   %edx
  801946:	50                   	push   %eax
  801947:	6a 06                	push   $0x6
  801949:	e8 56 ff ff ff       	call   8018a4 <syscall>
  80194e:	83 c4 18             	add    $0x18,%esp
}
  801951:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801954:	5b                   	pop    %ebx
  801955:	5e                   	pop    %esi
  801956:	5d                   	pop    %ebp
  801957:	c3                   	ret    

00801958 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801958:	55                   	push   %ebp
  801959:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80195b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80195e:	8b 45 08             	mov    0x8(%ebp),%eax
  801961:	6a 00                	push   $0x0
  801963:	6a 00                	push   $0x0
  801965:	6a 00                	push   $0x0
  801967:	52                   	push   %edx
  801968:	50                   	push   %eax
  801969:	6a 07                	push   $0x7
  80196b:	e8 34 ff ff ff       	call   8018a4 <syscall>
  801970:	83 c4 18             	add    $0x18,%esp
}
  801973:	c9                   	leave  
  801974:	c3                   	ret    

00801975 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801975:	55                   	push   %ebp
  801976:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801978:	6a 00                	push   $0x0
  80197a:	6a 00                	push   $0x0
  80197c:	6a 00                	push   $0x0
  80197e:	ff 75 0c             	pushl  0xc(%ebp)
  801981:	ff 75 08             	pushl  0x8(%ebp)
  801984:	6a 08                	push   $0x8
  801986:	e8 19 ff ff ff       	call   8018a4 <syscall>
  80198b:	83 c4 18             	add    $0x18,%esp
}
  80198e:	c9                   	leave  
  80198f:	c3                   	ret    

00801990 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801990:	55                   	push   %ebp
  801991:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801993:	6a 00                	push   $0x0
  801995:	6a 00                	push   $0x0
  801997:	6a 00                	push   $0x0
  801999:	6a 00                	push   $0x0
  80199b:	6a 00                	push   $0x0
  80199d:	6a 09                	push   $0x9
  80199f:	e8 00 ff ff ff       	call   8018a4 <syscall>
  8019a4:	83 c4 18             	add    $0x18,%esp
}
  8019a7:	c9                   	leave  
  8019a8:	c3                   	ret    

008019a9 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8019a9:	55                   	push   %ebp
  8019aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8019ac:	6a 00                	push   $0x0
  8019ae:	6a 00                	push   $0x0
  8019b0:	6a 00                	push   $0x0
  8019b2:	6a 00                	push   $0x0
  8019b4:	6a 00                	push   $0x0
  8019b6:	6a 0a                	push   $0xa
  8019b8:	e8 e7 fe ff ff       	call   8018a4 <syscall>
  8019bd:	83 c4 18             	add    $0x18,%esp
}
  8019c0:	c9                   	leave  
  8019c1:	c3                   	ret    

008019c2 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8019c2:	55                   	push   %ebp
  8019c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8019c5:	6a 00                	push   $0x0
  8019c7:	6a 00                	push   $0x0
  8019c9:	6a 00                	push   $0x0
  8019cb:	6a 00                	push   $0x0
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 0b                	push   $0xb
  8019d1:	e8 ce fe ff ff       	call   8018a4 <syscall>
  8019d6:	83 c4 18             	add    $0x18,%esp
}
  8019d9:	c9                   	leave  
  8019da:	c3                   	ret    

008019db <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8019db:	55                   	push   %ebp
  8019dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 00                	push   $0x0
  8019e4:	ff 75 0c             	pushl  0xc(%ebp)
  8019e7:	ff 75 08             	pushl  0x8(%ebp)
  8019ea:	6a 0f                	push   $0xf
  8019ec:	e8 b3 fe ff ff       	call   8018a4 <syscall>
  8019f1:	83 c4 18             	add    $0x18,%esp
	return;
  8019f4:	90                   	nop
}
  8019f5:	c9                   	leave  
  8019f6:	c3                   	ret    

008019f7 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8019f7:	55                   	push   %ebp
  8019f8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8019fa:	6a 00                	push   $0x0
  8019fc:	6a 00                	push   $0x0
  8019fe:	6a 00                	push   $0x0
  801a00:	ff 75 0c             	pushl  0xc(%ebp)
  801a03:	ff 75 08             	pushl  0x8(%ebp)
  801a06:	6a 10                	push   $0x10
  801a08:	e8 97 fe ff ff       	call   8018a4 <syscall>
  801a0d:	83 c4 18             	add    $0x18,%esp
	return ;
  801a10:	90                   	nop
}
  801a11:	c9                   	leave  
  801a12:	c3                   	ret    

00801a13 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801a13:	55                   	push   %ebp
  801a14:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a16:	6a 00                	push   $0x0
  801a18:	6a 00                	push   $0x0
  801a1a:	ff 75 10             	pushl  0x10(%ebp)
  801a1d:	ff 75 0c             	pushl  0xc(%ebp)
  801a20:	ff 75 08             	pushl  0x8(%ebp)
  801a23:	6a 11                	push   $0x11
  801a25:	e8 7a fe ff ff       	call   8018a4 <syscall>
  801a2a:	83 c4 18             	add    $0x18,%esp
	return ;
  801a2d:	90                   	nop
}
  801a2e:	c9                   	leave  
  801a2f:	c3                   	ret    

00801a30 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a30:	55                   	push   %ebp
  801a31:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a33:	6a 00                	push   $0x0
  801a35:	6a 00                	push   $0x0
  801a37:	6a 00                	push   $0x0
  801a39:	6a 00                	push   $0x0
  801a3b:	6a 00                	push   $0x0
  801a3d:	6a 0c                	push   $0xc
  801a3f:	e8 60 fe ff ff       	call   8018a4 <syscall>
  801a44:	83 c4 18             	add    $0x18,%esp
}
  801a47:	c9                   	leave  
  801a48:	c3                   	ret    

00801a49 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a49:	55                   	push   %ebp
  801a4a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a4c:	6a 00                	push   $0x0
  801a4e:	6a 00                	push   $0x0
  801a50:	6a 00                	push   $0x0
  801a52:	6a 00                	push   $0x0
  801a54:	ff 75 08             	pushl  0x8(%ebp)
  801a57:	6a 0d                	push   $0xd
  801a59:	e8 46 fe ff ff       	call   8018a4 <syscall>
  801a5e:	83 c4 18             	add    $0x18,%esp
}
  801a61:	c9                   	leave  
  801a62:	c3                   	ret    

00801a63 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a63:	55                   	push   %ebp
  801a64:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a66:	6a 00                	push   $0x0
  801a68:	6a 00                	push   $0x0
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 00                	push   $0x0
  801a70:	6a 0e                	push   $0xe
  801a72:	e8 2d fe ff ff       	call   8018a4 <syscall>
  801a77:	83 c4 18             	add    $0x18,%esp
}
  801a7a:	90                   	nop
  801a7b:	c9                   	leave  
  801a7c:	c3                   	ret    

00801a7d <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801a7d:	55                   	push   %ebp
  801a7e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801a80:	6a 00                	push   $0x0
  801a82:	6a 00                	push   $0x0
  801a84:	6a 00                	push   $0x0
  801a86:	6a 00                	push   $0x0
  801a88:	6a 00                	push   $0x0
  801a8a:	6a 13                	push   $0x13
  801a8c:	e8 13 fe ff ff       	call   8018a4 <syscall>
  801a91:	83 c4 18             	add    $0x18,%esp
}
  801a94:	90                   	nop
  801a95:	c9                   	leave  
  801a96:	c3                   	ret    

00801a97 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801a97:	55                   	push   %ebp
  801a98:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 00                	push   $0x0
  801aa0:	6a 00                	push   $0x0
  801aa2:	6a 00                	push   $0x0
  801aa4:	6a 14                	push   $0x14
  801aa6:	e8 f9 fd ff ff       	call   8018a4 <syscall>
  801aab:	83 c4 18             	add    $0x18,%esp
}
  801aae:	90                   	nop
  801aaf:	c9                   	leave  
  801ab0:	c3                   	ret    

00801ab1 <sys_cputc>:


void
sys_cputc(const char c)
{
  801ab1:	55                   	push   %ebp
  801ab2:	89 e5                	mov    %esp,%ebp
  801ab4:	83 ec 04             	sub    $0x4,%esp
  801ab7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aba:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801abd:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ac1:	6a 00                	push   $0x0
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 00                	push   $0x0
  801ac9:	50                   	push   %eax
  801aca:	6a 15                	push   $0x15
  801acc:	e8 d3 fd ff ff       	call   8018a4 <syscall>
  801ad1:	83 c4 18             	add    $0x18,%esp
}
  801ad4:	90                   	nop
  801ad5:	c9                   	leave  
  801ad6:	c3                   	ret    

00801ad7 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801ad7:	55                   	push   %ebp
  801ad8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801ada:	6a 00                	push   $0x0
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	6a 00                	push   $0x0
  801ae2:	6a 00                	push   $0x0
  801ae4:	6a 16                	push   $0x16
  801ae6:	e8 b9 fd ff ff       	call   8018a4 <syscall>
  801aeb:	83 c4 18             	add    $0x18,%esp
}
  801aee:	90                   	nop
  801aef:	c9                   	leave  
  801af0:	c3                   	ret    

00801af1 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801af1:	55                   	push   %ebp
  801af2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801af4:	8b 45 08             	mov    0x8(%ebp),%eax
  801af7:	6a 00                	push   $0x0
  801af9:	6a 00                	push   $0x0
  801afb:	6a 00                	push   $0x0
  801afd:	ff 75 0c             	pushl  0xc(%ebp)
  801b00:	50                   	push   %eax
  801b01:	6a 17                	push   $0x17
  801b03:	e8 9c fd ff ff       	call   8018a4 <syscall>
  801b08:	83 c4 18             	add    $0x18,%esp
}
  801b0b:	c9                   	leave  
  801b0c:	c3                   	ret    

00801b0d <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801b0d:	55                   	push   %ebp
  801b0e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b10:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b13:	8b 45 08             	mov    0x8(%ebp),%eax
  801b16:	6a 00                	push   $0x0
  801b18:	6a 00                	push   $0x0
  801b1a:	6a 00                	push   $0x0
  801b1c:	52                   	push   %edx
  801b1d:	50                   	push   %eax
  801b1e:	6a 1a                	push   $0x1a
  801b20:	e8 7f fd ff ff       	call   8018a4 <syscall>
  801b25:	83 c4 18             	add    $0x18,%esp
}
  801b28:	c9                   	leave  
  801b29:	c3                   	ret    

00801b2a <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b2a:	55                   	push   %ebp
  801b2b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b2d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b30:	8b 45 08             	mov    0x8(%ebp),%eax
  801b33:	6a 00                	push   $0x0
  801b35:	6a 00                	push   $0x0
  801b37:	6a 00                	push   $0x0
  801b39:	52                   	push   %edx
  801b3a:	50                   	push   %eax
  801b3b:	6a 18                	push   $0x18
  801b3d:	e8 62 fd ff ff       	call   8018a4 <syscall>
  801b42:	83 c4 18             	add    $0x18,%esp
}
  801b45:	90                   	nop
  801b46:	c9                   	leave  
  801b47:	c3                   	ret    

00801b48 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b48:	55                   	push   %ebp
  801b49:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b4b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b51:	6a 00                	push   $0x0
  801b53:	6a 00                	push   $0x0
  801b55:	6a 00                	push   $0x0
  801b57:	52                   	push   %edx
  801b58:	50                   	push   %eax
  801b59:	6a 19                	push   $0x19
  801b5b:	e8 44 fd ff ff       	call   8018a4 <syscall>
  801b60:	83 c4 18             	add    $0x18,%esp
}
  801b63:	90                   	nop
  801b64:	c9                   	leave  
  801b65:	c3                   	ret    

00801b66 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b66:	55                   	push   %ebp
  801b67:	89 e5                	mov    %esp,%ebp
  801b69:	83 ec 04             	sub    $0x4,%esp
  801b6c:	8b 45 10             	mov    0x10(%ebp),%eax
  801b6f:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b72:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b75:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b79:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7c:	6a 00                	push   $0x0
  801b7e:	51                   	push   %ecx
  801b7f:	52                   	push   %edx
  801b80:	ff 75 0c             	pushl  0xc(%ebp)
  801b83:	50                   	push   %eax
  801b84:	6a 1b                	push   $0x1b
  801b86:	e8 19 fd ff ff       	call   8018a4 <syscall>
  801b8b:	83 c4 18             	add    $0x18,%esp
}
  801b8e:	c9                   	leave  
  801b8f:	c3                   	ret    

00801b90 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b90:	55                   	push   %ebp
  801b91:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b93:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b96:	8b 45 08             	mov    0x8(%ebp),%eax
  801b99:	6a 00                	push   $0x0
  801b9b:	6a 00                	push   $0x0
  801b9d:	6a 00                	push   $0x0
  801b9f:	52                   	push   %edx
  801ba0:	50                   	push   %eax
  801ba1:	6a 1c                	push   $0x1c
  801ba3:	e8 fc fc ff ff       	call   8018a4 <syscall>
  801ba8:	83 c4 18             	add    $0x18,%esp
}
  801bab:	c9                   	leave  
  801bac:	c3                   	ret    

00801bad <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801bad:	55                   	push   %ebp
  801bae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801bb0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bb3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bb6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb9:	6a 00                	push   $0x0
  801bbb:	6a 00                	push   $0x0
  801bbd:	51                   	push   %ecx
  801bbe:	52                   	push   %edx
  801bbf:	50                   	push   %eax
  801bc0:	6a 1d                	push   $0x1d
  801bc2:	e8 dd fc ff ff       	call   8018a4 <syscall>
  801bc7:	83 c4 18             	add    $0x18,%esp
}
  801bca:	c9                   	leave  
  801bcb:	c3                   	ret    

00801bcc <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801bcc:	55                   	push   %ebp
  801bcd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801bcf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd5:	6a 00                	push   $0x0
  801bd7:	6a 00                	push   $0x0
  801bd9:	6a 00                	push   $0x0
  801bdb:	52                   	push   %edx
  801bdc:	50                   	push   %eax
  801bdd:	6a 1e                	push   $0x1e
  801bdf:	e8 c0 fc ff ff       	call   8018a4 <syscall>
  801be4:	83 c4 18             	add    $0x18,%esp
}
  801be7:	c9                   	leave  
  801be8:	c3                   	ret    

00801be9 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801be9:	55                   	push   %ebp
  801bea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801bec:	6a 00                	push   $0x0
  801bee:	6a 00                	push   $0x0
  801bf0:	6a 00                	push   $0x0
  801bf2:	6a 00                	push   $0x0
  801bf4:	6a 00                	push   $0x0
  801bf6:	6a 1f                	push   $0x1f
  801bf8:	e8 a7 fc ff ff       	call   8018a4 <syscall>
  801bfd:	83 c4 18             	add    $0x18,%esp
}
  801c00:	c9                   	leave  
  801c01:	c3                   	ret    

00801c02 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c02:	55                   	push   %ebp
  801c03:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c05:	8b 45 08             	mov    0x8(%ebp),%eax
  801c08:	6a 00                	push   $0x0
  801c0a:	ff 75 14             	pushl  0x14(%ebp)
  801c0d:	ff 75 10             	pushl  0x10(%ebp)
  801c10:	ff 75 0c             	pushl  0xc(%ebp)
  801c13:	50                   	push   %eax
  801c14:	6a 20                	push   $0x20
  801c16:	e8 89 fc ff ff       	call   8018a4 <syscall>
  801c1b:	83 c4 18             	add    $0x18,%esp
}
  801c1e:	c9                   	leave  
  801c1f:	c3                   	ret    

00801c20 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801c20:	55                   	push   %ebp
  801c21:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c23:	8b 45 08             	mov    0x8(%ebp),%eax
  801c26:	6a 00                	push   $0x0
  801c28:	6a 00                	push   $0x0
  801c2a:	6a 00                	push   $0x0
  801c2c:	6a 00                	push   $0x0
  801c2e:	50                   	push   %eax
  801c2f:	6a 21                	push   $0x21
  801c31:	e8 6e fc ff ff       	call   8018a4 <syscall>
  801c36:	83 c4 18             	add    $0x18,%esp
}
  801c39:	90                   	nop
  801c3a:	c9                   	leave  
  801c3b:	c3                   	ret    

00801c3c <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c3c:	55                   	push   %ebp
  801c3d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c42:	6a 00                	push   $0x0
  801c44:	6a 00                	push   $0x0
  801c46:	6a 00                	push   $0x0
  801c48:	6a 00                	push   $0x0
  801c4a:	50                   	push   %eax
  801c4b:	6a 22                	push   $0x22
  801c4d:	e8 52 fc ff ff       	call   8018a4 <syscall>
  801c52:	83 c4 18             	add    $0x18,%esp
}
  801c55:	c9                   	leave  
  801c56:	c3                   	ret    

00801c57 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c57:	55                   	push   %ebp
  801c58:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c5a:	6a 00                	push   $0x0
  801c5c:	6a 00                	push   $0x0
  801c5e:	6a 00                	push   $0x0
  801c60:	6a 00                	push   $0x0
  801c62:	6a 00                	push   $0x0
  801c64:	6a 02                	push   $0x2
  801c66:	e8 39 fc ff ff       	call   8018a4 <syscall>
  801c6b:	83 c4 18             	add    $0x18,%esp
}
  801c6e:	c9                   	leave  
  801c6f:	c3                   	ret    

00801c70 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c70:	55                   	push   %ebp
  801c71:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c73:	6a 00                	push   $0x0
  801c75:	6a 00                	push   $0x0
  801c77:	6a 00                	push   $0x0
  801c79:	6a 00                	push   $0x0
  801c7b:	6a 00                	push   $0x0
  801c7d:	6a 03                	push   $0x3
  801c7f:	e8 20 fc ff ff       	call   8018a4 <syscall>
  801c84:	83 c4 18             	add    $0x18,%esp
}
  801c87:	c9                   	leave  
  801c88:	c3                   	ret    

00801c89 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c89:	55                   	push   %ebp
  801c8a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 00                	push   $0x0
  801c90:	6a 00                	push   $0x0
  801c92:	6a 00                	push   $0x0
  801c94:	6a 00                	push   $0x0
  801c96:	6a 04                	push   $0x4
  801c98:	e8 07 fc ff ff       	call   8018a4 <syscall>
  801c9d:	83 c4 18             	add    $0x18,%esp
}
  801ca0:	c9                   	leave  
  801ca1:	c3                   	ret    

00801ca2 <sys_exit_env>:


void sys_exit_env(void)
{
  801ca2:	55                   	push   %ebp
  801ca3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801ca5:	6a 00                	push   $0x0
  801ca7:	6a 00                	push   $0x0
  801ca9:	6a 00                	push   $0x0
  801cab:	6a 00                	push   $0x0
  801cad:	6a 00                	push   $0x0
  801caf:	6a 23                	push   $0x23
  801cb1:	e8 ee fb ff ff       	call   8018a4 <syscall>
  801cb6:	83 c4 18             	add    $0x18,%esp
}
  801cb9:	90                   	nop
  801cba:	c9                   	leave  
  801cbb:	c3                   	ret    

00801cbc <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801cbc:	55                   	push   %ebp
  801cbd:	89 e5                	mov    %esp,%ebp
  801cbf:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801cc2:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cc5:	8d 50 04             	lea    0x4(%eax),%edx
  801cc8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ccb:	6a 00                	push   $0x0
  801ccd:	6a 00                	push   $0x0
  801ccf:	6a 00                	push   $0x0
  801cd1:	52                   	push   %edx
  801cd2:	50                   	push   %eax
  801cd3:	6a 24                	push   $0x24
  801cd5:	e8 ca fb ff ff       	call   8018a4 <syscall>
  801cda:	83 c4 18             	add    $0x18,%esp
	return result;
  801cdd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ce0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ce3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ce6:	89 01                	mov    %eax,(%ecx)
  801ce8:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801ceb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cee:	c9                   	leave  
  801cef:	c2 04 00             	ret    $0x4

00801cf2 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801cf2:	55                   	push   %ebp
  801cf3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801cf5:	6a 00                	push   $0x0
  801cf7:	6a 00                	push   $0x0
  801cf9:	ff 75 10             	pushl  0x10(%ebp)
  801cfc:	ff 75 0c             	pushl  0xc(%ebp)
  801cff:	ff 75 08             	pushl  0x8(%ebp)
  801d02:	6a 12                	push   $0x12
  801d04:	e8 9b fb ff ff       	call   8018a4 <syscall>
  801d09:	83 c4 18             	add    $0x18,%esp
	return ;
  801d0c:	90                   	nop
}
  801d0d:	c9                   	leave  
  801d0e:	c3                   	ret    

00801d0f <sys_rcr2>:
uint32 sys_rcr2()
{
  801d0f:	55                   	push   %ebp
  801d10:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d12:	6a 00                	push   $0x0
  801d14:	6a 00                	push   $0x0
  801d16:	6a 00                	push   $0x0
  801d18:	6a 00                	push   $0x0
  801d1a:	6a 00                	push   $0x0
  801d1c:	6a 25                	push   $0x25
  801d1e:	e8 81 fb ff ff       	call   8018a4 <syscall>
  801d23:	83 c4 18             	add    $0x18,%esp
}
  801d26:	c9                   	leave  
  801d27:	c3                   	ret    

00801d28 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801d28:	55                   	push   %ebp
  801d29:	89 e5                	mov    %esp,%ebp
  801d2b:	83 ec 04             	sub    $0x4,%esp
  801d2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d31:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d34:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d38:	6a 00                	push   $0x0
  801d3a:	6a 00                	push   $0x0
  801d3c:	6a 00                	push   $0x0
  801d3e:	6a 00                	push   $0x0
  801d40:	50                   	push   %eax
  801d41:	6a 26                	push   $0x26
  801d43:	e8 5c fb ff ff       	call   8018a4 <syscall>
  801d48:	83 c4 18             	add    $0x18,%esp
	return ;
  801d4b:	90                   	nop
}
  801d4c:	c9                   	leave  
  801d4d:	c3                   	ret    

00801d4e <rsttst>:
void rsttst()
{
  801d4e:	55                   	push   %ebp
  801d4f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d51:	6a 00                	push   $0x0
  801d53:	6a 00                	push   $0x0
  801d55:	6a 00                	push   $0x0
  801d57:	6a 00                	push   $0x0
  801d59:	6a 00                	push   $0x0
  801d5b:	6a 28                	push   $0x28
  801d5d:	e8 42 fb ff ff       	call   8018a4 <syscall>
  801d62:	83 c4 18             	add    $0x18,%esp
	return ;
  801d65:	90                   	nop
}
  801d66:	c9                   	leave  
  801d67:	c3                   	ret    

00801d68 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d68:	55                   	push   %ebp
  801d69:	89 e5                	mov    %esp,%ebp
  801d6b:	83 ec 04             	sub    $0x4,%esp
  801d6e:	8b 45 14             	mov    0x14(%ebp),%eax
  801d71:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d74:	8b 55 18             	mov    0x18(%ebp),%edx
  801d77:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d7b:	52                   	push   %edx
  801d7c:	50                   	push   %eax
  801d7d:	ff 75 10             	pushl  0x10(%ebp)
  801d80:	ff 75 0c             	pushl  0xc(%ebp)
  801d83:	ff 75 08             	pushl  0x8(%ebp)
  801d86:	6a 27                	push   $0x27
  801d88:	e8 17 fb ff ff       	call   8018a4 <syscall>
  801d8d:	83 c4 18             	add    $0x18,%esp
	return ;
  801d90:	90                   	nop
}
  801d91:	c9                   	leave  
  801d92:	c3                   	ret    

00801d93 <chktst>:
void chktst(uint32 n)
{
  801d93:	55                   	push   %ebp
  801d94:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d96:	6a 00                	push   $0x0
  801d98:	6a 00                	push   $0x0
  801d9a:	6a 00                	push   $0x0
  801d9c:	6a 00                	push   $0x0
  801d9e:	ff 75 08             	pushl  0x8(%ebp)
  801da1:	6a 29                	push   $0x29
  801da3:	e8 fc fa ff ff       	call   8018a4 <syscall>
  801da8:	83 c4 18             	add    $0x18,%esp
	return ;
  801dab:	90                   	nop
}
  801dac:	c9                   	leave  
  801dad:	c3                   	ret    

00801dae <inctst>:

void inctst()
{
  801dae:	55                   	push   %ebp
  801daf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801db1:	6a 00                	push   $0x0
  801db3:	6a 00                	push   $0x0
  801db5:	6a 00                	push   $0x0
  801db7:	6a 00                	push   $0x0
  801db9:	6a 00                	push   $0x0
  801dbb:	6a 2a                	push   $0x2a
  801dbd:	e8 e2 fa ff ff       	call   8018a4 <syscall>
  801dc2:	83 c4 18             	add    $0x18,%esp
	return ;
  801dc5:	90                   	nop
}
  801dc6:	c9                   	leave  
  801dc7:	c3                   	ret    

00801dc8 <gettst>:
uint32 gettst()
{
  801dc8:	55                   	push   %ebp
  801dc9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801dcb:	6a 00                	push   $0x0
  801dcd:	6a 00                	push   $0x0
  801dcf:	6a 00                	push   $0x0
  801dd1:	6a 00                	push   $0x0
  801dd3:	6a 00                	push   $0x0
  801dd5:	6a 2b                	push   $0x2b
  801dd7:	e8 c8 fa ff ff       	call   8018a4 <syscall>
  801ddc:	83 c4 18             	add    $0x18,%esp
}
  801ddf:	c9                   	leave  
  801de0:	c3                   	ret    

00801de1 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801de1:	55                   	push   %ebp
  801de2:	89 e5                	mov    %esp,%ebp
  801de4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801de7:	6a 00                	push   $0x0
  801de9:	6a 00                	push   $0x0
  801deb:	6a 00                	push   $0x0
  801ded:	6a 00                	push   $0x0
  801def:	6a 00                	push   $0x0
  801df1:	6a 2c                	push   $0x2c
  801df3:	e8 ac fa ff ff       	call   8018a4 <syscall>
  801df8:	83 c4 18             	add    $0x18,%esp
  801dfb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801dfe:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e02:	75 07                	jne    801e0b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e04:	b8 01 00 00 00       	mov    $0x1,%eax
  801e09:	eb 05                	jmp    801e10 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e0b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e10:	c9                   	leave  
  801e11:	c3                   	ret    

00801e12 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e12:	55                   	push   %ebp
  801e13:	89 e5                	mov    %esp,%ebp
  801e15:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e18:	6a 00                	push   $0x0
  801e1a:	6a 00                	push   $0x0
  801e1c:	6a 00                	push   $0x0
  801e1e:	6a 00                	push   $0x0
  801e20:	6a 00                	push   $0x0
  801e22:	6a 2c                	push   $0x2c
  801e24:	e8 7b fa ff ff       	call   8018a4 <syscall>
  801e29:	83 c4 18             	add    $0x18,%esp
  801e2c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e2f:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e33:	75 07                	jne    801e3c <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e35:	b8 01 00 00 00       	mov    $0x1,%eax
  801e3a:	eb 05                	jmp    801e41 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e3c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e41:	c9                   	leave  
  801e42:	c3                   	ret    

00801e43 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e43:	55                   	push   %ebp
  801e44:	89 e5                	mov    %esp,%ebp
  801e46:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e49:	6a 00                	push   $0x0
  801e4b:	6a 00                	push   $0x0
  801e4d:	6a 00                	push   $0x0
  801e4f:	6a 00                	push   $0x0
  801e51:	6a 00                	push   $0x0
  801e53:	6a 2c                	push   $0x2c
  801e55:	e8 4a fa ff ff       	call   8018a4 <syscall>
  801e5a:	83 c4 18             	add    $0x18,%esp
  801e5d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e60:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e64:	75 07                	jne    801e6d <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e66:	b8 01 00 00 00       	mov    $0x1,%eax
  801e6b:	eb 05                	jmp    801e72 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e6d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e72:	c9                   	leave  
  801e73:	c3                   	ret    

00801e74 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e74:	55                   	push   %ebp
  801e75:	89 e5                	mov    %esp,%ebp
  801e77:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e7a:	6a 00                	push   $0x0
  801e7c:	6a 00                	push   $0x0
  801e7e:	6a 00                	push   $0x0
  801e80:	6a 00                	push   $0x0
  801e82:	6a 00                	push   $0x0
  801e84:	6a 2c                	push   $0x2c
  801e86:	e8 19 fa ff ff       	call   8018a4 <syscall>
  801e8b:	83 c4 18             	add    $0x18,%esp
  801e8e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e91:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e95:	75 07                	jne    801e9e <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e97:	b8 01 00 00 00       	mov    $0x1,%eax
  801e9c:	eb 05                	jmp    801ea3 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e9e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ea3:	c9                   	leave  
  801ea4:	c3                   	ret    

00801ea5 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801ea5:	55                   	push   %ebp
  801ea6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801ea8:	6a 00                	push   $0x0
  801eaa:	6a 00                	push   $0x0
  801eac:	6a 00                	push   $0x0
  801eae:	6a 00                	push   $0x0
  801eb0:	ff 75 08             	pushl  0x8(%ebp)
  801eb3:	6a 2d                	push   $0x2d
  801eb5:	e8 ea f9 ff ff       	call   8018a4 <syscall>
  801eba:	83 c4 18             	add    $0x18,%esp
	return ;
  801ebd:	90                   	nop
}
  801ebe:	c9                   	leave  
  801ebf:	c3                   	ret    

00801ec0 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801ec0:	55                   	push   %ebp
  801ec1:	89 e5                	mov    %esp,%ebp
  801ec3:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801ec4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ec7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801eca:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ecd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed0:	6a 00                	push   $0x0
  801ed2:	53                   	push   %ebx
  801ed3:	51                   	push   %ecx
  801ed4:	52                   	push   %edx
  801ed5:	50                   	push   %eax
  801ed6:	6a 2e                	push   $0x2e
  801ed8:	e8 c7 f9 ff ff       	call   8018a4 <syscall>
  801edd:	83 c4 18             	add    $0x18,%esp
}
  801ee0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ee3:	c9                   	leave  
  801ee4:	c3                   	ret    

00801ee5 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ee5:	55                   	push   %ebp
  801ee6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801ee8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eeb:	8b 45 08             	mov    0x8(%ebp),%eax
  801eee:	6a 00                	push   $0x0
  801ef0:	6a 00                	push   $0x0
  801ef2:	6a 00                	push   $0x0
  801ef4:	52                   	push   %edx
  801ef5:	50                   	push   %eax
  801ef6:	6a 2f                	push   $0x2f
  801ef8:	e8 a7 f9 ff ff       	call   8018a4 <syscall>
  801efd:	83 c4 18             	add    $0x18,%esp
}
  801f00:	c9                   	leave  
  801f01:	c3                   	ret    

00801f02 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801f02:	55                   	push   %ebp
  801f03:	89 e5                	mov    %esp,%ebp
  801f05:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801f08:	83 ec 0c             	sub    $0xc,%esp
  801f0b:	68 c4 41 80 00       	push   $0x8041c4
  801f10:	e8 46 e8 ff ff       	call   80075b <cprintf>
  801f15:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801f18:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801f1f:	83 ec 0c             	sub    $0xc,%esp
  801f22:	68 f0 41 80 00       	push   $0x8041f0
  801f27:	e8 2f e8 ff ff       	call   80075b <cprintf>
  801f2c:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801f2f:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f33:	a1 38 51 80 00       	mov    0x805138,%eax
  801f38:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f3b:	eb 56                	jmp    801f93 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f3d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f41:	74 1c                	je     801f5f <print_mem_block_lists+0x5d>
  801f43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f46:	8b 50 08             	mov    0x8(%eax),%edx
  801f49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f4c:	8b 48 08             	mov    0x8(%eax),%ecx
  801f4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f52:	8b 40 0c             	mov    0xc(%eax),%eax
  801f55:	01 c8                	add    %ecx,%eax
  801f57:	39 c2                	cmp    %eax,%edx
  801f59:	73 04                	jae    801f5f <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801f5b:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f62:	8b 50 08             	mov    0x8(%eax),%edx
  801f65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f68:	8b 40 0c             	mov    0xc(%eax),%eax
  801f6b:	01 c2                	add    %eax,%edx
  801f6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f70:	8b 40 08             	mov    0x8(%eax),%eax
  801f73:	83 ec 04             	sub    $0x4,%esp
  801f76:	52                   	push   %edx
  801f77:	50                   	push   %eax
  801f78:	68 05 42 80 00       	push   $0x804205
  801f7d:	e8 d9 e7 ff ff       	call   80075b <cprintf>
  801f82:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f88:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f8b:	a1 40 51 80 00       	mov    0x805140,%eax
  801f90:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f93:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f97:	74 07                	je     801fa0 <print_mem_block_lists+0x9e>
  801f99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f9c:	8b 00                	mov    (%eax),%eax
  801f9e:	eb 05                	jmp    801fa5 <print_mem_block_lists+0xa3>
  801fa0:	b8 00 00 00 00       	mov    $0x0,%eax
  801fa5:	a3 40 51 80 00       	mov    %eax,0x805140
  801faa:	a1 40 51 80 00       	mov    0x805140,%eax
  801faf:	85 c0                	test   %eax,%eax
  801fb1:	75 8a                	jne    801f3d <print_mem_block_lists+0x3b>
  801fb3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fb7:	75 84                	jne    801f3d <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801fb9:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801fbd:	75 10                	jne    801fcf <print_mem_block_lists+0xcd>
  801fbf:	83 ec 0c             	sub    $0xc,%esp
  801fc2:	68 14 42 80 00       	push   $0x804214
  801fc7:	e8 8f e7 ff ff       	call   80075b <cprintf>
  801fcc:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801fcf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801fd6:	83 ec 0c             	sub    $0xc,%esp
  801fd9:	68 38 42 80 00       	push   $0x804238
  801fde:	e8 78 e7 ff ff       	call   80075b <cprintf>
  801fe3:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801fe6:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801fea:	a1 40 50 80 00       	mov    0x805040,%eax
  801fef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ff2:	eb 56                	jmp    80204a <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801ff4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ff8:	74 1c                	je     802016 <print_mem_block_lists+0x114>
  801ffa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ffd:	8b 50 08             	mov    0x8(%eax),%edx
  802000:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802003:	8b 48 08             	mov    0x8(%eax),%ecx
  802006:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802009:	8b 40 0c             	mov    0xc(%eax),%eax
  80200c:	01 c8                	add    %ecx,%eax
  80200e:	39 c2                	cmp    %eax,%edx
  802010:	73 04                	jae    802016 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802012:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802016:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802019:	8b 50 08             	mov    0x8(%eax),%edx
  80201c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80201f:	8b 40 0c             	mov    0xc(%eax),%eax
  802022:	01 c2                	add    %eax,%edx
  802024:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802027:	8b 40 08             	mov    0x8(%eax),%eax
  80202a:	83 ec 04             	sub    $0x4,%esp
  80202d:	52                   	push   %edx
  80202e:	50                   	push   %eax
  80202f:	68 05 42 80 00       	push   $0x804205
  802034:	e8 22 e7 ff ff       	call   80075b <cprintf>
  802039:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80203c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80203f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802042:	a1 48 50 80 00       	mov    0x805048,%eax
  802047:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80204a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80204e:	74 07                	je     802057 <print_mem_block_lists+0x155>
  802050:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802053:	8b 00                	mov    (%eax),%eax
  802055:	eb 05                	jmp    80205c <print_mem_block_lists+0x15a>
  802057:	b8 00 00 00 00       	mov    $0x0,%eax
  80205c:	a3 48 50 80 00       	mov    %eax,0x805048
  802061:	a1 48 50 80 00       	mov    0x805048,%eax
  802066:	85 c0                	test   %eax,%eax
  802068:	75 8a                	jne    801ff4 <print_mem_block_lists+0xf2>
  80206a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80206e:	75 84                	jne    801ff4 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802070:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802074:	75 10                	jne    802086 <print_mem_block_lists+0x184>
  802076:	83 ec 0c             	sub    $0xc,%esp
  802079:	68 50 42 80 00       	push   $0x804250
  80207e:	e8 d8 e6 ff ff       	call   80075b <cprintf>
  802083:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802086:	83 ec 0c             	sub    $0xc,%esp
  802089:	68 c4 41 80 00       	push   $0x8041c4
  80208e:	e8 c8 e6 ff ff       	call   80075b <cprintf>
  802093:	83 c4 10             	add    $0x10,%esp

}
  802096:	90                   	nop
  802097:	c9                   	leave  
  802098:	c3                   	ret    

00802099 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802099:	55                   	push   %ebp
  80209a:	89 e5                	mov    %esp,%ebp
  80209c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  80209f:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8020a6:	00 00 00 
  8020a9:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8020b0:	00 00 00 
  8020b3:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8020ba:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  8020bd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8020c4:	e9 9e 00 00 00       	jmp    802167 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  8020c9:	a1 50 50 80 00       	mov    0x805050,%eax
  8020ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020d1:	c1 e2 04             	shl    $0x4,%edx
  8020d4:	01 d0                	add    %edx,%eax
  8020d6:	85 c0                	test   %eax,%eax
  8020d8:	75 14                	jne    8020ee <initialize_MemBlocksList+0x55>
  8020da:	83 ec 04             	sub    $0x4,%esp
  8020dd:	68 78 42 80 00       	push   $0x804278
  8020e2:	6a 46                	push   $0x46
  8020e4:	68 9b 42 80 00       	push   $0x80429b
  8020e9:	e8 b9 e3 ff ff       	call   8004a7 <_panic>
  8020ee:	a1 50 50 80 00       	mov    0x805050,%eax
  8020f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020f6:	c1 e2 04             	shl    $0x4,%edx
  8020f9:	01 d0                	add    %edx,%eax
  8020fb:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802101:	89 10                	mov    %edx,(%eax)
  802103:	8b 00                	mov    (%eax),%eax
  802105:	85 c0                	test   %eax,%eax
  802107:	74 18                	je     802121 <initialize_MemBlocksList+0x88>
  802109:	a1 48 51 80 00       	mov    0x805148,%eax
  80210e:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802114:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802117:	c1 e1 04             	shl    $0x4,%ecx
  80211a:	01 ca                	add    %ecx,%edx
  80211c:	89 50 04             	mov    %edx,0x4(%eax)
  80211f:	eb 12                	jmp    802133 <initialize_MemBlocksList+0x9a>
  802121:	a1 50 50 80 00       	mov    0x805050,%eax
  802126:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802129:	c1 e2 04             	shl    $0x4,%edx
  80212c:	01 d0                	add    %edx,%eax
  80212e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802133:	a1 50 50 80 00       	mov    0x805050,%eax
  802138:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80213b:	c1 e2 04             	shl    $0x4,%edx
  80213e:	01 d0                	add    %edx,%eax
  802140:	a3 48 51 80 00       	mov    %eax,0x805148
  802145:	a1 50 50 80 00       	mov    0x805050,%eax
  80214a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80214d:	c1 e2 04             	shl    $0x4,%edx
  802150:	01 d0                	add    %edx,%eax
  802152:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802159:	a1 54 51 80 00       	mov    0x805154,%eax
  80215e:	40                   	inc    %eax
  80215f:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802164:	ff 45 f4             	incl   -0xc(%ebp)
  802167:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80216a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80216d:	0f 82 56 ff ff ff    	jb     8020c9 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802173:	90                   	nop
  802174:	c9                   	leave  
  802175:	c3                   	ret    

00802176 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802176:	55                   	push   %ebp
  802177:	89 e5                	mov    %esp,%ebp
  802179:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80217c:	8b 45 08             	mov    0x8(%ebp),%eax
  80217f:	8b 00                	mov    (%eax),%eax
  802181:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802184:	eb 19                	jmp    80219f <find_block+0x29>
	{
		if(va==point->sva)
  802186:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802189:	8b 40 08             	mov    0x8(%eax),%eax
  80218c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80218f:	75 05                	jne    802196 <find_block+0x20>
		   return point;
  802191:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802194:	eb 36                	jmp    8021cc <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802196:	8b 45 08             	mov    0x8(%ebp),%eax
  802199:	8b 40 08             	mov    0x8(%eax),%eax
  80219c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80219f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021a3:	74 07                	je     8021ac <find_block+0x36>
  8021a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021a8:	8b 00                	mov    (%eax),%eax
  8021aa:	eb 05                	jmp    8021b1 <find_block+0x3b>
  8021ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8021b1:	8b 55 08             	mov    0x8(%ebp),%edx
  8021b4:	89 42 08             	mov    %eax,0x8(%edx)
  8021b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ba:	8b 40 08             	mov    0x8(%eax),%eax
  8021bd:	85 c0                	test   %eax,%eax
  8021bf:	75 c5                	jne    802186 <find_block+0x10>
  8021c1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021c5:	75 bf                	jne    802186 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  8021c7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021cc:	c9                   	leave  
  8021cd:	c3                   	ret    

008021ce <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8021ce:	55                   	push   %ebp
  8021cf:	89 e5                	mov    %esp,%ebp
  8021d1:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  8021d4:	a1 40 50 80 00       	mov    0x805040,%eax
  8021d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  8021dc:	a1 44 50 80 00       	mov    0x805044,%eax
  8021e1:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8021e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021e7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8021ea:	74 24                	je     802210 <insert_sorted_allocList+0x42>
  8021ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ef:	8b 50 08             	mov    0x8(%eax),%edx
  8021f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021f5:	8b 40 08             	mov    0x8(%eax),%eax
  8021f8:	39 c2                	cmp    %eax,%edx
  8021fa:	76 14                	jbe    802210 <insert_sorted_allocList+0x42>
  8021fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ff:	8b 50 08             	mov    0x8(%eax),%edx
  802202:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802205:	8b 40 08             	mov    0x8(%eax),%eax
  802208:	39 c2                	cmp    %eax,%edx
  80220a:	0f 82 60 01 00 00    	jb     802370 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802210:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802214:	75 65                	jne    80227b <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802216:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80221a:	75 14                	jne    802230 <insert_sorted_allocList+0x62>
  80221c:	83 ec 04             	sub    $0x4,%esp
  80221f:	68 78 42 80 00       	push   $0x804278
  802224:	6a 6b                	push   $0x6b
  802226:	68 9b 42 80 00       	push   $0x80429b
  80222b:	e8 77 e2 ff ff       	call   8004a7 <_panic>
  802230:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802236:	8b 45 08             	mov    0x8(%ebp),%eax
  802239:	89 10                	mov    %edx,(%eax)
  80223b:	8b 45 08             	mov    0x8(%ebp),%eax
  80223e:	8b 00                	mov    (%eax),%eax
  802240:	85 c0                	test   %eax,%eax
  802242:	74 0d                	je     802251 <insert_sorted_allocList+0x83>
  802244:	a1 40 50 80 00       	mov    0x805040,%eax
  802249:	8b 55 08             	mov    0x8(%ebp),%edx
  80224c:	89 50 04             	mov    %edx,0x4(%eax)
  80224f:	eb 08                	jmp    802259 <insert_sorted_allocList+0x8b>
  802251:	8b 45 08             	mov    0x8(%ebp),%eax
  802254:	a3 44 50 80 00       	mov    %eax,0x805044
  802259:	8b 45 08             	mov    0x8(%ebp),%eax
  80225c:	a3 40 50 80 00       	mov    %eax,0x805040
  802261:	8b 45 08             	mov    0x8(%ebp),%eax
  802264:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80226b:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802270:	40                   	inc    %eax
  802271:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802276:	e9 dc 01 00 00       	jmp    802457 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  80227b:	8b 45 08             	mov    0x8(%ebp),%eax
  80227e:	8b 50 08             	mov    0x8(%eax),%edx
  802281:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802284:	8b 40 08             	mov    0x8(%eax),%eax
  802287:	39 c2                	cmp    %eax,%edx
  802289:	77 6c                	ja     8022f7 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  80228b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80228f:	74 06                	je     802297 <insert_sorted_allocList+0xc9>
  802291:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802295:	75 14                	jne    8022ab <insert_sorted_allocList+0xdd>
  802297:	83 ec 04             	sub    $0x4,%esp
  80229a:	68 b4 42 80 00       	push   $0x8042b4
  80229f:	6a 6f                	push   $0x6f
  8022a1:	68 9b 42 80 00       	push   $0x80429b
  8022a6:	e8 fc e1 ff ff       	call   8004a7 <_panic>
  8022ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022ae:	8b 50 04             	mov    0x4(%eax),%edx
  8022b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b4:	89 50 04             	mov    %edx,0x4(%eax)
  8022b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ba:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022bd:	89 10                	mov    %edx,(%eax)
  8022bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022c2:	8b 40 04             	mov    0x4(%eax),%eax
  8022c5:	85 c0                	test   %eax,%eax
  8022c7:	74 0d                	je     8022d6 <insert_sorted_allocList+0x108>
  8022c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022cc:	8b 40 04             	mov    0x4(%eax),%eax
  8022cf:	8b 55 08             	mov    0x8(%ebp),%edx
  8022d2:	89 10                	mov    %edx,(%eax)
  8022d4:	eb 08                	jmp    8022de <insert_sorted_allocList+0x110>
  8022d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d9:	a3 40 50 80 00       	mov    %eax,0x805040
  8022de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8022e4:	89 50 04             	mov    %edx,0x4(%eax)
  8022e7:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8022ec:	40                   	inc    %eax
  8022ed:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8022f2:	e9 60 01 00 00       	jmp    802457 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8022f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fa:	8b 50 08             	mov    0x8(%eax),%edx
  8022fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802300:	8b 40 08             	mov    0x8(%eax),%eax
  802303:	39 c2                	cmp    %eax,%edx
  802305:	0f 82 4c 01 00 00    	jb     802457 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  80230b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80230f:	75 14                	jne    802325 <insert_sorted_allocList+0x157>
  802311:	83 ec 04             	sub    $0x4,%esp
  802314:	68 ec 42 80 00       	push   $0x8042ec
  802319:	6a 73                	push   $0x73
  80231b:	68 9b 42 80 00       	push   $0x80429b
  802320:	e8 82 e1 ff ff       	call   8004a7 <_panic>
  802325:	8b 15 44 50 80 00    	mov    0x805044,%edx
  80232b:	8b 45 08             	mov    0x8(%ebp),%eax
  80232e:	89 50 04             	mov    %edx,0x4(%eax)
  802331:	8b 45 08             	mov    0x8(%ebp),%eax
  802334:	8b 40 04             	mov    0x4(%eax),%eax
  802337:	85 c0                	test   %eax,%eax
  802339:	74 0c                	je     802347 <insert_sorted_allocList+0x179>
  80233b:	a1 44 50 80 00       	mov    0x805044,%eax
  802340:	8b 55 08             	mov    0x8(%ebp),%edx
  802343:	89 10                	mov    %edx,(%eax)
  802345:	eb 08                	jmp    80234f <insert_sorted_allocList+0x181>
  802347:	8b 45 08             	mov    0x8(%ebp),%eax
  80234a:	a3 40 50 80 00       	mov    %eax,0x805040
  80234f:	8b 45 08             	mov    0x8(%ebp),%eax
  802352:	a3 44 50 80 00       	mov    %eax,0x805044
  802357:	8b 45 08             	mov    0x8(%ebp),%eax
  80235a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802360:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802365:	40                   	inc    %eax
  802366:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80236b:	e9 e7 00 00 00       	jmp    802457 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802370:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802373:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802376:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80237d:	a1 40 50 80 00       	mov    0x805040,%eax
  802382:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802385:	e9 9d 00 00 00       	jmp    802427 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  80238a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238d:	8b 00                	mov    (%eax),%eax
  80238f:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802392:	8b 45 08             	mov    0x8(%ebp),%eax
  802395:	8b 50 08             	mov    0x8(%eax),%edx
  802398:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239b:	8b 40 08             	mov    0x8(%eax),%eax
  80239e:	39 c2                	cmp    %eax,%edx
  8023a0:	76 7d                	jbe    80241f <insert_sorted_allocList+0x251>
  8023a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a5:	8b 50 08             	mov    0x8(%eax),%edx
  8023a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8023ab:	8b 40 08             	mov    0x8(%eax),%eax
  8023ae:	39 c2                	cmp    %eax,%edx
  8023b0:	73 6d                	jae    80241f <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8023b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023b6:	74 06                	je     8023be <insert_sorted_allocList+0x1f0>
  8023b8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023bc:	75 14                	jne    8023d2 <insert_sorted_allocList+0x204>
  8023be:	83 ec 04             	sub    $0x4,%esp
  8023c1:	68 10 43 80 00       	push   $0x804310
  8023c6:	6a 7f                	push   $0x7f
  8023c8:	68 9b 42 80 00       	push   $0x80429b
  8023cd:	e8 d5 e0 ff ff       	call   8004a7 <_panic>
  8023d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d5:	8b 10                	mov    (%eax),%edx
  8023d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023da:	89 10                	mov    %edx,(%eax)
  8023dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8023df:	8b 00                	mov    (%eax),%eax
  8023e1:	85 c0                	test   %eax,%eax
  8023e3:	74 0b                	je     8023f0 <insert_sorted_allocList+0x222>
  8023e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e8:	8b 00                	mov    (%eax),%eax
  8023ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8023ed:	89 50 04             	mov    %edx,0x4(%eax)
  8023f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8023f6:	89 10                	mov    %edx,(%eax)
  8023f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023fe:	89 50 04             	mov    %edx,0x4(%eax)
  802401:	8b 45 08             	mov    0x8(%ebp),%eax
  802404:	8b 00                	mov    (%eax),%eax
  802406:	85 c0                	test   %eax,%eax
  802408:	75 08                	jne    802412 <insert_sorted_allocList+0x244>
  80240a:	8b 45 08             	mov    0x8(%ebp),%eax
  80240d:	a3 44 50 80 00       	mov    %eax,0x805044
  802412:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802417:	40                   	inc    %eax
  802418:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  80241d:	eb 39                	jmp    802458 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80241f:	a1 48 50 80 00       	mov    0x805048,%eax
  802424:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802427:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80242b:	74 07                	je     802434 <insert_sorted_allocList+0x266>
  80242d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802430:	8b 00                	mov    (%eax),%eax
  802432:	eb 05                	jmp    802439 <insert_sorted_allocList+0x26b>
  802434:	b8 00 00 00 00       	mov    $0x0,%eax
  802439:	a3 48 50 80 00       	mov    %eax,0x805048
  80243e:	a1 48 50 80 00       	mov    0x805048,%eax
  802443:	85 c0                	test   %eax,%eax
  802445:	0f 85 3f ff ff ff    	jne    80238a <insert_sorted_allocList+0x1bc>
  80244b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80244f:	0f 85 35 ff ff ff    	jne    80238a <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802455:	eb 01                	jmp    802458 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802457:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802458:	90                   	nop
  802459:	c9                   	leave  
  80245a:	c3                   	ret    

0080245b <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80245b:	55                   	push   %ebp
  80245c:	89 e5                	mov    %esp,%ebp
  80245e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802461:	a1 38 51 80 00       	mov    0x805138,%eax
  802466:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802469:	e9 85 01 00 00       	jmp    8025f3 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  80246e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802471:	8b 40 0c             	mov    0xc(%eax),%eax
  802474:	3b 45 08             	cmp    0x8(%ebp),%eax
  802477:	0f 82 6e 01 00 00    	jb     8025eb <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  80247d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802480:	8b 40 0c             	mov    0xc(%eax),%eax
  802483:	3b 45 08             	cmp    0x8(%ebp),%eax
  802486:	0f 85 8a 00 00 00    	jne    802516 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  80248c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802490:	75 17                	jne    8024a9 <alloc_block_FF+0x4e>
  802492:	83 ec 04             	sub    $0x4,%esp
  802495:	68 44 43 80 00       	push   $0x804344
  80249a:	68 93 00 00 00       	push   $0x93
  80249f:	68 9b 42 80 00       	push   $0x80429b
  8024a4:	e8 fe df ff ff       	call   8004a7 <_panic>
  8024a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ac:	8b 00                	mov    (%eax),%eax
  8024ae:	85 c0                	test   %eax,%eax
  8024b0:	74 10                	je     8024c2 <alloc_block_FF+0x67>
  8024b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b5:	8b 00                	mov    (%eax),%eax
  8024b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024ba:	8b 52 04             	mov    0x4(%edx),%edx
  8024bd:	89 50 04             	mov    %edx,0x4(%eax)
  8024c0:	eb 0b                	jmp    8024cd <alloc_block_FF+0x72>
  8024c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c5:	8b 40 04             	mov    0x4(%eax),%eax
  8024c8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8024cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d0:	8b 40 04             	mov    0x4(%eax),%eax
  8024d3:	85 c0                	test   %eax,%eax
  8024d5:	74 0f                	je     8024e6 <alloc_block_FF+0x8b>
  8024d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024da:	8b 40 04             	mov    0x4(%eax),%eax
  8024dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024e0:	8b 12                	mov    (%edx),%edx
  8024e2:	89 10                	mov    %edx,(%eax)
  8024e4:	eb 0a                	jmp    8024f0 <alloc_block_FF+0x95>
  8024e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e9:	8b 00                	mov    (%eax),%eax
  8024eb:	a3 38 51 80 00       	mov    %eax,0x805138
  8024f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802503:	a1 44 51 80 00       	mov    0x805144,%eax
  802508:	48                   	dec    %eax
  802509:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  80250e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802511:	e9 10 01 00 00       	jmp    802626 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802516:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802519:	8b 40 0c             	mov    0xc(%eax),%eax
  80251c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80251f:	0f 86 c6 00 00 00    	jbe    8025eb <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802525:	a1 48 51 80 00       	mov    0x805148,%eax
  80252a:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  80252d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802530:	8b 50 08             	mov    0x8(%eax),%edx
  802533:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802536:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802539:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80253c:	8b 55 08             	mov    0x8(%ebp),%edx
  80253f:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802542:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802546:	75 17                	jne    80255f <alloc_block_FF+0x104>
  802548:	83 ec 04             	sub    $0x4,%esp
  80254b:	68 44 43 80 00       	push   $0x804344
  802550:	68 9b 00 00 00       	push   $0x9b
  802555:	68 9b 42 80 00       	push   $0x80429b
  80255a:	e8 48 df ff ff       	call   8004a7 <_panic>
  80255f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802562:	8b 00                	mov    (%eax),%eax
  802564:	85 c0                	test   %eax,%eax
  802566:	74 10                	je     802578 <alloc_block_FF+0x11d>
  802568:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80256b:	8b 00                	mov    (%eax),%eax
  80256d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802570:	8b 52 04             	mov    0x4(%edx),%edx
  802573:	89 50 04             	mov    %edx,0x4(%eax)
  802576:	eb 0b                	jmp    802583 <alloc_block_FF+0x128>
  802578:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80257b:	8b 40 04             	mov    0x4(%eax),%eax
  80257e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802583:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802586:	8b 40 04             	mov    0x4(%eax),%eax
  802589:	85 c0                	test   %eax,%eax
  80258b:	74 0f                	je     80259c <alloc_block_FF+0x141>
  80258d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802590:	8b 40 04             	mov    0x4(%eax),%eax
  802593:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802596:	8b 12                	mov    (%edx),%edx
  802598:	89 10                	mov    %edx,(%eax)
  80259a:	eb 0a                	jmp    8025a6 <alloc_block_FF+0x14b>
  80259c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80259f:	8b 00                	mov    (%eax),%eax
  8025a1:	a3 48 51 80 00       	mov    %eax,0x805148
  8025a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025b2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025b9:	a1 54 51 80 00       	mov    0x805154,%eax
  8025be:	48                   	dec    %eax
  8025bf:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  8025c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c7:	8b 50 08             	mov    0x8(%eax),%edx
  8025ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8025cd:	01 c2                	add    %eax,%edx
  8025cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d2:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8025d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d8:	8b 40 0c             	mov    0xc(%eax),%eax
  8025db:	2b 45 08             	sub    0x8(%ebp),%eax
  8025de:	89 c2                	mov    %eax,%edx
  8025e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e3:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8025e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025e9:	eb 3b                	jmp    802626 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8025eb:	a1 40 51 80 00       	mov    0x805140,%eax
  8025f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025f7:	74 07                	je     802600 <alloc_block_FF+0x1a5>
  8025f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fc:	8b 00                	mov    (%eax),%eax
  8025fe:	eb 05                	jmp    802605 <alloc_block_FF+0x1aa>
  802600:	b8 00 00 00 00       	mov    $0x0,%eax
  802605:	a3 40 51 80 00       	mov    %eax,0x805140
  80260a:	a1 40 51 80 00       	mov    0x805140,%eax
  80260f:	85 c0                	test   %eax,%eax
  802611:	0f 85 57 fe ff ff    	jne    80246e <alloc_block_FF+0x13>
  802617:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80261b:	0f 85 4d fe ff ff    	jne    80246e <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802621:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802626:	c9                   	leave  
  802627:	c3                   	ret    

00802628 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802628:	55                   	push   %ebp
  802629:	89 e5                	mov    %esp,%ebp
  80262b:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  80262e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802635:	a1 38 51 80 00       	mov    0x805138,%eax
  80263a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80263d:	e9 df 00 00 00       	jmp    802721 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802642:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802645:	8b 40 0c             	mov    0xc(%eax),%eax
  802648:	3b 45 08             	cmp    0x8(%ebp),%eax
  80264b:	0f 82 c8 00 00 00    	jb     802719 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802651:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802654:	8b 40 0c             	mov    0xc(%eax),%eax
  802657:	3b 45 08             	cmp    0x8(%ebp),%eax
  80265a:	0f 85 8a 00 00 00    	jne    8026ea <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802660:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802664:	75 17                	jne    80267d <alloc_block_BF+0x55>
  802666:	83 ec 04             	sub    $0x4,%esp
  802669:	68 44 43 80 00       	push   $0x804344
  80266e:	68 b7 00 00 00       	push   $0xb7
  802673:	68 9b 42 80 00       	push   $0x80429b
  802678:	e8 2a de ff ff       	call   8004a7 <_panic>
  80267d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802680:	8b 00                	mov    (%eax),%eax
  802682:	85 c0                	test   %eax,%eax
  802684:	74 10                	je     802696 <alloc_block_BF+0x6e>
  802686:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802689:	8b 00                	mov    (%eax),%eax
  80268b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80268e:	8b 52 04             	mov    0x4(%edx),%edx
  802691:	89 50 04             	mov    %edx,0x4(%eax)
  802694:	eb 0b                	jmp    8026a1 <alloc_block_BF+0x79>
  802696:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802699:	8b 40 04             	mov    0x4(%eax),%eax
  80269c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8026a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a4:	8b 40 04             	mov    0x4(%eax),%eax
  8026a7:	85 c0                	test   %eax,%eax
  8026a9:	74 0f                	je     8026ba <alloc_block_BF+0x92>
  8026ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ae:	8b 40 04             	mov    0x4(%eax),%eax
  8026b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026b4:	8b 12                	mov    (%edx),%edx
  8026b6:	89 10                	mov    %edx,(%eax)
  8026b8:	eb 0a                	jmp    8026c4 <alloc_block_BF+0x9c>
  8026ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bd:	8b 00                	mov    (%eax),%eax
  8026bf:	a3 38 51 80 00       	mov    %eax,0x805138
  8026c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026d7:	a1 44 51 80 00       	mov    0x805144,%eax
  8026dc:	48                   	dec    %eax
  8026dd:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  8026e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e5:	e9 4d 01 00 00       	jmp    802837 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8026ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ed:	8b 40 0c             	mov    0xc(%eax),%eax
  8026f0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026f3:	76 24                	jbe    802719 <alloc_block_BF+0xf1>
  8026f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f8:	8b 40 0c             	mov    0xc(%eax),%eax
  8026fb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8026fe:	73 19                	jae    802719 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802700:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802707:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270a:	8b 40 0c             	mov    0xc(%eax),%eax
  80270d:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802710:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802713:	8b 40 08             	mov    0x8(%eax),%eax
  802716:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802719:	a1 40 51 80 00       	mov    0x805140,%eax
  80271e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802721:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802725:	74 07                	je     80272e <alloc_block_BF+0x106>
  802727:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272a:	8b 00                	mov    (%eax),%eax
  80272c:	eb 05                	jmp    802733 <alloc_block_BF+0x10b>
  80272e:	b8 00 00 00 00       	mov    $0x0,%eax
  802733:	a3 40 51 80 00       	mov    %eax,0x805140
  802738:	a1 40 51 80 00       	mov    0x805140,%eax
  80273d:	85 c0                	test   %eax,%eax
  80273f:	0f 85 fd fe ff ff    	jne    802642 <alloc_block_BF+0x1a>
  802745:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802749:	0f 85 f3 fe ff ff    	jne    802642 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  80274f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802753:	0f 84 d9 00 00 00    	je     802832 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802759:	a1 48 51 80 00       	mov    0x805148,%eax
  80275e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802761:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802764:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802767:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  80276a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80276d:	8b 55 08             	mov    0x8(%ebp),%edx
  802770:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802773:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802777:	75 17                	jne    802790 <alloc_block_BF+0x168>
  802779:	83 ec 04             	sub    $0x4,%esp
  80277c:	68 44 43 80 00       	push   $0x804344
  802781:	68 c7 00 00 00       	push   $0xc7
  802786:	68 9b 42 80 00       	push   $0x80429b
  80278b:	e8 17 dd ff ff       	call   8004a7 <_panic>
  802790:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802793:	8b 00                	mov    (%eax),%eax
  802795:	85 c0                	test   %eax,%eax
  802797:	74 10                	je     8027a9 <alloc_block_BF+0x181>
  802799:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80279c:	8b 00                	mov    (%eax),%eax
  80279e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027a1:	8b 52 04             	mov    0x4(%edx),%edx
  8027a4:	89 50 04             	mov    %edx,0x4(%eax)
  8027a7:	eb 0b                	jmp    8027b4 <alloc_block_BF+0x18c>
  8027a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027ac:	8b 40 04             	mov    0x4(%eax),%eax
  8027af:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8027b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027b7:	8b 40 04             	mov    0x4(%eax),%eax
  8027ba:	85 c0                	test   %eax,%eax
  8027bc:	74 0f                	je     8027cd <alloc_block_BF+0x1a5>
  8027be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027c1:	8b 40 04             	mov    0x4(%eax),%eax
  8027c4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027c7:	8b 12                	mov    (%edx),%edx
  8027c9:	89 10                	mov    %edx,(%eax)
  8027cb:	eb 0a                	jmp    8027d7 <alloc_block_BF+0x1af>
  8027cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027d0:	8b 00                	mov    (%eax),%eax
  8027d2:	a3 48 51 80 00       	mov    %eax,0x805148
  8027d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027da:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027e3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027ea:	a1 54 51 80 00       	mov    0x805154,%eax
  8027ef:	48                   	dec    %eax
  8027f0:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8027f5:	83 ec 08             	sub    $0x8,%esp
  8027f8:	ff 75 ec             	pushl  -0x14(%ebp)
  8027fb:	68 38 51 80 00       	push   $0x805138
  802800:	e8 71 f9 ff ff       	call   802176 <find_block>
  802805:	83 c4 10             	add    $0x10,%esp
  802808:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  80280b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80280e:	8b 50 08             	mov    0x8(%eax),%edx
  802811:	8b 45 08             	mov    0x8(%ebp),%eax
  802814:	01 c2                	add    %eax,%edx
  802816:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802819:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  80281c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80281f:	8b 40 0c             	mov    0xc(%eax),%eax
  802822:	2b 45 08             	sub    0x8(%ebp),%eax
  802825:	89 c2                	mov    %eax,%edx
  802827:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80282a:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  80282d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802830:	eb 05                	jmp    802837 <alloc_block_BF+0x20f>
	}
	return NULL;
  802832:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802837:	c9                   	leave  
  802838:	c3                   	ret    

00802839 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802839:	55                   	push   %ebp
  80283a:	89 e5                	mov    %esp,%ebp
  80283c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  80283f:	a1 28 50 80 00       	mov    0x805028,%eax
  802844:	85 c0                	test   %eax,%eax
  802846:	0f 85 de 01 00 00    	jne    802a2a <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80284c:	a1 38 51 80 00       	mov    0x805138,%eax
  802851:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802854:	e9 9e 01 00 00       	jmp    8029f7 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802859:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285c:	8b 40 0c             	mov    0xc(%eax),%eax
  80285f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802862:	0f 82 87 01 00 00    	jb     8029ef <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802868:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286b:	8b 40 0c             	mov    0xc(%eax),%eax
  80286e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802871:	0f 85 95 00 00 00    	jne    80290c <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802877:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80287b:	75 17                	jne    802894 <alloc_block_NF+0x5b>
  80287d:	83 ec 04             	sub    $0x4,%esp
  802880:	68 44 43 80 00       	push   $0x804344
  802885:	68 e0 00 00 00       	push   $0xe0
  80288a:	68 9b 42 80 00       	push   $0x80429b
  80288f:	e8 13 dc ff ff       	call   8004a7 <_panic>
  802894:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802897:	8b 00                	mov    (%eax),%eax
  802899:	85 c0                	test   %eax,%eax
  80289b:	74 10                	je     8028ad <alloc_block_NF+0x74>
  80289d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a0:	8b 00                	mov    (%eax),%eax
  8028a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028a5:	8b 52 04             	mov    0x4(%edx),%edx
  8028a8:	89 50 04             	mov    %edx,0x4(%eax)
  8028ab:	eb 0b                	jmp    8028b8 <alloc_block_NF+0x7f>
  8028ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b0:	8b 40 04             	mov    0x4(%eax),%eax
  8028b3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8028b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bb:	8b 40 04             	mov    0x4(%eax),%eax
  8028be:	85 c0                	test   %eax,%eax
  8028c0:	74 0f                	je     8028d1 <alloc_block_NF+0x98>
  8028c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c5:	8b 40 04             	mov    0x4(%eax),%eax
  8028c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028cb:	8b 12                	mov    (%edx),%edx
  8028cd:	89 10                	mov    %edx,(%eax)
  8028cf:	eb 0a                	jmp    8028db <alloc_block_NF+0xa2>
  8028d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d4:	8b 00                	mov    (%eax),%eax
  8028d6:	a3 38 51 80 00       	mov    %eax,0x805138
  8028db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028de:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028ee:	a1 44 51 80 00       	mov    0x805144,%eax
  8028f3:	48                   	dec    %eax
  8028f4:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  8028f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fc:	8b 40 08             	mov    0x8(%eax),%eax
  8028ff:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802904:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802907:	e9 f8 04 00 00       	jmp    802e04 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  80290c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290f:	8b 40 0c             	mov    0xc(%eax),%eax
  802912:	3b 45 08             	cmp    0x8(%ebp),%eax
  802915:	0f 86 d4 00 00 00    	jbe    8029ef <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80291b:	a1 48 51 80 00       	mov    0x805148,%eax
  802920:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802923:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802926:	8b 50 08             	mov    0x8(%eax),%edx
  802929:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80292c:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  80292f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802932:	8b 55 08             	mov    0x8(%ebp),%edx
  802935:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802938:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80293c:	75 17                	jne    802955 <alloc_block_NF+0x11c>
  80293e:	83 ec 04             	sub    $0x4,%esp
  802941:	68 44 43 80 00       	push   $0x804344
  802946:	68 e9 00 00 00       	push   $0xe9
  80294b:	68 9b 42 80 00       	push   $0x80429b
  802950:	e8 52 db ff ff       	call   8004a7 <_panic>
  802955:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802958:	8b 00                	mov    (%eax),%eax
  80295a:	85 c0                	test   %eax,%eax
  80295c:	74 10                	je     80296e <alloc_block_NF+0x135>
  80295e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802961:	8b 00                	mov    (%eax),%eax
  802963:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802966:	8b 52 04             	mov    0x4(%edx),%edx
  802969:	89 50 04             	mov    %edx,0x4(%eax)
  80296c:	eb 0b                	jmp    802979 <alloc_block_NF+0x140>
  80296e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802971:	8b 40 04             	mov    0x4(%eax),%eax
  802974:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802979:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80297c:	8b 40 04             	mov    0x4(%eax),%eax
  80297f:	85 c0                	test   %eax,%eax
  802981:	74 0f                	je     802992 <alloc_block_NF+0x159>
  802983:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802986:	8b 40 04             	mov    0x4(%eax),%eax
  802989:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80298c:	8b 12                	mov    (%edx),%edx
  80298e:	89 10                	mov    %edx,(%eax)
  802990:	eb 0a                	jmp    80299c <alloc_block_NF+0x163>
  802992:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802995:	8b 00                	mov    (%eax),%eax
  802997:	a3 48 51 80 00       	mov    %eax,0x805148
  80299c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80299f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029af:	a1 54 51 80 00       	mov    0x805154,%eax
  8029b4:	48                   	dec    %eax
  8029b5:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  8029ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029bd:	8b 40 08             	mov    0x8(%eax),%eax
  8029c0:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  8029c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c8:	8b 50 08             	mov    0x8(%eax),%edx
  8029cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ce:	01 c2                	add    %eax,%edx
  8029d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d3:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  8029d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d9:	8b 40 0c             	mov    0xc(%eax),%eax
  8029dc:	2b 45 08             	sub    0x8(%ebp),%eax
  8029df:	89 c2                	mov    %eax,%edx
  8029e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e4:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  8029e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ea:	e9 15 04 00 00       	jmp    802e04 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8029ef:	a1 40 51 80 00       	mov    0x805140,%eax
  8029f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029fb:	74 07                	je     802a04 <alloc_block_NF+0x1cb>
  8029fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a00:	8b 00                	mov    (%eax),%eax
  802a02:	eb 05                	jmp    802a09 <alloc_block_NF+0x1d0>
  802a04:	b8 00 00 00 00       	mov    $0x0,%eax
  802a09:	a3 40 51 80 00       	mov    %eax,0x805140
  802a0e:	a1 40 51 80 00       	mov    0x805140,%eax
  802a13:	85 c0                	test   %eax,%eax
  802a15:	0f 85 3e fe ff ff    	jne    802859 <alloc_block_NF+0x20>
  802a1b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a1f:	0f 85 34 fe ff ff    	jne    802859 <alloc_block_NF+0x20>
  802a25:	e9 d5 03 00 00       	jmp    802dff <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a2a:	a1 38 51 80 00       	mov    0x805138,%eax
  802a2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a32:	e9 b1 01 00 00       	jmp    802be8 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802a37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3a:	8b 50 08             	mov    0x8(%eax),%edx
  802a3d:	a1 28 50 80 00       	mov    0x805028,%eax
  802a42:	39 c2                	cmp    %eax,%edx
  802a44:	0f 82 96 01 00 00    	jb     802be0 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802a4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4d:	8b 40 0c             	mov    0xc(%eax),%eax
  802a50:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a53:	0f 82 87 01 00 00    	jb     802be0 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802a59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5c:	8b 40 0c             	mov    0xc(%eax),%eax
  802a5f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a62:	0f 85 95 00 00 00    	jne    802afd <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802a68:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a6c:	75 17                	jne    802a85 <alloc_block_NF+0x24c>
  802a6e:	83 ec 04             	sub    $0x4,%esp
  802a71:	68 44 43 80 00       	push   $0x804344
  802a76:	68 fc 00 00 00       	push   $0xfc
  802a7b:	68 9b 42 80 00       	push   $0x80429b
  802a80:	e8 22 da ff ff       	call   8004a7 <_panic>
  802a85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a88:	8b 00                	mov    (%eax),%eax
  802a8a:	85 c0                	test   %eax,%eax
  802a8c:	74 10                	je     802a9e <alloc_block_NF+0x265>
  802a8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a91:	8b 00                	mov    (%eax),%eax
  802a93:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a96:	8b 52 04             	mov    0x4(%edx),%edx
  802a99:	89 50 04             	mov    %edx,0x4(%eax)
  802a9c:	eb 0b                	jmp    802aa9 <alloc_block_NF+0x270>
  802a9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa1:	8b 40 04             	mov    0x4(%eax),%eax
  802aa4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802aa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aac:	8b 40 04             	mov    0x4(%eax),%eax
  802aaf:	85 c0                	test   %eax,%eax
  802ab1:	74 0f                	je     802ac2 <alloc_block_NF+0x289>
  802ab3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab6:	8b 40 04             	mov    0x4(%eax),%eax
  802ab9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802abc:	8b 12                	mov    (%edx),%edx
  802abe:	89 10                	mov    %edx,(%eax)
  802ac0:	eb 0a                	jmp    802acc <alloc_block_NF+0x293>
  802ac2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac5:	8b 00                	mov    (%eax),%eax
  802ac7:	a3 38 51 80 00       	mov    %eax,0x805138
  802acc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ad5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802adf:	a1 44 51 80 00       	mov    0x805144,%eax
  802ae4:	48                   	dec    %eax
  802ae5:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802aea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aed:	8b 40 08             	mov    0x8(%eax),%eax
  802af0:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802af5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af8:	e9 07 03 00 00       	jmp    802e04 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802afd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b00:	8b 40 0c             	mov    0xc(%eax),%eax
  802b03:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b06:	0f 86 d4 00 00 00    	jbe    802be0 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b0c:	a1 48 51 80 00       	mov    0x805148,%eax
  802b11:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802b14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b17:	8b 50 08             	mov    0x8(%eax),%edx
  802b1a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b1d:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802b20:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b23:	8b 55 08             	mov    0x8(%ebp),%edx
  802b26:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802b29:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802b2d:	75 17                	jne    802b46 <alloc_block_NF+0x30d>
  802b2f:	83 ec 04             	sub    $0x4,%esp
  802b32:	68 44 43 80 00       	push   $0x804344
  802b37:	68 04 01 00 00       	push   $0x104
  802b3c:	68 9b 42 80 00       	push   $0x80429b
  802b41:	e8 61 d9 ff ff       	call   8004a7 <_panic>
  802b46:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b49:	8b 00                	mov    (%eax),%eax
  802b4b:	85 c0                	test   %eax,%eax
  802b4d:	74 10                	je     802b5f <alloc_block_NF+0x326>
  802b4f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b52:	8b 00                	mov    (%eax),%eax
  802b54:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b57:	8b 52 04             	mov    0x4(%edx),%edx
  802b5a:	89 50 04             	mov    %edx,0x4(%eax)
  802b5d:	eb 0b                	jmp    802b6a <alloc_block_NF+0x331>
  802b5f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b62:	8b 40 04             	mov    0x4(%eax),%eax
  802b65:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b6a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b6d:	8b 40 04             	mov    0x4(%eax),%eax
  802b70:	85 c0                	test   %eax,%eax
  802b72:	74 0f                	je     802b83 <alloc_block_NF+0x34a>
  802b74:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b77:	8b 40 04             	mov    0x4(%eax),%eax
  802b7a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b7d:	8b 12                	mov    (%edx),%edx
  802b7f:	89 10                	mov    %edx,(%eax)
  802b81:	eb 0a                	jmp    802b8d <alloc_block_NF+0x354>
  802b83:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b86:	8b 00                	mov    (%eax),%eax
  802b88:	a3 48 51 80 00       	mov    %eax,0x805148
  802b8d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b90:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b96:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b99:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ba0:	a1 54 51 80 00       	mov    0x805154,%eax
  802ba5:	48                   	dec    %eax
  802ba6:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802bab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bae:	8b 40 08             	mov    0x8(%eax),%eax
  802bb1:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802bb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb9:	8b 50 08             	mov    0x8(%eax),%edx
  802bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbf:	01 c2                	add    %eax,%edx
  802bc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc4:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802bc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bca:	8b 40 0c             	mov    0xc(%eax),%eax
  802bcd:	2b 45 08             	sub    0x8(%ebp),%eax
  802bd0:	89 c2                	mov    %eax,%edx
  802bd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd5:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802bd8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bdb:	e9 24 02 00 00       	jmp    802e04 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802be0:	a1 40 51 80 00       	mov    0x805140,%eax
  802be5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802be8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bec:	74 07                	je     802bf5 <alloc_block_NF+0x3bc>
  802bee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf1:	8b 00                	mov    (%eax),%eax
  802bf3:	eb 05                	jmp    802bfa <alloc_block_NF+0x3c1>
  802bf5:	b8 00 00 00 00       	mov    $0x0,%eax
  802bfa:	a3 40 51 80 00       	mov    %eax,0x805140
  802bff:	a1 40 51 80 00       	mov    0x805140,%eax
  802c04:	85 c0                	test   %eax,%eax
  802c06:	0f 85 2b fe ff ff    	jne    802a37 <alloc_block_NF+0x1fe>
  802c0c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c10:	0f 85 21 fe ff ff    	jne    802a37 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c16:	a1 38 51 80 00       	mov    0x805138,%eax
  802c1b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c1e:	e9 ae 01 00 00       	jmp    802dd1 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802c23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c26:	8b 50 08             	mov    0x8(%eax),%edx
  802c29:	a1 28 50 80 00       	mov    0x805028,%eax
  802c2e:	39 c2                	cmp    %eax,%edx
  802c30:	0f 83 93 01 00 00    	jae    802dc9 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802c36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c39:	8b 40 0c             	mov    0xc(%eax),%eax
  802c3c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c3f:	0f 82 84 01 00 00    	jb     802dc9 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802c45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c48:	8b 40 0c             	mov    0xc(%eax),%eax
  802c4b:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c4e:	0f 85 95 00 00 00    	jne    802ce9 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802c54:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c58:	75 17                	jne    802c71 <alloc_block_NF+0x438>
  802c5a:	83 ec 04             	sub    $0x4,%esp
  802c5d:	68 44 43 80 00       	push   $0x804344
  802c62:	68 14 01 00 00       	push   $0x114
  802c67:	68 9b 42 80 00       	push   $0x80429b
  802c6c:	e8 36 d8 ff ff       	call   8004a7 <_panic>
  802c71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c74:	8b 00                	mov    (%eax),%eax
  802c76:	85 c0                	test   %eax,%eax
  802c78:	74 10                	je     802c8a <alloc_block_NF+0x451>
  802c7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7d:	8b 00                	mov    (%eax),%eax
  802c7f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c82:	8b 52 04             	mov    0x4(%edx),%edx
  802c85:	89 50 04             	mov    %edx,0x4(%eax)
  802c88:	eb 0b                	jmp    802c95 <alloc_block_NF+0x45c>
  802c8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8d:	8b 40 04             	mov    0x4(%eax),%eax
  802c90:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c98:	8b 40 04             	mov    0x4(%eax),%eax
  802c9b:	85 c0                	test   %eax,%eax
  802c9d:	74 0f                	je     802cae <alloc_block_NF+0x475>
  802c9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca2:	8b 40 04             	mov    0x4(%eax),%eax
  802ca5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ca8:	8b 12                	mov    (%edx),%edx
  802caa:	89 10                	mov    %edx,(%eax)
  802cac:	eb 0a                	jmp    802cb8 <alloc_block_NF+0x47f>
  802cae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb1:	8b 00                	mov    (%eax),%eax
  802cb3:	a3 38 51 80 00       	mov    %eax,0x805138
  802cb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ccb:	a1 44 51 80 00       	mov    0x805144,%eax
  802cd0:	48                   	dec    %eax
  802cd1:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802cd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd9:	8b 40 08             	mov    0x8(%eax),%eax
  802cdc:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802ce1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce4:	e9 1b 01 00 00       	jmp    802e04 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802ce9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cec:	8b 40 0c             	mov    0xc(%eax),%eax
  802cef:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cf2:	0f 86 d1 00 00 00    	jbe    802dc9 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802cf8:	a1 48 51 80 00       	mov    0x805148,%eax
  802cfd:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802d00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d03:	8b 50 08             	mov    0x8(%eax),%edx
  802d06:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d09:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802d0c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d0f:	8b 55 08             	mov    0x8(%ebp),%edx
  802d12:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802d15:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802d19:	75 17                	jne    802d32 <alloc_block_NF+0x4f9>
  802d1b:	83 ec 04             	sub    $0x4,%esp
  802d1e:	68 44 43 80 00       	push   $0x804344
  802d23:	68 1c 01 00 00       	push   $0x11c
  802d28:	68 9b 42 80 00       	push   $0x80429b
  802d2d:	e8 75 d7 ff ff       	call   8004a7 <_panic>
  802d32:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d35:	8b 00                	mov    (%eax),%eax
  802d37:	85 c0                	test   %eax,%eax
  802d39:	74 10                	je     802d4b <alloc_block_NF+0x512>
  802d3b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d3e:	8b 00                	mov    (%eax),%eax
  802d40:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d43:	8b 52 04             	mov    0x4(%edx),%edx
  802d46:	89 50 04             	mov    %edx,0x4(%eax)
  802d49:	eb 0b                	jmp    802d56 <alloc_block_NF+0x51d>
  802d4b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d4e:	8b 40 04             	mov    0x4(%eax),%eax
  802d51:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d56:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d59:	8b 40 04             	mov    0x4(%eax),%eax
  802d5c:	85 c0                	test   %eax,%eax
  802d5e:	74 0f                	je     802d6f <alloc_block_NF+0x536>
  802d60:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d63:	8b 40 04             	mov    0x4(%eax),%eax
  802d66:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d69:	8b 12                	mov    (%edx),%edx
  802d6b:	89 10                	mov    %edx,(%eax)
  802d6d:	eb 0a                	jmp    802d79 <alloc_block_NF+0x540>
  802d6f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d72:	8b 00                	mov    (%eax),%eax
  802d74:	a3 48 51 80 00       	mov    %eax,0x805148
  802d79:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d7c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d82:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d85:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d8c:	a1 54 51 80 00       	mov    0x805154,%eax
  802d91:	48                   	dec    %eax
  802d92:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802d97:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d9a:	8b 40 08             	mov    0x8(%eax),%eax
  802d9d:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802da2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da5:	8b 50 08             	mov    0x8(%eax),%edx
  802da8:	8b 45 08             	mov    0x8(%ebp),%eax
  802dab:	01 c2                	add    %eax,%edx
  802dad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db0:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802db3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db6:	8b 40 0c             	mov    0xc(%eax),%eax
  802db9:	2b 45 08             	sub    0x8(%ebp),%eax
  802dbc:	89 c2                	mov    %eax,%edx
  802dbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc1:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802dc4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dc7:	eb 3b                	jmp    802e04 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802dc9:	a1 40 51 80 00       	mov    0x805140,%eax
  802dce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802dd1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dd5:	74 07                	je     802dde <alloc_block_NF+0x5a5>
  802dd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dda:	8b 00                	mov    (%eax),%eax
  802ddc:	eb 05                	jmp    802de3 <alloc_block_NF+0x5aa>
  802dde:	b8 00 00 00 00       	mov    $0x0,%eax
  802de3:	a3 40 51 80 00       	mov    %eax,0x805140
  802de8:	a1 40 51 80 00       	mov    0x805140,%eax
  802ded:	85 c0                	test   %eax,%eax
  802def:	0f 85 2e fe ff ff    	jne    802c23 <alloc_block_NF+0x3ea>
  802df5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802df9:	0f 85 24 fe ff ff    	jne    802c23 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802dff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e04:	c9                   	leave  
  802e05:	c3                   	ret    

00802e06 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802e06:	55                   	push   %ebp
  802e07:	89 e5                	mov    %esp,%ebp
  802e09:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802e0c:	a1 38 51 80 00       	mov    0x805138,%eax
  802e11:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802e14:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802e19:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802e1c:	a1 38 51 80 00       	mov    0x805138,%eax
  802e21:	85 c0                	test   %eax,%eax
  802e23:	74 14                	je     802e39 <insert_sorted_with_merge_freeList+0x33>
  802e25:	8b 45 08             	mov    0x8(%ebp),%eax
  802e28:	8b 50 08             	mov    0x8(%eax),%edx
  802e2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e2e:	8b 40 08             	mov    0x8(%eax),%eax
  802e31:	39 c2                	cmp    %eax,%edx
  802e33:	0f 87 9b 01 00 00    	ja     802fd4 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802e39:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e3d:	75 17                	jne    802e56 <insert_sorted_with_merge_freeList+0x50>
  802e3f:	83 ec 04             	sub    $0x4,%esp
  802e42:	68 78 42 80 00       	push   $0x804278
  802e47:	68 38 01 00 00       	push   $0x138
  802e4c:	68 9b 42 80 00       	push   $0x80429b
  802e51:	e8 51 d6 ff ff       	call   8004a7 <_panic>
  802e56:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802e5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5f:	89 10                	mov    %edx,(%eax)
  802e61:	8b 45 08             	mov    0x8(%ebp),%eax
  802e64:	8b 00                	mov    (%eax),%eax
  802e66:	85 c0                	test   %eax,%eax
  802e68:	74 0d                	je     802e77 <insert_sorted_with_merge_freeList+0x71>
  802e6a:	a1 38 51 80 00       	mov    0x805138,%eax
  802e6f:	8b 55 08             	mov    0x8(%ebp),%edx
  802e72:	89 50 04             	mov    %edx,0x4(%eax)
  802e75:	eb 08                	jmp    802e7f <insert_sorted_with_merge_freeList+0x79>
  802e77:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e82:	a3 38 51 80 00       	mov    %eax,0x805138
  802e87:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e91:	a1 44 51 80 00       	mov    0x805144,%eax
  802e96:	40                   	inc    %eax
  802e97:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802e9c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ea0:	0f 84 a8 06 00 00    	je     80354e <insert_sorted_with_merge_freeList+0x748>
  802ea6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea9:	8b 50 08             	mov    0x8(%eax),%edx
  802eac:	8b 45 08             	mov    0x8(%ebp),%eax
  802eaf:	8b 40 0c             	mov    0xc(%eax),%eax
  802eb2:	01 c2                	add    %eax,%edx
  802eb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eb7:	8b 40 08             	mov    0x8(%eax),%eax
  802eba:	39 c2                	cmp    %eax,%edx
  802ebc:	0f 85 8c 06 00 00    	jne    80354e <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec5:	8b 50 0c             	mov    0xc(%eax),%edx
  802ec8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ecb:	8b 40 0c             	mov    0xc(%eax),%eax
  802ece:	01 c2                	add    %eax,%edx
  802ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed3:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802ed6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802eda:	75 17                	jne    802ef3 <insert_sorted_with_merge_freeList+0xed>
  802edc:	83 ec 04             	sub    $0x4,%esp
  802edf:	68 44 43 80 00       	push   $0x804344
  802ee4:	68 3c 01 00 00       	push   $0x13c
  802ee9:	68 9b 42 80 00       	push   $0x80429b
  802eee:	e8 b4 d5 ff ff       	call   8004a7 <_panic>
  802ef3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ef6:	8b 00                	mov    (%eax),%eax
  802ef8:	85 c0                	test   %eax,%eax
  802efa:	74 10                	je     802f0c <insert_sorted_with_merge_freeList+0x106>
  802efc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eff:	8b 00                	mov    (%eax),%eax
  802f01:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f04:	8b 52 04             	mov    0x4(%edx),%edx
  802f07:	89 50 04             	mov    %edx,0x4(%eax)
  802f0a:	eb 0b                	jmp    802f17 <insert_sorted_with_merge_freeList+0x111>
  802f0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f0f:	8b 40 04             	mov    0x4(%eax),%eax
  802f12:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f1a:	8b 40 04             	mov    0x4(%eax),%eax
  802f1d:	85 c0                	test   %eax,%eax
  802f1f:	74 0f                	je     802f30 <insert_sorted_with_merge_freeList+0x12a>
  802f21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f24:	8b 40 04             	mov    0x4(%eax),%eax
  802f27:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f2a:	8b 12                	mov    (%edx),%edx
  802f2c:	89 10                	mov    %edx,(%eax)
  802f2e:	eb 0a                	jmp    802f3a <insert_sorted_with_merge_freeList+0x134>
  802f30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f33:	8b 00                	mov    (%eax),%eax
  802f35:	a3 38 51 80 00       	mov    %eax,0x805138
  802f3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f3d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f46:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f4d:	a1 44 51 80 00       	mov    0x805144,%eax
  802f52:	48                   	dec    %eax
  802f53:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802f58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f5b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802f62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f65:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802f6c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f70:	75 17                	jne    802f89 <insert_sorted_with_merge_freeList+0x183>
  802f72:	83 ec 04             	sub    $0x4,%esp
  802f75:	68 78 42 80 00       	push   $0x804278
  802f7a:	68 3f 01 00 00       	push   $0x13f
  802f7f:	68 9b 42 80 00       	push   $0x80429b
  802f84:	e8 1e d5 ff ff       	call   8004a7 <_panic>
  802f89:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802f8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f92:	89 10                	mov    %edx,(%eax)
  802f94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f97:	8b 00                	mov    (%eax),%eax
  802f99:	85 c0                	test   %eax,%eax
  802f9b:	74 0d                	je     802faa <insert_sorted_with_merge_freeList+0x1a4>
  802f9d:	a1 48 51 80 00       	mov    0x805148,%eax
  802fa2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fa5:	89 50 04             	mov    %edx,0x4(%eax)
  802fa8:	eb 08                	jmp    802fb2 <insert_sorted_with_merge_freeList+0x1ac>
  802faa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fad:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802fb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fb5:	a3 48 51 80 00       	mov    %eax,0x805148
  802fba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fbd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fc4:	a1 54 51 80 00       	mov    0x805154,%eax
  802fc9:	40                   	inc    %eax
  802fca:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802fcf:	e9 7a 05 00 00       	jmp    80354e <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802fd4:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd7:	8b 50 08             	mov    0x8(%eax),%edx
  802fda:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fdd:	8b 40 08             	mov    0x8(%eax),%eax
  802fe0:	39 c2                	cmp    %eax,%edx
  802fe2:	0f 82 14 01 00 00    	jb     8030fc <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802fe8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802feb:	8b 50 08             	mov    0x8(%eax),%edx
  802fee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ff1:	8b 40 0c             	mov    0xc(%eax),%eax
  802ff4:	01 c2                	add    %eax,%edx
  802ff6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff9:	8b 40 08             	mov    0x8(%eax),%eax
  802ffc:	39 c2                	cmp    %eax,%edx
  802ffe:	0f 85 90 00 00 00    	jne    803094 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  803004:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803007:	8b 50 0c             	mov    0xc(%eax),%edx
  80300a:	8b 45 08             	mov    0x8(%ebp),%eax
  80300d:	8b 40 0c             	mov    0xc(%eax),%eax
  803010:	01 c2                	add    %eax,%edx
  803012:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803015:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  803018:	8b 45 08             	mov    0x8(%ebp),%eax
  80301b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  803022:	8b 45 08             	mov    0x8(%ebp),%eax
  803025:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80302c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803030:	75 17                	jne    803049 <insert_sorted_with_merge_freeList+0x243>
  803032:	83 ec 04             	sub    $0x4,%esp
  803035:	68 78 42 80 00       	push   $0x804278
  80303a:	68 49 01 00 00       	push   $0x149
  80303f:	68 9b 42 80 00       	push   $0x80429b
  803044:	e8 5e d4 ff ff       	call   8004a7 <_panic>
  803049:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80304f:	8b 45 08             	mov    0x8(%ebp),%eax
  803052:	89 10                	mov    %edx,(%eax)
  803054:	8b 45 08             	mov    0x8(%ebp),%eax
  803057:	8b 00                	mov    (%eax),%eax
  803059:	85 c0                	test   %eax,%eax
  80305b:	74 0d                	je     80306a <insert_sorted_with_merge_freeList+0x264>
  80305d:	a1 48 51 80 00       	mov    0x805148,%eax
  803062:	8b 55 08             	mov    0x8(%ebp),%edx
  803065:	89 50 04             	mov    %edx,0x4(%eax)
  803068:	eb 08                	jmp    803072 <insert_sorted_with_merge_freeList+0x26c>
  80306a:	8b 45 08             	mov    0x8(%ebp),%eax
  80306d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803072:	8b 45 08             	mov    0x8(%ebp),%eax
  803075:	a3 48 51 80 00       	mov    %eax,0x805148
  80307a:	8b 45 08             	mov    0x8(%ebp),%eax
  80307d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803084:	a1 54 51 80 00       	mov    0x805154,%eax
  803089:	40                   	inc    %eax
  80308a:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80308f:	e9 bb 04 00 00       	jmp    80354f <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803094:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803098:	75 17                	jne    8030b1 <insert_sorted_with_merge_freeList+0x2ab>
  80309a:	83 ec 04             	sub    $0x4,%esp
  80309d:	68 ec 42 80 00       	push   $0x8042ec
  8030a2:	68 4c 01 00 00       	push   $0x14c
  8030a7:	68 9b 42 80 00       	push   $0x80429b
  8030ac:	e8 f6 d3 ff ff       	call   8004a7 <_panic>
  8030b1:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8030b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ba:	89 50 04             	mov    %edx,0x4(%eax)
  8030bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c0:	8b 40 04             	mov    0x4(%eax),%eax
  8030c3:	85 c0                	test   %eax,%eax
  8030c5:	74 0c                	je     8030d3 <insert_sorted_with_merge_freeList+0x2cd>
  8030c7:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8030cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8030cf:	89 10                	mov    %edx,(%eax)
  8030d1:	eb 08                	jmp    8030db <insert_sorted_with_merge_freeList+0x2d5>
  8030d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d6:	a3 38 51 80 00       	mov    %eax,0x805138
  8030db:	8b 45 08             	mov    0x8(%ebp),%eax
  8030de:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030ec:	a1 44 51 80 00       	mov    0x805144,%eax
  8030f1:	40                   	inc    %eax
  8030f2:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8030f7:	e9 53 04 00 00       	jmp    80354f <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8030fc:	a1 38 51 80 00       	mov    0x805138,%eax
  803101:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803104:	e9 15 04 00 00       	jmp    80351e <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  803109:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80310c:	8b 00                	mov    (%eax),%eax
  80310e:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803111:	8b 45 08             	mov    0x8(%ebp),%eax
  803114:	8b 50 08             	mov    0x8(%eax),%edx
  803117:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80311a:	8b 40 08             	mov    0x8(%eax),%eax
  80311d:	39 c2                	cmp    %eax,%edx
  80311f:	0f 86 f1 03 00 00    	jbe    803516 <insert_sorted_with_merge_freeList+0x710>
  803125:	8b 45 08             	mov    0x8(%ebp),%eax
  803128:	8b 50 08             	mov    0x8(%eax),%edx
  80312b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80312e:	8b 40 08             	mov    0x8(%eax),%eax
  803131:	39 c2                	cmp    %eax,%edx
  803133:	0f 83 dd 03 00 00    	jae    803516 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803139:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80313c:	8b 50 08             	mov    0x8(%eax),%edx
  80313f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803142:	8b 40 0c             	mov    0xc(%eax),%eax
  803145:	01 c2                	add    %eax,%edx
  803147:	8b 45 08             	mov    0x8(%ebp),%eax
  80314a:	8b 40 08             	mov    0x8(%eax),%eax
  80314d:	39 c2                	cmp    %eax,%edx
  80314f:	0f 85 b9 01 00 00    	jne    80330e <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803155:	8b 45 08             	mov    0x8(%ebp),%eax
  803158:	8b 50 08             	mov    0x8(%eax),%edx
  80315b:	8b 45 08             	mov    0x8(%ebp),%eax
  80315e:	8b 40 0c             	mov    0xc(%eax),%eax
  803161:	01 c2                	add    %eax,%edx
  803163:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803166:	8b 40 08             	mov    0x8(%eax),%eax
  803169:	39 c2                	cmp    %eax,%edx
  80316b:	0f 85 0d 01 00 00    	jne    80327e <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803171:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803174:	8b 50 0c             	mov    0xc(%eax),%edx
  803177:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80317a:	8b 40 0c             	mov    0xc(%eax),%eax
  80317d:	01 c2                	add    %eax,%edx
  80317f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803182:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803185:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803189:	75 17                	jne    8031a2 <insert_sorted_with_merge_freeList+0x39c>
  80318b:	83 ec 04             	sub    $0x4,%esp
  80318e:	68 44 43 80 00       	push   $0x804344
  803193:	68 5c 01 00 00       	push   $0x15c
  803198:	68 9b 42 80 00       	push   $0x80429b
  80319d:	e8 05 d3 ff ff       	call   8004a7 <_panic>
  8031a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031a5:	8b 00                	mov    (%eax),%eax
  8031a7:	85 c0                	test   %eax,%eax
  8031a9:	74 10                	je     8031bb <insert_sorted_with_merge_freeList+0x3b5>
  8031ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ae:	8b 00                	mov    (%eax),%eax
  8031b0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031b3:	8b 52 04             	mov    0x4(%edx),%edx
  8031b6:	89 50 04             	mov    %edx,0x4(%eax)
  8031b9:	eb 0b                	jmp    8031c6 <insert_sorted_with_merge_freeList+0x3c0>
  8031bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031be:	8b 40 04             	mov    0x4(%eax),%eax
  8031c1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c9:	8b 40 04             	mov    0x4(%eax),%eax
  8031cc:	85 c0                	test   %eax,%eax
  8031ce:	74 0f                	je     8031df <insert_sorted_with_merge_freeList+0x3d9>
  8031d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d3:	8b 40 04             	mov    0x4(%eax),%eax
  8031d6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031d9:	8b 12                	mov    (%edx),%edx
  8031db:	89 10                	mov    %edx,(%eax)
  8031dd:	eb 0a                	jmp    8031e9 <insert_sorted_with_merge_freeList+0x3e3>
  8031df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e2:	8b 00                	mov    (%eax),%eax
  8031e4:	a3 38 51 80 00       	mov    %eax,0x805138
  8031e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031fc:	a1 44 51 80 00       	mov    0x805144,%eax
  803201:	48                   	dec    %eax
  803202:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803207:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80320a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803211:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803214:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80321b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80321f:	75 17                	jne    803238 <insert_sorted_with_merge_freeList+0x432>
  803221:	83 ec 04             	sub    $0x4,%esp
  803224:	68 78 42 80 00       	push   $0x804278
  803229:	68 5f 01 00 00       	push   $0x15f
  80322e:	68 9b 42 80 00       	push   $0x80429b
  803233:	e8 6f d2 ff ff       	call   8004a7 <_panic>
  803238:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80323e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803241:	89 10                	mov    %edx,(%eax)
  803243:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803246:	8b 00                	mov    (%eax),%eax
  803248:	85 c0                	test   %eax,%eax
  80324a:	74 0d                	je     803259 <insert_sorted_with_merge_freeList+0x453>
  80324c:	a1 48 51 80 00       	mov    0x805148,%eax
  803251:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803254:	89 50 04             	mov    %edx,0x4(%eax)
  803257:	eb 08                	jmp    803261 <insert_sorted_with_merge_freeList+0x45b>
  803259:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80325c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803261:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803264:	a3 48 51 80 00       	mov    %eax,0x805148
  803269:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80326c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803273:	a1 54 51 80 00       	mov    0x805154,%eax
  803278:	40                   	inc    %eax
  803279:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  80327e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803281:	8b 50 0c             	mov    0xc(%eax),%edx
  803284:	8b 45 08             	mov    0x8(%ebp),%eax
  803287:	8b 40 0c             	mov    0xc(%eax),%eax
  80328a:	01 c2                	add    %eax,%edx
  80328c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80328f:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803292:	8b 45 08             	mov    0x8(%ebp),%eax
  803295:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  80329c:	8b 45 08             	mov    0x8(%ebp),%eax
  80329f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8032a6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032aa:	75 17                	jne    8032c3 <insert_sorted_with_merge_freeList+0x4bd>
  8032ac:	83 ec 04             	sub    $0x4,%esp
  8032af:	68 78 42 80 00       	push   $0x804278
  8032b4:	68 64 01 00 00       	push   $0x164
  8032b9:	68 9b 42 80 00       	push   $0x80429b
  8032be:	e8 e4 d1 ff ff       	call   8004a7 <_panic>
  8032c3:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8032c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032cc:	89 10                	mov    %edx,(%eax)
  8032ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d1:	8b 00                	mov    (%eax),%eax
  8032d3:	85 c0                	test   %eax,%eax
  8032d5:	74 0d                	je     8032e4 <insert_sorted_with_merge_freeList+0x4de>
  8032d7:	a1 48 51 80 00       	mov    0x805148,%eax
  8032dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8032df:	89 50 04             	mov    %edx,0x4(%eax)
  8032e2:	eb 08                	jmp    8032ec <insert_sorted_with_merge_freeList+0x4e6>
  8032e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ef:	a3 48 51 80 00       	mov    %eax,0x805148
  8032f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032fe:	a1 54 51 80 00       	mov    0x805154,%eax
  803303:	40                   	inc    %eax
  803304:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803309:	e9 41 02 00 00       	jmp    80354f <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80330e:	8b 45 08             	mov    0x8(%ebp),%eax
  803311:	8b 50 08             	mov    0x8(%eax),%edx
  803314:	8b 45 08             	mov    0x8(%ebp),%eax
  803317:	8b 40 0c             	mov    0xc(%eax),%eax
  80331a:	01 c2                	add    %eax,%edx
  80331c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80331f:	8b 40 08             	mov    0x8(%eax),%eax
  803322:	39 c2                	cmp    %eax,%edx
  803324:	0f 85 7c 01 00 00    	jne    8034a6 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  80332a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80332e:	74 06                	je     803336 <insert_sorted_with_merge_freeList+0x530>
  803330:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803334:	75 17                	jne    80334d <insert_sorted_with_merge_freeList+0x547>
  803336:	83 ec 04             	sub    $0x4,%esp
  803339:	68 b4 42 80 00       	push   $0x8042b4
  80333e:	68 69 01 00 00       	push   $0x169
  803343:	68 9b 42 80 00       	push   $0x80429b
  803348:	e8 5a d1 ff ff       	call   8004a7 <_panic>
  80334d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803350:	8b 50 04             	mov    0x4(%eax),%edx
  803353:	8b 45 08             	mov    0x8(%ebp),%eax
  803356:	89 50 04             	mov    %edx,0x4(%eax)
  803359:	8b 45 08             	mov    0x8(%ebp),%eax
  80335c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80335f:	89 10                	mov    %edx,(%eax)
  803361:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803364:	8b 40 04             	mov    0x4(%eax),%eax
  803367:	85 c0                	test   %eax,%eax
  803369:	74 0d                	je     803378 <insert_sorted_with_merge_freeList+0x572>
  80336b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80336e:	8b 40 04             	mov    0x4(%eax),%eax
  803371:	8b 55 08             	mov    0x8(%ebp),%edx
  803374:	89 10                	mov    %edx,(%eax)
  803376:	eb 08                	jmp    803380 <insert_sorted_with_merge_freeList+0x57a>
  803378:	8b 45 08             	mov    0x8(%ebp),%eax
  80337b:	a3 38 51 80 00       	mov    %eax,0x805138
  803380:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803383:	8b 55 08             	mov    0x8(%ebp),%edx
  803386:	89 50 04             	mov    %edx,0x4(%eax)
  803389:	a1 44 51 80 00       	mov    0x805144,%eax
  80338e:	40                   	inc    %eax
  80338f:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803394:	8b 45 08             	mov    0x8(%ebp),%eax
  803397:	8b 50 0c             	mov    0xc(%eax),%edx
  80339a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80339d:	8b 40 0c             	mov    0xc(%eax),%eax
  8033a0:	01 c2                	add    %eax,%edx
  8033a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a5:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8033a8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8033ac:	75 17                	jne    8033c5 <insert_sorted_with_merge_freeList+0x5bf>
  8033ae:	83 ec 04             	sub    $0x4,%esp
  8033b1:	68 44 43 80 00       	push   $0x804344
  8033b6:	68 6b 01 00 00       	push   $0x16b
  8033bb:	68 9b 42 80 00       	push   $0x80429b
  8033c0:	e8 e2 d0 ff ff       	call   8004a7 <_panic>
  8033c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033c8:	8b 00                	mov    (%eax),%eax
  8033ca:	85 c0                	test   %eax,%eax
  8033cc:	74 10                	je     8033de <insert_sorted_with_merge_freeList+0x5d8>
  8033ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033d1:	8b 00                	mov    (%eax),%eax
  8033d3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033d6:	8b 52 04             	mov    0x4(%edx),%edx
  8033d9:	89 50 04             	mov    %edx,0x4(%eax)
  8033dc:	eb 0b                	jmp    8033e9 <insert_sorted_with_merge_freeList+0x5e3>
  8033de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033e1:	8b 40 04             	mov    0x4(%eax),%eax
  8033e4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8033e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033ec:	8b 40 04             	mov    0x4(%eax),%eax
  8033ef:	85 c0                	test   %eax,%eax
  8033f1:	74 0f                	je     803402 <insert_sorted_with_merge_freeList+0x5fc>
  8033f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033f6:	8b 40 04             	mov    0x4(%eax),%eax
  8033f9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033fc:	8b 12                	mov    (%edx),%edx
  8033fe:	89 10                	mov    %edx,(%eax)
  803400:	eb 0a                	jmp    80340c <insert_sorted_with_merge_freeList+0x606>
  803402:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803405:	8b 00                	mov    (%eax),%eax
  803407:	a3 38 51 80 00       	mov    %eax,0x805138
  80340c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80340f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803415:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803418:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80341f:	a1 44 51 80 00       	mov    0x805144,%eax
  803424:	48                   	dec    %eax
  803425:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  80342a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80342d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803434:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803437:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80343e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803442:	75 17                	jne    80345b <insert_sorted_with_merge_freeList+0x655>
  803444:	83 ec 04             	sub    $0x4,%esp
  803447:	68 78 42 80 00       	push   $0x804278
  80344c:	68 6e 01 00 00       	push   $0x16e
  803451:	68 9b 42 80 00       	push   $0x80429b
  803456:	e8 4c d0 ff ff       	call   8004a7 <_panic>
  80345b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803461:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803464:	89 10                	mov    %edx,(%eax)
  803466:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803469:	8b 00                	mov    (%eax),%eax
  80346b:	85 c0                	test   %eax,%eax
  80346d:	74 0d                	je     80347c <insert_sorted_with_merge_freeList+0x676>
  80346f:	a1 48 51 80 00       	mov    0x805148,%eax
  803474:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803477:	89 50 04             	mov    %edx,0x4(%eax)
  80347a:	eb 08                	jmp    803484 <insert_sorted_with_merge_freeList+0x67e>
  80347c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80347f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803484:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803487:	a3 48 51 80 00       	mov    %eax,0x805148
  80348c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80348f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803496:	a1 54 51 80 00       	mov    0x805154,%eax
  80349b:	40                   	inc    %eax
  80349c:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8034a1:	e9 a9 00 00 00       	jmp    80354f <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8034a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034aa:	74 06                	je     8034b2 <insert_sorted_with_merge_freeList+0x6ac>
  8034ac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034b0:	75 17                	jne    8034c9 <insert_sorted_with_merge_freeList+0x6c3>
  8034b2:	83 ec 04             	sub    $0x4,%esp
  8034b5:	68 10 43 80 00       	push   $0x804310
  8034ba:	68 73 01 00 00       	push   $0x173
  8034bf:	68 9b 42 80 00       	push   $0x80429b
  8034c4:	e8 de cf ff ff       	call   8004a7 <_panic>
  8034c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034cc:	8b 10                	mov    (%eax),%edx
  8034ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d1:	89 10                	mov    %edx,(%eax)
  8034d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d6:	8b 00                	mov    (%eax),%eax
  8034d8:	85 c0                	test   %eax,%eax
  8034da:	74 0b                	je     8034e7 <insert_sorted_with_merge_freeList+0x6e1>
  8034dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034df:	8b 00                	mov    (%eax),%eax
  8034e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8034e4:	89 50 04             	mov    %edx,0x4(%eax)
  8034e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8034ed:	89 10                	mov    %edx,(%eax)
  8034ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034f5:	89 50 04             	mov    %edx,0x4(%eax)
  8034f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8034fb:	8b 00                	mov    (%eax),%eax
  8034fd:	85 c0                	test   %eax,%eax
  8034ff:	75 08                	jne    803509 <insert_sorted_with_merge_freeList+0x703>
  803501:	8b 45 08             	mov    0x8(%ebp),%eax
  803504:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803509:	a1 44 51 80 00       	mov    0x805144,%eax
  80350e:	40                   	inc    %eax
  80350f:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803514:	eb 39                	jmp    80354f <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803516:	a1 40 51 80 00       	mov    0x805140,%eax
  80351b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80351e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803522:	74 07                	je     80352b <insert_sorted_with_merge_freeList+0x725>
  803524:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803527:	8b 00                	mov    (%eax),%eax
  803529:	eb 05                	jmp    803530 <insert_sorted_with_merge_freeList+0x72a>
  80352b:	b8 00 00 00 00       	mov    $0x0,%eax
  803530:	a3 40 51 80 00       	mov    %eax,0x805140
  803535:	a1 40 51 80 00       	mov    0x805140,%eax
  80353a:	85 c0                	test   %eax,%eax
  80353c:	0f 85 c7 fb ff ff    	jne    803109 <insert_sorted_with_merge_freeList+0x303>
  803542:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803546:	0f 85 bd fb ff ff    	jne    803109 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80354c:	eb 01                	jmp    80354f <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80354e:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80354f:	90                   	nop
  803550:	c9                   	leave  
  803551:	c3                   	ret    

00803552 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803552:	55                   	push   %ebp
  803553:	89 e5                	mov    %esp,%ebp
  803555:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803558:	8b 55 08             	mov    0x8(%ebp),%edx
  80355b:	89 d0                	mov    %edx,%eax
  80355d:	c1 e0 02             	shl    $0x2,%eax
  803560:	01 d0                	add    %edx,%eax
  803562:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803569:	01 d0                	add    %edx,%eax
  80356b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803572:	01 d0                	add    %edx,%eax
  803574:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80357b:	01 d0                	add    %edx,%eax
  80357d:	c1 e0 04             	shl    $0x4,%eax
  803580:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803583:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  80358a:	8d 45 e8             	lea    -0x18(%ebp),%eax
  80358d:	83 ec 0c             	sub    $0xc,%esp
  803590:	50                   	push   %eax
  803591:	e8 26 e7 ff ff       	call   801cbc <sys_get_virtual_time>
  803596:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803599:	eb 41                	jmp    8035dc <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  80359b:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80359e:	83 ec 0c             	sub    $0xc,%esp
  8035a1:	50                   	push   %eax
  8035a2:	e8 15 e7 ff ff       	call   801cbc <sys_get_virtual_time>
  8035a7:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8035aa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8035ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035b0:	29 c2                	sub    %eax,%edx
  8035b2:	89 d0                	mov    %edx,%eax
  8035b4:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8035b7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035bd:	89 d1                	mov    %edx,%ecx
  8035bf:	29 c1                	sub    %eax,%ecx
  8035c1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8035c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035c7:	39 c2                	cmp    %eax,%edx
  8035c9:	0f 97 c0             	seta   %al
  8035cc:	0f b6 c0             	movzbl %al,%eax
  8035cf:	29 c1                	sub    %eax,%ecx
  8035d1:	89 c8                	mov    %ecx,%eax
  8035d3:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8035d6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8035d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8035dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035df:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8035e2:	72 b7                	jb     80359b <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8035e4:	90                   	nop
  8035e5:	c9                   	leave  
  8035e6:	c3                   	ret    

008035e7 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8035e7:	55                   	push   %ebp
  8035e8:	89 e5                	mov    %esp,%ebp
  8035ea:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8035ed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8035f4:	eb 03                	jmp    8035f9 <busy_wait+0x12>
  8035f6:	ff 45 fc             	incl   -0x4(%ebp)
  8035f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8035fc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8035ff:	72 f5                	jb     8035f6 <busy_wait+0xf>
	return i;
  803601:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803604:	c9                   	leave  
  803605:	c3                   	ret    
  803606:	66 90                	xchg   %ax,%ax

00803608 <__udivdi3>:
  803608:	55                   	push   %ebp
  803609:	57                   	push   %edi
  80360a:	56                   	push   %esi
  80360b:	53                   	push   %ebx
  80360c:	83 ec 1c             	sub    $0x1c,%esp
  80360f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803613:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803617:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80361b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80361f:	89 ca                	mov    %ecx,%edx
  803621:	89 f8                	mov    %edi,%eax
  803623:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803627:	85 f6                	test   %esi,%esi
  803629:	75 2d                	jne    803658 <__udivdi3+0x50>
  80362b:	39 cf                	cmp    %ecx,%edi
  80362d:	77 65                	ja     803694 <__udivdi3+0x8c>
  80362f:	89 fd                	mov    %edi,%ebp
  803631:	85 ff                	test   %edi,%edi
  803633:	75 0b                	jne    803640 <__udivdi3+0x38>
  803635:	b8 01 00 00 00       	mov    $0x1,%eax
  80363a:	31 d2                	xor    %edx,%edx
  80363c:	f7 f7                	div    %edi
  80363e:	89 c5                	mov    %eax,%ebp
  803640:	31 d2                	xor    %edx,%edx
  803642:	89 c8                	mov    %ecx,%eax
  803644:	f7 f5                	div    %ebp
  803646:	89 c1                	mov    %eax,%ecx
  803648:	89 d8                	mov    %ebx,%eax
  80364a:	f7 f5                	div    %ebp
  80364c:	89 cf                	mov    %ecx,%edi
  80364e:	89 fa                	mov    %edi,%edx
  803650:	83 c4 1c             	add    $0x1c,%esp
  803653:	5b                   	pop    %ebx
  803654:	5e                   	pop    %esi
  803655:	5f                   	pop    %edi
  803656:	5d                   	pop    %ebp
  803657:	c3                   	ret    
  803658:	39 ce                	cmp    %ecx,%esi
  80365a:	77 28                	ja     803684 <__udivdi3+0x7c>
  80365c:	0f bd fe             	bsr    %esi,%edi
  80365f:	83 f7 1f             	xor    $0x1f,%edi
  803662:	75 40                	jne    8036a4 <__udivdi3+0x9c>
  803664:	39 ce                	cmp    %ecx,%esi
  803666:	72 0a                	jb     803672 <__udivdi3+0x6a>
  803668:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80366c:	0f 87 9e 00 00 00    	ja     803710 <__udivdi3+0x108>
  803672:	b8 01 00 00 00       	mov    $0x1,%eax
  803677:	89 fa                	mov    %edi,%edx
  803679:	83 c4 1c             	add    $0x1c,%esp
  80367c:	5b                   	pop    %ebx
  80367d:	5e                   	pop    %esi
  80367e:	5f                   	pop    %edi
  80367f:	5d                   	pop    %ebp
  803680:	c3                   	ret    
  803681:	8d 76 00             	lea    0x0(%esi),%esi
  803684:	31 ff                	xor    %edi,%edi
  803686:	31 c0                	xor    %eax,%eax
  803688:	89 fa                	mov    %edi,%edx
  80368a:	83 c4 1c             	add    $0x1c,%esp
  80368d:	5b                   	pop    %ebx
  80368e:	5e                   	pop    %esi
  80368f:	5f                   	pop    %edi
  803690:	5d                   	pop    %ebp
  803691:	c3                   	ret    
  803692:	66 90                	xchg   %ax,%ax
  803694:	89 d8                	mov    %ebx,%eax
  803696:	f7 f7                	div    %edi
  803698:	31 ff                	xor    %edi,%edi
  80369a:	89 fa                	mov    %edi,%edx
  80369c:	83 c4 1c             	add    $0x1c,%esp
  80369f:	5b                   	pop    %ebx
  8036a0:	5e                   	pop    %esi
  8036a1:	5f                   	pop    %edi
  8036a2:	5d                   	pop    %ebp
  8036a3:	c3                   	ret    
  8036a4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8036a9:	89 eb                	mov    %ebp,%ebx
  8036ab:	29 fb                	sub    %edi,%ebx
  8036ad:	89 f9                	mov    %edi,%ecx
  8036af:	d3 e6                	shl    %cl,%esi
  8036b1:	89 c5                	mov    %eax,%ebp
  8036b3:	88 d9                	mov    %bl,%cl
  8036b5:	d3 ed                	shr    %cl,%ebp
  8036b7:	89 e9                	mov    %ebp,%ecx
  8036b9:	09 f1                	or     %esi,%ecx
  8036bb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8036bf:	89 f9                	mov    %edi,%ecx
  8036c1:	d3 e0                	shl    %cl,%eax
  8036c3:	89 c5                	mov    %eax,%ebp
  8036c5:	89 d6                	mov    %edx,%esi
  8036c7:	88 d9                	mov    %bl,%cl
  8036c9:	d3 ee                	shr    %cl,%esi
  8036cb:	89 f9                	mov    %edi,%ecx
  8036cd:	d3 e2                	shl    %cl,%edx
  8036cf:	8b 44 24 08          	mov    0x8(%esp),%eax
  8036d3:	88 d9                	mov    %bl,%cl
  8036d5:	d3 e8                	shr    %cl,%eax
  8036d7:	09 c2                	or     %eax,%edx
  8036d9:	89 d0                	mov    %edx,%eax
  8036db:	89 f2                	mov    %esi,%edx
  8036dd:	f7 74 24 0c          	divl   0xc(%esp)
  8036e1:	89 d6                	mov    %edx,%esi
  8036e3:	89 c3                	mov    %eax,%ebx
  8036e5:	f7 e5                	mul    %ebp
  8036e7:	39 d6                	cmp    %edx,%esi
  8036e9:	72 19                	jb     803704 <__udivdi3+0xfc>
  8036eb:	74 0b                	je     8036f8 <__udivdi3+0xf0>
  8036ed:	89 d8                	mov    %ebx,%eax
  8036ef:	31 ff                	xor    %edi,%edi
  8036f1:	e9 58 ff ff ff       	jmp    80364e <__udivdi3+0x46>
  8036f6:	66 90                	xchg   %ax,%ax
  8036f8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8036fc:	89 f9                	mov    %edi,%ecx
  8036fe:	d3 e2                	shl    %cl,%edx
  803700:	39 c2                	cmp    %eax,%edx
  803702:	73 e9                	jae    8036ed <__udivdi3+0xe5>
  803704:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803707:	31 ff                	xor    %edi,%edi
  803709:	e9 40 ff ff ff       	jmp    80364e <__udivdi3+0x46>
  80370e:	66 90                	xchg   %ax,%ax
  803710:	31 c0                	xor    %eax,%eax
  803712:	e9 37 ff ff ff       	jmp    80364e <__udivdi3+0x46>
  803717:	90                   	nop

00803718 <__umoddi3>:
  803718:	55                   	push   %ebp
  803719:	57                   	push   %edi
  80371a:	56                   	push   %esi
  80371b:	53                   	push   %ebx
  80371c:	83 ec 1c             	sub    $0x1c,%esp
  80371f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803723:	8b 74 24 34          	mov    0x34(%esp),%esi
  803727:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80372b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80372f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803733:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803737:	89 f3                	mov    %esi,%ebx
  803739:	89 fa                	mov    %edi,%edx
  80373b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80373f:	89 34 24             	mov    %esi,(%esp)
  803742:	85 c0                	test   %eax,%eax
  803744:	75 1a                	jne    803760 <__umoddi3+0x48>
  803746:	39 f7                	cmp    %esi,%edi
  803748:	0f 86 a2 00 00 00    	jbe    8037f0 <__umoddi3+0xd8>
  80374e:	89 c8                	mov    %ecx,%eax
  803750:	89 f2                	mov    %esi,%edx
  803752:	f7 f7                	div    %edi
  803754:	89 d0                	mov    %edx,%eax
  803756:	31 d2                	xor    %edx,%edx
  803758:	83 c4 1c             	add    $0x1c,%esp
  80375b:	5b                   	pop    %ebx
  80375c:	5e                   	pop    %esi
  80375d:	5f                   	pop    %edi
  80375e:	5d                   	pop    %ebp
  80375f:	c3                   	ret    
  803760:	39 f0                	cmp    %esi,%eax
  803762:	0f 87 ac 00 00 00    	ja     803814 <__umoddi3+0xfc>
  803768:	0f bd e8             	bsr    %eax,%ebp
  80376b:	83 f5 1f             	xor    $0x1f,%ebp
  80376e:	0f 84 ac 00 00 00    	je     803820 <__umoddi3+0x108>
  803774:	bf 20 00 00 00       	mov    $0x20,%edi
  803779:	29 ef                	sub    %ebp,%edi
  80377b:	89 fe                	mov    %edi,%esi
  80377d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803781:	89 e9                	mov    %ebp,%ecx
  803783:	d3 e0                	shl    %cl,%eax
  803785:	89 d7                	mov    %edx,%edi
  803787:	89 f1                	mov    %esi,%ecx
  803789:	d3 ef                	shr    %cl,%edi
  80378b:	09 c7                	or     %eax,%edi
  80378d:	89 e9                	mov    %ebp,%ecx
  80378f:	d3 e2                	shl    %cl,%edx
  803791:	89 14 24             	mov    %edx,(%esp)
  803794:	89 d8                	mov    %ebx,%eax
  803796:	d3 e0                	shl    %cl,%eax
  803798:	89 c2                	mov    %eax,%edx
  80379a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80379e:	d3 e0                	shl    %cl,%eax
  8037a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8037a4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8037a8:	89 f1                	mov    %esi,%ecx
  8037aa:	d3 e8                	shr    %cl,%eax
  8037ac:	09 d0                	or     %edx,%eax
  8037ae:	d3 eb                	shr    %cl,%ebx
  8037b0:	89 da                	mov    %ebx,%edx
  8037b2:	f7 f7                	div    %edi
  8037b4:	89 d3                	mov    %edx,%ebx
  8037b6:	f7 24 24             	mull   (%esp)
  8037b9:	89 c6                	mov    %eax,%esi
  8037bb:	89 d1                	mov    %edx,%ecx
  8037bd:	39 d3                	cmp    %edx,%ebx
  8037bf:	0f 82 87 00 00 00    	jb     80384c <__umoddi3+0x134>
  8037c5:	0f 84 91 00 00 00    	je     80385c <__umoddi3+0x144>
  8037cb:	8b 54 24 04          	mov    0x4(%esp),%edx
  8037cf:	29 f2                	sub    %esi,%edx
  8037d1:	19 cb                	sbb    %ecx,%ebx
  8037d3:	89 d8                	mov    %ebx,%eax
  8037d5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8037d9:	d3 e0                	shl    %cl,%eax
  8037db:	89 e9                	mov    %ebp,%ecx
  8037dd:	d3 ea                	shr    %cl,%edx
  8037df:	09 d0                	or     %edx,%eax
  8037e1:	89 e9                	mov    %ebp,%ecx
  8037e3:	d3 eb                	shr    %cl,%ebx
  8037e5:	89 da                	mov    %ebx,%edx
  8037e7:	83 c4 1c             	add    $0x1c,%esp
  8037ea:	5b                   	pop    %ebx
  8037eb:	5e                   	pop    %esi
  8037ec:	5f                   	pop    %edi
  8037ed:	5d                   	pop    %ebp
  8037ee:	c3                   	ret    
  8037ef:	90                   	nop
  8037f0:	89 fd                	mov    %edi,%ebp
  8037f2:	85 ff                	test   %edi,%edi
  8037f4:	75 0b                	jne    803801 <__umoddi3+0xe9>
  8037f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8037fb:	31 d2                	xor    %edx,%edx
  8037fd:	f7 f7                	div    %edi
  8037ff:	89 c5                	mov    %eax,%ebp
  803801:	89 f0                	mov    %esi,%eax
  803803:	31 d2                	xor    %edx,%edx
  803805:	f7 f5                	div    %ebp
  803807:	89 c8                	mov    %ecx,%eax
  803809:	f7 f5                	div    %ebp
  80380b:	89 d0                	mov    %edx,%eax
  80380d:	e9 44 ff ff ff       	jmp    803756 <__umoddi3+0x3e>
  803812:	66 90                	xchg   %ax,%ax
  803814:	89 c8                	mov    %ecx,%eax
  803816:	89 f2                	mov    %esi,%edx
  803818:	83 c4 1c             	add    $0x1c,%esp
  80381b:	5b                   	pop    %ebx
  80381c:	5e                   	pop    %esi
  80381d:	5f                   	pop    %edi
  80381e:	5d                   	pop    %ebp
  80381f:	c3                   	ret    
  803820:	3b 04 24             	cmp    (%esp),%eax
  803823:	72 06                	jb     80382b <__umoddi3+0x113>
  803825:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803829:	77 0f                	ja     80383a <__umoddi3+0x122>
  80382b:	89 f2                	mov    %esi,%edx
  80382d:	29 f9                	sub    %edi,%ecx
  80382f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803833:	89 14 24             	mov    %edx,(%esp)
  803836:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80383a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80383e:	8b 14 24             	mov    (%esp),%edx
  803841:	83 c4 1c             	add    $0x1c,%esp
  803844:	5b                   	pop    %ebx
  803845:	5e                   	pop    %esi
  803846:	5f                   	pop    %edi
  803847:	5d                   	pop    %ebp
  803848:	c3                   	ret    
  803849:	8d 76 00             	lea    0x0(%esi),%esi
  80384c:	2b 04 24             	sub    (%esp),%eax
  80384f:	19 fa                	sbb    %edi,%edx
  803851:	89 d1                	mov    %edx,%ecx
  803853:	89 c6                	mov    %eax,%esi
  803855:	e9 71 ff ff ff       	jmp    8037cb <__umoddi3+0xb3>
  80385a:	66 90                	xchg   %ax,%ax
  80385c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803860:	72 ea                	jb     80384c <__umoddi3+0x134>
  803862:	89 d9                	mov    %ebx,%ecx
  803864:	e9 62 ff ff ff       	jmp    8037cb <__umoddi3+0xb3>
