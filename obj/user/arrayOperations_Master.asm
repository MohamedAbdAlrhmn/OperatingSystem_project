
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
  800041:	e8 ed 20 00 00       	call   802133 <sys_disable_interrupt>
		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 80 3e 80 00       	push   $0x803e80
  80004e:	e8 fe 0a 00 00       	call   800b51 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 82 3e 80 00       	push   $0x803e82
  80005e:	e8 ee 0a 00 00       	call   800b51 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!   ARRAY OOERATIONS   !!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 a0 3e 80 00       	push   $0x803ea0
  80006e:	e8 de 0a 00 00       	call   800b51 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 82 3e 80 00       	push   $0x803e82
  80007e:	e8 ce 0a 00 00       	call   800b51 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 80 3e 80 00       	push   $0x803e80
  80008e:	e8 be 0a 00 00       	call   800b51 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp

		readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 45 82             	lea    -0x7e(%ebp),%eax
  80009c:	50                   	push   %eax
  80009d:	68 c0 3e 80 00       	push   $0x803ec0
  8000a2:	e8 2c 11 00 00       	call   8011d3 <readline>
  8000a7:	83 c4 10             	add    $0x10,%esp

		//Create the shared array & its size
		int *arrSize = smalloc("arrSize", sizeof(int) , 0) ;
  8000aa:	83 ec 04             	sub    $0x4,%esp
  8000ad:	6a 00                	push   $0x0
  8000af:	6a 04                	push   $0x4
  8000b1:	68 df 3e 80 00       	push   $0x803edf
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
  8000ef:	68 e7 3e 80 00       	push   $0x803ee7
  8000f4:	e8 7b 1c 00 00       	call   801d74 <smalloc>
  8000f9:	83 c4 10             	add    $0x10,%esp
  8000fc:	89 45 ec             	mov    %eax,-0x14(%ebp)

		cprintf("Chose the initialization method:\n") ;
  8000ff:	83 ec 0c             	sub    $0xc,%esp
  800102:	68 ec 3e 80 00       	push   $0x803eec
  800107:	e8 45 0a 00 00       	call   800b51 <cprintf>
  80010c:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  80010f:	83 ec 0c             	sub    $0xc,%esp
  800112:	68 0e 3f 80 00       	push   $0x803f0e
  800117:	e8 35 0a 00 00       	call   800b51 <cprintf>
  80011c:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  80011f:	83 ec 0c             	sub    $0xc,%esp
  800122:	68 1c 3f 80 00       	push   $0x803f1c
  800127:	e8 25 0a 00 00       	call   800b51 <cprintf>
  80012c:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  80012f:	83 ec 0c             	sub    $0xc,%esp
  800132:	68 2b 3f 80 00       	push   $0x803f2b
  800137:	e8 15 0a 00 00       	call   800b51 <cprintf>
  80013c:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80013f:	83 ec 0c             	sub    $0xc,%esp
  800142:	68 3b 3f 80 00       	push   $0x803f3b
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
  800186:	e8 c2 1f 00 00       	call   80214d <sys_enable_interrupt>

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
  8001f6:	68 44 3f 80 00       	push   $0x803f44
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
  800232:	68 52 3f 80 00       	push   $0x803f52
  800237:	e8 7c 20 00 00       	call   8022b8 <sys_create_env>
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
  800265:	68 5b 3f 80 00       	push   $0x803f5b
  80026a:	e8 49 20 00 00       	call   8022b8 <sys_create_env>
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
  800298:	68 64 3f 80 00       	push   $0x803f64
  80029d:	e8 16 20 00 00       	call   8022b8 <sys_create_env>
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
  8002bd:	68 70 3f 80 00       	push   $0x803f70
  8002c2:	6a 4b                	push   $0x4b
  8002c4:	68 85 3f 80 00       	push   $0x803f85
  8002c9:	e8 cf 05 00 00       	call   80089d <_panic>

	sys_run_env(envIdQuickSort);
  8002ce:	83 ec 0c             	sub    $0xc,%esp
  8002d1:	ff 75 dc             	pushl  -0x24(%ebp)
  8002d4:	e8 fd 1f 00 00       	call   8022d6 <sys_run_env>
  8002d9:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdMergeSort);
  8002dc:	83 ec 0c             	sub    $0xc,%esp
  8002df:	ff 75 d8             	pushl  -0x28(%ebp)
  8002e2:	e8 ef 1f 00 00       	call   8022d6 <sys_run_env>
  8002e7:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdStats);
  8002ea:	83 ec 0c             	sub    $0xc,%esp
  8002ed:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002f0:	e8 e1 1f 00 00       	call   8022d6 <sys_run_env>
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
  800337:	68 a3 3f 80 00       	push   $0x803fa3
  80033c:	ff 75 dc             	pushl  -0x24(%ebp)
  80033f:	e8 de 1a 00 00       	call   801e22 <sget>
  800344:	83 c4 10             	add    $0x10,%esp
  800347:	89 45 d0             	mov    %eax,-0x30(%ebp)
	mergesortedArr = sget(envIdMergeSort, "mergesortedArr") ;
  80034a:	83 ec 08             	sub    $0x8,%esp
  80034d:	68 b2 3f 80 00       	push   $0x803fb2
  800352:	ff 75 d8             	pushl  -0x28(%ebp)
  800355:	e8 c8 1a 00 00       	call   801e22 <sget>
  80035a:	83 c4 10             	add    $0x10,%esp
  80035d:	89 45 cc             	mov    %eax,-0x34(%ebp)
	mean = sget(envIdStats, "mean") ;
  800360:	83 ec 08             	sub    $0x8,%esp
  800363:	68 c1 3f 80 00       	push   $0x803fc1
  800368:	ff 75 d4             	pushl  -0x2c(%ebp)
  80036b:	e8 b2 1a 00 00       	call   801e22 <sget>
  800370:	83 c4 10             	add    $0x10,%esp
  800373:	89 45 c8             	mov    %eax,-0x38(%ebp)
	var = sget(envIdStats,"var") ;
  800376:	83 ec 08             	sub    $0x8,%esp
  800379:	68 c6 3f 80 00       	push   $0x803fc6
  80037e:	ff 75 d4             	pushl  -0x2c(%ebp)
  800381:	e8 9c 1a 00 00       	call   801e22 <sget>
  800386:	83 c4 10             	add    $0x10,%esp
  800389:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	min = sget(envIdStats,"min") ;
  80038c:	83 ec 08             	sub    $0x8,%esp
  80038f:	68 ca 3f 80 00       	push   $0x803fca
  800394:	ff 75 d4             	pushl  -0x2c(%ebp)
  800397:	e8 86 1a 00 00       	call   801e22 <sget>
  80039c:	83 c4 10             	add    $0x10,%esp
  80039f:	89 45 c0             	mov    %eax,-0x40(%ebp)
	max = sget(envIdStats,"max") ;
  8003a2:	83 ec 08             	sub    $0x8,%esp
  8003a5:	68 ce 3f 80 00       	push   $0x803fce
  8003aa:	ff 75 d4             	pushl  -0x2c(%ebp)
  8003ad:	e8 70 1a 00 00       	call   801e22 <sget>
  8003b2:	83 c4 10             	add    $0x10,%esp
  8003b5:	89 45 bc             	mov    %eax,-0x44(%ebp)
	med = sget(envIdStats,"med") ;
  8003b8:	83 ec 08             	sub    $0x8,%esp
  8003bb:	68 d2 3f 80 00       	push   $0x803fd2
  8003c0:	ff 75 d4             	pushl  -0x2c(%ebp)
  8003c3:	e8 5a 1a 00 00       	call   801e22 <sget>
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
  8003eb:	68 d8 3f 80 00       	push   $0x803fd8
  8003f0:	6a 66                	push   $0x66
  8003f2:	68 85 3f 80 00       	push   $0x803f85
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
  800419:	68 00 40 80 00       	push   $0x804000
  80041e:	6a 68                	push   $0x68
  800420:	68 85 3f 80 00       	push   $0x803f85
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
  8004cc:	68 28 40 80 00       	push   $0x804028
  8004d1:	6a 75                	push   $0x75
  8004d3:	68 85 3f 80 00       	push   $0x803f85
  8004d8:	e8 c0 03 00 00       	call   80089d <_panic>

	cprintf("Congratulations!! Scenario of Using the Shared Variables [Create & Get] completed successfully!!\n\n\n");
  8004dd:	83 ec 0c             	sub    $0xc,%esp
  8004e0:	68 58 40 80 00       	push   $0x804058
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
  8006d5:	e8 8d 1a 00 00       	call   802167 <sys_cputc>
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
  8006e6:	e8 48 1a 00 00       	call   802133 <sys_disable_interrupt>
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
  8006f9:	e8 69 1a 00 00       	call   802167 <sys_cputc>
  8006fe:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800701:	e8 47 1a 00 00       	call   80214d <sys_enable_interrupt>
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
  800718:	e8 91 18 00 00       	call   801fae <sys_cgetc>
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
  800731:	e8 fd 19 00 00       	call   802133 <sys_disable_interrupt>
	int c=0;
  800736:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  80073d:	eb 08                	jmp    800747 <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  80073f:	e8 6a 18 00 00       	call   801fae <sys_cgetc>
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
  80074d:	e8 fb 19 00 00       	call   80214d <sys_enable_interrupt>
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
  800767:	e8 ba 1b 00 00       	call   802326 <sys_getenvindex>
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
  8007d2:	e8 5c 19 00 00       	call   802133 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8007d7:	83 ec 0c             	sub    $0xc,%esp
  8007da:	68 d4 40 80 00       	push   $0x8040d4
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
  800802:	68 fc 40 80 00       	push   $0x8040fc
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
  800833:	68 24 41 80 00       	push   $0x804124
  800838:	e8 14 03 00 00       	call   800b51 <cprintf>
  80083d:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800840:	a1 20 50 80 00       	mov    0x805020,%eax
  800845:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80084b:	83 ec 08             	sub    $0x8,%esp
  80084e:	50                   	push   %eax
  80084f:	68 7c 41 80 00       	push   $0x80417c
  800854:	e8 f8 02 00 00       	call   800b51 <cprintf>
  800859:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80085c:	83 ec 0c             	sub    $0xc,%esp
  80085f:	68 d4 40 80 00       	push   $0x8040d4
  800864:	e8 e8 02 00 00       	call   800b51 <cprintf>
  800869:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80086c:	e8 dc 18 00 00       	call   80214d <sys_enable_interrupt>

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
  800884:	e8 69 1a 00 00       	call   8022f2 <sys_destroy_env>
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
  800895:	e8 be 1a 00 00       	call   802358 <sys_exit_env>
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
  8008be:	68 90 41 80 00       	push   $0x804190
  8008c3:	e8 89 02 00 00       	call   800b51 <cprintf>
  8008c8:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8008cb:	a1 00 50 80 00       	mov    0x805000,%eax
  8008d0:	ff 75 0c             	pushl  0xc(%ebp)
  8008d3:	ff 75 08             	pushl  0x8(%ebp)
  8008d6:	50                   	push   %eax
  8008d7:	68 95 41 80 00       	push   $0x804195
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
  8008fb:	68 b1 41 80 00       	push   $0x8041b1
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
  800927:	68 b4 41 80 00       	push   $0x8041b4
  80092c:	6a 26                	push   $0x26
  80092e:	68 00 42 80 00       	push   $0x804200
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
  8009f9:	68 0c 42 80 00       	push   $0x80420c
  8009fe:	6a 3a                	push   $0x3a
  800a00:	68 00 42 80 00       	push   $0x804200
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
  800a69:	68 60 42 80 00       	push   $0x804260
  800a6e:	6a 44                	push   $0x44
  800a70:	68 00 42 80 00       	push   $0x804200
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
  800ac3:	e8 bd 14 00 00       	call   801f85 <sys_cputs>
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
  800b3a:	e8 46 14 00 00       	call   801f85 <sys_cputs>
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
  800b84:	e8 aa 15 00 00       	call   802133 <sys_disable_interrupt>
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
  800ba4:	e8 a4 15 00 00       	call   80214d <sys_enable_interrupt>
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
  800bee:	e8 15 30 00 00       	call   803c08 <__udivdi3>
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
  800c3e:	e8 d5 30 00 00       	call   803d18 <__umoddi3>
  800c43:	83 c4 10             	add    $0x10,%esp
  800c46:	05 d4 44 80 00       	add    $0x8044d4,%eax
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
  800d99:	8b 04 85 f8 44 80 00 	mov    0x8044f8(,%eax,4),%eax
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
  800e7a:	8b 34 9d 40 43 80 00 	mov    0x804340(,%ebx,4),%esi
  800e81:	85 f6                	test   %esi,%esi
  800e83:	75 19                	jne    800e9e <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800e85:	53                   	push   %ebx
  800e86:	68 e5 44 80 00       	push   $0x8044e5
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
  800e9f:	68 ee 44 80 00       	push   $0x8044ee
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
  800ecc:	be f1 44 80 00       	mov    $0x8044f1,%esi
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
  8011e5:	68 50 46 80 00       	push   $0x804650
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
  801227:	68 53 46 80 00       	push   $0x804653
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
  8012d7:	e8 57 0e 00 00       	call   802133 <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  8012dc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012e0:	74 13                	je     8012f5 <atomic_readline+0x24>
		cprintf("%s", prompt);
  8012e2:	83 ec 08             	sub    $0x8,%esp
  8012e5:	ff 75 08             	pushl  0x8(%ebp)
  8012e8:	68 50 46 80 00       	push   $0x804650
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
  801326:	68 53 46 80 00       	push   $0x804653
  80132b:	e8 21 f8 ff ff       	call   800b51 <cprintf>
  801330:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  801333:	e8 15 0e 00 00       	call   80214d <sys_enable_interrupt>
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
  8013cb:	e8 7d 0d 00 00       	call   80214d <sys_enable_interrupt>
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
  801af8:	68 64 46 80 00       	push   $0x804664
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
  801bc8:	e8 fc 04 00 00       	call   8020c9 <sys_allocate_chunk>
  801bcd:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801bd0:	a1 20 51 80 00       	mov    0x805120,%eax
  801bd5:	83 ec 0c             	sub    $0xc,%esp
  801bd8:	50                   	push   %eax
  801bd9:	e8 71 0b 00 00       	call   80274f <initialize_MemBlocksList>
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
  801c06:	68 89 46 80 00       	push   $0x804689
  801c0b:	6a 33                	push   $0x33
  801c0d:	68 a7 46 80 00       	push   $0x8046a7
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
  801c85:	68 b4 46 80 00       	push   $0x8046b4
  801c8a:	6a 34                	push   $0x34
  801c8c:	68 a7 46 80 00       	push   $0x8046a7
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
  801d1d:	e8 75 07 00 00       	call   802497 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801d22:	85 c0                	test   %eax,%eax
  801d24:	74 11                	je     801d37 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801d26:	83 ec 0c             	sub    $0xc,%esp
  801d29:	ff 75 e8             	pushl  -0x18(%ebp)
  801d2c:	e8 e0 0d 00 00       	call   802b11 <alloc_block_FF>
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
  801d43:	e8 3c 0b 00 00       	call   802884 <insert_sorted_allocList>
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
  801d63:	68 d8 46 80 00       	push   $0x8046d8
  801d68:	6a 6f                	push   $0x6f
  801d6a:	68 a7 46 80 00       	push   $0x8046a7
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
  801d89:	75 0a                	jne    801d95 <smalloc+0x21>
  801d8b:	b8 00 00 00 00       	mov    $0x0,%eax
  801d90:	e9 8b 00 00 00       	jmp    801e20 <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801d95:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801d9c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801da2:	01 d0                	add    %edx,%eax
  801da4:	48                   	dec    %eax
  801da5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801da8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801dab:	ba 00 00 00 00       	mov    $0x0,%edx
  801db0:	f7 75 f0             	divl   -0x10(%ebp)
  801db3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801db6:	29 d0                	sub    %edx,%eax
  801db8:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801dbb:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801dc2:	e8 d0 06 00 00       	call   802497 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801dc7:	85 c0                	test   %eax,%eax
  801dc9:	74 11                	je     801ddc <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  801dcb:	83 ec 0c             	sub    $0xc,%esp
  801dce:	ff 75 e8             	pushl  -0x18(%ebp)
  801dd1:	e8 3b 0d 00 00       	call   802b11 <alloc_block_FF>
  801dd6:	83 c4 10             	add    $0x10,%esp
  801dd9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  801ddc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801de0:	74 39                	je     801e1b <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801de2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801de5:	8b 40 08             	mov    0x8(%eax),%eax
  801de8:	89 c2                	mov    %eax,%edx
  801dea:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801dee:	52                   	push   %edx
  801def:	50                   	push   %eax
  801df0:	ff 75 0c             	pushl  0xc(%ebp)
  801df3:	ff 75 08             	pushl  0x8(%ebp)
  801df6:	e8 21 04 00 00       	call   80221c <sys_createSharedObject>
  801dfb:	83 c4 10             	add    $0x10,%esp
  801dfe:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  801e01:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  801e05:	74 14                	je     801e1b <smalloc+0xa7>
  801e07:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  801e0b:	74 0e                	je     801e1b <smalloc+0xa7>
  801e0d:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  801e11:	74 08                	je     801e1b <smalloc+0xa7>
			return (void*) mem_block->sva;
  801e13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e16:	8b 40 08             	mov    0x8(%eax),%eax
  801e19:	eb 05                	jmp    801e20 <smalloc+0xac>
	}
	return NULL;
  801e1b:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801e20:	c9                   	leave  
  801e21:	c3                   	ret    

00801e22 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801e22:	55                   	push   %ebp
  801e23:	89 e5                	mov    %esp,%ebp
  801e25:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e28:	e8 b4 fc ff ff       	call   801ae1 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801e2d:	83 ec 08             	sub    $0x8,%esp
  801e30:	ff 75 0c             	pushl  0xc(%ebp)
  801e33:	ff 75 08             	pushl  0x8(%ebp)
  801e36:	e8 0b 04 00 00       	call   802246 <sys_getSizeOfSharedObject>
  801e3b:	83 c4 10             	add    $0x10,%esp
  801e3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  801e41:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  801e45:	74 76                	je     801ebd <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801e47:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801e4e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e51:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e54:	01 d0                	add    %edx,%eax
  801e56:	48                   	dec    %eax
  801e57:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801e5a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e5d:	ba 00 00 00 00       	mov    $0x0,%edx
  801e62:	f7 75 ec             	divl   -0x14(%ebp)
  801e65:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e68:	29 d0                	sub    %edx,%eax
  801e6a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  801e6d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801e74:	e8 1e 06 00 00       	call   802497 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801e79:	85 c0                	test   %eax,%eax
  801e7b:	74 11                	je     801e8e <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  801e7d:	83 ec 0c             	sub    $0xc,%esp
  801e80:	ff 75 e4             	pushl  -0x1c(%ebp)
  801e83:	e8 89 0c 00 00       	call   802b11 <alloc_block_FF>
  801e88:	83 c4 10             	add    $0x10,%esp
  801e8b:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  801e8e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e92:	74 29                	je     801ebd <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  801e94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e97:	8b 40 08             	mov    0x8(%eax),%eax
  801e9a:	83 ec 04             	sub    $0x4,%esp
  801e9d:	50                   	push   %eax
  801e9e:	ff 75 0c             	pushl  0xc(%ebp)
  801ea1:	ff 75 08             	pushl  0x8(%ebp)
  801ea4:	e8 ba 03 00 00       	call   802263 <sys_getSharedObject>
  801ea9:	83 c4 10             	add    $0x10,%esp
  801eac:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  801eaf:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  801eb3:	74 08                	je     801ebd <sget+0x9b>
				return (void *)mem_block->sva;
  801eb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb8:	8b 40 08             	mov    0x8(%eax),%eax
  801ebb:	eb 05                	jmp    801ec2 <sget+0xa0>
		}
	}
	return NULL;
  801ebd:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801ec2:	c9                   	leave  
  801ec3:	c3                   	ret    

00801ec4 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801ec4:	55                   	push   %ebp
  801ec5:	89 e5                	mov    %esp,%ebp
  801ec7:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801eca:	e8 12 fc ff ff       	call   801ae1 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801ecf:	83 ec 04             	sub    $0x4,%esp
  801ed2:	68 fc 46 80 00       	push   $0x8046fc
  801ed7:	68 f1 00 00 00       	push   $0xf1
  801edc:	68 a7 46 80 00       	push   $0x8046a7
  801ee1:	e8 b7 e9 ff ff       	call   80089d <_panic>

00801ee6 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801ee6:	55                   	push   %ebp
  801ee7:	89 e5                	mov    %esp,%ebp
  801ee9:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801eec:	83 ec 04             	sub    $0x4,%esp
  801eef:	68 24 47 80 00       	push   $0x804724
  801ef4:	68 05 01 00 00       	push   $0x105
  801ef9:	68 a7 46 80 00       	push   $0x8046a7
  801efe:	e8 9a e9 ff ff       	call   80089d <_panic>

00801f03 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801f03:	55                   	push   %ebp
  801f04:	89 e5                	mov    %esp,%ebp
  801f06:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801f09:	83 ec 04             	sub    $0x4,%esp
  801f0c:	68 48 47 80 00       	push   $0x804748
  801f11:	68 10 01 00 00       	push   $0x110
  801f16:	68 a7 46 80 00       	push   $0x8046a7
  801f1b:	e8 7d e9 ff ff       	call   80089d <_panic>

00801f20 <shrink>:

}
void shrink(uint32 newSize)
{
  801f20:	55                   	push   %ebp
  801f21:	89 e5                	mov    %esp,%ebp
  801f23:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801f26:	83 ec 04             	sub    $0x4,%esp
  801f29:	68 48 47 80 00       	push   $0x804748
  801f2e:	68 15 01 00 00       	push   $0x115
  801f33:	68 a7 46 80 00       	push   $0x8046a7
  801f38:	e8 60 e9 ff ff       	call   80089d <_panic>

00801f3d <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801f3d:	55                   	push   %ebp
  801f3e:	89 e5                	mov    %esp,%ebp
  801f40:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801f43:	83 ec 04             	sub    $0x4,%esp
  801f46:	68 48 47 80 00       	push   $0x804748
  801f4b:	68 1a 01 00 00       	push   $0x11a
  801f50:	68 a7 46 80 00       	push   $0x8046a7
  801f55:	e8 43 e9 ff ff       	call   80089d <_panic>

00801f5a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801f5a:	55                   	push   %ebp
  801f5b:	89 e5                	mov    %esp,%ebp
  801f5d:	57                   	push   %edi
  801f5e:	56                   	push   %esi
  801f5f:	53                   	push   %ebx
  801f60:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801f63:	8b 45 08             	mov    0x8(%ebp),%eax
  801f66:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f69:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f6c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f6f:	8b 7d 18             	mov    0x18(%ebp),%edi
  801f72:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801f75:	cd 30                	int    $0x30
  801f77:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801f7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801f7d:	83 c4 10             	add    $0x10,%esp
  801f80:	5b                   	pop    %ebx
  801f81:	5e                   	pop    %esi
  801f82:	5f                   	pop    %edi
  801f83:	5d                   	pop    %ebp
  801f84:	c3                   	ret    

00801f85 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801f85:	55                   	push   %ebp
  801f86:	89 e5                	mov    %esp,%ebp
  801f88:	83 ec 04             	sub    $0x4,%esp
  801f8b:	8b 45 10             	mov    0x10(%ebp),%eax
  801f8e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801f91:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f95:	8b 45 08             	mov    0x8(%ebp),%eax
  801f98:	6a 00                	push   $0x0
  801f9a:	6a 00                	push   $0x0
  801f9c:	52                   	push   %edx
  801f9d:	ff 75 0c             	pushl  0xc(%ebp)
  801fa0:	50                   	push   %eax
  801fa1:	6a 00                	push   $0x0
  801fa3:	e8 b2 ff ff ff       	call   801f5a <syscall>
  801fa8:	83 c4 18             	add    $0x18,%esp
}
  801fab:	90                   	nop
  801fac:	c9                   	leave  
  801fad:	c3                   	ret    

00801fae <sys_cgetc>:

int
sys_cgetc(void)
{
  801fae:	55                   	push   %ebp
  801faf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801fb1:	6a 00                	push   $0x0
  801fb3:	6a 00                	push   $0x0
  801fb5:	6a 00                	push   $0x0
  801fb7:	6a 00                	push   $0x0
  801fb9:	6a 00                	push   $0x0
  801fbb:	6a 01                	push   $0x1
  801fbd:	e8 98 ff ff ff       	call   801f5a <syscall>
  801fc2:	83 c4 18             	add    $0x18,%esp
}
  801fc5:	c9                   	leave  
  801fc6:	c3                   	ret    

00801fc7 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801fc7:	55                   	push   %ebp
  801fc8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801fca:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fcd:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd0:	6a 00                	push   $0x0
  801fd2:	6a 00                	push   $0x0
  801fd4:	6a 00                	push   $0x0
  801fd6:	52                   	push   %edx
  801fd7:	50                   	push   %eax
  801fd8:	6a 05                	push   $0x5
  801fda:	e8 7b ff ff ff       	call   801f5a <syscall>
  801fdf:	83 c4 18             	add    $0x18,%esp
}
  801fe2:	c9                   	leave  
  801fe3:	c3                   	ret    

00801fe4 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801fe4:	55                   	push   %ebp
  801fe5:	89 e5                	mov    %esp,%ebp
  801fe7:	56                   	push   %esi
  801fe8:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801fe9:	8b 75 18             	mov    0x18(%ebp),%esi
  801fec:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801fef:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ff2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ff5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff8:	56                   	push   %esi
  801ff9:	53                   	push   %ebx
  801ffa:	51                   	push   %ecx
  801ffb:	52                   	push   %edx
  801ffc:	50                   	push   %eax
  801ffd:	6a 06                	push   $0x6
  801fff:	e8 56 ff ff ff       	call   801f5a <syscall>
  802004:	83 c4 18             	add    $0x18,%esp
}
  802007:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80200a:	5b                   	pop    %ebx
  80200b:	5e                   	pop    %esi
  80200c:	5d                   	pop    %ebp
  80200d:	c3                   	ret    

0080200e <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80200e:	55                   	push   %ebp
  80200f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802011:	8b 55 0c             	mov    0xc(%ebp),%edx
  802014:	8b 45 08             	mov    0x8(%ebp),%eax
  802017:	6a 00                	push   $0x0
  802019:	6a 00                	push   $0x0
  80201b:	6a 00                	push   $0x0
  80201d:	52                   	push   %edx
  80201e:	50                   	push   %eax
  80201f:	6a 07                	push   $0x7
  802021:	e8 34 ff ff ff       	call   801f5a <syscall>
  802026:	83 c4 18             	add    $0x18,%esp
}
  802029:	c9                   	leave  
  80202a:	c3                   	ret    

0080202b <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80202b:	55                   	push   %ebp
  80202c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80202e:	6a 00                	push   $0x0
  802030:	6a 00                	push   $0x0
  802032:	6a 00                	push   $0x0
  802034:	ff 75 0c             	pushl  0xc(%ebp)
  802037:	ff 75 08             	pushl  0x8(%ebp)
  80203a:	6a 08                	push   $0x8
  80203c:	e8 19 ff ff ff       	call   801f5a <syscall>
  802041:	83 c4 18             	add    $0x18,%esp
}
  802044:	c9                   	leave  
  802045:	c3                   	ret    

00802046 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802046:	55                   	push   %ebp
  802047:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802049:	6a 00                	push   $0x0
  80204b:	6a 00                	push   $0x0
  80204d:	6a 00                	push   $0x0
  80204f:	6a 00                	push   $0x0
  802051:	6a 00                	push   $0x0
  802053:	6a 09                	push   $0x9
  802055:	e8 00 ff ff ff       	call   801f5a <syscall>
  80205a:	83 c4 18             	add    $0x18,%esp
}
  80205d:	c9                   	leave  
  80205e:	c3                   	ret    

0080205f <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80205f:	55                   	push   %ebp
  802060:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802062:	6a 00                	push   $0x0
  802064:	6a 00                	push   $0x0
  802066:	6a 00                	push   $0x0
  802068:	6a 00                	push   $0x0
  80206a:	6a 00                	push   $0x0
  80206c:	6a 0a                	push   $0xa
  80206e:	e8 e7 fe ff ff       	call   801f5a <syscall>
  802073:	83 c4 18             	add    $0x18,%esp
}
  802076:	c9                   	leave  
  802077:	c3                   	ret    

00802078 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802078:	55                   	push   %ebp
  802079:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80207b:	6a 00                	push   $0x0
  80207d:	6a 00                	push   $0x0
  80207f:	6a 00                	push   $0x0
  802081:	6a 00                	push   $0x0
  802083:	6a 00                	push   $0x0
  802085:	6a 0b                	push   $0xb
  802087:	e8 ce fe ff ff       	call   801f5a <syscall>
  80208c:	83 c4 18             	add    $0x18,%esp
}
  80208f:	c9                   	leave  
  802090:	c3                   	ret    

00802091 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802091:	55                   	push   %ebp
  802092:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802094:	6a 00                	push   $0x0
  802096:	6a 00                	push   $0x0
  802098:	6a 00                	push   $0x0
  80209a:	ff 75 0c             	pushl  0xc(%ebp)
  80209d:	ff 75 08             	pushl  0x8(%ebp)
  8020a0:	6a 0f                	push   $0xf
  8020a2:	e8 b3 fe ff ff       	call   801f5a <syscall>
  8020a7:	83 c4 18             	add    $0x18,%esp
	return;
  8020aa:	90                   	nop
}
  8020ab:	c9                   	leave  
  8020ac:	c3                   	ret    

008020ad <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8020ad:	55                   	push   %ebp
  8020ae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8020b0:	6a 00                	push   $0x0
  8020b2:	6a 00                	push   $0x0
  8020b4:	6a 00                	push   $0x0
  8020b6:	ff 75 0c             	pushl  0xc(%ebp)
  8020b9:	ff 75 08             	pushl  0x8(%ebp)
  8020bc:	6a 10                	push   $0x10
  8020be:	e8 97 fe ff ff       	call   801f5a <syscall>
  8020c3:	83 c4 18             	add    $0x18,%esp
	return ;
  8020c6:	90                   	nop
}
  8020c7:	c9                   	leave  
  8020c8:	c3                   	ret    

008020c9 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8020c9:	55                   	push   %ebp
  8020ca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8020cc:	6a 00                	push   $0x0
  8020ce:	6a 00                	push   $0x0
  8020d0:	ff 75 10             	pushl  0x10(%ebp)
  8020d3:	ff 75 0c             	pushl  0xc(%ebp)
  8020d6:	ff 75 08             	pushl  0x8(%ebp)
  8020d9:	6a 11                	push   $0x11
  8020db:	e8 7a fe ff ff       	call   801f5a <syscall>
  8020e0:	83 c4 18             	add    $0x18,%esp
	return ;
  8020e3:	90                   	nop
}
  8020e4:	c9                   	leave  
  8020e5:	c3                   	ret    

008020e6 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8020e6:	55                   	push   %ebp
  8020e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8020e9:	6a 00                	push   $0x0
  8020eb:	6a 00                	push   $0x0
  8020ed:	6a 00                	push   $0x0
  8020ef:	6a 00                	push   $0x0
  8020f1:	6a 00                	push   $0x0
  8020f3:	6a 0c                	push   $0xc
  8020f5:	e8 60 fe ff ff       	call   801f5a <syscall>
  8020fa:	83 c4 18             	add    $0x18,%esp
}
  8020fd:	c9                   	leave  
  8020fe:	c3                   	ret    

008020ff <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8020ff:	55                   	push   %ebp
  802100:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802102:	6a 00                	push   $0x0
  802104:	6a 00                	push   $0x0
  802106:	6a 00                	push   $0x0
  802108:	6a 00                	push   $0x0
  80210a:	ff 75 08             	pushl  0x8(%ebp)
  80210d:	6a 0d                	push   $0xd
  80210f:	e8 46 fe ff ff       	call   801f5a <syscall>
  802114:	83 c4 18             	add    $0x18,%esp
}
  802117:	c9                   	leave  
  802118:	c3                   	ret    

00802119 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802119:	55                   	push   %ebp
  80211a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80211c:	6a 00                	push   $0x0
  80211e:	6a 00                	push   $0x0
  802120:	6a 00                	push   $0x0
  802122:	6a 00                	push   $0x0
  802124:	6a 00                	push   $0x0
  802126:	6a 0e                	push   $0xe
  802128:	e8 2d fe ff ff       	call   801f5a <syscall>
  80212d:	83 c4 18             	add    $0x18,%esp
}
  802130:	90                   	nop
  802131:	c9                   	leave  
  802132:	c3                   	ret    

00802133 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802133:	55                   	push   %ebp
  802134:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802136:	6a 00                	push   $0x0
  802138:	6a 00                	push   $0x0
  80213a:	6a 00                	push   $0x0
  80213c:	6a 00                	push   $0x0
  80213e:	6a 00                	push   $0x0
  802140:	6a 13                	push   $0x13
  802142:	e8 13 fe ff ff       	call   801f5a <syscall>
  802147:	83 c4 18             	add    $0x18,%esp
}
  80214a:	90                   	nop
  80214b:	c9                   	leave  
  80214c:	c3                   	ret    

0080214d <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80214d:	55                   	push   %ebp
  80214e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802150:	6a 00                	push   $0x0
  802152:	6a 00                	push   $0x0
  802154:	6a 00                	push   $0x0
  802156:	6a 00                	push   $0x0
  802158:	6a 00                	push   $0x0
  80215a:	6a 14                	push   $0x14
  80215c:	e8 f9 fd ff ff       	call   801f5a <syscall>
  802161:	83 c4 18             	add    $0x18,%esp
}
  802164:	90                   	nop
  802165:	c9                   	leave  
  802166:	c3                   	ret    

00802167 <sys_cputc>:


void
sys_cputc(const char c)
{
  802167:	55                   	push   %ebp
  802168:	89 e5                	mov    %esp,%ebp
  80216a:	83 ec 04             	sub    $0x4,%esp
  80216d:	8b 45 08             	mov    0x8(%ebp),%eax
  802170:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802173:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802177:	6a 00                	push   $0x0
  802179:	6a 00                	push   $0x0
  80217b:	6a 00                	push   $0x0
  80217d:	6a 00                	push   $0x0
  80217f:	50                   	push   %eax
  802180:	6a 15                	push   $0x15
  802182:	e8 d3 fd ff ff       	call   801f5a <syscall>
  802187:	83 c4 18             	add    $0x18,%esp
}
  80218a:	90                   	nop
  80218b:	c9                   	leave  
  80218c:	c3                   	ret    

0080218d <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80218d:	55                   	push   %ebp
  80218e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802190:	6a 00                	push   $0x0
  802192:	6a 00                	push   $0x0
  802194:	6a 00                	push   $0x0
  802196:	6a 00                	push   $0x0
  802198:	6a 00                	push   $0x0
  80219a:	6a 16                	push   $0x16
  80219c:	e8 b9 fd ff ff       	call   801f5a <syscall>
  8021a1:	83 c4 18             	add    $0x18,%esp
}
  8021a4:	90                   	nop
  8021a5:	c9                   	leave  
  8021a6:	c3                   	ret    

008021a7 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8021a7:	55                   	push   %ebp
  8021a8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8021aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ad:	6a 00                	push   $0x0
  8021af:	6a 00                	push   $0x0
  8021b1:	6a 00                	push   $0x0
  8021b3:	ff 75 0c             	pushl  0xc(%ebp)
  8021b6:	50                   	push   %eax
  8021b7:	6a 17                	push   $0x17
  8021b9:	e8 9c fd ff ff       	call   801f5a <syscall>
  8021be:	83 c4 18             	add    $0x18,%esp
}
  8021c1:	c9                   	leave  
  8021c2:	c3                   	ret    

008021c3 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8021c3:	55                   	push   %ebp
  8021c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8021c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021cc:	6a 00                	push   $0x0
  8021ce:	6a 00                	push   $0x0
  8021d0:	6a 00                	push   $0x0
  8021d2:	52                   	push   %edx
  8021d3:	50                   	push   %eax
  8021d4:	6a 1a                	push   $0x1a
  8021d6:	e8 7f fd ff ff       	call   801f5a <syscall>
  8021db:	83 c4 18             	add    $0x18,%esp
}
  8021de:	c9                   	leave  
  8021df:	c3                   	ret    

008021e0 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8021e0:	55                   	push   %ebp
  8021e1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8021e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e9:	6a 00                	push   $0x0
  8021eb:	6a 00                	push   $0x0
  8021ed:	6a 00                	push   $0x0
  8021ef:	52                   	push   %edx
  8021f0:	50                   	push   %eax
  8021f1:	6a 18                	push   $0x18
  8021f3:	e8 62 fd ff ff       	call   801f5a <syscall>
  8021f8:	83 c4 18             	add    $0x18,%esp
}
  8021fb:	90                   	nop
  8021fc:	c9                   	leave  
  8021fd:	c3                   	ret    

008021fe <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8021fe:	55                   	push   %ebp
  8021ff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802201:	8b 55 0c             	mov    0xc(%ebp),%edx
  802204:	8b 45 08             	mov    0x8(%ebp),%eax
  802207:	6a 00                	push   $0x0
  802209:	6a 00                	push   $0x0
  80220b:	6a 00                	push   $0x0
  80220d:	52                   	push   %edx
  80220e:	50                   	push   %eax
  80220f:	6a 19                	push   $0x19
  802211:	e8 44 fd ff ff       	call   801f5a <syscall>
  802216:	83 c4 18             	add    $0x18,%esp
}
  802219:	90                   	nop
  80221a:	c9                   	leave  
  80221b:	c3                   	ret    

0080221c <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80221c:	55                   	push   %ebp
  80221d:	89 e5                	mov    %esp,%ebp
  80221f:	83 ec 04             	sub    $0x4,%esp
  802222:	8b 45 10             	mov    0x10(%ebp),%eax
  802225:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802228:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80222b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80222f:	8b 45 08             	mov    0x8(%ebp),%eax
  802232:	6a 00                	push   $0x0
  802234:	51                   	push   %ecx
  802235:	52                   	push   %edx
  802236:	ff 75 0c             	pushl  0xc(%ebp)
  802239:	50                   	push   %eax
  80223a:	6a 1b                	push   $0x1b
  80223c:	e8 19 fd ff ff       	call   801f5a <syscall>
  802241:	83 c4 18             	add    $0x18,%esp
}
  802244:	c9                   	leave  
  802245:	c3                   	ret    

00802246 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802246:	55                   	push   %ebp
  802247:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802249:	8b 55 0c             	mov    0xc(%ebp),%edx
  80224c:	8b 45 08             	mov    0x8(%ebp),%eax
  80224f:	6a 00                	push   $0x0
  802251:	6a 00                	push   $0x0
  802253:	6a 00                	push   $0x0
  802255:	52                   	push   %edx
  802256:	50                   	push   %eax
  802257:	6a 1c                	push   $0x1c
  802259:	e8 fc fc ff ff       	call   801f5a <syscall>
  80225e:	83 c4 18             	add    $0x18,%esp
}
  802261:	c9                   	leave  
  802262:	c3                   	ret    

00802263 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802263:	55                   	push   %ebp
  802264:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802266:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802269:	8b 55 0c             	mov    0xc(%ebp),%edx
  80226c:	8b 45 08             	mov    0x8(%ebp),%eax
  80226f:	6a 00                	push   $0x0
  802271:	6a 00                	push   $0x0
  802273:	51                   	push   %ecx
  802274:	52                   	push   %edx
  802275:	50                   	push   %eax
  802276:	6a 1d                	push   $0x1d
  802278:	e8 dd fc ff ff       	call   801f5a <syscall>
  80227d:	83 c4 18             	add    $0x18,%esp
}
  802280:	c9                   	leave  
  802281:	c3                   	ret    

00802282 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802282:	55                   	push   %ebp
  802283:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802285:	8b 55 0c             	mov    0xc(%ebp),%edx
  802288:	8b 45 08             	mov    0x8(%ebp),%eax
  80228b:	6a 00                	push   $0x0
  80228d:	6a 00                	push   $0x0
  80228f:	6a 00                	push   $0x0
  802291:	52                   	push   %edx
  802292:	50                   	push   %eax
  802293:	6a 1e                	push   $0x1e
  802295:	e8 c0 fc ff ff       	call   801f5a <syscall>
  80229a:	83 c4 18             	add    $0x18,%esp
}
  80229d:	c9                   	leave  
  80229e:	c3                   	ret    

0080229f <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80229f:	55                   	push   %ebp
  8022a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8022a2:	6a 00                	push   $0x0
  8022a4:	6a 00                	push   $0x0
  8022a6:	6a 00                	push   $0x0
  8022a8:	6a 00                	push   $0x0
  8022aa:	6a 00                	push   $0x0
  8022ac:	6a 1f                	push   $0x1f
  8022ae:	e8 a7 fc ff ff       	call   801f5a <syscall>
  8022b3:	83 c4 18             	add    $0x18,%esp
}
  8022b6:	c9                   	leave  
  8022b7:	c3                   	ret    

008022b8 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8022b8:	55                   	push   %ebp
  8022b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8022bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022be:	6a 00                	push   $0x0
  8022c0:	ff 75 14             	pushl  0x14(%ebp)
  8022c3:	ff 75 10             	pushl  0x10(%ebp)
  8022c6:	ff 75 0c             	pushl  0xc(%ebp)
  8022c9:	50                   	push   %eax
  8022ca:	6a 20                	push   $0x20
  8022cc:	e8 89 fc ff ff       	call   801f5a <syscall>
  8022d1:	83 c4 18             	add    $0x18,%esp
}
  8022d4:	c9                   	leave  
  8022d5:	c3                   	ret    

008022d6 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8022d6:	55                   	push   %ebp
  8022d7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8022d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022dc:	6a 00                	push   $0x0
  8022de:	6a 00                	push   $0x0
  8022e0:	6a 00                	push   $0x0
  8022e2:	6a 00                	push   $0x0
  8022e4:	50                   	push   %eax
  8022e5:	6a 21                	push   $0x21
  8022e7:	e8 6e fc ff ff       	call   801f5a <syscall>
  8022ec:	83 c4 18             	add    $0x18,%esp
}
  8022ef:	90                   	nop
  8022f0:	c9                   	leave  
  8022f1:	c3                   	ret    

008022f2 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8022f2:	55                   	push   %ebp
  8022f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8022f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f8:	6a 00                	push   $0x0
  8022fa:	6a 00                	push   $0x0
  8022fc:	6a 00                	push   $0x0
  8022fe:	6a 00                	push   $0x0
  802300:	50                   	push   %eax
  802301:	6a 22                	push   $0x22
  802303:	e8 52 fc ff ff       	call   801f5a <syscall>
  802308:	83 c4 18             	add    $0x18,%esp
}
  80230b:	c9                   	leave  
  80230c:	c3                   	ret    

0080230d <sys_getenvid>:

int32 sys_getenvid(void)
{
  80230d:	55                   	push   %ebp
  80230e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802310:	6a 00                	push   $0x0
  802312:	6a 00                	push   $0x0
  802314:	6a 00                	push   $0x0
  802316:	6a 00                	push   $0x0
  802318:	6a 00                	push   $0x0
  80231a:	6a 02                	push   $0x2
  80231c:	e8 39 fc ff ff       	call   801f5a <syscall>
  802321:	83 c4 18             	add    $0x18,%esp
}
  802324:	c9                   	leave  
  802325:	c3                   	ret    

00802326 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802326:	55                   	push   %ebp
  802327:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802329:	6a 00                	push   $0x0
  80232b:	6a 00                	push   $0x0
  80232d:	6a 00                	push   $0x0
  80232f:	6a 00                	push   $0x0
  802331:	6a 00                	push   $0x0
  802333:	6a 03                	push   $0x3
  802335:	e8 20 fc ff ff       	call   801f5a <syscall>
  80233a:	83 c4 18             	add    $0x18,%esp
}
  80233d:	c9                   	leave  
  80233e:	c3                   	ret    

0080233f <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80233f:	55                   	push   %ebp
  802340:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802342:	6a 00                	push   $0x0
  802344:	6a 00                	push   $0x0
  802346:	6a 00                	push   $0x0
  802348:	6a 00                	push   $0x0
  80234a:	6a 00                	push   $0x0
  80234c:	6a 04                	push   $0x4
  80234e:	e8 07 fc ff ff       	call   801f5a <syscall>
  802353:	83 c4 18             	add    $0x18,%esp
}
  802356:	c9                   	leave  
  802357:	c3                   	ret    

00802358 <sys_exit_env>:


void sys_exit_env(void)
{
  802358:	55                   	push   %ebp
  802359:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80235b:	6a 00                	push   $0x0
  80235d:	6a 00                	push   $0x0
  80235f:	6a 00                	push   $0x0
  802361:	6a 00                	push   $0x0
  802363:	6a 00                	push   $0x0
  802365:	6a 23                	push   $0x23
  802367:	e8 ee fb ff ff       	call   801f5a <syscall>
  80236c:	83 c4 18             	add    $0x18,%esp
}
  80236f:	90                   	nop
  802370:	c9                   	leave  
  802371:	c3                   	ret    

00802372 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802372:	55                   	push   %ebp
  802373:	89 e5                	mov    %esp,%ebp
  802375:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802378:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80237b:	8d 50 04             	lea    0x4(%eax),%edx
  80237e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802381:	6a 00                	push   $0x0
  802383:	6a 00                	push   $0x0
  802385:	6a 00                	push   $0x0
  802387:	52                   	push   %edx
  802388:	50                   	push   %eax
  802389:	6a 24                	push   $0x24
  80238b:	e8 ca fb ff ff       	call   801f5a <syscall>
  802390:	83 c4 18             	add    $0x18,%esp
	return result;
  802393:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802396:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802399:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80239c:	89 01                	mov    %eax,(%ecx)
  80239e:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8023a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a4:	c9                   	leave  
  8023a5:	c2 04 00             	ret    $0x4

008023a8 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8023a8:	55                   	push   %ebp
  8023a9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8023ab:	6a 00                	push   $0x0
  8023ad:	6a 00                	push   $0x0
  8023af:	ff 75 10             	pushl  0x10(%ebp)
  8023b2:	ff 75 0c             	pushl  0xc(%ebp)
  8023b5:	ff 75 08             	pushl  0x8(%ebp)
  8023b8:	6a 12                	push   $0x12
  8023ba:	e8 9b fb ff ff       	call   801f5a <syscall>
  8023bf:	83 c4 18             	add    $0x18,%esp
	return ;
  8023c2:	90                   	nop
}
  8023c3:	c9                   	leave  
  8023c4:	c3                   	ret    

008023c5 <sys_rcr2>:
uint32 sys_rcr2()
{
  8023c5:	55                   	push   %ebp
  8023c6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8023c8:	6a 00                	push   $0x0
  8023ca:	6a 00                	push   $0x0
  8023cc:	6a 00                	push   $0x0
  8023ce:	6a 00                	push   $0x0
  8023d0:	6a 00                	push   $0x0
  8023d2:	6a 25                	push   $0x25
  8023d4:	e8 81 fb ff ff       	call   801f5a <syscall>
  8023d9:	83 c4 18             	add    $0x18,%esp
}
  8023dc:	c9                   	leave  
  8023dd:	c3                   	ret    

008023de <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8023de:	55                   	push   %ebp
  8023df:	89 e5                	mov    %esp,%ebp
  8023e1:	83 ec 04             	sub    $0x4,%esp
  8023e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8023ea:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8023ee:	6a 00                	push   $0x0
  8023f0:	6a 00                	push   $0x0
  8023f2:	6a 00                	push   $0x0
  8023f4:	6a 00                	push   $0x0
  8023f6:	50                   	push   %eax
  8023f7:	6a 26                	push   $0x26
  8023f9:	e8 5c fb ff ff       	call   801f5a <syscall>
  8023fe:	83 c4 18             	add    $0x18,%esp
	return ;
  802401:	90                   	nop
}
  802402:	c9                   	leave  
  802403:	c3                   	ret    

00802404 <rsttst>:
void rsttst()
{
  802404:	55                   	push   %ebp
  802405:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802407:	6a 00                	push   $0x0
  802409:	6a 00                	push   $0x0
  80240b:	6a 00                	push   $0x0
  80240d:	6a 00                	push   $0x0
  80240f:	6a 00                	push   $0x0
  802411:	6a 28                	push   $0x28
  802413:	e8 42 fb ff ff       	call   801f5a <syscall>
  802418:	83 c4 18             	add    $0x18,%esp
	return ;
  80241b:	90                   	nop
}
  80241c:	c9                   	leave  
  80241d:	c3                   	ret    

0080241e <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80241e:	55                   	push   %ebp
  80241f:	89 e5                	mov    %esp,%ebp
  802421:	83 ec 04             	sub    $0x4,%esp
  802424:	8b 45 14             	mov    0x14(%ebp),%eax
  802427:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80242a:	8b 55 18             	mov    0x18(%ebp),%edx
  80242d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802431:	52                   	push   %edx
  802432:	50                   	push   %eax
  802433:	ff 75 10             	pushl  0x10(%ebp)
  802436:	ff 75 0c             	pushl  0xc(%ebp)
  802439:	ff 75 08             	pushl  0x8(%ebp)
  80243c:	6a 27                	push   $0x27
  80243e:	e8 17 fb ff ff       	call   801f5a <syscall>
  802443:	83 c4 18             	add    $0x18,%esp
	return ;
  802446:	90                   	nop
}
  802447:	c9                   	leave  
  802448:	c3                   	ret    

00802449 <chktst>:
void chktst(uint32 n)
{
  802449:	55                   	push   %ebp
  80244a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80244c:	6a 00                	push   $0x0
  80244e:	6a 00                	push   $0x0
  802450:	6a 00                	push   $0x0
  802452:	6a 00                	push   $0x0
  802454:	ff 75 08             	pushl  0x8(%ebp)
  802457:	6a 29                	push   $0x29
  802459:	e8 fc fa ff ff       	call   801f5a <syscall>
  80245e:	83 c4 18             	add    $0x18,%esp
	return ;
  802461:	90                   	nop
}
  802462:	c9                   	leave  
  802463:	c3                   	ret    

00802464 <inctst>:

void inctst()
{
  802464:	55                   	push   %ebp
  802465:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802467:	6a 00                	push   $0x0
  802469:	6a 00                	push   $0x0
  80246b:	6a 00                	push   $0x0
  80246d:	6a 00                	push   $0x0
  80246f:	6a 00                	push   $0x0
  802471:	6a 2a                	push   $0x2a
  802473:	e8 e2 fa ff ff       	call   801f5a <syscall>
  802478:	83 c4 18             	add    $0x18,%esp
	return ;
  80247b:	90                   	nop
}
  80247c:	c9                   	leave  
  80247d:	c3                   	ret    

0080247e <gettst>:
uint32 gettst()
{
  80247e:	55                   	push   %ebp
  80247f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802481:	6a 00                	push   $0x0
  802483:	6a 00                	push   $0x0
  802485:	6a 00                	push   $0x0
  802487:	6a 00                	push   $0x0
  802489:	6a 00                	push   $0x0
  80248b:	6a 2b                	push   $0x2b
  80248d:	e8 c8 fa ff ff       	call   801f5a <syscall>
  802492:	83 c4 18             	add    $0x18,%esp
}
  802495:	c9                   	leave  
  802496:	c3                   	ret    

00802497 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802497:	55                   	push   %ebp
  802498:	89 e5                	mov    %esp,%ebp
  80249a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80249d:	6a 00                	push   $0x0
  80249f:	6a 00                	push   $0x0
  8024a1:	6a 00                	push   $0x0
  8024a3:	6a 00                	push   $0x0
  8024a5:	6a 00                	push   $0x0
  8024a7:	6a 2c                	push   $0x2c
  8024a9:	e8 ac fa ff ff       	call   801f5a <syscall>
  8024ae:	83 c4 18             	add    $0x18,%esp
  8024b1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8024b4:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8024b8:	75 07                	jne    8024c1 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8024ba:	b8 01 00 00 00       	mov    $0x1,%eax
  8024bf:	eb 05                	jmp    8024c6 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8024c1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024c6:	c9                   	leave  
  8024c7:	c3                   	ret    

008024c8 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8024c8:	55                   	push   %ebp
  8024c9:	89 e5                	mov    %esp,%ebp
  8024cb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8024ce:	6a 00                	push   $0x0
  8024d0:	6a 00                	push   $0x0
  8024d2:	6a 00                	push   $0x0
  8024d4:	6a 00                	push   $0x0
  8024d6:	6a 00                	push   $0x0
  8024d8:	6a 2c                	push   $0x2c
  8024da:	e8 7b fa ff ff       	call   801f5a <syscall>
  8024df:	83 c4 18             	add    $0x18,%esp
  8024e2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8024e5:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8024e9:	75 07                	jne    8024f2 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8024eb:	b8 01 00 00 00       	mov    $0x1,%eax
  8024f0:	eb 05                	jmp    8024f7 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8024f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024f7:	c9                   	leave  
  8024f8:	c3                   	ret    

008024f9 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8024f9:	55                   	push   %ebp
  8024fa:	89 e5                	mov    %esp,%ebp
  8024fc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8024ff:	6a 00                	push   $0x0
  802501:	6a 00                	push   $0x0
  802503:	6a 00                	push   $0x0
  802505:	6a 00                	push   $0x0
  802507:	6a 00                	push   $0x0
  802509:	6a 2c                	push   $0x2c
  80250b:	e8 4a fa ff ff       	call   801f5a <syscall>
  802510:	83 c4 18             	add    $0x18,%esp
  802513:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802516:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80251a:	75 07                	jne    802523 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80251c:	b8 01 00 00 00       	mov    $0x1,%eax
  802521:	eb 05                	jmp    802528 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802523:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802528:	c9                   	leave  
  802529:	c3                   	ret    

0080252a <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80252a:	55                   	push   %ebp
  80252b:	89 e5                	mov    %esp,%ebp
  80252d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802530:	6a 00                	push   $0x0
  802532:	6a 00                	push   $0x0
  802534:	6a 00                	push   $0x0
  802536:	6a 00                	push   $0x0
  802538:	6a 00                	push   $0x0
  80253a:	6a 2c                	push   $0x2c
  80253c:	e8 19 fa ff ff       	call   801f5a <syscall>
  802541:	83 c4 18             	add    $0x18,%esp
  802544:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802547:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80254b:	75 07                	jne    802554 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80254d:	b8 01 00 00 00       	mov    $0x1,%eax
  802552:	eb 05                	jmp    802559 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802554:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802559:	c9                   	leave  
  80255a:	c3                   	ret    

0080255b <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80255b:	55                   	push   %ebp
  80255c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80255e:	6a 00                	push   $0x0
  802560:	6a 00                	push   $0x0
  802562:	6a 00                	push   $0x0
  802564:	6a 00                	push   $0x0
  802566:	ff 75 08             	pushl  0x8(%ebp)
  802569:	6a 2d                	push   $0x2d
  80256b:	e8 ea f9 ff ff       	call   801f5a <syscall>
  802570:	83 c4 18             	add    $0x18,%esp
	return ;
  802573:	90                   	nop
}
  802574:	c9                   	leave  
  802575:	c3                   	ret    

00802576 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802576:	55                   	push   %ebp
  802577:	89 e5                	mov    %esp,%ebp
  802579:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80257a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80257d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802580:	8b 55 0c             	mov    0xc(%ebp),%edx
  802583:	8b 45 08             	mov    0x8(%ebp),%eax
  802586:	6a 00                	push   $0x0
  802588:	53                   	push   %ebx
  802589:	51                   	push   %ecx
  80258a:	52                   	push   %edx
  80258b:	50                   	push   %eax
  80258c:	6a 2e                	push   $0x2e
  80258e:	e8 c7 f9 ff ff       	call   801f5a <syscall>
  802593:	83 c4 18             	add    $0x18,%esp
}
  802596:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802599:	c9                   	leave  
  80259a:	c3                   	ret    

0080259b <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80259b:	55                   	push   %ebp
  80259c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80259e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a4:	6a 00                	push   $0x0
  8025a6:	6a 00                	push   $0x0
  8025a8:	6a 00                	push   $0x0
  8025aa:	52                   	push   %edx
  8025ab:	50                   	push   %eax
  8025ac:	6a 2f                	push   $0x2f
  8025ae:	e8 a7 f9 ff ff       	call   801f5a <syscall>
  8025b3:	83 c4 18             	add    $0x18,%esp
}
  8025b6:	c9                   	leave  
  8025b7:	c3                   	ret    

008025b8 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8025b8:	55                   	push   %ebp
  8025b9:	89 e5                	mov    %esp,%ebp
  8025bb:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8025be:	83 ec 0c             	sub    $0xc,%esp
  8025c1:	68 58 47 80 00       	push   $0x804758
  8025c6:	e8 86 e5 ff ff       	call   800b51 <cprintf>
  8025cb:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8025ce:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8025d5:	83 ec 0c             	sub    $0xc,%esp
  8025d8:	68 84 47 80 00       	push   $0x804784
  8025dd:	e8 6f e5 ff ff       	call   800b51 <cprintf>
  8025e2:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8025e5:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8025e9:	a1 38 51 80 00       	mov    0x805138,%eax
  8025ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025f1:	eb 56                	jmp    802649 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8025f3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025f7:	74 1c                	je     802615 <print_mem_block_lists+0x5d>
  8025f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fc:	8b 50 08             	mov    0x8(%eax),%edx
  8025ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802602:	8b 48 08             	mov    0x8(%eax),%ecx
  802605:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802608:	8b 40 0c             	mov    0xc(%eax),%eax
  80260b:	01 c8                	add    %ecx,%eax
  80260d:	39 c2                	cmp    %eax,%edx
  80260f:	73 04                	jae    802615 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802611:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802615:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802618:	8b 50 08             	mov    0x8(%eax),%edx
  80261b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261e:	8b 40 0c             	mov    0xc(%eax),%eax
  802621:	01 c2                	add    %eax,%edx
  802623:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802626:	8b 40 08             	mov    0x8(%eax),%eax
  802629:	83 ec 04             	sub    $0x4,%esp
  80262c:	52                   	push   %edx
  80262d:	50                   	push   %eax
  80262e:	68 99 47 80 00       	push   $0x804799
  802633:	e8 19 e5 ff ff       	call   800b51 <cprintf>
  802638:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80263b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802641:	a1 40 51 80 00       	mov    0x805140,%eax
  802646:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802649:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80264d:	74 07                	je     802656 <print_mem_block_lists+0x9e>
  80264f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802652:	8b 00                	mov    (%eax),%eax
  802654:	eb 05                	jmp    80265b <print_mem_block_lists+0xa3>
  802656:	b8 00 00 00 00       	mov    $0x0,%eax
  80265b:	a3 40 51 80 00       	mov    %eax,0x805140
  802660:	a1 40 51 80 00       	mov    0x805140,%eax
  802665:	85 c0                	test   %eax,%eax
  802667:	75 8a                	jne    8025f3 <print_mem_block_lists+0x3b>
  802669:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80266d:	75 84                	jne    8025f3 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  80266f:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802673:	75 10                	jne    802685 <print_mem_block_lists+0xcd>
  802675:	83 ec 0c             	sub    $0xc,%esp
  802678:	68 a8 47 80 00       	push   $0x8047a8
  80267d:	e8 cf e4 ff ff       	call   800b51 <cprintf>
  802682:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802685:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80268c:	83 ec 0c             	sub    $0xc,%esp
  80268f:	68 cc 47 80 00       	push   $0x8047cc
  802694:	e8 b8 e4 ff ff       	call   800b51 <cprintf>
  802699:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80269c:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8026a0:	a1 40 50 80 00       	mov    0x805040,%eax
  8026a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026a8:	eb 56                	jmp    802700 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8026aa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026ae:	74 1c                	je     8026cc <print_mem_block_lists+0x114>
  8026b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b3:	8b 50 08             	mov    0x8(%eax),%edx
  8026b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026b9:	8b 48 08             	mov    0x8(%eax),%ecx
  8026bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026bf:	8b 40 0c             	mov    0xc(%eax),%eax
  8026c2:	01 c8                	add    %ecx,%eax
  8026c4:	39 c2                	cmp    %eax,%edx
  8026c6:	73 04                	jae    8026cc <print_mem_block_lists+0x114>
			sorted = 0 ;
  8026c8:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8026cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cf:	8b 50 08             	mov    0x8(%eax),%edx
  8026d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d5:	8b 40 0c             	mov    0xc(%eax),%eax
  8026d8:	01 c2                	add    %eax,%edx
  8026da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026dd:	8b 40 08             	mov    0x8(%eax),%eax
  8026e0:	83 ec 04             	sub    $0x4,%esp
  8026e3:	52                   	push   %edx
  8026e4:	50                   	push   %eax
  8026e5:	68 99 47 80 00       	push   $0x804799
  8026ea:	e8 62 e4 ff ff       	call   800b51 <cprintf>
  8026ef:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8026f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8026f8:	a1 48 50 80 00       	mov    0x805048,%eax
  8026fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802700:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802704:	74 07                	je     80270d <print_mem_block_lists+0x155>
  802706:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802709:	8b 00                	mov    (%eax),%eax
  80270b:	eb 05                	jmp    802712 <print_mem_block_lists+0x15a>
  80270d:	b8 00 00 00 00       	mov    $0x0,%eax
  802712:	a3 48 50 80 00       	mov    %eax,0x805048
  802717:	a1 48 50 80 00       	mov    0x805048,%eax
  80271c:	85 c0                	test   %eax,%eax
  80271e:	75 8a                	jne    8026aa <print_mem_block_lists+0xf2>
  802720:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802724:	75 84                	jne    8026aa <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802726:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80272a:	75 10                	jne    80273c <print_mem_block_lists+0x184>
  80272c:	83 ec 0c             	sub    $0xc,%esp
  80272f:	68 e4 47 80 00       	push   $0x8047e4
  802734:	e8 18 e4 ff ff       	call   800b51 <cprintf>
  802739:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80273c:	83 ec 0c             	sub    $0xc,%esp
  80273f:	68 58 47 80 00       	push   $0x804758
  802744:	e8 08 e4 ff ff       	call   800b51 <cprintf>
  802749:	83 c4 10             	add    $0x10,%esp

}
  80274c:	90                   	nop
  80274d:	c9                   	leave  
  80274e:	c3                   	ret    

0080274f <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80274f:	55                   	push   %ebp
  802750:	89 e5                	mov    %esp,%ebp
  802752:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  802755:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  80275c:	00 00 00 
  80275f:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802766:	00 00 00 
  802769:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802770:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  802773:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80277a:	e9 9e 00 00 00       	jmp    80281d <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  80277f:	a1 50 50 80 00       	mov    0x805050,%eax
  802784:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802787:	c1 e2 04             	shl    $0x4,%edx
  80278a:	01 d0                	add    %edx,%eax
  80278c:	85 c0                	test   %eax,%eax
  80278e:	75 14                	jne    8027a4 <initialize_MemBlocksList+0x55>
  802790:	83 ec 04             	sub    $0x4,%esp
  802793:	68 0c 48 80 00       	push   $0x80480c
  802798:	6a 46                	push   $0x46
  80279a:	68 2f 48 80 00       	push   $0x80482f
  80279f:	e8 f9 e0 ff ff       	call   80089d <_panic>
  8027a4:	a1 50 50 80 00       	mov    0x805050,%eax
  8027a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027ac:	c1 e2 04             	shl    $0x4,%edx
  8027af:	01 d0                	add    %edx,%eax
  8027b1:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8027b7:	89 10                	mov    %edx,(%eax)
  8027b9:	8b 00                	mov    (%eax),%eax
  8027bb:	85 c0                	test   %eax,%eax
  8027bd:	74 18                	je     8027d7 <initialize_MemBlocksList+0x88>
  8027bf:	a1 48 51 80 00       	mov    0x805148,%eax
  8027c4:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8027ca:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8027cd:	c1 e1 04             	shl    $0x4,%ecx
  8027d0:	01 ca                	add    %ecx,%edx
  8027d2:	89 50 04             	mov    %edx,0x4(%eax)
  8027d5:	eb 12                	jmp    8027e9 <initialize_MemBlocksList+0x9a>
  8027d7:	a1 50 50 80 00       	mov    0x805050,%eax
  8027dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027df:	c1 e2 04             	shl    $0x4,%edx
  8027e2:	01 d0                	add    %edx,%eax
  8027e4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8027e9:	a1 50 50 80 00       	mov    0x805050,%eax
  8027ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027f1:	c1 e2 04             	shl    $0x4,%edx
  8027f4:	01 d0                	add    %edx,%eax
  8027f6:	a3 48 51 80 00       	mov    %eax,0x805148
  8027fb:	a1 50 50 80 00       	mov    0x805050,%eax
  802800:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802803:	c1 e2 04             	shl    $0x4,%edx
  802806:	01 d0                	add    %edx,%eax
  802808:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80280f:	a1 54 51 80 00       	mov    0x805154,%eax
  802814:	40                   	inc    %eax
  802815:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  80281a:	ff 45 f4             	incl   -0xc(%ebp)
  80281d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802820:	3b 45 08             	cmp    0x8(%ebp),%eax
  802823:	0f 82 56 ff ff ff    	jb     80277f <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802829:	90                   	nop
  80282a:	c9                   	leave  
  80282b:	c3                   	ret    

0080282c <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80282c:	55                   	push   %ebp
  80282d:	89 e5                	mov    %esp,%ebp
  80282f:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802832:	8b 45 08             	mov    0x8(%ebp),%eax
  802835:	8b 00                	mov    (%eax),%eax
  802837:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80283a:	eb 19                	jmp    802855 <find_block+0x29>
	{
		if(va==point->sva)
  80283c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80283f:	8b 40 08             	mov    0x8(%eax),%eax
  802842:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802845:	75 05                	jne    80284c <find_block+0x20>
		   return point;
  802847:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80284a:	eb 36                	jmp    802882 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80284c:	8b 45 08             	mov    0x8(%ebp),%eax
  80284f:	8b 40 08             	mov    0x8(%eax),%eax
  802852:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802855:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802859:	74 07                	je     802862 <find_block+0x36>
  80285b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80285e:	8b 00                	mov    (%eax),%eax
  802860:	eb 05                	jmp    802867 <find_block+0x3b>
  802862:	b8 00 00 00 00       	mov    $0x0,%eax
  802867:	8b 55 08             	mov    0x8(%ebp),%edx
  80286a:	89 42 08             	mov    %eax,0x8(%edx)
  80286d:	8b 45 08             	mov    0x8(%ebp),%eax
  802870:	8b 40 08             	mov    0x8(%eax),%eax
  802873:	85 c0                	test   %eax,%eax
  802875:	75 c5                	jne    80283c <find_block+0x10>
  802877:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80287b:	75 bf                	jne    80283c <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  80287d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802882:	c9                   	leave  
  802883:	c3                   	ret    

00802884 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802884:	55                   	push   %ebp
  802885:	89 e5                	mov    %esp,%ebp
  802887:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  80288a:	a1 40 50 80 00       	mov    0x805040,%eax
  80288f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802892:	a1 44 50 80 00       	mov    0x805044,%eax
  802897:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  80289a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80289d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8028a0:	74 24                	je     8028c6 <insert_sorted_allocList+0x42>
  8028a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a5:	8b 50 08             	mov    0x8(%eax),%edx
  8028a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ab:	8b 40 08             	mov    0x8(%eax),%eax
  8028ae:	39 c2                	cmp    %eax,%edx
  8028b0:	76 14                	jbe    8028c6 <insert_sorted_allocList+0x42>
  8028b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b5:	8b 50 08             	mov    0x8(%eax),%edx
  8028b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028bb:	8b 40 08             	mov    0x8(%eax),%eax
  8028be:	39 c2                	cmp    %eax,%edx
  8028c0:	0f 82 60 01 00 00    	jb     802a26 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8028c6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028ca:	75 65                	jne    802931 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8028cc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028d0:	75 14                	jne    8028e6 <insert_sorted_allocList+0x62>
  8028d2:	83 ec 04             	sub    $0x4,%esp
  8028d5:	68 0c 48 80 00       	push   $0x80480c
  8028da:	6a 6b                	push   $0x6b
  8028dc:	68 2f 48 80 00       	push   $0x80482f
  8028e1:	e8 b7 df ff ff       	call   80089d <_panic>
  8028e6:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8028ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ef:	89 10                	mov    %edx,(%eax)
  8028f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f4:	8b 00                	mov    (%eax),%eax
  8028f6:	85 c0                	test   %eax,%eax
  8028f8:	74 0d                	je     802907 <insert_sorted_allocList+0x83>
  8028fa:	a1 40 50 80 00       	mov    0x805040,%eax
  8028ff:	8b 55 08             	mov    0x8(%ebp),%edx
  802902:	89 50 04             	mov    %edx,0x4(%eax)
  802905:	eb 08                	jmp    80290f <insert_sorted_allocList+0x8b>
  802907:	8b 45 08             	mov    0x8(%ebp),%eax
  80290a:	a3 44 50 80 00       	mov    %eax,0x805044
  80290f:	8b 45 08             	mov    0x8(%ebp),%eax
  802912:	a3 40 50 80 00       	mov    %eax,0x805040
  802917:	8b 45 08             	mov    0x8(%ebp),%eax
  80291a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802921:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802926:	40                   	inc    %eax
  802927:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80292c:	e9 dc 01 00 00       	jmp    802b0d <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802931:	8b 45 08             	mov    0x8(%ebp),%eax
  802934:	8b 50 08             	mov    0x8(%eax),%edx
  802937:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80293a:	8b 40 08             	mov    0x8(%eax),%eax
  80293d:	39 c2                	cmp    %eax,%edx
  80293f:	77 6c                	ja     8029ad <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802941:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802945:	74 06                	je     80294d <insert_sorted_allocList+0xc9>
  802947:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80294b:	75 14                	jne    802961 <insert_sorted_allocList+0xdd>
  80294d:	83 ec 04             	sub    $0x4,%esp
  802950:	68 48 48 80 00       	push   $0x804848
  802955:	6a 6f                	push   $0x6f
  802957:	68 2f 48 80 00       	push   $0x80482f
  80295c:	e8 3c df ff ff       	call   80089d <_panic>
  802961:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802964:	8b 50 04             	mov    0x4(%eax),%edx
  802967:	8b 45 08             	mov    0x8(%ebp),%eax
  80296a:	89 50 04             	mov    %edx,0x4(%eax)
  80296d:	8b 45 08             	mov    0x8(%ebp),%eax
  802970:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802973:	89 10                	mov    %edx,(%eax)
  802975:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802978:	8b 40 04             	mov    0x4(%eax),%eax
  80297b:	85 c0                	test   %eax,%eax
  80297d:	74 0d                	je     80298c <insert_sorted_allocList+0x108>
  80297f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802982:	8b 40 04             	mov    0x4(%eax),%eax
  802985:	8b 55 08             	mov    0x8(%ebp),%edx
  802988:	89 10                	mov    %edx,(%eax)
  80298a:	eb 08                	jmp    802994 <insert_sorted_allocList+0x110>
  80298c:	8b 45 08             	mov    0x8(%ebp),%eax
  80298f:	a3 40 50 80 00       	mov    %eax,0x805040
  802994:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802997:	8b 55 08             	mov    0x8(%ebp),%edx
  80299a:	89 50 04             	mov    %edx,0x4(%eax)
  80299d:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8029a2:	40                   	inc    %eax
  8029a3:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8029a8:	e9 60 01 00 00       	jmp    802b0d <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8029ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b0:	8b 50 08             	mov    0x8(%eax),%edx
  8029b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029b6:	8b 40 08             	mov    0x8(%eax),%eax
  8029b9:	39 c2                	cmp    %eax,%edx
  8029bb:	0f 82 4c 01 00 00    	jb     802b0d <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8029c1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029c5:	75 14                	jne    8029db <insert_sorted_allocList+0x157>
  8029c7:	83 ec 04             	sub    $0x4,%esp
  8029ca:	68 80 48 80 00       	push   $0x804880
  8029cf:	6a 73                	push   $0x73
  8029d1:	68 2f 48 80 00       	push   $0x80482f
  8029d6:	e8 c2 de ff ff       	call   80089d <_panic>
  8029db:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8029e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e4:	89 50 04             	mov    %edx,0x4(%eax)
  8029e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ea:	8b 40 04             	mov    0x4(%eax),%eax
  8029ed:	85 c0                	test   %eax,%eax
  8029ef:	74 0c                	je     8029fd <insert_sorted_allocList+0x179>
  8029f1:	a1 44 50 80 00       	mov    0x805044,%eax
  8029f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8029f9:	89 10                	mov    %edx,(%eax)
  8029fb:	eb 08                	jmp    802a05 <insert_sorted_allocList+0x181>
  8029fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802a00:	a3 40 50 80 00       	mov    %eax,0x805040
  802a05:	8b 45 08             	mov    0x8(%ebp),%eax
  802a08:	a3 44 50 80 00       	mov    %eax,0x805044
  802a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a10:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a16:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802a1b:	40                   	inc    %eax
  802a1c:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802a21:	e9 e7 00 00 00       	jmp    802b0d <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802a26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a29:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802a2c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802a33:	a1 40 50 80 00       	mov    0x805040,%eax
  802a38:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a3b:	e9 9d 00 00 00       	jmp    802add <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802a40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a43:	8b 00                	mov    (%eax),%eax
  802a45:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802a48:	8b 45 08             	mov    0x8(%ebp),%eax
  802a4b:	8b 50 08             	mov    0x8(%eax),%edx
  802a4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a51:	8b 40 08             	mov    0x8(%eax),%eax
  802a54:	39 c2                	cmp    %eax,%edx
  802a56:	76 7d                	jbe    802ad5 <insert_sorted_allocList+0x251>
  802a58:	8b 45 08             	mov    0x8(%ebp),%eax
  802a5b:	8b 50 08             	mov    0x8(%eax),%edx
  802a5e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a61:	8b 40 08             	mov    0x8(%eax),%eax
  802a64:	39 c2                	cmp    %eax,%edx
  802a66:	73 6d                	jae    802ad5 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802a68:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a6c:	74 06                	je     802a74 <insert_sorted_allocList+0x1f0>
  802a6e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a72:	75 14                	jne    802a88 <insert_sorted_allocList+0x204>
  802a74:	83 ec 04             	sub    $0x4,%esp
  802a77:	68 a4 48 80 00       	push   $0x8048a4
  802a7c:	6a 7f                	push   $0x7f
  802a7e:	68 2f 48 80 00       	push   $0x80482f
  802a83:	e8 15 de ff ff       	call   80089d <_panic>
  802a88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8b:	8b 10                	mov    (%eax),%edx
  802a8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a90:	89 10                	mov    %edx,(%eax)
  802a92:	8b 45 08             	mov    0x8(%ebp),%eax
  802a95:	8b 00                	mov    (%eax),%eax
  802a97:	85 c0                	test   %eax,%eax
  802a99:	74 0b                	je     802aa6 <insert_sorted_allocList+0x222>
  802a9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9e:	8b 00                	mov    (%eax),%eax
  802aa0:	8b 55 08             	mov    0x8(%ebp),%edx
  802aa3:	89 50 04             	mov    %edx,0x4(%eax)
  802aa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa9:	8b 55 08             	mov    0x8(%ebp),%edx
  802aac:	89 10                	mov    %edx,(%eax)
  802aae:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ab4:	89 50 04             	mov    %edx,0x4(%eax)
  802ab7:	8b 45 08             	mov    0x8(%ebp),%eax
  802aba:	8b 00                	mov    (%eax),%eax
  802abc:	85 c0                	test   %eax,%eax
  802abe:	75 08                	jne    802ac8 <insert_sorted_allocList+0x244>
  802ac0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac3:	a3 44 50 80 00       	mov    %eax,0x805044
  802ac8:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802acd:	40                   	inc    %eax
  802ace:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802ad3:	eb 39                	jmp    802b0e <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802ad5:	a1 48 50 80 00       	mov    0x805048,%eax
  802ada:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802add:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ae1:	74 07                	je     802aea <insert_sorted_allocList+0x266>
  802ae3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae6:	8b 00                	mov    (%eax),%eax
  802ae8:	eb 05                	jmp    802aef <insert_sorted_allocList+0x26b>
  802aea:	b8 00 00 00 00       	mov    $0x0,%eax
  802aef:	a3 48 50 80 00       	mov    %eax,0x805048
  802af4:	a1 48 50 80 00       	mov    0x805048,%eax
  802af9:	85 c0                	test   %eax,%eax
  802afb:	0f 85 3f ff ff ff    	jne    802a40 <insert_sorted_allocList+0x1bc>
  802b01:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b05:	0f 85 35 ff ff ff    	jne    802a40 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802b0b:	eb 01                	jmp    802b0e <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802b0d:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802b0e:	90                   	nop
  802b0f:	c9                   	leave  
  802b10:	c3                   	ret    

00802b11 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802b11:	55                   	push   %ebp
  802b12:	89 e5                	mov    %esp,%ebp
  802b14:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802b17:	a1 38 51 80 00       	mov    0x805138,%eax
  802b1c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b1f:	e9 85 01 00 00       	jmp    802ca9 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802b24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b27:	8b 40 0c             	mov    0xc(%eax),%eax
  802b2a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b2d:	0f 82 6e 01 00 00    	jb     802ca1 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802b33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b36:	8b 40 0c             	mov    0xc(%eax),%eax
  802b39:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b3c:	0f 85 8a 00 00 00    	jne    802bcc <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802b42:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b46:	75 17                	jne    802b5f <alloc_block_FF+0x4e>
  802b48:	83 ec 04             	sub    $0x4,%esp
  802b4b:	68 d8 48 80 00       	push   $0x8048d8
  802b50:	68 93 00 00 00       	push   $0x93
  802b55:	68 2f 48 80 00       	push   $0x80482f
  802b5a:	e8 3e dd ff ff       	call   80089d <_panic>
  802b5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b62:	8b 00                	mov    (%eax),%eax
  802b64:	85 c0                	test   %eax,%eax
  802b66:	74 10                	je     802b78 <alloc_block_FF+0x67>
  802b68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6b:	8b 00                	mov    (%eax),%eax
  802b6d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b70:	8b 52 04             	mov    0x4(%edx),%edx
  802b73:	89 50 04             	mov    %edx,0x4(%eax)
  802b76:	eb 0b                	jmp    802b83 <alloc_block_FF+0x72>
  802b78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7b:	8b 40 04             	mov    0x4(%eax),%eax
  802b7e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b86:	8b 40 04             	mov    0x4(%eax),%eax
  802b89:	85 c0                	test   %eax,%eax
  802b8b:	74 0f                	je     802b9c <alloc_block_FF+0x8b>
  802b8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b90:	8b 40 04             	mov    0x4(%eax),%eax
  802b93:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b96:	8b 12                	mov    (%edx),%edx
  802b98:	89 10                	mov    %edx,(%eax)
  802b9a:	eb 0a                	jmp    802ba6 <alloc_block_FF+0x95>
  802b9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9f:	8b 00                	mov    (%eax),%eax
  802ba1:	a3 38 51 80 00       	mov    %eax,0x805138
  802ba6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802baf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bb9:	a1 44 51 80 00       	mov    0x805144,%eax
  802bbe:	48                   	dec    %eax
  802bbf:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802bc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc7:	e9 10 01 00 00       	jmp    802cdc <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802bcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bcf:	8b 40 0c             	mov    0xc(%eax),%eax
  802bd2:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bd5:	0f 86 c6 00 00 00    	jbe    802ca1 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802bdb:	a1 48 51 80 00       	mov    0x805148,%eax
  802be0:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802be3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be6:	8b 50 08             	mov    0x8(%eax),%edx
  802be9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bec:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802bef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bf2:	8b 55 08             	mov    0x8(%ebp),%edx
  802bf5:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802bf8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bfc:	75 17                	jne    802c15 <alloc_block_FF+0x104>
  802bfe:	83 ec 04             	sub    $0x4,%esp
  802c01:	68 d8 48 80 00       	push   $0x8048d8
  802c06:	68 9b 00 00 00       	push   $0x9b
  802c0b:	68 2f 48 80 00       	push   $0x80482f
  802c10:	e8 88 dc ff ff       	call   80089d <_panic>
  802c15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c18:	8b 00                	mov    (%eax),%eax
  802c1a:	85 c0                	test   %eax,%eax
  802c1c:	74 10                	je     802c2e <alloc_block_FF+0x11d>
  802c1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c21:	8b 00                	mov    (%eax),%eax
  802c23:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c26:	8b 52 04             	mov    0x4(%edx),%edx
  802c29:	89 50 04             	mov    %edx,0x4(%eax)
  802c2c:	eb 0b                	jmp    802c39 <alloc_block_FF+0x128>
  802c2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c31:	8b 40 04             	mov    0x4(%eax),%eax
  802c34:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c3c:	8b 40 04             	mov    0x4(%eax),%eax
  802c3f:	85 c0                	test   %eax,%eax
  802c41:	74 0f                	je     802c52 <alloc_block_FF+0x141>
  802c43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c46:	8b 40 04             	mov    0x4(%eax),%eax
  802c49:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c4c:	8b 12                	mov    (%edx),%edx
  802c4e:	89 10                	mov    %edx,(%eax)
  802c50:	eb 0a                	jmp    802c5c <alloc_block_FF+0x14b>
  802c52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c55:	8b 00                	mov    (%eax),%eax
  802c57:	a3 48 51 80 00       	mov    %eax,0x805148
  802c5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c5f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c68:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c6f:	a1 54 51 80 00       	mov    0x805154,%eax
  802c74:	48                   	dec    %eax
  802c75:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802c7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7d:	8b 50 08             	mov    0x8(%eax),%edx
  802c80:	8b 45 08             	mov    0x8(%ebp),%eax
  802c83:	01 c2                	add    %eax,%edx
  802c85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c88:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802c8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8e:	8b 40 0c             	mov    0xc(%eax),%eax
  802c91:	2b 45 08             	sub    0x8(%ebp),%eax
  802c94:	89 c2                	mov    %eax,%edx
  802c96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c99:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802c9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c9f:	eb 3b                	jmp    802cdc <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802ca1:	a1 40 51 80 00       	mov    0x805140,%eax
  802ca6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ca9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cad:	74 07                	je     802cb6 <alloc_block_FF+0x1a5>
  802caf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb2:	8b 00                	mov    (%eax),%eax
  802cb4:	eb 05                	jmp    802cbb <alloc_block_FF+0x1aa>
  802cb6:	b8 00 00 00 00       	mov    $0x0,%eax
  802cbb:	a3 40 51 80 00       	mov    %eax,0x805140
  802cc0:	a1 40 51 80 00       	mov    0x805140,%eax
  802cc5:	85 c0                	test   %eax,%eax
  802cc7:	0f 85 57 fe ff ff    	jne    802b24 <alloc_block_FF+0x13>
  802ccd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cd1:	0f 85 4d fe ff ff    	jne    802b24 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802cd7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802cdc:	c9                   	leave  
  802cdd:	c3                   	ret    

00802cde <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802cde:	55                   	push   %ebp
  802cdf:	89 e5                	mov    %esp,%ebp
  802ce1:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802ce4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802ceb:	a1 38 51 80 00       	mov    0x805138,%eax
  802cf0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cf3:	e9 df 00 00 00       	jmp    802dd7 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802cf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfb:	8b 40 0c             	mov    0xc(%eax),%eax
  802cfe:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d01:	0f 82 c8 00 00 00    	jb     802dcf <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802d07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0a:	8b 40 0c             	mov    0xc(%eax),%eax
  802d0d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d10:	0f 85 8a 00 00 00    	jne    802da0 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802d16:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d1a:	75 17                	jne    802d33 <alloc_block_BF+0x55>
  802d1c:	83 ec 04             	sub    $0x4,%esp
  802d1f:	68 d8 48 80 00       	push   $0x8048d8
  802d24:	68 b7 00 00 00       	push   $0xb7
  802d29:	68 2f 48 80 00       	push   $0x80482f
  802d2e:	e8 6a db ff ff       	call   80089d <_panic>
  802d33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d36:	8b 00                	mov    (%eax),%eax
  802d38:	85 c0                	test   %eax,%eax
  802d3a:	74 10                	je     802d4c <alloc_block_BF+0x6e>
  802d3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3f:	8b 00                	mov    (%eax),%eax
  802d41:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d44:	8b 52 04             	mov    0x4(%edx),%edx
  802d47:	89 50 04             	mov    %edx,0x4(%eax)
  802d4a:	eb 0b                	jmp    802d57 <alloc_block_BF+0x79>
  802d4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4f:	8b 40 04             	mov    0x4(%eax),%eax
  802d52:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5a:	8b 40 04             	mov    0x4(%eax),%eax
  802d5d:	85 c0                	test   %eax,%eax
  802d5f:	74 0f                	je     802d70 <alloc_block_BF+0x92>
  802d61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d64:	8b 40 04             	mov    0x4(%eax),%eax
  802d67:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d6a:	8b 12                	mov    (%edx),%edx
  802d6c:	89 10                	mov    %edx,(%eax)
  802d6e:	eb 0a                	jmp    802d7a <alloc_block_BF+0x9c>
  802d70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d73:	8b 00                	mov    (%eax),%eax
  802d75:	a3 38 51 80 00       	mov    %eax,0x805138
  802d7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d86:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d8d:	a1 44 51 80 00       	mov    0x805144,%eax
  802d92:	48                   	dec    %eax
  802d93:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802d98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9b:	e9 4d 01 00 00       	jmp    802eed <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802da0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da3:	8b 40 0c             	mov    0xc(%eax),%eax
  802da6:	3b 45 08             	cmp    0x8(%ebp),%eax
  802da9:	76 24                	jbe    802dcf <alloc_block_BF+0xf1>
  802dab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dae:	8b 40 0c             	mov    0xc(%eax),%eax
  802db1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802db4:	73 19                	jae    802dcf <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802db6:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802dbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc0:	8b 40 0c             	mov    0xc(%eax),%eax
  802dc3:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802dc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc9:	8b 40 08             	mov    0x8(%eax),%eax
  802dcc:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802dcf:	a1 40 51 80 00       	mov    0x805140,%eax
  802dd4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802dd7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ddb:	74 07                	je     802de4 <alloc_block_BF+0x106>
  802ddd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de0:	8b 00                	mov    (%eax),%eax
  802de2:	eb 05                	jmp    802de9 <alloc_block_BF+0x10b>
  802de4:	b8 00 00 00 00       	mov    $0x0,%eax
  802de9:	a3 40 51 80 00       	mov    %eax,0x805140
  802dee:	a1 40 51 80 00       	mov    0x805140,%eax
  802df3:	85 c0                	test   %eax,%eax
  802df5:	0f 85 fd fe ff ff    	jne    802cf8 <alloc_block_BF+0x1a>
  802dfb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dff:	0f 85 f3 fe ff ff    	jne    802cf8 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802e05:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802e09:	0f 84 d9 00 00 00    	je     802ee8 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802e0f:	a1 48 51 80 00       	mov    0x805148,%eax
  802e14:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802e17:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e1a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e1d:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802e20:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e23:	8b 55 08             	mov    0x8(%ebp),%edx
  802e26:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802e29:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802e2d:	75 17                	jne    802e46 <alloc_block_BF+0x168>
  802e2f:	83 ec 04             	sub    $0x4,%esp
  802e32:	68 d8 48 80 00       	push   $0x8048d8
  802e37:	68 c7 00 00 00       	push   $0xc7
  802e3c:	68 2f 48 80 00       	push   $0x80482f
  802e41:	e8 57 da ff ff       	call   80089d <_panic>
  802e46:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e49:	8b 00                	mov    (%eax),%eax
  802e4b:	85 c0                	test   %eax,%eax
  802e4d:	74 10                	je     802e5f <alloc_block_BF+0x181>
  802e4f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e52:	8b 00                	mov    (%eax),%eax
  802e54:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802e57:	8b 52 04             	mov    0x4(%edx),%edx
  802e5a:	89 50 04             	mov    %edx,0x4(%eax)
  802e5d:	eb 0b                	jmp    802e6a <alloc_block_BF+0x18c>
  802e5f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e62:	8b 40 04             	mov    0x4(%eax),%eax
  802e65:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e6a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e6d:	8b 40 04             	mov    0x4(%eax),%eax
  802e70:	85 c0                	test   %eax,%eax
  802e72:	74 0f                	je     802e83 <alloc_block_BF+0x1a5>
  802e74:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e77:	8b 40 04             	mov    0x4(%eax),%eax
  802e7a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802e7d:	8b 12                	mov    (%edx),%edx
  802e7f:	89 10                	mov    %edx,(%eax)
  802e81:	eb 0a                	jmp    802e8d <alloc_block_BF+0x1af>
  802e83:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e86:	8b 00                	mov    (%eax),%eax
  802e88:	a3 48 51 80 00       	mov    %eax,0x805148
  802e8d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e90:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e96:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e99:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ea0:	a1 54 51 80 00       	mov    0x805154,%eax
  802ea5:	48                   	dec    %eax
  802ea6:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802eab:	83 ec 08             	sub    $0x8,%esp
  802eae:	ff 75 ec             	pushl  -0x14(%ebp)
  802eb1:	68 38 51 80 00       	push   $0x805138
  802eb6:	e8 71 f9 ff ff       	call   80282c <find_block>
  802ebb:	83 c4 10             	add    $0x10,%esp
  802ebe:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802ec1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ec4:	8b 50 08             	mov    0x8(%eax),%edx
  802ec7:	8b 45 08             	mov    0x8(%ebp),%eax
  802eca:	01 c2                	add    %eax,%edx
  802ecc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ecf:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802ed2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ed5:	8b 40 0c             	mov    0xc(%eax),%eax
  802ed8:	2b 45 08             	sub    0x8(%ebp),%eax
  802edb:	89 c2                	mov    %eax,%edx
  802edd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ee0:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802ee3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ee6:	eb 05                	jmp    802eed <alloc_block_BF+0x20f>
	}
	return NULL;
  802ee8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802eed:	c9                   	leave  
  802eee:	c3                   	ret    

00802eef <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802eef:	55                   	push   %ebp
  802ef0:	89 e5                	mov    %esp,%ebp
  802ef2:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802ef5:	a1 28 50 80 00       	mov    0x805028,%eax
  802efa:	85 c0                	test   %eax,%eax
  802efc:	0f 85 de 01 00 00    	jne    8030e0 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802f02:	a1 38 51 80 00       	mov    0x805138,%eax
  802f07:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f0a:	e9 9e 01 00 00       	jmp    8030ad <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802f0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f12:	8b 40 0c             	mov    0xc(%eax),%eax
  802f15:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f18:	0f 82 87 01 00 00    	jb     8030a5 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802f1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f21:	8b 40 0c             	mov    0xc(%eax),%eax
  802f24:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f27:	0f 85 95 00 00 00    	jne    802fc2 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802f2d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f31:	75 17                	jne    802f4a <alloc_block_NF+0x5b>
  802f33:	83 ec 04             	sub    $0x4,%esp
  802f36:	68 d8 48 80 00       	push   $0x8048d8
  802f3b:	68 e0 00 00 00       	push   $0xe0
  802f40:	68 2f 48 80 00       	push   $0x80482f
  802f45:	e8 53 d9 ff ff       	call   80089d <_panic>
  802f4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4d:	8b 00                	mov    (%eax),%eax
  802f4f:	85 c0                	test   %eax,%eax
  802f51:	74 10                	je     802f63 <alloc_block_NF+0x74>
  802f53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f56:	8b 00                	mov    (%eax),%eax
  802f58:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f5b:	8b 52 04             	mov    0x4(%edx),%edx
  802f5e:	89 50 04             	mov    %edx,0x4(%eax)
  802f61:	eb 0b                	jmp    802f6e <alloc_block_NF+0x7f>
  802f63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f66:	8b 40 04             	mov    0x4(%eax),%eax
  802f69:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f71:	8b 40 04             	mov    0x4(%eax),%eax
  802f74:	85 c0                	test   %eax,%eax
  802f76:	74 0f                	je     802f87 <alloc_block_NF+0x98>
  802f78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7b:	8b 40 04             	mov    0x4(%eax),%eax
  802f7e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f81:	8b 12                	mov    (%edx),%edx
  802f83:	89 10                	mov    %edx,(%eax)
  802f85:	eb 0a                	jmp    802f91 <alloc_block_NF+0xa2>
  802f87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8a:	8b 00                	mov    (%eax),%eax
  802f8c:	a3 38 51 80 00       	mov    %eax,0x805138
  802f91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f94:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f9d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fa4:	a1 44 51 80 00       	mov    0x805144,%eax
  802fa9:	48                   	dec    %eax
  802faa:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802faf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb2:	8b 40 08             	mov    0x8(%eax),%eax
  802fb5:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802fba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fbd:	e9 f8 04 00 00       	jmp    8034ba <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802fc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc5:	8b 40 0c             	mov    0xc(%eax),%eax
  802fc8:	3b 45 08             	cmp    0x8(%ebp),%eax
  802fcb:	0f 86 d4 00 00 00    	jbe    8030a5 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802fd1:	a1 48 51 80 00       	mov    0x805148,%eax
  802fd6:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802fd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fdc:	8b 50 08             	mov    0x8(%eax),%edx
  802fdf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fe2:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802fe5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fe8:	8b 55 08             	mov    0x8(%ebp),%edx
  802feb:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802fee:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ff2:	75 17                	jne    80300b <alloc_block_NF+0x11c>
  802ff4:	83 ec 04             	sub    $0x4,%esp
  802ff7:	68 d8 48 80 00       	push   $0x8048d8
  802ffc:	68 e9 00 00 00       	push   $0xe9
  803001:	68 2f 48 80 00       	push   $0x80482f
  803006:	e8 92 d8 ff ff       	call   80089d <_panic>
  80300b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80300e:	8b 00                	mov    (%eax),%eax
  803010:	85 c0                	test   %eax,%eax
  803012:	74 10                	je     803024 <alloc_block_NF+0x135>
  803014:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803017:	8b 00                	mov    (%eax),%eax
  803019:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80301c:	8b 52 04             	mov    0x4(%edx),%edx
  80301f:	89 50 04             	mov    %edx,0x4(%eax)
  803022:	eb 0b                	jmp    80302f <alloc_block_NF+0x140>
  803024:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803027:	8b 40 04             	mov    0x4(%eax),%eax
  80302a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80302f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803032:	8b 40 04             	mov    0x4(%eax),%eax
  803035:	85 c0                	test   %eax,%eax
  803037:	74 0f                	je     803048 <alloc_block_NF+0x159>
  803039:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80303c:	8b 40 04             	mov    0x4(%eax),%eax
  80303f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803042:	8b 12                	mov    (%edx),%edx
  803044:	89 10                	mov    %edx,(%eax)
  803046:	eb 0a                	jmp    803052 <alloc_block_NF+0x163>
  803048:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80304b:	8b 00                	mov    (%eax),%eax
  80304d:	a3 48 51 80 00       	mov    %eax,0x805148
  803052:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803055:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80305b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80305e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803065:	a1 54 51 80 00       	mov    0x805154,%eax
  80306a:	48                   	dec    %eax
  80306b:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  803070:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803073:	8b 40 08             	mov    0x8(%eax),%eax
  803076:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  80307b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80307e:	8b 50 08             	mov    0x8(%eax),%edx
  803081:	8b 45 08             	mov    0x8(%ebp),%eax
  803084:	01 c2                	add    %eax,%edx
  803086:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803089:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  80308c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80308f:	8b 40 0c             	mov    0xc(%eax),%eax
  803092:	2b 45 08             	sub    0x8(%ebp),%eax
  803095:	89 c2                	mov    %eax,%edx
  803097:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80309a:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  80309d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030a0:	e9 15 04 00 00       	jmp    8034ba <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8030a5:	a1 40 51 80 00       	mov    0x805140,%eax
  8030aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030b1:	74 07                	je     8030ba <alloc_block_NF+0x1cb>
  8030b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b6:	8b 00                	mov    (%eax),%eax
  8030b8:	eb 05                	jmp    8030bf <alloc_block_NF+0x1d0>
  8030ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8030bf:	a3 40 51 80 00       	mov    %eax,0x805140
  8030c4:	a1 40 51 80 00       	mov    0x805140,%eax
  8030c9:	85 c0                	test   %eax,%eax
  8030cb:	0f 85 3e fe ff ff    	jne    802f0f <alloc_block_NF+0x20>
  8030d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030d5:	0f 85 34 fe ff ff    	jne    802f0f <alloc_block_NF+0x20>
  8030db:	e9 d5 03 00 00       	jmp    8034b5 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8030e0:	a1 38 51 80 00       	mov    0x805138,%eax
  8030e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030e8:	e9 b1 01 00 00       	jmp    80329e <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  8030ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f0:	8b 50 08             	mov    0x8(%eax),%edx
  8030f3:	a1 28 50 80 00       	mov    0x805028,%eax
  8030f8:	39 c2                	cmp    %eax,%edx
  8030fa:	0f 82 96 01 00 00    	jb     803296 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  803100:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803103:	8b 40 0c             	mov    0xc(%eax),%eax
  803106:	3b 45 08             	cmp    0x8(%ebp),%eax
  803109:	0f 82 87 01 00 00    	jb     803296 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  80310f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803112:	8b 40 0c             	mov    0xc(%eax),%eax
  803115:	3b 45 08             	cmp    0x8(%ebp),%eax
  803118:	0f 85 95 00 00 00    	jne    8031b3 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  80311e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803122:	75 17                	jne    80313b <alloc_block_NF+0x24c>
  803124:	83 ec 04             	sub    $0x4,%esp
  803127:	68 d8 48 80 00       	push   $0x8048d8
  80312c:	68 fc 00 00 00       	push   $0xfc
  803131:	68 2f 48 80 00       	push   $0x80482f
  803136:	e8 62 d7 ff ff       	call   80089d <_panic>
  80313b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80313e:	8b 00                	mov    (%eax),%eax
  803140:	85 c0                	test   %eax,%eax
  803142:	74 10                	je     803154 <alloc_block_NF+0x265>
  803144:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803147:	8b 00                	mov    (%eax),%eax
  803149:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80314c:	8b 52 04             	mov    0x4(%edx),%edx
  80314f:	89 50 04             	mov    %edx,0x4(%eax)
  803152:	eb 0b                	jmp    80315f <alloc_block_NF+0x270>
  803154:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803157:	8b 40 04             	mov    0x4(%eax),%eax
  80315a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80315f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803162:	8b 40 04             	mov    0x4(%eax),%eax
  803165:	85 c0                	test   %eax,%eax
  803167:	74 0f                	je     803178 <alloc_block_NF+0x289>
  803169:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80316c:	8b 40 04             	mov    0x4(%eax),%eax
  80316f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803172:	8b 12                	mov    (%edx),%edx
  803174:	89 10                	mov    %edx,(%eax)
  803176:	eb 0a                	jmp    803182 <alloc_block_NF+0x293>
  803178:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80317b:	8b 00                	mov    (%eax),%eax
  80317d:	a3 38 51 80 00       	mov    %eax,0x805138
  803182:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803185:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80318b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80318e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803195:	a1 44 51 80 00       	mov    0x805144,%eax
  80319a:	48                   	dec    %eax
  80319b:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8031a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a3:	8b 40 08             	mov    0x8(%eax),%eax
  8031a6:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  8031ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ae:	e9 07 03 00 00       	jmp    8034ba <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8031b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b6:	8b 40 0c             	mov    0xc(%eax),%eax
  8031b9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031bc:	0f 86 d4 00 00 00    	jbe    803296 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8031c2:	a1 48 51 80 00       	mov    0x805148,%eax
  8031c7:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  8031ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031cd:	8b 50 08             	mov    0x8(%eax),%edx
  8031d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d3:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8031d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8031dc:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8031df:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031e3:	75 17                	jne    8031fc <alloc_block_NF+0x30d>
  8031e5:	83 ec 04             	sub    $0x4,%esp
  8031e8:	68 d8 48 80 00       	push   $0x8048d8
  8031ed:	68 04 01 00 00       	push   $0x104
  8031f2:	68 2f 48 80 00       	push   $0x80482f
  8031f7:	e8 a1 d6 ff ff       	call   80089d <_panic>
  8031fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ff:	8b 00                	mov    (%eax),%eax
  803201:	85 c0                	test   %eax,%eax
  803203:	74 10                	je     803215 <alloc_block_NF+0x326>
  803205:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803208:	8b 00                	mov    (%eax),%eax
  80320a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80320d:	8b 52 04             	mov    0x4(%edx),%edx
  803210:	89 50 04             	mov    %edx,0x4(%eax)
  803213:	eb 0b                	jmp    803220 <alloc_block_NF+0x331>
  803215:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803218:	8b 40 04             	mov    0x4(%eax),%eax
  80321b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803220:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803223:	8b 40 04             	mov    0x4(%eax),%eax
  803226:	85 c0                	test   %eax,%eax
  803228:	74 0f                	je     803239 <alloc_block_NF+0x34a>
  80322a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80322d:	8b 40 04             	mov    0x4(%eax),%eax
  803230:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803233:	8b 12                	mov    (%edx),%edx
  803235:	89 10                	mov    %edx,(%eax)
  803237:	eb 0a                	jmp    803243 <alloc_block_NF+0x354>
  803239:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80323c:	8b 00                	mov    (%eax),%eax
  80323e:	a3 48 51 80 00       	mov    %eax,0x805148
  803243:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803246:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80324c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80324f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803256:	a1 54 51 80 00       	mov    0x805154,%eax
  80325b:	48                   	dec    %eax
  80325c:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  803261:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803264:	8b 40 08             	mov    0x8(%eax),%eax
  803267:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  80326c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80326f:	8b 50 08             	mov    0x8(%eax),%edx
  803272:	8b 45 08             	mov    0x8(%ebp),%eax
  803275:	01 c2                	add    %eax,%edx
  803277:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80327a:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  80327d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803280:	8b 40 0c             	mov    0xc(%eax),%eax
  803283:	2b 45 08             	sub    0x8(%ebp),%eax
  803286:	89 c2                	mov    %eax,%edx
  803288:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80328b:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  80328e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803291:	e9 24 02 00 00       	jmp    8034ba <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  803296:	a1 40 51 80 00       	mov    0x805140,%eax
  80329b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80329e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032a2:	74 07                	je     8032ab <alloc_block_NF+0x3bc>
  8032a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a7:	8b 00                	mov    (%eax),%eax
  8032a9:	eb 05                	jmp    8032b0 <alloc_block_NF+0x3c1>
  8032ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8032b0:	a3 40 51 80 00       	mov    %eax,0x805140
  8032b5:	a1 40 51 80 00       	mov    0x805140,%eax
  8032ba:	85 c0                	test   %eax,%eax
  8032bc:	0f 85 2b fe ff ff    	jne    8030ed <alloc_block_NF+0x1fe>
  8032c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032c6:	0f 85 21 fe ff ff    	jne    8030ed <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8032cc:	a1 38 51 80 00       	mov    0x805138,%eax
  8032d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032d4:	e9 ae 01 00 00       	jmp    803487 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  8032d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032dc:	8b 50 08             	mov    0x8(%eax),%edx
  8032df:	a1 28 50 80 00       	mov    0x805028,%eax
  8032e4:	39 c2                	cmp    %eax,%edx
  8032e6:	0f 83 93 01 00 00    	jae    80347f <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  8032ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ef:	8b 40 0c             	mov    0xc(%eax),%eax
  8032f2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8032f5:	0f 82 84 01 00 00    	jb     80347f <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  8032fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032fe:	8b 40 0c             	mov    0xc(%eax),%eax
  803301:	3b 45 08             	cmp    0x8(%ebp),%eax
  803304:	0f 85 95 00 00 00    	jne    80339f <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  80330a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80330e:	75 17                	jne    803327 <alloc_block_NF+0x438>
  803310:	83 ec 04             	sub    $0x4,%esp
  803313:	68 d8 48 80 00       	push   $0x8048d8
  803318:	68 14 01 00 00       	push   $0x114
  80331d:	68 2f 48 80 00       	push   $0x80482f
  803322:	e8 76 d5 ff ff       	call   80089d <_panic>
  803327:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80332a:	8b 00                	mov    (%eax),%eax
  80332c:	85 c0                	test   %eax,%eax
  80332e:	74 10                	je     803340 <alloc_block_NF+0x451>
  803330:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803333:	8b 00                	mov    (%eax),%eax
  803335:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803338:	8b 52 04             	mov    0x4(%edx),%edx
  80333b:	89 50 04             	mov    %edx,0x4(%eax)
  80333e:	eb 0b                	jmp    80334b <alloc_block_NF+0x45c>
  803340:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803343:	8b 40 04             	mov    0x4(%eax),%eax
  803346:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80334b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80334e:	8b 40 04             	mov    0x4(%eax),%eax
  803351:	85 c0                	test   %eax,%eax
  803353:	74 0f                	je     803364 <alloc_block_NF+0x475>
  803355:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803358:	8b 40 04             	mov    0x4(%eax),%eax
  80335b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80335e:	8b 12                	mov    (%edx),%edx
  803360:	89 10                	mov    %edx,(%eax)
  803362:	eb 0a                	jmp    80336e <alloc_block_NF+0x47f>
  803364:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803367:	8b 00                	mov    (%eax),%eax
  803369:	a3 38 51 80 00       	mov    %eax,0x805138
  80336e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803371:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803377:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80337a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803381:	a1 44 51 80 00       	mov    0x805144,%eax
  803386:	48                   	dec    %eax
  803387:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  80338c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80338f:	8b 40 08             	mov    0x8(%eax),%eax
  803392:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  803397:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80339a:	e9 1b 01 00 00       	jmp    8034ba <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  80339f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a2:	8b 40 0c             	mov    0xc(%eax),%eax
  8033a5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8033a8:	0f 86 d1 00 00 00    	jbe    80347f <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8033ae:	a1 48 51 80 00       	mov    0x805148,%eax
  8033b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  8033b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b9:	8b 50 08             	mov    0x8(%eax),%edx
  8033bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033bf:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8033c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8033c8:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8033cb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8033cf:	75 17                	jne    8033e8 <alloc_block_NF+0x4f9>
  8033d1:	83 ec 04             	sub    $0x4,%esp
  8033d4:	68 d8 48 80 00       	push   $0x8048d8
  8033d9:	68 1c 01 00 00       	push   $0x11c
  8033de:	68 2f 48 80 00       	push   $0x80482f
  8033e3:	e8 b5 d4 ff ff       	call   80089d <_panic>
  8033e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033eb:	8b 00                	mov    (%eax),%eax
  8033ed:	85 c0                	test   %eax,%eax
  8033ef:	74 10                	je     803401 <alloc_block_NF+0x512>
  8033f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033f4:	8b 00                	mov    (%eax),%eax
  8033f6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8033f9:	8b 52 04             	mov    0x4(%edx),%edx
  8033fc:	89 50 04             	mov    %edx,0x4(%eax)
  8033ff:	eb 0b                	jmp    80340c <alloc_block_NF+0x51d>
  803401:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803404:	8b 40 04             	mov    0x4(%eax),%eax
  803407:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80340c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80340f:	8b 40 04             	mov    0x4(%eax),%eax
  803412:	85 c0                	test   %eax,%eax
  803414:	74 0f                	je     803425 <alloc_block_NF+0x536>
  803416:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803419:	8b 40 04             	mov    0x4(%eax),%eax
  80341c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80341f:	8b 12                	mov    (%edx),%edx
  803421:	89 10                	mov    %edx,(%eax)
  803423:	eb 0a                	jmp    80342f <alloc_block_NF+0x540>
  803425:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803428:	8b 00                	mov    (%eax),%eax
  80342a:	a3 48 51 80 00       	mov    %eax,0x805148
  80342f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803432:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803438:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80343b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803442:	a1 54 51 80 00       	mov    0x805154,%eax
  803447:	48                   	dec    %eax
  803448:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  80344d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803450:	8b 40 08             	mov    0x8(%eax),%eax
  803453:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  803458:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80345b:	8b 50 08             	mov    0x8(%eax),%edx
  80345e:	8b 45 08             	mov    0x8(%ebp),%eax
  803461:	01 c2                	add    %eax,%edx
  803463:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803466:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803469:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80346c:	8b 40 0c             	mov    0xc(%eax),%eax
  80346f:	2b 45 08             	sub    0x8(%ebp),%eax
  803472:	89 c2                	mov    %eax,%edx
  803474:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803477:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  80347a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80347d:	eb 3b                	jmp    8034ba <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  80347f:	a1 40 51 80 00       	mov    0x805140,%eax
  803484:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803487:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80348b:	74 07                	je     803494 <alloc_block_NF+0x5a5>
  80348d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803490:	8b 00                	mov    (%eax),%eax
  803492:	eb 05                	jmp    803499 <alloc_block_NF+0x5aa>
  803494:	b8 00 00 00 00       	mov    $0x0,%eax
  803499:	a3 40 51 80 00       	mov    %eax,0x805140
  80349e:	a1 40 51 80 00       	mov    0x805140,%eax
  8034a3:	85 c0                	test   %eax,%eax
  8034a5:	0f 85 2e fe ff ff    	jne    8032d9 <alloc_block_NF+0x3ea>
  8034ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034af:	0f 85 24 fe ff ff    	jne    8032d9 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  8034b5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8034ba:	c9                   	leave  
  8034bb:	c3                   	ret    

008034bc <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8034bc:	55                   	push   %ebp
  8034bd:	89 e5                	mov    %esp,%ebp
  8034bf:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  8034c2:	a1 38 51 80 00       	mov    0x805138,%eax
  8034c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  8034ca:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8034cf:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  8034d2:	a1 38 51 80 00       	mov    0x805138,%eax
  8034d7:	85 c0                	test   %eax,%eax
  8034d9:	74 14                	je     8034ef <insert_sorted_with_merge_freeList+0x33>
  8034db:	8b 45 08             	mov    0x8(%ebp),%eax
  8034de:	8b 50 08             	mov    0x8(%eax),%edx
  8034e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034e4:	8b 40 08             	mov    0x8(%eax),%eax
  8034e7:	39 c2                	cmp    %eax,%edx
  8034e9:	0f 87 9b 01 00 00    	ja     80368a <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  8034ef:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034f3:	75 17                	jne    80350c <insert_sorted_with_merge_freeList+0x50>
  8034f5:	83 ec 04             	sub    $0x4,%esp
  8034f8:	68 0c 48 80 00       	push   $0x80480c
  8034fd:	68 38 01 00 00       	push   $0x138
  803502:	68 2f 48 80 00       	push   $0x80482f
  803507:	e8 91 d3 ff ff       	call   80089d <_panic>
  80350c:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803512:	8b 45 08             	mov    0x8(%ebp),%eax
  803515:	89 10                	mov    %edx,(%eax)
  803517:	8b 45 08             	mov    0x8(%ebp),%eax
  80351a:	8b 00                	mov    (%eax),%eax
  80351c:	85 c0                	test   %eax,%eax
  80351e:	74 0d                	je     80352d <insert_sorted_with_merge_freeList+0x71>
  803520:	a1 38 51 80 00       	mov    0x805138,%eax
  803525:	8b 55 08             	mov    0x8(%ebp),%edx
  803528:	89 50 04             	mov    %edx,0x4(%eax)
  80352b:	eb 08                	jmp    803535 <insert_sorted_with_merge_freeList+0x79>
  80352d:	8b 45 08             	mov    0x8(%ebp),%eax
  803530:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803535:	8b 45 08             	mov    0x8(%ebp),%eax
  803538:	a3 38 51 80 00       	mov    %eax,0x805138
  80353d:	8b 45 08             	mov    0x8(%ebp),%eax
  803540:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803547:	a1 44 51 80 00       	mov    0x805144,%eax
  80354c:	40                   	inc    %eax
  80354d:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803552:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803556:	0f 84 a8 06 00 00    	je     803c04 <insert_sorted_with_merge_freeList+0x748>
  80355c:	8b 45 08             	mov    0x8(%ebp),%eax
  80355f:	8b 50 08             	mov    0x8(%eax),%edx
  803562:	8b 45 08             	mov    0x8(%ebp),%eax
  803565:	8b 40 0c             	mov    0xc(%eax),%eax
  803568:	01 c2                	add    %eax,%edx
  80356a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80356d:	8b 40 08             	mov    0x8(%eax),%eax
  803570:	39 c2                	cmp    %eax,%edx
  803572:	0f 85 8c 06 00 00    	jne    803c04 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  803578:	8b 45 08             	mov    0x8(%ebp),%eax
  80357b:	8b 50 0c             	mov    0xc(%eax),%edx
  80357e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803581:	8b 40 0c             	mov    0xc(%eax),%eax
  803584:	01 c2                	add    %eax,%edx
  803586:	8b 45 08             	mov    0x8(%ebp),%eax
  803589:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  80358c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803590:	75 17                	jne    8035a9 <insert_sorted_with_merge_freeList+0xed>
  803592:	83 ec 04             	sub    $0x4,%esp
  803595:	68 d8 48 80 00       	push   $0x8048d8
  80359a:	68 3c 01 00 00       	push   $0x13c
  80359f:	68 2f 48 80 00       	push   $0x80482f
  8035a4:	e8 f4 d2 ff ff       	call   80089d <_panic>
  8035a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035ac:	8b 00                	mov    (%eax),%eax
  8035ae:	85 c0                	test   %eax,%eax
  8035b0:	74 10                	je     8035c2 <insert_sorted_with_merge_freeList+0x106>
  8035b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035b5:	8b 00                	mov    (%eax),%eax
  8035b7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035ba:	8b 52 04             	mov    0x4(%edx),%edx
  8035bd:	89 50 04             	mov    %edx,0x4(%eax)
  8035c0:	eb 0b                	jmp    8035cd <insert_sorted_with_merge_freeList+0x111>
  8035c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035c5:	8b 40 04             	mov    0x4(%eax),%eax
  8035c8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8035cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035d0:	8b 40 04             	mov    0x4(%eax),%eax
  8035d3:	85 c0                	test   %eax,%eax
  8035d5:	74 0f                	je     8035e6 <insert_sorted_with_merge_freeList+0x12a>
  8035d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035da:	8b 40 04             	mov    0x4(%eax),%eax
  8035dd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035e0:	8b 12                	mov    (%edx),%edx
  8035e2:	89 10                	mov    %edx,(%eax)
  8035e4:	eb 0a                	jmp    8035f0 <insert_sorted_with_merge_freeList+0x134>
  8035e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035e9:	8b 00                	mov    (%eax),%eax
  8035eb:	a3 38 51 80 00       	mov    %eax,0x805138
  8035f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035f3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035fc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803603:	a1 44 51 80 00       	mov    0x805144,%eax
  803608:	48                   	dec    %eax
  803609:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  80360e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803611:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  803618:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80361b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  803622:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803626:	75 17                	jne    80363f <insert_sorted_with_merge_freeList+0x183>
  803628:	83 ec 04             	sub    $0x4,%esp
  80362b:	68 0c 48 80 00       	push   $0x80480c
  803630:	68 3f 01 00 00       	push   $0x13f
  803635:	68 2f 48 80 00       	push   $0x80482f
  80363a:	e8 5e d2 ff ff       	call   80089d <_panic>
  80363f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803645:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803648:	89 10                	mov    %edx,(%eax)
  80364a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80364d:	8b 00                	mov    (%eax),%eax
  80364f:	85 c0                	test   %eax,%eax
  803651:	74 0d                	je     803660 <insert_sorted_with_merge_freeList+0x1a4>
  803653:	a1 48 51 80 00       	mov    0x805148,%eax
  803658:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80365b:	89 50 04             	mov    %edx,0x4(%eax)
  80365e:	eb 08                	jmp    803668 <insert_sorted_with_merge_freeList+0x1ac>
  803660:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803663:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803668:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80366b:	a3 48 51 80 00       	mov    %eax,0x805148
  803670:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803673:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80367a:	a1 54 51 80 00       	mov    0x805154,%eax
  80367f:	40                   	inc    %eax
  803680:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803685:	e9 7a 05 00 00       	jmp    803c04 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  80368a:	8b 45 08             	mov    0x8(%ebp),%eax
  80368d:	8b 50 08             	mov    0x8(%eax),%edx
  803690:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803693:	8b 40 08             	mov    0x8(%eax),%eax
  803696:	39 c2                	cmp    %eax,%edx
  803698:	0f 82 14 01 00 00    	jb     8037b2 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  80369e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036a1:	8b 50 08             	mov    0x8(%eax),%edx
  8036a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036a7:	8b 40 0c             	mov    0xc(%eax),%eax
  8036aa:	01 c2                	add    %eax,%edx
  8036ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8036af:	8b 40 08             	mov    0x8(%eax),%eax
  8036b2:	39 c2                	cmp    %eax,%edx
  8036b4:	0f 85 90 00 00 00    	jne    80374a <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  8036ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036bd:	8b 50 0c             	mov    0xc(%eax),%edx
  8036c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8036c3:	8b 40 0c             	mov    0xc(%eax),%eax
  8036c6:	01 c2                	add    %eax,%edx
  8036c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036cb:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  8036ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  8036d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8036db:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8036e2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036e6:	75 17                	jne    8036ff <insert_sorted_with_merge_freeList+0x243>
  8036e8:	83 ec 04             	sub    $0x4,%esp
  8036eb:	68 0c 48 80 00       	push   $0x80480c
  8036f0:	68 49 01 00 00       	push   $0x149
  8036f5:	68 2f 48 80 00       	push   $0x80482f
  8036fa:	e8 9e d1 ff ff       	call   80089d <_panic>
  8036ff:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803705:	8b 45 08             	mov    0x8(%ebp),%eax
  803708:	89 10                	mov    %edx,(%eax)
  80370a:	8b 45 08             	mov    0x8(%ebp),%eax
  80370d:	8b 00                	mov    (%eax),%eax
  80370f:	85 c0                	test   %eax,%eax
  803711:	74 0d                	je     803720 <insert_sorted_with_merge_freeList+0x264>
  803713:	a1 48 51 80 00       	mov    0x805148,%eax
  803718:	8b 55 08             	mov    0x8(%ebp),%edx
  80371b:	89 50 04             	mov    %edx,0x4(%eax)
  80371e:	eb 08                	jmp    803728 <insert_sorted_with_merge_freeList+0x26c>
  803720:	8b 45 08             	mov    0x8(%ebp),%eax
  803723:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803728:	8b 45 08             	mov    0x8(%ebp),%eax
  80372b:	a3 48 51 80 00       	mov    %eax,0x805148
  803730:	8b 45 08             	mov    0x8(%ebp),%eax
  803733:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80373a:	a1 54 51 80 00       	mov    0x805154,%eax
  80373f:	40                   	inc    %eax
  803740:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803745:	e9 bb 04 00 00       	jmp    803c05 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  80374a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80374e:	75 17                	jne    803767 <insert_sorted_with_merge_freeList+0x2ab>
  803750:	83 ec 04             	sub    $0x4,%esp
  803753:	68 80 48 80 00       	push   $0x804880
  803758:	68 4c 01 00 00       	push   $0x14c
  80375d:	68 2f 48 80 00       	push   $0x80482f
  803762:	e8 36 d1 ff ff       	call   80089d <_panic>
  803767:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  80376d:	8b 45 08             	mov    0x8(%ebp),%eax
  803770:	89 50 04             	mov    %edx,0x4(%eax)
  803773:	8b 45 08             	mov    0x8(%ebp),%eax
  803776:	8b 40 04             	mov    0x4(%eax),%eax
  803779:	85 c0                	test   %eax,%eax
  80377b:	74 0c                	je     803789 <insert_sorted_with_merge_freeList+0x2cd>
  80377d:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803782:	8b 55 08             	mov    0x8(%ebp),%edx
  803785:	89 10                	mov    %edx,(%eax)
  803787:	eb 08                	jmp    803791 <insert_sorted_with_merge_freeList+0x2d5>
  803789:	8b 45 08             	mov    0x8(%ebp),%eax
  80378c:	a3 38 51 80 00       	mov    %eax,0x805138
  803791:	8b 45 08             	mov    0x8(%ebp),%eax
  803794:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803799:	8b 45 08             	mov    0x8(%ebp),%eax
  80379c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037a2:	a1 44 51 80 00       	mov    0x805144,%eax
  8037a7:	40                   	inc    %eax
  8037a8:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8037ad:	e9 53 04 00 00       	jmp    803c05 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8037b2:	a1 38 51 80 00       	mov    0x805138,%eax
  8037b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8037ba:	e9 15 04 00 00       	jmp    803bd4 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  8037bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037c2:	8b 00                	mov    (%eax),%eax
  8037c4:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  8037c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ca:	8b 50 08             	mov    0x8(%eax),%edx
  8037cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037d0:	8b 40 08             	mov    0x8(%eax),%eax
  8037d3:	39 c2                	cmp    %eax,%edx
  8037d5:	0f 86 f1 03 00 00    	jbe    803bcc <insert_sorted_with_merge_freeList+0x710>
  8037db:	8b 45 08             	mov    0x8(%ebp),%eax
  8037de:	8b 50 08             	mov    0x8(%eax),%edx
  8037e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037e4:	8b 40 08             	mov    0x8(%eax),%eax
  8037e7:	39 c2                	cmp    %eax,%edx
  8037e9:	0f 83 dd 03 00 00    	jae    803bcc <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  8037ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037f2:	8b 50 08             	mov    0x8(%eax),%edx
  8037f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037f8:	8b 40 0c             	mov    0xc(%eax),%eax
  8037fb:	01 c2                	add    %eax,%edx
  8037fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803800:	8b 40 08             	mov    0x8(%eax),%eax
  803803:	39 c2                	cmp    %eax,%edx
  803805:	0f 85 b9 01 00 00    	jne    8039c4 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80380b:	8b 45 08             	mov    0x8(%ebp),%eax
  80380e:	8b 50 08             	mov    0x8(%eax),%edx
  803811:	8b 45 08             	mov    0x8(%ebp),%eax
  803814:	8b 40 0c             	mov    0xc(%eax),%eax
  803817:	01 c2                	add    %eax,%edx
  803819:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80381c:	8b 40 08             	mov    0x8(%eax),%eax
  80381f:	39 c2                	cmp    %eax,%edx
  803821:	0f 85 0d 01 00 00    	jne    803934 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803827:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80382a:	8b 50 0c             	mov    0xc(%eax),%edx
  80382d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803830:	8b 40 0c             	mov    0xc(%eax),%eax
  803833:	01 c2                	add    %eax,%edx
  803835:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803838:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80383b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80383f:	75 17                	jne    803858 <insert_sorted_with_merge_freeList+0x39c>
  803841:	83 ec 04             	sub    $0x4,%esp
  803844:	68 d8 48 80 00       	push   $0x8048d8
  803849:	68 5c 01 00 00       	push   $0x15c
  80384e:	68 2f 48 80 00       	push   $0x80482f
  803853:	e8 45 d0 ff ff       	call   80089d <_panic>
  803858:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80385b:	8b 00                	mov    (%eax),%eax
  80385d:	85 c0                	test   %eax,%eax
  80385f:	74 10                	je     803871 <insert_sorted_with_merge_freeList+0x3b5>
  803861:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803864:	8b 00                	mov    (%eax),%eax
  803866:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803869:	8b 52 04             	mov    0x4(%edx),%edx
  80386c:	89 50 04             	mov    %edx,0x4(%eax)
  80386f:	eb 0b                	jmp    80387c <insert_sorted_with_merge_freeList+0x3c0>
  803871:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803874:	8b 40 04             	mov    0x4(%eax),%eax
  803877:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80387c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80387f:	8b 40 04             	mov    0x4(%eax),%eax
  803882:	85 c0                	test   %eax,%eax
  803884:	74 0f                	je     803895 <insert_sorted_with_merge_freeList+0x3d9>
  803886:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803889:	8b 40 04             	mov    0x4(%eax),%eax
  80388c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80388f:	8b 12                	mov    (%edx),%edx
  803891:	89 10                	mov    %edx,(%eax)
  803893:	eb 0a                	jmp    80389f <insert_sorted_with_merge_freeList+0x3e3>
  803895:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803898:	8b 00                	mov    (%eax),%eax
  80389a:	a3 38 51 80 00       	mov    %eax,0x805138
  80389f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038ab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038b2:	a1 44 51 80 00       	mov    0x805144,%eax
  8038b7:	48                   	dec    %eax
  8038b8:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  8038bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038c0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8038c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038ca:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8038d1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8038d5:	75 17                	jne    8038ee <insert_sorted_with_merge_freeList+0x432>
  8038d7:	83 ec 04             	sub    $0x4,%esp
  8038da:	68 0c 48 80 00       	push   $0x80480c
  8038df:	68 5f 01 00 00       	push   $0x15f
  8038e4:	68 2f 48 80 00       	push   $0x80482f
  8038e9:	e8 af cf ff ff       	call   80089d <_panic>
  8038ee:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8038f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038f7:	89 10                	mov    %edx,(%eax)
  8038f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038fc:	8b 00                	mov    (%eax),%eax
  8038fe:	85 c0                	test   %eax,%eax
  803900:	74 0d                	je     80390f <insert_sorted_with_merge_freeList+0x453>
  803902:	a1 48 51 80 00       	mov    0x805148,%eax
  803907:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80390a:	89 50 04             	mov    %edx,0x4(%eax)
  80390d:	eb 08                	jmp    803917 <insert_sorted_with_merge_freeList+0x45b>
  80390f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803912:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803917:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80391a:	a3 48 51 80 00       	mov    %eax,0x805148
  80391f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803922:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803929:	a1 54 51 80 00       	mov    0x805154,%eax
  80392e:	40                   	inc    %eax
  80392f:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803934:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803937:	8b 50 0c             	mov    0xc(%eax),%edx
  80393a:	8b 45 08             	mov    0x8(%ebp),%eax
  80393d:	8b 40 0c             	mov    0xc(%eax),%eax
  803940:	01 c2                	add    %eax,%edx
  803942:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803945:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803948:	8b 45 08             	mov    0x8(%ebp),%eax
  80394b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803952:	8b 45 08             	mov    0x8(%ebp),%eax
  803955:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80395c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803960:	75 17                	jne    803979 <insert_sorted_with_merge_freeList+0x4bd>
  803962:	83 ec 04             	sub    $0x4,%esp
  803965:	68 0c 48 80 00       	push   $0x80480c
  80396a:	68 64 01 00 00       	push   $0x164
  80396f:	68 2f 48 80 00       	push   $0x80482f
  803974:	e8 24 cf ff ff       	call   80089d <_panic>
  803979:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80397f:	8b 45 08             	mov    0x8(%ebp),%eax
  803982:	89 10                	mov    %edx,(%eax)
  803984:	8b 45 08             	mov    0x8(%ebp),%eax
  803987:	8b 00                	mov    (%eax),%eax
  803989:	85 c0                	test   %eax,%eax
  80398b:	74 0d                	je     80399a <insert_sorted_with_merge_freeList+0x4de>
  80398d:	a1 48 51 80 00       	mov    0x805148,%eax
  803992:	8b 55 08             	mov    0x8(%ebp),%edx
  803995:	89 50 04             	mov    %edx,0x4(%eax)
  803998:	eb 08                	jmp    8039a2 <insert_sorted_with_merge_freeList+0x4e6>
  80399a:	8b 45 08             	mov    0x8(%ebp),%eax
  80399d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8039a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8039a5:	a3 48 51 80 00       	mov    %eax,0x805148
  8039aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8039ad:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039b4:	a1 54 51 80 00       	mov    0x805154,%eax
  8039b9:	40                   	inc    %eax
  8039ba:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8039bf:	e9 41 02 00 00       	jmp    803c05 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8039c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8039c7:	8b 50 08             	mov    0x8(%eax),%edx
  8039ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8039cd:	8b 40 0c             	mov    0xc(%eax),%eax
  8039d0:	01 c2                	add    %eax,%edx
  8039d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039d5:	8b 40 08             	mov    0x8(%eax),%eax
  8039d8:	39 c2                	cmp    %eax,%edx
  8039da:	0f 85 7c 01 00 00    	jne    803b5c <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8039e0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8039e4:	74 06                	je     8039ec <insert_sorted_with_merge_freeList+0x530>
  8039e6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8039ea:	75 17                	jne    803a03 <insert_sorted_with_merge_freeList+0x547>
  8039ec:	83 ec 04             	sub    $0x4,%esp
  8039ef:	68 48 48 80 00       	push   $0x804848
  8039f4:	68 69 01 00 00       	push   $0x169
  8039f9:	68 2f 48 80 00       	push   $0x80482f
  8039fe:	e8 9a ce ff ff       	call   80089d <_panic>
  803a03:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a06:	8b 50 04             	mov    0x4(%eax),%edx
  803a09:	8b 45 08             	mov    0x8(%ebp),%eax
  803a0c:	89 50 04             	mov    %edx,0x4(%eax)
  803a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  803a12:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803a15:	89 10                	mov    %edx,(%eax)
  803a17:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a1a:	8b 40 04             	mov    0x4(%eax),%eax
  803a1d:	85 c0                	test   %eax,%eax
  803a1f:	74 0d                	je     803a2e <insert_sorted_with_merge_freeList+0x572>
  803a21:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a24:	8b 40 04             	mov    0x4(%eax),%eax
  803a27:	8b 55 08             	mov    0x8(%ebp),%edx
  803a2a:	89 10                	mov    %edx,(%eax)
  803a2c:	eb 08                	jmp    803a36 <insert_sorted_with_merge_freeList+0x57a>
  803a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  803a31:	a3 38 51 80 00       	mov    %eax,0x805138
  803a36:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a39:	8b 55 08             	mov    0x8(%ebp),%edx
  803a3c:	89 50 04             	mov    %edx,0x4(%eax)
  803a3f:	a1 44 51 80 00       	mov    0x805144,%eax
  803a44:	40                   	inc    %eax
  803a45:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  803a4d:	8b 50 0c             	mov    0xc(%eax),%edx
  803a50:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a53:	8b 40 0c             	mov    0xc(%eax),%eax
  803a56:	01 c2                	add    %eax,%edx
  803a58:	8b 45 08             	mov    0x8(%ebp),%eax
  803a5b:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803a5e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803a62:	75 17                	jne    803a7b <insert_sorted_with_merge_freeList+0x5bf>
  803a64:	83 ec 04             	sub    $0x4,%esp
  803a67:	68 d8 48 80 00       	push   $0x8048d8
  803a6c:	68 6b 01 00 00       	push   $0x16b
  803a71:	68 2f 48 80 00       	push   $0x80482f
  803a76:	e8 22 ce ff ff       	call   80089d <_panic>
  803a7b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a7e:	8b 00                	mov    (%eax),%eax
  803a80:	85 c0                	test   %eax,%eax
  803a82:	74 10                	je     803a94 <insert_sorted_with_merge_freeList+0x5d8>
  803a84:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a87:	8b 00                	mov    (%eax),%eax
  803a89:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803a8c:	8b 52 04             	mov    0x4(%edx),%edx
  803a8f:	89 50 04             	mov    %edx,0x4(%eax)
  803a92:	eb 0b                	jmp    803a9f <insert_sorted_with_merge_freeList+0x5e3>
  803a94:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a97:	8b 40 04             	mov    0x4(%eax),%eax
  803a9a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803a9f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803aa2:	8b 40 04             	mov    0x4(%eax),%eax
  803aa5:	85 c0                	test   %eax,%eax
  803aa7:	74 0f                	je     803ab8 <insert_sorted_with_merge_freeList+0x5fc>
  803aa9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803aac:	8b 40 04             	mov    0x4(%eax),%eax
  803aaf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803ab2:	8b 12                	mov    (%edx),%edx
  803ab4:	89 10                	mov    %edx,(%eax)
  803ab6:	eb 0a                	jmp    803ac2 <insert_sorted_with_merge_freeList+0x606>
  803ab8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803abb:	8b 00                	mov    (%eax),%eax
  803abd:	a3 38 51 80 00       	mov    %eax,0x805138
  803ac2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ac5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803acb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ace:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ad5:	a1 44 51 80 00       	mov    0x805144,%eax
  803ada:	48                   	dec    %eax
  803adb:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803ae0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ae3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803aea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803aed:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803af4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803af8:	75 17                	jne    803b11 <insert_sorted_with_merge_freeList+0x655>
  803afa:	83 ec 04             	sub    $0x4,%esp
  803afd:	68 0c 48 80 00       	push   $0x80480c
  803b02:	68 6e 01 00 00       	push   $0x16e
  803b07:	68 2f 48 80 00       	push   $0x80482f
  803b0c:	e8 8c cd ff ff       	call   80089d <_panic>
  803b11:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803b17:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b1a:	89 10                	mov    %edx,(%eax)
  803b1c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b1f:	8b 00                	mov    (%eax),%eax
  803b21:	85 c0                	test   %eax,%eax
  803b23:	74 0d                	je     803b32 <insert_sorted_with_merge_freeList+0x676>
  803b25:	a1 48 51 80 00       	mov    0x805148,%eax
  803b2a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803b2d:	89 50 04             	mov    %edx,0x4(%eax)
  803b30:	eb 08                	jmp    803b3a <insert_sorted_with_merge_freeList+0x67e>
  803b32:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b35:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803b3a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b3d:	a3 48 51 80 00       	mov    %eax,0x805148
  803b42:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b45:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b4c:	a1 54 51 80 00       	mov    0x805154,%eax
  803b51:	40                   	inc    %eax
  803b52:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803b57:	e9 a9 00 00 00       	jmp    803c05 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803b5c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b60:	74 06                	je     803b68 <insert_sorted_with_merge_freeList+0x6ac>
  803b62:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803b66:	75 17                	jne    803b7f <insert_sorted_with_merge_freeList+0x6c3>
  803b68:	83 ec 04             	sub    $0x4,%esp
  803b6b:	68 a4 48 80 00       	push   $0x8048a4
  803b70:	68 73 01 00 00       	push   $0x173
  803b75:	68 2f 48 80 00       	push   $0x80482f
  803b7a:	e8 1e cd ff ff       	call   80089d <_panic>
  803b7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b82:	8b 10                	mov    (%eax),%edx
  803b84:	8b 45 08             	mov    0x8(%ebp),%eax
  803b87:	89 10                	mov    %edx,(%eax)
  803b89:	8b 45 08             	mov    0x8(%ebp),%eax
  803b8c:	8b 00                	mov    (%eax),%eax
  803b8e:	85 c0                	test   %eax,%eax
  803b90:	74 0b                	je     803b9d <insert_sorted_with_merge_freeList+0x6e1>
  803b92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b95:	8b 00                	mov    (%eax),%eax
  803b97:	8b 55 08             	mov    0x8(%ebp),%edx
  803b9a:	89 50 04             	mov    %edx,0x4(%eax)
  803b9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ba0:	8b 55 08             	mov    0x8(%ebp),%edx
  803ba3:	89 10                	mov    %edx,(%eax)
  803ba5:	8b 45 08             	mov    0x8(%ebp),%eax
  803ba8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803bab:	89 50 04             	mov    %edx,0x4(%eax)
  803bae:	8b 45 08             	mov    0x8(%ebp),%eax
  803bb1:	8b 00                	mov    (%eax),%eax
  803bb3:	85 c0                	test   %eax,%eax
  803bb5:	75 08                	jne    803bbf <insert_sorted_with_merge_freeList+0x703>
  803bb7:	8b 45 08             	mov    0x8(%ebp),%eax
  803bba:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803bbf:	a1 44 51 80 00       	mov    0x805144,%eax
  803bc4:	40                   	inc    %eax
  803bc5:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803bca:	eb 39                	jmp    803c05 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803bcc:	a1 40 51 80 00       	mov    0x805140,%eax
  803bd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803bd4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803bd8:	74 07                	je     803be1 <insert_sorted_with_merge_freeList+0x725>
  803bda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bdd:	8b 00                	mov    (%eax),%eax
  803bdf:	eb 05                	jmp    803be6 <insert_sorted_with_merge_freeList+0x72a>
  803be1:	b8 00 00 00 00       	mov    $0x0,%eax
  803be6:	a3 40 51 80 00       	mov    %eax,0x805140
  803beb:	a1 40 51 80 00       	mov    0x805140,%eax
  803bf0:	85 c0                	test   %eax,%eax
  803bf2:	0f 85 c7 fb ff ff    	jne    8037bf <insert_sorted_with_merge_freeList+0x303>
  803bf8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803bfc:	0f 85 bd fb ff ff    	jne    8037bf <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803c02:	eb 01                	jmp    803c05 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803c04:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803c05:	90                   	nop
  803c06:	c9                   	leave  
  803c07:	c3                   	ret    

00803c08 <__udivdi3>:
  803c08:	55                   	push   %ebp
  803c09:	57                   	push   %edi
  803c0a:	56                   	push   %esi
  803c0b:	53                   	push   %ebx
  803c0c:	83 ec 1c             	sub    $0x1c,%esp
  803c0f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803c13:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803c17:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803c1b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803c1f:	89 ca                	mov    %ecx,%edx
  803c21:	89 f8                	mov    %edi,%eax
  803c23:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803c27:	85 f6                	test   %esi,%esi
  803c29:	75 2d                	jne    803c58 <__udivdi3+0x50>
  803c2b:	39 cf                	cmp    %ecx,%edi
  803c2d:	77 65                	ja     803c94 <__udivdi3+0x8c>
  803c2f:	89 fd                	mov    %edi,%ebp
  803c31:	85 ff                	test   %edi,%edi
  803c33:	75 0b                	jne    803c40 <__udivdi3+0x38>
  803c35:	b8 01 00 00 00       	mov    $0x1,%eax
  803c3a:	31 d2                	xor    %edx,%edx
  803c3c:	f7 f7                	div    %edi
  803c3e:	89 c5                	mov    %eax,%ebp
  803c40:	31 d2                	xor    %edx,%edx
  803c42:	89 c8                	mov    %ecx,%eax
  803c44:	f7 f5                	div    %ebp
  803c46:	89 c1                	mov    %eax,%ecx
  803c48:	89 d8                	mov    %ebx,%eax
  803c4a:	f7 f5                	div    %ebp
  803c4c:	89 cf                	mov    %ecx,%edi
  803c4e:	89 fa                	mov    %edi,%edx
  803c50:	83 c4 1c             	add    $0x1c,%esp
  803c53:	5b                   	pop    %ebx
  803c54:	5e                   	pop    %esi
  803c55:	5f                   	pop    %edi
  803c56:	5d                   	pop    %ebp
  803c57:	c3                   	ret    
  803c58:	39 ce                	cmp    %ecx,%esi
  803c5a:	77 28                	ja     803c84 <__udivdi3+0x7c>
  803c5c:	0f bd fe             	bsr    %esi,%edi
  803c5f:	83 f7 1f             	xor    $0x1f,%edi
  803c62:	75 40                	jne    803ca4 <__udivdi3+0x9c>
  803c64:	39 ce                	cmp    %ecx,%esi
  803c66:	72 0a                	jb     803c72 <__udivdi3+0x6a>
  803c68:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803c6c:	0f 87 9e 00 00 00    	ja     803d10 <__udivdi3+0x108>
  803c72:	b8 01 00 00 00       	mov    $0x1,%eax
  803c77:	89 fa                	mov    %edi,%edx
  803c79:	83 c4 1c             	add    $0x1c,%esp
  803c7c:	5b                   	pop    %ebx
  803c7d:	5e                   	pop    %esi
  803c7e:	5f                   	pop    %edi
  803c7f:	5d                   	pop    %ebp
  803c80:	c3                   	ret    
  803c81:	8d 76 00             	lea    0x0(%esi),%esi
  803c84:	31 ff                	xor    %edi,%edi
  803c86:	31 c0                	xor    %eax,%eax
  803c88:	89 fa                	mov    %edi,%edx
  803c8a:	83 c4 1c             	add    $0x1c,%esp
  803c8d:	5b                   	pop    %ebx
  803c8e:	5e                   	pop    %esi
  803c8f:	5f                   	pop    %edi
  803c90:	5d                   	pop    %ebp
  803c91:	c3                   	ret    
  803c92:	66 90                	xchg   %ax,%ax
  803c94:	89 d8                	mov    %ebx,%eax
  803c96:	f7 f7                	div    %edi
  803c98:	31 ff                	xor    %edi,%edi
  803c9a:	89 fa                	mov    %edi,%edx
  803c9c:	83 c4 1c             	add    $0x1c,%esp
  803c9f:	5b                   	pop    %ebx
  803ca0:	5e                   	pop    %esi
  803ca1:	5f                   	pop    %edi
  803ca2:	5d                   	pop    %ebp
  803ca3:	c3                   	ret    
  803ca4:	bd 20 00 00 00       	mov    $0x20,%ebp
  803ca9:	89 eb                	mov    %ebp,%ebx
  803cab:	29 fb                	sub    %edi,%ebx
  803cad:	89 f9                	mov    %edi,%ecx
  803caf:	d3 e6                	shl    %cl,%esi
  803cb1:	89 c5                	mov    %eax,%ebp
  803cb3:	88 d9                	mov    %bl,%cl
  803cb5:	d3 ed                	shr    %cl,%ebp
  803cb7:	89 e9                	mov    %ebp,%ecx
  803cb9:	09 f1                	or     %esi,%ecx
  803cbb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803cbf:	89 f9                	mov    %edi,%ecx
  803cc1:	d3 e0                	shl    %cl,%eax
  803cc3:	89 c5                	mov    %eax,%ebp
  803cc5:	89 d6                	mov    %edx,%esi
  803cc7:	88 d9                	mov    %bl,%cl
  803cc9:	d3 ee                	shr    %cl,%esi
  803ccb:	89 f9                	mov    %edi,%ecx
  803ccd:	d3 e2                	shl    %cl,%edx
  803ccf:	8b 44 24 08          	mov    0x8(%esp),%eax
  803cd3:	88 d9                	mov    %bl,%cl
  803cd5:	d3 e8                	shr    %cl,%eax
  803cd7:	09 c2                	or     %eax,%edx
  803cd9:	89 d0                	mov    %edx,%eax
  803cdb:	89 f2                	mov    %esi,%edx
  803cdd:	f7 74 24 0c          	divl   0xc(%esp)
  803ce1:	89 d6                	mov    %edx,%esi
  803ce3:	89 c3                	mov    %eax,%ebx
  803ce5:	f7 e5                	mul    %ebp
  803ce7:	39 d6                	cmp    %edx,%esi
  803ce9:	72 19                	jb     803d04 <__udivdi3+0xfc>
  803ceb:	74 0b                	je     803cf8 <__udivdi3+0xf0>
  803ced:	89 d8                	mov    %ebx,%eax
  803cef:	31 ff                	xor    %edi,%edi
  803cf1:	e9 58 ff ff ff       	jmp    803c4e <__udivdi3+0x46>
  803cf6:	66 90                	xchg   %ax,%ax
  803cf8:	8b 54 24 08          	mov    0x8(%esp),%edx
  803cfc:	89 f9                	mov    %edi,%ecx
  803cfe:	d3 e2                	shl    %cl,%edx
  803d00:	39 c2                	cmp    %eax,%edx
  803d02:	73 e9                	jae    803ced <__udivdi3+0xe5>
  803d04:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803d07:	31 ff                	xor    %edi,%edi
  803d09:	e9 40 ff ff ff       	jmp    803c4e <__udivdi3+0x46>
  803d0e:	66 90                	xchg   %ax,%ax
  803d10:	31 c0                	xor    %eax,%eax
  803d12:	e9 37 ff ff ff       	jmp    803c4e <__udivdi3+0x46>
  803d17:	90                   	nop

00803d18 <__umoddi3>:
  803d18:	55                   	push   %ebp
  803d19:	57                   	push   %edi
  803d1a:	56                   	push   %esi
  803d1b:	53                   	push   %ebx
  803d1c:	83 ec 1c             	sub    $0x1c,%esp
  803d1f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803d23:	8b 74 24 34          	mov    0x34(%esp),%esi
  803d27:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803d2b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803d2f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803d33:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803d37:	89 f3                	mov    %esi,%ebx
  803d39:	89 fa                	mov    %edi,%edx
  803d3b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d3f:	89 34 24             	mov    %esi,(%esp)
  803d42:	85 c0                	test   %eax,%eax
  803d44:	75 1a                	jne    803d60 <__umoddi3+0x48>
  803d46:	39 f7                	cmp    %esi,%edi
  803d48:	0f 86 a2 00 00 00    	jbe    803df0 <__umoddi3+0xd8>
  803d4e:	89 c8                	mov    %ecx,%eax
  803d50:	89 f2                	mov    %esi,%edx
  803d52:	f7 f7                	div    %edi
  803d54:	89 d0                	mov    %edx,%eax
  803d56:	31 d2                	xor    %edx,%edx
  803d58:	83 c4 1c             	add    $0x1c,%esp
  803d5b:	5b                   	pop    %ebx
  803d5c:	5e                   	pop    %esi
  803d5d:	5f                   	pop    %edi
  803d5e:	5d                   	pop    %ebp
  803d5f:	c3                   	ret    
  803d60:	39 f0                	cmp    %esi,%eax
  803d62:	0f 87 ac 00 00 00    	ja     803e14 <__umoddi3+0xfc>
  803d68:	0f bd e8             	bsr    %eax,%ebp
  803d6b:	83 f5 1f             	xor    $0x1f,%ebp
  803d6e:	0f 84 ac 00 00 00    	je     803e20 <__umoddi3+0x108>
  803d74:	bf 20 00 00 00       	mov    $0x20,%edi
  803d79:	29 ef                	sub    %ebp,%edi
  803d7b:	89 fe                	mov    %edi,%esi
  803d7d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803d81:	89 e9                	mov    %ebp,%ecx
  803d83:	d3 e0                	shl    %cl,%eax
  803d85:	89 d7                	mov    %edx,%edi
  803d87:	89 f1                	mov    %esi,%ecx
  803d89:	d3 ef                	shr    %cl,%edi
  803d8b:	09 c7                	or     %eax,%edi
  803d8d:	89 e9                	mov    %ebp,%ecx
  803d8f:	d3 e2                	shl    %cl,%edx
  803d91:	89 14 24             	mov    %edx,(%esp)
  803d94:	89 d8                	mov    %ebx,%eax
  803d96:	d3 e0                	shl    %cl,%eax
  803d98:	89 c2                	mov    %eax,%edx
  803d9a:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d9e:	d3 e0                	shl    %cl,%eax
  803da0:	89 44 24 04          	mov    %eax,0x4(%esp)
  803da4:	8b 44 24 08          	mov    0x8(%esp),%eax
  803da8:	89 f1                	mov    %esi,%ecx
  803daa:	d3 e8                	shr    %cl,%eax
  803dac:	09 d0                	or     %edx,%eax
  803dae:	d3 eb                	shr    %cl,%ebx
  803db0:	89 da                	mov    %ebx,%edx
  803db2:	f7 f7                	div    %edi
  803db4:	89 d3                	mov    %edx,%ebx
  803db6:	f7 24 24             	mull   (%esp)
  803db9:	89 c6                	mov    %eax,%esi
  803dbb:	89 d1                	mov    %edx,%ecx
  803dbd:	39 d3                	cmp    %edx,%ebx
  803dbf:	0f 82 87 00 00 00    	jb     803e4c <__umoddi3+0x134>
  803dc5:	0f 84 91 00 00 00    	je     803e5c <__umoddi3+0x144>
  803dcb:	8b 54 24 04          	mov    0x4(%esp),%edx
  803dcf:	29 f2                	sub    %esi,%edx
  803dd1:	19 cb                	sbb    %ecx,%ebx
  803dd3:	89 d8                	mov    %ebx,%eax
  803dd5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803dd9:	d3 e0                	shl    %cl,%eax
  803ddb:	89 e9                	mov    %ebp,%ecx
  803ddd:	d3 ea                	shr    %cl,%edx
  803ddf:	09 d0                	or     %edx,%eax
  803de1:	89 e9                	mov    %ebp,%ecx
  803de3:	d3 eb                	shr    %cl,%ebx
  803de5:	89 da                	mov    %ebx,%edx
  803de7:	83 c4 1c             	add    $0x1c,%esp
  803dea:	5b                   	pop    %ebx
  803deb:	5e                   	pop    %esi
  803dec:	5f                   	pop    %edi
  803ded:	5d                   	pop    %ebp
  803dee:	c3                   	ret    
  803def:	90                   	nop
  803df0:	89 fd                	mov    %edi,%ebp
  803df2:	85 ff                	test   %edi,%edi
  803df4:	75 0b                	jne    803e01 <__umoddi3+0xe9>
  803df6:	b8 01 00 00 00       	mov    $0x1,%eax
  803dfb:	31 d2                	xor    %edx,%edx
  803dfd:	f7 f7                	div    %edi
  803dff:	89 c5                	mov    %eax,%ebp
  803e01:	89 f0                	mov    %esi,%eax
  803e03:	31 d2                	xor    %edx,%edx
  803e05:	f7 f5                	div    %ebp
  803e07:	89 c8                	mov    %ecx,%eax
  803e09:	f7 f5                	div    %ebp
  803e0b:	89 d0                	mov    %edx,%eax
  803e0d:	e9 44 ff ff ff       	jmp    803d56 <__umoddi3+0x3e>
  803e12:	66 90                	xchg   %ax,%ax
  803e14:	89 c8                	mov    %ecx,%eax
  803e16:	89 f2                	mov    %esi,%edx
  803e18:	83 c4 1c             	add    $0x1c,%esp
  803e1b:	5b                   	pop    %ebx
  803e1c:	5e                   	pop    %esi
  803e1d:	5f                   	pop    %edi
  803e1e:	5d                   	pop    %ebp
  803e1f:	c3                   	ret    
  803e20:	3b 04 24             	cmp    (%esp),%eax
  803e23:	72 06                	jb     803e2b <__umoddi3+0x113>
  803e25:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803e29:	77 0f                	ja     803e3a <__umoddi3+0x122>
  803e2b:	89 f2                	mov    %esi,%edx
  803e2d:	29 f9                	sub    %edi,%ecx
  803e2f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803e33:	89 14 24             	mov    %edx,(%esp)
  803e36:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803e3a:	8b 44 24 04          	mov    0x4(%esp),%eax
  803e3e:	8b 14 24             	mov    (%esp),%edx
  803e41:	83 c4 1c             	add    $0x1c,%esp
  803e44:	5b                   	pop    %ebx
  803e45:	5e                   	pop    %esi
  803e46:	5f                   	pop    %edi
  803e47:	5d                   	pop    %ebp
  803e48:	c3                   	ret    
  803e49:	8d 76 00             	lea    0x0(%esi),%esi
  803e4c:	2b 04 24             	sub    (%esp),%eax
  803e4f:	19 fa                	sbb    %edi,%edx
  803e51:	89 d1                	mov    %edx,%ecx
  803e53:	89 c6                	mov    %eax,%esi
  803e55:	e9 71 ff ff ff       	jmp    803dcb <__umoddi3+0xb3>
  803e5a:	66 90                	xchg   %ax,%ax
  803e5c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803e60:	72 ea                	jb     803e4c <__umoddi3+0x134>
  803e62:	89 d9                	mov    %ebx,%ecx
  803e64:	e9 62 ff ff ff       	jmp    803dcb <__umoddi3+0xb3>
