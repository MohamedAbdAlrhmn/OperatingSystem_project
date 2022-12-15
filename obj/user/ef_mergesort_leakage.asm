
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
  80004b:	e8 4c 1f 00 00       	call   801f9c <sys_disable_interrupt>

		cprintf("\n");
  800050:	83 ec 0c             	sub    $0xc,%esp
  800053:	68 e0 3c 80 00       	push   $0x803ce0
  800058:	e8 63 0b 00 00       	call   800bc0 <cprintf>
  80005d:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800060:	83 ec 0c             	sub    $0xc,%esp
  800063:	68 e2 3c 80 00       	push   $0x803ce2
  800068:	e8 53 0b 00 00       	call   800bc0 <cprintf>
  80006d:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!! MERGE SORT !!!!\n");
  800070:	83 ec 0c             	sub    $0xc,%esp
  800073:	68 f8 3c 80 00       	push   $0x803cf8
  800078:	e8 43 0b 00 00       	call   800bc0 <cprintf>
  80007d:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800080:	83 ec 0c             	sub    $0xc,%esp
  800083:	68 e2 3c 80 00       	push   $0x803ce2
  800088:	e8 33 0b 00 00       	call   800bc0 <cprintf>
  80008d:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800090:	83 ec 0c             	sub    $0xc,%esp
  800093:	68 e0 3c 80 00       	push   $0x803ce0
  800098:	e8 23 0b 00 00       	call   800bc0 <cprintf>
  80009d:	83 c4 10             	add    $0x10,%esp
		cprintf("Enter the number of elements: ");
  8000a0:	83 ec 0c             	sub    $0xc,%esp
  8000a3:	68 10 3d 80 00       	push   $0x803d10
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
  8000d2:	68 2f 3d 80 00       	push   $0x803d2f
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
  8000f7:	68 34 3d 80 00       	push   $0x803d34
  8000fc:	e8 bf 0a 00 00       	call   800bc0 <cprintf>
  800101:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  800104:	83 ec 0c             	sub    $0xc,%esp
  800107:	68 56 3d 80 00       	push   $0x803d56
  80010c:	e8 af 0a 00 00       	call   800bc0 <cprintf>
  800111:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  800114:	83 ec 0c             	sub    $0xc,%esp
  800117:	68 64 3d 80 00       	push   $0x803d64
  80011c:	e8 9f 0a 00 00       	call   800bc0 <cprintf>
  800121:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  800124:	83 ec 0c             	sub    $0xc,%esp
  800127:	68 73 3d 80 00       	push   $0x803d73
  80012c:	e8 8f 0a 00 00       	call   800bc0 <cprintf>
  800131:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  800134:	83 ec 0c             	sub    $0xc,%esp
  800137:	68 83 3d 80 00       	push   $0x803d83
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
  800189:	e8 28 1e 00 00       	call   801fb6 <sys_enable_interrupt>

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
  8001fe:	e8 99 1d 00 00       	call   801f9c <sys_disable_interrupt>
		cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  800203:	83 ec 0c             	sub    $0xc,%esp
  800206:	68 8c 3d 80 00       	push   $0x803d8c
  80020b:	e8 b0 09 00 00       	call   800bc0 <cprintf>
  800210:	83 c4 10             	add    $0x10,%esp
		//PrintElements(Elements, NumOfElements);
		sys_enable_interrupt();
  800213:	e8 9e 1d 00 00       	call   801fb6 <sys_enable_interrupt>

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
  800235:	68 c0 3d 80 00       	push   $0x803dc0
  80023a:	6a 58                	push   $0x58
  80023c:	68 e2 3d 80 00       	push   $0x803de2
  800241:	e8 c6 06 00 00       	call   80090c <_panic>
		else
		{
			sys_disable_interrupt();
  800246:	e8 51 1d 00 00       	call   801f9c <sys_disable_interrupt>
			cprintf("===============================================\n") ;
  80024b:	83 ec 0c             	sub    $0xc,%esp
  80024e:	68 00 3e 80 00       	push   $0x803e00
  800253:	e8 68 09 00 00       	call   800bc0 <cprintf>
  800258:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  80025b:	83 ec 0c             	sub    $0xc,%esp
  80025e:	68 34 3e 80 00       	push   $0x803e34
  800263:	e8 58 09 00 00       	call   800bc0 <cprintf>
  800268:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  80026b:	83 ec 0c             	sub    $0xc,%esp
  80026e:	68 68 3e 80 00       	push   $0x803e68
  800273:	e8 48 09 00 00       	call   800bc0 <cprintf>
  800278:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  80027b:	e8 36 1d 00 00       	call   801fb6 <sys_enable_interrupt>
		}

		//free(Elements) ;

		sys_disable_interrupt();
  800280:	e8 17 1d 00 00       	call   801f9c <sys_disable_interrupt>
		Chose = 0 ;
  800285:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
		while (Chose != 'y' && Chose != 'n')
  800289:	eb 50                	jmp    8002db <_main+0x2a3>
		{
			cprintf("Do you want to repeat (y/n): ") ;
  80028b:	83 ec 0c             	sub    $0xc,%esp
  80028e:	68 9a 3e 80 00       	push   $0x803e9a
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
  8002e7:	e8 ca 1c 00 00       	call   801fb6 <sys_enable_interrupt>

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
  80047b:	68 e0 3c 80 00       	push   $0x803ce0
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
  80049d:	68 b8 3e 80 00       	push   $0x803eb8
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
  8004cb:	68 2f 3d 80 00       	push   $0x803d2f
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
  800744:	e8 87 18 00 00       	call   801fd0 <sys_cputc>
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
  800755:	e8 42 18 00 00       	call   801f9c <sys_disable_interrupt>
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
  800768:	e8 63 18 00 00       	call   801fd0 <sys_cputc>
  80076d:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800770:	e8 41 18 00 00       	call   801fb6 <sys_enable_interrupt>
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
  800787:	e8 8b 16 00 00       	call   801e17 <sys_cgetc>
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
  8007a0:	e8 f7 17 00 00       	call   801f9c <sys_disable_interrupt>
	int c=0;
  8007a5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8007ac:	eb 08                	jmp    8007b6 <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  8007ae:	e8 64 16 00 00       	call   801e17 <sys_cgetc>
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
  8007bc:	e8 f5 17 00 00       	call   801fb6 <sys_enable_interrupt>
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
  8007d6:	e8 b4 19 00 00       	call   80218f <sys_getenvindex>
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
  800841:	e8 56 17 00 00       	call   801f9c <sys_disable_interrupt>
	cprintf("**************************************\n");
  800846:	83 ec 0c             	sub    $0xc,%esp
  800849:	68 d8 3e 80 00       	push   $0x803ed8
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
  800871:	68 00 3f 80 00       	push   $0x803f00
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
  8008a2:	68 28 3f 80 00       	push   $0x803f28
  8008a7:	e8 14 03 00 00       	call   800bc0 <cprintf>
  8008ac:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8008af:	a1 24 50 80 00       	mov    0x805024,%eax
  8008b4:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8008ba:	83 ec 08             	sub    $0x8,%esp
  8008bd:	50                   	push   %eax
  8008be:	68 80 3f 80 00       	push   $0x803f80
  8008c3:	e8 f8 02 00 00       	call   800bc0 <cprintf>
  8008c8:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8008cb:	83 ec 0c             	sub    $0xc,%esp
  8008ce:	68 d8 3e 80 00       	push   $0x803ed8
  8008d3:	e8 e8 02 00 00       	call   800bc0 <cprintf>
  8008d8:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8008db:	e8 d6 16 00 00       	call   801fb6 <sys_enable_interrupt>

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
  8008f3:	e8 63 18 00 00       	call   80215b <sys_destroy_env>
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
  800904:	e8 b8 18 00 00       	call   8021c1 <sys_exit_env>
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
  80092d:	68 94 3f 80 00       	push   $0x803f94
  800932:	e8 89 02 00 00       	call   800bc0 <cprintf>
  800937:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80093a:	a1 00 50 80 00       	mov    0x805000,%eax
  80093f:	ff 75 0c             	pushl  0xc(%ebp)
  800942:	ff 75 08             	pushl  0x8(%ebp)
  800945:	50                   	push   %eax
  800946:	68 99 3f 80 00       	push   $0x803f99
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
  80096a:	68 b5 3f 80 00       	push   $0x803fb5
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
  800996:	68 b8 3f 80 00       	push   $0x803fb8
  80099b:	6a 26                	push   $0x26
  80099d:	68 04 40 80 00       	push   $0x804004
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
  800a68:	68 10 40 80 00       	push   $0x804010
  800a6d:	6a 3a                	push   $0x3a
  800a6f:	68 04 40 80 00       	push   $0x804004
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
  800ad8:	68 64 40 80 00       	push   $0x804064
  800add:	6a 44                	push   $0x44
  800adf:	68 04 40 80 00       	push   $0x804004
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
  800b32:	e8 b7 12 00 00       	call   801dee <sys_cputs>
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
  800ba9:	e8 40 12 00 00       	call   801dee <sys_cputs>
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
  800bf3:	e8 a4 13 00 00       	call   801f9c <sys_disable_interrupt>
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
  800c13:	e8 9e 13 00 00       	call   801fb6 <sys_enable_interrupt>
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
  800c5d:	e8 12 2e 00 00       	call   803a74 <__udivdi3>
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
  800cad:	e8 d2 2e 00 00       	call   803b84 <__umoddi3>
  800cb2:	83 c4 10             	add    $0x10,%esp
  800cb5:	05 d4 42 80 00       	add    $0x8042d4,%eax
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
  800e08:	8b 04 85 f8 42 80 00 	mov    0x8042f8(,%eax,4),%eax
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
  800ee9:	8b 34 9d 40 41 80 00 	mov    0x804140(,%ebx,4),%esi
  800ef0:	85 f6                	test   %esi,%esi
  800ef2:	75 19                	jne    800f0d <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ef4:	53                   	push   %ebx
  800ef5:	68 e5 42 80 00       	push   $0x8042e5
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
  800f0e:	68 ee 42 80 00       	push   $0x8042ee
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
  800f3b:	be f1 42 80 00       	mov    $0x8042f1,%esi
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
  801961:	68 50 44 80 00       	push   $0x804450
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
  801a31:	e8 fc 04 00 00       	call   801f32 <sys_allocate_chunk>
  801a36:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801a39:	a1 20 51 80 00       	mov    0x805120,%eax
  801a3e:	83 ec 0c             	sub    $0xc,%esp
  801a41:	50                   	push   %eax
  801a42:	e8 71 0b 00 00       	call   8025b8 <initialize_MemBlocksList>
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
  801a6f:	68 75 44 80 00       	push   $0x804475
  801a74:	6a 33                	push   $0x33
  801a76:	68 93 44 80 00       	push   $0x804493
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
  801aee:	68 a0 44 80 00       	push   $0x8044a0
  801af3:	6a 34                	push   $0x34
  801af5:	68 93 44 80 00       	push   $0x804493
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
  801b86:	e8 75 07 00 00       	call   802300 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801b8b:	85 c0                	test   %eax,%eax
  801b8d:	74 11                	je     801ba0 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801b8f:	83 ec 0c             	sub    $0xc,%esp
  801b92:	ff 75 e8             	pushl  -0x18(%ebp)
  801b95:	e8 e0 0d 00 00       	call   80297a <alloc_block_FF>
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
  801bac:	e8 3c 0b 00 00       	call   8026ed <insert_sorted_allocList>
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
  801bcc:	68 c4 44 80 00       	push   $0x8044c4
  801bd1:	6a 6f                	push   $0x6f
  801bd3:	68 93 44 80 00       	push   $0x804493
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
  801bf2:	75 0a                	jne    801bfe <smalloc+0x21>
  801bf4:	b8 00 00 00 00       	mov    $0x0,%eax
  801bf9:	e9 8b 00 00 00       	jmp    801c89 <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801bfe:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801c05:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c0b:	01 d0                	add    %edx,%eax
  801c0d:	48                   	dec    %eax
  801c0e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801c11:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c14:	ba 00 00 00 00       	mov    $0x0,%edx
  801c19:	f7 75 f0             	divl   -0x10(%ebp)
  801c1c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c1f:	29 d0                	sub    %edx,%eax
  801c21:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801c24:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801c2b:	e8 d0 06 00 00       	call   802300 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801c30:	85 c0                	test   %eax,%eax
  801c32:	74 11                	je     801c45 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  801c34:	83 ec 0c             	sub    $0xc,%esp
  801c37:	ff 75 e8             	pushl  -0x18(%ebp)
  801c3a:	e8 3b 0d 00 00       	call   80297a <alloc_block_FF>
  801c3f:	83 c4 10             	add    $0x10,%esp
  801c42:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  801c45:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c49:	74 39                	je     801c84 <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801c4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c4e:	8b 40 08             	mov    0x8(%eax),%eax
  801c51:	89 c2                	mov    %eax,%edx
  801c53:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801c57:	52                   	push   %edx
  801c58:	50                   	push   %eax
  801c59:	ff 75 0c             	pushl  0xc(%ebp)
  801c5c:	ff 75 08             	pushl  0x8(%ebp)
  801c5f:	e8 21 04 00 00       	call   802085 <sys_createSharedObject>
  801c64:	83 c4 10             	add    $0x10,%esp
  801c67:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  801c6a:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  801c6e:	74 14                	je     801c84 <smalloc+0xa7>
  801c70:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  801c74:	74 0e                	je     801c84 <smalloc+0xa7>
  801c76:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  801c7a:	74 08                	je     801c84 <smalloc+0xa7>
			return (void*) mem_block->sva;
  801c7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c7f:	8b 40 08             	mov    0x8(%eax),%eax
  801c82:	eb 05                	jmp    801c89 <smalloc+0xac>
	}
	return NULL;
  801c84:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801c89:	c9                   	leave  
  801c8a:	c3                   	ret    

00801c8b <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801c8b:	55                   	push   %ebp
  801c8c:	89 e5                	mov    %esp,%ebp
  801c8e:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801c91:	e8 b4 fc ff ff       	call   80194a <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801c96:	83 ec 08             	sub    $0x8,%esp
  801c99:	ff 75 0c             	pushl  0xc(%ebp)
  801c9c:	ff 75 08             	pushl  0x8(%ebp)
  801c9f:	e8 0b 04 00 00       	call   8020af <sys_getSizeOfSharedObject>
  801ca4:	83 c4 10             	add    $0x10,%esp
  801ca7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  801caa:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  801cae:	74 76                	je     801d26 <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801cb0:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801cb7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801cba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cbd:	01 d0                	add    %edx,%eax
  801cbf:	48                   	dec    %eax
  801cc0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801cc3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801cc6:	ba 00 00 00 00       	mov    $0x0,%edx
  801ccb:	f7 75 ec             	divl   -0x14(%ebp)
  801cce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801cd1:	29 d0                	sub    %edx,%eax
  801cd3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  801cd6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801cdd:	e8 1e 06 00 00       	call   802300 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801ce2:	85 c0                	test   %eax,%eax
  801ce4:	74 11                	je     801cf7 <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  801ce6:	83 ec 0c             	sub    $0xc,%esp
  801ce9:	ff 75 e4             	pushl  -0x1c(%ebp)
  801cec:	e8 89 0c 00 00       	call   80297a <alloc_block_FF>
  801cf1:	83 c4 10             	add    $0x10,%esp
  801cf4:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  801cf7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801cfb:	74 29                	je     801d26 <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  801cfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d00:	8b 40 08             	mov    0x8(%eax),%eax
  801d03:	83 ec 04             	sub    $0x4,%esp
  801d06:	50                   	push   %eax
  801d07:	ff 75 0c             	pushl  0xc(%ebp)
  801d0a:	ff 75 08             	pushl  0x8(%ebp)
  801d0d:	e8 ba 03 00 00       	call   8020cc <sys_getSharedObject>
  801d12:	83 c4 10             	add    $0x10,%esp
  801d15:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  801d18:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  801d1c:	74 08                	je     801d26 <sget+0x9b>
				return (void *)mem_block->sva;
  801d1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d21:	8b 40 08             	mov    0x8(%eax),%eax
  801d24:	eb 05                	jmp    801d2b <sget+0xa0>
		}
	}
	return NULL;
  801d26:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801d2b:	c9                   	leave  
  801d2c:	c3                   	ret    

00801d2d <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801d2d:	55                   	push   %ebp
  801d2e:	89 e5                	mov    %esp,%ebp
  801d30:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801d33:	e8 12 fc ff ff       	call   80194a <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801d38:	83 ec 04             	sub    $0x4,%esp
  801d3b:	68 e8 44 80 00       	push   $0x8044e8
  801d40:	68 f1 00 00 00       	push   $0xf1
  801d45:	68 93 44 80 00       	push   $0x804493
  801d4a:	e8 bd eb ff ff       	call   80090c <_panic>

00801d4f <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801d4f:	55                   	push   %ebp
  801d50:	89 e5                	mov    %esp,%ebp
  801d52:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801d55:	83 ec 04             	sub    $0x4,%esp
  801d58:	68 10 45 80 00       	push   $0x804510
  801d5d:	68 05 01 00 00       	push   $0x105
  801d62:	68 93 44 80 00       	push   $0x804493
  801d67:	e8 a0 eb ff ff       	call   80090c <_panic>

00801d6c <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801d6c:	55                   	push   %ebp
  801d6d:	89 e5                	mov    %esp,%ebp
  801d6f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801d72:	83 ec 04             	sub    $0x4,%esp
  801d75:	68 34 45 80 00       	push   $0x804534
  801d7a:	68 10 01 00 00       	push   $0x110
  801d7f:	68 93 44 80 00       	push   $0x804493
  801d84:	e8 83 eb ff ff       	call   80090c <_panic>

00801d89 <shrink>:

}
void shrink(uint32 newSize)
{
  801d89:	55                   	push   %ebp
  801d8a:	89 e5                	mov    %esp,%ebp
  801d8c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801d8f:	83 ec 04             	sub    $0x4,%esp
  801d92:	68 34 45 80 00       	push   $0x804534
  801d97:	68 15 01 00 00       	push   $0x115
  801d9c:	68 93 44 80 00       	push   $0x804493
  801da1:	e8 66 eb ff ff       	call   80090c <_panic>

00801da6 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801da6:	55                   	push   %ebp
  801da7:	89 e5                	mov    %esp,%ebp
  801da9:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801dac:	83 ec 04             	sub    $0x4,%esp
  801daf:	68 34 45 80 00       	push   $0x804534
  801db4:	68 1a 01 00 00       	push   $0x11a
  801db9:	68 93 44 80 00       	push   $0x804493
  801dbe:	e8 49 eb ff ff       	call   80090c <_panic>

00801dc3 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801dc3:	55                   	push   %ebp
  801dc4:	89 e5                	mov    %esp,%ebp
  801dc6:	57                   	push   %edi
  801dc7:	56                   	push   %esi
  801dc8:	53                   	push   %ebx
  801dc9:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  801dcf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dd2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801dd5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801dd8:	8b 7d 18             	mov    0x18(%ebp),%edi
  801ddb:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801dde:	cd 30                	int    $0x30
  801de0:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801de3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801de6:	83 c4 10             	add    $0x10,%esp
  801de9:	5b                   	pop    %ebx
  801dea:	5e                   	pop    %esi
  801deb:	5f                   	pop    %edi
  801dec:	5d                   	pop    %ebp
  801ded:	c3                   	ret    

00801dee <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801dee:	55                   	push   %ebp
  801def:	89 e5                	mov    %esp,%ebp
  801df1:	83 ec 04             	sub    $0x4,%esp
  801df4:	8b 45 10             	mov    0x10(%ebp),%eax
  801df7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801dfa:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  801e01:	6a 00                	push   $0x0
  801e03:	6a 00                	push   $0x0
  801e05:	52                   	push   %edx
  801e06:	ff 75 0c             	pushl  0xc(%ebp)
  801e09:	50                   	push   %eax
  801e0a:	6a 00                	push   $0x0
  801e0c:	e8 b2 ff ff ff       	call   801dc3 <syscall>
  801e11:	83 c4 18             	add    $0x18,%esp
}
  801e14:	90                   	nop
  801e15:	c9                   	leave  
  801e16:	c3                   	ret    

00801e17 <sys_cgetc>:

int
sys_cgetc(void)
{
  801e17:	55                   	push   %ebp
  801e18:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801e1a:	6a 00                	push   $0x0
  801e1c:	6a 00                	push   $0x0
  801e1e:	6a 00                	push   $0x0
  801e20:	6a 00                	push   $0x0
  801e22:	6a 00                	push   $0x0
  801e24:	6a 01                	push   $0x1
  801e26:	e8 98 ff ff ff       	call   801dc3 <syscall>
  801e2b:	83 c4 18             	add    $0x18,%esp
}
  801e2e:	c9                   	leave  
  801e2f:	c3                   	ret    

00801e30 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801e30:	55                   	push   %ebp
  801e31:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801e33:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e36:	8b 45 08             	mov    0x8(%ebp),%eax
  801e39:	6a 00                	push   $0x0
  801e3b:	6a 00                	push   $0x0
  801e3d:	6a 00                	push   $0x0
  801e3f:	52                   	push   %edx
  801e40:	50                   	push   %eax
  801e41:	6a 05                	push   $0x5
  801e43:	e8 7b ff ff ff       	call   801dc3 <syscall>
  801e48:	83 c4 18             	add    $0x18,%esp
}
  801e4b:	c9                   	leave  
  801e4c:	c3                   	ret    

00801e4d <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801e4d:	55                   	push   %ebp
  801e4e:	89 e5                	mov    %esp,%ebp
  801e50:	56                   	push   %esi
  801e51:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801e52:	8b 75 18             	mov    0x18(%ebp),%esi
  801e55:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e58:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e61:	56                   	push   %esi
  801e62:	53                   	push   %ebx
  801e63:	51                   	push   %ecx
  801e64:	52                   	push   %edx
  801e65:	50                   	push   %eax
  801e66:	6a 06                	push   $0x6
  801e68:	e8 56 ff ff ff       	call   801dc3 <syscall>
  801e6d:	83 c4 18             	add    $0x18,%esp
}
  801e70:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e73:	5b                   	pop    %ebx
  801e74:	5e                   	pop    %esi
  801e75:	5d                   	pop    %ebp
  801e76:	c3                   	ret    

00801e77 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801e77:	55                   	push   %ebp
  801e78:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801e7a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e80:	6a 00                	push   $0x0
  801e82:	6a 00                	push   $0x0
  801e84:	6a 00                	push   $0x0
  801e86:	52                   	push   %edx
  801e87:	50                   	push   %eax
  801e88:	6a 07                	push   $0x7
  801e8a:	e8 34 ff ff ff       	call   801dc3 <syscall>
  801e8f:	83 c4 18             	add    $0x18,%esp
}
  801e92:	c9                   	leave  
  801e93:	c3                   	ret    

00801e94 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801e94:	55                   	push   %ebp
  801e95:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801e97:	6a 00                	push   $0x0
  801e99:	6a 00                	push   $0x0
  801e9b:	6a 00                	push   $0x0
  801e9d:	ff 75 0c             	pushl  0xc(%ebp)
  801ea0:	ff 75 08             	pushl  0x8(%ebp)
  801ea3:	6a 08                	push   $0x8
  801ea5:	e8 19 ff ff ff       	call   801dc3 <syscall>
  801eaa:	83 c4 18             	add    $0x18,%esp
}
  801ead:	c9                   	leave  
  801eae:	c3                   	ret    

00801eaf <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801eaf:	55                   	push   %ebp
  801eb0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801eb2:	6a 00                	push   $0x0
  801eb4:	6a 00                	push   $0x0
  801eb6:	6a 00                	push   $0x0
  801eb8:	6a 00                	push   $0x0
  801eba:	6a 00                	push   $0x0
  801ebc:	6a 09                	push   $0x9
  801ebe:	e8 00 ff ff ff       	call   801dc3 <syscall>
  801ec3:	83 c4 18             	add    $0x18,%esp
}
  801ec6:	c9                   	leave  
  801ec7:	c3                   	ret    

00801ec8 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801ec8:	55                   	push   %ebp
  801ec9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801ecb:	6a 00                	push   $0x0
  801ecd:	6a 00                	push   $0x0
  801ecf:	6a 00                	push   $0x0
  801ed1:	6a 00                	push   $0x0
  801ed3:	6a 00                	push   $0x0
  801ed5:	6a 0a                	push   $0xa
  801ed7:	e8 e7 fe ff ff       	call   801dc3 <syscall>
  801edc:	83 c4 18             	add    $0x18,%esp
}
  801edf:	c9                   	leave  
  801ee0:	c3                   	ret    

00801ee1 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801ee1:	55                   	push   %ebp
  801ee2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801ee4:	6a 00                	push   $0x0
  801ee6:	6a 00                	push   $0x0
  801ee8:	6a 00                	push   $0x0
  801eea:	6a 00                	push   $0x0
  801eec:	6a 00                	push   $0x0
  801eee:	6a 0b                	push   $0xb
  801ef0:	e8 ce fe ff ff       	call   801dc3 <syscall>
  801ef5:	83 c4 18             	add    $0x18,%esp
}
  801ef8:	c9                   	leave  
  801ef9:	c3                   	ret    

00801efa <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801efa:	55                   	push   %ebp
  801efb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801efd:	6a 00                	push   $0x0
  801eff:	6a 00                	push   $0x0
  801f01:	6a 00                	push   $0x0
  801f03:	ff 75 0c             	pushl  0xc(%ebp)
  801f06:	ff 75 08             	pushl  0x8(%ebp)
  801f09:	6a 0f                	push   $0xf
  801f0b:	e8 b3 fe ff ff       	call   801dc3 <syscall>
  801f10:	83 c4 18             	add    $0x18,%esp
	return;
  801f13:	90                   	nop
}
  801f14:	c9                   	leave  
  801f15:	c3                   	ret    

00801f16 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801f16:	55                   	push   %ebp
  801f17:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801f19:	6a 00                	push   $0x0
  801f1b:	6a 00                	push   $0x0
  801f1d:	6a 00                	push   $0x0
  801f1f:	ff 75 0c             	pushl  0xc(%ebp)
  801f22:	ff 75 08             	pushl  0x8(%ebp)
  801f25:	6a 10                	push   $0x10
  801f27:	e8 97 fe ff ff       	call   801dc3 <syscall>
  801f2c:	83 c4 18             	add    $0x18,%esp
	return ;
  801f2f:	90                   	nop
}
  801f30:	c9                   	leave  
  801f31:	c3                   	ret    

00801f32 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801f32:	55                   	push   %ebp
  801f33:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801f35:	6a 00                	push   $0x0
  801f37:	6a 00                	push   $0x0
  801f39:	ff 75 10             	pushl  0x10(%ebp)
  801f3c:	ff 75 0c             	pushl  0xc(%ebp)
  801f3f:	ff 75 08             	pushl  0x8(%ebp)
  801f42:	6a 11                	push   $0x11
  801f44:	e8 7a fe ff ff       	call   801dc3 <syscall>
  801f49:	83 c4 18             	add    $0x18,%esp
	return ;
  801f4c:	90                   	nop
}
  801f4d:	c9                   	leave  
  801f4e:	c3                   	ret    

00801f4f <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801f4f:	55                   	push   %ebp
  801f50:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801f52:	6a 00                	push   $0x0
  801f54:	6a 00                	push   $0x0
  801f56:	6a 00                	push   $0x0
  801f58:	6a 00                	push   $0x0
  801f5a:	6a 00                	push   $0x0
  801f5c:	6a 0c                	push   $0xc
  801f5e:	e8 60 fe ff ff       	call   801dc3 <syscall>
  801f63:	83 c4 18             	add    $0x18,%esp
}
  801f66:	c9                   	leave  
  801f67:	c3                   	ret    

00801f68 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801f68:	55                   	push   %ebp
  801f69:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801f6b:	6a 00                	push   $0x0
  801f6d:	6a 00                	push   $0x0
  801f6f:	6a 00                	push   $0x0
  801f71:	6a 00                	push   $0x0
  801f73:	ff 75 08             	pushl  0x8(%ebp)
  801f76:	6a 0d                	push   $0xd
  801f78:	e8 46 fe ff ff       	call   801dc3 <syscall>
  801f7d:	83 c4 18             	add    $0x18,%esp
}
  801f80:	c9                   	leave  
  801f81:	c3                   	ret    

00801f82 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801f82:	55                   	push   %ebp
  801f83:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801f85:	6a 00                	push   $0x0
  801f87:	6a 00                	push   $0x0
  801f89:	6a 00                	push   $0x0
  801f8b:	6a 00                	push   $0x0
  801f8d:	6a 00                	push   $0x0
  801f8f:	6a 0e                	push   $0xe
  801f91:	e8 2d fe ff ff       	call   801dc3 <syscall>
  801f96:	83 c4 18             	add    $0x18,%esp
}
  801f99:	90                   	nop
  801f9a:	c9                   	leave  
  801f9b:	c3                   	ret    

00801f9c <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801f9c:	55                   	push   %ebp
  801f9d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801f9f:	6a 00                	push   $0x0
  801fa1:	6a 00                	push   $0x0
  801fa3:	6a 00                	push   $0x0
  801fa5:	6a 00                	push   $0x0
  801fa7:	6a 00                	push   $0x0
  801fa9:	6a 13                	push   $0x13
  801fab:	e8 13 fe ff ff       	call   801dc3 <syscall>
  801fb0:	83 c4 18             	add    $0x18,%esp
}
  801fb3:	90                   	nop
  801fb4:	c9                   	leave  
  801fb5:	c3                   	ret    

00801fb6 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801fb6:	55                   	push   %ebp
  801fb7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801fb9:	6a 00                	push   $0x0
  801fbb:	6a 00                	push   $0x0
  801fbd:	6a 00                	push   $0x0
  801fbf:	6a 00                	push   $0x0
  801fc1:	6a 00                	push   $0x0
  801fc3:	6a 14                	push   $0x14
  801fc5:	e8 f9 fd ff ff       	call   801dc3 <syscall>
  801fca:	83 c4 18             	add    $0x18,%esp
}
  801fcd:	90                   	nop
  801fce:	c9                   	leave  
  801fcf:	c3                   	ret    

00801fd0 <sys_cputc>:


void
sys_cputc(const char c)
{
  801fd0:	55                   	push   %ebp
  801fd1:	89 e5                	mov    %esp,%ebp
  801fd3:	83 ec 04             	sub    $0x4,%esp
  801fd6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801fdc:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801fe0:	6a 00                	push   $0x0
  801fe2:	6a 00                	push   $0x0
  801fe4:	6a 00                	push   $0x0
  801fe6:	6a 00                	push   $0x0
  801fe8:	50                   	push   %eax
  801fe9:	6a 15                	push   $0x15
  801feb:	e8 d3 fd ff ff       	call   801dc3 <syscall>
  801ff0:	83 c4 18             	add    $0x18,%esp
}
  801ff3:	90                   	nop
  801ff4:	c9                   	leave  
  801ff5:	c3                   	ret    

00801ff6 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801ff6:	55                   	push   %ebp
  801ff7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801ff9:	6a 00                	push   $0x0
  801ffb:	6a 00                	push   $0x0
  801ffd:	6a 00                	push   $0x0
  801fff:	6a 00                	push   $0x0
  802001:	6a 00                	push   $0x0
  802003:	6a 16                	push   $0x16
  802005:	e8 b9 fd ff ff       	call   801dc3 <syscall>
  80200a:	83 c4 18             	add    $0x18,%esp
}
  80200d:	90                   	nop
  80200e:	c9                   	leave  
  80200f:	c3                   	ret    

00802010 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802010:	55                   	push   %ebp
  802011:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802013:	8b 45 08             	mov    0x8(%ebp),%eax
  802016:	6a 00                	push   $0x0
  802018:	6a 00                	push   $0x0
  80201a:	6a 00                	push   $0x0
  80201c:	ff 75 0c             	pushl  0xc(%ebp)
  80201f:	50                   	push   %eax
  802020:	6a 17                	push   $0x17
  802022:	e8 9c fd ff ff       	call   801dc3 <syscall>
  802027:	83 c4 18             	add    $0x18,%esp
}
  80202a:	c9                   	leave  
  80202b:	c3                   	ret    

0080202c <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80202c:	55                   	push   %ebp
  80202d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80202f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802032:	8b 45 08             	mov    0x8(%ebp),%eax
  802035:	6a 00                	push   $0x0
  802037:	6a 00                	push   $0x0
  802039:	6a 00                	push   $0x0
  80203b:	52                   	push   %edx
  80203c:	50                   	push   %eax
  80203d:	6a 1a                	push   $0x1a
  80203f:	e8 7f fd ff ff       	call   801dc3 <syscall>
  802044:	83 c4 18             	add    $0x18,%esp
}
  802047:	c9                   	leave  
  802048:	c3                   	ret    

00802049 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802049:	55                   	push   %ebp
  80204a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80204c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80204f:	8b 45 08             	mov    0x8(%ebp),%eax
  802052:	6a 00                	push   $0x0
  802054:	6a 00                	push   $0x0
  802056:	6a 00                	push   $0x0
  802058:	52                   	push   %edx
  802059:	50                   	push   %eax
  80205a:	6a 18                	push   $0x18
  80205c:	e8 62 fd ff ff       	call   801dc3 <syscall>
  802061:	83 c4 18             	add    $0x18,%esp
}
  802064:	90                   	nop
  802065:	c9                   	leave  
  802066:	c3                   	ret    

00802067 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802067:	55                   	push   %ebp
  802068:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80206a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80206d:	8b 45 08             	mov    0x8(%ebp),%eax
  802070:	6a 00                	push   $0x0
  802072:	6a 00                	push   $0x0
  802074:	6a 00                	push   $0x0
  802076:	52                   	push   %edx
  802077:	50                   	push   %eax
  802078:	6a 19                	push   $0x19
  80207a:	e8 44 fd ff ff       	call   801dc3 <syscall>
  80207f:	83 c4 18             	add    $0x18,%esp
}
  802082:	90                   	nop
  802083:	c9                   	leave  
  802084:	c3                   	ret    

00802085 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802085:	55                   	push   %ebp
  802086:	89 e5                	mov    %esp,%ebp
  802088:	83 ec 04             	sub    $0x4,%esp
  80208b:	8b 45 10             	mov    0x10(%ebp),%eax
  80208e:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802091:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802094:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802098:	8b 45 08             	mov    0x8(%ebp),%eax
  80209b:	6a 00                	push   $0x0
  80209d:	51                   	push   %ecx
  80209e:	52                   	push   %edx
  80209f:	ff 75 0c             	pushl  0xc(%ebp)
  8020a2:	50                   	push   %eax
  8020a3:	6a 1b                	push   $0x1b
  8020a5:	e8 19 fd ff ff       	call   801dc3 <syscall>
  8020aa:	83 c4 18             	add    $0x18,%esp
}
  8020ad:	c9                   	leave  
  8020ae:	c3                   	ret    

008020af <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8020af:	55                   	push   %ebp
  8020b0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8020b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b8:	6a 00                	push   $0x0
  8020ba:	6a 00                	push   $0x0
  8020bc:	6a 00                	push   $0x0
  8020be:	52                   	push   %edx
  8020bf:	50                   	push   %eax
  8020c0:	6a 1c                	push   $0x1c
  8020c2:	e8 fc fc ff ff       	call   801dc3 <syscall>
  8020c7:	83 c4 18             	add    $0x18,%esp
}
  8020ca:	c9                   	leave  
  8020cb:	c3                   	ret    

008020cc <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8020cc:	55                   	push   %ebp
  8020cd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8020cf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d8:	6a 00                	push   $0x0
  8020da:	6a 00                	push   $0x0
  8020dc:	51                   	push   %ecx
  8020dd:	52                   	push   %edx
  8020de:	50                   	push   %eax
  8020df:	6a 1d                	push   $0x1d
  8020e1:	e8 dd fc ff ff       	call   801dc3 <syscall>
  8020e6:	83 c4 18             	add    $0x18,%esp
}
  8020e9:	c9                   	leave  
  8020ea:	c3                   	ret    

008020eb <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8020eb:	55                   	push   %ebp
  8020ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8020ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f4:	6a 00                	push   $0x0
  8020f6:	6a 00                	push   $0x0
  8020f8:	6a 00                	push   $0x0
  8020fa:	52                   	push   %edx
  8020fb:	50                   	push   %eax
  8020fc:	6a 1e                	push   $0x1e
  8020fe:	e8 c0 fc ff ff       	call   801dc3 <syscall>
  802103:	83 c4 18             	add    $0x18,%esp
}
  802106:	c9                   	leave  
  802107:	c3                   	ret    

00802108 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802108:	55                   	push   %ebp
  802109:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80210b:	6a 00                	push   $0x0
  80210d:	6a 00                	push   $0x0
  80210f:	6a 00                	push   $0x0
  802111:	6a 00                	push   $0x0
  802113:	6a 00                	push   $0x0
  802115:	6a 1f                	push   $0x1f
  802117:	e8 a7 fc ff ff       	call   801dc3 <syscall>
  80211c:	83 c4 18             	add    $0x18,%esp
}
  80211f:	c9                   	leave  
  802120:	c3                   	ret    

00802121 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802121:	55                   	push   %ebp
  802122:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802124:	8b 45 08             	mov    0x8(%ebp),%eax
  802127:	6a 00                	push   $0x0
  802129:	ff 75 14             	pushl  0x14(%ebp)
  80212c:	ff 75 10             	pushl  0x10(%ebp)
  80212f:	ff 75 0c             	pushl  0xc(%ebp)
  802132:	50                   	push   %eax
  802133:	6a 20                	push   $0x20
  802135:	e8 89 fc ff ff       	call   801dc3 <syscall>
  80213a:	83 c4 18             	add    $0x18,%esp
}
  80213d:	c9                   	leave  
  80213e:	c3                   	ret    

0080213f <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80213f:	55                   	push   %ebp
  802140:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802142:	8b 45 08             	mov    0x8(%ebp),%eax
  802145:	6a 00                	push   $0x0
  802147:	6a 00                	push   $0x0
  802149:	6a 00                	push   $0x0
  80214b:	6a 00                	push   $0x0
  80214d:	50                   	push   %eax
  80214e:	6a 21                	push   $0x21
  802150:	e8 6e fc ff ff       	call   801dc3 <syscall>
  802155:	83 c4 18             	add    $0x18,%esp
}
  802158:	90                   	nop
  802159:	c9                   	leave  
  80215a:	c3                   	ret    

0080215b <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80215b:	55                   	push   %ebp
  80215c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80215e:	8b 45 08             	mov    0x8(%ebp),%eax
  802161:	6a 00                	push   $0x0
  802163:	6a 00                	push   $0x0
  802165:	6a 00                	push   $0x0
  802167:	6a 00                	push   $0x0
  802169:	50                   	push   %eax
  80216a:	6a 22                	push   $0x22
  80216c:	e8 52 fc ff ff       	call   801dc3 <syscall>
  802171:	83 c4 18             	add    $0x18,%esp
}
  802174:	c9                   	leave  
  802175:	c3                   	ret    

00802176 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802176:	55                   	push   %ebp
  802177:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802179:	6a 00                	push   $0x0
  80217b:	6a 00                	push   $0x0
  80217d:	6a 00                	push   $0x0
  80217f:	6a 00                	push   $0x0
  802181:	6a 00                	push   $0x0
  802183:	6a 02                	push   $0x2
  802185:	e8 39 fc ff ff       	call   801dc3 <syscall>
  80218a:	83 c4 18             	add    $0x18,%esp
}
  80218d:	c9                   	leave  
  80218e:	c3                   	ret    

0080218f <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80218f:	55                   	push   %ebp
  802190:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802192:	6a 00                	push   $0x0
  802194:	6a 00                	push   $0x0
  802196:	6a 00                	push   $0x0
  802198:	6a 00                	push   $0x0
  80219a:	6a 00                	push   $0x0
  80219c:	6a 03                	push   $0x3
  80219e:	e8 20 fc ff ff       	call   801dc3 <syscall>
  8021a3:	83 c4 18             	add    $0x18,%esp
}
  8021a6:	c9                   	leave  
  8021a7:	c3                   	ret    

008021a8 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8021a8:	55                   	push   %ebp
  8021a9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8021ab:	6a 00                	push   $0x0
  8021ad:	6a 00                	push   $0x0
  8021af:	6a 00                	push   $0x0
  8021b1:	6a 00                	push   $0x0
  8021b3:	6a 00                	push   $0x0
  8021b5:	6a 04                	push   $0x4
  8021b7:	e8 07 fc ff ff       	call   801dc3 <syscall>
  8021bc:	83 c4 18             	add    $0x18,%esp
}
  8021bf:	c9                   	leave  
  8021c0:	c3                   	ret    

008021c1 <sys_exit_env>:


void sys_exit_env(void)
{
  8021c1:	55                   	push   %ebp
  8021c2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8021c4:	6a 00                	push   $0x0
  8021c6:	6a 00                	push   $0x0
  8021c8:	6a 00                	push   $0x0
  8021ca:	6a 00                	push   $0x0
  8021cc:	6a 00                	push   $0x0
  8021ce:	6a 23                	push   $0x23
  8021d0:	e8 ee fb ff ff       	call   801dc3 <syscall>
  8021d5:	83 c4 18             	add    $0x18,%esp
}
  8021d8:	90                   	nop
  8021d9:	c9                   	leave  
  8021da:	c3                   	ret    

008021db <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8021db:	55                   	push   %ebp
  8021dc:	89 e5                	mov    %esp,%ebp
  8021de:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8021e1:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8021e4:	8d 50 04             	lea    0x4(%eax),%edx
  8021e7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8021ea:	6a 00                	push   $0x0
  8021ec:	6a 00                	push   $0x0
  8021ee:	6a 00                	push   $0x0
  8021f0:	52                   	push   %edx
  8021f1:	50                   	push   %eax
  8021f2:	6a 24                	push   $0x24
  8021f4:	e8 ca fb ff ff       	call   801dc3 <syscall>
  8021f9:	83 c4 18             	add    $0x18,%esp
	return result;
  8021fc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8021ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802202:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802205:	89 01                	mov    %eax,(%ecx)
  802207:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80220a:	8b 45 08             	mov    0x8(%ebp),%eax
  80220d:	c9                   	leave  
  80220e:	c2 04 00             	ret    $0x4

00802211 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802211:	55                   	push   %ebp
  802212:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802214:	6a 00                	push   $0x0
  802216:	6a 00                	push   $0x0
  802218:	ff 75 10             	pushl  0x10(%ebp)
  80221b:	ff 75 0c             	pushl  0xc(%ebp)
  80221e:	ff 75 08             	pushl  0x8(%ebp)
  802221:	6a 12                	push   $0x12
  802223:	e8 9b fb ff ff       	call   801dc3 <syscall>
  802228:	83 c4 18             	add    $0x18,%esp
	return ;
  80222b:	90                   	nop
}
  80222c:	c9                   	leave  
  80222d:	c3                   	ret    

0080222e <sys_rcr2>:
uint32 sys_rcr2()
{
  80222e:	55                   	push   %ebp
  80222f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802231:	6a 00                	push   $0x0
  802233:	6a 00                	push   $0x0
  802235:	6a 00                	push   $0x0
  802237:	6a 00                	push   $0x0
  802239:	6a 00                	push   $0x0
  80223b:	6a 25                	push   $0x25
  80223d:	e8 81 fb ff ff       	call   801dc3 <syscall>
  802242:	83 c4 18             	add    $0x18,%esp
}
  802245:	c9                   	leave  
  802246:	c3                   	ret    

00802247 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802247:	55                   	push   %ebp
  802248:	89 e5                	mov    %esp,%ebp
  80224a:	83 ec 04             	sub    $0x4,%esp
  80224d:	8b 45 08             	mov    0x8(%ebp),%eax
  802250:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802253:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802257:	6a 00                	push   $0x0
  802259:	6a 00                	push   $0x0
  80225b:	6a 00                	push   $0x0
  80225d:	6a 00                	push   $0x0
  80225f:	50                   	push   %eax
  802260:	6a 26                	push   $0x26
  802262:	e8 5c fb ff ff       	call   801dc3 <syscall>
  802267:	83 c4 18             	add    $0x18,%esp
	return ;
  80226a:	90                   	nop
}
  80226b:	c9                   	leave  
  80226c:	c3                   	ret    

0080226d <rsttst>:
void rsttst()
{
  80226d:	55                   	push   %ebp
  80226e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802270:	6a 00                	push   $0x0
  802272:	6a 00                	push   $0x0
  802274:	6a 00                	push   $0x0
  802276:	6a 00                	push   $0x0
  802278:	6a 00                	push   $0x0
  80227a:	6a 28                	push   $0x28
  80227c:	e8 42 fb ff ff       	call   801dc3 <syscall>
  802281:	83 c4 18             	add    $0x18,%esp
	return ;
  802284:	90                   	nop
}
  802285:	c9                   	leave  
  802286:	c3                   	ret    

00802287 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802287:	55                   	push   %ebp
  802288:	89 e5                	mov    %esp,%ebp
  80228a:	83 ec 04             	sub    $0x4,%esp
  80228d:	8b 45 14             	mov    0x14(%ebp),%eax
  802290:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802293:	8b 55 18             	mov    0x18(%ebp),%edx
  802296:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80229a:	52                   	push   %edx
  80229b:	50                   	push   %eax
  80229c:	ff 75 10             	pushl  0x10(%ebp)
  80229f:	ff 75 0c             	pushl  0xc(%ebp)
  8022a2:	ff 75 08             	pushl  0x8(%ebp)
  8022a5:	6a 27                	push   $0x27
  8022a7:	e8 17 fb ff ff       	call   801dc3 <syscall>
  8022ac:	83 c4 18             	add    $0x18,%esp
	return ;
  8022af:	90                   	nop
}
  8022b0:	c9                   	leave  
  8022b1:	c3                   	ret    

008022b2 <chktst>:
void chktst(uint32 n)
{
  8022b2:	55                   	push   %ebp
  8022b3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8022b5:	6a 00                	push   $0x0
  8022b7:	6a 00                	push   $0x0
  8022b9:	6a 00                	push   $0x0
  8022bb:	6a 00                	push   $0x0
  8022bd:	ff 75 08             	pushl  0x8(%ebp)
  8022c0:	6a 29                	push   $0x29
  8022c2:	e8 fc fa ff ff       	call   801dc3 <syscall>
  8022c7:	83 c4 18             	add    $0x18,%esp
	return ;
  8022ca:	90                   	nop
}
  8022cb:	c9                   	leave  
  8022cc:	c3                   	ret    

008022cd <inctst>:

void inctst()
{
  8022cd:	55                   	push   %ebp
  8022ce:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8022d0:	6a 00                	push   $0x0
  8022d2:	6a 00                	push   $0x0
  8022d4:	6a 00                	push   $0x0
  8022d6:	6a 00                	push   $0x0
  8022d8:	6a 00                	push   $0x0
  8022da:	6a 2a                	push   $0x2a
  8022dc:	e8 e2 fa ff ff       	call   801dc3 <syscall>
  8022e1:	83 c4 18             	add    $0x18,%esp
	return ;
  8022e4:	90                   	nop
}
  8022e5:	c9                   	leave  
  8022e6:	c3                   	ret    

008022e7 <gettst>:
uint32 gettst()
{
  8022e7:	55                   	push   %ebp
  8022e8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8022ea:	6a 00                	push   $0x0
  8022ec:	6a 00                	push   $0x0
  8022ee:	6a 00                	push   $0x0
  8022f0:	6a 00                	push   $0x0
  8022f2:	6a 00                	push   $0x0
  8022f4:	6a 2b                	push   $0x2b
  8022f6:	e8 c8 fa ff ff       	call   801dc3 <syscall>
  8022fb:	83 c4 18             	add    $0x18,%esp
}
  8022fe:	c9                   	leave  
  8022ff:	c3                   	ret    

00802300 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802300:	55                   	push   %ebp
  802301:	89 e5                	mov    %esp,%ebp
  802303:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802306:	6a 00                	push   $0x0
  802308:	6a 00                	push   $0x0
  80230a:	6a 00                	push   $0x0
  80230c:	6a 00                	push   $0x0
  80230e:	6a 00                	push   $0x0
  802310:	6a 2c                	push   $0x2c
  802312:	e8 ac fa ff ff       	call   801dc3 <syscall>
  802317:	83 c4 18             	add    $0x18,%esp
  80231a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80231d:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802321:	75 07                	jne    80232a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802323:	b8 01 00 00 00       	mov    $0x1,%eax
  802328:	eb 05                	jmp    80232f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80232a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80232f:	c9                   	leave  
  802330:	c3                   	ret    

00802331 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802331:	55                   	push   %ebp
  802332:	89 e5                	mov    %esp,%ebp
  802334:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802337:	6a 00                	push   $0x0
  802339:	6a 00                	push   $0x0
  80233b:	6a 00                	push   $0x0
  80233d:	6a 00                	push   $0x0
  80233f:	6a 00                	push   $0x0
  802341:	6a 2c                	push   $0x2c
  802343:	e8 7b fa ff ff       	call   801dc3 <syscall>
  802348:	83 c4 18             	add    $0x18,%esp
  80234b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80234e:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802352:	75 07                	jne    80235b <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802354:	b8 01 00 00 00       	mov    $0x1,%eax
  802359:	eb 05                	jmp    802360 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80235b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802360:	c9                   	leave  
  802361:	c3                   	ret    

00802362 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802362:	55                   	push   %ebp
  802363:	89 e5                	mov    %esp,%ebp
  802365:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802368:	6a 00                	push   $0x0
  80236a:	6a 00                	push   $0x0
  80236c:	6a 00                	push   $0x0
  80236e:	6a 00                	push   $0x0
  802370:	6a 00                	push   $0x0
  802372:	6a 2c                	push   $0x2c
  802374:	e8 4a fa ff ff       	call   801dc3 <syscall>
  802379:	83 c4 18             	add    $0x18,%esp
  80237c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80237f:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802383:	75 07                	jne    80238c <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802385:	b8 01 00 00 00       	mov    $0x1,%eax
  80238a:	eb 05                	jmp    802391 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80238c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802391:	c9                   	leave  
  802392:	c3                   	ret    

00802393 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802393:	55                   	push   %ebp
  802394:	89 e5                	mov    %esp,%ebp
  802396:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802399:	6a 00                	push   $0x0
  80239b:	6a 00                	push   $0x0
  80239d:	6a 00                	push   $0x0
  80239f:	6a 00                	push   $0x0
  8023a1:	6a 00                	push   $0x0
  8023a3:	6a 2c                	push   $0x2c
  8023a5:	e8 19 fa ff ff       	call   801dc3 <syscall>
  8023aa:	83 c4 18             	add    $0x18,%esp
  8023ad:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8023b0:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8023b4:	75 07                	jne    8023bd <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8023b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8023bb:	eb 05                	jmp    8023c2 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8023bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023c2:	c9                   	leave  
  8023c3:	c3                   	ret    

008023c4 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8023c4:	55                   	push   %ebp
  8023c5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8023c7:	6a 00                	push   $0x0
  8023c9:	6a 00                	push   $0x0
  8023cb:	6a 00                	push   $0x0
  8023cd:	6a 00                	push   $0x0
  8023cf:	ff 75 08             	pushl  0x8(%ebp)
  8023d2:	6a 2d                	push   $0x2d
  8023d4:	e8 ea f9 ff ff       	call   801dc3 <syscall>
  8023d9:	83 c4 18             	add    $0x18,%esp
	return ;
  8023dc:	90                   	nop
}
  8023dd:	c9                   	leave  
  8023de:	c3                   	ret    

008023df <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8023df:	55                   	push   %ebp
  8023e0:	89 e5                	mov    %esp,%ebp
  8023e2:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8023e3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8023e6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8023e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ef:	6a 00                	push   $0x0
  8023f1:	53                   	push   %ebx
  8023f2:	51                   	push   %ecx
  8023f3:	52                   	push   %edx
  8023f4:	50                   	push   %eax
  8023f5:	6a 2e                	push   $0x2e
  8023f7:	e8 c7 f9 ff ff       	call   801dc3 <syscall>
  8023fc:	83 c4 18             	add    $0x18,%esp
}
  8023ff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802402:	c9                   	leave  
  802403:	c3                   	ret    

00802404 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802404:	55                   	push   %ebp
  802405:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802407:	8b 55 0c             	mov    0xc(%ebp),%edx
  80240a:	8b 45 08             	mov    0x8(%ebp),%eax
  80240d:	6a 00                	push   $0x0
  80240f:	6a 00                	push   $0x0
  802411:	6a 00                	push   $0x0
  802413:	52                   	push   %edx
  802414:	50                   	push   %eax
  802415:	6a 2f                	push   $0x2f
  802417:	e8 a7 f9 ff ff       	call   801dc3 <syscall>
  80241c:	83 c4 18             	add    $0x18,%esp
}
  80241f:	c9                   	leave  
  802420:	c3                   	ret    

00802421 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802421:	55                   	push   %ebp
  802422:	89 e5                	mov    %esp,%ebp
  802424:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802427:	83 ec 0c             	sub    $0xc,%esp
  80242a:	68 44 45 80 00       	push   $0x804544
  80242f:	e8 8c e7 ff ff       	call   800bc0 <cprintf>
  802434:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802437:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  80243e:	83 ec 0c             	sub    $0xc,%esp
  802441:	68 70 45 80 00       	push   $0x804570
  802446:	e8 75 e7 ff ff       	call   800bc0 <cprintf>
  80244b:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  80244e:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802452:	a1 38 51 80 00       	mov    0x805138,%eax
  802457:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80245a:	eb 56                	jmp    8024b2 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80245c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802460:	74 1c                	je     80247e <print_mem_block_lists+0x5d>
  802462:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802465:	8b 50 08             	mov    0x8(%eax),%edx
  802468:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80246b:	8b 48 08             	mov    0x8(%eax),%ecx
  80246e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802471:	8b 40 0c             	mov    0xc(%eax),%eax
  802474:	01 c8                	add    %ecx,%eax
  802476:	39 c2                	cmp    %eax,%edx
  802478:	73 04                	jae    80247e <print_mem_block_lists+0x5d>
			sorted = 0 ;
  80247a:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80247e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802481:	8b 50 08             	mov    0x8(%eax),%edx
  802484:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802487:	8b 40 0c             	mov    0xc(%eax),%eax
  80248a:	01 c2                	add    %eax,%edx
  80248c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248f:	8b 40 08             	mov    0x8(%eax),%eax
  802492:	83 ec 04             	sub    $0x4,%esp
  802495:	52                   	push   %edx
  802496:	50                   	push   %eax
  802497:	68 85 45 80 00       	push   $0x804585
  80249c:	e8 1f e7 ff ff       	call   800bc0 <cprintf>
  8024a1:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8024a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8024aa:	a1 40 51 80 00       	mov    0x805140,%eax
  8024af:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024b6:	74 07                	je     8024bf <print_mem_block_lists+0x9e>
  8024b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024bb:	8b 00                	mov    (%eax),%eax
  8024bd:	eb 05                	jmp    8024c4 <print_mem_block_lists+0xa3>
  8024bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8024c4:	a3 40 51 80 00       	mov    %eax,0x805140
  8024c9:	a1 40 51 80 00       	mov    0x805140,%eax
  8024ce:	85 c0                	test   %eax,%eax
  8024d0:	75 8a                	jne    80245c <print_mem_block_lists+0x3b>
  8024d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024d6:	75 84                	jne    80245c <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8024d8:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8024dc:	75 10                	jne    8024ee <print_mem_block_lists+0xcd>
  8024de:	83 ec 0c             	sub    $0xc,%esp
  8024e1:	68 94 45 80 00       	push   $0x804594
  8024e6:	e8 d5 e6 ff ff       	call   800bc0 <cprintf>
  8024eb:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8024ee:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8024f5:	83 ec 0c             	sub    $0xc,%esp
  8024f8:	68 b8 45 80 00       	push   $0x8045b8
  8024fd:	e8 be e6 ff ff       	call   800bc0 <cprintf>
  802502:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802505:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802509:	a1 40 50 80 00       	mov    0x805040,%eax
  80250e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802511:	eb 56                	jmp    802569 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802513:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802517:	74 1c                	je     802535 <print_mem_block_lists+0x114>
  802519:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251c:	8b 50 08             	mov    0x8(%eax),%edx
  80251f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802522:	8b 48 08             	mov    0x8(%eax),%ecx
  802525:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802528:	8b 40 0c             	mov    0xc(%eax),%eax
  80252b:	01 c8                	add    %ecx,%eax
  80252d:	39 c2                	cmp    %eax,%edx
  80252f:	73 04                	jae    802535 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802531:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802535:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802538:	8b 50 08             	mov    0x8(%eax),%edx
  80253b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253e:	8b 40 0c             	mov    0xc(%eax),%eax
  802541:	01 c2                	add    %eax,%edx
  802543:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802546:	8b 40 08             	mov    0x8(%eax),%eax
  802549:	83 ec 04             	sub    $0x4,%esp
  80254c:	52                   	push   %edx
  80254d:	50                   	push   %eax
  80254e:	68 85 45 80 00       	push   $0x804585
  802553:	e8 68 e6 ff ff       	call   800bc0 <cprintf>
  802558:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80255b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802561:	a1 48 50 80 00       	mov    0x805048,%eax
  802566:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802569:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80256d:	74 07                	je     802576 <print_mem_block_lists+0x155>
  80256f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802572:	8b 00                	mov    (%eax),%eax
  802574:	eb 05                	jmp    80257b <print_mem_block_lists+0x15a>
  802576:	b8 00 00 00 00       	mov    $0x0,%eax
  80257b:	a3 48 50 80 00       	mov    %eax,0x805048
  802580:	a1 48 50 80 00       	mov    0x805048,%eax
  802585:	85 c0                	test   %eax,%eax
  802587:	75 8a                	jne    802513 <print_mem_block_lists+0xf2>
  802589:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80258d:	75 84                	jne    802513 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80258f:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802593:	75 10                	jne    8025a5 <print_mem_block_lists+0x184>
  802595:	83 ec 0c             	sub    $0xc,%esp
  802598:	68 d0 45 80 00       	push   $0x8045d0
  80259d:	e8 1e e6 ff ff       	call   800bc0 <cprintf>
  8025a2:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8025a5:	83 ec 0c             	sub    $0xc,%esp
  8025a8:	68 44 45 80 00       	push   $0x804544
  8025ad:	e8 0e e6 ff ff       	call   800bc0 <cprintf>
  8025b2:	83 c4 10             	add    $0x10,%esp

}
  8025b5:	90                   	nop
  8025b6:	c9                   	leave  
  8025b7:	c3                   	ret    

008025b8 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8025b8:	55                   	push   %ebp
  8025b9:	89 e5                	mov    %esp,%ebp
  8025bb:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  8025be:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8025c5:	00 00 00 
  8025c8:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8025cf:	00 00 00 
  8025d2:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8025d9:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  8025dc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8025e3:	e9 9e 00 00 00       	jmp    802686 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  8025e8:	a1 50 50 80 00       	mov    0x805050,%eax
  8025ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025f0:	c1 e2 04             	shl    $0x4,%edx
  8025f3:	01 d0                	add    %edx,%eax
  8025f5:	85 c0                	test   %eax,%eax
  8025f7:	75 14                	jne    80260d <initialize_MemBlocksList+0x55>
  8025f9:	83 ec 04             	sub    $0x4,%esp
  8025fc:	68 f8 45 80 00       	push   $0x8045f8
  802601:	6a 46                	push   $0x46
  802603:	68 1b 46 80 00       	push   $0x80461b
  802608:	e8 ff e2 ff ff       	call   80090c <_panic>
  80260d:	a1 50 50 80 00       	mov    0x805050,%eax
  802612:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802615:	c1 e2 04             	shl    $0x4,%edx
  802618:	01 d0                	add    %edx,%eax
  80261a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802620:	89 10                	mov    %edx,(%eax)
  802622:	8b 00                	mov    (%eax),%eax
  802624:	85 c0                	test   %eax,%eax
  802626:	74 18                	je     802640 <initialize_MemBlocksList+0x88>
  802628:	a1 48 51 80 00       	mov    0x805148,%eax
  80262d:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802633:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802636:	c1 e1 04             	shl    $0x4,%ecx
  802639:	01 ca                	add    %ecx,%edx
  80263b:	89 50 04             	mov    %edx,0x4(%eax)
  80263e:	eb 12                	jmp    802652 <initialize_MemBlocksList+0x9a>
  802640:	a1 50 50 80 00       	mov    0x805050,%eax
  802645:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802648:	c1 e2 04             	shl    $0x4,%edx
  80264b:	01 d0                	add    %edx,%eax
  80264d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802652:	a1 50 50 80 00       	mov    0x805050,%eax
  802657:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80265a:	c1 e2 04             	shl    $0x4,%edx
  80265d:	01 d0                	add    %edx,%eax
  80265f:	a3 48 51 80 00       	mov    %eax,0x805148
  802664:	a1 50 50 80 00       	mov    0x805050,%eax
  802669:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80266c:	c1 e2 04             	shl    $0x4,%edx
  80266f:	01 d0                	add    %edx,%eax
  802671:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802678:	a1 54 51 80 00       	mov    0x805154,%eax
  80267d:	40                   	inc    %eax
  80267e:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802683:	ff 45 f4             	incl   -0xc(%ebp)
  802686:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802689:	3b 45 08             	cmp    0x8(%ebp),%eax
  80268c:	0f 82 56 ff ff ff    	jb     8025e8 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802692:	90                   	nop
  802693:	c9                   	leave  
  802694:	c3                   	ret    

00802695 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802695:	55                   	push   %ebp
  802696:	89 e5                	mov    %esp,%ebp
  802698:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80269b:	8b 45 08             	mov    0x8(%ebp),%eax
  80269e:	8b 00                	mov    (%eax),%eax
  8026a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8026a3:	eb 19                	jmp    8026be <find_block+0x29>
	{
		if(va==point->sva)
  8026a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8026a8:	8b 40 08             	mov    0x8(%eax),%eax
  8026ab:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8026ae:	75 05                	jne    8026b5 <find_block+0x20>
		   return point;
  8026b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8026b3:	eb 36                	jmp    8026eb <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8026b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b8:	8b 40 08             	mov    0x8(%eax),%eax
  8026bb:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8026be:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8026c2:	74 07                	je     8026cb <find_block+0x36>
  8026c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8026c7:	8b 00                	mov    (%eax),%eax
  8026c9:	eb 05                	jmp    8026d0 <find_block+0x3b>
  8026cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8026d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8026d3:	89 42 08             	mov    %eax,0x8(%edx)
  8026d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d9:	8b 40 08             	mov    0x8(%eax),%eax
  8026dc:	85 c0                	test   %eax,%eax
  8026de:	75 c5                	jne    8026a5 <find_block+0x10>
  8026e0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8026e4:	75 bf                	jne    8026a5 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  8026e6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026eb:	c9                   	leave  
  8026ec:	c3                   	ret    

008026ed <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8026ed:	55                   	push   %ebp
  8026ee:	89 e5                	mov    %esp,%ebp
  8026f0:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  8026f3:	a1 40 50 80 00       	mov    0x805040,%eax
  8026f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  8026fb:	a1 44 50 80 00       	mov    0x805044,%eax
  802700:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802703:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802706:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802709:	74 24                	je     80272f <insert_sorted_allocList+0x42>
  80270b:	8b 45 08             	mov    0x8(%ebp),%eax
  80270e:	8b 50 08             	mov    0x8(%eax),%edx
  802711:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802714:	8b 40 08             	mov    0x8(%eax),%eax
  802717:	39 c2                	cmp    %eax,%edx
  802719:	76 14                	jbe    80272f <insert_sorted_allocList+0x42>
  80271b:	8b 45 08             	mov    0x8(%ebp),%eax
  80271e:	8b 50 08             	mov    0x8(%eax),%edx
  802721:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802724:	8b 40 08             	mov    0x8(%eax),%eax
  802727:	39 c2                	cmp    %eax,%edx
  802729:	0f 82 60 01 00 00    	jb     80288f <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  80272f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802733:	75 65                	jne    80279a <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802735:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802739:	75 14                	jne    80274f <insert_sorted_allocList+0x62>
  80273b:	83 ec 04             	sub    $0x4,%esp
  80273e:	68 f8 45 80 00       	push   $0x8045f8
  802743:	6a 6b                	push   $0x6b
  802745:	68 1b 46 80 00       	push   $0x80461b
  80274a:	e8 bd e1 ff ff       	call   80090c <_panic>
  80274f:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802755:	8b 45 08             	mov    0x8(%ebp),%eax
  802758:	89 10                	mov    %edx,(%eax)
  80275a:	8b 45 08             	mov    0x8(%ebp),%eax
  80275d:	8b 00                	mov    (%eax),%eax
  80275f:	85 c0                	test   %eax,%eax
  802761:	74 0d                	je     802770 <insert_sorted_allocList+0x83>
  802763:	a1 40 50 80 00       	mov    0x805040,%eax
  802768:	8b 55 08             	mov    0x8(%ebp),%edx
  80276b:	89 50 04             	mov    %edx,0x4(%eax)
  80276e:	eb 08                	jmp    802778 <insert_sorted_allocList+0x8b>
  802770:	8b 45 08             	mov    0x8(%ebp),%eax
  802773:	a3 44 50 80 00       	mov    %eax,0x805044
  802778:	8b 45 08             	mov    0x8(%ebp),%eax
  80277b:	a3 40 50 80 00       	mov    %eax,0x805040
  802780:	8b 45 08             	mov    0x8(%ebp),%eax
  802783:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80278a:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80278f:	40                   	inc    %eax
  802790:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802795:	e9 dc 01 00 00       	jmp    802976 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  80279a:	8b 45 08             	mov    0x8(%ebp),%eax
  80279d:	8b 50 08             	mov    0x8(%eax),%edx
  8027a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027a3:	8b 40 08             	mov    0x8(%eax),%eax
  8027a6:	39 c2                	cmp    %eax,%edx
  8027a8:	77 6c                	ja     802816 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8027aa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027ae:	74 06                	je     8027b6 <insert_sorted_allocList+0xc9>
  8027b0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8027b4:	75 14                	jne    8027ca <insert_sorted_allocList+0xdd>
  8027b6:	83 ec 04             	sub    $0x4,%esp
  8027b9:	68 34 46 80 00       	push   $0x804634
  8027be:	6a 6f                	push   $0x6f
  8027c0:	68 1b 46 80 00       	push   $0x80461b
  8027c5:	e8 42 e1 ff ff       	call   80090c <_panic>
  8027ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027cd:	8b 50 04             	mov    0x4(%eax),%edx
  8027d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d3:	89 50 04             	mov    %edx,0x4(%eax)
  8027d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027dc:	89 10                	mov    %edx,(%eax)
  8027de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027e1:	8b 40 04             	mov    0x4(%eax),%eax
  8027e4:	85 c0                	test   %eax,%eax
  8027e6:	74 0d                	je     8027f5 <insert_sorted_allocList+0x108>
  8027e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027eb:	8b 40 04             	mov    0x4(%eax),%eax
  8027ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8027f1:	89 10                	mov    %edx,(%eax)
  8027f3:	eb 08                	jmp    8027fd <insert_sorted_allocList+0x110>
  8027f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f8:	a3 40 50 80 00       	mov    %eax,0x805040
  8027fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802800:	8b 55 08             	mov    0x8(%ebp),%edx
  802803:	89 50 04             	mov    %edx,0x4(%eax)
  802806:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80280b:	40                   	inc    %eax
  80280c:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802811:	e9 60 01 00 00       	jmp    802976 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802816:	8b 45 08             	mov    0x8(%ebp),%eax
  802819:	8b 50 08             	mov    0x8(%eax),%edx
  80281c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80281f:	8b 40 08             	mov    0x8(%eax),%eax
  802822:	39 c2                	cmp    %eax,%edx
  802824:	0f 82 4c 01 00 00    	jb     802976 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  80282a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80282e:	75 14                	jne    802844 <insert_sorted_allocList+0x157>
  802830:	83 ec 04             	sub    $0x4,%esp
  802833:	68 6c 46 80 00       	push   $0x80466c
  802838:	6a 73                	push   $0x73
  80283a:	68 1b 46 80 00       	push   $0x80461b
  80283f:	e8 c8 e0 ff ff       	call   80090c <_panic>
  802844:	8b 15 44 50 80 00    	mov    0x805044,%edx
  80284a:	8b 45 08             	mov    0x8(%ebp),%eax
  80284d:	89 50 04             	mov    %edx,0x4(%eax)
  802850:	8b 45 08             	mov    0x8(%ebp),%eax
  802853:	8b 40 04             	mov    0x4(%eax),%eax
  802856:	85 c0                	test   %eax,%eax
  802858:	74 0c                	je     802866 <insert_sorted_allocList+0x179>
  80285a:	a1 44 50 80 00       	mov    0x805044,%eax
  80285f:	8b 55 08             	mov    0x8(%ebp),%edx
  802862:	89 10                	mov    %edx,(%eax)
  802864:	eb 08                	jmp    80286e <insert_sorted_allocList+0x181>
  802866:	8b 45 08             	mov    0x8(%ebp),%eax
  802869:	a3 40 50 80 00       	mov    %eax,0x805040
  80286e:	8b 45 08             	mov    0x8(%ebp),%eax
  802871:	a3 44 50 80 00       	mov    %eax,0x805044
  802876:	8b 45 08             	mov    0x8(%ebp),%eax
  802879:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80287f:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802884:	40                   	inc    %eax
  802885:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80288a:	e9 e7 00 00 00       	jmp    802976 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  80288f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802892:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802895:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80289c:	a1 40 50 80 00       	mov    0x805040,%eax
  8028a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028a4:	e9 9d 00 00 00       	jmp    802946 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8028a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ac:	8b 00                	mov    (%eax),%eax
  8028ae:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8028b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b4:	8b 50 08             	mov    0x8(%eax),%edx
  8028b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ba:	8b 40 08             	mov    0x8(%eax),%eax
  8028bd:	39 c2                	cmp    %eax,%edx
  8028bf:	76 7d                	jbe    80293e <insert_sorted_allocList+0x251>
  8028c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c4:	8b 50 08             	mov    0x8(%eax),%edx
  8028c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028ca:	8b 40 08             	mov    0x8(%eax),%eax
  8028cd:	39 c2                	cmp    %eax,%edx
  8028cf:	73 6d                	jae    80293e <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8028d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028d5:	74 06                	je     8028dd <insert_sorted_allocList+0x1f0>
  8028d7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028db:	75 14                	jne    8028f1 <insert_sorted_allocList+0x204>
  8028dd:	83 ec 04             	sub    $0x4,%esp
  8028e0:	68 90 46 80 00       	push   $0x804690
  8028e5:	6a 7f                	push   $0x7f
  8028e7:	68 1b 46 80 00       	push   $0x80461b
  8028ec:	e8 1b e0 ff ff       	call   80090c <_panic>
  8028f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f4:	8b 10                	mov    (%eax),%edx
  8028f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f9:	89 10                	mov    %edx,(%eax)
  8028fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8028fe:	8b 00                	mov    (%eax),%eax
  802900:	85 c0                	test   %eax,%eax
  802902:	74 0b                	je     80290f <insert_sorted_allocList+0x222>
  802904:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802907:	8b 00                	mov    (%eax),%eax
  802909:	8b 55 08             	mov    0x8(%ebp),%edx
  80290c:	89 50 04             	mov    %edx,0x4(%eax)
  80290f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802912:	8b 55 08             	mov    0x8(%ebp),%edx
  802915:	89 10                	mov    %edx,(%eax)
  802917:	8b 45 08             	mov    0x8(%ebp),%eax
  80291a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80291d:	89 50 04             	mov    %edx,0x4(%eax)
  802920:	8b 45 08             	mov    0x8(%ebp),%eax
  802923:	8b 00                	mov    (%eax),%eax
  802925:	85 c0                	test   %eax,%eax
  802927:	75 08                	jne    802931 <insert_sorted_allocList+0x244>
  802929:	8b 45 08             	mov    0x8(%ebp),%eax
  80292c:	a3 44 50 80 00       	mov    %eax,0x805044
  802931:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802936:	40                   	inc    %eax
  802937:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  80293c:	eb 39                	jmp    802977 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80293e:	a1 48 50 80 00       	mov    0x805048,%eax
  802943:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802946:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80294a:	74 07                	je     802953 <insert_sorted_allocList+0x266>
  80294c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294f:	8b 00                	mov    (%eax),%eax
  802951:	eb 05                	jmp    802958 <insert_sorted_allocList+0x26b>
  802953:	b8 00 00 00 00       	mov    $0x0,%eax
  802958:	a3 48 50 80 00       	mov    %eax,0x805048
  80295d:	a1 48 50 80 00       	mov    0x805048,%eax
  802962:	85 c0                	test   %eax,%eax
  802964:	0f 85 3f ff ff ff    	jne    8028a9 <insert_sorted_allocList+0x1bc>
  80296a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80296e:	0f 85 35 ff ff ff    	jne    8028a9 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802974:	eb 01                	jmp    802977 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802976:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802977:	90                   	nop
  802978:	c9                   	leave  
  802979:	c3                   	ret    

0080297a <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80297a:	55                   	push   %ebp
  80297b:	89 e5                	mov    %esp,%ebp
  80297d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802980:	a1 38 51 80 00       	mov    0x805138,%eax
  802985:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802988:	e9 85 01 00 00       	jmp    802b12 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  80298d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802990:	8b 40 0c             	mov    0xc(%eax),%eax
  802993:	3b 45 08             	cmp    0x8(%ebp),%eax
  802996:	0f 82 6e 01 00 00    	jb     802b0a <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  80299c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299f:	8b 40 0c             	mov    0xc(%eax),%eax
  8029a2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029a5:	0f 85 8a 00 00 00    	jne    802a35 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8029ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029af:	75 17                	jne    8029c8 <alloc_block_FF+0x4e>
  8029b1:	83 ec 04             	sub    $0x4,%esp
  8029b4:	68 c4 46 80 00       	push   $0x8046c4
  8029b9:	68 93 00 00 00       	push   $0x93
  8029be:	68 1b 46 80 00       	push   $0x80461b
  8029c3:	e8 44 df ff ff       	call   80090c <_panic>
  8029c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029cb:	8b 00                	mov    (%eax),%eax
  8029cd:	85 c0                	test   %eax,%eax
  8029cf:	74 10                	je     8029e1 <alloc_block_FF+0x67>
  8029d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d4:	8b 00                	mov    (%eax),%eax
  8029d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029d9:	8b 52 04             	mov    0x4(%edx),%edx
  8029dc:	89 50 04             	mov    %edx,0x4(%eax)
  8029df:	eb 0b                	jmp    8029ec <alloc_block_FF+0x72>
  8029e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e4:	8b 40 04             	mov    0x4(%eax),%eax
  8029e7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8029ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ef:	8b 40 04             	mov    0x4(%eax),%eax
  8029f2:	85 c0                	test   %eax,%eax
  8029f4:	74 0f                	je     802a05 <alloc_block_FF+0x8b>
  8029f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f9:	8b 40 04             	mov    0x4(%eax),%eax
  8029fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029ff:	8b 12                	mov    (%edx),%edx
  802a01:	89 10                	mov    %edx,(%eax)
  802a03:	eb 0a                	jmp    802a0f <alloc_block_FF+0x95>
  802a05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a08:	8b 00                	mov    (%eax),%eax
  802a0a:	a3 38 51 80 00       	mov    %eax,0x805138
  802a0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a12:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a22:	a1 44 51 80 00       	mov    0x805144,%eax
  802a27:	48                   	dec    %eax
  802a28:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802a2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a30:	e9 10 01 00 00       	jmp    802b45 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802a35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a38:	8b 40 0c             	mov    0xc(%eax),%eax
  802a3b:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a3e:	0f 86 c6 00 00 00    	jbe    802b0a <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802a44:	a1 48 51 80 00       	mov    0x805148,%eax
  802a49:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802a4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4f:	8b 50 08             	mov    0x8(%eax),%edx
  802a52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a55:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802a58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a5b:	8b 55 08             	mov    0x8(%ebp),%edx
  802a5e:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802a61:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a65:	75 17                	jne    802a7e <alloc_block_FF+0x104>
  802a67:	83 ec 04             	sub    $0x4,%esp
  802a6a:	68 c4 46 80 00       	push   $0x8046c4
  802a6f:	68 9b 00 00 00       	push   $0x9b
  802a74:	68 1b 46 80 00       	push   $0x80461b
  802a79:	e8 8e de ff ff       	call   80090c <_panic>
  802a7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a81:	8b 00                	mov    (%eax),%eax
  802a83:	85 c0                	test   %eax,%eax
  802a85:	74 10                	je     802a97 <alloc_block_FF+0x11d>
  802a87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a8a:	8b 00                	mov    (%eax),%eax
  802a8c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a8f:	8b 52 04             	mov    0x4(%edx),%edx
  802a92:	89 50 04             	mov    %edx,0x4(%eax)
  802a95:	eb 0b                	jmp    802aa2 <alloc_block_FF+0x128>
  802a97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a9a:	8b 40 04             	mov    0x4(%eax),%eax
  802a9d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802aa2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aa5:	8b 40 04             	mov    0x4(%eax),%eax
  802aa8:	85 c0                	test   %eax,%eax
  802aaa:	74 0f                	je     802abb <alloc_block_FF+0x141>
  802aac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aaf:	8b 40 04             	mov    0x4(%eax),%eax
  802ab2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ab5:	8b 12                	mov    (%edx),%edx
  802ab7:	89 10                	mov    %edx,(%eax)
  802ab9:	eb 0a                	jmp    802ac5 <alloc_block_FF+0x14b>
  802abb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802abe:	8b 00                	mov    (%eax),%eax
  802ac0:	a3 48 51 80 00       	mov    %eax,0x805148
  802ac5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ac8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ace:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ad1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ad8:	a1 54 51 80 00       	mov    0x805154,%eax
  802add:	48                   	dec    %eax
  802ade:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802ae3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae6:	8b 50 08             	mov    0x8(%eax),%edx
  802ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  802aec:	01 c2                	add    %eax,%edx
  802aee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af1:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802af4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af7:	8b 40 0c             	mov    0xc(%eax),%eax
  802afa:	2b 45 08             	sub    0x8(%ebp),%eax
  802afd:	89 c2                	mov    %eax,%edx
  802aff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b02:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802b05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b08:	eb 3b                	jmp    802b45 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802b0a:	a1 40 51 80 00       	mov    0x805140,%eax
  802b0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b12:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b16:	74 07                	je     802b1f <alloc_block_FF+0x1a5>
  802b18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1b:	8b 00                	mov    (%eax),%eax
  802b1d:	eb 05                	jmp    802b24 <alloc_block_FF+0x1aa>
  802b1f:	b8 00 00 00 00       	mov    $0x0,%eax
  802b24:	a3 40 51 80 00       	mov    %eax,0x805140
  802b29:	a1 40 51 80 00       	mov    0x805140,%eax
  802b2e:	85 c0                	test   %eax,%eax
  802b30:	0f 85 57 fe ff ff    	jne    80298d <alloc_block_FF+0x13>
  802b36:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b3a:	0f 85 4d fe ff ff    	jne    80298d <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802b40:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b45:	c9                   	leave  
  802b46:	c3                   	ret    

00802b47 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802b47:	55                   	push   %ebp
  802b48:	89 e5                	mov    %esp,%ebp
  802b4a:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802b4d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802b54:	a1 38 51 80 00       	mov    0x805138,%eax
  802b59:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b5c:	e9 df 00 00 00       	jmp    802c40 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802b61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b64:	8b 40 0c             	mov    0xc(%eax),%eax
  802b67:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b6a:	0f 82 c8 00 00 00    	jb     802c38 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802b70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b73:	8b 40 0c             	mov    0xc(%eax),%eax
  802b76:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b79:	0f 85 8a 00 00 00    	jne    802c09 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802b7f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b83:	75 17                	jne    802b9c <alloc_block_BF+0x55>
  802b85:	83 ec 04             	sub    $0x4,%esp
  802b88:	68 c4 46 80 00       	push   $0x8046c4
  802b8d:	68 b7 00 00 00       	push   $0xb7
  802b92:	68 1b 46 80 00       	push   $0x80461b
  802b97:	e8 70 dd ff ff       	call   80090c <_panic>
  802b9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9f:	8b 00                	mov    (%eax),%eax
  802ba1:	85 c0                	test   %eax,%eax
  802ba3:	74 10                	je     802bb5 <alloc_block_BF+0x6e>
  802ba5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba8:	8b 00                	mov    (%eax),%eax
  802baa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bad:	8b 52 04             	mov    0x4(%edx),%edx
  802bb0:	89 50 04             	mov    %edx,0x4(%eax)
  802bb3:	eb 0b                	jmp    802bc0 <alloc_block_BF+0x79>
  802bb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb8:	8b 40 04             	mov    0x4(%eax),%eax
  802bbb:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802bc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc3:	8b 40 04             	mov    0x4(%eax),%eax
  802bc6:	85 c0                	test   %eax,%eax
  802bc8:	74 0f                	je     802bd9 <alloc_block_BF+0x92>
  802bca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bcd:	8b 40 04             	mov    0x4(%eax),%eax
  802bd0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bd3:	8b 12                	mov    (%edx),%edx
  802bd5:	89 10                	mov    %edx,(%eax)
  802bd7:	eb 0a                	jmp    802be3 <alloc_block_BF+0x9c>
  802bd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bdc:	8b 00                	mov    (%eax),%eax
  802bde:	a3 38 51 80 00       	mov    %eax,0x805138
  802be3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bef:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bf6:	a1 44 51 80 00       	mov    0x805144,%eax
  802bfb:	48                   	dec    %eax
  802bfc:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802c01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c04:	e9 4d 01 00 00       	jmp    802d56 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802c09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0c:	8b 40 0c             	mov    0xc(%eax),%eax
  802c0f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c12:	76 24                	jbe    802c38 <alloc_block_BF+0xf1>
  802c14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c17:	8b 40 0c             	mov    0xc(%eax),%eax
  802c1a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802c1d:	73 19                	jae    802c38 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802c1f:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802c26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c29:	8b 40 0c             	mov    0xc(%eax),%eax
  802c2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802c2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c32:	8b 40 08             	mov    0x8(%eax),%eax
  802c35:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802c38:	a1 40 51 80 00       	mov    0x805140,%eax
  802c3d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c40:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c44:	74 07                	je     802c4d <alloc_block_BF+0x106>
  802c46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c49:	8b 00                	mov    (%eax),%eax
  802c4b:	eb 05                	jmp    802c52 <alloc_block_BF+0x10b>
  802c4d:	b8 00 00 00 00       	mov    $0x0,%eax
  802c52:	a3 40 51 80 00       	mov    %eax,0x805140
  802c57:	a1 40 51 80 00       	mov    0x805140,%eax
  802c5c:	85 c0                	test   %eax,%eax
  802c5e:	0f 85 fd fe ff ff    	jne    802b61 <alloc_block_BF+0x1a>
  802c64:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c68:	0f 85 f3 fe ff ff    	jne    802b61 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802c6e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802c72:	0f 84 d9 00 00 00    	je     802d51 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802c78:	a1 48 51 80 00       	mov    0x805148,%eax
  802c7d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802c80:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c83:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c86:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802c89:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c8c:	8b 55 08             	mov    0x8(%ebp),%edx
  802c8f:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802c92:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802c96:	75 17                	jne    802caf <alloc_block_BF+0x168>
  802c98:	83 ec 04             	sub    $0x4,%esp
  802c9b:	68 c4 46 80 00       	push   $0x8046c4
  802ca0:	68 c7 00 00 00       	push   $0xc7
  802ca5:	68 1b 46 80 00       	push   $0x80461b
  802caa:	e8 5d dc ff ff       	call   80090c <_panic>
  802caf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cb2:	8b 00                	mov    (%eax),%eax
  802cb4:	85 c0                	test   %eax,%eax
  802cb6:	74 10                	je     802cc8 <alloc_block_BF+0x181>
  802cb8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cbb:	8b 00                	mov    (%eax),%eax
  802cbd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802cc0:	8b 52 04             	mov    0x4(%edx),%edx
  802cc3:	89 50 04             	mov    %edx,0x4(%eax)
  802cc6:	eb 0b                	jmp    802cd3 <alloc_block_BF+0x18c>
  802cc8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ccb:	8b 40 04             	mov    0x4(%eax),%eax
  802cce:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802cd3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cd6:	8b 40 04             	mov    0x4(%eax),%eax
  802cd9:	85 c0                	test   %eax,%eax
  802cdb:	74 0f                	je     802cec <alloc_block_BF+0x1a5>
  802cdd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ce0:	8b 40 04             	mov    0x4(%eax),%eax
  802ce3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802ce6:	8b 12                	mov    (%edx),%edx
  802ce8:	89 10                	mov    %edx,(%eax)
  802cea:	eb 0a                	jmp    802cf6 <alloc_block_BF+0x1af>
  802cec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cef:	8b 00                	mov    (%eax),%eax
  802cf1:	a3 48 51 80 00       	mov    %eax,0x805148
  802cf6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cf9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d02:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d09:	a1 54 51 80 00       	mov    0x805154,%eax
  802d0e:	48                   	dec    %eax
  802d0f:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802d14:	83 ec 08             	sub    $0x8,%esp
  802d17:	ff 75 ec             	pushl  -0x14(%ebp)
  802d1a:	68 38 51 80 00       	push   $0x805138
  802d1f:	e8 71 f9 ff ff       	call   802695 <find_block>
  802d24:	83 c4 10             	add    $0x10,%esp
  802d27:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802d2a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d2d:	8b 50 08             	mov    0x8(%eax),%edx
  802d30:	8b 45 08             	mov    0x8(%ebp),%eax
  802d33:	01 c2                	add    %eax,%edx
  802d35:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d38:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802d3b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d3e:	8b 40 0c             	mov    0xc(%eax),%eax
  802d41:	2b 45 08             	sub    0x8(%ebp),%eax
  802d44:	89 c2                	mov    %eax,%edx
  802d46:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d49:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802d4c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d4f:	eb 05                	jmp    802d56 <alloc_block_BF+0x20f>
	}
	return NULL;
  802d51:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d56:	c9                   	leave  
  802d57:	c3                   	ret    

00802d58 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802d58:	55                   	push   %ebp
  802d59:	89 e5                	mov    %esp,%ebp
  802d5b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802d5e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802d63:	85 c0                	test   %eax,%eax
  802d65:	0f 85 de 01 00 00    	jne    802f49 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802d6b:	a1 38 51 80 00       	mov    0x805138,%eax
  802d70:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d73:	e9 9e 01 00 00       	jmp    802f16 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802d78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7b:	8b 40 0c             	mov    0xc(%eax),%eax
  802d7e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d81:	0f 82 87 01 00 00    	jb     802f0e <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802d87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8a:	8b 40 0c             	mov    0xc(%eax),%eax
  802d8d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d90:	0f 85 95 00 00 00    	jne    802e2b <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802d96:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d9a:	75 17                	jne    802db3 <alloc_block_NF+0x5b>
  802d9c:	83 ec 04             	sub    $0x4,%esp
  802d9f:	68 c4 46 80 00       	push   $0x8046c4
  802da4:	68 e0 00 00 00       	push   $0xe0
  802da9:	68 1b 46 80 00       	push   $0x80461b
  802dae:	e8 59 db ff ff       	call   80090c <_panic>
  802db3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db6:	8b 00                	mov    (%eax),%eax
  802db8:	85 c0                	test   %eax,%eax
  802dba:	74 10                	je     802dcc <alloc_block_NF+0x74>
  802dbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbf:	8b 00                	mov    (%eax),%eax
  802dc1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dc4:	8b 52 04             	mov    0x4(%edx),%edx
  802dc7:	89 50 04             	mov    %edx,0x4(%eax)
  802dca:	eb 0b                	jmp    802dd7 <alloc_block_NF+0x7f>
  802dcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dcf:	8b 40 04             	mov    0x4(%eax),%eax
  802dd2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802dd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dda:	8b 40 04             	mov    0x4(%eax),%eax
  802ddd:	85 c0                	test   %eax,%eax
  802ddf:	74 0f                	je     802df0 <alloc_block_NF+0x98>
  802de1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de4:	8b 40 04             	mov    0x4(%eax),%eax
  802de7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dea:	8b 12                	mov    (%edx),%edx
  802dec:	89 10                	mov    %edx,(%eax)
  802dee:	eb 0a                	jmp    802dfa <alloc_block_NF+0xa2>
  802df0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df3:	8b 00                	mov    (%eax),%eax
  802df5:	a3 38 51 80 00       	mov    %eax,0x805138
  802dfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dfd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e06:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e0d:	a1 44 51 80 00       	mov    0x805144,%eax
  802e12:	48                   	dec    %eax
  802e13:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802e18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1b:	8b 40 08             	mov    0x8(%eax),%eax
  802e1e:	a3 2c 50 80 00       	mov    %eax,0x80502c
				   return  point;
  802e23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e26:	e9 f8 04 00 00       	jmp    803323 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802e2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2e:	8b 40 0c             	mov    0xc(%eax),%eax
  802e31:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e34:	0f 86 d4 00 00 00    	jbe    802f0e <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802e3a:	a1 48 51 80 00       	mov    0x805148,%eax
  802e3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802e42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e45:	8b 50 08             	mov    0x8(%eax),%edx
  802e48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e4b:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802e4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e51:	8b 55 08             	mov    0x8(%ebp),%edx
  802e54:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802e57:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e5b:	75 17                	jne    802e74 <alloc_block_NF+0x11c>
  802e5d:	83 ec 04             	sub    $0x4,%esp
  802e60:	68 c4 46 80 00       	push   $0x8046c4
  802e65:	68 e9 00 00 00       	push   $0xe9
  802e6a:	68 1b 46 80 00       	push   $0x80461b
  802e6f:	e8 98 da ff ff       	call   80090c <_panic>
  802e74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e77:	8b 00                	mov    (%eax),%eax
  802e79:	85 c0                	test   %eax,%eax
  802e7b:	74 10                	je     802e8d <alloc_block_NF+0x135>
  802e7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e80:	8b 00                	mov    (%eax),%eax
  802e82:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e85:	8b 52 04             	mov    0x4(%edx),%edx
  802e88:	89 50 04             	mov    %edx,0x4(%eax)
  802e8b:	eb 0b                	jmp    802e98 <alloc_block_NF+0x140>
  802e8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e90:	8b 40 04             	mov    0x4(%eax),%eax
  802e93:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e9b:	8b 40 04             	mov    0x4(%eax),%eax
  802e9e:	85 c0                	test   %eax,%eax
  802ea0:	74 0f                	je     802eb1 <alloc_block_NF+0x159>
  802ea2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ea5:	8b 40 04             	mov    0x4(%eax),%eax
  802ea8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802eab:	8b 12                	mov    (%edx),%edx
  802ead:	89 10                	mov    %edx,(%eax)
  802eaf:	eb 0a                	jmp    802ebb <alloc_block_NF+0x163>
  802eb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eb4:	8b 00                	mov    (%eax),%eax
  802eb6:	a3 48 51 80 00       	mov    %eax,0x805148
  802ebb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ebe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ec4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ec7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ece:	a1 54 51 80 00       	mov    0x805154,%eax
  802ed3:	48                   	dec    %eax
  802ed4:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802ed9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802edc:	8b 40 08             	mov    0x8(%eax),%eax
  802edf:	a3 2c 50 80 00       	mov    %eax,0x80502c
				   point->sva += size;
  802ee4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee7:	8b 50 08             	mov    0x8(%eax),%edx
  802eea:	8b 45 08             	mov    0x8(%ebp),%eax
  802eed:	01 c2                	add    %eax,%edx
  802eef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef2:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802ef5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef8:	8b 40 0c             	mov    0xc(%eax),%eax
  802efb:	2b 45 08             	sub    0x8(%ebp),%eax
  802efe:	89 c2                	mov    %eax,%edx
  802f00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f03:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802f06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f09:	e9 15 04 00 00       	jmp    803323 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802f0e:	a1 40 51 80 00       	mov    0x805140,%eax
  802f13:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f16:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f1a:	74 07                	je     802f23 <alloc_block_NF+0x1cb>
  802f1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1f:	8b 00                	mov    (%eax),%eax
  802f21:	eb 05                	jmp    802f28 <alloc_block_NF+0x1d0>
  802f23:	b8 00 00 00 00       	mov    $0x0,%eax
  802f28:	a3 40 51 80 00       	mov    %eax,0x805140
  802f2d:	a1 40 51 80 00       	mov    0x805140,%eax
  802f32:	85 c0                	test   %eax,%eax
  802f34:	0f 85 3e fe ff ff    	jne    802d78 <alloc_block_NF+0x20>
  802f3a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f3e:	0f 85 34 fe ff ff    	jne    802d78 <alloc_block_NF+0x20>
  802f44:	e9 d5 03 00 00       	jmp    80331e <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802f49:	a1 38 51 80 00       	mov    0x805138,%eax
  802f4e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f51:	e9 b1 01 00 00       	jmp    803107 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802f56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f59:	8b 50 08             	mov    0x8(%eax),%edx
  802f5c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802f61:	39 c2                	cmp    %eax,%edx
  802f63:	0f 82 96 01 00 00    	jb     8030ff <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802f69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6c:	8b 40 0c             	mov    0xc(%eax),%eax
  802f6f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f72:	0f 82 87 01 00 00    	jb     8030ff <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802f78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7b:	8b 40 0c             	mov    0xc(%eax),%eax
  802f7e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f81:	0f 85 95 00 00 00    	jne    80301c <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802f87:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f8b:	75 17                	jne    802fa4 <alloc_block_NF+0x24c>
  802f8d:	83 ec 04             	sub    $0x4,%esp
  802f90:	68 c4 46 80 00       	push   $0x8046c4
  802f95:	68 fc 00 00 00       	push   $0xfc
  802f9a:	68 1b 46 80 00       	push   $0x80461b
  802f9f:	e8 68 d9 ff ff       	call   80090c <_panic>
  802fa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa7:	8b 00                	mov    (%eax),%eax
  802fa9:	85 c0                	test   %eax,%eax
  802fab:	74 10                	je     802fbd <alloc_block_NF+0x265>
  802fad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb0:	8b 00                	mov    (%eax),%eax
  802fb2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fb5:	8b 52 04             	mov    0x4(%edx),%edx
  802fb8:	89 50 04             	mov    %edx,0x4(%eax)
  802fbb:	eb 0b                	jmp    802fc8 <alloc_block_NF+0x270>
  802fbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc0:	8b 40 04             	mov    0x4(%eax),%eax
  802fc3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fcb:	8b 40 04             	mov    0x4(%eax),%eax
  802fce:	85 c0                	test   %eax,%eax
  802fd0:	74 0f                	je     802fe1 <alloc_block_NF+0x289>
  802fd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd5:	8b 40 04             	mov    0x4(%eax),%eax
  802fd8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fdb:	8b 12                	mov    (%edx),%edx
  802fdd:	89 10                	mov    %edx,(%eax)
  802fdf:	eb 0a                	jmp    802feb <alloc_block_NF+0x293>
  802fe1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe4:	8b 00                	mov    (%eax),%eax
  802fe6:	a3 38 51 80 00       	mov    %eax,0x805138
  802feb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ff4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ffe:	a1 44 51 80 00       	mov    0x805144,%eax
  803003:	48                   	dec    %eax
  803004:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  803009:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80300c:	8b 40 08             	mov    0x8(%eax),%eax
  80300f:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   return  point;
  803014:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803017:	e9 07 03 00 00       	jmp    803323 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  80301c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80301f:	8b 40 0c             	mov    0xc(%eax),%eax
  803022:	3b 45 08             	cmp    0x8(%ebp),%eax
  803025:	0f 86 d4 00 00 00    	jbe    8030ff <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80302b:	a1 48 51 80 00       	mov    0x805148,%eax
  803030:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  803033:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803036:	8b 50 08             	mov    0x8(%eax),%edx
  803039:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80303c:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  80303f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803042:	8b 55 08             	mov    0x8(%ebp),%edx
  803045:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803048:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80304c:	75 17                	jne    803065 <alloc_block_NF+0x30d>
  80304e:	83 ec 04             	sub    $0x4,%esp
  803051:	68 c4 46 80 00       	push   $0x8046c4
  803056:	68 04 01 00 00       	push   $0x104
  80305b:	68 1b 46 80 00       	push   $0x80461b
  803060:	e8 a7 d8 ff ff       	call   80090c <_panic>
  803065:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803068:	8b 00                	mov    (%eax),%eax
  80306a:	85 c0                	test   %eax,%eax
  80306c:	74 10                	je     80307e <alloc_block_NF+0x326>
  80306e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803071:	8b 00                	mov    (%eax),%eax
  803073:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803076:	8b 52 04             	mov    0x4(%edx),%edx
  803079:	89 50 04             	mov    %edx,0x4(%eax)
  80307c:	eb 0b                	jmp    803089 <alloc_block_NF+0x331>
  80307e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803081:	8b 40 04             	mov    0x4(%eax),%eax
  803084:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803089:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80308c:	8b 40 04             	mov    0x4(%eax),%eax
  80308f:	85 c0                	test   %eax,%eax
  803091:	74 0f                	je     8030a2 <alloc_block_NF+0x34a>
  803093:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803096:	8b 40 04             	mov    0x4(%eax),%eax
  803099:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80309c:	8b 12                	mov    (%edx),%edx
  80309e:	89 10                	mov    %edx,(%eax)
  8030a0:	eb 0a                	jmp    8030ac <alloc_block_NF+0x354>
  8030a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030a5:	8b 00                	mov    (%eax),%eax
  8030a7:	a3 48 51 80 00       	mov    %eax,0x805148
  8030ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030af:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030b8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030bf:	a1 54 51 80 00       	mov    0x805154,%eax
  8030c4:	48                   	dec    %eax
  8030c5:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  8030ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030cd:	8b 40 08             	mov    0x8(%eax),%eax
  8030d0:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   point->sva += size;
  8030d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d8:	8b 50 08             	mov    0x8(%eax),%edx
  8030db:	8b 45 08             	mov    0x8(%ebp),%eax
  8030de:	01 c2                	add    %eax,%edx
  8030e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e3:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8030e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e9:	8b 40 0c             	mov    0xc(%eax),%eax
  8030ec:	2b 45 08             	sub    0x8(%ebp),%eax
  8030ef:	89 c2                	mov    %eax,%edx
  8030f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f4:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8030f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030fa:	e9 24 02 00 00       	jmp    803323 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8030ff:	a1 40 51 80 00       	mov    0x805140,%eax
  803104:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803107:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80310b:	74 07                	je     803114 <alloc_block_NF+0x3bc>
  80310d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803110:	8b 00                	mov    (%eax),%eax
  803112:	eb 05                	jmp    803119 <alloc_block_NF+0x3c1>
  803114:	b8 00 00 00 00       	mov    $0x0,%eax
  803119:	a3 40 51 80 00       	mov    %eax,0x805140
  80311e:	a1 40 51 80 00       	mov    0x805140,%eax
  803123:	85 c0                	test   %eax,%eax
  803125:	0f 85 2b fe ff ff    	jne    802f56 <alloc_block_NF+0x1fe>
  80312b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80312f:	0f 85 21 fe ff ff    	jne    802f56 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803135:	a1 38 51 80 00       	mov    0x805138,%eax
  80313a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80313d:	e9 ae 01 00 00       	jmp    8032f0 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  803142:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803145:	8b 50 08             	mov    0x8(%eax),%edx
  803148:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80314d:	39 c2                	cmp    %eax,%edx
  80314f:	0f 83 93 01 00 00    	jae    8032e8 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  803155:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803158:	8b 40 0c             	mov    0xc(%eax),%eax
  80315b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80315e:	0f 82 84 01 00 00    	jb     8032e8 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  803164:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803167:	8b 40 0c             	mov    0xc(%eax),%eax
  80316a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80316d:	0f 85 95 00 00 00    	jne    803208 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  803173:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803177:	75 17                	jne    803190 <alloc_block_NF+0x438>
  803179:	83 ec 04             	sub    $0x4,%esp
  80317c:	68 c4 46 80 00       	push   $0x8046c4
  803181:	68 14 01 00 00       	push   $0x114
  803186:	68 1b 46 80 00       	push   $0x80461b
  80318b:	e8 7c d7 ff ff       	call   80090c <_panic>
  803190:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803193:	8b 00                	mov    (%eax),%eax
  803195:	85 c0                	test   %eax,%eax
  803197:	74 10                	je     8031a9 <alloc_block_NF+0x451>
  803199:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80319c:	8b 00                	mov    (%eax),%eax
  80319e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031a1:	8b 52 04             	mov    0x4(%edx),%edx
  8031a4:	89 50 04             	mov    %edx,0x4(%eax)
  8031a7:	eb 0b                	jmp    8031b4 <alloc_block_NF+0x45c>
  8031a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ac:	8b 40 04             	mov    0x4(%eax),%eax
  8031af:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b7:	8b 40 04             	mov    0x4(%eax),%eax
  8031ba:	85 c0                	test   %eax,%eax
  8031bc:	74 0f                	je     8031cd <alloc_block_NF+0x475>
  8031be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c1:	8b 40 04             	mov    0x4(%eax),%eax
  8031c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031c7:	8b 12                	mov    (%edx),%edx
  8031c9:	89 10                	mov    %edx,(%eax)
  8031cb:	eb 0a                	jmp    8031d7 <alloc_block_NF+0x47f>
  8031cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d0:	8b 00                	mov    (%eax),%eax
  8031d2:	a3 38 51 80 00       	mov    %eax,0x805138
  8031d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031da:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031ea:	a1 44 51 80 00       	mov    0x805144,%eax
  8031ef:	48                   	dec    %eax
  8031f0:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8031f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f8:	8b 40 08             	mov    0x8(%eax),%eax
  8031fb:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   return  point;
  803200:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803203:	e9 1b 01 00 00       	jmp    803323 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  803208:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80320b:	8b 40 0c             	mov    0xc(%eax),%eax
  80320e:	3b 45 08             	cmp    0x8(%ebp),%eax
  803211:	0f 86 d1 00 00 00    	jbe    8032e8 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803217:	a1 48 51 80 00       	mov    0x805148,%eax
  80321c:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  80321f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803222:	8b 50 08             	mov    0x8(%eax),%edx
  803225:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803228:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  80322b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80322e:	8b 55 08             	mov    0x8(%ebp),%edx
  803231:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803234:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803238:	75 17                	jne    803251 <alloc_block_NF+0x4f9>
  80323a:	83 ec 04             	sub    $0x4,%esp
  80323d:	68 c4 46 80 00       	push   $0x8046c4
  803242:	68 1c 01 00 00       	push   $0x11c
  803247:	68 1b 46 80 00       	push   $0x80461b
  80324c:	e8 bb d6 ff ff       	call   80090c <_panic>
  803251:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803254:	8b 00                	mov    (%eax),%eax
  803256:	85 c0                	test   %eax,%eax
  803258:	74 10                	je     80326a <alloc_block_NF+0x512>
  80325a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80325d:	8b 00                	mov    (%eax),%eax
  80325f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803262:	8b 52 04             	mov    0x4(%edx),%edx
  803265:	89 50 04             	mov    %edx,0x4(%eax)
  803268:	eb 0b                	jmp    803275 <alloc_block_NF+0x51d>
  80326a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80326d:	8b 40 04             	mov    0x4(%eax),%eax
  803270:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803275:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803278:	8b 40 04             	mov    0x4(%eax),%eax
  80327b:	85 c0                	test   %eax,%eax
  80327d:	74 0f                	je     80328e <alloc_block_NF+0x536>
  80327f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803282:	8b 40 04             	mov    0x4(%eax),%eax
  803285:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803288:	8b 12                	mov    (%edx),%edx
  80328a:	89 10                	mov    %edx,(%eax)
  80328c:	eb 0a                	jmp    803298 <alloc_block_NF+0x540>
  80328e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803291:	8b 00                	mov    (%eax),%eax
  803293:	a3 48 51 80 00       	mov    %eax,0x805148
  803298:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80329b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032a4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032ab:	a1 54 51 80 00       	mov    0x805154,%eax
  8032b0:	48                   	dec    %eax
  8032b1:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  8032b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032b9:	8b 40 08             	mov    0x8(%eax),%eax
  8032bc:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   point->sva += size;
  8032c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c4:	8b 50 08             	mov    0x8(%eax),%edx
  8032c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ca:	01 c2                	add    %eax,%edx
  8032cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032cf:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8032d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d5:	8b 40 0c             	mov    0xc(%eax),%eax
  8032d8:	2b 45 08             	sub    0x8(%ebp),%eax
  8032db:	89 c2                	mov    %eax,%edx
  8032dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032e0:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8032e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032e6:	eb 3b                	jmp    803323 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8032e8:	a1 40 51 80 00       	mov    0x805140,%eax
  8032ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032f4:	74 07                	je     8032fd <alloc_block_NF+0x5a5>
  8032f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f9:	8b 00                	mov    (%eax),%eax
  8032fb:	eb 05                	jmp    803302 <alloc_block_NF+0x5aa>
  8032fd:	b8 00 00 00 00       	mov    $0x0,%eax
  803302:	a3 40 51 80 00       	mov    %eax,0x805140
  803307:	a1 40 51 80 00       	mov    0x805140,%eax
  80330c:	85 c0                	test   %eax,%eax
  80330e:	0f 85 2e fe ff ff    	jne    803142 <alloc_block_NF+0x3ea>
  803314:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803318:	0f 85 24 fe ff ff    	jne    803142 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  80331e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803323:	c9                   	leave  
  803324:	c3                   	ret    

00803325 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803325:	55                   	push   %ebp
  803326:	89 e5                	mov    %esp,%ebp
  803328:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  80332b:	a1 38 51 80 00       	mov    0x805138,%eax
  803330:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  803333:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803338:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  80333b:	a1 38 51 80 00       	mov    0x805138,%eax
  803340:	85 c0                	test   %eax,%eax
  803342:	74 14                	je     803358 <insert_sorted_with_merge_freeList+0x33>
  803344:	8b 45 08             	mov    0x8(%ebp),%eax
  803347:	8b 50 08             	mov    0x8(%eax),%edx
  80334a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80334d:	8b 40 08             	mov    0x8(%eax),%eax
  803350:	39 c2                	cmp    %eax,%edx
  803352:	0f 87 9b 01 00 00    	ja     8034f3 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  803358:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80335c:	75 17                	jne    803375 <insert_sorted_with_merge_freeList+0x50>
  80335e:	83 ec 04             	sub    $0x4,%esp
  803361:	68 f8 45 80 00       	push   $0x8045f8
  803366:	68 38 01 00 00       	push   $0x138
  80336b:	68 1b 46 80 00       	push   $0x80461b
  803370:	e8 97 d5 ff ff       	call   80090c <_panic>
  803375:	8b 15 38 51 80 00    	mov    0x805138,%edx
  80337b:	8b 45 08             	mov    0x8(%ebp),%eax
  80337e:	89 10                	mov    %edx,(%eax)
  803380:	8b 45 08             	mov    0x8(%ebp),%eax
  803383:	8b 00                	mov    (%eax),%eax
  803385:	85 c0                	test   %eax,%eax
  803387:	74 0d                	je     803396 <insert_sorted_with_merge_freeList+0x71>
  803389:	a1 38 51 80 00       	mov    0x805138,%eax
  80338e:	8b 55 08             	mov    0x8(%ebp),%edx
  803391:	89 50 04             	mov    %edx,0x4(%eax)
  803394:	eb 08                	jmp    80339e <insert_sorted_with_merge_freeList+0x79>
  803396:	8b 45 08             	mov    0x8(%ebp),%eax
  803399:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80339e:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a1:	a3 38 51 80 00       	mov    %eax,0x805138
  8033a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033b0:	a1 44 51 80 00       	mov    0x805144,%eax
  8033b5:	40                   	inc    %eax
  8033b6:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8033bb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8033bf:	0f 84 a8 06 00 00    	je     803a6d <insert_sorted_with_merge_freeList+0x748>
  8033c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c8:	8b 50 08             	mov    0x8(%eax),%edx
  8033cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ce:	8b 40 0c             	mov    0xc(%eax),%eax
  8033d1:	01 c2                	add    %eax,%edx
  8033d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033d6:	8b 40 08             	mov    0x8(%eax),%eax
  8033d9:	39 c2                	cmp    %eax,%edx
  8033db:	0f 85 8c 06 00 00    	jne    803a6d <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  8033e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e4:	8b 50 0c             	mov    0xc(%eax),%edx
  8033e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033ea:	8b 40 0c             	mov    0xc(%eax),%eax
  8033ed:	01 c2                	add    %eax,%edx
  8033ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f2:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  8033f5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8033f9:	75 17                	jne    803412 <insert_sorted_with_merge_freeList+0xed>
  8033fb:	83 ec 04             	sub    $0x4,%esp
  8033fe:	68 c4 46 80 00       	push   $0x8046c4
  803403:	68 3c 01 00 00       	push   $0x13c
  803408:	68 1b 46 80 00       	push   $0x80461b
  80340d:	e8 fa d4 ff ff       	call   80090c <_panic>
  803412:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803415:	8b 00                	mov    (%eax),%eax
  803417:	85 c0                	test   %eax,%eax
  803419:	74 10                	je     80342b <insert_sorted_with_merge_freeList+0x106>
  80341b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80341e:	8b 00                	mov    (%eax),%eax
  803420:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803423:	8b 52 04             	mov    0x4(%edx),%edx
  803426:	89 50 04             	mov    %edx,0x4(%eax)
  803429:	eb 0b                	jmp    803436 <insert_sorted_with_merge_freeList+0x111>
  80342b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80342e:	8b 40 04             	mov    0x4(%eax),%eax
  803431:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803436:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803439:	8b 40 04             	mov    0x4(%eax),%eax
  80343c:	85 c0                	test   %eax,%eax
  80343e:	74 0f                	je     80344f <insert_sorted_with_merge_freeList+0x12a>
  803440:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803443:	8b 40 04             	mov    0x4(%eax),%eax
  803446:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803449:	8b 12                	mov    (%edx),%edx
  80344b:	89 10                	mov    %edx,(%eax)
  80344d:	eb 0a                	jmp    803459 <insert_sorted_with_merge_freeList+0x134>
  80344f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803452:	8b 00                	mov    (%eax),%eax
  803454:	a3 38 51 80 00       	mov    %eax,0x805138
  803459:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80345c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803462:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803465:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80346c:	a1 44 51 80 00       	mov    0x805144,%eax
  803471:	48                   	dec    %eax
  803472:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  803477:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80347a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  803481:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803484:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  80348b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80348f:	75 17                	jne    8034a8 <insert_sorted_with_merge_freeList+0x183>
  803491:	83 ec 04             	sub    $0x4,%esp
  803494:	68 f8 45 80 00       	push   $0x8045f8
  803499:	68 3f 01 00 00       	push   $0x13f
  80349e:	68 1b 46 80 00       	push   $0x80461b
  8034a3:	e8 64 d4 ff ff       	call   80090c <_panic>
  8034a8:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8034ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034b1:	89 10                	mov    %edx,(%eax)
  8034b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034b6:	8b 00                	mov    (%eax),%eax
  8034b8:	85 c0                	test   %eax,%eax
  8034ba:	74 0d                	je     8034c9 <insert_sorted_with_merge_freeList+0x1a4>
  8034bc:	a1 48 51 80 00       	mov    0x805148,%eax
  8034c1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034c4:	89 50 04             	mov    %edx,0x4(%eax)
  8034c7:	eb 08                	jmp    8034d1 <insert_sorted_with_merge_freeList+0x1ac>
  8034c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034cc:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8034d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034d4:	a3 48 51 80 00       	mov    %eax,0x805148
  8034d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034dc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034e3:	a1 54 51 80 00       	mov    0x805154,%eax
  8034e8:	40                   	inc    %eax
  8034e9:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8034ee:	e9 7a 05 00 00       	jmp    803a6d <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  8034f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f6:	8b 50 08             	mov    0x8(%eax),%edx
  8034f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034fc:	8b 40 08             	mov    0x8(%eax),%eax
  8034ff:	39 c2                	cmp    %eax,%edx
  803501:	0f 82 14 01 00 00    	jb     80361b <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  803507:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80350a:	8b 50 08             	mov    0x8(%eax),%edx
  80350d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803510:	8b 40 0c             	mov    0xc(%eax),%eax
  803513:	01 c2                	add    %eax,%edx
  803515:	8b 45 08             	mov    0x8(%ebp),%eax
  803518:	8b 40 08             	mov    0x8(%eax),%eax
  80351b:	39 c2                	cmp    %eax,%edx
  80351d:	0f 85 90 00 00 00    	jne    8035b3 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  803523:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803526:	8b 50 0c             	mov    0xc(%eax),%edx
  803529:	8b 45 08             	mov    0x8(%ebp),%eax
  80352c:	8b 40 0c             	mov    0xc(%eax),%eax
  80352f:	01 c2                	add    %eax,%edx
  803531:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803534:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  803537:	8b 45 08             	mov    0x8(%ebp),%eax
  80353a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  803541:	8b 45 08             	mov    0x8(%ebp),%eax
  803544:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80354b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80354f:	75 17                	jne    803568 <insert_sorted_with_merge_freeList+0x243>
  803551:	83 ec 04             	sub    $0x4,%esp
  803554:	68 f8 45 80 00       	push   $0x8045f8
  803559:	68 49 01 00 00       	push   $0x149
  80355e:	68 1b 46 80 00       	push   $0x80461b
  803563:	e8 a4 d3 ff ff       	call   80090c <_panic>
  803568:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80356e:	8b 45 08             	mov    0x8(%ebp),%eax
  803571:	89 10                	mov    %edx,(%eax)
  803573:	8b 45 08             	mov    0x8(%ebp),%eax
  803576:	8b 00                	mov    (%eax),%eax
  803578:	85 c0                	test   %eax,%eax
  80357a:	74 0d                	je     803589 <insert_sorted_with_merge_freeList+0x264>
  80357c:	a1 48 51 80 00       	mov    0x805148,%eax
  803581:	8b 55 08             	mov    0x8(%ebp),%edx
  803584:	89 50 04             	mov    %edx,0x4(%eax)
  803587:	eb 08                	jmp    803591 <insert_sorted_with_merge_freeList+0x26c>
  803589:	8b 45 08             	mov    0x8(%ebp),%eax
  80358c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803591:	8b 45 08             	mov    0x8(%ebp),%eax
  803594:	a3 48 51 80 00       	mov    %eax,0x805148
  803599:	8b 45 08             	mov    0x8(%ebp),%eax
  80359c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035a3:	a1 54 51 80 00       	mov    0x805154,%eax
  8035a8:	40                   	inc    %eax
  8035a9:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8035ae:	e9 bb 04 00 00       	jmp    803a6e <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  8035b3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035b7:	75 17                	jne    8035d0 <insert_sorted_with_merge_freeList+0x2ab>
  8035b9:	83 ec 04             	sub    $0x4,%esp
  8035bc:	68 6c 46 80 00       	push   $0x80466c
  8035c1:	68 4c 01 00 00       	push   $0x14c
  8035c6:	68 1b 46 80 00       	push   $0x80461b
  8035cb:	e8 3c d3 ff ff       	call   80090c <_panic>
  8035d0:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8035d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d9:	89 50 04             	mov    %edx,0x4(%eax)
  8035dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8035df:	8b 40 04             	mov    0x4(%eax),%eax
  8035e2:	85 c0                	test   %eax,%eax
  8035e4:	74 0c                	je     8035f2 <insert_sorted_with_merge_freeList+0x2cd>
  8035e6:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8035eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8035ee:	89 10                	mov    %edx,(%eax)
  8035f0:	eb 08                	jmp    8035fa <insert_sorted_with_merge_freeList+0x2d5>
  8035f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f5:	a3 38 51 80 00       	mov    %eax,0x805138
  8035fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8035fd:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803602:	8b 45 08             	mov    0x8(%ebp),%eax
  803605:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80360b:	a1 44 51 80 00       	mov    0x805144,%eax
  803610:	40                   	inc    %eax
  803611:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803616:	e9 53 04 00 00       	jmp    803a6e <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80361b:	a1 38 51 80 00       	mov    0x805138,%eax
  803620:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803623:	e9 15 04 00 00       	jmp    803a3d <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  803628:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80362b:	8b 00                	mov    (%eax),%eax
  80362d:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803630:	8b 45 08             	mov    0x8(%ebp),%eax
  803633:	8b 50 08             	mov    0x8(%eax),%edx
  803636:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803639:	8b 40 08             	mov    0x8(%eax),%eax
  80363c:	39 c2                	cmp    %eax,%edx
  80363e:	0f 86 f1 03 00 00    	jbe    803a35 <insert_sorted_with_merge_freeList+0x710>
  803644:	8b 45 08             	mov    0x8(%ebp),%eax
  803647:	8b 50 08             	mov    0x8(%eax),%edx
  80364a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80364d:	8b 40 08             	mov    0x8(%eax),%eax
  803650:	39 c2                	cmp    %eax,%edx
  803652:	0f 83 dd 03 00 00    	jae    803a35 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803658:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80365b:	8b 50 08             	mov    0x8(%eax),%edx
  80365e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803661:	8b 40 0c             	mov    0xc(%eax),%eax
  803664:	01 c2                	add    %eax,%edx
  803666:	8b 45 08             	mov    0x8(%ebp),%eax
  803669:	8b 40 08             	mov    0x8(%eax),%eax
  80366c:	39 c2                	cmp    %eax,%edx
  80366e:	0f 85 b9 01 00 00    	jne    80382d <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803674:	8b 45 08             	mov    0x8(%ebp),%eax
  803677:	8b 50 08             	mov    0x8(%eax),%edx
  80367a:	8b 45 08             	mov    0x8(%ebp),%eax
  80367d:	8b 40 0c             	mov    0xc(%eax),%eax
  803680:	01 c2                	add    %eax,%edx
  803682:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803685:	8b 40 08             	mov    0x8(%eax),%eax
  803688:	39 c2                	cmp    %eax,%edx
  80368a:	0f 85 0d 01 00 00    	jne    80379d <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803690:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803693:	8b 50 0c             	mov    0xc(%eax),%edx
  803696:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803699:	8b 40 0c             	mov    0xc(%eax),%eax
  80369c:	01 c2                	add    %eax,%edx
  80369e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036a1:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8036a4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8036a8:	75 17                	jne    8036c1 <insert_sorted_with_merge_freeList+0x39c>
  8036aa:	83 ec 04             	sub    $0x4,%esp
  8036ad:	68 c4 46 80 00       	push   $0x8046c4
  8036b2:	68 5c 01 00 00       	push   $0x15c
  8036b7:	68 1b 46 80 00       	push   $0x80461b
  8036bc:	e8 4b d2 ff ff       	call   80090c <_panic>
  8036c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036c4:	8b 00                	mov    (%eax),%eax
  8036c6:	85 c0                	test   %eax,%eax
  8036c8:	74 10                	je     8036da <insert_sorted_with_merge_freeList+0x3b5>
  8036ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036cd:	8b 00                	mov    (%eax),%eax
  8036cf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8036d2:	8b 52 04             	mov    0x4(%edx),%edx
  8036d5:	89 50 04             	mov    %edx,0x4(%eax)
  8036d8:	eb 0b                	jmp    8036e5 <insert_sorted_with_merge_freeList+0x3c0>
  8036da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036dd:	8b 40 04             	mov    0x4(%eax),%eax
  8036e0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8036e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036e8:	8b 40 04             	mov    0x4(%eax),%eax
  8036eb:	85 c0                	test   %eax,%eax
  8036ed:	74 0f                	je     8036fe <insert_sorted_with_merge_freeList+0x3d9>
  8036ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036f2:	8b 40 04             	mov    0x4(%eax),%eax
  8036f5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8036f8:	8b 12                	mov    (%edx),%edx
  8036fa:	89 10                	mov    %edx,(%eax)
  8036fc:	eb 0a                	jmp    803708 <insert_sorted_with_merge_freeList+0x3e3>
  8036fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803701:	8b 00                	mov    (%eax),%eax
  803703:	a3 38 51 80 00       	mov    %eax,0x805138
  803708:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80370b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803711:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803714:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80371b:	a1 44 51 80 00       	mov    0x805144,%eax
  803720:	48                   	dec    %eax
  803721:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803726:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803729:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803730:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803733:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80373a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80373e:	75 17                	jne    803757 <insert_sorted_with_merge_freeList+0x432>
  803740:	83 ec 04             	sub    $0x4,%esp
  803743:	68 f8 45 80 00       	push   $0x8045f8
  803748:	68 5f 01 00 00       	push   $0x15f
  80374d:	68 1b 46 80 00       	push   $0x80461b
  803752:	e8 b5 d1 ff ff       	call   80090c <_panic>
  803757:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80375d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803760:	89 10                	mov    %edx,(%eax)
  803762:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803765:	8b 00                	mov    (%eax),%eax
  803767:	85 c0                	test   %eax,%eax
  803769:	74 0d                	je     803778 <insert_sorted_with_merge_freeList+0x453>
  80376b:	a1 48 51 80 00       	mov    0x805148,%eax
  803770:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803773:	89 50 04             	mov    %edx,0x4(%eax)
  803776:	eb 08                	jmp    803780 <insert_sorted_with_merge_freeList+0x45b>
  803778:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80377b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803780:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803783:	a3 48 51 80 00       	mov    %eax,0x805148
  803788:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80378b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803792:	a1 54 51 80 00       	mov    0x805154,%eax
  803797:	40                   	inc    %eax
  803798:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  80379d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037a0:	8b 50 0c             	mov    0xc(%eax),%edx
  8037a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a6:	8b 40 0c             	mov    0xc(%eax),%eax
  8037a9:	01 c2                	add    %eax,%edx
  8037ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037ae:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8037b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8037b4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8037bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8037be:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8037c5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037c9:	75 17                	jne    8037e2 <insert_sorted_with_merge_freeList+0x4bd>
  8037cb:	83 ec 04             	sub    $0x4,%esp
  8037ce:	68 f8 45 80 00       	push   $0x8045f8
  8037d3:	68 64 01 00 00       	push   $0x164
  8037d8:	68 1b 46 80 00       	push   $0x80461b
  8037dd:	e8 2a d1 ff ff       	call   80090c <_panic>
  8037e2:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8037e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8037eb:	89 10                	mov    %edx,(%eax)
  8037ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8037f0:	8b 00                	mov    (%eax),%eax
  8037f2:	85 c0                	test   %eax,%eax
  8037f4:	74 0d                	je     803803 <insert_sorted_with_merge_freeList+0x4de>
  8037f6:	a1 48 51 80 00       	mov    0x805148,%eax
  8037fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8037fe:	89 50 04             	mov    %edx,0x4(%eax)
  803801:	eb 08                	jmp    80380b <insert_sorted_with_merge_freeList+0x4e6>
  803803:	8b 45 08             	mov    0x8(%ebp),%eax
  803806:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80380b:	8b 45 08             	mov    0x8(%ebp),%eax
  80380e:	a3 48 51 80 00       	mov    %eax,0x805148
  803813:	8b 45 08             	mov    0x8(%ebp),%eax
  803816:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80381d:	a1 54 51 80 00       	mov    0x805154,%eax
  803822:	40                   	inc    %eax
  803823:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803828:	e9 41 02 00 00       	jmp    803a6e <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80382d:	8b 45 08             	mov    0x8(%ebp),%eax
  803830:	8b 50 08             	mov    0x8(%eax),%edx
  803833:	8b 45 08             	mov    0x8(%ebp),%eax
  803836:	8b 40 0c             	mov    0xc(%eax),%eax
  803839:	01 c2                	add    %eax,%edx
  80383b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80383e:	8b 40 08             	mov    0x8(%eax),%eax
  803841:	39 c2                	cmp    %eax,%edx
  803843:	0f 85 7c 01 00 00    	jne    8039c5 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803849:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80384d:	74 06                	je     803855 <insert_sorted_with_merge_freeList+0x530>
  80384f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803853:	75 17                	jne    80386c <insert_sorted_with_merge_freeList+0x547>
  803855:	83 ec 04             	sub    $0x4,%esp
  803858:	68 34 46 80 00       	push   $0x804634
  80385d:	68 69 01 00 00       	push   $0x169
  803862:	68 1b 46 80 00       	push   $0x80461b
  803867:	e8 a0 d0 ff ff       	call   80090c <_panic>
  80386c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80386f:	8b 50 04             	mov    0x4(%eax),%edx
  803872:	8b 45 08             	mov    0x8(%ebp),%eax
  803875:	89 50 04             	mov    %edx,0x4(%eax)
  803878:	8b 45 08             	mov    0x8(%ebp),%eax
  80387b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80387e:	89 10                	mov    %edx,(%eax)
  803880:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803883:	8b 40 04             	mov    0x4(%eax),%eax
  803886:	85 c0                	test   %eax,%eax
  803888:	74 0d                	je     803897 <insert_sorted_with_merge_freeList+0x572>
  80388a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80388d:	8b 40 04             	mov    0x4(%eax),%eax
  803890:	8b 55 08             	mov    0x8(%ebp),%edx
  803893:	89 10                	mov    %edx,(%eax)
  803895:	eb 08                	jmp    80389f <insert_sorted_with_merge_freeList+0x57a>
  803897:	8b 45 08             	mov    0x8(%ebp),%eax
  80389a:	a3 38 51 80 00       	mov    %eax,0x805138
  80389f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8038a5:	89 50 04             	mov    %edx,0x4(%eax)
  8038a8:	a1 44 51 80 00       	mov    0x805144,%eax
  8038ad:	40                   	inc    %eax
  8038ae:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  8038b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8038b6:	8b 50 0c             	mov    0xc(%eax),%edx
  8038b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038bc:	8b 40 0c             	mov    0xc(%eax),%eax
  8038bf:	01 c2                	add    %eax,%edx
  8038c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8038c4:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8038c7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8038cb:	75 17                	jne    8038e4 <insert_sorted_with_merge_freeList+0x5bf>
  8038cd:	83 ec 04             	sub    $0x4,%esp
  8038d0:	68 c4 46 80 00       	push   $0x8046c4
  8038d5:	68 6b 01 00 00       	push   $0x16b
  8038da:	68 1b 46 80 00       	push   $0x80461b
  8038df:	e8 28 d0 ff ff       	call   80090c <_panic>
  8038e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038e7:	8b 00                	mov    (%eax),%eax
  8038e9:	85 c0                	test   %eax,%eax
  8038eb:	74 10                	je     8038fd <insert_sorted_with_merge_freeList+0x5d8>
  8038ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038f0:	8b 00                	mov    (%eax),%eax
  8038f2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8038f5:	8b 52 04             	mov    0x4(%edx),%edx
  8038f8:	89 50 04             	mov    %edx,0x4(%eax)
  8038fb:	eb 0b                	jmp    803908 <insert_sorted_with_merge_freeList+0x5e3>
  8038fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803900:	8b 40 04             	mov    0x4(%eax),%eax
  803903:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803908:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80390b:	8b 40 04             	mov    0x4(%eax),%eax
  80390e:	85 c0                	test   %eax,%eax
  803910:	74 0f                	je     803921 <insert_sorted_with_merge_freeList+0x5fc>
  803912:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803915:	8b 40 04             	mov    0x4(%eax),%eax
  803918:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80391b:	8b 12                	mov    (%edx),%edx
  80391d:	89 10                	mov    %edx,(%eax)
  80391f:	eb 0a                	jmp    80392b <insert_sorted_with_merge_freeList+0x606>
  803921:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803924:	8b 00                	mov    (%eax),%eax
  803926:	a3 38 51 80 00       	mov    %eax,0x805138
  80392b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80392e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803934:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803937:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80393e:	a1 44 51 80 00       	mov    0x805144,%eax
  803943:	48                   	dec    %eax
  803944:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803949:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80394c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803953:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803956:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80395d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803961:	75 17                	jne    80397a <insert_sorted_with_merge_freeList+0x655>
  803963:	83 ec 04             	sub    $0x4,%esp
  803966:	68 f8 45 80 00       	push   $0x8045f8
  80396b:	68 6e 01 00 00       	push   $0x16e
  803970:	68 1b 46 80 00       	push   $0x80461b
  803975:	e8 92 cf ff ff       	call   80090c <_panic>
  80397a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803980:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803983:	89 10                	mov    %edx,(%eax)
  803985:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803988:	8b 00                	mov    (%eax),%eax
  80398a:	85 c0                	test   %eax,%eax
  80398c:	74 0d                	je     80399b <insert_sorted_with_merge_freeList+0x676>
  80398e:	a1 48 51 80 00       	mov    0x805148,%eax
  803993:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803996:	89 50 04             	mov    %edx,0x4(%eax)
  803999:	eb 08                	jmp    8039a3 <insert_sorted_with_merge_freeList+0x67e>
  80399b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80399e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8039a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039a6:	a3 48 51 80 00       	mov    %eax,0x805148
  8039ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039ae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039b5:	a1 54 51 80 00       	mov    0x805154,%eax
  8039ba:	40                   	inc    %eax
  8039bb:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8039c0:	e9 a9 00 00 00       	jmp    803a6e <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8039c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8039c9:	74 06                	je     8039d1 <insert_sorted_with_merge_freeList+0x6ac>
  8039cb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8039cf:	75 17                	jne    8039e8 <insert_sorted_with_merge_freeList+0x6c3>
  8039d1:	83 ec 04             	sub    $0x4,%esp
  8039d4:	68 90 46 80 00       	push   $0x804690
  8039d9:	68 73 01 00 00       	push   $0x173
  8039de:	68 1b 46 80 00       	push   $0x80461b
  8039e3:	e8 24 cf ff ff       	call   80090c <_panic>
  8039e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039eb:	8b 10                	mov    (%eax),%edx
  8039ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8039f0:	89 10                	mov    %edx,(%eax)
  8039f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8039f5:	8b 00                	mov    (%eax),%eax
  8039f7:	85 c0                	test   %eax,%eax
  8039f9:	74 0b                	je     803a06 <insert_sorted_with_merge_freeList+0x6e1>
  8039fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039fe:	8b 00                	mov    (%eax),%eax
  803a00:	8b 55 08             	mov    0x8(%ebp),%edx
  803a03:	89 50 04             	mov    %edx,0x4(%eax)
  803a06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a09:	8b 55 08             	mov    0x8(%ebp),%edx
  803a0c:	89 10                	mov    %edx,(%eax)
  803a0e:	8b 45 08             	mov    0x8(%ebp),%eax
  803a11:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803a14:	89 50 04             	mov    %edx,0x4(%eax)
  803a17:	8b 45 08             	mov    0x8(%ebp),%eax
  803a1a:	8b 00                	mov    (%eax),%eax
  803a1c:	85 c0                	test   %eax,%eax
  803a1e:	75 08                	jne    803a28 <insert_sorted_with_merge_freeList+0x703>
  803a20:	8b 45 08             	mov    0x8(%ebp),%eax
  803a23:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803a28:	a1 44 51 80 00       	mov    0x805144,%eax
  803a2d:	40                   	inc    %eax
  803a2e:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803a33:	eb 39                	jmp    803a6e <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803a35:	a1 40 51 80 00       	mov    0x805140,%eax
  803a3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803a3d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a41:	74 07                	je     803a4a <insert_sorted_with_merge_freeList+0x725>
  803a43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a46:	8b 00                	mov    (%eax),%eax
  803a48:	eb 05                	jmp    803a4f <insert_sorted_with_merge_freeList+0x72a>
  803a4a:	b8 00 00 00 00       	mov    $0x0,%eax
  803a4f:	a3 40 51 80 00       	mov    %eax,0x805140
  803a54:	a1 40 51 80 00       	mov    0x805140,%eax
  803a59:	85 c0                	test   %eax,%eax
  803a5b:	0f 85 c7 fb ff ff    	jne    803628 <insert_sorted_with_merge_freeList+0x303>
  803a61:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a65:	0f 85 bd fb ff ff    	jne    803628 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803a6b:	eb 01                	jmp    803a6e <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803a6d:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803a6e:	90                   	nop
  803a6f:	c9                   	leave  
  803a70:	c3                   	ret    
  803a71:	66 90                	xchg   %ax,%ax
  803a73:	90                   	nop

00803a74 <__udivdi3>:
  803a74:	55                   	push   %ebp
  803a75:	57                   	push   %edi
  803a76:	56                   	push   %esi
  803a77:	53                   	push   %ebx
  803a78:	83 ec 1c             	sub    $0x1c,%esp
  803a7b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803a7f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803a83:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803a87:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803a8b:	89 ca                	mov    %ecx,%edx
  803a8d:	89 f8                	mov    %edi,%eax
  803a8f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803a93:	85 f6                	test   %esi,%esi
  803a95:	75 2d                	jne    803ac4 <__udivdi3+0x50>
  803a97:	39 cf                	cmp    %ecx,%edi
  803a99:	77 65                	ja     803b00 <__udivdi3+0x8c>
  803a9b:	89 fd                	mov    %edi,%ebp
  803a9d:	85 ff                	test   %edi,%edi
  803a9f:	75 0b                	jne    803aac <__udivdi3+0x38>
  803aa1:	b8 01 00 00 00       	mov    $0x1,%eax
  803aa6:	31 d2                	xor    %edx,%edx
  803aa8:	f7 f7                	div    %edi
  803aaa:	89 c5                	mov    %eax,%ebp
  803aac:	31 d2                	xor    %edx,%edx
  803aae:	89 c8                	mov    %ecx,%eax
  803ab0:	f7 f5                	div    %ebp
  803ab2:	89 c1                	mov    %eax,%ecx
  803ab4:	89 d8                	mov    %ebx,%eax
  803ab6:	f7 f5                	div    %ebp
  803ab8:	89 cf                	mov    %ecx,%edi
  803aba:	89 fa                	mov    %edi,%edx
  803abc:	83 c4 1c             	add    $0x1c,%esp
  803abf:	5b                   	pop    %ebx
  803ac0:	5e                   	pop    %esi
  803ac1:	5f                   	pop    %edi
  803ac2:	5d                   	pop    %ebp
  803ac3:	c3                   	ret    
  803ac4:	39 ce                	cmp    %ecx,%esi
  803ac6:	77 28                	ja     803af0 <__udivdi3+0x7c>
  803ac8:	0f bd fe             	bsr    %esi,%edi
  803acb:	83 f7 1f             	xor    $0x1f,%edi
  803ace:	75 40                	jne    803b10 <__udivdi3+0x9c>
  803ad0:	39 ce                	cmp    %ecx,%esi
  803ad2:	72 0a                	jb     803ade <__udivdi3+0x6a>
  803ad4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803ad8:	0f 87 9e 00 00 00    	ja     803b7c <__udivdi3+0x108>
  803ade:	b8 01 00 00 00       	mov    $0x1,%eax
  803ae3:	89 fa                	mov    %edi,%edx
  803ae5:	83 c4 1c             	add    $0x1c,%esp
  803ae8:	5b                   	pop    %ebx
  803ae9:	5e                   	pop    %esi
  803aea:	5f                   	pop    %edi
  803aeb:	5d                   	pop    %ebp
  803aec:	c3                   	ret    
  803aed:	8d 76 00             	lea    0x0(%esi),%esi
  803af0:	31 ff                	xor    %edi,%edi
  803af2:	31 c0                	xor    %eax,%eax
  803af4:	89 fa                	mov    %edi,%edx
  803af6:	83 c4 1c             	add    $0x1c,%esp
  803af9:	5b                   	pop    %ebx
  803afa:	5e                   	pop    %esi
  803afb:	5f                   	pop    %edi
  803afc:	5d                   	pop    %ebp
  803afd:	c3                   	ret    
  803afe:	66 90                	xchg   %ax,%ax
  803b00:	89 d8                	mov    %ebx,%eax
  803b02:	f7 f7                	div    %edi
  803b04:	31 ff                	xor    %edi,%edi
  803b06:	89 fa                	mov    %edi,%edx
  803b08:	83 c4 1c             	add    $0x1c,%esp
  803b0b:	5b                   	pop    %ebx
  803b0c:	5e                   	pop    %esi
  803b0d:	5f                   	pop    %edi
  803b0e:	5d                   	pop    %ebp
  803b0f:	c3                   	ret    
  803b10:	bd 20 00 00 00       	mov    $0x20,%ebp
  803b15:	89 eb                	mov    %ebp,%ebx
  803b17:	29 fb                	sub    %edi,%ebx
  803b19:	89 f9                	mov    %edi,%ecx
  803b1b:	d3 e6                	shl    %cl,%esi
  803b1d:	89 c5                	mov    %eax,%ebp
  803b1f:	88 d9                	mov    %bl,%cl
  803b21:	d3 ed                	shr    %cl,%ebp
  803b23:	89 e9                	mov    %ebp,%ecx
  803b25:	09 f1                	or     %esi,%ecx
  803b27:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803b2b:	89 f9                	mov    %edi,%ecx
  803b2d:	d3 e0                	shl    %cl,%eax
  803b2f:	89 c5                	mov    %eax,%ebp
  803b31:	89 d6                	mov    %edx,%esi
  803b33:	88 d9                	mov    %bl,%cl
  803b35:	d3 ee                	shr    %cl,%esi
  803b37:	89 f9                	mov    %edi,%ecx
  803b39:	d3 e2                	shl    %cl,%edx
  803b3b:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b3f:	88 d9                	mov    %bl,%cl
  803b41:	d3 e8                	shr    %cl,%eax
  803b43:	09 c2                	or     %eax,%edx
  803b45:	89 d0                	mov    %edx,%eax
  803b47:	89 f2                	mov    %esi,%edx
  803b49:	f7 74 24 0c          	divl   0xc(%esp)
  803b4d:	89 d6                	mov    %edx,%esi
  803b4f:	89 c3                	mov    %eax,%ebx
  803b51:	f7 e5                	mul    %ebp
  803b53:	39 d6                	cmp    %edx,%esi
  803b55:	72 19                	jb     803b70 <__udivdi3+0xfc>
  803b57:	74 0b                	je     803b64 <__udivdi3+0xf0>
  803b59:	89 d8                	mov    %ebx,%eax
  803b5b:	31 ff                	xor    %edi,%edi
  803b5d:	e9 58 ff ff ff       	jmp    803aba <__udivdi3+0x46>
  803b62:	66 90                	xchg   %ax,%ax
  803b64:	8b 54 24 08          	mov    0x8(%esp),%edx
  803b68:	89 f9                	mov    %edi,%ecx
  803b6a:	d3 e2                	shl    %cl,%edx
  803b6c:	39 c2                	cmp    %eax,%edx
  803b6e:	73 e9                	jae    803b59 <__udivdi3+0xe5>
  803b70:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803b73:	31 ff                	xor    %edi,%edi
  803b75:	e9 40 ff ff ff       	jmp    803aba <__udivdi3+0x46>
  803b7a:	66 90                	xchg   %ax,%ax
  803b7c:	31 c0                	xor    %eax,%eax
  803b7e:	e9 37 ff ff ff       	jmp    803aba <__udivdi3+0x46>
  803b83:	90                   	nop

00803b84 <__umoddi3>:
  803b84:	55                   	push   %ebp
  803b85:	57                   	push   %edi
  803b86:	56                   	push   %esi
  803b87:	53                   	push   %ebx
  803b88:	83 ec 1c             	sub    $0x1c,%esp
  803b8b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803b8f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803b93:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b97:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803b9b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803b9f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803ba3:	89 f3                	mov    %esi,%ebx
  803ba5:	89 fa                	mov    %edi,%edx
  803ba7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803bab:	89 34 24             	mov    %esi,(%esp)
  803bae:	85 c0                	test   %eax,%eax
  803bb0:	75 1a                	jne    803bcc <__umoddi3+0x48>
  803bb2:	39 f7                	cmp    %esi,%edi
  803bb4:	0f 86 a2 00 00 00    	jbe    803c5c <__umoddi3+0xd8>
  803bba:	89 c8                	mov    %ecx,%eax
  803bbc:	89 f2                	mov    %esi,%edx
  803bbe:	f7 f7                	div    %edi
  803bc0:	89 d0                	mov    %edx,%eax
  803bc2:	31 d2                	xor    %edx,%edx
  803bc4:	83 c4 1c             	add    $0x1c,%esp
  803bc7:	5b                   	pop    %ebx
  803bc8:	5e                   	pop    %esi
  803bc9:	5f                   	pop    %edi
  803bca:	5d                   	pop    %ebp
  803bcb:	c3                   	ret    
  803bcc:	39 f0                	cmp    %esi,%eax
  803bce:	0f 87 ac 00 00 00    	ja     803c80 <__umoddi3+0xfc>
  803bd4:	0f bd e8             	bsr    %eax,%ebp
  803bd7:	83 f5 1f             	xor    $0x1f,%ebp
  803bda:	0f 84 ac 00 00 00    	je     803c8c <__umoddi3+0x108>
  803be0:	bf 20 00 00 00       	mov    $0x20,%edi
  803be5:	29 ef                	sub    %ebp,%edi
  803be7:	89 fe                	mov    %edi,%esi
  803be9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803bed:	89 e9                	mov    %ebp,%ecx
  803bef:	d3 e0                	shl    %cl,%eax
  803bf1:	89 d7                	mov    %edx,%edi
  803bf3:	89 f1                	mov    %esi,%ecx
  803bf5:	d3 ef                	shr    %cl,%edi
  803bf7:	09 c7                	or     %eax,%edi
  803bf9:	89 e9                	mov    %ebp,%ecx
  803bfb:	d3 e2                	shl    %cl,%edx
  803bfd:	89 14 24             	mov    %edx,(%esp)
  803c00:	89 d8                	mov    %ebx,%eax
  803c02:	d3 e0                	shl    %cl,%eax
  803c04:	89 c2                	mov    %eax,%edx
  803c06:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c0a:	d3 e0                	shl    %cl,%eax
  803c0c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803c10:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c14:	89 f1                	mov    %esi,%ecx
  803c16:	d3 e8                	shr    %cl,%eax
  803c18:	09 d0                	or     %edx,%eax
  803c1a:	d3 eb                	shr    %cl,%ebx
  803c1c:	89 da                	mov    %ebx,%edx
  803c1e:	f7 f7                	div    %edi
  803c20:	89 d3                	mov    %edx,%ebx
  803c22:	f7 24 24             	mull   (%esp)
  803c25:	89 c6                	mov    %eax,%esi
  803c27:	89 d1                	mov    %edx,%ecx
  803c29:	39 d3                	cmp    %edx,%ebx
  803c2b:	0f 82 87 00 00 00    	jb     803cb8 <__umoddi3+0x134>
  803c31:	0f 84 91 00 00 00    	je     803cc8 <__umoddi3+0x144>
  803c37:	8b 54 24 04          	mov    0x4(%esp),%edx
  803c3b:	29 f2                	sub    %esi,%edx
  803c3d:	19 cb                	sbb    %ecx,%ebx
  803c3f:	89 d8                	mov    %ebx,%eax
  803c41:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803c45:	d3 e0                	shl    %cl,%eax
  803c47:	89 e9                	mov    %ebp,%ecx
  803c49:	d3 ea                	shr    %cl,%edx
  803c4b:	09 d0                	or     %edx,%eax
  803c4d:	89 e9                	mov    %ebp,%ecx
  803c4f:	d3 eb                	shr    %cl,%ebx
  803c51:	89 da                	mov    %ebx,%edx
  803c53:	83 c4 1c             	add    $0x1c,%esp
  803c56:	5b                   	pop    %ebx
  803c57:	5e                   	pop    %esi
  803c58:	5f                   	pop    %edi
  803c59:	5d                   	pop    %ebp
  803c5a:	c3                   	ret    
  803c5b:	90                   	nop
  803c5c:	89 fd                	mov    %edi,%ebp
  803c5e:	85 ff                	test   %edi,%edi
  803c60:	75 0b                	jne    803c6d <__umoddi3+0xe9>
  803c62:	b8 01 00 00 00       	mov    $0x1,%eax
  803c67:	31 d2                	xor    %edx,%edx
  803c69:	f7 f7                	div    %edi
  803c6b:	89 c5                	mov    %eax,%ebp
  803c6d:	89 f0                	mov    %esi,%eax
  803c6f:	31 d2                	xor    %edx,%edx
  803c71:	f7 f5                	div    %ebp
  803c73:	89 c8                	mov    %ecx,%eax
  803c75:	f7 f5                	div    %ebp
  803c77:	89 d0                	mov    %edx,%eax
  803c79:	e9 44 ff ff ff       	jmp    803bc2 <__umoddi3+0x3e>
  803c7e:	66 90                	xchg   %ax,%ax
  803c80:	89 c8                	mov    %ecx,%eax
  803c82:	89 f2                	mov    %esi,%edx
  803c84:	83 c4 1c             	add    $0x1c,%esp
  803c87:	5b                   	pop    %ebx
  803c88:	5e                   	pop    %esi
  803c89:	5f                   	pop    %edi
  803c8a:	5d                   	pop    %ebp
  803c8b:	c3                   	ret    
  803c8c:	3b 04 24             	cmp    (%esp),%eax
  803c8f:	72 06                	jb     803c97 <__umoddi3+0x113>
  803c91:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803c95:	77 0f                	ja     803ca6 <__umoddi3+0x122>
  803c97:	89 f2                	mov    %esi,%edx
  803c99:	29 f9                	sub    %edi,%ecx
  803c9b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803c9f:	89 14 24             	mov    %edx,(%esp)
  803ca2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803ca6:	8b 44 24 04          	mov    0x4(%esp),%eax
  803caa:	8b 14 24             	mov    (%esp),%edx
  803cad:	83 c4 1c             	add    $0x1c,%esp
  803cb0:	5b                   	pop    %ebx
  803cb1:	5e                   	pop    %esi
  803cb2:	5f                   	pop    %edi
  803cb3:	5d                   	pop    %ebp
  803cb4:	c3                   	ret    
  803cb5:	8d 76 00             	lea    0x0(%esi),%esi
  803cb8:	2b 04 24             	sub    (%esp),%eax
  803cbb:	19 fa                	sbb    %edi,%edx
  803cbd:	89 d1                	mov    %edx,%ecx
  803cbf:	89 c6                	mov    %eax,%esi
  803cc1:	e9 71 ff ff ff       	jmp    803c37 <__umoddi3+0xb3>
  803cc6:	66 90                	xchg   %ax,%ax
  803cc8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803ccc:	72 ea                	jb     803cb8 <__umoddi3+0x134>
  803cce:	89 d9                	mov    %ebx,%ecx
  803cd0:	e9 62 ff ff ff       	jmp    803c37 <__umoddi3+0xb3>
