
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
  80008a:	68 60 22 80 00       	push   $0x802260
  80008f:	e8 3e 09 00 00       	call   8009d2 <cprintf>
  800094:	83 c4 10             	add    $0x10,%esp
		int32 envIdFib = sys_create_env("fib", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  800097:	a1 20 30 80 00       	mov    0x803020,%eax
  80009c:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  8000a2:	a1 20 30 80 00       	mov    0x803020,%eax
  8000a7:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8000ad:	89 c1                	mov    %eax,%ecx
  8000af:	a1 20 30 80 00       	mov    0x803020,%eax
  8000b4:	8b 40 74             	mov    0x74(%eax),%eax
  8000b7:	52                   	push   %edx
  8000b8:	51                   	push   %ecx
  8000b9:	50                   	push   %eax
  8000ba:	68 92 22 80 00       	push   $0x802292
  8000bf:	e8 75 1b 00 00       	call   801c39 <sys_create_env>
  8000c4:	83 c4 10             	add    $0x10,%esp
  8000c7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		int freeFrames = sys_calculate_free_frames() ;
  8000ca:	e8 f8 18 00 00       	call   8019c7 <sys_calculate_free_frames>
  8000cf:	89 45 d8             	mov    %eax,-0x28(%ebp)
		int32 envIdHelloWorld = sys_create_env("fos_helloWorld", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8000d2:	a1 20 30 80 00       	mov    0x803020,%eax
  8000d7:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  8000dd:	a1 20 30 80 00       	mov    0x803020,%eax
  8000e2:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8000e8:	89 c1                	mov    %eax,%ecx
  8000ea:	a1 20 30 80 00       	mov    0x803020,%eax
  8000ef:	8b 40 74             	mov    0x74(%eax),%eax
  8000f2:	52                   	push   %edx
  8000f3:	51                   	push   %ecx
  8000f4:	50                   	push   %eax
  8000f5:	68 96 22 80 00       	push   $0x802296
  8000fa:	e8 3a 1b 00 00       	call   801c39 <sys_create_env>
  8000ff:	83 c4 10             	add    $0x10,%esp
  800102:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		int helloWorldFrames = freeFrames - sys_calculate_free_frames() ;
  800105:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800108:	e8 ba 18 00 00       	call   8019c7 <sys_calculate_free_frames>
  80010d:	29 c3                	sub    %eax,%ebx
  80010f:	89 d8                	mov    %ebx,%eax
  800111:	89 45 d0             	mov    %eax,-0x30(%ebp)
		env_sleep(2000);
  800114:	83 ec 0c             	sub    $0xc,%esp
  800117:	68 d0 07 00 00       	push   $0x7d0
  80011c:	e8 18 1e 00 00       	call   801f39 <env_sleep>
  800121:	83 c4 10             	add    $0x10,%esp
		cprintf("[DONE]\n\n");
  800124:	83 ec 0c             	sub    $0xc,%esp
  800127:	68 a5 22 80 00       	push   $0x8022a5
  80012c:	e8 a1 08 00 00       	call   8009d2 <cprintf>
  800131:	83 c4 10             	add    $0x10,%esp

		//Load and run "fos_add"
		cprintf("Loading fos_add program into RAM...");
  800134:	83 ec 0c             	sub    $0xc,%esp
  800137:	68 b0 22 80 00       	push   $0x8022b0
  80013c:	e8 91 08 00 00       	call   8009d2 <cprintf>
  800141:	83 c4 10             	add    $0x10,%esp
		int32 envIdFOSAdd= sys_create_env("fos_add", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  800144:	a1 20 30 80 00       	mov    0x803020,%eax
  800149:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  80014f:	a1 20 30 80 00       	mov    0x803020,%eax
  800154:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80015a:	89 c1                	mov    %eax,%ecx
  80015c:	a1 20 30 80 00       	mov    0x803020,%eax
  800161:	8b 40 74             	mov    0x74(%eax),%eax
  800164:	52                   	push   %edx
  800165:	51                   	push   %ecx
  800166:	50                   	push   %eax
  800167:	68 d4 22 80 00       	push   $0x8022d4
  80016c:	e8 c8 1a 00 00       	call   801c39 <sys_create_env>
  800171:	83 c4 10             	add    $0x10,%esp
  800174:	89 45 cc             	mov    %eax,-0x34(%ebp)
		env_sleep(2000);
  800177:	83 ec 0c             	sub    $0xc,%esp
  80017a:	68 d0 07 00 00       	push   $0x7d0
  80017f:	e8 b5 1d 00 00       	call   801f39 <env_sleep>
  800184:	83 c4 10             	add    $0x10,%esp
		cprintf("[DONE]\n\n");
  800187:	83 ec 0c             	sub    $0xc,%esp
  80018a:	68 a5 22 80 00       	push   $0x8022a5
  80018f:	e8 3e 08 00 00       	call   8009d2 <cprintf>
  800194:	83 c4 10             	add    $0x10,%esp
		cprintf("running fos_add program...\n\n");
  800197:	83 ec 0c             	sub    $0xc,%esp
  80019a:	68 dc 22 80 00       	push   $0x8022dc
  80019f:	e8 2e 08 00 00       	call   8009d2 <cprintf>
  8001a4:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdFOSAdd);
  8001a7:	83 ec 0c             	sub    $0xc,%esp
  8001aa:	ff 75 cc             	pushl  -0x34(%ebp)
  8001ad:	e8 a5 1a 00 00       	call   801c57 <sys_run_env>
  8001b2:	83 c4 10             	add    $0x10,%esp

		cprintf("please be patient ...\n");
  8001b5:	83 ec 0c             	sub    $0xc,%esp
  8001b8:	68 f9 22 80 00       	push   $0x8022f9
  8001bd:	e8 10 08 00 00       	call   8009d2 <cprintf>
  8001c2:	83 c4 10             	add    $0x10,%esp
		env_sleep(5000);
  8001c5:	83 ec 0c             	sub    $0xc,%esp
  8001c8:	68 88 13 00 00       	push   $0x1388
  8001cd:	e8 67 1d 00 00       	call   801f39 <env_sleep>
  8001d2:	83 c4 10             	add    $0x10,%esp

		//Allocate 2 MB
		ptr_allocations[0] = malloc(2*Mega-kilo);
  8001d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001d8:	01 c0                	add    %eax,%eax
  8001da:	2b 45 f0             	sub    -0x10(%ebp),%eax
  8001dd:	83 ec 0c             	sub    $0xc,%esp
  8001e0:	50                   	push   %eax
  8001e1:	e8 c1 15 00 00       	call   8017a7 <malloc>
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
  800225:	e8 7d 15 00 00       	call   8017a7 <malloc>
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
  800266:	e8 5c 17 00 00       	call   8019c7 <sys_calculate_free_frames>
  80026b:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[2] = malloc(freeFrames*PAGE_SIZE);
  80026e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800271:	c1 e0 0c             	shl    $0xc,%eax
  800274:	83 ec 0c             	sub    $0xc,%esp
  800277:	50                   	push   %eax
  800278:	e8 2a 15 00 00       	call   8017a7 <malloc>
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
  8002c9:	e8 d9 14 00 00       	call   8017a7 <malloc>
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
  800352:	68 10 23 80 00       	push   $0x802310
  800357:	e8 76 06 00 00       	call   8009d2 <cprintf>
  80035c:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdHelloWorld);
  80035f:	83 ec 0c             	sub    $0xc,%esp
  800362:	ff 75 d4             	pushl  -0x2c(%ebp)
  800365:	e8 ed 18 00 00       	call   801c57 <sys_run_env>
  80036a:	83 c4 10             	add    $0x10,%esp

		cprintf("please be patient ...\n");
  80036d:	83 ec 0c             	sub    $0xc,%esp
  800370:	68 f9 22 80 00       	push   $0x8022f9
  800375:	e8 58 06 00 00       	call   8009d2 <cprintf>
  80037a:	83 c4 10             	add    $0x10,%esp
		env_sleep(5000);
  80037d:	83 ec 0c             	sub    $0xc,%esp
  800380:	68 88 13 00 00       	push   $0x1388
  800385:	e8 af 1b 00 00       	call   801f39 <env_sleep>
  80038a:	83 c4 10             	add    $0x10,%esp

		//Allocate the remaining RAM + extra RAM by the size of helloWorld program (Here: it requires to free some RAM by removing exited & loaded program(s) (fos_helloWorld & fib))
		freeFrames = sys_calculate_free_frames() ;
  80038d:	e8 35 16 00 00       	call   8019c7 <sys_calculate_free_frames>
  800392:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[4] = malloc((freeFrames + helloWorldFrames)*PAGE_SIZE);
  800395:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800398:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80039b:	01 d0                	add    %edx,%eax
  80039d:	c1 e0 0c             	shl    $0xc,%eax
  8003a0:	83 ec 0c             	sub    $0xc,%esp
  8003a3:	50                   	push   %eax
  8003a4:	e8 fe 13 00 00       	call   8017a7 <malloc>
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
  8003ee:	e8 b4 13 00 00       	call   8017a7 <malloc>
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
  800444:	68 34 23 80 00       	push   $0x802334
  800449:	6a 62                	push   $0x62
  80044b:	68 69 23 80 00       	push   $0x802369
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
  800479:	68 34 23 80 00       	push   $0x802334
  80047e:	6a 63                	push   $0x63
  800480:	68 69 23 80 00       	push   $0x802369
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
  8004ad:	68 34 23 80 00       	push   $0x802334
  8004b2:	6a 64                	push   $0x64
  8004b4:	68 69 23 80 00       	push   $0x802369
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
  8004e1:	68 34 23 80 00       	push   $0x802334
  8004e6:	6a 65                	push   $0x65
  8004e8:	68 69 23 80 00       	push   $0x802369
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
  800515:	68 34 23 80 00       	push   $0x802334
  80051a:	6a 66                	push   $0x66
  80051c:	68 69 23 80 00       	push   $0x802369
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
  800549:	68 34 23 80 00       	push   $0x802334
  80054e:	6a 68                	push   $0x68
  800550:	68 69 23 80 00       	push   $0x802369
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
  800583:	68 34 23 80 00       	push   $0x802334
  800588:	6a 69                	push   $0x69
  80058a:	68 69 23 80 00       	push   $0x802369
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
  8005b9:	68 34 23 80 00       	push   $0x802334
  8005be:	6a 6a                	push   $0x6a
  8005c0:	68 69 23 80 00       	push   $0x802369
  8005c5:	e8 54 01 00 00       	call   80071e <_panic>


	}

	cprintf("Congratulations!! test freeRAM (1) completed successfully.\n");
  8005ca:	83 ec 0c             	sub    $0xc,%esp
  8005cd:	68 80 23 80 00       	push   $0x802380
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
  8005e8:	e8 ba 16 00 00       	call   801ca7 <sys_getenvindex>
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
  80060f:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800614:	a1 20 30 80 00       	mov    0x803020,%eax
  800619:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80061f:	84 c0                	test   %al,%al
  800621:	74 0f                	je     800632 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800623:	a1 20 30 80 00       	mov    0x803020,%eax
  800628:	05 5c 05 00 00       	add    $0x55c,%eax
  80062d:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800632:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800636:	7e 0a                	jle    800642 <libmain+0x60>
		binaryname = argv[0];
  800638:	8b 45 0c             	mov    0xc(%ebp),%eax
  80063b:	8b 00                	mov    (%eax),%eax
  80063d:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800642:	83 ec 08             	sub    $0x8,%esp
  800645:	ff 75 0c             	pushl  0xc(%ebp)
  800648:	ff 75 08             	pushl  0x8(%ebp)
  80064b:	e8 e8 f9 ff ff       	call   800038 <_main>
  800650:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800653:	e8 5c 14 00 00       	call   801ab4 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800658:	83 ec 0c             	sub    $0xc,%esp
  80065b:	68 d4 23 80 00       	push   $0x8023d4
  800660:	e8 6d 03 00 00       	call   8009d2 <cprintf>
  800665:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800668:	a1 20 30 80 00       	mov    0x803020,%eax
  80066d:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800673:	a1 20 30 80 00       	mov    0x803020,%eax
  800678:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80067e:	83 ec 04             	sub    $0x4,%esp
  800681:	52                   	push   %edx
  800682:	50                   	push   %eax
  800683:	68 fc 23 80 00       	push   $0x8023fc
  800688:	e8 45 03 00 00       	call   8009d2 <cprintf>
  80068d:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800690:	a1 20 30 80 00       	mov    0x803020,%eax
  800695:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80069b:	a1 20 30 80 00       	mov    0x803020,%eax
  8006a0:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8006a6:	a1 20 30 80 00       	mov    0x803020,%eax
  8006ab:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8006b1:	51                   	push   %ecx
  8006b2:	52                   	push   %edx
  8006b3:	50                   	push   %eax
  8006b4:	68 24 24 80 00       	push   $0x802424
  8006b9:	e8 14 03 00 00       	call   8009d2 <cprintf>
  8006be:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8006c1:	a1 20 30 80 00       	mov    0x803020,%eax
  8006c6:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8006cc:	83 ec 08             	sub    $0x8,%esp
  8006cf:	50                   	push   %eax
  8006d0:	68 7c 24 80 00       	push   $0x80247c
  8006d5:	e8 f8 02 00 00       	call   8009d2 <cprintf>
  8006da:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8006dd:	83 ec 0c             	sub    $0xc,%esp
  8006e0:	68 d4 23 80 00       	push   $0x8023d4
  8006e5:	e8 e8 02 00 00       	call   8009d2 <cprintf>
  8006ea:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8006ed:	e8 dc 13 00 00       	call   801ace <sys_enable_interrupt>

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
  800705:	e8 69 15 00 00       	call   801c73 <sys_destroy_env>
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
  800716:	e8 be 15 00 00       	call   801cd9 <sys_exit_env>
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
  80072d:	a1 5c 31 80 00       	mov    0x80315c,%eax
  800732:	85 c0                	test   %eax,%eax
  800734:	74 16                	je     80074c <_panic+0x2e>
		cprintf("%s: ", argv0);
  800736:	a1 5c 31 80 00       	mov    0x80315c,%eax
  80073b:	83 ec 08             	sub    $0x8,%esp
  80073e:	50                   	push   %eax
  80073f:	68 90 24 80 00       	push   $0x802490
  800744:	e8 89 02 00 00       	call   8009d2 <cprintf>
  800749:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80074c:	a1 00 30 80 00       	mov    0x803000,%eax
  800751:	ff 75 0c             	pushl  0xc(%ebp)
  800754:	ff 75 08             	pushl  0x8(%ebp)
  800757:	50                   	push   %eax
  800758:	68 95 24 80 00       	push   $0x802495
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
  80077c:	68 b1 24 80 00       	push   $0x8024b1
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
  800796:	a1 20 30 80 00       	mov    0x803020,%eax
  80079b:	8b 50 74             	mov    0x74(%eax),%edx
  80079e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007a1:	39 c2                	cmp    %eax,%edx
  8007a3:	74 14                	je     8007b9 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8007a5:	83 ec 04             	sub    $0x4,%esp
  8007a8:	68 b4 24 80 00       	push   $0x8024b4
  8007ad:	6a 26                	push   $0x26
  8007af:	68 00 25 80 00       	push   $0x802500
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
  8007f9:	a1 20 30 80 00       	mov    0x803020,%eax
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
  800819:	a1 20 30 80 00       	mov    0x803020,%eax
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
  800862:	a1 20 30 80 00       	mov    0x803020,%eax
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
  80087a:	68 0c 25 80 00       	push   $0x80250c
  80087f:	6a 3a                	push   $0x3a
  800881:	68 00 25 80 00       	push   $0x802500
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
  8008aa:	a1 20 30 80 00       	mov    0x803020,%eax
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
  8008d0:	a1 20 30 80 00       	mov    0x803020,%eax
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
  8008ea:	68 60 25 80 00       	push   $0x802560
  8008ef:	6a 44                	push   $0x44
  8008f1:	68 00 25 80 00       	push   $0x802500
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
  800929:	a0 24 30 80 00       	mov    0x803024,%al
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
  800944:	e8 bd 0f 00 00       	call   801906 <sys_cputs>
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
  80099e:	a0 24 30 80 00       	mov    0x803024,%al
  8009a3:	0f b6 c0             	movzbl %al,%eax
  8009a6:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8009ac:	83 ec 04             	sub    $0x4,%esp
  8009af:	50                   	push   %eax
  8009b0:	52                   	push   %edx
  8009b1:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009b7:	83 c0 08             	add    $0x8,%eax
  8009ba:	50                   	push   %eax
  8009bb:	e8 46 0f 00 00       	call   801906 <sys_cputs>
  8009c0:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8009c3:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
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
  8009d8:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
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
  800a05:	e8 aa 10 00 00       	call   801ab4 <sys_disable_interrupt>
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
  800a25:	e8 a4 10 00 00       	call   801ace <sys_enable_interrupt>
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
  800a6f:	e8 7c 15 00 00       	call   801ff0 <__udivdi3>
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
  800abf:	e8 3c 16 00 00       	call   802100 <__umoddi3>
  800ac4:	83 c4 10             	add    $0x10,%esp
  800ac7:	05 d4 27 80 00       	add    $0x8027d4,%eax
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
  800c1a:	8b 04 85 f8 27 80 00 	mov    0x8027f8(,%eax,4),%eax
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
  800cfb:	8b 34 9d 40 26 80 00 	mov    0x802640(,%ebx,4),%esi
  800d02:	85 f6                	test   %esi,%esi
  800d04:	75 19                	jne    800d1f <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d06:	53                   	push   %ebx
  800d07:	68 e5 27 80 00       	push   $0x8027e5
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
  800d20:	68 ee 27 80 00       	push   $0x8027ee
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
  800d4d:	be f1 27 80 00       	mov    $0x8027f1,%esi
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
  801762:	a1 04 30 80 00       	mov    0x803004,%eax
  801767:	85 c0                	test   %eax,%eax
  801769:	74 1f                	je     80178a <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  80176b:	e8 1d 00 00 00       	call   80178d <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801770:	83 ec 0c             	sub    $0xc,%esp
  801773:	68 50 29 80 00       	push   $0x802950
  801778:	e8 55 f2 ff ff       	call   8009d2 <cprintf>
  80177d:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801780:	c7 05 04 30 80 00 00 	movl   $0x0,0x803004
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
  801790:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	panic("initialize_dyn_block_system() is not implemented yet...!!");
  801793:	83 ec 04             	sub    $0x4,%esp
  801796:	68 78 29 80 00       	push   $0x802978
  80179b:	6a 21                	push   $0x21
  80179d:	68 b2 29 80 00       	push   $0x8029b2
  8017a2:	e8 77 ef ff ff       	call   80071e <_panic>

008017a7 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8017a7:	55                   	push   %ebp
  8017a8:	89 e5                	mov    %esp,%ebp
  8017aa:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017ad:	e8 aa ff ff ff       	call   80175c <InitializeUHeap>
	if (size == 0) return NULL ;
  8017b2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8017b6:	75 07                	jne    8017bf <malloc+0x18>
  8017b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8017bd:	eb 14                	jmp    8017d3 <malloc+0x2c>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  8017bf:	83 ec 04             	sub    $0x4,%esp
  8017c2:	68 c0 29 80 00       	push   $0x8029c0
  8017c7:	6a 39                	push   $0x39
  8017c9:	68 b2 29 80 00       	push   $0x8029b2
  8017ce:	e8 4b ef ff ff       	call   80071e <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  8017d3:	c9                   	leave  
  8017d4:	c3                   	ret    

008017d5 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8017d5:	55                   	push   %ebp
  8017d6:	89 e5                	mov    %esp,%ebp
  8017d8:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  8017db:	83 ec 04             	sub    $0x4,%esp
  8017de:	68 e8 29 80 00       	push   $0x8029e8
  8017e3:	6a 54                	push   $0x54
  8017e5:	68 b2 29 80 00       	push   $0x8029b2
  8017ea:	e8 2f ef ff ff       	call   80071e <_panic>

008017ef <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8017ef:	55                   	push   %ebp
  8017f0:	89 e5                	mov    %esp,%ebp
  8017f2:	83 ec 18             	sub    $0x18,%esp
  8017f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8017f8:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017fb:	e8 5c ff ff ff       	call   80175c <InitializeUHeap>
	if (size == 0) return NULL ;
  801800:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801804:	75 07                	jne    80180d <smalloc+0x1e>
  801806:	b8 00 00 00 00       	mov    $0x0,%eax
  80180b:	eb 14                	jmp    801821 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  80180d:	83 ec 04             	sub    $0x4,%esp
  801810:	68 0c 2a 80 00       	push   $0x802a0c
  801815:	6a 69                	push   $0x69
  801817:	68 b2 29 80 00       	push   $0x8029b2
  80181c:	e8 fd ee ff ff       	call   80071e <_panic>

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801821:	c9                   	leave  
  801822:	c3                   	ret    

00801823 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801823:	55                   	push   %ebp
  801824:	89 e5                	mov    %esp,%ebp
  801826:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801829:	e8 2e ff ff ff       	call   80175c <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  80182e:	83 ec 04             	sub    $0x4,%esp
  801831:	68 34 2a 80 00       	push   $0x802a34
  801836:	68 86 00 00 00       	push   $0x86
  80183b:	68 b2 29 80 00       	push   $0x8029b2
  801840:	e8 d9 ee ff ff       	call   80071e <_panic>

00801845 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801845:	55                   	push   %ebp
  801846:	89 e5                	mov    %esp,%ebp
  801848:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80184b:	e8 0c ff ff ff       	call   80175c <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801850:	83 ec 04             	sub    $0x4,%esp
  801853:	68 58 2a 80 00       	push   $0x802a58
  801858:	68 b8 00 00 00       	push   $0xb8
  80185d:	68 b2 29 80 00       	push   $0x8029b2
  801862:	e8 b7 ee ff ff       	call   80071e <_panic>

00801867 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801867:	55                   	push   %ebp
  801868:	89 e5                	mov    %esp,%ebp
  80186a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80186d:	83 ec 04             	sub    $0x4,%esp
  801870:	68 80 2a 80 00       	push   $0x802a80
  801875:	68 cc 00 00 00       	push   $0xcc
  80187a:	68 b2 29 80 00       	push   $0x8029b2
  80187f:	e8 9a ee ff ff       	call   80071e <_panic>

00801884 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801884:	55                   	push   %ebp
  801885:	89 e5                	mov    %esp,%ebp
  801887:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80188a:	83 ec 04             	sub    $0x4,%esp
  80188d:	68 a4 2a 80 00       	push   $0x802aa4
  801892:	68 d7 00 00 00       	push   $0xd7
  801897:	68 b2 29 80 00       	push   $0x8029b2
  80189c:	e8 7d ee ff ff       	call   80071e <_panic>

008018a1 <shrink>:

}
void shrink(uint32 newSize)
{
  8018a1:	55                   	push   %ebp
  8018a2:	89 e5                	mov    %esp,%ebp
  8018a4:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018a7:	83 ec 04             	sub    $0x4,%esp
  8018aa:	68 a4 2a 80 00       	push   $0x802aa4
  8018af:	68 dc 00 00 00       	push   $0xdc
  8018b4:	68 b2 29 80 00       	push   $0x8029b2
  8018b9:	e8 60 ee ff ff       	call   80071e <_panic>

008018be <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8018be:	55                   	push   %ebp
  8018bf:	89 e5                	mov    %esp,%ebp
  8018c1:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018c4:	83 ec 04             	sub    $0x4,%esp
  8018c7:	68 a4 2a 80 00       	push   $0x802aa4
  8018cc:	68 e1 00 00 00       	push   $0xe1
  8018d1:	68 b2 29 80 00       	push   $0x8029b2
  8018d6:	e8 43 ee ff ff       	call   80071e <_panic>

008018db <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8018db:	55                   	push   %ebp
  8018dc:	89 e5                	mov    %esp,%ebp
  8018de:	57                   	push   %edi
  8018df:	56                   	push   %esi
  8018e0:	53                   	push   %ebx
  8018e1:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ea:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018ed:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018f0:	8b 7d 18             	mov    0x18(%ebp),%edi
  8018f3:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8018f6:	cd 30                	int    $0x30
  8018f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8018fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018fe:	83 c4 10             	add    $0x10,%esp
  801901:	5b                   	pop    %ebx
  801902:	5e                   	pop    %esi
  801903:	5f                   	pop    %edi
  801904:	5d                   	pop    %ebp
  801905:	c3                   	ret    

00801906 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801906:	55                   	push   %ebp
  801907:	89 e5                	mov    %esp,%ebp
  801909:	83 ec 04             	sub    $0x4,%esp
  80190c:	8b 45 10             	mov    0x10(%ebp),%eax
  80190f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801912:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801916:	8b 45 08             	mov    0x8(%ebp),%eax
  801919:	6a 00                	push   $0x0
  80191b:	6a 00                	push   $0x0
  80191d:	52                   	push   %edx
  80191e:	ff 75 0c             	pushl  0xc(%ebp)
  801921:	50                   	push   %eax
  801922:	6a 00                	push   $0x0
  801924:	e8 b2 ff ff ff       	call   8018db <syscall>
  801929:	83 c4 18             	add    $0x18,%esp
}
  80192c:	90                   	nop
  80192d:	c9                   	leave  
  80192e:	c3                   	ret    

0080192f <sys_cgetc>:

int
sys_cgetc(void)
{
  80192f:	55                   	push   %ebp
  801930:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801932:	6a 00                	push   $0x0
  801934:	6a 00                	push   $0x0
  801936:	6a 00                	push   $0x0
  801938:	6a 00                	push   $0x0
  80193a:	6a 00                	push   $0x0
  80193c:	6a 01                	push   $0x1
  80193e:	e8 98 ff ff ff       	call   8018db <syscall>
  801943:	83 c4 18             	add    $0x18,%esp
}
  801946:	c9                   	leave  
  801947:	c3                   	ret    

00801948 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801948:	55                   	push   %ebp
  801949:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80194b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80194e:	8b 45 08             	mov    0x8(%ebp),%eax
  801951:	6a 00                	push   $0x0
  801953:	6a 00                	push   $0x0
  801955:	6a 00                	push   $0x0
  801957:	52                   	push   %edx
  801958:	50                   	push   %eax
  801959:	6a 05                	push   $0x5
  80195b:	e8 7b ff ff ff       	call   8018db <syscall>
  801960:	83 c4 18             	add    $0x18,%esp
}
  801963:	c9                   	leave  
  801964:	c3                   	ret    

00801965 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801965:	55                   	push   %ebp
  801966:	89 e5                	mov    %esp,%ebp
  801968:	56                   	push   %esi
  801969:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80196a:	8b 75 18             	mov    0x18(%ebp),%esi
  80196d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801970:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801973:	8b 55 0c             	mov    0xc(%ebp),%edx
  801976:	8b 45 08             	mov    0x8(%ebp),%eax
  801979:	56                   	push   %esi
  80197a:	53                   	push   %ebx
  80197b:	51                   	push   %ecx
  80197c:	52                   	push   %edx
  80197d:	50                   	push   %eax
  80197e:	6a 06                	push   $0x6
  801980:	e8 56 ff ff ff       	call   8018db <syscall>
  801985:	83 c4 18             	add    $0x18,%esp
}
  801988:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80198b:	5b                   	pop    %ebx
  80198c:	5e                   	pop    %esi
  80198d:	5d                   	pop    %ebp
  80198e:	c3                   	ret    

0080198f <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80198f:	55                   	push   %ebp
  801990:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801992:	8b 55 0c             	mov    0xc(%ebp),%edx
  801995:	8b 45 08             	mov    0x8(%ebp),%eax
  801998:	6a 00                	push   $0x0
  80199a:	6a 00                	push   $0x0
  80199c:	6a 00                	push   $0x0
  80199e:	52                   	push   %edx
  80199f:	50                   	push   %eax
  8019a0:	6a 07                	push   $0x7
  8019a2:	e8 34 ff ff ff       	call   8018db <syscall>
  8019a7:	83 c4 18             	add    $0x18,%esp
}
  8019aa:	c9                   	leave  
  8019ab:	c3                   	ret    

008019ac <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8019ac:	55                   	push   %ebp
  8019ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8019af:	6a 00                	push   $0x0
  8019b1:	6a 00                	push   $0x0
  8019b3:	6a 00                	push   $0x0
  8019b5:	ff 75 0c             	pushl  0xc(%ebp)
  8019b8:	ff 75 08             	pushl  0x8(%ebp)
  8019bb:	6a 08                	push   $0x8
  8019bd:	e8 19 ff ff ff       	call   8018db <syscall>
  8019c2:	83 c4 18             	add    $0x18,%esp
}
  8019c5:	c9                   	leave  
  8019c6:	c3                   	ret    

008019c7 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8019c7:	55                   	push   %ebp
  8019c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 00                	push   $0x0
  8019d0:	6a 00                	push   $0x0
  8019d2:	6a 00                	push   $0x0
  8019d4:	6a 09                	push   $0x9
  8019d6:	e8 00 ff ff ff       	call   8018db <syscall>
  8019db:	83 c4 18             	add    $0x18,%esp
}
  8019de:	c9                   	leave  
  8019df:	c3                   	ret    

008019e0 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8019e0:	55                   	push   %ebp
  8019e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 0a                	push   $0xa
  8019ef:	e8 e7 fe ff ff       	call   8018db <syscall>
  8019f4:	83 c4 18             	add    $0x18,%esp
}
  8019f7:	c9                   	leave  
  8019f8:	c3                   	ret    

008019f9 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8019f9:	55                   	push   %ebp
  8019fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8019fc:	6a 00                	push   $0x0
  8019fe:	6a 00                	push   $0x0
  801a00:	6a 00                	push   $0x0
  801a02:	6a 00                	push   $0x0
  801a04:	6a 00                	push   $0x0
  801a06:	6a 0b                	push   $0xb
  801a08:	e8 ce fe ff ff       	call   8018db <syscall>
  801a0d:	83 c4 18             	add    $0x18,%esp
}
  801a10:	c9                   	leave  
  801a11:	c3                   	ret    

00801a12 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801a12:	55                   	push   %ebp
  801a13:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801a15:	6a 00                	push   $0x0
  801a17:	6a 00                	push   $0x0
  801a19:	6a 00                	push   $0x0
  801a1b:	ff 75 0c             	pushl  0xc(%ebp)
  801a1e:	ff 75 08             	pushl  0x8(%ebp)
  801a21:	6a 0f                	push   $0xf
  801a23:	e8 b3 fe ff ff       	call   8018db <syscall>
  801a28:	83 c4 18             	add    $0x18,%esp
	return;
  801a2b:	90                   	nop
}
  801a2c:	c9                   	leave  
  801a2d:	c3                   	ret    

00801a2e <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a2e:	55                   	push   %ebp
  801a2f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801a31:	6a 00                	push   $0x0
  801a33:	6a 00                	push   $0x0
  801a35:	6a 00                	push   $0x0
  801a37:	ff 75 0c             	pushl  0xc(%ebp)
  801a3a:	ff 75 08             	pushl  0x8(%ebp)
  801a3d:	6a 10                	push   $0x10
  801a3f:	e8 97 fe ff ff       	call   8018db <syscall>
  801a44:	83 c4 18             	add    $0x18,%esp
	return ;
  801a47:	90                   	nop
}
  801a48:	c9                   	leave  
  801a49:	c3                   	ret    

00801a4a <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801a4a:	55                   	push   %ebp
  801a4b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a4d:	6a 00                	push   $0x0
  801a4f:	6a 00                	push   $0x0
  801a51:	ff 75 10             	pushl  0x10(%ebp)
  801a54:	ff 75 0c             	pushl  0xc(%ebp)
  801a57:	ff 75 08             	pushl  0x8(%ebp)
  801a5a:	6a 11                	push   $0x11
  801a5c:	e8 7a fe ff ff       	call   8018db <syscall>
  801a61:	83 c4 18             	add    $0x18,%esp
	return ;
  801a64:	90                   	nop
}
  801a65:	c9                   	leave  
  801a66:	c3                   	ret    

00801a67 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a67:	55                   	push   %ebp
  801a68:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 00                	push   $0x0
  801a70:	6a 00                	push   $0x0
  801a72:	6a 00                	push   $0x0
  801a74:	6a 0c                	push   $0xc
  801a76:	e8 60 fe ff ff       	call   8018db <syscall>
  801a7b:	83 c4 18             	add    $0x18,%esp
}
  801a7e:	c9                   	leave  
  801a7f:	c3                   	ret    

00801a80 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a80:	55                   	push   %ebp
  801a81:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a83:	6a 00                	push   $0x0
  801a85:	6a 00                	push   $0x0
  801a87:	6a 00                	push   $0x0
  801a89:	6a 00                	push   $0x0
  801a8b:	ff 75 08             	pushl  0x8(%ebp)
  801a8e:	6a 0d                	push   $0xd
  801a90:	e8 46 fe ff ff       	call   8018db <syscall>
  801a95:	83 c4 18             	add    $0x18,%esp
}
  801a98:	c9                   	leave  
  801a99:	c3                   	ret    

00801a9a <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a9a:	55                   	push   %ebp
  801a9b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a9d:	6a 00                	push   $0x0
  801a9f:	6a 00                	push   $0x0
  801aa1:	6a 00                	push   $0x0
  801aa3:	6a 00                	push   $0x0
  801aa5:	6a 00                	push   $0x0
  801aa7:	6a 0e                	push   $0xe
  801aa9:	e8 2d fe ff ff       	call   8018db <syscall>
  801aae:	83 c4 18             	add    $0x18,%esp
}
  801ab1:	90                   	nop
  801ab2:	c9                   	leave  
  801ab3:	c3                   	ret    

00801ab4 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801ab4:	55                   	push   %ebp
  801ab5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801ab7:	6a 00                	push   $0x0
  801ab9:	6a 00                	push   $0x0
  801abb:	6a 00                	push   $0x0
  801abd:	6a 00                	push   $0x0
  801abf:	6a 00                	push   $0x0
  801ac1:	6a 13                	push   $0x13
  801ac3:	e8 13 fe ff ff       	call   8018db <syscall>
  801ac8:	83 c4 18             	add    $0x18,%esp
}
  801acb:	90                   	nop
  801acc:	c9                   	leave  
  801acd:	c3                   	ret    

00801ace <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801ace:	55                   	push   %ebp
  801acf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801ad1:	6a 00                	push   $0x0
  801ad3:	6a 00                	push   $0x0
  801ad5:	6a 00                	push   $0x0
  801ad7:	6a 00                	push   $0x0
  801ad9:	6a 00                	push   $0x0
  801adb:	6a 14                	push   $0x14
  801add:	e8 f9 fd ff ff       	call   8018db <syscall>
  801ae2:	83 c4 18             	add    $0x18,%esp
}
  801ae5:	90                   	nop
  801ae6:	c9                   	leave  
  801ae7:	c3                   	ret    

00801ae8 <sys_cputc>:


void
sys_cputc(const char c)
{
  801ae8:	55                   	push   %ebp
  801ae9:	89 e5                	mov    %esp,%ebp
  801aeb:	83 ec 04             	sub    $0x4,%esp
  801aee:	8b 45 08             	mov    0x8(%ebp),%eax
  801af1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801af4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801af8:	6a 00                	push   $0x0
  801afa:	6a 00                	push   $0x0
  801afc:	6a 00                	push   $0x0
  801afe:	6a 00                	push   $0x0
  801b00:	50                   	push   %eax
  801b01:	6a 15                	push   $0x15
  801b03:	e8 d3 fd ff ff       	call   8018db <syscall>
  801b08:	83 c4 18             	add    $0x18,%esp
}
  801b0b:	90                   	nop
  801b0c:	c9                   	leave  
  801b0d:	c3                   	ret    

00801b0e <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b0e:	55                   	push   %ebp
  801b0f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b11:	6a 00                	push   $0x0
  801b13:	6a 00                	push   $0x0
  801b15:	6a 00                	push   $0x0
  801b17:	6a 00                	push   $0x0
  801b19:	6a 00                	push   $0x0
  801b1b:	6a 16                	push   $0x16
  801b1d:	e8 b9 fd ff ff       	call   8018db <syscall>
  801b22:	83 c4 18             	add    $0x18,%esp
}
  801b25:	90                   	nop
  801b26:	c9                   	leave  
  801b27:	c3                   	ret    

00801b28 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801b28:	55                   	push   %ebp
  801b29:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2e:	6a 00                	push   $0x0
  801b30:	6a 00                	push   $0x0
  801b32:	6a 00                	push   $0x0
  801b34:	ff 75 0c             	pushl  0xc(%ebp)
  801b37:	50                   	push   %eax
  801b38:	6a 17                	push   $0x17
  801b3a:	e8 9c fd ff ff       	call   8018db <syscall>
  801b3f:	83 c4 18             	add    $0x18,%esp
}
  801b42:	c9                   	leave  
  801b43:	c3                   	ret    

00801b44 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801b44:	55                   	push   %ebp
  801b45:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b47:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4d:	6a 00                	push   $0x0
  801b4f:	6a 00                	push   $0x0
  801b51:	6a 00                	push   $0x0
  801b53:	52                   	push   %edx
  801b54:	50                   	push   %eax
  801b55:	6a 1a                	push   $0x1a
  801b57:	e8 7f fd ff ff       	call   8018db <syscall>
  801b5c:	83 c4 18             	add    $0x18,%esp
}
  801b5f:	c9                   	leave  
  801b60:	c3                   	ret    

00801b61 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b61:	55                   	push   %ebp
  801b62:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b64:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b67:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6a:	6a 00                	push   $0x0
  801b6c:	6a 00                	push   $0x0
  801b6e:	6a 00                	push   $0x0
  801b70:	52                   	push   %edx
  801b71:	50                   	push   %eax
  801b72:	6a 18                	push   $0x18
  801b74:	e8 62 fd ff ff       	call   8018db <syscall>
  801b79:	83 c4 18             	add    $0x18,%esp
}
  801b7c:	90                   	nop
  801b7d:	c9                   	leave  
  801b7e:	c3                   	ret    

00801b7f <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b7f:	55                   	push   %ebp
  801b80:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b82:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b85:	8b 45 08             	mov    0x8(%ebp),%eax
  801b88:	6a 00                	push   $0x0
  801b8a:	6a 00                	push   $0x0
  801b8c:	6a 00                	push   $0x0
  801b8e:	52                   	push   %edx
  801b8f:	50                   	push   %eax
  801b90:	6a 19                	push   $0x19
  801b92:	e8 44 fd ff ff       	call   8018db <syscall>
  801b97:	83 c4 18             	add    $0x18,%esp
}
  801b9a:	90                   	nop
  801b9b:	c9                   	leave  
  801b9c:	c3                   	ret    

00801b9d <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b9d:	55                   	push   %ebp
  801b9e:	89 e5                	mov    %esp,%ebp
  801ba0:	83 ec 04             	sub    $0x4,%esp
  801ba3:	8b 45 10             	mov    0x10(%ebp),%eax
  801ba6:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801ba9:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801bac:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb3:	6a 00                	push   $0x0
  801bb5:	51                   	push   %ecx
  801bb6:	52                   	push   %edx
  801bb7:	ff 75 0c             	pushl  0xc(%ebp)
  801bba:	50                   	push   %eax
  801bbb:	6a 1b                	push   $0x1b
  801bbd:	e8 19 fd ff ff       	call   8018db <syscall>
  801bc2:	83 c4 18             	add    $0x18,%esp
}
  801bc5:	c9                   	leave  
  801bc6:	c3                   	ret    

00801bc7 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801bc7:	55                   	push   %ebp
  801bc8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801bca:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd0:	6a 00                	push   $0x0
  801bd2:	6a 00                	push   $0x0
  801bd4:	6a 00                	push   $0x0
  801bd6:	52                   	push   %edx
  801bd7:	50                   	push   %eax
  801bd8:	6a 1c                	push   $0x1c
  801bda:	e8 fc fc ff ff       	call   8018db <syscall>
  801bdf:	83 c4 18             	add    $0x18,%esp
}
  801be2:	c9                   	leave  
  801be3:	c3                   	ret    

00801be4 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801be4:	55                   	push   %ebp
  801be5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801be7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bea:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bed:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf0:	6a 00                	push   $0x0
  801bf2:	6a 00                	push   $0x0
  801bf4:	51                   	push   %ecx
  801bf5:	52                   	push   %edx
  801bf6:	50                   	push   %eax
  801bf7:	6a 1d                	push   $0x1d
  801bf9:	e8 dd fc ff ff       	call   8018db <syscall>
  801bfe:	83 c4 18             	add    $0x18,%esp
}
  801c01:	c9                   	leave  
  801c02:	c3                   	ret    

00801c03 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801c03:	55                   	push   %ebp
  801c04:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801c06:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c09:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0c:	6a 00                	push   $0x0
  801c0e:	6a 00                	push   $0x0
  801c10:	6a 00                	push   $0x0
  801c12:	52                   	push   %edx
  801c13:	50                   	push   %eax
  801c14:	6a 1e                	push   $0x1e
  801c16:	e8 c0 fc ff ff       	call   8018db <syscall>
  801c1b:	83 c4 18             	add    $0x18,%esp
}
  801c1e:	c9                   	leave  
  801c1f:	c3                   	ret    

00801c20 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801c20:	55                   	push   %ebp
  801c21:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801c23:	6a 00                	push   $0x0
  801c25:	6a 00                	push   $0x0
  801c27:	6a 00                	push   $0x0
  801c29:	6a 00                	push   $0x0
  801c2b:	6a 00                	push   $0x0
  801c2d:	6a 1f                	push   $0x1f
  801c2f:	e8 a7 fc ff ff       	call   8018db <syscall>
  801c34:	83 c4 18             	add    $0x18,%esp
}
  801c37:	c9                   	leave  
  801c38:	c3                   	ret    

00801c39 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c39:	55                   	push   %ebp
  801c3a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3f:	6a 00                	push   $0x0
  801c41:	ff 75 14             	pushl  0x14(%ebp)
  801c44:	ff 75 10             	pushl  0x10(%ebp)
  801c47:	ff 75 0c             	pushl  0xc(%ebp)
  801c4a:	50                   	push   %eax
  801c4b:	6a 20                	push   $0x20
  801c4d:	e8 89 fc ff ff       	call   8018db <syscall>
  801c52:	83 c4 18             	add    $0x18,%esp
}
  801c55:	c9                   	leave  
  801c56:	c3                   	ret    

00801c57 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801c57:	55                   	push   %ebp
  801c58:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5d:	6a 00                	push   $0x0
  801c5f:	6a 00                	push   $0x0
  801c61:	6a 00                	push   $0x0
  801c63:	6a 00                	push   $0x0
  801c65:	50                   	push   %eax
  801c66:	6a 21                	push   $0x21
  801c68:	e8 6e fc ff ff       	call   8018db <syscall>
  801c6d:	83 c4 18             	add    $0x18,%esp
}
  801c70:	90                   	nop
  801c71:	c9                   	leave  
  801c72:	c3                   	ret    

00801c73 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c73:	55                   	push   %ebp
  801c74:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c76:	8b 45 08             	mov    0x8(%ebp),%eax
  801c79:	6a 00                	push   $0x0
  801c7b:	6a 00                	push   $0x0
  801c7d:	6a 00                	push   $0x0
  801c7f:	6a 00                	push   $0x0
  801c81:	50                   	push   %eax
  801c82:	6a 22                	push   $0x22
  801c84:	e8 52 fc ff ff       	call   8018db <syscall>
  801c89:	83 c4 18             	add    $0x18,%esp
}
  801c8c:	c9                   	leave  
  801c8d:	c3                   	ret    

00801c8e <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c8e:	55                   	push   %ebp
  801c8f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c91:	6a 00                	push   $0x0
  801c93:	6a 00                	push   $0x0
  801c95:	6a 00                	push   $0x0
  801c97:	6a 00                	push   $0x0
  801c99:	6a 00                	push   $0x0
  801c9b:	6a 02                	push   $0x2
  801c9d:	e8 39 fc ff ff       	call   8018db <syscall>
  801ca2:	83 c4 18             	add    $0x18,%esp
}
  801ca5:	c9                   	leave  
  801ca6:	c3                   	ret    

00801ca7 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801ca7:	55                   	push   %ebp
  801ca8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801caa:	6a 00                	push   $0x0
  801cac:	6a 00                	push   $0x0
  801cae:	6a 00                	push   $0x0
  801cb0:	6a 00                	push   $0x0
  801cb2:	6a 00                	push   $0x0
  801cb4:	6a 03                	push   $0x3
  801cb6:	e8 20 fc ff ff       	call   8018db <syscall>
  801cbb:	83 c4 18             	add    $0x18,%esp
}
  801cbe:	c9                   	leave  
  801cbf:	c3                   	ret    

00801cc0 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801cc0:	55                   	push   %ebp
  801cc1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801cc3:	6a 00                	push   $0x0
  801cc5:	6a 00                	push   $0x0
  801cc7:	6a 00                	push   $0x0
  801cc9:	6a 00                	push   $0x0
  801ccb:	6a 00                	push   $0x0
  801ccd:	6a 04                	push   $0x4
  801ccf:	e8 07 fc ff ff       	call   8018db <syscall>
  801cd4:	83 c4 18             	add    $0x18,%esp
}
  801cd7:	c9                   	leave  
  801cd8:	c3                   	ret    

00801cd9 <sys_exit_env>:


void sys_exit_env(void)
{
  801cd9:	55                   	push   %ebp
  801cda:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801cdc:	6a 00                	push   $0x0
  801cde:	6a 00                	push   $0x0
  801ce0:	6a 00                	push   $0x0
  801ce2:	6a 00                	push   $0x0
  801ce4:	6a 00                	push   $0x0
  801ce6:	6a 23                	push   $0x23
  801ce8:	e8 ee fb ff ff       	call   8018db <syscall>
  801ced:	83 c4 18             	add    $0x18,%esp
}
  801cf0:	90                   	nop
  801cf1:	c9                   	leave  
  801cf2:	c3                   	ret    

00801cf3 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801cf3:	55                   	push   %ebp
  801cf4:	89 e5                	mov    %esp,%ebp
  801cf6:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801cf9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cfc:	8d 50 04             	lea    0x4(%eax),%edx
  801cff:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d02:	6a 00                	push   $0x0
  801d04:	6a 00                	push   $0x0
  801d06:	6a 00                	push   $0x0
  801d08:	52                   	push   %edx
  801d09:	50                   	push   %eax
  801d0a:	6a 24                	push   $0x24
  801d0c:	e8 ca fb ff ff       	call   8018db <syscall>
  801d11:	83 c4 18             	add    $0x18,%esp
	return result;
  801d14:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d17:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d1a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d1d:	89 01                	mov    %eax,(%ecx)
  801d1f:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801d22:	8b 45 08             	mov    0x8(%ebp),%eax
  801d25:	c9                   	leave  
  801d26:	c2 04 00             	ret    $0x4

00801d29 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d29:	55                   	push   %ebp
  801d2a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d2c:	6a 00                	push   $0x0
  801d2e:	6a 00                	push   $0x0
  801d30:	ff 75 10             	pushl  0x10(%ebp)
  801d33:	ff 75 0c             	pushl  0xc(%ebp)
  801d36:	ff 75 08             	pushl  0x8(%ebp)
  801d39:	6a 12                	push   $0x12
  801d3b:	e8 9b fb ff ff       	call   8018db <syscall>
  801d40:	83 c4 18             	add    $0x18,%esp
	return ;
  801d43:	90                   	nop
}
  801d44:	c9                   	leave  
  801d45:	c3                   	ret    

00801d46 <sys_rcr2>:
uint32 sys_rcr2()
{
  801d46:	55                   	push   %ebp
  801d47:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 00                	push   $0x0
  801d4d:	6a 00                	push   $0x0
  801d4f:	6a 00                	push   $0x0
  801d51:	6a 00                	push   $0x0
  801d53:	6a 25                	push   $0x25
  801d55:	e8 81 fb ff ff       	call   8018db <syscall>
  801d5a:	83 c4 18             	add    $0x18,%esp
}
  801d5d:	c9                   	leave  
  801d5e:	c3                   	ret    

00801d5f <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801d5f:	55                   	push   %ebp
  801d60:	89 e5                	mov    %esp,%ebp
  801d62:	83 ec 04             	sub    $0x4,%esp
  801d65:	8b 45 08             	mov    0x8(%ebp),%eax
  801d68:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d6b:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d6f:	6a 00                	push   $0x0
  801d71:	6a 00                	push   $0x0
  801d73:	6a 00                	push   $0x0
  801d75:	6a 00                	push   $0x0
  801d77:	50                   	push   %eax
  801d78:	6a 26                	push   $0x26
  801d7a:	e8 5c fb ff ff       	call   8018db <syscall>
  801d7f:	83 c4 18             	add    $0x18,%esp
	return ;
  801d82:	90                   	nop
}
  801d83:	c9                   	leave  
  801d84:	c3                   	ret    

00801d85 <rsttst>:
void rsttst()
{
  801d85:	55                   	push   %ebp
  801d86:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d88:	6a 00                	push   $0x0
  801d8a:	6a 00                	push   $0x0
  801d8c:	6a 00                	push   $0x0
  801d8e:	6a 00                	push   $0x0
  801d90:	6a 00                	push   $0x0
  801d92:	6a 28                	push   $0x28
  801d94:	e8 42 fb ff ff       	call   8018db <syscall>
  801d99:	83 c4 18             	add    $0x18,%esp
	return ;
  801d9c:	90                   	nop
}
  801d9d:	c9                   	leave  
  801d9e:	c3                   	ret    

00801d9f <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d9f:	55                   	push   %ebp
  801da0:	89 e5                	mov    %esp,%ebp
  801da2:	83 ec 04             	sub    $0x4,%esp
  801da5:	8b 45 14             	mov    0x14(%ebp),%eax
  801da8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801dab:	8b 55 18             	mov    0x18(%ebp),%edx
  801dae:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801db2:	52                   	push   %edx
  801db3:	50                   	push   %eax
  801db4:	ff 75 10             	pushl  0x10(%ebp)
  801db7:	ff 75 0c             	pushl  0xc(%ebp)
  801dba:	ff 75 08             	pushl  0x8(%ebp)
  801dbd:	6a 27                	push   $0x27
  801dbf:	e8 17 fb ff ff       	call   8018db <syscall>
  801dc4:	83 c4 18             	add    $0x18,%esp
	return ;
  801dc7:	90                   	nop
}
  801dc8:	c9                   	leave  
  801dc9:	c3                   	ret    

00801dca <chktst>:
void chktst(uint32 n)
{
  801dca:	55                   	push   %ebp
  801dcb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801dcd:	6a 00                	push   $0x0
  801dcf:	6a 00                	push   $0x0
  801dd1:	6a 00                	push   $0x0
  801dd3:	6a 00                	push   $0x0
  801dd5:	ff 75 08             	pushl  0x8(%ebp)
  801dd8:	6a 29                	push   $0x29
  801dda:	e8 fc fa ff ff       	call   8018db <syscall>
  801ddf:	83 c4 18             	add    $0x18,%esp
	return ;
  801de2:	90                   	nop
}
  801de3:	c9                   	leave  
  801de4:	c3                   	ret    

00801de5 <inctst>:

void inctst()
{
  801de5:	55                   	push   %ebp
  801de6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801de8:	6a 00                	push   $0x0
  801dea:	6a 00                	push   $0x0
  801dec:	6a 00                	push   $0x0
  801dee:	6a 00                	push   $0x0
  801df0:	6a 00                	push   $0x0
  801df2:	6a 2a                	push   $0x2a
  801df4:	e8 e2 fa ff ff       	call   8018db <syscall>
  801df9:	83 c4 18             	add    $0x18,%esp
	return ;
  801dfc:	90                   	nop
}
  801dfd:	c9                   	leave  
  801dfe:	c3                   	ret    

00801dff <gettst>:
uint32 gettst()
{
  801dff:	55                   	push   %ebp
  801e00:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801e02:	6a 00                	push   $0x0
  801e04:	6a 00                	push   $0x0
  801e06:	6a 00                	push   $0x0
  801e08:	6a 00                	push   $0x0
  801e0a:	6a 00                	push   $0x0
  801e0c:	6a 2b                	push   $0x2b
  801e0e:	e8 c8 fa ff ff       	call   8018db <syscall>
  801e13:	83 c4 18             	add    $0x18,%esp
}
  801e16:	c9                   	leave  
  801e17:	c3                   	ret    

00801e18 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801e18:	55                   	push   %ebp
  801e19:	89 e5                	mov    %esp,%ebp
  801e1b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e1e:	6a 00                	push   $0x0
  801e20:	6a 00                	push   $0x0
  801e22:	6a 00                	push   $0x0
  801e24:	6a 00                	push   $0x0
  801e26:	6a 00                	push   $0x0
  801e28:	6a 2c                	push   $0x2c
  801e2a:	e8 ac fa ff ff       	call   8018db <syscall>
  801e2f:	83 c4 18             	add    $0x18,%esp
  801e32:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801e35:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e39:	75 07                	jne    801e42 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e3b:	b8 01 00 00 00       	mov    $0x1,%eax
  801e40:	eb 05                	jmp    801e47 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e42:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e47:	c9                   	leave  
  801e48:	c3                   	ret    

00801e49 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e49:	55                   	push   %ebp
  801e4a:	89 e5                	mov    %esp,%ebp
  801e4c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e4f:	6a 00                	push   $0x0
  801e51:	6a 00                	push   $0x0
  801e53:	6a 00                	push   $0x0
  801e55:	6a 00                	push   $0x0
  801e57:	6a 00                	push   $0x0
  801e59:	6a 2c                	push   $0x2c
  801e5b:	e8 7b fa ff ff       	call   8018db <syscall>
  801e60:	83 c4 18             	add    $0x18,%esp
  801e63:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e66:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e6a:	75 07                	jne    801e73 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e6c:	b8 01 00 00 00       	mov    $0x1,%eax
  801e71:	eb 05                	jmp    801e78 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e73:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e78:	c9                   	leave  
  801e79:	c3                   	ret    

00801e7a <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e7a:	55                   	push   %ebp
  801e7b:	89 e5                	mov    %esp,%ebp
  801e7d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e80:	6a 00                	push   $0x0
  801e82:	6a 00                	push   $0x0
  801e84:	6a 00                	push   $0x0
  801e86:	6a 00                	push   $0x0
  801e88:	6a 00                	push   $0x0
  801e8a:	6a 2c                	push   $0x2c
  801e8c:	e8 4a fa ff ff       	call   8018db <syscall>
  801e91:	83 c4 18             	add    $0x18,%esp
  801e94:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e97:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e9b:	75 07                	jne    801ea4 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e9d:	b8 01 00 00 00       	mov    $0x1,%eax
  801ea2:	eb 05                	jmp    801ea9 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801ea4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ea9:	c9                   	leave  
  801eaa:	c3                   	ret    

00801eab <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801eab:	55                   	push   %ebp
  801eac:	89 e5                	mov    %esp,%ebp
  801eae:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801eb1:	6a 00                	push   $0x0
  801eb3:	6a 00                	push   $0x0
  801eb5:	6a 00                	push   $0x0
  801eb7:	6a 00                	push   $0x0
  801eb9:	6a 00                	push   $0x0
  801ebb:	6a 2c                	push   $0x2c
  801ebd:	e8 19 fa ff ff       	call   8018db <syscall>
  801ec2:	83 c4 18             	add    $0x18,%esp
  801ec5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801ec8:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801ecc:	75 07                	jne    801ed5 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801ece:	b8 01 00 00 00       	mov    $0x1,%eax
  801ed3:	eb 05                	jmp    801eda <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801ed5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eda:	c9                   	leave  
  801edb:	c3                   	ret    

00801edc <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801edc:	55                   	push   %ebp
  801edd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801edf:	6a 00                	push   $0x0
  801ee1:	6a 00                	push   $0x0
  801ee3:	6a 00                	push   $0x0
  801ee5:	6a 00                	push   $0x0
  801ee7:	ff 75 08             	pushl  0x8(%ebp)
  801eea:	6a 2d                	push   $0x2d
  801eec:	e8 ea f9 ff ff       	call   8018db <syscall>
  801ef1:	83 c4 18             	add    $0x18,%esp
	return ;
  801ef4:	90                   	nop
}
  801ef5:	c9                   	leave  
  801ef6:	c3                   	ret    

00801ef7 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801ef7:	55                   	push   %ebp
  801ef8:	89 e5                	mov    %esp,%ebp
  801efa:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801efb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801efe:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f01:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f04:	8b 45 08             	mov    0x8(%ebp),%eax
  801f07:	6a 00                	push   $0x0
  801f09:	53                   	push   %ebx
  801f0a:	51                   	push   %ecx
  801f0b:	52                   	push   %edx
  801f0c:	50                   	push   %eax
  801f0d:	6a 2e                	push   $0x2e
  801f0f:	e8 c7 f9 ff ff       	call   8018db <syscall>
  801f14:	83 c4 18             	add    $0x18,%esp
}
  801f17:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f1a:	c9                   	leave  
  801f1b:	c3                   	ret    

00801f1c <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801f1c:	55                   	push   %ebp
  801f1d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801f1f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f22:	8b 45 08             	mov    0x8(%ebp),%eax
  801f25:	6a 00                	push   $0x0
  801f27:	6a 00                	push   $0x0
  801f29:	6a 00                	push   $0x0
  801f2b:	52                   	push   %edx
  801f2c:	50                   	push   %eax
  801f2d:	6a 2f                	push   $0x2f
  801f2f:	e8 a7 f9 ff ff       	call   8018db <syscall>
  801f34:	83 c4 18             	add    $0x18,%esp
}
  801f37:	c9                   	leave  
  801f38:	c3                   	ret    

00801f39 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801f39:	55                   	push   %ebp
  801f3a:	89 e5                	mov    %esp,%ebp
  801f3c:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801f3f:	8b 55 08             	mov    0x8(%ebp),%edx
  801f42:	89 d0                	mov    %edx,%eax
  801f44:	c1 e0 02             	shl    $0x2,%eax
  801f47:	01 d0                	add    %edx,%eax
  801f49:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801f50:	01 d0                	add    %edx,%eax
  801f52:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801f59:	01 d0                	add    %edx,%eax
  801f5b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801f62:	01 d0                	add    %edx,%eax
  801f64:	c1 e0 04             	shl    $0x4,%eax
  801f67:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  801f6a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  801f71:	8d 45 e8             	lea    -0x18(%ebp),%eax
  801f74:	83 ec 0c             	sub    $0xc,%esp
  801f77:	50                   	push   %eax
  801f78:	e8 76 fd ff ff       	call   801cf3 <sys_get_virtual_time>
  801f7d:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  801f80:	eb 41                	jmp    801fc3 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  801f82:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801f85:	83 ec 0c             	sub    $0xc,%esp
  801f88:	50                   	push   %eax
  801f89:	e8 65 fd ff ff       	call   801cf3 <sys_get_virtual_time>
  801f8e:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801f91:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801f94:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f97:	29 c2                	sub    %eax,%edx
  801f99:	89 d0                	mov    %edx,%eax
  801f9b:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801f9e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801fa1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fa4:	89 d1                	mov    %edx,%ecx
  801fa6:	29 c1                	sub    %eax,%ecx
  801fa8:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801fab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801fae:	39 c2                	cmp    %eax,%edx
  801fb0:	0f 97 c0             	seta   %al
  801fb3:	0f b6 c0             	movzbl %al,%eax
  801fb6:	29 c1                	sub    %eax,%ecx
  801fb8:	89 c8                	mov    %ecx,%eax
  801fba:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801fbd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801fc0:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  801fc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801fc9:	72 b7                	jb     801f82 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801fcb:	90                   	nop
  801fcc:	c9                   	leave  
  801fcd:	c3                   	ret    

00801fce <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801fce:	55                   	push   %ebp
  801fcf:	89 e5                	mov    %esp,%ebp
  801fd1:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801fd4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801fdb:	eb 03                	jmp    801fe0 <busy_wait+0x12>
  801fdd:	ff 45 fc             	incl   -0x4(%ebp)
  801fe0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fe3:	3b 45 08             	cmp    0x8(%ebp),%eax
  801fe6:	72 f5                	jb     801fdd <busy_wait+0xf>
	return i;
  801fe8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801feb:	c9                   	leave  
  801fec:	c3                   	ret    
  801fed:	66 90                	xchg   %ax,%ax
  801fef:	90                   	nop

00801ff0 <__udivdi3>:
  801ff0:	55                   	push   %ebp
  801ff1:	57                   	push   %edi
  801ff2:	56                   	push   %esi
  801ff3:	53                   	push   %ebx
  801ff4:	83 ec 1c             	sub    $0x1c,%esp
  801ff7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801ffb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801fff:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802003:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802007:	89 ca                	mov    %ecx,%edx
  802009:	89 f8                	mov    %edi,%eax
  80200b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80200f:	85 f6                	test   %esi,%esi
  802011:	75 2d                	jne    802040 <__udivdi3+0x50>
  802013:	39 cf                	cmp    %ecx,%edi
  802015:	77 65                	ja     80207c <__udivdi3+0x8c>
  802017:	89 fd                	mov    %edi,%ebp
  802019:	85 ff                	test   %edi,%edi
  80201b:	75 0b                	jne    802028 <__udivdi3+0x38>
  80201d:	b8 01 00 00 00       	mov    $0x1,%eax
  802022:	31 d2                	xor    %edx,%edx
  802024:	f7 f7                	div    %edi
  802026:	89 c5                	mov    %eax,%ebp
  802028:	31 d2                	xor    %edx,%edx
  80202a:	89 c8                	mov    %ecx,%eax
  80202c:	f7 f5                	div    %ebp
  80202e:	89 c1                	mov    %eax,%ecx
  802030:	89 d8                	mov    %ebx,%eax
  802032:	f7 f5                	div    %ebp
  802034:	89 cf                	mov    %ecx,%edi
  802036:	89 fa                	mov    %edi,%edx
  802038:	83 c4 1c             	add    $0x1c,%esp
  80203b:	5b                   	pop    %ebx
  80203c:	5e                   	pop    %esi
  80203d:	5f                   	pop    %edi
  80203e:	5d                   	pop    %ebp
  80203f:	c3                   	ret    
  802040:	39 ce                	cmp    %ecx,%esi
  802042:	77 28                	ja     80206c <__udivdi3+0x7c>
  802044:	0f bd fe             	bsr    %esi,%edi
  802047:	83 f7 1f             	xor    $0x1f,%edi
  80204a:	75 40                	jne    80208c <__udivdi3+0x9c>
  80204c:	39 ce                	cmp    %ecx,%esi
  80204e:	72 0a                	jb     80205a <__udivdi3+0x6a>
  802050:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802054:	0f 87 9e 00 00 00    	ja     8020f8 <__udivdi3+0x108>
  80205a:	b8 01 00 00 00       	mov    $0x1,%eax
  80205f:	89 fa                	mov    %edi,%edx
  802061:	83 c4 1c             	add    $0x1c,%esp
  802064:	5b                   	pop    %ebx
  802065:	5e                   	pop    %esi
  802066:	5f                   	pop    %edi
  802067:	5d                   	pop    %ebp
  802068:	c3                   	ret    
  802069:	8d 76 00             	lea    0x0(%esi),%esi
  80206c:	31 ff                	xor    %edi,%edi
  80206e:	31 c0                	xor    %eax,%eax
  802070:	89 fa                	mov    %edi,%edx
  802072:	83 c4 1c             	add    $0x1c,%esp
  802075:	5b                   	pop    %ebx
  802076:	5e                   	pop    %esi
  802077:	5f                   	pop    %edi
  802078:	5d                   	pop    %ebp
  802079:	c3                   	ret    
  80207a:	66 90                	xchg   %ax,%ax
  80207c:	89 d8                	mov    %ebx,%eax
  80207e:	f7 f7                	div    %edi
  802080:	31 ff                	xor    %edi,%edi
  802082:	89 fa                	mov    %edi,%edx
  802084:	83 c4 1c             	add    $0x1c,%esp
  802087:	5b                   	pop    %ebx
  802088:	5e                   	pop    %esi
  802089:	5f                   	pop    %edi
  80208a:	5d                   	pop    %ebp
  80208b:	c3                   	ret    
  80208c:	bd 20 00 00 00       	mov    $0x20,%ebp
  802091:	89 eb                	mov    %ebp,%ebx
  802093:	29 fb                	sub    %edi,%ebx
  802095:	89 f9                	mov    %edi,%ecx
  802097:	d3 e6                	shl    %cl,%esi
  802099:	89 c5                	mov    %eax,%ebp
  80209b:	88 d9                	mov    %bl,%cl
  80209d:	d3 ed                	shr    %cl,%ebp
  80209f:	89 e9                	mov    %ebp,%ecx
  8020a1:	09 f1                	or     %esi,%ecx
  8020a3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8020a7:	89 f9                	mov    %edi,%ecx
  8020a9:	d3 e0                	shl    %cl,%eax
  8020ab:	89 c5                	mov    %eax,%ebp
  8020ad:	89 d6                	mov    %edx,%esi
  8020af:	88 d9                	mov    %bl,%cl
  8020b1:	d3 ee                	shr    %cl,%esi
  8020b3:	89 f9                	mov    %edi,%ecx
  8020b5:	d3 e2                	shl    %cl,%edx
  8020b7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8020bb:	88 d9                	mov    %bl,%cl
  8020bd:	d3 e8                	shr    %cl,%eax
  8020bf:	09 c2                	or     %eax,%edx
  8020c1:	89 d0                	mov    %edx,%eax
  8020c3:	89 f2                	mov    %esi,%edx
  8020c5:	f7 74 24 0c          	divl   0xc(%esp)
  8020c9:	89 d6                	mov    %edx,%esi
  8020cb:	89 c3                	mov    %eax,%ebx
  8020cd:	f7 e5                	mul    %ebp
  8020cf:	39 d6                	cmp    %edx,%esi
  8020d1:	72 19                	jb     8020ec <__udivdi3+0xfc>
  8020d3:	74 0b                	je     8020e0 <__udivdi3+0xf0>
  8020d5:	89 d8                	mov    %ebx,%eax
  8020d7:	31 ff                	xor    %edi,%edi
  8020d9:	e9 58 ff ff ff       	jmp    802036 <__udivdi3+0x46>
  8020de:	66 90                	xchg   %ax,%ax
  8020e0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8020e4:	89 f9                	mov    %edi,%ecx
  8020e6:	d3 e2                	shl    %cl,%edx
  8020e8:	39 c2                	cmp    %eax,%edx
  8020ea:	73 e9                	jae    8020d5 <__udivdi3+0xe5>
  8020ec:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8020ef:	31 ff                	xor    %edi,%edi
  8020f1:	e9 40 ff ff ff       	jmp    802036 <__udivdi3+0x46>
  8020f6:	66 90                	xchg   %ax,%ax
  8020f8:	31 c0                	xor    %eax,%eax
  8020fa:	e9 37 ff ff ff       	jmp    802036 <__udivdi3+0x46>
  8020ff:	90                   	nop

00802100 <__umoddi3>:
  802100:	55                   	push   %ebp
  802101:	57                   	push   %edi
  802102:	56                   	push   %esi
  802103:	53                   	push   %ebx
  802104:	83 ec 1c             	sub    $0x1c,%esp
  802107:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80210b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80210f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802113:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802117:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80211b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80211f:	89 f3                	mov    %esi,%ebx
  802121:	89 fa                	mov    %edi,%edx
  802123:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802127:	89 34 24             	mov    %esi,(%esp)
  80212a:	85 c0                	test   %eax,%eax
  80212c:	75 1a                	jne    802148 <__umoddi3+0x48>
  80212e:	39 f7                	cmp    %esi,%edi
  802130:	0f 86 a2 00 00 00    	jbe    8021d8 <__umoddi3+0xd8>
  802136:	89 c8                	mov    %ecx,%eax
  802138:	89 f2                	mov    %esi,%edx
  80213a:	f7 f7                	div    %edi
  80213c:	89 d0                	mov    %edx,%eax
  80213e:	31 d2                	xor    %edx,%edx
  802140:	83 c4 1c             	add    $0x1c,%esp
  802143:	5b                   	pop    %ebx
  802144:	5e                   	pop    %esi
  802145:	5f                   	pop    %edi
  802146:	5d                   	pop    %ebp
  802147:	c3                   	ret    
  802148:	39 f0                	cmp    %esi,%eax
  80214a:	0f 87 ac 00 00 00    	ja     8021fc <__umoddi3+0xfc>
  802150:	0f bd e8             	bsr    %eax,%ebp
  802153:	83 f5 1f             	xor    $0x1f,%ebp
  802156:	0f 84 ac 00 00 00    	je     802208 <__umoddi3+0x108>
  80215c:	bf 20 00 00 00       	mov    $0x20,%edi
  802161:	29 ef                	sub    %ebp,%edi
  802163:	89 fe                	mov    %edi,%esi
  802165:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802169:	89 e9                	mov    %ebp,%ecx
  80216b:	d3 e0                	shl    %cl,%eax
  80216d:	89 d7                	mov    %edx,%edi
  80216f:	89 f1                	mov    %esi,%ecx
  802171:	d3 ef                	shr    %cl,%edi
  802173:	09 c7                	or     %eax,%edi
  802175:	89 e9                	mov    %ebp,%ecx
  802177:	d3 e2                	shl    %cl,%edx
  802179:	89 14 24             	mov    %edx,(%esp)
  80217c:	89 d8                	mov    %ebx,%eax
  80217e:	d3 e0                	shl    %cl,%eax
  802180:	89 c2                	mov    %eax,%edx
  802182:	8b 44 24 08          	mov    0x8(%esp),%eax
  802186:	d3 e0                	shl    %cl,%eax
  802188:	89 44 24 04          	mov    %eax,0x4(%esp)
  80218c:	8b 44 24 08          	mov    0x8(%esp),%eax
  802190:	89 f1                	mov    %esi,%ecx
  802192:	d3 e8                	shr    %cl,%eax
  802194:	09 d0                	or     %edx,%eax
  802196:	d3 eb                	shr    %cl,%ebx
  802198:	89 da                	mov    %ebx,%edx
  80219a:	f7 f7                	div    %edi
  80219c:	89 d3                	mov    %edx,%ebx
  80219e:	f7 24 24             	mull   (%esp)
  8021a1:	89 c6                	mov    %eax,%esi
  8021a3:	89 d1                	mov    %edx,%ecx
  8021a5:	39 d3                	cmp    %edx,%ebx
  8021a7:	0f 82 87 00 00 00    	jb     802234 <__umoddi3+0x134>
  8021ad:	0f 84 91 00 00 00    	je     802244 <__umoddi3+0x144>
  8021b3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8021b7:	29 f2                	sub    %esi,%edx
  8021b9:	19 cb                	sbb    %ecx,%ebx
  8021bb:	89 d8                	mov    %ebx,%eax
  8021bd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8021c1:	d3 e0                	shl    %cl,%eax
  8021c3:	89 e9                	mov    %ebp,%ecx
  8021c5:	d3 ea                	shr    %cl,%edx
  8021c7:	09 d0                	or     %edx,%eax
  8021c9:	89 e9                	mov    %ebp,%ecx
  8021cb:	d3 eb                	shr    %cl,%ebx
  8021cd:	89 da                	mov    %ebx,%edx
  8021cf:	83 c4 1c             	add    $0x1c,%esp
  8021d2:	5b                   	pop    %ebx
  8021d3:	5e                   	pop    %esi
  8021d4:	5f                   	pop    %edi
  8021d5:	5d                   	pop    %ebp
  8021d6:	c3                   	ret    
  8021d7:	90                   	nop
  8021d8:	89 fd                	mov    %edi,%ebp
  8021da:	85 ff                	test   %edi,%edi
  8021dc:	75 0b                	jne    8021e9 <__umoddi3+0xe9>
  8021de:	b8 01 00 00 00       	mov    $0x1,%eax
  8021e3:	31 d2                	xor    %edx,%edx
  8021e5:	f7 f7                	div    %edi
  8021e7:	89 c5                	mov    %eax,%ebp
  8021e9:	89 f0                	mov    %esi,%eax
  8021eb:	31 d2                	xor    %edx,%edx
  8021ed:	f7 f5                	div    %ebp
  8021ef:	89 c8                	mov    %ecx,%eax
  8021f1:	f7 f5                	div    %ebp
  8021f3:	89 d0                	mov    %edx,%eax
  8021f5:	e9 44 ff ff ff       	jmp    80213e <__umoddi3+0x3e>
  8021fa:	66 90                	xchg   %ax,%ax
  8021fc:	89 c8                	mov    %ecx,%eax
  8021fe:	89 f2                	mov    %esi,%edx
  802200:	83 c4 1c             	add    $0x1c,%esp
  802203:	5b                   	pop    %ebx
  802204:	5e                   	pop    %esi
  802205:	5f                   	pop    %edi
  802206:	5d                   	pop    %ebp
  802207:	c3                   	ret    
  802208:	3b 04 24             	cmp    (%esp),%eax
  80220b:	72 06                	jb     802213 <__umoddi3+0x113>
  80220d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802211:	77 0f                	ja     802222 <__umoddi3+0x122>
  802213:	89 f2                	mov    %esi,%edx
  802215:	29 f9                	sub    %edi,%ecx
  802217:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80221b:	89 14 24             	mov    %edx,(%esp)
  80221e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802222:	8b 44 24 04          	mov    0x4(%esp),%eax
  802226:	8b 14 24             	mov    (%esp),%edx
  802229:	83 c4 1c             	add    $0x1c,%esp
  80222c:	5b                   	pop    %ebx
  80222d:	5e                   	pop    %esi
  80222e:	5f                   	pop    %edi
  80222f:	5d                   	pop    %ebp
  802230:	c3                   	ret    
  802231:	8d 76 00             	lea    0x0(%esi),%esi
  802234:	2b 04 24             	sub    (%esp),%eax
  802237:	19 fa                	sbb    %edi,%edx
  802239:	89 d1                	mov    %edx,%ecx
  80223b:	89 c6                	mov    %eax,%esi
  80223d:	e9 71 ff ff ff       	jmp    8021b3 <__umoddi3+0xb3>
  802242:	66 90                	xchg   %ax,%ax
  802244:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802248:	72 ea                	jb     802234 <__umoddi3+0x134>
  80224a:	89 d9                	mov    %ebx,%ecx
  80224c:	e9 62 ff ff ff       	jmp    8021b3 <__umoddi3+0xb3>
