
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
  80008a:	68 a0 3b 80 00       	push   $0x803ba0
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
  8000ba:	68 d2 3b 80 00       	push   $0x803bd2
  8000bf:	e8 6f 1e 00 00       	call   801f33 <sys_create_env>
  8000c4:	83 c4 10             	add    $0x10,%esp
  8000c7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		int freeFrames = sys_calculate_free_frames() ;
  8000ca:	e8 f2 1b 00 00       	call   801cc1 <sys_calculate_free_frames>
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
  8000f5:	68 d6 3b 80 00       	push   $0x803bd6
  8000fa:	e8 34 1e 00 00       	call   801f33 <sys_create_env>
  8000ff:	83 c4 10             	add    $0x10,%esp
  800102:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		int helloWorldFrames = freeFrames - sys_calculate_free_frames() ;
  800105:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800108:	e8 b4 1b 00 00       	call   801cc1 <sys_calculate_free_frames>
  80010d:	29 c3                	sub    %eax,%ebx
  80010f:	89 d8                	mov    %ebx,%eax
  800111:	89 45 d0             	mov    %eax,-0x30(%ebp)
		env_sleep(2000);
  800114:	83 ec 0c             	sub    $0xc,%esp
  800117:	68 d0 07 00 00       	push   $0x7d0
  80011c:	e8 62 37 00 00       	call   803883 <env_sleep>
  800121:	83 c4 10             	add    $0x10,%esp
		cprintf("[DONE]\n\n");
  800124:	83 ec 0c             	sub    $0xc,%esp
  800127:	68 e5 3b 80 00       	push   $0x803be5
  80012c:	e8 a1 08 00 00       	call   8009d2 <cprintf>
  800131:	83 c4 10             	add    $0x10,%esp

		//Load and run "fos_add"
		cprintf("Loading fos_add program into RAM...");
  800134:	83 ec 0c             	sub    $0xc,%esp
  800137:	68 f0 3b 80 00       	push   $0x803bf0
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
  800167:	68 14 3c 80 00       	push   $0x803c14
  80016c:	e8 c2 1d 00 00       	call   801f33 <sys_create_env>
  800171:	83 c4 10             	add    $0x10,%esp
  800174:	89 45 cc             	mov    %eax,-0x34(%ebp)
		env_sleep(2000);
  800177:	83 ec 0c             	sub    $0xc,%esp
  80017a:	68 d0 07 00 00       	push   $0x7d0
  80017f:	e8 ff 36 00 00       	call   803883 <env_sleep>
  800184:	83 c4 10             	add    $0x10,%esp
		cprintf("[DONE]\n\n");
  800187:	83 ec 0c             	sub    $0xc,%esp
  80018a:	68 e5 3b 80 00       	push   $0x803be5
  80018f:	e8 3e 08 00 00       	call   8009d2 <cprintf>
  800194:	83 c4 10             	add    $0x10,%esp
		cprintf("running fos_add program...\n\n");
  800197:	83 ec 0c             	sub    $0xc,%esp
  80019a:	68 1c 3c 80 00       	push   $0x803c1c
  80019f:	e8 2e 08 00 00       	call   8009d2 <cprintf>
  8001a4:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdFOSAdd);
  8001a7:	83 ec 0c             	sub    $0xc,%esp
  8001aa:	ff 75 cc             	pushl  -0x34(%ebp)
  8001ad:	e8 9f 1d 00 00       	call   801f51 <sys_run_env>
  8001b2:	83 c4 10             	add    $0x10,%esp

		cprintf("please be patient ...\n");
  8001b5:	83 ec 0c             	sub    $0xc,%esp
  8001b8:	68 39 3c 80 00       	push   $0x803c39
  8001bd:	e8 10 08 00 00       	call   8009d2 <cprintf>
  8001c2:	83 c4 10             	add    $0x10,%esp
		env_sleep(5000);
  8001c5:	83 ec 0c             	sub    $0xc,%esp
  8001c8:	68 88 13 00 00       	push   $0x1388
  8001cd:	e8 b1 36 00 00       	call   803883 <env_sleep>
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
  800266:	e8 56 1a 00 00       	call   801cc1 <sys_calculate_free_frames>
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
  800352:	68 50 3c 80 00       	push   $0x803c50
  800357:	e8 76 06 00 00       	call   8009d2 <cprintf>
  80035c:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdHelloWorld);
  80035f:	83 ec 0c             	sub    $0xc,%esp
  800362:	ff 75 d4             	pushl  -0x2c(%ebp)
  800365:	e8 e7 1b 00 00       	call   801f51 <sys_run_env>
  80036a:	83 c4 10             	add    $0x10,%esp

		cprintf("please be patient ...\n");
  80036d:	83 ec 0c             	sub    $0xc,%esp
  800370:	68 39 3c 80 00       	push   $0x803c39
  800375:	e8 58 06 00 00       	call   8009d2 <cprintf>
  80037a:	83 c4 10             	add    $0x10,%esp
		env_sleep(5000);
  80037d:	83 ec 0c             	sub    $0xc,%esp
  800380:	68 88 13 00 00       	push   $0x1388
  800385:	e8 f9 34 00 00       	call   803883 <env_sleep>
  80038a:	83 c4 10             	add    $0x10,%esp

		//Allocate the remaining RAM + extra RAM by the size of helloWorld program (Here: it requires to free some RAM by removing exited & loaded program(s) (fos_helloWorld & fib))
		freeFrames = sys_calculate_free_frames() ;
  80038d:	e8 2f 19 00 00       	call   801cc1 <sys_calculate_free_frames>
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
  800444:	68 74 3c 80 00       	push   $0x803c74
  800449:	6a 62                	push   $0x62
  80044b:	68 a9 3c 80 00       	push   $0x803ca9
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
  800479:	68 74 3c 80 00       	push   $0x803c74
  80047e:	6a 63                	push   $0x63
  800480:	68 a9 3c 80 00       	push   $0x803ca9
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
  8004ad:	68 74 3c 80 00       	push   $0x803c74
  8004b2:	6a 64                	push   $0x64
  8004b4:	68 a9 3c 80 00       	push   $0x803ca9
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
  8004e1:	68 74 3c 80 00       	push   $0x803c74
  8004e6:	6a 65                	push   $0x65
  8004e8:	68 a9 3c 80 00       	push   $0x803ca9
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
  800515:	68 74 3c 80 00       	push   $0x803c74
  80051a:	6a 66                	push   $0x66
  80051c:	68 a9 3c 80 00       	push   $0x803ca9
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
  800549:	68 74 3c 80 00       	push   $0x803c74
  80054e:	6a 68                	push   $0x68
  800550:	68 a9 3c 80 00       	push   $0x803ca9
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
  800583:	68 74 3c 80 00       	push   $0x803c74
  800588:	6a 69                	push   $0x69
  80058a:	68 a9 3c 80 00       	push   $0x803ca9
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
  8005b9:	68 74 3c 80 00       	push   $0x803c74
  8005be:	6a 6a                	push   $0x6a
  8005c0:	68 a9 3c 80 00       	push   $0x803ca9
  8005c5:	e8 54 01 00 00       	call   80071e <_panic>


	}

	cprintf("Congratulations!! test freeRAM (1) completed successfully.\n");
  8005ca:	83 ec 0c             	sub    $0xc,%esp
  8005cd:	68 c0 3c 80 00       	push   $0x803cc0
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
  8005e8:	e8 b4 19 00 00       	call   801fa1 <sys_getenvindex>
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
  800653:	e8 56 17 00 00       	call   801dae <sys_disable_interrupt>
	cprintf("**************************************\n");
  800658:	83 ec 0c             	sub    $0xc,%esp
  80065b:	68 14 3d 80 00       	push   $0x803d14
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
  800683:	68 3c 3d 80 00       	push   $0x803d3c
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
  8006b4:	68 64 3d 80 00       	push   $0x803d64
  8006b9:	e8 14 03 00 00       	call   8009d2 <cprintf>
  8006be:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8006c1:	a1 20 50 80 00       	mov    0x805020,%eax
  8006c6:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8006cc:	83 ec 08             	sub    $0x8,%esp
  8006cf:	50                   	push   %eax
  8006d0:	68 bc 3d 80 00       	push   $0x803dbc
  8006d5:	e8 f8 02 00 00       	call   8009d2 <cprintf>
  8006da:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8006dd:	83 ec 0c             	sub    $0xc,%esp
  8006e0:	68 14 3d 80 00       	push   $0x803d14
  8006e5:	e8 e8 02 00 00       	call   8009d2 <cprintf>
  8006ea:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8006ed:	e8 d6 16 00 00       	call   801dc8 <sys_enable_interrupt>

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
  800705:	e8 63 18 00 00       	call   801f6d <sys_destroy_env>
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
  800716:	e8 b8 18 00 00       	call   801fd3 <sys_exit_env>
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
  80073f:	68 d0 3d 80 00       	push   $0x803dd0
  800744:	e8 89 02 00 00       	call   8009d2 <cprintf>
  800749:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80074c:	a1 00 50 80 00       	mov    0x805000,%eax
  800751:	ff 75 0c             	pushl  0xc(%ebp)
  800754:	ff 75 08             	pushl  0x8(%ebp)
  800757:	50                   	push   %eax
  800758:	68 d5 3d 80 00       	push   $0x803dd5
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
  80077c:	68 f1 3d 80 00       	push   $0x803df1
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
  8007a8:	68 f4 3d 80 00       	push   $0x803df4
  8007ad:	6a 26                	push   $0x26
  8007af:	68 40 3e 80 00       	push   $0x803e40
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
  80087a:	68 4c 3e 80 00       	push   $0x803e4c
  80087f:	6a 3a                	push   $0x3a
  800881:	68 40 3e 80 00       	push   $0x803e40
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
  8008ea:	68 a0 3e 80 00       	push   $0x803ea0
  8008ef:	6a 44                	push   $0x44
  8008f1:	68 40 3e 80 00       	push   $0x803e40
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
  800944:	e8 b7 12 00 00       	call   801c00 <sys_cputs>
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
  8009bb:	e8 40 12 00 00       	call   801c00 <sys_cputs>
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
  800a05:	e8 a4 13 00 00       	call   801dae <sys_disable_interrupt>
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
  800a25:	e8 9e 13 00 00       	call   801dc8 <sys_enable_interrupt>
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
  800a6f:	e8 c4 2e 00 00       	call   803938 <__udivdi3>
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
  800abf:	e8 84 2f 00 00       	call   803a48 <__umoddi3>
  800ac4:	83 c4 10             	add    $0x10,%esp
  800ac7:	05 14 41 80 00       	add    $0x804114,%eax
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
  800c1a:	8b 04 85 38 41 80 00 	mov    0x804138(,%eax,4),%eax
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
  800cfb:	8b 34 9d 80 3f 80 00 	mov    0x803f80(,%ebx,4),%esi
  800d02:	85 f6                	test   %esi,%esi
  800d04:	75 19                	jne    800d1f <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d06:	53                   	push   %ebx
  800d07:	68 25 41 80 00       	push   $0x804125
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
  800d20:	68 2e 41 80 00       	push   $0x80412e
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
  800d4d:	be 31 41 80 00       	mov    $0x804131,%esi
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
  801773:	68 90 42 80 00       	push   $0x804290
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
  801843:	e8 fc 04 00 00       	call   801d44 <sys_allocate_chunk>
  801848:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  80184b:	a1 20 51 80 00       	mov    0x805120,%eax
  801850:	83 ec 0c             	sub    $0xc,%esp
  801853:	50                   	push   %eax
  801854:	e8 71 0b 00 00       	call   8023ca <initialize_MemBlocksList>
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
  801881:	68 b5 42 80 00       	push   $0x8042b5
  801886:	6a 33                	push   $0x33
  801888:	68 d3 42 80 00       	push   $0x8042d3
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
  801900:	68 e0 42 80 00       	push   $0x8042e0
  801905:	6a 34                	push   $0x34
  801907:	68 d3 42 80 00       	push   $0x8042d3
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
  801998:	e8 75 07 00 00       	call   802112 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80199d:	85 c0                	test   %eax,%eax
  80199f:	74 11                	je     8019b2 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  8019a1:	83 ec 0c             	sub    $0xc,%esp
  8019a4:	ff 75 e8             	pushl  -0x18(%ebp)
  8019a7:	e8 e0 0d 00 00       	call   80278c <alloc_block_FF>
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
  8019be:	e8 3c 0b 00 00       	call   8024ff <insert_sorted_allocList>
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
  8019de:	68 04 43 80 00       	push   $0x804304
  8019e3:	6a 6f                	push   $0x6f
  8019e5:	68 d3 42 80 00       	push   $0x8042d3
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
  801a04:	75 0a                	jne    801a10 <smalloc+0x21>
  801a06:	b8 00 00 00 00       	mov    $0x0,%eax
  801a0b:	e9 8b 00 00 00       	jmp    801a9b <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801a10:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801a17:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a1d:	01 d0                	add    %edx,%eax
  801a1f:	48                   	dec    %eax
  801a20:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801a23:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a26:	ba 00 00 00 00       	mov    $0x0,%edx
  801a2b:	f7 75 f0             	divl   -0x10(%ebp)
  801a2e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a31:	29 d0                	sub    %edx,%eax
  801a33:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801a36:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801a3d:	e8 d0 06 00 00       	call   802112 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801a42:	85 c0                	test   %eax,%eax
  801a44:	74 11                	je     801a57 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  801a46:	83 ec 0c             	sub    $0xc,%esp
  801a49:	ff 75 e8             	pushl  -0x18(%ebp)
  801a4c:	e8 3b 0d 00 00       	call   80278c <alloc_block_FF>
  801a51:	83 c4 10             	add    $0x10,%esp
  801a54:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  801a57:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a5b:	74 39                	je     801a96 <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801a5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a60:	8b 40 08             	mov    0x8(%eax),%eax
  801a63:	89 c2                	mov    %eax,%edx
  801a65:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801a69:	52                   	push   %edx
  801a6a:	50                   	push   %eax
  801a6b:	ff 75 0c             	pushl  0xc(%ebp)
  801a6e:	ff 75 08             	pushl  0x8(%ebp)
  801a71:	e8 21 04 00 00       	call   801e97 <sys_createSharedObject>
  801a76:	83 c4 10             	add    $0x10,%esp
  801a79:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  801a7c:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  801a80:	74 14                	je     801a96 <smalloc+0xa7>
  801a82:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  801a86:	74 0e                	je     801a96 <smalloc+0xa7>
  801a88:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  801a8c:	74 08                	je     801a96 <smalloc+0xa7>
			return (void*) mem_block->sva;
  801a8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a91:	8b 40 08             	mov    0x8(%eax),%eax
  801a94:	eb 05                	jmp    801a9b <smalloc+0xac>
	}
	return NULL;
  801a96:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801a9b:	c9                   	leave  
  801a9c:	c3                   	ret    

00801a9d <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801a9d:	55                   	push   %ebp
  801a9e:	89 e5                	mov    %esp,%ebp
  801aa0:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801aa3:	e8 b4 fc ff ff       	call   80175c <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801aa8:	83 ec 08             	sub    $0x8,%esp
  801aab:	ff 75 0c             	pushl  0xc(%ebp)
  801aae:	ff 75 08             	pushl  0x8(%ebp)
  801ab1:	e8 0b 04 00 00       	call   801ec1 <sys_getSizeOfSharedObject>
  801ab6:	83 c4 10             	add    $0x10,%esp
  801ab9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  801abc:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  801ac0:	74 76                	je     801b38 <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801ac2:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801ac9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801acc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801acf:	01 d0                	add    %edx,%eax
  801ad1:	48                   	dec    %eax
  801ad2:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801ad5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ad8:	ba 00 00 00 00       	mov    $0x0,%edx
  801add:	f7 75 ec             	divl   -0x14(%ebp)
  801ae0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ae3:	29 d0                	sub    %edx,%eax
  801ae5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  801ae8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801aef:	e8 1e 06 00 00       	call   802112 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801af4:	85 c0                	test   %eax,%eax
  801af6:	74 11                	je     801b09 <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  801af8:	83 ec 0c             	sub    $0xc,%esp
  801afb:	ff 75 e4             	pushl  -0x1c(%ebp)
  801afe:	e8 89 0c 00 00       	call   80278c <alloc_block_FF>
  801b03:	83 c4 10             	add    $0x10,%esp
  801b06:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  801b09:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b0d:	74 29                	je     801b38 <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  801b0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b12:	8b 40 08             	mov    0x8(%eax),%eax
  801b15:	83 ec 04             	sub    $0x4,%esp
  801b18:	50                   	push   %eax
  801b19:	ff 75 0c             	pushl  0xc(%ebp)
  801b1c:	ff 75 08             	pushl  0x8(%ebp)
  801b1f:	e8 ba 03 00 00       	call   801ede <sys_getSharedObject>
  801b24:	83 c4 10             	add    $0x10,%esp
  801b27:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  801b2a:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  801b2e:	74 08                	je     801b38 <sget+0x9b>
				return (void *)mem_block->sva;
  801b30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b33:	8b 40 08             	mov    0x8(%eax),%eax
  801b36:	eb 05                	jmp    801b3d <sget+0xa0>
		}
	}
	return NULL;
  801b38:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801b3d:	c9                   	leave  
  801b3e:	c3                   	ret    

00801b3f <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801b3f:	55                   	push   %ebp
  801b40:	89 e5                	mov    %esp,%ebp
  801b42:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801b45:	e8 12 fc ff ff       	call   80175c <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801b4a:	83 ec 04             	sub    $0x4,%esp
  801b4d:	68 28 43 80 00       	push   $0x804328
  801b52:	68 f1 00 00 00       	push   $0xf1
  801b57:	68 d3 42 80 00       	push   $0x8042d3
  801b5c:	e8 bd eb ff ff       	call   80071e <_panic>

00801b61 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801b61:	55                   	push   %ebp
  801b62:	89 e5                	mov    %esp,%ebp
  801b64:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801b67:	83 ec 04             	sub    $0x4,%esp
  801b6a:	68 50 43 80 00       	push   $0x804350
  801b6f:	68 05 01 00 00       	push   $0x105
  801b74:	68 d3 42 80 00       	push   $0x8042d3
  801b79:	e8 a0 eb ff ff       	call   80071e <_panic>

00801b7e <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801b7e:	55                   	push   %ebp
  801b7f:	89 e5                	mov    %esp,%ebp
  801b81:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801b84:	83 ec 04             	sub    $0x4,%esp
  801b87:	68 74 43 80 00       	push   $0x804374
  801b8c:	68 10 01 00 00       	push   $0x110
  801b91:	68 d3 42 80 00       	push   $0x8042d3
  801b96:	e8 83 eb ff ff       	call   80071e <_panic>

00801b9b <shrink>:

}
void shrink(uint32 newSize)
{
  801b9b:	55                   	push   %ebp
  801b9c:	89 e5                	mov    %esp,%ebp
  801b9e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ba1:	83 ec 04             	sub    $0x4,%esp
  801ba4:	68 74 43 80 00       	push   $0x804374
  801ba9:	68 15 01 00 00       	push   $0x115
  801bae:	68 d3 42 80 00       	push   $0x8042d3
  801bb3:	e8 66 eb ff ff       	call   80071e <_panic>

00801bb8 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801bb8:	55                   	push   %ebp
  801bb9:	89 e5                	mov    %esp,%ebp
  801bbb:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801bbe:	83 ec 04             	sub    $0x4,%esp
  801bc1:	68 74 43 80 00       	push   $0x804374
  801bc6:	68 1a 01 00 00       	push   $0x11a
  801bcb:	68 d3 42 80 00       	push   $0x8042d3
  801bd0:	e8 49 eb ff ff       	call   80071e <_panic>

00801bd5 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801bd5:	55                   	push   %ebp
  801bd6:	89 e5                	mov    %esp,%ebp
  801bd8:	57                   	push   %edi
  801bd9:	56                   	push   %esi
  801bda:	53                   	push   %ebx
  801bdb:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801bde:	8b 45 08             	mov    0x8(%ebp),%eax
  801be1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801be4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801be7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801bea:	8b 7d 18             	mov    0x18(%ebp),%edi
  801bed:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801bf0:	cd 30                	int    $0x30
  801bf2:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801bf5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801bf8:	83 c4 10             	add    $0x10,%esp
  801bfb:	5b                   	pop    %ebx
  801bfc:	5e                   	pop    %esi
  801bfd:	5f                   	pop    %edi
  801bfe:	5d                   	pop    %ebp
  801bff:	c3                   	ret    

00801c00 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801c00:	55                   	push   %ebp
  801c01:	89 e5                	mov    %esp,%ebp
  801c03:	83 ec 04             	sub    $0x4,%esp
  801c06:	8b 45 10             	mov    0x10(%ebp),%eax
  801c09:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801c0c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c10:	8b 45 08             	mov    0x8(%ebp),%eax
  801c13:	6a 00                	push   $0x0
  801c15:	6a 00                	push   $0x0
  801c17:	52                   	push   %edx
  801c18:	ff 75 0c             	pushl  0xc(%ebp)
  801c1b:	50                   	push   %eax
  801c1c:	6a 00                	push   $0x0
  801c1e:	e8 b2 ff ff ff       	call   801bd5 <syscall>
  801c23:	83 c4 18             	add    $0x18,%esp
}
  801c26:	90                   	nop
  801c27:	c9                   	leave  
  801c28:	c3                   	ret    

00801c29 <sys_cgetc>:

int
sys_cgetc(void)
{
  801c29:	55                   	push   %ebp
  801c2a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801c2c:	6a 00                	push   $0x0
  801c2e:	6a 00                	push   $0x0
  801c30:	6a 00                	push   $0x0
  801c32:	6a 00                	push   $0x0
  801c34:	6a 00                	push   $0x0
  801c36:	6a 01                	push   $0x1
  801c38:	e8 98 ff ff ff       	call   801bd5 <syscall>
  801c3d:	83 c4 18             	add    $0x18,%esp
}
  801c40:	c9                   	leave  
  801c41:	c3                   	ret    

00801c42 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801c42:	55                   	push   %ebp
  801c43:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801c45:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c48:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4b:	6a 00                	push   $0x0
  801c4d:	6a 00                	push   $0x0
  801c4f:	6a 00                	push   $0x0
  801c51:	52                   	push   %edx
  801c52:	50                   	push   %eax
  801c53:	6a 05                	push   $0x5
  801c55:	e8 7b ff ff ff       	call   801bd5 <syscall>
  801c5a:	83 c4 18             	add    $0x18,%esp
}
  801c5d:	c9                   	leave  
  801c5e:	c3                   	ret    

00801c5f <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801c5f:	55                   	push   %ebp
  801c60:	89 e5                	mov    %esp,%ebp
  801c62:	56                   	push   %esi
  801c63:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801c64:	8b 75 18             	mov    0x18(%ebp),%esi
  801c67:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c6a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c6d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c70:	8b 45 08             	mov    0x8(%ebp),%eax
  801c73:	56                   	push   %esi
  801c74:	53                   	push   %ebx
  801c75:	51                   	push   %ecx
  801c76:	52                   	push   %edx
  801c77:	50                   	push   %eax
  801c78:	6a 06                	push   $0x6
  801c7a:	e8 56 ff ff ff       	call   801bd5 <syscall>
  801c7f:	83 c4 18             	add    $0x18,%esp
}
  801c82:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c85:	5b                   	pop    %ebx
  801c86:	5e                   	pop    %esi
  801c87:	5d                   	pop    %ebp
  801c88:	c3                   	ret    

00801c89 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801c89:	55                   	push   %ebp
  801c8a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801c8c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c92:	6a 00                	push   $0x0
  801c94:	6a 00                	push   $0x0
  801c96:	6a 00                	push   $0x0
  801c98:	52                   	push   %edx
  801c99:	50                   	push   %eax
  801c9a:	6a 07                	push   $0x7
  801c9c:	e8 34 ff ff ff       	call   801bd5 <syscall>
  801ca1:	83 c4 18             	add    $0x18,%esp
}
  801ca4:	c9                   	leave  
  801ca5:	c3                   	ret    

00801ca6 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801ca6:	55                   	push   %ebp
  801ca7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801ca9:	6a 00                	push   $0x0
  801cab:	6a 00                	push   $0x0
  801cad:	6a 00                	push   $0x0
  801caf:	ff 75 0c             	pushl  0xc(%ebp)
  801cb2:	ff 75 08             	pushl  0x8(%ebp)
  801cb5:	6a 08                	push   $0x8
  801cb7:	e8 19 ff ff ff       	call   801bd5 <syscall>
  801cbc:	83 c4 18             	add    $0x18,%esp
}
  801cbf:	c9                   	leave  
  801cc0:	c3                   	ret    

00801cc1 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801cc1:	55                   	push   %ebp
  801cc2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801cc4:	6a 00                	push   $0x0
  801cc6:	6a 00                	push   $0x0
  801cc8:	6a 00                	push   $0x0
  801cca:	6a 00                	push   $0x0
  801ccc:	6a 00                	push   $0x0
  801cce:	6a 09                	push   $0x9
  801cd0:	e8 00 ff ff ff       	call   801bd5 <syscall>
  801cd5:	83 c4 18             	add    $0x18,%esp
}
  801cd8:	c9                   	leave  
  801cd9:	c3                   	ret    

00801cda <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801cda:	55                   	push   %ebp
  801cdb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801cdd:	6a 00                	push   $0x0
  801cdf:	6a 00                	push   $0x0
  801ce1:	6a 00                	push   $0x0
  801ce3:	6a 00                	push   $0x0
  801ce5:	6a 00                	push   $0x0
  801ce7:	6a 0a                	push   $0xa
  801ce9:	e8 e7 fe ff ff       	call   801bd5 <syscall>
  801cee:	83 c4 18             	add    $0x18,%esp
}
  801cf1:	c9                   	leave  
  801cf2:	c3                   	ret    

00801cf3 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801cf3:	55                   	push   %ebp
  801cf4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801cf6:	6a 00                	push   $0x0
  801cf8:	6a 00                	push   $0x0
  801cfa:	6a 00                	push   $0x0
  801cfc:	6a 00                	push   $0x0
  801cfe:	6a 00                	push   $0x0
  801d00:	6a 0b                	push   $0xb
  801d02:	e8 ce fe ff ff       	call   801bd5 <syscall>
  801d07:	83 c4 18             	add    $0x18,%esp
}
  801d0a:	c9                   	leave  
  801d0b:	c3                   	ret    

00801d0c <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801d0c:	55                   	push   %ebp
  801d0d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801d0f:	6a 00                	push   $0x0
  801d11:	6a 00                	push   $0x0
  801d13:	6a 00                	push   $0x0
  801d15:	ff 75 0c             	pushl  0xc(%ebp)
  801d18:	ff 75 08             	pushl  0x8(%ebp)
  801d1b:	6a 0f                	push   $0xf
  801d1d:	e8 b3 fe ff ff       	call   801bd5 <syscall>
  801d22:	83 c4 18             	add    $0x18,%esp
	return;
  801d25:	90                   	nop
}
  801d26:	c9                   	leave  
  801d27:	c3                   	ret    

00801d28 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801d28:	55                   	push   %ebp
  801d29:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801d2b:	6a 00                	push   $0x0
  801d2d:	6a 00                	push   $0x0
  801d2f:	6a 00                	push   $0x0
  801d31:	ff 75 0c             	pushl  0xc(%ebp)
  801d34:	ff 75 08             	pushl  0x8(%ebp)
  801d37:	6a 10                	push   $0x10
  801d39:	e8 97 fe ff ff       	call   801bd5 <syscall>
  801d3e:	83 c4 18             	add    $0x18,%esp
	return ;
  801d41:	90                   	nop
}
  801d42:	c9                   	leave  
  801d43:	c3                   	ret    

00801d44 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801d44:	55                   	push   %ebp
  801d45:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801d47:	6a 00                	push   $0x0
  801d49:	6a 00                	push   $0x0
  801d4b:	ff 75 10             	pushl  0x10(%ebp)
  801d4e:	ff 75 0c             	pushl  0xc(%ebp)
  801d51:	ff 75 08             	pushl  0x8(%ebp)
  801d54:	6a 11                	push   $0x11
  801d56:	e8 7a fe ff ff       	call   801bd5 <syscall>
  801d5b:	83 c4 18             	add    $0x18,%esp
	return ;
  801d5e:	90                   	nop
}
  801d5f:	c9                   	leave  
  801d60:	c3                   	ret    

00801d61 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801d61:	55                   	push   %ebp
  801d62:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801d64:	6a 00                	push   $0x0
  801d66:	6a 00                	push   $0x0
  801d68:	6a 00                	push   $0x0
  801d6a:	6a 00                	push   $0x0
  801d6c:	6a 00                	push   $0x0
  801d6e:	6a 0c                	push   $0xc
  801d70:	e8 60 fe ff ff       	call   801bd5 <syscall>
  801d75:	83 c4 18             	add    $0x18,%esp
}
  801d78:	c9                   	leave  
  801d79:	c3                   	ret    

00801d7a <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801d7a:	55                   	push   %ebp
  801d7b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801d7d:	6a 00                	push   $0x0
  801d7f:	6a 00                	push   $0x0
  801d81:	6a 00                	push   $0x0
  801d83:	6a 00                	push   $0x0
  801d85:	ff 75 08             	pushl  0x8(%ebp)
  801d88:	6a 0d                	push   $0xd
  801d8a:	e8 46 fe ff ff       	call   801bd5 <syscall>
  801d8f:	83 c4 18             	add    $0x18,%esp
}
  801d92:	c9                   	leave  
  801d93:	c3                   	ret    

00801d94 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801d94:	55                   	push   %ebp
  801d95:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801d97:	6a 00                	push   $0x0
  801d99:	6a 00                	push   $0x0
  801d9b:	6a 00                	push   $0x0
  801d9d:	6a 00                	push   $0x0
  801d9f:	6a 00                	push   $0x0
  801da1:	6a 0e                	push   $0xe
  801da3:	e8 2d fe ff ff       	call   801bd5 <syscall>
  801da8:	83 c4 18             	add    $0x18,%esp
}
  801dab:	90                   	nop
  801dac:	c9                   	leave  
  801dad:	c3                   	ret    

00801dae <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801dae:	55                   	push   %ebp
  801daf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801db1:	6a 00                	push   $0x0
  801db3:	6a 00                	push   $0x0
  801db5:	6a 00                	push   $0x0
  801db7:	6a 00                	push   $0x0
  801db9:	6a 00                	push   $0x0
  801dbb:	6a 13                	push   $0x13
  801dbd:	e8 13 fe ff ff       	call   801bd5 <syscall>
  801dc2:	83 c4 18             	add    $0x18,%esp
}
  801dc5:	90                   	nop
  801dc6:	c9                   	leave  
  801dc7:	c3                   	ret    

00801dc8 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801dc8:	55                   	push   %ebp
  801dc9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801dcb:	6a 00                	push   $0x0
  801dcd:	6a 00                	push   $0x0
  801dcf:	6a 00                	push   $0x0
  801dd1:	6a 00                	push   $0x0
  801dd3:	6a 00                	push   $0x0
  801dd5:	6a 14                	push   $0x14
  801dd7:	e8 f9 fd ff ff       	call   801bd5 <syscall>
  801ddc:	83 c4 18             	add    $0x18,%esp
}
  801ddf:	90                   	nop
  801de0:	c9                   	leave  
  801de1:	c3                   	ret    

00801de2 <sys_cputc>:


void
sys_cputc(const char c)
{
  801de2:	55                   	push   %ebp
  801de3:	89 e5                	mov    %esp,%ebp
  801de5:	83 ec 04             	sub    $0x4,%esp
  801de8:	8b 45 08             	mov    0x8(%ebp),%eax
  801deb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801dee:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801df2:	6a 00                	push   $0x0
  801df4:	6a 00                	push   $0x0
  801df6:	6a 00                	push   $0x0
  801df8:	6a 00                	push   $0x0
  801dfa:	50                   	push   %eax
  801dfb:	6a 15                	push   $0x15
  801dfd:	e8 d3 fd ff ff       	call   801bd5 <syscall>
  801e02:	83 c4 18             	add    $0x18,%esp
}
  801e05:	90                   	nop
  801e06:	c9                   	leave  
  801e07:	c3                   	ret    

00801e08 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801e08:	55                   	push   %ebp
  801e09:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801e0b:	6a 00                	push   $0x0
  801e0d:	6a 00                	push   $0x0
  801e0f:	6a 00                	push   $0x0
  801e11:	6a 00                	push   $0x0
  801e13:	6a 00                	push   $0x0
  801e15:	6a 16                	push   $0x16
  801e17:	e8 b9 fd ff ff       	call   801bd5 <syscall>
  801e1c:	83 c4 18             	add    $0x18,%esp
}
  801e1f:	90                   	nop
  801e20:	c9                   	leave  
  801e21:	c3                   	ret    

00801e22 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801e22:	55                   	push   %ebp
  801e23:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801e25:	8b 45 08             	mov    0x8(%ebp),%eax
  801e28:	6a 00                	push   $0x0
  801e2a:	6a 00                	push   $0x0
  801e2c:	6a 00                	push   $0x0
  801e2e:	ff 75 0c             	pushl  0xc(%ebp)
  801e31:	50                   	push   %eax
  801e32:	6a 17                	push   $0x17
  801e34:	e8 9c fd ff ff       	call   801bd5 <syscall>
  801e39:	83 c4 18             	add    $0x18,%esp
}
  801e3c:	c9                   	leave  
  801e3d:	c3                   	ret    

00801e3e <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801e3e:	55                   	push   %ebp
  801e3f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801e41:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e44:	8b 45 08             	mov    0x8(%ebp),%eax
  801e47:	6a 00                	push   $0x0
  801e49:	6a 00                	push   $0x0
  801e4b:	6a 00                	push   $0x0
  801e4d:	52                   	push   %edx
  801e4e:	50                   	push   %eax
  801e4f:	6a 1a                	push   $0x1a
  801e51:	e8 7f fd ff ff       	call   801bd5 <syscall>
  801e56:	83 c4 18             	add    $0x18,%esp
}
  801e59:	c9                   	leave  
  801e5a:	c3                   	ret    

00801e5b <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801e5b:	55                   	push   %ebp
  801e5c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801e5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e61:	8b 45 08             	mov    0x8(%ebp),%eax
  801e64:	6a 00                	push   $0x0
  801e66:	6a 00                	push   $0x0
  801e68:	6a 00                	push   $0x0
  801e6a:	52                   	push   %edx
  801e6b:	50                   	push   %eax
  801e6c:	6a 18                	push   $0x18
  801e6e:	e8 62 fd ff ff       	call   801bd5 <syscall>
  801e73:	83 c4 18             	add    $0x18,%esp
}
  801e76:	90                   	nop
  801e77:	c9                   	leave  
  801e78:	c3                   	ret    

00801e79 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801e79:	55                   	push   %ebp
  801e7a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801e7c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e82:	6a 00                	push   $0x0
  801e84:	6a 00                	push   $0x0
  801e86:	6a 00                	push   $0x0
  801e88:	52                   	push   %edx
  801e89:	50                   	push   %eax
  801e8a:	6a 19                	push   $0x19
  801e8c:	e8 44 fd ff ff       	call   801bd5 <syscall>
  801e91:	83 c4 18             	add    $0x18,%esp
}
  801e94:	90                   	nop
  801e95:	c9                   	leave  
  801e96:	c3                   	ret    

00801e97 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801e97:	55                   	push   %ebp
  801e98:	89 e5                	mov    %esp,%ebp
  801e9a:	83 ec 04             	sub    $0x4,%esp
  801e9d:	8b 45 10             	mov    0x10(%ebp),%eax
  801ea0:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801ea3:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ea6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801eaa:	8b 45 08             	mov    0x8(%ebp),%eax
  801ead:	6a 00                	push   $0x0
  801eaf:	51                   	push   %ecx
  801eb0:	52                   	push   %edx
  801eb1:	ff 75 0c             	pushl  0xc(%ebp)
  801eb4:	50                   	push   %eax
  801eb5:	6a 1b                	push   $0x1b
  801eb7:	e8 19 fd ff ff       	call   801bd5 <syscall>
  801ebc:	83 c4 18             	add    $0x18,%esp
}
  801ebf:	c9                   	leave  
  801ec0:	c3                   	ret    

00801ec1 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801ec1:	55                   	push   %ebp
  801ec2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801ec4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ec7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eca:	6a 00                	push   $0x0
  801ecc:	6a 00                	push   $0x0
  801ece:	6a 00                	push   $0x0
  801ed0:	52                   	push   %edx
  801ed1:	50                   	push   %eax
  801ed2:	6a 1c                	push   $0x1c
  801ed4:	e8 fc fc ff ff       	call   801bd5 <syscall>
  801ed9:	83 c4 18             	add    $0x18,%esp
}
  801edc:	c9                   	leave  
  801edd:	c3                   	ret    

00801ede <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801ede:	55                   	push   %ebp
  801edf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801ee1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ee4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ee7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eea:	6a 00                	push   $0x0
  801eec:	6a 00                	push   $0x0
  801eee:	51                   	push   %ecx
  801eef:	52                   	push   %edx
  801ef0:	50                   	push   %eax
  801ef1:	6a 1d                	push   $0x1d
  801ef3:	e8 dd fc ff ff       	call   801bd5 <syscall>
  801ef8:	83 c4 18             	add    $0x18,%esp
}
  801efb:	c9                   	leave  
  801efc:	c3                   	ret    

00801efd <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801efd:	55                   	push   %ebp
  801efe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801f00:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f03:	8b 45 08             	mov    0x8(%ebp),%eax
  801f06:	6a 00                	push   $0x0
  801f08:	6a 00                	push   $0x0
  801f0a:	6a 00                	push   $0x0
  801f0c:	52                   	push   %edx
  801f0d:	50                   	push   %eax
  801f0e:	6a 1e                	push   $0x1e
  801f10:	e8 c0 fc ff ff       	call   801bd5 <syscall>
  801f15:	83 c4 18             	add    $0x18,%esp
}
  801f18:	c9                   	leave  
  801f19:	c3                   	ret    

00801f1a <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801f1a:	55                   	push   %ebp
  801f1b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801f1d:	6a 00                	push   $0x0
  801f1f:	6a 00                	push   $0x0
  801f21:	6a 00                	push   $0x0
  801f23:	6a 00                	push   $0x0
  801f25:	6a 00                	push   $0x0
  801f27:	6a 1f                	push   $0x1f
  801f29:	e8 a7 fc ff ff       	call   801bd5 <syscall>
  801f2e:	83 c4 18             	add    $0x18,%esp
}
  801f31:	c9                   	leave  
  801f32:	c3                   	ret    

00801f33 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801f33:	55                   	push   %ebp
  801f34:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801f36:	8b 45 08             	mov    0x8(%ebp),%eax
  801f39:	6a 00                	push   $0x0
  801f3b:	ff 75 14             	pushl  0x14(%ebp)
  801f3e:	ff 75 10             	pushl  0x10(%ebp)
  801f41:	ff 75 0c             	pushl  0xc(%ebp)
  801f44:	50                   	push   %eax
  801f45:	6a 20                	push   $0x20
  801f47:	e8 89 fc ff ff       	call   801bd5 <syscall>
  801f4c:	83 c4 18             	add    $0x18,%esp
}
  801f4f:	c9                   	leave  
  801f50:	c3                   	ret    

00801f51 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801f51:	55                   	push   %ebp
  801f52:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801f54:	8b 45 08             	mov    0x8(%ebp),%eax
  801f57:	6a 00                	push   $0x0
  801f59:	6a 00                	push   $0x0
  801f5b:	6a 00                	push   $0x0
  801f5d:	6a 00                	push   $0x0
  801f5f:	50                   	push   %eax
  801f60:	6a 21                	push   $0x21
  801f62:	e8 6e fc ff ff       	call   801bd5 <syscall>
  801f67:	83 c4 18             	add    $0x18,%esp
}
  801f6a:	90                   	nop
  801f6b:	c9                   	leave  
  801f6c:	c3                   	ret    

00801f6d <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801f6d:	55                   	push   %ebp
  801f6e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801f70:	8b 45 08             	mov    0x8(%ebp),%eax
  801f73:	6a 00                	push   $0x0
  801f75:	6a 00                	push   $0x0
  801f77:	6a 00                	push   $0x0
  801f79:	6a 00                	push   $0x0
  801f7b:	50                   	push   %eax
  801f7c:	6a 22                	push   $0x22
  801f7e:	e8 52 fc ff ff       	call   801bd5 <syscall>
  801f83:	83 c4 18             	add    $0x18,%esp
}
  801f86:	c9                   	leave  
  801f87:	c3                   	ret    

00801f88 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801f88:	55                   	push   %ebp
  801f89:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801f8b:	6a 00                	push   $0x0
  801f8d:	6a 00                	push   $0x0
  801f8f:	6a 00                	push   $0x0
  801f91:	6a 00                	push   $0x0
  801f93:	6a 00                	push   $0x0
  801f95:	6a 02                	push   $0x2
  801f97:	e8 39 fc ff ff       	call   801bd5 <syscall>
  801f9c:	83 c4 18             	add    $0x18,%esp
}
  801f9f:	c9                   	leave  
  801fa0:	c3                   	ret    

00801fa1 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801fa1:	55                   	push   %ebp
  801fa2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801fa4:	6a 00                	push   $0x0
  801fa6:	6a 00                	push   $0x0
  801fa8:	6a 00                	push   $0x0
  801faa:	6a 00                	push   $0x0
  801fac:	6a 00                	push   $0x0
  801fae:	6a 03                	push   $0x3
  801fb0:	e8 20 fc ff ff       	call   801bd5 <syscall>
  801fb5:	83 c4 18             	add    $0x18,%esp
}
  801fb8:	c9                   	leave  
  801fb9:	c3                   	ret    

00801fba <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801fba:	55                   	push   %ebp
  801fbb:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801fbd:	6a 00                	push   $0x0
  801fbf:	6a 00                	push   $0x0
  801fc1:	6a 00                	push   $0x0
  801fc3:	6a 00                	push   $0x0
  801fc5:	6a 00                	push   $0x0
  801fc7:	6a 04                	push   $0x4
  801fc9:	e8 07 fc ff ff       	call   801bd5 <syscall>
  801fce:	83 c4 18             	add    $0x18,%esp
}
  801fd1:	c9                   	leave  
  801fd2:	c3                   	ret    

00801fd3 <sys_exit_env>:


void sys_exit_env(void)
{
  801fd3:	55                   	push   %ebp
  801fd4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801fd6:	6a 00                	push   $0x0
  801fd8:	6a 00                	push   $0x0
  801fda:	6a 00                	push   $0x0
  801fdc:	6a 00                	push   $0x0
  801fde:	6a 00                	push   $0x0
  801fe0:	6a 23                	push   $0x23
  801fe2:	e8 ee fb ff ff       	call   801bd5 <syscall>
  801fe7:	83 c4 18             	add    $0x18,%esp
}
  801fea:	90                   	nop
  801feb:	c9                   	leave  
  801fec:	c3                   	ret    

00801fed <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801fed:	55                   	push   %ebp
  801fee:	89 e5                	mov    %esp,%ebp
  801ff0:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801ff3:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ff6:	8d 50 04             	lea    0x4(%eax),%edx
  801ff9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ffc:	6a 00                	push   $0x0
  801ffe:	6a 00                	push   $0x0
  802000:	6a 00                	push   $0x0
  802002:	52                   	push   %edx
  802003:	50                   	push   %eax
  802004:	6a 24                	push   $0x24
  802006:	e8 ca fb ff ff       	call   801bd5 <syscall>
  80200b:	83 c4 18             	add    $0x18,%esp
	return result;
  80200e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802011:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802014:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802017:	89 01                	mov    %eax,(%ecx)
  802019:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80201c:	8b 45 08             	mov    0x8(%ebp),%eax
  80201f:	c9                   	leave  
  802020:	c2 04 00             	ret    $0x4

00802023 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802023:	55                   	push   %ebp
  802024:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802026:	6a 00                	push   $0x0
  802028:	6a 00                	push   $0x0
  80202a:	ff 75 10             	pushl  0x10(%ebp)
  80202d:	ff 75 0c             	pushl  0xc(%ebp)
  802030:	ff 75 08             	pushl  0x8(%ebp)
  802033:	6a 12                	push   $0x12
  802035:	e8 9b fb ff ff       	call   801bd5 <syscall>
  80203a:	83 c4 18             	add    $0x18,%esp
	return ;
  80203d:	90                   	nop
}
  80203e:	c9                   	leave  
  80203f:	c3                   	ret    

00802040 <sys_rcr2>:
uint32 sys_rcr2()
{
  802040:	55                   	push   %ebp
  802041:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802043:	6a 00                	push   $0x0
  802045:	6a 00                	push   $0x0
  802047:	6a 00                	push   $0x0
  802049:	6a 00                	push   $0x0
  80204b:	6a 00                	push   $0x0
  80204d:	6a 25                	push   $0x25
  80204f:	e8 81 fb ff ff       	call   801bd5 <syscall>
  802054:	83 c4 18             	add    $0x18,%esp
}
  802057:	c9                   	leave  
  802058:	c3                   	ret    

00802059 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802059:	55                   	push   %ebp
  80205a:	89 e5                	mov    %esp,%ebp
  80205c:	83 ec 04             	sub    $0x4,%esp
  80205f:	8b 45 08             	mov    0x8(%ebp),%eax
  802062:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802065:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802069:	6a 00                	push   $0x0
  80206b:	6a 00                	push   $0x0
  80206d:	6a 00                	push   $0x0
  80206f:	6a 00                	push   $0x0
  802071:	50                   	push   %eax
  802072:	6a 26                	push   $0x26
  802074:	e8 5c fb ff ff       	call   801bd5 <syscall>
  802079:	83 c4 18             	add    $0x18,%esp
	return ;
  80207c:	90                   	nop
}
  80207d:	c9                   	leave  
  80207e:	c3                   	ret    

0080207f <rsttst>:
void rsttst()
{
  80207f:	55                   	push   %ebp
  802080:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802082:	6a 00                	push   $0x0
  802084:	6a 00                	push   $0x0
  802086:	6a 00                	push   $0x0
  802088:	6a 00                	push   $0x0
  80208a:	6a 00                	push   $0x0
  80208c:	6a 28                	push   $0x28
  80208e:	e8 42 fb ff ff       	call   801bd5 <syscall>
  802093:	83 c4 18             	add    $0x18,%esp
	return ;
  802096:	90                   	nop
}
  802097:	c9                   	leave  
  802098:	c3                   	ret    

00802099 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802099:	55                   	push   %ebp
  80209a:	89 e5                	mov    %esp,%ebp
  80209c:	83 ec 04             	sub    $0x4,%esp
  80209f:	8b 45 14             	mov    0x14(%ebp),%eax
  8020a2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8020a5:	8b 55 18             	mov    0x18(%ebp),%edx
  8020a8:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8020ac:	52                   	push   %edx
  8020ad:	50                   	push   %eax
  8020ae:	ff 75 10             	pushl  0x10(%ebp)
  8020b1:	ff 75 0c             	pushl  0xc(%ebp)
  8020b4:	ff 75 08             	pushl  0x8(%ebp)
  8020b7:	6a 27                	push   $0x27
  8020b9:	e8 17 fb ff ff       	call   801bd5 <syscall>
  8020be:	83 c4 18             	add    $0x18,%esp
	return ;
  8020c1:	90                   	nop
}
  8020c2:	c9                   	leave  
  8020c3:	c3                   	ret    

008020c4 <chktst>:
void chktst(uint32 n)
{
  8020c4:	55                   	push   %ebp
  8020c5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8020c7:	6a 00                	push   $0x0
  8020c9:	6a 00                	push   $0x0
  8020cb:	6a 00                	push   $0x0
  8020cd:	6a 00                	push   $0x0
  8020cf:	ff 75 08             	pushl  0x8(%ebp)
  8020d2:	6a 29                	push   $0x29
  8020d4:	e8 fc fa ff ff       	call   801bd5 <syscall>
  8020d9:	83 c4 18             	add    $0x18,%esp
	return ;
  8020dc:	90                   	nop
}
  8020dd:	c9                   	leave  
  8020de:	c3                   	ret    

008020df <inctst>:

void inctst()
{
  8020df:	55                   	push   %ebp
  8020e0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8020e2:	6a 00                	push   $0x0
  8020e4:	6a 00                	push   $0x0
  8020e6:	6a 00                	push   $0x0
  8020e8:	6a 00                	push   $0x0
  8020ea:	6a 00                	push   $0x0
  8020ec:	6a 2a                	push   $0x2a
  8020ee:	e8 e2 fa ff ff       	call   801bd5 <syscall>
  8020f3:	83 c4 18             	add    $0x18,%esp
	return ;
  8020f6:	90                   	nop
}
  8020f7:	c9                   	leave  
  8020f8:	c3                   	ret    

008020f9 <gettst>:
uint32 gettst()
{
  8020f9:	55                   	push   %ebp
  8020fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8020fc:	6a 00                	push   $0x0
  8020fe:	6a 00                	push   $0x0
  802100:	6a 00                	push   $0x0
  802102:	6a 00                	push   $0x0
  802104:	6a 00                	push   $0x0
  802106:	6a 2b                	push   $0x2b
  802108:	e8 c8 fa ff ff       	call   801bd5 <syscall>
  80210d:	83 c4 18             	add    $0x18,%esp
}
  802110:	c9                   	leave  
  802111:	c3                   	ret    

00802112 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802112:	55                   	push   %ebp
  802113:	89 e5                	mov    %esp,%ebp
  802115:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802118:	6a 00                	push   $0x0
  80211a:	6a 00                	push   $0x0
  80211c:	6a 00                	push   $0x0
  80211e:	6a 00                	push   $0x0
  802120:	6a 00                	push   $0x0
  802122:	6a 2c                	push   $0x2c
  802124:	e8 ac fa ff ff       	call   801bd5 <syscall>
  802129:	83 c4 18             	add    $0x18,%esp
  80212c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80212f:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802133:	75 07                	jne    80213c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802135:	b8 01 00 00 00       	mov    $0x1,%eax
  80213a:	eb 05                	jmp    802141 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80213c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802141:	c9                   	leave  
  802142:	c3                   	ret    

00802143 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802143:	55                   	push   %ebp
  802144:	89 e5                	mov    %esp,%ebp
  802146:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802149:	6a 00                	push   $0x0
  80214b:	6a 00                	push   $0x0
  80214d:	6a 00                	push   $0x0
  80214f:	6a 00                	push   $0x0
  802151:	6a 00                	push   $0x0
  802153:	6a 2c                	push   $0x2c
  802155:	e8 7b fa ff ff       	call   801bd5 <syscall>
  80215a:	83 c4 18             	add    $0x18,%esp
  80215d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802160:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802164:	75 07                	jne    80216d <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802166:	b8 01 00 00 00       	mov    $0x1,%eax
  80216b:	eb 05                	jmp    802172 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80216d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802172:	c9                   	leave  
  802173:	c3                   	ret    

00802174 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802174:	55                   	push   %ebp
  802175:	89 e5                	mov    %esp,%ebp
  802177:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80217a:	6a 00                	push   $0x0
  80217c:	6a 00                	push   $0x0
  80217e:	6a 00                	push   $0x0
  802180:	6a 00                	push   $0x0
  802182:	6a 00                	push   $0x0
  802184:	6a 2c                	push   $0x2c
  802186:	e8 4a fa ff ff       	call   801bd5 <syscall>
  80218b:	83 c4 18             	add    $0x18,%esp
  80218e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802191:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802195:	75 07                	jne    80219e <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802197:	b8 01 00 00 00       	mov    $0x1,%eax
  80219c:	eb 05                	jmp    8021a3 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80219e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021a3:	c9                   	leave  
  8021a4:	c3                   	ret    

008021a5 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8021a5:	55                   	push   %ebp
  8021a6:	89 e5                	mov    %esp,%ebp
  8021a8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021ab:	6a 00                	push   $0x0
  8021ad:	6a 00                	push   $0x0
  8021af:	6a 00                	push   $0x0
  8021b1:	6a 00                	push   $0x0
  8021b3:	6a 00                	push   $0x0
  8021b5:	6a 2c                	push   $0x2c
  8021b7:	e8 19 fa ff ff       	call   801bd5 <syscall>
  8021bc:	83 c4 18             	add    $0x18,%esp
  8021bf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8021c2:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8021c6:	75 07                	jne    8021cf <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8021c8:	b8 01 00 00 00       	mov    $0x1,%eax
  8021cd:	eb 05                	jmp    8021d4 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8021cf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021d4:	c9                   	leave  
  8021d5:	c3                   	ret    

008021d6 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8021d6:	55                   	push   %ebp
  8021d7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8021d9:	6a 00                	push   $0x0
  8021db:	6a 00                	push   $0x0
  8021dd:	6a 00                	push   $0x0
  8021df:	6a 00                	push   $0x0
  8021e1:	ff 75 08             	pushl  0x8(%ebp)
  8021e4:	6a 2d                	push   $0x2d
  8021e6:	e8 ea f9 ff ff       	call   801bd5 <syscall>
  8021eb:	83 c4 18             	add    $0x18,%esp
	return ;
  8021ee:	90                   	nop
}
  8021ef:	c9                   	leave  
  8021f0:	c3                   	ret    

008021f1 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8021f1:	55                   	push   %ebp
  8021f2:	89 e5                	mov    %esp,%ebp
  8021f4:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8021f5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8021f8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802201:	6a 00                	push   $0x0
  802203:	53                   	push   %ebx
  802204:	51                   	push   %ecx
  802205:	52                   	push   %edx
  802206:	50                   	push   %eax
  802207:	6a 2e                	push   $0x2e
  802209:	e8 c7 f9 ff ff       	call   801bd5 <syscall>
  80220e:	83 c4 18             	add    $0x18,%esp
}
  802211:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802214:	c9                   	leave  
  802215:	c3                   	ret    

00802216 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802216:	55                   	push   %ebp
  802217:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802219:	8b 55 0c             	mov    0xc(%ebp),%edx
  80221c:	8b 45 08             	mov    0x8(%ebp),%eax
  80221f:	6a 00                	push   $0x0
  802221:	6a 00                	push   $0x0
  802223:	6a 00                	push   $0x0
  802225:	52                   	push   %edx
  802226:	50                   	push   %eax
  802227:	6a 2f                	push   $0x2f
  802229:	e8 a7 f9 ff ff       	call   801bd5 <syscall>
  80222e:	83 c4 18             	add    $0x18,%esp
}
  802231:	c9                   	leave  
  802232:	c3                   	ret    

00802233 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802233:	55                   	push   %ebp
  802234:	89 e5                	mov    %esp,%ebp
  802236:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802239:	83 ec 0c             	sub    $0xc,%esp
  80223c:	68 84 43 80 00       	push   $0x804384
  802241:	e8 8c e7 ff ff       	call   8009d2 <cprintf>
  802246:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802249:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802250:	83 ec 0c             	sub    $0xc,%esp
  802253:	68 b0 43 80 00       	push   $0x8043b0
  802258:	e8 75 e7 ff ff       	call   8009d2 <cprintf>
  80225d:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802260:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802264:	a1 38 51 80 00       	mov    0x805138,%eax
  802269:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80226c:	eb 56                	jmp    8022c4 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80226e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802272:	74 1c                	je     802290 <print_mem_block_lists+0x5d>
  802274:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802277:	8b 50 08             	mov    0x8(%eax),%edx
  80227a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80227d:	8b 48 08             	mov    0x8(%eax),%ecx
  802280:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802283:	8b 40 0c             	mov    0xc(%eax),%eax
  802286:	01 c8                	add    %ecx,%eax
  802288:	39 c2                	cmp    %eax,%edx
  80228a:	73 04                	jae    802290 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  80228c:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802290:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802293:	8b 50 08             	mov    0x8(%eax),%edx
  802296:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802299:	8b 40 0c             	mov    0xc(%eax),%eax
  80229c:	01 c2                	add    %eax,%edx
  80229e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a1:	8b 40 08             	mov    0x8(%eax),%eax
  8022a4:	83 ec 04             	sub    $0x4,%esp
  8022a7:	52                   	push   %edx
  8022a8:	50                   	push   %eax
  8022a9:	68 c5 43 80 00       	push   $0x8043c5
  8022ae:	e8 1f e7 ff ff       	call   8009d2 <cprintf>
  8022b3:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8022b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8022bc:	a1 40 51 80 00       	mov    0x805140,%eax
  8022c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022c8:	74 07                	je     8022d1 <print_mem_block_lists+0x9e>
  8022ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022cd:	8b 00                	mov    (%eax),%eax
  8022cf:	eb 05                	jmp    8022d6 <print_mem_block_lists+0xa3>
  8022d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8022d6:	a3 40 51 80 00       	mov    %eax,0x805140
  8022db:	a1 40 51 80 00       	mov    0x805140,%eax
  8022e0:	85 c0                	test   %eax,%eax
  8022e2:	75 8a                	jne    80226e <print_mem_block_lists+0x3b>
  8022e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022e8:	75 84                	jne    80226e <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8022ea:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8022ee:	75 10                	jne    802300 <print_mem_block_lists+0xcd>
  8022f0:	83 ec 0c             	sub    $0xc,%esp
  8022f3:	68 d4 43 80 00       	push   $0x8043d4
  8022f8:	e8 d5 e6 ff ff       	call   8009d2 <cprintf>
  8022fd:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802300:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802307:	83 ec 0c             	sub    $0xc,%esp
  80230a:	68 f8 43 80 00       	push   $0x8043f8
  80230f:	e8 be e6 ff ff       	call   8009d2 <cprintf>
  802314:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802317:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80231b:	a1 40 50 80 00       	mov    0x805040,%eax
  802320:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802323:	eb 56                	jmp    80237b <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802325:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802329:	74 1c                	je     802347 <print_mem_block_lists+0x114>
  80232b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232e:	8b 50 08             	mov    0x8(%eax),%edx
  802331:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802334:	8b 48 08             	mov    0x8(%eax),%ecx
  802337:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80233a:	8b 40 0c             	mov    0xc(%eax),%eax
  80233d:	01 c8                	add    %ecx,%eax
  80233f:	39 c2                	cmp    %eax,%edx
  802341:	73 04                	jae    802347 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802343:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802347:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234a:	8b 50 08             	mov    0x8(%eax),%edx
  80234d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802350:	8b 40 0c             	mov    0xc(%eax),%eax
  802353:	01 c2                	add    %eax,%edx
  802355:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802358:	8b 40 08             	mov    0x8(%eax),%eax
  80235b:	83 ec 04             	sub    $0x4,%esp
  80235e:	52                   	push   %edx
  80235f:	50                   	push   %eax
  802360:	68 c5 43 80 00       	push   $0x8043c5
  802365:	e8 68 e6 ff ff       	call   8009d2 <cprintf>
  80236a:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80236d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802370:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802373:	a1 48 50 80 00       	mov    0x805048,%eax
  802378:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80237b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80237f:	74 07                	je     802388 <print_mem_block_lists+0x155>
  802381:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802384:	8b 00                	mov    (%eax),%eax
  802386:	eb 05                	jmp    80238d <print_mem_block_lists+0x15a>
  802388:	b8 00 00 00 00       	mov    $0x0,%eax
  80238d:	a3 48 50 80 00       	mov    %eax,0x805048
  802392:	a1 48 50 80 00       	mov    0x805048,%eax
  802397:	85 c0                	test   %eax,%eax
  802399:	75 8a                	jne    802325 <print_mem_block_lists+0xf2>
  80239b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80239f:	75 84                	jne    802325 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8023a1:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8023a5:	75 10                	jne    8023b7 <print_mem_block_lists+0x184>
  8023a7:	83 ec 0c             	sub    $0xc,%esp
  8023aa:	68 10 44 80 00       	push   $0x804410
  8023af:	e8 1e e6 ff ff       	call   8009d2 <cprintf>
  8023b4:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8023b7:	83 ec 0c             	sub    $0xc,%esp
  8023ba:	68 84 43 80 00       	push   $0x804384
  8023bf:	e8 0e e6 ff ff       	call   8009d2 <cprintf>
  8023c4:	83 c4 10             	add    $0x10,%esp

}
  8023c7:	90                   	nop
  8023c8:	c9                   	leave  
  8023c9:	c3                   	ret    

008023ca <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8023ca:	55                   	push   %ebp
  8023cb:	89 e5                	mov    %esp,%ebp
  8023cd:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  8023d0:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8023d7:	00 00 00 
  8023da:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8023e1:	00 00 00 
  8023e4:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8023eb:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  8023ee:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8023f5:	e9 9e 00 00 00       	jmp    802498 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  8023fa:	a1 50 50 80 00       	mov    0x805050,%eax
  8023ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802402:	c1 e2 04             	shl    $0x4,%edx
  802405:	01 d0                	add    %edx,%eax
  802407:	85 c0                	test   %eax,%eax
  802409:	75 14                	jne    80241f <initialize_MemBlocksList+0x55>
  80240b:	83 ec 04             	sub    $0x4,%esp
  80240e:	68 38 44 80 00       	push   $0x804438
  802413:	6a 46                	push   $0x46
  802415:	68 5b 44 80 00       	push   $0x80445b
  80241a:	e8 ff e2 ff ff       	call   80071e <_panic>
  80241f:	a1 50 50 80 00       	mov    0x805050,%eax
  802424:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802427:	c1 e2 04             	shl    $0x4,%edx
  80242a:	01 d0                	add    %edx,%eax
  80242c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802432:	89 10                	mov    %edx,(%eax)
  802434:	8b 00                	mov    (%eax),%eax
  802436:	85 c0                	test   %eax,%eax
  802438:	74 18                	je     802452 <initialize_MemBlocksList+0x88>
  80243a:	a1 48 51 80 00       	mov    0x805148,%eax
  80243f:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802445:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802448:	c1 e1 04             	shl    $0x4,%ecx
  80244b:	01 ca                	add    %ecx,%edx
  80244d:	89 50 04             	mov    %edx,0x4(%eax)
  802450:	eb 12                	jmp    802464 <initialize_MemBlocksList+0x9a>
  802452:	a1 50 50 80 00       	mov    0x805050,%eax
  802457:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80245a:	c1 e2 04             	shl    $0x4,%edx
  80245d:	01 d0                	add    %edx,%eax
  80245f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802464:	a1 50 50 80 00       	mov    0x805050,%eax
  802469:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80246c:	c1 e2 04             	shl    $0x4,%edx
  80246f:	01 d0                	add    %edx,%eax
  802471:	a3 48 51 80 00       	mov    %eax,0x805148
  802476:	a1 50 50 80 00       	mov    0x805050,%eax
  80247b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80247e:	c1 e2 04             	shl    $0x4,%edx
  802481:	01 d0                	add    %edx,%eax
  802483:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80248a:	a1 54 51 80 00       	mov    0x805154,%eax
  80248f:	40                   	inc    %eax
  802490:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802495:	ff 45 f4             	incl   -0xc(%ebp)
  802498:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80249e:	0f 82 56 ff ff ff    	jb     8023fa <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  8024a4:	90                   	nop
  8024a5:	c9                   	leave  
  8024a6:	c3                   	ret    

008024a7 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8024a7:	55                   	push   %ebp
  8024a8:	89 e5                	mov    %esp,%ebp
  8024aa:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8024ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b0:	8b 00                	mov    (%eax),%eax
  8024b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8024b5:	eb 19                	jmp    8024d0 <find_block+0x29>
	{
		if(va==point->sva)
  8024b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8024ba:	8b 40 08             	mov    0x8(%eax),%eax
  8024bd:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8024c0:	75 05                	jne    8024c7 <find_block+0x20>
		   return point;
  8024c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8024c5:	eb 36                	jmp    8024fd <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8024c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ca:	8b 40 08             	mov    0x8(%eax),%eax
  8024cd:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8024d0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8024d4:	74 07                	je     8024dd <find_block+0x36>
  8024d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8024d9:	8b 00                	mov    (%eax),%eax
  8024db:	eb 05                	jmp    8024e2 <find_block+0x3b>
  8024dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8024e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8024e5:	89 42 08             	mov    %eax,0x8(%edx)
  8024e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8024eb:	8b 40 08             	mov    0x8(%eax),%eax
  8024ee:	85 c0                	test   %eax,%eax
  8024f0:	75 c5                	jne    8024b7 <find_block+0x10>
  8024f2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8024f6:	75 bf                	jne    8024b7 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  8024f8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024fd:	c9                   	leave  
  8024fe:	c3                   	ret    

008024ff <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8024ff:	55                   	push   %ebp
  802500:	89 e5                	mov    %esp,%ebp
  802502:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802505:	a1 40 50 80 00       	mov    0x805040,%eax
  80250a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  80250d:	a1 44 50 80 00       	mov    0x805044,%eax
  802512:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802515:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802518:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80251b:	74 24                	je     802541 <insert_sorted_allocList+0x42>
  80251d:	8b 45 08             	mov    0x8(%ebp),%eax
  802520:	8b 50 08             	mov    0x8(%eax),%edx
  802523:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802526:	8b 40 08             	mov    0x8(%eax),%eax
  802529:	39 c2                	cmp    %eax,%edx
  80252b:	76 14                	jbe    802541 <insert_sorted_allocList+0x42>
  80252d:	8b 45 08             	mov    0x8(%ebp),%eax
  802530:	8b 50 08             	mov    0x8(%eax),%edx
  802533:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802536:	8b 40 08             	mov    0x8(%eax),%eax
  802539:	39 c2                	cmp    %eax,%edx
  80253b:	0f 82 60 01 00 00    	jb     8026a1 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802541:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802545:	75 65                	jne    8025ac <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802547:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80254b:	75 14                	jne    802561 <insert_sorted_allocList+0x62>
  80254d:	83 ec 04             	sub    $0x4,%esp
  802550:	68 38 44 80 00       	push   $0x804438
  802555:	6a 6b                	push   $0x6b
  802557:	68 5b 44 80 00       	push   $0x80445b
  80255c:	e8 bd e1 ff ff       	call   80071e <_panic>
  802561:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802567:	8b 45 08             	mov    0x8(%ebp),%eax
  80256a:	89 10                	mov    %edx,(%eax)
  80256c:	8b 45 08             	mov    0x8(%ebp),%eax
  80256f:	8b 00                	mov    (%eax),%eax
  802571:	85 c0                	test   %eax,%eax
  802573:	74 0d                	je     802582 <insert_sorted_allocList+0x83>
  802575:	a1 40 50 80 00       	mov    0x805040,%eax
  80257a:	8b 55 08             	mov    0x8(%ebp),%edx
  80257d:	89 50 04             	mov    %edx,0x4(%eax)
  802580:	eb 08                	jmp    80258a <insert_sorted_allocList+0x8b>
  802582:	8b 45 08             	mov    0x8(%ebp),%eax
  802585:	a3 44 50 80 00       	mov    %eax,0x805044
  80258a:	8b 45 08             	mov    0x8(%ebp),%eax
  80258d:	a3 40 50 80 00       	mov    %eax,0x805040
  802592:	8b 45 08             	mov    0x8(%ebp),%eax
  802595:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80259c:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8025a1:	40                   	inc    %eax
  8025a2:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8025a7:	e9 dc 01 00 00       	jmp    802788 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8025ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8025af:	8b 50 08             	mov    0x8(%eax),%edx
  8025b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025b5:	8b 40 08             	mov    0x8(%eax),%eax
  8025b8:	39 c2                	cmp    %eax,%edx
  8025ba:	77 6c                	ja     802628 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8025bc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025c0:	74 06                	je     8025c8 <insert_sorted_allocList+0xc9>
  8025c2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8025c6:	75 14                	jne    8025dc <insert_sorted_allocList+0xdd>
  8025c8:	83 ec 04             	sub    $0x4,%esp
  8025cb:	68 74 44 80 00       	push   $0x804474
  8025d0:	6a 6f                	push   $0x6f
  8025d2:	68 5b 44 80 00       	push   $0x80445b
  8025d7:	e8 42 e1 ff ff       	call   80071e <_panic>
  8025dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025df:	8b 50 04             	mov    0x4(%eax),%edx
  8025e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e5:	89 50 04             	mov    %edx,0x4(%eax)
  8025e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8025eb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025ee:	89 10                	mov    %edx,(%eax)
  8025f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025f3:	8b 40 04             	mov    0x4(%eax),%eax
  8025f6:	85 c0                	test   %eax,%eax
  8025f8:	74 0d                	je     802607 <insert_sorted_allocList+0x108>
  8025fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025fd:	8b 40 04             	mov    0x4(%eax),%eax
  802600:	8b 55 08             	mov    0x8(%ebp),%edx
  802603:	89 10                	mov    %edx,(%eax)
  802605:	eb 08                	jmp    80260f <insert_sorted_allocList+0x110>
  802607:	8b 45 08             	mov    0x8(%ebp),%eax
  80260a:	a3 40 50 80 00       	mov    %eax,0x805040
  80260f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802612:	8b 55 08             	mov    0x8(%ebp),%edx
  802615:	89 50 04             	mov    %edx,0x4(%eax)
  802618:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80261d:	40                   	inc    %eax
  80261e:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802623:	e9 60 01 00 00       	jmp    802788 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802628:	8b 45 08             	mov    0x8(%ebp),%eax
  80262b:	8b 50 08             	mov    0x8(%eax),%edx
  80262e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802631:	8b 40 08             	mov    0x8(%eax),%eax
  802634:	39 c2                	cmp    %eax,%edx
  802636:	0f 82 4c 01 00 00    	jb     802788 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  80263c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802640:	75 14                	jne    802656 <insert_sorted_allocList+0x157>
  802642:	83 ec 04             	sub    $0x4,%esp
  802645:	68 ac 44 80 00       	push   $0x8044ac
  80264a:	6a 73                	push   $0x73
  80264c:	68 5b 44 80 00       	push   $0x80445b
  802651:	e8 c8 e0 ff ff       	call   80071e <_panic>
  802656:	8b 15 44 50 80 00    	mov    0x805044,%edx
  80265c:	8b 45 08             	mov    0x8(%ebp),%eax
  80265f:	89 50 04             	mov    %edx,0x4(%eax)
  802662:	8b 45 08             	mov    0x8(%ebp),%eax
  802665:	8b 40 04             	mov    0x4(%eax),%eax
  802668:	85 c0                	test   %eax,%eax
  80266a:	74 0c                	je     802678 <insert_sorted_allocList+0x179>
  80266c:	a1 44 50 80 00       	mov    0x805044,%eax
  802671:	8b 55 08             	mov    0x8(%ebp),%edx
  802674:	89 10                	mov    %edx,(%eax)
  802676:	eb 08                	jmp    802680 <insert_sorted_allocList+0x181>
  802678:	8b 45 08             	mov    0x8(%ebp),%eax
  80267b:	a3 40 50 80 00       	mov    %eax,0x805040
  802680:	8b 45 08             	mov    0x8(%ebp),%eax
  802683:	a3 44 50 80 00       	mov    %eax,0x805044
  802688:	8b 45 08             	mov    0x8(%ebp),%eax
  80268b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802691:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802696:	40                   	inc    %eax
  802697:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80269c:	e9 e7 00 00 00       	jmp    802788 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8026a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8026a7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8026ae:	a1 40 50 80 00       	mov    0x805040,%eax
  8026b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026b6:	e9 9d 00 00 00       	jmp    802758 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8026bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026be:	8b 00                	mov    (%eax),%eax
  8026c0:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8026c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c6:	8b 50 08             	mov    0x8(%eax),%edx
  8026c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cc:	8b 40 08             	mov    0x8(%eax),%eax
  8026cf:	39 c2                	cmp    %eax,%edx
  8026d1:	76 7d                	jbe    802750 <insert_sorted_allocList+0x251>
  8026d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d6:	8b 50 08             	mov    0x8(%eax),%edx
  8026d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026dc:	8b 40 08             	mov    0x8(%eax),%eax
  8026df:	39 c2                	cmp    %eax,%edx
  8026e1:	73 6d                	jae    802750 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8026e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026e7:	74 06                	je     8026ef <insert_sorted_allocList+0x1f0>
  8026e9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8026ed:	75 14                	jne    802703 <insert_sorted_allocList+0x204>
  8026ef:	83 ec 04             	sub    $0x4,%esp
  8026f2:	68 d0 44 80 00       	push   $0x8044d0
  8026f7:	6a 7f                	push   $0x7f
  8026f9:	68 5b 44 80 00       	push   $0x80445b
  8026fe:	e8 1b e0 ff ff       	call   80071e <_panic>
  802703:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802706:	8b 10                	mov    (%eax),%edx
  802708:	8b 45 08             	mov    0x8(%ebp),%eax
  80270b:	89 10                	mov    %edx,(%eax)
  80270d:	8b 45 08             	mov    0x8(%ebp),%eax
  802710:	8b 00                	mov    (%eax),%eax
  802712:	85 c0                	test   %eax,%eax
  802714:	74 0b                	je     802721 <insert_sorted_allocList+0x222>
  802716:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802719:	8b 00                	mov    (%eax),%eax
  80271b:	8b 55 08             	mov    0x8(%ebp),%edx
  80271e:	89 50 04             	mov    %edx,0x4(%eax)
  802721:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802724:	8b 55 08             	mov    0x8(%ebp),%edx
  802727:	89 10                	mov    %edx,(%eax)
  802729:	8b 45 08             	mov    0x8(%ebp),%eax
  80272c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80272f:	89 50 04             	mov    %edx,0x4(%eax)
  802732:	8b 45 08             	mov    0x8(%ebp),%eax
  802735:	8b 00                	mov    (%eax),%eax
  802737:	85 c0                	test   %eax,%eax
  802739:	75 08                	jne    802743 <insert_sorted_allocList+0x244>
  80273b:	8b 45 08             	mov    0x8(%ebp),%eax
  80273e:	a3 44 50 80 00       	mov    %eax,0x805044
  802743:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802748:	40                   	inc    %eax
  802749:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  80274e:	eb 39                	jmp    802789 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802750:	a1 48 50 80 00       	mov    0x805048,%eax
  802755:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802758:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80275c:	74 07                	je     802765 <insert_sorted_allocList+0x266>
  80275e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802761:	8b 00                	mov    (%eax),%eax
  802763:	eb 05                	jmp    80276a <insert_sorted_allocList+0x26b>
  802765:	b8 00 00 00 00       	mov    $0x0,%eax
  80276a:	a3 48 50 80 00       	mov    %eax,0x805048
  80276f:	a1 48 50 80 00       	mov    0x805048,%eax
  802774:	85 c0                	test   %eax,%eax
  802776:	0f 85 3f ff ff ff    	jne    8026bb <insert_sorted_allocList+0x1bc>
  80277c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802780:	0f 85 35 ff ff ff    	jne    8026bb <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802786:	eb 01                	jmp    802789 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802788:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802789:	90                   	nop
  80278a:	c9                   	leave  
  80278b:	c3                   	ret    

0080278c <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80278c:	55                   	push   %ebp
  80278d:	89 e5                	mov    %esp,%ebp
  80278f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802792:	a1 38 51 80 00       	mov    0x805138,%eax
  802797:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80279a:	e9 85 01 00 00       	jmp    802924 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  80279f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a2:	8b 40 0c             	mov    0xc(%eax),%eax
  8027a5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027a8:	0f 82 6e 01 00 00    	jb     80291c <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8027ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b1:	8b 40 0c             	mov    0xc(%eax),%eax
  8027b4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027b7:	0f 85 8a 00 00 00    	jne    802847 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8027bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027c1:	75 17                	jne    8027da <alloc_block_FF+0x4e>
  8027c3:	83 ec 04             	sub    $0x4,%esp
  8027c6:	68 04 45 80 00       	push   $0x804504
  8027cb:	68 93 00 00 00       	push   $0x93
  8027d0:	68 5b 44 80 00       	push   $0x80445b
  8027d5:	e8 44 df ff ff       	call   80071e <_panic>
  8027da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027dd:	8b 00                	mov    (%eax),%eax
  8027df:	85 c0                	test   %eax,%eax
  8027e1:	74 10                	je     8027f3 <alloc_block_FF+0x67>
  8027e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e6:	8b 00                	mov    (%eax),%eax
  8027e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027eb:	8b 52 04             	mov    0x4(%edx),%edx
  8027ee:	89 50 04             	mov    %edx,0x4(%eax)
  8027f1:	eb 0b                	jmp    8027fe <alloc_block_FF+0x72>
  8027f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f6:	8b 40 04             	mov    0x4(%eax),%eax
  8027f9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8027fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802801:	8b 40 04             	mov    0x4(%eax),%eax
  802804:	85 c0                	test   %eax,%eax
  802806:	74 0f                	je     802817 <alloc_block_FF+0x8b>
  802808:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280b:	8b 40 04             	mov    0x4(%eax),%eax
  80280e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802811:	8b 12                	mov    (%edx),%edx
  802813:	89 10                	mov    %edx,(%eax)
  802815:	eb 0a                	jmp    802821 <alloc_block_FF+0x95>
  802817:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281a:	8b 00                	mov    (%eax),%eax
  80281c:	a3 38 51 80 00       	mov    %eax,0x805138
  802821:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802824:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80282a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802834:	a1 44 51 80 00       	mov    0x805144,%eax
  802839:	48                   	dec    %eax
  80283a:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  80283f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802842:	e9 10 01 00 00       	jmp    802957 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802847:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284a:	8b 40 0c             	mov    0xc(%eax),%eax
  80284d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802850:	0f 86 c6 00 00 00    	jbe    80291c <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802856:	a1 48 51 80 00       	mov    0x805148,%eax
  80285b:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  80285e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802861:	8b 50 08             	mov    0x8(%eax),%edx
  802864:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802867:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  80286a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80286d:	8b 55 08             	mov    0x8(%ebp),%edx
  802870:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802873:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802877:	75 17                	jne    802890 <alloc_block_FF+0x104>
  802879:	83 ec 04             	sub    $0x4,%esp
  80287c:	68 04 45 80 00       	push   $0x804504
  802881:	68 9b 00 00 00       	push   $0x9b
  802886:	68 5b 44 80 00       	push   $0x80445b
  80288b:	e8 8e de ff ff       	call   80071e <_panic>
  802890:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802893:	8b 00                	mov    (%eax),%eax
  802895:	85 c0                	test   %eax,%eax
  802897:	74 10                	je     8028a9 <alloc_block_FF+0x11d>
  802899:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80289c:	8b 00                	mov    (%eax),%eax
  80289e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028a1:	8b 52 04             	mov    0x4(%edx),%edx
  8028a4:	89 50 04             	mov    %edx,0x4(%eax)
  8028a7:	eb 0b                	jmp    8028b4 <alloc_block_FF+0x128>
  8028a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ac:	8b 40 04             	mov    0x4(%eax),%eax
  8028af:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8028b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028b7:	8b 40 04             	mov    0x4(%eax),%eax
  8028ba:	85 c0                	test   %eax,%eax
  8028bc:	74 0f                	je     8028cd <alloc_block_FF+0x141>
  8028be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028c1:	8b 40 04             	mov    0x4(%eax),%eax
  8028c4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028c7:	8b 12                	mov    (%edx),%edx
  8028c9:	89 10                	mov    %edx,(%eax)
  8028cb:	eb 0a                	jmp    8028d7 <alloc_block_FF+0x14b>
  8028cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028d0:	8b 00                	mov    (%eax),%eax
  8028d2:	a3 48 51 80 00       	mov    %eax,0x805148
  8028d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028da:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028ea:	a1 54 51 80 00       	mov    0x805154,%eax
  8028ef:	48                   	dec    %eax
  8028f0:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  8028f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f8:	8b 50 08             	mov    0x8(%eax),%edx
  8028fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8028fe:	01 c2                	add    %eax,%edx
  802900:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802903:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802906:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802909:	8b 40 0c             	mov    0xc(%eax),%eax
  80290c:	2b 45 08             	sub    0x8(%ebp),%eax
  80290f:	89 c2                	mov    %eax,%edx
  802911:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802914:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802917:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80291a:	eb 3b                	jmp    802957 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80291c:	a1 40 51 80 00       	mov    0x805140,%eax
  802921:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802924:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802928:	74 07                	je     802931 <alloc_block_FF+0x1a5>
  80292a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292d:	8b 00                	mov    (%eax),%eax
  80292f:	eb 05                	jmp    802936 <alloc_block_FF+0x1aa>
  802931:	b8 00 00 00 00       	mov    $0x0,%eax
  802936:	a3 40 51 80 00       	mov    %eax,0x805140
  80293b:	a1 40 51 80 00       	mov    0x805140,%eax
  802940:	85 c0                	test   %eax,%eax
  802942:	0f 85 57 fe ff ff    	jne    80279f <alloc_block_FF+0x13>
  802948:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80294c:	0f 85 4d fe ff ff    	jne    80279f <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802952:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802957:	c9                   	leave  
  802958:	c3                   	ret    

00802959 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802959:	55                   	push   %ebp
  80295a:	89 e5                	mov    %esp,%ebp
  80295c:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  80295f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802966:	a1 38 51 80 00       	mov    0x805138,%eax
  80296b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80296e:	e9 df 00 00 00       	jmp    802a52 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802973:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802976:	8b 40 0c             	mov    0xc(%eax),%eax
  802979:	3b 45 08             	cmp    0x8(%ebp),%eax
  80297c:	0f 82 c8 00 00 00    	jb     802a4a <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802982:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802985:	8b 40 0c             	mov    0xc(%eax),%eax
  802988:	3b 45 08             	cmp    0x8(%ebp),%eax
  80298b:	0f 85 8a 00 00 00    	jne    802a1b <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802991:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802995:	75 17                	jne    8029ae <alloc_block_BF+0x55>
  802997:	83 ec 04             	sub    $0x4,%esp
  80299a:	68 04 45 80 00       	push   $0x804504
  80299f:	68 b7 00 00 00       	push   $0xb7
  8029a4:	68 5b 44 80 00       	push   $0x80445b
  8029a9:	e8 70 dd ff ff       	call   80071e <_panic>
  8029ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b1:	8b 00                	mov    (%eax),%eax
  8029b3:	85 c0                	test   %eax,%eax
  8029b5:	74 10                	je     8029c7 <alloc_block_BF+0x6e>
  8029b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ba:	8b 00                	mov    (%eax),%eax
  8029bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029bf:	8b 52 04             	mov    0x4(%edx),%edx
  8029c2:	89 50 04             	mov    %edx,0x4(%eax)
  8029c5:	eb 0b                	jmp    8029d2 <alloc_block_BF+0x79>
  8029c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ca:	8b 40 04             	mov    0x4(%eax),%eax
  8029cd:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8029d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d5:	8b 40 04             	mov    0x4(%eax),%eax
  8029d8:	85 c0                	test   %eax,%eax
  8029da:	74 0f                	je     8029eb <alloc_block_BF+0x92>
  8029dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029df:	8b 40 04             	mov    0x4(%eax),%eax
  8029e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029e5:	8b 12                	mov    (%edx),%edx
  8029e7:	89 10                	mov    %edx,(%eax)
  8029e9:	eb 0a                	jmp    8029f5 <alloc_block_BF+0x9c>
  8029eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ee:	8b 00                	mov    (%eax),%eax
  8029f0:	a3 38 51 80 00       	mov    %eax,0x805138
  8029f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a01:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a08:	a1 44 51 80 00       	mov    0x805144,%eax
  802a0d:	48                   	dec    %eax
  802a0e:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802a13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a16:	e9 4d 01 00 00       	jmp    802b68 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802a1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1e:	8b 40 0c             	mov    0xc(%eax),%eax
  802a21:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a24:	76 24                	jbe    802a4a <alloc_block_BF+0xf1>
  802a26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a29:	8b 40 0c             	mov    0xc(%eax),%eax
  802a2c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802a2f:	73 19                	jae    802a4a <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802a31:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802a38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3b:	8b 40 0c             	mov    0xc(%eax),%eax
  802a3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802a41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a44:	8b 40 08             	mov    0x8(%eax),%eax
  802a47:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802a4a:	a1 40 51 80 00       	mov    0x805140,%eax
  802a4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a52:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a56:	74 07                	je     802a5f <alloc_block_BF+0x106>
  802a58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5b:	8b 00                	mov    (%eax),%eax
  802a5d:	eb 05                	jmp    802a64 <alloc_block_BF+0x10b>
  802a5f:	b8 00 00 00 00       	mov    $0x0,%eax
  802a64:	a3 40 51 80 00       	mov    %eax,0x805140
  802a69:	a1 40 51 80 00       	mov    0x805140,%eax
  802a6e:	85 c0                	test   %eax,%eax
  802a70:	0f 85 fd fe ff ff    	jne    802973 <alloc_block_BF+0x1a>
  802a76:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a7a:	0f 85 f3 fe ff ff    	jne    802973 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802a80:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802a84:	0f 84 d9 00 00 00    	je     802b63 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802a8a:	a1 48 51 80 00       	mov    0x805148,%eax
  802a8f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802a92:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a95:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a98:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802a9b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a9e:	8b 55 08             	mov    0x8(%ebp),%edx
  802aa1:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802aa4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802aa8:	75 17                	jne    802ac1 <alloc_block_BF+0x168>
  802aaa:	83 ec 04             	sub    $0x4,%esp
  802aad:	68 04 45 80 00       	push   $0x804504
  802ab2:	68 c7 00 00 00       	push   $0xc7
  802ab7:	68 5b 44 80 00       	push   $0x80445b
  802abc:	e8 5d dc ff ff       	call   80071e <_panic>
  802ac1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ac4:	8b 00                	mov    (%eax),%eax
  802ac6:	85 c0                	test   %eax,%eax
  802ac8:	74 10                	je     802ada <alloc_block_BF+0x181>
  802aca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802acd:	8b 00                	mov    (%eax),%eax
  802acf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802ad2:	8b 52 04             	mov    0x4(%edx),%edx
  802ad5:	89 50 04             	mov    %edx,0x4(%eax)
  802ad8:	eb 0b                	jmp    802ae5 <alloc_block_BF+0x18c>
  802ada:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802add:	8b 40 04             	mov    0x4(%eax),%eax
  802ae0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ae5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ae8:	8b 40 04             	mov    0x4(%eax),%eax
  802aeb:	85 c0                	test   %eax,%eax
  802aed:	74 0f                	je     802afe <alloc_block_BF+0x1a5>
  802aef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802af2:	8b 40 04             	mov    0x4(%eax),%eax
  802af5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802af8:	8b 12                	mov    (%edx),%edx
  802afa:	89 10                	mov    %edx,(%eax)
  802afc:	eb 0a                	jmp    802b08 <alloc_block_BF+0x1af>
  802afe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b01:	8b 00                	mov    (%eax),%eax
  802b03:	a3 48 51 80 00       	mov    %eax,0x805148
  802b08:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b0b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b11:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b14:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b1b:	a1 54 51 80 00       	mov    0x805154,%eax
  802b20:	48                   	dec    %eax
  802b21:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802b26:	83 ec 08             	sub    $0x8,%esp
  802b29:	ff 75 ec             	pushl  -0x14(%ebp)
  802b2c:	68 38 51 80 00       	push   $0x805138
  802b31:	e8 71 f9 ff ff       	call   8024a7 <find_block>
  802b36:	83 c4 10             	add    $0x10,%esp
  802b39:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802b3c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b3f:	8b 50 08             	mov    0x8(%eax),%edx
  802b42:	8b 45 08             	mov    0x8(%ebp),%eax
  802b45:	01 c2                	add    %eax,%edx
  802b47:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b4a:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802b4d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b50:	8b 40 0c             	mov    0xc(%eax),%eax
  802b53:	2b 45 08             	sub    0x8(%ebp),%eax
  802b56:	89 c2                	mov    %eax,%edx
  802b58:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b5b:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802b5e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b61:	eb 05                	jmp    802b68 <alloc_block_BF+0x20f>
	}
	return NULL;
  802b63:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b68:	c9                   	leave  
  802b69:	c3                   	ret    

00802b6a <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802b6a:	55                   	push   %ebp
  802b6b:	89 e5                	mov    %esp,%ebp
  802b6d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802b70:	a1 28 50 80 00       	mov    0x805028,%eax
  802b75:	85 c0                	test   %eax,%eax
  802b77:	0f 85 de 01 00 00    	jne    802d5b <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802b7d:	a1 38 51 80 00       	mov    0x805138,%eax
  802b82:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b85:	e9 9e 01 00 00       	jmp    802d28 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802b8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8d:	8b 40 0c             	mov    0xc(%eax),%eax
  802b90:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b93:	0f 82 87 01 00 00    	jb     802d20 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802b99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9c:	8b 40 0c             	mov    0xc(%eax),%eax
  802b9f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ba2:	0f 85 95 00 00 00    	jne    802c3d <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802ba8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bac:	75 17                	jne    802bc5 <alloc_block_NF+0x5b>
  802bae:	83 ec 04             	sub    $0x4,%esp
  802bb1:	68 04 45 80 00       	push   $0x804504
  802bb6:	68 e0 00 00 00       	push   $0xe0
  802bbb:	68 5b 44 80 00       	push   $0x80445b
  802bc0:	e8 59 db ff ff       	call   80071e <_panic>
  802bc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc8:	8b 00                	mov    (%eax),%eax
  802bca:	85 c0                	test   %eax,%eax
  802bcc:	74 10                	je     802bde <alloc_block_NF+0x74>
  802bce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd1:	8b 00                	mov    (%eax),%eax
  802bd3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bd6:	8b 52 04             	mov    0x4(%edx),%edx
  802bd9:	89 50 04             	mov    %edx,0x4(%eax)
  802bdc:	eb 0b                	jmp    802be9 <alloc_block_NF+0x7f>
  802bde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be1:	8b 40 04             	mov    0x4(%eax),%eax
  802be4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802be9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bec:	8b 40 04             	mov    0x4(%eax),%eax
  802bef:	85 c0                	test   %eax,%eax
  802bf1:	74 0f                	je     802c02 <alloc_block_NF+0x98>
  802bf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf6:	8b 40 04             	mov    0x4(%eax),%eax
  802bf9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bfc:	8b 12                	mov    (%edx),%edx
  802bfe:	89 10                	mov    %edx,(%eax)
  802c00:	eb 0a                	jmp    802c0c <alloc_block_NF+0xa2>
  802c02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c05:	8b 00                	mov    (%eax),%eax
  802c07:	a3 38 51 80 00       	mov    %eax,0x805138
  802c0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c18:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c1f:	a1 44 51 80 00       	mov    0x805144,%eax
  802c24:	48                   	dec    %eax
  802c25:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802c2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2d:	8b 40 08             	mov    0x8(%eax),%eax
  802c30:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802c35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c38:	e9 f8 04 00 00       	jmp    803135 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802c3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c40:	8b 40 0c             	mov    0xc(%eax),%eax
  802c43:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c46:	0f 86 d4 00 00 00    	jbe    802d20 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802c4c:	a1 48 51 80 00       	mov    0x805148,%eax
  802c51:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802c54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c57:	8b 50 08             	mov    0x8(%eax),%edx
  802c5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c5d:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802c60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c63:	8b 55 08             	mov    0x8(%ebp),%edx
  802c66:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802c69:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c6d:	75 17                	jne    802c86 <alloc_block_NF+0x11c>
  802c6f:	83 ec 04             	sub    $0x4,%esp
  802c72:	68 04 45 80 00       	push   $0x804504
  802c77:	68 e9 00 00 00       	push   $0xe9
  802c7c:	68 5b 44 80 00       	push   $0x80445b
  802c81:	e8 98 da ff ff       	call   80071e <_panic>
  802c86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c89:	8b 00                	mov    (%eax),%eax
  802c8b:	85 c0                	test   %eax,%eax
  802c8d:	74 10                	je     802c9f <alloc_block_NF+0x135>
  802c8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c92:	8b 00                	mov    (%eax),%eax
  802c94:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c97:	8b 52 04             	mov    0x4(%edx),%edx
  802c9a:	89 50 04             	mov    %edx,0x4(%eax)
  802c9d:	eb 0b                	jmp    802caa <alloc_block_NF+0x140>
  802c9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ca2:	8b 40 04             	mov    0x4(%eax),%eax
  802ca5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802caa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cad:	8b 40 04             	mov    0x4(%eax),%eax
  802cb0:	85 c0                	test   %eax,%eax
  802cb2:	74 0f                	je     802cc3 <alloc_block_NF+0x159>
  802cb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cb7:	8b 40 04             	mov    0x4(%eax),%eax
  802cba:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cbd:	8b 12                	mov    (%edx),%edx
  802cbf:	89 10                	mov    %edx,(%eax)
  802cc1:	eb 0a                	jmp    802ccd <alloc_block_NF+0x163>
  802cc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cc6:	8b 00                	mov    (%eax),%eax
  802cc8:	a3 48 51 80 00       	mov    %eax,0x805148
  802ccd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cd0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cd9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ce0:	a1 54 51 80 00       	mov    0x805154,%eax
  802ce5:	48                   	dec    %eax
  802ce6:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802ceb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cee:	8b 40 08             	mov    0x8(%eax),%eax
  802cf1:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802cf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf9:	8b 50 08             	mov    0x8(%eax),%edx
  802cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  802cff:	01 c2                	add    %eax,%edx
  802d01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d04:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802d07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0a:	8b 40 0c             	mov    0xc(%eax),%eax
  802d0d:	2b 45 08             	sub    0x8(%ebp),%eax
  802d10:	89 c2                	mov    %eax,%edx
  802d12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d15:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802d18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d1b:	e9 15 04 00 00       	jmp    803135 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802d20:	a1 40 51 80 00       	mov    0x805140,%eax
  802d25:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d28:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d2c:	74 07                	je     802d35 <alloc_block_NF+0x1cb>
  802d2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d31:	8b 00                	mov    (%eax),%eax
  802d33:	eb 05                	jmp    802d3a <alloc_block_NF+0x1d0>
  802d35:	b8 00 00 00 00       	mov    $0x0,%eax
  802d3a:	a3 40 51 80 00       	mov    %eax,0x805140
  802d3f:	a1 40 51 80 00       	mov    0x805140,%eax
  802d44:	85 c0                	test   %eax,%eax
  802d46:	0f 85 3e fe ff ff    	jne    802b8a <alloc_block_NF+0x20>
  802d4c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d50:	0f 85 34 fe ff ff    	jne    802b8a <alloc_block_NF+0x20>
  802d56:	e9 d5 03 00 00       	jmp    803130 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802d5b:	a1 38 51 80 00       	mov    0x805138,%eax
  802d60:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d63:	e9 b1 01 00 00       	jmp    802f19 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802d68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6b:	8b 50 08             	mov    0x8(%eax),%edx
  802d6e:	a1 28 50 80 00       	mov    0x805028,%eax
  802d73:	39 c2                	cmp    %eax,%edx
  802d75:	0f 82 96 01 00 00    	jb     802f11 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802d7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7e:	8b 40 0c             	mov    0xc(%eax),%eax
  802d81:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d84:	0f 82 87 01 00 00    	jb     802f11 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802d8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8d:	8b 40 0c             	mov    0xc(%eax),%eax
  802d90:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d93:	0f 85 95 00 00 00    	jne    802e2e <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802d99:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d9d:	75 17                	jne    802db6 <alloc_block_NF+0x24c>
  802d9f:	83 ec 04             	sub    $0x4,%esp
  802da2:	68 04 45 80 00       	push   $0x804504
  802da7:	68 fc 00 00 00       	push   $0xfc
  802dac:	68 5b 44 80 00       	push   $0x80445b
  802db1:	e8 68 d9 ff ff       	call   80071e <_panic>
  802db6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db9:	8b 00                	mov    (%eax),%eax
  802dbb:	85 c0                	test   %eax,%eax
  802dbd:	74 10                	je     802dcf <alloc_block_NF+0x265>
  802dbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc2:	8b 00                	mov    (%eax),%eax
  802dc4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dc7:	8b 52 04             	mov    0x4(%edx),%edx
  802dca:	89 50 04             	mov    %edx,0x4(%eax)
  802dcd:	eb 0b                	jmp    802dda <alloc_block_NF+0x270>
  802dcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd2:	8b 40 04             	mov    0x4(%eax),%eax
  802dd5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802dda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ddd:	8b 40 04             	mov    0x4(%eax),%eax
  802de0:	85 c0                	test   %eax,%eax
  802de2:	74 0f                	je     802df3 <alloc_block_NF+0x289>
  802de4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de7:	8b 40 04             	mov    0x4(%eax),%eax
  802dea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ded:	8b 12                	mov    (%edx),%edx
  802def:	89 10                	mov    %edx,(%eax)
  802df1:	eb 0a                	jmp    802dfd <alloc_block_NF+0x293>
  802df3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df6:	8b 00                	mov    (%eax),%eax
  802df8:	a3 38 51 80 00       	mov    %eax,0x805138
  802dfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e00:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e09:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e10:	a1 44 51 80 00       	mov    0x805144,%eax
  802e15:	48                   	dec    %eax
  802e16:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802e1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1e:	8b 40 08             	mov    0x8(%eax),%eax
  802e21:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802e26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e29:	e9 07 03 00 00       	jmp    803135 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802e2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e31:	8b 40 0c             	mov    0xc(%eax),%eax
  802e34:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e37:	0f 86 d4 00 00 00    	jbe    802f11 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802e3d:	a1 48 51 80 00       	mov    0x805148,%eax
  802e42:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802e45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e48:	8b 50 08             	mov    0x8(%eax),%edx
  802e4b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e4e:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802e51:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e54:	8b 55 08             	mov    0x8(%ebp),%edx
  802e57:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802e5a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802e5e:	75 17                	jne    802e77 <alloc_block_NF+0x30d>
  802e60:	83 ec 04             	sub    $0x4,%esp
  802e63:	68 04 45 80 00       	push   $0x804504
  802e68:	68 04 01 00 00       	push   $0x104
  802e6d:	68 5b 44 80 00       	push   $0x80445b
  802e72:	e8 a7 d8 ff ff       	call   80071e <_panic>
  802e77:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e7a:	8b 00                	mov    (%eax),%eax
  802e7c:	85 c0                	test   %eax,%eax
  802e7e:	74 10                	je     802e90 <alloc_block_NF+0x326>
  802e80:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e83:	8b 00                	mov    (%eax),%eax
  802e85:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e88:	8b 52 04             	mov    0x4(%edx),%edx
  802e8b:	89 50 04             	mov    %edx,0x4(%eax)
  802e8e:	eb 0b                	jmp    802e9b <alloc_block_NF+0x331>
  802e90:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e93:	8b 40 04             	mov    0x4(%eax),%eax
  802e96:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e9b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e9e:	8b 40 04             	mov    0x4(%eax),%eax
  802ea1:	85 c0                	test   %eax,%eax
  802ea3:	74 0f                	je     802eb4 <alloc_block_NF+0x34a>
  802ea5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ea8:	8b 40 04             	mov    0x4(%eax),%eax
  802eab:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802eae:	8b 12                	mov    (%edx),%edx
  802eb0:	89 10                	mov    %edx,(%eax)
  802eb2:	eb 0a                	jmp    802ebe <alloc_block_NF+0x354>
  802eb4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eb7:	8b 00                	mov    (%eax),%eax
  802eb9:	a3 48 51 80 00       	mov    %eax,0x805148
  802ebe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ec1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ec7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eca:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ed1:	a1 54 51 80 00       	mov    0x805154,%eax
  802ed6:	48                   	dec    %eax
  802ed7:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802edc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802edf:	8b 40 08             	mov    0x8(%eax),%eax
  802ee2:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802ee7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eea:	8b 50 08             	mov    0x8(%eax),%edx
  802eed:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef0:	01 c2                	add    %eax,%edx
  802ef2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef5:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802ef8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802efb:	8b 40 0c             	mov    0xc(%eax),%eax
  802efe:	2b 45 08             	sub    0x8(%ebp),%eax
  802f01:	89 c2                	mov    %eax,%edx
  802f03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f06:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802f09:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f0c:	e9 24 02 00 00       	jmp    803135 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802f11:	a1 40 51 80 00       	mov    0x805140,%eax
  802f16:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f19:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f1d:	74 07                	je     802f26 <alloc_block_NF+0x3bc>
  802f1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f22:	8b 00                	mov    (%eax),%eax
  802f24:	eb 05                	jmp    802f2b <alloc_block_NF+0x3c1>
  802f26:	b8 00 00 00 00       	mov    $0x0,%eax
  802f2b:	a3 40 51 80 00       	mov    %eax,0x805140
  802f30:	a1 40 51 80 00       	mov    0x805140,%eax
  802f35:	85 c0                	test   %eax,%eax
  802f37:	0f 85 2b fe ff ff    	jne    802d68 <alloc_block_NF+0x1fe>
  802f3d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f41:	0f 85 21 fe ff ff    	jne    802d68 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802f47:	a1 38 51 80 00       	mov    0x805138,%eax
  802f4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f4f:	e9 ae 01 00 00       	jmp    803102 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802f54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f57:	8b 50 08             	mov    0x8(%eax),%edx
  802f5a:	a1 28 50 80 00       	mov    0x805028,%eax
  802f5f:	39 c2                	cmp    %eax,%edx
  802f61:	0f 83 93 01 00 00    	jae    8030fa <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802f67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6a:	8b 40 0c             	mov    0xc(%eax),%eax
  802f6d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f70:	0f 82 84 01 00 00    	jb     8030fa <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802f76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f79:	8b 40 0c             	mov    0xc(%eax),%eax
  802f7c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f7f:	0f 85 95 00 00 00    	jne    80301a <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802f85:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f89:	75 17                	jne    802fa2 <alloc_block_NF+0x438>
  802f8b:	83 ec 04             	sub    $0x4,%esp
  802f8e:	68 04 45 80 00       	push   $0x804504
  802f93:	68 14 01 00 00       	push   $0x114
  802f98:	68 5b 44 80 00       	push   $0x80445b
  802f9d:	e8 7c d7 ff ff       	call   80071e <_panic>
  802fa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa5:	8b 00                	mov    (%eax),%eax
  802fa7:	85 c0                	test   %eax,%eax
  802fa9:	74 10                	je     802fbb <alloc_block_NF+0x451>
  802fab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fae:	8b 00                	mov    (%eax),%eax
  802fb0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fb3:	8b 52 04             	mov    0x4(%edx),%edx
  802fb6:	89 50 04             	mov    %edx,0x4(%eax)
  802fb9:	eb 0b                	jmp    802fc6 <alloc_block_NF+0x45c>
  802fbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fbe:	8b 40 04             	mov    0x4(%eax),%eax
  802fc1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc9:	8b 40 04             	mov    0x4(%eax),%eax
  802fcc:	85 c0                	test   %eax,%eax
  802fce:	74 0f                	je     802fdf <alloc_block_NF+0x475>
  802fd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd3:	8b 40 04             	mov    0x4(%eax),%eax
  802fd6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fd9:	8b 12                	mov    (%edx),%edx
  802fdb:	89 10                	mov    %edx,(%eax)
  802fdd:	eb 0a                	jmp    802fe9 <alloc_block_NF+0x47f>
  802fdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe2:	8b 00                	mov    (%eax),%eax
  802fe4:	a3 38 51 80 00       	mov    %eax,0x805138
  802fe9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ff2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ffc:	a1 44 51 80 00       	mov    0x805144,%eax
  803001:	48                   	dec    %eax
  803002:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  803007:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80300a:	8b 40 08             	mov    0x8(%eax),%eax
  80300d:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  803012:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803015:	e9 1b 01 00 00       	jmp    803135 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  80301a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80301d:	8b 40 0c             	mov    0xc(%eax),%eax
  803020:	3b 45 08             	cmp    0x8(%ebp),%eax
  803023:	0f 86 d1 00 00 00    	jbe    8030fa <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803029:	a1 48 51 80 00       	mov    0x805148,%eax
  80302e:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  803031:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803034:	8b 50 08             	mov    0x8(%eax),%edx
  803037:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80303a:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  80303d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803040:	8b 55 08             	mov    0x8(%ebp),%edx
  803043:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803046:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80304a:	75 17                	jne    803063 <alloc_block_NF+0x4f9>
  80304c:	83 ec 04             	sub    $0x4,%esp
  80304f:	68 04 45 80 00       	push   $0x804504
  803054:	68 1c 01 00 00       	push   $0x11c
  803059:	68 5b 44 80 00       	push   $0x80445b
  80305e:	e8 bb d6 ff ff       	call   80071e <_panic>
  803063:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803066:	8b 00                	mov    (%eax),%eax
  803068:	85 c0                	test   %eax,%eax
  80306a:	74 10                	je     80307c <alloc_block_NF+0x512>
  80306c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80306f:	8b 00                	mov    (%eax),%eax
  803071:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803074:	8b 52 04             	mov    0x4(%edx),%edx
  803077:	89 50 04             	mov    %edx,0x4(%eax)
  80307a:	eb 0b                	jmp    803087 <alloc_block_NF+0x51d>
  80307c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80307f:	8b 40 04             	mov    0x4(%eax),%eax
  803082:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803087:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80308a:	8b 40 04             	mov    0x4(%eax),%eax
  80308d:	85 c0                	test   %eax,%eax
  80308f:	74 0f                	je     8030a0 <alloc_block_NF+0x536>
  803091:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803094:	8b 40 04             	mov    0x4(%eax),%eax
  803097:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80309a:	8b 12                	mov    (%edx),%edx
  80309c:	89 10                	mov    %edx,(%eax)
  80309e:	eb 0a                	jmp    8030aa <alloc_block_NF+0x540>
  8030a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030a3:	8b 00                	mov    (%eax),%eax
  8030a5:	a3 48 51 80 00       	mov    %eax,0x805148
  8030aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030ad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030b6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030bd:	a1 54 51 80 00       	mov    0x805154,%eax
  8030c2:	48                   	dec    %eax
  8030c3:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  8030c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030cb:	8b 40 08             	mov    0x8(%eax),%eax
  8030ce:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  8030d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d6:	8b 50 08             	mov    0x8(%eax),%edx
  8030d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030dc:	01 c2                	add    %eax,%edx
  8030de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e1:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8030e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e7:	8b 40 0c             	mov    0xc(%eax),%eax
  8030ea:	2b 45 08             	sub    0x8(%ebp),%eax
  8030ed:	89 c2                	mov    %eax,%edx
  8030ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f2:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8030f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030f8:	eb 3b                	jmp    803135 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8030fa:	a1 40 51 80 00       	mov    0x805140,%eax
  8030ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803102:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803106:	74 07                	je     80310f <alloc_block_NF+0x5a5>
  803108:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80310b:	8b 00                	mov    (%eax),%eax
  80310d:	eb 05                	jmp    803114 <alloc_block_NF+0x5aa>
  80310f:	b8 00 00 00 00       	mov    $0x0,%eax
  803114:	a3 40 51 80 00       	mov    %eax,0x805140
  803119:	a1 40 51 80 00       	mov    0x805140,%eax
  80311e:	85 c0                	test   %eax,%eax
  803120:	0f 85 2e fe ff ff    	jne    802f54 <alloc_block_NF+0x3ea>
  803126:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80312a:	0f 85 24 fe ff ff    	jne    802f54 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  803130:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803135:	c9                   	leave  
  803136:	c3                   	ret    

00803137 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803137:	55                   	push   %ebp
  803138:	89 e5                	mov    %esp,%ebp
  80313a:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  80313d:	a1 38 51 80 00       	mov    0x805138,%eax
  803142:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  803145:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80314a:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  80314d:	a1 38 51 80 00       	mov    0x805138,%eax
  803152:	85 c0                	test   %eax,%eax
  803154:	74 14                	je     80316a <insert_sorted_with_merge_freeList+0x33>
  803156:	8b 45 08             	mov    0x8(%ebp),%eax
  803159:	8b 50 08             	mov    0x8(%eax),%edx
  80315c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80315f:	8b 40 08             	mov    0x8(%eax),%eax
  803162:	39 c2                	cmp    %eax,%edx
  803164:	0f 87 9b 01 00 00    	ja     803305 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  80316a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80316e:	75 17                	jne    803187 <insert_sorted_with_merge_freeList+0x50>
  803170:	83 ec 04             	sub    $0x4,%esp
  803173:	68 38 44 80 00       	push   $0x804438
  803178:	68 38 01 00 00       	push   $0x138
  80317d:	68 5b 44 80 00       	push   $0x80445b
  803182:	e8 97 d5 ff ff       	call   80071e <_panic>
  803187:	8b 15 38 51 80 00    	mov    0x805138,%edx
  80318d:	8b 45 08             	mov    0x8(%ebp),%eax
  803190:	89 10                	mov    %edx,(%eax)
  803192:	8b 45 08             	mov    0x8(%ebp),%eax
  803195:	8b 00                	mov    (%eax),%eax
  803197:	85 c0                	test   %eax,%eax
  803199:	74 0d                	je     8031a8 <insert_sorted_with_merge_freeList+0x71>
  80319b:	a1 38 51 80 00       	mov    0x805138,%eax
  8031a0:	8b 55 08             	mov    0x8(%ebp),%edx
  8031a3:	89 50 04             	mov    %edx,0x4(%eax)
  8031a6:	eb 08                	jmp    8031b0 <insert_sorted_with_merge_freeList+0x79>
  8031a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ab:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b3:	a3 38 51 80 00       	mov    %eax,0x805138
  8031b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8031bb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031c2:	a1 44 51 80 00       	mov    0x805144,%eax
  8031c7:	40                   	inc    %eax
  8031c8:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8031cd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8031d1:	0f 84 a8 06 00 00    	je     80387f <insert_sorted_with_merge_freeList+0x748>
  8031d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031da:	8b 50 08             	mov    0x8(%eax),%edx
  8031dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e0:	8b 40 0c             	mov    0xc(%eax),%eax
  8031e3:	01 c2                	add    %eax,%edx
  8031e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031e8:	8b 40 08             	mov    0x8(%eax),%eax
  8031eb:	39 c2                	cmp    %eax,%edx
  8031ed:	0f 85 8c 06 00 00    	jne    80387f <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  8031f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f6:	8b 50 0c             	mov    0xc(%eax),%edx
  8031f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031fc:	8b 40 0c             	mov    0xc(%eax),%eax
  8031ff:	01 c2                	add    %eax,%edx
  803201:	8b 45 08             	mov    0x8(%ebp),%eax
  803204:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  803207:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80320b:	75 17                	jne    803224 <insert_sorted_with_merge_freeList+0xed>
  80320d:	83 ec 04             	sub    $0x4,%esp
  803210:	68 04 45 80 00       	push   $0x804504
  803215:	68 3c 01 00 00       	push   $0x13c
  80321a:	68 5b 44 80 00       	push   $0x80445b
  80321f:	e8 fa d4 ff ff       	call   80071e <_panic>
  803224:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803227:	8b 00                	mov    (%eax),%eax
  803229:	85 c0                	test   %eax,%eax
  80322b:	74 10                	je     80323d <insert_sorted_with_merge_freeList+0x106>
  80322d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803230:	8b 00                	mov    (%eax),%eax
  803232:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803235:	8b 52 04             	mov    0x4(%edx),%edx
  803238:	89 50 04             	mov    %edx,0x4(%eax)
  80323b:	eb 0b                	jmp    803248 <insert_sorted_with_merge_freeList+0x111>
  80323d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803240:	8b 40 04             	mov    0x4(%eax),%eax
  803243:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803248:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80324b:	8b 40 04             	mov    0x4(%eax),%eax
  80324e:	85 c0                	test   %eax,%eax
  803250:	74 0f                	je     803261 <insert_sorted_with_merge_freeList+0x12a>
  803252:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803255:	8b 40 04             	mov    0x4(%eax),%eax
  803258:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80325b:	8b 12                	mov    (%edx),%edx
  80325d:	89 10                	mov    %edx,(%eax)
  80325f:	eb 0a                	jmp    80326b <insert_sorted_with_merge_freeList+0x134>
  803261:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803264:	8b 00                	mov    (%eax),%eax
  803266:	a3 38 51 80 00       	mov    %eax,0x805138
  80326b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80326e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803274:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803277:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80327e:	a1 44 51 80 00       	mov    0x805144,%eax
  803283:	48                   	dec    %eax
  803284:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  803289:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80328c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  803293:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803296:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  80329d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8032a1:	75 17                	jne    8032ba <insert_sorted_with_merge_freeList+0x183>
  8032a3:	83 ec 04             	sub    $0x4,%esp
  8032a6:	68 38 44 80 00       	push   $0x804438
  8032ab:	68 3f 01 00 00       	push   $0x13f
  8032b0:	68 5b 44 80 00       	push   $0x80445b
  8032b5:	e8 64 d4 ff ff       	call   80071e <_panic>
  8032ba:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8032c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032c3:	89 10                	mov    %edx,(%eax)
  8032c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032c8:	8b 00                	mov    (%eax),%eax
  8032ca:	85 c0                	test   %eax,%eax
  8032cc:	74 0d                	je     8032db <insert_sorted_with_merge_freeList+0x1a4>
  8032ce:	a1 48 51 80 00       	mov    0x805148,%eax
  8032d3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032d6:	89 50 04             	mov    %edx,0x4(%eax)
  8032d9:	eb 08                	jmp    8032e3 <insert_sorted_with_merge_freeList+0x1ac>
  8032db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032de:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032e6:	a3 48 51 80 00       	mov    %eax,0x805148
  8032eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032ee:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032f5:	a1 54 51 80 00       	mov    0x805154,%eax
  8032fa:	40                   	inc    %eax
  8032fb:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803300:	e9 7a 05 00 00       	jmp    80387f <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  803305:	8b 45 08             	mov    0x8(%ebp),%eax
  803308:	8b 50 08             	mov    0x8(%eax),%edx
  80330b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80330e:	8b 40 08             	mov    0x8(%eax),%eax
  803311:	39 c2                	cmp    %eax,%edx
  803313:	0f 82 14 01 00 00    	jb     80342d <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  803319:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80331c:	8b 50 08             	mov    0x8(%eax),%edx
  80331f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803322:	8b 40 0c             	mov    0xc(%eax),%eax
  803325:	01 c2                	add    %eax,%edx
  803327:	8b 45 08             	mov    0x8(%ebp),%eax
  80332a:	8b 40 08             	mov    0x8(%eax),%eax
  80332d:	39 c2                	cmp    %eax,%edx
  80332f:	0f 85 90 00 00 00    	jne    8033c5 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  803335:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803338:	8b 50 0c             	mov    0xc(%eax),%edx
  80333b:	8b 45 08             	mov    0x8(%ebp),%eax
  80333e:	8b 40 0c             	mov    0xc(%eax),%eax
  803341:	01 c2                	add    %eax,%edx
  803343:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803346:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  803349:	8b 45 08             	mov    0x8(%ebp),%eax
  80334c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  803353:	8b 45 08             	mov    0x8(%ebp),%eax
  803356:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80335d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803361:	75 17                	jne    80337a <insert_sorted_with_merge_freeList+0x243>
  803363:	83 ec 04             	sub    $0x4,%esp
  803366:	68 38 44 80 00       	push   $0x804438
  80336b:	68 49 01 00 00       	push   $0x149
  803370:	68 5b 44 80 00       	push   $0x80445b
  803375:	e8 a4 d3 ff ff       	call   80071e <_panic>
  80337a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803380:	8b 45 08             	mov    0x8(%ebp),%eax
  803383:	89 10                	mov    %edx,(%eax)
  803385:	8b 45 08             	mov    0x8(%ebp),%eax
  803388:	8b 00                	mov    (%eax),%eax
  80338a:	85 c0                	test   %eax,%eax
  80338c:	74 0d                	je     80339b <insert_sorted_with_merge_freeList+0x264>
  80338e:	a1 48 51 80 00       	mov    0x805148,%eax
  803393:	8b 55 08             	mov    0x8(%ebp),%edx
  803396:	89 50 04             	mov    %edx,0x4(%eax)
  803399:	eb 08                	jmp    8033a3 <insert_sorted_with_merge_freeList+0x26c>
  80339b:	8b 45 08             	mov    0x8(%ebp),%eax
  80339e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8033a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a6:	a3 48 51 80 00       	mov    %eax,0x805148
  8033ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033b5:	a1 54 51 80 00       	mov    0x805154,%eax
  8033ba:	40                   	inc    %eax
  8033bb:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8033c0:	e9 bb 04 00 00       	jmp    803880 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  8033c5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033c9:	75 17                	jne    8033e2 <insert_sorted_with_merge_freeList+0x2ab>
  8033cb:	83 ec 04             	sub    $0x4,%esp
  8033ce:	68 ac 44 80 00       	push   $0x8044ac
  8033d3:	68 4c 01 00 00       	push   $0x14c
  8033d8:	68 5b 44 80 00       	push   $0x80445b
  8033dd:	e8 3c d3 ff ff       	call   80071e <_panic>
  8033e2:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8033e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8033eb:	89 50 04             	mov    %edx,0x4(%eax)
  8033ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f1:	8b 40 04             	mov    0x4(%eax),%eax
  8033f4:	85 c0                	test   %eax,%eax
  8033f6:	74 0c                	je     803404 <insert_sorted_with_merge_freeList+0x2cd>
  8033f8:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8033fd:	8b 55 08             	mov    0x8(%ebp),%edx
  803400:	89 10                	mov    %edx,(%eax)
  803402:	eb 08                	jmp    80340c <insert_sorted_with_merge_freeList+0x2d5>
  803404:	8b 45 08             	mov    0x8(%ebp),%eax
  803407:	a3 38 51 80 00       	mov    %eax,0x805138
  80340c:	8b 45 08             	mov    0x8(%ebp),%eax
  80340f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803414:	8b 45 08             	mov    0x8(%ebp),%eax
  803417:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80341d:	a1 44 51 80 00       	mov    0x805144,%eax
  803422:	40                   	inc    %eax
  803423:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803428:	e9 53 04 00 00       	jmp    803880 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80342d:	a1 38 51 80 00       	mov    0x805138,%eax
  803432:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803435:	e9 15 04 00 00       	jmp    80384f <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  80343a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80343d:	8b 00                	mov    (%eax),%eax
  80343f:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803442:	8b 45 08             	mov    0x8(%ebp),%eax
  803445:	8b 50 08             	mov    0x8(%eax),%edx
  803448:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80344b:	8b 40 08             	mov    0x8(%eax),%eax
  80344e:	39 c2                	cmp    %eax,%edx
  803450:	0f 86 f1 03 00 00    	jbe    803847 <insert_sorted_with_merge_freeList+0x710>
  803456:	8b 45 08             	mov    0x8(%ebp),%eax
  803459:	8b 50 08             	mov    0x8(%eax),%edx
  80345c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80345f:	8b 40 08             	mov    0x8(%eax),%eax
  803462:	39 c2                	cmp    %eax,%edx
  803464:	0f 83 dd 03 00 00    	jae    803847 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  80346a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80346d:	8b 50 08             	mov    0x8(%eax),%edx
  803470:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803473:	8b 40 0c             	mov    0xc(%eax),%eax
  803476:	01 c2                	add    %eax,%edx
  803478:	8b 45 08             	mov    0x8(%ebp),%eax
  80347b:	8b 40 08             	mov    0x8(%eax),%eax
  80347e:	39 c2                	cmp    %eax,%edx
  803480:	0f 85 b9 01 00 00    	jne    80363f <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803486:	8b 45 08             	mov    0x8(%ebp),%eax
  803489:	8b 50 08             	mov    0x8(%eax),%edx
  80348c:	8b 45 08             	mov    0x8(%ebp),%eax
  80348f:	8b 40 0c             	mov    0xc(%eax),%eax
  803492:	01 c2                	add    %eax,%edx
  803494:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803497:	8b 40 08             	mov    0x8(%eax),%eax
  80349a:	39 c2                	cmp    %eax,%edx
  80349c:	0f 85 0d 01 00 00    	jne    8035af <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  8034a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a5:	8b 50 0c             	mov    0xc(%eax),%edx
  8034a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034ab:	8b 40 0c             	mov    0xc(%eax),%eax
  8034ae:	01 c2                	add    %eax,%edx
  8034b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034b3:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8034b6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8034ba:	75 17                	jne    8034d3 <insert_sorted_with_merge_freeList+0x39c>
  8034bc:	83 ec 04             	sub    $0x4,%esp
  8034bf:	68 04 45 80 00       	push   $0x804504
  8034c4:	68 5c 01 00 00       	push   $0x15c
  8034c9:	68 5b 44 80 00       	push   $0x80445b
  8034ce:	e8 4b d2 ff ff       	call   80071e <_panic>
  8034d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034d6:	8b 00                	mov    (%eax),%eax
  8034d8:	85 c0                	test   %eax,%eax
  8034da:	74 10                	je     8034ec <insert_sorted_with_merge_freeList+0x3b5>
  8034dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034df:	8b 00                	mov    (%eax),%eax
  8034e1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8034e4:	8b 52 04             	mov    0x4(%edx),%edx
  8034e7:	89 50 04             	mov    %edx,0x4(%eax)
  8034ea:	eb 0b                	jmp    8034f7 <insert_sorted_with_merge_freeList+0x3c0>
  8034ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034ef:	8b 40 04             	mov    0x4(%eax),%eax
  8034f2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8034f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034fa:	8b 40 04             	mov    0x4(%eax),%eax
  8034fd:	85 c0                	test   %eax,%eax
  8034ff:	74 0f                	je     803510 <insert_sorted_with_merge_freeList+0x3d9>
  803501:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803504:	8b 40 04             	mov    0x4(%eax),%eax
  803507:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80350a:	8b 12                	mov    (%edx),%edx
  80350c:	89 10                	mov    %edx,(%eax)
  80350e:	eb 0a                	jmp    80351a <insert_sorted_with_merge_freeList+0x3e3>
  803510:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803513:	8b 00                	mov    (%eax),%eax
  803515:	a3 38 51 80 00       	mov    %eax,0x805138
  80351a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80351d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803523:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803526:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80352d:	a1 44 51 80 00       	mov    0x805144,%eax
  803532:	48                   	dec    %eax
  803533:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803538:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80353b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803542:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803545:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80354c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803550:	75 17                	jne    803569 <insert_sorted_with_merge_freeList+0x432>
  803552:	83 ec 04             	sub    $0x4,%esp
  803555:	68 38 44 80 00       	push   $0x804438
  80355a:	68 5f 01 00 00       	push   $0x15f
  80355f:	68 5b 44 80 00       	push   $0x80445b
  803564:	e8 b5 d1 ff ff       	call   80071e <_panic>
  803569:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80356f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803572:	89 10                	mov    %edx,(%eax)
  803574:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803577:	8b 00                	mov    (%eax),%eax
  803579:	85 c0                	test   %eax,%eax
  80357b:	74 0d                	je     80358a <insert_sorted_with_merge_freeList+0x453>
  80357d:	a1 48 51 80 00       	mov    0x805148,%eax
  803582:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803585:	89 50 04             	mov    %edx,0x4(%eax)
  803588:	eb 08                	jmp    803592 <insert_sorted_with_merge_freeList+0x45b>
  80358a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80358d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803592:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803595:	a3 48 51 80 00       	mov    %eax,0x805148
  80359a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80359d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035a4:	a1 54 51 80 00       	mov    0x805154,%eax
  8035a9:	40                   	inc    %eax
  8035aa:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  8035af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035b2:	8b 50 0c             	mov    0xc(%eax),%edx
  8035b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b8:	8b 40 0c             	mov    0xc(%eax),%eax
  8035bb:	01 c2                	add    %eax,%edx
  8035bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035c0:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8035c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8035cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8035d7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035db:	75 17                	jne    8035f4 <insert_sorted_with_merge_freeList+0x4bd>
  8035dd:	83 ec 04             	sub    $0x4,%esp
  8035e0:	68 38 44 80 00       	push   $0x804438
  8035e5:	68 64 01 00 00       	push   $0x164
  8035ea:	68 5b 44 80 00       	push   $0x80445b
  8035ef:	e8 2a d1 ff ff       	call   80071e <_panic>
  8035f4:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8035fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8035fd:	89 10                	mov    %edx,(%eax)
  8035ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803602:	8b 00                	mov    (%eax),%eax
  803604:	85 c0                	test   %eax,%eax
  803606:	74 0d                	je     803615 <insert_sorted_with_merge_freeList+0x4de>
  803608:	a1 48 51 80 00       	mov    0x805148,%eax
  80360d:	8b 55 08             	mov    0x8(%ebp),%edx
  803610:	89 50 04             	mov    %edx,0x4(%eax)
  803613:	eb 08                	jmp    80361d <insert_sorted_with_merge_freeList+0x4e6>
  803615:	8b 45 08             	mov    0x8(%ebp),%eax
  803618:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80361d:	8b 45 08             	mov    0x8(%ebp),%eax
  803620:	a3 48 51 80 00       	mov    %eax,0x805148
  803625:	8b 45 08             	mov    0x8(%ebp),%eax
  803628:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80362f:	a1 54 51 80 00       	mov    0x805154,%eax
  803634:	40                   	inc    %eax
  803635:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80363a:	e9 41 02 00 00       	jmp    803880 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80363f:	8b 45 08             	mov    0x8(%ebp),%eax
  803642:	8b 50 08             	mov    0x8(%eax),%edx
  803645:	8b 45 08             	mov    0x8(%ebp),%eax
  803648:	8b 40 0c             	mov    0xc(%eax),%eax
  80364b:	01 c2                	add    %eax,%edx
  80364d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803650:	8b 40 08             	mov    0x8(%eax),%eax
  803653:	39 c2                	cmp    %eax,%edx
  803655:	0f 85 7c 01 00 00    	jne    8037d7 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  80365b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80365f:	74 06                	je     803667 <insert_sorted_with_merge_freeList+0x530>
  803661:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803665:	75 17                	jne    80367e <insert_sorted_with_merge_freeList+0x547>
  803667:	83 ec 04             	sub    $0x4,%esp
  80366a:	68 74 44 80 00       	push   $0x804474
  80366f:	68 69 01 00 00       	push   $0x169
  803674:	68 5b 44 80 00       	push   $0x80445b
  803679:	e8 a0 d0 ff ff       	call   80071e <_panic>
  80367e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803681:	8b 50 04             	mov    0x4(%eax),%edx
  803684:	8b 45 08             	mov    0x8(%ebp),%eax
  803687:	89 50 04             	mov    %edx,0x4(%eax)
  80368a:	8b 45 08             	mov    0x8(%ebp),%eax
  80368d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803690:	89 10                	mov    %edx,(%eax)
  803692:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803695:	8b 40 04             	mov    0x4(%eax),%eax
  803698:	85 c0                	test   %eax,%eax
  80369a:	74 0d                	je     8036a9 <insert_sorted_with_merge_freeList+0x572>
  80369c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80369f:	8b 40 04             	mov    0x4(%eax),%eax
  8036a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8036a5:	89 10                	mov    %edx,(%eax)
  8036a7:	eb 08                	jmp    8036b1 <insert_sorted_with_merge_freeList+0x57a>
  8036a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ac:	a3 38 51 80 00       	mov    %eax,0x805138
  8036b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036b4:	8b 55 08             	mov    0x8(%ebp),%edx
  8036b7:	89 50 04             	mov    %edx,0x4(%eax)
  8036ba:	a1 44 51 80 00       	mov    0x805144,%eax
  8036bf:	40                   	inc    %eax
  8036c0:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  8036c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8036c8:	8b 50 0c             	mov    0xc(%eax),%edx
  8036cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036ce:	8b 40 0c             	mov    0xc(%eax),%eax
  8036d1:	01 c2                	add    %eax,%edx
  8036d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d6:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8036d9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8036dd:	75 17                	jne    8036f6 <insert_sorted_with_merge_freeList+0x5bf>
  8036df:	83 ec 04             	sub    $0x4,%esp
  8036e2:	68 04 45 80 00       	push   $0x804504
  8036e7:	68 6b 01 00 00       	push   $0x16b
  8036ec:	68 5b 44 80 00       	push   $0x80445b
  8036f1:	e8 28 d0 ff ff       	call   80071e <_panic>
  8036f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036f9:	8b 00                	mov    (%eax),%eax
  8036fb:	85 c0                	test   %eax,%eax
  8036fd:	74 10                	je     80370f <insert_sorted_with_merge_freeList+0x5d8>
  8036ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803702:	8b 00                	mov    (%eax),%eax
  803704:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803707:	8b 52 04             	mov    0x4(%edx),%edx
  80370a:	89 50 04             	mov    %edx,0x4(%eax)
  80370d:	eb 0b                	jmp    80371a <insert_sorted_with_merge_freeList+0x5e3>
  80370f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803712:	8b 40 04             	mov    0x4(%eax),%eax
  803715:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80371a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80371d:	8b 40 04             	mov    0x4(%eax),%eax
  803720:	85 c0                	test   %eax,%eax
  803722:	74 0f                	je     803733 <insert_sorted_with_merge_freeList+0x5fc>
  803724:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803727:	8b 40 04             	mov    0x4(%eax),%eax
  80372a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80372d:	8b 12                	mov    (%edx),%edx
  80372f:	89 10                	mov    %edx,(%eax)
  803731:	eb 0a                	jmp    80373d <insert_sorted_with_merge_freeList+0x606>
  803733:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803736:	8b 00                	mov    (%eax),%eax
  803738:	a3 38 51 80 00       	mov    %eax,0x805138
  80373d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803740:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803746:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803749:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803750:	a1 44 51 80 00       	mov    0x805144,%eax
  803755:	48                   	dec    %eax
  803756:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  80375b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80375e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803765:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803768:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80376f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803773:	75 17                	jne    80378c <insert_sorted_with_merge_freeList+0x655>
  803775:	83 ec 04             	sub    $0x4,%esp
  803778:	68 38 44 80 00       	push   $0x804438
  80377d:	68 6e 01 00 00       	push   $0x16e
  803782:	68 5b 44 80 00       	push   $0x80445b
  803787:	e8 92 cf ff ff       	call   80071e <_panic>
  80378c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803792:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803795:	89 10                	mov    %edx,(%eax)
  803797:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80379a:	8b 00                	mov    (%eax),%eax
  80379c:	85 c0                	test   %eax,%eax
  80379e:	74 0d                	je     8037ad <insert_sorted_with_merge_freeList+0x676>
  8037a0:	a1 48 51 80 00       	mov    0x805148,%eax
  8037a5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8037a8:	89 50 04             	mov    %edx,0x4(%eax)
  8037ab:	eb 08                	jmp    8037b5 <insert_sorted_with_merge_freeList+0x67e>
  8037ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037b0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8037b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037b8:	a3 48 51 80 00       	mov    %eax,0x805148
  8037bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037c0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037c7:	a1 54 51 80 00       	mov    0x805154,%eax
  8037cc:	40                   	inc    %eax
  8037cd:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8037d2:	e9 a9 00 00 00       	jmp    803880 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8037d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037db:	74 06                	je     8037e3 <insert_sorted_with_merge_freeList+0x6ac>
  8037dd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037e1:	75 17                	jne    8037fa <insert_sorted_with_merge_freeList+0x6c3>
  8037e3:	83 ec 04             	sub    $0x4,%esp
  8037e6:	68 d0 44 80 00       	push   $0x8044d0
  8037eb:	68 73 01 00 00       	push   $0x173
  8037f0:	68 5b 44 80 00       	push   $0x80445b
  8037f5:	e8 24 cf ff ff       	call   80071e <_panic>
  8037fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037fd:	8b 10                	mov    (%eax),%edx
  8037ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803802:	89 10                	mov    %edx,(%eax)
  803804:	8b 45 08             	mov    0x8(%ebp),%eax
  803807:	8b 00                	mov    (%eax),%eax
  803809:	85 c0                	test   %eax,%eax
  80380b:	74 0b                	je     803818 <insert_sorted_with_merge_freeList+0x6e1>
  80380d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803810:	8b 00                	mov    (%eax),%eax
  803812:	8b 55 08             	mov    0x8(%ebp),%edx
  803815:	89 50 04             	mov    %edx,0x4(%eax)
  803818:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80381b:	8b 55 08             	mov    0x8(%ebp),%edx
  80381e:	89 10                	mov    %edx,(%eax)
  803820:	8b 45 08             	mov    0x8(%ebp),%eax
  803823:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803826:	89 50 04             	mov    %edx,0x4(%eax)
  803829:	8b 45 08             	mov    0x8(%ebp),%eax
  80382c:	8b 00                	mov    (%eax),%eax
  80382e:	85 c0                	test   %eax,%eax
  803830:	75 08                	jne    80383a <insert_sorted_with_merge_freeList+0x703>
  803832:	8b 45 08             	mov    0x8(%ebp),%eax
  803835:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80383a:	a1 44 51 80 00       	mov    0x805144,%eax
  80383f:	40                   	inc    %eax
  803840:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803845:	eb 39                	jmp    803880 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803847:	a1 40 51 80 00       	mov    0x805140,%eax
  80384c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80384f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803853:	74 07                	je     80385c <insert_sorted_with_merge_freeList+0x725>
  803855:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803858:	8b 00                	mov    (%eax),%eax
  80385a:	eb 05                	jmp    803861 <insert_sorted_with_merge_freeList+0x72a>
  80385c:	b8 00 00 00 00       	mov    $0x0,%eax
  803861:	a3 40 51 80 00       	mov    %eax,0x805140
  803866:	a1 40 51 80 00       	mov    0x805140,%eax
  80386b:	85 c0                	test   %eax,%eax
  80386d:	0f 85 c7 fb ff ff    	jne    80343a <insert_sorted_with_merge_freeList+0x303>
  803873:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803877:	0f 85 bd fb ff ff    	jne    80343a <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80387d:	eb 01                	jmp    803880 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80387f:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803880:	90                   	nop
  803881:	c9                   	leave  
  803882:	c3                   	ret    

00803883 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803883:	55                   	push   %ebp
  803884:	89 e5                	mov    %esp,%ebp
  803886:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803889:	8b 55 08             	mov    0x8(%ebp),%edx
  80388c:	89 d0                	mov    %edx,%eax
  80388e:	c1 e0 02             	shl    $0x2,%eax
  803891:	01 d0                	add    %edx,%eax
  803893:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80389a:	01 d0                	add    %edx,%eax
  80389c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8038a3:	01 d0                	add    %edx,%eax
  8038a5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8038ac:	01 d0                	add    %edx,%eax
  8038ae:	c1 e0 04             	shl    $0x4,%eax
  8038b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8038b4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8038bb:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8038be:	83 ec 0c             	sub    $0xc,%esp
  8038c1:	50                   	push   %eax
  8038c2:	e8 26 e7 ff ff       	call   801fed <sys_get_virtual_time>
  8038c7:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8038ca:	eb 41                	jmp    80390d <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8038cc:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8038cf:	83 ec 0c             	sub    $0xc,%esp
  8038d2:	50                   	push   %eax
  8038d3:	e8 15 e7 ff ff       	call   801fed <sys_get_virtual_time>
  8038d8:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8038db:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8038de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038e1:	29 c2                	sub    %eax,%edx
  8038e3:	89 d0                	mov    %edx,%eax
  8038e5:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8038e8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038ee:	89 d1                	mov    %edx,%ecx
  8038f0:	29 c1                	sub    %eax,%ecx
  8038f2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8038f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8038f8:	39 c2                	cmp    %eax,%edx
  8038fa:	0f 97 c0             	seta   %al
  8038fd:	0f b6 c0             	movzbl %al,%eax
  803900:	29 c1                	sub    %eax,%ecx
  803902:	89 c8                	mov    %ecx,%eax
  803904:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803907:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80390a:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  80390d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803910:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803913:	72 b7                	jb     8038cc <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803915:	90                   	nop
  803916:	c9                   	leave  
  803917:	c3                   	ret    

00803918 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803918:	55                   	push   %ebp
  803919:	89 e5                	mov    %esp,%ebp
  80391b:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  80391e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803925:	eb 03                	jmp    80392a <busy_wait+0x12>
  803927:	ff 45 fc             	incl   -0x4(%ebp)
  80392a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80392d:	3b 45 08             	cmp    0x8(%ebp),%eax
  803930:	72 f5                	jb     803927 <busy_wait+0xf>
	return i;
  803932:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803935:	c9                   	leave  
  803936:	c3                   	ret    
  803937:	90                   	nop

00803938 <__udivdi3>:
  803938:	55                   	push   %ebp
  803939:	57                   	push   %edi
  80393a:	56                   	push   %esi
  80393b:	53                   	push   %ebx
  80393c:	83 ec 1c             	sub    $0x1c,%esp
  80393f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803943:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803947:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80394b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80394f:	89 ca                	mov    %ecx,%edx
  803951:	89 f8                	mov    %edi,%eax
  803953:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803957:	85 f6                	test   %esi,%esi
  803959:	75 2d                	jne    803988 <__udivdi3+0x50>
  80395b:	39 cf                	cmp    %ecx,%edi
  80395d:	77 65                	ja     8039c4 <__udivdi3+0x8c>
  80395f:	89 fd                	mov    %edi,%ebp
  803961:	85 ff                	test   %edi,%edi
  803963:	75 0b                	jne    803970 <__udivdi3+0x38>
  803965:	b8 01 00 00 00       	mov    $0x1,%eax
  80396a:	31 d2                	xor    %edx,%edx
  80396c:	f7 f7                	div    %edi
  80396e:	89 c5                	mov    %eax,%ebp
  803970:	31 d2                	xor    %edx,%edx
  803972:	89 c8                	mov    %ecx,%eax
  803974:	f7 f5                	div    %ebp
  803976:	89 c1                	mov    %eax,%ecx
  803978:	89 d8                	mov    %ebx,%eax
  80397a:	f7 f5                	div    %ebp
  80397c:	89 cf                	mov    %ecx,%edi
  80397e:	89 fa                	mov    %edi,%edx
  803980:	83 c4 1c             	add    $0x1c,%esp
  803983:	5b                   	pop    %ebx
  803984:	5e                   	pop    %esi
  803985:	5f                   	pop    %edi
  803986:	5d                   	pop    %ebp
  803987:	c3                   	ret    
  803988:	39 ce                	cmp    %ecx,%esi
  80398a:	77 28                	ja     8039b4 <__udivdi3+0x7c>
  80398c:	0f bd fe             	bsr    %esi,%edi
  80398f:	83 f7 1f             	xor    $0x1f,%edi
  803992:	75 40                	jne    8039d4 <__udivdi3+0x9c>
  803994:	39 ce                	cmp    %ecx,%esi
  803996:	72 0a                	jb     8039a2 <__udivdi3+0x6a>
  803998:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80399c:	0f 87 9e 00 00 00    	ja     803a40 <__udivdi3+0x108>
  8039a2:	b8 01 00 00 00       	mov    $0x1,%eax
  8039a7:	89 fa                	mov    %edi,%edx
  8039a9:	83 c4 1c             	add    $0x1c,%esp
  8039ac:	5b                   	pop    %ebx
  8039ad:	5e                   	pop    %esi
  8039ae:	5f                   	pop    %edi
  8039af:	5d                   	pop    %ebp
  8039b0:	c3                   	ret    
  8039b1:	8d 76 00             	lea    0x0(%esi),%esi
  8039b4:	31 ff                	xor    %edi,%edi
  8039b6:	31 c0                	xor    %eax,%eax
  8039b8:	89 fa                	mov    %edi,%edx
  8039ba:	83 c4 1c             	add    $0x1c,%esp
  8039bd:	5b                   	pop    %ebx
  8039be:	5e                   	pop    %esi
  8039bf:	5f                   	pop    %edi
  8039c0:	5d                   	pop    %ebp
  8039c1:	c3                   	ret    
  8039c2:	66 90                	xchg   %ax,%ax
  8039c4:	89 d8                	mov    %ebx,%eax
  8039c6:	f7 f7                	div    %edi
  8039c8:	31 ff                	xor    %edi,%edi
  8039ca:	89 fa                	mov    %edi,%edx
  8039cc:	83 c4 1c             	add    $0x1c,%esp
  8039cf:	5b                   	pop    %ebx
  8039d0:	5e                   	pop    %esi
  8039d1:	5f                   	pop    %edi
  8039d2:	5d                   	pop    %ebp
  8039d3:	c3                   	ret    
  8039d4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8039d9:	89 eb                	mov    %ebp,%ebx
  8039db:	29 fb                	sub    %edi,%ebx
  8039dd:	89 f9                	mov    %edi,%ecx
  8039df:	d3 e6                	shl    %cl,%esi
  8039e1:	89 c5                	mov    %eax,%ebp
  8039e3:	88 d9                	mov    %bl,%cl
  8039e5:	d3 ed                	shr    %cl,%ebp
  8039e7:	89 e9                	mov    %ebp,%ecx
  8039e9:	09 f1                	or     %esi,%ecx
  8039eb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8039ef:	89 f9                	mov    %edi,%ecx
  8039f1:	d3 e0                	shl    %cl,%eax
  8039f3:	89 c5                	mov    %eax,%ebp
  8039f5:	89 d6                	mov    %edx,%esi
  8039f7:	88 d9                	mov    %bl,%cl
  8039f9:	d3 ee                	shr    %cl,%esi
  8039fb:	89 f9                	mov    %edi,%ecx
  8039fd:	d3 e2                	shl    %cl,%edx
  8039ff:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a03:	88 d9                	mov    %bl,%cl
  803a05:	d3 e8                	shr    %cl,%eax
  803a07:	09 c2                	or     %eax,%edx
  803a09:	89 d0                	mov    %edx,%eax
  803a0b:	89 f2                	mov    %esi,%edx
  803a0d:	f7 74 24 0c          	divl   0xc(%esp)
  803a11:	89 d6                	mov    %edx,%esi
  803a13:	89 c3                	mov    %eax,%ebx
  803a15:	f7 e5                	mul    %ebp
  803a17:	39 d6                	cmp    %edx,%esi
  803a19:	72 19                	jb     803a34 <__udivdi3+0xfc>
  803a1b:	74 0b                	je     803a28 <__udivdi3+0xf0>
  803a1d:	89 d8                	mov    %ebx,%eax
  803a1f:	31 ff                	xor    %edi,%edi
  803a21:	e9 58 ff ff ff       	jmp    80397e <__udivdi3+0x46>
  803a26:	66 90                	xchg   %ax,%ax
  803a28:	8b 54 24 08          	mov    0x8(%esp),%edx
  803a2c:	89 f9                	mov    %edi,%ecx
  803a2e:	d3 e2                	shl    %cl,%edx
  803a30:	39 c2                	cmp    %eax,%edx
  803a32:	73 e9                	jae    803a1d <__udivdi3+0xe5>
  803a34:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803a37:	31 ff                	xor    %edi,%edi
  803a39:	e9 40 ff ff ff       	jmp    80397e <__udivdi3+0x46>
  803a3e:	66 90                	xchg   %ax,%ax
  803a40:	31 c0                	xor    %eax,%eax
  803a42:	e9 37 ff ff ff       	jmp    80397e <__udivdi3+0x46>
  803a47:	90                   	nop

00803a48 <__umoddi3>:
  803a48:	55                   	push   %ebp
  803a49:	57                   	push   %edi
  803a4a:	56                   	push   %esi
  803a4b:	53                   	push   %ebx
  803a4c:	83 ec 1c             	sub    $0x1c,%esp
  803a4f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803a53:	8b 74 24 34          	mov    0x34(%esp),%esi
  803a57:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803a5b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803a5f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803a63:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803a67:	89 f3                	mov    %esi,%ebx
  803a69:	89 fa                	mov    %edi,%edx
  803a6b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803a6f:	89 34 24             	mov    %esi,(%esp)
  803a72:	85 c0                	test   %eax,%eax
  803a74:	75 1a                	jne    803a90 <__umoddi3+0x48>
  803a76:	39 f7                	cmp    %esi,%edi
  803a78:	0f 86 a2 00 00 00    	jbe    803b20 <__umoddi3+0xd8>
  803a7e:	89 c8                	mov    %ecx,%eax
  803a80:	89 f2                	mov    %esi,%edx
  803a82:	f7 f7                	div    %edi
  803a84:	89 d0                	mov    %edx,%eax
  803a86:	31 d2                	xor    %edx,%edx
  803a88:	83 c4 1c             	add    $0x1c,%esp
  803a8b:	5b                   	pop    %ebx
  803a8c:	5e                   	pop    %esi
  803a8d:	5f                   	pop    %edi
  803a8e:	5d                   	pop    %ebp
  803a8f:	c3                   	ret    
  803a90:	39 f0                	cmp    %esi,%eax
  803a92:	0f 87 ac 00 00 00    	ja     803b44 <__umoddi3+0xfc>
  803a98:	0f bd e8             	bsr    %eax,%ebp
  803a9b:	83 f5 1f             	xor    $0x1f,%ebp
  803a9e:	0f 84 ac 00 00 00    	je     803b50 <__umoddi3+0x108>
  803aa4:	bf 20 00 00 00       	mov    $0x20,%edi
  803aa9:	29 ef                	sub    %ebp,%edi
  803aab:	89 fe                	mov    %edi,%esi
  803aad:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803ab1:	89 e9                	mov    %ebp,%ecx
  803ab3:	d3 e0                	shl    %cl,%eax
  803ab5:	89 d7                	mov    %edx,%edi
  803ab7:	89 f1                	mov    %esi,%ecx
  803ab9:	d3 ef                	shr    %cl,%edi
  803abb:	09 c7                	or     %eax,%edi
  803abd:	89 e9                	mov    %ebp,%ecx
  803abf:	d3 e2                	shl    %cl,%edx
  803ac1:	89 14 24             	mov    %edx,(%esp)
  803ac4:	89 d8                	mov    %ebx,%eax
  803ac6:	d3 e0                	shl    %cl,%eax
  803ac8:	89 c2                	mov    %eax,%edx
  803aca:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ace:	d3 e0                	shl    %cl,%eax
  803ad0:	89 44 24 04          	mov    %eax,0x4(%esp)
  803ad4:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ad8:	89 f1                	mov    %esi,%ecx
  803ada:	d3 e8                	shr    %cl,%eax
  803adc:	09 d0                	or     %edx,%eax
  803ade:	d3 eb                	shr    %cl,%ebx
  803ae0:	89 da                	mov    %ebx,%edx
  803ae2:	f7 f7                	div    %edi
  803ae4:	89 d3                	mov    %edx,%ebx
  803ae6:	f7 24 24             	mull   (%esp)
  803ae9:	89 c6                	mov    %eax,%esi
  803aeb:	89 d1                	mov    %edx,%ecx
  803aed:	39 d3                	cmp    %edx,%ebx
  803aef:	0f 82 87 00 00 00    	jb     803b7c <__umoddi3+0x134>
  803af5:	0f 84 91 00 00 00    	je     803b8c <__umoddi3+0x144>
  803afb:	8b 54 24 04          	mov    0x4(%esp),%edx
  803aff:	29 f2                	sub    %esi,%edx
  803b01:	19 cb                	sbb    %ecx,%ebx
  803b03:	89 d8                	mov    %ebx,%eax
  803b05:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803b09:	d3 e0                	shl    %cl,%eax
  803b0b:	89 e9                	mov    %ebp,%ecx
  803b0d:	d3 ea                	shr    %cl,%edx
  803b0f:	09 d0                	or     %edx,%eax
  803b11:	89 e9                	mov    %ebp,%ecx
  803b13:	d3 eb                	shr    %cl,%ebx
  803b15:	89 da                	mov    %ebx,%edx
  803b17:	83 c4 1c             	add    $0x1c,%esp
  803b1a:	5b                   	pop    %ebx
  803b1b:	5e                   	pop    %esi
  803b1c:	5f                   	pop    %edi
  803b1d:	5d                   	pop    %ebp
  803b1e:	c3                   	ret    
  803b1f:	90                   	nop
  803b20:	89 fd                	mov    %edi,%ebp
  803b22:	85 ff                	test   %edi,%edi
  803b24:	75 0b                	jne    803b31 <__umoddi3+0xe9>
  803b26:	b8 01 00 00 00       	mov    $0x1,%eax
  803b2b:	31 d2                	xor    %edx,%edx
  803b2d:	f7 f7                	div    %edi
  803b2f:	89 c5                	mov    %eax,%ebp
  803b31:	89 f0                	mov    %esi,%eax
  803b33:	31 d2                	xor    %edx,%edx
  803b35:	f7 f5                	div    %ebp
  803b37:	89 c8                	mov    %ecx,%eax
  803b39:	f7 f5                	div    %ebp
  803b3b:	89 d0                	mov    %edx,%eax
  803b3d:	e9 44 ff ff ff       	jmp    803a86 <__umoddi3+0x3e>
  803b42:	66 90                	xchg   %ax,%ax
  803b44:	89 c8                	mov    %ecx,%eax
  803b46:	89 f2                	mov    %esi,%edx
  803b48:	83 c4 1c             	add    $0x1c,%esp
  803b4b:	5b                   	pop    %ebx
  803b4c:	5e                   	pop    %esi
  803b4d:	5f                   	pop    %edi
  803b4e:	5d                   	pop    %ebp
  803b4f:	c3                   	ret    
  803b50:	3b 04 24             	cmp    (%esp),%eax
  803b53:	72 06                	jb     803b5b <__umoddi3+0x113>
  803b55:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803b59:	77 0f                	ja     803b6a <__umoddi3+0x122>
  803b5b:	89 f2                	mov    %esi,%edx
  803b5d:	29 f9                	sub    %edi,%ecx
  803b5f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803b63:	89 14 24             	mov    %edx,(%esp)
  803b66:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803b6a:	8b 44 24 04          	mov    0x4(%esp),%eax
  803b6e:	8b 14 24             	mov    (%esp),%edx
  803b71:	83 c4 1c             	add    $0x1c,%esp
  803b74:	5b                   	pop    %ebx
  803b75:	5e                   	pop    %esi
  803b76:	5f                   	pop    %edi
  803b77:	5d                   	pop    %ebp
  803b78:	c3                   	ret    
  803b79:	8d 76 00             	lea    0x0(%esi),%esi
  803b7c:	2b 04 24             	sub    (%esp),%eax
  803b7f:	19 fa                	sbb    %edi,%edx
  803b81:	89 d1                	mov    %edx,%ecx
  803b83:	89 c6                	mov    %eax,%esi
  803b85:	e9 71 ff ff ff       	jmp    803afb <__umoddi3+0xb3>
  803b8a:	66 90                	xchg   %ax,%ax
  803b8c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803b90:	72 ea                	jb     803b7c <__umoddi3+0x134>
  803b92:	89 d9                	mov    %ebx,%ecx
  803b94:	e9 62 ff ff ff       	jmp    803afb <__umoddi3+0xb3>
