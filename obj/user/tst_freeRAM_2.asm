
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
  80008a:	68 20 3b 80 00       	push   $0x803b20
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
  8000ba:	68 52 3b 80 00       	push   $0x803b52
  8000bf:	e8 dd 1d 00 00       	call   801ea1 <sys_create_env>
  8000c4:	83 c4 10             	add    $0x10,%esp
  8000c7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		int freeFrames = sys_calculate_free_frames() ;
  8000ca:	e8 60 1b 00 00       	call   801c2f <sys_calculate_free_frames>
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
  8000f5:	68 56 3b 80 00       	push   $0x803b56
  8000fa:	e8 a2 1d 00 00       	call   801ea1 <sys_create_env>
  8000ff:	83 c4 10             	add    $0x10,%esp
  800102:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		int helloWorldFrames = freeFrames - sys_calculate_free_frames() ;
  800105:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800108:	e8 22 1b 00 00       	call   801c2f <sys_calculate_free_frames>
  80010d:	29 c3                	sub    %eax,%ebx
  80010f:	89 d8                	mov    %ebx,%eax
  800111:	89 45 d0             	mov    %eax,-0x30(%ebp)
		env_sleep(2000);
  800114:	83 ec 0c             	sub    $0xc,%esp
  800117:	68 d0 07 00 00       	push   $0x7d0
  80011c:	e8 d0 36 00 00       	call   8037f1 <env_sleep>
  800121:	83 c4 10             	add    $0x10,%esp
		cprintf("[DONE]\n\n");
  800124:	83 ec 0c             	sub    $0xc,%esp
  800127:	68 65 3b 80 00       	push   $0x803b65
  80012c:	e8 a1 08 00 00       	call   8009d2 <cprintf>
  800131:	83 c4 10             	add    $0x10,%esp

		//Load and run "fos_add"
		cprintf("Loading fos_add program into RAM...");
  800134:	83 ec 0c             	sub    $0xc,%esp
  800137:	68 70 3b 80 00       	push   $0x803b70
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
  800167:	68 94 3b 80 00       	push   $0x803b94
  80016c:	e8 30 1d 00 00       	call   801ea1 <sys_create_env>
  800171:	83 c4 10             	add    $0x10,%esp
  800174:	89 45 cc             	mov    %eax,-0x34(%ebp)
		env_sleep(2000);
  800177:	83 ec 0c             	sub    $0xc,%esp
  80017a:	68 d0 07 00 00       	push   $0x7d0
  80017f:	e8 6d 36 00 00       	call   8037f1 <env_sleep>
  800184:	83 c4 10             	add    $0x10,%esp
		cprintf("[DONE]\n\n");
  800187:	83 ec 0c             	sub    $0xc,%esp
  80018a:	68 65 3b 80 00       	push   $0x803b65
  80018f:	e8 3e 08 00 00       	call   8009d2 <cprintf>
  800194:	83 c4 10             	add    $0x10,%esp
		cprintf("running fos_add program...\n\n");
  800197:	83 ec 0c             	sub    $0xc,%esp
  80019a:	68 9c 3b 80 00       	push   $0x803b9c
  80019f:	e8 2e 08 00 00       	call   8009d2 <cprintf>
  8001a4:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdFOSAdd);
  8001a7:	83 ec 0c             	sub    $0xc,%esp
  8001aa:	ff 75 cc             	pushl  -0x34(%ebp)
  8001ad:	e8 0d 1d 00 00       	call   801ebf <sys_run_env>
  8001b2:	83 c4 10             	add    $0x10,%esp

		cprintf("please be patient ...\n");
  8001b5:	83 ec 0c             	sub    $0xc,%esp
  8001b8:	68 b9 3b 80 00       	push   $0x803bb9
  8001bd:	e8 10 08 00 00       	call   8009d2 <cprintf>
  8001c2:	83 c4 10             	add    $0x10,%esp
		env_sleep(5000);
  8001c5:	83 ec 0c             	sub    $0xc,%esp
  8001c8:	68 88 13 00 00       	push   $0x1388
  8001cd:	e8 1f 36 00 00       	call   8037f1 <env_sleep>
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
  800266:	e8 c4 19 00 00       	call   801c2f <sys_calculate_free_frames>
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
  800352:	68 d0 3b 80 00       	push   $0x803bd0
  800357:	e8 76 06 00 00       	call   8009d2 <cprintf>
  80035c:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdHelloWorld);
  80035f:	83 ec 0c             	sub    $0xc,%esp
  800362:	ff 75 d4             	pushl  -0x2c(%ebp)
  800365:	e8 55 1b 00 00       	call   801ebf <sys_run_env>
  80036a:	83 c4 10             	add    $0x10,%esp

		cprintf("please be patient ...\n");
  80036d:	83 ec 0c             	sub    $0xc,%esp
  800370:	68 b9 3b 80 00       	push   $0x803bb9
  800375:	e8 58 06 00 00       	call   8009d2 <cprintf>
  80037a:	83 c4 10             	add    $0x10,%esp
		env_sleep(5000);
  80037d:	83 ec 0c             	sub    $0xc,%esp
  800380:	68 88 13 00 00       	push   $0x1388
  800385:	e8 67 34 00 00       	call   8037f1 <env_sleep>
  80038a:	83 c4 10             	add    $0x10,%esp

		//Allocate the remaining RAM + extra RAM by the size of helloWorld program (Here: it requires to free some RAM by removing exited & loaded program(s) (fos_helloWorld & fib))
		freeFrames = sys_calculate_free_frames() ;
  80038d:	e8 9d 18 00 00       	call   801c2f <sys_calculate_free_frames>
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
  800444:	68 f4 3b 80 00       	push   $0x803bf4
  800449:	6a 62                	push   $0x62
  80044b:	68 29 3c 80 00       	push   $0x803c29
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
  800479:	68 f4 3b 80 00       	push   $0x803bf4
  80047e:	6a 63                	push   $0x63
  800480:	68 29 3c 80 00       	push   $0x803c29
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
  8004ad:	68 f4 3b 80 00       	push   $0x803bf4
  8004b2:	6a 64                	push   $0x64
  8004b4:	68 29 3c 80 00       	push   $0x803c29
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
  8004e1:	68 f4 3b 80 00       	push   $0x803bf4
  8004e6:	6a 65                	push   $0x65
  8004e8:	68 29 3c 80 00       	push   $0x803c29
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
  800515:	68 f4 3b 80 00       	push   $0x803bf4
  80051a:	6a 66                	push   $0x66
  80051c:	68 29 3c 80 00       	push   $0x803c29
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
  800549:	68 f4 3b 80 00       	push   $0x803bf4
  80054e:	6a 68                	push   $0x68
  800550:	68 29 3c 80 00       	push   $0x803c29
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
  800583:	68 f4 3b 80 00       	push   $0x803bf4
  800588:	6a 69                	push   $0x69
  80058a:	68 29 3c 80 00       	push   $0x803c29
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
  8005b9:	68 f4 3b 80 00       	push   $0x803bf4
  8005be:	6a 6a                	push   $0x6a
  8005c0:	68 29 3c 80 00       	push   $0x803c29
  8005c5:	e8 54 01 00 00       	call   80071e <_panic>


	}

	cprintf("Congratulations!! test freeRAM (1) completed successfully.\n");
  8005ca:	83 ec 0c             	sub    $0xc,%esp
  8005cd:	68 40 3c 80 00       	push   $0x803c40
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
  8005e8:	e8 22 19 00 00       	call   801f0f <sys_getenvindex>
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
  800653:	e8 c4 16 00 00       	call   801d1c <sys_disable_interrupt>
	cprintf("**************************************\n");
  800658:	83 ec 0c             	sub    $0xc,%esp
  80065b:	68 94 3c 80 00       	push   $0x803c94
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
  800683:	68 bc 3c 80 00       	push   $0x803cbc
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
  8006b4:	68 e4 3c 80 00       	push   $0x803ce4
  8006b9:	e8 14 03 00 00       	call   8009d2 <cprintf>
  8006be:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8006c1:	a1 20 50 80 00       	mov    0x805020,%eax
  8006c6:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8006cc:	83 ec 08             	sub    $0x8,%esp
  8006cf:	50                   	push   %eax
  8006d0:	68 3c 3d 80 00       	push   $0x803d3c
  8006d5:	e8 f8 02 00 00       	call   8009d2 <cprintf>
  8006da:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8006dd:	83 ec 0c             	sub    $0xc,%esp
  8006e0:	68 94 3c 80 00       	push   $0x803c94
  8006e5:	e8 e8 02 00 00       	call   8009d2 <cprintf>
  8006ea:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8006ed:	e8 44 16 00 00       	call   801d36 <sys_enable_interrupt>

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
  800705:	e8 d1 17 00 00       	call   801edb <sys_destroy_env>
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
  800716:	e8 26 18 00 00       	call   801f41 <sys_exit_env>
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
  80073f:	68 50 3d 80 00       	push   $0x803d50
  800744:	e8 89 02 00 00       	call   8009d2 <cprintf>
  800749:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80074c:	a1 00 50 80 00       	mov    0x805000,%eax
  800751:	ff 75 0c             	pushl  0xc(%ebp)
  800754:	ff 75 08             	pushl  0x8(%ebp)
  800757:	50                   	push   %eax
  800758:	68 55 3d 80 00       	push   $0x803d55
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
  80077c:	68 71 3d 80 00       	push   $0x803d71
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
  8007a8:	68 74 3d 80 00       	push   $0x803d74
  8007ad:	6a 26                	push   $0x26
  8007af:	68 c0 3d 80 00       	push   $0x803dc0
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
  80087a:	68 cc 3d 80 00       	push   $0x803dcc
  80087f:	6a 3a                	push   $0x3a
  800881:	68 c0 3d 80 00       	push   $0x803dc0
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
  8008ea:	68 20 3e 80 00       	push   $0x803e20
  8008ef:	6a 44                	push   $0x44
  8008f1:	68 c0 3d 80 00       	push   $0x803dc0
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
  800944:	e8 25 12 00 00       	call   801b6e <sys_cputs>
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
  8009bb:	e8 ae 11 00 00       	call   801b6e <sys_cputs>
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
  800a05:	e8 12 13 00 00       	call   801d1c <sys_disable_interrupt>
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
  800a25:	e8 0c 13 00 00       	call   801d36 <sys_enable_interrupt>
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
  800a6f:	e8 34 2e 00 00       	call   8038a8 <__udivdi3>
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
  800abf:	e8 f4 2e 00 00       	call   8039b8 <__umoddi3>
  800ac4:	83 c4 10             	add    $0x10,%esp
  800ac7:	05 94 40 80 00       	add    $0x804094,%eax
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
  800c1a:	8b 04 85 b8 40 80 00 	mov    0x8040b8(,%eax,4),%eax
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
  800cfb:	8b 34 9d 00 3f 80 00 	mov    0x803f00(,%ebx,4),%esi
  800d02:	85 f6                	test   %esi,%esi
  800d04:	75 19                	jne    800d1f <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d06:	53                   	push   %ebx
  800d07:	68 a5 40 80 00       	push   $0x8040a5
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
  800d20:	68 ae 40 80 00       	push   $0x8040ae
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
  800d4d:	be b1 40 80 00       	mov    $0x8040b1,%esi
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
  801773:	68 10 42 80 00       	push   $0x804210
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
  801843:	e8 6a 04 00 00       	call   801cb2 <sys_allocate_chunk>
  801848:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  80184b:	a1 20 51 80 00       	mov    0x805120,%eax
  801850:	83 ec 0c             	sub    $0xc,%esp
  801853:	50                   	push   %eax
  801854:	e8 df 0a 00 00       	call   802338 <initialize_MemBlocksList>
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
  801881:	68 35 42 80 00       	push   $0x804235
  801886:	6a 33                	push   $0x33
  801888:	68 53 42 80 00       	push   $0x804253
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
  801900:	68 60 42 80 00       	push   $0x804260
  801905:	6a 34                	push   $0x34
  801907:	68 53 42 80 00       	push   $0x804253
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
  80195d:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801960:	e8 f7 fd ff ff       	call   80175c <InitializeUHeap>
	if (size == 0) return NULL ;
  801965:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801969:	75 07                	jne    801972 <malloc+0x18>
  80196b:	b8 00 00 00 00       	mov    $0x0,%eax
  801970:	eb 61                	jmp    8019d3 <malloc+0x79>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
	uint32 malloc_allocsize=ROUNDUP(size,PAGE_SIZE);
  801972:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801979:	8b 55 08             	mov    0x8(%ebp),%edx
  80197c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80197f:	01 d0                	add    %edx,%eax
  801981:	48                   	dec    %eax
  801982:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801985:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801988:	ba 00 00 00 00       	mov    $0x0,%edx
  80198d:	f7 75 f0             	divl   -0x10(%ebp)
  801990:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801993:	29 d0                	sub    %edx,%eax
  801995:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 //int ret=0;
	struct MemBlock * user_block;
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801998:	e8 e3 06 00 00       	call   802080 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80199d:	85 c0                	test   %eax,%eax
  80199f:	74 11                	je     8019b2 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  8019a1:	83 ec 0c             	sub    $0xc,%esp
  8019a4:	ff 75 e8             	pushl  -0x18(%ebp)
  8019a7:	e8 4e 0d 00 00       	call   8026fa <alloc_block_FF>
  8019ac:	83 c4 10             	add    $0x10,%esp
  8019af:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(user_block!=NULL)
  8019b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8019b6:	74 16                	je     8019ce <malloc+0x74>
	{
		//sys_allocate_chunk(user_block->sva,malloc_allocsize,PERM_WRITEABLE| PERM_PRESENT);
		insert_sorted_allocList(user_block);
  8019b8:	83 ec 0c             	sub    $0xc,%esp
  8019bb:	ff 75 f4             	pushl  -0xc(%ebp)
  8019be:	e8 aa 0a 00 00       	call   80246d <insert_sorted_allocList>
  8019c3:	83 c4 10             	add    $0x10,%esp
		return (uint32 *)user_block->sva;
  8019c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019c9:	8b 40 08             	mov    0x8(%eax),%eax
  8019cc:	eb 05                	jmp    8019d3 <malloc+0x79>
	}

    return NULL;
  8019ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019d3:	c9                   	leave  
  8019d4:	c3                   	ret    

008019d5 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8019d5:	55                   	push   %ebp
  8019d6:	89 e5                	mov    %esp,%ebp
  8019d8:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  8019db:	83 ec 04             	sub    $0x4,%esp
  8019de:	68 84 42 80 00       	push   $0x804284
  8019e3:	6a 6f                	push   $0x6f
  8019e5:	68 53 42 80 00       	push   $0x804253
  8019ea:	e8 2f ed ff ff       	call   80071e <_panic>

008019ef <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8019ef:	55                   	push   %ebp
  8019f0:	89 e5                	mov    %esp,%ebp
  8019f2:	83 ec 38             	sub    $0x38,%esp
  8019f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8019f8:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8019fb:	e8 5c fd ff ff       	call   80175c <InitializeUHeap>
	if (size == 0) return NULL ;
  801a00:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a04:	75 07                	jne    801a0d <smalloc+0x1e>
  801a06:	b8 00 00 00 00       	mov    $0x0,%eax
  801a0b:	eb 7c                	jmp    801a89 <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801a0d:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801a14:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a1a:	01 d0                	add    %edx,%eax
  801a1c:	48                   	dec    %eax
  801a1d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801a20:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a23:	ba 00 00 00 00       	mov    $0x0,%edx
  801a28:	f7 75 f0             	divl   -0x10(%ebp)
  801a2b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a2e:	29 d0                	sub    %edx,%eax
  801a30:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801a33:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801a3a:	e8 41 06 00 00       	call   802080 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801a3f:	85 c0                	test   %eax,%eax
  801a41:	74 11                	je     801a54 <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  801a43:	83 ec 0c             	sub    $0xc,%esp
  801a46:	ff 75 e8             	pushl  -0x18(%ebp)
  801a49:	e8 ac 0c 00 00       	call   8026fa <alloc_block_FF>
  801a4e:	83 c4 10             	add    $0x10,%esp
  801a51:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  801a54:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a58:	74 2a                	je     801a84 <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801a5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a5d:	8b 40 08             	mov    0x8(%eax),%eax
  801a60:	89 c2                	mov    %eax,%edx
  801a62:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801a66:	52                   	push   %edx
  801a67:	50                   	push   %eax
  801a68:	ff 75 0c             	pushl  0xc(%ebp)
  801a6b:	ff 75 08             	pushl  0x8(%ebp)
  801a6e:	e8 92 03 00 00       	call   801e05 <sys_createSharedObject>
  801a73:	83 c4 10             	add    $0x10,%esp
  801a76:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  801a79:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  801a7d:	74 05                	je     801a84 <smalloc+0x95>
			return (void*)virtual_address;
  801a7f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a82:	eb 05                	jmp    801a89 <smalloc+0x9a>
	}
	return NULL;
  801a84:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801a89:	c9                   	leave  
  801a8a:	c3                   	ret    

00801a8b <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801a8b:	55                   	push   %ebp
  801a8c:	89 e5                	mov    %esp,%ebp
  801a8e:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801a91:	e8 c6 fc ff ff       	call   80175c <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801a96:	83 ec 04             	sub    $0x4,%esp
  801a99:	68 a8 42 80 00       	push   $0x8042a8
  801a9e:	68 b0 00 00 00       	push   $0xb0
  801aa3:	68 53 42 80 00       	push   $0x804253
  801aa8:	e8 71 ec ff ff       	call   80071e <_panic>

00801aad <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801aad:	55                   	push   %ebp
  801aae:	89 e5                	mov    %esp,%ebp
  801ab0:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801ab3:	e8 a4 fc ff ff       	call   80175c <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801ab8:	83 ec 04             	sub    $0x4,%esp
  801abb:	68 cc 42 80 00       	push   $0x8042cc
  801ac0:	68 f4 00 00 00       	push   $0xf4
  801ac5:	68 53 42 80 00       	push   $0x804253
  801aca:	e8 4f ec ff ff       	call   80071e <_panic>

00801acf <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801acf:	55                   	push   %ebp
  801ad0:	89 e5                	mov    %esp,%ebp
  801ad2:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801ad5:	83 ec 04             	sub    $0x4,%esp
  801ad8:	68 f4 42 80 00       	push   $0x8042f4
  801add:	68 08 01 00 00       	push   $0x108
  801ae2:	68 53 42 80 00       	push   $0x804253
  801ae7:	e8 32 ec ff ff       	call   80071e <_panic>

00801aec <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801aec:	55                   	push   %ebp
  801aed:	89 e5                	mov    %esp,%ebp
  801aef:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801af2:	83 ec 04             	sub    $0x4,%esp
  801af5:	68 18 43 80 00       	push   $0x804318
  801afa:	68 13 01 00 00       	push   $0x113
  801aff:	68 53 42 80 00       	push   $0x804253
  801b04:	e8 15 ec ff ff       	call   80071e <_panic>

00801b09 <shrink>:

}
void shrink(uint32 newSize)
{
  801b09:	55                   	push   %ebp
  801b0a:	89 e5                	mov    %esp,%ebp
  801b0c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801b0f:	83 ec 04             	sub    $0x4,%esp
  801b12:	68 18 43 80 00       	push   $0x804318
  801b17:	68 18 01 00 00       	push   $0x118
  801b1c:	68 53 42 80 00       	push   $0x804253
  801b21:	e8 f8 eb ff ff       	call   80071e <_panic>

00801b26 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801b26:	55                   	push   %ebp
  801b27:	89 e5                	mov    %esp,%ebp
  801b29:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801b2c:	83 ec 04             	sub    $0x4,%esp
  801b2f:	68 18 43 80 00       	push   $0x804318
  801b34:	68 1d 01 00 00       	push   $0x11d
  801b39:	68 53 42 80 00       	push   $0x804253
  801b3e:	e8 db eb ff ff       	call   80071e <_panic>

00801b43 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801b43:	55                   	push   %ebp
  801b44:	89 e5                	mov    %esp,%ebp
  801b46:	57                   	push   %edi
  801b47:	56                   	push   %esi
  801b48:	53                   	push   %ebx
  801b49:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b52:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b55:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b58:	8b 7d 18             	mov    0x18(%ebp),%edi
  801b5b:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801b5e:	cd 30                	int    $0x30
  801b60:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801b63:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801b66:	83 c4 10             	add    $0x10,%esp
  801b69:	5b                   	pop    %ebx
  801b6a:	5e                   	pop    %esi
  801b6b:	5f                   	pop    %edi
  801b6c:	5d                   	pop    %ebp
  801b6d:	c3                   	ret    

00801b6e <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801b6e:	55                   	push   %ebp
  801b6f:	89 e5                	mov    %esp,%ebp
  801b71:	83 ec 04             	sub    $0x4,%esp
  801b74:	8b 45 10             	mov    0x10(%ebp),%eax
  801b77:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801b7a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b81:	6a 00                	push   $0x0
  801b83:	6a 00                	push   $0x0
  801b85:	52                   	push   %edx
  801b86:	ff 75 0c             	pushl  0xc(%ebp)
  801b89:	50                   	push   %eax
  801b8a:	6a 00                	push   $0x0
  801b8c:	e8 b2 ff ff ff       	call   801b43 <syscall>
  801b91:	83 c4 18             	add    $0x18,%esp
}
  801b94:	90                   	nop
  801b95:	c9                   	leave  
  801b96:	c3                   	ret    

00801b97 <sys_cgetc>:

int
sys_cgetc(void)
{
  801b97:	55                   	push   %ebp
  801b98:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801b9a:	6a 00                	push   $0x0
  801b9c:	6a 00                	push   $0x0
  801b9e:	6a 00                	push   $0x0
  801ba0:	6a 00                	push   $0x0
  801ba2:	6a 00                	push   $0x0
  801ba4:	6a 01                	push   $0x1
  801ba6:	e8 98 ff ff ff       	call   801b43 <syscall>
  801bab:	83 c4 18             	add    $0x18,%esp
}
  801bae:	c9                   	leave  
  801baf:	c3                   	ret    

00801bb0 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801bb0:	55                   	push   %ebp
  801bb1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801bb3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bb6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb9:	6a 00                	push   $0x0
  801bbb:	6a 00                	push   $0x0
  801bbd:	6a 00                	push   $0x0
  801bbf:	52                   	push   %edx
  801bc0:	50                   	push   %eax
  801bc1:	6a 05                	push   $0x5
  801bc3:	e8 7b ff ff ff       	call   801b43 <syscall>
  801bc8:	83 c4 18             	add    $0x18,%esp
}
  801bcb:	c9                   	leave  
  801bcc:	c3                   	ret    

00801bcd <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801bcd:	55                   	push   %ebp
  801bce:	89 e5                	mov    %esp,%ebp
  801bd0:	56                   	push   %esi
  801bd1:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801bd2:	8b 75 18             	mov    0x18(%ebp),%esi
  801bd5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801bd8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bdb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bde:	8b 45 08             	mov    0x8(%ebp),%eax
  801be1:	56                   	push   %esi
  801be2:	53                   	push   %ebx
  801be3:	51                   	push   %ecx
  801be4:	52                   	push   %edx
  801be5:	50                   	push   %eax
  801be6:	6a 06                	push   $0x6
  801be8:	e8 56 ff ff ff       	call   801b43 <syscall>
  801bed:	83 c4 18             	add    $0x18,%esp
}
  801bf0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bf3:	5b                   	pop    %ebx
  801bf4:	5e                   	pop    %esi
  801bf5:	5d                   	pop    %ebp
  801bf6:	c3                   	ret    

00801bf7 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801bf7:	55                   	push   %ebp
  801bf8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801bfa:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  801c00:	6a 00                	push   $0x0
  801c02:	6a 00                	push   $0x0
  801c04:	6a 00                	push   $0x0
  801c06:	52                   	push   %edx
  801c07:	50                   	push   %eax
  801c08:	6a 07                	push   $0x7
  801c0a:	e8 34 ff ff ff       	call   801b43 <syscall>
  801c0f:	83 c4 18             	add    $0x18,%esp
}
  801c12:	c9                   	leave  
  801c13:	c3                   	ret    

00801c14 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801c14:	55                   	push   %ebp
  801c15:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801c17:	6a 00                	push   $0x0
  801c19:	6a 00                	push   $0x0
  801c1b:	6a 00                	push   $0x0
  801c1d:	ff 75 0c             	pushl  0xc(%ebp)
  801c20:	ff 75 08             	pushl  0x8(%ebp)
  801c23:	6a 08                	push   $0x8
  801c25:	e8 19 ff ff ff       	call   801b43 <syscall>
  801c2a:	83 c4 18             	add    $0x18,%esp
}
  801c2d:	c9                   	leave  
  801c2e:	c3                   	ret    

00801c2f <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801c2f:	55                   	push   %ebp
  801c30:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801c32:	6a 00                	push   $0x0
  801c34:	6a 00                	push   $0x0
  801c36:	6a 00                	push   $0x0
  801c38:	6a 00                	push   $0x0
  801c3a:	6a 00                	push   $0x0
  801c3c:	6a 09                	push   $0x9
  801c3e:	e8 00 ff ff ff       	call   801b43 <syscall>
  801c43:	83 c4 18             	add    $0x18,%esp
}
  801c46:	c9                   	leave  
  801c47:	c3                   	ret    

00801c48 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801c48:	55                   	push   %ebp
  801c49:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801c4b:	6a 00                	push   $0x0
  801c4d:	6a 00                	push   $0x0
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 00                	push   $0x0
  801c53:	6a 00                	push   $0x0
  801c55:	6a 0a                	push   $0xa
  801c57:	e8 e7 fe ff ff       	call   801b43 <syscall>
  801c5c:	83 c4 18             	add    $0x18,%esp
}
  801c5f:	c9                   	leave  
  801c60:	c3                   	ret    

00801c61 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801c61:	55                   	push   %ebp
  801c62:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801c64:	6a 00                	push   $0x0
  801c66:	6a 00                	push   $0x0
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 00                	push   $0x0
  801c6c:	6a 00                	push   $0x0
  801c6e:	6a 0b                	push   $0xb
  801c70:	e8 ce fe ff ff       	call   801b43 <syscall>
  801c75:	83 c4 18             	add    $0x18,%esp
}
  801c78:	c9                   	leave  
  801c79:	c3                   	ret    

00801c7a <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801c7a:	55                   	push   %ebp
  801c7b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801c7d:	6a 00                	push   $0x0
  801c7f:	6a 00                	push   $0x0
  801c81:	6a 00                	push   $0x0
  801c83:	ff 75 0c             	pushl  0xc(%ebp)
  801c86:	ff 75 08             	pushl  0x8(%ebp)
  801c89:	6a 0f                	push   $0xf
  801c8b:	e8 b3 fe ff ff       	call   801b43 <syscall>
  801c90:	83 c4 18             	add    $0x18,%esp
	return;
  801c93:	90                   	nop
}
  801c94:	c9                   	leave  
  801c95:	c3                   	ret    

00801c96 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801c96:	55                   	push   %ebp
  801c97:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801c99:	6a 00                	push   $0x0
  801c9b:	6a 00                	push   $0x0
  801c9d:	6a 00                	push   $0x0
  801c9f:	ff 75 0c             	pushl  0xc(%ebp)
  801ca2:	ff 75 08             	pushl  0x8(%ebp)
  801ca5:	6a 10                	push   $0x10
  801ca7:	e8 97 fe ff ff       	call   801b43 <syscall>
  801cac:	83 c4 18             	add    $0x18,%esp
	return ;
  801caf:	90                   	nop
}
  801cb0:	c9                   	leave  
  801cb1:	c3                   	ret    

00801cb2 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801cb2:	55                   	push   %ebp
  801cb3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801cb5:	6a 00                	push   $0x0
  801cb7:	6a 00                	push   $0x0
  801cb9:	ff 75 10             	pushl  0x10(%ebp)
  801cbc:	ff 75 0c             	pushl  0xc(%ebp)
  801cbf:	ff 75 08             	pushl  0x8(%ebp)
  801cc2:	6a 11                	push   $0x11
  801cc4:	e8 7a fe ff ff       	call   801b43 <syscall>
  801cc9:	83 c4 18             	add    $0x18,%esp
	return ;
  801ccc:	90                   	nop
}
  801ccd:	c9                   	leave  
  801cce:	c3                   	ret    

00801ccf <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801ccf:	55                   	push   %ebp
  801cd0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801cd2:	6a 00                	push   $0x0
  801cd4:	6a 00                	push   $0x0
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 00                	push   $0x0
  801cda:	6a 00                	push   $0x0
  801cdc:	6a 0c                	push   $0xc
  801cde:	e8 60 fe ff ff       	call   801b43 <syscall>
  801ce3:	83 c4 18             	add    $0x18,%esp
}
  801ce6:	c9                   	leave  
  801ce7:	c3                   	ret    

00801ce8 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801ce8:	55                   	push   %ebp
  801ce9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801ceb:	6a 00                	push   $0x0
  801ced:	6a 00                	push   $0x0
  801cef:	6a 00                	push   $0x0
  801cf1:	6a 00                	push   $0x0
  801cf3:	ff 75 08             	pushl  0x8(%ebp)
  801cf6:	6a 0d                	push   $0xd
  801cf8:	e8 46 fe ff ff       	call   801b43 <syscall>
  801cfd:	83 c4 18             	add    $0x18,%esp
}
  801d00:	c9                   	leave  
  801d01:	c3                   	ret    

00801d02 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801d02:	55                   	push   %ebp
  801d03:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801d05:	6a 00                	push   $0x0
  801d07:	6a 00                	push   $0x0
  801d09:	6a 00                	push   $0x0
  801d0b:	6a 00                	push   $0x0
  801d0d:	6a 00                	push   $0x0
  801d0f:	6a 0e                	push   $0xe
  801d11:	e8 2d fe ff ff       	call   801b43 <syscall>
  801d16:	83 c4 18             	add    $0x18,%esp
}
  801d19:	90                   	nop
  801d1a:	c9                   	leave  
  801d1b:	c3                   	ret    

00801d1c <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801d1c:	55                   	push   %ebp
  801d1d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801d1f:	6a 00                	push   $0x0
  801d21:	6a 00                	push   $0x0
  801d23:	6a 00                	push   $0x0
  801d25:	6a 00                	push   $0x0
  801d27:	6a 00                	push   $0x0
  801d29:	6a 13                	push   $0x13
  801d2b:	e8 13 fe ff ff       	call   801b43 <syscall>
  801d30:	83 c4 18             	add    $0x18,%esp
}
  801d33:	90                   	nop
  801d34:	c9                   	leave  
  801d35:	c3                   	ret    

00801d36 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801d36:	55                   	push   %ebp
  801d37:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801d39:	6a 00                	push   $0x0
  801d3b:	6a 00                	push   $0x0
  801d3d:	6a 00                	push   $0x0
  801d3f:	6a 00                	push   $0x0
  801d41:	6a 00                	push   $0x0
  801d43:	6a 14                	push   $0x14
  801d45:	e8 f9 fd ff ff       	call   801b43 <syscall>
  801d4a:	83 c4 18             	add    $0x18,%esp
}
  801d4d:	90                   	nop
  801d4e:	c9                   	leave  
  801d4f:	c3                   	ret    

00801d50 <sys_cputc>:


void
sys_cputc(const char c)
{
  801d50:	55                   	push   %ebp
  801d51:	89 e5                	mov    %esp,%ebp
  801d53:	83 ec 04             	sub    $0x4,%esp
  801d56:	8b 45 08             	mov    0x8(%ebp),%eax
  801d59:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801d5c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d60:	6a 00                	push   $0x0
  801d62:	6a 00                	push   $0x0
  801d64:	6a 00                	push   $0x0
  801d66:	6a 00                	push   $0x0
  801d68:	50                   	push   %eax
  801d69:	6a 15                	push   $0x15
  801d6b:	e8 d3 fd ff ff       	call   801b43 <syscall>
  801d70:	83 c4 18             	add    $0x18,%esp
}
  801d73:	90                   	nop
  801d74:	c9                   	leave  
  801d75:	c3                   	ret    

00801d76 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801d76:	55                   	push   %ebp
  801d77:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801d79:	6a 00                	push   $0x0
  801d7b:	6a 00                	push   $0x0
  801d7d:	6a 00                	push   $0x0
  801d7f:	6a 00                	push   $0x0
  801d81:	6a 00                	push   $0x0
  801d83:	6a 16                	push   $0x16
  801d85:	e8 b9 fd ff ff       	call   801b43 <syscall>
  801d8a:	83 c4 18             	add    $0x18,%esp
}
  801d8d:	90                   	nop
  801d8e:	c9                   	leave  
  801d8f:	c3                   	ret    

00801d90 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801d90:	55                   	push   %ebp
  801d91:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801d93:	8b 45 08             	mov    0x8(%ebp),%eax
  801d96:	6a 00                	push   $0x0
  801d98:	6a 00                	push   $0x0
  801d9a:	6a 00                	push   $0x0
  801d9c:	ff 75 0c             	pushl  0xc(%ebp)
  801d9f:	50                   	push   %eax
  801da0:	6a 17                	push   $0x17
  801da2:	e8 9c fd ff ff       	call   801b43 <syscall>
  801da7:	83 c4 18             	add    $0x18,%esp
}
  801daa:	c9                   	leave  
  801dab:	c3                   	ret    

00801dac <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801dac:	55                   	push   %ebp
  801dad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801daf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801db2:	8b 45 08             	mov    0x8(%ebp),%eax
  801db5:	6a 00                	push   $0x0
  801db7:	6a 00                	push   $0x0
  801db9:	6a 00                	push   $0x0
  801dbb:	52                   	push   %edx
  801dbc:	50                   	push   %eax
  801dbd:	6a 1a                	push   $0x1a
  801dbf:	e8 7f fd ff ff       	call   801b43 <syscall>
  801dc4:	83 c4 18             	add    $0x18,%esp
}
  801dc7:	c9                   	leave  
  801dc8:	c3                   	ret    

00801dc9 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801dc9:	55                   	push   %ebp
  801dca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801dcc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dcf:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd2:	6a 00                	push   $0x0
  801dd4:	6a 00                	push   $0x0
  801dd6:	6a 00                	push   $0x0
  801dd8:	52                   	push   %edx
  801dd9:	50                   	push   %eax
  801dda:	6a 18                	push   $0x18
  801ddc:	e8 62 fd ff ff       	call   801b43 <syscall>
  801de1:	83 c4 18             	add    $0x18,%esp
}
  801de4:	90                   	nop
  801de5:	c9                   	leave  
  801de6:	c3                   	ret    

00801de7 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801de7:	55                   	push   %ebp
  801de8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801dea:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ded:	8b 45 08             	mov    0x8(%ebp),%eax
  801df0:	6a 00                	push   $0x0
  801df2:	6a 00                	push   $0x0
  801df4:	6a 00                	push   $0x0
  801df6:	52                   	push   %edx
  801df7:	50                   	push   %eax
  801df8:	6a 19                	push   $0x19
  801dfa:	e8 44 fd ff ff       	call   801b43 <syscall>
  801dff:	83 c4 18             	add    $0x18,%esp
}
  801e02:	90                   	nop
  801e03:	c9                   	leave  
  801e04:	c3                   	ret    

00801e05 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801e05:	55                   	push   %ebp
  801e06:	89 e5                	mov    %esp,%ebp
  801e08:	83 ec 04             	sub    $0x4,%esp
  801e0b:	8b 45 10             	mov    0x10(%ebp),%eax
  801e0e:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801e11:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801e14:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801e18:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1b:	6a 00                	push   $0x0
  801e1d:	51                   	push   %ecx
  801e1e:	52                   	push   %edx
  801e1f:	ff 75 0c             	pushl  0xc(%ebp)
  801e22:	50                   	push   %eax
  801e23:	6a 1b                	push   $0x1b
  801e25:	e8 19 fd ff ff       	call   801b43 <syscall>
  801e2a:	83 c4 18             	add    $0x18,%esp
}
  801e2d:	c9                   	leave  
  801e2e:	c3                   	ret    

00801e2f <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801e2f:	55                   	push   %ebp
  801e30:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801e32:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e35:	8b 45 08             	mov    0x8(%ebp),%eax
  801e38:	6a 00                	push   $0x0
  801e3a:	6a 00                	push   $0x0
  801e3c:	6a 00                	push   $0x0
  801e3e:	52                   	push   %edx
  801e3f:	50                   	push   %eax
  801e40:	6a 1c                	push   $0x1c
  801e42:	e8 fc fc ff ff       	call   801b43 <syscall>
  801e47:	83 c4 18             	add    $0x18,%esp
}
  801e4a:	c9                   	leave  
  801e4b:	c3                   	ret    

00801e4c <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801e4c:	55                   	push   %ebp
  801e4d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801e4f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e52:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e55:	8b 45 08             	mov    0x8(%ebp),%eax
  801e58:	6a 00                	push   $0x0
  801e5a:	6a 00                	push   $0x0
  801e5c:	51                   	push   %ecx
  801e5d:	52                   	push   %edx
  801e5e:	50                   	push   %eax
  801e5f:	6a 1d                	push   $0x1d
  801e61:	e8 dd fc ff ff       	call   801b43 <syscall>
  801e66:	83 c4 18             	add    $0x18,%esp
}
  801e69:	c9                   	leave  
  801e6a:	c3                   	ret    

00801e6b <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801e6b:	55                   	push   %ebp
  801e6c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801e6e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e71:	8b 45 08             	mov    0x8(%ebp),%eax
  801e74:	6a 00                	push   $0x0
  801e76:	6a 00                	push   $0x0
  801e78:	6a 00                	push   $0x0
  801e7a:	52                   	push   %edx
  801e7b:	50                   	push   %eax
  801e7c:	6a 1e                	push   $0x1e
  801e7e:	e8 c0 fc ff ff       	call   801b43 <syscall>
  801e83:	83 c4 18             	add    $0x18,%esp
}
  801e86:	c9                   	leave  
  801e87:	c3                   	ret    

00801e88 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801e88:	55                   	push   %ebp
  801e89:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801e8b:	6a 00                	push   $0x0
  801e8d:	6a 00                	push   $0x0
  801e8f:	6a 00                	push   $0x0
  801e91:	6a 00                	push   $0x0
  801e93:	6a 00                	push   $0x0
  801e95:	6a 1f                	push   $0x1f
  801e97:	e8 a7 fc ff ff       	call   801b43 <syscall>
  801e9c:	83 c4 18             	add    $0x18,%esp
}
  801e9f:	c9                   	leave  
  801ea0:	c3                   	ret    

00801ea1 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801ea1:	55                   	push   %ebp
  801ea2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801ea4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea7:	6a 00                	push   $0x0
  801ea9:	ff 75 14             	pushl  0x14(%ebp)
  801eac:	ff 75 10             	pushl  0x10(%ebp)
  801eaf:	ff 75 0c             	pushl  0xc(%ebp)
  801eb2:	50                   	push   %eax
  801eb3:	6a 20                	push   $0x20
  801eb5:	e8 89 fc ff ff       	call   801b43 <syscall>
  801eba:	83 c4 18             	add    $0x18,%esp
}
  801ebd:	c9                   	leave  
  801ebe:	c3                   	ret    

00801ebf <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801ebf:	55                   	push   %ebp
  801ec0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec5:	6a 00                	push   $0x0
  801ec7:	6a 00                	push   $0x0
  801ec9:	6a 00                	push   $0x0
  801ecb:	6a 00                	push   $0x0
  801ecd:	50                   	push   %eax
  801ece:	6a 21                	push   $0x21
  801ed0:	e8 6e fc ff ff       	call   801b43 <syscall>
  801ed5:	83 c4 18             	add    $0x18,%esp
}
  801ed8:	90                   	nop
  801ed9:	c9                   	leave  
  801eda:	c3                   	ret    

00801edb <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801edb:	55                   	push   %ebp
  801edc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801ede:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee1:	6a 00                	push   $0x0
  801ee3:	6a 00                	push   $0x0
  801ee5:	6a 00                	push   $0x0
  801ee7:	6a 00                	push   $0x0
  801ee9:	50                   	push   %eax
  801eea:	6a 22                	push   $0x22
  801eec:	e8 52 fc ff ff       	call   801b43 <syscall>
  801ef1:	83 c4 18             	add    $0x18,%esp
}
  801ef4:	c9                   	leave  
  801ef5:	c3                   	ret    

00801ef6 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801ef6:	55                   	push   %ebp
  801ef7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801ef9:	6a 00                	push   $0x0
  801efb:	6a 00                	push   $0x0
  801efd:	6a 00                	push   $0x0
  801eff:	6a 00                	push   $0x0
  801f01:	6a 00                	push   $0x0
  801f03:	6a 02                	push   $0x2
  801f05:	e8 39 fc ff ff       	call   801b43 <syscall>
  801f0a:	83 c4 18             	add    $0x18,%esp
}
  801f0d:	c9                   	leave  
  801f0e:	c3                   	ret    

00801f0f <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801f0f:	55                   	push   %ebp
  801f10:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801f12:	6a 00                	push   $0x0
  801f14:	6a 00                	push   $0x0
  801f16:	6a 00                	push   $0x0
  801f18:	6a 00                	push   $0x0
  801f1a:	6a 00                	push   $0x0
  801f1c:	6a 03                	push   $0x3
  801f1e:	e8 20 fc ff ff       	call   801b43 <syscall>
  801f23:	83 c4 18             	add    $0x18,%esp
}
  801f26:	c9                   	leave  
  801f27:	c3                   	ret    

00801f28 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801f28:	55                   	push   %ebp
  801f29:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801f2b:	6a 00                	push   $0x0
  801f2d:	6a 00                	push   $0x0
  801f2f:	6a 00                	push   $0x0
  801f31:	6a 00                	push   $0x0
  801f33:	6a 00                	push   $0x0
  801f35:	6a 04                	push   $0x4
  801f37:	e8 07 fc ff ff       	call   801b43 <syscall>
  801f3c:	83 c4 18             	add    $0x18,%esp
}
  801f3f:	c9                   	leave  
  801f40:	c3                   	ret    

00801f41 <sys_exit_env>:


void sys_exit_env(void)
{
  801f41:	55                   	push   %ebp
  801f42:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801f44:	6a 00                	push   $0x0
  801f46:	6a 00                	push   $0x0
  801f48:	6a 00                	push   $0x0
  801f4a:	6a 00                	push   $0x0
  801f4c:	6a 00                	push   $0x0
  801f4e:	6a 23                	push   $0x23
  801f50:	e8 ee fb ff ff       	call   801b43 <syscall>
  801f55:	83 c4 18             	add    $0x18,%esp
}
  801f58:	90                   	nop
  801f59:	c9                   	leave  
  801f5a:	c3                   	ret    

00801f5b <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801f5b:	55                   	push   %ebp
  801f5c:	89 e5                	mov    %esp,%ebp
  801f5e:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801f61:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f64:	8d 50 04             	lea    0x4(%eax),%edx
  801f67:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f6a:	6a 00                	push   $0x0
  801f6c:	6a 00                	push   $0x0
  801f6e:	6a 00                	push   $0x0
  801f70:	52                   	push   %edx
  801f71:	50                   	push   %eax
  801f72:	6a 24                	push   $0x24
  801f74:	e8 ca fb ff ff       	call   801b43 <syscall>
  801f79:	83 c4 18             	add    $0x18,%esp
	return result;
  801f7c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f7f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f82:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801f85:	89 01                	mov    %eax,(%ecx)
  801f87:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801f8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8d:	c9                   	leave  
  801f8e:	c2 04 00             	ret    $0x4

00801f91 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801f91:	55                   	push   %ebp
  801f92:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801f94:	6a 00                	push   $0x0
  801f96:	6a 00                	push   $0x0
  801f98:	ff 75 10             	pushl  0x10(%ebp)
  801f9b:	ff 75 0c             	pushl  0xc(%ebp)
  801f9e:	ff 75 08             	pushl  0x8(%ebp)
  801fa1:	6a 12                	push   $0x12
  801fa3:	e8 9b fb ff ff       	call   801b43 <syscall>
  801fa8:	83 c4 18             	add    $0x18,%esp
	return ;
  801fab:	90                   	nop
}
  801fac:	c9                   	leave  
  801fad:	c3                   	ret    

00801fae <sys_rcr2>:
uint32 sys_rcr2()
{
  801fae:	55                   	push   %ebp
  801faf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801fb1:	6a 00                	push   $0x0
  801fb3:	6a 00                	push   $0x0
  801fb5:	6a 00                	push   $0x0
  801fb7:	6a 00                	push   $0x0
  801fb9:	6a 00                	push   $0x0
  801fbb:	6a 25                	push   $0x25
  801fbd:	e8 81 fb ff ff       	call   801b43 <syscall>
  801fc2:	83 c4 18             	add    $0x18,%esp
}
  801fc5:	c9                   	leave  
  801fc6:	c3                   	ret    

00801fc7 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801fc7:	55                   	push   %ebp
  801fc8:	89 e5                	mov    %esp,%ebp
  801fca:	83 ec 04             	sub    $0x4,%esp
  801fcd:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801fd3:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801fd7:	6a 00                	push   $0x0
  801fd9:	6a 00                	push   $0x0
  801fdb:	6a 00                	push   $0x0
  801fdd:	6a 00                	push   $0x0
  801fdf:	50                   	push   %eax
  801fe0:	6a 26                	push   $0x26
  801fe2:	e8 5c fb ff ff       	call   801b43 <syscall>
  801fe7:	83 c4 18             	add    $0x18,%esp
	return ;
  801fea:	90                   	nop
}
  801feb:	c9                   	leave  
  801fec:	c3                   	ret    

00801fed <rsttst>:
void rsttst()
{
  801fed:	55                   	push   %ebp
  801fee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801ff0:	6a 00                	push   $0x0
  801ff2:	6a 00                	push   $0x0
  801ff4:	6a 00                	push   $0x0
  801ff6:	6a 00                	push   $0x0
  801ff8:	6a 00                	push   $0x0
  801ffa:	6a 28                	push   $0x28
  801ffc:	e8 42 fb ff ff       	call   801b43 <syscall>
  802001:	83 c4 18             	add    $0x18,%esp
	return ;
  802004:	90                   	nop
}
  802005:	c9                   	leave  
  802006:	c3                   	ret    

00802007 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802007:	55                   	push   %ebp
  802008:	89 e5                	mov    %esp,%ebp
  80200a:	83 ec 04             	sub    $0x4,%esp
  80200d:	8b 45 14             	mov    0x14(%ebp),%eax
  802010:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802013:	8b 55 18             	mov    0x18(%ebp),%edx
  802016:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80201a:	52                   	push   %edx
  80201b:	50                   	push   %eax
  80201c:	ff 75 10             	pushl  0x10(%ebp)
  80201f:	ff 75 0c             	pushl  0xc(%ebp)
  802022:	ff 75 08             	pushl  0x8(%ebp)
  802025:	6a 27                	push   $0x27
  802027:	e8 17 fb ff ff       	call   801b43 <syscall>
  80202c:	83 c4 18             	add    $0x18,%esp
	return ;
  80202f:	90                   	nop
}
  802030:	c9                   	leave  
  802031:	c3                   	ret    

00802032 <chktst>:
void chktst(uint32 n)
{
  802032:	55                   	push   %ebp
  802033:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802035:	6a 00                	push   $0x0
  802037:	6a 00                	push   $0x0
  802039:	6a 00                	push   $0x0
  80203b:	6a 00                	push   $0x0
  80203d:	ff 75 08             	pushl  0x8(%ebp)
  802040:	6a 29                	push   $0x29
  802042:	e8 fc fa ff ff       	call   801b43 <syscall>
  802047:	83 c4 18             	add    $0x18,%esp
	return ;
  80204a:	90                   	nop
}
  80204b:	c9                   	leave  
  80204c:	c3                   	ret    

0080204d <inctst>:

void inctst()
{
  80204d:	55                   	push   %ebp
  80204e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802050:	6a 00                	push   $0x0
  802052:	6a 00                	push   $0x0
  802054:	6a 00                	push   $0x0
  802056:	6a 00                	push   $0x0
  802058:	6a 00                	push   $0x0
  80205a:	6a 2a                	push   $0x2a
  80205c:	e8 e2 fa ff ff       	call   801b43 <syscall>
  802061:	83 c4 18             	add    $0x18,%esp
	return ;
  802064:	90                   	nop
}
  802065:	c9                   	leave  
  802066:	c3                   	ret    

00802067 <gettst>:
uint32 gettst()
{
  802067:	55                   	push   %ebp
  802068:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80206a:	6a 00                	push   $0x0
  80206c:	6a 00                	push   $0x0
  80206e:	6a 00                	push   $0x0
  802070:	6a 00                	push   $0x0
  802072:	6a 00                	push   $0x0
  802074:	6a 2b                	push   $0x2b
  802076:	e8 c8 fa ff ff       	call   801b43 <syscall>
  80207b:	83 c4 18             	add    $0x18,%esp
}
  80207e:	c9                   	leave  
  80207f:	c3                   	ret    

00802080 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802080:	55                   	push   %ebp
  802081:	89 e5                	mov    %esp,%ebp
  802083:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802086:	6a 00                	push   $0x0
  802088:	6a 00                	push   $0x0
  80208a:	6a 00                	push   $0x0
  80208c:	6a 00                	push   $0x0
  80208e:	6a 00                	push   $0x0
  802090:	6a 2c                	push   $0x2c
  802092:	e8 ac fa ff ff       	call   801b43 <syscall>
  802097:	83 c4 18             	add    $0x18,%esp
  80209a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80209d:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8020a1:	75 07                	jne    8020aa <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8020a3:	b8 01 00 00 00       	mov    $0x1,%eax
  8020a8:	eb 05                	jmp    8020af <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8020aa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020af:	c9                   	leave  
  8020b0:	c3                   	ret    

008020b1 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8020b1:	55                   	push   %ebp
  8020b2:	89 e5                	mov    %esp,%ebp
  8020b4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020b7:	6a 00                	push   $0x0
  8020b9:	6a 00                	push   $0x0
  8020bb:	6a 00                	push   $0x0
  8020bd:	6a 00                	push   $0x0
  8020bf:	6a 00                	push   $0x0
  8020c1:	6a 2c                	push   $0x2c
  8020c3:	e8 7b fa ff ff       	call   801b43 <syscall>
  8020c8:	83 c4 18             	add    $0x18,%esp
  8020cb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8020ce:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8020d2:	75 07                	jne    8020db <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8020d4:	b8 01 00 00 00       	mov    $0x1,%eax
  8020d9:	eb 05                	jmp    8020e0 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8020db:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020e0:	c9                   	leave  
  8020e1:	c3                   	ret    

008020e2 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8020e2:	55                   	push   %ebp
  8020e3:	89 e5                	mov    %esp,%ebp
  8020e5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020e8:	6a 00                	push   $0x0
  8020ea:	6a 00                	push   $0x0
  8020ec:	6a 00                	push   $0x0
  8020ee:	6a 00                	push   $0x0
  8020f0:	6a 00                	push   $0x0
  8020f2:	6a 2c                	push   $0x2c
  8020f4:	e8 4a fa ff ff       	call   801b43 <syscall>
  8020f9:	83 c4 18             	add    $0x18,%esp
  8020fc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8020ff:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802103:	75 07                	jne    80210c <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802105:	b8 01 00 00 00       	mov    $0x1,%eax
  80210a:	eb 05                	jmp    802111 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80210c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802111:	c9                   	leave  
  802112:	c3                   	ret    

00802113 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802113:	55                   	push   %ebp
  802114:	89 e5                	mov    %esp,%ebp
  802116:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802119:	6a 00                	push   $0x0
  80211b:	6a 00                	push   $0x0
  80211d:	6a 00                	push   $0x0
  80211f:	6a 00                	push   $0x0
  802121:	6a 00                	push   $0x0
  802123:	6a 2c                	push   $0x2c
  802125:	e8 19 fa ff ff       	call   801b43 <syscall>
  80212a:	83 c4 18             	add    $0x18,%esp
  80212d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802130:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802134:	75 07                	jne    80213d <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802136:	b8 01 00 00 00       	mov    $0x1,%eax
  80213b:	eb 05                	jmp    802142 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80213d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802142:	c9                   	leave  
  802143:	c3                   	ret    

00802144 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802144:	55                   	push   %ebp
  802145:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802147:	6a 00                	push   $0x0
  802149:	6a 00                	push   $0x0
  80214b:	6a 00                	push   $0x0
  80214d:	6a 00                	push   $0x0
  80214f:	ff 75 08             	pushl  0x8(%ebp)
  802152:	6a 2d                	push   $0x2d
  802154:	e8 ea f9 ff ff       	call   801b43 <syscall>
  802159:	83 c4 18             	add    $0x18,%esp
	return ;
  80215c:	90                   	nop
}
  80215d:	c9                   	leave  
  80215e:	c3                   	ret    

0080215f <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80215f:	55                   	push   %ebp
  802160:	89 e5                	mov    %esp,%ebp
  802162:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802163:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802166:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802169:	8b 55 0c             	mov    0xc(%ebp),%edx
  80216c:	8b 45 08             	mov    0x8(%ebp),%eax
  80216f:	6a 00                	push   $0x0
  802171:	53                   	push   %ebx
  802172:	51                   	push   %ecx
  802173:	52                   	push   %edx
  802174:	50                   	push   %eax
  802175:	6a 2e                	push   $0x2e
  802177:	e8 c7 f9 ff ff       	call   801b43 <syscall>
  80217c:	83 c4 18             	add    $0x18,%esp
}
  80217f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802182:	c9                   	leave  
  802183:	c3                   	ret    

00802184 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802184:	55                   	push   %ebp
  802185:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802187:	8b 55 0c             	mov    0xc(%ebp),%edx
  80218a:	8b 45 08             	mov    0x8(%ebp),%eax
  80218d:	6a 00                	push   $0x0
  80218f:	6a 00                	push   $0x0
  802191:	6a 00                	push   $0x0
  802193:	52                   	push   %edx
  802194:	50                   	push   %eax
  802195:	6a 2f                	push   $0x2f
  802197:	e8 a7 f9 ff ff       	call   801b43 <syscall>
  80219c:	83 c4 18             	add    $0x18,%esp
}
  80219f:	c9                   	leave  
  8021a0:	c3                   	ret    

008021a1 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8021a1:	55                   	push   %ebp
  8021a2:	89 e5                	mov    %esp,%ebp
  8021a4:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8021a7:	83 ec 0c             	sub    $0xc,%esp
  8021aa:	68 28 43 80 00       	push   $0x804328
  8021af:	e8 1e e8 ff ff       	call   8009d2 <cprintf>
  8021b4:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8021b7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8021be:	83 ec 0c             	sub    $0xc,%esp
  8021c1:	68 54 43 80 00       	push   $0x804354
  8021c6:	e8 07 e8 ff ff       	call   8009d2 <cprintf>
  8021cb:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8021ce:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8021d2:	a1 38 51 80 00       	mov    0x805138,%eax
  8021d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021da:	eb 56                	jmp    802232 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8021dc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021e0:	74 1c                	je     8021fe <print_mem_block_lists+0x5d>
  8021e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e5:	8b 50 08             	mov    0x8(%eax),%edx
  8021e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021eb:	8b 48 08             	mov    0x8(%eax),%ecx
  8021ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021f1:	8b 40 0c             	mov    0xc(%eax),%eax
  8021f4:	01 c8                	add    %ecx,%eax
  8021f6:	39 c2                	cmp    %eax,%edx
  8021f8:	73 04                	jae    8021fe <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8021fa:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8021fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802201:	8b 50 08             	mov    0x8(%eax),%edx
  802204:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802207:	8b 40 0c             	mov    0xc(%eax),%eax
  80220a:	01 c2                	add    %eax,%edx
  80220c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80220f:	8b 40 08             	mov    0x8(%eax),%eax
  802212:	83 ec 04             	sub    $0x4,%esp
  802215:	52                   	push   %edx
  802216:	50                   	push   %eax
  802217:	68 69 43 80 00       	push   $0x804369
  80221c:	e8 b1 e7 ff ff       	call   8009d2 <cprintf>
  802221:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802224:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802227:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80222a:	a1 40 51 80 00       	mov    0x805140,%eax
  80222f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802232:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802236:	74 07                	je     80223f <print_mem_block_lists+0x9e>
  802238:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80223b:	8b 00                	mov    (%eax),%eax
  80223d:	eb 05                	jmp    802244 <print_mem_block_lists+0xa3>
  80223f:	b8 00 00 00 00       	mov    $0x0,%eax
  802244:	a3 40 51 80 00       	mov    %eax,0x805140
  802249:	a1 40 51 80 00       	mov    0x805140,%eax
  80224e:	85 c0                	test   %eax,%eax
  802250:	75 8a                	jne    8021dc <print_mem_block_lists+0x3b>
  802252:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802256:	75 84                	jne    8021dc <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802258:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80225c:	75 10                	jne    80226e <print_mem_block_lists+0xcd>
  80225e:	83 ec 0c             	sub    $0xc,%esp
  802261:	68 78 43 80 00       	push   $0x804378
  802266:	e8 67 e7 ff ff       	call   8009d2 <cprintf>
  80226b:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80226e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802275:	83 ec 0c             	sub    $0xc,%esp
  802278:	68 9c 43 80 00       	push   $0x80439c
  80227d:	e8 50 e7 ff ff       	call   8009d2 <cprintf>
  802282:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802285:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802289:	a1 40 50 80 00       	mov    0x805040,%eax
  80228e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802291:	eb 56                	jmp    8022e9 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802293:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802297:	74 1c                	je     8022b5 <print_mem_block_lists+0x114>
  802299:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229c:	8b 50 08             	mov    0x8(%eax),%edx
  80229f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022a2:	8b 48 08             	mov    0x8(%eax),%ecx
  8022a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022a8:	8b 40 0c             	mov    0xc(%eax),%eax
  8022ab:	01 c8                	add    %ecx,%eax
  8022ad:	39 c2                	cmp    %eax,%edx
  8022af:	73 04                	jae    8022b5 <print_mem_block_lists+0x114>
			sorted = 0 ;
  8022b1:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8022b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b8:	8b 50 08             	mov    0x8(%eax),%edx
  8022bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022be:	8b 40 0c             	mov    0xc(%eax),%eax
  8022c1:	01 c2                	add    %eax,%edx
  8022c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c6:	8b 40 08             	mov    0x8(%eax),%eax
  8022c9:	83 ec 04             	sub    $0x4,%esp
  8022cc:	52                   	push   %edx
  8022cd:	50                   	push   %eax
  8022ce:	68 69 43 80 00       	push   $0x804369
  8022d3:	e8 fa e6 ff ff       	call   8009d2 <cprintf>
  8022d8:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8022db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022de:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8022e1:	a1 48 50 80 00       	mov    0x805048,%eax
  8022e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022ed:	74 07                	je     8022f6 <print_mem_block_lists+0x155>
  8022ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f2:	8b 00                	mov    (%eax),%eax
  8022f4:	eb 05                	jmp    8022fb <print_mem_block_lists+0x15a>
  8022f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8022fb:	a3 48 50 80 00       	mov    %eax,0x805048
  802300:	a1 48 50 80 00       	mov    0x805048,%eax
  802305:	85 c0                	test   %eax,%eax
  802307:	75 8a                	jne    802293 <print_mem_block_lists+0xf2>
  802309:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80230d:	75 84                	jne    802293 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80230f:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802313:	75 10                	jne    802325 <print_mem_block_lists+0x184>
  802315:	83 ec 0c             	sub    $0xc,%esp
  802318:	68 b4 43 80 00       	push   $0x8043b4
  80231d:	e8 b0 e6 ff ff       	call   8009d2 <cprintf>
  802322:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802325:	83 ec 0c             	sub    $0xc,%esp
  802328:	68 28 43 80 00       	push   $0x804328
  80232d:	e8 a0 e6 ff ff       	call   8009d2 <cprintf>
  802332:	83 c4 10             	add    $0x10,%esp

}
  802335:	90                   	nop
  802336:	c9                   	leave  
  802337:	c3                   	ret    

00802338 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802338:	55                   	push   %ebp
  802339:	89 e5                	mov    %esp,%ebp
  80233b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  80233e:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802345:	00 00 00 
  802348:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80234f:	00 00 00 
  802352:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802359:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  80235c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802363:	e9 9e 00 00 00       	jmp    802406 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802368:	a1 50 50 80 00       	mov    0x805050,%eax
  80236d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802370:	c1 e2 04             	shl    $0x4,%edx
  802373:	01 d0                	add    %edx,%eax
  802375:	85 c0                	test   %eax,%eax
  802377:	75 14                	jne    80238d <initialize_MemBlocksList+0x55>
  802379:	83 ec 04             	sub    $0x4,%esp
  80237c:	68 dc 43 80 00       	push   $0x8043dc
  802381:	6a 46                	push   $0x46
  802383:	68 ff 43 80 00       	push   $0x8043ff
  802388:	e8 91 e3 ff ff       	call   80071e <_panic>
  80238d:	a1 50 50 80 00       	mov    0x805050,%eax
  802392:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802395:	c1 e2 04             	shl    $0x4,%edx
  802398:	01 d0                	add    %edx,%eax
  80239a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8023a0:	89 10                	mov    %edx,(%eax)
  8023a2:	8b 00                	mov    (%eax),%eax
  8023a4:	85 c0                	test   %eax,%eax
  8023a6:	74 18                	je     8023c0 <initialize_MemBlocksList+0x88>
  8023a8:	a1 48 51 80 00       	mov    0x805148,%eax
  8023ad:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8023b3:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8023b6:	c1 e1 04             	shl    $0x4,%ecx
  8023b9:	01 ca                	add    %ecx,%edx
  8023bb:	89 50 04             	mov    %edx,0x4(%eax)
  8023be:	eb 12                	jmp    8023d2 <initialize_MemBlocksList+0x9a>
  8023c0:	a1 50 50 80 00       	mov    0x805050,%eax
  8023c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023c8:	c1 e2 04             	shl    $0x4,%edx
  8023cb:	01 d0                	add    %edx,%eax
  8023cd:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8023d2:	a1 50 50 80 00       	mov    0x805050,%eax
  8023d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023da:	c1 e2 04             	shl    $0x4,%edx
  8023dd:	01 d0                	add    %edx,%eax
  8023df:	a3 48 51 80 00       	mov    %eax,0x805148
  8023e4:	a1 50 50 80 00       	mov    0x805050,%eax
  8023e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023ec:	c1 e2 04             	shl    $0x4,%edx
  8023ef:	01 d0                	add    %edx,%eax
  8023f1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023f8:	a1 54 51 80 00       	mov    0x805154,%eax
  8023fd:	40                   	inc    %eax
  8023fe:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802403:	ff 45 f4             	incl   -0xc(%ebp)
  802406:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802409:	3b 45 08             	cmp    0x8(%ebp),%eax
  80240c:	0f 82 56 ff ff ff    	jb     802368 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802412:	90                   	nop
  802413:	c9                   	leave  
  802414:	c3                   	ret    

00802415 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802415:	55                   	push   %ebp
  802416:	89 e5                	mov    %esp,%ebp
  802418:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80241b:	8b 45 08             	mov    0x8(%ebp),%eax
  80241e:	8b 00                	mov    (%eax),%eax
  802420:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802423:	eb 19                	jmp    80243e <find_block+0x29>
	{
		if(va==point->sva)
  802425:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802428:	8b 40 08             	mov    0x8(%eax),%eax
  80242b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80242e:	75 05                	jne    802435 <find_block+0x20>
		   return point;
  802430:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802433:	eb 36                	jmp    80246b <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802435:	8b 45 08             	mov    0x8(%ebp),%eax
  802438:	8b 40 08             	mov    0x8(%eax),%eax
  80243b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80243e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802442:	74 07                	je     80244b <find_block+0x36>
  802444:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802447:	8b 00                	mov    (%eax),%eax
  802449:	eb 05                	jmp    802450 <find_block+0x3b>
  80244b:	b8 00 00 00 00       	mov    $0x0,%eax
  802450:	8b 55 08             	mov    0x8(%ebp),%edx
  802453:	89 42 08             	mov    %eax,0x8(%edx)
  802456:	8b 45 08             	mov    0x8(%ebp),%eax
  802459:	8b 40 08             	mov    0x8(%eax),%eax
  80245c:	85 c0                	test   %eax,%eax
  80245e:	75 c5                	jne    802425 <find_block+0x10>
  802460:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802464:	75 bf                	jne    802425 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802466:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80246b:	c9                   	leave  
  80246c:	c3                   	ret    

0080246d <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80246d:	55                   	push   %ebp
  80246e:	89 e5                	mov    %esp,%ebp
  802470:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802473:	a1 40 50 80 00       	mov    0x805040,%eax
  802478:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  80247b:	a1 44 50 80 00       	mov    0x805044,%eax
  802480:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802483:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802486:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802489:	74 24                	je     8024af <insert_sorted_allocList+0x42>
  80248b:	8b 45 08             	mov    0x8(%ebp),%eax
  80248e:	8b 50 08             	mov    0x8(%eax),%edx
  802491:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802494:	8b 40 08             	mov    0x8(%eax),%eax
  802497:	39 c2                	cmp    %eax,%edx
  802499:	76 14                	jbe    8024af <insert_sorted_allocList+0x42>
  80249b:	8b 45 08             	mov    0x8(%ebp),%eax
  80249e:	8b 50 08             	mov    0x8(%eax),%edx
  8024a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024a4:	8b 40 08             	mov    0x8(%eax),%eax
  8024a7:	39 c2                	cmp    %eax,%edx
  8024a9:	0f 82 60 01 00 00    	jb     80260f <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8024af:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024b3:	75 65                	jne    80251a <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8024b5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024b9:	75 14                	jne    8024cf <insert_sorted_allocList+0x62>
  8024bb:	83 ec 04             	sub    $0x4,%esp
  8024be:	68 dc 43 80 00       	push   $0x8043dc
  8024c3:	6a 6b                	push   $0x6b
  8024c5:	68 ff 43 80 00       	push   $0x8043ff
  8024ca:	e8 4f e2 ff ff       	call   80071e <_panic>
  8024cf:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8024d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d8:	89 10                	mov    %edx,(%eax)
  8024da:	8b 45 08             	mov    0x8(%ebp),%eax
  8024dd:	8b 00                	mov    (%eax),%eax
  8024df:	85 c0                	test   %eax,%eax
  8024e1:	74 0d                	je     8024f0 <insert_sorted_allocList+0x83>
  8024e3:	a1 40 50 80 00       	mov    0x805040,%eax
  8024e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8024eb:	89 50 04             	mov    %edx,0x4(%eax)
  8024ee:	eb 08                	jmp    8024f8 <insert_sorted_allocList+0x8b>
  8024f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f3:	a3 44 50 80 00       	mov    %eax,0x805044
  8024f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8024fb:	a3 40 50 80 00       	mov    %eax,0x805040
  802500:	8b 45 08             	mov    0x8(%ebp),%eax
  802503:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80250a:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80250f:	40                   	inc    %eax
  802510:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802515:	e9 dc 01 00 00       	jmp    8026f6 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  80251a:	8b 45 08             	mov    0x8(%ebp),%eax
  80251d:	8b 50 08             	mov    0x8(%eax),%edx
  802520:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802523:	8b 40 08             	mov    0x8(%eax),%eax
  802526:	39 c2                	cmp    %eax,%edx
  802528:	77 6c                	ja     802596 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  80252a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80252e:	74 06                	je     802536 <insert_sorted_allocList+0xc9>
  802530:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802534:	75 14                	jne    80254a <insert_sorted_allocList+0xdd>
  802536:	83 ec 04             	sub    $0x4,%esp
  802539:	68 18 44 80 00       	push   $0x804418
  80253e:	6a 6f                	push   $0x6f
  802540:	68 ff 43 80 00       	push   $0x8043ff
  802545:	e8 d4 e1 ff ff       	call   80071e <_panic>
  80254a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80254d:	8b 50 04             	mov    0x4(%eax),%edx
  802550:	8b 45 08             	mov    0x8(%ebp),%eax
  802553:	89 50 04             	mov    %edx,0x4(%eax)
  802556:	8b 45 08             	mov    0x8(%ebp),%eax
  802559:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80255c:	89 10                	mov    %edx,(%eax)
  80255e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802561:	8b 40 04             	mov    0x4(%eax),%eax
  802564:	85 c0                	test   %eax,%eax
  802566:	74 0d                	je     802575 <insert_sorted_allocList+0x108>
  802568:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80256b:	8b 40 04             	mov    0x4(%eax),%eax
  80256e:	8b 55 08             	mov    0x8(%ebp),%edx
  802571:	89 10                	mov    %edx,(%eax)
  802573:	eb 08                	jmp    80257d <insert_sorted_allocList+0x110>
  802575:	8b 45 08             	mov    0x8(%ebp),%eax
  802578:	a3 40 50 80 00       	mov    %eax,0x805040
  80257d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802580:	8b 55 08             	mov    0x8(%ebp),%edx
  802583:	89 50 04             	mov    %edx,0x4(%eax)
  802586:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80258b:	40                   	inc    %eax
  80258c:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802591:	e9 60 01 00 00       	jmp    8026f6 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802596:	8b 45 08             	mov    0x8(%ebp),%eax
  802599:	8b 50 08             	mov    0x8(%eax),%edx
  80259c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80259f:	8b 40 08             	mov    0x8(%eax),%eax
  8025a2:	39 c2                	cmp    %eax,%edx
  8025a4:	0f 82 4c 01 00 00    	jb     8026f6 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8025aa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8025ae:	75 14                	jne    8025c4 <insert_sorted_allocList+0x157>
  8025b0:	83 ec 04             	sub    $0x4,%esp
  8025b3:	68 50 44 80 00       	push   $0x804450
  8025b8:	6a 73                	push   $0x73
  8025ba:	68 ff 43 80 00       	push   $0x8043ff
  8025bf:	e8 5a e1 ff ff       	call   80071e <_panic>
  8025c4:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8025ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8025cd:	89 50 04             	mov    %edx,0x4(%eax)
  8025d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d3:	8b 40 04             	mov    0x4(%eax),%eax
  8025d6:	85 c0                	test   %eax,%eax
  8025d8:	74 0c                	je     8025e6 <insert_sorted_allocList+0x179>
  8025da:	a1 44 50 80 00       	mov    0x805044,%eax
  8025df:	8b 55 08             	mov    0x8(%ebp),%edx
  8025e2:	89 10                	mov    %edx,(%eax)
  8025e4:	eb 08                	jmp    8025ee <insert_sorted_allocList+0x181>
  8025e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e9:	a3 40 50 80 00       	mov    %eax,0x805040
  8025ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f1:	a3 44 50 80 00       	mov    %eax,0x805044
  8025f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025ff:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802604:	40                   	inc    %eax
  802605:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80260a:	e9 e7 00 00 00       	jmp    8026f6 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  80260f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802612:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802615:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80261c:	a1 40 50 80 00       	mov    0x805040,%eax
  802621:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802624:	e9 9d 00 00 00       	jmp    8026c6 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802629:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262c:	8b 00                	mov    (%eax),%eax
  80262e:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802631:	8b 45 08             	mov    0x8(%ebp),%eax
  802634:	8b 50 08             	mov    0x8(%eax),%edx
  802637:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263a:	8b 40 08             	mov    0x8(%eax),%eax
  80263d:	39 c2                	cmp    %eax,%edx
  80263f:	76 7d                	jbe    8026be <insert_sorted_allocList+0x251>
  802641:	8b 45 08             	mov    0x8(%ebp),%eax
  802644:	8b 50 08             	mov    0x8(%eax),%edx
  802647:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80264a:	8b 40 08             	mov    0x8(%eax),%eax
  80264d:	39 c2                	cmp    %eax,%edx
  80264f:	73 6d                	jae    8026be <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802651:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802655:	74 06                	je     80265d <insert_sorted_allocList+0x1f0>
  802657:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80265b:	75 14                	jne    802671 <insert_sorted_allocList+0x204>
  80265d:	83 ec 04             	sub    $0x4,%esp
  802660:	68 74 44 80 00       	push   $0x804474
  802665:	6a 7f                	push   $0x7f
  802667:	68 ff 43 80 00       	push   $0x8043ff
  80266c:	e8 ad e0 ff ff       	call   80071e <_panic>
  802671:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802674:	8b 10                	mov    (%eax),%edx
  802676:	8b 45 08             	mov    0x8(%ebp),%eax
  802679:	89 10                	mov    %edx,(%eax)
  80267b:	8b 45 08             	mov    0x8(%ebp),%eax
  80267e:	8b 00                	mov    (%eax),%eax
  802680:	85 c0                	test   %eax,%eax
  802682:	74 0b                	je     80268f <insert_sorted_allocList+0x222>
  802684:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802687:	8b 00                	mov    (%eax),%eax
  802689:	8b 55 08             	mov    0x8(%ebp),%edx
  80268c:	89 50 04             	mov    %edx,0x4(%eax)
  80268f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802692:	8b 55 08             	mov    0x8(%ebp),%edx
  802695:	89 10                	mov    %edx,(%eax)
  802697:	8b 45 08             	mov    0x8(%ebp),%eax
  80269a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80269d:	89 50 04             	mov    %edx,0x4(%eax)
  8026a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a3:	8b 00                	mov    (%eax),%eax
  8026a5:	85 c0                	test   %eax,%eax
  8026a7:	75 08                	jne    8026b1 <insert_sorted_allocList+0x244>
  8026a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ac:	a3 44 50 80 00       	mov    %eax,0x805044
  8026b1:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8026b6:	40                   	inc    %eax
  8026b7:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8026bc:	eb 39                	jmp    8026f7 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8026be:	a1 48 50 80 00       	mov    0x805048,%eax
  8026c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026ca:	74 07                	je     8026d3 <insert_sorted_allocList+0x266>
  8026cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cf:	8b 00                	mov    (%eax),%eax
  8026d1:	eb 05                	jmp    8026d8 <insert_sorted_allocList+0x26b>
  8026d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8026d8:	a3 48 50 80 00       	mov    %eax,0x805048
  8026dd:	a1 48 50 80 00       	mov    0x805048,%eax
  8026e2:	85 c0                	test   %eax,%eax
  8026e4:	0f 85 3f ff ff ff    	jne    802629 <insert_sorted_allocList+0x1bc>
  8026ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026ee:	0f 85 35 ff ff ff    	jne    802629 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8026f4:	eb 01                	jmp    8026f7 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8026f6:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8026f7:	90                   	nop
  8026f8:	c9                   	leave  
  8026f9:	c3                   	ret    

008026fa <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8026fa:	55                   	push   %ebp
  8026fb:	89 e5                	mov    %esp,%ebp
  8026fd:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802700:	a1 38 51 80 00       	mov    0x805138,%eax
  802705:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802708:	e9 85 01 00 00       	jmp    802892 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  80270d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802710:	8b 40 0c             	mov    0xc(%eax),%eax
  802713:	3b 45 08             	cmp    0x8(%ebp),%eax
  802716:	0f 82 6e 01 00 00    	jb     80288a <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  80271c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271f:	8b 40 0c             	mov    0xc(%eax),%eax
  802722:	3b 45 08             	cmp    0x8(%ebp),%eax
  802725:	0f 85 8a 00 00 00    	jne    8027b5 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  80272b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80272f:	75 17                	jne    802748 <alloc_block_FF+0x4e>
  802731:	83 ec 04             	sub    $0x4,%esp
  802734:	68 a8 44 80 00       	push   $0x8044a8
  802739:	68 93 00 00 00       	push   $0x93
  80273e:	68 ff 43 80 00       	push   $0x8043ff
  802743:	e8 d6 df ff ff       	call   80071e <_panic>
  802748:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274b:	8b 00                	mov    (%eax),%eax
  80274d:	85 c0                	test   %eax,%eax
  80274f:	74 10                	je     802761 <alloc_block_FF+0x67>
  802751:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802754:	8b 00                	mov    (%eax),%eax
  802756:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802759:	8b 52 04             	mov    0x4(%edx),%edx
  80275c:	89 50 04             	mov    %edx,0x4(%eax)
  80275f:	eb 0b                	jmp    80276c <alloc_block_FF+0x72>
  802761:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802764:	8b 40 04             	mov    0x4(%eax),%eax
  802767:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80276c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276f:	8b 40 04             	mov    0x4(%eax),%eax
  802772:	85 c0                	test   %eax,%eax
  802774:	74 0f                	je     802785 <alloc_block_FF+0x8b>
  802776:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802779:	8b 40 04             	mov    0x4(%eax),%eax
  80277c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80277f:	8b 12                	mov    (%edx),%edx
  802781:	89 10                	mov    %edx,(%eax)
  802783:	eb 0a                	jmp    80278f <alloc_block_FF+0x95>
  802785:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802788:	8b 00                	mov    (%eax),%eax
  80278a:	a3 38 51 80 00       	mov    %eax,0x805138
  80278f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802792:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802798:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027a2:	a1 44 51 80 00       	mov    0x805144,%eax
  8027a7:	48                   	dec    %eax
  8027a8:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  8027ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b0:	e9 10 01 00 00       	jmp    8028c5 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8027b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b8:	8b 40 0c             	mov    0xc(%eax),%eax
  8027bb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027be:	0f 86 c6 00 00 00    	jbe    80288a <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8027c4:	a1 48 51 80 00       	mov    0x805148,%eax
  8027c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8027cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cf:	8b 50 08             	mov    0x8(%eax),%edx
  8027d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027d5:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8027d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027db:	8b 55 08             	mov    0x8(%ebp),%edx
  8027de:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8027e1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027e5:	75 17                	jne    8027fe <alloc_block_FF+0x104>
  8027e7:	83 ec 04             	sub    $0x4,%esp
  8027ea:	68 a8 44 80 00       	push   $0x8044a8
  8027ef:	68 9b 00 00 00       	push   $0x9b
  8027f4:	68 ff 43 80 00       	push   $0x8043ff
  8027f9:	e8 20 df ff ff       	call   80071e <_panic>
  8027fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802801:	8b 00                	mov    (%eax),%eax
  802803:	85 c0                	test   %eax,%eax
  802805:	74 10                	je     802817 <alloc_block_FF+0x11d>
  802807:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80280a:	8b 00                	mov    (%eax),%eax
  80280c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80280f:	8b 52 04             	mov    0x4(%edx),%edx
  802812:	89 50 04             	mov    %edx,0x4(%eax)
  802815:	eb 0b                	jmp    802822 <alloc_block_FF+0x128>
  802817:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80281a:	8b 40 04             	mov    0x4(%eax),%eax
  80281d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802822:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802825:	8b 40 04             	mov    0x4(%eax),%eax
  802828:	85 c0                	test   %eax,%eax
  80282a:	74 0f                	je     80283b <alloc_block_FF+0x141>
  80282c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80282f:	8b 40 04             	mov    0x4(%eax),%eax
  802832:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802835:	8b 12                	mov    (%edx),%edx
  802837:	89 10                	mov    %edx,(%eax)
  802839:	eb 0a                	jmp    802845 <alloc_block_FF+0x14b>
  80283b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80283e:	8b 00                	mov    (%eax),%eax
  802840:	a3 48 51 80 00       	mov    %eax,0x805148
  802845:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802848:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80284e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802851:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802858:	a1 54 51 80 00       	mov    0x805154,%eax
  80285d:	48                   	dec    %eax
  80285e:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802863:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802866:	8b 50 08             	mov    0x8(%eax),%edx
  802869:	8b 45 08             	mov    0x8(%ebp),%eax
  80286c:	01 c2                	add    %eax,%edx
  80286e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802871:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802874:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802877:	8b 40 0c             	mov    0xc(%eax),%eax
  80287a:	2b 45 08             	sub    0x8(%ebp),%eax
  80287d:	89 c2                	mov    %eax,%edx
  80287f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802882:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802885:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802888:	eb 3b                	jmp    8028c5 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80288a:	a1 40 51 80 00       	mov    0x805140,%eax
  80288f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802892:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802896:	74 07                	je     80289f <alloc_block_FF+0x1a5>
  802898:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289b:	8b 00                	mov    (%eax),%eax
  80289d:	eb 05                	jmp    8028a4 <alloc_block_FF+0x1aa>
  80289f:	b8 00 00 00 00       	mov    $0x0,%eax
  8028a4:	a3 40 51 80 00       	mov    %eax,0x805140
  8028a9:	a1 40 51 80 00       	mov    0x805140,%eax
  8028ae:	85 c0                	test   %eax,%eax
  8028b0:	0f 85 57 fe ff ff    	jne    80270d <alloc_block_FF+0x13>
  8028b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028ba:	0f 85 4d fe ff ff    	jne    80270d <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8028c0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028c5:	c9                   	leave  
  8028c6:	c3                   	ret    

008028c7 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8028c7:	55                   	push   %ebp
  8028c8:	89 e5                	mov    %esp,%ebp
  8028ca:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8028cd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8028d4:	a1 38 51 80 00       	mov    0x805138,%eax
  8028d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028dc:	e9 df 00 00 00       	jmp    8029c0 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8028e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e4:	8b 40 0c             	mov    0xc(%eax),%eax
  8028e7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028ea:	0f 82 c8 00 00 00    	jb     8029b8 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8028f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f3:	8b 40 0c             	mov    0xc(%eax),%eax
  8028f6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028f9:	0f 85 8a 00 00 00    	jne    802989 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8028ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802903:	75 17                	jne    80291c <alloc_block_BF+0x55>
  802905:	83 ec 04             	sub    $0x4,%esp
  802908:	68 a8 44 80 00       	push   $0x8044a8
  80290d:	68 b7 00 00 00       	push   $0xb7
  802912:	68 ff 43 80 00       	push   $0x8043ff
  802917:	e8 02 de ff ff       	call   80071e <_panic>
  80291c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291f:	8b 00                	mov    (%eax),%eax
  802921:	85 c0                	test   %eax,%eax
  802923:	74 10                	je     802935 <alloc_block_BF+0x6e>
  802925:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802928:	8b 00                	mov    (%eax),%eax
  80292a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80292d:	8b 52 04             	mov    0x4(%edx),%edx
  802930:	89 50 04             	mov    %edx,0x4(%eax)
  802933:	eb 0b                	jmp    802940 <alloc_block_BF+0x79>
  802935:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802938:	8b 40 04             	mov    0x4(%eax),%eax
  80293b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802940:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802943:	8b 40 04             	mov    0x4(%eax),%eax
  802946:	85 c0                	test   %eax,%eax
  802948:	74 0f                	je     802959 <alloc_block_BF+0x92>
  80294a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294d:	8b 40 04             	mov    0x4(%eax),%eax
  802950:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802953:	8b 12                	mov    (%edx),%edx
  802955:	89 10                	mov    %edx,(%eax)
  802957:	eb 0a                	jmp    802963 <alloc_block_BF+0x9c>
  802959:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295c:	8b 00                	mov    (%eax),%eax
  80295e:	a3 38 51 80 00       	mov    %eax,0x805138
  802963:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802966:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80296c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802976:	a1 44 51 80 00       	mov    0x805144,%eax
  80297b:	48                   	dec    %eax
  80297c:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802981:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802984:	e9 4d 01 00 00       	jmp    802ad6 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802989:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298c:	8b 40 0c             	mov    0xc(%eax),%eax
  80298f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802992:	76 24                	jbe    8029b8 <alloc_block_BF+0xf1>
  802994:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802997:	8b 40 0c             	mov    0xc(%eax),%eax
  80299a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80299d:	73 19                	jae    8029b8 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  80299f:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8029a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8029ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8029af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b2:	8b 40 08             	mov    0x8(%eax),%eax
  8029b5:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8029b8:	a1 40 51 80 00       	mov    0x805140,%eax
  8029bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029c4:	74 07                	je     8029cd <alloc_block_BF+0x106>
  8029c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c9:	8b 00                	mov    (%eax),%eax
  8029cb:	eb 05                	jmp    8029d2 <alloc_block_BF+0x10b>
  8029cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8029d2:	a3 40 51 80 00       	mov    %eax,0x805140
  8029d7:	a1 40 51 80 00       	mov    0x805140,%eax
  8029dc:	85 c0                	test   %eax,%eax
  8029de:	0f 85 fd fe ff ff    	jne    8028e1 <alloc_block_BF+0x1a>
  8029e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029e8:	0f 85 f3 fe ff ff    	jne    8028e1 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  8029ee:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8029f2:	0f 84 d9 00 00 00    	je     802ad1 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8029f8:	a1 48 51 80 00       	mov    0x805148,%eax
  8029fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802a00:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a03:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a06:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802a09:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a0c:	8b 55 08             	mov    0x8(%ebp),%edx
  802a0f:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802a12:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802a16:	75 17                	jne    802a2f <alloc_block_BF+0x168>
  802a18:	83 ec 04             	sub    $0x4,%esp
  802a1b:	68 a8 44 80 00       	push   $0x8044a8
  802a20:	68 c7 00 00 00       	push   $0xc7
  802a25:	68 ff 43 80 00       	push   $0x8043ff
  802a2a:	e8 ef dc ff ff       	call   80071e <_panic>
  802a2f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a32:	8b 00                	mov    (%eax),%eax
  802a34:	85 c0                	test   %eax,%eax
  802a36:	74 10                	je     802a48 <alloc_block_BF+0x181>
  802a38:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a3b:	8b 00                	mov    (%eax),%eax
  802a3d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802a40:	8b 52 04             	mov    0x4(%edx),%edx
  802a43:	89 50 04             	mov    %edx,0x4(%eax)
  802a46:	eb 0b                	jmp    802a53 <alloc_block_BF+0x18c>
  802a48:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a4b:	8b 40 04             	mov    0x4(%eax),%eax
  802a4e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a53:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a56:	8b 40 04             	mov    0x4(%eax),%eax
  802a59:	85 c0                	test   %eax,%eax
  802a5b:	74 0f                	je     802a6c <alloc_block_BF+0x1a5>
  802a5d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a60:	8b 40 04             	mov    0x4(%eax),%eax
  802a63:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802a66:	8b 12                	mov    (%edx),%edx
  802a68:	89 10                	mov    %edx,(%eax)
  802a6a:	eb 0a                	jmp    802a76 <alloc_block_BF+0x1af>
  802a6c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a6f:	8b 00                	mov    (%eax),%eax
  802a71:	a3 48 51 80 00       	mov    %eax,0x805148
  802a76:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a79:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a7f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a82:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a89:	a1 54 51 80 00       	mov    0x805154,%eax
  802a8e:	48                   	dec    %eax
  802a8f:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802a94:	83 ec 08             	sub    $0x8,%esp
  802a97:	ff 75 ec             	pushl  -0x14(%ebp)
  802a9a:	68 38 51 80 00       	push   $0x805138
  802a9f:	e8 71 f9 ff ff       	call   802415 <find_block>
  802aa4:	83 c4 10             	add    $0x10,%esp
  802aa7:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802aaa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802aad:	8b 50 08             	mov    0x8(%eax),%edx
  802ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab3:	01 c2                	add    %eax,%edx
  802ab5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ab8:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802abb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802abe:	8b 40 0c             	mov    0xc(%eax),%eax
  802ac1:	2b 45 08             	sub    0x8(%ebp),%eax
  802ac4:	89 c2                	mov    %eax,%edx
  802ac6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ac9:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802acc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802acf:	eb 05                	jmp    802ad6 <alloc_block_BF+0x20f>
	}
	return NULL;
  802ad1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ad6:	c9                   	leave  
  802ad7:	c3                   	ret    

00802ad8 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802ad8:	55                   	push   %ebp
  802ad9:	89 e5                	mov    %esp,%ebp
  802adb:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802ade:	a1 28 50 80 00       	mov    0x805028,%eax
  802ae3:	85 c0                	test   %eax,%eax
  802ae5:	0f 85 de 01 00 00    	jne    802cc9 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802aeb:	a1 38 51 80 00       	mov    0x805138,%eax
  802af0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802af3:	e9 9e 01 00 00       	jmp    802c96 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802af8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afb:	8b 40 0c             	mov    0xc(%eax),%eax
  802afe:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b01:	0f 82 87 01 00 00    	jb     802c8e <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802b07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0a:	8b 40 0c             	mov    0xc(%eax),%eax
  802b0d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b10:	0f 85 95 00 00 00    	jne    802bab <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802b16:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b1a:	75 17                	jne    802b33 <alloc_block_NF+0x5b>
  802b1c:	83 ec 04             	sub    $0x4,%esp
  802b1f:	68 a8 44 80 00       	push   $0x8044a8
  802b24:	68 e0 00 00 00       	push   $0xe0
  802b29:	68 ff 43 80 00       	push   $0x8043ff
  802b2e:	e8 eb db ff ff       	call   80071e <_panic>
  802b33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b36:	8b 00                	mov    (%eax),%eax
  802b38:	85 c0                	test   %eax,%eax
  802b3a:	74 10                	je     802b4c <alloc_block_NF+0x74>
  802b3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3f:	8b 00                	mov    (%eax),%eax
  802b41:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b44:	8b 52 04             	mov    0x4(%edx),%edx
  802b47:	89 50 04             	mov    %edx,0x4(%eax)
  802b4a:	eb 0b                	jmp    802b57 <alloc_block_NF+0x7f>
  802b4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4f:	8b 40 04             	mov    0x4(%eax),%eax
  802b52:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5a:	8b 40 04             	mov    0x4(%eax),%eax
  802b5d:	85 c0                	test   %eax,%eax
  802b5f:	74 0f                	je     802b70 <alloc_block_NF+0x98>
  802b61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b64:	8b 40 04             	mov    0x4(%eax),%eax
  802b67:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b6a:	8b 12                	mov    (%edx),%edx
  802b6c:	89 10                	mov    %edx,(%eax)
  802b6e:	eb 0a                	jmp    802b7a <alloc_block_NF+0xa2>
  802b70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b73:	8b 00                	mov    (%eax),%eax
  802b75:	a3 38 51 80 00       	mov    %eax,0x805138
  802b7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b86:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b8d:	a1 44 51 80 00       	mov    0x805144,%eax
  802b92:	48                   	dec    %eax
  802b93:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802b98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9b:	8b 40 08             	mov    0x8(%eax),%eax
  802b9e:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802ba3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba6:	e9 f8 04 00 00       	jmp    8030a3 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802bab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bae:	8b 40 0c             	mov    0xc(%eax),%eax
  802bb1:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bb4:	0f 86 d4 00 00 00    	jbe    802c8e <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802bba:	a1 48 51 80 00       	mov    0x805148,%eax
  802bbf:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802bc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc5:	8b 50 08             	mov    0x8(%eax),%edx
  802bc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bcb:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802bce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bd1:	8b 55 08             	mov    0x8(%ebp),%edx
  802bd4:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802bd7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bdb:	75 17                	jne    802bf4 <alloc_block_NF+0x11c>
  802bdd:	83 ec 04             	sub    $0x4,%esp
  802be0:	68 a8 44 80 00       	push   $0x8044a8
  802be5:	68 e9 00 00 00       	push   $0xe9
  802bea:	68 ff 43 80 00       	push   $0x8043ff
  802bef:	e8 2a db ff ff       	call   80071e <_panic>
  802bf4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bf7:	8b 00                	mov    (%eax),%eax
  802bf9:	85 c0                	test   %eax,%eax
  802bfb:	74 10                	je     802c0d <alloc_block_NF+0x135>
  802bfd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c00:	8b 00                	mov    (%eax),%eax
  802c02:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c05:	8b 52 04             	mov    0x4(%edx),%edx
  802c08:	89 50 04             	mov    %edx,0x4(%eax)
  802c0b:	eb 0b                	jmp    802c18 <alloc_block_NF+0x140>
  802c0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c10:	8b 40 04             	mov    0x4(%eax),%eax
  802c13:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c1b:	8b 40 04             	mov    0x4(%eax),%eax
  802c1e:	85 c0                	test   %eax,%eax
  802c20:	74 0f                	je     802c31 <alloc_block_NF+0x159>
  802c22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c25:	8b 40 04             	mov    0x4(%eax),%eax
  802c28:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c2b:	8b 12                	mov    (%edx),%edx
  802c2d:	89 10                	mov    %edx,(%eax)
  802c2f:	eb 0a                	jmp    802c3b <alloc_block_NF+0x163>
  802c31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c34:	8b 00                	mov    (%eax),%eax
  802c36:	a3 48 51 80 00       	mov    %eax,0x805148
  802c3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c3e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c47:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c4e:	a1 54 51 80 00       	mov    0x805154,%eax
  802c53:	48                   	dec    %eax
  802c54:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802c59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c5c:	8b 40 08             	mov    0x8(%eax),%eax
  802c5f:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802c64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c67:	8b 50 08             	mov    0x8(%eax),%edx
  802c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6d:	01 c2                	add    %eax,%edx
  802c6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c72:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802c75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c78:	8b 40 0c             	mov    0xc(%eax),%eax
  802c7b:	2b 45 08             	sub    0x8(%ebp),%eax
  802c7e:	89 c2                	mov    %eax,%edx
  802c80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c83:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802c86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c89:	e9 15 04 00 00       	jmp    8030a3 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802c8e:	a1 40 51 80 00       	mov    0x805140,%eax
  802c93:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c96:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c9a:	74 07                	je     802ca3 <alloc_block_NF+0x1cb>
  802c9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9f:	8b 00                	mov    (%eax),%eax
  802ca1:	eb 05                	jmp    802ca8 <alloc_block_NF+0x1d0>
  802ca3:	b8 00 00 00 00       	mov    $0x0,%eax
  802ca8:	a3 40 51 80 00       	mov    %eax,0x805140
  802cad:	a1 40 51 80 00       	mov    0x805140,%eax
  802cb2:	85 c0                	test   %eax,%eax
  802cb4:	0f 85 3e fe ff ff    	jne    802af8 <alloc_block_NF+0x20>
  802cba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cbe:	0f 85 34 fe ff ff    	jne    802af8 <alloc_block_NF+0x20>
  802cc4:	e9 d5 03 00 00       	jmp    80309e <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802cc9:	a1 38 51 80 00       	mov    0x805138,%eax
  802cce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cd1:	e9 b1 01 00 00       	jmp    802e87 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802cd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd9:	8b 50 08             	mov    0x8(%eax),%edx
  802cdc:	a1 28 50 80 00       	mov    0x805028,%eax
  802ce1:	39 c2                	cmp    %eax,%edx
  802ce3:	0f 82 96 01 00 00    	jb     802e7f <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802ce9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cec:	8b 40 0c             	mov    0xc(%eax),%eax
  802cef:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cf2:	0f 82 87 01 00 00    	jb     802e7f <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802cf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfb:	8b 40 0c             	mov    0xc(%eax),%eax
  802cfe:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d01:	0f 85 95 00 00 00    	jne    802d9c <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802d07:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d0b:	75 17                	jne    802d24 <alloc_block_NF+0x24c>
  802d0d:	83 ec 04             	sub    $0x4,%esp
  802d10:	68 a8 44 80 00       	push   $0x8044a8
  802d15:	68 fc 00 00 00       	push   $0xfc
  802d1a:	68 ff 43 80 00       	push   $0x8043ff
  802d1f:	e8 fa d9 ff ff       	call   80071e <_panic>
  802d24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d27:	8b 00                	mov    (%eax),%eax
  802d29:	85 c0                	test   %eax,%eax
  802d2b:	74 10                	je     802d3d <alloc_block_NF+0x265>
  802d2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d30:	8b 00                	mov    (%eax),%eax
  802d32:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d35:	8b 52 04             	mov    0x4(%edx),%edx
  802d38:	89 50 04             	mov    %edx,0x4(%eax)
  802d3b:	eb 0b                	jmp    802d48 <alloc_block_NF+0x270>
  802d3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d40:	8b 40 04             	mov    0x4(%eax),%eax
  802d43:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4b:	8b 40 04             	mov    0x4(%eax),%eax
  802d4e:	85 c0                	test   %eax,%eax
  802d50:	74 0f                	je     802d61 <alloc_block_NF+0x289>
  802d52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d55:	8b 40 04             	mov    0x4(%eax),%eax
  802d58:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d5b:	8b 12                	mov    (%edx),%edx
  802d5d:	89 10                	mov    %edx,(%eax)
  802d5f:	eb 0a                	jmp    802d6b <alloc_block_NF+0x293>
  802d61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d64:	8b 00                	mov    (%eax),%eax
  802d66:	a3 38 51 80 00       	mov    %eax,0x805138
  802d6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d77:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d7e:	a1 44 51 80 00       	mov    0x805144,%eax
  802d83:	48                   	dec    %eax
  802d84:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802d89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8c:	8b 40 08             	mov    0x8(%eax),%eax
  802d8f:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802d94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d97:	e9 07 03 00 00       	jmp    8030a3 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802d9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9f:	8b 40 0c             	mov    0xc(%eax),%eax
  802da2:	3b 45 08             	cmp    0x8(%ebp),%eax
  802da5:	0f 86 d4 00 00 00    	jbe    802e7f <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802dab:	a1 48 51 80 00       	mov    0x805148,%eax
  802db0:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802db3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db6:	8b 50 08             	mov    0x8(%eax),%edx
  802db9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dbc:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802dbf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dc2:	8b 55 08             	mov    0x8(%ebp),%edx
  802dc5:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802dc8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802dcc:	75 17                	jne    802de5 <alloc_block_NF+0x30d>
  802dce:	83 ec 04             	sub    $0x4,%esp
  802dd1:	68 a8 44 80 00       	push   $0x8044a8
  802dd6:	68 04 01 00 00       	push   $0x104
  802ddb:	68 ff 43 80 00       	push   $0x8043ff
  802de0:	e8 39 d9 ff ff       	call   80071e <_panic>
  802de5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802de8:	8b 00                	mov    (%eax),%eax
  802dea:	85 c0                	test   %eax,%eax
  802dec:	74 10                	je     802dfe <alloc_block_NF+0x326>
  802dee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802df1:	8b 00                	mov    (%eax),%eax
  802df3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802df6:	8b 52 04             	mov    0x4(%edx),%edx
  802df9:	89 50 04             	mov    %edx,0x4(%eax)
  802dfc:	eb 0b                	jmp    802e09 <alloc_block_NF+0x331>
  802dfe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e01:	8b 40 04             	mov    0x4(%eax),%eax
  802e04:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e09:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e0c:	8b 40 04             	mov    0x4(%eax),%eax
  802e0f:	85 c0                	test   %eax,%eax
  802e11:	74 0f                	je     802e22 <alloc_block_NF+0x34a>
  802e13:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e16:	8b 40 04             	mov    0x4(%eax),%eax
  802e19:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e1c:	8b 12                	mov    (%edx),%edx
  802e1e:	89 10                	mov    %edx,(%eax)
  802e20:	eb 0a                	jmp    802e2c <alloc_block_NF+0x354>
  802e22:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e25:	8b 00                	mov    (%eax),%eax
  802e27:	a3 48 51 80 00       	mov    %eax,0x805148
  802e2c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e2f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e35:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e38:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e3f:	a1 54 51 80 00       	mov    0x805154,%eax
  802e44:	48                   	dec    %eax
  802e45:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802e4a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e4d:	8b 40 08             	mov    0x8(%eax),%eax
  802e50:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802e55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e58:	8b 50 08             	mov    0x8(%eax),%edx
  802e5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5e:	01 c2                	add    %eax,%edx
  802e60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e63:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802e66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e69:	8b 40 0c             	mov    0xc(%eax),%eax
  802e6c:	2b 45 08             	sub    0x8(%ebp),%eax
  802e6f:	89 c2                	mov    %eax,%edx
  802e71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e74:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802e77:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e7a:	e9 24 02 00 00       	jmp    8030a3 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802e7f:	a1 40 51 80 00       	mov    0x805140,%eax
  802e84:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e87:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e8b:	74 07                	je     802e94 <alloc_block_NF+0x3bc>
  802e8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e90:	8b 00                	mov    (%eax),%eax
  802e92:	eb 05                	jmp    802e99 <alloc_block_NF+0x3c1>
  802e94:	b8 00 00 00 00       	mov    $0x0,%eax
  802e99:	a3 40 51 80 00       	mov    %eax,0x805140
  802e9e:	a1 40 51 80 00       	mov    0x805140,%eax
  802ea3:	85 c0                	test   %eax,%eax
  802ea5:	0f 85 2b fe ff ff    	jne    802cd6 <alloc_block_NF+0x1fe>
  802eab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802eaf:	0f 85 21 fe ff ff    	jne    802cd6 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802eb5:	a1 38 51 80 00       	mov    0x805138,%eax
  802eba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ebd:	e9 ae 01 00 00       	jmp    803070 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802ec2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec5:	8b 50 08             	mov    0x8(%eax),%edx
  802ec8:	a1 28 50 80 00       	mov    0x805028,%eax
  802ecd:	39 c2                	cmp    %eax,%edx
  802ecf:	0f 83 93 01 00 00    	jae    803068 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802ed5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed8:	8b 40 0c             	mov    0xc(%eax),%eax
  802edb:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ede:	0f 82 84 01 00 00    	jb     803068 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802ee4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee7:	8b 40 0c             	mov    0xc(%eax),%eax
  802eea:	3b 45 08             	cmp    0x8(%ebp),%eax
  802eed:	0f 85 95 00 00 00    	jne    802f88 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802ef3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ef7:	75 17                	jne    802f10 <alloc_block_NF+0x438>
  802ef9:	83 ec 04             	sub    $0x4,%esp
  802efc:	68 a8 44 80 00       	push   $0x8044a8
  802f01:	68 14 01 00 00       	push   $0x114
  802f06:	68 ff 43 80 00       	push   $0x8043ff
  802f0b:	e8 0e d8 ff ff       	call   80071e <_panic>
  802f10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f13:	8b 00                	mov    (%eax),%eax
  802f15:	85 c0                	test   %eax,%eax
  802f17:	74 10                	je     802f29 <alloc_block_NF+0x451>
  802f19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1c:	8b 00                	mov    (%eax),%eax
  802f1e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f21:	8b 52 04             	mov    0x4(%edx),%edx
  802f24:	89 50 04             	mov    %edx,0x4(%eax)
  802f27:	eb 0b                	jmp    802f34 <alloc_block_NF+0x45c>
  802f29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2c:	8b 40 04             	mov    0x4(%eax),%eax
  802f2f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f37:	8b 40 04             	mov    0x4(%eax),%eax
  802f3a:	85 c0                	test   %eax,%eax
  802f3c:	74 0f                	je     802f4d <alloc_block_NF+0x475>
  802f3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f41:	8b 40 04             	mov    0x4(%eax),%eax
  802f44:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f47:	8b 12                	mov    (%edx),%edx
  802f49:	89 10                	mov    %edx,(%eax)
  802f4b:	eb 0a                	jmp    802f57 <alloc_block_NF+0x47f>
  802f4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f50:	8b 00                	mov    (%eax),%eax
  802f52:	a3 38 51 80 00       	mov    %eax,0x805138
  802f57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f63:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f6a:	a1 44 51 80 00       	mov    0x805144,%eax
  802f6f:	48                   	dec    %eax
  802f70:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802f75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f78:	8b 40 08             	mov    0x8(%eax),%eax
  802f7b:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802f80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f83:	e9 1b 01 00 00       	jmp    8030a3 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802f88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8b:	8b 40 0c             	mov    0xc(%eax),%eax
  802f8e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f91:	0f 86 d1 00 00 00    	jbe    803068 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802f97:	a1 48 51 80 00       	mov    0x805148,%eax
  802f9c:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802f9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa2:	8b 50 08             	mov    0x8(%eax),%edx
  802fa5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fa8:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802fab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fae:	8b 55 08             	mov    0x8(%ebp),%edx
  802fb1:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802fb4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802fb8:	75 17                	jne    802fd1 <alloc_block_NF+0x4f9>
  802fba:	83 ec 04             	sub    $0x4,%esp
  802fbd:	68 a8 44 80 00       	push   $0x8044a8
  802fc2:	68 1c 01 00 00       	push   $0x11c
  802fc7:	68 ff 43 80 00       	push   $0x8043ff
  802fcc:	e8 4d d7 ff ff       	call   80071e <_panic>
  802fd1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fd4:	8b 00                	mov    (%eax),%eax
  802fd6:	85 c0                	test   %eax,%eax
  802fd8:	74 10                	je     802fea <alloc_block_NF+0x512>
  802fda:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fdd:	8b 00                	mov    (%eax),%eax
  802fdf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802fe2:	8b 52 04             	mov    0x4(%edx),%edx
  802fe5:	89 50 04             	mov    %edx,0x4(%eax)
  802fe8:	eb 0b                	jmp    802ff5 <alloc_block_NF+0x51d>
  802fea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fed:	8b 40 04             	mov    0x4(%eax),%eax
  802ff0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ff5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ff8:	8b 40 04             	mov    0x4(%eax),%eax
  802ffb:	85 c0                	test   %eax,%eax
  802ffd:	74 0f                	je     80300e <alloc_block_NF+0x536>
  802fff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803002:	8b 40 04             	mov    0x4(%eax),%eax
  803005:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803008:	8b 12                	mov    (%edx),%edx
  80300a:	89 10                	mov    %edx,(%eax)
  80300c:	eb 0a                	jmp    803018 <alloc_block_NF+0x540>
  80300e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803011:	8b 00                	mov    (%eax),%eax
  803013:	a3 48 51 80 00       	mov    %eax,0x805148
  803018:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80301b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803021:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803024:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80302b:	a1 54 51 80 00       	mov    0x805154,%eax
  803030:	48                   	dec    %eax
  803031:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  803036:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803039:	8b 40 08             	mov    0x8(%eax),%eax
  80303c:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  803041:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803044:	8b 50 08             	mov    0x8(%eax),%edx
  803047:	8b 45 08             	mov    0x8(%ebp),%eax
  80304a:	01 c2                	add    %eax,%edx
  80304c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80304f:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803052:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803055:	8b 40 0c             	mov    0xc(%eax),%eax
  803058:	2b 45 08             	sub    0x8(%ebp),%eax
  80305b:	89 c2                	mov    %eax,%edx
  80305d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803060:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803063:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803066:	eb 3b                	jmp    8030a3 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803068:	a1 40 51 80 00       	mov    0x805140,%eax
  80306d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803070:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803074:	74 07                	je     80307d <alloc_block_NF+0x5a5>
  803076:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803079:	8b 00                	mov    (%eax),%eax
  80307b:	eb 05                	jmp    803082 <alloc_block_NF+0x5aa>
  80307d:	b8 00 00 00 00       	mov    $0x0,%eax
  803082:	a3 40 51 80 00       	mov    %eax,0x805140
  803087:	a1 40 51 80 00       	mov    0x805140,%eax
  80308c:	85 c0                	test   %eax,%eax
  80308e:	0f 85 2e fe ff ff    	jne    802ec2 <alloc_block_NF+0x3ea>
  803094:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803098:	0f 85 24 fe ff ff    	jne    802ec2 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  80309e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8030a3:	c9                   	leave  
  8030a4:	c3                   	ret    

008030a5 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8030a5:	55                   	push   %ebp
  8030a6:	89 e5                	mov    %esp,%ebp
  8030a8:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  8030ab:	a1 38 51 80 00       	mov    0x805138,%eax
  8030b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  8030b3:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8030b8:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  8030bb:	a1 38 51 80 00       	mov    0x805138,%eax
  8030c0:	85 c0                	test   %eax,%eax
  8030c2:	74 14                	je     8030d8 <insert_sorted_with_merge_freeList+0x33>
  8030c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c7:	8b 50 08             	mov    0x8(%eax),%edx
  8030ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030cd:	8b 40 08             	mov    0x8(%eax),%eax
  8030d0:	39 c2                	cmp    %eax,%edx
  8030d2:	0f 87 9b 01 00 00    	ja     803273 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  8030d8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030dc:	75 17                	jne    8030f5 <insert_sorted_with_merge_freeList+0x50>
  8030de:	83 ec 04             	sub    $0x4,%esp
  8030e1:	68 dc 43 80 00       	push   $0x8043dc
  8030e6:	68 38 01 00 00       	push   $0x138
  8030eb:	68 ff 43 80 00       	push   $0x8043ff
  8030f0:	e8 29 d6 ff ff       	call   80071e <_panic>
  8030f5:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8030fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8030fe:	89 10                	mov    %edx,(%eax)
  803100:	8b 45 08             	mov    0x8(%ebp),%eax
  803103:	8b 00                	mov    (%eax),%eax
  803105:	85 c0                	test   %eax,%eax
  803107:	74 0d                	je     803116 <insert_sorted_with_merge_freeList+0x71>
  803109:	a1 38 51 80 00       	mov    0x805138,%eax
  80310e:	8b 55 08             	mov    0x8(%ebp),%edx
  803111:	89 50 04             	mov    %edx,0x4(%eax)
  803114:	eb 08                	jmp    80311e <insert_sorted_with_merge_freeList+0x79>
  803116:	8b 45 08             	mov    0x8(%ebp),%eax
  803119:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80311e:	8b 45 08             	mov    0x8(%ebp),%eax
  803121:	a3 38 51 80 00       	mov    %eax,0x805138
  803126:	8b 45 08             	mov    0x8(%ebp),%eax
  803129:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803130:	a1 44 51 80 00       	mov    0x805144,%eax
  803135:	40                   	inc    %eax
  803136:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80313b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80313f:	0f 84 a8 06 00 00    	je     8037ed <insert_sorted_with_merge_freeList+0x748>
  803145:	8b 45 08             	mov    0x8(%ebp),%eax
  803148:	8b 50 08             	mov    0x8(%eax),%edx
  80314b:	8b 45 08             	mov    0x8(%ebp),%eax
  80314e:	8b 40 0c             	mov    0xc(%eax),%eax
  803151:	01 c2                	add    %eax,%edx
  803153:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803156:	8b 40 08             	mov    0x8(%eax),%eax
  803159:	39 c2                	cmp    %eax,%edx
  80315b:	0f 85 8c 06 00 00    	jne    8037ed <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  803161:	8b 45 08             	mov    0x8(%ebp),%eax
  803164:	8b 50 0c             	mov    0xc(%eax),%edx
  803167:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80316a:	8b 40 0c             	mov    0xc(%eax),%eax
  80316d:	01 c2                	add    %eax,%edx
  80316f:	8b 45 08             	mov    0x8(%ebp),%eax
  803172:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  803175:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803179:	75 17                	jne    803192 <insert_sorted_with_merge_freeList+0xed>
  80317b:	83 ec 04             	sub    $0x4,%esp
  80317e:	68 a8 44 80 00       	push   $0x8044a8
  803183:	68 3c 01 00 00       	push   $0x13c
  803188:	68 ff 43 80 00       	push   $0x8043ff
  80318d:	e8 8c d5 ff ff       	call   80071e <_panic>
  803192:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803195:	8b 00                	mov    (%eax),%eax
  803197:	85 c0                	test   %eax,%eax
  803199:	74 10                	je     8031ab <insert_sorted_with_merge_freeList+0x106>
  80319b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80319e:	8b 00                	mov    (%eax),%eax
  8031a0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031a3:	8b 52 04             	mov    0x4(%edx),%edx
  8031a6:	89 50 04             	mov    %edx,0x4(%eax)
  8031a9:	eb 0b                	jmp    8031b6 <insert_sorted_with_merge_freeList+0x111>
  8031ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031ae:	8b 40 04             	mov    0x4(%eax),%eax
  8031b1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031b9:	8b 40 04             	mov    0x4(%eax),%eax
  8031bc:	85 c0                	test   %eax,%eax
  8031be:	74 0f                	je     8031cf <insert_sorted_with_merge_freeList+0x12a>
  8031c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031c3:	8b 40 04             	mov    0x4(%eax),%eax
  8031c6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031c9:	8b 12                	mov    (%edx),%edx
  8031cb:	89 10                	mov    %edx,(%eax)
  8031cd:	eb 0a                	jmp    8031d9 <insert_sorted_with_merge_freeList+0x134>
  8031cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031d2:	8b 00                	mov    (%eax),%eax
  8031d4:	a3 38 51 80 00       	mov    %eax,0x805138
  8031d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031dc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031e5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031ec:	a1 44 51 80 00       	mov    0x805144,%eax
  8031f1:	48                   	dec    %eax
  8031f2:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  8031f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031fa:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  803201:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803204:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  80320b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80320f:	75 17                	jne    803228 <insert_sorted_with_merge_freeList+0x183>
  803211:	83 ec 04             	sub    $0x4,%esp
  803214:	68 dc 43 80 00       	push   $0x8043dc
  803219:	68 3f 01 00 00       	push   $0x13f
  80321e:	68 ff 43 80 00       	push   $0x8043ff
  803223:	e8 f6 d4 ff ff       	call   80071e <_panic>
  803228:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80322e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803231:	89 10                	mov    %edx,(%eax)
  803233:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803236:	8b 00                	mov    (%eax),%eax
  803238:	85 c0                	test   %eax,%eax
  80323a:	74 0d                	je     803249 <insert_sorted_with_merge_freeList+0x1a4>
  80323c:	a1 48 51 80 00       	mov    0x805148,%eax
  803241:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803244:	89 50 04             	mov    %edx,0x4(%eax)
  803247:	eb 08                	jmp    803251 <insert_sorted_with_merge_freeList+0x1ac>
  803249:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80324c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803251:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803254:	a3 48 51 80 00       	mov    %eax,0x805148
  803259:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80325c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803263:	a1 54 51 80 00       	mov    0x805154,%eax
  803268:	40                   	inc    %eax
  803269:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80326e:	e9 7a 05 00 00       	jmp    8037ed <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  803273:	8b 45 08             	mov    0x8(%ebp),%eax
  803276:	8b 50 08             	mov    0x8(%eax),%edx
  803279:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80327c:	8b 40 08             	mov    0x8(%eax),%eax
  80327f:	39 c2                	cmp    %eax,%edx
  803281:	0f 82 14 01 00 00    	jb     80339b <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  803287:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80328a:	8b 50 08             	mov    0x8(%eax),%edx
  80328d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803290:	8b 40 0c             	mov    0xc(%eax),%eax
  803293:	01 c2                	add    %eax,%edx
  803295:	8b 45 08             	mov    0x8(%ebp),%eax
  803298:	8b 40 08             	mov    0x8(%eax),%eax
  80329b:	39 c2                	cmp    %eax,%edx
  80329d:	0f 85 90 00 00 00    	jne    803333 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  8032a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032a6:	8b 50 0c             	mov    0xc(%eax),%edx
  8032a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ac:	8b 40 0c             	mov    0xc(%eax),%eax
  8032af:	01 c2                	add    %eax,%edx
  8032b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032b4:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  8032b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ba:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  8032c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8032cb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032cf:	75 17                	jne    8032e8 <insert_sorted_with_merge_freeList+0x243>
  8032d1:	83 ec 04             	sub    $0x4,%esp
  8032d4:	68 dc 43 80 00       	push   $0x8043dc
  8032d9:	68 49 01 00 00       	push   $0x149
  8032de:	68 ff 43 80 00       	push   $0x8043ff
  8032e3:	e8 36 d4 ff ff       	call   80071e <_panic>
  8032e8:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8032ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f1:	89 10                	mov    %edx,(%eax)
  8032f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f6:	8b 00                	mov    (%eax),%eax
  8032f8:	85 c0                	test   %eax,%eax
  8032fa:	74 0d                	je     803309 <insert_sorted_with_merge_freeList+0x264>
  8032fc:	a1 48 51 80 00       	mov    0x805148,%eax
  803301:	8b 55 08             	mov    0x8(%ebp),%edx
  803304:	89 50 04             	mov    %edx,0x4(%eax)
  803307:	eb 08                	jmp    803311 <insert_sorted_with_merge_freeList+0x26c>
  803309:	8b 45 08             	mov    0x8(%ebp),%eax
  80330c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803311:	8b 45 08             	mov    0x8(%ebp),%eax
  803314:	a3 48 51 80 00       	mov    %eax,0x805148
  803319:	8b 45 08             	mov    0x8(%ebp),%eax
  80331c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803323:	a1 54 51 80 00       	mov    0x805154,%eax
  803328:	40                   	inc    %eax
  803329:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80332e:	e9 bb 04 00 00       	jmp    8037ee <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803333:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803337:	75 17                	jne    803350 <insert_sorted_with_merge_freeList+0x2ab>
  803339:	83 ec 04             	sub    $0x4,%esp
  80333c:	68 50 44 80 00       	push   $0x804450
  803341:	68 4c 01 00 00       	push   $0x14c
  803346:	68 ff 43 80 00       	push   $0x8043ff
  80334b:	e8 ce d3 ff ff       	call   80071e <_panic>
  803350:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803356:	8b 45 08             	mov    0x8(%ebp),%eax
  803359:	89 50 04             	mov    %edx,0x4(%eax)
  80335c:	8b 45 08             	mov    0x8(%ebp),%eax
  80335f:	8b 40 04             	mov    0x4(%eax),%eax
  803362:	85 c0                	test   %eax,%eax
  803364:	74 0c                	je     803372 <insert_sorted_with_merge_freeList+0x2cd>
  803366:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80336b:	8b 55 08             	mov    0x8(%ebp),%edx
  80336e:	89 10                	mov    %edx,(%eax)
  803370:	eb 08                	jmp    80337a <insert_sorted_with_merge_freeList+0x2d5>
  803372:	8b 45 08             	mov    0x8(%ebp),%eax
  803375:	a3 38 51 80 00       	mov    %eax,0x805138
  80337a:	8b 45 08             	mov    0x8(%ebp),%eax
  80337d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803382:	8b 45 08             	mov    0x8(%ebp),%eax
  803385:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80338b:	a1 44 51 80 00       	mov    0x805144,%eax
  803390:	40                   	inc    %eax
  803391:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803396:	e9 53 04 00 00       	jmp    8037ee <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80339b:	a1 38 51 80 00       	mov    0x805138,%eax
  8033a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033a3:	e9 15 04 00 00       	jmp    8037bd <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  8033a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ab:	8b 00                	mov    (%eax),%eax
  8033ad:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  8033b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b3:	8b 50 08             	mov    0x8(%eax),%edx
  8033b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b9:	8b 40 08             	mov    0x8(%eax),%eax
  8033bc:	39 c2                	cmp    %eax,%edx
  8033be:	0f 86 f1 03 00 00    	jbe    8037b5 <insert_sorted_with_merge_freeList+0x710>
  8033c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c7:	8b 50 08             	mov    0x8(%eax),%edx
  8033ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033cd:	8b 40 08             	mov    0x8(%eax),%eax
  8033d0:	39 c2                	cmp    %eax,%edx
  8033d2:	0f 83 dd 03 00 00    	jae    8037b5 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  8033d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033db:	8b 50 08             	mov    0x8(%eax),%edx
  8033de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033e1:	8b 40 0c             	mov    0xc(%eax),%eax
  8033e4:	01 c2                	add    %eax,%edx
  8033e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e9:	8b 40 08             	mov    0x8(%eax),%eax
  8033ec:	39 c2                	cmp    %eax,%edx
  8033ee:	0f 85 b9 01 00 00    	jne    8035ad <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8033f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f7:	8b 50 08             	mov    0x8(%eax),%edx
  8033fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8033fd:	8b 40 0c             	mov    0xc(%eax),%eax
  803400:	01 c2                	add    %eax,%edx
  803402:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803405:	8b 40 08             	mov    0x8(%eax),%eax
  803408:	39 c2                	cmp    %eax,%edx
  80340a:	0f 85 0d 01 00 00    	jne    80351d <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803410:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803413:	8b 50 0c             	mov    0xc(%eax),%edx
  803416:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803419:	8b 40 0c             	mov    0xc(%eax),%eax
  80341c:	01 c2                	add    %eax,%edx
  80341e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803421:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803424:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803428:	75 17                	jne    803441 <insert_sorted_with_merge_freeList+0x39c>
  80342a:	83 ec 04             	sub    $0x4,%esp
  80342d:	68 a8 44 80 00       	push   $0x8044a8
  803432:	68 5c 01 00 00       	push   $0x15c
  803437:	68 ff 43 80 00       	push   $0x8043ff
  80343c:	e8 dd d2 ff ff       	call   80071e <_panic>
  803441:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803444:	8b 00                	mov    (%eax),%eax
  803446:	85 c0                	test   %eax,%eax
  803448:	74 10                	je     80345a <insert_sorted_with_merge_freeList+0x3b5>
  80344a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80344d:	8b 00                	mov    (%eax),%eax
  80344f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803452:	8b 52 04             	mov    0x4(%edx),%edx
  803455:	89 50 04             	mov    %edx,0x4(%eax)
  803458:	eb 0b                	jmp    803465 <insert_sorted_with_merge_freeList+0x3c0>
  80345a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80345d:	8b 40 04             	mov    0x4(%eax),%eax
  803460:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803465:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803468:	8b 40 04             	mov    0x4(%eax),%eax
  80346b:	85 c0                	test   %eax,%eax
  80346d:	74 0f                	je     80347e <insert_sorted_with_merge_freeList+0x3d9>
  80346f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803472:	8b 40 04             	mov    0x4(%eax),%eax
  803475:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803478:	8b 12                	mov    (%edx),%edx
  80347a:	89 10                	mov    %edx,(%eax)
  80347c:	eb 0a                	jmp    803488 <insert_sorted_with_merge_freeList+0x3e3>
  80347e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803481:	8b 00                	mov    (%eax),%eax
  803483:	a3 38 51 80 00       	mov    %eax,0x805138
  803488:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80348b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803491:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803494:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80349b:	a1 44 51 80 00       	mov    0x805144,%eax
  8034a0:	48                   	dec    %eax
  8034a1:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  8034a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034a9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8034b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034b3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8034ba:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8034be:	75 17                	jne    8034d7 <insert_sorted_with_merge_freeList+0x432>
  8034c0:	83 ec 04             	sub    $0x4,%esp
  8034c3:	68 dc 43 80 00       	push   $0x8043dc
  8034c8:	68 5f 01 00 00       	push   $0x15f
  8034cd:	68 ff 43 80 00       	push   $0x8043ff
  8034d2:	e8 47 d2 ff ff       	call   80071e <_panic>
  8034d7:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8034dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034e0:	89 10                	mov    %edx,(%eax)
  8034e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034e5:	8b 00                	mov    (%eax),%eax
  8034e7:	85 c0                	test   %eax,%eax
  8034e9:	74 0d                	je     8034f8 <insert_sorted_with_merge_freeList+0x453>
  8034eb:	a1 48 51 80 00       	mov    0x805148,%eax
  8034f0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8034f3:	89 50 04             	mov    %edx,0x4(%eax)
  8034f6:	eb 08                	jmp    803500 <insert_sorted_with_merge_freeList+0x45b>
  8034f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034fb:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803500:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803503:	a3 48 51 80 00       	mov    %eax,0x805148
  803508:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80350b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803512:	a1 54 51 80 00       	mov    0x805154,%eax
  803517:	40                   	inc    %eax
  803518:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  80351d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803520:	8b 50 0c             	mov    0xc(%eax),%edx
  803523:	8b 45 08             	mov    0x8(%ebp),%eax
  803526:	8b 40 0c             	mov    0xc(%eax),%eax
  803529:	01 c2                	add    %eax,%edx
  80352b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80352e:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803531:	8b 45 08             	mov    0x8(%ebp),%eax
  803534:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  80353b:	8b 45 08             	mov    0x8(%ebp),%eax
  80353e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803545:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803549:	75 17                	jne    803562 <insert_sorted_with_merge_freeList+0x4bd>
  80354b:	83 ec 04             	sub    $0x4,%esp
  80354e:	68 dc 43 80 00       	push   $0x8043dc
  803553:	68 64 01 00 00       	push   $0x164
  803558:	68 ff 43 80 00       	push   $0x8043ff
  80355d:	e8 bc d1 ff ff       	call   80071e <_panic>
  803562:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803568:	8b 45 08             	mov    0x8(%ebp),%eax
  80356b:	89 10                	mov    %edx,(%eax)
  80356d:	8b 45 08             	mov    0x8(%ebp),%eax
  803570:	8b 00                	mov    (%eax),%eax
  803572:	85 c0                	test   %eax,%eax
  803574:	74 0d                	je     803583 <insert_sorted_with_merge_freeList+0x4de>
  803576:	a1 48 51 80 00       	mov    0x805148,%eax
  80357b:	8b 55 08             	mov    0x8(%ebp),%edx
  80357e:	89 50 04             	mov    %edx,0x4(%eax)
  803581:	eb 08                	jmp    80358b <insert_sorted_with_merge_freeList+0x4e6>
  803583:	8b 45 08             	mov    0x8(%ebp),%eax
  803586:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80358b:	8b 45 08             	mov    0x8(%ebp),%eax
  80358e:	a3 48 51 80 00       	mov    %eax,0x805148
  803593:	8b 45 08             	mov    0x8(%ebp),%eax
  803596:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80359d:	a1 54 51 80 00       	mov    0x805154,%eax
  8035a2:	40                   	inc    %eax
  8035a3:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8035a8:	e9 41 02 00 00       	jmp    8037ee <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8035ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b0:	8b 50 08             	mov    0x8(%eax),%edx
  8035b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b6:	8b 40 0c             	mov    0xc(%eax),%eax
  8035b9:	01 c2                	add    %eax,%edx
  8035bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035be:	8b 40 08             	mov    0x8(%eax),%eax
  8035c1:	39 c2                	cmp    %eax,%edx
  8035c3:	0f 85 7c 01 00 00    	jne    803745 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8035c9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8035cd:	74 06                	je     8035d5 <insert_sorted_with_merge_freeList+0x530>
  8035cf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035d3:	75 17                	jne    8035ec <insert_sorted_with_merge_freeList+0x547>
  8035d5:	83 ec 04             	sub    $0x4,%esp
  8035d8:	68 18 44 80 00       	push   $0x804418
  8035dd:	68 69 01 00 00       	push   $0x169
  8035e2:	68 ff 43 80 00       	push   $0x8043ff
  8035e7:	e8 32 d1 ff ff       	call   80071e <_panic>
  8035ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035ef:	8b 50 04             	mov    0x4(%eax),%edx
  8035f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f5:	89 50 04             	mov    %edx,0x4(%eax)
  8035f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8035fb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8035fe:	89 10                	mov    %edx,(%eax)
  803600:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803603:	8b 40 04             	mov    0x4(%eax),%eax
  803606:	85 c0                	test   %eax,%eax
  803608:	74 0d                	je     803617 <insert_sorted_with_merge_freeList+0x572>
  80360a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80360d:	8b 40 04             	mov    0x4(%eax),%eax
  803610:	8b 55 08             	mov    0x8(%ebp),%edx
  803613:	89 10                	mov    %edx,(%eax)
  803615:	eb 08                	jmp    80361f <insert_sorted_with_merge_freeList+0x57a>
  803617:	8b 45 08             	mov    0x8(%ebp),%eax
  80361a:	a3 38 51 80 00       	mov    %eax,0x805138
  80361f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803622:	8b 55 08             	mov    0x8(%ebp),%edx
  803625:	89 50 04             	mov    %edx,0x4(%eax)
  803628:	a1 44 51 80 00       	mov    0x805144,%eax
  80362d:	40                   	inc    %eax
  80362e:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803633:	8b 45 08             	mov    0x8(%ebp),%eax
  803636:	8b 50 0c             	mov    0xc(%eax),%edx
  803639:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80363c:	8b 40 0c             	mov    0xc(%eax),%eax
  80363f:	01 c2                	add    %eax,%edx
  803641:	8b 45 08             	mov    0x8(%ebp),%eax
  803644:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803647:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80364b:	75 17                	jne    803664 <insert_sorted_with_merge_freeList+0x5bf>
  80364d:	83 ec 04             	sub    $0x4,%esp
  803650:	68 a8 44 80 00       	push   $0x8044a8
  803655:	68 6b 01 00 00       	push   $0x16b
  80365a:	68 ff 43 80 00       	push   $0x8043ff
  80365f:	e8 ba d0 ff ff       	call   80071e <_panic>
  803664:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803667:	8b 00                	mov    (%eax),%eax
  803669:	85 c0                	test   %eax,%eax
  80366b:	74 10                	je     80367d <insert_sorted_with_merge_freeList+0x5d8>
  80366d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803670:	8b 00                	mov    (%eax),%eax
  803672:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803675:	8b 52 04             	mov    0x4(%edx),%edx
  803678:	89 50 04             	mov    %edx,0x4(%eax)
  80367b:	eb 0b                	jmp    803688 <insert_sorted_with_merge_freeList+0x5e3>
  80367d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803680:	8b 40 04             	mov    0x4(%eax),%eax
  803683:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803688:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80368b:	8b 40 04             	mov    0x4(%eax),%eax
  80368e:	85 c0                	test   %eax,%eax
  803690:	74 0f                	je     8036a1 <insert_sorted_with_merge_freeList+0x5fc>
  803692:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803695:	8b 40 04             	mov    0x4(%eax),%eax
  803698:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80369b:	8b 12                	mov    (%edx),%edx
  80369d:	89 10                	mov    %edx,(%eax)
  80369f:	eb 0a                	jmp    8036ab <insert_sorted_with_merge_freeList+0x606>
  8036a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036a4:	8b 00                	mov    (%eax),%eax
  8036a6:	a3 38 51 80 00       	mov    %eax,0x805138
  8036ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036ae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036b7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036be:	a1 44 51 80 00       	mov    0x805144,%eax
  8036c3:	48                   	dec    %eax
  8036c4:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  8036c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036cc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8036d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036d6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8036dd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8036e1:	75 17                	jne    8036fa <insert_sorted_with_merge_freeList+0x655>
  8036e3:	83 ec 04             	sub    $0x4,%esp
  8036e6:	68 dc 43 80 00       	push   $0x8043dc
  8036eb:	68 6e 01 00 00       	push   $0x16e
  8036f0:	68 ff 43 80 00       	push   $0x8043ff
  8036f5:	e8 24 d0 ff ff       	call   80071e <_panic>
  8036fa:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803700:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803703:	89 10                	mov    %edx,(%eax)
  803705:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803708:	8b 00                	mov    (%eax),%eax
  80370a:	85 c0                	test   %eax,%eax
  80370c:	74 0d                	je     80371b <insert_sorted_with_merge_freeList+0x676>
  80370e:	a1 48 51 80 00       	mov    0x805148,%eax
  803713:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803716:	89 50 04             	mov    %edx,0x4(%eax)
  803719:	eb 08                	jmp    803723 <insert_sorted_with_merge_freeList+0x67e>
  80371b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80371e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803723:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803726:	a3 48 51 80 00       	mov    %eax,0x805148
  80372b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80372e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803735:	a1 54 51 80 00       	mov    0x805154,%eax
  80373a:	40                   	inc    %eax
  80373b:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803740:	e9 a9 00 00 00       	jmp    8037ee <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803745:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803749:	74 06                	je     803751 <insert_sorted_with_merge_freeList+0x6ac>
  80374b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80374f:	75 17                	jne    803768 <insert_sorted_with_merge_freeList+0x6c3>
  803751:	83 ec 04             	sub    $0x4,%esp
  803754:	68 74 44 80 00       	push   $0x804474
  803759:	68 73 01 00 00       	push   $0x173
  80375e:	68 ff 43 80 00       	push   $0x8043ff
  803763:	e8 b6 cf ff ff       	call   80071e <_panic>
  803768:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80376b:	8b 10                	mov    (%eax),%edx
  80376d:	8b 45 08             	mov    0x8(%ebp),%eax
  803770:	89 10                	mov    %edx,(%eax)
  803772:	8b 45 08             	mov    0x8(%ebp),%eax
  803775:	8b 00                	mov    (%eax),%eax
  803777:	85 c0                	test   %eax,%eax
  803779:	74 0b                	je     803786 <insert_sorted_with_merge_freeList+0x6e1>
  80377b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80377e:	8b 00                	mov    (%eax),%eax
  803780:	8b 55 08             	mov    0x8(%ebp),%edx
  803783:	89 50 04             	mov    %edx,0x4(%eax)
  803786:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803789:	8b 55 08             	mov    0x8(%ebp),%edx
  80378c:	89 10                	mov    %edx,(%eax)
  80378e:	8b 45 08             	mov    0x8(%ebp),%eax
  803791:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803794:	89 50 04             	mov    %edx,0x4(%eax)
  803797:	8b 45 08             	mov    0x8(%ebp),%eax
  80379a:	8b 00                	mov    (%eax),%eax
  80379c:	85 c0                	test   %eax,%eax
  80379e:	75 08                	jne    8037a8 <insert_sorted_with_merge_freeList+0x703>
  8037a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8037a8:	a1 44 51 80 00       	mov    0x805144,%eax
  8037ad:	40                   	inc    %eax
  8037ae:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  8037b3:	eb 39                	jmp    8037ee <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8037b5:	a1 40 51 80 00       	mov    0x805140,%eax
  8037ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8037bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037c1:	74 07                	je     8037ca <insert_sorted_with_merge_freeList+0x725>
  8037c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037c6:	8b 00                	mov    (%eax),%eax
  8037c8:	eb 05                	jmp    8037cf <insert_sorted_with_merge_freeList+0x72a>
  8037ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8037cf:	a3 40 51 80 00       	mov    %eax,0x805140
  8037d4:	a1 40 51 80 00       	mov    0x805140,%eax
  8037d9:	85 c0                	test   %eax,%eax
  8037db:	0f 85 c7 fb ff ff    	jne    8033a8 <insert_sorted_with_merge_freeList+0x303>
  8037e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037e5:	0f 85 bd fb ff ff    	jne    8033a8 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8037eb:	eb 01                	jmp    8037ee <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8037ed:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8037ee:	90                   	nop
  8037ef:	c9                   	leave  
  8037f0:	c3                   	ret    

008037f1 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8037f1:	55                   	push   %ebp
  8037f2:	89 e5                	mov    %esp,%ebp
  8037f4:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8037f7:	8b 55 08             	mov    0x8(%ebp),%edx
  8037fa:	89 d0                	mov    %edx,%eax
  8037fc:	c1 e0 02             	shl    $0x2,%eax
  8037ff:	01 d0                	add    %edx,%eax
  803801:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803808:	01 d0                	add    %edx,%eax
  80380a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803811:	01 d0                	add    %edx,%eax
  803813:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80381a:	01 d0                	add    %edx,%eax
  80381c:	c1 e0 04             	shl    $0x4,%eax
  80381f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803822:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  803829:	8d 45 e8             	lea    -0x18(%ebp),%eax
  80382c:	83 ec 0c             	sub    $0xc,%esp
  80382f:	50                   	push   %eax
  803830:	e8 26 e7 ff ff       	call   801f5b <sys_get_virtual_time>
  803835:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803838:	eb 41                	jmp    80387b <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  80383a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80383d:	83 ec 0c             	sub    $0xc,%esp
  803840:	50                   	push   %eax
  803841:	e8 15 e7 ff ff       	call   801f5b <sys_get_virtual_time>
  803846:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803849:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80384c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80384f:	29 c2                	sub    %eax,%edx
  803851:	89 d0                	mov    %edx,%eax
  803853:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803856:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803859:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80385c:	89 d1                	mov    %edx,%ecx
  80385e:	29 c1                	sub    %eax,%ecx
  803860:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803863:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803866:	39 c2                	cmp    %eax,%edx
  803868:	0f 97 c0             	seta   %al
  80386b:	0f b6 c0             	movzbl %al,%eax
  80386e:	29 c1                	sub    %eax,%ecx
  803870:	89 c8                	mov    %ecx,%eax
  803872:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803875:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803878:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  80387b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80387e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803881:	72 b7                	jb     80383a <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803883:	90                   	nop
  803884:	c9                   	leave  
  803885:	c3                   	ret    

00803886 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803886:	55                   	push   %ebp
  803887:	89 e5                	mov    %esp,%ebp
  803889:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  80388c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803893:	eb 03                	jmp    803898 <busy_wait+0x12>
  803895:	ff 45 fc             	incl   -0x4(%ebp)
  803898:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80389b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80389e:	72 f5                	jb     803895 <busy_wait+0xf>
	return i;
  8038a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8038a3:	c9                   	leave  
  8038a4:	c3                   	ret    
  8038a5:	66 90                	xchg   %ax,%ax
  8038a7:	90                   	nop

008038a8 <__udivdi3>:
  8038a8:	55                   	push   %ebp
  8038a9:	57                   	push   %edi
  8038aa:	56                   	push   %esi
  8038ab:	53                   	push   %ebx
  8038ac:	83 ec 1c             	sub    $0x1c,%esp
  8038af:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8038b3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8038b7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8038bb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8038bf:	89 ca                	mov    %ecx,%edx
  8038c1:	89 f8                	mov    %edi,%eax
  8038c3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8038c7:	85 f6                	test   %esi,%esi
  8038c9:	75 2d                	jne    8038f8 <__udivdi3+0x50>
  8038cb:	39 cf                	cmp    %ecx,%edi
  8038cd:	77 65                	ja     803934 <__udivdi3+0x8c>
  8038cf:	89 fd                	mov    %edi,%ebp
  8038d1:	85 ff                	test   %edi,%edi
  8038d3:	75 0b                	jne    8038e0 <__udivdi3+0x38>
  8038d5:	b8 01 00 00 00       	mov    $0x1,%eax
  8038da:	31 d2                	xor    %edx,%edx
  8038dc:	f7 f7                	div    %edi
  8038de:	89 c5                	mov    %eax,%ebp
  8038e0:	31 d2                	xor    %edx,%edx
  8038e2:	89 c8                	mov    %ecx,%eax
  8038e4:	f7 f5                	div    %ebp
  8038e6:	89 c1                	mov    %eax,%ecx
  8038e8:	89 d8                	mov    %ebx,%eax
  8038ea:	f7 f5                	div    %ebp
  8038ec:	89 cf                	mov    %ecx,%edi
  8038ee:	89 fa                	mov    %edi,%edx
  8038f0:	83 c4 1c             	add    $0x1c,%esp
  8038f3:	5b                   	pop    %ebx
  8038f4:	5e                   	pop    %esi
  8038f5:	5f                   	pop    %edi
  8038f6:	5d                   	pop    %ebp
  8038f7:	c3                   	ret    
  8038f8:	39 ce                	cmp    %ecx,%esi
  8038fa:	77 28                	ja     803924 <__udivdi3+0x7c>
  8038fc:	0f bd fe             	bsr    %esi,%edi
  8038ff:	83 f7 1f             	xor    $0x1f,%edi
  803902:	75 40                	jne    803944 <__udivdi3+0x9c>
  803904:	39 ce                	cmp    %ecx,%esi
  803906:	72 0a                	jb     803912 <__udivdi3+0x6a>
  803908:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80390c:	0f 87 9e 00 00 00    	ja     8039b0 <__udivdi3+0x108>
  803912:	b8 01 00 00 00       	mov    $0x1,%eax
  803917:	89 fa                	mov    %edi,%edx
  803919:	83 c4 1c             	add    $0x1c,%esp
  80391c:	5b                   	pop    %ebx
  80391d:	5e                   	pop    %esi
  80391e:	5f                   	pop    %edi
  80391f:	5d                   	pop    %ebp
  803920:	c3                   	ret    
  803921:	8d 76 00             	lea    0x0(%esi),%esi
  803924:	31 ff                	xor    %edi,%edi
  803926:	31 c0                	xor    %eax,%eax
  803928:	89 fa                	mov    %edi,%edx
  80392a:	83 c4 1c             	add    $0x1c,%esp
  80392d:	5b                   	pop    %ebx
  80392e:	5e                   	pop    %esi
  80392f:	5f                   	pop    %edi
  803930:	5d                   	pop    %ebp
  803931:	c3                   	ret    
  803932:	66 90                	xchg   %ax,%ax
  803934:	89 d8                	mov    %ebx,%eax
  803936:	f7 f7                	div    %edi
  803938:	31 ff                	xor    %edi,%edi
  80393a:	89 fa                	mov    %edi,%edx
  80393c:	83 c4 1c             	add    $0x1c,%esp
  80393f:	5b                   	pop    %ebx
  803940:	5e                   	pop    %esi
  803941:	5f                   	pop    %edi
  803942:	5d                   	pop    %ebp
  803943:	c3                   	ret    
  803944:	bd 20 00 00 00       	mov    $0x20,%ebp
  803949:	89 eb                	mov    %ebp,%ebx
  80394b:	29 fb                	sub    %edi,%ebx
  80394d:	89 f9                	mov    %edi,%ecx
  80394f:	d3 e6                	shl    %cl,%esi
  803951:	89 c5                	mov    %eax,%ebp
  803953:	88 d9                	mov    %bl,%cl
  803955:	d3 ed                	shr    %cl,%ebp
  803957:	89 e9                	mov    %ebp,%ecx
  803959:	09 f1                	or     %esi,%ecx
  80395b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80395f:	89 f9                	mov    %edi,%ecx
  803961:	d3 e0                	shl    %cl,%eax
  803963:	89 c5                	mov    %eax,%ebp
  803965:	89 d6                	mov    %edx,%esi
  803967:	88 d9                	mov    %bl,%cl
  803969:	d3 ee                	shr    %cl,%esi
  80396b:	89 f9                	mov    %edi,%ecx
  80396d:	d3 e2                	shl    %cl,%edx
  80396f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803973:	88 d9                	mov    %bl,%cl
  803975:	d3 e8                	shr    %cl,%eax
  803977:	09 c2                	or     %eax,%edx
  803979:	89 d0                	mov    %edx,%eax
  80397b:	89 f2                	mov    %esi,%edx
  80397d:	f7 74 24 0c          	divl   0xc(%esp)
  803981:	89 d6                	mov    %edx,%esi
  803983:	89 c3                	mov    %eax,%ebx
  803985:	f7 e5                	mul    %ebp
  803987:	39 d6                	cmp    %edx,%esi
  803989:	72 19                	jb     8039a4 <__udivdi3+0xfc>
  80398b:	74 0b                	je     803998 <__udivdi3+0xf0>
  80398d:	89 d8                	mov    %ebx,%eax
  80398f:	31 ff                	xor    %edi,%edi
  803991:	e9 58 ff ff ff       	jmp    8038ee <__udivdi3+0x46>
  803996:	66 90                	xchg   %ax,%ax
  803998:	8b 54 24 08          	mov    0x8(%esp),%edx
  80399c:	89 f9                	mov    %edi,%ecx
  80399e:	d3 e2                	shl    %cl,%edx
  8039a0:	39 c2                	cmp    %eax,%edx
  8039a2:	73 e9                	jae    80398d <__udivdi3+0xe5>
  8039a4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8039a7:	31 ff                	xor    %edi,%edi
  8039a9:	e9 40 ff ff ff       	jmp    8038ee <__udivdi3+0x46>
  8039ae:	66 90                	xchg   %ax,%ax
  8039b0:	31 c0                	xor    %eax,%eax
  8039b2:	e9 37 ff ff ff       	jmp    8038ee <__udivdi3+0x46>
  8039b7:	90                   	nop

008039b8 <__umoddi3>:
  8039b8:	55                   	push   %ebp
  8039b9:	57                   	push   %edi
  8039ba:	56                   	push   %esi
  8039bb:	53                   	push   %ebx
  8039bc:	83 ec 1c             	sub    $0x1c,%esp
  8039bf:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8039c3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8039c7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8039cb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8039cf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8039d3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8039d7:	89 f3                	mov    %esi,%ebx
  8039d9:	89 fa                	mov    %edi,%edx
  8039db:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8039df:	89 34 24             	mov    %esi,(%esp)
  8039e2:	85 c0                	test   %eax,%eax
  8039e4:	75 1a                	jne    803a00 <__umoddi3+0x48>
  8039e6:	39 f7                	cmp    %esi,%edi
  8039e8:	0f 86 a2 00 00 00    	jbe    803a90 <__umoddi3+0xd8>
  8039ee:	89 c8                	mov    %ecx,%eax
  8039f0:	89 f2                	mov    %esi,%edx
  8039f2:	f7 f7                	div    %edi
  8039f4:	89 d0                	mov    %edx,%eax
  8039f6:	31 d2                	xor    %edx,%edx
  8039f8:	83 c4 1c             	add    $0x1c,%esp
  8039fb:	5b                   	pop    %ebx
  8039fc:	5e                   	pop    %esi
  8039fd:	5f                   	pop    %edi
  8039fe:	5d                   	pop    %ebp
  8039ff:	c3                   	ret    
  803a00:	39 f0                	cmp    %esi,%eax
  803a02:	0f 87 ac 00 00 00    	ja     803ab4 <__umoddi3+0xfc>
  803a08:	0f bd e8             	bsr    %eax,%ebp
  803a0b:	83 f5 1f             	xor    $0x1f,%ebp
  803a0e:	0f 84 ac 00 00 00    	je     803ac0 <__umoddi3+0x108>
  803a14:	bf 20 00 00 00       	mov    $0x20,%edi
  803a19:	29 ef                	sub    %ebp,%edi
  803a1b:	89 fe                	mov    %edi,%esi
  803a1d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803a21:	89 e9                	mov    %ebp,%ecx
  803a23:	d3 e0                	shl    %cl,%eax
  803a25:	89 d7                	mov    %edx,%edi
  803a27:	89 f1                	mov    %esi,%ecx
  803a29:	d3 ef                	shr    %cl,%edi
  803a2b:	09 c7                	or     %eax,%edi
  803a2d:	89 e9                	mov    %ebp,%ecx
  803a2f:	d3 e2                	shl    %cl,%edx
  803a31:	89 14 24             	mov    %edx,(%esp)
  803a34:	89 d8                	mov    %ebx,%eax
  803a36:	d3 e0                	shl    %cl,%eax
  803a38:	89 c2                	mov    %eax,%edx
  803a3a:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a3e:	d3 e0                	shl    %cl,%eax
  803a40:	89 44 24 04          	mov    %eax,0x4(%esp)
  803a44:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a48:	89 f1                	mov    %esi,%ecx
  803a4a:	d3 e8                	shr    %cl,%eax
  803a4c:	09 d0                	or     %edx,%eax
  803a4e:	d3 eb                	shr    %cl,%ebx
  803a50:	89 da                	mov    %ebx,%edx
  803a52:	f7 f7                	div    %edi
  803a54:	89 d3                	mov    %edx,%ebx
  803a56:	f7 24 24             	mull   (%esp)
  803a59:	89 c6                	mov    %eax,%esi
  803a5b:	89 d1                	mov    %edx,%ecx
  803a5d:	39 d3                	cmp    %edx,%ebx
  803a5f:	0f 82 87 00 00 00    	jb     803aec <__umoddi3+0x134>
  803a65:	0f 84 91 00 00 00    	je     803afc <__umoddi3+0x144>
  803a6b:	8b 54 24 04          	mov    0x4(%esp),%edx
  803a6f:	29 f2                	sub    %esi,%edx
  803a71:	19 cb                	sbb    %ecx,%ebx
  803a73:	89 d8                	mov    %ebx,%eax
  803a75:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803a79:	d3 e0                	shl    %cl,%eax
  803a7b:	89 e9                	mov    %ebp,%ecx
  803a7d:	d3 ea                	shr    %cl,%edx
  803a7f:	09 d0                	or     %edx,%eax
  803a81:	89 e9                	mov    %ebp,%ecx
  803a83:	d3 eb                	shr    %cl,%ebx
  803a85:	89 da                	mov    %ebx,%edx
  803a87:	83 c4 1c             	add    $0x1c,%esp
  803a8a:	5b                   	pop    %ebx
  803a8b:	5e                   	pop    %esi
  803a8c:	5f                   	pop    %edi
  803a8d:	5d                   	pop    %ebp
  803a8e:	c3                   	ret    
  803a8f:	90                   	nop
  803a90:	89 fd                	mov    %edi,%ebp
  803a92:	85 ff                	test   %edi,%edi
  803a94:	75 0b                	jne    803aa1 <__umoddi3+0xe9>
  803a96:	b8 01 00 00 00       	mov    $0x1,%eax
  803a9b:	31 d2                	xor    %edx,%edx
  803a9d:	f7 f7                	div    %edi
  803a9f:	89 c5                	mov    %eax,%ebp
  803aa1:	89 f0                	mov    %esi,%eax
  803aa3:	31 d2                	xor    %edx,%edx
  803aa5:	f7 f5                	div    %ebp
  803aa7:	89 c8                	mov    %ecx,%eax
  803aa9:	f7 f5                	div    %ebp
  803aab:	89 d0                	mov    %edx,%eax
  803aad:	e9 44 ff ff ff       	jmp    8039f6 <__umoddi3+0x3e>
  803ab2:	66 90                	xchg   %ax,%ax
  803ab4:	89 c8                	mov    %ecx,%eax
  803ab6:	89 f2                	mov    %esi,%edx
  803ab8:	83 c4 1c             	add    $0x1c,%esp
  803abb:	5b                   	pop    %ebx
  803abc:	5e                   	pop    %esi
  803abd:	5f                   	pop    %edi
  803abe:	5d                   	pop    %ebp
  803abf:	c3                   	ret    
  803ac0:	3b 04 24             	cmp    (%esp),%eax
  803ac3:	72 06                	jb     803acb <__umoddi3+0x113>
  803ac5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803ac9:	77 0f                	ja     803ada <__umoddi3+0x122>
  803acb:	89 f2                	mov    %esi,%edx
  803acd:	29 f9                	sub    %edi,%ecx
  803acf:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803ad3:	89 14 24             	mov    %edx,(%esp)
  803ad6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803ada:	8b 44 24 04          	mov    0x4(%esp),%eax
  803ade:	8b 14 24             	mov    (%esp),%edx
  803ae1:	83 c4 1c             	add    $0x1c,%esp
  803ae4:	5b                   	pop    %ebx
  803ae5:	5e                   	pop    %esi
  803ae6:	5f                   	pop    %edi
  803ae7:	5d                   	pop    %ebp
  803ae8:	c3                   	ret    
  803ae9:	8d 76 00             	lea    0x0(%esi),%esi
  803aec:	2b 04 24             	sub    (%esp),%eax
  803aef:	19 fa                	sbb    %edi,%edx
  803af1:	89 d1                	mov    %edx,%ecx
  803af3:	89 c6                	mov    %eax,%esi
  803af5:	e9 71 ff ff ff       	jmp    803a6b <__umoddi3+0xb3>
  803afa:	66 90                	xchg   %ax,%ax
  803afc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803b00:	72 ea                	jb     803aec <__umoddi3+0x134>
  803b02:	89 d9                	mov    %ebx,%ecx
  803b04:	e9 62 ff ff ff       	jmp    803a6b <__umoddi3+0xb3>
