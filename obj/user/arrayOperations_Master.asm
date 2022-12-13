
obj/user/arrayOperations_Master:     file format elf32-i386


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
  800031:	e8 2b 07 00 00       	call   800761 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
uint32 CheckSorted(int *Elements, int NumOfElements);
void ArrayStats(int *Elements, int NumOfElements, int *mean, int *var);

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 88 00 00 00    	sub    $0x88,%esp
	/*[1] CREATE SHARED ARRAY*/
	int ret;
	char Chose;
	char Line[30];
	//2012: lock the interrupt
	sys_disable_interrupt();
  800041:	e8 5b 20 00 00       	call   8020a1 <sys_disable_interrupt>
		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 e0 3d 80 00       	push   $0x803de0
  80004e:	e8 fe 0a 00 00       	call   800b51 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 e2 3d 80 00       	push   $0x803de2
  80005e:	e8 ee 0a 00 00       	call   800b51 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!   ARRAY OOERATIONS   !!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 00 3e 80 00       	push   $0x803e00
  80006e:	e8 de 0a 00 00       	call   800b51 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 e2 3d 80 00       	push   $0x803de2
  80007e:	e8 ce 0a 00 00       	call   800b51 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 e0 3d 80 00       	push   $0x803de0
  80008e:	e8 be 0a 00 00       	call   800b51 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp

		readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 45 82             	lea    -0x7e(%ebp),%eax
  80009c:	50                   	push   %eax
  80009d:	68 20 3e 80 00       	push   $0x803e20
  8000a2:	e8 2c 11 00 00       	call   8011d3 <readline>
  8000a7:	83 c4 10             	add    $0x10,%esp

		//Create the shared array & its size
		int *arrSize = smalloc("arrSize", sizeof(int) , 0) ;
  8000aa:	83 ec 04             	sub    $0x4,%esp
  8000ad:	6a 00                	push   $0x0
  8000af:	6a 04                	push   $0x4
  8000b1:	68 3f 3e 80 00       	push   $0x803e3f
  8000b6:	e8 b9 1c 00 00       	call   801d74 <smalloc>
  8000bb:	83 c4 10             	add    $0x10,%esp
  8000be:	89 45 f4             	mov    %eax,-0xc(%ebp)
		*arrSize = strtol(Line, NULL, 10) ;
  8000c1:	83 ec 04             	sub    $0x4,%esp
  8000c4:	6a 0a                	push   $0xa
  8000c6:	6a 00                	push   $0x0
  8000c8:	8d 45 82             	lea    -0x7e(%ebp),%eax
  8000cb:	50                   	push   %eax
  8000cc:	e8 68 16 00 00       	call   801739 <strtol>
  8000d1:	83 c4 10             	add    $0x10,%esp
  8000d4:	89 c2                	mov    %eax,%edx
  8000d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000d9:	89 10                	mov    %edx,(%eax)
		int NumOfElements = *arrSize;
  8000db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000de:	8b 00                	mov    (%eax),%eax
  8000e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
		int *Elements = smalloc("arr", sizeof(int) * NumOfElements , 0) ;
  8000e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000e6:	c1 e0 02             	shl    $0x2,%eax
  8000e9:	83 ec 04             	sub    $0x4,%esp
  8000ec:	6a 00                	push   $0x0
  8000ee:	50                   	push   %eax
  8000ef:	68 47 3e 80 00       	push   $0x803e47
  8000f4:	e8 7b 1c 00 00       	call   801d74 <smalloc>
  8000f9:	83 c4 10             	add    $0x10,%esp
  8000fc:	89 45 ec             	mov    %eax,-0x14(%ebp)

		cprintf("Chose the initialization method:\n") ;
  8000ff:	83 ec 0c             	sub    $0xc,%esp
  800102:	68 4c 3e 80 00       	push   $0x803e4c
  800107:	e8 45 0a 00 00       	call   800b51 <cprintf>
  80010c:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  80010f:	83 ec 0c             	sub    $0xc,%esp
  800112:	68 6e 3e 80 00       	push   $0x803e6e
  800117:	e8 35 0a 00 00       	call   800b51 <cprintf>
  80011c:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  80011f:	83 ec 0c             	sub    $0xc,%esp
  800122:	68 7c 3e 80 00       	push   $0x803e7c
  800127:	e8 25 0a 00 00       	call   800b51 <cprintf>
  80012c:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  80012f:	83 ec 0c             	sub    $0xc,%esp
  800132:	68 8b 3e 80 00       	push   $0x803e8b
  800137:	e8 15 0a 00 00       	call   800b51 <cprintf>
  80013c:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80013f:	83 ec 0c             	sub    $0xc,%esp
  800142:	68 9b 3e 80 00       	push   $0x803e9b
  800147:	e8 05 0a 00 00       	call   800b51 <cprintf>
  80014c:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  80014f:	e8 b5 05 00 00       	call   800709 <getchar>
  800154:	88 45 eb             	mov    %al,-0x15(%ebp)
			cputchar(Chose);
  800157:	0f be 45 eb          	movsbl -0x15(%ebp),%eax
  80015b:	83 ec 0c             	sub    $0xc,%esp
  80015e:	50                   	push   %eax
  80015f:	e8 5d 05 00 00       	call   8006c1 <cputchar>
  800164:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800167:	83 ec 0c             	sub    $0xc,%esp
  80016a:	6a 0a                	push   $0xa
  80016c:	e8 50 05 00 00       	call   8006c1 <cputchar>
  800171:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800174:	80 7d eb 61          	cmpb   $0x61,-0x15(%ebp)
  800178:	74 0c                	je     800186 <_main+0x14e>
  80017a:	80 7d eb 62          	cmpb   $0x62,-0x15(%ebp)
  80017e:	74 06                	je     800186 <_main+0x14e>
  800180:	80 7d eb 63          	cmpb   $0x63,-0x15(%ebp)
  800184:	75 b9                	jne    80013f <_main+0x107>

	//2012: unlock the interrupt
	sys_enable_interrupt();
  800186:	e8 30 1f 00 00       	call   8020bb <sys_enable_interrupt>

	int  i ;
	switch (Chose)
  80018b:	0f be 45 eb          	movsbl -0x15(%ebp),%eax
  80018f:	83 f8 62             	cmp    $0x62,%eax
  800192:	74 1d                	je     8001b1 <_main+0x179>
  800194:	83 f8 63             	cmp    $0x63,%eax
  800197:	74 2b                	je     8001c4 <_main+0x18c>
  800199:	83 f8 61             	cmp    $0x61,%eax
  80019c:	75 39                	jne    8001d7 <_main+0x19f>
	{
	case 'a':
		InitializeAscending(Elements, NumOfElements);
  80019e:	83 ec 08             	sub    $0x8,%esp
  8001a1:	ff 75 f0             	pushl  -0x10(%ebp)
  8001a4:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a7:	e8 9b 03 00 00       	call   800547 <InitializeAscending>
  8001ac:	83 c4 10             	add    $0x10,%esp
		break ;
  8001af:	eb 37                	jmp    8001e8 <_main+0x1b0>
	case 'b':
		InitializeDescending(Elements, NumOfElements);
  8001b1:	83 ec 08             	sub    $0x8,%esp
  8001b4:	ff 75 f0             	pushl  -0x10(%ebp)
  8001b7:	ff 75 ec             	pushl  -0x14(%ebp)
  8001ba:	e8 b9 03 00 00       	call   800578 <InitializeDescending>
  8001bf:	83 c4 10             	add    $0x10,%esp
		break ;
  8001c2:	eb 24                	jmp    8001e8 <_main+0x1b0>
	case 'c':
		InitializeSemiRandom(Elements, NumOfElements);
  8001c4:	83 ec 08             	sub    $0x8,%esp
  8001c7:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ca:	ff 75 ec             	pushl  -0x14(%ebp)
  8001cd:	e8 db 03 00 00       	call   8005ad <InitializeSemiRandom>
  8001d2:	83 c4 10             	add    $0x10,%esp
		break ;
  8001d5:	eb 11                	jmp    8001e8 <_main+0x1b0>
	default:
		InitializeSemiRandom(Elements, NumOfElements);
  8001d7:	83 ec 08             	sub    $0x8,%esp
  8001da:	ff 75 f0             	pushl  -0x10(%ebp)
  8001dd:	ff 75 ec             	pushl  -0x14(%ebp)
  8001e0:	e8 c8 03 00 00       	call   8005ad <InitializeSemiRandom>
  8001e5:	83 c4 10             	add    $0x10,%esp
	}

	//Create the check-finishing counter
	int numOfSlaveProgs = 3 ;
  8001e8:	c7 45 e4 03 00 00 00 	movl   $0x3,-0x1c(%ebp)
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  8001ef:	83 ec 04             	sub    $0x4,%esp
  8001f2:	6a 01                	push   $0x1
  8001f4:	6a 04                	push   $0x4
  8001f6:	68 a4 3e 80 00       	push   $0x803ea4
  8001fb:	e8 74 1b 00 00       	call   801d74 <smalloc>
  800200:	83 c4 10             	add    $0x10,%esp
  800203:	89 45 e0             	mov    %eax,-0x20(%ebp)
	*numOfFinished = 0 ;
  800206:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800209:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	/*[2] RUN THE SLAVES PROGRAMS*/
	int32 envIdQuickSort = sys_create_env("slave_qs", (myEnv->page_WS_max_size),(myEnv->SecondListSize) ,(myEnv->percentage_of_WS_pages_to_be_removed));
  80020f:	a1 20 50 80 00       	mov    0x805020,%eax
  800214:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  80021a:	a1 20 50 80 00       	mov    0x805020,%eax
  80021f:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800225:	89 c1                	mov    %eax,%ecx
  800227:	a1 20 50 80 00       	mov    0x805020,%eax
  80022c:	8b 40 74             	mov    0x74(%eax),%eax
  80022f:	52                   	push   %edx
  800230:	51                   	push   %ecx
  800231:	50                   	push   %eax
  800232:	68 b2 3e 80 00       	push   $0x803eb2
  800237:	e8 ea 1f 00 00       	call   802226 <sys_create_env>
  80023c:	83 c4 10             	add    $0x10,%esp
  80023f:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int32 envIdMergeSort = sys_create_env("slave_ms", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  800242:	a1 20 50 80 00       	mov    0x805020,%eax
  800247:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  80024d:	a1 20 50 80 00       	mov    0x805020,%eax
  800252:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800258:	89 c1                	mov    %eax,%ecx
  80025a:	a1 20 50 80 00       	mov    0x805020,%eax
  80025f:	8b 40 74             	mov    0x74(%eax),%eax
  800262:	52                   	push   %edx
  800263:	51                   	push   %ecx
  800264:	50                   	push   %eax
  800265:	68 bb 3e 80 00       	push   $0x803ebb
  80026a:	e8 b7 1f 00 00       	call   802226 <sys_create_env>
  80026f:	83 c4 10             	add    $0x10,%esp
  800272:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int32 envIdStats = sys_create_env("slave_stats", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  800275:	a1 20 50 80 00       	mov    0x805020,%eax
  80027a:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  800280:	a1 20 50 80 00       	mov    0x805020,%eax
  800285:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80028b:	89 c1                	mov    %eax,%ecx
  80028d:	a1 20 50 80 00       	mov    0x805020,%eax
  800292:	8b 40 74             	mov    0x74(%eax),%eax
  800295:	52                   	push   %edx
  800296:	51                   	push   %ecx
  800297:	50                   	push   %eax
  800298:	68 c4 3e 80 00       	push   $0x803ec4
  80029d:	e8 84 1f 00 00       	call   802226 <sys_create_env>
  8002a2:	83 c4 10             	add    $0x10,%esp
  8002a5:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if (envIdQuickSort == E_ENV_CREATION_ERROR || envIdMergeSort == E_ENV_CREATION_ERROR || envIdStats == E_ENV_CREATION_ERROR)
  8002a8:	83 7d dc ef          	cmpl   $0xffffffef,-0x24(%ebp)
  8002ac:	74 0c                	je     8002ba <_main+0x282>
  8002ae:	83 7d d8 ef          	cmpl   $0xffffffef,-0x28(%ebp)
  8002b2:	74 06                	je     8002ba <_main+0x282>
  8002b4:	83 7d d4 ef          	cmpl   $0xffffffef,-0x2c(%ebp)
  8002b8:	75 14                	jne    8002ce <_main+0x296>
		panic("NO AVAILABLE ENVs...");
  8002ba:	83 ec 04             	sub    $0x4,%esp
  8002bd:	68 d0 3e 80 00       	push   $0x803ed0
  8002c2:	6a 4b                	push   $0x4b
  8002c4:	68 e5 3e 80 00       	push   $0x803ee5
  8002c9:	e8 cf 05 00 00       	call   80089d <_panic>

	sys_run_env(envIdQuickSort);
  8002ce:	83 ec 0c             	sub    $0xc,%esp
  8002d1:	ff 75 dc             	pushl  -0x24(%ebp)
  8002d4:	e8 6b 1f 00 00       	call   802244 <sys_run_env>
  8002d9:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdMergeSort);
  8002dc:	83 ec 0c             	sub    $0xc,%esp
  8002df:	ff 75 d8             	pushl  -0x28(%ebp)
  8002e2:	e8 5d 1f 00 00       	call   802244 <sys_run_env>
  8002e7:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdStats);
  8002ea:	83 ec 0c             	sub    $0xc,%esp
  8002ed:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002f0:	e8 4f 1f 00 00       	call   802244 <sys_run_env>
  8002f5:	83 c4 10             	add    $0x10,%esp

	/*[3] BUSY-WAIT TILL FINISHING THEM*/
	while (*numOfFinished != numOfSlaveProgs) ;
  8002f8:	90                   	nop
  8002f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002fc:	8b 00                	mov    (%eax),%eax
  8002fe:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800301:	75 f6                	jne    8002f9 <_main+0x2c1>

	/*[4] GET THEIR RESULTS*/
	int *quicksortedArr = NULL;
  800303:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
	int *mergesortedArr = NULL;
  80030a:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
	int *mean = NULL;
  800311:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
	int *var = NULL;
  800318:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
	int *min = NULL;
  80031f:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
	int *max = NULL;
  800326:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
	int *med = NULL;
  80032d:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
	quicksortedArr = sget(envIdQuickSort, "quicksortedArr") ;
  800334:	83 ec 08             	sub    $0x8,%esp
  800337:	68 03 3f 80 00       	push   $0x803f03
  80033c:	ff 75 dc             	pushl  -0x24(%ebp)
  80033f:	e8 cc 1a 00 00       	call   801e10 <sget>
  800344:	83 c4 10             	add    $0x10,%esp
  800347:	89 45 d0             	mov    %eax,-0x30(%ebp)
	mergesortedArr = sget(envIdMergeSort, "mergesortedArr") ;
  80034a:	83 ec 08             	sub    $0x8,%esp
  80034d:	68 12 3f 80 00       	push   $0x803f12
  800352:	ff 75 d8             	pushl  -0x28(%ebp)
  800355:	e8 b6 1a 00 00       	call   801e10 <sget>
  80035a:	83 c4 10             	add    $0x10,%esp
  80035d:	89 45 cc             	mov    %eax,-0x34(%ebp)
	mean = sget(envIdStats, "mean") ;
  800360:	83 ec 08             	sub    $0x8,%esp
  800363:	68 21 3f 80 00       	push   $0x803f21
  800368:	ff 75 d4             	pushl  -0x2c(%ebp)
  80036b:	e8 a0 1a 00 00       	call   801e10 <sget>
  800370:	83 c4 10             	add    $0x10,%esp
  800373:	89 45 c8             	mov    %eax,-0x38(%ebp)
	var = sget(envIdStats,"var") ;
  800376:	83 ec 08             	sub    $0x8,%esp
  800379:	68 26 3f 80 00       	push   $0x803f26
  80037e:	ff 75 d4             	pushl  -0x2c(%ebp)
  800381:	e8 8a 1a 00 00       	call   801e10 <sget>
  800386:	83 c4 10             	add    $0x10,%esp
  800389:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	min = sget(envIdStats,"min") ;
  80038c:	83 ec 08             	sub    $0x8,%esp
  80038f:	68 2a 3f 80 00       	push   $0x803f2a
  800394:	ff 75 d4             	pushl  -0x2c(%ebp)
  800397:	e8 74 1a 00 00       	call   801e10 <sget>
  80039c:	83 c4 10             	add    $0x10,%esp
  80039f:	89 45 c0             	mov    %eax,-0x40(%ebp)
	max = sget(envIdStats,"max") ;
  8003a2:	83 ec 08             	sub    $0x8,%esp
  8003a5:	68 2e 3f 80 00       	push   $0x803f2e
  8003aa:	ff 75 d4             	pushl  -0x2c(%ebp)
  8003ad:	e8 5e 1a 00 00       	call   801e10 <sget>
  8003b2:	83 c4 10             	add    $0x10,%esp
  8003b5:	89 45 bc             	mov    %eax,-0x44(%ebp)
	med = sget(envIdStats,"med") ;
  8003b8:	83 ec 08             	sub    $0x8,%esp
  8003bb:	68 32 3f 80 00       	push   $0x803f32
  8003c0:	ff 75 d4             	pushl  -0x2c(%ebp)
  8003c3:	e8 48 1a 00 00       	call   801e10 <sget>
  8003c8:	83 c4 10             	add    $0x10,%esp
  8003cb:	89 45 b8             	mov    %eax,-0x48(%ebp)

	/*[5] VALIDATE THE RESULTS*/
	uint32 sorted = CheckSorted(quicksortedArr, NumOfElements);
  8003ce:	83 ec 08             	sub    $0x8,%esp
  8003d1:	ff 75 f0             	pushl  -0x10(%ebp)
  8003d4:	ff 75 d0             	pushl  -0x30(%ebp)
  8003d7:	e8 14 01 00 00       	call   8004f0 <CheckSorted>
  8003dc:	83 c4 10             	add    $0x10,%esp
  8003df:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if(sorted == 0) panic("The array is NOT quick-sorted correctly") ;
  8003e2:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  8003e6:	75 14                	jne    8003fc <_main+0x3c4>
  8003e8:	83 ec 04             	sub    $0x4,%esp
  8003eb:	68 38 3f 80 00       	push   $0x803f38
  8003f0:	6a 66                	push   $0x66
  8003f2:	68 e5 3e 80 00       	push   $0x803ee5
  8003f7:	e8 a1 04 00 00       	call   80089d <_panic>
	sorted = CheckSorted(mergesortedArr, NumOfElements);
  8003fc:	83 ec 08             	sub    $0x8,%esp
  8003ff:	ff 75 f0             	pushl  -0x10(%ebp)
  800402:	ff 75 cc             	pushl  -0x34(%ebp)
  800405:	e8 e6 00 00 00       	call   8004f0 <CheckSorted>
  80040a:	83 c4 10             	add    $0x10,%esp
  80040d:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if(sorted == 0) panic("The array is NOT merge-sorted correctly") ;
  800410:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  800414:	75 14                	jne    80042a <_main+0x3f2>
  800416:	83 ec 04             	sub    $0x4,%esp
  800419:	68 60 3f 80 00       	push   $0x803f60
  80041e:	6a 68                	push   $0x68
  800420:	68 e5 3e 80 00       	push   $0x803ee5
  800425:	e8 73 04 00 00       	call   80089d <_panic>
	int correctMean, correctVar ;
	ArrayStats(Elements, NumOfElements, &correctMean , &correctVar);
  80042a:	8d 85 78 ff ff ff    	lea    -0x88(%ebp),%eax
  800430:	50                   	push   %eax
  800431:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800437:	50                   	push   %eax
  800438:	ff 75 f0             	pushl  -0x10(%ebp)
  80043b:	ff 75 ec             	pushl  -0x14(%ebp)
  80043e:	e8 b6 01 00 00       	call   8005f9 <ArrayStats>
  800443:	83 c4 10             	add    $0x10,%esp
	int correctMin = quicksortedArr[0];
  800446:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800449:	8b 00                	mov    (%eax),%eax
  80044b:	89 45 b0             	mov    %eax,-0x50(%ebp)
	int last = NumOfElements-1;
  80044e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800451:	48                   	dec    %eax
  800452:	89 45 ac             	mov    %eax,-0x54(%ebp)
	int middle = (NumOfElements-1)/2;
  800455:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800458:	48                   	dec    %eax
  800459:	89 c2                	mov    %eax,%edx
  80045b:	c1 ea 1f             	shr    $0x1f,%edx
  80045e:	01 d0                	add    %edx,%eax
  800460:	d1 f8                	sar    %eax
  800462:	89 45 a8             	mov    %eax,-0x58(%ebp)
	int correctMax = quicksortedArr[last];
  800465:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800468:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80046f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800472:	01 d0                	add    %edx,%eax
  800474:	8b 00                	mov    (%eax),%eax
  800476:	89 45 a4             	mov    %eax,-0x5c(%ebp)
	int correctMed = quicksortedArr[middle];
  800479:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80047c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800483:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800486:	01 d0                	add    %edx,%eax
  800488:	8b 00                	mov    (%eax),%eax
  80048a:	89 45 a0             	mov    %eax,-0x60(%ebp)
	//cprintf("Array is correctly sorted\n");
	//cprintf("mean = %d, var = %d\nmin = %d, max = %d, med = %d\n", *mean, *var, *min, *max, *med);
	//cprintf("mean = %d, var = %d\nmin = %d, max = %d, med = %d\n", correctMean, correctVar, correctMin, correctMax, correctMed);

	if(*mean != correctMean || *var != correctVar|| *min != correctMin || *max != correctMax || *med != correctMed)
  80048d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800490:	8b 10                	mov    (%eax),%edx
  800492:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800498:	39 c2                	cmp    %eax,%edx
  80049a:	75 2d                	jne    8004c9 <_main+0x491>
  80049c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80049f:	8b 10                	mov    (%eax),%edx
  8004a1:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  8004a7:	39 c2                	cmp    %eax,%edx
  8004a9:	75 1e                	jne    8004c9 <_main+0x491>
  8004ab:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8004ae:	8b 00                	mov    (%eax),%eax
  8004b0:	3b 45 b0             	cmp    -0x50(%ebp),%eax
  8004b3:	75 14                	jne    8004c9 <_main+0x491>
  8004b5:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8004b8:	8b 00                	mov    (%eax),%eax
  8004ba:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8004bd:	75 0a                	jne    8004c9 <_main+0x491>
  8004bf:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8004c2:	8b 00                	mov    (%eax),%eax
  8004c4:	3b 45 a0             	cmp    -0x60(%ebp),%eax
  8004c7:	74 14                	je     8004dd <_main+0x4a5>
		panic("The array STATS are NOT calculated correctly") ;
  8004c9:	83 ec 04             	sub    $0x4,%esp
  8004cc:	68 88 3f 80 00       	push   $0x803f88
  8004d1:	6a 75                	push   $0x75
  8004d3:	68 e5 3e 80 00       	push   $0x803ee5
  8004d8:	e8 c0 03 00 00       	call   80089d <_panic>

	cprintf("Congratulations!! Scenario of Using the Shared Variables [Create & Get] completed successfully!!\n\n\n");
  8004dd:	83 ec 0c             	sub    $0xc,%esp
  8004e0:	68 b8 3f 80 00       	push   $0x803fb8
  8004e5:	e8 67 06 00 00       	call   800b51 <cprintf>
  8004ea:	83 c4 10             	add    $0x10,%esp

	return;
  8004ed:	90                   	nop
}
  8004ee:	c9                   	leave  
  8004ef:	c3                   	ret    

008004f0 <CheckSorted>:


uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8004f0:	55                   	push   %ebp
  8004f1:	89 e5                	mov    %esp,%ebp
  8004f3:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8004f6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8004fd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800504:	eb 33                	jmp    800539 <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  800506:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800509:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800510:	8b 45 08             	mov    0x8(%ebp),%eax
  800513:	01 d0                	add    %edx,%eax
  800515:	8b 10                	mov    (%eax),%edx
  800517:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80051a:	40                   	inc    %eax
  80051b:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800522:	8b 45 08             	mov    0x8(%ebp),%eax
  800525:	01 c8                	add    %ecx,%eax
  800527:	8b 00                	mov    (%eax),%eax
  800529:	39 c2                	cmp    %eax,%edx
  80052b:	7e 09                	jle    800536 <CheckSorted+0x46>
		{
			Sorted = 0 ;
  80052d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800534:	eb 0c                	jmp    800542 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800536:	ff 45 f8             	incl   -0x8(%ebp)
  800539:	8b 45 0c             	mov    0xc(%ebp),%eax
  80053c:	48                   	dec    %eax
  80053d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800540:	7f c4                	jg     800506 <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800542:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800545:	c9                   	leave  
  800546:	c3                   	ret    

00800547 <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  800547:	55                   	push   %ebp
  800548:	89 e5                	mov    %esp,%ebp
  80054a:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80054d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800554:	eb 17                	jmp    80056d <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  800556:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800559:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800560:	8b 45 08             	mov    0x8(%ebp),%eax
  800563:	01 c2                	add    %eax,%edx
  800565:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800568:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80056a:	ff 45 fc             	incl   -0x4(%ebp)
  80056d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800570:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800573:	7c e1                	jl     800556 <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  800575:	90                   	nop
  800576:	c9                   	leave  
  800577:	c3                   	ret    

00800578 <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  800578:	55                   	push   %ebp
  800579:	89 e5                	mov    %esp,%ebp
  80057b:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80057e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800585:	eb 1b                	jmp    8005a2 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  800587:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80058a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800591:	8b 45 08             	mov    0x8(%ebp),%eax
  800594:	01 c2                	add    %eax,%edx
  800596:	8b 45 0c             	mov    0xc(%ebp),%eax
  800599:	2b 45 fc             	sub    -0x4(%ebp),%eax
  80059c:	48                   	dec    %eax
  80059d:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80059f:	ff 45 fc             	incl   -0x4(%ebp)
  8005a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8005a5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8005a8:	7c dd                	jl     800587 <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8005aa:	90                   	nop
  8005ab:	c9                   	leave  
  8005ac:	c3                   	ret    

008005ad <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8005ad:	55                   	push   %ebp
  8005ae:	89 e5                	mov    %esp,%ebp
  8005b0:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8005b3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005b6:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8005bb:	f7 e9                	imul   %ecx
  8005bd:	c1 f9 1f             	sar    $0x1f,%ecx
  8005c0:	89 d0                	mov    %edx,%eax
  8005c2:	29 c8                	sub    %ecx,%eax
  8005c4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  8005c7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8005ce:	eb 1e                	jmp    8005ee <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  8005d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8005d3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005da:	8b 45 08             	mov    0x8(%ebp),%eax
  8005dd:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8005e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8005e3:	99                   	cltd   
  8005e4:	f7 7d f8             	idivl  -0x8(%ebp)
  8005e7:	89 d0                	mov    %edx,%eax
  8005e9:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  8005eb:	ff 45 fc             	incl   -0x4(%ebp)
  8005ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8005f1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8005f4:	7c da                	jl     8005d0 <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
		//cprintf("Elements[%d] = %d\n",i, Elements[i]);
	}

}
  8005f6:	90                   	nop
  8005f7:	c9                   	leave  
  8005f8:	c3                   	ret    

008005f9 <ArrayStats>:

void ArrayStats(int *Elements, int NumOfElements, int *mean, int *var)
{
  8005f9:	55                   	push   %ebp
  8005fa:	89 e5                	mov    %esp,%ebp
  8005fc:	53                   	push   %ebx
  8005fd:	83 ec 10             	sub    $0x10,%esp
	int i ;
	*mean =0 ;
  800600:	8b 45 10             	mov    0x10(%ebp),%eax
  800603:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	for (i = 0 ; i < NumOfElements ; i++)
  800609:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800610:	eb 20                	jmp    800632 <ArrayStats+0x39>
	{
		*mean += Elements[i];
  800612:	8b 45 10             	mov    0x10(%ebp),%eax
  800615:	8b 10                	mov    (%eax),%edx
  800617:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80061a:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800621:	8b 45 08             	mov    0x8(%ebp),%eax
  800624:	01 c8                	add    %ecx,%eax
  800626:	8b 00                	mov    (%eax),%eax
  800628:	01 c2                	add    %eax,%edx
  80062a:	8b 45 10             	mov    0x10(%ebp),%eax
  80062d:	89 10                	mov    %edx,(%eax)

void ArrayStats(int *Elements, int NumOfElements, int *mean, int *var)
{
	int i ;
	*mean =0 ;
	for (i = 0 ; i < NumOfElements ; i++)
  80062f:	ff 45 f8             	incl   -0x8(%ebp)
  800632:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800635:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800638:	7c d8                	jl     800612 <ArrayStats+0x19>
	{
		*mean += Elements[i];
	}
	*mean /= NumOfElements;
  80063a:	8b 45 10             	mov    0x10(%ebp),%eax
  80063d:	8b 00                	mov    (%eax),%eax
  80063f:	99                   	cltd   
  800640:	f7 7d 0c             	idivl  0xc(%ebp)
  800643:	89 c2                	mov    %eax,%edx
  800645:	8b 45 10             	mov    0x10(%ebp),%eax
  800648:	89 10                	mov    %edx,(%eax)
	*var = 0;
  80064a:	8b 45 14             	mov    0x14(%ebp),%eax
  80064d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	for (i = 0 ; i < NumOfElements ; i++)
  800653:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80065a:	eb 46                	jmp    8006a2 <ArrayStats+0xa9>
	{
		*var += (Elements[i] - *mean)*(Elements[i] - *mean);
  80065c:	8b 45 14             	mov    0x14(%ebp),%eax
  80065f:	8b 10                	mov    (%eax),%edx
  800661:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800664:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80066b:	8b 45 08             	mov    0x8(%ebp),%eax
  80066e:	01 c8                	add    %ecx,%eax
  800670:	8b 08                	mov    (%eax),%ecx
  800672:	8b 45 10             	mov    0x10(%ebp),%eax
  800675:	8b 00                	mov    (%eax),%eax
  800677:	89 cb                	mov    %ecx,%ebx
  800679:	29 c3                	sub    %eax,%ebx
  80067b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80067e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800685:	8b 45 08             	mov    0x8(%ebp),%eax
  800688:	01 c8                	add    %ecx,%eax
  80068a:	8b 08                	mov    (%eax),%ecx
  80068c:	8b 45 10             	mov    0x10(%ebp),%eax
  80068f:	8b 00                	mov    (%eax),%eax
  800691:	29 c1                	sub    %eax,%ecx
  800693:	89 c8                	mov    %ecx,%eax
  800695:	0f af c3             	imul   %ebx,%eax
  800698:	01 c2                	add    %eax,%edx
  80069a:	8b 45 14             	mov    0x14(%ebp),%eax
  80069d:	89 10                	mov    %edx,(%eax)
	{
		*mean += Elements[i];
	}
	*mean /= NumOfElements;
	*var = 0;
	for (i = 0 ; i < NumOfElements ; i++)
  80069f:	ff 45 f8             	incl   -0x8(%ebp)
  8006a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8006a5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8006a8:	7c b2                	jl     80065c <ArrayStats+0x63>
	{
		*var += (Elements[i] - *mean)*(Elements[i] - *mean);
	}
	*var /= NumOfElements;
  8006aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ad:	8b 00                	mov    (%eax),%eax
  8006af:	99                   	cltd   
  8006b0:	f7 7d 0c             	idivl  0xc(%ebp)
  8006b3:	89 c2                	mov    %eax,%edx
  8006b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b8:	89 10                	mov    %edx,(%eax)
}
  8006ba:	90                   	nop
  8006bb:	83 c4 10             	add    $0x10,%esp
  8006be:	5b                   	pop    %ebx
  8006bf:	5d                   	pop    %ebp
  8006c0:	c3                   	ret    

008006c1 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8006c1:	55                   	push   %ebp
  8006c2:	89 e5                	mov    %esp,%ebp
  8006c4:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8006c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ca:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8006cd:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8006d1:	83 ec 0c             	sub    $0xc,%esp
  8006d4:	50                   	push   %eax
  8006d5:	e8 fb 19 00 00       	call   8020d5 <sys_cputc>
  8006da:	83 c4 10             	add    $0x10,%esp
}
  8006dd:	90                   	nop
  8006de:	c9                   	leave  
  8006df:	c3                   	ret    

008006e0 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  8006e0:	55                   	push   %ebp
  8006e1:	89 e5                	mov    %esp,%ebp
  8006e3:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8006e6:	e8 b6 19 00 00       	call   8020a1 <sys_disable_interrupt>
	char c = ch;
  8006eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ee:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8006f1:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8006f5:	83 ec 0c             	sub    $0xc,%esp
  8006f8:	50                   	push   %eax
  8006f9:	e8 d7 19 00 00       	call   8020d5 <sys_cputc>
  8006fe:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800701:	e8 b5 19 00 00       	call   8020bb <sys_enable_interrupt>
}
  800706:	90                   	nop
  800707:	c9                   	leave  
  800708:	c3                   	ret    

00800709 <getchar>:

int
getchar(void)
{
  800709:	55                   	push   %ebp
  80070a:	89 e5                	mov    %esp,%ebp
  80070c:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  80070f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800716:	eb 08                	jmp    800720 <getchar+0x17>
	{
		c = sys_cgetc();
  800718:	e8 ff 17 00 00       	call   801f1c <sys_cgetc>
  80071d:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  800720:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800724:	74 f2                	je     800718 <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  800726:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800729:	c9                   	leave  
  80072a:	c3                   	ret    

0080072b <atomic_getchar>:

int
atomic_getchar(void)
{
  80072b:	55                   	push   %ebp
  80072c:	89 e5                	mov    %esp,%ebp
  80072e:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800731:	e8 6b 19 00 00       	call   8020a1 <sys_disable_interrupt>
	int c=0;
  800736:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  80073d:	eb 08                	jmp    800747 <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  80073f:	e8 d8 17 00 00       	call   801f1c <sys_cgetc>
  800744:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  800747:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80074b:	74 f2                	je     80073f <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  80074d:	e8 69 19 00 00       	call   8020bb <sys_enable_interrupt>
	return c;
  800752:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800755:	c9                   	leave  
  800756:	c3                   	ret    

00800757 <iscons>:

int iscons(int fdnum)
{
  800757:	55                   	push   %ebp
  800758:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  80075a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80075f:	5d                   	pop    %ebp
  800760:	c3                   	ret    

00800761 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800761:	55                   	push   %ebp
  800762:	89 e5                	mov    %esp,%ebp
  800764:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800767:	e8 28 1b 00 00       	call   802294 <sys_getenvindex>
  80076c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80076f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800772:	89 d0                	mov    %edx,%eax
  800774:	c1 e0 03             	shl    $0x3,%eax
  800777:	01 d0                	add    %edx,%eax
  800779:	01 c0                	add    %eax,%eax
  80077b:	01 d0                	add    %edx,%eax
  80077d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800784:	01 d0                	add    %edx,%eax
  800786:	c1 e0 04             	shl    $0x4,%eax
  800789:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80078e:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800793:	a1 20 50 80 00       	mov    0x805020,%eax
  800798:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80079e:	84 c0                	test   %al,%al
  8007a0:	74 0f                	je     8007b1 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8007a2:	a1 20 50 80 00       	mov    0x805020,%eax
  8007a7:	05 5c 05 00 00       	add    $0x55c,%eax
  8007ac:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8007b1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8007b5:	7e 0a                	jle    8007c1 <libmain+0x60>
		binaryname = argv[0];
  8007b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007ba:	8b 00                	mov    (%eax),%eax
  8007bc:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8007c1:	83 ec 08             	sub    $0x8,%esp
  8007c4:	ff 75 0c             	pushl  0xc(%ebp)
  8007c7:	ff 75 08             	pushl  0x8(%ebp)
  8007ca:	e8 69 f8 ff ff       	call   800038 <_main>
  8007cf:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8007d2:	e8 ca 18 00 00       	call   8020a1 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8007d7:	83 ec 0c             	sub    $0xc,%esp
  8007da:	68 34 40 80 00       	push   $0x804034
  8007df:	e8 6d 03 00 00       	call   800b51 <cprintf>
  8007e4:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8007e7:	a1 20 50 80 00       	mov    0x805020,%eax
  8007ec:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8007f2:	a1 20 50 80 00       	mov    0x805020,%eax
  8007f7:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8007fd:	83 ec 04             	sub    $0x4,%esp
  800800:	52                   	push   %edx
  800801:	50                   	push   %eax
  800802:	68 5c 40 80 00       	push   $0x80405c
  800807:	e8 45 03 00 00       	call   800b51 <cprintf>
  80080c:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80080f:	a1 20 50 80 00       	mov    0x805020,%eax
  800814:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80081a:	a1 20 50 80 00       	mov    0x805020,%eax
  80081f:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800825:	a1 20 50 80 00       	mov    0x805020,%eax
  80082a:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800830:	51                   	push   %ecx
  800831:	52                   	push   %edx
  800832:	50                   	push   %eax
  800833:	68 84 40 80 00       	push   $0x804084
  800838:	e8 14 03 00 00       	call   800b51 <cprintf>
  80083d:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800840:	a1 20 50 80 00       	mov    0x805020,%eax
  800845:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80084b:	83 ec 08             	sub    $0x8,%esp
  80084e:	50                   	push   %eax
  80084f:	68 dc 40 80 00       	push   $0x8040dc
  800854:	e8 f8 02 00 00       	call   800b51 <cprintf>
  800859:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80085c:	83 ec 0c             	sub    $0xc,%esp
  80085f:	68 34 40 80 00       	push   $0x804034
  800864:	e8 e8 02 00 00       	call   800b51 <cprintf>
  800869:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80086c:	e8 4a 18 00 00       	call   8020bb <sys_enable_interrupt>

	// exit gracefully
	exit();
  800871:	e8 19 00 00 00       	call   80088f <exit>
}
  800876:	90                   	nop
  800877:	c9                   	leave  
  800878:	c3                   	ret    

00800879 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800879:	55                   	push   %ebp
  80087a:	89 e5                	mov    %esp,%ebp
  80087c:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80087f:	83 ec 0c             	sub    $0xc,%esp
  800882:	6a 00                	push   $0x0
  800884:	e8 d7 19 00 00       	call   802260 <sys_destroy_env>
  800889:	83 c4 10             	add    $0x10,%esp
}
  80088c:	90                   	nop
  80088d:	c9                   	leave  
  80088e:	c3                   	ret    

0080088f <exit>:

void
exit(void)
{
  80088f:	55                   	push   %ebp
  800890:	89 e5                	mov    %esp,%ebp
  800892:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800895:	e8 2c 1a 00 00       	call   8022c6 <sys_exit_env>
}
  80089a:	90                   	nop
  80089b:	c9                   	leave  
  80089c:	c3                   	ret    

0080089d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80089d:	55                   	push   %ebp
  80089e:	89 e5                	mov    %esp,%ebp
  8008a0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8008a3:	8d 45 10             	lea    0x10(%ebp),%eax
  8008a6:	83 c0 04             	add    $0x4,%eax
  8008a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8008ac:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8008b1:	85 c0                	test   %eax,%eax
  8008b3:	74 16                	je     8008cb <_panic+0x2e>
		cprintf("%s: ", argv0);
  8008b5:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8008ba:	83 ec 08             	sub    $0x8,%esp
  8008bd:	50                   	push   %eax
  8008be:	68 f0 40 80 00       	push   $0x8040f0
  8008c3:	e8 89 02 00 00       	call   800b51 <cprintf>
  8008c8:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8008cb:	a1 00 50 80 00       	mov    0x805000,%eax
  8008d0:	ff 75 0c             	pushl  0xc(%ebp)
  8008d3:	ff 75 08             	pushl  0x8(%ebp)
  8008d6:	50                   	push   %eax
  8008d7:	68 f5 40 80 00       	push   $0x8040f5
  8008dc:	e8 70 02 00 00       	call   800b51 <cprintf>
  8008e1:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8008e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8008e7:	83 ec 08             	sub    $0x8,%esp
  8008ea:	ff 75 f4             	pushl  -0xc(%ebp)
  8008ed:	50                   	push   %eax
  8008ee:	e8 f3 01 00 00       	call   800ae6 <vcprintf>
  8008f3:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8008f6:	83 ec 08             	sub    $0x8,%esp
  8008f9:	6a 00                	push   $0x0
  8008fb:	68 11 41 80 00       	push   $0x804111
  800900:	e8 e1 01 00 00       	call   800ae6 <vcprintf>
  800905:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800908:	e8 82 ff ff ff       	call   80088f <exit>

	// should not return here
	while (1) ;
  80090d:	eb fe                	jmp    80090d <_panic+0x70>

0080090f <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80090f:	55                   	push   %ebp
  800910:	89 e5                	mov    %esp,%ebp
  800912:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800915:	a1 20 50 80 00       	mov    0x805020,%eax
  80091a:	8b 50 74             	mov    0x74(%eax),%edx
  80091d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800920:	39 c2                	cmp    %eax,%edx
  800922:	74 14                	je     800938 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800924:	83 ec 04             	sub    $0x4,%esp
  800927:	68 14 41 80 00       	push   $0x804114
  80092c:	6a 26                	push   $0x26
  80092e:	68 60 41 80 00       	push   $0x804160
  800933:	e8 65 ff ff ff       	call   80089d <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800938:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80093f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800946:	e9 c2 00 00 00       	jmp    800a0d <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80094b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80094e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800955:	8b 45 08             	mov    0x8(%ebp),%eax
  800958:	01 d0                	add    %edx,%eax
  80095a:	8b 00                	mov    (%eax),%eax
  80095c:	85 c0                	test   %eax,%eax
  80095e:	75 08                	jne    800968 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800960:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800963:	e9 a2 00 00 00       	jmp    800a0a <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800968:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80096f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800976:	eb 69                	jmp    8009e1 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800978:	a1 20 50 80 00       	mov    0x805020,%eax
  80097d:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800983:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800986:	89 d0                	mov    %edx,%eax
  800988:	01 c0                	add    %eax,%eax
  80098a:	01 d0                	add    %edx,%eax
  80098c:	c1 e0 03             	shl    $0x3,%eax
  80098f:	01 c8                	add    %ecx,%eax
  800991:	8a 40 04             	mov    0x4(%eax),%al
  800994:	84 c0                	test   %al,%al
  800996:	75 46                	jne    8009de <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800998:	a1 20 50 80 00       	mov    0x805020,%eax
  80099d:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8009a3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009a6:	89 d0                	mov    %edx,%eax
  8009a8:	01 c0                	add    %eax,%eax
  8009aa:	01 d0                	add    %edx,%eax
  8009ac:	c1 e0 03             	shl    $0x3,%eax
  8009af:	01 c8                	add    %ecx,%eax
  8009b1:	8b 00                	mov    (%eax),%eax
  8009b3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8009b6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8009b9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8009be:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8009c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009c3:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8009ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cd:	01 c8                	add    %ecx,%eax
  8009cf:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8009d1:	39 c2                	cmp    %eax,%edx
  8009d3:	75 09                	jne    8009de <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8009d5:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8009dc:	eb 12                	jmp    8009f0 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009de:	ff 45 e8             	incl   -0x18(%ebp)
  8009e1:	a1 20 50 80 00       	mov    0x805020,%eax
  8009e6:	8b 50 74             	mov    0x74(%eax),%edx
  8009e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8009ec:	39 c2                	cmp    %eax,%edx
  8009ee:	77 88                	ja     800978 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8009f0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8009f4:	75 14                	jne    800a0a <CheckWSWithoutLastIndex+0xfb>
			panic(
  8009f6:	83 ec 04             	sub    $0x4,%esp
  8009f9:	68 6c 41 80 00       	push   $0x80416c
  8009fe:	6a 3a                	push   $0x3a
  800a00:	68 60 41 80 00       	push   $0x804160
  800a05:	e8 93 fe ff ff       	call   80089d <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800a0a:	ff 45 f0             	incl   -0x10(%ebp)
  800a0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a10:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800a13:	0f 8c 32 ff ff ff    	jl     80094b <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800a19:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a20:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800a27:	eb 26                	jmp    800a4f <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800a29:	a1 20 50 80 00       	mov    0x805020,%eax
  800a2e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800a34:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a37:	89 d0                	mov    %edx,%eax
  800a39:	01 c0                	add    %eax,%eax
  800a3b:	01 d0                	add    %edx,%eax
  800a3d:	c1 e0 03             	shl    $0x3,%eax
  800a40:	01 c8                	add    %ecx,%eax
  800a42:	8a 40 04             	mov    0x4(%eax),%al
  800a45:	3c 01                	cmp    $0x1,%al
  800a47:	75 03                	jne    800a4c <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800a49:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a4c:	ff 45 e0             	incl   -0x20(%ebp)
  800a4f:	a1 20 50 80 00       	mov    0x805020,%eax
  800a54:	8b 50 74             	mov    0x74(%eax),%edx
  800a57:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a5a:	39 c2                	cmp    %eax,%edx
  800a5c:	77 cb                	ja     800a29 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800a5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a61:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800a64:	74 14                	je     800a7a <CheckWSWithoutLastIndex+0x16b>
		panic(
  800a66:	83 ec 04             	sub    $0x4,%esp
  800a69:	68 c0 41 80 00       	push   $0x8041c0
  800a6e:	6a 44                	push   $0x44
  800a70:	68 60 41 80 00       	push   $0x804160
  800a75:	e8 23 fe ff ff       	call   80089d <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800a7a:	90                   	nop
  800a7b:	c9                   	leave  
  800a7c:	c3                   	ret    

00800a7d <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800a7d:	55                   	push   %ebp
  800a7e:	89 e5                	mov    %esp,%ebp
  800a80:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800a83:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a86:	8b 00                	mov    (%eax),%eax
  800a88:	8d 48 01             	lea    0x1(%eax),%ecx
  800a8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a8e:	89 0a                	mov    %ecx,(%edx)
  800a90:	8b 55 08             	mov    0x8(%ebp),%edx
  800a93:	88 d1                	mov    %dl,%cl
  800a95:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a98:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800a9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a9f:	8b 00                	mov    (%eax),%eax
  800aa1:	3d ff 00 00 00       	cmp    $0xff,%eax
  800aa6:	75 2c                	jne    800ad4 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800aa8:	a0 24 50 80 00       	mov    0x805024,%al
  800aad:	0f b6 c0             	movzbl %al,%eax
  800ab0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ab3:	8b 12                	mov    (%edx),%edx
  800ab5:	89 d1                	mov    %edx,%ecx
  800ab7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aba:	83 c2 08             	add    $0x8,%edx
  800abd:	83 ec 04             	sub    $0x4,%esp
  800ac0:	50                   	push   %eax
  800ac1:	51                   	push   %ecx
  800ac2:	52                   	push   %edx
  800ac3:	e8 2b 14 00 00       	call   801ef3 <sys_cputs>
  800ac8:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800acb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ace:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800ad4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ad7:	8b 40 04             	mov    0x4(%eax),%eax
  800ada:	8d 50 01             	lea    0x1(%eax),%edx
  800add:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ae0:	89 50 04             	mov    %edx,0x4(%eax)
}
  800ae3:	90                   	nop
  800ae4:	c9                   	leave  
  800ae5:	c3                   	ret    

00800ae6 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800ae6:	55                   	push   %ebp
  800ae7:	89 e5                	mov    %esp,%ebp
  800ae9:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800aef:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800af6:	00 00 00 
	b.cnt = 0;
  800af9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800b00:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800b03:	ff 75 0c             	pushl  0xc(%ebp)
  800b06:	ff 75 08             	pushl  0x8(%ebp)
  800b09:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b0f:	50                   	push   %eax
  800b10:	68 7d 0a 80 00       	push   $0x800a7d
  800b15:	e8 11 02 00 00       	call   800d2b <vprintfmt>
  800b1a:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800b1d:	a0 24 50 80 00       	mov    0x805024,%al
  800b22:	0f b6 c0             	movzbl %al,%eax
  800b25:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800b2b:	83 ec 04             	sub    $0x4,%esp
  800b2e:	50                   	push   %eax
  800b2f:	52                   	push   %edx
  800b30:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b36:	83 c0 08             	add    $0x8,%eax
  800b39:	50                   	push   %eax
  800b3a:	e8 b4 13 00 00       	call   801ef3 <sys_cputs>
  800b3f:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800b42:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  800b49:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800b4f:	c9                   	leave  
  800b50:	c3                   	ret    

00800b51 <cprintf>:

int cprintf(const char *fmt, ...) {
  800b51:	55                   	push   %ebp
  800b52:	89 e5                	mov    %esp,%ebp
  800b54:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800b57:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800b5e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b61:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800b64:	8b 45 08             	mov    0x8(%ebp),%eax
  800b67:	83 ec 08             	sub    $0x8,%esp
  800b6a:	ff 75 f4             	pushl  -0xc(%ebp)
  800b6d:	50                   	push   %eax
  800b6e:	e8 73 ff ff ff       	call   800ae6 <vcprintf>
  800b73:	83 c4 10             	add    $0x10,%esp
  800b76:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800b79:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b7c:	c9                   	leave  
  800b7d:	c3                   	ret    

00800b7e <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800b7e:	55                   	push   %ebp
  800b7f:	89 e5                	mov    %esp,%ebp
  800b81:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800b84:	e8 18 15 00 00       	call   8020a1 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800b89:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b92:	83 ec 08             	sub    $0x8,%esp
  800b95:	ff 75 f4             	pushl  -0xc(%ebp)
  800b98:	50                   	push   %eax
  800b99:	e8 48 ff ff ff       	call   800ae6 <vcprintf>
  800b9e:	83 c4 10             	add    $0x10,%esp
  800ba1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800ba4:	e8 12 15 00 00       	call   8020bb <sys_enable_interrupt>
	return cnt;
  800ba9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bac:	c9                   	leave  
  800bad:	c3                   	ret    

00800bae <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800bae:	55                   	push   %ebp
  800baf:	89 e5                	mov    %esp,%ebp
  800bb1:	53                   	push   %ebx
  800bb2:	83 ec 14             	sub    $0x14,%esp
  800bb5:	8b 45 10             	mov    0x10(%ebp),%eax
  800bb8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bbb:	8b 45 14             	mov    0x14(%ebp),%eax
  800bbe:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800bc1:	8b 45 18             	mov    0x18(%ebp),%eax
  800bc4:	ba 00 00 00 00       	mov    $0x0,%edx
  800bc9:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800bcc:	77 55                	ja     800c23 <printnum+0x75>
  800bce:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800bd1:	72 05                	jb     800bd8 <printnum+0x2a>
  800bd3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800bd6:	77 4b                	ja     800c23 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800bd8:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800bdb:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800bde:	8b 45 18             	mov    0x18(%ebp),%eax
  800be1:	ba 00 00 00 00       	mov    $0x0,%edx
  800be6:	52                   	push   %edx
  800be7:	50                   	push   %eax
  800be8:	ff 75 f4             	pushl  -0xc(%ebp)
  800beb:	ff 75 f0             	pushl  -0x10(%ebp)
  800bee:	e8 85 2f 00 00       	call   803b78 <__udivdi3>
  800bf3:	83 c4 10             	add    $0x10,%esp
  800bf6:	83 ec 04             	sub    $0x4,%esp
  800bf9:	ff 75 20             	pushl  0x20(%ebp)
  800bfc:	53                   	push   %ebx
  800bfd:	ff 75 18             	pushl  0x18(%ebp)
  800c00:	52                   	push   %edx
  800c01:	50                   	push   %eax
  800c02:	ff 75 0c             	pushl  0xc(%ebp)
  800c05:	ff 75 08             	pushl  0x8(%ebp)
  800c08:	e8 a1 ff ff ff       	call   800bae <printnum>
  800c0d:	83 c4 20             	add    $0x20,%esp
  800c10:	eb 1a                	jmp    800c2c <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800c12:	83 ec 08             	sub    $0x8,%esp
  800c15:	ff 75 0c             	pushl  0xc(%ebp)
  800c18:	ff 75 20             	pushl  0x20(%ebp)
  800c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1e:	ff d0                	call   *%eax
  800c20:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c23:	ff 4d 1c             	decl   0x1c(%ebp)
  800c26:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800c2a:	7f e6                	jg     800c12 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800c2c:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800c2f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c37:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c3a:	53                   	push   %ebx
  800c3b:	51                   	push   %ecx
  800c3c:	52                   	push   %edx
  800c3d:	50                   	push   %eax
  800c3e:	e8 45 30 00 00       	call   803c88 <__umoddi3>
  800c43:	83 c4 10             	add    $0x10,%esp
  800c46:	05 34 44 80 00       	add    $0x804434,%eax
  800c4b:	8a 00                	mov    (%eax),%al
  800c4d:	0f be c0             	movsbl %al,%eax
  800c50:	83 ec 08             	sub    $0x8,%esp
  800c53:	ff 75 0c             	pushl  0xc(%ebp)
  800c56:	50                   	push   %eax
  800c57:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5a:	ff d0                	call   *%eax
  800c5c:	83 c4 10             	add    $0x10,%esp
}
  800c5f:	90                   	nop
  800c60:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c63:	c9                   	leave  
  800c64:	c3                   	ret    

00800c65 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800c65:	55                   	push   %ebp
  800c66:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c68:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800c6c:	7e 1c                	jle    800c8a <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c71:	8b 00                	mov    (%eax),%eax
  800c73:	8d 50 08             	lea    0x8(%eax),%edx
  800c76:	8b 45 08             	mov    0x8(%ebp),%eax
  800c79:	89 10                	mov    %edx,(%eax)
  800c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7e:	8b 00                	mov    (%eax),%eax
  800c80:	83 e8 08             	sub    $0x8,%eax
  800c83:	8b 50 04             	mov    0x4(%eax),%edx
  800c86:	8b 00                	mov    (%eax),%eax
  800c88:	eb 40                	jmp    800cca <getuint+0x65>
	else if (lflag)
  800c8a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c8e:	74 1e                	je     800cae <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800c90:	8b 45 08             	mov    0x8(%ebp),%eax
  800c93:	8b 00                	mov    (%eax),%eax
  800c95:	8d 50 04             	lea    0x4(%eax),%edx
  800c98:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9b:	89 10                	mov    %edx,(%eax)
  800c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca0:	8b 00                	mov    (%eax),%eax
  800ca2:	83 e8 04             	sub    $0x4,%eax
  800ca5:	8b 00                	mov    (%eax),%eax
  800ca7:	ba 00 00 00 00       	mov    $0x0,%edx
  800cac:	eb 1c                	jmp    800cca <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800cae:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb1:	8b 00                	mov    (%eax),%eax
  800cb3:	8d 50 04             	lea    0x4(%eax),%edx
  800cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb9:	89 10                	mov    %edx,(%eax)
  800cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbe:	8b 00                	mov    (%eax),%eax
  800cc0:	83 e8 04             	sub    $0x4,%eax
  800cc3:	8b 00                	mov    (%eax),%eax
  800cc5:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800cca:	5d                   	pop    %ebp
  800ccb:	c3                   	ret    

00800ccc <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800ccc:	55                   	push   %ebp
  800ccd:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800ccf:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800cd3:	7e 1c                	jle    800cf1 <getint+0x25>
		return va_arg(*ap, long long);
  800cd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd8:	8b 00                	mov    (%eax),%eax
  800cda:	8d 50 08             	lea    0x8(%eax),%edx
  800cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce0:	89 10                	mov    %edx,(%eax)
  800ce2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce5:	8b 00                	mov    (%eax),%eax
  800ce7:	83 e8 08             	sub    $0x8,%eax
  800cea:	8b 50 04             	mov    0x4(%eax),%edx
  800ced:	8b 00                	mov    (%eax),%eax
  800cef:	eb 38                	jmp    800d29 <getint+0x5d>
	else if (lflag)
  800cf1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cf5:	74 1a                	je     800d11 <getint+0x45>
		return va_arg(*ap, long);
  800cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfa:	8b 00                	mov    (%eax),%eax
  800cfc:	8d 50 04             	lea    0x4(%eax),%edx
  800cff:	8b 45 08             	mov    0x8(%ebp),%eax
  800d02:	89 10                	mov    %edx,(%eax)
  800d04:	8b 45 08             	mov    0x8(%ebp),%eax
  800d07:	8b 00                	mov    (%eax),%eax
  800d09:	83 e8 04             	sub    $0x4,%eax
  800d0c:	8b 00                	mov    (%eax),%eax
  800d0e:	99                   	cltd   
  800d0f:	eb 18                	jmp    800d29 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800d11:	8b 45 08             	mov    0x8(%ebp),%eax
  800d14:	8b 00                	mov    (%eax),%eax
  800d16:	8d 50 04             	lea    0x4(%eax),%edx
  800d19:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1c:	89 10                	mov    %edx,(%eax)
  800d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d21:	8b 00                	mov    (%eax),%eax
  800d23:	83 e8 04             	sub    $0x4,%eax
  800d26:	8b 00                	mov    (%eax),%eax
  800d28:	99                   	cltd   
}
  800d29:	5d                   	pop    %ebp
  800d2a:	c3                   	ret    

00800d2b <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800d2b:	55                   	push   %ebp
  800d2c:	89 e5                	mov    %esp,%ebp
  800d2e:	56                   	push   %esi
  800d2f:	53                   	push   %ebx
  800d30:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d33:	eb 17                	jmp    800d4c <vprintfmt+0x21>
			if (ch == '\0')
  800d35:	85 db                	test   %ebx,%ebx
  800d37:	0f 84 af 03 00 00    	je     8010ec <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800d3d:	83 ec 08             	sub    $0x8,%esp
  800d40:	ff 75 0c             	pushl  0xc(%ebp)
  800d43:	53                   	push   %ebx
  800d44:	8b 45 08             	mov    0x8(%ebp),%eax
  800d47:	ff d0                	call   *%eax
  800d49:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d4c:	8b 45 10             	mov    0x10(%ebp),%eax
  800d4f:	8d 50 01             	lea    0x1(%eax),%edx
  800d52:	89 55 10             	mov    %edx,0x10(%ebp)
  800d55:	8a 00                	mov    (%eax),%al
  800d57:	0f b6 d8             	movzbl %al,%ebx
  800d5a:	83 fb 25             	cmp    $0x25,%ebx
  800d5d:	75 d6                	jne    800d35 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800d5f:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800d63:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800d6a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800d71:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800d78:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800d7f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d82:	8d 50 01             	lea    0x1(%eax),%edx
  800d85:	89 55 10             	mov    %edx,0x10(%ebp)
  800d88:	8a 00                	mov    (%eax),%al
  800d8a:	0f b6 d8             	movzbl %al,%ebx
  800d8d:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800d90:	83 f8 55             	cmp    $0x55,%eax
  800d93:	0f 87 2b 03 00 00    	ja     8010c4 <vprintfmt+0x399>
  800d99:	8b 04 85 58 44 80 00 	mov    0x804458(,%eax,4),%eax
  800da0:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800da2:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800da6:	eb d7                	jmp    800d7f <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800da8:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800dac:	eb d1                	jmp    800d7f <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800dae:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800db5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800db8:	89 d0                	mov    %edx,%eax
  800dba:	c1 e0 02             	shl    $0x2,%eax
  800dbd:	01 d0                	add    %edx,%eax
  800dbf:	01 c0                	add    %eax,%eax
  800dc1:	01 d8                	add    %ebx,%eax
  800dc3:	83 e8 30             	sub    $0x30,%eax
  800dc6:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800dc9:	8b 45 10             	mov    0x10(%ebp),%eax
  800dcc:	8a 00                	mov    (%eax),%al
  800dce:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800dd1:	83 fb 2f             	cmp    $0x2f,%ebx
  800dd4:	7e 3e                	jle    800e14 <vprintfmt+0xe9>
  800dd6:	83 fb 39             	cmp    $0x39,%ebx
  800dd9:	7f 39                	jg     800e14 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ddb:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800dde:	eb d5                	jmp    800db5 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800de0:	8b 45 14             	mov    0x14(%ebp),%eax
  800de3:	83 c0 04             	add    $0x4,%eax
  800de6:	89 45 14             	mov    %eax,0x14(%ebp)
  800de9:	8b 45 14             	mov    0x14(%ebp),%eax
  800dec:	83 e8 04             	sub    $0x4,%eax
  800def:	8b 00                	mov    (%eax),%eax
  800df1:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800df4:	eb 1f                	jmp    800e15 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800df6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dfa:	79 83                	jns    800d7f <vprintfmt+0x54>
				width = 0;
  800dfc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800e03:	e9 77 ff ff ff       	jmp    800d7f <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800e08:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800e0f:	e9 6b ff ff ff       	jmp    800d7f <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800e14:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800e15:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e19:	0f 89 60 ff ff ff    	jns    800d7f <vprintfmt+0x54>
				width = precision, precision = -1;
  800e1f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e22:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800e25:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800e2c:	e9 4e ff ff ff       	jmp    800d7f <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800e31:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800e34:	e9 46 ff ff ff       	jmp    800d7f <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800e39:	8b 45 14             	mov    0x14(%ebp),%eax
  800e3c:	83 c0 04             	add    $0x4,%eax
  800e3f:	89 45 14             	mov    %eax,0x14(%ebp)
  800e42:	8b 45 14             	mov    0x14(%ebp),%eax
  800e45:	83 e8 04             	sub    $0x4,%eax
  800e48:	8b 00                	mov    (%eax),%eax
  800e4a:	83 ec 08             	sub    $0x8,%esp
  800e4d:	ff 75 0c             	pushl  0xc(%ebp)
  800e50:	50                   	push   %eax
  800e51:	8b 45 08             	mov    0x8(%ebp),%eax
  800e54:	ff d0                	call   *%eax
  800e56:	83 c4 10             	add    $0x10,%esp
			break;
  800e59:	e9 89 02 00 00       	jmp    8010e7 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800e5e:	8b 45 14             	mov    0x14(%ebp),%eax
  800e61:	83 c0 04             	add    $0x4,%eax
  800e64:	89 45 14             	mov    %eax,0x14(%ebp)
  800e67:	8b 45 14             	mov    0x14(%ebp),%eax
  800e6a:	83 e8 04             	sub    $0x4,%eax
  800e6d:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800e6f:	85 db                	test   %ebx,%ebx
  800e71:	79 02                	jns    800e75 <vprintfmt+0x14a>
				err = -err;
  800e73:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800e75:	83 fb 64             	cmp    $0x64,%ebx
  800e78:	7f 0b                	jg     800e85 <vprintfmt+0x15a>
  800e7a:	8b 34 9d a0 42 80 00 	mov    0x8042a0(,%ebx,4),%esi
  800e81:	85 f6                	test   %esi,%esi
  800e83:	75 19                	jne    800e9e <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800e85:	53                   	push   %ebx
  800e86:	68 45 44 80 00       	push   $0x804445
  800e8b:	ff 75 0c             	pushl  0xc(%ebp)
  800e8e:	ff 75 08             	pushl  0x8(%ebp)
  800e91:	e8 5e 02 00 00       	call   8010f4 <printfmt>
  800e96:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800e99:	e9 49 02 00 00       	jmp    8010e7 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800e9e:	56                   	push   %esi
  800e9f:	68 4e 44 80 00       	push   $0x80444e
  800ea4:	ff 75 0c             	pushl  0xc(%ebp)
  800ea7:	ff 75 08             	pushl  0x8(%ebp)
  800eaa:	e8 45 02 00 00       	call   8010f4 <printfmt>
  800eaf:	83 c4 10             	add    $0x10,%esp
			break;
  800eb2:	e9 30 02 00 00       	jmp    8010e7 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800eb7:	8b 45 14             	mov    0x14(%ebp),%eax
  800eba:	83 c0 04             	add    $0x4,%eax
  800ebd:	89 45 14             	mov    %eax,0x14(%ebp)
  800ec0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ec3:	83 e8 04             	sub    $0x4,%eax
  800ec6:	8b 30                	mov    (%eax),%esi
  800ec8:	85 f6                	test   %esi,%esi
  800eca:	75 05                	jne    800ed1 <vprintfmt+0x1a6>
				p = "(null)";
  800ecc:	be 51 44 80 00       	mov    $0x804451,%esi
			if (width > 0 && padc != '-')
  800ed1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ed5:	7e 6d                	jle    800f44 <vprintfmt+0x219>
  800ed7:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800edb:	74 67                	je     800f44 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800edd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ee0:	83 ec 08             	sub    $0x8,%esp
  800ee3:	50                   	push   %eax
  800ee4:	56                   	push   %esi
  800ee5:	e8 12 05 00 00       	call   8013fc <strnlen>
  800eea:	83 c4 10             	add    $0x10,%esp
  800eed:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800ef0:	eb 16                	jmp    800f08 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800ef2:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800ef6:	83 ec 08             	sub    $0x8,%esp
  800ef9:	ff 75 0c             	pushl  0xc(%ebp)
  800efc:	50                   	push   %eax
  800efd:	8b 45 08             	mov    0x8(%ebp),%eax
  800f00:	ff d0                	call   *%eax
  800f02:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800f05:	ff 4d e4             	decl   -0x1c(%ebp)
  800f08:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f0c:	7f e4                	jg     800ef2 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f0e:	eb 34                	jmp    800f44 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800f10:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800f14:	74 1c                	je     800f32 <vprintfmt+0x207>
  800f16:	83 fb 1f             	cmp    $0x1f,%ebx
  800f19:	7e 05                	jle    800f20 <vprintfmt+0x1f5>
  800f1b:	83 fb 7e             	cmp    $0x7e,%ebx
  800f1e:	7e 12                	jle    800f32 <vprintfmt+0x207>
					putch('?', putdat);
  800f20:	83 ec 08             	sub    $0x8,%esp
  800f23:	ff 75 0c             	pushl  0xc(%ebp)
  800f26:	6a 3f                	push   $0x3f
  800f28:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2b:	ff d0                	call   *%eax
  800f2d:	83 c4 10             	add    $0x10,%esp
  800f30:	eb 0f                	jmp    800f41 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800f32:	83 ec 08             	sub    $0x8,%esp
  800f35:	ff 75 0c             	pushl  0xc(%ebp)
  800f38:	53                   	push   %ebx
  800f39:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3c:	ff d0                	call   *%eax
  800f3e:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f41:	ff 4d e4             	decl   -0x1c(%ebp)
  800f44:	89 f0                	mov    %esi,%eax
  800f46:	8d 70 01             	lea    0x1(%eax),%esi
  800f49:	8a 00                	mov    (%eax),%al
  800f4b:	0f be d8             	movsbl %al,%ebx
  800f4e:	85 db                	test   %ebx,%ebx
  800f50:	74 24                	je     800f76 <vprintfmt+0x24b>
  800f52:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f56:	78 b8                	js     800f10 <vprintfmt+0x1e5>
  800f58:	ff 4d e0             	decl   -0x20(%ebp)
  800f5b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f5f:	79 af                	jns    800f10 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f61:	eb 13                	jmp    800f76 <vprintfmt+0x24b>
				putch(' ', putdat);
  800f63:	83 ec 08             	sub    $0x8,%esp
  800f66:	ff 75 0c             	pushl  0xc(%ebp)
  800f69:	6a 20                	push   $0x20
  800f6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6e:	ff d0                	call   *%eax
  800f70:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f73:	ff 4d e4             	decl   -0x1c(%ebp)
  800f76:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f7a:	7f e7                	jg     800f63 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800f7c:	e9 66 01 00 00       	jmp    8010e7 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800f81:	83 ec 08             	sub    $0x8,%esp
  800f84:	ff 75 e8             	pushl  -0x18(%ebp)
  800f87:	8d 45 14             	lea    0x14(%ebp),%eax
  800f8a:	50                   	push   %eax
  800f8b:	e8 3c fd ff ff       	call   800ccc <getint>
  800f90:	83 c4 10             	add    $0x10,%esp
  800f93:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f96:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800f99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f9c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f9f:	85 d2                	test   %edx,%edx
  800fa1:	79 23                	jns    800fc6 <vprintfmt+0x29b>
				putch('-', putdat);
  800fa3:	83 ec 08             	sub    $0x8,%esp
  800fa6:	ff 75 0c             	pushl  0xc(%ebp)
  800fa9:	6a 2d                	push   $0x2d
  800fab:	8b 45 08             	mov    0x8(%ebp),%eax
  800fae:	ff d0                	call   *%eax
  800fb0:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800fb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fb6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fb9:	f7 d8                	neg    %eax
  800fbb:	83 d2 00             	adc    $0x0,%edx
  800fbe:	f7 da                	neg    %edx
  800fc0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fc3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800fc6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800fcd:	e9 bc 00 00 00       	jmp    80108e <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800fd2:	83 ec 08             	sub    $0x8,%esp
  800fd5:	ff 75 e8             	pushl  -0x18(%ebp)
  800fd8:	8d 45 14             	lea    0x14(%ebp),%eax
  800fdb:	50                   	push   %eax
  800fdc:	e8 84 fc ff ff       	call   800c65 <getuint>
  800fe1:	83 c4 10             	add    $0x10,%esp
  800fe4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fe7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800fea:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ff1:	e9 98 00 00 00       	jmp    80108e <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ff6:	83 ec 08             	sub    $0x8,%esp
  800ff9:	ff 75 0c             	pushl  0xc(%ebp)
  800ffc:	6a 58                	push   $0x58
  800ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  801001:	ff d0                	call   *%eax
  801003:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801006:	83 ec 08             	sub    $0x8,%esp
  801009:	ff 75 0c             	pushl  0xc(%ebp)
  80100c:	6a 58                	push   $0x58
  80100e:	8b 45 08             	mov    0x8(%ebp),%eax
  801011:	ff d0                	call   *%eax
  801013:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801016:	83 ec 08             	sub    $0x8,%esp
  801019:	ff 75 0c             	pushl  0xc(%ebp)
  80101c:	6a 58                	push   $0x58
  80101e:	8b 45 08             	mov    0x8(%ebp),%eax
  801021:	ff d0                	call   *%eax
  801023:	83 c4 10             	add    $0x10,%esp
			break;
  801026:	e9 bc 00 00 00       	jmp    8010e7 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  80102b:	83 ec 08             	sub    $0x8,%esp
  80102e:	ff 75 0c             	pushl  0xc(%ebp)
  801031:	6a 30                	push   $0x30
  801033:	8b 45 08             	mov    0x8(%ebp),%eax
  801036:	ff d0                	call   *%eax
  801038:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80103b:	83 ec 08             	sub    $0x8,%esp
  80103e:	ff 75 0c             	pushl  0xc(%ebp)
  801041:	6a 78                	push   $0x78
  801043:	8b 45 08             	mov    0x8(%ebp),%eax
  801046:	ff d0                	call   *%eax
  801048:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80104b:	8b 45 14             	mov    0x14(%ebp),%eax
  80104e:	83 c0 04             	add    $0x4,%eax
  801051:	89 45 14             	mov    %eax,0x14(%ebp)
  801054:	8b 45 14             	mov    0x14(%ebp),%eax
  801057:	83 e8 04             	sub    $0x4,%eax
  80105a:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80105c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80105f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801066:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80106d:	eb 1f                	jmp    80108e <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80106f:	83 ec 08             	sub    $0x8,%esp
  801072:	ff 75 e8             	pushl  -0x18(%ebp)
  801075:	8d 45 14             	lea    0x14(%ebp),%eax
  801078:	50                   	push   %eax
  801079:	e8 e7 fb ff ff       	call   800c65 <getuint>
  80107e:	83 c4 10             	add    $0x10,%esp
  801081:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801084:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801087:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80108e:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801092:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801095:	83 ec 04             	sub    $0x4,%esp
  801098:	52                   	push   %edx
  801099:	ff 75 e4             	pushl  -0x1c(%ebp)
  80109c:	50                   	push   %eax
  80109d:	ff 75 f4             	pushl  -0xc(%ebp)
  8010a0:	ff 75 f0             	pushl  -0x10(%ebp)
  8010a3:	ff 75 0c             	pushl  0xc(%ebp)
  8010a6:	ff 75 08             	pushl  0x8(%ebp)
  8010a9:	e8 00 fb ff ff       	call   800bae <printnum>
  8010ae:	83 c4 20             	add    $0x20,%esp
			break;
  8010b1:	eb 34                	jmp    8010e7 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8010b3:	83 ec 08             	sub    $0x8,%esp
  8010b6:	ff 75 0c             	pushl  0xc(%ebp)
  8010b9:	53                   	push   %ebx
  8010ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bd:	ff d0                	call   *%eax
  8010bf:	83 c4 10             	add    $0x10,%esp
			break;
  8010c2:	eb 23                	jmp    8010e7 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8010c4:	83 ec 08             	sub    $0x8,%esp
  8010c7:	ff 75 0c             	pushl  0xc(%ebp)
  8010ca:	6a 25                	push   $0x25
  8010cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cf:	ff d0                	call   *%eax
  8010d1:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8010d4:	ff 4d 10             	decl   0x10(%ebp)
  8010d7:	eb 03                	jmp    8010dc <vprintfmt+0x3b1>
  8010d9:	ff 4d 10             	decl   0x10(%ebp)
  8010dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8010df:	48                   	dec    %eax
  8010e0:	8a 00                	mov    (%eax),%al
  8010e2:	3c 25                	cmp    $0x25,%al
  8010e4:	75 f3                	jne    8010d9 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8010e6:	90                   	nop
		}
	}
  8010e7:	e9 47 fc ff ff       	jmp    800d33 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8010ec:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8010ed:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8010f0:	5b                   	pop    %ebx
  8010f1:	5e                   	pop    %esi
  8010f2:	5d                   	pop    %ebp
  8010f3:	c3                   	ret    

008010f4 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8010f4:	55                   	push   %ebp
  8010f5:	89 e5                	mov    %esp,%ebp
  8010f7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8010fa:	8d 45 10             	lea    0x10(%ebp),%eax
  8010fd:	83 c0 04             	add    $0x4,%eax
  801100:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801103:	8b 45 10             	mov    0x10(%ebp),%eax
  801106:	ff 75 f4             	pushl  -0xc(%ebp)
  801109:	50                   	push   %eax
  80110a:	ff 75 0c             	pushl  0xc(%ebp)
  80110d:	ff 75 08             	pushl  0x8(%ebp)
  801110:	e8 16 fc ff ff       	call   800d2b <vprintfmt>
  801115:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801118:	90                   	nop
  801119:	c9                   	leave  
  80111a:	c3                   	ret    

0080111b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80111b:	55                   	push   %ebp
  80111c:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80111e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801121:	8b 40 08             	mov    0x8(%eax),%eax
  801124:	8d 50 01             	lea    0x1(%eax),%edx
  801127:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112a:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80112d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801130:	8b 10                	mov    (%eax),%edx
  801132:	8b 45 0c             	mov    0xc(%ebp),%eax
  801135:	8b 40 04             	mov    0x4(%eax),%eax
  801138:	39 c2                	cmp    %eax,%edx
  80113a:	73 12                	jae    80114e <sprintputch+0x33>
		*b->buf++ = ch;
  80113c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113f:	8b 00                	mov    (%eax),%eax
  801141:	8d 48 01             	lea    0x1(%eax),%ecx
  801144:	8b 55 0c             	mov    0xc(%ebp),%edx
  801147:	89 0a                	mov    %ecx,(%edx)
  801149:	8b 55 08             	mov    0x8(%ebp),%edx
  80114c:	88 10                	mov    %dl,(%eax)
}
  80114e:	90                   	nop
  80114f:	5d                   	pop    %ebp
  801150:	c3                   	ret    

00801151 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801151:	55                   	push   %ebp
  801152:	89 e5                	mov    %esp,%ebp
  801154:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801157:	8b 45 08             	mov    0x8(%ebp),%eax
  80115a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80115d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801160:	8d 50 ff             	lea    -0x1(%eax),%edx
  801163:	8b 45 08             	mov    0x8(%ebp),%eax
  801166:	01 d0                	add    %edx,%eax
  801168:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80116b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801172:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801176:	74 06                	je     80117e <vsnprintf+0x2d>
  801178:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80117c:	7f 07                	jg     801185 <vsnprintf+0x34>
		return -E_INVAL;
  80117e:	b8 03 00 00 00       	mov    $0x3,%eax
  801183:	eb 20                	jmp    8011a5 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801185:	ff 75 14             	pushl  0x14(%ebp)
  801188:	ff 75 10             	pushl  0x10(%ebp)
  80118b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80118e:	50                   	push   %eax
  80118f:	68 1b 11 80 00       	push   $0x80111b
  801194:	e8 92 fb ff ff       	call   800d2b <vprintfmt>
  801199:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80119c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80119f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8011a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8011a5:	c9                   	leave  
  8011a6:	c3                   	ret    

008011a7 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8011a7:	55                   	push   %ebp
  8011a8:	89 e5                	mov    %esp,%ebp
  8011aa:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8011ad:	8d 45 10             	lea    0x10(%ebp),%eax
  8011b0:	83 c0 04             	add    $0x4,%eax
  8011b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8011b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b9:	ff 75 f4             	pushl  -0xc(%ebp)
  8011bc:	50                   	push   %eax
  8011bd:	ff 75 0c             	pushl  0xc(%ebp)
  8011c0:	ff 75 08             	pushl  0x8(%ebp)
  8011c3:	e8 89 ff ff ff       	call   801151 <vsnprintf>
  8011c8:	83 c4 10             	add    $0x10,%esp
  8011cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8011ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8011d1:	c9                   	leave  
  8011d2:	c3                   	ret    

008011d3 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  8011d3:	55                   	push   %ebp
  8011d4:	89 e5                	mov    %esp,%ebp
  8011d6:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  8011d9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011dd:	74 13                	je     8011f2 <readline+0x1f>
		cprintf("%s", prompt);
  8011df:	83 ec 08             	sub    $0x8,%esp
  8011e2:	ff 75 08             	pushl  0x8(%ebp)
  8011e5:	68 b0 45 80 00       	push   $0x8045b0
  8011ea:	e8 62 f9 ff ff       	call   800b51 <cprintf>
  8011ef:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8011f2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8011f9:	83 ec 0c             	sub    $0xc,%esp
  8011fc:	6a 00                	push   $0x0
  8011fe:	e8 54 f5 ff ff       	call   800757 <iscons>
  801203:	83 c4 10             	add    $0x10,%esp
  801206:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801209:	e8 fb f4 ff ff       	call   800709 <getchar>
  80120e:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801211:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801215:	79 22                	jns    801239 <readline+0x66>
			if (c != -E_EOF)
  801217:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  80121b:	0f 84 ad 00 00 00    	je     8012ce <readline+0xfb>
				cprintf("read error: %e\n", c);
  801221:	83 ec 08             	sub    $0x8,%esp
  801224:	ff 75 ec             	pushl  -0x14(%ebp)
  801227:	68 b3 45 80 00       	push   $0x8045b3
  80122c:	e8 20 f9 ff ff       	call   800b51 <cprintf>
  801231:	83 c4 10             	add    $0x10,%esp
			return;
  801234:	e9 95 00 00 00       	jmp    8012ce <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801239:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  80123d:	7e 34                	jle    801273 <readline+0xa0>
  80123f:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801246:	7f 2b                	jg     801273 <readline+0xa0>
			if (echoing)
  801248:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80124c:	74 0e                	je     80125c <readline+0x89>
				cputchar(c);
  80124e:	83 ec 0c             	sub    $0xc,%esp
  801251:	ff 75 ec             	pushl  -0x14(%ebp)
  801254:	e8 68 f4 ff ff       	call   8006c1 <cputchar>
  801259:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  80125c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80125f:	8d 50 01             	lea    0x1(%eax),%edx
  801262:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801265:	89 c2                	mov    %eax,%edx
  801267:	8b 45 0c             	mov    0xc(%ebp),%eax
  80126a:	01 d0                	add    %edx,%eax
  80126c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80126f:	88 10                	mov    %dl,(%eax)
  801271:	eb 56                	jmp    8012c9 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  801273:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801277:	75 1f                	jne    801298 <readline+0xc5>
  801279:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80127d:	7e 19                	jle    801298 <readline+0xc5>
			if (echoing)
  80127f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801283:	74 0e                	je     801293 <readline+0xc0>
				cputchar(c);
  801285:	83 ec 0c             	sub    $0xc,%esp
  801288:	ff 75 ec             	pushl  -0x14(%ebp)
  80128b:	e8 31 f4 ff ff       	call   8006c1 <cputchar>
  801290:	83 c4 10             	add    $0x10,%esp

			i--;
  801293:	ff 4d f4             	decl   -0xc(%ebp)
  801296:	eb 31                	jmp    8012c9 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  801298:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  80129c:	74 0a                	je     8012a8 <readline+0xd5>
  80129e:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8012a2:	0f 85 61 ff ff ff    	jne    801209 <readline+0x36>
			if (echoing)
  8012a8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012ac:	74 0e                	je     8012bc <readline+0xe9>
				cputchar(c);
  8012ae:	83 ec 0c             	sub    $0xc,%esp
  8012b1:	ff 75 ec             	pushl  -0x14(%ebp)
  8012b4:	e8 08 f4 ff ff       	call   8006c1 <cputchar>
  8012b9:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  8012bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c2:	01 d0                	add    %edx,%eax
  8012c4:	c6 00 00             	movb   $0x0,(%eax)
			return;
  8012c7:	eb 06                	jmp    8012cf <readline+0xfc>
		}
	}
  8012c9:	e9 3b ff ff ff       	jmp    801209 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  8012ce:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  8012cf:	c9                   	leave  
  8012d0:	c3                   	ret    

008012d1 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  8012d1:	55                   	push   %ebp
  8012d2:	89 e5                	mov    %esp,%ebp
  8012d4:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8012d7:	e8 c5 0d 00 00       	call   8020a1 <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  8012dc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012e0:	74 13                	je     8012f5 <atomic_readline+0x24>
		cprintf("%s", prompt);
  8012e2:	83 ec 08             	sub    $0x8,%esp
  8012e5:	ff 75 08             	pushl  0x8(%ebp)
  8012e8:	68 b0 45 80 00       	push   $0x8045b0
  8012ed:	e8 5f f8 ff ff       	call   800b51 <cprintf>
  8012f2:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8012f5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8012fc:	83 ec 0c             	sub    $0xc,%esp
  8012ff:	6a 00                	push   $0x0
  801301:	e8 51 f4 ff ff       	call   800757 <iscons>
  801306:	83 c4 10             	add    $0x10,%esp
  801309:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  80130c:	e8 f8 f3 ff ff       	call   800709 <getchar>
  801311:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801314:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801318:	79 23                	jns    80133d <atomic_readline+0x6c>
			if (c != -E_EOF)
  80131a:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  80131e:	74 13                	je     801333 <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  801320:	83 ec 08             	sub    $0x8,%esp
  801323:	ff 75 ec             	pushl  -0x14(%ebp)
  801326:	68 b3 45 80 00       	push   $0x8045b3
  80132b:	e8 21 f8 ff ff       	call   800b51 <cprintf>
  801330:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  801333:	e8 83 0d 00 00       	call   8020bb <sys_enable_interrupt>
			return;
  801338:	e9 9a 00 00 00       	jmp    8013d7 <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  80133d:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801341:	7e 34                	jle    801377 <atomic_readline+0xa6>
  801343:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  80134a:	7f 2b                	jg     801377 <atomic_readline+0xa6>
			if (echoing)
  80134c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801350:	74 0e                	je     801360 <atomic_readline+0x8f>
				cputchar(c);
  801352:	83 ec 0c             	sub    $0xc,%esp
  801355:	ff 75 ec             	pushl  -0x14(%ebp)
  801358:	e8 64 f3 ff ff       	call   8006c1 <cputchar>
  80135d:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801360:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801363:	8d 50 01             	lea    0x1(%eax),%edx
  801366:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801369:	89 c2                	mov    %eax,%edx
  80136b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136e:	01 d0                	add    %edx,%eax
  801370:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801373:	88 10                	mov    %dl,(%eax)
  801375:	eb 5b                	jmp    8013d2 <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  801377:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80137b:	75 1f                	jne    80139c <atomic_readline+0xcb>
  80137d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801381:	7e 19                	jle    80139c <atomic_readline+0xcb>
			if (echoing)
  801383:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801387:	74 0e                	je     801397 <atomic_readline+0xc6>
				cputchar(c);
  801389:	83 ec 0c             	sub    $0xc,%esp
  80138c:	ff 75 ec             	pushl  -0x14(%ebp)
  80138f:	e8 2d f3 ff ff       	call   8006c1 <cputchar>
  801394:	83 c4 10             	add    $0x10,%esp
			i--;
  801397:	ff 4d f4             	decl   -0xc(%ebp)
  80139a:	eb 36                	jmp    8013d2 <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  80139c:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8013a0:	74 0a                	je     8013ac <atomic_readline+0xdb>
  8013a2:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8013a6:	0f 85 60 ff ff ff    	jne    80130c <atomic_readline+0x3b>
			if (echoing)
  8013ac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013b0:	74 0e                	je     8013c0 <atomic_readline+0xef>
				cputchar(c);
  8013b2:	83 ec 0c             	sub    $0xc,%esp
  8013b5:	ff 75 ec             	pushl  -0x14(%ebp)
  8013b8:	e8 04 f3 ff ff       	call   8006c1 <cputchar>
  8013bd:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  8013c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c6:	01 d0                	add    %edx,%eax
  8013c8:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  8013cb:	e8 eb 0c 00 00       	call   8020bb <sys_enable_interrupt>
			return;
  8013d0:	eb 05                	jmp    8013d7 <atomic_readline+0x106>
		}
	}
  8013d2:	e9 35 ff ff ff       	jmp    80130c <atomic_readline+0x3b>
}
  8013d7:	c9                   	leave  
  8013d8:	c3                   	ret    

008013d9 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8013d9:	55                   	push   %ebp
  8013da:	89 e5                	mov    %esp,%ebp
  8013dc:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8013df:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013e6:	eb 06                	jmp    8013ee <strlen+0x15>
		n++;
  8013e8:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8013eb:	ff 45 08             	incl   0x8(%ebp)
  8013ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f1:	8a 00                	mov    (%eax),%al
  8013f3:	84 c0                	test   %al,%al
  8013f5:	75 f1                	jne    8013e8 <strlen+0xf>
		n++;
	return n;
  8013f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8013fa:	c9                   	leave  
  8013fb:	c3                   	ret    

008013fc <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8013fc:	55                   	push   %ebp
  8013fd:	89 e5                	mov    %esp,%ebp
  8013ff:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801402:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801409:	eb 09                	jmp    801414 <strnlen+0x18>
		n++;
  80140b:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80140e:	ff 45 08             	incl   0x8(%ebp)
  801411:	ff 4d 0c             	decl   0xc(%ebp)
  801414:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801418:	74 09                	je     801423 <strnlen+0x27>
  80141a:	8b 45 08             	mov    0x8(%ebp),%eax
  80141d:	8a 00                	mov    (%eax),%al
  80141f:	84 c0                	test   %al,%al
  801421:	75 e8                	jne    80140b <strnlen+0xf>
		n++;
	return n;
  801423:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801426:	c9                   	leave  
  801427:	c3                   	ret    

00801428 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801428:	55                   	push   %ebp
  801429:	89 e5                	mov    %esp,%ebp
  80142b:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80142e:	8b 45 08             	mov    0x8(%ebp),%eax
  801431:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801434:	90                   	nop
  801435:	8b 45 08             	mov    0x8(%ebp),%eax
  801438:	8d 50 01             	lea    0x1(%eax),%edx
  80143b:	89 55 08             	mov    %edx,0x8(%ebp)
  80143e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801441:	8d 4a 01             	lea    0x1(%edx),%ecx
  801444:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801447:	8a 12                	mov    (%edx),%dl
  801449:	88 10                	mov    %dl,(%eax)
  80144b:	8a 00                	mov    (%eax),%al
  80144d:	84 c0                	test   %al,%al
  80144f:	75 e4                	jne    801435 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801451:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801454:	c9                   	leave  
  801455:	c3                   	ret    

00801456 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801456:	55                   	push   %ebp
  801457:	89 e5                	mov    %esp,%ebp
  801459:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80145c:	8b 45 08             	mov    0x8(%ebp),%eax
  80145f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801462:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801469:	eb 1f                	jmp    80148a <strncpy+0x34>
		*dst++ = *src;
  80146b:	8b 45 08             	mov    0x8(%ebp),%eax
  80146e:	8d 50 01             	lea    0x1(%eax),%edx
  801471:	89 55 08             	mov    %edx,0x8(%ebp)
  801474:	8b 55 0c             	mov    0xc(%ebp),%edx
  801477:	8a 12                	mov    (%edx),%dl
  801479:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80147b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80147e:	8a 00                	mov    (%eax),%al
  801480:	84 c0                	test   %al,%al
  801482:	74 03                	je     801487 <strncpy+0x31>
			src++;
  801484:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801487:	ff 45 fc             	incl   -0x4(%ebp)
  80148a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80148d:	3b 45 10             	cmp    0x10(%ebp),%eax
  801490:	72 d9                	jb     80146b <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801492:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801495:	c9                   	leave  
  801496:	c3                   	ret    

00801497 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801497:	55                   	push   %ebp
  801498:	89 e5                	mov    %esp,%ebp
  80149a:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80149d:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8014a3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014a7:	74 30                	je     8014d9 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8014a9:	eb 16                	jmp    8014c1 <strlcpy+0x2a>
			*dst++ = *src++;
  8014ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ae:	8d 50 01             	lea    0x1(%eax),%edx
  8014b1:	89 55 08             	mov    %edx,0x8(%ebp)
  8014b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014b7:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014ba:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8014bd:	8a 12                	mov    (%edx),%dl
  8014bf:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8014c1:	ff 4d 10             	decl   0x10(%ebp)
  8014c4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014c8:	74 09                	je     8014d3 <strlcpy+0x3c>
  8014ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014cd:	8a 00                	mov    (%eax),%al
  8014cf:	84 c0                	test   %al,%al
  8014d1:	75 d8                	jne    8014ab <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8014d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d6:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8014d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8014dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014df:	29 c2                	sub    %eax,%edx
  8014e1:	89 d0                	mov    %edx,%eax
}
  8014e3:	c9                   	leave  
  8014e4:	c3                   	ret    

008014e5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8014e5:	55                   	push   %ebp
  8014e6:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8014e8:	eb 06                	jmp    8014f0 <strcmp+0xb>
		p++, q++;
  8014ea:	ff 45 08             	incl   0x8(%ebp)
  8014ed:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8014f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f3:	8a 00                	mov    (%eax),%al
  8014f5:	84 c0                	test   %al,%al
  8014f7:	74 0e                	je     801507 <strcmp+0x22>
  8014f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fc:	8a 10                	mov    (%eax),%dl
  8014fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801501:	8a 00                	mov    (%eax),%al
  801503:	38 c2                	cmp    %al,%dl
  801505:	74 e3                	je     8014ea <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801507:	8b 45 08             	mov    0x8(%ebp),%eax
  80150a:	8a 00                	mov    (%eax),%al
  80150c:	0f b6 d0             	movzbl %al,%edx
  80150f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801512:	8a 00                	mov    (%eax),%al
  801514:	0f b6 c0             	movzbl %al,%eax
  801517:	29 c2                	sub    %eax,%edx
  801519:	89 d0                	mov    %edx,%eax
}
  80151b:	5d                   	pop    %ebp
  80151c:	c3                   	ret    

0080151d <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80151d:	55                   	push   %ebp
  80151e:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801520:	eb 09                	jmp    80152b <strncmp+0xe>
		n--, p++, q++;
  801522:	ff 4d 10             	decl   0x10(%ebp)
  801525:	ff 45 08             	incl   0x8(%ebp)
  801528:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80152b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80152f:	74 17                	je     801548 <strncmp+0x2b>
  801531:	8b 45 08             	mov    0x8(%ebp),%eax
  801534:	8a 00                	mov    (%eax),%al
  801536:	84 c0                	test   %al,%al
  801538:	74 0e                	je     801548 <strncmp+0x2b>
  80153a:	8b 45 08             	mov    0x8(%ebp),%eax
  80153d:	8a 10                	mov    (%eax),%dl
  80153f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801542:	8a 00                	mov    (%eax),%al
  801544:	38 c2                	cmp    %al,%dl
  801546:	74 da                	je     801522 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801548:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80154c:	75 07                	jne    801555 <strncmp+0x38>
		return 0;
  80154e:	b8 00 00 00 00       	mov    $0x0,%eax
  801553:	eb 14                	jmp    801569 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801555:	8b 45 08             	mov    0x8(%ebp),%eax
  801558:	8a 00                	mov    (%eax),%al
  80155a:	0f b6 d0             	movzbl %al,%edx
  80155d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801560:	8a 00                	mov    (%eax),%al
  801562:	0f b6 c0             	movzbl %al,%eax
  801565:	29 c2                	sub    %eax,%edx
  801567:	89 d0                	mov    %edx,%eax
}
  801569:	5d                   	pop    %ebp
  80156a:	c3                   	ret    

0080156b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80156b:	55                   	push   %ebp
  80156c:	89 e5                	mov    %esp,%ebp
  80156e:	83 ec 04             	sub    $0x4,%esp
  801571:	8b 45 0c             	mov    0xc(%ebp),%eax
  801574:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801577:	eb 12                	jmp    80158b <strchr+0x20>
		if (*s == c)
  801579:	8b 45 08             	mov    0x8(%ebp),%eax
  80157c:	8a 00                	mov    (%eax),%al
  80157e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801581:	75 05                	jne    801588 <strchr+0x1d>
			return (char *) s;
  801583:	8b 45 08             	mov    0x8(%ebp),%eax
  801586:	eb 11                	jmp    801599 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801588:	ff 45 08             	incl   0x8(%ebp)
  80158b:	8b 45 08             	mov    0x8(%ebp),%eax
  80158e:	8a 00                	mov    (%eax),%al
  801590:	84 c0                	test   %al,%al
  801592:	75 e5                	jne    801579 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801594:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801599:	c9                   	leave  
  80159a:	c3                   	ret    

0080159b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80159b:	55                   	push   %ebp
  80159c:	89 e5                	mov    %esp,%ebp
  80159e:	83 ec 04             	sub    $0x4,%esp
  8015a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a4:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8015a7:	eb 0d                	jmp    8015b6 <strfind+0x1b>
		if (*s == c)
  8015a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ac:	8a 00                	mov    (%eax),%al
  8015ae:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8015b1:	74 0e                	je     8015c1 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8015b3:	ff 45 08             	incl   0x8(%ebp)
  8015b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b9:	8a 00                	mov    (%eax),%al
  8015bb:	84 c0                	test   %al,%al
  8015bd:	75 ea                	jne    8015a9 <strfind+0xe>
  8015bf:	eb 01                	jmp    8015c2 <strfind+0x27>
		if (*s == c)
			break;
  8015c1:	90                   	nop
	return (char *) s;
  8015c2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015c5:	c9                   	leave  
  8015c6:	c3                   	ret    

008015c7 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8015c7:	55                   	push   %ebp
  8015c8:	89 e5                	mov    %esp,%ebp
  8015ca:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8015cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8015d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8015d6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8015d9:	eb 0e                	jmp    8015e9 <memset+0x22>
		*p++ = c;
  8015db:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015de:	8d 50 01             	lea    0x1(%eax),%edx
  8015e1:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8015e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015e7:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8015e9:	ff 4d f8             	decl   -0x8(%ebp)
  8015ec:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8015f0:	79 e9                	jns    8015db <memset+0x14>
		*p++ = c;

	return v;
  8015f2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015f5:	c9                   	leave  
  8015f6:	c3                   	ret    

008015f7 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8015f7:	55                   	push   %ebp
  8015f8:	89 e5                	mov    %esp,%ebp
  8015fa:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8015fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801600:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801603:	8b 45 08             	mov    0x8(%ebp),%eax
  801606:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801609:	eb 16                	jmp    801621 <memcpy+0x2a>
		*d++ = *s++;
  80160b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80160e:	8d 50 01             	lea    0x1(%eax),%edx
  801611:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801614:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801617:	8d 4a 01             	lea    0x1(%edx),%ecx
  80161a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80161d:	8a 12                	mov    (%edx),%dl
  80161f:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801621:	8b 45 10             	mov    0x10(%ebp),%eax
  801624:	8d 50 ff             	lea    -0x1(%eax),%edx
  801627:	89 55 10             	mov    %edx,0x10(%ebp)
  80162a:	85 c0                	test   %eax,%eax
  80162c:	75 dd                	jne    80160b <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80162e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801631:	c9                   	leave  
  801632:	c3                   	ret    

00801633 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801633:	55                   	push   %ebp
  801634:	89 e5                	mov    %esp,%ebp
  801636:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801639:	8b 45 0c             	mov    0xc(%ebp),%eax
  80163c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80163f:	8b 45 08             	mov    0x8(%ebp),%eax
  801642:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801645:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801648:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80164b:	73 50                	jae    80169d <memmove+0x6a>
  80164d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801650:	8b 45 10             	mov    0x10(%ebp),%eax
  801653:	01 d0                	add    %edx,%eax
  801655:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801658:	76 43                	jbe    80169d <memmove+0x6a>
		s += n;
  80165a:	8b 45 10             	mov    0x10(%ebp),%eax
  80165d:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801660:	8b 45 10             	mov    0x10(%ebp),%eax
  801663:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801666:	eb 10                	jmp    801678 <memmove+0x45>
			*--d = *--s;
  801668:	ff 4d f8             	decl   -0x8(%ebp)
  80166b:	ff 4d fc             	decl   -0x4(%ebp)
  80166e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801671:	8a 10                	mov    (%eax),%dl
  801673:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801676:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801678:	8b 45 10             	mov    0x10(%ebp),%eax
  80167b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80167e:	89 55 10             	mov    %edx,0x10(%ebp)
  801681:	85 c0                	test   %eax,%eax
  801683:	75 e3                	jne    801668 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801685:	eb 23                	jmp    8016aa <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801687:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80168a:	8d 50 01             	lea    0x1(%eax),%edx
  80168d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801690:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801693:	8d 4a 01             	lea    0x1(%edx),%ecx
  801696:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801699:	8a 12                	mov    (%edx),%dl
  80169b:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80169d:	8b 45 10             	mov    0x10(%ebp),%eax
  8016a0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016a3:	89 55 10             	mov    %edx,0x10(%ebp)
  8016a6:	85 c0                	test   %eax,%eax
  8016a8:	75 dd                	jne    801687 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8016aa:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016ad:	c9                   	leave  
  8016ae:	c3                   	ret    

008016af <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8016af:	55                   	push   %ebp
  8016b0:	89 e5                	mov    %esp,%ebp
  8016b2:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8016b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8016bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016be:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8016c1:	eb 2a                	jmp    8016ed <memcmp+0x3e>
		if (*s1 != *s2)
  8016c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016c6:	8a 10                	mov    (%eax),%dl
  8016c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016cb:	8a 00                	mov    (%eax),%al
  8016cd:	38 c2                	cmp    %al,%dl
  8016cf:	74 16                	je     8016e7 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8016d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016d4:	8a 00                	mov    (%eax),%al
  8016d6:	0f b6 d0             	movzbl %al,%edx
  8016d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016dc:	8a 00                	mov    (%eax),%al
  8016de:	0f b6 c0             	movzbl %al,%eax
  8016e1:	29 c2                	sub    %eax,%edx
  8016e3:	89 d0                	mov    %edx,%eax
  8016e5:	eb 18                	jmp    8016ff <memcmp+0x50>
		s1++, s2++;
  8016e7:	ff 45 fc             	incl   -0x4(%ebp)
  8016ea:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8016ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8016f0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016f3:	89 55 10             	mov    %edx,0x10(%ebp)
  8016f6:	85 c0                	test   %eax,%eax
  8016f8:	75 c9                	jne    8016c3 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8016fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016ff:	c9                   	leave  
  801700:	c3                   	ret    

00801701 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801701:	55                   	push   %ebp
  801702:	89 e5                	mov    %esp,%ebp
  801704:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801707:	8b 55 08             	mov    0x8(%ebp),%edx
  80170a:	8b 45 10             	mov    0x10(%ebp),%eax
  80170d:	01 d0                	add    %edx,%eax
  80170f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801712:	eb 15                	jmp    801729 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801714:	8b 45 08             	mov    0x8(%ebp),%eax
  801717:	8a 00                	mov    (%eax),%al
  801719:	0f b6 d0             	movzbl %al,%edx
  80171c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80171f:	0f b6 c0             	movzbl %al,%eax
  801722:	39 c2                	cmp    %eax,%edx
  801724:	74 0d                	je     801733 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801726:	ff 45 08             	incl   0x8(%ebp)
  801729:	8b 45 08             	mov    0x8(%ebp),%eax
  80172c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80172f:	72 e3                	jb     801714 <memfind+0x13>
  801731:	eb 01                	jmp    801734 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801733:	90                   	nop
	return (void *) s;
  801734:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801737:	c9                   	leave  
  801738:	c3                   	ret    

00801739 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801739:	55                   	push   %ebp
  80173a:	89 e5                	mov    %esp,%ebp
  80173c:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80173f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801746:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80174d:	eb 03                	jmp    801752 <strtol+0x19>
		s++;
  80174f:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801752:	8b 45 08             	mov    0x8(%ebp),%eax
  801755:	8a 00                	mov    (%eax),%al
  801757:	3c 20                	cmp    $0x20,%al
  801759:	74 f4                	je     80174f <strtol+0x16>
  80175b:	8b 45 08             	mov    0x8(%ebp),%eax
  80175e:	8a 00                	mov    (%eax),%al
  801760:	3c 09                	cmp    $0x9,%al
  801762:	74 eb                	je     80174f <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801764:	8b 45 08             	mov    0x8(%ebp),%eax
  801767:	8a 00                	mov    (%eax),%al
  801769:	3c 2b                	cmp    $0x2b,%al
  80176b:	75 05                	jne    801772 <strtol+0x39>
		s++;
  80176d:	ff 45 08             	incl   0x8(%ebp)
  801770:	eb 13                	jmp    801785 <strtol+0x4c>
	else if (*s == '-')
  801772:	8b 45 08             	mov    0x8(%ebp),%eax
  801775:	8a 00                	mov    (%eax),%al
  801777:	3c 2d                	cmp    $0x2d,%al
  801779:	75 0a                	jne    801785 <strtol+0x4c>
		s++, neg = 1;
  80177b:	ff 45 08             	incl   0x8(%ebp)
  80177e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801785:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801789:	74 06                	je     801791 <strtol+0x58>
  80178b:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80178f:	75 20                	jne    8017b1 <strtol+0x78>
  801791:	8b 45 08             	mov    0x8(%ebp),%eax
  801794:	8a 00                	mov    (%eax),%al
  801796:	3c 30                	cmp    $0x30,%al
  801798:	75 17                	jne    8017b1 <strtol+0x78>
  80179a:	8b 45 08             	mov    0x8(%ebp),%eax
  80179d:	40                   	inc    %eax
  80179e:	8a 00                	mov    (%eax),%al
  8017a0:	3c 78                	cmp    $0x78,%al
  8017a2:	75 0d                	jne    8017b1 <strtol+0x78>
		s += 2, base = 16;
  8017a4:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8017a8:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8017af:	eb 28                	jmp    8017d9 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8017b1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017b5:	75 15                	jne    8017cc <strtol+0x93>
  8017b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ba:	8a 00                	mov    (%eax),%al
  8017bc:	3c 30                	cmp    $0x30,%al
  8017be:	75 0c                	jne    8017cc <strtol+0x93>
		s++, base = 8;
  8017c0:	ff 45 08             	incl   0x8(%ebp)
  8017c3:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8017ca:	eb 0d                	jmp    8017d9 <strtol+0xa0>
	else if (base == 0)
  8017cc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017d0:	75 07                	jne    8017d9 <strtol+0xa0>
		base = 10;
  8017d2:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8017d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017dc:	8a 00                	mov    (%eax),%al
  8017de:	3c 2f                	cmp    $0x2f,%al
  8017e0:	7e 19                	jle    8017fb <strtol+0xc2>
  8017e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e5:	8a 00                	mov    (%eax),%al
  8017e7:	3c 39                	cmp    $0x39,%al
  8017e9:	7f 10                	jg     8017fb <strtol+0xc2>
			dig = *s - '0';
  8017eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ee:	8a 00                	mov    (%eax),%al
  8017f0:	0f be c0             	movsbl %al,%eax
  8017f3:	83 e8 30             	sub    $0x30,%eax
  8017f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017f9:	eb 42                	jmp    80183d <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8017fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fe:	8a 00                	mov    (%eax),%al
  801800:	3c 60                	cmp    $0x60,%al
  801802:	7e 19                	jle    80181d <strtol+0xe4>
  801804:	8b 45 08             	mov    0x8(%ebp),%eax
  801807:	8a 00                	mov    (%eax),%al
  801809:	3c 7a                	cmp    $0x7a,%al
  80180b:	7f 10                	jg     80181d <strtol+0xe4>
			dig = *s - 'a' + 10;
  80180d:	8b 45 08             	mov    0x8(%ebp),%eax
  801810:	8a 00                	mov    (%eax),%al
  801812:	0f be c0             	movsbl %al,%eax
  801815:	83 e8 57             	sub    $0x57,%eax
  801818:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80181b:	eb 20                	jmp    80183d <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80181d:	8b 45 08             	mov    0x8(%ebp),%eax
  801820:	8a 00                	mov    (%eax),%al
  801822:	3c 40                	cmp    $0x40,%al
  801824:	7e 39                	jle    80185f <strtol+0x126>
  801826:	8b 45 08             	mov    0x8(%ebp),%eax
  801829:	8a 00                	mov    (%eax),%al
  80182b:	3c 5a                	cmp    $0x5a,%al
  80182d:	7f 30                	jg     80185f <strtol+0x126>
			dig = *s - 'A' + 10;
  80182f:	8b 45 08             	mov    0x8(%ebp),%eax
  801832:	8a 00                	mov    (%eax),%al
  801834:	0f be c0             	movsbl %al,%eax
  801837:	83 e8 37             	sub    $0x37,%eax
  80183a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80183d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801840:	3b 45 10             	cmp    0x10(%ebp),%eax
  801843:	7d 19                	jge    80185e <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801845:	ff 45 08             	incl   0x8(%ebp)
  801848:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80184b:	0f af 45 10          	imul   0x10(%ebp),%eax
  80184f:	89 c2                	mov    %eax,%edx
  801851:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801854:	01 d0                	add    %edx,%eax
  801856:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801859:	e9 7b ff ff ff       	jmp    8017d9 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80185e:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80185f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801863:	74 08                	je     80186d <strtol+0x134>
		*endptr = (char *) s;
  801865:	8b 45 0c             	mov    0xc(%ebp),%eax
  801868:	8b 55 08             	mov    0x8(%ebp),%edx
  80186b:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80186d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801871:	74 07                	je     80187a <strtol+0x141>
  801873:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801876:	f7 d8                	neg    %eax
  801878:	eb 03                	jmp    80187d <strtol+0x144>
  80187a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80187d:	c9                   	leave  
  80187e:	c3                   	ret    

0080187f <ltostr>:

void
ltostr(long value, char *str)
{
  80187f:	55                   	push   %ebp
  801880:	89 e5                	mov    %esp,%ebp
  801882:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801885:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80188c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801893:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801897:	79 13                	jns    8018ac <ltostr+0x2d>
	{
		neg = 1;
  801899:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8018a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018a3:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8018a6:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8018a9:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8018ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8018af:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8018b4:	99                   	cltd   
  8018b5:	f7 f9                	idiv   %ecx
  8018b7:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8018ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018bd:	8d 50 01             	lea    0x1(%eax),%edx
  8018c0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8018c3:	89 c2                	mov    %eax,%edx
  8018c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018c8:	01 d0                	add    %edx,%eax
  8018ca:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8018cd:	83 c2 30             	add    $0x30,%edx
  8018d0:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8018d2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018d5:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8018da:	f7 e9                	imul   %ecx
  8018dc:	c1 fa 02             	sar    $0x2,%edx
  8018df:	89 c8                	mov    %ecx,%eax
  8018e1:	c1 f8 1f             	sar    $0x1f,%eax
  8018e4:	29 c2                	sub    %eax,%edx
  8018e6:	89 d0                	mov    %edx,%eax
  8018e8:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8018eb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018ee:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8018f3:	f7 e9                	imul   %ecx
  8018f5:	c1 fa 02             	sar    $0x2,%edx
  8018f8:	89 c8                	mov    %ecx,%eax
  8018fa:	c1 f8 1f             	sar    $0x1f,%eax
  8018fd:	29 c2                	sub    %eax,%edx
  8018ff:	89 d0                	mov    %edx,%eax
  801901:	c1 e0 02             	shl    $0x2,%eax
  801904:	01 d0                	add    %edx,%eax
  801906:	01 c0                	add    %eax,%eax
  801908:	29 c1                	sub    %eax,%ecx
  80190a:	89 ca                	mov    %ecx,%edx
  80190c:	85 d2                	test   %edx,%edx
  80190e:	75 9c                	jne    8018ac <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801910:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801917:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80191a:	48                   	dec    %eax
  80191b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80191e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801922:	74 3d                	je     801961 <ltostr+0xe2>
		start = 1 ;
  801924:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80192b:	eb 34                	jmp    801961 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80192d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801930:	8b 45 0c             	mov    0xc(%ebp),%eax
  801933:	01 d0                	add    %edx,%eax
  801935:	8a 00                	mov    (%eax),%al
  801937:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80193a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80193d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801940:	01 c2                	add    %eax,%edx
  801942:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801945:	8b 45 0c             	mov    0xc(%ebp),%eax
  801948:	01 c8                	add    %ecx,%eax
  80194a:	8a 00                	mov    (%eax),%al
  80194c:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80194e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801951:	8b 45 0c             	mov    0xc(%ebp),%eax
  801954:	01 c2                	add    %eax,%edx
  801956:	8a 45 eb             	mov    -0x15(%ebp),%al
  801959:	88 02                	mov    %al,(%edx)
		start++ ;
  80195b:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80195e:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801961:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801964:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801967:	7c c4                	jl     80192d <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801969:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80196c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80196f:	01 d0                	add    %edx,%eax
  801971:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801974:	90                   	nop
  801975:	c9                   	leave  
  801976:	c3                   	ret    

00801977 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801977:	55                   	push   %ebp
  801978:	89 e5                	mov    %esp,%ebp
  80197a:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80197d:	ff 75 08             	pushl  0x8(%ebp)
  801980:	e8 54 fa ff ff       	call   8013d9 <strlen>
  801985:	83 c4 04             	add    $0x4,%esp
  801988:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80198b:	ff 75 0c             	pushl  0xc(%ebp)
  80198e:	e8 46 fa ff ff       	call   8013d9 <strlen>
  801993:	83 c4 04             	add    $0x4,%esp
  801996:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801999:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8019a0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8019a7:	eb 17                	jmp    8019c0 <strcconcat+0x49>
		final[s] = str1[s] ;
  8019a9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8019af:	01 c2                	add    %eax,%edx
  8019b1:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8019b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b7:	01 c8                	add    %ecx,%eax
  8019b9:	8a 00                	mov    (%eax),%al
  8019bb:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8019bd:	ff 45 fc             	incl   -0x4(%ebp)
  8019c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019c3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8019c6:	7c e1                	jl     8019a9 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8019c8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8019cf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8019d6:	eb 1f                	jmp    8019f7 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8019d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019db:	8d 50 01             	lea    0x1(%eax),%edx
  8019de:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8019e1:	89 c2                	mov    %eax,%edx
  8019e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8019e6:	01 c2                	add    %eax,%edx
  8019e8:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8019eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019ee:	01 c8                	add    %ecx,%eax
  8019f0:	8a 00                	mov    (%eax),%al
  8019f2:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8019f4:	ff 45 f8             	incl   -0x8(%ebp)
  8019f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019fa:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8019fd:	7c d9                	jl     8019d8 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8019ff:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a02:	8b 45 10             	mov    0x10(%ebp),%eax
  801a05:	01 d0                	add    %edx,%eax
  801a07:	c6 00 00             	movb   $0x0,(%eax)
}
  801a0a:	90                   	nop
  801a0b:	c9                   	leave  
  801a0c:	c3                   	ret    

00801a0d <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801a0d:	55                   	push   %ebp
  801a0e:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801a10:	8b 45 14             	mov    0x14(%ebp),%eax
  801a13:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801a19:	8b 45 14             	mov    0x14(%ebp),%eax
  801a1c:	8b 00                	mov    (%eax),%eax
  801a1e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a25:	8b 45 10             	mov    0x10(%ebp),%eax
  801a28:	01 d0                	add    %edx,%eax
  801a2a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a30:	eb 0c                	jmp    801a3e <strsplit+0x31>
			*string++ = 0;
  801a32:	8b 45 08             	mov    0x8(%ebp),%eax
  801a35:	8d 50 01             	lea    0x1(%eax),%edx
  801a38:	89 55 08             	mov    %edx,0x8(%ebp)
  801a3b:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a41:	8a 00                	mov    (%eax),%al
  801a43:	84 c0                	test   %al,%al
  801a45:	74 18                	je     801a5f <strsplit+0x52>
  801a47:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4a:	8a 00                	mov    (%eax),%al
  801a4c:	0f be c0             	movsbl %al,%eax
  801a4f:	50                   	push   %eax
  801a50:	ff 75 0c             	pushl  0xc(%ebp)
  801a53:	e8 13 fb ff ff       	call   80156b <strchr>
  801a58:	83 c4 08             	add    $0x8,%esp
  801a5b:	85 c0                	test   %eax,%eax
  801a5d:	75 d3                	jne    801a32 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801a5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a62:	8a 00                	mov    (%eax),%al
  801a64:	84 c0                	test   %al,%al
  801a66:	74 5a                	je     801ac2 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801a68:	8b 45 14             	mov    0x14(%ebp),%eax
  801a6b:	8b 00                	mov    (%eax),%eax
  801a6d:	83 f8 0f             	cmp    $0xf,%eax
  801a70:	75 07                	jne    801a79 <strsplit+0x6c>
		{
			return 0;
  801a72:	b8 00 00 00 00       	mov    $0x0,%eax
  801a77:	eb 66                	jmp    801adf <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801a79:	8b 45 14             	mov    0x14(%ebp),%eax
  801a7c:	8b 00                	mov    (%eax),%eax
  801a7e:	8d 48 01             	lea    0x1(%eax),%ecx
  801a81:	8b 55 14             	mov    0x14(%ebp),%edx
  801a84:	89 0a                	mov    %ecx,(%edx)
  801a86:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a8d:	8b 45 10             	mov    0x10(%ebp),%eax
  801a90:	01 c2                	add    %eax,%edx
  801a92:	8b 45 08             	mov    0x8(%ebp),%eax
  801a95:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a97:	eb 03                	jmp    801a9c <strsplit+0x8f>
			string++;
  801a99:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9f:	8a 00                	mov    (%eax),%al
  801aa1:	84 c0                	test   %al,%al
  801aa3:	74 8b                	je     801a30 <strsplit+0x23>
  801aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa8:	8a 00                	mov    (%eax),%al
  801aaa:	0f be c0             	movsbl %al,%eax
  801aad:	50                   	push   %eax
  801aae:	ff 75 0c             	pushl  0xc(%ebp)
  801ab1:	e8 b5 fa ff ff       	call   80156b <strchr>
  801ab6:	83 c4 08             	add    $0x8,%esp
  801ab9:	85 c0                	test   %eax,%eax
  801abb:	74 dc                	je     801a99 <strsplit+0x8c>
			string++;
	}
  801abd:	e9 6e ff ff ff       	jmp    801a30 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801ac2:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801ac3:	8b 45 14             	mov    0x14(%ebp),%eax
  801ac6:	8b 00                	mov    (%eax),%eax
  801ac8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801acf:	8b 45 10             	mov    0x10(%ebp),%eax
  801ad2:	01 d0                	add    %edx,%eax
  801ad4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801ada:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801adf:	c9                   	leave  
  801ae0:	c3                   	ret    

00801ae1 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801ae1:	55                   	push   %ebp
  801ae2:	89 e5                	mov    %esp,%ebp
  801ae4:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801ae7:	a1 04 50 80 00       	mov    0x805004,%eax
  801aec:	85 c0                	test   %eax,%eax
  801aee:	74 1f                	je     801b0f <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801af0:	e8 1d 00 00 00       	call   801b12 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801af5:	83 ec 0c             	sub    $0xc,%esp
  801af8:	68 c4 45 80 00       	push   $0x8045c4
  801afd:	e8 4f f0 ff ff       	call   800b51 <cprintf>
  801b02:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801b05:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801b0c:	00 00 00 
	}
}
  801b0f:	90                   	nop
  801b10:	c9                   	leave  
  801b11:	c3                   	ret    

00801b12 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801b12:	55                   	push   %ebp
  801b13:	89 e5                	mov    %esp,%ebp
  801b15:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	LIST_INIT(&AllocMemBlocksList);
  801b18:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801b1f:	00 00 00 
  801b22:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801b29:	00 00 00 
  801b2c:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801b33:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801b36:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801b3d:	00 00 00 
  801b40:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801b47:	00 00 00 
  801b4a:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801b51:	00 00 00 
	uint32 arr_size = 0;
  801b54:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	MemBlockNodes  =(struct MemBlock*) USER_DYN_BLKS_ARRAY;
  801b5b:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801b62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b65:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801b6a:	2d 00 10 00 00       	sub    $0x1000,%eax
  801b6f:	a3 50 50 80 00       	mov    %eax,0x805050
	MAX_MEM_BLOCK_CNT = (USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE;
  801b74:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801b7b:	00 02 00 
	arr_size =  ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock), PAGE_SIZE);
  801b7e:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801b85:	a1 20 51 80 00       	mov    0x805120,%eax
  801b8a:	c1 e0 04             	shl    $0x4,%eax
  801b8d:	89 c2                	mov    %eax,%edx
  801b8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b92:	01 d0                	add    %edx,%eax
  801b94:	48                   	dec    %eax
  801b95:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801b98:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b9b:	ba 00 00 00 00       	mov    $0x0,%edx
  801ba0:	f7 75 ec             	divl   -0x14(%ebp)
  801ba3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ba6:	29 d0                	sub    %edx,%eax
  801ba8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_USER);
  801bab:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801bb2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801bb5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801bba:	2d 00 10 00 00       	sub    $0x1000,%eax
  801bbf:	83 ec 04             	sub    $0x4,%esp
  801bc2:	6a 06                	push   $0x6
  801bc4:	ff 75 f4             	pushl  -0xc(%ebp)
  801bc7:	50                   	push   %eax
  801bc8:	e8 6a 04 00 00       	call   802037 <sys_allocate_chunk>
  801bcd:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801bd0:	a1 20 51 80 00       	mov    0x805120,%eax
  801bd5:	83 ec 0c             	sub    $0xc,%esp
  801bd8:	50                   	push   %eax
  801bd9:	e8 df 0a 00 00       	call   8026bd <initialize_MemBlocksList>
  801bde:	83 c4 10             	add    $0x10,%esp
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	struct MemBlock * NewBlock = LIST_FIRST(&AvailableMemBlocksList);
  801be1:	a1 48 51 80 00       	mov    0x805148,%eax
  801be6:	89 45 e0             	mov    %eax,-0x20(%ebp)
	NewBlock->sva = USER_HEAP_START;
  801be9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bec:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	NewBlock->size = (USER_HEAP_MAX-USER_HEAP_START);
  801bf3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bf6:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	LIST_REMOVE(&AvailableMemBlocksList,NewBlock);
  801bfd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801c01:	75 14                	jne    801c17 <initialize_dyn_block_system+0x105>
  801c03:	83 ec 04             	sub    $0x4,%esp
  801c06:	68 e9 45 80 00       	push   $0x8045e9
  801c0b:	6a 33                	push   $0x33
  801c0d:	68 07 46 80 00       	push   $0x804607
  801c12:	e8 86 ec ff ff       	call   80089d <_panic>
  801c17:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c1a:	8b 00                	mov    (%eax),%eax
  801c1c:	85 c0                	test   %eax,%eax
  801c1e:	74 10                	je     801c30 <initialize_dyn_block_system+0x11e>
  801c20:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c23:	8b 00                	mov    (%eax),%eax
  801c25:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c28:	8b 52 04             	mov    0x4(%edx),%edx
  801c2b:	89 50 04             	mov    %edx,0x4(%eax)
  801c2e:	eb 0b                	jmp    801c3b <initialize_dyn_block_system+0x129>
  801c30:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c33:	8b 40 04             	mov    0x4(%eax),%eax
  801c36:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801c3b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c3e:	8b 40 04             	mov    0x4(%eax),%eax
  801c41:	85 c0                	test   %eax,%eax
  801c43:	74 0f                	je     801c54 <initialize_dyn_block_system+0x142>
  801c45:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c48:	8b 40 04             	mov    0x4(%eax),%eax
  801c4b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c4e:	8b 12                	mov    (%edx),%edx
  801c50:	89 10                	mov    %edx,(%eax)
  801c52:	eb 0a                	jmp    801c5e <initialize_dyn_block_system+0x14c>
  801c54:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c57:	8b 00                	mov    (%eax),%eax
  801c59:	a3 48 51 80 00       	mov    %eax,0x805148
  801c5e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c61:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801c67:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c6a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801c71:	a1 54 51 80 00       	mov    0x805154,%eax
  801c76:	48                   	dec    %eax
  801c77:	a3 54 51 80 00       	mov    %eax,0x805154
	LIST_INSERT_HEAD(&FreeMemBlocksList, NewBlock);
  801c7c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801c80:	75 14                	jne    801c96 <initialize_dyn_block_system+0x184>
  801c82:	83 ec 04             	sub    $0x4,%esp
  801c85:	68 14 46 80 00       	push   $0x804614
  801c8a:	6a 34                	push   $0x34
  801c8c:	68 07 46 80 00       	push   $0x804607
  801c91:	e8 07 ec ff ff       	call   80089d <_panic>
  801c96:	8b 15 38 51 80 00    	mov    0x805138,%edx
  801c9c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c9f:	89 10                	mov    %edx,(%eax)
  801ca1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ca4:	8b 00                	mov    (%eax),%eax
  801ca6:	85 c0                	test   %eax,%eax
  801ca8:	74 0d                	je     801cb7 <initialize_dyn_block_system+0x1a5>
  801caa:	a1 38 51 80 00       	mov    0x805138,%eax
  801caf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801cb2:	89 50 04             	mov    %edx,0x4(%eax)
  801cb5:	eb 08                	jmp    801cbf <initialize_dyn_block_system+0x1ad>
  801cb7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801cba:	a3 3c 51 80 00       	mov    %eax,0x80513c
  801cbf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801cc2:	a3 38 51 80 00       	mov    %eax,0x805138
  801cc7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801cca:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801cd1:	a1 44 51 80 00       	mov    0x805144,%eax
  801cd6:	40                   	inc    %eax
  801cd7:	a3 44 51 80 00       	mov    %eax,0x805144
}
  801cdc:	90                   	nop
  801cdd:	c9                   	leave  
  801cde:	c3                   	ret    

00801cdf <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801cdf:	55                   	push   %ebp
  801ce0:	89 e5                	mov    %esp,%ebp
  801ce2:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801ce5:	e8 f7 fd ff ff       	call   801ae1 <InitializeUHeap>
	if (size == 0) return NULL ;
  801cea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801cee:	75 07                	jne    801cf7 <malloc+0x18>
  801cf0:	b8 00 00 00 00       	mov    $0x0,%eax
  801cf5:	eb 61                	jmp    801d58 <malloc+0x79>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
	uint32 malloc_allocsize=ROUNDUP(size,PAGE_SIZE);
  801cf7:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801cfe:	8b 55 08             	mov    0x8(%ebp),%edx
  801d01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d04:	01 d0                	add    %edx,%eax
  801d06:	48                   	dec    %eax
  801d07:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801d0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d0d:	ba 00 00 00 00       	mov    $0x0,%edx
  801d12:	f7 75 f0             	divl   -0x10(%ebp)
  801d15:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d18:	29 d0                	sub    %edx,%eax
  801d1a:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 //int ret=0;
	struct MemBlock * user_block;
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801d1d:	e8 e3 06 00 00       	call   802405 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801d22:	85 c0                	test   %eax,%eax
  801d24:	74 11                	je     801d37 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801d26:	83 ec 0c             	sub    $0xc,%esp
  801d29:	ff 75 e8             	pushl  -0x18(%ebp)
  801d2c:	e8 4e 0d 00 00       	call   802a7f <alloc_block_FF>
  801d31:	83 c4 10             	add    $0x10,%esp
  801d34:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(user_block!=NULL)
  801d37:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d3b:	74 16                	je     801d53 <malloc+0x74>
	{
		//sys_allocate_chunk(user_block->sva,malloc_allocsize,PERM_WRITEABLE| PERM_PRESENT);
		insert_sorted_allocList(user_block);
  801d3d:	83 ec 0c             	sub    $0xc,%esp
  801d40:	ff 75 f4             	pushl  -0xc(%ebp)
  801d43:	e8 aa 0a 00 00       	call   8027f2 <insert_sorted_allocList>
  801d48:	83 c4 10             	add    $0x10,%esp
		return (uint32 *)user_block->sva;
  801d4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d4e:	8b 40 08             	mov    0x8(%eax),%eax
  801d51:	eb 05                	jmp    801d58 <malloc+0x79>
	}

    return NULL;
  801d53:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d58:	c9                   	leave  
  801d59:	c3                   	ret    

00801d5a <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801d5a:	55                   	push   %ebp
  801d5b:	89 e5                	mov    %esp,%ebp
  801d5d:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801d60:	83 ec 04             	sub    $0x4,%esp
  801d63:	68 38 46 80 00       	push   $0x804638
  801d68:	6a 6f                	push   $0x6f
  801d6a:	68 07 46 80 00       	push   $0x804607
  801d6f:	e8 29 eb ff ff       	call   80089d <_panic>

00801d74 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801d74:	55                   	push   %ebp
  801d75:	89 e5                	mov    %esp,%ebp
  801d77:	83 ec 38             	sub    $0x38,%esp
  801d7a:	8b 45 10             	mov    0x10(%ebp),%eax
  801d7d:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801d80:	e8 5c fd ff ff       	call   801ae1 <InitializeUHeap>
	if (size == 0) return NULL ;
  801d85:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d89:	75 07                	jne    801d92 <smalloc+0x1e>
  801d8b:	b8 00 00 00 00       	mov    $0x0,%eax
  801d90:	eb 7c                	jmp    801e0e <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801d92:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801d99:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d9f:	01 d0                	add    %edx,%eax
  801da1:	48                   	dec    %eax
  801da2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801da5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801da8:	ba 00 00 00 00       	mov    $0x0,%edx
  801dad:	f7 75 f0             	divl   -0x10(%ebp)
  801db0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801db3:	29 d0                	sub    %edx,%eax
  801db5:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801db8:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801dbf:	e8 41 06 00 00       	call   802405 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801dc4:	85 c0                	test   %eax,%eax
  801dc6:	74 11                	je     801dd9 <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  801dc8:	83 ec 0c             	sub    $0xc,%esp
  801dcb:	ff 75 e8             	pushl  -0x18(%ebp)
  801dce:	e8 ac 0c 00 00       	call   802a7f <alloc_block_FF>
  801dd3:	83 c4 10             	add    $0x10,%esp
  801dd6:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  801dd9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ddd:	74 2a                	je     801e09 <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801ddf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801de2:	8b 40 08             	mov    0x8(%eax),%eax
  801de5:	89 c2                	mov    %eax,%edx
  801de7:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801deb:	52                   	push   %edx
  801dec:	50                   	push   %eax
  801ded:	ff 75 0c             	pushl  0xc(%ebp)
  801df0:	ff 75 08             	pushl  0x8(%ebp)
  801df3:	e8 92 03 00 00       	call   80218a <sys_createSharedObject>
  801df8:	83 c4 10             	add    $0x10,%esp
  801dfb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  801dfe:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  801e02:	74 05                	je     801e09 <smalloc+0x95>
			return (void*)virtual_address;
  801e04:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e07:	eb 05                	jmp    801e0e <smalloc+0x9a>
	}
	return NULL;
  801e09:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801e0e:	c9                   	leave  
  801e0f:	c3                   	ret    

00801e10 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801e10:	55                   	push   %ebp
  801e11:	89 e5                	mov    %esp,%ebp
  801e13:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e16:	e8 c6 fc ff ff       	call   801ae1 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801e1b:	83 ec 04             	sub    $0x4,%esp
  801e1e:	68 5c 46 80 00       	push   $0x80465c
  801e23:	68 b0 00 00 00       	push   $0xb0
  801e28:	68 07 46 80 00       	push   $0x804607
  801e2d:	e8 6b ea ff ff       	call   80089d <_panic>

00801e32 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801e32:	55                   	push   %ebp
  801e33:	89 e5                	mov    %esp,%ebp
  801e35:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e38:	e8 a4 fc ff ff       	call   801ae1 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801e3d:	83 ec 04             	sub    $0x4,%esp
  801e40:	68 80 46 80 00       	push   $0x804680
  801e45:	68 f4 00 00 00       	push   $0xf4
  801e4a:	68 07 46 80 00       	push   $0x804607
  801e4f:	e8 49 ea ff ff       	call   80089d <_panic>

00801e54 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801e54:	55                   	push   %ebp
  801e55:	89 e5                	mov    %esp,%ebp
  801e57:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801e5a:	83 ec 04             	sub    $0x4,%esp
  801e5d:	68 a8 46 80 00       	push   $0x8046a8
  801e62:	68 08 01 00 00       	push   $0x108
  801e67:	68 07 46 80 00       	push   $0x804607
  801e6c:	e8 2c ea ff ff       	call   80089d <_panic>

00801e71 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801e71:	55                   	push   %ebp
  801e72:	89 e5                	mov    %esp,%ebp
  801e74:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e77:	83 ec 04             	sub    $0x4,%esp
  801e7a:	68 cc 46 80 00       	push   $0x8046cc
  801e7f:	68 13 01 00 00       	push   $0x113
  801e84:	68 07 46 80 00       	push   $0x804607
  801e89:	e8 0f ea ff ff       	call   80089d <_panic>

00801e8e <shrink>:

}
void shrink(uint32 newSize)
{
  801e8e:	55                   	push   %ebp
  801e8f:	89 e5                	mov    %esp,%ebp
  801e91:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e94:	83 ec 04             	sub    $0x4,%esp
  801e97:	68 cc 46 80 00       	push   $0x8046cc
  801e9c:	68 18 01 00 00       	push   $0x118
  801ea1:	68 07 46 80 00       	push   $0x804607
  801ea6:	e8 f2 e9 ff ff       	call   80089d <_panic>

00801eab <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801eab:	55                   	push   %ebp
  801eac:	89 e5                	mov    %esp,%ebp
  801eae:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801eb1:	83 ec 04             	sub    $0x4,%esp
  801eb4:	68 cc 46 80 00       	push   $0x8046cc
  801eb9:	68 1d 01 00 00       	push   $0x11d
  801ebe:	68 07 46 80 00       	push   $0x804607
  801ec3:	e8 d5 e9 ff ff       	call   80089d <_panic>

00801ec8 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801ec8:	55                   	push   %ebp
  801ec9:	89 e5                	mov    %esp,%ebp
  801ecb:	57                   	push   %edi
  801ecc:	56                   	push   %esi
  801ecd:	53                   	push   %ebx
  801ece:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801ed1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ed7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801eda:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801edd:	8b 7d 18             	mov    0x18(%ebp),%edi
  801ee0:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801ee3:	cd 30                	int    $0x30
  801ee5:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801ee8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801eeb:	83 c4 10             	add    $0x10,%esp
  801eee:	5b                   	pop    %ebx
  801eef:	5e                   	pop    %esi
  801ef0:	5f                   	pop    %edi
  801ef1:	5d                   	pop    %ebp
  801ef2:	c3                   	ret    

00801ef3 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801ef3:	55                   	push   %ebp
  801ef4:	89 e5                	mov    %esp,%ebp
  801ef6:	83 ec 04             	sub    $0x4,%esp
  801ef9:	8b 45 10             	mov    0x10(%ebp),%eax
  801efc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801eff:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f03:	8b 45 08             	mov    0x8(%ebp),%eax
  801f06:	6a 00                	push   $0x0
  801f08:	6a 00                	push   $0x0
  801f0a:	52                   	push   %edx
  801f0b:	ff 75 0c             	pushl  0xc(%ebp)
  801f0e:	50                   	push   %eax
  801f0f:	6a 00                	push   $0x0
  801f11:	e8 b2 ff ff ff       	call   801ec8 <syscall>
  801f16:	83 c4 18             	add    $0x18,%esp
}
  801f19:	90                   	nop
  801f1a:	c9                   	leave  
  801f1b:	c3                   	ret    

00801f1c <sys_cgetc>:

int
sys_cgetc(void)
{
  801f1c:	55                   	push   %ebp
  801f1d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801f1f:	6a 00                	push   $0x0
  801f21:	6a 00                	push   $0x0
  801f23:	6a 00                	push   $0x0
  801f25:	6a 00                	push   $0x0
  801f27:	6a 00                	push   $0x0
  801f29:	6a 01                	push   $0x1
  801f2b:	e8 98 ff ff ff       	call   801ec8 <syscall>
  801f30:	83 c4 18             	add    $0x18,%esp
}
  801f33:	c9                   	leave  
  801f34:	c3                   	ret    

00801f35 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801f35:	55                   	push   %ebp
  801f36:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801f38:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3e:	6a 00                	push   $0x0
  801f40:	6a 00                	push   $0x0
  801f42:	6a 00                	push   $0x0
  801f44:	52                   	push   %edx
  801f45:	50                   	push   %eax
  801f46:	6a 05                	push   $0x5
  801f48:	e8 7b ff ff ff       	call   801ec8 <syscall>
  801f4d:	83 c4 18             	add    $0x18,%esp
}
  801f50:	c9                   	leave  
  801f51:	c3                   	ret    

00801f52 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801f52:	55                   	push   %ebp
  801f53:	89 e5                	mov    %esp,%ebp
  801f55:	56                   	push   %esi
  801f56:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801f57:	8b 75 18             	mov    0x18(%ebp),%esi
  801f5a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f5d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f60:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f63:	8b 45 08             	mov    0x8(%ebp),%eax
  801f66:	56                   	push   %esi
  801f67:	53                   	push   %ebx
  801f68:	51                   	push   %ecx
  801f69:	52                   	push   %edx
  801f6a:	50                   	push   %eax
  801f6b:	6a 06                	push   $0x6
  801f6d:	e8 56 ff ff ff       	call   801ec8 <syscall>
  801f72:	83 c4 18             	add    $0x18,%esp
}
  801f75:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f78:	5b                   	pop    %ebx
  801f79:	5e                   	pop    %esi
  801f7a:	5d                   	pop    %ebp
  801f7b:	c3                   	ret    

00801f7c <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801f7c:	55                   	push   %ebp
  801f7d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801f7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f82:	8b 45 08             	mov    0x8(%ebp),%eax
  801f85:	6a 00                	push   $0x0
  801f87:	6a 00                	push   $0x0
  801f89:	6a 00                	push   $0x0
  801f8b:	52                   	push   %edx
  801f8c:	50                   	push   %eax
  801f8d:	6a 07                	push   $0x7
  801f8f:	e8 34 ff ff ff       	call   801ec8 <syscall>
  801f94:	83 c4 18             	add    $0x18,%esp
}
  801f97:	c9                   	leave  
  801f98:	c3                   	ret    

00801f99 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801f99:	55                   	push   %ebp
  801f9a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801f9c:	6a 00                	push   $0x0
  801f9e:	6a 00                	push   $0x0
  801fa0:	6a 00                	push   $0x0
  801fa2:	ff 75 0c             	pushl  0xc(%ebp)
  801fa5:	ff 75 08             	pushl  0x8(%ebp)
  801fa8:	6a 08                	push   $0x8
  801faa:	e8 19 ff ff ff       	call   801ec8 <syscall>
  801faf:	83 c4 18             	add    $0x18,%esp
}
  801fb2:	c9                   	leave  
  801fb3:	c3                   	ret    

00801fb4 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801fb4:	55                   	push   %ebp
  801fb5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801fb7:	6a 00                	push   $0x0
  801fb9:	6a 00                	push   $0x0
  801fbb:	6a 00                	push   $0x0
  801fbd:	6a 00                	push   $0x0
  801fbf:	6a 00                	push   $0x0
  801fc1:	6a 09                	push   $0x9
  801fc3:	e8 00 ff ff ff       	call   801ec8 <syscall>
  801fc8:	83 c4 18             	add    $0x18,%esp
}
  801fcb:	c9                   	leave  
  801fcc:	c3                   	ret    

00801fcd <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801fcd:	55                   	push   %ebp
  801fce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801fd0:	6a 00                	push   $0x0
  801fd2:	6a 00                	push   $0x0
  801fd4:	6a 00                	push   $0x0
  801fd6:	6a 00                	push   $0x0
  801fd8:	6a 00                	push   $0x0
  801fda:	6a 0a                	push   $0xa
  801fdc:	e8 e7 fe ff ff       	call   801ec8 <syscall>
  801fe1:	83 c4 18             	add    $0x18,%esp
}
  801fe4:	c9                   	leave  
  801fe5:	c3                   	ret    

00801fe6 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801fe6:	55                   	push   %ebp
  801fe7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801fe9:	6a 00                	push   $0x0
  801feb:	6a 00                	push   $0x0
  801fed:	6a 00                	push   $0x0
  801fef:	6a 00                	push   $0x0
  801ff1:	6a 00                	push   $0x0
  801ff3:	6a 0b                	push   $0xb
  801ff5:	e8 ce fe ff ff       	call   801ec8 <syscall>
  801ffa:	83 c4 18             	add    $0x18,%esp
}
  801ffd:	c9                   	leave  
  801ffe:	c3                   	ret    

00801fff <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801fff:	55                   	push   %ebp
  802000:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802002:	6a 00                	push   $0x0
  802004:	6a 00                	push   $0x0
  802006:	6a 00                	push   $0x0
  802008:	ff 75 0c             	pushl  0xc(%ebp)
  80200b:	ff 75 08             	pushl  0x8(%ebp)
  80200e:	6a 0f                	push   $0xf
  802010:	e8 b3 fe ff ff       	call   801ec8 <syscall>
  802015:	83 c4 18             	add    $0x18,%esp
	return;
  802018:	90                   	nop
}
  802019:	c9                   	leave  
  80201a:	c3                   	ret    

0080201b <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80201b:	55                   	push   %ebp
  80201c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80201e:	6a 00                	push   $0x0
  802020:	6a 00                	push   $0x0
  802022:	6a 00                	push   $0x0
  802024:	ff 75 0c             	pushl  0xc(%ebp)
  802027:	ff 75 08             	pushl  0x8(%ebp)
  80202a:	6a 10                	push   $0x10
  80202c:	e8 97 fe ff ff       	call   801ec8 <syscall>
  802031:	83 c4 18             	add    $0x18,%esp
	return ;
  802034:	90                   	nop
}
  802035:	c9                   	leave  
  802036:	c3                   	ret    

00802037 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802037:	55                   	push   %ebp
  802038:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80203a:	6a 00                	push   $0x0
  80203c:	6a 00                	push   $0x0
  80203e:	ff 75 10             	pushl  0x10(%ebp)
  802041:	ff 75 0c             	pushl  0xc(%ebp)
  802044:	ff 75 08             	pushl  0x8(%ebp)
  802047:	6a 11                	push   $0x11
  802049:	e8 7a fe ff ff       	call   801ec8 <syscall>
  80204e:	83 c4 18             	add    $0x18,%esp
	return ;
  802051:	90                   	nop
}
  802052:	c9                   	leave  
  802053:	c3                   	ret    

00802054 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802054:	55                   	push   %ebp
  802055:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802057:	6a 00                	push   $0x0
  802059:	6a 00                	push   $0x0
  80205b:	6a 00                	push   $0x0
  80205d:	6a 00                	push   $0x0
  80205f:	6a 00                	push   $0x0
  802061:	6a 0c                	push   $0xc
  802063:	e8 60 fe ff ff       	call   801ec8 <syscall>
  802068:	83 c4 18             	add    $0x18,%esp
}
  80206b:	c9                   	leave  
  80206c:	c3                   	ret    

0080206d <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80206d:	55                   	push   %ebp
  80206e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802070:	6a 00                	push   $0x0
  802072:	6a 00                	push   $0x0
  802074:	6a 00                	push   $0x0
  802076:	6a 00                	push   $0x0
  802078:	ff 75 08             	pushl  0x8(%ebp)
  80207b:	6a 0d                	push   $0xd
  80207d:	e8 46 fe ff ff       	call   801ec8 <syscall>
  802082:	83 c4 18             	add    $0x18,%esp
}
  802085:	c9                   	leave  
  802086:	c3                   	ret    

00802087 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802087:	55                   	push   %ebp
  802088:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80208a:	6a 00                	push   $0x0
  80208c:	6a 00                	push   $0x0
  80208e:	6a 00                	push   $0x0
  802090:	6a 00                	push   $0x0
  802092:	6a 00                	push   $0x0
  802094:	6a 0e                	push   $0xe
  802096:	e8 2d fe ff ff       	call   801ec8 <syscall>
  80209b:	83 c4 18             	add    $0x18,%esp
}
  80209e:	90                   	nop
  80209f:	c9                   	leave  
  8020a0:	c3                   	ret    

008020a1 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8020a1:	55                   	push   %ebp
  8020a2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8020a4:	6a 00                	push   $0x0
  8020a6:	6a 00                	push   $0x0
  8020a8:	6a 00                	push   $0x0
  8020aa:	6a 00                	push   $0x0
  8020ac:	6a 00                	push   $0x0
  8020ae:	6a 13                	push   $0x13
  8020b0:	e8 13 fe ff ff       	call   801ec8 <syscall>
  8020b5:	83 c4 18             	add    $0x18,%esp
}
  8020b8:	90                   	nop
  8020b9:	c9                   	leave  
  8020ba:	c3                   	ret    

008020bb <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8020bb:	55                   	push   %ebp
  8020bc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8020be:	6a 00                	push   $0x0
  8020c0:	6a 00                	push   $0x0
  8020c2:	6a 00                	push   $0x0
  8020c4:	6a 00                	push   $0x0
  8020c6:	6a 00                	push   $0x0
  8020c8:	6a 14                	push   $0x14
  8020ca:	e8 f9 fd ff ff       	call   801ec8 <syscall>
  8020cf:	83 c4 18             	add    $0x18,%esp
}
  8020d2:	90                   	nop
  8020d3:	c9                   	leave  
  8020d4:	c3                   	ret    

008020d5 <sys_cputc>:


void
sys_cputc(const char c)
{
  8020d5:	55                   	push   %ebp
  8020d6:	89 e5                	mov    %esp,%ebp
  8020d8:	83 ec 04             	sub    $0x4,%esp
  8020db:	8b 45 08             	mov    0x8(%ebp),%eax
  8020de:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8020e1:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8020e5:	6a 00                	push   $0x0
  8020e7:	6a 00                	push   $0x0
  8020e9:	6a 00                	push   $0x0
  8020eb:	6a 00                	push   $0x0
  8020ed:	50                   	push   %eax
  8020ee:	6a 15                	push   $0x15
  8020f0:	e8 d3 fd ff ff       	call   801ec8 <syscall>
  8020f5:	83 c4 18             	add    $0x18,%esp
}
  8020f8:	90                   	nop
  8020f9:	c9                   	leave  
  8020fa:	c3                   	ret    

008020fb <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8020fb:	55                   	push   %ebp
  8020fc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8020fe:	6a 00                	push   $0x0
  802100:	6a 00                	push   $0x0
  802102:	6a 00                	push   $0x0
  802104:	6a 00                	push   $0x0
  802106:	6a 00                	push   $0x0
  802108:	6a 16                	push   $0x16
  80210a:	e8 b9 fd ff ff       	call   801ec8 <syscall>
  80210f:	83 c4 18             	add    $0x18,%esp
}
  802112:	90                   	nop
  802113:	c9                   	leave  
  802114:	c3                   	ret    

00802115 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802115:	55                   	push   %ebp
  802116:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802118:	8b 45 08             	mov    0x8(%ebp),%eax
  80211b:	6a 00                	push   $0x0
  80211d:	6a 00                	push   $0x0
  80211f:	6a 00                	push   $0x0
  802121:	ff 75 0c             	pushl  0xc(%ebp)
  802124:	50                   	push   %eax
  802125:	6a 17                	push   $0x17
  802127:	e8 9c fd ff ff       	call   801ec8 <syscall>
  80212c:	83 c4 18             	add    $0x18,%esp
}
  80212f:	c9                   	leave  
  802130:	c3                   	ret    

00802131 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802131:	55                   	push   %ebp
  802132:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802134:	8b 55 0c             	mov    0xc(%ebp),%edx
  802137:	8b 45 08             	mov    0x8(%ebp),%eax
  80213a:	6a 00                	push   $0x0
  80213c:	6a 00                	push   $0x0
  80213e:	6a 00                	push   $0x0
  802140:	52                   	push   %edx
  802141:	50                   	push   %eax
  802142:	6a 1a                	push   $0x1a
  802144:	e8 7f fd ff ff       	call   801ec8 <syscall>
  802149:	83 c4 18             	add    $0x18,%esp
}
  80214c:	c9                   	leave  
  80214d:	c3                   	ret    

0080214e <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80214e:	55                   	push   %ebp
  80214f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802151:	8b 55 0c             	mov    0xc(%ebp),%edx
  802154:	8b 45 08             	mov    0x8(%ebp),%eax
  802157:	6a 00                	push   $0x0
  802159:	6a 00                	push   $0x0
  80215b:	6a 00                	push   $0x0
  80215d:	52                   	push   %edx
  80215e:	50                   	push   %eax
  80215f:	6a 18                	push   $0x18
  802161:	e8 62 fd ff ff       	call   801ec8 <syscall>
  802166:	83 c4 18             	add    $0x18,%esp
}
  802169:	90                   	nop
  80216a:	c9                   	leave  
  80216b:	c3                   	ret    

0080216c <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80216c:	55                   	push   %ebp
  80216d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80216f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802172:	8b 45 08             	mov    0x8(%ebp),%eax
  802175:	6a 00                	push   $0x0
  802177:	6a 00                	push   $0x0
  802179:	6a 00                	push   $0x0
  80217b:	52                   	push   %edx
  80217c:	50                   	push   %eax
  80217d:	6a 19                	push   $0x19
  80217f:	e8 44 fd ff ff       	call   801ec8 <syscall>
  802184:	83 c4 18             	add    $0x18,%esp
}
  802187:	90                   	nop
  802188:	c9                   	leave  
  802189:	c3                   	ret    

0080218a <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80218a:	55                   	push   %ebp
  80218b:	89 e5                	mov    %esp,%ebp
  80218d:	83 ec 04             	sub    $0x4,%esp
  802190:	8b 45 10             	mov    0x10(%ebp),%eax
  802193:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802196:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802199:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80219d:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a0:	6a 00                	push   $0x0
  8021a2:	51                   	push   %ecx
  8021a3:	52                   	push   %edx
  8021a4:	ff 75 0c             	pushl  0xc(%ebp)
  8021a7:	50                   	push   %eax
  8021a8:	6a 1b                	push   $0x1b
  8021aa:	e8 19 fd ff ff       	call   801ec8 <syscall>
  8021af:	83 c4 18             	add    $0x18,%esp
}
  8021b2:	c9                   	leave  
  8021b3:	c3                   	ret    

008021b4 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8021b4:	55                   	push   %ebp
  8021b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8021b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bd:	6a 00                	push   $0x0
  8021bf:	6a 00                	push   $0x0
  8021c1:	6a 00                	push   $0x0
  8021c3:	52                   	push   %edx
  8021c4:	50                   	push   %eax
  8021c5:	6a 1c                	push   $0x1c
  8021c7:	e8 fc fc ff ff       	call   801ec8 <syscall>
  8021cc:	83 c4 18             	add    $0x18,%esp
}
  8021cf:	c9                   	leave  
  8021d0:	c3                   	ret    

008021d1 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8021d1:	55                   	push   %ebp
  8021d2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8021d4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021da:	8b 45 08             	mov    0x8(%ebp),%eax
  8021dd:	6a 00                	push   $0x0
  8021df:	6a 00                	push   $0x0
  8021e1:	51                   	push   %ecx
  8021e2:	52                   	push   %edx
  8021e3:	50                   	push   %eax
  8021e4:	6a 1d                	push   $0x1d
  8021e6:	e8 dd fc ff ff       	call   801ec8 <syscall>
  8021eb:	83 c4 18             	add    $0x18,%esp
}
  8021ee:	c9                   	leave  
  8021ef:	c3                   	ret    

008021f0 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8021f0:	55                   	push   %ebp
  8021f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8021f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f9:	6a 00                	push   $0x0
  8021fb:	6a 00                	push   $0x0
  8021fd:	6a 00                	push   $0x0
  8021ff:	52                   	push   %edx
  802200:	50                   	push   %eax
  802201:	6a 1e                	push   $0x1e
  802203:	e8 c0 fc ff ff       	call   801ec8 <syscall>
  802208:	83 c4 18             	add    $0x18,%esp
}
  80220b:	c9                   	leave  
  80220c:	c3                   	ret    

0080220d <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80220d:	55                   	push   %ebp
  80220e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802210:	6a 00                	push   $0x0
  802212:	6a 00                	push   $0x0
  802214:	6a 00                	push   $0x0
  802216:	6a 00                	push   $0x0
  802218:	6a 00                	push   $0x0
  80221a:	6a 1f                	push   $0x1f
  80221c:	e8 a7 fc ff ff       	call   801ec8 <syscall>
  802221:	83 c4 18             	add    $0x18,%esp
}
  802224:	c9                   	leave  
  802225:	c3                   	ret    

00802226 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802226:	55                   	push   %ebp
  802227:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802229:	8b 45 08             	mov    0x8(%ebp),%eax
  80222c:	6a 00                	push   $0x0
  80222e:	ff 75 14             	pushl  0x14(%ebp)
  802231:	ff 75 10             	pushl  0x10(%ebp)
  802234:	ff 75 0c             	pushl  0xc(%ebp)
  802237:	50                   	push   %eax
  802238:	6a 20                	push   $0x20
  80223a:	e8 89 fc ff ff       	call   801ec8 <syscall>
  80223f:	83 c4 18             	add    $0x18,%esp
}
  802242:	c9                   	leave  
  802243:	c3                   	ret    

00802244 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802244:	55                   	push   %ebp
  802245:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802247:	8b 45 08             	mov    0x8(%ebp),%eax
  80224a:	6a 00                	push   $0x0
  80224c:	6a 00                	push   $0x0
  80224e:	6a 00                	push   $0x0
  802250:	6a 00                	push   $0x0
  802252:	50                   	push   %eax
  802253:	6a 21                	push   $0x21
  802255:	e8 6e fc ff ff       	call   801ec8 <syscall>
  80225a:	83 c4 18             	add    $0x18,%esp
}
  80225d:	90                   	nop
  80225e:	c9                   	leave  
  80225f:	c3                   	ret    

00802260 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802260:	55                   	push   %ebp
  802261:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802263:	8b 45 08             	mov    0x8(%ebp),%eax
  802266:	6a 00                	push   $0x0
  802268:	6a 00                	push   $0x0
  80226a:	6a 00                	push   $0x0
  80226c:	6a 00                	push   $0x0
  80226e:	50                   	push   %eax
  80226f:	6a 22                	push   $0x22
  802271:	e8 52 fc ff ff       	call   801ec8 <syscall>
  802276:	83 c4 18             	add    $0x18,%esp
}
  802279:	c9                   	leave  
  80227a:	c3                   	ret    

0080227b <sys_getenvid>:

int32 sys_getenvid(void)
{
  80227b:	55                   	push   %ebp
  80227c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80227e:	6a 00                	push   $0x0
  802280:	6a 00                	push   $0x0
  802282:	6a 00                	push   $0x0
  802284:	6a 00                	push   $0x0
  802286:	6a 00                	push   $0x0
  802288:	6a 02                	push   $0x2
  80228a:	e8 39 fc ff ff       	call   801ec8 <syscall>
  80228f:	83 c4 18             	add    $0x18,%esp
}
  802292:	c9                   	leave  
  802293:	c3                   	ret    

00802294 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802294:	55                   	push   %ebp
  802295:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802297:	6a 00                	push   $0x0
  802299:	6a 00                	push   $0x0
  80229b:	6a 00                	push   $0x0
  80229d:	6a 00                	push   $0x0
  80229f:	6a 00                	push   $0x0
  8022a1:	6a 03                	push   $0x3
  8022a3:	e8 20 fc ff ff       	call   801ec8 <syscall>
  8022a8:	83 c4 18             	add    $0x18,%esp
}
  8022ab:	c9                   	leave  
  8022ac:	c3                   	ret    

008022ad <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8022ad:	55                   	push   %ebp
  8022ae:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8022b0:	6a 00                	push   $0x0
  8022b2:	6a 00                	push   $0x0
  8022b4:	6a 00                	push   $0x0
  8022b6:	6a 00                	push   $0x0
  8022b8:	6a 00                	push   $0x0
  8022ba:	6a 04                	push   $0x4
  8022bc:	e8 07 fc ff ff       	call   801ec8 <syscall>
  8022c1:	83 c4 18             	add    $0x18,%esp
}
  8022c4:	c9                   	leave  
  8022c5:	c3                   	ret    

008022c6 <sys_exit_env>:


void sys_exit_env(void)
{
  8022c6:	55                   	push   %ebp
  8022c7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8022c9:	6a 00                	push   $0x0
  8022cb:	6a 00                	push   $0x0
  8022cd:	6a 00                	push   $0x0
  8022cf:	6a 00                	push   $0x0
  8022d1:	6a 00                	push   $0x0
  8022d3:	6a 23                	push   $0x23
  8022d5:	e8 ee fb ff ff       	call   801ec8 <syscall>
  8022da:	83 c4 18             	add    $0x18,%esp
}
  8022dd:	90                   	nop
  8022de:	c9                   	leave  
  8022df:	c3                   	ret    

008022e0 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8022e0:	55                   	push   %ebp
  8022e1:	89 e5                	mov    %esp,%ebp
  8022e3:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8022e6:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8022e9:	8d 50 04             	lea    0x4(%eax),%edx
  8022ec:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8022ef:	6a 00                	push   $0x0
  8022f1:	6a 00                	push   $0x0
  8022f3:	6a 00                	push   $0x0
  8022f5:	52                   	push   %edx
  8022f6:	50                   	push   %eax
  8022f7:	6a 24                	push   $0x24
  8022f9:	e8 ca fb ff ff       	call   801ec8 <syscall>
  8022fe:	83 c4 18             	add    $0x18,%esp
	return result;
  802301:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802304:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802307:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80230a:	89 01                	mov    %eax,(%ecx)
  80230c:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80230f:	8b 45 08             	mov    0x8(%ebp),%eax
  802312:	c9                   	leave  
  802313:	c2 04 00             	ret    $0x4

00802316 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802316:	55                   	push   %ebp
  802317:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802319:	6a 00                	push   $0x0
  80231b:	6a 00                	push   $0x0
  80231d:	ff 75 10             	pushl  0x10(%ebp)
  802320:	ff 75 0c             	pushl  0xc(%ebp)
  802323:	ff 75 08             	pushl  0x8(%ebp)
  802326:	6a 12                	push   $0x12
  802328:	e8 9b fb ff ff       	call   801ec8 <syscall>
  80232d:	83 c4 18             	add    $0x18,%esp
	return ;
  802330:	90                   	nop
}
  802331:	c9                   	leave  
  802332:	c3                   	ret    

00802333 <sys_rcr2>:
uint32 sys_rcr2()
{
  802333:	55                   	push   %ebp
  802334:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802336:	6a 00                	push   $0x0
  802338:	6a 00                	push   $0x0
  80233a:	6a 00                	push   $0x0
  80233c:	6a 00                	push   $0x0
  80233e:	6a 00                	push   $0x0
  802340:	6a 25                	push   $0x25
  802342:	e8 81 fb ff ff       	call   801ec8 <syscall>
  802347:	83 c4 18             	add    $0x18,%esp
}
  80234a:	c9                   	leave  
  80234b:	c3                   	ret    

0080234c <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80234c:	55                   	push   %ebp
  80234d:	89 e5                	mov    %esp,%ebp
  80234f:	83 ec 04             	sub    $0x4,%esp
  802352:	8b 45 08             	mov    0x8(%ebp),%eax
  802355:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802358:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80235c:	6a 00                	push   $0x0
  80235e:	6a 00                	push   $0x0
  802360:	6a 00                	push   $0x0
  802362:	6a 00                	push   $0x0
  802364:	50                   	push   %eax
  802365:	6a 26                	push   $0x26
  802367:	e8 5c fb ff ff       	call   801ec8 <syscall>
  80236c:	83 c4 18             	add    $0x18,%esp
	return ;
  80236f:	90                   	nop
}
  802370:	c9                   	leave  
  802371:	c3                   	ret    

00802372 <rsttst>:
void rsttst()
{
  802372:	55                   	push   %ebp
  802373:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802375:	6a 00                	push   $0x0
  802377:	6a 00                	push   $0x0
  802379:	6a 00                	push   $0x0
  80237b:	6a 00                	push   $0x0
  80237d:	6a 00                	push   $0x0
  80237f:	6a 28                	push   $0x28
  802381:	e8 42 fb ff ff       	call   801ec8 <syscall>
  802386:	83 c4 18             	add    $0x18,%esp
	return ;
  802389:	90                   	nop
}
  80238a:	c9                   	leave  
  80238b:	c3                   	ret    

0080238c <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80238c:	55                   	push   %ebp
  80238d:	89 e5                	mov    %esp,%ebp
  80238f:	83 ec 04             	sub    $0x4,%esp
  802392:	8b 45 14             	mov    0x14(%ebp),%eax
  802395:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802398:	8b 55 18             	mov    0x18(%ebp),%edx
  80239b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80239f:	52                   	push   %edx
  8023a0:	50                   	push   %eax
  8023a1:	ff 75 10             	pushl  0x10(%ebp)
  8023a4:	ff 75 0c             	pushl  0xc(%ebp)
  8023a7:	ff 75 08             	pushl  0x8(%ebp)
  8023aa:	6a 27                	push   $0x27
  8023ac:	e8 17 fb ff ff       	call   801ec8 <syscall>
  8023b1:	83 c4 18             	add    $0x18,%esp
	return ;
  8023b4:	90                   	nop
}
  8023b5:	c9                   	leave  
  8023b6:	c3                   	ret    

008023b7 <chktst>:
void chktst(uint32 n)
{
  8023b7:	55                   	push   %ebp
  8023b8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8023ba:	6a 00                	push   $0x0
  8023bc:	6a 00                	push   $0x0
  8023be:	6a 00                	push   $0x0
  8023c0:	6a 00                	push   $0x0
  8023c2:	ff 75 08             	pushl  0x8(%ebp)
  8023c5:	6a 29                	push   $0x29
  8023c7:	e8 fc fa ff ff       	call   801ec8 <syscall>
  8023cc:	83 c4 18             	add    $0x18,%esp
	return ;
  8023cf:	90                   	nop
}
  8023d0:	c9                   	leave  
  8023d1:	c3                   	ret    

008023d2 <inctst>:

void inctst()
{
  8023d2:	55                   	push   %ebp
  8023d3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8023d5:	6a 00                	push   $0x0
  8023d7:	6a 00                	push   $0x0
  8023d9:	6a 00                	push   $0x0
  8023db:	6a 00                	push   $0x0
  8023dd:	6a 00                	push   $0x0
  8023df:	6a 2a                	push   $0x2a
  8023e1:	e8 e2 fa ff ff       	call   801ec8 <syscall>
  8023e6:	83 c4 18             	add    $0x18,%esp
	return ;
  8023e9:	90                   	nop
}
  8023ea:	c9                   	leave  
  8023eb:	c3                   	ret    

008023ec <gettst>:
uint32 gettst()
{
  8023ec:	55                   	push   %ebp
  8023ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8023ef:	6a 00                	push   $0x0
  8023f1:	6a 00                	push   $0x0
  8023f3:	6a 00                	push   $0x0
  8023f5:	6a 00                	push   $0x0
  8023f7:	6a 00                	push   $0x0
  8023f9:	6a 2b                	push   $0x2b
  8023fb:	e8 c8 fa ff ff       	call   801ec8 <syscall>
  802400:	83 c4 18             	add    $0x18,%esp
}
  802403:	c9                   	leave  
  802404:	c3                   	ret    

00802405 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802405:	55                   	push   %ebp
  802406:	89 e5                	mov    %esp,%ebp
  802408:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80240b:	6a 00                	push   $0x0
  80240d:	6a 00                	push   $0x0
  80240f:	6a 00                	push   $0x0
  802411:	6a 00                	push   $0x0
  802413:	6a 00                	push   $0x0
  802415:	6a 2c                	push   $0x2c
  802417:	e8 ac fa ff ff       	call   801ec8 <syscall>
  80241c:	83 c4 18             	add    $0x18,%esp
  80241f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802422:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802426:	75 07                	jne    80242f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802428:	b8 01 00 00 00       	mov    $0x1,%eax
  80242d:	eb 05                	jmp    802434 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80242f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802434:	c9                   	leave  
  802435:	c3                   	ret    

00802436 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802436:	55                   	push   %ebp
  802437:	89 e5                	mov    %esp,%ebp
  802439:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80243c:	6a 00                	push   $0x0
  80243e:	6a 00                	push   $0x0
  802440:	6a 00                	push   $0x0
  802442:	6a 00                	push   $0x0
  802444:	6a 00                	push   $0x0
  802446:	6a 2c                	push   $0x2c
  802448:	e8 7b fa ff ff       	call   801ec8 <syscall>
  80244d:	83 c4 18             	add    $0x18,%esp
  802450:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802453:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802457:	75 07                	jne    802460 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802459:	b8 01 00 00 00       	mov    $0x1,%eax
  80245e:	eb 05                	jmp    802465 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802460:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802465:	c9                   	leave  
  802466:	c3                   	ret    

00802467 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802467:	55                   	push   %ebp
  802468:	89 e5                	mov    %esp,%ebp
  80246a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80246d:	6a 00                	push   $0x0
  80246f:	6a 00                	push   $0x0
  802471:	6a 00                	push   $0x0
  802473:	6a 00                	push   $0x0
  802475:	6a 00                	push   $0x0
  802477:	6a 2c                	push   $0x2c
  802479:	e8 4a fa ff ff       	call   801ec8 <syscall>
  80247e:	83 c4 18             	add    $0x18,%esp
  802481:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802484:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802488:	75 07                	jne    802491 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80248a:	b8 01 00 00 00       	mov    $0x1,%eax
  80248f:	eb 05                	jmp    802496 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802491:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802496:	c9                   	leave  
  802497:	c3                   	ret    

00802498 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802498:	55                   	push   %ebp
  802499:	89 e5                	mov    %esp,%ebp
  80249b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80249e:	6a 00                	push   $0x0
  8024a0:	6a 00                	push   $0x0
  8024a2:	6a 00                	push   $0x0
  8024a4:	6a 00                	push   $0x0
  8024a6:	6a 00                	push   $0x0
  8024a8:	6a 2c                	push   $0x2c
  8024aa:	e8 19 fa ff ff       	call   801ec8 <syscall>
  8024af:	83 c4 18             	add    $0x18,%esp
  8024b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8024b5:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8024b9:	75 07                	jne    8024c2 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8024bb:	b8 01 00 00 00       	mov    $0x1,%eax
  8024c0:	eb 05                	jmp    8024c7 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8024c2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024c7:	c9                   	leave  
  8024c8:	c3                   	ret    

008024c9 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8024c9:	55                   	push   %ebp
  8024ca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8024cc:	6a 00                	push   $0x0
  8024ce:	6a 00                	push   $0x0
  8024d0:	6a 00                	push   $0x0
  8024d2:	6a 00                	push   $0x0
  8024d4:	ff 75 08             	pushl  0x8(%ebp)
  8024d7:	6a 2d                	push   $0x2d
  8024d9:	e8 ea f9 ff ff       	call   801ec8 <syscall>
  8024de:	83 c4 18             	add    $0x18,%esp
	return ;
  8024e1:	90                   	nop
}
  8024e2:	c9                   	leave  
  8024e3:	c3                   	ret    

008024e4 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8024e4:	55                   	push   %ebp
  8024e5:	89 e5                	mov    %esp,%ebp
  8024e7:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8024e8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8024eb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8024ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f4:	6a 00                	push   $0x0
  8024f6:	53                   	push   %ebx
  8024f7:	51                   	push   %ecx
  8024f8:	52                   	push   %edx
  8024f9:	50                   	push   %eax
  8024fa:	6a 2e                	push   $0x2e
  8024fc:	e8 c7 f9 ff ff       	call   801ec8 <syscall>
  802501:	83 c4 18             	add    $0x18,%esp
}
  802504:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802507:	c9                   	leave  
  802508:	c3                   	ret    

00802509 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802509:	55                   	push   %ebp
  80250a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80250c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80250f:	8b 45 08             	mov    0x8(%ebp),%eax
  802512:	6a 00                	push   $0x0
  802514:	6a 00                	push   $0x0
  802516:	6a 00                	push   $0x0
  802518:	52                   	push   %edx
  802519:	50                   	push   %eax
  80251a:	6a 2f                	push   $0x2f
  80251c:	e8 a7 f9 ff ff       	call   801ec8 <syscall>
  802521:	83 c4 18             	add    $0x18,%esp
}
  802524:	c9                   	leave  
  802525:	c3                   	ret    

00802526 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802526:	55                   	push   %ebp
  802527:	89 e5                	mov    %esp,%ebp
  802529:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  80252c:	83 ec 0c             	sub    $0xc,%esp
  80252f:	68 dc 46 80 00       	push   $0x8046dc
  802534:	e8 18 e6 ff ff       	call   800b51 <cprintf>
  802539:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80253c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802543:	83 ec 0c             	sub    $0xc,%esp
  802546:	68 08 47 80 00       	push   $0x804708
  80254b:	e8 01 e6 ff ff       	call   800b51 <cprintf>
  802550:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802553:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802557:	a1 38 51 80 00       	mov    0x805138,%eax
  80255c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80255f:	eb 56                	jmp    8025b7 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802561:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802565:	74 1c                	je     802583 <print_mem_block_lists+0x5d>
  802567:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256a:	8b 50 08             	mov    0x8(%eax),%edx
  80256d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802570:	8b 48 08             	mov    0x8(%eax),%ecx
  802573:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802576:	8b 40 0c             	mov    0xc(%eax),%eax
  802579:	01 c8                	add    %ecx,%eax
  80257b:	39 c2                	cmp    %eax,%edx
  80257d:	73 04                	jae    802583 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  80257f:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802583:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802586:	8b 50 08             	mov    0x8(%eax),%edx
  802589:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258c:	8b 40 0c             	mov    0xc(%eax),%eax
  80258f:	01 c2                	add    %eax,%edx
  802591:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802594:	8b 40 08             	mov    0x8(%eax),%eax
  802597:	83 ec 04             	sub    $0x4,%esp
  80259a:	52                   	push   %edx
  80259b:	50                   	push   %eax
  80259c:	68 1d 47 80 00       	push   $0x80471d
  8025a1:	e8 ab e5 ff ff       	call   800b51 <cprintf>
  8025a6:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8025a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8025af:	a1 40 51 80 00       	mov    0x805140,%eax
  8025b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025bb:	74 07                	je     8025c4 <print_mem_block_lists+0x9e>
  8025bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c0:	8b 00                	mov    (%eax),%eax
  8025c2:	eb 05                	jmp    8025c9 <print_mem_block_lists+0xa3>
  8025c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8025c9:	a3 40 51 80 00       	mov    %eax,0x805140
  8025ce:	a1 40 51 80 00       	mov    0x805140,%eax
  8025d3:	85 c0                	test   %eax,%eax
  8025d5:	75 8a                	jne    802561 <print_mem_block_lists+0x3b>
  8025d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025db:	75 84                	jne    802561 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8025dd:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8025e1:	75 10                	jne    8025f3 <print_mem_block_lists+0xcd>
  8025e3:	83 ec 0c             	sub    $0xc,%esp
  8025e6:	68 2c 47 80 00       	push   $0x80472c
  8025eb:	e8 61 e5 ff ff       	call   800b51 <cprintf>
  8025f0:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8025f3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8025fa:	83 ec 0c             	sub    $0xc,%esp
  8025fd:	68 50 47 80 00       	push   $0x804750
  802602:	e8 4a e5 ff ff       	call   800b51 <cprintf>
  802607:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80260a:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80260e:	a1 40 50 80 00       	mov    0x805040,%eax
  802613:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802616:	eb 56                	jmp    80266e <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802618:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80261c:	74 1c                	je     80263a <print_mem_block_lists+0x114>
  80261e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802621:	8b 50 08             	mov    0x8(%eax),%edx
  802624:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802627:	8b 48 08             	mov    0x8(%eax),%ecx
  80262a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80262d:	8b 40 0c             	mov    0xc(%eax),%eax
  802630:	01 c8                	add    %ecx,%eax
  802632:	39 c2                	cmp    %eax,%edx
  802634:	73 04                	jae    80263a <print_mem_block_lists+0x114>
			sorted = 0 ;
  802636:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80263a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263d:	8b 50 08             	mov    0x8(%eax),%edx
  802640:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802643:	8b 40 0c             	mov    0xc(%eax),%eax
  802646:	01 c2                	add    %eax,%edx
  802648:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264b:	8b 40 08             	mov    0x8(%eax),%eax
  80264e:	83 ec 04             	sub    $0x4,%esp
  802651:	52                   	push   %edx
  802652:	50                   	push   %eax
  802653:	68 1d 47 80 00       	push   $0x80471d
  802658:	e8 f4 e4 ff ff       	call   800b51 <cprintf>
  80265d:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802660:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802663:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802666:	a1 48 50 80 00       	mov    0x805048,%eax
  80266b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80266e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802672:	74 07                	je     80267b <print_mem_block_lists+0x155>
  802674:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802677:	8b 00                	mov    (%eax),%eax
  802679:	eb 05                	jmp    802680 <print_mem_block_lists+0x15a>
  80267b:	b8 00 00 00 00       	mov    $0x0,%eax
  802680:	a3 48 50 80 00       	mov    %eax,0x805048
  802685:	a1 48 50 80 00       	mov    0x805048,%eax
  80268a:	85 c0                	test   %eax,%eax
  80268c:	75 8a                	jne    802618 <print_mem_block_lists+0xf2>
  80268e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802692:	75 84                	jne    802618 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802694:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802698:	75 10                	jne    8026aa <print_mem_block_lists+0x184>
  80269a:	83 ec 0c             	sub    $0xc,%esp
  80269d:	68 68 47 80 00       	push   $0x804768
  8026a2:	e8 aa e4 ff ff       	call   800b51 <cprintf>
  8026a7:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8026aa:	83 ec 0c             	sub    $0xc,%esp
  8026ad:	68 dc 46 80 00       	push   $0x8046dc
  8026b2:	e8 9a e4 ff ff       	call   800b51 <cprintf>
  8026b7:	83 c4 10             	add    $0x10,%esp

}
  8026ba:	90                   	nop
  8026bb:	c9                   	leave  
  8026bc:	c3                   	ret    

008026bd <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8026bd:	55                   	push   %ebp
  8026be:	89 e5                	mov    %esp,%ebp
  8026c0:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  8026c3:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8026ca:	00 00 00 
  8026cd:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8026d4:	00 00 00 
  8026d7:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8026de:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  8026e1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8026e8:	e9 9e 00 00 00       	jmp    80278b <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  8026ed:	a1 50 50 80 00       	mov    0x805050,%eax
  8026f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026f5:	c1 e2 04             	shl    $0x4,%edx
  8026f8:	01 d0                	add    %edx,%eax
  8026fa:	85 c0                	test   %eax,%eax
  8026fc:	75 14                	jne    802712 <initialize_MemBlocksList+0x55>
  8026fe:	83 ec 04             	sub    $0x4,%esp
  802701:	68 90 47 80 00       	push   $0x804790
  802706:	6a 46                	push   $0x46
  802708:	68 b3 47 80 00       	push   $0x8047b3
  80270d:	e8 8b e1 ff ff       	call   80089d <_panic>
  802712:	a1 50 50 80 00       	mov    0x805050,%eax
  802717:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80271a:	c1 e2 04             	shl    $0x4,%edx
  80271d:	01 d0                	add    %edx,%eax
  80271f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802725:	89 10                	mov    %edx,(%eax)
  802727:	8b 00                	mov    (%eax),%eax
  802729:	85 c0                	test   %eax,%eax
  80272b:	74 18                	je     802745 <initialize_MemBlocksList+0x88>
  80272d:	a1 48 51 80 00       	mov    0x805148,%eax
  802732:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802738:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80273b:	c1 e1 04             	shl    $0x4,%ecx
  80273e:	01 ca                	add    %ecx,%edx
  802740:	89 50 04             	mov    %edx,0x4(%eax)
  802743:	eb 12                	jmp    802757 <initialize_MemBlocksList+0x9a>
  802745:	a1 50 50 80 00       	mov    0x805050,%eax
  80274a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80274d:	c1 e2 04             	shl    $0x4,%edx
  802750:	01 d0                	add    %edx,%eax
  802752:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802757:	a1 50 50 80 00       	mov    0x805050,%eax
  80275c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80275f:	c1 e2 04             	shl    $0x4,%edx
  802762:	01 d0                	add    %edx,%eax
  802764:	a3 48 51 80 00       	mov    %eax,0x805148
  802769:	a1 50 50 80 00       	mov    0x805050,%eax
  80276e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802771:	c1 e2 04             	shl    $0x4,%edx
  802774:	01 d0                	add    %edx,%eax
  802776:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80277d:	a1 54 51 80 00       	mov    0x805154,%eax
  802782:	40                   	inc    %eax
  802783:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802788:	ff 45 f4             	incl   -0xc(%ebp)
  80278b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802791:	0f 82 56 ff ff ff    	jb     8026ed <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802797:	90                   	nop
  802798:	c9                   	leave  
  802799:	c3                   	ret    

0080279a <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80279a:	55                   	push   %ebp
  80279b:	89 e5                	mov    %esp,%ebp
  80279d:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8027a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a3:	8b 00                	mov    (%eax),%eax
  8027a5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8027a8:	eb 19                	jmp    8027c3 <find_block+0x29>
	{
		if(va==point->sva)
  8027aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8027ad:	8b 40 08             	mov    0x8(%eax),%eax
  8027b0:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8027b3:	75 05                	jne    8027ba <find_block+0x20>
		   return point;
  8027b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8027b8:	eb 36                	jmp    8027f0 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8027ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8027bd:	8b 40 08             	mov    0x8(%eax),%eax
  8027c0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8027c3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8027c7:	74 07                	je     8027d0 <find_block+0x36>
  8027c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8027cc:	8b 00                	mov    (%eax),%eax
  8027ce:	eb 05                	jmp    8027d5 <find_block+0x3b>
  8027d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8027d5:	8b 55 08             	mov    0x8(%ebp),%edx
  8027d8:	89 42 08             	mov    %eax,0x8(%edx)
  8027db:	8b 45 08             	mov    0x8(%ebp),%eax
  8027de:	8b 40 08             	mov    0x8(%eax),%eax
  8027e1:	85 c0                	test   %eax,%eax
  8027e3:	75 c5                	jne    8027aa <find_block+0x10>
  8027e5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8027e9:	75 bf                	jne    8027aa <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  8027eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027f0:	c9                   	leave  
  8027f1:	c3                   	ret    

008027f2 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8027f2:	55                   	push   %ebp
  8027f3:	89 e5                	mov    %esp,%ebp
  8027f5:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  8027f8:	a1 40 50 80 00       	mov    0x805040,%eax
  8027fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802800:	a1 44 50 80 00       	mov    0x805044,%eax
  802805:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802808:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80280b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80280e:	74 24                	je     802834 <insert_sorted_allocList+0x42>
  802810:	8b 45 08             	mov    0x8(%ebp),%eax
  802813:	8b 50 08             	mov    0x8(%eax),%edx
  802816:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802819:	8b 40 08             	mov    0x8(%eax),%eax
  80281c:	39 c2                	cmp    %eax,%edx
  80281e:	76 14                	jbe    802834 <insert_sorted_allocList+0x42>
  802820:	8b 45 08             	mov    0x8(%ebp),%eax
  802823:	8b 50 08             	mov    0x8(%eax),%edx
  802826:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802829:	8b 40 08             	mov    0x8(%eax),%eax
  80282c:	39 c2                	cmp    %eax,%edx
  80282e:	0f 82 60 01 00 00    	jb     802994 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802834:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802838:	75 65                	jne    80289f <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  80283a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80283e:	75 14                	jne    802854 <insert_sorted_allocList+0x62>
  802840:	83 ec 04             	sub    $0x4,%esp
  802843:	68 90 47 80 00       	push   $0x804790
  802848:	6a 6b                	push   $0x6b
  80284a:	68 b3 47 80 00       	push   $0x8047b3
  80284f:	e8 49 e0 ff ff       	call   80089d <_panic>
  802854:	8b 15 40 50 80 00    	mov    0x805040,%edx
  80285a:	8b 45 08             	mov    0x8(%ebp),%eax
  80285d:	89 10                	mov    %edx,(%eax)
  80285f:	8b 45 08             	mov    0x8(%ebp),%eax
  802862:	8b 00                	mov    (%eax),%eax
  802864:	85 c0                	test   %eax,%eax
  802866:	74 0d                	je     802875 <insert_sorted_allocList+0x83>
  802868:	a1 40 50 80 00       	mov    0x805040,%eax
  80286d:	8b 55 08             	mov    0x8(%ebp),%edx
  802870:	89 50 04             	mov    %edx,0x4(%eax)
  802873:	eb 08                	jmp    80287d <insert_sorted_allocList+0x8b>
  802875:	8b 45 08             	mov    0x8(%ebp),%eax
  802878:	a3 44 50 80 00       	mov    %eax,0x805044
  80287d:	8b 45 08             	mov    0x8(%ebp),%eax
  802880:	a3 40 50 80 00       	mov    %eax,0x805040
  802885:	8b 45 08             	mov    0x8(%ebp),%eax
  802888:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80288f:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802894:	40                   	inc    %eax
  802895:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80289a:	e9 dc 01 00 00       	jmp    802a7b <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  80289f:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a2:	8b 50 08             	mov    0x8(%eax),%edx
  8028a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028a8:	8b 40 08             	mov    0x8(%eax),%eax
  8028ab:	39 c2                	cmp    %eax,%edx
  8028ad:	77 6c                	ja     80291b <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8028af:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028b3:	74 06                	je     8028bb <insert_sorted_allocList+0xc9>
  8028b5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028b9:	75 14                	jne    8028cf <insert_sorted_allocList+0xdd>
  8028bb:	83 ec 04             	sub    $0x4,%esp
  8028be:	68 cc 47 80 00       	push   $0x8047cc
  8028c3:	6a 6f                	push   $0x6f
  8028c5:	68 b3 47 80 00       	push   $0x8047b3
  8028ca:	e8 ce df ff ff       	call   80089d <_panic>
  8028cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028d2:	8b 50 04             	mov    0x4(%eax),%edx
  8028d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d8:	89 50 04             	mov    %edx,0x4(%eax)
  8028db:	8b 45 08             	mov    0x8(%ebp),%eax
  8028de:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028e1:	89 10                	mov    %edx,(%eax)
  8028e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e6:	8b 40 04             	mov    0x4(%eax),%eax
  8028e9:	85 c0                	test   %eax,%eax
  8028eb:	74 0d                	je     8028fa <insert_sorted_allocList+0x108>
  8028ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028f0:	8b 40 04             	mov    0x4(%eax),%eax
  8028f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8028f6:	89 10                	mov    %edx,(%eax)
  8028f8:	eb 08                	jmp    802902 <insert_sorted_allocList+0x110>
  8028fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8028fd:	a3 40 50 80 00       	mov    %eax,0x805040
  802902:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802905:	8b 55 08             	mov    0x8(%ebp),%edx
  802908:	89 50 04             	mov    %edx,0x4(%eax)
  80290b:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802910:	40                   	inc    %eax
  802911:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802916:	e9 60 01 00 00       	jmp    802a7b <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  80291b:	8b 45 08             	mov    0x8(%ebp),%eax
  80291e:	8b 50 08             	mov    0x8(%eax),%edx
  802921:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802924:	8b 40 08             	mov    0x8(%eax),%eax
  802927:	39 c2                	cmp    %eax,%edx
  802929:	0f 82 4c 01 00 00    	jb     802a7b <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  80292f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802933:	75 14                	jne    802949 <insert_sorted_allocList+0x157>
  802935:	83 ec 04             	sub    $0x4,%esp
  802938:	68 04 48 80 00       	push   $0x804804
  80293d:	6a 73                	push   $0x73
  80293f:	68 b3 47 80 00       	push   $0x8047b3
  802944:	e8 54 df ff ff       	call   80089d <_panic>
  802949:	8b 15 44 50 80 00    	mov    0x805044,%edx
  80294f:	8b 45 08             	mov    0x8(%ebp),%eax
  802952:	89 50 04             	mov    %edx,0x4(%eax)
  802955:	8b 45 08             	mov    0x8(%ebp),%eax
  802958:	8b 40 04             	mov    0x4(%eax),%eax
  80295b:	85 c0                	test   %eax,%eax
  80295d:	74 0c                	je     80296b <insert_sorted_allocList+0x179>
  80295f:	a1 44 50 80 00       	mov    0x805044,%eax
  802964:	8b 55 08             	mov    0x8(%ebp),%edx
  802967:	89 10                	mov    %edx,(%eax)
  802969:	eb 08                	jmp    802973 <insert_sorted_allocList+0x181>
  80296b:	8b 45 08             	mov    0x8(%ebp),%eax
  80296e:	a3 40 50 80 00       	mov    %eax,0x805040
  802973:	8b 45 08             	mov    0x8(%ebp),%eax
  802976:	a3 44 50 80 00       	mov    %eax,0x805044
  80297b:	8b 45 08             	mov    0x8(%ebp),%eax
  80297e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802984:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802989:	40                   	inc    %eax
  80298a:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80298f:	e9 e7 00 00 00       	jmp    802a7b <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802994:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802997:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  80299a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8029a1:	a1 40 50 80 00       	mov    0x805040,%eax
  8029a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029a9:	e9 9d 00 00 00       	jmp    802a4b <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8029ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b1:	8b 00                	mov    (%eax),%eax
  8029b3:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8029b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b9:	8b 50 08             	mov    0x8(%eax),%edx
  8029bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bf:	8b 40 08             	mov    0x8(%eax),%eax
  8029c2:	39 c2                	cmp    %eax,%edx
  8029c4:	76 7d                	jbe    802a43 <insert_sorted_allocList+0x251>
  8029c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c9:	8b 50 08             	mov    0x8(%eax),%edx
  8029cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029cf:	8b 40 08             	mov    0x8(%eax),%eax
  8029d2:	39 c2                	cmp    %eax,%edx
  8029d4:	73 6d                	jae    802a43 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8029d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029da:	74 06                	je     8029e2 <insert_sorted_allocList+0x1f0>
  8029dc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029e0:	75 14                	jne    8029f6 <insert_sorted_allocList+0x204>
  8029e2:	83 ec 04             	sub    $0x4,%esp
  8029e5:	68 28 48 80 00       	push   $0x804828
  8029ea:	6a 7f                	push   $0x7f
  8029ec:	68 b3 47 80 00       	push   $0x8047b3
  8029f1:	e8 a7 de ff ff       	call   80089d <_panic>
  8029f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f9:	8b 10                	mov    (%eax),%edx
  8029fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8029fe:	89 10                	mov    %edx,(%eax)
  802a00:	8b 45 08             	mov    0x8(%ebp),%eax
  802a03:	8b 00                	mov    (%eax),%eax
  802a05:	85 c0                	test   %eax,%eax
  802a07:	74 0b                	je     802a14 <insert_sorted_allocList+0x222>
  802a09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0c:	8b 00                	mov    (%eax),%eax
  802a0e:	8b 55 08             	mov    0x8(%ebp),%edx
  802a11:	89 50 04             	mov    %edx,0x4(%eax)
  802a14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a17:	8b 55 08             	mov    0x8(%ebp),%edx
  802a1a:	89 10                	mov    %edx,(%eax)
  802a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a1f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a22:	89 50 04             	mov    %edx,0x4(%eax)
  802a25:	8b 45 08             	mov    0x8(%ebp),%eax
  802a28:	8b 00                	mov    (%eax),%eax
  802a2a:	85 c0                	test   %eax,%eax
  802a2c:	75 08                	jne    802a36 <insert_sorted_allocList+0x244>
  802a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a31:	a3 44 50 80 00       	mov    %eax,0x805044
  802a36:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802a3b:	40                   	inc    %eax
  802a3c:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802a41:	eb 39                	jmp    802a7c <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802a43:	a1 48 50 80 00       	mov    0x805048,%eax
  802a48:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a4b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a4f:	74 07                	je     802a58 <insert_sorted_allocList+0x266>
  802a51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a54:	8b 00                	mov    (%eax),%eax
  802a56:	eb 05                	jmp    802a5d <insert_sorted_allocList+0x26b>
  802a58:	b8 00 00 00 00       	mov    $0x0,%eax
  802a5d:	a3 48 50 80 00       	mov    %eax,0x805048
  802a62:	a1 48 50 80 00       	mov    0x805048,%eax
  802a67:	85 c0                	test   %eax,%eax
  802a69:	0f 85 3f ff ff ff    	jne    8029ae <insert_sorted_allocList+0x1bc>
  802a6f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a73:	0f 85 35 ff ff ff    	jne    8029ae <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802a79:	eb 01                	jmp    802a7c <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802a7b:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802a7c:	90                   	nop
  802a7d:	c9                   	leave  
  802a7e:	c3                   	ret    

00802a7f <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802a7f:	55                   	push   %ebp
  802a80:	89 e5                	mov    %esp,%ebp
  802a82:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802a85:	a1 38 51 80 00       	mov    0x805138,%eax
  802a8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a8d:	e9 85 01 00 00       	jmp    802c17 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802a92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a95:	8b 40 0c             	mov    0xc(%eax),%eax
  802a98:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a9b:	0f 82 6e 01 00 00    	jb     802c0f <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802aa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa4:	8b 40 0c             	mov    0xc(%eax),%eax
  802aa7:	3b 45 08             	cmp    0x8(%ebp),%eax
  802aaa:	0f 85 8a 00 00 00    	jne    802b3a <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802ab0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ab4:	75 17                	jne    802acd <alloc_block_FF+0x4e>
  802ab6:	83 ec 04             	sub    $0x4,%esp
  802ab9:	68 5c 48 80 00       	push   $0x80485c
  802abe:	68 93 00 00 00       	push   $0x93
  802ac3:	68 b3 47 80 00       	push   $0x8047b3
  802ac8:	e8 d0 dd ff ff       	call   80089d <_panic>
  802acd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad0:	8b 00                	mov    (%eax),%eax
  802ad2:	85 c0                	test   %eax,%eax
  802ad4:	74 10                	je     802ae6 <alloc_block_FF+0x67>
  802ad6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad9:	8b 00                	mov    (%eax),%eax
  802adb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ade:	8b 52 04             	mov    0x4(%edx),%edx
  802ae1:	89 50 04             	mov    %edx,0x4(%eax)
  802ae4:	eb 0b                	jmp    802af1 <alloc_block_FF+0x72>
  802ae6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae9:	8b 40 04             	mov    0x4(%eax),%eax
  802aec:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802af1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af4:	8b 40 04             	mov    0x4(%eax),%eax
  802af7:	85 c0                	test   %eax,%eax
  802af9:	74 0f                	je     802b0a <alloc_block_FF+0x8b>
  802afb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afe:	8b 40 04             	mov    0x4(%eax),%eax
  802b01:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b04:	8b 12                	mov    (%edx),%edx
  802b06:	89 10                	mov    %edx,(%eax)
  802b08:	eb 0a                	jmp    802b14 <alloc_block_FF+0x95>
  802b0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0d:	8b 00                	mov    (%eax),%eax
  802b0f:	a3 38 51 80 00       	mov    %eax,0x805138
  802b14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b17:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b20:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b27:	a1 44 51 80 00       	mov    0x805144,%eax
  802b2c:	48                   	dec    %eax
  802b2d:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802b32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b35:	e9 10 01 00 00       	jmp    802c4a <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802b3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3d:	8b 40 0c             	mov    0xc(%eax),%eax
  802b40:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b43:	0f 86 c6 00 00 00    	jbe    802c0f <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b49:	a1 48 51 80 00       	mov    0x805148,%eax
  802b4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802b51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b54:	8b 50 08             	mov    0x8(%eax),%edx
  802b57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b5a:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802b5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b60:	8b 55 08             	mov    0x8(%ebp),%edx
  802b63:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802b66:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b6a:	75 17                	jne    802b83 <alloc_block_FF+0x104>
  802b6c:	83 ec 04             	sub    $0x4,%esp
  802b6f:	68 5c 48 80 00       	push   $0x80485c
  802b74:	68 9b 00 00 00       	push   $0x9b
  802b79:	68 b3 47 80 00       	push   $0x8047b3
  802b7e:	e8 1a dd ff ff       	call   80089d <_panic>
  802b83:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b86:	8b 00                	mov    (%eax),%eax
  802b88:	85 c0                	test   %eax,%eax
  802b8a:	74 10                	je     802b9c <alloc_block_FF+0x11d>
  802b8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b8f:	8b 00                	mov    (%eax),%eax
  802b91:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b94:	8b 52 04             	mov    0x4(%edx),%edx
  802b97:	89 50 04             	mov    %edx,0x4(%eax)
  802b9a:	eb 0b                	jmp    802ba7 <alloc_block_FF+0x128>
  802b9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b9f:	8b 40 04             	mov    0x4(%eax),%eax
  802ba2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ba7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802baa:	8b 40 04             	mov    0x4(%eax),%eax
  802bad:	85 c0                	test   %eax,%eax
  802baf:	74 0f                	je     802bc0 <alloc_block_FF+0x141>
  802bb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bb4:	8b 40 04             	mov    0x4(%eax),%eax
  802bb7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bba:	8b 12                	mov    (%edx),%edx
  802bbc:	89 10                	mov    %edx,(%eax)
  802bbe:	eb 0a                	jmp    802bca <alloc_block_FF+0x14b>
  802bc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bc3:	8b 00                	mov    (%eax),%eax
  802bc5:	a3 48 51 80 00       	mov    %eax,0x805148
  802bca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bcd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bd6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bdd:	a1 54 51 80 00       	mov    0x805154,%eax
  802be2:	48                   	dec    %eax
  802be3:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802be8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802beb:	8b 50 08             	mov    0x8(%eax),%edx
  802bee:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf1:	01 c2                	add    %eax,%edx
  802bf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf6:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802bf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfc:	8b 40 0c             	mov    0xc(%eax),%eax
  802bff:	2b 45 08             	sub    0x8(%ebp),%eax
  802c02:	89 c2                	mov    %eax,%edx
  802c04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c07:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802c0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c0d:	eb 3b                	jmp    802c4a <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802c0f:	a1 40 51 80 00       	mov    0x805140,%eax
  802c14:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c17:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c1b:	74 07                	je     802c24 <alloc_block_FF+0x1a5>
  802c1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c20:	8b 00                	mov    (%eax),%eax
  802c22:	eb 05                	jmp    802c29 <alloc_block_FF+0x1aa>
  802c24:	b8 00 00 00 00       	mov    $0x0,%eax
  802c29:	a3 40 51 80 00       	mov    %eax,0x805140
  802c2e:	a1 40 51 80 00       	mov    0x805140,%eax
  802c33:	85 c0                	test   %eax,%eax
  802c35:	0f 85 57 fe ff ff    	jne    802a92 <alloc_block_FF+0x13>
  802c3b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c3f:	0f 85 4d fe ff ff    	jne    802a92 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802c45:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c4a:	c9                   	leave  
  802c4b:	c3                   	ret    

00802c4c <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802c4c:	55                   	push   %ebp
  802c4d:	89 e5                	mov    %esp,%ebp
  802c4f:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802c52:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802c59:	a1 38 51 80 00       	mov    0x805138,%eax
  802c5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c61:	e9 df 00 00 00       	jmp    802d45 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802c66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c69:	8b 40 0c             	mov    0xc(%eax),%eax
  802c6c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c6f:	0f 82 c8 00 00 00    	jb     802d3d <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802c75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c78:	8b 40 0c             	mov    0xc(%eax),%eax
  802c7b:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c7e:	0f 85 8a 00 00 00    	jne    802d0e <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802c84:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c88:	75 17                	jne    802ca1 <alloc_block_BF+0x55>
  802c8a:	83 ec 04             	sub    $0x4,%esp
  802c8d:	68 5c 48 80 00       	push   $0x80485c
  802c92:	68 b7 00 00 00       	push   $0xb7
  802c97:	68 b3 47 80 00       	push   $0x8047b3
  802c9c:	e8 fc db ff ff       	call   80089d <_panic>
  802ca1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca4:	8b 00                	mov    (%eax),%eax
  802ca6:	85 c0                	test   %eax,%eax
  802ca8:	74 10                	je     802cba <alloc_block_BF+0x6e>
  802caa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cad:	8b 00                	mov    (%eax),%eax
  802caf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cb2:	8b 52 04             	mov    0x4(%edx),%edx
  802cb5:	89 50 04             	mov    %edx,0x4(%eax)
  802cb8:	eb 0b                	jmp    802cc5 <alloc_block_BF+0x79>
  802cba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbd:	8b 40 04             	mov    0x4(%eax),%eax
  802cc0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802cc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc8:	8b 40 04             	mov    0x4(%eax),%eax
  802ccb:	85 c0                	test   %eax,%eax
  802ccd:	74 0f                	je     802cde <alloc_block_BF+0x92>
  802ccf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd2:	8b 40 04             	mov    0x4(%eax),%eax
  802cd5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cd8:	8b 12                	mov    (%edx),%edx
  802cda:	89 10                	mov    %edx,(%eax)
  802cdc:	eb 0a                	jmp    802ce8 <alloc_block_BF+0x9c>
  802cde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce1:	8b 00                	mov    (%eax),%eax
  802ce3:	a3 38 51 80 00       	mov    %eax,0x805138
  802ce8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ceb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cfb:	a1 44 51 80 00       	mov    0x805144,%eax
  802d00:	48                   	dec    %eax
  802d01:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802d06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d09:	e9 4d 01 00 00       	jmp    802e5b <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802d0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d11:	8b 40 0c             	mov    0xc(%eax),%eax
  802d14:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d17:	76 24                	jbe    802d3d <alloc_block_BF+0xf1>
  802d19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1c:	8b 40 0c             	mov    0xc(%eax),%eax
  802d1f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802d22:	73 19                	jae    802d3d <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802d24:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802d2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2e:	8b 40 0c             	mov    0xc(%eax),%eax
  802d31:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802d34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d37:	8b 40 08             	mov    0x8(%eax),%eax
  802d3a:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802d3d:	a1 40 51 80 00       	mov    0x805140,%eax
  802d42:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d45:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d49:	74 07                	je     802d52 <alloc_block_BF+0x106>
  802d4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4e:	8b 00                	mov    (%eax),%eax
  802d50:	eb 05                	jmp    802d57 <alloc_block_BF+0x10b>
  802d52:	b8 00 00 00 00       	mov    $0x0,%eax
  802d57:	a3 40 51 80 00       	mov    %eax,0x805140
  802d5c:	a1 40 51 80 00       	mov    0x805140,%eax
  802d61:	85 c0                	test   %eax,%eax
  802d63:	0f 85 fd fe ff ff    	jne    802c66 <alloc_block_BF+0x1a>
  802d69:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d6d:	0f 85 f3 fe ff ff    	jne    802c66 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802d73:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802d77:	0f 84 d9 00 00 00    	je     802e56 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802d7d:	a1 48 51 80 00       	mov    0x805148,%eax
  802d82:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802d85:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d88:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d8b:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802d8e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d91:	8b 55 08             	mov    0x8(%ebp),%edx
  802d94:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802d97:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802d9b:	75 17                	jne    802db4 <alloc_block_BF+0x168>
  802d9d:	83 ec 04             	sub    $0x4,%esp
  802da0:	68 5c 48 80 00       	push   $0x80485c
  802da5:	68 c7 00 00 00       	push   $0xc7
  802daa:	68 b3 47 80 00       	push   $0x8047b3
  802daf:	e8 e9 da ff ff       	call   80089d <_panic>
  802db4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802db7:	8b 00                	mov    (%eax),%eax
  802db9:	85 c0                	test   %eax,%eax
  802dbb:	74 10                	je     802dcd <alloc_block_BF+0x181>
  802dbd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dc0:	8b 00                	mov    (%eax),%eax
  802dc2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802dc5:	8b 52 04             	mov    0x4(%edx),%edx
  802dc8:	89 50 04             	mov    %edx,0x4(%eax)
  802dcb:	eb 0b                	jmp    802dd8 <alloc_block_BF+0x18c>
  802dcd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dd0:	8b 40 04             	mov    0x4(%eax),%eax
  802dd3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802dd8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ddb:	8b 40 04             	mov    0x4(%eax),%eax
  802dde:	85 c0                	test   %eax,%eax
  802de0:	74 0f                	je     802df1 <alloc_block_BF+0x1a5>
  802de2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802de5:	8b 40 04             	mov    0x4(%eax),%eax
  802de8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802deb:	8b 12                	mov    (%edx),%edx
  802ded:	89 10                	mov    %edx,(%eax)
  802def:	eb 0a                	jmp    802dfb <alloc_block_BF+0x1af>
  802df1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802df4:	8b 00                	mov    (%eax),%eax
  802df6:	a3 48 51 80 00       	mov    %eax,0x805148
  802dfb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dfe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e04:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e07:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e0e:	a1 54 51 80 00       	mov    0x805154,%eax
  802e13:	48                   	dec    %eax
  802e14:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802e19:	83 ec 08             	sub    $0x8,%esp
  802e1c:	ff 75 ec             	pushl  -0x14(%ebp)
  802e1f:	68 38 51 80 00       	push   $0x805138
  802e24:	e8 71 f9 ff ff       	call   80279a <find_block>
  802e29:	83 c4 10             	add    $0x10,%esp
  802e2c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802e2f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e32:	8b 50 08             	mov    0x8(%eax),%edx
  802e35:	8b 45 08             	mov    0x8(%ebp),%eax
  802e38:	01 c2                	add    %eax,%edx
  802e3a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e3d:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802e40:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e43:	8b 40 0c             	mov    0xc(%eax),%eax
  802e46:	2b 45 08             	sub    0x8(%ebp),%eax
  802e49:	89 c2                	mov    %eax,%edx
  802e4b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e4e:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802e51:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e54:	eb 05                	jmp    802e5b <alloc_block_BF+0x20f>
	}
	return NULL;
  802e56:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e5b:	c9                   	leave  
  802e5c:	c3                   	ret    

00802e5d <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802e5d:	55                   	push   %ebp
  802e5e:	89 e5                	mov    %esp,%ebp
  802e60:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802e63:	a1 28 50 80 00       	mov    0x805028,%eax
  802e68:	85 c0                	test   %eax,%eax
  802e6a:	0f 85 de 01 00 00    	jne    80304e <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802e70:	a1 38 51 80 00       	mov    0x805138,%eax
  802e75:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e78:	e9 9e 01 00 00       	jmp    80301b <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802e7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e80:	8b 40 0c             	mov    0xc(%eax),%eax
  802e83:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e86:	0f 82 87 01 00 00    	jb     803013 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802e8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8f:	8b 40 0c             	mov    0xc(%eax),%eax
  802e92:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e95:	0f 85 95 00 00 00    	jne    802f30 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802e9b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e9f:	75 17                	jne    802eb8 <alloc_block_NF+0x5b>
  802ea1:	83 ec 04             	sub    $0x4,%esp
  802ea4:	68 5c 48 80 00       	push   $0x80485c
  802ea9:	68 e0 00 00 00       	push   $0xe0
  802eae:	68 b3 47 80 00       	push   $0x8047b3
  802eb3:	e8 e5 d9 ff ff       	call   80089d <_panic>
  802eb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebb:	8b 00                	mov    (%eax),%eax
  802ebd:	85 c0                	test   %eax,%eax
  802ebf:	74 10                	je     802ed1 <alloc_block_NF+0x74>
  802ec1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec4:	8b 00                	mov    (%eax),%eax
  802ec6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ec9:	8b 52 04             	mov    0x4(%edx),%edx
  802ecc:	89 50 04             	mov    %edx,0x4(%eax)
  802ecf:	eb 0b                	jmp    802edc <alloc_block_NF+0x7f>
  802ed1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed4:	8b 40 04             	mov    0x4(%eax),%eax
  802ed7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802edc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802edf:	8b 40 04             	mov    0x4(%eax),%eax
  802ee2:	85 c0                	test   %eax,%eax
  802ee4:	74 0f                	je     802ef5 <alloc_block_NF+0x98>
  802ee6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee9:	8b 40 04             	mov    0x4(%eax),%eax
  802eec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802eef:	8b 12                	mov    (%edx),%edx
  802ef1:	89 10                	mov    %edx,(%eax)
  802ef3:	eb 0a                	jmp    802eff <alloc_block_NF+0xa2>
  802ef5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef8:	8b 00                	mov    (%eax),%eax
  802efa:	a3 38 51 80 00       	mov    %eax,0x805138
  802eff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f02:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f12:	a1 44 51 80 00       	mov    0x805144,%eax
  802f17:	48                   	dec    %eax
  802f18:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802f1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f20:	8b 40 08             	mov    0x8(%eax),%eax
  802f23:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802f28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2b:	e9 f8 04 00 00       	jmp    803428 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802f30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f33:	8b 40 0c             	mov    0xc(%eax),%eax
  802f36:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f39:	0f 86 d4 00 00 00    	jbe    803013 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802f3f:	a1 48 51 80 00       	mov    0x805148,%eax
  802f44:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802f47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4a:	8b 50 08             	mov    0x8(%eax),%edx
  802f4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f50:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802f53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f56:	8b 55 08             	mov    0x8(%ebp),%edx
  802f59:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802f5c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f60:	75 17                	jne    802f79 <alloc_block_NF+0x11c>
  802f62:	83 ec 04             	sub    $0x4,%esp
  802f65:	68 5c 48 80 00       	push   $0x80485c
  802f6a:	68 e9 00 00 00       	push   $0xe9
  802f6f:	68 b3 47 80 00       	push   $0x8047b3
  802f74:	e8 24 d9 ff ff       	call   80089d <_panic>
  802f79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f7c:	8b 00                	mov    (%eax),%eax
  802f7e:	85 c0                	test   %eax,%eax
  802f80:	74 10                	je     802f92 <alloc_block_NF+0x135>
  802f82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f85:	8b 00                	mov    (%eax),%eax
  802f87:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f8a:	8b 52 04             	mov    0x4(%edx),%edx
  802f8d:	89 50 04             	mov    %edx,0x4(%eax)
  802f90:	eb 0b                	jmp    802f9d <alloc_block_NF+0x140>
  802f92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f95:	8b 40 04             	mov    0x4(%eax),%eax
  802f98:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fa0:	8b 40 04             	mov    0x4(%eax),%eax
  802fa3:	85 c0                	test   %eax,%eax
  802fa5:	74 0f                	je     802fb6 <alloc_block_NF+0x159>
  802fa7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802faa:	8b 40 04             	mov    0x4(%eax),%eax
  802fad:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fb0:	8b 12                	mov    (%edx),%edx
  802fb2:	89 10                	mov    %edx,(%eax)
  802fb4:	eb 0a                	jmp    802fc0 <alloc_block_NF+0x163>
  802fb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fb9:	8b 00                	mov    (%eax),%eax
  802fbb:	a3 48 51 80 00       	mov    %eax,0x805148
  802fc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fc3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fcc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fd3:	a1 54 51 80 00       	mov    0x805154,%eax
  802fd8:	48                   	dec    %eax
  802fd9:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802fde:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fe1:	8b 40 08             	mov    0x8(%eax),%eax
  802fe4:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802fe9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fec:	8b 50 08             	mov    0x8(%eax),%edx
  802fef:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff2:	01 c2                	add    %eax,%edx
  802ff4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff7:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802ffa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ffd:	8b 40 0c             	mov    0xc(%eax),%eax
  803000:	2b 45 08             	sub    0x8(%ebp),%eax
  803003:	89 c2                	mov    %eax,%edx
  803005:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803008:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  80300b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80300e:	e9 15 04 00 00       	jmp    803428 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  803013:	a1 40 51 80 00       	mov    0x805140,%eax
  803018:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80301b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80301f:	74 07                	je     803028 <alloc_block_NF+0x1cb>
  803021:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803024:	8b 00                	mov    (%eax),%eax
  803026:	eb 05                	jmp    80302d <alloc_block_NF+0x1d0>
  803028:	b8 00 00 00 00       	mov    $0x0,%eax
  80302d:	a3 40 51 80 00       	mov    %eax,0x805140
  803032:	a1 40 51 80 00       	mov    0x805140,%eax
  803037:	85 c0                	test   %eax,%eax
  803039:	0f 85 3e fe ff ff    	jne    802e7d <alloc_block_NF+0x20>
  80303f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803043:	0f 85 34 fe ff ff    	jne    802e7d <alloc_block_NF+0x20>
  803049:	e9 d5 03 00 00       	jmp    803423 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  80304e:	a1 38 51 80 00       	mov    0x805138,%eax
  803053:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803056:	e9 b1 01 00 00       	jmp    80320c <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  80305b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305e:	8b 50 08             	mov    0x8(%eax),%edx
  803061:	a1 28 50 80 00       	mov    0x805028,%eax
  803066:	39 c2                	cmp    %eax,%edx
  803068:	0f 82 96 01 00 00    	jb     803204 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  80306e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803071:	8b 40 0c             	mov    0xc(%eax),%eax
  803074:	3b 45 08             	cmp    0x8(%ebp),%eax
  803077:	0f 82 87 01 00 00    	jb     803204 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  80307d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803080:	8b 40 0c             	mov    0xc(%eax),%eax
  803083:	3b 45 08             	cmp    0x8(%ebp),%eax
  803086:	0f 85 95 00 00 00    	jne    803121 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  80308c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803090:	75 17                	jne    8030a9 <alloc_block_NF+0x24c>
  803092:	83 ec 04             	sub    $0x4,%esp
  803095:	68 5c 48 80 00       	push   $0x80485c
  80309a:	68 fc 00 00 00       	push   $0xfc
  80309f:	68 b3 47 80 00       	push   $0x8047b3
  8030a4:	e8 f4 d7 ff ff       	call   80089d <_panic>
  8030a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ac:	8b 00                	mov    (%eax),%eax
  8030ae:	85 c0                	test   %eax,%eax
  8030b0:	74 10                	je     8030c2 <alloc_block_NF+0x265>
  8030b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b5:	8b 00                	mov    (%eax),%eax
  8030b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030ba:	8b 52 04             	mov    0x4(%edx),%edx
  8030bd:	89 50 04             	mov    %edx,0x4(%eax)
  8030c0:	eb 0b                	jmp    8030cd <alloc_block_NF+0x270>
  8030c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c5:	8b 40 04             	mov    0x4(%eax),%eax
  8030c8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d0:	8b 40 04             	mov    0x4(%eax),%eax
  8030d3:	85 c0                	test   %eax,%eax
  8030d5:	74 0f                	je     8030e6 <alloc_block_NF+0x289>
  8030d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030da:	8b 40 04             	mov    0x4(%eax),%eax
  8030dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030e0:	8b 12                	mov    (%edx),%edx
  8030e2:	89 10                	mov    %edx,(%eax)
  8030e4:	eb 0a                	jmp    8030f0 <alloc_block_NF+0x293>
  8030e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e9:	8b 00                	mov    (%eax),%eax
  8030eb:	a3 38 51 80 00       	mov    %eax,0x805138
  8030f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030fc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803103:	a1 44 51 80 00       	mov    0x805144,%eax
  803108:	48                   	dec    %eax
  803109:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  80310e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803111:	8b 40 08             	mov    0x8(%eax),%eax
  803114:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  803119:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80311c:	e9 07 03 00 00       	jmp    803428 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  803121:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803124:	8b 40 0c             	mov    0xc(%eax),%eax
  803127:	3b 45 08             	cmp    0x8(%ebp),%eax
  80312a:	0f 86 d4 00 00 00    	jbe    803204 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803130:	a1 48 51 80 00       	mov    0x805148,%eax
  803135:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  803138:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80313b:	8b 50 08             	mov    0x8(%eax),%edx
  80313e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803141:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  803144:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803147:	8b 55 08             	mov    0x8(%ebp),%edx
  80314a:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80314d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803151:	75 17                	jne    80316a <alloc_block_NF+0x30d>
  803153:	83 ec 04             	sub    $0x4,%esp
  803156:	68 5c 48 80 00       	push   $0x80485c
  80315b:	68 04 01 00 00       	push   $0x104
  803160:	68 b3 47 80 00       	push   $0x8047b3
  803165:	e8 33 d7 ff ff       	call   80089d <_panic>
  80316a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80316d:	8b 00                	mov    (%eax),%eax
  80316f:	85 c0                	test   %eax,%eax
  803171:	74 10                	je     803183 <alloc_block_NF+0x326>
  803173:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803176:	8b 00                	mov    (%eax),%eax
  803178:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80317b:	8b 52 04             	mov    0x4(%edx),%edx
  80317e:	89 50 04             	mov    %edx,0x4(%eax)
  803181:	eb 0b                	jmp    80318e <alloc_block_NF+0x331>
  803183:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803186:	8b 40 04             	mov    0x4(%eax),%eax
  803189:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80318e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803191:	8b 40 04             	mov    0x4(%eax),%eax
  803194:	85 c0                	test   %eax,%eax
  803196:	74 0f                	je     8031a7 <alloc_block_NF+0x34a>
  803198:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80319b:	8b 40 04             	mov    0x4(%eax),%eax
  80319e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031a1:	8b 12                	mov    (%edx),%edx
  8031a3:	89 10                	mov    %edx,(%eax)
  8031a5:	eb 0a                	jmp    8031b1 <alloc_block_NF+0x354>
  8031a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031aa:	8b 00                	mov    (%eax),%eax
  8031ac:	a3 48 51 80 00       	mov    %eax,0x805148
  8031b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031b4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031bd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031c4:	a1 54 51 80 00       	mov    0x805154,%eax
  8031c9:	48                   	dec    %eax
  8031ca:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  8031cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d2:	8b 40 08             	mov    0x8(%eax),%eax
  8031d5:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  8031da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031dd:	8b 50 08             	mov    0x8(%eax),%edx
  8031e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e3:	01 c2                	add    %eax,%edx
  8031e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e8:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8031eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ee:	8b 40 0c             	mov    0xc(%eax),%eax
  8031f1:	2b 45 08             	sub    0x8(%ebp),%eax
  8031f4:	89 c2                	mov    %eax,%edx
  8031f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f9:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8031fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ff:	e9 24 02 00 00       	jmp    803428 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  803204:	a1 40 51 80 00       	mov    0x805140,%eax
  803209:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80320c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803210:	74 07                	je     803219 <alloc_block_NF+0x3bc>
  803212:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803215:	8b 00                	mov    (%eax),%eax
  803217:	eb 05                	jmp    80321e <alloc_block_NF+0x3c1>
  803219:	b8 00 00 00 00       	mov    $0x0,%eax
  80321e:	a3 40 51 80 00       	mov    %eax,0x805140
  803223:	a1 40 51 80 00       	mov    0x805140,%eax
  803228:	85 c0                	test   %eax,%eax
  80322a:	0f 85 2b fe ff ff    	jne    80305b <alloc_block_NF+0x1fe>
  803230:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803234:	0f 85 21 fe ff ff    	jne    80305b <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  80323a:	a1 38 51 80 00       	mov    0x805138,%eax
  80323f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803242:	e9 ae 01 00 00       	jmp    8033f5 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  803247:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80324a:	8b 50 08             	mov    0x8(%eax),%edx
  80324d:	a1 28 50 80 00       	mov    0x805028,%eax
  803252:	39 c2                	cmp    %eax,%edx
  803254:	0f 83 93 01 00 00    	jae    8033ed <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  80325a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80325d:	8b 40 0c             	mov    0xc(%eax),%eax
  803260:	3b 45 08             	cmp    0x8(%ebp),%eax
  803263:	0f 82 84 01 00 00    	jb     8033ed <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  803269:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80326c:	8b 40 0c             	mov    0xc(%eax),%eax
  80326f:	3b 45 08             	cmp    0x8(%ebp),%eax
  803272:	0f 85 95 00 00 00    	jne    80330d <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  803278:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80327c:	75 17                	jne    803295 <alloc_block_NF+0x438>
  80327e:	83 ec 04             	sub    $0x4,%esp
  803281:	68 5c 48 80 00       	push   $0x80485c
  803286:	68 14 01 00 00       	push   $0x114
  80328b:	68 b3 47 80 00       	push   $0x8047b3
  803290:	e8 08 d6 ff ff       	call   80089d <_panic>
  803295:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803298:	8b 00                	mov    (%eax),%eax
  80329a:	85 c0                	test   %eax,%eax
  80329c:	74 10                	je     8032ae <alloc_block_NF+0x451>
  80329e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a1:	8b 00                	mov    (%eax),%eax
  8032a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032a6:	8b 52 04             	mov    0x4(%edx),%edx
  8032a9:	89 50 04             	mov    %edx,0x4(%eax)
  8032ac:	eb 0b                	jmp    8032b9 <alloc_block_NF+0x45c>
  8032ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b1:	8b 40 04             	mov    0x4(%eax),%eax
  8032b4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032bc:	8b 40 04             	mov    0x4(%eax),%eax
  8032bf:	85 c0                	test   %eax,%eax
  8032c1:	74 0f                	je     8032d2 <alloc_block_NF+0x475>
  8032c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c6:	8b 40 04             	mov    0x4(%eax),%eax
  8032c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032cc:	8b 12                	mov    (%edx),%edx
  8032ce:	89 10                	mov    %edx,(%eax)
  8032d0:	eb 0a                	jmp    8032dc <alloc_block_NF+0x47f>
  8032d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d5:	8b 00                	mov    (%eax),%eax
  8032d7:	a3 38 51 80 00       	mov    %eax,0x805138
  8032dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032df:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032e8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032ef:	a1 44 51 80 00       	mov    0x805144,%eax
  8032f4:	48                   	dec    %eax
  8032f5:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8032fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032fd:	8b 40 08             	mov    0x8(%eax),%eax
  803300:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  803305:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803308:	e9 1b 01 00 00       	jmp    803428 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  80330d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803310:	8b 40 0c             	mov    0xc(%eax),%eax
  803313:	3b 45 08             	cmp    0x8(%ebp),%eax
  803316:	0f 86 d1 00 00 00    	jbe    8033ed <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80331c:	a1 48 51 80 00       	mov    0x805148,%eax
  803321:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  803324:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803327:	8b 50 08             	mov    0x8(%eax),%edx
  80332a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80332d:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  803330:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803333:	8b 55 08             	mov    0x8(%ebp),%edx
  803336:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803339:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80333d:	75 17                	jne    803356 <alloc_block_NF+0x4f9>
  80333f:	83 ec 04             	sub    $0x4,%esp
  803342:	68 5c 48 80 00       	push   $0x80485c
  803347:	68 1c 01 00 00       	push   $0x11c
  80334c:	68 b3 47 80 00       	push   $0x8047b3
  803351:	e8 47 d5 ff ff       	call   80089d <_panic>
  803356:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803359:	8b 00                	mov    (%eax),%eax
  80335b:	85 c0                	test   %eax,%eax
  80335d:	74 10                	je     80336f <alloc_block_NF+0x512>
  80335f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803362:	8b 00                	mov    (%eax),%eax
  803364:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803367:	8b 52 04             	mov    0x4(%edx),%edx
  80336a:	89 50 04             	mov    %edx,0x4(%eax)
  80336d:	eb 0b                	jmp    80337a <alloc_block_NF+0x51d>
  80336f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803372:	8b 40 04             	mov    0x4(%eax),%eax
  803375:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80337a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80337d:	8b 40 04             	mov    0x4(%eax),%eax
  803380:	85 c0                	test   %eax,%eax
  803382:	74 0f                	je     803393 <alloc_block_NF+0x536>
  803384:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803387:	8b 40 04             	mov    0x4(%eax),%eax
  80338a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80338d:	8b 12                	mov    (%edx),%edx
  80338f:	89 10                	mov    %edx,(%eax)
  803391:	eb 0a                	jmp    80339d <alloc_block_NF+0x540>
  803393:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803396:	8b 00                	mov    (%eax),%eax
  803398:	a3 48 51 80 00       	mov    %eax,0x805148
  80339d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033a9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033b0:	a1 54 51 80 00       	mov    0x805154,%eax
  8033b5:	48                   	dec    %eax
  8033b6:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  8033bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033be:	8b 40 08             	mov    0x8(%eax),%eax
  8033c1:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  8033c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c9:	8b 50 08             	mov    0x8(%eax),%edx
  8033cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8033cf:	01 c2                	add    %eax,%edx
  8033d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033d4:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8033d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033da:	8b 40 0c             	mov    0xc(%eax),%eax
  8033dd:	2b 45 08             	sub    0x8(%ebp),%eax
  8033e0:	89 c2                	mov    %eax,%edx
  8033e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033e5:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8033e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033eb:	eb 3b                	jmp    803428 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8033ed:	a1 40 51 80 00       	mov    0x805140,%eax
  8033f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033f9:	74 07                	je     803402 <alloc_block_NF+0x5a5>
  8033fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033fe:	8b 00                	mov    (%eax),%eax
  803400:	eb 05                	jmp    803407 <alloc_block_NF+0x5aa>
  803402:	b8 00 00 00 00       	mov    $0x0,%eax
  803407:	a3 40 51 80 00       	mov    %eax,0x805140
  80340c:	a1 40 51 80 00       	mov    0x805140,%eax
  803411:	85 c0                	test   %eax,%eax
  803413:	0f 85 2e fe ff ff    	jne    803247 <alloc_block_NF+0x3ea>
  803419:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80341d:	0f 85 24 fe ff ff    	jne    803247 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  803423:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803428:	c9                   	leave  
  803429:	c3                   	ret    

0080342a <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  80342a:	55                   	push   %ebp
  80342b:	89 e5                	mov    %esp,%ebp
  80342d:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  803430:	a1 38 51 80 00       	mov    0x805138,%eax
  803435:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  803438:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80343d:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  803440:	a1 38 51 80 00       	mov    0x805138,%eax
  803445:	85 c0                	test   %eax,%eax
  803447:	74 14                	je     80345d <insert_sorted_with_merge_freeList+0x33>
  803449:	8b 45 08             	mov    0x8(%ebp),%eax
  80344c:	8b 50 08             	mov    0x8(%eax),%edx
  80344f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803452:	8b 40 08             	mov    0x8(%eax),%eax
  803455:	39 c2                	cmp    %eax,%edx
  803457:	0f 87 9b 01 00 00    	ja     8035f8 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  80345d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803461:	75 17                	jne    80347a <insert_sorted_with_merge_freeList+0x50>
  803463:	83 ec 04             	sub    $0x4,%esp
  803466:	68 90 47 80 00       	push   $0x804790
  80346b:	68 38 01 00 00       	push   $0x138
  803470:	68 b3 47 80 00       	push   $0x8047b3
  803475:	e8 23 d4 ff ff       	call   80089d <_panic>
  80347a:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803480:	8b 45 08             	mov    0x8(%ebp),%eax
  803483:	89 10                	mov    %edx,(%eax)
  803485:	8b 45 08             	mov    0x8(%ebp),%eax
  803488:	8b 00                	mov    (%eax),%eax
  80348a:	85 c0                	test   %eax,%eax
  80348c:	74 0d                	je     80349b <insert_sorted_with_merge_freeList+0x71>
  80348e:	a1 38 51 80 00       	mov    0x805138,%eax
  803493:	8b 55 08             	mov    0x8(%ebp),%edx
  803496:	89 50 04             	mov    %edx,0x4(%eax)
  803499:	eb 08                	jmp    8034a3 <insert_sorted_with_merge_freeList+0x79>
  80349b:	8b 45 08             	mov    0x8(%ebp),%eax
  80349e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8034a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a6:	a3 38 51 80 00       	mov    %eax,0x805138
  8034ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034b5:	a1 44 51 80 00       	mov    0x805144,%eax
  8034ba:	40                   	inc    %eax
  8034bb:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8034c0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8034c4:	0f 84 a8 06 00 00    	je     803b72 <insert_sorted_with_merge_freeList+0x748>
  8034ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8034cd:	8b 50 08             	mov    0x8(%eax),%edx
  8034d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d3:	8b 40 0c             	mov    0xc(%eax),%eax
  8034d6:	01 c2                	add    %eax,%edx
  8034d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034db:	8b 40 08             	mov    0x8(%eax),%eax
  8034de:	39 c2                	cmp    %eax,%edx
  8034e0:	0f 85 8c 06 00 00    	jne    803b72 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  8034e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e9:	8b 50 0c             	mov    0xc(%eax),%edx
  8034ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034ef:	8b 40 0c             	mov    0xc(%eax),%eax
  8034f2:	01 c2                	add    %eax,%edx
  8034f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f7:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  8034fa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8034fe:	75 17                	jne    803517 <insert_sorted_with_merge_freeList+0xed>
  803500:	83 ec 04             	sub    $0x4,%esp
  803503:	68 5c 48 80 00       	push   $0x80485c
  803508:	68 3c 01 00 00       	push   $0x13c
  80350d:	68 b3 47 80 00       	push   $0x8047b3
  803512:	e8 86 d3 ff ff       	call   80089d <_panic>
  803517:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80351a:	8b 00                	mov    (%eax),%eax
  80351c:	85 c0                	test   %eax,%eax
  80351e:	74 10                	je     803530 <insert_sorted_with_merge_freeList+0x106>
  803520:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803523:	8b 00                	mov    (%eax),%eax
  803525:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803528:	8b 52 04             	mov    0x4(%edx),%edx
  80352b:	89 50 04             	mov    %edx,0x4(%eax)
  80352e:	eb 0b                	jmp    80353b <insert_sorted_with_merge_freeList+0x111>
  803530:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803533:	8b 40 04             	mov    0x4(%eax),%eax
  803536:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80353b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80353e:	8b 40 04             	mov    0x4(%eax),%eax
  803541:	85 c0                	test   %eax,%eax
  803543:	74 0f                	je     803554 <insert_sorted_with_merge_freeList+0x12a>
  803545:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803548:	8b 40 04             	mov    0x4(%eax),%eax
  80354b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80354e:	8b 12                	mov    (%edx),%edx
  803550:	89 10                	mov    %edx,(%eax)
  803552:	eb 0a                	jmp    80355e <insert_sorted_with_merge_freeList+0x134>
  803554:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803557:	8b 00                	mov    (%eax),%eax
  803559:	a3 38 51 80 00       	mov    %eax,0x805138
  80355e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803561:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803567:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80356a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803571:	a1 44 51 80 00       	mov    0x805144,%eax
  803576:	48                   	dec    %eax
  803577:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  80357c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80357f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  803586:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803589:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  803590:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803594:	75 17                	jne    8035ad <insert_sorted_with_merge_freeList+0x183>
  803596:	83 ec 04             	sub    $0x4,%esp
  803599:	68 90 47 80 00       	push   $0x804790
  80359e:	68 3f 01 00 00       	push   $0x13f
  8035a3:	68 b3 47 80 00       	push   $0x8047b3
  8035a8:	e8 f0 d2 ff ff       	call   80089d <_panic>
  8035ad:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8035b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035b6:	89 10                	mov    %edx,(%eax)
  8035b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035bb:	8b 00                	mov    (%eax),%eax
  8035bd:	85 c0                	test   %eax,%eax
  8035bf:	74 0d                	je     8035ce <insert_sorted_with_merge_freeList+0x1a4>
  8035c1:	a1 48 51 80 00       	mov    0x805148,%eax
  8035c6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035c9:	89 50 04             	mov    %edx,0x4(%eax)
  8035cc:	eb 08                	jmp    8035d6 <insert_sorted_with_merge_freeList+0x1ac>
  8035ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035d1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8035d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035d9:	a3 48 51 80 00       	mov    %eax,0x805148
  8035de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035e1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035e8:	a1 54 51 80 00       	mov    0x805154,%eax
  8035ed:	40                   	inc    %eax
  8035ee:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8035f3:	e9 7a 05 00 00       	jmp    803b72 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  8035f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8035fb:	8b 50 08             	mov    0x8(%eax),%edx
  8035fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803601:	8b 40 08             	mov    0x8(%eax),%eax
  803604:	39 c2                	cmp    %eax,%edx
  803606:	0f 82 14 01 00 00    	jb     803720 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  80360c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80360f:	8b 50 08             	mov    0x8(%eax),%edx
  803612:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803615:	8b 40 0c             	mov    0xc(%eax),%eax
  803618:	01 c2                	add    %eax,%edx
  80361a:	8b 45 08             	mov    0x8(%ebp),%eax
  80361d:	8b 40 08             	mov    0x8(%eax),%eax
  803620:	39 c2                	cmp    %eax,%edx
  803622:	0f 85 90 00 00 00    	jne    8036b8 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  803628:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80362b:	8b 50 0c             	mov    0xc(%eax),%edx
  80362e:	8b 45 08             	mov    0x8(%ebp),%eax
  803631:	8b 40 0c             	mov    0xc(%eax),%eax
  803634:	01 c2                	add    %eax,%edx
  803636:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803639:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  80363c:	8b 45 08             	mov    0x8(%ebp),%eax
  80363f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  803646:	8b 45 08             	mov    0x8(%ebp),%eax
  803649:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803650:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803654:	75 17                	jne    80366d <insert_sorted_with_merge_freeList+0x243>
  803656:	83 ec 04             	sub    $0x4,%esp
  803659:	68 90 47 80 00       	push   $0x804790
  80365e:	68 49 01 00 00       	push   $0x149
  803663:	68 b3 47 80 00       	push   $0x8047b3
  803668:	e8 30 d2 ff ff       	call   80089d <_panic>
  80366d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803673:	8b 45 08             	mov    0x8(%ebp),%eax
  803676:	89 10                	mov    %edx,(%eax)
  803678:	8b 45 08             	mov    0x8(%ebp),%eax
  80367b:	8b 00                	mov    (%eax),%eax
  80367d:	85 c0                	test   %eax,%eax
  80367f:	74 0d                	je     80368e <insert_sorted_with_merge_freeList+0x264>
  803681:	a1 48 51 80 00       	mov    0x805148,%eax
  803686:	8b 55 08             	mov    0x8(%ebp),%edx
  803689:	89 50 04             	mov    %edx,0x4(%eax)
  80368c:	eb 08                	jmp    803696 <insert_sorted_with_merge_freeList+0x26c>
  80368e:	8b 45 08             	mov    0x8(%ebp),%eax
  803691:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803696:	8b 45 08             	mov    0x8(%ebp),%eax
  803699:	a3 48 51 80 00       	mov    %eax,0x805148
  80369e:	8b 45 08             	mov    0x8(%ebp),%eax
  8036a1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036a8:	a1 54 51 80 00       	mov    0x805154,%eax
  8036ad:	40                   	inc    %eax
  8036ae:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8036b3:	e9 bb 04 00 00       	jmp    803b73 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  8036b8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036bc:	75 17                	jne    8036d5 <insert_sorted_with_merge_freeList+0x2ab>
  8036be:	83 ec 04             	sub    $0x4,%esp
  8036c1:	68 04 48 80 00       	push   $0x804804
  8036c6:	68 4c 01 00 00       	push   $0x14c
  8036cb:	68 b3 47 80 00       	push   $0x8047b3
  8036d0:	e8 c8 d1 ff ff       	call   80089d <_panic>
  8036d5:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8036db:	8b 45 08             	mov    0x8(%ebp),%eax
  8036de:	89 50 04             	mov    %edx,0x4(%eax)
  8036e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e4:	8b 40 04             	mov    0x4(%eax),%eax
  8036e7:	85 c0                	test   %eax,%eax
  8036e9:	74 0c                	je     8036f7 <insert_sorted_with_merge_freeList+0x2cd>
  8036eb:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8036f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8036f3:	89 10                	mov    %edx,(%eax)
  8036f5:	eb 08                	jmp    8036ff <insert_sorted_with_merge_freeList+0x2d5>
  8036f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8036fa:	a3 38 51 80 00       	mov    %eax,0x805138
  8036ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803702:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803707:	8b 45 08             	mov    0x8(%ebp),%eax
  80370a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803710:	a1 44 51 80 00       	mov    0x805144,%eax
  803715:	40                   	inc    %eax
  803716:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80371b:	e9 53 04 00 00       	jmp    803b73 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803720:	a1 38 51 80 00       	mov    0x805138,%eax
  803725:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803728:	e9 15 04 00 00       	jmp    803b42 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  80372d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803730:	8b 00                	mov    (%eax),%eax
  803732:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803735:	8b 45 08             	mov    0x8(%ebp),%eax
  803738:	8b 50 08             	mov    0x8(%eax),%edx
  80373b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80373e:	8b 40 08             	mov    0x8(%eax),%eax
  803741:	39 c2                	cmp    %eax,%edx
  803743:	0f 86 f1 03 00 00    	jbe    803b3a <insert_sorted_with_merge_freeList+0x710>
  803749:	8b 45 08             	mov    0x8(%ebp),%eax
  80374c:	8b 50 08             	mov    0x8(%eax),%edx
  80374f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803752:	8b 40 08             	mov    0x8(%eax),%eax
  803755:	39 c2                	cmp    %eax,%edx
  803757:	0f 83 dd 03 00 00    	jae    803b3a <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  80375d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803760:	8b 50 08             	mov    0x8(%eax),%edx
  803763:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803766:	8b 40 0c             	mov    0xc(%eax),%eax
  803769:	01 c2                	add    %eax,%edx
  80376b:	8b 45 08             	mov    0x8(%ebp),%eax
  80376e:	8b 40 08             	mov    0x8(%eax),%eax
  803771:	39 c2                	cmp    %eax,%edx
  803773:	0f 85 b9 01 00 00    	jne    803932 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803779:	8b 45 08             	mov    0x8(%ebp),%eax
  80377c:	8b 50 08             	mov    0x8(%eax),%edx
  80377f:	8b 45 08             	mov    0x8(%ebp),%eax
  803782:	8b 40 0c             	mov    0xc(%eax),%eax
  803785:	01 c2                	add    %eax,%edx
  803787:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80378a:	8b 40 08             	mov    0x8(%eax),%eax
  80378d:	39 c2                	cmp    %eax,%edx
  80378f:	0f 85 0d 01 00 00    	jne    8038a2 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803795:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803798:	8b 50 0c             	mov    0xc(%eax),%edx
  80379b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80379e:	8b 40 0c             	mov    0xc(%eax),%eax
  8037a1:	01 c2                	add    %eax,%edx
  8037a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037a6:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8037a9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8037ad:	75 17                	jne    8037c6 <insert_sorted_with_merge_freeList+0x39c>
  8037af:	83 ec 04             	sub    $0x4,%esp
  8037b2:	68 5c 48 80 00       	push   $0x80485c
  8037b7:	68 5c 01 00 00       	push   $0x15c
  8037bc:	68 b3 47 80 00       	push   $0x8047b3
  8037c1:	e8 d7 d0 ff ff       	call   80089d <_panic>
  8037c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037c9:	8b 00                	mov    (%eax),%eax
  8037cb:	85 c0                	test   %eax,%eax
  8037cd:	74 10                	je     8037df <insert_sorted_with_merge_freeList+0x3b5>
  8037cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037d2:	8b 00                	mov    (%eax),%eax
  8037d4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8037d7:	8b 52 04             	mov    0x4(%edx),%edx
  8037da:	89 50 04             	mov    %edx,0x4(%eax)
  8037dd:	eb 0b                	jmp    8037ea <insert_sorted_with_merge_freeList+0x3c0>
  8037df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037e2:	8b 40 04             	mov    0x4(%eax),%eax
  8037e5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8037ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037ed:	8b 40 04             	mov    0x4(%eax),%eax
  8037f0:	85 c0                	test   %eax,%eax
  8037f2:	74 0f                	je     803803 <insert_sorted_with_merge_freeList+0x3d9>
  8037f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037f7:	8b 40 04             	mov    0x4(%eax),%eax
  8037fa:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8037fd:	8b 12                	mov    (%edx),%edx
  8037ff:	89 10                	mov    %edx,(%eax)
  803801:	eb 0a                	jmp    80380d <insert_sorted_with_merge_freeList+0x3e3>
  803803:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803806:	8b 00                	mov    (%eax),%eax
  803808:	a3 38 51 80 00       	mov    %eax,0x805138
  80380d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803810:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803816:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803819:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803820:	a1 44 51 80 00       	mov    0x805144,%eax
  803825:	48                   	dec    %eax
  803826:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  80382b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80382e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803835:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803838:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80383f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803843:	75 17                	jne    80385c <insert_sorted_with_merge_freeList+0x432>
  803845:	83 ec 04             	sub    $0x4,%esp
  803848:	68 90 47 80 00       	push   $0x804790
  80384d:	68 5f 01 00 00       	push   $0x15f
  803852:	68 b3 47 80 00       	push   $0x8047b3
  803857:	e8 41 d0 ff ff       	call   80089d <_panic>
  80385c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803862:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803865:	89 10                	mov    %edx,(%eax)
  803867:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80386a:	8b 00                	mov    (%eax),%eax
  80386c:	85 c0                	test   %eax,%eax
  80386e:	74 0d                	je     80387d <insert_sorted_with_merge_freeList+0x453>
  803870:	a1 48 51 80 00       	mov    0x805148,%eax
  803875:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803878:	89 50 04             	mov    %edx,0x4(%eax)
  80387b:	eb 08                	jmp    803885 <insert_sorted_with_merge_freeList+0x45b>
  80387d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803880:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803885:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803888:	a3 48 51 80 00       	mov    %eax,0x805148
  80388d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803890:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803897:	a1 54 51 80 00       	mov    0x805154,%eax
  80389c:	40                   	inc    %eax
  80389d:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  8038a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038a5:	8b 50 0c             	mov    0xc(%eax),%edx
  8038a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ab:	8b 40 0c             	mov    0xc(%eax),%eax
  8038ae:	01 c2                	add    %eax,%edx
  8038b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038b3:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8038b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8038b9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8038c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8038c3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8038ca:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8038ce:	75 17                	jne    8038e7 <insert_sorted_with_merge_freeList+0x4bd>
  8038d0:	83 ec 04             	sub    $0x4,%esp
  8038d3:	68 90 47 80 00       	push   $0x804790
  8038d8:	68 64 01 00 00       	push   $0x164
  8038dd:	68 b3 47 80 00       	push   $0x8047b3
  8038e2:	e8 b6 cf ff ff       	call   80089d <_panic>
  8038e7:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8038ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8038f0:	89 10                	mov    %edx,(%eax)
  8038f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8038f5:	8b 00                	mov    (%eax),%eax
  8038f7:	85 c0                	test   %eax,%eax
  8038f9:	74 0d                	je     803908 <insert_sorted_with_merge_freeList+0x4de>
  8038fb:	a1 48 51 80 00       	mov    0x805148,%eax
  803900:	8b 55 08             	mov    0x8(%ebp),%edx
  803903:	89 50 04             	mov    %edx,0x4(%eax)
  803906:	eb 08                	jmp    803910 <insert_sorted_with_merge_freeList+0x4e6>
  803908:	8b 45 08             	mov    0x8(%ebp),%eax
  80390b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803910:	8b 45 08             	mov    0x8(%ebp),%eax
  803913:	a3 48 51 80 00       	mov    %eax,0x805148
  803918:	8b 45 08             	mov    0x8(%ebp),%eax
  80391b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803922:	a1 54 51 80 00       	mov    0x805154,%eax
  803927:	40                   	inc    %eax
  803928:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80392d:	e9 41 02 00 00       	jmp    803b73 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803932:	8b 45 08             	mov    0x8(%ebp),%eax
  803935:	8b 50 08             	mov    0x8(%eax),%edx
  803938:	8b 45 08             	mov    0x8(%ebp),%eax
  80393b:	8b 40 0c             	mov    0xc(%eax),%eax
  80393e:	01 c2                	add    %eax,%edx
  803940:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803943:	8b 40 08             	mov    0x8(%eax),%eax
  803946:	39 c2                	cmp    %eax,%edx
  803948:	0f 85 7c 01 00 00    	jne    803aca <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  80394e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803952:	74 06                	je     80395a <insert_sorted_with_merge_freeList+0x530>
  803954:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803958:	75 17                	jne    803971 <insert_sorted_with_merge_freeList+0x547>
  80395a:	83 ec 04             	sub    $0x4,%esp
  80395d:	68 cc 47 80 00       	push   $0x8047cc
  803962:	68 69 01 00 00       	push   $0x169
  803967:	68 b3 47 80 00       	push   $0x8047b3
  80396c:	e8 2c cf ff ff       	call   80089d <_panic>
  803971:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803974:	8b 50 04             	mov    0x4(%eax),%edx
  803977:	8b 45 08             	mov    0x8(%ebp),%eax
  80397a:	89 50 04             	mov    %edx,0x4(%eax)
  80397d:	8b 45 08             	mov    0x8(%ebp),%eax
  803980:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803983:	89 10                	mov    %edx,(%eax)
  803985:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803988:	8b 40 04             	mov    0x4(%eax),%eax
  80398b:	85 c0                	test   %eax,%eax
  80398d:	74 0d                	je     80399c <insert_sorted_with_merge_freeList+0x572>
  80398f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803992:	8b 40 04             	mov    0x4(%eax),%eax
  803995:	8b 55 08             	mov    0x8(%ebp),%edx
  803998:	89 10                	mov    %edx,(%eax)
  80399a:	eb 08                	jmp    8039a4 <insert_sorted_with_merge_freeList+0x57a>
  80399c:	8b 45 08             	mov    0x8(%ebp),%eax
  80399f:	a3 38 51 80 00       	mov    %eax,0x805138
  8039a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8039aa:	89 50 04             	mov    %edx,0x4(%eax)
  8039ad:	a1 44 51 80 00       	mov    0x805144,%eax
  8039b2:	40                   	inc    %eax
  8039b3:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  8039b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8039bb:	8b 50 0c             	mov    0xc(%eax),%edx
  8039be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039c1:	8b 40 0c             	mov    0xc(%eax),%eax
  8039c4:	01 c2                	add    %eax,%edx
  8039c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8039c9:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8039cc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8039d0:	75 17                	jne    8039e9 <insert_sorted_with_merge_freeList+0x5bf>
  8039d2:	83 ec 04             	sub    $0x4,%esp
  8039d5:	68 5c 48 80 00       	push   $0x80485c
  8039da:	68 6b 01 00 00       	push   $0x16b
  8039df:	68 b3 47 80 00       	push   $0x8047b3
  8039e4:	e8 b4 ce ff ff       	call   80089d <_panic>
  8039e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039ec:	8b 00                	mov    (%eax),%eax
  8039ee:	85 c0                	test   %eax,%eax
  8039f0:	74 10                	je     803a02 <insert_sorted_with_merge_freeList+0x5d8>
  8039f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039f5:	8b 00                	mov    (%eax),%eax
  8039f7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8039fa:	8b 52 04             	mov    0x4(%edx),%edx
  8039fd:	89 50 04             	mov    %edx,0x4(%eax)
  803a00:	eb 0b                	jmp    803a0d <insert_sorted_with_merge_freeList+0x5e3>
  803a02:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a05:	8b 40 04             	mov    0x4(%eax),%eax
  803a08:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803a0d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a10:	8b 40 04             	mov    0x4(%eax),%eax
  803a13:	85 c0                	test   %eax,%eax
  803a15:	74 0f                	je     803a26 <insert_sorted_with_merge_freeList+0x5fc>
  803a17:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a1a:	8b 40 04             	mov    0x4(%eax),%eax
  803a1d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803a20:	8b 12                	mov    (%edx),%edx
  803a22:	89 10                	mov    %edx,(%eax)
  803a24:	eb 0a                	jmp    803a30 <insert_sorted_with_merge_freeList+0x606>
  803a26:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a29:	8b 00                	mov    (%eax),%eax
  803a2b:	a3 38 51 80 00       	mov    %eax,0x805138
  803a30:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a33:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a39:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a3c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a43:	a1 44 51 80 00       	mov    0x805144,%eax
  803a48:	48                   	dec    %eax
  803a49:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803a4e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a51:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803a58:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a5b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803a62:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803a66:	75 17                	jne    803a7f <insert_sorted_with_merge_freeList+0x655>
  803a68:	83 ec 04             	sub    $0x4,%esp
  803a6b:	68 90 47 80 00       	push   $0x804790
  803a70:	68 6e 01 00 00       	push   $0x16e
  803a75:	68 b3 47 80 00       	push   $0x8047b3
  803a7a:	e8 1e ce ff ff       	call   80089d <_panic>
  803a7f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803a85:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a88:	89 10                	mov    %edx,(%eax)
  803a8a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a8d:	8b 00                	mov    (%eax),%eax
  803a8f:	85 c0                	test   %eax,%eax
  803a91:	74 0d                	je     803aa0 <insert_sorted_with_merge_freeList+0x676>
  803a93:	a1 48 51 80 00       	mov    0x805148,%eax
  803a98:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803a9b:	89 50 04             	mov    %edx,0x4(%eax)
  803a9e:	eb 08                	jmp    803aa8 <insert_sorted_with_merge_freeList+0x67e>
  803aa0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803aa3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803aa8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803aab:	a3 48 51 80 00       	mov    %eax,0x805148
  803ab0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ab3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803aba:	a1 54 51 80 00       	mov    0x805154,%eax
  803abf:	40                   	inc    %eax
  803ac0:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803ac5:	e9 a9 00 00 00       	jmp    803b73 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803aca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ace:	74 06                	je     803ad6 <insert_sorted_with_merge_freeList+0x6ac>
  803ad0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803ad4:	75 17                	jne    803aed <insert_sorted_with_merge_freeList+0x6c3>
  803ad6:	83 ec 04             	sub    $0x4,%esp
  803ad9:	68 28 48 80 00       	push   $0x804828
  803ade:	68 73 01 00 00       	push   $0x173
  803ae3:	68 b3 47 80 00       	push   $0x8047b3
  803ae8:	e8 b0 cd ff ff       	call   80089d <_panic>
  803aed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803af0:	8b 10                	mov    (%eax),%edx
  803af2:	8b 45 08             	mov    0x8(%ebp),%eax
  803af5:	89 10                	mov    %edx,(%eax)
  803af7:	8b 45 08             	mov    0x8(%ebp),%eax
  803afa:	8b 00                	mov    (%eax),%eax
  803afc:	85 c0                	test   %eax,%eax
  803afe:	74 0b                	je     803b0b <insert_sorted_with_merge_freeList+0x6e1>
  803b00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b03:	8b 00                	mov    (%eax),%eax
  803b05:	8b 55 08             	mov    0x8(%ebp),%edx
  803b08:	89 50 04             	mov    %edx,0x4(%eax)
  803b0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b0e:	8b 55 08             	mov    0x8(%ebp),%edx
  803b11:	89 10                	mov    %edx,(%eax)
  803b13:	8b 45 08             	mov    0x8(%ebp),%eax
  803b16:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803b19:	89 50 04             	mov    %edx,0x4(%eax)
  803b1c:	8b 45 08             	mov    0x8(%ebp),%eax
  803b1f:	8b 00                	mov    (%eax),%eax
  803b21:	85 c0                	test   %eax,%eax
  803b23:	75 08                	jne    803b2d <insert_sorted_with_merge_freeList+0x703>
  803b25:	8b 45 08             	mov    0x8(%ebp),%eax
  803b28:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803b2d:	a1 44 51 80 00       	mov    0x805144,%eax
  803b32:	40                   	inc    %eax
  803b33:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803b38:	eb 39                	jmp    803b73 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803b3a:	a1 40 51 80 00       	mov    0x805140,%eax
  803b3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803b42:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b46:	74 07                	je     803b4f <insert_sorted_with_merge_freeList+0x725>
  803b48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b4b:	8b 00                	mov    (%eax),%eax
  803b4d:	eb 05                	jmp    803b54 <insert_sorted_with_merge_freeList+0x72a>
  803b4f:	b8 00 00 00 00       	mov    $0x0,%eax
  803b54:	a3 40 51 80 00       	mov    %eax,0x805140
  803b59:	a1 40 51 80 00       	mov    0x805140,%eax
  803b5e:	85 c0                	test   %eax,%eax
  803b60:	0f 85 c7 fb ff ff    	jne    80372d <insert_sorted_with_merge_freeList+0x303>
  803b66:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b6a:	0f 85 bd fb ff ff    	jne    80372d <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803b70:	eb 01                	jmp    803b73 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803b72:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803b73:	90                   	nop
  803b74:	c9                   	leave  
  803b75:	c3                   	ret    
  803b76:	66 90                	xchg   %ax,%ax

00803b78 <__udivdi3>:
  803b78:	55                   	push   %ebp
  803b79:	57                   	push   %edi
  803b7a:	56                   	push   %esi
  803b7b:	53                   	push   %ebx
  803b7c:	83 ec 1c             	sub    $0x1c,%esp
  803b7f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803b83:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803b87:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b8b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803b8f:	89 ca                	mov    %ecx,%edx
  803b91:	89 f8                	mov    %edi,%eax
  803b93:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803b97:	85 f6                	test   %esi,%esi
  803b99:	75 2d                	jne    803bc8 <__udivdi3+0x50>
  803b9b:	39 cf                	cmp    %ecx,%edi
  803b9d:	77 65                	ja     803c04 <__udivdi3+0x8c>
  803b9f:	89 fd                	mov    %edi,%ebp
  803ba1:	85 ff                	test   %edi,%edi
  803ba3:	75 0b                	jne    803bb0 <__udivdi3+0x38>
  803ba5:	b8 01 00 00 00       	mov    $0x1,%eax
  803baa:	31 d2                	xor    %edx,%edx
  803bac:	f7 f7                	div    %edi
  803bae:	89 c5                	mov    %eax,%ebp
  803bb0:	31 d2                	xor    %edx,%edx
  803bb2:	89 c8                	mov    %ecx,%eax
  803bb4:	f7 f5                	div    %ebp
  803bb6:	89 c1                	mov    %eax,%ecx
  803bb8:	89 d8                	mov    %ebx,%eax
  803bba:	f7 f5                	div    %ebp
  803bbc:	89 cf                	mov    %ecx,%edi
  803bbe:	89 fa                	mov    %edi,%edx
  803bc0:	83 c4 1c             	add    $0x1c,%esp
  803bc3:	5b                   	pop    %ebx
  803bc4:	5e                   	pop    %esi
  803bc5:	5f                   	pop    %edi
  803bc6:	5d                   	pop    %ebp
  803bc7:	c3                   	ret    
  803bc8:	39 ce                	cmp    %ecx,%esi
  803bca:	77 28                	ja     803bf4 <__udivdi3+0x7c>
  803bcc:	0f bd fe             	bsr    %esi,%edi
  803bcf:	83 f7 1f             	xor    $0x1f,%edi
  803bd2:	75 40                	jne    803c14 <__udivdi3+0x9c>
  803bd4:	39 ce                	cmp    %ecx,%esi
  803bd6:	72 0a                	jb     803be2 <__udivdi3+0x6a>
  803bd8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803bdc:	0f 87 9e 00 00 00    	ja     803c80 <__udivdi3+0x108>
  803be2:	b8 01 00 00 00       	mov    $0x1,%eax
  803be7:	89 fa                	mov    %edi,%edx
  803be9:	83 c4 1c             	add    $0x1c,%esp
  803bec:	5b                   	pop    %ebx
  803bed:	5e                   	pop    %esi
  803bee:	5f                   	pop    %edi
  803bef:	5d                   	pop    %ebp
  803bf0:	c3                   	ret    
  803bf1:	8d 76 00             	lea    0x0(%esi),%esi
  803bf4:	31 ff                	xor    %edi,%edi
  803bf6:	31 c0                	xor    %eax,%eax
  803bf8:	89 fa                	mov    %edi,%edx
  803bfa:	83 c4 1c             	add    $0x1c,%esp
  803bfd:	5b                   	pop    %ebx
  803bfe:	5e                   	pop    %esi
  803bff:	5f                   	pop    %edi
  803c00:	5d                   	pop    %ebp
  803c01:	c3                   	ret    
  803c02:	66 90                	xchg   %ax,%ax
  803c04:	89 d8                	mov    %ebx,%eax
  803c06:	f7 f7                	div    %edi
  803c08:	31 ff                	xor    %edi,%edi
  803c0a:	89 fa                	mov    %edi,%edx
  803c0c:	83 c4 1c             	add    $0x1c,%esp
  803c0f:	5b                   	pop    %ebx
  803c10:	5e                   	pop    %esi
  803c11:	5f                   	pop    %edi
  803c12:	5d                   	pop    %ebp
  803c13:	c3                   	ret    
  803c14:	bd 20 00 00 00       	mov    $0x20,%ebp
  803c19:	89 eb                	mov    %ebp,%ebx
  803c1b:	29 fb                	sub    %edi,%ebx
  803c1d:	89 f9                	mov    %edi,%ecx
  803c1f:	d3 e6                	shl    %cl,%esi
  803c21:	89 c5                	mov    %eax,%ebp
  803c23:	88 d9                	mov    %bl,%cl
  803c25:	d3 ed                	shr    %cl,%ebp
  803c27:	89 e9                	mov    %ebp,%ecx
  803c29:	09 f1                	or     %esi,%ecx
  803c2b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803c2f:	89 f9                	mov    %edi,%ecx
  803c31:	d3 e0                	shl    %cl,%eax
  803c33:	89 c5                	mov    %eax,%ebp
  803c35:	89 d6                	mov    %edx,%esi
  803c37:	88 d9                	mov    %bl,%cl
  803c39:	d3 ee                	shr    %cl,%esi
  803c3b:	89 f9                	mov    %edi,%ecx
  803c3d:	d3 e2                	shl    %cl,%edx
  803c3f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c43:	88 d9                	mov    %bl,%cl
  803c45:	d3 e8                	shr    %cl,%eax
  803c47:	09 c2                	or     %eax,%edx
  803c49:	89 d0                	mov    %edx,%eax
  803c4b:	89 f2                	mov    %esi,%edx
  803c4d:	f7 74 24 0c          	divl   0xc(%esp)
  803c51:	89 d6                	mov    %edx,%esi
  803c53:	89 c3                	mov    %eax,%ebx
  803c55:	f7 e5                	mul    %ebp
  803c57:	39 d6                	cmp    %edx,%esi
  803c59:	72 19                	jb     803c74 <__udivdi3+0xfc>
  803c5b:	74 0b                	je     803c68 <__udivdi3+0xf0>
  803c5d:	89 d8                	mov    %ebx,%eax
  803c5f:	31 ff                	xor    %edi,%edi
  803c61:	e9 58 ff ff ff       	jmp    803bbe <__udivdi3+0x46>
  803c66:	66 90                	xchg   %ax,%ax
  803c68:	8b 54 24 08          	mov    0x8(%esp),%edx
  803c6c:	89 f9                	mov    %edi,%ecx
  803c6e:	d3 e2                	shl    %cl,%edx
  803c70:	39 c2                	cmp    %eax,%edx
  803c72:	73 e9                	jae    803c5d <__udivdi3+0xe5>
  803c74:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803c77:	31 ff                	xor    %edi,%edi
  803c79:	e9 40 ff ff ff       	jmp    803bbe <__udivdi3+0x46>
  803c7e:	66 90                	xchg   %ax,%ax
  803c80:	31 c0                	xor    %eax,%eax
  803c82:	e9 37 ff ff ff       	jmp    803bbe <__udivdi3+0x46>
  803c87:	90                   	nop

00803c88 <__umoddi3>:
  803c88:	55                   	push   %ebp
  803c89:	57                   	push   %edi
  803c8a:	56                   	push   %esi
  803c8b:	53                   	push   %ebx
  803c8c:	83 ec 1c             	sub    $0x1c,%esp
  803c8f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803c93:	8b 74 24 34          	mov    0x34(%esp),%esi
  803c97:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803c9b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803c9f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803ca3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803ca7:	89 f3                	mov    %esi,%ebx
  803ca9:	89 fa                	mov    %edi,%edx
  803cab:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803caf:	89 34 24             	mov    %esi,(%esp)
  803cb2:	85 c0                	test   %eax,%eax
  803cb4:	75 1a                	jne    803cd0 <__umoddi3+0x48>
  803cb6:	39 f7                	cmp    %esi,%edi
  803cb8:	0f 86 a2 00 00 00    	jbe    803d60 <__umoddi3+0xd8>
  803cbe:	89 c8                	mov    %ecx,%eax
  803cc0:	89 f2                	mov    %esi,%edx
  803cc2:	f7 f7                	div    %edi
  803cc4:	89 d0                	mov    %edx,%eax
  803cc6:	31 d2                	xor    %edx,%edx
  803cc8:	83 c4 1c             	add    $0x1c,%esp
  803ccb:	5b                   	pop    %ebx
  803ccc:	5e                   	pop    %esi
  803ccd:	5f                   	pop    %edi
  803cce:	5d                   	pop    %ebp
  803ccf:	c3                   	ret    
  803cd0:	39 f0                	cmp    %esi,%eax
  803cd2:	0f 87 ac 00 00 00    	ja     803d84 <__umoddi3+0xfc>
  803cd8:	0f bd e8             	bsr    %eax,%ebp
  803cdb:	83 f5 1f             	xor    $0x1f,%ebp
  803cde:	0f 84 ac 00 00 00    	je     803d90 <__umoddi3+0x108>
  803ce4:	bf 20 00 00 00       	mov    $0x20,%edi
  803ce9:	29 ef                	sub    %ebp,%edi
  803ceb:	89 fe                	mov    %edi,%esi
  803ced:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803cf1:	89 e9                	mov    %ebp,%ecx
  803cf3:	d3 e0                	shl    %cl,%eax
  803cf5:	89 d7                	mov    %edx,%edi
  803cf7:	89 f1                	mov    %esi,%ecx
  803cf9:	d3 ef                	shr    %cl,%edi
  803cfb:	09 c7                	or     %eax,%edi
  803cfd:	89 e9                	mov    %ebp,%ecx
  803cff:	d3 e2                	shl    %cl,%edx
  803d01:	89 14 24             	mov    %edx,(%esp)
  803d04:	89 d8                	mov    %ebx,%eax
  803d06:	d3 e0                	shl    %cl,%eax
  803d08:	89 c2                	mov    %eax,%edx
  803d0a:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d0e:	d3 e0                	shl    %cl,%eax
  803d10:	89 44 24 04          	mov    %eax,0x4(%esp)
  803d14:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d18:	89 f1                	mov    %esi,%ecx
  803d1a:	d3 e8                	shr    %cl,%eax
  803d1c:	09 d0                	or     %edx,%eax
  803d1e:	d3 eb                	shr    %cl,%ebx
  803d20:	89 da                	mov    %ebx,%edx
  803d22:	f7 f7                	div    %edi
  803d24:	89 d3                	mov    %edx,%ebx
  803d26:	f7 24 24             	mull   (%esp)
  803d29:	89 c6                	mov    %eax,%esi
  803d2b:	89 d1                	mov    %edx,%ecx
  803d2d:	39 d3                	cmp    %edx,%ebx
  803d2f:	0f 82 87 00 00 00    	jb     803dbc <__umoddi3+0x134>
  803d35:	0f 84 91 00 00 00    	je     803dcc <__umoddi3+0x144>
  803d3b:	8b 54 24 04          	mov    0x4(%esp),%edx
  803d3f:	29 f2                	sub    %esi,%edx
  803d41:	19 cb                	sbb    %ecx,%ebx
  803d43:	89 d8                	mov    %ebx,%eax
  803d45:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803d49:	d3 e0                	shl    %cl,%eax
  803d4b:	89 e9                	mov    %ebp,%ecx
  803d4d:	d3 ea                	shr    %cl,%edx
  803d4f:	09 d0                	or     %edx,%eax
  803d51:	89 e9                	mov    %ebp,%ecx
  803d53:	d3 eb                	shr    %cl,%ebx
  803d55:	89 da                	mov    %ebx,%edx
  803d57:	83 c4 1c             	add    $0x1c,%esp
  803d5a:	5b                   	pop    %ebx
  803d5b:	5e                   	pop    %esi
  803d5c:	5f                   	pop    %edi
  803d5d:	5d                   	pop    %ebp
  803d5e:	c3                   	ret    
  803d5f:	90                   	nop
  803d60:	89 fd                	mov    %edi,%ebp
  803d62:	85 ff                	test   %edi,%edi
  803d64:	75 0b                	jne    803d71 <__umoddi3+0xe9>
  803d66:	b8 01 00 00 00       	mov    $0x1,%eax
  803d6b:	31 d2                	xor    %edx,%edx
  803d6d:	f7 f7                	div    %edi
  803d6f:	89 c5                	mov    %eax,%ebp
  803d71:	89 f0                	mov    %esi,%eax
  803d73:	31 d2                	xor    %edx,%edx
  803d75:	f7 f5                	div    %ebp
  803d77:	89 c8                	mov    %ecx,%eax
  803d79:	f7 f5                	div    %ebp
  803d7b:	89 d0                	mov    %edx,%eax
  803d7d:	e9 44 ff ff ff       	jmp    803cc6 <__umoddi3+0x3e>
  803d82:	66 90                	xchg   %ax,%ax
  803d84:	89 c8                	mov    %ecx,%eax
  803d86:	89 f2                	mov    %esi,%edx
  803d88:	83 c4 1c             	add    $0x1c,%esp
  803d8b:	5b                   	pop    %ebx
  803d8c:	5e                   	pop    %esi
  803d8d:	5f                   	pop    %edi
  803d8e:	5d                   	pop    %ebp
  803d8f:	c3                   	ret    
  803d90:	3b 04 24             	cmp    (%esp),%eax
  803d93:	72 06                	jb     803d9b <__umoddi3+0x113>
  803d95:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803d99:	77 0f                	ja     803daa <__umoddi3+0x122>
  803d9b:	89 f2                	mov    %esi,%edx
  803d9d:	29 f9                	sub    %edi,%ecx
  803d9f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803da3:	89 14 24             	mov    %edx,(%esp)
  803da6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803daa:	8b 44 24 04          	mov    0x4(%esp),%eax
  803dae:	8b 14 24             	mov    (%esp),%edx
  803db1:	83 c4 1c             	add    $0x1c,%esp
  803db4:	5b                   	pop    %ebx
  803db5:	5e                   	pop    %esi
  803db6:	5f                   	pop    %edi
  803db7:	5d                   	pop    %ebp
  803db8:	c3                   	ret    
  803db9:	8d 76 00             	lea    0x0(%esi),%esi
  803dbc:	2b 04 24             	sub    (%esp),%eax
  803dbf:	19 fa                	sbb    %edi,%edx
  803dc1:	89 d1                	mov    %edx,%ecx
  803dc3:	89 c6                	mov    %eax,%esi
  803dc5:	e9 71 ff ff ff       	jmp    803d3b <__umoddi3+0xb3>
  803dca:	66 90                	xchg   %ax,%ax
  803dcc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803dd0:	72 ea                	jb     803dbc <__umoddi3+0x134>
  803dd2:	89 d9                	mov    %ebx,%ecx
  803dd4:	e9 62 ff ff ff       	jmp    803d3b <__umoddi3+0xb3>
