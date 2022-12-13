
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
  80008a:	68 00 3b 80 00       	push   $0x803b00
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
  8000ba:	68 32 3b 80 00       	push   $0x803b32
  8000bf:	e8 b5 1d 00 00       	call   801e79 <sys_create_env>
  8000c4:	83 c4 10             	add    $0x10,%esp
  8000c7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		int freeFrames = sys_calculate_free_frames() ;
  8000ca:	e8 38 1b 00 00       	call   801c07 <sys_calculate_free_frames>
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
  8000f5:	68 36 3b 80 00       	push   $0x803b36
  8000fa:	e8 7a 1d 00 00       	call   801e79 <sys_create_env>
  8000ff:	83 c4 10             	add    $0x10,%esp
  800102:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		int helloWorldFrames = freeFrames - sys_calculate_free_frames() ;
  800105:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800108:	e8 fa 1a 00 00       	call   801c07 <sys_calculate_free_frames>
  80010d:	29 c3                	sub    %eax,%ebx
  80010f:	89 d8                	mov    %ebx,%eax
  800111:	89 45 d0             	mov    %eax,-0x30(%ebp)
		env_sleep(2000);
  800114:	83 ec 0c             	sub    $0xc,%esp
  800117:	68 d0 07 00 00       	push   $0x7d0
  80011c:	e8 a8 36 00 00       	call   8037c9 <env_sleep>
  800121:	83 c4 10             	add    $0x10,%esp
		cprintf("[DONE]\n\n");
  800124:	83 ec 0c             	sub    $0xc,%esp
  800127:	68 45 3b 80 00       	push   $0x803b45
  80012c:	e8 a1 08 00 00       	call   8009d2 <cprintf>
  800131:	83 c4 10             	add    $0x10,%esp

		//Load and run "fos_add"
		cprintf("Loading fos_add program into RAM...");
  800134:	83 ec 0c             	sub    $0xc,%esp
  800137:	68 50 3b 80 00       	push   $0x803b50
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
  800167:	68 74 3b 80 00       	push   $0x803b74
  80016c:	e8 08 1d 00 00       	call   801e79 <sys_create_env>
  800171:	83 c4 10             	add    $0x10,%esp
  800174:	89 45 cc             	mov    %eax,-0x34(%ebp)
		env_sleep(2000);
  800177:	83 ec 0c             	sub    $0xc,%esp
  80017a:	68 d0 07 00 00       	push   $0x7d0
  80017f:	e8 45 36 00 00       	call   8037c9 <env_sleep>
  800184:	83 c4 10             	add    $0x10,%esp
		cprintf("[DONE]\n\n");
  800187:	83 ec 0c             	sub    $0xc,%esp
  80018a:	68 45 3b 80 00       	push   $0x803b45
  80018f:	e8 3e 08 00 00       	call   8009d2 <cprintf>
  800194:	83 c4 10             	add    $0x10,%esp
		cprintf("running fos_add program...\n\n");
  800197:	83 ec 0c             	sub    $0xc,%esp
  80019a:	68 7c 3b 80 00       	push   $0x803b7c
  80019f:	e8 2e 08 00 00       	call   8009d2 <cprintf>
  8001a4:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdFOSAdd);
  8001a7:	83 ec 0c             	sub    $0xc,%esp
  8001aa:	ff 75 cc             	pushl  -0x34(%ebp)
  8001ad:	e8 e5 1c 00 00       	call   801e97 <sys_run_env>
  8001b2:	83 c4 10             	add    $0x10,%esp

		cprintf("please be patient ...\n");
  8001b5:	83 ec 0c             	sub    $0xc,%esp
  8001b8:	68 99 3b 80 00       	push   $0x803b99
  8001bd:	e8 10 08 00 00       	call   8009d2 <cprintf>
  8001c2:	83 c4 10             	add    $0x10,%esp
		env_sleep(5000);
  8001c5:	83 ec 0c             	sub    $0xc,%esp
  8001c8:	68 88 13 00 00       	push   $0x1388
  8001cd:	e8 f7 35 00 00       	call   8037c9 <env_sleep>
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
  800266:	e8 9c 19 00 00       	call   801c07 <sys_calculate_free_frames>
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
  800352:	68 b0 3b 80 00       	push   $0x803bb0
  800357:	e8 76 06 00 00       	call   8009d2 <cprintf>
  80035c:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdHelloWorld);
  80035f:	83 ec 0c             	sub    $0xc,%esp
  800362:	ff 75 d4             	pushl  -0x2c(%ebp)
  800365:	e8 2d 1b 00 00       	call   801e97 <sys_run_env>
  80036a:	83 c4 10             	add    $0x10,%esp

		cprintf("please be patient ...\n");
  80036d:	83 ec 0c             	sub    $0xc,%esp
  800370:	68 99 3b 80 00       	push   $0x803b99
  800375:	e8 58 06 00 00       	call   8009d2 <cprintf>
  80037a:	83 c4 10             	add    $0x10,%esp
		env_sleep(5000);
  80037d:	83 ec 0c             	sub    $0xc,%esp
  800380:	68 88 13 00 00       	push   $0x1388
  800385:	e8 3f 34 00 00       	call   8037c9 <env_sleep>
  80038a:	83 c4 10             	add    $0x10,%esp

		//Allocate the remaining RAM + extra RAM by the size of helloWorld program (Here: it requires to free some RAM by removing exited & loaded program(s) (fos_helloWorld & fib))
		freeFrames = sys_calculate_free_frames() ;
  80038d:	e8 75 18 00 00       	call   801c07 <sys_calculate_free_frames>
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
  800444:	68 d4 3b 80 00       	push   $0x803bd4
  800449:	6a 62                	push   $0x62
  80044b:	68 09 3c 80 00       	push   $0x803c09
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
  800479:	68 d4 3b 80 00       	push   $0x803bd4
  80047e:	6a 63                	push   $0x63
  800480:	68 09 3c 80 00       	push   $0x803c09
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
  8004ad:	68 d4 3b 80 00       	push   $0x803bd4
  8004b2:	6a 64                	push   $0x64
  8004b4:	68 09 3c 80 00       	push   $0x803c09
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
  8004e1:	68 d4 3b 80 00       	push   $0x803bd4
  8004e6:	6a 65                	push   $0x65
  8004e8:	68 09 3c 80 00       	push   $0x803c09
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
  800515:	68 d4 3b 80 00       	push   $0x803bd4
  80051a:	6a 66                	push   $0x66
  80051c:	68 09 3c 80 00       	push   $0x803c09
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
  800549:	68 d4 3b 80 00       	push   $0x803bd4
  80054e:	6a 68                	push   $0x68
  800550:	68 09 3c 80 00       	push   $0x803c09
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
  800583:	68 d4 3b 80 00       	push   $0x803bd4
  800588:	6a 69                	push   $0x69
  80058a:	68 09 3c 80 00       	push   $0x803c09
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
  8005b9:	68 d4 3b 80 00       	push   $0x803bd4
  8005be:	6a 6a                	push   $0x6a
  8005c0:	68 09 3c 80 00       	push   $0x803c09
  8005c5:	e8 54 01 00 00       	call   80071e <_panic>


	}

	cprintf("Congratulations!! test freeRAM (1) completed successfully.\n");
  8005ca:	83 ec 0c             	sub    $0xc,%esp
  8005cd:	68 20 3c 80 00       	push   $0x803c20
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
  8005e8:	e8 fa 18 00 00       	call   801ee7 <sys_getenvindex>
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
  800653:	e8 9c 16 00 00       	call   801cf4 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800658:	83 ec 0c             	sub    $0xc,%esp
  80065b:	68 74 3c 80 00       	push   $0x803c74
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
  800683:	68 9c 3c 80 00       	push   $0x803c9c
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
  8006b4:	68 c4 3c 80 00       	push   $0x803cc4
  8006b9:	e8 14 03 00 00       	call   8009d2 <cprintf>
  8006be:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8006c1:	a1 20 50 80 00       	mov    0x805020,%eax
  8006c6:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8006cc:	83 ec 08             	sub    $0x8,%esp
  8006cf:	50                   	push   %eax
  8006d0:	68 1c 3d 80 00       	push   $0x803d1c
  8006d5:	e8 f8 02 00 00       	call   8009d2 <cprintf>
  8006da:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8006dd:	83 ec 0c             	sub    $0xc,%esp
  8006e0:	68 74 3c 80 00       	push   $0x803c74
  8006e5:	e8 e8 02 00 00       	call   8009d2 <cprintf>
  8006ea:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8006ed:	e8 1c 16 00 00       	call   801d0e <sys_enable_interrupt>

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
  800705:	e8 a9 17 00 00       	call   801eb3 <sys_destroy_env>
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
  800716:	e8 fe 17 00 00       	call   801f19 <sys_exit_env>
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
  80073f:	68 30 3d 80 00       	push   $0x803d30
  800744:	e8 89 02 00 00       	call   8009d2 <cprintf>
  800749:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80074c:	a1 00 50 80 00       	mov    0x805000,%eax
  800751:	ff 75 0c             	pushl  0xc(%ebp)
  800754:	ff 75 08             	pushl  0x8(%ebp)
  800757:	50                   	push   %eax
  800758:	68 35 3d 80 00       	push   $0x803d35
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
  80077c:	68 51 3d 80 00       	push   $0x803d51
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
  8007a8:	68 54 3d 80 00       	push   $0x803d54
  8007ad:	6a 26                	push   $0x26
  8007af:	68 a0 3d 80 00       	push   $0x803da0
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
  80087a:	68 ac 3d 80 00       	push   $0x803dac
  80087f:	6a 3a                	push   $0x3a
  800881:	68 a0 3d 80 00       	push   $0x803da0
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
  8008ea:	68 00 3e 80 00       	push   $0x803e00
  8008ef:	6a 44                	push   $0x44
  8008f1:	68 a0 3d 80 00       	push   $0x803da0
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
  800944:	e8 fd 11 00 00       	call   801b46 <sys_cputs>
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
  8009bb:	e8 86 11 00 00       	call   801b46 <sys_cputs>
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
  800a05:	e8 ea 12 00 00       	call   801cf4 <sys_disable_interrupt>
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
  800a25:	e8 e4 12 00 00       	call   801d0e <sys_enable_interrupt>
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
  800a6f:	e8 0c 2e 00 00       	call   803880 <__udivdi3>
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
  800abf:	e8 cc 2e 00 00       	call   803990 <__umoddi3>
  800ac4:	83 c4 10             	add    $0x10,%esp
  800ac7:	05 74 40 80 00       	add    $0x804074,%eax
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
  800c1a:	8b 04 85 98 40 80 00 	mov    0x804098(,%eax,4),%eax
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
  800cfb:	8b 34 9d e0 3e 80 00 	mov    0x803ee0(,%ebx,4),%esi
  800d02:	85 f6                	test   %esi,%esi
  800d04:	75 19                	jne    800d1f <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d06:	53                   	push   %ebx
  800d07:	68 85 40 80 00       	push   $0x804085
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
  800d20:	68 8e 40 80 00       	push   $0x80408e
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
  800d4d:	be 91 40 80 00       	mov    $0x804091,%esi
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
  801773:	68 f0 41 80 00       	push   $0x8041f0
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
  801843:	e8 42 04 00 00       	call   801c8a <sys_allocate_chunk>
  801848:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  80184b:	a1 20 51 80 00       	mov    0x805120,%eax
  801850:	83 ec 0c             	sub    $0xc,%esp
  801853:	50                   	push   %eax
  801854:	e8 b7 0a 00 00       	call   802310 <initialize_MemBlocksList>
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
  801881:	68 15 42 80 00       	push   $0x804215
  801886:	6a 33                	push   $0x33
  801888:	68 33 42 80 00       	push   $0x804233
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
  801900:	68 40 42 80 00       	push   $0x804240
  801905:	6a 34                	push   $0x34
  801907:	68 33 42 80 00       	push   $0x804233
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
  801975:	68 64 42 80 00       	push   $0x804264
  80197a:	6a 46                	push   $0x46
  80197c:	68 33 42 80 00       	push   $0x804233
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
  801991:	68 8c 42 80 00       	push   $0x80428c
  801996:	6a 61                	push   $0x61
  801998:	68 33 42 80 00       	push   $0x804233
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
  8019b7:	75 0a                	jne    8019c3 <smalloc+0x21>
  8019b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8019be:	e9 9e 00 00 00       	jmp    801a61 <smalloc+0xbf>
	//3-If the Kernel successfully creates the shared variable, return its virtual address
	//4-Else, return NULL



	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  8019c3:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8019ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019d0:	01 d0                	add    %edx,%eax
  8019d2:	48                   	dec    %eax
  8019d3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8019d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019d9:	ba 00 00 00 00       	mov    $0x0,%edx
  8019de:	f7 75 f0             	divl   -0x10(%ebp)
  8019e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019e4:	29 d0                	sub    %edx,%eax
  8019e6:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  8019e9:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8019f0:	e8 63 06 00 00       	call   802058 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8019f5:	85 c0                	test   %eax,%eax
  8019f7:	74 11                	je     801a0a <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  8019f9:	83 ec 0c             	sub    $0xc,%esp
  8019fc:	ff 75 e8             	pushl  -0x18(%ebp)
  8019ff:	e8 ce 0c 00 00       	call   8026d2 <alloc_block_FF>
  801a04:	83 c4 10             	add    $0x10,%esp
  801a07:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  801a0a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a0e:	74 4c                	je     801a5c <smalloc+0xba>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801a10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a13:	8b 40 08             	mov    0x8(%eax),%eax
  801a16:	89 c2                	mov    %eax,%edx
  801a18:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801a1c:	52                   	push   %edx
  801a1d:	50                   	push   %eax
  801a1e:	ff 75 0c             	pushl  0xc(%ebp)
  801a21:	ff 75 08             	pushl  0x8(%ebp)
  801a24:	e8 b4 03 00 00       	call   801ddd <sys_createSharedObject>
  801a29:	83 c4 10             	add    $0x10,%esp
  801a2c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cprintf("Output is :  %d \n" , result);
  801a2f:	83 ec 08             	sub    $0x8,%esp
  801a32:	ff 75 e0             	pushl  -0x20(%ebp)
  801a35:	68 af 42 80 00       	push   $0x8042af
  801a3a:	e8 93 ef ff ff       	call   8009d2 <cprintf>
  801a3f:	83 c4 10             	add    $0x10,%esp
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  801a42:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  801a46:	74 14                	je     801a5c <smalloc+0xba>
  801a48:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  801a4c:	74 0e                	je     801a5c <smalloc+0xba>
  801a4e:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  801a52:	74 08                	je     801a5c <smalloc+0xba>
			return (void*) mem_block->sva;
  801a54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a57:	8b 40 08             	mov    0x8(%eax),%eax
  801a5a:	eb 05                	jmp    801a61 <smalloc+0xbf>
	}
	return NULL;
  801a5c:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801a61:	c9                   	leave  
  801a62:	c3                   	ret    

00801a63 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801a63:	55                   	push   %ebp
  801a64:	89 e5                	mov    %esp,%ebp
  801a66:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801a69:	e8 ee fc ff ff       	call   80175c <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801a6e:	83 ec 04             	sub    $0x4,%esp
  801a71:	68 c4 42 80 00       	push   $0x8042c4
  801a76:	68 ab 00 00 00       	push   $0xab
  801a7b:	68 33 42 80 00       	push   $0x804233
  801a80:	e8 99 ec ff ff       	call   80071e <_panic>

00801a85 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801a85:	55                   	push   %ebp
  801a86:	89 e5                	mov    %esp,%ebp
  801a88:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801a8b:	e8 cc fc ff ff       	call   80175c <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801a90:	83 ec 04             	sub    $0x4,%esp
  801a93:	68 e8 42 80 00       	push   $0x8042e8
  801a98:	68 ef 00 00 00       	push   $0xef
  801a9d:	68 33 42 80 00       	push   $0x804233
  801aa2:	e8 77 ec ff ff       	call   80071e <_panic>

00801aa7 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801aa7:	55                   	push   %ebp
  801aa8:	89 e5                	mov    %esp,%ebp
  801aaa:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801aad:	83 ec 04             	sub    $0x4,%esp
  801ab0:	68 10 43 80 00       	push   $0x804310
  801ab5:	68 03 01 00 00       	push   $0x103
  801aba:	68 33 42 80 00       	push   $0x804233
  801abf:	e8 5a ec ff ff       	call   80071e <_panic>

00801ac4 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801ac4:	55                   	push   %ebp
  801ac5:	89 e5                	mov    %esp,%ebp
  801ac7:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801aca:	83 ec 04             	sub    $0x4,%esp
  801acd:	68 34 43 80 00       	push   $0x804334
  801ad2:	68 0e 01 00 00       	push   $0x10e
  801ad7:	68 33 42 80 00       	push   $0x804233
  801adc:	e8 3d ec ff ff       	call   80071e <_panic>

00801ae1 <shrink>:

}
void shrink(uint32 newSize)
{
  801ae1:	55                   	push   %ebp
  801ae2:	89 e5                	mov    %esp,%ebp
  801ae4:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ae7:	83 ec 04             	sub    $0x4,%esp
  801aea:	68 34 43 80 00       	push   $0x804334
  801aef:	68 13 01 00 00       	push   $0x113
  801af4:	68 33 42 80 00       	push   $0x804233
  801af9:	e8 20 ec ff ff       	call   80071e <_panic>

00801afe <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801afe:	55                   	push   %ebp
  801aff:	89 e5                	mov    %esp,%ebp
  801b01:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801b04:	83 ec 04             	sub    $0x4,%esp
  801b07:	68 34 43 80 00       	push   $0x804334
  801b0c:	68 18 01 00 00       	push   $0x118
  801b11:	68 33 42 80 00       	push   $0x804233
  801b16:	e8 03 ec ff ff       	call   80071e <_panic>

00801b1b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801b1b:	55                   	push   %ebp
  801b1c:	89 e5                	mov    %esp,%ebp
  801b1e:	57                   	push   %edi
  801b1f:	56                   	push   %esi
  801b20:	53                   	push   %ebx
  801b21:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801b24:	8b 45 08             	mov    0x8(%ebp),%eax
  801b27:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b2a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b2d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b30:	8b 7d 18             	mov    0x18(%ebp),%edi
  801b33:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801b36:	cd 30                	int    $0x30
  801b38:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801b3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801b3e:	83 c4 10             	add    $0x10,%esp
  801b41:	5b                   	pop    %ebx
  801b42:	5e                   	pop    %esi
  801b43:	5f                   	pop    %edi
  801b44:	5d                   	pop    %ebp
  801b45:	c3                   	ret    

00801b46 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801b46:	55                   	push   %ebp
  801b47:	89 e5                	mov    %esp,%ebp
  801b49:	83 ec 04             	sub    $0x4,%esp
  801b4c:	8b 45 10             	mov    0x10(%ebp),%eax
  801b4f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801b52:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b56:	8b 45 08             	mov    0x8(%ebp),%eax
  801b59:	6a 00                	push   $0x0
  801b5b:	6a 00                	push   $0x0
  801b5d:	52                   	push   %edx
  801b5e:	ff 75 0c             	pushl  0xc(%ebp)
  801b61:	50                   	push   %eax
  801b62:	6a 00                	push   $0x0
  801b64:	e8 b2 ff ff ff       	call   801b1b <syscall>
  801b69:	83 c4 18             	add    $0x18,%esp
}
  801b6c:	90                   	nop
  801b6d:	c9                   	leave  
  801b6e:	c3                   	ret    

00801b6f <sys_cgetc>:

int
sys_cgetc(void)
{
  801b6f:	55                   	push   %ebp
  801b70:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801b72:	6a 00                	push   $0x0
  801b74:	6a 00                	push   $0x0
  801b76:	6a 00                	push   $0x0
  801b78:	6a 00                	push   $0x0
  801b7a:	6a 00                	push   $0x0
  801b7c:	6a 01                	push   $0x1
  801b7e:	e8 98 ff ff ff       	call   801b1b <syscall>
  801b83:	83 c4 18             	add    $0x18,%esp
}
  801b86:	c9                   	leave  
  801b87:	c3                   	ret    

00801b88 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801b88:	55                   	push   %ebp
  801b89:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801b8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b91:	6a 00                	push   $0x0
  801b93:	6a 00                	push   $0x0
  801b95:	6a 00                	push   $0x0
  801b97:	52                   	push   %edx
  801b98:	50                   	push   %eax
  801b99:	6a 05                	push   $0x5
  801b9b:	e8 7b ff ff ff       	call   801b1b <syscall>
  801ba0:	83 c4 18             	add    $0x18,%esp
}
  801ba3:	c9                   	leave  
  801ba4:	c3                   	ret    

00801ba5 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801ba5:	55                   	push   %ebp
  801ba6:	89 e5                	mov    %esp,%ebp
  801ba8:	56                   	push   %esi
  801ba9:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801baa:	8b 75 18             	mov    0x18(%ebp),%esi
  801bad:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801bb0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bb3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bb6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb9:	56                   	push   %esi
  801bba:	53                   	push   %ebx
  801bbb:	51                   	push   %ecx
  801bbc:	52                   	push   %edx
  801bbd:	50                   	push   %eax
  801bbe:	6a 06                	push   $0x6
  801bc0:	e8 56 ff ff ff       	call   801b1b <syscall>
  801bc5:	83 c4 18             	add    $0x18,%esp
}
  801bc8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bcb:	5b                   	pop    %ebx
  801bcc:	5e                   	pop    %esi
  801bcd:	5d                   	pop    %ebp
  801bce:	c3                   	ret    

00801bcf <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801bcf:	55                   	push   %ebp
  801bd0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801bd2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bd5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 00                	push   $0x0
  801bdc:	6a 00                	push   $0x0
  801bde:	52                   	push   %edx
  801bdf:	50                   	push   %eax
  801be0:	6a 07                	push   $0x7
  801be2:	e8 34 ff ff ff       	call   801b1b <syscall>
  801be7:	83 c4 18             	add    $0x18,%esp
}
  801bea:	c9                   	leave  
  801beb:	c3                   	ret    

00801bec <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801bec:	55                   	push   %ebp
  801bed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801bef:	6a 00                	push   $0x0
  801bf1:	6a 00                	push   $0x0
  801bf3:	6a 00                	push   $0x0
  801bf5:	ff 75 0c             	pushl  0xc(%ebp)
  801bf8:	ff 75 08             	pushl  0x8(%ebp)
  801bfb:	6a 08                	push   $0x8
  801bfd:	e8 19 ff ff ff       	call   801b1b <syscall>
  801c02:	83 c4 18             	add    $0x18,%esp
}
  801c05:	c9                   	leave  
  801c06:	c3                   	ret    

00801c07 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801c07:	55                   	push   %ebp
  801c08:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801c0a:	6a 00                	push   $0x0
  801c0c:	6a 00                	push   $0x0
  801c0e:	6a 00                	push   $0x0
  801c10:	6a 00                	push   $0x0
  801c12:	6a 00                	push   $0x0
  801c14:	6a 09                	push   $0x9
  801c16:	e8 00 ff ff ff       	call   801b1b <syscall>
  801c1b:	83 c4 18             	add    $0x18,%esp
}
  801c1e:	c9                   	leave  
  801c1f:	c3                   	ret    

00801c20 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801c20:	55                   	push   %ebp
  801c21:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801c23:	6a 00                	push   $0x0
  801c25:	6a 00                	push   $0x0
  801c27:	6a 00                	push   $0x0
  801c29:	6a 00                	push   $0x0
  801c2b:	6a 00                	push   $0x0
  801c2d:	6a 0a                	push   $0xa
  801c2f:	e8 e7 fe ff ff       	call   801b1b <syscall>
  801c34:	83 c4 18             	add    $0x18,%esp
}
  801c37:	c9                   	leave  
  801c38:	c3                   	ret    

00801c39 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801c39:	55                   	push   %ebp
  801c3a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801c3c:	6a 00                	push   $0x0
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 00                	push   $0x0
  801c42:	6a 00                	push   $0x0
  801c44:	6a 00                	push   $0x0
  801c46:	6a 0b                	push   $0xb
  801c48:	e8 ce fe ff ff       	call   801b1b <syscall>
  801c4d:	83 c4 18             	add    $0x18,%esp
}
  801c50:	c9                   	leave  
  801c51:	c3                   	ret    

00801c52 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801c52:	55                   	push   %ebp
  801c53:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801c55:	6a 00                	push   $0x0
  801c57:	6a 00                	push   $0x0
  801c59:	6a 00                	push   $0x0
  801c5b:	ff 75 0c             	pushl  0xc(%ebp)
  801c5e:	ff 75 08             	pushl  0x8(%ebp)
  801c61:	6a 0f                	push   $0xf
  801c63:	e8 b3 fe ff ff       	call   801b1b <syscall>
  801c68:	83 c4 18             	add    $0x18,%esp
	return;
  801c6b:	90                   	nop
}
  801c6c:	c9                   	leave  
  801c6d:	c3                   	ret    

00801c6e <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801c6e:	55                   	push   %ebp
  801c6f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801c71:	6a 00                	push   $0x0
  801c73:	6a 00                	push   $0x0
  801c75:	6a 00                	push   $0x0
  801c77:	ff 75 0c             	pushl  0xc(%ebp)
  801c7a:	ff 75 08             	pushl  0x8(%ebp)
  801c7d:	6a 10                	push   $0x10
  801c7f:	e8 97 fe ff ff       	call   801b1b <syscall>
  801c84:	83 c4 18             	add    $0x18,%esp
	return ;
  801c87:	90                   	nop
}
  801c88:	c9                   	leave  
  801c89:	c3                   	ret    

00801c8a <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801c8a:	55                   	push   %ebp
  801c8b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801c8d:	6a 00                	push   $0x0
  801c8f:	6a 00                	push   $0x0
  801c91:	ff 75 10             	pushl  0x10(%ebp)
  801c94:	ff 75 0c             	pushl  0xc(%ebp)
  801c97:	ff 75 08             	pushl  0x8(%ebp)
  801c9a:	6a 11                	push   $0x11
  801c9c:	e8 7a fe ff ff       	call   801b1b <syscall>
  801ca1:	83 c4 18             	add    $0x18,%esp
	return ;
  801ca4:	90                   	nop
}
  801ca5:	c9                   	leave  
  801ca6:	c3                   	ret    

00801ca7 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801ca7:	55                   	push   %ebp
  801ca8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801caa:	6a 00                	push   $0x0
  801cac:	6a 00                	push   $0x0
  801cae:	6a 00                	push   $0x0
  801cb0:	6a 00                	push   $0x0
  801cb2:	6a 00                	push   $0x0
  801cb4:	6a 0c                	push   $0xc
  801cb6:	e8 60 fe ff ff       	call   801b1b <syscall>
  801cbb:	83 c4 18             	add    $0x18,%esp
}
  801cbe:	c9                   	leave  
  801cbf:	c3                   	ret    

00801cc0 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801cc0:	55                   	push   %ebp
  801cc1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801cc3:	6a 00                	push   $0x0
  801cc5:	6a 00                	push   $0x0
  801cc7:	6a 00                	push   $0x0
  801cc9:	6a 00                	push   $0x0
  801ccb:	ff 75 08             	pushl  0x8(%ebp)
  801cce:	6a 0d                	push   $0xd
  801cd0:	e8 46 fe ff ff       	call   801b1b <syscall>
  801cd5:	83 c4 18             	add    $0x18,%esp
}
  801cd8:	c9                   	leave  
  801cd9:	c3                   	ret    

00801cda <sys_scarce_memory>:

void sys_scarce_memory()
{
  801cda:	55                   	push   %ebp
  801cdb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801cdd:	6a 00                	push   $0x0
  801cdf:	6a 00                	push   $0x0
  801ce1:	6a 00                	push   $0x0
  801ce3:	6a 00                	push   $0x0
  801ce5:	6a 00                	push   $0x0
  801ce7:	6a 0e                	push   $0xe
  801ce9:	e8 2d fe ff ff       	call   801b1b <syscall>
  801cee:	83 c4 18             	add    $0x18,%esp
}
  801cf1:	90                   	nop
  801cf2:	c9                   	leave  
  801cf3:	c3                   	ret    

00801cf4 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801cf4:	55                   	push   %ebp
  801cf5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801cf7:	6a 00                	push   $0x0
  801cf9:	6a 00                	push   $0x0
  801cfb:	6a 00                	push   $0x0
  801cfd:	6a 00                	push   $0x0
  801cff:	6a 00                	push   $0x0
  801d01:	6a 13                	push   $0x13
  801d03:	e8 13 fe ff ff       	call   801b1b <syscall>
  801d08:	83 c4 18             	add    $0x18,%esp
}
  801d0b:	90                   	nop
  801d0c:	c9                   	leave  
  801d0d:	c3                   	ret    

00801d0e <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801d0e:	55                   	push   %ebp
  801d0f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801d11:	6a 00                	push   $0x0
  801d13:	6a 00                	push   $0x0
  801d15:	6a 00                	push   $0x0
  801d17:	6a 00                	push   $0x0
  801d19:	6a 00                	push   $0x0
  801d1b:	6a 14                	push   $0x14
  801d1d:	e8 f9 fd ff ff       	call   801b1b <syscall>
  801d22:	83 c4 18             	add    $0x18,%esp
}
  801d25:	90                   	nop
  801d26:	c9                   	leave  
  801d27:	c3                   	ret    

00801d28 <sys_cputc>:


void
sys_cputc(const char c)
{
  801d28:	55                   	push   %ebp
  801d29:	89 e5                	mov    %esp,%ebp
  801d2b:	83 ec 04             	sub    $0x4,%esp
  801d2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d31:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801d34:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d38:	6a 00                	push   $0x0
  801d3a:	6a 00                	push   $0x0
  801d3c:	6a 00                	push   $0x0
  801d3e:	6a 00                	push   $0x0
  801d40:	50                   	push   %eax
  801d41:	6a 15                	push   $0x15
  801d43:	e8 d3 fd ff ff       	call   801b1b <syscall>
  801d48:	83 c4 18             	add    $0x18,%esp
}
  801d4b:	90                   	nop
  801d4c:	c9                   	leave  
  801d4d:	c3                   	ret    

00801d4e <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801d4e:	55                   	push   %ebp
  801d4f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801d51:	6a 00                	push   $0x0
  801d53:	6a 00                	push   $0x0
  801d55:	6a 00                	push   $0x0
  801d57:	6a 00                	push   $0x0
  801d59:	6a 00                	push   $0x0
  801d5b:	6a 16                	push   $0x16
  801d5d:	e8 b9 fd ff ff       	call   801b1b <syscall>
  801d62:	83 c4 18             	add    $0x18,%esp
}
  801d65:	90                   	nop
  801d66:	c9                   	leave  
  801d67:	c3                   	ret    

00801d68 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801d68:	55                   	push   %ebp
  801d69:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6e:	6a 00                	push   $0x0
  801d70:	6a 00                	push   $0x0
  801d72:	6a 00                	push   $0x0
  801d74:	ff 75 0c             	pushl  0xc(%ebp)
  801d77:	50                   	push   %eax
  801d78:	6a 17                	push   $0x17
  801d7a:	e8 9c fd ff ff       	call   801b1b <syscall>
  801d7f:	83 c4 18             	add    $0x18,%esp
}
  801d82:	c9                   	leave  
  801d83:	c3                   	ret    

00801d84 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801d84:	55                   	push   %ebp
  801d85:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d87:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8d:	6a 00                	push   $0x0
  801d8f:	6a 00                	push   $0x0
  801d91:	6a 00                	push   $0x0
  801d93:	52                   	push   %edx
  801d94:	50                   	push   %eax
  801d95:	6a 1a                	push   $0x1a
  801d97:	e8 7f fd ff ff       	call   801b1b <syscall>
  801d9c:	83 c4 18             	add    $0x18,%esp
}
  801d9f:	c9                   	leave  
  801da0:	c3                   	ret    

00801da1 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801da1:	55                   	push   %ebp
  801da2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801da4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801da7:	8b 45 08             	mov    0x8(%ebp),%eax
  801daa:	6a 00                	push   $0x0
  801dac:	6a 00                	push   $0x0
  801dae:	6a 00                	push   $0x0
  801db0:	52                   	push   %edx
  801db1:	50                   	push   %eax
  801db2:	6a 18                	push   $0x18
  801db4:	e8 62 fd ff ff       	call   801b1b <syscall>
  801db9:	83 c4 18             	add    $0x18,%esp
}
  801dbc:	90                   	nop
  801dbd:	c9                   	leave  
  801dbe:	c3                   	ret    

00801dbf <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801dbf:	55                   	push   %ebp
  801dc0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801dc2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dc5:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc8:	6a 00                	push   $0x0
  801dca:	6a 00                	push   $0x0
  801dcc:	6a 00                	push   $0x0
  801dce:	52                   	push   %edx
  801dcf:	50                   	push   %eax
  801dd0:	6a 19                	push   $0x19
  801dd2:	e8 44 fd ff ff       	call   801b1b <syscall>
  801dd7:	83 c4 18             	add    $0x18,%esp
}
  801dda:	90                   	nop
  801ddb:	c9                   	leave  
  801ddc:	c3                   	ret    

00801ddd <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801ddd:	55                   	push   %ebp
  801dde:	89 e5                	mov    %esp,%ebp
  801de0:	83 ec 04             	sub    $0x4,%esp
  801de3:	8b 45 10             	mov    0x10(%ebp),%eax
  801de6:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801de9:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801dec:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801df0:	8b 45 08             	mov    0x8(%ebp),%eax
  801df3:	6a 00                	push   $0x0
  801df5:	51                   	push   %ecx
  801df6:	52                   	push   %edx
  801df7:	ff 75 0c             	pushl  0xc(%ebp)
  801dfa:	50                   	push   %eax
  801dfb:	6a 1b                	push   $0x1b
  801dfd:	e8 19 fd ff ff       	call   801b1b <syscall>
  801e02:	83 c4 18             	add    $0x18,%esp
}
  801e05:	c9                   	leave  
  801e06:	c3                   	ret    

00801e07 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801e07:	55                   	push   %ebp
  801e08:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801e0a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e10:	6a 00                	push   $0x0
  801e12:	6a 00                	push   $0x0
  801e14:	6a 00                	push   $0x0
  801e16:	52                   	push   %edx
  801e17:	50                   	push   %eax
  801e18:	6a 1c                	push   $0x1c
  801e1a:	e8 fc fc ff ff       	call   801b1b <syscall>
  801e1f:	83 c4 18             	add    $0x18,%esp
}
  801e22:	c9                   	leave  
  801e23:	c3                   	ret    

00801e24 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801e24:	55                   	push   %ebp
  801e25:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801e27:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e30:	6a 00                	push   $0x0
  801e32:	6a 00                	push   $0x0
  801e34:	51                   	push   %ecx
  801e35:	52                   	push   %edx
  801e36:	50                   	push   %eax
  801e37:	6a 1d                	push   $0x1d
  801e39:	e8 dd fc ff ff       	call   801b1b <syscall>
  801e3e:	83 c4 18             	add    $0x18,%esp
}
  801e41:	c9                   	leave  
  801e42:	c3                   	ret    

00801e43 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801e43:	55                   	push   %ebp
  801e44:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801e46:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e49:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4c:	6a 00                	push   $0x0
  801e4e:	6a 00                	push   $0x0
  801e50:	6a 00                	push   $0x0
  801e52:	52                   	push   %edx
  801e53:	50                   	push   %eax
  801e54:	6a 1e                	push   $0x1e
  801e56:	e8 c0 fc ff ff       	call   801b1b <syscall>
  801e5b:	83 c4 18             	add    $0x18,%esp
}
  801e5e:	c9                   	leave  
  801e5f:	c3                   	ret    

00801e60 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801e60:	55                   	push   %ebp
  801e61:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801e63:	6a 00                	push   $0x0
  801e65:	6a 00                	push   $0x0
  801e67:	6a 00                	push   $0x0
  801e69:	6a 00                	push   $0x0
  801e6b:	6a 00                	push   $0x0
  801e6d:	6a 1f                	push   $0x1f
  801e6f:	e8 a7 fc ff ff       	call   801b1b <syscall>
  801e74:	83 c4 18             	add    $0x18,%esp
}
  801e77:	c9                   	leave  
  801e78:	c3                   	ret    

00801e79 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801e79:	55                   	push   %ebp
  801e7a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801e7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7f:	6a 00                	push   $0x0
  801e81:	ff 75 14             	pushl  0x14(%ebp)
  801e84:	ff 75 10             	pushl  0x10(%ebp)
  801e87:	ff 75 0c             	pushl  0xc(%ebp)
  801e8a:	50                   	push   %eax
  801e8b:	6a 20                	push   $0x20
  801e8d:	e8 89 fc ff ff       	call   801b1b <syscall>
  801e92:	83 c4 18             	add    $0x18,%esp
}
  801e95:	c9                   	leave  
  801e96:	c3                   	ret    

00801e97 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801e97:	55                   	push   %ebp
  801e98:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801e9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9d:	6a 00                	push   $0x0
  801e9f:	6a 00                	push   $0x0
  801ea1:	6a 00                	push   $0x0
  801ea3:	6a 00                	push   $0x0
  801ea5:	50                   	push   %eax
  801ea6:	6a 21                	push   $0x21
  801ea8:	e8 6e fc ff ff       	call   801b1b <syscall>
  801ead:	83 c4 18             	add    $0x18,%esp
}
  801eb0:	90                   	nop
  801eb1:	c9                   	leave  
  801eb2:	c3                   	ret    

00801eb3 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801eb3:	55                   	push   %ebp
  801eb4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801eb6:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb9:	6a 00                	push   $0x0
  801ebb:	6a 00                	push   $0x0
  801ebd:	6a 00                	push   $0x0
  801ebf:	6a 00                	push   $0x0
  801ec1:	50                   	push   %eax
  801ec2:	6a 22                	push   $0x22
  801ec4:	e8 52 fc ff ff       	call   801b1b <syscall>
  801ec9:	83 c4 18             	add    $0x18,%esp
}
  801ecc:	c9                   	leave  
  801ecd:	c3                   	ret    

00801ece <sys_getenvid>:

int32 sys_getenvid(void)
{
  801ece:	55                   	push   %ebp
  801ecf:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801ed1:	6a 00                	push   $0x0
  801ed3:	6a 00                	push   $0x0
  801ed5:	6a 00                	push   $0x0
  801ed7:	6a 00                	push   $0x0
  801ed9:	6a 00                	push   $0x0
  801edb:	6a 02                	push   $0x2
  801edd:	e8 39 fc ff ff       	call   801b1b <syscall>
  801ee2:	83 c4 18             	add    $0x18,%esp
}
  801ee5:	c9                   	leave  
  801ee6:	c3                   	ret    

00801ee7 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801ee7:	55                   	push   %ebp
  801ee8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801eea:	6a 00                	push   $0x0
  801eec:	6a 00                	push   $0x0
  801eee:	6a 00                	push   $0x0
  801ef0:	6a 00                	push   $0x0
  801ef2:	6a 00                	push   $0x0
  801ef4:	6a 03                	push   $0x3
  801ef6:	e8 20 fc ff ff       	call   801b1b <syscall>
  801efb:	83 c4 18             	add    $0x18,%esp
}
  801efe:	c9                   	leave  
  801eff:	c3                   	ret    

00801f00 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801f00:	55                   	push   %ebp
  801f01:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801f03:	6a 00                	push   $0x0
  801f05:	6a 00                	push   $0x0
  801f07:	6a 00                	push   $0x0
  801f09:	6a 00                	push   $0x0
  801f0b:	6a 00                	push   $0x0
  801f0d:	6a 04                	push   $0x4
  801f0f:	e8 07 fc ff ff       	call   801b1b <syscall>
  801f14:	83 c4 18             	add    $0x18,%esp
}
  801f17:	c9                   	leave  
  801f18:	c3                   	ret    

00801f19 <sys_exit_env>:


void sys_exit_env(void)
{
  801f19:	55                   	push   %ebp
  801f1a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801f1c:	6a 00                	push   $0x0
  801f1e:	6a 00                	push   $0x0
  801f20:	6a 00                	push   $0x0
  801f22:	6a 00                	push   $0x0
  801f24:	6a 00                	push   $0x0
  801f26:	6a 23                	push   $0x23
  801f28:	e8 ee fb ff ff       	call   801b1b <syscall>
  801f2d:	83 c4 18             	add    $0x18,%esp
}
  801f30:	90                   	nop
  801f31:	c9                   	leave  
  801f32:	c3                   	ret    

00801f33 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801f33:	55                   	push   %ebp
  801f34:	89 e5                	mov    %esp,%ebp
  801f36:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801f39:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f3c:	8d 50 04             	lea    0x4(%eax),%edx
  801f3f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f42:	6a 00                	push   $0x0
  801f44:	6a 00                	push   $0x0
  801f46:	6a 00                	push   $0x0
  801f48:	52                   	push   %edx
  801f49:	50                   	push   %eax
  801f4a:	6a 24                	push   $0x24
  801f4c:	e8 ca fb ff ff       	call   801b1b <syscall>
  801f51:	83 c4 18             	add    $0x18,%esp
	return result;
  801f54:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f57:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f5a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801f5d:	89 01                	mov    %eax,(%ecx)
  801f5f:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801f62:	8b 45 08             	mov    0x8(%ebp),%eax
  801f65:	c9                   	leave  
  801f66:	c2 04 00             	ret    $0x4

00801f69 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801f69:	55                   	push   %ebp
  801f6a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801f6c:	6a 00                	push   $0x0
  801f6e:	6a 00                	push   $0x0
  801f70:	ff 75 10             	pushl  0x10(%ebp)
  801f73:	ff 75 0c             	pushl  0xc(%ebp)
  801f76:	ff 75 08             	pushl  0x8(%ebp)
  801f79:	6a 12                	push   $0x12
  801f7b:	e8 9b fb ff ff       	call   801b1b <syscall>
  801f80:	83 c4 18             	add    $0x18,%esp
	return ;
  801f83:	90                   	nop
}
  801f84:	c9                   	leave  
  801f85:	c3                   	ret    

00801f86 <sys_rcr2>:
uint32 sys_rcr2()
{
  801f86:	55                   	push   %ebp
  801f87:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801f89:	6a 00                	push   $0x0
  801f8b:	6a 00                	push   $0x0
  801f8d:	6a 00                	push   $0x0
  801f8f:	6a 00                	push   $0x0
  801f91:	6a 00                	push   $0x0
  801f93:	6a 25                	push   $0x25
  801f95:	e8 81 fb ff ff       	call   801b1b <syscall>
  801f9a:	83 c4 18             	add    $0x18,%esp
}
  801f9d:	c9                   	leave  
  801f9e:	c3                   	ret    

00801f9f <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801f9f:	55                   	push   %ebp
  801fa0:	89 e5                	mov    %esp,%ebp
  801fa2:	83 ec 04             	sub    $0x4,%esp
  801fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801fab:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801faf:	6a 00                	push   $0x0
  801fb1:	6a 00                	push   $0x0
  801fb3:	6a 00                	push   $0x0
  801fb5:	6a 00                	push   $0x0
  801fb7:	50                   	push   %eax
  801fb8:	6a 26                	push   $0x26
  801fba:	e8 5c fb ff ff       	call   801b1b <syscall>
  801fbf:	83 c4 18             	add    $0x18,%esp
	return ;
  801fc2:	90                   	nop
}
  801fc3:	c9                   	leave  
  801fc4:	c3                   	ret    

00801fc5 <rsttst>:
void rsttst()
{
  801fc5:	55                   	push   %ebp
  801fc6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801fc8:	6a 00                	push   $0x0
  801fca:	6a 00                	push   $0x0
  801fcc:	6a 00                	push   $0x0
  801fce:	6a 00                	push   $0x0
  801fd0:	6a 00                	push   $0x0
  801fd2:	6a 28                	push   $0x28
  801fd4:	e8 42 fb ff ff       	call   801b1b <syscall>
  801fd9:	83 c4 18             	add    $0x18,%esp
	return ;
  801fdc:	90                   	nop
}
  801fdd:	c9                   	leave  
  801fde:	c3                   	ret    

00801fdf <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801fdf:	55                   	push   %ebp
  801fe0:	89 e5                	mov    %esp,%ebp
  801fe2:	83 ec 04             	sub    $0x4,%esp
  801fe5:	8b 45 14             	mov    0x14(%ebp),%eax
  801fe8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801feb:	8b 55 18             	mov    0x18(%ebp),%edx
  801fee:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ff2:	52                   	push   %edx
  801ff3:	50                   	push   %eax
  801ff4:	ff 75 10             	pushl  0x10(%ebp)
  801ff7:	ff 75 0c             	pushl  0xc(%ebp)
  801ffa:	ff 75 08             	pushl  0x8(%ebp)
  801ffd:	6a 27                	push   $0x27
  801fff:	e8 17 fb ff ff       	call   801b1b <syscall>
  802004:	83 c4 18             	add    $0x18,%esp
	return ;
  802007:	90                   	nop
}
  802008:	c9                   	leave  
  802009:	c3                   	ret    

0080200a <chktst>:
void chktst(uint32 n)
{
  80200a:	55                   	push   %ebp
  80200b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80200d:	6a 00                	push   $0x0
  80200f:	6a 00                	push   $0x0
  802011:	6a 00                	push   $0x0
  802013:	6a 00                	push   $0x0
  802015:	ff 75 08             	pushl  0x8(%ebp)
  802018:	6a 29                	push   $0x29
  80201a:	e8 fc fa ff ff       	call   801b1b <syscall>
  80201f:	83 c4 18             	add    $0x18,%esp
	return ;
  802022:	90                   	nop
}
  802023:	c9                   	leave  
  802024:	c3                   	ret    

00802025 <inctst>:

void inctst()
{
  802025:	55                   	push   %ebp
  802026:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802028:	6a 00                	push   $0x0
  80202a:	6a 00                	push   $0x0
  80202c:	6a 00                	push   $0x0
  80202e:	6a 00                	push   $0x0
  802030:	6a 00                	push   $0x0
  802032:	6a 2a                	push   $0x2a
  802034:	e8 e2 fa ff ff       	call   801b1b <syscall>
  802039:	83 c4 18             	add    $0x18,%esp
	return ;
  80203c:	90                   	nop
}
  80203d:	c9                   	leave  
  80203e:	c3                   	ret    

0080203f <gettst>:
uint32 gettst()
{
  80203f:	55                   	push   %ebp
  802040:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802042:	6a 00                	push   $0x0
  802044:	6a 00                	push   $0x0
  802046:	6a 00                	push   $0x0
  802048:	6a 00                	push   $0x0
  80204a:	6a 00                	push   $0x0
  80204c:	6a 2b                	push   $0x2b
  80204e:	e8 c8 fa ff ff       	call   801b1b <syscall>
  802053:	83 c4 18             	add    $0x18,%esp
}
  802056:	c9                   	leave  
  802057:	c3                   	ret    

00802058 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802058:	55                   	push   %ebp
  802059:	89 e5                	mov    %esp,%ebp
  80205b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80205e:	6a 00                	push   $0x0
  802060:	6a 00                	push   $0x0
  802062:	6a 00                	push   $0x0
  802064:	6a 00                	push   $0x0
  802066:	6a 00                	push   $0x0
  802068:	6a 2c                	push   $0x2c
  80206a:	e8 ac fa ff ff       	call   801b1b <syscall>
  80206f:	83 c4 18             	add    $0x18,%esp
  802072:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802075:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802079:	75 07                	jne    802082 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80207b:	b8 01 00 00 00       	mov    $0x1,%eax
  802080:	eb 05                	jmp    802087 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802082:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802087:	c9                   	leave  
  802088:	c3                   	ret    

00802089 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802089:	55                   	push   %ebp
  80208a:	89 e5                	mov    %esp,%ebp
  80208c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80208f:	6a 00                	push   $0x0
  802091:	6a 00                	push   $0x0
  802093:	6a 00                	push   $0x0
  802095:	6a 00                	push   $0x0
  802097:	6a 00                	push   $0x0
  802099:	6a 2c                	push   $0x2c
  80209b:	e8 7b fa ff ff       	call   801b1b <syscall>
  8020a0:	83 c4 18             	add    $0x18,%esp
  8020a3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8020a6:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8020aa:	75 07                	jne    8020b3 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8020ac:	b8 01 00 00 00       	mov    $0x1,%eax
  8020b1:	eb 05                	jmp    8020b8 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8020b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020b8:	c9                   	leave  
  8020b9:	c3                   	ret    

008020ba <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8020ba:	55                   	push   %ebp
  8020bb:	89 e5                	mov    %esp,%ebp
  8020bd:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020c0:	6a 00                	push   $0x0
  8020c2:	6a 00                	push   $0x0
  8020c4:	6a 00                	push   $0x0
  8020c6:	6a 00                	push   $0x0
  8020c8:	6a 00                	push   $0x0
  8020ca:	6a 2c                	push   $0x2c
  8020cc:	e8 4a fa ff ff       	call   801b1b <syscall>
  8020d1:	83 c4 18             	add    $0x18,%esp
  8020d4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8020d7:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8020db:	75 07                	jne    8020e4 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8020dd:	b8 01 00 00 00       	mov    $0x1,%eax
  8020e2:	eb 05                	jmp    8020e9 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8020e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020e9:	c9                   	leave  
  8020ea:	c3                   	ret    

008020eb <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8020eb:	55                   	push   %ebp
  8020ec:	89 e5                	mov    %esp,%ebp
  8020ee:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020f1:	6a 00                	push   $0x0
  8020f3:	6a 00                	push   $0x0
  8020f5:	6a 00                	push   $0x0
  8020f7:	6a 00                	push   $0x0
  8020f9:	6a 00                	push   $0x0
  8020fb:	6a 2c                	push   $0x2c
  8020fd:	e8 19 fa ff ff       	call   801b1b <syscall>
  802102:	83 c4 18             	add    $0x18,%esp
  802105:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802108:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80210c:	75 07                	jne    802115 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80210e:	b8 01 00 00 00       	mov    $0x1,%eax
  802113:	eb 05                	jmp    80211a <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802115:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80211a:	c9                   	leave  
  80211b:	c3                   	ret    

0080211c <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80211c:	55                   	push   %ebp
  80211d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80211f:	6a 00                	push   $0x0
  802121:	6a 00                	push   $0x0
  802123:	6a 00                	push   $0x0
  802125:	6a 00                	push   $0x0
  802127:	ff 75 08             	pushl  0x8(%ebp)
  80212a:	6a 2d                	push   $0x2d
  80212c:	e8 ea f9 ff ff       	call   801b1b <syscall>
  802131:	83 c4 18             	add    $0x18,%esp
	return ;
  802134:	90                   	nop
}
  802135:	c9                   	leave  
  802136:	c3                   	ret    

00802137 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802137:	55                   	push   %ebp
  802138:	89 e5                	mov    %esp,%ebp
  80213a:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80213b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80213e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802141:	8b 55 0c             	mov    0xc(%ebp),%edx
  802144:	8b 45 08             	mov    0x8(%ebp),%eax
  802147:	6a 00                	push   $0x0
  802149:	53                   	push   %ebx
  80214a:	51                   	push   %ecx
  80214b:	52                   	push   %edx
  80214c:	50                   	push   %eax
  80214d:	6a 2e                	push   $0x2e
  80214f:	e8 c7 f9 ff ff       	call   801b1b <syscall>
  802154:	83 c4 18             	add    $0x18,%esp
}
  802157:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80215a:	c9                   	leave  
  80215b:	c3                   	ret    

0080215c <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80215c:	55                   	push   %ebp
  80215d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80215f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802162:	8b 45 08             	mov    0x8(%ebp),%eax
  802165:	6a 00                	push   $0x0
  802167:	6a 00                	push   $0x0
  802169:	6a 00                	push   $0x0
  80216b:	52                   	push   %edx
  80216c:	50                   	push   %eax
  80216d:	6a 2f                	push   $0x2f
  80216f:	e8 a7 f9 ff ff       	call   801b1b <syscall>
  802174:	83 c4 18             	add    $0x18,%esp
}
  802177:	c9                   	leave  
  802178:	c3                   	ret    

00802179 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802179:	55                   	push   %ebp
  80217a:	89 e5                	mov    %esp,%ebp
  80217c:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  80217f:	83 ec 0c             	sub    $0xc,%esp
  802182:	68 44 43 80 00       	push   $0x804344
  802187:	e8 46 e8 ff ff       	call   8009d2 <cprintf>
  80218c:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80218f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802196:	83 ec 0c             	sub    $0xc,%esp
  802199:	68 70 43 80 00       	push   $0x804370
  80219e:	e8 2f e8 ff ff       	call   8009d2 <cprintf>
  8021a3:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8021a6:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8021aa:	a1 38 51 80 00       	mov    0x805138,%eax
  8021af:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021b2:	eb 56                	jmp    80220a <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8021b4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021b8:	74 1c                	je     8021d6 <print_mem_block_lists+0x5d>
  8021ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021bd:	8b 50 08             	mov    0x8(%eax),%edx
  8021c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021c3:	8b 48 08             	mov    0x8(%eax),%ecx
  8021c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021c9:	8b 40 0c             	mov    0xc(%eax),%eax
  8021cc:	01 c8                	add    %ecx,%eax
  8021ce:	39 c2                	cmp    %eax,%edx
  8021d0:	73 04                	jae    8021d6 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8021d2:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8021d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d9:	8b 50 08             	mov    0x8(%eax),%edx
  8021dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021df:	8b 40 0c             	mov    0xc(%eax),%eax
  8021e2:	01 c2                	add    %eax,%edx
  8021e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e7:	8b 40 08             	mov    0x8(%eax),%eax
  8021ea:	83 ec 04             	sub    $0x4,%esp
  8021ed:	52                   	push   %edx
  8021ee:	50                   	push   %eax
  8021ef:	68 85 43 80 00       	push   $0x804385
  8021f4:	e8 d9 e7 ff ff       	call   8009d2 <cprintf>
  8021f9:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8021fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802202:	a1 40 51 80 00       	mov    0x805140,%eax
  802207:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80220a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80220e:	74 07                	je     802217 <print_mem_block_lists+0x9e>
  802210:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802213:	8b 00                	mov    (%eax),%eax
  802215:	eb 05                	jmp    80221c <print_mem_block_lists+0xa3>
  802217:	b8 00 00 00 00       	mov    $0x0,%eax
  80221c:	a3 40 51 80 00       	mov    %eax,0x805140
  802221:	a1 40 51 80 00       	mov    0x805140,%eax
  802226:	85 c0                	test   %eax,%eax
  802228:	75 8a                	jne    8021b4 <print_mem_block_lists+0x3b>
  80222a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80222e:	75 84                	jne    8021b4 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802230:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802234:	75 10                	jne    802246 <print_mem_block_lists+0xcd>
  802236:	83 ec 0c             	sub    $0xc,%esp
  802239:	68 94 43 80 00       	push   $0x804394
  80223e:	e8 8f e7 ff ff       	call   8009d2 <cprintf>
  802243:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802246:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80224d:	83 ec 0c             	sub    $0xc,%esp
  802250:	68 b8 43 80 00       	push   $0x8043b8
  802255:	e8 78 e7 ff ff       	call   8009d2 <cprintf>
  80225a:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80225d:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802261:	a1 40 50 80 00       	mov    0x805040,%eax
  802266:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802269:	eb 56                	jmp    8022c1 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80226b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80226f:	74 1c                	je     80228d <print_mem_block_lists+0x114>
  802271:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802274:	8b 50 08             	mov    0x8(%eax),%edx
  802277:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80227a:	8b 48 08             	mov    0x8(%eax),%ecx
  80227d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802280:	8b 40 0c             	mov    0xc(%eax),%eax
  802283:	01 c8                	add    %ecx,%eax
  802285:	39 c2                	cmp    %eax,%edx
  802287:	73 04                	jae    80228d <print_mem_block_lists+0x114>
			sorted = 0 ;
  802289:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80228d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802290:	8b 50 08             	mov    0x8(%eax),%edx
  802293:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802296:	8b 40 0c             	mov    0xc(%eax),%eax
  802299:	01 c2                	add    %eax,%edx
  80229b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229e:	8b 40 08             	mov    0x8(%eax),%eax
  8022a1:	83 ec 04             	sub    $0x4,%esp
  8022a4:	52                   	push   %edx
  8022a5:	50                   	push   %eax
  8022a6:	68 85 43 80 00       	push   $0x804385
  8022ab:	e8 22 e7 ff ff       	call   8009d2 <cprintf>
  8022b0:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8022b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8022b9:	a1 48 50 80 00       	mov    0x805048,%eax
  8022be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022c5:	74 07                	je     8022ce <print_mem_block_lists+0x155>
  8022c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ca:	8b 00                	mov    (%eax),%eax
  8022cc:	eb 05                	jmp    8022d3 <print_mem_block_lists+0x15a>
  8022ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8022d3:	a3 48 50 80 00       	mov    %eax,0x805048
  8022d8:	a1 48 50 80 00       	mov    0x805048,%eax
  8022dd:	85 c0                	test   %eax,%eax
  8022df:	75 8a                	jne    80226b <print_mem_block_lists+0xf2>
  8022e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022e5:	75 84                	jne    80226b <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8022e7:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8022eb:	75 10                	jne    8022fd <print_mem_block_lists+0x184>
  8022ed:	83 ec 0c             	sub    $0xc,%esp
  8022f0:	68 d0 43 80 00       	push   $0x8043d0
  8022f5:	e8 d8 e6 ff ff       	call   8009d2 <cprintf>
  8022fa:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8022fd:	83 ec 0c             	sub    $0xc,%esp
  802300:	68 44 43 80 00       	push   $0x804344
  802305:	e8 c8 e6 ff ff       	call   8009d2 <cprintf>
  80230a:	83 c4 10             	add    $0x10,%esp

}
  80230d:	90                   	nop
  80230e:	c9                   	leave  
  80230f:	c3                   	ret    

00802310 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802310:	55                   	push   %ebp
  802311:	89 e5                	mov    %esp,%ebp
  802313:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  802316:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  80231d:	00 00 00 
  802320:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802327:	00 00 00 
  80232a:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802331:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  802334:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80233b:	e9 9e 00 00 00       	jmp    8023de <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802340:	a1 50 50 80 00       	mov    0x805050,%eax
  802345:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802348:	c1 e2 04             	shl    $0x4,%edx
  80234b:	01 d0                	add    %edx,%eax
  80234d:	85 c0                	test   %eax,%eax
  80234f:	75 14                	jne    802365 <initialize_MemBlocksList+0x55>
  802351:	83 ec 04             	sub    $0x4,%esp
  802354:	68 f8 43 80 00       	push   $0x8043f8
  802359:	6a 46                	push   $0x46
  80235b:	68 1b 44 80 00       	push   $0x80441b
  802360:	e8 b9 e3 ff ff       	call   80071e <_panic>
  802365:	a1 50 50 80 00       	mov    0x805050,%eax
  80236a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80236d:	c1 e2 04             	shl    $0x4,%edx
  802370:	01 d0                	add    %edx,%eax
  802372:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802378:	89 10                	mov    %edx,(%eax)
  80237a:	8b 00                	mov    (%eax),%eax
  80237c:	85 c0                	test   %eax,%eax
  80237e:	74 18                	je     802398 <initialize_MemBlocksList+0x88>
  802380:	a1 48 51 80 00       	mov    0x805148,%eax
  802385:	8b 15 50 50 80 00    	mov    0x805050,%edx
  80238b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80238e:	c1 e1 04             	shl    $0x4,%ecx
  802391:	01 ca                	add    %ecx,%edx
  802393:	89 50 04             	mov    %edx,0x4(%eax)
  802396:	eb 12                	jmp    8023aa <initialize_MemBlocksList+0x9a>
  802398:	a1 50 50 80 00       	mov    0x805050,%eax
  80239d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023a0:	c1 e2 04             	shl    $0x4,%edx
  8023a3:	01 d0                	add    %edx,%eax
  8023a5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8023aa:	a1 50 50 80 00       	mov    0x805050,%eax
  8023af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023b2:	c1 e2 04             	shl    $0x4,%edx
  8023b5:	01 d0                	add    %edx,%eax
  8023b7:	a3 48 51 80 00       	mov    %eax,0x805148
  8023bc:	a1 50 50 80 00       	mov    0x805050,%eax
  8023c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023c4:	c1 e2 04             	shl    $0x4,%edx
  8023c7:	01 d0                	add    %edx,%eax
  8023c9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023d0:	a1 54 51 80 00       	mov    0x805154,%eax
  8023d5:	40                   	inc    %eax
  8023d6:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  8023db:	ff 45 f4             	incl   -0xc(%ebp)
  8023de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023e4:	0f 82 56 ff ff ff    	jb     802340 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  8023ea:	90                   	nop
  8023eb:	c9                   	leave  
  8023ec:	c3                   	ret    

008023ed <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8023ed:	55                   	push   %ebp
  8023ee:	89 e5                	mov    %esp,%ebp
  8023f0:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8023f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f6:	8b 00                	mov    (%eax),%eax
  8023f8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8023fb:	eb 19                	jmp    802416 <find_block+0x29>
	{
		if(va==point->sva)
  8023fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802400:	8b 40 08             	mov    0x8(%eax),%eax
  802403:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802406:	75 05                	jne    80240d <find_block+0x20>
		   return point;
  802408:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80240b:	eb 36                	jmp    802443 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80240d:	8b 45 08             	mov    0x8(%ebp),%eax
  802410:	8b 40 08             	mov    0x8(%eax),%eax
  802413:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802416:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80241a:	74 07                	je     802423 <find_block+0x36>
  80241c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80241f:	8b 00                	mov    (%eax),%eax
  802421:	eb 05                	jmp    802428 <find_block+0x3b>
  802423:	b8 00 00 00 00       	mov    $0x0,%eax
  802428:	8b 55 08             	mov    0x8(%ebp),%edx
  80242b:	89 42 08             	mov    %eax,0x8(%edx)
  80242e:	8b 45 08             	mov    0x8(%ebp),%eax
  802431:	8b 40 08             	mov    0x8(%eax),%eax
  802434:	85 c0                	test   %eax,%eax
  802436:	75 c5                	jne    8023fd <find_block+0x10>
  802438:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80243c:	75 bf                	jne    8023fd <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  80243e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802443:	c9                   	leave  
  802444:	c3                   	ret    

00802445 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802445:	55                   	push   %ebp
  802446:	89 e5                	mov    %esp,%ebp
  802448:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  80244b:	a1 40 50 80 00       	mov    0x805040,%eax
  802450:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802453:	a1 44 50 80 00       	mov    0x805044,%eax
  802458:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  80245b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80245e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802461:	74 24                	je     802487 <insert_sorted_allocList+0x42>
  802463:	8b 45 08             	mov    0x8(%ebp),%eax
  802466:	8b 50 08             	mov    0x8(%eax),%edx
  802469:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80246c:	8b 40 08             	mov    0x8(%eax),%eax
  80246f:	39 c2                	cmp    %eax,%edx
  802471:	76 14                	jbe    802487 <insert_sorted_allocList+0x42>
  802473:	8b 45 08             	mov    0x8(%ebp),%eax
  802476:	8b 50 08             	mov    0x8(%eax),%edx
  802479:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80247c:	8b 40 08             	mov    0x8(%eax),%eax
  80247f:	39 c2                	cmp    %eax,%edx
  802481:	0f 82 60 01 00 00    	jb     8025e7 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802487:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80248b:	75 65                	jne    8024f2 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  80248d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802491:	75 14                	jne    8024a7 <insert_sorted_allocList+0x62>
  802493:	83 ec 04             	sub    $0x4,%esp
  802496:	68 f8 43 80 00       	push   $0x8043f8
  80249b:	6a 6b                	push   $0x6b
  80249d:	68 1b 44 80 00       	push   $0x80441b
  8024a2:	e8 77 e2 ff ff       	call   80071e <_panic>
  8024a7:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8024ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b0:	89 10                	mov    %edx,(%eax)
  8024b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b5:	8b 00                	mov    (%eax),%eax
  8024b7:	85 c0                	test   %eax,%eax
  8024b9:	74 0d                	je     8024c8 <insert_sorted_allocList+0x83>
  8024bb:	a1 40 50 80 00       	mov    0x805040,%eax
  8024c0:	8b 55 08             	mov    0x8(%ebp),%edx
  8024c3:	89 50 04             	mov    %edx,0x4(%eax)
  8024c6:	eb 08                	jmp    8024d0 <insert_sorted_allocList+0x8b>
  8024c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8024cb:	a3 44 50 80 00       	mov    %eax,0x805044
  8024d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d3:	a3 40 50 80 00       	mov    %eax,0x805040
  8024d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8024db:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024e2:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8024e7:	40                   	inc    %eax
  8024e8:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8024ed:	e9 dc 01 00 00       	jmp    8026ce <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8024f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f5:	8b 50 08             	mov    0x8(%eax),%edx
  8024f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024fb:	8b 40 08             	mov    0x8(%eax),%eax
  8024fe:	39 c2                	cmp    %eax,%edx
  802500:	77 6c                	ja     80256e <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802502:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802506:	74 06                	je     80250e <insert_sorted_allocList+0xc9>
  802508:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80250c:	75 14                	jne    802522 <insert_sorted_allocList+0xdd>
  80250e:	83 ec 04             	sub    $0x4,%esp
  802511:	68 34 44 80 00       	push   $0x804434
  802516:	6a 6f                	push   $0x6f
  802518:	68 1b 44 80 00       	push   $0x80441b
  80251d:	e8 fc e1 ff ff       	call   80071e <_panic>
  802522:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802525:	8b 50 04             	mov    0x4(%eax),%edx
  802528:	8b 45 08             	mov    0x8(%ebp),%eax
  80252b:	89 50 04             	mov    %edx,0x4(%eax)
  80252e:	8b 45 08             	mov    0x8(%ebp),%eax
  802531:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802534:	89 10                	mov    %edx,(%eax)
  802536:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802539:	8b 40 04             	mov    0x4(%eax),%eax
  80253c:	85 c0                	test   %eax,%eax
  80253e:	74 0d                	je     80254d <insert_sorted_allocList+0x108>
  802540:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802543:	8b 40 04             	mov    0x4(%eax),%eax
  802546:	8b 55 08             	mov    0x8(%ebp),%edx
  802549:	89 10                	mov    %edx,(%eax)
  80254b:	eb 08                	jmp    802555 <insert_sorted_allocList+0x110>
  80254d:	8b 45 08             	mov    0x8(%ebp),%eax
  802550:	a3 40 50 80 00       	mov    %eax,0x805040
  802555:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802558:	8b 55 08             	mov    0x8(%ebp),%edx
  80255b:	89 50 04             	mov    %edx,0x4(%eax)
  80255e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802563:	40                   	inc    %eax
  802564:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802569:	e9 60 01 00 00       	jmp    8026ce <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  80256e:	8b 45 08             	mov    0x8(%ebp),%eax
  802571:	8b 50 08             	mov    0x8(%eax),%edx
  802574:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802577:	8b 40 08             	mov    0x8(%eax),%eax
  80257a:	39 c2                	cmp    %eax,%edx
  80257c:	0f 82 4c 01 00 00    	jb     8026ce <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802582:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802586:	75 14                	jne    80259c <insert_sorted_allocList+0x157>
  802588:	83 ec 04             	sub    $0x4,%esp
  80258b:	68 6c 44 80 00       	push   $0x80446c
  802590:	6a 73                	push   $0x73
  802592:	68 1b 44 80 00       	push   $0x80441b
  802597:	e8 82 e1 ff ff       	call   80071e <_panic>
  80259c:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8025a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a5:	89 50 04             	mov    %edx,0x4(%eax)
  8025a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ab:	8b 40 04             	mov    0x4(%eax),%eax
  8025ae:	85 c0                	test   %eax,%eax
  8025b0:	74 0c                	je     8025be <insert_sorted_allocList+0x179>
  8025b2:	a1 44 50 80 00       	mov    0x805044,%eax
  8025b7:	8b 55 08             	mov    0x8(%ebp),%edx
  8025ba:	89 10                	mov    %edx,(%eax)
  8025bc:	eb 08                	jmp    8025c6 <insert_sorted_allocList+0x181>
  8025be:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c1:	a3 40 50 80 00       	mov    %eax,0x805040
  8025c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c9:	a3 44 50 80 00       	mov    %eax,0x805044
  8025ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025d7:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8025dc:	40                   	inc    %eax
  8025dd:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8025e2:	e9 e7 00 00 00       	jmp    8026ce <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8025e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8025ed:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8025f4:	a1 40 50 80 00       	mov    0x805040,%eax
  8025f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025fc:	e9 9d 00 00 00       	jmp    80269e <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802601:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802604:	8b 00                	mov    (%eax),%eax
  802606:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802609:	8b 45 08             	mov    0x8(%ebp),%eax
  80260c:	8b 50 08             	mov    0x8(%eax),%edx
  80260f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802612:	8b 40 08             	mov    0x8(%eax),%eax
  802615:	39 c2                	cmp    %eax,%edx
  802617:	76 7d                	jbe    802696 <insert_sorted_allocList+0x251>
  802619:	8b 45 08             	mov    0x8(%ebp),%eax
  80261c:	8b 50 08             	mov    0x8(%eax),%edx
  80261f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802622:	8b 40 08             	mov    0x8(%eax),%eax
  802625:	39 c2                	cmp    %eax,%edx
  802627:	73 6d                	jae    802696 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802629:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80262d:	74 06                	je     802635 <insert_sorted_allocList+0x1f0>
  80262f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802633:	75 14                	jne    802649 <insert_sorted_allocList+0x204>
  802635:	83 ec 04             	sub    $0x4,%esp
  802638:	68 90 44 80 00       	push   $0x804490
  80263d:	6a 7f                	push   $0x7f
  80263f:	68 1b 44 80 00       	push   $0x80441b
  802644:	e8 d5 e0 ff ff       	call   80071e <_panic>
  802649:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264c:	8b 10                	mov    (%eax),%edx
  80264e:	8b 45 08             	mov    0x8(%ebp),%eax
  802651:	89 10                	mov    %edx,(%eax)
  802653:	8b 45 08             	mov    0x8(%ebp),%eax
  802656:	8b 00                	mov    (%eax),%eax
  802658:	85 c0                	test   %eax,%eax
  80265a:	74 0b                	je     802667 <insert_sorted_allocList+0x222>
  80265c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265f:	8b 00                	mov    (%eax),%eax
  802661:	8b 55 08             	mov    0x8(%ebp),%edx
  802664:	89 50 04             	mov    %edx,0x4(%eax)
  802667:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266a:	8b 55 08             	mov    0x8(%ebp),%edx
  80266d:	89 10                	mov    %edx,(%eax)
  80266f:	8b 45 08             	mov    0x8(%ebp),%eax
  802672:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802675:	89 50 04             	mov    %edx,0x4(%eax)
  802678:	8b 45 08             	mov    0x8(%ebp),%eax
  80267b:	8b 00                	mov    (%eax),%eax
  80267d:	85 c0                	test   %eax,%eax
  80267f:	75 08                	jne    802689 <insert_sorted_allocList+0x244>
  802681:	8b 45 08             	mov    0x8(%ebp),%eax
  802684:	a3 44 50 80 00       	mov    %eax,0x805044
  802689:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80268e:	40                   	inc    %eax
  80268f:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802694:	eb 39                	jmp    8026cf <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802696:	a1 48 50 80 00       	mov    0x805048,%eax
  80269b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80269e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026a2:	74 07                	je     8026ab <insert_sorted_allocList+0x266>
  8026a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a7:	8b 00                	mov    (%eax),%eax
  8026a9:	eb 05                	jmp    8026b0 <insert_sorted_allocList+0x26b>
  8026ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8026b0:	a3 48 50 80 00       	mov    %eax,0x805048
  8026b5:	a1 48 50 80 00       	mov    0x805048,%eax
  8026ba:	85 c0                	test   %eax,%eax
  8026bc:	0f 85 3f ff ff ff    	jne    802601 <insert_sorted_allocList+0x1bc>
  8026c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026c6:	0f 85 35 ff ff ff    	jne    802601 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8026cc:	eb 01                	jmp    8026cf <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8026ce:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8026cf:	90                   	nop
  8026d0:	c9                   	leave  
  8026d1:	c3                   	ret    

008026d2 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8026d2:	55                   	push   %ebp
  8026d3:	89 e5                	mov    %esp,%ebp
  8026d5:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8026d8:	a1 38 51 80 00       	mov    0x805138,%eax
  8026dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026e0:	e9 85 01 00 00       	jmp    80286a <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8026e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e8:	8b 40 0c             	mov    0xc(%eax),%eax
  8026eb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026ee:	0f 82 6e 01 00 00    	jb     802862 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8026f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f7:	8b 40 0c             	mov    0xc(%eax),%eax
  8026fa:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026fd:	0f 85 8a 00 00 00    	jne    80278d <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802703:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802707:	75 17                	jne    802720 <alloc_block_FF+0x4e>
  802709:	83 ec 04             	sub    $0x4,%esp
  80270c:	68 c4 44 80 00       	push   $0x8044c4
  802711:	68 93 00 00 00       	push   $0x93
  802716:	68 1b 44 80 00       	push   $0x80441b
  80271b:	e8 fe df ff ff       	call   80071e <_panic>
  802720:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802723:	8b 00                	mov    (%eax),%eax
  802725:	85 c0                	test   %eax,%eax
  802727:	74 10                	je     802739 <alloc_block_FF+0x67>
  802729:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272c:	8b 00                	mov    (%eax),%eax
  80272e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802731:	8b 52 04             	mov    0x4(%edx),%edx
  802734:	89 50 04             	mov    %edx,0x4(%eax)
  802737:	eb 0b                	jmp    802744 <alloc_block_FF+0x72>
  802739:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273c:	8b 40 04             	mov    0x4(%eax),%eax
  80273f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802744:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802747:	8b 40 04             	mov    0x4(%eax),%eax
  80274a:	85 c0                	test   %eax,%eax
  80274c:	74 0f                	je     80275d <alloc_block_FF+0x8b>
  80274e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802751:	8b 40 04             	mov    0x4(%eax),%eax
  802754:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802757:	8b 12                	mov    (%edx),%edx
  802759:	89 10                	mov    %edx,(%eax)
  80275b:	eb 0a                	jmp    802767 <alloc_block_FF+0x95>
  80275d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802760:	8b 00                	mov    (%eax),%eax
  802762:	a3 38 51 80 00       	mov    %eax,0x805138
  802767:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802770:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802773:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80277a:	a1 44 51 80 00       	mov    0x805144,%eax
  80277f:	48                   	dec    %eax
  802780:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802785:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802788:	e9 10 01 00 00       	jmp    80289d <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  80278d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802790:	8b 40 0c             	mov    0xc(%eax),%eax
  802793:	3b 45 08             	cmp    0x8(%ebp),%eax
  802796:	0f 86 c6 00 00 00    	jbe    802862 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80279c:	a1 48 51 80 00       	mov    0x805148,%eax
  8027a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8027a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a7:	8b 50 08             	mov    0x8(%eax),%edx
  8027aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ad:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8027b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8027b6:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8027b9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027bd:	75 17                	jne    8027d6 <alloc_block_FF+0x104>
  8027bf:	83 ec 04             	sub    $0x4,%esp
  8027c2:	68 c4 44 80 00       	push   $0x8044c4
  8027c7:	68 9b 00 00 00       	push   $0x9b
  8027cc:	68 1b 44 80 00       	push   $0x80441b
  8027d1:	e8 48 df ff ff       	call   80071e <_panic>
  8027d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027d9:	8b 00                	mov    (%eax),%eax
  8027db:	85 c0                	test   %eax,%eax
  8027dd:	74 10                	je     8027ef <alloc_block_FF+0x11d>
  8027df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027e2:	8b 00                	mov    (%eax),%eax
  8027e4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027e7:	8b 52 04             	mov    0x4(%edx),%edx
  8027ea:	89 50 04             	mov    %edx,0x4(%eax)
  8027ed:	eb 0b                	jmp    8027fa <alloc_block_FF+0x128>
  8027ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027f2:	8b 40 04             	mov    0x4(%eax),%eax
  8027f5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8027fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027fd:	8b 40 04             	mov    0x4(%eax),%eax
  802800:	85 c0                	test   %eax,%eax
  802802:	74 0f                	je     802813 <alloc_block_FF+0x141>
  802804:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802807:	8b 40 04             	mov    0x4(%eax),%eax
  80280a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80280d:	8b 12                	mov    (%edx),%edx
  80280f:	89 10                	mov    %edx,(%eax)
  802811:	eb 0a                	jmp    80281d <alloc_block_FF+0x14b>
  802813:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802816:	8b 00                	mov    (%eax),%eax
  802818:	a3 48 51 80 00       	mov    %eax,0x805148
  80281d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802820:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802826:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802829:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802830:	a1 54 51 80 00       	mov    0x805154,%eax
  802835:	48                   	dec    %eax
  802836:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  80283b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283e:	8b 50 08             	mov    0x8(%eax),%edx
  802841:	8b 45 08             	mov    0x8(%ebp),%eax
  802844:	01 c2                	add    %eax,%edx
  802846:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802849:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  80284c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284f:	8b 40 0c             	mov    0xc(%eax),%eax
  802852:	2b 45 08             	sub    0x8(%ebp),%eax
  802855:	89 c2                	mov    %eax,%edx
  802857:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285a:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  80285d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802860:	eb 3b                	jmp    80289d <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802862:	a1 40 51 80 00       	mov    0x805140,%eax
  802867:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80286a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80286e:	74 07                	je     802877 <alloc_block_FF+0x1a5>
  802870:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802873:	8b 00                	mov    (%eax),%eax
  802875:	eb 05                	jmp    80287c <alloc_block_FF+0x1aa>
  802877:	b8 00 00 00 00       	mov    $0x0,%eax
  80287c:	a3 40 51 80 00       	mov    %eax,0x805140
  802881:	a1 40 51 80 00       	mov    0x805140,%eax
  802886:	85 c0                	test   %eax,%eax
  802888:	0f 85 57 fe ff ff    	jne    8026e5 <alloc_block_FF+0x13>
  80288e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802892:	0f 85 4d fe ff ff    	jne    8026e5 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802898:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80289d:	c9                   	leave  
  80289e:	c3                   	ret    

0080289f <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80289f:	55                   	push   %ebp
  8028a0:	89 e5                	mov    %esp,%ebp
  8028a2:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8028a5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8028ac:	a1 38 51 80 00       	mov    0x805138,%eax
  8028b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028b4:	e9 df 00 00 00       	jmp    802998 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8028b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bc:	8b 40 0c             	mov    0xc(%eax),%eax
  8028bf:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028c2:	0f 82 c8 00 00 00    	jb     802990 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8028c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cb:	8b 40 0c             	mov    0xc(%eax),%eax
  8028ce:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028d1:	0f 85 8a 00 00 00    	jne    802961 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8028d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028db:	75 17                	jne    8028f4 <alloc_block_BF+0x55>
  8028dd:	83 ec 04             	sub    $0x4,%esp
  8028e0:	68 c4 44 80 00       	push   $0x8044c4
  8028e5:	68 b7 00 00 00       	push   $0xb7
  8028ea:	68 1b 44 80 00       	push   $0x80441b
  8028ef:	e8 2a de ff ff       	call   80071e <_panic>
  8028f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f7:	8b 00                	mov    (%eax),%eax
  8028f9:	85 c0                	test   %eax,%eax
  8028fb:	74 10                	je     80290d <alloc_block_BF+0x6e>
  8028fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802900:	8b 00                	mov    (%eax),%eax
  802902:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802905:	8b 52 04             	mov    0x4(%edx),%edx
  802908:	89 50 04             	mov    %edx,0x4(%eax)
  80290b:	eb 0b                	jmp    802918 <alloc_block_BF+0x79>
  80290d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802910:	8b 40 04             	mov    0x4(%eax),%eax
  802913:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802918:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291b:	8b 40 04             	mov    0x4(%eax),%eax
  80291e:	85 c0                	test   %eax,%eax
  802920:	74 0f                	je     802931 <alloc_block_BF+0x92>
  802922:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802925:	8b 40 04             	mov    0x4(%eax),%eax
  802928:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80292b:	8b 12                	mov    (%edx),%edx
  80292d:	89 10                	mov    %edx,(%eax)
  80292f:	eb 0a                	jmp    80293b <alloc_block_BF+0x9c>
  802931:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802934:	8b 00                	mov    (%eax),%eax
  802936:	a3 38 51 80 00       	mov    %eax,0x805138
  80293b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802944:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802947:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80294e:	a1 44 51 80 00       	mov    0x805144,%eax
  802953:	48                   	dec    %eax
  802954:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802959:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295c:	e9 4d 01 00 00       	jmp    802aae <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802961:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802964:	8b 40 0c             	mov    0xc(%eax),%eax
  802967:	3b 45 08             	cmp    0x8(%ebp),%eax
  80296a:	76 24                	jbe    802990 <alloc_block_BF+0xf1>
  80296c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296f:	8b 40 0c             	mov    0xc(%eax),%eax
  802972:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802975:	73 19                	jae    802990 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802977:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  80297e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802981:	8b 40 0c             	mov    0xc(%eax),%eax
  802984:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802987:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298a:	8b 40 08             	mov    0x8(%eax),%eax
  80298d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802990:	a1 40 51 80 00       	mov    0x805140,%eax
  802995:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802998:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80299c:	74 07                	je     8029a5 <alloc_block_BF+0x106>
  80299e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a1:	8b 00                	mov    (%eax),%eax
  8029a3:	eb 05                	jmp    8029aa <alloc_block_BF+0x10b>
  8029a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8029aa:	a3 40 51 80 00       	mov    %eax,0x805140
  8029af:	a1 40 51 80 00       	mov    0x805140,%eax
  8029b4:	85 c0                	test   %eax,%eax
  8029b6:	0f 85 fd fe ff ff    	jne    8028b9 <alloc_block_BF+0x1a>
  8029bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029c0:	0f 85 f3 fe ff ff    	jne    8028b9 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  8029c6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8029ca:	0f 84 d9 00 00 00    	je     802aa9 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8029d0:	a1 48 51 80 00       	mov    0x805148,%eax
  8029d5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8029d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029db:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029de:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8029e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8029e7:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  8029ea:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8029ee:	75 17                	jne    802a07 <alloc_block_BF+0x168>
  8029f0:	83 ec 04             	sub    $0x4,%esp
  8029f3:	68 c4 44 80 00       	push   $0x8044c4
  8029f8:	68 c7 00 00 00       	push   $0xc7
  8029fd:	68 1b 44 80 00       	push   $0x80441b
  802a02:	e8 17 dd ff ff       	call   80071e <_panic>
  802a07:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a0a:	8b 00                	mov    (%eax),%eax
  802a0c:	85 c0                	test   %eax,%eax
  802a0e:	74 10                	je     802a20 <alloc_block_BF+0x181>
  802a10:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a13:	8b 00                	mov    (%eax),%eax
  802a15:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802a18:	8b 52 04             	mov    0x4(%edx),%edx
  802a1b:	89 50 04             	mov    %edx,0x4(%eax)
  802a1e:	eb 0b                	jmp    802a2b <alloc_block_BF+0x18c>
  802a20:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a23:	8b 40 04             	mov    0x4(%eax),%eax
  802a26:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a2b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a2e:	8b 40 04             	mov    0x4(%eax),%eax
  802a31:	85 c0                	test   %eax,%eax
  802a33:	74 0f                	je     802a44 <alloc_block_BF+0x1a5>
  802a35:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a38:	8b 40 04             	mov    0x4(%eax),%eax
  802a3b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802a3e:	8b 12                	mov    (%edx),%edx
  802a40:	89 10                	mov    %edx,(%eax)
  802a42:	eb 0a                	jmp    802a4e <alloc_block_BF+0x1af>
  802a44:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a47:	8b 00                	mov    (%eax),%eax
  802a49:	a3 48 51 80 00       	mov    %eax,0x805148
  802a4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a51:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a57:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a5a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a61:	a1 54 51 80 00       	mov    0x805154,%eax
  802a66:	48                   	dec    %eax
  802a67:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802a6c:	83 ec 08             	sub    $0x8,%esp
  802a6f:	ff 75 ec             	pushl  -0x14(%ebp)
  802a72:	68 38 51 80 00       	push   $0x805138
  802a77:	e8 71 f9 ff ff       	call   8023ed <find_block>
  802a7c:	83 c4 10             	add    $0x10,%esp
  802a7f:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802a82:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a85:	8b 50 08             	mov    0x8(%eax),%edx
  802a88:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8b:	01 c2                	add    %eax,%edx
  802a8d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a90:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802a93:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a96:	8b 40 0c             	mov    0xc(%eax),%eax
  802a99:	2b 45 08             	sub    0x8(%ebp),%eax
  802a9c:	89 c2                	mov    %eax,%edx
  802a9e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802aa1:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802aa4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802aa7:	eb 05                	jmp    802aae <alloc_block_BF+0x20f>
	}
	return NULL;
  802aa9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802aae:	c9                   	leave  
  802aaf:	c3                   	ret    

00802ab0 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802ab0:	55                   	push   %ebp
  802ab1:	89 e5                	mov    %esp,%ebp
  802ab3:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802ab6:	a1 28 50 80 00       	mov    0x805028,%eax
  802abb:	85 c0                	test   %eax,%eax
  802abd:	0f 85 de 01 00 00    	jne    802ca1 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802ac3:	a1 38 51 80 00       	mov    0x805138,%eax
  802ac8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802acb:	e9 9e 01 00 00       	jmp    802c6e <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802ad0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad3:	8b 40 0c             	mov    0xc(%eax),%eax
  802ad6:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ad9:	0f 82 87 01 00 00    	jb     802c66 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802adf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae2:	8b 40 0c             	mov    0xc(%eax),%eax
  802ae5:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ae8:	0f 85 95 00 00 00    	jne    802b83 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802aee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802af2:	75 17                	jne    802b0b <alloc_block_NF+0x5b>
  802af4:	83 ec 04             	sub    $0x4,%esp
  802af7:	68 c4 44 80 00       	push   $0x8044c4
  802afc:	68 e0 00 00 00       	push   $0xe0
  802b01:	68 1b 44 80 00       	push   $0x80441b
  802b06:	e8 13 dc ff ff       	call   80071e <_panic>
  802b0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0e:	8b 00                	mov    (%eax),%eax
  802b10:	85 c0                	test   %eax,%eax
  802b12:	74 10                	je     802b24 <alloc_block_NF+0x74>
  802b14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b17:	8b 00                	mov    (%eax),%eax
  802b19:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b1c:	8b 52 04             	mov    0x4(%edx),%edx
  802b1f:	89 50 04             	mov    %edx,0x4(%eax)
  802b22:	eb 0b                	jmp    802b2f <alloc_block_NF+0x7f>
  802b24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b27:	8b 40 04             	mov    0x4(%eax),%eax
  802b2a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b32:	8b 40 04             	mov    0x4(%eax),%eax
  802b35:	85 c0                	test   %eax,%eax
  802b37:	74 0f                	je     802b48 <alloc_block_NF+0x98>
  802b39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3c:	8b 40 04             	mov    0x4(%eax),%eax
  802b3f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b42:	8b 12                	mov    (%edx),%edx
  802b44:	89 10                	mov    %edx,(%eax)
  802b46:	eb 0a                	jmp    802b52 <alloc_block_NF+0xa2>
  802b48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4b:	8b 00                	mov    (%eax),%eax
  802b4d:	a3 38 51 80 00       	mov    %eax,0x805138
  802b52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b55:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b65:	a1 44 51 80 00       	mov    0x805144,%eax
  802b6a:	48                   	dec    %eax
  802b6b:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802b70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b73:	8b 40 08             	mov    0x8(%eax),%eax
  802b76:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802b7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7e:	e9 f8 04 00 00       	jmp    80307b <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802b83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b86:	8b 40 0c             	mov    0xc(%eax),%eax
  802b89:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b8c:	0f 86 d4 00 00 00    	jbe    802c66 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b92:	a1 48 51 80 00       	mov    0x805148,%eax
  802b97:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802b9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9d:	8b 50 08             	mov    0x8(%eax),%edx
  802ba0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba3:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802ba6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba9:	8b 55 08             	mov    0x8(%ebp),%edx
  802bac:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802baf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bb3:	75 17                	jne    802bcc <alloc_block_NF+0x11c>
  802bb5:	83 ec 04             	sub    $0x4,%esp
  802bb8:	68 c4 44 80 00       	push   $0x8044c4
  802bbd:	68 e9 00 00 00       	push   $0xe9
  802bc2:	68 1b 44 80 00       	push   $0x80441b
  802bc7:	e8 52 db ff ff       	call   80071e <_panic>
  802bcc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bcf:	8b 00                	mov    (%eax),%eax
  802bd1:	85 c0                	test   %eax,%eax
  802bd3:	74 10                	je     802be5 <alloc_block_NF+0x135>
  802bd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bd8:	8b 00                	mov    (%eax),%eax
  802bda:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bdd:	8b 52 04             	mov    0x4(%edx),%edx
  802be0:	89 50 04             	mov    %edx,0x4(%eax)
  802be3:	eb 0b                	jmp    802bf0 <alloc_block_NF+0x140>
  802be5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802be8:	8b 40 04             	mov    0x4(%eax),%eax
  802beb:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802bf0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bf3:	8b 40 04             	mov    0x4(%eax),%eax
  802bf6:	85 c0                	test   %eax,%eax
  802bf8:	74 0f                	je     802c09 <alloc_block_NF+0x159>
  802bfa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bfd:	8b 40 04             	mov    0x4(%eax),%eax
  802c00:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c03:	8b 12                	mov    (%edx),%edx
  802c05:	89 10                	mov    %edx,(%eax)
  802c07:	eb 0a                	jmp    802c13 <alloc_block_NF+0x163>
  802c09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c0c:	8b 00                	mov    (%eax),%eax
  802c0e:	a3 48 51 80 00       	mov    %eax,0x805148
  802c13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c16:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c1f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c26:	a1 54 51 80 00       	mov    0x805154,%eax
  802c2b:	48                   	dec    %eax
  802c2c:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802c31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c34:	8b 40 08             	mov    0x8(%eax),%eax
  802c37:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802c3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3f:	8b 50 08             	mov    0x8(%eax),%edx
  802c42:	8b 45 08             	mov    0x8(%ebp),%eax
  802c45:	01 c2                	add    %eax,%edx
  802c47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4a:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802c4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c50:	8b 40 0c             	mov    0xc(%eax),%eax
  802c53:	2b 45 08             	sub    0x8(%ebp),%eax
  802c56:	89 c2                	mov    %eax,%edx
  802c58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5b:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802c5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c61:	e9 15 04 00 00       	jmp    80307b <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802c66:	a1 40 51 80 00       	mov    0x805140,%eax
  802c6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c6e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c72:	74 07                	je     802c7b <alloc_block_NF+0x1cb>
  802c74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c77:	8b 00                	mov    (%eax),%eax
  802c79:	eb 05                	jmp    802c80 <alloc_block_NF+0x1d0>
  802c7b:	b8 00 00 00 00       	mov    $0x0,%eax
  802c80:	a3 40 51 80 00       	mov    %eax,0x805140
  802c85:	a1 40 51 80 00       	mov    0x805140,%eax
  802c8a:	85 c0                	test   %eax,%eax
  802c8c:	0f 85 3e fe ff ff    	jne    802ad0 <alloc_block_NF+0x20>
  802c92:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c96:	0f 85 34 fe ff ff    	jne    802ad0 <alloc_block_NF+0x20>
  802c9c:	e9 d5 03 00 00       	jmp    803076 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802ca1:	a1 38 51 80 00       	mov    0x805138,%eax
  802ca6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ca9:	e9 b1 01 00 00       	jmp    802e5f <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802cae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb1:	8b 50 08             	mov    0x8(%eax),%edx
  802cb4:	a1 28 50 80 00       	mov    0x805028,%eax
  802cb9:	39 c2                	cmp    %eax,%edx
  802cbb:	0f 82 96 01 00 00    	jb     802e57 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802cc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc4:	8b 40 0c             	mov    0xc(%eax),%eax
  802cc7:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cca:	0f 82 87 01 00 00    	jb     802e57 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802cd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd3:	8b 40 0c             	mov    0xc(%eax),%eax
  802cd6:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cd9:	0f 85 95 00 00 00    	jne    802d74 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802cdf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ce3:	75 17                	jne    802cfc <alloc_block_NF+0x24c>
  802ce5:	83 ec 04             	sub    $0x4,%esp
  802ce8:	68 c4 44 80 00       	push   $0x8044c4
  802ced:	68 fc 00 00 00       	push   $0xfc
  802cf2:	68 1b 44 80 00       	push   $0x80441b
  802cf7:	e8 22 da ff ff       	call   80071e <_panic>
  802cfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cff:	8b 00                	mov    (%eax),%eax
  802d01:	85 c0                	test   %eax,%eax
  802d03:	74 10                	je     802d15 <alloc_block_NF+0x265>
  802d05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d08:	8b 00                	mov    (%eax),%eax
  802d0a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d0d:	8b 52 04             	mov    0x4(%edx),%edx
  802d10:	89 50 04             	mov    %edx,0x4(%eax)
  802d13:	eb 0b                	jmp    802d20 <alloc_block_NF+0x270>
  802d15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d18:	8b 40 04             	mov    0x4(%eax),%eax
  802d1b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d23:	8b 40 04             	mov    0x4(%eax),%eax
  802d26:	85 c0                	test   %eax,%eax
  802d28:	74 0f                	je     802d39 <alloc_block_NF+0x289>
  802d2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2d:	8b 40 04             	mov    0x4(%eax),%eax
  802d30:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d33:	8b 12                	mov    (%edx),%edx
  802d35:	89 10                	mov    %edx,(%eax)
  802d37:	eb 0a                	jmp    802d43 <alloc_block_NF+0x293>
  802d39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3c:	8b 00                	mov    (%eax),%eax
  802d3e:	a3 38 51 80 00       	mov    %eax,0x805138
  802d43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d46:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d56:	a1 44 51 80 00       	mov    0x805144,%eax
  802d5b:	48                   	dec    %eax
  802d5c:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802d61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d64:	8b 40 08             	mov    0x8(%eax),%eax
  802d67:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802d6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6f:	e9 07 03 00 00       	jmp    80307b <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802d74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d77:	8b 40 0c             	mov    0xc(%eax),%eax
  802d7a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d7d:	0f 86 d4 00 00 00    	jbe    802e57 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802d83:	a1 48 51 80 00       	mov    0x805148,%eax
  802d88:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802d8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8e:	8b 50 08             	mov    0x8(%eax),%edx
  802d91:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d94:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802d97:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d9a:	8b 55 08             	mov    0x8(%ebp),%edx
  802d9d:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802da0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802da4:	75 17                	jne    802dbd <alloc_block_NF+0x30d>
  802da6:	83 ec 04             	sub    $0x4,%esp
  802da9:	68 c4 44 80 00       	push   $0x8044c4
  802dae:	68 04 01 00 00       	push   $0x104
  802db3:	68 1b 44 80 00       	push   $0x80441b
  802db8:	e8 61 d9 ff ff       	call   80071e <_panic>
  802dbd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dc0:	8b 00                	mov    (%eax),%eax
  802dc2:	85 c0                	test   %eax,%eax
  802dc4:	74 10                	je     802dd6 <alloc_block_NF+0x326>
  802dc6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dc9:	8b 00                	mov    (%eax),%eax
  802dcb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802dce:	8b 52 04             	mov    0x4(%edx),%edx
  802dd1:	89 50 04             	mov    %edx,0x4(%eax)
  802dd4:	eb 0b                	jmp    802de1 <alloc_block_NF+0x331>
  802dd6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dd9:	8b 40 04             	mov    0x4(%eax),%eax
  802ddc:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802de1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802de4:	8b 40 04             	mov    0x4(%eax),%eax
  802de7:	85 c0                	test   %eax,%eax
  802de9:	74 0f                	je     802dfa <alloc_block_NF+0x34a>
  802deb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dee:	8b 40 04             	mov    0x4(%eax),%eax
  802df1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802df4:	8b 12                	mov    (%edx),%edx
  802df6:	89 10                	mov    %edx,(%eax)
  802df8:	eb 0a                	jmp    802e04 <alloc_block_NF+0x354>
  802dfa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dfd:	8b 00                	mov    (%eax),%eax
  802dff:	a3 48 51 80 00       	mov    %eax,0x805148
  802e04:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e07:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e0d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e10:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e17:	a1 54 51 80 00       	mov    0x805154,%eax
  802e1c:	48                   	dec    %eax
  802e1d:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802e22:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e25:	8b 40 08             	mov    0x8(%eax),%eax
  802e28:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802e2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e30:	8b 50 08             	mov    0x8(%eax),%edx
  802e33:	8b 45 08             	mov    0x8(%ebp),%eax
  802e36:	01 c2                	add    %eax,%edx
  802e38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3b:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802e3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e41:	8b 40 0c             	mov    0xc(%eax),%eax
  802e44:	2b 45 08             	sub    0x8(%ebp),%eax
  802e47:	89 c2                	mov    %eax,%edx
  802e49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4c:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802e4f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e52:	e9 24 02 00 00       	jmp    80307b <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802e57:	a1 40 51 80 00       	mov    0x805140,%eax
  802e5c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e5f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e63:	74 07                	je     802e6c <alloc_block_NF+0x3bc>
  802e65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e68:	8b 00                	mov    (%eax),%eax
  802e6a:	eb 05                	jmp    802e71 <alloc_block_NF+0x3c1>
  802e6c:	b8 00 00 00 00       	mov    $0x0,%eax
  802e71:	a3 40 51 80 00       	mov    %eax,0x805140
  802e76:	a1 40 51 80 00       	mov    0x805140,%eax
  802e7b:	85 c0                	test   %eax,%eax
  802e7d:	0f 85 2b fe ff ff    	jne    802cae <alloc_block_NF+0x1fe>
  802e83:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e87:	0f 85 21 fe ff ff    	jne    802cae <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802e8d:	a1 38 51 80 00       	mov    0x805138,%eax
  802e92:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e95:	e9 ae 01 00 00       	jmp    803048 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802e9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9d:	8b 50 08             	mov    0x8(%eax),%edx
  802ea0:	a1 28 50 80 00       	mov    0x805028,%eax
  802ea5:	39 c2                	cmp    %eax,%edx
  802ea7:	0f 83 93 01 00 00    	jae    803040 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802ead:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb0:	8b 40 0c             	mov    0xc(%eax),%eax
  802eb3:	3b 45 08             	cmp    0x8(%ebp),%eax
  802eb6:	0f 82 84 01 00 00    	jb     803040 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802ebc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebf:	8b 40 0c             	mov    0xc(%eax),%eax
  802ec2:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ec5:	0f 85 95 00 00 00    	jne    802f60 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802ecb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ecf:	75 17                	jne    802ee8 <alloc_block_NF+0x438>
  802ed1:	83 ec 04             	sub    $0x4,%esp
  802ed4:	68 c4 44 80 00       	push   $0x8044c4
  802ed9:	68 14 01 00 00       	push   $0x114
  802ede:	68 1b 44 80 00       	push   $0x80441b
  802ee3:	e8 36 d8 ff ff       	call   80071e <_panic>
  802ee8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eeb:	8b 00                	mov    (%eax),%eax
  802eed:	85 c0                	test   %eax,%eax
  802eef:	74 10                	je     802f01 <alloc_block_NF+0x451>
  802ef1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef4:	8b 00                	mov    (%eax),%eax
  802ef6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ef9:	8b 52 04             	mov    0x4(%edx),%edx
  802efc:	89 50 04             	mov    %edx,0x4(%eax)
  802eff:	eb 0b                	jmp    802f0c <alloc_block_NF+0x45c>
  802f01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f04:	8b 40 04             	mov    0x4(%eax),%eax
  802f07:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0f:	8b 40 04             	mov    0x4(%eax),%eax
  802f12:	85 c0                	test   %eax,%eax
  802f14:	74 0f                	je     802f25 <alloc_block_NF+0x475>
  802f16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f19:	8b 40 04             	mov    0x4(%eax),%eax
  802f1c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f1f:	8b 12                	mov    (%edx),%edx
  802f21:	89 10                	mov    %edx,(%eax)
  802f23:	eb 0a                	jmp    802f2f <alloc_block_NF+0x47f>
  802f25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f28:	8b 00                	mov    (%eax),%eax
  802f2a:	a3 38 51 80 00       	mov    %eax,0x805138
  802f2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f32:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f42:	a1 44 51 80 00       	mov    0x805144,%eax
  802f47:	48                   	dec    %eax
  802f48:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802f4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f50:	8b 40 08             	mov    0x8(%eax),%eax
  802f53:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802f58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5b:	e9 1b 01 00 00       	jmp    80307b <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802f60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f63:	8b 40 0c             	mov    0xc(%eax),%eax
  802f66:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f69:	0f 86 d1 00 00 00    	jbe    803040 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802f6f:	a1 48 51 80 00       	mov    0x805148,%eax
  802f74:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802f77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7a:	8b 50 08             	mov    0x8(%eax),%edx
  802f7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f80:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802f83:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f86:	8b 55 08             	mov    0x8(%ebp),%edx
  802f89:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802f8c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802f90:	75 17                	jne    802fa9 <alloc_block_NF+0x4f9>
  802f92:	83 ec 04             	sub    $0x4,%esp
  802f95:	68 c4 44 80 00       	push   $0x8044c4
  802f9a:	68 1c 01 00 00       	push   $0x11c
  802f9f:	68 1b 44 80 00       	push   $0x80441b
  802fa4:	e8 75 d7 ff ff       	call   80071e <_panic>
  802fa9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fac:	8b 00                	mov    (%eax),%eax
  802fae:	85 c0                	test   %eax,%eax
  802fb0:	74 10                	je     802fc2 <alloc_block_NF+0x512>
  802fb2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fb5:	8b 00                	mov    (%eax),%eax
  802fb7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802fba:	8b 52 04             	mov    0x4(%edx),%edx
  802fbd:	89 50 04             	mov    %edx,0x4(%eax)
  802fc0:	eb 0b                	jmp    802fcd <alloc_block_NF+0x51d>
  802fc2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fc5:	8b 40 04             	mov    0x4(%eax),%eax
  802fc8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802fcd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fd0:	8b 40 04             	mov    0x4(%eax),%eax
  802fd3:	85 c0                	test   %eax,%eax
  802fd5:	74 0f                	je     802fe6 <alloc_block_NF+0x536>
  802fd7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fda:	8b 40 04             	mov    0x4(%eax),%eax
  802fdd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802fe0:	8b 12                	mov    (%edx),%edx
  802fe2:	89 10                	mov    %edx,(%eax)
  802fe4:	eb 0a                	jmp    802ff0 <alloc_block_NF+0x540>
  802fe6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fe9:	8b 00                	mov    (%eax),%eax
  802feb:	a3 48 51 80 00       	mov    %eax,0x805148
  802ff0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ff3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ff9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ffc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803003:	a1 54 51 80 00       	mov    0x805154,%eax
  803008:	48                   	dec    %eax
  803009:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  80300e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803011:	8b 40 08             	mov    0x8(%eax),%eax
  803014:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  803019:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80301c:	8b 50 08             	mov    0x8(%eax),%edx
  80301f:	8b 45 08             	mov    0x8(%ebp),%eax
  803022:	01 c2                	add    %eax,%edx
  803024:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803027:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  80302a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80302d:	8b 40 0c             	mov    0xc(%eax),%eax
  803030:	2b 45 08             	sub    0x8(%ebp),%eax
  803033:	89 c2                	mov    %eax,%edx
  803035:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803038:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  80303b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80303e:	eb 3b                	jmp    80307b <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803040:	a1 40 51 80 00       	mov    0x805140,%eax
  803045:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803048:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80304c:	74 07                	je     803055 <alloc_block_NF+0x5a5>
  80304e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803051:	8b 00                	mov    (%eax),%eax
  803053:	eb 05                	jmp    80305a <alloc_block_NF+0x5aa>
  803055:	b8 00 00 00 00       	mov    $0x0,%eax
  80305a:	a3 40 51 80 00       	mov    %eax,0x805140
  80305f:	a1 40 51 80 00       	mov    0x805140,%eax
  803064:	85 c0                	test   %eax,%eax
  803066:	0f 85 2e fe ff ff    	jne    802e9a <alloc_block_NF+0x3ea>
  80306c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803070:	0f 85 24 fe ff ff    	jne    802e9a <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  803076:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80307b:	c9                   	leave  
  80307c:	c3                   	ret    

0080307d <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  80307d:	55                   	push   %ebp
  80307e:	89 e5                	mov    %esp,%ebp
  803080:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  803083:	a1 38 51 80 00       	mov    0x805138,%eax
  803088:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  80308b:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803090:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  803093:	a1 38 51 80 00       	mov    0x805138,%eax
  803098:	85 c0                	test   %eax,%eax
  80309a:	74 14                	je     8030b0 <insert_sorted_with_merge_freeList+0x33>
  80309c:	8b 45 08             	mov    0x8(%ebp),%eax
  80309f:	8b 50 08             	mov    0x8(%eax),%edx
  8030a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030a5:	8b 40 08             	mov    0x8(%eax),%eax
  8030a8:	39 c2                	cmp    %eax,%edx
  8030aa:	0f 87 9b 01 00 00    	ja     80324b <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  8030b0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030b4:	75 17                	jne    8030cd <insert_sorted_with_merge_freeList+0x50>
  8030b6:	83 ec 04             	sub    $0x4,%esp
  8030b9:	68 f8 43 80 00       	push   $0x8043f8
  8030be:	68 38 01 00 00       	push   $0x138
  8030c3:	68 1b 44 80 00       	push   $0x80441b
  8030c8:	e8 51 d6 ff ff       	call   80071e <_panic>
  8030cd:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8030d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d6:	89 10                	mov    %edx,(%eax)
  8030d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030db:	8b 00                	mov    (%eax),%eax
  8030dd:	85 c0                	test   %eax,%eax
  8030df:	74 0d                	je     8030ee <insert_sorted_with_merge_freeList+0x71>
  8030e1:	a1 38 51 80 00       	mov    0x805138,%eax
  8030e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8030e9:	89 50 04             	mov    %edx,0x4(%eax)
  8030ec:	eb 08                	jmp    8030f6 <insert_sorted_with_merge_freeList+0x79>
  8030ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f9:	a3 38 51 80 00       	mov    %eax,0x805138
  8030fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803101:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803108:	a1 44 51 80 00       	mov    0x805144,%eax
  80310d:	40                   	inc    %eax
  80310e:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803113:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803117:	0f 84 a8 06 00 00    	je     8037c5 <insert_sorted_with_merge_freeList+0x748>
  80311d:	8b 45 08             	mov    0x8(%ebp),%eax
  803120:	8b 50 08             	mov    0x8(%eax),%edx
  803123:	8b 45 08             	mov    0x8(%ebp),%eax
  803126:	8b 40 0c             	mov    0xc(%eax),%eax
  803129:	01 c2                	add    %eax,%edx
  80312b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80312e:	8b 40 08             	mov    0x8(%eax),%eax
  803131:	39 c2                	cmp    %eax,%edx
  803133:	0f 85 8c 06 00 00    	jne    8037c5 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  803139:	8b 45 08             	mov    0x8(%ebp),%eax
  80313c:	8b 50 0c             	mov    0xc(%eax),%edx
  80313f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803142:	8b 40 0c             	mov    0xc(%eax),%eax
  803145:	01 c2                	add    %eax,%edx
  803147:	8b 45 08             	mov    0x8(%ebp),%eax
  80314a:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  80314d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803151:	75 17                	jne    80316a <insert_sorted_with_merge_freeList+0xed>
  803153:	83 ec 04             	sub    $0x4,%esp
  803156:	68 c4 44 80 00       	push   $0x8044c4
  80315b:	68 3c 01 00 00       	push   $0x13c
  803160:	68 1b 44 80 00       	push   $0x80441b
  803165:	e8 b4 d5 ff ff       	call   80071e <_panic>
  80316a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80316d:	8b 00                	mov    (%eax),%eax
  80316f:	85 c0                	test   %eax,%eax
  803171:	74 10                	je     803183 <insert_sorted_with_merge_freeList+0x106>
  803173:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803176:	8b 00                	mov    (%eax),%eax
  803178:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80317b:	8b 52 04             	mov    0x4(%edx),%edx
  80317e:	89 50 04             	mov    %edx,0x4(%eax)
  803181:	eb 0b                	jmp    80318e <insert_sorted_with_merge_freeList+0x111>
  803183:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803186:	8b 40 04             	mov    0x4(%eax),%eax
  803189:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80318e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803191:	8b 40 04             	mov    0x4(%eax),%eax
  803194:	85 c0                	test   %eax,%eax
  803196:	74 0f                	je     8031a7 <insert_sorted_with_merge_freeList+0x12a>
  803198:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80319b:	8b 40 04             	mov    0x4(%eax),%eax
  80319e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031a1:	8b 12                	mov    (%edx),%edx
  8031a3:	89 10                	mov    %edx,(%eax)
  8031a5:	eb 0a                	jmp    8031b1 <insert_sorted_with_merge_freeList+0x134>
  8031a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031aa:	8b 00                	mov    (%eax),%eax
  8031ac:	a3 38 51 80 00       	mov    %eax,0x805138
  8031b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031b4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031bd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031c4:	a1 44 51 80 00       	mov    0x805144,%eax
  8031c9:	48                   	dec    %eax
  8031ca:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  8031cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031d2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  8031d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031dc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  8031e3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8031e7:	75 17                	jne    803200 <insert_sorted_with_merge_freeList+0x183>
  8031e9:	83 ec 04             	sub    $0x4,%esp
  8031ec:	68 f8 43 80 00       	push   $0x8043f8
  8031f1:	68 3f 01 00 00       	push   $0x13f
  8031f6:	68 1b 44 80 00       	push   $0x80441b
  8031fb:	e8 1e d5 ff ff       	call   80071e <_panic>
  803200:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803206:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803209:	89 10                	mov    %edx,(%eax)
  80320b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80320e:	8b 00                	mov    (%eax),%eax
  803210:	85 c0                	test   %eax,%eax
  803212:	74 0d                	je     803221 <insert_sorted_with_merge_freeList+0x1a4>
  803214:	a1 48 51 80 00       	mov    0x805148,%eax
  803219:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80321c:	89 50 04             	mov    %edx,0x4(%eax)
  80321f:	eb 08                	jmp    803229 <insert_sorted_with_merge_freeList+0x1ac>
  803221:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803224:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803229:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80322c:	a3 48 51 80 00       	mov    %eax,0x805148
  803231:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803234:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80323b:	a1 54 51 80 00       	mov    0x805154,%eax
  803240:	40                   	inc    %eax
  803241:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803246:	e9 7a 05 00 00       	jmp    8037c5 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  80324b:	8b 45 08             	mov    0x8(%ebp),%eax
  80324e:	8b 50 08             	mov    0x8(%eax),%edx
  803251:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803254:	8b 40 08             	mov    0x8(%eax),%eax
  803257:	39 c2                	cmp    %eax,%edx
  803259:	0f 82 14 01 00 00    	jb     803373 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  80325f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803262:	8b 50 08             	mov    0x8(%eax),%edx
  803265:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803268:	8b 40 0c             	mov    0xc(%eax),%eax
  80326b:	01 c2                	add    %eax,%edx
  80326d:	8b 45 08             	mov    0x8(%ebp),%eax
  803270:	8b 40 08             	mov    0x8(%eax),%eax
  803273:	39 c2                	cmp    %eax,%edx
  803275:	0f 85 90 00 00 00    	jne    80330b <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  80327b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80327e:	8b 50 0c             	mov    0xc(%eax),%edx
  803281:	8b 45 08             	mov    0x8(%ebp),%eax
  803284:	8b 40 0c             	mov    0xc(%eax),%eax
  803287:	01 c2                	add    %eax,%edx
  803289:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80328c:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  80328f:	8b 45 08             	mov    0x8(%ebp),%eax
  803292:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  803299:	8b 45 08             	mov    0x8(%ebp),%eax
  80329c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8032a3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032a7:	75 17                	jne    8032c0 <insert_sorted_with_merge_freeList+0x243>
  8032a9:	83 ec 04             	sub    $0x4,%esp
  8032ac:	68 f8 43 80 00       	push   $0x8043f8
  8032b1:	68 49 01 00 00       	push   $0x149
  8032b6:	68 1b 44 80 00       	push   $0x80441b
  8032bb:	e8 5e d4 ff ff       	call   80071e <_panic>
  8032c0:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8032c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c9:	89 10                	mov    %edx,(%eax)
  8032cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ce:	8b 00                	mov    (%eax),%eax
  8032d0:	85 c0                	test   %eax,%eax
  8032d2:	74 0d                	je     8032e1 <insert_sorted_with_merge_freeList+0x264>
  8032d4:	a1 48 51 80 00       	mov    0x805148,%eax
  8032d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8032dc:	89 50 04             	mov    %edx,0x4(%eax)
  8032df:	eb 08                	jmp    8032e9 <insert_sorted_with_merge_freeList+0x26c>
  8032e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ec:	a3 48 51 80 00       	mov    %eax,0x805148
  8032f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032fb:	a1 54 51 80 00       	mov    0x805154,%eax
  803300:	40                   	inc    %eax
  803301:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803306:	e9 bb 04 00 00       	jmp    8037c6 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  80330b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80330f:	75 17                	jne    803328 <insert_sorted_with_merge_freeList+0x2ab>
  803311:	83 ec 04             	sub    $0x4,%esp
  803314:	68 6c 44 80 00       	push   $0x80446c
  803319:	68 4c 01 00 00       	push   $0x14c
  80331e:	68 1b 44 80 00       	push   $0x80441b
  803323:	e8 f6 d3 ff ff       	call   80071e <_panic>
  803328:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  80332e:	8b 45 08             	mov    0x8(%ebp),%eax
  803331:	89 50 04             	mov    %edx,0x4(%eax)
  803334:	8b 45 08             	mov    0x8(%ebp),%eax
  803337:	8b 40 04             	mov    0x4(%eax),%eax
  80333a:	85 c0                	test   %eax,%eax
  80333c:	74 0c                	je     80334a <insert_sorted_with_merge_freeList+0x2cd>
  80333e:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803343:	8b 55 08             	mov    0x8(%ebp),%edx
  803346:	89 10                	mov    %edx,(%eax)
  803348:	eb 08                	jmp    803352 <insert_sorted_with_merge_freeList+0x2d5>
  80334a:	8b 45 08             	mov    0x8(%ebp),%eax
  80334d:	a3 38 51 80 00       	mov    %eax,0x805138
  803352:	8b 45 08             	mov    0x8(%ebp),%eax
  803355:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80335a:	8b 45 08             	mov    0x8(%ebp),%eax
  80335d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803363:	a1 44 51 80 00       	mov    0x805144,%eax
  803368:	40                   	inc    %eax
  803369:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80336e:	e9 53 04 00 00       	jmp    8037c6 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803373:	a1 38 51 80 00       	mov    0x805138,%eax
  803378:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80337b:	e9 15 04 00 00       	jmp    803795 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  803380:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803383:	8b 00                	mov    (%eax),%eax
  803385:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803388:	8b 45 08             	mov    0x8(%ebp),%eax
  80338b:	8b 50 08             	mov    0x8(%eax),%edx
  80338e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803391:	8b 40 08             	mov    0x8(%eax),%eax
  803394:	39 c2                	cmp    %eax,%edx
  803396:	0f 86 f1 03 00 00    	jbe    80378d <insert_sorted_with_merge_freeList+0x710>
  80339c:	8b 45 08             	mov    0x8(%ebp),%eax
  80339f:	8b 50 08             	mov    0x8(%eax),%edx
  8033a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033a5:	8b 40 08             	mov    0x8(%eax),%eax
  8033a8:	39 c2                	cmp    %eax,%edx
  8033aa:	0f 83 dd 03 00 00    	jae    80378d <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  8033b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b3:	8b 50 08             	mov    0x8(%eax),%edx
  8033b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b9:	8b 40 0c             	mov    0xc(%eax),%eax
  8033bc:	01 c2                	add    %eax,%edx
  8033be:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c1:	8b 40 08             	mov    0x8(%eax),%eax
  8033c4:	39 c2                	cmp    %eax,%edx
  8033c6:	0f 85 b9 01 00 00    	jne    803585 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8033cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8033cf:	8b 50 08             	mov    0x8(%eax),%edx
  8033d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d5:	8b 40 0c             	mov    0xc(%eax),%eax
  8033d8:	01 c2                	add    %eax,%edx
  8033da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033dd:	8b 40 08             	mov    0x8(%eax),%eax
  8033e0:	39 c2                	cmp    %eax,%edx
  8033e2:	0f 85 0d 01 00 00    	jne    8034f5 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  8033e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033eb:	8b 50 0c             	mov    0xc(%eax),%edx
  8033ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033f1:	8b 40 0c             	mov    0xc(%eax),%eax
  8033f4:	01 c2                	add    %eax,%edx
  8033f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f9:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8033fc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803400:	75 17                	jne    803419 <insert_sorted_with_merge_freeList+0x39c>
  803402:	83 ec 04             	sub    $0x4,%esp
  803405:	68 c4 44 80 00       	push   $0x8044c4
  80340a:	68 5c 01 00 00       	push   $0x15c
  80340f:	68 1b 44 80 00       	push   $0x80441b
  803414:	e8 05 d3 ff ff       	call   80071e <_panic>
  803419:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80341c:	8b 00                	mov    (%eax),%eax
  80341e:	85 c0                	test   %eax,%eax
  803420:	74 10                	je     803432 <insert_sorted_with_merge_freeList+0x3b5>
  803422:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803425:	8b 00                	mov    (%eax),%eax
  803427:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80342a:	8b 52 04             	mov    0x4(%edx),%edx
  80342d:	89 50 04             	mov    %edx,0x4(%eax)
  803430:	eb 0b                	jmp    80343d <insert_sorted_with_merge_freeList+0x3c0>
  803432:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803435:	8b 40 04             	mov    0x4(%eax),%eax
  803438:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80343d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803440:	8b 40 04             	mov    0x4(%eax),%eax
  803443:	85 c0                	test   %eax,%eax
  803445:	74 0f                	je     803456 <insert_sorted_with_merge_freeList+0x3d9>
  803447:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80344a:	8b 40 04             	mov    0x4(%eax),%eax
  80344d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803450:	8b 12                	mov    (%edx),%edx
  803452:	89 10                	mov    %edx,(%eax)
  803454:	eb 0a                	jmp    803460 <insert_sorted_with_merge_freeList+0x3e3>
  803456:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803459:	8b 00                	mov    (%eax),%eax
  80345b:	a3 38 51 80 00       	mov    %eax,0x805138
  803460:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803463:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803469:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80346c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803473:	a1 44 51 80 00       	mov    0x805144,%eax
  803478:	48                   	dec    %eax
  803479:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  80347e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803481:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803488:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80348b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803492:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803496:	75 17                	jne    8034af <insert_sorted_with_merge_freeList+0x432>
  803498:	83 ec 04             	sub    $0x4,%esp
  80349b:	68 f8 43 80 00       	push   $0x8043f8
  8034a0:	68 5f 01 00 00       	push   $0x15f
  8034a5:	68 1b 44 80 00       	push   $0x80441b
  8034aa:	e8 6f d2 ff ff       	call   80071e <_panic>
  8034af:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8034b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034b8:	89 10                	mov    %edx,(%eax)
  8034ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034bd:	8b 00                	mov    (%eax),%eax
  8034bf:	85 c0                	test   %eax,%eax
  8034c1:	74 0d                	je     8034d0 <insert_sorted_with_merge_freeList+0x453>
  8034c3:	a1 48 51 80 00       	mov    0x805148,%eax
  8034c8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8034cb:	89 50 04             	mov    %edx,0x4(%eax)
  8034ce:	eb 08                	jmp    8034d8 <insert_sorted_with_merge_freeList+0x45b>
  8034d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034d3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8034d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034db:	a3 48 51 80 00       	mov    %eax,0x805148
  8034e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034e3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034ea:	a1 54 51 80 00       	mov    0x805154,%eax
  8034ef:	40                   	inc    %eax
  8034f0:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  8034f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034f8:	8b 50 0c             	mov    0xc(%eax),%edx
  8034fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8034fe:	8b 40 0c             	mov    0xc(%eax),%eax
  803501:	01 c2                	add    %eax,%edx
  803503:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803506:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803509:	8b 45 08             	mov    0x8(%ebp),%eax
  80350c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803513:	8b 45 08             	mov    0x8(%ebp),%eax
  803516:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80351d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803521:	75 17                	jne    80353a <insert_sorted_with_merge_freeList+0x4bd>
  803523:	83 ec 04             	sub    $0x4,%esp
  803526:	68 f8 43 80 00       	push   $0x8043f8
  80352b:	68 64 01 00 00       	push   $0x164
  803530:	68 1b 44 80 00       	push   $0x80441b
  803535:	e8 e4 d1 ff ff       	call   80071e <_panic>
  80353a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803540:	8b 45 08             	mov    0x8(%ebp),%eax
  803543:	89 10                	mov    %edx,(%eax)
  803545:	8b 45 08             	mov    0x8(%ebp),%eax
  803548:	8b 00                	mov    (%eax),%eax
  80354a:	85 c0                	test   %eax,%eax
  80354c:	74 0d                	je     80355b <insert_sorted_with_merge_freeList+0x4de>
  80354e:	a1 48 51 80 00       	mov    0x805148,%eax
  803553:	8b 55 08             	mov    0x8(%ebp),%edx
  803556:	89 50 04             	mov    %edx,0x4(%eax)
  803559:	eb 08                	jmp    803563 <insert_sorted_with_merge_freeList+0x4e6>
  80355b:	8b 45 08             	mov    0x8(%ebp),%eax
  80355e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803563:	8b 45 08             	mov    0x8(%ebp),%eax
  803566:	a3 48 51 80 00       	mov    %eax,0x805148
  80356b:	8b 45 08             	mov    0x8(%ebp),%eax
  80356e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803575:	a1 54 51 80 00       	mov    0x805154,%eax
  80357a:	40                   	inc    %eax
  80357b:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803580:	e9 41 02 00 00       	jmp    8037c6 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803585:	8b 45 08             	mov    0x8(%ebp),%eax
  803588:	8b 50 08             	mov    0x8(%eax),%edx
  80358b:	8b 45 08             	mov    0x8(%ebp),%eax
  80358e:	8b 40 0c             	mov    0xc(%eax),%eax
  803591:	01 c2                	add    %eax,%edx
  803593:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803596:	8b 40 08             	mov    0x8(%eax),%eax
  803599:	39 c2                	cmp    %eax,%edx
  80359b:	0f 85 7c 01 00 00    	jne    80371d <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8035a1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8035a5:	74 06                	je     8035ad <insert_sorted_with_merge_freeList+0x530>
  8035a7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035ab:	75 17                	jne    8035c4 <insert_sorted_with_merge_freeList+0x547>
  8035ad:	83 ec 04             	sub    $0x4,%esp
  8035b0:	68 34 44 80 00       	push   $0x804434
  8035b5:	68 69 01 00 00       	push   $0x169
  8035ba:	68 1b 44 80 00       	push   $0x80441b
  8035bf:	e8 5a d1 ff ff       	call   80071e <_panic>
  8035c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035c7:	8b 50 04             	mov    0x4(%eax),%edx
  8035ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8035cd:	89 50 04             	mov    %edx,0x4(%eax)
  8035d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8035d6:	89 10                	mov    %edx,(%eax)
  8035d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035db:	8b 40 04             	mov    0x4(%eax),%eax
  8035de:	85 c0                	test   %eax,%eax
  8035e0:	74 0d                	je     8035ef <insert_sorted_with_merge_freeList+0x572>
  8035e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035e5:	8b 40 04             	mov    0x4(%eax),%eax
  8035e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8035eb:	89 10                	mov    %edx,(%eax)
  8035ed:	eb 08                	jmp    8035f7 <insert_sorted_with_merge_freeList+0x57a>
  8035ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f2:	a3 38 51 80 00       	mov    %eax,0x805138
  8035f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035fa:	8b 55 08             	mov    0x8(%ebp),%edx
  8035fd:	89 50 04             	mov    %edx,0x4(%eax)
  803600:	a1 44 51 80 00       	mov    0x805144,%eax
  803605:	40                   	inc    %eax
  803606:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  80360b:	8b 45 08             	mov    0x8(%ebp),%eax
  80360e:	8b 50 0c             	mov    0xc(%eax),%edx
  803611:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803614:	8b 40 0c             	mov    0xc(%eax),%eax
  803617:	01 c2                	add    %eax,%edx
  803619:	8b 45 08             	mov    0x8(%ebp),%eax
  80361c:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80361f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803623:	75 17                	jne    80363c <insert_sorted_with_merge_freeList+0x5bf>
  803625:	83 ec 04             	sub    $0x4,%esp
  803628:	68 c4 44 80 00       	push   $0x8044c4
  80362d:	68 6b 01 00 00       	push   $0x16b
  803632:	68 1b 44 80 00       	push   $0x80441b
  803637:	e8 e2 d0 ff ff       	call   80071e <_panic>
  80363c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80363f:	8b 00                	mov    (%eax),%eax
  803641:	85 c0                	test   %eax,%eax
  803643:	74 10                	je     803655 <insert_sorted_with_merge_freeList+0x5d8>
  803645:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803648:	8b 00                	mov    (%eax),%eax
  80364a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80364d:	8b 52 04             	mov    0x4(%edx),%edx
  803650:	89 50 04             	mov    %edx,0x4(%eax)
  803653:	eb 0b                	jmp    803660 <insert_sorted_with_merge_freeList+0x5e3>
  803655:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803658:	8b 40 04             	mov    0x4(%eax),%eax
  80365b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803660:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803663:	8b 40 04             	mov    0x4(%eax),%eax
  803666:	85 c0                	test   %eax,%eax
  803668:	74 0f                	je     803679 <insert_sorted_with_merge_freeList+0x5fc>
  80366a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80366d:	8b 40 04             	mov    0x4(%eax),%eax
  803670:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803673:	8b 12                	mov    (%edx),%edx
  803675:	89 10                	mov    %edx,(%eax)
  803677:	eb 0a                	jmp    803683 <insert_sorted_with_merge_freeList+0x606>
  803679:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80367c:	8b 00                	mov    (%eax),%eax
  80367e:	a3 38 51 80 00       	mov    %eax,0x805138
  803683:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803686:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80368c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80368f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803696:	a1 44 51 80 00       	mov    0x805144,%eax
  80369b:	48                   	dec    %eax
  80369c:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  8036a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036a4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8036ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036ae:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8036b5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8036b9:	75 17                	jne    8036d2 <insert_sorted_with_merge_freeList+0x655>
  8036bb:	83 ec 04             	sub    $0x4,%esp
  8036be:	68 f8 43 80 00       	push   $0x8043f8
  8036c3:	68 6e 01 00 00       	push   $0x16e
  8036c8:	68 1b 44 80 00       	push   $0x80441b
  8036cd:	e8 4c d0 ff ff       	call   80071e <_panic>
  8036d2:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8036d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036db:	89 10                	mov    %edx,(%eax)
  8036dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036e0:	8b 00                	mov    (%eax),%eax
  8036e2:	85 c0                	test   %eax,%eax
  8036e4:	74 0d                	je     8036f3 <insert_sorted_with_merge_freeList+0x676>
  8036e6:	a1 48 51 80 00       	mov    0x805148,%eax
  8036eb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8036ee:	89 50 04             	mov    %edx,0x4(%eax)
  8036f1:	eb 08                	jmp    8036fb <insert_sorted_with_merge_freeList+0x67e>
  8036f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036f6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8036fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036fe:	a3 48 51 80 00       	mov    %eax,0x805148
  803703:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803706:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80370d:	a1 54 51 80 00       	mov    0x805154,%eax
  803712:	40                   	inc    %eax
  803713:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803718:	e9 a9 00 00 00       	jmp    8037c6 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  80371d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803721:	74 06                	je     803729 <insert_sorted_with_merge_freeList+0x6ac>
  803723:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803727:	75 17                	jne    803740 <insert_sorted_with_merge_freeList+0x6c3>
  803729:	83 ec 04             	sub    $0x4,%esp
  80372c:	68 90 44 80 00       	push   $0x804490
  803731:	68 73 01 00 00       	push   $0x173
  803736:	68 1b 44 80 00       	push   $0x80441b
  80373b:	e8 de cf ff ff       	call   80071e <_panic>
  803740:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803743:	8b 10                	mov    (%eax),%edx
  803745:	8b 45 08             	mov    0x8(%ebp),%eax
  803748:	89 10                	mov    %edx,(%eax)
  80374a:	8b 45 08             	mov    0x8(%ebp),%eax
  80374d:	8b 00                	mov    (%eax),%eax
  80374f:	85 c0                	test   %eax,%eax
  803751:	74 0b                	je     80375e <insert_sorted_with_merge_freeList+0x6e1>
  803753:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803756:	8b 00                	mov    (%eax),%eax
  803758:	8b 55 08             	mov    0x8(%ebp),%edx
  80375b:	89 50 04             	mov    %edx,0x4(%eax)
  80375e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803761:	8b 55 08             	mov    0x8(%ebp),%edx
  803764:	89 10                	mov    %edx,(%eax)
  803766:	8b 45 08             	mov    0x8(%ebp),%eax
  803769:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80376c:	89 50 04             	mov    %edx,0x4(%eax)
  80376f:	8b 45 08             	mov    0x8(%ebp),%eax
  803772:	8b 00                	mov    (%eax),%eax
  803774:	85 c0                	test   %eax,%eax
  803776:	75 08                	jne    803780 <insert_sorted_with_merge_freeList+0x703>
  803778:	8b 45 08             	mov    0x8(%ebp),%eax
  80377b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803780:	a1 44 51 80 00       	mov    0x805144,%eax
  803785:	40                   	inc    %eax
  803786:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  80378b:	eb 39                	jmp    8037c6 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80378d:	a1 40 51 80 00       	mov    0x805140,%eax
  803792:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803795:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803799:	74 07                	je     8037a2 <insert_sorted_with_merge_freeList+0x725>
  80379b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80379e:	8b 00                	mov    (%eax),%eax
  8037a0:	eb 05                	jmp    8037a7 <insert_sorted_with_merge_freeList+0x72a>
  8037a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8037a7:	a3 40 51 80 00       	mov    %eax,0x805140
  8037ac:	a1 40 51 80 00       	mov    0x805140,%eax
  8037b1:	85 c0                	test   %eax,%eax
  8037b3:	0f 85 c7 fb ff ff    	jne    803380 <insert_sorted_with_merge_freeList+0x303>
  8037b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037bd:	0f 85 bd fb ff ff    	jne    803380 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8037c3:	eb 01                	jmp    8037c6 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8037c5:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8037c6:	90                   	nop
  8037c7:	c9                   	leave  
  8037c8:	c3                   	ret    

008037c9 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8037c9:	55                   	push   %ebp
  8037ca:	89 e5                	mov    %esp,%ebp
  8037cc:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8037cf:	8b 55 08             	mov    0x8(%ebp),%edx
  8037d2:	89 d0                	mov    %edx,%eax
  8037d4:	c1 e0 02             	shl    $0x2,%eax
  8037d7:	01 d0                	add    %edx,%eax
  8037d9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8037e0:	01 d0                	add    %edx,%eax
  8037e2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8037e9:	01 d0                	add    %edx,%eax
  8037eb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8037f2:	01 d0                	add    %edx,%eax
  8037f4:	c1 e0 04             	shl    $0x4,%eax
  8037f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8037fa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  803801:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803804:	83 ec 0c             	sub    $0xc,%esp
  803807:	50                   	push   %eax
  803808:	e8 26 e7 ff ff       	call   801f33 <sys_get_virtual_time>
  80380d:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803810:	eb 41                	jmp    803853 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  803812:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803815:	83 ec 0c             	sub    $0xc,%esp
  803818:	50                   	push   %eax
  803819:	e8 15 e7 ff ff       	call   801f33 <sys_get_virtual_time>
  80381e:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803821:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803824:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803827:	29 c2                	sub    %eax,%edx
  803829:	89 d0                	mov    %edx,%eax
  80382b:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  80382e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803831:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803834:	89 d1                	mov    %edx,%ecx
  803836:	29 c1                	sub    %eax,%ecx
  803838:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80383b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80383e:	39 c2                	cmp    %eax,%edx
  803840:	0f 97 c0             	seta   %al
  803843:	0f b6 c0             	movzbl %al,%eax
  803846:	29 c1                	sub    %eax,%ecx
  803848:	89 c8                	mov    %ecx,%eax
  80384a:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  80384d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803850:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  803853:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803856:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803859:	72 b7                	jb     803812 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  80385b:	90                   	nop
  80385c:	c9                   	leave  
  80385d:	c3                   	ret    

0080385e <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  80385e:	55                   	push   %ebp
  80385f:	89 e5                	mov    %esp,%ebp
  803861:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803864:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  80386b:	eb 03                	jmp    803870 <busy_wait+0x12>
  80386d:	ff 45 fc             	incl   -0x4(%ebp)
  803870:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803873:	3b 45 08             	cmp    0x8(%ebp),%eax
  803876:	72 f5                	jb     80386d <busy_wait+0xf>
	return i;
  803878:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80387b:	c9                   	leave  
  80387c:	c3                   	ret    
  80387d:	66 90                	xchg   %ax,%ax
  80387f:	90                   	nop

00803880 <__udivdi3>:
  803880:	55                   	push   %ebp
  803881:	57                   	push   %edi
  803882:	56                   	push   %esi
  803883:	53                   	push   %ebx
  803884:	83 ec 1c             	sub    $0x1c,%esp
  803887:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80388b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80388f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803893:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803897:	89 ca                	mov    %ecx,%edx
  803899:	89 f8                	mov    %edi,%eax
  80389b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80389f:	85 f6                	test   %esi,%esi
  8038a1:	75 2d                	jne    8038d0 <__udivdi3+0x50>
  8038a3:	39 cf                	cmp    %ecx,%edi
  8038a5:	77 65                	ja     80390c <__udivdi3+0x8c>
  8038a7:	89 fd                	mov    %edi,%ebp
  8038a9:	85 ff                	test   %edi,%edi
  8038ab:	75 0b                	jne    8038b8 <__udivdi3+0x38>
  8038ad:	b8 01 00 00 00       	mov    $0x1,%eax
  8038b2:	31 d2                	xor    %edx,%edx
  8038b4:	f7 f7                	div    %edi
  8038b6:	89 c5                	mov    %eax,%ebp
  8038b8:	31 d2                	xor    %edx,%edx
  8038ba:	89 c8                	mov    %ecx,%eax
  8038bc:	f7 f5                	div    %ebp
  8038be:	89 c1                	mov    %eax,%ecx
  8038c0:	89 d8                	mov    %ebx,%eax
  8038c2:	f7 f5                	div    %ebp
  8038c4:	89 cf                	mov    %ecx,%edi
  8038c6:	89 fa                	mov    %edi,%edx
  8038c8:	83 c4 1c             	add    $0x1c,%esp
  8038cb:	5b                   	pop    %ebx
  8038cc:	5e                   	pop    %esi
  8038cd:	5f                   	pop    %edi
  8038ce:	5d                   	pop    %ebp
  8038cf:	c3                   	ret    
  8038d0:	39 ce                	cmp    %ecx,%esi
  8038d2:	77 28                	ja     8038fc <__udivdi3+0x7c>
  8038d4:	0f bd fe             	bsr    %esi,%edi
  8038d7:	83 f7 1f             	xor    $0x1f,%edi
  8038da:	75 40                	jne    80391c <__udivdi3+0x9c>
  8038dc:	39 ce                	cmp    %ecx,%esi
  8038de:	72 0a                	jb     8038ea <__udivdi3+0x6a>
  8038e0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8038e4:	0f 87 9e 00 00 00    	ja     803988 <__udivdi3+0x108>
  8038ea:	b8 01 00 00 00       	mov    $0x1,%eax
  8038ef:	89 fa                	mov    %edi,%edx
  8038f1:	83 c4 1c             	add    $0x1c,%esp
  8038f4:	5b                   	pop    %ebx
  8038f5:	5e                   	pop    %esi
  8038f6:	5f                   	pop    %edi
  8038f7:	5d                   	pop    %ebp
  8038f8:	c3                   	ret    
  8038f9:	8d 76 00             	lea    0x0(%esi),%esi
  8038fc:	31 ff                	xor    %edi,%edi
  8038fe:	31 c0                	xor    %eax,%eax
  803900:	89 fa                	mov    %edi,%edx
  803902:	83 c4 1c             	add    $0x1c,%esp
  803905:	5b                   	pop    %ebx
  803906:	5e                   	pop    %esi
  803907:	5f                   	pop    %edi
  803908:	5d                   	pop    %ebp
  803909:	c3                   	ret    
  80390a:	66 90                	xchg   %ax,%ax
  80390c:	89 d8                	mov    %ebx,%eax
  80390e:	f7 f7                	div    %edi
  803910:	31 ff                	xor    %edi,%edi
  803912:	89 fa                	mov    %edi,%edx
  803914:	83 c4 1c             	add    $0x1c,%esp
  803917:	5b                   	pop    %ebx
  803918:	5e                   	pop    %esi
  803919:	5f                   	pop    %edi
  80391a:	5d                   	pop    %ebp
  80391b:	c3                   	ret    
  80391c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803921:	89 eb                	mov    %ebp,%ebx
  803923:	29 fb                	sub    %edi,%ebx
  803925:	89 f9                	mov    %edi,%ecx
  803927:	d3 e6                	shl    %cl,%esi
  803929:	89 c5                	mov    %eax,%ebp
  80392b:	88 d9                	mov    %bl,%cl
  80392d:	d3 ed                	shr    %cl,%ebp
  80392f:	89 e9                	mov    %ebp,%ecx
  803931:	09 f1                	or     %esi,%ecx
  803933:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803937:	89 f9                	mov    %edi,%ecx
  803939:	d3 e0                	shl    %cl,%eax
  80393b:	89 c5                	mov    %eax,%ebp
  80393d:	89 d6                	mov    %edx,%esi
  80393f:	88 d9                	mov    %bl,%cl
  803941:	d3 ee                	shr    %cl,%esi
  803943:	89 f9                	mov    %edi,%ecx
  803945:	d3 e2                	shl    %cl,%edx
  803947:	8b 44 24 08          	mov    0x8(%esp),%eax
  80394b:	88 d9                	mov    %bl,%cl
  80394d:	d3 e8                	shr    %cl,%eax
  80394f:	09 c2                	or     %eax,%edx
  803951:	89 d0                	mov    %edx,%eax
  803953:	89 f2                	mov    %esi,%edx
  803955:	f7 74 24 0c          	divl   0xc(%esp)
  803959:	89 d6                	mov    %edx,%esi
  80395b:	89 c3                	mov    %eax,%ebx
  80395d:	f7 e5                	mul    %ebp
  80395f:	39 d6                	cmp    %edx,%esi
  803961:	72 19                	jb     80397c <__udivdi3+0xfc>
  803963:	74 0b                	je     803970 <__udivdi3+0xf0>
  803965:	89 d8                	mov    %ebx,%eax
  803967:	31 ff                	xor    %edi,%edi
  803969:	e9 58 ff ff ff       	jmp    8038c6 <__udivdi3+0x46>
  80396e:	66 90                	xchg   %ax,%ax
  803970:	8b 54 24 08          	mov    0x8(%esp),%edx
  803974:	89 f9                	mov    %edi,%ecx
  803976:	d3 e2                	shl    %cl,%edx
  803978:	39 c2                	cmp    %eax,%edx
  80397a:	73 e9                	jae    803965 <__udivdi3+0xe5>
  80397c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80397f:	31 ff                	xor    %edi,%edi
  803981:	e9 40 ff ff ff       	jmp    8038c6 <__udivdi3+0x46>
  803986:	66 90                	xchg   %ax,%ax
  803988:	31 c0                	xor    %eax,%eax
  80398a:	e9 37 ff ff ff       	jmp    8038c6 <__udivdi3+0x46>
  80398f:	90                   	nop

00803990 <__umoddi3>:
  803990:	55                   	push   %ebp
  803991:	57                   	push   %edi
  803992:	56                   	push   %esi
  803993:	53                   	push   %ebx
  803994:	83 ec 1c             	sub    $0x1c,%esp
  803997:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80399b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80399f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8039a3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8039a7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8039ab:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8039af:	89 f3                	mov    %esi,%ebx
  8039b1:	89 fa                	mov    %edi,%edx
  8039b3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8039b7:	89 34 24             	mov    %esi,(%esp)
  8039ba:	85 c0                	test   %eax,%eax
  8039bc:	75 1a                	jne    8039d8 <__umoddi3+0x48>
  8039be:	39 f7                	cmp    %esi,%edi
  8039c0:	0f 86 a2 00 00 00    	jbe    803a68 <__umoddi3+0xd8>
  8039c6:	89 c8                	mov    %ecx,%eax
  8039c8:	89 f2                	mov    %esi,%edx
  8039ca:	f7 f7                	div    %edi
  8039cc:	89 d0                	mov    %edx,%eax
  8039ce:	31 d2                	xor    %edx,%edx
  8039d0:	83 c4 1c             	add    $0x1c,%esp
  8039d3:	5b                   	pop    %ebx
  8039d4:	5e                   	pop    %esi
  8039d5:	5f                   	pop    %edi
  8039d6:	5d                   	pop    %ebp
  8039d7:	c3                   	ret    
  8039d8:	39 f0                	cmp    %esi,%eax
  8039da:	0f 87 ac 00 00 00    	ja     803a8c <__umoddi3+0xfc>
  8039e0:	0f bd e8             	bsr    %eax,%ebp
  8039e3:	83 f5 1f             	xor    $0x1f,%ebp
  8039e6:	0f 84 ac 00 00 00    	je     803a98 <__umoddi3+0x108>
  8039ec:	bf 20 00 00 00       	mov    $0x20,%edi
  8039f1:	29 ef                	sub    %ebp,%edi
  8039f3:	89 fe                	mov    %edi,%esi
  8039f5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8039f9:	89 e9                	mov    %ebp,%ecx
  8039fb:	d3 e0                	shl    %cl,%eax
  8039fd:	89 d7                	mov    %edx,%edi
  8039ff:	89 f1                	mov    %esi,%ecx
  803a01:	d3 ef                	shr    %cl,%edi
  803a03:	09 c7                	or     %eax,%edi
  803a05:	89 e9                	mov    %ebp,%ecx
  803a07:	d3 e2                	shl    %cl,%edx
  803a09:	89 14 24             	mov    %edx,(%esp)
  803a0c:	89 d8                	mov    %ebx,%eax
  803a0e:	d3 e0                	shl    %cl,%eax
  803a10:	89 c2                	mov    %eax,%edx
  803a12:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a16:	d3 e0                	shl    %cl,%eax
  803a18:	89 44 24 04          	mov    %eax,0x4(%esp)
  803a1c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a20:	89 f1                	mov    %esi,%ecx
  803a22:	d3 e8                	shr    %cl,%eax
  803a24:	09 d0                	or     %edx,%eax
  803a26:	d3 eb                	shr    %cl,%ebx
  803a28:	89 da                	mov    %ebx,%edx
  803a2a:	f7 f7                	div    %edi
  803a2c:	89 d3                	mov    %edx,%ebx
  803a2e:	f7 24 24             	mull   (%esp)
  803a31:	89 c6                	mov    %eax,%esi
  803a33:	89 d1                	mov    %edx,%ecx
  803a35:	39 d3                	cmp    %edx,%ebx
  803a37:	0f 82 87 00 00 00    	jb     803ac4 <__umoddi3+0x134>
  803a3d:	0f 84 91 00 00 00    	je     803ad4 <__umoddi3+0x144>
  803a43:	8b 54 24 04          	mov    0x4(%esp),%edx
  803a47:	29 f2                	sub    %esi,%edx
  803a49:	19 cb                	sbb    %ecx,%ebx
  803a4b:	89 d8                	mov    %ebx,%eax
  803a4d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803a51:	d3 e0                	shl    %cl,%eax
  803a53:	89 e9                	mov    %ebp,%ecx
  803a55:	d3 ea                	shr    %cl,%edx
  803a57:	09 d0                	or     %edx,%eax
  803a59:	89 e9                	mov    %ebp,%ecx
  803a5b:	d3 eb                	shr    %cl,%ebx
  803a5d:	89 da                	mov    %ebx,%edx
  803a5f:	83 c4 1c             	add    $0x1c,%esp
  803a62:	5b                   	pop    %ebx
  803a63:	5e                   	pop    %esi
  803a64:	5f                   	pop    %edi
  803a65:	5d                   	pop    %ebp
  803a66:	c3                   	ret    
  803a67:	90                   	nop
  803a68:	89 fd                	mov    %edi,%ebp
  803a6a:	85 ff                	test   %edi,%edi
  803a6c:	75 0b                	jne    803a79 <__umoddi3+0xe9>
  803a6e:	b8 01 00 00 00       	mov    $0x1,%eax
  803a73:	31 d2                	xor    %edx,%edx
  803a75:	f7 f7                	div    %edi
  803a77:	89 c5                	mov    %eax,%ebp
  803a79:	89 f0                	mov    %esi,%eax
  803a7b:	31 d2                	xor    %edx,%edx
  803a7d:	f7 f5                	div    %ebp
  803a7f:	89 c8                	mov    %ecx,%eax
  803a81:	f7 f5                	div    %ebp
  803a83:	89 d0                	mov    %edx,%eax
  803a85:	e9 44 ff ff ff       	jmp    8039ce <__umoddi3+0x3e>
  803a8a:	66 90                	xchg   %ax,%ax
  803a8c:	89 c8                	mov    %ecx,%eax
  803a8e:	89 f2                	mov    %esi,%edx
  803a90:	83 c4 1c             	add    $0x1c,%esp
  803a93:	5b                   	pop    %ebx
  803a94:	5e                   	pop    %esi
  803a95:	5f                   	pop    %edi
  803a96:	5d                   	pop    %ebp
  803a97:	c3                   	ret    
  803a98:	3b 04 24             	cmp    (%esp),%eax
  803a9b:	72 06                	jb     803aa3 <__umoddi3+0x113>
  803a9d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803aa1:	77 0f                	ja     803ab2 <__umoddi3+0x122>
  803aa3:	89 f2                	mov    %esi,%edx
  803aa5:	29 f9                	sub    %edi,%ecx
  803aa7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803aab:	89 14 24             	mov    %edx,(%esp)
  803aae:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803ab2:	8b 44 24 04          	mov    0x4(%esp),%eax
  803ab6:	8b 14 24             	mov    (%esp),%edx
  803ab9:	83 c4 1c             	add    $0x1c,%esp
  803abc:	5b                   	pop    %ebx
  803abd:	5e                   	pop    %esi
  803abe:	5f                   	pop    %edi
  803abf:	5d                   	pop    %ebp
  803ac0:	c3                   	ret    
  803ac1:	8d 76 00             	lea    0x0(%esi),%esi
  803ac4:	2b 04 24             	sub    (%esp),%eax
  803ac7:	19 fa                	sbb    %edi,%edx
  803ac9:	89 d1                	mov    %edx,%ecx
  803acb:	89 c6                	mov    %eax,%esi
  803acd:	e9 71 ff ff ff       	jmp    803a43 <__umoddi3+0xb3>
  803ad2:	66 90                	xchg   %ax,%ax
  803ad4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803ad8:	72 ea                	jb     803ac4 <__umoddi3+0x134>
  803ada:	89 d9                	mov    %ebx,%ecx
  803adc:	e9 62 ff ff ff       	jmp    803a43 <__umoddi3+0xb3>
