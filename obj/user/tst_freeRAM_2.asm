
obj/user/tst_freeRAM_2:     file format elf32-i386


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
  800031:	e8 ac 05 00 00       	call   8005e2 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
	char a;
	short b;
	int c;
};
void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	53                   	push   %ebx
  80003d:	81 ec b0 00 00 00    	sub    $0xb0,%esp





	int Mega = 1024*1024;
  800043:	c7 45 f4 00 00 10 00 	movl   $0x100000,-0xc(%ebp)
	int kilo = 1024;
  80004a:	c7 45 f0 00 04 00 00 	movl   $0x400,-0x10(%ebp)
	char minByte = 1<<7;
  800051:	c6 45 ef 80          	movb   $0x80,-0x11(%ebp)
	char maxByte = 0x7F;
  800055:	c6 45 ee 7f          	movb   $0x7f,-0x12(%ebp)
	short minShort = 1<<15 ;
  800059:	66 c7 45 ec 00 80    	movw   $0x8000,-0x14(%ebp)
	short maxShort = 0x7FFF;
  80005f:	66 c7 45 ea ff 7f    	movw   $0x7fff,-0x16(%ebp)
	int minInt = 1<<31 ;
  800065:	c7 45 e4 00 00 00 80 	movl   $0x80000000,-0x1c(%ebp)
	int maxInt = 0x7FFFFFFF;
  80006c:	c7 45 e0 ff ff ff 7f 	movl   $0x7fffffff,-0x20(%ebp)

	void* ptr_allocations[20] = {0};
  800073:	8d 95 4c ff ff ff    	lea    -0xb4(%ebp),%edx
  800079:	b9 14 00 00 00       	mov    $0x14,%ecx
  80007e:	b8 00 00 00 00       	mov    $0x0,%eax
  800083:	89 d7                	mov    %edx,%edi
  800085:	f3 ab                	rep stos %eax,%es:(%edi)
	{
		//Load "fib" & "fos_helloWorld" programs into RAM
		cprintf("Loading Fib & fos_helloWorld programs into RAM...");
  800087:	83 ec 0c             	sub    $0xc,%esp
  80008a:	68 c0 3a 80 00       	push   $0x803ac0
  80008f:	e8 3e 09 00 00       	call   8009d2 <cprintf>
  800094:	83 c4 10             	add    $0x10,%esp
		int32 envIdFib = sys_create_env("fib", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  800097:	a1 20 50 80 00       	mov    0x805020,%eax
  80009c:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  8000a2:	a1 20 50 80 00       	mov    0x805020,%eax
  8000a7:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8000ad:	89 c1                	mov    %eax,%ecx
  8000af:	a1 20 50 80 00       	mov    0x805020,%eax
  8000b4:	8b 40 74             	mov    0x74(%eax),%eax
  8000b7:	52                   	push   %edx
  8000b8:	51                   	push   %ecx
  8000b9:	50                   	push   %eax
  8000ba:	68 f2 3a 80 00       	push   $0x803af2
  8000bf:	e8 90 1d 00 00       	call   801e54 <sys_create_env>
  8000c4:	83 c4 10             	add    $0x10,%esp
  8000c7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		int freeFrames = sys_calculate_free_frames() ;
  8000ca:	e8 13 1b 00 00       	call   801be2 <sys_calculate_free_frames>
  8000cf:	89 45 d8             	mov    %eax,-0x28(%ebp)
		int32 envIdHelloWorld = sys_create_env("fos_helloWorld", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8000d2:	a1 20 50 80 00       	mov    0x805020,%eax
  8000d7:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  8000dd:	a1 20 50 80 00       	mov    0x805020,%eax
  8000e2:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8000e8:	89 c1                	mov    %eax,%ecx
  8000ea:	a1 20 50 80 00       	mov    0x805020,%eax
  8000ef:	8b 40 74             	mov    0x74(%eax),%eax
  8000f2:	52                   	push   %edx
  8000f3:	51                   	push   %ecx
  8000f4:	50                   	push   %eax
  8000f5:	68 f6 3a 80 00       	push   $0x803af6
  8000fa:	e8 55 1d 00 00       	call   801e54 <sys_create_env>
  8000ff:	83 c4 10             	add    $0x10,%esp
  800102:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		int helloWorldFrames = freeFrames - sys_calculate_free_frames() ;
  800105:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800108:	e8 d5 1a 00 00       	call   801be2 <sys_calculate_free_frames>
  80010d:	29 c3                	sub    %eax,%ebx
  80010f:	89 d8                	mov    %ebx,%eax
  800111:	89 45 d0             	mov    %eax,-0x30(%ebp)
		env_sleep(2000);
  800114:	83 ec 0c             	sub    $0xc,%esp
  800117:	68 d0 07 00 00       	push   $0x7d0
  80011c:	e8 83 36 00 00       	call   8037a4 <env_sleep>
  800121:	83 c4 10             	add    $0x10,%esp
		cprintf("[DONE]\n\n");
  800124:	83 ec 0c             	sub    $0xc,%esp
  800127:	68 05 3b 80 00       	push   $0x803b05
  80012c:	e8 a1 08 00 00       	call   8009d2 <cprintf>
  800131:	83 c4 10             	add    $0x10,%esp

		//Load and run "fos_add"
		cprintf("Loading fos_add program into RAM...");
  800134:	83 ec 0c             	sub    $0xc,%esp
  800137:	68 10 3b 80 00       	push   $0x803b10
  80013c:	e8 91 08 00 00       	call   8009d2 <cprintf>
  800141:	83 c4 10             	add    $0x10,%esp
		int32 envIdFOSAdd= sys_create_env("fos_add", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  800144:	a1 20 50 80 00       	mov    0x805020,%eax
  800149:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  80014f:	a1 20 50 80 00       	mov    0x805020,%eax
  800154:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80015a:	89 c1                	mov    %eax,%ecx
  80015c:	a1 20 50 80 00       	mov    0x805020,%eax
  800161:	8b 40 74             	mov    0x74(%eax),%eax
  800164:	52                   	push   %edx
  800165:	51                   	push   %ecx
  800166:	50                   	push   %eax
  800167:	68 34 3b 80 00       	push   $0x803b34
  80016c:	e8 e3 1c 00 00       	call   801e54 <sys_create_env>
  800171:	83 c4 10             	add    $0x10,%esp
  800174:	89 45 cc             	mov    %eax,-0x34(%ebp)
		env_sleep(2000);
  800177:	83 ec 0c             	sub    $0xc,%esp
  80017a:	68 d0 07 00 00       	push   $0x7d0
  80017f:	e8 20 36 00 00       	call   8037a4 <env_sleep>
  800184:	83 c4 10             	add    $0x10,%esp
		cprintf("[DONE]\n\n");
  800187:	83 ec 0c             	sub    $0xc,%esp
  80018a:	68 05 3b 80 00       	push   $0x803b05
  80018f:	e8 3e 08 00 00       	call   8009d2 <cprintf>
  800194:	83 c4 10             	add    $0x10,%esp
		cprintf("running fos_add program...\n\n");
  800197:	83 ec 0c             	sub    $0xc,%esp
  80019a:	68 3c 3b 80 00       	push   $0x803b3c
  80019f:	e8 2e 08 00 00       	call   8009d2 <cprintf>
  8001a4:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdFOSAdd);
  8001a7:	83 ec 0c             	sub    $0xc,%esp
  8001aa:	ff 75 cc             	pushl  -0x34(%ebp)
  8001ad:	e8 c0 1c 00 00       	call   801e72 <sys_run_env>
  8001b2:	83 c4 10             	add    $0x10,%esp

		cprintf("please be patient ...\n");
  8001b5:	83 ec 0c             	sub    $0xc,%esp
  8001b8:	68 59 3b 80 00       	push   $0x803b59
  8001bd:	e8 10 08 00 00       	call   8009d2 <cprintf>
  8001c2:	83 c4 10             	add    $0x10,%esp
		env_sleep(5000);
  8001c5:	83 ec 0c             	sub    $0xc,%esp
  8001c8:	68 88 13 00 00       	push   $0x1388
  8001cd:	e8 d2 35 00 00       	call   8037a4 <env_sleep>
  8001d2:	83 c4 10             	add    $0x10,%esp

		//Allocate 2 MB
		ptr_allocations[0] = malloc(2*Mega-kilo);
  8001d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001d8:	01 c0                	add    %eax,%eax
  8001da:	2b 45 f0             	sub    -0x10(%ebp),%eax
  8001dd:	83 ec 0c             	sub    $0xc,%esp
  8001e0:	50                   	push   %eax
  8001e1:	e8 74 17 00 00       	call   80195a <malloc>
  8001e6:	83 c4 10             	add    $0x10,%esp
  8001e9:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
		char *byteArr = (char *) ptr_allocations[0];
  8001ef:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  8001f5:	89 45 c8             	mov    %eax,-0x38(%ebp)
		int lastIndexOfByte = (2*Mega-kilo)/sizeof(char) - 1;
  8001f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001fb:	01 c0                	add    %eax,%eax
  8001fd:	2b 45 f0             	sub    -0x10(%ebp),%eax
  800200:	48                   	dec    %eax
  800201:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		byteArr[0] = minByte ;
  800204:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800207:	8a 55 ef             	mov    -0x11(%ebp),%dl
  80020a:	88 10                	mov    %dl,(%eax)
		byteArr[lastIndexOfByte] = maxByte ;
  80020c:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80020f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800212:	01 c2                	add    %eax,%edx
  800214:	8a 45 ee             	mov    -0x12(%ebp),%al
  800217:	88 02                	mov    %al,(%edx)

		//Allocate another 2 MB
		ptr_allocations[1] = malloc(2*Mega-kilo);
  800219:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80021c:	01 c0                	add    %eax,%eax
  80021e:	2b 45 f0             	sub    -0x10(%ebp),%eax
  800221:	83 ec 0c             	sub    $0xc,%esp
  800224:	50                   	push   %eax
  800225:	e8 30 17 00 00       	call   80195a <malloc>
  80022a:	83 c4 10             	add    $0x10,%esp
  80022d:	89 85 50 ff ff ff    	mov    %eax,-0xb0(%ebp)
		short *shortArr = (short *) ptr_allocations[1];
  800233:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  800239:	89 45 c0             	mov    %eax,-0x40(%ebp)
		int lastIndexOfShort = (2*Mega-kilo)/sizeof(short) - 1;
  80023c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80023f:	01 c0                	add    %eax,%eax
  800241:	2b 45 f0             	sub    -0x10(%ebp),%eax
  800244:	d1 e8                	shr    %eax
  800246:	48                   	dec    %eax
  800247:	89 45 bc             	mov    %eax,-0x44(%ebp)
		shortArr[0] = minShort;
  80024a:	8b 55 c0             	mov    -0x40(%ebp),%edx
  80024d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800250:	66 89 02             	mov    %ax,(%edx)
		shortArr[lastIndexOfShort] = maxShort;
  800253:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800256:	01 c0                	add    %eax,%eax
  800258:	89 c2                	mov    %eax,%edx
  80025a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80025d:	01 c2                	add    %eax,%edx
  80025f:	66 8b 45 ea          	mov    -0x16(%ebp),%ax
  800263:	66 89 02             	mov    %ax,(%edx)

		//Allocate all remaining RAM (Here: it requires to free some RAM by removing exited program (fos_add))
		freeFrames = sys_calculate_free_frames() ;
  800266:	e8 77 19 00 00       	call   801be2 <sys_calculate_free_frames>
  80026b:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[2] = malloc(freeFrames*PAGE_SIZE);
  80026e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800271:	c1 e0 0c             	shl    $0xc,%eax
  800274:	83 ec 0c             	sub    $0xc,%esp
  800277:	50                   	push   %eax
  800278:	e8 dd 16 00 00       	call   80195a <malloc>
  80027d:	83 c4 10             	add    $0x10,%esp
  800280:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
		int *intArr = (int *) ptr_allocations[2];
  800286:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  80028c:	89 45 b8             	mov    %eax,-0x48(%ebp)
		int lastIndexOfInt = (freeFrames*PAGE_SIZE)/sizeof(int) - 1;
  80028f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800292:	c1 e0 0c             	shl    $0xc,%eax
  800295:	c1 e8 02             	shr    $0x2,%eax
  800298:	48                   	dec    %eax
  800299:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		intArr[0] = minInt;
  80029c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80029f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8002a2:	89 10                	mov    %edx,(%eax)
		intArr[lastIndexOfInt] = maxInt;
  8002a4:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8002a7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002ae:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8002b1:	01 c2                	add    %eax,%edx
  8002b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002b6:	89 02                	mov    %eax,(%edx)

		//Allocate 7 KB after freeing some RAM
		ptr_allocations[3] = malloc(7*kilo);
  8002b8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8002bb:	89 d0                	mov    %edx,%eax
  8002bd:	01 c0                	add    %eax,%eax
  8002bf:	01 d0                	add    %edx,%eax
  8002c1:	01 c0                	add    %eax,%eax
  8002c3:	01 d0                	add    %edx,%eax
  8002c5:	83 ec 0c             	sub    $0xc,%esp
  8002c8:	50                   	push   %eax
  8002c9:	e8 8c 16 00 00       	call   80195a <malloc>
  8002ce:	83 c4 10             	add    $0x10,%esp
  8002d1:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)
		struct MyStruct *structArr = (struct MyStruct *) ptr_allocations[3];
  8002d7:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  8002dd:	89 45 b0             	mov    %eax,-0x50(%ebp)
		int lastIndexOfStruct = (7*kilo)/sizeof(struct MyStruct) - 1;
  8002e0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8002e3:	89 d0                	mov    %edx,%eax
  8002e5:	01 c0                	add    %eax,%eax
  8002e7:	01 d0                	add    %edx,%eax
  8002e9:	01 c0                	add    %eax,%eax
  8002eb:	01 d0                	add    %edx,%eax
  8002ed:	c1 e8 03             	shr    $0x3,%eax
  8002f0:	48                   	dec    %eax
  8002f1:	89 45 ac             	mov    %eax,-0x54(%ebp)
		structArr[0].a = minByte; structArr[0].b = minShort; structArr[0].c = minInt;
  8002f4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8002f7:	8a 55 ef             	mov    -0x11(%ebp),%dl
  8002fa:	88 10                	mov    %dl,(%eax)
  8002fc:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8002ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800302:	66 89 42 02          	mov    %ax,0x2(%edx)
  800306:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800309:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80030c:	89 50 04             	mov    %edx,0x4(%eax)
		structArr[lastIndexOfStruct].a = maxByte; structArr[lastIndexOfStruct].b = maxShort; structArr[lastIndexOfStruct].c = maxInt;
  80030f:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800312:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800319:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80031c:	01 c2                	add    %eax,%edx
  80031e:	8a 45 ee             	mov    -0x12(%ebp),%al
  800321:	88 02                	mov    %al,(%edx)
  800323:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800326:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80032d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800330:	01 c2                	add    %eax,%edx
  800332:	66 8b 45 ea          	mov    -0x16(%ebp),%ax
  800336:	66 89 42 02          	mov    %ax,0x2(%edx)
  80033a:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80033d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800344:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800347:	01 c2                	add    %eax,%edx
  800349:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80034c:	89 42 04             	mov    %eax,0x4(%edx)

		cprintf("running fos_helloWorld program...\n\n");
  80034f:	83 ec 0c             	sub    $0xc,%esp
  800352:	68 70 3b 80 00       	push   $0x803b70
  800357:	e8 76 06 00 00       	call   8009d2 <cprintf>
  80035c:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdHelloWorld);
  80035f:	83 ec 0c             	sub    $0xc,%esp
  800362:	ff 75 d4             	pushl  -0x2c(%ebp)
  800365:	e8 08 1b 00 00       	call   801e72 <sys_run_env>
  80036a:	83 c4 10             	add    $0x10,%esp

		cprintf("please be patient ...\n");
  80036d:	83 ec 0c             	sub    $0xc,%esp
  800370:	68 59 3b 80 00       	push   $0x803b59
  800375:	e8 58 06 00 00       	call   8009d2 <cprintf>
  80037a:	83 c4 10             	add    $0x10,%esp
		env_sleep(5000);
  80037d:	83 ec 0c             	sub    $0xc,%esp
  800380:	68 88 13 00 00       	push   $0x1388
  800385:	e8 1a 34 00 00       	call   8037a4 <env_sleep>
  80038a:	83 c4 10             	add    $0x10,%esp

		//Allocate the remaining RAM + extra RAM by the size of helloWorld program (Here: it requires to free some RAM by removing exited & loaded program(s) (fos_helloWorld & fib))
		freeFrames = sys_calculate_free_frames() ;
  80038d:	e8 50 18 00 00       	call   801be2 <sys_calculate_free_frames>
  800392:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[4] = malloc((freeFrames + helloWorldFrames)*PAGE_SIZE);
  800395:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800398:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80039b:	01 d0                	add    %edx,%eax
  80039d:	c1 e0 0c             	shl    $0xc,%eax
  8003a0:	83 ec 0c             	sub    $0xc,%esp
  8003a3:	50                   	push   %eax
  8003a4:	e8 b1 15 00 00       	call   80195a <malloc>
  8003a9:	83 c4 10             	add    $0x10,%esp
  8003ac:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
		int *intArr2 = (int *) ptr_allocations[4];
  8003b2:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  8003b8:	89 45 a8             	mov    %eax,-0x58(%ebp)
		int lastIndexOfInt2 = ((freeFrames + helloWorldFrames)*PAGE_SIZE)/sizeof(int) - 1;
  8003bb:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8003be:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8003c1:	01 d0                	add    %edx,%eax
  8003c3:	c1 e0 0c             	shl    $0xc,%eax
  8003c6:	c1 e8 02             	shr    $0x2,%eax
  8003c9:	48                   	dec    %eax
  8003ca:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		intArr2[0] = minInt;
  8003cd:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8003d0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8003d3:	89 10                	mov    %edx,(%eax)
		intArr2[lastIndexOfInt2] = maxInt;
  8003d5:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003d8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003df:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8003e2:	01 c2                	add    %eax,%edx
  8003e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003e7:	89 02                	mov    %eax,(%edx)

		//Allocate 8 B after freeing the RAM
		ptr_allocations[5] = malloc(8);
  8003e9:	83 ec 0c             	sub    $0xc,%esp
  8003ec:	6a 08                	push   $0x8
  8003ee:	e8 67 15 00 00       	call   80195a <malloc>
  8003f3:	83 c4 10             	add    $0x10,%esp
  8003f6:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
		int *intArr3 = (int *) ptr_allocations[5];
  8003fc:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800402:	89 45 a0             	mov    %eax,-0x60(%ebp)
		int lastIndexOfInt3 = 8/sizeof(int) - 1;
  800405:	c7 45 9c 01 00 00 00 	movl   $0x1,-0x64(%ebp)
		intArr3[0] = minInt;
  80040c:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80040f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800412:	89 10                	mov    %edx,(%eax)
		intArr3[lastIndexOfInt3] = maxInt;
  800414:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800417:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80041e:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800421:	01 c2                	add    %eax,%edx
  800423:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800426:	89 02                	mov    %eax,(%edx)

		//Check that the values are successfully stored
		if (byteArr[0] 	!= minByte 	|| byteArr[lastIndexOfByte] 	!= maxByte) panic("Wrong allocation: stored values are wrongly changed!");
  800428:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80042b:	8a 00                	mov    (%eax),%al
  80042d:	3a 45 ef             	cmp    -0x11(%ebp),%al
  800430:	75 0f                	jne    800441 <_main+0x409>
  800432:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800435:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800438:	01 d0                	add    %edx,%eax
  80043a:	8a 00                	mov    (%eax),%al
  80043c:	3a 45 ee             	cmp    -0x12(%ebp),%al
  80043f:	74 14                	je     800455 <_main+0x41d>
  800441:	83 ec 04             	sub    $0x4,%esp
  800444:	68 94 3b 80 00       	push   $0x803b94
  800449:	6a 62                	push   $0x62
  80044b:	68 c9 3b 80 00       	push   $0x803bc9
  800450:	e8 c9 02 00 00       	call   80071e <_panic>
		if (shortArr[0] != minShort || shortArr[lastIndexOfShort] 	!= maxShort) panic("Wrong allocation: stored values are wrongly changed!");
  800455:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800458:	66 8b 00             	mov    (%eax),%ax
  80045b:	66 3b 45 ec          	cmp    -0x14(%ebp),%ax
  80045f:	75 15                	jne    800476 <_main+0x43e>
  800461:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800464:	01 c0                	add    %eax,%eax
  800466:	89 c2                	mov    %eax,%edx
  800468:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80046b:	01 d0                	add    %edx,%eax
  80046d:	66 8b 00             	mov    (%eax),%ax
  800470:	66 3b 45 ea          	cmp    -0x16(%ebp),%ax
  800474:	74 14                	je     80048a <_main+0x452>
  800476:	83 ec 04             	sub    $0x4,%esp
  800479:	68 94 3b 80 00       	push   $0x803b94
  80047e:	6a 63                	push   $0x63
  800480:	68 c9 3b 80 00       	push   $0x803bc9
  800485:	e8 94 02 00 00       	call   80071e <_panic>
		if (intArr[0] 	!= minInt 	|| intArr[lastIndexOfInt] 		!= maxInt) panic("Wrong allocation: stored values are wrongly changed!");
  80048a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80048d:	8b 00                	mov    (%eax),%eax
  80048f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800492:	75 16                	jne    8004aa <_main+0x472>
  800494:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  800497:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80049e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8004a1:	01 d0                	add    %edx,%eax
  8004a3:	8b 00                	mov    (%eax),%eax
  8004a5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8004a8:	74 14                	je     8004be <_main+0x486>
  8004aa:	83 ec 04             	sub    $0x4,%esp
  8004ad:	68 94 3b 80 00       	push   $0x803b94
  8004b2:	6a 64                	push   $0x64
  8004b4:	68 c9 3b 80 00       	push   $0x803bc9
  8004b9:	e8 60 02 00 00       	call   80071e <_panic>
		if (intArr2[0] 	!= minInt 	|| intArr2[lastIndexOfInt2] 	!= maxInt) panic("Wrong allocation: stored values are wrongly changed!");
  8004be:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8004c1:	8b 00                	mov    (%eax),%eax
  8004c3:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004c6:	75 16                	jne    8004de <_main+0x4a6>
  8004c8:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8004cb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004d2:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8004d5:	01 d0                	add    %edx,%eax
  8004d7:	8b 00                	mov    (%eax),%eax
  8004d9:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8004dc:	74 14                	je     8004f2 <_main+0x4ba>
  8004de:	83 ec 04             	sub    $0x4,%esp
  8004e1:	68 94 3b 80 00       	push   $0x803b94
  8004e6:	6a 65                	push   $0x65
  8004e8:	68 c9 3b 80 00       	push   $0x803bc9
  8004ed:	e8 2c 02 00 00       	call   80071e <_panic>
		if (intArr3[0] 	!= minInt 	|| intArr3[lastIndexOfInt3] 	!= maxInt) panic("Wrong allocation: stored values are wrongly changed!");
  8004f2:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8004f5:	8b 00                	mov    (%eax),%eax
  8004f7:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004fa:	75 16                	jne    800512 <_main+0x4da>
  8004fc:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8004ff:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800506:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800509:	01 d0                	add    %edx,%eax
  80050b:	8b 00                	mov    (%eax),%eax
  80050d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800510:	74 14                	je     800526 <_main+0x4ee>
  800512:	83 ec 04             	sub    $0x4,%esp
  800515:	68 94 3b 80 00       	push   $0x803b94
  80051a:	6a 66                	push   $0x66
  80051c:	68 c9 3b 80 00       	push   $0x803bc9
  800521:	e8 f8 01 00 00       	call   80071e <_panic>

		if (structArr[0].a != minByte 	|| structArr[lastIndexOfStruct].a != maxByte) 	panic("Wrong allocation: stored values are wrongly changed!");
  800526:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800529:	8a 00                	mov    (%eax),%al
  80052b:	3a 45 ef             	cmp    -0x11(%ebp),%al
  80052e:	75 16                	jne    800546 <_main+0x50e>
  800530:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800533:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80053a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80053d:	01 d0                	add    %edx,%eax
  80053f:	8a 00                	mov    (%eax),%al
  800541:	3a 45 ee             	cmp    -0x12(%ebp),%al
  800544:	74 14                	je     80055a <_main+0x522>
  800546:	83 ec 04             	sub    $0x4,%esp
  800549:	68 94 3b 80 00       	push   $0x803b94
  80054e:	6a 68                	push   $0x68
  800550:	68 c9 3b 80 00       	push   $0x803bc9
  800555:	e8 c4 01 00 00       	call   80071e <_panic>
		if (structArr[0].b != minShort 	|| structArr[lastIndexOfStruct].b != maxShort) 	panic("Wrong allocation: stored values are wrongly changed!");
  80055a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80055d:	66 8b 40 02          	mov    0x2(%eax),%ax
  800561:	66 3b 45 ec          	cmp    -0x14(%ebp),%ax
  800565:	75 19                	jne    800580 <_main+0x548>
  800567:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80056a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800571:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800574:	01 d0                	add    %edx,%eax
  800576:	66 8b 40 02          	mov    0x2(%eax),%ax
  80057a:	66 3b 45 ea          	cmp    -0x16(%ebp),%ax
  80057e:	74 14                	je     800594 <_main+0x55c>
  800580:	83 ec 04             	sub    $0x4,%esp
  800583:	68 94 3b 80 00       	push   $0x803b94
  800588:	6a 69                	push   $0x69
  80058a:	68 c9 3b 80 00       	push   $0x803bc9
  80058f:	e8 8a 01 00 00       	call   80071e <_panic>
		if (structArr[0].c != minInt 	|| structArr[lastIndexOfStruct].c != maxInt) 	panic("Wrong allocation: stored values are wrongly changed!");
  800594:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800597:	8b 40 04             	mov    0x4(%eax),%eax
  80059a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80059d:	75 17                	jne    8005b6 <_main+0x57e>
  80059f:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8005a2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8005a9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8005ac:	01 d0                	add    %edx,%eax
  8005ae:	8b 40 04             	mov    0x4(%eax),%eax
  8005b1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005b4:	74 14                	je     8005ca <_main+0x592>
  8005b6:	83 ec 04             	sub    $0x4,%esp
  8005b9:	68 94 3b 80 00       	push   $0x803b94
  8005be:	6a 6a                	push   $0x6a
  8005c0:	68 c9 3b 80 00       	push   $0x803bc9
  8005c5:	e8 54 01 00 00       	call   80071e <_panic>


	}

	cprintf("Congratulations!! test freeRAM (1) completed successfully.\n");
  8005ca:	83 ec 0c             	sub    $0xc,%esp
  8005cd:	68 e0 3b 80 00       	push   $0x803be0
  8005d2:	e8 fb 03 00 00       	call   8009d2 <cprintf>
  8005d7:	83 c4 10             	add    $0x10,%esp

	return;
  8005da:	90                   	nop
}
  8005db:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8005de:	5b                   	pop    %ebx
  8005df:	5f                   	pop    %edi
  8005e0:	5d                   	pop    %ebp
  8005e1:	c3                   	ret    

008005e2 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8005e2:	55                   	push   %ebp
  8005e3:	89 e5                	mov    %esp,%ebp
  8005e5:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8005e8:	e8 d5 18 00 00       	call   801ec2 <sys_getenvindex>
  8005ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8005f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8005f3:	89 d0                	mov    %edx,%eax
  8005f5:	c1 e0 03             	shl    $0x3,%eax
  8005f8:	01 d0                	add    %edx,%eax
  8005fa:	01 c0                	add    %eax,%eax
  8005fc:	01 d0                	add    %edx,%eax
  8005fe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800605:	01 d0                	add    %edx,%eax
  800607:	c1 e0 04             	shl    $0x4,%eax
  80060a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80060f:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800614:	a1 20 50 80 00       	mov    0x805020,%eax
  800619:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80061f:	84 c0                	test   %al,%al
  800621:	74 0f                	je     800632 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800623:	a1 20 50 80 00       	mov    0x805020,%eax
  800628:	05 5c 05 00 00       	add    $0x55c,%eax
  80062d:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800632:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800636:	7e 0a                	jle    800642 <libmain+0x60>
		binaryname = argv[0];
  800638:	8b 45 0c             	mov    0xc(%ebp),%eax
  80063b:	8b 00                	mov    (%eax),%eax
  80063d:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800642:	83 ec 08             	sub    $0x8,%esp
  800645:	ff 75 0c             	pushl  0xc(%ebp)
  800648:	ff 75 08             	pushl  0x8(%ebp)
  80064b:	e8 e8 f9 ff ff       	call   800038 <_main>
  800650:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800653:	e8 77 16 00 00       	call   801ccf <sys_disable_interrupt>
	cprintf("**************************************\n");
  800658:	83 ec 0c             	sub    $0xc,%esp
  80065b:	68 34 3c 80 00       	push   $0x803c34
  800660:	e8 6d 03 00 00       	call   8009d2 <cprintf>
  800665:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800668:	a1 20 50 80 00       	mov    0x805020,%eax
  80066d:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800673:	a1 20 50 80 00       	mov    0x805020,%eax
  800678:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80067e:	83 ec 04             	sub    $0x4,%esp
  800681:	52                   	push   %edx
  800682:	50                   	push   %eax
  800683:	68 5c 3c 80 00       	push   $0x803c5c
  800688:	e8 45 03 00 00       	call   8009d2 <cprintf>
  80068d:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800690:	a1 20 50 80 00       	mov    0x805020,%eax
  800695:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80069b:	a1 20 50 80 00       	mov    0x805020,%eax
  8006a0:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8006a6:	a1 20 50 80 00       	mov    0x805020,%eax
  8006ab:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8006b1:	51                   	push   %ecx
  8006b2:	52                   	push   %edx
  8006b3:	50                   	push   %eax
  8006b4:	68 84 3c 80 00       	push   $0x803c84
  8006b9:	e8 14 03 00 00       	call   8009d2 <cprintf>
  8006be:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8006c1:	a1 20 50 80 00       	mov    0x805020,%eax
  8006c6:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8006cc:	83 ec 08             	sub    $0x8,%esp
  8006cf:	50                   	push   %eax
  8006d0:	68 dc 3c 80 00       	push   $0x803cdc
  8006d5:	e8 f8 02 00 00       	call   8009d2 <cprintf>
  8006da:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8006dd:	83 ec 0c             	sub    $0xc,%esp
  8006e0:	68 34 3c 80 00       	push   $0x803c34
  8006e5:	e8 e8 02 00 00       	call   8009d2 <cprintf>
  8006ea:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8006ed:	e8 f7 15 00 00       	call   801ce9 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8006f2:	e8 19 00 00 00       	call   800710 <exit>
}
  8006f7:	90                   	nop
  8006f8:	c9                   	leave  
  8006f9:	c3                   	ret    

008006fa <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8006fa:	55                   	push   %ebp
  8006fb:	89 e5                	mov    %esp,%ebp
  8006fd:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800700:	83 ec 0c             	sub    $0xc,%esp
  800703:	6a 00                	push   $0x0
  800705:	e8 84 17 00 00       	call   801e8e <sys_destroy_env>
  80070a:	83 c4 10             	add    $0x10,%esp
}
  80070d:	90                   	nop
  80070e:	c9                   	leave  
  80070f:	c3                   	ret    

00800710 <exit>:

void
exit(void)
{
  800710:	55                   	push   %ebp
  800711:	89 e5                	mov    %esp,%ebp
  800713:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800716:	e8 d9 17 00 00       	call   801ef4 <sys_exit_env>
}
  80071b:	90                   	nop
  80071c:	c9                   	leave  
  80071d:	c3                   	ret    

0080071e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80071e:	55                   	push   %ebp
  80071f:	89 e5                	mov    %esp,%ebp
  800721:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800724:	8d 45 10             	lea    0x10(%ebp),%eax
  800727:	83 c0 04             	add    $0x4,%eax
  80072a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80072d:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800732:	85 c0                	test   %eax,%eax
  800734:	74 16                	je     80074c <_panic+0x2e>
		cprintf("%s: ", argv0);
  800736:	a1 5c 51 80 00       	mov    0x80515c,%eax
  80073b:	83 ec 08             	sub    $0x8,%esp
  80073e:	50                   	push   %eax
  80073f:	68 f0 3c 80 00       	push   $0x803cf0
  800744:	e8 89 02 00 00       	call   8009d2 <cprintf>
  800749:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80074c:	a1 00 50 80 00       	mov    0x805000,%eax
  800751:	ff 75 0c             	pushl  0xc(%ebp)
  800754:	ff 75 08             	pushl  0x8(%ebp)
  800757:	50                   	push   %eax
  800758:	68 f5 3c 80 00       	push   $0x803cf5
  80075d:	e8 70 02 00 00       	call   8009d2 <cprintf>
  800762:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800765:	8b 45 10             	mov    0x10(%ebp),%eax
  800768:	83 ec 08             	sub    $0x8,%esp
  80076b:	ff 75 f4             	pushl  -0xc(%ebp)
  80076e:	50                   	push   %eax
  80076f:	e8 f3 01 00 00       	call   800967 <vcprintf>
  800774:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800777:	83 ec 08             	sub    $0x8,%esp
  80077a:	6a 00                	push   $0x0
  80077c:	68 11 3d 80 00       	push   $0x803d11
  800781:	e8 e1 01 00 00       	call   800967 <vcprintf>
  800786:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800789:	e8 82 ff ff ff       	call   800710 <exit>

	// should not return here
	while (1) ;
  80078e:	eb fe                	jmp    80078e <_panic+0x70>

00800790 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800790:	55                   	push   %ebp
  800791:	89 e5                	mov    %esp,%ebp
  800793:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800796:	a1 20 50 80 00       	mov    0x805020,%eax
  80079b:	8b 50 74             	mov    0x74(%eax),%edx
  80079e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007a1:	39 c2                	cmp    %eax,%edx
  8007a3:	74 14                	je     8007b9 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8007a5:	83 ec 04             	sub    $0x4,%esp
  8007a8:	68 14 3d 80 00       	push   $0x803d14
  8007ad:	6a 26                	push   $0x26
  8007af:	68 60 3d 80 00       	push   $0x803d60
  8007b4:	e8 65 ff ff ff       	call   80071e <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8007b9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8007c0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8007c7:	e9 c2 00 00 00       	jmp    80088e <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8007cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007cf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d9:	01 d0                	add    %edx,%eax
  8007db:	8b 00                	mov    (%eax),%eax
  8007dd:	85 c0                	test   %eax,%eax
  8007df:	75 08                	jne    8007e9 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8007e1:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8007e4:	e9 a2 00 00 00       	jmp    80088b <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8007e9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8007f0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8007f7:	eb 69                	jmp    800862 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8007f9:	a1 20 50 80 00       	mov    0x805020,%eax
  8007fe:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800804:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800807:	89 d0                	mov    %edx,%eax
  800809:	01 c0                	add    %eax,%eax
  80080b:	01 d0                	add    %edx,%eax
  80080d:	c1 e0 03             	shl    $0x3,%eax
  800810:	01 c8                	add    %ecx,%eax
  800812:	8a 40 04             	mov    0x4(%eax),%al
  800815:	84 c0                	test   %al,%al
  800817:	75 46                	jne    80085f <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800819:	a1 20 50 80 00       	mov    0x805020,%eax
  80081e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800824:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800827:	89 d0                	mov    %edx,%eax
  800829:	01 c0                	add    %eax,%eax
  80082b:	01 d0                	add    %edx,%eax
  80082d:	c1 e0 03             	shl    $0x3,%eax
  800830:	01 c8                	add    %ecx,%eax
  800832:	8b 00                	mov    (%eax),%eax
  800834:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800837:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80083a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80083f:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800841:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800844:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80084b:	8b 45 08             	mov    0x8(%ebp),%eax
  80084e:	01 c8                	add    %ecx,%eax
  800850:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800852:	39 c2                	cmp    %eax,%edx
  800854:	75 09                	jne    80085f <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800856:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80085d:	eb 12                	jmp    800871 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80085f:	ff 45 e8             	incl   -0x18(%ebp)
  800862:	a1 20 50 80 00       	mov    0x805020,%eax
  800867:	8b 50 74             	mov    0x74(%eax),%edx
  80086a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80086d:	39 c2                	cmp    %eax,%edx
  80086f:	77 88                	ja     8007f9 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800871:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800875:	75 14                	jne    80088b <CheckWSWithoutLastIndex+0xfb>
			panic(
  800877:	83 ec 04             	sub    $0x4,%esp
  80087a:	68 6c 3d 80 00       	push   $0x803d6c
  80087f:	6a 3a                	push   $0x3a
  800881:	68 60 3d 80 00       	push   $0x803d60
  800886:	e8 93 fe ff ff       	call   80071e <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80088b:	ff 45 f0             	incl   -0x10(%ebp)
  80088e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800891:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800894:	0f 8c 32 ff ff ff    	jl     8007cc <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80089a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008a1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8008a8:	eb 26                	jmp    8008d0 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8008aa:	a1 20 50 80 00       	mov    0x805020,%eax
  8008af:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8008b5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008b8:	89 d0                	mov    %edx,%eax
  8008ba:	01 c0                	add    %eax,%eax
  8008bc:	01 d0                	add    %edx,%eax
  8008be:	c1 e0 03             	shl    $0x3,%eax
  8008c1:	01 c8                	add    %ecx,%eax
  8008c3:	8a 40 04             	mov    0x4(%eax),%al
  8008c6:	3c 01                	cmp    $0x1,%al
  8008c8:	75 03                	jne    8008cd <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8008ca:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008cd:	ff 45 e0             	incl   -0x20(%ebp)
  8008d0:	a1 20 50 80 00       	mov    0x805020,%eax
  8008d5:	8b 50 74             	mov    0x74(%eax),%edx
  8008d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008db:	39 c2                	cmp    %eax,%edx
  8008dd:	77 cb                	ja     8008aa <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8008df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008e2:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8008e5:	74 14                	je     8008fb <CheckWSWithoutLastIndex+0x16b>
		panic(
  8008e7:	83 ec 04             	sub    $0x4,%esp
  8008ea:	68 c0 3d 80 00       	push   $0x803dc0
  8008ef:	6a 44                	push   $0x44
  8008f1:	68 60 3d 80 00       	push   $0x803d60
  8008f6:	e8 23 fe ff ff       	call   80071e <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8008fb:	90                   	nop
  8008fc:	c9                   	leave  
  8008fd:	c3                   	ret    

008008fe <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8008fe:	55                   	push   %ebp
  8008ff:	89 e5                	mov    %esp,%ebp
  800901:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800904:	8b 45 0c             	mov    0xc(%ebp),%eax
  800907:	8b 00                	mov    (%eax),%eax
  800909:	8d 48 01             	lea    0x1(%eax),%ecx
  80090c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80090f:	89 0a                	mov    %ecx,(%edx)
  800911:	8b 55 08             	mov    0x8(%ebp),%edx
  800914:	88 d1                	mov    %dl,%cl
  800916:	8b 55 0c             	mov    0xc(%ebp),%edx
  800919:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80091d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800920:	8b 00                	mov    (%eax),%eax
  800922:	3d ff 00 00 00       	cmp    $0xff,%eax
  800927:	75 2c                	jne    800955 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800929:	a0 24 50 80 00       	mov    0x805024,%al
  80092e:	0f b6 c0             	movzbl %al,%eax
  800931:	8b 55 0c             	mov    0xc(%ebp),%edx
  800934:	8b 12                	mov    (%edx),%edx
  800936:	89 d1                	mov    %edx,%ecx
  800938:	8b 55 0c             	mov    0xc(%ebp),%edx
  80093b:	83 c2 08             	add    $0x8,%edx
  80093e:	83 ec 04             	sub    $0x4,%esp
  800941:	50                   	push   %eax
  800942:	51                   	push   %ecx
  800943:	52                   	push   %edx
  800944:	e8 d8 11 00 00       	call   801b21 <sys_cputs>
  800949:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80094c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80094f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800955:	8b 45 0c             	mov    0xc(%ebp),%eax
  800958:	8b 40 04             	mov    0x4(%eax),%eax
  80095b:	8d 50 01             	lea    0x1(%eax),%edx
  80095e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800961:	89 50 04             	mov    %edx,0x4(%eax)
}
  800964:	90                   	nop
  800965:	c9                   	leave  
  800966:	c3                   	ret    

00800967 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800967:	55                   	push   %ebp
  800968:	89 e5                	mov    %esp,%ebp
  80096a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800970:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800977:	00 00 00 
	b.cnt = 0;
  80097a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800981:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800984:	ff 75 0c             	pushl  0xc(%ebp)
  800987:	ff 75 08             	pushl  0x8(%ebp)
  80098a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800990:	50                   	push   %eax
  800991:	68 fe 08 80 00       	push   $0x8008fe
  800996:	e8 11 02 00 00       	call   800bac <vprintfmt>
  80099b:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80099e:	a0 24 50 80 00       	mov    0x805024,%al
  8009a3:	0f b6 c0             	movzbl %al,%eax
  8009a6:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8009ac:	83 ec 04             	sub    $0x4,%esp
  8009af:	50                   	push   %eax
  8009b0:	52                   	push   %edx
  8009b1:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009b7:	83 c0 08             	add    $0x8,%eax
  8009ba:	50                   	push   %eax
  8009bb:	e8 61 11 00 00       	call   801b21 <sys_cputs>
  8009c0:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8009c3:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  8009ca:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8009d0:	c9                   	leave  
  8009d1:	c3                   	ret    

008009d2 <cprintf>:

int cprintf(const char *fmt, ...) {
  8009d2:	55                   	push   %ebp
  8009d3:	89 e5                	mov    %esp,%ebp
  8009d5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8009d8:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  8009df:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8009e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e8:	83 ec 08             	sub    $0x8,%esp
  8009eb:	ff 75 f4             	pushl  -0xc(%ebp)
  8009ee:	50                   	push   %eax
  8009ef:	e8 73 ff ff ff       	call   800967 <vcprintf>
  8009f4:	83 c4 10             	add    $0x10,%esp
  8009f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8009fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009fd:	c9                   	leave  
  8009fe:	c3                   	ret    

008009ff <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8009ff:	55                   	push   %ebp
  800a00:	89 e5                	mov    %esp,%ebp
  800a02:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800a05:	e8 c5 12 00 00       	call   801ccf <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800a0a:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a10:	8b 45 08             	mov    0x8(%ebp),%eax
  800a13:	83 ec 08             	sub    $0x8,%esp
  800a16:	ff 75 f4             	pushl  -0xc(%ebp)
  800a19:	50                   	push   %eax
  800a1a:	e8 48 ff ff ff       	call   800967 <vcprintf>
  800a1f:	83 c4 10             	add    $0x10,%esp
  800a22:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800a25:	e8 bf 12 00 00       	call   801ce9 <sys_enable_interrupt>
	return cnt;
  800a2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a2d:	c9                   	leave  
  800a2e:	c3                   	ret    

00800a2f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a2f:	55                   	push   %ebp
  800a30:	89 e5                	mov    %esp,%ebp
  800a32:	53                   	push   %ebx
  800a33:	83 ec 14             	sub    $0x14,%esp
  800a36:	8b 45 10             	mov    0x10(%ebp),%eax
  800a39:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a3c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800a42:	8b 45 18             	mov    0x18(%ebp),%eax
  800a45:	ba 00 00 00 00       	mov    $0x0,%edx
  800a4a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a4d:	77 55                	ja     800aa4 <printnum+0x75>
  800a4f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a52:	72 05                	jb     800a59 <printnum+0x2a>
  800a54:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800a57:	77 4b                	ja     800aa4 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a59:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800a5c:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800a5f:	8b 45 18             	mov    0x18(%ebp),%eax
  800a62:	ba 00 00 00 00       	mov    $0x0,%edx
  800a67:	52                   	push   %edx
  800a68:	50                   	push   %eax
  800a69:	ff 75 f4             	pushl  -0xc(%ebp)
  800a6c:	ff 75 f0             	pushl  -0x10(%ebp)
  800a6f:	e8 e4 2d 00 00       	call   803858 <__udivdi3>
  800a74:	83 c4 10             	add    $0x10,%esp
  800a77:	83 ec 04             	sub    $0x4,%esp
  800a7a:	ff 75 20             	pushl  0x20(%ebp)
  800a7d:	53                   	push   %ebx
  800a7e:	ff 75 18             	pushl  0x18(%ebp)
  800a81:	52                   	push   %edx
  800a82:	50                   	push   %eax
  800a83:	ff 75 0c             	pushl  0xc(%ebp)
  800a86:	ff 75 08             	pushl  0x8(%ebp)
  800a89:	e8 a1 ff ff ff       	call   800a2f <printnum>
  800a8e:	83 c4 20             	add    $0x20,%esp
  800a91:	eb 1a                	jmp    800aad <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800a93:	83 ec 08             	sub    $0x8,%esp
  800a96:	ff 75 0c             	pushl  0xc(%ebp)
  800a99:	ff 75 20             	pushl  0x20(%ebp)
  800a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9f:	ff d0                	call   *%eax
  800aa1:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800aa4:	ff 4d 1c             	decl   0x1c(%ebp)
  800aa7:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800aab:	7f e6                	jg     800a93 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800aad:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800ab0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ab5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ab8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800abb:	53                   	push   %ebx
  800abc:	51                   	push   %ecx
  800abd:	52                   	push   %edx
  800abe:	50                   	push   %eax
  800abf:	e8 a4 2e 00 00       	call   803968 <__umoddi3>
  800ac4:	83 c4 10             	add    $0x10,%esp
  800ac7:	05 34 40 80 00       	add    $0x804034,%eax
  800acc:	8a 00                	mov    (%eax),%al
  800ace:	0f be c0             	movsbl %al,%eax
  800ad1:	83 ec 08             	sub    $0x8,%esp
  800ad4:	ff 75 0c             	pushl  0xc(%ebp)
  800ad7:	50                   	push   %eax
  800ad8:	8b 45 08             	mov    0x8(%ebp),%eax
  800adb:	ff d0                	call   *%eax
  800add:	83 c4 10             	add    $0x10,%esp
}
  800ae0:	90                   	nop
  800ae1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ae4:	c9                   	leave  
  800ae5:	c3                   	ret    

00800ae6 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800ae6:	55                   	push   %ebp
  800ae7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800ae9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800aed:	7e 1c                	jle    800b0b <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800aef:	8b 45 08             	mov    0x8(%ebp),%eax
  800af2:	8b 00                	mov    (%eax),%eax
  800af4:	8d 50 08             	lea    0x8(%eax),%edx
  800af7:	8b 45 08             	mov    0x8(%ebp),%eax
  800afa:	89 10                	mov    %edx,(%eax)
  800afc:	8b 45 08             	mov    0x8(%ebp),%eax
  800aff:	8b 00                	mov    (%eax),%eax
  800b01:	83 e8 08             	sub    $0x8,%eax
  800b04:	8b 50 04             	mov    0x4(%eax),%edx
  800b07:	8b 00                	mov    (%eax),%eax
  800b09:	eb 40                	jmp    800b4b <getuint+0x65>
	else if (lflag)
  800b0b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b0f:	74 1e                	je     800b2f <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800b11:	8b 45 08             	mov    0x8(%ebp),%eax
  800b14:	8b 00                	mov    (%eax),%eax
  800b16:	8d 50 04             	lea    0x4(%eax),%edx
  800b19:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1c:	89 10                	mov    %edx,(%eax)
  800b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b21:	8b 00                	mov    (%eax),%eax
  800b23:	83 e8 04             	sub    $0x4,%eax
  800b26:	8b 00                	mov    (%eax),%eax
  800b28:	ba 00 00 00 00       	mov    $0x0,%edx
  800b2d:	eb 1c                	jmp    800b4b <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b32:	8b 00                	mov    (%eax),%eax
  800b34:	8d 50 04             	lea    0x4(%eax),%edx
  800b37:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3a:	89 10                	mov    %edx,(%eax)
  800b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3f:	8b 00                	mov    (%eax),%eax
  800b41:	83 e8 04             	sub    $0x4,%eax
  800b44:	8b 00                	mov    (%eax),%eax
  800b46:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800b4b:	5d                   	pop    %ebp
  800b4c:	c3                   	ret    

00800b4d <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800b4d:	55                   	push   %ebp
  800b4e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b50:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b54:	7e 1c                	jle    800b72 <getint+0x25>
		return va_arg(*ap, long long);
  800b56:	8b 45 08             	mov    0x8(%ebp),%eax
  800b59:	8b 00                	mov    (%eax),%eax
  800b5b:	8d 50 08             	lea    0x8(%eax),%edx
  800b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b61:	89 10                	mov    %edx,(%eax)
  800b63:	8b 45 08             	mov    0x8(%ebp),%eax
  800b66:	8b 00                	mov    (%eax),%eax
  800b68:	83 e8 08             	sub    $0x8,%eax
  800b6b:	8b 50 04             	mov    0x4(%eax),%edx
  800b6e:	8b 00                	mov    (%eax),%eax
  800b70:	eb 38                	jmp    800baa <getint+0x5d>
	else if (lflag)
  800b72:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b76:	74 1a                	je     800b92 <getint+0x45>
		return va_arg(*ap, long);
  800b78:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7b:	8b 00                	mov    (%eax),%eax
  800b7d:	8d 50 04             	lea    0x4(%eax),%edx
  800b80:	8b 45 08             	mov    0x8(%ebp),%eax
  800b83:	89 10                	mov    %edx,(%eax)
  800b85:	8b 45 08             	mov    0x8(%ebp),%eax
  800b88:	8b 00                	mov    (%eax),%eax
  800b8a:	83 e8 04             	sub    $0x4,%eax
  800b8d:	8b 00                	mov    (%eax),%eax
  800b8f:	99                   	cltd   
  800b90:	eb 18                	jmp    800baa <getint+0x5d>
	else
		return va_arg(*ap, int);
  800b92:	8b 45 08             	mov    0x8(%ebp),%eax
  800b95:	8b 00                	mov    (%eax),%eax
  800b97:	8d 50 04             	lea    0x4(%eax),%edx
  800b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9d:	89 10                	mov    %edx,(%eax)
  800b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba2:	8b 00                	mov    (%eax),%eax
  800ba4:	83 e8 04             	sub    $0x4,%eax
  800ba7:	8b 00                	mov    (%eax),%eax
  800ba9:	99                   	cltd   
}
  800baa:	5d                   	pop    %ebp
  800bab:	c3                   	ret    

00800bac <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800bac:	55                   	push   %ebp
  800bad:	89 e5                	mov    %esp,%ebp
  800baf:	56                   	push   %esi
  800bb0:	53                   	push   %ebx
  800bb1:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bb4:	eb 17                	jmp    800bcd <vprintfmt+0x21>
			if (ch == '\0')
  800bb6:	85 db                	test   %ebx,%ebx
  800bb8:	0f 84 af 03 00 00    	je     800f6d <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800bbe:	83 ec 08             	sub    $0x8,%esp
  800bc1:	ff 75 0c             	pushl  0xc(%ebp)
  800bc4:	53                   	push   %ebx
  800bc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc8:	ff d0                	call   *%eax
  800bca:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bcd:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd0:	8d 50 01             	lea    0x1(%eax),%edx
  800bd3:	89 55 10             	mov    %edx,0x10(%ebp)
  800bd6:	8a 00                	mov    (%eax),%al
  800bd8:	0f b6 d8             	movzbl %al,%ebx
  800bdb:	83 fb 25             	cmp    $0x25,%ebx
  800bde:	75 d6                	jne    800bb6 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800be0:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800be4:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800beb:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800bf2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800bf9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c00:	8b 45 10             	mov    0x10(%ebp),%eax
  800c03:	8d 50 01             	lea    0x1(%eax),%edx
  800c06:	89 55 10             	mov    %edx,0x10(%ebp)
  800c09:	8a 00                	mov    (%eax),%al
  800c0b:	0f b6 d8             	movzbl %al,%ebx
  800c0e:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800c11:	83 f8 55             	cmp    $0x55,%eax
  800c14:	0f 87 2b 03 00 00    	ja     800f45 <vprintfmt+0x399>
  800c1a:	8b 04 85 58 40 80 00 	mov    0x804058(,%eax,4),%eax
  800c21:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800c23:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800c27:	eb d7                	jmp    800c00 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c29:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800c2d:	eb d1                	jmp    800c00 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c2f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800c36:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c39:	89 d0                	mov    %edx,%eax
  800c3b:	c1 e0 02             	shl    $0x2,%eax
  800c3e:	01 d0                	add    %edx,%eax
  800c40:	01 c0                	add    %eax,%eax
  800c42:	01 d8                	add    %ebx,%eax
  800c44:	83 e8 30             	sub    $0x30,%eax
  800c47:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800c4a:	8b 45 10             	mov    0x10(%ebp),%eax
  800c4d:	8a 00                	mov    (%eax),%al
  800c4f:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c52:	83 fb 2f             	cmp    $0x2f,%ebx
  800c55:	7e 3e                	jle    800c95 <vprintfmt+0xe9>
  800c57:	83 fb 39             	cmp    $0x39,%ebx
  800c5a:	7f 39                	jg     800c95 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c5c:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c5f:	eb d5                	jmp    800c36 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800c61:	8b 45 14             	mov    0x14(%ebp),%eax
  800c64:	83 c0 04             	add    $0x4,%eax
  800c67:	89 45 14             	mov    %eax,0x14(%ebp)
  800c6a:	8b 45 14             	mov    0x14(%ebp),%eax
  800c6d:	83 e8 04             	sub    $0x4,%eax
  800c70:	8b 00                	mov    (%eax),%eax
  800c72:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800c75:	eb 1f                	jmp    800c96 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800c77:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c7b:	79 83                	jns    800c00 <vprintfmt+0x54>
				width = 0;
  800c7d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800c84:	e9 77 ff ff ff       	jmp    800c00 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800c89:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800c90:	e9 6b ff ff ff       	jmp    800c00 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800c95:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800c96:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c9a:	0f 89 60 ff ff ff    	jns    800c00 <vprintfmt+0x54>
				width = precision, precision = -1;
  800ca0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ca3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800ca6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800cad:	e9 4e ff ff ff       	jmp    800c00 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800cb2:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800cb5:	e9 46 ff ff ff       	jmp    800c00 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800cba:	8b 45 14             	mov    0x14(%ebp),%eax
  800cbd:	83 c0 04             	add    $0x4,%eax
  800cc0:	89 45 14             	mov    %eax,0x14(%ebp)
  800cc3:	8b 45 14             	mov    0x14(%ebp),%eax
  800cc6:	83 e8 04             	sub    $0x4,%eax
  800cc9:	8b 00                	mov    (%eax),%eax
  800ccb:	83 ec 08             	sub    $0x8,%esp
  800cce:	ff 75 0c             	pushl  0xc(%ebp)
  800cd1:	50                   	push   %eax
  800cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd5:	ff d0                	call   *%eax
  800cd7:	83 c4 10             	add    $0x10,%esp
			break;
  800cda:	e9 89 02 00 00       	jmp    800f68 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800cdf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ce2:	83 c0 04             	add    $0x4,%eax
  800ce5:	89 45 14             	mov    %eax,0x14(%ebp)
  800ce8:	8b 45 14             	mov    0x14(%ebp),%eax
  800ceb:	83 e8 04             	sub    $0x4,%eax
  800cee:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800cf0:	85 db                	test   %ebx,%ebx
  800cf2:	79 02                	jns    800cf6 <vprintfmt+0x14a>
				err = -err;
  800cf4:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800cf6:	83 fb 64             	cmp    $0x64,%ebx
  800cf9:	7f 0b                	jg     800d06 <vprintfmt+0x15a>
  800cfb:	8b 34 9d a0 3e 80 00 	mov    0x803ea0(,%ebx,4),%esi
  800d02:	85 f6                	test   %esi,%esi
  800d04:	75 19                	jne    800d1f <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d06:	53                   	push   %ebx
  800d07:	68 45 40 80 00       	push   $0x804045
  800d0c:	ff 75 0c             	pushl  0xc(%ebp)
  800d0f:	ff 75 08             	pushl  0x8(%ebp)
  800d12:	e8 5e 02 00 00       	call   800f75 <printfmt>
  800d17:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d1a:	e9 49 02 00 00       	jmp    800f68 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d1f:	56                   	push   %esi
  800d20:	68 4e 40 80 00       	push   $0x80404e
  800d25:	ff 75 0c             	pushl  0xc(%ebp)
  800d28:	ff 75 08             	pushl  0x8(%ebp)
  800d2b:	e8 45 02 00 00       	call   800f75 <printfmt>
  800d30:	83 c4 10             	add    $0x10,%esp
			break;
  800d33:	e9 30 02 00 00       	jmp    800f68 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800d38:	8b 45 14             	mov    0x14(%ebp),%eax
  800d3b:	83 c0 04             	add    $0x4,%eax
  800d3e:	89 45 14             	mov    %eax,0x14(%ebp)
  800d41:	8b 45 14             	mov    0x14(%ebp),%eax
  800d44:	83 e8 04             	sub    $0x4,%eax
  800d47:	8b 30                	mov    (%eax),%esi
  800d49:	85 f6                	test   %esi,%esi
  800d4b:	75 05                	jne    800d52 <vprintfmt+0x1a6>
				p = "(null)";
  800d4d:	be 51 40 80 00       	mov    $0x804051,%esi
			if (width > 0 && padc != '-')
  800d52:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d56:	7e 6d                	jle    800dc5 <vprintfmt+0x219>
  800d58:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800d5c:	74 67                	je     800dc5 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d5e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d61:	83 ec 08             	sub    $0x8,%esp
  800d64:	50                   	push   %eax
  800d65:	56                   	push   %esi
  800d66:	e8 0c 03 00 00       	call   801077 <strnlen>
  800d6b:	83 c4 10             	add    $0x10,%esp
  800d6e:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800d71:	eb 16                	jmp    800d89 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800d73:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800d77:	83 ec 08             	sub    $0x8,%esp
  800d7a:	ff 75 0c             	pushl  0xc(%ebp)
  800d7d:	50                   	push   %eax
  800d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d81:	ff d0                	call   *%eax
  800d83:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d86:	ff 4d e4             	decl   -0x1c(%ebp)
  800d89:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d8d:	7f e4                	jg     800d73 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d8f:	eb 34                	jmp    800dc5 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800d91:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800d95:	74 1c                	je     800db3 <vprintfmt+0x207>
  800d97:	83 fb 1f             	cmp    $0x1f,%ebx
  800d9a:	7e 05                	jle    800da1 <vprintfmt+0x1f5>
  800d9c:	83 fb 7e             	cmp    $0x7e,%ebx
  800d9f:	7e 12                	jle    800db3 <vprintfmt+0x207>
					putch('?', putdat);
  800da1:	83 ec 08             	sub    $0x8,%esp
  800da4:	ff 75 0c             	pushl  0xc(%ebp)
  800da7:	6a 3f                	push   $0x3f
  800da9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dac:	ff d0                	call   *%eax
  800dae:	83 c4 10             	add    $0x10,%esp
  800db1:	eb 0f                	jmp    800dc2 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800db3:	83 ec 08             	sub    $0x8,%esp
  800db6:	ff 75 0c             	pushl  0xc(%ebp)
  800db9:	53                   	push   %ebx
  800dba:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbd:	ff d0                	call   *%eax
  800dbf:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800dc2:	ff 4d e4             	decl   -0x1c(%ebp)
  800dc5:	89 f0                	mov    %esi,%eax
  800dc7:	8d 70 01             	lea    0x1(%eax),%esi
  800dca:	8a 00                	mov    (%eax),%al
  800dcc:	0f be d8             	movsbl %al,%ebx
  800dcf:	85 db                	test   %ebx,%ebx
  800dd1:	74 24                	je     800df7 <vprintfmt+0x24b>
  800dd3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800dd7:	78 b8                	js     800d91 <vprintfmt+0x1e5>
  800dd9:	ff 4d e0             	decl   -0x20(%ebp)
  800ddc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800de0:	79 af                	jns    800d91 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800de2:	eb 13                	jmp    800df7 <vprintfmt+0x24b>
				putch(' ', putdat);
  800de4:	83 ec 08             	sub    $0x8,%esp
  800de7:	ff 75 0c             	pushl  0xc(%ebp)
  800dea:	6a 20                	push   $0x20
  800dec:	8b 45 08             	mov    0x8(%ebp),%eax
  800def:	ff d0                	call   *%eax
  800df1:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800df4:	ff 4d e4             	decl   -0x1c(%ebp)
  800df7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dfb:	7f e7                	jg     800de4 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800dfd:	e9 66 01 00 00       	jmp    800f68 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800e02:	83 ec 08             	sub    $0x8,%esp
  800e05:	ff 75 e8             	pushl  -0x18(%ebp)
  800e08:	8d 45 14             	lea    0x14(%ebp),%eax
  800e0b:	50                   	push   %eax
  800e0c:	e8 3c fd ff ff       	call   800b4d <getint>
  800e11:	83 c4 10             	add    $0x10,%esp
  800e14:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e17:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800e1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e1d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e20:	85 d2                	test   %edx,%edx
  800e22:	79 23                	jns    800e47 <vprintfmt+0x29b>
				putch('-', putdat);
  800e24:	83 ec 08             	sub    $0x8,%esp
  800e27:	ff 75 0c             	pushl  0xc(%ebp)
  800e2a:	6a 2d                	push   $0x2d
  800e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2f:	ff d0                	call   *%eax
  800e31:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800e34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e37:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e3a:	f7 d8                	neg    %eax
  800e3c:	83 d2 00             	adc    $0x0,%edx
  800e3f:	f7 da                	neg    %edx
  800e41:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e44:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800e47:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e4e:	e9 bc 00 00 00       	jmp    800f0f <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800e53:	83 ec 08             	sub    $0x8,%esp
  800e56:	ff 75 e8             	pushl  -0x18(%ebp)
  800e59:	8d 45 14             	lea    0x14(%ebp),%eax
  800e5c:	50                   	push   %eax
  800e5d:	e8 84 fc ff ff       	call   800ae6 <getuint>
  800e62:	83 c4 10             	add    $0x10,%esp
  800e65:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e68:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800e6b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e72:	e9 98 00 00 00       	jmp    800f0f <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800e77:	83 ec 08             	sub    $0x8,%esp
  800e7a:	ff 75 0c             	pushl  0xc(%ebp)
  800e7d:	6a 58                	push   $0x58
  800e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e82:	ff d0                	call   *%eax
  800e84:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e87:	83 ec 08             	sub    $0x8,%esp
  800e8a:	ff 75 0c             	pushl  0xc(%ebp)
  800e8d:	6a 58                	push   $0x58
  800e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e92:	ff d0                	call   *%eax
  800e94:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e97:	83 ec 08             	sub    $0x8,%esp
  800e9a:	ff 75 0c             	pushl  0xc(%ebp)
  800e9d:	6a 58                	push   $0x58
  800e9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea2:	ff d0                	call   *%eax
  800ea4:	83 c4 10             	add    $0x10,%esp
			break;
  800ea7:	e9 bc 00 00 00       	jmp    800f68 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800eac:	83 ec 08             	sub    $0x8,%esp
  800eaf:	ff 75 0c             	pushl  0xc(%ebp)
  800eb2:	6a 30                	push   $0x30
  800eb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb7:	ff d0                	call   *%eax
  800eb9:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ebc:	83 ec 08             	sub    $0x8,%esp
  800ebf:	ff 75 0c             	pushl  0xc(%ebp)
  800ec2:	6a 78                	push   $0x78
  800ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec7:	ff d0                	call   *%eax
  800ec9:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ecc:	8b 45 14             	mov    0x14(%ebp),%eax
  800ecf:	83 c0 04             	add    $0x4,%eax
  800ed2:	89 45 14             	mov    %eax,0x14(%ebp)
  800ed5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ed8:	83 e8 04             	sub    $0x4,%eax
  800edb:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800edd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ee0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800ee7:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800eee:	eb 1f                	jmp    800f0f <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ef0:	83 ec 08             	sub    $0x8,%esp
  800ef3:	ff 75 e8             	pushl  -0x18(%ebp)
  800ef6:	8d 45 14             	lea    0x14(%ebp),%eax
  800ef9:	50                   	push   %eax
  800efa:	e8 e7 fb ff ff       	call   800ae6 <getuint>
  800eff:	83 c4 10             	add    $0x10,%esp
  800f02:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f05:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800f08:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f0f:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800f13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f16:	83 ec 04             	sub    $0x4,%esp
  800f19:	52                   	push   %edx
  800f1a:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f1d:	50                   	push   %eax
  800f1e:	ff 75 f4             	pushl  -0xc(%ebp)
  800f21:	ff 75 f0             	pushl  -0x10(%ebp)
  800f24:	ff 75 0c             	pushl  0xc(%ebp)
  800f27:	ff 75 08             	pushl  0x8(%ebp)
  800f2a:	e8 00 fb ff ff       	call   800a2f <printnum>
  800f2f:	83 c4 20             	add    $0x20,%esp
			break;
  800f32:	eb 34                	jmp    800f68 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f34:	83 ec 08             	sub    $0x8,%esp
  800f37:	ff 75 0c             	pushl  0xc(%ebp)
  800f3a:	53                   	push   %ebx
  800f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3e:	ff d0                	call   *%eax
  800f40:	83 c4 10             	add    $0x10,%esp
			break;
  800f43:	eb 23                	jmp    800f68 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f45:	83 ec 08             	sub    $0x8,%esp
  800f48:	ff 75 0c             	pushl  0xc(%ebp)
  800f4b:	6a 25                	push   $0x25
  800f4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f50:	ff d0                	call   *%eax
  800f52:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f55:	ff 4d 10             	decl   0x10(%ebp)
  800f58:	eb 03                	jmp    800f5d <vprintfmt+0x3b1>
  800f5a:	ff 4d 10             	decl   0x10(%ebp)
  800f5d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f60:	48                   	dec    %eax
  800f61:	8a 00                	mov    (%eax),%al
  800f63:	3c 25                	cmp    $0x25,%al
  800f65:	75 f3                	jne    800f5a <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800f67:	90                   	nop
		}
	}
  800f68:	e9 47 fc ff ff       	jmp    800bb4 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800f6d:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800f6e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f71:	5b                   	pop    %ebx
  800f72:	5e                   	pop    %esi
  800f73:	5d                   	pop    %ebp
  800f74:	c3                   	ret    

00800f75 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f75:	55                   	push   %ebp
  800f76:	89 e5                	mov    %esp,%ebp
  800f78:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800f7b:	8d 45 10             	lea    0x10(%ebp),%eax
  800f7e:	83 c0 04             	add    $0x4,%eax
  800f81:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800f84:	8b 45 10             	mov    0x10(%ebp),%eax
  800f87:	ff 75 f4             	pushl  -0xc(%ebp)
  800f8a:	50                   	push   %eax
  800f8b:	ff 75 0c             	pushl  0xc(%ebp)
  800f8e:	ff 75 08             	pushl  0x8(%ebp)
  800f91:	e8 16 fc ff ff       	call   800bac <vprintfmt>
  800f96:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800f99:	90                   	nop
  800f9a:	c9                   	leave  
  800f9b:	c3                   	ret    

00800f9c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f9c:	55                   	push   %ebp
  800f9d:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800f9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa2:	8b 40 08             	mov    0x8(%eax),%eax
  800fa5:	8d 50 01             	lea    0x1(%eax),%edx
  800fa8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fab:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800fae:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb1:	8b 10                	mov    (%eax),%edx
  800fb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb6:	8b 40 04             	mov    0x4(%eax),%eax
  800fb9:	39 c2                	cmp    %eax,%edx
  800fbb:	73 12                	jae    800fcf <sprintputch+0x33>
		*b->buf++ = ch;
  800fbd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc0:	8b 00                	mov    (%eax),%eax
  800fc2:	8d 48 01             	lea    0x1(%eax),%ecx
  800fc5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fc8:	89 0a                	mov    %ecx,(%edx)
  800fca:	8b 55 08             	mov    0x8(%ebp),%edx
  800fcd:	88 10                	mov    %dl,(%eax)
}
  800fcf:	90                   	nop
  800fd0:	5d                   	pop    %ebp
  800fd1:	c3                   	ret    

00800fd2 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800fd2:	55                   	push   %ebp
  800fd3:	89 e5                	mov    %esp,%ebp
  800fd5:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800fde:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe1:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fe4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe7:	01 d0                	add    %edx,%eax
  800fe9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ff3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ff7:	74 06                	je     800fff <vsnprintf+0x2d>
  800ff9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ffd:	7f 07                	jg     801006 <vsnprintf+0x34>
		return -E_INVAL;
  800fff:	b8 03 00 00 00       	mov    $0x3,%eax
  801004:	eb 20                	jmp    801026 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801006:	ff 75 14             	pushl  0x14(%ebp)
  801009:	ff 75 10             	pushl  0x10(%ebp)
  80100c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80100f:	50                   	push   %eax
  801010:	68 9c 0f 80 00       	push   $0x800f9c
  801015:	e8 92 fb ff ff       	call   800bac <vprintfmt>
  80101a:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80101d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801020:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801023:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801026:	c9                   	leave  
  801027:	c3                   	ret    

00801028 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801028:	55                   	push   %ebp
  801029:	89 e5                	mov    %esp,%ebp
  80102b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80102e:	8d 45 10             	lea    0x10(%ebp),%eax
  801031:	83 c0 04             	add    $0x4,%eax
  801034:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801037:	8b 45 10             	mov    0x10(%ebp),%eax
  80103a:	ff 75 f4             	pushl  -0xc(%ebp)
  80103d:	50                   	push   %eax
  80103e:	ff 75 0c             	pushl  0xc(%ebp)
  801041:	ff 75 08             	pushl  0x8(%ebp)
  801044:	e8 89 ff ff ff       	call   800fd2 <vsnprintf>
  801049:	83 c4 10             	add    $0x10,%esp
  80104c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80104f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801052:	c9                   	leave  
  801053:	c3                   	ret    

00801054 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801054:	55                   	push   %ebp
  801055:	89 e5                	mov    %esp,%ebp
  801057:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80105a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801061:	eb 06                	jmp    801069 <strlen+0x15>
		n++;
  801063:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801066:	ff 45 08             	incl   0x8(%ebp)
  801069:	8b 45 08             	mov    0x8(%ebp),%eax
  80106c:	8a 00                	mov    (%eax),%al
  80106e:	84 c0                	test   %al,%al
  801070:	75 f1                	jne    801063 <strlen+0xf>
		n++;
	return n;
  801072:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801075:	c9                   	leave  
  801076:	c3                   	ret    

00801077 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801077:	55                   	push   %ebp
  801078:	89 e5                	mov    %esp,%ebp
  80107a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80107d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801084:	eb 09                	jmp    80108f <strnlen+0x18>
		n++;
  801086:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801089:	ff 45 08             	incl   0x8(%ebp)
  80108c:	ff 4d 0c             	decl   0xc(%ebp)
  80108f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801093:	74 09                	je     80109e <strnlen+0x27>
  801095:	8b 45 08             	mov    0x8(%ebp),%eax
  801098:	8a 00                	mov    (%eax),%al
  80109a:	84 c0                	test   %al,%al
  80109c:	75 e8                	jne    801086 <strnlen+0xf>
		n++;
	return n;
  80109e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010a1:	c9                   	leave  
  8010a2:	c3                   	ret    

008010a3 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8010a3:	55                   	push   %ebp
  8010a4:	89 e5                	mov    %esp,%ebp
  8010a6:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8010a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ac:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8010af:	90                   	nop
  8010b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b3:	8d 50 01             	lea    0x1(%eax),%edx
  8010b6:	89 55 08             	mov    %edx,0x8(%ebp)
  8010b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010bc:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010bf:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8010c2:	8a 12                	mov    (%edx),%dl
  8010c4:	88 10                	mov    %dl,(%eax)
  8010c6:	8a 00                	mov    (%eax),%al
  8010c8:	84 c0                	test   %al,%al
  8010ca:	75 e4                	jne    8010b0 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8010cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010cf:	c9                   	leave  
  8010d0:	c3                   	ret    

008010d1 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8010d1:	55                   	push   %ebp
  8010d2:	89 e5                	mov    %esp,%ebp
  8010d4:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8010d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010da:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8010dd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010e4:	eb 1f                	jmp    801105 <strncpy+0x34>
		*dst++ = *src;
  8010e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e9:	8d 50 01             	lea    0x1(%eax),%edx
  8010ec:	89 55 08             	mov    %edx,0x8(%ebp)
  8010ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010f2:	8a 12                	mov    (%edx),%dl
  8010f4:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8010f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f9:	8a 00                	mov    (%eax),%al
  8010fb:	84 c0                	test   %al,%al
  8010fd:	74 03                	je     801102 <strncpy+0x31>
			src++;
  8010ff:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801102:	ff 45 fc             	incl   -0x4(%ebp)
  801105:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801108:	3b 45 10             	cmp    0x10(%ebp),%eax
  80110b:	72 d9                	jb     8010e6 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80110d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801110:	c9                   	leave  
  801111:	c3                   	ret    

00801112 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801112:	55                   	push   %ebp
  801113:	89 e5                	mov    %esp,%ebp
  801115:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801118:	8b 45 08             	mov    0x8(%ebp),%eax
  80111b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80111e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801122:	74 30                	je     801154 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801124:	eb 16                	jmp    80113c <strlcpy+0x2a>
			*dst++ = *src++;
  801126:	8b 45 08             	mov    0x8(%ebp),%eax
  801129:	8d 50 01             	lea    0x1(%eax),%edx
  80112c:	89 55 08             	mov    %edx,0x8(%ebp)
  80112f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801132:	8d 4a 01             	lea    0x1(%edx),%ecx
  801135:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801138:	8a 12                	mov    (%edx),%dl
  80113a:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80113c:	ff 4d 10             	decl   0x10(%ebp)
  80113f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801143:	74 09                	je     80114e <strlcpy+0x3c>
  801145:	8b 45 0c             	mov    0xc(%ebp),%eax
  801148:	8a 00                	mov    (%eax),%al
  80114a:	84 c0                	test   %al,%al
  80114c:	75 d8                	jne    801126 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80114e:	8b 45 08             	mov    0x8(%ebp),%eax
  801151:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801154:	8b 55 08             	mov    0x8(%ebp),%edx
  801157:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80115a:	29 c2                	sub    %eax,%edx
  80115c:	89 d0                	mov    %edx,%eax
}
  80115e:	c9                   	leave  
  80115f:	c3                   	ret    

00801160 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801160:	55                   	push   %ebp
  801161:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801163:	eb 06                	jmp    80116b <strcmp+0xb>
		p++, q++;
  801165:	ff 45 08             	incl   0x8(%ebp)
  801168:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80116b:	8b 45 08             	mov    0x8(%ebp),%eax
  80116e:	8a 00                	mov    (%eax),%al
  801170:	84 c0                	test   %al,%al
  801172:	74 0e                	je     801182 <strcmp+0x22>
  801174:	8b 45 08             	mov    0x8(%ebp),%eax
  801177:	8a 10                	mov    (%eax),%dl
  801179:	8b 45 0c             	mov    0xc(%ebp),%eax
  80117c:	8a 00                	mov    (%eax),%al
  80117e:	38 c2                	cmp    %al,%dl
  801180:	74 e3                	je     801165 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801182:	8b 45 08             	mov    0x8(%ebp),%eax
  801185:	8a 00                	mov    (%eax),%al
  801187:	0f b6 d0             	movzbl %al,%edx
  80118a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118d:	8a 00                	mov    (%eax),%al
  80118f:	0f b6 c0             	movzbl %al,%eax
  801192:	29 c2                	sub    %eax,%edx
  801194:	89 d0                	mov    %edx,%eax
}
  801196:	5d                   	pop    %ebp
  801197:	c3                   	ret    

00801198 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801198:	55                   	push   %ebp
  801199:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80119b:	eb 09                	jmp    8011a6 <strncmp+0xe>
		n--, p++, q++;
  80119d:	ff 4d 10             	decl   0x10(%ebp)
  8011a0:	ff 45 08             	incl   0x8(%ebp)
  8011a3:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8011a6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011aa:	74 17                	je     8011c3 <strncmp+0x2b>
  8011ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8011af:	8a 00                	mov    (%eax),%al
  8011b1:	84 c0                	test   %al,%al
  8011b3:	74 0e                	je     8011c3 <strncmp+0x2b>
  8011b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b8:	8a 10                	mov    (%eax),%dl
  8011ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011bd:	8a 00                	mov    (%eax),%al
  8011bf:	38 c2                	cmp    %al,%dl
  8011c1:	74 da                	je     80119d <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8011c3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011c7:	75 07                	jne    8011d0 <strncmp+0x38>
		return 0;
  8011c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8011ce:	eb 14                	jmp    8011e4 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8011d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d3:	8a 00                	mov    (%eax),%al
  8011d5:	0f b6 d0             	movzbl %al,%edx
  8011d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011db:	8a 00                	mov    (%eax),%al
  8011dd:	0f b6 c0             	movzbl %al,%eax
  8011e0:	29 c2                	sub    %eax,%edx
  8011e2:	89 d0                	mov    %edx,%eax
}
  8011e4:	5d                   	pop    %ebp
  8011e5:	c3                   	ret    

008011e6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8011e6:	55                   	push   %ebp
  8011e7:	89 e5                	mov    %esp,%ebp
  8011e9:	83 ec 04             	sub    $0x4,%esp
  8011ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ef:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011f2:	eb 12                	jmp    801206 <strchr+0x20>
		if (*s == c)
  8011f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f7:	8a 00                	mov    (%eax),%al
  8011f9:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011fc:	75 05                	jne    801203 <strchr+0x1d>
			return (char *) s;
  8011fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801201:	eb 11                	jmp    801214 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801203:	ff 45 08             	incl   0x8(%ebp)
  801206:	8b 45 08             	mov    0x8(%ebp),%eax
  801209:	8a 00                	mov    (%eax),%al
  80120b:	84 c0                	test   %al,%al
  80120d:	75 e5                	jne    8011f4 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80120f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801214:	c9                   	leave  
  801215:	c3                   	ret    

00801216 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801216:	55                   	push   %ebp
  801217:	89 e5                	mov    %esp,%ebp
  801219:	83 ec 04             	sub    $0x4,%esp
  80121c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801222:	eb 0d                	jmp    801231 <strfind+0x1b>
		if (*s == c)
  801224:	8b 45 08             	mov    0x8(%ebp),%eax
  801227:	8a 00                	mov    (%eax),%al
  801229:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80122c:	74 0e                	je     80123c <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80122e:	ff 45 08             	incl   0x8(%ebp)
  801231:	8b 45 08             	mov    0x8(%ebp),%eax
  801234:	8a 00                	mov    (%eax),%al
  801236:	84 c0                	test   %al,%al
  801238:	75 ea                	jne    801224 <strfind+0xe>
  80123a:	eb 01                	jmp    80123d <strfind+0x27>
		if (*s == c)
			break;
  80123c:	90                   	nop
	return (char *) s;
  80123d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801240:	c9                   	leave  
  801241:	c3                   	ret    

00801242 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801242:	55                   	push   %ebp
  801243:	89 e5                	mov    %esp,%ebp
  801245:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801248:	8b 45 08             	mov    0x8(%ebp),%eax
  80124b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  80124e:	8b 45 10             	mov    0x10(%ebp),%eax
  801251:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801254:	eb 0e                	jmp    801264 <memset+0x22>
		*p++ = c;
  801256:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801259:	8d 50 01             	lea    0x1(%eax),%edx
  80125c:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80125f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801262:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801264:	ff 4d f8             	decl   -0x8(%ebp)
  801267:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80126b:	79 e9                	jns    801256 <memset+0x14>
		*p++ = c;

	return v;
  80126d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801270:	c9                   	leave  
  801271:	c3                   	ret    

00801272 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801272:	55                   	push   %ebp
  801273:	89 e5                	mov    %esp,%ebp
  801275:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801278:	8b 45 0c             	mov    0xc(%ebp),%eax
  80127b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80127e:	8b 45 08             	mov    0x8(%ebp),%eax
  801281:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801284:	eb 16                	jmp    80129c <memcpy+0x2a>
		*d++ = *s++;
  801286:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801289:	8d 50 01             	lea    0x1(%eax),%edx
  80128c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80128f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801292:	8d 4a 01             	lea    0x1(%edx),%ecx
  801295:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801298:	8a 12                	mov    (%edx),%dl
  80129a:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80129c:	8b 45 10             	mov    0x10(%ebp),%eax
  80129f:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012a2:	89 55 10             	mov    %edx,0x10(%ebp)
  8012a5:	85 c0                	test   %eax,%eax
  8012a7:	75 dd                	jne    801286 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8012a9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012ac:	c9                   	leave  
  8012ad:	c3                   	ret    

008012ae <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8012ae:	55                   	push   %ebp
  8012af:	89 e5                	mov    %esp,%ebp
  8012b1:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8012b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8012ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8012c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012c3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8012c6:	73 50                	jae    801318 <memmove+0x6a>
  8012c8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ce:	01 d0                	add    %edx,%eax
  8012d0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8012d3:	76 43                	jbe    801318 <memmove+0x6a>
		s += n;
  8012d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d8:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8012db:	8b 45 10             	mov    0x10(%ebp),%eax
  8012de:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8012e1:	eb 10                	jmp    8012f3 <memmove+0x45>
			*--d = *--s;
  8012e3:	ff 4d f8             	decl   -0x8(%ebp)
  8012e6:	ff 4d fc             	decl   -0x4(%ebp)
  8012e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012ec:	8a 10                	mov    (%eax),%dl
  8012ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012f1:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8012f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012f9:	89 55 10             	mov    %edx,0x10(%ebp)
  8012fc:	85 c0                	test   %eax,%eax
  8012fe:	75 e3                	jne    8012e3 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801300:	eb 23                	jmp    801325 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801302:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801305:	8d 50 01             	lea    0x1(%eax),%edx
  801308:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80130b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80130e:	8d 4a 01             	lea    0x1(%edx),%ecx
  801311:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801314:	8a 12                	mov    (%edx),%dl
  801316:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801318:	8b 45 10             	mov    0x10(%ebp),%eax
  80131b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80131e:	89 55 10             	mov    %edx,0x10(%ebp)
  801321:	85 c0                	test   %eax,%eax
  801323:	75 dd                	jne    801302 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801325:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801328:	c9                   	leave  
  801329:	c3                   	ret    

0080132a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80132a:	55                   	push   %ebp
  80132b:	89 e5                	mov    %esp,%ebp
  80132d:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801330:	8b 45 08             	mov    0x8(%ebp),%eax
  801333:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801336:	8b 45 0c             	mov    0xc(%ebp),%eax
  801339:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80133c:	eb 2a                	jmp    801368 <memcmp+0x3e>
		if (*s1 != *s2)
  80133e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801341:	8a 10                	mov    (%eax),%dl
  801343:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801346:	8a 00                	mov    (%eax),%al
  801348:	38 c2                	cmp    %al,%dl
  80134a:	74 16                	je     801362 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80134c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80134f:	8a 00                	mov    (%eax),%al
  801351:	0f b6 d0             	movzbl %al,%edx
  801354:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801357:	8a 00                	mov    (%eax),%al
  801359:	0f b6 c0             	movzbl %al,%eax
  80135c:	29 c2                	sub    %eax,%edx
  80135e:	89 d0                	mov    %edx,%eax
  801360:	eb 18                	jmp    80137a <memcmp+0x50>
		s1++, s2++;
  801362:	ff 45 fc             	incl   -0x4(%ebp)
  801365:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801368:	8b 45 10             	mov    0x10(%ebp),%eax
  80136b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80136e:	89 55 10             	mov    %edx,0x10(%ebp)
  801371:	85 c0                	test   %eax,%eax
  801373:	75 c9                	jne    80133e <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801375:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80137a:	c9                   	leave  
  80137b:	c3                   	ret    

0080137c <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80137c:	55                   	push   %ebp
  80137d:	89 e5                	mov    %esp,%ebp
  80137f:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801382:	8b 55 08             	mov    0x8(%ebp),%edx
  801385:	8b 45 10             	mov    0x10(%ebp),%eax
  801388:	01 d0                	add    %edx,%eax
  80138a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80138d:	eb 15                	jmp    8013a4 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80138f:	8b 45 08             	mov    0x8(%ebp),%eax
  801392:	8a 00                	mov    (%eax),%al
  801394:	0f b6 d0             	movzbl %al,%edx
  801397:	8b 45 0c             	mov    0xc(%ebp),%eax
  80139a:	0f b6 c0             	movzbl %al,%eax
  80139d:	39 c2                	cmp    %eax,%edx
  80139f:	74 0d                	je     8013ae <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8013a1:	ff 45 08             	incl   0x8(%ebp)
  8013a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8013aa:	72 e3                	jb     80138f <memfind+0x13>
  8013ac:	eb 01                	jmp    8013af <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8013ae:	90                   	nop
	return (void *) s;
  8013af:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013b2:	c9                   	leave  
  8013b3:	c3                   	ret    

008013b4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8013b4:	55                   	push   %ebp
  8013b5:	89 e5                	mov    %esp,%ebp
  8013b7:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8013ba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8013c1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013c8:	eb 03                	jmp    8013cd <strtol+0x19>
		s++;
  8013ca:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d0:	8a 00                	mov    (%eax),%al
  8013d2:	3c 20                	cmp    $0x20,%al
  8013d4:	74 f4                	je     8013ca <strtol+0x16>
  8013d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d9:	8a 00                	mov    (%eax),%al
  8013db:	3c 09                	cmp    $0x9,%al
  8013dd:	74 eb                	je     8013ca <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8013df:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e2:	8a 00                	mov    (%eax),%al
  8013e4:	3c 2b                	cmp    $0x2b,%al
  8013e6:	75 05                	jne    8013ed <strtol+0x39>
		s++;
  8013e8:	ff 45 08             	incl   0x8(%ebp)
  8013eb:	eb 13                	jmp    801400 <strtol+0x4c>
	else if (*s == '-')
  8013ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f0:	8a 00                	mov    (%eax),%al
  8013f2:	3c 2d                	cmp    $0x2d,%al
  8013f4:	75 0a                	jne    801400 <strtol+0x4c>
		s++, neg = 1;
  8013f6:	ff 45 08             	incl   0x8(%ebp)
  8013f9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801400:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801404:	74 06                	je     80140c <strtol+0x58>
  801406:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80140a:	75 20                	jne    80142c <strtol+0x78>
  80140c:	8b 45 08             	mov    0x8(%ebp),%eax
  80140f:	8a 00                	mov    (%eax),%al
  801411:	3c 30                	cmp    $0x30,%al
  801413:	75 17                	jne    80142c <strtol+0x78>
  801415:	8b 45 08             	mov    0x8(%ebp),%eax
  801418:	40                   	inc    %eax
  801419:	8a 00                	mov    (%eax),%al
  80141b:	3c 78                	cmp    $0x78,%al
  80141d:	75 0d                	jne    80142c <strtol+0x78>
		s += 2, base = 16;
  80141f:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801423:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80142a:	eb 28                	jmp    801454 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80142c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801430:	75 15                	jne    801447 <strtol+0x93>
  801432:	8b 45 08             	mov    0x8(%ebp),%eax
  801435:	8a 00                	mov    (%eax),%al
  801437:	3c 30                	cmp    $0x30,%al
  801439:	75 0c                	jne    801447 <strtol+0x93>
		s++, base = 8;
  80143b:	ff 45 08             	incl   0x8(%ebp)
  80143e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801445:	eb 0d                	jmp    801454 <strtol+0xa0>
	else if (base == 0)
  801447:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80144b:	75 07                	jne    801454 <strtol+0xa0>
		base = 10;
  80144d:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801454:	8b 45 08             	mov    0x8(%ebp),%eax
  801457:	8a 00                	mov    (%eax),%al
  801459:	3c 2f                	cmp    $0x2f,%al
  80145b:	7e 19                	jle    801476 <strtol+0xc2>
  80145d:	8b 45 08             	mov    0x8(%ebp),%eax
  801460:	8a 00                	mov    (%eax),%al
  801462:	3c 39                	cmp    $0x39,%al
  801464:	7f 10                	jg     801476 <strtol+0xc2>
			dig = *s - '0';
  801466:	8b 45 08             	mov    0x8(%ebp),%eax
  801469:	8a 00                	mov    (%eax),%al
  80146b:	0f be c0             	movsbl %al,%eax
  80146e:	83 e8 30             	sub    $0x30,%eax
  801471:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801474:	eb 42                	jmp    8014b8 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801476:	8b 45 08             	mov    0x8(%ebp),%eax
  801479:	8a 00                	mov    (%eax),%al
  80147b:	3c 60                	cmp    $0x60,%al
  80147d:	7e 19                	jle    801498 <strtol+0xe4>
  80147f:	8b 45 08             	mov    0x8(%ebp),%eax
  801482:	8a 00                	mov    (%eax),%al
  801484:	3c 7a                	cmp    $0x7a,%al
  801486:	7f 10                	jg     801498 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801488:	8b 45 08             	mov    0x8(%ebp),%eax
  80148b:	8a 00                	mov    (%eax),%al
  80148d:	0f be c0             	movsbl %al,%eax
  801490:	83 e8 57             	sub    $0x57,%eax
  801493:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801496:	eb 20                	jmp    8014b8 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801498:	8b 45 08             	mov    0x8(%ebp),%eax
  80149b:	8a 00                	mov    (%eax),%al
  80149d:	3c 40                	cmp    $0x40,%al
  80149f:	7e 39                	jle    8014da <strtol+0x126>
  8014a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a4:	8a 00                	mov    (%eax),%al
  8014a6:	3c 5a                	cmp    $0x5a,%al
  8014a8:	7f 30                	jg     8014da <strtol+0x126>
			dig = *s - 'A' + 10;
  8014aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ad:	8a 00                	mov    (%eax),%al
  8014af:	0f be c0             	movsbl %al,%eax
  8014b2:	83 e8 37             	sub    $0x37,%eax
  8014b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8014b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014bb:	3b 45 10             	cmp    0x10(%ebp),%eax
  8014be:	7d 19                	jge    8014d9 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8014c0:	ff 45 08             	incl   0x8(%ebp)
  8014c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014c6:	0f af 45 10          	imul   0x10(%ebp),%eax
  8014ca:	89 c2                	mov    %eax,%edx
  8014cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014cf:	01 d0                	add    %edx,%eax
  8014d1:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8014d4:	e9 7b ff ff ff       	jmp    801454 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8014d9:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8014da:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8014de:	74 08                	je     8014e8 <strtol+0x134>
		*endptr = (char *) s;
  8014e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e3:	8b 55 08             	mov    0x8(%ebp),%edx
  8014e6:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8014e8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8014ec:	74 07                	je     8014f5 <strtol+0x141>
  8014ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014f1:	f7 d8                	neg    %eax
  8014f3:	eb 03                	jmp    8014f8 <strtol+0x144>
  8014f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014f8:	c9                   	leave  
  8014f9:	c3                   	ret    

008014fa <ltostr>:

void
ltostr(long value, char *str)
{
  8014fa:	55                   	push   %ebp
  8014fb:	89 e5                	mov    %esp,%ebp
  8014fd:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801500:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801507:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80150e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801512:	79 13                	jns    801527 <ltostr+0x2d>
	{
		neg = 1;
  801514:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80151b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80151e:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801521:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801524:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801527:	8b 45 08             	mov    0x8(%ebp),%eax
  80152a:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80152f:	99                   	cltd   
  801530:	f7 f9                	idiv   %ecx
  801532:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801535:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801538:	8d 50 01             	lea    0x1(%eax),%edx
  80153b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80153e:	89 c2                	mov    %eax,%edx
  801540:	8b 45 0c             	mov    0xc(%ebp),%eax
  801543:	01 d0                	add    %edx,%eax
  801545:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801548:	83 c2 30             	add    $0x30,%edx
  80154b:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80154d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801550:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801555:	f7 e9                	imul   %ecx
  801557:	c1 fa 02             	sar    $0x2,%edx
  80155a:	89 c8                	mov    %ecx,%eax
  80155c:	c1 f8 1f             	sar    $0x1f,%eax
  80155f:	29 c2                	sub    %eax,%edx
  801561:	89 d0                	mov    %edx,%eax
  801563:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801566:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801569:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80156e:	f7 e9                	imul   %ecx
  801570:	c1 fa 02             	sar    $0x2,%edx
  801573:	89 c8                	mov    %ecx,%eax
  801575:	c1 f8 1f             	sar    $0x1f,%eax
  801578:	29 c2                	sub    %eax,%edx
  80157a:	89 d0                	mov    %edx,%eax
  80157c:	c1 e0 02             	shl    $0x2,%eax
  80157f:	01 d0                	add    %edx,%eax
  801581:	01 c0                	add    %eax,%eax
  801583:	29 c1                	sub    %eax,%ecx
  801585:	89 ca                	mov    %ecx,%edx
  801587:	85 d2                	test   %edx,%edx
  801589:	75 9c                	jne    801527 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80158b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801592:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801595:	48                   	dec    %eax
  801596:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801599:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80159d:	74 3d                	je     8015dc <ltostr+0xe2>
		start = 1 ;
  80159f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8015a6:	eb 34                	jmp    8015dc <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8015a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ae:	01 d0                	add    %edx,%eax
  8015b0:	8a 00                	mov    (%eax),%al
  8015b2:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8015b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015bb:	01 c2                	add    %eax,%edx
  8015bd:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8015c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c3:	01 c8                	add    %ecx,%eax
  8015c5:	8a 00                	mov    (%eax),%al
  8015c7:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8015c9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015cf:	01 c2                	add    %eax,%edx
  8015d1:	8a 45 eb             	mov    -0x15(%ebp),%al
  8015d4:	88 02                	mov    %al,(%edx)
		start++ ;
  8015d6:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8015d9:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8015dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015df:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8015e2:	7c c4                	jl     8015a8 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8015e4:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8015e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ea:	01 d0                	add    %edx,%eax
  8015ec:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8015ef:	90                   	nop
  8015f0:	c9                   	leave  
  8015f1:	c3                   	ret    

008015f2 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8015f2:	55                   	push   %ebp
  8015f3:	89 e5                	mov    %esp,%ebp
  8015f5:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8015f8:	ff 75 08             	pushl  0x8(%ebp)
  8015fb:	e8 54 fa ff ff       	call   801054 <strlen>
  801600:	83 c4 04             	add    $0x4,%esp
  801603:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801606:	ff 75 0c             	pushl  0xc(%ebp)
  801609:	e8 46 fa ff ff       	call   801054 <strlen>
  80160e:	83 c4 04             	add    $0x4,%esp
  801611:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801614:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80161b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801622:	eb 17                	jmp    80163b <strcconcat+0x49>
		final[s] = str1[s] ;
  801624:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801627:	8b 45 10             	mov    0x10(%ebp),%eax
  80162a:	01 c2                	add    %eax,%edx
  80162c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80162f:	8b 45 08             	mov    0x8(%ebp),%eax
  801632:	01 c8                	add    %ecx,%eax
  801634:	8a 00                	mov    (%eax),%al
  801636:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801638:	ff 45 fc             	incl   -0x4(%ebp)
  80163b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80163e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801641:	7c e1                	jl     801624 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801643:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80164a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801651:	eb 1f                	jmp    801672 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801653:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801656:	8d 50 01             	lea    0x1(%eax),%edx
  801659:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80165c:	89 c2                	mov    %eax,%edx
  80165e:	8b 45 10             	mov    0x10(%ebp),%eax
  801661:	01 c2                	add    %eax,%edx
  801663:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801666:	8b 45 0c             	mov    0xc(%ebp),%eax
  801669:	01 c8                	add    %ecx,%eax
  80166b:	8a 00                	mov    (%eax),%al
  80166d:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80166f:	ff 45 f8             	incl   -0x8(%ebp)
  801672:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801675:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801678:	7c d9                	jl     801653 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80167a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80167d:	8b 45 10             	mov    0x10(%ebp),%eax
  801680:	01 d0                	add    %edx,%eax
  801682:	c6 00 00             	movb   $0x0,(%eax)
}
  801685:	90                   	nop
  801686:	c9                   	leave  
  801687:	c3                   	ret    

00801688 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801688:	55                   	push   %ebp
  801689:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80168b:	8b 45 14             	mov    0x14(%ebp),%eax
  80168e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801694:	8b 45 14             	mov    0x14(%ebp),%eax
  801697:	8b 00                	mov    (%eax),%eax
  801699:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8016a3:	01 d0                	add    %edx,%eax
  8016a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8016ab:	eb 0c                	jmp    8016b9 <strsplit+0x31>
			*string++ = 0;
  8016ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b0:	8d 50 01             	lea    0x1(%eax),%edx
  8016b3:	89 55 08             	mov    %edx,0x8(%ebp)
  8016b6:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8016b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bc:	8a 00                	mov    (%eax),%al
  8016be:	84 c0                	test   %al,%al
  8016c0:	74 18                	je     8016da <strsplit+0x52>
  8016c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c5:	8a 00                	mov    (%eax),%al
  8016c7:	0f be c0             	movsbl %al,%eax
  8016ca:	50                   	push   %eax
  8016cb:	ff 75 0c             	pushl  0xc(%ebp)
  8016ce:	e8 13 fb ff ff       	call   8011e6 <strchr>
  8016d3:	83 c4 08             	add    $0x8,%esp
  8016d6:	85 c0                	test   %eax,%eax
  8016d8:	75 d3                	jne    8016ad <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8016da:	8b 45 08             	mov    0x8(%ebp),%eax
  8016dd:	8a 00                	mov    (%eax),%al
  8016df:	84 c0                	test   %al,%al
  8016e1:	74 5a                	je     80173d <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8016e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8016e6:	8b 00                	mov    (%eax),%eax
  8016e8:	83 f8 0f             	cmp    $0xf,%eax
  8016eb:	75 07                	jne    8016f4 <strsplit+0x6c>
		{
			return 0;
  8016ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8016f2:	eb 66                	jmp    80175a <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8016f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8016f7:	8b 00                	mov    (%eax),%eax
  8016f9:	8d 48 01             	lea    0x1(%eax),%ecx
  8016fc:	8b 55 14             	mov    0x14(%ebp),%edx
  8016ff:	89 0a                	mov    %ecx,(%edx)
  801701:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801708:	8b 45 10             	mov    0x10(%ebp),%eax
  80170b:	01 c2                	add    %eax,%edx
  80170d:	8b 45 08             	mov    0x8(%ebp),%eax
  801710:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801712:	eb 03                	jmp    801717 <strsplit+0x8f>
			string++;
  801714:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801717:	8b 45 08             	mov    0x8(%ebp),%eax
  80171a:	8a 00                	mov    (%eax),%al
  80171c:	84 c0                	test   %al,%al
  80171e:	74 8b                	je     8016ab <strsplit+0x23>
  801720:	8b 45 08             	mov    0x8(%ebp),%eax
  801723:	8a 00                	mov    (%eax),%al
  801725:	0f be c0             	movsbl %al,%eax
  801728:	50                   	push   %eax
  801729:	ff 75 0c             	pushl  0xc(%ebp)
  80172c:	e8 b5 fa ff ff       	call   8011e6 <strchr>
  801731:	83 c4 08             	add    $0x8,%esp
  801734:	85 c0                	test   %eax,%eax
  801736:	74 dc                	je     801714 <strsplit+0x8c>
			string++;
	}
  801738:	e9 6e ff ff ff       	jmp    8016ab <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80173d:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80173e:	8b 45 14             	mov    0x14(%ebp),%eax
  801741:	8b 00                	mov    (%eax),%eax
  801743:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80174a:	8b 45 10             	mov    0x10(%ebp),%eax
  80174d:	01 d0                	add    %edx,%eax
  80174f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801755:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80175a:	c9                   	leave  
  80175b:	c3                   	ret    

0080175c <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  80175c:	55                   	push   %ebp
  80175d:	89 e5                	mov    %esp,%ebp
  80175f:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801762:	a1 04 50 80 00       	mov    0x805004,%eax
  801767:	85 c0                	test   %eax,%eax
  801769:	74 1f                	je     80178a <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  80176b:	e8 1d 00 00 00       	call   80178d <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801770:	83 ec 0c             	sub    $0xc,%esp
  801773:	68 b0 41 80 00       	push   $0x8041b0
  801778:	e8 55 f2 ff ff       	call   8009d2 <cprintf>
  80177d:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801780:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801787:	00 00 00 
	}
}
  80178a:	90                   	nop
  80178b:	c9                   	leave  
  80178c:	c3                   	ret    

0080178d <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80178d:	55                   	push   %ebp
  80178e:	89 e5                	mov    %esp,%ebp
  801790:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	LIST_INIT(&AllocMemBlocksList);
  801793:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  80179a:	00 00 00 
  80179d:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  8017a4:	00 00 00 
  8017a7:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  8017ae:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  8017b1:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  8017b8:	00 00 00 
  8017bb:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  8017c2:	00 00 00 
  8017c5:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  8017cc:	00 00 00 
	uint32 arr_size = 0;
  8017cf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	MemBlockNodes  =(struct MemBlock*) USER_DYN_BLKS_ARRAY;
  8017d6:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  8017dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017e0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8017e5:	2d 00 10 00 00       	sub    $0x1000,%eax
  8017ea:	a3 50 50 80 00       	mov    %eax,0x805050
	MAX_MEM_BLOCK_CNT = (USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE;
  8017ef:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  8017f6:	00 02 00 
	arr_size =  ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock), PAGE_SIZE);
  8017f9:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801800:	a1 20 51 80 00       	mov    0x805120,%eax
  801805:	c1 e0 04             	shl    $0x4,%eax
  801808:	89 c2                	mov    %eax,%edx
  80180a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80180d:	01 d0                	add    %edx,%eax
  80180f:	48                   	dec    %eax
  801810:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801813:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801816:	ba 00 00 00 00       	mov    $0x0,%edx
  80181b:	f7 75 ec             	divl   -0x14(%ebp)
  80181e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801821:	29 d0                	sub    %edx,%eax
  801823:	89 45 f4             	mov    %eax,-0xc(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_USER);
  801826:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  80182d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801830:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801835:	2d 00 10 00 00       	sub    $0x1000,%eax
  80183a:	83 ec 04             	sub    $0x4,%esp
  80183d:	6a 06                	push   $0x6
  80183f:	ff 75 f4             	pushl  -0xc(%ebp)
  801842:	50                   	push   %eax
  801843:	e8 1d 04 00 00       	call   801c65 <sys_allocate_chunk>
  801848:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  80184b:	a1 20 51 80 00       	mov    0x805120,%eax
  801850:	83 ec 0c             	sub    $0xc,%esp
  801853:	50                   	push   %eax
  801854:	e8 92 0a 00 00       	call   8022eb <initialize_MemBlocksList>
  801859:	83 c4 10             	add    $0x10,%esp
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	struct MemBlock * NewBlock = LIST_FIRST(&AvailableMemBlocksList);
  80185c:	a1 48 51 80 00       	mov    0x805148,%eax
  801861:	89 45 e0             	mov    %eax,-0x20(%ebp)
	NewBlock->sva = USER_HEAP_START;
  801864:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801867:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	NewBlock->size = (USER_HEAP_MAX-USER_HEAP_START);
  80186e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801871:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	LIST_REMOVE(&AvailableMemBlocksList,NewBlock);
  801878:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80187c:	75 14                	jne    801892 <initialize_dyn_block_system+0x105>
  80187e:	83 ec 04             	sub    $0x4,%esp
  801881:	68 d5 41 80 00       	push   $0x8041d5
  801886:	6a 33                	push   $0x33
  801888:	68 f3 41 80 00       	push   $0x8041f3
  80188d:	e8 8c ee ff ff       	call   80071e <_panic>
  801892:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801895:	8b 00                	mov    (%eax),%eax
  801897:	85 c0                	test   %eax,%eax
  801899:	74 10                	je     8018ab <initialize_dyn_block_system+0x11e>
  80189b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80189e:	8b 00                	mov    (%eax),%eax
  8018a0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8018a3:	8b 52 04             	mov    0x4(%edx),%edx
  8018a6:	89 50 04             	mov    %edx,0x4(%eax)
  8018a9:	eb 0b                	jmp    8018b6 <initialize_dyn_block_system+0x129>
  8018ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018ae:	8b 40 04             	mov    0x4(%eax),%eax
  8018b1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8018b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018b9:	8b 40 04             	mov    0x4(%eax),%eax
  8018bc:	85 c0                	test   %eax,%eax
  8018be:	74 0f                	je     8018cf <initialize_dyn_block_system+0x142>
  8018c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018c3:	8b 40 04             	mov    0x4(%eax),%eax
  8018c6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8018c9:	8b 12                	mov    (%edx),%edx
  8018cb:	89 10                	mov    %edx,(%eax)
  8018cd:	eb 0a                	jmp    8018d9 <initialize_dyn_block_system+0x14c>
  8018cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018d2:	8b 00                	mov    (%eax),%eax
  8018d4:	a3 48 51 80 00       	mov    %eax,0x805148
  8018d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018dc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8018e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018e5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8018ec:	a1 54 51 80 00       	mov    0x805154,%eax
  8018f1:	48                   	dec    %eax
  8018f2:	a3 54 51 80 00       	mov    %eax,0x805154
	LIST_INSERT_HEAD(&FreeMemBlocksList, NewBlock);
  8018f7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8018fb:	75 14                	jne    801911 <initialize_dyn_block_system+0x184>
  8018fd:	83 ec 04             	sub    $0x4,%esp
  801900:	68 00 42 80 00       	push   $0x804200
  801905:	6a 34                	push   $0x34
  801907:	68 f3 41 80 00       	push   $0x8041f3
  80190c:	e8 0d ee ff ff       	call   80071e <_panic>
  801911:	8b 15 38 51 80 00    	mov    0x805138,%edx
  801917:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80191a:	89 10                	mov    %edx,(%eax)
  80191c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80191f:	8b 00                	mov    (%eax),%eax
  801921:	85 c0                	test   %eax,%eax
  801923:	74 0d                	je     801932 <initialize_dyn_block_system+0x1a5>
  801925:	a1 38 51 80 00       	mov    0x805138,%eax
  80192a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80192d:	89 50 04             	mov    %edx,0x4(%eax)
  801930:	eb 08                	jmp    80193a <initialize_dyn_block_system+0x1ad>
  801932:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801935:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80193a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80193d:	a3 38 51 80 00       	mov    %eax,0x805138
  801942:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801945:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80194c:	a1 44 51 80 00       	mov    0x805144,%eax
  801951:	40                   	inc    %eax
  801952:	a3 44 51 80 00       	mov    %eax,0x805144
}
  801957:	90                   	nop
  801958:	c9                   	leave  
  801959:	c3                   	ret    

0080195a <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  80195a:	55                   	push   %ebp
  80195b:	89 e5                	mov    %esp,%ebp
  80195d:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801960:	e8 f7 fd ff ff       	call   80175c <InitializeUHeap>
	if (size == 0) return NULL ;
  801965:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801969:	75 07                	jne    801972 <malloc+0x18>
  80196b:	b8 00 00 00 00       	mov    $0x0,%eax
  801970:	eb 14                	jmp    801986 <malloc+0x2c>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801972:	83 ec 04             	sub    $0x4,%esp
  801975:	68 24 42 80 00       	push   $0x804224
  80197a:	6a 46                	push   $0x46
  80197c:	68 f3 41 80 00       	push   $0x8041f3
  801981:	e8 98 ed ff ff       	call   80071e <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801986:	c9                   	leave  
  801987:	c3                   	ret    

00801988 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801988:	55                   	push   %ebp
  801989:	89 e5                	mov    %esp,%ebp
  80198b:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  80198e:	83 ec 04             	sub    $0x4,%esp
  801991:	68 4c 42 80 00       	push   $0x80424c
  801996:	6a 61                	push   $0x61
  801998:	68 f3 41 80 00       	push   $0x8041f3
  80199d:	e8 7c ed ff ff       	call   80071e <_panic>

008019a2 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8019a2:	55                   	push   %ebp
  8019a3:	89 e5                	mov    %esp,%ebp
  8019a5:	83 ec 38             	sub    $0x38,%esp
  8019a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8019ab:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8019ae:	e8 a9 fd ff ff       	call   80175c <InitializeUHeap>
	if (size == 0) return NULL ;
  8019b3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8019b7:	75 07                	jne    8019c0 <smalloc+0x1e>
  8019b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8019be:	eb 7c                	jmp    801a3c <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  8019c0:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8019c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019cd:	01 d0                	add    %edx,%eax
  8019cf:	48                   	dec    %eax
  8019d0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8019d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8019db:	f7 75 f0             	divl   -0x10(%ebp)
  8019de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019e1:	29 d0                	sub    %edx,%eax
  8019e3:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  8019e6:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8019ed:	e8 41 06 00 00       	call   802033 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8019f2:	85 c0                	test   %eax,%eax
  8019f4:	74 11                	je     801a07 <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  8019f6:	83 ec 0c             	sub    $0xc,%esp
  8019f9:	ff 75 e8             	pushl  -0x18(%ebp)
  8019fc:	e8 ac 0c 00 00       	call   8026ad <alloc_block_FF>
  801a01:	83 c4 10             	add    $0x10,%esp
  801a04:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  801a07:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a0b:	74 2a                	je     801a37 <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801a0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a10:	8b 40 08             	mov    0x8(%eax),%eax
  801a13:	89 c2                	mov    %eax,%edx
  801a15:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801a19:	52                   	push   %edx
  801a1a:	50                   	push   %eax
  801a1b:	ff 75 0c             	pushl  0xc(%ebp)
  801a1e:	ff 75 08             	pushl  0x8(%ebp)
  801a21:	e8 92 03 00 00       	call   801db8 <sys_createSharedObject>
  801a26:	83 c4 10             	add    $0x10,%esp
  801a29:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  801a2c:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  801a30:	74 05                	je     801a37 <smalloc+0x95>
			return (void*)virtual_address;
  801a32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a35:	eb 05                	jmp    801a3c <smalloc+0x9a>
	}
	return NULL;
  801a37:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801a3c:	c9                   	leave  
  801a3d:	c3                   	ret    

00801a3e <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801a3e:	55                   	push   %ebp
  801a3f:	89 e5                	mov    %esp,%ebp
  801a41:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801a44:	e8 13 fd ff ff       	call   80175c <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801a49:	83 ec 04             	sub    $0x4,%esp
  801a4c:	68 70 42 80 00       	push   $0x804270
  801a51:	68 a2 00 00 00       	push   $0xa2
  801a56:	68 f3 41 80 00       	push   $0x8041f3
  801a5b:	e8 be ec ff ff       	call   80071e <_panic>

00801a60 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801a60:	55                   	push   %ebp
  801a61:	89 e5                	mov    %esp,%ebp
  801a63:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801a66:	e8 f1 fc ff ff       	call   80175c <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801a6b:	83 ec 04             	sub    $0x4,%esp
  801a6e:	68 94 42 80 00       	push   $0x804294
  801a73:	68 e6 00 00 00       	push   $0xe6
  801a78:	68 f3 41 80 00       	push   $0x8041f3
  801a7d:	e8 9c ec ff ff       	call   80071e <_panic>

00801a82 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801a82:	55                   	push   %ebp
  801a83:	89 e5                	mov    %esp,%ebp
  801a85:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801a88:	83 ec 04             	sub    $0x4,%esp
  801a8b:	68 bc 42 80 00       	push   $0x8042bc
  801a90:	68 fa 00 00 00       	push   $0xfa
  801a95:	68 f3 41 80 00       	push   $0x8041f3
  801a9a:	e8 7f ec ff ff       	call   80071e <_panic>

00801a9f <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801a9f:	55                   	push   %ebp
  801aa0:	89 e5                	mov    %esp,%ebp
  801aa2:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801aa5:	83 ec 04             	sub    $0x4,%esp
  801aa8:	68 e0 42 80 00       	push   $0x8042e0
  801aad:	68 05 01 00 00       	push   $0x105
  801ab2:	68 f3 41 80 00       	push   $0x8041f3
  801ab7:	e8 62 ec ff ff       	call   80071e <_panic>

00801abc <shrink>:

}
void shrink(uint32 newSize)
{
  801abc:	55                   	push   %ebp
  801abd:	89 e5                	mov    %esp,%ebp
  801abf:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ac2:	83 ec 04             	sub    $0x4,%esp
  801ac5:	68 e0 42 80 00       	push   $0x8042e0
  801aca:	68 0a 01 00 00       	push   $0x10a
  801acf:	68 f3 41 80 00       	push   $0x8041f3
  801ad4:	e8 45 ec ff ff       	call   80071e <_panic>

00801ad9 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801ad9:	55                   	push   %ebp
  801ada:	89 e5                	mov    %esp,%ebp
  801adc:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801adf:	83 ec 04             	sub    $0x4,%esp
  801ae2:	68 e0 42 80 00       	push   $0x8042e0
  801ae7:	68 0f 01 00 00       	push   $0x10f
  801aec:	68 f3 41 80 00       	push   $0x8041f3
  801af1:	e8 28 ec ff ff       	call   80071e <_panic>

00801af6 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801af6:	55                   	push   %ebp
  801af7:	89 e5                	mov    %esp,%ebp
  801af9:	57                   	push   %edi
  801afa:	56                   	push   %esi
  801afb:	53                   	push   %ebx
  801afc:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801aff:	8b 45 08             	mov    0x8(%ebp),%eax
  801b02:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b05:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b08:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b0b:	8b 7d 18             	mov    0x18(%ebp),%edi
  801b0e:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801b11:	cd 30                	int    $0x30
  801b13:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801b16:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801b19:	83 c4 10             	add    $0x10,%esp
  801b1c:	5b                   	pop    %ebx
  801b1d:	5e                   	pop    %esi
  801b1e:	5f                   	pop    %edi
  801b1f:	5d                   	pop    %ebp
  801b20:	c3                   	ret    

00801b21 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801b21:	55                   	push   %ebp
  801b22:	89 e5                	mov    %esp,%ebp
  801b24:	83 ec 04             	sub    $0x4,%esp
  801b27:	8b 45 10             	mov    0x10(%ebp),%eax
  801b2a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801b2d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b31:	8b 45 08             	mov    0x8(%ebp),%eax
  801b34:	6a 00                	push   $0x0
  801b36:	6a 00                	push   $0x0
  801b38:	52                   	push   %edx
  801b39:	ff 75 0c             	pushl  0xc(%ebp)
  801b3c:	50                   	push   %eax
  801b3d:	6a 00                	push   $0x0
  801b3f:	e8 b2 ff ff ff       	call   801af6 <syscall>
  801b44:	83 c4 18             	add    $0x18,%esp
}
  801b47:	90                   	nop
  801b48:	c9                   	leave  
  801b49:	c3                   	ret    

00801b4a <sys_cgetc>:

int
sys_cgetc(void)
{
  801b4a:	55                   	push   %ebp
  801b4b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801b4d:	6a 00                	push   $0x0
  801b4f:	6a 00                	push   $0x0
  801b51:	6a 00                	push   $0x0
  801b53:	6a 00                	push   $0x0
  801b55:	6a 00                	push   $0x0
  801b57:	6a 01                	push   $0x1
  801b59:	e8 98 ff ff ff       	call   801af6 <syscall>
  801b5e:	83 c4 18             	add    $0x18,%esp
}
  801b61:	c9                   	leave  
  801b62:	c3                   	ret    

00801b63 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801b63:	55                   	push   %ebp
  801b64:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801b66:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b69:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6c:	6a 00                	push   $0x0
  801b6e:	6a 00                	push   $0x0
  801b70:	6a 00                	push   $0x0
  801b72:	52                   	push   %edx
  801b73:	50                   	push   %eax
  801b74:	6a 05                	push   $0x5
  801b76:	e8 7b ff ff ff       	call   801af6 <syscall>
  801b7b:	83 c4 18             	add    $0x18,%esp
}
  801b7e:	c9                   	leave  
  801b7f:	c3                   	ret    

00801b80 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801b80:	55                   	push   %ebp
  801b81:	89 e5                	mov    %esp,%ebp
  801b83:	56                   	push   %esi
  801b84:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801b85:	8b 75 18             	mov    0x18(%ebp),%esi
  801b88:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b8b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b8e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b91:	8b 45 08             	mov    0x8(%ebp),%eax
  801b94:	56                   	push   %esi
  801b95:	53                   	push   %ebx
  801b96:	51                   	push   %ecx
  801b97:	52                   	push   %edx
  801b98:	50                   	push   %eax
  801b99:	6a 06                	push   $0x6
  801b9b:	e8 56 ff ff ff       	call   801af6 <syscall>
  801ba0:	83 c4 18             	add    $0x18,%esp
}
  801ba3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ba6:	5b                   	pop    %ebx
  801ba7:	5e                   	pop    %esi
  801ba8:	5d                   	pop    %ebp
  801ba9:	c3                   	ret    

00801baa <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801baa:	55                   	push   %ebp
  801bab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801bad:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb3:	6a 00                	push   $0x0
  801bb5:	6a 00                	push   $0x0
  801bb7:	6a 00                	push   $0x0
  801bb9:	52                   	push   %edx
  801bba:	50                   	push   %eax
  801bbb:	6a 07                	push   $0x7
  801bbd:	e8 34 ff ff ff       	call   801af6 <syscall>
  801bc2:	83 c4 18             	add    $0x18,%esp
}
  801bc5:	c9                   	leave  
  801bc6:	c3                   	ret    

00801bc7 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801bc7:	55                   	push   %ebp
  801bc8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801bca:	6a 00                	push   $0x0
  801bcc:	6a 00                	push   $0x0
  801bce:	6a 00                	push   $0x0
  801bd0:	ff 75 0c             	pushl  0xc(%ebp)
  801bd3:	ff 75 08             	pushl  0x8(%ebp)
  801bd6:	6a 08                	push   $0x8
  801bd8:	e8 19 ff ff ff       	call   801af6 <syscall>
  801bdd:	83 c4 18             	add    $0x18,%esp
}
  801be0:	c9                   	leave  
  801be1:	c3                   	ret    

00801be2 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801be2:	55                   	push   %ebp
  801be3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801be5:	6a 00                	push   $0x0
  801be7:	6a 00                	push   $0x0
  801be9:	6a 00                	push   $0x0
  801beb:	6a 00                	push   $0x0
  801bed:	6a 00                	push   $0x0
  801bef:	6a 09                	push   $0x9
  801bf1:	e8 00 ff ff ff       	call   801af6 <syscall>
  801bf6:	83 c4 18             	add    $0x18,%esp
}
  801bf9:	c9                   	leave  
  801bfa:	c3                   	ret    

00801bfb <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801bfb:	55                   	push   %ebp
  801bfc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 00                	push   $0x0
  801c02:	6a 00                	push   $0x0
  801c04:	6a 00                	push   $0x0
  801c06:	6a 00                	push   $0x0
  801c08:	6a 0a                	push   $0xa
  801c0a:	e8 e7 fe ff ff       	call   801af6 <syscall>
  801c0f:	83 c4 18             	add    $0x18,%esp
}
  801c12:	c9                   	leave  
  801c13:	c3                   	ret    

00801c14 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801c14:	55                   	push   %ebp
  801c15:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801c17:	6a 00                	push   $0x0
  801c19:	6a 00                	push   $0x0
  801c1b:	6a 00                	push   $0x0
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 0b                	push   $0xb
  801c23:	e8 ce fe ff ff       	call   801af6 <syscall>
  801c28:	83 c4 18             	add    $0x18,%esp
}
  801c2b:	c9                   	leave  
  801c2c:	c3                   	ret    

00801c2d <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801c2d:	55                   	push   %ebp
  801c2e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801c30:	6a 00                	push   $0x0
  801c32:	6a 00                	push   $0x0
  801c34:	6a 00                	push   $0x0
  801c36:	ff 75 0c             	pushl  0xc(%ebp)
  801c39:	ff 75 08             	pushl  0x8(%ebp)
  801c3c:	6a 0f                	push   $0xf
  801c3e:	e8 b3 fe ff ff       	call   801af6 <syscall>
  801c43:	83 c4 18             	add    $0x18,%esp
	return;
  801c46:	90                   	nop
}
  801c47:	c9                   	leave  
  801c48:	c3                   	ret    

00801c49 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801c49:	55                   	push   %ebp
  801c4a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801c4c:	6a 00                	push   $0x0
  801c4e:	6a 00                	push   $0x0
  801c50:	6a 00                	push   $0x0
  801c52:	ff 75 0c             	pushl  0xc(%ebp)
  801c55:	ff 75 08             	pushl  0x8(%ebp)
  801c58:	6a 10                	push   $0x10
  801c5a:	e8 97 fe ff ff       	call   801af6 <syscall>
  801c5f:	83 c4 18             	add    $0x18,%esp
	return ;
  801c62:	90                   	nop
}
  801c63:	c9                   	leave  
  801c64:	c3                   	ret    

00801c65 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801c65:	55                   	push   %ebp
  801c66:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 00                	push   $0x0
  801c6c:	ff 75 10             	pushl  0x10(%ebp)
  801c6f:	ff 75 0c             	pushl  0xc(%ebp)
  801c72:	ff 75 08             	pushl  0x8(%ebp)
  801c75:	6a 11                	push   $0x11
  801c77:	e8 7a fe ff ff       	call   801af6 <syscall>
  801c7c:	83 c4 18             	add    $0x18,%esp
	return ;
  801c7f:	90                   	nop
}
  801c80:	c9                   	leave  
  801c81:	c3                   	ret    

00801c82 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801c82:	55                   	push   %ebp
  801c83:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801c85:	6a 00                	push   $0x0
  801c87:	6a 00                	push   $0x0
  801c89:	6a 00                	push   $0x0
  801c8b:	6a 00                	push   $0x0
  801c8d:	6a 00                	push   $0x0
  801c8f:	6a 0c                	push   $0xc
  801c91:	e8 60 fe ff ff       	call   801af6 <syscall>
  801c96:	83 c4 18             	add    $0x18,%esp
}
  801c99:	c9                   	leave  
  801c9a:	c3                   	ret    

00801c9b <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801c9b:	55                   	push   %ebp
  801c9c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801c9e:	6a 00                	push   $0x0
  801ca0:	6a 00                	push   $0x0
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 00                	push   $0x0
  801ca6:	ff 75 08             	pushl  0x8(%ebp)
  801ca9:	6a 0d                	push   $0xd
  801cab:	e8 46 fe ff ff       	call   801af6 <syscall>
  801cb0:	83 c4 18             	add    $0x18,%esp
}
  801cb3:	c9                   	leave  
  801cb4:	c3                   	ret    

00801cb5 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801cb5:	55                   	push   %ebp
  801cb6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801cb8:	6a 00                	push   $0x0
  801cba:	6a 00                	push   $0x0
  801cbc:	6a 00                	push   $0x0
  801cbe:	6a 00                	push   $0x0
  801cc0:	6a 00                	push   $0x0
  801cc2:	6a 0e                	push   $0xe
  801cc4:	e8 2d fe ff ff       	call   801af6 <syscall>
  801cc9:	83 c4 18             	add    $0x18,%esp
}
  801ccc:	90                   	nop
  801ccd:	c9                   	leave  
  801cce:	c3                   	ret    

00801ccf <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801ccf:	55                   	push   %ebp
  801cd0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801cd2:	6a 00                	push   $0x0
  801cd4:	6a 00                	push   $0x0
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 00                	push   $0x0
  801cda:	6a 00                	push   $0x0
  801cdc:	6a 13                	push   $0x13
  801cde:	e8 13 fe ff ff       	call   801af6 <syscall>
  801ce3:	83 c4 18             	add    $0x18,%esp
}
  801ce6:	90                   	nop
  801ce7:	c9                   	leave  
  801ce8:	c3                   	ret    

00801ce9 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801ce9:	55                   	push   %ebp
  801cea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801cec:	6a 00                	push   $0x0
  801cee:	6a 00                	push   $0x0
  801cf0:	6a 00                	push   $0x0
  801cf2:	6a 00                	push   $0x0
  801cf4:	6a 00                	push   $0x0
  801cf6:	6a 14                	push   $0x14
  801cf8:	e8 f9 fd ff ff       	call   801af6 <syscall>
  801cfd:	83 c4 18             	add    $0x18,%esp
}
  801d00:	90                   	nop
  801d01:	c9                   	leave  
  801d02:	c3                   	ret    

00801d03 <sys_cputc>:


void
sys_cputc(const char c)
{
  801d03:	55                   	push   %ebp
  801d04:	89 e5                	mov    %esp,%ebp
  801d06:	83 ec 04             	sub    $0x4,%esp
  801d09:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801d0f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d13:	6a 00                	push   $0x0
  801d15:	6a 00                	push   $0x0
  801d17:	6a 00                	push   $0x0
  801d19:	6a 00                	push   $0x0
  801d1b:	50                   	push   %eax
  801d1c:	6a 15                	push   $0x15
  801d1e:	e8 d3 fd ff ff       	call   801af6 <syscall>
  801d23:	83 c4 18             	add    $0x18,%esp
}
  801d26:	90                   	nop
  801d27:	c9                   	leave  
  801d28:	c3                   	ret    

00801d29 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801d29:	55                   	push   %ebp
  801d2a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801d2c:	6a 00                	push   $0x0
  801d2e:	6a 00                	push   $0x0
  801d30:	6a 00                	push   $0x0
  801d32:	6a 00                	push   $0x0
  801d34:	6a 00                	push   $0x0
  801d36:	6a 16                	push   $0x16
  801d38:	e8 b9 fd ff ff       	call   801af6 <syscall>
  801d3d:	83 c4 18             	add    $0x18,%esp
}
  801d40:	90                   	nop
  801d41:	c9                   	leave  
  801d42:	c3                   	ret    

00801d43 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801d43:	55                   	push   %ebp
  801d44:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801d46:	8b 45 08             	mov    0x8(%ebp),%eax
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 00                	push   $0x0
  801d4d:	6a 00                	push   $0x0
  801d4f:	ff 75 0c             	pushl  0xc(%ebp)
  801d52:	50                   	push   %eax
  801d53:	6a 17                	push   $0x17
  801d55:	e8 9c fd ff ff       	call   801af6 <syscall>
  801d5a:	83 c4 18             	add    $0x18,%esp
}
  801d5d:	c9                   	leave  
  801d5e:	c3                   	ret    

00801d5f <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801d5f:	55                   	push   %ebp
  801d60:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d62:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d65:	8b 45 08             	mov    0x8(%ebp),%eax
  801d68:	6a 00                	push   $0x0
  801d6a:	6a 00                	push   $0x0
  801d6c:	6a 00                	push   $0x0
  801d6e:	52                   	push   %edx
  801d6f:	50                   	push   %eax
  801d70:	6a 1a                	push   $0x1a
  801d72:	e8 7f fd ff ff       	call   801af6 <syscall>
  801d77:	83 c4 18             	add    $0x18,%esp
}
  801d7a:	c9                   	leave  
  801d7b:	c3                   	ret    

00801d7c <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801d7c:	55                   	push   %ebp
  801d7d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d82:	8b 45 08             	mov    0x8(%ebp),%eax
  801d85:	6a 00                	push   $0x0
  801d87:	6a 00                	push   $0x0
  801d89:	6a 00                	push   $0x0
  801d8b:	52                   	push   %edx
  801d8c:	50                   	push   %eax
  801d8d:	6a 18                	push   $0x18
  801d8f:	e8 62 fd ff ff       	call   801af6 <syscall>
  801d94:	83 c4 18             	add    $0x18,%esp
}
  801d97:	90                   	nop
  801d98:	c9                   	leave  
  801d99:	c3                   	ret    

00801d9a <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801d9a:	55                   	push   %ebp
  801d9b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d9d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801da0:	8b 45 08             	mov    0x8(%ebp),%eax
  801da3:	6a 00                	push   $0x0
  801da5:	6a 00                	push   $0x0
  801da7:	6a 00                	push   $0x0
  801da9:	52                   	push   %edx
  801daa:	50                   	push   %eax
  801dab:	6a 19                	push   $0x19
  801dad:	e8 44 fd ff ff       	call   801af6 <syscall>
  801db2:	83 c4 18             	add    $0x18,%esp
}
  801db5:	90                   	nop
  801db6:	c9                   	leave  
  801db7:	c3                   	ret    

00801db8 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801db8:	55                   	push   %ebp
  801db9:	89 e5                	mov    %esp,%ebp
  801dbb:	83 ec 04             	sub    $0x4,%esp
  801dbe:	8b 45 10             	mov    0x10(%ebp),%eax
  801dc1:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801dc4:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801dc7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801dcb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dce:	6a 00                	push   $0x0
  801dd0:	51                   	push   %ecx
  801dd1:	52                   	push   %edx
  801dd2:	ff 75 0c             	pushl  0xc(%ebp)
  801dd5:	50                   	push   %eax
  801dd6:	6a 1b                	push   $0x1b
  801dd8:	e8 19 fd ff ff       	call   801af6 <syscall>
  801ddd:	83 c4 18             	add    $0x18,%esp
}
  801de0:	c9                   	leave  
  801de1:	c3                   	ret    

00801de2 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801de2:	55                   	push   %ebp
  801de3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801de5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801de8:	8b 45 08             	mov    0x8(%ebp),%eax
  801deb:	6a 00                	push   $0x0
  801ded:	6a 00                	push   $0x0
  801def:	6a 00                	push   $0x0
  801df1:	52                   	push   %edx
  801df2:	50                   	push   %eax
  801df3:	6a 1c                	push   $0x1c
  801df5:	e8 fc fc ff ff       	call   801af6 <syscall>
  801dfa:	83 c4 18             	add    $0x18,%esp
}
  801dfd:	c9                   	leave  
  801dfe:	c3                   	ret    

00801dff <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801dff:	55                   	push   %ebp
  801e00:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801e02:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e05:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e08:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0b:	6a 00                	push   $0x0
  801e0d:	6a 00                	push   $0x0
  801e0f:	51                   	push   %ecx
  801e10:	52                   	push   %edx
  801e11:	50                   	push   %eax
  801e12:	6a 1d                	push   $0x1d
  801e14:	e8 dd fc ff ff       	call   801af6 <syscall>
  801e19:	83 c4 18             	add    $0x18,%esp
}
  801e1c:	c9                   	leave  
  801e1d:	c3                   	ret    

00801e1e <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801e1e:	55                   	push   %ebp
  801e1f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801e21:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e24:	8b 45 08             	mov    0x8(%ebp),%eax
  801e27:	6a 00                	push   $0x0
  801e29:	6a 00                	push   $0x0
  801e2b:	6a 00                	push   $0x0
  801e2d:	52                   	push   %edx
  801e2e:	50                   	push   %eax
  801e2f:	6a 1e                	push   $0x1e
  801e31:	e8 c0 fc ff ff       	call   801af6 <syscall>
  801e36:	83 c4 18             	add    $0x18,%esp
}
  801e39:	c9                   	leave  
  801e3a:	c3                   	ret    

00801e3b <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801e3b:	55                   	push   %ebp
  801e3c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801e3e:	6a 00                	push   $0x0
  801e40:	6a 00                	push   $0x0
  801e42:	6a 00                	push   $0x0
  801e44:	6a 00                	push   $0x0
  801e46:	6a 00                	push   $0x0
  801e48:	6a 1f                	push   $0x1f
  801e4a:	e8 a7 fc ff ff       	call   801af6 <syscall>
  801e4f:	83 c4 18             	add    $0x18,%esp
}
  801e52:	c9                   	leave  
  801e53:	c3                   	ret    

00801e54 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801e54:	55                   	push   %ebp
  801e55:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801e57:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5a:	6a 00                	push   $0x0
  801e5c:	ff 75 14             	pushl  0x14(%ebp)
  801e5f:	ff 75 10             	pushl  0x10(%ebp)
  801e62:	ff 75 0c             	pushl  0xc(%ebp)
  801e65:	50                   	push   %eax
  801e66:	6a 20                	push   $0x20
  801e68:	e8 89 fc ff ff       	call   801af6 <syscall>
  801e6d:	83 c4 18             	add    $0x18,%esp
}
  801e70:	c9                   	leave  
  801e71:	c3                   	ret    

00801e72 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801e72:	55                   	push   %ebp
  801e73:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801e75:	8b 45 08             	mov    0x8(%ebp),%eax
  801e78:	6a 00                	push   $0x0
  801e7a:	6a 00                	push   $0x0
  801e7c:	6a 00                	push   $0x0
  801e7e:	6a 00                	push   $0x0
  801e80:	50                   	push   %eax
  801e81:	6a 21                	push   $0x21
  801e83:	e8 6e fc ff ff       	call   801af6 <syscall>
  801e88:	83 c4 18             	add    $0x18,%esp
}
  801e8b:	90                   	nop
  801e8c:	c9                   	leave  
  801e8d:	c3                   	ret    

00801e8e <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801e8e:	55                   	push   %ebp
  801e8f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801e91:	8b 45 08             	mov    0x8(%ebp),%eax
  801e94:	6a 00                	push   $0x0
  801e96:	6a 00                	push   $0x0
  801e98:	6a 00                	push   $0x0
  801e9a:	6a 00                	push   $0x0
  801e9c:	50                   	push   %eax
  801e9d:	6a 22                	push   $0x22
  801e9f:	e8 52 fc ff ff       	call   801af6 <syscall>
  801ea4:	83 c4 18             	add    $0x18,%esp
}
  801ea7:	c9                   	leave  
  801ea8:	c3                   	ret    

00801ea9 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801ea9:	55                   	push   %ebp
  801eaa:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801eac:	6a 00                	push   $0x0
  801eae:	6a 00                	push   $0x0
  801eb0:	6a 00                	push   $0x0
  801eb2:	6a 00                	push   $0x0
  801eb4:	6a 00                	push   $0x0
  801eb6:	6a 02                	push   $0x2
  801eb8:	e8 39 fc ff ff       	call   801af6 <syscall>
  801ebd:	83 c4 18             	add    $0x18,%esp
}
  801ec0:	c9                   	leave  
  801ec1:	c3                   	ret    

00801ec2 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801ec2:	55                   	push   %ebp
  801ec3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801ec5:	6a 00                	push   $0x0
  801ec7:	6a 00                	push   $0x0
  801ec9:	6a 00                	push   $0x0
  801ecb:	6a 00                	push   $0x0
  801ecd:	6a 00                	push   $0x0
  801ecf:	6a 03                	push   $0x3
  801ed1:	e8 20 fc ff ff       	call   801af6 <syscall>
  801ed6:	83 c4 18             	add    $0x18,%esp
}
  801ed9:	c9                   	leave  
  801eda:	c3                   	ret    

00801edb <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801edb:	55                   	push   %ebp
  801edc:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801ede:	6a 00                	push   $0x0
  801ee0:	6a 00                	push   $0x0
  801ee2:	6a 00                	push   $0x0
  801ee4:	6a 00                	push   $0x0
  801ee6:	6a 00                	push   $0x0
  801ee8:	6a 04                	push   $0x4
  801eea:	e8 07 fc ff ff       	call   801af6 <syscall>
  801eef:	83 c4 18             	add    $0x18,%esp
}
  801ef2:	c9                   	leave  
  801ef3:	c3                   	ret    

00801ef4 <sys_exit_env>:


void sys_exit_env(void)
{
  801ef4:	55                   	push   %ebp
  801ef5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801ef7:	6a 00                	push   $0x0
  801ef9:	6a 00                	push   $0x0
  801efb:	6a 00                	push   $0x0
  801efd:	6a 00                	push   $0x0
  801eff:	6a 00                	push   $0x0
  801f01:	6a 23                	push   $0x23
  801f03:	e8 ee fb ff ff       	call   801af6 <syscall>
  801f08:	83 c4 18             	add    $0x18,%esp
}
  801f0b:	90                   	nop
  801f0c:	c9                   	leave  
  801f0d:	c3                   	ret    

00801f0e <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801f0e:	55                   	push   %ebp
  801f0f:	89 e5                	mov    %esp,%ebp
  801f11:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801f14:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f17:	8d 50 04             	lea    0x4(%eax),%edx
  801f1a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f1d:	6a 00                	push   $0x0
  801f1f:	6a 00                	push   $0x0
  801f21:	6a 00                	push   $0x0
  801f23:	52                   	push   %edx
  801f24:	50                   	push   %eax
  801f25:	6a 24                	push   $0x24
  801f27:	e8 ca fb ff ff       	call   801af6 <syscall>
  801f2c:	83 c4 18             	add    $0x18,%esp
	return result;
  801f2f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f32:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f35:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801f38:	89 01                	mov    %eax,(%ecx)
  801f3a:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801f3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f40:	c9                   	leave  
  801f41:	c2 04 00             	ret    $0x4

00801f44 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801f44:	55                   	push   %ebp
  801f45:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801f47:	6a 00                	push   $0x0
  801f49:	6a 00                	push   $0x0
  801f4b:	ff 75 10             	pushl  0x10(%ebp)
  801f4e:	ff 75 0c             	pushl  0xc(%ebp)
  801f51:	ff 75 08             	pushl  0x8(%ebp)
  801f54:	6a 12                	push   $0x12
  801f56:	e8 9b fb ff ff       	call   801af6 <syscall>
  801f5b:	83 c4 18             	add    $0x18,%esp
	return ;
  801f5e:	90                   	nop
}
  801f5f:	c9                   	leave  
  801f60:	c3                   	ret    

00801f61 <sys_rcr2>:
uint32 sys_rcr2()
{
  801f61:	55                   	push   %ebp
  801f62:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801f64:	6a 00                	push   $0x0
  801f66:	6a 00                	push   $0x0
  801f68:	6a 00                	push   $0x0
  801f6a:	6a 00                	push   $0x0
  801f6c:	6a 00                	push   $0x0
  801f6e:	6a 25                	push   $0x25
  801f70:	e8 81 fb ff ff       	call   801af6 <syscall>
  801f75:	83 c4 18             	add    $0x18,%esp
}
  801f78:	c9                   	leave  
  801f79:	c3                   	ret    

00801f7a <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801f7a:	55                   	push   %ebp
  801f7b:	89 e5                	mov    %esp,%ebp
  801f7d:	83 ec 04             	sub    $0x4,%esp
  801f80:	8b 45 08             	mov    0x8(%ebp),%eax
  801f83:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801f86:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801f8a:	6a 00                	push   $0x0
  801f8c:	6a 00                	push   $0x0
  801f8e:	6a 00                	push   $0x0
  801f90:	6a 00                	push   $0x0
  801f92:	50                   	push   %eax
  801f93:	6a 26                	push   $0x26
  801f95:	e8 5c fb ff ff       	call   801af6 <syscall>
  801f9a:	83 c4 18             	add    $0x18,%esp
	return ;
  801f9d:	90                   	nop
}
  801f9e:	c9                   	leave  
  801f9f:	c3                   	ret    

00801fa0 <rsttst>:
void rsttst()
{
  801fa0:	55                   	push   %ebp
  801fa1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801fa3:	6a 00                	push   $0x0
  801fa5:	6a 00                	push   $0x0
  801fa7:	6a 00                	push   $0x0
  801fa9:	6a 00                	push   $0x0
  801fab:	6a 00                	push   $0x0
  801fad:	6a 28                	push   $0x28
  801faf:	e8 42 fb ff ff       	call   801af6 <syscall>
  801fb4:	83 c4 18             	add    $0x18,%esp
	return ;
  801fb7:	90                   	nop
}
  801fb8:	c9                   	leave  
  801fb9:	c3                   	ret    

00801fba <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801fba:	55                   	push   %ebp
  801fbb:	89 e5                	mov    %esp,%ebp
  801fbd:	83 ec 04             	sub    $0x4,%esp
  801fc0:	8b 45 14             	mov    0x14(%ebp),%eax
  801fc3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801fc6:	8b 55 18             	mov    0x18(%ebp),%edx
  801fc9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801fcd:	52                   	push   %edx
  801fce:	50                   	push   %eax
  801fcf:	ff 75 10             	pushl  0x10(%ebp)
  801fd2:	ff 75 0c             	pushl  0xc(%ebp)
  801fd5:	ff 75 08             	pushl  0x8(%ebp)
  801fd8:	6a 27                	push   $0x27
  801fda:	e8 17 fb ff ff       	call   801af6 <syscall>
  801fdf:	83 c4 18             	add    $0x18,%esp
	return ;
  801fe2:	90                   	nop
}
  801fe3:	c9                   	leave  
  801fe4:	c3                   	ret    

00801fe5 <chktst>:
void chktst(uint32 n)
{
  801fe5:	55                   	push   %ebp
  801fe6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801fe8:	6a 00                	push   $0x0
  801fea:	6a 00                	push   $0x0
  801fec:	6a 00                	push   $0x0
  801fee:	6a 00                	push   $0x0
  801ff0:	ff 75 08             	pushl  0x8(%ebp)
  801ff3:	6a 29                	push   $0x29
  801ff5:	e8 fc fa ff ff       	call   801af6 <syscall>
  801ffa:	83 c4 18             	add    $0x18,%esp
	return ;
  801ffd:	90                   	nop
}
  801ffe:	c9                   	leave  
  801fff:	c3                   	ret    

00802000 <inctst>:

void inctst()
{
  802000:	55                   	push   %ebp
  802001:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802003:	6a 00                	push   $0x0
  802005:	6a 00                	push   $0x0
  802007:	6a 00                	push   $0x0
  802009:	6a 00                	push   $0x0
  80200b:	6a 00                	push   $0x0
  80200d:	6a 2a                	push   $0x2a
  80200f:	e8 e2 fa ff ff       	call   801af6 <syscall>
  802014:	83 c4 18             	add    $0x18,%esp
	return ;
  802017:	90                   	nop
}
  802018:	c9                   	leave  
  802019:	c3                   	ret    

0080201a <gettst>:
uint32 gettst()
{
  80201a:	55                   	push   %ebp
  80201b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80201d:	6a 00                	push   $0x0
  80201f:	6a 00                	push   $0x0
  802021:	6a 00                	push   $0x0
  802023:	6a 00                	push   $0x0
  802025:	6a 00                	push   $0x0
  802027:	6a 2b                	push   $0x2b
  802029:	e8 c8 fa ff ff       	call   801af6 <syscall>
  80202e:	83 c4 18             	add    $0x18,%esp
}
  802031:	c9                   	leave  
  802032:	c3                   	ret    

00802033 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802033:	55                   	push   %ebp
  802034:	89 e5                	mov    %esp,%ebp
  802036:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802039:	6a 00                	push   $0x0
  80203b:	6a 00                	push   $0x0
  80203d:	6a 00                	push   $0x0
  80203f:	6a 00                	push   $0x0
  802041:	6a 00                	push   $0x0
  802043:	6a 2c                	push   $0x2c
  802045:	e8 ac fa ff ff       	call   801af6 <syscall>
  80204a:	83 c4 18             	add    $0x18,%esp
  80204d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802050:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802054:	75 07                	jne    80205d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802056:	b8 01 00 00 00       	mov    $0x1,%eax
  80205b:	eb 05                	jmp    802062 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80205d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802062:	c9                   	leave  
  802063:	c3                   	ret    

00802064 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802064:	55                   	push   %ebp
  802065:	89 e5                	mov    %esp,%ebp
  802067:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80206a:	6a 00                	push   $0x0
  80206c:	6a 00                	push   $0x0
  80206e:	6a 00                	push   $0x0
  802070:	6a 00                	push   $0x0
  802072:	6a 00                	push   $0x0
  802074:	6a 2c                	push   $0x2c
  802076:	e8 7b fa ff ff       	call   801af6 <syscall>
  80207b:	83 c4 18             	add    $0x18,%esp
  80207e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802081:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802085:	75 07                	jne    80208e <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802087:	b8 01 00 00 00       	mov    $0x1,%eax
  80208c:	eb 05                	jmp    802093 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80208e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802093:	c9                   	leave  
  802094:	c3                   	ret    

00802095 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802095:	55                   	push   %ebp
  802096:	89 e5                	mov    %esp,%ebp
  802098:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80209b:	6a 00                	push   $0x0
  80209d:	6a 00                	push   $0x0
  80209f:	6a 00                	push   $0x0
  8020a1:	6a 00                	push   $0x0
  8020a3:	6a 00                	push   $0x0
  8020a5:	6a 2c                	push   $0x2c
  8020a7:	e8 4a fa ff ff       	call   801af6 <syscall>
  8020ac:	83 c4 18             	add    $0x18,%esp
  8020af:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8020b2:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8020b6:	75 07                	jne    8020bf <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8020b8:	b8 01 00 00 00       	mov    $0x1,%eax
  8020bd:	eb 05                	jmp    8020c4 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8020bf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020c4:	c9                   	leave  
  8020c5:	c3                   	ret    

008020c6 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8020c6:	55                   	push   %ebp
  8020c7:	89 e5                	mov    %esp,%ebp
  8020c9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020cc:	6a 00                	push   $0x0
  8020ce:	6a 00                	push   $0x0
  8020d0:	6a 00                	push   $0x0
  8020d2:	6a 00                	push   $0x0
  8020d4:	6a 00                	push   $0x0
  8020d6:	6a 2c                	push   $0x2c
  8020d8:	e8 19 fa ff ff       	call   801af6 <syscall>
  8020dd:	83 c4 18             	add    $0x18,%esp
  8020e0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8020e3:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8020e7:	75 07                	jne    8020f0 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8020e9:	b8 01 00 00 00       	mov    $0x1,%eax
  8020ee:	eb 05                	jmp    8020f5 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8020f0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020f5:	c9                   	leave  
  8020f6:	c3                   	ret    

008020f7 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8020f7:	55                   	push   %ebp
  8020f8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8020fa:	6a 00                	push   $0x0
  8020fc:	6a 00                	push   $0x0
  8020fe:	6a 00                	push   $0x0
  802100:	6a 00                	push   $0x0
  802102:	ff 75 08             	pushl  0x8(%ebp)
  802105:	6a 2d                	push   $0x2d
  802107:	e8 ea f9 ff ff       	call   801af6 <syscall>
  80210c:	83 c4 18             	add    $0x18,%esp
	return ;
  80210f:	90                   	nop
}
  802110:	c9                   	leave  
  802111:	c3                   	ret    

00802112 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802112:	55                   	push   %ebp
  802113:	89 e5                	mov    %esp,%ebp
  802115:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802116:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802119:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80211c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80211f:	8b 45 08             	mov    0x8(%ebp),%eax
  802122:	6a 00                	push   $0x0
  802124:	53                   	push   %ebx
  802125:	51                   	push   %ecx
  802126:	52                   	push   %edx
  802127:	50                   	push   %eax
  802128:	6a 2e                	push   $0x2e
  80212a:	e8 c7 f9 ff ff       	call   801af6 <syscall>
  80212f:	83 c4 18             	add    $0x18,%esp
}
  802132:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802135:	c9                   	leave  
  802136:	c3                   	ret    

00802137 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802137:	55                   	push   %ebp
  802138:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80213a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80213d:	8b 45 08             	mov    0x8(%ebp),%eax
  802140:	6a 00                	push   $0x0
  802142:	6a 00                	push   $0x0
  802144:	6a 00                	push   $0x0
  802146:	52                   	push   %edx
  802147:	50                   	push   %eax
  802148:	6a 2f                	push   $0x2f
  80214a:	e8 a7 f9 ff ff       	call   801af6 <syscall>
  80214f:	83 c4 18             	add    $0x18,%esp
}
  802152:	c9                   	leave  
  802153:	c3                   	ret    

00802154 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802154:	55                   	push   %ebp
  802155:	89 e5                	mov    %esp,%ebp
  802157:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  80215a:	83 ec 0c             	sub    $0xc,%esp
  80215d:	68 f0 42 80 00       	push   $0x8042f0
  802162:	e8 6b e8 ff ff       	call   8009d2 <cprintf>
  802167:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80216a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802171:	83 ec 0c             	sub    $0xc,%esp
  802174:	68 1c 43 80 00       	push   $0x80431c
  802179:	e8 54 e8 ff ff       	call   8009d2 <cprintf>
  80217e:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802181:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802185:	a1 38 51 80 00       	mov    0x805138,%eax
  80218a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80218d:	eb 56                	jmp    8021e5 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80218f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802193:	74 1c                	je     8021b1 <print_mem_block_lists+0x5d>
  802195:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802198:	8b 50 08             	mov    0x8(%eax),%edx
  80219b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80219e:	8b 48 08             	mov    0x8(%eax),%ecx
  8021a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021a4:	8b 40 0c             	mov    0xc(%eax),%eax
  8021a7:	01 c8                	add    %ecx,%eax
  8021a9:	39 c2                	cmp    %eax,%edx
  8021ab:	73 04                	jae    8021b1 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8021ad:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8021b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b4:	8b 50 08             	mov    0x8(%eax),%edx
  8021b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ba:	8b 40 0c             	mov    0xc(%eax),%eax
  8021bd:	01 c2                	add    %eax,%edx
  8021bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c2:	8b 40 08             	mov    0x8(%eax),%eax
  8021c5:	83 ec 04             	sub    $0x4,%esp
  8021c8:	52                   	push   %edx
  8021c9:	50                   	push   %eax
  8021ca:	68 31 43 80 00       	push   $0x804331
  8021cf:	e8 fe e7 ff ff       	call   8009d2 <cprintf>
  8021d4:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8021d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021da:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8021dd:	a1 40 51 80 00       	mov    0x805140,%eax
  8021e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021e9:	74 07                	je     8021f2 <print_mem_block_lists+0x9e>
  8021eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ee:	8b 00                	mov    (%eax),%eax
  8021f0:	eb 05                	jmp    8021f7 <print_mem_block_lists+0xa3>
  8021f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8021f7:	a3 40 51 80 00       	mov    %eax,0x805140
  8021fc:	a1 40 51 80 00       	mov    0x805140,%eax
  802201:	85 c0                	test   %eax,%eax
  802203:	75 8a                	jne    80218f <print_mem_block_lists+0x3b>
  802205:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802209:	75 84                	jne    80218f <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  80220b:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80220f:	75 10                	jne    802221 <print_mem_block_lists+0xcd>
  802211:	83 ec 0c             	sub    $0xc,%esp
  802214:	68 40 43 80 00       	push   $0x804340
  802219:	e8 b4 e7 ff ff       	call   8009d2 <cprintf>
  80221e:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802221:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802228:	83 ec 0c             	sub    $0xc,%esp
  80222b:	68 64 43 80 00       	push   $0x804364
  802230:	e8 9d e7 ff ff       	call   8009d2 <cprintf>
  802235:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802238:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80223c:	a1 40 50 80 00       	mov    0x805040,%eax
  802241:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802244:	eb 56                	jmp    80229c <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802246:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80224a:	74 1c                	je     802268 <print_mem_block_lists+0x114>
  80224c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80224f:	8b 50 08             	mov    0x8(%eax),%edx
  802252:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802255:	8b 48 08             	mov    0x8(%eax),%ecx
  802258:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80225b:	8b 40 0c             	mov    0xc(%eax),%eax
  80225e:	01 c8                	add    %ecx,%eax
  802260:	39 c2                	cmp    %eax,%edx
  802262:	73 04                	jae    802268 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802264:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802268:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226b:	8b 50 08             	mov    0x8(%eax),%edx
  80226e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802271:	8b 40 0c             	mov    0xc(%eax),%eax
  802274:	01 c2                	add    %eax,%edx
  802276:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802279:	8b 40 08             	mov    0x8(%eax),%eax
  80227c:	83 ec 04             	sub    $0x4,%esp
  80227f:	52                   	push   %edx
  802280:	50                   	push   %eax
  802281:	68 31 43 80 00       	push   $0x804331
  802286:	e8 47 e7 ff ff       	call   8009d2 <cprintf>
  80228b:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80228e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802291:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802294:	a1 48 50 80 00       	mov    0x805048,%eax
  802299:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80229c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022a0:	74 07                	je     8022a9 <print_mem_block_lists+0x155>
  8022a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a5:	8b 00                	mov    (%eax),%eax
  8022a7:	eb 05                	jmp    8022ae <print_mem_block_lists+0x15a>
  8022a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8022ae:	a3 48 50 80 00       	mov    %eax,0x805048
  8022b3:	a1 48 50 80 00       	mov    0x805048,%eax
  8022b8:	85 c0                	test   %eax,%eax
  8022ba:	75 8a                	jne    802246 <print_mem_block_lists+0xf2>
  8022bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022c0:	75 84                	jne    802246 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8022c2:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8022c6:	75 10                	jne    8022d8 <print_mem_block_lists+0x184>
  8022c8:	83 ec 0c             	sub    $0xc,%esp
  8022cb:	68 7c 43 80 00       	push   $0x80437c
  8022d0:	e8 fd e6 ff ff       	call   8009d2 <cprintf>
  8022d5:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8022d8:	83 ec 0c             	sub    $0xc,%esp
  8022db:	68 f0 42 80 00       	push   $0x8042f0
  8022e0:	e8 ed e6 ff ff       	call   8009d2 <cprintf>
  8022e5:	83 c4 10             	add    $0x10,%esp

}
  8022e8:	90                   	nop
  8022e9:	c9                   	leave  
  8022ea:	c3                   	ret    

008022eb <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8022eb:	55                   	push   %ebp
  8022ec:	89 e5                	mov    %esp,%ebp
  8022ee:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  8022f1:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8022f8:	00 00 00 
  8022fb:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802302:	00 00 00 
  802305:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  80230c:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  80230f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802316:	e9 9e 00 00 00       	jmp    8023b9 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  80231b:	a1 50 50 80 00       	mov    0x805050,%eax
  802320:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802323:	c1 e2 04             	shl    $0x4,%edx
  802326:	01 d0                	add    %edx,%eax
  802328:	85 c0                	test   %eax,%eax
  80232a:	75 14                	jne    802340 <initialize_MemBlocksList+0x55>
  80232c:	83 ec 04             	sub    $0x4,%esp
  80232f:	68 a4 43 80 00       	push   $0x8043a4
  802334:	6a 46                	push   $0x46
  802336:	68 c7 43 80 00       	push   $0x8043c7
  80233b:	e8 de e3 ff ff       	call   80071e <_panic>
  802340:	a1 50 50 80 00       	mov    0x805050,%eax
  802345:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802348:	c1 e2 04             	shl    $0x4,%edx
  80234b:	01 d0                	add    %edx,%eax
  80234d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802353:	89 10                	mov    %edx,(%eax)
  802355:	8b 00                	mov    (%eax),%eax
  802357:	85 c0                	test   %eax,%eax
  802359:	74 18                	je     802373 <initialize_MemBlocksList+0x88>
  80235b:	a1 48 51 80 00       	mov    0x805148,%eax
  802360:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802366:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802369:	c1 e1 04             	shl    $0x4,%ecx
  80236c:	01 ca                	add    %ecx,%edx
  80236e:	89 50 04             	mov    %edx,0x4(%eax)
  802371:	eb 12                	jmp    802385 <initialize_MemBlocksList+0x9a>
  802373:	a1 50 50 80 00       	mov    0x805050,%eax
  802378:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80237b:	c1 e2 04             	shl    $0x4,%edx
  80237e:	01 d0                	add    %edx,%eax
  802380:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802385:	a1 50 50 80 00       	mov    0x805050,%eax
  80238a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80238d:	c1 e2 04             	shl    $0x4,%edx
  802390:	01 d0                	add    %edx,%eax
  802392:	a3 48 51 80 00       	mov    %eax,0x805148
  802397:	a1 50 50 80 00       	mov    0x805050,%eax
  80239c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80239f:	c1 e2 04             	shl    $0x4,%edx
  8023a2:	01 d0                	add    %edx,%eax
  8023a4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023ab:	a1 54 51 80 00       	mov    0x805154,%eax
  8023b0:	40                   	inc    %eax
  8023b1:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  8023b6:	ff 45 f4             	incl   -0xc(%ebp)
  8023b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023bc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023bf:	0f 82 56 ff ff ff    	jb     80231b <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  8023c5:	90                   	nop
  8023c6:	c9                   	leave  
  8023c7:	c3                   	ret    

008023c8 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8023c8:	55                   	push   %ebp
  8023c9:	89 e5                	mov    %esp,%ebp
  8023cb:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8023ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d1:	8b 00                	mov    (%eax),%eax
  8023d3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8023d6:	eb 19                	jmp    8023f1 <find_block+0x29>
	{
		if(va==point->sva)
  8023d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023db:	8b 40 08             	mov    0x8(%eax),%eax
  8023de:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8023e1:	75 05                	jne    8023e8 <find_block+0x20>
		   return point;
  8023e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023e6:	eb 36                	jmp    80241e <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8023e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023eb:	8b 40 08             	mov    0x8(%eax),%eax
  8023ee:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8023f1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8023f5:	74 07                	je     8023fe <find_block+0x36>
  8023f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023fa:	8b 00                	mov    (%eax),%eax
  8023fc:	eb 05                	jmp    802403 <find_block+0x3b>
  8023fe:	b8 00 00 00 00       	mov    $0x0,%eax
  802403:	8b 55 08             	mov    0x8(%ebp),%edx
  802406:	89 42 08             	mov    %eax,0x8(%edx)
  802409:	8b 45 08             	mov    0x8(%ebp),%eax
  80240c:	8b 40 08             	mov    0x8(%eax),%eax
  80240f:	85 c0                	test   %eax,%eax
  802411:	75 c5                	jne    8023d8 <find_block+0x10>
  802413:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802417:	75 bf                	jne    8023d8 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802419:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80241e:	c9                   	leave  
  80241f:	c3                   	ret    

00802420 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802420:	55                   	push   %ebp
  802421:	89 e5                	mov    %esp,%ebp
  802423:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802426:	a1 40 50 80 00       	mov    0x805040,%eax
  80242b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  80242e:	a1 44 50 80 00       	mov    0x805044,%eax
  802433:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802436:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802439:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80243c:	74 24                	je     802462 <insert_sorted_allocList+0x42>
  80243e:	8b 45 08             	mov    0x8(%ebp),%eax
  802441:	8b 50 08             	mov    0x8(%eax),%edx
  802444:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802447:	8b 40 08             	mov    0x8(%eax),%eax
  80244a:	39 c2                	cmp    %eax,%edx
  80244c:	76 14                	jbe    802462 <insert_sorted_allocList+0x42>
  80244e:	8b 45 08             	mov    0x8(%ebp),%eax
  802451:	8b 50 08             	mov    0x8(%eax),%edx
  802454:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802457:	8b 40 08             	mov    0x8(%eax),%eax
  80245a:	39 c2                	cmp    %eax,%edx
  80245c:	0f 82 60 01 00 00    	jb     8025c2 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802462:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802466:	75 65                	jne    8024cd <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802468:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80246c:	75 14                	jne    802482 <insert_sorted_allocList+0x62>
  80246e:	83 ec 04             	sub    $0x4,%esp
  802471:	68 a4 43 80 00       	push   $0x8043a4
  802476:	6a 6b                	push   $0x6b
  802478:	68 c7 43 80 00       	push   $0x8043c7
  80247d:	e8 9c e2 ff ff       	call   80071e <_panic>
  802482:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802488:	8b 45 08             	mov    0x8(%ebp),%eax
  80248b:	89 10                	mov    %edx,(%eax)
  80248d:	8b 45 08             	mov    0x8(%ebp),%eax
  802490:	8b 00                	mov    (%eax),%eax
  802492:	85 c0                	test   %eax,%eax
  802494:	74 0d                	je     8024a3 <insert_sorted_allocList+0x83>
  802496:	a1 40 50 80 00       	mov    0x805040,%eax
  80249b:	8b 55 08             	mov    0x8(%ebp),%edx
  80249e:	89 50 04             	mov    %edx,0x4(%eax)
  8024a1:	eb 08                	jmp    8024ab <insert_sorted_allocList+0x8b>
  8024a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a6:	a3 44 50 80 00       	mov    %eax,0x805044
  8024ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ae:	a3 40 50 80 00       	mov    %eax,0x805040
  8024b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024bd:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8024c2:	40                   	inc    %eax
  8024c3:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8024c8:	e9 dc 01 00 00       	jmp    8026a9 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8024cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d0:	8b 50 08             	mov    0x8(%eax),%edx
  8024d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024d6:	8b 40 08             	mov    0x8(%eax),%eax
  8024d9:	39 c2                	cmp    %eax,%edx
  8024db:	77 6c                	ja     802549 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8024dd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024e1:	74 06                	je     8024e9 <insert_sorted_allocList+0xc9>
  8024e3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024e7:	75 14                	jne    8024fd <insert_sorted_allocList+0xdd>
  8024e9:	83 ec 04             	sub    $0x4,%esp
  8024ec:	68 e0 43 80 00       	push   $0x8043e0
  8024f1:	6a 6f                	push   $0x6f
  8024f3:	68 c7 43 80 00       	push   $0x8043c7
  8024f8:	e8 21 e2 ff ff       	call   80071e <_panic>
  8024fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802500:	8b 50 04             	mov    0x4(%eax),%edx
  802503:	8b 45 08             	mov    0x8(%ebp),%eax
  802506:	89 50 04             	mov    %edx,0x4(%eax)
  802509:	8b 45 08             	mov    0x8(%ebp),%eax
  80250c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80250f:	89 10                	mov    %edx,(%eax)
  802511:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802514:	8b 40 04             	mov    0x4(%eax),%eax
  802517:	85 c0                	test   %eax,%eax
  802519:	74 0d                	je     802528 <insert_sorted_allocList+0x108>
  80251b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80251e:	8b 40 04             	mov    0x4(%eax),%eax
  802521:	8b 55 08             	mov    0x8(%ebp),%edx
  802524:	89 10                	mov    %edx,(%eax)
  802526:	eb 08                	jmp    802530 <insert_sorted_allocList+0x110>
  802528:	8b 45 08             	mov    0x8(%ebp),%eax
  80252b:	a3 40 50 80 00       	mov    %eax,0x805040
  802530:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802533:	8b 55 08             	mov    0x8(%ebp),%edx
  802536:	89 50 04             	mov    %edx,0x4(%eax)
  802539:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80253e:	40                   	inc    %eax
  80253f:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802544:	e9 60 01 00 00       	jmp    8026a9 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802549:	8b 45 08             	mov    0x8(%ebp),%eax
  80254c:	8b 50 08             	mov    0x8(%eax),%edx
  80254f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802552:	8b 40 08             	mov    0x8(%eax),%eax
  802555:	39 c2                	cmp    %eax,%edx
  802557:	0f 82 4c 01 00 00    	jb     8026a9 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  80255d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802561:	75 14                	jne    802577 <insert_sorted_allocList+0x157>
  802563:	83 ec 04             	sub    $0x4,%esp
  802566:	68 18 44 80 00       	push   $0x804418
  80256b:	6a 73                	push   $0x73
  80256d:	68 c7 43 80 00       	push   $0x8043c7
  802572:	e8 a7 e1 ff ff       	call   80071e <_panic>
  802577:	8b 15 44 50 80 00    	mov    0x805044,%edx
  80257d:	8b 45 08             	mov    0x8(%ebp),%eax
  802580:	89 50 04             	mov    %edx,0x4(%eax)
  802583:	8b 45 08             	mov    0x8(%ebp),%eax
  802586:	8b 40 04             	mov    0x4(%eax),%eax
  802589:	85 c0                	test   %eax,%eax
  80258b:	74 0c                	je     802599 <insert_sorted_allocList+0x179>
  80258d:	a1 44 50 80 00       	mov    0x805044,%eax
  802592:	8b 55 08             	mov    0x8(%ebp),%edx
  802595:	89 10                	mov    %edx,(%eax)
  802597:	eb 08                	jmp    8025a1 <insert_sorted_allocList+0x181>
  802599:	8b 45 08             	mov    0x8(%ebp),%eax
  80259c:	a3 40 50 80 00       	mov    %eax,0x805040
  8025a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a4:	a3 44 50 80 00       	mov    %eax,0x805044
  8025a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025b2:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8025b7:	40                   	inc    %eax
  8025b8:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8025bd:	e9 e7 00 00 00       	jmp    8026a9 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8025c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8025c8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8025cf:	a1 40 50 80 00       	mov    0x805040,%eax
  8025d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025d7:	e9 9d 00 00 00       	jmp    802679 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8025dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025df:	8b 00                	mov    (%eax),%eax
  8025e1:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8025e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e7:	8b 50 08             	mov    0x8(%eax),%edx
  8025ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ed:	8b 40 08             	mov    0x8(%eax),%eax
  8025f0:	39 c2                	cmp    %eax,%edx
  8025f2:	76 7d                	jbe    802671 <insert_sorted_allocList+0x251>
  8025f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f7:	8b 50 08             	mov    0x8(%eax),%edx
  8025fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8025fd:	8b 40 08             	mov    0x8(%eax),%eax
  802600:	39 c2                	cmp    %eax,%edx
  802602:	73 6d                	jae    802671 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802604:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802608:	74 06                	je     802610 <insert_sorted_allocList+0x1f0>
  80260a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80260e:	75 14                	jne    802624 <insert_sorted_allocList+0x204>
  802610:	83 ec 04             	sub    $0x4,%esp
  802613:	68 3c 44 80 00       	push   $0x80443c
  802618:	6a 7f                	push   $0x7f
  80261a:	68 c7 43 80 00       	push   $0x8043c7
  80261f:	e8 fa e0 ff ff       	call   80071e <_panic>
  802624:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802627:	8b 10                	mov    (%eax),%edx
  802629:	8b 45 08             	mov    0x8(%ebp),%eax
  80262c:	89 10                	mov    %edx,(%eax)
  80262e:	8b 45 08             	mov    0x8(%ebp),%eax
  802631:	8b 00                	mov    (%eax),%eax
  802633:	85 c0                	test   %eax,%eax
  802635:	74 0b                	je     802642 <insert_sorted_allocList+0x222>
  802637:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263a:	8b 00                	mov    (%eax),%eax
  80263c:	8b 55 08             	mov    0x8(%ebp),%edx
  80263f:	89 50 04             	mov    %edx,0x4(%eax)
  802642:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802645:	8b 55 08             	mov    0x8(%ebp),%edx
  802648:	89 10                	mov    %edx,(%eax)
  80264a:	8b 45 08             	mov    0x8(%ebp),%eax
  80264d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802650:	89 50 04             	mov    %edx,0x4(%eax)
  802653:	8b 45 08             	mov    0x8(%ebp),%eax
  802656:	8b 00                	mov    (%eax),%eax
  802658:	85 c0                	test   %eax,%eax
  80265a:	75 08                	jne    802664 <insert_sorted_allocList+0x244>
  80265c:	8b 45 08             	mov    0x8(%ebp),%eax
  80265f:	a3 44 50 80 00       	mov    %eax,0x805044
  802664:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802669:	40                   	inc    %eax
  80266a:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  80266f:	eb 39                	jmp    8026aa <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802671:	a1 48 50 80 00       	mov    0x805048,%eax
  802676:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802679:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80267d:	74 07                	je     802686 <insert_sorted_allocList+0x266>
  80267f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802682:	8b 00                	mov    (%eax),%eax
  802684:	eb 05                	jmp    80268b <insert_sorted_allocList+0x26b>
  802686:	b8 00 00 00 00       	mov    $0x0,%eax
  80268b:	a3 48 50 80 00       	mov    %eax,0x805048
  802690:	a1 48 50 80 00       	mov    0x805048,%eax
  802695:	85 c0                	test   %eax,%eax
  802697:	0f 85 3f ff ff ff    	jne    8025dc <insert_sorted_allocList+0x1bc>
  80269d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026a1:	0f 85 35 ff ff ff    	jne    8025dc <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8026a7:	eb 01                	jmp    8026aa <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8026a9:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8026aa:	90                   	nop
  8026ab:	c9                   	leave  
  8026ac:	c3                   	ret    

008026ad <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8026ad:	55                   	push   %ebp
  8026ae:	89 e5                	mov    %esp,%ebp
  8026b0:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8026b3:	a1 38 51 80 00       	mov    0x805138,%eax
  8026b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026bb:	e9 85 01 00 00       	jmp    802845 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8026c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c3:	8b 40 0c             	mov    0xc(%eax),%eax
  8026c6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026c9:	0f 82 6e 01 00 00    	jb     80283d <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8026cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d2:	8b 40 0c             	mov    0xc(%eax),%eax
  8026d5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026d8:	0f 85 8a 00 00 00    	jne    802768 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8026de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026e2:	75 17                	jne    8026fb <alloc_block_FF+0x4e>
  8026e4:	83 ec 04             	sub    $0x4,%esp
  8026e7:	68 70 44 80 00       	push   $0x804470
  8026ec:	68 93 00 00 00       	push   $0x93
  8026f1:	68 c7 43 80 00       	push   $0x8043c7
  8026f6:	e8 23 e0 ff ff       	call   80071e <_panic>
  8026fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fe:	8b 00                	mov    (%eax),%eax
  802700:	85 c0                	test   %eax,%eax
  802702:	74 10                	je     802714 <alloc_block_FF+0x67>
  802704:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802707:	8b 00                	mov    (%eax),%eax
  802709:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80270c:	8b 52 04             	mov    0x4(%edx),%edx
  80270f:	89 50 04             	mov    %edx,0x4(%eax)
  802712:	eb 0b                	jmp    80271f <alloc_block_FF+0x72>
  802714:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802717:	8b 40 04             	mov    0x4(%eax),%eax
  80271a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80271f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802722:	8b 40 04             	mov    0x4(%eax),%eax
  802725:	85 c0                	test   %eax,%eax
  802727:	74 0f                	je     802738 <alloc_block_FF+0x8b>
  802729:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272c:	8b 40 04             	mov    0x4(%eax),%eax
  80272f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802732:	8b 12                	mov    (%edx),%edx
  802734:	89 10                	mov    %edx,(%eax)
  802736:	eb 0a                	jmp    802742 <alloc_block_FF+0x95>
  802738:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273b:	8b 00                	mov    (%eax),%eax
  80273d:	a3 38 51 80 00       	mov    %eax,0x805138
  802742:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802745:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80274b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802755:	a1 44 51 80 00       	mov    0x805144,%eax
  80275a:	48                   	dec    %eax
  80275b:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802760:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802763:	e9 10 01 00 00       	jmp    802878 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802768:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276b:	8b 40 0c             	mov    0xc(%eax),%eax
  80276e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802771:	0f 86 c6 00 00 00    	jbe    80283d <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802777:	a1 48 51 80 00       	mov    0x805148,%eax
  80277c:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  80277f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802782:	8b 50 08             	mov    0x8(%eax),%edx
  802785:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802788:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  80278b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80278e:	8b 55 08             	mov    0x8(%ebp),%edx
  802791:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802794:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802798:	75 17                	jne    8027b1 <alloc_block_FF+0x104>
  80279a:	83 ec 04             	sub    $0x4,%esp
  80279d:	68 70 44 80 00       	push   $0x804470
  8027a2:	68 9b 00 00 00       	push   $0x9b
  8027a7:	68 c7 43 80 00       	push   $0x8043c7
  8027ac:	e8 6d df ff ff       	call   80071e <_panic>
  8027b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027b4:	8b 00                	mov    (%eax),%eax
  8027b6:	85 c0                	test   %eax,%eax
  8027b8:	74 10                	je     8027ca <alloc_block_FF+0x11d>
  8027ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027bd:	8b 00                	mov    (%eax),%eax
  8027bf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027c2:	8b 52 04             	mov    0x4(%edx),%edx
  8027c5:	89 50 04             	mov    %edx,0x4(%eax)
  8027c8:	eb 0b                	jmp    8027d5 <alloc_block_FF+0x128>
  8027ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027cd:	8b 40 04             	mov    0x4(%eax),%eax
  8027d0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8027d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027d8:	8b 40 04             	mov    0x4(%eax),%eax
  8027db:	85 c0                	test   %eax,%eax
  8027dd:	74 0f                	je     8027ee <alloc_block_FF+0x141>
  8027df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027e2:	8b 40 04             	mov    0x4(%eax),%eax
  8027e5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027e8:	8b 12                	mov    (%edx),%edx
  8027ea:	89 10                	mov    %edx,(%eax)
  8027ec:	eb 0a                	jmp    8027f8 <alloc_block_FF+0x14b>
  8027ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027f1:	8b 00                	mov    (%eax),%eax
  8027f3:	a3 48 51 80 00       	mov    %eax,0x805148
  8027f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027fb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802801:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802804:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80280b:	a1 54 51 80 00       	mov    0x805154,%eax
  802810:	48                   	dec    %eax
  802811:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802816:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802819:	8b 50 08             	mov    0x8(%eax),%edx
  80281c:	8b 45 08             	mov    0x8(%ebp),%eax
  80281f:	01 c2                	add    %eax,%edx
  802821:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802824:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802827:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282a:	8b 40 0c             	mov    0xc(%eax),%eax
  80282d:	2b 45 08             	sub    0x8(%ebp),%eax
  802830:	89 c2                	mov    %eax,%edx
  802832:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802835:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802838:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80283b:	eb 3b                	jmp    802878 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80283d:	a1 40 51 80 00       	mov    0x805140,%eax
  802842:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802845:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802849:	74 07                	je     802852 <alloc_block_FF+0x1a5>
  80284b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284e:	8b 00                	mov    (%eax),%eax
  802850:	eb 05                	jmp    802857 <alloc_block_FF+0x1aa>
  802852:	b8 00 00 00 00       	mov    $0x0,%eax
  802857:	a3 40 51 80 00       	mov    %eax,0x805140
  80285c:	a1 40 51 80 00       	mov    0x805140,%eax
  802861:	85 c0                	test   %eax,%eax
  802863:	0f 85 57 fe ff ff    	jne    8026c0 <alloc_block_FF+0x13>
  802869:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80286d:	0f 85 4d fe ff ff    	jne    8026c0 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802873:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802878:	c9                   	leave  
  802879:	c3                   	ret    

0080287a <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80287a:	55                   	push   %ebp
  80287b:	89 e5                	mov    %esp,%ebp
  80287d:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802880:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802887:	a1 38 51 80 00       	mov    0x805138,%eax
  80288c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80288f:	e9 df 00 00 00       	jmp    802973 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802894:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802897:	8b 40 0c             	mov    0xc(%eax),%eax
  80289a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80289d:	0f 82 c8 00 00 00    	jb     80296b <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8028a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a6:	8b 40 0c             	mov    0xc(%eax),%eax
  8028a9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028ac:	0f 85 8a 00 00 00    	jne    80293c <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8028b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028b6:	75 17                	jne    8028cf <alloc_block_BF+0x55>
  8028b8:	83 ec 04             	sub    $0x4,%esp
  8028bb:	68 70 44 80 00       	push   $0x804470
  8028c0:	68 b7 00 00 00       	push   $0xb7
  8028c5:	68 c7 43 80 00       	push   $0x8043c7
  8028ca:	e8 4f de ff ff       	call   80071e <_panic>
  8028cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d2:	8b 00                	mov    (%eax),%eax
  8028d4:	85 c0                	test   %eax,%eax
  8028d6:	74 10                	je     8028e8 <alloc_block_BF+0x6e>
  8028d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028db:	8b 00                	mov    (%eax),%eax
  8028dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028e0:	8b 52 04             	mov    0x4(%edx),%edx
  8028e3:	89 50 04             	mov    %edx,0x4(%eax)
  8028e6:	eb 0b                	jmp    8028f3 <alloc_block_BF+0x79>
  8028e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028eb:	8b 40 04             	mov    0x4(%eax),%eax
  8028ee:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8028f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f6:	8b 40 04             	mov    0x4(%eax),%eax
  8028f9:	85 c0                	test   %eax,%eax
  8028fb:	74 0f                	je     80290c <alloc_block_BF+0x92>
  8028fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802900:	8b 40 04             	mov    0x4(%eax),%eax
  802903:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802906:	8b 12                	mov    (%edx),%edx
  802908:	89 10                	mov    %edx,(%eax)
  80290a:	eb 0a                	jmp    802916 <alloc_block_BF+0x9c>
  80290c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290f:	8b 00                	mov    (%eax),%eax
  802911:	a3 38 51 80 00       	mov    %eax,0x805138
  802916:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802919:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80291f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802922:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802929:	a1 44 51 80 00       	mov    0x805144,%eax
  80292e:	48                   	dec    %eax
  80292f:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802934:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802937:	e9 4d 01 00 00       	jmp    802a89 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  80293c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293f:	8b 40 0c             	mov    0xc(%eax),%eax
  802942:	3b 45 08             	cmp    0x8(%ebp),%eax
  802945:	76 24                	jbe    80296b <alloc_block_BF+0xf1>
  802947:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294a:	8b 40 0c             	mov    0xc(%eax),%eax
  80294d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802950:	73 19                	jae    80296b <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802952:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802959:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295c:	8b 40 0c             	mov    0xc(%eax),%eax
  80295f:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802962:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802965:	8b 40 08             	mov    0x8(%eax),%eax
  802968:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80296b:	a1 40 51 80 00       	mov    0x805140,%eax
  802970:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802973:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802977:	74 07                	je     802980 <alloc_block_BF+0x106>
  802979:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297c:	8b 00                	mov    (%eax),%eax
  80297e:	eb 05                	jmp    802985 <alloc_block_BF+0x10b>
  802980:	b8 00 00 00 00       	mov    $0x0,%eax
  802985:	a3 40 51 80 00       	mov    %eax,0x805140
  80298a:	a1 40 51 80 00       	mov    0x805140,%eax
  80298f:	85 c0                	test   %eax,%eax
  802991:	0f 85 fd fe ff ff    	jne    802894 <alloc_block_BF+0x1a>
  802997:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80299b:	0f 85 f3 fe ff ff    	jne    802894 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  8029a1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8029a5:	0f 84 d9 00 00 00    	je     802a84 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8029ab:	a1 48 51 80 00       	mov    0x805148,%eax
  8029b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8029b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029b6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029b9:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8029bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8029c2:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  8029c5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8029c9:	75 17                	jne    8029e2 <alloc_block_BF+0x168>
  8029cb:	83 ec 04             	sub    $0x4,%esp
  8029ce:	68 70 44 80 00       	push   $0x804470
  8029d3:	68 c7 00 00 00       	push   $0xc7
  8029d8:	68 c7 43 80 00       	push   $0x8043c7
  8029dd:	e8 3c dd ff ff       	call   80071e <_panic>
  8029e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029e5:	8b 00                	mov    (%eax),%eax
  8029e7:	85 c0                	test   %eax,%eax
  8029e9:	74 10                	je     8029fb <alloc_block_BF+0x181>
  8029eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029ee:	8b 00                	mov    (%eax),%eax
  8029f0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8029f3:	8b 52 04             	mov    0x4(%edx),%edx
  8029f6:	89 50 04             	mov    %edx,0x4(%eax)
  8029f9:	eb 0b                	jmp    802a06 <alloc_block_BF+0x18c>
  8029fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029fe:	8b 40 04             	mov    0x4(%eax),%eax
  802a01:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a06:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a09:	8b 40 04             	mov    0x4(%eax),%eax
  802a0c:	85 c0                	test   %eax,%eax
  802a0e:	74 0f                	je     802a1f <alloc_block_BF+0x1a5>
  802a10:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a13:	8b 40 04             	mov    0x4(%eax),%eax
  802a16:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802a19:	8b 12                	mov    (%edx),%edx
  802a1b:	89 10                	mov    %edx,(%eax)
  802a1d:	eb 0a                	jmp    802a29 <alloc_block_BF+0x1af>
  802a1f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a22:	8b 00                	mov    (%eax),%eax
  802a24:	a3 48 51 80 00       	mov    %eax,0x805148
  802a29:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a2c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a35:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a3c:	a1 54 51 80 00       	mov    0x805154,%eax
  802a41:	48                   	dec    %eax
  802a42:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802a47:	83 ec 08             	sub    $0x8,%esp
  802a4a:	ff 75 ec             	pushl  -0x14(%ebp)
  802a4d:	68 38 51 80 00       	push   $0x805138
  802a52:	e8 71 f9 ff ff       	call   8023c8 <find_block>
  802a57:	83 c4 10             	add    $0x10,%esp
  802a5a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802a5d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a60:	8b 50 08             	mov    0x8(%eax),%edx
  802a63:	8b 45 08             	mov    0x8(%ebp),%eax
  802a66:	01 c2                	add    %eax,%edx
  802a68:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a6b:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802a6e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a71:	8b 40 0c             	mov    0xc(%eax),%eax
  802a74:	2b 45 08             	sub    0x8(%ebp),%eax
  802a77:	89 c2                	mov    %eax,%edx
  802a79:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a7c:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802a7f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a82:	eb 05                	jmp    802a89 <alloc_block_BF+0x20f>
	}
	return NULL;
  802a84:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a89:	c9                   	leave  
  802a8a:	c3                   	ret    

00802a8b <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802a8b:	55                   	push   %ebp
  802a8c:	89 e5                	mov    %esp,%ebp
  802a8e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802a91:	a1 28 50 80 00       	mov    0x805028,%eax
  802a96:	85 c0                	test   %eax,%eax
  802a98:	0f 85 de 01 00 00    	jne    802c7c <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802a9e:	a1 38 51 80 00       	mov    0x805138,%eax
  802aa3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802aa6:	e9 9e 01 00 00       	jmp    802c49 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802aab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aae:	8b 40 0c             	mov    0xc(%eax),%eax
  802ab1:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ab4:	0f 82 87 01 00 00    	jb     802c41 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802aba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802abd:	8b 40 0c             	mov    0xc(%eax),%eax
  802ac0:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ac3:	0f 85 95 00 00 00    	jne    802b5e <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802ac9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802acd:	75 17                	jne    802ae6 <alloc_block_NF+0x5b>
  802acf:	83 ec 04             	sub    $0x4,%esp
  802ad2:	68 70 44 80 00       	push   $0x804470
  802ad7:	68 e0 00 00 00       	push   $0xe0
  802adc:	68 c7 43 80 00       	push   $0x8043c7
  802ae1:	e8 38 dc ff ff       	call   80071e <_panic>
  802ae6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae9:	8b 00                	mov    (%eax),%eax
  802aeb:	85 c0                	test   %eax,%eax
  802aed:	74 10                	je     802aff <alloc_block_NF+0x74>
  802aef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af2:	8b 00                	mov    (%eax),%eax
  802af4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802af7:	8b 52 04             	mov    0x4(%edx),%edx
  802afa:	89 50 04             	mov    %edx,0x4(%eax)
  802afd:	eb 0b                	jmp    802b0a <alloc_block_NF+0x7f>
  802aff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b02:	8b 40 04             	mov    0x4(%eax),%eax
  802b05:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0d:	8b 40 04             	mov    0x4(%eax),%eax
  802b10:	85 c0                	test   %eax,%eax
  802b12:	74 0f                	je     802b23 <alloc_block_NF+0x98>
  802b14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b17:	8b 40 04             	mov    0x4(%eax),%eax
  802b1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b1d:	8b 12                	mov    (%edx),%edx
  802b1f:	89 10                	mov    %edx,(%eax)
  802b21:	eb 0a                	jmp    802b2d <alloc_block_NF+0xa2>
  802b23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b26:	8b 00                	mov    (%eax),%eax
  802b28:	a3 38 51 80 00       	mov    %eax,0x805138
  802b2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b30:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b39:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b40:	a1 44 51 80 00       	mov    0x805144,%eax
  802b45:	48                   	dec    %eax
  802b46:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802b4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4e:	8b 40 08             	mov    0x8(%eax),%eax
  802b51:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802b56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b59:	e9 f8 04 00 00       	jmp    803056 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802b5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b61:	8b 40 0c             	mov    0xc(%eax),%eax
  802b64:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b67:	0f 86 d4 00 00 00    	jbe    802c41 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b6d:	a1 48 51 80 00       	mov    0x805148,%eax
  802b72:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802b75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b78:	8b 50 08             	mov    0x8(%eax),%edx
  802b7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b7e:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802b81:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b84:	8b 55 08             	mov    0x8(%ebp),%edx
  802b87:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802b8a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b8e:	75 17                	jne    802ba7 <alloc_block_NF+0x11c>
  802b90:	83 ec 04             	sub    $0x4,%esp
  802b93:	68 70 44 80 00       	push   $0x804470
  802b98:	68 e9 00 00 00       	push   $0xe9
  802b9d:	68 c7 43 80 00       	push   $0x8043c7
  802ba2:	e8 77 db ff ff       	call   80071e <_panic>
  802ba7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802baa:	8b 00                	mov    (%eax),%eax
  802bac:	85 c0                	test   %eax,%eax
  802bae:	74 10                	je     802bc0 <alloc_block_NF+0x135>
  802bb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bb3:	8b 00                	mov    (%eax),%eax
  802bb5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bb8:	8b 52 04             	mov    0x4(%edx),%edx
  802bbb:	89 50 04             	mov    %edx,0x4(%eax)
  802bbe:	eb 0b                	jmp    802bcb <alloc_block_NF+0x140>
  802bc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bc3:	8b 40 04             	mov    0x4(%eax),%eax
  802bc6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802bcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bce:	8b 40 04             	mov    0x4(%eax),%eax
  802bd1:	85 c0                	test   %eax,%eax
  802bd3:	74 0f                	je     802be4 <alloc_block_NF+0x159>
  802bd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bd8:	8b 40 04             	mov    0x4(%eax),%eax
  802bdb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bde:	8b 12                	mov    (%edx),%edx
  802be0:	89 10                	mov    %edx,(%eax)
  802be2:	eb 0a                	jmp    802bee <alloc_block_NF+0x163>
  802be4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802be7:	8b 00                	mov    (%eax),%eax
  802be9:	a3 48 51 80 00       	mov    %eax,0x805148
  802bee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bf1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bf7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bfa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c01:	a1 54 51 80 00       	mov    0x805154,%eax
  802c06:	48                   	dec    %eax
  802c07:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802c0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c0f:	8b 40 08             	mov    0x8(%eax),%eax
  802c12:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802c17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1a:	8b 50 08             	mov    0x8(%eax),%edx
  802c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c20:	01 c2                	add    %eax,%edx
  802c22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c25:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802c28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2b:	8b 40 0c             	mov    0xc(%eax),%eax
  802c2e:	2b 45 08             	sub    0x8(%ebp),%eax
  802c31:	89 c2                	mov    %eax,%edx
  802c33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c36:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802c39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c3c:	e9 15 04 00 00       	jmp    803056 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802c41:	a1 40 51 80 00       	mov    0x805140,%eax
  802c46:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c49:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c4d:	74 07                	je     802c56 <alloc_block_NF+0x1cb>
  802c4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c52:	8b 00                	mov    (%eax),%eax
  802c54:	eb 05                	jmp    802c5b <alloc_block_NF+0x1d0>
  802c56:	b8 00 00 00 00       	mov    $0x0,%eax
  802c5b:	a3 40 51 80 00       	mov    %eax,0x805140
  802c60:	a1 40 51 80 00       	mov    0x805140,%eax
  802c65:	85 c0                	test   %eax,%eax
  802c67:	0f 85 3e fe ff ff    	jne    802aab <alloc_block_NF+0x20>
  802c6d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c71:	0f 85 34 fe ff ff    	jne    802aab <alloc_block_NF+0x20>
  802c77:	e9 d5 03 00 00       	jmp    803051 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c7c:	a1 38 51 80 00       	mov    0x805138,%eax
  802c81:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c84:	e9 b1 01 00 00       	jmp    802e3a <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802c89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8c:	8b 50 08             	mov    0x8(%eax),%edx
  802c8f:	a1 28 50 80 00       	mov    0x805028,%eax
  802c94:	39 c2                	cmp    %eax,%edx
  802c96:	0f 82 96 01 00 00    	jb     802e32 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802c9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9f:	8b 40 0c             	mov    0xc(%eax),%eax
  802ca2:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ca5:	0f 82 87 01 00 00    	jb     802e32 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802cab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cae:	8b 40 0c             	mov    0xc(%eax),%eax
  802cb1:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cb4:	0f 85 95 00 00 00    	jne    802d4f <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802cba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cbe:	75 17                	jne    802cd7 <alloc_block_NF+0x24c>
  802cc0:	83 ec 04             	sub    $0x4,%esp
  802cc3:	68 70 44 80 00       	push   $0x804470
  802cc8:	68 fc 00 00 00       	push   $0xfc
  802ccd:	68 c7 43 80 00       	push   $0x8043c7
  802cd2:	e8 47 da ff ff       	call   80071e <_panic>
  802cd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cda:	8b 00                	mov    (%eax),%eax
  802cdc:	85 c0                	test   %eax,%eax
  802cde:	74 10                	je     802cf0 <alloc_block_NF+0x265>
  802ce0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce3:	8b 00                	mov    (%eax),%eax
  802ce5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ce8:	8b 52 04             	mov    0x4(%edx),%edx
  802ceb:	89 50 04             	mov    %edx,0x4(%eax)
  802cee:	eb 0b                	jmp    802cfb <alloc_block_NF+0x270>
  802cf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf3:	8b 40 04             	mov    0x4(%eax),%eax
  802cf6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802cfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfe:	8b 40 04             	mov    0x4(%eax),%eax
  802d01:	85 c0                	test   %eax,%eax
  802d03:	74 0f                	je     802d14 <alloc_block_NF+0x289>
  802d05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d08:	8b 40 04             	mov    0x4(%eax),%eax
  802d0b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d0e:	8b 12                	mov    (%edx),%edx
  802d10:	89 10                	mov    %edx,(%eax)
  802d12:	eb 0a                	jmp    802d1e <alloc_block_NF+0x293>
  802d14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d17:	8b 00                	mov    (%eax),%eax
  802d19:	a3 38 51 80 00       	mov    %eax,0x805138
  802d1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d21:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d31:	a1 44 51 80 00       	mov    0x805144,%eax
  802d36:	48                   	dec    %eax
  802d37:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802d3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3f:	8b 40 08             	mov    0x8(%eax),%eax
  802d42:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802d47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4a:	e9 07 03 00 00       	jmp    803056 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802d4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d52:	8b 40 0c             	mov    0xc(%eax),%eax
  802d55:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d58:	0f 86 d4 00 00 00    	jbe    802e32 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802d5e:	a1 48 51 80 00       	mov    0x805148,%eax
  802d63:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802d66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d69:	8b 50 08             	mov    0x8(%eax),%edx
  802d6c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d6f:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802d72:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d75:	8b 55 08             	mov    0x8(%ebp),%edx
  802d78:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802d7b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802d7f:	75 17                	jne    802d98 <alloc_block_NF+0x30d>
  802d81:	83 ec 04             	sub    $0x4,%esp
  802d84:	68 70 44 80 00       	push   $0x804470
  802d89:	68 04 01 00 00       	push   $0x104
  802d8e:	68 c7 43 80 00       	push   $0x8043c7
  802d93:	e8 86 d9 ff ff       	call   80071e <_panic>
  802d98:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d9b:	8b 00                	mov    (%eax),%eax
  802d9d:	85 c0                	test   %eax,%eax
  802d9f:	74 10                	je     802db1 <alloc_block_NF+0x326>
  802da1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802da4:	8b 00                	mov    (%eax),%eax
  802da6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802da9:	8b 52 04             	mov    0x4(%edx),%edx
  802dac:	89 50 04             	mov    %edx,0x4(%eax)
  802daf:	eb 0b                	jmp    802dbc <alloc_block_NF+0x331>
  802db1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802db4:	8b 40 04             	mov    0x4(%eax),%eax
  802db7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802dbc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dbf:	8b 40 04             	mov    0x4(%eax),%eax
  802dc2:	85 c0                	test   %eax,%eax
  802dc4:	74 0f                	je     802dd5 <alloc_block_NF+0x34a>
  802dc6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dc9:	8b 40 04             	mov    0x4(%eax),%eax
  802dcc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802dcf:	8b 12                	mov    (%edx),%edx
  802dd1:	89 10                	mov    %edx,(%eax)
  802dd3:	eb 0a                	jmp    802ddf <alloc_block_NF+0x354>
  802dd5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dd8:	8b 00                	mov    (%eax),%eax
  802dda:	a3 48 51 80 00       	mov    %eax,0x805148
  802ddf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802de2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802de8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802deb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802df2:	a1 54 51 80 00       	mov    0x805154,%eax
  802df7:	48                   	dec    %eax
  802df8:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802dfd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e00:	8b 40 08             	mov    0x8(%eax),%eax
  802e03:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802e08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0b:	8b 50 08             	mov    0x8(%eax),%edx
  802e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e11:	01 c2                	add    %eax,%edx
  802e13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e16:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802e19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1c:	8b 40 0c             	mov    0xc(%eax),%eax
  802e1f:	2b 45 08             	sub    0x8(%ebp),%eax
  802e22:	89 c2                	mov    %eax,%edx
  802e24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e27:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802e2a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e2d:	e9 24 02 00 00       	jmp    803056 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802e32:	a1 40 51 80 00       	mov    0x805140,%eax
  802e37:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e3a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e3e:	74 07                	je     802e47 <alloc_block_NF+0x3bc>
  802e40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e43:	8b 00                	mov    (%eax),%eax
  802e45:	eb 05                	jmp    802e4c <alloc_block_NF+0x3c1>
  802e47:	b8 00 00 00 00       	mov    $0x0,%eax
  802e4c:	a3 40 51 80 00       	mov    %eax,0x805140
  802e51:	a1 40 51 80 00       	mov    0x805140,%eax
  802e56:	85 c0                	test   %eax,%eax
  802e58:	0f 85 2b fe ff ff    	jne    802c89 <alloc_block_NF+0x1fe>
  802e5e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e62:	0f 85 21 fe ff ff    	jne    802c89 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802e68:	a1 38 51 80 00       	mov    0x805138,%eax
  802e6d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e70:	e9 ae 01 00 00       	jmp    803023 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802e75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e78:	8b 50 08             	mov    0x8(%eax),%edx
  802e7b:	a1 28 50 80 00       	mov    0x805028,%eax
  802e80:	39 c2                	cmp    %eax,%edx
  802e82:	0f 83 93 01 00 00    	jae    80301b <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802e88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8b:	8b 40 0c             	mov    0xc(%eax),%eax
  802e8e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e91:	0f 82 84 01 00 00    	jb     80301b <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802e97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9a:	8b 40 0c             	mov    0xc(%eax),%eax
  802e9d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ea0:	0f 85 95 00 00 00    	jne    802f3b <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802ea6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802eaa:	75 17                	jne    802ec3 <alloc_block_NF+0x438>
  802eac:	83 ec 04             	sub    $0x4,%esp
  802eaf:	68 70 44 80 00       	push   $0x804470
  802eb4:	68 14 01 00 00       	push   $0x114
  802eb9:	68 c7 43 80 00       	push   $0x8043c7
  802ebe:	e8 5b d8 ff ff       	call   80071e <_panic>
  802ec3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec6:	8b 00                	mov    (%eax),%eax
  802ec8:	85 c0                	test   %eax,%eax
  802eca:	74 10                	je     802edc <alloc_block_NF+0x451>
  802ecc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ecf:	8b 00                	mov    (%eax),%eax
  802ed1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ed4:	8b 52 04             	mov    0x4(%edx),%edx
  802ed7:	89 50 04             	mov    %edx,0x4(%eax)
  802eda:	eb 0b                	jmp    802ee7 <alloc_block_NF+0x45c>
  802edc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802edf:	8b 40 04             	mov    0x4(%eax),%eax
  802ee2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ee7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eea:	8b 40 04             	mov    0x4(%eax),%eax
  802eed:	85 c0                	test   %eax,%eax
  802eef:	74 0f                	je     802f00 <alloc_block_NF+0x475>
  802ef1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef4:	8b 40 04             	mov    0x4(%eax),%eax
  802ef7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802efa:	8b 12                	mov    (%edx),%edx
  802efc:	89 10                	mov    %edx,(%eax)
  802efe:	eb 0a                	jmp    802f0a <alloc_block_NF+0x47f>
  802f00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f03:	8b 00                	mov    (%eax),%eax
  802f05:	a3 38 51 80 00       	mov    %eax,0x805138
  802f0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f16:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f1d:	a1 44 51 80 00       	mov    0x805144,%eax
  802f22:	48                   	dec    %eax
  802f23:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802f28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2b:	8b 40 08             	mov    0x8(%eax),%eax
  802f2e:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802f33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f36:	e9 1b 01 00 00       	jmp    803056 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802f3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3e:	8b 40 0c             	mov    0xc(%eax),%eax
  802f41:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f44:	0f 86 d1 00 00 00    	jbe    80301b <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802f4a:	a1 48 51 80 00       	mov    0x805148,%eax
  802f4f:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802f52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f55:	8b 50 08             	mov    0x8(%eax),%edx
  802f58:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f5b:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802f5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f61:	8b 55 08             	mov    0x8(%ebp),%edx
  802f64:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802f67:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802f6b:	75 17                	jne    802f84 <alloc_block_NF+0x4f9>
  802f6d:	83 ec 04             	sub    $0x4,%esp
  802f70:	68 70 44 80 00       	push   $0x804470
  802f75:	68 1c 01 00 00       	push   $0x11c
  802f7a:	68 c7 43 80 00       	push   $0x8043c7
  802f7f:	e8 9a d7 ff ff       	call   80071e <_panic>
  802f84:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f87:	8b 00                	mov    (%eax),%eax
  802f89:	85 c0                	test   %eax,%eax
  802f8b:	74 10                	je     802f9d <alloc_block_NF+0x512>
  802f8d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f90:	8b 00                	mov    (%eax),%eax
  802f92:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f95:	8b 52 04             	mov    0x4(%edx),%edx
  802f98:	89 50 04             	mov    %edx,0x4(%eax)
  802f9b:	eb 0b                	jmp    802fa8 <alloc_block_NF+0x51d>
  802f9d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fa0:	8b 40 04             	mov    0x4(%eax),%eax
  802fa3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802fa8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fab:	8b 40 04             	mov    0x4(%eax),%eax
  802fae:	85 c0                	test   %eax,%eax
  802fb0:	74 0f                	je     802fc1 <alloc_block_NF+0x536>
  802fb2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fb5:	8b 40 04             	mov    0x4(%eax),%eax
  802fb8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802fbb:	8b 12                	mov    (%edx),%edx
  802fbd:	89 10                	mov    %edx,(%eax)
  802fbf:	eb 0a                	jmp    802fcb <alloc_block_NF+0x540>
  802fc1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fc4:	8b 00                	mov    (%eax),%eax
  802fc6:	a3 48 51 80 00       	mov    %eax,0x805148
  802fcb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fd4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fd7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fde:	a1 54 51 80 00       	mov    0x805154,%eax
  802fe3:	48                   	dec    %eax
  802fe4:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802fe9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fec:	8b 40 08             	mov    0x8(%eax),%eax
  802fef:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802ff4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff7:	8b 50 08             	mov    0x8(%eax),%edx
  802ffa:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffd:	01 c2                	add    %eax,%edx
  802fff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803002:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803005:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803008:	8b 40 0c             	mov    0xc(%eax),%eax
  80300b:	2b 45 08             	sub    0x8(%ebp),%eax
  80300e:	89 c2                	mov    %eax,%edx
  803010:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803013:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803016:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803019:	eb 3b                	jmp    803056 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  80301b:	a1 40 51 80 00       	mov    0x805140,%eax
  803020:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803023:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803027:	74 07                	je     803030 <alloc_block_NF+0x5a5>
  803029:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80302c:	8b 00                	mov    (%eax),%eax
  80302e:	eb 05                	jmp    803035 <alloc_block_NF+0x5aa>
  803030:	b8 00 00 00 00       	mov    $0x0,%eax
  803035:	a3 40 51 80 00       	mov    %eax,0x805140
  80303a:	a1 40 51 80 00       	mov    0x805140,%eax
  80303f:	85 c0                	test   %eax,%eax
  803041:	0f 85 2e fe ff ff    	jne    802e75 <alloc_block_NF+0x3ea>
  803047:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80304b:	0f 85 24 fe ff ff    	jne    802e75 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  803051:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803056:	c9                   	leave  
  803057:	c3                   	ret    

00803058 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803058:	55                   	push   %ebp
  803059:	89 e5                	mov    %esp,%ebp
  80305b:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  80305e:	a1 38 51 80 00       	mov    0x805138,%eax
  803063:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  803066:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80306b:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  80306e:	a1 38 51 80 00       	mov    0x805138,%eax
  803073:	85 c0                	test   %eax,%eax
  803075:	74 14                	je     80308b <insert_sorted_with_merge_freeList+0x33>
  803077:	8b 45 08             	mov    0x8(%ebp),%eax
  80307a:	8b 50 08             	mov    0x8(%eax),%edx
  80307d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803080:	8b 40 08             	mov    0x8(%eax),%eax
  803083:	39 c2                	cmp    %eax,%edx
  803085:	0f 87 9b 01 00 00    	ja     803226 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  80308b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80308f:	75 17                	jne    8030a8 <insert_sorted_with_merge_freeList+0x50>
  803091:	83 ec 04             	sub    $0x4,%esp
  803094:	68 a4 43 80 00       	push   $0x8043a4
  803099:	68 38 01 00 00       	push   $0x138
  80309e:	68 c7 43 80 00       	push   $0x8043c7
  8030a3:	e8 76 d6 ff ff       	call   80071e <_panic>
  8030a8:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8030ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b1:	89 10                	mov    %edx,(%eax)
  8030b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b6:	8b 00                	mov    (%eax),%eax
  8030b8:	85 c0                	test   %eax,%eax
  8030ba:	74 0d                	je     8030c9 <insert_sorted_with_merge_freeList+0x71>
  8030bc:	a1 38 51 80 00       	mov    0x805138,%eax
  8030c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8030c4:	89 50 04             	mov    %edx,0x4(%eax)
  8030c7:	eb 08                	jmp    8030d1 <insert_sorted_with_merge_freeList+0x79>
  8030c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030cc:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d4:	a3 38 51 80 00       	mov    %eax,0x805138
  8030d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030dc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030e3:	a1 44 51 80 00       	mov    0x805144,%eax
  8030e8:	40                   	inc    %eax
  8030e9:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8030ee:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8030f2:	0f 84 a8 06 00 00    	je     8037a0 <insert_sorted_with_merge_freeList+0x748>
  8030f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030fb:	8b 50 08             	mov    0x8(%eax),%edx
  8030fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803101:	8b 40 0c             	mov    0xc(%eax),%eax
  803104:	01 c2                	add    %eax,%edx
  803106:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803109:	8b 40 08             	mov    0x8(%eax),%eax
  80310c:	39 c2                	cmp    %eax,%edx
  80310e:	0f 85 8c 06 00 00    	jne    8037a0 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  803114:	8b 45 08             	mov    0x8(%ebp),%eax
  803117:	8b 50 0c             	mov    0xc(%eax),%edx
  80311a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80311d:	8b 40 0c             	mov    0xc(%eax),%eax
  803120:	01 c2                	add    %eax,%edx
  803122:	8b 45 08             	mov    0x8(%ebp),%eax
  803125:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  803128:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80312c:	75 17                	jne    803145 <insert_sorted_with_merge_freeList+0xed>
  80312e:	83 ec 04             	sub    $0x4,%esp
  803131:	68 70 44 80 00       	push   $0x804470
  803136:	68 3c 01 00 00       	push   $0x13c
  80313b:	68 c7 43 80 00       	push   $0x8043c7
  803140:	e8 d9 d5 ff ff       	call   80071e <_panic>
  803145:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803148:	8b 00                	mov    (%eax),%eax
  80314a:	85 c0                	test   %eax,%eax
  80314c:	74 10                	je     80315e <insert_sorted_with_merge_freeList+0x106>
  80314e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803151:	8b 00                	mov    (%eax),%eax
  803153:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803156:	8b 52 04             	mov    0x4(%edx),%edx
  803159:	89 50 04             	mov    %edx,0x4(%eax)
  80315c:	eb 0b                	jmp    803169 <insert_sorted_with_merge_freeList+0x111>
  80315e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803161:	8b 40 04             	mov    0x4(%eax),%eax
  803164:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803169:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80316c:	8b 40 04             	mov    0x4(%eax),%eax
  80316f:	85 c0                	test   %eax,%eax
  803171:	74 0f                	je     803182 <insert_sorted_with_merge_freeList+0x12a>
  803173:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803176:	8b 40 04             	mov    0x4(%eax),%eax
  803179:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80317c:	8b 12                	mov    (%edx),%edx
  80317e:	89 10                	mov    %edx,(%eax)
  803180:	eb 0a                	jmp    80318c <insert_sorted_with_merge_freeList+0x134>
  803182:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803185:	8b 00                	mov    (%eax),%eax
  803187:	a3 38 51 80 00       	mov    %eax,0x805138
  80318c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80318f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803195:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803198:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80319f:	a1 44 51 80 00       	mov    0x805144,%eax
  8031a4:	48                   	dec    %eax
  8031a5:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  8031aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031ad:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  8031b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031b7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  8031be:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8031c2:	75 17                	jne    8031db <insert_sorted_with_merge_freeList+0x183>
  8031c4:	83 ec 04             	sub    $0x4,%esp
  8031c7:	68 a4 43 80 00       	push   $0x8043a4
  8031cc:	68 3f 01 00 00       	push   $0x13f
  8031d1:	68 c7 43 80 00       	push   $0x8043c7
  8031d6:	e8 43 d5 ff ff       	call   80071e <_panic>
  8031db:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8031e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031e4:	89 10                	mov    %edx,(%eax)
  8031e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031e9:	8b 00                	mov    (%eax),%eax
  8031eb:	85 c0                	test   %eax,%eax
  8031ed:	74 0d                	je     8031fc <insert_sorted_with_merge_freeList+0x1a4>
  8031ef:	a1 48 51 80 00       	mov    0x805148,%eax
  8031f4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031f7:	89 50 04             	mov    %edx,0x4(%eax)
  8031fa:	eb 08                	jmp    803204 <insert_sorted_with_merge_freeList+0x1ac>
  8031fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031ff:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803204:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803207:	a3 48 51 80 00       	mov    %eax,0x805148
  80320c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80320f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803216:	a1 54 51 80 00       	mov    0x805154,%eax
  80321b:	40                   	inc    %eax
  80321c:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803221:	e9 7a 05 00 00       	jmp    8037a0 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  803226:	8b 45 08             	mov    0x8(%ebp),%eax
  803229:	8b 50 08             	mov    0x8(%eax),%edx
  80322c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80322f:	8b 40 08             	mov    0x8(%eax),%eax
  803232:	39 c2                	cmp    %eax,%edx
  803234:	0f 82 14 01 00 00    	jb     80334e <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  80323a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80323d:	8b 50 08             	mov    0x8(%eax),%edx
  803240:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803243:	8b 40 0c             	mov    0xc(%eax),%eax
  803246:	01 c2                	add    %eax,%edx
  803248:	8b 45 08             	mov    0x8(%ebp),%eax
  80324b:	8b 40 08             	mov    0x8(%eax),%eax
  80324e:	39 c2                	cmp    %eax,%edx
  803250:	0f 85 90 00 00 00    	jne    8032e6 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  803256:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803259:	8b 50 0c             	mov    0xc(%eax),%edx
  80325c:	8b 45 08             	mov    0x8(%ebp),%eax
  80325f:	8b 40 0c             	mov    0xc(%eax),%eax
  803262:	01 c2                	add    %eax,%edx
  803264:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803267:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  80326a:	8b 45 08             	mov    0x8(%ebp),%eax
  80326d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  803274:	8b 45 08             	mov    0x8(%ebp),%eax
  803277:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80327e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803282:	75 17                	jne    80329b <insert_sorted_with_merge_freeList+0x243>
  803284:	83 ec 04             	sub    $0x4,%esp
  803287:	68 a4 43 80 00       	push   $0x8043a4
  80328c:	68 49 01 00 00       	push   $0x149
  803291:	68 c7 43 80 00       	push   $0x8043c7
  803296:	e8 83 d4 ff ff       	call   80071e <_panic>
  80329b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8032a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a4:	89 10                	mov    %edx,(%eax)
  8032a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a9:	8b 00                	mov    (%eax),%eax
  8032ab:	85 c0                	test   %eax,%eax
  8032ad:	74 0d                	je     8032bc <insert_sorted_with_merge_freeList+0x264>
  8032af:	a1 48 51 80 00       	mov    0x805148,%eax
  8032b4:	8b 55 08             	mov    0x8(%ebp),%edx
  8032b7:	89 50 04             	mov    %edx,0x4(%eax)
  8032ba:	eb 08                	jmp    8032c4 <insert_sorted_with_merge_freeList+0x26c>
  8032bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8032bf:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c7:	a3 48 51 80 00       	mov    %eax,0x805148
  8032cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8032cf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032d6:	a1 54 51 80 00       	mov    0x805154,%eax
  8032db:	40                   	inc    %eax
  8032dc:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8032e1:	e9 bb 04 00 00       	jmp    8037a1 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  8032e6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032ea:	75 17                	jne    803303 <insert_sorted_with_merge_freeList+0x2ab>
  8032ec:	83 ec 04             	sub    $0x4,%esp
  8032ef:	68 18 44 80 00       	push   $0x804418
  8032f4:	68 4c 01 00 00       	push   $0x14c
  8032f9:	68 c7 43 80 00       	push   $0x8043c7
  8032fe:	e8 1b d4 ff ff       	call   80071e <_panic>
  803303:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803309:	8b 45 08             	mov    0x8(%ebp),%eax
  80330c:	89 50 04             	mov    %edx,0x4(%eax)
  80330f:	8b 45 08             	mov    0x8(%ebp),%eax
  803312:	8b 40 04             	mov    0x4(%eax),%eax
  803315:	85 c0                	test   %eax,%eax
  803317:	74 0c                	je     803325 <insert_sorted_with_merge_freeList+0x2cd>
  803319:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80331e:	8b 55 08             	mov    0x8(%ebp),%edx
  803321:	89 10                	mov    %edx,(%eax)
  803323:	eb 08                	jmp    80332d <insert_sorted_with_merge_freeList+0x2d5>
  803325:	8b 45 08             	mov    0x8(%ebp),%eax
  803328:	a3 38 51 80 00       	mov    %eax,0x805138
  80332d:	8b 45 08             	mov    0x8(%ebp),%eax
  803330:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803335:	8b 45 08             	mov    0x8(%ebp),%eax
  803338:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80333e:	a1 44 51 80 00       	mov    0x805144,%eax
  803343:	40                   	inc    %eax
  803344:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803349:	e9 53 04 00 00       	jmp    8037a1 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80334e:	a1 38 51 80 00       	mov    0x805138,%eax
  803353:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803356:	e9 15 04 00 00       	jmp    803770 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  80335b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80335e:	8b 00                	mov    (%eax),%eax
  803360:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803363:	8b 45 08             	mov    0x8(%ebp),%eax
  803366:	8b 50 08             	mov    0x8(%eax),%edx
  803369:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80336c:	8b 40 08             	mov    0x8(%eax),%eax
  80336f:	39 c2                	cmp    %eax,%edx
  803371:	0f 86 f1 03 00 00    	jbe    803768 <insert_sorted_with_merge_freeList+0x710>
  803377:	8b 45 08             	mov    0x8(%ebp),%eax
  80337a:	8b 50 08             	mov    0x8(%eax),%edx
  80337d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803380:	8b 40 08             	mov    0x8(%eax),%eax
  803383:	39 c2                	cmp    %eax,%edx
  803385:	0f 83 dd 03 00 00    	jae    803768 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  80338b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80338e:	8b 50 08             	mov    0x8(%eax),%edx
  803391:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803394:	8b 40 0c             	mov    0xc(%eax),%eax
  803397:	01 c2                	add    %eax,%edx
  803399:	8b 45 08             	mov    0x8(%ebp),%eax
  80339c:	8b 40 08             	mov    0x8(%eax),%eax
  80339f:	39 c2                	cmp    %eax,%edx
  8033a1:	0f 85 b9 01 00 00    	jne    803560 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8033a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8033aa:	8b 50 08             	mov    0x8(%eax),%edx
  8033ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b0:	8b 40 0c             	mov    0xc(%eax),%eax
  8033b3:	01 c2                	add    %eax,%edx
  8033b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033b8:	8b 40 08             	mov    0x8(%eax),%eax
  8033bb:	39 c2                	cmp    %eax,%edx
  8033bd:	0f 85 0d 01 00 00    	jne    8034d0 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  8033c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c6:	8b 50 0c             	mov    0xc(%eax),%edx
  8033c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033cc:	8b 40 0c             	mov    0xc(%eax),%eax
  8033cf:	01 c2                	add    %eax,%edx
  8033d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033d4:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8033d7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8033db:	75 17                	jne    8033f4 <insert_sorted_with_merge_freeList+0x39c>
  8033dd:	83 ec 04             	sub    $0x4,%esp
  8033e0:	68 70 44 80 00       	push   $0x804470
  8033e5:	68 5c 01 00 00       	push   $0x15c
  8033ea:	68 c7 43 80 00       	push   $0x8043c7
  8033ef:	e8 2a d3 ff ff       	call   80071e <_panic>
  8033f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033f7:	8b 00                	mov    (%eax),%eax
  8033f9:	85 c0                	test   %eax,%eax
  8033fb:	74 10                	je     80340d <insert_sorted_with_merge_freeList+0x3b5>
  8033fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803400:	8b 00                	mov    (%eax),%eax
  803402:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803405:	8b 52 04             	mov    0x4(%edx),%edx
  803408:	89 50 04             	mov    %edx,0x4(%eax)
  80340b:	eb 0b                	jmp    803418 <insert_sorted_with_merge_freeList+0x3c0>
  80340d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803410:	8b 40 04             	mov    0x4(%eax),%eax
  803413:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803418:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80341b:	8b 40 04             	mov    0x4(%eax),%eax
  80341e:	85 c0                	test   %eax,%eax
  803420:	74 0f                	je     803431 <insert_sorted_with_merge_freeList+0x3d9>
  803422:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803425:	8b 40 04             	mov    0x4(%eax),%eax
  803428:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80342b:	8b 12                	mov    (%edx),%edx
  80342d:	89 10                	mov    %edx,(%eax)
  80342f:	eb 0a                	jmp    80343b <insert_sorted_with_merge_freeList+0x3e3>
  803431:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803434:	8b 00                	mov    (%eax),%eax
  803436:	a3 38 51 80 00       	mov    %eax,0x805138
  80343b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80343e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803444:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803447:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80344e:	a1 44 51 80 00       	mov    0x805144,%eax
  803453:	48                   	dec    %eax
  803454:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803459:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80345c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803463:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803466:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80346d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803471:	75 17                	jne    80348a <insert_sorted_with_merge_freeList+0x432>
  803473:	83 ec 04             	sub    $0x4,%esp
  803476:	68 a4 43 80 00       	push   $0x8043a4
  80347b:	68 5f 01 00 00       	push   $0x15f
  803480:	68 c7 43 80 00       	push   $0x8043c7
  803485:	e8 94 d2 ff ff       	call   80071e <_panic>
  80348a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803490:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803493:	89 10                	mov    %edx,(%eax)
  803495:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803498:	8b 00                	mov    (%eax),%eax
  80349a:	85 c0                	test   %eax,%eax
  80349c:	74 0d                	je     8034ab <insert_sorted_with_merge_freeList+0x453>
  80349e:	a1 48 51 80 00       	mov    0x805148,%eax
  8034a3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8034a6:	89 50 04             	mov    %edx,0x4(%eax)
  8034a9:	eb 08                	jmp    8034b3 <insert_sorted_with_merge_freeList+0x45b>
  8034ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034ae:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8034b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034b6:	a3 48 51 80 00       	mov    %eax,0x805148
  8034bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034be:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034c5:	a1 54 51 80 00       	mov    0x805154,%eax
  8034ca:	40                   	inc    %eax
  8034cb:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  8034d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034d3:	8b 50 0c             	mov    0xc(%eax),%edx
  8034d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d9:	8b 40 0c             	mov    0xc(%eax),%eax
  8034dc:	01 c2                	add    %eax,%edx
  8034de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034e1:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8034e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8034ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8034f8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034fc:	75 17                	jne    803515 <insert_sorted_with_merge_freeList+0x4bd>
  8034fe:	83 ec 04             	sub    $0x4,%esp
  803501:	68 a4 43 80 00       	push   $0x8043a4
  803506:	68 64 01 00 00       	push   $0x164
  80350b:	68 c7 43 80 00       	push   $0x8043c7
  803510:	e8 09 d2 ff ff       	call   80071e <_panic>
  803515:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80351b:	8b 45 08             	mov    0x8(%ebp),%eax
  80351e:	89 10                	mov    %edx,(%eax)
  803520:	8b 45 08             	mov    0x8(%ebp),%eax
  803523:	8b 00                	mov    (%eax),%eax
  803525:	85 c0                	test   %eax,%eax
  803527:	74 0d                	je     803536 <insert_sorted_with_merge_freeList+0x4de>
  803529:	a1 48 51 80 00       	mov    0x805148,%eax
  80352e:	8b 55 08             	mov    0x8(%ebp),%edx
  803531:	89 50 04             	mov    %edx,0x4(%eax)
  803534:	eb 08                	jmp    80353e <insert_sorted_with_merge_freeList+0x4e6>
  803536:	8b 45 08             	mov    0x8(%ebp),%eax
  803539:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80353e:	8b 45 08             	mov    0x8(%ebp),%eax
  803541:	a3 48 51 80 00       	mov    %eax,0x805148
  803546:	8b 45 08             	mov    0x8(%ebp),%eax
  803549:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803550:	a1 54 51 80 00       	mov    0x805154,%eax
  803555:	40                   	inc    %eax
  803556:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80355b:	e9 41 02 00 00       	jmp    8037a1 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803560:	8b 45 08             	mov    0x8(%ebp),%eax
  803563:	8b 50 08             	mov    0x8(%eax),%edx
  803566:	8b 45 08             	mov    0x8(%ebp),%eax
  803569:	8b 40 0c             	mov    0xc(%eax),%eax
  80356c:	01 c2                	add    %eax,%edx
  80356e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803571:	8b 40 08             	mov    0x8(%eax),%eax
  803574:	39 c2                	cmp    %eax,%edx
  803576:	0f 85 7c 01 00 00    	jne    8036f8 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  80357c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803580:	74 06                	je     803588 <insert_sorted_with_merge_freeList+0x530>
  803582:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803586:	75 17                	jne    80359f <insert_sorted_with_merge_freeList+0x547>
  803588:	83 ec 04             	sub    $0x4,%esp
  80358b:	68 e0 43 80 00       	push   $0x8043e0
  803590:	68 69 01 00 00       	push   $0x169
  803595:	68 c7 43 80 00       	push   $0x8043c7
  80359a:	e8 7f d1 ff ff       	call   80071e <_panic>
  80359f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035a2:	8b 50 04             	mov    0x4(%eax),%edx
  8035a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a8:	89 50 04             	mov    %edx,0x4(%eax)
  8035ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ae:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8035b1:	89 10                	mov    %edx,(%eax)
  8035b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035b6:	8b 40 04             	mov    0x4(%eax),%eax
  8035b9:	85 c0                	test   %eax,%eax
  8035bb:	74 0d                	je     8035ca <insert_sorted_with_merge_freeList+0x572>
  8035bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035c0:	8b 40 04             	mov    0x4(%eax),%eax
  8035c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8035c6:	89 10                	mov    %edx,(%eax)
  8035c8:	eb 08                	jmp    8035d2 <insert_sorted_with_merge_freeList+0x57a>
  8035ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8035cd:	a3 38 51 80 00       	mov    %eax,0x805138
  8035d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035d5:	8b 55 08             	mov    0x8(%ebp),%edx
  8035d8:	89 50 04             	mov    %edx,0x4(%eax)
  8035db:	a1 44 51 80 00       	mov    0x805144,%eax
  8035e0:	40                   	inc    %eax
  8035e1:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  8035e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e9:	8b 50 0c             	mov    0xc(%eax),%edx
  8035ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035ef:	8b 40 0c             	mov    0xc(%eax),%eax
  8035f2:	01 c2                	add    %eax,%edx
  8035f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f7:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8035fa:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8035fe:	75 17                	jne    803617 <insert_sorted_with_merge_freeList+0x5bf>
  803600:	83 ec 04             	sub    $0x4,%esp
  803603:	68 70 44 80 00       	push   $0x804470
  803608:	68 6b 01 00 00       	push   $0x16b
  80360d:	68 c7 43 80 00       	push   $0x8043c7
  803612:	e8 07 d1 ff ff       	call   80071e <_panic>
  803617:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80361a:	8b 00                	mov    (%eax),%eax
  80361c:	85 c0                	test   %eax,%eax
  80361e:	74 10                	je     803630 <insert_sorted_with_merge_freeList+0x5d8>
  803620:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803623:	8b 00                	mov    (%eax),%eax
  803625:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803628:	8b 52 04             	mov    0x4(%edx),%edx
  80362b:	89 50 04             	mov    %edx,0x4(%eax)
  80362e:	eb 0b                	jmp    80363b <insert_sorted_with_merge_freeList+0x5e3>
  803630:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803633:	8b 40 04             	mov    0x4(%eax),%eax
  803636:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80363b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80363e:	8b 40 04             	mov    0x4(%eax),%eax
  803641:	85 c0                	test   %eax,%eax
  803643:	74 0f                	je     803654 <insert_sorted_with_merge_freeList+0x5fc>
  803645:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803648:	8b 40 04             	mov    0x4(%eax),%eax
  80364b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80364e:	8b 12                	mov    (%edx),%edx
  803650:	89 10                	mov    %edx,(%eax)
  803652:	eb 0a                	jmp    80365e <insert_sorted_with_merge_freeList+0x606>
  803654:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803657:	8b 00                	mov    (%eax),%eax
  803659:	a3 38 51 80 00       	mov    %eax,0x805138
  80365e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803661:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803667:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80366a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803671:	a1 44 51 80 00       	mov    0x805144,%eax
  803676:	48                   	dec    %eax
  803677:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  80367c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80367f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803686:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803689:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803690:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803694:	75 17                	jne    8036ad <insert_sorted_with_merge_freeList+0x655>
  803696:	83 ec 04             	sub    $0x4,%esp
  803699:	68 a4 43 80 00       	push   $0x8043a4
  80369e:	68 6e 01 00 00       	push   $0x16e
  8036a3:	68 c7 43 80 00       	push   $0x8043c7
  8036a8:	e8 71 d0 ff ff       	call   80071e <_panic>
  8036ad:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8036b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036b6:	89 10                	mov    %edx,(%eax)
  8036b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036bb:	8b 00                	mov    (%eax),%eax
  8036bd:	85 c0                	test   %eax,%eax
  8036bf:	74 0d                	je     8036ce <insert_sorted_with_merge_freeList+0x676>
  8036c1:	a1 48 51 80 00       	mov    0x805148,%eax
  8036c6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8036c9:	89 50 04             	mov    %edx,0x4(%eax)
  8036cc:	eb 08                	jmp    8036d6 <insert_sorted_with_merge_freeList+0x67e>
  8036ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036d1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8036d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036d9:	a3 48 51 80 00       	mov    %eax,0x805148
  8036de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036e1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036e8:	a1 54 51 80 00       	mov    0x805154,%eax
  8036ed:	40                   	inc    %eax
  8036ee:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8036f3:	e9 a9 00 00 00       	jmp    8037a1 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8036f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036fc:	74 06                	je     803704 <insert_sorted_with_merge_freeList+0x6ac>
  8036fe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803702:	75 17                	jne    80371b <insert_sorted_with_merge_freeList+0x6c3>
  803704:	83 ec 04             	sub    $0x4,%esp
  803707:	68 3c 44 80 00       	push   $0x80443c
  80370c:	68 73 01 00 00       	push   $0x173
  803711:	68 c7 43 80 00       	push   $0x8043c7
  803716:	e8 03 d0 ff ff       	call   80071e <_panic>
  80371b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80371e:	8b 10                	mov    (%eax),%edx
  803720:	8b 45 08             	mov    0x8(%ebp),%eax
  803723:	89 10                	mov    %edx,(%eax)
  803725:	8b 45 08             	mov    0x8(%ebp),%eax
  803728:	8b 00                	mov    (%eax),%eax
  80372a:	85 c0                	test   %eax,%eax
  80372c:	74 0b                	je     803739 <insert_sorted_with_merge_freeList+0x6e1>
  80372e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803731:	8b 00                	mov    (%eax),%eax
  803733:	8b 55 08             	mov    0x8(%ebp),%edx
  803736:	89 50 04             	mov    %edx,0x4(%eax)
  803739:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80373c:	8b 55 08             	mov    0x8(%ebp),%edx
  80373f:	89 10                	mov    %edx,(%eax)
  803741:	8b 45 08             	mov    0x8(%ebp),%eax
  803744:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803747:	89 50 04             	mov    %edx,0x4(%eax)
  80374a:	8b 45 08             	mov    0x8(%ebp),%eax
  80374d:	8b 00                	mov    (%eax),%eax
  80374f:	85 c0                	test   %eax,%eax
  803751:	75 08                	jne    80375b <insert_sorted_with_merge_freeList+0x703>
  803753:	8b 45 08             	mov    0x8(%ebp),%eax
  803756:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80375b:	a1 44 51 80 00       	mov    0x805144,%eax
  803760:	40                   	inc    %eax
  803761:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803766:	eb 39                	jmp    8037a1 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803768:	a1 40 51 80 00       	mov    0x805140,%eax
  80376d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803770:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803774:	74 07                	je     80377d <insert_sorted_with_merge_freeList+0x725>
  803776:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803779:	8b 00                	mov    (%eax),%eax
  80377b:	eb 05                	jmp    803782 <insert_sorted_with_merge_freeList+0x72a>
  80377d:	b8 00 00 00 00       	mov    $0x0,%eax
  803782:	a3 40 51 80 00       	mov    %eax,0x805140
  803787:	a1 40 51 80 00       	mov    0x805140,%eax
  80378c:	85 c0                	test   %eax,%eax
  80378e:	0f 85 c7 fb ff ff    	jne    80335b <insert_sorted_with_merge_freeList+0x303>
  803794:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803798:	0f 85 bd fb ff ff    	jne    80335b <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80379e:	eb 01                	jmp    8037a1 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8037a0:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8037a1:	90                   	nop
  8037a2:	c9                   	leave  
  8037a3:	c3                   	ret    

008037a4 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8037a4:	55                   	push   %ebp
  8037a5:	89 e5                	mov    %esp,%ebp
  8037a7:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8037aa:	8b 55 08             	mov    0x8(%ebp),%edx
  8037ad:	89 d0                	mov    %edx,%eax
  8037af:	c1 e0 02             	shl    $0x2,%eax
  8037b2:	01 d0                	add    %edx,%eax
  8037b4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8037bb:	01 d0                	add    %edx,%eax
  8037bd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8037c4:	01 d0                	add    %edx,%eax
  8037c6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8037cd:	01 d0                	add    %edx,%eax
  8037cf:	c1 e0 04             	shl    $0x4,%eax
  8037d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8037d5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8037dc:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8037df:	83 ec 0c             	sub    $0xc,%esp
  8037e2:	50                   	push   %eax
  8037e3:	e8 26 e7 ff ff       	call   801f0e <sys_get_virtual_time>
  8037e8:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8037eb:	eb 41                	jmp    80382e <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8037ed:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8037f0:	83 ec 0c             	sub    $0xc,%esp
  8037f3:	50                   	push   %eax
  8037f4:	e8 15 e7 ff ff       	call   801f0e <sys_get_virtual_time>
  8037f9:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8037fc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8037ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803802:	29 c2                	sub    %eax,%edx
  803804:	89 d0                	mov    %edx,%eax
  803806:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803809:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80380c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80380f:	89 d1                	mov    %edx,%ecx
  803811:	29 c1                	sub    %eax,%ecx
  803813:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803816:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803819:	39 c2                	cmp    %eax,%edx
  80381b:	0f 97 c0             	seta   %al
  80381e:	0f b6 c0             	movzbl %al,%eax
  803821:	29 c1                	sub    %eax,%ecx
  803823:	89 c8                	mov    %ecx,%eax
  803825:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803828:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80382b:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  80382e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803831:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803834:	72 b7                	jb     8037ed <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803836:	90                   	nop
  803837:	c9                   	leave  
  803838:	c3                   	ret    

00803839 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803839:	55                   	push   %ebp
  80383a:	89 e5                	mov    %esp,%ebp
  80383c:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  80383f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803846:	eb 03                	jmp    80384b <busy_wait+0x12>
  803848:	ff 45 fc             	incl   -0x4(%ebp)
  80384b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80384e:	3b 45 08             	cmp    0x8(%ebp),%eax
  803851:	72 f5                	jb     803848 <busy_wait+0xf>
	return i;
  803853:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803856:	c9                   	leave  
  803857:	c3                   	ret    

00803858 <__udivdi3>:
  803858:	55                   	push   %ebp
  803859:	57                   	push   %edi
  80385a:	56                   	push   %esi
  80385b:	53                   	push   %ebx
  80385c:	83 ec 1c             	sub    $0x1c,%esp
  80385f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803863:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803867:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80386b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80386f:	89 ca                	mov    %ecx,%edx
  803871:	89 f8                	mov    %edi,%eax
  803873:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803877:	85 f6                	test   %esi,%esi
  803879:	75 2d                	jne    8038a8 <__udivdi3+0x50>
  80387b:	39 cf                	cmp    %ecx,%edi
  80387d:	77 65                	ja     8038e4 <__udivdi3+0x8c>
  80387f:	89 fd                	mov    %edi,%ebp
  803881:	85 ff                	test   %edi,%edi
  803883:	75 0b                	jne    803890 <__udivdi3+0x38>
  803885:	b8 01 00 00 00       	mov    $0x1,%eax
  80388a:	31 d2                	xor    %edx,%edx
  80388c:	f7 f7                	div    %edi
  80388e:	89 c5                	mov    %eax,%ebp
  803890:	31 d2                	xor    %edx,%edx
  803892:	89 c8                	mov    %ecx,%eax
  803894:	f7 f5                	div    %ebp
  803896:	89 c1                	mov    %eax,%ecx
  803898:	89 d8                	mov    %ebx,%eax
  80389a:	f7 f5                	div    %ebp
  80389c:	89 cf                	mov    %ecx,%edi
  80389e:	89 fa                	mov    %edi,%edx
  8038a0:	83 c4 1c             	add    $0x1c,%esp
  8038a3:	5b                   	pop    %ebx
  8038a4:	5e                   	pop    %esi
  8038a5:	5f                   	pop    %edi
  8038a6:	5d                   	pop    %ebp
  8038a7:	c3                   	ret    
  8038a8:	39 ce                	cmp    %ecx,%esi
  8038aa:	77 28                	ja     8038d4 <__udivdi3+0x7c>
  8038ac:	0f bd fe             	bsr    %esi,%edi
  8038af:	83 f7 1f             	xor    $0x1f,%edi
  8038b2:	75 40                	jne    8038f4 <__udivdi3+0x9c>
  8038b4:	39 ce                	cmp    %ecx,%esi
  8038b6:	72 0a                	jb     8038c2 <__udivdi3+0x6a>
  8038b8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8038bc:	0f 87 9e 00 00 00    	ja     803960 <__udivdi3+0x108>
  8038c2:	b8 01 00 00 00       	mov    $0x1,%eax
  8038c7:	89 fa                	mov    %edi,%edx
  8038c9:	83 c4 1c             	add    $0x1c,%esp
  8038cc:	5b                   	pop    %ebx
  8038cd:	5e                   	pop    %esi
  8038ce:	5f                   	pop    %edi
  8038cf:	5d                   	pop    %ebp
  8038d0:	c3                   	ret    
  8038d1:	8d 76 00             	lea    0x0(%esi),%esi
  8038d4:	31 ff                	xor    %edi,%edi
  8038d6:	31 c0                	xor    %eax,%eax
  8038d8:	89 fa                	mov    %edi,%edx
  8038da:	83 c4 1c             	add    $0x1c,%esp
  8038dd:	5b                   	pop    %ebx
  8038de:	5e                   	pop    %esi
  8038df:	5f                   	pop    %edi
  8038e0:	5d                   	pop    %ebp
  8038e1:	c3                   	ret    
  8038e2:	66 90                	xchg   %ax,%ax
  8038e4:	89 d8                	mov    %ebx,%eax
  8038e6:	f7 f7                	div    %edi
  8038e8:	31 ff                	xor    %edi,%edi
  8038ea:	89 fa                	mov    %edi,%edx
  8038ec:	83 c4 1c             	add    $0x1c,%esp
  8038ef:	5b                   	pop    %ebx
  8038f0:	5e                   	pop    %esi
  8038f1:	5f                   	pop    %edi
  8038f2:	5d                   	pop    %ebp
  8038f3:	c3                   	ret    
  8038f4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8038f9:	89 eb                	mov    %ebp,%ebx
  8038fb:	29 fb                	sub    %edi,%ebx
  8038fd:	89 f9                	mov    %edi,%ecx
  8038ff:	d3 e6                	shl    %cl,%esi
  803901:	89 c5                	mov    %eax,%ebp
  803903:	88 d9                	mov    %bl,%cl
  803905:	d3 ed                	shr    %cl,%ebp
  803907:	89 e9                	mov    %ebp,%ecx
  803909:	09 f1                	or     %esi,%ecx
  80390b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80390f:	89 f9                	mov    %edi,%ecx
  803911:	d3 e0                	shl    %cl,%eax
  803913:	89 c5                	mov    %eax,%ebp
  803915:	89 d6                	mov    %edx,%esi
  803917:	88 d9                	mov    %bl,%cl
  803919:	d3 ee                	shr    %cl,%esi
  80391b:	89 f9                	mov    %edi,%ecx
  80391d:	d3 e2                	shl    %cl,%edx
  80391f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803923:	88 d9                	mov    %bl,%cl
  803925:	d3 e8                	shr    %cl,%eax
  803927:	09 c2                	or     %eax,%edx
  803929:	89 d0                	mov    %edx,%eax
  80392b:	89 f2                	mov    %esi,%edx
  80392d:	f7 74 24 0c          	divl   0xc(%esp)
  803931:	89 d6                	mov    %edx,%esi
  803933:	89 c3                	mov    %eax,%ebx
  803935:	f7 e5                	mul    %ebp
  803937:	39 d6                	cmp    %edx,%esi
  803939:	72 19                	jb     803954 <__udivdi3+0xfc>
  80393b:	74 0b                	je     803948 <__udivdi3+0xf0>
  80393d:	89 d8                	mov    %ebx,%eax
  80393f:	31 ff                	xor    %edi,%edi
  803941:	e9 58 ff ff ff       	jmp    80389e <__udivdi3+0x46>
  803946:	66 90                	xchg   %ax,%ax
  803948:	8b 54 24 08          	mov    0x8(%esp),%edx
  80394c:	89 f9                	mov    %edi,%ecx
  80394e:	d3 e2                	shl    %cl,%edx
  803950:	39 c2                	cmp    %eax,%edx
  803952:	73 e9                	jae    80393d <__udivdi3+0xe5>
  803954:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803957:	31 ff                	xor    %edi,%edi
  803959:	e9 40 ff ff ff       	jmp    80389e <__udivdi3+0x46>
  80395e:	66 90                	xchg   %ax,%ax
  803960:	31 c0                	xor    %eax,%eax
  803962:	e9 37 ff ff ff       	jmp    80389e <__udivdi3+0x46>
  803967:	90                   	nop

00803968 <__umoddi3>:
  803968:	55                   	push   %ebp
  803969:	57                   	push   %edi
  80396a:	56                   	push   %esi
  80396b:	53                   	push   %ebx
  80396c:	83 ec 1c             	sub    $0x1c,%esp
  80396f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803973:	8b 74 24 34          	mov    0x34(%esp),%esi
  803977:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80397b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80397f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803983:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803987:	89 f3                	mov    %esi,%ebx
  803989:	89 fa                	mov    %edi,%edx
  80398b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80398f:	89 34 24             	mov    %esi,(%esp)
  803992:	85 c0                	test   %eax,%eax
  803994:	75 1a                	jne    8039b0 <__umoddi3+0x48>
  803996:	39 f7                	cmp    %esi,%edi
  803998:	0f 86 a2 00 00 00    	jbe    803a40 <__umoddi3+0xd8>
  80399e:	89 c8                	mov    %ecx,%eax
  8039a0:	89 f2                	mov    %esi,%edx
  8039a2:	f7 f7                	div    %edi
  8039a4:	89 d0                	mov    %edx,%eax
  8039a6:	31 d2                	xor    %edx,%edx
  8039a8:	83 c4 1c             	add    $0x1c,%esp
  8039ab:	5b                   	pop    %ebx
  8039ac:	5e                   	pop    %esi
  8039ad:	5f                   	pop    %edi
  8039ae:	5d                   	pop    %ebp
  8039af:	c3                   	ret    
  8039b0:	39 f0                	cmp    %esi,%eax
  8039b2:	0f 87 ac 00 00 00    	ja     803a64 <__umoddi3+0xfc>
  8039b8:	0f bd e8             	bsr    %eax,%ebp
  8039bb:	83 f5 1f             	xor    $0x1f,%ebp
  8039be:	0f 84 ac 00 00 00    	je     803a70 <__umoddi3+0x108>
  8039c4:	bf 20 00 00 00       	mov    $0x20,%edi
  8039c9:	29 ef                	sub    %ebp,%edi
  8039cb:	89 fe                	mov    %edi,%esi
  8039cd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8039d1:	89 e9                	mov    %ebp,%ecx
  8039d3:	d3 e0                	shl    %cl,%eax
  8039d5:	89 d7                	mov    %edx,%edi
  8039d7:	89 f1                	mov    %esi,%ecx
  8039d9:	d3 ef                	shr    %cl,%edi
  8039db:	09 c7                	or     %eax,%edi
  8039dd:	89 e9                	mov    %ebp,%ecx
  8039df:	d3 e2                	shl    %cl,%edx
  8039e1:	89 14 24             	mov    %edx,(%esp)
  8039e4:	89 d8                	mov    %ebx,%eax
  8039e6:	d3 e0                	shl    %cl,%eax
  8039e8:	89 c2                	mov    %eax,%edx
  8039ea:	8b 44 24 08          	mov    0x8(%esp),%eax
  8039ee:	d3 e0                	shl    %cl,%eax
  8039f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8039f4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8039f8:	89 f1                	mov    %esi,%ecx
  8039fa:	d3 e8                	shr    %cl,%eax
  8039fc:	09 d0                	or     %edx,%eax
  8039fe:	d3 eb                	shr    %cl,%ebx
  803a00:	89 da                	mov    %ebx,%edx
  803a02:	f7 f7                	div    %edi
  803a04:	89 d3                	mov    %edx,%ebx
  803a06:	f7 24 24             	mull   (%esp)
  803a09:	89 c6                	mov    %eax,%esi
  803a0b:	89 d1                	mov    %edx,%ecx
  803a0d:	39 d3                	cmp    %edx,%ebx
  803a0f:	0f 82 87 00 00 00    	jb     803a9c <__umoddi3+0x134>
  803a15:	0f 84 91 00 00 00    	je     803aac <__umoddi3+0x144>
  803a1b:	8b 54 24 04          	mov    0x4(%esp),%edx
  803a1f:	29 f2                	sub    %esi,%edx
  803a21:	19 cb                	sbb    %ecx,%ebx
  803a23:	89 d8                	mov    %ebx,%eax
  803a25:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803a29:	d3 e0                	shl    %cl,%eax
  803a2b:	89 e9                	mov    %ebp,%ecx
  803a2d:	d3 ea                	shr    %cl,%edx
  803a2f:	09 d0                	or     %edx,%eax
  803a31:	89 e9                	mov    %ebp,%ecx
  803a33:	d3 eb                	shr    %cl,%ebx
  803a35:	89 da                	mov    %ebx,%edx
  803a37:	83 c4 1c             	add    $0x1c,%esp
  803a3a:	5b                   	pop    %ebx
  803a3b:	5e                   	pop    %esi
  803a3c:	5f                   	pop    %edi
  803a3d:	5d                   	pop    %ebp
  803a3e:	c3                   	ret    
  803a3f:	90                   	nop
  803a40:	89 fd                	mov    %edi,%ebp
  803a42:	85 ff                	test   %edi,%edi
  803a44:	75 0b                	jne    803a51 <__umoddi3+0xe9>
  803a46:	b8 01 00 00 00       	mov    $0x1,%eax
  803a4b:	31 d2                	xor    %edx,%edx
  803a4d:	f7 f7                	div    %edi
  803a4f:	89 c5                	mov    %eax,%ebp
  803a51:	89 f0                	mov    %esi,%eax
  803a53:	31 d2                	xor    %edx,%edx
  803a55:	f7 f5                	div    %ebp
  803a57:	89 c8                	mov    %ecx,%eax
  803a59:	f7 f5                	div    %ebp
  803a5b:	89 d0                	mov    %edx,%eax
  803a5d:	e9 44 ff ff ff       	jmp    8039a6 <__umoddi3+0x3e>
  803a62:	66 90                	xchg   %ax,%ax
  803a64:	89 c8                	mov    %ecx,%eax
  803a66:	89 f2                	mov    %esi,%edx
  803a68:	83 c4 1c             	add    $0x1c,%esp
  803a6b:	5b                   	pop    %ebx
  803a6c:	5e                   	pop    %esi
  803a6d:	5f                   	pop    %edi
  803a6e:	5d                   	pop    %ebp
  803a6f:	c3                   	ret    
  803a70:	3b 04 24             	cmp    (%esp),%eax
  803a73:	72 06                	jb     803a7b <__umoddi3+0x113>
  803a75:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803a79:	77 0f                	ja     803a8a <__umoddi3+0x122>
  803a7b:	89 f2                	mov    %esi,%edx
  803a7d:	29 f9                	sub    %edi,%ecx
  803a7f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803a83:	89 14 24             	mov    %edx,(%esp)
  803a86:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803a8a:	8b 44 24 04          	mov    0x4(%esp),%eax
  803a8e:	8b 14 24             	mov    (%esp),%edx
  803a91:	83 c4 1c             	add    $0x1c,%esp
  803a94:	5b                   	pop    %ebx
  803a95:	5e                   	pop    %esi
  803a96:	5f                   	pop    %edi
  803a97:	5d                   	pop    %ebp
  803a98:	c3                   	ret    
  803a99:	8d 76 00             	lea    0x0(%esi),%esi
  803a9c:	2b 04 24             	sub    (%esp),%eax
  803a9f:	19 fa                	sbb    %edi,%edx
  803aa1:	89 d1                	mov    %edx,%ecx
  803aa3:	89 c6                	mov    %eax,%esi
  803aa5:	e9 71 ff ff ff       	jmp    803a1b <__umoddi3+0xb3>
  803aaa:	66 90                	xchg   %ax,%ax
  803aac:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803ab0:	72 ea                	jb     803a9c <__umoddi3+0x134>
  803ab2:	89 d9                	mov    %ebx,%ecx
  803ab4:	e9 62 ff ff ff       	jmp    803a1b <__umoddi3+0xb3>
