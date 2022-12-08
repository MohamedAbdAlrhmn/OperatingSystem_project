
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
  80008a:	68 60 3a 80 00       	push   $0x803a60
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
  8000ba:	68 92 3a 80 00       	push   $0x803a92
  8000bf:	e8 28 1d 00 00       	call   801dec <sys_create_env>
  8000c4:	83 c4 10             	add    $0x10,%esp
  8000c7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		int freeFrames = sys_calculate_free_frames() ;
  8000ca:	e8 ab 1a 00 00       	call   801b7a <sys_calculate_free_frames>
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
  8000f5:	68 96 3a 80 00       	push   $0x803a96
  8000fa:	e8 ed 1c 00 00       	call   801dec <sys_create_env>
  8000ff:	83 c4 10             	add    $0x10,%esp
  800102:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		int helloWorldFrames = freeFrames - sys_calculate_free_frames() ;
  800105:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800108:	e8 6d 1a 00 00       	call   801b7a <sys_calculate_free_frames>
  80010d:	29 c3                	sub    %eax,%ebx
  80010f:	89 d8                	mov    %ebx,%eax
  800111:	89 45 d0             	mov    %eax,-0x30(%ebp)
		env_sleep(2000);
  800114:	83 ec 0c             	sub    $0xc,%esp
  800117:	68 d0 07 00 00       	push   $0x7d0
  80011c:	e8 1b 36 00 00       	call   80373c <env_sleep>
  800121:	83 c4 10             	add    $0x10,%esp
		cprintf("[DONE]\n\n");
  800124:	83 ec 0c             	sub    $0xc,%esp
  800127:	68 a5 3a 80 00       	push   $0x803aa5
  80012c:	e8 a1 08 00 00       	call   8009d2 <cprintf>
  800131:	83 c4 10             	add    $0x10,%esp

		//Load and run "fos_add"
		cprintf("Loading fos_add program into RAM...");
  800134:	83 ec 0c             	sub    $0xc,%esp
  800137:	68 b0 3a 80 00       	push   $0x803ab0
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
  800167:	68 d4 3a 80 00       	push   $0x803ad4
  80016c:	e8 7b 1c 00 00       	call   801dec <sys_create_env>
  800171:	83 c4 10             	add    $0x10,%esp
  800174:	89 45 cc             	mov    %eax,-0x34(%ebp)
		env_sleep(2000);
  800177:	83 ec 0c             	sub    $0xc,%esp
  80017a:	68 d0 07 00 00       	push   $0x7d0
  80017f:	e8 b8 35 00 00       	call   80373c <env_sleep>
  800184:	83 c4 10             	add    $0x10,%esp
		cprintf("[DONE]\n\n");
  800187:	83 ec 0c             	sub    $0xc,%esp
  80018a:	68 a5 3a 80 00       	push   $0x803aa5
  80018f:	e8 3e 08 00 00       	call   8009d2 <cprintf>
  800194:	83 c4 10             	add    $0x10,%esp
		cprintf("running fos_add program...\n\n");
  800197:	83 ec 0c             	sub    $0xc,%esp
  80019a:	68 dc 3a 80 00       	push   $0x803adc
  80019f:	e8 2e 08 00 00       	call   8009d2 <cprintf>
  8001a4:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdFOSAdd);
  8001a7:	83 ec 0c             	sub    $0xc,%esp
  8001aa:	ff 75 cc             	pushl  -0x34(%ebp)
  8001ad:	e8 58 1c 00 00       	call   801e0a <sys_run_env>
  8001b2:	83 c4 10             	add    $0x10,%esp

		cprintf("please be patient ...\n");
  8001b5:	83 ec 0c             	sub    $0xc,%esp
  8001b8:	68 f9 3a 80 00       	push   $0x803af9
  8001bd:	e8 10 08 00 00       	call   8009d2 <cprintf>
  8001c2:	83 c4 10             	add    $0x10,%esp
		env_sleep(5000);
  8001c5:	83 ec 0c             	sub    $0xc,%esp
  8001c8:	68 88 13 00 00       	push   $0x1388
  8001cd:	e8 6a 35 00 00       	call   80373c <env_sleep>
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
  800266:	e8 0f 19 00 00       	call   801b7a <sys_calculate_free_frames>
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
  800352:	68 10 3b 80 00       	push   $0x803b10
  800357:	e8 76 06 00 00       	call   8009d2 <cprintf>
  80035c:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdHelloWorld);
  80035f:	83 ec 0c             	sub    $0xc,%esp
  800362:	ff 75 d4             	pushl  -0x2c(%ebp)
  800365:	e8 a0 1a 00 00       	call   801e0a <sys_run_env>
  80036a:	83 c4 10             	add    $0x10,%esp

		cprintf("please be patient ...\n");
  80036d:	83 ec 0c             	sub    $0xc,%esp
  800370:	68 f9 3a 80 00       	push   $0x803af9
  800375:	e8 58 06 00 00       	call   8009d2 <cprintf>
  80037a:	83 c4 10             	add    $0x10,%esp
		env_sleep(5000);
  80037d:	83 ec 0c             	sub    $0xc,%esp
  800380:	68 88 13 00 00       	push   $0x1388
  800385:	e8 b2 33 00 00       	call   80373c <env_sleep>
  80038a:	83 c4 10             	add    $0x10,%esp

		//Allocate the remaining RAM + extra RAM by the size of helloWorld program (Here: it requires to free some RAM by removing exited & loaded program(s) (fos_helloWorld & fib))
		freeFrames = sys_calculate_free_frames() ;
  80038d:	e8 e8 17 00 00       	call   801b7a <sys_calculate_free_frames>
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
  800444:	68 34 3b 80 00       	push   $0x803b34
  800449:	6a 62                	push   $0x62
  80044b:	68 69 3b 80 00       	push   $0x803b69
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
  800479:	68 34 3b 80 00       	push   $0x803b34
  80047e:	6a 63                	push   $0x63
  800480:	68 69 3b 80 00       	push   $0x803b69
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
  8004ad:	68 34 3b 80 00       	push   $0x803b34
  8004b2:	6a 64                	push   $0x64
  8004b4:	68 69 3b 80 00       	push   $0x803b69
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
  8004e1:	68 34 3b 80 00       	push   $0x803b34
  8004e6:	6a 65                	push   $0x65
  8004e8:	68 69 3b 80 00       	push   $0x803b69
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
  800515:	68 34 3b 80 00       	push   $0x803b34
  80051a:	6a 66                	push   $0x66
  80051c:	68 69 3b 80 00       	push   $0x803b69
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
  800549:	68 34 3b 80 00       	push   $0x803b34
  80054e:	6a 68                	push   $0x68
  800550:	68 69 3b 80 00       	push   $0x803b69
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
  800583:	68 34 3b 80 00       	push   $0x803b34
  800588:	6a 69                	push   $0x69
  80058a:	68 69 3b 80 00       	push   $0x803b69
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
  8005b9:	68 34 3b 80 00       	push   $0x803b34
  8005be:	6a 6a                	push   $0x6a
  8005c0:	68 69 3b 80 00       	push   $0x803b69
  8005c5:	e8 54 01 00 00       	call   80071e <_panic>


	}

	cprintf("Congratulations!! test freeRAM (1) completed successfully.\n");
  8005ca:	83 ec 0c             	sub    $0xc,%esp
  8005cd:	68 80 3b 80 00       	push   $0x803b80
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
  8005e8:	e8 6d 18 00 00       	call   801e5a <sys_getenvindex>
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
  800653:	e8 0f 16 00 00       	call   801c67 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800658:	83 ec 0c             	sub    $0xc,%esp
  80065b:	68 d4 3b 80 00       	push   $0x803bd4
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
  800683:	68 fc 3b 80 00       	push   $0x803bfc
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
  8006b4:	68 24 3c 80 00       	push   $0x803c24
  8006b9:	e8 14 03 00 00       	call   8009d2 <cprintf>
  8006be:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8006c1:	a1 20 50 80 00       	mov    0x805020,%eax
  8006c6:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8006cc:	83 ec 08             	sub    $0x8,%esp
  8006cf:	50                   	push   %eax
  8006d0:	68 7c 3c 80 00       	push   $0x803c7c
  8006d5:	e8 f8 02 00 00       	call   8009d2 <cprintf>
  8006da:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8006dd:	83 ec 0c             	sub    $0xc,%esp
  8006e0:	68 d4 3b 80 00       	push   $0x803bd4
  8006e5:	e8 e8 02 00 00       	call   8009d2 <cprintf>
  8006ea:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8006ed:	e8 8f 15 00 00       	call   801c81 <sys_enable_interrupt>

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
  800705:	e8 1c 17 00 00       	call   801e26 <sys_destroy_env>
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
  800716:	e8 71 17 00 00       	call   801e8c <sys_exit_env>
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
  80073f:	68 90 3c 80 00       	push   $0x803c90
  800744:	e8 89 02 00 00       	call   8009d2 <cprintf>
  800749:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80074c:	a1 00 50 80 00       	mov    0x805000,%eax
  800751:	ff 75 0c             	pushl  0xc(%ebp)
  800754:	ff 75 08             	pushl  0x8(%ebp)
  800757:	50                   	push   %eax
  800758:	68 95 3c 80 00       	push   $0x803c95
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
  80077c:	68 b1 3c 80 00       	push   $0x803cb1
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
  8007a8:	68 b4 3c 80 00       	push   $0x803cb4
  8007ad:	6a 26                	push   $0x26
  8007af:	68 00 3d 80 00       	push   $0x803d00
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
  80087a:	68 0c 3d 80 00       	push   $0x803d0c
  80087f:	6a 3a                	push   $0x3a
  800881:	68 00 3d 80 00       	push   $0x803d00
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
  8008ea:	68 60 3d 80 00       	push   $0x803d60
  8008ef:	6a 44                	push   $0x44
  8008f1:	68 00 3d 80 00       	push   $0x803d00
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
  800944:	e8 70 11 00 00       	call   801ab9 <sys_cputs>
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
  8009bb:	e8 f9 10 00 00       	call   801ab9 <sys_cputs>
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
  800a05:	e8 5d 12 00 00       	call   801c67 <sys_disable_interrupt>
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
  800a25:	e8 57 12 00 00       	call   801c81 <sys_enable_interrupt>
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
  800a6f:	e8 7c 2d 00 00       	call   8037f0 <__udivdi3>
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
  800abf:	e8 3c 2e 00 00       	call   803900 <__umoddi3>
  800ac4:	83 c4 10             	add    $0x10,%esp
  800ac7:	05 d4 3f 80 00       	add    $0x803fd4,%eax
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
  800c1a:	8b 04 85 f8 3f 80 00 	mov    0x803ff8(,%eax,4),%eax
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
  800cfb:	8b 34 9d 40 3e 80 00 	mov    0x803e40(,%ebx,4),%esi
  800d02:	85 f6                	test   %esi,%esi
  800d04:	75 19                	jne    800d1f <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d06:	53                   	push   %ebx
  800d07:	68 e5 3f 80 00       	push   $0x803fe5
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
  800d20:	68 ee 3f 80 00       	push   $0x803fee
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
  800d4d:	be f1 3f 80 00       	mov    $0x803ff1,%esi
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
  801773:	68 50 41 80 00       	push   $0x804150
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
  801843:	e8 b5 03 00 00       	call   801bfd <sys_allocate_chunk>
  801848:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  80184b:	a1 20 51 80 00       	mov    0x805120,%eax
  801850:	83 ec 0c             	sub    $0xc,%esp
  801853:	50                   	push   %eax
  801854:	e8 2a 0a 00 00       	call   802283 <initialize_MemBlocksList>
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
  801881:	68 75 41 80 00       	push   $0x804175
  801886:	6a 33                	push   $0x33
  801888:	68 93 41 80 00       	push   $0x804193
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
  801900:	68 a0 41 80 00       	push   $0x8041a0
  801905:	6a 34                	push   $0x34
  801907:	68 93 41 80 00       	push   $0x804193
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
  801975:	68 c4 41 80 00       	push   $0x8041c4
  80197a:	6a 46                	push   $0x46
  80197c:	68 93 41 80 00       	push   $0x804193
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
  801991:	68 ec 41 80 00       	push   $0x8041ec
  801996:	6a 61                	push   $0x61
  801998:	68 93 41 80 00       	push   $0x804193
  80199d:	e8 7c ed ff ff       	call   80071e <_panic>

008019a2 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8019a2:	55                   	push   %ebp
  8019a3:	89 e5                	mov    %esp,%ebp
  8019a5:	83 ec 18             	sub    $0x18,%esp
  8019a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8019ab:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8019ae:	e8 a9 fd ff ff       	call   80175c <InitializeUHeap>
	if (size == 0) return NULL ;
  8019b3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8019b7:	75 07                	jne    8019c0 <smalloc+0x1e>
  8019b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8019be:	eb 14                	jmp    8019d4 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  8019c0:	83 ec 04             	sub    $0x4,%esp
  8019c3:	68 10 42 80 00       	push   $0x804210
  8019c8:	6a 76                	push   $0x76
  8019ca:	68 93 41 80 00       	push   $0x804193
  8019cf:	e8 4a ed ff ff       	call   80071e <_panic>

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8019d4:	c9                   	leave  
  8019d5:	c3                   	ret    

008019d6 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8019d6:	55                   	push   %ebp
  8019d7:	89 e5                	mov    %esp,%ebp
  8019d9:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8019dc:	e8 7b fd ff ff       	call   80175c <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8019e1:	83 ec 04             	sub    $0x4,%esp
  8019e4:	68 38 42 80 00       	push   $0x804238
  8019e9:	68 93 00 00 00       	push   $0x93
  8019ee:	68 93 41 80 00       	push   $0x804193
  8019f3:	e8 26 ed ff ff       	call   80071e <_panic>

008019f8 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8019f8:	55                   	push   %ebp
  8019f9:	89 e5                	mov    %esp,%ebp
  8019fb:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8019fe:	e8 59 fd ff ff       	call   80175c <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801a03:	83 ec 04             	sub    $0x4,%esp
  801a06:	68 5c 42 80 00       	push   $0x80425c
  801a0b:	68 c5 00 00 00       	push   $0xc5
  801a10:	68 93 41 80 00       	push   $0x804193
  801a15:	e8 04 ed ff ff       	call   80071e <_panic>

00801a1a <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801a1a:	55                   	push   %ebp
  801a1b:	89 e5                	mov    %esp,%ebp
  801a1d:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801a20:	83 ec 04             	sub    $0x4,%esp
  801a23:	68 84 42 80 00       	push   $0x804284
  801a28:	68 d9 00 00 00       	push   $0xd9
  801a2d:	68 93 41 80 00       	push   $0x804193
  801a32:	e8 e7 ec ff ff       	call   80071e <_panic>

00801a37 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801a37:	55                   	push   %ebp
  801a38:	89 e5                	mov    %esp,%ebp
  801a3a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a3d:	83 ec 04             	sub    $0x4,%esp
  801a40:	68 a8 42 80 00       	push   $0x8042a8
  801a45:	68 e4 00 00 00       	push   $0xe4
  801a4a:	68 93 41 80 00       	push   $0x804193
  801a4f:	e8 ca ec ff ff       	call   80071e <_panic>

00801a54 <shrink>:

}
void shrink(uint32 newSize)
{
  801a54:	55                   	push   %ebp
  801a55:	89 e5                	mov    %esp,%ebp
  801a57:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a5a:	83 ec 04             	sub    $0x4,%esp
  801a5d:	68 a8 42 80 00       	push   $0x8042a8
  801a62:	68 e9 00 00 00       	push   $0xe9
  801a67:	68 93 41 80 00       	push   $0x804193
  801a6c:	e8 ad ec ff ff       	call   80071e <_panic>

00801a71 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801a71:	55                   	push   %ebp
  801a72:	89 e5                	mov    %esp,%ebp
  801a74:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a77:	83 ec 04             	sub    $0x4,%esp
  801a7a:	68 a8 42 80 00       	push   $0x8042a8
  801a7f:	68 ee 00 00 00       	push   $0xee
  801a84:	68 93 41 80 00       	push   $0x804193
  801a89:	e8 90 ec ff ff       	call   80071e <_panic>

00801a8e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801a8e:	55                   	push   %ebp
  801a8f:	89 e5                	mov    %esp,%ebp
  801a91:	57                   	push   %edi
  801a92:	56                   	push   %esi
  801a93:	53                   	push   %ebx
  801a94:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a97:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a9d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801aa0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801aa3:	8b 7d 18             	mov    0x18(%ebp),%edi
  801aa6:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801aa9:	cd 30                	int    $0x30
  801aab:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801aae:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801ab1:	83 c4 10             	add    $0x10,%esp
  801ab4:	5b                   	pop    %ebx
  801ab5:	5e                   	pop    %esi
  801ab6:	5f                   	pop    %edi
  801ab7:	5d                   	pop    %ebp
  801ab8:	c3                   	ret    

00801ab9 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801ab9:	55                   	push   %ebp
  801aba:	89 e5                	mov    %esp,%ebp
  801abc:	83 ec 04             	sub    $0x4,%esp
  801abf:	8b 45 10             	mov    0x10(%ebp),%eax
  801ac2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801ac5:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  801acc:	6a 00                	push   $0x0
  801ace:	6a 00                	push   $0x0
  801ad0:	52                   	push   %edx
  801ad1:	ff 75 0c             	pushl  0xc(%ebp)
  801ad4:	50                   	push   %eax
  801ad5:	6a 00                	push   $0x0
  801ad7:	e8 b2 ff ff ff       	call   801a8e <syscall>
  801adc:	83 c4 18             	add    $0x18,%esp
}
  801adf:	90                   	nop
  801ae0:	c9                   	leave  
  801ae1:	c3                   	ret    

00801ae2 <sys_cgetc>:

int
sys_cgetc(void)
{
  801ae2:	55                   	push   %ebp
  801ae3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801ae5:	6a 00                	push   $0x0
  801ae7:	6a 00                	push   $0x0
  801ae9:	6a 00                	push   $0x0
  801aeb:	6a 00                	push   $0x0
  801aed:	6a 00                	push   $0x0
  801aef:	6a 01                	push   $0x1
  801af1:	e8 98 ff ff ff       	call   801a8e <syscall>
  801af6:	83 c4 18             	add    $0x18,%esp
}
  801af9:	c9                   	leave  
  801afa:	c3                   	ret    

00801afb <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801afb:	55                   	push   %ebp
  801afc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801afe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b01:	8b 45 08             	mov    0x8(%ebp),%eax
  801b04:	6a 00                	push   $0x0
  801b06:	6a 00                	push   $0x0
  801b08:	6a 00                	push   $0x0
  801b0a:	52                   	push   %edx
  801b0b:	50                   	push   %eax
  801b0c:	6a 05                	push   $0x5
  801b0e:	e8 7b ff ff ff       	call   801a8e <syscall>
  801b13:	83 c4 18             	add    $0x18,%esp
}
  801b16:	c9                   	leave  
  801b17:	c3                   	ret    

00801b18 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801b18:	55                   	push   %ebp
  801b19:	89 e5                	mov    %esp,%ebp
  801b1b:	56                   	push   %esi
  801b1c:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801b1d:	8b 75 18             	mov    0x18(%ebp),%esi
  801b20:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b23:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b26:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b29:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2c:	56                   	push   %esi
  801b2d:	53                   	push   %ebx
  801b2e:	51                   	push   %ecx
  801b2f:	52                   	push   %edx
  801b30:	50                   	push   %eax
  801b31:	6a 06                	push   $0x6
  801b33:	e8 56 ff ff ff       	call   801a8e <syscall>
  801b38:	83 c4 18             	add    $0x18,%esp
}
  801b3b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b3e:	5b                   	pop    %ebx
  801b3f:	5e                   	pop    %esi
  801b40:	5d                   	pop    %ebp
  801b41:	c3                   	ret    

00801b42 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801b42:	55                   	push   %ebp
  801b43:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801b45:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b48:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 00                	push   $0x0
  801b4f:	6a 00                	push   $0x0
  801b51:	52                   	push   %edx
  801b52:	50                   	push   %eax
  801b53:	6a 07                	push   $0x7
  801b55:	e8 34 ff ff ff       	call   801a8e <syscall>
  801b5a:	83 c4 18             	add    $0x18,%esp
}
  801b5d:	c9                   	leave  
  801b5e:	c3                   	ret    

00801b5f <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801b5f:	55                   	push   %ebp
  801b60:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801b62:	6a 00                	push   $0x0
  801b64:	6a 00                	push   $0x0
  801b66:	6a 00                	push   $0x0
  801b68:	ff 75 0c             	pushl  0xc(%ebp)
  801b6b:	ff 75 08             	pushl  0x8(%ebp)
  801b6e:	6a 08                	push   $0x8
  801b70:	e8 19 ff ff ff       	call   801a8e <syscall>
  801b75:	83 c4 18             	add    $0x18,%esp
}
  801b78:	c9                   	leave  
  801b79:	c3                   	ret    

00801b7a <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801b7a:	55                   	push   %ebp
  801b7b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801b7d:	6a 00                	push   $0x0
  801b7f:	6a 00                	push   $0x0
  801b81:	6a 00                	push   $0x0
  801b83:	6a 00                	push   $0x0
  801b85:	6a 00                	push   $0x0
  801b87:	6a 09                	push   $0x9
  801b89:	e8 00 ff ff ff       	call   801a8e <syscall>
  801b8e:	83 c4 18             	add    $0x18,%esp
}
  801b91:	c9                   	leave  
  801b92:	c3                   	ret    

00801b93 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801b93:	55                   	push   %ebp
  801b94:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801b96:	6a 00                	push   $0x0
  801b98:	6a 00                	push   $0x0
  801b9a:	6a 00                	push   $0x0
  801b9c:	6a 00                	push   $0x0
  801b9e:	6a 00                	push   $0x0
  801ba0:	6a 0a                	push   $0xa
  801ba2:	e8 e7 fe ff ff       	call   801a8e <syscall>
  801ba7:	83 c4 18             	add    $0x18,%esp
}
  801baa:	c9                   	leave  
  801bab:	c3                   	ret    

00801bac <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801bac:	55                   	push   %ebp
  801bad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801baf:	6a 00                	push   $0x0
  801bb1:	6a 00                	push   $0x0
  801bb3:	6a 00                	push   $0x0
  801bb5:	6a 00                	push   $0x0
  801bb7:	6a 00                	push   $0x0
  801bb9:	6a 0b                	push   $0xb
  801bbb:	e8 ce fe ff ff       	call   801a8e <syscall>
  801bc0:	83 c4 18             	add    $0x18,%esp
}
  801bc3:	c9                   	leave  
  801bc4:	c3                   	ret    

00801bc5 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801bc5:	55                   	push   %ebp
  801bc6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 00                	push   $0x0
  801bcc:	6a 00                	push   $0x0
  801bce:	ff 75 0c             	pushl  0xc(%ebp)
  801bd1:	ff 75 08             	pushl  0x8(%ebp)
  801bd4:	6a 0f                	push   $0xf
  801bd6:	e8 b3 fe ff ff       	call   801a8e <syscall>
  801bdb:	83 c4 18             	add    $0x18,%esp
	return;
  801bde:	90                   	nop
}
  801bdf:	c9                   	leave  
  801be0:	c3                   	ret    

00801be1 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801be1:	55                   	push   %ebp
  801be2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801be4:	6a 00                	push   $0x0
  801be6:	6a 00                	push   $0x0
  801be8:	6a 00                	push   $0x0
  801bea:	ff 75 0c             	pushl  0xc(%ebp)
  801bed:	ff 75 08             	pushl  0x8(%ebp)
  801bf0:	6a 10                	push   $0x10
  801bf2:	e8 97 fe ff ff       	call   801a8e <syscall>
  801bf7:	83 c4 18             	add    $0x18,%esp
	return ;
  801bfa:	90                   	nop
}
  801bfb:	c9                   	leave  
  801bfc:	c3                   	ret    

00801bfd <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801bfd:	55                   	push   %ebp
  801bfe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801c00:	6a 00                	push   $0x0
  801c02:	6a 00                	push   $0x0
  801c04:	ff 75 10             	pushl  0x10(%ebp)
  801c07:	ff 75 0c             	pushl  0xc(%ebp)
  801c0a:	ff 75 08             	pushl  0x8(%ebp)
  801c0d:	6a 11                	push   $0x11
  801c0f:	e8 7a fe ff ff       	call   801a8e <syscall>
  801c14:	83 c4 18             	add    $0x18,%esp
	return ;
  801c17:	90                   	nop
}
  801c18:	c9                   	leave  
  801c19:	c3                   	ret    

00801c1a <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801c1a:	55                   	push   %ebp
  801c1b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 00                	push   $0x0
  801c23:	6a 00                	push   $0x0
  801c25:	6a 00                	push   $0x0
  801c27:	6a 0c                	push   $0xc
  801c29:	e8 60 fe ff ff       	call   801a8e <syscall>
  801c2e:	83 c4 18             	add    $0x18,%esp
}
  801c31:	c9                   	leave  
  801c32:	c3                   	ret    

00801c33 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801c33:	55                   	push   %ebp
  801c34:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801c36:	6a 00                	push   $0x0
  801c38:	6a 00                	push   $0x0
  801c3a:	6a 00                	push   $0x0
  801c3c:	6a 00                	push   $0x0
  801c3e:	ff 75 08             	pushl  0x8(%ebp)
  801c41:	6a 0d                	push   $0xd
  801c43:	e8 46 fe ff ff       	call   801a8e <syscall>
  801c48:	83 c4 18             	add    $0x18,%esp
}
  801c4b:	c9                   	leave  
  801c4c:	c3                   	ret    

00801c4d <sys_scarce_memory>:

void sys_scarce_memory()
{
  801c4d:	55                   	push   %ebp
  801c4e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801c50:	6a 00                	push   $0x0
  801c52:	6a 00                	push   $0x0
  801c54:	6a 00                	push   $0x0
  801c56:	6a 00                	push   $0x0
  801c58:	6a 00                	push   $0x0
  801c5a:	6a 0e                	push   $0xe
  801c5c:	e8 2d fe ff ff       	call   801a8e <syscall>
  801c61:	83 c4 18             	add    $0x18,%esp
}
  801c64:	90                   	nop
  801c65:	c9                   	leave  
  801c66:	c3                   	ret    

00801c67 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801c67:	55                   	push   %ebp
  801c68:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801c6a:	6a 00                	push   $0x0
  801c6c:	6a 00                	push   $0x0
  801c6e:	6a 00                	push   $0x0
  801c70:	6a 00                	push   $0x0
  801c72:	6a 00                	push   $0x0
  801c74:	6a 13                	push   $0x13
  801c76:	e8 13 fe ff ff       	call   801a8e <syscall>
  801c7b:	83 c4 18             	add    $0x18,%esp
}
  801c7e:	90                   	nop
  801c7f:	c9                   	leave  
  801c80:	c3                   	ret    

00801c81 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801c81:	55                   	push   %ebp
  801c82:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801c84:	6a 00                	push   $0x0
  801c86:	6a 00                	push   $0x0
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 14                	push   $0x14
  801c90:	e8 f9 fd ff ff       	call   801a8e <syscall>
  801c95:	83 c4 18             	add    $0x18,%esp
}
  801c98:	90                   	nop
  801c99:	c9                   	leave  
  801c9a:	c3                   	ret    

00801c9b <sys_cputc>:


void
sys_cputc(const char c)
{
  801c9b:	55                   	push   %ebp
  801c9c:	89 e5                	mov    %esp,%ebp
  801c9e:	83 ec 04             	sub    $0x4,%esp
  801ca1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801ca7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801cab:	6a 00                	push   $0x0
  801cad:	6a 00                	push   $0x0
  801caf:	6a 00                	push   $0x0
  801cb1:	6a 00                	push   $0x0
  801cb3:	50                   	push   %eax
  801cb4:	6a 15                	push   $0x15
  801cb6:	e8 d3 fd ff ff       	call   801a8e <syscall>
  801cbb:	83 c4 18             	add    $0x18,%esp
}
  801cbe:	90                   	nop
  801cbf:	c9                   	leave  
  801cc0:	c3                   	ret    

00801cc1 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801cc1:	55                   	push   %ebp
  801cc2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801cc4:	6a 00                	push   $0x0
  801cc6:	6a 00                	push   $0x0
  801cc8:	6a 00                	push   $0x0
  801cca:	6a 00                	push   $0x0
  801ccc:	6a 00                	push   $0x0
  801cce:	6a 16                	push   $0x16
  801cd0:	e8 b9 fd ff ff       	call   801a8e <syscall>
  801cd5:	83 c4 18             	add    $0x18,%esp
}
  801cd8:	90                   	nop
  801cd9:	c9                   	leave  
  801cda:	c3                   	ret    

00801cdb <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801cdb:	55                   	push   %ebp
  801cdc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801cde:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce1:	6a 00                	push   $0x0
  801ce3:	6a 00                	push   $0x0
  801ce5:	6a 00                	push   $0x0
  801ce7:	ff 75 0c             	pushl  0xc(%ebp)
  801cea:	50                   	push   %eax
  801ceb:	6a 17                	push   $0x17
  801ced:	e8 9c fd ff ff       	call   801a8e <syscall>
  801cf2:	83 c4 18             	add    $0x18,%esp
}
  801cf5:	c9                   	leave  
  801cf6:	c3                   	ret    

00801cf7 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801cf7:	55                   	push   %ebp
  801cf8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801cfa:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cfd:	8b 45 08             	mov    0x8(%ebp),%eax
  801d00:	6a 00                	push   $0x0
  801d02:	6a 00                	push   $0x0
  801d04:	6a 00                	push   $0x0
  801d06:	52                   	push   %edx
  801d07:	50                   	push   %eax
  801d08:	6a 1a                	push   $0x1a
  801d0a:	e8 7f fd ff ff       	call   801a8e <syscall>
  801d0f:	83 c4 18             	add    $0x18,%esp
}
  801d12:	c9                   	leave  
  801d13:	c3                   	ret    

00801d14 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801d14:	55                   	push   %ebp
  801d15:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d17:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1d:	6a 00                	push   $0x0
  801d1f:	6a 00                	push   $0x0
  801d21:	6a 00                	push   $0x0
  801d23:	52                   	push   %edx
  801d24:	50                   	push   %eax
  801d25:	6a 18                	push   $0x18
  801d27:	e8 62 fd ff ff       	call   801a8e <syscall>
  801d2c:	83 c4 18             	add    $0x18,%esp
}
  801d2f:	90                   	nop
  801d30:	c9                   	leave  
  801d31:	c3                   	ret    

00801d32 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801d32:	55                   	push   %ebp
  801d33:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d35:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d38:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3b:	6a 00                	push   $0x0
  801d3d:	6a 00                	push   $0x0
  801d3f:	6a 00                	push   $0x0
  801d41:	52                   	push   %edx
  801d42:	50                   	push   %eax
  801d43:	6a 19                	push   $0x19
  801d45:	e8 44 fd ff ff       	call   801a8e <syscall>
  801d4a:	83 c4 18             	add    $0x18,%esp
}
  801d4d:	90                   	nop
  801d4e:	c9                   	leave  
  801d4f:	c3                   	ret    

00801d50 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801d50:	55                   	push   %ebp
  801d51:	89 e5                	mov    %esp,%ebp
  801d53:	83 ec 04             	sub    $0x4,%esp
  801d56:	8b 45 10             	mov    0x10(%ebp),%eax
  801d59:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801d5c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d5f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d63:	8b 45 08             	mov    0x8(%ebp),%eax
  801d66:	6a 00                	push   $0x0
  801d68:	51                   	push   %ecx
  801d69:	52                   	push   %edx
  801d6a:	ff 75 0c             	pushl  0xc(%ebp)
  801d6d:	50                   	push   %eax
  801d6e:	6a 1b                	push   $0x1b
  801d70:	e8 19 fd ff ff       	call   801a8e <syscall>
  801d75:	83 c4 18             	add    $0x18,%esp
}
  801d78:	c9                   	leave  
  801d79:	c3                   	ret    

00801d7a <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801d7a:	55                   	push   %ebp
  801d7b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801d7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d80:	8b 45 08             	mov    0x8(%ebp),%eax
  801d83:	6a 00                	push   $0x0
  801d85:	6a 00                	push   $0x0
  801d87:	6a 00                	push   $0x0
  801d89:	52                   	push   %edx
  801d8a:	50                   	push   %eax
  801d8b:	6a 1c                	push   $0x1c
  801d8d:	e8 fc fc ff ff       	call   801a8e <syscall>
  801d92:	83 c4 18             	add    $0x18,%esp
}
  801d95:	c9                   	leave  
  801d96:	c3                   	ret    

00801d97 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801d97:	55                   	push   %ebp
  801d98:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801d9a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d9d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801da0:	8b 45 08             	mov    0x8(%ebp),%eax
  801da3:	6a 00                	push   $0x0
  801da5:	6a 00                	push   $0x0
  801da7:	51                   	push   %ecx
  801da8:	52                   	push   %edx
  801da9:	50                   	push   %eax
  801daa:	6a 1d                	push   $0x1d
  801dac:	e8 dd fc ff ff       	call   801a8e <syscall>
  801db1:	83 c4 18             	add    $0x18,%esp
}
  801db4:	c9                   	leave  
  801db5:	c3                   	ret    

00801db6 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801db6:	55                   	push   %ebp
  801db7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801db9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dbc:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbf:	6a 00                	push   $0x0
  801dc1:	6a 00                	push   $0x0
  801dc3:	6a 00                	push   $0x0
  801dc5:	52                   	push   %edx
  801dc6:	50                   	push   %eax
  801dc7:	6a 1e                	push   $0x1e
  801dc9:	e8 c0 fc ff ff       	call   801a8e <syscall>
  801dce:	83 c4 18             	add    $0x18,%esp
}
  801dd1:	c9                   	leave  
  801dd2:	c3                   	ret    

00801dd3 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801dd3:	55                   	push   %ebp
  801dd4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801dd6:	6a 00                	push   $0x0
  801dd8:	6a 00                	push   $0x0
  801dda:	6a 00                	push   $0x0
  801ddc:	6a 00                	push   $0x0
  801dde:	6a 00                	push   $0x0
  801de0:	6a 1f                	push   $0x1f
  801de2:	e8 a7 fc ff ff       	call   801a8e <syscall>
  801de7:	83 c4 18             	add    $0x18,%esp
}
  801dea:	c9                   	leave  
  801deb:	c3                   	ret    

00801dec <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801dec:	55                   	push   %ebp
  801ded:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801def:	8b 45 08             	mov    0x8(%ebp),%eax
  801df2:	6a 00                	push   $0x0
  801df4:	ff 75 14             	pushl  0x14(%ebp)
  801df7:	ff 75 10             	pushl  0x10(%ebp)
  801dfa:	ff 75 0c             	pushl  0xc(%ebp)
  801dfd:	50                   	push   %eax
  801dfe:	6a 20                	push   $0x20
  801e00:	e8 89 fc ff ff       	call   801a8e <syscall>
  801e05:	83 c4 18             	add    $0x18,%esp
}
  801e08:	c9                   	leave  
  801e09:	c3                   	ret    

00801e0a <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801e0a:	55                   	push   %ebp
  801e0b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801e0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e10:	6a 00                	push   $0x0
  801e12:	6a 00                	push   $0x0
  801e14:	6a 00                	push   $0x0
  801e16:	6a 00                	push   $0x0
  801e18:	50                   	push   %eax
  801e19:	6a 21                	push   $0x21
  801e1b:	e8 6e fc ff ff       	call   801a8e <syscall>
  801e20:	83 c4 18             	add    $0x18,%esp
}
  801e23:	90                   	nop
  801e24:	c9                   	leave  
  801e25:	c3                   	ret    

00801e26 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801e26:	55                   	push   %ebp
  801e27:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801e29:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2c:	6a 00                	push   $0x0
  801e2e:	6a 00                	push   $0x0
  801e30:	6a 00                	push   $0x0
  801e32:	6a 00                	push   $0x0
  801e34:	50                   	push   %eax
  801e35:	6a 22                	push   $0x22
  801e37:	e8 52 fc ff ff       	call   801a8e <syscall>
  801e3c:	83 c4 18             	add    $0x18,%esp
}
  801e3f:	c9                   	leave  
  801e40:	c3                   	ret    

00801e41 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801e41:	55                   	push   %ebp
  801e42:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801e44:	6a 00                	push   $0x0
  801e46:	6a 00                	push   $0x0
  801e48:	6a 00                	push   $0x0
  801e4a:	6a 00                	push   $0x0
  801e4c:	6a 00                	push   $0x0
  801e4e:	6a 02                	push   $0x2
  801e50:	e8 39 fc ff ff       	call   801a8e <syscall>
  801e55:	83 c4 18             	add    $0x18,%esp
}
  801e58:	c9                   	leave  
  801e59:	c3                   	ret    

00801e5a <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801e5a:	55                   	push   %ebp
  801e5b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801e5d:	6a 00                	push   $0x0
  801e5f:	6a 00                	push   $0x0
  801e61:	6a 00                	push   $0x0
  801e63:	6a 00                	push   $0x0
  801e65:	6a 00                	push   $0x0
  801e67:	6a 03                	push   $0x3
  801e69:	e8 20 fc ff ff       	call   801a8e <syscall>
  801e6e:	83 c4 18             	add    $0x18,%esp
}
  801e71:	c9                   	leave  
  801e72:	c3                   	ret    

00801e73 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801e73:	55                   	push   %ebp
  801e74:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801e76:	6a 00                	push   $0x0
  801e78:	6a 00                	push   $0x0
  801e7a:	6a 00                	push   $0x0
  801e7c:	6a 00                	push   $0x0
  801e7e:	6a 00                	push   $0x0
  801e80:	6a 04                	push   $0x4
  801e82:	e8 07 fc ff ff       	call   801a8e <syscall>
  801e87:	83 c4 18             	add    $0x18,%esp
}
  801e8a:	c9                   	leave  
  801e8b:	c3                   	ret    

00801e8c <sys_exit_env>:


void sys_exit_env(void)
{
  801e8c:	55                   	push   %ebp
  801e8d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801e8f:	6a 00                	push   $0x0
  801e91:	6a 00                	push   $0x0
  801e93:	6a 00                	push   $0x0
  801e95:	6a 00                	push   $0x0
  801e97:	6a 00                	push   $0x0
  801e99:	6a 23                	push   $0x23
  801e9b:	e8 ee fb ff ff       	call   801a8e <syscall>
  801ea0:	83 c4 18             	add    $0x18,%esp
}
  801ea3:	90                   	nop
  801ea4:	c9                   	leave  
  801ea5:	c3                   	ret    

00801ea6 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801ea6:	55                   	push   %ebp
  801ea7:	89 e5                	mov    %esp,%ebp
  801ea9:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801eac:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801eaf:	8d 50 04             	lea    0x4(%eax),%edx
  801eb2:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801eb5:	6a 00                	push   $0x0
  801eb7:	6a 00                	push   $0x0
  801eb9:	6a 00                	push   $0x0
  801ebb:	52                   	push   %edx
  801ebc:	50                   	push   %eax
  801ebd:	6a 24                	push   $0x24
  801ebf:	e8 ca fb ff ff       	call   801a8e <syscall>
  801ec4:	83 c4 18             	add    $0x18,%esp
	return result;
  801ec7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801eca:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ecd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ed0:	89 01                	mov    %eax,(%ecx)
  801ed2:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801ed5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed8:	c9                   	leave  
  801ed9:	c2 04 00             	ret    $0x4

00801edc <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801edc:	55                   	push   %ebp
  801edd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801edf:	6a 00                	push   $0x0
  801ee1:	6a 00                	push   $0x0
  801ee3:	ff 75 10             	pushl  0x10(%ebp)
  801ee6:	ff 75 0c             	pushl  0xc(%ebp)
  801ee9:	ff 75 08             	pushl  0x8(%ebp)
  801eec:	6a 12                	push   $0x12
  801eee:	e8 9b fb ff ff       	call   801a8e <syscall>
  801ef3:	83 c4 18             	add    $0x18,%esp
	return ;
  801ef6:	90                   	nop
}
  801ef7:	c9                   	leave  
  801ef8:	c3                   	ret    

00801ef9 <sys_rcr2>:
uint32 sys_rcr2()
{
  801ef9:	55                   	push   %ebp
  801efa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801efc:	6a 00                	push   $0x0
  801efe:	6a 00                	push   $0x0
  801f00:	6a 00                	push   $0x0
  801f02:	6a 00                	push   $0x0
  801f04:	6a 00                	push   $0x0
  801f06:	6a 25                	push   $0x25
  801f08:	e8 81 fb ff ff       	call   801a8e <syscall>
  801f0d:	83 c4 18             	add    $0x18,%esp
}
  801f10:	c9                   	leave  
  801f11:	c3                   	ret    

00801f12 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801f12:	55                   	push   %ebp
  801f13:	89 e5                	mov    %esp,%ebp
  801f15:	83 ec 04             	sub    $0x4,%esp
  801f18:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801f1e:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801f22:	6a 00                	push   $0x0
  801f24:	6a 00                	push   $0x0
  801f26:	6a 00                	push   $0x0
  801f28:	6a 00                	push   $0x0
  801f2a:	50                   	push   %eax
  801f2b:	6a 26                	push   $0x26
  801f2d:	e8 5c fb ff ff       	call   801a8e <syscall>
  801f32:	83 c4 18             	add    $0x18,%esp
	return ;
  801f35:	90                   	nop
}
  801f36:	c9                   	leave  
  801f37:	c3                   	ret    

00801f38 <rsttst>:
void rsttst()
{
  801f38:	55                   	push   %ebp
  801f39:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801f3b:	6a 00                	push   $0x0
  801f3d:	6a 00                	push   $0x0
  801f3f:	6a 00                	push   $0x0
  801f41:	6a 00                	push   $0x0
  801f43:	6a 00                	push   $0x0
  801f45:	6a 28                	push   $0x28
  801f47:	e8 42 fb ff ff       	call   801a8e <syscall>
  801f4c:	83 c4 18             	add    $0x18,%esp
	return ;
  801f4f:	90                   	nop
}
  801f50:	c9                   	leave  
  801f51:	c3                   	ret    

00801f52 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801f52:	55                   	push   %ebp
  801f53:	89 e5                	mov    %esp,%ebp
  801f55:	83 ec 04             	sub    $0x4,%esp
  801f58:	8b 45 14             	mov    0x14(%ebp),%eax
  801f5b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801f5e:	8b 55 18             	mov    0x18(%ebp),%edx
  801f61:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f65:	52                   	push   %edx
  801f66:	50                   	push   %eax
  801f67:	ff 75 10             	pushl  0x10(%ebp)
  801f6a:	ff 75 0c             	pushl  0xc(%ebp)
  801f6d:	ff 75 08             	pushl  0x8(%ebp)
  801f70:	6a 27                	push   $0x27
  801f72:	e8 17 fb ff ff       	call   801a8e <syscall>
  801f77:	83 c4 18             	add    $0x18,%esp
	return ;
  801f7a:	90                   	nop
}
  801f7b:	c9                   	leave  
  801f7c:	c3                   	ret    

00801f7d <chktst>:
void chktst(uint32 n)
{
  801f7d:	55                   	push   %ebp
  801f7e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801f80:	6a 00                	push   $0x0
  801f82:	6a 00                	push   $0x0
  801f84:	6a 00                	push   $0x0
  801f86:	6a 00                	push   $0x0
  801f88:	ff 75 08             	pushl  0x8(%ebp)
  801f8b:	6a 29                	push   $0x29
  801f8d:	e8 fc fa ff ff       	call   801a8e <syscall>
  801f92:	83 c4 18             	add    $0x18,%esp
	return ;
  801f95:	90                   	nop
}
  801f96:	c9                   	leave  
  801f97:	c3                   	ret    

00801f98 <inctst>:

void inctst()
{
  801f98:	55                   	push   %ebp
  801f99:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801f9b:	6a 00                	push   $0x0
  801f9d:	6a 00                	push   $0x0
  801f9f:	6a 00                	push   $0x0
  801fa1:	6a 00                	push   $0x0
  801fa3:	6a 00                	push   $0x0
  801fa5:	6a 2a                	push   $0x2a
  801fa7:	e8 e2 fa ff ff       	call   801a8e <syscall>
  801fac:	83 c4 18             	add    $0x18,%esp
	return ;
  801faf:	90                   	nop
}
  801fb0:	c9                   	leave  
  801fb1:	c3                   	ret    

00801fb2 <gettst>:
uint32 gettst()
{
  801fb2:	55                   	push   %ebp
  801fb3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801fb5:	6a 00                	push   $0x0
  801fb7:	6a 00                	push   $0x0
  801fb9:	6a 00                	push   $0x0
  801fbb:	6a 00                	push   $0x0
  801fbd:	6a 00                	push   $0x0
  801fbf:	6a 2b                	push   $0x2b
  801fc1:	e8 c8 fa ff ff       	call   801a8e <syscall>
  801fc6:	83 c4 18             	add    $0x18,%esp
}
  801fc9:	c9                   	leave  
  801fca:	c3                   	ret    

00801fcb <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801fcb:	55                   	push   %ebp
  801fcc:	89 e5                	mov    %esp,%ebp
  801fce:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fd1:	6a 00                	push   $0x0
  801fd3:	6a 00                	push   $0x0
  801fd5:	6a 00                	push   $0x0
  801fd7:	6a 00                	push   $0x0
  801fd9:	6a 00                	push   $0x0
  801fdb:	6a 2c                	push   $0x2c
  801fdd:	e8 ac fa ff ff       	call   801a8e <syscall>
  801fe2:	83 c4 18             	add    $0x18,%esp
  801fe5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801fe8:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801fec:	75 07                	jne    801ff5 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801fee:	b8 01 00 00 00       	mov    $0x1,%eax
  801ff3:	eb 05                	jmp    801ffa <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801ff5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ffa:	c9                   	leave  
  801ffb:	c3                   	ret    

00801ffc <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801ffc:	55                   	push   %ebp
  801ffd:	89 e5                	mov    %esp,%ebp
  801fff:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802002:	6a 00                	push   $0x0
  802004:	6a 00                	push   $0x0
  802006:	6a 00                	push   $0x0
  802008:	6a 00                	push   $0x0
  80200a:	6a 00                	push   $0x0
  80200c:	6a 2c                	push   $0x2c
  80200e:	e8 7b fa ff ff       	call   801a8e <syscall>
  802013:	83 c4 18             	add    $0x18,%esp
  802016:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802019:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80201d:	75 07                	jne    802026 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80201f:	b8 01 00 00 00       	mov    $0x1,%eax
  802024:	eb 05                	jmp    80202b <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802026:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80202b:	c9                   	leave  
  80202c:	c3                   	ret    

0080202d <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80202d:	55                   	push   %ebp
  80202e:	89 e5                	mov    %esp,%ebp
  802030:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802033:	6a 00                	push   $0x0
  802035:	6a 00                	push   $0x0
  802037:	6a 00                	push   $0x0
  802039:	6a 00                	push   $0x0
  80203b:	6a 00                	push   $0x0
  80203d:	6a 2c                	push   $0x2c
  80203f:	e8 4a fa ff ff       	call   801a8e <syscall>
  802044:	83 c4 18             	add    $0x18,%esp
  802047:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80204a:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80204e:	75 07                	jne    802057 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802050:	b8 01 00 00 00       	mov    $0x1,%eax
  802055:	eb 05                	jmp    80205c <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802057:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80205c:	c9                   	leave  
  80205d:	c3                   	ret    

0080205e <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80205e:	55                   	push   %ebp
  80205f:	89 e5                	mov    %esp,%ebp
  802061:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802064:	6a 00                	push   $0x0
  802066:	6a 00                	push   $0x0
  802068:	6a 00                	push   $0x0
  80206a:	6a 00                	push   $0x0
  80206c:	6a 00                	push   $0x0
  80206e:	6a 2c                	push   $0x2c
  802070:	e8 19 fa ff ff       	call   801a8e <syscall>
  802075:	83 c4 18             	add    $0x18,%esp
  802078:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80207b:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80207f:	75 07                	jne    802088 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802081:	b8 01 00 00 00       	mov    $0x1,%eax
  802086:	eb 05                	jmp    80208d <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802088:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80208d:	c9                   	leave  
  80208e:	c3                   	ret    

0080208f <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80208f:	55                   	push   %ebp
  802090:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802092:	6a 00                	push   $0x0
  802094:	6a 00                	push   $0x0
  802096:	6a 00                	push   $0x0
  802098:	6a 00                	push   $0x0
  80209a:	ff 75 08             	pushl  0x8(%ebp)
  80209d:	6a 2d                	push   $0x2d
  80209f:	e8 ea f9 ff ff       	call   801a8e <syscall>
  8020a4:	83 c4 18             	add    $0x18,%esp
	return ;
  8020a7:	90                   	nop
}
  8020a8:	c9                   	leave  
  8020a9:	c3                   	ret    

008020aa <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8020aa:	55                   	push   %ebp
  8020ab:	89 e5                	mov    %esp,%ebp
  8020ad:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8020ae:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8020b1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ba:	6a 00                	push   $0x0
  8020bc:	53                   	push   %ebx
  8020bd:	51                   	push   %ecx
  8020be:	52                   	push   %edx
  8020bf:	50                   	push   %eax
  8020c0:	6a 2e                	push   $0x2e
  8020c2:	e8 c7 f9 ff ff       	call   801a8e <syscall>
  8020c7:	83 c4 18             	add    $0x18,%esp
}
  8020ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020cd:	c9                   	leave  
  8020ce:	c3                   	ret    

008020cf <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8020cf:	55                   	push   %ebp
  8020d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8020d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d8:	6a 00                	push   $0x0
  8020da:	6a 00                	push   $0x0
  8020dc:	6a 00                	push   $0x0
  8020de:	52                   	push   %edx
  8020df:	50                   	push   %eax
  8020e0:	6a 2f                	push   $0x2f
  8020e2:	e8 a7 f9 ff ff       	call   801a8e <syscall>
  8020e7:	83 c4 18             	add    $0x18,%esp
}
  8020ea:	c9                   	leave  
  8020eb:	c3                   	ret    

008020ec <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8020ec:	55                   	push   %ebp
  8020ed:	89 e5                	mov    %esp,%ebp
  8020ef:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8020f2:	83 ec 0c             	sub    $0xc,%esp
  8020f5:	68 b8 42 80 00       	push   $0x8042b8
  8020fa:	e8 d3 e8 ff ff       	call   8009d2 <cprintf>
  8020ff:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802102:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802109:	83 ec 0c             	sub    $0xc,%esp
  80210c:	68 e4 42 80 00       	push   $0x8042e4
  802111:	e8 bc e8 ff ff       	call   8009d2 <cprintf>
  802116:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802119:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80211d:	a1 38 51 80 00       	mov    0x805138,%eax
  802122:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802125:	eb 56                	jmp    80217d <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802127:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80212b:	74 1c                	je     802149 <print_mem_block_lists+0x5d>
  80212d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802130:	8b 50 08             	mov    0x8(%eax),%edx
  802133:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802136:	8b 48 08             	mov    0x8(%eax),%ecx
  802139:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80213c:	8b 40 0c             	mov    0xc(%eax),%eax
  80213f:	01 c8                	add    %ecx,%eax
  802141:	39 c2                	cmp    %eax,%edx
  802143:	73 04                	jae    802149 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802145:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802149:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80214c:	8b 50 08             	mov    0x8(%eax),%edx
  80214f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802152:	8b 40 0c             	mov    0xc(%eax),%eax
  802155:	01 c2                	add    %eax,%edx
  802157:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80215a:	8b 40 08             	mov    0x8(%eax),%eax
  80215d:	83 ec 04             	sub    $0x4,%esp
  802160:	52                   	push   %edx
  802161:	50                   	push   %eax
  802162:	68 f9 42 80 00       	push   $0x8042f9
  802167:	e8 66 e8 ff ff       	call   8009d2 <cprintf>
  80216c:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80216f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802172:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802175:	a1 40 51 80 00       	mov    0x805140,%eax
  80217a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80217d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802181:	74 07                	je     80218a <print_mem_block_lists+0x9e>
  802183:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802186:	8b 00                	mov    (%eax),%eax
  802188:	eb 05                	jmp    80218f <print_mem_block_lists+0xa3>
  80218a:	b8 00 00 00 00       	mov    $0x0,%eax
  80218f:	a3 40 51 80 00       	mov    %eax,0x805140
  802194:	a1 40 51 80 00       	mov    0x805140,%eax
  802199:	85 c0                	test   %eax,%eax
  80219b:	75 8a                	jne    802127 <print_mem_block_lists+0x3b>
  80219d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021a1:	75 84                	jne    802127 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8021a3:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8021a7:	75 10                	jne    8021b9 <print_mem_block_lists+0xcd>
  8021a9:	83 ec 0c             	sub    $0xc,%esp
  8021ac:	68 08 43 80 00       	push   $0x804308
  8021b1:	e8 1c e8 ff ff       	call   8009d2 <cprintf>
  8021b6:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8021b9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8021c0:	83 ec 0c             	sub    $0xc,%esp
  8021c3:	68 2c 43 80 00       	push   $0x80432c
  8021c8:	e8 05 e8 ff ff       	call   8009d2 <cprintf>
  8021cd:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8021d0:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8021d4:	a1 40 50 80 00       	mov    0x805040,%eax
  8021d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021dc:	eb 56                	jmp    802234 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8021de:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021e2:	74 1c                	je     802200 <print_mem_block_lists+0x114>
  8021e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e7:	8b 50 08             	mov    0x8(%eax),%edx
  8021ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021ed:	8b 48 08             	mov    0x8(%eax),%ecx
  8021f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021f3:	8b 40 0c             	mov    0xc(%eax),%eax
  8021f6:	01 c8                	add    %ecx,%eax
  8021f8:	39 c2                	cmp    %eax,%edx
  8021fa:	73 04                	jae    802200 <print_mem_block_lists+0x114>
			sorted = 0 ;
  8021fc:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802200:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802203:	8b 50 08             	mov    0x8(%eax),%edx
  802206:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802209:	8b 40 0c             	mov    0xc(%eax),%eax
  80220c:	01 c2                	add    %eax,%edx
  80220e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802211:	8b 40 08             	mov    0x8(%eax),%eax
  802214:	83 ec 04             	sub    $0x4,%esp
  802217:	52                   	push   %edx
  802218:	50                   	push   %eax
  802219:	68 f9 42 80 00       	push   $0x8042f9
  80221e:	e8 af e7 ff ff       	call   8009d2 <cprintf>
  802223:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802226:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802229:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80222c:	a1 48 50 80 00       	mov    0x805048,%eax
  802231:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802234:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802238:	74 07                	je     802241 <print_mem_block_lists+0x155>
  80223a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80223d:	8b 00                	mov    (%eax),%eax
  80223f:	eb 05                	jmp    802246 <print_mem_block_lists+0x15a>
  802241:	b8 00 00 00 00       	mov    $0x0,%eax
  802246:	a3 48 50 80 00       	mov    %eax,0x805048
  80224b:	a1 48 50 80 00       	mov    0x805048,%eax
  802250:	85 c0                	test   %eax,%eax
  802252:	75 8a                	jne    8021de <print_mem_block_lists+0xf2>
  802254:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802258:	75 84                	jne    8021de <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80225a:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80225e:	75 10                	jne    802270 <print_mem_block_lists+0x184>
  802260:	83 ec 0c             	sub    $0xc,%esp
  802263:	68 44 43 80 00       	push   $0x804344
  802268:	e8 65 e7 ff ff       	call   8009d2 <cprintf>
  80226d:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802270:	83 ec 0c             	sub    $0xc,%esp
  802273:	68 b8 42 80 00       	push   $0x8042b8
  802278:	e8 55 e7 ff ff       	call   8009d2 <cprintf>
  80227d:	83 c4 10             	add    $0x10,%esp

}
  802280:	90                   	nop
  802281:	c9                   	leave  
  802282:	c3                   	ret    

00802283 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802283:	55                   	push   %ebp
  802284:	89 e5                	mov    %esp,%ebp
  802286:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  802289:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802290:	00 00 00 
  802293:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80229a:	00 00 00 
  80229d:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8022a4:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  8022a7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8022ae:	e9 9e 00 00 00       	jmp    802351 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  8022b3:	a1 50 50 80 00       	mov    0x805050,%eax
  8022b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022bb:	c1 e2 04             	shl    $0x4,%edx
  8022be:	01 d0                	add    %edx,%eax
  8022c0:	85 c0                	test   %eax,%eax
  8022c2:	75 14                	jne    8022d8 <initialize_MemBlocksList+0x55>
  8022c4:	83 ec 04             	sub    $0x4,%esp
  8022c7:	68 6c 43 80 00       	push   $0x80436c
  8022cc:	6a 46                	push   $0x46
  8022ce:	68 8f 43 80 00       	push   $0x80438f
  8022d3:	e8 46 e4 ff ff       	call   80071e <_panic>
  8022d8:	a1 50 50 80 00       	mov    0x805050,%eax
  8022dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022e0:	c1 e2 04             	shl    $0x4,%edx
  8022e3:	01 d0                	add    %edx,%eax
  8022e5:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8022eb:	89 10                	mov    %edx,(%eax)
  8022ed:	8b 00                	mov    (%eax),%eax
  8022ef:	85 c0                	test   %eax,%eax
  8022f1:	74 18                	je     80230b <initialize_MemBlocksList+0x88>
  8022f3:	a1 48 51 80 00       	mov    0x805148,%eax
  8022f8:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8022fe:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802301:	c1 e1 04             	shl    $0x4,%ecx
  802304:	01 ca                	add    %ecx,%edx
  802306:	89 50 04             	mov    %edx,0x4(%eax)
  802309:	eb 12                	jmp    80231d <initialize_MemBlocksList+0x9a>
  80230b:	a1 50 50 80 00       	mov    0x805050,%eax
  802310:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802313:	c1 e2 04             	shl    $0x4,%edx
  802316:	01 d0                	add    %edx,%eax
  802318:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80231d:	a1 50 50 80 00       	mov    0x805050,%eax
  802322:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802325:	c1 e2 04             	shl    $0x4,%edx
  802328:	01 d0                	add    %edx,%eax
  80232a:	a3 48 51 80 00       	mov    %eax,0x805148
  80232f:	a1 50 50 80 00       	mov    0x805050,%eax
  802334:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802337:	c1 e2 04             	shl    $0x4,%edx
  80233a:	01 d0                	add    %edx,%eax
  80233c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802343:	a1 54 51 80 00       	mov    0x805154,%eax
  802348:	40                   	inc    %eax
  802349:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  80234e:	ff 45 f4             	incl   -0xc(%ebp)
  802351:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802354:	3b 45 08             	cmp    0x8(%ebp),%eax
  802357:	0f 82 56 ff ff ff    	jb     8022b3 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  80235d:	90                   	nop
  80235e:	c9                   	leave  
  80235f:	c3                   	ret    

00802360 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802360:	55                   	push   %ebp
  802361:	89 e5                	mov    %esp,%ebp
  802363:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802366:	8b 45 08             	mov    0x8(%ebp),%eax
  802369:	8b 00                	mov    (%eax),%eax
  80236b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80236e:	eb 19                	jmp    802389 <find_block+0x29>
	{
		if(va==point->sva)
  802370:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802373:	8b 40 08             	mov    0x8(%eax),%eax
  802376:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802379:	75 05                	jne    802380 <find_block+0x20>
		   return point;
  80237b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80237e:	eb 36                	jmp    8023b6 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802380:	8b 45 08             	mov    0x8(%ebp),%eax
  802383:	8b 40 08             	mov    0x8(%eax),%eax
  802386:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802389:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80238d:	74 07                	je     802396 <find_block+0x36>
  80238f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802392:	8b 00                	mov    (%eax),%eax
  802394:	eb 05                	jmp    80239b <find_block+0x3b>
  802396:	b8 00 00 00 00       	mov    $0x0,%eax
  80239b:	8b 55 08             	mov    0x8(%ebp),%edx
  80239e:	89 42 08             	mov    %eax,0x8(%edx)
  8023a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a4:	8b 40 08             	mov    0x8(%eax),%eax
  8023a7:	85 c0                	test   %eax,%eax
  8023a9:	75 c5                	jne    802370 <find_block+0x10>
  8023ab:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8023af:	75 bf                	jne    802370 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  8023b1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023b6:	c9                   	leave  
  8023b7:	c3                   	ret    

008023b8 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8023b8:	55                   	push   %ebp
  8023b9:	89 e5                	mov    %esp,%ebp
  8023bb:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  8023be:	a1 40 50 80 00       	mov    0x805040,%eax
  8023c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  8023c6:	a1 44 50 80 00       	mov    0x805044,%eax
  8023cb:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8023ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023d1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8023d4:	74 24                	je     8023fa <insert_sorted_allocList+0x42>
  8023d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d9:	8b 50 08             	mov    0x8(%eax),%edx
  8023dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023df:	8b 40 08             	mov    0x8(%eax),%eax
  8023e2:	39 c2                	cmp    %eax,%edx
  8023e4:	76 14                	jbe    8023fa <insert_sorted_allocList+0x42>
  8023e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e9:	8b 50 08             	mov    0x8(%eax),%edx
  8023ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023ef:	8b 40 08             	mov    0x8(%eax),%eax
  8023f2:	39 c2                	cmp    %eax,%edx
  8023f4:	0f 82 60 01 00 00    	jb     80255a <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8023fa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023fe:	75 65                	jne    802465 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802400:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802404:	75 14                	jne    80241a <insert_sorted_allocList+0x62>
  802406:	83 ec 04             	sub    $0x4,%esp
  802409:	68 6c 43 80 00       	push   $0x80436c
  80240e:	6a 6b                	push   $0x6b
  802410:	68 8f 43 80 00       	push   $0x80438f
  802415:	e8 04 e3 ff ff       	call   80071e <_panic>
  80241a:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802420:	8b 45 08             	mov    0x8(%ebp),%eax
  802423:	89 10                	mov    %edx,(%eax)
  802425:	8b 45 08             	mov    0x8(%ebp),%eax
  802428:	8b 00                	mov    (%eax),%eax
  80242a:	85 c0                	test   %eax,%eax
  80242c:	74 0d                	je     80243b <insert_sorted_allocList+0x83>
  80242e:	a1 40 50 80 00       	mov    0x805040,%eax
  802433:	8b 55 08             	mov    0x8(%ebp),%edx
  802436:	89 50 04             	mov    %edx,0x4(%eax)
  802439:	eb 08                	jmp    802443 <insert_sorted_allocList+0x8b>
  80243b:	8b 45 08             	mov    0x8(%ebp),%eax
  80243e:	a3 44 50 80 00       	mov    %eax,0x805044
  802443:	8b 45 08             	mov    0x8(%ebp),%eax
  802446:	a3 40 50 80 00       	mov    %eax,0x805040
  80244b:	8b 45 08             	mov    0x8(%ebp),%eax
  80244e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802455:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80245a:	40                   	inc    %eax
  80245b:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802460:	e9 dc 01 00 00       	jmp    802641 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802465:	8b 45 08             	mov    0x8(%ebp),%eax
  802468:	8b 50 08             	mov    0x8(%eax),%edx
  80246b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80246e:	8b 40 08             	mov    0x8(%eax),%eax
  802471:	39 c2                	cmp    %eax,%edx
  802473:	77 6c                	ja     8024e1 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802475:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802479:	74 06                	je     802481 <insert_sorted_allocList+0xc9>
  80247b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80247f:	75 14                	jne    802495 <insert_sorted_allocList+0xdd>
  802481:	83 ec 04             	sub    $0x4,%esp
  802484:	68 a8 43 80 00       	push   $0x8043a8
  802489:	6a 6f                	push   $0x6f
  80248b:	68 8f 43 80 00       	push   $0x80438f
  802490:	e8 89 e2 ff ff       	call   80071e <_panic>
  802495:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802498:	8b 50 04             	mov    0x4(%eax),%edx
  80249b:	8b 45 08             	mov    0x8(%ebp),%eax
  80249e:	89 50 04             	mov    %edx,0x4(%eax)
  8024a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024a7:	89 10                	mov    %edx,(%eax)
  8024a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024ac:	8b 40 04             	mov    0x4(%eax),%eax
  8024af:	85 c0                	test   %eax,%eax
  8024b1:	74 0d                	je     8024c0 <insert_sorted_allocList+0x108>
  8024b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024b6:	8b 40 04             	mov    0x4(%eax),%eax
  8024b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8024bc:	89 10                	mov    %edx,(%eax)
  8024be:	eb 08                	jmp    8024c8 <insert_sorted_allocList+0x110>
  8024c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c3:	a3 40 50 80 00       	mov    %eax,0x805040
  8024c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024cb:	8b 55 08             	mov    0x8(%ebp),%edx
  8024ce:	89 50 04             	mov    %edx,0x4(%eax)
  8024d1:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8024d6:	40                   	inc    %eax
  8024d7:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8024dc:	e9 60 01 00 00       	jmp    802641 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8024e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e4:	8b 50 08             	mov    0x8(%eax),%edx
  8024e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024ea:	8b 40 08             	mov    0x8(%eax),%eax
  8024ed:	39 c2                	cmp    %eax,%edx
  8024ef:	0f 82 4c 01 00 00    	jb     802641 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8024f5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024f9:	75 14                	jne    80250f <insert_sorted_allocList+0x157>
  8024fb:	83 ec 04             	sub    $0x4,%esp
  8024fe:	68 e0 43 80 00       	push   $0x8043e0
  802503:	6a 73                	push   $0x73
  802505:	68 8f 43 80 00       	push   $0x80438f
  80250a:	e8 0f e2 ff ff       	call   80071e <_panic>
  80250f:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802515:	8b 45 08             	mov    0x8(%ebp),%eax
  802518:	89 50 04             	mov    %edx,0x4(%eax)
  80251b:	8b 45 08             	mov    0x8(%ebp),%eax
  80251e:	8b 40 04             	mov    0x4(%eax),%eax
  802521:	85 c0                	test   %eax,%eax
  802523:	74 0c                	je     802531 <insert_sorted_allocList+0x179>
  802525:	a1 44 50 80 00       	mov    0x805044,%eax
  80252a:	8b 55 08             	mov    0x8(%ebp),%edx
  80252d:	89 10                	mov    %edx,(%eax)
  80252f:	eb 08                	jmp    802539 <insert_sorted_allocList+0x181>
  802531:	8b 45 08             	mov    0x8(%ebp),%eax
  802534:	a3 40 50 80 00       	mov    %eax,0x805040
  802539:	8b 45 08             	mov    0x8(%ebp),%eax
  80253c:	a3 44 50 80 00       	mov    %eax,0x805044
  802541:	8b 45 08             	mov    0x8(%ebp),%eax
  802544:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80254a:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80254f:	40                   	inc    %eax
  802550:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802555:	e9 e7 00 00 00       	jmp    802641 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  80255a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80255d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802560:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802567:	a1 40 50 80 00       	mov    0x805040,%eax
  80256c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80256f:	e9 9d 00 00 00       	jmp    802611 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802574:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802577:	8b 00                	mov    (%eax),%eax
  802579:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  80257c:	8b 45 08             	mov    0x8(%ebp),%eax
  80257f:	8b 50 08             	mov    0x8(%eax),%edx
  802582:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802585:	8b 40 08             	mov    0x8(%eax),%eax
  802588:	39 c2                	cmp    %eax,%edx
  80258a:	76 7d                	jbe    802609 <insert_sorted_allocList+0x251>
  80258c:	8b 45 08             	mov    0x8(%ebp),%eax
  80258f:	8b 50 08             	mov    0x8(%eax),%edx
  802592:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802595:	8b 40 08             	mov    0x8(%eax),%eax
  802598:	39 c2                	cmp    %eax,%edx
  80259a:	73 6d                	jae    802609 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  80259c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025a0:	74 06                	je     8025a8 <insert_sorted_allocList+0x1f0>
  8025a2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8025a6:	75 14                	jne    8025bc <insert_sorted_allocList+0x204>
  8025a8:	83 ec 04             	sub    $0x4,%esp
  8025ab:	68 04 44 80 00       	push   $0x804404
  8025b0:	6a 7f                	push   $0x7f
  8025b2:	68 8f 43 80 00       	push   $0x80438f
  8025b7:	e8 62 e1 ff ff       	call   80071e <_panic>
  8025bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bf:	8b 10                	mov    (%eax),%edx
  8025c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c4:	89 10                	mov    %edx,(%eax)
  8025c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c9:	8b 00                	mov    (%eax),%eax
  8025cb:	85 c0                	test   %eax,%eax
  8025cd:	74 0b                	je     8025da <insert_sorted_allocList+0x222>
  8025cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d2:	8b 00                	mov    (%eax),%eax
  8025d4:	8b 55 08             	mov    0x8(%ebp),%edx
  8025d7:	89 50 04             	mov    %edx,0x4(%eax)
  8025da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025dd:	8b 55 08             	mov    0x8(%ebp),%edx
  8025e0:	89 10                	mov    %edx,(%eax)
  8025e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025e8:	89 50 04             	mov    %edx,0x4(%eax)
  8025eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ee:	8b 00                	mov    (%eax),%eax
  8025f0:	85 c0                	test   %eax,%eax
  8025f2:	75 08                	jne    8025fc <insert_sorted_allocList+0x244>
  8025f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f7:	a3 44 50 80 00       	mov    %eax,0x805044
  8025fc:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802601:	40                   	inc    %eax
  802602:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802607:	eb 39                	jmp    802642 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802609:	a1 48 50 80 00       	mov    0x805048,%eax
  80260e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802611:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802615:	74 07                	je     80261e <insert_sorted_allocList+0x266>
  802617:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261a:	8b 00                	mov    (%eax),%eax
  80261c:	eb 05                	jmp    802623 <insert_sorted_allocList+0x26b>
  80261e:	b8 00 00 00 00       	mov    $0x0,%eax
  802623:	a3 48 50 80 00       	mov    %eax,0x805048
  802628:	a1 48 50 80 00       	mov    0x805048,%eax
  80262d:	85 c0                	test   %eax,%eax
  80262f:	0f 85 3f ff ff ff    	jne    802574 <insert_sorted_allocList+0x1bc>
  802635:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802639:	0f 85 35 ff ff ff    	jne    802574 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80263f:	eb 01                	jmp    802642 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802641:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802642:	90                   	nop
  802643:	c9                   	leave  
  802644:	c3                   	ret    

00802645 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802645:	55                   	push   %ebp
  802646:	89 e5                	mov    %esp,%ebp
  802648:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80264b:	a1 38 51 80 00       	mov    0x805138,%eax
  802650:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802653:	e9 85 01 00 00       	jmp    8027dd <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802658:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265b:	8b 40 0c             	mov    0xc(%eax),%eax
  80265e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802661:	0f 82 6e 01 00 00    	jb     8027d5 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802667:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266a:	8b 40 0c             	mov    0xc(%eax),%eax
  80266d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802670:	0f 85 8a 00 00 00    	jne    802700 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802676:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80267a:	75 17                	jne    802693 <alloc_block_FF+0x4e>
  80267c:	83 ec 04             	sub    $0x4,%esp
  80267f:	68 38 44 80 00       	push   $0x804438
  802684:	68 93 00 00 00       	push   $0x93
  802689:	68 8f 43 80 00       	push   $0x80438f
  80268e:	e8 8b e0 ff ff       	call   80071e <_panic>
  802693:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802696:	8b 00                	mov    (%eax),%eax
  802698:	85 c0                	test   %eax,%eax
  80269a:	74 10                	je     8026ac <alloc_block_FF+0x67>
  80269c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269f:	8b 00                	mov    (%eax),%eax
  8026a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026a4:	8b 52 04             	mov    0x4(%edx),%edx
  8026a7:	89 50 04             	mov    %edx,0x4(%eax)
  8026aa:	eb 0b                	jmp    8026b7 <alloc_block_FF+0x72>
  8026ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026af:	8b 40 04             	mov    0x4(%eax),%eax
  8026b2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8026b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ba:	8b 40 04             	mov    0x4(%eax),%eax
  8026bd:	85 c0                	test   %eax,%eax
  8026bf:	74 0f                	je     8026d0 <alloc_block_FF+0x8b>
  8026c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c4:	8b 40 04             	mov    0x4(%eax),%eax
  8026c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026ca:	8b 12                	mov    (%edx),%edx
  8026cc:	89 10                	mov    %edx,(%eax)
  8026ce:	eb 0a                	jmp    8026da <alloc_block_FF+0x95>
  8026d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d3:	8b 00                	mov    (%eax),%eax
  8026d5:	a3 38 51 80 00       	mov    %eax,0x805138
  8026da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026dd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026ed:	a1 44 51 80 00       	mov    0x805144,%eax
  8026f2:	48                   	dec    %eax
  8026f3:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  8026f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fb:	e9 10 01 00 00       	jmp    802810 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802700:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802703:	8b 40 0c             	mov    0xc(%eax),%eax
  802706:	3b 45 08             	cmp    0x8(%ebp),%eax
  802709:	0f 86 c6 00 00 00    	jbe    8027d5 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80270f:	a1 48 51 80 00       	mov    0x805148,%eax
  802714:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802717:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271a:	8b 50 08             	mov    0x8(%eax),%edx
  80271d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802720:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802723:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802726:	8b 55 08             	mov    0x8(%ebp),%edx
  802729:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80272c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802730:	75 17                	jne    802749 <alloc_block_FF+0x104>
  802732:	83 ec 04             	sub    $0x4,%esp
  802735:	68 38 44 80 00       	push   $0x804438
  80273a:	68 9b 00 00 00       	push   $0x9b
  80273f:	68 8f 43 80 00       	push   $0x80438f
  802744:	e8 d5 df ff ff       	call   80071e <_panic>
  802749:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80274c:	8b 00                	mov    (%eax),%eax
  80274e:	85 c0                	test   %eax,%eax
  802750:	74 10                	je     802762 <alloc_block_FF+0x11d>
  802752:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802755:	8b 00                	mov    (%eax),%eax
  802757:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80275a:	8b 52 04             	mov    0x4(%edx),%edx
  80275d:	89 50 04             	mov    %edx,0x4(%eax)
  802760:	eb 0b                	jmp    80276d <alloc_block_FF+0x128>
  802762:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802765:	8b 40 04             	mov    0x4(%eax),%eax
  802768:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80276d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802770:	8b 40 04             	mov    0x4(%eax),%eax
  802773:	85 c0                	test   %eax,%eax
  802775:	74 0f                	je     802786 <alloc_block_FF+0x141>
  802777:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80277a:	8b 40 04             	mov    0x4(%eax),%eax
  80277d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802780:	8b 12                	mov    (%edx),%edx
  802782:	89 10                	mov    %edx,(%eax)
  802784:	eb 0a                	jmp    802790 <alloc_block_FF+0x14b>
  802786:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802789:	8b 00                	mov    (%eax),%eax
  80278b:	a3 48 51 80 00       	mov    %eax,0x805148
  802790:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802793:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802799:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80279c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027a3:	a1 54 51 80 00       	mov    0x805154,%eax
  8027a8:	48                   	dec    %eax
  8027a9:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  8027ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b1:	8b 50 08             	mov    0x8(%eax),%edx
  8027b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b7:	01 c2                	add    %eax,%edx
  8027b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027bc:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8027bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c2:	8b 40 0c             	mov    0xc(%eax),%eax
  8027c5:	2b 45 08             	sub    0x8(%ebp),%eax
  8027c8:	89 c2                	mov    %eax,%edx
  8027ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cd:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8027d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027d3:	eb 3b                	jmp    802810 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8027d5:	a1 40 51 80 00       	mov    0x805140,%eax
  8027da:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027e1:	74 07                	je     8027ea <alloc_block_FF+0x1a5>
  8027e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e6:	8b 00                	mov    (%eax),%eax
  8027e8:	eb 05                	jmp    8027ef <alloc_block_FF+0x1aa>
  8027ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8027ef:	a3 40 51 80 00       	mov    %eax,0x805140
  8027f4:	a1 40 51 80 00       	mov    0x805140,%eax
  8027f9:	85 c0                	test   %eax,%eax
  8027fb:	0f 85 57 fe ff ff    	jne    802658 <alloc_block_FF+0x13>
  802801:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802805:	0f 85 4d fe ff ff    	jne    802658 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  80280b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802810:	c9                   	leave  
  802811:	c3                   	ret    

00802812 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802812:	55                   	push   %ebp
  802813:	89 e5                	mov    %esp,%ebp
  802815:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802818:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80281f:	a1 38 51 80 00       	mov    0x805138,%eax
  802824:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802827:	e9 df 00 00 00       	jmp    80290b <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  80282c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282f:	8b 40 0c             	mov    0xc(%eax),%eax
  802832:	3b 45 08             	cmp    0x8(%ebp),%eax
  802835:	0f 82 c8 00 00 00    	jb     802903 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  80283b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283e:	8b 40 0c             	mov    0xc(%eax),%eax
  802841:	3b 45 08             	cmp    0x8(%ebp),%eax
  802844:	0f 85 8a 00 00 00    	jne    8028d4 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  80284a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80284e:	75 17                	jne    802867 <alloc_block_BF+0x55>
  802850:	83 ec 04             	sub    $0x4,%esp
  802853:	68 38 44 80 00       	push   $0x804438
  802858:	68 b7 00 00 00       	push   $0xb7
  80285d:	68 8f 43 80 00       	push   $0x80438f
  802862:	e8 b7 de ff ff       	call   80071e <_panic>
  802867:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286a:	8b 00                	mov    (%eax),%eax
  80286c:	85 c0                	test   %eax,%eax
  80286e:	74 10                	je     802880 <alloc_block_BF+0x6e>
  802870:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802873:	8b 00                	mov    (%eax),%eax
  802875:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802878:	8b 52 04             	mov    0x4(%edx),%edx
  80287b:	89 50 04             	mov    %edx,0x4(%eax)
  80287e:	eb 0b                	jmp    80288b <alloc_block_BF+0x79>
  802880:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802883:	8b 40 04             	mov    0x4(%eax),%eax
  802886:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80288b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288e:	8b 40 04             	mov    0x4(%eax),%eax
  802891:	85 c0                	test   %eax,%eax
  802893:	74 0f                	je     8028a4 <alloc_block_BF+0x92>
  802895:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802898:	8b 40 04             	mov    0x4(%eax),%eax
  80289b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80289e:	8b 12                	mov    (%edx),%edx
  8028a0:	89 10                	mov    %edx,(%eax)
  8028a2:	eb 0a                	jmp    8028ae <alloc_block_BF+0x9c>
  8028a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a7:	8b 00                	mov    (%eax),%eax
  8028a9:	a3 38 51 80 00       	mov    %eax,0x805138
  8028ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ba:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028c1:	a1 44 51 80 00       	mov    0x805144,%eax
  8028c6:	48                   	dec    %eax
  8028c7:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  8028cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cf:	e9 4d 01 00 00       	jmp    802a21 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8028d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d7:	8b 40 0c             	mov    0xc(%eax),%eax
  8028da:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028dd:	76 24                	jbe    802903 <alloc_block_BF+0xf1>
  8028df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8028e5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8028e8:	73 19                	jae    802903 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8028ea:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8028f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f4:	8b 40 0c             	mov    0xc(%eax),%eax
  8028f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8028fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fd:	8b 40 08             	mov    0x8(%eax),%eax
  802900:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802903:	a1 40 51 80 00       	mov    0x805140,%eax
  802908:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80290b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80290f:	74 07                	je     802918 <alloc_block_BF+0x106>
  802911:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802914:	8b 00                	mov    (%eax),%eax
  802916:	eb 05                	jmp    80291d <alloc_block_BF+0x10b>
  802918:	b8 00 00 00 00       	mov    $0x0,%eax
  80291d:	a3 40 51 80 00       	mov    %eax,0x805140
  802922:	a1 40 51 80 00       	mov    0x805140,%eax
  802927:	85 c0                	test   %eax,%eax
  802929:	0f 85 fd fe ff ff    	jne    80282c <alloc_block_BF+0x1a>
  80292f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802933:	0f 85 f3 fe ff ff    	jne    80282c <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802939:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80293d:	0f 84 d9 00 00 00    	je     802a1c <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802943:	a1 48 51 80 00       	mov    0x805148,%eax
  802948:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  80294b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80294e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802951:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802954:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802957:	8b 55 08             	mov    0x8(%ebp),%edx
  80295a:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  80295d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802961:	75 17                	jne    80297a <alloc_block_BF+0x168>
  802963:	83 ec 04             	sub    $0x4,%esp
  802966:	68 38 44 80 00       	push   $0x804438
  80296b:	68 c7 00 00 00       	push   $0xc7
  802970:	68 8f 43 80 00       	push   $0x80438f
  802975:	e8 a4 dd ff ff       	call   80071e <_panic>
  80297a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80297d:	8b 00                	mov    (%eax),%eax
  80297f:	85 c0                	test   %eax,%eax
  802981:	74 10                	je     802993 <alloc_block_BF+0x181>
  802983:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802986:	8b 00                	mov    (%eax),%eax
  802988:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80298b:	8b 52 04             	mov    0x4(%edx),%edx
  80298e:	89 50 04             	mov    %edx,0x4(%eax)
  802991:	eb 0b                	jmp    80299e <alloc_block_BF+0x18c>
  802993:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802996:	8b 40 04             	mov    0x4(%eax),%eax
  802999:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80299e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029a1:	8b 40 04             	mov    0x4(%eax),%eax
  8029a4:	85 c0                	test   %eax,%eax
  8029a6:	74 0f                	je     8029b7 <alloc_block_BF+0x1a5>
  8029a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029ab:	8b 40 04             	mov    0x4(%eax),%eax
  8029ae:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8029b1:	8b 12                	mov    (%edx),%edx
  8029b3:	89 10                	mov    %edx,(%eax)
  8029b5:	eb 0a                	jmp    8029c1 <alloc_block_BF+0x1af>
  8029b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029ba:	8b 00                	mov    (%eax),%eax
  8029bc:	a3 48 51 80 00       	mov    %eax,0x805148
  8029c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029c4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029cd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029d4:	a1 54 51 80 00       	mov    0x805154,%eax
  8029d9:	48                   	dec    %eax
  8029da:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8029df:	83 ec 08             	sub    $0x8,%esp
  8029e2:	ff 75 ec             	pushl  -0x14(%ebp)
  8029e5:	68 38 51 80 00       	push   $0x805138
  8029ea:	e8 71 f9 ff ff       	call   802360 <find_block>
  8029ef:	83 c4 10             	add    $0x10,%esp
  8029f2:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8029f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029f8:	8b 50 08             	mov    0x8(%eax),%edx
  8029fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8029fe:	01 c2                	add    %eax,%edx
  802a00:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a03:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802a06:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a09:	8b 40 0c             	mov    0xc(%eax),%eax
  802a0c:	2b 45 08             	sub    0x8(%ebp),%eax
  802a0f:	89 c2                	mov    %eax,%edx
  802a11:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a14:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802a17:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a1a:	eb 05                	jmp    802a21 <alloc_block_BF+0x20f>
	}
	return NULL;
  802a1c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a21:	c9                   	leave  
  802a22:	c3                   	ret    

00802a23 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802a23:	55                   	push   %ebp
  802a24:	89 e5                	mov    %esp,%ebp
  802a26:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802a29:	a1 28 50 80 00       	mov    0x805028,%eax
  802a2e:	85 c0                	test   %eax,%eax
  802a30:	0f 85 de 01 00 00    	jne    802c14 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802a36:	a1 38 51 80 00       	mov    0x805138,%eax
  802a3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a3e:	e9 9e 01 00 00       	jmp    802be1 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802a43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a46:	8b 40 0c             	mov    0xc(%eax),%eax
  802a49:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a4c:	0f 82 87 01 00 00    	jb     802bd9 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802a52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a55:	8b 40 0c             	mov    0xc(%eax),%eax
  802a58:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a5b:	0f 85 95 00 00 00    	jne    802af6 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802a61:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a65:	75 17                	jne    802a7e <alloc_block_NF+0x5b>
  802a67:	83 ec 04             	sub    $0x4,%esp
  802a6a:	68 38 44 80 00       	push   $0x804438
  802a6f:	68 e0 00 00 00       	push   $0xe0
  802a74:	68 8f 43 80 00       	push   $0x80438f
  802a79:	e8 a0 dc ff ff       	call   80071e <_panic>
  802a7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a81:	8b 00                	mov    (%eax),%eax
  802a83:	85 c0                	test   %eax,%eax
  802a85:	74 10                	je     802a97 <alloc_block_NF+0x74>
  802a87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8a:	8b 00                	mov    (%eax),%eax
  802a8c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a8f:	8b 52 04             	mov    0x4(%edx),%edx
  802a92:	89 50 04             	mov    %edx,0x4(%eax)
  802a95:	eb 0b                	jmp    802aa2 <alloc_block_NF+0x7f>
  802a97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9a:	8b 40 04             	mov    0x4(%eax),%eax
  802a9d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802aa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa5:	8b 40 04             	mov    0x4(%eax),%eax
  802aa8:	85 c0                	test   %eax,%eax
  802aaa:	74 0f                	je     802abb <alloc_block_NF+0x98>
  802aac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aaf:	8b 40 04             	mov    0x4(%eax),%eax
  802ab2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ab5:	8b 12                	mov    (%edx),%edx
  802ab7:	89 10                	mov    %edx,(%eax)
  802ab9:	eb 0a                	jmp    802ac5 <alloc_block_NF+0xa2>
  802abb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802abe:	8b 00                	mov    (%eax),%eax
  802ac0:	a3 38 51 80 00       	mov    %eax,0x805138
  802ac5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ace:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ad8:	a1 44 51 80 00       	mov    0x805144,%eax
  802add:	48                   	dec    %eax
  802ade:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802ae3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae6:	8b 40 08             	mov    0x8(%eax),%eax
  802ae9:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802aee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af1:	e9 f8 04 00 00       	jmp    802fee <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802af6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af9:	8b 40 0c             	mov    0xc(%eax),%eax
  802afc:	3b 45 08             	cmp    0x8(%ebp),%eax
  802aff:	0f 86 d4 00 00 00    	jbe    802bd9 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b05:	a1 48 51 80 00       	mov    0x805148,%eax
  802b0a:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802b0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b10:	8b 50 08             	mov    0x8(%eax),%edx
  802b13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b16:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802b19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b1c:	8b 55 08             	mov    0x8(%ebp),%edx
  802b1f:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802b22:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b26:	75 17                	jne    802b3f <alloc_block_NF+0x11c>
  802b28:	83 ec 04             	sub    $0x4,%esp
  802b2b:	68 38 44 80 00       	push   $0x804438
  802b30:	68 e9 00 00 00       	push   $0xe9
  802b35:	68 8f 43 80 00       	push   $0x80438f
  802b3a:	e8 df db ff ff       	call   80071e <_panic>
  802b3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b42:	8b 00                	mov    (%eax),%eax
  802b44:	85 c0                	test   %eax,%eax
  802b46:	74 10                	je     802b58 <alloc_block_NF+0x135>
  802b48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b4b:	8b 00                	mov    (%eax),%eax
  802b4d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b50:	8b 52 04             	mov    0x4(%edx),%edx
  802b53:	89 50 04             	mov    %edx,0x4(%eax)
  802b56:	eb 0b                	jmp    802b63 <alloc_block_NF+0x140>
  802b58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b5b:	8b 40 04             	mov    0x4(%eax),%eax
  802b5e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b66:	8b 40 04             	mov    0x4(%eax),%eax
  802b69:	85 c0                	test   %eax,%eax
  802b6b:	74 0f                	je     802b7c <alloc_block_NF+0x159>
  802b6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b70:	8b 40 04             	mov    0x4(%eax),%eax
  802b73:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b76:	8b 12                	mov    (%edx),%edx
  802b78:	89 10                	mov    %edx,(%eax)
  802b7a:	eb 0a                	jmp    802b86 <alloc_block_NF+0x163>
  802b7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b7f:	8b 00                	mov    (%eax),%eax
  802b81:	a3 48 51 80 00       	mov    %eax,0x805148
  802b86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b89:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b92:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b99:	a1 54 51 80 00       	mov    0x805154,%eax
  802b9e:	48                   	dec    %eax
  802b9f:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802ba4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba7:	8b 40 08             	mov    0x8(%eax),%eax
  802baa:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802baf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb2:	8b 50 08             	mov    0x8(%eax),%edx
  802bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb8:	01 c2                	add    %eax,%edx
  802bba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bbd:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802bc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc3:	8b 40 0c             	mov    0xc(%eax),%eax
  802bc6:	2b 45 08             	sub    0x8(%ebp),%eax
  802bc9:	89 c2                	mov    %eax,%edx
  802bcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bce:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802bd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bd4:	e9 15 04 00 00       	jmp    802fee <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802bd9:	a1 40 51 80 00       	mov    0x805140,%eax
  802bde:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802be1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802be5:	74 07                	je     802bee <alloc_block_NF+0x1cb>
  802be7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bea:	8b 00                	mov    (%eax),%eax
  802bec:	eb 05                	jmp    802bf3 <alloc_block_NF+0x1d0>
  802bee:	b8 00 00 00 00       	mov    $0x0,%eax
  802bf3:	a3 40 51 80 00       	mov    %eax,0x805140
  802bf8:	a1 40 51 80 00       	mov    0x805140,%eax
  802bfd:	85 c0                	test   %eax,%eax
  802bff:	0f 85 3e fe ff ff    	jne    802a43 <alloc_block_NF+0x20>
  802c05:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c09:	0f 85 34 fe ff ff    	jne    802a43 <alloc_block_NF+0x20>
  802c0f:	e9 d5 03 00 00       	jmp    802fe9 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c14:	a1 38 51 80 00       	mov    0x805138,%eax
  802c19:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c1c:	e9 b1 01 00 00       	jmp    802dd2 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802c21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c24:	8b 50 08             	mov    0x8(%eax),%edx
  802c27:	a1 28 50 80 00       	mov    0x805028,%eax
  802c2c:	39 c2                	cmp    %eax,%edx
  802c2e:	0f 82 96 01 00 00    	jb     802dca <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802c34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c37:	8b 40 0c             	mov    0xc(%eax),%eax
  802c3a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c3d:	0f 82 87 01 00 00    	jb     802dca <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802c43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c46:	8b 40 0c             	mov    0xc(%eax),%eax
  802c49:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c4c:	0f 85 95 00 00 00    	jne    802ce7 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802c52:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c56:	75 17                	jne    802c6f <alloc_block_NF+0x24c>
  802c58:	83 ec 04             	sub    $0x4,%esp
  802c5b:	68 38 44 80 00       	push   $0x804438
  802c60:	68 fc 00 00 00       	push   $0xfc
  802c65:	68 8f 43 80 00       	push   $0x80438f
  802c6a:	e8 af da ff ff       	call   80071e <_panic>
  802c6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c72:	8b 00                	mov    (%eax),%eax
  802c74:	85 c0                	test   %eax,%eax
  802c76:	74 10                	je     802c88 <alloc_block_NF+0x265>
  802c78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7b:	8b 00                	mov    (%eax),%eax
  802c7d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c80:	8b 52 04             	mov    0x4(%edx),%edx
  802c83:	89 50 04             	mov    %edx,0x4(%eax)
  802c86:	eb 0b                	jmp    802c93 <alloc_block_NF+0x270>
  802c88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8b:	8b 40 04             	mov    0x4(%eax),%eax
  802c8e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c96:	8b 40 04             	mov    0x4(%eax),%eax
  802c99:	85 c0                	test   %eax,%eax
  802c9b:	74 0f                	je     802cac <alloc_block_NF+0x289>
  802c9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca0:	8b 40 04             	mov    0x4(%eax),%eax
  802ca3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ca6:	8b 12                	mov    (%edx),%edx
  802ca8:	89 10                	mov    %edx,(%eax)
  802caa:	eb 0a                	jmp    802cb6 <alloc_block_NF+0x293>
  802cac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802caf:	8b 00                	mov    (%eax),%eax
  802cb1:	a3 38 51 80 00       	mov    %eax,0x805138
  802cb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cc9:	a1 44 51 80 00       	mov    0x805144,%eax
  802cce:	48                   	dec    %eax
  802ccf:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802cd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd7:	8b 40 08             	mov    0x8(%eax),%eax
  802cda:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802cdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce2:	e9 07 03 00 00       	jmp    802fee <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802ce7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cea:	8b 40 0c             	mov    0xc(%eax),%eax
  802ced:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cf0:	0f 86 d4 00 00 00    	jbe    802dca <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802cf6:	a1 48 51 80 00       	mov    0x805148,%eax
  802cfb:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802cfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d01:	8b 50 08             	mov    0x8(%eax),%edx
  802d04:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d07:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802d0a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d0d:	8b 55 08             	mov    0x8(%ebp),%edx
  802d10:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802d13:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802d17:	75 17                	jne    802d30 <alloc_block_NF+0x30d>
  802d19:	83 ec 04             	sub    $0x4,%esp
  802d1c:	68 38 44 80 00       	push   $0x804438
  802d21:	68 04 01 00 00       	push   $0x104
  802d26:	68 8f 43 80 00       	push   $0x80438f
  802d2b:	e8 ee d9 ff ff       	call   80071e <_panic>
  802d30:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d33:	8b 00                	mov    (%eax),%eax
  802d35:	85 c0                	test   %eax,%eax
  802d37:	74 10                	je     802d49 <alloc_block_NF+0x326>
  802d39:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d3c:	8b 00                	mov    (%eax),%eax
  802d3e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d41:	8b 52 04             	mov    0x4(%edx),%edx
  802d44:	89 50 04             	mov    %edx,0x4(%eax)
  802d47:	eb 0b                	jmp    802d54 <alloc_block_NF+0x331>
  802d49:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d4c:	8b 40 04             	mov    0x4(%eax),%eax
  802d4f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d54:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d57:	8b 40 04             	mov    0x4(%eax),%eax
  802d5a:	85 c0                	test   %eax,%eax
  802d5c:	74 0f                	je     802d6d <alloc_block_NF+0x34a>
  802d5e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d61:	8b 40 04             	mov    0x4(%eax),%eax
  802d64:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d67:	8b 12                	mov    (%edx),%edx
  802d69:	89 10                	mov    %edx,(%eax)
  802d6b:	eb 0a                	jmp    802d77 <alloc_block_NF+0x354>
  802d6d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d70:	8b 00                	mov    (%eax),%eax
  802d72:	a3 48 51 80 00       	mov    %eax,0x805148
  802d77:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d7a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d80:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d83:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d8a:	a1 54 51 80 00       	mov    0x805154,%eax
  802d8f:	48                   	dec    %eax
  802d90:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802d95:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d98:	8b 40 08             	mov    0x8(%eax),%eax
  802d9b:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802da0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da3:	8b 50 08             	mov    0x8(%eax),%edx
  802da6:	8b 45 08             	mov    0x8(%ebp),%eax
  802da9:	01 c2                	add    %eax,%edx
  802dab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dae:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802db1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db4:	8b 40 0c             	mov    0xc(%eax),%eax
  802db7:	2b 45 08             	sub    0x8(%ebp),%eax
  802dba:	89 c2                	mov    %eax,%edx
  802dbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbf:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802dc2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dc5:	e9 24 02 00 00       	jmp    802fee <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802dca:	a1 40 51 80 00       	mov    0x805140,%eax
  802dcf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802dd2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dd6:	74 07                	je     802ddf <alloc_block_NF+0x3bc>
  802dd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ddb:	8b 00                	mov    (%eax),%eax
  802ddd:	eb 05                	jmp    802de4 <alloc_block_NF+0x3c1>
  802ddf:	b8 00 00 00 00       	mov    $0x0,%eax
  802de4:	a3 40 51 80 00       	mov    %eax,0x805140
  802de9:	a1 40 51 80 00       	mov    0x805140,%eax
  802dee:	85 c0                	test   %eax,%eax
  802df0:	0f 85 2b fe ff ff    	jne    802c21 <alloc_block_NF+0x1fe>
  802df6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dfa:	0f 85 21 fe ff ff    	jne    802c21 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802e00:	a1 38 51 80 00       	mov    0x805138,%eax
  802e05:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e08:	e9 ae 01 00 00       	jmp    802fbb <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802e0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e10:	8b 50 08             	mov    0x8(%eax),%edx
  802e13:	a1 28 50 80 00       	mov    0x805028,%eax
  802e18:	39 c2                	cmp    %eax,%edx
  802e1a:	0f 83 93 01 00 00    	jae    802fb3 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802e20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e23:	8b 40 0c             	mov    0xc(%eax),%eax
  802e26:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e29:	0f 82 84 01 00 00    	jb     802fb3 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802e2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e32:	8b 40 0c             	mov    0xc(%eax),%eax
  802e35:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e38:	0f 85 95 00 00 00    	jne    802ed3 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802e3e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e42:	75 17                	jne    802e5b <alloc_block_NF+0x438>
  802e44:	83 ec 04             	sub    $0x4,%esp
  802e47:	68 38 44 80 00       	push   $0x804438
  802e4c:	68 14 01 00 00       	push   $0x114
  802e51:	68 8f 43 80 00       	push   $0x80438f
  802e56:	e8 c3 d8 ff ff       	call   80071e <_panic>
  802e5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5e:	8b 00                	mov    (%eax),%eax
  802e60:	85 c0                	test   %eax,%eax
  802e62:	74 10                	je     802e74 <alloc_block_NF+0x451>
  802e64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e67:	8b 00                	mov    (%eax),%eax
  802e69:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e6c:	8b 52 04             	mov    0x4(%edx),%edx
  802e6f:	89 50 04             	mov    %edx,0x4(%eax)
  802e72:	eb 0b                	jmp    802e7f <alloc_block_NF+0x45c>
  802e74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e77:	8b 40 04             	mov    0x4(%eax),%eax
  802e7a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e82:	8b 40 04             	mov    0x4(%eax),%eax
  802e85:	85 c0                	test   %eax,%eax
  802e87:	74 0f                	je     802e98 <alloc_block_NF+0x475>
  802e89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8c:	8b 40 04             	mov    0x4(%eax),%eax
  802e8f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e92:	8b 12                	mov    (%edx),%edx
  802e94:	89 10                	mov    %edx,(%eax)
  802e96:	eb 0a                	jmp    802ea2 <alloc_block_NF+0x47f>
  802e98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9b:	8b 00                	mov    (%eax),%eax
  802e9d:	a3 38 51 80 00       	mov    %eax,0x805138
  802ea2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802eab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eb5:	a1 44 51 80 00       	mov    0x805144,%eax
  802eba:	48                   	dec    %eax
  802ebb:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802ec0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec3:	8b 40 08             	mov    0x8(%eax),%eax
  802ec6:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802ecb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ece:	e9 1b 01 00 00       	jmp    802fee <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802ed3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed6:	8b 40 0c             	mov    0xc(%eax),%eax
  802ed9:	3b 45 08             	cmp    0x8(%ebp),%eax
  802edc:	0f 86 d1 00 00 00    	jbe    802fb3 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802ee2:	a1 48 51 80 00       	mov    0x805148,%eax
  802ee7:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802eea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eed:	8b 50 08             	mov    0x8(%eax),%edx
  802ef0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ef3:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802ef6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ef9:	8b 55 08             	mov    0x8(%ebp),%edx
  802efc:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802eff:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802f03:	75 17                	jne    802f1c <alloc_block_NF+0x4f9>
  802f05:	83 ec 04             	sub    $0x4,%esp
  802f08:	68 38 44 80 00       	push   $0x804438
  802f0d:	68 1c 01 00 00       	push   $0x11c
  802f12:	68 8f 43 80 00       	push   $0x80438f
  802f17:	e8 02 d8 ff ff       	call   80071e <_panic>
  802f1c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f1f:	8b 00                	mov    (%eax),%eax
  802f21:	85 c0                	test   %eax,%eax
  802f23:	74 10                	je     802f35 <alloc_block_NF+0x512>
  802f25:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f28:	8b 00                	mov    (%eax),%eax
  802f2a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f2d:	8b 52 04             	mov    0x4(%edx),%edx
  802f30:	89 50 04             	mov    %edx,0x4(%eax)
  802f33:	eb 0b                	jmp    802f40 <alloc_block_NF+0x51d>
  802f35:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f38:	8b 40 04             	mov    0x4(%eax),%eax
  802f3b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f40:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f43:	8b 40 04             	mov    0x4(%eax),%eax
  802f46:	85 c0                	test   %eax,%eax
  802f48:	74 0f                	je     802f59 <alloc_block_NF+0x536>
  802f4a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f4d:	8b 40 04             	mov    0x4(%eax),%eax
  802f50:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f53:	8b 12                	mov    (%edx),%edx
  802f55:	89 10                	mov    %edx,(%eax)
  802f57:	eb 0a                	jmp    802f63 <alloc_block_NF+0x540>
  802f59:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f5c:	8b 00                	mov    (%eax),%eax
  802f5e:	a3 48 51 80 00       	mov    %eax,0x805148
  802f63:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f66:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f6f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f76:	a1 54 51 80 00       	mov    0x805154,%eax
  802f7b:	48                   	dec    %eax
  802f7c:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802f81:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f84:	8b 40 08             	mov    0x8(%eax),%eax
  802f87:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802f8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8f:	8b 50 08             	mov    0x8(%eax),%edx
  802f92:	8b 45 08             	mov    0x8(%ebp),%eax
  802f95:	01 c2                	add    %eax,%edx
  802f97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f9a:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802f9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa0:	8b 40 0c             	mov    0xc(%eax),%eax
  802fa3:	2b 45 08             	sub    0x8(%ebp),%eax
  802fa6:	89 c2                	mov    %eax,%edx
  802fa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fab:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802fae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fb1:	eb 3b                	jmp    802fee <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802fb3:	a1 40 51 80 00       	mov    0x805140,%eax
  802fb8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fbb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fbf:	74 07                	je     802fc8 <alloc_block_NF+0x5a5>
  802fc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc4:	8b 00                	mov    (%eax),%eax
  802fc6:	eb 05                	jmp    802fcd <alloc_block_NF+0x5aa>
  802fc8:	b8 00 00 00 00       	mov    $0x0,%eax
  802fcd:	a3 40 51 80 00       	mov    %eax,0x805140
  802fd2:	a1 40 51 80 00       	mov    0x805140,%eax
  802fd7:	85 c0                	test   %eax,%eax
  802fd9:	0f 85 2e fe ff ff    	jne    802e0d <alloc_block_NF+0x3ea>
  802fdf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fe3:	0f 85 24 fe ff ff    	jne    802e0d <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802fe9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802fee:	c9                   	leave  
  802fef:	c3                   	ret    

00802ff0 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802ff0:	55                   	push   %ebp
  802ff1:	89 e5                	mov    %esp,%ebp
  802ff3:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802ff6:	a1 38 51 80 00       	mov    0x805138,%eax
  802ffb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802ffe:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803003:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  803006:	a1 38 51 80 00       	mov    0x805138,%eax
  80300b:	85 c0                	test   %eax,%eax
  80300d:	74 14                	je     803023 <insert_sorted_with_merge_freeList+0x33>
  80300f:	8b 45 08             	mov    0x8(%ebp),%eax
  803012:	8b 50 08             	mov    0x8(%eax),%edx
  803015:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803018:	8b 40 08             	mov    0x8(%eax),%eax
  80301b:	39 c2                	cmp    %eax,%edx
  80301d:	0f 87 9b 01 00 00    	ja     8031be <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  803023:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803027:	75 17                	jne    803040 <insert_sorted_with_merge_freeList+0x50>
  803029:	83 ec 04             	sub    $0x4,%esp
  80302c:	68 6c 43 80 00       	push   $0x80436c
  803031:	68 38 01 00 00       	push   $0x138
  803036:	68 8f 43 80 00       	push   $0x80438f
  80303b:	e8 de d6 ff ff       	call   80071e <_panic>
  803040:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803046:	8b 45 08             	mov    0x8(%ebp),%eax
  803049:	89 10                	mov    %edx,(%eax)
  80304b:	8b 45 08             	mov    0x8(%ebp),%eax
  80304e:	8b 00                	mov    (%eax),%eax
  803050:	85 c0                	test   %eax,%eax
  803052:	74 0d                	je     803061 <insert_sorted_with_merge_freeList+0x71>
  803054:	a1 38 51 80 00       	mov    0x805138,%eax
  803059:	8b 55 08             	mov    0x8(%ebp),%edx
  80305c:	89 50 04             	mov    %edx,0x4(%eax)
  80305f:	eb 08                	jmp    803069 <insert_sorted_with_merge_freeList+0x79>
  803061:	8b 45 08             	mov    0x8(%ebp),%eax
  803064:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803069:	8b 45 08             	mov    0x8(%ebp),%eax
  80306c:	a3 38 51 80 00       	mov    %eax,0x805138
  803071:	8b 45 08             	mov    0x8(%ebp),%eax
  803074:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80307b:	a1 44 51 80 00       	mov    0x805144,%eax
  803080:	40                   	inc    %eax
  803081:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803086:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80308a:	0f 84 a8 06 00 00    	je     803738 <insert_sorted_with_merge_freeList+0x748>
  803090:	8b 45 08             	mov    0x8(%ebp),%eax
  803093:	8b 50 08             	mov    0x8(%eax),%edx
  803096:	8b 45 08             	mov    0x8(%ebp),%eax
  803099:	8b 40 0c             	mov    0xc(%eax),%eax
  80309c:	01 c2                	add    %eax,%edx
  80309e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030a1:	8b 40 08             	mov    0x8(%eax),%eax
  8030a4:	39 c2                	cmp    %eax,%edx
  8030a6:	0f 85 8c 06 00 00    	jne    803738 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  8030ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8030af:	8b 50 0c             	mov    0xc(%eax),%edx
  8030b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030b5:	8b 40 0c             	mov    0xc(%eax),%eax
  8030b8:	01 c2                	add    %eax,%edx
  8030ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8030bd:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  8030c0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8030c4:	75 17                	jne    8030dd <insert_sorted_with_merge_freeList+0xed>
  8030c6:	83 ec 04             	sub    $0x4,%esp
  8030c9:	68 38 44 80 00       	push   $0x804438
  8030ce:	68 3c 01 00 00       	push   $0x13c
  8030d3:	68 8f 43 80 00       	push   $0x80438f
  8030d8:	e8 41 d6 ff ff       	call   80071e <_panic>
  8030dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030e0:	8b 00                	mov    (%eax),%eax
  8030e2:	85 c0                	test   %eax,%eax
  8030e4:	74 10                	je     8030f6 <insert_sorted_with_merge_freeList+0x106>
  8030e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030e9:	8b 00                	mov    (%eax),%eax
  8030eb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030ee:	8b 52 04             	mov    0x4(%edx),%edx
  8030f1:	89 50 04             	mov    %edx,0x4(%eax)
  8030f4:	eb 0b                	jmp    803101 <insert_sorted_with_merge_freeList+0x111>
  8030f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030f9:	8b 40 04             	mov    0x4(%eax),%eax
  8030fc:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803101:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803104:	8b 40 04             	mov    0x4(%eax),%eax
  803107:	85 c0                	test   %eax,%eax
  803109:	74 0f                	je     80311a <insert_sorted_with_merge_freeList+0x12a>
  80310b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80310e:	8b 40 04             	mov    0x4(%eax),%eax
  803111:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803114:	8b 12                	mov    (%edx),%edx
  803116:	89 10                	mov    %edx,(%eax)
  803118:	eb 0a                	jmp    803124 <insert_sorted_with_merge_freeList+0x134>
  80311a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80311d:	8b 00                	mov    (%eax),%eax
  80311f:	a3 38 51 80 00       	mov    %eax,0x805138
  803124:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803127:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80312d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803130:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803137:	a1 44 51 80 00       	mov    0x805144,%eax
  80313c:	48                   	dec    %eax
  80313d:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  803142:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803145:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  80314c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80314f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  803156:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80315a:	75 17                	jne    803173 <insert_sorted_with_merge_freeList+0x183>
  80315c:	83 ec 04             	sub    $0x4,%esp
  80315f:	68 6c 43 80 00       	push   $0x80436c
  803164:	68 3f 01 00 00       	push   $0x13f
  803169:	68 8f 43 80 00       	push   $0x80438f
  80316e:	e8 ab d5 ff ff       	call   80071e <_panic>
  803173:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803179:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80317c:	89 10                	mov    %edx,(%eax)
  80317e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803181:	8b 00                	mov    (%eax),%eax
  803183:	85 c0                	test   %eax,%eax
  803185:	74 0d                	je     803194 <insert_sorted_with_merge_freeList+0x1a4>
  803187:	a1 48 51 80 00       	mov    0x805148,%eax
  80318c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80318f:	89 50 04             	mov    %edx,0x4(%eax)
  803192:	eb 08                	jmp    80319c <insert_sorted_with_merge_freeList+0x1ac>
  803194:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803197:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80319c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80319f:	a3 48 51 80 00       	mov    %eax,0x805148
  8031a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031a7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031ae:	a1 54 51 80 00       	mov    0x805154,%eax
  8031b3:	40                   	inc    %eax
  8031b4:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8031b9:	e9 7a 05 00 00       	jmp    803738 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  8031be:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c1:	8b 50 08             	mov    0x8(%eax),%edx
  8031c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031c7:	8b 40 08             	mov    0x8(%eax),%eax
  8031ca:	39 c2                	cmp    %eax,%edx
  8031cc:	0f 82 14 01 00 00    	jb     8032e6 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  8031d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031d5:	8b 50 08             	mov    0x8(%eax),%edx
  8031d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031db:	8b 40 0c             	mov    0xc(%eax),%eax
  8031de:	01 c2                	add    %eax,%edx
  8031e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e3:	8b 40 08             	mov    0x8(%eax),%eax
  8031e6:	39 c2                	cmp    %eax,%edx
  8031e8:	0f 85 90 00 00 00    	jne    80327e <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  8031ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031f1:	8b 50 0c             	mov    0xc(%eax),%edx
  8031f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f7:	8b 40 0c             	mov    0xc(%eax),%eax
  8031fa:	01 c2                	add    %eax,%edx
  8031fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031ff:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  803202:	8b 45 08             	mov    0x8(%ebp),%eax
  803205:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  80320c:	8b 45 08             	mov    0x8(%ebp),%eax
  80320f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803216:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80321a:	75 17                	jne    803233 <insert_sorted_with_merge_freeList+0x243>
  80321c:	83 ec 04             	sub    $0x4,%esp
  80321f:	68 6c 43 80 00       	push   $0x80436c
  803224:	68 49 01 00 00       	push   $0x149
  803229:	68 8f 43 80 00       	push   $0x80438f
  80322e:	e8 eb d4 ff ff       	call   80071e <_panic>
  803233:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803239:	8b 45 08             	mov    0x8(%ebp),%eax
  80323c:	89 10                	mov    %edx,(%eax)
  80323e:	8b 45 08             	mov    0x8(%ebp),%eax
  803241:	8b 00                	mov    (%eax),%eax
  803243:	85 c0                	test   %eax,%eax
  803245:	74 0d                	je     803254 <insert_sorted_with_merge_freeList+0x264>
  803247:	a1 48 51 80 00       	mov    0x805148,%eax
  80324c:	8b 55 08             	mov    0x8(%ebp),%edx
  80324f:	89 50 04             	mov    %edx,0x4(%eax)
  803252:	eb 08                	jmp    80325c <insert_sorted_with_merge_freeList+0x26c>
  803254:	8b 45 08             	mov    0x8(%ebp),%eax
  803257:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80325c:	8b 45 08             	mov    0x8(%ebp),%eax
  80325f:	a3 48 51 80 00       	mov    %eax,0x805148
  803264:	8b 45 08             	mov    0x8(%ebp),%eax
  803267:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80326e:	a1 54 51 80 00       	mov    0x805154,%eax
  803273:	40                   	inc    %eax
  803274:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803279:	e9 bb 04 00 00       	jmp    803739 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  80327e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803282:	75 17                	jne    80329b <insert_sorted_with_merge_freeList+0x2ab>
  803284:	83 ec 04             	sub    $0x4,%esp
  803287:	68 e0 43 80 00       	push   $0x8043e0
  80328c:	68 4c 01 00 00       	push   $0x14c
  803291:	68 8f 43 80 00       	push   $0x80438f
  803296:	e8 83 d4 ff ff       	call   80071e <_panic>
  80329b:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8032a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a4:	89 50 04             	mov    %edx,0x4(%eax)
  8032a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8032aa:	8b 40 04             	mov    0x4(%eax),%eax
  8032ad:	85 c0                	test   %eax,%eax
  8032af:	74 0c                	je     8032bd <insert_sorted_with_merge_freeList+0x2cd>
  8032b1:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8032b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8032b9:	89 10                	mov    %edx,(%eax)
  8032bb:	eb 08                	jmp    8032c5 <insert_sorted_with_merge_freeList+0x2d5>
  8032bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c0:	a3 38 51 80 00       	mov    %eax,0x805138
  8032c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032d6:	a1 44 51 80 00       	mov    0x805144,%eax
  8032db:	40                   	inc    %eax
  8032dc:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8032e1:	e9 53 04 00 00       	jmp    803739 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8032e6:	a1 38 51 80 00       	mov    0x805138,%eax
  8032eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032ee:	e9 15 04 00 00       	jmp    803708 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  8032f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f6:	8b 00                	mov    (%eax),%eax
  8032f8:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  8032fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fe:	8b 50 08             	mov    0x8(%eax),%edx
  803301:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803304:	8b 40 08             	mov    0x8(%eax),%eax
  803307:	39 c2                	cmp    %eax,%edx
  803309:	0f 86 f1 03 00 00    	jbe    803700 <insert_sorted_with_merge_freeList+0x710>
  80330f:	8b 45 08             	mov    0x8(%ebp),%eax
  803312:	8b 50 08             	mov    0x8(%eax),%edx
  803315:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803318:	8b 40 08             	mov    0x8(%eax),%eax
  80331b:	39 c2                	cmp    %eax,%edx
  80331d:	0f 83 dd 03 00 00    	jae    803700 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803323:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803326:	8b 50 08             	mov    0x8(%eax),%edx
  803329:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80332c:	8b 40 0c             	mov    0xc(%eax),%eax
  80332f:	01 c2                	add    %eax,%edx
  803331:	8b 45 08             	mov    0x8(%ebp),%eax
  803334:	8b 40 08             	mov    0x8(%eax),%eax
  803337:	39 c2                	cmp    %eax,%edx
  803339:	0f 85 b9 01 00 00    	jne    8034f8 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80333f:	8b 45 08             	mov    0x8(%ebp),%eax
  803342:	8b 50 08             	mov    0x8(%eax),%edx
  803345:	8b 45 08             	mov    0x8(%ebp),%eax
  803348:	8b 40 0c             	mov    0xc(%eax),%eax
  80334b:	01 c2                	add    %eax,%edx
  80334d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803350:	8b 40 08             	mov    0x8(%eax),%eax
  803353:	39 c2                	cmp    %eax,%edx
  803355:	0f 85 0d 01 00 00    	jne    803468 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  80335b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80335e:	8b 50 0c             	mov    0xc(%eax),%edx
  803361:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803364:	8b 40 0c             	mov    0xc(%eax),%eax
  803367:	01 c2                	add    %eax,%edx
  803369:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80336c:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80336f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803373:	75 17                	jne    80338c <insert_sorted_with_merge_freeList+0x39c>
  803375:	83 ec 04             	sub    $0x4,%esp
  803378:	68 38 44 80 00       	push   $0x804438
  80337d:	68 5c 01 00 00       	push   $0x15c
  803382:	68 8f 43 80 00       	push   $0x80438f
  803387:	e8 92 d3 ff ff       	call   80071e <_panic>
  80338c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80338f:	8b 00                	mov    (%eax),%eax
  803391:	85 c0                	test   %eax,%eax
  803393:	74 10                	je     8033a5 <insert_sorted_with_merge_freeList+0x3b5>
  803395:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803398:	8b 00                	mov    (%eax),%eax
  80339a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80339d:	8b 52 04             	mov    0x4(%edx),%edx
  8033a0:	89 50 04             	mov    %edx,0x4(%eax)
  8033a3:	eb 0b                	jmp    8033b0 <insert_sorted_with_merge_freeList+0x3c0>
  8033a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033a8:	8b 40 04             	mov    0x4(%eax),%eax
  8033ab:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8033b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033b3:	8b 40 04             	mov    0x4(%eax),%eax
  8033b6:	85 c0                	test   %eax,%eax
  8033b8:	74 0f                	je     8033c9 <insert_sorted_with_merge_freeList+0x3d9>
  8033ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033bd:	8b 40 04             	mov    0x4(%eax),%eax
  8033c0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033c3:	8b 12                	mov    (%edx),%edx
  8033c5:	89 10                	mov    %edx,(%eax)
  8033c7:	eb 0a                	jmp    8033d3 <insert_sorted_with_merge_freeList+0x3e3>
  8033c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033cc:	8b 00                	mov    (%eax),%eax
  8033ce:	a3 38 51 80 00       	mov    %eax,0x805138
  8033d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033df:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033e6:	a1 44 51 80 00       	mov    0x805144,%eax
  8033eb:	48                   	dec    %eax
  8033ec:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  8033f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033f4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8033fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033fe:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803405:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803409:	75 17                	jne    803422 <insert_sorted_with_merge_freeList+0x432>
  80340b:	83 ec 04             	sub    $0x4,%esp
  80340e:	68 6c 43 80 00       	push   $0x80436c
  803413:	68 5f 01 00 00       	push   $0x15f
  803418:	68 8f 43 80 00       	push   $0x80438f
  80341d:	e8 fc d2 ff ff       	call   80071e <_panic>
  803422:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803428:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80342b:	89 10                	mov    %edx,(%eax)
  80342d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803430:	8b 00                	mov    (%eax),%eax
  803432:	85 c0                	test   %eax,%eax
  803434:	74 0d                	je     803443 <insert_sorted_with_merge_freeList+0x453>
  803436:	a1 48 51 80 00       	mov    0x805148,%eax
  80343b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80343e:	89 50 04             	mov    %edx,0x4(%eax)
  803441:	eb 08                	jmp    80344b <insert_sorted_with_merge_freeList+0x45b>
  803443:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803446:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80344b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80344e:	a3 48 51 80 00       	mov    %eax,0x805148
  803453:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803456:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80345d:	a1 54 51 80 00       	mov    0x805154,%eax
  803462:	40                   	inc    %eax
  803463:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803468:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80346b:	8b 50 0c             	mov    0xc(%eax),%edx
  80346e:	8b 45 08             	mov    0x8(%ebp),%eax
  803471:	8b 40 0c             	mov    0xc(%eax),%eax
  803474:	01 c2                	add    %eax,%edx
  803476:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803479:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  80347c:	8b 45 08             	mov    0x8(%ebp),%eax
  80347f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803486:	8b 45 08             	mov    0x8(%ebp),%eax
  803489:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803490:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803494:	75 17                	jne    8034ad <insert_sorted_with_merge_freeList+0x4bd>
  803496:	83 ec 04             	sub    $0x4,%esp
  803499:	68 6c 43 80 00       	push   $0x80436c
  80349e:	68 64 01 00 00       	push   $0x164
  8034a3:	68 8f 43 80 00       	push   $0x80438f
  8034a8:	e8 71 d2 ff ff       	call   80071e <_panic>
  8034ad:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8034b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b6:	89 10                	mov    %edx,(%eax)
  8034b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8034bb:	8b 00                	mov    (%eax),%eax
  8034bd:	85 c0                	test   %eax,%eax
  8034bf:	74 0d                	je     8034ce <insert_sorted_with_merge_freeList+0x4de>
  8034c1:	a1 48 51 80 00       	mov    0x805148,%eax
  8034c6:	8b 55 08             	mov    0x8(%ebp),%edx
  8034c9:	89 50 04             	mov    %edx,0x4(%eax)
  8034cc:	eb 08                	jmp    8034d6 <insert_sorted_with_merge_freeList+0x4e6>
  8034ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8034d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d9:	a3 48 51 80 00       	mov    %eax,0x805148
  8034de:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034e8:	a1 54 51 80 00       	mov    0x805154,%eax
  8034ed:	40                   	inc    %eax
  8034ee:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8034f3:	e9 41 02 00 00       	jmp    803739 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8034f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8034fb:	8b 50 08             	mov    0x8(%eax),%edx
  8034fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803501:	8b 40 0c             	mov    0xc(%eax),%eax
  803504:	01 c2                	add    %eax,%edx
  803506:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803509:	8b 40 08             	mov    0x8(%eax),%eax
  80350c:	39 c2                	cmp    %eax,%edx
  80350e:	0f 85 7c 01 00 00    	jne    803690 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803514:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803518:	74 06                	je     803520 <insert_sorted_with_merge_freeList+0x530>
  80351a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80351e:	75 17                	jne    803537 <insert_sorted_with_merge_freeList+0x547>
  803520:	83 ec 04             	sub    $0x4,%esp
  803523:	68 a8 43 80 00       	push   $0x8043a8
  803528:	68 69 01 00 00       	push   $0x169
  80352d:	68 8f 43 80 00       	push   $0x80438f
  803532:	e8 e7 d1 ff ff       	call   80071e <_panic>
  803537:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80353a:	8b 50 04             	mov    0x4(%eax),%edx
  80353d:	8b 45 08             	mov    0x8(%ebp),%eax
  803540:	89 50 04             	mov    %edx,0x4(%eax)
  803543:	8b 45 08             	mov    0x8(%ebp),%eax
  803546:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803549:	89 10                	mov    %edx,(%eax)
  80354b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80354e:	8b 40 04             	mov    0x4(%eax),%eax
  803551:	85 c0                	test   %eax,%eax
  803553:	74 0d                	je     803562 <insert_sorted_with_merge_freeList+0x572>
  803555:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803558:	8b 40 04             	mov    0x4(%eax),%eax
  80355b:	8b 55 08             	mov    0x8(%ebp),%edx
  80355e:	89 10                	mov    %edx,(%eax)
  803560:	eb 08                	jmp    80356a <insert_sorted_with_merge_freeList+0x57a>
  803562:	8b 45 08             	mov    0x8(%ebp),%eax
  803565:	a3 38 51 80 00       	mov    %eax,0x805138
  80356a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80356d:	8b 55 08             	mov    0x8(%ebp),%edx
  803570:	89 50 04             	mov    %edx,0x4(%eax)
  803573:	a1 44 51 80 00       	mov    0x805144,%eax
  803578:	40                   	inc    %eax
  803579:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  80357e:	8b 45 08             	mov    0x8(%ebp),%eax
  803581:	8b 50 0c             	mov    0xc(%eax),%edx
  803584:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803587:	8b 40 0c             	mov    0xc(%eax),%eax
  80358a:	01 c2                	add    %eax,%edx
  80358c:	8b 45 08             	mov    0x8(%ebp),%eax
  80358f:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803592:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803596:	75 17                	jne    8035af <insert_sorted_with_merge_freeList+0x5bf>
  803598:	83 ec 04             	sub    $0x4,%esp
  80359b:	68 38 44 80 00       	push   $0x804438
  8035a0:	68 6b 01 00 00       	push   $0x16b
  8035a5:	68 8f 43 80 00       	push   $0x80438f
  8035aa:	e8 6f d1 ff ff       	call   80071e <_panic>
  8035af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035b2:	8b 00                	mov    (%eax),%eax
  8035b4:	85 c0                	test   %eax,%eax
  8035b6:	74 10                	je     8035c8 <insert_sorted_with_merge_freeList+0x5d8>
  8035b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035bb:	8b 00                	mov    (%eax),%eax
  8035bd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8035c0:	8b 52 04             	mov    0x4(%edx),%edx
  8035c3:	89 50 04             	mov    %edx,0x4(%eax)
  8035c6:	eb 0b                	jmp    8035d3 <insert_sorted_with_merge_freeList+0x5e3>
  8035c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035cb:	8b 40 04             	mov    0x4(%eax),%eax
  8035ce:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8035d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035d6:	8b 40 04             	mov    0x4(%eax),%eax
  8035d9:	85 c0                	test   %eax,%eax
  8035db:	74 0f                	je     8035ec <insert_sorted_with_merge_freeList+0x5fc>
  8035dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035e0:	8b 40 04             	mov    0x4(%eax),%eax
  8035e3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8035e6:	8b 12                	mov    (%edx),%edx
  8035e8:	89 10                	mov    %edx,(%eax)
  8035ea:	eb 0a                	jmp    8035f6 <insert_sorted_with_merge_freeList+0x606>
  8035ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035ef:	8b 00                	mov    (%eax),%eax
  8035f1:	a3 38 51 80 00       	mov    %eax,0x805138
  8035f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803602:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803609:	a1 44 51 80 00       	mov    0x805144,%eax
  80360e:	48                   	dec    %eax
  80360f:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803614:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803617:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  80361e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803621:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803628:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80362c:	75 17                	jne    803645 <insert_sorted_with_merge_freeList+0x655>
  80362e:	83 ec 04             	sub    $0x4,%esp
  803631:	68 6c 43 80 00       	push   $0x80436c
  803636:	68 6e 01 00 00       	push   $0x16e
  80363b:	68 8f 43 80 00       	push   $0x80438f
  803640:	e8 d9 d0 ff ff       	call   80071e <_panic>
  803645:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80364b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80364e:	89 10                	mov    %edx,(%eax)
  803650:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803653:	8b 00                	mov    (%eax),%eax
  803655:	85 c0                	test   %eax,%eax
  803657:	74 0d                	je     803666 <insert_sorted_with_merge_freeList+0x676>
  803659:	a1 48 51 80 00       	mov    0x805148,%eax
  80365e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803661:	89 50 04             	mov    %edx,0x4(%eax)
  803664:	eb 08                	jmp    80366e <insert_sorted_with_merge_freeList+0x67e>
  803666:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803669:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80366e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803671:	a3 48 51 80 00       	mov    %eax,0x805148
  803676:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803679:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803680:	a1 54 51 80 00       	mov    0x805154,%eax
  803685:	40                   	inc    %eax
  803686:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80368b:	e9 a9 00 00 00       	jmp    803739 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803690:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803694:	74 06                	je     80369c <insert_sorted_with_merge_freeList+0x6ac>
  803696:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80369a:	75 17                	jne    8036b3 <insert_sorted_with_merge_freeList+0x6c3>
  80369c:	83 ec 04             	sub    $0x4,%esp
  80369f:	68 04 44 80 00       	push   $0x804404
  8036a4:	68 73 01 00 00       	push   $0x173
  8036a9:	68 8f 43 80 00       	push   $0x80438f
  8036ae:	e8 6b d0 ff ff       	call   80071e <_panic>
  8036b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036b6:	8b 10                	mov    (%eax),%edx
  8036b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8036bb:	89 10                	mov    %edx,(%eax)
  8036bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8036c0:	8b 00                	mov    (%eax),%eax
  8036c2:	85 c0                	test   %eax,%eax
  8036c4:	74 0b                	je     8036d1 <insert_sorted_with_merge_freeList+0x6e1>
  8036c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036c9:	8b 00                	mov    (%eax),%eax
  8036cb:	8b 55 08             	mov    0x8(%ebp),%edx
  8036ce:	89 50 04             	mov    %edx,0x4(%eax)
  8036d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036d4:	8b 55 08             	mov    0x8(%ebp),%edx
  8036d7:	89 10                	mov    %edx,(%eax)
  8036d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8036dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036df:	89 50 04             	mov    %edx,0x4(%eax)
  8036e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e5:	8b 00                	mov    (%eax),%eax
  8036e7:	85 c0                	test   %eax,%eax
  8036e9:	75 08                	jne    8036f3 <insert_sorted_with_merge_freeList+0x703>
  8036eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ee:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8036f3:	a1 44 51 80 00       	mov    0x805144,%eax
  8036f8:	40                   	inc    %eax
  8036f9:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  8036fe:	eb 39                	jmp    803739 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803700:	a1 40 51 80 00       	mov    0x805140,%eax
  803705:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803708:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80370c:	74 07                	je     803715 <insert_sorted_with_merge_freeList+0x725>
  80370e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803711:	8b 00                	mov    (%eax),%eax
  803713:	eb 05                	jmp    80371a <insert_sorted_with_merge_freeList+0x72a>
  803715:	b8 00 00 00 00       	mov    $0x0,%eax
  80371a:	a3 40 51 80 00       	mov    %eax,0x805140
  80371f:	a1 40 51 80 00       	mov    0x805140,%eax
  803724:	85 c0                	test   %eax,%eax
  803726:	0f 85 c7 fb ff ff    	jne    8032f3 <insert_sorted_with_merge_freeList+0x303>
  80372c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803730:	0f 85 bd fb ff ff    	jne    8032f3 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803736:	eb 01                	jmp    803739 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803738:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803739:	90                   	nop
  80373a:	c9                   	leave  
  80373b:	c3                   	ret    

0080373c <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  80373c:	55                   	push   %ebp
  80373d:	89 e5                	mov    %esp,%ebp
  80373f:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803742:	8b 55 08             	mov    0x8(%ebp),%edx
  803745:	89 d0                	mov    %edx,%eax
  803747:	c1 e0 02             	shl    $0x2,%eax
  80374a:	01 d0                	add    %edx,%eax
  80374c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803753:	01 d0                	add    %edx,%eax
  803755:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80375c:	01 d0                	add    %edx,%eax
  80375e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803765:	01 d0                	add    %edx,%eax
  803767:	c1 e0 04             	shl    $0x4,%eax
  80376a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  80376d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  803774:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803777:	83 ec 0c             	sub    $0xc,%esp
  80377a:	50                   	push   %eax
  80377b:	e8 26 e7 ff ff       	call   801ea6 <sys_get_virtual_time>
  803780:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803783:	eb 41                	jmp    8037c6 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  803785:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803788:	83 ec 0c             	sub    $0xc,%esp
  80378b:	50                   	push   %eax
  80378c:	e8 15 e7 ff ff       	call   801ea6 <sys_get_virtual_time>
  803791:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803794:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803797:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80379a:	29 c2                	sub    %eax,%edx
  80379c:	89 d0                	mov    %edx,%eax
  80379e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8037a1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037a7:	89 d1                	mov    %edx,%ecx
  8037a9:	29 c1                	sub    %eax,%ecx
  8037ab:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8037ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037b1:	39 c2                	cmp    %eax,%edx
  8037b3:	0f 97 c0             	seta   %al
  8037b6:	0f b6 c0             	movzbl %al,%eax
  8037b9:	29 c1                	sub    %eax,%ecx
  8037bb:	89 c8                	mov    %ecx,%eax
  8037bd:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8037c0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8037c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8037c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037c9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8037cc:	72 b7                	jb     803785 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8037ce:	90                   	nop
  8037cf:	c9                   	leave  
  8037d0:	c3                   	ret    

008037d1 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8037d1:	55                   	push   %ebp
  8037d2:	89 e5                	mov    %esp,%ebp
  8037d4:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8037d7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8037de:	eb 03                	jmp    8037e3 <busy_wait+0x12>
  8037e0:	ff 45 fc             	incl   -0x4(%ebp)
  8037e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8037e6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8037e9:	72 f5                	jb     8037e0 <busy_wait+0xf>
	return i;
  8037eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8037ee:	c9                   	leave  
  8037ef:	c3                   	ret    

008037f0 <__udivdi3>:
  8037f0:	55                   	push   %ebp
  8037f1:	57                   	push   %edi
  8037f2:	56                   	push   %esi
  8037f3:	53                   	push   %ebx
  8037f4:	83 ec 1c             	sub    $0x1c,%esp
  8037f7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8037fb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8037ff:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803803:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803807:	89 ca                	mov    %ecx,%edx
  803809:	89 f8                	mov    %edi,%eax
  80380b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80380f:	85 f6                	test   %esi,%esi
  803811:	75 2d                	jne    803840 <__udivdi3+0x50>
  803813:	39 cf                	cmp    %ecx,%edi
  803815:	77 65                	ja     80387c <__udivdi3+0x8c>
  803817:	89 fd                	mov    %edi,%ebp
  803819:	85 ff                	test   %edi,%edi
  80381b:	75 0b                	jne    803828 <__udivdi3+0x38>
  80381d:	b8 01 00 00 00       	mov    $0x1,%eax
  803822:	31 d2                	xor    %edx,%edx
  803824:	f7 f7                	div    %edi
  803826:	89 c5                	mov    %eax,%ebp
  803828:	31 d2                	xor    %edx,%edx
  80382a:	89 c8                	mov    %ecx,%eax
  80382c:	f7 f5                	div    %ebp
  80382e:	89 c1                	mov    %eax,%ecx
  803830:	89 d8                	mov    %ebx,%eax
  803832:	f7 f5                	div    %ebp
  803834:	89 cf                	mov    %ecx,%edi
  803836:	89 fa                	mov    %edi,%edx
  803838:	83 c4 1c             	add    $0x1c,%esp
  80383b:	5b                   	pop    %ebx
  80383c:	5e                   	pop    %esi
  80383d:	5f                   	pop    %edi
  80383e:	5d                   	pop    %ebp
  80383f:	c3                   	ret    
  803840:	39 ce                	cmp    %ecx,%esi
  803842:	77 28                	ja     80386c <__udivdi3+0x7c>
  803844:	0f bd fe             	bsr    %esi,%edi
  803847:	83 f7 1f             	xor    $0x1f,%edi
  80384a:	75 40                	jne    80388c <__udivdi3+0x9c>
  80384c:	39 ce                	cmp    %ecx,%esi
  80384e:	72 0a                	jb     80385a <__udivdi3+0x6a>
  803850:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803854:	0f 87 9e 00 00 00    	ja     8038f8 <__udivdi3+0x108>
  80385a:	b8 01 00 00 00       	mov    $0x1,%eax
  80385f:	89 fa                	mov    %edi,%edx
  803861:	83 c4 1c             	add    $0x1c,%esp
  803864:	5b                   	pop    %ebx
  803865:	5e                   	pop    %esi
  803866:	5f                   	pop    %edi
  803867:	5d                   	pop    %ebp
  803868:	c3                   	ret    
  803869:	8d 76 00             	lea    0x0(%esi),%esi
  80386c:	31 ff                	xor    %edi,%edi
  80386e:	31 c0                	xor    %eax,%eax
  803870:	89 fa                	mov    %edi,%edx
  803872:	83 c4 1c             	add    $0x1c,%esp
  803875:	5b                   	pop    %ebx
  803876:	5e                   	pop    %esi
  803877:	5f                   	pop    %edi
  803878:	5d                   	pop    %ebp
  803879:	c3                   	ret    
  80387a:	66 90                	xchg   %ax,%ax
  80387c:	89 d8                	mov    %ebx,%eax
  80387e:	f7 f7                	div    %edi
  803880:	31 ff                	xor    %edi,%edi
  803882:	89 fa                	mov    %edi,%edx
  803884:	83 c4 1c             	add    $0x1c,%esp
  803887:	5b                   	pop    %ebx
  803888:	5e                   	pop    %esi
  803889:	5f                   	pop    %edi
  80388a:	5d                   	pop    %ebp
  80388b:	c3                   	ret    
  80388c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803891:	89 eb                	mov    %ebp,%ebx
  803893:	29 fb                	sub    %edi,%ebx
  803895:	89 f9                	mov    %edi,%ecx
  803897:	d3 e6                	shl    %cl,%esi
  803899:	89 c5                	mov    %eax,%ebp
  80389b:	88 d9                	mov    %bl,%cl
  80389d:	d3 ed                	shr    %cl,%ebp
  80389f:	89 e9                	mov    %ebp,%ecx
  8038a1:	09 f1                	or     %esi,%ecx
  8038a3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8038a7:	89 f9                	mov    %edi,%ecx
  8038a9:	d3 e0                	shl    %cl,%eax
  8038ab:	89 c5                	mov    %eax,%ebp
  8038ad:	89 d6                	mov    %edx,%esi
  8038af:	88 d9                	mov    %bl,%cl
  8038b1:	d3 ee                	shr    %cl,%esi
  8038b3:	89 f9                	mov    %edi,%ecx
  8038b5:	d3 e2                	shl    %cl,%edx
  8038b7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8038bb:	88 d9                	mov    %bl,%cl
  8038bd:	d3 e8                	shr    %cl,%eax
  8038bf:	09 c2                	or     %eax,%edx
  8038c1:	89 d0                	mov    %edx,%eax
  8038c3:	89 f2                	mov    %esi,%edx
  8038c5:	f7 74 24 0c          	divl   0xc(%esp)
  8038c9:	89 d6                	mov    %edx,%esi
  8038cb:	89 c3                	mov    %eax,%ebx
  8038cd:	f7 e5                	mul    %ebp
  8038cf:	39 d6                	cmp    %edx,%esi
  8038d1:	72 19                	jb     8038ec <__udivdi3+0xfc>
  8038d3:	74 0b                	je     8038e0 <__udivdi3+0xf0>
  8038d5:	89 d8                	mov    %ebx,%eax
  8038d7:	31 ff                	xor    %edi,%edi
  8038d9:	e9 58 ff ff ff       	jmp    803836 <__udivdi3+0x46>
  8038de:	66 90                	xchg   %ax,%ax
  8038e0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8038e4:	89 f9                	mov    %edi,%ecx
  8038e6:	d3 e2                	shl    %cl,%edx
  8038e8:	39 c2                	cmp    %eax,%edx
  8038ea:	73 e9                	jae    8038d5 <__udivdi3+0xe5>
  8038ec:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8038ef:	31 ff                	xor    %edi,%edi
  8038f1:	e9 40 ff ff ff       	jmp    803836 <__udivdi3+0x46>
  8038f6:	66 90                	xchg   %ax,%ax
  8038f8:	31 c0                	xor    %eax,%eax
  8038fa:	e9 37 ff ff ff       	jmp    803836 <__udivdi3+0x46>
  8038ff:	90                   	nop

00803900 <__umoddi3>:
  803900:	55                   	push   %ebp
  803901:	57                   	push   %edi
  803902:	56                   	push   %esi
  803903:	53                   	push   %ebx
  803904:	83 ec 1c             	sub    $0x1c,%esp
  803907:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80390b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80390f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803913:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803917:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80391b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80391f:	89 f3                	mov    %esi,%ebx
  803921:	89 fa                	mov    %edi,%edx
  803923:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803927:	89 34 24             	mov    %esi,(%esp)
  80392a:	85 c0                	test   %eax,%eax
  80392c:	75 1a                	jne    803948 <__umoddi3+0x48>
  80392e:	39 f7                	cmp    %esi,%edi
  803930:	0f 86 a2 00 00 00    	jbe    8039d8 <__umoddi3+0xd8>
  803936:	89 c8                	mov    %ecx,%eax
  803938:	89 f2                	mov    %esi,%edx
  80393a:	f7 f7                	div    %edi
  80393c:	89 d0                	mov    %edx,%eax
  80393e:	31 d2                	xor    %edx,%edx
  803940:	83 c4 1c             	add    $0x1c,%esp
  803943:	5b                   	pop    %ebx
  803944:	5e                   	pop    %esi
  803945:	5f                   	pop    %edi
  803946:	5d                   	pop    %ebp
  803947:	c3                   	ret    
  803948:	39 f0                	cmp    %esi,%eax
  80394a:	0f 87 ac 00 00 00    	ja     8039fc <__umoddi3+0xfc>
  803950:	0f bd e8             	bsr    %eax,%ebp
  803953:	83 f5 1f             	xor    $0x1f,%ebp
  803956:	0f 84 ac 00 00 00    	je     803a08 <__umoddi3+0x108>
  80395c:	bf 20 00 00 00       	mov    $0x20,%edi
  803961:	29 ef                	sub    %ebp,%edi
  803963:	89 fe                	mov    %edi,%esi
  803965:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803969:	89 e9                	mov    %ebp,%ecx
  80396b:	d3 e0                	shl    %cl,%eax
  80396d:	89 d7                	mov    %edx,%edi
  80396f:	89 f1                	mov    %esi,%ecx
  803971:	d3 ef                	shr    %cl,%edi
  803973:	09 c7                	or     %eax,%edi
  803975:	89 e9                	mov    %ebp,%ecx
  803977:	d3 e2                	shl    %cl,%edx
  803979:	89 14 24             	mov    %edx,(%esp)
  80397c:	89 d8                	mov    %ebx,%eax
  80397e:	d3 e0                	shl    %cl,%eax
  803980:	89 c2                	mov    %eax,%edx
  803982:	8b 44 24 08          	mov    0x8(%esp),%eax
  803986:	d3 e0                	shl    %cl,%eax
  803988:	89 44 24 04          	mov    %eax,0x4(%esp)
  80398c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803990:	89 f1                	mov    %esi,%ecx
  803992:	d3 e8                	shr    %cl,%eax
  803994:	09 d0                	or     %edx,%eax
  803996:	d3 eb                	shr    %cl,%ebx
  803998:	89 da                	mov    %ebx,%edx
  80399a:	f7 f7                	div    %edi
  80399c:	89 d3                	mov    %edx,%ebx
  80399e:	f7 24 24             	mull   (%esp)
  8039a1:	89 c6                	mov    %eax,%esi
  8039a3:	89 d1                	mov    %edx,%ecx
  8039a5:	39 d3                	cmp    %edx,%ebx
  8039a7:	0f 82 87 00 00 00    	jb     803a34 <__umoddi3+0x134>
  8039ad:	0f 84 91 00 00 00    	je     803a44 <__umoddi3+0x144>
  8039b3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8039b7:	29 f2                	sub    %esi,%edx
  8039b9:	19 cb                	sbb    %ecx,%ebx
  8039bb:	89 d8                	mov    %ebx,%eax
  8039bd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8039c1:	d3 e0                	shl    %cl,%eax
  8039c3:	89 e9                	mov    %ebp,%ecx
  8039c5:	d3 ea                	shr    %cl,%edx
  8039c7:	09 d0                	or     %edx,%eax
  8039c9:	89 e9                	mov    %ebp,%ecx
  8039cb:	d3 eb                	shr    %cl,%ebx
  8039cd:	89 da                	mov    %ebx,%edx
  8039cf:	83 c4 1c             	add    $0x1c,%esp
  8039d2:	5b                   	pop    %ebx
  8039d3:	5e                   	pop    %esi
  8039d4:	5f                   	pop    %edi
  8039d5:	5d                   	pop    %ebp
  8039d6:	c3                   	ret    
  8039d7:	90                   	nop
  8039d8:	89 fd                	mov    %edi,%ebp
  8039da:	85 ff                	test   %edi,%edi
  8039dc:	75 0b                	jne    8039e9 <__umoddi3+0xe9>
  8039de:	b8 01 00 00 00       	mov    $0x1,%eax
  8039e3:	31 d2                	xor    %edx,%edx
  8039e5:	f7 f7                	div    %edi
  8039e7:	89 c5                	mov    %eax,%ebp
  8039e9:	89 f0                	mov    %esi,%eax
  8039eb:	31 d2                	xor    %edx,%edx
  8039ed:	f7 f5                	div    %ebp
  8039ef:	89 c8                	mov    %ecx,%eax
  8039f1:	f7 f5                	div    %ebp
  8039f3:	89 d0                	mov    %edx,%eax
  8039f5:	e9 44 ff ff ff       	jmp    80393e <__umoddi3+0x3e>
  8039fa:	66 90                	xchg   %ax,%ax
  8039fc:	89 c8                	mov    %ecx,%eax
  8039fe:	89 f2                	mov    %esi,%edx
  803a00:	83 c4 1c             	add    $0x1c,%esp
  803a03:	5b                   	pop    %ebx
  803a04:	5e                   	pop    %esi
  803a05:	5f                   	pop    %edi
  803a06:	5d                   	pop    %ebp
  803a07:	c3                   	ret    
  803a08:	3b 04 24             	cmp    (%esp),%eax
  803a0b:	72 06                	jb     803a13 <__umoddi3+0x113>
  803a0d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803a11:	77 0f                	ja     803a22 <__umoddi3+0x122>
  803a13:	89 f2                	mov    %esi,%edx
  803a15:	29 f9                	sub    %edi,%ecx
  803a17:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803a1b:	89 14 24             	mov    %edx,(%esp)
  803a1e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803a22:	8b 44 24 04          	mov    0x4(%esp),%eax
  803a26:	8b 14 24             	mov    (%esp),%edx
  803a29:	83 c4 1c             	add    $0x1c,%esp
  803a2c:	5b                   	pop    %ebx
  803a2d:	5e                   	pop    %esi
  803a2e:	5f                   	pop    %edi
  803a2f:	5d                   	pop    %ebp
  803a30:	c3                   	ret    
  803a31:	8d 76 00             	lea    0x0(%esi),%esi
  803a34:	2b 04 24             	sub    (%esp),%eax
  803a37:	19 fa                	sbb    %edi,%edx
  803a39:	89 d1                	mov    %edx,%ecx
  803a3b:	89 c6                	mov    %eax,%esi
  803a3d:	e9 71 ff ff ff       	jmp    8039b3 <__umoddi3+0xb3>
  803a42:	66 90                	xchg   %ax,%ax
  803a44:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803a48:	72 ea                	jb     803a34 <__umoddi3+0x134>
  803a4a:	89 d9                	mov    %ebx,%ecx
  803a4c:	e9 62 ff ff ff       	jmp    8039b3 <__umoddi3+0xb3>
