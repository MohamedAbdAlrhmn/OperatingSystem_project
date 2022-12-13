
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
  80004b:	e8 ba 1e 00 00       	call   801f0a <sys_disable_interrupt>

		cprintf("\n");
  800050:	83 ec 0c             	sub    $0xc,%esp
  800053:	68 60 3c 80 00       	push   $0x803c60
  800058:	e8 63 0b 00 00       	call   800bc0 <cprintf>
  80005d:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800060:	83 ec 0c             	sub    $0xc,%esp
  800063:	68 62 3c 80 00       	push   $0x803c62
  800068:	e8 53 0b 00 00       	call   800bc0 <cprintf>
  80006d:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!! MERGE SORT !!!!\n");
  800070:	83 ec 0c             	sub    $0xc,%esp
  800073:	68 78 3c 80 00       	push   $0x803c78
  800078:	e8 43 0b 00 00       	call   800bc0 <cprintf>
  80007d:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800080:	83 ec 0c             	sub    $0xc,%esp
  800083:	68 62 3c 80 00       	push   $0x803c62
  800088:	e8 33 0b 00 00       	call   800bc0 <cprintf>
  80008d:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800090:	83 ec 0c             	sub    $0xc,%esp
  800093:	68 60 3c 80 00       	push   $0x803c60
  800098:	e8 23 0b 00 00       	call   800bc0 <cprintf>
  80009d:	83 c4 10             	add    $0x10,%esp
		cprintf("Enter the number of elements: ");
  8000a0:	83 ec 0c             	sub    $0xc,%esp
  8000a3:	68 90 3c 80 00       	push   $0x803c90
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
  8000d2:	68 af 3c 80 00       	push   $0x803caf
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
  8000f7:	68 b4 3c 80 00       	push   $0x803cb4
  8000fc:	e8 bf 0a 00 00       	call   800bc0 <cprintf>
  800101:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  800104:	83 ec 0c             	sub    $0xc,%esp
  800107:	68 d6 3c 80 00       	push   $0x803cd6
  80010c:	e8 af 0a 00 00       	call   800bc0 <cprintf>
  800111:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  800114:	83 ec 0c             	sub    $0xc,%esp
  800117:	68 e4 3c 80 00       	push   $0x803ce4
  80011c:	e8 9f 0a 00 00       	call   800bc0 <cprintf>
  800121:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  800124:	83 ec 0c             	sub    $0xc,%esp
  800127:	68 f3 3c 80 00       	push   $0x803cf3
  80012c:	e8 8f 0a 00 00       	call   800bc0 <cprintf>
  800131:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  800134:	83 ec 0c             	sub    $0xc,%esp
  800137:	68 03 3d 80 00       	push   $0x803d03
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
  800189:	e8 96 1d 00 00       	call   801f24 <sys_enable_interrupt>

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
  8001fe:	e8 07 1d 00 00       	call   801f0a <sys_disable_interrupt>
		cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  800203:	83 ec 0c             	sub    $0xc,%esp
  800206:	68 0c 3d 80 00       	push   $0x803d0c
  80020b:	e8 b0 09 00 00       	call   800bc0 <cprintf>
  800210:	83 c4 10             	add    $0x10,%esp
		//PrintElements(Elements, NumOfElements);
		sys_enable_interrupt();
  800213:	e8 0c 1d 00 00       	call   801f24 <sys_enable_interrupt>

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
  800235:	68 40 3d 80 00       	push   $0x803d40
  80023a:	6a 58                	push   $0x58
  80023c:	68 62 3d 80 00       	push   $0x803d62
  800241:	e8 c6 06 00 00       	call   80090c <_panic>
		else
		{
			sys_disable_interrupt();
  800246:	e8 bf 1c 00 00       	call   801f0a <sys_disable_interrupt>
			cprintf("===============================================\n") ;
  80024b:	83 ec 0c             	sub    $0xc,%esp
  80024e:	68 80 3d 80 00       	push   $0x803d80
  800253:	e8 68 09 00 00       	call   800bc0 <cprintf>
  800258:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  80025b:	83 ec 0c             	sub    $0xc,%esp
  80025e:	68 b4 3d 80 00       	push   $0x803db4
  800263:	e8 58 09 00 00       	call   800bc0 <cprintf>
  800268:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  80026b:	83 ec 0c             	sub    $0xc,%esp
  80026e:	68 e8 3d 80 00       	push   $0x803de8
  800273:	e8 48 09 00 00       	call   800bc0 <cprintf>
  800278:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  80027b:	e8 a4 1c 00 00       	call   801f24 <sys_enable_interrupt>
		}

		//free(Elements) ;

		sys_disable_interrupt();
  800280:	e8 85 1c 00 00       	call   801f0a <sys_disable_interrupt>
		Chose = 0 ;
  800285:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
		while (Chose != 'y' && Chose != 'n')
  800289:	eb 50                	jmp    8002db <_main+0x2a3>
		{
			cprintf("Do you want to repeat (y/n): ") ;
  80028b:	83 ec 0c             	sub    $0xc,%esp
  80028e:	68 1a 3e 80 00       	push   $0x803e1a
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
  8002e7:	e8 38 1c 00 00       	call   801f24 <sys_enable_interrupt>

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
  80047b:	68 60 3c 80 00       	push   $0x803c60
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
  80049d:	68 38 3e 80 00       	push   $0x803e38
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
  8004cb:	68 af 3c 80 00       	push   $0x803caf
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
  800744:	e8 f5 17 00 00       	call   801f3e <sys_cputc>
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
  800755:	e8 b0 17 00 00       	call   801f0a <sys_disable_interrupt>
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
  800768:	e8 d1 17 00 00       	call   801f3e <sys_cputc>
  80076d:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800770:	e8 af 17 00 00       	call   801f24 <sys_enable_interrupt>
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
  800787:	e8 f9 15 00 00       	call   801d85 <sys_cgetc>
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
  8007a0:	e8 65 17 00 00       	call   801f0a <sys_disable_interrupt>
	int c=0;
  8007a5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8007ac:	eb 08                	jmp    8007b6 <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  8007ae:	e8 d2 15 00 00       	call   801d85 <sys_cgetc>
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
  8007bc:	e8 63 17 00 00       	call   801f24 <sys_enable_interrupt>
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
  8007d6:	e8 22 19 00 00       	call   8020fd <sys_getenvindex>
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
  800841:	e8 c4 16 00 00       	call   801f0a <sys_disable_interrupt>
	cprintf("**************************************\n");
  800846:	83 ec 0c             	sub    $0xc,%esp
  800849:	68 58 3e 80 00       	push   $0x803e58
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
  800871:	68 80 3e 80 00       	push   $0x803e80
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
  8008a2:	68 a8 3e 80 00       	push   $0x803ea8
  8008a7:	e8 14 03 00 00       	call   800bc0 <cprintf>
  8008ac:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8008af:	a1 24 50 80 00       	mov    0x805024,%eax
  8008b4:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8008ba:	83 ec 08             	sub    $0x8,%esp
  8008bd:	50                   	push   %eax
  8008be:	68 00 3f 80 00       	push   $0x803f00
  8008c3:	e8 f8 02 00 00       	call   800bc0 <cprintf>
  8008c8:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8008cb:	83 ec 0c             	sub    $0xc,%esp
  8008ce:	68 58 3e 80 00       	push   $0x803e58
  8008d3:	e8 e8 02 00 00       	call   800bc0 <cprintf>
  8008d8:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8008db:	e8 44 16 00 00       	call   801f24 <sys_enable_interrupt>

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
  8008f3:	e8 d1 17 00 00       	call   8020c9 <sys_destroy_env>
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
  800904:	e8 26 18 00 00       	call   80212f <sys_exit_env>
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
  80092d:	68 14 3f 80 00       	push   $0x803f14
  800932:	e8 89 02 00 00       	call   800bc0 <cprintf>
  800937:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80093a:	a1 00 50 80 00       	mov    0x805000,%eax
  80093f:	ff 75 0c             	pushl  0xc(%ebp)
  800942:	ff 75 08             	pushl  0x8(%ebp)
  800945:	50                   	push   %eax
  800946:	68 19 3f 80 00       	push   $0x803f19
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
  80096a:	68 35 3f 80 00       	push   $0x803f35
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
  800996:	68 38 3f 80 00       	push   $0x803f38
  80099b:	6a 26                	push   $0x26
  80099d:	68 84 3f 80 00       	push   $0x803f84
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
  800a68:	68 90 3f 80 00       	push   $0x803f90
  800a6d:	6a 3a                	push   $0x3a
  800a6f:	68 84 3f 80 00       	push   $0x803f84
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
  800ad8:	68 e4 3f 80 00       	push   $0x803fe4
  800add:	6a 44                	push   $0x44
  800adf:	68 84 3f 80 00       	push   $0x803f84
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
  800b32:	e8 25 12 00 00       	call   801d5c <sys_cputs>
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
  800ba9:	e8 ae 11 00 00       	call   801d5c <sys_cputs>
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
  800bf3:	e8 12 13 00 00       	call   801f0a <sys_disable_interrupt>
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
  800c13:	e8 0c 13 00 00       	call   801f24 <sys_enable_interrupt>
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
  800c5d:	e8 7e 2d 00 00       	call   8039e0 <__udivdi3>
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
  800cad:	e8 3e 2e 00 00       	call   803af0 <__umoddi3>
  800cb2:	83 c4 10             	add    $0x10,%esp
  800cb5:	05 54 42 80 00       	add    $0x804254,%eax
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
  800e08:	8b 04 85 78 42 80 00 	mov    0x804278(,%eax,4),%eax
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
  800ee9:	8b 34 9d c0 40 80 00 	mov    0x8040c0(,%ebx,4),%esi
  800ef0:	85 f6                	test   %esi,%esi
  800ef2:	75 19                	jne    800f0d <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ef4:	53                   	push   %ebx
  800ef5:	68 65 42 80 00       	push   $0x804265
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
  800f0e:	68 6e 42 80 00       	push   $0x80426e
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
  800f3b:	be 71 42 80 00       	mov    $0x804271,%esi
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
  801961:	68 d0 43 80 00       	push   $0x8043d0
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
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_USER);
  801a14:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801a1b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a1e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801a23:	2d 00 10 00 00       	sub    $0x1000,%eax
  801a28:	83 ec 04             	sub    $0x4,%esp
  801a2b:	6a 06                	push   $0x6
  801a2d:	ff 75 f4             	pushl  -0xc(%ebp)
  801a30:	50                   	push   %eax
  801a31:	e8 6a 04 00 00       	call   801ea0 <sys_allocate_chunk>
  801a36:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801a39:	a1 20 51 80 00       	mov    0x805120,%eax
  801a3e:	83 ec 0c             	sub    $0xc,%esp
  801a41:	50                   	push   %eax
  801a42:	e8 df 0a 00 00       	call   802526 <initialize_MemBlocksList>
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
  801a6f:	68 f5 43 80 00       	push   $0x8043f5
  801a74:	6a 33                	push   $0x33
  801a76:	68 13 44 80 00       	push   $0x804413
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
  801aee:	68 20 44 80 00       	push   $0x804420
  801af3:	6a 34                	push   $0x34
  801af5:	68 13 44 80 00       	push   $0x804413
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
  801b4b:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801b4e:	e8 f7 fd ff ff       	call   80194a <InitializeUHeap>
	if (size == 0) return NULL ;
  801b53:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b57:	75 07                	jne    801b60 <malloc+0x18>
  801b59:	b8 00 00 00 00       	mov    $0x0,%eax
  801b5e:	eb 61                	jmp    801bc1 <malloc+0x79>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
	uint32 malloc_allocsize=ROUNDUP(size,PAGE_SIZE);
  801b60:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801b67:	8b 55 08             	mov    0x8(%ebp),%edx
  801b6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b6d:	01 d0                	add    %edx,%eax
  801b6f:	48                   	dec    %eax
  801b70:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801b73:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b76:	ba 00 00 00 00       	mov    $0x0,%edx
  801b7b:	f7 75 f0             	divl   -0x10(%ebp)
  801b7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b81:	29 d0                	sub    %edx,%eax
  801b83:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 //int ret=0;
	struct MemBlock * user_block;
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801b86:	e8 e3 06 00 00       	call   80226e <sys_isUHeapPlacementStrategyFIRSTFIT>
  801b8b:	85 c0                	test   %eax,%eax
  801b8d:	74 11                	je     801ba0 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801b8f:	83 ec 0c             	sub    $0xc,%esp
  801b92:	ff 75 e8             	pushl  -0x18(%ebp)
  801b95:	e8 4e 0d 00 00       	call   8028e8 <alloc_block_FF>
  801b9a:	83 c4 10             	add    $0x10,%esp
  801b9d:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(user_block!=NULL)
  801ba0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ba4:	74 16                	je     801bbc <malloc+0x74>
	{
		//sys_allocate_chunk(user_block->sva,malloc_allocsize,PERM_WRITEABLE| PERM_PRESENT);
		insert_sorted_allocList(user_block);
  801ba6:	83 ec 0c             	sub    $0xc,%esp
  801ba9:	ff 75 f4             	pushl  -0xc(%ebp)
  801bac:	e8 aa 0a 00 00       	call   80265b <insert_sorted_allocList>
  801bb1:	83 c4 10             	add    $0x10,%esp
		return (uint32 *)user_block->sva;
  801bb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bb7:	8b 40 08             	mov    0x8(%eax),%eax
  801bba:	eb 05                	jmp    801bc1 <malloc+0x79>
	}

    return NULL;
  801bbc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bc1:	c9                   	leave  
  801bc2:	c3                   	ret    

00801bc3 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801bc3:	55                   	push   %ebp
  801bc4:	89 e5                	mov    %esp,%ebp
  801bc6:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801bc9:	83 ec 04             	sub    $0x4,%esp
  801bcc:	68 44 44 80 00       	push   $0x804444
  801bd1:	6a 6f                	push   $0x6f
  801bd3:	68 13 44 80 00       	push   $0x804413
  801bd8:	e8 2f ed ff ff       	call   80090c <_panic>

00801bdd <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801bdd:	55                   	push   %ebp
  801bde:	89 e5                	mov    %esp,%ebp
  801be0:	83 ec 38             	sub    $0x38,%esp
  801be3:	8b 45 10             	mov    0x10(%ebp),%eax
  801be6:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801be9:	e8 5c fd ff ff       	call   80194a <InitializeUHeap>
	if (size == 0) return NULL ;
  801bee:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801bf2:	75 07                	jne    801bfb <smalloc+0x1e>
  801bf4:	b8 00 00 00 00       	mov    $0x0,%eax
  801bf9:	eb 7c                	jmp    801c77 <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801bfb:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801c02:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c08:	01 d0                	add    %edx,%eax
  801c0a:	48                   	dec    %eax
  801c0b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801c0e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c11:	ba 00 00 00 00       	mov    $0x0,%edx
  801c16:	f7 75 f0             	divl   -0x10(%ebp)
  801c19:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c1c:	29 d0                	sub    %edx,%eax
  801c1e:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801c21:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801c28:	e8 41 06 00 00       	call   80226e <sys_isUHeapPlacementStrategyFIRSTFIT>
  801c2d:	85 c0                	test   %eax,%eax
  801c2f:	74 11                	je     801c42 <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  801c31:	83 ec 0c             	sub    $0xc,%esp
  801c34:	ff 75 e8             	pushl  -0x18(%ebp)
  801c37:	e8 ac 0c 00 00       	call   8028e8 <alloc_block_FF>
  801c3c:	83 c4 10             	add    $0x10,%esp
  801c3f:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  801c42:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c46:	74 2a                	je     801c72 <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801c48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c4b:	8b 40 08             	mov    0x8(%eax),%eax
  801c4e:	89 c2                	mov    %eax,%edx
  801c50:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801c54:	52                   	push   %edx
  801c55:	50                   	push   %eax
  801c56:	ff 75 0c             	pushl  0xc(%ebp)
  801c59:	ff 75 08             	pushl  0x8(%ebp)
  801c5c:	e8 92 03 00 00       	call   801ff3 <sys_createSharedObject>
  801c61:	83 c4 10             	add    $0x10,%esp
  801c64:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  801c67:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  801c6b:	74 05                	je     801c72 <smalloc+0x95>
			return (void*)virtual_address;
  801c6d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c70:	eb 05                	jmp    801c77 <smalloc+0x9a>
	}
	return NULL;
  801c72:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801c77:	c9                   	leave  
  801c78:	c3                   	ret    

00801c79 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801c79:	55                   	push   %ebp
  801c7a:	89 e5                	mov    %esp,%ebp
  801c7c:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801c7f:	e8 c6 fc ff ff       	call   80194a <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801c84:	83 ec 04             	sub    $0x4,%esp
  801c87:	68 68 44 80 00       	push   $0x804468
  801c8c:	68 b0 00 00 00       	push   $0xb0
  801c91:	68 13 44 80 00       	push   $0x804413
  801c96:	e8 71 ec ff ff       	call   80090c <_panic>

00801c9b <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801c9b:	55                   	push   %ebp
  801c9c:	89 e5                	mov    %esp,%ebp
  801c9e:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801ca1:	e8 a4 fc ff ff       	call   80194a <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801ca6:	83 ec 04             	sub    $0x4,%esp
  801ca9:	68 8c 44 80 00       	push   $0x80448c
  801cae:	68 f4 00 00 00       	push   $0xf4
  801cb3:	68 13 44 80 00       	push   $0x804413
  801cb8:	e8 4f ec ff ff       	call   80090c <_panic>

00801cbd <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801cbd:	55                   	push   %ebp
  801cbe:	89 e5                	mov    %esp,%ebp
  801cc0:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801cc3:	83 ec 04             	sub    $0x4,%esp
  801cc6:	68 b4 44 80 00       	push   $0x8044b4
  801ccb:	68 08 01 00 00       	push   $0x108
  801cd0:	68 13 44 80 00       	push   $0x804413
  801cd5:	e8 32 ec ff ff       	call   80090c <_panic>

00801cda <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801cda:	55                   	push   %ebp
  801cdb:	89 e5                	mov    %esp,%ebp
  801cdd:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ce0:	83 ec 04             	sub    $0x4,%esp
  801ce3:	68 d8 44 80 00       	push   $0x8044d8
  801ce8:	68 13 01 00 00       	push   $0x113
  801ced:	68 13 44 80 00       	push   $0x804413
  801cf2:	e8 15 ec ff ff       	call   80090c <_panic>

00801cf7 <shrink>:

}
void shrink(uint32 newSize)
{
  801cf7:	55                   	push   %ebp
  801cf8:	89 e5                	mov    %esp,%ebp
  801cfa:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801cfd:	83 ec 04             	sub    $0x4,%esp
  801d00:	68 d8 44 80 00       	push   $0x8044d8
  801d05:	68 18 01 00 00       	push   $0x118
  801d0a:	68 13 44 80 00       	push   $0x804413
  801d0f:	e8 f8 eb ff ff       	call   80090c <_panic>

00801d14 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801d14:	55                   	push   %ebp
  801d15:	89 e5                	mov    %esp,%ebp
  801d17:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801d1a:	83 ec 04             	sub    $0x4,%esp
  801d1d:	68 d8 44 80 00       	push   $0x8044d8
  801d22:	68 1d 01 00 00       	push   $0x11d
  801d27:	68 13 44 80 00       	push   $0x804413
  801d2c:	e8 db eb ff ff       	call   80090c <_panic>

00801d31 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801d31:	55                   	push   %ebp
  801d32:	89 e5                	mov    %esp,%ebp
  801d34:	57                   	push   %edi
  801d35:	56                   	push   %esi
  801d36:	53                   	push   %ebx
  801d37:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801d3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d40:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d43:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d46:	8b 7d 18             	mov    0x18(%ebp),%edi
  801d49:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801d4c:	cd 30                	int    $0x30
  801d4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801d51:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801d54:	83 c4 10             	add    $0x10,%esp
  801d57:	5b                   	pop    %ebx
  801d58:	5e                   	pop    %esi
  801d59:	5f                   	pop    %edi
  801d5a:	5d                   	pop    %ebp
  801d5b:	c3                   	ret    

00801d5c <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801d5c:	55                   	push   %ebp
  801d5d:	89 e5                	mov    %esp,%ebp
  801d5f:	83 ec 04             	sub    $0x4,%esp
  801d62:	8b 45 10             	mov    0x10(%ebp),%eax
  801d65:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801d68:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6f:	6a 00                	push   $0x0
  801d71:	6a 00                	push   $0x0
  801d73:	52                   	push   %edx
  801d74:	ff 75 0c             	pushl  0xc(%ebp)
  801d77:	50                   	push   %eax
  801d78:	6a 00                	push   $0x0
  801d7a:	e8 b2 ff ff ff       	call   801d31 <syscall>
  801d7f:	83 c4 18             	add    $0x18,%esp
}
  801d82:	90                   	nop
  801d83:	c9                   	leave  
  801d84:	c3                   	ret    

00801d85 <sys_cgetc>:

int
sys_cgetc(void)
{
  801d85:	55                   	push   %ebp
  801d86:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801d88:	6a 00                	push   $0x0
  801d8a:	6a 00                	push   $0x0
  801d8c:	6a 00                	push   $0x0
  801d8e:	6a 00                	push   $0x0
  801d90:	6a 00                	push   $0x0
  801d92:	6a 01                	push   $0x1
  801d94:	e8 98 ff ff ff       	call   801d31 <syscall>
  801d99:	83 c4 18             	add    $0x18,%esp
}
  801d9c:	c9                   	leave  
  801d9d:	c3                   	ret    

00801d9e <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801d9e:	55                   	push   %ebp
  801d9f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801da1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801da4:	8b 45 08             	mov    0x8(%ebp),%eax
  801da7:	6a 00                	push   $0x0
  801da9:	6a 00                	push   $0x0
  801dab:	6a 00                	push   $0x0
  801dad:	52                   	push   %edx
  801dae:	50                   	push   %eax
  801daf:	6a 05                	push   $0x5
  801db1:	e8 7b ff ff ff       	call   801d31 <syscall>
  801db6:	83 c4 18             	add    $0x18,%esp
}
  801db9:	c9                   	leave  
  801dba:	c3                   	ret    

00801dbb <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801dbb:	55                   	push   %ebp
  801dbc:	89 e5                	mov    %esp,%ebp
  801dbe:	56                   	push   %esi
  801dbf:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801dc0:	8b 75 18             	mov    0x18(%ebp),%esi
  801dc3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801dc6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801dc9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  801dcf:	56                   	push   %esi
  801dd0:	53                   	push   %ebx
  801dd1:	51                   	push   %ecx
  801dd2:	52                   	push   %edx
  801dd3:	50                   	push   %eax
  801dd4:	6a 06                	push   $0x6
  801dd6:	e8 56 ff ff ff       	call   801d31 <syscall>
  801ddb:	83 c4 18             	add    $0x18,%esp
}
  801dde:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801de1:	5b                   	pop    %ebx
  801de2:	5e                   	pop    %esi
  801de3:	5d                   	pop    %ebp
  801de4:	c3                   	ret    

00801de5 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801de5:	55                   	push   %ebp
  801de6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801de8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801deb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dee:	6a 00                	push   $0x0
  801df0:	6a 00                	push   $0x0
  801df2:	6a 00                	push   $0x0
  801df4:	52                   	push   %edx
  801df5:	50                   	push   %eax
  801df6:	6a 07                	push   $0x7
  801df8:	e8 34 ff ff ff       	call   801d31 <syscall>
  801dfd:	83 c4 18             	add    $0x18,%esp
}
  801e00:	c9                   	leave  
  801e01:	c3                   	ret    

00801e02 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801e02:	55                   	push   %ebp
  801e03:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801e05:	6a 00                	push   $0x0
  801e07:	6a 00                	push   $0x0
  801e09:	6a 00                	push   $0x0
  801e0b:	ff 75 0c             	pushl  0xc(%ebp)
  801e0e:	ff 75 08             	pushl  0x8(%ebp)
  801e11:	6a 08                	push   $0x8
  801e13:	e8 19 ff ff ff       	call   801d31 <syscall>
  801e18:	83 c4 18             	add    $0x18,%esp
}
  801e1b:	c9                   	leave  
  801e1c:	c3                   	ret    

00801e1d <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801e1d:	55                   	push   %ebp
  801e1e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801e20:	6a 00                	push   $0x0
  801e22:	6a 00                	push   $0x0
  801e24:	6a 00                	push   $0x0
  801e26:	6a 00                	push   $0x0
  801e28:	6a 00                	push   $0x0
  801e2a:	6a 09                	push   $0x9
  801e2c:	e8 00 ff ff ff       	call   801d31 <syscall>
  801e31:	83 c4 18             	add    $0x18,%esp
}
  801e34:	c9                   	leave  
  801e35:	c3                   	ret    

00801e36 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801e36:	55                   	push   %ebp
  801e37:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801e39:	6a 00                	push   $0x0
  801e3b:	6a 00                	push   $0x0
  801e3d:	6a 00                	push   $0x0
  801e3f:	6a 00                	push   $0x0
  801e41:	6a 00                	push   $0x0
  801e43:	6a 0a                	push   $0xa
  801e45:	e8 e7 fe ff ff       	call   801d31 <syscall>
  801e4a:	83 c4 18             	add    $0x18,%esp
}
  801e4d:	c9                   	leave  
  801e4e:	c3                   	ret    

00801e4f <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801e4f:	55                   	push   %ebp
  801e50:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801e52:	6a 00                	push   $0x0
  801e54:	6a 00                	push   $0x0
  801e56:	6a 00                	push   $0x0
  801e58:	6a 00                	push   $0x0
  801e5a:	6a 00                	push   $0x0
  801e5c:	6a 0b                	push   $0xb
  801e5e:	e8 ce fe ff ff       	call   801d31 <syscall>
  801e63:	83 c4 18             	add    $0x18,%esp
}
  801e66:	c9                   	leave  
  801e67:	c3                   	ret    

00801e68 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801e68:	55                   	push   %ebp
  801e69:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801e6b:	6a 00                	push   $0x0
  801e6d:	6a 00                	push   $0x0
  801e6f:	6a 00                	push   $0x0
  801e71:	ff 75 0c             	pushl  0xc(%ebp)
  801e74:	ff 75 08             	pushl  0x8(%ebp)
  801e77:	6a 0f                	push   $0xf
  801e79:	e8 b3 fe ff ff       	call   801d31 <syscall>
  801e7e:	83 c4 18             	add    $0x18,%esp
	return;
  801e81:	90                   	nop
}
  801e82:	c9                   	leave  
  801e83:	c3                   	ret    

00801e84 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801e84:	55                   	push   %ebp
  801e85:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801e87:	6a 00                	push   $0x0
  801e89:	6a 00                	push   $0x0
  801e8b:	6a 00                	push   $0x0
  801e8d:	ff 75 0c             	pushl  0xc(%ebp)
  801e90:	ff 75 08             	pushl  0x8(%ebp)
  801e93:	6a 10                	push   $0x10
  801e95:	e8 97 fe ff ff       	call   801d31 <syscall>
  801e9a:	83 c4 18             	add    $0x18,%esp
	return ;
  801e9d:	90                   	nop
}
  801e9e:	c9                   	leave  
  801e9f:	c3                   	ret    

00801ea0 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801ea0:	55                   	push   %ebp
  801ea1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801ea3:	6a 00                	push   $0x0
  801ea5:	6a 00                	push   $0x0
  801ea7:	ff 75 10             	pushl  0x10(%ebp)
  801eaa:	ff 75 0c             	pushl  0xc(%ebp)
  801ead:	ff 75 08             	pushl  0x8(%ebp)
  801eb0:	6a 11                	push   $0x11
  801eb2:	e8 7a fe ff ff       	call   801d31 <syscall>
  801eb7:	83 c4 18             	add    $0x18,%esp
	return ;
  801eba:	90                   	nop
}
  801ebb:	c9                   	leave  
  801ebc:	c3                   	ret    

00801ebd <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801ebd:	55                   	push   %ebp
  801ebe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801ec0:	6a 00                	push   $0x0
  801ec2:	6a 00                	push   $0x0
  801ec4:	6a 00                	push   $0x0
  801ec6:	6a 00                	push   $0x0
  801ec8:	6a 00                	push   $0x0
  801eca:	6a 0c                	push   $0xc
  801ecc:	e8 60 fe ff ff       	call   801d31 <syscall>
  801ed1:	83 c4 18             	add    $0x18,%esp
}
  801ed4:	c9                   	leave  
  801ed5:	c3                   	ret    

00801ed6 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801ed6:	55                   	push   %ebp
  801ed7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801ed9:	6a 00                	push   $0x0
  801edb:	6a 00                	push   $0x0
  801edd:	6a 00                	push   $0x0
  801edf:	6a 00                	push   $0x0
  801ee1:	ff 75 08             	pushl  0x8(%ebp)
  801ee4:	6a 0d                	push   $0xd
  801ee6:	e8 46 fe ff ff       	call   801d31 <syscall>
  801eeb:	83 c4 18             	add    $0x18,%esp
}
  801eee:	c9                   	leave  
  801eef:	c3                   	ret    

00801ef0 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801ef0:	55                   	push   %ebp
  801ef1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801ef3:	6a 00                	push   $0x0
  801ef5:	6a 00                	push   $0x0
  801ef7:	6a 00                	push   $0x0
  801ef9:	6a 00                	push   $0x0
  801efb:	6a 00                	push   $0x0
  801efd:	6a 0e                	push   $0xe
  801eff:	e8 2d fe ff ff       	call   801d31 <syscall>
  801f04:	83 c4 18             	add    $0x18,%esp
}
  801f07:	90                   	nop
  801f08:	c9                   	leave  
  801f09:	c3                   	ret    

00801f0a <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801f0a:	55                   	push   %ebp
  801f0b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801f0d:	6a 00                	push   $0x0
  801f0f:	6a 00                	push   $0x0
  801f11:	6a 00                	push   $0x0
  801f13:	6a 00                	push   $0x0
  801f15:	6a 00                	push   $0x0
  801f17:	6a 13                	push   $0x13
  801f19:	e8 13 fe ff ff       	call   801d31 <syscall>
  801f1e:	83 c4 18             	add    $0x18,%esp
}
  801f21:	90                   	nop
  801f22:	c9                   	leave  
  801f23:	c3                   	ret    

00801f24 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801f24:	55                   	push   %ebp
  801f25:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801f27:	6a 00                	push   $0x0
  801f29:	6a 00                	push   $0x0
  801f2b:	6a 00                	push   $0x0
  801f2d:	6a 00                	push   $0x0
  801f2f:	6a 00                	push   $0x0
  801f31:	6a 14                	push   $0x14
  801f33:	e8 f9 fd ff ff       	call   801d31 <syscall>
  801f38:	83 c4 18             	add    $0x18,%esp
}
  801f3b:	90                   	nop
  801f3c:	c9                   	leave  
  801f3d:	c3                   	ret    

00801f3e <sys_cputc>:


void
sys_cputc(const char c)
{
  801f3e:	55                   	push   %ebp
  801f3f:	89 e5                	mov    %esp,%ebp
  801f41:	83 ec 04             	sub    $0x4,%esp
  801f44:	8b 45 08             	mov    0x8(%ebp),%eax
  801f47:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801f4a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f4e:	6a 00                	push   $0x0
  801f50:	6a 00                	push   $0x0
  801f52:	6a 00                	push   $0x0
  801f54:	6a 00                	push   $0x0
  801f56:	50                   	push   %eax
  801f57:	6a 15                	push   $0x15
  801f59:	e8 d3 fd ff ff       	call   801d31 <syscall>
  801f5e:	83 c4 18             	add    $0x18,%esp
}
  801f61:	90                   	nop
  801f62:	c9                   	leave  
  801f63:	c3                   	ret    

00801f64 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801f64:	55                   	push   %ebp
  801f65:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801f67:	6a 00                	push   $0x0
  801f69:	6a 00                	push   $0x0
  801f6b:	6a 00                	push   $0x0
  801f6d:	6a 00                	push   $0x0
  801f6f:	6a 00                	push   $0x0
  801f71:	6a 16                	push   $0x16
  801f73:	e8 b9 fd ff ff       	call   801d31 <syscall>
  801f78:	83 c4 18             	add    $0x18,%esp
}
  801f7b:	90                   	nop
  801f7c:	c9                   	leave  
  801f7d:	c3                   	ret    

00801f7e <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801f7e:	55                   	push   %ebp
  801f7f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801f81:	8b 45 08             	mov    0x8(%ebp),%eax
  801f84:	6a 00                	push   $0x0
  801f86:	6a 00                	push   $0x0
  801f88:	6a 00                	push   $0x0
  801f8a:	ff 75 0c             	pushl  0xc(%ebp)
  801f8d:	50                   	push   %eax
  801f8e:	6a 17                	push   $0x17
  801f90:	e8 9c fd ff ff       	call   801d31 <syscall>
  801f95:	83 c4 18             	add    $0x18,%esp
}
  801f98:	c9                   	leave  
  801f99:	c3                   	ret    

00801f9a <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801f9a:	55                   	push   %ebp
  801f9b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f9d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa3:	6a 00                	push   $0x0
  801fa5:	6a 00                	push   $0x0
  801fa7:	6a 00                	push   $0x0
  801fa9:	52                   	push   %edx
  801faa:	50                   	push   %eax
  801fab:	6a 1a                	push   $0x1a
  801fad:	e8 7f fd ff ff       	call   801d31 <syscall>
  801fb2:	83 c4 18             	add    $0x18,%esp
}
  801fb5:	c9                   	leave  
  801fb6:	c3                   	ret    

00801fb7 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801fb7:	55                   	push   %ebp
  801fb8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801fba:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fbd:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc0:	6a 00                	push   $0x0
  801fc2:	6a 00                	push   $0x0
  801fc4:	6a 00                	push   $0x0
  801fc6:	52                   	push   %edx
  801fc7:	50                   	push   %eax
  801fc8:	6a 18                	push   $0x18
  801fca:	e8 62 fd ff ff       	call   801d31 <syscall>
  801fcf:	83 c4 18             	add    $0x18,%esp
}
  801fd2:	90                   	nop
  801fd3:	c9                   	leave  
  801fd4:	c3                   	ret    

00801fd5 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801fd5:	55                   	push   %ebp
  801fd6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801fd8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fde:	6a 00                	push   $0x0
  801fe0:	6a 00                	push   $0x0
  801fe2:	6a 00                	push   $0x0
  801fe4:	52                   	push   %edx
  801fe5:	50                   	push   %eax
  801fe6:	6a 19                	push   $0x19
  801fe8:	e8 44 fd ff ff       	call   801d31 <syscall>
  801fed:	83 c4 18             	add    $0x18,%esp
}
  801ff0:	90                   	nop
  801ff1:	c9                   	leave  
  801ff2:	c3                   	ret    

00801ff3 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801ff3:	55                   	push   %ebp
  801ff4:	89 e5                	mov    %esp,%ebp
  801ff6:	83 ec 04             	sub    $0x4,%esp
  801ff9:	8b 45 10             	mov    0x10(%ebp),%eax
  801ffc:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801fff:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802002:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802006:	8b 45 08             	mov    0x8(%ebp),%eax
  802009:	6a 00                	push   $0x0
  80200b:	51                   	push   %ecx
  80200c:	52                   	push   %edx
  80200d:	ff 75 0c             	pushl  0xc(%ebp)
  802010:	50                   	push   %eax
  802011:	6a 1b                	push   $0x1b
  802013:	e8 19 fd ff ff       	call   801d31 <syscall>
  802018:	83 c4 18             	add    $0x18,%esp
}
  80201b:	c9                   	leave  
  80201c:	c3                   	ret    

0080201d <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80201d:	55                   	push   %ebp
  80201e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802020:	8b 55 0c             	mov    0xc(%ebp),%edx
  802023:	8b 45 08             	mov    0x8(%ebp),%eax
  802026:	6a 00                	push   $0x0
  802028:	6a 00                	push   $0x0
  80202a:	6a 00                	push   $0x0
  80202c:	52                   	push   %edx
  80202d:	50                   	push   %eax
  80202e:	6a 1c                	push   $0x1c
  802030:	e8 fc fc ff ff       	call   801d31 <syscall>
  802035:	83 c4 18             	add    $0x18,%esp
}
  802038:	c9                   	leave  
  802039:	c3                   	ret    

0080203a <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80203a:	55                   	push   %ebp
  80203b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80203d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802040:	8b 55 0c             	mov    0xc(%ebp),%edx
  802043:	8b 45 08             	mov    0x8(%ebp),%eax
  802046:	6a 00                	push   $0x0
  802048:	6a 00                	push   $0x0
  80204a:	51                   	push   %ecx
  80204b:	52                   	push   %edx
  80204c:	50                   	push   %eax
  80204d:	6a 1d                	push   $0x1d
  80204f:	e8 dd fc ff ff       	call   801d31 <syscall>
  802054:	83 c4 18             	add    $0x18,%esp
}
  802057:	c9                   	leave  
  802058:	c3                   	ret    

00802059 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802059:	55                   	push   %ebp
  80205a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80205c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80205f:	8b 45 08             	mov    0x8(%ebp),%eax
  802062:	6a 00                	push   $0x0
  802064:	6a 00                	push   $0x0
  802066:	6a 00                	push   $0x0
  802068:	52                   	push   %edx
  802069:	50                   	push   %eax
  80206a:	6a 1e                	push   $0x1e
  80206c:	e8 c0 fc ff ff       	call   801d31 <syscall>
  802071:	83 c4 18             	add    $0x18,%esp
}
  802074:	c9                   	leave  
  802075:	c3                   	ret    

00802076 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802076:	55                   	push   %ebp
  802077:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802079:	6a 00                	push   $0x0
  80207b:	6a 00                	push   $0x0
  80207d:	6a 00                	push   $0x0
  80207f:	6a 00                	push   $0x0
  802081:	6a 00                	push   $0x0
  802083:	6a 1f                	push   $0x1f
  802085:	e8 a7 fc ff ff       	call   801d31 <syscall>
  80208a:	83 c4 18             	add    $0x18,%esp
}
  80208d:	c9                   	leave  
  80208e:	c3                   	ret    

0080208f <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80208f:	55                   	push   %ebp
  802090:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802092:	8b 45 08             	mov    0x8(%ebp),%eax
  802095:	6a 00                	push   $0x0
  802097:	ff 75 14             	pushl  0x14(%ebp)
  80209a:	ff 75 10             	pushl  0x10(%ebp)
  80209d:	ff 75 0c             	pushl  0xc(%ebp)
  8020a0:	50                   	push   %eax
  8020a1:	6a 20                	push   $0x20
  8020a3:	e8 89 fc ff ff       	call   801d31 <syscall>
  8020a8:	83 c4 18             	add    $0x18,%esp
}
  8020ab:	c9                   	leave  
  8020ac:	c3                   	ret    

008020ad <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8020ad:	55                   	push   %ebp
  8020ae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8020b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b3:	6a 00                	push   $0x0
  8020b5:	6a 00                	push   $0x0
  8020b7:	6a 00                	push   $0x0
  8020b9:	6a 00                	push   $0x0
  8020bb:	50                   	push   %eax
  8020bc:	6a 21                	push   $0x21
  8020be:	e8 6e fc ff ff       	call   801d31 <syscall>
  8020c3:	83 c4 18             	add    $0x18,%esp
}
  8020c6:	90                   	nop
  8020c7:	c9                   	leave  
  8020c8:	c3                   	ret    

008020c9 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8020c9:	55                   	push   %ebp
  8020ca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8020cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8020cf:	6a 00                	push   $0x0
  8020d1:	6a 00                	push   $0x0
  8020d3:	6a 00                	push   $0x0
  8020d5:	6a 00                	push   $0x0
  8020d7:	50                   	push   %eax
  8020d8:	6a 22                	push   $0x22
  8020da:	e8 52 fc ff ff       	call   801d31 <syscall>
  8020df:	83 c4 18             	add    $0x18,%esp
}
  8020e2:	c9                   	leave  
  8020e3:	c3                   	ret    

008020e4 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8020e4:	55                   	push   %ebp
  8020e5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8020e7:	6a 00                	push   $0x0
  8020e9:	6a 00                	push   $0x0
  8020eb:	6a 00                	push   $0x0
  8020ed:	6a 00                	push   $0x0
  8020ef:	6a 00                	push   $0x0
  8020f1:	6a 02                	push   $0x2
  8020f3:	e8 39 fc ff ff       	call   801d31 <syscall>
  8020f8:	83 c4 18             	add    $0x18,%esp
}
  8020fb:	c9                   	leave  
  8020fc:	c3                   	ret    

008020fd <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8020fd:	55                   	push   %ebp
  8020fe:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802100:	6a 00                	push   $0x0
  802102:	6a 00                	push   $0x0
  802104:	6a 00                	push   $0x0
  802106:	6a 00                	push   $0x0
  802108:	6a 00                	push   $0x0
  80210a:	6a 03                	push   $0x3
  80210c:	e8 20 fc ff ff       	call   801d31 <syscall>
  802111:	83 c4 18             	add    $0x18,%esp
}
  802114:	c9                   	leave  
  802115:	c3                   	ret    

00802116 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802116:	55                   	push   %ebp
  802117:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802119:	6a 00                	push   $0x0
  80211b:	6a 00                	push   $0x0
  80211d:	6a 00                	push   $0x0
  80211f:	6a 00                	push   $0x0
  802121:	6a 00                	push   $0x0
  802123:	6a 04                	push   $0x4
  802125:	e8 07 fc ff ff       	call   801d31 <syscall>
  80212a:	83 c4 18             	add    $0x18,%esp
}
  80212d:	c9                   	leave  
  80212e:	c3                   	ret    

0080212f <sys_exit_env>:


void sys_exit_env(void)
{
  80212f:	55                   	push   %ebp
  802130:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802132:	6a 00                	push   $0x0
  802134:	6a 00                	push   $0x0
  802136:	6a 00                	push   $0x0
  802138:	6a 00                	push   $0x0
  80213a:	6a 00                	push   $0x0
  80213c:	6a 23                	push   $0x23
  80213e:	e8 ee fb ff ff       	call   801d31 <syscall>
  802143:	83 c4 18             	add    $0x18,%esp
}
  802146:	90                   	nop
  802147:	c9                   	leave  
  802148:	c3                   	ret    

00802149 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802149:	55                   	push   %ebp
  80214a:	89 e5                	mov    %esp,%ebp
  80214c:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80214f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802152:	8d 50 04             	lea    0x4(%eax),%edx
  802155:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802158:	6a 00                	push   $0x0
  80215a:	6a 00                	push   $0x0
  80215c:	6a 00                	push   $0x0
  80215e:	52                   	push   %edx
  80215f:	50                   	push   %eax
  802160:	6a 24                	push   $0x24
  802162:	e8 ca fb ff ff       	call   801d31 <syscall>
  802167:	83 c4 18             	add    $0x18,%esp
	return result;
  80216a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80216d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802170:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802173:	89 01                	mov    %eax,(%ecx)
  802175:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802178:	8b 45 08             	mov    0x8(%ebp),%eax
  80217b:	c9                   	leave  
  80217c:	c2 04 00             	ret    $0x4

0080217f <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80217f:	55                   	push   %ebp
  802180:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802182:	6a 00                	push   $0x0
  802184:	6a 00                	push   $0x0
  802186:	ff 75 10             	pushl  0x10(%ebp)
  802189:	ff 75 0c             	pushl  0xc(%ebp)
  80218c:	ff 75 08             	pushl  0x8(%ebp)
  80218f:	6a 12                	push   $0x12
  802191:	e8 9b fb ff ff       	call   801d31 <syscall>
  802196:	83 c4 18             	add    $0x18,%esp
	return ;
  802199:	90                   	nop
}
  80219a:	c9                   	leave  
  80219b:	c3                   	ret    

0080219c <sys_rcr2>:
uint32 sys_rcr2()
{
  80219c:	55                   	push   %ebp
  80219d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80219f:	6a 00                	push   $0x0
  8021a1:	6a 00                	push   $0x0
  8021a3:	6a 00                	push   $0x0
  8021a5:	6a 00                	push   $0x0
  8021a7:	6a 00                	push   $0x0
  8021a9:	6a 25                	push   $0x25
  8021ab:	e8 81 fb ff ff       	call   801d31 <syscall>
  8021b0:	83 c4 18             	add    $0x18,%esp
}
  8021b3:	c9                   	leave  
  8021b4:	c3                   	ret    

008021b5 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8021b5:	55                   	push   %ebp
  8021b6:	89 e5                	mov    %esp,%ebp
  8021b8:	83 ec 04             	sub    $0x4,%esp
  8021bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021be:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8021c1:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8021c5:	6a 00                	push   $0x0
  8021c7:	6a 00                	push   $0x0
  8021c9:	6a 00                	push   $0x0
  8021cb:	6a 00                	push   $0x0
  8021cd:	50                   	push   %eax
  8021ce:	6a 26                	push   $0x26
  8021d0:	e8 5c fb ff ff       	call   801d31 <syscall>
  8021d5:	83 c4 18             	add    $0x18,%esp
	return ;
  8021d8:	90                   	nop
}
  8021d9:	c9                   	leave  
  8021da:	c3                   	ret    

008021db <rsttst>:
void rsttst()
{
  8021db:	55                   	push   %ebp
  8021dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8021de:	6a 00                	push   $0x0
  8021e0:	6a 00                	push   $0x0
  8021e2:	6a 00                	push   $0x0
  8021e4:	6a 00                	push   $0x0
  8021e6:	6a 00                	push   $0x0
  8021e8:	6a 28                	push   $0x28
  8021ea:	e8 42 fb ff ff       	call   801d31 <syscall>
  8021ef:	83 c4 18             	add    $0x18,%esp
	return ;
  8021f2:	90                   	nop
}
  8021f3:	c9                   	leave  
  8021f4:	c3                   	ret    

008021f5 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8021f5:	55                   	push   %ebp
  8021f6:	89 e5                	mov    %esp,%ebp
  8021f8:	83 ec 04             	sub    $0x4,%esp
  8021fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8021fe:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802201:	8b 55 18             	mov    0x18(%ebp),%edx
  802204:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802208:	52                   	push   %edx
  802209:	50                   	push   %eax
  80220a:	ff 75 10             	pushl  0x10(%ebp)
  80220d:	ff 75 0c             	pushl  0xc(%ebp)
  802210:	ff 75 08             	pushl  0x8(%ebp)
  802213:	6a 27                	push   $0x27
  802215:	e8 17 fb ff ff       	call   801d31 <syscall>
  80221a:	83 c4 18             	add    $0x18,%esp
	return ;
  80221d:	90                   	nop
}
  80221e:	c9                   	leave  
  80221f:	c3                   	ret    

00802220 <chktst>:
void chktst(uint32 n)
{
  802220:	55                   	push   %ebp
  802221:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802223:	6a 00                	push   $0x0
  802225:	6a 00                	push   $0x0
  802227:	6a 00                	push   $0x0
  802229:	6a 00                	push   $0x0
  80222b:	ff 75 08             	pushl  0x8(%ebp)
  80222e:	6a 29                	push   $0x29
  802230:	e8 fc fa ff ff       	call   801d31 <syscall>
  802235:	83 c4 18             	add    $0x18,%esp
	return ;
  802238:	90                   	nop
}
  802239:	c9                   	leave  
  80223a:	c3                   	ret    

0080223b <inctst>:

void inctst()
{
  80223b:	55                   	push   %ebp
  80223c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80223e:	6a 00                	push   $0x0
  802240:	6a 00                	push   $0x0
  802242:	6a 00                	push   $0x0
  802244:	6a 00                	push   $0x0
  802246:	6a 00                	push   $0x0
  802248:	6a 2a                	push   $0x2a
  80224a:	e8 e2 fa ff ff       	call   801d31 <syscall>
  80224f:	83 c4 18             	add    $0x18,%esp
	return ;
  802252:	90                   	nop
}
  802253:	c9                   	leave  
  802254:	c3                   	ret    

00802255 <gettst>:
uint32 gettst()
{
  802255:	55                   	push   %ebp
  802256:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802258:	6a 00                	push   $0x0
  80225a:	6a 00                	push   $0x0
  80225c:	6a 00                	push   $0x0
  80225e:	6a 00                	push   $0x0
  802260:	6a 00                	push   $0x0
  802262:	6a 2b                	push   $0x2b
  802264:	e8 c8 fa ff ff       	call   801d31 <syscall>
  802269:	83 c4 18             	add    $0x18,%esp
}
  80226c:	c9                   	leave  
  80226d:	c3                   	ret    

0080226e <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80226e:	55                   	push   %ebp
  80226f:	89 e5                	mov    %esp,%ebp
  802271:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802274:	6a 00                	push   $0x0
  802276:	6a 00                	push   $0x0
  802278:	6a 00                	push   $0x0
  80227a:	6a 00                	push   $0x0
  80227c:	6a 00                	push   $0x0
  80227e:	6a 2c                	push   $0x2c
  802280:	e8 ac fa ff ff       	call   801d31 <syscall>
  802285:	83 c4 18             	add    $0x18,%esp
  802288:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80228b:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80228f:	75 07                	jne    802298 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802291:	b8 01 00 00 00       	mov    $0x1,%eax
  802296:	eb 05                	jmp    80229d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802298:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80229d:	c9                   	leave  
  80229e:	c3                   	ret    

0080229f <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80229f:	55                   	push   %ebp
  8022a0:	89 e5                	mov    %esp,%ebp
  8022a2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8022a5:	6a 00                	push   $0x0
  8022a7:	6a 00                	push   $0x0
  8022a9:	6a 00                	push   $0x0
  8022ab:	6a 00                	push   $0x0
  8022ad:	6a 00                	push   $0x0
  8022af:	6a 2c                	push   $0x2c
  8022b1:	e8 7b fa ff ff       	call   801d31 <syscall>
  8022b6:	83 c4 18             	add    $0x18,%esp
  8022b9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8022bc:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8022c0:	75 07                	jne    8022c9 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8022c2:	b8 01 00 00 00       	mov    $0x1,%eax
  8022c7:	eb 05                	jmp    8022ce <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8022c9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022ce:	c9                   	leave  
  8022cf:	c3                   	ret    

008022d0 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8022d0:	55                   	push   %ebp
  8022d1:	89 e5                	mov    %esp,%ebp
  8022d3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8022d6:	6a 00                	push   $0x0
  8022d8:	6a 00                	push   $0x0
  8022da:	6a 00                	push   $0x0
  8022dc:	6a 00                	push   $0x0
  8022de:	6a 00                	push   $0x0
  8022e0:	6a 2c                	push   $0x2c
  8022e2:	e8 4a fa ff ff       	call   801d31 <syscall>
  8022e7:	83 c4 18             	add    $0x18,%esp
  8022ea:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8022ed:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8022f1:	75 07                	jne    8022fa <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8022f3:	b8 01 00 00 00       	mov    $0x1,%eax
  8022f8:	eb 05                	jmp    8022ff <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8022fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022ff:	c9                   	leave  
  802300:	c3                   	ret    

00802301 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802301:	55                   	push   %ebp
  802302:	89 e5                	mov    %esp,%ebp
  802304:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802307:	6a 00                	push   $0x0
  802309:	6a 00                	push   $0x0
  80230b:	6a 00                	push   $0x0
  80230d:	6a 00                	push   $0x0
  80230f:	6a 00                	push   $0x0
  802311:	6a 2c                	push   $0x2c
  802313:	e8 19 fa ff ff       	call   801d31 <syscall>
  802318:	83 c4 18             	add    $0x18,%esp
  80231b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80231e:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802322:	75 07                	jne    80232b <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802324:	b8 01 00 00 00       	mov    $0x1,%eax
  802329:	eb 05                	jmp    802330 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80232b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802330:	c9                   	leave  
  802331:	c3                   	ret    

00802332 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802332:	55                   	push   %ebp
  802333:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802335:	6a 00                	push   $0x0
  802337:	6a 00                	push   $0x0
  802339:	6a 00                	push   $0x0
  80233b:	6a 00                	push   $0x0
  80233d:	ff 75 08             	pushl  0x8(%ebp)
  802340:	6a 2d                	push   $0x2d
  802342:	e8 ea f9 ff ff       	call   801d31 <syscall>
  802347:	83 c4 18             	add    $0x18,%esp
	return ;
  80234a:	90                   	nop
}
  80234b:	c9                   	leave  
  80234c:	c3                   	ret    

0080234d <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80234d:	55                   	push   %ebp
  80234e:	89 e5                	mov    %esp,%ebp
  802350:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802351:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802354:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802357:	8b 55 0c             	mov    0xc(%ebp),%edx
  80235a:	8b 45 08             	mov    0x8(%ebp),%eax
  80235d:	6a 00                	push   $0x0
  80235f:	53                   	push   %ebx
  802360:	51                   	push   %ecx
  802361:	52                   	push   %edx
  802362:	50                   	push   %eax
  802363:	6a 2e                	push   $0x2e
  802365:	e8 c7 f9 ff ff       	call   801d31 <syscall>
  80236a:	83 c4 18             	add    $0x18,%esp
}
  80236d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802370:	c9                   	leave  
  802371:	c3                   	ret    

00802372 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802372:	55                   	push   %ebp
  802373:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802375:	8b 55 0c             	mov    0xc(%ebp),%edx
  802378:	8b 45 08             	mov    0x8(%ebp),%eax
  80237b:	6a 00                	push   $0x0
  80237d:	6a 00                	push   $0x0
  80237f:	6a 00                	push   $0x0
  802381:	52                   	push   %edx
  802382:	50                   	push   %eax
  802383:	6a 2f                	push   $0x2f
  802385:	e8 a7 f9 ff ff       	call   801d31 <syscall>
  80238a:	83 c4 18             	add    $0x18,%esp
}
  80238d:	c9                   	leave  
  80238e:	c3                   	ret    

0080238f <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  80238f:	55                   	push   %ebp
  802390:	89 e5                	mov    %esp,%ebp
  802392:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802395:	83 ec 0c             	sub    $0xc,%esp
  802398:	68 e8 44 80 00       	push   $0x8044e8
  80239d:	e8 1e e8 ff ff       	call   800bc0 <cprintf>
  8023a2:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8023a5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8023ac:	83 ec 0c             	sub    $0xc,%esp
  8023af:	68 14 45 80 00       	push   $0x804514
  8023b4:	e8 07 e8 ff ff       	call   800bc0 <cprintf>
  8023b9:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8023bc:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8023c0:	a1 38 51 80 00       	mov    0x805138,%eax
  8023c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023c8:	eb 56                	jmp    802420 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8023ca:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023ce:	74 1c                	je     8023ec <print_mem_block_lists+0x5d>
  8023d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d3:	8b 50 08             	mov    0x8(%eax),%edx
  8023d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023d9:	8b 48 08             	mov    0x8(%eax),%ecx
  8023dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023df:	8b 40 0c             	mov    0xc(%eax),%eax
  8023e2:	01 c8                	add    %ecx,%eax
  8023e4:	39 c2                	cmp    %eax,%edx
  8023e6:	73 04                	jae    8023ec <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8023e8:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8023ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ef:	8b 50 08             	mov    0x8(%eax),%edx
  8023f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f5:	8b 40 0c             	mov    0xc(%eax),%eax
  8023f8:	01 c2                	add    %eax,%edx
  8023fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fd:	8b 40 08             	mov    0x8(%eax),%eax
  802400:	83 ec 04             	sub    $0x4,%esp
  802403:	52                   	push   %edx
  802404:	50                   	push   %eax
  802405:	68 29 45 80 00       	push   $0x804529
  80240a:	e8 b1 e7 ff ff       	call   800bc0 <cprintf>
  80240f:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802412:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802415:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802418:	a1 40 51 80 00       	mov    0x805140,%eax
  80241d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802420:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802424:	74 07                	je     80242d <print_mem_block_lists+0x9e>
  802426:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802429:	8b 00                	mov    (%eax),%eax
  80242b:	eb 05                	jmp    802432 <print_mem_block_lists+0xa3>
  80242d:	b8 00 00 00 00       	mov    $0x0,%eax
  802432:	a3 40 51 80 00       	mov    %eax,0x805140
  802437:	a1 40 51 80 00       	mov    0x805140,%eax
  80243c:	85 c0                	test   %eax,%eax
  80243e:	75 8a                	jne    8023ca <print_mem_block_lists+0x3b>
  802440:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802444:	75 84                	jne    8023ca <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802446:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80244a:	75 10                	jne    80245c <print_mem_block_lists+0xcd>
  80244c:	83 ec 0c             	sub    $0xc,%esp
  80244f:	68 38 45 80 00       	push   $0x804538
  802454:	e8 67 e7 ff ff       	call   800bc0 <cprintf>
  802459:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80245c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802463:	83 ec 0c             	sub    $0xc,%esp
  802466:	68 5c 45 80 00       	push   $0x80455c
  80246b:	e8 50 e7 ff ff       	call   800bc0 <cprintf>
  802470:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802473:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802477:	a1 40 50 80 00       	mov    0x805040,%eax
  80247c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80247f:	eb 56                	jmp    8024d7 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802481:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802485:	74 1c                	je     8024a3 <print_mem_block_lists+0x114>
  802487:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248a:	8b 50 08             	mov    0x8(%eax),%edx
  80248d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802490:	8b 48 08             	mov    0x8(%eax),%ecx
  802493:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802496:	8b 40 0c             	mov    0xc(%eax),%eax
  802499:	01 c8                	add    %ecx,%eax
  80249b:	39 c2                	cmp    %eax,%edx
  80249d:	73 04                	jae    8024a3 <print_mem_block_lists+0x114>
			sorted = 0 ;
  80249f:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8024a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a6:	8b 50 08             	mov    0x8(%eax),%edx
  8024a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ac:	8b 40 0c             	mov    0xc(%eax),%eax
  8024af:	01 c2                	add    %eax,%edx
  8024b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b4:	8b 40 08             	mov    0x8(%eax),%eax
  8024b7:	83 ec 04             	sub    $0x4,%esp
  8024ba:	52                   	push   %edx
  8024bb:	50                   	push   %eax
  8024bc:	68 29 45 80 00       	push   $0x804529
  8024c1:	e8 fa e6 ff ff       	call   800bc0 <cprintf>
  8024c6:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8024c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8024cf:	a1 48 50 80 00       	mov    0x805048,%eax
  8024d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024db:	74 07                	je     8024e4 <print_mem_block_lists+0x155>
  8024dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e0:	8b 00                	mov    (%eax),%eax
  8024e2:	eb 05                	jmp    8024e9 <print_mem_block_lists+0x15a>
  8024e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8024e9:	a3 48 50 80 00       	mov    %eax,0x805048
  8024ee:	a1 48 50 80 00       	mov    0x805048,%eax
  8024f3:	85 c0                	test   %eax,%eax
  8024f5:	75 8a                	jne    802481 <print_mem_block_lists+0xf2>
  8024f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024fb:	75 84                	jne    802481 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8024fd:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802501:	75 10                	jne    802513 <print_mem_block_lists+0x184>
  802503:	83 ec 0c             	sub    $0xc,%esp
  802506:	68 74 45 80 00       	push   $0x804574
  80250b:	e8 b0 e6 ff ff       	call   800bc0 <cprintf>
  802510:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802513:	83 ec 0c             	sub    $0xc,%esp
  802516:	68 e8 44 80 00       	push   $0x8044e8
  80251b:	e8 a0 e6 ff ff       	call   800bc0 <cprintf>
  802520:	83 c4 10             	add    $0x10,%esp

}
  802523:	90                   	nop
  802524:	c9                   	leave  
  802525:	c3                   	ret    

00802526 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802526:	55                   	push   %ebp
  802527:	89 e5                	mov    %esp,%ebp
  802529:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  80252c:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802533:	00 00 00 
  802536:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80253d:	00 00 00 
  802540:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802547:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  80254a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802551:	e9 9e 00 00 00       	jmp    8025f4 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802556:	a1 50 50 80 00       	mov    0x805050,%eax
  80255b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80255e:	c1 e2 04             	shl    $0x4,%edx
  802561:	01 d0                	add    %edx,%eax
  802563:	85 c0                	test   %eax,%eax
  802565:	75 14                	jne    80257b <initialize_MemBlocksList+0x55>
  802567:	83 ec 04             	sub    $0x4,%esp
  80256a:	68 9c 45 80 00       	push   $0x80459c
  80256f:	6a 46                	push   $0x46
  802571:	68 bf 45 80 00       	push   $0x8045bf
  802576:	e8 91 e3 ff ff       	call   80090c <_panic>
  80257b:	a1 50 50 80 00       	mov    0x805050,%eax
  802580:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802583:	c1 e2 04             	shl    $0x4,%edx
  802586:	01 d0                	add    %edx,%eax
  802588:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80258e:	89 10                	mov    %edx,(%eax)
  802590:	8b 00                	mov    (%eax),%eax
  802592:	85 c0                	test   %eax,%eax
  802594:	74 18                	je     8025ae <initialize_MemBlocksList+0x88>
  802596:	a1 48 51 80 00       	mov    0x805148,%eax
  80259b:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8025a1:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8025a4:	c1 e1 04             	shl    $0x4,%ecx
  8025a7:	01 ca                	add    %ecx,%edx
  8025a9:	89 50 04             	mov    %edx,0x4(%eax)
  8025ac:	eb 12                	jmp    8025c0 <initialize_MemBlocksList+0x9a>
  8025ae:	a1 50 50 80 00       	mov    0x805050,%eax
  8025b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025b6:	c1 e2 04             	shl    $0x4,%edx
  8025b9:	01 d0                	add    %edx,%eax
  8025bb:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8025c0:	a1 50 50 80 00       	mov    0x805050,%eax
  8025c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025c8:	c1 e2 04             	shl    $0x4,%edx
  8025cb:	01 d0                	add    %edx,%eax
  8025cd:	a3 48 51 80 00       	mov    %eax,0x805148
  8025d2:	a1 50 50 80 00       	mov    0x805050,%eax
  8025d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025da:	c1 e2 04             	shl    $0x4,%edx
  8025dd:	01 d0                	add    %edx,%eax
  8025df:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025e6:	a1 54 51 80 00       	mov    0x805154,%eax
  8025eb:	40                   	inc    %eax
  8025ec:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  8025f1:	ff 45 f4             	incl   -0xc(%ebp)
  8025f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025fa:	0f 82 56 ff ff ff    	jb     802556 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802600:	90                   	nop
  802601:	c9                   	leave  
  802602:	c3                   	ret    

00802603 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802603:	55                   	push   %ebp
  802604:	89 e5                	mov    %esp,%ebp
  802606:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802609:	8b 45 08             	mov    0x8(%ebp),%eax
  80260c:	8b 00                	mov    (%eax),%eax
  80260e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802611:	eb 19                	jmp    80262c <find_block+0x29>
	{
		if(va==point->sva)
  802613:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802616:	8b 40 08             	mov    0x8(%eax),%eax
  802619:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80261c:	75 05                	jne    802623 <find_block+0x20>
		   return point;
  80261e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802621:	eb 36                	jmp    802659 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802623:	8b 45 08             	mov    0x8(%ebp),%eax
  802626:	8b 40 08             	mov    0x8(%eax),%eax
  802629:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80262c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802630:	74 07                	je     802639 <find_block+0x36>
  802632:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802635:	8b 00                	mov    (%eax),%eax
  802637:	eb 05                	jmp    80263e <find_block+0x3b>
  802639:	b8 00 00 00 00       	mov    $0x0,%eax
  80263e:	8b 55 08             	mov    0x8(%ebp),%edx
  802641:	89 42 08             	mov    %eax,0x8(%edx)
  802644:	8b 45 08             	mov    0x8(%ebp),%eax
  802647:	8b 40 08             	mov    0x8(%eax),%eax
  80264a:	85 c0                	test   %eax,%eax
  80264c:	75 c5                	jne    802613 <find_block+0x10>
  80264e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802652:	75 bf                	jne    802613 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802654:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802659:	c9                   	leave  
  80265a:	c3                   	ret    

0080265b <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80265b:	55                   	push   %ebp
  80265c:	89 e5                	mov    %esp,%ebp
  80265e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802661:	a1 40 50 80 00       	mov    0x805040,%eax
  802666:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802669:	a1 44 50 80 00       	mov    0x805044,%eax
  80266e:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802671:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802674:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802677:	74 24                	je     80269d <insert_sorted_allocList+0x42>
  802679:	8b 45 08             	mov    0x8(%ebp),%eax
  80267c:	8b 50 08             	mov    0x8(%eax),%edx
  80267f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802682:	8b 40 08             	mov    0x8(%eax),%eax
  802685:	39 c2                	cmp    %eax,%edx
  802687:	76 14                	jbe    80269d <insert_sorted_allocList+0x42>
  802689:	8b 45 08             	mov    0x8(%ebp),%eax
  80268c:	8b 50 08             	mov    0x8(%eax),%edx
  80268f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802692:	8b 40 08             	mov    0x8(%eax),%eax
  802695:	39 c2                	cmp    %eax,%edx
  802697:	0f 82 60 01 00 00    	jb     8027fd <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  80269d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026a1:	75 65                	jne    802708 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8026a3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8026a7:	75 14                	jne    8026bd <insert_sorted_allocList+0x62>
  8026a9:	83 ec 04             	sub    $0x4,%esp
  8026ac:	68 9c 45 80 00       	push   $0x80459c
  8026b1:	6a 6b                	push   $0x6b
  8026b3:	68 bf 45 80 00       	push   $0x8045bf
  8026b8:	e8 4f e2 ff ff       	call   80090c <_panic>
  8026bd:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8026c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c6:	89 10                	mov    %edx,(%eax)
  8026c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8026cb:	8b 00                	mov    (%eax),%eax
  8026cd:	85 c0                	test   %eax,%eax
  8026cf:	74 0d                	je     8026de <insert_sorted_allocList+0x83>
  8026d1:	a1 40 50 80 00       	mov    0x805040,%eax
  8026d6:	8b 55 08             	mov    0x8(%ebp),%edx
  8026d9:	89 50 04             	mov    %edx,0x4(%eax)
  8026dc:	eb 08                	jmp    8026e6 <insert_sorted_allocList+0x8b>
  8026de:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e1:	a3 44 50 80 00       	mov    %eax,0x805044
  8026e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e9:	a3 40 50 80 00       	mov    %eax,0x805040
  8026ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026f8:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8026fd:	40                   	inc    %eax
  8026fe:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802703:	e9 dc 01 00 00       	jmp    8028e4 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802708:	8b 45 08             	mov    0x8(%ebp),%eax
  80270b:	8b 50 08             	mov    0x8(%eax),%edx
  80270e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802711:	8b 40 08             	mov    0x8(%eax),%eax
  802714:	39 c2                	cmp    %eax,%edx
  802716:	77 6c                	ja     802784 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802718:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80271c:	74 06                	je     802724 <insert_sorted_allocList+0xc9>
  80271e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802722:	75 14                	jne    802738 <insert_sorted_allocList+0xdd>
  802724:	83 ec 04             	sub    $0x4,%esp
  802727:	68 d8 45 80 00       	push   $0x8045d8
  80272c:	6a 6f                	push   $0x6f
  80272e:	68 bf 45 80 00       	push   $0x8045bf
  802733:	e8 d4 e1 ff ff       	call   80090c <_panic>
  802738:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80273b:	8b 50 04             	mov    0x4(%eax),%edx
  80273e:	8b 45 08             	mov    0x8(%ebp),%eax
  802741:	89 50 04             	mov    %edx,0x4(%eax)
  802744:	8b 45 08             	mov    0x8(%ebp),%eax
  802747:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80274a:	89 10                	mov    %edx,(%eax)
  80274c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80274f:	8b 40 04             	mov    0x4(%eax),%eax
  802752:	85 c0                	test   %eax,%eax
  802754:	74 0d                	je     802763 <insert_sorted_allocList+0x108>
  802756:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802759:	8b 40 04             	mov    0x4(%eax),%eax
  80275c:	8b 55 08             	mov    0x8(%ebp),%edx
  80275f:	89 10                	mov    %edx,(%eax)
  802761:	eb 08                	jmp    80276b <insert_sorted_allocList+0x110>
  802763:	8b 45 08             	mov    0x8(%ebp),%eax
  802766:	a3 40 50 80 00       	mov    %eax,0x805040
  80276b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80276e:	8b 55 08             	mov    0x8(%ebp),%edx
  802771:	89 50 04             	mov    %edx,0x4(%eax)
  802774:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802779:	40                   	inc    %eax
  80277a:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80277f:	e9 60 01 00 00       	jmp    8028e4 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802784:	8b 45 08             	mov    0x8(%ebp),%eax
  802787:	8b 50 08             	mov    0x8(%eax),%edx
  80278a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80278d:	8b 40 08             	mov    0x8(%eax),%eax
  802790:	39 c2                	cmp    %eax,%edx
  802792:	0f 82 4c 01 00 00    	jb     8028e4 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802798:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80279c:	75 14                	jne    8027b2 <insert_sorted_allocList+0x157>
  80279e:	83 ec 04             	sub    $0x4,%esp
  8027a1:	68 10 46 80 00       	push   $0x804610
  8027a6:	6a 73                	push   $0x73
  8027a8:	68 bf 45 80 00       	push   $0x8045bf
  8027ad:	e8 5a e1 ff ff       	call   80090c <_panic>
  8027b2:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8027b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8027bb:	89 50 04             	mov    %edx,0x4(%eax)
  8027be:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c1:	8b 40 04             	mov    0x4(%eax),%eax
  8027c4:	85 c0                	test   %eax,%eax
  8027c6:	74 0c                	je     8027d4 <insert_sorted_allocList+0x179>
  8027c8:	a1 44 50 80 00       	mov    0x805044,%eax
  8027cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8027d0:	89 10                	mov    %edx,(%eax)
  8027d2:	eb 08                	jmp    8027dc <insert_sorted_allocList+0x181>
  8027d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d7:	a3 40 50 80 00       	mov    %eax,0x805040
  8027dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8027df:	a3 44 50 80 00       	mov    %eax,0x805044
  8027e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027ed:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8027f2:	40                   	inc    %eax
  8027f3:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8027f8:	e9 e7 00 00 00       	jmp    8028e4 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8027fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802800:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802803:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80280a:	a1 40 50 80 00       	mov    0x805040,%eax
  80280f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802812:	e9 9d 00 00 00       	jmp    8028b4 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802817:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281a:	8b 00                	mov    (%eax),%eax
  80281c:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  80281f:	8b 45 08             	mov    0x8(%ebp),%eax
  802822:	8b 50 08             	mov    0x8(%eax),%edx
  802825:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802828:	8b 40 08             	mov    0x8(%eax),%eax
  80282b:	39 c2                	cmp    %eax,%edx
  80282d:	76 7d                	jbe    8028ac <insert_sorted_allocList+0x251>
  80282f:	8b 45 08             	mov    0x8(%ebp),%eax
  802832:	8b 50 08             	mov    0x8(%eax),%edx
  802835:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802838:	8b 40 08             	mov    0x8(%eax),%eax
  80283b:	39 c2                	cmp    %eax,%edx
  80283d:	73 6d                	jae    8028ac <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  80283f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802843:	74 06                	je     80284b <insert_sorted_allocList+0x1f0>
  802845:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802849:	75 14                	jne    80285f <insert_sorted_allocList+0x204>
  80284b:	83 ec 04             	sub    $0x4,%esp
  80284e:	68 34 46 80 00       	push   $0x804634
  802853:	6a 7f                	push   $0x7f
  802855:	68 bf 45 80 00       	push   $0x8045bf
  80285a:	e8 ad e0 ff ff       	call   80090c <_panic>
  80285f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802862:	8b 10                	mov    (%eax),%edx
  802864:	8b 45 08             	mov    0x8(%ebp),%eax
  802867:	89 10                	mov    %edx,(%eax)
  802869:	8b 45 08             	mov    0x8(%ebp),%eax
  80286c:	8b 00                	mov    (%eax),%eax
  80286e:	85 c0                	test   %eax,%eax
  802870:	74 0b                	je     80287d <insert_sorted_allocList+0x222>
  802872:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802875:	8b 00                	mov    (%eax),%eax
  802877:	8b 55 08             	mov    0x8(%ebp),%edx
  80287a:	89 50 04             	mov    %edx,0x4(%eax)
  80287d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802880:	8b 55 08             	mov    0x8(%ebp),%edx
  802883:	89 10                	mov    %edx,(%eax)
  802885:	8b 45 08             	mov    0x8(%ebp),%eax
  802888:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80288b:	89 50 04             	mov    %edx,0x4(%eax)
  80288e:	8b 45 08             	mov    0x8(%ebp),%eax
  802891:	8b 00                	mov    (%eax),%eax
  802893:	85 c0                	test   %eax,%eax
  802895:	75 08                	jne    80289f <insert_sorted_allocList+0x244>
  802897:	8b 45 08             	mov    0x8(%ebp),%eax
  80289a:	a3 44 50 80 00       	mov    %eax,0x805044
  80289f:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8028a4:	40                   	inc    %eax
  8028a5:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8028aa:	eb 39                	jmp    8028e5 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8028ac:	a1 48 50 80 00       	mov    0x805048,%eax
  8028b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028b8:	74 07                	je     8028c1 <insert_sorted_allocList+0x266>
  8028ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bd:	8b 00                	mov    (%eax),%eax
  8028bf:	eb 05                	jmp    8028c6 <insert_sorted_allocList+0x26b>
  8028c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8028c6:	a3 48 50 80 00       	mov    %eax,0x805048
  8028cb:	a1 48 50 80 00       	mov    0x805048,%eax
  8028d0:	85 c0                	test   %eax,%eax
  8028d2:	0f 85 3f ff ff ff    	jne    802817 <insert_sorted_allocList+0x1bc>
  8028d8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028dc:	0f 85 35 ff ff ff    	jne    802817 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8028e2:	eb 01                	jmp    8028e5 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8028e4:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8028e5:	90                   	nop
  8028e6:	c9                   	leave  
  8028e7:	c3                   	ret    

008028e8 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8028e8:	55                   	push   %ebp
  8028e9:	89 e5                	mov    %esp,%ebp
  8028eb:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8028ee:	a1 38 51 80 00       	mov    0x805138,%eax
  8028f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028f6:	e9 85 01 00 00       	jmp    802a80 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8028fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fe:	8b 40 0c             	mov    0xc(%eax),%eax
  802901:	3b 45 08             	cmp    0x8(%ebp),%eax
  802904:	0f 82 6e 01 00 00    	jb     802a78 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  80290a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290d:	8b 40 0c             	mov    0xc(%eax),%eax
  802910:	3b 45 08             	cmp    0x8(%ebp),%eax
  802913:	0f 85 8a 00 00 00    	jne    8029a3 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802919:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80291d:	75 17                	jne    802936 <alloc_block_FF+0x4e>
  80291f:	83 ec 04             	sub    $0x4,%esp
  802922:	68 68 46 80 00       	push   $0x804668
  802927:	68 93 00 00 00       	push   $0x93
  80292c:	68 bf 45 80 00       	push   $0x8045bf
  802931:	e8 d6 df ff ff       	call   80090c <_panic>
  802936:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802939:	8b 00                	mov    (%eax),%eax
  80293b:	85 c0                	test   %eax,%eax
  80293d:	74 10                	je     80294f <alloc_block_FF+0x67>
  80293f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802942:	8b 00                	mov    (%eax),%eax
  802944:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802947:	8b 52 04             	mov    0x4(%edx),%edx
  80294a:	89 50 04             	mov    %edx,0x4(%eax)
  80294d:	eb 0b                	jmp    80295a <alloc_block_FF+0x72>
  80294f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802952:	8b 40 04             	mov    0x4(%eax),%eax
  802955:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80295a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295d:	8b 40 04             	mov    0x4(%eax),%eax
  802960:	85 c0                	test   %eax,%eax
  802962:	74 0f                	je     802973 <alloc_block_FF+0x8b>
  802964:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802967:	8b 40 04             	mov    0x4(%eax),%eax
  80296a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80296d:	8b 12                	mov    (%edx),%edx
  80296f:	89 10                	mov    %edx,(%eax)
  802971:	eb 0a                	jmp    80297d <alloc_block_FF+0x95>
  802973:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802976:	8b 00                	mov    (%eax),%eax
  802978:	a3 38 51 80 00       	mov    %eax,0x805138
  80297d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802980:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802986:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802989:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802990:	a1 44 51 80 00       	mov    0x805144,%eax
  802995:	48                   	dec    %eax
  802996:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  80299b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299e:	e9 10 01 00 00       	jmp    802ab3 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8029a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a6:	8b 40 0c             	mov    0xc(%eax),%eax
  8029a9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029ac:	0f 86 c6 00 00 00    	jbe    802a78 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8029b2:	a1 48 51 80 00       	mov    0x805148,%eax
  8029b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8029ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bd:	8b 50 08             	mov    0x8(%eax),%edx
  8029c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029c3:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8029c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029c9:	8b 55 08             	mov    0x8(%ebp),%edx
  8029cc:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8029cf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029d3:	75 17                	jne    8029ec <alloc_block_FF+0x104>
  8029d5:	83 ec 04             	sub    $0x4,%esp
  8029d8:	68 68 46 80 00       	push   $0x804668
  8029dd:	68 9b 00 00 00       	push   $0x9b
  8029e2:	68 bf 45 80 00       	push   $0x8045bf
  8029e7:	e8 20 df ff ff       	call   80090c <_panic>
  8029ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ef:	8b 00                	mov    (%eax),%eax
  8029f1:	85 c0                	test   %eax,%eax
  8029f3:	74 10                	je     802a05 <alloc_block_FF+0x11d>
  8029f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f8:	8b 00                	mov    (%eax),%eax
  8029fa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029fd:	8b 52 04             	mov    0x4(%edx),%edx
  802a00:	89 50 04             	mov    %edx,0x4(%eax)
  802a03:	eb 0b                	jmp    802a10 <alloc_block_FF+0x128>
  802a05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a08:	8b 40 04             	mov    0x4(%eax),%eax
  802a0b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a13:	8b 40 04             	mov    0x4(%eax),%eax
  802a16:	85 c0                	test   %eax,%eax
  802a18:	74 0f                	je     802a29 <alloc_block_FF+0x141>
  802a1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a1d:	8b 40 04             	mov    0x4(%eax),%eax
  802a20:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a23:	8b 12                	mov    (%edx),%edx
  802a25:	89 10                	mov    %edx,(%eax)
  802a27:	eb 0a                	jmp    802a33 <alloc_block_FF+0x14b>
  802a29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a2c:	8b 00                	mov    (%eax),%eax
  802a2e:	a3 48 51 80 00       	mov    %eax,0x805148
  802a33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a36:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a3f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a46:	a1 54 51 80 00       	mov    0x805154,%eax
  802a4b:	48                   	dec    %eax
  802a4c:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802a51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a54:	8b 50 08             	mov    0x8(%eax),%edx
  802a57:	8b 45 08             	mov    0x8(%ebp),%eax
  802a5a:	01 c2                	add    %eax,%edx
  802a5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5f:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802a62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a65:	8b 40 0c             	mov    0xc(%eax),%eax
  802a68:	2b 45 08             	sub    0x8(%ebp),%eax
  802a6b:	89 c2                	mov    %eax,%edx
  802a6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a70:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802a73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a76:	eb 3b                	jmp    802ab3 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802a78:	a1 40 51 80 00       	mov    0x805140,%eax
  802a7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a80:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a84:	74 07                	je     802a8d <alloc_block_FF+0x1a5>
  802a86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a89:	8b 00                	mov    (%eax),%eax
  802a8b:	eb 05                	jmp    802a92 <alloc_block_FF+0x1aa>
  802a8d:	b8 00 00 00 00       	mov    $0x0,%eax
  802a92:	a3 40 51 80 00       	mov    %eax,0x805140
  802a97:	a1 40 51 80 00       	mov    0x805140,%eax
  802a9c:	85 c0                	test   %eax,%eax
  802a9e:	0f 85 57 fe ff ff    	jne    8028fb <alloc_block_FF+0x13>
  802aa4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aa8:	0f 85 4d fe ff ff    	jne    8028fb <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802aae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ab3:	c9                   	leave  
  802ab4:	c3                   	ret    

00802ab5 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802ab5:	55                   	push   %ebp
  802ab6:	89 e5                	mov    %esp,%ebp
  802ab8:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802abb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802ac2:	a1 38 51 80 00       	mov    0x805138,%eax
  802ac7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802aca:	e9 df 00 00 00       	jmp    802bae <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802acf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad2:	8b 40 0c             	mov    0xc(%eax),%eax
  802ad5:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ad8:	0f 82 c8 00 00 00    	jb     802ba6 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802ade:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae1:	8b 40 0c             	mov    0xc(%eax),%eax
  802ae4:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ae7:	0f 85 8a 00 00 00    	jne    802b77 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802aed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802af1:	75 17                	jne    802b0a <alloc_block_BF+0x55>
  802af3:	83 ec 04             	sub    $0x4,%esp
  802af6:	68 68 46 80 00       	push   $0x804668
  802afb:	68 b7 00 00 00       	push   $0xb7
  802b00:	68 bf 45 80 00       	push   $0x8045bf
  802b05:	e8 02 de ff ff       	call   80090c <_panic>
  802b0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0d:	8b 00                	mov    (%eax),%eax
  802b0f:	85 c0                	test   %eax,%eax
  802b11:	74 10                	je     802b23 <alloc_block_BF+0x6e>
  802b13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b16:	8b 00                	mov    (%eax),%eax
  802b18:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b1b:	8b 52 04             	mov    0x4(%edx),%edx
  802b1e:	89 50 04             	mov    %edx,0x4(%eax)
  802b21:	eb 0b                	jmp    802b2e <alloc_block_BF+0x79>
  802b23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b26:	8b 40 04             	mov    0x4(%eax),%eax
  802b29:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b31:	8b 40 04             	mov    0x4(%eax),%eax
  802b34:	85 c0                	test   %eax,%eax
  802b36:	74 0f                	je     802b47 <alloc_block_BF+0x92>
  802b38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3b:	8b 40 04             	mov    0x4(%eax),%eax
  802b3e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b41:	8b 12                	mov    (%edx),%edx
  802b43:	89 10                	mov    %edx,(%eax)
  802b45:	eb 0a                	jmp    802b51 <alloc_block_BF+0x9c>
  802b47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4a:	8b 00                	mov    (%eax),%eax
  802b4c:	a3 38 51 80 00       	mov    %eax,0x805138
  802b51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b54:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b64:	a1 44 51 80 00       	mov    0x805144,%eax
  802b69:	48                   	dec    %eax
  802b6a:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802b6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b72:	e9 4d 01 00 00       	jmp    802cc4 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802b77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7a:	8b 40 0c             	mov    0xc(%eax),%eax
  802b7d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b80:	76 24                	jbe    802ba6 <alloc_block_BF+0xf1>
  802b82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b85:	8b 40 0c             	mov    0xc(%eax),%eax
  802b88:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802b8b:	73 19                	jae    802ba6 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802b8d:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802b94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b97:	8b 40 0c             	mov    0xc(%eax),%eax
  802b9a:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802b9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba0:	8b 40 08             	mov    0x8(%eax),%eax
  802ba3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802ba6:	a1 40 51 80 00       	mov    0x805140,%eax
  802bab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bb2:	74 07                	je     802bbb <alloc_block_BF+0x106>
  802bb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb7:	8b 00                	mov    (%eax),%eax
  802bb9:	eb 05                	jmp    802bc0 <alloc_block_BF+0x10b>
  802bbb:	b8 00 00 00 00       	mov    $0x0,%eax
  802bc0:	a3 40 51 80 00       	mov    %eax,0x805140
  802bc5:	a1 40 51 80 00       	mov    0x805140,%eax
  802bca:	85 c0                	test   %eax,%eax
  802bcc:	0f 85 fd fe ff ff    	jne    802acf <alloc_block_BF+0x1a>
  802bd2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bd6:	0f 85 f3 fe ff ff    	jne    802acf <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802bdc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802be0:	0f 84 d9 00 00 00    	je     802cbf <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802be6:	a1 48 51 80 00       	mov    0x805148,%eax
  802beb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802bee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bf1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802bf4:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802bf7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bfa:	8b 55 08             	mov    0x8(%ebp),%edx
  802bfd:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802c00:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802c04:	75 17                	jne    802c1d <alloc_block_BF+0x168>
  802c06:	83 ec 04             	sub    $0x4,%esp
  802c09:	68 68 46 80 00       	push   $0x804668
  802c0e:	68 c7 00 00 00       	push   $0xc7
  802c13:	68 bf 45 80 00       	push   $0x8045bf
  802c18:	e8 ef dc ff ff       	call   80090c <_panic>
  802c1d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c20:	8b 00                	mov    (%eax),%eax
  802c22:	85 c0                	test   %eax,%eax
  802c24:	74 10                	je     802c36 <alloc_block_BF+0x181>
  802c26:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c29:	8b 00                	mov    (%eax),%eax
  802c2b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c2e:	8b 52 04             	mov    0x4(%edx),%edx
  802c31:	89 50 04             	mov    %edx,0x4(%eax)
  802c34:	eb 0b                	jmp    802c41 <alloc_block_BF+0x18c>
  802c36:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c39:	8b 40 04             	mov    0x4(%eax),%eax
  802c3c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c41:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c44:	8b 40 04             	mov    0x4(%eax),%eax
  802c47:	85 c0                	test   %eax,%eax
  802c49:	74 0f                	je     802c5a <alloc_block_BF+0x1a5>
  802c4b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c4e:	8b 40 04             	mov    0x4(%eax),%eax
  802c51:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c54:	8b 12                	mov    (%edx),%edx
  802c56:	89 10                	mov    %edx,(%eax)
  802c58:	eb 0a                	jmp    802c64 <alloc_block_BF+0x1af>
  802c5a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c5d:	8b 00                	mov    (%eax),%eax
  802c5f:	a3 48 51 80 00       	mov    %eax,0x805148
  802c64:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c67:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c6d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c70:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c77:	a1 54 51 80 00       	mov    0x805154,%eax
  802c7c:	48                   	dec    %eax
  802c7d:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802c82:	83 ec 08             	sub    $0x8,%esp
  802c85:	ff 75 ec             	pushl  -0x14(%ebp)
  802c88:	68 38 51 80 00       	push   $0x805138
  802c8d:	e8 71 f9 ff ff       	call   802603 <find_block>
  802c92:	83 c4 10             	add    $0x10,%esp
  802c95:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802c98:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c9b:	8b 50 08             	mov    0x8(%eax),%edx
  802c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca1:	01 c2                	add    %eax,%edx
  802ca3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ca6:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802ca9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cac:	8b 40 0c             	mov    0xc(%eax),%eax
  802caf:	2b 45 08             	sub    0x8(%ebp),%eax
  802cb2:	89 c2                	mov    %eax,%edx
  802cb4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cb7:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802cba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cbd:	eb 05                	jmp    802cc4 <alloc_block_BF+0x20f>
	}
	return NULL;
  802cbf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802cc4:	c9                   	leave  
  802cc5:	c3                   	ret    

00802cc6 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802cc6:	55                   	push   %ebp
  802cc7:	89 e5                	mov    %esp,%ebp
  802cc9:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802ccc:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802cd1:	85 c0                	test   %eax,%eax
  802cd3:	0f 85 de 01 00 00    	jne    802eb7 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802cd9:	a1 38 51 80 00       	mov    0x805138,%eax
  802cde:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ce1:	e9 9e 01 00 00       	jmp    802e84 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802ce6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce9:	8b 40 0c             	mov    0xc(%eax),%eax
  802cec:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cef:	0f 82 87 01 00 00    	jb     802e7c <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802cf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf8:	8b 40 0c             	mov    0xc(%eax),%eax
  802cfb:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cfe:	0f 85 95 00 00 00    	jne    802d99 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802d04:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d08:	75 17                	jne    802d21 <alloc_block_NF+0x5b>
  802d0a:	83 ec 04             	sub    $0x4,%esp
  802d0d:	68 68 46 80 00       	push   $0x804668
  802d12:	68 e0 00 00 00       	push   $0xe0
  802d17:	68 bf 45 80 00       	push   $0x8045bf
  802d1c:	e8 eb db ff ff       	call   80090c <_panic>
  802d21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d24:	8b 00                	mov    (%eax),%eax
  802d26:	85 c0                	test   %eax,%eax
  802d28:	74 10                	je     802d3a <alloc_block_NF+0x74>
  802d2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2d:	8b 00                	mov    (%eax),%eax
  802d2f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d32:	8b 52 04             	mov    0x4(%edx),%edx
  802d35:	89 50 04             	mov    %edx,0x4(%eax)
  802d38:	eb 0b                	jmp    802d45 <alloc_block_NF+0x7f>
  802d3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3d:	8b 40 04             	mov    0x4(%eax),%eax
  802d40:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d48:	8b 40 04             	mov    0x4(%eax),%eax
  802d4b:	85 c0                	test   %eax,%eax
  802d4d:	74 0f                	je     802d5e <alloc_block_NF+0x98>
  802d4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d52:	8b 40 04             	mov    0x4(%eax),%eax
  802d55:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d58:	8b 12                	mov    (%edx),%edx
  802d5a:	89 10                	mov    %edx,(%eax)
  802d5c:	eb 0a                	jmp    802d68 <alloc_block_NF+0xa2>
  802d5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d61:	8b 00                	mov    (%eax),%eax
  802d63:	a3 38 51 80 00       	mov    %eax,0x805138
  802d68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d74:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d7b:	a1 44 51 80 00       	mov    0x805144,%eax
  802d80:	48                   	dec    %eax
  802d81:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802d86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d89:	8b 40 08             	mov    0x8(%eax),%eax
  802d8c:	a3 2c 50 80 00       	mov    %eax,0x80502c
				   return  point;
  802d91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d94:	e9 f8 04 00 00       	jmp    803291 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802d99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9c:	8b 40 0c             	mov    0xc(%eax),%eax
  802d9f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802da2:	0f 86 d4 00 00 00    	jbe    802e7c <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802da8:	a1 48 51 80 00       	mov    0x805148,%eax
  802dad:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802db0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db3:	8b 50 08             	mov    0x8(%eax),%edx
  802db6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802db9:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802dbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dbf:	8b 55 08             	mov    0x8(%ebp),%edx
  802dc2:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802dc5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802dc9:	75 17                	jne    802de2 <alloc_block_NF+0x11c>
  802dcb:	83 ec 04             	sub    $0x4,%esp
  802dce:	68 68 46 80 00       	push   $0x804668
  802dd3:	68 e9 00 00 00       	push   $0xe9
  802dd8:	68 bf 45 80 00       	push   $0x8045bf
  802ddd:	e8 2a db ff ff       	call   80090c <_panic>
  802de2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de5:	8b 00                	mov    (%eax),%eax
  802de7:	85 c0                	test   %eax,%eax
  802de9:	74 10                	je     802dfb <alloc_block_NF+0x135>
  802deb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dee:	8b 00                	mov    (%eax),%eax
  802df0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802df3:	8b 52 04             	mov    0x4(%edx),%edx
  802df6:	89 50 04             	mov    %edx,0x4(%eax)
  802df9:	eb 0b                	jmp    802e06 <alloc_block_NF+0x140>
  802dfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dfe:	8b 40 04             	mov    0x4(%eax),%eax
  802e01:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e09:	8b 40 04             	mov    0x4(%eax),%eax
  802e0c:	85 c0                	test   %eax,%eax
  802e0e:	74 0f                	je     802e1f <alloc_block_NF+0x159>
  802e10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e13:	8b 40 04             	mov    0x4(%eax),%eax
  802e16:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e19:	8b 12                	mov    (%edx),%edx
  802e1b:	89 10                	mov    %edx,(%eax)
  802e1d:	eb 0a                	jmp    802e29 <alloc_block_NF+0x163>
  802e1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e22:	8b 00                	mov    (%eax),%eax
  802e24:	a3 48 51 80 00       	mov    %eax,0x805148
  802e29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e2c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e35:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e3c:	a1 54 51 80 00       	mov    0x805154,%eax
  802e41:	48                   	dec    %eax
  802e42:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802e47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e4a:	8b 40 08             	mov    0x8(%eax),%eax
  802e4d:	a3 2c 50 80 00       	mov    %eax,0x80502c
				   point->sva += size;
  802e52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e55:	8b 50 08             	mov    0x8(%eax),%edx
  802e58:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5b:	01 c2                	add    %eax,%edx
  802e5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e60:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802e63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e66:	8b 40 0c             	mov    0xc(%eax),%eax
  802e69:	2b 45 08             	sub    0x8(%ebp),%eax
  802e6c:	89 c2                	mov    %eax,%edx
  802e6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e71:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802e74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e77:	e9 15 04 00 00       	jmp    803291 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802e7c:	a1 40 51 80 00       	mov    0x805140,%eax
  802e81:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e84:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e88:	74 07                	je     802e91 <alloc_block_NF+0x1cb>
  802e8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8d:	8b 00                	mov    (%eax),%eax
  802e8f:	eb 05                	jmp    802e96 <alloc_block_NF+0x1d0>
  802e91:	b8 00 00 00 00       	mov    $0x0,%eax
  802e96:	a3 40 51 80 00       	mov    %eax,0x805140
  802e9b:	a1 40 51 80 00       	mov    0x805140,%eax
  802ea0:	85 c0                	test   %eax,%eax
  802ea2:	0f 85 3e fe ff ff    	jne    802ce6 <alloc_block_NF+0x20>
  802ea8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802eac:	0f 85 34 fe ff ff    	jne    802ce6 <alloc_block_NF+0x20>
  802eb2:	e9 d5 03 00 00       	jmp    80328c <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802eb7:	a1 38 51 80 00       	mov    0x805138,%eax
  802ebc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ebf:	e9 b1 01 00 00       	jmp    803075 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802ec4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec7:	8b 50 08             	mov    0x8(%eax),%edx
  802eca:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802ecf:	39 c2                	cmp    %eax,%edx
  802ed1:	0f 82 96 01 00 00    	jb     80306d <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802ed7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eda:	8b 40 0c             	mov    0xc(%eax),%eax
  802edd:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ee0:	0f 82 87 01 00 00    	jb     80306d <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802ee6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee9:	8b 40 0c             	mov    0xc(%eax),%eax
  802eec:	3b 45 08             	cmp    0x8(%ebp),%eax
  802eef:	0f 85 95 00 00 00    	jne    802f8a <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802ef5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ef9:	75 17                	jne    802f12 <alloc_block_NF+0x24c>
  802efb:	83 ec 04             	sub    $0x4,%esp
  802efe:	68 68 46 80 00       	push   $0x804668
  802f03:	68 fc 00 00 00       	push   $0xfc
  802f08:	68 bf 45 80 00       	push   $0x8045bf
  802f0d:	e8 fa d9 ff ff       	call   80090c <_panic>
  802f12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f15:	8b 00                	mov    (%eax),%eax
  802f17:	85 c0                	test   %eax,%eax
  802f19:	74 10                	je     802f2b <alloc_block_NF+0x265>
  802f1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1e:	8b 00                	mov    (%eax),%eax
  802f20:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f23:	8b 52 04             	mov    0x4(%edx),%edx
  802f26:	89 50 04             	mov    %edx,0x4(%eax)
  802f29:	eb 0b                	jmp    802f36 <alloc_block_NF+0x270>
  802f2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2e:	8b 40 04             	mov    0x4(%eax),%eax
  802f31:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f39:	8b 40 04             	mov    0x4(%eax),%eax
  802f3c:	85 c0                	test   %eax,%eax
  802f3e:	74 0f                	je     802f4f <alloc_block_NF+0x289>
  802f40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f43:	8b 40 04             	mov    0x4(%eax),%eax
  802f46:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f49:	8b 12                	mov    (%edx),%edx
  802f4b:	89 10                	mov    %edx,(%eax)
  802f4d:	eb 0a                	jmp    802f59 <alloc_block_NF+0x293>
  802f4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f52:	8b 00                	mov    (%eax),%eax
  802f54:	a3 38 51 80 00       	mov    %eax,0x805138
  802f59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f65:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f6c:	a1 44 51 80 00       	mov    0x805144,%eax
  802f71:	48                   	dec    %eax
  802f72:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802f77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7a:	8b 40 08             	mov    0x8(%eax),%eax
  802f7d:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   return  point;
  802f82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f85:	e9 07 03 00 00       	jmp    803291 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802f8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8d:	8b 40 0c             	mov    0xc(%eax),%eax
  802f90:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f93:	0f 86 d4 00 00 00    	jbe    80306d <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802f99:	a1 48 51 80 00       	mov    0x805148,%eax
  802f9e:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802fa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa4:	8b 50 08             	mov    0x8(%eax),%edx
  802fa7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802faa:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802fad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fb0:	8b 55 08             	mov    0x8(%ebp),%edx
  802fb3:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802fb6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802fba:	75 17                	jne    802fd3 <alloc_block_NF+0x30d>
  802fbc:	83 ec 04             	sub    $0x4,%esp
  802fbf:	68 68 46 80 00       	push   $0x804668
  802fc4:	68 04 01 00 00       	push   $0x104
  802fc9:	68 bf 45 80 00       	push   $0x8045bf
  802fce:	e8 39 d9 ff ff       	call   80090c <_panic>
  802fd3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fd6:	8b 00                	mov    (%eax),%eax
  802fd8:	85 c0                	test   %eax,%eax
  802fda:	74 10                	je     802fec <alloc_block_NF+0x326>
  802fdc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fdf:	8b 00                	mov    (%eax),%eax
  802fe1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fe4:	8b 52 04             	mov    0x4(%edx),%edx
  802fe7:	89 50 04             	mov    %edx,0x4(%eax)
  802fea:	eb 0b                	jmp    802ff7 <alloc_block_NF+0x331>
  802fec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fef:	8b 40 04             	mov    0x4(%eax),%eax
  802ff2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ff7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ffa:	8b 40 04             	mov    0x4(%eax),%eax
  802ffd:	85 c0                	test   %eax,%eax
  802fff:	74 0f                	je     803010 <alloc_block_NF+0x34a>
  803001:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803004:	8b 40 04             	mov    0x4(%eax),%eax
  803007:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80300a:	8b 12                	mov    (%edx),%edx
  80300c:	89 10                	mov    %edx,(%eax)
  80300e:	eb 0a                	jmp    80301a <alloc_block_NF+0x354>
  803010:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803013:	8b 00                	mov    (%eax),%eax
  803015:	a3 48 51 80 00       	mov    %eax,0x805148
  80301a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80301d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803023:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803026:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80302d:	a1 54 51 80 00       	mov    0x805154,%eax
  803032:	48                   	dec    %eax
  803033:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  803038:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80303b:	8b 40 08             	mov    0x8(%eax),%eax
  80303e:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   point->sva += size;
  803043:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803046:	8b 50 08             	mov    0x8(%eax),%edx
  803049:	8b 45 08             	mov    0x8(%ebp),%eax
  80304c:	01 c2                	add    %eax,%edx
  80304e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803051:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803054:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803057:	8b 40 0c             	mov    0xc(%eax),%eax
  80305a:	2b 45 08             	sub    0x8(%ebp),%eax
  80305d:	89 c2                	mov    %eax,%edx
  80305f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803062:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803065:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803068:	e9 24 02 00 00       	jmp    803291 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  80306d:	a1 40 51 80 00       	mov    0x805140,%eax
  803072:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803075:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803079:	74 07                	je     803082 <alloc_block_NF+0x3bc>
  80307b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80307e:	8b 00                	mov    (%eax),%eax
  803080:	eb 05                	jmp    803087 <alloc_block_NF+0x3c1>
  803082:	b8 00 00 00 00       	mov    $0x0,%eax
  803087:	a3 40 51 80 00       	mov    %eax,0x805140
  80308c:	a1 40 51 80 00       	mov    0x805140,%eax
  803091:	85 c0                	test   %eax,%eax
  803093:	0f 85 2b fe ff ff    	jne    802ec4 <alloc_block_NF+0x1fe>
  803099:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80309d:	0f 85 21 fe ff ff    	jne    802ec4 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8030a3:	a1 38 51 80 00       	mov    0x805138,%eax
  8030a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030ab:	e9 ae 01 00 00       	jmp    80325e <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  8030b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b3:	8b 50 08             	mov    0x8(%eax),%edx
  8030b6:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8030bb:	39 c2                	cmp    %eax,%edx
  8030bd:	0f 83 93 01 00 00    	jae    803256 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  8030c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c6:	8b 40 0c             	mov    0xc(%eax),%eax
  8030c9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030cc:	0f 82 84 01 00 00    	jb     803256 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  8030d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d5:	8b 40 0c             	mov    0xc(%eax),%eax
  8030d8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030db:	0f 85 95 00 00 00    	jne    803176 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8030e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030e5:	75 17                	jne    8030fe <alloc_block_NF+0x438>
  8030e7:	83 ec 04             	sub    $0x4,%esp
  8030ea:	68 68 46 80 00       	push   $0x804668
  8030ef:	68 14 01 00 00       	push   $0x114
  8030f4:	68 bf 45 80 00       	push   $0x8045bf
  8030f9:	e8 0e d8 ff ff       	call   80090c <_panic>
  8030fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803101:	8b 00                	mov    (%eax),%eax
  803103:	85 c0                	test   %eax,%eax
  803105:	74 10                	je     803117 <alloc_block_NF+0x451>
  803107:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80310a:	8b 00                	mov    (%eax),%eax
  80310c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80310f:	8b 52 04             	mov    0x4(%edx),%edx
  803112:	89 50 04             	mov    %edx,0x4(%eax)
  803115:	eb 0b                	jmp    803122 <alloc_block_NF+0x45c>
  803117:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80311a:	8b 40 04             	mov    0x4(%eax),%eax
  80311d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803122:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803125:	8b 40 04             	mov    0x4(%eax),%eax
  803128:	85 c0                	test   %eax,%eax
  80312a:	74 0f                	je     80313b <alloc_block_NF+0x475>
  80312c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80312f:	8b 40 04             	mov    0x4(%eax),%eax
  803132:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803135:	8b 12                	mov    (%edx),%edx
  803137:	89 10                	mov    %edx,(%eax)
  803139:	eb 0a                	jmp    803145 <alloc_block_NF+0x47f>
  80313b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80313e:	8b 00                	mov    (%eax),%eax
  803140:	a3 38 51 80 00       	mov    %eax,0x805138
  803145:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803148:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80314e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803151:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803158:	a1 44 51 80 00       	mov    0x805144,%eax
  80315d:	48                   	dec    %eax
  80315e:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  803163:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803166:	8b 40 08             	mov    0x8(%eax),%eax
  803169:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   return  point;
  80316e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803171:	e9 1b 01 00 00       	jmp    803291 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  803176:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803179:	8b 40 0c             	mov    0xc(%eax),%eax
  80317c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80317f:	0f 86 d1 00 00 00    	jbe    803256 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803185:	a1 48 51 80 00       	mov    0x805148,%eax
  80318a:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  80318d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803190:	8b 50 08             	mov    0x8(%eax),%edx
  803193:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803196:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  803199:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80319c:	8b 55 08             	mov    0x8(%ebp),%edx
  80319f:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8031a2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8031a6:	75 17                	jne    8031bf <alloc_block_NF+0x4f9>
  8031a8:	83 ec 04             	sub    $0x4,%esp
  8031ab:	68 68 46 80 00       	push   $0x804668
  8031b0:	68 1c 01 00 00       	push   $0x11c
  8031b5:	68 bf 45 80 00       	push   $0x8045bf
  8031ba:	e8 4d d7 ff ff       	call   80090c <_panic>
  8031bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031c2:	8b 00                	mov    (%eax),%eax
  8031c4:	85 c0                	test   %eax,%eax
  8031c6:	74 10                	je     8031d8 <alloc_block_NF+0x512>
  8031c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031cb:	8b 00                	mov    (%eax),%eax
  8031cd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8031d0:	8b 52 04             	mov    0x4(%edx),%edx
  8031d3:	89 50 04             	mov    %edx,0x4(%eax)
  8031d6:	eb 0b                	jmp    8031e3 <alloc_block_NF+0x51d>
  8031d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031db:	8b 40 04             	mov    0x4(%eax),%eax
  8031de:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031e6:	8b 40 04             	mov    0x4(%eax),%eax
  8031e9:	85 c0                	test   %eax,%eax
  8031eb:	74 0f                	je     8031fc <alloc_block_NF+0x536>
  8031ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031f0:	8b 40 04             	mov    0x4(%eax),%eax
  8031f3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8031f6:	8b 12                	mov    (%edx),%edx
  8031f8:	89 10                	mov    %edx,(%eax)
  8031fa:	eb 0a                	jmp    803206 <alloc_block_NF+0x540>
  8031fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031ff:	8b 00                	mov    (%eax),%eax
  803201:	a3 48 51 80 00       	mov    %eax,0x805148
  803206:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803209:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80320f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803212:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803219:	a1 54 51 80 00       	mov    0x805154,%eax
  80321e:	48                   	dec    %eax
  80321f:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  803224:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803227:	8b 40 08             	mov    0x8(%eax),%eax
  80322a:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   point->sva += size;
  80322f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803232:	8b 50 08             	mov    0x8(%eax),%edx
  803235:	8b 45 08             	mov    0x8(%ebp),%eax
  803238:	01 c2                	add    %eax,%edx
  80323a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80323d:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803240:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803243:	8b 40 0c             	mov    0xc(%eax),%eax
  803246:	2b 45 08             	sub    0x8(%ebp),%eax
  803249:	89 c2                	mov    %eax,%edx
  80324b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80324e:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803251:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803254:	eb 3b                	jmp    803291 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803256:	a1 40 51 80 00       	mov    0x805140,%eax
  80325b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80325e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803262:	74 07                	je     80326b <alloc_block_NF+0x5a5>
  803264:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803267:	8b 00                	mov    (%eax),%eax
  803269:	eb 05                	jmp    803270 <alloc_block_NF+0x5aa>
  80326b:	b8 00 00 00 00       	mov    $0x0,%eax
  803270:	a3 40 51 80 00       	mov    %eax,0x805140
  803275:	a1 40 51 80 00       	mov    0x805140,%eax
  80327a:	85 c0                	test   %eax,%eax
  80327c:	0f 85 2e fe ff ff    	jne    8030b0 <alloc_block_NF+0x3ea>
  803282:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803286:	0f 85 24 fe ff ff    	jne    8030b0 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  80328c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803291:	c9                   	leave  
  803292:	c3                   	ret    

00803293 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803293:	55                   	push   %ebp
  803294:	89 e5                	mov    %esp,%ebp
  803296:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  803299:	a1 38 51 80 00       	mov    0x805138,%eax
  80329e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  8032a1:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8032a6:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  8032a9:	a1 38 51 80 00       	mov    0x805138,%eax
  8032ae:	85 c0                	test   %eax,%eax
  8032b0:	74 14                	je     8032c6 <insert_sorted_with_merge_freeList+0x33>
  8032b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b5:	8b 50 08             	mov    0x8(%eax),%edx
  8032b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032bb:	8b 40 08             	mov    0x8(%eax),%eax
  8032be:	39 c2                	cmp    %eax,%edx
  8032c0:	0f 87 9b 01 00 00    	ja     803461 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  8032c6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032ca:	75 17                	jne    8032e3 <insert_sorted_with_merge_freeList+0x50>
  8032cc:	83 ec 04             	sub    $0x4,%esp
  8032cf:	68 9c 45 80 00       	push   $0x80459c
  8032d4:	68 38 01 00 00       	push   $0x138
  8032d9:	68 bf 45 80 00       	push   $0x8045bf
  8032de:	e8 29 d6 ff ff       	call   80090c <_panic>
  8032e3:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8032e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ec:	89 10                	mov    %edx,(%eax)
  8032ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f1:	8b 00                	mov    (%eax),%eax
  8032f3:	85 c0                	test   %eax,%eax
  8032f5:	74 0d                	je     803304 <insert_sorted_with_merge_freeList+0x71>
  8032f7:	a1 38 51 80 00       	mov    0x805138,%eax
  8032fc:	8b 55 08             	mov    0x8(%ebp),%edx
  8032ff:	89 50 04             	mov    %edx,0x4(%eax)
  803302:	eb 08                	jmp    80330c <insert_sorted_with_merge_freeList+0x79>
  803304:	8b 45 08             	mov    0x8(%ebp),%eax
  803307:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80330c:	8b 45 08             	mov    0x8(%ebp),%eax
  80330f:	a3 38 51 80 00       	mov    %eax,0x805138
  803314:	8b 45 08             	mov    0x8(%ebp),%eax
  803317:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80331e:	a1 44 51 80 00       	mov    0x805144,%eax
  803323:	40                   	inc    %eax
  803324:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803329:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80332d:	0f 84 a8 06 00 00    	je     8039db <insert_sorted_with_merge_freeList+0x748>
  803333:	8b 45 08             	mov    0x8(%ebp),%eax
  803336:	8b 50 08             	mov    0x8(%eax),%edx
  803339:	8b 45 08             	mov    0x8(%ebp),%eax
  80333c:	8b 40 0c             	mov    0xc(%eax),%eax
  80333f:	01 c2                	add    %eax,%edx
  803341:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803344:	8b 40 08             	mov    0x8(%eax),%eax
  803347:	39 c2                	cmp    %eax,%edx
  803349:	0f 85 8c 06 00 00    	jne    8039db <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  80334f:	8b 45 08             	mov    0x8(%ebp),%eax
  803352:	8b 50 0c             	mov    0xc(%eax),%edx
  803355:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803358:	8b 40 0c             	mov    0xc(%eax),%eax
  80335b:	01 c2                	add    %eax,%edx
  80335d:	8b 45 08             	mov    0x8(%ebp),%eax
  803360:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  803363:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803367:	75 17                	jne    803380 <insert_sorted_with_merge_freeList+0xed>
  803369:	83 ec 04             	sub    $0x4,%esp
  80336c:	68 68 46 80 00       	push   $0x804668
  803371:	68 3c 01 00 00       	push   $0x13c
  803376:	68 bf 45 80 00       	push   $0x8045bf
  80337b:	e8 8c d5 ff ff       	call   80090c <_panic>
  803380:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803383:	8b 00                	mov    (%eax),%eax
  803385:	85 c0                	test   %eax,%eax
  803387:	74 10                	je     803399 <insert_sorted_with_merge_freeList+0x106>
  803389:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80338c:	8b 00                	mov    (%eax),%eax
  80338e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803391:	8b 52 04             	mov    0x4(%edx),%edx
  803394:	89 50 04             	mov    %edx,0x4(%eax)
  803397:	eb 0b                	jmp    8033a4 <insert_sorted_with_merge_freeList+0x111>
  803399:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80339c:	8b 40 04             	mov    0x4(%eax),%eax
  80339f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8033a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033a7:	8b 40 04             	mov    0x4(%eax),%eax
  8033aa:	85 c0                	test   %eax,%eax
  8033ac:	74 0f                	je     8033bd <insert_sorted_with_merge_freeList+0x12a>
  8033ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033b1:	8b 40 04             	mov    0x4(%eax),%eax
  8033b4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8033b7:	8b 12                	mov    (%edx),%edx
  8033b9:	89 10                	mov    %edx,(%eax)
  8033bb:	eb 0a                	jmp    8033c7 <insert_sorted_with_merge_freeList+0x134>
  8033bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033c0:	8b 00                	mov    (%eax),%eax
  8033c2:	a3 38 51 80 00       	mov    %eax,0x805138
  8033c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033ca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033d3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033da:	a1 44 51 80 00       	mov    0x805144,%eax
  8033df:	48                   	dec    %eax
  8033e0:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  8033e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033e8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  8033ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033f2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  8033f9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8033fd:	75 17                	jne    803416 <insert_sorted_with_merge_freeList+0x183>
  8033ff:	83 ec 04             	sub    $0x4,%esp
  803402:	68 9c 45 80 00       	push   $0x80459c
  803407:	68 3f 01 00 00       	push   $0x13f
  80340c:	68 bf 45 80 00       	push   $0x8045bf
  803411:	e8 f6 d4 ff ff       	call   80090c <_panic>
  803416:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80341c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80341f:	89 10                	mov    %edx,(%eax)
  803421:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803424:	8b 00                	mov    (%eax),%eax
  803426:	85 c0                	test   %eax,%eax
  803428:	74 0d                	je     803437 <insert_sorted_with_merge_freeList+0x1a4>
  80342a:	a1 48 51 80 00       	mov    0x805148,%eax
  80342f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803432:	89 50 04             	mov    %edx,0x4(%eax)
  803435:	eb 08                	jmp    80343f <insert_sorted_with_merge_freeList+0x1ac>
  803437:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80343a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80343f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803442:	a3 48 51 80 00       	mov    %eax,0x805148
  803447:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80344a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803451:	a1 54 51 80 00       	mov    0x805154,%eax
  803456:	40                   	inc    %eax
  803457:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80345c:	e9 7a 05 00 00       	jmp    8039db <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  803461:	8b 45 08             	mov    0x8(%ebp),%eax
  803464:	8b 50 08             	mov    0x8(%eax),%edx
  803467:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80346a:	8b 40 08             	mov    0x8(%eax),%eax
  80346d:	39 c2                	cmp    %eax,%edx
  80346f:	0f 82 14 01 00 00    	jb     803589 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  803475:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803478:	8b 50 08             	mov    0x8(%eax),%edx
  80347b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80347e:	8b 40 0c             	mov    0xc(%eax),%eax
  803481:	01 c2                	add    %eax,%edx
  803483:	8b 45 08             	mov    0x8(%ebp),%eax
  803486:	8b 40 08             	mov    0x8(%eax),%eax
  803489:	39 c2                	cmp    %eax,%edx
  80348b:	0f 85 90 00 00 00    	jne    803521 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  803491:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803494:	8b 50 0c             	mov    0xc(%eax),%edx
  803497:	8b 45 08             	mov    0x8(%ebp),%eax
  80349a:	8b 40 0c             	mov    0xc(%eax),%eax
  80349d:	01 c2                	add    %eax,%edx
  80349f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034a2:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  8034a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  8034af:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8034b9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034bd:	75 17                	jne    8034d6 <insert_sorted_with_merge_freeList+0x243>
  8034bf:	83 ec 04             	sub    $0x4,%esp
  8034c2:	68 9c 45 80 00       	push   $0x80459c
  8034c7:	68 49 01 00 00       	push   $0x149
  8034cc:	68 bf 45 80 00       	push   $0x8045bf
  8034d1:	e8 36 d4 ff ff       	call   80090c <_panic>
  8034d6:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8034dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8034df:	89 10                	mov    %edx,(%eax)
  8034e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e4:	8b 00                	mov    (%eax),%eax
  8034e6:	85 c0                	test   %eax,%eax
  8034e8:	74 0d                	je     8034f7 <insert_sorted_with_merge_freeList+0x264>
  8034ea:	a1 48 51 80 00       	mov    0x805148,%eax
  8034ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8034f2:	89 50 04             	mov    %edx,0x4(%eax)
  8034f5:	eb 08                	jmp    8034ff <insert_sorted_with_merge_freeList+0x26c>
  8034f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8034fa:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8034ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803502:	a3 48 51 80 00       	mov    %eax,0x805148
  803507:	8b 45 08             	mov    0x8(%ebp),%eax
  80350a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803511:	a1 54 51 80 00       	mov    0x805154,%eax
  803516:	40                   	inc    %eax
  803517:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80351c:	e9 bb 04 00 00       	jmp    8039dc <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803521:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803525:	75 17                	jne    80353e <insert_sorted_with_merge_freeList+0x2ab>
  803527:	83 ec 04             	sub    $0x4,%esp
  80352a:	68 10 46 80 00       	push   $0x804610
  80352f:	68 4c 01 00 00       	push   $0x14c
  803534:	68 bf 45 80 00       	push   $0x8045bf
  803539:	e8 ce d3 ff ff       	call   80090c <_panic>
  80353e:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803544:	8b 45 08             	mov    0x8(%ebp),%eax
  803547:	89 50 04             	mov    %edx,0x4(%eax)
  80354a:	8b 45 08             	mov    0x8(%ebp),%eax
  80354d:	8b 40 04             	mov    0x4(%eax),%eax
  803550:	85 c0                	test   %eax,%eax
  803552:	74 0c                	je     803560 <insert_sorted_with_merge_freeList+0x2cd>
  803554:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803559:	8b 55 08             	mov    0x8(%ebp),%edx
  80355c:	89 10                	mov    %edx,(%eax)
  80355e:	eb 08                	jmp    803568 <insert_sorted_with_merge_freeList+0x2d5>
  803560:	8b 45 08             	mov    0x8(%ebp),%eax
  803563:	a3 38 51 80 00       	mov    %eax,0x805138
  803568:	8b 45 08             	mov    0x8(%ebp),%eax
  80356b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803570:	8b 45 08             	mov    0x8(%ebp),%eax
  803573:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803579:	a1 44 51 80 00       	mov    0x805144,%eax
  80357e:	40                   	inc    %eax
  80357f:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803584:	e9 53 04 00 00       	jmp    8039dc <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803589:	a1 38 51 80 00       	mov    0x805138,%eax
  80358e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803591:	e9 15 04 00 00       	jmp    8039ab <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  803596:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803599:	8b 00                	mov    (%eax),%eax
  80359b:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  80359e:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a1:	8b 50 08             	mov    0x8(%eax),%edx
  8035a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035a7:	8b 40 08             	mov    0x8(%eax),%eax
  8035aa:	39 c2                	cmp    %eax,%edx
  8035ac:	0f 86 f1 03 00 00    	jbe    8039a3 <insert_sorted_with_merge_freeList+0x710>
  8035b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b5:	8b 50 08             	mov    0x8(%eax),%edx
  8035b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035bb:	8b 40 08             	mov    0x8(%eax),%eax
  8035be:	39 c2                	cmp    %eax,%edx
  8035c0:	0f 83 dd 03 00 00    	jae    8039a3 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  8035c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035c9:	8b 50 08             	mov    0x8(%eax),%edx
  8035cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035cf:	8b 40 0c             	mov    0xc(%eax),%eax
  8035d2:	01 c2                	add    %eax,%edx
  8035d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d7:	8b 40 08             	mov    0x8(%eax),%eax
  8035da:	39 c2                	cmp    %eax,%edx
  8035dc:	0f 85 b9 01 00 00    	jne    80379b <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8035e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e5:	8b 50 08             	mov    0x8(%eax),%edx
  8035e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8035eb:	8b 40 0c             	mov    0xc(%eax),%eax
  8035ee:	01 c2                	add    %eax,%edx
  8035f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035f3:	8b 40 08             	mov    0x8(%eax),%eax
  8035f6:	39 c2                	cmp    %eax,%edx
  8035f8:	0f 85 0d 01 00 00    	jne    80370b <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  8035fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803601:	8b 50 0c             	mov    0xc(%eax),%edx
  803604:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803607:	8b 40 0c             	mov    0xc(%eax),%eax
  80360a:	01 c2                	add    %eax,%edx
  80360c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80360f:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803612:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803616:	75 17                	jne    80362f <insert_sorted_with_merge_freeList+0x39c>
  803618:	83 ec 04             	sub    $0x4,%esp
  80361b:	68 68 46 80 00       	push   $0x804668
  803620:	68 5c 01 00 00       	push   $0x15c
  803625:	68 bf 45 80 00       	push   $0x8045bf
  80362a:	e8 dd d2 ff ff       	call   80090c <_panic>
  80362f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803632:	8b 00                	mov    (%eax),%eax
  803634:	85 c0                	test   %eax,%eax
  803636:	74 10                	je     803648 <insert_sorted_with_merge_freeList+0x3b5>
  803638:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80363b:	8b 00                	mov    (%eax),%eax
  80363d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803640:	8b 52 04             	mov    0x4(%edx),%edx
  803643:	89 50 04             	mov    %edx,0x4(%eax)
  803646:	eb 0b                	jmp    803653 <insert_sorted_with_merge_freeList+0x3c0>
  803648:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80364b:	8b 40 04             	mov    0x4(%eax),%eax
  80364e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803653:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803656:	8b 40 04             	mov    0x4(%eax),%eax
  803659:	85 c0                	test   %eax,%eax
  80365b:	74 0f                	je     80366c <insert_sorted_with_merge_freeList+0x3d9>
  80365d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803660:	8b 40 04             	mov    0x4(%eax),%eax
  803663:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803666:	8b 12                	mov    (%edx),%edx
  803668:	89 10                	mov    %edx,(%eax)
  80366a:	eb 0a                	jmp    803676 <insert_sorted_with_merge_freeList+0x3e3>
  80366c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80366f:	8b 00                	mov    (%eax),%eax
  803671:	a3 38 51 80 00       	mov    %eax,0x805138
  803676:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803679:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80367f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803682:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803689:	a1 44 51 80 00       	mov    0x805144,%eax
  80368e:	48                   	dec    %eax
  80368f:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803694:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803697:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  80369e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036a1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8036a8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8036ac:	75 17                	jne    8036c5 <insert_sorted_with_merge_freeList+0x432>
  8036ae:	83 ec 04             	sub    $0x4,%esp
  8036b1:	68 9c 45 80 00       	push   $0x80459c
  8036b6:	68 5f 01 00 00       	push   $0x15f
  8036bb:	68 bf 45 80 00       	push   $0x8045bf
  8036c0:	e8 47 d2 ff ff       	call   80090c <_panic>
  8036c5:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8036cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036ce:	89 10                	mov    %edx,(%eax)
  8036d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036d3:	8b 00                	mov    (%eax),%eax
  8036d5:	85 c0                	test   %eax,%eax
  8036d7:	74 0d                	je     8036e6 <insert_sorted_with_merge_freeList+0x453>
  8036d9:	a1 48 51 80 00       	mov    0x805148,%eax
  8036de:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8036e1:	89 50 04             	mov    %edx,0x4(%eax)
  8036e4:	eb 08                	jmp    8036ee <insert_sorted_with_merge_freeList+0x45b>
  8036e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036e9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8036ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036f1:	a3 48 51 80 00       	mov    %eax,0x805148
  8036f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036f9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803700:	a1 54 51 80 00       	mov    0x805154,%eax
  803705:	40                   	inc    %eax
  803706:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  80370b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80370e:	8b 50 0c             	mov    0xc(%eax),%edx
  803711:	8b 45 08             	mov    0x8(%ebp),%eax
  803714:	8b 40 0c             	mov    0xc(%eax),%eax
  803717:	01 c2                	add    %eax,%edx
  803719:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80371c:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  80371f:	8b 45 08             	mov    0x8(%ebp),%eax
  803722:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803729:	8b 45 08             	mov    0x8(%ebp),%eax
  80372c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803733:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803737:	75 17                	jne    803750 <insert_sorted_with_merge_freeList+0x4bd>
  803739:	83 ec 04             	sub    $0x4,%esp
  80373c:	68 9c 45 80 00       	push   $0x80459c
  803741:	68 64 01 00 00       	push   $0x164
  803746:	68 bf 45 80 00       	push   $0x8045bf
  80374b:	e8 bc d1 ff ff       	call   80090c <_panic>
  803750:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803756:	8b 45 08             	mov    0x8(%ebp),%eax
  803759:	89 10                	mov    %edx,(%eax)
  80375b:	8b 45 08             	mov    0x8(%ebp),%eax
  80375e:	8b 00                	mov    (%eax),%eax
  803760:	85 c0                	test   %eax,%eax
  803762:	74 0d                	je     803771 <insert_sorted_with_merge_freeList+0x4de>
  803764:	a1 48 51 80 00       	mov    0x805148,%eax
  803769:	8b 55 08             	mov    0x8(%ebp),%edx
  80376c:	89 50 04             	mov    %edx,0x4(%eax)
  80376f:	eb 08                	jmp    803779 <insert_sorted_with_merge_freeList+0x4e6>
  803771:	8b 45 08             	mov    0x8(%ebp),%eax
  803774:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803779:	8b 45 08             	mov    0x8(%ebp),%eax
  80377c:	a3 48 51 80 00       	mov    %eax,0x805148
  803781:	8b 45 08             	mov    0x8(%ebp),%eax
  803784:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80378b:	a1 54 51 80 00       	mov    0x805154,%eax
  803790:	40                   	inc    %eax
  803791:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803796:	e9 41 02 00 00       	jmp    8039dc <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80379b:	8b 45 08             	mov    0x8(%ebp),%eax
  80379e:	8b 50 08             	mov    0x8(%eax),%edx
  8037a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a4:	8b 40 0c             	mov    0xc(%eax),%eax
  8037a7:	01 c2                	add    %eax,%edx
  8037a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037ac:	8b 40 08             	mov    0x8(%eax),%eax
  8037af:	39 c2                	cmp    %eax,%edx
  8037b1:	0f 85 7c 01 00 00    	jne    803933 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8037b7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8037bb:	74 06                	je     8037c3 <insert_sorted_with_merge_freeList+0x530>
  8037bd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037c1:	75 17                	jne    8037da <insert_sorted_with_merge_freeList+0x547>
  8037c3:	83 ec 04             	sub    $0x4,%esp
  8037c6:	68 d8 45 80 00       	push   $0x8045d8
  8037cb:	68 69 01 00 00       	push   $0x169
  8037d0:	68 bf 45 80 00       	push   $0x8045bf
  8037d5:	e8 32 d1 ff ff       	call   80090c <_panic>
  8037da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037dd:	8b 50 04             	mov    0x4(%eax),%edx
  8037e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8037e3:	89 50 04             	mov    %edx,0x4(%eax)
  8037e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8037e9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8037ec:	89 10                	mov    %edx,(%eax)
  8037ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037f1:	8b 40 04             	mov    0x4(%eax),%eax
  8037f4:	85 c0                	test   %eax,%eax
  8037f6:	74 0d                	je     803805 <insert_sorted_with_merge_freeList+0x572>
  8037f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037fb:	8b 40 04             	mov    0x4(%eax),%eax
  8037fe:	8b 55 08             	mov    0x8(%ebp),%edx
  803801:	89 10                	mov    %edx,(%eax)
  803803:	eb 08                	jmp    80380d <insert_sorted_with_merge_freeList+0x57a>
  803805:	8b 45 08             	mov    0x8(%ebp),%eax
  803808:	a3 38 51 80 00       	mov    %eax,0x805138
  80380d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803810:	8b 55 08             	mov    0x8(%ebp),%edx
  803813:	89 50 04             	mov    %edx,0x4(%eax)
  803816:	a1 44 51 80 00       	mov    0x805144,%eax
  80381b:	40                   	inc    %eax
  80381c:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803821:	8b 45 08             	mov    0x8(%ebp),%eax
  803824:	8b 50 0c             	mov    0xc(%eax),%edx
  803827:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80382a:	8b 40 0c             	mov    0xc(%eax),%eax
  80382d:	01 c2                	add    %eax,%edx
  80382f:	8b 45 08             	mov    0x8(%ebp),%eax
  803832:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803835:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803839:	75 17                	jne    803852 <insert_sorted_with_merge_freeList+0x5bf>
  80383b:	83 ec 04             	sub    $0x4,%esp
  80383e:	68 68 46 80 00       	push   $0x804668
  803843:	68 6b 01 00 00       	push   $0x16b
  803848:	68 bf 45 80 00       	push   $0x8045bf
  80384d:	e8 ba d0 ff ff       	call   80090c <_panic>
  803852:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803855:	8b 00                	mov    (%eax),%eax
  803857:	85 c0                	test   %eax,%eax
  803859:	74 10                	je     80386b <insert_sorted_with_merge_freeList+0x5d8>
  80385b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80385e:	8b 00                	mov    (%eax),%eax
  803860:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803863:	8b 52 04             	mov    0x4(%edx),%edx
  803866:	89 50 04             	mov    %edx,0x4(%eax)
  803869:	eb 0b                	jmp    803876 <insert_sorted_with_merge_freeList+0x5e3>
  80386b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80386e:	8b 40 04             	mov    0x4(%eax),%eax
  803871:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803876:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803879:	8b 40 04             	mov    0x4(%eax),%eax
  80387c:	85 c0                	test   %eax,%eax
  80387e:	74 0f                	je     80388f <insert_sorted_with_merge_freeList+0x5fc>
  803880:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803883:	8b 40 04             	mov    0x4(%eax),%eax
  803886:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803889:	8b 12                	mov    (%edx),%edx
  80388b:	89 10                	mov    %edx,(%eax)
  80388d:	eb 0a                	jmp    803899 <insert_sorted_with_merge_freeList+0x606>
  80388f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803892:	8b 00                	mov    (%eax),%eax
  803894:	a3 38 51 80 00       	mov    %eax,0x805138
  803899:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80389c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038a5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038ac:	a1 44 51 80 00       	mov    0x805144,%eax
  8038b1:	48                   	dec    %eax
  8038b2:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  8038b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038ba:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8038c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038c4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8038cb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8038cf:	75 17                	jne    8038e8 <insert_sorted_with_merge_freeList+0x655>
  8038d1:	83 ec 04             	sub    $0x4,%esp
  8038d4:	68 9c 45 80 00       	push   $0x80459c
  8038d9:	68 6e 01 00 00       	push   $0x16e
  8038de:	68 bf 45 80 00       	push   $0x8045bf
  8038e3:	e8 24 d0 ff ff       	call   80090c <_panic>
  8038e8:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8038ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038f1:	89 10                	mov    %edx,(%eax)
  8038f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038f6:	8b 00                	mov    (%eax),%eax
  8038f8:	85 c0                	test   %eax,%eax
  8038fa:	74 0d                	je     803909 <insert_sorted_with_merge_freeList+0x676>
  8038fc:	a1 48 51 80 00       	mov    0x805148,%eax
  803901:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803904:	89 50 04             	mov    %edx,0x4(%eax)
  803907:	eb 08                	jmp    803911 <insert_sorted_with_merge_freeList+0x67e>
  803909:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80390c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803911:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803914:	a3 48 51 80 00       	mov    %eax,0x805148
  803919:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80391c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803923:	a1 54 51 80 00       	mov    0x805154,%eax
  803928:	40                   	inc    %eax
  803929:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80392e:	e9 a9 00 00 00       	jmp    8039dc <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803933:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803937:	74 06                	je     80393f <insert_sorted_with_merge_freeList+0x6ac>
  803939:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80393d:	75 17                	jne    803956 <insert_sorted_with_merge_freeList+0x6c3>
  80393f:	83 ec 04             	sub    $0x4,%esp
  803942:	68 34 46 80 00       	push   $0x804634
  803947:	68 73 01 00 00       	push   $0x173
  80394c:	68 bf 45 80 00       	push   $0x8045bf
  803951:	e8 b6 cf ff ff       	call   80090c <_panic>
  803956:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803959:	8b 10                	mov    (%eax),%edx
  80395b:	8b 45 08             	mov    0x8(%ebp),%eax
  80395e:	89 10                	mov    %edx,(%eax)
  803960:	8b 45 08             	mov    0x8(%ebp),%eax
  803963:	8b 00                	mov    (%eax),%eax
  803965:	85 c0                	test   %eax,%eax
  803967:	74 0b                	je     803974 <insert_sorted_with_merge_freeList+0x6e1>
  803969:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80396c:	8b 00                	mov    (%eax),%eax
  80396e:	8b 55 08             	mov    0x8(%ebp),%edx
  803971:	89 50 04             	mov    %edx,0x4(%eax)
  803974:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803977:	8b 55 08             	mov    0x8(%ebp),%edx
  80397a:	89 10                	mov    %edx,(%eax)
  80397c:	8b 45 08             	mov    0x8(%ebp),%eax
  80397f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803982:	89 50 04             	mov    %edx,0x4(%eax)
  803985:	8b 45 08             	mov    0x8(%ebp),%eax
  803988:	8b 00                	mov    (%eax),%eax
  80398a:	85 c0                	test   %eax,%eax
  80398c:	75 08                	jne    803996 <insert_sorted_with_merge_freeList+0x703>
  80398e:	8b 45 08             	mov    0x8(%ebp),%eax
  803991:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803996:	a1 44 51 80 00       	mov    0x805144,%eax
  80399b:	40                   	inc    %eax
  80399c:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  8039a1:	eb 39                	jmp    8039dc <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8039a3:	a1 40 51 80 00       	mov    0x805140,%eax
  8039a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8039ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8039af:	74 07                	je     8039b8 <insert_sorted_with_merge_freeList+0x725>
  8039b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039b4:	8b 00                	mov    (%eax),%eax
  8039b6:	eb 05                	jmp    8039bd <insert_sorted_with_merge_freeList+0x72a>
  8039b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8039bd:	a3 40 51 80 00       	mov    %eax,0x805140
  8039c2:	a1 40 51 80 00       	mov    0x805140,%eax
  8039c7:	85 c0                	test   %eax,%eax
  8039c9:	0f 85 c7 fb ff ff    	jne    803596 <insert_sorted_with_merge_freeList+0x303>
  8039cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8039d3:	0f 85 bd fb ff ff    	jne    803596 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8039d9:	eb 01                	jmp    8039dc <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8039db:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8039dc:	90                   	nop
  8039dd:	c9                   	leave  
  8039de:	c3                   	ret    
  8039df:	90                   	nop

008039e0 <__udivdi3>:
  8039e0:	55                   	push   %ebp
  8039e1:	57                   	push   %edi
  8039e2:	56                   	push   %esi
  8039e3:	53                   	push   %ebx
  8039e4:	83 ec 1c             	sub    $0x1c,%esp
  8039e7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8039eb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8039ef:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8039f3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8039f7:	89 ca                	mov    %ecx,%edx
  8039f9:	89 f8                	mov    %edi,%eax
  8039fb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8039ff:	85 f6                	test   %esi,%esi
  803a01:	75 2d                	jne    803a30 <__udivdi3+0x50>
  803a03:	39 cf                	cmp    %ecx,%edi
  803a05:	77 65                	ja     803a6c <__udivdi3+0x8c>
  803a07:	89 fd                	mov    %edi,%ebp
  803a09:	85 ff                	test   %edi,%edi
  803a0b:	75 0b                	jne    803a18 <__udivdi3+0x38>
  803a0d:	b8 01 00 00 00       	mov    $0x1,%eax
  803a12:	31 d2                	xor    %edx,%edx
  803a14:	f7 f7                	div    %edi
  803a16:	89 c5                	mov    %eax,%ebp
  803a18:	31 d2                	xor    %edx,%edx
  803a1a:	89 c8                	mov    %ecx,%eax
  803a1c:	f7 f5                	div    %ebp
  803a1e:	89 c1                	mov    %eax,%ecx
  803a20:	89 d8                	mov    %ebx,%eax
  803a22:	f7 f5                	div    %ebp
  803a24:	89 cf                	mov    %ecx,%edi
  803a26:	89 fa                	mov    %edi,%edx
  803a28:	83 c4 1c             	add    $0x1c,%esp
  803a2b:	5b                   	pop    %ebx
  803a2c:	5e                   	pop    %esi
  803a2d:	5f                   	pop    %edi
  803a2e:	5d                   	pop    %ebp
  803a2f:	c3                   	ret    
  803a30:	39 ce                	cmp    %ecx,%esi
  803a32:	77 28                	ja     803a5c <__udivdi3+0x7c>
  803a34:	0f bd fe             	bsr    %esi,%edi
  803a37:	83 f7 1f             	xor    $0x1f,%edi
  803a3a:	75 40                	jne    803a7c <__udivdi3+0x9c>
  803a3c:	39 ce                	cmp    %ecx,%esi
  803a3e:	72 0a                	jb     803a4a <__udivdi3+0x6a>
  803a40:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803a44:	0f 87 9e 00 00 00    	ja     803ae8 <__udivdi3+0x108>
  803a4a:	b8 01 00 00 00       	mov    $0x1,%eax
  803a4f:	89 fa                	mov    %edi,%edx
  803a51:	83 c4 1c             	add    $0x1c,%esp
  803a54:	5b                   	pop    %ebx
  803a55:	5e                   	pop    %esi
  803a56:	5f                   	pop    %edi
  803a57:	5d                   	pop    %ebp
  803a58:	c3                   	ret    
  803a59:	8d 76 00             	lea    0x0(%esi),%esi
  803a5c:	31 ff                	xor    %edi,%edi
  803a5e:	31 c0                	xor    %eax,%eax
  803a60:	89 fa                	mov    %edi,%edx
  803a62:	83 c4 1c             	add    $0x1c,%esp
  803a65:	5b                   	pop    %ebx
  803a66:	5e                   	pop    %esi
  803a67:	5f                   	pop    %edi
  803a68:	5d                   	pop    %ebp
  803a69:	c3                   	ret    
  803a6a:	66 90                	xchg   %ax,%ax
  803a6c:	89 d8                	mov    %ebx,%eax
  803a6e:	f7 f7                	div    %edi
  803a70:	31 ff                	xor    %edi,%edi
  803a72:	89 fa                	mov    %edi,%edx
  803a74:	83 c4 1c             	add    $0x1c,%esp
  803a77:	5b                   	pop    %ebx
  803a78:	5e                   	pop    %esi
  803a79:	5f                   	pop    %edi
  803a7a:	5d                   	pop    %ebp
  803a7b:	c3                   	ret    
  803a7c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803a81:	89 eb                	mov    %ebp,%ebx
  803a83:	29 fb                	sub    %edi,%ebx
  803a85:	89 f9                	mov    %edi,%ecx
  803a87:	d3 e6                	shl    %cl,%esi
  803a89:	89 c5                	mov    %eax,%ebp
  803a8b:	88 d9                	mov    %bl,%cl
  803a8d:	d3 ed                	shr    %cl,%ebp
  803a8f:	89 e9                	mov    %ebp,%ecx
  803a91:	09 f1                	or     %esi,%ecx
  803a93:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803a97:	89 f9                	mov    %edi,%ecx
  803a99:	d3 e0                	shl    %cl,%eax
  803a9b:	89 c5                	mov    %eax,%ebp
  803a9d:	89 d6                	mov    %edx,%esi
  803a9f:	88 d9                	mov    %bl,%cl
  803aa1:	d3 ee                	shr    %cl,%esi
  803aa3:	89 f9                	mov    %edi,%ecx
  803aa5:	d3 e2                	shl    %cl,%edx
  803aa7:	8b 44 24 08          	mov    0x8(%esp),%eax
  803aab:	88 d9                	mov    %bl,%cl
  803aad:	d3 e8                	shr    %cl,%eax
  803aaf:	09 c2                	or     %eax,%edx
  803ab1:	89 d0                	mov    %edx,%eax
  803ab3:	89 f2                	mov    %esi,%edx
  803ab5:	f7 74 24 0c          	divl   0xc(%esp)
  803ab9:	89 d6                	mov    %edx,%esi
  803abb:	89 c3                	mov    %eax,%ebx
  803abd:	f7 e5                	mul    %ebp
  803abf:	39 d6                	cmp    %edx,%esi
  803ac1:	72 19                	jb     803adc <__udivdi3+0xfc>
  803ac3:	74 0b                	je     803ad0 <__udivdi3+0xf0>
  803ac5:	89 d8                	mov    %ebx,%eax
  803ac7:	31 ff                	xor    %edi,%edi
  803ac9:	e9 58 ff ff ff       	jmp    803a26 <__udivdi3+0x46>
  803ace:	66 90                	xchg   %ax,%ax
  803ad0:	8b 54 24 08          	mov    0x8(%esp),%edx
  803ad4:	89 f9                	mov    %edi,%ecx
  803ad6:	d3 e2                	shl    %cl,%edx
  803ad8:	39 c2                	cmp    %eax,%edx
  803ada:	73 e9                	jae    803ac5 <__udivdi3+0xe5>
  803adc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803adf:	31 ff                	xor    %edi,%edi
  803ae1:	e9 40 ff ff ff       	jmp    803a26 <__udivdi3+0x46>
  803ae6:	66 90                	xchg   %ax,%ax
  803ae8:	31 c0                	xor    %eax,%eax
  803aea:	e9 37 ff ff ff       	jmp    803a26 <__udivdi3+0x46>
  803aef:	90                   	nop

00803af0 <__umoddi3>:
  803af0:	55                   	push   %ebp
  803af1:	57                   	push   %edi
  803af2:	56                   	push   %esi
  803af3:	53                   	push   %ebx
  803af4:	83 ec 1c             	sub    $0x1c,%esp
  803af7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803afb:	8b 74 24 34          	mov    0x34(%esp),%esi
  803aff:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b03:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803b07:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803b0b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803b0f:	89 f3                	mov    %esi,%ebx
  803b11:	89 fa                	mov    %edi,%edx
  803b13:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803b17:	89 34 24             	mov    %esi,(%esp)
  803b1a:	85 c0                	test   %eax,%eax
  803b1c:	75 1a                	jne    803b38 <__umoddi3+0x48>
  803b1e:	39 f7                	cmp    %esi,%edi
  803b20:	0f 86 a2 00 00 00    	jbe    803bc8 <__umoddi3+0xd8>
  803b26:	89 c8                	mov    %ecx,%eax
  803b28:	89 f2                	mov    %esi,%edx
  803b2a:	f7 f7                	div    %edi
  803b2c:	89 d0                	mov    %edx,%eax
  803b2e:	31 d2                	xor    %edx,%edx
  803b30:	83 c4 1c             	add    $0x1c,%esp
  803b33:	5b                   	pop    %ebx
  803b34:	5e                   	pop    %esi
  803b35:	5f                   	pop    %edi
  803b36:	5d                   	pop    %ebp
  803b37:	c3                   	ret    
  803b38:	39 f0                	cmp    %esi,%eax
  803b3a:	0f 87 ac 00 00 00    	ja     803bec <__umoddi3+0xfc>
  803b40:	0f bd e8             	bsr    %eax,%ebp
  803b43:	83 f5 1f             	xor    $0x1f,%ebp
  803b46:	0f 84 ac 00 00 00    	je     803bf8 <__umoddi3+0x108>
  803b4c:	bf 20 00 00 00       	mov    $0x20,%edi
  803b51:	29 ef                	sub    %ebp,%edi
  803b53:	89 fe                	mov    %edi,%esi
  803b55:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803b59:	89 e9                	mov    %ebp,%ecx
  803b5b:	d3 e0                	shl    %cl,%eax
  803b5d:	89 d7                	mov    %edx,%edi
  803b5f:	89 f1                	mov    %esi,%ecx
  803b61:	d3 ef                	shr    %cl,%edi
  803b63:	09 c7                	or     %eax,%edi
  803b65:	89 e9                	mov    %ebp,%ecx
  803b67:	d3 e2                	shl    %cl,%edx
  803b69:	89 14 24             	mov    %edx,(%esp)
  803b6c:	89 d8                	mov    %ebx,%eax
  803b6e:	d3 e0                	shl    %cl,%eax
  803b70:	89 c2                	mov    %eax,%edx
  803b72:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b76:	d3 e0                	shl    %cl,%eax
  803b78:	89 44 24 04          	mov    %eax,0x4(%esp)
  803b7c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b80:	89 f1                	mov    %esi,%ecx
  803b82:	d3 e8                	shr    %cl,%eax
  803b84:	09 d0                	or     %edx,%eax
  803b86:	d3 eb                	shr    %cl,%ebx
  803b88:	89 da                	mov    %ebx,%edx
  803b8a:	f7 f7                	div    %edi
  803b8c:	89 d3                	mov    %edx,%ebx
  803b8e:	f7 24 24             	mull   (%esp)
  803b91:	89 c6                	mov    %eax,%esi
  803b93:	89 d1                	mov    %edx,%ecx
  803b95:	39 d3                	cmp    %edx,%ebx
  803b97:	0f 82 87 00 00 00    	jb     803c24 <__umoddi3+0x134>
  803b9d:	0f 84 91 00 00 00    	je     803c34 <__umoddi3+0x144>
  803ba3:	8b 54 24 04          	mov    0x4(%esp),%edx
  803ba7:	29 f2                	sub    %esi,%edx
  803ba9:	19 cb                	sbb    %ecx,%ebx
  803bab:	89 d8                	mov    %ebx,%eax
  803bad:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803bb1:	d3 e0                	shl    %cl,%eax
  803bb3:	89 e9                	mov    %ebp,%ecx
  803bb5:	d3 ea                	shr    %cl,%edx
  803bb7:	09 d0                	or     %edx,%eax
  803bb9:	89 e9                	mov    %ebp,%ecx
  803bbb:	d3 eb                	shr    %cl,%ebx
  803bbd:	89 da                	mov    %ebx,%edx
  803bbf:	83 c4 1c             	add    $0x1c,%esp
  803bc2:	5b                   	pop    %ebx
  803bc3:	5e                   	pop    %esi
  803bc4:	5f                   	pop    %edi
  803bc5:	5d                   	pop    %ebp
  803bc6:	c3                   	ret    
  803bc7:	90                   	nop
  803bc8:	89 fd                	mov    %edi,%ebp
  803bca:	85 ff                	test   %edi,%edi
  803bcc:	75 0b                	jne    803bd9 <__umoddi3+0xe9>
  803bce:	b8 01 00 00 00       	mov    $0x1,%eax
  803bd3:	31 d2                	xor    %edx,%edx
  803bd5:	f7 f7                	div    %edi
  803bd7:	89 c5                	mov    %eax,%ebp
  803bd9:	89 f0                	mov    %esi,%eax
  803bdb:	31 d2                	xor    %edx,%edx
  803bdd:	f7 f5                	div    %ebp
  803bdf:	89 c8                	mov    %ecx,%eax
  803be1:	f7 f5                	div    %ebp
  803be3:	89 d0                	mov    %edx,%eax
  803be5:	e9 44 ff ff ff       	jmp    803b2e <__umoddi3+0x3e>
  803bea:	66 90                	xchg   %ax,%ax
  803bec:	89 c8                	mov    %ecx,%eax
  803bee:	89 f2                	mov    %esi,%edx
  803bf0:	83 c4 1c             	add    $0x1c,%esp
  803bf3:	5b                   	pop    %ebx
  803bf4:	5e                   	pop    %esi
  803bf5:	5f                   	pop    %edi
  803bf6:	5d                   	pop    %ebp
  803bf7:	c3                   	ret    
  803bf8:	3b 04 24             	cmp    (%esp),%eax
  803bfb:	72 06                	jb     803c03 <__umoddi3+0x113>
  803bfd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803c01:	77 0f                	ja     803c12 <__umoddi3+0x122>
  803c03:	89 f2                	mov    %esi,%edx
  803c05:	29 f9                	sub    %edi,%ecx
  803c07:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803c0b:	89 14 24             	mov    %edx,(%esp)
  803c0e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c12:	8b 44 24 04          	mov    0x4(%esp),%eax
  803c16:	8b 14 24             	mov    (%esp),%edx
  803c19:	83 c4 1c             	add    $0x1c,%esp
  803c1c:	5b                   	pop    %ebx
  803c1d:	5e                   	pop    %esi
  803c1e:	5f                   	pop    %edi
  803c1f:	5d                   	pop    %ebp
  803c20:	c3                   	ret    
  803c21:	8d 76 00             	lea    0x0(%esi),%esi
  803c24:	2b 04 24             	sub    (%esp),%eax
  803c27:	19 fa                	sbb    %edi,%edx
  803c29:	89 d1                	mov    %edx,%ecx
  803c2b:	89 c6                	mov    %eax,%esi
  803c2d:	e9 71 ff ff ff       	jmp    803ba3 <__umoddi3+0xb3>
  803c32:	66 90                	xchg   %ax,%ax
  803c34:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803c38:	72 ea                	jb     803c24 <__umoddi3+0x134>
  803c3a:	89 d9                	mov    %ebx,%ecx
  803c3c:	e9 62 ff ff ff       	jmp    803ba3 <__umoddi3+0xb3>
