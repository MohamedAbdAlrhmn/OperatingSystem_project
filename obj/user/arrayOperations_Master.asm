
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
  800041:	e8 33 20 00 00       	call   802079 <sys_disable_interrupt>
		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 c0 3d 80 00       	push   $0x803dc0
  80004e:	e8 fe 0a 00 00       	call   800b51 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 c2 3d 80 00       	push   $0x803dc2
  80005e:	e8 ee 0a 00 00       	call   800b51 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!   ARRAY OOERATIONS   !!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 e0 3d 80 00       	push   $0x803de0
  80006e:	e8 de 0a 00 00       	call   800b51 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 c2 3d 80 00       	push   $0x803dc2
  80007e:	e8 ce 0a 00 00       	call   800b51 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 c0 3d 80 00       	push   $0x803dc0
  80008e:	e8 be 0a 00 00       	call   800b51 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp

		readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 45 82             	lea    -0x7e(%ebp),%eax
  80009c:	50                   	push   %eax
  80009d:	68 00 3e 80 00       	push   $0x803e00
  8000a2:	e8 2c 11 00 00       	call   8011d3 <readline>
  8000a7:	83 c4 10             	add    $0x10,%esp

		//Create the shared array & its size
		int *arrSize = smalloc("arrSize", sizeof(int) , 0) ;
  8000aa:	83 ec 04             	sub    $0x4,%esp
  8000ad:	6a 00                	push   $0x0
  8000af:	6a 04                	push   $0x4
  8000b1:	68 1f 3e 80 00       	push   $0x803e1f
  8000b6:	e8 6c 1c 00 00       	call   801d27 <smalloc>
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
  8000ef:	68 27 3e 80 00       	push   $0x803e27
  8000f4:	e8 2e 1c 00 00       	call   801d27 <smalloc>
  8000f9:	83 c4 10             	add    $0x10,%esp
  8000fc:	89 45 ec             	mov    %eax,-0x14(%ebp)

		cprintf("Chose the initialization method:\n") ;
  8000ff:	83 ec 0c             	sub    $0xc,%esp
  800102:	68 2c 3e 80 00       	push   $0x803e2c
  800107:	e8 45 0a 00 00       	call   800b51 <cprintf>
  80010c:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  80010f:	83 ec 0c             	sub    $0xc,%esp
  800112:	68 4e 3e 80 00       	push   $0x803e4e
  800117:	e8 35 0a 00 00       	call   800b51 <cprintf>
  80011c:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  80011f:	83 ec 0c             	sub    $0xc,%esp
  800122:	68 5c 3e 80 00       	push   $0x803e5c
  800127:	e8 25 0a 00 00       	call   800b51 <cprintf>
  80012c:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  80012f:	83 ec 0c             	sub    $0xc,%esp
  800132:	68 6b 3e 80 00       	push   $0x803e6b
  800137:	e8 15 0a 00 00       	call   800b51 <cprintf>
  80013c:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80013f:	83 ec 0c             	sub    $0xc,%esp
  800142:	68 7b 3e 80 00       	push   $0x803e7b
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
  800186:	e8 08 1f 00 00       	call   802093 <sys_enable_interrupt>

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
  8001f6:	68 84 3e 80 00       	push   $0x803e84
  8001fb:	e8 27 1b 00 00       	call   801d27 <smalloc>
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
  800232:	68 92 3e 80 00       	push   $0x803e92
  800237:	e8 c2 1f 00 00       	call   8021fe <sys_create_env>
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
  800265:	68 9b 3e 80 00       	push   $0x803e9b
  80026a:	e8 8f 1f 00 00       	call   8021fe <sys_create_env>
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
  800298:	68 a4 3e 80 00       	push   $0x803ea4
  80029d:	e8 5c 1f 00 00       	call   8021fe <sys_create_env>
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
  8002bd:	68 b0 3e 80 00       	push   $0x803eb0
  8002c2:	6a 4b                	push   $0x4b
  8002c4:	68 c5 3e 80 00       	push   $0x803ec5
  8002c9:	e8 cf 05 00 00       	call   80089d <_panic>

	sys_run_env(envIdQuickSort);
  8002ce:	83 ec 0c             	sub    $0xc,%esp
  8002d1:	ff 75 dc             	pushl  -0x24(%ebp)
  8002d4:	e8 43 1f 00 00       	call   80221c <sys_run_env>
  8002d9:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdMergeSort);
  8002dc:	83 ec 0c             	sub    $0xc,%esp
  8002df:	ff 75 d8             	pushl  -0x28(%ebp)
  8002e2:	e8 35 1f 00 00       	call   80221c <sys_run_env>
  8002e7:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdStats);
  8002ea:	83 ec 0c             	sub    $0xc,%esp
  8002ed:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002f0:	e8 27 1f 00 00       	call   80221c <sys_run_env>
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
  800337:	68 e3 3e 80 00       	push   $0x803ee3
  80033c:	ff 75 dc             	pushl  -0x24(%ebp)
  80033f:	e8 a4 1a 00 00       	call   801de8 <sget>
  800344:	83 c4 10             	add    $0x10,%esp
  800347:	89 45 d0             	mov    %eax,-0x30(%ebp)
	mergesortedArr = sget(envIdMergeSort, "mergesortedArr") ;
  80034a:	83 ec 08             	sub    $0x8,%esp
  80034d:	68 f2 3e 80 00       	push   $0x803ef2
  800352:	ff 75 d8             	pushl  -0x28(%ebp)
  800355:	e8 8e 1a 00 00       	call   801de8 <sget>
  80035a:	83 c4 10             	add    $0x10,%esp
  80035d:	89 45 cc             	mov    %eax,-0x34(%ebp)
	mean = sget(envIdStats, "mean") ;
  800360:	83 ec 08             	sub    $0x8,%esp
  800363:	68 01 3f 80 00       	push   $0x803f01
  800368:	ff 75 d4             	pushl  -0x2c(%ebp)
  80036b:	e8 78 1a 00 00       	call   801de8 <sget>
  800370:	83 c4 10             	add    $0x10,%esp
  800373:	89 45 c8             	mov    %eax,-0x38(%ebp)
	var = sget(envIdStats,"var") ;
  800376:	83 ec 08             	sub    $0x8,%esp
  800379:	68 06 3f 80 00       	push   $0x803f06
  80037e:	ff 75 d4             	pushl  -0x2c(%ebp)
  800381:	e8 62 1a 00 00       	call   801de8 <sget>
  800386:	83 c4 10             	add    $0x10,%esp
  800389:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	min = sget(envIdStats,"min") ;
  80038c:	83 ec 08             	sub    $0x8,%esp
  80038f:	68 0a 3f 80 00       	push   $0x803f0a
  800394:	ff 75 d4             	pushl  -0x2c(%ebp)
  800397:	e8 4c 1a 00 00       	call   801de8 <sget>
  80039c:	83 c4 10             	add    $0x10,%esp
  80039f:	89 45 c0             	mov    %eax,-0x40(%ebp)
	max = sget(envIdStats,"max") ;
  8003a2:	83 ec 08             	sub    $0x8,%esp
  8003a5:	68 0e 3f 80 00       	push   $0x803f0e
  8003aa:	ff 75 d4             	pushl  -0x2c(%ebp)
  8003ad:	e8 36 1a 00 00       	call   801de8 <sget>
  8003b2:	83 c4 10             	add    $0x10,%esp
  8003b5:	89 45 bc             	mov    %eax,-0x44(%ebp)
	med = sget(envIdStats,"med") ;
  8003b8:	83 ec 08             	sub    $0x8,%esp
  8003bb:	68 12 3f 80 00       	push   $0x803f12
  8003c0:	ff 75 d4             	pushl  -0x2c(%ebp)
  8003c3:	e8 20 1a 00 00       	call   801de8 <sget>
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
  8003eb:	68 18 3f 80 00       	push   $0x803f18
  8003f0:	6a 66                	push   $0x66
  8003f2:	68 c5 3e 80 00       	push   $0x803ec5
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
  800419:	68 40 3f 80 00       	push   $0x803f40
  80041e:	6a 68                	push   $0x68
  800420:	68 c5 3e 80 00       	push   $0x803ec5
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
  8004cc:	68 68 3f 80 00       	push   $0x803f68
  8004d1:	6a 75                	push   $0x75
  8004d3:	68 c5 3e 80 00       	push   $0x803ec5
  8004d8:	e8 c0 03 00 00       	call   80089d <_panic>

	cprintf("Congratulations!! Scenario of Using the Shared Variables [Create & Get] completed successfully!!\n\n\n");
  8004dd:	83 ec 0c             	sub    $0xc,%esp
  8004e0:	68 98 3f 80 00       	push   $0x803f98
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
  8006d5:	e8 d3 19 00 00       	call   8020ad <sys_cputc>
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
  8006e6:	e8 8e 19 00 00       	call   802079 <sys_disable_interrupt>
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
  8006f9:	e8 af 19 00 00       	call   8020ad <sys_cputc>
  8006fe:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800701:	e8 8d 19 00 00       	call   802093 <sys_enable_interrupt>
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
  800718:	e8 d7 17 00 00       	call   801ef4 <sys_cgetc>
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
  800731:	e8 43 19 00 00       	call   802079 <sys_disable_interrupt>
	int c=0;
  800736:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  80073d:	eb 08                	jmp    800747 <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  80073f:	e8 b0 17 00 00       	call   801ef4 <sys_cgetc>
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
  80074d:	e8 41 19 00 00       	call   802093 <sys_enable_interrupt>
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
  800767:	e8 00 1b 00 00       	call   80226c <sys_getenvindex>
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
  8007d2:	e8 a2 18 00 00       	call   802079 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8007d7:	83 ec 0c             	sub    $0xc,%esp
  8007da:	68 14 40 80 00       	push   $0x804014
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
  800802:	68 3c 40 80 00       	push   $0x80403c
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
  800833:	68 64 40 80 00       	push   $0x804064
  800838:	e8 14 03 00 00       	call   800b51 <cprintf>
  80083d:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800840:	a1 20 50 80 00       	mov    0x805020,%eax
  800845:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80084b:	83 ec 08             	sub    $0x8,%esp
  80084e:	50                   	push   %eax
  80084f:	68 bc 40 80 00       	push   $0x8040bc
  800854:	e8 f8 02 00 00       	call   800b51 <cprintf>
  800859:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80085c:	83 ec 0c             	sub    $0xc,%esp
  80085f:	68 14 40 80 00       	push   $0x804014
  800864:	e8 e8 02 00 00       	call   800b51 <cprintf>
  800869:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80086c:	e8 22 18 00 00       	call   802093 <sys_enable_interrupt>

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
  800884:	e8 af 19 00 00       	call   802238 <sys_destroy_env>
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
  800895:	e8 04 1a 00 00       	call   80229e <sys_exit_env>
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
  8008be:	68 d0 40 80 00       	push   $0x8040d0
  8008c3:	e8 89 02 00 00       	call   800b51 <cprintf>
  8008c8:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8008cb:	a1 00 50 80 00       	mov    0x805000,%eax
  8008d0:	ff 75 0c             	pushl  0xc(%ebp)
  8008d3:	ff 75 08             	pushl  0x8(%ebp)
  8008d6:	50                   	push   %eax
  8008d7:	68 d5 40 80 00       	push   $0x8040d5
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
  8008fb:	68 f1 40 80 00       	push   $0x8040f1
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
  800927:	68 f4 40 80 00       	push   $0x8040f4
  80092c:	6a 26                	push   $0x26
  80092e:	68 40 41 80 00       	push   $0x804140
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
  8009f9:	68 4c 41 80 00       	push   $0x80414c
  8009fe:	6a 3a                	push   $0x3a
  800a00:	68 40 41 80 00       	push   $0x804140
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
  800a69:	68 a0 41 80 00       	push   $0x8041a0
  800a6e:	6a 44                	push   $0x44
  800a70:	68 40 41 80 00       	push   $0x804140
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
  800ac3:	e8 03 14 00 00       	call   801ecb <sys_cputs>
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
  800b3a:	e8 8c 13 00 00       	call   801ecb <sys_cputs>
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
  800b84:	e8 f0 14 00 00       	call   802079 <sys_disable_interrupt>
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
  800ba4:	e8 ea 14 00 00       	call   802093 <sys_enable_interrupt>
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
  800bee:	e8 5d 2f 00 00       	call   803b50 <__udivdi3>
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
  800c3e:	e8 1d 30 00 00       	call   803c60 <__umoddi3>
  800c43:	83 c4 10             	add    $0x10,%esp
  800c46:	05 14 44 80 00       	add    $0x804414,%eax
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
  800d99:	8b 04 85 38 44 80 00 	mov    0x804438(,%eax,4),%eax
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
  800e7a:	8b 34 9d 80 42 80 00 	mov    0x804280(,%ebx,4),%esi
  800e81:	85 f6                	test   %esi,%esi
  800e83:	75 19                	jne    800e9e <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800e85:	53                   	push   %ebx
  800e86:	68 25 44 80 00       	push   $0x804425
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
  800e9f:	68 2e 44 80 00       	push   $0x80442e
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
  800ecc:	be 31 44 80 00       	mov    $0x804431,%esi
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
  8011e5:	68 90 45 80 00       	push   $0x804590
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
  801227:	68 93 45 80 00       	push   $0x804593
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
  8012d7:	e8 9d 0d 00 00       	call   802079 <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  8012dc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012e0:	74 13                	je     8012f5 <atomic_readline+0x24>
		cprintf("%s", prompt);
  8012e2:	83 ec 08             	sub    $0x8,%esp
  8012e5:	ff 75 08             	pushl  0x8(%ebp)
  8012e8:	68 90 45 80 00       	push   $0x804590
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
  801326:	68 93 45 80 00       	push   $0x804593
  80132b:	e8 21 f8 ff ff       	call   800b51 <cprintf>
  801330:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  801333:	e8 5b 0d 00 00       	call   802093 <sys_enable_interrupt>
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
  8013cb:	e8 c3 0c 00 00       	call   802093 <sys_enable_interrupt>
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
  801af8:	68 a4 45 80 00       	push   $0x8045a4
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
  801bc8:	e8 42 04 00 00       	call   80200f <sys_allocate_chunk>
  801bcd:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801bd0:	a1 20 51 80 00       	mov    0x805120,%eax
  801bd5:	83 ec 0c             	sub    $0xc,%esp
  801bd8:	50                   	push   %eax
  801bd9:	e8 b7 0a 00 00       	call   802695 <initialize_MemBlocksList>
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
  801c06:	68 c9 45 80 00       	push   $0x8045c9
  801c0b:	6a 33                	push   $0x33
  801c0d:	68 e7 45 80 00       	push   $0x8045e7
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
  801c85:	68 f4 45 80 00       	push   $0x8045f4
  801c8a:	6a 34                	push   $0x34
  801c8c:	68 e7 45 80 00       	push   $0x8045e7
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
  801ce2:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801ce5:	e8 f7 fd ff ff       	call   801ae1 <InitializeUHeap>
	if (size == 0) return NULL ;
  801cea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801cee:	75 07                	jne    801cf7 <malloc+0x18>
  801cf0:	b8 00 00 00 00       	mov    $0x0,%eax
  801cf5:	eb 14                	jmp    801d0b <malloc+0x2c>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801cf7:	83 ec 04             	sub    $0x4,%esp
  801cfa:	68 18 46 80 00       	push   $0x804618
  801cff:	6a 46                	push   $0x46
  801d01:	68 e7 45 80 00       	push   $0x8045e7
  801d06:	e8 92 eb ff ff       	call   80089d <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801d0b:	c9                   	leave  
  801d0c:	c3                   	ret    

00801d0d <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801d0d:	55                   	push   %ebp
  801d0e:	89 e5                	mov    %esp,%ebp
  801d10:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801d13:	83 ec 04             	sub    $0x4,%esp
  801d16:	68 40 46 80 00       	push   $0x804640
  801d1b:	6a 61                	push   $0x61
  801d1d:	68 e7 45 80 00       	push   $0x8045e7
  801d22:	e8 76 eb ff ff       	call   80089d <_panic>

00801d27 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801d27:	55                   	push   %ebp
  801d28:	89 e5                	mov    %esp,%ebp
  801d2a:	83 ec 38             	sub    $0x38,%esp
  801d2d:	8b 45 10             	mov    0x10(%ebp),%eax
  801d30:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801d33:	e8 a9 fd ff ff       	call   801ae1 <InitializeUHeap>
	if (size == 0) return NULL ;
  801d38:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d3c:	75 0a                	jne    801d48 <smalloc+0x21>
  801d3e:	b8 00 00 00 00       	mov    $0x0,%eax
  801d43:	e9 9e 00 00 00       	jmp    801de6 <smalloc+0xbf>
	//3-If the Kernel successfully creates the shared variable, return its virtual address
	//4-Else, return NULL



	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801d48:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801d4f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d55:	01 d0                	add    %edx,%eax
  801d57:	48                   	dec    %eax
  801d58:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801d5b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d5e:	ba 00 00 00 00       	mov    $0x0,%edx
  801d63:	f7 75 f0             	divl   -0x10(%ebp)
  801d66:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d69:	29 d0                	sub    %edx,%eax
  801d6b:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801d6e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801d75:	e8 63 06 00 00       	call   8023dd <sys_isUHeapPlacementStrategyFIRSTFIT>
  801d7a:	85 c0                	test   %eax,%eax
  801d7c:	74 11                	je     801d8f <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  801d7e:	83 ec 0c             	sub    $0xc,%esp
  801d81:	ff 75 e8             	pushl  -0x18(%ebp)
  801d84:	e8 ce 0c 00 00       	call   802a57 <alloc_block_FF>
  801d89:	83 c4 10             	add    $0x10,%esp
  801d8c:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  801d8f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d93:	74 4c                	je     801de1 <smalloc+0xba>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801d95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d98:	8b 40 08             	mov    0x8(%eax),%eax
  801d9b:	89 c2                	mov    %eax,%edx
  801d9d:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801da1:	52                   	push   %edx
  801da2:	50                   	push   %eax
  801da3:	ff 75 0c             	pushl  0xc(%ebp)
  801da6:	ff 75 08             	pushl  0x8(%ebp)
  801da9:	e8 b4 03 00 00       	call   802162 <sys_createSharedObject>
  801dae:	83 c4 10             	add    $0x10,%esp
  801db1:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cprintf("Output is :  %d \n" , result);
  801db4:	83 ec 08             	sub    $0x8,%esp
  801db7:	ff 75 e0             	pushl  -0x20(%ebp)
  801dba:	68 63 46 80 00       	push   $0x804663
  801dbf:	e8 8d ed ff ff       	call   800b51 <cprintf>
  801dc4:	83 c4 10             	add    $0x10,%esp
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  801dc7:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  801dcb:	74 14                	je     801de1 <smalloc+0xba>
  801dcd:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  801dd1:	74 0e                	je     801de1 <smalloc+0xba>
  801dd3:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  801dd7:	74 08                	je     801de1 <smalloc+0xba>
			return (void*) mem_block->sva;
  801dd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ddc:	8b 40 08             	mov    0x8(%eax),%eax
  801ddf:	eb 05                	jmp    801de6 <smalloc+0xbf>
	}
	return NULL;
  801de1:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801de6:	c9                   	leave  
  801de7:	c3                   	ret    

00801de8 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801de8:	55                   	push   %ebp
  801de9:	89 e5                	mov    %esp,%ebp
  801deb:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801dee:	e8 ee fc ff ff       	call   801ae1 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801df3:	83 ec 04             	sub    $0x4,%esp
  801df6:	68 78 46 80 00       	push   $0x804678
  801dfb:	68 ab 00 00 00       	push   $0xab
  801e00:	68 e7 45 80 00       	push   $0x8045e7
  801e05:	e8 93 ea ff ff       	call   80089d <_panic>

00801e0a <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801e0a:	55                   	push   %ebp
  801e0b:	89 e5                	mov    %esp,%ebp
  801e0d:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e10:	e8 cc fc ff ff       	call   801ae1 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801e15:	83 ec 04             	sub    $0x4,%esp
  801e18:	68 9c 46 80 00       	push   $0x80469c
  801e1d:	68 ef 00 00 00       	push   $0xef
  801e22:	68 e7 45 80 00       	push   $0x8045e7
  801e27:	e8 71 ea ff ff       	call   80089d <_panic>

00801e2c <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801e2c:	55                   	push   %ebp
  801e2d:	89 e5                	mov    %esp,%ebp
  801e2f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801e32:	83 ec 04             	sub    $0x4,%esp
  801e35:	68 c4 46 80 00       	push   $0x8046c4
  801e3a:	68 03 01 00 00       	push   $0x103
  801e3f:	68 e7 45 80 00       	push   $0x8045e7
  801e44:	e8 54 ea ff ff       	call   80089d <_panic>

00801e49 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801e49:	55                   	push   %ebp
  801e4a:	89 e5                	mov    %esp,%ebp
  801e4c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e4f:	83 ec 04             	sub    $0x4,%esp
  801e52:	68 e8 46 80 00       	push   $0x8046e8
  801e57:	68 0e 01 00 00       	push   $0x10e
  801e5c:	68 e7 45 80 00       	push   $0x8045e7
  801e61:	e8 37 ea ff ff       	call   80089d <_panic>

00801e66 <shrink>:

}
void shrink(uint32 newSize)
{
  801e66:	55                   	push   %ebp
  801e67:	89 e5                	mov    %esp,%ebp
  801e69:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e6c:	83 ec 04             	sub    $0x4,%esp
  801e6f:	68 e8 46 80 00       	push   $0x8046e8
  801e74:	68 13 01 00 00       	push   $0x113
  801e79:	68 e7 45 80 00       	push   $0x8045e7
  801e7e:	e8 1a ea ff ff       	call   80089d <_panic>

00801e83 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801e83:	55                   	push   %ebp
  801e84:	89 e5                	mov    %esp,%ebp
  801e86:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e89:	83 ec 04             	sub    $0x4,%esp
  801e8c:	68 e8 46 80 00       	push   $0x8046e8
  801e91:	68 18 01 00 00       	push   $0x118
  801e96:	68 e7 45 80 00       	push   $0x8045e7
  801e9b:	e8 fd e9 ff ff       	call   80089d <_panic>

00801ea0 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801ea0:	55                   	push   %ebp
  801ea1:	89 e5                	mov    %esp,%ebp
  801ea3:	57                   	push   %edi
  801ea4:	56                   	push   %esi
  801ea5:	53                   	push   %ebx
  801ea6:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  801eac:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eaf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801eb2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801eb5:	8b 7d 18             	mov    0x18(%ebp),%edi
  801eb8:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801ebb:	cd 30                	int    $0x30
  801ebd:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801ec0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801ec3:	83 c4 10             	add    $0x10,%esp
  801ec6:	5b                   	pop    %ebx
  801ec7:	5e                   	pop    %esi
  801ec8:	5f                   	pop    %edi
  801ec9:	5d                   	pop    %ebp
  801eca:	c3                   	ret    

00801ecb <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801ecb:	55                   	push   %ebp
  801ecc:	89 e5                	mov    %esp,%ebp
  801ece:	83 ec 04             	sub    $0x4,%esp
  801ed1:	8b 45 10             	mov    0x10(%ebp),%eax
  801ed4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801ed7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801edb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ede:	6a 00                	push   $0x0
  801ee0:	6a 00                	push   $0x0
  801ee2:	52                   	push   %edx
  801ee3:	ff 75 0c             	pushl  0xc(%ebp)
  801ee6:	50                   	push   %eax
  801ee7:	6a 00                	push   $0x0
  801ee9:	e8 b2 ff ff ff       	call   801ea0 <syscall>
  801eee:	83 c4 18             	add    $0x18,%esp
}
  801ef1:	90                   	nop
  801ef2:	c9                   	leave  
  801ef3:	c3                   	ret    

00801ef4 <sys_cgetc>:

int
sys_cgetc(void)
{
  801ef4:	55                   	push   %ebp
  801ef5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801ef7:	6a 00                	push   $0x0
  801ef9:	6a 00                	push   $0x0
  801efb:	6a 00                	push   $0x0
  801efd:	6a 00                	push   $0x0
  801eff:	6a 00                	push   $0x0
  801f01:	6a 01                	push   $0x1
  801f03:	e8 98 ff ff ff       	call   801ea0 <syscall>
  801f08:	83 c4 18             	add    $0x18,%esp
}
  801f0b:	c9                   	leave  
  801f0c:	c3                   	ret    

00801f0d <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801f0d:	55                   	push   %ebp
  801f0e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801f10:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f13:	8b 45 08             	mov    0x8(%ebp),%eax
  801f16:	6a 00                	push   $0x0
  801f18:	6a 00                	push   $0x0
  801f1a:	6a 00                	push   $0x0
  801f1c:	52                   	push   %edx
  801f1d:	50                   	push   %eax
  801f1e:	6a 05                	push   $0x5
  801f20:	e8 7b ff ff ff       	call   801ea0 <syscall>
  801f25:	83 c4 18             	add    $0x18,%esp
}
  801f28:	c9                   	leave  
  801f29:	c3                   	ret    

00801f2a <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801f2a:	55                   	push   %ebp
  801f2b:	89 e5                	mov    %esp,%ebp
  801f2d:	56                   	push   %esi
  801f2e:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801f2f:	8b 75 18             	mov    0x18(%ebp),%esi
  801f32:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f35:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f38:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3e:	56                   	push   %esi
  801f3f:	53                   	push   %ebx
  801f40:	51                   	push   %ecx
  801f41:	52                   	push   %edx
  801f42:	50                   	push   %eax
  801f43:	6a 06                	push   $0x6
  801f45:	e8 56 ff ff ff       	call   801ea0 <syscall>
  801f4a:	83 c4 18             	add    $0x18,%esp
}
  801f4d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f50:	5b                   	pop    %ebx
  801f51:	5e                   	pop    %esi
  801f52:	5d                   	pop    %ebp
  801f53:	c3                   	ret    

00801f54 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801f54:	55                   	push   %ebp
  801f55:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801f57:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5d:	6a 00                	push   $0x0
  801f5f:	6a 00                	push   $0x0
  801f61:	6a 00                	push   $0x0
  801f63:	52                   	push   %edx
  801f64:	50                   	push   %eax
  801f65:	6a 07                	push   $0x7
  801f67:	e8 34 ff ff ff       	call   801ea0 <syscall>
  801f6c:	83 c4 18             	add    $0x18,%esp
}
  801f6f:	c9                   	leave  
  801f70:	c3                   	ret    

00801f71 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801f71:	55                   	push   %ebp
  801f72:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801f74:	6a 00                	push   $0x0
  801f76:	6a 00                	push   $0x0
  801f78:	6a 00                	push   $0x0
  801f7a:	ff 75 0c             	pushl  0xc(%ebp)
  801f7d:	ff 75 08             	pushl  0x8(%ebp)
  801f80:	6a 08                	push   $0x8
  801f82:	e8 19 ff ff ff       	call   801ea0 <syscall>
  801f87:	83 c4 18             	add    $0x18,%esp
}
  801f8a:	c9                   	leave  
  801f8b:	c3                   	ret    

00801f8c <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801f8c:	55                   	push   %ebp
  801f8d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801f8f:	6a 00                	push   $0x0
  801f91:	6a 00                	push   $0x0
  801f93:	6a 00                	push   $0x0
  801f95:	6a 00                	push   $0x0
  801f97:	6a 00                	push   $0x0
  801f99:	6a 09                	push   $0x9
  801f9b:	e8 00 ff ff ff       	call   801ea0 <syscall>
  801fa0:	83 c4 18             	add    $0x18,%esp
}
  801fa3:	c9                   	leave  
  801fa4:	c3                   	ret    

00801fa5 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801fa5:	55                   	push   %ebp
  801fa6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801fa8:	6a 00                	push   $0x0
  801faa:	6a 00                	push   $0x0
  801fac:	6a 00                	push   $0x0
  801fae:	6a 00                	push   $0x0
  801fb0:	6a 00                	push   $0x0
  801fb2:	6a 0a                	push   $0xa
  801fb4:	e8 e7 fe ff ff       	call   801ea0 <syscall>
  801fb9:	83 c4 18             	add    $0x18,%esp
}
  801fbc:	c9                   	leave  
  801fbd:	c3                   	ret    

00801fbe <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801fbe:	55                   	push   %ebp
  801fbf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801fc1:	6a 00                	push   $0x0
  801fc3:	6a 00                	push   $0x0
  801fc5:	6a 00                	push   $0x0
  801fc7:	6a 00                	push   $0x0
  801fc9:	6a 00                	push   $0x0
  801fcb:	6a 0b                	push   $0xb
  801fcd:	e8 ce fe ff ff       	call   801ea0 <syscall>
  801fd2:	83 c4 18             	add    $0x18,%esp
}
  801fd5:	c9                   	leave  
  801fd6:	c3                   	ret    

00801fd7 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801fd7:	55                   	push   %ebp
  801fd8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801fda:	6a 00                	push   $0x0
  801fdc:	6a 00                	push   $0x0
  801fde:	6a 00                	push   $0x0
  801fe0:	ff 75 0c             	pushl  0xc(%ebp)
  801fe3:	ff 75 08             	pushl  0x8(%ebp)
  801fe6:	6a 0f                	push   $0xf
  801fe8:	e8 b3 fe ff ff       	call   801ea0 <syscall>
  801fed:	83 c4 18             	add    $0x18,%esp
	return;
  801ff0:	90                   	nop
}
  801ff1:	c9                   	leave  
  801ff2:	c3                   	ret    

00801ff3 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801ff3:	55                   	push   %ebp
  801ff4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801ff6:	6a 00                	push   $0x0
  801ff8:	6a 00                	push   $0x0
  801ffa:	6a 00                	push   $0x0
  801ffc:	ff 75 0c             	pushl  0xc(%ebp)
  801fff:	ff 75 08             	pushl  0x8(%ebp)
  802002:	6a 10                	push   $0x10
  802004:	e8 97 fe ff ff       	call   801ea0 <syscall>
  802009:	83 c4 18             	add    $0x18,%esp
	return ;
  80200c:	90                   	nop
}
  80200d:	c9                   	leave  
  80200e:	c3                   	ret    

0080200f <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80200f:	55                   	push   %ebp
  802010:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802012:	6a 00                	push   $0x0
  802014:	6a 00                	push   $0x0
  802016:	ff 75 10             	pushl  0x10(%ebp)
  802019:	ff 75 0c             	pushl  0xc(%ebp)
  80201c:	ff 75 08             	pushl  0x8(%ebp)
  80201f:	6a 11                	push   $0x11
  802021:	e8 7a fe ff ff       	call   801ea0 <syscall>
  802026:	83 c4 18             	add    $0x18,%esp
	return ;
  802029:	90                   	nop
}
  80202a:	c9                   	leave  
  80202b:	c3                   	ret    

0080202c <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80202c:	55                   	push   %ebp
  80202d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80202f:	6a 00                	push   $0x0
  802031:	6a 00                	push   $0x0
  802033:	6a 00                	push   $0x0
  802035:	6a 00                	push   $0x0
  802037:	6a 00                	push   $0x0
  802039:	6a 0c                	push   $0xc
  80203b:	e8 60 fe ff ff       	call   801ea0 <syscall>
  802040:	83 c4 18             	add    $0x18,%esp
}
  802043:	c9                   	leave  
  802044:	c3                   	ret    

00802045 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802045:	55                   	push   %ebp
  802046:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802048:	6a 00                	push   $0x0
  80204a:	6a 00                	push   $0x0
  80204c:	6a 00                	push   $0x0
  80204e:	6a 00                	push   $0x0
  802050:	ff 75 08             	pushl  0x8(%ebp)
  802053:	6a 0d                	push   $0xd
  802055:	e8 46 fe ff ff       	call   801ea0 <syscall>
  80205a:	83 c4 18             	add    $0x18,%esp
}
  80205d:	c9                   	leave  
  80205e:	c3                   	ret    

0080205f <sys_scarce_memory>:

void sys_scarce_memory()
{
  80205f:	55                   	push   %ebp
  802060:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802062:	6a 00                	push   $0x0
  802064:	6a 00                	push   $0x0
  802066:	6a 00                	push   $0x0
  802068:	6a 00                	push   $0x0
  80206a:	6a 00                	push   $0x0
  80206c:	6a 0e                	push   $0xe
  80206e:	e8 2d fe ff ff       	call   801ea0 <syscall>
  802073:	83 c4 18             	add    $0x18,%esp
}
  802076:	90                   	nop
  802077:	c9                   	leave  
  802078:	c3                   	ret    

00802079 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802079:	55                   	push   %ebp
  80207a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80207c:	6a 00                	push   $0x0
  80207e:	6a 00                	push   $0x0
  802080:	6a 00                	push   $0x0
  802082:	6a 00                	push   $0x0
  802084:	6a 00                	push   $0x0
  802086:	6a 13                	push   $0x13
  802088:	e8 13 fe ff ff       	call   801ea0 <syscall>
  80208d:	83 c4 18             	add    $0x18,%esp
}
  802090:	90                   	nop
  802091:	c9                   	leave  
  802092:	c3                   	ret    

00802093 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802093:	55                   	push   %ebp
  802094:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802096:	6a 00                	push   $0x0
  802098:	6a 00                	push   $0x0
  80209a:	6a 00                	push   $0x0
  80209c:	6a 00                	push   $0x0
  80209e:	6a 00                	push   $0x0
  8020a0:	6a 14                	push   $0x14
  8020a2:	e8 f9 fd ff ff       	call   801ea0 <syscall>
  8020a7:	83 c4 18             	add    $0x18,%esp
}
  8020aa:	90                   	nop
  8020ab:	c9                   	leave  
  8020ac:	c3                   	ret    

008020ad <sys_cputc>:


void
sys_cputc(const char c)
{
  8020ad:	55                   	push   %ebp
  8020ae:	89 e5                	mov    %esp,%ebp
  8020b0:	83 ec 04             	sub    $0x4,%esp
  8020b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8020b9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8020bd:	6a 00                	push   $0x0
  8020bf:	6a 00                	push   $0x0
  8020c1:	6a 00                	push   $0x0
  8020c3:	6a 00                	push   $0x0
  8020c5:	50                   	push   %eax
  8020c6:	6a 15                	push   $0x15
  8020c8:	e8 d3 fd ff ff       	call   801ea0 <syscall>
  8020cd:	83 c4 18             	add    $0x18,%esp
}
  8020d0:	90                   	nop
  8020d1:	c9                   	leave  
  8020d2:	c3                   	ret    

008020d3 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8020d3:	55                   	push   %ebp
  8020d4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8020d6:	6a 00                	push   $0x0
  8020d8:	6a 00                	push   $0x0
  8020da:	6a 00                	push   $0x0
  8020dc:	6a 00                	push   $0x0
  8020de:	6a 00                	push   $0x0
  8020e0:	6a 16                	push   $0x16
  8020e2:	e8 b9 fd ff ff       	call   801ea0 <syscall>
  8020e7:	83 c4 18             	add    $0x18,%esp
}
  8020ea:	90                   	nop
  8020eb:	c9                   	leave  
  8020ec:	c3                   	ret    

008020ed <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8020ed:	55                   	push   %ebp
  8020ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8020f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f3:	6a 00                	push   $0x0
  8020f5:	6a 00                	push   $0x0
  8020f7:	6a 00                	push   $0x0
  8020f9:	ff 75 0c             	pushl  0xc(%ebp)
  8020fc:	50                   	push   %eax
  8020fd:	6a 17                	push   $0x17
  8020ff:	e8 9c fd ff ff       	call   801ea0 <syscall>
  802104:	83 c4 18             	add    $0x18,%esp
}
  802107:	c9                   	leave  
  802108:	c3                   	ret    

00802109 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802109:	55                   	push   %ebp
  80210a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80210c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80210f:	8b 45 08             	mov    0x8(%ebp),%eax
  802112:	6a 00                	push   $0x0
  802114:	6a 00                	push   $0x0
  802116:	6a 00                	push   $0x0
  802118:	52                   	push   %edx
  802119:	50                   	push   %eax
  80211a:	6a 1a                	push   $0x1a
  80211c:	e8 7f fd ff ff       	call   801ea0 <syscall>
  802121:	83 c4 18             	add    $0x18,%esp
}
  802124:	c9                   	leave  
  802125:	c3                   	ret    

00802126 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802126:	55                   	push   %ebp
  802127:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802129:	8b 55 0c             	mov    0xc(%ebp),%edx
  80212c:	8b 45 08             	mov    0x8(%ebp),%eax
  80212f:	6a 00                	push   $0x0
  802131:	6a 00                	push   $0x0
  802133:	6a 00                	push   $0x0
  802135:	52                   	push   %edx
  802136:	50                   	push   %eax
  802137:	6a 18                	push   $0x18
  802139:	e8 62 fd ff ff       	call   801ea0 <syscall>
  80213e:	83 c4 18             	add    $0x18,%esp
}
  802141:	90                   	nop
  802142:	c9                   	leave  
  802143:	c3                   	ret    

00802144 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802144:	55                   	push   %ebp
  802145:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802147:	8b 55 0c             	mov    0xc(%ebp),%edx
  80214a:	8b 45 08             	mov    0x8(%ebp),%eax
  80214d:	6a 00                	push   $0x0
  80214f:	6a 00                	push   $0x0
  802151:	6a 00                	push   $0x0
  802153:	52                   	push   %edx
  802154:	50                   	push   %eax
  802155:	6a 19                	push   $0x19
  802157:	e8 44 fd ff ff       	call   801ea0 <syscall>
  80215c:	83 c4 18             	add    $0x18,%esp
}
  80215f:	90                   	nop
  802160:	c9                   	leave  
  802161:	c3                   	ret    

00802162 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802162:	55                   	push   %ebp
  802163:	89 e5                	mov    %esp,%ebp
  802165:	83 ec 04             	sub    $0x4,%esp
  802168:	8b 45 10             	mov    0x10(%ebp),%eax
  80216b:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80216e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802171:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802175:	8b 45 08             	mov    0x8(%ebp),%eax
  802178:	6a 00                	push   $0x0
  80217a:	51                   	push   %ecx
  80217b:	52                   	push   %edx
  80217c:	ff 75 0c             	pushl  0xc(%ebp)
  80217f:	50                   	push   %eax
  802180:	6a 1b                	push   $0x1b
  802182:	e8 19 fd ff ff       	call   801ea0 <syscall>
  802187:	83 c4 18             	add    $0x18,%esp
}
  80218a:	c9                   	leave  
  80218b:	c3                   	ret    

0080218c <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80218c:	55                   	push   %ebp
  80218d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80218f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802192:	8b 45 08             	mov    0x8(%ebp),%eax
  802195:	6a 00                	push   $0x0
  802197:	6a 00                	push   $0x0
  802199:	6a 00                	push   $0x0
  80219b:	52                   	push   %edx
  80219c:	50                   	push   %eax
  80219d:	6a 1c                	push   $0x1c
  80219f:	e8 fc fc ff ff       	call   801ea0 <syscall>
  8021a4:	83 c4 18             	add    $0x18,%esp
}
  8021a7:	c9                   	leave  
  8021a8:	c3                   	ret    

008021a9 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8021a9:	55                   	push   %ebp
  8021aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8021ac:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b5:	6a 00                	push   $0x0
  8021b7:	6a 00                	push   $0x0
  8021b9:	51                   	push   %ecx
  8021ba:	52                   	push   %edx
  8021bb:	50                   	push   %eax
  8021bc:	6a 1d                	push   $0x1d
  8021be:	e8 dd fc ff ff       	call   801ea0 <syscall>
  8021c3:	83 c4 18             	add    $0x18,%esp
}
  8021c6:	c9                   	leave  
  8021c7:	c3                   	ret    

008021c8 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8021c8:	55                   	push   %ebp
  8021c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8021cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d1:	6a 00                	push   $0x0
  8021d3:	6a 00                	push   $0x0
  8021d5:	6a 00                	push   $0x0
  8021d7:	52                   	push   %edx
  8021d8:	50                   	push   %eax
  8021d9:	6a 1e                	push   $0x1e
  8021db:	e8 c0 fc ff ff       	call   801ea0 <syscall>
  8021e0:	83 c4 18             	add    $0x18,%esp
}
  8021e3:	c9                   	leave  
  8021e4:	c3                   	ret    

008021e5 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8021e5:	55                   	push   %ebp
  8021e6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8021e8:	6a 00                	push   $0x0
  8021ea:	6a 00                	push   $0x0
  8021ec:	6a 00                	push   $0x0
  8021ee:	6a 00                	push   $0x0
  8021f0:	6a 00                	push   $0x0
  8021f2:	6a 1f                	push   $0x1f
  8021f4:	e8 a7 fc ff ff       	call   801ea0 <syscall>
  8021f9:	83 c4 18             	add    $0x18,%esp
}
  8021fc:	c9                   	leave  
  8021fd:	c3                   	ret    

008021fe <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8021fe:	55                   	push   %ebp
  8021ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802201:	8b 45 08             	mov    0x8(%ebp),%eax
  802204:	6a 00                	push   $0x0
  802206:	ff 75 14             	pushl  0x14(%ebp)
  802209:	ff 75 10             	pushl  0x10(%ebp)
  80220c:	ff 75 0c             	pushl  0xc(%ebp)
  80220f:	50                   	push   %eax
  802210:	6a 20                	push   $0x20
  802212:	e8 89 fc ff ff       	call   801ea0 <syscall>
  802217:	83 c4 18             	add    $0x18,%esp
}
  80221a:	c9                   	leave  
  80221b:	c3                   	ret    

0080221c <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80221c:	55                   	push   %ebp
  80221d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80221f:	8b 45 08             	mov    0x8(%ebp),%eax
  802222:	6a 00                	push   $0x0
  802224:	6a 00                	push   $0x0
  802226:	6a 00                	push   $0x0
  802228:	6a 00                	push   $0x0
  80222a:	50                   	push   %eax
  80222b:	6a 21                	push   $0x21
  80222d:	e8 6e fc ff ff       	call   801ea0 <syscall>
  802232:	83 c4 18             	add    $0x18,%esp
}
  802235:	90                   	nop
  802236:	c9                   	leave  
  802237:	c3                   	ret    

00802238 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802238:	55                   	push   %ebp
  802239:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80223b:	8b 45 08             	mov    0x8(%ebp),%eax
  80223e:	6a 00                	push   $0x0
  802240:	6a 00                	push   $0x0
  802242:	6a 00                	push   $0x0
  802244:	6a 00                	push   $0x0
  802246:	50                   	push   %eax
  802247:	6a 22                	push   $0x22
  802249:	e8 52 fc ff ff       	call   801ea0 <syscall>
  80224e:	83 c4 18             	add    $0x18,%esp
}
  802251:	c9                   	leave  
  802252:	c3                   	ret    

00802253 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802253:	55                   	push   %ebp
  802254:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802256:	6a 00                	push   $0x0
  802258:	6a 00                	push   $0x0
  80225a:	6a 00                	push   $0x0
  80225c:	6a 00                	push   $0x0
  80225e:	6a 00                	push   $0x0
  802260:	6a 02                	push   $0x2
  802262:	e8 39 fc ff ff       	call   801ea0 <syscall>
  802267:	83 c4 18             	add    $0x18,%esp
}
  80226a:	c9                   	leave  
  80226b:	c3                   	ret    

0080226c <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80226c:	55                   	push   %ebp
  80226d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80226f:	6a 00                	push   $0x0
  802271:	6a 00                	push   $0x0
  802273:	6a 00                	push   $0x0
  802275:	6a 00                	push   $0x0
  802277:	6a 00                	push   $0x0
  802279:	6a 03                	push   $0x3
  80227b:	e8 20 fc ff ff       	call   801ea0 <syscall>
  802280:	83 c4 18             	add    $0x18,%esp
}
  802283:	c9                   	leave  
  802284:	c3                   	ret    

00802285 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802285:	55                   	push   %ebp
  802286:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802288:	6a 00                	push   $0x0
  80228a:	6a 00                	push   $0x0
  80228c:	6a 00                	push   $0x0
  80228e:	6a 00                	push   $0x0
  802290:	6a 00                	push   $0x0
  802292:	6a 04                	push   $0x4
  802294:	e8 07 fc ff ff       	call   801ea0 <syscall>
  802299:	83 c4 18             	add    $0x18,%esp
}
  80229c:	c9                   	leave  
  80229d:	c3                   	ret    

0080229e <sys_exit_env>:


void sys_exit_env(void)
{
  80229e:	55                   	push   %ebp
  80229f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8022a1:	6a 00                	push   $0x0
  8022a3:	6a 00                	push   $0x0
  8022a5:	6a 00                	push   $0x0
  8022a7:	6a 00                	push   $0x0
  8022a9:	6a 00                	push   $0x0
  8022ab:	6a 23                	push   $0x23
  8022ad:	e8 ee fb ff ff       	call   801ea0 <syscall>
  8022b2:	83 c4 18             	add    $0x18,%esp
}
  8022b5:	90                   	nop
  8022b6:	c9                   	leave  
  8022b7:	c3                   	ret    

008022b8 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8022b8:	55                   	push   %ebp
  8022b9:	89 e5                	mov    %esp,%ebp
  8022bb:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8022be:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8022c1:	8d 50 04             	lea    0x4(%eax),%edx
  8022c4:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8022c7:	6a 00                	push   $0x0
  8022c9:	6a 00                	push   $0x0
  8022cb:	6a 00                	push   $0x0
  8022cd:	52                   	push   %edx
  8022ce:	50                   	push   %eax
  8022cf:	6a 24                	push   $0x24
  8022d1:	e8 ca fb ff ff       	call   801ea0 <syscall>
  8022d6:	83 c4 18             	add    $0x18,%esp
	return result;
  8022d9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8022df:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8022e2:	89 01                	mov    %eax,(%ecx)
  8022e4:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8022e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ea:	c9                   	leave  
  8022eb:	c2 04 00             	ret    $0x4

008022ee <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8022ee:	55                   	push   %ebp
  8022ef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8022f1:	6a 00                	push   $0x0
  8022f3:	6a 00                	push   $0x0
  8022f5:	ff 75 10             	pushl  0x10(%ebp)
  8022f8:	ff 75 0c             	pushl  0xc(%ebp)
  8022fb:	ff 75 08             	pushl  0x8(%ebp)
  8022fe:	6a 12                	push   $0x12
  802300:	e8 9b fb ff ff       	call   801ea0 <syscall>
  802305:	83 c4 18             	add    $0x18,%esp
	return ;
  802308:	90                   	nop
}
  802309:	c9                   	leave  
  80230a:	c3                   	ret    

0080230b <sys_rcr2>:
uint32 sys_rcr2()
{
  80230b:	55                   	push   %ebp
  80230c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80230e:	6a 00                	push   $0x0
  802310:	6a 00                	push   $0x0
  802312:	6a 00                	push   $0x0
  802314:	6a 00                	push   $0x0
  802316:	6a 00                	push   $0x0
  802318:	6a 25                	push   $0x25
  80231a:	e8 81 fb ff ff       	call   801ea0 <syscall>
  80231f:	83 c4 18             	add    $0x18,%esp
}
  802322:	c9                   	leave  
  802323:	c3                   	ret    

00802324 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802324:	55                   	push   %ebp
  802325:	89 e5                	mov    %esp,%ebp
  802327:	83 ec 04             	sub    $0x4,%esp
  80232a:	8b 45 08             	mov    0x8(%ebp),%eax
  80232d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802330:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802334:	6a 00                	push   $0x0
  802336:	6a 00                	push   $0x0
  802338:	6a 00                	push   $0x0
  80233a:	6a 00                	push   $0x0
  80233c:	50                   	push   %eax
  80233d:	6a 26                	push   $0x26
  80233f:	e8 5c fb ff ff       	call   801ea0 <syscall>
  802344:	83 c4 18             	add    $0x18,%esp
	return ;
  802347:	90                   	nop
}
  802348:	c9                   	leave  
  802349:	c3                   	ret    

0080234a <rsttst>:
void rsttst()
{
  80234a:	55                   	push   %ebp
  80234b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80234d:	6a 00                	push   $0x0
  80234f:	6a 00                	push   $0x0
  802351:	6a 00                	push   $0x0
  802353:	6a 00                	push   $0x0
  802355:	6a 00                	push   $0x0
  802357:	6a 28                	push   $0x28
  802359:	e8 42 fb ff ff       	call   801ea0 <syscall>
  80235e:	83 c4 18             	add    $0x18,%esp
	return ;
  802361:	90                   	nop
}
  802362:	c9                   	leave  
  802363:	c3                   	ret    

00802364 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802364:	55                   	push   %ebp
  802365:	89 e5                	mov    %esp,%ebp
  802367:	83 ec 04             	sub    $0x4,%esp
  80236a:	8b 45 14             	mov    0x14(%ebp),%eax
  80236d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802370:	8b 55 18             	mov    0x18(%ebp),%edx
  802373:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802377:	52                   	push   %edx
  802378:	50                   	push   %eax
  802379:	ff 75 10             	pushl  0x10(%ebp)
  80237c:	ff 75 0c             	pushl  0xc(%ebp)
  80237f:	ff 75 08             	pushl  0x8(%ebp)
  802382:	6a 27                	push   $0x27
  802384:	e8 17 fb ff ff       	call   801ea0 <syscall>
  802389:	83 c4 18             	add    $0x18,%esp
	return ;
  80238c:	90                   	nop
}
  80238d:	c9                   	leave  
  80238e:	c3                   	ret    

0080238f <chktst>:
void chktst(uint32 n)
{
  80238f:	55                   	push   %ebp
  802390:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802392:	6a 00                	push   $0x0
  802394:	6a 00                	push   $0x0
  802396:	6a 00                	push   $0x0
  802398:	6a 00                	push   $0x0
  80239a:	ff 75 08             	pushl  0x8(%ebp)
  80239d:	6a 29                	push   $0x29
  80239f:	e8 fc fa ff ff       	call   801ea0 <syscall>
  8023a4:	83 c4 18             	add    $0x18,%esp
	return ;
  8023a7:	90                   	nop
}
  8023a8:	c9                   	leave  
  8023a9:	c3                   	ret    

008023aa <inctst>:

void inctst()
{
  8023aa:	55                   	push   %ebp
  8023ab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8023ad:	6a 00                	push   $0x0
  8023af:	6a 00                	push   $0x0
  8023b1:	6a 00                	push   $0x0
  8023b3:	6a 00                	push   $0x0
  8023b5:	6a 00                	push   $0x0
  8023b7:	6a 2a                	push   $0x2a
  8023b9:	e8 e2 fa ff ff       	call   801ea0 <syscall>
  8023be:	83 c4 18             	add    $0x18,%esp
	return ;
  8023c1:	90                   	nop
}
  8023c2:	c9                   	leave  
  8023c3:	c3                   	ret    

008023c4 <gettst>:
uint32 gettst()
{
  8023c4:	55                   	push   %ebp
  8023c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8023c7:	6a 00                	push   $0x0
  8023c9:	6a 00                	push   $0x0
  8023cb:	6a 00                	push   $0x0
  8023cd:	6a 00                	push   $0x0
  8023cf:	6a 00                	push   $0x0
  8023d1:	6a 2b                	push   $0x2b
  8023d3:	e8 c8 fa ff ff       	call   801ea0 <syscall>
  8023d8:	83 c4 18             	add    $0x18,%esp
}
  8023db:	c9                   	leave  
  8023dc:	c3                   	ret    

008023dd <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8023dd:	55                   	push   %ebp
  8023de:	89 e5                	mov    %esp,%ebp
  8023e0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023e3:	6a 00                	push   $0x0
  8023e5:	6a 00                	push   $0x0
  8023e7:	6a 00                	push   $0x0
  8023e9:	6a 00                	push   $0x0
  8023eb:	6a 00                	push   $0x0
  8023ed:	6a 2c                	push   $0x2c
  8023ef:	e8 ac fa ff ff       	call   801ea0 <syscall>
  8023f4:	83 c4 18             	add    $0x18,%esp
  8023f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8023fa:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8023fe:	75 07                	jne    802407 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802400:	b8 01 00 00 00       	mov    $0x1,%eax
  802405:	eb 05                	jmp    80240c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802407:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80240c:	c9                   	leave  
  80240d:	c3                   	ret    

0080240e <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80240e:	55                   	push   %ebp
  80240f:	89 e5                	mov    %esp,%ebp
  802411:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802414:	6a 00                	push   $0x0
  802416:	6a 00                	push   $0x0
  802418:	6a 00                	push   $0x0
  80241a:	6a 00                	push   $0x0
  80241c:	6a 00                	push   $0x0
  80241e:	6a 2c                	push   $0x2c
  802420:	e8 7b fa ff ff       	call   801ea0 <syscall>
  802425:	83 c4 18             	add    $0x18,%esp
  802428:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80242b:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80242f:	75 07                	jne    802438 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802431:	b8 01 00 00 00       	mov    $0x1,%eax
  802436:	eb 05                	jmp    80243d <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802438:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80243d:	c9                   	leave  
  80243e:	c3                   	ret    

0080243f <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80243f:	55                   	push   %ebp
  802440:	89 e5                	mov    %esp,%ebp
  802442:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802445:	6a 00                	push   $0x0
  802447:	6a 00                	push   $0x0
  802449:	6a 00                	push   $0x0
  80244b:	6a 00                	push   $0x0
  80244d:	6a 00                	push   $0x0
  80244f:	6a 2c                	push   $0x2c
  802451:	e8 4a fa ff ff       	call   801ea0 <syscall>
  802456:	83 c4 18             	add    $0x18,%esp
  802459:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80245c:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802460:	75 07                	jne    802469 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802462:	b8 01 00 00 00       	mov    $0x1,%eax
  802467:	eb 05                	jmp    80246e <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802469:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80246e:	c9                   	leave  
  80246f:	c3                   	ret    

00802470 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802470:	55                   	push   %ebp
  802471:	89 e5                	mov    %esp,%ebp
  802473:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802476:	6a 00                	push   $0x0
  802478:	6a 00                	push   $0x0
  80247a:	6a 00                	push   $0x0
  80247c:	6a 00                	push   $0x0
  80247e:	6a 00                	push   $0x0
  802480:	6a 2c                	push   $0x2c
  802482:	e8 19 fa ff ff       	call   801ea0 <syscall>
  802487:	83 c4 18             	add    $0x18,%esp
  80248a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80248d:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802491:	75 07                	jne    80249a <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802493:	b8 01 00 00 00       	mov    $0x1,%eax
  802498:	eb 05                	jmp    80249f <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80249a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80249f:	c9                   	leave  
  8024a0:	c3                   	ret    

008024a1 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8024a1:	55                   	push   %ebp
  8024a2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8024a4:	6a 00                	push   $0x0
  8024a6:	6a 00                	push   $0x0
  8024a8:	6a 00                	push   $0x0
  8024aa:	6a 00                	push   $0x0
  8024ac:	ff 75 08             	pushl  0x8(%ebp)
  8024af:	6a 2d                	push   $0x2d
  8024b1:	e8 ea f9 ff ff       	call   801ea0 <syscall>
  8024b6:	83 c4 18             	add    $0x18,%esp
	return ;
  8024b9:	90                   	nop
}
  8024ba:	c9                   	leave  
  8024bb:	c3                   	ret    

008024bc <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8024bc:	55                   	push   %ebp
  8024bd:	89 e5                	mov    %esp,%ebp
  8024bf:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8024c0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8024c3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8024c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8024cc:	6a 00                	push   $0x0
  8024ce:	53                   	push   %ebx
  8024cf:	51                   	push   %ecx
  8024d0:	52                   	push   %edx
  8024d1:	50                   	push   %eax
  8024d2:	6a 2e                	push   $0x2e
  8024d4:	e8 c7 f9 ff ff       	call   801ea0 <syscall>
  8024d9:	83 c4 18             	add    $0x18,%esp
}
  8024dc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8024df:	c9                   	leave  
  8024e0:	c3                   	ret    

008024e1 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8024e1:	55                   	push   %ebp
  8024e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8024e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ea:	6a 00                	push   $0x0
  8024ec:	6a 00                	push   $0x0
  8024ee:	6a 00                	push   $0x0
  8024f0:	52                   	push   %edx
  8024f1:	50                   	push   %eax
  8024f2:	6a 2f                	push   $0x2f
  8024f4:	e8 a7 f9 ff ff       	call   801ea0 <syscall>
  8024f9:	83 c4 18             	add    $0x18,%esp
}
  8024fc:	c9                   	leave  
  8024fd:	c3                   	ret    

008024fe <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8024fe:	55                   	push   %ebp
  8024ff:	89 e5                	mov    %esp,%ebp
  802501:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802504:	83 ec 0c             	sub    $0xc,%esp
  802507:	68 f8 46 80 00       	push   $0x8046f8
  80250c:	e8 40 e6 ff ff       	call   800b51 <cprintf>
  802511:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802514:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  80251b:	83 ec 0c             	sub    $0xc,%esp
  80251e:	68 24 47 80 00       	push   $0x804724
  802523:	e8 29 e6 ff ff       	call   800b51 <cprintf>
  802528:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  80252b:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80252f:	a1 38 51 80 00       	mov    0x805138,%eax
  802534:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802537:	eb 56                	jmp    80258f <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802539:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80253d:	74 1c                	je     80255b <print_mem_block_lists+0x5d>
  80253f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802542:	8b 50 08             	mov    0x8(%eax),%edx
  802545:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802548:	8b 48 08             	mov    0x8(%eax),%ecx
  80254b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80254e:	8b 40 0c             	mov    0xc(%eax),%eax
  802551:	01 c8                	add    %ecx,%eax
  802553:	39 c2                	cmp    %eax,%edx
  802555:	73 04                	jae    80255b <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802557:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80255b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255e:	8b 50 08             	mov    0x8(%eax),%edx
  802561:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802564:	8b 40 0c             	mov    0xc(%eax),%eax
  802567:	01 c2                	add    %eax,%edx
  802569:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256c:	8b 40 08             	mov    0x8(%eax),%eax
  80256f:	83 ec 04             	sub    $0x4,%esp
  802572:	52                   	push   %edx
  802573:	50                   	push   %eax
  802574:	68 39 47 80 00       	push   $0x804739
  802579:	e8 d3 e5 ff ff       	call   800b51 <cprintf>
  80257e:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802581:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802584:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802587:	a1 40 51 80 00       	mov    0x805140,%eax
  80258c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80258f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802593:	74 07                	je     80259c <print_mem_block_lists+0x9e>
  802595:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802598:	8b 00                	mov    (%eax),%eax
  80259a:	eb 05                	jmp    8025a1 <print_mem_block_lists+0xa3>
  80259c:	b8 00 00 00 00       	mov    $0x0,%eax
  8025a1:	a3 40 51 80 00       	mov    %eax,0x805140
  8025a6:	a1 40 51 80 00       	mov    0x805140,%eax
  8025ab:	85 c0                	test   %eax,%eax
  8025ad:	75 8a                	jne    802539 <print_mem_block_lists+0x3b>
  8025af:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025b3:	75 84                	jne    802539 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8025b5:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8025b9:	75 10                	jne    8025cb <print_mem_block_lists+0xcd>
  8025bb:	83 ec 0c             	sub    $0xc,%esp
  8025be:	68 48 47 80 00       	push   $0x804748
  8025c3:	e8 89 e5 ff ff       	call   800b51 <cprintf>
  8025c8:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8025cb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8025d2:	83 ec 0c             	sub    $0xc,%esp
  8025d5:	68 6c 47 80 00       	push   $0x80476c
  8025da:	e8 72 e5 ff ff       	call   800b51 <cprintf>
  8025df:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8025e2:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8025e6:	a1 40 50 80 00       	mov    0x805040,%eax
  8025eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025ee:	eb 56                	jmp    802646 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8025f0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025f4:	74 1c                	je     802612 <print_mem_block_lists+0x114>
  8025f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f9:	8b 50 08             	mov    0x8(%eax),%edx
  8025fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025ff:	8b 48 08             	mov    0x8(%eax),%ecx
  802602:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802605:	8b 40 0c             	mov    0xc(%eax),%eax
  802608:	01 c8                	add    %ecx,%eax
  80260a:	39 c2                	cmp    %eax,%edx
  80260c:	73 04                	jae    802612 <print_mem_block_lists+0x114>
			sorted = 0 ;
  80260e:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802612:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802615:	8b 50 08             	mov    0x8(%eax),%edx
  802618:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261b:	8b 40 0c             	mov    0xc(%eax),%eax
  80261e:	01 c2                	add    %eax,%edx
  802620:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802623:	8b 40 08             	mov    0x8(%eax),%eax
  802626:	83 ec 04             	sub    $0x4,%esp
  802629:	52                   	push   %edx
  80262a:	50                   	push   %eax
  80262b:	68 39 47 80 00       	push   $0x804739
  802630:	e8 1c e5 ff ff       	call   800b51 <cprintf>
  802635:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802638:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80263e:	a1 48 50 80 00       	mov    0x805048,%eax
  802643:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802646:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80264a:	74 07                	je     802653 <print_mem_block_lists+0x155>
  80264c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264f:	8b 00                	mov    (%eax),%eax
  802651:	eb 05                	jmp    802658 <print_mem_block_lists+0x15a>
  802653:	b8 00 00 00 00       	mov    $0x0,%eax
  802658:	a3 48 50 80 00       	mov    %eax,0x805048
  80265d:	a1 48 50 80 00       	mov    0x805048,%eax
  802662:	85 c0                	test   %eax,%eax
  802664:	75 8a                	jne    8025f0 <print_mem_block_lists+0xf2>
  802666:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80266a:	75 84                	jne    8025f0 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80266c:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802670:	75 10                	jne    802682 <print_mem_block_lists+0x184>
  802672:	83 ec 0c             	sub    $0xc,%esp
  802675:	68 84 47 80 00       	push   $0x804784
  80267a:	e8 d2 e4 ff ff       	call   800b51 <cprintf>
  80267f:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802682:	83 ec 0c             	sub    $0xc,%esp
  802685:	68 f8 46 80 00       	push   $0x8046f8
  80268a:	e8 c2 e4 ff ff       	call   800b51 <cprintf>
  80268f:	83 c4 10             	add    $0x10,%esp

}
  802692:	90                   	nop
  802693:	c9                   	leave  
  802694:	c3                   	ret    

00802695 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802695:	55                   	push   %ebp
  802696:	89 e5                	mov    %esp,%ebp
  802698:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  80269b:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8026a2:	00 00 00 
  8026a5:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8026ac:	00 00 00 
  8026af:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8026b6:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  8026b9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8026c0:	e9 9e 00 00 00       	jmp    802763 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  8026c5:	a1 50 50 80 00       	mov    0x805050,%eax
  8026ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026cd:	c1 e2 04             	shl    $0x4,%edx
  8026d0:	01 d0                	add    %edx,%eax
  8026d2:	85 c0                	test   %eax,%eax
  8026d4:	75 14                	jne    8026ea <initialize_MemBlocksList+0x55>
  8026d6:	83 ec 04             	sub    $0x4,%esp
  8026d9:	68 ac 47 80 00       	push   $0x8047ac
  8026de:	6a 46                	push   $0x46
  8026e0:	68 cf 47 80 00       	push   $0x8047cf
  8026e5:	e8 b3 e1 ff ff       	call   80089d <_panic>
  8026ea:	a1 50 50 80 00       	mov    0x805050,%eax
  8026ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026f2:	c1 e2 04             	shl    $0x4,%edx
  8026f5:	01 d0                	add    %edx,%eax
  8026f7:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8026fd:	89 10                	mov    %edx,(%eax)
  8026ff:	8b 00                	mov    (%eax),%eax
  802701:	85 c0                	test   %eax,%eax
  802703:	74 18                	je     80271d <initialize_MemBlocksList+0x88>
  802705:	a1 48 51 80 00       	mov    0x805148,%eax
  80270a:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802710:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802713:	c1 e1 04             	shl    $0x4,%ecx
  802716:	01 ca                	add    %ecx,%edx
  802718:	89 50 04             	mov    %edx,0x4(%eax)
  80271b:	eb 12                	jmp    80272f <initialize_MemBlocksList+0x9a>
  80271d:	a1 50 50 80 00       	mov    0x805050,%eax
  802722:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802725:	c1 e2 04             	shl    $0x4,%edx
  802728:	01 d0                	add    %edx,%eax
  80272a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80272f:	a1 50 50 80 00       	mov    0x805050,%eax
  802734:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802737:	c1 e2 04             	shl    $0x4,%edx
  80273a:	01 d0                	add    %edx,%eax
  80273c:	a3 48 51 80 00       	mov    %eax,0x805148
  802741:	a1 50 50 80 00       	mov    0x805050,%eax
  802746:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802749:	c1 e2 04             	shl    $0x4,%edx
  80274c:	01 d0                	add    %edx,%eax
  80274e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802755:	a1 54 51 80 00       	mov    0x805154,%eax
  80275a:	40                   	inc    %eax
  80275b:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802760:	ff 45 f4             	incl   -0xc(%ebp)
  802763:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802766:	3b 45 08             	cmp    0x8(%ebp),%eax
  802769:	0f 82 56 ff ff ff    	jb     8026c5 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  80276f:	90                   	nop
  802770:	c9                   	leave  
  802771:	c3                   	ret    

00802772 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802772:	55                   	push   %ebp
  802773:	89 e5                	mov    %esp,%ebp
  802775:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802778:	8b 45 08             	mov    0x8(%ebp),%eax
  80277b:	8b 00                	mov    (%eax),%eax
  80277d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802780:	eb 19                	jmp    80279b <find_block+0x29>
	{
		if(va==point->sva)
  802782:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802785:	8b 40 08             	mov    0x8(%eax),%eax
  802788:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80278b:	75 05                	jne    802792 <find_block+0x20>
		   return point;
  80278d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802790:	eb 36                	jmp    8027c8 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802792:	8b 45 08             	mov    0x8(%ebp),%eax
  802795:	8b 40 08             	mov    0x8(%eax),%eax
  802798:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80279b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80279f:	74 07                	je     8027a8 <find_block+0x36>
  8027a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8027a4:	8b 00                	mov    (%eax),%eax
  8027a6:	eb 05                	jmp    8027ad <find_block+0x3b>
  8027a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8027ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8027b0:	89 42 08             	mov    %eax,0x8(%edx)
  8027b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b6:	8b 40 08             	mov    0x8(%eax),%eax
  8027b9:	85 c0                	test   %eax,%eax
  8027bb:	75 c5                	jne    802782 <find_block+0x10>
  8027bd:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8027c1:	75 bf                	jne    802782 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  8027c3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027c8:	c9                   	leave  
  8027c9:	c3                   	ret    

008027ca <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8027ca:	55                   	push   %ebp
  8027cb:	89 e5                	mov    %esp,%ebp
  8027cd:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  8027d0:	a1 40 50 80 00       	mov    0x805040,%eax
  8027d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  8027d8:	a1 44 50 80 00       	mov    0x805044,%eax
  8027dd:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8027e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027e3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8027e6:	74 24                	je     80280c <insert_sorted_allocList+0x42>
  8027e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8027eb:	8b 50 08             	mov    0x8(%eax),%edx
  8027ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027f1:	8b 40 08             	mov    0x8(%eax),%eax
  8027f4:	39 c2                	cmp    %eax,%edx
  8027f6:	76 14                	jbe    80280c <insert_sorted_allocList+0x42>
  8027f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8027fb:	8b 50 08             	mov    0x8(%eax),%edx
  8027fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802801:	8b 40 08             	mov    0x8(%eax),%eax
  802804:	39 c2                	cmp    %eax,%edx
  802806:	0f 82 60 01 00 00    	jb     80296c <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  80280c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802810:	75 65                	jne    802877 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802812:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802816:	75 14                	jne    80282c <insert_sorted_allocList+0x62>
  802818:	83 ec 04             	sub    $0x4,%esp
  80281b:	68 ac 47 80 00       	push   $0x8047ac
  802820:	6a 6b                	push   $0x6b
  802822:	68 cf 47 80 00       	push   $0x8047cf
  802827:	e8 71 e0 ff ff       	call   80089d <_panic>
  80282c:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802832:	8b 45 08             	mov    0x8(%ebp),%eax
  802835:	89 10                	mov    %edx,(%eax)
  802837:	8b 45 08             	mov    0x8(%ebp),%eax
  80283a:	8b 00                	mov    (%eax),%eax
  80283c:	85 c0                	test   %eax,%eax
  80283e:	74 0d                	je     80284d <insert_sorted_allocList+0x83>
  802840:	a1 40 50 80 00       	mov    0x805040,%eax
  802845:	8b 55 08             	mov    0x8(%ebp),%edx
  802848:	89 50 04             	mov    %edx,0x4(%eax)
  80284b:	eb 08                	jmp    802855 <insert_sorted_allocList+0x8b>
  80284d:	8b 45 08             	mov    0x8(%ebp),%eax
  802850:	a3 44 50 80 00       	mov    %eax,0x805044
  802855:	8b 45 08             	mov    0x8(%ebp),%eax
  802858:	a3 40 50 80 00       	mov    %eax,0x805040
  80285d:	8b 45 08             	mov    0x8(%ebp),%eax
  802860:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802867:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80286c:	40                   	inc    %eax
  80286d:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802872:	e9 dc 01 00 00       	jmp    802a53 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802877:	8b 45 08             	mov    0x8(%ebp),%eax
  80287a:	8b 50 08             	mov    0x8(%eax),%edx
  80287d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802880:	8b 40 08             	mov    0x8(%eax),%eax
  802883:	39 c2                	cmp    %eax,%edx
  802885:	77 6c                	ja     8028f3 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802887:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80288b:	74 06                	je     802893 <insert_sorted_allocList+0xc9>
  80288d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802891:	75 14                	jne    8028a7 <insert_sorted_allocList+0xdd>
  802893:	83 ec 04             	sub    $0x4,%esp
  802896:	68 e8 47 80 00       	push   $0x8047e8
  80289b:	6a 6f                	push   $0x6f
  80289d:	68 cf 47 80 00       	push   $0x8047cf
  8028a2:	e8 f6 df ff ff       	call   80089d <_panic>
  8028a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028aa:	8b 50 04             	mov    0x4(%eax),%edx
  8028ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b0:	89 50 04             	mov    %edx,0x4(%eax)
  8028b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028b9:	89 10                	mov    %edx,(%eax)
  8028bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028be:	8b 40 04             	mov    0x4(%eax),%eax
  8028c1:	85 c0                	test   %eax,%eax
  8028c3:	74 0d                	je     8028d2 <insert_sorted_allocList+0x108>
  8028c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028c8:	8b 40 04             	mov    0x4(%eax),%eax
  8028cb:	8b 55 08             	mov    0x8(%ebp),%edx
  8028ce:	89 10                	mov    %edx,(%eax)
  8028d0:	eb 08                	jmp    8028da <insert_sorted_allocList+0x110>
  8028d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d5:	a3 40 50 80 00       	mov    %eax,0x805040
  8028da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028dd:	8b 55 08             	mov    0x8(%ebp),%edx
  8028e0:	89 50 04             	mov    %edx,0x4(%eax)
  8028e3:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8028e8:	40                   	inc    %eax
  8028e9:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8028ee:	e9 60 01 00 00       	jmp    802a53 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8028f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f6:	8b 50 08             	mov    0x8(%eax),%edx
  8028f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028fc:	8b 40 08             	mov    0x8(%eax),%eax
  8028ff:	39 c2                	cmp    %eax,%edx
  802901:	0f 82 4c 01 00 00    	jb     802a53 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802907:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80290b:	75 14                	jne    802921 <insert_sorted_allocList+0x157>
  80290d:	83 ec 04             	sub    $0x4,%esp
  802910:	68 20 48 80 00       	push   $0x804820
  802915:	6a 73                	push   $0x73
  802917:	68 cf 47 80 00       	push   $0x8047cf
  80291c:	e8 7c df ff ff       	call   80089d <_panic>
  802921:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802927:	8b 45 08             	mov    0x8(%ebp),%eax
  80292a:	89 50 04             	mov    %edx,0x4(%eax)
  80292d:	8b 45 08             	mov    0x8(%ebp),%eax
  802930:	8b 40 04             	mov    0x4(%eax),%eax
  802933:	85 c0                	test   %eax,%eax
  802935:	74 0c                	je     802943 <insert_sorted_allocList+0x179>
  802937:	a1 44 50 80 00       	mov    0x805044,%eax
  80293c:	8b 55 08             	mov    0x8(%ebp),%edx
  80293f:	89 10                	mov    %edx,(%eax)
  802941:	eb 08                	jmp    80294b <insert_sorted_allocList+0x181>
  802943:	8b 45 08             	mov    0x8(%ebp),%eax
  802946:	a3 40 50 80 00       	mov    %eax,0x805040
  80294b:	8b 45 08             	mov    0x8(%ebp),%eax
  80294e:	a3 44 50 80 00       	mov    %eax,0x805044
  802953:	8b 45 08             	mov    0x8(%ebp),%eax
  802956:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80295c:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802961:	40                   	inc    %eax
  802962:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802967:	e9 e7 00 00 00       	jmp    802a53 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  80296c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80296f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802972:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802979:	a1 40 50 80 00       	mov    0x805040,%eax
  80297e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802981:	e9 9d 00 00 00       	jmp    802a23 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802986:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802989:	8b 00                	mov    (%eax),%eax
  80298b:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  80298e:	8b 45 08             	mov    0x8(%ebp),%eax
  802991:	8b 50 08             	mov    0x8(%eax),%edx
  802994:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802997:	8b 40 08             	mov    0x8(%eax),%eax
  80299a:	39 c2                	cmp    %eax,%edx
  80299c:	76 7d                	jbe    802a1b <insert_sorted_allocList+0x251>
  80299e:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a1:	8b 50 08             	mov    0x8(%eax),%edx
  8029a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029a7:	8b 40 08             	mov    0x8(%eax),%eax
  8029aa:	39 c2                	cmp    %eax,%edx
  8029ac:	73 6d                	jae    802a1b <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8029ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029b2:	74 06                	je     8029ba <insert_sorted_allocList+0x1f0>
  8029b4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029b8:	75 14                	jne    8029ce <insert_sorted_allocList+0x204>
  8029ba:	83 ec 04             	sub    $0x4,%esp
  8029bd:	68 44 48 80 00       	push   $0x804844
  8029c2:	6a 7f                	push   $0x7f
  8029c4:	68 cf 47 80 00       	push   $0x8047cf
  8029c9:	e8 cf de ff ff       	call   80089d <_panic>
  8029ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d1:	8b 10                	mov    (%eax),%edx
  8029d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d6:	89 10                	mov    %edx,(%eax)
  8029d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029db:	8b 00                	mov    (%eax),%eax
  8029dd:	85 c0                	test   %eax,%eax
  8029df:	74 0b                	je     8029ec <insert_sorted_allocList+0x222>
  8029e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e4:	8b 00                	mov    (%eax),%eax
  8029e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8029e9:	89 50 04             	mov    %edx,0x4(%eax)
  8029ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8029f2:	89 10                	mov    %edx,(%eax)
  8029f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029fa:	89 50 04             	mov    %edx,0x4(%eax)
  8029fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802a00:	8b 00                	mov    (%eax),%eax
  802a02:	85 c0                	test   %eax,%eax
  802a04:	75 08                	jne    802a0e <insert_sorted_allocList+0x244>
  802a06:	8b 45 08             	mov    0x8(%ebp),%eax
  802a09:	a3 44 50 80 00       	mov    %eax,0x805044
  802a0e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802a13:	40                   	inc    %eax
  802a14:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802a19:	eb 39                	jmp    802a54 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802a1b:	a1 48 50 80 00       	mov    0x805048,%eax
  802a20:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a23:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a27:	74 07                	je     802a30 <insert_sorted_allocList+0x266>
  802a29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2c:	8b 00                	mov    (%eax),%eax
  802a2e:	eb 05                	jmp    802a35 <insert_sorted_allocList+0x26b>
  802a30:	b8 00 00 00 00       	mov    $0x0,%eax
  802a35:	a3 48 50 80 00       	mov    %eax,0x805048
  802a3a:	a1 48 50 80 00       	mov    0x805048,%eax
  802a3f:	85 c0                	test   %eax,%eax
  802a41:	0f 85 3f ff ff ff    	jne    802986 <insert_sorted_allocList+0x1bc>
  802a47:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a4b:	0f 85 35 ff ff ff    	jne    802986 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802a51:	eb 01                	jmp    802a54 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802a53:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802a54:	90                   	nop
  802a55:	c9                   	leave  
  802a56:	c3                   	ret    

00802a57 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802a57:	55                   	push   %ebp
  802a58:	89 e5                	mov    %esp,%ebp
  802a5a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802a5d:	a1 38 51 80 00       	mov    0x805138,%eax
  802a62:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a65:	e9 85 01 00 00       	jmp    802bef <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802a6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6d:	8b 40 0c             	mov    0xc(%eax),%eax
  802a70:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a73:	0f 82 6e 01 00 00    	jb     802be7 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802a79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7c:	8b 40 0c             	mov    0xc(%eax),%eax
  802a7f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a82:	0f 85 8a 00 00 00    	jne    802b12 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802a88:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a8c:	75 17                	jne    802aa5 <alloc_block_FF+0x4e>
  802a8e:	83 ec 04             	sub    $0x4,%esp
  802a91:	68 78 48 80 00       	push   $0x804878
  802a96:	68 93 00 00 00       	push   $0x93
  802a9b:	68 cf 47 80 00       	push   $0x8047cf
  802aa0:	e8 f8 dd ff ff       	call   80089d <_panic>
  802aa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa8:	8b 00                	mov    (%eax),%eax
  802aaa:	85 c0                	test   %eax,%eax
  802aac:	74 10                	je     802abe <alloc_block_FF+0x67>
  802aae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab1:	8b 00                	mov    (%eax),%eax
  802ab3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ab6:	8b 52 04             	mov    0x4(%edx),%edx
  802ab9:	89 50 04             	mov    %edx,0x4(%eax)
  802abc:	eb 0b                	jmp    802ac9 <alloc_block_FF+0x72>
  802abe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac1:	8b 40 04             	mov    0x4(%eax),%eax
  802ac4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ac9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acc:	8b 40 04             	mov    0x4(%eax),%eax
  802acf:	85 c0                	test   %eax,%eax
  802ad1:	74 0f                	je     802ae2 <alloc_block_FF+0x8b>
  802ad3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad6:	8b 40 04             	mov    0x4(%eax),%eax
  802ad9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802adc:	8b 12                	mov    (%edx),%edx
  802ade:	89 10                	mov    %edx,(%eax)
  802ae0:	eb 0a                	jmp    802aec <alloc_block_FF+0x95>
  802ae2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae5:	8b 00                	mov    (%eax),%eax
  802ae7:	a3 38 51 80 00       	mov    %eax,0x805138
  802aec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802af5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802aff:	a1 44 51 80 00       	mov    0x805144,%eax
  802b04:	48                   	dec    %eax
  802b05:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802b0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0d:	e9 10 01 00 00       	jmp    802c22 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802b12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b15:	8b 40 0c             	mov    0xc(%eax),%eax
  802b18:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b1b:	0f 86 c6 00 00 00    	jbe    802be7 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b21:	a1 48 51 80 00       	mov    0x805148,%eax
  802b26:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802b29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2c:	8b 50 08             	mov    0x8(%eax),%edx
  802b2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b32:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802b35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b38:	8b 55 08             	mov    0x8(%ebp),%edx
  802b3b:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802b3e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b42:	75 17                	jne    802b5b <alloc_block_FF+0x104>
  802b44:	83 ec 04             	sub    $0x4,%esp
  802b47:	68 78 48 80 00       	push   $0x804878
  802b4c:	68 9b 00 00 00       	push   $0x9b
  802b51:	68 cf 47 80 00       	push   $0x8047cf
  802b56:	e8 42 dd ff ff       	call   80089d <_panic>
  802b5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b5e:	8b 00                	mov    (%eax),%eax
  802b60:	85 c0                	test   %eax,%eax
  802b62:	74 10                	je     802b74 <alloc_block_FF+0x11d>
  802b64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b67:	8b 00                	mov    (%eax),%eax
  802b69:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b6c:	8b 52 04             	mov    0x4(%edx),%edx
  802b6f:	89 50 04             	mov    %edx,0x4(%eax)
  802b72:	eb 0b                	jmp    802b7f <alloc_block_FF+0x128>
  802b74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b77:	8b 40 04             	mov    0x4(%eax),%eax
  802b7a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b82:	8b 40 04             	mov    0x4(%eax),%eax
  802b85:	85 c0                	test   %eax,%eax
  802b87:	74 0f                	je     802b98 <alloc_block_FF+0x141>
  802b89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b8c:	8b 40 04             	mov    0x4(%eax),%eax
  802b8f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b92:	8b 12                	mov    (%edx),%edx
  802b94:	89 10                	mov    %edx,(%eax)
  802b96:	eb 0a                	jmp    802ba2 <alloc_block_FF+0x14b>
  802b98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b9b:	8b 00                	mov    (%eax),%eax
  802b9d:	a3 48 51 80 00       	mov    %eax,0x805148
  802ba2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bb5:	a1 54 51 80 00       	mov    0x805154,%eax
  802bba:	48                   	dec    %eax
  802bbb:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802bc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc3:	8b 50 08             	mov    0x8(%eax),%edx
  802bc6:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc9:	01 c2                	add    %eax,%edx
  802bcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bce:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802bd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd4:	8b 40 0c             	mov    0xc(%eax),%eax
  802bd7:	2b 45 08             	sub    0x8(%ebp),%eax
  802bda:	89 c2                	mov    %eax,%edx
  802bdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bdf:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802be2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802be5:	eb 3b                	jmp    802c22 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802be7:	a1 40 51 80 00       	mov    0x805140,%eax
  802bec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bf3:	74 07                	je     802bfc <alloc_block_FF+0x1a5>
  802bf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf8:	8b 00                	mov    (%eax),%eax
  802bfa:	eb 05                	jmp    802c01 <alloc_block_FF+0x1aa>
  802bfc:	b8 00 00 00 00       	mov    $0x0,%eax
  802c01:	a3 40 51 80 00       	mov    %eax,0x805140
  802c06:	a1 40 51 80 00       	mov    0x805140,%eax
  802c0b:	85 c0                	test   %eax,%eax
  802c0d:	0f 85 57 fe ff ff    	jne    802a6a <alloc_block_FF+0x13>
  802c13:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c17:	0f 85 4d fe ff ff    	jne    802a6a <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802c1d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c22:	c9                   	leave  
  802c23:	c3                   	ret    

00802c24 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802c24:	55                   	push   %ebp
  802c25:	89 e5                	mov    %esp,%ebp
  802c27:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802c2a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802c31:	a1 38 51 80 00       	mov    0x805138,%eax
  802c36:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c39:	e9 df 00 00 00       	jmp    802d1d <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802c3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c41:	8b 40 0c             	mov    0xc(%eax),%eax
  802c44:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c47:	0f 82 c8 00 00 00    	jb     802d15 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802c4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c50:	8b 40 0c             	mov    0xc(%eax),%eax
  802c53:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c56:	0f 85 8a 00 00 00    	jne    802ce6 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802c5c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c60:	75 17                	jne    802c79 <alloc_block_BF+0x55>
  802c62:	83 ec 04             	sub    $0x4,%esp
  802c65:	68 78 48 80 00       	push   $0x804878
  802c6a:	68 b7 00 00 00       	push   $0xb7
  802c6f:	68 cf 47 80 00       	push   $0x8047cf
  802c74:	e8 24 dc ff ff       	call   80089d <_panic>
  802c79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7c:	8b 00                	mov    (%eax),%eax
  802c7e:	85 c0                	test   %eax,%eax
  802c80:	74 10                	je     802c92 <alloc_block_BF+0x6e>
  802c82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c85:	8b 00                	mov    (%eax),%eax
  802c87:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c8a:	8b 52 04             	mov    0x4(%edx),%edx
  802c8d:	89 50 04             	mov    %edx,0x4(%eax)
  802c90:	eb 0b                	jmp    802c9d <alloc_block_BF+0x79>
  802c92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c95:	8b 40 04             	mov    0x4(%eax),%eax
  802c98:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca0:	8b 40 04             	mov    0x4(%eax),%eax
  802ca3:	85 c0                	test   %eax,%eax
  802ca5:	74 0f                	je     802cb6 <alloc_block_BF+0x92>
  802ca7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802caa:	8b 40 04             	mov    0x4(%eax),%eax
  802cad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cb0:	8b 12                	mov    (%edx),%edx
  802cb2:	89 10                	mov    %edx,(%eax)
  802cb4:	eb 0a                	jmp    802cc0 <alloc_block_BF+0x9c>
  802cb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb9:	8b 00                	mov    (%eax),%eax
  802cbb:	a3 38 51 80 00       	mov    %eax,0x805138
  802cc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ccc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cd3:	a1 44 51 80 00       	mov    0x805144,%eax
  802cd8:	48                   	dec    %eax
  802cd9:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802cde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce1:	e9 4d 01 00 00       	jmp    802e33 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802ce6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce9:	8b 40 0c             	mov    0xc(%eax),%eax
  802cec:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cef:	76 24                	jbe    802d15 <alloc_block_BF+0xf1>
  802cf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf4:	8b 40 0c             	mov    0xc(%eax),%eax
  802cf7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802cfa:	73 19                	jae    802d15 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802cfc:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802d03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d06:	8b 40 0c             	mov    0xc(%eax),%eax
  802d09:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802d0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0f:	8b 40 08             	mov    0x8(%eax),%eax
  802d12:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802d15:	a1 40 51 80 00       	mov    0x805140,%eax
  802d1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d1d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d21:	74 07                	je     802d2a <alloc_block_BF+0x106>
  802d23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d26:	8b 00                	mov    (%eax),%eax
  802d28:	eb 05                	jmp    802d2f <alloc_block_BF+0x10b>
  802d2a:	b8 00 00 00 00       	mov    $0x0,%eax
  802d2f:	a3 40 51 80 00       	mov    %eax,0x805140
  802d34:	a1 40 51 80 00       	mov    0x805140,%eax
  802d39:	85 c0                	test   %eax,%eax
  802d3b:	0f 85 fd fe ff ff    	jne    802c3e <alloc_block_BF+0x1a>
  802d41:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d45:	0f 85 f3 fe ff ff    	jne    802c3e <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802d4b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802d4f:	0f 84 d9 00 00 00    	je     802e2e <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802d55:	a1 48 51 80 00       	mov    0x805148,%eax
  802d5a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802d5d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d60:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d63:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802d66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d69:	8b 55 08             	mov    0x8(%ebp),%edx
  802d6c:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802d6f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802d73:	75 17                	jne    802d8c <alloc_block_BF+0x168>
  802d75:	83 ec 04             	sub    $0x4,%esp
  802d78:	68 78 48 80 00       	push   $0x804878
  802d7d:	68 c7 00 00 00       	push   $0xc7
  802d82:	68 cf 47 80 00       	push   $0x8047cf
  802d87:	e8 11 db ff ff       	call   80089d <_panic>
  802d8c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d8f:	8b 00                	mov    (%eax),%eax
  802d91:	85 c0                	test   %eax,%eax
  802d93:	74 10                	je     802da5 <alloc_block_BF+0x181>
  802d95:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d98:	8b 00                	mov    (%eax),%eax
  802d9a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d9d:	8b 52 04             	mov    0x4(%edx),%edx
  802da0:	89 50 04             	mov    %edx,0x4(%eax)
  802da3:	eb 0b                	jmp    802db0 <alloc_block_BF+0x18c>
  802da5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802da8:	8b 40 04             	mov    0x4(%eax),%eax
  802dab:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802db0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802db3:	8b 40 04             	mov    0x4(%eax),%eax
  802db6:	85 c0                	test   %eax,%eax
  802db8:	74 0f                	je     802dc9 <alloc_block_BF+0x1a5>
  802dba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dbd:	8b 40 04             	mov    0x4(%eax),%eax
  802dc0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802dc3:	8b 12                	mov    (%edx),%edx
  802dc5:	89 10                	mov    %edx,(%eax)
  802dc7:	eb 0a                	jmp    802dd3 <alloc_block_BF+0x1af>
  802dc9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dcc:	8b 00                	mov    (%eax),%eax
  802dce:	a3 48 51 80 00       	mov    %eax,0x805148
  802dd3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dd6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ddc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ddf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802de6:	a1 54 51 80 00       	mov    0x805154,%eax
  802deb:	48                   	dec    %eax
  802dec:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802df1:	83 ec 08             	sub    $0x8,%esp
  802df4:	ff 75 ec             	pushl  -0x14(%ebp)
  802df7:	68 38 51 80 00       	push   $0x805138
  802dfc:	e8 71 f9 ff ff       	call   802772 <find_block>
  802e01:	83 c4 10             	add    $0x10,%esp
  802e04:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802e07:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e0a:	8b 50 08             	mov    0x8(%eax),%edx
  802e0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e10:	01 c2                	add    %eax,%edx
  802e12:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e15:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802e18:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e1b:	8b 40 0c             	mov    0xc(%eax),%eax
  802e1e:	2b 45 08             	sub    0x8(%ebp),%eax
  802e21:	89 c2                	mov    %eax,%edx
  802e23:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e26:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802e29:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e2c:	eb 05                	jmp    802e33 <alloc_block_BF+0x20f>
	}
	return NULL;
  802e2e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e33:	c9                   	leave  
  802e34:	c3                   	ret    

00802e35 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802e35:	55                   	push   %ebp
  802e36:	89 e5                	mov    %esp,%ebp
  802e38:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802e3b:	a1 28 50 80 00       	mov    0x805028,%eax
  802e40:	85 c0                	test   %eax,%eax
  802e42:	0f 85 de 01 00 00    	jne    803026 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802e48:	a1 38 51 80 00       	mov    0x805138,%eax
  802e4d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e50:	e9 9e 01 00 00       	jmp    802ff3 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802e55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e58:	8b 40 0c             	mov    0xc(%eax),%eax
  802e5b:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e5e:	0f 82 87 01 00 00    	jb     802feb <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802e64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e67:	8b 40 0c             	mov    0xc(%eax),%eax
  802e6a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e6d:	0f 85 95 00 00 00    	jne    802f08 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802e73:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e77:	75 17                	jne    802e90 <alloc_block_NF+0x5b>
  802e79:	83 ec 04             	sub    $0x4,%esp
  802e7c:	68 78 48 80 00       	push   $0x804878
  802e81:	68 e0 00 00 00       	push   $0xe0
  802e86:	68 cf 47 80 00       	push   $0x8047cf
  802e8b:	e8 0d da ff ff       	call   80089d <_panic>
  802e90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e93:	8b 00                	mov    (%eax),%eax
  802e95:	85 c0                	test   %eax,%eax
  802e97:	74 10                	je     802ea9 <alloc_block_NF+0x74>
  802e99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9c:	8b 00                	mov    (%eax),%eax
  802e9e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ea1:	8b 52 04             	mov    0x4(%edx),%edx
  802ea4:	89 50 04             	mov    %edx,0x4(%eax)
  802ea7:	eb 0b                	jmp    802eb4 <alloc_block_NF+0x7f>
  802ea9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eac:	8b 40 04             	mov    0x4(%eax),%eax
  802eaf:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802eb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb7:	8b 40 04             	mov    0x4(%eax),%eax
  802eba:	85 c0                	test   %eax,%eax
  802ebc:	74 0f                	je     802ecd <alloc_block_NF+0x98>
  802ebe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec1:	8b 40 04             	mov    0x4(%eax),%eax
  802ec4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ec7:	8b 12                	mov    (%edx),%edx
  802ec9:	89 10                	mov    %edx,(%eax)
  802ecb:	eb 0a                	jmp    802ed7 <alloc_block_NF+0xa2>
  802ecd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed0:	8b 00                	mov    (%eax),%eax
  802ed2:	a3 38 51 80 00       	mov    %eax,0x805138
  802ed7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eda:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ee0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eea:	a1 44 51 80 00       	mov    0x805144,%eax
  802eef:	48                   	dec    %eax
  802ef0:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802ef5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef8:	8b 40 08             	mov    0x8(%eax),%eax
  802efb:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802f00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f03:	e9 f8 04 00 00       	jmp    803400 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802f08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0b:	8b 40 0c             	mov    0xc(%eax),%eax
  802f0e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f11:	0f 86 d4 00 00 00    	jbe    802feb <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802f17:	a1 48 51 80 00       	mov    0x805148,%eax
  802f1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802f1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f22:	8b 50 08             	mov    0x8(%eax),%edx
  802f25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f28:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802f2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f2e:	8b 55 08             	mov    0x8(%ebp),%edx
  802f31:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802f34:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f38:	75 17                	jne    802f51 <alloc_block_NF+0x11c>
  802f3a:	83 ec 04             	sub    $0x4,%esp
  802f3d:	68 78 48 80 00       	push   $0x804878
  802f42:	68 e9 00 00 00       	push   $0xe9
  802f47:	68 cf 47 80 00       	push   $0x8047cf
  802f4c:	e8 4c d9 ff ff       	call   80089d <_panic>
  802f51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f54:	8b 00                	mov    (%eax),%eax
  802f56:	85 c0                	test   %eax,%eax
  802f58:	74 10                	je     802f6a <alloc_block_NF+0x135>
  802f5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f5d:	8b 00                	mov    (%eax),%eax
  802f5f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f62:	8b 52 04             	mov    0x4(%edx),%edx
  802f65:	89 50 04             	mov    %edx,0x4(%eax)
  802f68:	eb 0b                	jmp    802f75 <alloc_block_NF+0x140>
  802f6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f6d:	8b 40 04             	mov    0x4(%eax),%eax
  802f70:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f75:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f78:	8b 40 04             	mov    0x4(%eax),%eax
  802f7b:	85 c0                	test   %eax,%eax
  802f7d:	74 0f                	je     802f8e <alloc_block_NF+0x159>
  802f7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f82:	8b 40 04             	mov    0x4(%eax),%eax
  802f85:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f88:	8b 12                	mov    (%edx),%edx
  802f8a:	89 10                	mov    %edx,(%eax)
  802f8c:	eb 0a                	jmp    802f98 <alloc_block_NF+0x163>
  802f8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f91:	8b 00                	mov    (%eax),%eax
  802f93:	a3 48 51 80 00       	mov    %eax,0x805148
  802f98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f9b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fa1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fa4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fab:	a1 54 51 80 00       	mov    0x805154,%eax
  802fb0:	48                   	dec    %eax
  802fb1:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802fb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fb9:	8b 40 08             	mov    0x8(%eax),%eax
  802fbc:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802fc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc4:	8b 50 08             	mov    0x8(%eax),%edx
  802fc7:	8b 45 08             	mov    0x8(%ebp),%eax
  802fca:	01 c2                	add    %eax,%edx
  802fcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fcf:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802fd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd5:	8b 40 0c             	mov    0xc(%eax),%eax
  802fd8:	2b 45 08             	sub    0x8(%ebp),%eax
  802fdb:	89 c2                	mov    %eax,%edx
  802fdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe0:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802fe3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fe6:	e9 15 04 00 00       	jmp    803400 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802feb:	a1 40 51 80 00       	mov    0x805140,%eax
  802ff0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ff3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ff7:	74 07                	je     803000 <alloc_block_NF+0x1cb>
  802ff9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ffc:	8b 00                	mov    (%eax),%eax
  802ffe:	eb 05                	jmp    803005 <alloc_block_NF+0x1d0>
  803000:	b8 00 00 00 00       	mov    $0x0,%eax
  803005:	a3 40 51 80 00       	mov    %eax,0x805140
  80300a:	a1 40 51 80 00       	mov    0x805140,%eax
  80300f:	85 c0                	test   %eax,%eax
  803011:	0f 85 3e fe ff ff    	jne    802e55 <alloc_block_NF+0x20>
  803017:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80301b:	0f 85 34 fe ff ff    	jne    802e55 <alloc_block_NF+0x20>
  803021:	e9 d5 03 00 00       	jmp    8033fb <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  803026:	a1 38 51 80 00       	mov    0x805138,%eax
  80302b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80302e:	e9 b1 01 00 00       	jmp    8031e4 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  803033:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803036:	8b 50 08             	mov    0x8(%eax),%edx
  803039:	a1 28 50 80 00       	mov    0x805028,%eax
  80303e:	39 c2                	cmp    %eax,%edx
  803040:	0f 82 96 01 00 00    	jb     8031dc <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  803046:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803049:	8b 40 0c             	mov    0xc(%eax),%eax
  80304c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80304f:	0f 82 87 01 00 00    	jb     8031dc <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  803055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803058:	8b 40 0c             	mov    0xc(%eax),%eax
  80305b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80305e:	0f 85 95 00 00 00    	jne    8030f9 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  803064:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803068:	75 17                	jne    803081 <alloc_block_NF+0x24c>
  80306a:	83 ec 04             	sub    $0x4,%esp
  80306d:	68 78 48 80 00       	push   $0x804878
  803072:	68 fc 00 00 00       	push   $0xfc
  803077:	68 cf 47 80 00       	push   $0x8047cf
  80307c:	e8 1c d8 ff ff       	call   80089d <_panic>
  803081:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803084:	8b 00                	mov    (%eax),%eax
  803086:	85 c0                	test   %eax,%eax
  803088:	74 10                	je     80309a <alloc_block_NF+0x265>
  80308a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80308d:	8b 00                	mov    (%eax),%eax
  80308f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803092:	8b 52 04             	mov    0x4(%edx),%edx
  803095:	89 50 04             	mov    %edx,0x4(%eax)
  803098:	eb 0b                	jmp    8030a5 <alloc_block_NF+0x270>
  80309a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80309d:	8b 40 04             	mov    0x4(%eax),%eax
  8030a0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a8:	8b 40 04             	mov    0x4(%eax),%eax
  8030ab:	85 c0                	test   %eax,%eax
  8030ad:	74 0f                	je     8030be <alloc_block_NF+0x289>
  8030af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b2:	8b 40 04             	mov    0x4(%eax),%eax
  8030b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030b8:	8b 12                	mov    (%edx),%edx
  8030ba:	89 10                	mov    %edx,(%eax)
  8030bc:	eb 0a                	jmp    8030c8 <alloc_block_NF+0x293>
  8030be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c1:	8b 00                	mov    (%eax),%eax
  8030c3:	a3 38 51 80 00       	mov    %eax,0x805138
  8030c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030cb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030db:	a1 44 51 80 00       	mov    0x805144,%eax
  8030e0:	48                   	dec    %eax
  8030e1:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8030e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e9:	8b 40 08             	mov    0x8(%eax),%eax
  8030ec:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  8030f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f4:	e9 07 03 00 00       	jmp    803400 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8030f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030fc:	8b 40 0c             	mov    0xc(%eax),%eax
  8030ff:	3b 45 08             	cmp    0x8(%ebp),%eax
  803102:	0f 86 d4 00 00 00    	jbe    8031dc <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803108:	a1 48 51 80 00       	mov    0x805148,%eax
  80310d:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  803110:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803113:	8b 50 08             	mov    0x8(%eax),%edx
  803116:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803119:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  80311c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80311f:	8b 55 08             	mov    0x8(%ebp),%edx
  803122:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803125:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803129:	75 17                	jne    803142 <alloc_block_NF+0x30d>
  80312b:	83 ec 04             	sub    $0x4,%esp
  80312e:	68 78 48 80 00       	push   $0x804878
  803133:	68 04 01 00 00       	push   $0x104
  803138:	68 cf 47 80 00       	push   $0x8047cf
  80313d:	e8 5b d7 ff ff       	call   80089d <_panic>
  803142:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803145:	8b 00                	mov    (%eax),%eax
  803147:	85 c0                	test   %eax,%eax
  803149:	74 10                	je     80315b <alloc_block_NF+0x326>
  80314b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80314e:	8b 00                	mov    (%eax),%eax
  803150:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803153:	8b 52 04             	mov    0x4(%edx),%edx
  803156:	89 50 04             	mov    %edx,0x4(%eax)
  803159:	eb 0b                	jmp    803166 <alloc_block_NF+0x331>
  80315b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80315e:	8b 40 04             	mov    0x4(%eax),%eax
  803161:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803166:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803169:	8b 40 04             	mov    0x4(%eax),%eax
  80316c:	85 c0                	test   %eax,%eax
  80316e:	74 0f                	je     80317f <alloc_block_NF+0x34a>
  803170:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803173:	8b 40 04             	mov    0x4(%eax),%eax
  803176:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803179:	8b 12                	mov    (%edx),%edx
  80317b:	89 10                	mov    %edx,(%eax)
  80317d:	eb 0a                	jmp    803189 <alloc_block_NF+0x354>
  80317f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803182:	8b 00                	mov    (%eax),%eax
  803184:	a3 48 51 80 00       	mov    %eax,0x805148
  803189:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80318c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803192:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803195:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80319c:	a1 54 51 80 00       	mov    0x805154,%eax
  8031a1:	48                   	dec    %eax
  8031a2:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  8031a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031aa:	8b 40 08             	mov    0x8(%eax),%eax
  8031ad:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  8031b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b5:	8b 50 08             	mov    0x8(%eax),%edx
  8031b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8031bb:	01 c2                	add    %eax,%edx
  8031bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c0:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8031c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c6:	8b 40 0c             	mov    0xc(%eax),%eax
  8031c9:	2b 45 08             	sub    0x8(%ebp),%eax
  8031cc:	89 c2                	mov    %eax,%edx
  8031ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d1:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8031d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d7:	e9 24 02 00 00       	jmp    803400 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8031dc:	a1 40 51 80 00       	mov    0x805140,%eax
  8031e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031e8:	74 07                	je     8031f1 <alloc_block_NF+0x3bc>
  8031ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ed:	8b 00                	mov    (%eax),%eax
  8031ef:	eb 05                	jmp    8031f6 <alloc_block_NF+0x3c1>
  8031f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8031f6:	a3 40 51 80 00       	mov    %eax,0x805140
  8031fb:	a1 40 51 80 00       	mov    0x805140,%eax
  803200:	85 c0                	test   %eax,%eax
  803202:	0f 85 2b fe ff ff    	jne    803033 <alloc_block_NF+0x1fe>
  803208:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80320c:	0f 85 21 fe ff ff    	jne    803033 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803212:	a1 38 51 80 00       	mov    0x805138,%eax
  803217:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80321a:	e9 ae 01 00 00       	jmp    8033cd <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  80321f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803222:	8b 50 08             	mov    0x8(%eax),%edx
  803225:	a1 28 50 80 00       	mov    0x805028,%eax
  80322a:	39 c2                	cmp    %eax,%edx
  80322c:	0f 83 93 01 00 00    	jae    8033c5 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  803232:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803235:	8b 40 0c             	mov    0xc(%eax),%eax
  803238:	3b 45 08             	cmp    0x8(%ebp),%eax
  80323b:	0f 82 84 01 00 00    	jb     8033c5 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  803241:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803244:	8b 40 0c             	mov    0xc(%eax),%eax
  803247:	3b 45 08             	cmp    0x8(%ebp),%eax
  80324a:	0f 85 95 00 00 00    	jne    8032e5 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  803250:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803254:	75 17                	jne    80326d <alloc_block_NF+0x438>
  803256:	83 ec 04             	sub    $0x4,%esp
  803259:	68 78 48 80 00       	push   $0x804878
  80325e:	68 14 01 00 00       	push   $0x114
  803263:	68 cf 47 80 00       	push   $0x8047cf
  803268:	e8 30 d6 ff ff       	call   80089d <_panic>
  80326d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803270:	8b 00                	mov    (%eax),%eax
  803272:	85 c0                	test   %eax,%eax
  803274:	74 10                	je     803286 <alloc_block_NF+0x451>
  803276:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803279:	8b 00                	mov    (%eax),%eax
  80327b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80327e:	8b 52 04             	mov    0x4(%edx),%edx
  803281:	89 50 04             	mov    %edx,0x4(%eax)
  803284:	eb 0b                	jmp    803291 <alloc_block_NF+0x45c>
  803286:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803289:	8b 40 04             	mov    0x4(%eax),%eax
  80328c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803291:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803294:	8b 40 04             	mov    0x4(%eax),%eax
  803297:	85 c0                	test   %eax,%eax
  803299:	74 0f                	je     8032aa <alloc_block_NF+0x475>
  80329b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80329e:	8b 40 04             	mov    0x4(%eax),%eax
  8032a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032a4:	8b 12                	mov    (%edx),%edx
  8032a6:	89 10                	mov    %edx,(%eax)
  8032a8:	eb 0a                	jmp    8032b4 <alloc_block_NF+0x47f>
  8032aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ad:	8b 00                	mov    (%eax),%eax
  8032af:	a3 38 51 80 00       	mov    %eax,0x805138
  8032b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032c7:	a1 44 51 80 00       	mov    0x805144,%eax
  8032cc:	48                   	dec    %eax
  8032cd:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8032d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d5:	8b 40 08             	mov    0x8(%eax),%eax
  8032d8:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  8032dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032e0:	e9 1b 01 00 00       	jmp    803400 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8032e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032e8:	8b 40 0c             	mov    0xc(%eax),%eax
  8032eb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8032ee:	0f 86 d1 00 00 00    	jbe    8033c5 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8032f4:	a1 48 51 80 00       	mov    0x805148,%eax
  8032f9:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  8032fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ff:	8b 50 08             	mov    0x8(%eax),%edx
  803302:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803305:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  803308:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80330b:	8b 55 08             	mov    0x8(%ebp),%edx
  80330e:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803311:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803315:	75 17                	jne    80332e <alloc_block_NF+0x4f9>
  803317:	83 ec 04             	sub    $0x4,%esp
  80331a:	68 78 48 80 00       	push   $0x804878
  80331f:	68 1c 01 00 00       	push   $0x11c
  803324:	68 cf 47 80 00       	push   $0x8047cf
  803329:	e8 6f d5 ff ff       	call   80089d <_panic>
  80332e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803331:	8b 00                	mov    (%eax),%eax
  803333:	85 c0                	test   %eax,%eax
  803335:	74 10                	je     803347 <alloc_block_NF+0x512>
  803337:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80333a:	8b 00                	mov    (%eax),%eax
  80333c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80333f:	8b 52 04             	mov    0x4(%edx),%edx
  803342:	89 50 04             	mov    %edx,0x4(%eax)
  803345:	eb 0b                	jmp    803352 <alloc_block_NF+0x51d>
  803347:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80334a:	8b 40 04             	mov    0x4(%eax),%eax
  80334d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803352:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803355:	8b 40 04             	mov    0x4(%eax),%eax
  803358:	85 c0                	test   %eax,%eax
  80335a:	74 0f                	je     80336b <alloc_block_NF+0x536>
  80335c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80335f:	8b 40 04             	mov    0x4(%eax),%eax
  803362:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803365:	8b 12                	mov    (%edx),%edx
  803367:	89 10                	mov    %edx,(%eax)
  803369:	eb 0a                	jmp    803375 <alloc_block_NF+0x540>
  80336b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80336e:	8b 00                	mov    (%eax),%eax
  803370:	a3 48 51 80 00       	mov    %eax,0x805148
  803375:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803378:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80337e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803381:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803388:	a1 54 51 80 00       	mov    0x805154,%eax
  80338d:	48                   	dec    %eax
  80338e:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  803393:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803396:	8b 40 08             	mov    0x8(%eax),%eax
  803399:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  80339e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a1:	8b 50 08             	mov    0x8(%eax),%edx
  8033a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a7:	01 c2                	add    %eax,%edx
  8033a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ac:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8033af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b2:	8b 40 0c             	mov    0xc(%eax),%eax
  8033b5:	2b 45 08             	sub    0x8(%ebp),%eax
  8033b8:	89 c2                	mov    %eax,%edx
  8033ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033bd:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8033c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033c3:	eb 3b                	jmp    803400 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8033c5:	a1 40 51 80 00       	mov    0x805140,%eax
  8033ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033d1:	74 07                	je     8033da <alloc_block_NF+0x5a5>
  8033d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033d6:	8b 00                	mov    (%eax),%eax
  8033d8:	eb 05                	jmp    8033df <alloc_block_NF+0x5aa>
  8033da:	b8 00 00 00 00       	mov    $0x0,%eax
  8033df:	a3 40 51 80 00       	mov    %eax,0x805140
  8033e4:	a1 40 51 80 00       	mov    0x805140,%eax
  8033e9:	85 c0                	test   %eax,%eax
  8033eb:	0f 85 2e fe ff ff    	jne    80321f <alloc_block_NF+0x3ea>
  8033f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033f5:	0f 85 24 fe ff ff    	jne    80321f <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  8033fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803400:	c9                   	leave  
  803401:	c3                   	ret    

00803402 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803402:	55                   	push   %ebp
  803403:	89 e5                	mov    %esp,%ebp
  803405:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  803408:	a1 38 51 80 00       	mov    0x805138,%eax
  80340d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  803410:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803415:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  803418:	a1 38 51 80 00       	mov    0x805138,%eax
  80341d:	85 c0                	test   %eax,%eax
  80341f:	74 14                	je     803435 <insert_sorted_with_merge_freeList+0x33>
  803421:	8b 45 08             	mov    0x8(%ebp),%eax
  803424:	8b 50 08             	mov    0x8(%eax),%edx
  803427:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80342a:	8b 40 08             	mov    0x8(%eax),%eax
  80342d:	39 c2                	cmp    %eax,%edx
  80342f:	0f 87 9b 01 00 00    	ja     8035d0 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  803435:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803439:	75 17                	jne    803452 <insert_sorted_with_merge_freeList+0x50>
  80343b:	83 ec 04             	sub    $0x4,%esp
  80343e:	68 ac 47 80 00       	push   $0x8047ac
  803443:	68 38 01 00 00       	push   $0x138
  803448:	68 cf 47 80 00       	push   $0x8047cf
  80344d:	e8 4b d4 ff ff       	call   80089d <_panic>
  803452:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803458:	8b 45 08             	mov    0x8(%ebp),%eax
  80345b:	89 10                	mov    %edx,(%eax)
  80345d:	8b 45 08             	mov    0x8(%ebp),%eax
  803460:	8b 00                	mov    (%eax),%eax
  803462:	85 c0                	test   %eax,%eax
  803464:	74 0d                	je     803473 <insert_sorted_with_merge_freeList+0x71>
  803466:	a1 38 51 80 00       	mov    0x805138,%eax
  80346b:	8b 55 08             	mov    0x8(%ebp),%edx
  80346e:	89 50 04             	mov    %edx,0x4(%eax)
  803471:	eb 08                	jmp    80347b <insert_sorted_with_merge_freeList+0x79>
  803473:	8b 45 08             	mov    0x8(%ebp),%eax
  803476:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80347b:	8b 45 08             	mov    0x8(%ebp),%eax
  80347e:	a3 38 51 80 00       	mov    %eax,0x805138
  803483:	8b 45 08             	mov    0x8(%ebp),%eax
  803486:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80348d:	a1 44 51 80 00       	mov    0x805144,%eax
  803492:	40                   	inc    %eax
  803493:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803498:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80349c:	0f 84 a8 06 00 00    	je     803b4a <insert_sorted_with_merge_freeList+0x748>
  8034a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a5:	8b 50 08             	mov    0x8(%eax),%edx
  8034a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ab:	8b 40 0c             	mov    0xc(%eax),%eax
  8034ae:	01 c2                	add    %eax,%edx
  8034b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034b3:	8b 40 08             	mov    0x8(%eax),%eax
  8034b6:	39 c2                	cmp    %eax,%edx
  8034b8:	0f 85 8c 06 00 00    	jne    803b4a <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  8034be:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c1:	8b 50 0c             	mov    0xc(%eax),%edx
  8034c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034c7:	8b 40 0c             	mov    0xc(%eax),%eax
  8034ca:	01 c2                	add    %eax,%edx
  8034cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8034cf:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  8034d2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8034d6:	75 17                	jne    8034ef <insert_sorted_with_merge_freeList+0xed>
  8034d8:	83 ec 04             	sub    $0x4,%esp
  8034db:	68 78 48 80 00       	push   $0x804878
  8034e0:	68 3c 01 00 00       	push   $0x13c
  8034e5:	68 cf 47 80 00       	push   $0x8047cf
  8034ea:	e8 ae d3 ff ff       	call   80089d <_panic>
  8034ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034f2:	8b 00                	mov    (%eax),%eax
  8034f4:	85 c0                	test   %eax,%eax
  8034f6:	74 10                	je     803508 <insert_sorted_with_merge_freeList+0x106>
  8034f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034fb:	8b 00                	mov    (%eax),%eax
  8034fd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803500:	8b 52 04             	mov    0x4(%edx),%edx
  803503:	89 50 04             	mov    %edx,0x4(%eax)
  803506:	eb 0b                	jmp    803513 <insert_sorted_with_merge_freeList+0x111>
  803508:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80350b:	8b 40 04             	mov    0x4(%eax),%eax
  80350e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803513:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803516:	8b 40 04             	mov    0x4(%eax),%eax
  803519:	85 c0                	test   %eax,%eax
  80351b:	74 0f                	je     80352c <insert_sorted_with_merge_freeList+0x12a>
  80351d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803520:	8b 40 04             	mov    0x4(%eax),%eax
  803523:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803526:	8b 12                	mov    (%edx),%edx
  803528:	89 10                	mov    %edx,(%eax)
  80352a:	eb 0a                	jmp    803536 <insert_sorted_with_merge_freeList+0x134>
  80352c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80352f:	8b 00                	mov    (%eax),%eax
  803531:	a3 38 51 80 00       	mov    %eax,0x805138
  803536:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803539:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80353f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803542:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803549:	a1 44 51 80 00       	mov    0x805144,%eax
  80354e:	48                   	dec    %eax
  80354f:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  803554:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803557:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  80355e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803561:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  803568:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80356c:	75 17                	jne    803585 <insert_sorted_with_merge_freeList+0x183>
  80356e:	83 ec 04             	sub    $0x4,%esp
  803571:	68 ac 47 80 00       	push   $0x8047ac
  803576:	68 3f 01 00 00       	push   $0x13f
  80357b:	68 cf 47 80 00       	push   $0x8047cf
  803580:	e8 18 d3 ff ff       	call   80089d <_panic>
  803585:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80358b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80358e:	89 10                	mov    %edx,(%eax)
  803590:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803593:	8b 00                	mov    (%eax),%eax
  803595:	85 c0                	test   %eax,%eax
  803597:	74 0d                	je     8035a6 <insert_sorted_with_merge_freeList+0x1a4>
  803599:	a1 48 51 80 00       	mov    0x805148,%eax
  80359e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035a1:	89 50 04             	mov    %edx,0x4(%eax)
  8035a4:	eb 08                	jmp    8035ae <insert_sorted_with_merge_freeList+0x1ac>
  8035a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035a9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8035ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035b1:	a3 48 51 80 00       	mov    %eax,0x805148
  8035b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035b9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035c0:	a1 54 51 80 00       	mov    0x805154,%eax
  8035c5:	40                   	inc    %eax
  8035c6:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8035cb:	e9 7a 05 00 00       	jmp    803b4a <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  8035d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d3:	8b 50 08             	mov    0x8(%eax),%edx
  8035d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035d9:	8b 40 08             	mov    0x8(%eax),%eax
  8035dc:	39 c2                	cmp    %eax,%edx
  8035de:	0f 82 14 01 00 00    	jb     8036f8 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  8035e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035e7:	8b 50 08             	mov    0x8(%eax),%edx
  8035ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035ed:	8b 40 0c             	mov    0xc(%eax),%eax
  8035f0:	01 c2                	add    %eax,%edx
  8035f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f5:	8b 40 08             	mov    0x8(%eax),%eax
  8035f8:	39 c2                	cmp    %eax,%edx
  8035fa:	0f 85 90 00 00 00    	jne    803690 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  803600:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803603:	8b 50 0c             	mov    0xc(%eax),%edx
  803606:	8b 45 08             	mov    0x8(%ebp),%eax
  803609:	8b 40 0c             	mov    0xc(%eax),%eax
  80360c:	01 c2                	add    %eax,%edx
  80360e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803611:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  803614:	8b 45 08             	mov    0x8(%ebp),%eax
  803617:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  80361e:	8b 45 08             	mov    0x8(%ebp),%eax
  803621:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803628:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80362c:	75 17                	jne    803645 <insert_sorted_with_merge_freeList+0x243>
  80362e:	83 ec 04             	sub    $0x4,%esp
  803631:	68 ac 47 80 00       	push   $0x8047ac
  803636:	68 49 01 00 00       	push   $0x149
  80363b:	68 cf 47 80 00       	push   $0x8047cf
  803640:	e8 58 d2 ff ff       	call   80089d <_panic>
  803645:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80364b:	8b 45 08             	mov    0x8(%ebp),%eax
  80364e:	89 10                	mov    %edx,(%eax)
  803650:	8b 45 08             	mov    0x8(%ebp),%eax
  803653:	8b 00                	mov    (%eax),%eax
  803655:	85 c0                	test   %eax,%eax
  803657:	74 0d                	je     803666 <insert_sorted_with_merge_freeList+0x264>
  803659:	a1 48 51 80 00       	mov    0x805148,%eax
  80365e:	8b 55 08             	mov    0x8(%ebp),%edx
  803661:	89 50 04             	mov    %edx,0x4(%eax)
  803664:	eb 08                	jmp    80366e <insert_sorted_with_merge_freeList+0x26c>
  803666:	8b 45 08             	mov    0x8(%ebp),%eax
  803669:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80366e:	8b 45 08             	mov    0x8(%ebp),%eax
  803671:	a3 48 51 80 00       	mov    %eax,0x805148
  803676:	8b 45 08             	mov    0x8(%ebp),%eax
  803679:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803680:	a1 54 51 80 00       	mov    0x805154,%eax
  803685:	40                   	inc    %eax
  803686:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80368b:	e9 bb 04 00 00       	jmp    803b4b <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803690:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803694:	75 17                	jne    8036ad <insert_sorted_with_merge_freeList+0x2ab>
  803696:	83 ec 04             	sub    $0x4,%esp
  803699:	68 20 48 80 00       	push   $0x804820
  80369e:	68 4c 01 00 00       	push   $0x14c
  8036a3:	68 cf 47 80 00       	push   $0x8047cf
  8036a8:	e8 f0 d1 ff ff       	call   80089d <_panic>
  8036ad:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8036b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b6:	89 50 04             	mov    %edx,0x4(%eax)
  8036b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8036bc:	8b 40 04             	mov    0x4(%eax),%eax
  8036bf:	85 c0                	test   %eax,%eax
  8036c1:	74 0c                	je     8036cf <insert_sorted_with_merge_freeList+0x2cd>
  8036c3:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8036c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8036cb:	89 10                	mov    %edx,(%eax)
  8036cd:	eb 08                	jmp    8036d7 <insert_sorted_with_merge_freeList+0x2d5>
  8036cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d2:	a3 38 51 80 00       	mov    %eax,0x805138
  8036d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8036da:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8036df:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036e8:	a1 44 51 80 00       	mov    0x805144,%eax
  8036ed:	40                   	inc    %eax
  8036ee:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8036f3:	e9 53 04 00 00       	jmp    803b4b <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8036f8:	a1 38 51 80 00       	mov    0x805138,%eax
  8036fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803700:	e9 15 04 00 00       	jmp    803b1a <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  803705:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803708:	8b 00                	mov    (%eax),%eax
  80370a:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  80370d:	8b 45 08             	mov    0x8(%ebp),%eax
  803710:	8b 50 08             	mov    0x8(%eax),%edx
  803713:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803716:	8b 40 08             	mov    0x8(%eax),%eax
  803719:	39 c2                	cmp    %eax,%edx
  80371b:	0f 86 f1 03 00 00    	jbe    803b12 <insert_sorted_with_merge_freeList+0x710>
  803721:	8b 45 08             	mov    0x8(%ebp),%eax
  803724:	8b 50 08             	mov    0x8(%eax),%edx
  803727:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80372a:	8b 40 08             	mov    0x8(%eax),%eax
  80372d:	39 c2                	cmp    %eax,%edx
  80372f:	0f 83 dd 03 00 00    	jae    803b12 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803735:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803738:	8b 50 08             	mov    0x8(%eax),%edx
  80373b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80373e:	8b 40 0c             	mov    0xc(%eax),%eax
  803741:	01 c2                	add    %eax,%edx
  803743:	8b 45 08             	mov    0x8(%ebp),%eax
  803746:	8b 40 08             	mov    0x8(%eax),%eax
  803749:	39 c2                	cmp    %eax,%edx
  80374b:	0f 85 b9 01 00 00    	jne    80390a <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803751:	8b 45 08             	mov    0x8(%ebp),%eax
  803754:	8b 50 08             	mov    0x8(%eax),%edx
  803757:	8b 45 08             	mov    0x8(%ebp),%eax
  80375a:	8b 40 0c             	mov    0xc(%eax),%eax
  80375d:	01 c2                	add    %eax,%edx
  80375f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803762:	8b 40 08             	mov    0x8(%eax),%eax
  803765:	39 c2                	cmp    %eax,%edx
  803767:	0f 85 0d 01 00 00    	jne    80387a <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  80376d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803770:	8b 50 0c             	mov    0xc(%eax),%edx
  803773:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803776:	8b 40 0c             	mov    0xc(%eax),%eax
  803779:	01 c2                	add    %eax,%edx
  80377b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80377e:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803781:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803785:	75 17                	jne    80379e <insert_sorted_with_merge_freeList+0x39c>
  803787:	83 ec 04             	sub    $0x4,%esp
  80378a:	68 78 48 80 00       	push   $0x804878
  80378f:	68 5c 01 00 00       	push   $0x15c
  803794:	68 cf 47 80 00       	push   $0x8047cf
  803799:	e8 ff d0 ff ff       	call   80089d <_panic>
  80379e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037a1:	8b 00                	mov    (%eax),%eax
  8037a3:	85 c0                	test   %eax,%eax
  8037a5:	74 10                	je     8037b7 <insert_sorted_with_merge_freeList+0x3b5>
  8037a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037aa:	8b 00                	mov    (%eax),%eax
  8037ac:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8037af:	8b 52 04             	mov    0x4(%edx),%edx
  8037b2:	89 50 04             	mov    %edx,0x4(%eax)
  8037b5:	eb 0b                	jmp    8037c2 <insert_sorted_with_merge_freeList+0x3c0>
  8037b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037ba:	8b 40 04             	mov    0x4(%eax),%eax
  8037bd:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8037c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037c5:	8b 40 04             	mov    0x4(%eax),%eax
  8037c8:	85 c0                	test   %eax,%eax
  8037ca:	74 0f                	je     8037db <insert_sorted_with_merge_freeList+0x3d9>
  8037cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037cf:	8b 40 04             	mov    0x4(%eax),%eax
  8037d2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8037d5:	8b 12                	mov    (%edx),%edx
  8037d7:	89 10                	mov    %edx,(%eax)
  8037d9:	eb 0a                	jmp    8037e5 <insert_sorted_with_merge_freeList+0x3e3>
  8037db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037de:	8b 00                	mov    (%eax),%eax
  8037e0:	a3 38 51 80 00       	mov    %eax,0x805138
  8037e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037e8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037f1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037f8:	a1 44 51 80 00       	mov    0x805144,%eax
  8037fd:	48                   	dec    %eax
  8037fe:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803803:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803806:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  80380d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803810:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803817:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80381b:	75 17                	jne    803834 <insert_sorted_with_merge_freeList+0x432>
  80381d:	83 ec 04             	sub    $0x4,%esp
  803820:	68 ac 47 80 00       	push   $0x8047ac
  803825:	68 5f 01 00 00       	push   $0x15f
  80382a:	68 cf 47 80 00       	push   $0x8047cf
  80382f:	e8 69 d0 ff ff       	call   80089d <_panic>
  803834:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80383a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80383d:	89 10                	mov    %edx,(%eax)
  80383f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803842:	8b 00                	mov    (%eax),%eax
  803844:	85 c0                	test   %eax,%eax
  803846:	74 0d                	je     803855 <insert_sorted_with_merge_freeList+0x453>
  803848:	a1 48 51 80 00       	mov    0x805148,%eax
  80384d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803850:	89 50 04             	mov    %edx,0x4(%eax)
  803853:	eb 08                	jmp    80385d <insert_sorted_with_merge_freeList+0x45b>
  803855:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803858:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80385d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803860:	a3 48 51 80 00       	mov    %eax,0x805148
  803865:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803868:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80386f:	a1 54 51 80 00       	mov    0x805154,%eax
  803874:	40                   	inc    %eax
  803875:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  80387a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80387d:	8b 50 0c             	mov    0xc(%eax),%edx
  803880:	8b 45 08             	mov    0x8(%ebp),%eax
  803883:	8b 40 0c             	mov    0xc(%eax),%eax
  803886:	01 c2                	add    %eax,%edx
  803888:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80388b:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  80388e:	8b 45 08             	mov    0x8(%ebp),%eax
  803891:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803898:	8b 45 08             	mov    0x8(%ebp),%eax
  80389b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8038a2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8038a6:	75 17                	jne    8038bf <insert_sorted_with_merge_freeList+0x4bd>
  8038a8:	83 ec 04             	sub    $0x4,%esp
  8038ab:	68 ac 47 80 00       	push   $0x8047ac
  8038b0:	68 64 01 00 00       	push   $0x164
  8038b5:	68 cf 47 80 00       	push   $0x8047cf
  8038ba:	e8 de cf ff ff       	call   80089d <_panic>
  8038bf:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8038c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8038c8:	89 10                	mov    %edx,(%eax)
  8038ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8038cd:	8b 00                	mov    (%eax),%eax
  8038cf:	85 c0                	test   %eax,%eax
  8038d1:	74 0d                	je     8038e0 <insert_sorted_with_merge_freeList+0x4de>
  8038d3:	a1 48 51 80 00       	mov    0x805148,%eax
  8038d8:	8b 55 08             	mov    0x8(%ebp),%edx
  8038db:	89 50 04             	mov    %edx,0x4(%eax)
  8038de:	eb 08                	jmp    8038e8 <insert_sorted_with_merge_freeList+0x4e6>
  8038e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8038e3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8038e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8038eb:	a3 48 51 80 00       	mov    %eax,0x805148
  8038f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8038f3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038fa:	a1 54 51 80 00       	mov    0x805154,%eax
  8038ff:	40                   	inc    %eax
  803900:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803905:	e9 41 02 00 00       	jmp    803b4b <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80390a:	8b 45 08             	mov    0x8(%ebp),%eax
  80390d:	8b 50 08             	mov    0x8(%eax),%edx
  803910:	8b 45 08             	mov    0x8(%ebp),%eax
  803913:	8b 40 0c             	mov    0xc(%eax),%eax
  803916:	01 c2                	add    %eax,%edx
  803918:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80391b:	8b 40 08             	mov    0x8(%eax),%eax
  80391e:	39 c2                	cmp    %eax,%edx
  803920:	0f 85 7c 01 00 00    	jne    803aa2 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803926:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80392a:	74 06                	je     803932 <insert_sorted_with_merge_freeList+0x530>
  80392c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803930:	75 17                	jne    803949 <insert_sorted_with_merge_freeList+0x547>
  803932:	83 ec 04             	sub    $0x4,%esp
  803935:	68 e8 47 80 00       	push   $0x8047e8
  80393a:	68 69 01 00 00       	push   $0x169
  80393f:	68 cf 47 80 00       	push   $0x8047cf
  803944:	e8 54 cf ff ff       	call   80089d <_panic>
  803949:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80394c:	8b 50 04             	mov    0x4(%eax),%edx
  80394f:	8b 45 08             	mov    0x8(%ebp),%eax
  803952:	89 50 04             	mov    %edx,0x4(%eax)
  803955:	8b 45 08             	mov    0x8(%ebp),%eax
  803958:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80395b:	89 10                	mov    %edx,(%eax)
  80395d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803960:	8b 40 04             	mov    0x4(%eax),%eax
  803963:	85 c0                	test   %eax,%eax
  803965:	74 0d                	je     803974 <insert_sorted_with_merge_freeList+0x572>
  803967:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80396a:	8b 40 04             	mov    0x4(%eax),%eax
  80396d:	8b 55 08             	mov    0x8(%ebp),%edx
  803970:	89 10                	mov    %edx,(%eax)
  803972:	eb 08                	jmp    80397c <insert_sorted_with_merge_freeList+0x57a>
  803974:	8b 45 08             	mov    0x8(%ebp),%eax
  803977:	a3 38 51 80 00       	mov    %eax,0x805138
  80397c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80397f:	8b 55 08             	mov    0x8(%ebp),%edx
  803982:	89 50 04             	mov    %edx,0x4(%eax)
  803985:	a1 44 51 80 00       	mov    0x805144,%eax
  80398a:	40                   	inc    %eax
  80398b:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803990:	8b 45 08             	mov    0x8(%ebp),%eax
  803993:	8b 50 0c             	mov    0xc(%eax),%edx
  803996:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803999:	8b 40 0c             	mov    0xc(%eax),%eax
  80399c:	01 c2                	add    %eax,%edx
  80399e:	8b 45 08             	mov    0x8(%ebp),%eax
  8039a1:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8039a4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8039a8:	75 17                	jne    8039c1 <insert_sorted_with_merge_freeList+0x5bf>
  8039aa:	83 ec 04             	sub    $0x4,%esp
  8039ad:	68 78 48 80 00       	push   $0x804878
  8039b2:	68 6b 01 00 00       	push   $0x16b
  8039b7:	68 cf 47 80 00       	push   $0x8047cf
  8039bc:	e8 dc ce ff ff       	call   80089d <_panic>
  8039c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039c4:	8b 00                	mov    (%eax),%eax
  8039c6:	85 c0                	test   %eax,%eax
  8039c8:	74 10                	je     8039da <insert_sorted_with_merge_freeList+0x5d8>
  8039ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039cd:	8b 00                	mov    (%eax),%eax
  8039cf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8039d2:	8b 52 04             	mov    0x4(%edx),%edx
  8039d5:	89 50 04             	mov    %edx,0x4(%eax)
  8039d8:	eb 0b                	jmp    8039e5 <insert_sorted_with_merge_freeList+0x5e3>
  8039da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039dd:	8b 40 04             	mov    0x4(%eax),%eax
  8039e0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8039e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039e8:	8b 40 04             	mov    0x4(%eax),%eax
  8039eb:	85 c0                	test   %eax,%eax
  8039ed:	74 0f                	je     8039fe <insert_sorted_with_merge_freeList+0x5fc>
  8039ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039f2:	8b 40 04             	mov    0x4(%eax),%eax
  8039f5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8039f8:	8b 12                	mov    (%edx),%edx
  8039fa:	89 10                	mov    %edx,(%eax)
  8039fc:	eb 0a                	jmp    803a08 <insert_sorted_with_merge_freeList+0x606>
  8039fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a01:	8b 00                	mov    (%eax),%eax
  803a03:	a3 38 51 80 00       	mov    %eax,0x805138
  803a08:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a0b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a11:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a14:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a1b:	a1 44 51 80 00       	mov    0x805144,%eax
  803a20:	48                   	dec    %eax
  803a21:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803a26:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a29:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803a30:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a33:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803a3a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803a3e:	75 17                	jne    803a57 <insert_sorted_with_merge_freeList+0x655>
  803a40:	83 ec 04             	sub    $0x4,%esp
  803a43:	68 ac 47 80 00       	push   $0x8047ac
  803a48:	68 6e 01 00 00       	push   $0x16e
  803a4d:	68 cf 47 80 00       	push   $0x8047cf
  803a52:	e8 46 ce ff ff       	call   80089d <_panic>
  803a57:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803a5d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a60:	89 10                	mov    %edx,(%eax)
  803a62:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a65:	8b 00                	mov    (%eax),%eax
  803a67:	85 c0                	test   %eax,%eax
  803a69:	74 0d                	je     803a78 <insert_sorted_with_merge_freeList+0x676>
  803a6b:	a1 48 51 80 00       	mov    0x805148,%eax
  803a70:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803a73:	89 50 04             	mov    %edx,0x4(%eax)
  803a76:	eb 08                	jmp    803a80 <insert_sorted_with_merge_freeList+0x67e>
  803a78:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a7b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803a80:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a83:	a3 48 51 80 00       	mov    %eax,0x805148
  803a88:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a8b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a92:	a1 54 51 80 00       	mov    0x805154,%eax
  803a97:	40                   	inc    %eax
  803a98:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803a9d:	e9 a9 00 00 00       	jmp    803b4b <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803aa2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803aa6:	74 06                	je     803aae <insert_sorted_with_merge_freeList+0x6ac>
  803aa8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803aac:	75 17                	jne    803ac5 <insert_sorted_with_merge_freeList+0x6c3>
  803aae:	83 ec 04             	sub    $0x4,%esp
  803ab1:	68 44 48 80 00       	push   $0x804844
  803ab6:	68 73 01 00 00       	push   $0x173
  803abb:	68 cf 47 80 00       	push   $0x8047cf
  803ac0:	e8 d8 cd ff ff       	call   80089d <_panic>
  803ac5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ac8:	8b 10                	mov    (%eax),%edx
  803aca:	8b 45 08             	mov    0x8(%ebp),%eax
  803acd:	89 10                	mov    %edx,(%eax)
  803acf:	8b 45 08             	mov    0x8(%ebp),%eax
  803ad2:	8b 00                	mov    (%eax),%eax
  803ad4:	85 c0                	test   %eax,%eax
  803ad6:	74 0b                	je     803ae3 <insert_sorted_with_merge_freeList+0x6e1>
  803ad8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803adb:	8b 00                	mov    (%eax),%eax
  803add:	8b 55 08             	mov    0x8(%ebp),%edx
  803ae0:	89 50 04             	mov    %edx,0x4(%eax)
  803ae3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ae6:	8b 55 08             	mov    0x8(%ebp),%edx
  803ae9:	89 10                	mov    %edx,(%eax)
  803aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  803aee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803af1:	89 50 04             	mov    %edx,0x4(%eax)
  803af4:	8b 45 08             	mov    0x8(%ebp),%eax
  803af7:	8b 00                	mov    (%eax),%eax
  803af9:	85 c0                	test   %eax,%eax
  803afb:	75 08                	jne    803b05 <insert_sorted_with_merge_freeList+0x703>
  803afd:	8b 45 08             	mov    0x8(%ebp),%eax
  803b00:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803b05:	a1 44 51 80 00       	mov    0x805144,%eax
  803b0a:	40                   	inc    %eax
  803b0b:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803b10:	eb 39                	jmp    803b4b <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803b12:	a1 40 51 80 00       	mov    0x805140,%eax
  803b17:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803b1a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b1e:	74 07                	je     803b27 <insert_sorted_with_merge_freeList+0x725>
  803b20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b23:	8b 00                	mov    (%eax),%eax
  803b25:	eb 05                	jmp    803b2c <insert_sorted_with_merge_freeList+0x72a>
  803b27:	b8 00 00 00 00       	mov    $0x0,%eax
  803b2c:	a3 40 51 80 00       	mov    %eax,0x805140
  803b31:	a1 40 51 80 00       	mov    0x805140,%eax
  803b36:	85 c0                	test   %eax,%eax
  803b38:	0f 85 c7 fb ff ff    	jne    803705 <insert_sorted_with_merge_freeList+0x303>
  803b3e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b42:	0f 85 bd fb ff ff    	jne    803705 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803b48:	eb 01                	jmp    803b4b <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803b4a:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803b4b:	90                   	nop
  803b4c:	c9                   	leave  
  803b4d:	c3                   	ret    
  803b4e:	66 90                	xchg   %ax,%ax

00803b50 <__udivdi3>:
  803b50:	55                   	push   %ebp
  803b51:	57                   	push   %edi
  803b52:	56                   	push   %esi
  803b53:	53                   	push   %ebx
  803b54:	83 ec 1c             	sub    $0x1c,%esp
  803b57:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803b5b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803b5f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b63:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803b67:	89 ca                	mov    %ecx,%edx
  803b69:	89 f8                	mov    %edi,%eax
  803b6b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803b6f:	85 f6                	test   %esi,%esi
  803b71:	75 2d                	jne    803ba0 <__udivdi3+0x50>
  803b73:	39 cf                	cmp    %ecx,%edi
  803b75:	77 65                	ja     803bdc <__udivdi3+0x8c>
  803b77:	89 fd                	mov    %edi,%ebp
  803b79:	85 ff                	test   %edi,%edi
  803b7b:	75 0b                	jne    803b88 <__udivdi3+0x38>
  803b7d:	b8 01 00 00 00       	mov    $0x1,%eax
  803b82:	31 d2                	xor    %edx,%edx
  803b84:	f7 f7                	div    %edi
  803b86:	89 c5                	mov    %eax,%ebp
  803b88:	31 d2                	xor    %edx,%edx
  803b8a:	89 c8                	mov    %ecx,%eax
  803b8c:	f7 f5                	div    %ebp
  803b8e:	89 c1                	mov    %eax,%ecx
  803b90:	89 d8                	mov    %ebx,%eax
  803b92:	f7 f5                	div    %ebp
  803b94:	89 cf                	mov    %ecx,%edi
  803b96:	89 fa                	mov    %edi,%edx
  803b98:	83 c4 1c             	add    $0x1c,%esp
  803b9b:	5b                   	pop    %ebx
  803b9c:	5e                   	pop    %esi
  803b9d:	5f                   	pop    %edi
  803b9e:	5d                   	pop    %ebp
  803b9f:	c3                   	ret    
  803ba0:	39 ce                	cmp    %ecx,%esi
  803ba2:	77 28                	ja     803bcc <__udivdi3+0x7c>
  803ba4:	0f bd fe             	bsr    %esi,%edi
  803ba7:	83 f7 1f             	xor    $0x1f,%edi
  803baa:	75 40                	jne    803bec <__udivdi3+0x9c>
  803bac:	39 ce                	cmp    %ecx,%esi
  803bae:	72 0a                	jb     803bba <__udivdi3+0x6a>
  803bb0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803bb4:	0f 87 9e 00 00 00    	ja     803c58 <__udivdi3+0x108>
  803bba:	b8 01 00 00 00       	mov    $0x1,%eax
  803bbf:	89 fa                	mov    %edi,%edx
  803bc1:	83 c4 1c             	add    $0x1c,%esp
  803bc4:	5b                   	pop    %ebx
  803bc5:	5e                   	pop    %esi
  803bc6:	5f                   	pop    %edi
  803bc7:	5d                   	pop    %ebp
  803bc8:	c3                   	ret    
  803bc9:	8d 76 00             	lea    0x0(%esi),%esi
  803bcc:	31 ff                	xor    %edi,%edi
  803bce:	31 c0                	xor    %eax,%eax
  803bd0:	89 fa                	mov    %edi,%edx
  803bd2:	83 c4 1c             	add    $0x1c,%esp
  803bd5:	5b                   	pop    %ebx
  803bd6:	5e                   	pop    %esi
  803bd7:	5f                   	pop    %edi
  803bd8:	5d                   	pop    %ebp
  803bd9:	c3                   	ret    
  803bda:	66 90                	xchg   %ax,%ax
  803bdc:	89 d8                	mov    %ebx,%eax
  803bde:	f7 f7                	div    %edi
  803be0:	31 ff                	xor    %edi,%edi
  803be2:	89 fa                	mov    %edi,%edx
  803be4:	83 c4 1c             	add    $0x1c,%esp
  803be7:	5b                   	pop    %ebx
  803be8:	5e                   	pop    %esi
  803be9:	5f                   	pop    %edi
  803bea:	5d                   	pop    %ebp
  803beb:	c3                   	ret    
  803bec:	bd 20 00 00 00       	mov    $0x20,%ebp
  803bf1:	89 eb                	mov    %ebp,%ebx
  803bf3:	29 fb                	sub    %edi,%ebx
  803bf5:	89 f9                	mov    %edi,%ecx
  803bf7:	d3 e6                	shl    %cl,%esi
  803bf9:	89 c5                	mov    %eax,%ebp
  803bfb:	88 d9                	mov    %bl,%cl
  803bfd:	d3 ed                	shr    %cl,%ebp
  803bff:	89 e9                	mov    %ebp,%ecx
  803c01:	09 f1                	or     %esi,%ecx
  803c03:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803c07:	89 f9                	mov    %edi,%ecx
  803c09:	d3 e0                	shl    %cl,%eax
  803c0b:	89 c5                	mov    %eax,%ebp
  803c0d:	89 d6                	mov    %edx,%esi
  803c0f:	88 d9                	mov    %bl,%cl
  803c11:	d3 ee                	shr    %cl,%esi
  803c13:	89 f9                	mov    %edi,%ecx
  803c15:	d3 e2                	shl    %cl,%edx
  803c17:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c1b:	88 d9                	mov    %bl,%cl
  803c1d:	d3 e8                	shr    %cl,%eax
  803c1f:	09 c2                	or     %eax,%edx
  803c21:	89 d0                	mov    %edx,%eax
  803c23:	89 f2                	mov    %esi,%edx
  803c25:	f7 74 24 0c          	divl   0xc(%esp)
  803c29:	89 d6                	mov    %edx,%esi
  803c2b:	89 c3                	mov    %eax,%ebx
  803c2d:	f7 e5                	mul    %ebp
  803c2f:	39 d6                	cmp    %edx,%esi
  803c31:	72 19                	jb     803c4c <__udivdi3+0xfc>
  803c33:	74 0b                	je     803c40 <__udivdi3+0xf0>
  803c35:	89 d8                	mov    %ebx,%eax
  803c37:	31 ff                	xor    %edi,%edi
  803c39:	e9 58 ff ff ff       	jmp    803b96 <__udivdi3+0x46>
  803c3e:	66 90                	xchg   %ax,%ax
  803c40:	8b 54 24 08          	mov    0x8(%esp),%edx
  803c44:	89 f9                	mov    %edi,%ecx
  803c46:	d3 e2                	shl    %cl,%edx
  803c48:	39 c2                	cmp    %eax,%edx
  803c4a:	73 e9                	jae    803c35 <__udivdi3+0xe5>
  803c4c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803c4f:	31 ff                	xor    %edi,%edi
  803c51:	e9 40 ff ff ff       	jmp    803b96 <__udivdi3+0x46>
  803c56:	66 90                	xchg   %ax,%ax
  803c58:	31 c0                	xor    %eax,%eax
  803c5a:	e9 37 ff ff ff       	jmp    803b96 <__udivdi3+0x46>
  803c5f:	90                   	nop

00803c60 <__umoddi3>:
  803c60:	55                   	push   %ebp
  803c61:	57                   	push   %edi
  803c62:	56                   	push   %esi
  803c63:	53                   	push   %ebx
  803c64:	83 ec 1c             	sub    $0x1c,%esp
  803c67:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803c6b:	8b 74 24 34          	mov    0x34(%esp),%esi
  803c6f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803c73:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803c77:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803c7b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803c7f:	89 f3                	mov    %esi,%ebx
  803c81:	89 fa                	mov    %edi,%edx
  803c83:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c87:	89 34 24             	mov    %esi,(%esp)
  803c8a:	85 c0                	test   %eax,%eax
  803c8c:	75 1a                	jne    803ca8 <__umoddi3+0x48>
  803c8e:	39 f7                	cmp    %esi,%edi
  803c90:	0f 86 a2 00 00 00    	jbe    803d38 <__umoddi3+0xd8>
  803c96:	89 c8                	mov    %ecx,%eax
  803c98:	89 f2                	mov    %esi,%edx
  803c9a:	f7 f7                	div    %edi
  803c9c:	89 d0                	mov    %edx,%eax
  803c9e:	31 d2                	xor    %edx,%edx
  803ca0:	83 c4 1c             	add    $0x1c,%esp
  803ca3:	5b                   	pop    %ebx
  803ca4:	5e                   	pop    %esi
  803ca5:	5f                   	pop    %edi
  803ca6:	5d                   	pop    %ebp
  803ca7:	c3                   	ret    
  803ca8:	39 f0                	cmp    %esi,%eax
  803caa:	0f 87 ac 00 00 00    	ja     803d5c <__umoddi3+0xfc>
  803cb0:	0f bd e8             	bsr    %eax,%ebp
  803cb3:	83 f5 1f             	xor    $0x1f,%ebp
  803cb6:	0f 84 ac 00 00 00    	je     803d68 <__umoddi3+0x108>
  803cbc:	bf 20 00 00 00       	mov    $0x20,%edi
  803cc1:	29 ef                	sub    %ebp,%edi
  803cc3:	89 fe                	mov    %edi,%esi
  803cc5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803cc9:	89 e9                	mov    %ebp,%ecx
  803ccb:	d3 e0                	shl    %cl,%eax
  803ccd:	89 d7                	mov    %edx,%edi
  803ccf:	89 f1                	mov    %esi,%ecx
  803cd1:	d3 ef                	shr    %cl,%edi
  803cd3:	09 c7                	or     %eax,%edi
  803cd5:	89 e9                	mov    %ebp,%ecx
  803cd7:	d3 e2                	shl    %cl,%edx
  803cd9:	89 14 24             	mov    %edx,(%esp)
  803cdc:	89 d8                	mov    %ebx,%eax
  803cde:	d3 e0                	shl    %cl,%eax
  803ce0:	89 c2                	mov    %eax,%edx
  803ce2:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ce6:	d3 e0                	shl    %cl,%eax
  803ce8:	89 44 24 04          	mov    %eax,0x4(%esp)
  803cec:	8b 44 24 08          	mov    0x8(%esp),%eax
  803cf0:	89 f1                	mov    %esi,%ecx
  803cf2:	d3 e8                	shr    %cl,%eax
  803cf4:	09 d0                	or     %edx,%eax
  803cf6:	d3 eb                	shr    %cl,%ebx
  803cf8:	89 da                	mov    %ebx,%edx
  803cfa:	f7 f7                	div    %edi
  803cfc:	89 d3                	mov    %edx,%ebx
  803cfe:	f7 24 24             	mull   (%esp)
  803d01:	89 c6                	mov    %eax,%esi
  803d03:	89 d1                	mov    %edx,%ecx
  803d05:	39 d3                	cmp    %edx,%ebx
  803d07:	0f 82 87 00 00 00    	jb     803d94 <__umoddi3+0x134>
  803d0d:	0f 84 91 00 00 00    	je     803da4 <__umoddi3+0x144>
  803d13:	8b 54 24 04          	mov    0x4(%esp),%edx
  803d17:	29 f2                	sub    %esi,%edx
  803d19:	19 cb                	sbb    %ecx,%ebx
  803d1b:	89 d8                	mov    %ebx,%eax
  803d1d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803d21:	d3 e0                	shl    %cl,%eax
  803d23:	89 e9                	mov    %ebp,%ecx
  803d25:	d3 ea                	shr    %cl,%edx
  803d27:	09 d0                	or     %edx,%eax
  803d29:	89 e9                	mov    %ebp,%ecx
  803d2b:	d3 eb                	shr    %cl,%ebx
  803d2d:	89 da                	mov    %ebx,%edx
  803d2f:	83 c4 1c             	add    $0x1c,%esp
  803d32:	5b                   	pop    %ebx
  803d33:	5e                   	pop    %esi
  803d34:	5f                   	pop    %edi
  803d35:	5d                   	pop    %ebp
  803d36:	c3                   	ret    
  803d37:	90                   	nop
  803d38:	89 fd                	mov    %edi,%ebp
  803d3a:	85 ff                	test   %edi,%edi
  803d3c:	75 0b                	jne    803d49 <__umoddi3+0xe9>
  803d3e:	b8 01 00 00 00       	mov    $0x1,%eax
  803d43:	31 d2                	xor    %edx,%edx
  803d45:	f7 f7                	div    %edi
  803d47:	89 c5                	mov    %eax,%ebp
  803d49:	89 f0                	mov    %esi,%eax
  803d4b:	31 d2                	xor    %edx,%edx
  803d4d:	f7 f5                	div    %ebp
  803d4f:	89 c8                	mov    %ecx,%eax
  803d51:	f7 f5                	div    %ebp
  803d53:	89 d0                	mov    %edx,%eax
  803d55:	e9 44 ff ff ff       	jmp    803c9e <__umoddi3+0x3e>
  803d5a:	66 90                	xchg   %ax,%ax
  803d5c:	89 c8                	mov    %ecx,%eax
  803d5e:	89 f2                	mov    %esi,%edx
  803d60:	83 c4 1c             	add    $0x1c,%esp
  803d63:	5b                   	pop    %ebx
  803d64:	5e                   	pop    %esi
  803d65:	5f                   	pop    %edi
  803d66:	5d                   	pop    %ebp
  803d67:	c3                   	ret    
  803d68:	3b 04 24             	cmp    (%esp),%eax
  803d6b:	72 06                	jb     803d73 <__umoddi3+0x113>
  803d6d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803d71:	77 0f                	ja     803d82 <__umoddi3+0x122>
  803d73:	89 f2                	mov    %esi,%edx
  803d75:	29 f9                	sub    %edi,%ecx
  803d77:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803d7b:	89 14 24             	mov    %edx,(%esp)
  803d7e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d82:	8b 44 24 04          	mov    0x4(%esp),%eax
  803d86:	8b 14 24             	mov    (%esp),%edx
  803d89:	83 c4 1c             	add    $0x1c,%esp
  803d8c:	5b                   	pop    %ebx
  803d8d:	5e                   	pop    %esi
  803d8e:	5f                   	pop    %edi
  803d8f:	5d                   	pop    %ebp
  803d90:	c3                   	ret    
  803d91:	8d 76 00             	lea    0x0(%esi),%esi
  803d94:	2b 04 24             	sub    (%esp),%eax
  803d97:	19 fa                	sbb    %edi,%edx
  803d99:	89 d1                	mov    %edx,%ecx
  803d9b:	89 c6                	mov    %eax,%esi
  803d9d:	e9 71 ff ff ff       	jmp    803d13 <__umoddi3+0xb3>
  803da2:	66 90                	xchg   %ax,%ax
  803da4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803da8:	72 ea                	jb     803d94 <__umoddi3+0x134>
  803daa:	89 d9                	mov    %ebx,%ecx
  803dac:	e9 62 ff ff ff       	jmp    803d13 <__umoddi3+0xb3>
