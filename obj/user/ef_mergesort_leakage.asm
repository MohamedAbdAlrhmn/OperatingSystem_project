
obj/user/ef_mergesort_leakage:     file format elf32-i386


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
  800031:	e8 9a 07 00 00       	call   8007d0 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
void Merge(int* A, int p, int q, int r);

uint32 CheckSorted(int *Elements, int NumOfElements);

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 28 01 00 00    	sub    $0x128,%esp
	char Line[255] ;
	char Chose ;
	int numOfRep = 0;
  800041:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	do
	{
		numOfRep++ ;
  800048:	ff 45 f0             	incl   -0x10(%ebp)
		//2012: lock the interrupt
		sys_disable_interrupt();
  80004b:	e8 05 1e 00 00       	call   801e55 <sys_disable_interrupt>

		cprintf("\n");
  800050:	83 ec 0c             	sub    $0xc,%esp
  800053:	68 a0 3b 80 00       	push   $0x803ba0
  800058:	e8 63 0b 00 00       	call   800bc0 <cprintf>
  80005d:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800060:	83 ec 0c             	sub    $0xc,%esp
  800063:	68 a2 3b 80 00       	push   $0x803ba2
  800068:	e8 53 0b 00 00       	call   800bc0 <cprintf>
  80006d:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!! MERGE SORT !!!!\n");
  800070:	83 ec 0c             	sub    $0xc,%esp
  800073:	68 b8 3b 80 00       	push   $0x803bb8
  800078:	e8 43 0b 00 00       	call   800bc0 <cprintf>
  80007d:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800080:	83 ec 0c             	sub    $0xc,%esp
  800083:	68 a2 3b 80 00       	push   $0x803ba2
  800088:	e8 33 0b 00 00       	call   800bc0 <cprintf>
  80008d:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800090:	83 ec 0c             	sub    $0xc,%esp
  800093:	68 a0 3b 80 00       	push   $0x803ba0
  800098:	e8 23 0b 00 00       	call   800bc0 <cprintf>
  80009d:	83 c4 10             	add    $0x10,%esp
		cprintf("Enter the number of elements: ");
  8000a0:	83 ec 0c             	sub    $0xc,%esp
  8000a3:	68 d0 3b 80 00       	push   $0x803bd0
  8000a8:	e8 13 0b 00 00       	call   800bc0 <cprintf>
  8000ad:	83 c4 10             	add    $0x10,%esp

		int NumOfElements ;

		if (numOfRep == 1)
  8000b0:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
  8000b4:	75 09                	jne    8000bf <_main+0x87>
			NumOfElements = 32;
  8000b6:	c7 45 ec 20 00 00 00 	movl   $0x20,-0x14(%ebp)
  8000bd:	eb 0d                	jmp    8000cc <_main+0x94>
		else if (numOfRep == 2)
  8000bf:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
  8000c3:	75 07                	jne    8000cc <_main+0x94>
			NumOfElements = 32;
  8000c5:	c7 45 ec 20 00 00 00 	movl   $0x20,-0x14(%ebp)

		cprintf("%d\n", NumOfElements) ;
  8000cc:	83 ec 08             	sub    $0x8,%esp
  8000cf:	ff 75 ec             	pushl  -0x14(%ebp)
  8000d2:	68 ef 3b 80 00       	push   $0x803bef
  8000d7:	e8 e4 0a 00 00       	call   800bc0 <cprintf>
  8000dc:	83 c4 10             	add    $0x10,%esp

		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  8000df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000e2:	c1 e0 02             	shl    $0x2,%eax
  8000e5:	83 ec 0c             	sub    $0xc,%esp
  8000e8:	50                   	push   %eax
  8000e9:	e8 5a 1a 00 00       	call   801b48 <malloc>
  8000ee:	83 c4 10             	add    $0x10,%esp
  8000f1:	89 45 e8             	mov    %eax,-0x18(%ebp)
		cprintf("Chose the initialization method:\n") ;
  8000f4:	83 ec 0c             	sub    $0xc,%esp
  8000f7:	68 f4 3b 80 00       	push   $0x803bf4
  8000fc:	e8 bf 0a 00 00       	call   800bc0 <cprintf>
  800101:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  800104:	83 ec 0c             	sub    $0xc,%esp
  800107:	68 16 3c 80 00       	push   $0x803c16
  80010c:	e8 af 0a 00 00       	call   800bc0 <cprintf>
  800111:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  800114:	83 ec 0c             	sub    $0xc,%esp
  800117:	68 24 3c 80 00       	push   $0x803c24
  80011c:	e8 9f 0a 00 00       	call   800bc0 <cprintf>
  800121:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  800124:	83 ec 0c             	sub    $0xc,%esp
  800127:	68 33 3c 80 00       	push   $0x803c33
  80012c:	e8 8f 0a 00 00       	call   800bc0 <cprintf>
  800131:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  800134:	83 ec 0c             	sub    $0xc,%esp
  800137:	68 43 3c 80 00       	push   $0x803c43
  80013c:	e8 7f 0a 00 00       	call   800bc0 <cprintf>
  800141:	83 c4 10             	add    $0x10,%esp
			if (numOfRep == 1)
  800144:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
  800148:	75 06                	jne    800150 <_main+0x118>
				Chose = 'a' ;
  80014a:	c6 45 f7 61          	movb   $0x61,-0x9(%ebp)
  80014e:	eb 0a                	jmp    80015a <_main+0x122>
			else if (numOfRep == 2)
  800150:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
  800154:	75 04                	jne    80015a <_main+0x122>
				Chose = 'c' ;
  800156:	c6 45 f7 63          	movb   $0x63,-0x9(%ebp)
			cputchar(Chose);
  80015a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80015e:	83 ec 0c             	sub    $0xc,%esp
  800161:	50                   	push   %eax
  800162:	e8 c9 05 00 00       	call   800730 <cputchar>
  800167:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  80016a:	83 ec 0c             	sub    $0xc,%esp
  80016d:	6a 0a                	push   $0xa
  80016f:	e8 bc 05 00 00       	call   800730 <cputchar>
  800174:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800177:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  80017b:	74 0c                	je     800189 <_main+0x151>
  80017d:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  800181:	74 06                	je     800189 <_main+0x151>
  800183:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  800187:	75 ab                	jne    800134 <_main+0xfc>

		//2012: lock the interrupt
		sys_enable_interrupt();
  800189:	e8 e1 1c 00 00       	call   801e6f <sys_enable_interrupt>

		int  i ;
		switch (Chose)
  80018e:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800192:	83 f8 62             	cmp    $0x62,%eax
  800195:	74 1d                	je     8001b4 <_main+0x17c>
  800197:	83 f8 63             	cmp    $0x63,%eax
  80019a:	74 2b                	je     8001c7 <_main+0x18f>
  80019c:	83 f8 61             	cmp    $0x61,%eax
  80019f:	75 39                	jne    8001da <_main+0x1a2>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  8001a1:	83 ec 08             	sub    $0x8,%esp
  8001a4:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a7:	ff 75 e8             	pushl  -0x18(%ebp)
  8001aa:	e8 f4 01 00 00       	call   8003a3 <InitializeAscending>
  8001af:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b2:	eb 37                	jmp    8001eb <_main+0x1b3>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  8001b4:	83 ec 08             	sub    $0x8,%esp
  8001b7:	ff 75 ec             	pushl  -0x14(%ebp)
  8001ba:	ff 75 e8             	pushl  -0x18(%ebp)
  8001bd:	e8 12 02 00 00       	call   8003d4 <InitializeDescending>
  8001c2:	83 c4 10             	add    $0x10,%esp
			break ;
  8001c5:	eb 24                	jmp    8001eb <_main+0x1b3>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001c7:	83 ec 08             	sub    $0x8,%esp
  8001ca:	ff 75 ec             	pushl  -0x14(%ebp)
  8001cd:	ff 75 e8             	pushl  -0x18(%ebp)
  8001d0:	e8 34 02 00 00       	call   800409 <InitializeSemiRandom>
  8001d5:	83 c4 10             	add    $0x10,%esp
			break ;
  8001d8:	eb 11                	jmp    8001eb <_main+0x1b3>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001da:	83 ec 08             	sub    $0x8,%esp
  8001dd:	ff 75 ec             	pushl  -0x14(%ebp)
  8001e0:	ff 75 e8             	pushl  -0x18(%ebp)
  8001e3:	e8 21 02 00 00       	call   800409 <InitializeSemiRandom>
  8001e8:	83 c4 10             	add    $0x10,%esp
		}

		MSort(Elements, 1, NumOfElements);
  8001eb:	83 ec 04             	sub    $0x4,%esp
  8001ee:	ff 75 ec             	pushl  -0x14(%ebp)
  8001f1:	6a 01                	push   $0x1
  8001f3:	ff 75 e8             	pushl  -0x18(%ebp)
  8001f6:	e8 e0 02 00 00       	call   8004db <MSort>
  8001fb:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  8001fe:	e8 52 1c 00 00       	call   801e55 <sys_disable_interrupt>
		cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  800203:	83 ec 0c             	sub    $0xc,%esp
  800206:	68 4c 3c 80 00       	push   $0x803c4c
  80020b:	e8 b0 09 00 00       	call   800bc0 <cprintf>
  800210:	83 c4 10             	add    $0x10,%esp
		//PrintElements(Elements, NumOfElements);
		sys_enable_interrupt();
  800213:	e8 57 1c 00 00       	call   801e6f <sys_enable_interrupt>

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  800218:	83 ec 08             	sub    $0x8,%esp
  80021b:	ff 75 ec             	pushl  -0x14(%ebp)
  80021e:	ff 75 e8             	pushl  -0x18(%ebp)
  800221:	e8 d3 00 00 00       	call   8002f9 <CheckSorted>
  800226:	83 c4 10             	add    $0x10,%esp
  800229:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  80022c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800230:	75 14                	jne    800246 <_main+0x20e>
  800232:	83 ec 04             	sub    $0x4,%esp
  800235:	68 80 3c 80 00       	push   $0x803c80
  80023a:	6a 58                	push   $0x58
  80023c:	68 a2 3c 80 00       	push   $0x803ca2
  800241:	e8 c6 06 00 00       	call   80090c <_panic>
		else
		{
			sys_disable_interrupt();
  800246:	e8 0a 1c 00 00       	call   801e55 <sys_disable_interrupt>
			cprintf("===============================================\n") ;
  80024b:	83 ec 0c             	sub    $0xc,%esp
  80024e:	68 c0 3c 80 00       	push   $0x803cc0
  800253:	e8 68 09 00 00       	call   800bc0 <cprintf>
  800258:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  80025b:	83 ec 0c             	sub    $0xc,%esp
  80025e:	68 f4 3c 80 00       	push   $0x803cf4
  800263:	e8 58 09 00 00       	call   800bc0 <cprintf>
  800268:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  80026b:	83 ec 0c             	sub    $0xc,%esp
  80026e:	68 28 3d 80 00       	push   $0x803d28
  800273:	e8 48 09 00 00       	call   800bc0 <cprintf>
  800278:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  80027b:	e8 ef 1b 00 00       	call   801e6f <sys_enable_interrupt>
		}

		//free(Elements) ;

		sys_disable_interrupt();
  800280:	e8 d0 1b 00 00       	call   801e55 <sys_disable_interrupt>
		Chose = 0 ;
  800285:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
		while (Chose != 'y' && Chose != 'n')
  800289:	eb 50                	jmp    8002db <_main+0x2a3>
		{
			cprintf("Do you want to repeat (y/n): ") ;
  80028b:	83 ec 0c             	sub    $0xc,%esp
  80028e:	68 5a 3d 80 00       	push   $0x803d5a
  800293:	e8 28 09 00 00       	call   800bc0 <cprintf>
  800298:	83 c4 10             	add    $0x10,%esp
			if (numOfRep == 1)
  80029b:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
  80029f:	75 06                	jne    8002a7 <_main+0x26f>
				Chose = 'y' ;
  8002a1:	c6 45 f7 79          	movb   $0x79,-0x9(%ebp)
  8002a5:	eb 0a                	jmp    8002b1 <_main+0x279>
			else if (numOfRep == 2)
  8002a7:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
  8002ab:	75 04                	jne    8002b1 <_main+0x279>
				Chose = 'n' ;
  8002ad:	c6 45 f7 6e          	movb   $0x6e,-0x9(%ebp)
			cputchar(Chose);
  8002b1:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8002b5:	83 ec 0c             	sub    $0xc,%esp
  8002b8:	50                   	push   %eax
  8002b9:	e8 72 04 00 00       	call   800730 <cputchar>
  8002be:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  8002c1:	83 ec 0c             	sub    $0xc,%esp
  8002c4:	6a 0a                	push   $0xa
  8002c6:	e8 65 04 00 00       	call   800730 <cputchar>
  8002cb:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  8002ce:	83 ec 0c             	sub    $0xc,%esp
  8002d1:	6a 0a                	push   $0xa
  8002d3:	e8 58 04 00 00       	call   800730 <cputchar>
  8002d8:	83 c4 10             	add    $0x10,%esp

		//free(Elements) ;

		sys_disable_interrupt();
		Chose = 0 ;
		while (Chose != 'y' && Chose != 'n')
  8002db:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002df:	74 06                	je     8002e7 <_main+0x2af>
  8002e1:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  8002e5:	75 a4                	jne    80028b <_main+0x253>
				Chose = 'n' ;
			cputchar(Chose);
			cputchar('\n');
			cputchar('\n');
		}
		sys_enable_interrupt();
  8002e7:	e8 83 1b 00 00       	call   801e6f <sys_enable_interrupt>

	} while (Chose == 'y');
  8002ec:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002f0:	0f 84 52 fd ff ff    	je     800048 <_main+0x10>
}
  8002f6:	90                   	nop
  8002f7:	c9                   	leave  
  8002f8:	c3                   	ret    

008002f9 <CheckSorted>:


uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8002f9:	55                   	push   %ebp
  8002fa:	89 e5                	mov    %esp,%ebp
  8002fc:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8002ff:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800306:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80030d:	eb 33                	jmp    800342 <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  80030f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800312:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800319:	8b 45 08             	mov    0x8(%ebp),%eax
  80031c:	01 d0                	add    %edx,%eax
  80031e:	8b 10                	mov    (%eax),%edx
  800320:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800323:	40                   	inc    %eax
  800324:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80032b:	8b 45 08             	mov    0x8(%ebp),%eax
  80032e:	01 c8                	add    %ecx,%eax
  800330:	8b 00                	mov    (%eax),%eax
  800332:	39 c2                	cmp    %eax,%edx
  800334:	7e 09                	jle    80033f <CheckSorted+0x46>
		{
			Sorted = 0 ;
  800336:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  80033d:	eb 0c                	jmp    80034b <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  80033f:	ff 45 f8             	incl   -0x8(%ebp)
  800342:	8b 45 0c             	mov    0xc(%ebp),%eax
  800345:	48                   	dec    %eax
  800346:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800349:	7f c4                	jg     80030f <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  80034b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80034e:	c9                   	leave  
  80034f:	c3                   	ret    

00800350 <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  800350:	55                   	push   %ebp
  800351:	89 e5                	mov    %esp,%ebp
  800353:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  800356:	8b 45 0c             	mov    0xc(%ebp),%eax
  800359:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800360:	8b 45 08             	mov    0x8(%ebp),%eax
  800363:	01 d0                	add    %edx,%eax
  800365:	8b 00                	mov    (%eax),%eax
  800367:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  80036a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80036d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800374:	8b 45 08             	mov    0x8(%ebp),%eax
  800377:	01 c2                	add    %eax,%edx
  800379:	8b 45 10             	mov    0x10(%ebp),%eax
  80037c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800383:	8b 45 08             	mov    0x8(%ebp),%eax
  800386:	01 c8                	add    %ecx,%eax
  800388:	8b 00                	mov    (%eax),%eax
  80038a:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  80038c:	8b 45 10             	mov    0x10(%ebp),%eax
  80038f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800396:	8b 45 08             	mov    0x8(%ebp),%eax
  800399:	01 c2                	add    %eax,%edx
  80039b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80039e:	89 02                	mov    %eax,(%edx)
}
  8003a0:	90                   	nop
  8003a1:	c9                   	leave  
  8003a2:	c3                   	ret    

008003a3 <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  8003a3:	55                   	push   %ebp
  8003a4:	89 e5                	mov    %esp,%ebp
  8003a6:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003a9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003b0:	eb 17                	jmp    8003c9 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  8003b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003b5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8003bf:	01 c2                	add    %eax,%edx
  8003c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003c4:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003c6:	ff 45 fc             	incl   -0x4(%ebp)
  8003c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003cc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003cf:	7c e1                	jl     8003b2 <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  8003d1:	90                   	nop
  8003d2:	c9                   	leave  
  8003d3:	c3                   	ret    

008003d4 <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  8003d4:	55                   	push   %ebp
  8003d5:	89 e5                	mov    %esp,%ebp
  8003d7:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003da:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003e1:	eb 1b                	jmp    8003fe <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8003e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003e6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f0:	01 c2                	add    %eax,%edx
  8003f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003f5:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8003f8:	48                   	dec    %eax
  8003f9:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003fb:	ff 45 fc             	incl   -0x4(%ebp)
  8003fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800401:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800404:	7c dd                	jl     8003e3 <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  800406:	90                   	nop
  800407:	c9                   	leave  
  800408:	c3                   	ret    

00800409 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  800409:	55                   	push   %ebp
  80040a:	89 e5                	mov    %esp,%ebp
  80040c:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  80040f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800412:	b8 56 55 55 55       	mov    $0x55555556,%eax
  800417:	f7 e9                	imul   %ecx
  800419:	c1 f9 1f             	sar    $0x1f,%ecx
  80041c:	89 d0                	mov    %edx,%eax
  80041e:	29 c8                	sub    %ecx,%eax
  800420:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  800423:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80042a:	eb 1e                	jmp    80044a <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  80042c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80042f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800436:	8b 45 08             	mov    0x8(%ebp),%eax
  800439:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80043c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80043f:	99                   	cltd   
  800440:	f7 7d f8             	idivl  -0x8(%ebp)
  800443:	89 d0                	mov    %edx,%eax
  800445:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800447:	ff 45 fc             	incl   -0x4(%ebp)
  80044a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80044d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800450:	7c da                	jl     80042c <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
		//	cprintf("i=%d\n",i);
	}

}
  800452:	90                   	nop
  800453:	c9                   	leave  
  800454:	c3                   	ret    

00800455 <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  800455:	55                   	push   %ebp
  800456:	89 e5                	mov    %esp,%ebp
  800458:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  80045b:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800462:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800469:	eb 42                	jmp    8004ad <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  80046b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80046e:	99                   	cltd   
  80046f:	f7 7d f0             	idivl  -0x10(%ebp)
  800472:	89 d0                	mov    %edx,%eax
  800474:	85 c0                	test   %eax,%eax
  800476:	75 10                	jne    800488 <PrintElements+0x33>
			cprintf("\n");
  800478:	83 ec 0c             	sub    $0xc,%esp
  80047b:	68 a0 3b 80 00       	push   $0x803ba0
  800480:	e8 3b 07 00 00       	call   800bc0 <cprintf>
  800485:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800488:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80048b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800492:	8b 45 08             	mov    0x8(%ebp),%eax
  800495:	01 d0                	add    %edx,%eax
  800497:	8b 00                	mov    (%eax),%eax
  800499:	83 ec 08             	sub    $0x8,%esp
  80049c:	50                   	push   %eax
  80049d:	68 78 3d 80 00       	push   $0x803d78
  8004a2:	e8 19 07 00 00       	call   800bc0 <cprintf>
  8004a7:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  8004aa:	ff 45 f4             	incl   -0xc(%ebp)
  8004ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b0:	48                   	dec    %eax
  8004b1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8004b4:	7f b5                	jg     80046b <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  8004b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004b9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c3:	01 d0                	add    %edx,%eax
  8004c5:	8b 00                	mov    (%eax),%eax
  8004c7:	83 ec 08             	sub    $0x8,%esp
  8004ca:	50                   	push   %eax
  8004cb:	68 ef 3b 80 00       	push   $0x803bef
  8004d0:	e8 eb 06 00 00       	call   800bc0 <cprintf>
  8004d5:	83 c4 10             	add    $0x10,%esp

}
  8004d8:	90                   	nop
  8004d9:	c9                   	leave  
  8004da:	c3                   	ret    

008004db <MSort>:


void MSort(int* A, int p, int r)
{
  8004db:	55                   	push   %ebp
  8004dc:	89 e5                	mov    %esp,%ebp
  8004de:	83 ec 18             	sub    $0x18,%esp
	if (p >= r)
  8004e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004e4:	3b 45 10             	cmp    0x10(%ebp),%eax
  8004e7:	7d 54                	jge    80053d <MSort+0x62>
	{
		return;
	}

	int q = (p + r) / 2;
  8004e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8004ef:	01 d0                	add    %edx,%eax
  8004f1:	89 c2                	mov    %eax,%edx
  8004f3:	c1 ea 1f             	shr    $0x1f,%edx
  8004f6:	01 d0                	add    %edx,%eax
  8004f8:	d1 f8                	sar    %eax
  8004fa:	89 45 f4             	mov    %eax,-0xc(%ebp)

	MSort(A, p, q);
  8004fd:	83 ec 04             	sub    $0x4,%esp
  800500:	ff 75 f4             	pushl  -0xc(%ebp)
  800503:	ff 75 0c             	pushl  0xc(%ebp)
  800506:	ff 75 08             	pushl  0x8(%ebp)
  800509:	e8 cd ff ff ff       	call   8004db <MSort>
  80050e:	83 c4 10             	add    $0x10,%esp

	MSort(A, q + 1, r);
  800511:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800514:	40                   	inc    %eax
  800515:	83 ec 04             	sub    $0x4,%esp
  800518:	ff 75 10             	pushl  0x10(%ebp)
  80051b:	50                   	push   %eax
  80051c:	ff 75 08             	pushl  0x8(%ebp)
  80051f:	e8 b7 ff ff ff       	call   8004db <MSort>
  800524:	83 c4 10             	add    $0x10,%esp

	Merge(A, p, q, r);
  800527:	ff 75 10             	pushl  0x10(%ebp)
  80052a:	ff 75 f4             	pushl  -0xc(%ebp)
  80052d:	ff 75 0c             	pushl  0xc(%ebp)
  800530:	ff 75 08             	pushl  0x8(%ebp)
  800533:	e8 08 00 00 00       	call   800540 <Merge>
  800538:	83 c4 10             	add    $0x10,%esp
  80053b:	eb 01                	jmp    80053e <MSort+0x63>

void MSort(int* A, int p, int r)
{
	if (p >= r)
	{
		return;
  80053d:	90                   	nop

	MSort(A, q + 1, r);

	Merge(A, p, q, r);

}
  80053e:	c9                   	leave  
  80053f:	c3                   	ret    

00800540 <Merge>:

void Merge(int* A, int p, int q, int r)
{
  800540:	55                   	push   %ebp
  800541:	89 e5                	mov    %esp,%ebp
  800543:	83 ec 38             	sub    $0x38,%esp
	int leftCapacity = q - p + 1;
  800546:	8b 45 10             	mov    0x10(%ebp),%eax
  800549:	2b 45 0c             	sub    0xc(%ebp),%eax
  80054c:	40                   	inc    %eax
  80054d:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int rightCapacity = r - q;
  800550:	8b 45 14             	mov    0x14(%ebp),%eax
  800553:	2b 45 10             	sub    0x10(%ebp),%eax
  800556:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int leftIndex = 0;
  800559:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int rightIndex = 0;
  800560:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int* Left = malloc(sizeof(int) * leftCapacity);
  800567:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80056a:	c1 e0 02             	shl    $0x2,%eax
  80056d:	83 ec 0c             	sub    $0xc,%esp
  800570:	50                   	push   %eax
  800571:	e8 d2 15 00 00       	call   801b48 <malloc>
  800576:	83 c4 10             	add    $0x10,%esp
  800579:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* Right = malloc(sizeof(int) * rightCapacity);
  80057c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80057f:	c1 e0 02             	shl    $0x2,%eax
  800582:	83 ec 0c             	sub    $0xc,%esp
  800585:	50                   	push   %eax
  800586:	e8 bd 15 00 00       	call   801b48 <malloc>
  80058b:	83 c4 10             	add    $0x10,%esp
  80058e:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	//	int Left[5000] ;
	//	int Right[5000] ;

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  800591:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800598:	eb 2f                	jmp    8005c9 <Merge+0x89>
	{
		Left[i] = A[p + i - 1];
  80059a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80059d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005a4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005a7:	01 c2                	add    %eax,%edx
  8005a9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8005af:	01 c8                	add    %ecx,%eax
  8005b1:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8005b6:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c0:	01 c8                	add    %ecx,%eax
  8005c2:	8b 00                	mov    (%eax),%eax
  8005c4:	89 02                	mov    %eax,(%edx)

	//	int Left[5000] ;
	//	int Right[5000] ;

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  8005c6:	ff 45 ec             	incl   -0x14(%ebp)
  8005c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8005cc:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005cf:	7c c9                	jl     80059a <Merge+0x5a>
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8005d1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005d8:	eb 2a                	jmp    800604 <Merge+0xc4>
	{
		Right[j] = A[q + j];
  8005da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005dd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005e4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8005e7:	01 c2                	add    %eax,%edx
  8005e9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8005ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005ef:	01 c8                	add    %ecx,%eax
  8005f1:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005fb:	01 c8                	add    %ecx,%eax
  8005fd:	8b 00                	mov    (%eax),%eax
  8005ff:	89 02                	mov    %eax,(%edx)
	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  800601:	ff 45 e8             	incl   -0x18(%ebp)
  800604:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800607:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80060a:	7c ce                	jl     8005da <Merge+0x9a>
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  80060c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80060f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800612:	e9 0a 01 00 00       	jmp    800721 <Merge+0x1e1>
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
  800617:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80061a:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80061d:	0f 8d 95 00 00 00    	jge    8006b8 <Merge+0x178>
  800623:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800626:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800629:	0f 8d 89 00 00 00    	jge    8006b8 <Merge+0x178>
		{
			if (Left[leftIndex] < Right[rightIndex] )
  80062f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800632:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800639:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80063c:	01 d0                	add    %edx,%eax
  80063e:	8b 10                	mov    (%eax),%edx
  800640:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800643:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80064a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80064d:	01 c8                	add    %ecx,%eax
  80064f:	8b 00                	mov    (%eax),%eax
  800651:	39 c2                	cmp    %eax,%edx
  800653:	7d 33                	jge    800688 <Merge+0x148>
			{
				A[k - 1] = Left[leftIndex++];
  800655:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800658:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80065d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800664:	8b 45 08             	mov    0x8(%ebp),%eax
  800667:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80066a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80066d:	8d 50 01             	lea    0x1(%eax),%edx
  800670:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800673:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80067a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80067d:	01 d0                	add    %edx,%eax
  80067f:	8b 00                	mov    (%eax),%eax
  800681:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800683:	e9 96 00 00 00       	jmp    80071e <Merge+0x1de>
			{
				A[k - 1] = Left[leftIndex++];
			}
			else
			{
				A[k - 1] = Right[rightIndex++];
  800688:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80068b:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800690:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800697:	8b 45 08             	mov    0x8(%ebp),%eax
  80069a:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80069d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006a0:	8d 50 01             	lea    0x1(%eax),%edx
  8006a3:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8006a6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006ad:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8006b0:	01 d0                	add    %edx,%eax
  8006b2:	8b 00                	mov    (%eax),%eax
  8006b4:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  8006b6:	eb 66                	jmp    80071e <Merge+0x1de>
			else
			{
				A[k - 1] = Right[rightIndex++];
			}
		}
		else if (leftIndex < leftCapacity)
  8006b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006bb:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8006be:	7d 30                	jge    8006f0 <Merge+0x1b0>
		{
			A[k - 1] = Left[leftIndex++];
  8006c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006c3:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8006c8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d2:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006d8:	8d 50 01             	lea    0x1(%eax),%edx
  8006db:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8006de:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006e5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006e8:	01 d0                	add    %edx,%eax
  8006ea:	8b 00                	mov    (%eax),%eax
  8006ec:	89 01                	mov    %eax,(%ecx)
  8006ee:	eb 2e                	jmp    80071e <Merge+0x1de>
		}
		else
		{
			A[k - 1] = Right[rightIndex++];
  8006f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006f3:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8006f8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800702:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800705:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800708:	8d 50 01             	lea    0x1(%eax),%edx
  80070b:	89 55 f0             	mov    %edx,-0x10(%ebp)
  80070e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800715:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800718:	01 d0                	add    %edx,%eax
  80071a:	8b 00                	mov    (%eax),%eax
  80071c:	89 01                	mov    %eax,(%ecx)
	for (j = 0; j < rightCapacity; j++)
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  80071e:	ff 45 e4             	incl   -0x1c(%ebp)
  800721:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800724:	3b 45 14             	cmp    0x14(%ebp),%eax
  800727:	0f 8e ea fe ff ff    	jle    800617 <Merge+0xd7>
		{
			A[k - 1] = Right[rightIndex++];
		}
	}

}
  80072d:	90                   	nop
  80072e:	c9                   	leave  
  80072f:	c3                   	ret    

00800730 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  800730:	55                   	push   %ebp
  800731:	89 e5                	mov    %esp,%ebp
  800733:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  800736:	8b 45 08             	mov    0x8(%ebp),%eax
  800739:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  80073c:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800740:	83 ec 0c             	sub    $0xc,%esp
  800743:	50                   	push   %eax
  800744:	e8 40 17 00 00       	call   801e89 <sys_cputc>
  800749:	83 c4 10             	add    $0x10,%esp
}
  80074c:	90                   	nop
  80074d:	c9                   	leave  
  80074e:	c3                   	ret    

0080074f <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  80074f:	55                   	push   %ebp
  800750:	89 e5                	mov    %esp,%ebp
  800752:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800755:	e8 fb 16 00 00       	call   801e55 <sys_disable_interrupt>
	char c = ch;
  80075a:	8b 45 08             	mov    0x8(%ebp),%eax
  80075d:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800760:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800764:	83 ec 0c             	sub    $0xc,%esp
  800767:	50                   	push   %eax
  800768:	e8 1c 17 00 00       	call   801e89 <sys_cputc>
  80076d:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800770:	e8 fa 16 00 00       	call   801e6f <sys_enable_interrupt>
}
  800775:	90                   	nop
  800776:	c9                   	leave  
  800777:	c3                   	ret    

00800778 <getchar>:

int
getchar(void)
{
  800778:	55                   	push   %ebp
  800779:	89 e5                	mov    %esp,%ebp
  80077b:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  80077e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800785:	eb 08                	jmp    80078f <getchar+0x17>
	{
		c = sys_cgetc();
  800787:	e8 44 15 00 00       	call   801cd0 <sys_cgetc>
  80078c:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  80078f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800793:	74 f2                	je     800787 <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  800795:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800798:	c9                   	leave  
  800799:	c3                   	ret    

0080079a <atomic_getchar>:

int
atomic_getchar(void)
{
  80079a:	55                   	push   %ebp
  80079b:	89 e5                	mov    %esp,%ebp
  80079d:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8007a0:	e8 b0 16 00 00       	call   801e55 <sys_disable_interrupt>
	int c=0;
  8007a5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8007ac:	eb 08                	jmp    8007b6 <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  8007ae:	e8 1d 15 00 00       	call   801cd0 <sys_cgetc>
  8007b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  8007b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8007ba:	74 f2                	je     8007ae <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  8007bc:	e8 ae 16 00 00       	call   801e6f <sys_enable_interrupt>
	return c;
  8007c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8007c4:	c9                   	leave  
  8007c5:	c3                   	ret    

008007c6 <iscons>:

int iscons(int fdnum)
{
  8007c6:	55                   	push   %ebp
  8007c7:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  8007c9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8007ce:	5d                   	pop    %ebp
  8007cf:	c3                   	ret    

008007d0 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8007d0:	55                   	push   %ebp
  8007d1:	89 e5                	mov    %esp,%ebp
  8007d3:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8007d6:	e8 6d 18 00 00       	call   802048 <sys_getenvindex>
  8007db:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8007de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007e1:	89 d0                	mov    %edx,%eax
  8007e3:	c1 e0 03             	shl    $0x3,%eax
  8007e6:	01 d0                	add    %edx,%eax
  8007e8:	01 c0                	add    %eax,%eax
  8007ea:	01 d0                	add    %edx,%eax
  8007ec:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007f3:	01 d0                	add    %edx,%eax
  8007f5:	c1 e0 04             	shl    $0x4,%eax
  8007f8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8007fd:	a3 24 50 80 00       	mov    %eax,0x805024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800802:	a1 24 50 80 00       	mov    0x805024,%eax
  800807:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80080d:	84 c0                	test   %al,%al
  80080f:	74 0f                	je     800820 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800811:	a1 24 50 80 00       	mov    0x805024,%eax
  800816:	05 5c 05 00 00       	add    $0x55c,%eax
  80081b:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800820:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800824:	7e 0a                	jle    800830 <libmain+0x60>
		binaryname = argv[0];
  800826:	8b 45 0c             	mov    0xc(%ebp),%eax
  800829:	8b 00                	mov    (%eax),%eax
  80082b:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800830:	83 ec 08             	sub    $0x8,%esp
  800833:	ff 75 0c             	pushl  0xc(%ebp)
  800836:	ff 75 08             	pushl  0x8(%ebp)
  800839:	e8 fa f7 ff ff       	call   800038 <_main>
  80083e:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800841:	e8 0f 16 00 00       	call   801e55 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800846:	83 ec 0c             	sub    $0xc,%esp
  800849:	68 98 3d 80 00       	push   $0x803d98
  80084e:	e8 6d 03 00 00       	call   800bc0 <cprintf>
  800853:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800856:	a1 24 50 80 00       	mov    0x805024,%eax
  80085b:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800861:	a1 24 50 80 00       	mov    0x805024,%eax
  800866:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80086c:	83 ec 04             	sub    $0x4,%esp
  80086f:	52                   	push   %edx
  800870:	50                   	push   %eax
  800871:	68 c0 3d 80 00       	push   $0x803dc0
  800876:	e8 45 03 00 00       	call   800bc0 <cprintf>
  80087b:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80087e:	a1 24 50 80 00       	mov    0x805024,%eax
  800883:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800889:	a1 24 50 80 00       	mov    0x805024,%eax
  80088e:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800894:	a1 24 50 80 00       	mov    0x805024,%eax
  800899:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80089f:	51                   	push   %ecx
  8008a0:	52                   	push   %edx
  8008a1:	50                   	push   %eax
  8008a2:	68 e8 3d 80 00       	push   $0x803de8
  8008a7:	e8 14 03 00 00       	call   800bc0 <cprintf>
  8008ac:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8008af:	a1 24 50 80 00       	mov    0x805024,%eax
  8008b4:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8008ba:	83 ec 08             	sub    $0x8,%esp
  8008bd:	50                   	push   %eax
  8008be:	68 40 3e 80 00       	push   $0x803e40
  8008c3:	e8 f8 02 00 00       	call   800bc0 <cprintf>
  8008c8:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8008cb:	83 ec 0c             	sub    $0xc,%esp
  8008ce:	68 98 3d 80 00       	push   $0x803d98
  8008d3:	e8 e8 02 00 00       	call   800bc0 <cprintf>
  8008d8:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8008db:	e8 8f 15 00 00       	call   801e6f <sys_enable_interrupt>

	// exit gracefully
	exit();
  8008e0:	e8 19 00 00 00       	call   8008fe <exit>
}
  8008e5:	90                   	nop
  8008e6:	c9                   	leave  
  8008e7:	c3                   	ret    

008008e8 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8008e8:	55                   	push   %ebp
  8008e9:	89 e5                	mov    %esp,%ebp
  8008eb:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8008ee:	83 ec 0c             	sub    $0xc,%esp
  8008f1:	6a 00                	push   $0x0
  8008f3:	e8 1c 17 00 00       	call   802014 <sys_destroy_env>
  8008f8:	83 c4 10             	add    $0x10,%esp
}
  8008fb:	90                   	nop
  8008fc:	c9                   	leave  
  8008fd:	c3                   	ret    

008008fe <exit>:

void
exit(void)
{
  8008fe:	55                   	push   %ebp
  8008ff:	89 e5                	mov    %esp,%ebp
  800901:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800904:	e8 71 17 00 00       	call   80207a <sys_exit_env>
}
  800909:	90                   	nop
  80090a:	c9                   	leave  
  80090b:	c3                   	ret    

0080090c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80090c:	55                   	push   %ebp
  80090d:	89 e5                	mov    %esp,%ebp
  80090f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800912:	8d 45 10             	lea    0x10(%ebp),%eax
  800915:	83 c0 04             	add    $0x4,%eax
  800918:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80091b:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800920:	85 c0                	test   %eax,%eax
  800922:	74 16                	je     80093a <_panic+0x2e>
		cprintf("%s: ", argv0);
  800924:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800929:	83 ec 08             	sub    $0x8,%esp
  80092c:	50                   	push   %eax
  80092d:	68 54 3e 80 00       	push   $0x803e54
  800932:	e8 89 02 00 00       	call   800bc0 <cprintf>
  800937:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80093a:	a1 00 50 80 00       	mov    0x805000,%eax
  80093f:	ff 75 0c             	pushl  0xc(%ebp)
  800942:	ff 75 08             	pushl  0x8(%ebp)
  800945:	50                   	push   %eax
  800946:	68 59 3e 80 00       	push   $0x803e59
  80094b:	e8 70 02 00 00       	call   800bc0 <cprintf>
  800950:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800953:	8b 45 10             	mov    0x10(%ebp),%eax
  800956:	83 ec 08             	sub    $0x8,%esp
  800959:	ff 75 f4             	pushl  -0xc(%ebp)
  80095c:	50                   	push   %eax
  80095d:	e8 f3 01 00 00       	call   800b55 <vcprintf>
  800962:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800965:	83 ec 08             	sub    $0x8,%esp
  800968:	6a 00                	push   $0x0
  80096a:	68 75 3e 80 00       	push   $0x803e75
  80096f:	e8 e1 01 00 00       	call   800b55 <vcprintf>
  800974:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800977:	e8 82 ff ff ff       	call   8008fe <exit>

	// should not return here
	while (1) ;
  80097c:	eb fe                	jmp    80097c <_panic+0x70>

0080097e <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80097e:	55                   	push   %ebp
  80097f:	89 e5                	mov    %esp,%ebp
  800981:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800984:	a1 24 50 80 00       	mov    0x805024,%eax
  800989:	8b 50 74             	mov    0x74(%eax),%edx
  80098c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80098f:	39 c2                	cmp    %eax,%edx
  800991:	74 14                	je     8009a7 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800993:	83 ec 04             	sub    $0x4,%esp
  800996:	68 78 3e 80 00       	push   $0x803e78
  80099b:	6a 26                	push   $0x26
  80099d:	68 c4 3e 80 00       	push   $0x803ec4
  8009a2:	e8 65 ff ff ff       	call   80090c <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8009a7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8009ae:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8009b5:	e9 c2 00 00 00       	jmp    800a7c <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8009ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009bd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8009c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c7:	01 d0                	add    %edx,%eax
  8009c9:	8b 00                	mov    (%eax),%eax
  8009cb:	85 c0                	test   %eax,%eax
  8009cd:	75 08                	jne    8009d7 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8009cf:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8009d2:	e9 a2 00 00 00       	jmp    800a79 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8009d7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009de:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8009e5:	eb 69                	jmp    800a50 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8009e7:	a1 24 50 80 00       	mov    0x805024,%eax
  8009ec:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8009f2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009f5:	89 d0                	mov    %edx,%eax
  8009f7:	01 c0                	add    %eax,%eax
  8009f9:	01 d0                	add    %edx,%eax
  8009fb:	c1 e0 03             	shl    $0x3,%eax
  8009fe:	01 c8                	add    %ecx,%eax
  800a00:	8a 40 04             	mov    0x4(%eax),%al
  800a03:	84 c0                	test   %al,%al
  800a05:	75 46                	jne    800a4d <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a07:	a1 24 50 80 00       	mov    0x805024,%eax
  800a0c:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800a12:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800a15:	89 d0                	mov    %edx,%eax
  800a17:	01 c0                	add    %eax,%eax
  800a19:	01 d0                	add    %edx,%eax
  800a1b:	c1 e0 03             	shl    $0x3,%eax
  800a1e:	01 c8                	add    %ecx,%eax
  800a20:	8b 00                	mov    (%eax),%eax
  800a22:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800a25:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800a28:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800a2d:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800a2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a32:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800a39:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3c:	01 c8                	add    %ecx,%eax
  800a3e:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a40:	39 c2                	cmp    %eax,%edx
  800a42:	75 09                	jne    800a4d <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800a44:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800a4b:	eb 12                	jmp    800a5f <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a4d:	ff 45 e8             	incl   -0x18(%ebp)
  800a50:	a1 24 50 80 00       	mov    0x805024,%eax
  800a55:	8b 50 74             	mov    0x74(%eax),%edx
  800a58:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a5b:	39 c2                	cmp    %eax,%edx
  800a5d:	77 88                	ja     8009e7 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800a5f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800a63:	75 14                	jne    800a79 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800a65:	83 ec 04             	sub    $0x4,%esp
  800a68:	68 d0 3e 80 00       	push   $0x803ed0
  800a6d:	6a 3a                	push   $0x3a
  800a6f:	68 c4 3e 80 00       	push   $0x803ec4
  800a74:	e8 93 fe ff ff       	call   80090c <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800a79:	ff 45 f0             	incl   -0x10(%ebp)
  800a7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a7f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800a82:	0f 8c 32 ff ff ff    	jl     8009ba <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800a88:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a8f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800a96:	eb 26                	jmp    800abe <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800a98:	a1 24 50 80 00       	mov    0x805024,%eax
  800a9d:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800aa3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800aa6:	89 d0                	mov    %edx,%eax
  800aa8:	01 c0                	add    %eax,%eax
  800aaa:	01 d0                	add    %edx,%eax
  800aac:	c1 e0 03             	shl    $0x3,%eax
  800aaf:	01 c8                	add    %ecx,%eax
  800ab1:	8a 40 04             	mov    0x4(%eax),%al
  800ab4:	3c 01                	cmp    $0x1,%al
  800ab6:	75 03                	jne    800abb <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800ab8:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800abb:	ff 45 e0             	incl   -0x20(%ebp)
  800abe:	a1 24 50 80 00       	mov    0x805024,%eax
  800ac3:	8b 50 74             	mov    0x74(%eax),%edx
  800ac6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ac9:	39 c2                	cmp    %eax,%edx
  800acb:	77 cb                	ja     800a98 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800acd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ad0:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800ad3:	74 14                	je     800ae9 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800ad5:	83 ec 04             	sub    $0x4,%esp
  800ad8:	68 24 3f 80 00       	push   $0x803f24
  800add:	6a 44                	push   $0x44
  800adf:	68 c4 3e 80 00       	push   $0x803ec4
  800ae4:	e8 23 fe ff ff       	call   80090c <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800ae9:	90                   	nop
  800aea:	c9                   	leave  
  800aeb:	c3                   	ret    

00800aec <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800aec:	55                   	push   %ebp
  800aed:	89 e5                	mov    %esp,%ebp
  800aef:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800af2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af5:	8b 00                	mov    (%eax),%eax
  800af7:	8d 48 01             	lea    0x1(%eax),%ecx
  800afa:	8b 55 0c             	mov    0xc(%ebp),%edx
  800afd:	89 0a                	mov    %ecx,(%edx)
  800aff:	8b 55 08             	mov    0x8(%ebp),%edx
  800b02:	88 d1                	mov    %dl,%cl
  800b04:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b07:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800b0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0e:	8b 00                	mov    (%eax),%eax
  800b10:	3d ff 00 00 00       	cmp    $0xff,%eax
  800b15:	75 2c                	jne    800b43 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800b17:	a0 28 50 80 00       	mov    0x805028,%al
  800b1c:	0f b6 c0             	movzbl %al,%eax
  800b1f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b22:	8b 12                	mov    (%edx),%edx
  800b24:	89 d1                	mov    %edx,%ecx
  800b26:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b29:	83 c2 08             	add    $0x8,%edx
  800b2c:	83 ec 04             	sub    $0x4,%esp
  800b2f:	50                   	push   %eax
  800b30:	51                   	push   %ecx
  800b31:	52                   	push   %edx
  800b32:	e8 70 11 00 00       	call   801ca7 <sys_cputs>
  800b37:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800b3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800b43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b46:	8b 40 04             	mov    0x4(%eax),%eax
  800b49:	8d 50 01             	lea    0x1(%eax),%edx
  800b4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4f:	89 50 04             	mov    %edx,0x4(%eax)
}
  800b52:	90                   	nop
  800b53:	c9                   	leave  
  800b54:	c3                   	ret    

00800b55 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800b55:	55                   	push   %ebp
  800b56:	89 e5                	mov    %esp,%ebp
  800b58:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800b5e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800b65:	00 00 00 
	b.cnt = 0;
  800b68:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800b6f:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800b72:	ff 75 0c             	pushl  0xc(%ebp)
  800b75:	ff 75 08             	pushl  0x8(%ebp)
  800b78:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b7e:	50                   	push   %eax
  800b7f:	68 ec 0a 80 00       	push   $0x800aec
  800b84:	e8 11 02 00 00       	call   800d9a <vprintfmt>
  800b89:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800b8c:	a0 28 50 80 00       	mov    0x805028,%al
  800b91:	0f b6 c0             	movzbl %al,%eax
  800b94:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800b9a:	83 ec 04             	sub    $0x4,%esp
  800b9d:	50                   	push   %eax
  800b9e:	52                   	push   %edx
  800b9f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800ba5:	83 c0 08             	add    $0x8,%eax
  800ba8:	50                   	push   %eax
  800ba9:	e8 f9 10 00 00       	call   801ca7 <sys_cputs>
  800bae:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800bb1:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
	return b.cnt;
  800bb8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800bbe:	c9                   	leave  
  800bbf:	c3                   	ret    

00800bc0 <cprintf>:

int cprintf(const char *fmt, ...) {
  800bc0:	55                   	push   %ebp
  800bc1:	89 e5                	mov    %esp,%ebp
  800bc3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800bc6:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
	va_start(ap, fmt);
  800bcd:	8d 45 0c             	lea    0xc(%ebp),%eax
  800bd0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd6:	83 ec 08             	sub    $0x8,%esp
  800bd9:	ff 75 f4             	pushl  -0xc(%ebp)
  800bdc:	50                   	push   %eax
  800bdd:	e8 73 ff ff ff       	call   800b55 <vcprintf>
  800be2:	83 c4 10             	add    $0x10,%esp
  800be5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800be8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800beb:	c9                   	leave  
  800bec:	c3                   	ret    

00800bed <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800bed:	55                   	push   %ebp
  800bee:	89 e5                	mov    %esp,%ebp
  800bf0:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800bf3:	e8 5d 12 00 00       	call   801e55 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800bf8:	8d 45 0c             	lea    0xc(%ebp),%eax
  800bfb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800c01:	83 ec 08             	sub    $0x8,%esp
  800c04:	ff 75 f4             	pushl  -0xc(%ebp)
  800c07:	50                   	push   %eax
  800c08:	e8 48 ff ff ff       	call   800b55 <vcprintf>
  800c0d:	83 c4 10             	add    $0x10,%esp
  800c10:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800c13:	e8 57 12 00 00       	call   801e6f <sys_enable_interrupt>
	return cnt;
  800c18:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c1b:	c9                   	leave  
  800c1c:	c3                   	ret    

00800c1d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800c1d:	55                   	push   %ebp
  800c1e:	89 e5                	mov    %esp,%ebp
  800c20:	53                   	push   %ebx
  800c21:	83 ec 14             	sub    $0x14,%esp
  800c24:	8b 45 10             	mov    0x10(%ebp),%eax
  800c27:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c2a:	8b 45 14             	mov    0x14(%ebp),%eax
  800c2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800c30:	8b 45 18             	mov    0x18(%ebp),%eax
  800c33:	ba 00 00 00 00       	mov    $0x0,%edx
  800c38:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c3b:	77 55                	ja     800c92 <printnum+0x75>
  800c3d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c40:	72 05                	jb     800c47 <printnum+0x2a>
  800c42:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800c45:	77 4b                	ja     800c92 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800c47:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800c4a:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800c4d:	8b 45 18             	mov    0x18(%ebp),%eax
  800c50:	ba 00 00 00 00       	mov    $0x0,%edx
  800c55:	52                   	push   %edx
  800c56:	50                   	push   %eax
  800c57:	ff 75 f4             	pushl  -0xc(%ebp)
  800c5a:	ff 75 f0             	pushl  -0x10(%ebp)
  800c5d:	e8 ca 2c 00 00       	call   80392c <__udivdi3>
  800c62:	83 c4 10             	add    $0x10,%esp
  800c65:	83 ec 04             	sub    $0x4,%esp
  800c68:	ff 75 20             	pushl  0x20(%ebp)
  800c6b:	53                   	push   %ebx
  800c6c:	ff 75 18             	pushl  0x18(%ebp)
  800c6f:	52                   	push   %edx
  800c70:	50                   	push   %eax
  800c71:	ff 75 0c             	pushl  0xc(%ebp)
  800c74:	ff 75 08             	pushl  0x8(%ebp)
  800c77:	e8 a1 ff ff ff       	call   800c1d <printnum>
  800c7c:	83 c4 20             	add    $0x20,%esp
  800c7f:	eb 1a                	jmp    800c9b <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800c81:	83 ec 08             	sub    $0x8,%esp
  800c84:	ff 75 0c             	pushl  0xc(%ebp)
  800c87:	ff 75 20             	pushl  0x20(%ebp)
  800c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8d:	ff d0                	call   *%eax
  800c8f:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c92:	ff 4d 1c             	decl   0x1c(%ebp)
  800c95:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800c99:	7f e6                	jg     800c81 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800c9b:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800c9e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ca3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ca6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ca9:	53                   	push   %ebx
  800caa:	51                   	push   %ecx
  800cab:	52                   	push   %edx
  800cac:	50                   	push   %eax
  800cad:	e8 8a 2d 00 00       	call   803a3c <__umoddi3>
  800cb2:	83 c4 10             	add    $0x10,%esp
  800cb5:	05 94 41 80 00       	add    $0x804194,%eax
  800cba:	8a 00                	mov    (%eax),%al
  800cbc:	0f be c0             	movsbl %al,%eax
  800cbf:	83 ec 08             	sub    $0x8,%esp
  800cc2:	ff 75 0c             	pushl  0xc(%ebp)
  800cc5:	50                   	push   %eax
  800cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc9:	ff d0                	call   *%eax
  800ccb:	83 c4 10             	add    $0x10,%esp
}
  800cce:	90                   	nop
  800ccf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800cd2:	c9                   	leave  
  800cd3:	c3                   	ret    

00800cd4 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800cd4:	55                   	push   %ebp
  800cd5:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800cd7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800cdb:	7e 1c                	jle    800cf9 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce0:	8b 00                	mov    (%eax),%eax
  800ce2:	8d 50 08             	lea    0x8(%eax),%edx
  800ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce8:	89 10                	mov    %edx,(%eax)
  800cea:	8b 45 08             	mov    0x8(%ebp),%eax
  800ced:	8b 00                	mov    (%eax),%eax
  800cef:	83 e8 08             	sub    $0x8,%eax
  800cf2:	8b 50 04             	mov    0x4(%eax),%edx
  800cf5:	8b 00                	mov    (%eax),%eax
  800cf7:	eb 40                	jmp    800d39 <getuint+0x65>
	else if (lflag)
  800cf9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cfd:	74 1e                	je     800d1d <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800cff:	8b 45 08             	mov    0x8(%ebp),%eax
  800d02:	8b 00                	mov    (%eax),%eax
  800d04:	8d 50 04             	lea    0x4(%eax),%edx
  800d07:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0a:	89 10                	mov    %edx,(%eax)
  800d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0f:	8b 00                	mov    (%eax),%eax
  800d11:	83 e8 04             	sub    $0x4,%eax
  800d14:	8b 00                	mov    (%eax),%eax
  800d16:	ba 00 00 00 00       	mov    $0x0,%edx
  800d1b:	eb 1c                	jmp    800d39 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d20:	8b 00                	mov    (%eax),%eax
  800d22:	8d 50 04             	lea    0x4(%eax),%edx
  800d25:	8b 45 08             	mov    0x8(%ebp),%eax
  800d28:	89 10                	mov    %edx,(%eax)
  800d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2d:	8b 00                	mov    (%eax),%eax
  800d2f:	83 e8 04             	sub    $0x4,%eax
  800d32:	8b 00                	mov    (%eax),%eax
  800d34:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800d39:	5d                   	pop    %ebp
  800d3a:	c3                   	ret    

00800d3b <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800d3b:	55                   	push   %ebp
  800d3c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d3e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d42:	7e 1c                	jle    800d60 <getint+0x25>
		return va_arg(*ap, long long);
  800d44:	8b 45 08             	mov    0x8(%ebp),%eax
  800d47:	8b 00                	mov    (%eax),%eax
  800d49:	8d 50 08             	lea    0x8(%eax),%edx
  800d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4f:	89 10                	mov    %edx,(%eax)
  800d51:	8b 45 08             	mov    0x8(%ebp),%eax
  800d54:	8b 00                	mov    (%eax),%eax
  800d56:	83 e8 08             	sub    $0x8,%eax
  800d59:	8b 50 04             	mov    0x4(%eax),%edx
  800d5c:	8b 00                	mov    (%eax),%eax
  800d5e:	eb 38                	jmp    800d98 <getint+0x5d>
	else if (lflag)
  800d60:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d64:	74 1a                	je     800d80 <getint+0x45>
		return va_arg(*ap, long);
  800d66:	8b 45 08             	mov    0x8(%ebp),%eax
  800d69:	8b 00                	mov    (%eax),%eax
  800d6b:	8d 50 04             	lea    0x4(%eax),%edx
  800d6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d71:	89 10                	mov    %edx,(%eax)
  800d73:	8b 45 08             	mov    0x8(%ebp),%eax
  800d76:	8b 00                	mov    (%eax),%eax
  800d78:	83 e8 04             	sub    $0x4,%eax
  800d7b:	8b 00                	mov    (%eax),%eax
  800d7d:	99                   	cltd   
  800d7e:	eb 18                	jmp    800d98 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800d80:	8b 45 08             	mov    0x8(%ebp),%eax
  800d83:	8b 00                	mov    (%eax),%eax
  800d85:	8d 50 04             	lea    0x4(%eax),%edx
  800d88:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8b:	89 10                	mov    %edx,(%eax)
  800d8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d90:	8b 00                	mov    (%eax),%eax
  800d92:	83 e8 04             	sub    $0x4,%eax
  800d95:	8b 00                	mov    (%eax),%eax
  800d97:	99                   	cltd   
}
  800d98:	5d                   	pop    %ebp
  800d99:	c3                   	ret    

00800d9a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800d9a:	55                   	push   %ebp
  800d9b:	89 e5                	mov    %esp,%ebp
  800d9d:	56                   	push   %esi
  800d9e:	53                   	push   %ebx
  800d9f:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800da2:	eb 17                	jmp    800dbb <vprintfmt+0x21>
			if (ch == '\0')
  800da4:	85 db                	test   %ebx,%ebx
  800da6:	0f 84 af 03 00 00    	je     80115b <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800dac:	83 ec 08             	sub    $0x8,%esp
  800daf:	ff 75 0c             	pushl  0xc(%ebp)
  800db2:	53                   	push   %ebx
  800db3:	8b 45 08             	mov    0x8(%ebp),%eax
  800db6:	ff d0                	call   *%eax
  800db8:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800dbb:	8b 45 10             	mov    0x10(%ebp),%eax
  800dbe:	8d 50 01             	lea    0x1(%eax),%edx
  800dc1:	89 55 10             	mov    %edx,0x10(%ebp)
  800dc4:	8a 00                	mov    (%eax),%al
  800dc6:	0f b6 d8             	movzbl %al,%ebx
  800dc9:	83 fb 25             	cmp    $0x25,%ebx
  800dcc:	75 d6                	jne    800da4 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800dce:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800dd2:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800dd9:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800de0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800de7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800dee:	8b 45 10             	mov    0x10(%ebp),%eax
  800df1:	8d 50 01             	lea    0x1(%eax),%edx
  800df4:	89 55 10             	mov    %edx,0x10(%ebp)
  800df7:	8a 00                	mov    (%eax),%al
  800df9:	0f b6 d8             	movzbl %al,%ebx
  800dfc:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800dff:	83 f8 55             	cmp    $0x55,%eax
  800e02:	0f 87 2b 03 00 00    	ja     801133 <vprintfmt+0x399>
  800e08:	8b 04 85 b8 41 80 00 	mov    0x8041b8(,%eax,4),%eax
  800e0f:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800e11:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800e15:	eb d7                	jmp    800dee <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800e17:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800e1b:	eb d1                	jmp    800dee <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e1d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800e24:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800e27:	89 d0                	mov    %edx,%eax
  800e29:	c1 e0 02             	shl    $0x2,%eax
  800e2c:	01 d0                	add    %edx,%eax
  800e2e:	01 c0                	add    %eax,%eax
  800e30:	01 d8                	add    %ebx,%eax
  800e32:	83 e8 30             	sub    $0x30,%eax
  800e35:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800e38:	8b 45 10             	mov    0x10(%ebp),%eax
  800e3b:	8a 00                	mov    (%eax),%al
  800e3d:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800e40:	83 fb 2f             	cmp    $0x2f,%ebx
  800e43:	7e 3e                	jle    800e83 <vprintfmt+0xe9>
  800e45:	83 fb 39             	cmp    $0x39,%ebx
  800e48:	7f 39                	jg     800e83 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e4a:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800e4d:	eb d5                	jmp    800e24 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800e4f:	8b 45 14             	mov    0x14(%ebp),%eax
  800e52:	83 c0 04             	add    $0x4,%eax
  800e55:	89 45 14             	mov    %eax,0x14(%ebp)
  800e58:	8b 45 14             	mov    0x14(%ebp),%eax
  800e5b:	83 e8 04             	sub    $0x4,%eax
  800e5e:	8b 00                	mov    (%eax),%eax
  800e60:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800e63:	eb 1f                	jmp    800e84 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800e65:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e69:	79 83                	jns    800dee <vprintfmt+0x54>
				width = 0;
  800e6b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800e72:	e9 77 ff ff ff       	jmp    800dee <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800e77:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800e7e:	e9 6b ff ff ff       	jmp    800dee <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800e83:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800e84:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e88:	0f 89 60 ff ff ff    	jns    800dee <vprintfmt+0x54>
				width = precision, precision = -1;
  800e8e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e91:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800e94:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800e9b:	e9 4e ff ff ff       	jmp    800dee <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ea0:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800ea3:	e9 46 ff ff ff       	jmp    800dee <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800ea8:	8b 45 14             	mov    0x14(%ebp),%eax
  800eab:	83 c0 04             	add    $0x4,%eax
  800eae:	89 45 14             	mov    %eax,0x14(%ebp)
  800eb1:	8b 45 14             	mov    0x14(%ebp),%eax
  800eb4:	83 e8 04             	sub    $0x4,%eax
  800eb7:	8b 00                	mov    (%eax),%eax
  800eb9:	83 ec 08             	sub    $0x8,%esp
  800ebc:	ff 75 0c             	pushl  0xc(%ebp)
  800ebf:	50                   	push   %eax
  800ec0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec3:	ff d0                	call   *%eax
  800ec5:	83 c4 10             	add    $0x10,%esp
			break;
  800ec8:	e9 89 02 00 00       	jmp    801156 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ecd:	8b 45 14             	mov    0x14(%ebp),%eax
  800ed0:	83 c0 04             	add    $0x4,%eax
  800ed3:	89 45 14             	mov    %eax,0x14(%ebp)
  800ed6:	8b 45 14             	mov    0x14(%ebp),%eax
  800ed9:	83 e8 04             	sub    $0x4,%eax
  800edc:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ede:	85 db                	test   %ebx,%ebx
  800ee0:	79 02                	jns    800ee4 <vprintfmt+0x14a>
				err = -err;
  800ee2:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ee4:	83 fb 64             	cmp    $0x64,%ebx
  800ee7:	7f 0b                	jg     800ef4 <vprintfmt+0x15a>
  800ee9:	8b 34 9d 00 40 80 00 	mov    0x804000(,%ebx,4),%esi
  800ef0:	85 f6                	test   %esi,%esi
  800ef2:	75 19                	jne    800f0d <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ef4:	53                   	push   %ebx
  800ef5:	68 a5 41 80 00       	push   $0x8041a5
  800efa:	ff 75 0c             	pushl  0xc(%ebp)
  800efd:	ff 75 08             	pushl  0x8(%ebp)
  800f00:	e8 5e 02 00 00       	call   801163 <printfmt>
  800f05:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800f08:	e9 49 02 00 00       	jmp    801156 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800f0d:	56                   	push   %esi
  800f0e:	68 ae 41 80 00       	push   $0x8041ae
  800f13:	ff 75 0c             	pushl  0xc(%ebp)
  800f16:	ff 75 08             	pushl  0x8(%ebp)
  800f19:	e8 45 02 00 00       	call   801163 <printfmt>
  800f1e:	83 c4 10             	add    $0x10,%esp
			break;
  800f21:	e9 30 02 00 00       	jmp    801156 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800f26:	8b 45 14             	mov    0x14(%ebp),%eax
  800f29:	83 c0 04             	add    $0x4,%eax
  800f2c:	89 45 14             	mov    %eax,0x14(%ebp)
  800f2f:	8b 45 14             	mov    0x14(%ebp),%eax
  800f32:	83 e8 04             	sub    $0x4,%eax
  800f35:	8b 30                	mov    (%eax),%esi
  800f37:	85 f6                	test   %esi,%esi
  800f39:	75 05                	jne    800f40 <vprintfmt+0x1a6>
				p = "(null)";
  800f3b:	be b1 41 80 00       	mov    $0x8041b1,%esi
			if (width > 0 && padc != '-')
  800f40:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f44:	7e 6d                	jle    800fb3 <vprintfmt+0x219>
  800f46:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800f4a:	74 67                	je     800fb3 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800f4c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f4f:	83 ec 08             	sub    $0x8,%esp
  800f52:	50                   	push   %eax
  800f53:	56                   	push   %esi
  800f54:	e8 0c 03 00 00       	call   801265 <strnlen>
  800f59:	83 c4 10             	add    $0x10,%esp
  800f5c:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800f5f:	eb 16                	jmp    800f77 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800f61:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800f65:	83 ec 08             	sub    $0x8,%esp
  800f68:	ff 75 0c             	pushl  0xc(%ebp)
  800f6b:	50                   	push   %eax
  800f6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6f:	ff d0                	call   *%eax
  800f71:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800f74:	ff 4d e4             	decl   -0x1c(%ebp)
  800f77:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f7b:	7f e4                	jg     800f61 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f7d:	eb 34                	jmp    800fb3 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800f7f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800f83:	74 1c                	je     800fa1 <vprintfmt+0x207>
  800f85:	83 fb 1f             	cmp    $0x1f,%ebx
  800f88:	7e 05                	jle    800f8f <vprintfmt+0x1f5>
  800f8a:	83 fb 7e             	cmp    $0x7e,%ebx
  800f8d:	7e 12                	jle    800fa1 <vprintfmt+0x207>
					putch('?', putdat);
  800f8f:	83 ec 08             	sub    $0x8,%esp
  800f92:	ff 75 0c             	pushl  0xc(%ebp)
  800f95:	6a 3f                	push   $0x3f
  800f97:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9a:	ff d0                	call   *%eax
  800f9c:	83 c4 10             	add    $0x10,%esp
  800f9f:	eb 0f                	jmp    800fb0 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800fa1:	83 ec 08             	sub    $0x8,%esp
  800fa4:	ff 75 0c             	pushl  0xc(%ebp)
  800fa7:	53                   	push   %ebx
  800fa8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fab:	ff d0                	call   *%eax
  800fad:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800fb0:	ff 4d e4             	decl   -0x1c(%ebp)
  800fb3:	89 f0                	mov    %esi,%eax
  800fb5:	8d 70 01             	lea    0x1(%eax),%esi
  800fb8:	8a 00                	mov    (%eax),%al
  800fba:	0f be d8             	movsbl %al,%ebx
  800fbd:	85 db                	test   %ebx,%ebx
  800fbf:	74 24                	je     800fe5 <vprintfmt+0x24b>
  800fc1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800fc5:	78 b8                	js     800f7f <vprintfmt+0x1e5>
  800fc7:	ff 4d e0             	decl   -0x20(%ebp)
  800fca:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800fce:	79 af                	jns    800f7f <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800fd0:	eb 13                	jmp    800fe5 <vprintfmt+0x24b>
				putch(' ', putdat);
  800fd2:	83 ec 08             	sub    $0x8,%esp
  800fd5:	ff 75 0c             	pushl  0xc(%ebp)
  800fd8:	6a 20                	push   $0x20
  800fda:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdd:	ff d0                	call   *%eax
  800fdf:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800fe2:	ff 4d e4             	decl   -0x1c(%ebp)
  800fe5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fe9:	7f e7                	jg     800fd2 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800feb:	e9 66 01 00 00       	jmp    801156 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ff0:	83 ec 08             	sub    $0x8,%esp
  800ff3:	ff 75 e8             	pushl  -0x18(%ebp)
  800ff6:	8d 45 14             	lea    0x14(%ebp),%eax
  800ff9:	50                   	push   %eax
  800ffa:	e8 3c fd ff ff       	call   800d3b <getint>
  800fff:	83 c4 10             	add    $0x10,%esp
  801002:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801005:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801008:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80100b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80100e:	85 d2                	test   %edx,%edx
  801010:	79 23                	jns    801035 <vprintfmt+0x29b>
				putch('-', putdat);
  801012:	83 ec 08             	sub    $0x8,%esp
  801015:	ff 75 0c             	pushl  0xc(%ebp)
  801018:	6a 2d                	push   $0x2d
  80101a:	8b 45 08             	mov    0x8(%ebp),%eax
  80101d:	ff d0                	call   *%eax
  80101f:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801022:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801025:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801028:	f7 d8                	neg    %eax
  80102a:	83 d2 00             	adc    $0x0,%edx
  80102d:	f7 da                	neg    %edx
  80102f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801032:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801035:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80103c:	e9 bc 00 00 00       	jmp    8010fd <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801041:	83 ec 08             	sub    $0x8,%esp
  801044:	ff 75 e8             	pushl  -0x18(%ebp)
  801047:	8d 45 14             	lea    0x14(%ebp),%eax
  80104a:	50                   	push   %eax
  80104b:	e8 84 fc ff ff       	call   800cd4 <getuint>
  801050:	83 c4 10             	add    $0x10,%esp
  801053:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801056:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801059:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801060:	e9 98 00 00 00       	jmp    8010fd <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801065:	83 ec 08             	sub    $0x8,%esp
  801068:	ff 75 0c             	pushl  0xc(%ebp)
  80106b:	6a 58                	push   $0x58
  80106d:	8b 45 08             	mov    0x8(%ebp),%eax
  801070:	ff d0                	call   *%eax
  801072:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801075:	83 ec 08             	sub    $0x8,%esp
  801078:	ff 75 0c             	pushl  0xc(%ebp)
  80107b:	6a 58                	push   $0x58
  80107d:	8b 45 08             	mov    0x8(%ebp),%eax
  801080:	ff d0                	call   *%eax
  801082:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801085:	83 ec 08             	sub    $0x8,%esp
  801088:	ff 75 0c             	pushl  0xc(%ebp)
  80108b:	6a 58                	push   $0x58
  80108d:	8b 45 08             	mov    0x8(%ebp),%eax
  801090:	ff d0                	call   *%eax
  801092:	83 c4 10             	add    $0x10,%esp
			break;
  801095:	e9 bc 00 00 00       	jmp    801156 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  80109a:	83 ec 08             	sub    $0x8,%esp
  80109d:	ff 75 0c             	pushl  0xc(%ebp)
  8010a0:	6a 30                	push   $0x30
  8010a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a5:	ff d0                	call   *%eax
  8010a7:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8010aa:	83 ec 08             	sub    $0x8,%esp
  8010ad:	ff 75 0c             	pushl  0xc(%ebp)
  8010b0:	6a 78                	push   $0x78
  8010b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b5:	ff d0                	call   *%eax
  8010b7:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8010ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8010bd:	83 c0 04             	add    $0x4,%eax
  8010c0:	89 45 14             	mov    %eax,0x14(%ebp)
  8010c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8010c6:	83 e8 04             	sub    $0x4,%eax
  8010c9:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8010cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010ce:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8010d5:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8010dc:	eb 1f                	jmp    8010fd <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8010de:	83 ec 08             	sub    $0x8,%esp
  8010e1:	ff 75 e8             	pushl  -0x18(%ebp)
  8010e4:	8d 45 14             	lea    0x14(%ebp),%eax
  8010e7:	50                   	push   %eax
  8010e8:	e8 e7 fb ff ff       	call   800cd4 <getuint>
  8010ed:	83 c4 10             	add    $0x10,%esp
  8010f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010f3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8010f6:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8010fd:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801101:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801104:	83 ec 04             	sub    $0x4,%esp
  801107:	52                   	push   %edx
  801108:	ff 75 e4             	pushl  -0x1c(%ebp)
  80110b:	50                   	push   %eax
  80110c:	ff 75 f4             	pushl  -0xc(%ebp)
  80110f:	ff 75 f0             	pushl  -0x10(%ebp)
  801112:	ff 75 0c             	pushl  0xc(%ebp)
  801115:	ff 75 08             	pushl  0x8(%ebp)
  801118:	e8 00 fb ff ff       	call   800c1d <printnum>
  80111d:	83 c4 20             	add    $0x20,%esp
			break;
  801120:	eb 34                	jmp    801156 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801122:	83 ec 08             	sub    $0x8,%esp
  801125:	ff 75 0c             	pushl  0xc(%ebp)
  801128:	53                   	push   %ebx
  801129:	8b 45 08             	mov    0x8(%ebp),%eax
  80112c:	ff d0                	call   *%eax
  80112e:	83 c4 10             	add    $0x10,%esp
			break;
  801131:	eb 23                	jmp    801156 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801133:	83 ec 08             	sub    $0x8,%esp
  801136:	ff 75 0c             	pushl  0xc(%ebp)
  801139:	6a 25                	push   $0x25
  80113b:	8b 45 08             	mov    0x8(%ebp),%eax
  80113e:	ff d0                	call   *%eax
  801140:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801143:	ff 4d 10             	decl   0x10(%ebp)
  801146:	eb 03                	jmp    80114b <vprintfmt+0x3b1>
  801148:	ff 4d 10             	decl   0x10(%ebp)
  80114b:	8b 45 10             	mov    0x10(%ebp),%eax
  80114e:	48                   	dec    %eax
  80114f:	8a 00                	mov    (%eax),%al
  801151:	3c 25                	cmp    $0x25,%al
  801153:	75 f3                	jne    801148 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801155:	90                   	nop
		}
	}
  801156:	e9 47 fc ff ff       	jmp    800da2 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80115b:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80115c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80115f:	5b                   	pop    %ebx
  801160:	5e                   	pop    %esi
  801161:	5d                   	pop    %ebp
  801162:	c3                   	ret    

00801163 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801163:	55                   	push   %ebp
  801164:	89 e5                	mov    %esp,%ebp
  801166:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801169:	8d 45 10             	lea    0x10(%ebp),%eax
  80116c:	83 c0 04             	add    $0x4,%eax
  80116f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801172:	8b 45 10             	mov    0x10(%ebp),%eax
  801175:	ff 75 f4             	pushl  -0xc(%ebp)
  801178:	50                   	push   %eax
  801179:	ff 75 0c             	pushl  0xc(%ebp)
  80117c:	ff 75 08             	pushl  0x8(%ebp)
  80117f:	e8 16 fc ff ff       	call   800d9a <vprintfmt>
  801184:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801187:	90                   	nop
  801188:	c9                   	leave  
  801189:	c3                   	ret    

0080118a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80118a:	55                   	push   %ebp
  80118b:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80118d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801190:	8b 40 08             	mov    0x8(%eax),%eax
  801193:	8d 50 01             	lea    0x1(%eax),%edx
  801196:	8b 45 0c             	mov    0xc(%ebp),%eax
  801199:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80119c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119f:	8b 10                	mov    (%eax),%edx
  8011a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a4:	8b 40 04             	mov    0x4(%eax),%eax
  8011a7:	39 c2                	cmp    %eax,%edx
  8011a9:	73 12                	jae    8011bd <sprintputch+0x33>
		*b->buf++ = ch;
  8011ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ae:	8b 00                	mov    (%eax),%eax
  8011b0:	8d 48 01             	lea    0x1(%eax),%ecx
  8011b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011b6:	89 0a                	mov    %ecx,(%edx)
  8011b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8011bb:	88 10                	mov    %dl,(%eax)
}
  8011bd:	90                   	nop
  8011be:	5d                   	pop    %ebp
  8011bf:	c3                   	ret    

008011c0 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8011c0:	55                   	push   %ebp
  8011c1:	89 e5                	mov    %esp,%ebp
  8011c3:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8011c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8011cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011cf:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d5:	01 d0                	add    %edx,%eax
  8011d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011da:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8011e1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011e5:	74 06                	je     8011ed <vsnprintf+0x2d>
  8011e7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011eb:	7f 07                	jg     8011f4 <vsnprintf+0x34>
		return -E_INVAL;
  8011ed:	b8 03 00 00 00       	mov    $0x3,%eax
  8011f2:	eb 20                	jmp    801214 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8011f4:	ff 75 14             	pushl  0x14(%ebp)
  8011f7:	ff 75 10             	pushl  0x10(%ebp)
  8011fa:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8011fd:	50                   	push   %eax
  8011fe:	68 8a 11 80 00       	push   $0x80118a
  801203:	e8 92 fb ff ff       	call   800d9a <vprintfmt>
  801208:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80120b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80120e:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801211:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801214:	c9                   	leave  
  801215:	c3                   	ret    

00801216 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801216:	55                   	push   %ebp
  801217:	89 e5                	mov    %esp,%ebp
  801219:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80121c:	8d 45 10             	lea    0x10(%ebp),%eax
  80121f:	83 c0 04             	add    $0x4,%eax
  801222:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801225:	8b 45 10             	mov    0x10(%ebp),%eax
  801228:	ff 75 f4             	pushl  -0xc(%ebp)
  80122b:	50                   	push   %eax
  80122c:	ff 75 0c             	pushl  0xc(%ebp)
  80122f:	ff 75 08             	pushl  0x8(%ebp)
  801232:	e8 89 ff ff ff       	call   8011c0 <vsnprintf>
  801237:	83 c4 10             	add    $0x10,%esp
  80123a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80123d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801240:	c9                   	leave  
  801241:	c3                   	ret    

00801242 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801242:	55                   	push   %ebp
  801243:	89 e5                	mov    %esp,%ebp
  801245:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801248:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80124f:	eb 06                	jmp    801257 <strlen+0x15>
		n++;
  801251:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801254:	ff 45 08             	incl   0x8(%ebp)
  801257:	8b 45 08             	mov    0x8(%ebp),%eax
  80125a:	8a 00                	mov    (%eax),%al
  80125c:	84 c0                	test   %al,%al
  80125e:	75 f1                	jne    801251 <strlen+0xf>
		n++;
	return n;
  801260:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801263:	c9                   	leave  
  801264:	c3                   	ret    

00801265 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801265:	55                   	push   %ebp
  801266:	89 e5                	mov    %esp,%ebp
  801268:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80126b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801272:	eb 09                	jmp    80127d <strnlen+0x18>
		n++;
  801274:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801277:	ff 45 08             	incl   0x8(%ebp)
  80127a:	ff 4d 0c             	decl   0xc(%ebp)
  80127d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801281:	74 09                	je     80128c <strnlen+0x27>
  801283:	8b 45 08             	mov    0x8(%ebp),%eax
  801286:	8a 00                	mov    (%eax),%al
  801288:	84 c0                	test   %al,%al
  80128a:	75 e8                	jne    801274 <strnlen+0xf>
		n++;
	return n;
  80128c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80128f:	c9                   	leave  
  801290:	c3                   	ret    

00801291 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801291:	55                   	push   %ebp
  801292:	89 e5                	mov    %esp,%ebp
  801294:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801297:	8b 45 08             	mov    0x8(%ebp),%eax
  80129a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80129d:	90                   	nop
  80129e:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a1:	8d 50 01             	lea    0x1(%eax),%edx
  8012a4:	89 55 08             	mov    %edx,0x8(%ebp)
  8012a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012aa:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012ad:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8012b0:	8a 12                	mov    (%edx),%dl
  8012b2:	88 10                	mov    %dl,(%eax)
  8012b4:	8a 00                	mov    (%eax),%al
  8012b6:	84 c0                	test   %al,%al
  8012b8:	75 e4                	jne    80129e <strcpy+0xd>
		/* do nothing */;
	return ret;
  8012ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012bd:	c9                   	leave  
  8012be:	c3                   	ret    

008012bf <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8012bf:	55                   	push   %ebp
  8012c0:	89 e5                	mov    %esp,%ebp
  8012c2:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8012c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8012cb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012d2:	eb 1f                	jmp    8012f3 <strncpy+0x34>
		*dst++ = *src;
  8012d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d7:	8d 50 01             	lea    0x1(%eax),%edx
  8012da:	89 55 08             	mov    %edx,0x8(%ebp)
  8012dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012e0:	8a 12                	mov    (%edx),%dl
  8012e2:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8012e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e7:	8a 00                	mov    (%eax),%al
  8012e9:	84 c0                	test   %al,%al
  8012eb:	74 03                	je     8012f0 <strncpy+0x31>
			src++;
  8012ed:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8012f0:	ff 45 fc             	incl   -0x4(%ebp)
  8012f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012f6:	3b 45 10             	cmp    0x10(%ebp),%eax
  8012f9:	72 d9                	jb     8012d4 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8012fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8012fe:	c9                   	leave  
  8012ff:	c3                   	ret    

00801300 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801300:	55                   	push   %ebp
  801301:	89 e5                	mov    %esp,%ebp
  801303:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801306:	8b 45 08             	mov    0x8(%ebp),%eax
  801309:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80130c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801310:	74 30                	je     801342 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801312:	eb 16                	jmp    80132a <strlcpy+0x2a>
			*dst++ = *src++;
  801314:	8b 45 08             	mov    0x8(%ebp),%eax
  801317:	8d 50 01             	lea    0x1(%eax),%edx
  80131a:	89 55 08             	mov    %edx,0x8(%ebp)
  80131d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801320:	8d 4a 01             	lea    0x1(%edx),%ecx
  801323:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801326:	8a 12                	mov    (%edx),%dl
  801328:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80132a:	ff 4d 10             	decl   0x10(%ebp)
  80132d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801331:	74 09                	je     80133c <strlcpy+0x3c>
  801333:	8b 45 0c             	mov    0xc(%ebp),%eax
  801336:	8a 00                	mov    (%eax),%al
  801338:	84 c0                	test   %al,%al
  80133a:	75 d8                	jne    801314 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80133c:	8b 45 08             	mov    0x8(%ebp),%eax
  80133f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801342:	8b 55 08             	mov    0x8(%ebp),%edx
  801345:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801348:	29 c2                	sub    %eax,%edx
  80134a:	89 d0                	mov    %edx,%eax
}
  80134c:	c9                   	leave  
  80134d:	c3                   	ret    

0080134e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80134e:	55                   	push   %ebp
  80134f:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801351:	eb 06                	jmp    801359 <strcmp+0xb>
		p++, q++;
  801353:	ff 45 08             	incl   0x8(%ebp)
  801356:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801359:	8b 45 08             	mov    0x8(%ebp),%eax
  80135c:	8a 00                	mov    (%eax),%al
  80135e:	84 c0                	test   %al,%al
  801360:	74 0e                	je     801370 <strcmp+0x22>
  801362:	8b 45 08             	mov    0x8(%ebp),%eax
  801365:	8a 10                	mov    (%eax),%dl
  801367:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136a:	8a 00                	mov    (%eax),%al
  80136c:	38 c2                	cmp    %al,%dl
  80136e:	74 e3                	je     801353 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801370:	8b 45 08             	mov    0x8(%ebp),%eax
  801373:	8a 00                	mov    (%eax),%al
  801375:	0f b6 d0             	movzbl %al,%edx
  801378:	8b 45 0c             	mov    0xc(%ebp),%eax
  80137b:	8a 00                	mov    (%eax),%al
  80137d:	0f b6 c0             	movzbl %al,%eax
  801380:	29 c2                	sub    %eax,%edx
  801382:	89 d0                	mov    %edx,%eax
}
  801384:	5d                   	pop    %ebp
  801385:	c3                   	ret    

00801386 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801386:	55                   	push   %ebp
  801387:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801389:	eb 09                	jmp    801394 <strncmp+0xe>
		n--, p++, q++;
  80138b:	ff 4d 10             	decl   0x10(%ebp)
  80138e:	ff 45 08             	incl   0x8(%ebp)
  801391:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801394:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801398:	74 17                	je     8013b1 <strncmp+0x2b>
  80139a:	8b 45 08             	mov    0x8(%ebp),%eax
  80139d:	8a 00                	mov    (%eax),%al
  80139f:	84 c0                	test   %al,%al
  8013a1:	74 0e                	je     8013b1 <strncmp+0x2b>
  8013a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a6:	8a 10                	mov    (%eax),%dl
  8013a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ab:	8a 00                	mov    (%eax),%al
  8013ad:	38 c2                	cmp    %al,%dl
  8013af:	74 da                	je     80138b <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8013b1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013b5:	75 07                	jne    8013be <strncmp+0x38>
		return 0;
  8013b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8013bc:	eb 14                	jmp    8013d2 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8013be:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c1:	8a 00                	mov    (%eax),%al
  8013c3:	0f b6 d0             	movzbl %al,%edx
  8013c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c9:	8a 00                	mov    (%eax),%al
  8013cb:	0f b6 c0             	movzbl %al,%eax
  8013ce:	29 c2                	sub    %eax,%edx
  8013d0:	89 d0                	mov    %edx,%eax
}
  8013d2:	5d                   	pop    %ebp
  8013d3:	c3                   	ret    

008013d4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8013d4:	55                   	push   %ebp
  8013d5:	89 e5                	mov    %esp,%ebp
  8013d7:	83 ec 04             	sub    $0x4,%esp
  8013da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013dd:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8013e0:	eb 12                	jmp    8013f4 <strchr+0x20>
		if (*s == c)
  8013e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e5:	8a 00                	mov    (%eax),%al
  8013e7:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8013ea:	75 05                	jne    8013f1 <strchr+0x1d>
			return (char *) s;
  8013ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ef:	eb 11                	jmp    801402 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8013f1:	ff 45 08             	incl   0x8(%ebp)
  8013f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f7:	8a 00                	mov    (%eax),%al
  8013f9:	84 c0                	test   %al,%al
  8013fb:	75 e5                	jne    8013e2 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8013fd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801402:	c9                   	leave  
  801403:	c3                   	ret    

00801404 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801404:	55                   	push   %ebp
  801405:	89 e5                	mov    %esp,%ebp
  801407:	83 ec 04             	sub    $0x4,%esp
  80140a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80140d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801410:	eb 0d                	jmp    80141f <strfind+0x1b>
		if (*s == c)
  801412:	8b 45 08             	mov    0x8(%ebp),%eax
  801415:	8a 00                	mov    (%eax),%al
  801417:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80141a:	74 0e                	je     80142a <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80141c:	ff 45 08             	incl   0x8(%ebp)
  80141f:	8b 45 08             	mov    0x8(%ebp),%eax
  801422:	8a 00                	mov    (%eax),%al
  801424:	84 c0                	test   %al,%al
  801426:	75 ea                	jne    801412 <strfind+0xe>
  801428:	eb 01                	jmp    80142b <strfind+0x27>
		if (*s == c)
			break;
  80142a:	90                   	nop
	return (char *) s;
  80142b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80142e:	c9                   	leave  
  80142f:	c3                   	ret    

00801430 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801430:	55                   	push   %ebp
  801431:	89 e5                	mov    %esp,%ebp
  801433:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801436:	8b 45 08             	mov    0x8(%ebp),%eax
  801439:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  80143c:	8b 45 10             	mov    0x10(%ebp),%eax
  80143f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801442:	eb 0e                	jmp    801452 <memset+0x22>
		*p++ = c;
  801444:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801447:	8d 50 01             	lea    0x1(%eax),%edx
  80144a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80144d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801450:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801452:	ff 4d f8             	decl   -0x8(%ebp)
  801455:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801459:	79 e9                	jns    801444 <memset+0x14>
		*p++ = c;

	return v;
  80145b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80145e:	c9                   	leave  
  80145f:	c3                   	ret    

00801460 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801460:	55                   	push   %ebp
  801461:	89 e5                	mov    %esp,%ebp
  801463:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801466:	8b 45 0c             	mov    0xc(%ebp),%eax
  801469:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80146c:	8b 45 08             	mov    0x8(%ebp),%eax
  80146f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801472:	eb 16                	jmp    80148a <memcpy+0x2a>
		*d++ = *s++;
  801474:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801477:	8d 50 01             	lea    0x1(%eax),%edx
  80147a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80147d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801480:	8d 4a 01             	lea    0x1(%edx),%ecx
  801483:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801486:	8a 12                	mov    (%edx),%dl
  801488:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80148a:	8b 45 10             	mov    0x10(%ebp),%eax
  80148d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801490:	89 55 10             	mov    %edx,0x10(%ebp)
  801493:	85 c0                	test   %eax,%eax
  801495:	75 dd                	jne    801474 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801497:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80149a:	c9                   	leave  
  80149b:	c3                   	ret    

0080149c <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80149c:	55                   	push   %ebp
  80149d:	89 e5                	mov    %esp,%ebp
  80149f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8014a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8014a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ab:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8014ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014b1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8014b4:	73 50                	jae    801506 <memmove+0x6a>
  8014b6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8014bc:	01 d0                	add    %edx,%eax
  8014be:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8014c1:	76 43                	jbe    801506 <memmove+0x6a>
		s += n;
  8014c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8014c6:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8014c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8014cc:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8014cf:	eb 10                	jmp    8014e1 <memmove+0x45>
			*--d = *--s;
  8014d1:	ff 4d f8             	decl   -0x8(%ebp)
  8014d4:	ff 4d fc             	decl   -0x4(%ebp)
  8014d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014da:	8a 10                	mov    (%eax),%dl
  8014dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014df:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8014e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8014e4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8014e7:	89 55 10             	mov    %edx,0x10(%ebp)
  8014ea:	85 c0                	test   %eax,%eax
  8014ec:	75 e3                	jne    8014d1 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8014ee:	eb 23                	jmp    801513 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8014f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014f3:	8d 50 01             	lea    0x1(%eax),%edx
  8014f6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8014f9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014fc:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014ff:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801502:	8a 12                	mov    (%edx),%dl
  801504:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801506:	8b 45 10             	mov    0x10(%ebp),%eax
  801509:	8d 50 ff             	lea    -0x1(%eax),%edx
  80150c:	89 55 10             	mov    %edx,0x10(%ebp)
  80150f:	85 c0                	test   %eax,%eax
  801511:	75 dd                	jne    8014f0 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801513:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801516:	c9                   	leave  
  801517:	c3                   	ret    

00801518 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801518:	55                   	push   %ebp
  801519:	89 e5                	mov    %esp,%ebp
  80151b:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80151e:	8b 45 08             	mov    0x8(%ebp),%eax
  801521:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801524:	8b 45 0c             	mov    0xc(%ebp),%eax
  801527:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80152a:	eb 2a                	jmp    801556 <memcmp+0x3e>
		if (*s1 != *s2)
  80152c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80152f:	8a 10                	mov    (%eax),%dl
  801531:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801534:	8a 00                	mov    (%eax),%al
  801536:	38 c2                	cmp    %al,%dl
  801538:	74 16                	je     801550 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80153a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80153d:	8a 00                	mov    (%eax),%al
  80153f:	0f b6 d0             	movzbl %al,%edx
  801542:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801545:	8a 00                	mov    (%eax),%al
  801547:	0f b6 c0             	movzbl %al,%eax
  80154a:	29 c2                	sub    %eax,%edx
  80154c:	89 d0                	mov    %edx,%eax
  80154e:	eb 18                	jmp    801568 <memcmp+0x50>
		s1++, s2++;
  801550:	ff 45 fc             	incl   -0x4(%ebp)
  801553:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801556:	8b 45 10             	mov    0x10(%ebp),%eax
  801559:	8d 50 ff             	lea    -0x1(%eax),%edx
  80155c:	89 55 10             	mov    %edx,0x10(%ebp)
  80155f:	85 c0                	test   %eax,%eax
  801561:	75 c9                	jne    80152c <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801563:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801568:	c9                   	leave  
  801569:	c3                   	ret    

0080156a <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80156a:	55                   	push   %ebp
  80156b:	89 e5                	mov    %esp,%ebp
  80156d:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801570:	8b 55 08             	mov    0x8(%ebp),%edx
  801573:	8b 45 10             	mov    0x10(%ebp),%eax
  801576:	01 d0                	add    %edx,%eax
  801578:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80157b:	eb 15                	jmp    801592 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80157d:	8b 45 08             	mov    0x8(%ebp),%eax
  801580:	8a 00                	mov    (%eax),%al
  801582:	0f b6 d0             	movzbl %al,%edx
  801585:	8b 45 0c             	mov    0xc(%ebp),%eax
  801588:	0f b6 c0             	movzbl %al,%eax
  80158b:	39 c2                	cmp    %eax,%edx
  80158d:	74 0d                	je     80159c <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80158f:	ff 45 08             	incl   0x8(%ebp)
  801592:	8b 45 08             	mov    0x8(%ebp),%eax
  801595:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801598:	72 e3                	jb     80157d <memfind+0x13>
  80159a:	eb 01                	jmp    80159d <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80159c:	90                   	nop
	return (void *) s;
  80159d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015a0:	c9                   	leave  
  8015a1:	c3                   	ret    

008015a2 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8015a2:	55                   	push   %ebp
  8015a3:	89 e5                	mov    %esp,%ebp
  8015a5:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8015a8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8015af:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015b6:	eb 03                	jmp    8015bb <strtol+0x19>
		s++;
  8015b8:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015be:	8a 00                	mov    (%eax),%al
  8015c0:	3c 20                	cmp    $0x20,%al
  8015c2:	74 f4                	je     8015b8 <strtol+0x16>
  8015c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c7:	8a 00                	mov    (%eax),%al
  8015c9:	3c 09                	cmp    $0x9,%al
  8015cb:	74 eb                	je     8015b8 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8015cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d0:	8a 00                	mov    (%eax),%al
  8015d2:	3c 2b                	cmp    $0x2b,%al
  8015d4:	75 05                	jne    8015db <strtol+0x39>
		s++;
  8015d6:	ff 45 08             	incl   0x8(%ebp)
  8015d9:	eb 13                	jmp    8015ee <strtol+0x4c>
	else if (*s == '-')
  8015db:	8b 45 08             	mov    0x8(%ebp),%eax
  8015de:	8a 00                	mov    (%eax),%al
  8015e0:	3c 2d                	cmp    $0x2d,%al
  8015e2:	75 0a                	jne    8015ee <strtol+0x4c>
		s++, neg = 1;
  8015e4:	ff 45 08             	incl   0x8(%ebp)
  8015e7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8015ee:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015f2:	74 06                	je     8015fa <strtol+0x58>
  8015f4:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8015f8:	75 20                	jne    80161a <strtol+0x78>
  8015fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fd:	8a 00                	mov    (%eax),%al
  8015ff:	3c 30                	cmp    $0x30,%al
  801601:	75 17                	jne    80161a <strtol+0x78>
  801603:	8b 45 08             	mov    0x8(%ebp),%eax
  801606:	40                   	inc    %eax
  801607:	8a 00                	mov    (%eax),%al
  801609:	3c 78                	cmp    $0x78,%al
  80160b:	75 0d                	jne    80161a <strtol+0x78>
		s += 2, base = 16;
  80160d:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801611:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801618:	eb 28                	jmp    801642 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80161a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80161e:	75 15                	jne    801635 <strtol+0x93>
  801620:	8b 45 08             	mov    0x8(%ebp),%eax
  801623:	8a 00                	mov    (%eax),%al
  801625:	3c 30                	cmp    $0x30,%al
  801627:	75 0c                	jne    801635 <strtol+0x93>
		s++, base = 8;
  801629:	ff 45 08             	incl   0x8(%ebp)
  80162c:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801633:	eb 0d                	jmp    801642 <strtol+0xa0>
	else if (base == 0)
  801635:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801639:	75 07                	jne    801642 <strtol+0xa0>
		base = 10;
  80163b:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801642:	8b 45 08             	mov    0x8(%ebp),%eax
  801645:	8a 00                	mov    (%eax),%al
  801647:	3c 2f                	cmp    $0x2f,%al
  801649:	7e 19                	jle    801664 <strtol+0xc2>
  80164b:	8b 45 08             	mov    0x8(%ebp),%eax
  80164e:	8a 00                	mov    (%eax),%al
  801650:	3c 39                	cmp    $0x39,%al
  801652:	7f 10                	jg     801664 <strtol+0xc2>
			dig = *s - '0';
  801654:	8b 45 08             	mov    0x8(%ebp),%eax
  801657:	8a 00                	mov    (%eax),%al
  801659:	0f be c0             	movsbl %al,%eax
  80165c:	83 e8 30             	sub    $0x30,%eax
  80165f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801662:	eb 42                	jmp    8016a6 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801664:	8b 45 08             	mov    0x8(%ebp),%eax
  801667:	8a 00                	mov    (%eax),%al
  801669:	3c 60                	cmp    $0x60,%al
  80166b:	7e 19                	jle    801686 <strtol+0xe4>
  80166d:	8b 45 08             	mov    0x8(%ebp),%eax
  801670:	8a 00                	mov    (%eax),%al
  801672:	3c 7a                	cmp    $0x7a,%al
  801674:	7f 10                	jg     801686 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801676:	8b 45 08             	mov    0x8(%ebp),%eax
  801679:	8a 00                	mov    (%eax),%al
  80167b:	0f be c0             	movsbl %al,%eax
  80167e:	83 e8 57             	sub    $0x57,%eax
  801681:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801684:	eb 20                	jmp    8016a6 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801686:	8b 45 08             	mov    0x8(%ebp),%eax
  801689:	8a 00                	mov    (%eax),%al
  80168b:	3c 40                	cmp    $0x40,%al
  80168d:	7e 39                	jle    8016c8 <strtol+0x126>
  80168f:	8b 45 08             	mov    0x8(%ebp),%eax
  801692:	8a 00                	mov    (%eax),%al
  801694:	3c 5a                	cmp    $0x5a,%al
  801696:	7f 30                	jg     8016c8 <strtol+0x126>
			dig = *s - 'A' + 10;
  801698:	8b 45 08             	mov    0x8(%ebp),%eax
  80169b:	8a 00                	mov    (%eax),%al
  80169d:	0f be c0             	movsbl %al,%eax
  8016a0:	83 e8 37             	sub    $0x37,%eax
  8016a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8016a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016a9:	3b 45 10             	cmp    0x10(%ebp),%eax
  8016ac:	7d 19                	jge    8016c7 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8016ae:	ff 45 08             	incl   0x8(%ebp)
  8016b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016b4:	0f af 45 10          	imul   0x10(%ebp),%eax
  8016b8:	89 c2                	mov    %eax,%edx
  8016ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016bd:	01 d0                	add    %edx,%eax
  8016bf:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8016c2:	e9 7b ff ff ff       	jmp    801642 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8016c7:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8016c8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016cc:	74 08                	je     8016d6 <strtol+0x134>
		*endptr = (char *) s;
  8016ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8016d4:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8016d6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8016da:	74 07                	je     8016e3 <strtol+0x141>
  8016dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016df:	f7 d8                	neg    %eax
  8016e1:	eb 03                	jmp    8016e6 <strtol+0x144>
  8016e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8016e6:	c9                   	leave  
  8016e7:	c3                   	ret    

008016e8 <ltostr>:

void
ltostr(long value, char *str)
{
  8016e8:	55                   	push   %ebp
  8016e9:	89 e5                	mov    %esp,%ebp
  8016eb:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8016ee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8016f5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8016fc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801700:	79 13                	jns    801715 <ltostr+0x2d>
	{
		neg = 1;
  801702:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801709:	8b 45 0c             	mov    0xc(%ebp),%eax
  80170c:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80170f:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801712:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801715:	8b 45 08             	mov    0x8(%ebp),%eax
  801718:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80171d:	99                   	cltd   
  80171e:	f7 f9                	idiv   %ecx
  801720:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801723:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801726:	8d 50 01             	lea    0x1(%eax),%edx
  801729:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80172c:	89 c2                	mov    %eax,%edx
  80172e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801731:	01 d0                	add    %edx,%eax
  801733:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801736:	83 c2 30             	add    $0x30,%edx
  801739:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80173b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80173e:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801743:	f7 e9                	imul   %ecx
  801745:	c1 fa 02             	sar    $0x2,%edx
  801748:	89 c8                	mov    %ecx,%eax
  80174a:	c1 f8 1f             	sar    $0x1f,%eax
  80174d:	29 c2                	sub    %eax,%edx
  80174f:	89 d0                	mov    %edx,%eax
  801751:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801754:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801757:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80175c:	f7 e9                	imul   %ecx
  80175e:	c1 fa 02             	sar    $0x2,%edx
  801761:	89 c8                	mov    %ecx,%eax
  801763:	c1 f8 1f             	sar    $0x1f,%eax
  801766:	29 c2                	sub    %eax,%edx
  801768:	89 d0                	mov    %edx,%eax
  80176a:	c1 e0 02             	shl    $0x2,%eax
  80176d:	01 d0                	add    %edx,%eax
  80176f:	01 c0                	add    %eax,%eax
  801771:	29 c1                	sub    %eax,%ecx
  801773:	89 ca                	mov    %ecx,%edx
  801775:	85 d2                	test   %edx,%edx
  801777:	75 9c                	jne    801715 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801779:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801780:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801783:	48                   	dec    %eax
  801784:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801787:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80178b:	74 3d                	je     8017ca <ltostr+0xe2>
		start = 1 ;
  80178d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801794:	eb 34                	jmp    8017ca <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801796:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801799:	8b 45 0c             	mov    0xc(%ebp),%eax
  80179c:	01 d0                	add    %edx,%eax
  80179e:	8a 00                	mov    (%eax),%al
  8017a0:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8017a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017a9:	01 c2                	add    %eax,%edx
  8017ab:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8017ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017b1:	01 c8                	add    %ecx,%eax
  8017b3:	8a 00                	mov    (%eax),%al
  8017b5:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8017b7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017bd:	01 c2                	add    %eax,%edx
  8017bf:	8a 45 eb             	mov    -0x15(%ebp),%al
  8017c2:	88 02                	mov    %al,(%edx)
		start++ ;
  8017c4:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8017c7:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8017ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017cd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8017d0:	7c c4                	jl     801796 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8017d2:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8017d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017d8:	01 d0                	add    %edx,%eax
  8017da:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8017dd:	90                   	nop
  8017de:	c9                   	leave  
  8017df:	c3                   	ret    

008017e0 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8017e0:	55                   	push   %ebp
  8017e1:	89 e5                	mov    %esp,%ebp
  8017e3:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8017e6:	ff 75 08             	pushl  0x8(%ebp)
  8017e9:	e8 54 fa ff ff       	call   801242 <strlen>
  8017ee:	83 c4 04             	add    $0x4,%esp
  8017f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8017f4:	ff 75 0c             	pushl  0xc(%ebp)
  8017f7:	e8 46 fa ff ff       	call   801242 <strlen>
  8017fc:	83 c4 04             	add    $0x4,%esp
  8017ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801802:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801809:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801810:	eb 17                	jmp    801829 <strcconcat+0x49>
		final[s] = str1[s] ;
  801812:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801815:	8b 45 10             	mov    0x10(%ebp),%eax
  801818:	01 c2                	add    %eax,%edx
  80181a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80181d:	8b 45 08             	mov    0x8(%ebp),%eax
  801820:	01 c8                	add    %ecx,%eax
  801822:	8a 00                	mov    (%eax),%al
  801824:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801826:	ff 45 fc             	incl   -0x4(%ebp)
  801829:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80182c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80182f:	7c e1                	jl     801812 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801831:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801838:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80183f:	eb 1f                	jmp    801860 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801841:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801844:	8d 50 01             	lea    0x1(%eax),%edx
  801847:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80184a:	89 c2                	mov    %eax,%edx
  80184c:	8b 45 10             	mov    0x10(%ebp),%eax
  80184f:	01 c2                	add    %eax,%edx
  801851:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801854:	8b 45 0c             	mov    0xc(%ebp),%eax
  801857:	01 c8                	add    %ecx,%eax
  801859:	8a 00                	mov    (%eax),%al
  80185b:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80185d:	ff 45 f8             	incl   -0x8(%ebp)
  801860:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801863:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801866:	7c d9                	jl     801841 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801868:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80186b:	8b 45 10             	mov    0x10(%ebp),%eax
  80186e:	01 d0                	add    %edx,%eax
  801870:	c6 00 00             	movb   $0x0,(%eax)
}
  801873:	90                   	nop
  801874:	c9                   	leave  
  801875:	c3                   	ret    

00801876 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801876:	55                   	push   %ebp
  801877:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801879:	8b 45 14             	mov    0x14(%ebp),%eax
  80187c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801882:	8b 45 14             	mov    0x14(%ebp),%eax
  801885:	8b 00                	mov    (%eax),%eax
  801887:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80188e:	8b 45 10             	mov    0x10(%ebp),%eax
  801891:	01 d0                	add    %edx,%eax
  801893:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801899:	eb 0c                	jmp    8018a7 <strsplit+0x31>
			*string++ = 0;
  80189b:	8b 45 08             	mov    0x8(%ebp),%eax
  80189e:	8d 50 01             	lea    0x1(%eax),%edx
  8018a1:	89 55 08             	mov    %edx,0x8(%ebp)
  8018a4:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8018a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018aa:	8a 00                	mov    (%eax),%al
  8018ac:	84 c0                	test   %al,%al
  8018ae:	74 18                	je     8018c8 <strsplit+0x52>
  8018b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b3:	8a 00                	mov    (%eax),%al
  8018b5:	0f be c0             	movsbl %al,%eax
  8018b8:	50                   	push   %eax
  8018b9:	ff 75 0c             	pushl  0xc(%ebp)
  8018bc:	e8 13 fb ff ff       	call   8013d4 <strchr>
  8018c1:	83 c4 08             	add    $0x8,%esp
  8018c4:	85 c0                	test   %eax,%eax
  8018c6:	75 d3                	jne    80189b <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8018c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cb:	8a 00                	mov    (%eax),%al
  8018cd:	84 c0                	test   %al,%al
  8018cf:	74 5a                	je     80192b <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8018d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8018d4:	8b 00                	mov    (%eax),%eax
  8018d6:	83 f8 0f             	cmp    $0xf,%eax
  8018d9:	75 07                	jne    8018e2 <strsplit+0x6c>
		{
			return 0;
  8018db:	b8 00 00 00 00       	mov    $0x0,%eax
  8018e0:	eb 66                	jmp    801948 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8018e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8018e5:	8b 00                	mov    (%eax),%eax
  8018e7:	8d 48 01             	lea    0x1(%eax),%ecx
  8018ea:	8b 55 14             	mov    0x14(%ebp),%edx
  8018ed:	89 0a                	mov    %ecx,(%edx)
  8018ef:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8018f9:	01 c2                	add    %eax,%edx
  8018fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fe:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801900:	eb 03                	jmp    801905 <strsplit+0x8f>
			string++;
  801902:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801905:	8b 45 08             	mov    0x8(%ebp),%eax
  801908:	8a 00                	mov    (%eax),%al
  80190a:	84 c0                	test   %al,%al
  80190c:	74 8b                	je     801899 <strsplit+0x23>
  80190e:	8b 45 08             	mov    0x8(%ebp),%eax
  801911:	8a 00                	mov    (%eax),%al
  801913:	0f be c0             	movsbl %al,%eax
  801916:	50                   	push   %eax
  801917:	ff 75 0c             	pushl  0xc(%ebp)
  80191a:	e8 b5 fa ff ff       	call   8013d4 <strchr>
  80191f:	83 c4 08             	add    $0x8,%esp
  801922:	85 c0                	test   %eax,%eax
  801924:	74 dc                	je     801902 <strsplit+0x8c>
			string++;
	}
  801926:	e9 6e ff ff ff       	jmp    801899 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80192b:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80192c:	8b 45 14             	mov    0x14(%ebp),%eax
  80192f:	8b 00                	mov    (%eax),%eax
  801931:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801938:	8b 45 10             	mov    0x10(%ebp),%eax
  80193b:	01 d0                	add    %edx,%eax
  80193d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801943:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801948:	c9                   	leave  
  801949:	c3                   	ret    

0080194a <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  80194a:	55                   	push   %ebp
  80194b:	89 e5                	mov    %esp,%ebp
  80194d:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801950:	a1 04 50 80 00       	mov    0x805004,%eax
  801955:	85 c0                	test   %eax,%eax
  801957:	74 1f                	je     801978 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801959:	e8 1d 00 00 00       	call   80197b <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  80195e:	83 ec 0c             	sub    $0xc,%esp
  801961:	68 10 43 80 00       	push   $0x804310
  801966:	e8 55 f2 ff ff       	call   800bc0 <cprintf>
  80196b:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80196e:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801975:	00 00 00 
	}
}
  801978:	90                   	nop
  801979:	c9                   	leave  
  80197a:	c3                   	ret    

0080197b <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80197b:	55                   	push   %ebp
  80197c:	89 e5                	mov    %esp,%ebp
  80197e:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	LIST_INIT(&AllocMemBlocksList);
  801981:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801988:	00 00 00 
  80198b:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801992:	00 00 00 
  801995:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  80199c:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  80199f:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  8019a6:	00 00 00 
  8019a9:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  8019b0:	00 00 00 
  8019b3:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  8019ba:	00 00 00 
	uint32 arr_size = 0;
  8019bd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	MemBlockNodes  =(struct MemBlock*) USER_DYN_BLKS_ARRAY;
  8019c4:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  8019cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019ce:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8019d3:	2d 00 10 00 00       	sub    $0x1000,%eax
  8019d8:	a3 50 50 80 00       	mov    %eax,0x805050
	MAX_MEM_BLOCK_CNT = (USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE;
  8019dd:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  8019e4:	00 02 00 
	arr_size =  ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock), PAGE_SIZE);
  8019e7:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8019ee:	a1 20 51 80 00       	mov    0x805120,%eax
  8019f3:	c1 e0 04             	shl    $0x4,%eax
  8019f6:	89 c2                	mov    %eax,%edx
  8019f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019fb:	01 d0                	add    %edx,%eax
  8019fd:	48                   	dec    %eax
  8019fe:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801a01:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a04:	ba 00 00 00 00       	mov    $0x0,%edx
  801a09:	f7 75 ec             	divl   -0x14(%ebp)
  801a0c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a0f:	29 d0                	sub    %edx,%eax
  801a11:	89 45 f4             	mov    %eax,-0xc(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_PRESENT);
  801a14:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801a1b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a1e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801a23:	2d 00 10 00 00       	sub    $0x1000,%eax
  801a28:	83 ec 04             	sub    $0x4,%esp
  801a2b:	6a 03                	push   $0x3
  801a2d:	ff 75 f4             	pushl  -0xc(%ebp)
  801a30:	50                   	push   %eax
  801a31:	e8 b5 03 00 00       	call   801deb <sys_allocate_chunk>
  801a36:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801a39:	a1 20 51 80 00       	mov    0x805120,%eax
  801a3e:	83 ec 0c             	sub    $0xc,%esp
  801a41:	50                   	push   %eax
  801a42:	e8 2a 0a 00 00       	call   802471 <initialize_MemBlocksList>
  801a47:	83 c4 10             	add    $0x10,%esp
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	struct MemBlock * NewBlock = LIST_FIRST(&AvailableMemBlocksList);
  801a4a:	a1 48 51 80 00       	mov    0x805148,%eax
  801a4f:	89 45 e0             	mov    %eax,-0x20(%ebp)
	NewBlock->sva = USER_HEAP_START;
  801a52:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a55:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	NewBlock->size = (USER_HEAP_MAX-USER_HEAP_START);
  801a5c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a5f:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	LIST_REMOVE(&AvailableMemBlocksList,NewBlock);
  801a66:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801a6a:	75 14                	jne    801a80 <initialize_dyn_block_system+0x105>
  801a6c:	83 ec 04             	sub    $0x4,%esp
  801a6f:	68 35 43 80 00       	push   $0x804335
  801a74:	6a 33                	push   $0x33
  801a76:	68 53 43 80 00       	push   $0x804353
  801a7b:	e8 8c ee ff ff       	call   80090c <_panic>
  801a80:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a83:	8b 00                	mov    (%eax),%eax
  801a85:	85 c0                	test   %eax,%eax
  801a87:	74 10                	je     801a99 <initialize_dyn_block_system+0x11e>
  801a89:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a8c:	8b 00                	mov    (%eax),%eax
  801a8e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a91:	8b 52 04             	mov    0x4(%edx),%edx
  801a94:	89 50 04             	mov    %edx,0x4(%eax)
  801a97:	eb 0b                	jmp    801aa4 <initialize_dyn_block_system+0x129>
  801a99:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a9c:	8b 40 04             	mov    0x4(%eax),%eax
  801a9f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801aa4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801aa7:	8b 40 04             	mov    0x4(%eax),%eax
  801aaa:	85 c0                	test   %eax,%eax
  801aac:	74 0f                	je     801abd <initialize_dyn_block_system+0x142>
  801aae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ab1:	8b 40 04             	mov    0x4(%eax),%eax
  801ab4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ab7:	8b 12                	mov    (%edx),%edx
  801ab9:	89 10                	mov    %edx,(%eax)
  801abb:	eb 0a                	jmp    801ac7 <initialize_dyn_block_system+0x14c>
  801abd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ac0:	8b 00                	mov    (%eax),%eax
  801ac2:	a3 48 51 80 00       	mov    %eax,0x805148
  801ac7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801aca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801ad0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ad3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801ada:	a1 54 51 80 00       	mov    0x805154,%eax
  801adf:	48                   	dec    %eax
  801ae0:	a3 54 51 80 00       	mov    %eax,0x805154
	LIST_INSERT_HEAD(&FreeMemBlocksList, NewBlock);
  801ae5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801ae9:	75 14                	jne    801aff <initialize_dyn_block_system+0x184>
  801aeb:	83 ec 04             	sub    $0x4,%esp
  801aee:	68 60 43 80 00       	push   $0x804360
  801af3:	6a 34                	push   $0x34
  801af5:	68 53 43 80 00       	push   $0x804353
  801afa:	e8 0d ee ff ff       	call   80090c <_panic>
  801aff:	8b 15 38 51 80 00    	mov    0x805138,%edx
  801b05:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b08:	89 10                	mov    %edx,(%eax)
  801b0a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b0d:	8b 00                	mov    (%eax),%eax
  801b0f:	85 c0                	test   %eax,%eax
  801b11:	74 0d                	je     801b20 <initialize_dyn_block_system+0x1a5>
  801b13:	a1 38 51 80 00       	mov    0x805138,%eax
  801b18:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b1b:	89 50 04             	mov    %edx,0x4(%eax)
  801b1e:	eb 08                	jmp    801b28 <initialize_dyn_block_system+0x1ad>
  801b20:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b23:	a3 3c 51 80 00       	mov    %eax,0x80513c
  801b28:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b2b:	a3 38 51 80 00       	mov    %eax,0x805138
  801b30:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b33:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801b3a:	a1 44 51 80 00       	mov    0x805144,%eax
  801b3f:	40                   	inc    %eax
  801b40:	a3 44 51 80 00       	mov    %eax,0x805144
}
  801b45:	90                   	nop
  801b46:	c9                   	leave  
  801b47:	c3                   	ret    

00801b48 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801b48:	55                   	push   %ebp
  801b49:	89 e5                	mov    %esp,%ebp
  801b4b:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801b4e:	e8 f7 fd ff ff       	call   80194a <InitializeUHeap>
	if (size == 0) return NULL ;
  801b53:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b57:	75 07                	jne    801b60 <malloc+0x18>
  801b59:	b8 00 00 00 00       	mov    $0x0,%eax
  801b5e:	eb 14                	jmp    801b74 <malloc+0x2c>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801b60:	83 ec 04             	sub    $0x4,%esp
  801b63:	68 84 43 80 00       	push   $0x804384
  801b68:	6a 46                	push   $0x46
  801b6a:	68 53 43 80 00       	push   $0x804353
  801b6f:	e8 98 ed ff ff       	call   80090c <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801b74:	c9                   	leave  
  801b75:	c3                   	ret    

00801b76 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801b76:	55                   	push   %ebp
  801b77:	89 e5                	mov    %esp,%ebp
  801b79:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801b7c:	83 ec 04             	sub    $0x4,%esp
  801b7f:	68 ac 43 80 00       	push   $0x8043ac
  801b84:	6a 61                	push   $0x61
  801b86:	68 53 43 80 00       	push   $0x804353
  801b8b:	e8 7c ed ff ff       	call   80090c <_panic>

00801b90 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801b90:	55                   	push   %ebp
  801b91:	89 e5                	mov    %esp,%ebp
  801b93:	83 ec 18             	sub    $0x18,%esp
  801b96:	8b 45 10             	mov    0x10(%ebp),%eax
  801b99:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801b9c:	e8 a9 fd ff ff       	call   80194a <InitializeUHeap>
	if (size == 0) return NULL ;
  801ba1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801ba5:	75 07                	jne    801bae <smalloc+0x1e>
  801ba7:	b8 00 00 00 00       	mov    $0x0,%eax
  801bac:	eb 14                	jmp    801bc2 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801bae:	83 ec 04             	sub    $0x4,%esp
  801bb1:	68 d0 43 80 00       	push   $0x8043d0
  801bb6:	6a 76                	push   $0x76
  801bb8:	68 53 43 80 00       	push   $0x804353
  801bbd:	e8 4a ed ff ff       	call   80090c <_panic>

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801bc2:	c9                   	leave  
  801bc3:	c3                   	ret    

00801bc4 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801bc4:	55                   	push   %ebp
  801bc5:	89 e5                	mov    %esp,%ebp
  801bc7:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801bca:	e8 7b fd ff ff       	call   80194a <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801bcf:	83 ec 04             	sub    $0x4,%esp
  801bd2:	68 f8 43 80 00       	push   $0x8043f8
  801bd7:	68 93 00 00 00       	push   $0x93
  801bdc:	68 53 43 80 00       	push   $0x804353
  801be1:	e8 26 ed ff ff       	call   80090c <_panic>

00801be6 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801be6:	55                   	push   %ebp
  801be7:	89 e5                	mov    %esp,%ebp
  801be9:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801bec:	e8 59 fd ff ff       	call   80194a <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801bf1:	83 ec 04             	sub    $0x4,%esp
  801bf4:	68 1c 44 80 00       	push   $0x80441c
  801bf9:	68 c5 00 00 00       	push   $0xc5
  801bfe:	68 53 43 80 00       	push   $0x804353
  801c03:	e8 04 ed ff ff       	call   80090c <_panic>

00801c08 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801c08:	55                   	push   %ebp
  801c09:	89 e5                	mov    %esp,%ebp
  801c0b:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801c0e:	83 ec 04             	sub    $0x4,%esp
  801c11:	68 44 44 80 00       	push   $0x804444
  801c16:	68 d9 00 00 00       	push   $0xd9
  801c1b:	68 53 43 80 00       	push   $0x804353
  801c20:	e8 e7 ec ff ff       	call   80090c <_panic>

00801c25 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801c25:	55                   	push   %ebp
  801c26:	89 e5                	mov    %esp,%ebp
  801c28:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c2b:	83 ec 04             	sub    $0x4,%esp
  801c2e:	68 68 44 80 00       	push   $0x804468
  801c33:	68 e4 00 00 00       	push   $0xe4
  801c38:	68 53 43 80 00       	push   $0x804353
  801c3d:	e8 ca ec ff ff       	call   80090c <_panic>

00801c42 <shrink>:

}
void shrink(uint32 newSize)
{
  801c42:	55                   	push   %ebp
  801c43:	89 e5                	mov    %esp,%ebp
  801c45:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c48:	83 ec 04             	sub    $0x4,%esp
  801c4b:	68 68 44 80 00       	push   $0x804468
  801c50:	68 e9 00 00 00       	push   $0xe9
  801c55:	68 53 43 80 00       	push   $0x804353
  801c5a:	e8 ad ec ff ff       	call   80090c <_panic>

00801c5f <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801c5f:	55                   	push   %ebp
  801c60:	89 e5                	mov    %esp,%ebp
  801c62:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c65:	83 ec 04             	sub    $0x4,%esp
  801c68:	68 68 44 80 00       	push   $0x804468
  801c6d:	68 ee 00 00 00       	push   $0xee
  801c72:	68 53 43 80 00       	push   $0x804353
  801c77:	e8 90 ec ff ff       	call   80090c <_panic>

00801c7c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801c7c:	55                   	push   %ebp
  801c7d:	89 e5                	mov    %esp,%ebp
  801c7f:	57                   	push   %edi
  801c80:	56                   	push   %esi
  801c81:	53                   	push   %ebx
  801c82:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801c85:	8b 45 08             	mov    0x8(%ebp),%eax
  801c88:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c8b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c8e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c91:	8b 7d 18             	mov    0x18(%ebp),%edi
  801c94:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801c97:	cd 30                	int    $0x30
  801c99:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801c9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801c9f:	83 c4 10             	add    $0x10,%esp
  801ca2:	5b                   	pop    %ebx
  801ca3:	5e                   	pop    %esi
  801ca4:	5f                   	pop    %edi
  801ca5:	5d                   	pop    %ebp
  801ca6:	c3                   	ret    

00801ca7 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801ca7:	55                   	push   %ebp
  801ca8:	89 e5                	mov    %esp,%ebp
  801caa:	83 ec 04             	sub    $0x4,%esp
  801cad:	8b 45 10             	mov    0x10(%ebp),%eax
  801cb0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801cb3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801cb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cba:	6a 00                	push   $0x0
  801cbc:	6a 00                	push   $0x0
  801cbe:	52                   	push   %edx
  801cbf:	ff 75 0c             	pushl  0xc(%ebp)
  801cc2:	50                   	push   %eax
  801cc3:	6a 00                	push   $0x0
  801cc5:	e8 b2 ff ff ff       	call   801c7c <syscall>
  801cca:	83 c4 18             	add    $0x18,%esp
}
  801ccd:	90                   	nop
  801cce:	c9                   	leave  
  801ccf:	c3                   	ret    

00801cd0 <sys_cgetc>:

int
sys_cgetc(void)
{
  801cd0:	55                   	push   %ebp
  801cd1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801cd3:	6a 00                	push   $0x0
  801cd5:	6a 00                	push   $0x0
  801cd7:	6a 00                	push   $0x0
  801cd9:	6a 00                	push   $0x0
  801cdb:	6a 00                	push   $0x0
  801cdd:	6a 01                	push   $0x1
  801cdf:	e8 98 ff ff ff       	call   801c7c <syscall>
  801ce4:	83 c4 18             	add    $0x18,%esp
}
  801ce7:	c9                   	leave  
  801ce8:	c3                   	ret    

00801ce9 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801ce9:	55                   	push   %ebp
  801cea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801cec:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cef:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf2:	6a 00                	push   $0x0
  801cf4:	6a 00                	push   $0x0
  801cf6:	6a 00                	push   $0x0
  801cf8:	52                   	push   %edx
  801cf9:	50                   	push   %eax
  801cfa:	6a 05                	push   $0x5
  801cfc:	e8 7b ff ff ff       	call   801c7c <syscall>
  801d01:	83 c4 18             	add    $0x18,%esp
}
  801d04:	c9                   	leave  
  801d05:	c3                   	ret    

00801d06 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801d06:	55                   	push   %ebp
  801d07:	89 e5                	mov    %esp,%ebp
  801d09:	56                   	push   %esi
  801d0a:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801d0b:	8b 75 18             	mov    0x18(%ebp),%esi
  801d0e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d11:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d14:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d17:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1a:	56                   	push   %esi
  801d1b:	53                   	push   %ebx
  801d1c:	51                   	push   %ecx
  801d1d:	52                   	push   %edx
  801d1e:	50                   	push   %eax
  801d1f:	6a 06                	push   $0x6
  801d21:	e8 56 ff ff ff       	call   801c7c <syscall>
  801d26:	83 c4 18             	add    $0x18,%esp
}
  801d29:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d2c:	5b                   	pop    %ebx
  801d2d:	5e                   	pop    %esi
  801d2e:	5d                   	pop    %ebp
  801d2f:	c3                   	ret    

00801d30 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801d30:	55                   	push   %ebp
  801d31:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801d33:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d36:	8b 45 08             	mov    0x8(%ebp),%eax
  801d39:	6a 00                	push   $0x0
  801d3b:	6a 00                	push   $0x0
  801d3d:	6a 00                	push   $0x0
  801d3f:	52                   	push   %edx
  801d40:	50                   	push   %eax
  801d41:	6a 07                	push   $0x7
  801d43:	e8 34 ff ff ff       	call   801c7c <syscall>
  801d48:	83 c4 18             	add    $0x18,%esp
}
  801d4b:	c9                   	leave  
  801d4c:	c3                   	ret    

00801d4d <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801d4d:	55                   	push   %ebp
  801d4e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801d50:	6a 00                	push   $0x0
  801d52:	6a 00                	push   $0x0
  801d54:	6a 00                	push   $0x0
  801d56:	ff 75 0c             	pushl  0xc(%ebp)
  801d59:	ff 75 08             	pushl  0x8(%ebp)
  801d5c:	6a 08                	push   $0x8
  801d5e:	e8 19 ff ff ff       	call   801c7c <syscall>
  801d63:	83 c4 18             	add    $0x18,%esp
}
  801d66:	c9                   	leave  
  801d67:	c3                   	ret    

00801d68 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801d68:	55                   	push   %ebp
  801d69:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801d6b:	6a 00                	push   $0x0
  801d6d:	6a 00                	push   $0x0
  801d6f:	6a 00                	push   $0x0
  801d71:	6a 00                	push   $0x0
  801d73:	6a 00                	push   $0x0
  801d75:	6a 09                	push   $0x9
  801d77:	e8 00 ff ff ff       	call   801c7c <syscall>
  801d7c:	83 c4 18             	add    $0x18,%esp
}
  801d7f:	c9                   	leave  
  801d80:	c3                   	ret    

00801d81 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801d81:	55                   	push   %ebp
  801d82:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801d84:	6a 00                	push   $0x0
  801d86:	6a 00                	push   $0x0
  801d88:	6a 00                	push   $0x0
  801d8a:	6a 00                	push   $0x0
  801d8c:	6a 00                	push   $0x0
  801d8e:	6a 0a                	push   $0xa
  801d90:	e8 e7 fe ff ff       	call   801c7c <syscall>
  801d95:	83 c4 18             	add    $0x18,%esp
}
  801d98:	c9                   	leave  
  801d99:	c3                   	ret    

00801d9a <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801d9a:	55                   	push   %ebp
  801d9b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801d9d:	6a 00                	push   $0x0
  801d9f:	6a 00                	push   $0x0
  801da1:	6a 00                	push   $0x0
  801da3:	6a 00                	push   $0x0
  801da5:	6a 00                	push   $0x0
  801da7:	6a 0b                	push   $0xb
  801da9:	e8 ce fe ff ff       	call   801c7c <syscall>
  801dae:	83 c4 18             	add    $0x18,%esp
}
  801db1:	c9                   	leave  
  801db2:	c3                   	ret    

00801db3 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801db3:	55                   	push   %ebp
  801db4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801db6:	6a 00                	push   $0x0
  801db8:	6a 00                	push   $0x0
  801dba:	6a 00                	push   $0x0
  801dbc:	ff 75 0c             	pushl  0xc(%ebp)
  801dbf:	ff 75 08             	pushl  0x8(%ebp)
  801dc2:	6a 0f                	push   $0xf
  801dc4:	e8 b3 fe ff ff       	call   801c7c <syscall>
  801dc9:	83 c4 18             	add    $0x18,%esp
	return;
  801dcc:	90                   	nop
}
  801dcd:	c9                   	leave  
  801dce:	c3                   	ret    

00801dcf <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801dcf:	55                   	push   %ebp
  801dd0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801dd2:	6a 00                	push   $0x0
  801dd4:	6a 00                	push   $0x0
  801dd6:	6a 00                	push   $0x0
  801dd8:	ff 75 0c             	pushl  0xc(%ebp)
  801ddb:	ff 75 08             	pushl  0x8(%ebp)
  801dde:	6a 10                	push   $0x10
  801de0:	e8 97 fe ff ff       	call   801c7c <syscall>
  801de5:	83 c4 18             	add    $0x18,%esp
	return ;
  801de8:	90                   	nop
}
  801de9:	c9                   	leave  
  801dea:	c3                   	ret    

00801deb <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801deb:	55                   	push   %ebp
  801dec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801dee:	6a 00                	push   $0x0
  801df0:	6a 00                	push   $0x0
  801df2:	ff 75 10             	pushl  0x10(%ebp)
  801df5:	ff 75 0c             	pushl  0xc(%ebp)
  801df8:	ff 75 08             	pushl  0x8(%ebp)
  801dfb:	6a 11                	push   $0x11
  801dfd:	e8 7a fe ff ff       	call   801c7c <syscall>
  801e02:	83 c4 18             	add    $0x18,%esp
	return ;
  801e05:	90                   	nop
}
  801e06:	c9                   	leave  
  801e07:	c3                   	ret    

00801e08 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801e08:	55                   	push   %ebp
  801e09:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801e0b:	6a 00                	push   $0x0
  801e0d:	6a 00                	push   $0x0
  801e0f:	6a 00                	push   $0x0
  801e11:	6a 00                	push   $0x0
  801e13:	6a 00                	push   $0x0
  801e15:	6a 0c                	push   $0xc
  801e17:	e8 60 fe ff ff       	call   801c7c <syscall>
  801e1c:	83 c4 18             	add    $0x18,%esp
}
  801e1f:	c9                   	leave  
  801e20:	c3                   	ret    

00801e21 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801e21:	55                   	push   %ebp
  801e22:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801e24:	6a 00                	push   $0x0
  801e26:	6a 00                	push   $0x0
  801e28:	6a 00                	push   $0x0
  801e2a:	6a 00                	push   $0x0
  801e2c:	ff 75 08             	pushl  0x8(%ebp)
  801e2f:	6a 0d                	push   $0xd
  801e31:	e8 46 fe ff ff       	call   801c7c <syscall>
  801e36:	83 c4 18             	add    $0x18,%esp
}
  801e39:	c9                   	leave  
  801e3a:	c3                   	ret    

00801e3b <sys_scarce_memory>:

void sys_scarce_memory()
{
  801e3b:	55                   	push   %ebp
  801e3c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801e3e:	6a 00                	push   $0x0
  801e40:	6a 00                	push   $0x0
  801e42:	6a 00                	push   $0x0
  801e44:	6a 00                	push   $0x0
  801e46:	6a 00                	push   $0x0
  801e48:	6a 0e                	push   $0xe
  801e4a:	e8 2d fe ff ff       	call   801c7c <syscall>
  801e4f:	83 c4 18             	add    $0x18,%esp
}
  801e52:	90                   	nop
  801e53:	c9                   	leave  
  801e54:	c3                   	ret    

00801e55 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801e55:	55                   	push   %ebp
  801e56:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801e58:	6a 00                	push   $0x0
  801e5a:	6a 00                	push   $0x0
  801e5c:	6a 00                	push   $0x0
  801e5e:	6a 00                	push   $0x0
  801e60:	6a 00                	push   $0x0
  801e62:	6a 13                	push   $0x13
  801e64:	e8 13 fe ff ff       	call   801c7c <syscall>
  801e69:	83 c4 18             	add    $0x18,%esp
}
  801e6c:	90                   	nop
  801e6d:	c9                   	leave  
  801e6e:	c3                   	ret    

00801e6f <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801e6f:	55                   	push   %ebp
  801e70:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801e72:	6a 00                	push   $0x0
  801e74:	6a 00                	push   $0x0
  801e76:	6a 00                	push   $0x0
  801e78:	6a 00                	push   $0x0
  801e7a:	6a 00                	push   $0x0
  801e7c:	6a 14                	push   $0x14
  801e7e:	e8 f9 fd ff ff       	call   801c7c <syscall>
  801e83:	83 c4 18             	add    $0x18,%esp
}
  801e86:	90                   	nop
  801e87:	c9                   	leave  
  801e88:	c3                   	ret    

00801e89 <sys_cputc>:


void
sys_cputc(const char c)
{
  801e89:	55                   	push   %ebp
  801e8a:	89 e5                	mov    %esp,%ebp
  801e8c:	83 ec 04             	sub    $0x4,%esp
  801e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e92:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801e95:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e99:	6a 00                	push   $0x0
  801e9b:	6a 00                	push   $0x0
  801e9d:	6a 00                	push   $0x0
  801e9f:	6a 00                	push   $0x0
  801ea1:	50                   	push   %eax
  801ea2:	6a 15                	push   $0x15
  801ea4:	e8 d3 fd ff ff       	call   801c7c <syscall>
  801ea9:	83 c4 18             	add    $0x18,%esp
}
  801eac:	90                   	nop
  801ead:	c9                   	leave  
  801eae:	c3                   	ret    

00801eaf <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801eaf:	55                   	push   %ebp
  801eb0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801eb2:	6a 00                	push   $0x0
  801eb4:	6a 00                	push   $0x0
  801eb6:	6a 00                	push   $0x0
  801eb8:	6a 00                	push   $0x0
  801eba:	6a 00                	push   $0x0
  801ebc:	6a 16                	push   $0x16
  801ebe:	e8 b9 fd ff ff       	call   801c7c <syscall>
  801ec3:	83 c4 18             	add    $0x18,%esp
}
  801ec6:	90                   	nop
  801ec7:	c9                   	leave  
  801ec8:	c3                   	ret    

00801ec9 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801ec9:	55                   	push   %ebp
  801eca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  801ecf:	6a 00                	push   $0x0
  801ed1:	6a 00                	push   $0x0
  801ed3:	6a 00                	push   $0x0
  801ed5:	ff 75 0c             	pushl  0xc(%ebp)
  801ed8:	50                   	push   %eax
  801ed9:	6a 17                	push   $0x17
  801edb:	e8 9c fd ff ff       	call   801c7c <syscall>
  801ee0:	83 c4 18             	add    $0x18,%esp
}
  801ee3:	c9                   	leave  
  801ee4:	c3                   	ret    

00801ee5 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801ee5:	55                   	push   %ebp
  801ee6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ee8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eeb:	8b 45 08             	mov    0x8(%ebp),%eax
  801eee:	6a 00                	push   $0x0
  801ef0:	6a 00                	push   $0x0
  801ef2:	6a 00                	push   $0x0
  801ef4:	52                   	push   %edx
  801ef5:	50                   	push   %eax
  801ef6:	6a 1a                	push   $0x1a
  801ef8:	e8 7f fd ff ff       	call   801c7c <syscall>
  801efd:	83 c4 18             	add    $0x18,%esp
}
  801f00:	c9                   	leave  
  801f01:	c3                   	ret    

00801f02 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801f02:	55                   	push   %ebp
  801f03:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f05:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f08:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0b:	6a 00                	push   $0x0
  801f0d:	6a 00                	push   $0x0
  801f0f:	6a 00                	push   $0x0
  801f11:	52                   	push   %edx
  801f12:	50                   	push   %eax
  801f13:	6a 18                	push   $0x18
  801f15:	e8 62 fd ff ff       	call   801c7c <syscall>
  801f1a:	83 c4 18             	add    $0x18,%esp
}
  801f1d:	90                   	nop
  801f1e:	c9                   	leave  
  801f1f:	c3                   	ret    

00801f20 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801f20:	55                   	push   %ebp
  801f21:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f23:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f26:	8b 45 08             	mov    0x8(%ebp),%eax
  801f29:	6a 00                	push   $0x0
  801f2b:	6a 00                	push   $0x0
  801f2d:	6a 00                	push   $0x0
  801f2f:	52                   	push   %edx
  801f30:	50                   	push   %eax
  801f31:	6a 19                	push   $0x19
  801f33:	e8 44 fd ff ff       	call   801c7c <syscall>
  801f38:	83 c4 18             	add    $0x18,%esp
}
  801f3b:	90                   	nop
  801f3c:	c9                   	leave  
  801f3d:	c3                   	ret    

00801f3e <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801f3e:	55                   	push   %ebp
  801f3f:	89 e5                	mov    %esp,%ebp
  801f41:	83 ec 04             	sub    $0x4,%esp
  801f44:	8b 45 10             	mov    0x10(%ebp),%eax
  801f47:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801f4a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801f4d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f51:	8b 45 08             	mov    0x8(%ebp),%eax
  801f54:	6a 00                	push   $0x0
  801f56:	51                   	push   %ecx
  801f57:	52                   	push   %edx
  801f58:	ff 75 0c             	pushl  0xc(%ebp)
  801f5b:	50                   	push   %eax
  801f5c:	6a 1b                	push   $0x1b
  801f5e:	e8 19 fd ff ff       	call   801c7c <syscall>
  801f63:	83 c4 18             	add    $0x18,%esp
}
  801f66:	c9                   	leave  
  801f67:	c3                   	ret    

00801f68 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801f68:	55                   	push   %ebp
  801f69:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801f6b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f71:	6a 00                	push   $0x0
  801f73:	6a 00                	push   $0x0
  801f75:	6a 00                	push   $0x0
  801f77:	52                   	push   %edx
  801f78:	50                   	push   %eax
  801f79:	6a 1c                	push   $0x1c
  801f7b:	e8 fc fc ff ff       	call   801c7c <syscall>
  801f80:	83 c4 18             	add    $0x18,%esp
}
  801f83:	c9                   	leave  
  801f84:	c3                   	ret    

00801f85 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801f85:	55                   	push   %ebp
  801f86:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801f88:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f91:	6a 00                	push   $0x0
  801f93:	6a 00                	push   $0x0
  801f95:	51                   	push   %ecx
  801f96:	52                   	push   %edx
  801f97:	50                   	push   %eax
  801f98:	6a 1d                	push   $0x1d
  801f9a:	e8 dd fc ff ff       	call   801c7c <syscall>
  801f9f:	83 c4 18             	add    $0x18,%esp
}
  801fa2:	c9                   	leave  
  801fa3:	c3                   	ret    

00801fa4 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801fa4:	55                   	push   %ebp
  801fa5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801fa7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801faa:	8b 45 08             	mov    0x8(%ebp),%eax
  801fad:	6a 00                	push   $0x0
  801faf:	6a 00                	push   $0x0
  801fb1:	6a 00                	push   $0x0
  801fb3:	52                   	push   %edx
  801fb4:	50                   	push   %eax
  801fb5:	6a 1e                	push   $0x1e
  801fb7:	e8 c0 fc ff ff       	call   801c7c <syscall>
  801fbc:	83 c4 18             	add    $0x18,%esp
}
  801fbf:	c9                   	leave  
  801fc0:	c3                   	ret    

00801fc1 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801fc1:	55                   	push   %ebp
  801fc2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801fc4:	6a 00                	push   $0x0
  801fc6:	6a 00                	push   $0x0
  801fc8:	6a 00                	push   $0x0
  801fca:	6a 00                	push   $0x0
  801fcc:	6a 00                	push   $0x0
  801fce:	6a 1f                	push   $0x1f
  801fd0:	e8 a7 fc ff ff       	call   801c7c <syscall>
  801fd5:	83 c4 18             	add    $0x18,%esp
}
  801fd8:	c9                   	leave  
  801fd9:	c3                   	ret    

00801fda <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801fda:	55                   	push   %ebp
  801fdb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801fdd:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe0:	6a 00                	push   $0x0
  801fe2:	ff 75 14             	pushl  0x14(%ebp)
  801fe5:	ff 75 10             	pushl  0x10(%ebp)
  801fe8:	ff 75 0c             	pushl  0xc(%ebp)
  801feb:	50                   	push   %eax
  801fec:	6a 20                	push   $0x20
  801fee:	e8 89 fc ff ff       	call   801c7c <syscall>
  801ff3:	83 c4 18             	add    $0x18,%esp
}
  801ff6:	c9                   	leave  
  801ff7:	c3                   	ret    

00801ff8 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801ff8:	55                   	push   %ebp
  801ff9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801ffb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffe:	6a 00                	push   $0x0
  802000:	6a 00                	push   $0x0
  802002:	6a 00                	push   $0x0
  802004:	6a 00                	push   $0x0
  802006:	50                   	push   %eax
  802007:	6a 21                	push   $0x21
  802009:	e8 6e fc ff ff       	call   801c7c <syscall>
  80200e:	83 c4 18             	add    $0x18,%esp
}
  802011:	90                   	nop
  802012:	c9                   	leave  
  802013:	c3                   	ret    

00802014 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802014:	55                   	push   %ebp
  802015:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802017:	8b 45 08             	mov    0x8(%ebp),%eax
  80201a:	6a 00                	push   $0x0
  80201c:	6a 00                	push   $0x0
  80201e:	6a 00                	push   $0x0
  802020:	6a 00                	push   $0x0
  802022:	50                   	push   %eax
  802023:	6a 22                	push   $0x22
  802025:	e8 52 fc ff ff       	call   801c7c <syscall>
  80202a:	83 c4 18             	add    $0x18,%esp
}
  80202d:	c9                   	leave  
  80202e:	c3                   	ret    

0080202f <sys_getenvid>:

int32 sys_getenvid(void)
{
  80202f:	55                   	push   %ebp
  802030:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802032:	6a 00                	push   $0x0
  802034:	6a 00                	push   $0x0
  802036:	6a 00                	push   $0x0
  802038:	6a 00                	push   $0x0
  80203a:	6a 00                	push   $0x0
  80203c:	6a 02                	push   $0x2
  80203e:	e8 39 fc ff ff       	call   801c7c <syscall>
  802043:	83 c4 18             	add    $0x18,%esp
}
  802046:	c9                   	leave  
  802047:	c3                   	ret    

00802048 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802048:	55                   	push   %ebp
  802049:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80204b:	6a 00                	push   $0x0
  80204d:	6a 00                	push   $0x0
  80204f:	6a 00                	push   $0x0
  802051:	6a 00                	push   $0x0
  802053:	6a 00                	push   $0x0
  802055:	6a 03                	push   $0x3
  802057:	e8 20 fc ff ff       	call   801c7c <syscall>
  80205c:	83 c4 18             	add    $0x18,%esp
}
  80205f:	c9                   	leave  
  802060:	c3                   	ret    

00802061 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802061:	55                   	push   %ebp
  802062:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802064:	6a 00                	push   $0x0
  802066:	6a 00                	push   $0x0
  802068:	6a 00                	push   $0x0
  80206a:	6a 00                	push   $0x0
  80206c:	6a 00                	push   $0x0
  80206e:	6a 04                	push   $0x4
  802070:	e8 07 fc ff ff       	call   801c7c <syscall>
  802075:	83 c4 18             	add    $0x18,%esp
}
  802078:	c9                   	leave  
  802079:	c3                   	ret    

0080207a <sys_exit_env>:


void sys_exit_env(void)
{
  80207a:	55                   	push   %ebp
  80207b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80207d:	6a 00                	push   $0x0
  80207f:	6a 00                	push   $0x0
  802081:	6a 00                	push   $0x0
  802083:	6a 00                	push   $0x0
  802085:	6a 00                	push   $0x0
  802087:	6a 23                	push   $0x23
  802089:	e8 ee fb ff ff       	call   801c7c <syscall>
  80208e:	83 c4 18             	add    $0x18,%esp
}
  802091:	90                   	nop
  802092:	c9                   	leave  
  802093:	c3                   	ret    

00802094 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802094:	55                   	push   %ebp
  802095:	89 e5                	mov    %esp,%ebp
  802097:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80209a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80209d:	8d 50 04             	lea    0x4(%eax),%edx
  8020a0:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8020a3:	6a 00                	push   $0x0
  8020a5:	6a 00                	push   $0x0
  8020a7:	6a 00                	push   $0x0
  8020a9:	52                   	push   %edx
  8020aa:	50                   	push   %eax
  8020ab:	6a 24                	push   $0x24
  8020ad:	e8 ca fb ff ff       	call   801c7c <syscall>
  8020b2:	83 c4 18             	add    $0x18,%esp
	return result;
  8020b5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8020b8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8020bb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8020be:	89 01                	mov    %eax,(%ecx)
  8020c0:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8020c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c6:	c9                   	leave  
  8020c7:	c2 04 00             	ret    $0x4

008020ca <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8020ca:	55                   	push   %ebp
  8020cb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8020cd:	6a 00                	push   $0x0
  8020cf:	6a 00                	push   $0x0
  8020d1:	ff 75 10             	pushl  0x10(%ebp)
  8020d4:	ff 75 0c             	pushl  0xc(%ebp)
  8020d7:	ff 75 08             	pushl  0x8(%ebp)
  8020da:	6a 12                	push   $0x12
  8020dc:	e8 9b fb ff ff       	call   801c7c <syscall>
  8020e1:	83 c4 18             	add    $0x18,%esp
	return ;
  8020e4:	90                   	nop
}
  8020e5:	c9                   	leave  
  8020e6:	c3                   	ret    

008020e7 <sys_rcr2>:
uint32 sys_rcr2()
{
  8020e7:	55                   	push   %ebp
  8020e8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8020ea:	6a 00                	push   $0x0
  8020ec:	6a 00                	push   $0x0
  8020ee:	6a 00                	push   $0x0
  8020f0:	6a 00                	push   $0x0
  8020f2:	6a 00                	push   $0x0
  8020f4:	6a 25                	push   $0x25
  8020f6:	e8 81 fb ff ff       	call   801c7c <syscall>
  8020fb:	83 c4 18             	add    $0x18,%esp
}
  8020fe:	c9                   	leave  
  8020ff:	c3                   	ret    

00802100 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802100:	55                   	push   %ebp
  802101:	89 e5                	mov    %esp,%ebp
  802103:	83 ec 04             	sub    $0x4,%esp
  802106:	8b 45 08             	mov    0x8(%ebp),%eax
  802109:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80210c:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802110:	6a 00                	push   $0x0
  802112:	6a 00                	push   $0x0
  802114:	6a 00                	push   $0x0
  802116:	6a 00                	push   $0x0
  802118:	50                   	push   %eax
  802119:	6a 26                	push   $0x26
  80211b:	e8 5c fb ff ff       	call   801c7c <syscall>
  802120:	83 c4 18             	add    $0x18,%esp
	return ;
  802123:	90                   	nop
}
  802124:	c9                   	leave  
  802125:	c3                   	ret    

00802126 <rsttst>:
void rsttst()
{
  802126:	55                   	push   %ebp
  802127:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802129:	6a 00                	push   $0x0
  80212b:	6a 00                	push   $0x0
  80212d:	6a 00                	push   $0x0
  80212f:	6a 00                	push   $0x0
  802131:	6a 00                	push   $0x0
  802133:	6a 28                	push   $0x28
  802135:	e8 42 fb ff ff       	call   801c7c <syscall>
  80213a:	83 c4 18             	add    $0x18,%esp
	return ;
  80213d:	90                   	nop
}
  80213e:	c9                   	leave  
  80213f:	c3                   	ret    

00802140 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802140:	55                   	push   %ebp
  802141:	89 e5                	mov    %esp,%ebp
  802143:	83 ec 04             	sub    $0x4,%esp
  802146:	8b 45 14             	mov    0x14(%ebp),%eax
  802149:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80214c:	8b 55 18             	mov    0x18(%ebp),%edx
  80214f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802153:	52                   	push   %edx
  802154:	50                   	push   %eax
  802155:	ff 75 10             	pushl  0x10(%ebp)
  802158:	ff 75 0c             	pushl  0xc(%ebp)
  80215b:	ff 75 08             	pushl  0x8(%ebp)
  80215e:	6a 27                	push   $0x27
  802160:	e8 17 fb ff ff       	call   801c7c <syscall>
  802165:	83 c4 18             	add    $0x18,%esp
	return ;
  802168:	90                   	nop
}
  802169:	c9                   	leave  
  80216a:	c3                   	ret    

0080216b <chktst>:
void chktst(uint32 n)
{
  80216b:	55                   	push   %ebp
  80216c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80216e:	6a 00                	push   $0x0
  802170:	6a 00                	push   $0x0
  802172:	6a 00                	push   $0x0
  802174:	6a 00                	push   $0x0
  802176:	ff 75 08             	pushl  0x8(%ebp)
  802179:	6a 29                	push   $0x29
  80217b:	e8 fc fa ff ff       	call   801c7c <syscall>
  802180:	83 c4 18             	add    $0x18,%esp
	return ;
  802183:	90                   	nop
}
  802184:	c9                   	leave  
  802185:	c3                   	ret    

00802186 <inctst>:

void inctst()
{
  802186:	55                   	push   %ebp
  802187:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802189:	6a 00                	push   $0x0
  80218b:	6a 00                	push   $0x0
  80218d:	6a 00                	push   $0x0
  80218f:	6a 00                	push   $0x0
  802191:	6a 00                	push   $0x0
  802193:	6a 2a                	push   $0x2a
  802195:	e8 e2 fa ff ff       	call   801c7c <syscall>
  80219a:	83 c4 18             	add    $0x18,%esp
	return ;
  80219d:	90                   	nop
}
  80219e:	c9                   	leave  
  80219f:	c3                   	ret    

008021a0 <gettst>:
uint32 gettst()
{
  8021a0:	55                   	push   %ebp
  8021a1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8021a3:	6a 00                	push   $0x0
  8021a5:	6a 00                	push   $0x0
  8021a7:	6a 00                	push   $0x0
  8021a9:	6a 00                	push   $0x0
  8021ab:	6a 00                	push   $0x0
  8021ad:	6a 2b                	push   $0x2b
  8021af:	e8 c8 fa ff ff       	call   801c7c <syscall>
  8021b4:	83 c4 18             	add    $0x18,%esp
}
  8021b7:	c9                   	leave  
  8021b8:	c3                   	ret    

008021b9 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8021b9:	55                   	push   %ebp
  8021ba:	89 e5                	mov    %esp,%ebp
  8021bc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021bf:	6a 00                	push   $0x0
  8021c1:	6a 00                	push   $0x0
  8021c3:	6a 00                	push   $0x0
  8021c5:	6a 00                	push   $0x0
  8021c7:	6a 00                	push   $0x0
  8021c9:	6a 2c                	push   $0x2c
  8021cb:	e8 ac fa ff ff       	call   801c7c <syscall>
  8021d0:	83 c4 18             	add    $0x18,%esp
  8021d3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8021d6:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8021da:	75 07                	jne    8021e3 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8021dc:	b8 01 00 00 00       	mov    $0x1,%eax
  8021e1:	eb 05                	jmp    8021e8 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8021e3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021e8:	c9                   	leave  
  8021e9:	c3                   	ret    

008021ea <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8021ea:	55                   	push   %ebp
  8021eb:	89 e5                	mov    %esp,%ebp
  8021ed:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021f0:	6a 00                	push   $0x0
  8021f2:	6a 00                	push   $0x0
  8021f4:	6a 00                	push   $0x0
  8021f6:	6a 00                	push   $0x0
  8021f8:	6a 00                	push   $0x0
  8021fa:	6a 2c                	push   $0x2c
  8021fc:	e8 7b fa ff ff       	call   801c7c <syscall>
  802201:	83 c4 18             	add    $0x18,%esp
  802204:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802207:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80220b:	75 07                	jne    802214 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80220d:	b8 01 00 00 00       	mov    $0x1,%eax
  802212:	eb 05                	jmp    802219 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802214:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802219:	c9                   	leave  
  80221a:	c3                   	ret    

0080221b <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80221b:	55                   	push   %ebp
  80221c:	89 e5                	mov    %esp,%ebp
  80221e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802221:	6a 00                	push   $0x0
  802223:	6a 00                	push   $0x0
  802225:	6a 00                	push   $0x0
  802227:	6a 00                	push   $0x0
  802229:	6a 00                	push   $0x0
  80222b:	6a 2c                	push   $0x2c
  80222d:	e8 4a fa ff ff       	call   801c7c <syscall>
  802232:	83 c4 18             	add    $0x18,%esp
  802235:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802238:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80223c:	75 07                	jne    802245 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80223e:	b8 01 00 00 00       	mov    $0x1,%eax
  802243:	eb 05                	jmp    80224a <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802245:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80224a:	c9                   	leave  
  80224b:	c3                   	ret    

0080224c <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80224c:	55                   	push   %ebp
  80224d:	89 e5                	mov    %esp,%ebp
  80224f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802252:	6a 00                	push   $0x0
  802254:	6a 00                	push   $0x0
  802256:	6a 00                	push   $0x0
  802258:	6a 00                	push   $0x0
  80225a:	6a 00                	push   $0x0
  80225c:	6a 2c                	push   $0x2c
  80225e:	e8 19 fa ff ff       	call   801c7c <syscall>
  802263:	83 c4 18             	add    $0x18,%esp
  802266:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802269:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80226d:	75 07                	jne    802276 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80226f:	b8 01 00 00 00       	mov    $0x1,%eax
  802274:	eb 05                	jmp    80227b <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802276:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80227b:	c9                   	leave  
  80227c:	c3                   	ret    

0080227d <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80227d:	55                   	push   %ebp
  80227e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802280:	6a 00                	push   $0x0
  802282:	6a 00                	push   $0x0
  802284:	6a 00                	push   $0x0
  802286:	6a 00                	push   $0x0
  802288:	ff 75 08             	pushl  0x8(%ebp)
  80228b:	6a 2d                	push   $0x2d
  80228d:	e8 ea f9 ff ff       	call   801c7c <syscall>
  802292:	83 c4 18             	add    $0x18,%esp
	return ;
  802295:	90                   	nop
}
  802296:	c9                   	leave  
  802297:	c3                   	ret    

00802298 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802298:	55                   	push   %ebp
  802299:	89 e5                	mov    %esp,%ebp
  80229b:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80229c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80229f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8022a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a8:	6a 00                	push   $0x0
  8022aa:	53                   	push   %ebx
  8022ab:	51                   	push   %ecx
  8022ac:	52                   	push   %edx
  8022ad:	50                   	push   %eax
  8022ae:	6a 2e                	push   $0x2e
  8022b0:	e8 c7 f9 ff ff       	call   801c7c <syscall>
  8022b5:	83 c4 18             	add    $0x18,%esp
}
  8022b8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022bb:	c9                   	leave  
  8022bc:	c3                   	ret    

008022bd <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8022bd:	55                   	push   %ebp
  8022be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8022c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c6:	6a 00                	push   $0x0
  8022c8:	6a 00                	push   $0x0
  8022ca:	6a 00                	push   $0x0
  8022cc:	52                   	push   %edx
  8022cd:	50                   	push   %eax
  8022ce:	6a 2f                	push   $0x2f
  8022d0:	e8 a7 f9 ff ff       	call   801c7c <syscall>
  8022d5:	83 c4 18             	add    $0x18,%esp
}
  8022d8:	c9                   	leave  
  8022d9:	c3                   	ret    

008022da <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8022da:	55                   	push   %ebp
  8022db:	89 e5                	mov    %esp,%ebp
  8022dd:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8022e0:	83 ec 0c             	sub    $0xc,%esp
  8022e3:	68 78 44 80 00       	push   $0x804478
  8022e8:	e8 d3 e8 ff ff       	call   800bc0 <cprintf>
  8022ed:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8022f0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8022f7:	83 ec 0c             	sub    $0xc,%esp
  8022fa:	68 a4 44 80 00       	push   $0x8044a4
  8022ff:	e8 bc e8 ff ff       	call   800bc0 <cprintf>
  802304:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802307:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80230b:	a1 38 51 80 00       	mov    0x805138,%eax
  802310:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802313:	eb 56                	jmp    80236b <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802315:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802319:	74 1c                	je     802337 <print_mem_block_lists+0x5d>
  80231b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231e:	8b 50 08             	mov    0x8(%eax),%edx
  802321:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802324:	8b 48 08             	mov    0x8(%eax),%ecx
  802327:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80232a:	8b 40 0c             	mov    0xc(%eax),%eax
  80232d:	01 c8                	add    %ecx,%eax
  80232f:	39 c2                	cmp    %eax,%edx
  802331:	73 04                	jae    802337 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802333:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802337:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233a:	8b 50 08             	mov    0x8(%eax),%edx
  80233d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802340:	8b 40 0c             	mov    0xc(%eax),%eax
  802343:	01 c2                	add    %eax,%edx
  802345:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802348:	8b 40 08             	mov    0x8(%eax),%eax
  80234b:	83 ec 04             	sub    $0x4,%esp
  80234e:	52                   	push   %edx
  80234f:	50                   	push   %eax
  802350:	68 b9 44 80 00       	push   $0x8044b9
  802355:	e8 66 e8 ff ff       	call   800bc0 <cprintf>
  80235a:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80235d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802360:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802363:	a1 40 51 80 00       	mov    0x805140,%eax
  802368:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80236b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80236f:	74 07                	je     802378 <print_mem_block_lists+0x9e>
  802371:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802374:	8b 00                	mov    (%eax),%eax
  802376:	eb 05                	jmp    80237d <print_mem_block_lists+0xa3>
  802378:	b8 00 00 00 00       	mov    $0x0,%eax
  80237d:	a3 40 51 80 00       	mov    %eax,0x805140
  802382:	a1 40 51 80 00       	mov    0x805140,%eax
  802387:	85 c0                	test   %eax,%eax
  802389:	75 8a                	jne    802315 <print_mem_block_lists+0x3b>
  80238b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80238f:	75 84                	jne    802315 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802391:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802395:	75 10                	jne    8023a7 <print_mem_block_lists+0xcd>
  802397:	83 ec 0c             	sub    $0xc,%esp
  80239a:	68 c8 44 80 00       	push   $0x8044c8
  80239f:	e8 1c e8 ff ff       	call   800bc0 <cprintf>
  8023a4:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8023a7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8023ae:	83 ec 0c             	sub    $0xc,%esp
  8023b1:	68 ec 44 80 00       	push   $0x8044ec
  8023b6:	e8 05 e8 ff ff       	call   800bc0 <cprintf>
  8023bb:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8023be:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8023c2:	a1 40 50 80 00       	mov    0x805040,%eax
  8023c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023ca:	eb 56                	jmp    802422 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8023cc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023d0:	74 1c                	je     8023ee <print_mem_block_lists+0x114>
  8023d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d5:	8b 50 08             	mov    0x8(%eax),%edx
  8023d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023db:	8b 48 08             	mov    0x8(%eax),%ecx
  8023de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023e1:	8b 40 0c             	mov    0xc(%eax),%eax
  8023e4:	01 c8                	add    %ecx,%eax
  8023e6:	39 c2                	cmp    %eax,%edx
  8023e8:	73 04                	jae    8023ee <print_mem_block_lists+0x114>
			sorted = 0 ;
  8023ea:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8023ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f1:	8b 50 08             	mov    0x8(%eax),%edx
  8023f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f7:	8b 40 0c             	mov    0xc(%eax),%eax
  8023fa:	01 c2                	add    %eax,%edx
  8023fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ff:	8b 40 08             	mov    0x8(%eax),%eax
  802402:	83 ec 04             	sub    $0x4,%esp
  802405:	52                   	push   %edx
  802406:	50                   	push   %eax
  802407:	68 b9 44 80 00       	push   $0x8044b9
  80240c:	e8 af e7 ff ff       	call   800bc0 <cprintf>
  802411:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802414:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802417:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80241a:	a1 48 50 80 00       	mov    0x805048,%eax
  80241f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802422:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802426:	74 07                	je     80242f <print_mem_block_lists+0x155>
  802428:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242b:	8b 00                	mov    (%eax),%eax
  80242d:	eb 05                	jmp    802434 <print_mem_block_lists+0x15a>
  80242f:	b8 00 00 00 00       	mov    $0x0,%eax
  802434:	a3 48 50 80 00       	mov    %eax,0x805048
  802439:	a1 48 50 80 00       	mov    0x805048,%eax
  80243e:	85 c0                	test   %eax,%eax
  802440:	75 8a                	jne    8023cc <print_mem_block_lists+0xf2>
  802442:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802446:	75 84                	jne    8023cc <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802448:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80244c:	75 10                	jne    80245e <print_mem_block_lists+0x184>
  80244e:	83 ec 0c             	sub    $0xc,%esp
  802451:	68 04 45 80 00       	push   $0x804504
  802456:	e8 65 e7 ff ff       	call   800bc0 <cprintf>
  80245b:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80245e:	83 ec 0c             	sub    $0xc,%esp
  802461:	68 78 44 80 00       	push   $0x804478
  802466:	e8 55 e7 ff ff       	call   800bc0 <cprintf>
  80246b:	83 c4 10             	add    $0x10,%esp

}
  80246e:	90                   	nop
  80246f:	c9                   	leave  
  802470:	c3                   	ret    

00802471 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802471:	55                   	push   %ebp
  802472:	89 e5                	mov    %esp,%ebp
  802474:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  802477:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  80247e:	00 00 00 
  802481:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802488:	00 00 00 
  80248b:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802492:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  802495:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80249c:	e9 9e 00 00 00       	jmp    80253f <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  8024a1:	a1 50 50 80 00       	mov    0x805050,%eax
  8024a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024a9:	c1 e2 04             	shl    $0x4,%edx
  8024ac:	01 d0                	add    %edx,%eax
  8024ae:	85 c0                	test   %eax,%eax
  8024b0:	75 14                	jne    8024c6 <initialize_MemBlocksList+0x55>
  8024b2:	83 ec 04             	sub    $0x4,%esp
  8024b5:	68 2c 45 80 00       	push   $0x80452c
  8024ba:	6a 46                	push   $0x46
  8024bc:	68 4f 45 80 00       	push   $0x80454f
  8024c1:	e8 46 e4 ff ff       	call   80090c <_panic>
  8024c6:	a1 50 50 80 00       	mov    0x805050,%eax
  8024cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024ce:	c1 e2 04             	shl    $0x4,%edx
  8024d1:	01 d0                	add    %edx,%eax
  8024d3:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8024d9:	89 10                	mov    %edx,(%eax)
  8024db:	8b 00                	mov    (%eax),%eax
  8024dd:	85 c0                	test   %eax,%eax
  8024df:	74 18                	je     8024f9 <initialize_MemBlocksList+0x88>
  8024e1:	a1 48 51 80 00       	mov    0x805148,%eax
  8024e6:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8024ec:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8024ef:	c1 e1 04             	shl    $0x4,%ecx
  8024f2:	01 ca                	add    %ecx,%edx
  8024f4:	89 50 04             	mov    %edx,0x4(%eax)
  8024f7:	eb 12                	jmp    80250b <initialize_MemBlocksList+0x9a>
  8024f9:	a1 50 50 80 00       	mov    0x805050,%eax
  8024fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802501:	c1 e2 04             	shl    $0x4,%edx
  802504:	01 d0                	add    %edx,%eax
  802506:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80250b:	a1 50 50 80 00       	mov    0x805050,%eax
  802510:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802513:	c1 e2 04             	shl    $0x4,%edx
  802516:	01 d0                	add    %edx,%eax
  802518:	a3 48 51 80 00       	mov    %eax,0x805148
  80251d:	a1 50 50 80 00       	mov    0x805050,%eax
  802522:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802525:	c1 e2 04             	shl    $0x4,%edx
  802528:	01 d0                	add    %edx,%eax
  80252a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802531:	a1 54 51 80 00       	mov    0x805154,%eax
  802536:	40                   	inc    %eax
  802537:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  80253c:	ff 45 f4             	incl   -0xc(%ebp)
  80253f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802542:	3b 45 08             	cmp    0x8(%ebp),%eax
  802545:	0f 82 56 ff ff ff    	jb     8024a1 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  80254b:	90                   	nop
  80254c:	c9                   	leave  
  80254d:	c3                   	ret    

0080254e <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80254e:	55                   	push   %ebp
  80254f:	89 e5                	mov    %esp,%ebp
  802551:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802554:	8b 45 08             	mov    0x8(%ebp),%eax
  802557:	8b 00                	mov    (%eax),%eax
  802559:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80255c:	eb 19                	jmp    802577 <find_block+0x29>
	{
		if(va==point->sva)
  80255e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802561:	8b 40 08             	mov    0x8(%eax),%eax
  802564:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802567:	75 05                	jne    80256e <find_block+0x20>
		   return point;
  802569:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80256c:	eb 36                	jmp    8025a4 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80256e:	8b 45 08             	mov    0x8(%ebp),%eax
  802571:	8b 40 08             	mov    0x8(%eax),%eax
  802574:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802577:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80257b:	74 07                	je     802584 <find_block+0x36>
  80257d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802580:	8b 00                	mov    (%eax),%eax
  802582:	eb 05                	jmp    802589 <find_block+0x3b>
  802584:	b8 00 00 00 00       	mov    $0x0,%eax
  802589:	8b 55 08             	mov    0x8(%ebp),%edx
  80258c:	89 42 08             	mov    %eax,0x8(%edx)
  80258f:	8b 45 08             	mov    0x8(%ebp),%eax
  802592:	8b 40 08             	mov    0x8(%eax),%eax
  802595:	85 c0                	test   %eax,%eax
  802597:	75 c5                	jne    80255e <find_block+0x10>
  802599:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80259d:	75 bf                	jne    80255e <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  80259f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025a4:	c9                   	leave  
  8025a5:	c3                   	ret    

008025a6 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8025a6:	55                   	push   %ebp
  8025a7:	89 e5                	mov    %esp,%ebp
  8025a9:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  8025ac:	a1 40 50 80 00       	mov    0x805040,%eax
  8025b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  8025b4:	a1 44 50 80 00       	mov    0x805044,%eax
  8025b9:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8025bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025bf:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8025c2:	74 24                	je     8025e8 <insert_sorted_allocList+0x42>
  8025c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c7:	8b 50 08             	mov    0x8(%eax),%edx
  8025ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025cd:	8b 40 08             	mov    0x8(%eax),%eax
  8025d0:	39 c2                	cmp    %eax,%edx
  8025d2:	76 14                	jbe    8025e8 <insert_sorted_allocList+0x42>
  8025d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d7:	8b 50 08             	mov    0x8(%eax),%edx
  8025da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025dd:	8b 40 08             	mov    0x8(%eax),%eax
  8025e0:	39 c2                	cmp    %eax,%edx
  8025e2:	0f 82 60 01 00 00    	jb     802748 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8025e8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025ec:	75 65                	jne    802653 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8025ee:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8025f2:	75 14                	jne    802608 <insert_sorted_allocList+0x62>
  8025f4:	83 ec 04             	sub    $0x4,%esp
  8025f7:	68 2c 45 80 00       	push   $0x80452c
  8025fc:	6a 6b                	push   $0x6b
  8025fe:	68 4f 45 80 00       	push   $0x80454f
  802603:	e8 04 e3 ff ff       	call   80090c <_panic>
  802608:	8b 15 40 50 80 00    	mov    0x805040,%edx
  80260e:	8b 45 08             	mov    0x8(%ebp),%eax
  802611:	89 10                	mov    %edx,(%eax)
  802613:	8b 45 08             	mov    0x8(%ebp),%eax
  802616:	8b 00                	mov    (%eax),%eax
  802618:	85 c0                	test   %eax,%eax
  80261a:	74 0d                	je     802629 <insert_sorted_allocList+0x83>
  80261c:	a1 40 50 80 00       	mov    0x805040,%eax
  802621:	8b 55 08             	mov    0x8(%ebp),%edx
  802624:	89 50 04             	mov    %edx,0x4(%eax)
  802627:	eb 08                	jmp    802631 <insert_sorted_allocList+0x8b>
  802629:	8b 45 08             	mov    0x8(%ebp),%eax
  80262c:	a3 44 50 80 00       	mov    %eax,0x805044
  802631:	8b 45 08             	mov    0x8(%ebp),%eax
  802634:	a3 40 50 80 00       	mov    %eax,0x805040
  802639:	8b 45 08             	mov    0x8(%ebp),%eax
  80263c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802643:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802648:	40                   	inc    %eax
  802649:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80264e:	e9 dc 01 00 00       	jmp    80282f <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802653:	8b 45 08             	mov    0x8(%ebp),%eax
  802656:	8b 50 08             	mov    0x8(%eax),%edx
  802659:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80265c:	8b 40 08             	mov    0x8(%eax),%eax
  80265f:	39 c2                	cmp    %eax,%edx
  802661:	77 6c                	ja     8026cf <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802663:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802667:	74 06                	je     80266f <insert_sorted_allocList+0xc9>
  802669:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80266d:	75 14                	jne    802683 <insert_sorted_allocList+0xdd>
  80266f:	83 ec 04             	sub    $0x4,%esp
  802672:	68 68 45 80 00       	push   $0x804568
  802677:	6a 6f                	push   $0x6f
  802679:	68 4f 45 80 00       	push   $0x80454f
  80267e:	e8 89 e2 ff ff       	call   80090c <_panic>
  802683:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802686:	8b 50 04             	mov    0x4(%eax),%edx
  802689:	8b 45 08             	mov    0x8(%ebp),%eax
  80268c:	89 50 04             	mov    %edx,0x4(%eax)
  80268f:	8b 45 08             	mov    0x8(%ebp),%eax
  802692:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802695:	89 10                	mov    %edx,(%eax)
  802697:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80269a:	8b 40 04             	mov    0x4(%eax),%eax
  80269d:	85 c0                	test   %eax,%eax
  80269f:	74 0d                	je     8026ae <insert_sorted_allocList+0x108>
  8026a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026a4:	8b 40 04             	mov    0x4(%eax),%eax
  8026a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8026aa:	89 10                	mov    %edx,(%eax)
  8026ac:	eb 08                	jmp    8026b6 <insert_sorted_allocList+0x110>
  8026ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b1:	a3 40 50 80 00       	mov    %eax,0x805040
  8026b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8026bc:	89 50 04             	mov    %edx,0x4(%eax)
  8026bf:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8026c4:	40                   	inc    %eax
  8026c5:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8026ca:	e9 60 01 00 00       	jmp    80282f <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8026cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d2:	8b 50 08             	mov    0x8(%eax),%edx
  8026d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026d8:	8b 40 08             	mov    0x8(%eax),%eax
  8026db:	39 c2                	cmp    %eax,%edx
  8026dd:	0f 82 4c 01 00 00    	jb     80282f <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8026e3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8026e7:	75 14                	jne    8026fd <insert_sorted_allocList+0x157>
  8026e9:	83 ec 04             	sub    $0x4,%esp
  8026ec:	68 a0 45 80 00       	push   $0x8045a0
  8026f1:	6a 73                	push   $0x73
  8026f3:	68 4f 45 80 00       	push   $0x80454f
  8026f8:	e8 0f e2 ff ff       	call   80090c <_panic>
  8026fd:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802703:	8b 45 08             	mov    0x8(%ebp),%eax
  802706:	89 50 04             	mov    %edx,0x4(%eax)
  802709:	8b 45 08             	mov    0x8(%ebp),%eax
  80270c:	8b 40 04             	mov    0x4(%eax),%eax
  80270f:	85 c0                	test   %eax,%eax
  802711:	74 0c                	je     80271f <insert_sorted_allocList+0x179>
  802713:	a1 44 50 80 00       	mov    0x805044,%eax
  802718:	8b 55 08             	mov    0x8(%ebp),%edx
  80271b:	89 10                	mov    %edx,(%eax)
  80271d:	eb 08                	jmp    802727 <insert_sorted_allocList+0x181>
  80271f:	8b 45 08             	mov    0x8(%ebp),%eax
  802722:	a3 40 50 80 00       	mov    %eax,0x805040
  802727:	8b 45 08             	mov    0x8(%ebp),%eax
  80272a:	a3 44 50 80 00       	mov    %eax,0x805044
  80272f:	8b 45 08             	mov    0x8(%ebp),%eax
  802732:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802738:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80273d:	40                   	inc    %eax
  80273e:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802743:	e9 e7 00 00 00       	jmp    80282f <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802748:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80274b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  80274e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802755:	a1 40 50 80 00       	mov    0x805040,%eax
  80275a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80275d:	e9 9d 00 00 00       	jmp    8027ff <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802762:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802765:	8b 00                	mov    (%eax),%eax
  802767:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  80276a:	8b 45 08             	mov    0x8(%ebp),%eax
  80276d:	8b 50 08             	mov    0x8(%eax),%edx
  802770:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802773:	8b 40 08             	mov    0x8(%eax),%eax
  802776:	39 c2                	cmp    %eax,%edx
  802778:	76 7d                	jbe    8027f7 <insert_sorted_allocList+0x251>
  80277a:	8b 45 08             	mov    0x8(%ebp),%eax
  80277d:	8b 50 08             	mov    0x8(%eax),%edx
  802780:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802783:	8b 40 08             	mov    0x8(%eax),%eax
  802786:	39 c2                	cmp    %eax,%edx
  802788:	73 6d                	jae    8027f7 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  80278a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80278e:	74 06                	je     802796 <insert_sorted_allocList+0x1f0>
  802790:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802794:	75 14                	jne    8027aa <insert_sorted_allocList+0x204>
  802796:	83 ec 04             	sub    $0x4,%esp
  802799:	68 c4 45 80 00       	push   $0x8045c4
  80279e:	6a 7f                	push   $0x7f
  8027a0:	68 4f 45 80 00       	push   $0x80454f
  8027a5:	e8 62 e1 ff ff       	call   80090c <_panic>
  8027aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ad:	8b 10                	mov    (%eax),%edx
  8027af:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b2:	89 10                	mov    %edx,(%eax)
  8027b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b7:	8b 00                	mov    (%eax),%eax
  8027b9:	85 c0                	test   %eax,%eax
  8027bb:	74 0b                	je     8027c8 <insert_sorted_allocList+0x222>
  8027bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c0:	8b 00                	mov    (%eax),%eax
  8027c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8027c5:	89 50 04             	mov    %edx,0x4(%eax)
  8027c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cb:	8b 55 08             	mov    0x8(%ebp),%edx
  8027ce:	89 10                	mov    %edx,(%eax)
  8027d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027d6:	89 50 04             	mov    %edx,0x4(%eax)
  8027d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8027dc:	8b 00                	mov    (%eax),%eax
  8027de:	85 c0                	test   %eax,%eax
  8027e0:	75 08                	jne    8027ea <insert_sorted_allocList+0x244>
  8027e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e5:	a3 44 50 80 00       	mov    %eax,0x805044
  8027ea:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8027ef:	40                   	inc    %eax
  8027f0:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8027f5:	eb 39                	jmp    802830 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8027f7:	a1 48 50 80 00       	mov    0x805048,%eax
  8027fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802803:	74 07                	je     80280c <insert_sorted_allocList+0x266>
  802805:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802808:	8b 00                	mov    (%eax),%eax
  80280a:	eb 05                	jmp    802811 <insert_sorted_allocList+0x26b>
  80280c:	b8 00 00 00 00       	mov    $0x0,%eax
  802811:	a3 48 50 80 00       	mov    %eax,0x805048
  802816:	a1 48 50 80 00       	mov    0x805048,%eax
  80281b:	85 c0                	test   %eax,%eax
  80281d:	0f 85 3f ff ff ff    	jne    802762 <insert_sorted_allocList+0x1bc>
  802823:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802827:	0f 85 35 ff ff ff    	jne    802762 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80282d:	eb 01                	jmp    802830 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80282f:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802830:	90                   	nop
  802831:	c9                   	leave  
  802832:	c3                   	ret    

00802833 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802833:	55                   	push   %ebp
  802834:	89 e5                	mov    %esp,%ebp
  802836:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802839:	a1 38 51 80 00       	mov    0x805138,%eax
  80283e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802841:	e9 85 01 00 00       	jmp    8029cb <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802846:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802849:	8b 40 0c             	mov    0xc(%eax),%eax
  80284c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80284f:	0f 82 6e 01 00 00    	jb     8029c3 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802855:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802858:	8b 40 0c             	mov    0xc(%eax),%eax
  80285b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80285e:	0f 85 8a 00 00 00    	jne    8028ee <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802864:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802868:	75 17                	jne    802881 <alloc_block_FF+0x4e>
  80286a:	83 ec 04             	sub    $0x4,%esp
  80286d:	68 f8 45 80 00       	push   $0x8045f8
  802872:	68 93 00 00 00       	push   $0x93
  802877:	68 4f 45 80 00       	push   $0x80454f
  80287c:	e8 8b e0 ff ff       	call   80090c <_panic>
  802881:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802884:	8b 00                	mov    (%eax),%eax
  802886:	85 c0                	test   %eax,%eax
  802888:	74 10                	je     80289a <alloc_block_FF+0x67>
  80288a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288d:	8b 00                	mov    (%eax),%eax
  80288f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802892:	8b 52 04             	mov    0x4(%edx),%edx
  802895:	89 50 04             	mov    %edx,0x4(%eax)
  802898:	eb 0b                	jmp    8028a5 <alloc_block_FF+0x72>
  80289a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289d:	8b 40 04             	mov    0x4(%eax),%eax
  8028a0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8028a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a8:	8b 40 04             	mov    0x4(%eax),%eax
  8028ab:	85 c0                	test   %eax,%eax
  8028ad:	74 0f                	je     8028be <alloc_block_FF+0x8b>
  8028af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b2:	8b 40 04             	mov    0x4(%eax),%eax
  8028b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028b8:	8b 12                	mov    (%edx),%edx
  8028ba:	89 10                	mov    %edx,(%eax)
  8028bc:	eb 0a                	jmp    8028c8 <alloc_block_FF+0x95>
  8028be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c1:	8b 00                	mov    (%eax),%eax
  8028c3:	a3 38 51 80 00       	mov    %eax,0x805138
  8028c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028db:	a1 44 51 80 00       	mov    0x805144,%eax
  8028e0:	48                   	dec    %eax
  8028e1:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  8028e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e9:	e9 10 01 00 00       	jmp    8029fe <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8028ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f1:	8b 40 0c             	mov    0xc(%eax),%eax
  8028f4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028f7:	0f 86 c6 00 00 00    	jbe    8029c3 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8028fd:	a1 48 51 80 00       	mov    0x805148,%eax
  802902:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802905:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802908:	8b 50 08             	mov    0x8(%eax),%edx
  80290b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80290e:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802911:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802914:	8b 55 08             	mov    0x8(%ebp),%edx
  802917:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80291a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80291e:	75 17                	jne    802937 <alloc_block_FF+0x104>
  802920:	83 ec 04             	sub    $0x4,%esp
  802923:	68 f8 45 80 00       	push   $0x8045f8
  802928:	68 9b 00 00 00       	push   $0x9b
  80292d:	68 4f 45 80 00       	push   $0x80454f
  802932:	e8 d5 df ff ff       	call   80090c <_panic>
  802937:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80293a:	8b 00                	mov    (%eax),%eax
  80293c:	85 c0                	test   %eax,%eax
  80293e:	74 10                	je     802950 <alloc_block_FF+0x11d>
  802940:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802943:	8b 00                	mov    (%eax),%eax
  802945:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802948:	8b 52 04             	mov    0x4(%edx),%edx
  80294b:	89 50 04             	mov    %edx,0x4(%eax)
  80294e:	eb 0b                	jmp    80295b <alloc_block_FF+0x128>
  802950:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802953:	8b 40 04             	mov    0x4(%eax),%eax
  802956:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80295b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80295e:	8b 40 04             	mov    0x4(%eax),%eax
  802961:	85 c0                	test   %eax,%eax
  802963:	74 0f                	je     802974 <alloc_block_FF+0x141>
  802965:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802968:	8b 40 04             	mov    0x4(%eax),%eax
  80296b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80296e:	8b 12                	mov    (%edx),%edx
  802970:	89 10                	mov    %edx,(%eax)
  802972:	eb 0a                	jmp    80297e <alloc_block_FF+0x14b>
  802974:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802977:	8b 00                	mov    (%eax),%eax
  802979:	a3 48 51 80 00       	mov    %eax,0x805148
  80297e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802981:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802987:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80298a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802991:	a1 54 51 80 00       	mov    0x805154,%eax
  802996:	48                   	dec    %eax
  802997:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  80299c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299f:	8b 50 08             	mov    0x8(%eax),%edx
  8029a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a5:	01 c2                	add    %eax,%edx
  8029a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029aa:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8029ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b0:	8b 40 0c             	mov    0xc(%eax),%eax
  8029b3:	2b 45 08             	sub    0x8(%ebp),%eax
  8029b6:	89 c2                	mov    %eax,%edx
  8029b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bb:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8029be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029c1:	eb 3b                	jmp    8029fe <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8029c3:	a1 40 51 80 00       	mov    0x805140,%eax
  8029c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029cb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029cf:	74 07                	je     8029d8 <alloc_block_FF+0x1a5>
  8029d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d4:	8b 00                	mov    (%eax),%eax
  8029d6:	eb 05                	jmp    8029dd <alloc_block_FF+0x1aa>
  8029d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8029dd:	a3 40 51 80 00       	mov    %eax,0x805140
  8029e2:	a1 40 51 80 00       	mov    0x805140,%eax
  8029e7:	85 c0                	test   %eax,%eax
  8029e9:	0f 85 57 fe ff ff    	jne    802846 <alloc_block_FF+0x13>
  8029ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029f3:	0f 85 4d fe ff ff    	jne    802846 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8029f9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029fe:	c9                   	leave  
  8029ff:	c3                   	ret    

00802a00 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802a00:	55                   	push   %ebp
  802a01:	89 e5                	mov    %esp,%ebp
  802a03:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802a06:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802a0d:	a1 38 51 80 00       	mov    0x805138,%eax
  802a12:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a15:	e9 df 00 00 00       	jmp    802af9 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802a1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1d:	8b 40 0c             	mov    0xc(%eax),%eax
  802a20:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a23:	0f 82 c8 00 00 00    	jb     802af1 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802a29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2c:	8b 40 0c             	mov    0xc(%eax),%eax
  802a2f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a32:	0f 85 8a 00 00 00    	jne    802ac2 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802a38:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a3c:	75 17                	jne    802a55 <alloc_block_BF+0x55>
  802a3e:	83 ec 04             	sub    $0x4,%esp
  802a41:	68 f8 45 80 00       	push   $0x8045f8
  802a46:	68 b7 00 00 00       	push   $0xb7
  802a4b:	68 4f 45 80 00       	push   $0x80454f
  802a50:	e8 b7 de ff ff       	call   80090c <_panic>
  802a55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a58:	8b 00                	mov    (%eax),%eax
  802a5a:	85 c0                	test   %eax,%eax
  802a5c:	74 10                	je     802a6e <alloc_block_BF+0x6e>
  802a5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a61:	8b 00                	mov    (%eax),%eax
  802a63:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a66:	8b 52 04             	mov    0x4(%edx),%edx
  802a69:	89 50 04             	mov    %edx,0x4(%eax)
  802a6c:	eb 0b                	jmp    802a79 <alloc_block_BF+0x79>
  802a6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a71:	8b 40 04             	mov    0x4(%eax),%eax
  802a74:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7c:	8b 40 04             	mov    0x4(%eax),%eax
  802a7f:	85 c0                	test   %eax,%eax
  802a81:	74 0f                	je     802a92 <alloc_block_BF+0x92>
  802a83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a86:	8b 40 04             	mov    0x4(%eax),%eax
  802a89:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a8c:	8b 12                	mov    (%edx),%edx
  802a8e:	89 10                	mov    %edx,(%eax)
  802a90:	eb 0a                	jmp    802a9c <alloc_block_BF+0x9c>
  802a92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a95:	8b 00                	mov    (%eax),%eax
  802a97:	a3 38 51 80 00       	mov    %eax,0x805138
  802a9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802aa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802aaf:	a1 44 51 80 00       	mov    0x805144,%eax
  802ab4:	48                   	dec    %eax
  802ab5:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802aba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802abd:	e9 4d 01 00 00       	jmp    802c0f <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802ac2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac5:	8b 40 0c             	mov    0xc(%eax),%eax
  802ac8:	3b 45 08             	cmp    0x8(%ebp),%eax
  802acb:	76 24                	jbe    802af1 <alloc_block_BF+0xf1>
  802acd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad0:	8b 40 0c             	mov    0xc(%eax),%eax
  802ad3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802ad6:	73 19                	jae    802af1 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802ad8:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802adf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae2:	8b 40 0c             	mov    0xc(%eax),%eax
  802ae5:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802ae8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aeb:	8b 40 08             	mov    0x8(%eax),%eax
  802aee:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802af1:	a1 40 51 80 00       	mov    0x805140,%eax
  802af6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802af9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802afd:	74 07                	je     802b06 <alloc_block_BF+0x106>
  802aff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b02:	8b 00                	mov    (%eax),%eax
  802b04:	eb 05                	jmp    802b0b <alloc_block_BF+0x10b>
  802b06:	b8 00 00 00 00       	mov    $0x0,%eax
  802b0b:	a3 40 51 80 00       	mov    %eax,0x805140
  802b10:	a1 40 51 80 00       	mov    0x805140,%eax
  802b15:	85 c0                	test   %eax,%eax
  802b17:	0f 85 fd fe ff ff    	jne    802a1a <alloc_block_BF+0x1a>
  802b1d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b21:	0f 85 f3 fe ff ff    	jne    802a1a <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802b27:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802b2b:	0f 84 d9 00 00 00    	je     802c0a <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b31:	a1 48 51 80 00       	mov    0x805148,%eax
  802b36:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802b39:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b3c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b3f:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802b42:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b45:	8b 55 08             	mov    0x8(%ebp),%edx
  802b48:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802b4b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802b4f:	75 17                	jne    802b68 <alloc_block_BF+0x168>
  802b51:	83 ec 04             	sub    $0x4,%esp
  802b54:	68 f8 45 80 00       	push   $0x8045f8
  802b59:	68 c7 00 00 00       	push   $0xc7
  802b5e:	68 4f 45 80 00       	push   $0x80454f
  802b63:	e8 a4 dd ff ff       	call   80090c <_panic>
  802b68:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b6b:	8b 00                	mov    (%eax),%eax
  802b6d:	85 c0                	test   %eax,%eax
  802b6f:	74 10                	je     802b81 <alloc_block_BF+0x181>
  802b71:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b74:	8b 00                	mov    (%eax),%eax
  802b76:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802b79:	8b 52 04             	mov    0x4(%edx),%edx
  802b7c:	89 50 04             	mov    %edx,0x4(%eax)
  802b7f:	eb 0b                	jmp    802b8c <alloc_block_BF+0x18c>
  802b81:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b84:	8b 40 04             	mov    0x4(%eax),%eax
  802b87:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b8c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b8f:	8b 40 04             	mov    0x4(%eax),%eax
  802b92:	85 c0                	test   %eax,%eax
  802b94:	74 0f                	je     802ba5 <alloc_block_BF+0x1a5>
  802b96:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b99:	8b 40 04             	mov    0x4(%eax),%eax
  802b9c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802b9f:	8b 12                	mov    (%edx),%edx
  802ba1:	89 10                	mov    %edx,(%eax)
  802ba3:	eb 0a                	jmp    802baf <alloc_block_BF+0x1af>
  802ba5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ba8:	8b 00                	mov    (%eax),%eax
  802baa:	a3 48 51 80 00       	mov    %eax,0x805148
  802baf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bb2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bb8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bbb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bc2:	a1 54 51 80 00       	mov    0x805154,%eax
  802bc7:	48                   	dec    %eax
  802bc8:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802bcd:	83 ec 08             	sub    $0x8,%esp
  802bd0:	ff 75 ec             	pushl  -0x14(%ebp)
  802bd3:	68 38 51 80 00       	push   $0x805138
  802bd8:	e8 71 f9 ff ff       	call   80254e <find_block>
  802bdd:	83 c4 10             	add    $0x10,%esp
  802be0:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802be3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802be6:	8b 50 08             	mov    0x8(%eax),%edx
  802be9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bec:	01 c2                	add    %eax,%edx
  802bee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bf1:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802bf4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bf7:	8b 40 0c             	mov    0xc(%eax),%eax
  802bfa:	2b 45 08             	sub    0x8(%ebp),%eax
  802bfd:	89 c2                	mov    %eax,%edx
  802bff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c02:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802c05:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c08:	eb 05                	jmp    802c0f <alloc_block_BF+0x20f>
	}
	return NULL;
  802c0a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c0f:	c9                   	leave  
  802c10:	c3                   	ret    

00802c11 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802c11:	55                   	push   %ebp
  802c12:	89 e5                	mov    %esp,%ebp
  802c14:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802c17:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802c1c:	85 c0                	test   %eax,%eax
  802c1e:	0f 85 de 01 00 00    	jne    802e02 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802c24:	a1 38 51 80 00       	mov    0x805138,%eax
  802c29:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c2c:	e9 9e 01 00 00       	jmp    802dcf <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802c31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c34:	8b 40 0c             	mov    0xc(%eax),%eax
  802c37:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c3a:	0f 82 87 01 00 00    	jb     802dc7 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802c40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c43:	8b 40 0c             	mov    0xc(%eax),%eax
  802c46:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c49:	0f 85 95 00 00 00    	jne    802ce4 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802c4f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c53:	75 17                	jne    802c6c <alloc_block_NF+0x5b>
  802c55:	83 ec 04             	sub    $0x4,%esp
  802c58:	68 f8 45 80 00       	push   $0x8045f8
  802c5d:	68 e0 00 00 00       	push   $0xe0
  802c62:	68 4f 45 80 00       	push   $0x80454f
  802c67:	e8 a0 dc ff ff       	call   80090c <_panic>
  802c6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6f:	8b 00                	mov    (%eax),%eax
  802c71:	85 c0                	test   %eax,%eax
  802c73:	74 10                	je     802c85 <alloc_block_NF+0x74>
  802c75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c78:	8b 00                	mov    (%eax),%eax
  802c7a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c7d:	8b 52 04             	mov    0x4(%edx),%edx
  802c80:	89 50 04             	mov    %edx,0x4(%eax)
  802c83:	eb 0b                	jmp    802c90 <alloc_block_NF+0x7f>
  802c85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c88:	8b 40 04             	mov    0x4(%eax),%eax
  802c8b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c93:	8b 40 04             	mov    0x4(%eax),%eax
  802c96:	85 c0                	test   %eax,%eax
  802c98:	74 0f                	je     802ca9 <alloc_block_NF+0x98>
  802c9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9d:	8b 40 04             	mov    0x4(%eax),%eax
  802ca0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ca3:	8b 12                	mov    (%edx),%edx
  802ca5:	89 10                	mov    %edx,(%eax)
  802ca7:	eb 0a                	jmp    802cb3 <alloc_block_NF+0xa2>
  802ca9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cac:	8b 00                	mov    (%eax),%eax
  802cae:	a3 38 51 80 00       	mov    %eax,0x805138
  802cb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cc6:	a1 44 51 80 00       	mov    0x805144,%eax
  802ccb:	48                   	dec    %eax
  802ccc:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802cd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd4:	8b 40 08             	mov    0x8(%eax),%eax
  802cd7:	a3 2c 50 80 00       	mov    %eax,0x80502c
				   return  point;
  802cdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cdf:	e9 f8 04 00 00       	jmp    8031dc <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802ce4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce7:	8b 40 0c             	mov    0xc(%eax),%eax
  802cea:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ced:	0f 86 d4 00 00 00    	jbe    802dc7 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802cf3:	a1 48 51 80 00       	mov    0x805148,%eax
  802cf8:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802cfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfe:	8b 50 08             	mov    0x8(%eax),%edx
  802d01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d04:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802d07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d0a:	8b 55 08             	mov    0x8(%ebp),%edx
  802d0d:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802d10:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d14:	75 17                	jne    802d2d <alloc_block_NF+0x11c>
  802d16:	83 ec 04             	sub    $0x4,%esp
  802d19:	68 f8 45 80 00       	push   $0x8045f8
  802d1e:	68 e9 00 00 00       	push   $0xe9
  802d23:	68 4f 45 80 00       	push   $0x80454f
  802d28:	e8 df db ff ff       	call   80090c <_panic>
  802d2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d30:	8b 00                	mov    (%eax),%eax
  802d32:	85 c0                	test   %eax,%eax
  802d34:	74 10                	je     802d46 <alloc_block_NF+0x135>
  802d36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d39:	8b 00                	mov    (%eax),%eax
  802d3b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d3e:	8b 52 04             	mov    0x4(%edx),%edx
  802d41:	89 50 04             	mov    %edx,0x4(%eax)
  802d44:	eb 0b                	jmp    802d51 <alloc_block_NF+0x140>
  802d46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d49:	8b 40 04             	mov    0x4(%eax),%eax
  802d4c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d54:	8b 40 04             	mov    0x4(%eax),%eax
  802d57:	85 c0                	test   %eax,%eax
  802d59:	74 0f                	je     802d6a <alloc_block_NF+0x159>
  802d5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d5e:	8b 40 04             	mov    0x4(%eax),%eax
  802d61:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d64:	8b 12                	mov    (%edx),%edx
  802d66:	89 10                	mov    %edx,(%eax)
  802d68:	eb 0a                	jmp    802d74 <alloc_block_NF+0x163>
  802d6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d6d:	8b 00                	mov    (%eax),%eax
  802d6f:	a3 48 51 80 00       	mov    %eax,0x805148
  802d74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d77:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d80:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d87:	a1 54 51 80 00       	mov    0x805154,%eax
  802d8c:	48                   	dec    %eax
  802d8d:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802d92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d95:	8b 40 08             	mov    0x8(%eax),%eax
  802d98:	a3 2c 50 80 00       	mov    %eax,0x80502c
				   point->sva += size;
  802d9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da0:	8b 50 08             	mov    0x8(%eax),%edx
  802da3:	8b 45 08             	mov    0x8(%ebp),%eax
  802da6:	01 c2                	add    %eax,%edx
  802da8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dab:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802dae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db1:	8b 40 0c             	mov    0xc(%eax),%eax
  802db4:	2b 45 08             	sub    0x8(%ebp),%eax
  802db7:	89 c2                	mov    %eax,%edx
  802db9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbc:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802dbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc2:	e9 15 04 00 00       	jmp    8031dc <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802dc7:	a1 40 51 80 00       	mov    0x805140,%eax
  802dcc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802dcf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dd3:	74 07                	je     802ddc <alloc_block_NF+0x1cb>
  802dd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd8:	8b 00                	mov    (%eax),%eax
  802dda:	eb 05                	jmp    802de1 <alloc_block_NF+0x1d0>
  802ddc:	b8 00 00 00 00       	mov    $0x0,%eax
  802de1:	a3 40 51 80 00       	mov    %eax,0x805140
  802de6:	a1 40 51 80 00       	mov    0x805140,%eax
  802deb:	85 c0                	test   %eax,%eax
  802ded:	0f 85 3e fe ff ff    	jne    802c31 <alloc_block_NF+0x20>
  802df3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802df7:	0f 85 34 fe ff ff    	jne    802c31 <alloc_block_NF+0x20>
  802dfd:	e9 d5 03 00 00       	jmp    8031d7 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802e02:	a1 38 51 80 00       	mov    0x805138,%eax
  802e07:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e0a:	e9 b1 01 00 00       	jmp    802fc0 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802e0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e12:	8b 50 08             	mov    0x8(%eax),%edx
  802e15:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802e1a:	39 c2                	cmp    %eax,%edx
  802e1c:	0f 82 96 01 00 00    	jb     802fb8 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802e22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e25:	8b 40 0c             	mov    0xc(%eax),%eax
  802e28:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e2b:	0f 82 87 01 00 00    	jb     802fb8 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802e31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e34:	8b 40 0c             	mov    0xc(%eax),%eax
  802e37:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e3a:	0f 85 95 00 00 00    	jne    802ed5 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802e40:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e44:	75 17                	jne    802e5d <alloc_block_NF+0x24c>
  802e46:	83 ec 04             	sub    $0x4,%esp
  802e49:	68 f8 45 80 00       	push   $0x8045f8
  802e4e:	68 fc 00 00 00       	push   $0xfc
  802e53:	68 4f 45 80 00       	push   $0x80454f
  802e58:	e8 af da ff ff       	call   80090c <_panic>
  802e5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e60:	8b 00                	mov    (%eax),%eax
  802e62:	85 c0                	test   %eax,%eax
  802e64:	74 10                	je     802e76 <alloc_block_NF+0x265>
  802e66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e69:	8b 00                	mov    (%eax),%eax
  802e6b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e6e:	8b 52 04             	mov    0x4(%edx),%edx
  802e71:	89 50 04             	mov    %edx,0x4(%eax)
  802e74:	eb 0b                	jmp    802e81 <alloc_block_NF+0x270>
  802e76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e79:	8b 40 04             	mov    0x4(%eax),%eax
  802e7c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e84:	8b 40 04             	mov    0x4(%eax),%eax
  802e87:	85 c0                	test   %eax,%eax
  802e89:	74 0f                	je     802e9a <alloc_block_NF+0x289>
  802e8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8e:	8b 40 04             	mov    0x4(%eax),%eax
  802e91:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e94:	8b 12                	mov    (%edx),%edx
  802e96:	89 10                	mov    %edx,(%eax)
  802e98:	eb 0a                	jmp    802ea4 <alloc_block_NF+0x293>
  802e9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9d:	8b 00                	mov    (%eax),%eax
  802e9f:	a3 38 51 80 00       	mov    %eax,0x805138
  802ea4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ead:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eb7:	a1 44 51 80 00       	mov    0x805144,%eax
  802ebc:	48                   	dec    %eax
  802ebd:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802ec2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec5:	8b 40 08             	mov    0x8(%eax),%eax
  802ec8:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   return  point;
  802ecd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed0:	e9 07 03 00 00       	jmp    8031dc <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802ed5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed8:	8b 40 0c             	mov    0xc(%eax),%eax
  802edb:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ede:	0f 86 d4 00 00 00    	jbe    802fb8 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802ee4:	a1 48 51 80 00       	mov    0x805148,%eax
  802ee9:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802eec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eef:	8b 50 08             	mov    0x8(%eax),%edx
  802ef2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ef5:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802ef8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802efb:	8b 55 08             	mov    0x8(%ebp),%edx
  802efe:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802f01:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f05:	75 17                	jne    802f1e <alloc_block_NF+0x30d>
  802f07:	83 ec 04             	sub    $0x4,%esp
  802f0a:	68 f8 45 80 00       	push   $0x8045f8
  802f0f:	68 04 01 00 00       	push   $0x104
  802f14:	68 4f 45 80 00       	push   $0x80454f
  802f19:	e8 ee d9 ff ff       	call   80090c <_panic>
  802f1e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f21:	8b 00                	mov    (%eax),%eax
  802f23:	85 c0                	test   %eax,%eax
  802f25:	74 10                	je     802f37 <alloc_block_NF+0x326>
  802f27:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f2a:	8b 00                	mov    (%eax),%eax
  802f2c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f2f:	8b 52 04             	mov    0x4(%edx),%edx
  802f32:	89 50 04             	mov    %edx,0x4(%eax)
  802f35:	eb 0b                	jmp    802f42 <alloc_block_NF+0x331>
  802f37:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f3a:	8b 40 04             	mov    0x4(%eax),%eax
  802f3d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f42:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f45:	8b 40 04             	mov    0x4(%eax),%eax
  802f48:	85 c0                	test   %eax,%eax
  802f4a:	74 0f                	je     802f5b <alloc_block_NF+0x34a>
  802f4c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f4f:	8b 40 04             	mov    0x4(%eax),%eax
  802f52:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f55:	8b 12                	mov    (%edx),%edx
  802f57:	89 10                	mov    %edx,(%eax)
  802f59:	eb 0a                	jmp    802f65 <alloc_block_NF+0x354>
  802f5b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f5e:	8b 00                	mov    (%eax),%eax
  802f60:	a3 48 51 80 00       	mov    %eax,0x805148
  802f65:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f68:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f6e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f71:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f78:	a1 54 51 80 00       	mov    0x805154,%eax
  802f7d:	48                   	dec    %eax
  802f7e:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802f83:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f86:	8b 40 08             	mov    0x8(%eax),%eax
  802f89:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   point->sva += size;
  802f8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f91:	8b 50 08             	mov    0x8(%eax),%edx
  802f94:	8b 45 08             	mov    0x8(%ebp),%eax
  802f97:	01 c2                	add    %eax,%edx
  802f99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f9c:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802f9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa2:	8b 40 0c             	mov    0xc(%eax),%eax
  802fa5:	2b 45 08             	sub    0x8(%ebp),%eax
  802fa8:	89 c2                	mov    %eax,%edx
  802faa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fad:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802fb0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fb3:	e9 24 02 00 00       	jmp    8031dc <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802fb8:	a1 40 51 80 00       	mov    0x805140,%eax
  802fbd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fc0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fc4:	74 07                	je     802fcd <alloc_block_NF+0x3bc>
  802fc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc9:	8b 00                	mov    (%eax),%eax
  802fcb:	eb 05                	jmp    802fd2 <alloc_block_NF+0x3c1>
  802fcd:	b8 00 00 00 00       	mov    $0x0,%eax
  802fd2:	a3 40 51 80 00       	mov    %eax,0x805140
  802fd7:	a1 40 51 80 00       	mov    0x805140,%eax
  802fdc:	85 c0                	test   %eax,%eax
  802fde:	0f 85 2b fe ff ff    	jne    802e0f <alloc_block_NF+0x1fe>
  802fe4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fe8:	0f 85 21 fe ff ff    	jne    802e0f <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802fee:	a1 38 51 80 00       	mov    0x805138,%eax
  802ff3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ff6:	e9 ae 01 00 00       	jmp    8031a9 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802ffb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ffe:	8b 50 08             	mov    0x8(%eax),%edx
  803001:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803006:	39 c2                	cmp    %eax,%edx
  803008:	0f 83 93 01 00 00    	jae    8031a1 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  80300e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803011:	8b 40 0c             	mov    0xc(%eax),%eax
  803014:	3b 45 08             	cmp    0x8(%ebp),%eax
  803017:	0f 82 84 01 00 00    	jb     8031a1 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  80301d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803020:	8b 40 0c             	mov    0xc(%eax),%eax
  803023:	3b 45 08             	cmp    0x8(%ebp),%eax
  803026:	0f 85 95 00 00 00    	jne    8030c1 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  80302c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803030:	75 17                	jne    803049 <alloc_block_NF+0x438>
  803032:	83 ec 04             	sub    $0x4,%esp
  803035:	68 f8 45 80 00       	push   $0x8045f8
  80303a:	68 14 01 00 00       	push   $0x114
  80303f:	68 4f 45 80 00       	push   $0x80454f
  803044:	e8 c3 d8 ff ff       	call   80090c <_panic>
  803049:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80304c:	8b 00                	mov    (%eax),%eax
  80304e:	85 c0                	test   %eax,%eax
  803050:	74 10                	je     803062 <alloc_block_NF+0x451>
  803052:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803055:	8b 00                	mov    (%eax),%eax
  803057:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80305a:	8b 52 04             	mov    0x4(%edx),%edx
  80305d:	89 50 04             	mov    %edx,0x4(%eax)
  803060:	eb 0b                	jmp    80306d <alloc_block_NF+0x45c>
  803062:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803065:	8b 40 04             	mov    0x4(%eax),%eax
  803068:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80306d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803070:	8b 40 04             	mov    0x4(%eax),%eax
  803073:	85 c0                	test   %eax,%eax
  803075:	74 0f                	je     803086 <alloc_block_NF+0x475>
  803077:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80307a:	8b 40 04             	mov    0x4(%eax),%eax
  80307d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803080:	8b 12                	mov    (%edx),%edx
  803082:	89 10                	mov    %edx,(%eax)
  803084:	eb 0a                	jmp    803090 <alloc_block_NF+0x47f>
  803086:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803089:	8b 00                	mov    (%eax),%eax
  80308b:	a3 38 51 80 00       	mov    %eax,0x805138
  803090:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803093:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803099:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80309c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030a3:	a1 44 51 80 00       	mov    0x805144,%eax
  8030a8:	48                   	dec    %eax
  8030a9:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8030ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b1:	8b 40 08             	mov    0x8(%eax),%eax
  8030b4:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   return  point;
  8030b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030bc:	e9 1b 01 00 00       	jmp    8031dc <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8030c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c4:	8b 40 0c             	mov    0xc(%eax),%eax
  8030c7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030ca:	0f 86 d1 00 00 00    	jbe    8031a1 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8030d0:	a1 48 51 80 00       	mov    0x805148,%eax
  8030d5:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  8030d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030db:	8b 50 08             	mov    0x8(%eax),%edx
  8030de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030e1:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8030e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8030ea:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8030ed:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8030f1:	75 17                	jne    80310a <alloc_block_NF+0x4f9>
  8030f3:	83 ec 04             	sub    $0x4,%esp
  8030f6:	68 f8 45 80 00       	push   $0x8045f8
  8030fb:	68 1c 01 00 00       	push   $0x11c
  803100:	68 4f 45 80 00       	push   $0x80454f
  803105:	e8 02 d8 ff ff       	call   80090c <_panic>
  80310a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80310d:	8b 00                	mov    (%eax),%eax
  80310f:	85 c0                	test   %eax,%eax
  803111:	74 10                	je     803123 <alloc_block_NF+0x512>
  803113:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803116:	8b 00                	mov    (%eax),%eax
  803118:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80311b:	8b 52 04             	mov    0x4(%edx),%edx
  80311e:	89 50 04             	mov    %edx,0x4(%eax)
  803121:	eb 0b                	jmp    80312e <alloc_block_NF+0x51d>
  803123:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803126:	8b 40 04             	mov    0x4(%eax),%eax
  803129:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80312e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803131:	8b 40 04             	mov    0x4(%eax),%eax
  803134:	85 c0                	test   %eax,%eax
  803136:	74 0f                	je     803147 <alloc_block_NF+0x536>
  803138:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80313b:	8b 40 04             	mov    0x4(%eax),%eax
  80313e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803141:	8b 12                	mov    (%edx),%edx
  803143:	89 10                	mov    %edx,(%eax)
  803145:	eb 0a                	jmp    803151 <alloc_block_NF+0x540>
  803147:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80314a:	8b 00                	mov    (%eax),%eax
  80314c:	a3 48 51 80 00       	mov    %eax,0x805148
  803151:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803154:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80315a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80315d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803164:	a1 54 51 80 00       	mov    0x805154,%eax
  803169:	48                   	dec    %eax
  80316a:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  80316f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803172:	8b 40 08             	mov    0x8(%eax),%eax
  803175:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   point->sva += size;
  80317a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80317d:	8b 50 08             	mov    0x8(%eax),%edx
  803180:	8b 45 08             	mov    0x8(%ebp),%eax
  803183:	01 c2                	add    %eax,%edx
  803185:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803188:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  80318b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80318e:	8b 40 0c             	mov    0xc(%eax),%eax
  803191:	2b 45 08             	sub    0x8(%ebp),%eax
  803194:	89 c2                	mov    %eax,%edx
  803196:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803199:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  80319c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80319f:	eb 3b                	jmp    8031dc <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8031a1:	a1 40 51 80 00       	mov    0x805140,%eax
  8031a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031ad:	74 07                	je     8031b6 <alloc_block_NF+0x5a5>
  8031af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b2:	8b 00                	mov    (%eax),%eax
  8031b4:	eb 05                	jmp    8031bb <alloc_block_NF+0x5aa>
  8031b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8031bb:	a3 40 51 80 00       	mov    %eax,0x805140
  8031c0:	a1 40 51 80 00       	mov    0x805140,%eax
  8031c5:	85 c0                	test   %eax,%eax
  8031c7:	0f 85 2e fe ff ff    	jne    802ffb <alloc_block_NF+0x3ea>
  8031cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031d1:	0f 85 24 fe ff ff    	jne    802ffb <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  8031d7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8031dc:	c9                   	leave  
  8031dd:	c3                   	ret    

008031de <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8031de:	55                   	push   %ebp
  8031df:	89 e5                	mov    %esp,%ebp
  8031e1:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  8031e4:	a1 38 51 80 00       	mov    0x805138,%eax
  8031e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  8031ec:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8031f1:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  8031f4:	a1 38 51 80 00       	mov    0x805138,%eax
  8031f9:	85 c0                	test   %eax,%eax
  8031fb:	74 14                	je     803211 <insert_sorted_with_merge_freeList+0x33>
  8031fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803200:	8b 50 08             	mov    0x8(%eax),%edx
  803203:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803206:	8b 40 08             	mov    0x8(%eax),%eax
  803209:	39 c2                	cmp    %eax,%edx
  80320b:	0f 87 9b 01 00 00    	ja     8033ac <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  803211:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803215:	75 17                	jne    80322e <insert_sorted_with_merge_freeList+0x50>
  803217:	83 ec 04             	sub    $0x4,%esp
  80321a:	68 2c 45 80 00       	push   $0x80452c
  80321f:	68 38 01 00 00       	push   $0x138
  803224:	68 4f 45 80 00       	push   $0x80454f
  803229:	e8 de d6 ff ff       	call   80090c <_panic>
  80322e:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803234:	8b 45 08             	mov    0x8(%ebp),%eax
  803237:	89 10                	mov    %edx,(%eax)
  803239:	8b 45 08             	mov    0x8(%ebp),%eax
  80323c:	8b 00                	mov    (%eax),%eax
  80323e:	85 c0                	test   %eax,%eax
  803240:	74 0d                	je     80324f <insert_sorted_with_merge_freeList+0x71>
  803242:	a1 38 51 80 00       	mov    0x805138,%eax
  803247:	8b 55 08             	mov    0x8(%ebp),%edx
  80324a:	89 50 04             	mov    %edx,0x4(%eax)
  80324d:	eb 08                	jmp    803257 <insert_sorted_with_merge_freeList+0x79>
  80324f:	8b 45 08             	mov    0x8(%ebp),%eax
  803252:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803257:	8b 45 08             	mov    0x8(%ebp),%eax
  80325a:	a3 38 51 80 00       	mov    %eax,0x805138
  80325f:	8b 45 08             	mov    0x8(%ebp),%eax
  803262:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803269:	a1 44 51 80 00       	mov    0x805144,%eax
  80326e:	40                   	inc    %eax
  80326f:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803274:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803278:	0f 84 a8 06 00 00    	je     803926 <insert_sorted_with_merge_freeList+0x748>
  80327e:	8b 45 08             	mov    0x8(%ebp),%eax
  803281:	8b 50 08             	mov    0x8(%eax),%edx
  803284:	8b 45 08             	mov    0x8(%ebp),%eax
  803287:	8b 40 0c             	mov    0xc(%eax),%eax
  80328a:	01 c2                	add    %eax,%edx
  80328c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80328f:	8b 40 08             	mov    0x8(%eax),%eax
  803292:	39 c2                	cmp    %eax,%edx
  803294:	0f 85 8c 06 00 00    	jne    803926 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  80329a:	8b 45 08             	mov    0x8(%ebp),%eax
  80329d:	8b 50 0c             	mov    0xc(%eax),%edx
  8032a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032a3:	8b 40 0c             	mov    0xc(%eax),%eax
  8032a6:	01 c2                	add    %eax,%edx
  8032a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ab:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  8032ae:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8032b2:	75 17                	jne    8032cb <insert_sorted_with_merge_freeList+0xed>
  8032b4:	83 ec 04             	sub    $0x4,%esp
  8032b7:	68 f8 45 80 00       	push   $0x8045f8
  8032bc:	68 3c 01 00 00       	push   $0x13c
  8032c1:	68 4f 45 80 00       	push   $0x80454f
  8032c6:	e8 41 d6 ff ff       	call   80090c <_panic>
  8032cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032ce:	8b 00                	mov    (%eax),%eax
  8032d0:	85 c0                	test   %eax,%eax
  8032d2:	74 10                	je     8032e4 <insert_sorted_with_merge_freeList+0x106>
  8032d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032d7:	8b 00                	mov    (%eax),%eax
  8032d9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032dc:	8b 52 04             	mov    0x4(%edx),%edx
  8032df:	89 50 04             	mov    %edx,0x4(%eax)
  8032e2:	eb 0b                	jmp    8032ef <insert_sorted_with_merge_freeList+0x111>
  8032e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032e7:	8b 40 04             	mov    0x4(%eax),%eax
  8032ea:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032f2:	8b 40 04             	mov    0x4(%eax),%eax
  8032f5:	85 c0                	test   %eax,%eax
  8032f7:	74 0f                	je     803308 <insert_sorted_with_merge_freeList+0x12a>
  8032f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032fc:	8b 40 04             	mov    0x4(%eax),%eax
  8032ff:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803302:	8b 12                	mov    (%edx),%edx
  803304:	89 10                	mov    %edx,(%eax)
  803306:	eb 0a                	jmp    803312 <insert_sorted_with_merge_freeList+0x134>
  803308:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80330b:	8b 00                	mov    (%eax),%eax
  80330d:	a3 38 51 80 00       	mov    %eax,0x805138
  803312:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803315:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80331b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80331e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803325:	a1 44 51 80 00       	mov    0x805144,%eax
  80332a:	48                   	dec    %eax
  80332b:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  803330:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803333:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  80333a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80333d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  803344:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803348:	75 17                	jne    803361 <insert_sorted_with_merge_freeList+0x183>
  80334a:	83 ec 04             	sub    $0x4,%esp
  80334d:	68 2c 45 80 00       	push   $0x80452c
  803352:	68 3f 01 00 00       	push   $0x13f
  803357:	68 4f 45 80 00       	push   $0x80454f
  80335c:	e8 ab d5 ff ff       	call   80090c <_panic>
  803361:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803367:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80336a:	89 10                	mov    %edx,(%eax)
  80336c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80336f:	8b 00                	mov    (%eax),%eax
  803371:	85 c0                	test   %eax,%eax
  803373:	74 0d                	je     803382 <insert_sorted_with_merge_freeList+0x1a4>
  803375:	a1 48 51 80 00       	mov    0x805148,%eax
  80337a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80337d:	89 50 04             	mov    %edx,0x4(%eax)
  803380:	eb 08                	jmp    80338a <insert_sorted_with_merge_freeList+0x1ac>
  803382:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803385:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80338a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80338d:	a3 48 51 80 00       	mov    %eax,0x805148
  803392:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803395:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80339c:	a1 54 51 80 00       	mov    0x805154,%eax
  8033a1:	40                   	inc    %eax
  8033a2:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8033a7:	e9 7a 05 00 00       	jmp    803926 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  8033ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8033af:	8b 50 08             	mov    0x8(%eax),%edx
  8033b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033b5:	8b 40 08             	mov    0x8(%eax),%eax
  8033b8:	39 c2                	cmp    %eax,%edx
  8033ba:	0f 82 14 01 00 00    	jb     8034d4 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  8033c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033c3:	8b 50 08             	mov    0x8(%eax),%edx
  8033c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033c9:	8b 40 0c             	mov    0xc(%eax),%eax
  8033cc:	01 c2                	add    %eax,%edx
  8033ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d1:	8b 40 08             	mov    0x8(%eax),%eax
  8033d4:	39 c2                	cmp    %eax,%edx
  8033d6:	0f 85 90 00 00 00    	jne    80346c <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  8033dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033df:	8b 50 0c             	mov    0xc(%eax),%edx
  8033e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e5:	8b 40 0c             	mov    0xc(%eax),%eax
  8033e8:	01 c2                	add    %eax,%edx
  8033ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033ed:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  8033f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  8033fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8033fd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803404:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803408:	75 17                	jne    803421 <insert_sorted_with_merge_freeList+0x243>
  80340a:	83 ec 04             	sub    $0x4,%esp
  80340d:	68 2c 45 80 00       	push   $0x80452c
  803412:	68 49 01 00 00       	push   $0x149
  803417:	68 4f 45 80 00       	push   $0x80454f
  80341c:	e8 eb d4 ff ff       	call   80090c <_panic>
  803421:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803427:	8b 45 08             	mov    0x8(%ebp),%eax
  80342a:	89 10                	mov    %edx,(%eax)
  80342c:	8b 45 08             	mov    0x8(%ebp),%eax
  80342f:	8b 00                	mov    (%eax),%eax
  803431:	85 c0                	test   %eax,%eax
  803433:	74 0d                	je     803442 <insert_sorted_with_merge_freeList+0x264>
  803435:	a1 48 51 80 00       	mov    0x805148,%eax
  80343a:	8b 55 08             	mov    0x8(%ebp),%edx
  80343d:	89 50 04             	mov    %edx,0x4(%eax)
  803440:	eb 08                	jmp    80344a <insert_sorted_with_merge_freeList+0x26c>
  803442:	8b 45 08             	mov    0x8(%ebp),%eax
  803445:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80344a:	8b 45 08             	mov    0x8(%ebp),%eax
  80344d:	a3 48 51 80 00       	mov    %eax,0x805148
  803452:	8b 45 08             	mov    0x8(%ebp),%eax
  803455:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80345c:	a1 54 51 80 00       	mov    0x805154,%eax
  803461:	40                   	inc    %eax
  803462:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803467:	e9 bb 04 00 00       	jmp    803927 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  80346c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803470:	75 17                	jne    803489 <insert_sorted_with_merge_freeList+0x2ab>
  803472:	83 ec 04             	sub    $0x4,%esp
  803475:	68 a0 45 80 00       	push   $0x8045a0
  80347a:	68 4c 01 00 00       	push   $0x14c
  80347f:	68 4f 45 80 00       	push   $0x80454f
  803484:	e8 83 d4 ff ff       	call   80090c <_panic>
  803489:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  80348f:	8b 45 08             	mov    0x8(%ebp),%eax
  803492:	89 50 04             	mov    %edx,0x4(%eax)
  803495:	8b 45 08             	mov    0x8(%ebp),%eax
  803498:	8b 40 04             	mov    0x4(%eax),%eax
  80349b:	85 c0                	test   %eax,%eax
  80349d:	74 0c                	je     8034ab <insert_sorted_with_merge_freeList+0x2cd>
  80349f:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8034a4:	8b 55 08             	mov    0x8(%ebp),%edx
  8034a7:	89 10                	mov    %edx,(%eax)
  8034a9:	eb 08                	jmp    8034b3 <insert_sorted_with_merge_freeList+0x2d5>
  8034ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ae:	a3 38 51 80 00       	mov    %eax,0x805138
  8034b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8034bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8034be:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034c4:	a1 44 51 80 00       	mov    0x805144,%eax
  8034c9:	40                   	inc    %eax
  8034ca:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8034cf:	e9 53 04 00 00       	jmp    803927 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8034d4:	a1 38 51 80 00       	mov    0x805138,%eax
  8034d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8034dc:	e9 15 04 00 00       	jmp    8038f6 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  8034e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034e4:	8b 00                	mov    (%eax),%eax
  8034e6:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  8034e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ec:	8b 50 08             	mov    0x8(%eax),%edx
  8034ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034f2:	8b 40 08             	mov    0x8(%eax),%eax
  8034f5:	39 c2                	cmp    %eax,%edx
  8034f7:	0f 86 f1 03 00 00    	jbe    8038ee <insert_sorted_with_merge_freeList+0x710>
  8034fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803500:	8b 50 08             	mov    0x8(%eax),%edx
  803503:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803506:	8b 40 08             	mov    0x8(%eax),%eax
  803509:	39 c2                	cmp    %eax,%edx
  80350b:	0f 83 dd 03 00 00    	jae    8038ee <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803511:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803514:	8b 50 08             	mov    0x8(%eax),%edx
  803517:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80351a:	8b 40 0c             	mov    0xc(%eax),%eax
  80351d:	01 c2                	add    %eax,%edx
  80351f:	8b 45 08             	mov    0x8(%ebp),%eax
  803522:	8b 40 08             	mov    0x8(%eax),%eax
  803525:	39 c2                	cmp    %eax,%edx
  803527:	0f 85 b9 01 00 00    	jne    8036e6 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80352d:	8b 45 08             	mov    0x8(%ebp),%eax
  803530:	8b 50 08             	mov    0x8(%eax),%edx
  803533:	8b 45 08             	mov    0x8(%ebp),%eax
  803536:	8b 40 0c             	mov    0xc(%eax),%eax
  803539:	01 c2                	add    %eax,%edx
  80353b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80353e:	8b 40 08             	mov    0x8(%eax),%eax
  803541:	39 c2                	cmp    %eax,%edx
  803543:	0f 85 0d 01 00 00    	jne    803656 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803549:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80354c:	8b 50 0c             	mov    0xc(%eax),%edx
  80354f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803552:	8b 40 0c             	mov    0xc(%eax),%eax
  803555:	01 c2                	add    %eax,%edx
  803557:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80355a:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80355d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803561:	75 17                	jne    80357a <insert_sorted_with_merge_freeList+0x39c>
  803563:	83 ec 04             	sub    $0x4,%esp
  803566:	68 f8 45 80 00       	push   $0x8045f8
  80356b:	68 5c 01 00 00       	push   $0x15c
  803570:	68 4f 45 80 00       	push   $0x80454f
  803575:	e8 92 d3 ff ff       	call   80090c <_panic>
  80357a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80357d:	8b 00                	mov    (%eax),%eax
  80357f:	85 c0                	test   %eax,%eax
  803581:	74 10                	je     803593 <insert_sorted_with_merge_freeList+0x3b5>
  803583:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803586:	8b 00                	mov    (%eax),%eax
  803588:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80358b:	8b 52 04             	mov    0x4(%edx),%edx
  80358e:	89 50 04             	mov    %edx,0x4(%eax)
  803591:	eb 0b                	jmp    80359e <insert_sorted_with_merge_freeList+0x3c0>
  803593:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803596:	8b 40 04             	mov    0x4(%eax),%eax
  803599:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80359e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035a1:	8b 40 04             	mov    0x4(%eax),%eax
  8035a4:	85 c0                	test   %eax,%eax
  8035a6:	74 0f                	je     8035b7 <insert_sorted_with_merge_freeList+0x3d9>
  8035a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035ab:	8b 40 04             	mov    0x4(%eax),%eax
  8035ae:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8035b1:	8b 12                	mov    (%edx),%edx
  8035b3:	89 10                	mov    %edx,(%eax)
  8035b5:	eb 0a                	jmp    8035c1 <insert_sorted_with_merge_freeList+0x3e3>
  8035b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035ba:	8b 00                	mov    (%eax),%eax
  8035bc:	a3 38 51 80 00       	mov    %eax,0x805138
  8035c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035c4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035cd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035d4:	a1 44 51 80 00       	mov    0x805144,%eax
  8035d9:	48                   	dec    %eax
  8035da:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  8035df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035e2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8035e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035ec:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8035f3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8035f7:	75 17                	jne    803610 <insert_sorted_with_merge_freeList+0x432>
  8035f9:	83 ec 04             	sub    $0x4,%esp
  8035fc:	68 2c 45 80 00       	push   $0x80452c
  803601:	68 5f 01 00 00       	push   $0x15f
  803606:	68 4f 45 80 00       	push   $0x80454f
  80360b:	e8 fc d2 ff ff       	call   80090c <_panic>
  803610:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803616:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803619:	89 10                	mov    %edx,(%eax)
  80361b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80361e:	8b 00                	mov    (%eax),%eax
  803620:	85 c0                	test   %eax,%eax
  803622:	74 0d                	je     803631 <insert_sorted_with_merge_freeList+0x453>
  803624:	a1 48 51 80 00       	mov    0x805148,%eax
  803629:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80362c:	89 50 04             	mov    %edx,0x4(%eax)
  80362f:	eb 08                	jmp    803639 <insert_sorted_with_merge_freeList+0x45b>
  803631:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803634:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803639:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80363c:	a3 48 51 80 00       	mov    %eax,0x805148
  803641:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803644:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80364b:	a1 54 51 80 00       	mov    0x805154,%eax
  803650:	40                   	inc    %eax
  803651:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803656:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803659:	8b 50 0c             	mov    0xc(%eax),%edx
  80365c:	8b 45 08             	mov    0x8(%ebp),%eax
  80365f:	8b 40 0c             	mov    0xc(%eax),%eax
  803662:	01 c2                	add    %eax,%edx
  803664:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803667:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  80366a:	8b 45 08             	mov    0x8(%ebp),%eax
  80366d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803674:	8b 45 08             	mov    0x8(%ebp),%eax
  803677:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80367e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803682:	75 17                	jne    80369b <insert_sorted_with_merge_freeList+0x4bd>
  803684:	83 ec 04             	sub    $0x4,%esp
  803687:	68 2c 45 80 00       	push   $0x80452c
  80368c:	68 64 01 00 00       	push   $0x164
  803691:	68 4f 45 80 00       	push   $0x80454f
  803696:	e8 71 d2 ff ff       	call   80090c <_panic>
  80369b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8036a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8036a4:	89 10                	mov    %edx,(%eax)
  8036a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8036a9:	8b 00                	mov    (%eax),%eax
  8036ab:	85 c0                	test   %eax,%eax
  8036ad:	74 0d                	je     8036bc <insert_sorted_with_merge_freeList+0x4de>
  8036af:	a1 48 51 80 00       	mov    0x805148,%eax
  8036b4:	8b 55 08             	mov    0x8(%ebp),%edx
  8036b7:	89 50 04             	mov    %edx,0x4(%eax)
  8036ba:	eb 08                	jmp    8036c4 <insert_sorted_with_merge_freeList+0x4e6>
  8036bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8036bf:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8036c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8036c7:	a3 48 51 80 00       	mov    %eax,0x805148
  8036cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8036cf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036d6:	a1 54 51 80 00       	mov    0x805154,%eax
  8036db:	40                   	inc    %eax
  8036dc:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8036e1:	e9 41 02 00 00       	jmp    803927 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8036e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e9:	8b 50 08             	mov    0x8(%eax),%edx
  8036ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ef:	8b 40 0c             	mov    0xc(%eax),%eax
  8036f2:	01 c2                	add    %eax,%edx
  8036f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036f7:	8b 40 08             	mov    0x8(%eax),%eax
  8036fa:	39 c2                	cmp    %eax,%edx
  8036fc:	0f 85 7c 01 00 00    	jne    80387e <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803702:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803706:	74 06                	je     80370e <insert_sorted_with_merge_freeList+0x530>
  803708:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80370c:	75 17                	jne    803725 <insert_sorted_with_merge_freeList+0x547>
  80370e:	83 ec 04             	sub    $0x4,%esp
  803711:	68 68 45 80 00       	push   $0x804568
  803716:	68 69 01 00 00       	push   $0x169
  80371b:	68 4f 45 80 00       	push   $0x80454f
  803720:	e8 e7 d1 ff ff       	call   80090c <_panic>
  803725:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803728:	8b 50 04             	mov    0x4(%eax),%edx
  80372b:	8b 45 08             	mov    0x8(%ebp),%eax
  80372e:	89 50 04             	mov    %edx,0x4(%eax)
  803731:	8b 45 08             	mov    0x8(%ebp),%eax
  803734:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803737:	89 10                	mov    %edx,(%eax)
  803739:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80373c:	8b 40 04             	mov    0x4(%eax),%eax
  80373f:	85 c0                	test   %eax,%eax
  803741:	74 0d                	je     803750 <insert_sorted_with_merge_freeList+0x572>
  803743:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803746:	8b 40 04             	mov    0x4(%eax),%eax
  803749:	8b 55 08             	mov    0x8(%ebp),%edx
  80374c:	89 10                	mov    %edx,(%eax)
  80374e:	eb 08                	jmp    803758 <insert_sorted_with_merge_freeList+0x57a>
  803750:	8b 45 08             	mov    0x8(%ebp),%eax
  803753:	a3 38 51 80 00       	mov    %eax,0x805138
  803758:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80375b:	8b 55 08             	mov    0x8(%ebp),%edx
  80375e:	89 50 04             	mov    %edx,0x4(%eax)
  803761:	a1 44 51 80 00       	mov    0x805144,%eax
  803766:	40                   	inc    %eax
  803767:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  80376c:	8b 45 08             	mov    0x8(%ebp),%eax
  80376f:	8b 50 0c             	mov    0xc(%eax),%edx
  803772:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803775:	8b 40 0c             	mov    0xc(%eax),%eax
  803778:	01 c2                	add    %eax,%edx
  80377a:	8b 45 08             	mov    0x8(%ebp),%eax
  80377d:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803780:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803784:	75 17                	jne    80379d <insert_sorted_with_merge_freeList+0x5bf>
  803786:	83 ec 04             	sub    $0x4,%esp
  803789:	68 f8 45 80 00       	push   $0x8045f8
  80378e:	68 6b 01 00 00       	push   $0x16b
  803793:	68 4f 45 80 00       	push   $0x80454f
  803798:	e8 6f d1 ff ff       	call   80090c <_panic>
  80379d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037a0:	8b 00                	mov    (%eax),%eax
  8037a2:	85 c0                	test   %eax,%eax
  8037a4:	74 10                	je     8037b6 <insert_sorted_with_merge_freeList+0x5d8>
  8037a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037a9:	8b 00                	mov    (%eax),%eax
  8037ab:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8037ae:	8b 52 04             	mov    0x4(%edx),%edx
  8037b1:	89 50 04             	mov    %edx,0x4(%eax)
  8037b4:	eb 0b                	jmp    8037c1 <insert_sorted_with_merge_freeList+0x5e3>
  8037b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037b9:	8b 40 04             	mov    0x4(%eax),%eax
  8037bc:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8037c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037c4:	8b 40 04             	mov    0x4(%eax),%eax
  8037c7:	85 c0                	test   %eax,%eax
  8037c9:	74 0f                	je     8037da <insert_sorted_with_merge_freeList+0x5fc>
  8037cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037ce:	8b 40 04             	mov    0x4(%eax),%eax
  8037d1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8037d4:	8b 12                	mov    (%edx),%edx
  8037d6:	89 10                	mov    %edx,(%eax)
  8037d8:	eb 0a                	jmp    8037e4 <insert_sorted_with_merge_freeList+0x606>
  8037da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037dd:	8b 00                	mov    (%eax),%eax
  8037df:	a3 38 51 80 00       	mov    %eax,0x805138
  8037e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037f0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037f7:	a1 44 51 80 00       	mov    0x805144,%eax
  8037fc:	48                   	dec    %eax
  8037fd:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803802:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803805:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  80380c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80380f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803816:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80381a:	75 17                	jne    803833 <insert_sorted_with_merge_freeList+0x655>
  80381c:	83 ec 04             	sub    $0x4,%esp
  80381f:	68 2c 45 80 00       	push   $0x80452c
  803824:	68 6e 01 00 00       	push   $0x16e
  803829:	68 4f 45 80 00       	push   $0x80454f
  80382e:	e8 d9 d0 ff ff       	call   80090c <_panic>
  803833:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803839:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80383c:	89 10                	mov    %edx,(%eax)
  80383e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803841:	8b 00                	mov    (%eax),%eax
  803843:	85 c0                	test   %eax,%eax
  803845:	74 0d                	je     803854 <insert_sorted_with_merge_freeList+0x676>
  803847:	a1 48 51 80 00       	mov    0x805148,%eax
  80384c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80384f:	89 50 04             	mov    %edx,0x4(%eax)
  803852:	eb 08                	jmp    80385c <insert_sorted_with_merge_freeList+0x67e>
  803854:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803857:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80385c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80385f:	a3 48 51 80 00       	mov    %eax,0x805148
  803864:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803867:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80386e:	a1 54 51 80 00       	mov    0x805154,%eax
  803873:	40                   	inc    %eax
  803874:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803879:	e9 a9 00 00 00       	jmp    803927 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  80387e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803882:	74 06                	je     80388a <insert_sorted_with_merge_freeList+0x6ac>
  803884:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803888:	75 17                	jne    8038a1 <insert_sorted_with_merge_freeList+0x6c3>
  80388a:	83 ec 04             	sub    $0x4,%esp
  80388d:	68 c4 45 80 00       	push   $0x8045c4
  803892:	68 73 01 00 00       	push   $0x173
  803897:	68 4f 45 80 00       	push   $0x80454f
  80389c:	e8 6b d0 ff ff       	call   80090c <_panic>
  8038a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038a4:	8b 10                	mov    (%eax),%edx
  8038a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8038a9:	89 10                	mov    %edx,(%eax)
  8038ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ae:	8b 00                	mov    (%eax),%eax
  8038b0:	85 c0                	test   %eax,%eax
  8038b2:	74 0b                	je     8038bf <insert_sorted_with_merge_freeList+0x6e1>
  8038b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038b7:	8b 00                	mov    (%eax),%eax
  8038b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8038bc:	89 50 04             	mov    %edx,0x4(%eax)
  8038bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8038c5:	89 10                	mov    %edx,(%eax)
  8038c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8038cd:	89 50 04             	mov    %edx,0x4(%eax)
  8038d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8038d3:	8b 00                	mov    (%eax),%eax
  8038d5:	85 c0                	test   %eax,%eax
  8038d7:	75 08                	jne    8038e1 <insert_sorted_with_merge_freeList+0x703>
  8038d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8038dc:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8038e1:	a1 44 51 80 00       	mov    0x805144,%eax
  8038e6:	40                   	inc    %eax
  8038e7:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  8038ec:	eb 39                	jmp    803927 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8038ee:	a1 40 51 80 00       	mov    0x805140,%eax
  8038f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8038f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038fa:	74 07                	je     803903 <insert_sorted_with_merge_freeList+0x725>
  8038fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038ff:	8b 00                	mov    (%eax),%eax
  803901:	eb 05                	jmp    803908 <insert_sorted_with_merge_freeList+0x72a>
  803903:	b8 00 00 00 00       	mov    $0x0,%eax
  803908:	a3 40 51 80 00       	mov    %eax,0x805140
  80390d:	a1 40 51 80 00       	mov    0x805140,%eax
  803912:	85 c0                	test   %eax,%eax
  803914:	0f 85 c7 fb ff ff    	jne    8034e1 <insert_sorted_with_merge_freeList+0x303>
  80391a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80391e:	0f 85 bd fb ff ff    	jne    8034e1 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803924:	eb 01                	jmp    803927 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803926:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803927:	90                   	nop
  803928:	c9                   	leave  
  803929:	c3                   	ret    
  80392a:	66 90                	xchg   %ax,%ax

0080392c <__udivdi3>:
  80392c:	55                   	push   %ebp
  80392d:	57                   	push   %edi
  80392e:	56                   	push   %esi
  80392f:	53                   	push   %ebx
  803930:	83 ec 1c             	sub    $0x1c,%esp
  803933:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803937:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80393b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80393f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803943:	89 ca                	mov    %ecx,%edx
  803945:	89 f8                	mov    %edi,%eax
  803947:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80394b:	85 f6                	test   %esi,%esi
  80394d:	75 2d                	jne    80397c <__udivdi3+0x50>
  80394f:	39 cf                	cmp    %ecx,%edi
  803951:	77 65                	ja     8039b8 <__udivdi3+0x8c>
  803953:	89 fd                	mov    %edi,%ebp
  803955:	85 ff                	test   %edi,%edi
  803957:	75 0b                	jne    803964 <__udivdi3+0x38>
  803959:	b8 01 00 00 00       	mov    $0x1,%eax
  80395e:	31 d2                	xor    %edx,%edx
  803960:	f7 f7                	div    %edi
  803962:	89 c5                	mov    %eax,%ebp
  803964:	31 d2                	xor    %edx,%edx
  803966:	89 c8                	mov    %ecx,%eax
  803968:	f7 f5                	div    %ebp
  80396a:	89 c1                	mov    %eax,%ecx
  80396c:	89 d8                	mov    %ebx,%eax
  80396e:	f7 f5                	div    %ebp
  803970:	89 cf                	mov    %ecx,%edi
  803972:	89 fa                	mov    %edi,%edx
  803974:	83 c4 1c             	add    $0x1c,%esp
  803977:	5b                   	pop    %ebx
  803978:	5e                   	pop    %esi
  803979:	5f                   	pop    %edi
  80397a:	5d                   	pop    %ebp
  80397b:	c3                   	ret    
  80397c:	39 ce                	cmp    %ecx,%esi
  80397e:	77 28                	ja     8039a8 <__udivdi3+0x7c>
  803980:	0f bd fe             	bsr    %esi,%edi
  803983:	83 f7 1f             	xor    $0x1f,%edi
  803986:	75 40                	jne    8039c8 <__udivdi3+0x9c>
  803988:	39 ce                	cmp    %ecx,%esi
  80398a:	72 0a                	jb     803996 <__udivdi3+0x6a>
  80398c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803990:	0f 87 9e 00 00 00    	ja     803a34 <__udivdi3+0x108>
  803996:	b8 01 00 00 00       	mov    $0x1,%eax
  80399b:	89 fa                	mov    %edi,%edx
  80399d:	83 c4 1c             	add    $0x1c,%esp
  8039a0:	5b                   	pop    %ebx
  8039a1:	5e                   	pop    %esi
  8039a2:	5f                   	pop    %edi
  8039a3:	5d                   	pop    %ebp
  8039a4:	c3                   	ret    
  8039a5:	8d 76 00             	lea    0x0(%esi),%esi
  8039a8:	31 ff                	xor    %edi,%edi
  8039aa:	31 c0                	xor    %eax,%eax
  8039ac:	89 fa                	mov    %edi,%edx
  8039ae:	83 c4 1c             	add    $0x1c,%esp
  8039b1:	5b                   	pop    %ebx
  8039b2:	5e                   	pop    %esi
  8039b3:	5f                   	pop    %edi
  8039b4:	5d                   	pop    %ebp
  8039b5:	c3                   	ret    
  8039b6:	66 90                	xchg   %ax,%ax
  8039b8:	89 d8                	mov    %ebx,%eax
  8039ba:	f7 f7                	div    %edi
  8039bc:	31 ff                	xor    %edi,%edi
  8039be:	89 fa                	mov    %edi,%edx
  8039c0:	83 c4 1c             	add    $0x1c,%esp
  8039c3:	5b                   	pop    %ebx
  8039c4:	5e                   	pop    %esi
  8039c5:	5f                   	pop    %edi
  8039c6:	5d                   	pop    %ebp
  8039c7:	c3                   	ret    
  8039c8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8039cd:	89 eb                	mov    %ebp,%ebx
  8039cf:	29 fb                	sub    %edi,%ebx
  8039d1:	89 f9                	mov    %edi,%ecx
  8039d3:	d3 e6                	shl    %cl,%esi
  8039d5:	89 c5                	mov    %eax,%ebp
  8039d7:	88 d9                	mov    %bl,%cl
  8039d9:	d3 ed                	shr    %cl,%ebp
  8039db:	89 e9                	mov    %ebp,%ecx
  8039dd:	09 f1                	or     %esi,%ecx
  8039df:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8039e3:	89 f9                	mov    %edi,%ecx
  8039e5:	d3 e0                	shl    %cl,%eax
  8039e7:	89 c5                	mov    %eax,%ebp
  8039e9:	89 d6                	mov    %edx,%esi
  8039eb:	88 d9                	mov    %bl,%cl
  8039ed:	d3 ee                	shr    %cl,%esi
  8039ef:	89 f9                	mov    %edi,%ecx
  8039f1:	d3 e2                	shl    %cl,%edx
  8039f3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8039f7:	88 d9                	mov    %bl,%cl
  8039f9:	d3 e8                	shr    %cl,%eax
  8039fb:	09 c2                	or     %eax,%edx
  8039fd:	89 d0                	mov    %edx,%eax
  8039ff:	89 f2                	mov    %esi,%edx
  803a01:	f7 74 24 0c          	divl   0xc(%esp)
  803a05:	89 d6                	mov    %edx,%esi
  803a07:	89 c3                	mov    %eax,%ebx
  803a09:	f7 e5                	mul    %ebp
  803a0b:	39 d6                	cmp    %edx,%esi
  803a0d:	72 19                	jb     803a28 <__udivdi3+0xfc>
  803a0f:	74 0b                	je     803a1c <__udivdi3+0xf0>
  803a11:	89 d8                	mov    %ebx,%eax
  803a13:	31 ff                	xor    %edi,%edi
  803a15:	e9 58 ff ff ff       	jmp    803972 <__udivdi3+0x46>
  803a1a:	66 90                	xchg   %ax,%ax
  803a1c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803a20:	89 f9                	mov    %edi,%ecx
  803a22:	d3 e2                	shl    %cl,%edx
  803a24:	39 c2                	cmp    %eax,%edx
  803a26:	73 e9                	jae    803a11 <__udivdi3+0xe5>
  803a28:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803a2b:	31 ff                	xor    %edi,%edi
  803a2d:	e9 40 ff ff ff       	jmp    803972 <__udivdi3+0x46>
  803a32:	66 90                	xchg   %ax,%ax
  803a34:	31 c0                	xor    %eax,%eax
  803a36:	e9 37 ff ff ff       	jmp    803972 <__udivdi3+0x46>
  803a3b:	90                   	nop

00803a3c <__umoddi3>:
  803a3c:	55                   	push   %ebp
  803a3d:	57                   	push   %edi
  803a3e:	56                   	push   %esi
  803a3f:	53                   	push   %ebx
  803a40:	83 ec 1c             	sub    $0x1c,%esp
  803a43:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803a47:	8b 74 24 34          	mov    0x34(%esp),%esi
  803a4b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803a4f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803a53:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803a57:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803a5b:	89 f3                	mov    %esi,%ebx
  803a5d:	89 fa                	mov    %edi,%edx
  803a5f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803a63:	89 34 24             	mov    %esi,(%esp)
  803a66:	85 c0                	test   %eax,%eax
  803a68:	75 1a                	jne    803a84 <__umoddi3+0x48>
  803a6a:	39 f7                	cmp    %esi,%edi
  803a6c:	0f 86 a2 00 00 00    	jbe    803b14 <__umoddi3+0xd8>
  803a72:	89 c8                	mov    %ecx,%eax
  803a74:	89 f2                	mov    %esi,%edx
  803a76:	f7 f7                	div    %edi
  803a78:	89 d0                	mov    %edx,%eax
  803a7a:	31 d2                	xor    %edx,%edx
  803a7c:	83 c4 1c             	add    $0x1c,%esp
  803a7f:	5b                   	pop    %ebx
  803a80:	5e                   	pop    %esi
  803a81:	5f                   	pop    %edi
  803a82:	5d                   	pop    %ebp
  803a83:	c3                   	ret    
  803a84:	39 f0                	cmp    %esi,%eax
  803a86:	0f 87 ac 00 00 00    	ja     803b38 <__umoddi3+0xfc>
  803a8c:	0f bd e8             	bsr    %eax,%ebp
  803a8f:	83 f5 1f             	xor    $0x1f,%ebp
  803a92:	0f 84 ac 00 00 00    	je     803b44 <__umoddi3+0x108>
  803a98:	bf 20 00 00 00       	mov    $0x20,%edi
  803a9d:	29 ef                	sub    %ebp,%edi
  803a9f:	89 fe                	mov    %edi,%esi
  803aa1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803aa5:	89 e9                	mov    %ebp,%ecx
  803aa7:	d3 e0                	shl    %cl,%eax
  803aa9:	89 d7                	mov    %edx,%edi
  803aab:	89 f1                	mov    %esi,%ecx
  803aad:	d3 ef                	shr    %cl,%edi
  803aaf:	09 c7                	or     %eax,%edi
  803ab1:	89 e9                	mov    %ebp,%ecx
  803ab3:	d3 e2                	shl    %cl,%edx
  803ab5:	89 14 24             	mov    %edx,(%esp)
  803ab8:	89 d8                	mov    %ebx,%eax
  803aba:	d3 e0                	shl    %cl,%eax
  803abc:	89 c2                	mov    %eax,%edx
  803abe:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ac2:	d3 e0                	shl    %cl,%eax
  803ac4:	89 44 24 04          	mov    %eax,0x4(%esp)
  803ac8:	8b 44 24 08          	mov    0x8(%esp),%eax
  803acc:	89 f1                	mov    %esi,%ecx
  803ace:	d3 e8                	shr    %cl,%eax
  803ad0:	09 d0                	or     %edx,%eax
  803ad2:	d3 eb                	shr    %cl,%ebx
  803ad4:	89 da                	mov    %ebx,%edx
  803ad6:	f7 f7                	div    %edi
  803ad8:	89 d3                	mov    %edx,%ebx
  803ada:	f7 24 24             	mull   (%esp)
  803add:	89 c6                	mov    %eax,%esi
  803adf:	89 d1                	mov    %edx,%ecx
  803ae1:	39 d3                	cmp    %edx,%ebx
  803ae3:	0f 82 87 00 00 00    	jb     803b70 <__umoddi3+0x134>
  803ae9:	0f 84 91 00 00 00    	je     803b80 <__umoddi3+0x144>
  803aef:	8b 54 24 04          	mov    0x4(%esp),%edx
  803af3:	29 f2                	sub    %esi,%edx
  803af5:	19 cb                	sbb    %ecx,%ebx
  803af7:	89 d8                	mov    %ebx,%eax
  803af9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803afd:	d3 e0                	shl    %cl,%eax
  803aff:	89 e9                	mov    %ebp,%ecx
  803b01:	d3 ea                	shr    %cl,%edx
  803b03:	09 d0                	or     %edx,%eax
  803b05:	89 e9                	mov    %ebp,%ecx
  803b07:	d3 eb                	shr    %cl,%ebx
  803b09:	89 da                	mov    %ebx,%edx
  803b0b:	83 c4 1c             	add    $0x1c,%esp
  803b0e:	5b                   	pop    %ebx
  803b0f:	5e                   	pop    %esi
  803b10:	5f                   	pop    %edi
  803b11:	5d                   	pop    %ebp
  803b12:	c3                   	ret    
  803b13:	90                   	nop
  803b14:	89 fd                	mov    %edi,%ebp
  803b16:	85 ff                	test   %edi,%edi
  803b18:	75 0b                	jne    803b25 <__umoddi3+0xe9>
  803b1a:	b8 01 00 00 00       	mov    $0x1,%eax
  803b1f:	31 d2                	xor    %edx,%edx
  803b21:	f7 f7                	div    %edi
  803b23:	89 c5                	mov    %eax,%ebp
  803b25:	89 f0                	mov    %esi,%eax
  803b27:	31 d2                	xor    %edx,%edx
  803b29:	f7 f5                	div    %ebp
  803b2b:	89 c8                	mov    %ecx,%eax
  803b2d:	f7 f5                	div    %ebp
  803b2f:	89 d0                	mov    %edx,%eax
  803b31:	e9 44 ff ff ff       	jmp    803a7a <__umoddi3+0x3e>
  803b36:	66 90                	xchg   %ax,%ax
  803b38:	89 c8                	mov    %ecx,%eax
  803b3a:	89 f2                	mov    %esi,%edx
  803b3c:	83 c4 1c             	add    $0x1c,%esp
  803b3f:	5b                   	pop    %ebx
  803b40:	5e                   	pop    %esi
  803b41:	5f                   	pop    %edi
  803b42:	5d                   	pop    %ebp
  803b43:	c3                   	ret    
  803b44:	3b 04 24             	cmp    (%esp),%eax
  803b47:	72 06                	jb     803b4f <__umoddi3+0x113>
  803b49:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803b4d:	77 0f                	ja     803b5e <__umoddi3+0x122>
  803b4f:	89 f2                	mov    %esi,%edx
  803b51:	29 f9                	sub    %edi,%ecx
  803b53:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803b57:	89 14 24             	mov    %edx,(%esp)
  803b5a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803b5e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803b62:	8b 14 24             	mov    (%esp),%edx
  803b65:	83 c4 1c             	add    $0x1c,%esp
  803b68:	5b                   	pop    %ebx
  803b69:	5e                   	pop    %esi
  803b6a:	5f                   	pop    %edi
  803b6b:	5d                   	pop    %ebp
  803b6c:	c3                   	ret    
  803b6d:	8d 76 00             	lea    0x0(%esi),%esi
  803b70:	2b 04 24             	sub    (%esp),%eax
  803b73:	19 fa                	sbb    %edi,%edx
  803b75:	89 d1                	mov    %edx,%ecx
  803b77:	89 c6                	mov    %eax,%esi
  803b79:	e9 71 ff ff ff       	jmp    803aef <__umoddi3+0xb3>
  803b7e:	66 90                	xchg   %ax,%ax
  803b80:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803b84:	72 ea                	jb     803b70 <__umoddi3+0x134>
  803b86:	89 d9                	mov    %ebx,%ecx
  803b88:	e9 62 ff ff ff       	jmp    803aef <__umoddi3+0xb3>
