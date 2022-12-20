
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
  80004b:	e8 02 20 00 00       	call   802052 <sys_disable_interrupt>

		cprintf("\n");
  800050:	83 ec 0c             	sub    $0xc,%esp
  800053:	68 a0 3d 80 00       	push   $0x803da0
  800058:	e8 63 0b 00 00       	call   800bc0 <cprintf>
  80005d:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800060:	83 ec 0c             	sub    $0xc,%esp
  800063:	68 a2 3d 80 00       	push   $0x803da2
  800068:	e8 53 0b 00 00       	call   800bc0 <cprintf>
  80006d:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!! MERGE SORT !!!!\n");
  800070:	83 ec 0c             	sub    $0xc,%esp
  800073:	68 b8 3d 80 00       	push   $0x803db8
  800078:	e8 43 0b 00 00       	call   800bc0 <cprintf>
  80007d:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800080:	83 ec 0c             	sub    $0xc,%esp
  800083:	68 a2 3d 80 00       	push   $0x803da2
  800088:	e8 33 0b 00 00       	call   800bc0 <cprintf>
  80008d:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800090:	83 ec 0c             	sub    $0xc,%esp
  800093:	68 a0 3d 80 00       	push   $0x803da0
  800098:	e8 23 0b 00 00       	call   800bc0 <cprintf>
  80009d:	83 c4 10             	add    $0x10,%esp
		cprintf("Enter the number of elements: ");
  8000a0:	83 ec 0c             	sub    $0xc,%esp
  8000a3:	68 d0 3d 80 00       	push   $0x803dd0
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
  8000d2:	68 ef 3d 80 00       	push   $0x803def
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
  8000f7:	68 f4 3d 80 00       	push   $0x803df4
  8000fc:	e8 bf 0a 00 00       	call   800bc0 <cprintf>
  800101:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  800104:	83 ec 0c             	sub    $0xc,%esp
  800107:	68 16 3e 80 00       	push   $0x803e16
  80010c:	e8 af 0a 00 00       	call   800bc0 <cprintf>
  800111:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  800114:	83 ec 0c             	sub    $0xc,%esp
  800117:	68 24 3e 80 00       	push   $0x803e24
  80011c:	e8 9f 0a 00 00       	call   800bc0 <cprintf>
  800121:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  800124:	83 ec 0c             	sub    $0xc,%esp
  800127:	68 33 3e 80 00       	push   $0x803e33
  80012c:	e8 8f 0a 00 00       	call   800bc0 <cprintf>
  800131:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  800134:	83 ec 0c             	sub    $0xc,%esp
  800137:	68 43 3e 80 00       	push   $0x803e43
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
  800189:	e8 de 1e 00 00       	call   80206c <sys_enable_interrupt>

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
  8001fe:	e8 4f 1e 00 00       	call   802052 <sys_disable_interrupt>
		cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  800203:	83 ec 0c             	sub    $0xc,%esp
  800206:	68 4c 3e 80 00       	push   $0x803e4c
  80020b:	e8 b0 09 00 00       	call   800bc0 <cprintf>
  800210:	83 c4 10             	add    $0x10,%esp
		//PrintElements(Elements, NumOfElements);
		sys_enable_interrupt();
  800213:	e8 54 1e 00 00       	call   80206c <sys_enable_interrupt>

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
  800235:	68 80 3e 80 00       	push   $0x803e80
  80023a:	6a 58                	push   $0x58
  80023c:	68 a2 3e 80 00       	push   $0x803ea2
  800241:	e8 c6 06 00 00       	call   80090c <_panic>
		else
		{
			sys_disable_interrupt();
  800246:	e8 07 1e 00 00       	call   802052 <sys_disable_interrupt>
			cprintf("===============================================\n") ;
  80024b:	83 ec 0c             	sub    $0xc,%esp
  80024e:	68 c0 3e 80 00       	push   $0x803ec0
  800253:	e8 68 09 00 00       	call   800bc0 <cprintf>
  800258:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  80025b:	83 ec 0c             	sub    $0xc,%esp
  80025e:	68 f4 3e 80 00       	push   $0x803ef4
  800263:	e8 58 09 00 00       	call   800bc0 <cprintf>
  800268:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  80026b:	83 ec 0c             	sub    $0xc,%esp
  80026e:	68 28 3f 80 00       	push   $0x803f28
  800273:	e8 48 09 00 00       	call   800bc0 <cprintf>
  800278:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  80027b:	e8 ec 1d 00 00       	call   80206c <sys_enable_interrupt>
		}

		//free(Elements) ;

		sys_disable_interrupt();
  800280:	e8 cd 1d 00 00       	call   802052 <sys_disable_interrupt>
		Chose = 0 ;
  800285:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
		while (Chose != 'y' && Chose != 'n')
  800289:	eb 50                	jmp    8002db <_main+0x2a3>
		{
			cprintf("Do you want to repeat (y/n): ") ;
  80028b:	83 ec 0c             	sub    $0xc,%esp
  80028e:	68 5a 3f 80 00       	push   $0x803f5a
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
  8002e7:	e8 80 1d 00 00       	call   80206c <sys_enable_interrupt>

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
  80047b:	68 a0 3d 80 00       	push   $0x803da0
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
  80049d:	68 78 3f 80 00       	push   $0x803f78
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
  8004cb:	68 ef 3d 80 00       	push   $0x803def
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
  800744:	e8 3d 19 00 00       	call   802086 <sys_cputc>
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
  800755:	e8 f8 18 00 00       	call   802052 <sys_disable_interrupt>
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
  800768:	e8 19 19 00 00       	call   802086 <sys_cputc>
  80076d:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800770:	e8 f7 18 00 00       	call   80206c <sys_enable_interrupt>
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
  800787:	e8 41 17 00 00       	call   801ecd <sys_cgetc>
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
  8007a0:	e8 ad 18 00 00       	call   802052 <sys_disable_interrupt>
	int c=0;
  8007a5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8007ac:	eb 08                	jmp    8007b6 <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  8007ae:	e8 1a 17 00 00       	call   801ecd <sys_cgetc>
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
  8007bc:	e8 ab 18 00 00       	call   80206c <sys_enable_interrupt>
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
  8007d6:	e8 6a 1a 00 00       	call   802245 <sys_getenvindex>
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
  800841:	e8 0c 18 00 00       	call   802052 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800846:	83 ec 0c             	sub    $0xc,%esp
  800849:	68 98 3f 80 00       	push   $0x803f98
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
  800871:	68 c0 3f 80 00       	push   $0x803fc0
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
  8008a2:	68 e8 3f 80 00       	push   $0x803fe8
  8008a7:	e8 14 03 00 00       	call   800bc0 <cprintf>
  8008ac:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8008af:	a1 24 50 80 00       	mov    0x805024,%eax
  8008b4:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8008ba:	83 ec 08             	sub    $0x8,%esp
  8008bd:	50                   	push   %eax
  8008be:	68 40 40 80 00       	push   $0x804040
  8008c3:	e8 f8 02 00 00       	call   800bc0 <cprintf>
  8008c8:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8008cb:	83 ec 0c             	sub    $0xc,%esp
  8008ce:	68 98 3f 80 00       	push   $0x803f98
  8008d3:	e8 e8 02 00 00       	call   800bc0 <cprintf>
  8008d8:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8008db:	e8 8c 17 00 00       	call   80206c <sys_enable_interrupt>

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
  8008f3:	e8 19 19 00 00       	call   802211 <sys_destroy_env>
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
  800904:	e8 6e 19 00 00       	call   802277 <sys_exit_env>
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
  80092d:	68 54 40 80 00       	push   $0x804054
  800932:	e8 89 02 00 00       	call   800bc0 <cprintf>
  800937:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80093a:	a1 00 50 80 00       	mov    0x805000,%eax
  80093f:	ff 75 0c             	pushl  0xc(%ebp)
  800942:	ff 75 08             	pushl  0x8(%ebp)
  800945:	50                   	push   %eax
  800946:	68 59 40 80 00       	push   $0x804059
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
  80096a:	68 75 40 80 00       	push   $0x804075
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
  800996:	68 78 40 80 00       	push   $0x804078
  80099b:	6a 26                	push   $0x26
  80099d:	68 c4 40 80 00       	push   $0x8040c4
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
  800a68:	68 d0 40 80 00       	push   $0x8040d0
  800a6d:	6a 3a                	push   $0x3a
  800a6f:	68 c4 40 80 00       	push   $0x8040c4
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
  800ad8:	68 24 41 80 00       	push   $0x804124
  800add:	6a 44                	push   $0x44
  800adf:	68 c4 40 80 00       	push   $0x8040c4
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
  800b32:	e8 6d 13 00 00       	call   801ea4 <sys_cputs>
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
  800ba9:	e8 f6 12 00 00       	call   801ea4 <sys_cputs>
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
  800bf3:	e8 5a 14 00 00       	call   802052 <sys_disable_interrupt>
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
  800c13:	e8 54 14 00 00       	call   80206c <sys_enable_interrupt>
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
  800c5d:	e8 c6 2e 00 00       	call   803b28 <__udivdi3>
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
  800cad:	e8 86 2f 00 00       	call   803c38 <__umoddi3>
  800cb2:	83 c4 10             	add    $0x10,%esp
  800cb5:	05 94 43 80 00       	add    $0x804394,%eax
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
  800e08:	8b 04 85 b8 43 80 00 	mov    0x8043b8(,%eax,4),%eax
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
  800ee9:	8b 34 9d 00 42 80 00 	mov    0x804200(,%ebx,4),%esi
  800ef0:	85 f6                	test   %esi,%esi
  800ef2:	75 19                	jne    800f0d <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ef4:	53                   	push   %ebx
  800ef5:	68 a5 43 80 00       	push   $0x8043a5
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
  800f0e:	68 ae 43 80 00       	push   $0x8043ae
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
  800f3b:	be b1 43 80 00       	mov    $0x8043b1,%esi
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
  801961:	68 10 45 80 00       	push   $0x804510
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
  801a31:	e8 b2 05 00 00       	call   801fe8 <sys_allocate_chunk>
  801a36:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801a39:	a1 20 51 80 00       	mov    0x805120,%eax
  801a3e:	83 ec 0c             	sub    $0xc,%esp
  801a41:	50                   	push   %eax
  801a42:	e8 27 0c 00 00       	call   80266e <initialize_MemBlocksList>
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
  801a6f:	68 35 45 80 00       	push   $0x804535
  801a74:	6a 33                	push   $0x33
  801a76:	68 53 45 80 00       	push   $0x804553
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
  801aee:	68 60 45 80 00       	push   $0x804560
  801af3:	6a 34                	push   $0x34
  801af5:	68 53 45 80 00       	push   $0x804553
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
  801b86:	e8 2b 08 00 00       	call   8023b6 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801b8b:	85 c0                	test   %eax,%eax
  801b8d:	74 11                	je     801ba0 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801b8f:	83 ec 0c             	sub    $0xc,%esp
  801b92:	ff 75 e8             	pushl  -0x18(%ebp)
  801b95:	e8 96 0e 00 00       	call   802a30 <alloc_block_FF>
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
  801bac:	e8 f2 0b 00 00       	call   8027a3 <insert_sorted_allocList>
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
  801bc6:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	struct MemBlock * free_block=find_block(&AllocMemBlocksList,(uint32)virtual_address);
  801bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcc:	83 ec 08             	sub    $0x8,%esp
  801bcf:	50                   	push   %eax
  801bd0:	68 40 50 80 00       	push   $0x805040
  801bd5:	e8 71 0b 00 00       	call   80274b <find_block>
  801bda:	83 c4 10             	add    $0x10,%esp
  801bdd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(free_block!=NULL)
  801be0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801be4:	0f 84 a6 00 00 00    	je     801c90 <free+0xcd>
	{
		sys_free_user_mem(free_block->sva,free_block->size);
  801bea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bed:	8b 50 0c             	mov    0xc(%eax),%edx
  801bf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bf3:	8b 40 08             	mov    0x8(%eax),%eax
  801bf6:	83 ec 08             	sub    $0x8,%esp
  801bf9:	52                   	push   %edx
  801bfa:	50                   	push   %eax
  801bfb:	e8 b0 03 00 00       	call   801fb0 <sys_free_user_mem>
  801c00:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,free_block);
  801c03:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c07:	75 14                	jne    801c1d <free+0x5a>
  801c09:	83 ec 04             	sub    $0x4,%esp
  801c0c:	68 35 45 80 00       	push   $0x804535
  801c11:	6a 74                	push   $0x74
  801c13:	68 53 45 80 00       	push   $0x804553
  801c18:	e8 ef ec ff ff       	call   80090c <_panic>
  801c1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c20:	8b 00                	mov    (%eax),%eax
  801c22:	85 c0                	test   %eax,%eax
  801c24:	74 10                	je     801c36 <free+0x73>
  801c26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c29:	8b 00                	mov    (%eax),%eax
  801c2b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c2e:	8b 52 04             	mov    0x4(%edx),%edx
  801c31:	89 50 04             	mov    %edx,0x4(%eax)
  801c34:	eb 0b                	jmp    801c41 <free+0x7e>
  801c36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c39:	8b 40 04             	mov    0x4(%eax),%eax
  801c3c:	a3 44 50 80 00       	mov    %eax,0x805044
  801c41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c44:	8b 40 04             	mov    0x4(%eax),%eax
  801c47:	85 c0                	test   %eax,%eax
  801c49:	74 0f                	je     801c5a <free+0x97>
  801c4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c4e:	8b 40 04             	mov    0x4(%eax),%eax
  801c51:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c54:	8b 12                	mov    (%edx),%edx
  801c56:	89 10                	mov    %edx,(%eax)
  801c58:	eb 0a                	jmp    801c64 <free+0xa1>
  801c5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c5d:	8b 00                	mov    (%eax),%eax
  801c5f:	a3 40 50 80 00       	mov    %eax,0x805040
  801c64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c67:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801c6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c70:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801c77:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801c7c:	48                   	dec    %eax
  801c7d:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(free_block);
  801c82:	83 ec 0c             	sub    $0xc,%esp
  801c85:	ff 75 f4             	pushl  -0xc(%ebp)
  801c88:	e8 4e 17 00 00       	call   8033db <insert_sorted_with_merge_freeList>
  801c8d:	83 c4 10             	add    $0x10,%esp
	}

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801c90:	90                   	nop
  801c91:	c9                   	leave  
  801c92:	c3                   	ret    

00801c93 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801c93:	55                   	push   %ebp
  801c94:	89 e5                	mov    %esp,%ebp
  801c96:	83 ec 38             	sub    $0x38,%esp
  801c99:	8b 45 10             	mov    0x10(%ebp),%eax
  801c9c:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801c9f:	e8 a6 fc ff ff       	call   80194a <InitializeUHeap>
	if (size == 0) return NULL ;
  801ca4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801ca8:	75 0a                	jne    801cb4 <smalloc+0x21>
  801caa:	b8 00 00 00 00       	mov    $0x0,%eax
  801caf:	e9 8b 00 00 00       	jmp    801d3f <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801cb4:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801cbb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cc1:	01 d0                	add    %edx,%eax
  801cc3:	48                   	dec    %eax
  801cc4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801cc7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cca:	ba 00 00 00 00       	mov    $0x0,%edx
  801ccf:	f7 75 f0             	divl   -0x10(%ebp)
  801cd2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cd5:	29 d0                	sub    %edx,%eax
  801cd7:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801cda:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801ce1:	e8 d0 06 00 00       	call   8023b6 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801ce6:	85 c0                	test   %eax,%eax
  801ce8:	74 11                	je     801cfb <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  801cea:	83 ec 0c             	sub    $0xc,%esp
  801ced:	ff 75 e8             	pushl  -0x18(%ebp)
  801cf0:	e8 3b 0d 00 00       	call   802a30 <alloc_block_FF>
  801cf5:	83 c4 10             	add    $0x10,%esp
  801cf8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  801cfb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801cff:	74 39                	je     801d3a <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801d01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d04:	8b 40 08             	mov    0x8(%eax),%eax
  801d07:	89 c2                	mov    %eax,%edx
  801d09:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801d0d:	52                   	push   %edx
  801d0e:	50                   	push   %eax
  801d0f:	ff 75 0c             	pushl  0xc(%ebp)
  801d12:	ff 75 08             	pushl  0x8(%ebp)
  801d15:	e8 21 04 00 00       	call   80213b <sys_createSharedObject>
  801d1a:	83 c4 10             	add    $0x10,%esp
  801d1d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  801d20:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  801d24:	74 14                	je     801d3a <smalloc+0xa7>
  801d26:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  801d2a:	74 0e                	je     801d3a <smalloc+0xa7>
  801d2c:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  801d30:	74 08                	je     801d3a <smalloc+0xa7>
			return (void*) mem_block->sva;
  801d32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d35:	8b 40 08             	mov    0x8(%eax),%eax
  801d38:	eb 05                	jmp    801d3f <smalloc+0xac>
	}
	return NULL;
  801d3a:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801d3f:	c9                   	leave  
  801d40:	c3                   	ret    

00801d41 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801d41:	55                   	push   %ebp
  801d42:	89 e5                	mov    %esp,%ebp
  801d44:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801d47:	e8 fe fb ff ff       	call   80194a <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801d4c:	83 ec 08             	sub    $0x8,%esp
  801d4f:	ff 75 0c             	pushl  0xc(%ebp)
  801d52:	ff 75 08             	pushl  0x8(%ebp)
  801d55:	e8 0b 04 00 00       	call   802165 <sys_getSizeOfSharedObject>
  801d5a:	83 c4 10             	add    $0x10,%esp
  801d5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  801d60:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  801d64:	74 76                	je     801ddc <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801d66:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801d6d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d70:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d73:	01 d0                	add    %edx,%eax
  801d75:	48                   	dec    %eax
  801d76:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801d79:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d7c:	ba 00 00 00 00       	mov    $0x0,%edx
  801d81:	f7 75 ec             	divl   -0x14(%ebp)
  801d84:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d87:	29 d0                	sub    %edx,%eax
  801d89:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  801d8c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801d93:	e8 1e 06 00 00       	call   8023b6 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801d98:	85 c0                	test   %eax,%eax
  801d9a:	74 11                	je     801dad <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  801d9c:	83 ec 0c             	sub    $0xc,%esp
  801d9f:	ff 75 e4             	pushl  -0x1c(%ebp)
  801da2:	e8 89 0c 00 00       	call   802a30 <alloc_block_FF>
  801da7:	83 c4 10             	add    $0x10,%esp
  801daa:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  801dad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801db1:	74 29                	je     801ddc <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  801db3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801db6:	8b 40 08             	mov    0x8(%eax),%eax
  801db9:	83 ec 04             	sub    $0x4,%esp
  801dbc:	50                   	push   %eax
  801dbd:	ff 75 0c             	pushl  0xc(%ebp)
  801dc0:	ff 75 08             	pushl  0x8(%ebp)
  801dc3:	e8 ba 03 00 00       	call   802182 <sys_getSharedObject>
  801dc8:	83 c4 10             	add    $0x10,%esp
  801dcb:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  801dce:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  801dd2:	74 08                	je     801ddc <sget+0x9b>
				return (void *)mem_block->sva;
  801dd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dd7:	8b 40 08             	mov    0x8(%eax),%eax
  801dda:	eb 05                	jmp    801de1 <sget+0xa0>
		}
	}
	return NULL;
  801ddc:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801de1:	c9                   	leave  
  801de2:	c3                   	ret    

00801de3 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801de3:	55                   	push   %ebp
  801de4:	89 e5                	mov    %esp,%ebp
  801de6:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801de9:	e8 5c fb ff ff       	call   80194a <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801dee:	83 ec 04             	sub    $0x4,%esp
  801df1:	68 84 45 80 00       	push   $0x804584
  801df6:	68 f7 00 00 00       	push   $0xf7
  801dfb:	68 53 45 80 00       	push   $0x804553
  801e00:	e8 07 eb ff ff       	call   80090c <_panic>

00801e05 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801e05:	55                   	push   %ebp
  801e06:	89 e5                	mov    %esp,%ebp
  801e08:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()


	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801e0b:	83 ec 04             	sub    $0x4,%esp
  801e0e:	68 ac 45 80 00       	push   $0x8045ac
  801e13:	68 0c 01 00 00       	push   $0x10c
  801e18:	68 53 45 80 00       	push   $0x804553
  801e1d:	e8 ea ea ff ff       	call   80090c <_panic>

00801e22 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801e22:	55                   	push   %ebp
  801e23:	89 e5                	mov    %esp,%ebp
  801e25:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e28:	83 ec 04             	sub    $0x4,%esp
  801e2b:	68 d0 45 80 00       	push   $0x8045d0
  801e30:	68 44 01 00 00       	push   $0x144
  801e35:	68 53 45 80 00       	push   $0x804553
  801e3a:	e8 cd ea ff ff       	call   80090c <_panic>

00801e3f <shrink>:

}
void shrink(uint32 newSize)
{
  801e3f:	55                   	push   %ebp
  801e40:	89 e5                	mov    %esp,%ebp
  801e42:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e45:	83 ec 04             	sub    $0x4,%esp
  801e48:	68 d0 45 80 00       	push   $0x8045d0
  801e4d:	68 49 01 00 00       	push   $0x149
  801e52:	68 53 45 80 00       	push   $0x804553
  801e57:	e8 b0 ea ff ff       	call   80090c <_panic>

00801e5c <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801e5c:	55                   	push   %ebp
  801e5d:	89 e5                	mov    %esp,%ebp
  801e5f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e62:	83 ec 04             	sub    $0x4,%esp
  801e65:	68 d0 45 80 00       	push   $0x8045d0
  801e6a:	68 4e 01 00 00       	push   $0x14e
  801e6f:	68 53 45 80 00       	push   $0x804553
  801e74:	e8 93 ea ff ff       	call   80090c <_panic>

00801e79 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801e79:	55                   	push   %ebp
  801e7a:	89 e5                	mov    %esp,%ebp
  801e7c:	57                   	push   %edi
  801e7d:	56                   	push   %esi
  801e7e:	53                   	push   %ebx
  801e7f:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801e82:	8b 45 08             	mov    0x8(%ebp),%eax
  801e85:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e88:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e8b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e8e:	8b 7d 18             	mov    0x18(%ebp),%edi
  801e91:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801e94:	cd 30                	int    $0x30
  801e96:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801e99:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801e9c:	83 c4 10             	add    $0x10,%esp
  801e9f:	5b                   	pop    %ebx
  801ea0:	5e                   	pop    %esi
  801ea1:	5f                   	pop    %edi
  801ea2:	5d                   	pop    %ebp
  801ea3:	c3                   	ret    

00801ea4 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801ea4:	55                   	push   %ebp
  801ea5:	89 e5                	mov    %esp,%ebp
  801ea7:	83 ec 04             	sub    $0x4,%esp
  801eaa:	8b 45 10             	mov    0x10(%ebp),%eax
  801ead:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801eb0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801eb4:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb7:	6a 00                	push   $0x0
  801eb9:	6a 00                	push   $0x0
  801ebb:	52                   	push   %edx
  801ebc:	ff 75 0c             	pushl  0xc(%ebp)
  801ebf:	50                   	push   %eax
  801ec0:	6a 00                	push   $0x0
  801ec2:	e8 b2 ff ff ff       	call   801e79 <syscall>
  801ec7:	83 c4 18             	add    $0x18,%esp
}
  801eca:	90                   	nop
  801ecb:	c9                   	leave  
  801ecc:	c3                   	ret    

00801ecd <sys_cgetc>:

int
sys_cgetc(void)
{
  801ecd:	55                   	push   %ebp
  801ece:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801ed0:	6a 00                	push   $0x0
  801ed2:	6a 00                	push   $0x0
  801ed4:	6a 00                	push   $0x0
  801ed6:	6a 00                	push   $0x0
  801ed8:	6a 00                	push   $0x0
  801eda:	6a 01                	push   $0x1
  801edc:	e8 98 ff ff ff       	call   801e79 <syscall>
  801ee1:	83 c4 18             	add    $0x18,%esp
}
  801ee4:	c9                   	leave  
  801ee5:	c3                   	ret    

00801ee6 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801ee6:	55                   	push   %ebp
  801ee7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801ee9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eec:	8b 45 08             	mov    0x8(%ebp),%eax
  801eef:	6a 00                	push   $0x0
  801ef1:	6a 00                	push   $0x0
  801ef3:	6a 00                	push   $0x0
  801ef5:	52                   	push   %edx
  801ef6:	50                   	push   %eax
  801ef7:	6a 05                	push   $0x5
  801ef9:	e8 7b ff ff ff       	call   801e79 <syscall>
  801efe:	83 c4 18             	add    $0x18,%esp
}
  801f01:	c9                   	leave  
  801f02:	c3                   	ret    

00801f03 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801f03:	55                   	push   %ebp
  801f04:	89 e5                	mov    %esp,%ebp
  801f06:	56                   	push   %esi
  801f07:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801f08:	8b 75 18             	mov    0x18(%ebp),%esi
  801f0b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f0e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f11:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f14:	8b 45 08             	mov    0x8(%ebp),%eax
  801f17:	56                   	push   %esi
  801f18:	53                   	push   %ebx
  801f19:	51                   	push   %ecx
  801f1a:	52                   	push   %edx
  801f1b:	50                   	push   %eax
  801f1c:	6a 06                	push   $0x6
  801f1e:	e8 56 ff ff ff       	call   801e79 <syscall>
  801f23:	83 c4 18             	add    $0x18,%esp
}
  801f26:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f29:	5b                   	pop    %ebx
  801f2a:	5e                   	pop    %esi
  801f2b:	5d                   	pop    %ebp
  801f2c:	c3                   	ret    

00801f2d <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801f2d:	55                   	push   %ebp
  801f2e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801f30:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f33:	8b 45 08             	mov    0x8(%ebp),%eax
  801f36:	6a 00                	push   $0x0
  801f38:	6a 00                	push   $0x0
  801f3a:	6a 00                	push   $0x0
  801f3c:	52                   	push   %edx
  801f3d:	50                   	push   %eax
  801f3e:	6a 07                	push   $0x7
  801f40:	e8 34 ff ff ff       	call   801e79 <syscall>
  801f45:	83 c4 18             	add    $0x18,%esp
}
  801f48:	c9                   	leave  
  801f49:	c3                   	ret    

00801f4a <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801f4a:	55                   	push   %ebp
  801f4b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801f4d:	6a 00                	push   $0x0
  801f4f:	6a 00                	push   $0x0
  801f51:	6a 00                	push   $0x0
  801f53:	ff 75 0c             	pushl  0xc(%ebp)
  801f56:	ff 75 08             	pushl  0x8(%ebp)
  801f59:	6a 08                	push   $0x8
  801f5b:	e8 19 ff ff ff       	call   801e79 <syscall>
  801f60:	83 c4 18             	add    $0x18,%esp
}
  801f63:	c9                   	leave  
  801f64:	c3                   	ret    

00801f65 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801f65:	55                   	push   %ebp
  801f66:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801f68:	6a 00                	push   $0x0
  801f6a:	6a 00                	push   $0x0
  801f6c:	6a 00                	push   $0x0
  801f6e:	6a 00                	push   $0x0
  801f70:	6a 00                	push   $0x0
  801f72:	6a 09                	push   $0x9
  801f74:	e8 00 ff ff ff       	call   801e79 <syscall>
  801f79:	83 c4 18             	add    $0x18,%esp
}
  801f7c:	c9                   	leave  
  801f7d:	c3                   	ret    

00801f7e <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801f7e:	55                   	push   %ebp
  801f7f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801f81:	6a 00                	push   $0x0
  801f83:	6a 00                	push   $0x0
  801f85:	6a 00                	push   $0x0
  801f87:	6a 00                	push   $0x0
  801f89:	6a 00                	push   $0x0
  801f8b:	6a 0a                	push   $0xa
  801f8d:	e8 e7 fe ff ff       	call   801e79 <syscall>
  801f92:	83 c4 18             	add    $0x18,%esp
}
  801f95:	c9                   	leave  
  801f96:	c3                   	ret    

00801f97 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801f97:	55                   	push   %ebp
  801f98:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801f9a:	6a 00                	push   $0x0
  801f9c:	6a 00                	push   $0x0
  801f9e:	6a 00                	push   $0x0
  801fa0:	6a 00                	push   $0x0
  801fa2:	6a 00                	push   $0x0
  801fa4:	6a 0b                	push   $0xb
  801fa6:	e8 ce fe ff ff       	call   801e79 <syscall>
  801fab:	83 c4 18             	add    $0x18,%esp
}
  801fae:	c9                   	leave  
  801faf:	c3                   	ret    

00801fb0 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801fb0:	55                   	push   %ebp
  801fb1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801fb3:	6a 00                	push   $0x0
  801fb5:	6a 00                	push   $0x0
  801fb7:	6a 00                	push   $0x0
  801fb9:	ff 75 0c             	pushl  0xc(%ebp)
  801fbc:	ff 75 08             	pushl  0x8(%ebp)
  801fbf:	6a 0f                	push   $0xf
  801fc1:	e8 b3 fe ff ff       	call   801e79 <syscall>
  801fc6:	83 c4 18             	add    $0x18,%esp
	return;
  801fc9:	90                   	nop
}
  801fca:	c9                   	leave  
  801fcb:	c3                   	ret    

00801fcc <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801fcc:	55                   	push   %ebp
  801fcd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801fcf:	6a 00                	push   $0x0
  801fd1:	6a 00                	push   $0x0
  801fd3:	6a 00                	push   $0x0
  801fd5:	ff 75 0c             	pushl  0xc(%ebp)
  801fd8:	ff 75 08             	pushl  0x8(%ebp)
  801fdb:	6a 10                	push   $0x10
  801fdd:	e8 97 fe ff ff       	call   801e79 <syscall>
  801fe2:	83 c4 18             	add    $0x18,%esp
	return ;
  801fe5:	90                   	nop
}
  801fe6:	c9                   	leave  
  801fe7:	c3                   	ret    

00801fe8 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801fe8:	55                   	push   %ebp
  801fe9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801feb:	6a 00                	push   $0x0
  801fed:	6a 00                	push   $0x0
  801fef:	ff 75 10             	pushl  0x10(%ebp)
  801ff2:	ff 75 0c             	pushl  0xc(%ebp)
  801ff5:	ff 75 08             	pushl  0x8(%ebp)
  801ff8:	6a 11                	push   $0x11
  801ffa:	e8 7a fe ff ff       	call   801e79 <syscall>
  801fff:	83 c4 18             	add    $0x18,%esp
	return ;
  802002:	90                   	nop
}
  802003:	c9                   	leave  
  802004:	c3                   	ret    

00802005 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802005:	55                   	push   %ebp
  802006:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802008:	6a 00                	push   $0x0
  80200a:	6a 00                	push   $0x0
  80200c:	6a 00                	push   $0x0
  80200e:	6a 00                	push   $0x0
  802010:	6a 00                	push   $0x0
  802012:	6a 0c                	push   $0xc
  802014:	e8 60 fe ff ff       	call   801e79 <syscall>
  802019:	83 c4 18             	add    $0x18,%esp
}
  80201c:	c9                   	leave  
  80201d:	c3                   	ret    

0080201e <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80201e:	55                   	push   %ebp
  80201f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802021:	6a 00                	push   $0x0
  802023:	6a 00                	push   $0x0
  802025:	6a 00                	push   $0x0
  802027:	6a 00                	push   $0x0
  802029:	ff 75 08             	pushl  0x8(%ebp)
  80202c:	6a 0d                	push   $0xd
  80202e:	e8 46 fe ff ff       	call   801e79 <syscall>
  802033:	83 c4 18             	add    $0x18,%esp
}
  802036:	c9                   	leave  
  802037:	c3                   	ret    

00802038 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802038:	55                   	push   %ebp
  802039:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80203b:	6a 00                	push   $0x0
  80203d:	6a 00                	push   $0x0
  80203f:	6a 00                	push   $0x0
  802041:	6a 00                	push   $0x0
  802043:	6a 00                	push   $0x0
  802045:	6a 0e                	push   $0xe
  802047:	e8 2d fe ff ff       	call   801e79 <syscall>
  80204c:	83 c4 18             	add    $0x18,%esp
}
  80204f:	90                   	nop
  802050:	c9                   	leave  
  802051:	c3                   	ret    

00802052 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802052:	55                   	push   %ebp
  802053:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802055:	6a 00                	push   $0x0
  802057:	6a 00                	push   $0x0
  802059:	6a 00                	push   $0x0
  80205b:	6a 00                	push   $0x0
  80205d:	6a 00                	push   $0x0
  80205f:	6a 13                	push   $0x13
  802061:	e8 13 fe ff ff       	call   801e79 <syscall>
  802066:	83 c4 18             	add    $0x18,%esp
}
  802069:	90                   	nop
  80206a:	c9                   	leave  
  80206b:	c3                   	ret    

0080206c <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80206c:	55                   	push   %ebp
  80206d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80206f:	6a 00                	push   $0x0
  802071:	6a 00                	push   $0x0
  802073:	6a 00                	push   $0x0
  802075:	6a 00                	push   $0x0
  802077:	6a 00                	push   $0x0
  802079:	6a 14                	push   $0x14
  80207b:	e8 f9 fd ff ff       	call   801e79 <syscall>
  802080:	83 c4 18             	add    $0x18,%esp
}
  802083:	90                   	nop
  802084:	c9                   	leave  
  802085:	c3                   	ret    

00802086 <sys_cputc>:


void
sys_cputc(const char c)
{
  802086:	55                   	push   %ebp
  802087:	89 e5                	mov    %esp,%ebp
  802089:	83 ec 04             	sub    $0x4,%esp
  80208c:	8b 45 08             	mov    0x8(%ebp),%eax
  80208f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802092:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802096:	6a 00                	push   $0x0
  802098:	6a 00                	push   $0x0
  80209a:	6a 00                	push   $0x0
  80209c:	6a 00                	push   $0x0
  80209e:	50                   	push   %eax
  80209f:	6a 15                	push   $0x15
  8020a1:	e8 d3 fd ff ff       	call   801e79 <syscall>
  8020a6:	83 c4 18             	add    $0x18,%esp
}
  8020a9:	90                   	nop
  8020aa:	c9                   	leave  
  8020ab:	c3                   	ret    

008020ac <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8020ac:	55                   	push   %ebp
  8020ad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8020af:	6a 00                	push   $0x0
  8020b1:	6a 00                	push   $0x0
  8020b3:	6a 00                	push   $0x0
  8020b5:	6a 00                	push   $0x0
  8020b7:	6a 00                	push   $0x0
  8020b9:	6a 16                	push   $0x16
  8020bb:	e8 b9 fd ff ff       	call   801e79 <syscall>
  8020c0:	83 c4 18             	add    $0x18,%esp
}
  8020c3:	90                   	nop
  8020c4:	c9                   	leave  
  8020c5:	c3                   	ret    

008020c6 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8020c6:	55                   	push   %ebp
  8020c7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8020c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020cc:	6a 00                	push   $0x0
  8020ce:	6a 00                	push   $0x0
  8020d0:	6a 00                	push   $0x0
  8020d2:	ff 75 0c             	pushl  0xc(%ebp)
  8020d5:	50                   	push   %eax
  8020d6:	6a 17                	push   $0x17
  8020d8:	e8 9c fd ff ff       	call   801e79 <syscall>
  8020dd:	83 c4 18             	add    $0x18,%esp
}
  8020e0:	c9                   	leave  
  8020e1:	c3                   	ret    

008020e2 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8020e2:	55                   	push   %ebp
  8020e3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8020e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020eb:	6a 00                	push   $0x0
  8020ed:	6a 00                	push   $0x0
  8020ef:	6a 00                	push   $0x0
  8020f1:	52                   	push   %edx
  8020f2:	50                   	push   %eax
  8020f3:	6a 1a                	push   $0x1a
  8020f5:	e8 7f fd ff ff       	call   801e79 <syscall>
  8020fa:	83 c4 18             	add    $0x18,%esp
}
  8020fd:	c9                   	leave  
  8020fe:	c3                   	ret    

008020ff <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8020ff:	55                   	push   %ebp
  802100:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802102:	8b 55 0c             	mov    0xc(%ebp),%edx
  802105:	8b 45 08             	mov    0x8(%ebp),%eax
  802108:	6a 00                	push   $0x0
  80210a:	6a 00                	push   $0x0
  80210c:	6a 00                	push   $0x0
  80210e:	52                   	push   %edx
  80210f:	50                   	push   %eax
  802110:	6a 18                	push   $0x18
  802112:	e8 62 fd ff ff       	call   801e79 <syscall>
  802117:	83 c4 18             	add    $0x18,%esp
}
  80211a:	90                   	nop
  80211b:	c9                   	leave  
  80211c:	c3                   	ret    

0080211d <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80211d:	55                   	push   %ebp
  80211e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802120:	8b 55 0c             	mov    0xc(%ebp),%edx
  802123:	8b 45 08             	mov    0x8(%ebp),%eax
  802126:	6a 00                	push   $0x0
  802128:	6a 00                	push   $0x0
  80212a:	6a 00                	push   $0x0
  80212c:	52                   	push   %edx
  80212d:	50                   	push   %eax
  80212e:	6a 19                	push   $0x19
  802130:	e8 44 fd ff ff       	call   801e79 <syscall>
  802135:	83 c4 18             	add    $0x18,%esp
}
  802138:	90                   	nop
  802139:	c9                   	leave  
  80213a:	c3                   	ret    

0080213b <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80213b:	55                   	push   %ebp
  80213c:	89 e5                	mov    %esp,%ebp
  80213e:	83 ec 04             	sub    $0x4,%esp
  802141:	8b 45 10             	mov    0x10(%ebp),%eax
  802144:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802147:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80214a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80214e:	8b 45 08             	mov    0x8(%ebp),%eax
  802151:	6a 00                	push   $0x0
  802153:	51                   	push   %ecx
  802154:	52                   	push   %edx
  802155:	ff 75 0c             	pushl  0xc(%ebp)
  802158:	50                   	push   %eax
  802159:	6a 1b                	push   $0x1b
  80215b:	e8 19 fd ff ff       	call   801e79 <syscall>
  802160:	83 c4 18             	add    $0x18,%esp
}
  802163:	c9                   	leave  
  802164:	c3                   	ret    

00802165 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802165:	55                   	push   %ebp
  802166:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802168:	8b 55 0c             	mov    0xc(%ebp),%edx
  80216b:	8b 45 08             	mov    0x8(%ebp),%eax
  80216e:	6a 00                	push   $0x0
  802170:	6a 00                	push   $0x0
  802172:	6a 00                	push   $0x0
  802174:	52                   	push   %edx
  802175:	50                   	push   %eax
  802176:	6a 1c                	push   $0x1c
  802178:	e8 fc fc ff ff       	call   801e79 <syscall>
  80217d:	83 c4 18             	add    $0x18,%esp
}
  802180:	c9                   	leave  
  802181:	c3                   	ret    

00802182 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802182:	55                   	push   %ebp
  802183:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802185:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802188:	8b 55 0c             	mov    0xc(%ebp),%edx
  80218b:	8b 45 08             	mov    0x8(%ebp),%eax
  80218e:	6a 00                	push   $0x0
  802190:	6a 00                	push   $0x0
  802192:	51                   	push   %ecx
  802193:	52                   	push   %edx
  802194:	50                   	push   %eax
  802195:	6a 1d                	push   $0x1d
  802197:	e8 dd fc ff ff       	call   801e79 <syscall>
  80219c:	83 c4 18             	add    $0x18,%esp
}
  80219f:	c9                   	leave  
  8021a0:	c3                   	ret    

008021a1 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8021a1:	55                   	push   %ebp
  8021a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8021a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021aa:	6a 00                	push   $0x0
  8021ac:	6a 00                	push   $0x0
  8021ae:	6a 00                	push   $0x0
  8021b0:	52                   	push   %edx
  8021b1:	50                   	push   %eax
  8021b2:	6a 1e                	push   $0x1e
  8021b4:	e8 c0 fc ff ff       	call   801e79 <syscall>
  8021b9:	83 c4 18             	add    $0x18,%esp
}
  8021bc:	c9                   	leave  
  8021bd:	c3                   	ret    

008021be <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8021be:	55                   	push   %ebp
  8021bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8021c1:	6a 00                	push   $0x0
  8021c3:	6a 00                	push   $0x0
  8021c5:	6a 00                	push   $0x0
  8021c7:	6a 00                	push   $0x0
  8021c9:	6a 00                	push   $0x0
  8021cb:	6a 1f                	push   $0x1f
  8021cd:	e8 a7 fc ff ff       	call   801e79 <syscall>
  8021d2:	83 c4 18             	add    $0x18,%esp
}
  8021d5:	c9                   	leave  
  8021d6:	c3                   	ret    

008021d7 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8021d7:	55                   	push   %ebp
  8021d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8021da:	8b 45 08             	mov    0x8(%ebp),%eax
  8021dd:	6a 00                	push   $0x0
  8021df:	ff 75 14             	pushl  0x14(%ebp)
  8021e2:	ff 75 10             	pushl  0x10(%ebp)
  8021e5:	ff 75 0c             	pushl  0xc(%ebp)
  8021e8:	50                   	push   %eax
  8021e9:	6a 20                	push   $0x20
  8021eb:	e8 89 fc ff ff       	call   801e79 <syscall>
  8021f0:	83 c4 18             	add    $0x18,%esp
}
  8021f3:	c9                   	leave  
  8021f4:	c3                   	ret    

008021f5 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8021f5:	55                   	push   %ebp
  8021f6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8021f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fb:	6a 00                	push   $0x0
  8021fd:	6a 00                	push   $0x0
  8021ff:	6a 00                	push   $0x0
  802201:	6a 00                	push   $0x0
  802203:	50                   	push   %eax
  802204:	6a 21                	push   $0x21
  802206:	e8 6e fc ff ff       	call   801e79 <syscall>
  80220b:	83 c4 18             	add    $0x18,%esp
}
  80220e:	90                   	nop
  80220f:	c9                   	leave  
  802210:	c3                   	ret    

00802211 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802211:	55                   	push   %ebp
  802212:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802214:	8b 45 08             	mov    0x8(%ebp),%eax
  802217:	6a 00                	push   $0x0
  802219:	6a 00                	push   $0x0
  80221b:	6a 00                	push   $0x0
  80221d:	6a 00                	push   $0x0
  80221f:	50                   	push   %eax
  802220:	6a 22                	push   $0x22
  802222:	e8 52 fc ff ff       	call   801e79 <syscall>
  802227:	83 c4 18             	add    $0x18,%esp
}
  80222a:	c9                   	leave  
  80222b:	c3                   	ret    

0080222c <sys_getenvid>:

int32 sys_getenvid(void)
{
  80222c:	55                   	push   %ebp
  80222d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80222f:	6a 00                	push   $0x0
  802231:	6a 00                	push   $0x0
  802233:	6a 00                	push   $0x0
  802235:	6a 00                	push   $0x0
  802237:	6a 00                	push   $0x0
  802239:	6a 02                	push   $0x2
  80223b:	e8 39 fc ff ff       	call   801e79 <syscall>
  802240:	83 c4 18             	add    $0x18,%esp
}
  802243:	c9                   	leave  
  802244:	c3                   	ret    

00802245 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802245:	55                   	push   %ebp
  802246:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802248:	6a 00                	push   $0x0
  80224a:	6a 00                	push   $0x0
  80224c:	6a 00                	push   $0x0
  80224e:	6a 00                	push   $0x0
  802250:	6a 00                	push   $0x0
  802252:	6a 03                	push   $0x3
  802254:	e8 20 fc ff ff       	call   801e79 <syscall>
  802259:	83 c4 18             	add    $0x18,%esp
}
  80225c:	c9                   	leave  
  80225d:	c3                   	ret    

0080225e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80225e:	55                   	push   %ebp
  80225f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802261:	6a 00                	push   $0x0
  802263:	6a 00                	push   $0x0
  802265:	6a 00                	push   $0x0
  802267:	6a 00                	push   $0x0
  802269:	6a 00                	push   $0x0
  80226b:	6a 04                	push   $0x4
  80226d:	e8 07 fc ff ff       	call   801e79 <syscall>
  802272:	83 c4 18             	add    $0x18,%esp
}
  802275:	c9                   	leave  
  802276:	c3                   	ret    

00802277 <sys_exit_env>:


void sys_exit_env(void)
{
  802277:	55                   	push   %ebp
  802278:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80227a:	6a 00                	push   $0x0
  80227c:	6a 00                	push   $0x0
  80227e:	6a 00                	push   $0x0
  802280:	6a 00                	push   $0x0
  802282:	6a 00                	push   $0x0
  802284:	6a 23                	push   $0x23
  802286:	e8 ee fb ff ff       	call   801e79 <syscall>
  80228b:	83 c4 18             	add    $0x18,%esp
}
  80228e:	90                   	nop
  80228f:	c9                   	leave  
  802290:	c3                   	ret    

00802291 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802291:	55                   	push   %ebp
  802292:	89 e5                	mov    %esp,%ebp
  802294:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802297:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80229a:	8d 50 04             	lea    0x4(%eax),%edx
  80229d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8022a0:	6a 00                	push   $0x0
  8022a2:	6a 00                	push   $0x0
  8022a4:	6a 00                	push   $0x0
  8022a6:	52                   	push   %edx
  8022a7:	50                   	push   %eax
  8022a8:	6a 24                	push   $0x24
  8022aa:	e8 ca fb ff ff       	call   801e79 <syscall>
  8022af:	83 c4 18             	add    $0x18,%esp
	return result;
  8022b2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022b5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8022b8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8022bb:	89 01                	mov    %eax,(%ecx)
  8022bd:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8022c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c3:	c9                   	leave  
  8022c4:	c2 04 00             	ret    $0x4

008022c7 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8022c7:	55                   	push   %ebp
  8022c8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8022ca:	6a 00                	push   $0x0
  8022cc:	6a 00                	push   $0x0
  8022ce:	ff 75 10             	pushl  0x10(%ebp)
  8022d1:	ff 75 0c             	pushl  0xc(%ebp)
  8022d4:	ff 75 08             	pushl  0x8(%ebp)
  8022d7:	6a 12                	push   $0x12
  8022d9:	e8 9b fb ff ff       	call   801e79 <syscall>
  8022de:	83 c4 18             	add    $0x18,%esp
	return ;
  8022e1:	90                   	nop
}
  8022e2:	c9                   	leave  
  8022e3:	c3                   	ret    

008022e4 <sys_rcr2>:
uint32 sys_rcr2()
{
  8022e4:	55                   	push   %ebp
  8022e5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8022e7:	6a 00                	push   $0x0
  8022e9:	6a 00                	push   $0x0
  8022eb:	6a 00                	push   $0x0
  8022ed:	6a 00                	push   $0x0
  8022ef:	6a 00                	push   $0x0
  8022f1:	6a 25                	push   $0x25
  8022f3:	e8 81 fb ff ff       	call   801e79 <syscall>
  8022f8:	83 c4 18             	add    $0x18,%esp
}
  8022fb:	c9                   	leave  
  8022fc:	c3                   	ret    

008022fd <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8022fd:	55                   	push   %ebp
  8022fe:	89 e5                	mov    %esp,%ebp
  802300:	83 ec 04             	sub    $0x4,%esp
  802303:	8b 45 08             	mov    0x8(%ebp),%eax
  802306:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802309:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80230d:	6a 00                	push   $0x0
  80230f:	6a 00                	push   $0x0
  802311:	6a 00                	push   $0x0
  802313:	6a 00                	push   $0x0
  802315:	50                   	push   %eax
  802316:	6a 26                	push   $0x26
  802318:	e8 5c fb ff ff       	call   801e79 <syscall>
  80231d:	83 c4 18             	add    $0x18,%esp
	return ;
  802320:	90                   	nop
}
  802321:	c9                   	leave  
  802322:	c3                   	ret    

00802323 <rsttst>:
void rsttst()
{
  802323:	55                   	push   %ebp
  802324:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802326:	6a 00                	push   $0x0
  802328:	6a 00                	push   $0x0
  80232a:	6a 00                	push   $0x0
  80232c:	6a 00                	push   $0x0
  80232e:	6a 00                	push   $0x0
  802330:	6a 28                	push   $0x28
  802332:	e8 42 fb ff ff       	call   801e79 <syscall>
  802337:	83 c4 18             	add    $0x18,%esp
	return ;
  80233a:	90                   	nop
}
  80233b:	c9                   	leave  
  80233c:	c3                   	ret    

0080233d <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80233d:	55                   	push   %ebp
  80233e:	89 e5                	mov    %esp,%ebp
  802340:	83 ec 04             	sub    $0x4,%esp
  802343:	8b 45 14             	mov    0x14(%ebp),%eax
  802346:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802349:	8b 55 18             	mov    0x18(%ebp),%edx
  80234c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802350:	52                   	push   %edx
  802351:	50                   	push   %eax
  802352:	ff 75 10             	pushl  0x10(%ebp)
  802355:	ff 75 0c             	pushl  0xc(%ebp)
  802358:	ff 75 08             	pushl  0x8(%ebp)
  80235b:	6a 27                	push   $0x27
  80235d:	e8 17 fb ff ff       	call   801e79 <syscall>
  802362:	83 c4 18             	add    $0x18,%esp
	return ;
  802365:	90                   	nop
}
  802366:	c9                   	leave  
  802367:	c3                   	ret    

00802368 <chktst>:
void chktst(uint32 n)
{
  802368:	55                   	push   %ebp
  802369:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80236b:	6a 00                	push   $0x0
  80236d:	6a 00                	push   $0x0
  80236f:	6a 00                	push   $0x0
  802371:	6a 00                	push   $0x0
  802373:	ff 75 08             	pushl  0x8(%ebp)
  802376:	6a 29                	push   $0x29
  802378:	e8 fc fa ff ff       	call   801e79 <syscall>
  80237d:	83 c4 18             	add    $0x18,%esp
	return ;
  802380:	90                   	nop
}
  802381:	c9                   	leave  
  802382:	c3                   	ret    

00802383 <inctst>:

void inctst()
{
  802383:	55                   	push   %ebp
  802384:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802386:	6a 00                	push   $0x0
  802388:	6a 00                	push   $0x0
  80238a:	6a 00                	push   $0x0
  80238c:	6a 00                	push   $0x0
  80238e:	6a 00                	push   $0x0
  802390:	6a 2a                	push   $0x2a
  802392:	e8 e2 fa ff ff       	call   801e79 <syscall>
  802397:	83 c4 18             	add    $0x18,%esp
	return ;
  80239a:	90                   	nop
}
  80239b:	c9                   	leave  
  80239c:	c3                   	ret    

0080239d <gettst>:
uint32 gettst()
{
  80239d:	55                   	push   %ebp
  80239e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8023a0:	6a 00                	push   $0x0
  8023a2:	6a 00                	push   $0x0
  8023a4:	6a 00                	push   $0x0
  8023a6:	6a 00                	push   $0x0
  8023a8:	6a 00                	push   $0x0
  8023aa:	6a 2b                	push   $0x2b
  8023ac:	e8 c8 fa ff ff       	call   801e79 <syscall>
  8023b1:	83 c4 18             	add    $0x18,%esp
}
  8023b4:	c9                   	leave  
  8023b5:	c3                   	ret    

008023b6 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8023b6:	55                   	push   %ebp
  8023b7:	89 e5                	mov    %esp,%ebp
  8023b9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023bc:	6a 00                	push   $0x0
  8023be:	6a 00                	push   $0x0
  8023c0:	6a 00                	push   $0x0
  8023c2:	6a 00                	push   $0x0
  8023c4:	6a 00                	push   $0x0
  8023c6:	6a 2c                	push   $0x2c
  8023c8:	e8 ac fa ff ff       	call   801e79 <syscall>
  8023cd:	83 c4 18             	add    $0x18,%esp
  8023d0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8023d3:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8023d7:	75 07                	jne    8023e0 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8023d9:	b8 01 00 00 00       	mov    $0x1,%eax
  8023de:	eb 05                	jmp    8023e5 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8023e0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023e5:	c9                   	leave  
  8023e6:	c3                   	ret    

008023e7 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8023e7:	55                   	push   %ebp
  8023e8:	89 e5                	mov    %esp,%ebp
  8023ea:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023ed:	6a 00                	push   $0x0
  8023ef:	6a 00                	push   $0x0
  8023f1:	6a 00                	push   $0x0
  8023f3:	6a 00                	push   $0x0
  8023f5:	6a 00                	push   $0x0
  8023f7:	6a 2c                	push   $0x2c
  8023f9:	e8 7b fa ff ff       	call   801e79 <syscall>
  8023fe:	83 c4 18             	add    $0x18,%esp
  802401:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802404:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802408:	75 07                	jne    802411 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80240a:	b8 01 00 00 00       	mov    $0x1,%eax
  80240f:	eb 05                	jmp    802416 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802411:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802416:	c9                   	leave  
  802417:	c3                   	ret    

00802418 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802418:	55                   	push   %ebp
  802419:	89 e5                	mov    %esp,%ebp
  80241b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80241e:	6a 00                	push   $0x0
  802420:	6a 00                	push   $0x0
  802422:	6a 00                	push   $0x0
  802424:	6a 00                	push   $0x0
  802426:	6a 00                	push   $0x0
  802428:	6a 2c                	push   $0x2c
  80242a:	e8 4a fa ff ff       	call   801e79 <syscall>
  80242f:	83 c4 18             	add    $0x18,%esp
  802432:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802435:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802439:	75 07                	jne    802442 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80243b:	b8 01 00 00 00       	mov    $0x1,%eax
  802440:	eb 05                	jmp    802447 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802442:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802447:	c9                   	leave  
  802448:	c3                   	ret    

00802449 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802449:	55                   	push   %ebp
  80244a:	89 e5                	mov    %esp,%ebp
  80244c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80244f:	6a 00                	push   $0x0
  802451:	6a 00                	push   $0x0
  802453:	6a 00                	push   $0x0
  802455:	6a 00                	push   $0x0
  802457:	6a 00                	push   $0x0
  802459:	6a 2c                	push   $0x2c
  80245b:	e8 19 fa ff ff       	call   801e79 <syscall>
  802460:	83 c4 18             	add    $0x18,%esp
  802463:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802466:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80246a:	75 07                	jne    802473 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80246c:	b8 01 00 00 00       	mov    $0x1,%eax
  802471:	eb 05                	jmp    802478 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802473:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802478:	c9                   	leave  
  802479:	c3                   	ret    

0080247a <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80247a:	55                   	push   %ebp
  80247b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80247d:	6a 00                	push   $0x0
  80247f:	6a 00                	push   $0x0
  802481:	6a 00                	push   $0x0
  802483:	6a 00                	push   $0x0
  802485:	ff 75 08             	pushl  0x8(%ebp)
  802488:	6a 2d                	push   $0x2d
  80248a:	e8 ea f9 ff ff       	call   801e79 <syscall>
  80248f:	83 c4 18             	add    $0x18,%esp
	return ;
  802492:	90                   	nop
}
  802493:	c9                   	leave  
  802494:	c3                   	ret    

00802495 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802495:	55                   	push   %ebp
  802496:	89 e5                	mov    %esp,%ebp
  802498:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802499:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80249c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80249f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a5:	6a 00                	push   $0x0
  8024a7:	53                   	push   %ebx
  8024a8:	51                   	push   %ecx
  8024a9:	52                   	push   %edx
  8024aa:	50                   	push   %eax
  8024ab:	6a 2e                	push   $0x2e
  8024ad:	e8 c7 f9 ff ff       	call   801e79 <syscall>
  8024b2:	83 c4 18             	add    $0x18,%esp
}
  8024b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8024b8:	c9                   	leave  
  8024b9:	c3                   	ret    

008024ba <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8024ba:	55                   	push   %ebp
  8024bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8024bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c3:	6a 00                	push   $0x0
  8024c5:	6a 00                	push   $0x0
  8024c7:	6a 00                	push   $0x0
  8024c9:	52                   	push   %edx
  8024ca:	50                   	push   %eax
  8024cb:	6a 2f                	push   $0x2f
  8024cd:	e8 a7 f9 ff ff       	call   801e79 <syscall>
  8024d2:	83 c4 18             	add    $0x18,%esp
}
  8024d5:	c9                   	leave  
  8024d6:	c3                   	ret    

008024d7 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8024d7:	55                   	push   %ebp
  8024d8:	89 e5                	mov    %esp,%ebp
  8024da:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8024dd:	83 ec 0c             	sub    $0xc,%esp
  8024e0:	68 e0 45 80 00       	push   $0x8045e0
  8024e5:	e8 d6 e6 ff ff       	call   800bc0 <cprintf>
  8024ea:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8024ed:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8024f4:	83 ec 0c             	sub    $0xc,%esp
  8024f7:	68 0c 46 80 00       	push   $0x80460c
  8024fc:	e8 bf e6 ff ff       	call   800bc0 <cprintf>
  802501:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802504:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802508:	a1 38 51 80 00       	mov    0x805138,%eax
  80250d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802510:	eb 56                	jmp    802568 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802512:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802516:	74 1c                	je     802534 <print_mem_block_lists+0x5d>
  802518:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251b:	8b 50 08             	mov    0x8(%eax),%edx
  80251e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802521:	8b 48 08             	mov    0x8(%eax),%ecx
  802524:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802527:	8b 40 0c             	mov    0xc(%eax),%eax
  80252a:	01 c8                	add    %ecx,%eax
  80252c:	39 c2                	cmp    %eax,%edx
  80252e:	73 04                	jae    802534 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802530:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802534:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802537:	8b 50 08             	mov    0x8(%eax),%edx
  80253a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253d:	8b 40 0c             	mov    0xc(%eax),%eax
  802540:	01 c2                	add    %eax,%edx
  802542:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802545:	8b 40 08             	mov    0x8(%eax),%eax
  802548:	83 ec 04             	sub    $0x4,%esp
  80254b:	52                   	push   %edx
  80254c:	50                   	push   %eax
  80254d:	68 21 46 80 00       	push   $0x804621
  802552:	e8 69 e6 ff ff       	call   800bc0 <cprintf>
  802557:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80255a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802560:	a1 40 51 80 00       	mov    0x805140,%eax
  802565:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802568:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80256c:	74 07                	je     802575 <print_mem_block_lists+0x9e>
  80256e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802571:	8b 00                	mov    (%eax),%eax
  802573:	eb 05                	jmp    80257a <print_mem_block_lists+0xa3>
  802575:	b8 00 00 00 00       	mov    $0x0,%eax
  80257a:	a3 40 51 80 00       	mov    %eax,0x805140
  80257f:	a1 40 51 80 00       	mov    0x805140,%eax
  802584:	85 c0                	test   %eax,%eax
  802586:	75 8a                	jne    802512 <print_mem_block_lists+0x3b>
  802588:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80258c:	75 84                	jne    802512 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  80258e:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802592:	75 10                	jne    8025a4 <print_mem_block_lists+0xcd>
  802594:	83 ec 0c             	sub    $0xc,%esp
  802597:	68 30 46 80 00       	push   $0x804630
  80259c:	e8 1f e6 ff ff       	call   800bc0 <cprintf>
  8025a1:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8025a4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8025ab:	83 ec 0c             	sub    $0xc,%esp
  8025ae:	68 54 46 80 00       	push   $0x804654
  8025b3:	e8 08 e6 ff ff       	call   800bc0 <cprintf>
  8025b8:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8025bb:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8025bf:	a1 40 50 80 00       	mov    0x805040,%eax
  8025c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025c7:	eb 56                	jmp    80261f <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8025c9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025cd:	74 1c                	je     8025eb <print_mem_block_lists+0x114>
  8025cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d2:	8b 50 08             	mov    0x8(%eax),%edx
  8025d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025d8:	8b 48 08             	mov    0x8(%eax),%ecx
  8025db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025de:	8b 40 0c             	mov    0xc(%eax),%eax
  8025e1:	01 c8                	add    %ecx,%eax
  8025e3:	39 c2                	cmp    %eax,%edx
  8025e5:	73 04                	jae    8025eb <print_mem_block_lists+0x114>
			sorted = 0 ;
  8025e7:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8025eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ee:	8b 50 08             	mov    0x8(%eax),%edx
  8025f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f4:	8b 40 0c             	mov    0xc(%eax),%eax
  8025f7:	01 c2                	add    %eax,%edx
  8025f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fc:	8b 40 08             	mov    0x8(%eax),%eax
  8025ff:	83 ec 04             	sub    $0x4,%esp
  802602:	52                   	push   %edx
  802603:	50                   	push   %eax
  802604:	68 21 46 80 00       	push   $0x804621
  802609:	e8 b2 e5 ff ff       	call   800bc0 <cprintf>
  80260e:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802611:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802614:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802617:	a1 48 50 80 00       	mov    0x805048,%eax
  80261c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80261f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802623:	74 07                	je     80262c <print_mem_block_lists+0x155>
  802625:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802628:	8b 00                	mov    (%eax),%eax
  80262a:	eb 05                	jmp    802631 <print_mem_block_lists+0x15a>
  80262c:	b8 00 00 00 00       	mov    $0x0,%eax
  802631:	a3 48 50 80 00       	mov    %eax,0x805048
  802636:	a1 48 50 80 00       	mov    0x805048,%eax
  80263b:	85 c0                	test   %eax,%eax
  80263d:	75 8a                	jne    8025c9 <print_mem_block_lists+0xf2>
  80263f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802643:	75 84                	jne    8025c9 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802645:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802649:	75 10                	jne    80265b <print_mem_block_lists+0x184>
  80264b:	83 ec 0c             	sub    $0xc,%esp
  80264e:	68 6c 46 80 00       	push   $0x80466c
  802653:	e8 68 e5 ff ff       	call   800bc0 <cprintf>
  802658:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80265b:	83 ec 0c             	sub    $0xc,%esp
  80265e:	68 e0 45 80 00       	push   $0x8045e0
  802663:	e8 58 e5 ff ff       	call   800bc0 <cprintf>
  802668:	83 c4 10             	add    $0x10,%esp

}
  80266b:	90                   	nop
  80266c:	c9                   	leave  
  80266d:	c3                   	ret    

0080266e <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80266e:	55                   	push   %ebp
  80266f:	89 e5                	mov    %esp,%ebp
  802671:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  802674:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  80267b:	00 00 00 
  80267e:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802685:	00 00 00 
  802688:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  80268f:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  802692:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802699:	e9 9e 00 00 00       	jmp    80273c <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  80269e:	a1 50 50 80 00       	mov    0x805050,%eax
  8026a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026a6:	c1 e2 04             	shl    $0x4,%edx
  8026a9:	01 d0                	add    %edx,%eax
  8026ab:	85 c0                	test   %eax,%eax
  8026ad:	75 14                	jne    8026c3 <initialize_MemBlocksList+0x55>
  8026af:	83 ec 04             	sub    $0x4,%esp
  8026b2:	68 94 46 80 00       	push   $0x804694
  8026b7:	6a 46                	push   $0x46
  8026b9:	68 b7 46 80 00       	push   $0x8046b7
  8026be:	e8 49 e2 ff ff       	call   80090c <_panic>
  8026c3:	a1 50 50 80 00       	mov    0x805050,%eax
  8026c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026cb:	c1 e2 04             	shl    $0x4,%edx
  8026ce:	01 d0                	add    %edx,%eax
  8026d0:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8026d6:	89 10                	mov    %edx,(%eax)
  8026d8:	8b 00                	mov    (%eax),%eax
  8026da:	85 c0                	test   %eax,%eax
  8026dc:	74 18                	je     8026f6 <initialize_MemBlocksList+0x88>
  8026de:	a1 48 51 80 00       	mov    0x805148,%eax
  8026e3:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8026e9:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8026ec:	c1 e1 04             	shl    $0x4,%ecx
  8026ef:	01 ca                	add    %ecx,%edx
  8026f1:	89 50 04             	mov    %edx,0x4(%eax)
  8026f4:	eb 12                	jmp    802708 <initialize_MemBlocksList+0x9a>
  8026f6:	a1 50 50 80 00       	mov    0x805050,%eax
  8026fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026fe:	c1 e2 04             	shl    $0x4,%edx
  802701:	01 d0                	add    %edx,%eax
  802703:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802708:	a1 50 50 80 00       	mov    0x805050,%eax
  80270d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802710:	c1 e2 04             	shl    $0x4,%edx
  802713:	01 d0                	add    %edx,%eax
  802715:	a3 48 51 80 00       	mov    %eax,0x805148
  80271a:	a1 50 50 80 00       	mov    0x805050,%eax
  80271f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802722:	c1 e2 04             	shl    $0x4,%edx
  802725:	01 d0                	add    %edx,%eax
  802727:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80272e:	a1 54 51 80 00       	mov    0x805154,%eax
  802733:	40                   	inc    %eax
  802734:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802739:	ff 45 f4             	incl   -0xc(%ebp)
  80273c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802742:	0f 82 56 ff ff ff    	jb     80269e <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802748:	90                   	nop
  802749:	c9                   	leave  
  80274a:	c3                   	ret    

0080274b <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80274b:	55                   	push   %ebp
  80274c:	89 e5                	mov    %esp,%ebp
  80274e:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802751:	8b 45 08             	mov    0x8(%ebp),%eax
  802754:	8b 00                	mov    (%eax),%eax
  802756:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802759:	eb 19                	jmp    802774 <find_block+0x29>
	{
		if(va==point->sva)
  80275b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80275e:	8b 40 08             	mov    0x8(%eax),%eax
  802761:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802764:	75 05                	jne    80276b <find_block+0x20>
		   return point;
  802766:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802769:	eb 36                	jmp    8027a1 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80276b:	8b 45 08             	mov    0x8(%ebp),%eax
  80276e:	8b 40 08             	mov    0x8(%eax),%eax
  802771:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802774:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802778:	74 07                	je     802781 <find_block+0x36>
  80277a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80277d:	8b 00                	mov    (%eax),%eax
  80277f:	eb 05                	jmp    802786 <find_block+0x3b>
  802781:	b8 00 00 00 00       	mov    $0x0,%eax
  802786:	8b 55 08             	mov    0x8(%ebp),%edx
  802789:	89 42 08             	mov    %eax,0x8(%edx)
  80278c:	8b 45 08             	mov    0x8(%ebp),%eax
  80278f:	8b 40 08             	mov    0x8(%eax),%eax
  802792:	85 c0                	test   %eax,%eax
  802794:	75 c5                	jne    80275b <find_block+0x10>
  802796:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80279a:	75 bf                	jne    80275b <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  80279c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027a1:	c9                   	leave  
  8027a2:	c3                   	ret    

008027a3 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8027a3:	55                   	push   %ebp
  8027a4:	89 e5                	mov    %esp,%ebp
  8027a6:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  8027a9:	a1 40 50 80 00       	mov    0x805040,%eax
  8027ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  8027b1:	a1 44 50 80 00       	mov    0x805044,%eax
  8027b6:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8027b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027bc:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8027bf:	74 24                	je     8027e5 <insert_sorted_allocList+0x42>
  8027c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c4:	8b 50 08             	mov    0x8(%eax),%edx
  8027c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ca:	8b 40 08             	mov    0x8(%eax),%eax
  8027cd:	39 c2                	cmp    %eax,%edx
  8027cf:	76 14                	jbe    8027e5 <insert_sorted_allocList+0x42>
  8027d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d4:	8b 50 08             	mov    0x8(%eax),%edx
  8027d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027da:	8b 40 08             	mov    0x8(%eax),%eax
  8027dd:	39 c2                	cmp    %eax,%edx
  8027df:	0f 82 60 01 00 00    	jb     802945 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8027e5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027e9:	75 65                	jne    802850 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8027eb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8027ef:	75 14                	jne    802805 <insert_sorted_allocList+0x62>
  8027f1:	83 ec 04             	sub    $0x4,%esp
  8027f4:	68 94 46 80 00       	push   $0x804694
  8027f9:	6a 6b                	push   $0x6b
  8027fb:	68 b7 46 80 00       	push   $0x8046b7
  802800:	e8 07 e1 ff ff       	call   80090c <_panic>
  802805:	8b 15 40 50 80 00    	mov    0x805040,%edx
  80280b:	8b 45 08             	mov    0x8(%ebp),%eax
  80280e:	89 10                	mov    %edx,(%eax)
  802810:	8b 45 08             	mov    0x8(%ebp),%eax
  802813:	8b 00                	mov    (%eax),%eax
  802815:	85 c0                	test   %eax,%eax
  802817:	74 0d                	je     802826 <insert_sorted_allocList+0x83>
  802819:	a1 40 50 80 00       	mov    0x805040,%eax
  80281e:	8b 55 08             	mov    0x8(%ebp),%edx
  802821:	89 50 04             	mov    %edx,0x4(%eax)
  802824:	eb 08                	jmp    80282e <insert_sorted_allocList+0x8b>
  802826:	8b 45 08             	mov    0x8(%ebp),%eax
  802829:	a3 44 50 80 00       	mov    %eax,0x805044
  80282e:	8b 45 08             	mov    0x8(%ebp),%eax
  802831:	a3 40 50 80 00       	mov    %eax,0x805040
  802836:	8b 45 08             	mov    0x8(%ebp),%eax
  802839:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802840:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802845:	40                   	inc    %eax
  802846:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80284b:	e9 dc 01 00 00       	jmp    802a2c <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802850:	8b 45 08             	mov    0x8(%ebp),%eax
  802853:	8b 50 08             	mov    0x8(%eax),%edx
  802856:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802859:	8b 40 08             	mov    0x8(%eax),%eax
  80285c:	39 c2                	cmp    %eax,%edx
  80285e:	77 6c                	ja     8028cc <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802860:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802864:	74 06                	je     80286c <insert_sorted_allocList+0xc9>
  802866:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80286a:	75 14                	jne    802880 <insert_sorted_allocList+0xdd>
  80286c:	83 ec 04             	sub    $0x4,%esp
  80286f:	68 d0 46 80 00       	push   $0x8046d0
  802874:	6a 6f                	push   $0x6f
  802876:	68 b7 46 80 00       	push   $0x8046b7
  80287b:	e8 8c e0 ff ff       	call   80090c <_panic>
  802880:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802883:	8b 50 04             	mov    0x4(%eax),%edx
  802886:	8b 45 08             	mov    0x8(%ebp),%eax
  802889:	89 50 04             	mov    %edx,0x4(%eax)
  80288c:	8b 45 08             	mov    0x8(%ebp),%eax
  80288f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802892:	89 10                	mov    %edx,(%eax)
  802894:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802897:	8b 40 04             	mov    0x4(%eax),%eax
  80289a:	85 c0                	test   %eax,%eax
  80289c:	74 0d                	je     8028ab <insert_sorted_allocList+0x108>
  80289e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028a1:	8b 40 04             	mov    0x4(%eax),%eax
  8028a4:	8b 55 08             	mov    0x8(%ebp),%edx
  8028a7:	89 10                	mov    %edx,(%eax)
  8028a9:	eb 08                	jmp    8028b3 <insert_sorted_allocList+0x110>
  8028ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ae:	a3 40 50 80 00       	mov    %eax,0x805040
  8028b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8028b9:	89 50 04             	mov    %edx,0x4(%eax)
  8028bc:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8028c1:	40                   	inc    %eax
  8028c2:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8028c7:	e9 60 01 00 00       	jmp    802a2c <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8028cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8028cf:	8b 50 08             	mov    0x8(%eax),%edx
  8028d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028d5:	8b 40 08             	mov    0x8(%eax),%eax
  8028d8:	39 c2                	cmp    %eax,%edx
  8028da:	0f 82 4c 01 00 00    	jb     802a2c <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8028e0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028e4:	75 14                	jne    8028fa <insert_sorted_allocList+0x157>
  8028e6:	83 ec 04             	sub    $0x4,%esp
  8028e9:	68 08 47 80 00       	push   $0x804708
  8028ee:	6a 73                	push   $0x73
  8028f0:	68 b7 46 80 00       	push   $0x8046b7
  8028f5:	e8 12 e0 ff ff       	call   80090c <_panic>
  8028fa:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802900:	8b 45 08             	mov    0x8(%ebp),%eax
  802903:	89 50 04             	mov    %edx,0x4(%eax)
  802906:	8b 45 08             	mov    0x8(%ebp),%eax
  802909:	8b 40 04             	mov    0x4(%eax),%eax
  80290c:	85 c0                	test   %eax,%eax
  80290e:	74 0c                	je     80291c <insert_sorted_allocList+0x179>
  802910:	a1 44 50 80 00       	mov    0x805044,%eax
  802915:	8b 55 08             	mov    0x8(%ebp),%edx
  802918:	89 10                	mov    %edx,(%eax)
  80291a:	eb 08                	jmp    802924 <insert_sorted_allocList+0x181>
  80291c:	8b 45 08             	mov    0x8(%ebp),%eax
  80291f:	a3 40 50 80 00       	mov    %eax,0x805040
  802924:	8b 45 08             	mov    0x8(%ebp),%eax
  802927:	a3 44 50 80 00       	mov    %eax,0x805044
  80292c:	8b 45 08             	mov    0x8(%ebp),%eax
  80292f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802935:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80293a:	40                   	inc    %eax
  80293b:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802940:	e9 e7 00 00 00       	jmp    802a2c <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802945:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802948:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  80294b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802952:	a1 40 50 80 00       	mov    0x805040,%eax
  802957:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80295a:	e9 9d 00 00 00       	jmp    8029fc <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  80295f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802962:	8b 00                	mov    (%eax),%eax
  802964:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802967:	8b 45 08             	mov    0x8(%ebp),%eax
  80296a:	8b 50 08             	mov    0x8(%eax),%edx
  80296d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802970:	8b 40 08             	mov    0x8(%eax),%eax
  802973:	39 c2                	cmp    %eax,%edx
  802975:	76 7d                	jbe    8029f4 <insert_sorted_allocList+0x251>
  802977:	8b 45 08             	mov    0x8(%ebp),%eax
  80297a:	8b 50 08             	mov    0x8(%eax),%edx
  80297d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802980:	8b 40 08             	mov    0x8(%eax),%eax
  802983:	39 c2                	cmp    %eax,%edx
  802985:	73 6d                	jae    8029f4 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802987:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80298b:	74 06                	je     802993 <insert_sorted_allocList+0x1f0>
  80298d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802991:	75 14                	jne    8029a7 <insert_sorted_allocList+0x204>
  802993:	83 ec 04             	sub    $0x4,%esp
  802996:	68 2c 47 80 00       	push   $0x80472c
  80299b:	6a 7f                	push   $0x7f
  80299d:	68 b7 46 80 00       	push   $0x8046b7
  8029a2:	e8 65 df ff ff       	call   80090c <_panic>
  8029a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029aa:	8b 10                	mov    (%eax),%edx
  8029ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8029af:	89 10                	mov    %edx,(%eax)
  8029b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b4:	8b 00                	mov    (%eax),%eax
  8029b6:	85 c0                	test   %eax,%eax
  8029b8:	74 0b                	je     8029c5 <insert_sorted_allocList+0x222>
  8029ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bd:	8b 00                	mov    (%eax),%eax
  8029bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8029c2:	89 50 04             	mov    %edx,0x4(%eax)
  8029c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8029cb:	89 10                	mov    %edx,(%eax)
  8029cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029d3:	89 50 04             	mov    %edx,0x4(%eax)
  8029d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d9:	8b 00                	mov    (%eax),%eax
  8029db:	85 c0                	test   %eax,%eax
  8029dd:	75 08                	jne    8029e7 <insert_sorted_allocList+0x244>
  8029df:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e2:	a3 44 50 80 00       	mov    %eax,0x805044
  8029e7:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8029ec:	40                   	inc    %eax
  8029ed:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8029f2:	eb 39                	jmp    802a2d <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8029f4:	a1 48 50 80 00       	mov    0x805048,%eax
  8029f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a00:	74 07                	je     802a09 <insert_sorted_allocList+0x266>
  802a02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a05:	8b 00                	mov    (%eax),%eax
  802a07:	eb 05                	jmp    802a0e <insert_sorted_allocList+0x26b>
  802a09:	b8 00 00 00 00       	mov    $0x0,%eax
  802a0e:	a3 48 50 80 00       	mov    %eax,0x805048
  802a13:	a1 48 50 80 00       	mov    0x805048,%eax
  802a18:	85 c0                	test   %eax,%eax
  802a1a:	0f 85 3f ff ff ff    	jne    80295f <insert_sorted_allocList+0x1bc>
  802a20:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a24:	0f 85 35 ff ff ff    	jne    80295f <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802a2a:	eb 01                	jmp    802a2d <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802a2c:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802a2d:	90                   	nop
  802a2e:	c9                   	leave  
  802a2f:	c3                   	ret    

00802a30 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802a30:	55                   	push   %ebp
  802a31:	89 e5                	mov    %esp,%ebp
  802a33:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802a36:	a1 38 51 80 00       	mov    0x805138,%eax
  802a3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a3e:	e9 85 01 00 00       	jmp    802bc8 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802a43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a46:	8b 40 0c             	mov    0xc(%eax),%eax
  802a49:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a4c:	0f 82 6e 01 00 00    	jb     802bc0 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802a52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a55:	8b 40 0c             	mov    0xc(%eax),%eax
  802a58:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a5b:	0f 85 8a 00 00 00    	jne    802aeb <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802a61:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a65:	75 17                	jne    802a7e <alloc_block_FF+0x4e>
  802a67:	83 ec 04             	sub    $0x4,%esp
  802a6a:	68 60 47 80 00       	push   $0x804760
  802a6f:	68 93 00 00 00       	push   $0x93
  802a74:	68 b7 46 80 00       	push   $0x8046b7
  802a79:	e8 8e de ff ff       	call   80090c <_panic>
  802a7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a81:	8b 00                	mov    (%eax),%eax
  802a83:	85 c0                	test   %eax,%eax
  802a85:	74 10                	je     802a97 <alloc_block_FF+0x67>
  802a87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8a:	8b 00                	mov    (%eax),%eax
  802a8c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a8f:	8b 52 04             	mov    0x4(%edx),%edx
  802a92:	89 50 04             	mov    %edx,0x4(%eax)
  802a95:	eb 0b                	jmp    802aa2 <alloc_block_FF+0x72>
  802a97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9a:	8b 40 04             	mov    0x4(%eax),%eax
  802a9d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802aa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa5:	8b 40 04             	mov    0x4(%eax),%eax
  802aa8:	85 c0                	test   %eax,%eax
  802aaa:	74 0f                	je     802abb <alloc_block_FF+0x8b>
  802aac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aaf:	8b 40 04             	mov    0x4(%eax),%eax
  802ab2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ab5:	8b 12                	mov    (%edx),%edx
  802ab7:	89 10                	mov    %edx,(%eax)
  802ab9:	eb 0a                	jmp    802ac5 <alloc_block_FF+0x95>
  802abb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802abe:	8b 00                	mov    (%eax),%eax
  802ac0:	a3 38 51 80 00       	mov    %eax,0x805138
  802ac5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ace:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ad8:	a1 44 51 80 00       	mov    0x805144,%eax
  802add:	48                   	dec    %eax
  802ade:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802ae3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae6:	e9 10 01 00 00       	jmp    802bfb <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802aeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aee:	8b 40 0c             	mov    0xc(%eax),%eax
  802af1:	3b 45 08             	cmp    0x8(%ebp),%eax
  802af4:	0f 86 c6 00 00 00    	jbe    802bc0 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802afa:	a1 48 51 80 00       	mov    0x805148,%eax
  802aff:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802b02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b05:	8b 50 08             	mov    0x8(%eax),%edx
  802b08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b0b:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802b0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b11:	8b 55 08             	mov    0x8(%ebp),%edx
  802b14:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802b17:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b1b:	75 17                	jne    802b34 <alloc_block_FF+0x104>
  802b1d:	83 ec 04             	sub    $0x4,%esp
  802b20:	68 60 47 80 00       	push   $0x804760
  802b25:	68 9b 00 00 00       	push   $0x9b
  802b2a:	68 b7 46 80 00       	push   $0x8046b7
  802b2f:	e8 d8 dd ff ff       	call   80090c <_panic>
  802b34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b37:	8b 00                	mov    (%eax),%eax
  802b39:	85 c0                	test   %eax,%eax
  802b3b:	74 10                	je     802b4d <alloc_block_FF+0x11d>
  802b3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b40:	8b 00                	mov    (%eax),%eax
  802b42:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b45:	8b 52 04             	mov    0x4(%edx),%edx
  802b48:	89 50 04             	mov    %edx,0x4(%eax)
  802b4b:	eb 0b                	jmp    802b58 <alloc_block_FF+0x128>
  802b4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b50:	8b 40 04             	mov    0x4(%eax),%eax
  802b53:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b5b:	8b 40 04             	mov    0x4(%eax),%eax
  802b5e:	85 c0                	test   %eax,%eax
  802b60:	74 0f                	je     802b71 <alloc_block_FF+0x141>
  802b62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b65:	8b 40 04             	mov    0x4(%eax),%eax
  802b68:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b6b:	8b 12                	mov    (%edx),%edx
  802b6d:	89 10                	mov    %edx,(%eax)
  802b6f:	eb 0a                	jmp    802b7b <alloc_block_FF+0x14b>
  802b71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b74:	8b 00                	mov    (%eax),%eax
  802b76:	a3 48 51 80 00       	mov    %eax,0x805148
  802b7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b7e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b87:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b8e:	a1 54 51 80 00       	mov    0x805154,%eax
  802b93:	48                   	dec    %eax
  802b94:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802b99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9c:	8b 50 08             	mov    0x8(%eax),%edx
  802b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba2:	01 c2                	add    %eax,%edx
  802ba4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba7:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802baa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bad:	8b 40 0c             	mov    0xc(%eax),%eax
  802bb0:	2b 45 08             	sub    0x8(%ebp),%eax
  802bb3:	89 c2                	mov    %eax,%edx
  802bb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb8:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802bbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bbe:	eb 3b                	jmp    802bfb <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802bc0:	a1 40 51 80 00       	mov    0x805140,%eax
  802bc5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bc8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bcc:	74 07                	je     802bd5 <alloc_block_FF+0x1a5>
  802bce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd1:	8b 00                	mov    (%eax),%eax
  802bd3:	eb 05                	jmp    802bda <alloc_block_FF+0x1aa>
  802bd5:	b8 00 00 00 00       	mov    $0x0,%eax
  802bda:	a3 40 51 80 00       	mov    %eax,0x805140
  802bdf:	a1 40 51 80 00       	mov    0x805140,%eax
  802be4:	85 c0                	test   %eax,%eax
  802be6:	0f 85 57 fe ff ff    	jne    802a43 <alloc_block_FF+0x13>
  802bec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bf0:	0f 85 4d fe ff ff    	jne    802a43 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802bf6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bfb:	c9                   	leave  
  802bfc:	c3                   	ret    

00802bfd <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802bfd:	55                   	push   %ebp
  802bfe:	89 e5                	mov    %esp,%ebp
  802c00:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802c03:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802c0a:	a1 38 51 80 00       	mov    0x805138,%eax
  802c0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c12:	e9 df 00 00 00       	jmp    802cf6 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802c17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1a:	8b 40 0c             	mov    0xc(%eax),%eax
  802c1d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c20:	0f 82 c8 00 00 00    	jb     802cee <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802c26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c29:	8b 40 0c             	mov    0xc(%eax),%eax
  802c2c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c2f:	0f 85 8a 00 00 00    	jne    802cbf <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802c35:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c39:	75 17                	jne    802c52 <alloc_block_BF+0x55>
  802c3b:	83 ec 04             	sub    $0x4,%esp
  802c3e:	68 60 47 80 00       	push   $0x804760
  802c43:	68 b7 00 00 00       	push   $0xb7
  802c48:	68 b7 46 80 00       	push   $0x8046b7
  802c4d:	e8 ba dc ff ff       	call   80090c <_panic>
  802c52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c55:	8b 00                	mov    (%eax),%eax
  802c57:	85 c0                	test   %eax,%eax
  802c59:	74 10                	je     802c6b <alloc_block_BF+0x6e>
  802c5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5e:	8b 00                	mov    (%eax),%eax
  802c60:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c63:	8b 52 04             	mov    0x4(%edx),%edx
  802c66:	89 50 04             	mov    %edx,0x4(%eax)
  802c69:	eb 0b                	jmp    802c76 <alloc_block_BF+0x79>
  802c6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6e:	8b 40 04             	mov    0x4(%eax),%eax
  802c71:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c79:	8b 40 04             	mov    0x4(%eax),%eax
  802c7c:	85 c0                	test   %eax,%eax
  802c7e:	74 0f                	je     802c8f <alloc_block_BF+0x92>
  802c80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c83:	8b 40 04             	mov    0x4(%eax),%eax
  802c86:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c89:	8b 12                	mov    (%edx),%edx
  802c8b:	89 10                	mov    %edx,(%eax)
  802c8d:	eb 0a                	jmp    802c99 <alloc_block_BF+0x9c>
  802c8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c92:	8b 00                	mov    (%eax),%eax
  802c94:	a3 38 51 80 00       	mov    %eax,0x805138
  802c99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ca2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cac:	a1 44 51 80 00       	mov    0x805144,%eax
  802cb1:	48                   	dec    %eax
  802cb2:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802cb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cba:	e9 4d 01 00 00       	jmp    802e0c <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802cbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc2:	8b 40 0c             	mov    0xc(%eax),%eax
  802cc5:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cc8:	76 24                	jbe    802cee <alloc_block_BF+0xf1>
  802cca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ccd:	8b 40 0c             	mov    0xc(%eax),%eax
  802cd0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802cd3:	73 19                	jae    802cee <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802cd5:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802cdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cdf:	8b 40 0c             	mov    0xc(%eax),%eax
  802ce2:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802ce5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce8:	8b 40 08             	mov    0x8(%eax),%eax
  802ceb:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802cee:	a1 40 51 80 00       	mov    0x805140,%eax
  802cf3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cf6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cfa:	74 07                	je     802d03 <alloc_block_BF+0x106>
  802cfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cff:	8b 00                	mov    (%eax),%eax
  802d01:	eb 05                	jmp    802d08 <alloc_block_BF+0x10b>
  802d03:	b8 00 00 00 00       	mov    $0x0,%eax
  802d08:	a3 40 51 80 00       	mov    %eax,0x805140
  802d0d:	a1 40 51 80 00       	mov    0x805140,%eax
  802d12:	85 c0                	test   %eax,%eax
  802d14:	0f 85 fd fe ff ff    	jne    802c17 <alloc_block_BF+0x1a>
  802d1a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d1e:	0f 85 f3 fe ff ff    	jne    802c17 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802d24:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802d28:	0f 84 d9 00 00 00    	je     802e07 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802d2e:	a1 48 51 80 00       	mov    0x805148,%eax
  802d33:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802d36:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d39:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d3c:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802d3f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d42:	8b 55 08             	mov    0x8(%ebp),%edx
  802d45:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802d48:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802d4c:	75 17                	jne    802d65 <alloc_block_BF+0x168>
  802d4e:	83 ec 04             	sub    $0x4,%esp
  802d51:	68 60 47 80 00       	push   $0x804760
  802d56:	68 c7 00 00 00       	push   $0xc7
  802d5b:	68 b7 46 80 00       	push   $0x8046b7
  802d60:	e8 a7 db ff ff       	call   80090c <_panic>
  802d65:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d68:	8b 00                	mov    (%eax),%eax
  802d6a:	85 c0                	test   %eax,%eax
  802d6c:	74 10                	je     802d7e <alloc_block_BF+0x181>
  802d6e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d71:	8b 00                	mov    (%eax),%eax
  802d73:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d76:	8b 52 04             	mov    0x4(%edx),%edx
  802d79:	89 50 04             	mov    %edx,0x4(%eax)
  802d7c:	eb 0b                	jmp    802d89 <alloc_block_BF+0x18c>
  802d7e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d81:	8b 40 04             	mov    0x4(%eax),%eax
  802d84:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d89:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d8c:	8b 40 04             	mov    0x4(%eax),%eax
  802d8f:	85 c0                	test   %eax,%eax
  802d91:	74 0f                	je     802da2 <alloc_block_BF+0x1a5>
  802d93:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d96:	8b 40 04             	mov    0x4(%eax),%eax
  802d99:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d9c:	8b 12                	mov    (%edx),%edx
  802d9e:	89 10                	mov    %edx,(%eax)
  802da0:	eb 0a                	jmp    802dac <alloc_block_BF+0x1af>
  802da2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802da5:	8b 00                	mov    (%eax),%eax
  802da7:	a3 48 51 80 00       	mov    %eax,0x805148
  802dac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802daf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802db5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802db8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dbf:	a1 54 51 80 00       	mov    0x805154,%eax
  802dc4:	48                   	dec    %eax
  802dc5:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802dca:	83 ec 08             	sub    $0x8,%esp
  802dcd:	ff 75 ec             	pushl  -0x14(%ebp)
  802dd0:	68 38 51 80 00       	push   $0x805138
  802dd5:	e8 71 f9 ff ff       	call   80274b <find_block>
  802dda:	83 c4 10             	add    $0x10,%esp
  802ddd:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802de0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802de3:	8b 50 08             	mov    0x8(%eax),%edx
  802de6:	8b 45 08             	mov    0x8(%ebp),%eax
  802de9:	01 c2                	add    %eax,%edx
  802deb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802dee:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802df1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802df4:	8b 40 0c             	mov    0xc(%eax),%eax
  802df7:	2b 45 08             	sub    0x8(%ebp),%eax
  802dfa:	89 c2                	mov    %eax,%edx
  802dfc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802dff:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802e02:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e05:	eb 05                	jmp    802e0c <alloc_block_BF+0x20f>
	}
	return NULL;
  802e07:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e0c:	c9                   	leave  
  802e0d:	c3                   	ret    

00802e0e <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802e0e:	55                   	push   %ebp
  802e0f:	89 e5                	mov    %esp,%ebp
  802e11:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802e14:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802e19:	85 c0                	test   %eax,%eax
  802e1b:	0f 85 de 01 00 00    	jne    802fff <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802e21:	a1 38 51 80 00       	mov    0x805138,%eax
  802e26:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e29:	e9 9e 01 00 00       	jmp    802fcc <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802e2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e31:	8b 40 0c             	mov    0xc(%eax),%eax
  802e34:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e37:	0f 82 87 01 00 00    	jb     802fc4 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802e3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e40:	8b 40 0c             	mov    0xc(%eax),%eax
  802e43:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e46:	0f 85 95 00 00 00    	jne    802ee1 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802e4c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e50:	75 17                	jne    802e69 <alloc_block_NF+0x5b>
  802e52:	83 ec 04             	sub    $0x4,%esp
  802e55:	68 60 47 80 00       	push   $0x804760
  802e5a:	68 e0 00 00 00       	push   $0xe0
  802e5f:	68 b7 46 80 00       	push   $0x8046b7
  802e64:	e8 a3 da ff ff       	call   80090c <_panic>
  802e69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6c:	8b 00                	mov    (%eax),%eax
  802e6e:	85 c0                	test   %eax,%eax
  802e70:	74 10                	je     802e82 <alloc_block_NF+0x74>
  802e72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e75:	8b 00                	mov    (%eax),%eax
  802e77:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e7a:	8b 52 04             	mov    0x4(%edx),%edx
  802e7d:	89 50 04             	mov    %edx,0x4(%eax)
  802e80:	eb 0b                	jmp    802e8d <alloc_block_NF+0x7f>
  802e82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e85:	8b 40 04             	mov    0x4(%eax),%eax
  802e88:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e90:	8b 40 04             	mov    0x4(%eax),%eax
  802e93:	85 c0                	test   %eax,%eax
  802e95:	74 0f                	je     802ea6 <alloc_block_NF+0x98>
  802e97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9a:	8b 40 04             	mov    0x4(%eax),%eax
  802e9d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ea0:	8b 12                	mov    (%edx),%edx
  802ea2:	89 10                	mov    %edx,(%eax)
  802ea4:	eb 0a                	jmp    802eb0 <alloc_block_NF+0xa2>
  802ea6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea9:	8b 00                	mov    (%eax),%eax
  802eab:	a3 38 51 80 00       	mov    %eax,0x805138
  802eb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802eb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ec3:	a1 44 51 80 00       	mov    0x805144,%eax
  802ec8:	48                   	dec    %eax
  802ec9:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802ece:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed1:	8b 40 08             	mov    0x8(%eax),%eax
  802ed4:	a3 2c 50 80 00       	mov    %eax,0x80502c
				   return  point;
  802ed9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802edc:	e9 f8 04 00 00       	jmp    8033d9 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802ee1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee4:	8b 40 0c             	mov    0xc(%eax),%eax
  802ee7:	3b 45 08             	cmp    0x8(%ebp),%eax
  802eea:	0f 86 d4 00 00 00    	jbe    802fc4 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802ef0:	a1 48 51 80 00       	mov    0x805148,%eax
  802ef5:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802ef8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802efb:	8b 50 08             	mov    0x8(%eax),%edx
  802efe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f01:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802f04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f07:	8b 55 08             	mov    0x8(%ebp),%edx
  802f0a:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802f0d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f11:	75 17                	jne    802f2a <alloc_block_NF+0x11c>
  802f13:	83 ec 04             	sub    $0x4,%esp
  802f16:	68 60 47 80 00       	push   $0x804760
  802f1b:	68 e9 00 00 00       	push   $0xe9
  802f20:	68 b7 46 80 00       	push   $0x8046b7
  802f25:	e8 e2 d9 ff ff       	call   80090c <_panic>
  802f2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f2d:	8b 00                	mov    (%eax),%eax
  802f2f:	85 c0                	test   %eax,%eax
  802f31:	74 10                	je     802f43 <alloc_block_NF+0x135>
  802f33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f36:	8b 00                	mov    (%eax),%eax
  802f38:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f3b:	8b 52 04             	mov    0x4(%edx),%edx
  802f3e:	89 50 04             	mov    %edx,0x4(%eax)
  802f41:	eb 0b                	jmp    802f4e <alloc_block_NF+0x140>
  802f43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f46:	8b 40 04             	mov    0x4(%eax),%eax
  802f49:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f51:	8b 40 04             	mov    0x4(%eax),%eax
  802f54:	85 c0                	test   %eax,%eax
  802f56:	74 0f                	je     802f67 <alloc_block_NF+0x159>
  802f58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f5b:	8b 40 04             	mov    0x4(%eax),%eax
  802f5e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f61:	8b 12                	mov    (%edx),%edx
  802f63:	89 10                	mov    %edx,(%eax)
  802f65:	eb 0a                	jmp    802f71 <alloc_block_NF+0x163>
  802f67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f6a:	8b 00                	mov    (%eax),%eax
  802f6c:	a3 48 51 80 00       	mov    %eax,0x805148
  802f71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f74:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f7d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f84:	a1 54 51 80 00       	mov    0x805154,%eax
  802f89:	48                   	dec    %eax
  802f8a:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802f8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f92:	8b 40 08             	mov    0x8(%eax),%eax
  802f95:	a3 2c 50 80 00       	mov    %eax,0x80502c
				   point->sva += size;
  802f9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f9d:	8b 50 08             	mov    0x8(%eax),%edx
  802fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa3:	01 c2                	add    %eax,%edx
  802fa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa8:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802fab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fae:	8b 40 0c             	mov    0xc(%eax),%eax
  802fb1:	2b 45 08             	sub    0x8(%ebp),%eax
  802fb4:	89 c2                	mov    %eax,%edx
  802fb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb9:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802fbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fbf:	e9 15 04 00 00       	jmp    8033d9 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802fc4:	a1 40 51 80 00       	mov    0x805140,%eax
  802fc9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fcc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fd0:	74 07                	je     802fd9 <alloc_block_NF+0x1cb>
  802fd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd5:	8b 00                	mov    (%eax),%eax
  802fd7:	eb 05                	jmp    802fde <alloc_block_NF+0x1d0>
  802fd9:	b8 00 00 00 00       	mov    $0x0,%eax
  802fde:	a3 40 51 80 00       	mov    %eax,0x805140
  802fe3:	a1 40 51 80 00       	mov    0x805140,%eax
  802fe8:	85 c0                	test   %eax,%eax
  802fea:	0f 85 3e fe ff ff    	jne    802e2e <alloc_block_NF+0x20>
  802ff0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ff4:	0f 85 34 fe ff ff    	jne    802e2e <alloc_block_NF+0x20>
  802ffa:	e9 d5 03 00 00       	jmp    8033d4 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802fff:	a1 38 51 80 00       	mov    0x805138,%eax
  803004:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803007:	e9 b1 01 00 00       	jmp    8031bd <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  80300c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80300f:	8b 50 08             	mov    0x8(%eax),%edx
  803012:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803017:	39 c2                	cmp    %eax,%edx
  803019:	0f 82 96 01 00 00    	jb     8031b5 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  80301f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803022:	8b 40 0c             	mov    0xc(%eax),%eax
  803025:	3b 45 08             	cmp    0x8(%ebp),%eax
  803028:	0f 82 87 01 00 00    	jb     8031b5 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  80302e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803031:	8b 40 0c             	mov    0xc(%eax),%eax
  803034:	3b 45 08             	cmp    0x8(%ebp),%eax
  803037:	0f 85 95 00 00 00    	jne    8030d2 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  80303d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803041:	75 17                	jne    80305a <alloc_block_NF+0x24c>
  803043:	83 ec 04             	sub    $0x4,%esp
  803046:	68 60 47 80 00       	push   $0x804760
  80304b:	68 fc 00 00 00       	push   $0xfc
  803050:	68 b7 46 80 00       	push   $0x8046b7
  803055:	e8 b2 d8 ff ff       	call   80090c <_panic>
  80305a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305d:	8b 00                	mov    (%eax),%eax
  80305f:	85 c0                	test   %eax,%eax
  803061:	74 10                	je     803073 <alloc_block_NF+0x265>
  803063:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803066:	8b 00                	mov    (%eax),%eax
  803068:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80306b:	8b 52 04             	mov    0x4(%edx),%edx
  80306e:	89 50 04             	mov    %edx,0x4(%eax)
  803071:	eb 0b                	jmp    80307e <alloc_block_NF+0x270>
  803073:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803076:	8b 40 04             	mov    0x4(%eax),%eax
  803079:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80307e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803081:	8b 40 04             	mov    0x4(%eax),%eax
  803084:	85 c0                	test   %eax,%eax
  803086:	74 0f                	je     803097 <alloc_block_NF+0x289>
  803088:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80308b:	8b 40 04             	mov    0x4(%eax),%eax
  80308e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803091:	8b 12                	mov    (%edx),%edx
  803093:	89 10                	mov    %edx,(%eax)
  803095:	eb 0a                	jmp    8030a1 <alloc_block_NF+0x293>
  803097:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80309a:	8b 00                	mov    (%eax),%eax
  80309c:	a3 38 51 80 00       	mov    %eax,0x805138
  8030a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ad:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030b4:	a1 44 51 80 00       	mov    0x805144,%eax
  8030b9:	48                   	dec    %eax
  8030ba:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8030bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c2:	8b 40 08             	mov    0x8(%eax),%eax
  8030c5:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   return  point;
  8030ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030cd:	e9 07 03 00 00       	jmp    8033d9 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8030d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d5:	8b 40 0c             	mov    0xc(%eax),%eax
  8030d8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030db:	0f 86 d4 00 00 00    	jbe    8031b5 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8030e1:	a1 48 51 80 00       	mov    0x805148,%eax
  8030e6:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  8030e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ec:	8b 50 08             	mov    0x8(%eax),%edx
  8030ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030f2:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8030f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030f8:	8b 55 08             	mov    0x8(%ebp),%edx
  8030fb:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8030fe:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803102:	75 17                	jne    80311b <alloc_block_NF+0x30d>
  803104:	83 ec 04             	sub    $0x4,%esp
  803107:	68 60 47 80 00       	push   $0x804760
  80310c:	68 04 01 00 00       	push   $0x104
  803111:	68 b7 46 80 00       	push   $0x8046b7
  803116:	e8 f1 d7 ff ff       	call   80090c <_panic>
  80311b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80311e:	8b 00                	mov    (%eax),%eax
  803120:	85 c0                	test   %eax,%eax
  803122:	74 10                	je     803134 <alloc_block_NF+0x326>
  803124:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803127:	8b 00                	mov    (%eax),%eax
  803129:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80312c:	8b 52 04             	mov    0x4(%edx),%edx
  80312f:	89 50 04             	mov    %edx,0x4(%eax)
  803132:	eb 0b                	jmp    80313f <alloc_block_NF+0x331>
  803134:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803137:	8b 40 04             	mov    0x4(%eax),%eax
  80313a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80313f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803142:	8b 40 04             	mov    0x4(%eax),%eax
  803145:	85 c0                	test   %eax,%eax
  803147:	74 0f                	je     803158 <alloc_block_NF+0x34a>
  803149:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80314c:	8b 40 04             	mov    0x4(%eax),%eax
  80314f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803152:	8b 12                	mov    (%edx),%edx
  803154:	89 10                	mov    %edx,(%eax)
  803156:	eb 0a                	jmp    803162 <alloc_block_NF+0x354>
  803158:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80315b:	8b 00                	mov    (%eax),%eax
  80315d:	a3 48 51 80 00       	mov    %eax,0x805148
  803162:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803165:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80316b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80316e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803175:	a1 54 51 80 00       	mov    0x805154,%eax
  80317a:	48                   	dec    %eax
  80317b:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  803180:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803183:	8b 40 08             	mov    0x8(%eax),%eax
  803186:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   point->sva += size;
  80318b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80318e:	8b 50 08             	mov    0x8(%eax),%edx
  803191:	8b 45 08             	mov    0x8(%ebp),%eax
  803194:	01 c2                	add    %eax,%edx
  803196:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803199:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  80319c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80319f:	8b 40 0c             	mov    0xc(%eax),%eax
  8031a2:	2b 45 08             	sub    0x8(%ebp),%eax
  8031a5:	89 c2                	mov    %eax,%edx
  8031a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031aa:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8031ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031b0:	e9 24 02 00 00       	jmp    8033d9 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8031b5:	a1 40 51 80 00       	mov    0x805140,%eax
  8031ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031c1:	74 07                	je     8031ca <alloc_block_NF+0x3bc>
  8031c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c6:	8b 00                	mov    (%eax),%eax
  8031c8:	eb 05                	jmp    8031cf <alloc_block_NF+0x3c1>
  8031ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8031cf:	a3 40 51 80 00       	mov    %eax,0x805140
  8031d4:	a1 40 51 80 00       	mov    0x805140,%eax
  8031d9:	85 c0                	test   %eax,%eax
  8031db:	0f 85 2b fe ff ff    	jne    80300c <alloc_block_NF+0x1fe>
  8031e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031e5:	0f 85 21 fe ff ff    	jne    80300c <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8031eb:	a1 38 51 80 00       	mov    0x805138,%eax
  8031f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031f3:	e9 ae 01 00 00       	jmp    8033a6 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  8031f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031fb:	8b 50 08             	mov    0x8(%eax),%edx
  8031fe:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803203:	39 c2                	cmp    %eax,%edx
  803205:	0f 83 93 01 00 00    	jae    80339e <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  80320b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80320e:	8b 40 0c             	mov    0xc(%eax),%eax
  803211:	3b 45 08             	cmp    0x8(%ebp),%eax
  803214:	0f 82 84 01 00 00    	jb     80339e <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  80321a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80321d:	8b 40 0c             	mov    0xc(%eax),%eax
  803220:	3b 45 08             	cmp    0x8(%ebp),%eax
  803223:	0f 85 95 00 00 00    	jne    8032be <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  803229:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80322d:	75 17                	jne    803246 <alloc_block_NF+0x438>
  80322f:	83 ec 04             	sub    $0x4,%esp
  803232:	68 60 47 80 00       	push   $0x804760
  803237:	68 14 01 00 00       	push   $0x114
  80323c:	68 b7 46 80 00       	push   $0x8046b7
  803241:	e8 c6 d6 ff ff       	call   80090c <_panic>
  803246:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803249:	8b 00                	mov    (%eax),%eax
  80324b:	85 c0                	test   %eax,%eax
  80324d:	74 10                	je     80325f <alloc_block_NF+0x451>
  80324f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803252:	8b 00                	mov    (%eax),%eax
  803254:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803257:	8b 52 04             	mov    0x4(%edx),%edx
  80325a:	89 50 04             	mov    %edx,0x4(%eax)
  80325d:	eb 0b                	jmp    80326a <alloc_block_NF+0x45c>
  80325f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803262:	8b 40 04             	mov    0x4(%eax),%eax
  803265:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80326a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80326d:	8b 40 04             	mov    0x4(%eax),%eax
  803270:	85 c0                	test   %eax,%eax
  803272:	74 0f                	je     803283 <alloc_block_NF+0x475>
  803274:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803277:	8b 40 04             	mov    0x4(%eax),%eax
  80327a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80327d:	8b 12                	mov    (%edx),%edx
  80327f:	89 10                	mov    %edx,(%eax)
  803281:	eb 0a                	jmp    80328d <alloc_block_NF+0x47f>
  803283:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803286:	8b 00                	mov    (%eax),%eax
  803288:	a3 38 51 80 00       	mov    %eax,0x805138
  80328d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803290:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803296:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803299:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032a0:	a1 44 51 80 00       	mov    0x805144,%eax
  8032a5:	48                   	dec    %eax
  8032a6:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8032ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ae:	8b 40 08             	mov    0x8(%eax),%eax
  8032b1:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   return  point;
  8032b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b9:	e9 1b 01 00 00       	jmp    8033d9 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8032be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c1:	8b 40 0c             	mov    0xc(%eax),%eax
  8032c4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8032c7:	0f 86 d1 00 00 00    	jbe    80339e <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8032cd:	a1 48 51 80 00       	mov    0x805148,%eax
  8032d2:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  8032d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d8:	8b 50 08             	mov    0x8(%eax),%edx
  8032db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032de:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8032e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8032e7:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8032ea:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8032ee:	75 17                	jne    803307 <alloc_block_NF+0x4f9>
  8032f0:	83 ec 04             	sub    $0x4,%esp
  8032f3:	68 60 47 80 00       	push   $0x804760
  8032f8:	68 1c 01 00 00       	push   $0x11c
  8032fd:	68 b7 46 80 00       	push   $0x8046b7
  803302:	e8 05 d6 ff ff       	call   80090c <_panic>
  803307:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80330a:	8b 00                	mov    (%eax),%eax
  80330c:	85 c0                	test   %eax,%eax
  80330e:	74 10                	je     803320 <alloc_block_NF+0x512>
  803310:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803313:	8b 00                	mov    (%eax),%eax
  803315:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803318:	8b 52 04             	mov    0x4(%edx),%edx
  80331b:	89 50 04             	mov    %edx,0x4(%eax)
  80331e:	eb 0b                	jmp    80332b <alloc_block_NF+0x51d>
  803320:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803323:	8b 40 04             	mov    0x4(%eax),%eax
  803326:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80332b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80332e:	8b 40 04             	mov    0x4(%eax),%eax
  803331:	85 c0                	test   %eax,%eax
  803333:	74 0f                	je     803344 <alloc_block_NF+0x536>
  803335:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803338:	8b 40 04             	mov    0x4(%eax),%eax
  80333b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80333e:	8b 12                	mov    (%edx),%edx
  803340:	89 10                	mov    %edx,(%eax)
  803342:	eb 0a                	jmp    80334e <alloc_block_NF+0x540>
  803344:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803347:	8b 00                	mov    (%eax),%eax
  803349:	a3 48 51 80 00       	mov    %eax,0x805148
  80334e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803351:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803357:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80335a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803361:	a1 54 51 80 00       	mov    0x805154,%eax
  803366:	48                   	dec    %eax
  803367:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  80336c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80336f:	8b 40 08             	mov    0x8(%eax),%eax
  803372:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   point->sva += size;
  803377:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80337a:	8b 50 08             	mov    0x8(%eax),%edx
  80337d:	8b 45 08             	mov    0x8(%ebp),%eax
  803380:	01 c2                	add    %eax,%edx
  803382:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803385:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803388:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80338b:	8b 40 0c             	mov    0xc(%eax),%eax
  80338e:	2b 45 08             	sub    0x8(%ebp),%eax
  803391:	89 c2                	mov    %eax,%edx
  803393:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803396:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803399:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80339c:	eb 3b                	jmp    8033d9 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  80339e:	a1 40 51 80 00       	mov    0x805140,%eax
  8033a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033aa:	74 07                	je     8033b3 <alloc_block_NF+0x5a5>
  8033ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033af:	8b 00                	mov    (%eax),%eax
  8033b1:	eb 05                	jmp    8033b8 <alloc_block_NF+0x5aa>
  8033b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8033b8:	a3 40 51 80 00       	mov    %eax,0x805140
  8033bd:	a1 40 51 80 00       	mov    0x805140,%eax
  8033c2:	85 c0                	test   %eax,%eax
  8033c4:	0f 85 2e fe ff ff    	jne    8031f8 <alloc_block_NF+0x3ea>
  8033ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033ce:	0f 85 24 fe ff ff    	jne    8031f8 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  8033d4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8033d9:	c9                   	leave  
  8033da:	c3                   	ret    

008033db <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8033db:	55                   	push   %ebp
  8033dc:	89 e5                	mov    %esp,%ebp
  8033de:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  8033e1:	a1 38 51 80 00       	mov    0x805138,%eax
  8033e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  8033e9:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8033ee:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  8033f1:	a1 38 51 80 00       	mov    0x805138,%eax
  8033f6:	85 c0                	test   %eax,%eax
  8033f8:	74 14                	je     80340e <insert_sorted_with_merge_freeList+0x33>
  8033fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8033fd:	8b 50 08             	mov    0x8(%eax),%edx
  803400:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803403:	8b 40 08             	mov    0x8(%eax),%eax
  803406:	39 c2                	cmp    %eax,%edx
  803408:	0f 87 9b 01 00 00    	ja     8035a9 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  80340e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803412:	75 17                	jne    80342b <insert_sorted_with_merge_freeList+0x50>
  803414:	83 ec 04             	sub    $0x4,%esp
  803417:	68 94 46 80 00       	push   $0x804694
  80341c:	68 38 01 00 00       	push   $0x138
  803421:	68 b7 46 80 00       	push   $0x8046b7
  803426:	e8 e1 d4 ff ff       	call   80090c <_panic>
  80342b:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803431:	8b 45 08             	mov    0x8(%ebp),%eax
  803434:	89 10                	mov    %edx,(%eax)
  803436:	8b 45 08             	mov    0x8(%ebp),%eax
  803439:	8b 00                	mov    (%eax),%eax
  80343b:	85 c0                	test   %eax,%eax
  80343d:	74 0d                	je     80344c <insert_sorted_with_merge_freeList+0x71>
  80343f:	a1 38 51 80 00       	mov    0x805138,%eax
  803444:	8b 55 08             	mov    0x8(%ebp),%edx
  803447:	89 50 04             	mov    %edx,0x4(%eax)
  80344a:	eb 08                	jmp    803454 <insert_sorted_with_merge_freeList+0x79>
  80344c:	8b 45 08             	mov    0x8(%ebp),%eax
  80344f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803454:	8b 45 08             	mov    0x8(%ebp),%eax
  803457:	a3 38 51 80 00       	mov    %eax,0x805138
  80345c:	8b 45 08             	mov    0x8(%ebp),%eax
  80345f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803466:	a1 44 51 80 00       	mov    0x805144,%eax
  80346b:	40                   	inc    %eax
  80346c:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803471:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803475:	0f 84 a8 06 00 00    	je     803b23 <insert_sorted_with_merge_freeList+0x748>
  80347b:	8b 45 08             	mov    0x8(%ebp),%eax
  80347e:	8b 50 08             	mov    0x8(%eax),%edx
  803481:	8b 45 08             	mov    0x8(%ebp),%eax
  803484:	8b 40 0c             	mov    0xc(%eax),%eax
  803487:	01 c2                	add    %eax,%edx
  803489:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80348c:	8b 40 08             	mov    0x8(%eax),%eax
  80348f:	39 c2                	cmp    %eax,%edx
  803491:	0f 85 8c 06 00 00    	jne    803b23 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  803497:	8b 45 08             	mov    0x8(%ebp),%eax
  80349a:	8b 50 0c             	mov    0xc(%eax),%edx
  80349d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034a0:	8b 40 0c             	mov    0xc(%eax),%eax
  8034a3:	01 c2                	add    %eax,%edx
  8034a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a8:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  8034ab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8034af:	75 17                	jne    8034c8 <insert_sorted_with_merge_freeList+0xed>
  8034b1:	83 ec 04             	sub    $0x4,%esp
  8034b4:	68 60 47 80 00       	push   $0x804760
  8034b9:	68 3c 01 00 00       	push   $0x13c
  8034be:	68 b7 46 80 00       	push   $0x8046b7
  8034c3:	e8 44 d4 ff ff       	call   80090c <_panic>
  8034c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034cb:	8b 00                	mov    (%eax),%eax
  8034cd:	85 c0                	test   %eax,%eax
  8034cf:	74 10                	je     8034e1 <insert_sorted_with_merge_freeList+0x106>
  8034d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034d4:	8b 00                	mov    (%eax),%eax
  8034d6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034d9:	8b 52 04             	mov    0x4(%edx),%edx
  8034dc:	89 50 04             	mov    %edx,0x4(%eax)
  8034df:	eb 0b                	jmp    8034ec <insert_sorted_with_merge_freeList+0x111>
  8034e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034e4:	8b 40 04             	mov    0x4(%eax),%eax
  8034e7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8034ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034ef:	8b 40 04             	mov    0x4(%eax),%eax
  8034f2:	85 c0                	test   %eax,%eax
  8034f4:	74 0f                	je     803505 <insert_sorted_with_merge_freeList+0x12a>
  8034f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034f9:	8b 40 04             	mov    0x4(%eax),%eax
  8034fc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034ff:	8b 12                	mov    (%edx),%edx
  803501:	89 10                	mov    %edx,(%eax)
  803503:	eb 0a                	jmp    80350f <insert_sorted_with_merge_freeList+0x134>
  803505:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803508:	8b 00                	mov    (%eax),%eax
  80350a:	a3 38 51 80 00       	mov    %eax,0x805138
  80350f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803512:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803518:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80351b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803522:	a1 44 51 80 00       	mov    0x805144,%eax
  803527:	48                   	dec    %eax
  803528:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  80352d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803530:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  803537:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80353a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  803541:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803545:	75 17                	jne    80355e <insert_sorted_with_merge_freeList+0x183>
  803547:	83 ec 04             	sub    $0x4,%esp
  80354a:	68 94 46 80 00       	push   $0x804694
  80354f:	68 3f 01 00 00       	push   $0x13f
  803554:	68 b7 46 80 00       	push   $0x8046b7
  803559:	e8 ae d3 ff ff       	call   80090c <_panic>
  80355e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803564:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803567:	89 10                	mov    %edx,(%eax)
  803569:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80356c:	8b 00                	mov    (%eax),%eax
  80356e:	85 c0                	test   %eax,%eax
  803570:	74 0d                	je     80357f <insert_sorted_with_merge_freeList+0x1a4>
  803572:	a1 48 51 80 00       	mov    0x805148,%eax
  803577:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80357a:	89 50 04             	mov    %edx,0x4(%eax)
  80357d:	eb 08                	jmp    803587 <insert_sorted_with_merge_freeList+0x1ac>
  80357f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803582:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803587:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80358a:	a3 48 51 80 00       	mov    %eax,0x805148
  80358f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803592:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803599:	a1 54 51 80 00       	mov    0x805154,%eax
  80359e:	40                   	inc    %eax
  80359f:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8035a4:	e9 7a 05 00 00       	jmp    803b23 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  8035a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ac:	8b 50 08             	mov    0x8(%eax),%edx
  8035af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035b2:	8b 40 08             	mov    0x8(%eax),%eax
  8035b5:	39 c2                	cmp    %eax,%edx
  8035b7:	0f 82 14 01 00 00    	jb     8036d1 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  8035bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035c0:	8b 50 08             	mov    0x8(%eax),%edx
  8035c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035c6:	8b 40 0c             	mov    0xc(%eax),%eax
  8035c9:	01 c2                	add    %eax,%edx
  8035cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ce:	8b 40 08             	mov    0x8(%eax),%eax
  8035d1:	39 c2                	cmp    %eax,%edx
  8035d3:	0f 85 90 00 00 00    	jne    803669 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  8035d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035dc:	8b 50 0c             	mov    0xc(%eax),%edx
  8035df:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8035e5:	01 c2                	add    %eax,%edx
  8035e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035ea:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  8035ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  8035f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8035fa:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803601:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803605:	75 17                	jne    80361e <insert_sorted_with_merge_freeList+0x243>
  803607:	83 ec 04             	sub    $0x4,%esp
  80360a:	68 94 46 80 00       	push   $0x804694
  80360f:	68 49 01 00 00       	push   $0x149
  803614:	68 b7 46 80 00       	push   $0x8046b7
  803619:	e8 ee d2 ff ff       	call   80090c <_panic>
  80361e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803624:	8b 45 08             	mov    0x8(%ebp),%eax
  803627:	89 10                	mov    %edx,(%eax)
  803629:	8b 45 08             	mov    0x8(%ebp),%eax
  80362c:	8b 00                	mov    (%eax),%eax
  80362e:	85 c0                	test   %eax,%eax
  803630:	74 0d                	je     80363f <insert_sorted_with_merge_freeList+0x264>
  803632:	a1 48 51 80 00       	mov    0x805148,%eax
  803637:	8b 55 08             	mov    0x8(%ebp),%edx
  80363a:	89 50 04             	mov    %edx,0x4(%eax)
  80363d:	eb 08                	jmp    803647 <insert_sorted_with_merge_freeList+0x26c>
  80363f:	8b 45 08             	mov    0x8(%ebp),%eax
  803642:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803647:	8b 45 08             	mov    0x8(%ebp),%eax
  80364a:	a3 48 51 80 00       	mov    %eax,0x805148
  80364f:	8b 45 08             	mov    0x8(%ebp),%eax
  803652:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803659:	a1 54 51 80 00       	mov    0x805154,%eax
  80365e:	40                   	inc    %eax
  80365f:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803664:	e9 bb 04 00 00       	jmp    803b24 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803669:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80366d:	75 17                	jne    803686 <insert_sorted_with_merge_freeList+0x2ab>
  80366f:	83 ec 04             	sub    $0x4,%esp
  803672:	68 08 47 80 00       	push   $0x804708
  803677:	68 4c 01 00 00       	push   $0x14c
  80367c:	68 b7 46 80 00       	push   $0x8046b7
  803681:	e8 86 d2 ff ff       	call   80090c <_panic>
  803686:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  80368c:	8b 45 08             	mov    0x8(%ebp),%eax
  80368f:	89 50 04             	mov    %edx,0x4(%eax)
  803692:	8b 45 08             	mov    0x8(%ebp),%eax
  803695:	8b 40 04             	mov    0x4(%eax),%eax
  803698:	85 c0                	test   %eax,%eax
  80369a:	74 0c                	je     8036a8 <insert_sorted_with_merge_freeList+0x2cd>
  80369c:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8036a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8036a4:	89 10                	mov    %edx,(%eax)
  8036a6:	eb 08                	jmp    8036b0 <insert_sorted_with_merge_freeList+0x2d5>
  8036a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ab:	a3 38 51 80 00       	mov    %eax,0x805138
  8036b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8036b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8036bb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036c1:	a1 44 51 80 00       	mov    0x805144,%eax
  8036c6:	40                   	inc    %eax
  8036c7:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8036cc:	e9 53 04 00 00       	jmp    803b24 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8036d1:	a1 38 51 80 00       	mov    0x805138,%eax
  8036d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8036d9:	e9 15 04 00 00       	jmp    803af3 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  8036de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036e1:	8b 00                	mov    (%eax),%eax
  8036e3:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  8036e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e9:	8b 50 08             	mov    0x8(%eax),%edx
  8036ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036ef:	8b 40 08             	mov    0x8(%eax),%eax
  8036f2:	39 c2                	cmp    %eax,%edx
  8036f4:	0f 86 f1 03 00 00    	jbe    803aeb <insert_sorted_with_merge_freeList+0x710>
  8036fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8036fd:	8b 50 08             	mov    0x8(%eax),%edx
  803700:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803703:	8b 40 08             	mov    0x8(%eax),%eax
  803706:	39 c2                	cmp    %eax,%edx
  803708:	0f 83 dd 03 00 00    	jae    803aeb <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  80370e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803711:	8b 50 08             	mov    0x8(%eax),%edx
  803714:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803717:	8b 40 0c             	mov    0xc(%eax),%eax
  80371a:	01 c2                	add    %eax,%edx
  80371c:	8b 45 08             	mov    0x8(%ebp),%eax
  80371f:	8b 40 08             	mov    0x8(%eax),%eax
  803722:	39 c2                	cmp    %eax,%edx
  803724:	0f 85 b9 01 00 00    	jne    8038e3 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80372a:	8b 45 08             	mov    0x8(%ebp),%eax
  80372d:	8b 50 08             	mov    0x8(%eax),%edx
  803730:	8b 45 08             	mov    0x8(%ebp),%eax
  803733:	8b 40 0c             	mov    0xc(%eax),%eax
  803736:	01 c2                	add    %eax,%edx
  803738:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80373b:	8b 40 08             	mov    0x8(%eax),%eax
  80373e:	39 c2                	cmp    %eax,%edx
  803740:	0f 85 0d 01 00 00    	jne    803853 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803746:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803749:	8b 50 0c             	mov    0xc(%eax),%edx
  80374c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80374f:	8b 40 0c             	mov    0xc(%eax),%eax
  803752:	01 c2                	add    %eax,%edx
  803754:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803757:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80375a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80375e:	75 17                	jne    803777 <insert_sorted_with_merge_freeList+0x39c>
  803760:	83 ec 04             	sub    $0x4,%esp
  803763:	68 60 47 80 00       	push   $0x804760
  803768:	68 5c 01 00 00       	push   $0x15c
  80376d:	68 b7 46 80 00       	push   $0x8046b7
  803772:	e8 95 d1 ff ff       	call   80090c <_panic>
  803777:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80377a:	8b 00                	mov    (%eax),%eax
  80377c:	85 c0                	test   %eax,%eax
  80377e:	74 10                	je     803790 <insert_sorted_with_merge_freeList+0x3b5>
  803780:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803783:	8b 00                	mov    (%eax),%eax
  803785:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803788:	8b 52 04             	mov    0x4(%edx),%edx
  80378b:	89 50 04             	mov    %edx,0x4(%eax)
  80378e:	eb 0b                	jmp    80379b <insert_sorted_with_merge_freeList+0x3c0>
  803790:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803793:	8b 40 04             	mov    0x4(%eax),%eax
  803796:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80379b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80379e:	8b 40 04             	mov    0x4(%eax),%eax
  8037a1:	85 c0                	test   %eax,%eax
  8037a3:	74 0f                	je     8037b4 <insert_sorted_with_merge_freeList+0x3d9>
  8037a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037a8:	8b 40 04             	mov    0x4(%eax),%eax
  8037ab:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8037ae:	8b 12                	mov    (%edx),%edx
  8037b0:	89 10                	mov    %edx,(%eax)
  8037b2:	eb 0a                	jmp    8037be <insert_sorted_with_merge_freeList+0x3e3>
  8037b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037b7:	8b 00                	mov    (%eax),%eax
  8037b9:	a3 38 51 80 00       	mov    %eax,0x805138
  8037be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037ca:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037d1:	a1 44 51 80 00       	mov    0x805144,%eax
  8037d6:	48                   	dec    %eax
  8037d7:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  8037dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037df:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8037e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037e9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8037f0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8037f4:	75 17                	jne    80380d <insert_sorted_with_merge_freeList+0x432>
  8037f6:	83 ec 04             	sub    $0x4,%esp
  8037f9:	68 94 46 80 00       	push   $0x804694
  8037fe:	68 5f 01 00 00       	push   $0x15f
  803803:	68 b7 46 80 00       	push   $0x8046b7
  803808:	e8 ff d0 ff ff       	call   80090c <_panic>
  80380d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803813:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803816:	89 10                	mov    %edx,(%eax)
  803818:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80381b:	8b 00                	mov    (%eax),%eax
  80381d:	85 c0                	test   %eax,%eax
  80381f:	74 0d                	je     80382e <insert_sorted_with_merge_freeList+0x453>
  803821:	a1 48 51 80 00       	mov    0x805148,%eax
  803826:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803829:	89 50 04             	mov    %edx,0x4(%eax)
  80382c:	eb 08                	jmp    803836 <insert_sorted_with_merge_freeList+0x45b>
  80382e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803831:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803836:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803839:	a3 48 51 80 00       	mov    %eax,0x805148
  80383e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803841:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803848:	a1 54 51 80 00       	mov    0x805154,%eax
  80384d:	40                   	inc    %eax
  80384e:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803853:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803856:	8b 50 0c             	mov    0xc(%eax),%edx
  803859:	8b 45 08             	mov    0x8(%ebp),%eax
  80385c:	8b 40 0c             	mov    0xc(%eax),%eax
  80385f:	01 c2                	add    %eax,%edx
  803861:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803864:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803867:	8b 45 08             	mov    0x8(%ebp),%eax
  80386a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803871:	8b 45 08             	mov    0x8(%ebp),%eax
  803874:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80387b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80387f:	75 17                	jne    803898 <insert_sorted_with_merge_freeList+0x4bd>
  803881:	83 ec 04             	sub    $0x4,%esp
  803884:	68 94 46 80 00       	push   $0x804694
  803889:	68 64 01 00 00       	push   $0x164
  80388e:	68 b7 46 80 00       	push   $0x8046b7
  803893:	e8 74 d0 ff ff       	call   80090c <_panic>
  803898:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80389e:	8b 45 08             	mov    0x8(%ebp),%eax
  8038a1:	89 10                	mov    %edx,(%eax)
  8038a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8038a6:	8b 00                	mov    (%eax),%eax
  8038a8:	85 c0                	test   %eax,%eax
  8038aa:	74 0d                	je     8038b9 <insert_sorted_with_merge_freeList+0x4de>
  8038ac:	a1 48 51 80 00       	mov    0x805148,%eax
  8038b1:	8b 55 08             	mov    0x8(%ebp),%edx
  8038b4:	89 50 04             	mov    %edx,0x4(%eax)
  8038b7:	eb 08                	jmp    8038c1 <insert_sorted_with_merge_freeList+0x4e6>
  8038b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8038bc:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8038c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8038c4:	a3 48 51 80 00       	mov    %eax,0x805148
  8038c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8038cc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038d3:	a1 54 51 80 00       	mov    0x805154,%eax
  8038d8:	40                   	inc    %eax
  8038d9:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8038de:	e9 41 02 00 00       	jmp    803b24 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8038e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8038e6:	8b 50 08             	mov    0x8(%eax),%edx
  8038e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ec:	8b 40 0c             	mov    0xc(%eax),%eax
  8038ef:	01 c2                	add    %eax,%edx
  8038f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038f4:	8b 40 08             	mov    0x8(%eax),%eax
  8038f7:	39 c2                	cmp    %eax,%edx
  8038f9:	0f 85 7c 01 00 00    	jne    803a7b <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8038ff:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803903:	74 06                	je     80390b <insert_sorted_with_merge_freeList+0x530>
  803905:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803909:	75 17                	jne    803922 <insert_sorted_with_merge_freeList+0x547>
  80390b:	83 ec 04             	sub    $0x4,%esp
  80390e:	68 d0 46 80 00       	push   $0x8046d0
  803913:	68 69 01 00 00       	push   $0x169
  803918:	68 b7 46 80 00       	push   $0x8046b7
  80391d:	e8 ea cf ff ff       	call   80090c <_panic>
  803922:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803925:	8b 50 04             	mov    0x4(%eax),%edx
  803928:	8b 45 08             	mov    0x8(%ebp),%eax
  80392b:	89 50 04             	mov    %edx,0x4(%eax)
  80392e:	8b 45 08             	mov    0x8(%ebp),%eax
  803931:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803934:	89 10                	mov    %edx,(%eax)
  803936:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803939:	8b 40 04             	mov    0x4(%eax),%eax
  80393c:	85 c0                	test   %eax,%eax
  80393e:	74 0d                	je     80394d <insert_sorted_with_merge_freeList+0x572>
  803940:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803943:	8b 40 04             	mov    0x4(%eax),%eax
  803946:	8b 55 08             	mov    0x8(%ebp),%edx
  803949:	89 10                	mov    %edx,(%eax)
  80394b:	eb 08                	jmp    803955 <insert_sorted_with_merge_freeList+0x57a>
  80394d:	8b 45 08             	mov    0x8(%ebp),%eax
  803950:	a3 38 51 80 00       	mov    %eax,0x805138
  803955:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803958:	8b 55 08             	mov    0x8(%ebp),%edx
  80395b:	89 50 04             	mov    %edx,0x4(%eax)
  80395e:	a1 44 51 80 00       	mov    0x805144,%eax
  803963:	40                   	inc    %eax
  803964:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803969:	8b 45 08             	mov    0x8(%ebp),%eax
  80396c:	8b 50 0c             	mov    0xc(%eax),%edx
  80396f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803972:	8b 40 0c             	mov    0xc(%eax),%eax
  803975:	01 c2                	add    %eax,%edx
  803977:	8b 45 08             	mov    0x8(%ebp),%eax
  80397a:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80397d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803981:	75 17                	jne    80399a <insert_sorted_with_merge_freeList+0x5bf>
  803983:	83 ec 04             	sub    $0x4,%esp
  803986:	68 60 47 80 00       	push   $0x804760
  80398b:	68 6b 01 00 00       	push   $0x16b
  803990:	68 b7 46 80 00       	push   $0x8046b7
  803995:	e8 72 cf ff ff       	call   80090c <_panic>
  80399a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80399d:	8b 00                	mov    (%eax),%eax
  80399f:	85 c0                	test   %eax,%eax
  8039a1:	74 10                	je     8039b3 <insert_sorted_with_merge_freeList+0x5d8>
  8039a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039a6:	8b 00                	mov    (%eax),%eax
  8039a8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8039ab:	8b 52 04             	mov    0x4(%edx),%edx
  8039ae:	89 50 04             	mov    %edx,0x4(%eax)
  8039b1:	eb 0b                	jmp    8039be <insert_sorted_with_merge_freeList+0x5e3>
  8039b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039b6:	8b 40 04             	mov    0x4(%eax),%eax
  8039b9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8039be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039c1:	8b 40 04             	mov    0x4(%eax),%eax
  8039c4:	85 c0                	test   %eax,%eax
  8039c6:	74 0f                	je     8039d7 <insert_sorted_with_merge_freeList+0x5fc>
  8039c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039cb:	8b 40 04             	mov    0x4(%eax),%eax
  8039ce:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8039d1:	8b 12                	mov    (%edx),%edx
  8039d3:	89 10                	mov    %edx,(%eax)
  8039d5:	eb 0a                	jmp    8039e1 <insert_sorted_with_merge_freeList+0x606>
  8039d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039da:	8b 00                	mov    (%eax),%eax
  8039dc:	a3 38 51 80 00       	mov    %eax,0x805138
  8039e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039e4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039ed:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039f4:	a1 44 51 80 00       	mov    0x805144,%eax
  8039f9:	48                   	dec    %eax
  8039fa:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  8039ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a02:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803a09:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a0c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803a13:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803a17:	75 17                	jne    803a30 <insert_sorted_with_merge_freeList+0x655>
  803a19:	83 ec 04             	sub    $0x4,%esp
  803a1c:	68 94 46 80 00       	push   $0x804694
  803a21:	68 6e 01 00 00       	push   $0x16e
  803a26:	68 b7 46 80 00       	push   $0x8046b7
  803a2b:	e8 dc ce ff ff       	call   80090c <_panic>
  803a30:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803a36:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a39:	89 10                	mov    %edx,(%eax)
  803a3b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a3e:	8b 00                	mov    (%eax),%eax
  803a40:	85 c0                	test   %eax,%eax
  803a42:	74 0d                	je     803a51 <insert_sorted_with_merge_freeList+0x676>
  803a44:	a1 48 51 80 00       	mov    0x805148,%eax
  803a49:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803a4c:	89 50 04             	mov    %edx,0x4(%eax)
  803a4f:	eb 08                	jmp    803a59 <insert_sorted_with_merge_freeList+0x67e>
  803a51:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a54:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803a59:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a5c:	a3 48 51 80 00       	mov    %eax,0x805148
  803a61:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a64:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a6b:	a1 54 51 80 00       	mov    0x805154,%eax
  803a70:	40                   	inc    %eax
  803a71:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803a76:	e9 a9 00 00 00       	jmp    803b24 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803a7b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a7f:	74 06                	je     803a87 <insert_sorted_with_merge_freeList+0x6ac>
  803a81:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803a85:	75 17                	jne    803a9e <insert_sorted_with_merge_freeList+0x6c3>
  803a87:	83 ec 04             	sub    $0x4,%esp
  803a8a:	68 2c 47 80 00       	push   $0x80472c
  803a8f:	68 73 01 00 00       	push   $0x173
  803a94:	68 b7 46 80 00       	push   $0x8046b7
  803a99:	e8 6e ce ff ff       	call   80090c <_panic>
  803a9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aa1:	8b 10                	mov    (%eax),%edx
  803aa3:	8b 45 08             	mov    0x8(%ebp),%eax
  803aa6:	89 10                	mov    %edx,(%eax)
  803aa8:	8b 45 08             	mov    0x8(%ebp),%eax
  803aab:	8b 00                	mov    (%eax),%eax
  803aad:	85 c0                	test   %eax,%eax
  803aaf:	74 0b                	je     803abc <insert_sorted_with_merge_freeList+0x6e1>
  803ab1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ab4:	8b 00                	mov    (%eax),%eax
  803ab6:	8b 55 08             	mov    0x8(%ebp),%edx
  803ab9:	89 50 04             	mov    %edx,0x4(%eax)
  803abc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803abf:	8b 55 08             	mov    0x8(%ebp),%edx
  803ac2:	89 10                	mov    %edx,(%eax)
  803ac4:	8b 45 08             	mov    0x8(%ebp),%eax
  803ac7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803aca:	89 50 04             	mov    %edx,0x4(%eax)
  803acd:	8b 45 08             	mov    0x8(%ebp),%eax
  803ad0:	8b 00                	mov    (%eax),%eax
  803ad2:	85 c0                	test   %eax,%eax
  803ad4:	75 08                	jne    803ade <insert_sorted_with_merge_freeList+0x703>
  803ad6:	8b 45 08             	mov    0x8(%ebp),%eax
  803ad9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803ade:	a1 44 51 80 00       	mov    0x805144,%eax
  803ae3:	40                   	inc    %eax
  803ae4:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803ae9:	eb 39                	jmp    803b24 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803aeb:	a1 40 51 80 00       	mov    0x805140,%eax
  803af0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803af3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803af7:	74 07                	je     803b00 <insert_sorted_with_merge_freeList+0x725>
  803af9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803afc:	8b 00                	mov    (%eax),%eax
  803afe:	eb 05                	jmp    803b05 <insert_sorted_with_merge_freeList+0x72a>
  803b00:	b8 00 00 00 00       	mov    $0x0,%eax
  803b05:	a3 40 51 80 00       	mov    %eax,0x805140
  803b0a:	a1 40 51 80 00       	mov    0x805140,%eax
  803b0f:	85 c0                	test   %eax,%eax
  803b11:	0f 85 c7 fb ff ff    	jne    8036de <insert_sorted_with_merge_freeList+0x303>
  803b17:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b1b:	0f 85 bd fb ff ff    	jne    8036de <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803b21:	eb 01                	jmp    803b24 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803b23:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803b24:	90                   	nop
  803b25:	c9                   	leave  
  803b26:	c3                   	ret    
  803b27:	90                   	nop

00803b28 <__udivdi3>:
  803b28:	55                   	push   %ebp
  803b29:	57                   	push   %edi
  803b2a:	56                   	push   %esi
  803b2b:	53                   	push   %ebx
  803b2c:	83 ec 1c             	sub    $0x1c,%esp
  803b2f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803b33:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803b37:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b3b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803b3f:	89 ca                	mov    %ecx,%edx
  803b41:	89 f8                	mov    %edi,%eax
  803b43:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803b47:	85 f6                	test   %esi,%esi
  803b49:	75 2d                	jne    803b78 <__udivdi3+0x50>
  803b4b:	39 cf                	cmp    %ecx,%edi
  803b4d:	77 65                	ja     803bb4 <__udivdi3+0x8c>
  803b4f:	89 fd                	mov    %edi,%ebp
  803b51:	85 ff                	test   %edi,%edi
  803b53:	75 0b                	jne    803b60 <__udivdi3+0x38>
  803b55:	b8 01 00 00 00       	mov    $0x1,%eax
  803b5a:	31 d2                	xor    %edx,%edx
  803b5c:	f7 f7                	div    %edi
  803b5e:	89 c5                	mov    %eax,%ebp
  803b60:	31 d2                	xor    %edx,%edx
  803b62:	89 c8                	mov    %ecx,%eax
  803b64:	f7 f5                	div    %ebp
  803b66:	89 c1                	mov    %eax,%ecx
  803b68:	89 d8                	mov    %ebx,%eax
  803b6a:	f7 f5                	div    %ebp
  803b6c:	89 cf                	mov    %ecx,%edi
  803b6e:	89 fa                	mov    %edi,%edx
  803b70:	83 c4 1c             	add    $0x1c,%esp
  803b73:	5b                   	pop    %ebx
  803b74:	5e                   	pop    %esi
  803b75:	5f                   	pop    %edi
  803b76:	5d                   	pop    %ebp
  803b77:	c3                   	ret    
  803b78:	39 ce                	cmp    %ecx,%esi
  803b7a:	77 28                	ja     803ba4 <__udivdi3+0x7c>
  803b7c:	0f bd fe             	bsr    %esi,%edi
  803b7f:	83 f7 1f             	xor    $0x1f,%edi
  803b82:	75 40                	jne    803bc4 <__udivdi3+0x9c>
  803b84:	39 ce                	cmp    %ecx,%esi
  803b86:	72 0a                	jb     803b92 <__udivdi3+0x6a>
  803b88:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803b8c:	0f 87 9e 00 00 00    	ja     803c30 <__udivdi3+0x108>
  803b92:	b8 01 00 00 00       	mov    $0x1,%eax
  803b97:	89 fa                	mov    %edi,%edx
  803b99:	83 c4 1c             	add    $0x1c,%esp
  803b9c:	5b                   	pop    %ebx
  803b9d:	5e                   	pop    %esi
  803b9e:	5f                   	pop    %edi
  803b9f:	5d                   	pop    %ebp
  803ba0:	c3                   	ret    
  803ba1:	8d 76 00             	lea    0x0(%esi),%esi
  803ba4:	31 ff                	xor    %edi,%edi
  803ba6:	31 c0                	xor    %eax,%eax
  803ba8:	89 fa                	mov    %edi,%edx
  803baa:	83 c4 1c             	add    $0x1c,%esp
  803bad:	5b                   	pop    %ebx
  803bae:	5e                   	pop    %esi
  803baf:	5f                   	pop    %edi
  803bb0:	5d                   	pop    %ebp
  803bb1:	c3                   	ret    
  803bb2:	66 90                	xchg   %ax,%ax
  803bb4:	89 d8                	mov    %ebx,%eax
  803bb6:	f7 f7                	div    %edi
  803bb8:	31 ff                	xor    %edi,%edi
  803bba:	89 fa                	mov    %edi,%edx
  803bbc:	83 c4 1c             	add    $0x1c,%esp
  803bbf:	5b                   	pop    %ebx
  803bc0:	5e                   	pop    %esi
  803bc1:	5f                   	pop    %edi
  803bc2:	5d                   	pop    %ebp
  803bc3:	c3                   	ret    
  803bc4:	bd 20 00 00 00       	mov    $0x20,%ebp
  803bc9:	89 eb                	mov    %ebp,%ebx
  803bcb:	29 fb                	sub    %edi,%ebx
  803bcd:	89 f9                	mov    %edi,%ecx
  803bcf:	d3 e6                	shl    %cl,%esi
  803bd1:	89 c5                	mov    %eax,%ebp
  803bd3:	88 d9                	mov    %bl,%cl
  803bd5:	d3 ed                	shr    %cl,%ebp
  803bd7:	89 e9                	mov    %ebp,%ecx
  803bd9:	09 f1                	or     %esi,%ecx
  803bdb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803bdf:	89 f9                	mov    %edi,%ecx
  803be1:	d3 e0                	shl    %cl,%eax
  803be3:	89 c5                	mov    %eax,%ebp
  803be5:	89 d6                	mov    %edx,%esi
  803be7:	88 d9                	mov    %bl,%cl
  803be9:	d3 ee                	shr    %cl,%esi
  803beb:	89 f9                	mov    %edi,%ecx
  803bed:	d3 e2                	shl    %cl,%edx
  803bef:	8b 44 24 08          	mov    0x8(%esp),%eax
  803bf3:	88 d9                	mov    %bl,%cl
  803bf5:	d3 e8                	shr    %cl,%eax
  803bf7:	09 c2                	or     %eax,%edx
  803bf9:	89 d0                	mov    %edx,%eax
  803bfb:	89 f2                	mov    %esi,%edx
  803bfd:	f7 74 24 0c          	divl   0xc(%esp)
  803c01:	89 d6                	mov    %edx,%esi
  803c03:	89 c3                	mov    %eax,%ebx
  803c05:	f7 e5                	mul    %ebp
  803c07:	39 d6                	cmp    %edx,%esi
  803c09:	72 19                	jb     803c24 <__udivdi3+0xfc>
  803c0b:	74 0b                	je     803c18 <__udivdi3+0xf0>
  803c0d:	89 d8                	mov    %ebx,%eax
  803c0f:	31 ff                	xor    %edi,%edi
  803c11:	e9 58 ff ff ff       	jmp    803b6e <__udivdi3+0x46>
  803c16:	66 90                	xchg   %ax,%ax
  803c18:	8b 54 24 08          	mov    0x8(%esp),%edx
  803c1c:	89 f9                	mov    %edi,%ecx
  803c1e:	d3 e2                	shl    %cl,%edx
  803c20:	39 c2                	cmp    %eax,%edx
  803c22:	73 e9                	jae    803c0d <__udivdi3+0xe5>
  803c24:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803c27:	31 ff                	xor    %edi,%edi
  803c29:	e9 40 ff ff ff       	jmp    803b6e <__udivdi3+0x46>
  803c2e:	66 90                	xchg   %ax,%ax
  803c30:	31 c0                	xor    %eax,%eax
  803c32:	e9 37 ff ff ff       	jmp    803b6e <__udivdi3+0x46>
  803c37:	90                   	nop

00803c38 <__umoddi3>:
  803c38:	55                   	push   %ebp
  803c39:	57                   	push   %edi
  803c3a:	56                   	push   %esi
  803c3b:	53                   	push   %ebx
  803c3c:	83 ec 1c             	sub    $0x1c,%esp
  803c3f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803c43:	8b 74 24 34          	mov    0x34(%esp),%esi
  803c47:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803c4b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803c4f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803c53:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803c57:	89 f3                	mov    %esi,%ebx
  803c59:	89 fa                	mov    %edi,%edx
  803c5b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c5f:	89 34 24             	mov    %esi,(%esp)
  803c62:	85 c0                	test   %eax,%eax
  803c64:	75 1a                	jne    803c80 <__umoddi3+0x48>
  803c66:	39 f7                	cmp    %esi,%edi
  803c68:	0f 86 a2 00 00 00    	jbe    803d10 <__umoddi3+0xd8>
  803c6e:	89 c8                	mov    %ecx,%eax
  803c70:	89 f2                	mov    %esi,%edx
  803c72:	f7 f7                	div    %edi
  803c74:	89 d0                	mov    %edx,%eax
  803c76:	31 d2                	xor    %edx,%edx
  803c78:	83 c4 1c             	add    $0x1c,%esp
  803c7b:	5b                   	pop    %ebx
  803c7c:	5e                   	pop    %esi
  803c7d:	5f                   	pop    %edi
  803c7e:	5d                   	pop    %ebp
  803c7f:	c3                   	ret    
  803c80:	39 f0                	cmp    %esi,%eax
  803c82:	0f 87 ac 00 00 00    	ja     803d34 <__umoddi3+0xfc>
  803c88:	0f bd e8             	bsr    %eax,%ebp
  803c8b:	83 f5 1f             	xor    $0x1f,%ebp
  803c8e:	0f 84 ac 00 00 00    	je     803d40 <__umoddi3+0x108>
  803c94:	bf 20 00 00 00       	mov    $0x20,%edi
  803c99:	29 ef                	sub    %ebp,%edi
  803c9b:	89 fe                	mov    %edi,%esi
  803c9d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803ca1:	89 e9                	mov    %ebp,%ecx
  803ca3:	d3 e0                	shl    %cl,%eax
  803ca5:	89 d7                	mov    %edx,%edi
  803ca7:	89 f1                	mov    %esi,%ecx
  803ca9:	d3 ef                	shr    %cl,%edi
  803cab:	09 c7                	or     %eax,%edi
  803cad:	89 e9                	mov    %ebp,%ecx
  803caf:	d3 e2                	shl    %cl,%edx
  803cb1:	89 14 24             	mov    %edx,(%esp)
  803cb4:	89 d8                	mov    %ebx,%eax
  803cb6:	d3 e0                	shl    %cl,%eax
  803cb8:	89 c2                	mov    %eax,%edx
  803cba:	8b 44 24 08          	mov    0x8(%esp),%eax
  803cbe:	d3 e0                	shl    %cl,%eax
  803cc0:	89 44 24 04          	mov    %eax,0x4(%esp)
  803cc4:	8b 44 24 08          	mov    0x8(%esp),%eax
  803cc8:	89 f1                	mov    %esi,%ecx
  803cca:	d3 e8                	shr    %cl,%eax
  803ccc:	09 d0                	or     %edx,%eax
  803cce:	d3 eb                	shr    %cl,%ebx
  803cd0:	89 da                	mov    %ebx,%edx
  803cd2:	f7 f7                	div    %edi
  803cd4:	89 d3                	mov    %edx,%ebx
  803cd6:	f7 24 24             	mull   (%esp)
  803cd9:	89 c6                	mov    %eax,%esi
  803cdb:	89 d1                	mov    %edx,%ecx
  803cdd:	39 d3                	cmp    %edx,%ebx
  803cdf:	0f 82 87 00 00 00    	jb     803d6c <__umoddi3+0x134>
  803ce5:	0f 84 91 00 00 00    	je     803d7c <__umoddi3+0x144>
  803ceb:	8b 54 24 04          	mov    0x4(%esp),%edx
  803cef:	29 f2                	sub    %esi,%edx
  803cf1:	19 cb                	sbb    %ecx,%ebx
  803cf3:	89 d8                	mov    %ebx,%eax
  803cf5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803cf9:	d3 e0                	shl    %cl,%eax
  803cfb:	89 e9                	mov    %ebp,%ecx
  803cfd:	d3 ea                	shr    %cl,%edx
  803cff:	09 d0                	or     %edx,%eax
  803d01:	89 e9                	mov    %ebp,%ecx
  803d03:	d3 eb                	shr    %cl,%ebx
  803d05:	89 da                	mov    %ebx,%edx
  803d07:	83 c4 1c             	add    $0x1c,%esp
  803d0a:	5b                   	pop    %ebx
  803d0b:	5e                   	pop    %esi
  803d0c:	5f                   	pop    %edi
  803d0d:	5d                   	pop    %ebp
  803d0e:	c3                   	ret    
  803d0f:	90                   	nop
  803d10:	89 fd                	mov    %edi,%ebp
  803d12:	85 ff                	test   %edi,%edi
  803d14:	75 0b                	jne    803d21 <__umoddi3+0xe9>
  803d16:	b8 01 00 00 00       	mov    $0x1,%eax
  803d1b:	31 d2                	xor    %edx,%edx
  803d1d:	f7 f7                	div    %edi
  803d1f:	89 c5                	mov    %eax,%ebp
  803d21:	89 f0                	mov    %esi,%eax
  803d23:	31 d2                	xor    %edx,%edx
  803d25:	f7 f5                	div    %ebp
  803d27:	89 c8                	mov    %ecx,%eax
  803d29:	f7 f5                	div    %ebp
  803d2b:	89 d0                	mov    %edx,%eax
  803d2d:	e9 44 ff ff ff       	jmp    803c76 <__umoddi3+0x3e>
  803d32:	66 90                	xchg   %ax,%ax
  803d34:	89 c8                	mov    %ecx,%eax
  803d36:	89 f2                	mov    %esi,%edx
  803d38:	83 c4 1c             	add    $0x1c,%esp
  803d3b:	5b                   	pop    %ebx
  803d3c:	5e                   	pop    %esi
  803d3d:	5f                   	pop    %edi
  803d3e:	5d                   	pop    %ebp
  803d3f:	c3                   	ret    
  803d40:	3b 04 24             	cmp    (%esp),%eax
  803d43:	72 06                	jb     803d4b <__umoddi3+0x113>
  803d45:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803d49:	77 0f                	ja     803d5a <__umoddi3+0x122>
  803d4b:	89 f2                	mov    %esi,%edx
  803d4d:	29 f9                	sub    %edi,%ecx
  803d4f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803d53:	89 14 24             	mov    %edx,(%esp)
  803d56:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d5a:	8b 44 24 04          	mov    0x4(%esp),%eax
  803d5e:	8b 14 24             	mov    (%esp),%edx
  803d61:	83 c4 1c             	add    $0x1c,%esp
  803d64:	5b                   	pop    %ebx
  803d65:	5e                   	pop    %esi
  803d66:	5f                   	pop    %edi
  803d67:	5d                   	pop    %ebp
  803d68:	c3                   	ret    
  803d69:	8d 76 00             	lea    0x0(%esi),%esi
  803d6c:	2b 04 24             	sub    (%esp),%eax
  803d6f:	19 fa                	sbb    %edi,%edx
  803d71:	89 d1                	mov    %edx,%ecx
  803d73:	89 c6                	mov    %eax,%esi
  803d75:	e9 71 ff ff ff       	jmp    803ceb <__umoddi3+0xb3>
  803d7a:	66 90                	xchg   %ax,%ax
  803d7c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803d80:	72 ea                	jb     803d6c <__umoddi3+0x134>
  803d82:	89 d9                	mov    %ebx,%ecx
  803d84:	e9 62 ff ff ff       	jmp    803ceb <__umoddi3+0xb3>
