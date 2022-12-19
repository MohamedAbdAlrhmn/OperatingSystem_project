
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
  80008d:	68 e0 39 80 00       	push   $0x8039e0
  800092:	6a 13                	push   $0x13
  800094:	68 fc 39 80 00       	push   $0x8039fc
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
  8000ab:	e8 50 1a 00 00       	call   801b00 <sys_calculate_free_frames>
  8000b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	x = smalloc("x", 4, 0);
  8000b3:	83 ec 04             	sub    $0x4,%esp
  8000b6:	6a 00                	push   $0x0
  8000b8:	6a 04                	push   $0x4
  8000ba:	68 17 3a 80 00       	push   $0x803a17
  8000bf:	e8 6a 17 00 00       	call   80182e <smalloc>
  8000c4:	83 c4 10             	add    $0x10,%esp
  8000c7:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if (x != (uint32*)USER_HEAP_START) panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8000ca:	81 7d e8 00 00 00 80 	cmpl   $0x80000000,-0x18(%ebp)
  8000d1:	74 14                	je     8000e7 <_main+0xaf>
  8000d3:	83 ec 04             	sub    $0x4,%esp
  8000d6:	68 1c 3a 80 00       	push   $0x803a1c
  8000db:	6a 1e                	push   $0x1e
  8000dd:	68 fc 39 80 00       	push   $0x8039fc
  8000e2:	e8 c0 03 00 00       	call   8004a7 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Create(): Wrong allocation- make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8000e7:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000ea:	e8 11 1a 00 00       	call   801b00 <sys_calculate_free_frames>
  8000ef:	29 c3                	sub    %eax,%ebx
  8000f1:	89 d8                	mov    %ebx,%eax
  8000f3:	83 f8 04             	cmp    $0x4,%eax
  8000f6:	74 14                	je     80010c <_main+0xd4>
  8000f8:	83 ec 04             	sub    $0x4,%esp
  8000fb:	68 80 3a 80 00       	push   $0x803a80
  800100:	6a 1f                	push   $0x1f
  800102:	68 fc 39 80 00       	push   $0x8039fc
  800107:	e8 9b 03 00 00       	call   8004a7 <_panic>

	//y: Readonly
	freeFrames = sys_calculate_free_frames() ;
  80010c:	e8 ef 19 00 00       	call   801b00 <sys_calculate_free_frames>
  800111:	89 45 ec             	mov    %eax,-0x14(%ebp)
	y = smalloc("y", 4, 0);
  800114:	83 ec 04             	sub    $0x4,%esp
  800117:	6a 00                	push   $0x0
  800119:	6a 04                	push   $0x4
  80011b:	68 08 3b 80 00       	push   $0x803b08
  800120:	e8 09 17 00 00       	call   80182e <smalloc>
  800125:	83 c4 10             	add    $0x10,%esp
  800128:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (y != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  80012b:	81 7d e4 00 10 00 80 	cmpl   $0x80001000,-0x1c(%ebp)
  800132:	74 14                	je     800148 <_main+0x110>
  800134:	83 ec 04             	sub    $0x4,%esp
  800137:	68 1c 3a 80 00       	push   $0x803a1c
  80013c:	6a 24                	push   $0x24
  80013e:	68 fc 39 80 00       	push   $0x8039fc
  800143:	e8 5f 03 00 00       	call   8004a7 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1+0+2) panic("Create(): Wrong allocation- make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800148:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  80014b:	e8 b0 19 00 00       	call   801b00 <sys_calculate_free_frames>
  800150:	29 c3                	sub    %eax,%ebx
  800152:	89 d8                	mov    %ebx,%eax
  800154:	83 f8 03             	cmp    $0x3,%eax
  800157:	74 14                	je     80016d <_main+0x135>
  800159:	83 ec 04             	sub    $0x4,%esp
  80015c:	68 80 3a 80 00       	push   $0x803a80
  800161:	6a 25                	push   $0x25
  800163:	68 fc 39 80 00       	push   $0x8039fc
  800168:	e8 3a 03 00 00       	call   8004a7 <_panic>

	//z: Writable
	freeFrames = sys_calculate_free_frames() ;
  80016d:	e8 8e 19 00 00       	call   801b00 <sys_calculate_free_frames>
  800172:	89 45 ec             	mov    %eax,-0x14(%ebp)
	z = smalloc("z", 4, 1);
  800175:	83 ec 04             	sub    $0x4,%esp
  800178:	6a 01                	push   $0x1
  80017a:	6a 04                	push   $0x4
  80017c:	68 0a 3b 80 00       	push   $0x803b0a
  800181:	e8 a8 16 00 00       	call   80182e <smalloc>
  800186:	83 c4 10             	add    $0x10,%esp
  800189:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (z != (uint32*)(USER_HEAP_START + 2 * PAGE_SIZE)) panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  80018c:	81 7d e0 00 20 00 80 	cmpl   $0x80002000,-0x20(%ebp)
  800193:	74 14                	je     8001a9 <_main+0x171>
  800195:	83 ec 04             	sub    $0x4,%esp
  800198:	68 1c 3a 80 00       	push   $0x803a1c
  80019d:	6a 2a                	push   $0x2a
  80019f:	68 fc 39 80 00       	push   $0x8039fc
  8001a4:	e8 fe 02 00 00       	call   8004a7 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1+0+2) panic("Create(): Wrong allocation- make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8001a9:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8001ac:	e8 4f 19 00 00       	call   801b00 <sys_calculate_free_frames>
  8001b1:	29 c3                	sub    %eax,%ebx
  8001b3:	89 d8                	mov    %ebx,%eax
  8001b5:	83 f8 03             	cmp    $0x3,%eax
  8001b8:	74 14                	je     8001ce <_main+0x196>
  8001ba:	83 ec 04             	sub    $0x4,%esp
  8001bd:	68 80 3a 80 00       	push   $0x803a80
  8001c2:	6a 2b                	push   $0x2b
  8001c4:	68 fc 39 80 00       	push   $0x8039fc
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
  800203:	68 0c 3b 80 00       	push   $0x803b0c
  800208:	e8 65 1b 00 00       	call   801d72 <sys_create_env>
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
  800236:	68 0c 3b 80 00       	push   $0x803b0c
  80023b:	e8 32 1b 00 00       	call   801d72 <sys_create_env>
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
  800269:	68 0c 3b 80 00       	push   $0x803b0c
  80026e:	e8 ff 1a 00 00       	call   801d72 <sys_create_env>
  800273:	83 c4 10             	add    $0x10,%esp
  800276:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	//to check that the slave environments completed successfully
	rsttst();
  800279:	e8 40 1c 00 00       	call   801ebe <rsttst>

	sys_run_env(id1);
  80027e:	83 ec 0c             	sub    $0xc,%esp
  800281:	ff 75 dc             	pushl  -0x24(%ebp)
  800284:	e8 07 1b 00 00       	call   801d90 <sys_run_env>
  800289:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id2);
  80028c:	83 ec 0c             	sub    $0xc,%esp
  80028f:	ff 75 d8             	pushl  -0x28(%ebp)
  800292:	e8 f9 1a 00 00       	call   801d90 <sys_run_env>
  800297:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id3);
  80029a:	83 ec 0c             	sub    $0xc,%esp
  80029d:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002a0:	e8 eb 1a 00 00       	call   801d90 <sys_run_env>
  8002a5:	83 c4 10             	add    $0x10,%esp

	env_sleep(12000) ;
  8002a8:	83 ec 0c             	sub    $0xc,%esp
  8002ab:	68 e0 2e 00 00       	push   $0x2ee0
  8002b0:	e8 0d 34 00 00       	call   8036c2 <env_sleep>
  8002b5:	83 c4 10             	add    $0x10,%esp

	//to ensure that the slave environments completed successfully
	if (gettst()!=3) panic("test failed");
  8002b8:	e8 7b 1c 00 00       	call   801f38 <gettst>
  8002bd:	83 f8 03             	cmp    $0x3,%eax
  8002c0:	74 14                	je     8002d6 <_main+0x29e>
  8002c2:	83 ec 04             	sub    $0x4,%esp
  8002c5:	68 17 3b 80 00       	push   $0x803b17
  8002ca:	6a 3f                	push   $0x3f
  8002cc:	68 fc 39 80 00       	push   $0x8039fc
  8002d1:	e8 d1 01 00 00       	call   8004a7 <_panic>


	if (*z != 30)
  8002d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002d9:	8b 00                	mov    (%eax),%eax
  8002db:	83 f8 1e             	cmp    $0x1e,%eax
  8002de:	74 14                	je     8002f4 <_main+0x2bc>
		panic("Error!! Please check the creation (or the getting) of shared variables!!\n\n\n");
  8002e0:	83 ec 04             	sub    $0x4,%esp
  8002e3:	68 24 3b 80 00       	push   $0x803b24
  8002e8:	6a 43                	push   $0x43
  8002ea:	68 fc 39 80 00       	push   $0x8039fc
  8002ef:	e8 b3 01 00 00       	call   8004a7 <_panic>
	else
		cprintf("Congratulations!! Test of Shared Variables [Create & Get] [2] completed successfully!!\n\n\n");
  8002f4:	83 ec 0c             	sub    $0xc,%esp
  8002f7:	68 70 3b 80 00       	push   $0x803b70
  8002fc:	e8 5a 04 00 00       	call   80075b <cprintf>
  800301:	83 c4 10             	add    $0x10,%esp

	cprintf("Now, ILLEGAL MEM ACCESS should be occur, due to attempting to write a ReadOnly variable\n\n\n");
  800304:	83 ec 0c             	sub    $0xc,%esp
  800307:	68 cc 3b 80 00       	push   $0x803bcc
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
  800337:	68 27 3c 80 00       	push   $0x803c27
  80033c:	e8 31 1a 00 00       	call   801d72 <sys_create_env>
  800341:	83 c4 10             	add    $0x10,%esp
  800344:	89 45 dc             	mov    %eax,-0x24(%ebp)

	env_sleep(3000) ;
  800347:	83 ec 0c             	sub    $0xc,%esp
  80034a:	68 b8 0b 00 00       	push   $0xbb8
  80034f:	e8 6e 33 00 00       	call   8036c2 <env_sleep>
  800354:	83 c4 10             	add    $0x10,%esp

	sys_run_env(id1);
  800357:	83 ec 0c             	sub    $0xc,%esp
  80035a:	ff 75 dc             	pushl  -0x24(%ebp)
  80035d:	e8 2e 1a 00 00       	call   801d90 <sys_run_env>
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
  800371:	e8 6a 1a 00 00       	call   801de0 <sys_getenvindex>
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
  8003dc:	e8 0c 18 00 00       	call   801bed <sys_disable_interrupt>
	cprintf("**************************************\n");
  8003e1:	83 ec 0c             	sub    $0xc,%esp
  8003e4:	68 4c 3c 80 00       	push   $0x803c4c
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
  80040c:	68 74 3c 80 00       	push   $0x803c74
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
  80043d:	68 9c 3c 80 00       	push   $0x803c9c
  800442:	e8 14 03 00 00       	call   80075b <cprintf>
  800447:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80044a:	a1 20 50 80 00       	mov    0x805020,%eax
  80044f:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800455:	83 ec 08             	sub    $0x8,%esp
  800458:	50                   	push   %eax
  800459:	68 f4 3c 80 00       	push   $0x803cf4
  80045e:	e8 f8 02 00 00       	call   80075b <cprintf>
  800463:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800466:	83 ec 0c             	sub    $0xc,%esp
  800469:	68 4c 3c 80 00       	push   $0x803c4c
  80046e:	e8 e8 02 00 00       	call   80075b <cprintf>
  800473:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800476:	e8 8c 17 00 00       	call   801c07 <sys_enable_interrupt>

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
  80048e:	e8 19 19 00 00       	call   801dac <sys_destroy_env>
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
  80049f:	e8 6e 19 00 00       	call   801e12 <sys_exit_env>
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
  8004c8:	68 08 3d 80 00       	push   $0x803d08
  8004cd:	e8 89 02 00 00       	call   80075b <cprintf>
  8004d2:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8004d5:	a1 00 50 80 00       	mov    0x805000,%eax
  8004da:	ff 75 0c             	pushl  0xc(%ebp)
  8004dd:	ff 75 08             	pushl  0x8(%ebp)
  8004e0:	50                   	push   %eax
  8004e1:	68 0d 3d 80 00       	push   $0x803d0d
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
  800505:	68 29 3d 80 00       	push   $0x803d29
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
  800531:	68 2c 3d 80 00       	push   $0x803d2c
  800536:	6a 26                	push   $0x26
  800538:	68 78 3d 80 00       	push   $0x803d78
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
  800603:	68 84 3d 80 00       	push   $0x803d84
  800608:	6a 3a                	push   $0x3a
  80060a:	68 78 3d 80 00       	push   $0x803d78
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
  800673:	68 d8 3d 80 00       	push   $0x803dd8
  800678:	6a 44                	push   $0x44
  80067a:	68 78 3d 80 00       	push   $0x803d78
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
  8006cd:	e8 6d 13 00 00       	call   801a3f <sys_cputs>
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
  800744:	e8 f6 12 00 00       	call   801a3f <sys_cputs>
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
  80078e:	e8 5a 14 00 00       	call   801bed <sys_disable_interrupt>
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
  8007ae:	e8 54 14 00 00       	call   801c07 <sys_enable_interrupt>
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
  8007f8:	e8 7b 2f 00 00       	call   803778 <__udivdi3>
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
  800848:	e8 3b 30 00 00       	call   803888 <__umoddi3>
  80084d:	83 c4 10             	add    $0x10,%esp
  800850:	05 54 40 80 00       	add    $0x804054,%eax
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
  8009a3:	8b 04 85 78 40 80 00 	mov    0x804078(,%eax,4),%eax
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
  800a84:	8b 34 9d c0 3e 80 00 	mov    0x803ec0(,%ebx,4),%esi
  800a8b:	85 f6                	test   %esi,%esi
  800a8d:	75 19                	jne    800aa8 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a8f:	53                   	push   %ebx
  800a90:	68 65 40 80 00       	push   $0x804065
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
  800aa9:	68 6e 40 80 00       	push   $0x80406e
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
  800ad6:	be 71 40 80 00       	mov    $0x804071,%esi
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
  8014fc:	68 d0 41 80 00       	push   $0x8041d0
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
  8015cc:	e8 b2 05 00 00       	call   801b83 <sys_allocate_chunk>
  8015d1:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8015d4:	a1 20 51 80 00       	mov    0x805120,%eax
  8015d9:	83 ec 0c             	sub    $0xc,%esp
  8015dc:	50                   	push   %eax
  8015dd:	e8 27 0c 00 00       	call   802209 <initialize_MemBlocksList>
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
  80160a:	68 f5 41 80 00       	push   $0x8041f5
  80160f:	6a 33                	push   $0x33
  801611:	68 13 42 80 00       	push   $0x804213
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
  801689:	68 20 42 80 00       	push   $0x804220
  80168e:	6a 34                	push   $0x34
  801690:	68 13 42 80 00       	push   $0x804213
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
  801721:	e8 2b 08 00 00       	call   801f51 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801726:	85 c0                	test   %eax,%eax
  801728:	74 11                	je     80173b <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  80172a:	83 ec 0c             	sub    $0xc,%esp
  80172d:	ff 75 e8             	pushl  -0x18(%ebp)
  801730:	e8 96 0e 00 00       	call   8025cb <alloc_block_FF>
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
  801747:	e8 f2 0b 00 00       	call   80233e <insert_sorted_allocList>
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
  801761:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	struct MemBlock * free_block=find_block(&AllocMemBlocksList,(uint32)virtual_address);
  801764:	8b 45 08             	mov    0x8(%ebp),%eax
  801767:	83 ec 08             	sub    $0x8,%esp
  80176a:	50                   	push   %eax
  80176b:	68 40 50 80 00       	push   $0x805040
  801770:	e8 71 0b 00 00       	call   8022e6 <find_block>
  801775:	83 c4 10             	add    $0x10,%esp
  801778:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(free_block!=NULL)
  80177b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80177f:	0f 84 a6 00 00 00    	je     80182b <free+0xcd>
	{
		sys_free_user_mem(free_block->sva,free_block->size);
  801785:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801788:	8b 50 0c             	mov    0xc(%eax),%edx
  80178b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80178e:	8b 40 08             	mov    0x8(%eax),%eax
  801791:	83 ec 08             	sub    $0x8,%esp
  801794:	52                   	push   %edx
  801795:	50                   	push   %eax
  801796:	e8 b0 03 00 00       	call   801b4b <sys_free_user_mem>
  80179b:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,free_block);
  80179e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8017a2:	75 14                	jne    8017b8 <free+0x5a>
  8017a4:	83 ec 04             	sub    $0x4,%esp
  8017a7:	68 f5 41 80 00       	push   $0x8041f5
  8017ac:	6a 74                	push   $0x74
  8017ae:	68 13 42 80 00       	push   $0x804213
  8017b3:	e8 ef ec ff ff       	call   8004a7 <_panic>
  8017b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017bb:	8b 00                	mov    (%eax),%eax
  8017bd:	85 c0                	test   %eax,%eax
  8017bf:	74 10                	je     8017d1 <free+0x73>
  8017c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017c4:	8b 00                	mov    (%eax),%eax
  8017c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017c9:	8b 52 04             	mov    0x4(%edx),%edx
  8017cc:	89 50 04             	mov    %edx,0x4(%eax)
  8017cf:	eb 0b                	jmp    8017dc <free+0x7e>
  8017d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017d4:	8b 40 04             	mov    0x4(%eax),%eax
  8017d7:	a3 44 50 80 00       	mov    %eax,0x805044
  8017dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017df:	8b 40 04             	mov    0x4(%eax),%eax
  8017e2:	85 c0                	test   %eax,%eax
  8017e4:	74 0f                	je     8017f5 <free+0x97>
  8017e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017e9:	8b 40 04             	mov    0x4(%eax),%eax
  8017ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017ef:	8b 12                	mov    (%edx),%edx
  8017f1:	89 10                	mov    %edx,(%eax)
  8017f3:	eb 0a                	jmp    8017ff <free+0xa1>
  8017f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017f8:	8b 00                	mov    (%eax),%eax
  8017fa:	a3 40 50 80 00       	mov    %eax,0x805040
  8017ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801802:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801808:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80180b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801812:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801817:	48                   	dec    %eax
  801818:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(free_block);
  80181d:	83 ec 0c             	sub    $0xc,%esp
  801820:	ff 75 f4             	pushl  -0xc(%ebp)
  801823:	e8 4e 17 00 00       	call   802f76 <insert_sorted_with_merge_freeList>
  801828:	83 c4 10             	add    $0x10,%esp
	}

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  80182b:	90                   	nop
  80182c:	c9                   	leave  
  80182d:	c3                   	ret    

0080182e <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80182e:	55                   	push   %ebp
  80182f:	89 e5                	mov    %esp,%ebp
  801831:	83 ec 38             	sub    $0x38,%esp
  801834:	8b 45 10             	mov    0x10(%ebp),%eax
  801837:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80183a:	e8 a6 fc ff ff       	call   8014e5 <InitializeUHeap>
	if (size == 0) return NULL ;
  80183f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801843:	75 0a                	jne    80184f <smalloc+0x21>
  801845:	b8 00 00 00 00       	mov    $0x0,%eax
  80184a:	e9 8b 00 00 00       	jmp    8018da <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  80184f:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801856:	8b 55 0c             	mov    0xc(%ebp),%edx
  801859:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80185c:	01 d0                	add    %edx,%eax
  80185e:	48                   	dec    %eax
  80185f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801862:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801865:	ba 00 00 00 00       	mov    $0x0,%edx
  80186a:	f7 75 f0             	divl   -0x10(%ebp)
  80186d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801870:	29 d0                	sub    %edx,%eax
  801872:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801875:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  80187c:	e8 d0 06 00 00       	call   801f51 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801881:	85 c0                	test   %eax,%eax
  801883:	74 11                	je     801896 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  801885:	83 ec 0c             	sub    $0xc,%esp
  801888:	ff 75 e8             	pushl  -0x18(%ebp)
  80188b:	e8 3b 0d 00 00       	call   8025cb <alloc_block_FF>
  801890:	83 c4 10             	add    $0x10,%esp
  801893:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  801896:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80189a:	74 39                	je     8018d5 <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  80189c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80189f:	8b 40 08             	mov    0x8(%eax),%eax
  8018a2:	89 c2                	mov    %eax,%edx
  8018a4:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8018a8:	52                   	push   %edx
  8018a9:	50                   	push   %eax
  8018aa:	ff 75 0c             	pushl  0xc(%ebp)
  8018ad:	ff 75 08             	pushl  0x8(%ebp)
  8018b0:	e8 21 04 00 00       	call   801cd6 <sys_createSharedObject>
  8018b5:	83 c4 10             	add    $0x10,%esp
  8018b8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  8018bb:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  8018bf:	74 14                	je     8018d5 <smalloc+0xa7>
  8018c1:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  8018c5:	74 0e                	je     8018d5 <smalloc+0xa7>
  8018c7:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  8018cb:	74 08                	je     8018d5 <smalloc+0xa7>
			return (void*) mem_block->sva;
  8018cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018d0:	8b 40 08             	mov    0x8(%eax),%eax
  8018d3:	eb 05                	jmp    8018da <smalloc+0xac>
	}
	return NULL;
  8018d5:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8018da:	c9                   	leave  
  8018db:	c3                   	ret    

008018dc <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8018dc:	55                   	push   %ebp
  8018dd:	89 e5                	mov    %esp,%ebp
  8018df:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8018e2:	e8 fe fb ff ff       	call   8014e5 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8018e7:	83 ec 08             	sub    $0x8,%esp
  8018ea:	ff 75 0c             	pushl  0xc(%ebp)
  8018ed:	ff 75 08             	pushl  0x8(%ebp)
  8018f0:	e8 0b 04 00 00       	call   801d00 <sys_getSizeOfSharedObject>
  8018f5:	83 c4 10             	add    $0x10,%esp
  8018f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  8018fb:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  8018ff:	74 76                	je     801977 <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801901:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801908:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80190b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80190e:	01 d0                	add    %edx,%eax
  801910:	48                   	dec    %eax
  801911:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801914:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801917:	ba 00 00 00 00       	mov    $0x0,%edx
  80191c:	f7 75 ec             	divl   -0x14(%ebp)
  80191f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801922:	29 d0                	sub    %edx,%eax
  801924:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  801927:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  80192e:	e8 1e 06 00 00       	call   801f51 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801933:	85 c0                	test   %eax,%eax
  801935:	74 11                	je     801948 <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  801937:	83 ec 0c             	sub    $0xc,%esp
  80193a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80193d:	e8 89 0c 00 00       	call   8025cb <alloc_block_FF>
  801942:	83 c4 10             	add    $0x10,%esp
  801945:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  801948:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80194c:	74 29                	je     801977 <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  80194e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801951:	8b 40 08             	mov    0x8(%eax),%eax
  801954:	83 ec 04             	sub    $0x4,%esp
  801957:	50                   	push   %eax
  801958:	ff 75 0c             	pushl  0xc(%ebp)
  80195b:	ff 75 08             	pushl  0x8(%ebp)
  80195e:	e8 ba 03 00 00       	call   801d1d <sys_getSharedObject>
  801963:	83 c4 10             	add    $0x10,%esp
  801966:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  801969:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  80196d:	74 08                	je     801977 <sget+0x9b>
				return (void *)mem_block->sva;
  80196f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801972:	8b 40 08             	mov    0x8(%eax),%eax
  801975:	eb 05                	jmp    80197c <sget+0xa0>
		}
	}
	return NULL;
  801977:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80197c:	c9                   	leave  
  80197d:	c3                   	ret    

0080197e <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80197e:	55                   	push   %ebp
  80197f:	89 e5                	mov    %esp,%ebp
  801981:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801984:	e8 5c fb ff ff       	call   8014e5 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801989:	83 ec 04             	sub    $0x4,%esp
  80198c:	68 44 42 80 00       	push   $0x804244
  801991:	68 f7 00 00 00       	push   $0xf7
  801996:	68 13 42 80 00       	push   $0x804213
  80199b:	e8 07 eb ff ff       	call   8004a7 <_panic>

008019a0 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8019a0:	55                   	push   %ebp
  8019a1:	89 e5                	mov    %esp,%ebp
  8019a3:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8019a6:	83 ec 04             	sub    $0x4,%esp
  8019a9:	68 6c 42 80 00       	push   $0x80426c
  8019ae:	68 0b 01 00 00       	push   $0x10b
  8019b3:	68 13 42 80 00       	push   $0x804213
  8019b8:	e8 ea ea ff ff       	call   8004a7 <_panic>

008019bd <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8019bd:	55                   	push   %ebp
  8019be:	89 e5                	mov    %esp,%ebp
  8019c0:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019c3:	83 ec 04             	sub    $0x4,%esp
  8019c6:	68 90 42 80 00       	push   $0x804290
  8019cb:	68 16 01 00 00       	push   $0x116
  8019d0:	68 13 42 80 00       	push   $0x804213
  8019d5:	e8 cd ea ff ff       	call   8004a7 <_panic>

008019da <shrink>:

}
void shrink(uint32 newSize)
{
  8019da:	55                   	push   %ebp
  8019db:	89 e5                	mov    %esp,%ebp
  8019dd:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019e0:	83 ec 04             	sub    $0x4,%esp
  8019e3:	68 90 42 80 00       	push   $0x804290
  8019e8:	68 1b 01 00 00       	push   $0x11b
  8019ed:	68 13 42 80 00       	push   $0x804213
  8019f2:	e8 b0 ea ff ff       	call   8004a7 <_panic>

008019f7 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8019f7:	55                   	push   %ebp
  8019f8:	89 e5                	mov    %esp,%ebp
  8019fa:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019fd:	83 ec 04             	sub    $0x4,%esp
  801a00:	68 90 42 80 00       	push   $0x804290
  801a05:	68 20 01 00 00       	push   $0x120
  801a0a:	68 13 42 80 00       	push   $0x804213
  801a0f:	e8 93 ea ff ff       	call   8004a7 <_panic>

00801a14 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801a14:	55                   	push   %ebp
  801a15:	89 e5                	mov    %esp,%ebp
  801a17:	57                   	push   %edi
  801a18:	56                   	push   %esi
  801a19:	53                   	push   %ebx
  801a1a:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a20:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a23:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a26:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a29:	8b 7d 18             	mov    0x18(%ebp),%edi
  801a2c:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801a2f:	cd 30                	int    $0x30
  801a31:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801a34:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801a37:	83 c4 10             	add    $0x10,%esp
  801a3a:	5b                   	pop    %ebx
  801a3b:	5e                   	pop    %esi
  801a3c:	5f                   	pop    %edi
  801a3d:	5d                   	pop    %ebp
  801a3e:	c3                   	ret    

00801a3f <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801a3f:	55                   	push   %ebp
  801a40:	89 e5                	mov    %esp,%ebp
  801a42:	83 ec 04             	sub    $0x4,%esp
  801a45:	8b 45 10             	mov    0x10(%ebp),%eax
  801a48:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801a4b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a52:	6a 00                	push   $0x0
  801a54:	6a 00                	push   $0x0
  801a56:	52                   	push   %edx
  801a57:	ff 75 0c             	pushl  0xc(%ebp)
  801a5a:	50                   	push   %eax
  801a5b:	6a 00                	push   $0x0
  801a5d:	e8 b2 ff ff ff       	call   801a14 <syscall>
  801a62:	83 c4 18             	add    $0x18,%esp
}
  801a65:	90                   	nop
  801a66:	c9                   	leave  
  801a67:	c3                   	ret    

00801a68 <sys_cgetc>:

int
sys_cgetc(void)
{
  801a68:	55                   	push   %ebp
  801a69:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801a6b:	6a 00                	push   $0x0
  801a6d:	6a 00                	push   $0x0
  801a6f:	6a 00                	push   $0x0
  801a71:	6a 00                	push   $0x0
  801a73:	6a 00                	push   $0x0
  801a75:	6a 01                	push   $0x1
  801a77:	e8 98 ff ff ff       	call   801a14 <syscall>
  801a7c:	83 c4 18             	add    $0x18,%esp
}
  801a7f:	c9                   	leave  
  801a80:	c3                   	ret    

00801a81 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801a81:	55                   	push   %ebp
  801a82:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801a84:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a87:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 00                	push   $0x0
  801a8e:	6a 00                	push   $0x0
  801a90:	52                   	push   %edx
  801a91:	50                   	push   %eax
  801a92:	6a 05                	push   $0x5
  801a94:	e8 7b ff ff ff       	call   801a14 <syscall>
  801a99:	83 c4 18             	add    $0x18,%esp
}
  801a9c:	c9                   	leave  
  801a9d:	c3                   	ret    

00801a9e <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801a9e:	55                   	push   %ebp
  801a9f:	89 e5                	mov    %esp,%ebp
  801aa1:	56                   	push   %esi
  801aa2:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801aa3:	8b 75 18             	mov    0x18(%ebp),%esi
  801aa6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801aa9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801aac:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aaf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab2:	56                   	push   %esi
  801ab3:	53                   	push   %ebx
  801ab4:	51                   	push   %ecx
  801ab5:	52                   	push   %edx
  801ab6:	50                   	push   %eax
  801ab7:	6a 06                	push   $0x6
  801ab9:	e8 56 ff ff ff       	call   801a14 <syscall>
  801abe:	83 c4 18             	add    $0x18,%esp
}
  801ac1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ac4:	5b                   	pop    %ebx
  801ac5:	5e                   	pop    %esi
  801ac6:	5d                   	pop    %ebp
  801ac7:	c3                   	ret    

00801ac8 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801ac8:	55                   	push   %ebp
  801ac9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801acb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ace:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad1:	6a 00                	push   $0x0
  801ad3:	6a 00                	push   $0x0
  801ad5:	6a 00                	push   $0x0
  801ad7:	52                   	push   %edx
  801ad8:	50                   	push   %eax
  801ad9:	6a 07                	push   $0x7
  801adb:	e8 34 ff ff ff       	call   801a14 <syscall>
  801ae0:	83 c4 18             	add    $0x18,%esp
}
  801ae3:	c9                   	leave  
  801ae4:	c3                   	ret    

00801ae5 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801ae5:	55                   	push   %ebp
  801ae6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801ae8:	6a 00                	push   $0x0
  801aea:	6a 00                	push   $0x0
  801aec:	6a 00                	push   $0x0
  801aee:	ff 75 0c             	pushl  0xc(%ebp)
  801af1:	ff 75 08             	pushl  0x8(%ebp)
  801af4:	6a 08                	push   $0x8
  801af6:	e8 19 ff ff ff       	call   801a14 <syscall>
  801afb:	83 c4 18             	add    $0x18,%esp
}
  801afe:	c9                   	leave  
  801aff:	c3                   	ret    

00801b00 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801b00:	55                   	push   %ebp
  801b01:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801b03:	6a 00                	push   $0x0
  801b05:	6a 00                	push   $0x0
  801b07:	6a 00                	push   $0x0
  801b09:	6a 00                	push   $0x0
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 09                	push   $0x9
  801b0f:	e8 00 ff ff ff       	call   801a14 <syscall>
  801b14:	83 c4 18             	add    $0x18,%esp
}
  801b17:	c9                   	leave  
  801b18:	c3                   	ret    

00801b19 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801b19:	55                   	push   %ebp
  801b1a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801b1c:	6a 00                	push   $0x0
  801b1e:	6a 00                	push   $0x0
  801b20:	6a 00                	push   $0x0
  801b22:	6a 00                	push   $0x0
  801b24:	6a 00                	push   $0x0
  801b26:	6a 0a                	push   $0xa
  801b28:	e8 e7 fe ff ff       	call   801a14 <syscall>
  801b2d:	83 c4 18             	add    $0x18,%esp
}
  801b30:	c9                   	leave  
  801b31:	c3                   	ret    

00801b32 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801b32:	55                   	push   %ebp
  801b33:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801b35:	6a 00                	push   $0x0
  801b37:	6a 00                	push   $0x0
  801b39:	6a 00                	push   $0x0
  801b3b:	6a 00                	push   $0x0
  801b3d:	6a 00                	push   $0x0
  801b3f:	6a 0b                	push   $0xb
  801b41:	e8 ce fe ff ff       	call   801a14 <syscall>
  801b46:	83 c4 18             	add    $0x18,%esp
}
  801b49:	c9                   	leave  
  801b4a:	c3                   	ret    

00801b4b <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801b4b:	55                   	push   %ebp
  801b4c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801b4e:	6a 00                	push   $0x0
  801b50:	6a 00                	push   $0x0
  801b52:	6a 00                	push   $0x0
  801b54:	ff 75 0c             	pushl  0xc(%ebp)
  801b57:	ff 75 08             	pushl  0x8(%ebp)
  801b5a:	6a 0f                	push   $0xf
  801b5c:	e8 b3 fe ff ff       	call   801a14 <syscall>
  801b61:	83 c4 18             	add    $0x18,%esp
	return;
  801b64:	90                   	nop
}
  801b65:	c9                   	leave  
  801b66:	c3                   	ret    

00801b67 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801b67:	55                   	push   %ebp
  801b68:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801b6a:	6a 00                	push   $0x0
  801b6c:	6a 00                	push   $0x0
  801b6e:	6a 00                	push   $0x0
  801b70:	ff 75 0c             	pushl  0xc(%ebp)
  801b73:	ff 75 08             	pushl  0x8(%ebp)
  801b76:	6a 10                	push   $0x10
  801b78:	e8 97 fe ff ff       	call   801a14 <syscall>
  801b7d:	83 c4 18             	add    $0x18,%esp
	return ;
  801b80:	90                   	nop
}
  801b81:	c9                   	leave  
  801b82:	c3                   	ret    

00801b83 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801b83:	55                   	push   %ebp
  801b84:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801b86:	6a 00                	push   $0x0
  801b88:	6a 00                	push   $0x0
  801b8a:	ff 75 10             	pushl  0x10(%ebp)
  801b8d:	ff 75 0c             	pushl  0xc(%ebp)
  801b90:	ff 75 08             	pushl  0x8(%ebp)
  801b93:	6a 11                	push   $0x11
  801b95:	e8 7a fe ff ff       	call   801a14 <syscall>
  801b9a:	83 c4 18             	add    $0x18,%esp
	return ;
  801b9d:	90                   	nop
}
  801b9e:	c9                   	leave  
  801b9f:	c3                   	ret    

00801ba0 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801ba0:	55                   	push   %ebp
  801ba1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801ba3:	6a 00                	push   $0x0
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 00                	push   $0x0
  801bab:	6a 00                	push   $0x0
  801bad:	6a 0c                	push   $0xc
  801baf:	e8 60 fe ff ff       	call   801a14 <syscall>
  801bb4:	83 c4 18             	add    $0x18,%esp
}
  801bb7:	c9                   	leave  
  801bb8:	c3                   	ret    

00801bb9 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801bb9:	55                   	push   %ebp
  801bba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801bbc:	6a 00                	push   $0x0
  801bbe:	6a 00                	push   $0x0
  801bc0:	6a 00                	push   $0x0
  801bc2:	6a 00                	push   $0x0
  801bc4:	ff 75 08             	pushl  0x8(%ebp)
  801bc7:	6a 0d                	push   $0xd
  801bc9:	e8 46 fe ff ff       	call   801a14 <syscall>
  801bce:	83 c4 18             	add    $0x18,%esp
}
  801bd1:	c9                   	leave  
  801bd2:	c3                   	ret    

00801bd3 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801bd3:	55                   	push   %ebp
  801bd4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801bd6:	6a 00                	push   $0x0
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 00                	push   $0x0
  801bdc:	6a 00                	push   $0x0
  801bde:	6a 00                	push   $0x0
  801be0:	6a 0e                	push   $0xe
  801be2:	e8 2d fe ff ff       	call   801a14 <syscall>
  801be7:	83 c4 18             	add    $0x18,%esp
}
  801bea:	90                   	nop
  801beb:	c9                   	leave  
  801bec:	c3                   	ret    

00801bed <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801bed:	55                   	push   %ebp
  801bee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801bf0:	6a 00                	push   $0x0
  801bf2:	6a 00                	push   $0x0
  801bf4:	6a 00                	push   $0x0
  801bf6:	6a 00                	push   $0x0
  801bf8:	6a 00                	push   $0x0
  801bfa:	6a 13                	push   $0x13
  801bfc:	e8 13 fe ff ff       	call   801a14 <syscall>
  801c01:	83 c4 18             	add    $0x18,%esp
}
  801c04:	90                   	nop
  801c05:	c9                   	leave  
  801c06:	c3                   	ret    

00801c07 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801c07:	55                   	push   %ebp
  801c08:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801c0a:	6a 00                	push   $0x0
  801c0c:	6a 00                	push   $0x0
  801c0e:	6a 00                	push   $0x0
  801c10:	6a 00                	push   $0x0
  801c12:	6a 00                	push   $0x0
  801c14:	6a 14                	push   $0x14
  801c16:	e8 f9 fd ff ff       	call   801a14 <syscall>
  801c1b:	83 c4 18             	add    $0x18,%esp
}
  801c1e:	90                   	nop
  801c1f:	c9                   	leave  
  801c20:	c3                   	ret    

00801c21 <sys_cputc>:


void
sys_cputc(const char c)
{
  801c21:	55                   	push   %ebp
  801c22:	89 e5                	mov    %esp,%ebp
  801c24:	83 ec 04             	sub    $0x4,%esp
  801c27:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801c2d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c31:	6a 00                	push   $0x0
  801c33:	6a 00                	push   $0x0
  801c35:	6a 00                	push   $0x0
  801c37:	6a 00                	push   $0x0
  801c39:	50                   	push   %eax
  801c3a:	6a 15                	push   $0x15
  801c3c:	e8 d3 fd ff ff       	call   801a14 <syscall>
  801c41:	83 c4 18             	add    $0x18,%esp
}
  801c44:	90                   	nop
  801c45:	c9                   	leave  
  801c46:	c3                   	ret    

00801c47 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801c47:	55                   	push   %ebp
  801c48:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 00                	push   $0x0
  801c4e:	6a 00                	push   $0x0
  801c50:	6a 00                	push   $0x0
  801c52:	6a 00                	push   $0x0
  801c54:	6a 16                	push   $0x16
  801c56:	e8 b9 fd ff ff       	call   801a14 <syscall>
  801c5b:	83 c4 18             	add    $0x18,%esp
}
  801c5e:	90                   	nop
  801c5f:	c9                   	leave  
  801c60:	c3                   	ret    

00801c61 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801c61:	55                   	push   %ebp
  801c62:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801c64:	8b 45 08             	mov    0x8(%ebp),%eax
  801c67:	6a 00                	push   $0x0
  801c69:	6a 00                	push   $0x0
  801c6b:	6a 00                	push   $0x0
  801c6d:	ff 75 0c             	pushl  0xc(%ebp)
  801c70:	50                   	push   %eax
  801c71:	6a 17                	push   $0x17
  801c73:	e8 9c fd ff ff       	call   801a14 <syscall>
  801c78:	83 c4 18             	add    $0x18,%esp
}
  801c7b:	c9                   	leave  
  801c7c:	c3                   	ret    

00801c7d <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801c7d:	55                   	push   %ebp
  801c7e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c80:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c83:	8b 45 08             	mov    0x8(%ebp),%eax
  801c86:	6a 00                	push   $0x0
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 00                	push   $0x0
  801c8c:	52                   	push   %edx
  801c8d:	50                   	push   %eax
  801c8e:	6a 1a                	push   $0x1a
  801c90:	e8 7f fd ff ff       	call   801a14 <syscall>
  801c95:	83 c4 18             	add    $0x18,%esp
}
  801c98:	c9                   	leave  
  801c99:	c3                   	ret    

00801c9a <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801c9a:	55                   	push   %ebp
  801c9b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c9d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ca0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca3:	6a 00                	push   $0x0
  801ca5:	6a 00                	push   $0x0
  801ca7:	6a 00                	push   $0x0
  801ca9:	52                   	push   %edx
  801caa:	50                   	push   %eax
  801cab:	6a 18                	push   $0x18
  801cad:	e8 62 fd ff ff       	call   801a14 <syscall>
  801cb2:	83 c4 18             	add    $0x18,%esp
}
  801cb5:	90                   	nop
  801cb6:	c9                   	leave  
  801cb7:	c3                   	ret    

00801cb8 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801cb8:	55                   	push   %ebp
  801cb9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801cbb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc1:	6a 00                	push   $0x0
  801cc3:	6a 00                	push   $0x0
  801cc5:	6a 00                	push   $0x0
  801cc7:	52                   	push   %edx
  801cc8:	50                   	push   %eax
  801cc9:	6a 19                	push   $0x19
  801ccb:	e8 44 fd ff ff       	call   801a14 <syscall>
  801cd0:	83 c4 18             	add    $0x18,%esp
}
  801cd3:	90                   	nop
  801cd4:	c9                   	leave  
  801cd5:	c3                   	ret    

00801cd6 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801cd6:	55                   	push   %ebp
  801cd7:	89 e5                	mov    %esp,%ebp
  801cd9:	83 ec 04             	sub    $0x4,%esp
  801cdc:	8b 45 10             	mov    0x10(%ebp),%eax
  801cdf:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801ce2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ce5:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ce9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cec:	6a 00                	push   $0x0
  801cee:	51                   	push   %ecx
  801cef:	52                   	push   %edx
  801cf0:	ff 75 0c             	pushl  0xc(%ebp)
  801cf3:	50                   	push   %eax
  801cf4:	6a 1b                	push   $0x1b
  801cf6:	e8 19 fd ff ff       	call   801a14 <syscall>
  801cfb:	83 c4 18             	add    $0x18,%esp
}
  801cfe:	c9                   	leave  
  801cff:	c3                   	ret    

00801d00 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801d00:	55                   	push   %ebp
  801d01:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801d03:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d06:	8b 45 08             	mov    0x8(%ebp),%eax
  801d09:	6a 00                	push   $0x0
  801d0b:	6a 00                	push   $0x0
  801d0d:	6a 00                	push   $0x0
  801d0f:	52                   	push   %edx
  801d10:	50                   	push   %eax
  801d11:	6a 1c                	push   $0x1c
  801d13:	e8 fc fc ff ff       	call   801a14 <syscall>
  801d18:	83 c4 18             	add    $0x18,%esp
}
  801d1b:	c9                   	leave  
  801d1c:	c3                   	ret    

00801d1d <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801d1d:	55                   	push   %ebp
  801d1e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801d20:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d23:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d26:	8b 45 08             	mov    0x8(%ebp),%eax
  801d29:	6a 00                	push   $0x0
  801d2b:	6a 00                	push   $0x0
  801d2d:	51                   	push   %ecx
  801d2e:	52                   	push   %edx
  801d2f:	50                   	push   %eax
  801d30:	6a 1d                	push   $0x1d
  801d32:	e8 dd fc ff ff       	call   801a14 <syscall>
  801d37:	83 c4 18             	add    $0x18,%esp
}
  801d3a:	c9                   	leave  
  801d3b:	c3                   	ret    

00801d3c <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801d3c:	55                   	push   %ebp
  801d3d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801d3f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d42:	8b 45 08             	mov    0x8(%ebp),%eax
  801d45:	6a 00                	push   $0x0
  801d47:	6a 00                	push   $0x0
  801d49:	6a 00                	push   $0x0
  801d4b:	52                   	push   %edx
  801d4c:	50                   	push   %eax
  801d4d:	6a 1e                	push   $0x1e
  801d4f:	e8 c0 fc ff ff       	call   801a14 <syscall>
  801d54:	83 c4 18             	add    $0x18,%esp
}
  801d57:	c9                   	leave  
  801d58:	c3                   	ret    

00801d59 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801d59:	55                   	push   %ebp
  801d5a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801d5c:	6a 00                	push   $0x0
  801d5e:	6a 00                	push   $0x0
  801d60:	6a 00                	push   $0x0
  801d62:	6a 00                	push   $0x0
  801d64:	6a 00                	push   $0x0
  801d66:	6a 1f                	push   $0x1f
  801d68:	e8 a7 fc ff ff       	call   801a14 <syscall>
  801d6d:	83 c4 18             	add    $0x18,%esp
}
  801d70:	c9                   	leave  
  801d71:	c3                   	ret    

00801d72 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801d72:	55                   	push   %ebp
  801d73:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801d75:	8b 45 08             	mov    0x8(%ebp),%eax
  801d78:	6a 00                	push   $0x0
  801d7a:	ff 75 14             	pushl  0x14(%ebp)
  801d7d:	ff 75 10             	pushl  0x10(%ebp)
  801d80:	ff 75 0c             	pushl  0xc(%ebp)
  801d83:	50                   	push   %eax
  801d84:	6a 20                	push   $0x20
  801d86:	e8 89 fc ff ff       	call   801a14 <syscall>
  801d8b:	83 c4 18             	add    $0x18,%esp
}
  801d8e:	c9                   	leave  
  801d8f:	c3                   	ret    

00801d90 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801d90:	55                   	push   %ebp
  801d91:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801d93:	8b 45 08             	mov    0x8(%ebp),%eax
  801d96:	6a 00                	push   $0x0
  801d98:	6a 00                	push   $0x0
  801d9a:	6a 00                	push   $0x0
  801d9c:	6a 00                	push   $0x0
  801d9e:	50                   	push   %eax
  801d9f:	6a 21                	push   $0x21
  801da1:	e8 6e fc ff ff       	call   801a14 <syscall>
  801da6:	83 c4 18             	add    $0x18,%esp
}
  801da9:	90                   	nop
  801daa:	c9                   	leave  
  801dab:	c3                   	ret    

00801dac <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801dac:	55                   	push   %ebp
  801dad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801daf:	8b 45 08             	mov    0x8(%ebp),%eax
  801db2:	6a 00                	push   $0x0
  801db4:	6a 00                	push   $0x0
  801db6:	6a 00                	push   $0x0
  801db8:	6a 00                	push   $0x0
  801dba:	50                   	push   %eax
  801dbb:	6a 22                	push   $0x22
  801dbd:	e8 52 fc ff ff       	call   801a14 <syscall>
  801dc2:	83 c4 18             	add    $0x18,%esp
}
  801dc5:	c9                   	leave  
  801dc6:	c3                   	ret    

00801dc7 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801dc7:	55                   	push   %ebp
  801dc8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801dca:	6a 00                	push   $0x0
  801dcc:	6a 00                	push   $0x0
  801dce:	6a 00                	push   $0x0
  801dd0:	6a 00                	push   $0x0
  801dd2:	6a 00                	push   $0x0
  801dd4:	6a 02                	push   $0x2
  801dd6:	e8 39 fc ff ff       	call   801a14 <syscall>
  801ddb:	83 c4 18             	add    $0x18,%esp
}
  801dde:	c9                   	leave  
  801ddf:	c3                   	ret    

00801de0 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801de0:	55                   	push   %ebp
  801de1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801de3:	6a 00                	push   $0x0
  801de5:	6a 00                	push   $0x0
  801de7:	6a 00                	push   $0x0
  801de9:	6a 00                	push   $0x0
  801deb:	6a 00                	push   $0x0
  801ded:	6a 03                	push   $0x3
  801def:	e8 20 fc ff ff       	call   801a14 <syscall>
  801df4:	83 c4 18             	add    $0x18,%esp
}
  801df7:	c9                   	leave  
  801df8:	c3                   	ret    

00801df9 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801df9:	55                   	push   %ebp
  801dfa:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801dfc:	6a 00                	push   $0x0
  801dfe:	6a 00                	push   $0x0
  801e00:	6a 00                	push   $0x0
  801e02:	6a 00                	push   $0x0
  801e04:	6a 00                	push   $0x0
  801e06:	6a 04                	push   $0x4
  801e08:	e8 07 fc ff ff       	call   801a14 <syscall>
  801e0d:	83 c4 18             	add    $0x18,%esp
}
  801e10:	c9                   	leave  
  801e11:	c3                   	ret    

00801e12 <sys_exit_env>:


void sys_exit_env(void)
{
  801e12:	55                   	push   %ebp
  801e13:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801e15:	6a 00                	push   $0x0
  801e17:	6a 00                	push   $0x0
  801e19:	6a 00                	push   $0x0
  801e1b:	6a 00                	push   $0x0
  801e1d:	6a 00                	push   $0x0
  801e1f:	6a 23                	push   $0x23
  801e21:	e8 ee fb ff ff       	call   801a14 <syscall>
  801e26:	83 c4 18             	add    $0x18,%esp
}
  801e29:	90                   	nop
  801e2a:	c9                   	leave  
  801e2b:	c3                   	ret    

00801e2c <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801e2c:	55                   	push   %ebp
  801e2d:	89 e5                	mov    %esp,%ebp
  801e2f:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801e32:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e35:	8d 50 04             	lea    0x4(%eax),%edx
  801e38:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e3b:	6a 00                	push   $0x0
  801e3d:	6a 00                	push   $0x0
  801e3f:	6a 00                	push   $0x0
  801e41:	52                   	push   %edx
  801e42:	50                   	push   %eax
  801e43:	6a 24                	push   $0x24
  801e45:	e8 ca fb ff ff       	call   801a14 <syscall>
  801e4a:	83 c4 18             	add    $0x18,%esp
	return result;
  801e4d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e50:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e53:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e56:	89 01                	mov    %eax,(%ecx)
  801e58:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801e5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5e:	c9                   	leave  
  801e5f:	c2 04 00             	ret    $0x4

00801e62 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801e62:	55                   	push   %ebp
  801e63:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801e65:	6a 00                	push   $0x0
  801e67:	6a 00                	push   $0x0
  801e69:	ff 75 10             	pushl  0x10(%ebp)
  801e6c:	ff 75 0c             	pushl  0xc(%ebp)
  801e6f:	ff 75 08             	pushl  0x8(%ebp)
  801e72:	6a 12                	push   $0x12
  801e74:	e8 9b fb ff ff       	call   801a14 <syscall>
  801e79:	83 c4 18             	add    $0x18,%esp
	return ;
  801e7c:	90                   	nop
}
  801e7d:	c9                   	leave  
  801e7e:	c3                   	ret    

00801e7f <sys_rcr2>:
uint32 sys_rcr2()
{
  801e7f:	55                   	push   %ebp
  801e80:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801e82:	6a 00                	push   $0x0
  801e84:	6a 00                	push   $0x0
  801e86:	6a 00                	push   $0x0
  801e88:	6a 00                	push   $0x0
  801e8a:	6a 00                	push   $0x0
  801e8c:	6a 25                	push   $0x25
  801e8e:	e8 81 fb ff ff       	call   801a14 <syscall>
  801e93:	83 c4 18             	add    $0x18,%esp
}
  801e96:	c9                   	leave  
  801e97:	c3                   	ret    

00801e98 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801e98:	55                   	push   %ebp
  801e99:	89 e5                	mov    %esp,%ebp
  801e9b:	83 ec 04             	sub    $0x4,%esp
  801e9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801ea4:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801ea8:	6a 00                	push   $0x0
  801eaa:	6a 00                	push   $0x0
  801eac:	6a 00                	push   $0x0
  801eae:	6a 00                	push   $0x0
  801eb0:	50                   	push   %eax
  801eb1:	6a 26                	push   $0x26
  801eb3:	e8 5c fb ff ff       	call   801a14 <syscall>
  801eb8:	83 c4 18             	add    $0x18,%esp
	return ;
  801ebb:	90                   	nop
}
  801ebc:	c9                   	leave  
  801ebd:	c3                   	ret    

00801ebe <rsttst>:
void rsttst()
{
  801ebe:	55                   	push   %ebp
  801ebf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801ec1:	6a 00                	push   $0x0
  801ec3:	6a 00                	push   $0x0
  801ec5:	6a 00                	push   $0x0
  801ec7:	6a 00                	push   $0x0
  801ec9:	6a 00                	push   $0x0
  801ecb:	6a 28                	push   $0x28
  801ecd:	e8 42 fb ff ff       	call   801a14 <syscall>
  801ed2:	83 c4 18             	add    $0x18,%esp
	return ;
  801ed5:	90                   	nop
}
  801ed6:	c9                   	leave  
  801ed7:	c3                   	ret    

00801ed8 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801ed8:	55                   	push   %ebp
  801ed9:	89 e5                	mov    %esp,%ebp
  801edb:	83 ec 04             	sub    $0x4,%esp
  801ede:	8b 45 14             	mov    0x14(%ebp),%eax
  801ee1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ee4:	8b 55 18             	mov    0x18(%ebp),%edx
  801ee7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801eeb:	52                   	push   %edx
  801eec:	50                   	push   %eax
  801eed:	ff 75 10             	pushl  0x10(%ebp)
  801ef0:	ff 75 0c             	pushl  0xc(%ebp)
  801ef3:	ff 75 08             	pushl  0x8(%ebp)
  801ef6:	6a 27                	push   $0x27
  801ef8:	e8 17 fb ff ff       	call   801a14 <syscall>
  801efd:	83 c4 18             	add    $0x18,%esp
	return ;
  801f00:	90                   	nop
}
  801f01:	c9                   	leave  
  801f02:	c3                   	ret    

00801f03 <chktst>:
void chktst(uint32 n)
{
  801f03:	55                   	push   %ebp
  801f04:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801f06:	6a 00                	push   $0x0
  801f08:	6a 00                	push   $0x0
  801f0a:	6a 00                	push   $0x0
  801f0c:	6a 00                	push   $0x0
  801f0e:	ff 75 08             	pushl  0x8(%ebp)
  801f11:	6a 29                	push   $0x29
  801f13:	e8 fc fa ff ff       	call   801a14 <syscall>
  801f18:	83 c4 18             	add    $0x18,%esp
	return ;
  801f1b:	90                   	nop
}
  801f1c:	c9                   	leave  
  801f1d:	c3                   	ret    

00801f1e <inctst>:

void inctst()
{
  801f1e:	55                   	push   %ebp
  801f1f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801f21:	6a 00                	push   $0x0
  801f23:	6a 00                	push   $0x0
  801f25:	6a 00                	push   $0x0
  801f27:	6a 00                	push   $0x0
  801f29:	6a 00                	push   $0x0
  801f2b:	6a 2a                	push   $0x2a
  801f2d:	e8 e2 fa ff ff       	call   801a14 <syscall>
  801f32:	83 c4 18             	add    $0x18,%esp
	return ;
  801f35:	90                   	nop
}
  801f36:	c9                   	leave  
  801f37:	c3                   	ret    

00801f38 <gettst>:
uint32 gettst()
{
  801f38:	55                   	push   %ebp
  801f39:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801f3b:	6a 00                	push   $0x0
  801f3d:	6a 00                	push   $0x0
  801f3f:	6a 00                	push   $0x0
  801f41:	6a 00                	push   $0x0
  801f43:	6a 00                	push   $0x0
  801f45:	6a 2b                	push   $0x2b
  801f47:	e8 c8 fa ff ff       	call   801a14 <syscall>
  801f4c:	83 c4 18             	add    $0x18,%esp
}
  801f4f:	c9                   	leave  
  801f50:	c3                   	ret    

00801f51 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801f51:	55                   	push   %ebp
  801f52:	89 e5                	mov    %esp,%ebp
  801f54:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f57:	6a 00                	push   $0x0
  801f59:	6a 00                	push   $0x0
  801f5b:	6a 00                	push   $0x0
  801f5d:	6a 00                	push   $0x0
  801f5f:	6a 00                	push   $0x0
  801f61:	6a 2c                	push   $0x2c
  801f63:	e8 ac fa ff ff       	call   801a14 <syscall>
  801f68:	83 c4 18             	add    $0x18,%esp
  801f6b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801f6e:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801f72:	75 07                	jne    801f7b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801f74:	b8 01 00 00 00       	mov    $0x1,%eax
  801f79:	eb 05                	jmp    801f80 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801f7b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f80:	c9                   	leave  
  801f81:	c3                   	ret    

00801f82 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801f82:	55                   	push   %ebp
  801f83:	89 e5                	mov    %esp,%ebp
  801f85:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f88:	6a 00                	push   $0x0
  801f8a:	6a 00                	push   $0x0
  801f8c:	6a 00                	push   $0x0
  801f8e:	6a 00                	push   $0x0
  801f90:	6a 00                	push   $0x0
  801f92:	6a 2c                	push   $0x2c
  801f94:	e8 7b fa ff ff       	call   801a14 <syscall>
  801f99:	83 c4 18             	add    $0x18,%esp
  801f9c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801f9f:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801fa3:	75 07                	jne    801fac <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801fa5:	b8 01 00 00 00       	mov    $0x1,%eax
  801faa:	eb 05                	jmp    801fb1 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801fac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fb1:	c9                   	leave  
  801fb2:	c3                   	ret    

00801fb3 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801fb3:	55                   	push   %ebp
  801fb4:	89 e5                	mov    %esp,%ebp
  801fb6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fb9:	6a 00                	push   $0x0
  801fbb:	6a 00                	push   $0x0
  801fbd:	6a 00                	push   $0x0
  801fbf:	6a 00                	push   $0x0
  801fc1:	6a 00                	push   $0x0
  801fc3:	6a 2c                	push   $0x2c
  801fc5:	e8 4a fa ff ff       	call   801a14 <syscall>
  801fca:	83 c4 18             	add    $0x18,%esp
  801fcd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801fd0:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801fd4:	75 07                	jne    801fdd <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801fd6:	b8 01 00 00 00       	mov    $0x1,%eax
  801fdb:	eb 05                	jmp    801fe2 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801fdd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fe2:	c9                   	leave  
  801fe3:	c3                   	ret    

00801fe4 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801fe4:	55                   	push   %ebp
  801fe5:	89 e5                	mov    %esp,%ebp
  801fe7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fea:	6a 00                	push   $0x0
  801fec:	6a 00                	push   $0x0
  801fee:	6a 00                	push   $0x0
  801ff0:	6a 00                	push   $0x0
  801ff2:	6a 00                	push   $0x0
  801ff4:	6a 2c                	push   $0x2c
  801ff6:	e8 19 fa ff ff       	call   801a14 <syscall>
  801ffb:	83 c4 18             	add    $0x18,%esp
  801ffe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802001:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802005:	75 07                	jne    80200e <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802007:	b8 01 00 00 00       	mov    $0x1,%eax
  80200c:	eb 05                	jmp    802013 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80200e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802013:	c9                   	leave  
  802014:	c3                   	ret    

00802015 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802015:	55                   	push   %ebp
  802016:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802018:	6a 00                	push   $0x0
  80201a:	6a 00                	push   $0x0
  80201c:	6a 00                	push   $0x0
  80201e:	6a 00                	push   $0x0
  802020:	ff 75 08             	pushl  0x8(%ebp)
  802023:	6a 2d                	push   $0x2d
  802025:	e8 ea f9 ff ff       	call   801a14 <syscall>
  80202a:	83 c4 18             	add    $0x18,%esp
	return ;
  80202d:	90                   	nop
}
  80202e:	c9                   	leave  
  80202f:	c3                   	ret    

00802030 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802030:	55                   	push   %ebp
  802031:	89 e5                	mov    %esp,%ebp
  802033:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802034:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802037:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80203a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80203d:	8b 45 08             	mov    0x8(%ebp),%eax
  802040:	6a 00                	push   $0x0
  802042:	53                   	push   %ebx
  802043:	51                   	push   %ecx
  802044:	52                   	push   %edx
  802045:	50                   	push   %eax
  802046:	6a 2e                	push   $0x2e
  802048:	e8 c7 f9 ff ff       	call   801a14 <syscall>
  80204d:	83 c4 18             	add    $0x18,%esp
}
  802050:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802053:	c9                   	leave  
  802054:	c3                   	ret    

00802055 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802055:	55                   	push   %ebp
  802056:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802058:	8b 55 0c             	mov    0xc(%ebp),%edx
  80205b:	8b 45 08             	mov    0x8(%ebp),%eax
  80205e:	6a 00                	push   $0x0
  802060:	6a 00                	push   $0x0
  802062:	6a 00                	push   $0x0
  802064:	52                   	push   %edx
  802065:	50                   	push   %eax
  802066:	6a 2f                	push   $0x2f
  802068:	e8 a7 f9 ff ff       	call   801a14 <syscall>
  80206d:	83 c4 18             	add    $0x18,%esp
}
  802070:	c9                   	leave  
  802071:	c3                   	ret    

00802072 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802072:	55                   	push   %ebp
  802073:	89 e5                	mov    %esp,%ebp
  802075:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802078:	83 ec 0c             	sub    $0xc,%esp
  80207b:	68 a0 42 80 00       	push   $0x8042a0
  802080:	e8 d6 e6 ff ff       	call   80075b <cprintf>
  802085:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802088:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  80208f:	83 ec 0c             	sub    $0xc,%esp
  802092:	68 cc 42 80 00       	push   $0x8042cc
  802097:	e8 bf e6 ff ff       	call   80075b <cprintf>
  80209c:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  80209f:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8020a3:	a1 38 51 80 00       	mov    0x805138,%eax
  8020a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020ab:	eb 56                	jmp    802103 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8020ad:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020b1:	74 1c                	je     8020cf <print_mem_block_lists+0x5d>
  8020b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b6:	8b 50 08             	mov    0x8(%eax),%edx
  8020b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020bc:	8b 48 08             	mov    0x8(%eax),%ecx
  8020bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020c2:	8b 40 0c             	mov    0xc(%eax),%eax
  8020c5:	01 c8                	add    %ecx,%eax
  8020c7:	39 c2                	cmp    %eax,%edx
  8020c9:	73 04                	jae    8020cf <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8020cb:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8020cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d2:	8b 50 08             	mov    0x8(%eax),%edx
  8020d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d8:	8b 40 0c             	mov    0xc(%eax),%eax
  8020db:	01 c2                	add    %eax,%edx
  8020dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e0:	8b 40 08             	mov    0x8(%eax),%eax
  8020e3:	83 ec 04             	sub    $0x4,%esp
  8020e6:	52                   	push   %edx
  8020e7:	50                   	push   %eax
  8020e8:	68 e1 42 80 00       	push   $0x8042e1
  8020ed:	e8 69 e6 ff ff       	call   80075b <cprintf>
  8020f2:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8020f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8020fb:	a1 40 51 80 00       	mov    0x805140,%eax
  802100:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802103:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802107:	74 07                	je     802110 <print_mem_block_lists+0x9e>
  802109:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80210c:	8b 00                	mov    (%eax),%eax
  80210e:	eb 05                	jmp    802115 <print_mem_block_lists+0xa3>
  802110:	b8 00 00 00 00       	mov    $0x0,%eax
  802115:	a3 40 51 80 00       	mov    %eax,0x805140
  80211a:	a1 40 51 80 00       	mov    0x805140,%eax
  80211f:	85 c0                	test   %eax,%eax
  802121:	75 8a                	jne    8020ad <print_mem_block_lists+0x3b>
  802123:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802127:	75 84                	jne    8020ad <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802129:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80212d:	75 10                	jne    80213f <print_mem_block_lists+0xcd>
  80212f:	83 ec 0c             	sub    $0xc,%esp
  802132:	68 f0 42 80 00       	push   $0x8042f0
  802137:	e8 1f e6 ff ff       	call   80075b <cprintf>
  80213c:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80213f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802146:	83 ec 0c             	sub    $0xc,%esp
  802149:	68 14 43 80 00       	push   $0x804314
  80214e:	e8 08 e6 ff ff       	call   80075b <cprintf>
  802153:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802156:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80215a:	a1 40 50 80 00       	mov    0x805040,%eax
  80215f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802162:	eb 56                	jmp    8021ba <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802164:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802168:	74 1c                	je     802186 <print_mem_block_lists+0x114>
  80216a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80216d:	8b 50 08             	mov    0x8(%eax),%edx
  802170:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802173:	8b 48 08             	mov    0x8(%eax),%ecx
  802176:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802179:	8b 40 0c             	mov    0xc(%eax),%eax
  80217c:	01 c8                	add    %ecx,%eax
  80217e:	39 c2                	cmp    %eax,%edx
  802180:	73 04                	jae    802186 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802182:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802186:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802189:	8b 50 08             	mov    0x8(%eax),%edx
  80218c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80218f:	8b 40 0c             	mov    0xc(%eax),%eax
  802192:	01 c2                	add    %eax,%edx
  802194:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802197:	8b 40 08             	mov    0x8(%eax),%eax
  80219a:	83 ec 04             	sub    $0x4,%esp
  80219d:	52                   	push   %edx
  80219e:	50                   	push   %eax
  80219f:	68 e1 42 80 00       	push   $0x8042e1
  8021a4:	e8 b2 e5 ff ff       	call   80075b <cprintf>
  8021a9:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8021ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021af:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8021b2:	a1 48 50 80 00       	mov    0x805048,%eax
  8021b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021be:	74 07                	je     8021c7 <print_mem_block_lists+0x155>
  8021c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c3:	8b 00                	mov    (%eax),%eax
  8021c5:	eb 05                	jmp    8021cc <print_mem_block_lists+0x15a>
  8021c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8021cc:	a3 48 50 80 00       	mov    %eax,0x805048
  8021d1:	a1 48 50 80 00       	mov    0x805048,%eax
  8021d6:	85 c0                	test   %eax,%eax
  8021d8:	75 8a                	jne    802164 <print_mem_block_lists+0xf2>
  8021da:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021de:	75 84                	jne    802164 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8021e0:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8021e4:	75 10                	jne    8021f6 <print_mem_block_lists+0x184>
  8021e6:	83 ec 0c             	sub    $0xc,%esp
  8021e9:	68 2c 43 80 00       	push   $0x80432c
  8021ee:	e8 68 e5 ff ff       	call   80075b <cprintf>
  8021f3:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8021f6:	83 ec 0c             	sub    $0xc,%esp
  8021f9:	68 a0 42 80 00       	push   $0x8042a0
  8021fe:	e8 58 e5 ff ff       	call   80075b <cprintf>
  802203:	83 c4 10             	add    $0x10,%esp

}
  802206:	90                   	nop
  802207:	c9                   	leave  
  802208:	c3                   	ret    

00802209 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802209:	55                   	push   %ebp
  80220a:	89 e5                	mov    %esp,%ebp
  80220c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  80220f:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802216:	00 00 00 
  802219:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802220:	00 00 00 
  802223:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  80222a:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  80222d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802234:	e9 9e 00 00 00       	jmp    8022d7 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802239:	a1 50 50 80 00       	mov    0x805050,%eax
  80223e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802241:	c1 e2 04             	shl    $0x4,%edx
  802244:	01 d0                	add    %edx,%eax
  802246:	85 c0                	test   %eax,%eax
  802248:	75 14                	jne    80225e <initialize_MemBlocksList+0x55>
  80224a:	83 ec 04             	sub    $0x4,%esp
  80224d:	68 54 43 80 00       	push   $0x804354
  802252:	6a 46                	push   $0x46
  802254:	68 77 43 80 00       	push   $0x804377
  802259:	e8 49 e2 ff ff       	call   8004a7 <_panic>
  80225e:	a1 50 50 80 00       	mov    0x805050,%eax
  802263:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802266:	c1 e2 04             	shl    $0x4,%edx
  802269:	01 d0                	add    %edx,%eax
  80226b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802271:	89 10                	mov    %edx,(%eax)
  802273:	8b 00                	mov    (%eax),%eax
  802275:	85 c0                	test   %eax,%eax
  802277:	74 18                	je     802291 <initialize_MemBlocksList+0x88>
  802279:	a1 48 51 80 00       	mov    0x805148,%eax
  80227e:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802284:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802287:	c1 e1 04             	shl    $0x4,%ecx
  80228a:	01 ca                	add    %ecx,%edx
  80228c:	89 50 04             	mov    %edx,0x4(%eax)
  80228f:	eb 12                	jmp    8022a3 <initialize_MemBlocksList+0x9a>
  802291:	a1 50 50 80 00       	mov    0x805050,%eax
  802296:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802299:	c1 e2 04             	shl    $0x4,%edx
  80229c:	01 d0                	add    %edx,%eax
  80229e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8022a3:	a1 50 50 80 00       	mov    0x805050,%eax
  8022a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022ab:	c1 e2 04             	shl    $0x4,%edx
  8022ae:	01 d0                	add    %edx,%eax
  8022b0:	a3 48 51 80 00       	mov    %eax,0x805148
  8022b5:	a1 50 50 80 00       	mov    0x805050,%eax
  8022ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022bd:	c1 e2 04             	shl    $0x4,%edx
  8022c0:	01 d0                	add    %edx,%eax
  8022c2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022c9:	a1 54 51 80 00       	mov    0x805154,%eax
  8022ce:	40                   	inc    %eax
  8022cf:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  8022d4:	ff 45 f4             	incl   -0xc(%ebp)
  8022d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022da:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022dd:	0f 82 56 ff ff ff    	jb     802239 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  8022e3:	90                   	nop
  8022e4:	c9                   	leave  
  8022e5:	c3                   	ret    

008022e6 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8022e6:	55                   	push   %ebp
  8022e7:	89 e5                	mov    %esp,%ebp
  8022e9:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8022ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ef:	8b 00                	mov    (%eax),%eax
  8022f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8022f4:	eb 19                	jmp    80230f <find_block+0x29>
	{
		if(va==point->sva)
  8022f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022f9:	8b 40 08             	mov    0x8(%eax),%eax
  8022fc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8022ff:	75 05                	jne    802306 <find_block+0x20>
		   return point;
  802301:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802304:	eb 36                	jmp    80233c <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802306:	8b 45 08             	mov    0x8(%ebp),%eax
  802309:	8b 40 08             	mov    0x8(%eax),%eax
  80230c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80230f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802313:	74 07                	je     80231c <find_block+0x36>
  802315:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802318:	8b 00                	mov    (%eax),%eax
  80231a:	eb 05                	jmp    802321 <find_block+0x3b>
  80231c:	b8 00 00 00 00       	mov    $0x0,%eax
  802321:	8b 55 08             	mov    0x8(%ebp),%edx
  802324:	89 42 08             	mov    %eax,0x8(%edx)
  802327:	8b 45 08             	mov    0x8(%ebp),%eax
  80232a:	8b 40 08             	mov    0x8(%eax),%eax
  80232d:	85 c0                	test   %eax,%eax
  80232f:	75 c5                	jne    8022f6 <find_block+0x10>
  802331:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802335:	75 bf                	jne    8022f6 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802337:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80233c:	c9                   	leave  
  80233d:	c3                   	ret    

0080233e <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80233e:	55                   	push   %ebp
  80233f:	89 e5                	mov    %esp,%ebp
  802341:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802344:	a1 40 50 80 00       	mov    0x805040,%eax
  802349:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  80234c:	a1 44 50 80 00       	mov    0x805044,%eax
  802351:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802354:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802357:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80235a:	74 24                	je     802380 <insert_sorted_allocList+0x42>
  80235c:	8b 45 08             	mov    0x8(%ebp),%eax
  80235f:	8b 50 08             	mov    0x8(%eax),%edx
  802362:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802365:	8b 40 08             	mov    0x8(%eax),%eax
  802368:	39 c2                	cmp    %eax,%edx
  80236a:	76 14                	jbe    802380 <insert_sorted_allocList+0x42>
  80236c:	8b 45 08             	mov    0x8(%ebp),%eax
  80236f:	8b 50 08             	mov    0x8(%eax),%edx
  802372:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802375:	8b 40 08             	mov    0x8(%eax),%eax
  802378:	39 c2                	cmp    %eax,%edx
  80237a:	0f 82 60 01 00 00    	jb     8024e0 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802380:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802384:	75 65                	jne    8023eb <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802386:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80238a:	75 14                	jne    8023a0 <insert_sorted_allocList+0x62>
  80238c:	83 ec 04             	sub    $0x4,%esp
  80238f:	68 54 43 80 00       	push   $0x804354
  802394:	6a 6b                	push   $0x6b
  802396:	68 77 43 80 00       	push   $0x804377
  80239b:	e8 07 e1 ff ff       	call   8004a7 <_panic>
  8023a0:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8023a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a9:	89 10                	mov    %edx,(%eax)
  8023ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ae:	8b 00                	mov    (%eax),%eax
  8023b0:	85 c0                	test   %eax,%eax
  8023b2:	74 0d                	je     8023c1 <insert_sorted_allocList+0x83>
  8023b4:	a1 40 50 80 00       	mov    0x805040,%eax
  8023b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8023bc:	89 50 04             	mov    %edx,0x4(%eax)
  8023bf:	eb 08                	jmp    8023c9 <insert_sorted_allocList+0x8b>
  8023c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c4:	a3 44 50 80 00       	mov    %eax,0x805044
  8023c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023cc:	a3 40 50 80 00       	mov    %eax,0x805040
  8023d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023db:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8023e0:	40                   	inc    %eax
  8023e1:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8023e6:	e9 dc 01 00 00       	jmp    8025c7 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8023eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ee:	8b 50 08             	mov    0x8(%eax),%edx
  8023f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023f4:	8b 40 08             	mov    0x8(%eax),%eax
  8023f7:	39 c2                	cmp    %eax,%edx
  8023f9:	77 6c                	ja     802467 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8023fb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023ff:	74 06                	je     802407 <insert_sorted_allocList+0xc9>
  802401:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802405:	75 14                	jne    80241b <insert_sorted_allocList+0xdd>
  802407:	83 ec 04             	sub    $0x4,%esp
  80240a:	68 90 43 80 00       	push   $0x804390
  80240f:	6a 6f                	push   $0x6f
  802411:	68 77 43 80 00       	push   $0x804377
  802416:	e8 8c e0 ff ff       	call   8004a7 <_panic>
  80241b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80241e:	8b 50 04             	mov    0x4(%eax),%edx
  802421:	8b 45 08             	mov    0x8(%ebp),%eax
  802424:	89 50 04             	mov    %edx,0x4(%eax)
  802427:	8b 45 08             	mov    0x8(%ebp),%eax
  80242a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80242d:	89 10                	mov    %edx,(%eax)
  80242f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802432:	8b 40 04             	mov    0x4(%eax),%eax
  802435:	85 c0                	test   %eax,%eax
  802437:	74 0d                	je     802446 <insert_sorted_allocList+0x108>
  802439:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80243c:	8b 40 04             	mov    0x4(%eax),%eax
  80243f:	8b 55 08             	mov    0x8(%ebp),%edx
  802442:	89 10                	mov    %edx,(%eax)
  802444:	eb 08                	jmp    80244e <insert_sorted_allocList+0x110>
  802446:	8b 45 08             	mov    0x8(%ebp),%eax
  802449:	a3 40 50 80 00       	mov    %eax,0x805040
  80244e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802451:	8b 55 08             	mov    0x8(%ebp),%edx
  802454:	89 50 04             	mov    %edx,0x4(%eax)
  802457:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80245c:	40                   	inc    %eax
  80245d:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802462:	e9 60 01 00 00       	jmp    8025c7 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802467:	8b 45 08             	mov    0x8(%ebp),%eax
  80246a:	8b 50 08             	mov    0x8(%eax),%edx
  80246d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802470:	8b 40 08             	mov    0x8(%eax),%eax
  802473:	39 c2                	cmp    %eax,%edx
  802475:	0f 82 4c 01 00 00    	jb     8025c7 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  80247b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80247f:	75 14                	jne    802495 <insert_sorted_allocList+0x157>
  802481:	83 ec 04             	sub    $0x4,%esp
  802484:	68 c8 43 80 00       	push   $0x8043c8
  802489:	6a 73                	push   $0x73
  80248b:	68 77 43 80 00       	push   $0x804377
  802490:	e8 12 e0 ff ff       	call   8004a7 <_panic>
  802495:	8b 15 44 50 80 00    	mov    0x805044,%edx
  80249b:	8b 45 08             	mov    0x8(%ebp),%eax
  80249e:	89 50 04             	mov    %edx,0x4(%eax)
  8024a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a4:	8b 40 04             	mov    0x4(%eax),%eax
  8024a7:	85 c0                	test   %eax,%eax
  8024a9:	74 0c                	je     8024b7 <insert_sorted_allocList+0x179>
  8024ab:	a1 44 50 80 00       	mov    0x805044,%eax
  8024b0:	8b 55 08             	mov    0x8(%ebp),%edx
  8024b3:	89 10                	mov    %edx,(%eax)
  8024b5:	eb 08                	jmp    8024bf <insert_sorted_allocList+0x181>
  8024b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ba:	a3 40 50 80 00       	mov    %eax,0x805040
  8024bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c2:	a3 44 50 80 00       	mov    %eax,0x805044
  8024c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024d0:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8024d5:	40                   	inc    %eax
  8024d6:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8024db:	e9 e7 00 00 00       	jmp    8025c7 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8024e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8024e6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8024ed:	a1 40 50 80 00       	mov    0x805040,%eax
  8024f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024f5:	e9 9d 00 00 00       	jmp    802597 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8024fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fd:	8b 00                	mov    (%eax),%eax
  8024ff:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802502:	8b 45 08             	mov    0x8(%ebp),%eax
  802505:	8b 50 08             	mov    0x8(%eax),%edx
  802508:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250b:	8b 40 08             	mov    0x8(%eax),%eax
  80250e:	39 c2                	cmp    %eax,%edx
  802510:	76 7d                	jbe    80258f <insert_sorted_allocList+0x251>
  802512:	8b 45 08             	mov    0x8(%ebp),%eax
  802515:	8b 50 08             	mov    0x8(%eax),%edx
  802518:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80251b:	8b 40 08             	mov    0x8(%eax),%eax
  80251e:	39 c2                	cmp    %eax,%edx
  802520:	73 6d                	jae    80258f <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802522:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802526:	74 06                	je     80252e <insert_sorted_allocList+0x1f0>
  802528:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80252c:	75 14                	jne    802542 <insert_sorted_allocList+0x204>
  80252e:	83 ec 04             	sub    $0x4,%esp
  802531:	68 ec 43 80 00       	push   $0x8043ec
  802536:	6a 7f                	push   $0x7f
  802538:	68 77 43 80 00       	push   $0x804377
  80253d:	e8 65 df ff ff       	call   8004a7 <_panic>
  802542:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802545:	8b 10                	mov    (%eax),%edx
  802547:	8b 45 08             	mov    0x8(%ebp),%eax
  80254a:	89 10                	mov    %edx,(%eax)
  80254c:	8b 45 08             	mov    0x8(%ebp),%eax
  80254f:	8b 00                	mov    (%eax),%eax
  802551:	85 c0                	test   %eax,%eax
  802553:	74 0b                	je     802560 <insert_sorted_allocList+0x222>
  802555:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802558:	8b 00                	mov    (%eax),%eax
  80255a:	8b 55 08             	mov    0x8(%ebp),%edx
  80255d:	89 50 04             	mov    %edx,0x4(%eax)
  802560:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802563:	8b 55 08             	mov    0x8(%ebp),%edx
  802566:	89 10                	mov    %edx,(%eax)
  802568:	8b 45 08             	mov    0x8(%ebp),%eax
  80256b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80256e:	89 50 04             	mov    %edx,0x4(%eax)
  802571:	8b 45 08             	mov    0x8(%ebp),%eax
  802574:	8b 00                	mov    (%eax),%eax
  802576:	85 c0                	test   %eax,%eax
  802578:	75 08                	jne    802582 <insert_sorted_allocList+0x244>
  80257a:	8b 45 08             	mov    0x8(%ebp),%eax
  80257d:	a3 44 50 80 00       	mov    %eax,0x805044
  802582:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802587:	40                   	inc    %eax
  802588:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  80258d:	eb 39                	jmp    8025c8 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80258f:	a1 48 50 80 00       	mov    0x805048,%eax
  802594:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802597:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80259b:	74 07                	je     8025a4 <insert_sorted_allocList+0x266>
  80259d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a0:	8b 00                	mov    (%eax),%eax
  8025a2:	eb 05                	jmp    8025a9 <insert_sorted_allocList+0x26b>
  8025a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8025a9:	a3 48 50 80 00       	mov    %eax,0x805048
  8025ae:	a1 48 50 80 00       	mov    0x805048,%eax
  8025b3:	85 c0                	test   %eax,%eax
  8025b5:	0f 85 3f ff ff ff    	jne    8024fa <insert_sorted_allocList+0x1bc>
  8025bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025bf:	0f 85 35 ff ff ff    	jne    8024fa <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8025c5:	eb 01                	jmp    8025c8 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8025c7:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8025c8:	90                   	nop
  8025c9:	c9                   	leave  
  8025ca:	c3                   	ret    

008025cb <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8025cb:	55                   	push   %ebp
  8025cc:	89 e5                	mov    %esp,%ebp
  8025ce:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8025d1:	a1 38 51 80 00       	mov    0x805138,%eax
  8025d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025d9:	e9 85 01 00 00       	jmp    802763 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8025de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e1:	8b 40 0c             	mov    0xc(%eax),%eax
  8025e4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025e7:	0f 82 6e 01 00 00    	jb     80275b <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8025ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f0:	8b 40 0c             	mov    0xc(%eax),%eax
  8025f3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025f6:	0f 85 8a 00 00 00    	jne    802686 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8025fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802600:	75 17                	jne    802619 <alloc_block_FF+0x4e>
  802602:	83 ec 04             	sub    $0x4,%esp
  802605:	68 20 44 80 00       	push   $0x804420
  80260a:	68 93 00 00 00       	push   $0x93
  80260f:	68 77 43 80 00       	push   $0x804377
  802614:	e8 8e de ff ff       	call   8004a7 <_panic>
  802619:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261c:	8b 00                	mov    (%eax),%eax
  80261e:	85 c0                	test   %eax,%eax
  802620:	74 10                	je     802632 <alloc_block_FF+0x67>
  802622:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802625:	8b 00                	mov    (%eax),%eax
  802627:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80262a:	8b 52 04             	mov    0x4(%edx),%edx
  80262d:	89 50 04             	mov    %edx,0x4(%eax)
  802630:	eb 0b                	jmp    80263d <alloc_block_FF+0x72>
  802632:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802635:	8b 40 04             	mov    0x4(%eax),%eax
  802638:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80263d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802640:	8b 40 04             	mov    0x4(%eax),%eax
  802643:	85 c0                	test   %eax,%eax
  802645:	74 0f                	je     802656 <alloc_block_FF+0x8b>
  802647:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264a:	8b 40 04             	mov    0x4(%eax),%eax
  80264d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802650:	8b 12                	mov    (%edx),%edx
  802652:	89 10                	mov    %edx,(%eax)
  802654:	eb 0a                	jmp    802660 <alloc_block_FF+0x95>
  802656:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802659:	8b 00                	mov    (%eax),%eax
  80265b:	a3 38 51 80 00       	mov    %eax,0x805138
  802660:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802663:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802669:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802673:	a1 44 51 80 00       	mov    0x805144,%eax
  802678:	48                   	dec    %eax
  802679:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  80267e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802681:	e9 10 01 00 00       	jmp    802796 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802686:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802689:	8b 40 0c             	mov    0xc(%eax),%eax
  80268c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80268f:	0f 86 c6 00 00 00    	jbe    80275b <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802695:	a1 48 51 80 00       	mov    0x805148,%eax
  80269a:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  80269d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a0:	8b 50 08             	mov    0x8(%eax),%edx
  8026a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026a6:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8026a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026ac:	8b 55 08             	mov    0x8(%ebp),%edx
  8026af:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8026b2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026b6:	75 17                	jne    8026cf <alloc_block_FF+0x104>
  8026b8:	83 ec 04             	sub    $0x4,%esp
  8026bb:	68 20 44 80 00       	push   $0x804420
  8026c0:	68 9b 00 00 00       	push   $0x9b
  8026c5:	68 77 43 80 00       	push   $0x804377
  8026ca:	e8 d8 dd ff ff       	call   8004a7 <_panic>
  8026cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026d2:	8b 00                	mov    (%eax),%eax
  8026d4:	85 c0                	test   %eax,%eax
  8026d6:	74 10                	je     8026e8 <alloc_block_FF+0x11d>
  8026d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026db:	8b 00                	mov    (%eax),%eax
  8026dd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026e0:	8b 52 04             	mov    0x4(%edx),%edx
  8026e3:	89 50 04             	mov    %edx,0x4(%eax)
  8026e6:	eb 0b                	jmp    8026f3 <alloc_block_FF+0x128>
  8026e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026eb:	8b 40 04             	mov    0x4(%eax),%eax
  8026ee:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8026f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026f6:	8b 40 04             	mov    0x4(%eax),%eax
  8026f9:	85 c0                	test   %eax,%eax
  8026fb:	74 0f                	je     80270c <alloc_block_FF+0x141>
  8026fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802700:	8b 40 04             	mov    0x4(%eax),%eax
  802703:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802706:	8b 12                	mov    (%edx),%edx
  802708:	89 10                	mov    %edx,(%eax)
  80270a:	eb 0a                	jmp    802716 <alloc_block_FF+0x14b>
  80270c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80270f:	8b 00                	mov    (%eax),%eax
  802711:	a3 48 51 80 00       	mov    %eax,0x805148
  802716:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802719:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80271f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802722:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802729:	a1 54 51 80 00       	mov    0x805154,%eax
  80272e:	48                   	dec    %eax
  80272f:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802734:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802737:	8b 50 08             	mov    0x8(%eax),%edx
  80273a:	8b 45 08             	mov    0x8(%ebp),%eax
  80273d:	01 c2                	add    %eax,%edx
  80273f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802742:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802745:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802748:	8b 40 0c             	mov    0xc(%eax),%eax
  80274b:	2b 45 08             	sub    0x8(%ebp),%eax
  80274e:	89 c2                	mov    %eax,%edx
  802750:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802753:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802756:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802759:	eb 3b                	jmp    802796 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80275b:	a1 40 51 80 00       	mov    0x805140,%eax
  802760:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802763:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802767:	74 07                	je     802770 <alloc_block_FF+0x1a5>
  802769:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276c:	8b 00                	mov    (%eax),%eax
  80276e:	eb 05                	jmp    802775 <alloc_block_FF+0x1aa>
  802770:	b8 00 00 00 00       	mov    $0x0,%eax
  802775:	a3 40 51 80 00       	mov    %eax,0x805140
  80277a:	a1 40 51 80 00       	mov    0x805140,%eax
  80277f:	85 c0                	test   %eax,%eax
  802781:	0f 85 57 fe ff ff    	jne    8025de <alloc_block_FF+0x13>
  802787:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80278b:	0f 85 4d fe ff ff    	jne    8025de <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802791:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802796:	c9                   	leave  
  802797:	c3                   	ret    

00802798 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802798:	55                   	push   %ebp
  802799:	89 e5                	mov    %esp,%ebp
  80279b:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  80279e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8027a5:	a1 38 51 80 00       	mov    0x805138,%eax
  8027aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027ad:	e9 df 00 00 00       	jmp    802891 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8027b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b5:	8b 40 0c             	mov    0xc(%eax),%eax
  8027b8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027bb:	0f 82 c8 00 00 00    	jb     802889 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8027c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c4:	8b 40 0c             	mov    0xc(%eax),%eax
  8027c7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027ca:	0f 85 8a 00 00 00    	jne    80285a <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8027d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027d4:	75 17                	jne    8027ed <alloc_block_BF+0x55>
  8027d6:	83 ec 04             	sub    $0x4,%esp
  8027d9:	68 20 44 80 00       	push   $0x804420
  8027de:	68 b7 00 00 00       	push   $0xb7
  8027e3:	68 77 43 80 00       	push   $0x804377
  8027e8:	e8 ba dc ff ff       	call   8004a7 <_panic>
  8027ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f0:	8b 00                	mov    (%eax),%eax
  8027f2:	85 c0                	test   %eax,%eax
  8027f4:	74 10                	je     802806 <alloc_block_BF+0x6e>
  8027f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f9:	8b 00                	mov    (%eax),%eax
  8027fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027fe:	8b 52 04             	mov    0x4(%edx),%edx
  802801:	89 50 04             	mov    %edx,0x4(%eax)
  802804:	eb 0b                	jmp    802811 <alloc_block_BF+0x79>
  802806:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802809:	8b 40 04             	mov    0x4(%eax),%eax
  80280c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802811:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802814:	8b 40 04             	mov    0x4(%eax),%eax
  802817:	85 c0                	test   %eax,%eax
  802819:	74 0f                	je     80282a <alloc_block_BF+0x92>
  80281b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281e:	8b 40 04             	mov    0x4(%eax),%eax
  802821:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802824:	8b 12                	mov    (%edx),%edx
  802826:	89 10                	mov    %edx,(%eax)
  802828:	eb 0a                	jmp    802834 <alloc_block_BF+0x9c>
  80282a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282d:	8b 00                	mov    (%eax),%eax
  80282f:	a3 38 51 80 00       	mov    %eax,0x805138
  802834:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802837:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80283d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802840:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802847:	a1 44 51 80 00       	mov    0x805144,%eax
  80284c:	48                   	dec    %eax
  80284d:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802852:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802855:	e9 4d 01 00 00       	jmp    8029a7 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  80285a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285d:	8b 40 0c             	mov    0xc(%eax),%eax
  802860:	3b 45 08             	cmp    0x8(%ebp),%eax
  802863:	76 24                	jbe    802889 <alloc_block_BF+0xf1>
  802865:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802868:	8b 40 0c             	mov    0xc(%eax),%eax
  80286b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80286e:	73 19                	jae    802889 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802870:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802877:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287a:	8b 40 0c             	mov    0xc(%eax),%eax
  80287d:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802880:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802883:	8b 40 08             	mov    0x8(%eax),%eax
  802886:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802889:	a1 40 51 80 00       	mov    0x805140,%eax
  80288e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802891:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802895:	74 07                	je     80289e <alloc_block_BF+0x106>
  802897:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289a:	8b 00                	mov    (%eax),%eax
  80289c:	eb 05                	jmp    8028a3 <alloc_block_BF+0x10b>
  80289e:	b8 00 00 00 00       	mov    $0x0,%eax
  8028a3:	a3 40 51 80 00       	mov    %eax,0x805140
  8028a8:	a1 40 51 80 00       	mov    0x805140,%eax
  8028ad:	85 c0                	test   %eax,%eax
  8028af:	0f 85 fd fe ff ff    	jne    8027b2 <alloc_block_BF+0x1a>
  8028b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028b9:	0f 85 f3 fe ff ff    	jne    8027b2 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  8028bf:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8028c3:	0f 84 d9 00 00 00    	je     8029a2 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8028c9:	a1 48 51 80 00       	mov    0x805148,%eax
  8028ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8028d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028d4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028d7:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8028da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028dd:	8b 55 08             	mov    0x8(%ebp),%edx
  8028e0:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  8028e3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8028e7:	75 17                	jne    802900 <alloc_block_BF+0x168>
  8028e9:	83 ec 04             	sub    $0x4,%esp
  8028ec:	68 20 44 80 00       	push   $0x804420
  8028f1:	68 c7 00 00 00       	push   $0xc7
  8028f6:	68 77 43 80 00       	push   $0x804377
  8028fb:	e8 a7 db ff ff       	call   8004a7 <_panic>
  802900:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802903:	8b 00                	mov    (%eax),%eax
  802905:	85 c0                	test   %eax,%eax
  802907:	74 10                	je     802919 <alloc_block_BF+0x181>
  802909:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80290c:	8b 00                	mov    (%eax),%eax
  80290e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802911:	8b 52 04             	mov    0x4(%edx),%edx
  802914:	89 50 04             	mov    %edx,0x4(%eax)
  802917:	eb 0b                	jmp    802924 <alloc_block_BF+0x18c>
  802919:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80291c:	8b 40 04             	mov    0x4(%eax),%eax
  80291f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802924:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802927:	8b 40 04             	mov    0x4(%eax),%eax
  80292a:	85 c0                	test   %eax,%eax
  80292c:	74 0f                	je     80293d <alloc_block_BF+0x1a5>
  80292e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802931:	8b 40 04             	mov    0x4(%eax),%eax
  802934:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802937:	8b 12                	mov    (%edx),%edx
  802939:	89 10                	mov    %edx,(%eax)
  80293b:	eb 0a                	jmp    802947 <alloc_block_BF+0x1af>
  80293d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802940:	8b 00                	mov    (%eax),%eax
  802942:	a3 48 51 80 00       	mov    %eax,0x805148
  802947:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80294a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802950:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802953:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80295a:	a1 54 51 80 00       	mov    0x805154,%eax
  80295f:	48                   	dec    %eax
  802960:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802965:	83 ec 08             	sub    $0x8,%esp
  802968:	ff 75 ec             	pushl  -0x14(%ebp)
  80296b:	68 38 51 80 00       	push   $0x805138
  802970:	e8 71 f9 ff ff       	call   8022e6 <find_block>
  802975:	83 c4 10             	add    $0x10,%esp
  802978:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  80297b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80297e:	8b 50 08             	mov    0x8(%eax),%edx
  802981:	8b 45 08             	mov    0x8(%ebp),%eax
  802984:	01 c2                	add    %eax,%edx
  802986:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802989:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  80298c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80298f:	8b 40 0c             	mov    0xc(%eax),%eax
  802992:	2b 45 08             	sub    0x8(%ebp),%eax
  802995:	89 c2                	mov    %eax,%edx
  802997:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80299a:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  80299d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029a0:	eb 05                	jmp    8029a7 <alloc_block_BF+0x20f>
	}
	return NULL;
  8029a2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029a7:	c9                   	leave  
  8029a8:	c3                   	ret    

008029a9 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8029a9:	55                   	push   %ebp
  8029aa:	89 e5                	mov    %esp,%ebp
  8029ac:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  8029af:	a1 28 50 80 00       	mov    0x805028,%eax
  8029b4:	85 c0                	test   %eax,%eax
  8029b6:	0f 85 de 01 00 00    	jne    802b9a <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8029bc:	a1 38 51 80 00       	mov    0x805138,%eax
  8029c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029c4:	e9 9e 01 00 00       	jmp    802b67 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8029c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029cc:	8b 40 0c             	mov    0xc(%eax),%eax
  8029cf:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029d2:	0f 82 87 01 00 00    	jb     802b5f <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  8029d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029db:	8b 40 0c             	mov    0xc(%eax),%eax
  8029de:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029e1:	0f 85 95 00 00 00    	jne    802a7c <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  8029e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029eb:	75 17                	jne    802a04 <alloc_block_NF+0x5b>
  8029ed:	83 ec 04             	sub    $0x4,%esp
  8029f0:	68 20 44 80 00       	push   $0x804420
  8029f5:	68 e0 00 00 00       	push   $0xe0
  8029fa:	68 77 43 80 00       	push   $0x804377
  8029ff:	e8 a3 da ff ff       	call   8004a7 <_panic>
  802a04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a07:	8b 00                	mov    (%eax),%eax
  802a09:	85 c0                	test   %eax,%eax
  802a0b:	74 10                	je     802a1d <alloc_block_NF+0x74>
  802a0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a10:	8b 00                	mov    (%eax),%eax
  802a12:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a15:	8b 52 04             	mov    0x4(%edx),%edx
  802a18:	89 50 04             	mov    %edx,0x4(%eax)
  802a1b:	eb 0b                	jmp    802a28 <alloc_block_NF+0x7f>
  802a1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a20:	8b 40 04             	mov    0x4(%eax),%eax
  802a23:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2b:	8b 40 04             	mov    0x4(%eax),%eax
  802a2e:	85 c0                	test   %eax,%eax
  802a30:	74 0f                	je     802a41 <alloc_block_NF+0x98>
  802a32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a35:	8b 40 04             	mov    0x4(%eax),%eax
  802a38:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a3b:	8b 12                	mov    (%edx),%edx
  802a3d:	89 10                	mov    %edx,(%eax)
  802a3f:	eb 0a                	jmp    802a4b <alloc_block_NF+0xa2>
  802a41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a44:	8b 00                	mov    (%eax),%eax
  802a46:	a3 38 51 80 00       	mov    %eax,0x805138
  802a4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a57:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a5e:	a1 44 51 80 00       	mov    0x805144,%eax
  802a63:	48                   	dec    %eax
  802a64:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802a69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6c:	8b 40 08             	mov    0x8(%eax),%eax
  802a6f:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802a74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a77:	e9 f8 04 00 00       	jmp    802f74 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802a7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7f:	8b 40 0c             	mov    0xc(%eax),%eax
  802a82:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a85:	0f 86 d4 00 00 00    	jbe    802b5f <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802a8b:	a1 48 51 80 00       	mov    0x805148,%eax
  802a90:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802a93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a96:	8b 50 08             	mov    0x8(%eax),%edx
  802a99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a9c:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802a9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aa2:	8b 55 08             	mov    0x8(%ebp),%edx
  802aa5:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802aa8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802aac:	75 17                	jne    802ac5 <alloc_block_NF+0x11c>
  802aae:	83 ec 04             	sub    $0x4,%esp
  802ab1:	68 20 44 80 00       	push   $0x804420
  802ab6:	68 e9 00 00 00       	push   $0xe9
  802abb:	68 77 43 80 00       	push   $0x804377
  802ac0:	e8 e2 d9 ff ff       	call   8004a7 <_panic>
  802ac5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ac8:	8b 00                	mov    (%eax),%eax
  802aca:	85 c0                	test   %eax,%eax
  802acc:	74 10                	je     802ade <alloc_block_NF+0x135>
  802ace:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ad1:	8b 00                	mov    (%eax),%eax
  802ad3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ad6:	8b 52 04             	mov    0x4(%edx),%edx
  802ad9:	89 50 04             	mov    %edx,0x4(%eax)
  802adc:	eb 0b                	jmp    802ae9 <alloc_block_NF+0x140>
  802ade:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae1:	8b 40 04             	mov    0x4(%eax),%eax
  802ae4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ae9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aec:	8b 40 04             	mov    0x4(%eax),%eax
  802aef:	85 c0                	test   %eax,%eax
  802af1:	74 0f                	je     802b02 <alloc_block_NF+0x159>
  802af3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802af6:	8b 40 04             	mov    0x4(%eax),%eax
  802af9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802afc:	8b 12                	mov    (%edx),%edx
  802afe:	89 10                	mov    %edx,(%eax)
  802b00:	eb 0a                	jmp    802b0c <alloc_block_NF+0x163>
  802b02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b05:	8b 00                	mov    (%eax),%eax
  802b07:	a3 48 51 80 00       	mov    %eax,0x805148
  802b0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b0f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b18:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b1f:	a1 54 51 80 00       	mov    0x805154,%eax
  802b24:	48                   	dec    %eax
  802b25:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802b2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b2d:	8b 40 08             	mov    0x8(%eax),%eax
  802b30:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802b35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b38:	8b 50 08             	mov    0x8(%eax),%edx
  802b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3e:	01 c2                	add    %eax,%edx
  802b40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b43:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802b46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b49:	8b 40 0c             	mov    0xc(%eax),%eax
  802b4c:	2b 45 08             	sub    0x8(%ebp),%eax
  802b4f:	89 c2                	mov    %eax,%edx
  802b51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b54:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802b57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b5a:	e9 15 04 00 00       	jmp    802f74 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802b5f:	a1 40 51 80 00       	mov    0x805140,%eax
  802b64:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b67:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b6b:	74 07                	je     802b74 <alloc_block_NF+0x1cb>
  802b6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b70:	8b 00                	mov    (%eax),%eax
  802b72:	eb 05                	jmp    802b79 <alloc_block_NF+0x1d0>
  802b74:	b8 00 00 00 00       	mov    $0x0,%eax
  802b79:	a3 40 51 80 00       	mov    %eax,0x805140
  802b7e:	a1 40 51 80 00       	mov    0x805140,%eax
  802b83:	85 c0                	test   %eax,%eax
  802b85:	0f 85 3e fe ff ff    	jne    8029c9 <alloc_block_NF+0x20>
  802b8b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b8f:	0f 85 34 fe ff ff    	jne    8029c9 <alloc_block_NF+0x20>
  802b95:	e9 d5 03 00 00       	jmp    802f6f <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b9a:	a1 38 51 80 00       	mov    0x805138,%eax
  802b9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ba2:	e9 b1 01 00 00       	jmp    802d58 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802ba7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802baa:	8b 50 08             	mov    0x8(%eax),%edx
  802bad:	a1 28 50 80 00       	mov    0x805028,%eax
  802bb2:	39 c2                	cmp    %eax,%edx
  802bb4:	0f 82 96 01 00 00    	jb     802d50 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802bba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bbd:	8b 40 0c             	mov    0xc(%eax),%eax
  802bc0:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bc3:	0f 82 87 01 00 00    	jb     802d50 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802bc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bcc:	8b 40 0c             	mov    0xc(%eax),%eax
  802bcf:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bd2:	0f 85 95 00 00 00    	jne    802c6d <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802bd8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bdc:	75 17                	jne    802bf5 <alloc_block_NF+0x24c>
  802bde:	83 ec 04             	sub    $0x4,%esp
  802be1:	68 20 44 80 00       	push   $0x804420
  802be6:	68 fc 00 00 00       	push   $0xfc
  802beb:	68 77 43 80 00       	push   $0x804377
  802bf0:	e8 b2 d8 ff ff       	call   8004a7 <_panic>
  802bf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf8:	8b 00                	mov    (%eax),%eax
  802bfa:	85 c0                	test   %eax,%eax
  802bfc:	74 10                	je     802c0e <alloc_block_NF+0x265>
  802bfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c01:	8b 00                	mov    (%eax),%eax
  802c03:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c06:	8b 52 04             	mov    0x4(%edx),%edx
  802c09:	89 50 04             	mov    %edx,0x4(%eax)
  802c0c:	eb 0b                	jmp    802c19 <alloc_block_NF+0x270>
  802c0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c11:	8b 40 04             	mov    0x4(%eax),%eax
  802c14:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1c:	8b 40 04             	mov    0x4(%eax),%eax
  802c1f:	85 c0                	test   %eax,%eax
  802c21:	74 0f                	je     802c32 <alloc_block_NF+0x289>
  802c23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c26:	8b 40 04             	mov    0x4(%eax),%eax
  802c29:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c2c:	8b 12                	mov    (%edx),%edx
  802c2e:	89 10                	mov    %edx,(%eax)
  802c30:	eb 0a                	jmp    802c3c <alloc_block_NF+0x293>
  802c32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c35:	8b 00                	mov    (%eax),%eax
  802c37:	a3 38 51 80 00       	mov    %eax,0x805138
  802c3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c48:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c4f:	a1 44 51 80 00       	mov    0x805144,%eax
  802c54:	48                   	dec    %eax
  802c55:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802c5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5d:	8b 40 08             	mov    0x8(%eax),%eax
  802c60:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802c65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c68:	e9 07 03 00 00       	jmp    802f74 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802c6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c70:	8b 40 0c             	mov    0xc(%eax),%eax
  802c73:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c76:	0f 86 d4 00 00 00    	jbe    802d50 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802c7c:	a1 48 51 80 00       	mov    0x805148,%eax
  802c81:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802c84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c87:	8b 50 08             	mov    0x8(%eax),%edx
  802c8a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c8d:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802c90:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c93:	8b 55 08             	mov    0x8(%ebp),%edx
  802c96:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802c99:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802c9d:	75 17                	jne    802cb6 <alloc_block_NF+0x30d>
  802c9f:	83 ec 04             	sub    $0x4,%esp
  802ca2:	68 20 44 80 00       	push   $0x804420
  802ca7:	68 04 01 00 00       	push   $0x104
  802cac:	68 77 43 80 00       	push   $0x804377
  802cb1:	e8 f1 d7 ff ff       	call   8004a7 <_panic>
  802cb6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cb9:	8b 00                	mov    (%eax),%eax
  802cbb:	85 c0                	test   %eax,%eax
  802cbd:	74 10                	je     802ccf <alloc_block_NF+0x326>
  802cbf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cc2:	8b 00                	mov    (%eax),%eax
  802cc4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802cc7:	8b 52 04             	mov    0x4(%edx),%edx
  802cca:	89 50 04             	mov    %edx,0x4(%eax)
  802ccd:	eb 0b                	jmp    802cda <alloc_block_NF+0x331>
  802ccf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cd2:	8b 40 04             	mov    0x4(%eax),%eax
  802cd5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802cda:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cdd:	8b 40 04             	mov    0x4(%eax),%eax
  802ce0:	85 c0                	test   %eax,%eax
  802ce2:	74 0f                	je     802cf3 <alloc_block_NF+0x34a>
  802ce4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ce7:	8b 40 04             	mov    0x4(%eax),%eax
  802cea:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ced:	8b 12                	mov    (%edx),%edx
  802cef:	89 10                	mov    %edx,(%eax)
  802cf1:	eb 0a                	jmp    802cfd <alloc_block_NF+0x354>
  802cf3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cf6:	8b 00                	mov    (%eax),%eax
  802cf8:	a3 48 51 80 00       	mov    %eax,0x805148
  802cfd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d00:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d06:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d09:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d10:	a1 54 51 80 00       	mov    0x805154,%eax
  802d15:	48                   	dec    %eax
  802d16:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802d1b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d1e:	8b 40 08             	mov    0x8(%eax),%eax
  802d21:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802d26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d29:	8b 50 08             	mov    0x8(%eax),%edx
  802d2c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2f:	01 c2                	add    %eax,%edx
  802d31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d34:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802d37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3a:	8b 40 0c             	mov    0xc(%eax),%eax
  802d3d:	2b 45 08             	sub    0x8(%ebp),%eax
  802d40:	89 c2                	mov    %eax,%edx
  802d42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d45:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802d48:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d4b:	e9 24 02 00 00       	jmp    802f74 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802d50:	a1 40 51 80 00       	mov    0x805140,%eax
  802d55:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d58:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d5c:	74 07                	je     802d65 <alloc_block_NF+0x3bc>
  802d5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d61:	8b 00                	mov    (%eax),%eax
  802d63:	eb 05                	jmp    802d6a <alloc_block_NF+0x3c1>
  802d65:	b8 00 00 00 00       	mov    $0x0,%eax
  802d6a:	a3 40 51 80 00       	mov    %eax,0x805140
  802d6f:	a1 40 51 80 00       	mov    0x805140,%eax
  802d74:	85 c0                	test   %eax,%eax
  802d76:	0f 85 2b fe ff ff    	jne    802ba7 <alloc_block_NF+0x1fe>
  802d7c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d80:	0f 85 21 fe ff ff    	jne    802ba7 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802d86:	a1 38 51 80 00       	mov    0x805138,%eax
  802d8b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d8e:	e9 ae 01 00 00       	jmp    802f41 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802d93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d96:	8b 50 08             	mov    0x8(%eax),%edx
  802d99:	a1 28 50 80 00       	mov    0x805028,%eax
  802d9e:	39 c2                	cmp    %eax,%edx
  802da0:	0f 83 93 01 00 00    	jae    802f39 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802da6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da9:	8b 40 0c             	mov    0xc(%eax),%eax
  802dac:	3b 45 08             	cmp    0x8(%ebp),%eax
  802daf:	0f 82 84 01 00 00    	jb     802f39 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802db5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db8:	8b 40 0c             	mov    0xc(%eax),%eax
  802dbb:	3b 45 08             	cmp    0x8(%ebp),%eax
  802dbe:	0f 85 95 00 00 00    	jne    802e59 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802dc4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dc8:	75 17                	jne    802de1 <alloc_block_NF+0x438>
  802dca:	83 ec 04             	sub    $0x4,%esp
  802dcd:	68 20 44 80 00       	push   $0x804420
  802dd2:	68 14 01 00 00       	push   $0x114
  802dd7:	68 77 43 80 00       	push   $0x804377
  802ddc:	e8 c6 d6 ff ff       	call   8004a7 <_panic>
  802de1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de4:	8b 00                	mov    (%eax),%eax
  802de6:	85 c0                	test   %eax,%eax
  802de8:	74 10                	je     802dfa <alloc_block_NF+0x451>
  802dea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ded:	8b 00                	mov    (%eax),%eax
  802def:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802df2:	8b 52 04             	mov    0x4(%edx),%edx
  802df5:	89 50 04             	mov    %edx,0x4(%eax)
  802df8:	eb 0b                	jmp    802e05 <alloc_block_NF+0x45c>
  802dfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dfd:	8b 40 04             	mov    0x4(%eax),%eax
  802e00:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e08:	8b 40 04             	mov    0x4(%eax),%eax
  802e0b:	85 c0                	test   %eax,%eax
  802e0d:	74 0f                	je     802e1e <alloc_block_NF+0x475>
  802e0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e12:	8b 40 04             	mov    0x4(%eax),%eax
  802e15:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e18:	8b 12                	mov    (%edx),%edx
  802e1a:	89 10                	mov    %edx,(%eax)
  802e1c:	eb 0a                	jmp    802e28 <alloc_block_NF+0x47f>
  802e1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e21:	8b 00                	mov    (%eax),%eax
  802e23:	a3 38 51 80 00       	mov    %eax,0x805138
  802e28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e34:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e3b:	a1 44 51 80 00       	mov    0x805144,%eax
  802e40:	48                   	dec    %eax
  802e41:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802e46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e49:	8b 40 08             	mov    0x8(%eax),%eax
  802e4c:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802e51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e54:	e9 1b 01 00 00       	jmp    802f74 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802e59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5c:	8b 40 0c             	mov    0xc(%eax),%eax
  802e5f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e62:	0f 86 d1 00 00 00    	jbe    802f39 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802e68:	a1 48 51 80 00       	mov    0x805148,%eax
  802e6d:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802e70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e73:	8b 50 08             	mov    0x8(%eax),%edx
  802e76:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e79:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802e7c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e7f:	8b 55 08             	mov    0x8(%ebp),%edx
  802e82:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802e85:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802e89:	75 17                	jne    802ea2 <alloc_block_NF+0x4f9>
  802e8b:	83 ec 04             	sub    $0x4,%esp
  802e8e:	68 20 44 80 00       	push   $0x804420
  802e93:	68 1c 01 00 00       	push   $0x11c
  802e98:	68 77 43 80 00       	push   $0x804377
  802e9d:	e8 05 d6 ff ff       	call   8004a7 <_panic>
  802ea2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ea5:	8b 00                	mov    (%eax),%eax
  802ea7:	85 c0                	test   %eax,%eax
  802ea9:	74 10                	je     802ebb <alloc_block_NF+0x512>
  802eab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eae:	8b 00                	mov    (%eax),%eax
  802eb0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802eb3:	8b 52 04             	mov    0x4(%edx),%edx
  802eb6:	89 50 04             	mov    %edx,0x4(%eax)
  802eb9:	eb 0b                	jmp    802ec6 <alloc_block_NF+0x51d>
  802ebb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ebe:	8b 40 04             	mov    0x4(%eax),%eax
  802ec1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ec6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ec9:	8b 40 04             	mov    0x4(%eax),%eax
  802ecc:	85 c0                	test   %eax,%eax
  802ece:	74 0f                	je     802edf <alloc_block_NF+0x536>
  802ed0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ed3:	8b 40 04             	mov    0x4(%eax),%eax
  802ed6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ed9:	8b 12                	mov    (%edx),%edx
  802edb:	89 10                	mov    %edx,(%eax)
  802edd:	eb 0a                	jmp    802ee9 <alloc_block_NF+0x540>
  802edf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ee2:	8b 00                	mov    (%eax),%eax
  802ee4:	a3 48 51 80 00       	mov    %eax,0x805148
  802ee9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ef2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ef5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802efc:	a1 54 51 80 00       	mov    0x805154,%eax
  802f01:	48                   	dec    %eax
  802f02:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802f07:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f0a:	8b 40 08             	mov    0x8(%eax),%eax
  802f0d:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802f12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f15:	8b 50 08             	mov    0x8(%eax),%edx
  802f18:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1b:	01 c2                	add    %eax,%edx
  802f1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f20:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802f23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f26:	8b 40 0c             	mov    0xc(%eax),%eax
  802f29:	2b 45 08             	sub    0x8(%ebp),%eax
  802f2c:	89 c2                	mov    %eax,%edx
  802f2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f31:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802f34:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f37:	eb 3b                	jmp    802f74 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802f39:	a1 40 51 80 00       	mov    0x805140,%eax
  802f3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f41:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f45:	74 07                	je     802f4e <alloc_block_NF+0x5a5>
  802f47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4a:	8b 00                	mov    (%eax),%eax
  802f4c:	eb 05                	jmp    802f53 <alloc_block_NF+0x5aa>
  802f4e:	b8 00 00 00 00       	mov    $0x0,%eax
  802f53:	a3 40 51 80 00       	mov    %eax,0x805140
  802f58:	a1 40 51 80 00       	mov    0x805140,%eax
  802f5d:	85 c0                	test   %eax,%eax
  802f5f:	0f 85 2e fe ff ff    	jne    802d93 <alloc_block_NF+0x3ea>
  802f65:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f69:	0f 85 24 fe ff ff    	jne    802d93 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802f6f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f74:	c9                   	leave  
  802f75:	c3                   	ret    

00802f76 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802f76:	55                   	push   %ebp
  802f77:	89 e5                	mov    %esp,%ebp
  802f79:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802f7c:	a1 38 51 80 00       	mov    0x805138,%eax
  802f81:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802f84:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802f89:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802f8c:	a1 38 51 80 00       	mov    0x805138,%eax
  802f91:	85 c0                	test   %eax,%eax
  802f93:	74 14                	je     802fa9 <insert_sorted_with_merge_freeList+0x33>
  802f95:	8b 45 08             	mov    0x8(%ebp),%eax
  802f98:	8b 50 08             	mov    0x8(%eax),%edx
  802f9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f9e:	8b 40 08             	mov    0x8(%eax),%eax
  802fa1:	39 c2                	cmp    %eax,%edx
  802fa3:	0f 87 9b 01 00 00    	ja     803144 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802fa9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fad:	75 17                	jne    802fc6 <insert_sorted_with_merge_freeList+0x50>
  802faf:	83 ec 04             	sub    $0x4,%esp
  802fb2:	68 54 43 80 00       	push   $0x804354
  802fb7:	68 38 01 00 00       	push   $0x138
  802fbc:	68 77 43 80 00       	push   $0x804377
  802fc1:	e8 e1 d4 ff ff       	call   8004a7 <_panic>
  802fc6:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802fcc:	8b 45 08             	mov    0x8(%ebp),%eax
  802fcf:	89 10                	mov    %edx,(%eax)
  802fd1:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd4:	8b 00                	mov    (%eax),%eax
  802fd6:	85 c0                	test   %eax,%eax
  802fd8:	74 0d                	je     802fe7 <insert_sorted_with_merge_freeList+0x71>
  802fda:	a1 38 51 80 00       	mov    0x805138,%eax
  802fdf:	8b 55 08             	mov    0x8(%ebp),%edx
  802fe2:	89 50 04             	mov    %edx,0x4(%eax)
  802fe5:	eb 08                	jmp    802fef <insert_sorted_with_merge_freeList+0x79>
  802fe7:	8b 45 08             	mov    0x8(%ebp),%eax
  802fea:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fef:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff2:	a3 38 51 80 00       	mov    %eax,0x805138
  802ff7:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803001:	a1 44 51 80 00       	mov    0x805144,%eax
  803006:	40                   	inc    %eax
  803007:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80300c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803010:	0f 84 a8 06 00 00    	je     8036be <insert_sorted_with_merge_freeList+0x748>
  803016:	8b 45 08             	mov    0x8(%ebp),%eax
  803019:	8b 50 08             	mov    0x8(%eax),%edx
  80301c:	8b 45 08             	mov    0x8(%ebp),%eax
  80301f:	8b 40 0c             	mov    0xc(%eax),%eax
  803022:	01 c2                	add    %eax,%edx
  803024:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803027:	8b 40 08             	mov    0x8(%eax),%eax
  80302a:	39 c2                	cmp    %eax,%edx
  80302c:	0f 85 8c 06 00 00    	jne    8036be <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  803032:	8b 45 08             	mov    0x8(%ebp),%eax
  803035:	8b 50 0c             	mov    0xc(%eax),%edx
  803038:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80303b:	8b 40 0c             	mov    0xc(%eax),%eax
  80303e:	01 c2                	add    %eax,%edx
  803040:	8b 45 08             	mov    0x8(%ebp),%eax
  803043:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  803046:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80304a:	75 17                	jne    803063 <insert_sorted_with_merge_freeList+0xed>
  80304c:	83 ec 04             	sub    $0x4,%esp
  80304f:	68 20 44 80 00       	push   $0x804420
  803054:	68 3c 01 00 00       	push   $0x13c
  803059:	68 77 43 80 00       	push   $0x804377
  80305e:	e8 44 d4 ff ff       	call   8004a7 <_panic>
  803063:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803066:	8b 00                	mov    (%eax),%eax
  803068:	85 c0                	test   %eax,%eax
  80306a:	74 10                	je     80307c <insert_sorted_with_merge_freeList+0x106>
  80306c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80306f:	8b 00                	mov    (%eax),%eax
  803071:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803074:	8b 52 04             	mov    0x4(%edx),%edx
  803077:	89 50 04             	mov    %edx,0x4(%eax)
  80307a:	eb 0b                	jmp    803087 <insert_sorted_with_merge_freeList+0x111>
  80307c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80307f:	8b 40 04             	mov    0x4(%eax),%eax
  803082:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803087:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80308a:	8b 40 04             	mov    0x4(%eax),%eax
  80308d:	85 c0                	test   %eax,%eax
  80308f:	74 0f                	je     8030a0 <insert_sorted_with_merge_freeList+0x12a>
  803091:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803094:	8b 40 04             	mov    0x4(%eax),%eax
  803097:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80309a:	8b 12                	mov    (%edx),%edx
  80309c:	89 10                	mov    %edx,(%eax)
  80309e:	eb 0a                	jmp    8030aa <insert_sorted_with_merge_freeList+0x134>
  8030a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030a3:	8b 00                	mov    (%eax),%eax
  8030a5:	a3 38 51 80 00       	mov    %eax,0x805138
  8030aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030ad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030b6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030bd:	a1 44 51 80 00       	mov    0x805144,%eax
  8030c2:	48                   	dec    %eax
  8030c3:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  8030c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030cb:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  8030d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030d5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  8030dc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8030e0:	75 17                	jne    8030f9 <insert_sorted_with_merge_freeList+0x183>
  8030e2:	83 ec 04             	sub    $0x4,%esp
  8030e5:	68 54 43 80 00       	push   $0x804354
  8030ea:	68 3f 01 00 00       	push   $0x13f
  8030ef:	68 77 43 80 00       	push   $0x804377
  8030f4:	e8 ae d3 ff ff       	call   8004a7 <_panic>
  8030f9:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8030ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803102:	89 10                	mov    %edx,(%eax)
  803104:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803107:	8b 00                	mov    (%eax),%eax
  803109:	85 c0                	test   %eax,%eax
  80310b:	74 0d                	je     80311a <insert_sorted_with_merge_freeList+0x1a4>
  80310d:	a1 48 51 80 00       	mov    0x805148,%eax
  803112:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803115:	89 50 04             	mov    %edx,0x4(%eax)
  803118:	eb 08                	jmp    803122 <insert_sorted_with_merge_freeList+0x1ac>
  80311a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80311d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803122:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803125:	a3 48 51 80 00       	mov    %eax,0x805148
  80312a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80312d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803134:	a1 54 51 80 00       	mov    0x805154,%eax
  803139:	40                   	inc    %eax
  80313a:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80313f:	e9 7a 05 00 00       	jmp    8036be <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  803144:	8b 45 08             	mov    0x8(%ebp),%eax
  803147:	8b 50 08             	mov    0x8(%eax),%edx
  80314a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80314d:	8b 40 08             	mov    0x8(%eax),%eax
  803150:	39 c2                	cmp    %eax,%edx
  803152:	0f 82 14 01 00 00    	jb     80326c <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  803158:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80315b:	8b 50 08             	mov    0x8(%eax),%edx
  80315e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803161:	8b 40 0c             	mov    0xc(%eax),%eax
  803164:	01 c2                	add    %eax,%edx
  803166:	8b 45 08             	mov    0x8(%ebp),%eax
  803169:	8b 40 08             	mov    0x8(%eax),%eax
  80316c:	39 c2                	cmp    %eax,%edx
  80316e:	0f 85 90 00 00 00    	jne    803204 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  803174:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803177:	8b 50 0c             	mov    0xc(%eax),%edx
  80317a:	8b 45 08             	mov    0x8(%ebp),%eax
  80317d:	8b 40 0c             	mov    0xc(%eax),%eax
  803180:	01 c2                	add    %eax,%edx
  803182:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803185:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  803188:	8b 45 08             	mov    0x8(%ebp),%eax
  80318b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  803192:	8b 45 08             	mov    0x8(%ebp),%eax
  803195:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80319c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031a0:	75 17                	jne    8031b9 <insert_sorted_with_merge_freeList+0x243>
  8031a2:	83 ec 04             	sub    $0x4,%esp
  8031a5:	68 54 43 80 00       	push   $0x804354
  8031aa:	68 49 01 00 00       	push   $0x149
  8031af:	68 77 43 80 00       	push   $0x804377
  8031b4:	e8 ee d2 ff ff       	call   8004a7 <_panic>
  8031b9:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8031bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c2:	89 10                	mov    %edx,(%eax)
  8031c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c7:	8b 00                	mov    (%eax),%eax
  8031c9:	85 c0                	test   %eax,%eax
  8031cb:	74 0d                	je     8031da <insert_sorted_with_merge_freeList+0x264>
  8031cd:	a1 48 51 80 00       	mov    0x805148,%eax
  8031d2:	8b 55 08             	mov    0x8(%ebp),%edx
  8031d5:	89 50 04             	mov    %edx,0x4(%eax)
  8031d8:	eb 08                	jmp    8031e2 <insert_sorted_with_merge_freeList+0x26c>
  8031da:	8b 45 08             	mov    0x8(%ebp),%eax
  8031dd:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e5:	a3 48 51 80 00       	mov    %eax,0x805148
  8031ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ed:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031f4:	a1 54 51 80 00       	mov    0x805154,%eax
  8031f9:	40                   	inc    %eax
  8031fa:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8031ff:	e9 bb 04 00 00       	jmp    8036bf <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803204:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803208:	75 17                	jne    803221 <insert_sorted_with_merge_freeList+0x2ab>
  80320a:	83 ec 04             	sub    $0x4,%esp
  80320d:	68 c8 43 80 00       	push   $0x8043c8
  803212:	68 4c 01 00 00       	push   $0x14c
  803217:	68 77 43 80 00       	push   $0x804377
  80321c:	e8 86 d2 ff ff       	call   8004a7 <_panic>
  803221:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803227:	8b 45 08             	mov    0x8(%ebp),%eax
  80322a:	89 50 04             	mov    %edx,0x4(%eax)
  80322d:	8b 45 08             	mov    0x8(%ebp),%eax
  803230:	8b 40 04             	mov    0x4(%eax),%eax
  803233:	85 c0                	test   %eax,%eax
  803235:	74 0c                	je     803243 <insert_sorted_with_merge_freeList+0x2cd>
  803237:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80323c:	8b 55 08             	mov    0x8(%ebp),%edx
  80323f:	89 10                	mov    %edx,(%eax)
  803241:	eb 08                	jmp    80324b <insert_sorted_with_merge_freeList+0x2d5>
  803243:	8b 45 08             	mov    0x8(%ebp),%eax
  803246:	a3 38 51 80 00       	mov    %eax,0x805138
  80324b:	8b 45 08             	mov    0x8(%ebp),%eax
  80324e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803253:	8b 45 08             	mov    0x8(%ebp),%eax
  803256:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80325c:	a1 44 51 80 00       	mov    0x805144,%eax
  803261:	40                   	inc    %eax
  803262:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803267:	e9 53 04 00 00       	jmp    8036bf <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80326c:	a1 38 51 80 00       	mov    0x805138,%eax
  803271:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803274:	e9 15 04 00 00       	jmp    80368e <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  803279:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80327c:	8b 00                	mov    (%eax),%eax
  80327e:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803281:	8b 45 08             	mov    0x8(%ebp),%eax
  803284:	8b 50 08             	mov    0x8(%eax),%edx
  803287:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80328a:	8b 40 08             	mov    0x8(%eax),%eax
  80328d:	39 c2                	cmp    %eax,%edx
  80328f:	0f 86 f1 03 00 00    	jbe    803686 <insert_sorted_with_merge_freeList+0x710>
  803295:	8b 45 08             	mov    0x8(%ebp),%eax
  803298:	8b 50 08             	mov    0x8(%eax),%edx
  80329b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80329e:	8b 40 08             	mov    0x8(%eax),%eax
  8032a1:	39 c2                	cmp    %eax,%edx
  8032a3:	0f 83 dd 03 00 00    	jae    803686 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  8032a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ac:	8b 50 08             	mov    0x8(%eax),%edx
  8032af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b2:	8b 40 0c             	mov    0xc(%eax),%eax
  8032b5:	01 c2                	add    %eax,%edx
  8032b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ba:	8b 40 08             	mov    0x8(%eax),%eax
  8032bd:	39 c2                	cmp    %eax,%edx
  8032bf:	0f 85 b9 01 00 00    	jne    80347e <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8032c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c8:	8b 50 08             	mov    0x8(%eax),%edx
  8032cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ce:	8b 40 0c             	mov    0xc(%eax),%eax
  8032d1:	01 c2                	add    %eax,%edx
  8032d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032d6:	8b 40 08             	mov    0x8(%eax),%eax
  8032d9:	39 c2                	cmp    %eax,%edx
  8032db:	0f 85 0d 01 00 00    	jne    8033ee <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  8032e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032e4:	8b 50 0c             	mov    0xc(%eax),%edx
  8032e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032ea:	8b 40 0c             	mov    0xc(%eax),%eax
  8032ed:	01 c2                	add    %eax,%edx
  8032ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f2:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8032f5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032f9:	75 17                	jne    803312 <insert_sorted_with_merge_freeList+0x39c>
  8032fb:	83 ec 04             	sub    $0x4,%esp
  8032fe:	68 20 44 80 00       	push   $0x804420
  803303:	68 5c 01 00 00       	push   $0x15c
  803308:	68 77 43 80 00       	push   $0x804377
  80330d:	e8 95 d1 ff ff       	call   8004a7 <_panic>
  803312:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803315:	8b 00                	mov    (%eax),%eax
  803317:	85 c0                	test   %eax,%eax
  803319:	74 10                	je     80332b <insert_sorted_with_merge_freeList+0x3b5>
  80331b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80331e:	8b 00                	mov    (%eax),%eax
  803320:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803323:	8b 52 04             	mov    0x4(%edx),%edx
  803326:	89 50 04             	mov    %edx,0x4(%eax)
  803329:	eb 0b                	jmp    803336 <insert_sorted_with_merge_freeList+0x3c0>
  80332b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80332e:	8b 40 04             	mov    0x4(%eax),%eax
  803331:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803336:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803339:	8b 40 04             	mov    0x4(%eax),%eax
  80333c:	85 c0                	test   %eax,%eax
  80333e:	74 0f                	je     80334f <insert_sorted_with_merge_freeList+0x3d9>
  803340:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803343:	8b 40 04             	mov    0x4(%eax),%eax
  803346:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803349:	8b 12                	mov    (%edx),%edx
  80334b:	89 10                	mov    %edx,(%eax)
  80334d:	eb 0a                	jmp    803359 <insert_sorted_with_merge_freeList+0x3e3>
  80334f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803352:	8b 00                	mov    (%eax),%eax
  803354:	a3 38 51 80 00       	mov    %eax,0x805138
  803359:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80335c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803362:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803365:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80336c:	a1 44 51 80 00       	mov    0x805144,%eax
  803371:	48                   	dec    %eax
  803372:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803377:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80337a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803381:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803384:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80338b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80338f:	75 17                	jne    8033a8 <insert_sorted_with_merge_freeList+0x432>
  803391:	83 ec 04             	sub    $0x4,%esp
  803394:	68 54 43 80 00       	push   $0x804354
  803399:	68 5f 01 00 00       	push   $0x15f
  80339e:	68 77 43 80 00       	push   $0x804377
  8033a3:	e8 ff d0 ff ff       	call   8004a7 <_panic>
  8033a8:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8033ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033b1:	89 10                	mov    %edx,(%eax)
  8033b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033b6:	8b 00                	mov    (%eax),%eax
  8033b8:	85 c0                	test   %eax,%eax
  8033ba:	74 0d                	je     8033c9 <insert_sorted_with_merge_freeList+0x453>
  8033bc:	a1 48 51 80 00       	mov    0x805148,%eax
  8033c1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033c4:	89 50 04             	mov    %edx,0x4(%eax)
  8033c7:	eb 08                	jmp    8033d1 <insert_sorted_with_merge_freeList+0x45b>
  8033c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033cc:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8033d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033d4:	a3 48 51 80 00       	mov    %eax,0x805148
  8033d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033dc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033e3:	a1 54 51 80 00       	mov    0x805154,%eax
  8033e8:	40                   	inc    %eax
  8033e9:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  8033ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f1:	8b 50 0c             	mov    0xc(%eax),%edx
  8033f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f7:	8b 40 0c             	mov    0xc(%eax),%eax
  8033fa:	01 c2                	add    %eax,%edx
  8033fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ff:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803402:	8b 45 08             	mov    0x8(%ebp),%eax
  803405:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  80340c:	8b 45 08             	mov    0x8(%ebp),%eax
  80340f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803416:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80341a:	75 17                	jne    803433 <insert_sorted_with_merge_freeList+0x4bd>
  80341c:	83 ec 04             	sub    $0x4,%esp
  80341f:	68 54 43 80 00       	push   $0x804354
  803424:	68 64 01 00 00       	push   $0x164
  803429:	68 77 43 80 00       	push   $0x804377
  80342e:	e8 74 d0 ff ff       	call   8004a7 <_panic>
  803433:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803439:	8b 45 08             	mov    0x8(%ebp),%eax
  80343c:	89 10                	mov    %edx,(%eax)
  80343e:	8b 45 08             	mov    0x8(%ebp),%eax
  803441:	8b 00                	mov    (%eax),%eax
  803443:	85 c0                	test   %eax,%eax
  803445:	74 0d                	je     803454 <insert_sorted_with_merge_freeList+0x4de>
  803447:	a1 48 51 80 00       	mov    0x805148,%eax
  80344c:	8b 55 08             	mov    0x8(%ebp),%edx
  80344f:	89 50 04             	mov    %edx,0x4(%eax)
  803452:	eb 08                	jmp    80345c <insert_sorted_with_merge_freeList+0x4e6>
  803454:	8b 45 08             	mov    0x8(%ebp),%eax
  803457:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80345c:	8b 45 08             	mov    0x8(%ebp),%eax
  80345f:	a3 48 51 80 00       	mov    %eax,0x805148
  803464:	8b 45 08             	mov    0x8(%ebp),%eax
  803467:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80346e:	a1 54 51 80 00       	mov    0x805154,%eax
  803473:	40                   	inc    %eax
  803474:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803479:	e9 41 02 00 00       	jmp    8036bf <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80347e:	8b 45 08             	mov    0x8(%ebp),%eax
  803481:	8b 50 08             	mov    0x8(%eax),%edx
  803484:	8b 45 08             	mov    0x8(%ebp),%eax
  803487:	8b 40 0c             	mov    0xc(%eax),%eax
  80348a:	01 c2                	add    %eax,%edx
  80348c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80348f:	8b 40 08             	mov    0x8(%eax),%eax
  803492:	39 c2                	cmp    %eax,%edx
  803494:	0f 85 7c 01 00 00    	jne    803616 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  80349a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80349e:	74 06                	je     8034a6 <insert_sorted_with_merge_freeList+0x530>
  8034a0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034a4:	75 17                	jne    8034bd <insert_sorted_with_merge_freeList+0x547>
  8034a6:	83 ec 04             	sub    $0x4,%esp
  8034a9:	68 90 43 80 00       	push   $0x804390
  8034ae:	68 69 01 00 00       	push   $0x169
  8034b3:	68 77 43 80 00       	push   $0x804377
  8034b8:	e8 ea cf ff ff       	call   8004a7 <_panic>
  8034bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034c0:	8b 50 04             	mov    0x4(%eax),%edx
  8034c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c6:	89 50 04             	mov    %edx,0x4(%eax)
  8034c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8034cc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8034cf:	89 10                	mov    %edx,(%eax)
  8034d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034d4:	8b 40 04             	mov    0x4(%eax),%eax
  8034d7:	85 c0                	test   %eax,%eax
  8034d9:	74 0d                	je     8034e8 <insert_sorted_with_merge_freeList+0x572>
  8034db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034de:	8b 40 04             	mov    0x4(%eax),%eax
  8034e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8034e4:	89 10                	mov    %edx,(%eax)
  8034e6:	eb 08                	jmp    8034f0 <insert_sorted_with_merge_freeList+0x57a>
  8034e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8034eb:	a3 38 51 80 00       	mov    %eax,0x805138
  8034f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8034f6:	89 50 04             	mov    %edx,0x4(%eax)
  8034f9:	a1 44 51 80 00       	mov    0x805144,%eax
  8034fe:	40                   	inc    %eax
  8034ff:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803504:	8b 45 08             	mov    0x8(%ebp),%eax
  803507:	8b 50 0c             	mov    0xc(%eax),%edx
  80350a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80350d:	8b 40 0c             	mov    0xc(%eax),%eax
  803510:	01 c2                	add    %eax,%edx
  803512:	8b 45 08             	mov    0x8(%ebp),%eax
  803515:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803518:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80351c:	75 17                	jne    803535 <insert_sorted_with_merge_freeList+0x5bf>
  80351e:	83 ec 04             	sub    $0x4,%esp
  803521:	68 20 44 80 00       	push   $0x804420
  803526:	68 6b 01 00 00       	push   $0x16b
  80352b:	68 77 43 80 00       	push   $0x804377
  803530:	e8 72 cf ff ff       	call   8004a7 <_panic>
  803535:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803538:	8b 00                	mov    (%eax),%eax
  80353a:	85 c0                	test   %eax,%eax
  80353c:	74 10                	je     80354e <insert_sorted_with_merge_freeList+0x5d8>
  80353e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803541:	8b 00                	mov    (%eax),%eax
  803543:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803546:	8b 52 04             	mov    0x4(%edx),%edx
  803549:	89 50 04             	mov    %edx,0x4(%eax)
  80354c:	eb 0b                	jmp    803559 <insert_sorted_with_merge_freeList+0x5e3>
  80354e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803551:	8b 40 04             	mov    0x4(%eax),%eax
  803554:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803559:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80355c:	8b 40 04             	mov    0x4(%eax),%eax
  80355f:	85 c0                	test   %eax,%eax
  803561:	74 0f                	je     803572 <insert_sorted_with_merge_freeList+0x5fc>
  803563:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803566:	8b 40 04             	mov    0x4(%eax),%eax
  803569:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80356c:	8b 12                	mov    (%edx),%edx
  80356e:	89 10                	mov    %edx,(%eax)
  803570:	eb 0a                	jmp    80357c <insert_sorted_with_merge_freeList+0x606>
  803572:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803575:	8b 00                	mov    (%eax),%eax
  803577:	a3 38 51 80 00       	mov    %eax,0x805138
  80357c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80357f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803585:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803588:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80358f:	a1 44 51 80 00       	mov    0x805144,%eax
  803594:	48                   	dec    %eax
  803595:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  80359a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80359d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8035a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035a7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8035ae:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8035b2:	75 17                	jne    8035cb <insert_sorted_with_merge_freeList+0x655>
  8035b4:	83 ec 04             	sub    $0x4,%esp
  8035b7:	68 54 43 80 00       	push   $0x804354
  8035bc:	68 6e 01 00 00       	push   $0x16e
  8035c1:	68 77 43 80 00       	push   $0x804377
  8035c6:	e8 dc ce ff ff       	call   8004a7 <_panic>
  8035cb:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8035d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035d4:	89 10                	mov    %edx,(%eax)
  8035d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035d9:	8b 00                	mov    (%eax),%eax
  8035db:	85 c0                	test   %eax,%eax
  8035dd:	74 0d                	je     8035ec <insert_sorted_with_merge_freeList+0x676>
  8035df:	a1 48 51 80 00       	mov    0x805148,%eax
  8035e4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8035e7:	89 50 04             	mov    %edx,0x4(%eax)
  8035ea:	eb 08                	jmp    8035f4 <insert_sorted_with_merge_freeList+0x67e>
  8035ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035ef:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8035f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035f7:	a3 48 51 80 00       	mov    %eax,0x805148
  8035fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035ff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803606:	a1 54 51 80 00       	mov    0x805154,%eax
  80360b:	40                   	inc    %eax
  80360c:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803611:	e9 a9 00 00 00       	jmp    8036bf <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803616:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80361a:	74 06                	je     803622 <insert_sorted_with_merge_freeList+0x6ac>
  80361c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803620:	75 17                	jne    803639 <insert_sorted_with_merge_freeList+0x6c3>
  803622:	83 ec 04             	sub    $0x4,%esp
  803625:	68 ec 43 80 00       	push   $0x8043ec
  80362a:	68 73 01 00 00       	push   $0x173
  80362f:	68 77 43 80 00       	push   $0x804377
  803634:	e8 6e ce ff ff       	call   8004a7 <_panic>
  803639:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80363c:	8b 10                	mov    (%eax),%edx
  80363e:	8b 45 08             	mov    0x8(%ebp),%eax
  803641:	89 10                	mov    %edx,(%eax)
  803643:	8b 45 08             	mov    0x8(%ebp),%eax
  803646:	8b 00                	mov    (%eax),%eax
  803648:	85 c0                	test   %eax,%eax
  80364a:	74 0b                	je     803657 <insert_sorted_with_merge_freeList+0x6e1>
  80364c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80364f:	8b 00                	mov    (%eax),%eax
  803651:	8b 55 08             	mov    0x8(%ebp),%edx
  803654:	89 50 04             	mov    %edx,0x4(%eax)
  803657:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80365a:	8b 55 08             	mov    0x8(%ebp),%edx
  80365d:	89 10                	mov    %edx,(%eax)
  80365f:	8b 45 08             	mov    0x8(%ebp),%eax
  803662:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803665:	89 50 04             	mov    %edx,0x4(%eax)
  803668:	8b 45 08             	mov    0x8(%ebp),%eax
  80366b:	8b 00                	mov    (%eax),%eax
  80366d:	85 c0                	test   %eax,%eax
  80366f:	75 08                	jne    803679 <insert_sorted_with_merge_freeList+0x703>
  803671:	8b 45 08             	mov    0x8(%ebp),%eax
  803674:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803679:	a1 44 51 80 00       	mov    0x805144,%eax
  80367e:	40                   	inc    %eax
  80367f:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803684:	eb 39                	jmp    8036bf <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803686:	a1 40 51 80 00       	mov    0x805140,%eax
  80368b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80368e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803692:	74 07                	je     80369b <insert_sorted_with_merge_freeList+0x725>
  803694:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803697:	8b 00                	mov    (%eax),%eax
  803699:	eb 05                	jmp    8036a0 <insert_sorted_with_merge_freeList+0x72a>
  80369b:	b8 00 00 00 00       	mov    $0x0,%eax
  8036a0:	a3 40 51 80 00       	mov    %eax,0x805140
  8036a5:	a1 40 51 80 00       	mov    0x805140,%eax
  8036aa:	85 c0                	test   %eax,%eax
  8036ac:	0f 85 c7 fb ff ff    	jne    803279 <insert_sorted_with_merge_freeList+0x303>
  8036b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036b6:	0f 85 bd fb ff ff    	jne    803279 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8036bc:	eb 01                	jmp    8036bf <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8036be:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8036bf:	90                   	nop
  8036c0:	c9                   	leave  
  8036c1:	c3                   	ret    

008036c2 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8036c2:	55                   	push   %ebp
  8036c3:	89 e5                	mov    %esp,%ebp
  8036c5:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8036c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8036cb:	89 d0                	mov    %edx,%eax
  8036cd:	c1 e0 02             	shl    $0x2,%eax
  8036d0:	01 d0                	add    %edx,%eax
  8036d2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8036d9:	01 d0                	add    %edx,%eax
  8036db:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8036e2:	01 d0                	add    %edx,%eax
  8036e4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8036eb:	01 d0                	add    %edx,%eax
  8036ed:	c1 e0 04             	shl    $0x4,%eax
  8036f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8036f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8036fa:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8036fd:	83 ec 0c             	sub    $0xc,%esp
  803700:	50                   	push   %eax
  803701:	e8 26 e7 ff ff       	call   801e2c <sys_get_virtual_time>
  803706:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803709:	eb 41                	jmp    80374c <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  80370b:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80370e:	83 ec 0c             	sub    $0xc,%esp
  803711:	50                   	push   %eax
  803712:	e8 15 e7 ff ff       	call   801e2c <sys_get_virtual_time>
  803717:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  80371a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80371d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803720:	29 c2                	sub    %eax,%edx
  803722:	89 d0                	mov    %edx,%eax
  803724:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803727:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80372a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80372d:	89 d1                	mov    %edx,%ecx
  80372f:	29 c1                	sub    %eax,%ecx
  803731:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803734:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803737:	39 c2                	cmp    %eax,%edx
  803739:	0f 97 c0             	seta   %al
  80373c:	0f b6 c0             	movzbl %al,%eax
  80373f:	29 c1                	sub    %eax,%ecx
  803741:	89 c8                	mov    %ecx,%eax
  803743:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803746:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803749:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  80374c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80374f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803752:	72 b7                	jb     80370b <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803754:	90                   	nop
  803755:	c9                   	leave  
  803756:	c3                   	ret    

00803757 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803757:	55                   	push   %ebp
  803758:	89 e5                	mov    %esp,%ebp
  80375a:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  80375d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803764:	eb 03                	jmp    803769 <busy_wait+0x12>
  803766:	ff 45 fc             	incl   -0x4(%ebp)
  803769:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80376c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80376f:	72 f5                	jb     803766 <busy_wait+0xf>
	return i;
  803771:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803774:	c9                   	leave  
  803775:	c3                   	ret    
  803776:	66 90                	xchg   %ax,%ax

00803778 <__udivdi3>:
  803778:	55                   	push   %ebp
  803779:	57                   	push   %edi
  80377a:	56                   	push   %esi
  80377b:	53                   	push   %ebx
  80377c:	83 ec 1c             	sub    $0x1c,%esp
  80377f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803783:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803787:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80378b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80378f:	89 ca                	mov    %ecx,%edx
  803791:	89 f8                	mov    %edi,%eax
  803793:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803797:	85 f6                	test   %esi,%esi
  803799:	75 2d                	jne    8037c8 <__udivdi3+0x50>
  80379b:	39 cf                	cmp    %ecx,%edi
  80379d:	77 65                	ja     803804 <__udivdi3+0x8c>
  80379f:	89 fd                	mov    %edi,%ebp
  8037a1:	85 ff                	test   %edi,%edi
  8037a3:	75 0b                	jne    8037b0 <__udivdi3+0x38>
  8037a5:	b8 01 00 00 00       	mov    $0x1,%eax
  8037aa:	31 d2                	xor    %edx,%edx
  8037ac:	f7 f7                	div    %edi
  8037ae:	89 c5                	mov    %eax,%ebp
  8037b0:	31 d2                	xor    %edx,%edx
  8037b2:	89 c8                	mov    %ecx,%eax
  8037b4:	f7 f5                	div    %ebp
  8037b6:	89 c1                	mov    %eax,%ecx
  8037b8:	89 d8                	mov    %ebx,%eax
  8037ba:	f7 f5                	div    %ebp
  8037bc:	89 cf                	mov    %ecx,%edi
  8037be:	89 fa                	mov    %edi,%edx
  8037c0:	83 c4 1c             	add    $0x1c,%esp
  8037c3:	5b                   	pop    %ebx
  8037c4:	5e                   	pop    %esi
  8037c5:	5f                   	pop    %edi
  8037c6:	5d                   	pop    %ebp
  8037c7:	c3                   	ret    
  8037c8:	39 ce                	cmp    %ecx,%esi
  8037ca:	77 28                	ja     8037f4 <__udivdi3+0x7c>
  8037cc:	0f bd fe             	bsr    %esi,%edi
  8037cf:	83 f7 1f             	xor    $0x1f,%edi
  8037d2:	75 40                	jne    803814 <__udivdi3+0x9c>
  8037d4:	39 ce                	cmp    %ecx,%esi
  8037d6:	72 0a                	jb     8037e2 <__udivdi3+0x6a>
  8037d8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8037dc:	0f 87 9e 00 00 00    	ja     803880 <__udivdi3+0x108>
  8037e2:	b8 01 00 00 00       	mov    $0x1,%eax
  8037e7:	89 fa                	mov    %edi,%edx
  8037e9:	83 c4 1c             	add    $0x1c,%esp
  8037ec:	5b                   	pop    %ebx
  8037ed:	5e                   	pop    %esi
  8037ee:	5f                   	pop    %edi
  8037ef:	5d                   	pop    %ebp
  8037f0:	c3                   	ret    
  8037f1:	8d 76 00             	lea    0x0(%esi),%esi
  8037f4:	31 ff                	xor    %edi,%edi
  8037f6:	31 c0                	xor    %eax,%eax
  8037f8:	89 fa                	mov    %edi,%edx
  8037fa:	83 c4 1c             	add    $0x1c,%esp
  8037fd:	5b                   	pop    %ebx
  8037fe:	5e                   	pop    %esi
  8037ff:	5f                   	pop    %edi
  803800:	5d                   	pop    %ebp
  803801:	c3                   	ret    
  803802:	66 90                	xchg   %ax,%ax
  803804:	89 d8                	mov    %ebx,%eax
  803806:	f7 f7                	div    %edi
  803808:	31 ff                	xor    %edi,%edi
  80380a:	89 fa                	mov    %edi,%edx
  80380c:	83 c4 1c             	add    $0x1c,%esp
  80380f:	5b                   	pop    %ebx
  803810:	5e                   	pop    %esi
  803811:	5f                   	pop    %edi
  803812:	5d                   	pop    %ebp
  803813:	c3                   	ret    
  803814:	bd 20 00 00 00       	mov    $0x20,%ebp
  803819:	89 eb                	mov    %ebp,%ebx
  80381b:	29 fb                	sub    %edi,%ebx
  80381d:	89 f9                	mov    %edi,%ecx
  80381f:	d3 e6                	shl    %cl,%esi
  803821:	89 c5                	mov    %eax,%ebp
  803823:	88 d9                	mov    %bl,%cl
  803825:	d3 ed                	shr    %cl,%ebp
  803827:	89 e9                	mov    %ebp,%ecx
  803829:	09 f1                	or     %esi,%ecx
  80382b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80382f:	89 f9                	mov    %edi,%ecx
  803831:	d3 e0                	shl    %cl,%eax
  803833:	89 c5                	mov    %eax,%ebp
  803835:	89 d6                	mov    %edx,%esi
  803837:	88 d9                	mov    %bl,%cl
  803839:	d3 ee                	shr    %cl,%esi
  80383b:	89 f9                	mov    %edi,%ecx
  80383d:	d3 e2                	shl    %cl,%edx
  80383f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803843:	88 d9                	mov    %bl,%cl
  803845:	d3 e8                	shr    %cl,%eax
  803847:	09 c2                	or     %eax,%edx
  803849:	89 d0                	mov    %edx,%eax
  80384b:	89 f2                	mov    %esi,%edx
  80384d:	f7 74 24 0c          	divl   0xc(%esp)
  803851:	89 d6                	mov    %edx,%esi
  803853:	89 c3                	mov    %eax,%ebx
  803855:	f7 e5                	mul    %ebp
  803857:	39 d6                	cmp    %edx,%esi
  803859:	72 19                	jb     803874 <__udivdi3+0xfc>
  80385b:	74 0b                	je     803868 <__udivdi3+0xf0>
  80385d:	89 d8                	mov    %ebx,%eax
  80385f:	31 ff                	xor    %edi,%edi
  803861:	e9 58 ff ff ff       	jmp    8037be <__udivdi3+0x46>
  803866:	66 90                	xchg   %ax,%ax
  803868:	8b 54 24 08          	mov    0x8(%esp),%edx
  80386c:	89 f9                	mov    %edi,%ecx
  80386e:	d3 e2                	shl    %cl,%edx
  803870:	39 c2                	cmp    %eax,%edx
  803872:	73 e9                	jae    80385d <__udivdi3+0xe5>
  803874:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803877:	31 ff                	xor    %edi,%edi
  803879:	e9 40 ff ff ff       	jmp    8037be <__udivdi3+0x46>
  80387e:	66 90                	xchg   %ax,%ax
  803880:	31 c0                	xor    %eax,%eax
  803882:	e9 37 ff ff ff       	jmp    8037be <__udivdi3+0x46>
  803887:	90                   	nop

00803888 <__umoddi3>:
  803888:	55                   	push   %ebp
  803889:	57                   	push   %edi
  80388a:	56                   	push   %esi
  80388b:	53                   	push   %ebx
  80388c:	83 ec 1c             	sub    $0x1c,%esp
  80388f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803893:	8b 74 24 34          	mov    0x34(%esp),%esi
  803897:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80389b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80389f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8038a3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8038a7:	89 f3                	mov    %esi,%ebx
  8038a9:	89 fa                	mov    %edi,%edx
  8038ab:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8038af:	89 34 24             	mov    %esi,(%esp)
  8038b2:	85 c0                	test   %eax,%eax
  8038b4:	75 1a                	jne    8038d0 <__umoddi3+0x48>
  8038b6:	39 f7                	cmp    %esi,%edi
  8038b8:	0f 86 a2 00 00 00    	jbe    803960 <__umoddi3+0xd8>
  8038be:	89 c8                	mov    %ecx,%eax
  8038c0:	89 f2                	mov    %esi,%edx
  8038c2:	f7 f7                	div    %edi
  8038c4:	89 d0                	mov    %edx,%eax
  8038c6:	31 d2                	xor    %edx,%edx
  8038c8:	83 c4 1c             	add    $0x1c,%esp
  8038cb:	5b                   	pop    %ebx
  8038cc:	5e                   	pop    %esi
  8038cd:	5f                   	pop    %edi
  8038ce:	5d                   	pop    %ebp
  8038cf:	c3                   	ret    
  8038d0:	39 f0                	cmp    %esi,%eax
  8038d2:	0f 87 ac 00 00 00    	ja     803984 <__umoddi3+0xfc>
  8038d8:	0f bd e8             	bsr    %eax,%ebp
  8038db:	83 f5 1f             	xor    $0x1f,%ebp
  8038de:	0f 84 ac 00 00 00    	je     803990 <__umoddi3+0x108>
  8038e4:	bf 20 00 00 00       	mov    $0x20,%edi
  8038e9:	29 ef                	sub    %ebp,%edi
  8038eb:	89 fe                	mov    %edi,%esi
  8038ed:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8038f1:	89 e9                	mov    %ebp,%ecx
  8038f3:	d3 e0                	shl    %cl,%eax
  8038f5:	89 d7                	mov    %edx,%edi
  8038f7:	89 f1                	mov    %esi,%ecx
  8038f9:	d3 ef                	shr    %cl,%edi
  8038fb:	09 c7                	or     %eax,%edi
  8038fd:	89 e9                	mov    %ebp,%ecx
  8038ff:	d3 e2                	shl    %cl,%edx
  803901:	89 14 24             	mov    %edx,(%esp)
  803904:	89 d8                	mov    %ebx,%eax
  803906:	d3 e0                	shl    %cl,%eax
  803908:	89 c2                	mov    %eax,%edx
  80390a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80390e:	d3 e0                	shl    %cl,%eax
  803910:	89 44 24 04          	mov    %eax,0x4(%esp)
  803914:	8b 44 24 08          	mov    0x8(%esp),%eax
  803918:	89 f1                	mov    %esi,%ecx
  80391a:	d3 e8                	shr    %cl,%eax
  80391c:	09 d0                	or     %edx,%eax
  80391e:	d3 eb                	shr    %cl,%ebx
  803920:	89 da                	mov    %ebx,%edx
  803922:	f7 f7                	div    %edi
  803924:	89 d3                	mov    %edx,%ebx
  803926:	f7 24 24             	mull   (%esp)
  803929:	89 c6                	mov    %eax,%esi
  80392b:	89 d1                	mov    %edx,%ecx
  80392d:	39 d3                	cmp    %edx,%ebx
  80392f:	0f 82 87 00 00 00    	jb     8039bc <__umoddi3+0x134>
  803935:	0f 84 91 00 00 00    	je     8039cc <__umoddi3+0x144>
  80393b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80393f:	29 f2                	sub    %esi,%edx
  803941:	19 cb                	sbb    %ecx,%ebx
  803943:	89 d8                	mov    %ebx,%eax
  803945:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803949:	d3 e0                	shl    %cl,%eax
  80394b:	89 e9                	mov    %ebp,%ecx
  80394d:	d3 ea                	shr    %cl,%edx
  80394f:	09 d0                	or     %edx,%eax
  803951:	89 e9                	mov    %ebp,%ecx
  803953:	d3 eb                	shr    %cl,%ebx
  803955:	89 da                	mov    %ebx,%edx
  803957:	83 c4 1c             	add    $0x1c,%esp
  80395a:	5b                   	pop    %ebx
  80395b:	5e                   	pop    %esi
  80395c:	5f                   	pop    %edi
  80395d:	5d                   	pop    %ebp
  80395e:	c3                   	ret    
  80395f:	90                   	nop
  803960:	89 fd                	mov    %edi,%ebp
  803962:	85 ff                	test   %edi,%edi
  803964:	75 0b                	jne    803971 <__umoddi3+0xe9>
  803966:	b8 01 00 00 00       	mov    $0x1,%eax
  80396b:	31 d2                	xor    %edx,%edx
  80396d:	f7 f7                	div    %edi
  80396f:	89 c5                	mov    %eax,%ebp
  803971:	89 f0                	mov    %esi,%eax
  803973:	31 d2                	xor    %edx,%edx
  803975:	f7 f5                	div    %ebp
  803977:	89 c8                	mov    %ecx,%eax
  803979:	f7 f5                	div    %ebp
  80397b:	89 d0                	mov    %edx,%eax
  80397d:	e9 44 ff ff ff       	jmp    8038c6 <__umoddi3+0x3e>
  803982:	66 90                	xchg   %ax,%ax
  803984:	89 c8                	mov    %ecx,%eax
  803986:	89 f2                	mov    %esi,%edx
  803988:	83 c4 1c             	add    $0x1c,%esp
  80398b:	5b                   	pop    %ebx
  80398c:	5e                   	pop    %esi
  80398d:	5f                   	pop    %edi
  80398e:	5d                   	pop    %ebp
  80398f:	c3                   	ret    
  803990:	3b 04 24             	cmp    (%esp),%eax
  803993:	72 06                	jb     80399b <__umoddi3+0x113>
  803995:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803999:	77 0f                	ja     8039aa <__umoddi3+0x122>
  80399b:	89 f2                	mov    %esi,%edx
  80399d:	29 f9                	sub    %edi,%ecx
  80399f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8039a3:	89 14 24             	mov    %edx,(%esp)
  8039a6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8039aa:	8b 44 24 04          	mov    0x4(%esp),%eax
  8039ae:	8b 14 24             	mov    (%esp),%edx
  8039b1:	83 c4 1c             	add    $0x1c,%esp
  8039b4:	5b                   	pop    %ebx
  8039b5:	5e                   	pop    %esi
  8039b6:	5f                   	pop    %edi
  8039b7:	5d                   	pop    %ebp
  8039b8:	c3                   	ret    
  8039b9:	8d 76 00             	lea    0x0(%esi),%esi
  8039bc:	2b 04 24             	sub    (%esp),%eax
  8039bf:	19 fa                	sbb    %edi,%edx
  8039c1:	89 d1                	mov    %edx,%ecx
  8039c3:	89 c6                	mov    %eax,%esi
  8039c5:	e9 71 ff ff ff       	jmp    80393b <__umoddi3+0xb3>
  8039ca:	66 90                	xchg   %ax,%ax
  8039cc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8039d0:	72 ea                	jb     8039bc <__umoddi3+0x134>
  8039d2:	89 d9                	mov    %ebx,%ecx
  8039d4:	e9 62 ff ff ff       	jmp    80393b <__umoddi3+0xb3>
