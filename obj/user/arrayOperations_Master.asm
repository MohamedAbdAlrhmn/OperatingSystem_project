
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
  800041:	e8 0e 20 00 00       	call   802054 <sys_disable_interrupt>
		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 a0 3d 80 00       	push   $0x803da0
  80004e:	e8 fe 0a 00 00       	call   800b51 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 a2 3d 80 00       	push   $0x803da2
  80005e:	e8 ee 0a 00 00       	call   800b51 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!   ARRAY OOERATIONS   !!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 c0 3d 80 00       	push   $0x803dc0
  80006e:	e8 de 0a 00 00       	call   800b51 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 a2 3d 80 00       	push   $0x803da2
  80007e:	e8 ce 0a 00 00       	call   800b51 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 a0 3d 80 00       	push   $0x803da0
  80008e:	e8 be 0a 00 00       	call   800b51 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp

		readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 45 82             	lea    -0x7e(%ebp),%eax
  80009c:	50                   	push   %eax
  80009d:	68 e0 3d 80 00       	push   $0x803de0
  8000a2:	e8 2c 11 00 00       	call   8011d3 <readline>
  8000a7:	83 c4 10             	add    $0x10,%esp

		//Create the shared array & its size
		int *arrSize = smalloc("arrSize", sizeof(int) , 0) ;
  8000aa:	83 ec 04             	sub    $0x4,%esp
  8000ad:	6a 00                	push   $0x0
  8000af:	6a 04                	push   $0x4
  8000b1:	68 ff 3d 80 00       	push   $0x803dff
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
  8000ef:	68 07 3e 80 00       	push   $0x803e07
  8000f4:	e8 2e 1c 00 00       	call   801d27 <smalloc>
  8000f9:	83 c4 10             	add    $0x10,%esp
  8000fc:	89 45 ec             	mov    %eax,-0x14(%ebp)

		cprintf("Chose the initialization method:\n") ;
  8000ff:	83 ec 0c             	sub    $0xc,%esp
  800102:	68 0c 3e 80 00       	push   $0x803e0c
  800107:	e8 45 0a 00 00       	call   800b51 <cprintf>
  80010c:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  80010f:	83 ec 0c             	sub    $0xc,%esp
  800112:	68 2e 3e 80 00       	push   $0x803e2e
  800117:	e8 35 0a 00 00       	call   800b51 <cprintf>
  80011c:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  80011f:	83 ec 0c             	sub    $0xc,%esp
  800122:	68 3c 3e 80 00       	push   $0x803e3c
  800127:	e8 25 0a 00 00       	call   800b51 <cprintf>
  80012c:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  80012f:	83 ec 0c             	sub    $0xc,%esp
  800132:	68 4b 3e 80 00       	push   $0x803e4b
  800137:	e8 15 0a 00 00       	call   800b51 <cprintf>
  80013c:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80013f:	83 ec 0c             	sub    $0xc,%esp
  800142:	68 5b 3e 80 00       	push   $0x803e5b
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
  800186:	e8 e3 1e 00 00       	call   80206e <sys_enable_interrupt>

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
  8001f6:	68 64 3e 80 00       	push   $0x803e64
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
  800232:	68 72 3e 80 00       	push   $0x803e72
  800237:	e8 9d 1f 00 00       	call   8021d9 <sys_create_env>
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
  800265:	68 7b 3e 80 00       	push   $0x803e7b
  80026a:	e8 6a 1f 00 00       	call   8021d9 <sys_create_env>
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
  800298:	68 84 3e 80 00       	push   $0x803e84
  80029d:	e8 37 1f 00 00       	call   8021d9 <sys_create_env>
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
  8002bd:	68 90 3e 80 00       	push   $0x803e90
  8002c2:	6a 4b                	push   $0x4b
  8002c4:	68 a5 3e 80 00       	push   $0x803ea5
  8002c9:	e8 cf 05 00 00       	call   80089d <_panic>

	sys_run_env(envIdQuickSort);
  8002ce:	83 ec 0c             	sub    $0xc,%esp
  8002d1:	ff 75 dc             	pushl  -0x24(%ebp)
  8002d4:	e8 1e 1f 00 00       	call   8021f7 <sys_run_env>
  8002d9:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdMergeSort);
  8002dc:	83 ec 0c             	sub    $0xc,%esp
  8002df:	ff 75 d8             	pushl  -0x28(%ebp)
  8002e2:	e8 10 1f 00 00       	call   8021f7 <sys_run_env>
  8002e7:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdStats);
  8002ea:	83 ec 0c             	sub    $0xc,%esp
  8002ed:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002f0:	e8 02 1f 00 00       	call   8021f7 <sys_run_env>
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
  800337:	68 c3 3e 80 00       	push   $0x803ec3
  80033c:	ff 75 dc             	pushl  -0x24(%ebp)
  80033f:	e8 7f 1a 00 00       	call   801dc3 <sget>
  800344:	83 c4 10             	add    $0x10,%esp
  800347:	89 45 d0             	mov    %eax,-0x30(%ebp)
	mergesortedArr = sget(envIdMergeSort, "mergesortedArr") ;
  80034a:	83 ec 08             	sub    $0x8,%esp
  80034d:	68 d2 3e 80 00       	push   $0x803ed2
  800352:	ff 75 d8             	pushl  -0x28(%ebp)
  800355:	e8 69 1a 00 00       	call   801dc3 <sget>
  80035a:	83 c4 10             	add    $0x10,%esp
  80035d:	89 45 cc             	mov    %eax,-0x34(%ebp)
	mean = sget(envIdStats, "mean") ;
  800360:	83 ec 08             	sub    $0x8,%esp
  800363:	68 e1 3e 80 00       	push   $0x803ee1
  800368:	ff 75 d4             	pushl  -0x2c(%ebp)
  80036b:	e8 53 1a 00 00       	call   801dc3 <sget>
  800370:	83 c4 10             	add    $0x10,%esp
  800373:	89 45 c8             	mov    %eax,-0x38(%ebp)
	var = sget(envIdStats,"var") ;
  800376:	83 ec 08             	sub    $0x8,%esp
  800379:	68 e6 3e 80 00       	push   $0x803ee6
  80037e:	ff 75 d4             	pushl  -0x2c(%ebp)
  800381:	e8 3d 1a 00 00       	call   801dc3 <sget>
  800386:	83 c4 10             	add    $0x10,%esp
  800389:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	min = sget(envIdStats,"min") ;
  80038c:	83 ec 08             	sub    $0x8,%esp
  80038f:	68 ea 3e 80 00       	push   $0x803eea
  800394:	ff 75 d4             	pushl  -0x2c(%ebp)
  800397:	e8 27 1a 00 00       	call   801dc3 <sget>
  80039c:	83 c4 10             	add    $0x10,%esp
  80039f:	89 45 c0             	mov    %eax,-0x40(%ebp)
	max = sget(envIdStats,"max") ;
  8003a2:	83 ec 08             	sub    $0x8,%esp
  8003a5:	68 ee 3e 80 00       	push   $0x803eee
  8003aa:	ff 75 d4             	pushl  -0x2c(%ebp)
  8003ad:	e8 11 1a 00 00       	call   801dc3 <sget>
  8003b2:	83 c4 10             	add    $0x10,%esp
  8003b5:	89 45 bc             	mov    %eax,-0x44(%ebp)
	med = sget(envIdStats,"med") ;
  8003b8:	83 ec 08             	sub    $0x8,%esp
  8003bb:	68 f2 3e 80 00       	push   $0x803ef2
  8003c0:	ff 75 d4             	pushl  -0x2c(%ebp)
  8003c3:	e8 fb 19 00 00       	call   801dc3 <sget>
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
  8003eb:	68 f8 3e 80 00       	push   $0x803ef8
  8003f0:	6a 66                	push   $0x66
  8003f2:	68 a5 3e 80 00       	push   $0x803ea5
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
  800419:	68 20 3f 80 00       	push   $0x803f20
  80041e:	6a 68                	push   $0x68
  800420:	68 a5 3e 80 00       	push   $0x803ea5
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
  8004cc:	68 48 3f 80 00       	push   $0x803f48
  8004d1:	6a 75                	push   $0x75
  8004d3:	68 a5 3e 80 00       	push   $0x803ea5
  8004d8:	e8 c0 03 00 00       	call   80089d <_panic>

	cprintf("Congratulations!! Scenario of Using the Shared Variables [Create & Get] completed successfully!!\n\n\n");
  8004dd:	83 ec 0c             	sub    $0xc,%esp
  8004e0:	68 78 3f 80 00       	push   $0x803f78
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
  8006d5:	e8 ae 19 00 00       	call   802088 <sys_cputc>
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
  8006e6:	e8 69 19 00 00       	call   802054 <sys_disable_interrupt>
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
  8006f9:	e8 8a 19 00 00       	call   802088 <sys_cputc>
  8006fe:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800701:	e8 68 19 00 00       	call   80206e <sys_enable_interrupt>
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
  800718:	e8 b2 17 00 00       	call   801ecf <sys_cgetc>
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
  800731:	e8 1e 19 00 00       	call   802054 <sys_disable_interrupt>
	int c=0;
  800736:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  80073d:	eb 08                	jmp    800747 <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  80073f:	e8 8b 17 00 00       	call   801ecf <sys_cgetc>
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
  80074d:	e8 1c 19 00 00       	call   80206e <sys_enable_interrupt>
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
  800767:	e8 db 1a 00 00       	call   802247 <sys_getenvindex>
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
  8007d2:	e8 7d 18 00 00       	call   802054 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8007d7:	83 ec 0c             	sub    $0xc,%esp
  8007da:	68 f4 3f 80 00       	push   $0x803ff4
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
  800802:	68 1c 40 80 00       	push   $0x80401c
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
  800833:	68 44 40 80 00       	push   $0x804044
  800838:	e8 14 03 00 00       	call   800b51 <cprintf>
  80083d:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800840:	a1 20 50 80 00       	mov    0x805020,%eax
  800845:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80084b:	83 ec 08             	sub    $0x8,%esp
  80084e:	50                   	push   %eax
  80084f:	68 9c 40 80 00       	push   $0x80409c
  800854:	e8 f8 02 00 00       	call   800b51 <cprintf>
  800859:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80085c:	83 ec 0c             	sub    $0xc,%esp
  80085f:	68 f4 3f 80 00       	push   $0x803ff4
  800864:	e8 e8 02 00 00       	call   800b51 <cprintf>
  800869:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80086c:	e8 fd 17 00 00       	call   80206e <sys_enable_interrupt>

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
  800884:	e8 8a 19 00 00       	call   802213 <sys_destroy_env>
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
  800895:	e8 df 19 00 00       	call   802279 <sys_exit_env>
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
  8008be:	68 b0 40 80 00       	push   $0x8040b0
  8008c3:	e8 89 02 00 00       	call   800b51 <cprintf>
  8008c8:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8008cb:	a1 00 50 80 00       	mov    0x805000,%eax
  8008d0:	ff 75 0c             	pushl  0xc(%ebp)
  8008d3:	ff 75 08             	pushl  0x8(%ebp)
  8008d6:	50                   	push   %eax
  8008d7:	68 b5 40 80 00       	push   $0x8040b5
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
  8008fb:	68 d1 40 80 00       	push   $0x8040d1
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
  800927:	68 d4 40 80 00       	push   $0x8040d4
  80092c:	6a 26                	push   $0x26
  80092e:	68 20 41 80 00       	push   $0x804120
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
  8009f9:	68 2c 41 80 00       	push   $0x80412c
  8009fe:	6a 3a                	push   $0x3a
  800a00:	68 20 41 80 00       	push   $0x804120
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
  800a69:	68 80 41 80 00       	push   $0x804180
  800a6e:	6a 44                	push   $0x44
  800a70:	68 20 41 80 00       	push   $0x804120
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
  800ac3:	e8 de 13 00 00       	call   801ea6 <sys_cputs>
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
  800b3a:	e8 67 13 00 00       	call   801ea6 <sys_cputs>
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
  800b84:	e8 cb 14 00 00       	call   802054 <sys_disable_interrupt>
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
  800ba4:	e8 c5 14 00 00       	call   80206e <sys_enable_interrupt>
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
  800bee:	e8 39 2f 00 00       	call   803b2c <__udivdi3>
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
  800c3e:	e8 f9 2f 00 00       	call   803c3c <__umoddi3>
  800c43:	83 c4 10             	add    $0x10,%esp
  800c46:	05 f4 43 80 00       	add    $0x8043f4,%eax
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
  800d99:	8b 04 85 18 44 80 00 	mov    0x804418(,%eax,4),%eax
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
  800e7a:	8b 34 9d 60 42 80 00 	mov    0x804260(,%ebx,4),%esi
  800e81:	85 f6                	test   %esi,%esi
  800e83:	75 19                	jne    800e9e <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800e85:	53                   	push   %ebx
  800e86:	68 05 44 80 00       	push   $0x804405
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
  800e9f:	68 0e 44 80 00       	push   $0x80440e
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
  800ecc:	be 11 44 80 00       	mov    $0x804411,%esi
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
  8011e5:	68 70 45 80 00       	push   $0x804570
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
  801227:	68 73 45 80 00       	push   $0x804573
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
  8012d7:	e8 78 0d 00 00       	call   802054 <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  8012dc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012e0:	74 13                	je     8012f5 <atomic_readline+0x24>
		cprintf("%s", prompt);
  8012e2:	83 ec 08             	sub    $0x8,%esp
  8012e5:	ff 75 08             	pushl  0x8(%ebp)
  8012e8:	68 70 45 80 00       	push   $0x804570
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
  801326:	68 73 45 80 00       	push   $0x804573
  80132b:	e8 21 f8 ff ff       	call   800b51 <cprintf>
  801330:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  801333:	e8 36 0d 00 00       	call   80206e <sys_enable_interrupt>
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
  8013cb:	e8 9e 0c 00 00       	call   80206e <sys_enable_interrupt>
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
  801af8:	68 84 45 80 00       	push   $0x804584
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
  801bc8:	e8 1d 04 00 00       	call   801fea <sys_allocate_chunk>
  801bcd:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801bd0:	a1 20 51 80 00       	mov    0x805120,%eax
  801bd5:	83 ec 0c             	sub    $0xc,%esp
  801bd8:	50                   	push   %eax
  801bd9:	e8 92 0a 00 00       	call   802670 <initialize_MemBlocksList>
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
  801c06:	68 a9 45 80 00       	push   $0x8045a9
  801c0b:	6a 33                	push   $0x33
  801c0d:	68 c7 45 80 00       	push   $0x8045c7
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
  801c85:	68 d4 45 80 00       	push   $0x8045d4
  801c8a:	6a 34                	push   $0x34
  801c8c:	68 c7 45 80 00       	push   $0x8045c7
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
  801cfa:	68 f8 45 80 00       	push   $0x8045f8
  801cff:	6a 46                	push   $0x46
  801d01:	68 c7 45 80 00       	push   $0x8045c7
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
  801d16:	68 20 46 80 00       	push   $0x804620
  801d1b:	6a 61                	push   $0x61
  801d1d:	68 c7 45 80 00       	push   $0x8045c7
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
  801d3c:	75 07                	jne    801d45 <smalloc+0x1e>
  801d3e:	b8 00 00 00 00       	mov    $0x0,%eax
  801d43:	eb 7c                	jmp    801dc1 <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801d45:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801d4c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d52:	01 d0                	add    %edx,%eax
  801d54:	48                   	dec    %eax
  801d55:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801d58:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d5b:	ba 00 00 00 00       	mov    $0x0,%edx
  801d60:	f7 75 f0             	divl   -0x10(%ebp)
  801d63:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d66:	29 d0                	sub    %edx,%eax
  801d68:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801d6b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801d72:	e8 41 06 00 00       	call   8023b8 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801d77:	85 c0                	test   %eax,%eax
  801d79:	74 11                	je     801d8c <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  801d7b:	83 ec 0c             	sub    $0xc,%esp
  801d7e:	ff 75 e8             	pushl  -0x18(%ebp)
  801d81:	e8 ac 0c 00 00       	call   802a32 <alloc_block_FF>
  801d86:	83 c4 10             	add    $0x10,%esp
  801d89:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  801d8c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d90:	74 2a                	je     801dbc <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801d92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d95:	8b 40 08             	mov    0x8(%eax),%eax
  801d98:	89 c2                	mov    %eax,%edx
  801d9a:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801d9e:	52                   	push   %edx
  801d9f:	50                   	push   %eax
  801da0:	ff 75 0c             	pushl  0xc(%ebp)
  801da3:	ff 75 08             	pushl  0x8(%ebp)
  801da6:	e8 92 03 00 00       	call   80213d <sys_createSharedObject>
  801dab:	83 c4 10             	add    $0x10,%esp
  801dae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  801db1:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  801db5:	74 05                	je     801dbc <smalloc+0x95>
			return (void*)virtual_address;
  801db7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801dba:	eb 05                	jmp    801dc1 <smalloc+0x9a>
	}
	return NULL;
  801dbc:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801dc1:	c9                   	leave  
  801dc2:	c3                   	ret    

00801dc3 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801dc3:	55                   	push   %ebp
  801dc4:	89 e5                	mov    %esp,%ebp
  801dc6:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801dc9:	e8 13 fd ff ff       	call   801ae1 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801dce:	83 ec 04             	sub    $0x4,%esp
  801dd1:	68 44 46 80 00       	push   $0x804644
  801dd6:	68 a2 00 00 00       	push   $0xa2
  801ddb:	68 c7 45 80 00       	push   $0x8045c7
  801de0:	e8 b8 ea ff ff       	call   80089d <_panic>

00801de5 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801de5:	55                   	push   %ebp
  801de6:	89 e5                	mov    %esp,%ebp
  801de8:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801deb:	e8 f1 fc ff ff       	call   801ae1 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801df0:	83 ec 04             	sub    $0x4,%esp
  801df3:	68 68 46 80 00       	push   $0x804668
  801df8:	68 e6 00 00 00       	push   $0xe6
  801dfd:	68 c7 45 80 00       	push   $0x8045c7
  801e02:	e8 96 ea ff ff       	call   80089d <_panic>

00801e07 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801e07:	55                   	push   %ebp
  801e08:	89 e5                	mov    %esp,%ebp
  801e0a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801e0d:	83 ec 04             	sub    $0x4,%esp
  801e10:	68 90 46 80 00       	push   $0x804690
  801e15:	68 fa 00 00 00       	push   $0xfa
  801e1a:	68 c7 45 80 00       	push   $0x8045c7
  801e1f:	e8 79 ea ff ff       	call   80089d <_panic>

00801e24 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801e24:	55                   	push   %ebp
  801e25:	89 e5                	mov    %esp,%ebp
  801e27:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e2a:	83 ec 04             	sub    $0x4,%esp
  801e2d:	68 b4 46 80 00       	push   $0x8046b4
  801e32:	68 05 01 00 00       	push   $0x105
  801e37:	68 c7 45 80 00       	push   $0x8045c7
  801e3c:	e8 5c ea ff ff       	call   80089d <_panic>

00801e41 <shrink>:

}
void shrink(uint32 newSize)
{
  801e41:	55                   	push   %ebp
  801e42:	89 e5                	mov    %esp,%ebp
  801e44:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e47:	83 ec 04             	sub    $0x4,%esp
  801e4a:	68 b4 46 80 00       	push   $0x8046b4
  801e4f:	68 0a 01 00 00       	push   $0x10a
  801e54:	68 c7 45 80 00       	push   $0x8045c7
  801e59:	e8 3f ea ff ff       	call   80089d <_panic>

00801e5e <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801e5e:	55                   	push   %ebp
  801e5f:	89 e5                	mov    %esp,%ebp
  801e61:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e64:	83 ec 04             	sub    $0x4,%esp
  801e67:	68 b4 46 80 00       	push   $0x8046b4
  801e6c:	68 0f 01 00 00       	push   $0x10f
  801e71:	68 c7 45 80 00       	push   $0x8045c7
  801e76:	e8 22 ea ff ff       	call   80089d <_panic>

00801e7b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801e7b:	55                   	push   %ebp
  801e7c:	89 e5                	mov    %esp,%ebp
  801e7e:	57                   	push   %edi
  801e7f:	56                   	push   %esi
  801e80:	53                   	push   %ebx
  801e81:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801e84:	8b 45 08             	mov    0x8(%ebp),%eax
  801e87:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e8a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e8d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e90:	8b 7d 18             	mov    0x18(%ebp),%edi
  801e93:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801e96:	cd 30                	int    $0x30
  801e98:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801e9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801e9e:	83 c4 10             	add    $0x10,%esp
  801ea1:	5b                   	pop    %ebx
  801ea2:	5e                   	pop    %esi
  801ea3:	5f                   	pop    %edi
  801ea4:	5d                   	pop    %ebp
  801ea5:	c3                   	ret    

00801ea6 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801ea6:	55                   	push   %ebp
  801ea7:	89 e5                	mov    %esp,%ebp
  801ea9:	83 ec 04             	sub    $0x4,%esp
  801eac:	8b 45 10             	mov    0x10(%ebp),%eax
  801eaf:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801eb2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801eb6:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb9:	6a 00                	push   $0x0
  801ebb:	6a 00                	push   $0x0
  801ebd:	52                   	push   %edx
  801ebe:	ff 75 0c             	pushl  0xc(%ebp)
  801ec1:	50                   	push   %eax
  801ec2:	6a 00                	push   $0x0
  801ec4:	e8 b2 ff ff ff       	call   801e7b <syscall>
  801ec9:	83 c4 18             	add    $0x18,%esp
}
  801ecc:	90                   	nop
  801ecd:	c9                   	leave  
  801ece:	c3                   	ret    

00801ecf <sys_cgetc>:

int
sys_cgetc(void)
{
  801ecf:	55                   	push   %ebp
  801ed0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801ed2:	6a 00                	push   $0x0
  801ed4:	6a 00                	push   $0x0
  801ed6:	6a 00                	push   $0x0
  801ed8:	6a 00                	push   $0x0
  801eda:	6a 00                	push   $0x0
  801edc:	6a 01                	push   $0x1
  801ede:	e8 98 ff ff ff       	call   801e7b <syscall>
  801ee3:	83 c4 18             	add    $0x18,%esp
}
  801ee6:	c9                   	leave  
  801ee7:	c3                   	ret    

00801ee8 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801ee8:	55                   	push   %ebp
  801ee9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801eeb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eee:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef1:	6a 00                	push   $0x0
  801ef3:	6a 00                	push   $0x0
  801ef5:	6a 00                	push   $0x0
  801ef7:	52                   	push   %edx
  801ef8:	50                   	push   %eax
  801ef9:	6a 05                	push   $0x5
  801efb:	e8 7b ff ff ff       	call   801e7b <syscall>
  801f00:	83 c4 18             	add    $0x18,%esp
}
  801f03:	c9                   	leave  
  801f04:	c3                   	ret    

00801f05 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801f05:	55                   	push   %ebp
  801f06:	89 e5                	mov    %esp,%ebp
  801f08:	56                   	push   %esi
  801f09:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801f0a:	8b 75 18             	mov    0x18(%ebp),%esi
  801f0d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f10:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f13:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f16:	8b 45 08             	mov    0x8(%ebp),%eax
  801f19:	56                   	push   %esi
  801f1a:	53                   	push   %ebx
  801f1b:	51                   	push   %ecx
  801f1c:	52                   	push   %edx
  801f1d:	50                   	push   %eax
  801f1e:	6a 06                	push   $0x6
  801f20:	e8 56 ff ff ff       	call   801e7b <syscall>
  801f25:	83 c4 18             	add    $0x18,%esp
}
  801f28:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f2b:	5b                   	pop    %ebx
  801f2c:	5e                   	pop    %esi
  801f2d:	5d                   	pop    %ebp
  801f2e:	c3                   	ret    

00801f2f <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801f2f:	55                   	push   %ebp
  801f30:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801f32:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f35:	8b 45 08             	mov    0x8(%ebp),%eax
  801f38:	6a 00                	push   $0x0
  801f3a:	6a 00                	push   $0x0
  801f3c:	6a 00                	push   $0x0
  801f3e:	52                   	push   %edx
  801f3f:	50                   	push   %eax
  801f40:	6a 07                	push   $0x7
  801f42:	e8 34 ff ff ff       	call   801e7b <syscall>
  801f47:	83 c4 18             	add    $0x18,%esp
}
  801f4a:	c9                   	leave  
  801f4b:	c3                   	ret    

00801f4c <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801f4c:	55                   	push   %ebp
  801f4d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801f4f:	6a 00                	push   $0x0
  801f51:	6a 00                	push   $0x0
  801f53:	6a 00                	push   $0x0
  801f55:	ff 75 0c             	pushl  0xc(%ebp)
  801f58:	ff 75 08             	pushl  0x8(%ebp)
  801f5b:	6a 08                	push   $0x8
  801f5d:	e8 19 ff ff ff       	call   801e7b <syscall>
  801f62:	83 c4 18             	add    $0x18,%esp
}
  801f65:	c9                   	leave  
  801f66:	c3                   	ret    

00801f67 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801f67:	55                   	push   %ebp
  801f68:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801f6a:	6a 00                	push   $0x0
  801f6c:	6a 00                	push   $0x0
  801f6e:	6a 00                	push   $0x0
  801f70:	6a 00                	push   $0x0
  801f72:	6a 00                	push   $0x0
  801f74:	6a 09                	push   $0x9
  801f76:	e8 00 ff ff ff       	call   801e7b <syscall>
  801f7b:	83 c4 18             	add    $0x18,%esp
}
  801f7e:	c9                   	leave  
  801f7f:	c3                   	ret    

00801f80 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801f80:	55                   	push   %ebp
  801f81:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801f83:	6a 00                	push   $0x0
  801f85:	6a 00                	push   $0x0
  801f87:	6a 00                	push   $0x0
  801f89:	6a 00                	push   $0x0
  801f8b:	6a 00                	push   $0x0
  801f8d:	6a 0a                	push   $0xa
  801f8f:	e8 e7 fe ff ff       	call   801e7b <syscall>
  801f94:	83 c4 18             	add    $0x18,%esp
}
  801f97:	c9                   	leave  
  801f98:	c3                   	ret    

00801f99 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801f99:	55                   	push   %ebp
  801f9a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801f9c:	6a 00                	push   $0x0
  801f9e:	6a 00                	push   $0x0
  801fa0:	6a 00                	push   $0x0
  801fa2:	6a 00                	push   $0x0
  801fa4:	6a 00                	push   $0x0
  801fa6:	6a 0b                	push   $0xb
  801fa8:	e8 ce fe ff ff       	call   801e7b <syscall>
  801fad:	83 c4 18             	add    $0x18,%esp
}
  801fb0:	c9                   	leave  
  801fb1:	c3                   	ret    

00801fb2 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801fb2:	55                   	push   %ebp
  801fb3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801fb5:	6a 00                	push   $0x0
  801fb7:	6a 00                	push   $0x0
  801fb9:	6a 00                	push   $0x0
  801fbb:	ff 75 0c             	pushl  0xc(%ebp)
  801fbe:	ff 75 08             	pushl  0x8(%ebp)
  801fc1:	6a 0f                	push   $0xf
  801fc3:	e8 b3 fe ff ff       	call   801e7b <syscall>
  801fc8:	83 c4 18             	add    $0x18,%esp
	return;
  801fcb:	90                   	nop
}
  801fcc:	c9                   	leave  
  801fcd:	c3                   	ret    

00801fce <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801fce:	55                   	push   %ebp
  801fcf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801fd1:	6a 00                	push   $0x0
  801fd3:	6a 00                	push   $0x0
  801fd5:	6a 00                	push   $0x0
  801fd7:	ff 75 0c             	pushl  0xc(%ebp)
  801fda:	ff 75 08             	pushl  0x8(%ebp)
  801fdd:	6a 10                	push   $0x10
  801fdf:	e8 97 fe ff ff       	call   801e7b <syscall>
  801fe4:	83 c4 18             	add    $0x18,%esp
	return ;
  801fe7:	90                   	nop
}
  801fe8:	c9                   	leave  
  801fe9:	c3                   	ret    

00801fea <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801fea:	55                   	push   %ebp
  801feb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801fed:	6a 00                	push   $0x0
  801fef:	6a 00                	push   $0x0
  801ff1:	ff 75 10             	pushl  0x10(%ebp)
  801ff4:	ff 75 0c             	pushl  0xc(%ebp)
  801ff7:	ff 75 08             	pushl  0x8(%ebp)
  801ffa:	6a 11                	push   $0x11
  801ffc:	e8 7a fe ff ff       	call   801e7b <syscall>
  802001:	83 c4 18             	add    $0x18,%esp
	return ;
  802004:	90                   	nop
}
  802005:	c9                   	leave  
  802006:	c3                   	ret    

00802007 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802007:	55                   	push   %ebp
  802008:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80200a:	6a 00                	push   $0x0
  80200c:	6a 00                	push   $0x0
  80200e:	6a 00                	push   $0x0
  802010:	6a 00                	push   $0x0
  802012:	6a 00                	push   $0x0
  802014:	6a 0c                	push   $0xc
  802016:	e8 60 fe ff ff       	call   801e7b <syscall>
  80201b:	83 c4 18             	add    $0x18,%esp
}
  80201e:	c9                   	leave  
  80201f:	c3                   	ret    

00802020 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802020:	55                   	push   %ebp
  802021:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802023:	6a 00                	push   $0x0
  802025:	6a 00                	push   $0x0
  802027:	6a 00                	push   $0x0
  802029:	6a 00                	push   $0x0
  80202b:	ff 75 08             	pushl  0x8(%ebp)
  80202e:	6a 0d                	push   $0xd
  802030:	e8 46 fe ff ff       	call   801e7b <syscall>
  802035:	83 c4 18             	add    $0x18,%esp
}
  802038:	c9                   	leave  
  802039:	c3                   	ret    

0080203a <sys_scarce_memory>:

void sys_scarce_memory()
{
  80203a:	55                   	push   %ebp
  80203b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80203d:	6a 00                	push   $0x0
  80203f:	6a 00                	push   $0x0
  802041:	6a 00                	push   $0x0
  802043:	6a 00                	push   $0x0
  802045:	6a 00                	push   $0x0
  802047:	6a 0e                	push   $0xe
  802049:	e8 2d fe ff ff       	call   801e7b <syscall>
  80204e:	83 c4 18             	add    $0x18,%esp
}
  802051:	90                   	nop
  802052:	c9                   	leave  
  802053:	c3                   	ret    

00802054 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802054:	55                   	push   %ebp
  802055:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802057:	6a 00                	push   $0x0
  802059:	6a 00                	push   $0x0
  80205b:	6a 00                	push   $0x0
  80205d:	6a 00                	push   $0x0
  80205f:	6a 00                	push   $0x0
  802061:	6a 13                	push   $0x13
  802063:	e8 13 fe ff ff       	call   801e7b <syscall>
  802068:	83 c4 18             	add    $0x18,%esp
}
  80206b:	90                   	nop
  80206c:	c9                   	leave  
  80206d:	c3                   	ret    

0080206e <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80206e:	55                   	push   %ebp
  80206f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802071:	6a 00                	push   $0x0
  802073:	6a 00                	push   $0x0
  802075:	6a 00                	push   $0x0
  802077:	6a 00                	push   $0x0
  802079:	6a 00                	push   $0x0
  80207b:	6a 14                	push   $0x14
  80207d:	e8 f9 fd ff ff       	call   801e7b <syscall>
  802082:	83 c4 18             	add    $0x18,%esp
}
  802085:	90                   	nop
  802086:	c9                   	leave  
  802087:	c3                   	ret    

00802088 <sys_cputc>:


void
sys_cputc(const char c)
{
  802088:	55                   	push   %ebp
  802089:	89 e5                	mov    %esp,%ebp
  80208b:	83 ec 04             	sub    $0x4,%esp
  80208e:	8b 45 08             	mov    0x8(%ebp),%eax
  802091:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802094:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802098:	6a 00                	push   $0x0
  80209a:	6a 00                	push   $0x0
  80209c:	6a 00                	push   $0x0
  80209e:	6a 00                	push   $0x0
  8020a0:	50                   	push   %eax
  8020a1:	6a 15                	push   $0x15
  8020a3:	e8 d3 fd ff ff       	call   801e7b <syscall>
  8020a8:	83 c4 18             	add    $0x18,%esp
}
  8020ab:	90                   	nop
  8020ac:	c9                   	leave  
  8020ad:	c3                   	ret    

008020ae <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8020ae:	55                   	push   %ebp
  8020af:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8020b1:	6a 00                	push   $0x0
  8020b3:	6a 00                	push   $0x0
  8020b5:	6a 00                	push   $0x0
  8020b7:	6a 00                	push   $0x0
  8020b9:	6a 00                	push   $0x0
  8020bb:	6a 16                	push   $0x16
  8020bd:	e8 b9 fd ff ff       	call   801e7b <syscall>
  8020c2:	83 c4 18             	add    $0x18,%esp
}
  8020c5:	90                   	nop
  8020c6:	c9                   	leave  
  8020c7:	c3                   	ret    

008020c8 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8020c8:	55                   	push   %ebp
  8020c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8020cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ce:	6a 00                	push   $0x0
  8020d0:	6a 00                	push   $0x0
  8020d2:	6a 00                	push   $0x0
  8020d4:	ff 75 0c             	pushl  0xc(%ebp)
  8020d7:	50                   	push   %eax
  8020d8:	6a 17                	push   $0x17
  8020da:	e8 9c fd ff ff       	call   801e7b <syscall>
  8020df:	83 c4 18             	add    $0x18,%esp
}
  8020e2:	c9                   	leave  
  8020e3:	c3                   	ret    

008020e4 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8020e4:	55                   	push   %ebp
  8020e5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8020e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ed:	6a 00                	push   $0x0
  8020ef:	6a 00                	push   $0x0
  8020f1:	6a 00                	push   $0x0
  8020f3:	52                   	push   %edx
  8020f4:	50                   	push   %eax
  8020f5:	6a 1a                	push   $0x1a
  8020f7:	e8 7f fd ff ff       	call   801e7b <syscall>
  8020fc:	83 c4 18             	add    $0x18,%esp
}
  8020ff:	c9                   	leave  
  802100:	c3                   	ret    

00802101 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802101:	55                   	push   %ebp
  802102:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802104:	8b 55 0c             	mov    0xc(%ebp),%edx
  802107:	8b 45 08             	mov    0x8(%ebp),%eax
  80210a:	6a 00                	push   $0x0
  80210c:	6a 00                	push   $0x0
  80210e:	6a 00                	push   $0x0
  802110:	52                   	push   %edx
  802111:	50                   	push   %eax
  802112:	6a 18                	push   $0x18
  802114:	e8 62 fd ff ff       	call   801e7b <syscall>
  802119:	83 c4 18             	add    $0x18,%esp
}
  80211c:	90                   	nop
  80211d:	c9                   	leave  
  80211e:	c3                   	ret    

0080211f <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80211f:	55                   	push   %ebp
  802120:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802122:	8b 55 0c             	mov    0xc(%ebp),%edx
  802125:	8b 45 08             	mov    0x8(%ebp),%eax
  802128:	6a 00                	push   $0x0
  80212a:	6a 00                	push   $0x0
  80212c:	6a 00                	push   $0x0
  80212e:	52                   	push   %edx
  80212f:	50                   	push   %eax
  802130:	6a 19                	push   $0x19
  802132:	e8 44 fd ff ff       	call   801e7b <syscall>
  802137:	83 c4 18             	add    $0x18,%esp
}
  80213a:	90                   	nop
  80213b:	c9                   	leave  
  80213c:	c3                   	ret    

0080213d <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80213d:	55                   	push   %ebp
  80213e:	89 e5                	mov    %esp,%ebp
  802140:	83 ec 04             	sub    $0x4,%esp
  802143:	8b 45 10             	mov    0x10(%ebp),%eax
  802146:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802149:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80214c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802150:	8b 45 08             	mov    0x8(%ebp),%eax
  802153:	6a 00                	push   $0x0
  802155:	51                   	push   %ecx
  802156:	52                   	push   %edx
  802157:	ff 75 0c             	pushl  0xc(%ebp)
  80215a:	50                   	push   %eax
  80215b:	6a 1b                	push   $0x1b
  80215d:	e8 19 fd ff ff       	call   801e7b <syscall>
  802162:	83 c4 18             	add    $0x18,%esp
}
  802165:	c9                   	leave  
  802166:	c3                   	ret    

00802167 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802167:	55                   	push   %ebp
  802168:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80216a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80216d:	8b 45 08             	mov    0x8(%ebp),%eax
  802170:	6a 00                	push   $0x0
  802172:	6a 00                	push   $0x0
  802174:	6a 00                	push   $0x0
  802176:	52                   	push   %edx
  802177:	50                   	push   %eax
  802178:	6a 1c                	push   $0x1c
  80217a:	e8 fc fc ff ff       	call   801e7b <syscall>
  80217f:	83 c4 18             	add    $0x18,%esp
}
  802182:	c9                   	leave  
  802183:	c3                   	ret    

00802184 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802184:	55                   	push   %ebp
  802185:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802187:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80218a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80218d:	8b 45 08             	mov    0x8(%ebp),%eax
  802190:	6a 00                	push   $0x0
  802192:	6a 00                	push   $0x0
  802194:	51                   	push   %ecx
  802195:	52                   	push   %edx
  802196:	50                   	push   %eax
  802197:	6a 1d                	push   $0x1d
  802199:	e8 dd fc ff ff       	call   801e7b <syscall>
  80219e:	83 c4 18             	add    $0x18,%esp
}
  8021a1:	c9                   	leave  
  8021a2:	c3                   	ret    

008021a3 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8021a3:	55                   	push   %ebp
  8021a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8021a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ac:	6a 00                	push   $0x0
  8021ae:	6a 00                	push   $0x0
  8021b0:	6a 00                	push   $0x0
  8021b2:	52                   	push   %edx
  8021b3:	50                   	push   %eax
  8021b4:	6a 1e                	push   $0x1e
  8021b6:	e8 c0 fc ff ff       	call   801e7b <syscall>
  8021bb:	83 c4 18             	add    $0x18,%esp
}
  8021be:	c9                   	leave  
  8021bf:	c3                   	ret    

008021c0 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8021c0:	55                   	push   %ebp
  8021c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8021c3:	6a 00                	push   $0x0
  8021c5:	6a 00                	push   $0x0
  8021c7:	6a 00                	push   $0x0
  8021c9:	6a 00                	push   $0x0
  8021cb:	6a 00                	push   $0x0
  8021cd:	6a 1f                	push   $0x1f
  8021cf:	e8 a7 fc ff ff       	call   801e7b <syscall>
  8021d4:	83 c4 18             	add    $0x18,%esp
}
  8021d7:	c9                   	leave  
  8021d8:	c3                   	ret    

008021d9 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8021d9:	55                   	push   %ebp
  8021da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8021dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021df:	6a 00                	push   $0x0
  8021e1:	ff 75 14             	pushl  0x14(%ebp)
  8021e4:	ff 75 10             	pushl  0x10(%ebp)
  8021e7:	ff 75 0c             	pushl  0xc(%ebp)
  8021ea:	50                   	push   %eax
  8021eb:	6a 20                	push   $0x20
  8021ed:	e8 89 fc ff ff       	call   801e7b <syscall>
  8021f2:	83 c4 18             	add    $0x18,%esp
}
  8021f5:	c9                   	leave  
  8021f6:	c3                   	ret    

008021f7 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8021f7:	55                   	push   %ebp
  8021f8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8021fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fd:	6a 00                	push   $0x0
  8021ff:	6a 00                	push   $0x0
  802201:	6a 00                	push   $0x0
  802203:	6a 00                	push   $0x0
  802205:	50                   	push   %eax
  802206:	6a 21                	push   $0x21
  802208:	e8 6e fc ff ff       	call   801e7b <syscall>
  80220d:	83 c4 18             	add    $0x18,%esp
}
  802210:	90                   	nop
  802211:	c9                   	leave  
  802212:	c3                   	ret    

00802213 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802213:	55                   	push   %ebp
  802214:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802216:	8b 45 08             	mov    0x8(%ebp),%eax
  802219:	6a 00                	push   $0x0
  80221b:	6a 00                	push   $0x0
  80221d:	6a 00                	push   $0x0
  80221f:	6a 00                	push   $0x0
  802221:	50                   	push   %eax
  802222:	6a 22                	push   $0x22
  802224:	e8 52 fc ff ff       	call   801e7b <syscall>
  802229:	83 c4 18             	add    $0x18,%esp
}
  80222c:	c9                   	leave  
  80222d:	c3                   	ret    

0080222e <sys_getenvid>:

int32 sys_getenvid(void)
{
  80222e:	55                   	push   %ebp
  80222f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802231:	6a 00                	push   $0x0
  802233:	6a 00                	push   $0x0
  802235:	6a 00                	push   $0x0
  802237:	6a 00                	push   $0x0
  802239:	6a 00                	push   $0x0
  80223b:	6a 02                	push   $0x2
  80223d:	e8 39 fc ff ff       	call   801e7b <syscall>
  802242:	83 c4 18             	add    $0x18,%esp
}
  802245:	c9                   	leave  
  802246:	c3                   	ret    

00802247 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802247:	55                   	push   %ebp
  802248:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80224a:	6a 00                	push   $0x0
  80224c:	6a 00                	push   $0x0
  80224e:	6a 00                	push   $0x0
  802250:	6a 00                	push   $0x0
  802252:	6a 00                	push   $0x0
  802254:	6a 03                	push   $0x3
  802256:	e8 20 fc ff ff       	call   801e7b <syscall>
  80225b:	83 c4 18             	add    $0x18,%esp
}
  80225e:	c9                   	leave  
  80225f:	c3                   	ret    

00802260 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802260:	55                   	push   %ebp
  802261:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802263:	6a 00                	push   $0x0
  802265:	6a 00                	push   $0x0
  802267:	6a 00                	push   $0x0
  802269:	6a 00                	push   $0x0
  80226b:	6a 00                	push   $0x0
  80226d:	6a 04                	push   $0x4
  80226f:	e8 07 fc ff ff       	call   801e7b <syscall>
  802274:	83 c4 18             	add    $0x18,%esp
}
  802277:	c9                   	leave  
  802278:	c3                   	ret    

00802279 <sys_exit_env>:


void sys_exit_env(void)
{
  802279:	55                   	push   %ebp
  80227a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80227c:	6a 00                	push   $0x0
  80227e:	6a 00                	push   $0x0
  802280:	6a 00                	push   $0x0
  802282:	6a 00                	push   $0x0
  802284:	6a 00                	push   $0x0
  802286:	6a 23                	push   $0x23
  802288:	e8 ee fb ff ff       	call   801e7b <syscall>
  80228d:	83 c4 18             	add    $0x18,%esp
}
  802290:	90                   	nop
  802291:	c9                   	leave  
  802292:	c3                   	ret    

00802293 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802293:	55                   	push   %ebp
  802294:	89 e5                	mov    %esp,%ebp
  802296:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802299:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80229c:	8d 50 04             	lea    0x4(%eax),%edx
  80229f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8022a2:	6a 00                	push   $0x0
  8022a4:	6a 00                	push   $0x0
  8022a6:	6a 00                	push   $0x0
  8022a8:	52                   	push   %edx
  8022a9:	50                   	push   %eax
  8022aa:	6a 24                	push   $0x24
  8022ac:	e8 ca fb ff ff       	call   801e7b <syscall>
  8022b1:	83 c4 18             	add    $0x18,%esp
	return result;
  8022b4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8022ba:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8022bd:	89 01                	mov    %eax,(%ecx)
  8022bf:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8022c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c5:	c9                   	leave  
  8022c6:	c2 04 00             	ret    $0x4

008022c9 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8022c9:	55                   	push   %ebp
  8022ca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8022cc:	6a 00                	push   $0x0
  8022ce:	6a 00                	push   $0x0
  8022d0:	ff 75 10             	pushl  0x10(%ebp)
  8022d3:	ff 75 0c             	pushl  0xc(%ebp)
  8022d6:	ff 75 08             	pushl  0x8(%ebp)
  8022d9:	6a 12                	push   $0x12
  8022db:	e8 9b fb ff ff       	call   801e7b <syscall>
  8022e0:	83 c4 18             	add    $0x18,%esp
	return ;
  8022e3:	90                   	nop
}
  8022e4:	c9                   	leave  
  8022e5:	c3                   	ret    

008022e6 <sys_rcr2>:
uint32 sys_rcr2()
{
  8022e6:	55                   	push   %ebp
  8022e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8022e9:	6a 00                	push   $0x0
  8022eb:	6a 00                	push   $0x0
  8022ed:	6a 00                	push   $0x0
  8022ef:	6a 00                	push   $0x0
  8022f1:	6a 00                	push   $0x0
  8022f3:	6a 25                	push   $0x25
  8022f5:	e8 81 fb ff ff       	call   801e7b <syscall>
  8022fa:	83 c4 18             	add    $0x18,%esp
}
  8022fd:	c9                   	leave  
  8022fe:	c3                   	ret    

008022ff <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8022ff:	55                   	push   %ebp
  802300:	89 e5                	mov    %esp,%ebp
  802302:	83 ec 04             	sub    $0x4,%esp
  802305:	8b 45 08             	mov    0x8(%ebp),%eax
  802308:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80230b:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80230f:	6a 00                	push   $0x0
  802311:	6a 00                	push   $0x0
  802313:	6a 00                	push   $0x0
  802315:	6a 00                	push   $0x0
  802317:	50                   	push   %eax
  802318:	6a 26                	push   $0x26
  80231a:	e8 5c fb ff ff       	call   801e7b <syscall>
  80231f:	83 c4 18             	add    $0x18,%esp
	return ;
  802322:	90                   	nop
}
  802323:	c9                   	leave  
  802324:	c3                   	ret    

00802325 <rsttst>:
void rsttst()
{
  802325:	55                   	push   %ebp
  802326:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802328:	6a 00                	push   $0x0
  80232a:	6a 00                	push   $0x0
  80232c:	6a 00                	push   $0x0
  80232e:	6a 00                	push   $0x0
  802330:	6a 00                	push   $0x0
  802332:	6a 28                	push   $0x28
  802334:	e8 42 fb ff ff       	call   801e7b <syscall>
  802339:	83 c4 18             	add    $0x18,%esp
	return ;
  80233c:	90                   	nop
}
  80233d:	c9                   	leave  
  80233e:	c3                   	ret    

0080233f <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80233f:	55                   	push   %ebp
  802340:	89 e5                	mov    %esp,%ebp
  802342:	83 ec 04             	sub    $0x4,%esp
  802345:	8b 45 14             	mov    0x14(%ebp),%eax
  802348:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80234b:	8b 55 18             	mov    0x18(%ebp),%edx
  80234e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802352:	52                   	push   %edx
  802353:	50                   	push   %eax
  802354:	ff 75 10             	pushl  0x10(%ebp)
  802357:	ff 75 0c             	pushl  0xc(%ebp)
  80235a:	ff 75 08             	pushl  0x8(%ebp)
  80235d:	6a 27                	push   $0x27
  80235f:	e8 17 fb ff ff       	call   801e7b <syscall>
  802364:	83 c4 18             	add    $0x18,%esp
	return ;
  802367:	90                   	nop
}
  802368:	c9                   	leave  
  802369:	c3                   	ret    

0080236a <chktst>:
void chktst(uint32 n)
{
  80236a:	55                   	push   %ebp
  80236b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80236d:	6a 00                	push   $0x0
  80236f:	6a 00                	push   $0x0
  802371:	6a 00                	push   $0x0
  802373:	6a 00                	push   $0x0
  802375:	ff 75 08             	pushl  0x8(%ebp)
  802378:	6a 29                	push   $0x29
  80237a:	e8 fc fa ff ff       	call   801e7b <syscall>
  80237f:	83 c4 18             	add    $0x18,%esp
	return ;
  802382:	90                   	nop
}
  802383:	c9                   	leave  
  802384:	c3                   	ret    

00802385 <inctst>:

void inctst()
{
  802385:	55                   	push   %ebp
  802386:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802388:	6a 00                	push   $0x0
  80238a:	6a 00                	push   $0x0
  80238c:	6a 00                	push   $0x0
  80238e:	6a 00                	push   $0x0
  802390:	6a 00                	push   $0x0
  802392:	6a 2a                	push   $0x2a
  802394:	e8 e2 fa ff ff       	call   801e7b <syscall>
  802399:	83 c4 18             	add    $0x18,%esp
	return ;
  80239c:	90                   	nop
}
  80239d:	c9                   	leave  
  80239e:	c3                   	ret    

0080239f <gettst>:
uint32 gettst()
{
  80239f:	55                   	push   %ebp
  8023a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8023a2:	6a 00                	push   $0x0
  8023a4:	6a 00                	push   $0x0
  8023a6:	6a 00                	push   $0x0
  8023a8:	6a 00                	push   $0x0
  8023aa:	6a 00                	push   $0x0
  8023ac:	6a 2b                	push   $0x2b
  8023ae:	e8 c8 fa ff ff       	call   801e7b <syscall>
  8023b3:	83 c4 18             	add    $0x18,%esp
}
  8023b6:	c9                   	leave  
  8023b7:	c3                   	ret    

008023b8 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8023b8:	55                   	push   %ebp
  8023b9:	89 e5                	mov    %esp,%ebp
  8023bb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023be:	6a 00                	push   $0x0
  8023c0:	6a 00                	push   $0x0
  8023c2:	6a 00                	push   $0x0
  8023c4:	6a 00                	push   $0x0
  8023c6:	6a 00                	push   $0x0
  8023c8:	6a 2c                	push   $0x2c
  8023ca:	e8 ac fa ff ff       	call   801e7b <syscall>
  8023cf:	83 c4 18             	add    $0x18,%esp
  8023d2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8023d5:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8023d9:	75 07                	jne    8023e2 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8023db:	b8 01 00 00 00       	mov    $0x1,%eax
  8023e0:	eb 05                	jmp    8023e7 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8023e2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023e7:	c9                   	leave  
  8023e8:	c3                   	ret    

008023e9 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8023e9:	55                   	push   %ebp
  8023ea:	89 e5                	mov    %esp,%ebp
  8023ec:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023ef:	6a 00                	push   $0x0
  8023f1:	6a 00                	push   $0x0
  8023f3:	6a 00                	push   $0x0
  8023f5:	6a 00                	push   $0x0
  8023f7:	6a 00                	push   $0x0
  8023f9:	6a 2c                	push   $0x2c
  8023fb:	e8 7b fa ff ff       	call   801e7b <syscall>
  802400:	83 c4 18             	add    $0x18,%esp
  802403:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802406:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80240a:	75 07                	jne    802413 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80240c:	b8 01 00 00 00       	mov    $0x1,%eax
  802411:	eb 05                	jmp    802418 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802413:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802418:	c9                   	leave  
  802419:	c3                   	ret    

0080241a <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80241a:	55                   	push   %ebp
  80241b:	89 e5                	mov    %esp,%ebp
  80241d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802420:	6a 00                	push   $0x0
  802422:	6a 00                	push   $0x0
  802424:	6a 00                	push   $0x0
  802426:	6a 00                	push   $0x0
  802428:	6a 00                	push   $0x0
  80242a:	6a 2c                	push   $0x2c
  80242c:	e8 4a fa ff ff       	call   801e7b <syscall>
  802431:	83 c4 18             	add    $0x18,%esp
  802434:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802437:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80243b:	75 07                	jne    802444 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80243d:	b8 01 00 00 00       	mov    $0x1,%eax
  802442:	eb 05                	jmp    802449 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802444:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802449:	c9                   	leave  
  80244a:	c3                   	ret    

0080244b <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80244b:	55                   	push   %ebp
  80244c:	89 e5                	mov    %esp,%ebp
  80244e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802451:	6a 00                	push   $0x0
  802453:	6a 00                	push   $0x0
  802455:	6a 00                	push   $0x0
  802457:	6a 00                	push   $0x0
  802459:	6a 00                	push   $0x0
  80245b:	6a 2c                	push   $0x2c
  80245d:	e8 19 fa ff ff       	call   801e7b <syscall>
  802462:	83 c4 18             	add    $0x18,%esp
  802465:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802468:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80246c:	75 07                	jne    802475 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80246e:	b8 01 00 00 00       	mov    $0x1,%eax
  802473:	eb 05                	jmp    80247a <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802475:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80247a:	c9                   	leave  
  80247b:	c3                   	ret    

0080247c <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80247c:	55                   	push   %ebp
  80247d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80247f:	6a 00                	push   $0x0
  802481:	6a 00                	push   $0x0
  802483:	6a 00                	push   $0x0
  802485:	6a 00                	push   $0x0
  802487:	ff 75 08             	pushl  0x8(%ebp)
  80248a:	6a 2d                	push   $0x2d
  80248c:	e8 ea f9 ff ff       	call   801e7b <syscall>
  802491:	83 c4 18             	add    $0x18,%esp
	return ;
  802494:	90                   	nop
}
  802495:	c9                   	leave  
  802496:	c3                   	ret    

00802497 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802497:	55                   	push   %ebp
  802498:	89 e5                	mov    %esp,%ebp
  80249a:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80249b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80249e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8024a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a7:	6a 00                	push   $0x0
  8024a9:	53                   	push   %ebx
  8024aa:	51                   	push   %ecx
  8024ab:	52                   	push   %edx
  8024ac:	50                   	push   %eax
  8024ad:	6a 2e                	push   $0x2e
  8024af:	e8 c7 f9 ff ff       	call   801e7b <syscall>
  8024b4:	83 c4 18             	add    $0x18,%esp
}
  8024b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8024ba:	c9                   	leave  
  8024bb:	c3                   	ret    

008024bc <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8024bc:	55                   	push   %ebp
  8024bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8024bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c5:	6a 00                	push   $0x0
  8024c7:	6a 00                	push   $0x0
  8024c9:	6a 00                	push   $0x0
  8024cb:	52                   	push   %edx
  8024cc:	50                   	push   %eax
  8024cd:	6a 2f                	push   $0x2f
  8024cf:	e8 a7 f9 ff ff       	call   801e7b <syscall>
  8024d4:	83 c4 18             	add    $0x18,%esp
}
  8024d7:	c9                   	leave  
  8024d8:	c3                   	ret    

008024d9 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8024d9:	55                   	push   %ebp
  8024da:	89 e5                	mov    %esp,%ebp
  8024dc:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8024df:	83 ec 0c             	sub    $0xc,%esp
  8024e2:	68 c4 46 80 00       	push   $0x8046c4
  8024e7:	e8 65 e6 ff ff       	call   800b51 <cprintf>
  8024ec:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8024ef:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8024f6:	83 ec 0c             	sub    $0xc,%esp
  8024f9:	68 f0 46 80 00       	push   $0x8046f0
  8024fe:	e8 4e e6 ff ff       	call   800b51 <cprintf>
  802503:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802506:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80250a:	a1 38 51 80 00       	mov    0x805138,%eax
  80250f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802512:	eb 56                	jmp    80256a <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802514:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802518:	74 1c                	je     802536 <print_mem_block_lists+0x5d>
  80251a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251d:	8b 50 08             	mov    0x8(%eax),%edx
  802520:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802523:	8b 48 08             	mov    0x8(%eax),%ecx
  802526:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802529:	8b 40 0c             	mov    0xc(%eax),%eax
  80252c:	01 c8                	add    %ecx,%eax
  80252e:	39 c2                	cmp    %eax,%edx
  802530:	73 04                	jae    802536 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802532:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802536:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802539:	8b 50 08             	mov    0x8(%eax),%edx
  80253c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253f:	8b 40 0c             	mov    0xc(%eax),%eax
  802542:	01 c2                	add    %eax,%edx
  802544:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802547:	8b 40 08             	mov    0x8(%eax),%eax
  80254a:	83 ec 04             	sub    $0x4,%esp
  80254d:	52                   	push   %edx
  80254e:	50                   	push   %eax
  80254f:	68 05 47 80 00       	push   $0x804705
  802554:	e8 f8 e5 ff ff       	call   800b51 <cprintf>
  802559:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80255c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802562:	a1 40 51 80 00       	mov    0x805140,%eax
  802567:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80256a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80256e:	74 07                	je     802577 <print_mem_block_lists+0x9e>
  802570:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802573:	8b 00                	mov    (%eax),%eax
  802575:	eb 05                	jmp    80257c <print_mem_block_lists+0xa3>
  802577:	b8 00 00 00 00       	mov    $0x0,%eax
  80257c:	a3 40 51 80 00       	mov    %eax,0x805140
  802581:	a1 40 51 80 00       	mov    0x805140,%eax
  802586:	85 c0                	test   %eax,%eax
  802588:	75 8a                	jne    802514 <print_mem_block_lists+0x3b>
  80258a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80258e:	75 84                	jne    802514 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802590:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802594:	75 10                	jne    8025a6 <print_mem_block_lists+0xcd>
  802596:	83 ec 0c             	sub    $0xc,%esp
  802599:	68 14 47 80 00       	push   $0x804714
  80259e:	e8 ae e5 ff ff       	call   800b51 <cprintf>
  8025a3:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8025a6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8025ad:	83 ec 0c             	sub    $0xc,%esp
  8025b0:	68 38 47 80 00       	push   $0x804738
  8025b5:	e8 97 e5 ff ff       	call   800b51 <cprintf>
  8025ba:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8025bd:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8025c1:	a1 40 50 80 00       	mov    0x805040,%eax
  8025c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025c9:	eb 56                	jmp    802621 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8025cb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025cf:	74 1c                	je     8025ed <print_mem_block_lists+0x114>
  8025d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d4:	8b 50 08             	mov    0x8(%eax),%edx
  8025d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025da:	8b 48 08             	mov    0x8(%eax),%ecx
  8025dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025e0:	8b 40 0c             	mov    0xc(%eax),%eax
  8025e3:	01 c8                	add    %ecx,%eax
  8025e5:	39 c2                	cmp    %eax,%edx
  8025e7:	73 04                	jae    8025ed <print_mem_block_lists+0x114>
			sorted = 0 ;
  8025e9:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8025ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f0:	8b 50 08             	mov    0x8(%eax),%edx
  8025f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f6:	8b 40 0c             	mov    0xc(%eax),%eax
  8025f9:	01 c2                	add    %eax,%edx
  8025fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fe:	8b 40 08             	mov    0x8(%eax),%eax
  802601:	83 ec 04             	sub    $0x4,%esp
  802604:	52                   	push   %edx
  802605:	50                   	push   %eax
  802606:	68 05 47 80 00       	push   $0x804705
  80260b:	e8 41 e5 ff ff       	call   800b51 <cprintf>
  802610:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802613:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802616:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802619:	a1 48 50 80 00       	mov    0x805048,%eax
  80261e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802621:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802625:	74 07                	je     80262e <print_mem_block_lists+0x155>
  802627:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262a:	8b 00                	mov    (%eax),%eax
  80262c:	eb 05                	jmp    802633 <print_mem_block_lists+0x15a>
  80262e:	b8 00 00 00 00       	mov    $0x0,%eax
  802633:	a3 48 50 80 00       	mov    %eax,0x805048
  802638:	a1 48 50 80 00       	mov    0x805048,%eax
  80263d:	85 c0                	test   %eax,%eax
  80263f:	75 8a                	jne    8025cb <print_mem_block_lists+0xf2>
  802641:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802645:	75 84                	jne    8025cb <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802647:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80264b:	75 10                	jne    80265d <print_mem_block_lists+0x184>
  80264d:	83 ec 0c             	sub    $0xc,%esp
  802650:	68 50 47 80 00       	push   $0x804750
  802655:	e8 f7 e4 ff ff       	call   800b51 <cprintf>
  80265a:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80265d:	83 ec 0c             	sub    $0xc,%esp
  802660:	68 c4 46 80 00       	push   $0x8046c4
  802665:	e8 e7 e4 ff ff       	call   800b51 <cprintf>
  80266a:	83 c4 10             	add    $0x10,%esp

}
  80266d:	90                   	nop
  80266e:	c9                   	leave  
  80266f:	c3                   	ret    

00802670 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802670:	55                   	push   %ebp
  802671:	89 e5                	mov    %esp,%ebp
  802673:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  802676:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  80267d:	00 00 00 
  802680:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802687:	00 00 00 
  80268a:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802691:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  802694:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80269b:	e9 9e 00 00 00       	jmp    80273e <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  8026a0:	a1 50 50 80 00       	mov    0x805050,%eax
  8026a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026a8:	c1 e2 04             	shl    $0x4,%edx
  8026ab:	01 d0                	add    %edx,%eax
  8026ad:	85 c0                	test   %eax,%eax
  8026af:	75 14                	jne    8026c5 <initialize_MemBlocksList+0x55>
  8026b1:	83 ec 04             	sub    $0x4,%esp
  8026b4:	68 78 47 80 00       	push   $0x804778
  8026b9:	6a 46                	push   $0x46
  8026bb:	68 9b 47 80 00       	push   $0x80479b
  8026c0:	e8 d8 e1 ff ff       	call   80089d <_panic>
  8026c5:	a1 50 50 80 00       	mov    0x805050,%eax
  8026ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026cd:	c1 e2 04             	shl    $0x4,%edx
  8026d0:	01 d0                	add    %edx,%eax
  8026d2:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8026d8:	89 10                	mov    %edx,(%eax)
  8026da:	8b 00                	mov    (%eax),%eax
  8026dc:	85 c0                	test   %eax,%eax
  8026de:	74 18                	je     8026f8 <initialize_MemBlocksList+0x88>
  8026e0:	a1 48 51 80 00       	mov    0x805148,%eax
  8026e5:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8026eb:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8026ee:	c1 e1 04             	shl    $0x4,%ecx
  8026f1:	01 ca                	add    %ecx,%edx
  8026f3:	89 50 04             	mov    %edx,0x4(%eax)
  8026f6:	eb 12                	jmp    80270a <initialize_MemBlocksList+0x9a>
  8026f8:	a1 50 50 80 00       	mov    0x805050,%eax
  8026fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802700:	c1 e2 04             	shl    $0x4,%edx
  802703:	01 d0                	add    %edx,%eax
  802705:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80270a:	a1 50 50 80 00       	mov    0x805050,%eax
  80270f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802712:	c1 e2 04             	shl    $0x4,%edx
  802715:	01 d0                	add    %edx,%eax
  802717:	a3 48 51 80 00       	mov    %eax,0x805148
  80271c:	a1 50 50 80 00       	mov    0x805050,%eax
  802721:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802724:	c1 e2 04             	shl    $0x4,%edx
  802727:	01 d0                	add    %edx,%eax
  802729:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802730:	a1 54 51 80 00       	mov    0x805154,%eax
  802735:	40                   	inc    %eax
  802736:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  80273b:	ff 45 f4             	incl   -0xc(%ebp)
  80273e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802741:	3b 45 08             	cmp    0x8(%ebp),%eax
  802744:	0f 82 56 ff ff ff    	jb     8026a0 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  80274a:	90                   	nop
  80274b:	c9                   	leave  
  80274c:	c3                   	ret    

0080274d <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80274d:	55                   	push   %ebp
  80274e:	89 e5                	mov    %esp,%ebp
  802750:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802753:	8b 45 08             	mov    0x8(%ebp),%eax
  802756:	8b 00                	mov    (%eax),%eax
  802758:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80275b:	eb 19                	jmp    802776 <find_block+0x29>
	{
		if(va==point->sva)
  80275d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802760:	8b 40 08             	mov    0x8(%eax),%eax
  802763:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802766:	75 05                	jne    80276d <find_block+0x20>
		   return point;
  802768:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80276b:	eb 36                	jmp    8027a3 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80276d:	8b 45 08             	mov    0x8(%ebp),%eax
  802770:	8b 40 08             	mov    0x8(%eax),%eax
  802773:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802776:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80277a:	74 07                	je     802783 <find_block+0x36>
  80277c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80277f:	8b 00                	mov    (%eax),%eax
  802781:	eb 05                	jmp    802788 <find_block+0x3b>
  802783:	b8 00 00 00 00       	mov    $0x0,%eax
  802788:	8b 55 08             	mov    0x8(%ebp),%edx
  80278b:	89 42 08             	mov    %eax,0x8(%edx)
  80278e:	8b 45 08             	mov    0x8(%ebp),%eax
  802791:	8b 40 08             	mov    0x8(%eax),%eax
  802794:	85 c0                	test   %eax,%eax
  802796:	75 c5                	jne    80275d <find_block+0x10>
  802798:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80279c:	75 bf                	jne    80275d <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  80279e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027a3:	c9                   	leave  
  8027a4:	c3                   	ret    

008027a5 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8027a5:	55                   	push   %ebp
  8027a6:	89 e5                	mov    %esp,%ebp
  8027a8:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  8027ab:	a1 40 50 80 00       	mov    0x805040,%eax
  8027b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  8027b3:	a1 44 50 80 00       	mov    0x805044,%eax
  8027b8:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8027bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027be:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8027c1:	74 24                	je     8027e7 <insert_sorted_allocList+0x42>
  8027c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c6:	8b 50 08             	mov    0x8(%eax),%edx
  8027c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027cc:	8b 40 08             	mov    0x8(%eax),%eax
  8027cf:	39 c2                	cmp    %eax,%edx
  8027d1:	76 14                	jbe    8027e7 <insert_sorted_allocList+0x42>
  8027d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d6:	8b 50 08             	mov    0x8(%eax),%edx
  8027d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027dc:	8b 40 08             	mov    0x8(%eax),%eax
  8027df:	39 c2                	cmp    %eax,%edx
  8027e1:	0f 82 60 01 00 00    	jb     802947 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8027e7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027eb:	75 65                	jne    802852 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8027ed:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8027f1:	75 14                	jne    802807 <insert_sorted_allocList+0x62>
  8027f3:	83 ec 04             	sub    $0x4,%esp
  8027f6:	68 78 47 80 00       	push   $0x804778
  8027fb:	6a 6b                	push   $0x6b
  8027fd:	68 9b 47 80 00       	push   $0x80479b
  802802:	e8 96 e0 ff ff       	call   80089d <_panic>
  802807:	8b 15 40 50 80 00    	mov    0x805040,%edx
  80280d:	8b 45 08             	mov    0x8(%ebp),%eax
  802810:	89 10                	mov    %edx,(%eax)
  802812:	8b 45 08             	mov    0x8(%ebp),%eax
  802815:	8b 00                	mov    (%eax),%eax
  802817:	85 c0                	test   %eax,%eax
  802819:	74 0d                	je     802828 <insert_sorted_allocList+0x83>
  80281b:	a1 40 50 80 00       	mov    0x805040,%eax
  802820:	8b 55 08             	mov    0x8(%ebp),%edx
  802823:	89 50 04             	mov    %edx,0x4(%eax)
  802826:	eb 08                	jmp    802830 <insert_sorted_allocList+0x8b>
  802828:	8b 45 08             	mov    0x8(%ebp),%eax
  80282b:	a3 44 50 80 00       	mov    %eax,0x805044
  802830:	8b 45 08             	mov    0x8(%ebp),%eax
  802833:	a3 40 50 80 00       	mov    %eax,0x805040
  802838:	8b 45 08             	mov    0x8(%ebp),%eax
  80283b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802842:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802847:	40                   	inc    %eax
  802848:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80284d:	e9 dc 01 00 00       	jmp    802a2e <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802852:	8b 45 08             	mov    0x8(%ebp),%eax
  802855:	8b 50 08             	mov    0x8(%eax),%edx
  802858:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80285b:	8b 40 08             	mov    0x8(%eax),%eax
  80285e:	39 c2                	cmp    %eax,%edx
  802860:	77 6c                	ja     8028ce <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802862:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802866:	74 06                	je     80286e <insert_sorted_allocList+0xc9>
  802868:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80286c:	75 14                	jne    802882 <insert_sorted_allocList+0xdd>
  80286e:	83 ec 04             	sub    $0x4,%esp
  802871:	68 b4 47 80 00       	push   $0x8047b4
  802876:	6a 6f                	push   $0x6f
  802878:	68 9b 47 80 00       	push   $0x80479b
  80287d:	e8 1b e0 ff ff       	call   80089d <_panic>
  802882:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802885:	8b 50 04             	mov    0x4(%eax),%edx
  802888:	8b 45 08             	mov    0x8(%ebp),%eax
  80288b:	89 50 04             	mov    %edx,0x4(%eax)
  80288e:	8b 45 08             	mov    0x8(%ebp),%eax
  802891:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802894:	89 10                	mov    %edx,(%eax)
  802896:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802899:	8b 40 04             	mov    0x4(%eax),%eax
  80289c:	85 c0                	test   %eax,%eax
  80289e:	74 0d                	je     8028ad <insert_sorted_allocList+0x108>
  8028a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028a3:	8b 40 04             	mov    0x4(%eax),%eax
  8028a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8028a9:	89 10                	mov    %edx,(%eax)
  8028ab:	eb 08                	jmp    8028b5 <insert_sorted_allocList+0x110>
  8028ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b0:	a3 40 50 80 00       	mov    %eax,0x805040
  8028b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8028bb:	89 50 04             	mov    %edx,0x4(%eax)
  8028be:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8028c3:	40                   	inc    %eax
  8028c4:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8028c9:	e9 60 01 00 00       	jmp    802a2e <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8028ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d1:	8b 50 08             	mov    0x8(%eax),%edx
  8028d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028d7:	8b 40 08             	mov    0x8(%eax),%eax
  8028da:	39 c2                	cmp    %eax,%edx
  8028dc:	0f 82 4c 01 00 00    	jb     802a2e <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8028e2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028e6:	75 14                	jne    8028fc <insert_sorted_allocList+0x157>
  8028e8:	83 ec 04             	sub    $0x4,%esp
  8028eb:	68 ec 47 80 00       	push   $0x8047ec
  8028f0:	6a 73                	push   $0x73
  8028f2:	68 9b 47 80 00       	push   $0x80479b
  8028f7:	e8 a1 df ff ff       	call   80089d <_panic>
  8028fc:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802902:	8b 45 08             	mov    0x8(%ebp),%eax
  802905:	89 50 04             	mov    %edx,0x4(%eax)
  802908:	8b 45 08             	mov    0x8(%ebp),%eax
  80290b:	8b 40 04             	mov    0x4(%eax),%eax
  80290e:	85 c0                	test   %eax,%eax
  802910:	74 0c                	je     80291e <insert_sorted_allocList+0x179>
  802912:	a1 44 50 80 00       	mov    0x805044,%eax
  802917:	8b 55 08             	mov    0x8(%ebp),%edx
  80291a:	89 10                	mov    %edx,(%eax)
  80291c:	eb 08                	jmp    802926 <insert_sorted_allocList+0x181>
  80291e:	8b 45 08             	mov    0x8(%ebp),%eax
  802921:	a3 40 50 80 00       	mov    %eax,0x805040
  802926:	8b 45 08             	mov    0x8(%ebp),%eax
  802929:	a3 44 50 80 00       	mov    %eax,0x805044
  80292e:	8b 45 08             	mov    0x8(%ebp),%eax
  802931:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802937:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80293c:	40                   	inc    %eax
  80293d:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802942:	e9 e7 00 00 00       	jmp    802a2e <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802947:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80294a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  80294d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802954:	a1 40 50 80 00       	mov    0x805040,%eax
  802959:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80295c:	e9 9d 00 00 00       	jmp    8029fe <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802961:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802964:	8b 00                	mov    (%eax),%eax
  802966:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802969:	8b 45 08             	mov    0x8(%ebp),%eax
  80296c:	8b 50 08             	mov    0x8(%eax),%edx
  80296f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802972:	8b 40 08             	mov    0x8(%eax),%eax
  802975:	39 c2                	cmp    %eax,%edx
  802977:	76 7d                	jbe    8029f6 <insert_sorted_allocList+0x251>
  802979:	8b 45 08             	mov    0x8(%ebp),%eax
  80297c:	8b 50 08             	mov    0x8(%eax),%edx
  80297f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802982:	8b 40 08             	mov    0x8(%eax),%eax
  802985:	39 c2                	cmp    %eax,%edx
  802987:	73 6d                	jae    8029f6 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802989:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80298d:	74 06                	je     802995 <insert_sorted_allocList+0x1f0>
  80298f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802993:	75 14                	jne    8029a9 <insert_sorted_allocList+0x204>
  802995:	83 ec 04             	sub    $0x4,%esp
  802998:	68 10 48 80 00       	push   $0x804810
  80299d:	6a 7f                	push   $0x7f
  80299f:	68 9b 47 80 00       	push   $0x80479b
  8029a4:	e8 f4 de ff ff       	call   80089d <_panic>
  8029a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ac:	8b 10                	mov    (%eax),%edx
  8029ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b1:	89 10                	mov    %edx,(%eax)
  8029b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b6:	8b 00                	mov    (%eax),%eax
  8029b8:	85 c0                	test   %eax,%eax
  8029ba:	74 0b                	je     8029c7 <insert_sorted_allocList+0x222>
  8029bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bf:	8b 00                	mov    (%eax),%eax
  8029c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8029c4:	89 50 04             	mov    %edx,0x4(%eax)
  8029c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8029cd:	89 10                	mov    %edx,(%eax)
  8029cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029d5:	89 50 04             	mov    %edx,0x4(%eax)
  8029d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029db:	8b 00                	mov    (%eax),%eax
  8029dd:	85 c0                	test   %eax,%eax
  8029df:	75 08                	jne    8029e9 <insert_sorted_allocList+0x244>
  8029e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e4:	a3 44 50 80 00       	mov    %eax,0x805044
  8029e9:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8029ee:	40                   	inc    %eax
  8029ef:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8029f4:	eb 39                	jmp    802a2f <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8029f6:	a1 48 50 80 00       	mov    0x805048,%eax
  8029fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a02:	74 07                	je     802a0b <insert_sorted_allocList+0x266>
  802a04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a07:	8b 00                	mov    (%eax),%eax
  802a09:	eb 05                	jmp    802a10 <insert_sorted_allocList+0x26b>
  802a0b:	b8 00 00 00 00       	mov    $0x0,%eax
  802a10:	a3 48 50 80 00       	mov    %eax,0x805048
  802a15:	a1 48 50 80 00       	mov    0x805048,%eax
  802a1a:	85 c0                	test   %eax,%eax
  802a1c:	0f 85 3f ff ff ff    	jne    802961 <insert_sorted_allocList+0x1bc>
  802a22:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a26:	0f 85 35 ff ff ff    	jne    802961 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802a2c:	eb 01                	jmp    802a2f <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802a2e:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802a2f:	90                   	nop
  802a30:	c9                   	leave  
  802a31:	c3                   	ret    

00802a32 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802a32:	55                   	push   %ebp
  802a33:	89 e5                	mov    %esp,%ebp
  802a35:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802a38:	a1 38 51 80 00       	mov    0x805138,%eax
  802a3d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a40:	e9 85 01 00 00       	jmp    802bca <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802a45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a48:	8b 40 0c             	mov    0xc(%eax),%eax
  802a4b:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a4e:	0f 82 6e 01 00 00    	jb     802bc2 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802a54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a57:	8b 40 0c             	mov    0xc(%eax),%eax
  802a5a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a5d:	0f 85 8a 00 00 00    	jne    802aed <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802a63:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a67:	75 17                	jne    802a80 <alloc_block_FF+0x4e>
  802a69:	83 ec 04             	sub    $0x4,%esp
  802a6c:	68 44 48 80 00       	push   $0x804844
  802a71:	68 93 00 00 00       	push   $0x93
  802a76:	68 9b 47 80 00       	push   $0x80479b
  802a7b:	e8 1d de ff ff       	call   80089d <_panic>
  802a80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a83:	8b 00                	mov    (%eax),%eax
  802a85:	85 c0                	test   %eax,%eax
  802a87:	74 10                	je     802a99 <alloc_block_FF+0x67>
  802a89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8c:	8b 00                	mov    (%eax),%eax
  802a8e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a91:	8b 52 04             	mov    0x4(%edx),%edx
  802a94:	89 50 04             	mov    %edx,0x4(%eax)
  802a97:	eb 0b                	jmp    802aa4 <alloc_block_FF+0x72>
  802a99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9c:	8b 40 04             	mov    0x4(%eax),%eax
  802a9f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802aa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa7:	8b 40 04             	mov    0x4(%eax),%eax
  802aaa:	85 c0                	test   %eax,%eax
  802aac:	74 0f                	je     802abd <alloc_block_FF+0x8b>
  802aae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab1:	8b 40 04             	mov    0x4(%eax),%eax
  802ab4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ab7:	8b 12                	mov    (%edx),%edx
  802ab9:	89 10                	mov    %edx,(%eax)
  802abb:	eb 0a                	jmp    802ac7 <alloc_block_FF+0x95>
  802abd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac0:	8b 00                	mov    (%eax),%eax
  802ac2:	a3 38 51 80 00       	mov    %eax,0x805138
  802ac7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ad0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ada:	a1 44 51 80 00       	mov    0x805144,%eax
  802adf:	48                   	dec    %eax
  802ae0:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802ae5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae8:	e9 10 01 00 00       	jmp    802bfd <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802aed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af0:	8b 40 0c             	mov    0xc(%eax),%eax
  802af3:	3b 45 08             	cmp    0x8(%ebp),%eax
  802af6:	0f 86 c6 00 00 00    	jbe    802bc2 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802afc:	a1 48 51 80 00       	mov    0x805148,%eax
  802b01:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802b04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b07:	8b 50 08             	mov    0x8(%eax),%edx
  802b0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b0d:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802b10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b13:	8b 55 08             	mov    0x8(%ebp),%edx
  802b16:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802b19:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b1d:	75 17                	jne    802b36 <alloc_block_FF+0x104>
  802b1f:	83 ec 04             	sub    $0x4,%esp
  802b22:	68 44 48 80 00       	push   $0x804844
  802b27:	68 9b 00 00 00       	push   $0x9b
  802b2c:	68 9b 47 80 00       	push   $0x80479b
  802b31:	e8 67 dd ff ff       	call   80089d <_panic>
  802b36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b39:	8b 00                	mov    (%eax),%eax
  802b3b:	85 c0                	test   %eax,%eax
  802b3d:	74 10                	je     802b4f <alloc_block_FF+0x11d>
  802b3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b42:	8b 00                	mov    (%eax),%eax
  802b44:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b47:	8b 52 04             	mov    0x4(%edx),%edx
  802b4a:	89 50 04             	mov    %edx,0x4(%eax)
  802b4d:	eb 0b                	jmp    802b5a <alloc_block_FF+0x128>
  802b4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b52:	8b 40 04             	mov    0x4(%eax),%eax
  802b55:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b5d:	8b 40 04             	mov    0x4(%eax),%eax
  802b60:	85 c0                	test   %eax,%eax
  802b62:	74 0f                	je     802b73 <alloc_block_FF+0x141>
  802b64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b67:	8b 40 04             	mov    0x4(%eax),%eax
  802b6a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b6d:	8b 12                	mov    (%edx),%edx
  802b6f:	89 10                	mov    %edx,(%eax)
  802b71:	eb 0a                	jmp    802b7d <alloc_block_FF+0x14b>
  802b73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b76:	8b 00                	mov    (%eax),%eax
  802b78:	a3 48 51 80 00       	mov    %eax,0x805148
  802b7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b80:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b89:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b90:	a1 54 51 80 00       	mov    0x805154,%eax
  802b95:	48                   	dec    %eax
  802b96:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802b9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9e:	8b 50 08             	mov    0x8(%eax),%edx
  802ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba4:	01 c2                	add    %eax,%edx
  802ba6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba9:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802bac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802baf:	8b 40 0c             	mov    0xc(%eax),%eax
  802bb2:	2b 45 08             	sub    0x8(%ebp),%eax
  802bb5:	89 c2                	mov    %eax,%edx
  802bb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bba:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802bbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bc0:	eb 3b                	jmp    802bfd <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802bc2:	a1 40 51 80 00       	mov    0x805140,%eax
  802bc7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bce:	74 07                	je     802bd7 <alloc_block_FF+0x1a5>
  802bd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd3:	8b 00                	mov    (%eax),%eax
  802bd5:	eb 05                	jmp    802bdc <alloc_block_FF+0x1aa>
  802bd7:	b8 00 00 00 00       	mov    $0x0,%eax
  802bdc:	a3 40 51 80 00       	mov    %eax,0x805140
  802be1:	a1 40 51 80 00       	mov    0x805140,%eax
  802be6:	85 c0                	test   %eax,%eax
  802be8:	0f 85 57 fe ff ff    	jne    802a45 <alloc_block_FF+0x13>
  802bee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bf2:	0f 85 4d fe ff ff    	jne    802a45 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802bf8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bfd:	c9                   	leave  
  802bfe:	c3                   	ret    

00802bff <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802bff:	55                   	push   %ebp
  802c00:	89 e5                	mov    %esp,%ebp
  802c02:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802c05:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802c0c:	a1 38 51 80 00       	mov    0x805138,%eax
  802c11:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c14:	e9 df 00 00 00       	jmp    802cf8 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802c19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1c:	8b 40 0c             	mov    0xc(%eax),%eax
  802c1f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c22:	0f 82 c8 00 00 00    	jb     802cf0 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802c28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2b:	8b 40 0c             	mov    0xc(%eax),%eax
  802c2e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c31:	0f 85 8a 00 00 00    	jne    802cc1 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802c37:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c3b:	75 17                	jne    802c54 <alloc_block_BF+0x55>
  802c3d:	83 ec 04             	sub    $0x4,%esp
  802c40:	68 44 48 80 00       	push   $0x804844
  802c45:	68 b7 00 00 00       	push   $0xb7
  802c4a:	68 9b 47 80 00       	push   $0x80479b
  802c4f:	e8 49 dc ff ff       	call   80089d <_panic>
  802c54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c57:	8b 00                	mov    (%eax),%eax
  802c59:	85 c0                	test   %eax,%eax
  802c5b:	74 10                	je     802c6d <alloc_block_BF+0x6e>
  802c5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c60:	8b 00                	mov    (%eax),%eax
  802c62:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c65:	8b 52 04             	mov    0x4(%edx),%edx
  802c68:	89 50 04             	mov    %edx,0x4(%eax)
  802c6b:	eb 0b                	jmp    802c78 <alloc_block_BF+0x79>
  802c6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c70:	8b 40 04             	mov    0x4(%eax),%eax
  802c73:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7b:	8b 40 04             	mov    0x4(%eax),%eax
  802c7e:	85 c0                	test   %eax,%eax
  802c80:	74 0f                	je     802c91 <alloc_block_BF+0x92>
  802c82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c85:	8b 40 04             	mov    0x4(%eax),%eax
  802c88:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c8b:	8b 12                	mov    (%edx),%edx
  802c8d:	89 10                	mov    %edx,(%eax)
  802c8f:	eb 0a                	jmp    802c9b <alloc_block_BF+0x9c>
  802c91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c94:	8b 00                	mov    (%eax),%eax
  802c96:	a3 38 51 80 00       	mov    %eax,0x805138
  802c9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ca4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cae:	a1 44 51 80 00       	mov    0x805144,%eax
  802cb3:	48                   	dec    %eax
  802cb4:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802cb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbc:	e9 4d 01 00 00       	jmp    802e0e <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802cc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc4:	8b 40 0c             	mov    0xc(%eax),%eax
  802cc7:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cca:	76 24                	jbe    802cf0 <alloc_block_BF+0xf1>
  802ccc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ccf:	8b 40 0c             	mov    0xc(%eax),%eax
  802cd2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802cd5:	73 19                	jae    802cf0 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802cd7:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802cde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce1:	8b 40 0c             	mov    0xc(%eax),%eax
  802ce4:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802ce7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cea:	8b 40 08             	mov    0x8(%eax),%eax
  802ced:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802cf0:	a1 40 51 80 00       	mov    0x805140,%eax
  802cf5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cf8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cfc:	74 07                	je     802d05 <alloc_block_BF+0x106>
  802cfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d01:	8b 00                	mov    (%eax),%eax
  802d03:	eb 05                	jmp    802d0a <alloc_block_BF+0x10b>
  802d05:	b8 00 00 00 00       	mov    $0x0,%eax
  802d0a:	a3 40 51 80 00       	mov    %eax,0x805140
  802d0f:	a1 40 51 80 00       	mov    0x805140,%eax
  802d14:	85 c0                	test   %eax,%eax
  802d16:	0f 85 fd fe ff ff    	jne    802c19 <alloc_block_BF+0x1a>
  802d1c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d20:	0f 85 f3 fe ff ff    	jne    802c19 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802d26:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802d2a:	0f 84 d9 00 00 00    	je     802e09 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802d30:	a1 48 51 80 00       	mov    0x805148,%eax
  802d35:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802d38:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d3b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d3e:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802d41:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d44:	8b 55 08             	mov    0x8(%ebp),%edx
  802d47:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802d4a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802d4e:	75 17                	jne    802d67 <alloc_block_BF+0x168>
  802d50:	83 ec 04             	sub    $0x4,%esp
  802d53:	68 44 48 80 00       	push   $0x804844
  802d58:	68 c7 00 00 00       	push   $0xc7
  802d5d:	68 9b 47 80 00       	push   $0x80479b
  802d62:	e8 36 db ff ff       	call   80089d <_panic>
  802d67:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d6a:	8b 00                	mov    (%eax),%eax
  802d6c:	85 c0                	test   %eax,%eax
  802d6e:	74 10                	je     802d80 <alloc_block_BF+0x181>
  802d70:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d73:	8b 00                	mov    (%eax),%eax
  802d75:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d78:	8b 52 04             	mov    0x4(%edx),%edx
  802d7b:	89 50 04             	mov    %edx,0x4(%eax)
  802d7e:	eb 0b                	jmp    802d8b <alloc_block_BF+0x18c>
  802d80:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d83:	8b 40 04             	mov    0x4(%eax),%eax
  802d86:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d8b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d8e:	8b 40 04             	mov    0x4(%eax),%eax
  802d91:	85 c0                	test   %eax,%eax
  802d93:	74 0f                	je     802da4 <alloc_block_BF+0x1a5>
  802d95:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d98:	8b 40 04             	mov    0x4(%eax),%eax
  802d9b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d9e:	8b 12                	mov    (%edx),%edx
  802da0:	89 10                	mov    %edx,(%eax)
  802da2:	eb 0a                	jmp    802dae <alloc_block_BF+0x1af>
  802da4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802da7:	8b 00                	mov    (%eax),%eax
  802da9:	a3 48 51 80 00       	mov    %eax,0x805148
  802dae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802db1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802db7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dba:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dc1:	a1 54 51 80 00       	mov    0x805154,%eax
  802dc6:	48                   	dec    %eax
  802dc7:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802dcc:	83 ec 08             	sub    $0x8,%esp
  802dcf:	ff 75 ec             	pushl  -0x14(%ebp)
  802dd2:	68 38 51 80 00       	push   $0x805138
  802dd7:	e8 71 f9 ff ff       	call   80274d <find_block>
  802ddc:	83 c4 10             	add    $0x10,%esp
  802ddf:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802de2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802de5:	8b 50 08             	mov    0x8(%eax),%edx
  802de8:	8b 45 08             	mov    0x8(%ebp),%eax
  802deb:	01 c2                	add    %eax,%edx
  802ded:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802df0:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802df3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802df6:	8b 40 0c             	mov    0xc(%eax),%eax
  802df9:	2b 45 08             	sub    0x8(%ebp),%eax
  802dfc:	89 c2                	mov    %eax,%edx
  802dfe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e01:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802e04:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e07:	eb 05                	jmp    802e0e <alloc_block_BF+0x20f>
	}
	return NULL;
  802e09:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e0e:	c9                   	leave  
  802e0f:	c3                   	ret    

00802e10 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802e10:	55                   	push   %ebp
  802e11:	89 e5                	mov    %esp,%ebp
  802e13:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802e16:	a1 28 50 80 00       	mov    0x805028,%eax
  802e1b:	85 c0                	test   %eax,%eax
  802e1d:	0f 85 de 01 00 00    	jne    803001 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802e23:	a1 38 51 80 00       	mov    0x805138,%eax
  802e28:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e2b:	e9 9e 01 00 00       	jmp    802fce <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802e30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e33:	8b 40 0c             	mov    0xc(%eax),%eax
  802e36:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e39:	0f 82 87 01 00 00    	jb     802fc6 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802e3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e42:	8b 40 0c             	mov    0xc(%eax),%eax
  802e45:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e48:	0f 85 95 00 00 00    	jne    802ee3 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802e4e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e52:	75 17                	jne    802e6b <alloc_block_NF+0x5b>
  802e54:	83 ec 04             	sub    $0x4,%esp
  802e57:	68 44 48 80 00       	push   $0x804844
  802e5c:	68 e0 00 00 00       	push   $0xe0
  802e61:	68 9b 47 80 00       	push   $0x80479b
  802e66:	e8 32 da ff ff       	call   80089d <_panic>
  802e6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6e:	8b 00                	mov    (%eax),%eax
  802e70:	85 c0                	test   %eax,%eax
  802e72:	74 10                	je     802e84 <alloc_block_NF+0x74>
  802e74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e77:	8b 00                	mov    (%eax),%eax
  802e79:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e7c:	8b 52 04             	mov    0x4(%edx),%edx
  802e7f:	89 50 04             	mov    %edx,0x4(%eax)
  802e82:	eb 0b                	jmp    802e8f <alloc_block_NF+0x7f>
  802e84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e87:	8b 40 04             	mov    0x4(%eax),%eax
  802e8a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e92:	8b 40 04             	mov    0x4(%eax),%eax
  802e95:	85 c0                	test   %eax,%eax
  802e97:	74 0f                	je     802ea8 <alloc_block_NF+0x98>
  802e99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9c:	8b 40 04             	mov    0x4(%eax),%eax
  802e9f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ea2:	8b 12                	mov    (%edx),%edx
  802ea4:	89 10                	mov    %edx,(%eax)
  802ea6:	eb 0a                	jmp    802eb2 <alloc_block_NF+0xa2>
  802ea8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eab:	8b 00                	mov    (%eax),%eax
  802ead:	a3 38 51 80 00       	mov    %eax,0x805138
  802eb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ebb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ec5:	a1 44 51 80 00       	mov    0x805144,%eax
  802eca:	48                   	dec    %eax
  802ecb:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802ed0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed3:	8b 40 08             	mov    0x8(%eax),%eax
  802ed6:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802edb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ede:	e9 f8 04 00 00       	jmp    8033db <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802ee3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee6:	8b 40 0c             	mov    0xc(%eax),%eax
  802ee9:	3b 45 08             	cmp    0x8(%ebp),%eax
  802eec:	0f 86 d4 00 00 00    	jbe    802fc6 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802ef2:	a1 48 51 80 00       	mov    0x805148,%eax
  802ef7:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802efa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802efd:	8b 50 08             	mov    0x8(%eax),%edx
  802f00:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f03:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802f06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f09:	8b 55 08             	mov    0x8(%ebp),%edx
  802f0c:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802f0f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f13:	75 17                	jne    802f2c <alloc_block_NF+0x11c>
  802f15:	83 ec 04             	sub    $0x4,%esp
  802f18:	68 44 48 80 00       	push   $0x804844
  802f1d:	68 e9 00 00 00       	push   $0xe9
  802f22:	68 9b 47 80 00       	push   $0x80479b
  802f27:	e8 71 d9 ff ff       	call   80089d <_panic>
  802f2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f2f:	8b 00                	mov    (%eax),%eax
  802f31:	85 c0                	test   %eax,%eax
  802f33:	74 10                	je     802f45 <alloc_block_NF+0x135>
  802f35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f38:	8b 00                	mov    (%eax),%eax
  802f3a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f3d:	8b 52 04             	mov    0x4(%edx),%edx
  802f40:	89 50 04             	mov    %edx,0x4(%eax)
  802f43:	eb 0b                	jmp    802f50 <alloc_block_NF+0x140>
  802f45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f48:	8b 40 04             	mov    0x4(%eax),%eax
  802f4b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f53:	8b 40 04             	mov    0x4(%eax),%eax
  802f56:	85 c0                	test   %eax,%eax
  802f58:	74 0f                	je     802f69 <alloc_block_NF+0x159>
  802f5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f5d:	8b 40 04             	mov    0x4(%eax),%eax
  802f60:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f63:	8b 12                	mov    (%edx),%edx
  802f65:	89 10                	mov    %edx,(%eax)
  802f67:	eb 0a                	jmp    802f73 <alloc_block_NF+0x163>
  802f69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f6c:	8b 00                	mov    (%eax),%eax
  802f6e:	a3 48 51 80 00       	mov    %eax,0x805148
  802f73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f76:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f7f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f86:	a1 54 51 80 00       	mov    0x805154,%eax
  802f8b:	48                   	dec    %eax
  802f8c:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802f91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f94:	8b 40 08             	mov    0x8(%eax),%eax
  802f97:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802f9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f9f:	8b 50 08             	mov    0x8(%eax),%edx
  802fa2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa5:	01 c2                	add    %eax,%edx
  802fa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802faa:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802fad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb0:	8b 40 0c             	mov    0xc(%eax),%eax
  802fb3:	2b 45 08             	sub    0x8(%ebp),%eax
  802fb6:	89 c2                	mov    %eax,%edx
  802fb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fbb:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802fbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fc1:	e9 15 04 00 00       	jmp    8033db <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802fc6:	a1 40 51 80 00       	mov    0x805140,%eax
  802fcb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fd2:	74 07                	je     802fdb <alloc_block_NF+0x1cb>
  802fd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd7:	8b 00                	mov    (%eax),%eax
  802fd9:	eb 05                	jmp    802fe0 <alloc_block_NF+0x1d0>
  802fdb:	b8 00 00 00 00       	mov    $0x0,%eax
  802fe0:	a3 40 51 80 00       	mov    %eax,0x805140
  802fe5:	a1 40 51 80 00       	mov    0x805140,%eax
  802fea:	85 c0                	test   %eax,%eax
  802fec:	0f 85 3e fe ff ff    	jne    802e30 <alloc_block_NF+0x20>
  802ff2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ff6:	0f 85 34 fe ff ff    	jne    802e30 <alloc_block_NF+0x20>
  802ffc:	e9 d5 03 00 00       	jmp    8033d6 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  803001:	a1 38 51 80 00       	mov    0x805138,%eax
  803006:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803009:	e9 b1 01 00 00       	jmp    8031bf <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  80300e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803011:	8b 50 08             	mov    0x8(%eax),%edx
  803014:	a1 28 50 80 00       	mov    0x805028,%eax
  803019:	39 c2                	cmp    %eax,%edx
  80301b:	0f 82 96 01 00 00    	jb     8031b7 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  803021:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803024:	8b 40 0c             	mov    0xc(%eax),%eax
  803027:	3b 45 08             	cmp    0x8(%ebp),%eax
  80302a:	0f 82 87 01 00 00    	jb     8031b7 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  803030:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803033:	8b 40 0c             	mov    0xc(%eax),%eax
  803036:	3b 45 08             	cmp    0x8(%ebp),%eax
  803039:	0f 85 95 00 00 00    	jne    8030d4 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  80303f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803043:	75 17                	jne    80305c <alloc_block_NF+0x24c>
  803045:	83 ec 04             	sub    $0x4,%esp
  803048:	68 44 48 80 00       	push   $0x804844
  80304d:	68 fc 00 00 00       	push   $0xfc
  803052:	68 9b 47 80 00       	push   $0x80479b
  803057:	e8 41 d8 ff ff       	call   80089d <_panic>
  80305c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305f:	8b 00                	mov    (%eax),%eax
  803061:	85 c0                	test   %eax,%eax
  803063:	74 10                	je     803075 <alloc_block_NF+0x265>
  803065:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803068:	8b 00                	mov    (%eax),%eax
  80306a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80306d:	8b 52 04             	mov    0x4(%edx),%edx
  803070:	89 50 04             	mov    %edx,0x4(%eax)
  803073:	eb 0b                	jmp    803080 <alloc_block_NF+0x270>
  803075:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803078:	8b 40 04             	mov    0x4(%eax),%eax
  80307b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803080:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803083:	8b 40 04             	mov    0x4(%eax),%eax
  803086:	85 c0                	test   %eax,%eax
  803088:	74 0f                	je     803099 <alloc_block_NF+0x289>
  80308a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80308d:	8b 40 04             	mov    0x4(%eax),%eax
  803090:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803093:	8b 12                	mov    (%edx),%edx
  803095:	89 10                	mov    %edx,(%eax)
  803097:	eb 0a                	jmp    8030a3 <alloc_block_NF+0x293>
  803099:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80309c:	8b 00                	mov    (%eax),%eax
  80309e:	a3 38 51 80 00       	mov    %eax,0x805138
  8030a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030af:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030b6:	a1 44 51 80 00       	mov    0x805144,%eax
  8030bb:	48                   	dec    %eax
  8030bc:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8030c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c4:	8b 40 08             	mov    0x8(%eax),%eax
  8030c7:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  8030cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030cf:	e9 07 03 00 00       	jmp    8033db <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8030d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d7:	8b 40 0c             	mov    0xc(%eax),%eax
  8030da:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030dd:	0f 86 d4 00 00 00    	jbe    8031b7 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8030e3:	a1 48 51 80 00       	mov    0x805148,%eax
  8030e8:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  8030eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ee:	8b 50 08             	mov    0x8(%eax),%edx
  8030f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030f4:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8030f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030fa:	8b 55 08             	mov    0x8(%ebp),%edx
  8030fd:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803100:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803104:	75 17                	jne    80311d <alloc_block_NF+0x30d>
  803106:	83 ec 04             	sub    $0x4,%esp
  803109:	68 44 48 80 00       	push   $0x804844
  80310e:	68 04 01 00 00       	push   $0x104
  803113:	68 9b 47 80 00       	push   $0x80479b
  803118:	e8 80 d7 ff ff       	call   80089d <_panic>
  80311d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803120:	8b 00                	mov    (%eax),%eax
  803122:	85 c0                	test   %eax,%eax
  803124:	74 10                	je     803136 <alloc_block_NF+0x326>
  803126:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803129:	8b 00                	mov    (%eax),%eax
  80312b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80312e:	8b 52 04             	mov    0x4(%edx),%edx
  803131:	89 50 04             	mov    %edx,0x4(%eax)
  803134:	eb 0b                	jmp    803141 <alloc_block_NF+0x331>
  803136:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803139:	8b 40 04             	mov    0x4(%eax),%eax
  80313c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803141:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803144:	8b 40 04             	mov    0x4(%eax),%eax
  803147:	85 c0                	test   %eax,%eax
  803149:	74 0f                	je     80315a <alloc_block_NF+0x34a>
  80314b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80314e:	8b 40 04             	mov    0x4(%eax),%eax
  803151:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803154:	8b 12                	mov    (%edx),%edx
  803156:	89 10                	mov    %edx,(%eax)
  803158:	eb 0a                	jmp    803164 <alloc_block_NF+0x354>
  80315a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80315d:	8b 00                	mov    (%eax),%eax
  80315f:	a3 48 51 80 00       	mov    %eax,0x805148
  803164:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803167:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80316d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803170:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803177:	a1 54 51 80 00       	mov    0x805154,%eax
  80317c:	48                   	dec    %eax
  80317d:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  803182:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803185:	8b 40 08             	mov    0x8(%eax),%eax
  803188:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  80318d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803190:	8b 50 08             	mov    0x8(%eax),%edx
  803193:	8b 45 08             	mov    0x8(%ebp),%eax
  803196:	01 c2                	add    %eax,%edx
  803198:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80319b:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  80319e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a1:	8b 40 0c             	mov    0xc(%eax),%eax
  8031a4:	2b 45 08             	sub    0x8(%ebp),%eax
  8031a7:	89 c2                	mov    %eax,%edx
  8031a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ac:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8031af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031b2:	e9 24 02 00 00       	jmp    8033db <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8031b7:	a1 40 51 80 00       	mov    0x805140,%eax
  8031bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031bf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031c3:	74 07                	je     8031cc <alloc_block_NF+0x3bc>
  8031c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c8:	8b 00                	mov    (%eax),%eax
  8031ca:	eb 05                	jmp    8031d1 <alloc_block_NF+0x3c1>
  8031cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8031d1:	a3 40 51 80 00       	mov    %eax,0x805140
  8031d6:	a1 40 51 80 00       	mov    0x805140,%eax
  8031db:	85 c0                	test   %eax,%eax
  8031dd:	0f 85 2b fe ff ff    	jne    80300e <alloc_block_NF+0x1fe>
  8031e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031e7:	0f 85 21 fe ff ff    	jne    80300e <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8031ed:	a1 38 51 80 00       	mov    0x805138,%eax
  8031f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031f5:	e9 ae 01 00 00       	jmp    8033a8 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  8031fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031fd:	8b 50 08             	mov    0x8(%eax),%edx
  803200:	a1 28 50 80 00       	mov    0x805028,%eax
  803205:	39 c2                	cmp    %eax,%edx
  803207:	0f 83 93 01 00 00    	jae    8033a0 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  80320d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803210:	8b 40 0c             	mov    0xc(%eax),%eax
  803213:	3b 45 08             	cmp    0x8(%ebp),%eax
  803216:	0f 82 84 01 00 00    	jb     8033a0 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  80321c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80321f:	8b 40 0c             	mov    0xc(%eax),%eax
  803222:	3b 45 08             	cmp    0x8(%ebp),%eax
  803225:	0f 85 95 00 00 00    	jne    8032c0 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  80322b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80322f:	75 17                	jne    803248 <alloc_block_NF+0x438>
  803231:	83 ec 04             	sub    $0x4,%esp
  803234:	68 44 48 80 00       	push   $0x804844
  803239:	68 14 01 00 00       	push   $0x114
  80323e:	68 9b 47 80 00       	push   $0x80479b
  803243:	e8 55 d6 ff ff       	call   80089d <_panic>
  803248:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80324b:	8b 00                	mov    (%eax),%eax
  80324d:	85 c0                	test   %eax,%eax
  80324f:	74 10                	je     803261 <alloc_block_NF+0x451>
  803251:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803254:	8b 00                	mov    (%eax),%eax
  803256:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803259:	8b 52 04             	mov    0x4(%edx),%edx
  80325c:	89 50 04             	mov    %edx,0x4(%eax)
  80325f:	eb 0b                	jmp    80326c <alloc_block_NF+0x45c>
  803261:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803264:	8b 40 04             	mov    0x4(%eax),%eax
  803267:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80326c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80326f:	8b 40 04             	mov    0x4(%eax),%eax
  803272:	85 c0                	test   %eax,%eax
  803274:	74 0f                	je     803285 <alloc_block_NF+0x475>
  803276:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803279:	8b 40 04             	mov    0x4(%eax),%eax
  80327c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80327f:	8b 12                	mov    (%edx),%edx
  803281:	89 10                	mov    %edx,(%eax)
  803283:	eb 0a                	jmp    80328f <alloc_block_NF+0x47f>
  803285:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803288:	8b 00                	mov    (%eax),%eax
  80328a:	a3 38 51 80 00       	mov    %eax,0x805138
  80328f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803292:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803298:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80329b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032a2:	a1 44 51 80 00       	mov    0x805144,%eax
  8032a7:	48                   	dec    %eax
  8032a8:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8032ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b0:	8b 40 08             	mov    0x8(%eax),%eax
  8032b3:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  8032b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032bb:	e9 1b 01 00 00       	jmp    8033db <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8032c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c3:	8b 40 0c             	mov    0xc(%eax),%eax
  8032c6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8032c9:	0f 86 d1 00 00 00    	jbe    8033a0 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8032cf:	a1 48 51 80 00       	mov    0x805148,%eax
  8032d4:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  8032d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032da:	8b 50 08             	mov    0x8(%eax),%edx
  8032dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032e0:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8032e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8032e9:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8032ec:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8032f0:	75 17                	jne    803309 <alloc_block_NF+0x4f9>
  8032f2:	83 ec 04             	sub    $0x4,%esp
  8032f5:	68 44 48 80 00       	push   $0x804844
  8032fa:	68 1c 01 00 00       	push   $0x11c
  8032ff:	68 9b 47 80 00       	push   $0x80479b
  803304:	e8 94 d5 ff ff       	call   80089d <_panic>
  803309:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80330c:	8b 00                	mov    (%eax),%eax
  80330e:	85 c0                	test   %eax,%eax
  803310:	74 10                	je     803322 <alloc_block_NF+0x512>
  803312:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803315:	8b 00                	mov    (%eax),%eax
  803317:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80331a:	8b 52 04             	mov    0x4(%edx),%edx
  80331d:	89 50 04             	mov    %edx,0x4(%eax)
  803320:	eb 0b                	jmp    80332d <alloc_block_NF+0x51d>
  803322:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803325:	8b 40 04             	mov    0x4(%eax),%eax
  803328:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80332d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803330:	8b 40 04             	mov    0x4(%eax),%eax
  803333:	85 c0                	test   %eax,%eax
  803335:	74 0f                	je     803346 <alloc_block_NF+0x536>
  803337:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80333a:	8b 40 04             	mov    0x4(%eax),%eax
  80333d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803340:	8b 12                	mov    (%edx),%edx
  803342:	89 10                	mov    %edx,(%eax)
  803344:	eb 0a                	jmp    803350 <alloc_block_NF+0x540>
  803346:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803349:	8b 00                	mov    (%eax),%eax
  80334b:	a3 48 51 80 00       	mov    %eax,0x805148
  803350:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803353:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803359:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80335c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803363:	a1 54 51 80 00       	mov    0x805154,%eax
  803368:	48                   	dec    %eax
  803369:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  80336e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803371:	8b 40 08             	mov    0x8(%eax),%eax
  803374:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  803379:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80337c:	8b 50 08             	mov    0x8(%eax),%edx
  80337f:	8b 45 08             	mov    0x8(%ebp),%eax
  803382:	01 c2                	add    %eax,%edx
  803384:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803387:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  80338a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80338d:	8b 40 0c             	mov    0xc(%eax),%eax
  803390:	2b 45 08             	sub    0x8(%ebp),%eax
  803393:	89 c2                	mov    %eax,%edx
  803395:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803398:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  80339b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80339e:	eb 3b                	jmp    8033db <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8033a0:	a1 40 51 80 00       	mov    0x805140,%eax
  8033a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033ac:	74 07                	je     8033b5 <alloc_block_NF+0x5a5>
  8033ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b1:	8b 00                	mov    (%eax),%eax
  8033b3:	eb 05                	jmp    8033ba <alloc_block_NF+0x5aa>
  8033b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8033ba:	a3 40 51 80 00       	mov    %eax,0x805140
  8033bf:	a1 40 51 80 00       	mov    0x805140,%eax
  8033c4:	85 c0                	test   %eax,%eax
  8033c6:	0f 85 2e fe ff ff    	jne    8031fa <alloc_block_NF+0x3ea>
  8033cc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033d0:	0f 85 24 fe ff ff    	jne    8031fa <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  8033d6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8033db:	c9                   	leave  
  8033dc:	c3                   	ret    

008033dd <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8033dd:	55                   	push   %ebp
  8033de:	89 e5                	mov    %esp,%ebp
  8033e0:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  8033e3:	a1 38 51 80 00       	mov    0x805138,%eax
  8033e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  8033eb:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8033f0:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  8033f3:	a1 38 51 80 00       	mov    0x805138,%eax
  8033f8:	85 c0                	test   %eax,%eax
  8033fa:	74 14                	je     803410 <insert_sorted_with_merge_freeList+0x33>
  8033fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ff:	8b 50 08             	mov    0x8(%eax),%edx
  803402:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803405:	8b 40 08             	mov    0x8(%eax),%eax
  803408:	39 c2                	cmp    %eax,%edx
  80340a:	0f 87 9b 01 00 00    	ja     8035ab <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  803410:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803414:	75 17                	jne    80342d <insert_sorted_with_merge_freeList+0x50>
  803416:	83 ec 04             	sub    $0x4,%esp
  803419:	68 78 47 80 00       	push   $0x804778
  80341e:	68 38 01 00 00       	push   $0x138
  803423:	68 9b 47 80 00       	push   $0x80479b
  803428:	e8 70 d4 ff ff       	call   80089d <_panic>
  80342d:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803433:	8b 45 08             	mov    0x8(%ebp),%eax
  803436:	89 10                	mov    %edx,(%eax)
  803438:	8b 45 08             	mov    0x8(%ebp),%eax
  80343b:	8b 00                	mov    (%eax),%eax
  80343d:	85 c0                	test   %eax,%eax
  80343f:	74 0d                	je     80344e <insert_sorted_with_merge_freeList+0x71>
  803441:	a1 38 51 80 00       	mov    0x805138,%eax
  803446:	8b 55 08             	mov    0x8(%ebp),%edx
  803449:	89 50 04             	mov    %edx,0x4(%eax)
  80344c:	eb 08                	jmp    803456 <insert_sorted_with_merge_freeList+0x79>
  80344e:	8b 45 08             	mov    0x8(%ebp),%eax
  803451:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803456:	8b 45 08             	mov    0x8(%ebp),%eax
  803459:	a3 38 51 80 00       	mov    %eax,0x805138
  80345e:	8b 45 08             	mov    0x8(%ebp),%eax
  803461:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803468:	a1 44 51 80 00       	mov    0x805144,%eax
  80346d:	40                   	inc    %eax
  80346e:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803473:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803477:	0f 84 a8 06 00 00    	je     803b25 <insert_sorted_with_merge_freeList+0x748>
  80347d:	8b 45 08             	mov    0x8(%ebp),%eax
  803480:	8b 50 08             	mov    0x8(%eax),%edx
  803483:	8b 45 08             	mov    0x8(%ebp),%eax
  803486:	8b 40 0c             	mov    0xc(%eax),%eax
  803489:	01 c2                	add    %eax,%edx
  80348b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80348e:	8b 40 08             	mov    0x8(%eax),%eax
  803491:	39 c2                	cmp    %eax,%edx
  803493:	0f 85 8c 06 00 00    	jne    803b25 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  803499:	8b 45 08             	mov    0x8(%ebp),%eax
  80349c:	8b 50 0c             	mov    0xc(%eax),%edx
  80349f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034a2:	8b 40 0c             	mov    0xc(%eax),%eax
  8034a5:	01 c2                	add    %eax,%edx
  8034a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8034aa:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  8034ad:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8034b1:	75 17                	jne    8034ca <insert_sorted_with_merge_freeList+0xed>
  8034b3:	83 ec 04             	sub    $0x4,%esp
  8034b6:	68 44 48 80 00       	push   $0x804844
  8034bb:	68 3c 01 00 00       	push   $0x13c
  8034c0:	68 9b 47 80 00       	push   $0x80479b
  8034c5:	e8 d3 d3 ff ff       	call   80089d <_panic>
  8034ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034cd:	8b 00                	mov    (%eax),%eax
  8034cf:	85 c0                	test   %eax,%eax
  8034d1:	74 10                	je     8034e3 <insert_sorted_with_merge_freeList+0x106>
  8034d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034d6:	8b 00                	mov    (%eax),%eax
  8034d8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034db:	8b 52 04             	mov    0x4(%edx),%edx
  8034de:	89 50 04             	mov    %edx,0x4(%eax)
  8034e1:	eb 0b                	jmp    8034ee <insert_sorted_with_merge_freeList+0x111>
  8034e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034e6:	8b 40 04             	mov    0x4(%eax),%eax
  8034e9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8034ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034f1:	8b 40 04             	mov    0x4(%eax),%eax
  8034f4:	85 c0                	test   %eax,%eax
  8034f6:	74 0f                	je     803507 <insert_sorted_with_merge_freeList+0x12a>
  8034f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034fb:	8b 40 04             	mov    0x4(%eax),%eax
  8034fe:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803501:	8b 12                	mov    (%edx),%edx
  803503:	89 10                	mov    %edx,(%eax)
  803505:	eb 0a                	jmp    803511 <insert_sorted_with_merge_freeList+0x134>
  803507:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80350a:	8b 00                	mov    (%eax),%eax
  80350c:	a3 38 51 80 00       	mov    %eax,0x805138
  803511:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803514:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80351a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80351d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803524:	a1 44 51 80 00       	mov    0x805144,%eax
  803529:	48                   	dec    %eax
  80352a:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  80352f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803532:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  803539:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80353c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  803543:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803547:	75 17                	jne    803560 <insert_sorted_with_merge_freeList+0x183>
  803549:	83 ec 04             	sub    $0x4,%esp
  80354c:	68 78 47 80 00       	push   $0x804778
  803551:	68 3f 01 00 00       	push   $0x13f
  803556:	68 9b 47 80 00       	push   $0x80479b
  80355b:	e8 3d d3 ff ff       	call   80089d <_panic>
  803560:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803566:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803569:	89 10                	mov    %edx,(%eax)
  80356b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80356e:	8b 00                	mov    (%eax),%eax
  803570:	85 c0                	test   %eax,%eax
  803572:	74 0d                	je     803581 <insert_sorted_with_merge_freeList+0x1a4>
  803574:	a1 48 51 80 00       	mov    0x805148,%eax
  803579:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80357c:	89 50 04             	mov    %edx,0x4(%eax)
  80357f:	eb 08                	jmp    803589 <insert_sorted_with_merge_freeList+0x1ac>
  803581:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803584:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803589:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80358c:	a3 48 51 80 00       	mov    %eax,0x805148
  803591:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803594:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80359b:	a1 54 51 80 00       	mov    0x805154,%eax
  8035a0:	40                   	inc    %eax
  8035a1:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8035a6:	e9 7a 05 00 00       	jmp    803b25 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  8035ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ae:	8b 50 08             	mov    0x8(%eax),%edx
  8035b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035b4:	8b 40 08             	mov    0x8(%eax),%eax
  8035b7:	39 c2                	cmp    %eax,%edx
  8035b9:	0f 82 14 01 00 00    	jb     8036d3 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  8035bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035c2:	8b 50 08             	mov    0x8(%eax),%edx
  8035c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035c8:	8b 40 0c             	mov    0xc(%eax),%eax
  8035cb:	01 c2                	add    %eax,%edx
  8035cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d0:	8b 40 08             	mov    0x8(%eax),%eax
  8035d3:	39 c2                	cmp    %eax,%edx
  8035d5:	0f 85 90 00 00 00    	jne    80366b <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  8035db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035de:	8b 50 0c             	mov    0xc(%eax),%edx
  8035e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e4:	8b 40 0c             	mov    0xc(%eax),%eax
  8035e7:	01 c2                	add    %eax,%edx
  8035e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035ec:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  8035ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  8035f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8035fc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803603:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803607:	75 17                	jne    803620 <insert_sorted_with_merge_freeList+0x243>
  803609:	83 ec 04             	sub    $0x4,%esp
  80360c:	68 78 47 80 00       	push   $0x804778
  803611:	68 49 01 00 00       	push   $0x149
  803616:	68 9b 47 80 00       	push   $0x80479b
  80361b:	e8 7d d2 ff ff       	call   80089d <_panic>
  803620:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803626:	8b 45 08             	mov    0x8(%ebp),%eax
  803629:	89 10                	mov    %edx,(%eax)
  80362b:	8b 45 08             	mov    0x8(%ebp),%eax
  80362e:	8b 00                	mov    (%eax),%eax
  803630:	85 c0                	test   %eax,%eax
  803632:	74 0d                	je     803641 <insert_sorted_with_merge_freeList+0x264>
  803634:	a1 48 51 80 00       	mov    0x805148,%eax
  803639:	8b 55 08             	mov    0x8(%ebp),%edx
  80363c:	89 50 04             	mov    %edx,0x4(%eax)
  80363f:	eb 08                	jmp    803649 <insert_sorted_with_merge_freeList+0x26c>
  803641:	8b 45 08             	mov    0x8(%ebp),%eax
  803644:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803649:	8b 45 08             	mov    0x8(%ebp),%eax
  80364c:	a3 48 51 80 00       	mov    %eax,0x805148
  803651:	8b 45 08             	mov    0x8(%ebp),%eax
  803654:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80365b:	a1 54 51 80 00       	mov    0x805154,%eax
  803660:	40                   	inc    %eax
  803661:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803666:	e9 bb 04 00 00       	jmp    803b26 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  80366b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80366f:	75 17                	jne    803688 <insert_sorted_with_merge_freeList+0x2ab>
  803671:	83 ec 04             	sub    $0x4,%esp
  803674:	68 ec 47 80 00       	push   $0x8047ec
  803679:	68 4c 01 00 00       	push   $0x14c
  80367e:	68 9b 47 80 00       	push   $0x80479b
  803683:	e8 15 d2 ff ff       	call   80089d <_panic>
  803688:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  80368e:	8b 45 08             	mov    0x8(%ebp),%eax
  803691:	89 50 04             	mov    %edx,0x4(%eax)
  803694:	8b 45 08             	mov    0x8(%ebp),%eax
  803697:	8b 40 04             	mov    0x4(%eax),%eax
  80369a:	85 c0                	test   %eax,%eax
  80369c:	74 0c                	je     8036aa <insert_sorted_with_merge_freeList+0x2cd>
  80369e:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8036a3:	8b 55 08             	mov    0x8(%ebp),%edx
  8036a6:	89 10                	mov    %edx,(%eax)
  8036a8:	eb 08                	jmp    8036b2 <insert_sorted_with_merge_freeList+0x2d5>
  8036aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ad:	a3 38 51 80 00       	mov    %eax,0x805138
  8036b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8036ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8036bd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036c3:	a1 44 51 80 00       	mov    0x805144,%eax
  8036c8:	40                   	inc    %eax
  8036c9:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8036ce:	e9 53 04 00 00       	jmp    803b26 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8036d3:	a1 38 51 80 00       	mov    0x805138,%eax
  8036d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8036db:	e9 15 04 00 00       	jmp    803af5 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  8036e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036e3:	8b 00                	mov    (%eax),%eax
  8036e5:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  8036e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8036eb:	8b 50 08             	mov    0x8(%eax),%edx
  8036ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036f1:	8b 40 08             	mov    0x8(%eax),%eax
  8036f4:	39 c2                	cmp    %eax,%edx
  8036f6:	0f 86 f1 03 00 00    	jbe    803aed <insert_sorted_with_merge_freeList+0x710>
  8036fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ff:	8b 50 08             	mov    0x8(%eax),%edx
  803702:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803705:	8b 40 08             	mov    0x8(%eax),%eax
  803708:	39 c2                	cmp    %eax,%edx
  80370a:	0f 83 dd 03 00 00    	jae    803aed <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803710:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803713:	8b 50 08             	mov    0x8(%eax),%edx
  803716:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803719:	8b 40 0c             	mov    0xc(%eax),%eax
  80371c:	01 c2                	add    %eax,%edx
  80371e:	8b 45 08             	mov    0x8(%ebp),%eax
  803721:	8b 40 08             	mov    0x8(%eax),%eax
  803724:	39 c2                	cmp    %eax,%edx
  803726:	0f 85 b9 01 00 00    	jne    8038e5 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80372c:	8b 45 08             	mov    0x8(%ebp),%eax
  80372f:	8b 50 08             	mov    0x8(%eax),%edx
  803732:	8b 45 08             	mov    0x8(%ebp),%eax
  803735:	8b 40 0c             	mov    0xc(%eax),%eax
  803738:	01 c2                	add    %eax,%edx
  80373a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80373d:	8b 40 08             	mov    0x8(%eax),%eax
  803740:	39 c2                	cmp    %eax,%edx
  803742:	0f 85 0d 01 00 00    	jne    803855 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803748:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80374b:	8b 50 0c             	mov    0xc(%eax),%edx
  80374e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803751:	8b 40 0c             	mov    0xc(%eax),%eax
  803754:	01 c2                	add    %eax,%edx
  803756:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803759:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80375c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803760:	75 17                	jne    803779 <insert_sorted_with_merge_freeList+0x39c>
  803762:	83 ec 04             	sub    $0x4,%esp
  803765:	68 44 48 80 00       	push   $0x804844
  80376a:	68 5c 01 00 00       	push   $0x15c
  80376f:	68 9b 47 80 00       	push   $0x80479b
  803774:	e8 24 d1 ff ff       	call   80089d <_panic>
  803779:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80377c:	8b 00                	mov    (%eax),%eax
  80377e:	85 c0                	test   %eax,%eax
  803780:	74 10                	je     803792 <insert_sorted_with_merge_freeList+0x3b5>
  803782:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803785:	8b 00                	mov    (%eax),%eax
  803787:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80378a:	8b 52 04             	mov    0x4(%edx),%edx
  80378d:	89 50 04             	mov    %edx,0x4(%eax)
  803790:	eb 0b                	jmp    80379d <insert_sorted_with_merge_freeList+0x3c0>
  803792:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803795:	8b 40 04             	mov    0x4(%eax),%eax
  803798:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80379d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037a0:	8b 40 04             	mov    0x4(%eax),%eax
  8037a3:	85 c0                	test   %eax,%eax
  8037a5:	74 0f                	je     8037b6 <insert_sorted_with_merge_freeList+0x3d9>
  8037a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037aa:	8b 40 04             	mov    0x4(%eax),%eax
  8037ad:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8037b0:	8b 12                	mov    (%edx),%edx
  8037b2:	89 10                	mov    %edx,(%eax)
  8037b4:	eb 0a                	jmp    8037c0 <insert_sorted_with_merge_freeList+0x3e3>
  8037b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037b9:	8b 00                	mov    (%eax),%eax
  8037bb:	a3 38 51 80 00       	mov    %eax,0x805138
  8037c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037c3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037cc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037d3:	a1 44 51 80 00       	mov    0x805144,%eax
  8037d8:	48                   	dec    %eax
  8037d9:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  8037de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037e1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8037e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037eb:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8037f2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8037f6:	75 17                	jne    80380f <insert_sorted_with_merge_freeList+0x432>
  8037f8:	83 ec 04             	sub    $0x4,%esp
  8037fb:	68 78 47 80 00       	push   $0x804778
  803800:	68 5f 01 00 00       	push   $0x15f
  803805:	68 9b 47 80 00       	push   $0x80479b
  80380a:	e8 8e d0 ff ff       	call   80089d <_panic>
  80380f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803815:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803818:	89 10                	mov    %edx,(%eax)
  80381a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80381d:	8b 00                	mov    (%eax),%eax
  80381f:	85 c0                	test   %eax,%eax
  803821:	74 0d                	je     803830 <insert_sorted_with_merge_freeList+0x453>
  803823:	a1 48 51 80 00       	mov    0x805148,%eax
  803828:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80382b:	89 50 04             	mov    %edx,0x4(%eax)
  80382e:	eb 08                	jmp    803838 <insert_sorted_with_merge_freeList+0x45b>
  803830:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803833:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803838:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80383b:	a3 48 51 80 00       	mov    %eax,0x805148
  803840:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803843:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80384a:	a1 54 51 80 00       	mov    0x805154,%eax
  80384f:	40                   	inc    %eax
  803850:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803855:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803858:	8b 50 0c             	mov    0xc(%eax),%edx
  80385b:	8b 45 08             	mov    0x8(%ebp),%eax
  80385e:	8b 40 0c             	mov    0xc(%eax),%eax
  803861:	01 c2                	add    %eax,%edx
  803863:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803866:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803869:	8b 45 08             	mov    0x8(%ebp),%eax
  80386c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803873:	8b 45 08             	mov    0x8(%ebp),%eax
  803876:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80387d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803881:	75 17                	jne    80389a <insert_sorted_with_merge_freeList+0x4bd>
  803883:	83 ec 04             	sub    $0x4,%esp
  803886:	68 78 47 80 00       	push   $0x804778
  80388b:	68 64 01 00 00       	push   $0x164
  803890:	68 9b 47 80 00       	push   $0x80479b
  803895:	e8 03 d0 ff ff       	call   80089d <_panic>
  80389a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8038a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8038a3:	89 10                	mov    %edx,(%eax)
  8038a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8038a8:	8b 00                	mov    (%eax),%eax
  8038aa:	85 c0                	test   %eax,%eax
  8038ac:	74 0d                	je     8038bb <insert_sorted_with_merge_freeList+0x4de>
  8038ae:	a1 48 51 80 00       	mov    0x805148,%eax
  8038b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8038b6:	89 50 04             	mov    %edx,0x4(%eax)
  8038b9:	eb 08                	jmp    8038c3 <insert_sorted_with_merge_freeList+0x4e6>
  8038bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8038be:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8038c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8038c6:	a3 48 51 80 00       	mov    %eax,0x805148
  8038cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ce:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038d5:	a1 54 51 80 00       	mov    0x805154,%eax
  8038da:	40                   	inc    %eax
  8038db:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8038e0:	e9 41 02 00 00       	jmp    803b26 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8038e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8038e8:	8b 50 08             	mov    0x8(%eax),%edx
  8038eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ee:	8b 40 0c             	mov    0xc(%eax),%eax
  8038f1:	01 c2                	add    %eax,%edx
  8038f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038f6:	8b 40 08             	mov    0x8(%eax),%eax
  8038f9:	39 c2                	cmp    %eax,%edx
  8038fb:	0f 85 7c 01 00 00    	jne    803a7d <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803901:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803905:	74 06                	je     80390d <insert_sorted_with_merge_freeList+0x530>
  803907:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80390b:	75 17                	jne    803924 <insert_sorted_with_merge_freeList+0x547>
  80390d:	83 ec 04             	sub    $0x4,%esp
  803910:	68 b4 47 80 00       	push   $0x8047b4
  803915:	68 69 01 00 00       	push   $0x169
  80391a:	68 9b 47 80 00       	push   $0x80479b
  80391f:	e8 79 cf ff ff       	call   80089d <_panic>
  803924:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803927:	8b 50 04             	mov    0x4(%eax),%edx
  80392a:	8b 45 08             	mov    0x8(%ebp),%eax
  80392d:	89 50 04             	mov    %edx,0x4(%eax)
  803930:	8b 45 08             	mov    0x8(%ebp),%eax
  803933:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803936:	89 10                	mov    %edx,(%eax)
  803938:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80393b:	8b 40 04             	mov    0x4(%eax),%eax
  80393e:	85 c0                	test   %eax,%eax
  803940:	74 0d                	je     80394f <insert_sorted_with_merge_freeList+0x572>
  803942:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803945:	8b 40 04             	mov    0x4(%eax),%eax
  803948:	8b 55 08             	mov    0x8(%ebp),%edx
  80394b:	89 10                	mov    %edx,(%eax)
  80394d:	eb 08                	jmp    803957 <insert_sorted_with_merge_freeList+0x57a>
  80394f:	8b 45 08             	mov    0x8(%ebp),%eax
  803952:	a3 38 51 80 00       	mov    %eax,0x805138
  803957:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80395a:	8b 55 08             	mov    0x8(%ebp),%edx
  80395d:	89 50 04             	mov    %edx,0x4(%eax)
  803960:	a1 44 51 80 00       	mov    0x805144,%eax
  803965:	40                   	inc    %eax
  803966:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  80396b:	8b 45 08             	mov    0x8(%ebp),%eax
  80396e:	8b 50 0c             	mov    0xc(%eax),%edx
  803971:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803974:	8b 40 0c             	mov    0xc(%eax),%eax
  803977:	01 c2                	add    %eax,%edx
  803979:	8b 45 08             	mov    0x8(%ebp),%eax
  80397c:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80397f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803983:	75 17                	jne    80399c <insert_sorted_with_merge_freeList+0x5bf>
  803985:	83 ec 04             	sub    $0x4,%esp
  803988:	68 44 48 80 00       	push   $0x804844
  80398d:	68 6b 01 00 00       	push   $0x16b
  803992:	68 9b 47 80 00       	push   $0x80479b
  803997:	e8 01 cf ff ff       	call   80089d <_panic>
  80399c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80399f:	8b 00                	mov    (%eax),%eax
  8039a1:	85 c0                	test   %eax,%eax
  8039a3:	74 10                	je     8039b5 <insert_sorted_with_merge_freeList+0x5d8>
  8039a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039a8:	8b 00                	mov    (%eax),%eax
  8039aa:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8039ad:	8b 52 04             	mov    0x4(%edx),%edx
  8039b0:	89 50 04             	mov    %edx,0x4(%eax)
  8039b3:	eb 0b                	jmp    8039c0 <insert_sorted_with_merge_freeList+0x5e3>
  8039b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039b8:	8b 40 04             	mov    0x4(%eax),%eax
  8039bb:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8039c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039c3:	8b 40 04             	mov    0x4(%eax),%eax
  8039c6:	85 c0                	test   %eax,%eax
  8039c8:	74 0f                	je     8039d9 <insert_sorted_with_merge_freeList+0x5fc>
  8039ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039cd:	8b 40 04             	mov    0x4(%eax),%eax
  8039d0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8039d3:	8b 12                	mov    (%edx),%edx
  8039d5:	89 10                	mov    %edx,(%eax)
  8039d7:	eb 0a                	jmp    8039e3 <insert_sorted_with_merge_freeList+0x606>
  8039d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039dc:	8b 00                	mov    (%eax),%eax
  8039de:	a3 38 51 80 00       	mov    %eax,0x805138
  8039e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039e6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039ef:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039f6:	a1 44 51 80 00       	mov    0x805144,%eax
  8039fb:	48                   	dec    %eax
  8039fc:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803a01:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a04:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803a0b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a0e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803a15:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803a19:	75 17                	jne    803a32 <insert_sorted_with_merge_freeList+0x655>
  803a1b:	83 ec 04             	sub    $0x4,%esp
  803a1e:	68 78 47 80 00       	push   $0x804778
  803a23:	68 6e 01 00 00       	push   $0x16e
  803a28:	68 9b 47 80 00       	push   $0x80479b
  803a2d:	e8 6b ce ff ff       	call   80089d <_panic>
  803a32:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803a38:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a3b:	89 10                	mov    %edx,(%eax)
  803a3d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a40:	8b 00                	mov    (%eax),%eax
  803a42:	85 c0                	test   %eax,%eax
  803a44:	74 0d                	je     803a53 <insert_sorted_with_merge_freeList+0x676>
  803a46:	a1 48 51 80 00       	mov    0x805148,%eax
  803a4b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803a4e:	89 50 04             	mov    %edx,0x4(%eax)
  803a51:	eb 08                	jmp    803a5b <insert_sorted_with_merge_freeList+0x67e>
  803a53:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a56:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803a5b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a5e:	a3 48 51 80 00       	mov    %eax,0x805148
  803a63:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a66:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a6d:	a1 54 51 80 00       	mov    0x805154,%eax
  803a72:	40                   	inc    %eax
  803a73:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803a78:	e9 a9 00 00 00       	jmp    803b26 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803a7d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a81:	74 06                	je     803a89 <insert_sorted_with_merge_freeList+0x6ac>
  803a83:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803a87:	75 17                	jne    803aa0 <insert_sorted_with_merge_freeList+0x6c3>
  803a89:	83 ec 04             	sub    $0x4,%esp
  803a8c:	68 10 48 80 00       	push   $0x804810
  803a91:	68 73 01 00 00       	push   $0x173
  803a96:	68 9b 47 80 00       	push   $0x80479b
  803a9b:	e8 fd cd ff ff       	call   80089d <_panic>
  803aa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aa3:	8b 10                	mov    (%eax),%edx
  803aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  803aa8:	89 10                	mov    %edx,(%eax)
  803aaa:	8b 45 08             	mov    0x8(%ebp),%eax
  803aad:	8b 00                	mov    (%eax),%eax
  803aaf:	85 c0                	test   %eax,%eax
  803ab1:	74 0b                	je     803abe <insert_sorted_with_merge_freeList+0x6e1>
  803ab3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ab6:	8b 00                	mov    (%eax),%eax
  803ab8:	8b 55 08             	mov    0x8(%ebp),%edx
  803abb:	89 50 04             	mov    %edx,0x4(%eax)
  803abe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ac1:	8b 55 08             	mov    0x8(%ebp),%edx
  803ac4:	89 10                	mov    %edx,(%eax)
  803ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  803ac9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803acc:	89 50 04             	mov    %edx,0x4(%eax)
  803acf:	8b 45 08             	mov    0x8(%ebp),%eax
  803ad2:	8b 00                	mov    (%eax),%eax
  803ad4:	85 c0                	test   %eax,%eax
  803ad6:	75 08                	jne    803ae0 <insert_sorted_with_merge_freeList+0x703>
  803ad8:	8b 45 08             	mov    0x8(%ebp),%eax
  803adb:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803ae0:	a1 44 51 80 00       	mov    0x805144,%eax
  803ae5:	40                   	inc    %eax
  803ae6:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803aeb:	eb 39                	jmp    803b26 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803aed:	a1 40 51 80 00       	mov    0x805140,%eax
  803af2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803af5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803af9:	74 07                	je     803b02 <insert_sorted_with_merge_freeList+0x725>
  803afb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803afe:	8b 00                	mov    (%eax),%eax
  803b00:	eb 05                	jmp    803b07 <insert_sorted_with_merge_freeList+0x72a>
  803b02:	b8 00 00 00 00       	mov    $0x0,%eax
  803b07:	a3 40 51 80 00       	mov    %eax,0x805140
  803b0c:	a1 40 51 80 00       	mov    0x805140,%eax
  803b11:	85 c0                	test   %eax,%eax
  803b13:	0f 85 c7 fb ff ff    	jne    8036e0 <insert_sorted_with_merge_freeList+0x303>
  803b19:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b1d:	0f 85 bd fb ff ff    	jne    8036e0 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803b23:	eb 01                	jmp    803b26 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803b25:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803b26:	90                   	nop
  803b27:	c9                   	leave  
  803b28:	c3                   	ret    
  803b29:	66 90                	xchg   %ax,%ax
  803b2b:	90                   	nop

00803b2c <__udivdi3>:
  803b2c:	55                   	push   %ebp
  803b2d:	57                   	push   %edi
  803b2e:	56                   	push   %esi
  803b2f:	53                   	push   %ebx
  803b30:	83 ec 1c             	sub    $0x1c,%esp
  803b33:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803b37:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803b3b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b3f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803b43:	89 ca                	mov    %ecx,%edx
  803b45:	89 f8                	mov    %edi,%eax
  803b47:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803b4b:	85 f6                	test   %esi,%esi
  803b4d:	75 2d                	jne    803b7c <__udivdi3+0x50>
  803b4f:	39 cf                	cmp    %ecx,%edi
  803b51:	77 65                	ja     803bb8 <__udivdi3+0x8c>
  803b53:	89 fd                	mov    %edi,%ebp
  803b55:	85 ff                	test   %edi,%edi
  803b57:	75 0b                	jne    803b64 <__udivdi3+0x38>
  803b59:	b8 01 00 00 00       	mov    $0x1,%eax
  803b5e:	31 d2                	xor    %edx,%edx
  803b60:	f7 f7                	div    %edi
  803b62:	89 c5                	mov    %eax,%ebp
  803b64:	31 d2                	xor    %edx,%edx
  803b66:	89 c8                	mov    %ecx,%eax
  803b68:	f7 f5                	div    %ebp
  803b6a:	89 c1                	mov    %eax,%ecx
  803b6c:	89 d8                	mov    %ebx,%eax
  803b6e:	f7 f5                	div    %ebp
  803b70:	89 cf                	mov    %ecx,%edi
  803b72:	89 fa                	mov    %edi,%edx
  803b74:	83 c4 1c             	add    $0x1c,%esp
  803b77:	5b                   	pop    %ebx
  803b78:	5e                   	pop    %esi
  803b79:	5f                   	pop    %edi
  803b7a:	5d                   	pop    %ebp
  803b7b:	c3                   	ret    
  803b7c:	39 ce                	cmp    %ecx,%esi
  803b7e:	77 28                	ja     803ba8 <__udivdi3+0x7c>
  803b80:	0f bd fe             	bsr    %esi,%edi
  803b83:	83 f7 1f             	xor    $0x1f,%edi
  803b86:	75 40                	jne    803bc8 <__udivdi3+0x9c>
  803b88:	39 ce                	cmp    %ecx,%esi
  803b8a:	72 0a                	jb     803b96 <__udivdi3+0x6a>
  803b8c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803b90:	0f 87 9e 00 00 00    	ja     803c34 <__udivdi3+0x108>
  803b96:	b8 01 00 00 00       	mov    $0x1,%eax
  803b9b:	89 fa                	mov    %edi,%edx
  803b9d:	83 c4 1c             	add    $0x1c,%esp
  803ba0:	5b                   	pop    %ebx
  803ba1:	5e                   	pop    %esi
  803ba2:	5f                   	pop    %edi
  803ba3:	5d                   	pop    %ebp
  803ba4:	c3                   	ret    
  803ba5:	8d 76 00             	lea    0x0(%esi),%esi
  803ba8:	31 ff                	xor    %edi,%edi
  803baa:	31 c0                	xor    %eax,%eax
  803bac:	89 fa                	mov    %edi,%edx
  803bae:	83 c4 1c             	add    $0x1c,%esp
  803bb1:	5b                   	pop    %ebx
  803bb2:	5e                   	pop    %esi
  803bb3:	5f                   	pop    %edi
  803bb4:	5d                   	pop    %ebp
  803bb5:	c3                   	ret    
  803bb6:	66 90                	xchg   %ax,%ax
  803bb8:	89 d8                	mov    %ebx,%eax
  803bba:	f7 f7                	div    %edi
  803bbc:	31 ff                	xor    %edi,%edi
  803bbe:	89 fa                	mov    %edi,%edx
  803bc0:	83 c4 1c             	add    $0x1c,%esp
  803bc3:	5b                   	pop    %ebx
  803bc4:	5e                   	pop    %esi
  803bc5:	5f                   	pop    %edi
  803bc6:	5d                   	pop    %ebp
  803bc7:	c3                   	ret    
  803bc8:	bd 20 00 00 00       	mov    $0x20,%ebp
  803bcd:	89 eb                	mov    %ebp,%ebx
  803bcf:	29 fb                	sub    %edi,%ebx
  803bd1:	89 f9                	mov    %edi,%ecx
  803bd3:	d3 e6                	shl    %cl,%esi
  803bd5:	89 c5                	mov    %eax,%ebp
  803bd7:	88 d9                	mov    %bl,%cl
  803bd9:	d3 ed                	shr    %cl,%ebp
  803bdb:	89 e9                	mov    %ebp,%ecx
  803bdd:	09 f1                	or     %esi,%ecx
  803bdf:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803be3:	89 f9                	mov    %edi,%ecx
  803be5:	d3 e0                	shl    %cl,%eax
  803be7:	89 c5                	mov    %eax,%ebp
  803be9:	89 d6                	mov    %edx,%esi
  803beb:	88 d9                	mov    %bl,%cl
  803bed:	d3 ee                	shr    %cl,%esi
  803bef:	89 f9                	mov    %edi,%ecx
  803bf1:	d3 e2                	shl    %cl,%edx
  803bf3:	8b 44 24 08          	mov    0x8(%esp),%eax
  803bf7:	88 d9                	mov    %bl,%cl
  803bf9:	d3 e8                	shr    %cl,%eax
  803bfb:	09 c2                	or     %eax,%edx
  803bfd:	89 d0                	mov    %edx,%eax
  803bff:	89 f2                	mov    %esi,%edx
  803c01:	f7 74 24 0c          	divl   0xc(%esp)
  803c05:	89 d6                	mov    %edx,%esi
  803c07:	89 c3                	mov    %eax,%ebx
  803c09:	f7 e5                	mul    %ebp
  803c0b:	39 d6                	cmp    %edx,%esi
  803c0d:	72 19                	jb     803c28 <__udivdi3+0xfc>
  803c0f:	74 0b                	je     803c1c <__udivdi3+0xf0>
  803c11:	89 d8                	mov    %ebx,%eax
  803c13:	31 ff                	xor    %edi,%edi
  803c15:	e9 58 ff ff ff       	jmp    803b72 <__udivdi3+0x46>
  803c1a:	66 90                	xchg   %ax,%ax
  803c1c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803c20:	89 f9                	mov    %edi,%ecx
  803c22:	d3 e2                	shl    %cl,%edx
  803c24:	39 c2                	cmp    %eax,%edx
  803c26:	73 e9                	jae    803c11 <__udivdi3+0xe5>
  803c28:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803c2b:	31 ff                	xor    %edi,%edi
  803c2d:	e9 40 ff ff ff       	jmp    803b72 <__udivdi3+0x46>
  803c32:	66 90                	xchg   %ax,%ax
  803c34:	31 c0                	xor    %eax,%eax
  803c36:	e9 37 ff ff ff       	jmp    803b72 <__udivdi3+0x46>
  803c3b:	90                   	nop

00803c3c <__umoddi3>:
  803c3c:	55                   	push   %ebp
  803c3d:	57                   	push   %edi
  803c3e:	56                   	push   %esi
  803c3f:	53                   	push   %ebx
  803c40:	83 ec 1c             	sub    $0x1c,%esp
  803c43:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803c47:	8b 74 24 34          	mov    0x34(%esp),%esi
  803c4b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803c4f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803c53:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803c57:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803c5b:	89 f3                	mov    %esi,%ebx
  803c5d:	89 fa                	mov    %edi,%edx
  803c5f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c63:	89 34 24             	mov    %esi,(%esp)
  803c66:	85 c0                	test   %eax,%eax
  803c68:	75 1a                	jne    803c84 <__umoddi3+0x48>
  803c6a:	39 f7                	cmp    %esi,%edi
  803c6c:	0f 86 a2 00 00 00    	jbe    803d14 <__umoddi3+0xd8>
  803c72:	89 c8                	mov    %ecx,%eax
  803c74:	89 f2                	mov    %esi,%edx
  803c76:	f7 f7                	div    %edi
  803c78:	89 d0                	mov    %edx,%eax
  803c7a:	31 d2                	xor    %edx,%edx
  803c7c:	83 c4 1c             	add    $0x1c,%esp
  803c7f:	5b                   	pop    %ebx
  803c80:	5e                   	pop    %esi
  803c81:	5f                   	pop    %edi
  803c82:	5d                   	pop    %ebp
  803c83:	c3                   	ret    
  803c84:	39 f0                	cmp    %esi,%eax
  803c86:	0f 87 ac 00 00 00    	ja     803d38 <__umoddi3+0xfc>
  803c8c:	0f bd e8             	bsr    %eax,%ebp
  803c8f:	83 f5 1f             	xor    $0x1f,%ebp
  803c92:	0f 84 ac 00 00 00    	je     803d44 <__umoddi3+0x108>
  803c98:	bf 20 00 00 00       	mov    $0x20,%edi
  803c9d:	29 ef                	sub    %ebp,%edi
  803c9f:	89 fe                	mov    %edi,%esi
  803ca1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803ca5:	89 e9                	mov    %ebp,%ecx
  803ca7:	d3 e0                	shl    %cl,%eax
  803ca9:	89 d7                	mov    %edx,%edi
  803cab:	89 f1                	mov    %esi,%ecx
  803cad:	d3 ef                	shr    %cl,%edi
  803caf:	09 c7                	or     %eax,%edi
  803cb1:	89 e9                	mov    %ebp,%ecx
  803cb3:	d3 e2                	shl    %cl,%edx
  803cb5:	89 14 24             	mov    %edx,(%esp)
  803cb8:	89 d8                	mov    %ebx,%eax
  803cba:	d3 e0                	shl    %cl,%eax
  803cbc:	89 c2                	mov    %eax,%edx
  803cbe:	8b 44 24 08          	mov    0x8(%esp),%eax
  803cc2:	d3 e0                	shl    %cl,%eax
  803cc4:	89 44 24 04          	mov    %eax,0x4(%esp)
  803cc8:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ccc:	89 f1                	mov    %esi,%ecx
  803cce:	d3 e8                	shr    %cl,%eax
  803cd0:	09 d0                	or     %edx,%eax
  803cd2:	d3 eb                	shr    %cl,%ebx
  803cd4:	89 da                	mov    %ebx,%edx
  803cd6:	f7 f7                	div    %edi
  803cd8:	89 d3                	mov    %edx,%ebx
  803cda:	f7 24 24             	mull   (%esp)
  803cdd:	89 c6                	mov    %eax,%esi
  803cdf:	89 d1                	mov    %edx,%ecx
  803ce1:	39 d3                	cmp    %edx,%ebx
  803ce3:	0f 82 87 00 00 00    	jb     803d70 <__umoddi3+0x134>
  803ce9:	0f 84 91 00 00 00    	je     803d80 <__umoddi3+0x144>
  803cef:	8b 54 24 04          	mov    0x4(%esp),%edx
  803cf3:	29 f2                	sub    %esi,%edx
  803cf5:	19 cb                	sbb    %ecx,%ebx
  803cf7:	89 d8                	mov    %ebx,%eax
  803cf9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803cfd:	d3 e0                	shl    %cl,%eax
  803cff:	89 e9                	mov    %ebp,%ecx
  803d01:	d3 ea                	shr    %cl,%edx
  803d03:	09 d0                	or     %edx,%eax
  803d05:	89 e9                	mov    %ebp,%ecx
  803d07:	d3 eb                	shr    %cl,%ebx
  803d09:	89 da                	mov    %ebx,%edx
  803d0b:	83 c4 1c             	add    $0x1c,%esp
  803d0e:	5b                   	pop    %ebx
  803d0f:	5e                   	pop    %esi
  803d10:	5f                   	pop    %edi
  803d11:	5d                   	pop    %ebp
  803d12:	c3                   	ret    
  803d13:	90                   	nop
  803d14:	89 fd                	mov    %edi,%ebp
  803d16:	85 ff                	test   %edi,%edi
  803d18:	75 0b                	jne    803d25 <__umoddi3+0xe9>
  803d1a:	b8 01 00 00 00       	mov    $0x1,%eax
  803d1f:	31 d2                	xor    %edx,%edx
  803d21:	f7 f7                	div    %edi
  803d23:	89 c5                	mov    %eax,%ebp
  803d25:	89 f0                	mov    %esi,%eax
  803d27:	31 d2                	xor    %edx,%edx
  803d29:	f7 f5                	div    %ebp
  803d2b:	89 c8                	mov    %ecx,%eax
  803d2d:	f7 f5                	div    %ebp
  803d2f:	89 d0                	mov    %edx,%eax
  803d31:	e9 44 ff ff ff       	jmp    803c7a <__umoddi3+0x3e>
  803d36:	66 90                	xchg   %ax,%ax
  803d38:	89 c8                	mov    %ecx,%eax
  803d3a:	89 f2                	mov    %esi,%edx
  803d3c:	83 c4 1c             	add    $0x1c,%esp
  803d3f:	5b                   	pop    %ebx
  803d40:	5e                   	pop    %esi
  803d41:	5f                   	pop    %edi
  803d42:	5d                   	pop    %ebp
  803d43:	c3                   	ret    
  803d44:	3b 04 24             	cmp    (%esp),%eax
  803d47:	72 06                	jb     803d4f <__umoddi3+0x113>
  803d49:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803d4d:	77 0f                	ja     803d5e <__umoddi3+0x122>
  803d4f:	89 f2                	mov    %esi,%edx
  803d51:	29 f9                	sub    %edi,%ecx
  803d53:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803d57:	89 14 24             	mov    %edx,(%esp)
  803d5a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d5e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803d62:	8b 14 24             	mov    (%esp),%edx
  803d65:	83 c4 1c             	add    $0x1c,%esp
  803d68:	5b                   	pop    %ebx
  803d69:	5e                   	pop    %esi
  803d6a:	5f                   	pop    %edi
  803d6b:	5d                   	pop    %ebp
  803d6c:	c3                   	ret    
  803d6d:	8d 76 00             	lea    0x0(%esi),%esi
  803d70:	2b 04 24             	sub    (%esp),%eax
  803d73:	19 fa                	sbb    %edi,%edx
  803d75:	89 d1                	mov    %edx,%ecx
  803d77:	89 c6                	mov    %eax,%esi
  803d79:	e9 71 ff ff ff       	jmp    803cef <__umoddi3+0xb3>
  803d7e:	66 90                	xchg   %ax,%ax
  803d80:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803d84:	72 ea                	jb     803d70 <__umoddi3+0x134>
  803d86:	89 d9                	mov    %ebx,%ecx
  803d88:	e9 62 ff ff ff       	jmp    803cef <__umoddi3+0xb3>
