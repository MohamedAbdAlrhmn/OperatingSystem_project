
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
  80008a:	68 60 3c 80 00       	push   $0x803c60
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
  8000ba:	68 92 3c 80 00       	push   $0x803c92
  8000bf:	e8 25 1f 00 00       	call   801fe9 <sys_create_env>
  8000c4:	83 c4 10             	add    $0x10,%esp
  8000c7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		int freeFrames = sys_calculate_free_frames() ;
  8000ca:	e8 a8 1c 00 00       	call   801d77 <sys_calculate_free_frames>
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
  8000f5:	68 96 3c 80 00       	push   $0x803c96
  8000fa:	e8 ea 1e 00 00       	call   801fe9 <sys_create_env>
  8000ff:	83 c4 10             	add    $0x10,%esp
  800102:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		int helloWorldFrames = freeFrames - sys_calculate_free_frames() ;
  800105:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800108:	e8 6a 1c 00 00       	call   801d77 <sys_calculate_free_frames>
  80010d:	29 c3                	sub    %eax,%ebx
  80010f:	89 d8                	mov    %ebx,%eax
  800111:	89 45 d0             	mov    %eax,-0x30(%ebp)
		env_sleep(2000);
  800114:	83 ec 0c             	sub    $0xc,%esp
  800117:	68 d0 07 00 00       	push   $0x7d0
  80011c:	e8 18 38 00 00       	call   803939 <env_sleep>
  800121:	83 c4 10             	add    $0x10,%esp
		cprintf("[DONE]\n\n");
  800124:	83 ec 0c             	sub    $0xc,%esp
  800127:	68 a5 3c 80 00       	push   $0x803ca5
  80012c:	e8 a1 08 00 00       	call   8009d2 <cprintf>
  800131:	83 c4 10             	add    $0x10,%esp

		//Load and run "fos_add"
		cprintf("Loading fos_add program into RAM...");
  800134:	83 ec 0c             	sub    $0xc,%esp
  800137:	68 b0 3c 80 00       	push   $0x803cb0
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
  800167:	68 d4 3c 80 00       	push   $0x803cd4
  80016c:	e8 78 1e 00 00       	call   801fe9 <sys_create_env>
  800171:	83 c4 10             	add    $0x10,%esp
  800174:	89 45 cc             	mov    %eax,-0x34(%ebp)
		env_sleep(2000);
  800177:	83 ec 0c             	sub    $0xc,%esp
  80017a:	68 d0 07 00 00       	push   $0x7d0
  80017f:	e8 b5 37 00 00       	call   803939 <env_sleep>
  800184:	83 c4 10             	add    $0x10,%esp
		cprintf("[DONE]\n\n");
  800187:	83 ec 0c             	sub    $0xc,%esp
  80018a:	68 a5 3c 80 00       	push   $0x803ca5
  80018f:	e8 3e 08 00 00       	call   8009d2 <cprintf>
  800194:	83 c4 10             	add    $0x10,%esp
		cprintf("running fos_add program...\n\n");
  800197:	83 ec 0c             	sub    $0xc,%esp
  80019a:	68 dc 3c 80 00       	push   $0x803cdc
  80019f:	e8 2e 08 00 00       	call   8009d2 <cprintf>
  8001a4:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdFOSAdd);
  8001a7:	83 ec 0c             	sub    $0xc,%esp
  8001aa:	ff 75 cc             	pushl  -0x34(%ebp)
  8001ad:	e8 55 1e 00 00       	call   802007 <sys_run_env>
  8001b2:	83 c4 10             	add    $0x10,%esp

		cprintf("please be patient ...\n");
  8001b5:	83 ec 0c             	sub    $0xc,%esp
  8001b8:	68 f9 3c 80 00       	push   $0x803cf9
  8001bd:	e8 10 08 00 00       	call   8009d2 <cprintf>
  8001c2:	83 c4 10             	add    $0x10,%esp
		env_sleep(5000);
  8001c5:	83 ec 0c             	sub    $0xc,%esp
  8001c8:	68 88 13 00 00       	push   $0x1388
  8001cd:	e8 67 37 00 00       	call   803939 <env_sleep>
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
  800266:	e8 0c 1b 00 00       	call   801d77 <sys_calculate_free_frames>
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
  800352:	68 10 3d 80 00       	push   $0x803d10
  800357:	e8 76 06 00 00       	call   8009d2 <cprintf>
  80035c:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdHelloWorld);
  80035f:	83 ec 0c             	sub    $0xc,%esp
  800362:	ff 75 d4             	pushl  -0x2c(%ebp)
  800365:	e8 9d 1c 00 00       	call   802007 <sys_run_env>
  80036a:	83 c4 10             	add    $0x10,%esp

		cprintf("please be patient ...\n");
  80036d:	83 ec 0c             	sub    $0xc,%esp
  800370:	68 f9 3c 80 00       	push   $0x803cf9
  800375:	e8 58 06 00 00       	call   8009d2 <cprintf>
  80037a:	83 c4 10             	add    $0x10,%esp
		env_sleep(5000);
  80037d:	83 ec 0c             	sub    $0xc,%esp
  800380:	68 88 13 00 00       	push   $0x1388
  800385:	e8 af 35 00 00       	call   803939 <env_sleep>
  80038a:	83 c4 10             	add    $0x10,%esp

		//Allocate the remaining RAM + extra RAM by the size of helloWorld program (Here: it requires to free some RAM by removing exited & loaded program(s) (fos_helloWorld & fib))
		freeFrames = sys_calculate_free_frames() ;
  80038d:	e8 e5 19 00 00       	call   801d77 <sys_calculate_free_frames>
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
  800444:	68 34 3d 80 00       	push   $0x803d34
  800449:	6a 62                	push   $0x62
  80044b:	68 69 3d 80 00       	push   $0x803d69
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
  800479:	68 34 3d 80 00       	push   $0x803d34
  80047e:	6a 63                	push   $0x63
  800480:	68 69 3d 80 00       	push   $0x803d69
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
  8004ad:	68 34 3d 80 00       	push   $0x803d34
  8004b2:	6a 64                	push   $0x64
  8004b4:	68 69 3d 80 00       	push   $0x803d69
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
  8004e1:	68 34 3d 80 00       	push   $0x803d34
  8004e6:	6a 65                	push   $0x65
  8004e8:	68 69 3d 80 00       	push   $0x803d69
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
  800515:	68 34 3d 80 00       	push   $0x803d34
  80051a:	6a 66                	push   $0x66
  80051c:	68 69 3d 80 00       	push   $0x803d69
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
  800549:	68 34 3d 80 00       	push   $0x803d34
  80054e:	6a 68                	push   $0x68
  800550:	68 69 3d 80 00       	push   $0x803d69
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
  800583:	68 34 3d 80 00       	push   $0x803d34
  800588:	6a 69                	push   $0x69
  80058a:	68 69 3d 80 00       	push   $0x803d69
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
  8005b9:	68 34 3d 80 00       	push   $0x803d34
  8005be:	6a 6a                	push   $0x6a
  8005c0:	68 69 3d 80 00       	push   $0x803d69
  8005c5:	e8 54 01 00 00       	call   80071e <_panic>


	}

	cprintf("Congratulations!! test freeRAM (1) completed successfully.\n");
  8005ca:	83 ec 0c             	sub    $0xc,%esp
  8005cd:	68 80 3d 80 00       	push   $0x803d80
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
  8005e8:	e8 6a 1a 00 00       	call   802057 <sys_getenvindex>
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
  800653:	e8 0c 18 00 00       	call   801e64 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800658:	83 ec 0c             	sub    $0xc,%esp
  80065b:	68 d4 3d 80 00       	push   $0x803dd4
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
  800683:	68 fc 3d 80 00       	push   $0x803dfc
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
  8006b4:	68 24 3e 80 00       	push   $0x803e24
  8006b9:	e8 14 03 00 00       	call   8009d2 <cprintf>
  8006be:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8006c1:	a1 20 50 80 00       	mov    0x805020,%eax
  8006c6:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8006cc:	83 ec 08             	sub    $0x8,%esp
  8006cf:	50                   	push   %eax
  8006d0:	68 7c 3e 80 00       	push   $0x803e7c
  8006d5:	e8 f8 02 00 00       	call   8009d2 <cprintf>
  8006da:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8006dd:	83 ec 0c             	sub    $0xc,%esp
  8006e0:	68 d4 3d 80 00       	push   $0x803dd4
  8006e5:	e8 e8 02 00 00       	call   8009d2 <cprintf>
  8006ea:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8006ed:	e8 8c 17 00 00       	call   801e7e <sys_enable_interrupt>

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
  800705:	e8 19 19 00 00       	call   802023 <sys_destroy_env>
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
  800716:	e8 6e 19 00 00       	call   802089 <sys_exit_env>
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
  80073f:	68 90 3e 80 00       	push   $0x803e90
  800744:	e8 89 02 00 00       	call   8009d2 <cprintf>
  800749:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80074c:	a1 00 50 80 00       	mov    0x805000,%eax
  800751:	ff 75 0c             	pushl  0xc(%ebp)
  800754:	ff 75 08             	pushl  0x8(%ebp)
  800757:	50                   	push   %eax
  800758:	68 95 3e 80 00       	push   $0x803e95
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
  80077c:	68 b1 3e 80 00       	push   $0x803eb1
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
  8007a8:	68 b4 3e 80 00       	push   $0x803eb4
  8007ad:	6a 26                	push   $0x26
  8007af:	68 00 3f 80 00       	push   $0x803f00
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
  80087a:	68 0c 3f 80 00       	push   $0x803f0c
  80087f:	6a 3a                	push   $0x3a
  800881:	68 00 3f 80 00       	push   $0x803f00
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
  8008ea:	68 60 3f 80 00       	push   $0x803f60
  8008ef:	6a 44                	push   $0x44
  8008f1:	68 00 3f 80 00       	push   $0x803f00
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
  800944:	e8 6d 13 00 00       	call   801cb6 <sys_cputs>
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
  8009bb:	e8 f6 12 00 00       	call   801cb6 <sys_cputs>
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
  800a05:	e8 5a 14 00 00       	call   801e64 <sys_disable_interrupt>
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
  800a25:	e8 54 14 00 00       	call   801e7e <sys_enable_interrupt>
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
  800a6f:	e8 7c 2f 00 00       	call   8039f0 <__udivdi3>
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
  800abf:	e8 3c 30 00 00       	call   803b00 <__umoddi3>
  800ac4:	83 c4 10             	add    $0x10,%esp
  800ac7:	05 d4 41 80 00       	add    $0x8041d4,%eax
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
  800c1a:	8b 04 85 f8 41 80 00 	mov    0x8041f8(,%eax,4),%eax
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
  800cfb:	8b 34 9d 40 40 80 00 	mov    0x804040(,%ebx,4),%esi
  800d02:	85 f6                	test   %esi,%esi
  800d04:	75 19                	jne    800d1f <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d06:	53                   	push   %ebx
  800d07:	68 e5 41 80 00       	push   $0x8041e5
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
  800d20:	68 ee 41 80 00       	push   $0x8041ee
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
  800d4d:	be f1 41 80 00       	mov    $0x8041f1,%esi
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
  801773:	68 50 43 80 00       	push   $0x804350
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
  801843:	e8 b2 05 00 00       	call   801dfa <sys_allocate_chunk>
  801848:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  80184b:	a1 20 51 80 00       	mov    0x805120,%eax
  801850:	83 ec 0c             	sub    $0xc,%esp
  801853:	50                   	push   %eax
  801854:	e8 27 0c 00 00       	call   802480 <initialize_MemBlocksList>
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
  801881:	68 75 43 80 00       	push   $0x804375
  801886:	6a 33                	push   $0x33
  801888:	68 93 43 80 00       	push   $0x804393
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
  801900:	68 a0 43 80 00       	push   $0x8043a0
  801905:	6a 34                	push   $0x34
  801907:	68 93 43 80 00       	push   $0x804393
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
  801998:	e8 2b 08 00 00       	call   8021c8 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80199d:	85 c0                	test   %eax,%eax
  80199f:	74 11                	je     8019b2 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  8019a1:	83 ec 0c             	sub    $0xc,%esp
  8019a4:	ff 75 e8             	pushl  -0x18(%ebp)
  8019a7:	e8 96 0e 00 00       	call   802842 <alloc_block_FF>
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
  8019be:	e8 f2 0b 00 00       	call   8025b5 <insert_sorted_allocList>
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
  8019d8:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	struct MemBlock * free_block=find_block(&AllocMemBlocksList,(uint32)virtual_address);
  8019db:	8b 45 08             	mov    0x8(%ebp),%eax
  8019de:	83 ec 08             	sub    $0x8,%esp
  8019e1:	50                   	push   %eax
  8019e2:	68 40 50 80 00       	push   $0x805040
  8019e7:	e8 71 0b 00 00       	call   80255d <find_block>
  8019ec:	83 c4 10             	add    $0x10,%esp
  8019ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(free_block!=NULL)
  8019f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8019f6:	0f 84 a6 00 00 00    	je     801aa2 <free+0xcd>
	{
		sys_free_user_mem(free_block->sva,free_block->size);
  8019fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019ff:	8b 50 0c             	mov    0xc(%eax),%edx
  801a02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a05:	8b 40 08             	mov    0x8(%eax),%eax
  801a08:	83 ec 08             	sub    $0x8,%esp
  801a0b:	52                   	push   %edx
  801a0c:	50                   	push   %eax
  801a0d:	e8 b0 03 00 00       	call   801dc2 <sys_free_user_mem>
  801a12:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,free_block);
  801a15:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a19:	75 14                	jne    801a2f <free+0x5a>
  801a1b:	83 ec 04             	sub    $0x4,%esp
  801a1e:	68 75 43 80 00       	push   $0x804375
  801a23:	6a 74                	push   $0x74
  801a25:	68 93 43 80 00       	push   $0x804393
  801a2a:	e8 ef ec ff ff       	call   80071e <_panic>
  801a2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a32:	8b 00                	mov    (%eax),%eax
  801a34:	85 c0                	test   %eax,%eax
  801a36:	74 10                	je     801a48 <free+0x73>
  801a38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a3b:	8b 00                	mov    (%eax),%eax
  801a3d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a40:	8b 52 04             	mov    0x4(%edx),%edx
  801a43:	89 50 04             	mov    %edx,0x4(%eax)
  801a46:	eb 0b                	jmp    801a53 <free+0x7e>
  801a48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a4b:	8b 40 04             	mov    0x4(%eax),%eax
  801a4e:	a3 44 50 80 00       	mov    %eax,0x805044
  801a53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a56:	8b 40 04             	mov    0x4(%eax),%eax
  801a59:	85 c0                	test   %eax,%eax
  801a5b:	74 0f                	je     801a6c <free+0x97>
  801a5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a60:	8b 40 04             	mov    0x4(%eax),%eax
  801a63:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a66:	8b 12                	mov    (%edx),%edx
  801a68:	89 10                	mov    %edx,(%eax)
  801a6a:	eb 0a                	jmp    801a76 <free+0xa1>
  801a6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a6f:	8b 00                	mov    (%eax),%eax
  801a71:	a3 40 50 80 00       	mov    %eax,0x805040
  801a76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a79:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801a7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a82:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801a89:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801a8e:	48                   	dec    %eax
  801a8f:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(free_block);
  801a94:	83 ec 0c             	sub    $0xc,%esp
  801a97:	ff 75 f4             	pushl  -0xc(%ebp)
  801a9a:	e8 4e 17 00 00       	call   8031ed <insert_sorted_with_merge_freeList>
  801a9f:	83 c4 10             	add    $0x10,%esp
	}

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801aa2:	90                   	nop
  801aa3:	c9                   	leave  
  801aa4:	c3                   	ret    

00801aa5 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801aa5:	55                   	push   %ebp
  801aa6:	89 e5                	mov    %esp,%ebp
  801aa8:	83 ec 38             	sub    $0x38,%esp
  801aab:	8b 45 10             	mov    0x10(%ebp),%eax
  801aae:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801ab1:	e8 a6 fc ff ff       	call   80175c <InitializeUHeap>
	if (size == 0) return NULL ;
  801ab6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801aba:	75 0a                	jne    801ac6 <smalloc+0x21>
  801abc:	b8 00 00 00 00       	mov    $0x0,%eax
  801ac1:	e9 8b 00 00 00       	jmp    801b51 <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801ac6:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801acd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ad0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ad3:	01 d0                	add    %edx,%eax
  801ad5:	48                   	dec    %eax
  801ad6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801ad9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801adc:	ba 00 00 00 00       	mov    $0x0,%edx
  801ae1:	f7 75 f0             	divl   -0x10(%ebp)
  801ae4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ae7:	29 d0                	sub    %edx,%eax
  801ae9:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801aec:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801af3:	e8 d0 06 00 00       	call   8021c8 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801af8:	85 c0                	test   %eax,%eax
  801afa:	74 11                	je     801b0d <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  801afc:	83 ec 0c             	sub    $0xc,%esp
  801aff:	ff 75 e8             	pushl  -0x18(%ebp)
  801b02:	e8 3b 0d 00 00       	call   802842 <alloc_block_FF>
  801b07:	83 c4 10             	add    $0x10,%esp
  801b0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  801b0d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b11:	74 39                	je     801b4c <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801b13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b16:	8b 40 08             	mov    0x8(%eax),%eax
  801b19:	89 c2                	mov    %eax,%edx
  801b1b:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801b1f:	52                   	push   %edx
  801b20:	50                   	push   %eax
  801b21:	ff 75 0c             	pushl  0xc(%ebp)
  801b24:	ff 75 08             	pushl  0x8(%ebp)
  801b27:	e8 21 04 00 00       	call   801f4d <sys_createSharedObject>
  801b2c:	83 c4 10             	add    $0x10,%esp
  801b2f:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  801b32:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  801b36:	74 14                	je     801b4c <smalloc+0xa7>
  801b38:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  801b3c:	74 0e                	je     801b4c <smalloc+0xa7>
  801b3e:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  801b42:	74 08                	je     801b4c <smalloc+0xa7>
			return (void*) mem_block->sva;
  801b44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b47:	8b 40 08             	mov    0x8(%eax),%eax
  801b4a:	eb 05                	jmp    801b51 <smalloc+0xac>
	}
	return NULL;
  801b4c:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801b51:	c9                   	leave  
  801b52:	c3                   	ret    

00801b53 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801b53:	55                   	push   %ebp
  801b54:	89 e5                	mov    %esp,%ebp
  801b56:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801b59:	e8 fe fb ff ff       	call   80175c <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801b5e:	83 ec 08             	sub    $0x8,%esp
  801b61:	ff 75 0c             	pushl  0xc(%ebp)
  801b64:	ff 75 08             	pushl  0x8(%ebp)
  801b67:	e8 0b 04 00 00       	call   801f77 <sys_getSizeOfSharedObject>
  801b6c:	83 c4 10             	add    $0x10,%esp
  801b6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  801b72:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  801b76:	74 76                	je     801bee <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801b78:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801b7f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b82:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b85:	01 d0                	add    %edx,%eax
  801b87:	48                   	dec    %eax
  801b88:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801b8b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b8e:	ba 00 00 00 00       	mov    $0x0,%edx
  801b93:	f7 75 ec             	divl   -0x14(%ebp)
  801b96:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b99:	29 d0                	sub    %edx,%eax
  801b9b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  801b9e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801ba5:	e8 1e 06 00 00       	call   8021c8 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801baa:	85 c0                	test   %eax,%eax
  801bac:	74 11                	je     801bbf <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  801bae:	83 ec 0c             	sub    $0xc,%esp
  801bb1:	ff 75 e4             	pushl  -0x1c(%ebp)
  801bb4:	e8 89 0c 00 00       	call   802842 <alloc_block_FF>
  801bb9:	83 c4 10             	add    $0x10,%esp
  801bbc:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  801bbf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801bc3:	74 29                	je     801bee <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  801bc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bc8:	8b 40 08             	mov    0x8(%eax),%eax
  801bcb:	83 ec 04             	sub    $0x4,%esp
  801bce:	50                   	push   %eax
  801bcf:	ff 75 0c             	pushl  0xc(%ebp)
  801bd2:	ff 75 08             	pushl  0x8(%ebp)
  801bd5:	e8 ba 03 00 00       	call   801f94 <sys_getSharedObject>
  801bda:	83 c4 10             	add    $0x10,%esp
  801bdd:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  801be0:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  801be4:	74 08                	je     801bee <sget+0x9b>
				return (void *)mem_block->sva;
  801be6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801be9:	8b 40 08             	mov    0x8(%eax),%eax
  801bec:	eb 05                	jmp    801bf3 <sget+0xa0>
		}
	}
	return NULL;
  801bee:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801bf3:	c9                   	leave  
  801bf4:	c3                   	ret    

00801bf5 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801bf5:	55                   	push   %ebp
  801bf6:	89 e5                	mov    %esp,%ebp
  801bf8:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801bfb:	e8 5c fb ff ff       	call   80175c <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801c00:	83 ec 04             	sub    $0x4,%esp
  801c03:	68 c4 43 80 00       	push   $0x8043c4
  801c08:	68 f7 00 00 00       	push   $0xf7
  801c0d:	68 93 43 80 00       	push   $0x804393
  801c12:	e8 07 eb ff ff       	call   80071e <_panic>

00801c17 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801c17:	55                   	push   %ebp
  801c18:	89 e5                	mov    %esp,%ebp
  801c1a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()


	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801c1d:	83 ec 04             	sub    $0x4,%esp
  801c20:	68 ec 43 80 00       	push   $0x8043ec
  801c25:	68 0c 01 00 00       	push   $0x10c
  801c2a:	68 93 43 80 00       	push   $0x804393
  801c2f:	e8 ea ea ff ff       	call   80071e <_panic>

00801c34 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801c34:	55                   	push   %ebp
  801c35:	89 e5                	mov    %esp,%ebp
  801c37:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c3a:	83 ec 04             	sub    $0x4,%esp
  801c3d:	68 10 44 80 00       	push   $0x804410
  801c42:	68 44 01 00 00       	push   $0x144
  801c47:	68 93 43 80 00       	push   $0x804393
  801c4c:	e8 cd ea ff ff       	call   80071e <_panic>

00801c51 <shrink>:

}
void shrink(uint32 newSize)
{
  801c51:	55                   	push   %ebp
  801c52:	89 e5                	mov    %esp,%ebp
  801c54:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c57:	83 ec 04             	sub    $0x4,%esp
  801c5a:	68 10 44 80 00       	push   $0x804410
  801c5f:	68 49 01 00 00       	push   $0x149
  801c64:	68 93 43 80 00       	push   $0x804393
  801c69:	e8 b0 ea ff ff       	call   80071e <_panic>

00801c6e <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801c6e:	55                   	push   %ebp
  801c6f:	89 e5                	mov    %esp,%ebp
  801c71:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c74:	83 ec 04             	sub    $0x4,%esp
  801c77:	68 10 44 80 00       	push   $0x804410
  801c7c:	68 4e 01 00 00       	push   $0x14e
  801c81:	68 93 43 80 00       	push   $0x804393
  801c86:	e8 93 ea ff ff       	call   80071e <_panic>

00801c8b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801c8b:	55                   	push   %ebp
  801c8c:	89 e5                	mov    %esp,%ebp
  801c8e:	57                   	push   %edi
  801c8f:	56                   	push   %esi
  801c90:	53                   	push   %ebx
  801c91:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801c94:	8b 45 08             	mov    0x8(%ebp),%eax
  801c97:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c9a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c9d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ca0:	8b 7d 18             	mov    0x18(%ebp),%edi
  801ca3:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801ca6:	cd 30                	int    $0x30
  801ca8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801cab:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801cae:	83 c4 10             	add    $0x10,%esp
  801cb1:	5b                   	pop    %ebx
  801cb2:	5e                   	pop    %esi
  801cb3:	5f                   	pop    %edi
  801cb4:	5d                   	pop    %ebp
  801cb5:	c3                   	ret    

00801cb6 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801cb6:	55                   	push   %ebp
  801cb7:	89 e5                	mov    %esp,%ebp
  801cb9:	83 ec 04             	sub    $0x4,%esp
  801cbc:	8b 45 10             	mov    0x10(%ebp),%eax
  801cbf:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801cc2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc9:	6a 00                	push   $0x0
  801ccb:	6a 00                	push   $0x0
  801ccd:	52                   	push   %edx
  801cce:	ff 75 0c             	pushl  0xc(%ebp)
  801cd1:	50                   	push   %eax
  801cd2:	6a 00                	push   $0x0
  801cd4:	e8 b2 ff ff ff       	call   801c8b <syscall>
  801cd9:	83 c4 18             	add    $0x18,%esp
}
  801cdc:	90                   	nop
  801cdd:	c9                   	leave  
  801cde:	c3                   	ret    

00801cdf <sys_cgetc>:

int
sys_cgetc(void)
{
  801cdf:	55                   	push   %ebp
  801ce0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801ce2:	6a 00                	push   $0x0
  801ce4:	6a 00                	push   $0x0
  801ce6:	6a 00                	push   $0x0
  801ce8:	6a 00                	push   $0x0
  801cea:	6a 00                	push   $0x0
  801cec:	6a 01                	push   $0x1
  801cee:	e8 98 ff ff ff       	call   801c8b <syscall>
  801cf3:	83 c4 18             	add    $0x18,%esp
}
  801cf6:	c9                   	leave  
  801cf7:	c3                   	ret    

00801cf8 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801cf8:	55                   	push   %ebp
  801cf9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801cfb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cfe:	8b 45 08             	mov    0x8(%ebp),%eax
  801d01:	6a 00                	push   $0x0
  801d03:	6a 00                	push   $0x0
  801d05:	6a 00                	push   $0x0
  801d07:	52                   	push   %edx
  801d08:	50                   	push   %eax
  801d09:	6a 05                	push   $0x5
  801d0b:	e8 7b ff ff ff       	call   801c8b <syscall>
  801d10:	83 c4 18             	add    $0x18,%esp
}
  801d13:	c9                   	leave  
  801d14:	c3                   	ret    

00801d15 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801d15:	55                   	push   %ebp
  801d16:	89 e5                	mov    %esp,%ebp
  801d18:	56                   	push   %esi
  801d19:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801d1a:	8b 75 18             	mov    0x18(%ebp),%esi
  801d1d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d20:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d23:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d26:	8b 45 08             	mov    0x8(%ebp),%eax
  801d29:	56                   	push   %esi
  801d2a:	53                   	push   %ebx
  801d2b:	51                   	push   %ecx
  801d2c:	52                   	push   %edx
  801d2d:	50                   	push   %eax
  801d2e:	6a 06                	push   $0x6
  801d30:	e8 56 ff ff ff       	call   801c8b <syscall>
  801d35:	83 c4 18             	add    $0x18,%esp
}
  801d38:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d3b:	5b                   	pop    %ebx
  801d3c:	5e                   	pop    %esi
  801d3d:	5d                   	pop    %ebp
  801d3e:	c3                   	ret    

00801d3f <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801d3f:	55                   	push   %ebp
  801d40:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801d42:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d45:	8b 45 08             	mov    0x8(%ebp),%eax
  801d48:	6a 00                	push   $0x0
  801d4a:	6a 00                	push   $0x0
  801d4c:	6a 00                	push   $0x0
  801d4e:	52                   	push   %edx
  801d4f:	50                   	push   %eax
  801d50:	6a 07                	push   $0x7
  801d52:	e8 34 ff ff ff       	call   801c8b <syscall>
  801d57:	83 c4 18             	add    $0x18,%esp
}
  801d5a:	c9                   	leave  
  801d5b:	c3                   	ret    

00801d5c <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801d5c:	55                   	push   %ebp
  801d5d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801d5f:	6a 00                	push   $0x0
  801d61:	6a 00                	push   $0x0
  801d63:	6a 00                	push   $0x0
  801d65:	ff 75 0c             	pushl  0xc(%ebp)
  801d68:	ff 75 08             	pushl  0x8(%ebp)
  801d6b:	6a 08                	push   $0x8
  801d6d:	e8 19 ff ff ff       	call   801c8b <syscall>
  801d72:	83 c4 18             	add    $0x18,%esp
}
  801d75:	c9                   	leave  
  801d76:	c3                   	ret    

00801d77 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801d77:	55                   	push   %ebp
  801d78:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801d7a:	6a 00                	push   $0x0
  801d7c:	6a 00                	push   $0x0
  801d7e:	6a 00                	push   $0x0
  801d80:	6a 00                	push   $0x0
  801d82:	6a 00                	push   $0x0
  801d84:	6a 09                	push   $0x9
  801d86:	e8 00 ff ff ff       	call   801c8b <syscall>
  801d8b:	83 c4 18             	add    $0x18,%esp
}
  801d8e:	c9                   	leave  
  801d8f:	c3                   	ret    

00801d90 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801d90:	55                   	push   %ebp
  801d91:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801d93:	6a 00                	push   $0x0
  801d95:	6a 00                	push   $0x0
  801d97:	6a 00                	push   $0x0
  801d99:	6a 00                	push   $0x0
  801d9b:	6a 00                	push   $0x0
  801d9d:	6a 0a                	push   $0xa
  801d9f:	e8 e7 fe ff ff       	call   801c8b <syscall>
  801da4:	83 c4 18             	add    $0x18,%esp
}
  801da7:	c9                   	leave  
  801da8:	c3                   	ret    

00801da9 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801da9:	55                   	push   %ebp
  801daa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801dac:	6a 00                	push   $0x0
  801dae:	6a 00                	push   $0x0
  801db0:	6a 00                	push   $0x0
  801db2:	6a 00                	push   $0x0
  801db4:	6a 00                	push   $0x0
  801db6:	6a 0b                	push   $0xb
  801db8:	e8 ce fe ff ff       	call   801c8b <syscall>
  801dbd:	83 c4 18             	add    $0x18,%esp
}
  801dc0:	c9                   	leave  
  801dc1:	c3                   	ret    

00801dc2 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801dc2:	55                   	push   %ebp
  801dc3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801dc5:	6a 00                	push   $0x0
  801dc7:	6a 00                	push   $0x0
  801dc9:	6a 00                	push   $0x0
  801dcb:	ff 75 0c             	pushl  0xc(%ebp)
  801dce:	ff 75 08             	pushl  0x8(%ebp)
  801dd1:	6a 0f                	push   $0xf
  801dd3:	e8 b3 fe ff ff       	call   801c8b <syscall>
  801dd8:	83 c4 18             	add    $0x18,%esp
	return;
  801ddb:	90                   	nop
}
  801ddc:	c9                   	leave  
  801ddd:	c3                   	ret    

00801dde <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801dde:	55                   	push   %ebp
  801ddf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801de1:	6a 00                	push   $0x0
  801de3:	6a 00                	push   $0x0
  801de5:	6a 00                	push   $0x0
  801de7:	ff 75 0c             	pushl  0xc(%ebp)
  801dea:	ff 75 08             	pushl  0x8(%ebp)
  801ded:	6a 10                	push   $0x10
  801def:	e8 97 fe ff ff       	call   801c8b <syscall>
  801df4:	83 c4 18             	add    $0x18,%esp
	return ;
  801df7:	90                   	nop
}
  801df8:	c9                   	leave  
  801df9:	c3                   	ret    

00801dfa <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801dfa:	55                   	push   %ebp
  801dfb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801dfd:	6a 00                	push   $0x0
  801dff:	6a 00                	push   $0x0
  801e01:	ff 75 10             	pushl  0x10(%ebp)
  801e04:	ff 75 0c             	pushl  0xc(%ebp)
  801e07:	ff 75 08             	pushl  0x8(%ebp)
  801e0a:	6a 11                	push   $0x11
  801e0c:	e8 7a fe ff ff       	call   801c8b <syscall>
  801e11:	83 c4 18             	add    $0x18,%esp
	return ;
  801e14:	90                   	nop
}
  801e15:	c9                   	leave  
  801e16:	c3                   	ret    

00801e17 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801e17:	55                   	push   %ebp
  801e18:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801e1a:	6a 00                	push   $0x0
  801e1c:	6a 00                	push   $0x0
  801e1e:	6a 00                	push   $0x0
  801e20:	6a 00                	push   $0x0
  801e22:	6a 00                	push   $0x0
  801e24:	6a 0c                	push   $0xc
  801e26:	e8 60 fe ff ff       	call   801c8b <syscall>
  801e2b:	83 c4 18             	add    $0x18,%esp
}
  801e2e:	c9                   	leave  
  801e2f:	c3                   	ret    

00801e30 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801e30:	55                   	push   %ebp
  801e31:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801e33:	6a 00                	push   $0x0
  801e35:	6a 00                	push   $0x0
  801e37:	6a 00                	push   $0x0
  801e39:	6a 00                	push   $0x0
  801e3b:	ff 75 08             	pushl  0x8(%ebp)
  801e3e:	6a 0d                	push   $0xd
  801e40:	e8 46 fe ff ff       	call   801c8b <syscall>
  801e45:	83 c4 18             	add    $0x18,%esp
}
  801e48:	c9                   	leave  
  801e49:	c3                   	ret    

00801e4a <sys_scarce_memory>:

void sys_scarce_memory()
{
  801e4a:	55                   	push   %ebp
  801e4b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801e4d:	6a 00                	push   $0x0
  801e4f:	6a 00                	push   $0x0
  801e51:	6a 00                	push   $0x0
  801e53:	6a 00                	push   $0x0
  801e55:	6a 00                	push   $0x0
  801e57:	6a 0e                	push   $0xe
  801e59:	e8 2d fe ff ff       	call   801c8b <syscall>
  801e5e:	83 c4 18             	add    $0x18,%esp
}
  801e61:	90                   	nop
  801e62:	c9                   	leave  
  801e63:	c3                   	ret    

00801e64 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801e64:	55                   	push   %ebp
  801e65:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801e67:	6a 00                	push   $0x0
  801e69:	6a 00                	push   $0x0
  801e6b:	6a 00                	push   $0x0
  801e6d:	6a 00                	push   $0x0
  801e6f:	6a 00                	push   $0x0
  801e71:	6a 13                	push   $0x13
  801e73:	e8 13 fe ff ff       	call   801c8b <syscall>
  801e78:	83 c4 18             	add    $0x18,%esp
}
  801e7b:	90                   	nop
  801e7c:	c9                   	leave  
  801e7d:	c3                   	ret    

00801e7e <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801e7e:	55                   	push   %ebp
  801e7f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801e81:	6a 00                	push   $0x0
  801e83:	6a 00                	push   $0x0
  801e85:	6a 00                	push   $0x0
  801e87:	6a 00                	push   $0x0
  801e89:	6a 00                	push   $0x0
  801e8b:	6a 14                	push   $0x14
  801e8d:	e8 f9 fd ff ff       	call   801c8b <syscall>
  801e92:	83 c4 18             	add    $0x18,%esp
}
  801e95:	90                   	nop
  801e96:	c9                   	leave  
  801e97:	c3                   	ret    

00801e98 <sys_cputc>:


void
sys_cputc(const char c)
{
  801e98:	55                   	push   %ebp
  801e99:	89 e5                	mov    %esp,%ebp
  801e9b:	83 ec 04             	sub    $0x4,%esp
  801e9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801ea4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ea8:	6a 00                	push   $0x0
  801eaa:	6a 00                	push   $0x0
  801eac:	6a 00                	push   $0x0
  801eae:	6a 00                	push   $0x0
  801eb0:	50                   	push   %eax
  801eb1:	6a 15                	push   $0x15
  801eb3:	e8 d3 fd ff ff       	call   801c8b <syscall>
  801eb8:	83 c4 18             	add    $0x18,%esp
}
  801ebb:	90                   	nop
  801ebc:	c9                   	leave  
  801ebd:	c3                   	ret    

00801ebe <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801ebe:	55                   	push   %ebp
  801ebf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801ec1:	6a 00                	push   $0x0
  801ec3:	6a 00                	push   $0x0
  801ec5:	6a 00                	push   $0x0
  801ec7:	6a 00                	push   $0x0
  801ec9:	6a 00                	push   $0x0
  801ecb:	6a 16                	push   $0x16
  801ecd:	e8 b9 fd ff ff       	call   801c8b <syscall>
  801ed2:	83 c4 18             	add    $0x18,%esp
}
  801ed5:	90                   	nop
  801ed6:	c9                   	leave  
  801ed7:	c3                   	ret    

00801ed8 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801ed8:	55                   	push   %ebp
  801ed9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801edb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ede:	6a 00                	push   $0x0
  801ee0:	6a 00                	push   $0x0
  801ee2:	6a 00                	push   $0x0
  801ee4:	ff 75 0c             	pushl  0xc(%ebp)
  801ee7:	50                   	push   %eax
  801ee8:	6a 17                	push   $0x17
  801eea:	e8 9c fd ff ff       	call   801c8b <syscall>
  801eef:	83 c4 18             	add    $0x18,%esp
}
  801ef2:	c9                   	leave  
  801ef3:	c3                   	ret    

00801ef4 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801ef4:	55                   	push   %ebp
  801ef5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ef7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801efa:	8b 45 08             	mov    0x8(%ebp),%eax
  801efd:	6a 00                	push   $0x0
  801eff:	6a 00                	push   $0x0
  801f01:	6a 00                	push   $0x0
  801f03:	52                   	push   %edx
  801f04:	50                   	push   %eax
  801f05:	6a 1a                	push   $0x1a
  801f07:	e8 7f fd ff ff       	call   801c8b <syscall>
  801f0c:	83 c4 18             	add    $0x18,%esp
}
  801f0f:	c9                   	leave  
  801f10:	c3                   	ret    

00801f11 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801f11:	55                   	push   %ebp
  801f12:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f14:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f17:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1a:	6a 00                	push   $0x0
  801f1c:	6a 00                	push   $0x0
  801f1e:	6a 00                	push   $0x0
  801f20:	52                   	push   %edx
  801f21:	50                   	push   %eax
  801f22:	6a 18                	push   $0x18
  801f24:	e8 62 fd ff ff       	call   801c8b <syscall>
  801f29:	83 c4 18             	add    $0x18,%esp
}
  801f2c:	90                   	nop
  801f2d:	c9                   	leave  
  801f2e:	c3                   	ret    

00801f2f <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801f2f:	55                   	push   %ebp
  801f30:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f32:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f35:	8b 45 08             	mov    0x8(%ebp),%eax
  801f38:	6a 00                	push   $0x0
  801f3a:	6a 00                	push   $0x0
  801f3c:	6a 00                	push   $0x0
  801f3e:	52                   	push   %edx
  801f3f:	50                   	push   %eax
  801f40:	6a 19                	push   $0x19
  801f42:	e8 44 fd ff ff       	call   801c8b <syscall>
  801f47:	83 c4 18             	add    $0x18,%esp
}
  801f4a:	90                   	nop
  801f4b:	c9                   	leave  
  801f4c:	c3                   	ret    

00801f4d <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801f4d:	55                   	push   %ebp
  801f4e:	89 e5                	mov    %esp,%ebp
  801f50:	83 ec 04             	sub    $0x4,%esp
  801f53:	8b 45 10             	mov    0x10(%ebp),%eax
  801f56:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801f59:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801f5c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f60:	8b 45 08             	mov    0x8(%ebp),%eax
  801f63:	6a 00                	push   $0x0
  801f65:	51                   	push   %ecx
  801f66:	52                   	push   %edx
  801f67:	ff 75 0c             	pushl  0xc(%ebp)
  801f6a:	50                   	push   %eax
  801f6b:	6a 1b                	push   $0x1b
  801f6d:	e8 19 fd ff ff       	call   801c8b <syscall>
  801f72:	83 c4 18             	add    $0x18,%esp
}
  801f75:	c9                   	leave  
  801f76:	c3                   	ret    

00801f77 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801f77:	55                   	push   %ebp
  801f78:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801f7a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f80:	6a 00                	push   $0x0
  801f82:	6a 00                	push   $0x0
  801f84:	6a 00                	push   $0x0
  801f86:	52                   	push   %edx
  801f87:	50                   	push   %eax
  801f88:	6a 1c                	push   $0x1c
  801f8a:	e8 fc fc ff ff       	call   801c8b <syscall>
  801f8f:	83 c4 18             	add    $0x18,%esp
}
  801f92:	c9                   	leave  
  801f93:	c3                   	ret    

00801f94 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801f94:	55                   	push   %ebp
  801f95:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801f97:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f9a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa0:	6a 00                	push   $0x0
  801fa2:	6a 00                	push   $0x0
  801fa4:	51                   	push   %ecx
  801fa5:	52                   	push   %edx
  801fa6:	50                   	push   %eax
  801fa7:	6a 1d                	push   $0x1d
  801fa9:	e8 dd fc ff ff       	call   801c8b <syscall>
  801fae:	83 c4 18             	add    $0x18,%esp
}
  801fb1:	c9                   	leave  
  801fb2:	c3                   	ret    

00801fb3 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801fb3:	55                   	push   %ebp
  801fb4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801fb6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fb9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fbc:	6a 00                	push   $0x0
  801fbe:	6a 00                	push   $0x0
  801fc0:	6a 00                	push   $0x0
  801fc2:	52                   	push   %edx
  801fc3:	50                   	push   %eax
  801fc4:	6a 1e                	push   $0x1e
  801fc6:	e8 c0 fc ff ff       	call   801c8b <syscall>
  801fcb:	83 c4 18             	add    $0x18,%esp
}
  801fce:	c9                   	leave  
  801fcf:	c3                   	ret    

00801fd0 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801fd0:	55                   	push   %ebp
  801fd1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801fd3:	6a 00                	push   $0x0
  801fd5:	6a 00                	push   $0x0
  801fd7:	6a 00                	push   $0x0
  801fd9:	6a 00                	push   $0x0
  801fdb:	6a 00                	push   $0x0
  801fdd:	6a 1f                	push   $0x1f
  801fdf:	e8 a7 fc ff ff       	call   801c8b <syscall>
  801fe4:	83 c4 18             	add    $0x18,%esp
}
  801fe7:	c9                   	leave  
  801fe8:	c3                   	ret    

00801fe9 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801fe9:	55                   	push   %ebp
  801fea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801fec:	8b 45 08             	mov    0x8(%ebp),%eax
  801fef:	6a 00                	push   $0x0
  801ff1:	ff 75 14             	pushl  0x14(%ebp)
  801ff4:	ff 75 10             	pushl  0x10(%ebp)
  801ff7:	ff 75 0c             	pushl  0xc(%ebp)
  801ffa:	50                   	push   %eax
  801ffb:	6a 20                	push   $0x20
  801ffd:	e8 89 fc ff ff       	call   801c8b <syscall>
  802002:	83 c4 18             	add    $0x18,%esp
}
  802005:	c9                   	leave  
  802006:	c3                   	ret    

00802007 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802007:	55                   	push   %ebp
  802008:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80200a:	8b 45 08             	mov    0x8(%ebp),%eax
  80200d:	6a 00                	push   $0x0
  80200f:	6a 00                	push   $0x0
  802011:	6a 00                	push   $0x0
  802013:	6a 00                	push   $0x0
  802015:	50                   	push   %eax
  802016:	6a 21                	push   $0x21
  802018:	e8 6e fc ff ff       	call   801c8b <syscall>
  80201d:	83 c4 18             	add    $0x18,%esp
}
  802020:	90                   	nop
  802021:	c9                   	leave  
  802022:	c3                   	ret    

00802023 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802023:	55                   	push   %ebp
  802024:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802026:	8b 45 08             	mov    0x8(%ebp),%eax
  802029:	6a 00                	push   $0x0
  80202b:	6a 00                	push   $0x0
  80202d:	6a 00                	push   $0x0
  80202f:	6a 00                	push   $0x0
  802031:	50                   	push   %eax
  802032:	6a 22                	push   $0x22
  802034:	e8 52 fc ff ff       	call   801c8b <syscall>
  802039:	83 c4 18             	add    $0x18,%esp
}
  80203c:	c9                   	leave  
  80203d:	c3                   	ret    

0080203e <sys_getenvid>:

int32 sys_getenvid(void)
{
  80203e:	55                   	push   %ebp
  80203f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802041:	6a 00                	push   $0x0
  802043:	6a 00                	push   $0x0
  802045:	6a 00                	push   $0x0
  802047:	6a 00                	push   $0x0
  802049:	6a 00                	push   $0x0
  80204b:	6a 02                	push   $0x2
  80204d:	e8 39 fc ff ff       	call   801c8b <syscall>
  802052:	83 c4 18             	add    $0x18,%esp
}
  802055:	c9                   	leave  
  802056:	c3                   	ret    

00802057 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802057:	55                   	push   %ebp
  802058:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80205a:	6a 00                	push   $0x0
  80205c:	6a 00                	push   $0x0
  80205e:	6a 00                	push   $0x0
  802060:	6a 00                	push   $0x0
  802062:	6a 00                	push   $0x0
  802064:	6a 03                	push   $0x3
  802066:	e8 20 fc ff ff       	call   801c8b <syscall>
  80206b:	83 c4 18             	add    $0x18,%esp
}
  80206e:	c9                   	leave  
  80206f:	c3                   	ret    

00802070 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802070:	55                   	push   %ebp
  802071:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802073:	6a 00                	push   $0x0
  802075:	6a 00                	push   $0x0
  802077:	6a 00                	push   $0x0
  802079:	6a 00                	push   $0x0
  80207b:	6a 00                	push   $0x0
  80207d:	6a 04                	push   $0x4
  80207f:	e8 07 fc ff ff       	call   801c8b <syscall>
  802084:	83 c4 18             	add    $0x18,%esp
}
  802087:	c9                   	leave  
  802088:	c3                   	ret    

00802089 <sys_exit_env>:


void sys_exit_env(void)
{
  802089:	55                   	push   %ebp
  80208a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80208c:	6a 00                	push   $0x0
  80208e:	6a 00                	push   $0x0
  802090:	6a 00                	push   $0x0
  802092:	6a 00                	push   $0x0
  802094:	6a 00                	push   $0x0
  802096:	6a 23                	push   $0x23
  802098:	e8 ee fb ff ff       	call   801c8b <syscall>
  80209d:	83 c4 18             	add    $0x18,%esp
}
  8020a0:	90                   	nop
  8020a1:	c9                   	leave  
  8020a2:	c3                   	ret    

008020a3 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8020a3:	55                   	push   %ebp
  8020a4:	89 e5                	mov    %esp,%ebp
  8020a6:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8020a9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8020ac:	8d 50 04             	lea    0x4(%eax),%edx
  8020af:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8020b2:	6a 00                	push   $0x0
  8020b4:	6a 00                	push   $0x0
  8020b6:	6a 00                	push   $0x0
  8020b8:	52                   	push   %edx
  8020b9:	50                   	push   %eax
  8020ba:	6a 24                	push   $0x24
  8020bc:	e8 ca fb ff ff       	call   801c8b <syscall>
  8020c1:	83 c4 18             	add    $0x18,%esp
	return result;
  8020c4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8020c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8020ca:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8020cd:	89 01                	mov    %eax,(%ecx)
  8020cf:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8020d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d5:	c9                   	leave  
  8020d6:	c2 04 00             	ret    $0x4

008020d9 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8020d9:	55                   	push   %ebp
  8020da:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8020dc:	6a 00                	push   $0x0
  8020de:	6a 00                	push   $0x0
  8020e0:	ff 75 10             	pushl  0x10(%ebp)
  8020e3:	ff 75 0c             	pushl  0xc(%ebp)
  8020e6:	ff 75 08             	pushl  0x8(%ebp)
  8020e9:	6a 12                	push   $0x12
  8020eb:	e8 9b fb ff ff       	call   801c8b <syscall>
  8020f0:	83 c4 18             	add    $0x18,%esp
	return ;
  8020f3:	90                   	nop
}
  8020f4:	c9                   	leave  
  8020f5:	c3                   	ret    

008020f6 <sys_rcr2>:
uint32 sys_rcr2()
{
  8020f6:	55                   	push   %ebp
  8020f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8020f9:	6a 00                	push   $0x0
  8020fb:	6a 00                	push   $0x0
  8020fd:	6a 00                	push   $0x0
  8020ff:	6a 00                	push   $0x0
  802101:	6a 00                	push   $0x0
  802103:	6a 25                	push   $0x25
  802105:	e8 81 fb ff ff       	call   801c8b <syscall>
  80210a:	83 c4 18             	add    $0x18,%esp
}
  80210d:	c9                   	leave  
  80210e:	c3                   	ret    

0080210f <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80210f:	55                   	push   %ebp
  802110:	89 e5                	mov    %esp,%ebp
  802112:	83 ec 04             	sub    $0x4,%esp
  802115:	8b 45 08             	mov    0x8(%ebp),%eax
  802118:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80211b:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80211f:	6a 00                	push   $0x0
  802121:	6a 00                	push   $0x0
  802123:	6a 00                	push   $0x0
  802125:	6a 00                	push   $0x0
  802127:	50                   	push   %eax
  802128:	6a 26                	push   $0x26
  80212a:	e8 5c fb ff ff       	call   801c8b <syscall>
  80212f:	83 c4 18             	add    $0x18,%esp
	return ;
  802132:	90                   	nop
}
  802133:	c9                   	leave  
  802134:	c3                   	ret    

00802135 <rsttst>:
void rsttst()
{
  802135:	55                   	push   %ebp
  802136:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802138:	6a 00                	push   $0x0
  80213a:	6a 00                	push   $0x0
  80213c:	6a 00                	push   $0x0
  80213e:	6a 00                	push   $0x0
  802140:	6a 00                	push   $0x0
  802142:	6a 28                	push   $0x28
  802144:	e8 42 fb ff ff       	call   801c8b <syscall>
  802149:	83 c4 18             	add    $0x18,%esp
	return ;
  80214c:	90                   	nop
}
  80214d:	c9                   	leave  
  80214e:	c3                   	ret    

0080214f <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80214f:	55                   	push   %ebp
  802150:	89 e5                	mov    %esp,%ebp
  802152:	83 ec 04             	sub    $0x4,%esp
  802155:	8b 45 14             	mov    0x14(%ebp),%eax
  802158:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80215b:	8b 55 18             	mov    0x18(%ebp),%edx
  80215e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802162:	52                   	push   %edx
  802163:	50                   	push   %eax
  802164:	ff 75 10             	pushl  0x10(%ebp)
  802167:	ff 75 0c             	pushl  0xc(%ebp)
  80216a:	ff 75 08             	pushl  0x8(%ebp)
  80216d:	6a 27                	push   $0x27
  80216f:	e8 17 fb ff ff       	call   801c8b <syscall>
  802174:	83 c4 18             	add    $0x18,%esp
	return ;
  802177:	90                   	nop
}
  802178:	c9                   	leave  
  802179:	c3                   	ret    

0080217a <chktst>:
void chktst(uint32 n)
{
  80217a:	55                   	push   %ebp
  80217b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80217d:	6a 00                	push   $0x0
  80217f:	6a 00                	push   $0x0
  802181:	6a 00                	push   $0x0
  802183:	6a 00                	push   $0x0
  802185:	ff 75 08             	pushl  0x8(%ebp)
  802188:	6a 29                	push   $0x29
  80218a:	e8 fc fa ff ff       	call   801c8b <syscall>
  80218f:	83 c4 18             	add    $0x18,%esp
	return ;
  802192:	90                   	nop
}
  802193:	c9                   	leave  
  802194:	c3                   	ret    

00802195 <inctst>:

void inctst()
{
  802195:	55                   	push   %ebp
  802196:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802198:	6a 00                	push   $0x0
  80219a:	6a 00                	push   $0x0
  80219c:	6a 00                	push   $0x0
  80219e:	6a 00                	push   $0x0
  8021a0:	6a 00                	push   $0x0
  8021a2:	6a 2a                	push   $0x2a
  8021a4:	e8 e2 fa ff ff       	call   801c8b <syscall>
  8021a9:	83 c4 18             	add    $0x18,%esp
	return ;
  8021ac:	90                   	nop
}
  8021ad:	c9                   	leave  
  8021ae:	c3                   	ret    

008021af <gettst>:
uint32 gettst()
{
  8021af:	55                   	push   %ebp
  8021b0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8021b2:	6a 00                	push   $0x0
  8021b4:	6a 00                	push   $0x0
  8021b6:	6a 00                	push   $0x0
  8021b8:	6a 00                	push   $0x0
  8021ba:	6a 00                	push   $0x0
  8021bc:	6a 2b                	push   $0x2b
  8021be:	e8 c8 fa ff ff       	call   801c8b <syscall>
  8021c3:	83 c4 18             	add    $0x18,%esp
}
  8021c6:	c9                   	leave  
  8021c7:	c3                   	ret    

008021c8 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8021c8:	55                   	push   %ebp
  8021c9:	89 e5                	mov    %esp,%ebp
  8021cb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021ce:	6a 00                	push   $0x0
  8021d0:	6a 00                	push   $0x0
  8021d2:	6a 00                	push   $0x0
  8021d4:	6a 00                	push   $0x0
  8021d6:	6a 00                	push   $0x0
  8021d8:	6a 2c                	push   $0x2c
  8021da:	e8 ac fa ff ff       	call   801c8b <syscall>
  8021df:	83 c4 18             	add    $0x18,%esp
  8021e2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8021e5:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8021e9:	75 07                	jne    8021f2 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8021eb:	b8 01 00 00 00       	mov    $0x1,%eax
  8021f0:	eb 05                	jmp    8021f7 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8021f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021f7:	c9                   	leave  
  8021f8:	c3                   	ret    

008021f9 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8021f9:	55                   	push   %ebp
  8021fa:	89 e5                	mov    %esp,%ebp
  8021fc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021ff:	6a 00                	push   $0x0
  802201:	6a 00                	push   $0x0
  802203:	6a 00                	push   $0x0
  802205:	6a 00                	push   $0x0
  802207:	6a 00                	push   $0x0
  802209:	6a 2c                	push   $0x2c
  80220b:	e8 7b fa ff ff       	call   801c8b <syscall>
  802210:	83 c4 18             	add    $0x18,%esp
  802213:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802216:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80221a:	75 07                	jne    802223 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80221c:	b8 01 00 00 00       	mov    $0x1,%eax
  802221:	eb 05                	jmp    802228 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802223:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802228:	c9                   	leave  
  802229:	c3                   	ret    

0080222a <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80222a:	55                   	push   %ebp
  80222b:	89 e5                	mov    %esp,%ebp
  80222d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802230:	6a 00                	push   $0x0
  802232:	6a 00                	push   $0x0
  802234:	6a 00                	push   $0x0
  802236:	6a 00                	push   $0x0
  802238:	6a 00                	push   $0x0
  80223a:	6a 2c                	push   $0x2c
  80223c:	e8 4a fa ff ff       	call   801c8b <syscall>
  802241:	83 c4 18             	add    $0x18,%esp
  802244:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802247:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80224b:	75 07                	jne    802254 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80224d:	b8 01 00 00 00       	mov    $0x1,%eax
  802252:	eb 05                	jmp    802259 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802254:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802259:	c9                   	leave  
  80225a:	c3                   	ret    

0080225b <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80225b:	55                   	push   %ebp
  80225c:	89 e5                	mov    %esp,%ebp
  80225e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802261:	6a 00                	push   $0x0
  802263:	6a 00                	push   $0x0
  802265:	6a 00                	push   $0x0
  802267:	6a 00                	push   $0x0
  802269:	6a 00                	push   $0x0
  80226b:	6a 2c                	push   $0x2c
  80226d:	e8 19 fa ff ff       	call   801c8b <syscall>
  802272:	83 c4 18             	add    $0x18,%esp
  802275:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802278:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80227c:	75 07                	jne    802285 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80227e:	b8 01 00 00 00       	mov    $0x1,%eax
  802283:	eb 05                	jmp    80228a <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802285:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80228a:	c9                   	leave  
  80228b:	c3                   	ret    

0080228c <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80228c:	55                   	push   %ebp
  80228d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80228f:	6a 00                	push   $0x0
  802291:	6a 00                	push   $0x0
  802293:	6a 00                	push   $0x0
  802295:	6a 00                	push   $0x0
  802297:	ff 75 08             	pushl  0x8(%ebp)
  80229a:	6a 2d                	push   $0x2d
  80229c:	e8 ea f9 ff ff       	call   801c8b <syscall>
  8022a1:	83 c4 18             	add    $0x18,%esp
	return ;
  8022a4:	90                   	nop
}
  8022a5:	c9                   	leave  
  8022a6:	c3                   	ret    

008022a7 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8022a7:	55                   	push   %ebp
  8022a8:	89 e5                	mov    %esp,%ebp
  8022aa:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8022ab:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8022ae:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8022b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b7:	6a 00                	push   $0x0
  8022b9:	53                   	push   %ebx
  8022ba:	51                   	push   %ecx
  8022bb:	52                   	push   %edx
  8022bc:	50                   	push   %eax
  8022bd:	6a 2e                	push   $0x2e
  8022bf:	e8 c7 f9 ff ff       	call   801c8b <syscall>
  8022c4:	83 c4 18             	add    $0x18,%esp
}
  8022c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022ca:	c9                   	leave  
  8022cb:	c3                   	ret    

008022cc <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8022cc:	55                   	push   %ebp
  8022cd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8022cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d5:	6a 00                	push   $0x0
  8022d7:	6a 00                	push   $0x0
  8022d9:	6a 00                	push   $0x0
  8022db:	52                   	push   %edx
  8022dc:	50                   	push   %eax
  8022dd:	6a 2f                	push   $0x2f
  8022df:	e8 a7 f9 ff ff       	call   801c8b <syscall>
  8022e4:	83 c4 18             	add    $0x18,%esp
}
  8022e7:	c9                   	leave  
  8022e8:	c3                   	ret    

008022e9 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8022e9:	55                   	push   %ebp
  8022ea:	89 e5                	mov    %esp,%ebp
  8022ec:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8022ef:	83 ec 0c             	sub    $0xc,%esp
  8022f2:	68 20 44 80 00       	push   $0x804420
  8022f7:	e8 d6 e6 ff ff       	call   8009d2 <cprintf>
  8022fc:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8022ff:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802306:	83 ec 0c             	sub    $0xc,%esp
  802309:	68 4c 44 80 00       	push   $0x80444c
  80230e:	e8 bf e6 ff ff       	call   8009d2 <cprintf>
  802313:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802316:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80231a:	a1 38 51 80 00       	mov    0x805138,%eax
  80231f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802322:	eb 56                	jmp    80237a <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802324:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802328:	74 1c                	je     802346 <print_mem_block_lists+0x5d>
  80232a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232d:	8b 50 08             	mov    0x8(%eax),%edx
  802330:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802333:	8b 48 08             	mov    0x8(%eax),%ecx
  802336:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802339:	8b 40 0c             	mov    0xc(%eax),%eax
  80233c:	01 c8                	add    %ecx,%eax
  80233e:	39 c2                	cmp    %eax,%edx
  802340:	73 04                	jae    802346 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802342:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802346:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802349:	8b 50 08             	mov    0x8(%eax),%edx
  80234c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234f:	8b 40 0c             	mov    0xc(%eax),%eax
  802352:	01 c2                	add    %eax,%edx
  802354:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802357:	8b 40 08             	mov    0x8(%eax),%eax
  80235a:	83 ec 04             	sub    $0x4,%esp
  80235d:	52                   	push   %edx
  80235e:	50                   	push   %eax
  80235f:	68 61 44 80 00       	push   $0x804461
  802364:	e8 69 e6 ff ff       	call   8009d2 <cprintf>
  802369:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80236c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802372:	a1 40 51 80 00       	mov    0x805140,%eax
  802377:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80237a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80237e:	74 07                	je     802387 <print_mem_block_lists+0x9e>
  802380:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802383:	8b 00                	mov    (%eax),%eax
  802385:	eb 05                	jmp    80238c <print_mem_block_lists+0xa3>
  802387:	b8 00 00 00 00       	mov    $0x0,%eax
  80238c:	a3 40 51 80 00       	mov    %eax,0x805140
  802391:	a1 40 51 80 00       	mov    0x805140,%eax
  802396:	85 c0                	test   %eax,%eax
  802398:	75 8a                	jne    802324 <print_mem_block_lists+0x3b>
  80239a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80239e:	75 84                	jne    802324 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8023a0:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8023a4:	75 10                	jne    8023b6 <print_mem_block_lists+0xcd>
  8023a6:	83 ec 0c             	sub    $0xc,%esp
  8023a9:	68 70 44 80 00       	push   $0x804470
  8023ae:	e8 1f e6 ff ff       	call   8009d2 <cprintf>
  8023b3:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8023b6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8023bd:	83 ec 0c             	sub    $0xc,%esp
  8023c0:	68 94 44 80 00       	push   $0x804494
  8023c5:	e8 08 e6 ff ff       	call   8009d2 <cprintf>
  8023ca:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8023cd:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8023d1:	a1 40 50 80 00       	mov    0x805040,%eax
  8023d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023d9:	eb 56                	jmp    802431 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8023db:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023df:	74 1c                	je     8023fd <print_mem_block_lists+0x114>
  8023e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e4:	8b 50 08             	mov    0x8(%eax),%edx
  8023e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023ea:	8b 48 08             	mov    0x8(%eax),%ecx
  8023ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023f0:	8b 40 0c             	mov    0xc(%eax),%eax
  8023f3:	01 c8                	add    %ecx,%eax
  8023f5:	39 c2                	cmp    %eax,%edx
  8023f7:	73 04                	jae    8023fd <print_mem_block_lists+0x114>
			sorted = 0 ;
  8023f9:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8023fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802400:	8b 50 08             	mov    0x8(%eax),%edx
  802403:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802406:	8b 40 0c             	mov    0xc(%eax),%eax
  802409:	01 c2                	add    %eax,%edx
  80240b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240e:	8b 40 08             	mov    0x8(%eax),%eax
  802411:	83 ec 04             	sub    $0x4,%esp
  802414:	52                   	push   %edx
  802415:	50                   	push   %eax
  802416:	68 61 44 80 00       	push   $0x804461
  80241b:	e8 b2 e5 ff ff       	call   8009d2 <cprintf>
  802420:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802423:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802426:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802429:	a1 48 50 80 00       	mov    0x805048,%eax
  80242e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802431:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802435:	74 07                	je     80243e <print_mem_block_lists+0x155>
  802437:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243a:	8b 00                	mov    (%eax),%eax
  80243c:	eb 05                	jmp    802443 <print_mem_block_lists+0x15a>
  80243e:	b8 00 00 00 00       	mov    $0x0,%eax
  802443:	a3 48 50 80 00       	mov    %eax,0x805048
  802448:	a1 48 50 80 00       	mov    0x805048,%eax
  80244d:	85 c0                	test   %eax,%eax
  80244f:	75 8a                	jne    8023db <print_mem_block_lists+0xf2>
  802451:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802455:	75 84                	jne    8023db <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802457:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80245b:	75 10                	jne    80246d <print_mem_block_lists+0x184>
  80245d:	83 ec 0c             	sub    $0xc,%esp
  802460:	68 ac 44 80 00       	push   $0x8044ac
  802465:	e8 68 e5 ff ff       	call   8009d2 <cprintf>
  80246a:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80246d:	83 ec 0c             	sub    $0xc,%esp
  802470:	68 20 44 80 00       	push   $0x804420
  802475:	e8 58 e5 ff ff       	call   8009d2 <cprintf>
  80247a:	83 c4 10             	add    $0x10,%esp

}
  80247d:	90                   	nop
  80247e:	c9                   	leave  
  80247f:	c3                   	ret    

00802480 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802480:	55                   	push   %ebp
  802481:	89 e5                	mov    %esp,%ebp
  802483:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  802486:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  80248d:	00 00 00 
  802490:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802497:	00 00 00 
  80249a:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8024a1:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  8024a4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8024ab:	e9 9e 00 00 00       	jmp    80254e <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  8024b0:	a1 50 50 80 00       	mov    0x805050,%eax
  8024b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024b8:	c1 e2 04             	shl    $0x4,%edx
  8024bb:	01 d0                	add    %edx,%eax
  8024bd:	85 c0                	test   %eax,%eax
  8024bf:	75 14                	jne    8024d5 <initialize_MemBlocksList+0x55>
  8024c1:	83 ec 04             	sub    $0x4,%esp
  8024c4:	68 d4 44 80 00       	push   $0x8044d4
  8024c9:	6a 46                	push   $0x46
  8024cb:	68 f7 44 80 00       	push   $0x8044f7
  8024d0:	e8 49 e2 ff ff       	call   80071e <_panic>
  8024d5:	a1 50 50 80 00       	mov    0x805050,%eax
  8024da:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024dd:	c1 e2 04             	shl    $0x4,%edx
  8024e0:	01 d0                	add    %edx,%eax
  8024e2:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8024e8:	89 10                	mov    %edx,(%eax)
  8024ea:	8b 00                	mov    (%eax),%eax
  8024ec:	85 c0                	test   %eax,%eax
  8024ee:	74 18                	je     802508 <initialize_MemBlocksList+0x88>
  8024f0:	a1 48 51 80 00       	mov    0x805148,%eax
  8024f5:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8024fb:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8024fe:	c1 e1 04             	shl    $0x4,%ecx
  802501:	01 ca                	add    %ecx,%edx
  802503:	89 50 04             	mov    %edx,0x4(%eax)
  802506:	eb 12                	jmp    80251a <initialize_MemBlocksList+0x9a>
  802508:	a1 50 50 80 00       	mov    0x805050,%eax
  80250d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802510:	c1 e2 04             	shl    $0x4,%edx
  802513:	01 d0                	add    %edx,%eax
  802515:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80251a:	a1 50 50 80 00       	mov    0x805050,%eax
  80251f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802522:	c1 e2 04             	shl    $0x4,%edx
  802525:	01 d0                	add    %edx,%eax
  802527:	a3 48 51 80 00       	mov    %eax,0x805148
  80252c:	a1 50 50 80 00       	mov    0x805050,%eax
  802531:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802534:	c1 e2 04             	shl    $0x4,%edx
  802537:	01 d0                	add    %edx,%eax
  802539:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802540:	a1 54 51 80 00       	mov    0x805154,%eax
  802545:	40                   	inc    %eax
  802546:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  80254b:	ff 45 f4             	incl   -0xc(%ebp)
  80254e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802551:	3b 45 08             	cmp    0x8(%ebp),%eax
  802554:	0f 82 56 ff ff ff    	jb     8024b0 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  80255a:	90                   	nop
  80255b:	c9                   	leave  
  80255c:	c3                   	ret    

0080255d <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80255d:	55                   	push   %ebp
  80255e:	89 e5                	mov    %esp,%ebp
  802560:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802563:	8b 45 08             	mov    0x8(%ebp),%eax
  802566:	8b 00                	mov    (%eax),%eax
  802568:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80256b:	eb 19                	jmp    802586 <find_block+0x29>
	{
		if(va==point->sva)
  80256d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802570:	8b 40 08             	mov    0x8(%eax),%eax
  802573:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802576:	75 05                	jne    80257d <find_block+0x20>
		   return point;
  802578:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80257b:	eb 36                	jmp    8025b3 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80257d:	8b 45 08             	mov    0x8(%ebp),%eax
  802580:	8b 40 08             	mov    0x8(%eax),%eax
  802583:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802586:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80258a:	74 07                	je     802593 <find_block+0x36>
  80258c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80258f:	8b 00                	mov    (%eax),%eax
  802591:	eb 05                	jmp    802598 <find_block+0x3b>
  802593:	b8 00 00 00 00       	mov    $0x0,%eax
  802598:	8b 55 08             	mov    0x8(%ebp),%edx
  80259b:	89 42 08             	mov    %eax,0x8(%edx)
  80259e:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a1:	8b 40 08             	mov    0x8(%eax),%eax
  8025a4:	85 c0                	test   %eax,%eax
  8025a6:	75 c5                	jne    80256d <find_block+0x10>
  8025a8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8025ac:	75 bf                	jne    80256d <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  8025ae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025b3:	c9                   	leave  
  8025b4:	c3                   	ret    

008025b5 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8025b5:	55                   	push   %ebp
  8025b6:	89 e5                	mov    %esp,%ebp
  8025b8:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  8025bb:	a1 40 50 80 00       	mov    0x805040,%eax
  8025c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  8025c3:	a1 44 50 80 00       	mov    0x805044,%eax
  8025c8:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8025cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025ce:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8025d1:	74 24                	je     8025f7 <insert_sorted_allocList+0x42>
  8025d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d6:	8b 50 08             	mov    0x8(%eax),%edx
  8025d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025dc:	8b 40 08             	mov    0x8(%eax),%eax
  8025df:	39 c2                	cmp    %eax,%edx
  8025e1:	76 14                	jbe    8025f7 <insert_sorted_allocList+0x42>
  8025e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e6:	8b 50 08             	mov    0x8(%eax),%edx
  8025e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025ec:	8b 40 08             	mov    0x8(%eax),%eax
  8025ef:	39 c2                	cmp    %eax,%edx
  8025f1:	0f 82 60 01 00 00    	jb     802757 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8025f7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025fb:	75 65                	jne    802662 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8025fd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802601:	75 14                	jne    802617 <insert_sorted_allocList+0x62>
  802603:	83 ec 04             	sub    $0x4,%esp
  802606:	68 d4 44 80 00       	push   $0x8044d4
  80260b:	6a 6b                	push   $0x6b
  80260d:	68 f7 44 80 00       	push   $0x8044f7
  802612:	e8 07 e1 ff ff       	call   80071e <_panic>
  802617:	8b 15 40 50 80 00    	mov    0x805040,%edx
  80261d:	8b 45 08             	mov    0x8(%ebp),%eax
  802620:	89 10                	mov    %edx,(%eax)
  802622:	8b 45 08             	mov    0x8(%ebp),%eax
  802625:	8b 00                	mov    (%eax),%eax
  802627:	85 c0                	test   %eax,%eax
  802629:	74 0d                	je     802638 <insert_sorted_allocList+0x83>
  80262b:	a1 40 50 80 00       	mov    0x805040,%eax
  802630:	8b 55 08             	mov    0x8(%ebp),%edx
  802633:	89 50 04             	mov    %edx,0x4(%eax)
  802636:	eb 08                	jmp    802640 <insert_sorted_allocList+0x8b>
  802638:	8b 45 08             	mov    0x8(%ebp),%eax
  80263b:	a3 44 50 80 00       	mov    %eax,0x805044
  802640:	8b 45 08             	mov    0x8(%ebp),%eax
  802643:	a3 40 50 80 00       	mov    %eax,0x805040
  802648:	8b 45 08             	mov    0x8(%ebp),%eax
  80264b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802652:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802657:	40                   	inc    %eax
  802658:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80265d:	e9 dc 01 00 00       	jmp    80283e <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802662:	8b 45 08             	mov    0x8(%ebp),%eax
  802665:	8b 50 08             	mov    0x8(%eax),%edx
  802668:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80266b:	8b 40 08             	mov    0x8(%eax),%eax
  80266e:	39 c2                	cmp    %eax,%edx
  802670:	77 6c                	ja     8026de <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802672:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802676:	74 06                	je     80267e <insert_sorted_allocList+0xc9>
  802678:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80267c:	75 14                	jne    802692 <insert_sorted_allocList+0xdd>
  80267e:	83 ec 04             	sub    $0x4,%esp
  802681:	68 10 45 80 00       	push   $0x804510
  802686:	6a 6f                	push   $0x6f
  802688:	68 f7 44 80 00       	push   $0x8044f7
  80268d:	e8 8c e0 ff ff       	call   80071e <_panic>
  802692:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802695:	8b 50 04             	mov    0x4(%eax),%edx
  802698:	8b 45 08             	mov    0x8(%ebp),%eax
  80269b:	89 50 04             	mov    %edx,0x4(%eax)
  80269e:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026a4:	89 10                	mov    %edx,(%eax)
  8026a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026a9:	8b 40 04             	mov    0x4(%eax),%eax
  8026ac:	85 c0                	test   %eax,%eax
  8026ae:	74 0d                	je     8026bd <insert_sorted_allocList+0x108>
  8026b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026b3:	8b 40 04             	mov    0x4(%eax),%eax
  8026b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8026b9:	89 10                	mov    %edx,(%eax)
  8026bb:	eb 08                	jmp    8026c5 <insert_sorted_allocList+0x110>
  8026bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c0:	a3 40 50 80 00       	mov    %eax,0x805040
  8026c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8026cb:	89 50 04             	mov    %edx,0x4(%eax)
  8026ce:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8026d3:	40                   	inc    %eax
  8026d4:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8026d9:	e9 60 01 00 00       	jmp    80283e <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8026de:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e1:	8b 50 08             	mov    0x8(%eax),%edx
  8026e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026e7:	8b 40 08             	mov    0x8(%eax),%eax
  8026ea:	39 c2                	cmp    %eax,%edx
  8026ec:	0f 82 4c 01 00 00    	jb     80283e <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8026f2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8026f6:	75 14                	jne    80270c <insert_sorted_allocList+0x157>
  8026f8:	83 ec 04             	sub    $0x4,%esp
  8026fb:	68 48 45 80 00       	push   $0x804548
  802700:	6a 73                	push   $0x73
  802702:	68 f7 44 80 00       	push   $0x8044f7
  802707:	e8 12 e0 ff ff       	call   80071e <_panic>
  80270c:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802712:	8b 45 08             	mov    0x8(%ebp),%eax
  802715:	89 50 04             	mov    %edx,0x4(%eax)
  802718:	8b 45 08             	mov    0x8(%ebp),%eax
  80271b:	8b 40 04             	mov    0x4(%eax),%eax
  80271e:	85 c0                	test   %eax,%eax
  802720:	74 0c                	je     80272e <insert_sorted_allocList+0x179>
  802722:	a1 44 50 80 00       	mov    0x805044,%eax
  802727:	8b 55 08             	mov    0x8(%ebp),%edx
  80272a:	89 10                	mov    %edx,(%eax)
  80272c:	eb 08                	jmp    802736 <insert_sorted_allocList+0x181>
  80272e:	8b 45 08             	mov    0x8(%ebp),%eax
  802731:	a3 40 50 80 00       	mov    %eax,0x805040
  802736:	8b 45 08             	mov    0x8(%ebp),%eax
  802739:	a3 44 50 80 00       	mov    %eax,0x805044
  80273e:	8b 45 08             	mov    0x8(%ebp),%eax
  802741:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802747:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80274c:	40                   	inc    %eax
  80274d:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802752:	e9 e7 00 00 00       	jmp    80283e <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802757:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80275a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  80275d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802764:	a1 40 50 80 00       	mov    0x805040,%eax
  802769:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80276c:	e9 9d 00 00 00       	jmp    80280e <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802771:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802774:	8b 00                	mov    (%eax),%eax
  802776:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802779:	8b 45 08             	mov    0x8(%ebp),%eax
  80277c:	8b 50 08             	mov    0x8(%eax),%edx
  80277f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802782:	8b 40 08             	mov    0x8(%eax),%eax
  802785:	39 c2                	cmp    %eax,%edx
  802787:	76 7d                	jbe    802806 <insert_sorted_allocList+0x251>
  802789:	8b 45 08             	mov    0x8(%ebp),%eax
  80278c:	8b 50 08             	mov    0x8(%eax),%edx
  80278f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802792:	8b 40 08             	mov    0x8(%eax),%eax
  802795:	39 c2                	cmp    %eax,%edx
  802797:	73 6d                	jae    802806 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802799:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80279d:	74 06                	je     8027a5 <insert_sorted_allocList+0x1f0>
  80279f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8027a3:	75 14                	jne    8027b9 <insert_sorted_allocList+0x204>
  8027a5:	83 ec 04             	sub    $0x4,%esp
  8027a8:	68 6c 45 80 00       	push   $0x80456c
  8027ad:	6a 7f                	push   $0x7f
  8027af:	68 f7 44 80 00       	push   $0x8044f7
  8027b4:	e8 65 df ff ff       	call   80071e <_panic>
  8027b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027bc:	8b 10                	mov    (%eax),%edx
  8027be:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c1:	89 10                	mov    %edx,(%eax)
  8027c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c6:	8b 00                	mov    (%eax),%eax
  8027c8:	85 c0                	test   %eax,%eax
  8027ca:	74 0b                	je     8027d7 <insert_sorted_allocList+0x222>
  8027cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cf:	8b 00                	mov    (%eax),%eax
  8027d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8027d4:	89 50 04             	mov    %edx,0x4(%eax)
  8027d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027da:	8b 55 08             	mov    0x8(%ebp),%edx
  8027dd:	89 10                	mov    %edx,(%eax)
  8027df:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027e5:	89 50 04             	mov    %edx,0x4(%eax)
  8027e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8027eb:	8b 00                	mov    (%eax),%eax
  8027ed:	85 c0                	test   %eax,%eax
  8027ef:	75 08                	jne    8027f9 <insert_sorted_allocList+0x244>
  8027f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f4:	a3 44 50 80 00       	mov    %eax,0x805044
  8027f9:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8027fe:	40                   	inc    %eax
  8027ff:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802804:	eb 39                	jmp    80283f <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802806:	a1 48 50 80 00       	mov    0x805048,%eax
  80280b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80280e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802812:	74 07                	je     80281b <insert_sorted_allocList+0x266>
  802814:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802817:	8b 00                	mov    (%eax),%eax
  802819:	eb 05                	jmp    802820 <insert_sorted_allocList+0x26b>
  80281b:	b8 00 00 00 00       	mov    $0x0,%eax
  802820:	a3 48 50 80 00       	mov    %eax,0x805048
  802825:	a1 48 50 80 00       	mov    0x805048,%eax
  80282a:	85 c0                	test   %eax,%eax
  80282c:	0f 85 3f ff ff ff    	jne    802771 <insert_sorted_allocList+0x1bc>
  802832:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802836:	0f 85 35 ff ff ff    	jne    802771 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80283c:	eb 01                	jmp    80283f <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80283e:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80283f:	90                   	nop
  802840:	c9                   	leave  
  802841:	c3                   	ret    

00802842 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802842:	55                   	push   %ebp
  802843:	89 e5                	mov    %esp,%ebp
  802845:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802848:	a1 38 51 80 00       	mov    0x805138,%eax
  80284d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802850:	e9 85 01 00 00       	jmp    8029da <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802855:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802858:	8b 40 0c             	mov    0xc(%eax),%eax
  80285b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80285e:	0f 82 6e 01 00 00    	jb     8029d2 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802864:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802867:	8b 40 0c             	mov    0xc(%eax),%eax
  80286a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80286d:	0f 85 8a 00 00 00    	jne    8028fd <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802873:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802877:	75 17                	jne    802890 <alloc_block_FF+0x4e>
  802879:	83 ec 04             	sub    $0x4,%esp
  80287c:	68 a0 45 80 00       	push   $0x8045a0
  802881:	68 93 00 00 00       	push   $0x93
  802886:	68 f7 44 80 00       	push   $0x8044f7
  80288b:	e8 8e de ff ff       	call   80071e <_panic>
  802890:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802893:	8b 00                	mov    (%eax),%eax
  802895:	85 c0                	test   %eax,%eax
  802897:	74 10                	je     8028a9 <alloc_block_FF+0x67>
  802899:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289c:	8b 00                	mov    (%eax),%eax
  80289e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028a1:	8b 52 04             	mov    0x4(%edx),%edx
  8028a4:	89 50 04             	mov    %edx,0x4(%eax)
  8028a7:	eb 0b                	jmp    8028b4 <alloc_block_FF+0x72>
  8028a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ac:	8b 40 04             	mov    0x4(%eax),%eax
  8028af:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8028b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b7:	8b 40 04             	mov    0x4(%eax),%eax
  8028ba:	85 c0                	test   %eax,%eax
  8028bc:	74 0f                	je     8028cd <alloc_block_FF+0x8b>
  8028be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c1:	8b 40 04             	mov    0x4(%eax),%eax
  8028c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028c7:	8b 12                	mov    (%edx),%edx
  8028c9:	89 10                	mov    %edx,(%eax)
  8028cb:	eb 0a                	jmp    8028d7 <alloc_block_FF+0x95>
  8028cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d0:	8b 00                	mov    (%eax),%eax
  8028d2:	a3 38 51 80 00       	mov    %eax,0x805138
  8028d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028da:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028ea:	a1 44 51 80 00       	mov    0x805144,%eax
  8028ef:	48                   	dec    %eax
  8028f0:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  8028f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f8:	e9 10 01 00 00       	jmp    802a0d <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8028fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802900:	8b 40 0c             	mov    0xc(%eax),%eax
  802903:	3b 45 08             	cmp    0x8(%ebp),%eax
  802906:	0f 86 c6 00 00 00    	jbe    8029d2 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80290c:	a1 48 51 80 00       	mov    0x805148,%eax
  802911:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802914:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802917:	8b 50 08             	mov    0x8(%eax),%edx
  80291a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80291d:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802920:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802923:	8b 55 08             	mov    0x8(%ebp),%edx
  802926:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802929:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80292d:	75 17                	jne    802946 <alloc_block_FF+0x104>
  80292f:	83 ec 04             	sub    $0x4,%esp
  802932:	68 a0 45 80 00       	push   $0x8045a0
  802937:	68 9b 00 00 00       	push   $0x9b
  80293c:	68 f7 44 80 00       	push   $0x8044f7
  802941:	e8 d8 dd ff ff       	call   80071e <_panic>
  802946:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802949:	8b 00                	mov    (%eax),%eax
  80294b:	85 c0                	test   %eax,%eax
  80294d:	74 10                	je     80295f <alloc_block_FF+0x11d>
  80294f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802952:	8b 00                	mov    (%eax),%eax
  802954:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802957:	8b 52 04             	mov    0x4(%edx),%edx
  80295a:	89 50 04             	mov    %edx,0x4(%eax)
  80295d:	eb 0b                	jmp    80296a <alloc_block_FF+0x128>
  80295f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802962:	8b 40 04             	mov    0x4(%eax),%eax
  802965:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80296a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80296d:	8b 40 04             	mov    0x4(%eax),%eax
  802970:	85 c0                	test   %eax,%eax
  802972:	74 0f                	je     802983 <alloc_block_FF+0x141>
  802974:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802977:	8b 40 04             	mov    0x4(%eax),%eax
  80297a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80297d:	8b 12                	mov    (%edx),%edx
  80297f:	89 10                	mov    %edx,(%eax)
  802981:	eb 0a                	jmp    80298d <alloc_block_FF+0x14b>
  802983:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802986:	8b 00                	mov    (%eax),%eax
  802988:	a3 48 51 80 00       	mov    %eax,0x805148
  80298d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802990:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802996:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802999:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029a0:	a1 54 51 80 00       	mov    0x805154,%eax
  8029a5:	48                   	dec    %eax
  8029a6:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  8029ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ae:	8b 50 08             	mov    0x8(%eax),%edx
  8029b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b4:	01 c2                	add    %eax,%edx
  8029b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b9:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8029bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bf:	8b 40 0c             	mov    0xc(%eax),%eax
  8029c2:	2b 45 08             	sub    0x8(%ebp),%eax
  8029c5:	89 c2                	mov    %eax,%edx
  8029c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ca:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8029cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029d0:	eb 3b                	jmp    802a0d <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8029d2:	a1 40 51 80 00       	mov    0x805140,%eax
  8029d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029da:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029de:	74 07                	je     8029e7 <alloc_block_FF+0x1a5>
  8029e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e3:	8b 00                	mov    (%eax),%eax
  8029e5:	eb 05                	jmp    8029ec <alloc_block_FF+0x1aa>
  8029e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8029ec:	a3 40 51 80 00       	mov    %eax,0x805140
  8029f1:	a1 40 51 80 00       	mov    0x805140,%eax
  8029f6:	85 c0                	test   %eax,%eax
  8029f8:	0f 85 57 fe ff ff    	jne    802855 <alloc_block_FF+0x13>
  8029fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a02:	0f 85 4d fe ff ff    	jne    802855 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802a08:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a0d:	c9                   	leave  
  802a0e:	c3                   	ret    

00802a0f <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802a0f:	55                   	push   %ebp
  802a10:	89 e5                	mov    %esp,%ebp
  802a12:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802a15:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802a1c:	a1 38 51 80 00       	mov    0x805138,%eax
  802a21:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a24:	e9 df 00 00 00       	jmp    802b08 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802a29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2c:	8b 40 0c             	mov    0xc(%eax),%eax
  802a2f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a32:	0f 82 c8 00 00 00    	jb     802b00 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802a38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3b:	8b 40 0c             	mov    0xc(%eax),%eax
  802a3e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a41:	0f 85 8a 00 00 00    	jne    802ad1 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802a47:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a4b:	75 17                	jne    802a64 <alloc_block_BF+0x55>
  802a4d:	83 ec 04             	sub    $0x4,%esp
  802a50:	68 a0 45 80 00       	push   $0x8045a0
  802a55:	68 b7 00 00 00       	push   $0xb7
  802a5a:	68 f7 44 80 00       	push   $0x8044f7
  802a5f:	e8 ba dc ff ff       	call   80071e <_panic>
  802a64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a67:	8b 00                	mov    (%eax),%eax
  802a69:	85 c0                	test   %eax,%eax
  802a6b:	74 10                	je     802a7d <alloc_block_BF+0x6e>
  802a6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a70:	8b 00                	mov    (%eax),%eax
  802a72:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a75:	8b 52 04             	mov    0x4(%edx),%edx
  802a78:	89 50 04             	mov    %edx,0x4(%eax)
  802a7b:	eb 0b                	jmp    802a88 <alloc_block_BF+0x79>
  802a7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a80:	8b 40 04             	mov    0x4(%eax),%eax
  802a83:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8b:	8b 40 04             	mov    0x4(%eax),%eax
  802a8e:	85 c0                	test   %eax,%eax
  802a90:	74 0f                	je     802aa1 <alloc_block_BF+0x92>
  802a92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a95:	8b 40 04             	mov    0x4(%eax),%eax
  802a98:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a9b:	8b 12                	mov    (%edx),%edx
  802a9d:	89 10                	mov    %edx,(%eax)
  802a9f:	eb 0a                	jmp    802aab <alloc_block_BF+0x9c>
  802aa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa4:	8b 00                	mov    (%eax),%eax
  802aa6:	a3 38 51 80 00       	mov    %eax,0x805138
  802aab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ab4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802abe:	a1 44 51 80 00       	mov    0x805144,%eax
  802ac3:	48                   	dec    %eax
  802ac4:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802ac9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acc:	e9 4d 01 00 00       	jmp    802c1e <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802ad1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad4:	8b 40 0c             	mov    0xc(%eax),%eax
  802ad7:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ada:	76 24                	jbe    802b00 <alloc_block_BF+0xf1>
  802adc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802adf:	8b 40 0c             	mov    0xc(%eax),%eax
  802ae2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802ae5:	73 19                	jae    802b00 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802ae7:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802aee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af1:	8b 40 0c             	mov    0xc(%eax),%eax
  802af4:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802af7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afa:	8b 40 08             	mov    0x8(%eax),%eax
  802afd:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802b00:	a1 40 51 80 00       	mov    0x805140,%eax
  802b05:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b08:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b0c:	74 07                	je     802b15 <alloc_block_BF+0x106>
  802b0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b11:	8b 00                	mov    (%eax),%eax
  802b13:	eb 05                	jmp    802b1a <alloc_block_BF+0x10b>
  802b15:	b8 00 00 00 00       	mov    $0x0,%eax
  802b1a:	a3 40 51 80 00       	mov    %eax,0x805140
  802b1f:	a1 40 51 80 00       	mov    0x805140,%eax
  802b24:	85 c0                	test   %eax,%eax
  802b26:	0f 85 fd fe ff ff    	jne    802a29 <alloc_block_BF+0x1a>
  802b2c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b30:	0f 85 f3 fe ff ff    	jne    802a29 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802b36:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802b3a:	0f 84 d9 00 00 00    	je     802c19 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b40:	a1 48 51 80 00       	mov    0x805148,%eax
  802b45:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802b48:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b4b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b4e:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802b51:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b54:	8b 55 08             	mov    0x8(%ebp),%edx
  802b57:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802b5a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802b5e:	75 17                	jne    802b77 <alloc_block_BF+0x168>
  802b60:	83 ec 04             	sub    $0x4,%esp
  802b63:	68 a0 45 80 00       	push   $0x8045a0
  802b68:	68 c7 00 00 00       	push   $0xc7
  802b6d:	68 f7 44 80 00       	push   $0x8044f7
  802b72:	e8 a7 db ff ff       	call   80071e <_panic>
  802b77:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b7a:	8b 00                	mov    (%eax),%eax
  802b7c:	85 c0                	test   %eax,%eax
  802b7e:	74 10                	je     802b90 <alloc_block_BF+0x181>
  802b80:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b83:	8b 00                	mov    (%eax),%eax
  802b85:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802b88:	8b 52 04             	mov    0x4(%edx),%edx
  802b8b:	89 50 04             	mov    %edx,0x4(%eax)
  802b8e:	eb 0b                	jmp    802b9b <alloc_block_BF+0x18c>
  802b90:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b93:	8b 40 04             	mov    0x4(%eax),%eax
  802b96:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b9b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b9e:	8b 40 04             	mov    0x4(%eax),%eax
  802ba1:	85 c0                	test   %eax,%eax
  802ba3:	74 0f                	je     802bb4 <alloc_block_BF+0x1a5>
  802ba5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ba8:	8b 40 04             	mov    0x4(%eax),%eax
  802bab:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802bae:	8b 12                	mov    (%edx),%edx
  802bb0:	89 10                	mov    %edx,(%eax)
  802bb2:	eb 0a                	jmp    802bbe <alloc_block_BF+0x1af>
  802bb4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bb7:	8b 00                	mov    (%eax),%eax
  802bb9:	a3 48 51 80 00       	mov    %eax,0x805148
  802bbe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bc1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bc7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bca:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bd1:	a1 54 51 80 00       	mov    0x805154,%eax
  802bd6:	48                   	dec    %eax
  802bd7:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802bdc:	83 ec 08             	sub    $0x8,%esp
  802bdf:	ff 75 ec             	pushl  -0x14(%ebp)
  802be2:	68 38 51 80 00       	push   $0x805138
  802be7:	e8 71 f9 ff ff       	call   80255d <find_block>
  802bec:	83 c4 10             	add    $0x10,%esp
  802bef:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802bf2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bf5:	8b 50 08             	mov    0x8(%eax),%edx
  802bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  802bfb:	01 c2                	add    %eax,%edx
  802bfd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c00:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802c03:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c06:	8b 40 0c             	mov    0xc(%eax),%eax
  802c09:	2b 45 08             	sub    0x8(%ebp),%eax
  802c0c:	89 c2                	mov    %eax,%edx
  802c0e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c11:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802c14:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c17:	eb 05                	jmp    802c1e <alloc_block_BF+0x20f>
	}
	return NULL;
  802c19:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c1e:	c9                   	leave  
  802c1f:	c3                   	ret    

00802c20 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802c20:	55                   	push   %ebp
  802c21:	89 e5                	mov    %esp,%ebp
  802c23:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802c26:	a1 28 50 80 00       	mov    0x805028,%eax
  802c2b:	85 c0                	test   %eax,%eax
  802c2d:	0f 85 de 01 00 00    	jne    802e11 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802c33:	a1 38 51 80 00       	mov    0x805138,%eax
  802c38:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c3b:	e9 9e 01 00 00       	jmp    802dde <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802c40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c43:	8b 40 0c             	mov    0xc(%eax),%eax
  802c46:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c49:	0f 82 87 01 00 00    	jb     802dd6 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802c4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c52:	8b 40 0c             	mov    0xc(%eax),%eax
  802c55:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c58:	0f 85 95 00 00 00    	jne    802cf3 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802c5e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c62:	75 17                	jne    802c7b <alloc_block_NF+0x5b>
  802c64:	83 ec 04             	sub    $0x4,%esp
  802c67:	68 a0 45 80 00       	push   $0x8045a0
  802c6c:	68 e0 00 00 00       	push   $0xe0
  802c71:	68 f7 44 80 00       	push   $0x8044f7
  802c76:	e8 a3 da ff ff       	call   80071e <_panic>
  802c7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7e:	8b 00                	mov    (%eax),%eax
  802c80:	85 c0                	test   %eax,%eax
  802c82:	74 10                	je     802c94 <alloc_block_NF+0x74>
  802c84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c87:	8b 00                	mov    (%eax),%eax
  802c89:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c8c:	8b 52 04             	mov    0x4(%edx),%edx
  802c8f:	89 50 04             	mov    %edx,0x4(%eax)
  802c92:	eb 0b                	jmp    802c9f <alloc_block_NF+0x7f>
  802c94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c97:	8b 40 04             	mov    0x4(%eax),%eax
  802c9a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca2:	8b 40 04             	mov    0x4(%eax),%eax
  802ca5:	85 c0                	test   %eax,%eax
  802ca7:	74 0f                	je     802cb8 <alloc_block_NF+0x98>
  802ca9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cac:	8b 40 04             	mov    0x4(%eax),%eax
  802caf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cb2:	8b 12                	mov    (%edx),%edx
  802cb4:	89 10                	mov    %edx,(%eax)
  802cb6:	eb 0a                	jmp    802cc2 <alloc_block_NF+0xa2>
  802cb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbb:	8b 00                	mov    (%eax),%eax
  802cbd:	a3 38 51 80 00       	mov    %eax,0x805138
  802cc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ccb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cce:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cd5:	a1 44 51 80 00       	mov    0x805144,%eax
  802cda:	48                   	dec    %eax
  802cdb:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802ce0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce3:	8b 40 08             	mov    0x8(%eax),%eax
  802ce6:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802ceb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cee:	e9 f8 04 00 00       	jmp    8031eb <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802cf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf6:	8b 40 0c             	mov    0xc(%eax),%eax
  802cf9:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cfc:	0f 86 d4 00 00 00    	jbe    802dd6 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802d02:	a1 48 51 80 00       	mov    0x805148,%eax
  802d07:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802d0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0d:	8b 50 08             	mov    0x8(%eax),%edx
  802d10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d13:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802d16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d19:	8b 55 08             	mov    0x8(%ebp),%edx
  802d1c:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802d1f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d23:	75 17                	jne    802d3c <alloc_block_NF+0x11c>
  802d25:	83 ec 04             	sub    $0x4,%esp
  802d28:	68 a0 45 80 00       	push   $0x8045a0
  802d2d:	68 e9 00 00 00       	push   $0xe9
  802d32:	68 f7 44 80 00       	push   $0x8044f7
  802d37:	e8 e2 d9 ff ff       	call   80071e <_panic>
  802d3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d3f:	8b 00                	mov    (%eax),%eax
  802d41:	85 c0                	test   %eax,%eax
  802d43:	74 10                	je     802d55 <alloc_block_NF+0x135>
  802d45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d48:	8b 00                	mov    (%eax),%eax
  802d4a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d4d:	8b 52 04             	mov    0x4(%edx),%edx
  802d50:	89 50 04             	mov    %edx,0x4(%eax)
  802d53:	eb 0b                	jmp    802d60 <alloc_block_NF+0x140>
  802d55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d58:	8b 40 04             	mov    0x4(%eax),%eax
  802d5b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d63:	8b 40 04             	mov    0x4(%eax),%eax
  802d66:	85 c0                	test   %eax,%eax
  802d68:	74 0f                	je     802d79 <alloc_block_NF+0x159>
  802d6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d6d:	8b 40 04             	mov    0x4(%eax),%eax
  802d70:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d73:	8b 12                	mov    (%edx),%edx
  802d75:	89 10                	mov    %edx,(%eax)
  802d77:	eb 0a                	jmp    802d83 <alloc_block_NF+0x163>
  802d79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d7c:	8b 00                	mov    (%eax),%eax
  802d7e:	a3 48 51 80 00       	mov    %eax,0x805148
  802d83:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d86:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d8f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d96:	a1 54 51 80 00       	mov    0x805154,%eax
  802d9b:	48                   	dec    %eax
  802d9c:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802da1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802da4:	8b 40 08             	mov    0x8(%eax),%eax
  802da7:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802dac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802daf:	8b 50 08             	mov    0x8(%eax),%edx
  802db2:	8b 45 08             	mov    0x8(%ebp),%eax
  802db5:	01 c2                	add    %eax,%edx
  802db7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dba:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802dbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc0:	8b 40 0c             	mov    0xc(%eax),%eax
  802dc3:	2b 45 08             	sub    0x8(%ebp),%eax
  802dc6:	89 c2                	mov    %eax,%edx
  802dc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dcb:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802dce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dd1:	e9 15 04 00 00       	jmp    8031eb <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802dd6:	a1 40 51 80 00       	mov    0x805140,%eax
  802ddb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802dde:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802de2:	74 07                	je     802deb <alloc_block_NF+0x1cb>
  802de4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de7:	8b 00                	mov    (%eax),%eax
  802de9:	eb 05                	jmp    802df0 <alloc_block_NF+0x1d0>
  802deb:	b8 00 00 00 00       	mov    $0x0,%eax
  802df0:	a3 40 51 80 00       	mov    %eax,0x805140
  802df5:	a1 40 51 80 00       	mov    0x805140,%eax
  802dfa:	85 c0                	test   %eax,%eax
  802dfc:	0f 85 3e fe ff ff    	jne    802c40 <alloc_block_NF+0x20>
  802e02:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e06:	0f 85 34 fe ff ff    	jne    802c40 <alloc_block_NF+0x20>
  802e0c:	e9 d5 03 00 00       	jmp    8031e6 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802e11:	a1 38 51 80 00       	mov    0x805138,%eax
  802e16:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e19:	e9 b1 01 00 00       	jmp    802fcf <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802e1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e21:	8b 50 08             	mov    0x8(%eax),%edx
  802e24:	a1 28 50 80 00       	mov    0x805028,%eax
  802e29:	39 c2                	cmp    %eax,%edx
  802e2b:	0f 82 96 01 00 00    	jb     802fc7 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802e31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e34:	8b 40 0c             	mov    0xc(%eax),%eax
  802e37:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e3a:	0f 82 87 01 00 00    	jb     802fc7 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802e40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e43:	8b 40 0c             	mov    0xc(%eax),%eax
  802e46:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e49:	0f 85 95 00 00 00    	jne    802ee4 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802e4f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e53:	75 17                	jne    802e6c <alloc_block_NF+0x24c>
  802e55:	83 ec 04             	sub    $0x4,%esp
  802e58:	68 a0 45 80 00       	push   $0x8045a0
  802e5d:	68 fc 00 00 00       	push   $0xfc
  802e62:	68 f7 44 80 00       	push   $0x8044f7
  802e67:	e8 b2 d8 ff ff       	call   80071e <_panic>
  802e6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6f:	8b 00                	mov    (%eax),%eax
  802e71:	85 c0                	test   %eax,%eax
  802e73:	74 10                	je     802e85 <alloc_block_NF+0x265>
  802e75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e78:	8b 00                	mov    (%eax),%eax
  802e7a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e7d:	8b 52 04             	mov    0x4(%edx),%edx
  802e80:	89 50 04             	mov    %edx,0x4(%eax)
  802e83:	eb 0b                	jmp    802e90 <alloc_block_NF+0x270>
  802e85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e88:	8b 40 04             	mov    0x4(%eax),%eax
  802e8b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e93:	8b 40 04             	mov    0x4(%eax),%eax
  802e96:	85 c0                	test   %eax,%eax
  802e98:	74 0f                	je     802ea9 <alloc_block_NF+0x289>
  802e9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9d:	8b 40 04             	mov    0x4(%eax),%eax
  802ea0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ea3:	8b 12                	mov    (%edx),%edx
  802ea5:	89 10                	mov    %edx,(%eax)
  802ea7:	eb 0a                	jmp    802eb3 <alloc_block_NF+0x293>
  802ea9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eac:	8b 00                	mov    (%eax),%eax
  802eae:	a3 38 51 80 00       	mov    %eax,0x805138
  802eb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ebc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ec6:	a1 44 51 80 00       	mov    0x805144,%eax
  802ecb:	48                   	dec    %eax
  802ecc:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802ed1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed4:	8b 40 08             	mov    0x8(%eax),%eax
  802ed7:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802edc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802edf:	e9 07 03 00 00       	jmp    8031eb <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802ee4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee7:	8b 40 0c             	mov    0xc(%eax),%eax
  802eea:	3b 45 08             	cmp    0x8(%ebp),%eax
  802eed:	0f 86 d4 00 00 00    	jbe    802fc7 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802ef3:	a1 48 51 80 00       	mov    0x805148,%eax
  802ef8:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802efb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802efe:	8b 50 08             	mov    0x8(%eax),%edx
  802f01:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f04:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802f07:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f0a:	8b 55 08             	mov    0x8(%ebp),%edx
  802f0d:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802f10:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f14:	75 17                	jne    802f2d <alloc_block_NF+0x30d>
  802f16:	83 ec 04             	sub    $0x4,%esp
  802f19:	68 a0 45 80 00       	push   $0x8045a0
  802f1e:	68 04 01 00 00       	push   $0x104
  802f23:	68 f7 44 80 00       	push   $0x8044f7
  802f28:	e8 f1 d7 ff ff       	call   80071e <_panic>
  802f2d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f30:	8b 00                	mov    (%eax),%eax
  802f32:	85 c0                	test   %eax,%eax
  802f34:	74 10                	je     802f46 <alloc_block_NF+0x326>
  802f36:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f39:	8b 00                	mov    (%eax),%eax
  802f3b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f3e:	8b 52 04             	mov    0x4(%edx),%edx
  802f41:	89 50 04             	mov    %edx,0x4(%eax)
  802f44:	eb 0b                	jmp    802f51 <alloc_block_NF+0x331>
  802f46:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f49:	8b 40 04             	mov    0x4(%eax),%eax
  802f4c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f51:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f54:	8b 40 04             	mov    0x4(%eax),%eax
  802f57:	85 c0                	test   %eax,%eax
  802f59:	74 0f                	je     802f6a <alloc_block_NF+0x34a>
  802f5b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f5e:	8b 40 04             	mov    0x4(%eax),%eax
  802f61:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f64:	8b 12                	mov    (%edx),%edx
  802f66:	89 10                	mov    %edx,(%eax)
  802f68:	eb 0a                	jmp    802f74 <alloc_block_NF+0x354>
  802f6a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f6d:	8b 00                	mov    (%eax),%eax
  802f6f:	a3 48 51 80 00       	mov    %eax,0x805148
  802f74:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f77:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f7d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f80:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f87:	a1 54 51 80 00       	mov    0x805154,%eax
  802f8c:	48                   	dec    %eax
  802f8d:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802f92:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f95:	8b 40 08             	mov    0x8(%eax),%eax
  802f98:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802f9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa0:	8b 50 08             	mov    0x8(%eax),%edx
  802fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa6:	01 c2                	add    %eax,%edx
  802fa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fab:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802fae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb1:	8b 40 0c             	mov    0xc(%eax),%eax
  802fb4:	2b 45 08             	sub    0x8(%ebp),%eax
  802fb7:	89 c2                	mov    %eax,%edx
  802fb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fbc:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802fbf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fc2:	e9 24 02 00 00       	jmp    8031eb <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802fc7:	a1 40 51 80 00       	mov    0x805140,%eax
  802fcc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fcf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fd3:	74 07                	je     802fdc <alloc_block_NF+0x3bc>
  802fd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd8:	8b 00                	mov    (%eax),%eax
  802fda:	eb 05                	jmp    802fe1 <alloc_block_NF+0x3c1>
  802fdc:	b8 00 00 00 00       	mov    $0x0,%eax
  802fe1:	a3 40 51 80 00       	mov    %eax,0x805140
  802fe6:	a1 40 51 80 00       	mov    0x805140,%eax
  802feb:	85 c0                	test   %eax,%eax
  802fed:	0f 85 2b fe ff ff    	jne    802e1e <alloc_block_NF+0x1fe>
  802ff3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ff7:	0f 85 21 fe ff ff    	jne    802e1e <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802ffd:	a1 38 51 80 00       	mov    0x805138,%eax
  803002:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803005:	e9 ae 01 00 00       	jmp    8031b8 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  80300a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80300d:	8b 50 08             	mov    0x8(%eax),%edx
  803010:	a1 28 50 80 00       	mov    0x805028,%eax
  803015:	39 c2                	cmp    %eax,%edx
  803017:	0f 83 93 01 00 00    	jae    8031b0 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  80301d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803020:	8b 40 0c             	mov    0xc(%eax),%eax
  803023:	3b 45 08             	cmp    0x8(%ebp),%eax
  803026:	0f 82 84 01 00 00    	jb     8031b0 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  80302c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80302f:	8b 40 0c             	mov    0xc(%eax),%eax
  803032:	3b 45 08             	cmp    0x8(%ebp),%eax
  803035:	0f 85 95 00 00 00    	jne    8030d0 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  80303b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80303f:	75 17                	jne    803058 <alloc_block_NF+0x438>
  803041:	83 ec 04             	sub    $0x4,%esp
  803044:	68 a0 45 80 00       	push   $0x8045a0
  803049:	68 14 01 00 00       	push   $0x114
  80304e:	68 f7 44 80 00       	push   $0x8044f7
  803053:	e8 c6 d6 ff ff       	call   80071e <_panic>
  803058:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305b:	8b 00                	mov    (%eax),%eax
  80305d:	85 c0                	test   %eax,%eax
  80305f:	74 10                	je     803071 <alloc_block_NF+0x451>
  803061:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803064:	8b 00                	mov    (%eax),%eax
  803066:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803069:	8b 52 04             	mov    0x4(%edx),%edx
  80306c:	89 50 04             	mov    %edx,0x4(%eax)
  80306f:	eb 0b                	jmp    80307c <alloc_block_NF+0x45c>
  803071:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803074:	8b 40 04             	mov    0x4(%eax),%eax
  803077:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80307c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80307f:	8b 40 04             	mov    0x4(%eax),%eax
  803082:	85 c0                	test   %eax,%eax
  803084:	74 0f                	je     803095 <alloc_block_NF+0x475>
  803086:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803089:	8b 40 04             	mov    0x4(%eax),%eax
  80308c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80308f:	8b 12                	mov    (%edx),%edx
  803091:	89 10                	mov    %edx,(%eax)
  803093:	eb 0a                	jmp    80309f <alloc_block_NF+0x47f>
  803095:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803098:	8b 00                	mov    (%eax),%eax
  80309a:	a3 38 51 80 00       	mov    %eax,0x805138
  80309f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030b2:	a1 44 51 80 00       	mov    0x805144,%eax
  8030b7:	48                   	dec    %eax
  8030b8:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8030bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c0:	8b 40 08             	mov    0x8(%eax),%eax
  8030c3:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  8030c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030cb:	e9 1b 01 00 00       	jmp    8031eb <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8030d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d3:	8b 40 0c             	mov    0xc(%eax),%eax
  8030d6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030d9:	0f 86 d1 00 00 00    	jbe    8031b0 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8030df:	a1 48 51 80 00       	mov    0x805148,%eax
  8030e4:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  8030e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ea:	8b 50 08             	mov    0x8(%eax),%edx
  8030ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030f0:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8030f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8030f9:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8030fc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803100:	75 17                	jne    803119 <alloc_block_NF+0x4f9>
  803102:	83 ec 04             	sub    $0x4,%esp
  803105:	68 a0 45 80 00       	push   $0x8045a0
  80310a:	68 1c 01 00 00       	push   $0x11c
  80310f:	68 f7 44 80 00       	push   $0x8044f7
  803114:	e8 05 d6 ff ff       	call   80071e <_panic>
  803119:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80311c:	8b 00                	mov    (%eax),%eax
  80311e:	85 c0                	test   %eax,%eax
  803120:	74 10                	je     803132 <alloc_block_NF+0x512>
  803122:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803125:	8b 00                	mov    (%eax),%eax
  803127:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80312a:	8b 52 04             	mov    0x4(%edx),%edx
  80312d:	89 50 04             	mov    %edx,0x4(%eax)
  803130:	eb 0b                	jmp    80313d <alloc_block_NF+0x51d>
  803132:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803135:	8b 40 04             	mov    0x4(%eax),%eax
  803138:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80313d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803140:	8b 40 04             	mov    0x4(%eax),%eax
  803143:	85 c0                	test   %eax,%eax
  803145:	74 0f                	je     803156 <alloc_block_NF+0x536>
  803147:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80314a:	8b 40 04             	mov    0x4(%eax),%eax
  80314d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803150:	8b 12                	mov    (%edx),%edx
  803152:	89 10                	mov    %edx,(%eax)
  803154:	eb 0a                	jmp    803160 <alloc_block_NF+0x540>
  803156:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803159:	8b 00                	mov    (%eax),%eax
  80315b:	a3 48 51 80 00       	mov    %eax,0x805148
  803160:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803163:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803169:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80316c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803173:	a1 54 51 80 00       	mov    0x805154,%eax
  803178:	48                   	dec    %eax
  803179:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  80317e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803181:	8b 40 08             	mov    0x8(%eax),%eax
  803184:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  803189:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80318c:	8b 50 08             	mov    0x8(%eax),%edx
  80318f:	8b 45 08             	mov    0x8(%ebp),%eax
  803192:	01 c2                	add    %eax,%edx
  803194:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803197:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  80319a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80319d:	8b 40 0c             	mov    0xc(%eax),%eax
  8031a0:	2b 45 08             	sub    0x8(%ebp),%eax
  8031a3:	89 c2                	mov    %eax,%edx
  8031a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a8:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8031ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031ae:	eb 3b                	jmp    8031eb <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8031b0:	a1 40 51 80 00       	mov    0x805140,%eax
  8031b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031bc:	74 07                	je     8031c5 <alloc_block_NF+0x5a5>
  8031be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c1:	8b 00                	mov    (%eax),%eax
  8031c3:	eb 05                	jmp    8031ca <alloc_block_NF+0x5aa>
  8031c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8031ca:	a3 40 51 80 00       	mov    %eax,0x805140
  8031cf:	a1 40 51 80 00       	mov    0x805140,%eax
  8031d4:	85 c0                	test   %eax,%eax
  8031d6:	0f 85 2e fe ff ff    	jne    80300a <alloc_block_NF+0x3ea>
  8031dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031e0:	0f 85 24 fe ff ff    	jne    80300a <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  8031e6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8031eb:	c9                   	leave  
  8031ec:	c3                   	ret    

008031ed <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8031ed:	55                   	push   %ebp
  8031ee:	89 e5                	mov    %esp,%ebp
  8031f0:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  8031f3:	a1 38 51 80 00       	mov    0x805138,%eax
  8031f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  8031fb:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803200:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  803203:	a1 38 51 80 00       	mov    0x805138,%eax
  803208:	85 c0                	test   %eax,%eax
  80320a:	74 14                	je     803220 <insert_sorted_with_merge_freeList+0x33>
  80320c:	8b 45 08             	mov    0x8(%ebp),%eax
  80320f:	8b 50 08             	mov    0x8(%eax),%edx
  803212:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803215:	8b 40 08             	mov    0x8(%eax),%eax
  803218:	39 c2                	cmp    %eax,%edx
  80321a:	0f 87 9b 01 00 00    	ja     8033bb <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  803220:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803224:	75 17                	jne    80323d <insert_sorted_with_merge_freeList+0x50>
  803226:	83 ec 04             	sub    $0x4,%esp
  803229:	68 d4 44 80 00       	push   $0x8044d4
  80322e:	68 38 01 00 00       	push   $0x138
  803233:	68 f7 44 80 00       	push   $0x8044f7
  803238:	e8 e1 d4 ff ff       	call   80071e <_panic>
  80323d:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803243:	8b 45 08             	mov    0x8(%ebp),%eax
  803246:	89 10                	mov    %edx,(%eax)
  803248:	8b 45 08             	mov    0x8(%ebp),%eax
  80324b:	8b 00                	mov    (%eax),%eax
  80324d:	85 c0                	test   %eax,%eax
  80324f:	74 0d                	je     80325e <insert_sorted_with_merge_freeList+0x71>
  803251:	a1 38 51 80 00       	mov    0x805138,%eax
  803256:	8b 55 08             	mov    0x8(%ebp),%edx
  803259:	89 50 04             	mov    %edx,0x4(%eax)
  80325c:	eb 08                	jmp    803266 <insert_sorted_with_merge_freeList+0x79>
  80325e:	8b 45 08             	mov    0x8(%ebp),%eax
  803261:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803266:	8b 45 08             	mov    0x8(%ebp),%eax
  803269:	a3 38 51 80 00       	mov    %eax,0x805138
  80326e:	8b 45 08             	mov    0x8(%ebp),%eax
  803271:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803278:	a1 44 51 80 00       	mov    0x805144,%eax
  80327d:	40                   	inc    %eax
  80327e:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803283:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803287:	0f 84 a8 06 00 00    	je     803935 <insert_sorted_with_merge_freeList+0x748>
  80328d:	8b 45 08             	mov    0x8(%ebp),%eax
  803290:	8b 50 08             	mov    0x8(%eax),%edx
  803293:	8b 45 08             	mov    0x8(%ebp),%eax
  803296:	8b 40 0c             	mov    0xc(%eax),%eax
  803299:	01 c2                	add    %eax,%edx
  80329b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80329e:	8b 40 08             	mov    0x8(%eax),%eax
  8032a1:	39 c2                	cmp    %eax,%edx
  8032a3:	0f 85 8c 06 00 00    	jne    803935 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  8032a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ac:	8b 50 0c             	mov    0xc(%eax),%edx
  8032af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032b2:	8b 40 0c             	mov    0xc(%eax),%eax
  8032b5:	01 c2                	add    %eax,%edx
  8032b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ba:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  8032bd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8032c1:	75 17                	jne    8032da <insert_sorted_with_merge_freeList+0xed>
  8032c3:	83 ec 04             	sub    $0x4,%esp
  8032c6:	68 a0 45 80 00       	push   $0x8045a0
  8032cb:	68 3c 01 00 00       	push   $0x13c
  8032d0:	68 f7 44 80 00       	push   $0x8044f7
  8032d5:	e8 44 d4 ff ff       	call   80071e <_panic>
  8032da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032dd:	8b 00                	mov    (%eax),%eax
  8032df:	85 c0                	test   %eax,%eax
  8032e1:	74 10                	je     8032f3 <insert_sorted_with_merge_freeList+0x106>
  8032e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032e6:	8b 00                	mov    (%eax),%eax
  8032e8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032eb:	8b 52 04             	mov    0x4(%edx),%edx
  8032ee:	89 50 04             	mov    %edx,0x4(%eax)
  8032f1:	eb 0b                	jmp    8032fe <insert_sorted_with_merge_freeList+0x111>
  8032f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032f6:	8b 40 04             	mov    0x4(%eax),%eax
  8032f9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803301:	8b 40 04             	mov    0x4(%eax),%eax
  803304:	85 c0                	test   %eax,%eax
  803306:	74 0f                	je     803317 <insert_sorted_with_merge_freeList+0x12a>
  803308:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80330b:	8b 40 04             	mov    0x4(%eax),%eax
  80330e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803311:	8b 12                	mov    (%edx),%edx
  803313:	89 10                	mov    %edx,(%eax)
  803315:	eb 0a                	jmp    803321 <insert_sorted_with_merge_freeList+0x134>
  803317:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80331a:	8b 00                	mov    (%eax),%eax
  80331c:	a3 38 51 80 00       	mov    %eax,0x805138
  803321:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803324:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80332a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80332d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803334:	a1 44 51 80 00       	mov    0x805144,%eax
  803339:	48                   	dec    %eax
  80333a:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  80333f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803342:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  803349:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80334c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  803353:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803357:	75 17                	jne    803370 <insert_sorted_with_merge_freeList+0x183>
  803359:	83 ec 04             	sub    $0x4,%esp
  80335c:	68 d4 44 80 00       	push   $0x8044d4
  803361:	68 3f 01 00 00       	push   $0x13f
  803366:	68 f7 44 80 00       	push   $0x8044f7
  80336b:	e8 ae d3 ff ff       	call   80071e <_panic>
  803370:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803376:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803379:	89 10                	mov    %edx,(%eax)
  80337b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80337e:	8b 00                	mov    (%eax),%eax
  803380:	85 c0                	test   %eax,%eax
  803382:	74 0d                	je     803391 <insert_sorted_with_merge_freeList+0x1a4>
  803384:	a1 48 51 80 00       	mov    0x805148,%eax
  803389:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80338c:	89 50 04             	mov    %edx,0x4(%eax)
  80338f:	eb 08                	jmp    803399 <insert_sorted_with_merge_freeList+0x1ac>
  803391:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803394:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803399:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80339c:	a3 48 51 80 00       	mov    %eax,0x805148
  8033a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033a4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033ab:	a1 54 51 80 00       	mov    0x805154,%eax
  8033b0:	40                   	inc    %eax
  8033b1:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8033b6:	e9 7a 05 00 00       	jmp    803935 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  8033bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8033be:	8b 50 08             	mov    0x8(%eax),%edx
  8033c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033c4:	8b 40 08             	mov    0x8(%eax),%eax
  8033c7:	39 c2                	cmp    %eax,%edx
  8033c9:	0f 82 14 01 00 00    	jb     8034e3 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  8033cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033d2:	8b 50 08             	mov    0x8(%eax),%edx
  8033d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033d8:	8b 40 0c             	mov    0xc(%eax),%eax
  8033db:	01 c2                	add    %eax,%edx
  8033dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e0:	8b 40 08             	mov    0x8(%eax),%eax
  8033e3:	39 c2                	cmp    %eax,%edx
  8033e5:	0f 85 90 00 00 00    	jne    80347b <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  8033eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033ee:	8b 50 0c             	mov    0xc(%eax),%edx
  8033f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f4:	8b 40 0c             	mov    0xc(%eax),%eax
  8033f7:	01 c2                	add    %eax,%edx
  8033f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033fc:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  8033ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803402:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  803409:	8b 45 08             	mov    0x8(%ebp),%eax
  80340c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803413:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803417:	75 17                	jne    803430 <insert_sorted_with_merge_freeList+0x243>
  803419:	83 ec 04             	sub    $0x4,%esp
  80341c:	68 d4 44 80 00       	push   $0x8044d4
  803421:	68 49 01 00 00       	push   $0x149
  803426:	68 f7 44 80 00       	push   $0x8044f7
  80342b:	e8 ee d2 ff ff       	call   80071e <_panic>
  803430:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803436:	8b 45 08             	mov    0x8(%ebp),%eax
  803439:	89 10                	mov    %edx,(%eax)
  80343b:	8b 45 08             	mov    0x8(%ebp),%eax
  80343e:	8b 00                	mov    (%eax),%eax
  803440:	85 c0                	test   %eax,%eax
  803442:	74 0d                	je     803451 <insert_sorted_with_merge_freeList+0x264>
  803444:	a1 48 51 80 00       	mov    0x805148,%eax
  803449:	8b 55 08             	mov    0x8(%ebp),%edx
  80344c:	89 50 04             	mov    %edx,0x4(%eax)
  80344f:	eb 08                	jmp    803459 <insert_sorted_with_merge_freeList+0x26c>
  803451:	8b 45 08             	mov    0x8(%ebp),%eax
  803454:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803459:	8b 45 08             	mov    0x8(%ebp),%eax
  80345c:	a3 48 51 80 00       	mov    %eax,0x805148
  803461:	8b 45 08             	mov    0x8(%ebp),%eax
  803464:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80346b:	a1 54 51 80 00       	mov    0x805154,%eax
  803470:	40                   	inc    %eax
  803471:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803476:	e9 bb 04 00 00       	jmp    803936 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  80347b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80347f:	75 17                	jne    803498 <insert_sorted_with_merge_freeList+0x2ab>
  803481:	83 ec 04             	sub    $0x4,%esp
  803484:	68 48 45 80 00       	push   $0x804548
  803489:	68 4c 01 00 00       	push   $0x14c
  80348e:	68 f7 44 80 00       	push   $0x8044f7
  803493:	e8 86 d2 ff ff       	call   80071e <_panic>
  803498:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  80349e:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a1:	89 50 04             	mov    %edx,0x4(%eax)
  8034a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a7:	8b 40 04             	mov    0x4(%eax),%eax
  8034aa:	85 c0                	test   %eax,%eax
  8034ac:	74 0c                	je     8034ba <insert_sorted_with_merge_freeList+0x2cd>
  8034ae:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8034b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8034b6:	89 10                	mov    %edx,(%eax)
  8034b8:	eb 08                	jmp    8034c2 <insert_sorted_with_merge_freeList+0x2d5>
  8034ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8034bd:	a3 38 51 80 00       	mov    %eax,0x805138
  8034c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8034ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8034cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034d3:	a1 44 51 80 00       	mov    0x805144,%eax
  8034d8:	40                   	inc    %eax
  8034d9:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8034de:	e9 53 04 00 00       	jmp    803936 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8034e3:	a1 38 51 80 00       	mov    0x805138,%eax
  8034e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8034eb:	e9 15 04 00 00       	jmp    803905 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  8034f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034f3:	8b 00                	mov    (%eax),%eax
  8034f5:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  8034f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8034fb:	8b 50 08             	mov    0x8(%eax),%edx
  8034fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803501:	8b 40 08             	mov    0x8(%eax),%eax
  803504:	39 c2                	cmp    %eax,%edx
  803506:	0f 86 f1 03 00 00    	jbe    8038fd <insert_sorted_with_merge_freeList+0x710>
  80350c:	8b 45 08             	mov    0x8(%ebp),%eax
  80350f:	8b 50 08             	mov    0x8(%eax),%edx
  803512:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803515:	8b 40 08             	mov    0x8(%eax),%eax
  803518:	39 c2                	cmp    %eax,%edx
  80351a:	0f 83 dd 03 00 00    	jae    8038fd <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803520:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803523:	8b 50 08             	mov    0x8(%eax),%edx
  803526:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803529:	8b 40 0c             	mov    0xc(%eax),%eax
  80352c:	01 c2                	add    %eax,%edx
  80352e:	8b 45 08             	mov    0x8(%ebp),%eax
  803531:	8b 40 08             	mov    0x8(%eax),%eax
  803534:	39 c2                	cmp    %eax,%edx
  803536:	0f 85 b9 01 00 00    	jne    8036f5 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80353c:	8b 45 08             	mov    0x8(%ebp),%eax
  80353f:	8b 50 08             	mov    0x8(%eax),%edx
  803542:	8b 45 08             	mov    0x8(%ebp),%eax
  803545:	8b 40 0c             	mov    0xc(%eax),%eax
  803548:	01 c2                	add    %eax,%edx
  80354a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80354d:	8b 40 08             	mov    0x8(%eax),%eax
  803550:	39 c2                	cmp    %eax,%edx
  803552:	0f 85 0d 01 00 00    	jne    803665 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803558:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80355b:	8b 50 0c             	mov    0xc(%eax),%edx
  80355e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803561:	8b 40 0c             	mov    0xc(%eax),%eax
  803564:	01 c2                	add    %eax,%edx
  803566:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803569:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80356c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803570:	75 17                	jne    803589 <insert_sorted_with_merge_freeList+0x39c>
  803572:	83 ec 04             	sub    $0x4,%esp
  803575:	68 a0 45 80 00       	push   $0x8045a0
  80357a:	68 5c 01 00 00       	push   $0x15c
  80357f:	68 f7 44 80 00       	push   $0x8044f7
  803584:	e8 95 d1 ff ff       	call   80071e <_panic>
  803589:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80358c:	8b 00                	mov    (%eax),%eax
  80358e:	85 c0                	test   %eax,%eax
  803590:	74 10                	je     8035a2 <insert_sorted_with_merge_freeList+0x3b5>
  803592:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803595:	8b 00                	mov    (%eax),%eax
  803597:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80359a:	8b 52 04             	mov    0x4(%edx),%edx
  80359d:	89 50 04             	mov    %edx,0x4(%eax)
  8035a0:	eb 0b                	jmp    8035ad <insert_sorted_with_merge_freeList+0x3c0>
  8035a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035a5:	8b 40 04             	mov    0x4(%eax),%eax
  8035a8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8035ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035b0:	8b 40 04             	mov    0x4(%eax),%eax
  8035b3:	85 c0                	test   %eax,%eax
  8035b5:	74 0f                	je     8035c6 <insert_sorted_with_merge_freeList+0x3d9>
  8035b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035ba:	8b 40 04             	mov    0x4(%eax),%eax
  8035bd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8035c0:	8b 12                	mov    (%edx),%edx
  8035c2:	89 10                	mov    %edx,(%eax)
  8035c4:	eb 0a                	jmp    8035d0 <insert_sorted_with_merge_freeList+0x3e3>
  8035c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035c9:	8b 00                	mov    (%eax),%eax
  8035cb:	a3 38 51 80 00       	mov    %eax,0x805138
  8035d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035d3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035dc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035e3:	a1 44 51 80 00       	mov    0x805144,%eax
  8035e8:	48                   	dec    %eax
  8035e9:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  8035ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035f1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8035f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035fb:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803602:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803606:	75 17                	jne    80361f <insert_sorted_with_merge_freeList+0x432>
  803608:	83 ec 04             	sub    $0x4,%esp
  80360b:	68 d4 44 80 00       	push   $0x8044d4
  803610:	68 5f 01 00 00       	push   $0x15f
  803615:	68 f7 44 80 00       	push   $0x8044f7
  80361a:	e8 ff d0 ff ff       	call   80071e <_panic>
  80361f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803625:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803628:	89 10                	mov    %edx,(%eax)
  80362a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80362d:	8b 00                	mov    (%eax),%eax
  80362f:	85 c0                	test   %eax,%eax
  803631:	74 0d                	je     803640 <insert_sorted_with_merge_freeList+0x453>
  803633:	a1 48 51 80 00       	mov    0x805148,%eax
  803638:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80363b:	89 50 04             	mov    %edx,0x4(%eax)
  80363e:	eb 08                	jmp    803648 <insert_sorted_with_merge_freeList+0x45b>
  803640:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803643:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803648:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80364b:	a3 48 51 80 00       	mov    %eax,0x805148
  803650:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803653:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80365a:	a1 54 51 80 00       	mov    0x805154,%eax
  80365f:	40                   	inc    %eax
  803660:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803665:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803668:	8b 50 0c             	mov    0xc(%eax),%edx
  80366b:	8b 45 08             	mov    0x8(%ebp),%eax
  80366e:	8b 40 0c             	mov    0xc(%eax),%eax
  803671:	01 c2                	add    %eax,%edx
  803673:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803676:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803679:	8b 45 08             	mov    0x8(%ebp),%eax
  80367c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803683:	8b 45 08             	mov    0x8(%ebp),%eax
  803686:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80368d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803691:	75 17                	jne    8036aa <insert_sorted_with_merge_freeList+0x4bd>
  803693:	83 ec 04             	sub    $0x4,%esp
  803696:	68 d4 44 80 00       	push   $0x8044d4
  80369b:	68 64 01 00 00       	push   $0x164
  8036a0:	68 f7 44 80 00       	push   $0x8044f7
  8036a5:	e8 74 d0 ff ff       	call   80071e <_panic>
  8036aa:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8036b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b3:	89 10                	mov    %edx,(%eax)
  8036b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b8:	8b 00                	mov    (%eax),%eax
  8036ba:	85 c0                	test   %eax,%eax
  8036bc:	74 0d                	je     8036cb <insert_sorted_with_merge_freeList+0x4de>
  8036be:	a1 48 51 80 00       	mov    0x805148,%eax
  8036c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8036c6:	89 50 04             	mov    %edx,0x4(%eax)
  8036c9:	eb 08                	jmp    8036d3 <insert_sorted_with_merge_freeList+0x4e6>
  8036cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ce:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8036d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d6:	a3 48 51 80 00       	mov    %eax,0x805148
  8036db:	8b 45 08             	mov    0x8(%ebp),%eax
  8036de:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036e5:	a1 54 51 80 00       	mov    0x805154,%eax
  8036ea:	40                   	inc    %eax
  8036eb:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8036f0:	e9 41 02 00 00       	jmp    803936 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8036f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8036f8:	8b 50 08             	mov    0x8(%eax),%edx
  8036fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8036fe:	8b 40 0c             	mov    0xc(%eax),%eax
  803701:	01 c2                	add    %eax,%edx
  803703:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803706:	8b 40 08             	mov    0x8(%eax),%eax
  803709:	39 c2                	cmp    %eax,%edx
  80370b:	0f 85 7c 01 00 00    	jne    80388d <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803711:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803715:	74 06                	je     80371d <insert_sorted_with_merge_freeList+0x530>
  803717:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80371b:	75 17                	jne    803734 <insert_sorted_with_merge_freeList+0x547>
  80371d:	83 ec 04             	sub    $0x4,%esp
  803720:	68 10 45 80 00       	push   $0x804510
  803725:	68 69 01 00 00       	push   $0x169
  80372a:	68 f7 44 80 00       	push   $0x8044f7
  80372f:	e8 ea cf ff ff       	call   80071e <_panic>
  803734:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803737:	8b 50 04             	mov    0x4(%eax),%edx
  80373a:	8b 45 08             	mov    0x8(%ebp),%eax
  80373d:	89 50 04             	mov    %edx,0x4(%eax)
  803740:	8b 45 08             	mov    0x8(%ebp),%eax
  803743:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803746:	89 10                	mov    %edx,(%eax)
  803748:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80374b:	8b 40 04             	mov    0x4(%eax),%eax
  80374e:	85 c0                	test   %eax,%eax
  803750:	74 0d                	je     80375f <insert_sorted_with_merge_freeList+0x572>
  803752:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803755:	8b 40 04             	mov    0x4(%eax),%eax
  803758:	8b 55 08             	mov    0x8(%ebp),%edx
  80375b:	89 10                	mov    %edx,(%eax)
  80375d:	eb 08                	jmp    803767 <insert_sorted_with_merge_freeList+0x57a>
  80375f:	8b 45 08             	mov    0x8(%ebp),%eax
  803762:	a3 38 51 80 00       	mov    %eax,0x805138
  803767:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80376a:	8b 55 08             	mov    0x8(%ebp),%edx
  80376d:	89 50 04             	mov    %edx,0x4(%eax)
  803770:	a1 44 51 80 00       	mov    0x805144,%eax
  803775:	40                   	inc    %eax
  803776:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  80377b:	8b 45 08             	mov    0x8(%ebp),%eax
  80377e:	8b 50 0c             	mov    0xc(%eax),%edx
  803781:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803784:	8b 40 0c             	mov    0xc(%eax),%eax
  803787:	01 c2                	add    %eax,%edx
  803789:	8b 45 08             	mov    0x8(%ebp),%eax
  80378c:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80378f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803793:	75 17                	jne    8037ac <insert_sorted_with_merge_freeList+0x5bf>
  803795:	83 ec 04             	sub    $0x4,%esp
  803798:	68 a0 45 80 00       	push   $0x8045a0
  80379d:	68 6b 01 00 00       	push   $0x16b
  8037a2:	68 f7 44 80 00       	push   $0x8044f7
  8037a7:	e8 72 cf ff ff       	call   80071e <_panic>
  8037ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037af:	8b 00                	mov    (%eax),%eax
  8037b1:	85 c0                	test   %eax,%eax
  8037b3:	74 10                	je     8037c5 <insert_sorted_with_merge_freeList+0x5d8>
  8037b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037b8:	8b 00                	mov    (%eax),%eax
  8037ba:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8037bd:	8b 52 04             	mov    0x4(%edx),%edx
  8037c0:	89 50 04             	mov    %edx,0x4(%eax)
  8037c3:	eb 0b                	jmp    8037d0 <insert_sorted_with_merge_freeList+0x5e3>
  8037c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037c8:	8b 40 04             	mov    0x4(%eax),%eax
  8037cb:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8037d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037d3:	8b 40 04             	mov    0x4(%eax),%eax
  8037d6:	85 c0                	test   %eax,%eax
  8037d8:	74 0f                	je     8037e9 <insert_sorted_with_merge_freeList+0x5fc>
  8037da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037dd:	8b 40 04             	mov    0x4(%eax),%eax
  8037e0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8037e3:	8b 12                	mov    (%edx),%edx
  8037e5:	89 10                	mov    %edx,(%eax)
  8037e7:	eb 0a                	jmp    8037f3 <insert_sorted_with_merge_freeList+0x606>
  8037e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037ec:	8b 00                	mov    (%eax),%eax
  8037ee:	a3 38 51 80 00       	mov    %eax,0x805138
  8037f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037ff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803806:	a1 44 51 80 00       	mov    0x805144,%eax
  80380b:	48                   	dec    %eax
  80380c:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803811:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803814:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  80381b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80381e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803825:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803829:	75 17                	jne    803842 <insert_sorted_with_merge_freeList+0x655>
  80382b:	83 ec 04             	sub    $0x4,%esp
  80382e:	68 d4 44 80 00       	push   $0x8044d4
  803833:	68 6e 01 00 00       	push   $0x16e
  803838:	68 f7 44 80 00       	push   $0x8044f7
  80383d:	e8 dc ce ff ff       	call   80071e <_panic>
  803842:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803848:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80384b:	89 10                	mov    %edx,(%eax)
  80384d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803850:	8b 00                	mov    (%eax),%eax
  803852:	85 c0                	test   %eax,%eax
  803854:	74 0d                	je     803863 <insert_sorted_with_merge_freeList+0x676>
  803856:	a1 48 51 80 00       	mov    0x805148,%eax
  80385b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80385e:	89 50 04             	mov    %edx,0x4(%eax)
  803861:	eb 08                	jmp    80386b <insert_sorted_with_merge_freeList+0x67e>
  803863:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803866:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80386b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80386e:	a3 48 51 80 00       	mov    %eax,0x805148
  803873:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803876:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80387d:	a1 54 51 80 00       	mov    0x805154,%eax
  803882:	40                   	inc    %eax
  803883:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803888:	e9 a9 00 00 00       	jmp    803936 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  80388d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803891:	74 06                	je     803899 <insert_sorted_with_merge_freeList+0x6ac>
  803893:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803897:	75 17                	jne    8038b0 <insert_sorted_with_merge_freeList+0x6c3>
  803899:	83 ec 04             	sub    $0x4,%esp
  80389c:	68 6c 45 80 00       	push   $0x80456c
  8038a1:	68 73 01 00 00       	push   $0x173
  8038a6:	68 f7 44 80 00       	push   $0x8044f7
  8038ab:	e8 6e ce ff ff       	call   80071e <_panic>
  8038b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038b3:	8b 10                	mov    (%eax),%edx
  8038b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8038b8:	89 10                	mov    %edx,(%eax)
  8038ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8038bd:	8b 00                	mov    (%eax),%eax
  8038bf:	85 c0                	test   %eax,%eax
  8038c1:	74 0b                	je     8038ce <insert_sorted_with_merge_freeList+0x6e1>
  8038c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038c6:	8b 00                	mov    (%eax),%eax
  8038c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8038cb:	89 50 04             	mov    %edx,0x4(%eax)
  8038ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8038d4:	89 10                	mov    %edx,(%eax)
  8038d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8038d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8038dc:	89 50 04             	mov    %edx,0x4(%eax)
  8038df:	8b 45 08             	mov    0x8(%ebp),%eax
  8038e2:	8b 00                	mov    (%eax),%eax
  8038e4:	85 c0                	test   %eax,%eax
  8038e6:	75 08                	jne    8038f0 <insert_sorted_with_merge_freeList+0x703>
  8038e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8038eb:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8038f0:	a1 44 51 80 00       	mov    0x805144,%eax
  8038f5:	40                   	inc    %eax
  8038f6:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  8038fb:	eb 39                	jmp    803936 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8038fd:	a1 40 51 80 00       	mov    0x805140,%eax
  803902:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803905:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803909:	74 07                	je     803912 <insert_sorted_with_merge_freeList+0x725>
  80390b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80390e:	8b 00                	mov    (%eax),%eax
  803910:	eb 05                	jmp    803917 <insert_sorted_with_merge_freeList+0x72a>
  803912:	b8 00 00 00 00       	mov    $0x0,%eax
  803917:	a3 40 51 80 00       	mov    %eax,0x805140
  80391c:	a1 40 51 80 00       	mov    0x805140,%eax
  803921:	85 c0                	test   %eax,%eax
  803923:	0f 85 c7 fb ff ff    	jne    8034f0 <insert_sorted_with_merge_freeList+0x303>
  803929:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80392d:	0f 85 bd fb ff ff    	jne    8034f0 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803933:	eb 01                	jmp    803936 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803935:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803936:	90                   	nop
  803937:	c9                   	leave  
  803938:	c3                   	ret    

00803939 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803939:	55                   	push   %ebp
  80393a:	89 e5                	mov    %esp,%ebp
  80393c:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  80393f:	8b 55 08             	mov    0x8(%ebp),%edx
  803942:	89 d0                	mov    %edx,%eax
  803944:	c1 e0 02             	shl    $0x2,%eax
  803947:	01 d0                	add    %edx,%eax
  803949:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803950:	01 d0                	add    %edx,%eax
  803952:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803959:	01 d0                	add    %edx,%eax
  80395b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803962:	01 d0                	add    %edx,%eax
  803964:	c1 e0 04             	shl    $0x4,%eax
  803967:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  80396a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  803971:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803974:	83 ec 0c             	sub    $0xc,%esp
  803977:	50                   	push   %eax
  803978:	e8 26 e7 ff ff       	call   8020a3 <sys_get_virtual_time>
  80397d:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803980:	eb 41                	jmp    8039c3 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  803982:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803985:	83 ec 0c             	sub    $0xc,%esp
  803988:	50                   	push   %eax
  803989:	e8 15 e7 ff ff       	call   8020a3 <sys_get_virtual_time>
  80398e:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803991:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803994:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803997:	29 c2                	sub    %eax,%edx
  803999:	89 d0                	mov    %edx,%eax
  80399b:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  80399e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8039a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8039a4:	89 d1                	mov    %edx,%ecx
  8039a6:	29 c1                	sub    %eax,%ecx
  8039a8:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8039ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8039ae:	39 c2                	cmp    %eax,%edx
  8039b0:	0f 97 c0             	seta   %al
  8039b3:	0f b6 c0             	movzbl %al,%eax
  8039b6:	29 c1                	sub    %eax,%ecx
  8039b8:	89 c8                	mov    %ecx,%eax
  8039ba:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8039bd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8039c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8039c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039c6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8039c9:	72 b7                	jb     803982 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8039cb:	90                   	nop
  8039cc:	c9                   	leave  
  8039cd:	c3                   	ret    

008039ce <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8039ce:	55                   	push   %ebp
  8039cf:	89 e5                	mov    %esp,%ebp
  8039d1:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8039d4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8039db:	eb 03                	jmp    8039e0 <busy_wait+0x12>
  8039dd:	ff 45 fc             	incl   -0x4(%ebp)
  8039e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8039e3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8039e6:	72 f5                	jb     8039dd <busy_wait+0xf>
	return i;
  8039e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8039eb:	c9                   	leave  
  8039ec:	c3                   	ret    
  8039ed:	66 90                	xchg   %ax,%ax
  8039ef:	90                   	nop

008039f0 <__udivdi3>:
  8039f0:	55                   	push   %ebp
  8039f1:	57                   	push   %edi
  8039f2:	56                   	push   %esi
  8039f3:	53                   	push   %ebx
  8039f4:	83 ec 1c             	sub    $0x1c,%esp
  8039f7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8039fb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8039ff:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803a03:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803a07:	89 ca                	mov    %ecx,%edx
  803a09:	89 f8                	mov    %edi,%eax
  803a0b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803a0f:	85 f6                	test   %esi,%esi
  803a11:	75 2d                	jne    803a40 <__udivdi3+0x50>
  803a13:	39 cf                	cmp    %ecx,%edi
  803a15:	77 65                	ja     803a7c <__udivdi3+0x8c>
  803a17:	89 fd                	mov    %edi,%ebp
  803a19:	85 ff                	test   %edi,%edi
  803a1b:	75 0b                	jne    803a28 <__udivdi3+0x38>
  803a1d:	b8 01 00 00 00       	mov    $0x1,%eax
  803a22:	31 d2                	xor    %edx,%edx
  803a24:	f7 f7                	div    %edi
  803a26:	89 c5                	mov    %eax,%ebp
  803a28:	31 d2                	xor    %edx,%edx
  803a2a:	89 c8                	mov    %ecx,%eax
  803a2c:	f7 f5                	div    %ebp
  803a2e:	89 c1                	mov    %eax,%ecx
  803a30:	89 d8                	mov    %ebx,%eax
  803a32:	f7 f5                	div    %ebp
  803a34:	89 cf                	mov    %ecx,%edi
  803a36:	89 fa                	mov    %edi,%edx
  803a38:	83 c4 1c             	add    $0x1c,%esp
  803a3b:	5b                   	pop    %ebx
  803a3c:	5e                   	pop    %esi
  803a3d:	5f                   	pop    %edi
  803a3e:	5d                   	pop    %ebp
  803a3f:	c3                   	ret    
  803a40:	39 ce                	cmp    %ecx,%esi
  803a42:	77 28                	ja     803a6c <__udivdi3+0x7c>
  803a44:	0f bd fe             	bsr    %esi,%edi
  803a47:	83 f7 1f             	xor    $0x1f,%edi
  803a4a:	75 40                	jne    803a8c <__udivdi3+0x9c>
  803a4c:	39 ce                	cmp    %ecx,%esi
  803a4e:	72 0a                	jb     803a5a <__udivdi3+0x6a>
  803a50:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803a54:	0f 87 9e 00 00 00    	ja     803af8 <__udivdi3+0x108>
  803a5a:	b8 01 00 00 00       	mov    $0x1,%eax
  803a5f:	89 fa                	mov    %edi,%edx
  803a61:	83 c4 1c             	add    $0x1c,%esp
  803a64:	5b                   	pop    %ebx
  803a65:	5e                   	pop    %esi
  803a66:	5f                   	pop    %edi
  803a67:	5d                   	pop    %ebp
  803a68:	c3                   	ret    
  803a69:	8d 76 00             	lea    0x0(%esi),%esi
  803a6c:	31 ff                	xor    %edi,%edi
  803a6e:	31 c0                	xor    %eax,%eax
  803a70:	89 fa                	mov    %edi,%edx
  803a72:	83 c4 1c             	add    $0x1c,%esp
  803a75:	5b                   	pop    %ebx
  803a76:	5e                   	pop    %esi
  803a77:	5f                   	pop    %edi
  803a78:	5d                   	pop    %ebp
  803a79:	c3                   	ret    
  803a7a:	66 90                	xchg   %ax,%ax
  803a7c:	89 d8                	mov    %ebx,%eax
  803a7e:	f7 f7                	div    %edi
  803a80:	31 ff                	xor    %edi,%edi
  803a82:	89 fa                	mov    %edi,%edx
  803a84:	83 c4 1c             	add    $0x1c,%esp
  803a87:	5b                   	pop    %ebx
  803a88:	5e                   	pop    %esi
  803a89:	5f                   	pop    %edi
  803a8a:	5d                   	pop    %ebp
  803a8b:	c3                   	ret    
  803a8c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803a91:	89 eb                	mov    %ebp,%ebx
  803a93:	29 fb                	sub    %edi,%ebx
  803a95:	89 f9                	mov    %edi,%ecx
  803a97:	d3 e6                	shl    %cl,%esi
  803a99:	89 c5                	mov    %eax,%ebp
  803a9b:	88 d9                	mov    %bl,%cl
  803a9d:	d3 ed                	shr    %cl,%ebp
  803a9f:	89 e9                	mov    %ebp,%ecx
  803aa1:	09 f1                	or     %esi,%ecx
  803aa3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803aa7:	89 f9                	mov    %edi,%ecx
  803aa9:	d3 e0                	shl    %cl,%eax
  803aab:	89 c5                	mov    %eax,%ebp
  803aad:	89 d6                	mov    %edx,%esi
  803aaf:	88 d9                	mov    %bl,%cl
  803ab1:	d3 ee                	shr    %cl,%esi
  803ab3:	89 f9                	mov    %edi,%ecx
  803ab5:	d3 e2                	shl    %cl,%edx
  803ab7:	8b 44 24 08          	mov    0x8(%esp),%eax
  803abb:	88 d9                	mov    %bl,%cl
  803abd:	d3 e8                	shr    %cl,%eax
  803abf:	09 c2                	or     %eax,%edx
  803ac1:	89 d0                	mov    %edx,%eax
  803ac3:	89 f2                	mov    %esi,%edx
  803ac5:	f7 74 24 0c          	divl   0xc(%esp)
  803ac9:	89 d6                	mov    %edx,%esi
  803acb:	89 c3                	mov    %eax,%ebx
  803acd:	f7 e5                	mul    %ebp
  803acf:	39 d6                	cmp    %edx,%esi
  803ad1:	72 19                	jb     803aec <__udivdi3+0xfc>
  803ad3:	74 0b                	je     803ae0 <__udivdi3+0xf0>
  803ad5:	89 d8                	mov    %ebx,%eax
  803ad7:	31 ff                	xor    %edi,%edi
  803ad9:	e9 58 ff ff ff       	jmp    803a36 <__udivdi3+0x46>
  803ade:	66 90                	xchg   %ax,%ax
  803ae0:	8b 54 24 08          	mov    0x8(%esp),%edx
  803ae4:	89 f9                	mov    %edi,%ecx
  803ae6:	d3 e2                	shl    %cl,%edx
  803ae8:	39 c2                	cmp    %eax,%edx
  803aea:	73 e9                	jae    803ad5 <__udivdi3+0xe5>
  803aec:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803aef:	31 ff                	xor    %edi,%edi
  803af1:	e9 40 ff ff ff       	jmp    803a36 <__udivdi3+0x46>
  803af6:	66 90                	xchg   %ax,%ax
  803af8:	31 c0                	xor    %eax,%eax
  803afa:	e9 37 ff ff ff       	jmp    803a36 <__udivdi3+0x46>
  803aff:	90                   	nop

00803b00 <__umoddi3>:
  803b00:	55                   	push   %ebp
  803b01:	57                   	push   %edi
  803b02:	56                   	push   %esi
  803b03:	53                   	push   %ebx
  803b04:	83 ec 1c             	sub    $0x1c,%esp
  803b07:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803b0b:	8b 74 24 34          	mov    0x34(%esp),%esi
  803b0f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b13:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803b17:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803b1b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803b1f:	89 f3                	mov    %esi,%ebx
  803b21:	89 fa                	mov    %edi,%edx
  803b23:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803b27:	89 34 24             	mov    %esi,(%esp)
  803b2a:	85 c0                	test   %eax,%eax
  803b2c:	75 1a                	jne    803b48 <__umoddi3+0x48>
  803b2e:	39 f7                	cmp    %esi,%edi
  803b30:	0f 86 a2 00 00 00    	jbe    803bd8 <__umoddi3+0xd8>
  803b36:	89 c8                	mov    %ecx,%eax
  803b38:	89 f2                	mov    %esi,%edx
  803b3a:	f7 f7                	div    %edi
  803b3c:	89 d0                	mov    %edx,%eax
  803b3e:	31 d2                	xor    %edx,%edx
  803b40:	83 c4 1c             	add    $0x1c,%esp
  803b43:	5b                   	pop    %ebx
  803b44:	5e                   	pop    %esi
  803b45:	5f                   	pop    %edi
  803b46:	5d                   	pop    %ebp
  803b47:	c3                   	ret    
  803b48:	39 f0                	cmp    %esi,%eax
  803b4a:	0f 87 ac 00 00 00    	ja     803bfc <__umoddi3+0xfc>
  803b50:	0f bd e8             	bsr    %eax,%ebp
  803b53:	83 f5 1f             	xor    $0x1f,%ebp
  803b56:	0f 84 ac 00 00 00    	je     803c08 <__umoddi3+0x108>
  803b5c:	bf 20 00 00 00       	mov    $0x20,%edi
  803b61:	29 ef                	sub    %ebp,%edi
  803b63:	89 fe                	mov    %edi,%esi
  803b65:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803b69:	89 e9                	mov    %ebp,%ecx
  803b6b:	d3 e0                	shl    %cl,%eax
  803b6d:	89 d7                	mov    %edx,%edi
  803b6f:	89 f1                	mov    %esi,%ecx
  803b71:	d3 ef                	shr    %cl,%edi
  803b73:	09 c7                	or     %eax,%edi
  803b75:	89 e9                	mov    %ebp,%ecx
  803b77:	d3 e2                	shl    %cl,%edx
  803b79:	89 14 24             	mov    %edx,(%esp)
  803b7c:	89 d8                	mov    %ebx,%eax
  803b7e:	d3 e0                	shl    %cl,%eax
  803b80:	89 c2                	mov    %eax,%edx
  803b82:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b86:	d3 e0                	shl    %cl,%eax
  803b88:	89 44 24 04          	mov    %eax,0x4(%esp)
  803b8c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b90:	89 f1                	mov    %esi,%ecx
  803b92:	d3 e8                	shr    %cl,%eax
  803b94:	09 d0                	or     %edx,%eax
  803b96:	d3 eb                	shr    %cl,%ebx
  803b98:	89 da                	mov    %ebx,%edx
  803b9a:	f7 f7                	div    %edi
  803b9c:	89 d3                	mov    %edx,%ebx
  803b9e:	f7 24 24             	mull   (%esp)
  803ba1:	89 c6                	mov    %eax,%esi
  803ba3:	89 d1                	mov    %edx,%ecx
  803ba5:	39 d3                	cmp    %edx,%ebx
  803ba7:	0f 82 87 00 00 00    	jb     803c34 <__umoddi3+0x134>
  803bad:	0f 84 91 00 00 00    	je     803c44 <__umoddi3+0x144>
  803bb3:	8b 54 24 04          	mov    0x4(%esp),%edx
  803bb7:	29 f2                	sub    %esi,%edx
  803bb9:	19 cb                	sbb    %ecx,%ebx
  803bbb:	89 d8                	mov    %ebx,%eax
  803bbd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803bc1:	d3 e0                	shl    %cl,%eax
  803bc3:	89 e9                	mov    %ebp,%ecx
  803bc5:	d3 ea                	shr    %cl,%edx
  803bc7:	09 d0                	or     %edx,%eax
  803bc9:	89 e9                	mov    %ebp,%ecx
  803bcb:	d3 eb                	shr    %cl,%ebx
  803bcd:	89 da                	mov    %ebx,%edx
  803bcf:	83 c4 1c             	add    $0x1c,%esp
  803bd2:	5b                   	pop    %ebx
  803bd3:	5e                   	pop    %esi
  803bd4:	5f                   	pop    %edi
  803bd5:	5d                   	pop    %ebp
  803bd6:	c3                   	ret    
  803bd7:	90                   	nop
  803bd8:	89 fd                	mov    %edi,%ebp
  803bda:	85 ff                	test   %edi,%edi
  803bdc:	75 0b                	jne    803be9 <__umoddi3+0xe9>
  803bde:	b8 01 00 00 00       	mov    $0x1,%eax
  803be3:	31 d2                	xor    %edx,%edx
  803be5:	f7 f7                	div    %edi
  803be7:	89 c5                	mov    %eax,%ebp
  803be9:	89 f0                	mov    %esi,%eax
  803beb:	31 d2                	xor    %edx,%edx
  803bed:	f7 f5                	div    %ebp
  803bef:	89 c8                	mov    %ecx,%eax
  803bf1:	f7 f5                	div    %ebp
  803bf3:	89 d0                	mov    %edx,%eax
  803bf5:	e9 44 ff ff ff       	jmp    803b3e <__umoddi3+0x3e>
  803bfa:	66 90                	xchg   %ax,%ax
  803bfc:	89 c8                	mov    %ecx,%eax
  803bfe:	89 f2                	mov    %esi,%edx
  803c00:	83 c4 1c             	add    $0x1c,%esp
  803c03:	5b                   	pop    %ebx
  803c04:	5e                   	pop    %esi
  803c05:	5f                   	pop    %edi
  803c06:	5d                   	pop    %ebp
  803c07:	c3                   	ret    
  803c08:	3b 04 24             	cmp    (%esp),%eax
  803c0b:	72 06                	jb     803c13 <__umoddi3+0x113>
  803c0d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803c11:	77 0f                	ja     803c22 <__umoddi3+0x122>
  803c13:	89 f2                	mov    %esi,%edx
  803c15:	29 f9                	sub    %edi,%ecx
  803c17:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803c1b:	89 14 24             	mov    %edx,(%esp)
  803c1e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c22:	8b 44 24 04          	mov    0x4(%esp),%eax
  803c26:	8b 14 24             	mov    (%esp),%edx
  803c29:	83 c4 1c             	add    $0x1c,%esp
  803c2c:	5b                   	pop    %ebx
  803c2d:	5e                   	pop    %esi
  803c2e:	5f                   	pop    %edi
  803c2f:	5d                   	pop    %ebp
  803c30:	c3                   	ret    
  803c31:	8d 76 00             	lea    0x0(%esi),%esi
  803c34:	2b 04 24             	sub    (%esp),%eax
  803c37:	19 fa                	sbb    %edi,%edx
  803c39:	89 d1                	mov    %edx,%ecx
  803c3b:	89 c6                	mov    %eax,%esi
  803c3d:	e9 71 ff ff ff       	jmp    803bb3 <__umoddi3+0xb3>
  803c42:	66 90                	xchg   %ax,%ax
  803c44:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803c48:	72 ea                	jb     803c34 <__umoddi3+0x134>
  803c4a:	89 d9                	mov    %ebx,%ecx
  803c4c:	e9 62 ff ff ff       	jmp    803bb3 <__umoddi3+0xb3>
