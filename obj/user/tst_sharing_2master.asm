
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
  80008d:	68 e0 37 80 00       	push   $0x8037e0
  800092:	6a 13                	push   $0x13
  800094:	68 fc 37 80 00       	push   $0x8037fc
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
  8000ab:	e8 53 18 00 00       	call   801903 <sys_calculate_free_frames>
  8000b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	x = smalloc("x", 4, 0);
  8000b3:	83 ec 04             	sub    $0x4,%esp
  8000b6:	6a 00                	push   $0x0
  8000b8:	6a 04                	push   $0x4
  8000ba:	68 17 38 80 00       	push   $0x803817
  8000bf:	e8 67 16 00 00       	call   80172b <smalloc>
  8000c4:	83 c4 10             	add    $0x10,%esp
  8000c7:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if (x != (uint32*)USER_HEAP_START) panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8000ca:	81 7d e8 00 00 00 80 	cmpl   $0x80000000,-0x18(%ebp)
  8000d1:	74 14                	je     8000e7 <_main+0xaf>
  8000d3:	83 ec 04             	sub    $0x4,%esp
  8000d6:	68 1c 38 80 00       	push   $0x80381c
  8000db:	6a 1e                	push   $0x1e
  8000dd:	68 fc 37 80 00       	push   $0x8037fc
  8000e2:	e8 c0 03 00 00       	call   8004a7 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Create(): Wrong allocation- make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8000e7:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000ea:	e8 14 18 00 00       	call   801903 <sys_calculate_free_frames>
  8000ef:	29 c3                	sub    %eax,%ebx
  8000f1:	89 d8                	mov    %ebx,%eax
  8000f3:	83 f8 04             	cmp    $0x4,%eax
  8000f6:	74 14                	je     80010c <_main+0xd4>
  8000f8:	83 ec 04             	sub    $0x4,%esp
  8000fb:	68 80 38 80 00       	push   $0x803880
  800100:	6a 1f                	push   $0x1f
  800102:	68 fc 37 80 00       	push   $0x8037fc
  800107:	e8 9b 03 00 00       	call   8004a7 <_panic>

	//y: Readonly
	freeFrames = sys_calculate_free_frames() ;
  80010c:	e8 f2 17 00 00       	call   801903 <sys_calculate_free_frames>
  800111:	89 45 ec             	mov    %eax,-0x14(%ebp)
	y = smalloc("y", 4, 0);
  800114:	83 ec 04             	sub    $0x4,%esp
  800117:	6a 00                	push   $0x0
  800119:	6a 04                	push   $0x4
  80011b:	68 08 39 80 00       	push   $0x803908
  800120:	e8 06 16 00 00       	call   80172b <smalloc>
  800125:	83 c4 10             	add    $0x10,%esp
  800128:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (y != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  80012b:	81 7d e4 00 10 00 80 	cmpl   $0x80001000,-0x1c(%ebp)
  800132:	74 14                	je     800148 <_main+0x110>
  800134:	83 ec 04             	sub    $0x4,%esp
  800137:	68 1c 38 80 00       	push   $0x80381c
  80013c:	6a 24                	push   $0x24
  80013e:	68 fc 37 80 00       	push   $0x8037fc
  800143:	e8 5f 03 00 00       	call   8004a7 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1+0+2) panic("Create(): Wrong allocation- make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800148:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  80014b:	e8 b3 17 00 00       	call   801903 <sys_calculate_free_frames>
  800150:	29 c3                	sub    %eax,%ebx
  800152:	89 d8                	mov    %ebx,%eax
  800154:	83 f8 03             	cmp    $0x3,%eax
  800157:	74 14                	je     80016d <_main+0x135>
  800159:	83 ec 04             	sub    $0x4,%esp
  80015c:	68 80 38 80 00       	push   $0x803880
  800161:	6a 25                	push   $0x25
  800163:	68 fc 37 80 00       	push   $0x8037fc
  800168:	e8 3a 03 00 00       	call   8004a7 <_panic>

	//z: Writable
	freeFrames = sys_calculate_free_frames() ;
  80016d:	e8 91 17 00 00       	call   801903 <sys_calculate_free_frames>
  800172:	89 45 ec             	mov    %eax,-0x14(%ebp)
	z = smalloc("z", 4, 1);
  800175:	83 ec 04             	sub    $0x4,%esp
  800178:	6a 01                	push   $0x1
  80017a:	6a 04                	push   $0x4
  80017c:	68 0a 39 80 00       	push   $0x80390a
  800181:	e8 a5 15 00 00       	call   80172b <smalloc>
  800186:	83 c4 10             	add    $0x10,%esp
  800189:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (z != (uint32*)(USER_HEAP_START + 2 * PAGE_SIZE)) panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  80018c:	81 7d e0 00 20 00 80 	cmpl   $0x80002000,-0x20(%ebp)
  800193:	74 14                	je     8001a9 <_main+0x171>
  800195:	83 ec 04             	sub    $0x4,%esp
  800198:	68 1c 38 80 00       	push   $0x80381c
  80019d:	6a 2a                	push   $0x2a
  80019f:	68 fc 37 80 00       	push   $0x8037fc
  8001a4:	e8 fe 02 00 00       	call   8004a7 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1+0+2) panic("Create(): Wrong allocation- make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8001a9:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8001ac:	e8 52 17 00 00       	call   801903 <sys_calculate_free_frames>
  8001b1:	29 c3                	sub    %eax,%ebx
  8001b3:	89 d8                	mov    %ebx,%eax
  8001b5:	83 f8 03             	cmp    $0x3,%eax
  8001b8:	74 14                	je     8001ce <_main+0x196>
  8001ba:	83 ec 04             	sub    $0x4,%esp
  8001bd:	68 80 38 80 00       	push   $0x803880
  8001c2:	6a 2b                	push   $0x2b
  8001c4:	68 fc 37 80 00       	push   $0x8037fc
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
  800203:	68 0c 39 80 00       	push   $0x80390c
  800208:	e8 68 19 00 00       	call   801b75 <sys_create_env>
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
  800236:	68 0c 39 80 00       	push   $0x80390c
  80023b:	e8 35 19 00 00       	call   801b75 <sys_create_env>
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
  800269:	68 0c 39 80 00       	push   $0x80390c
  80026e:	e8 02 19 00 00       	call   801b75 <sys_create_env>
  800273:	83 c4 10             	add    $0x10,%esp
  800276:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	//to check that the slave environments completed successfully
	rsttst();
  800279:	e8 43 1a 00 00       	call   801cc1 <rsttst>

	sys_run_env(id1);
  80027e:	83 ec 0c             	sub    $0xc,%esp
  800281:	ff 75 dc             	pushl  -0x24(%ebp)
  800284:	e8 0a 19 00 00       	call   801b93 <sys_run_env>
  800289:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id2);
  80028c:	83 ec 0c             	sub    $0xc,%esp
  80028f:	ff 75 d8             	pushl  -0x28(%ebp)
  800292:	e8 fc 18 00 00       	call   801b93 <sys_run_env>
  800297:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id3);
  80029a:	83 ec 0c             	sub    $0xc,%esp
  80029d:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002a0:	e8 ee 18 00 00       	call   801b93 <sys_run_env>
  8002a5:	83 c4 10             	add    $0x10,%esp

	env_sleep(12000) ;
  8002a8:	83 ec 0c             	sub    $0xc,%esp
  8002ab:	68 e0 2e 00 00       	push   $0x2ee0
  8002b0:	e8 10 32 00 00       	call   8034c5 <env_sleep>
  8002b5:	83 c4 10             	add    $0x10,%esp

	//to ensure that the slave environments completed successfully
	if (gettst()!=3) panic("test failed");
  8002b8:	e8 7e 1a 00 00       	call   801d3b <gettst>
  8002bd:	83 f8 03             	cmp    $0x3,%eax
  8002c0:	74 14                	je     8002d6 <_main+0x29e>
  8002c2:	83 ec 04             	sub    $0x4,%esp
  8002c5:	68 17 39 80 00       	push   $0x803917
  8002ca:	6a 3f                	push   $0x3f
  8002cc:	68 fc 37 80 00       	push   $0x8037fc
  8002d1:	e8 d1 01 00 00       	call   8004a7 <_panic>


	if (*z != 30)
  8002d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002d9:	8b 00                	mov    (%eax),%eax
  8002db:	83 f8 1e             	cmp    $0x1e,%eax
  8002de:	74 14                	je     8002f4 <_main+0x2bc>
		panic("Error!! Please check the creation (or the getting) of shared variables!!\n\n\n");
  8002e0:	83 ec 04             	sub    $0x4,%esp
  8002e3:	68 24 39 80 00       	push   $0x803924
  8002e8:	6a 43                	push   $0x43
  8002ea:	68 fc 37 80 00       	push   $0x8037fc
  8002ef:	e8 b3 01 00 00       	call   8004a7 <_panic>
	else
		cprintf("Congratulations!! Test of Shared Variables [Create & Get] [2] completed successfully!!\n\n\n");
  8002f4:	83 ec 0c             	sub    $0xc,%esp
  8002f7:	68 70 39 80 00       	push   $0x803970
  8002fc:	e8 5a 04 00 00       	call   80075b <cprintf>
  800301:	83 c4 10             	add    $0x10,%esp

	cprintf("Now, ILLEGAL MEM ACCESS should be occur, due to attempting to write a ReadOnly variable\n\n\n");
  800304:	83 ec 0c             	sub    $0xc,%esp
  800307:	68 cc 39 80 00       	push   $0x8039cc
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
  800337:	68 27 3a 80 00       	push   $0x803a27
  80033c:	e8 34 18 00 00       	call   801b75 <sys_create_env>
  800341:	83 c4 10             	add    $0x10,%esp
  800344:	89 45 dc             	mov    %eax,-0x24(%ebp)

	env_sleep(3000) ;
  800347:	83 ec 0c             	sub    $0xc,%esp
  80034a:	68 b8 0b 00 00       	push   $0xbb8
  80034f:	e8 71 31 00 00       	call   8034c5 <env_sleep>
  800354:	83 c4 10             	add    $0x10,%esp

	sys_run_env(id1);
  800357:	83 ec 0c             	sub    $0xc,%esp
  80035a:	ff 75 dc             	pushl  -0x24(%ebp)
  80035d:	e8 31 18 00 00       	call   801b93 <sys_run_env>
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
  800371:	e8 6d 18 00 00       	call   801be3 <sys_getenvindex>
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
  8003dc:	e8 0f 16 00 00       	call   8019f0 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8003e1:	83 ec 0c             	sub    $0xc,%esp
  8003e4:	68 4c 3a 80 00       	push   $0x803a4c
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
  80040c:	68 74 3a 80 00       	push   $0x803a74
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
  80043d:	68 9c 3a 80 00       	push   $0x803a9c
  800442:	e8 14 03 00 00       	call   80075b <cprintf>
  800447:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80044a:	a1 20 50 80 00       	mov    0x805020,%eax
  80044f:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800455:	83 ec 08             	sub    $0x8,%esp
  800458:	50                   	push   %eax
  800459:	68 f4 3a 80 00       	push   $0x803af4
  80045e:	e8 f8 02 00 00       	call   80075b <cprintf>
  800463:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800466:	83 ec 0c             	sub    $0xc,%esp
  800469:	68 4c 3a 80 00       	push   $0x803a4c
  80046e:	e8 e8 02 00 00       	call   80075b <cprintf>
  800473:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800476:	e8 8f 15 00 00       	call   801a0a <sys_enable_interrupt>

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
  80048e:	e8 1c 17 00 00       	call   801baf <sys_destroy_env>
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
  80049f:	e8 71 17 00 00       	call   801c15 <sys_exit_env>
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
  8004c8:	68 08 3b 80 00       	push   $0x803b08
  8004cd:	e8 89 02 00 00       	call   80075b <cprintf>
  8004d2:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8004d5:	a1 00 50 80 00       	mov    0x805000,%eax
  8004da:	ff 75 0c             	pushl  0xc(%ebp)
  8004dd:	ff 75 08             	pushl  0x8(%ebp)
  8004e0:	50                   	push   %eax
  8004e1:	68 0d 3b 80 00       	push   $0x803b0d
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
  800505:	68 29 3b 80 00       	push   $0x803b29
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
  800531:	68 2c 3b 80 00       	push   $0x803b2c
  800536:	6a 26                	push   $0x26
  800538:	68 78 3b 80 00       	push   $0x803b78
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
  800603:	68 84 3b 80 00       	push   $0x803b84
  800608:	6a 3a                	push   $0x3a
  80060a:	68 78 3b 80 00       	push   $0x803b78
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
  800673:	68 d8 3b 80 00       	push   $0x803bd8
  800678:	6a 44                	push   $0x44
  80067a:	68 78 3b 80 00       	push   $0x803b78
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
  8006cd:	e8 70 11 00 00       	call   801842 <sys_cputs>
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
  800744:	e8 f9 10 00 00       	call   801842 <sys_cputs>
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
  80078e:	e8 5d 12 00 00       	call   8019f0 <sys_disable_interrupt>
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
  8007ae:	e8 57 12 00 00       	call   801a0a <sys_enable_interrupt>
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
  8007f8:	e8 7f 2d 00 00       	call   80357c <__udivdi3>
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
  800848:	e8 3f 2e 00 00       	call   80368c <__umoddi3>
  80084d:	83 c4 10             	add    $0x10,%esp
  800850:	05 54 3e 80 00       	add    $0x803e54,%eax
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
  8009a3:	8b 04 85 78 3e 80 00 	mov    0x803e78(,%eax,4),%eax
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
  800a84:	8b 34 9d c0 3c 80 00 	mov    0x803cc0(,%ebx,4),%esi
  800a8b:	85 f6                	test   %esi,%esi
  800a8d:	75 19                	jne    800aa8 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a8f:	53                   	push   %ebx
  800a90:	68 65 3e 80 00       	push   $0x803e65
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
  800aa9:	68 6e 3e 80 00       	push   $0x803e6e
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
  800ad6:	be 71 3e 80 00       	mov    $0x803e71,%esi
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
  8014fc:	68 d0 3f 80 00       	push   $0x803fd0
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
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_PRESENT);
  8015af:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  8015b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015b9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015be:	2d 00 10 00 00       	sub    $0x1000,%eax
  8015c3:	83 ec 04             	sub    $0x4,%esp
  8015c6:	6a 03                	push   $0x3
  8015c8:	ff 75 f4             	pushl  -0xc(%ebp)
  8015cb:	50                   	push   %eax
  8015cc:	e8 b5 03 00 00       	call   801986 <sys_allocate_chunk>
  8015d1:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8015d4:	a1 20 51 80 00       	mov    0x805120,%eax
  8015d9:	83 ec 0c             	sub    $0xc,%esp
  8015dc:	50                   	push   %eax
  8015dd:	e8 2a 0a 00 00       	call   80200c <initialize_MemBlocksList>
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
  80160a:	68 f5 3f 80 00       	push   $0x803ff5
  80160f:	6a 33                	push   $0x33
  801611:	68 13 40 80 00       	push   $0x804013
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
  801689:	68 20 40 80 00       	push   $0x804020
  80168e:	6a 34                	push   $0x34
  801690:	68 13 40 80 00       	push   $0x804013
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
  8016fe:	68 44 40 80 00       	push   $0x804044
  801703:	6a 46                	push   $0x46
  801705:	68 13 40 80 00       	push   $0x804013
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
  80171a:	68 6c 40 80 00       	push   $0x80406c
  80171f:	6a 61                	push   $0x61
  801721:	68 13 40 80 00       	push   $0x804013
  801726:	e8 7c ed ff ff       	call   8004a7 <_panic>

0080172b <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80172b:	55                   	push   %ebp
  80172c:	89 e5                	mov    %esp,%ebp
  80172e:	83 ec 18             	sub    $0x18,%esp
  801731:	8b 45 10             	mov    0x10(%ebp),%eax
  801734:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801737:	e8 a9 fd ff ff       	call   8014e5 <InitializeUHeap>
	if (size == 0) return NULL ;
  80173c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801740:	75 07                	jne    801749 <smalloc+0x1e>
  801742:	b8 00 00 00 00       	mov    $0x0,%eax
  801747:	eb 14                	jmp    80175d <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801749:	83 ec 04             	sub    $0x4,%esp
  80174c:	68 90 40 80 00       	push   $0x804090
  801751:	6a 76                	push   $0x76
  801753:	68 13 40 80 00       	push   $0x804013
  801758:	e8 4a ed ff ff       	call   8004a7 <_panic>

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80175d:	c9                   	leave  
  80175e:	c3                   	ret    

0080175f <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80175f:	55                   	push   %ebp
  801760:	89 e5                	mov    %esp,%ebp
  801762:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801765:	e8 7b fd ff ff       	call   8014e5 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  80176a:	83 ec 04             	sub    $0x4,%esp
  80176d:	68 b8 40 80 00       	push   $0x8040b8
  801772:	68 93 00 00 00       	push   $0x93
  801777:	68 13 40 80 00       	push   $0x804013
  80177c:	e8 26 ed ff ff       	call   8004a7 <_panic>

00801781 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801781:	55                   	push   %ebp
  801782:	89 e5                	mov    %esp,%ebp
  801784:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801787:	e8 59 fd ff ff       	call   8014e5 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80178c:	83 ec 04             	sub    $0x4,%esp
  80178f:	68 dc 40 80 00       	push   $0x8040dc
  801794:	68 c5 00 00 00       	push   $0xc5
  801799:	68 13 40 80 00       	push   $0x804013
  80179e:	e8 04 ed ff ff       	call   8004a7 <_panic>

008017a3 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8017a3:	55                   	push   %ebp
  8017a4:	89 e5                	mov    %esp,%ebp
  8017a6:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8017a9:	83 ec 04             	sub    $0x4,%esp
  8017ac:	68 04 41 80 00       	push   $0x804104
  8017b1:	68 d9 00 00 00       	push   $0xd9
  8017b6:	68 13 40 80 00       	push   $0x804013
  8017bb:	e8 e7 ec ff ff       	call   8004a7 <_panic>

008017c0 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8017c0:	55                   	push   %ebp
  8017c1:	89 e5                	mov    %esp,%ebp
  8017c3:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017c6:	83 ec 04             	sub    $0x4,%esp
  8017c9:	68 28 41 80 00       	push   $0x804128
  8017ce:	68 e4 00 00 00       	push   $0xe4
  8017d3:	68 13 40 80 00       	push   $0x804013
  8017d8:	e8 ca ec ff ff       	call   8004a7 <_panic>

008017dd <shrink>:

}
void shrink(uint32 newSize)
{
  8017dd:	55                   	push   %ebp
  8017de:	89 e5                	mov    %esp,%ebp
  8017e0:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017e3:	83 ec 04             	sub    $0x4,%esp
  8017e6:	68 28 41 80 00       	push   $0x804128
  8017eb:	68 e9 00 00 00       	push   $0xe9
  8017f0:	68 13 40 80 00       	push   $0x804013
  8017f5:	e8 ad ec ff ff       	call   8004a7 <_panic>

008017fa <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8017fa:	55                   	push   %ebp
  8017fb:	89 e5                	mov    %esp,%ebp
  8017fd:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801800:	83 ec 04             	sub    $0x4,%esp
  801803:	68 28 41 80 00       	push   $0x804128
  801808:	68 ee 00 00 00       	push   $0xee
  80180d:	68 13 40 80 00       	push   $0x804013
  801812:	e8 90 ec ff ff       	call   8004a7 <_panic>

00801817 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801817:	55                   	push   %ebp
  801818:	89 e5                	mov    %esp,%ebp
  80181a:	57                   	push   %edi
  80181b:	56                   	push   %esi
  80181c:	53                   	push   %ebx
  80181d:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801820:	8b 45 08             	mov    0x8(%ebp),%eax
  801823:	8b 55 0c             	mov    0xc(%ebp),%edx
  801826:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801829:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80182c:	8b 7d 18             	mov    0x18(%ebp),%edi
  80182f:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801832:	cd 30                	int    $0x30
  801834:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801837:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80183a:	83 c4 10             	add    $0x10,%esp
  80183d:	5b                   	pop    %ebx
  80183e:	5e                   	pop    %esi
  80183f:	5f                   	pop    %edi
  801840:	5d                   	pop    %ebp
  801841:	c3                   	ret    

00801842 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801842:	55                   	push   %ebp
  801843:	89 e5                	mov    %esp,%ebp
  801845:	83 ec 04             	sub    $0x4,%esp
  801848:	8b 45 10             	mov    0x10(%ebp),%eax
  80184b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80184e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801852:	8b 45 08             	mov    0x8(%ebp),%eax
  801855:	6a 00                	push   $0x0
  801857:	6a 00                	push   $0x0
  801859:	52                   	push   %edx
  80185a:	ff 75 0c             	pushl  0xc(%ebp)
  80185d:	50                   	push   %eax
  80185e:	6a 00                	push   $0x0
  801860:	e8 b2 ff ff ff       	call   801817 <syscall>
  801865:	83 c4 18             	add    $0x18,%esp
}
  801868:	90                   	nop
  801869:	c9                   	leave  
  80186a:	c3                   	ret    

0080186b <sys_cgetc>:

int
sys_cgetc(void)
{
  80186b:	55                   	push   %ebp
  80186c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80186e:	6a 00                	push   $0x0
  801870:	6a 00                	push   $0x0
  801872:	6a 00                	push   $0x0
  801874:	6a 00                	push   $0x0
  801876:	6a 00                	push   $0x0
  801878:	6a 01                	push   $0x1
  80187a:	e8 98 ff ff ff       	call   801817 <syscall>
  80187f:	83 c4 18             	add    $0x18,%esp
}
  801882:	c9                   	leave  
  801883:	c3                   	ret    

00801884 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801884:	55                   	push   %ebp
  801885:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801887:	8b 55 0c             	mov    0xc(%ebp),%edx
  80188a:	8b 45 08             	mov    0x8(%ebp),%eax
  80188d:	6a 00                	push   $0x0
  80188f:	6a 00                	push   $0x0
  801891:	6a 00                	push   $0x0
  801893:	52                   	push   %edx
  801894:	50                   	push   %eax
  801895:	6a 05                	push   $0x5
  801897:	e8 7b ff ff ff       	call   801817 <syscall>
  80189c:	83 c4 18             	add    $0x18,%esp
}
  80189f:	c9                   	leave  
  8018a0:	c3                   	ret    

008018a1 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8018a1:	55                   	push   %ebp
  8018a2:	89 e5                	mov    %esp,%ebp
  8018a4:	56                   	push   %esi
  8018a5:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8018a6:	8b 75 18             	mov    0x18(%ebp),%esi
  8018a9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018ac:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b5:	56                   	push   %esi
  8018b6:	53                   	push   %ebx
  8018b7:	51                   	push   %ecx
  8018b8:	52                   	push   %edx
  8018b9:	50                   	push   %eax
  8018ba:	6a 06                	push   $0x6
  8018bc:	e8 56 ff ff ff       	call   801817 <syscall>
  8018c1:	83 c4 18             	add    $0x18,%esp
}
  8018c4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018c7:	5b                   	pop    %ebx
  8018c8:	5e                   	pop    %esi
  8018c9:	5d                   	pop    %ebp
  8018ca:	c3                   	ret    

008018cb <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8018cb:	55                   	push   %ebp
  8018cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8018ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d4:	6a 00                	push   $0x0
  8018d6:	6a 00                	push   $0x0
  8018d8:	6a 00                	push   $0x0
  8018da:	52                   	push   %edx
  8018db:	50                   	push   %eax
  8018dc:	6a 07                	push   $0x7
  8018de:	e8 34 ff ff ff       	call   801817 <syscall>
  8018e3:	83 c4 18             	add    $0x18,%esp
}
  8018e6:	c9                   	leave  
  8018e7:	c3                   	ret    

008018e8 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8018e8:	55                   	push   %ebp
  8018e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8018eb:	6a 00                	push   $0x0
  8018ed:	6a 00                	push   $0x0
  8018ef:	6a 00                	push   $0x0
  8018f1:	ff 75 0c             	pushl  0xc(%ebp)
  8018f4:	ff 75 08             	pushl  0x8(%ebp)
  8018f7:	6a 08                	push   $0x8
  8018f9:	e8 19 ff ff ff       	call   801817 <syscall>
  8018fe:	83 c4 18             	add    $0x18,%esp
}
  801901:	c9                   	leave  
  801902:	c3                   	ret    

00801903 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801903:	55                   	push   %ebp
  801904:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801906:	6a 00                	push   $0x0
  801908:	6a 00                	push   $0x0
  80190a:	6a 00                	push   $0x0
  80190c:	6a 00                	push   $0x0
  80190e:	6a 00                	push   $0x0
  801910:	6a 09                	push   $0x9
  801912:	e8 00 ff ff ff       	call   801817 <syscall>
  801917:	83 c4 18             	add    $0x18,%esp
}
  80191a:	c9                   	leave  
  80191b:	c3                   	ret    

0080191c <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80191c:	55                   	push   %ebp
  80191d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80191f:	6a 00                	push   $0x0
  801921:	6a 00                	push   $0x0
  801923:	6a 00                	push   $0x0
  801925:	6a 00                	push   $0x0
  801927:	6a 00                	push   $0x0
  801929:	6a 0a                	push   $0xa
  80192b:	e8 e7 fe ff ff       	call   801817 <syscall>
  801930:	83 c4 18             	add    $0x18,%esp
}
  801933:	c9                   	leave  
  801934:	c3                   	ret    

00801935 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801935:	55                   	push   %ebp
  801936:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801938:	6a 00                	push   $0x0
  80193a:	6a 00                	push   $0x0
  80193c:	6a 00                	push   $0x0
  80193e:	6a 00                	push   $0x0
  801940:	6a 00                	push   $0x0
  801942:	6a 0b                	push   $0xb
  801944:	e8 ce fe ff ff       	call   801817 <syscall>
  801949:	83 c4 18             	add    $0x18,%esp
}
  80194c:	c9                   	leave  
  80194d:	c3                   	ret    

0080194e <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80194e:	55                   	push   %ebp
  80194f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801951:	6a 00                	push   $0x0
  801953:	6a 00                	push   $0x0
  801955:	6a 00                	push   $0x0
  801957:	ff 75 0c             	pushl  0xc(%ebp)
  80195a:	ff 75 08             	pushl  0x8(%ebp)
  80195d:	6a 0f                	push   $0xf
  80195f:	e8 b3 fe ff ff       	call   801817 <syscall>
  801964:	83 c4 18             	add    $0x18,%esp
	return;
  801967:	90                   	nop
}
  801968:	c9                   	leave  
  801969:	c3                   	ret    

0080196a <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80196a:	55                   	push   %ebp
  80196b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80196d:	6a 00                	push   $0x0
  80196f:	6a 00                	push   $0x0
  801971:	6a 00                	push   $0x0
  801973:	ff 75 0c             	pushl  0xc(%ebp)
  801976:	ff 75 08             	pushl  0x8(%ebp)
  801979:	6a 10                	push   $0x10
  80197b:	e8 97 fe ff ff       	call   801817 <syscall>
  801980:	83 c4 18             	add    $0x18,%esp
	return ;
  801983:	90                   	nop
}
  801984:	c9                   	leave  
  801985:	c3                   	ret    

00801986 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801986:	55                   	push   %ebp
  801987:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801989:	6a 00                	push   $0x0
  80198b:	6a 00                	push   $0x0
  80198d:	ff 75 10             	pushl  0x10(%ebp)
  801990:	ff 75 0c             	pushl  0xc(%ebp)
  801993:	ff 75 08             	pushl  0x8(%ebp)
  801996:	6a 11                	push   $0x11
  801998:	e8 7a fe ff ff       	call   801817 <syscall>
  80199d:	83 c4 18             	add    $0x18,%esp
	return ;
  8019a0:	90                   	nop
}
  8019a1:	c9                   	leave  
  8019a2:	c3                   	ret    

008019a3 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8019a3:	55                   	push   %ebp
  8019a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8019a6:	6a 00                	push   $0x0
  8019a8:	6a 00                	push   $0x0
  8019aa:	6a 00                	push   $0x0
  8019ac:	6a 00                	push   $0x0
  8019ae:	6a 00                	push   $0x0
  8019b0:	6a 0c                	push   $0xc
  8019b2:	e8 60 fe ff ff       	call   801817 <syscall>
  8019b7:	83 c4 18             	add    $0x18,%esp
}
  8019ba:	c9                   	leave  
  8019bb:	c3                   	ret    

008019bc <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8019bc:	55                   	push   %ebp
  8019bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 00                	push   $0x0
  8019c5:	6a 00                	push   $0x0
  8019c7:	ff 75 08             	pushl  0x8(%ebp)
  8019ca:	6a 0d                	push   $0xd
  8019cc:	e8 46 fe ff ff       	call   801817 <syscall>
  8019d1:	83 c4 18             	add    $0x18,%esp
}
  8019d4:	c9                   	leave  
  8019d5:	c3                   	ret    

008019d6 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8019d6:	55                   	push   %ebp
  8019d7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8019d9:	6a 00                	push   $0x0
  8019db:	6a 00                	push   $0x0
  8019dd:	6a 00                	push   $0x0
  8019df:	6a 00                	push   $0x0
  8019e1:	6a 00                	push   $0x0
  8019e3:	6a 0e                	push   $0xe
  8019e5:	e8 2d fe ff ff       	call   801817 <syscall>
  8019ea:	83 c4 18             	add    $0x18,%esp
}
  8019ed:	90                   	nop
  8019ee:	c9                   	leave  
  8019ef:	c3                   	ret    

008019f0 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8019f0:	55                   	push   %ebp
  8019f1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8019f3:	6a 00                	push   $0x0
  8019f5:	6a 00                	push   $0x0
  8019f7:	6a 00                	push   $0x0
  8019f9:	6a 00                	push   $0x0
  8019fb:	6a 00                	push   $0x0
  8019fd:	6a 13                	push   $0x13
  8019ff:	e8 13 fe ff ff       	call   801817 <syscall>
  801a04:	83 c4 18             	add    $0x18,%esp
}
  801a07:	90                   	nop
  801a08:	c9                   	leave  
  801a09:	c3                   	ret    

00801a0a <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801a0a:	55                   	push   %ebp
  801a0b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801a0d:	6a 00                	push   $0x0
  801a0f:	6a 00                	push   $0x0
  801a11:	6a 00                	push   $0x0
  801a13:	6a 00                	push   $0x0
  801a15:	6a 00                	push   $0x0
  801a17:	6a 14                	push   $0x14
  801a19:	e8 f9 fd ff ff       	call   801817 <syscall>
  801a1e:	83 c4 18             	add    $0x18,%esp
}
  801a21:	90                   	nop
  801a22:	c9                   	leave  
  801a23:	c3                   	ret    

00801a24 <sys_cputc>:


void
sys_cputc(const char c)
{
  801a24:	55                   	push   %ebp
  801a25:	89 e5                	mov    %esp,%ebp
  801a27:	83 ec 04             	sub    $0x4,%esp
  801a2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a30:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a34:	6a 00                	push   $0x0
  801a36:	6a 00                	push   $0x0
  801a38:	6a 00                	push   $0x0
  801a3a:	6a 00                	push   $0x0
  801a3c:	50                   	push   %eax
  801a3d:	6a 15                	push   $0x15
  801a3f:	e8 d3 fd ff ff       	call   801817 <syscall>
  801a44:	83 c4 18             	add    $0x18,%esp
}
  801a47:	90                   	nop
  801a48:	c9                   	leave  
  801a49:	c3                   	ret    

00801a4a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a4a:	55                   	push   %ebp
  801a4b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a4d:	6a 00                	push   $0x0
  801a4f:	6a 00                	push   $0x0
  801a51:	6a 00                	push   $0x0
  801a53:	6a 00                	push   $0x0
  801a55:	6a 00                	push   $0x0
  801a57:	6a 16                	push   $0x16
  801a59:	e8 b9 fd ff ff       	call   801817 <syscall>
  801a5e:	83 c4 18             	add    $0x18,%esp
}
  801a61:	90                   	nop
  801a62:	c9                   	leave  
  801a63:	c3                   	ret    

00801a64 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a64:	55                   	push   %ebp
  801a65:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a67:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 00                	push   $0x0
  801a70:	ff 75 0c             	pushl  0xc(%ebp)
  801a73:	50                   	push   %eax
  801a74:	6a 17                	push   $0x17
  801a76:	e8 9c fd ff ff       	call   801817 <syscall>
  801a7b:	83 c4 18             	add    $0x18,%esp
}
  801a7e:	c9                   	leave  
  801a7f:	c3                   	ret    

00801a80 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801a80:	55                   	push   %ebp
  801a81:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a83:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a86:	8b 45 08             	mov    0x8(%ebp),%eax
  801a89:	6a 00                	push   $0x0
  801a8b:	6a 00                	push   $0x0
  801a8d:	6a 00                	push   $0x0
  801a8f:	52                   	push   %edx
  801a90:	50                   	push   %eax
  801a91:	6a 1a                	push   $0x1a
  801a93:	e8 7f fd ff ff       	call   801817 <syscall>
  801a98:	83 c4 18             	add    $0x18,%esp
}
  801a9b:	c9                   	leave  
  801a9c:	c3                   	ret    

00801a9d <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a9d:	55                   	push   %ebp
  801a9e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801aa0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aa3:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa6:	6a 00                	push   $0x0
  801aa8:	6a 00                	push   $0x0
  801aaa:	6a 00                	push   $0x0
  801aac:	52                   	push   %edx
  801aad:	50                   	push   %eax
  801aae:	6a 18                	push   $0x18
  801ab0:	e8 62 fd ff ff       	call   801817 <syscall>
  801ab5:	83 c4 18             	add    $0x18,%esp
}
  801ab8:	90                   	nop
  801ab9:	c9                   	leave  
  801aba:	c3                   	ret    

00801abb <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801abb:	55                   	push   %ebp
  801abc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801abe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac4:	6a 00                	push   $0x0
  801ac6:	6a 00                	push   $0x0
  801ac8:	6a 00                	push   $0x0
  801aca:	52                   	push   %edx
  801acb:	50                   	push   %eax
  801acc:	6a 19                	push   $0x19
  801ace:	e8 44 fd ff ff       	call   801817 <syscall>
  801ad3:	83 c4 18             	add    $0x18,%esp
}
  801ad6:	90                   	nop
  801ad7:	c9                   	leave  
  801ad8:	c3                   	ret    

00801ad9 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801ad9:	55                   	push   %ebp
  801ada:	89 e5                	mov    %esp,%ebp
  801adc:	83 ec 04             	sub    $0x4,%esp
  801adf:	8b 45 10             	mov    0x10(%ebp),%eax
  801ae2:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801ae5:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ae8:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801aec:	8b 45 08             	mov    0x8(%ebp),%eax
  801aef:	6a 00                	push   $0x0
  801af1:	51                   	push   %ecx
  801af2:	52                   	push   %edx
  801af3:	ff 75 0c             	pushl  0xc(%ebp)
  801af6:	50                   	push   %eax
  801af7:	6a 1b                	push   $0x1b
  801af9:	e8 19 fd ff ff       	call   801817 <syscall>
  801afe:	83 c4 18             	add    $0x18,%esp
}
  801b01:	c9                   	leave  
  801b02:	c3                   	ret    

00801b03 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b03:	55                   	push   %ebp
  801b04:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b06:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b09:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0c:	6a 00                	push   $0x0
  801b0e:	6a 00                	push   $0x0
  801b10:	6a 00                	push   $0x0
  801b12:	52                   	push   %edx
  801b13:	50                   	push   %eax
  801b14:	6a 1c                	push   $0x1c
  801b16:	e8 fc fc ff ff       	call   801817 <syscall>
  801b1b:	83 c4 18             	add    $0x18,%esp
}
  801b1e:	c9                   	leave  
  801b1f:	c3                   	ret    

00801b20 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b20:	55                   	push   %ebp
  801b21:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b23:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b26:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b29:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2c:	6a 00                	push   $0x0
  801b2e:	6a 00                	push   $0x0
  801b30:	51                   	push   %ecx
  801b31:	52                   	push   %edx
  801b32:	50                   	push   %eax
  801b33:	6a 1d                	push   $0x1d
  801b35:	e8 dd fc ff ff       	call   801817 <syscall>
  801b3a:	83 c4 18             	add    $0x18,%esp
}
  801b3d:	c9                   	leave  
  801b3e:	c3                   	ret    

00801b3f <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b3f:	55                   	push   %ebp
  801b40:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b42:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b45:	8b 45 08             	mov    0x8(%ebp),%eax
  801b48:	6a 00                	push   $0x0
  801b4a:	6a 00                	push   $0x0
  801b4c:	6a 00                	push   $0x0
  801b4e:	52                   	push   %edx
  801b4f:	50                   	push   %eax
  801b50:	6a 1e                	push   $0x1e
  801b52:	e8 c0 fc ff ff       	call   801817 <syscall>
  801b57:	83 c4 18             	add    $0x18,%esp
}
  801b5a:	c9                   	leave  
  801b5b:	c3                   	ret    

00801b5c <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b5c:	55                   	push   %ebp
  801b5d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b5f:	6a 00                	push   $0x0
  801b61:	6a 00                	push   $0x0
  801b63:	6a 00                	push   $0x0
  801b65:	6a 00                	push   $0x0
  801b67:	6a 00                	push   $0x0
  801b69:	6a 1f                	push   $0x1f
  801b6b:	e8 a7 fc ff ff       	call   801817 <syscall>
  801b70:	83 c4 18             	add    $0x18,%esp
}
  801b73:	c9                   	leave  
  801b74:	c3                   	ret    

00801b75 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b75:	55                   	push   %ebp
  801b76:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b78:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7b:	6a 00                	push   $0x0
  801b7d:	ff 75 14             	pushl  0x14(%ebp)
  801b80:	ff 75 10             	pushl  0x10(%ebp)
  801b83:	ff 75 0c             	pushl  0xc(%ebp)
  801b86:	50                   	push   %eax
  801b87:	6a 20                	push   $0x20
  801b89:	e8 89 fc ff ff       	call   801817 <syscall>
  801b8e:	83 c4 18             	add    $0x18,%esp
}
  801b91:	c9                   	leave  
  801b92:	c3                   	ret    

00801b93 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801b93:	55                   	push   %ebp
  801b94:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b96:	8b 45 08             	mov    0x8(%ebp),%eax
  801b99:	6a 00                	push   $0x0
  801b9b:	6a 00                	push   $0x0
  801b9d:	6a 00                	push   $0x0
  801b9f:	6a 00                	push   $0x0
  801ba1:	50                   	push   %eax
  801ba2:	6a 21                	push   $0x21
  801ba4:	e8 6e fc ff ff       	call   801817 <syscall>
  801ba9:	83 c4 18             	add    $0x18,%esp
}
  801bac:	90                   	nop
  801bad:	c9                   	leave  
  801bae:	c3                   	ret    

00801baf <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801baf:	55                   	push   %ebp
  801bb0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801bb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb5:	6a 00                	push   $0x0
  801bb7:	6a 00                	push   $0x0
  801bb9:	6a 00                	push   $0x0
  801bbb:	6a 00                	push   $0x0
  801bbd:	50                   	push   %eax
  801bbe:	6a 22                	push   $0x22
  801bc0:	e8 52 fc ff ff       	call   801817 <syscall>
  801bc5:	83 c4 18             	add    $0x18,%esp
}
  801bc8:	c9                   	leave  
  801bc9:	c3                   	ret    

00801bca <sys_getenvid>:

int32 sys_getenvid(void)
{
  801bca:	55                   	push   %ebp
  801bcb:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801bcd:	6a 00                	push   $0x0
  801bcf:	6a 00                	push   $0x0
  801bd1:	6a 00                	push   $0x0
  801bd3:	6a 00                	push   $0x0
  801bd5:	6a 00                	push   $0x0
  801bd7:	6a 02                	push   $0x2
  801bd9:	e8 39 fc ff ff       	call   801817 <syscall>
  801bde:	83 c4 18             	add    $0x18,%esp
}
  801be1:	c9                   	leave  
  801be2:	c3                   	ret    

00801be3 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801be3:	55                   	push   %ebp
  801be4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801be6:	6a 00                	push   $0x0
  801be8:	6a 00                	push   $0x0
  801bea:	6a 00                	push   $0x0
  801bec:	6a 00                	push   $0x0
  801bee:	6a 00                	push   $0x0
  801bf0:	6a 03                	push   $0x3
  801bf2:	e8 20 fc ff ff       	call   801817 <syscall>
  801bf7:	83 c4 18             	add    $0x18,%esp
}
  801bfa:	c9                   	leave  
  801bfb:	c3                   	ret    

00801bfc <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801bfc:	55                   	push   %ebp
  801bfd:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801bff:	6a 00                	push   $0x0
  801c01:	6a 00                	push   $0x0
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	6a 00                	push   $0x0
  801c09:	6a 04                	push   $0x4
  801c0b:	e8 07 fc ff ff       	call   801817 <syscall>
  801c10:	83 c4 18             	add    $0x18,%esp
}
  801c13:	c9                   	leave  
  801c14:	c3                   	ret    

00801c15 <sys_exit_env>:


void sys_exit_env(void)
{
  801c15:	55                   	push   %ebp
  801c16:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c18:	6a 00                	push   $0x0
  801c1a:	6a 00                	push   $0x0
  801c1c:	6a 00                	push   $0x0
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 00                	push   $0x0
  801c22:	6a 23                	push   $0x23
  801c24:	e8 ee fb ff ff       	call   801817 <syscall>
  801c29:	83 c4 18             	add    $0x18,%esp
}
  801c2c:	90                   	nop
  801c2d:	c9                   	leave  
  801c2e:	c3                   	ret    

00801c2f <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801c2f:	55                   	push   %ebp
  801c30:	89 e5                	mov    %esp,%ebp
  801c32:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c35:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c38:	8d 50 04             	lea    0x4(%eax),%edx
  801c3b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 00                	push   $0x0
  801c42:	6a 00                	push   $0x0
  801c44:	52                   	push   %edx
  801c45:	50                   	push   %eax
  801c46:	6a 24                	push   $0x24
  801c48:	e8 ca fb ff ff       	call   801817 <syscall>
  801c4d:	83 c4 18             	add    $0x18,%esp
	return result;
  801c50:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c53:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c56:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c59:	89 01                	mov    %eax,(%ecx)
  801c5b:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c61:	c9                   	leave  
  801c62:	c2 04 00             	ret    $0x4

00801c65 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c65:	55                   	push   %ebp
  801c66:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 00                	push   $0x0
  801c6c:	ff 75 10             	pushl  0x10(%ebp)
  801c6f:	ff 75 0c             	pushl  0xc(%ebp)
  801c72:	ff 75 08             	pushl  0x8(%ebp)
  801c75:	6a 12                	push   $0x12
  801c77:	e8 9b fb ff ff       	call   801817 <syscall>
  801c7c:	83 c4 18             	add    $0x18,%esp
	return ;
  801c7f:	90                   	nop
}
  801c80:	c9                   	leave  
  801c81:	c3                   	ret    

00801c82 <sys_rcr2>:
uint32 sys_rcr2()
{
  801c82:	55                   	push   %ebp
  801c83:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c85:	6a 00                	push   $0x0
  801c87:	6a 00                	push   $0x0
  801c89:	6a 00                	push   $0x0
  801c8b:	6a 00                	push   $0x0
  801c8d:	6a 00                	push   $0x0
  801c8f:	6a 25                	push   $0x25
  801c91:	e8 81 fb ff ff       	call   801817 <syscall>
  801c96:	83 c4 18             	add    $0x18,%esp
}
  801c99:	c9                   	leave  
  801c9a:	c3                   	ret    

00801c9b <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801c9b:	55                   	push   %ebp
  801c9c:	89 e5                	mov    %esp,%ebp
  801c9e:	83 ec 04             	sub    $0x4,%esp
  801ca1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801ca7:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801cab:	6a 00                	push   $0x0
  801cad:	6a 00                	push   $0x0
  801caf:	6a 00                	push   $0x0
  801cb1:	6a 00                	push   $0x0
  801cb3:	50                   	push   %eax
  801cb4:	6a 26                	push   $0x26
  801cb6:	e8 5c fb ff ff       	call   801817 <syscall>
  801cbb:	83 c4 18             	add    $0x18,%esp
	return ;
  801cbe:	90                   	nop
}
  801cbf:	c9                   	leave  
  801cc0:	c3                   	ret    

00801cc1 <rsttst>:
void rsttst()
{
  801cc1:	55                   	push   %ebp
  801cc2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801cc4:	6a 00                	push   $0x0
  801cc6:	6a 00                	push   $0x0
  801cc8:	6a 00                	push   $0x0
  801cca:	6a 00                	push   $0x0
  801ccc:	6a 00                	push   $0x0
  801cce:	6a 28                	push   $0x28
  801cd0:	e8 42 fb ff ff       	call   801817 <syscall>
  801cd5:	83 c4 18             	add    $0x18,%esp
	return ;
  801cd8:	90                   	nop
}
  801cd9:	c9                   	leave  
  801cda:	c3                   	ret    

00801cdb <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801cdb:	55                   	push   %ebp
  801cdc:	89 e5                	mov    %esp,%ebp
  801cde:	83 ec 04             	sub    $0x4,%esp
  801ce1:	8b 45 14             	mov    0x14(%ebp),%eax
  801ce4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ce7:	8b 55 18             	mov    0x18(%ebp),%edx
  801cea:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801cee:	52                   	push   %edx
  801cef:	50                   	push   %eax
  801cf0:	ff 75 10             	pushl  0x10(%ebp)
  801cf3:	ff 75 0c             	pushl  0xc(%ebp)
  801cf6:	ff 75 08             	pushl  0x8(%ebp)
  801cf9:	6a 27                	push   $0x27
  801cfb:	e8 17 fb ff ff       	call   801817 <syscall>
  801d00:	83 c4 18             	add    $0x18,%esp
	return ;
  801d03:	90                   	nop
}
  801d04:	c9                   	leave  
  801d05:	c3                   	ret    

00801d06 <chktst>:
void chktst(uint32 n)
{
  801d06:	55                   	push   %ebp
  801d07:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d09:	6a 00                	push   $0x0
  801d0b:	6a 00                	push   $0x0
  801d0d:	6a 00                	push   $0x0
  801d0f:	6a 00                	push   $0x0
  801d11:	ff 75 08             	pushl  0x8(%ebp)
  801d14:	6a 29                	push   $0x29
  801d16:	e8 fc fa ff ff       	call   801817 <syscall>
  801d1b:	83 c4 18             	add    $0x18,%esp
	return ;
  801d1e:	90                   	nop
}
  801d1f:	c9                   	leave  
  801d20:	c3                   	ret    

00801d21 <inctst>:

void inctst()
{
  801d21:	55                   	push   %ebp
  801d22:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d24:	6a 00                	push   $0x0
  801d26:	6a 00                	push   $0x0
  801d28:	6a 00                	push   $0x0
  801d2a:	6a 00                	push   $0x0
  801d2c:	6a 00                	push   $0x0
  801d2e:	6a 2a                	push   $0x2a
  801d30:	e8 e2 fa ff ff       	call   801817 <syscall>
  801d35:	83 c4 18             	add    $0x18,%esp
	return ;
  801d38:	90                   	nop
}
  801d39:	c9                   	leave  
  801d3a:	c3                   	ret    

00801d3b <gettst>:
uint32 gettst()
{
  801d3b:	55                   	push   %ebp
  801d3c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d3e:	6a 00                	push   $0x0
  801d40:	6a 00                	push   $0x0
  801d42:	6a 00                	push   $0x0
  801d44:	6a 00                	push   $0x0
  801d46:	6a 00                	push   $0x0
  801d48:	6a 2b                	push   $0x2b
  801d4a:	e8 c8 fa ff ff       	call   801817 <syscall>
  801d4f:	83 c4 18             	add    $0x18,%esp
}
  801d52:	c9                   	leave  
  801d53:	c3                   	ret    

00801d54 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d54:	55                   	push   %ebp
  801d55:	89 e5                	mov    %esp,%ebp
  801d57:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d5a:	6a 00                	push   $0x0
  801d5c:	6a 00                	push   $0x0
  801d5e:	6a 00                	push   $0x0
  801d60:	6a 00                	push   $0x0
  801d62:	6a 00                	push   $0x0
  801d64:	6a 2c                	push   $0x2c
  801d66:	e8 ac fa ff ff       	call   801817 <syscall>
  801d6b:	83 c4 18             	add    $0x18,%esp
  801d6e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d71:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d75:	75 07                	jne    801d7e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d77:	b8 01 00 00 00       	mov    $0x1,%eax
  801d7c:	eb 05                	jmp    801d83 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d7e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d83:	c9                   	leave  
  801d84:	c3                   	ret    

00801d85 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d85:	55                   	push   %ebp
  801d86:	89 e5                	mov    %esp,%ebp
  801d88:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d8b:	6a 00                	push   $0x0
  801d8d:	6a 00                	push   $0x0
  801d8f:	6a 00                	push   $0x0
  801d91:	6a 00                	push   $0x0
  801d93:	6a 00                	push   $0x0
  801d95:	6a 2c                	push   $0x2c
  801d97:	e8 7b fa ff ff       	call   801817 <syscall>
  801d9c:	83 c4 18             	add    $0x18,%esp
  801d9f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801da2:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801da6:	75 07                	jne    801daf <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801da8:	b8 01 00 00 00       	mov    $0x1,%eax
  801dad:	eb 05                	jmp    801db4 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801daf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801db4:	c9                   	leave  
  801db5:	c3                   	ret    

00801db6 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801db6:	55                   	push   %ebp
  801db7:	89 e5                	mov    %esp,%ebp
  801db9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dbc:	6a 00                	push   $0x0
  801dbe:	6a 00                	push   $0x0
  801dc0:	6a 00                	push   $0x0
  801dc2:	6a 00                	push   $0x0
  801dc4:	6a 00                	push   $0x0
  801dc6:	6a 2c                	push   $0x2c
  801dc8:	e8 4a fa ff ff       	call   801817 <syscall>
  801dcd:	83 c4 18             	add    $0x18,%esp
  801dd0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801dd3:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801dd7:	75 07                	jne    801de0 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801dd9:	b8 01 00 00 00       	mov    $0x1,%eax
  801dde:	eb 05                	jmp    801de5 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801de0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801de5:	c9                   	leave  
  801de6:	c3                   	ret    

00801de7 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801de7:	55                   	push   %ebp
  801de8:	89 e5                	mov    %esp,%ebp
  801dea:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ded:	6a 00                	push   $0x0
  801def:	6a 00                	push   $0x0
  801df1:	6a 00                	push   $0x0
  801df3:	6a 00                	push   $0x0
  801df5:	6a 00                	push   $0x0
  801df7:	6a 2c                	push   $0x2c
  801df9:	e8 19 fa ff ff       	call   801817 <syscall>
  801dfe:	83 c4 18             	add    $0x18,%esp
  801e01:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e04:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e08:	75 07                	jne    801e11 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e0a:	b8 01 00 00 00       	mov    $0x1,%eax
  801e0f:	eb 05                	jmp    801e16 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e11:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e16:	c9                   	leave  
  801e17:	c3                   	ret    

00801e18 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e18:	55                   	push   %ebp
  801e19:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e1b:	6a 00                	push   $0x0
  801e1d:	6a 00                	push   $0x0
  801e1f:	6a 00                	push   $0x0
  801e21:	6a 00                	push   $0x0
  801e23:	ff 75 08             	pushl  0x8(%ebp)
  801e26:	6a 2d                	push   $0x2d
  801e28:	e8 ea f9 ff ff       	call   801817 <syscall>
  801e2d:	83 c4 18             	add    $0x18,%esp
	return ;
  801e30:	90                   	nop
}
  801e31:	c9                   	leave  
  801e32:	c3                   	ret    

00801e33 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e33:	55                   	push   %ebp
  801e34:	89 e5                	mov    %esp,%ebp
  801e36:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e37:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e3a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e40:	8b 45 08             	mov    0x8(%ebp),%eax
  801e43:	6a 00                	push   $0x0
  801e45:	53                   	push   %ebx
  801e46:	51                   	push   %ecx
  801e47:	52                   	push   %edx
  801e48:	50                   	push   %eax
  801e49:	6a 2e                	push   $0x2e
  801e4b:	e8 c7 f9 ff ff       	call   801817 <syscall>
  801e50:	83 c4 18             	add    $0x18,%esp
}
  801e53:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e56:	c9                   	leave  
  801e57:	c3                   	ret    

00801e58 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e58:	55                   	push   %ebp
  801e59:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e61:	6a 00                	push   $0x0
  801e63:	6a 00                	push   $0x0
  801e65:	6a 00                	push   $0x0
  801e67:	52                   	push   %edx
  801e68:	50                   	push   %eax
  801e69:	6a 2f                	push   $0x2f
  801e6b:	e8 a7 f9 ff ff       	call   801817 <syscall>
  801e70:	83 c4 18             	add    $0x18,%esp
}
  801e73:	c9                   	leave  
  801e74:	c3                   	ret    

00801e75 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801e75:	55                   	push   %ebp
  801e76:	89 e5                	mov    %esp,%ebp
  801e78:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801e7b:	83 ec 0c             	sub    $0xc,%esp
  801e7e:	68 38 41 80 00       	push   $0x804138
  801e83:	e8 d3 e8 ff ff       	call   80075b <cprintf>
  801e88:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801e8b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801e92:	83 ec 0c             	sub    $0xc,%esp
  801e95:	68 64 41 80 00       	push   $0x804164
  801e9a:	e8 bc e8 ff ff       	call   80075b <cprintf>
  801e9f:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801ea2:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ea6:	a1 38 51 80 00       	mov    0x805138,%eax
  801eab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801eae:	eb 56                	jmp    801f06 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801eb0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801eb4:	74 1c                	je     801ed2 <print_mem_block_lists+0x5d>
  801eb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb9:	8b 50 08             	mov    0x8(%eax),%edx
  801ebc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ebf:	8b 48 08             	mov    0x8(%eax),%ecx
  801ec2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ec5:	8b 40 0c             	mov    0xc(%eax),%eax
  801ec8:	01 c8                	add    %ecx,%eax
  801eca:	39 c2                	cmp    %eax,%edx
  801ecc:	73 04                	jae    801ed2 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801ece:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801ed2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed5:	8b 50 08             	mov    0x8(%eax),%edx
  801ed8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801edb:	8b 40 0c             	mov    0xc(%eax),%eax
  801ede:	01 c2                	add    %eax,%edx
  801ee0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee3:	8b 40 08             	mov    0x8(%eax),%eax
  801ee6:	83 ec 04             	sub    $0x4,%esp
  801ee9:	52                   	push   %edx
  801eea:	50                   	push   %eax
  801eeb:	68 79 41 80 00       	push   $0x804179
  801ef0:	e8 66 e8 ff ff       	call   80075b <cprintf>
  801ef5:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801ef8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801efb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801efe:	a1 40 51 80 00       	mov    0x805140,%eax
  801f03:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f06:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f0a:	74 07                	je     801f13 <print_mem_block_lists+0x9e>
  801f0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f0f:	8b 00                	mov    (%eax),%eax
  801f11:	eb 05                	jmp    801f18 <print_mem_block_lists+0xa3>
  801f13:	b8 00 00 00 00       	mov    $0x0,%eax
  801f18:	a3 40 51 80 00       	mov    %eax,0x805140
  801f1d:	a1 40 51 80 00       	mov    0x805140,%eax
  801f22:	85 c0                	test   %eax,%eax
  801f24:	75 8a                	jne    801eb0 <print_mem_block_lists+0x3b>
  801f26:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f2a:	75 84                	jne    801eb0 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801f2c:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f30:	75 10                	jne    801f42 <print_mem_block_lists+0xcd>
  801f32:	83 ec 0c             	sub    $0xc,%esp
  801f35:	68 88 41 80 00       	push   $0x804188
  801f3a:	e8 1c e8 ff ff       	call   80075b <cprintf>
  801f3f:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801f42:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801f49:	83 ec 0c             	sub    $0xc,%esp
  801f4c:	68 ac 41 80 00       	push   $0x8041ac
  801f51:	e8 05 e8 ff ff       	call   80075b <cprintf>
  801f56:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801f59:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f5d:	a1 40 50 80 00       	mov    0x805040,%eax
  801f62:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f65:	eb 56                	jmp    801fbd <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f67:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f6b:	74 1c                	je     801f89 <print_mem_block_lists+0x114>
  801f6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f70:	8b 50 08             	mov    0x8(%eax),%edx
  801f73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f76:	8b 48 08             	mov    0x8(%eax),%ecx
  801f79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f7c:	8b 40 0c             	mov    0xc(%eax),%eax
  801f7f:	01 c8                	add    %ecx,%eax
  801f81:	39 c2                	cmp    %eax,%edx
  801f83:	73 04                	jae    801f89 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801f85:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f8c:	8b 50 08             	mov    0x8(%eax),%edx
  801f8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f92:	8b 40 0c             	mov    0xc(%eax),%eax
  801f95:	01 c2                	add    %eax,%edx
  801f97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f9a:	8b 40 08             	mov    0x8(%eax),%eax
  801f9d:	83 ec 04             	sub    $0x4,%esp
  801fa0:	52                   	push   %edx
  801fa1:	50                   	push   %eax
  801fa2:	68 79 41 80 00       	push   $0x804179
  801fa7:	e8 af e7 ff ff       	call   80075b <cprintf>
  801fac:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801faf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801fb5:	a1 48 50 80 00       	mov    0x805048,%eax
  801fba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fbd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fc1:	74 07                	je     801fca <print_mem_block_lists+0x155>
  801fc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc6:	8b 00                	mov    (%eax),%eax
  801fc8:	eb 05                	jmp    801fcf <print_mem_block_lists+0x15a>
  801fca:	b8 00 00 00 00       	mov    $0x0,%eax
  801fcf:	a3 48 50 80 00       	mov    %eax,0x805048
  801fd4:	a1 48 50 80 00       	mov    0x805048,%eax
  801fd9:	85 c0                	test   %eax,%eax
  801fdb:	75 8a                	jne    801f67 <print_mem_block_lists+0xf2>
  801fdd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fe1:	75 84                	jne    801f67 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801fe3:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801fe7:	75 10                	jne    801ff9 <print_mem_block_lists+0x184>
  801fe9:	83 ec 0c             	sub    $0xc,%esp
  801fec:	68 c4 41 80 00       	push   $0x8041c4
  801ff1:	e8 65 e7 ff ff       	call   80075b <cprintf>
  801ff6:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801ff9:	83 ec 0c             	sub    $0xc,%esp
  801ffc:	68 38 41 80 00       	push   $0x804138
  802001:	e8 55 e7 ff ff       	call   80075b <cprintf>
  802006:	83 c4 10             	add    $0x10,%esp

}
  802009:	90                   	nop
  80200a:	c9                   	leave  
  80200b:	c3                   	ret    

0080200c <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80200c:	55                   	push   %ebp
  80200d:	89 e5                	mov    %esp,%ebp
  80200f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  802012:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802019:	00 00 00 
  80201c:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802023:	00 00 00 
  802026:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  80202d:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  802030:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802037:	e9 9e 00 00 00       	jmp    8020da <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  80203c:	a1 50 50 80 00       	mov    0x805050,%eax
  802041:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802044:	c1 e2 04             	shl    $0x4,%edx
  802047:	01 d0                	add    %edx,%eax
  802049:	85 c0                	test   %eax,%eax
  80204b:	75 14                	jne    802061 <initialize_MemBlocksList+0x55>
  80204d:	83 ec 04             	sub    $0x4,%esp
  802050:	68 ec 41 80 00       	push   $0x8041ec
  802055:	6a 46                	push   $0x46
  802057:	68 0f 42 80 00       	push   $0x80420f
  80205c:	e8 46 e4 ff ff       	call   8004a7 <_panic>
  802061:	a1 50 50 80 00       	mov    0x805050,%eax
  802066:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802069:	c1 e2 04             	shl    $0x4,%edx
  80206c:	01 d0                	add    %edx,%eax
  80206e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802074:	89 10                	mov    %edx,(%eax)
  802076:	8b 00                	mov    (%eax),%eax
  802078:	85 c0                	test   %eax,%eax
  80207a:	74 18                	je     802094 <initialize_MemBlocksList+0x88>
  80207c:	a1 48 51 80 00       	mov    0x805148,%eax
  802081:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802087:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80208a:	c1 e1 04             	shl    $0x4,%ecx
  80208d:	01 ca                	add    %ecx,%edx
  80208f:	89 50 04             	mov    %edx,0x4(%eax)
  802092:	eb 12                	jmp    8020a6 <initialize_MemBlocksList+0x9a>
  802094:	a1 50 50 80 00       	mov    0x805050,%eax
  802099:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80209c:	c1 e2 04             	shl    $0x4,%edx
  80209f:	01 d0                	add    %edx,%eax
  8020a1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8020a6:	a1 50 50 80 00       	mov    0x805050,%eax
  8020ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020ae:	c1 e2 04             	shl    $0x4,%edx
  8020b1:	01 d0                	add    %edx,%eax
  8020b3:	a3 48 51 80 00       	mov    %eax,0x805148
  8020b8:	a1 50 50 80 00       	mov    0x805050,%eax
  8020bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020c0:	c1 e2 04             	shl    $0x4,%edx
  8020c3:	01 d0                	add    %edx,%eax
  8020c5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020cc:	a1 54 51 80 00       	mov    0x805154,%eax
  8020d1:	40                   	inc    %eax
  8020d2:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  8020d7:	ff 45 f4             	incl   -0xc(%ebp)
  8020da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020dd:	3b 45 08             	cmp    0x8(%ebp),%eax
  8020e0:	0f 82 56 ff ff ff    	jb     80203c <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  8020e6:	90                   	nop
  8020e7:	c9                   	leave  
  8020e8:	c3                   	ret    

008020e9 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8020e9:	55                   	push   %ebp
  8020ea:	89 e5                	mov    %esp,%ebp
  8020ec:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8020ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f2:	8b 00                	mov    (%eax),%eax
  8020f4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020f7:	eb 19                	jmp    802112 <find_block+0x29>
	{
		if(va==point->sva)
  8020f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020fc:	8b 40 08             	mov    0x8(%eax),%eax
  8020ff:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802102:	75 05                	jne    802109 <find_block+0x20>
		   return point;
  802104:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802107:	eb 36                	jmp    80213f <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802109:	8b 45 08             	mov    0x8(%ebp),%eax
  80210c:	8b 40 08             	mov    0x8(%eax),%eax
  80210f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802112:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802116:	74 07                	je     80211f <find_block+0x36>
  802118:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80211b:	8b 00                	mov    (%eax),%eax
  80211d:	eb 05                	jmp    802124 <find_block+0x3b>
  80211f:	b8 00 00 00 00       	mov    $0x0,%eax
  802124:	8b 55 08             	mov    0x8(%ebp),%edx
  802127:	89 42 08             	mov    %eax,0x8(%edx)
  80212a:	8b 45 08             	mov    0x8(%ebp),%eax
  80212d:	8b 40 08             	mov    0x8(%eax),%eax
  802130:	85 c0                	test   %eax,%eax
  802132:	75 c5                	jne    8020f9 <find_block+0x10>
  802134:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802138:	75 bf                	jne    8020f9 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  80213a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80213f:	c9                   	leave  
  802140:	c3                   	ret    

00802141 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802141:	55                   	push   %ebp
  802142:	89 e5                	mov    %esp,%ebp
  802144:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802147:	a1 40 50 80 00       	mov    0x805040,%eax
  80214c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  80214f:	a1 44 50 80 00       	mov    0x805044,%eax
  802154:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802157:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80215a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80215d:	74 24                	je     802183 <insert_sorted_allocList+0x42>
  80215f:	8b 45 08             	mov    0x8(%ebp),%eax
  802162:	8b 50 08             	mov    0x8(%eax),%edx
  802165:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802168:	8b 40 08             	mov    0x8(%eax),%eax
  80216b:	39 c2                	cmp    %eax,%edx
  80216d:	76 14                	jbe    802183 <insert_sorted_allocList+0x42>
  80216f:	8b 45 08             	mov    0x8(%ebp),%eax
  802172:	8b 50 08             	mov    0x8(%eax),%edx
  802175:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802178:	8b 40 08             	mov    0x8(%eax),%eax
  80217b:	39 c2                	cmp    %eax,%edx
  80217d:	0f 82 60 01 00 00    	jb     8022e3 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802183:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802187:	75 65                	jne    8021ee <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802189:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80218d:	75 14                	jne    8021a3 <insert_sorted_allocList+0x62>
  80218f:	83 ec 04             	sub    $0x4,%esp
  802192:	68 ec 41 80 00       	push   $0x8041ec
  802197:	6a 6b                	push   $0x6b
  802199:	68 0f 42 80 00       	push   $0x80420f
  80219e:	e8 04 e3 ff ff       	call   8004a7 <_panic>
  8021a3:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8021a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ac:	89 10                	mov    %edx,(%eax)
  8021ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b1:	8b 00                	mov    (%eax),%eax
  8021b3:	85 c0                	test   %eax,%eax
  8021b5:	74 0d                	je     8021c4 <insert_sorted_allocList+0x83>
  8021b7:	a1 40 50 80 00       	mov    0x805040,%eax
  8021bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8021bf:	89 50 04             	mov    %edx,0x4(%eax)
  8021c2:	eb 08                	jmp    8021cc <insert_sorted_allocList+0x8b>
  8021c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c7:	a3 44 50 80 00       	mov    %eax,0x805044
  8021cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021cf:	a3 40 50 80 00       	mov    %eax,0x805040
  8021d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021de:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8021e3:	40                   	inc    %eax
  8021e4:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8021e9:	e9 dc 01 00 00       	jmp    8023ca <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8021ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f1:	8b 50 08             	mov    0x8(%eax),%edx
  8021f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021f7:	8b 40 08             	mov    0x8(%eax),%eax
  8021fa:	39 c2                	cmp    %eax,%edx
  8021fc:	77 6c                	ja     80226a <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8021fe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802202:	74 06                	je     80220a <insert_sorted_allocList+0xc9>
  802204:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802208:	75 14                	jne    80221e <insert_sorted_allocList+0xdd>
  80220a:	83 ec 04             	sub    $0x4,%esp
  80220d:	68 28 42 80 00       	push   $0x804228
  802212:	6a 6f                	push   $0x6f
  802214:	68 0f 42 80 00       	push   $0x80420f
  802219:	e8 89 e2 ff ff       	call   8004a7 <_panic>
  80221e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802221:	8b 50 04             	mov    0x4(%eax),%edx
  802224:	8b 45 08             	mov    0x8(%ebp),%eax
  802227:	89 50 04             	mov    %edx,0x4(%eax)
  80222a:	8b 45 08             	mov    0x8(%ebp),%eax
  80222d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802230:	89 10                	mov    %edx,(%eax)
  802232:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802235:	8b 40 04             	mov    0x4(%eax),%eax
  802238:	85 c0                	test   %eax,%eax
  80223a:	74 0d                	je     802249 <insert_sorted_allocList+0x108>
  80223c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80223f:	8b 40 04             	mov    0x4(%eax),%eax
  802242:	8b 55 08             	mov    0x8(%ebp),%edx
  802245:	89 10                	mov    %edx,(%eax)
  802247:	eb 08                	jmp    802251 <insert_sorted_allocList+0x110>
  802249:	8b 45 08             	mov    0x8(%ebp),%eax
  80224c:	a3 40 50 80 00       	mov    %eax,0x805040
  802251:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802254:	8b 55 08             	mov    0x8(%ebp),%edx
  802257:	89 50 04             	mov    %edx,0x4(%eax)
  80225a:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80225f:	40                   	inc    %eax
  802260:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802265:	e9 60 01 00 00       	jmp    8023ca <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  80226a:	8b 45 08             	mov    0x8(%ebp),%eax
  80226d:	8b 50 08             	mov    0x8(%eax),%edx
  802270:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802273:	8b 40 08             	mov    0x8(%eax),%eax
  802276:	39 c2                	cmp    %eax,%edx
  802278:	0f 82 4c 01 00 00    	jb     8023ca <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  80227e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802282:	75 14                	jne    802298 <insert_sorted_allocList+0x157>
  802284:	83 ec 04             	sub    $0x4,%esp
  802287:	68 60 42 80 00       	push   $0x804260
  80228c:	6a 73                	push   $0x73
  80228e:	68 0f 42 80 00       	push   $0x80420f
  802293:	e8 0f e2 ff ff       	call   8004a7 <_panic>
  802298:	8b 15 44 50 80 00    	mov    0x805044,%edx
  80229e:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a1:	89 50 04             	mov    %edx,0x4(%eax)
  8022a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a7:	8b 40 04             	mov    0x4(%eax),%eax
  8022aa:	85 c0                	test   %eax,%eax
  8022ac:	74 0c                	je     8022ba <insert_sorted_allocList+0x179>
  8022ae:	a1 44 50 80 00       	mov    0x805044,%eax
  8022b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8022b6:	89 10                	mov    %edx,(%eax)
  8022b8:	eb 08                	jmp    8022c2 <insert_sorted_allocList+0x181>
  8022ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bd:	a3 40 50 80 00       	mov    %eax,0x805040
  8022c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c5:	a3 44 50 80 00       	mov    %eax,0x805044
  8022ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8022cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022d3:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8022d8:	40                   	inc    %eax
  8022d9:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8022de:	e9 e7 00 00 00       	jmp    8023ca <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8022e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8022e9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8022f0:	a1 40 50 80 00       	mov    0x805040,%eax
  8022f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022f8:	e9 9d 00 00 00       	jmp    80239a <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8022fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802300:	8b 00                	mov    (%eax),%eax
  802302:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802305:	8b 45 08             	mov    0x8(%ebp),%eax
  802308:	8b 50 08             	mov    0x8(%eax),%edx
  80230b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230e:	8b 40 08             	mov    0x8(%eax),%eax
  802311:	39 c2                	cmp    %eax,%edx
  802313:	76 7d                	jbe    802392 <insert_sorted_allocList+0x251>
  802315:	8b 45 08             	mov    0x8(%ebp),%eax
  802318:	8b 50 08             	mov    0x8(%eax),%edx
  80231b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80231e:	8b 40 08             	mov    0x8(%eax),%eax
  802321:	39 c2                	cmp    %eax,%edx
  802323:	73 6d                	jae    802392 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802325:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802329:	74 06                	je     802331 <insert_sorted_allocList+0x1f0>
  80232b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80232f:	75 14                	jne    802345 <insert_sorted_allocList+0x204>
  802331:	83 ec 04             	sub    $0x4,%esp
  802334:	68 84 42 80 00       	push   $0x804284
  802339:	6a 7f                	push   $0x7f
  80233b:	68 0f 42 80 00       	push   $0x80420f
  802340:	e8 62 e1 ff ff       	call   8004a7 <_panic>
  802345:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802348:	8b 10                	mov    (%eax),%edx
  80234a:	8b 45 08             	mov    0x8(%ebp),%eax
  80234d:	89 10                	mov    %edx,(%eax)
  80234f:	8b 45 08             	mov    0x8(%ebp),%eax
  802352:	8b 00                	mov    (%eax),%eax
  802354:	85 c0                	test   %eax,%eax
  802356:	74 0b                	je     802363 <insert_sorted_allocList+0x222>
  802358:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235b:	8b 00                	mov    (%eax),%eax
  80235d:	8b 55 08             	mov    0x8(%ebp),%edx
  802360:	89 50 04             	mov    %edx,0x4(%eax)
  802363:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802366:	8b 55 08             	mov    0x8(%ebp),%edx
  802369:	89 10                	mov    %edx,(%eax)
  80236b:	8b 45 08             	mov    0x8(%ebp),%eax
  80236e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802371:	89 50 04             	mov    %edx,0x4(%eax)
  802374:	8b 45 08             	mov    0x8(%ebp),%eax
  802377:	8b 00                	mov    (%eax),%eax
  802379:	85 c0                	test   %eax,%eax
  80237b:	75 08                	jne    802385 <insert_sorted_allocList+0x244>
  80237d:	8b 45 08             	mov    0x8(%ebp),%eax
  802380:	a3 44 50 80 00       	mov    %eax,0x805044
  802385:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80238a:	40                   	inc    %eax
  80238b:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802390:	eb 39                	jmp    8023cb <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802392:	a1 48 50 80 00       	mov    0x805048,%eax
  802397:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80239a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80239e:	74 07                	je     8023a7 <insert_sorted_allocList+0x266>
  8023a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a3:	8b 00                	mov    (%eax),%eax
  8023a5:	eb 05                	jmp    8023ac <insert_sorted_allocList+0x26b>
  8023a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8023ac:	a3 48 50 80 00       	mov    %eax,0x805048
  8023b1:	a1 48 50 80 00       	mov    0x805048,%eax
  8023b6:	85 c0                	test   %eax,%eax
  8023b8:	0f 85 3f ff ff ff    	jne    8022fd <insert_sorted_allocList+0x1bc>
  8023be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023c2:	0f 85 35 ff ff ff    	jne    8022fd <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8023c8:	eb 01                	jmp    8023cb <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8023ca:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8023cb:	90                   	nop
  8023cc:	c9                   	leave  
  8023cd:	c3                   	ret    

008023ce <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8023ce:	55                   	push   %ebp
  8023cf:	89 e5                	mov    %esp,%ebp
  8023d1:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8023d4:	a1 38 51 80 00       	mov    0x805138,%eax
  8023d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023dc:	e9 85 01 00 00       	jmp    802566 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8023e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e4:	8b 40 0c             	mov    0xc(%eax),%eax
  8023e7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023ea:	0f 82 6e 01 00 00    	jb     80255e <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8023f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f3:	8b 40 0c             	mov    0xc(%eax),%eax
  8023f6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023f9:	0f 85 8a 00 00 00    	jne    802489 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8023ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802403:	75 17                	jne    80241c <alloc_block_FF+0x4e>
  802405:	83 ec 04             	sub    $0x4,%esp
  802408:	68 b8 42 80 00       	push   $0x8042b8
  80240d:	68 93 00 00 00       	push   $0x93
  802412:	68 0f 42 80 00       	push   $0x80420f
  802417:	e8 8b e0 ff ff       	call   8004a7 <_panic>
  80241c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241f:	8b 00                	mov    (%eax),%eax
  802421:	85 c0                	test   %eax,%eax
  802423:	74 10                	je     802435 <alloc_block_FF+0x67>
  802425:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802428:	8b 00                	mov    (%eax),%eax
  80242a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80242d:	8b 52 04             	mov    0x4(%edx),%edx
  802430:	89 50 04             	mov    %edx,0x4(%eax)
  802433:	eb 0b                	jmp    802440 <alloc_block_FF+0x72>
  802435:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802438:	8b 40 04             	mov    0x4(%eax),%eax
  80243b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802440:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802443:	8b 40 04             	mov    0x4(%eax),%eax
  802446:	85 c0                	test   %eax,%eax
  802448:	74 0f                	je     802459 <alloc_block_FF+0x8b>
  80244a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244d:	8b 40 04             	mov    0x4(%eax),%eax
  802450:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802453:	8b 12                	mov    (%edx),%edx
  802455:	89 10                	mov    %edx,(%eax)
  802457:	eb 0a                	jmp    802463 <alloc_block_FF+0x95>
  802459:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245c:	8b 00                	mov    (%eax),%eax
  80245e:	a3 38 51 80 00       	mov    %eax,0x805138
  802463:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802466:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80246c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802476:	a1 44 51 80 00       	mov    0x805144,%eax
  80247b:	48                   	dec    %eax
  80247c:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802481:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802484:	e9 10 01 00 00       	jmp    802599 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802489:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248c:	8b 40 0c             	mov    0xc(%eax),%eax
  80248f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802492:	0f 86 c6 00 00 00    	jbe    80255e <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802498:	a1 48 51 80 00       	mov    0x805148,%eax
  80249d:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8024a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a3:	8b 50 08             	mov    0x8(%eax),%edx
  8024a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024a9:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8024ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024af:	8b 55 08             	mov    0x8(%ebp),%edx
  8024b2:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8024b5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024b9:	75 17                	jne    8024d2 <alloc_block_FF+0x104>
  8024bb:	83 ec 04             	sub    $0x4,%esp
  8024be:	68 b8 42 80 00       	push   $0x8042b8
  8024c3:	68 9b 00 00 00       	push   $0x9b
  8024c8:	68 0f 42 80 00       	push   $0x80420f
  8024cd:	e8 d5 df ff ff       	call   8004a7 <_panic>
  8024d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024d5:	8b 00                	mov    (%eax),%eax
  8024d7:	85 c0                	test   %eax,%eax
  8024d9:	74 10                	je     8024eb <alloc_block_FF+0x11d>
  8024db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024de:	8b 00                	mov    (%eax),%eax
  8024e0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024e3:	8b 52 04             	mov    0x4(%edx),%edx
  8024e6:	89 50 04             	mov    %edx,0x4(%eax)
  8024e9:	eb 0b                	jmp    8024f6 <alloc_block_FF+0x128>
  8024eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024ee:	8b 40 04             	mov    0x4(%eax),%eax
  8024f1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8024f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024f9:	8b 40 04             	mov    0x4(%eax),%eax
  8024fc:	85 c0                	test   %eax,%eax
  8024fe:	74 0f                	je     80250f <alloc_block_FF+0x141>
  802500:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802503:	8b 40 04             	mov    0x4(%eax),%eax
  802506:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802509:	8b 12                	mov    (%edx),%edx
  80250b:	89 10                	mov    %edx,(%eax)
  80250d:	eb 0a                	jmp    802519 <alloc_block_FF+0x14b>
  80250f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802512:	8b 00                	mov    (%eax),%eax
  802514:	a3 48 51 80 00       	mov    %eax,0x805148
  802519:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80251c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802522:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802525:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80252c:	a1 54 51 80 00       	mov    0x805154,%eax
  802531:	48                   	dec    %eax
  802532:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802537:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253a:	8b 50 08             	mov    0x8(%eax),%edx
  80253d:	8b 45 08             	mov    0x8(%ebp),%eax
  802540:	01 c2                	add    %eax,%edx
  802542:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802545:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802548:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254b:	8b 40 0c             	mov    0xc(%eax),%eax
  80254e:	2b 45 08             	sub    0x8(%ebp),%eax
  802551:	89 c2                	mov    %eax,%edx
  802553:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802556:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802559:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80255c:	eb 3b                	jmp    802599 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80255e:	a1 40 51 80 00       	mov    0x805140,%eax
  802563:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802566:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80256a:	74 07                	je     802573 <alloc_block_FF+0x1a5>
  80256c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256f:	8b 00                	mov    (%eax),%eax
  802571:	eb 05                	jmp    802578 <alloc_block_FF+0x1aa>
  802573:	b8 00 00 00 00       	mov    $0x0,%eax
  802578:	a3 40 51 80 00       	mov    %eax,0x805140
  80257d:	a1 40 51 80 00       	mov    0x805140,%eax
  802582:	85 c0                	test   %eax,%eax
  802584:	0f 85 57 fe ff ff    	jne    8023e1 <alloc_block_FF+0x13>
  80258a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80258e:	0f 85 4d fe ff ff    	jne    8023e1 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802594:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802599:	c9                   	leave  
  80259a:	c3                   	ret    

0080259b <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80259b:	55                   	push   %ebp
  80259c:	89 e5                	mov    %esp,%ebp
  80259e:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8025a1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8025a8:	a1 38 51 80 00       	mov    0x805138,%eax
  8025ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025b0:	e9 df 00 00 00       	jmp    802694 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8025b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b8:	8b 40 0c             	mov    0xc(%eax),%eax
  8025bb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025be:	0f 82 c8 00 00 00    	jb     80268c <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8025c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c7:	8b 40 0c             	mov    0xc(%eax),%eax
  8025ca:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025cd:	0f 85 8a 00 00 00    	jne    80265d <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8025d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025d7:	75 17                	jne    8025f0 <alloc_block_BF+0x55>
  8025d9:	83 ec 04             	sub    $0x4,%esp
  8025dc:	68 b8 42 80 00       	push   $0x8042b8
  8025e1:	68 b7 00 00 00       	push   $0xb7
  8025e6:	68 0f 42 80 00       	push   $0x80420f
  8025eb:	e8 b7 de ff ff       	call   8004a7 <_panic>
  8025f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f3:	8b 00                	mov    (%eax),%eax
  8025f5:	85 c0                	test   %eax,%eax
  8025f7:	74 10                	je     802609 <alloc_block_BF+0x6e>
  8025f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fc:	8b 00                	mov    (%eax),%eax
  8025fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802601:	8b 52 04             	mov    0x4(%edx),%edx
  802604:	89 50 04             	mov    %edx,0x4(%eax)
  802607:	eb 0b                	jmp    802614 <alloc_block_BF+0x79>
  802609:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260c:	8b 40 04             	mov    0x4(%eax),%eax
  80260f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802614:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802617:	8b 40 04             	mov    0x4(%eax),%eax
  80261a:	85 c0                	test   %eax,%eax
  80261c:	74 0f                	je     80262d <alloc_block_BF+0x92>
  80261e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802621:	8b 40 04             	mov    0x4(%eax),%eax
  802624:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802627:	8b 12                	mov    (%edx),%edx
  802629:	89 10                	mov    %edx,(%eax)
  80262b:	eb 0a                	jmp    802637 <alloc_block_BF+0x9c>
  80262d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802630:	8b 00                	mov    (%eax),%eax
  802632:	a3 38 51 80 00       	mov    %eax,0x805138
  802637:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802640:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802643:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80264a:	a1 44 51 80 00       	mov    0x805144,%eax
  80264f:	48                   	dec    %eax
  802650:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802655:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802658:	e9 4d 01 00 00       	jmp    8027aa <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  80265d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802660:	8b 40 0c             	mov    0xc(%eax),%eax
  802663:	3b 45 08             	cmp    0x8(%ebp),%eax
  802666:	76 24                	jbe    80268c <alloc_block_BF+0xf1>
  802668:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266b:	8b 40 0c             	mov    0xc(%eax),%eax
  80266e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802671:	73 19                	jae    80268c <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802673:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  80267a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267d:	8b 40 0c             	mov    0xc(%eax),%eax
  802680:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802683:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802686:	8b 40 08             	mov    0x8(%eax),%eax
  802689:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80268c:	a1 40 51 80 00       	mov    0x805140,%eax
  802691:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802694:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802698:	74 07                	je     8026a1 <alloc_block_BF+0x106>
  80269a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269d:	8b 00                	mov    (%eax),%eax
  80269f:	eb 05                	jmp    8026a6 <alloc_block_BF+0x10b>
  8026a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8026a6:	a3 40 51 80 00       	mov    %eax,0x805140
  8026ab:	a1 40 51 80 00       	mov    0x805140,%eax
  8026b0:	85 c0                	test   %eax,%eax
  8026b2:	0f 85 fd fe ff ff    	jne    8025b5 <alloc_block_BF+0x1a>
  8026b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026bc:	0f 85 f3 fe ff ff    	jne    8025b5 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  8026c2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8026c6:	0f 84 d9 00 00 00    	je     8027a5 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8026cc:	a1 48 51 80 00       	mov    0x805148,%eax
  8026d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8026d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026d7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026da:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8026dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8026e3:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  8026e6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8026ea:	75 17                	jne    802703 <alloc_block_BF+0x168>
  8026ec:	83 ec 04             	sub    $0x4,%esp
  8026ef:	68 b8 42 80 00       	push   $0x8042b8
  8026f4:	68 c7 00 00 00       	push   $0xc7
  8026f9:	68 0f 42 80 00       	push   $0x80420f
  8026fe:	e8 a4 dd ff ff       	call   8004a7 <_panic>
  802703:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802706:	8b 00                	mov    (%eax),%eax
  802708:	85 c0                	test   %eax,%eax
  80270a:	74 10                	je     80271c <alloc_block_BF+0x181>
  80270c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80270f:	8b 00                	mov    (%eax),%eax
  802711:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802714:	8b 52 04             	mov    0x4(%edx),%edx
  802717:	89 50 04             	mov    %edx,0x4(%eax)
  80271a:	eb 0b                	jmp    802727 <alloc_block_BF+0x18c>
  80271c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80271f:	8b 40 04             	mov    0x4(%eax),%eax
  802722:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802727:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80272a:	8b 40 04             	mov    0x4(%eax),%eax
  80272d:	85 c0                	test   %eax,%eax
  80272f:	74 0f                	je     802740 <alloc_block_BF+0x1a5>
  802731:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802734:	8b 40 04             	mov    0x4(%eax),%eax
  802737:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80273a:	8b 12                	mov    (%edx),%edx
  80273c:	89 10                	mov    %edx,(%eax)
  80273e:	eb 0a                	jmp    80274a <alloc_block_BF+0x1af>
  802740:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802743:	8b 00                	mov    (%eax),%eax
  802745:	a3 48 51 80 00       	mov    %eax,0x805148
  80274a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80274d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802753:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802756:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80275d:	a1 54 51 80 00       	mov    0x805154,%eax
  802762:	48                   	dec    %eax
  802763:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802768:	83 ec 08             	sub    $0x8,%esp
  80276b:	ff 75 ec             	pushl  -0x14(%ebp)
  80276e:	68 38 51 80 00       	push   $0x805138
  802773:	e8 71 f9 ff ff       	call   8020e9 <find_block>
  802778:	83 c4 10             	add    $0x10,%esp
  80277b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  80277e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802781:	8b 50 08             	mov    0x8(%eax),%edx
  802784:	8b 45 08             	mov    0x8(%ebp),%eax
  802787:	01 c2                	add    %eax,%edx
  802789:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80278c:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  80278f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802792:	8b 40 0c             	mov    0xc(%eax),%eax
  802795:	2b 45 08             	sub    0x8(%ebp),%eax
  802798:	89 c2                	mov    %eax,%edx
  80279a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80279d:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8027a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027a3:	eb 05                	jmp    8027aa <alloc_block_BF+0x20f>
	}
	return NULL;
  8027a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027aa:	c9                   	leave  
  8027ab:	c3                   	ret    

008027ac <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8027ac:	55                   	push   %ebp
  8027ad:	89 e5                	mov    %esp,%ebp
  8027af:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  8027b2:	a1 28 50 80 00       	mov    0x805028,%eax
  8027b7:	85 c0                	test   %eax,%eax
  8027b9:	0f 85 de 01 00 00    	jne    80299d <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8027bf:	a1 38 51 80 00       	mov    0x805138,%eax
  8027c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027c7:	e9 9e 01 00 00       	jmp    80296a <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8027cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cf:	8b 40 0c             	mov    0xc(%eax),%eax
  8027d2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027d5:	0f 82 87 01 00 00    	jb     802962 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  8027db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027de:	8b 40 0c             	mov    0xc(%eax),%eax
  8027e1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027e4:	0f 85 95 00 00 00    	jne    80287f <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  8027ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027ee:	75 17                	jne    802807 <alloc_block_NF+0x5b>
  8027f0:	83 ec 04             	sub    $0x4,%esp
  8027f3:	68 b8 42 80 00       	push   $0x8042b8
  8027f8:	68 e0 00 00 00       	push   $0xe0
  8027fd:	68 0f 42 80 00       	push   $0x80420f
  802802:	e8 a0 dc ff ff       	call   8004a7 <_panic>
  802807:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280a:	8b 00                	mov    (%eax),%eax
  80280c:	85 c0                	test   %eax,%eax
  80280e:	74 10                	je     802820 <alloc_block_NF+0x74>
  802810:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802813:	8b 00                	mov    (%eax),%eax
  802815:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802818:	8b 52 04             	mov    0x4(%edx),%edx
  80281b:	89 50 04             	mov    %edx,0x4(%eax)
  80281e:	eb 0b                	jmp    80282b <alloc_block_NF+0x7f>
  802820:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802823:	8b 40 04             	mov    0x4(%eax),%eax
  802826:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80282b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282e:	8b 40 04             	mov    0x4(%eax),%eax
  802831:	85 c0                	test   %eax,%eax
  802833:	74 0f                	je     802844 <alloc_block_NF+0x98>
  802835:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802838:	8b 40 04             	mov    0x4(%eax),%eax
  80283b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80283e:	8b 12                	mov    (%edx),%edx
  802840:	89 10                	mov    %edx,(%eax)
  802842:	eb 0a                	jmp    80284e <alloc_block_NF+0xa2>
  802844:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802847:	8b 00                	mov    (%eax),%eax
  802849:	a3 38 51 80 00       	mov    %eax,0x805138
  80284e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802851:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802857:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802861:	a1 44 51 80 00       	mov    0x805144,%eax
  802866:	48                   	dec    %eax
  802867:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  80286c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286f:	8b 40 08             	mov    0x8(%eax),%eax
  802872:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802877:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287a:	e9 f8 04 00 00       	jmp    802d77 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  80287f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802882:	8b 40 0c             	mov    0xc(%eax),%eax
  802885:	3b 45 08             	cmp    0x8(%ebp),%eax
  802888:	0f 86 d4 00 00 00    	jbe    802962 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80288e:	a1 48 51 80 00       	mov    0x805148,%eax
  802893:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802896:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802899:	8b 50 08             	mov    0x8(%eax),%edx
  80289c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80289f:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8028a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8028a8:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8028ab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028af:	75 17                	jne    8028c8 <alloc_block_NF+0x11c>
  8028b1:	83 ec 04             	sub    $0x4,%esp
  8028b4:	68 b8 42 80 00       	push   $0x8042b8
  8028b9:	68 e9 00 00 00       	push   $0xe9
  8028be:	68 0f 42 80 00       	push   $0x80420f
  8028c3:	e8 df db ff ff       	call   8004a7 <_panic>
  8028c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028cb:	8b 00                	mov    (%eax),%eax
  8028cd:	85 c0                	test   %eax,%eax
  8028cf:	74 10                	je     8028e1 <alloc_block_NF+0x135>
  8028d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028d4:	8b 00                	mov    (%eax),%eax
  8028d6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028d9:	8b 52 04             	mov    0x4(%edx),%edx
  8028dc:	89 50 04             	mov    %edx,0x4(%eax)
  8028df:	eb 0b                	jmp    8028ec <alloc_block_NF+0x140>
  8028e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e4:	8b 40 04             	mov    0x4(%eax),%eax
  8028e7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8028ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ef:	8b 40 04             	mov    0x4(%eax),%eax
  8028f2:	85 c0                	test   %eax,%eax
  8028f4:	74 0f                	je     802905 <alloc_block_NF+0x159>
  8028f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028f9:	8b 40 04             	mov    0x4(%eax),%eax
  8028fc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028ff:	8b 12                	mov    (%edx),%edx
  802901:	89 10                	mov    %edx,(%eax)
  802903:	eb 0a                	jmp    80290f <alloc_block_NF+0x163>
  802905:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802908:	8b 00                	mov    (%eax),%eax
  80290a:	a3 48 51 80 00       	mov    %eax,0x805148
  80290f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802912:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802918:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80291b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802922:	a1 54 51 80 00       	mov    0x805154,%eax
  802927:	48                   	dec    %eax
  802928:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  80292d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802930:	8b 40 08             	mov    0x8(%eax),%eax
  802933:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802938:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293b:	8b 50 08             	mov    0x8(%eax),%edx
  80293e:	8b 45 08             	mov    0x8(%ebp),%eax
  802941:	01 c2                	add    %eax,%edx
  802943:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802946:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802949:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294c:	8b 40 0c             	mov    0xc(%eax),%eax
  80294f:	2b 45 08             	sub    0x8(%ebp),%eax
  802952:	89 c2                	mov    %eax,%edx
  802954:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802957:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  80295a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80295d:	e9 15 04 00 00       	jmp    802d77 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802962:	a1 40 51 80 00       	mov    0x805140,%eax
  802967:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80296a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80296e:	74 07                	je     802977 <alloc_block_NF+0x1cb>
  802970:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802973:	8b 00                	mov    (%eax),%eax
  802975:	eb 05                	jmp    80297c <alloc_block_NF+0x1d0>
  802977:	b8 00 00 00 00       	mov    $0x0,%eax
  80297c:	a3 40 51 80 00       	mov    %eax,0x805140
  802981:	a1 40 51 80 00       	mov    0x805140,%eax
  802986:	85 c0                	test   %eax,%eax
  802988:	0f 85 3e fe ff ff    	jne    8027cc <alloc_block_NF+0x20>
  80298e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802992:	0f 85 34 fe ff ff    	jne    8027cc <alloc_block_NF+0x20>
  802998:	e9 d5 03 00 00       	jmp    802d72 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  80299d:	a1 38 51 80 00       	mov    0x805138,%eax
  8029a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029a5:	e9 b1 01 00 00       	jmp    802b5b <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  8029aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ad:	8b 50 08             	mov    0x8(%eax),%edx
  8029b0:	a1 28 50 80 00       	mov    0x805028,%eax
  8029b5:	39 c2                	cmp    %eax,%edx
  8029b7:	0f 82 96 01 00 00    	jb     802b53 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  8029bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c0:	8b 40 0c             	mov    0xc(%eax),%eax
  8029c3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029c6:	0f 82 87 01 00 00    	jb     802b53 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  8029cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029cf:	8b 40 0c             	mov    0xc(%eax),%eax
  8029d2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029d5:	0f 85 95 00 00 00    	jne    802a70 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8029db:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029df:	75 17                	jne    8029f8 <alloc_block_NF+0x24c>
  8029e1:	83 ec 04             	sub    $0x4,%esp
  8029e4:	68 b8 42 80 00       	push   $0x8042b8
  8029e9:	68 fc 00 00 00       	push   $0xfc
  8029ee:	68 0f 42 80 00       	push   $0x80420f
  8029f3:	e8 af da ff ff       	call   8004a7 <_panic>
  8029f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fb:	8b 00                	mov    (%eax),%eax
  8029fd:	85 c0                	test   %eax,%eax
  8029ff:	74 10                	je     802a11 <alloc_block_NF+0x265>
  802a01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a04:	8b 00                	mov    (%eax),%eax
  802a06:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a09:	8b 52 04             	mov    0x4(%edx),%edx
  802a0c:	89 50 04             	mov    %edx,0x4(%eax)
  802a0f:	eb 0b                	jmp    802a1c <alloc_block_NF+0x270>
  802a11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a14:	8b 40 04             	mov    0x4(%eax),%eax
  802a17:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1f:	8b 40 04             	mov    0x4(%eax),%eax
  802a22:	85 c0                	test   %eax,%eax
  802a24:	74 0f                	je     802a35 <alloc_block_NF+0x289>
  802a26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a29:	8b 40 04             	mov    0x4(%eax),%eax
  802a2c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a2f:	8b 12                	mov    (%edx),%edx
  802a31:	89 10                	mov    %edx,(%eax)
  802a33:	eb 0a                	jmp    802a3f <alloc_block_NF+0x293>
  802a35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a38:	8b 00                	mov    (%eax),%eax
  802a3a:	a3 38 51 80 00       	mov    %eax,0x805138
  802a3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a42:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a52:	a1 44 51 80 00       	mov    0x805144,%eax
  802a57:	48                   	dec    %eax
  802a58:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802a5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a60:	8b 40 08             	mov    0x8(%eax),%eax
  802a63:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802a68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6b:	e9 07 03 00 00       	jmp    802d77 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802a70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a73:	8b 40 0c             	mov    0xc(%eax),%eax
  802a76:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a79:	0f 86 d4 00 00 00    	jbe    802b53 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802a7f:	a1 48 51 80 00       	mov    0x805148,%eax
  802a84:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802a87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8a:	8b 50 08             	mov    0x8(%eax),%edx
  802a8d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a90:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802a93:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a96:	8b 55 08             	mov    0x8(%ebp),%edx
  802a99:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802a9c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802aa0:	75 17                	jne    802ab9 <alloc_block_NF+0x30d>
  802aa2:	83 ec 04             	sub    $0x4,%esp
  802aa5:	68 b8 42 80 00       	push   $0x8042b8
  802aaa:	68 04 01 00 00       	push   $0x104
  802aaf:	68 0f 42 80 00       	push   $0x80420f
  802ab4:	e8 ee d9 ff ff       	call   8004a7 <_panic>
  802ab9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802abc:	8b 00                	mov    (%eax),%eax
  802abe:	85 c0                	test   %eax,%eax
  802ac0:	74 10                	je     802ad2 <alloc_block_NF+0x326>
  802ac2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ac5:	8b 00                	mov    (%eax),%eax
  802ac7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802aca:	8b 52 04             	mov    0x4(%edx),%edx
  802acd:	89 50 04             	mov    %edx,0x4(%eax)
  802ad0:	eb 0b                	jmp    802add <alloc_block_NF+0x331>
  802ad2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ad5:	8b 40 04             	mov    0x4(%eax),%eax
  802ad8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802add:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ae0:	8b 40 04             	mov    0x4(%eax),%eax
  802ae3:	85 c0                	test   %eax,%eax
  802ae5:	74 0f                	je     802af6 <alloc_block_NF+0x34a>
  802ae7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802aea:	8b 40 04             	mov    0x4(%eax),%eax
  802aed:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802af0:	8b 12                	mov    (%edx),%edx
  802af2:	89 10                	mov    %edx,(%eax)
  802af4:	eb 0a                	jmp    802b00 <alloc_block_NF+0x354>
  802af6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802af9:	8b 00                	mov    (%eax),%eax
  802afb:	a3 48 51 80 00       	mov    %eax,0x805148
  802b00:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b03:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b09:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b0c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b13:	a1 54 51 80 00       	mov    0x805154,%eax
  802b18:	48                   	dec    %eax
  802b19:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802b1e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b21:	8b 40 08             	mov    0x8(%eax),%eax
  802b24:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802b29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2c:	8b 50 08             	mov    0x8(%eax),%edx
  802b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b32:	01 c2                	add    %eax,%edx
  802b34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b37:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802b3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3d:	8b 40 0c             	mov    0xc(%eax),%eax
  802b40:	2b 45 08             	sub    0x8(%ebp),%eax
  802b43:	89 c2                	mov    %eax,%edx
  802b45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b48:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802b4b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b4e:	e9 24 02 00 00       	jmp    802d77 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b53:	a1 40 51 80 00       	mov    0x805140,%eax
  802b58:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b5b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b5f:	74 07                	je     802b68 <alloc_block_NF+0x3bc>
  802b61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b64:	8b 00                	mov    (%eax),%eax
  802b66:	eb 05                	jmp    802b6d <alloc_block_NF+0x3c1>
  802b68:	b8 00 00 00 00       	mov    $0x0,%eax
  802b6d:	a3 40 51 80 00       	mov    %eax,0x805140
  802b72:	a1 40 51 80 00       	mov    0x805140,%eax
  802b77:	85 c0                	test   %eax,%eax
  802b79:	0f 85 2b fe ff ff    	jne    8029aa <alloc_block_NF+0x1fe>
  802b7f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b83:	0f 85 21 fe ff ff    	jne    8029aa <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b89:	a1 38 51 80 00       	mov    0x805138,%eax
  802b8e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b91:	e9 ae 01 00 00       	jmp    802d44 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802b96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b99:	8b 50 08             	mov    0x8(%eax),%edx
  802b9c:	a1 28 50 80 00       	mov    0x805028,%eax
  802ba1:	39 c2                	cmp    %eax,%edx
  802ba3:	0f 83 93 01 00 00    	jae    802d3c <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802ba9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bac:	8b 40 0c             	mov    0xc(%eax),%eax
  802baf:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bb2:	0f 82 84 01 00 00    	jb     802d3c <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802bb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bbb:	8b 40 0c             	mov    0xc(%eax),%eax
  802bbe:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bc1:	0f 85 95 00 00 00    	jne    802c5c <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802bc7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bcb:	75 17                	jne    802be4 <alloc_block_NF+0x438>
  802bcd:	83 ec 04             	sub    $0x4,%esp
  802bd0:	68 b8 42 80 00       	push   $0x8042b8
  802bd5:	68 14 01 00 00       	push   $0x114
  802bda:	68 0f 42 80 00       	push   $0x80420f
  802bdf:	e8 c3 d8 ff ff       	call   8004a7 <_panic>
  802be4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be7:	8b 00                	mov    (%eax),%eax
  802be9:	85 c0                	test   %eax,%eax
  802beb:	74 10                	je     802bfd <alloc_block_NF+0x451>
  802bed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf0:	8b 00                	mov    (%eax),%eax
  802bf2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bf5:	8b 52 04             	mov    0x4(%edx),%edx
  802bf8:	89 50 04             	mov    %edx,0x4(%eax)
  802bfb:	eb 0b                	jmp    802c08 <alloc_block_NF+0x45c>
  802bfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c00:	8b 40 04             	mov    0x4(%eax),%eax
  802c03:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0b:	8b 40 04             	mov    0x4(%eax),%eax
  802c0e:	85 c0                	test   %eax,%eax
  802c10:	74 0f                	je     802c21 <alloc_block_NF+0x475>
  802c12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c15:	8b 40 04             	mov    0x4(%eax),%eax
  802c18:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c1b:	8b 12                	mov    (%edx),%edx
  802c1d:	89 10                	mov    %edx,(%eax)
  802c1f:	eb 0a                	jmp    802c2b <alloc_block_NF+0x47f>
  802c21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c24:	8b 00                	mov    (%eax),%eax
  802c26:	a3 38 51 80 00       	mov    %eax,0x805138
  802c2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c37:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c3e:	a1 44 51 80 00       	mov    0x805144,%eax
  802c43:	48                   	dec    %eax
  802c44:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802c49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4c:	8b 40 08             	mov    0x8(%eax),%eax
  802c4f:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802c54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c57:	e9 1b 01 00 00       	jmp    802d77 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802c5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5f:	8b 40 0c             	mov    0xc(%eax),%eax
  802c62:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c65:	0f 86 d1 00 00 00    	jbe    802d3c <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802c6b:	a1 48 51 80 00       	mov    0x805148,%eax
  802c70:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802c73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c76:	8b 50 08             	mov    0x8(%eax),%edx
  802c79:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c7c:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802c7f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c82:	8b 55 08             	mov    0x8(%ebp),%edx
  802c85:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802c88:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c8c:	75 17                	jne    802ca5 <alloc_block_NF+0x4f9>
  802c8e:	83 ec 04             	sub    $0x4,%esp
  802c91:	68 b8 42 80 00       	push   $0x8042b8
  802c96:	68 1c 01 00 00       	push   $0x11c
  802c9b:	68 0f 42 80 00       	push   $0x80420f
  802ca0:	e8 02 d8 ff ff       	call   8004a7 <_panic>
  802ca5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ca8:	8b 00                	mov    (%eax),%eax
  802caa:	85 c0                	test   %eax,%eax
  802cac:	74 10                	je     802cbe <alloc_block_NF+0x512>
  802cae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cb1:	8b 00                	mov    (%eax),%eax
  802cb3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802cb6:	8b 52 04             	mov    0x4(%edx),%edx
  802cb9:	89 50 04             	mov    %edx,0x4(%eax)
  802cbc:	eb 0b                	jmp    802cc9 <alloc_block_NF+0x51d>
  802cbe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cc1:	8b 40 04             	mov    0x4(%eax),%eax
  802cc4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802cc9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ccc:	8b 40 04             	mov    0x4(%eax),%eax
  802ccf:	85 c0                	test   %eax,%eax
  802cd1:	74 0f                	je     802ce2 <alloc_block_NF+0x536>
  802cd3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cd6:	8b 40 04             	mov    0x4(%eax),%eax
  802cd9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802cdc:	8b 12                	mov    (%edx),%edx
  802cde:	89 10                	mov    %edx,(%eax)
  802ce0:	eb 0a                	jmp    802cec <alloc_block_NF+0x540>
  802ce2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ce5:	8b 00                	mov    (%eax),%eax
  802ce7:	a3 48 51 80 00       	mov    %eax,0x805148
  802cec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cf5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cf8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cff:	a1 54 51 80 00       	mov    0x805154,%eax
  802d04:	48                   	dec    %eax
  802d05:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802d0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d0d:	8b 40 08             	mov    0x8(%eax),%eax
  802d10:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802d15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d18:	8b 50 08             	mov    0x8(%eax),%edx
  802d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1e:	01 c2                	add    %eax,%edx
  802d20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d23:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802d26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d29:	8b 40 0c             	mov    0xc(%eax),%eax
  802d2c:	2b 45 08             	sub    0x8(%ebp),%eax
  802d2f:	89 c2                	mov    %eax,%edx
  802d31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d34:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802d37:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d3a:	eb 3b                	jmp    802d77 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802d3c:	a1 40 51 80 00       	mov    0x805140,%eax
  802d41:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d44:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d48:	74 07                	je     802d51 <alloc_block_NF+0x5a5>
  802d4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4d:	8b 00                	mov    (%eax),%eax
  802d4f:	eb 05                	jmp    802d56 <alloc_block_NF+0x5aa>
  802d51:	b8 00 00 00 00       	mov    $0x0,%eax
  802d56:	a3 40 51 80 00       	mov    %eax,0x805140
  802d5b:	a1 40 51 80 00       	mov    0x805140,%eax
  802d60:	85 c0                	test   %eax,%eax
  802d62:	0f 85 2e fe ff ff    	jne    802b96 <alloc_block_NF+0x3ea>
  802d68:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d6c:	0f 85 24 fe ff ff    	jne    802b96 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802d72:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d77:	c9                   	leave  
  802d78:	c3                   	ret    

00802d79 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802d79:	55                   	push   %ebp
  802d7a:	89 e5                	mov    %esp,%ebp
  802d7c:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802d7f:	a1 38 51 80 00       	mov    0x805138,%eax
  802d84:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802d87:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802d8c:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802d8f:	a1 38 51 80 00       	mov    0x805138,%eax
  802d94:	85 c0                	test   %eax,%eax
  802d96:	74 14                	je     802dac <insert_sorted_with_merge_freeList+0x33>
  802d98:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9b:	8b 50 08             	mov    0x8(%eax),%edx
  802d9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802da1:	8b 40 08             	mov    0x8(%eax),%eax
  802da4:	39 c2                	cmp    %eax,%edx
  802da6:	0f 87 9b 01 00 00    	ja     802f47 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802dac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802db0:	75 17                	jne    802dc9 <insert_sorted_with_merge_freeList+0x50>
  802db2:	83 ec 04             	sub    $0x4,%esp
  802db5:	68 ec 41 80 00       	push   $0x8041ec
  802dba:	68 38 01 00 00       	push   $0x138
  802dbf:	68 0f 42 80 00       	push   $0x80420f
  802dc4:	e8 de d6 ff ff       	call   8004a7 <_panic>
  802dc9:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802dcf:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd2:	89 10                	mov    %edx,(%eax)
  802dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd7:	8b 00                	mov    (%eax),%eax
  802dd9:	85 c0                	test   %eax,%eax
  802ddb:	74 0d                	je     802dea <insert_sorted_with_merge_freeList+0x71>
  802ddd:	a1 38 51 80 00       	mov    0x805138,%eax
  802de2:	8b 55 08             	mov    0x8(%ebp),%edx
  802de5:	89 50 04             	mov    %edx,0x4(%eax)
  802de8:	eb 08                	jmp    802df2 <insert_sorted_with_merge_freeList+0x79>
  802dea:	8b 45 08             	mov    0x8(%ebp),%eax
  802ded:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802df2:	8b 45 08             	mov    0x8(%ebp),%eax
  802df5:	a3 38 51 80 00       	mov    %eax,0x805138
  802dfa:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e04:	a1 44 51 80 00       	mov    0x805144,%eax
  802e09:	40                   	inc    %eax
  802e0a:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802e0f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e13:	0f 84 a8 06 00 00    	je     8034c1 <insert_sorted_with_merge_freeList+0x748>
  802e19:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1c:	8b 50 08             	mov    0x8(%eax),%edx
  802e1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e22:	8b 40 0c             	mov    0xc(%eax),%eax
  802e25:	01 c2                	add    %eax,%edx
  802e27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e2a:	8b 40 08             	mov    0x8(%eax),%eax
  802e2d:	39 c2                	cmp    %eax,%edx
  802e2f:	0f 85 8c 06 00 00    	jne    8034c1 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802e35:	8b 45 08             	mov    0x8(%ebp),%eax
  802e38:	8b 50 0c             	mov    0xc(%eax),%edx
  802e3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e3e:	8b 40 0c             	mov    0xc(%eax),%eax
  802e41:	01 c2                	add    %eax,%edx
  802e43:	8b 45 08             	mov    0x8(%ebp),%eax
  802e46:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802e49:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e4d:	75 17                	jne    802e66 <insert_sorted_with_merge_freeList+0xed>
  802e4f:	83 ec 04             	sub    $0x4,%esp
  802e52:	68 b8 42 80 00       	push   $0x8042b8
  802e57:	68 3c 01 00 00       	push   $0x13c
  802e5c:	68 0f 42 80 00       	push   $0x80420f
  802e61:	e8 41 d6 ff ff       	call   8004a7 <_panic>
  802e66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e69:	8b 00                	mov    (%eax),%eax
  802e6b:	85 c0                	test   %eax,%eax
  802e6d:	74 10                	je     802e7f <insert_sorted_with_merge_freeList+0x106>
  802e6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e72:	8b 00                	mov    (%eax),%eax
  802e74:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e77:	8b 52 04             	mov    0x4(%edx),%edx
  802e7a:	89 50 04             	mov    %edx,0x4(%eax)
  802e7d:	eb 0b                	jmp    802e8a <insert_sorted_with_merge_freeList+0x111>
  802e7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e82:	8b 40 04             	mov    0x4(%eax),%eax
  802e85:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e8d:	8b 40 04             	mov    0x4(%eax),%eax
  802e90:	85 c0                	test   %eax,%eax
  802e92:	74 0f                	je     802ea3 <insert_sorted_with_merge_freeList+0x12a>
  802e94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e97:	8b 40 04             	mov    0x4(%eax),%eax
  802e9a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e9d:	8b 12                	mov    (%edx),%edx
  802e9f:	89 10                	mov    %edx,(%eax)
  802ea1:	eb 0a                	jmp    802ead <insert_sorted_with_merge_freeList+0x134>
  802ea3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ea6:	8b 00                	mov    (%eax),%eax
  802ea8:	a3 38 51 80 00       	mov    %eax,0x805138
  802ead:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eb0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802eb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eb9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ec0:	a1 44 51 80 00       	mov    0x805144,%eax
  802ec5:	48                   	dec    %eax
  802ec6:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802ecb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ece:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802ed5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ed8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802edf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ee3:	75 17                	jne    802efc <insert_sorted_with_merge_freeList+0x183>
  802ee5:	83 ec 04             	sub    $0x4,%esp
  802ee8:	68 ec 41 80 00       	push   $0x8041ec
  802eed:	68 3f 01 00 00       	push   $0x13f
  802ef2:	68 0f 42 80 00       	push   $0x80420f
  802ef7:	e8 ab d5 ff ff       	call   8004a7 <_panic>
  802efc:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802f02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f05:	89 10                	mov    %edx,(%eax)
  802f07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f0a:	8b 00                	mov    (%eax),%eax
  802f0c:	85 c0                	test   %eax,%eax
  802f0e:	74 0d                	je     802f1d <insert_sorted_with_merge_freeList+0x1a4>
  802f10:	a1 48 51 80 00       	mov    0x805148,%eax
  802f15:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f18:	89 50 04             	mov    %edx,0x4(%eax)
  802f1b:	eb 08                	jmp    802f25 <insert_sorted_with_merge_freeList+0x1ac>
  802f1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f20:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f28:	a3 48 51 80 00       	mov    %eax,0x805148
  802f2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f30:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f37:	a1 54 51 80 00       	mov    0x805154,%eax
  802f3c:	40                   	inc    %eax
  802f3d:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802f42:	e9 7a 05 00 00       	jmp    8034c1 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802f47:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4a:	8b 50 08             	mov    0x8(%eax),%edx
  802f4d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f50:	8b 40 08             	mov    0x8(%eax),%eax
  802f53:	39 c2                	cmp    %eax,%edx
  802f55:	0f 82 14 01 00 00    	jb     80306f <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802f5b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f5e:	8b 50 08             	mov    0x8(%eax),%edx
  802f61:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f64:	8b 40 0c             	mov    0xc(%eax),%eax
  802f67:	01 c2                	add    %eax,%edx
  802f69:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6c:	8b 40 08             	mov    0x8(%eax),%eax
  802f6f:	39 c2                	cmp    %eax,%edx
  802f71:	0f 85 90 00 00 00    	jne    803007 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802f77:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f7a:	8b 50 0c             	mov    0xc(%eax),%edx
  802f7d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f80:	8b 40 0c             	mov    0xc(%eax),%eax
  802f83:	01 c2                	add    %eax,%edx
  802f85:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f88:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802f8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802f95:	8b 45 08             	mov    0x8(%ebp),%eax
  802f98:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802f9f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fa3:	75 17                	jne    802fbc <insert_sorted_with_merge_freeList+0x243>
  802fa5:	83 ec 04             	sub    $0x4,%esp
  802fa8:	68 ec 41 80 00       	push   $0x8041ec
  802fad:	68 49 01 00 00       	push   $0x149
  802fb2:	68 0f 42 80 00       	push   $0x80420f
  802fb7:	e8 eb d4 ff ff       	call   8004a7 <_panic>
  802fbc:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802fc2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc5:	89 10                	mov    %edx,(%eax)
  802fc7:	8b 45 08             	mov    0x8(%ebp),%eax
  802fca:	8b 00                	mov    (%eax),%eax
  802fcc:	85 c0                	test   %eax,%eax
  802fce:	74 0d                	je     802fdd <insert_sorted_with_merge_freeList+0x264>
  802fd0:	a1 48 51 80 00       	mov    0x805148,%eax
  802fd5:	8b 55 08             	mov    0x8(%ebp),%edx
  802fd8:	89 50 04             	mov    %edx,0x4(%eax)
  802fdb:	eb 08                	jmp    802fe5 <insert_sorted_with_merge_freeList+0x26c>
  802fdd:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe8:	a3 48 51 80 00       	mov    %eax,0x805148
  802fed:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ff7:	a1 54 51 80 00       	mov    0x805154,%eax
  802ffc:	40                   	inc    %eax
  802ffd:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803002:	e9 bb 04 00 00       	jmp    8034c2 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803007:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80300b:	75 17                	jne    803024 <insert_sorted_with_merge_freeList+0x2ab>
  80300d:	83 ec 04             	sub    $0x4,%esp
  803010:	68 60 42 80 00       	push   $0x804260
  803015:	68 4c 01 00 00       	push   $0x14c
  80301a:	68 0f 42 80 00       	push   $0x80420f
  80301f:	e8 83 d4 ff ff       	call   8004a7 <_panic>
  803024:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  80302a:	8b 45 08             	mov    0x8(%ebp),%eax
  80302d:	89 50 04             	mov    %edx,0x4(%eax)
  803030:	8b 45 08             	mov    0x8(%ebp),%eax
  803033:	8b 40 04             	mov    0x4(%eax),%eax
  803036:	85 c0                	test   %eax,%eax
  803038:	74 0c                	je     803046 <insert_sorted_with_merge_freeList+0x2cd>
  80303a:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80303f:	8b 55 08             	mov    0x8(%ebp),%edx
  803042:	89 10                	mov    %edx,(%eax)
  803044:	eb 08                	jmp    80304e <insert_sorted_with_merge_freeList+0x2d5>
  803046:	8b 45 08             	mov    0x8(%ebp),%eax
  803049:	a3 38 51 80 00       	mov    %eax,0x805138
  80304e:	8b 45 08             	mov    0x8(%ebp),%eax
  803051:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803056:	8b 45 08             	mov    0x8(%ebp),%eax
  803059:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80305f:	a1 44 51 80 00       	mov    0x805144,%eax
  803064:	40                   	inc    %eax
  803065:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80306a:	e9 53 04 00 00       	jmp    8034c2 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80306f:	a1 38 51 80 00       	mov    0x805138,%eax
  803074:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803077:	e9 15 04 00 00       	jmp    803491 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  80307c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80307f:	8b 00                	mov    (%eax),%eax
  803081:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803084:	8b 45 08             	mov    0x8(%ebp),%eax
  803087:	8b 50 08             	mov    0x8(%eax),%edx
  80308a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80308d:	8b 40 08             	mov    0x8(%eax),%eax
  803090:	39 c2                	cmp    %eax,%edx
  803092:	0f 86 f1 03 00 00    	jbe    803489 <insert_sorted_with_merge_freeList+0x710>
  803098:	8b 45 08             	mov    0x8(%ebp),%eax
  80309b:	8b 50 08             	mov    0x8(%eax),%edx
  80309e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030a1:	8b 40 08             	mov    0x8(%eax),%eax
  8030a4:	39 c2                	cmp    %eax,%edx
  8030a6:	0f 83 dd 03 00 00    	jae    803489 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  8030ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030af:	8b 50 08             	mov    0x8(%eax),%edx
  8030b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b5:	8b 40 0c             	mov    0xc(%eax),%eax
  8030b8:	01 c2                	add    %eax,%edx
  8030ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8030bd:	8b 40 08             	mov    0x8(%eax),%eax
  8030c0:	39 c2                	cmp    %eax,%edx
  8030c2:	0f 85 b9 01 00 00    	jne    803281 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8030c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030cb:	8b 50 08             	mov    0x8(%eax),%edx
  8030ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d1:	8b 40 0c             	mov    0xc(%eax),%eax
  8030d4:	01 c2                	add    %eax,%edx
  8030d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030d9:	8b 40 08             	mov    0x8(%eax),%eax
  8030dc:	39 c2                	cmp    %eax,%edx
  8030de:	0f 85 0d 01 00 00    	jne    8031f1 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  8030e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e7:	8b 50 0c             	mov    0xc(%eax),%edx
  8030ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ed:	8b 40 0c             	mov    0xc(%eax),%eax
  8030f0:	01 c2                	add    %eax,%edx
  8030f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f5:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8030f8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030fc:	75 17                	jne    803115 <insert_sorted_with_merge_freeList+0x39c>
  8030fe:	83 ec 04             	sub    $0x4,%esp
  803101:	68 b8 42 80 00       	push   $0x8042b8
  803106:	68 5c 01 00 00       	push   $0x15c
  80310b:	68 0f 42 80 00       	push   $0x80420f
  803110:	e8 92 d3 ff ff       	call   8004a7 <_panic>
  803115:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803118:	8b 00                	mov    (%eax),%eax
  80311a:	85 c0                	test   %eax,%eax
  80311c:	74 10                	je     80312e <insert_sorted_with_merge_freeList+0x3b5>
  80311e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803121:	8b 00                	mov    (%eax),%eax
  803123:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803126:	8b 52 04             	mov    0x4(%edx),%edx
  803129:	89 50 04             	mov    %edx,0x4(%eax)
  80312c:	eb 0b                	jmp    803139 <insert_sorted_with_merge_freeList+0x3c0>
  80312e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803131:	8b 40 04             	mov    0x4(%eax),%eax
  803134:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803139:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80313c:	8b 40 04             	mov    0x4(%eax),%eax
  80313f:	85 c0                	test   %eax,%eax
  803141:	74 0f                	je     803152 <insert_sorted_with_merge_freeList+0x3d9>
  803143:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803146:	8b 40 04             	mov    0x4(%eax),%eax
  803149:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80314c:	8b 12                	mov    (%edx),%edx
  80314e:	89 10                	mov    %edx,(%eax)
  803150:	eb 0a                	jmp    80315c <insert_sorted_with_merge_freeList+0x3e3>
  803152:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803155:	8b 00                	mov    (%eax),%eax
  803157:	a3 38 51 80 00       	mov    %eax,0x805138
  80315c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80315f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803165:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803168:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80316f:	a1 44 51 80 00       	mov    0x805144,%eax
  803174:	48                   	dec    %eax
  803175:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  80317a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80317d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803184:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803187:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80318e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803192:	75 17                	jne    8031ab <insert_sorted_with_merge_freeList+0x432>
  803194:	83 ec 04             	sub    $0x4,%esp
  803197:	68 ec 41 80 00       	push   $0x8041ec
  80319c:	68 5f 01 00 00       	push   $0x15f
  8031a1:	68 0f 42 80 00       	push   $0x80420f
  8031a6:	e8 fc d2 ff ff       	call   8004a7 <_panic>
  8031ab:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8031b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031b4:	89 10                	mov    %edx,(%eax)
  8031b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031b9:	8b 00                	mov    (%eax),%eax
  8031bb:	85 c0                	test   %eax,%eax
  8031bd:	74 0d                	je     8031cc <insert_sorted_with_merge_freeList+0x453>
  8031bf:	a1 48 51 80 00       	mov    0x805148,%eax
  8031c4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031c7:	89 50 04             	mov    %edx,0x4(%eax)
  8031ca:	eb 08                	jmp    8031d4 <insert_sorted_with_merge_freeList+0x45b>
  8031cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031cf:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d7:	a3 48 51 80 00       	mov    %eax,0x805148
  8031dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031df:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031e6:	a1 54 51 80 00       	mov    0x805154,%eax
  8031eb:	40                   	inc    %eax
  8031ec:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  8031f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f4:	8b 50 0c             	mov    0xc(%eax),%edx
  8031f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031fa:	8b 40 0c             	mov    0xc(%eax),%eax
  8031fd:	01 c2                	add    %eax,%edx
  8031ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803202:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803205:	8b 45 08             	mov    0x8(%ebp),%eax
  803208:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  80320f:	8b 45 08             	mov    0x8(%ebp),%eax
  803212:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803219:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80321d:	75 17                	jne    803236 <insert_sorted_with_merge_freeList+0x4bd>
  80321f:	83 ec 04             	sub    $0x4,%esp
  803222:	68 ec 41 80 00       	push   $0x8041ec
  803227:	68 64 01 00 00       	push   $0x164
  80322c:	68 0f 42 80 00       	push   $0x80420f
  803231:	e8 71 d2 ff ff       	call   8004a7 <_panic>
  803236:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80323c:	8b 45 08             	mov    0x8(%ebp),%eax
  80323f:	89 10                	mov    %edx,(%eax)
  803241:	8b 45 08             	mov    0x8(%ebp),%eax
  803244:	8b 00                	mov    (%eax),%eax
  803246:	85 c0                	test   %eax,%eax
  803248:	74 0d                	je     803257 <insert_sorted_with_merge_freeList+0x4de>
  80324a:	a1 48 51 80 00       	mov    0x805148,%eax
  80324f:	8b 55 08             	mov    0x8(%ebp),%edx
  803252:	89 50 04             	mov    %edx,0x4(%eax)
  803255:	eb 08                	jmp    80325f <insert_sorted_with_merge_freeList+0x4e6>
  803257:	8b 45 08             	mov    0x8(%ebp),%eax
  80325a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80325f:	8b 45 08             	mov    0x8(%ebp),%eax
  803262:	a3 48 51 80 00       	mov    %eax,0x805148
  803267:	8b 45 08             	mov    0x8(%ebp),%eax
  80326a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803271:	a1 54 51 80 00       	mov    0x805154,%eax
  803276:	40                   	inc    %eax
  803277:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80327c:	e9 41 02 00 00       	jmp    8034c2 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803281:	8b 45 08             	mov    0x8(%ebp),%eax
  803284:	8b 50 08             	mov    0x8(%eax),%edx
  803287:	8b 45 08             	mov    0x8(%ebp),%eax
  80328a:	8b 40 0c             	mov    0xc(%eax),%eax
  80328d:	01 c2                	add    %eax,%edx
  80328f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803292:	8b 40 08             	mov    0x8(%eax),%eax
  803295:	39 c2                	cmp    %eax,%edx
  803297:	0f 85 7c 01 00 00    	jne    803419 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  80329d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032a1:	74 06                	je     8032a9 <insert_sorted_with_merge_freeList+0x530>
  8032a3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032a7:	75 17                	jne    8032c0 <insert_sorted_with_merge_freeList+0x547>
  8032a9:	83 ec 04             	sub    $0x4,%esp
  8032ac:	68 28 42 80 00       	push   $0x804228
  8032b1:	68 69 01 00 00       	push   $0x169
  8032b6:	68 0f 42 80 00       	push   $0x80420f
  8032bb:	e8 e7 d1 ff ff       	call   8004a7 <_panic>
  8032c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032c3:	8b 50 04             	mov    0x4(%eax),%edx
  8032c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c9:	89 50 04             	mov    %edx,0x4(%eax)
  8032cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8032cf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032d2:	89 10                	mov    %edx,(%eax)
  8032d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032d7:	8b 40 04             	mov    0x4(%eax),%eax
  8032da:	85 c0                	test   %eax,%eax
  8032dc:	74 0d                	je     8032eb <insert_sorted_with_merge_freeList+0x572>
  8032de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032e1:	8b 40 04             	mov    0x4(%eax),%eax
  8032e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8032e7:	89 10                	mov    %edx,(%eax)
  8032e9:	eb 08                	jmp    8032f3 <insert_sorted_with_merge_freeList+0x57a>
  8032eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ee:	a3 38 51 80 00       	mov    %eax,0x805138
  8032f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8032f9:	89 50 04             	mov    %edx,0x4(%eax)
  8032fc:	a1 44 51 80 00       	mov    0x805144,%eax
  803301:	40                   	inc    %eax
  803302:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803307:	8b 45 08             	mov    0x8(%ebp),%eax
  80330a:	8b 50 0c             	mov    0xc(%eax),%edx
  80330d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803310:	8b 40 0c             	mov    0xc(%eax),%eax
  803313:	01 c2                	add    %eax,%edx
  803315:	8b 45 08             	mov    0x8(%ebp),%eax
  803318:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80331b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80331f:	75 17                	jne    803338 <insert_sorted_with_merge_freeList+0x5bf>
  803321:	83 ec 04             	sub    $0x4,%esp
  803324:	68 b8 42 80 00       	push   $0x8042b8
  803329:	68 6b 01 00 00       	push   $0x16b
  80332e:	68 0f 42 80 00       	push   $0x80420f
  803333:	e8 6f d1 ff ff       	call   8004a7 <_panic>
  803338:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80333b:	8b 00                	mov    (%eax),%eax
  80333d:	85 c0                	test   %eax,%eax
  80333f:	74 10                	je     803351 <insert_sorted_with_merge_freeList+0x5d8>
  803341:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803344:	8b 00                	mov    (%eax),%eax
  803346:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803349:	8b 52 04             	mov    0x4(%edx),%edx
  80334c:	89 50 04             	mov    %edx,0x4(%eax)
  80334f:	eb 0b                	jmp    80335c <insert_sorted_with_merge_freeList+0x5e3>
  803351:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803354:	8b 40 04             	mov    0x4(%eax),%eax
  803357:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80335c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80335f:	8b 40 04             	mov    0x4(%eax),%eax
  803362:	85 c0                	test   %eax,%eax
  803364:	74 0f                	je     803375 <insert_sorted_with_merge_freeList+0x5fc>
  803366:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803369:	8b 40 04             	mov    0x4(%eax),%eax
  80336c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80336f:	8b 12                	mov    (%edx),%edx
  803371:	89 10                	mov    %edx,(%eax)
  803373:	eb 0a                	jmp    80337f <insert_sorted_with_merge_freeList+0x606>
  803375:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803378:	8b 00                	mov    (%eax),%eax
  80337a:	a3 38 51 80 00       	mov    %eax,0x805138
  80337f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803382:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803388:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80338b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803392:	a1 44 51 80 00       	mov    0x805144,%eax
  803397:	48                   	dec    %eax
  803398:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  80339d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033a0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8033a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033aa:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8033b1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8033b5:	75 17                	jne    8033ce <insert_sorted_with_merge_freeList+0x655>
  8033b7:	83 ec 04             	sub    $0x4,%esp
  8033ba:	68 ec 41 80 00       	push   $0x8041ec
  8033bf:	68 6e 01 00 00       	push   $0x16e
  8033c4:	68 0f 42 80 00       	push   $0x80420f
  8033c9:	e8 d9 d0 ff ff       	call   8004a7 <_panic>
  8033ce:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8033d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033d7:	89 10                	mov    %edx,(%eax)
  8033d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033dc:	8b 00                	mov    (%eax),%eax
  8033de:	85 c0                	test   %eax,%eax
  8033e0:	74 0d                	je     8033ef <insert_sorted_with_merge_freeList+0x676>
  8033e2:	a1 48 51 80 00       	mov    0x805148,%eax
  8033e7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033ea:	89 50 04             	mov    %edx,0x4(%eax)
  8033ed:	eb 08                	jmp    8033f7 <insert_sorted_with_merge_freeList+0x67e>
  8033ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033f2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8033f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033fa:	a3 48 51 80 00       	mov    %eax,0x805148
  8033ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803402:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803409:	a1 54 51 80 00       	mov    0x805154,%eax
  80340e:	40                   	inc    %eax
  80340f:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803414:	e9 a9 00 00 00       	jmp    8034c2 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803419:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80341d:	74 06                	je     803425 <insert_sorted_with_merge_freeList+0x6ac>
  80341f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803423:	75 17                	jne    80343c <insert_sorted_with_merge_freeList+0x6c3>
  803425:	83 ec 04             	sub    $0x4,%esp
  803428:	68 84 42 80 00       	push   $0x804284
  80342d:	68 73 01 00 00       	push   $0x173
  803432:	68 0f 42 80 00       	push   $0x80420f
  803437:	e8 6b d0 ff ff       	call   8004a7 <_panic>
  80343c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80343f:	8b 10                	mov    (%eax),%edx
  803441:	8b 45 08             	mov    0x8(%ebp),%eax
  803444:	89 10                	mov    %edx,(%eax)
  803446:	8b 45 08             	mov    0x8(%ebp),%eax
  803449:	8b 00                	mov    (%eax),%eax
  80344b:	85 c0                	test   %eax,%eax
  80344d:	74 0b                	je     80345a <insert_sorted_with_merge_freeList+0x6e1>
  80344f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803452:	8b 00                	mov    (%eax),%eax
  803454:	8b 55 08             	mov    0x8(%ebp),%edx
  803457:	89 50 04             	mov    %edx,0x4(%eax)
  80345a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80345d:	8b 55 08             	mov    0x8(%ebp),%edx
  803460:	89 10                	mov    %edx,(%eax)
  803462:	8b 45 08             	mov    0x8(%ebp),%eax
  803465:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803468:	89 50 04             	mov    %edx,0x4(%eax)
  80346b:	8b 45 08             	mov    0x8(%ebp),%eax
  80346e:	8b 00                	mov    (%eax),%eax
  803470:	85 c0                	test   %eax,%eax
  803472:	75 08                	jne    80347c <insert_sorted_with_merge_freeList+0x703>
  803474:	8b 45 08             	mov    0x8(%ebp),%eax
  803477:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80347c:	a1 44 51 80 00       	mov    0x805144,%eax
  803481:	40                   	inc    %eax
  803482:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803487:	eb 39                	jmp    8034c2 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803489:	a1 40 51 80 00       	mov    0x805140,%eax
  80348e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803491:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803495:	74 07                	je     80349e <insert_sorted_with_merge_freeList+0x725>
  803497:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80349a:	8b 00                	mov    (%eax),%eax
  80349c:	eb 05                	jmp    8034a3 <insert_sorted_with_merge_freeList+0x72a>
  80349e:	b8 00 00 00 00       	mov    $0x0,%eax
  8034a3:	a3 40 51 80 00       	mov    %eax,0x805140
  8034a8:	a1 40 51 80 00       	mov    0x805140,%eax
  8034ad:	85 c0                	test   %eax,%eax
  8034af:	0f 85 c7 fb ff ff    	jne    80307c <insert_sorted_with_merge_freeList+0x303>
  8034b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034b9:	0f 85 bd fb ff ff    	jne    80307c <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8034bf:	eb 01                	jmp    8034c2 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8034c1:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8034c2:	90                   	nop
  8034c3:	c9                   	leave  
  8034c4:	c3                   	ret    

008034c5 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8034c5:	55                   	push   %ebp
  8034c6:	89 e5                	mov    %esp,%ebp
  8034c8:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8034cb:	8b 55 08             	mov    0x8(%ebp),%edx
  8034ce:	89 d0                	mov    %edx,%eax
  8034d0:	c1 e0 02             	shl    $0x2,%eax
  8034d3:	01 d0                	add    %edx,%eax
  8034d5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8034dc:	01 d0                	add    %edx,%eax
  8034de:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8034e5:	01 d0                	add    %edx,%eax
  8034e7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8034ee:	01 d0                	add    %edx,%eax
  8034f0:	c1 e0 04             	shl    $0x4,%eax
  8034f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8034f6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8034fd:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803500:	83 ec 0c             	sub    $0xc,%esp
  803503:	50                   	push   %eax
  803504:	e8 26 e7 ff ff       	call   801c2f <sys_get_virtual_time>
  803509:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  80350c:	eb 41                	jmp    80354f <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  80350e:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803511:	83 ec 0c             	sub    $0xc,%esp
  803514:	50                   	push   %eax
  803515:	e8 15 e7 ff ff       	call   801c2f <sys_get_virtual_time>
  80351a:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  80351d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803520:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803523:	29 c2                	sub    %eax,%edx
  803525:	89 d0                	mov    %edx,%eax
  803527:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  80352a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80352d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803530:	89 d1                	mov    %edx,%ecx
  803532:	29 c1                	sub    %eax,%ecx
  803534:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803537:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80353a:	39 c2                	cmp    %eax,%edx
  80353c:	0f 97 c0             	seta   %al
  80353f:	0f b6 c0             	movzbl %al,%eax
  803542:	29 c1                	sub    %eax,%ecx
  803544:	89 c8                	mov    %ecx,%eax
  803546:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803549:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80354c:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  80354f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803552:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803555:	72 b7                	jb     80350e <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803557:	90                   	nop
  803558:	c9                   	leave  
  803559:	c3                   	ret    

0080355a <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  80355a:	55                   	push   %ebp
  80355b:	89 e5                	mov    %esp,%ebp
  80355d:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803560:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803567:	eb 03                	jmp    80356c <busy_wait+0x12>
  803569:	ff 45 fc             	incl   -0x4(%ebp)
  80356c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80356f:	3b 45 08             	cmp    0x8(%ebp),%eax
  803572:	72 f5                	jb     803569 <busy_wait+0xf>
	return i;
  803574:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803577:	c9                   	leave  
  803578:	c3                   	ret    
  803579:	66 90                	xchg   %ax,%ax
  80357b:	90                   	nop

0080357c <__udivdi3>:
  80357c:	55                   	push   %ebp
  80357d:	57                   	push   %edi
  80357e:	56                   	push   %esi
  80357f:	53                   	push   %ebx
  803580:	83 ec 1c             	sub    $0x1c,%esp
  803583:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803587:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80358b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80358f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803593:	89 ca                	mov    %ecx,%edx
  803595:	89 f8                	mov    %edi,%eax
  803597:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80359b:	85 f6                	test   %esi,%esi
  80359d:	75 2d                	jne    8035cc <__udivdi3+0x50>
  80359f:	39 cf                	cmp    %ecx,%edi
  8035a1:	77 65                	ja     803608 <__udivdi3+0x8c>
  8035a3:	89 fd                	mov    %edi,%ebp
  8035a5:	85 ff                	test   %edi,%edi
  8035a7:	75 0b                	jne    8035b4 <__udivdi3+0x38>
  8035a9:	b8 01 00 00 00       	mov    $0x1,%eax
  8035ae:	31 d2                	xor    %edx,%edx
  8035b0:	f7 f7                	div    %edi
  8035b2:	89 c5                	mov    %eax,%ebp
  8035b4:	31 d2                	xor    %edx,%edx
  8035b6:	89 c8                	mov    %ecx,%eax
  8035b8:	f7 f5                	div    %ebp
  8035ba:	89 c1                	mov    %eax,%ecx
  8035bc:	89 d8                	mov    %ebx,%eax
  8035be:	f7 f5                	div    %ebp
  8035c0:	89 cf                	mov    %ecx,%edi
  8035c2:	89 fa                	mov    %edi,%edx
  8035c4:	83 c4 1c             	add    $0x1c,%esp
  8035c7:	5b                   	pop    %ebx
  8035c8:	5e                   	pop    %esi
  8035c9:	5f                   	pop    %edi
  8035ca:	5d                   	pop    %ebp
  8035cb:	c3                   	ret    
  8035cc:	39 ce                	cmp    %ecx,%esi
  8035ce:	77 28                	ja     8035f8 <__udivdi3+0x7c>
  8035d0:	0f bd fe             	bsr    %esi,%edi
  8035d3:	83 f7 1f             	xor    $0x1f,%edi
  8035d6:	75 40                	jne    803618 <__udivdi3+0x9c>
  8035d8:	39 ce                	cmp    %ecx,%esi
  8035da:	72 0a                	jb     8035e6 <__udivdi3+0x6a>
  8035dc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8035e0:	0f 87 9e 00 00 00    	ja     803684 <__udivdi3+0x108>
  8035e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8035eb:	89 fa                	mov    %edi,%edx
  8035ed:	83 c4 1c             	add    $0x1c,%esp
  8035f0:	5b                   	pop    %ebx
  8035f1:	5e                   	pop    %esi
  8035f2:	5f                   	pop    %edi
  8035f3:	5d                   	pop    %ebp
  8035f4:	c3                   	ret    
  8035f5:	8d 76 00             	lea    0x0(%esi),%esi
  8035f8:	31 ff                	xor    %edi,%edi
  8035fa:	31 c0                	xor    %eax,%eax
  8035fc:	89 fa                	mov    %edi,%edx
  8035fe:	83 c4 1c             	add    $0x1c,%esp
  803601:	5b                   	pop    %ebx
  803602:	5e                   	pop    %esi
  803603:	5f                   	pop    %edi
  803604:	5d                   	pop    %ebp
  803605:	c3                   	ret    
  803606:	66 90                	xchg   %ax,%ax
  803608:	89 d8                	mov    %ebx,%eax
  80360a:	f7 f7                	div    %edi
  80360c:	31 ff                	xor    %edi,%edi
  80360e:	89 fa                	mov    %edi,%edx
  803610:	83 c4 1c             	add    $0x1c,%esp
  803613:	5b                   	pop    %ebx
  803614:	5e                   	pop    %esi
  803615:	5f                   	pop    %edi
  803616:	5d                   	pop    %ebp
  803617:	c3                   	ret    
  803618:	bd 20 00 00 00       	mov    $0x20,%ebp
  80361d:	89 eb                	mov    %ebp,%ebx
  80361f:	29 fb                	sub    %edi,%ebx
  803621:	89 f9                	mov    %edi,%ecx
  803623:	d3 e6                	shl    %cl,%esi
  803625:	89 c5                	mov    %eax,%ebp
  803627:	88 d9                	mov    %bl,%cl
  803629:	d3 ed                	shr    %cl,%ebp
  80362b:	89 e9                	mov    %ebp,%ecx
  80362d:	09 f1                	or     %esi,%ecx
  80362f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803633:	89 f9                	mov    %edi,%ecx
  803635:	d3 e0                	shl    %cl,%eax
  803637:	89 c5                	mov    %eax,%ebp
  803639:	89 d6                	mov    %edx,%esi
  80363b:	88 d9                	mov    %bl,%cl
  80363d:	d3 ee                	shr    %cl,%esi
  80363f:	89 f9                	mov    %edi,%ecx
  803641:	d3 e2                	shl    %cl,%edx
  803643:	8b 44 24 08          	mov    0x8(%esp),%eax
  803647:	88 d9                	mov    %bl,%cl
  803649:	d3 e8                	shr    %cl,%eax
  80364b:	09 c2                	or     %eax,%edx
  80364d:	89 d0                	mov    %edx,%eax
  80364f:	89 f2                	mov    %esi,%edx
  803651:	f7 74 24 0c          	divl   0xc(%esp)
  803655:	89 d6                	mov    %edx,%esi
  803657:	89 c3                	mov    %eax,%ebx
  803659:	f7 e5                	mul    %ebp
  80365b:	39 d6                	cmp    %edx,%esi
  80365d:	72 19                	jb     803678 <__udivdi3+0xfc>
  80365f:	74 0b                	je     80366c <__udivdi3+0xf0>
  803661:	89 d8                	mov    %ebx,%eax
  803663:	31 ff                	xor    %edi,%edi
  803665:	e9 58 ff ff ff       	jmp    8035c2 <__udivdi3+0x46>
  80366a:	66 90                	xchg   %ax,%ax
  80366c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803670:	89 f9                	mov    %edi,%ecx
  803672:	d3 e2                	shl    %cl,%edx
  803674:	39 c2                	cmp    %eax,%edx
  803676:	73 e9                	jae    803661 <__udivdi3+0xe5>
  803678:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80367b:	31 ff                	xor    %edi,%edi
  80367d:	e9 40 ff ff ff       	jmp    8035c2 <__udivdi3+0x46>
  803682:	66 90                	xchg   %ax,%ax
  803684:	31 c0                	xor    %eax,%eax
  803686:	e9 37 ff ff ff       	jmp    8035c2 <__udivdi3+0x46>
  80368b:	90                   	nop

0080368c <__umoddi3>:
  80368c:	55                   	push   %ebp
  80368d:	57                   	push   %edi
  80368e:	56                   	push   %esi
  80368f:	53                   	push   %ebx
  803690:	83 ec 1c             	sub    $0x1c,%esp
  803693:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803697:	8b 74 24 34          	mov    0x34(%esp),%esi
  80369b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80369f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8036a3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8036a7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8036ab:	89 f3                	mov    %esi,%ebx
  8036ad:	89 fa                	mov    %edi,%edx
  8036af:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8036b3:	89 34 24             	mov    %esi,(%esp)
  8036b6:	85 c0                	test   %eax,%eax
  8036b8:	75 1a                	jne    8036d4 <__umoddi3+0x48>
  8036ba:	39 f7                	cmp    %esi,%edi
  8036bc:	0f 86 a2 00 00 00    	jbe    803764 <__umoddi3+0xd8>
  8036c2:	89 c8                	mov    %ecx,%eax
  8036c4:	89 f2                	mov    %esi,%edx
  8036c6:	f7 f7                	div    %edi
  8036c8:	89 d0                	mov    %edx,%eax
  8036ca:	31 d2                	xor    %edx,%edx
  8036cc:	83 c4 1c             	add    $0x1c,%esp
  8036cf:	5b                   	pop    %ebx
  8036d0:	5e                   	pop    %esi
  8036d1:	5f                   	pop    %edi
  8036d2:	5d                   	pop    %ebp
  8036d3:	c3                   	ret    
  8036d4:	39 f0                	cmp    %esi,%eax
  8036d6:	0f 87 ac 00 00 00    	ja     803788 <__umoddi3+0xfc>
  8036dc:	0f bd e8             	bsr    %eax,%ebp
  8036df:	83 f5 1f             	xor    $0x1f,%ebp
  8036e2:	0f 84 ac 00 00 00    	je     803794 <__umoddi3+0x108>
  8036e8:	bf 20 00 00 00       	mov    $0x20,%edi
  8036ed:	29 ef                	sub    %ebp,%edi
  8036ef:	89 fe                	mov    %edi,%esi
  8036f1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8036f5:	89 e9                	mov    %ebp,%ecx
  8036f7:	d3 e0                	shl    %cl,%eax
  8036f9:	89 d7                	mov    %edx,%edi
  8036fb:	89 f1                	mov    %esi,%ecx
  8036fd:	d3 ef                	shr    %cl,%edi
  8036ff:	09 c7                	or     %eax,%edi
  803701:	89 e9                	mov    %ebp,%ecx
  803703:	d3 e2                	shl    %cl,%edx
  803705:	89 14 24             	mov    %edx,(%esp)
  803708:	89 d8                	mov    %ebx,%eax
  80370a:	d3 e0                	shl    %cl,%eax
  80370c:	89 c2                	mov    %eax,%edx
  80370e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803712:	d3 e0                	shl    %cl,%eax
  803714:	89 44 24 04          	mov    %eax,0x4(%esp)
  803718:	8b 44 24 08          	mov    0x8(%esp),%eax
  80371c:	89 f1                	mov    %esi,%ecx
  80371e:	d3 e8                	shr    %cl,%eax
  803720:	09 d0                	or     %edx,%eax
  803722:	d3 eb                	shr    %cl,%ebx
  803724:	89 da                	mov    %ebx,%edx
  803726:	f7 f7                	div    %edi
  803728:	89 d3                	mov    %edx,%ebx
  80372a:	f7 24 24             	mull   (%esp)
  80372d:	89 c6                	mov    %eax,%esi
  80372f:	89 d1                	mov    %edx,%ecx
  803731:	39 d3                	cmp    %edx,%ebx
  803733:	0f 82 87 00 00 00    	jb     8037c0 <__umoddi3+0x134>
  803739:	0f 84 91 00 00 00    	je     8037d0 <__umoddi3+0x144>
  80373f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803743:	29 f2                	sub    %esi,%edx
  803745:	19 cb                	sbb    %ecx,%ebx
  803747:	89 d8                	mov    %ebx,%eax
  803749:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80374d:	d3 e0                	shl    %cl,%eax
  80374f:	89 e9                	mov    %ebp,%ecx
  803751:	d3 ea                	shr    %cl,%edx
  803753:	09 d0                	or     %edx,%eax
  803755:	89 e9                	mov    %ebp,%ecx
  803757:	d3 eb                	shr    %cl,%ebx
  803759:	89 da                	mov    %ebx,%edx
  80375b:	83 c4 1c             	add    $0x1c,%esp
  80375e:	5b                   	pop    %ebx
  80375f:	5e                   	pop    %esi
  803760:	5f                   	pop    %edi
  803761:	5d                   	pop    %ebp
  803762:	c3                   	ret    
  803763:	90                   	nop
  803764:	89 fd                	mov    %edi,%ebp
  803766:	85 ff                	test   %edi,%edi
  803768:	75 0b                	jne    803775 <__umoddi3+0xe9>
  80376a:	b8 01 00 00 00       	mov    $0x1,%eax
  80376f:	31 d2                	xor    %edx,%edx
  803771:	f7 f7                	div    %edi
  803773:	89 c5                	mov    %eax,%ebp
  803775:	89 f0                	mov    %esi,%eax
  803777:	31 d2                	xor    %edx,%edx
  803779:	f7 f5                	div    %ebp
  80377b:	89 c8                	mov    %ecx,%eax
  80377d:	f7 f5                	div    %ebp
  80377f:	89 d0                	mov    %edx,%eax
  803781:	e9 44 ff ff ff       	jmp    8036ca <__umoddi3+0x3e>
  803786:	66 90                	xchg   %ax,%ax
  803788:	89 c8                	mov    %ecx,%eax
  80378a:	89 f2                	mov    %esi,%edx
  80378c:	83 c4 1c             	add    $0x1c,%esp
  80378f:	5b                   	pop    %ebx
  803790:	5e                   	pop    %esi
  803791:	5f                   	pop    %edi
  803792:	5d                   	pop    %ebp
  803793:	c3                   	ret    
  803794:	3b 04 24             	cmp    (%esp),%eax
  803797:	72 06                	jb     80379f <__umoddi3+0x113>
  803799:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80379d:	77 0f                	ja     8037ae <__umoddi3+0x122>
  80379f:	89 f2                	mov    %esi,%edx
  8037a1:	29 f9                	sub    %edi,%ecx
  8037a3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8037a7:	89 14 24             	mov    %edx,(%esp)
  8037aa:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8037ae:	8b 44 24 04          	mov    0x4(%esp),%eax
  8037b2:	8b 14 24             	mov    (%esp),%edx
  8037b5:	83 c4 1c             	add    $0x1c,%esp
  8037b8:	5b                   	pop    %ebx
  8037b9:	5e                   	pop    %esi
  8037ba:	5f                   	pop    %edi
  8037bb:	5d                   	pop    %ebp
  8037bc:	c3                   	ret    
  8037bd:	8d 76 00             	lea    0x0(%esi),%esi
  8037c0:	2b 04 24             	sub    (%esp),%eax
  8037c3:	19 fa                	sbb    %edi,%edx
  8037c5:	89 d1                	mov    %edx,%ecx
  8037c7:	89 c6                	mov    %eax,%esi
  8037c9:	e9 71 ff ff ff       	jmp    80373f <__umoddi3+0xb3>
  8037ce:	66 90                	xchg   %ax,%ax
  8037d0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8037d4:	72 ea                	jb     8037c0 <__umoddi3+0x134>
  8037d6:	89 d9                	mov    %ebx,%ecx
  8037d8:	e9 62 ff ff ff       	jmp    80373f <__umoddi3+0xb3>
