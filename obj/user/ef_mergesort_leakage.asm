
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
  80004b:	e8 92 1e 00 00       	call   801ee2 <sys_disable_interrupt>

		cprintf("\n");
  800050:	83 ec 0c             	sub    $0xc,%esp
  800053:	68 20 3c 80 00       	push   $0x803c20
  800058:	e8 63 0b 00 00       	call   800bc0 <cprintf>
  80005d:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800060:	83 ec 0c             	sub    $0xc,%esp
  800063:	68 22 3c 80 00       	push   $0x803c22
  800068:	e8 53 0b 00 00       	call   800bc0 <cprintf>
  80006d:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!! MERGE SORT !!!!\n");
  800070:	83 ec 0c             	sub    $0xc,%esp
  800073:	68 38 3c 80 00       	push   $0x803c38
  800078:	e8 43 0b 00 00       	call   800bc0 <cprintf>
  80007d:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800080:	83 ec 0c             	sub    $0xc,%esp
  800083:	68 22 3c 80 00       	push   $0x803c22
  800088:	e8 33 0b 00 00       	call   800bc0 <cprintf>
  80008d:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800090:	83 ec 0c             	sub    $0xc,%esp
  800093:	68 20 3c 80 00       	push   $0x803c20
  800098:	e8 23 0b 00 00       	call   800bc0 <cprintf>
  80009d:	83 c4 10             	add    $0x10,%esp
		cprintf("Enter the number of elements: ");
  8000a0:	83 ec 0c             	sub    $0xc,%esp
  8000a3:	68 50 3c 80 00       	push   $0x803c50
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
  8000d2:	68 6f 3c 80 00       	push   $0x803c6f
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
  8000f7:	68 74 3c 80 00       	push   $0x803c74
  8000fc:	e8 bf 0a 00 00       	call   800bc0 <cprintf>
  800101:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  800104:	83 ec 0c             	sub    $0xc,%esp
  800107:	68 96 3c 80 00       	push   $0x803c96
  80010c:	e8 af 0a 00 00       	call   800bc0 <cprintf>
  800111:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  800114:	83 ec 0c             	sub    $0xc,%esp
  800117:	68 a4 3c 80 00       	push   $0x803ca4
  80011c:	e8 9f 0a 00 00       	call   800bc0 <cprintf>
  800121:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  800124:	83 ec 0c             	sub    $0xc,%esp
  800127:	68 b3 3c 80 00       	push   $0x803cb3
  80012c:	e8 8f 0a 00 00       	call   800bc0 <cprintf>
  800131:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  800134:	83 ec 0c             	sub    $0xc,%esp
  800137:	68 c3 3c 80 00       	push   $0x803cc3
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
  800189:	e8 6e 1d 00 00       	call   801efc <sys_enable_interrupt>

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
  8001fe:	e8 df 1c 00 00       	call   801ee2 <sys_disable_interrupt>
		cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  800203:	83 ec 0c             	sub    $0xc,%esp
  800206:	68 cc 3c 80 00       	push   $0x803ccc
  80020b:	e8 b0 09 00 00       	call   800bc0 <cprintf>
  800210:	83 c4 10             	add    $0x10,%esp
		//PrintElements(Elements, NumOfElements);
		sys_enable_interrupt();
  800213:	e8 e4 1c 00 00       	call   801efc <sys_enable_interrupt>

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
  800235:	68 00 3d 80 00       	push   $0x803d00
  80023a:	6a 58                	push   $0x58
  80023c:	68 22 3d 80 00       	push   $0x803d22
  800241:	e8 c6 06 00 00       	call   80090c <_panic>
		else
		{
			sys_disable_interrupt();
  800246:	e8 97 1c 00 00       	call   801ee2 <sys_disable_interrupt>
			cprintf("===============================================\n") ;
  80024b:	83 ec 0c             	sub    $0xc,%esp
  80024e:	68 40 3d 80 00       	push   $0x803d40
  800253:	e8 68 09 00 00       	call   800bc0 <cprintf>
  800258:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  80025b:	83 ec 0c             	sub    $0xc,%esp
  80025e:	68 74 3d 80 00       	push   $0x803d74
  800263:	e8 58 09 00 00       	call   800bc0 <cprintf>
  800268:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  80026b:	83 ec 0c             	sub    $0xc,%esp
  80026e:	68 a8 3d 80 00       	push   $0x803da8
  800273:	e8 48 09 00 00       	call   800bc0 <cprintf>
  800278:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  80027b:	e8 7c 1c 00 00       	call   801efc <sys_enable_interrupt>
		}

		//free(Elements) ;

		sys_disable_interrupt();
  800280:	e8 5d 1c 00 00       	call   801ee2 <sys_disable_interrupt>
		Chose = 0 ;
  800285:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
		while (Chose != 'y' && Chose != 'n')
  800289:	eb 50                	jmp    8002db <_main+0x2a3>
		{
			cprintf("Do you want to repeat (y/n): ") ;
  80028b:	83 ec 0c             	sub    $0xc,%esp
  80028e:	68 da 3d 80 00       	push   $0x803dda
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
  8002e7:	e8 10 1c 00 00       	call   801efc <sys_enable_interrupt>

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
  80047b:	68 20 3c 80 00       	push   $0x803c20
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
  80049d:	68 f8 3d 80 00       	push   $0x803df8
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
  8004cb:	68 6f 3c 80 00       	push   $0x803c6f
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
  800744:	e8 cd 17 00 00       	call   801f16 <sys_cputc>
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
  800755:	e8 88 17 00 00       	call   801ee2 <sys_disable_interrupt>
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
  800768:	e8 a9 17 00 00       	call   801f16 <sys_cputc>
  80076d:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800770:	e8 87 17 00 00       	call   801efc <sys_enable_interrupt>
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
  800787:	e8 d1 15 00 00       	call   801d5d <sys_cgetc>
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
  8007a0:	e8 3d 17 00 00       	call   801ee2 <sys_disable_interrupt>
	int c=0;
  8007a5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8007ac:	eb 08                	jmp    8007b6 <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  8007ae:	e8 aa 15 00 00       	call   801d5d <sys_cgetc>
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
  8007bc:	e8 3b 17 00 00       	call   801efc <sys_enable_interrupt>
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
  8007d6:	e8 fa 18 00 00       	call   8020d5 <sys_getenvindex>
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
  800841:	e8 9c 16 00 00       	call   801ee2 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800846:	83 ec 0c             	sub    $0xc,%esp
  800849:	68 18 3e 80 00       	push   $0x803e18
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
  800871:	68 40 3e 80 00       	push   $0x803e40
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
  8008a2:	68 68 3e 80 00       	push   $0x803e68
  8008a7:	e8 14 03 00 00       	call   800bc0 <cprintf>
  8008ac:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8008af:	a1 24 50 80 00       	mov    0x805024,%eax
  8008b4:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8008ba:	83 ec 08             	sub    $0x8,%esp
  8008bd:	50                   	push   %eax
  8008be:	68 c0 3e 80 00       	push   $0x803ec0
  8008c3:	e8 f8 02 00 00       	call   800bc0 <cprintf>
  8008c8:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8008cb:	83 ec 0c             	sub    $0xc,%esp
  8008ce:	68 18 3e 80 00       	push   $0x803e18
  8008d3:	e8 e8 02 00 00       	call   800bc0 <cprintf>
  8008d8:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8008db:	e8 1c 16 00 00       	call   801efc <sys_enable_interrupt>

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
  8008f3:	e8 a9 17 00 00       	call   8020a1 <sys_destroy_env>
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
  800904:	e8 fe 17 00 00       	call   802107 <sys_exit_env>
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
  80092d:	68 d4 3e 80 00       	push   $0x803ed4
  800932:	e8 89 02 00 00       	call   800bc0 <cprintf>
  800937:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80093a:	a1 00 50 80 00       	mov    0x805000,%eax
  80093f:	ff 75 0c             	pushl  0xc(%ebp)
  800942:	ff 75 08             	pushl  0x8(%ebp)
  800945:	50                   	push   %eax
  800946:	68 d9 3e 80 00       	push   $0x803ed9
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
  80096a:	68 f5 3e 80 00       	push   $0x803ef5
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
  800996:	68 f8 3e 80 00       	push   $0x803ef8
  80099b:	6a 26                	push   $0x26
  80099d:	68 44 3f 80 00       	push   $0x803f44
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
  800a68:	68 50 3f 80 00       	push   $0x803f50
  800a6d:	6a 3a                	push   $0x3a
  800a6f:	68 44 3f 80 00       	push   $0x803f44
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
  800ad8:	68 a4 3f 80 00       	push   $0x803fa4
  800add:	6a 44                	push   $0x44
  800adf:	68 44 3f 80 00       	push   $0x803f44
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
  800b32:	e8 fd 11 00 00       	call   801d34 <sys_cputs>
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
  800ba9:	e8 86 11 00 00       	call   801d34 <sys_cputs>
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
  800bf3:	e8 ea 12 00 00       	call   801ee2 <sys_disable_interrupt>
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
  800c13:	e8 e4 12 00 00       	call   801efc <sys_enable_interrupt>
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
  800c5d:	e8 56 2d 00 00       	call   8039b8 <__udivdi3>
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
  800cad:	e8 16 2e 00 00       	call   803ac8 <__umoddi3>
  800cb2:	83 c4 10             	add    $0x10,%esp
  800cb5:	05 14 42 80 00       	add    $0x804214,%eax
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
  800e08:	8b 04 85 38 42 80 00 	mov    0x804238(,%eax,4),%eax
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
  800ee9:	8b 34 9d 80 40 80 00 	mov    0x804080(,%ebx,4),%esi
  800ef0:	85 f6                	test   %esi,%esi
  800ef2:	75 19                	jne    800f0d <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ef4:	53                   	push   %ebx
  800ef5:	68 25 42 80 00       	push   $0x804225
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
  800f0e:	68 2e 42 80 00       	push   $0x80422e
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
  800f3b:	be 31 42 80 00       	mov    $0x804231,%esi
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
  801961:	68 90 43 80 00       	push   $0x804390
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
  801a31:	e8 42 04 00 00       	call   801e78 <sys_allocate_chunk>
  801a36:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801a39:	a1 20 51 80 00       	mov    0x805120,%eax
  801a3e:	83 ec 0c             	sub    $0xc,%esp
  801a41:	50                   	push   %eax
  801a42:	e8 b7 0a 00 00       	call   8024fe <initialize_MemBlocksList>
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
  801a6f:	68 b5 43 80 00       	push   $0x8043b5
  801a74:	6a 33                	push   $0x33
  801a76:	68 d3 43 80 00       	push   $0x8043d3
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
  801aee:	68 e0 43 80 00       	push   $0x8043e0
  801af3:	6a 34                	push   $0x34
  801af5:	68 d3 43 80 00       	push   $0x8043d3
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
  801b63:	68 04 44 80 00       	push   $0x804404
  801b68:	6a 46                	push   $0x46
  801b6a:	68 d3 43 80 00       	push   $0x8043d3
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
  801b7f:	68 2c 44 80 00       	push   $0x80442c
  801b84:	6a 61                	push   $0x61
  801b86:	68 d3 43 80 00       	push   $0x8043d3
  801b8b:	e8 7c ed ff ff       	call   80090c <_panic>

00801b90 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801b90:	55                   	push   %ebp
  801b91:	89 e5                	mov    %esp,%ebp
  801b93:	83 ec 38             	sub    $0x38,%esp
  801b96:	8b 45 10             	mov    0x10(%ebp),%eax
  801b99:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801b9c:	e8 a9 fd ff ff       	call   80194a <InitializeUHeap>
	if (size == 0) return NULL ;
  801ba1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801ba5:	75 0a                	jne    801bb1 <smalloc+0x21>
  801ba7:	b8 00 00 00 00       	mov    $0x0,%eax
  801bac:	e9 9e 00 00 00       	jmp    801c4f <smalloc+0xbf>
	//3-If the Kernel successfully creates the shared variable, return its virtual address
	//4-Else, return NULL



	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801bb1:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801bb8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bbe:	01 d0                	add    %edx,%eax
  801bc0:	48                   	dec    %eax
  801bc1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801bc4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bc7:	ba 00 00 00 00       	mov    $0x0,%edx
  801bcc:	f7 75 f0             	divl   -0x10(%ebp)
  801bcf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bd2:	29 d0                	sub    %edx,%eax
  801bd4:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801bd7:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801bde:	e8 63 06 00 00       	call   802246 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801be3:	85 c0                	test   %eax,%eax
  801be5:	74 11                	je     801bf8 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  801be7:	83 ec 0c             	sub    $0xc,%esp
  801bea:	ff 75 e8             	pushl  -0x18(%ebp)
  801bed:	e8 ce 0c 00 00       	call   8028c0 <alloc_block_FF>
  801bf2:	83 c4 10             	add    $0x10,%esp
  801bf5:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  801bf8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801bfc:	74 4c                	je     801c4a <smalloc+0xba>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801bfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c01:	8b 40 08             	mov    0x8(%eax),%eax
  801c04:	89 c2                	mov    %eax,%edx
  801c06:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801c0a:	52                   	push   %edx
  801c0b:	50                   	push   %eax
  801c0c:	ff 75 0c             	pushl  0xc(%ebp)
  801c0f:	ff 75 08             	pushl  0x8(%ebp)
  801c12:	e8 b4 03 00 00       	call   801fcb <sys_createSharedObject>
  801c17:	83 c4 10             	add    $0x10,%esp
  801c1a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cprintf("Output is :  %d \n" , result);
  801c1d:	83 ec 08             	sub    $0x8,%esp
  801c20:	ff 75 e0             	pushl  -0x20(%ebp)
  801c23:	68 4f 44 80 00       	push   $0x80444f
  801c28:	e8 93 ef ff ff       	call   800bc0 <cprintf>
  801c2d:	83 c4 10             	add    $0x10,%esp
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  801c30:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  801c34:	74 14                	je     801c4a <smalloc+0xba>
  801c36:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  801c3a:	74 0e                	je     801c4a <smalloc+0xba>
  801c3c:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  801c40:	74 08                	je     801c4a <smalloc+0xba>
			return (void*) mem_block->sva;
  801c42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c45:	8b 40 08             	mov    0x8(%eax),%eax
  801c48:	eb 05                	jmp    801c4f <smalloc+0xbf>
	}
	return NULL;
  801c4a:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801c4f:	c9                   	leave  
  801c50:	c3                   	ret    

00801c51 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801c51:	55                   	push   %ebp
  801c52:	89 e5                	mov    %esp,%ebp
  801c54:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801c57:	e8 ee fc ff ff       	call   80194a <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801c5c:	83 ec 04             	sub    $0x4,%esp
  801c5f:	68 64 44 80 00       	push   $0x804464
  801c64:	68 ab 00 00 00       	push   $0xab
  801c69:	68 d3 43 80 00       	push   $0x8043d3
  801c6e:	e8 99 ec ff ff       	call   80090c <_panic>

00801c73 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801c73:	55                   	push   %ebp
  801c74:	89 e5                	mov    %esp,%ebp
  801c76:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801c79:	e8 cc fc ff ff       	call   80194a <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801c7e:	83 ec 04             	sub    $0x4,%esp
  801c81:	68 88 44 80 00       	push   $0x804488
  801c86:	68 ef 00 00 00       	push   $0xef
  801c8b:	68 d3 43 80 00       	push   $0x8043d3
  801c90:	e8 77 ec ff ff       	call   80090c <_panic>

00801c95 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801c95:	55                   	push   %ebp
  801c96:	89 e5                	mov    %esp,%ebp
  801c98:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801c9b:	83 ec 04             	sub    $0x4,%esp
  801c9e:	68 b0 44 80 00       	push   $0x8044b0
  801ca3:	68 03 01 00 00       	push   $0x103
  801ca8:	68 d3 43 80 00       	push   $0x8043d3
  801cad:	e8 5a ec ff ff       	call   80090c <_panic>

00801cb2 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801cb2:	55                   	push   %ebp
  801cb3:	89 e5                	mov    %esp,%ebp
  801cb5:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801cb8:	83 ec 04             	sub    $0x4,%esp
  801cbb:	68 d4 44 80 00       	push   $0x8044d4
  801cc0:	68 0e 01 00 00       	push   $0x10e
  801cc5:	68 d3 43 80 00       	push   $0x8043d3
  801cca:	e8 3d ec ff ff       	call   80090c <_panic>

00801ccf <shrink>:

}
void shrink(uint32 newSize)
{
  801ccf:	55                   	push   %ebp
  801cd0:	89 e5                	mov    %esp,%ebp
  801cd2:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801cd5:	83 ec 04             	sub    $0x4,%esp
  801cd8:	68 d4 44 80 00       	push   $0x8044d4
  801cdd:	68 13 01 00 00       	push   $0x113
  801ce2:	68 d3 43 80 00       	push   $0x8043d3
  801ce7:	e8 20 ec ff ff       	call   80090c <_panic>

00801cec <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801cec:	55                   	push   %ebp
  801ced:	89 e5                	mov    %esp,%ebp
  801cef:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801cf2:	83 ec 04             	sub    $0x4,%esp
  801cf5:	68 d4 44 80 00       	push   $0x8044d4
  801cfa:	68 18 01 00 00       	push   $0x118
  801cff:	68 d3 43 80 00       	push   $0x8043d3
  801d04:	e8 03 ec ff ff       	call   80090c <_panic>

00801d09 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801d09:	55                   	push   %ebp
  801d0a:	89 e5                	mov    %esp,%ebp
  801d0c:	57                   	push   %edi
  801d0d:	56                   	push   %esi
  801d0e:	53                   	push   %ebx
  801d0f:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801d12:	8b 45 08             	mov    0x8(%ebp),%eax
  801d15:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d18:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d1b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d1e:	8b 7d 18             	mov    0x18(%ebp),%edi
  801d21:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801d24:	cd 30                	int    $0x30
  801d26:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801d29:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801d2c:	83 c4 10             	add    $0x10,%esp
  801d2f:	5b                   	pop    %ebx
  801d30:	5e                   	pop    %esi
  801d31:	5f                   	pop    %edi
  801d32:	5d                   	pop    %ebp
  801d33:	c3                   	ret    

00801d34 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801d34:	55                   	push   %ebp
  801d35:	89 e5                	mov    %esp,%ebp
  801d37:	83 ec 04             	sub    $0x4,%esp
  801d3a:	8b 45 10             	mov    0x10(%ebp),%eax
  801d3d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801d40:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d44:	8b 45 08             	mov    0x8(%ebp),%eax
  801d47:	6a 00                	push   $0x0
  801d49:	6a 00                	push   $0x0
  801d4b:	52                   	push   %edx
  801d4c:	ff 75 0c             	pushl  0xc(%ebp)
  801d4f:	50                   	push   %eax
  801d50:	6a 00                	push   $0x0
  801d52:	e8 b2 ff ff ff       	call   801d09 <syscall>
  801d57:	83 c4 18             	add    $0x18,%esp
}
  801d5a:	90                   	nop
  801d5b:	c9                   	leave  
  801d5c:	c3                   	ret    

00801d5d <sys_cgetc>:

int
sys_cgetc(void)
{
  801d5d:	55                   	push   %ebp
  801d5e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801d60:	6a 00                	push   $0x0
  801d62:	6a 00                	push   $0x0
  801d64:	6a 00                	push   $0x0
  801d66:	6a 00                	push   $0x0
  801d68:	6a 00                	push   $0x0
  801d6a:	6a 01                	push   $0x1
  801d6c:	e8 98 ff ff ff       	call   801d09 <syscall>
  801d71:	83 c4 18             	add    $0x18,%esp
}
  801d74:	c9                   	leave  
  801d75:	c3                   	ret    

00801d76 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801d76:	55                   	push   %ebp
  801d77:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801d79:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7f:	6a 00                	push   $0x0
  801d81:	6a 00                	push   $0x0
  801d83:	6a 00                	push   $0x0
  801d85:	52                   	push   %edx
  801d86:	50                   	push   %eax
  801d87:	6a 05                	push   $0x5
  801d89:	e8 7b ff ff ff       	call   801d09 <syscall>
  801d8e:	83 c4 18             	add    $0x18,%esp
}
  801d91:	c9                   	leave  
  801d92:	c3                   	ret    

00801d93 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801d93:	55                   	push   %ebp
  801d94:	89 e5                	mov    %esp,%ebp
  801d96:	56                   	push   %esi
  801d97:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801d98:	8b 75 18             	mov    0x18(%ebp),%esi
  801d9b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d9e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801da1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801da4:	8b 45 08             	mov    0x8(%ebp),%eax
  801da7:	56                   	push   %esi
  801da8:	53                   	push   %ebx
  801da9:	51                   	push   %ecx
  801daa:	52                   	push   %edx
  801dab:	50                   	push   %eax
  801dac:	6a 06                	push   $0x6
  801dae:	e8 56 ff ff ff       	call   801d09 <syscall>
  801db3:	83 c4 18             	add    $0x18,%esp
}
  801db6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801db9:	5b                   	pop    %ebx
  801dba:	5e                   	pop    %esi
  801dbb:	5d                   	pop    %ebp
  801dbc:	c3                   	ret    

00801dbd <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801dbd:	55                   	push   %ebp
  801dbe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801dc0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc6:	6a 00                	push   $0x0
  801dc8:	6a 00                	push   $0x0
  801dca:	6a 00                	push   $0x0
  801dcc:	52                   	push   %edx
  801dcd:	50                   	push   %eax
  801dce:	6a 07                	push   $0x7
  801dd0:	e8 34 ff ff ff       	call   801d09 <syscall>
  801dd5:	83 c4 18             	add    $0x18,%esp
}
  801dd8:	c9                   	leave  
  801dd9:	c3                   	ret    

00801dda <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801dda:	55                   	push   %ebp
  801ddb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801ddd:	6a 00                	push   $0x0
  801ddf:	6a 00                	push   $0x0
  801de1:	6a 00                	push   $0x0
  801de3:	ff 75 0c             	pushl  0xc(%ebp)
  801de6:	ff 75 08             	pushl  0x8(%ebp)
  801de9:	6a 08                	push   $0x8
  801deb:	e8 19 ff ff ff       	call   801d09 <syscall>
  801df0:	83 c4 18             	add    $0x18,%esp
}
  801df3:	c9                   	leave  
  801df4:	c3                   	ret    

00801df5 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801df5:	55                   	push   %ebp
  801df6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801df8:	6a 00                	push   $0x0
  801dfa:	6a 00                	push   $0x0
  801dfc:	6a 00                	push   $0x0
  801dfe:	6a 00                	push   $0x0
  801e00:	6a 00                	push   $0x0
  801e02:	6a 09                	push   $0x9
  801e04:	e8 00 ff ff ff       	call   801d09 <syscall>
  801e09:	83 c4 18             	add    $0x18,%esp
}
  801e0c:	c9                   	leave  
  801e0d:	c3                   	ret    

00801e0e <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801e0e:	55                   	push   %ebp
  801e0f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801e11:	6a 00                	push   $0x0
  801e13:	6a 00                	push   $0x0
  801e15:	6a 00                	push   $0x0
  801e17:	6a 00                	push   $0x0
  801e19:	6a 00                	push   $0x0
  801e1b:	6a 0a                	push   $0xa
  801e1d:	e8 e7 fe ff ff       	call   801d09 <syscall>
  801e22:	83 c4 18             	add    $0x18,%esp
}
  801e25:	c9                   	leave  
  801e26:	c3                   	ret    

00801e27 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801e27:	55                   	push   %ebp
  801e28:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801e2a:	6a 00                	push   $0x0
  801e2c:	6a 00                	push   $0x0
  801e2e:	6a 00                	push   $0x0
  801e30:	6a 00                	push   $0x0
  801e32:	6a 00                	push   $0x0
  801e34:	6a 0b                	push   $0xb
  801e36:	e8 ce fe ff ff       	call   801d09 <syscall>
  801e3b:	83 c4 18             	add    $0x18,%esp
}
  801e3e:	c9                   	leave  
  801e3f:	c3                   	ret    

00801e40 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801e40:	55                   	push   %ebp
  801e41:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801e43:	6a 00                	push   $0x0
  801e45:	6a 00                	push   $0x0
  801e47:	6a 00                	push   $0x0
  801e49:	ff 75 0c             	pushl  0xc(%ebp)
  801e4c:	ff 75 08             	pushl  0x8(%ebp)
  801e4f:	6a 0f                	push   $0xf
  801e51:	e8 b3 fe ff ff       	call   801d09 <syscall>
  801e56:	83 c4 18             	add    $0x18,%esp
	return;
  801e59:	90                   	nop
}
  801e5a:	c9                   	leave  
  801e5b:	c3                   	ret    

00801e5c <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801e5c:	55                   	push   %ebp
  801e5d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801e5f:	6a 00                	push   $0x0
  801e61:	6a 00                	push   $0x0
  801e63:	6a 00                	push   $0x0
  801e65:	ff 75 0c             	pushl  0xc(%ebp)
  801e68:	ff 75 08             	pushl  0x8(%ebp)
  801e6b:	6a 10                	push   $0x10
  801e6d:	e8 97 fe ff ff       	call   801d09 <syscall>
  801e72:	83 c4 18             	add    $0x18,%esp
	return ;
  801e75:	90                   	nop
}
  801e76:	c9                   	leave  
  801e77:	c3                   	ret    

00801e78 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801e78:	55                   	push   %ebp
  801e79:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801e7b:	6a 00                	push   $0x0
  801e7d:	6a 00                	push   $0x0
  801e7f:	ff 75 10             	pushl  0x10(%ebp)
  801e82:	ff 75 0c             	pushl  0xc(%ebp)
  801e85:	ff 75 08             	pushl  0x8(%ebp)
  801e88:	6a 11                	push   $0x11
  801e8a:	e8 7a fe ff ff       	call   801d09 <syscall>
  801e8f:	83 c4 18             	add    $0x18,%esp
	return ;
  801e92:	90                   	nop
}
  801e93:	c9                   	leave  
  801e94:	c3                   	ret    

00801e95 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801e95:	55                   	push   %ebp
  801e96:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801e98:	6a 00                	push   $0x0
  801e9a:	6a 00                	push   $0x0
  801e9c:	6a 00                	push   $0x0
  801e9e:	6a 00                	push   $0x0
  801ea0:	6a 00                	push   $0x0
  801ea2:	6a 0c                	push   $0xc
  801ea4:	e8 60 fe ff ff       	call   801d09 <syscall>
  801ea9:	83 c4 18             	add    $0x18,%esp
}
  801eac:	c9                   	leave  
  801ead:	c3                   	ret    

00801eae <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801eae:	55                   	push   %ebp
  801eaf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801eb1:	6a 00                	push   $0x0
  801eb3:	6a 00                	push   $0x0
  801eb5:	6a 00                	push   $0x0
  801eb7:	6a 00                	push   $0x0
  801eb9:	ff 75 08             	pushl  0x8(%ebp)
  801ebc:	6a 0d                	push   $0xd
  801ebe:	e8 46 fe ff ff       	call   801d09 <syscall>
  801ec3:	83 c4 18             	add    $0x18,%esp
}
  801ec6:	c9                   	leave  
  801ec7:	c3                   	ret    

00801ec8 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801ec8:	55                   	push   %ebp
  801ec9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801ecb:	6a 00                	push   $0x0
  801ecd:	6a 00                	push   $0x0
  801ecf:	6a 00                	push   $0x0
  801ed1:	6a 00                	push   $0x0
  801ed3:	6a 00                	push   $0x0
  801ed5:	6a 0e                	push   $0xe
  801ed7:	e8 2d fe ff ff       	call   801d09 <syscall>
  801edc:	83 c4 18             	add    $0x18,%esp
}
  801edf:	90                   	nop
  801ee0:	c9                   	leave  
  801ee1:	c3                   	ret    

00801ee2 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801ee2:	55                   	push   %ebp
  801ee3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801ee5:	6a 00                	push   $0x0
  801ee7:	6a 00                	push   $0x0
  801ee9:	6a 00                	push   $0x0
  801eeb:	6a 00                	push   $0x0
  801eed:	6a 00                	push   $0x0
  801eef:	6a 13                	push   $0x13
  801ef1:	e8 13 fe ff ff       	call   801d09 <syscall>
  801ef6:	83 c4 18             	add    $0x18,%esp
}
  801ef9:	90                   	nop
  801efa:	c9                   	leave  
  801efb:	c3                   	ret    

00801efc <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801efc:	55                   	push   %ebp
  801efd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801eff:	6a 00                	push   $0x0
  801f01:	6a 00                	push   $0x0
  801f03:	6a 00                	push   $0x0
  801f05:	6a 00                	push   $0x0
  801f07:	6a 00                	push   $0x0
  801f09:	6a 14                	push   $0x14
  801f0b:	e8 f9 fd ff ff       	call   801d09 <syscall>
  801f10:	83 c4 18             	add    $0x18,%esp
}
  801f13:	90                   	nop
  801f14:	c9                   	leave  
  801f15:	c3                   	ret    

00801f16 <sys_cputc>:


void
sys_cputc(const char c)
{
  801f16:	55                   	push   %ebp
  801f17:	89 e5                	mov    %esp,%ebp
  801f19:	83 ec 04             	sub    $0x4,%esp
  801f1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801f22:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f26:	6a 00                	push   $0x0
  801f28:	6a 00                	push   $0x0
  801f2a:	6a 00                	push   $0x0
  801f2c:	6a 00                	push   $0x0
  801f2e:	50                   	push   %eax
  801f2f:	6a 15                	push   $0x15
  801f31:	e8 d3 fd ff ff       	call   801d09 <syscall>
  801f36:	83 c4 18             	add    $0x18,%esp
}
  801f39:	90                   	nop
  801f3a:	c9                   	leave  
  801f3b:	c3                   	ret    

00801f3c <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801f3c:	55                   	push   %ebp
  801f3d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801f3f:	6a 00                	push   $0x0
  801f41:	6a 00                	push   $0x0
  801f43:	6a 00                	push   $0x0
  801f45:	6a 00                	push   $0x0
  801f47:	6a 00                	push   $0x0
  801f49:	6a 16                	push   $0x16
  801f4b:	e8 b9 fd ff ff       	call   801d09 <syscall>
  801f50:	83 c4 18             	add    $0x18,%esp
}
  801f53:	90                   	nop
  801f54:	c9                   	leave  
  801f55:	c3                   	ret    

00801f56 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801f56:	55                   	push   %ebp
  801f57:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801f59:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5c:	6a 00                	push   $0x0
  801f5e:	6a 00                	push   $0x0
  801f60:	6a 00                	push   $0x0
  801f62:	ff 75 0c             	pushl  0xc(%ebp)
  801f65:	50                   	push   %eax
  801f66:	6a 17                	push   $0x17
  801f68:	e8 9c fd ff ff       	call   801d09 <syscall>
  801f6d:	83 c4 18             	add    $0x18,%esp
}
  801f70:	c9                   	leave  
  801f71:	c3                   	ret    

00801f72 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801f72:	55                   	push   %ebp
  801f73:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f75:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f78:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7b:	6a 00                	push   $0x0
  801f7d:	6a 00                	push   $0x0
  801f7f:	6a 00                	push   $0x0
  801f81:	52                   	push   %edx
  801f82:	50                   	push   %eax
  801f83:	6a 1a                	push   $0x1a
  801f85:	e8 7f fd ff ff       	call   801d09 <syscall>
  801f8a:	83 c4 18             	add    $0x18,%esp
}
  801f8d:	c9                   	leave  
  801f8e:	c3                   	ret    

00801f8f <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801f8f:	55                   	push   %ebp
  801f90:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f92:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f95:	8b 45 08             	mov    0x8(%ebp),%eax
  801f98:	6a 00                	push   $0x0
  801f9a:	6a 00                	push   $0x0
  801f9c:	6a 00                	push   $0x0
  801f9e:	52                   	push   %edx
  801f9f:	50                   	push   %eax
  801fa0:	6a 18                	push   $0x18
  801fa2:	e8 62 fd ff ff       	call   801d09 <syscall>
  801fa7:	83 c4 18             	add    $0x18,%esp
}
  801faa:	90                   	nop
  801fab:	c9                   	leave  
  801fac:	c3                   	ret    

00801fad <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801fad:	55                   	push   %ebp
  801fae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801fb0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb6:	6a 00                	push   $0x0
  801fb8:	6a 00                	push   $0x0
  801fba:	6a 00                	push   $0x0
  801fbc:	52                   	push   %edx
  801fbd:	50                   	push   %eax
  801fbe:	6a 19                	push   $0x19
  801fc0:	e8 44 fd ff ff       	call   801d09 <syscall>
  801fc5:	83 c4 18             	add    $0x18,%esp
}
  801fc8:	90                   	nop
  801fc9:	c9                   	leave  
  801fca:	c3                   	ret    

00801fcb <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801fcb:	55                   	push   %ebp
  801fcc:	89 e5                	mov    %esp,%ebp
  801fce:	83 ec 04             	sub    $0x4,%esp
  801fd1:	8b 45 10             	mov    0x10(%ebp),%eax
  801fd4:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801fd7:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801fda:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801fde:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe1:	6a 00                	push   $0x0
  801fe3:	51                   	push   %ecx
  801fe4:	52                   	push   %edx
  801fe5:	ff 75 0c             	pushl  0xc(%ebp)
  801fe8:	50                   	push   %eax
  801fe9:	6a 1b                	push   $0x1b
  801feb:	e8 19 fd ff ff       	call   801d09 <syscall>
  801ff0:	83 c4 18             	add    $0x18,%esp
}
  801ff3:	c9                   	leave  
  801ff4:	c3                   	ret    

00801ff5 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801ff5:	55                   	push   %ebp
  801ff6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801ff8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ffb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffe:	6a 00                	push   $0x0
  802000:	6a 00                	push   $0x0
  802002:	6a 00                	push   $0x0
  802004:	52                   	push   %edx
  802005:	50                   	push   %eax
  802006:	6a 1c                	push   $0x1c
  802008:	e8 fc fc ff ff       	call   801d09 <syscall>
  80200d:	83 c4 18             	add    $0x18,%esp
}
  802010:	c9                   	leave  
  802011:	c3                   	ret    

00802012 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802012:	55                   	push   %ebp
  802013:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802015:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802018:	8b 55 0c             	mov    0xc(%ebp),%edx
  80201b:	8b 45 08             	mov    0x8(%ebp),%eax
  80201e:	6a 00                	push   $0x0
  802020:	6a 00                	push   $0x0
  802022:	51                   	push   %ecx
  802023:	52                   	push   %edx
  802024:	50                   	push   %eax
  802025:	6a 1d                	push   $0x1d
  802027:	e8 dd fc ff ff       	call   801d09 <syscall>
  80202c:	83 c4 18             	add    $0x18,%esp
}
  80202f:	c9                   	leave  
  802030:	c3                   	ret    

00802031 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802031:	55                   	push   %ebp
  802032:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802034:	8b 55 0c             	mov    0xc(%ebp),%edx
  802037:	8b 45 08             	mov    0x8(%ebp),%eax
  80203a:	6a 00                	push   $0x0
  80203c:	6a 00                	push   $0x0
  80203e:	6a 00                	push   $0x0
  802040:	52                   	push   %edx
  802041:	50                   	push   %eax
  802042:	6a 1e                	push   $0x1e
  802044:	e8 c0 fc ff ff       	call   801d09 <syscall>
  802049:	83 c4 18             	add    $0x18,%esp
}
  80204c:	c9                   	leave  
  80204d:	c3                   	ret    

0080204e <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80204e:	55                   	push   %ebp
  80204f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802051:	6a 00                	push   $0x0
  802053:	6a 00                	push   $0x0
  802055:	6a 00                	push   $0x0
  802057:	6a 00                	push   $0x0
  802059:	6a 00                	push   $0x0
  80205b:	6a 1f                	push   $0x1f
  80205d:	e8 a7 fc ff ff       	call   801d09 <syscall>
  802062:	83 c4 18             	add    $0x18,%esp
}
  802065:	c9                   	leave  
  802066:	c3                   	ret    

00802067 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802067:	55                   	push   %ebp
  802068:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80206a:	8b 45 08             	mov    0x8(%ebp),%eax
  80206d:	6a 00                	push   $0x0
  80206f:	ff 75 14             	pushl  0x14(%ebp)
  802072:	ff 75 10             	pushl  0x10(%ebp)
  802075:	ff 75 0c             	pushl  0xc(%ebp)
  802078:	50                   	push   %eax
  802079:	6a 20                	push   $0x20
  80207b:	e8 89 fc ff ff       	call   801d09 <syscall>
  802080:	83 c4 18             	add    $0x18,%esp
}
  802083:	c9                   	leave  
  802084:	c3                   	ret    

00802085 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802085:	55                   	push   %ebp
  802086:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802088:	8b 45 08             	mov    0x8(%ebp),%eax
  80208b:	6a 00                	push   $0x0
  80208d:	6a 00                	push   $0x0
  80208f:	6a 00                	push   $0x0
  802091:	6a 00                	push   $0x0
  802093:	50                   	push   %eax
  802094:	6a 21                	push   $0x21
  802096:	e8 6e fc ff ff       	call   801d09 <syscall>
  80209b:	83 c4 18             	add    $0x18,%esp
}
  80209e:	90                   	nop
  80209f:	c9                   	leave  
  8020a0:	c3                   	ret    

008020a1 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8020a1:	55                   	push   %ebp
  8020a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8020a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a7:	6a 00                	push   $0x0
  8020a9:	6a 00                	push   $0x0
  8020ab:	6a 00                	push   $0x0
  8020ad:	6a 00                	push   $0x0
  8020af:	50                   	push   %eax
  8020b0:	6a 22                	push   $0x22
  8020b2:	e8 52 fc ff ff       	call   801d09 <syscall>
  8020b7:	83 c4 18             	add    $0x18,%esp
}
  8020ba:	c9                   	leave  
  8020bb:	c3                   	ret    

008020bc <sys_getenvid>:

int32 sys_getenvid(void)
{
  8020bc:	55                   	push   %ebp
  8020bd:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8020bf:	6a 00                	push   $0x0
  8020c1:	6a 00                	push   $0x0
  8020c3:	6a 00                	push   $0x0
  8020c5:	6a 00                	push   $0x0
  8020c7:	6a 00                	push   $0x0
  8020c9:	6a 02                	push   $0x2
  8020cb:	e8 39 fc ff ff       	call   801d09 <syscall>
  8020d0:	83 c4 18             	add    $0x18,%esp
}
  8020d3:	c9                   	leave  
  8020d4:	c3                   	ret    

008020d5 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8020d5:	55                   	push   %ebp
  8020d6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8020d8:	6a 00                	push   $0x0
  8020da:	6a 00                	push   $0x0
  8020dc:	6a 00                	push   $0x0
  8020de:	6a 00                	push   $0x0
  8020e0:	6a 00                	push   $0x0
  8020e2:	6a 03                	push   $0x3
  8020e4:	e8 20 fc ff ff       	call   801d09 <syscall>
  8020e9:	83 c4 18             	add    $0x18,%esp
}
  8020ec:	c9                   	leave  
  8020ed:	c3                   	ret    

008020ee <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8020ee:	55                   	push   %ebp
  8020ef:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8020f1:	6a 00                	push   $0x0
  8020f3:	6a 00                	push   $0x0
  8020f5:	6a 00                	push   $0x0
  8020f7:	6a 00                	push   $0x0
  8020f9:	6a 00                	push   $0x0
  8020fb:	6a 04                	push   $0x4
  8020fd:	e8 07 fc ff ff       	call   801d09 <syscall>
  802102:	83 c4 18             	add    $0x18,%esp
}
  802105:	c9                   	leave  
  802106:	c3                   	ret    

00802107 <sys_exit_env>:


void sys_exit_env(void)
{
  802107:	55                   	push   %ebp
  802108:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80210a:	6a 00                	push   $0x0
  80210c:	6a 00                	push   $0x0
  80210e:	6a 00                	push   $0x0
  802110:	6a 00                	push   $0x0
  802112:	6a 00                	push   $0x0
  802114:	6a 23                	push   $0x23
  802116:	e8 ee fb ff ff       	call   801d09 <syscall>
  80211b:	83 c4 18             	add    $0x18,%esp
}
  80211e:	90                   	nop
  80211f:	c9                   	leave  
  802120:	c3                   	ret    

00802121 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802121:	55                   	push   %ebp
  802122:	89 e5                	mov    %esp,%ebp
  802124:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802127:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80212a:	8d 50 04             	lea    0x4(%eax),%edx
  80212d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802130:	6a 00                	push   $0x0
  802132:	6a 00                	push   $0x0
  802134:	6a 00                	push   $0x0
  802136:	52                   	push   %edx
  802137:	50                   	push   %eax
  802138:	6a 24                	push   $0x24
  80213a:	e8 ca fb ff ff       	call   801d09 <syscall>
  80213f:	83 c4 18             	add    $0x18,%esp
	return result;
  802142:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802145:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802148:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80214b:	89 01                	mov    %eax,(%ecx)
  80214d:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802150:	8b 45 08             	mov    0x8(%ebp),%eax
  802153:	c9                   	leave  
  802154:	c2 04 00             	ret    $0x4

00802157 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802157:	55                   	push   %ebp
  802158:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80215a:	6a 00                	push   $0x0
  80215c:	6a 00                	push   $0x0
  80215e:	ff 75 10             	pushl  0x10(%ebp)
  802161:	ff 75 0c             	pushl  0xc(%ebp)
  802164:	ff 75 08             	pushl  0x8(%ebp)
  802167:	6a 12                	push   $0x12
  802169:	e8 9b fb ff ff       	call   801d09 <syscall>
  80216e:	83 c4 18             	add    $0x18,%esp
	return ;
  802171:	90                   	nop
}
  802172:	c9                   	leave  
  802173:	c3                   	ret    

00802174 <sys_rcr2>:
uint32 sys_rcr2()
{
  802174:	55                   	push   %ebp
  802175:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802177:	6a 00                	push   $0x0
  802179:	6a 00                	push   $0x0
  80217b:	6a 00                	push   $0x0
  80217d:	6a 00                	push   $0x0
  80217f:	6a 00                	push   $0x0
  802181:	6a 25                	push   $0x25
  802183:	e8 81 fb ff ff       	call   801d09 <syscall>
  802188:	83 c4 18             	add    $0x18,%esp
}
  80218b:	c9                   	leave  
  80218c:	c3                   	ret    

0080218d <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80218d:	55                   	push   %ebp
  80218e:	89 e5                	mov    %esp,%ebp
  802190:	83 ec 04             	sub    $0x4,%esp
  802193:	8b 45 08             	mov    0x8(%ebp),%eax
  802196:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802199:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80219d:	6a 00                	push   $0x0
  80219f:	6a 00                	push   $0x0
  8021a1:	6a 00                	push   $0x0
  8021a3:	6a 00                	push   $0x0
  8021a5:	50                   	push   %eax
  8021a6:	6a 26                	push   $0x26
  8021a8:	e8 5c fb ff ff       	call   801d09 <syscall>
  8021ad:	83 c4 18             	add    $0x18,%esp
	return ;
  8021b0:	90                   	nop
}
  8021b1:	c9                   	leave  
  8021b2:	c3                   	ret    

008021b3 <rsttst>:
void rsttst()
{
  8021b3:	55                   	push   %ebp
  8021b4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8021b6:	6a 00                	push   $0x0
  8021b8:	6a 00                	push   $0x0
  8021ba:	6a 00                	push   $0x0
  8021bc:	6a 00                	push   $0x0
  8021be:	6a 00                	push   $0x0
  8021c0:	6a 28                	push   $0x28
  8021c2:	e8 42 fb ff ff       	call   801d09 <syscall>
  8021c7:	83 c4 18             	add    $0x18,%esp
	return ;
  8021ca:	90                   	nop
}
  8021cb:	c9                   	leave  
  8021cc:	c3                   	ret    

008021cd <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8021cd:	55                   	push   %ebp
  8021ce:	89 e5                	mov    %esp,%ebp
  8021d0:	83 ec 04             	sub    $0x4,%esp
  8021d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8021d6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8021d9:	8b 55 18             	mov    0x18(%ebp),%edx
  8021dc:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8021e0:	52                   	push   %edx
  8021e1:	50                   	push   %eax
  8021e2:	ff 75 10             	pushl  0x10(%ebp)
  8021e5:	ff 75 0c             	pushl  0xc(%ebp)
  8021e8:	ff 75 08             	pushl  0x8(%ebp)
  8021eb:	6a 27                	push   $0x27
  8021ed:	e8 17 fb ff ff       	call   801d09 <syscall>
  8021f2:	83 c4 18             	add    $0x18,%esp
	return ;
  8021f5:	90                   	nop
}
  8021f6:	c9                   	leave  
  8021f7:	c3                   	ret    

008021f8 <chktst>:
void chktst(uint32 n)
{
  8021f8:	55                   	push   %ebp
  8021f9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8021fb:	6a 00                	push   $0x0
  8021fd:	6a 00                	push   $0x0
  8021ff:	6a 00                	push   $0x0
  802201:	6a 00                	push   $0x0
  802203:	ff 75 08             	pushl  0x8(%ebp)
  802206:	6a 29                	push   $0x29
  802208:	e8 fc fa ff ff       	call   801d09 <syscall>
  80220d:	83 c4 18             	add    $0x18,%esp
	return ;
  802210:	90                   	nop
}
  802211:	c9                   	leave  
  802212:	c3                   	ret    

00802213 <inctst>:

void inctst()
{
  802213:	55                   	push   %ebp
  802214:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802216:	6a 00                	push   $0x0
  802218:	6a 00                	push   $0x0
  80221a:	6a 00                	push   $0x0
  80221c:	6a 00                	push   $0x0
  80221e:	6a 00                	push   $0x0
  802220:	6a 2a                	push   $0x2a
  802222:	e8 e2 fa ff ff       	call   801d09 <syscall>
  802227:	83 c4 18             	add    $0x18,%esp
	return ;
  80222a:	90                   	nop
}
  80222b:	c9                   	leave  
  80222c:	c3                   	ret    

0080222d <gettst>:
uint32 gettst()
{
  80222d:	55                   	push   %ebp
  80222e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802230:	6a 00                	push   $0x0
  802232:	6a 00                	push   $0x0
  802234:	6a 00                	push   $0x0
  802236:	6a 00                	push   $0x0
  802238:	6a 00                	push   $0x0
  80223a:	6a 2b                	push   $0x2b
  80223c:	e8 c8 fa ff ff       	call   801d09 <syscall>
  802241:	83 c4 18             	add    $0x18,%esp
}
  802244:	c9                   	leave  
  802245:	c3                   	ret    

00802246 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802246:	55                   	push   %ebp
  802247:	89 e5                	mov    %esp,%ebp
  802249:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80224c:	6a 00                	push   $0x0
  80224e:	6a 00                	push   $0x0
  802250:	6a 00                	push   $0x0
  802252:	6a 00                	push   $0x0
  802254:	6a 00                	push   $0x0
  802256:	6a 2c                	push   $0x2c
  802258:	e8 ac fa ff ff       	call   801d09 <syscall>
  80225d:	83 c4 18             	add    $0x18,%esp
  802260:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802263:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802267:	75 07                	jne    802270 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802269:	b8 01 00 00 00       	mov    $0x1,%eax
  80226e:	eb 05                	jmp    802275 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802270:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802275:	c9                   	leave  
  802276:	c3                   	ret    

00802277 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802277:	55                   	push   %ebp
  802278:	89 e5                	mov    %esp,%ebp
  80227a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80227d:	6a 00                	push   $0x0
  80227f:	6a 00                	push   $0x0
  802281:	6a 00                	push   $0x0
  802283:	6a 00                	push   $0x0
  802285:	6a 00                	push   $0x0
  802287:	6a 2c                	push   $0x2c
  802289:	e8 7b fa ff ff       	call   801d09 <syscall>
  80228e:	83 c4 18             	add    $0x18,%esp
  802291:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802294:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802298:	75 07                	jne    8022a1 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80229a:	b8 01 00 00 00       	mov    $0x1,%eax
  80229f:	eb 05                	jmp    8022a6 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8022a1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022a6:	c9                   	leave  
  8022a7:	c3                   	ret    

008022a8 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8022a8:	55                   	push   %ebp
  8022a9:	89 e5                	mov    %esp,%ebp
  8022ab:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8022ae:	6a 00                	push   $0x0
  8022b0:	6a 00                	push   $0x0
  8022b2:	6a 00                	push   $0x0
  8022b4:	6a 00                	push   $0x0
  8022b6:	6a 00                	push   $0x0
  8022b8:	6a 2c                	push   $0x2c
  8022ba:	e8 4a fa ff ff       	call   801d09 <syscall>
  8022bf:	83 c4 18             	add    $0x18,%esp
  8022c2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8022c5:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8022c9:	75 07                	jne    8022d2 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8022cb:	b8 01 00 00 00       	mov    $0x1,%eax
  8022d0:	eb 05                	jmp    8022d7 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8022d2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022d7:	c9                   	leave  
  8022d8:	c3                   	ret    

008022d9 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8022d9:	55                   	push   %ebp
  8022da:	89 e5                	mov    %esp,%ebp
  8022dc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8022df:	6a 00                	push   $0x0
  8022e1:	6a 00                	push   $0x0
  8022e3:	6a 00                	push   $0x0
  8022e5:	6a 00                	push   $0x0
  8022e7:	6a 00                	push   $0x0
  8022e9:	6a 2c                	push   $0x2c
  8022eb:	e8 19 fa ff ff       	call   801d09 <syscall>
  8022f0:	83 c4 18             	add    $0x18,%esp
  8022f3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8022f6:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8022fa:	75 07                	jne    802303 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8022fc:	b8 01 00 00 00       	mov    $0x1,%eax
  802301:	eb 05                	jmp    802308 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802303:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802308:	c9                   	leave  
  802309:	c3                   	ret    

0080230a <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80230a:	55                   	push   %ebp
  80230b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80230d:	6a 00                	push   $0x0
  80230f:	6a 00                	push   $0x0
  802311:	6a 00                	push   $0x0
  802313:	6a 00                	push   $0x0
  802315:	ff 75 08             	pushl  0x8(%ebp)
  802318:	6a 2d                	push   $0x2d
  80231a:	e8 ea f9 ff ff       	call   801d09 <syscall>
  80231f:	83 c4 18             	add    $0x18,%esp
	return ;
  802322:	90                   	nop
}
  802323:	c9                   	leave  
  802324:	c3                   	ret    

00802325 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802325:	55                   	push   %ebp
  802326:	89 e5                	mov    %esp,%ebp
  802328:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802329:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80232c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80232f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802332:	8b 45 08             	mov    0x8(%ebp),%eax
  802335:	6a 00                	push   $0x0
  802337:	53                   	push   %ebx
  802338:	51                   	push   %ecx
  802339:	52                   	push   %edx
  80233a:	50                   	push   %eax
  80233b:	6a 2e                	push   $0x2e
  80233d:	e8 c7 f9 ff ff       	call   801d09 <syscall>
  802342:	83 c4 18             	add    $0x18,%esp
}
  802345:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802348:	c9                   	leave  
  802349:	c3                   	ret    

0080234a <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80234a:	55                   	push   %ebp
  80234b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80234d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802350:	8b 45 08             	mov    0x8(%ebp),%eax
  802353:	6a 00                	push   $0x0
  802355:	6a 00                	push   $0x0
  802357:	6a 00                	push   $0x0
  802359:	52                   	push   %edx
  80235a:	50                   	push   %eax
  80235b:	6a 2f                	push   $0x2f
  80235d:	e8 a7 f9 ff ff       	call   801d09 <syscall>
  802362:	83 c4 18             	add    $0x18,%esp
}
  802365:	c9                   	leave  
  802366:	c3                   	ret    

00802367 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802367:	55                   	push   %ebp
  802368:	89 e5                	mov    %esp,%ebp
  80236a:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  80236d:	83 ec 0c             	sub    $0xc,%esp
  802370:	68 e4 44 80 00       	push   $0x8044e4
  802375:	e8 46 e8 ff ff       	call   800bc0 <cprintf>
  80237a:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80237d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802384:	83 ec 0c             	sub    $0xc,%esp
  802387:	68 10 45 80 00       	push   $0x804510
  80238c:	e8 2f e8 ff ff       	call   800bc0 <cprintf>
  802391:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802394:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802398:	a1 38 51 80 00       	mov    0x805138,%eax
  80239d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023a0:	eb 56                	jmp    8023f8 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8023a2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023a6:	74 1c                	je     8023c4 <print_mem_block_lists+0x5d>
  8023a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ab:	8b 50 08             	mov    0x8(%eax),%edx
  8023ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023b1:	8b 48 08             	mov    0x8(%eax),%ecx
  8023b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023b7:	8b 40 0c             	mov    0xc(%eax),%eax
  8023ba:	01 c8                	add    %ecx,%eax
  8023bc:	39 c2                	cmp    %eax,%edx
  8023be:	73 04                	jae    8023c4 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8023c0:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8023c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c7:	8b 50 08             	mov    0x8(%eax),%edx
  8023ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023cd:	8b 40 0c             	mov    0xc(%eax),%eax
  8023d0:	01 c2                	add    %eax,%edx
  8023d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d5:	8b 40 08             	mov    0x8(%eax),%eax
  8023d8:	83 ec 04             	sub    $0x4,%esp
  8023db:	52                   	push   %edx
  8023dc:	50                   	push   %eax
  8023dd:	68 25 45 80 00       	push   $0x804525
  8023e2:	e8 d9 e7 ff ff       	call   800bc0 <cprintf>
  8023e7:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8023ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8023f0:	a1 40 51 80 00       	mov    0x805140,%eax
  8023f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023fc:	74 07                	je     802405 <print_mem_block_lists+0x9e>
  8023fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802401:	8b 00                	mov    (%eax),%eax
  802403:	eb 05                	jmp    80240a <print_mem_block_lists+0xa3>
  802405:	b8 00 00 00 00       	mov    $0x0,%eax
  80240a:	a3 40 51 80 00       	mov    %eax,0x805140
  80240f:	a1 40 51 80 00       	mov    0x805140,%eax
  802414:	85 c0                	test   %eax,%eax
  802416:	75 8a                	jne    8023a2 <print_mem_block_lists+0x3b>
  802418:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80241c:	75 84                	jne    8023a2 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  80241e:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802422:	75 10                	jne    802434 <print_mem_block_lists+0xcd>
  802424:	83 ec 0c             	sub    $0xc,%esp
  802427:	68 34 45 80 00       	push   $0x804534
  80242c:	e8 8f e7 ff ff       	call   800bc0 <cprintf>
  802431:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802434:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80243b:	83 ec 0c             	sub    $0xc,%esp
  80243e:	68 58 45 80 00       	push   $0x804558
  802443:	e8 78 e7 ff ff       	call   800bc0 <cprintf>
  802448:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80244b:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80244f:	a1 40 50 80 00       	mov    0x805040,%eax
  802454:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802457:	eb 56                	jmp    8024af <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802459:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80245d:	74 1c                	je     80247b <print_mem_block_lists+0x114>
  80245f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802462:	8b 50 08             	mov    0x8(%eax),%edx
  802465:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802468:	8b 48 08             	mov    0x8(%eax),%ecx
  80246b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80246e:	8b 40 0c             	mov    0xc(%eax),%eax
  802471:	01 c8                	add    %ecx,%eax
  802473:	39 c2                	cmp    %eax,%edx
  802475:	73 04                	jae    80247b <print_mem_block_lists+0x114>
			sorted = 0 ;
  802477:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80247b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247e:	8b 50 08             	mov    0x8(%eax),%edx
  802481:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802484:	8b 40 0c             	mov    0xc(%eax),%eax
  802487:	01 c2                	add    %eax,%edx
  802489:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248c:	8b 40 08             	mov    0x8(%eax),%eax
  80248f:	83 ec 04             	sub    $0x4,%esp
  802492:	52                   	push   %edx
  802493:	50                   	push   %eax
  802494:	68 25 45 80 00       	push   $0x804525
  802499:	e8 22 e7 ff ff       	call   800bc0 <cprintf>
  80249e:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8024a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8024a7:	a1 48 50 80 00       	mov    0x805048,%eax
  8024ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024af:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024b3:	74 07                	je     8024bc <print_mem_block_lists+0x155>
  8024b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b8:	8b 00                	mov    (%eax),%eax
  8024ba:	eb 05                	jmp    8024c1 <print_mem_block_lists+0x15a>
  8024bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8024c1:	a3 48 50 80 00       	mov    %eax,0x805048
  8024c6:	a1 48 50 80 00       	mov    0x805048,%eax
  8024cb:	85 c0                	test   %eax,%eax
  8024cd:	75 8a                	jne    802459 <print_mem_block_lists+0xf2>
  8024cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024d3:	75 84                	jne    802459 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8024d5:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8024d9:	75 10                	jne    8024eb <print_mem_block_lists+0x184>
  8024db:	83 ec 0c             	sub    $0xc,%esp
  8024de:	68 70 45 80 00       	push   $0x804570
  8024e3:	e8 d8 e6 ff ff       	call   800bc0 <cprintf>
  8024e8:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8024eb:	83 ec 0c             	sub    $0xc,%esp
  8024ee:	68 e4 44 80 00       	push   $0x8044e4
  8024f3:	e8 c8 e6 ff ff       	call   800bc0 <cprintf>
  8024f8:	83 c4 10             	add    $0x10,%esp

}
  8024fb:	90                   	nop
  8024fc:	c9                   	leave  
  8024fd:	c3                   	ret    

008024fe <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8024fe:	55                   	push   %ebp
  8024ff:	89 e5                	mov    %esp,%ebp
  802501:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  802504:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  80250b:	00 00 00 
  80250e:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802515:	00 00 00 
  802518:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  80251f:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  802522:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802529:	e9 9e 00 00 00       	jmp    8025cc <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  80252e:	a1 50 50 80 00       	mov    0x805050,%eax
  802533:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802536:	c1 e2 04             	shl    $0x4,%edx
  802539:	01 d0                	add    %edx,%eax
  80253b:	85 c0                	test   %eax,%eax
  80253d:	75 14                	jne    802553 <initialize_MemBlocksList+0x55>
  80253f:	83 ec 04             	sub    $0x4,%esp
  802542:	68 98 45 80 00       	push   $0x804598
  802547:	6a 46                	push   $0x46
  802549:	68 bb 45 80 00       	push   $0x8045bb
  80254e:	e8 b9 e3 ff ff       	call   80090c <_panic>
  802553:	a1 50 50 80 00       	mov    0x805050,%eax
  802558:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80255b:	c1 e2 04             	shl    $0x4,%edx
  80255e:	01 d0                	add    %edx,%eax
  802560:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802566:	89 10                	mov    %edx,(%eax)
  802568:	8b 00                	mov    (%eax),%eax
  80256a:	85 c0                	test   %eax,%eax
  80256c:	74 18                	je     802586 <initialize_MemBlocksList+0x88>
  80256e:	a1 48 51 80 00       	mov    0x805148,%eax
  802573:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802579:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80257c:	c1 e1 04             	shl    $0x4,%ecx
  80257f:	01 ca                	add    %ecx,%edx
  802581:	89 50 04             	mov    %edx,0x4(%eax)
  802584:	eb 12                	jmp    802598 <initialize_MemBlocksList+0x9a>
  802586:	a1 50 50 80 00       	mov    0x805050,%eax
  80258b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80258e:	c1 e2 04             	shl    $0x4,%edx
  802591:	01 d0                	add    %edx,%eax
  802593:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802598:	a1 50 50 80 00       	mov    0x805050,%eax
  80259d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025a0:	c1 e2 04             	shl    $0x4,%edx
  8025a3:	01 d0                	add    %edx,%eax
  8025a5:	a3 48 51 80 00       	mov    %eax,0x805148
  8025aa:	a1 50 50 80 00       	mov    0x805050,%eax
  8025af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025b2:	c1 e2 04             	shl    $0x4,%edx
  8025b5:	01 d0                	add    %edx,%eax
  8025b7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025be:	a1 54 51 80 00       	mov    0x805154,%eax
  8025c3:	40                   	inc    %eax
  8025c4:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  8025c9:	ff 45 f4             	incl   -0xc(%ebp)
  8025cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cf:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025d2:	0f 82 56 ff ff ff    	jb     80252e <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  8025d8:	90                   	nop
  8025d9:	c9                   	leave  
  8025da:	c3                   	ret    

008025db <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8025db:	55                   	push   %ebp
  8025dc:	89 e5                	mov    %esp,%ebp
  8025de:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8025e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e4:	8b 00                	mov    (%eax),%eax
  8025e6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8025e9:	eb 19                	jmp    802604 <find_block+0x29>
	{
		if(va==point->sva)
  8025eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025ee:	8b 40 08             	mov    0x8(%eax),%eax
  8025f1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8025f4:	75 05                	jne    8025fb <find_block+0x20>
		   return point;
  8025f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025f9:	eb 36                	jmp    802631 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8025fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8025fe:	8b 40 08             	mov    0x8(%eax),%eax
  802601:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802604:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802608:	74 07                	je     802611 <find_block+0x36>
  80260a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80260d:	8b 00                	mov    (%eax),%eax
  80260f:	eb 05                	jmp    802616 <find_block+0x3b>
  802611:	b8 00 00 00 00       	mov    $0x0,%eax
  802616:	8b 55 08             	mov    0x8(%ebp),%edx
  802619:	89 42 08             	mov    %eax,0x8(%edx)
  80261c:	8b 45 08             	mov    0x8(%ebp),%eax
  80261f:	8b 40 08             	mov    0x8(%eax),%eax
  802622:	85 c0                	test   %eax,%eax
  802624:	75 c5                	jne    8025eb <find_block+0x10>
  802626:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80262a:	75 bf                	jne    8025eb <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  80262c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802631:	c9                   	leave  
  802632:	c3                   	ret    

00802633 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802633:	55                   	push   %ebp
  802634:	89 e5                	mov    %esp,%ebp
  802636:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802639:	a1 40 50 80 00       	mov    0x805040,%eax
  80263e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802641:	a1 44 50 80 00       	mov    0x805044,%eax
  802646:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802649:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80264c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80264f:	74 24                	je     802675 <insert_sorted_allocList+0x42>
  802651:	8b 45 08             	mov    0x8(%ebp),%eax
  802654:	8b 50 08             	mov    0x8(%eax),%edx
  802657:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80265a:	8b 40 08             	mov    0x8(%eax),%eax
  80265d:	39 c2                	cmp    %eax,%edx
  80265f:	76 14                	jbe    802675 <insert_sorted_allocList+0x42>
  802661:	8b 45 08             	mov    0x8(%ebp),%eax
  802664:	8b 50 08             	mov    0x8(%eax),%edx
  802667:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80266a:	8b 40 08             	mov    0x8(%eax),%eax
  80266d:	39 c2                	cmp    %eax,%edx
  80266f:	0f 82 60 01 00 00    	jb     8027d5 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802675:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802679:	75 65                	jne    8026e0 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  80267b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80267f:	75 14                	jne    802695 <insert_sorted_allocList+0x62>
  802681:	83 ec 04             	sub    $0x4,%esp
  802684:	68 98 45 80 00       	push   $0x804598
  802689:	6a 6b                	push   $0x6b
  80268b:	68 bb 45 80 00       	push   $0x8045bb
  802690:	e8 77 e2 ff ff       	call   80090c <_panic>
  802695:	8b 15 40 50 80 00    	mov    0x805040,%edx
  80269b:	8b 45 08             	mov    0x8(%ebp),%eax
  80269e:	89 10                	mov    %edx,(%eax)
  8026a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a3:	8b 00                	mov    (%eax),%eax
  8026a5:	85 c0                	test   %eax,%eax
  8026a7:	74 0d                	je     8026b6 <insert_sorted_allocList+0x83>
  8026a9:	a1 40 50 80 00       	mov    0x805040,%eax
  8026ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8026b1:	89 50 04             	mov    %edx,0x4(%eax)
  8026b4:	eb 08                	jmp    8026be <insert_sorted_allocList+0x8b>
  8026b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b9:	a3 44 50 80 00       	mov    %eax,0x805044
  8026be:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c1:	a3 40 50 80 00       	mov    %eax,0x805040
  8026c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026d0:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8026d5:	40                   	inc    %eax
  8026d6:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8026db:	e9 dc 01 00 00       	jmp    8028bc <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8026e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e3:	8b 50 08             	mov    0x8(%eax),%edx
  8026e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026e9:	8b 40 08             	mov    0x8(%eax),%eax
  8026ec:	39 c2                	cmp    %eax,%edx
  8026ee:	77 6c                	ja     80275c <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8026f0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026f4:	74 06                	je     8026fc <insert_sorted_allocList+0xc9>
  8026f6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8026fa:	75 14                	jne    802710 <insert_sorted_allocList+0xdd>
  8026fc:	83 ec 04             	sub    $0x4,%esp
  8026ff:	68 d4 45 80 00       	push   $0x8045d4
  802704:	6a 6f                	push   $0x6f
  802706:	68 bb 45 80 00       	push   $0x8045bb
  80270b:	e8 fc e1 ff ff       	call   80090c <_panic>
  802710:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802713:	8b 50 04             	mov    0x4(%eax),%edx
  802716:	8b 45 08             	mov    0x8(%ebp),%eax
  802719:	89 50 04             	mov    %edx,0x4(%eax)
  80271c:	8b 45 08             	mov    0x8(%ebp),%eax
  80271f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802722:	89 10                	mov    %edx,(%eax)
  802724:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802727:	8b 40 04             	mov    0x4(%eax),%eax
  80272a:	85 c0                	test   %eax,%eax
  80272c:	74 0d                	je     80273b <insert_sorted_allocList+0x108>
  80272e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802731:	8b 40 04             	mov    0x4(%eax),%eax
  802734:	8b 55 08             	mov    0x8(%ebp),%edx
  802737:	89 10                	mov    %edx,(%eax)
  802739:	eb 08                	jmp    802743 <insert_sorted_allocList+0x110>
  80273b:	8b 45 08             	mov    0x8(%ebp),%eax
  80273e:	a3 40 50 80 00       	mov    %eax,0x805040
  802743:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802746:	8b 55 08             	mov    0x8(%ebp),%edx
  802749:	89 50 04             	mov    %edx,0x4(%eax)
  80274c:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802751:	40                   	inc    %eax
  802752:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802757:	e9 60 01 00 00       	jmp    8028bc <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  80275c:	8b 45 08             	mov    0x8(%ebp),%eax
  80275f:	8b 50 08             	mov    0x8(%eax),%edx
  802762:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802765:	8b 40 08             	mov    0x8(%eax),%eax
  802768:	39 c2                	cmp    %eax,%edx
  80276a:	0f 82 4c 01 00 00    	jb     8028bc <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802770:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802774:	75 14                	jne    80278a <insert_sorted_allocList+0x157>
  802776:	83 ec 04             	sub    $0x4,%esp
  802779:	68 0c 46 80 00       	push   $0x80460c
  80277e:	6a 73                	push   $0x73
  802780:	68 bb 45 80 00       	push   $0x8045bb
  802785:	e8 82 e1 ff ff       	call   80090c <_panic>
  80278a:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802790:	8b 45 08             	mov    0x8(%ebp),%eax
  802793:	89 50 04             	mov    %edx,0x4(%eax)
  802796:	8b 45 08             	mov    0x8(%ebp),%eax
  802799:	8b 40 04             	mov    0x4(%eax),%eax
  80279c:	85 c0                	test   %eax,%eax
  80279e:	74 0c                	je     8027ac <insert_sorted_allocList+0x179>
  8027a0:	a1 44 50 80 00       	mov    0x805044,%eax
  8027a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8027a8:	89 10                	mov    %edx,(%eax)
  8027aa:	eb 08                	jmp    8027b4 <insert_sorted_allocList+0x181>
  8027ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8027af:	a3 40 50 80 00       	mov    %eax,0x805040
  8027b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b7:	a3 44 50 80 00       	mov    %eax,0x805044
  8027bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8027bf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027c5:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8027ca:	40                   	inc    %eax
  8027cb:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8027d0:	e9 e7 00 00 00       	jmp    8028bc <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8027d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8027db:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8027e2:	a1 40 50 80 00       	mov    0x805040,%eax
  8027e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027ea:	e9 9d 00 00 00       	jmp    80288c <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8027ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f2:	8b 00                	mov    (%eax),%eax
  8027f4:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8027f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8027fa:	8b 50 08             	mov    0x8(%eax),%edx
  8027fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802800:	8b 40 08             	mov    0x8(%eax),%eax
  802803:	39 c2                	cmp    %eax,%edx
  802805:	76 7d                	jbe    802884 <insert_sorted_allocList+0x251>
  802807:	8b 45 08             	mov    0x8(%ebp),%eax
  80280a:	8b 50 08             	mov    0x8(%eax),%edx
  80280d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802810:	8b 40 08             	mov    0x8(%eax),%eax
  802813:	39 c2                	cmp    %eax,%edx
  802815:	73 6d                	jae    802884 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802817:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80281b:	74 06                	je     802823 <insert_sorted_allocList+0x1f0>
  80281d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802821:	75 14                	jne    802837 <insert_sorted_allocList+0x204>
  802823:	83 ec 04             	sub    $0x4,%esp
  802826:	68 30 46 80 00       	push   $0x804630
  80282b:	6a 7f                	push   $0x7f
  80282d:	68 bb 45 80 00       	push   $0x8045bb
  802832:	e8 d5 e0 ff ff       	call   80090c <_panic>
  802837:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283a:	8b 10                	mov    (%eax),%edx
  80283c:	8b 45 08             	mov    0x8(%ebp),%eax
  80283f:	89 10                	mov    %edx,(%eax)
  802841:	8b 45 08             	mov    0x8(%ebp),%eax
  802844:	8b 00                	mov    (%eax),%eax
  802846:	85 c0                	test   %eax,%eax
  802848:	74 0b                	je     802855 <insert_sorted_allocList+0x222>
  80284a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284d:	8b 00                	mov    (%eax),%eax
  80284f:	8b 55 08             	mov    0x8(%ebp),%edx
  802852:	89 50 04             	mov    %edx,0x4(%eax)
  802855:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802858:	8b 55 08             	mov    0x8(%ebp),%edx
  80285b:	89 10                	mov    %edx,(%eax)
  80285d:	8b 45 08             	mov    0x8(%ebp),%eax
  802860:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802863:	89 50 04             	mov    %edx,0x4(%eax)
  802866:	8b 45 08             	mov    0x8(%ebp),%eax
  802869:	8b 00                	mov    (%eax),%eax
  80286b:	85 c0                	test   %eax,%eax
  80286d:	75 08                	jne    802877 <insert_sorted_allocList+0x244>
  80286f:	8b 45 08             	mov    0x8(%ebp),%eax
  802872:	a3 44 50 80 00       	mov    %eax,0x805044
  802877:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80287c:	40                   	inc    %eax
  80287d:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802882:	eb 39                	jmp    8028bd <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802884:	a1 48 50 80 00       	mov    0x805048,%eax
  802889:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80288c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802890:	74 07                	je     802899 <insert_sorted_allocList+0x266>
  802892:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802895:	8b 00                	mov    (%eax),%eax
  802897:	eb 05                	jmp    80289e <insert_sorted_allocList+0x26b>
  802899:	b8 00 00 00 00       	mov    $0x0,%eax
  80289e:	a3 48 50 80 00       	mov    %eax,0x805048
  8028a3:	a1 48 50 80 00       	mov    0x805048,%eax
  8028a8:	85 c0                	test   %eax,%eax
  8028aa:	0f 85 3f ff ff ff    	jne    8027ef <insert_sorted_allocList+0x1bc>
  8028b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028b4:	0f 85 35 ff ff ff    	jne    8027ef <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8028ba:	eb 01                	jmp    8028bd <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8028bc:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8028bd:	90                   	nop
  8028be:	c9                   	leave  
  8028bf:	c3                   	ret    

008028c0 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8028c0:	55                   	push   %ebp
  8028c1:	89 e5                	mov    %esp,%ebp
  8028c3:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8028c6:	a1 38 51 80 00       	mov    0x805138,%eax
  8028cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028ce:	e9 85 01 00 00       	jmp    802a58 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8028d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d6:	8b 40 0c             	mov    0xc(%eax),%eax
  8028d9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028dc:	0f 82 6e 01 00 00    	jb     802a50 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8028e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e5:	8b 40 0c             	mov    0xc(%eax),%eax
  8028e8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028eb:	0f 85 8a 00 00 00    	jne    80297b <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8028f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028f5:	75 17                	jne    80290e <alloc_block_FF+0x4e>
  8028f7:	83 ec 04             	sub    $0x4,%esp
  8028fa:	68 64 46 80 00       	push   $0x804664
  8028ff:	68 93 00 00 00       	push   $0x93
  802904:	68 bb 45 80 00       	push   $0x8045bb
  802909:	e8 fe df ff ff       	call   80090c <_panic>
  80290e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802911:	8b 00                	mov    (%eax),%eax
  802913:	85 c0                	test   %eax,%eax
  802915:	74 10                	je     802927 <alloc_block_FF+0x67>
  802917:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291a:	8b 00                	mov    (%eax),%eax
  80291c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80291f:	8b 52 04             	mov    0x4(%edx),%edx
  802922:	89 50 04             	mov    %edx,0x4(%eax)
  802925:	eb 0b                	jmp    802932 <alloc_block_FF+0x72>
  802927:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292a:	8b 40 04             	mov    0x4(%eax),%eax
  80292d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802932:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802935:	8b 40 04             	mov    0x4(%eax),%eax
  802938:	85 c0                	test   %eax,%eax
  80293a:	74 0f                	je     80294b <alloc_block_FF+0x8b>
  80293c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293f:	8b 40 04             	mov    0x4(%eax),%eax
  802942:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802945:	8b 12                	mov    (%edx),%edx
  802947:	89 10                	mov    %edx,(%eax)
  802949:	eb 0a                	jmp    802955 <alloc_block_FF+0x95>
  80294b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294e:	8b 00                	mov    (%eax),%eax
  802950:	a3 38 51 80 00       	mov    %eax,0x805138
  802955:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802958:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80295e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802961:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802968:	a1 44 51 80 00       	mov    0x805144,%eax
  80296d:	48                   	dec    %eax
  80296e:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802973:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802976:	e9 10 01 00 00       	jmp    802a8b <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  80297b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297e:	8b 40 0c             	mov    0xc(%eax),%eax
  802981:	3b 45 08             	cmp    0x8(%ebp),%eax
  802984:	0f 86 c6 00 00 00    	jbe    802a50 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80298a:	a1 48 51 80 00       	mov    0x805148,%eax
  80298f:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802992:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802995:	8b 50 08             	mov    0x8(%eax),%edx
  802998:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80299b:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  80299e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8029a4:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8029a7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029ab:	75 17                	jne    8029c4 <alloc_block_FF+0x104>
  8029ad:	83 ec 04             	sub    $0x4,%esp
  8029b0:	68 64 46 80 00       	push   $0x804664
  8029b5:	68 9b 00 00 00       	push   $0x9b
  8029ba:	68 bb 45 80 00       	push   $0x8045bb
  8029bf:	e8 48 df ff ff       	call   80090c <_panic>
  8029c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029c7:	8b 00                	mov    (%eax),%eax
  8029c9:	85 c0                	test   %eax,%eax
  8029cb:	74 10                	je     8029dd <alloc_block_FF+0x11d>
  8029cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029d0:	8b 00                	mov    (%eax),%eax
  8029d2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029d5:	8b 52 04             	mov    0x4(%edx),%edx
  8029d8:	89 50 04             	mov    %edx,0x4(%eax)
  8029db:	eb 0b                	jmp    8029e8 <alloc_block_FF+0x128>
  8029dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029e0:	8b 40 04             	mov    0x4(%eax),%eax
  8029e3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8029e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029eb:	8b 40 04             	mov    0x4(%eax),%eax
  8029ee:	85 c0                	test   %eax,%eax
  8029f0:	74 0f                	je     802a01 <alloc_block_FF+0x141>
  8029f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f5:	8b 40 04             	mov    0x4(%eax),%eax
  8029f8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029fb:	8b 12                	mov    (%edx),%edx
  8029fd:	89 10                	mov    %edx,(%eax)
  8029ff:	eb 0a                	jmp    802a0b <alloc_block_FF+0x14b>
  802a01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a04:	8b 00                	mov    (%eax),%eax
  802a06:	a3 48 51 80 00       	mov    %eax,0x805148
  802a0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a0e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a17:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a1e:	a1 54 51 80 00       	mov    0x805154,%eax
  802a23:	48                   	dec    %eax
  802a24:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802a29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2c:	8b 50 08             	mov    0x8(%eax),%edx
  802a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a32:	01 c2                	add    %eax,%edx
  802a34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a37:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802a3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3d:	8b 40 0c             	mov    0xc(%eax),%eax
  802a40:	2b 45 08             	sub    0x8(%ebp),%eax
  802a43:	89 c2                	mov    %eax,%edx
  802a45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a48:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802a4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a4e:	eb 3b                	jmp    802a8b <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802a50:	a1 40 51 80 00       	mov    0x805140,%eax
  802a55:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a58:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a5c:	74 07                	je     802a65 <alloc_block_FF+0x1a5>
  802a5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a61:	8b 00                	mov    (%eax),%eax
  802a63:	eb 05                	jmp    802a6a <alloc_block_FF+0x1aa>
  802a65:	b8 00 00 00 00       	mov    $0x0,%eax
  802a6a:	a3 40 51 80 00       	mov    %eax,0x805140
  802a6f:	a1 40 51 80 00       	mov    0x805140,%eax
  802a74:	85 c0                	test   %eax,%eax
  802a76:	0f 85 57 fe ff ff    	jne    8028d3 <alloc_block_FF+0x13>
  802a7c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a80:	0f 85 4d fe ff ff    	jne    8028d3 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802a86:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a8b:	c9                   	leave  
  802a8c:	c3                   	ret    

00802a8d <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802a8d:	55                   	push   %ebp
  802a8e:	89 e5                	mov    %esp,%ebp
  802a90:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802a93:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802a9a:	a1 38 51 80 00       	mov    0x805138,%eax
  802a9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802aa2:	e9 df 00 00 00       	jmp    802b86 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802aa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aaa:	8b 40 0c             	mov    0xc(%eax),%eax
  802aad:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ab0:	0f 82 c8 00 00 00    	jb     802b7e <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802ab6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab9:	8b 40 0c             	mov    0xc(%eax),%eax
  802abc:	3b 45 08             	cmp    0x8(%ebp),%eax
  802abf:	0f 85 8a 00 00 00    	jne    802b4f <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802ac5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ac9:	75 17                	jne    802ae2 <alloc_block_BF+0x55>
  802acb:	83 ec 04             	sub    $0x4,%esp
  802ace:	68 64 46 80 00       	push   $0x804664
  802ad3:	68 b7 00 00 00       	push   $0xb7
  802ad8:	68 bb 45 80 00       	push   $0x8045bb
  802add:	e8 2a de ff ff       	call   80090c <_panic>
  802ae2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae5:	8b 00                	mov    (%eax),%eax
  802ae7:	85 c0                	test   %eax,%eax
  802ae9:	74 10                	je     802afb <alloc_block_BF+0x6e>
  802aeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aee:	8b 00                	mov    (%eax),%eax
  802af0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802af3:	8b 52 04             	mov    0x4(%edx),%edx
  802af6:	89 50 04             	mov    %edx,0x4(%eax)
  802af9:	eb 0b                	jmp    802b06 <alloc_block_BF+0x79>
  802afb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afe:	8b 40 04             	mov    0x4(%eax),%eax
  802b01:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b09:	8b 40 04             	mov    0x4(%eax),%eax
  802b0c:	85 c0                	test   %eax,%eax
  802b0e:	74 0f                	je     802b1f <alloc_block_BF+0x92>
  802b10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b13:	8b 40 04             	mov    0x4(%eax),%eax
  802b16:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b19:	8b 12                	mov    (%edx),%edx
  802b1b:	89 10                	mov    %edx,(%eax)
  802b1d:	eb 0a                	jmp    802b29 <alloc_block_BF+0x9c>
  802b1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b22:	8b 00                	mov    (%eax),%eax
  802b24:	a3 38 51 80 00       	mov    %eax,0x805138
  802b29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b35:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b3c:	a1 44 51 80 00       	mov    0x805144,%eax
  802b41:	48                   	dec    %eax
  802b42:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802b47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4a:	e9 4d 01 00 00       	jmp    802c9c <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802b4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b52:	8b 40 0c             	mov    0xc(%eax),%eax
  802b55:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b58:	76 24                	jbe    802b7e <alloc_block_BF+0xf1>
  802b5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5d:	8b 40 0c             	mov    0xc(%eax),%eax
  802b60:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802b63:	73 19                	jae    802b7e <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802b65:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802b6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6f:	8b 40 0c             	mov    0xc(%eax),%eax
  802b72:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802b75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b78:	8b 40 08             	mov    0x8(%eax),%eax
  802b7b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802b7e:	a1 40 51 80 00       	mov    0x805140,%eax
  802b83:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b86:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b8a:	74 07                	je     802b93 <alloc_block_BF+0x106>
  802b8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8f:	8b 00                	mov    (%eax),%eax
  802b91:	eb 05                	jmp    802b98 <alloc_block_BF+0x10b>
  802b93:	b8 00 00 00 00       	mov    $0x0,%eax
  802b98:	a3 40 51 80 00       	mov    %eax,0x805140
  802b9d:	a1 40 51 80 00       	mov    0x805140,%eax
  802ba2:	85 c0                	test   %eax,%eax
  802ba4:	0f 85 fd fe ff ff    	jne    802aa7 <alloc_block_BF+0x1a>
  802baa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bae:	0f 85 f3 fe ff ff    	jne    802aa7 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802bb4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802bb8:	0f 84 d9 00 00 00    	je     802c97 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802bbe:	a1 48 51 80 00       	mov    0x805148,%eax
  802bc3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802bc6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bc9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802bcc:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802bcf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bd2:	8b 55 08             	mov    0x8(%ebp),%edx
  802bd5:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802bd8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802bdc:	75 17                	jne    802bf5 <alloc_block_BF+0x168>
  802bde:	83 ec 04             	sub    $0x4,%esp
  802be1:	68 64 46 80 00       	push   $0x804664
  802be6:	68 c7 00 00 00       	push   $0xc7
  802beb:	68 bb 45 80 00       	push   $0x8045bb
  802bf0:	e8 17 dd ff ff       	call   80090c <_panic>
  802bf5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bf8:	8b 00                	mov    (%eax),%eax
  802bfa:	85 c0                	test   %eax,%eax
  802bfc:	74 10                	je     802c0e <alloc_block_BF+0x181>
  802bfe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c01:	8b 00                	mov    (%eax),%eax
  802c03:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c06:	8b 52 04             	mov    0x4(%edx),%edx
  802c09:	89 50 04             	mov    %edx,0x4(%eax)
  802c0c:	eb 0b                	jmp    802c19 <alloc_block_BF+0x18c>
  802c0e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c11:	8b 40 04             	mov    0x4(%eax),%eax
  802c14:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c19:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c1c:	8b 40 04             	mov    0x4(%eax),%eax
  802c1f:	85 c0                	test   %eax,%eax
  802c21:	74 0f                	je     802c32 <alloc_block_BF+0x1a5>
  802c23:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c26:	8b 40 04             	mov    0x4(%eax),%eax
  802c29:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c2c:	8b 12                	mov    (%edx),%edx
  802c2e:	89 10                	mov    %edx,(%eax)
  802c30:	eb 0a                	jmp    802c3c <alloc_block_BF+0x1af>
  802c32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c35:	8b 00                	mov    (%eax),%eax
  802c37:	a3 48 51 80 00       	mov    %eax,0x805148
  802c3c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c3f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c45:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c48:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c4f:	a1 54 51 80 00       	mov    0x805154,%eax
  802c54:	48                   	dec    %eax
  802c55:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802c5a:	83 ec 08             	sub    $0x8,%esp
  802c5d:	ff 75 ec             	pushl  -0x14(%ebp)
  802c60:	68 38 51 80 00       	push   $0x805138
  802c65:	e8 71 f9 ff ff       	call   8025db <find_block>
  802c6a:	83 c4 10             	add    $0x10,%esp
  802c6d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802c70:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c73:	8b 50 08             	mov    0x8(%eax),%edx
  802c76:	8b 45 08             	mov    0x8(%ebp),%eax
  802c79:	01 c2                	add    %eax,%edx
  802c7b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c7e:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802c81:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c84:	8b 40 0c             	mov    0xc(%eax),%eax
  802c87:	2b 45 08             	sub    0x8(%ebp),%eax
  802c8a:	89 c2                	mov    %eax,%edx
  802c8c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c8f:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802c92:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c95:	eb 05                	jmp    802c9c <alloc_block_BF+0x20f>
	}
	return NULL;
  802c97:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c9c:	c9                   	leave  
  802c9d:	c3                   	ret    

00802c9e <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802c9e:	55                   	push   %ebp
  802c9f:	89 e5                	mov    %esp,%ebp
  802ca1:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802ca4:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802ca9:	85 c0                	test   %eax,%eax
  802cab:	0f 85 de 01 00 00    	jne    802e8f <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802cb1:	a1 38 51 80 00       	mov    0x805138,%eax
  802cb6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cb9:	e9 9e 01 00 00       	jmp    802e5c <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802cbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc1:	8b 40 0c             	mov    0xc(%eax),%eax
  802cc4:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cc7:	0f 82 87 01 00 00    	jb     802e54 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802ccd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd0:	8b 40 0c             	mov    0xc(%eax),%eax
  802cd3:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cd6:	0f 85 95 00 00 00    	jne    802d71 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802cdc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ce0:	75 17                	jne    802cf9 <alloc_block_NF+0x5b>
  802ce2:	83 ec 04             	sub    $0x4,%esp
  802ce5:	68 64 46 80 00       	push   $0x804664
  802cea:	68 e0 00 00 00       	push   $0xe0
  802cef:	68 bb 45 80 00       	push   $0x8045bb
  802cf4:	e8 13 dc ff ff       	call   80090c <_panic>
  802cf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfc:	8b 00                	mov    (%eax),%eax
  802cfe:	85 c0                	test   %eax,%eax
  802d00:	74 10                	je     802d12 <alloc_block_NF+0x74>
  802d02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d05:	8b 00                	mov    (%eax),%eax
  802d07:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d0a:	8b 52 04             	mov    0x4(%edx),%edx
  802d0d:	89 50 04             	mov    %edx,0x4(%eax)
  802d10:	eb 0b                	jmp    802d1d <alloc_block_NF+0x7f>
  802d12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d15:	8b 40 04             	mov    0x4(%eax),%eax
  802d18:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d20:	8b 40 04             	mov    0x4(%eax),%eax
  802d23:	85 c0                	test   %eax,%eax
  802d25:	74 0f                	je     802d36 <alloc_block_NF+0x98>
  802d27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2a:	8b 40 04             	mov    0x4(%eax),%eax
  802d2d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d30:	8b 12                	mov    (%edx),%edx
  802d32:	89 10                	mov    %edx,(%eax)
  802d34:	eb 0a                	jmp    802d40 <alloc_block_NF+0xa2>
  802d36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d39:	8b 00                	mov    (%eax),%eax
  802d3b:	a3 38 51 80 00       	mov    %eax,0x805138
  802d40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d43:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d53:	a1 44 51 80 00       	mov    0x805144,%eax
  802d58:	48                   	dec    %eax
  802d59:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802d5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d61:	8b 40 08             	mov    0x8(%eax),%eax
  802d64:	a3 2c 50 80 00       	mov    %eax,0x80502c
				   return  point;
  802d69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6c:	e9 f8 04 00 00       	jmp    803269 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802d71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d74:	8b 40 0c             	mov    0xc(%eax),%eax
  802d77:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d7a:	0f 86 d4 00 00 00    	jbe    802e54 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802d80:	a1 48 51 80 00       	mov    0x805148,%eax
  802d85:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802d88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8b:	8b 50 08             	mov    0x8(%eax),%edx
  802d8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d91:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802d94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d97:	8b 55 08             	mov    0x8(%ebp),%edx
  802d9a:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802d9d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802da1:	75 17                	jne    802dba <alloc_block_NF+0x11c>
  802da3:	83 ec 04             	sub    $0x4,%esp
  802da6:	68 64 46 80 00       	push   $0x804664
  802dab:	68 e9 00 00 00       	push   $0xe9
  802db0:	68 bb 45 80 00       	push   $0x8045bb
  802db5:	e8 52 db ff ff       	call   80090c <_panic>
  802dba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dbd:	8b 00                	mov    (%eax),%eax
  802dbf:	85 c0                	test   %eax,%eax
  802dc1:	74 10                	je     802dd3 <alloc_block_NF+0x135>
  802dc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc6:	8b 00                	mov    (%eax),%eax
  802dc8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802dcb:	8b 52 04             	mov    0x4(%edx),%edx
  802dce:	89 50 04             	mov    %edx,0x4(%eax)
  802dd1:	eb 0b                	jmp    802dde <alloc_block_NF+0x140>
  802dd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dd6:	8b 40 04             	mov    0x4(%eax),%eax
  802dd9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802dde:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de1:	8b 40 04             	mov    0x4(%eax),%eax
  802de4:	85 c0                	test   %eax,%eax
  802de6:	74 0f                	je     802df7 <alloc_block_NF+0x159>
  802de8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802deb:	8b 40 04             	mov    0x4(%eax),%eax
  802dee:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802df1:	8b 12                	mov    (%edx),%edx
  802df3:	89 10                	mov    %edx,(%eax)
  802df5:	eb 0a                	jmp    802e01 <alloc_block_NF+0x163>
  802df7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dfa:	8b 00                	mov    (%eax),%eax
  802dfc:	a3 48 51 80 00       	mov    %eax,0x805148
  802e01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e04:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e0d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e14:	a1 54 51 80 00       	mov    0x805154,%eax
  802e19:	48                   	dec    %eax
  802e1a:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802e1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e22:	8b 40 08             	mov    0x8(%eax),%eax
  802e25:	a3 2c 50 80 00       	mov    %eax,0x80502c
				   point->sva += size;
  802e2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2d:	8b 50 08             	mov    0x8(%eax),%edx
  802e30:	8b 45 08             	mov    0x8(%ebp),%eax
  802e33:	01 c2                	add    %eax,%edx
  802e35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e38:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802e3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3e:	8b 40 0c             	mov    0xc(%eax),%eax
  802e41:	2b 45 08             	sub    0x8(%ebp),%eax
  802e44:	89 c2                	mov    %eax,%edx
  802e46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e49:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802e4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e4f:	e9 15 04 00 00       	jmp    803269 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802e54:	a1 40 51 80 00       	mov    0x805140,%eax
  802e59:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e5c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e60:	74 07                	je     802e69 <alloc_block_NF+0x1cb>
  802e62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e65:	8b 00                	mov    (%eax),%eax
  802e67:	eb 05                	jmp    802e6e <alloc_block_NF+0x1d0>
  802e69:	b8 00 00 00 00       	mov    $0x0,%eax
  802e6e:	a3 40 51 80 00       	mov    %eax,0x805140
  802e73:	a1 40 51 80 00       	mov    0x805140,%eax
  802e78:	85 c0                	test   %eax,%eax
  802e7a:	0f 85 3e fe ff ff    	jne    802cbe <alloc_block_NF+0x20>
  802e80:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e84:	0f 85 34 fe ff ff    	jne    802cbe <alloc_block_NF+0x20>
  802e8a:	e9 d5 03 00 00       	jmp    803264 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802e8f:	a1 38 51 80 00       	mov    0x805138,%eax
  802e94:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e97:	e9 b1 01 00 00       	jmp    80304d <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802e9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9f:	8b 50 08             	mov    0x8(%eax),%edx
  802ea2:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802ea7:	39 c2                	cmp    %eax,%edx
  802ea9:	0f 82 96 01 00 00    	jb     803045 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802eaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb2:	8b 40 0c             	mov    0xc(%eax),%eax
  802eb5:	3b 45 08             	cmp    0x8(%ebp),%eax
  802eb8:	0f 82 87 01 00 00    	jb     803045 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802ebe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec1:	8b 40 0c             	mov    0xc(%eax),%eax
  802ec4:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ec7:	0f 85 95 00 00 00    	jne    802f62 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802ecd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ed1:	75 17                	jne    802eea <alloc_block_NF+0x24c>
  802ed3:	83 ec 04             	sub    $0x4,%esp
  802ed6:	68 64 46 80 00       	push   $0x804664
  802edb:	68 fc 00 00 00       	push   $0xfc
  802ee0:	68 bb 45 80 00       	push   $0x8045bb
  802ee5:	e8 22 da ff ff       	call   80090c <_panic>
  802eea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eed:	8b 00                	mov    (%eax),%eax
  802eef:	85 c0                	test   %eax,%eax
  802ef1:	74 10                	je     802f03 <alloc_block_NF+0x265>
  802ef3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef6:	8b 00                	mov    (%eax),%eax
  802ef8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802efb:	8b 52 04             	mov    0x4(%edx),%edx
  802efe:	89 50 04             	mov    %edx,0x4(%eax)
  802f01:	eb 0b                	jmp    802f0e <alloc_block_NF+0x270>
  802f03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f06:	8b 40 04             	mov    0x4(%eax),%eax
  802f09:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f11:	8b 40 04             	mov    0x4(%eax),%eax
  802f14:	85 c0                	test   %eax,%eax
  802f16:	74 0f                	je     802f27 <alloc_block_NF+0x289>
  802f18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1b:	8b 40 04             	mov    0x4(%eax),%eax
  802f1e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f21:	8b 12                	mov    (%edx),%edx
  802f23:	89 10                	mov    %edx,(%eax)
  802f25:	eb 0a                	jmp    802f31 <alloc_block_NF+0x293>
  802f27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2a:	8b 00                	mov    (%eax),%eax
  802f2c:	a3 38 51 80 00       	mov    %eax,0x805138
  802f31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f34:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f44:	a1 44 51 80 00       	mov    0x805144,%eax
  802f49:	48                   	dec    %eax
  802f4a:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802f4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f52:	8b 40 08             	mov    0x8(%eax),%eax
  802f55:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   return  point;
  802f5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5d:	e9 07 03 00 00       	jmp    803269 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802f62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f65:	8b 40 0c             	mov    0xc(%eax),%eax
  802f68:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f6b:	0f 86 d4 00 00 00    	jbe    803045 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802f71:	a1 48 51 80 00       	mov    0x805148,%eax
  802f76:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802f79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7c:	8b 50 08             	mov    0x8(%eax),%edx
  802f7f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f82:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802f85:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f88:	8b 55 08             	mov    0x8(%ebp),%edx
  802f8b:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802f8e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f92:	75 17                	jne    802fab <alloc_block_NF+0x30d>
  802f94:	83 ec 04             	sub    $0x4,%esp
  802f97:	68 64 46 80 00       	push   $0x804664
  802f9c:	68 04 01 00 00       	push   $0x104
  802fa1:	68 bb 45 80 00       	push   $0x8045bb
  802fa6:	e8 61 d9 ff ff       	call   80090c <_panic>
  802fab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fae:	8b 00                	mov    (%eax),%eax
  802fb0:	85 c0                	test   %eax,%eax
  802fb2:	74 10                	je     802fc4 <alloc_block_NF+0x326>
  802fb4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fb7:	8b 00                	mov    (%eax),%eax
  802fb9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fbc:	8b 52 04             	mov    0x4(%edx),%edx
  802fbf:	89 50 04             	mov    %edx,0x4(%eax)
  802fc2:	eb 0b                	jmp    802fcf <alloc_block_NF+0x331>
  802fc4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fc7:	8b 40 04             	mov    0x4(%eax),%eax
  802fca:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802fcf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fd2:	8b 40 04             	mov    0x4(%eax),%eax
  802fd5:	85 c0                	test   %eax,%eax
  802fd7:	74 0f                	je     802fe8 <alloc_block_NF+0x34a>
  802fd9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fdc:	8b 40 04             	mov    0x4(%eax),%eax
  802fdf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fe2:	8b 12                	mov    (%edx),%edx
  802fe4:	89 10                	mov    %edx,(%eax)
  802fe6:	eb 0a                	jmp    802ff2 <alloc_block_NF+0x354>
  802fe8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802feb:	8b 00                	mov    (%eax),%eax
  802fed:	a3 48 51 80 00       	mov    %eax,0x805148
  802ff2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ff5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ffb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ffe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803005:	a1 54 51 80 00       	mov    0x805154,%eax
  80300a:	48                   	dec    %eax
  80300b:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  803010:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803013:	8b 40 08             	mov    0x8(%eax),%eax
  803016:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   point->sva += size;
  80301b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80301e:	8b 50 08             	mov    0x8(%eax),%edx
  803021:	8b 45 08             	mov    0x8(%ebp),%eax
  803024:	01 c2                	add    %eax,%edx
  803026:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803029:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  80302c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80302f:	8b 40 0c             	mov    0xc(%eax),%eax
  803032:	2b 45 08             	sub    0x8(%ebp),%eax
  803035:	89 c2                	mov    %eax,%edx
  803037:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80303a:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  80303d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803040:	e9 24 02 00 00       	jmp    803269 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  803045:	a1 40 51 80 00       	mov    0x805140,%eax
  80304a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80304d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803051:	74 07                	je     80305a <alloc_block_NF+0x3bc>
  803053:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803056:	8b 00                	mov    (%eax),%eax
  803058:	eb 05                	jmp    80305f <alloc_block_NF+0x3c1>
  80305a:	b8 00 00 00 00       	mov    $0x0,%eax
  80305f:	a3 40 51 80 00       	mov    %eax,0x805140
  803064:	a1 40 51 80 00       	mov    0x805140,%eax
  803069:	85 c0                	test   %eax,%eax
  80306b:	0f 85 2b fe ff ff    	jne    802e9c <alloc_block_NF+0x1fe>
  803071:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803075:	0f 85 21 fe ff ff    	jne    802e9c <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  80307b:	a1 38 51 80 00       	mov    0x805138,%eax
  803080:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803083:	e9 ae 01 00 00       	jmp    803236 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  803088:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80308b:	8b 50 08             	mov    0x8(%eax),%edx
  80308e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803093:	39 c2                	cmp    %eax,%edx
  803095:	0f 83 93 01 00 00    	jae    80322e <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  80309b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80309e:	8b 40 0c             	mov    0xc(%eax),%eax
  8030a1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030a4:	0f 82 84 01 00 00    	jb     80322e <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  8030aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ad:	8b 40 0c             	mov    0xc(%eax),%eax
  8030b0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030b3:	0f 85 95 00 00 00    	jne    80314e <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8030b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030bd:	75 17                	jne    8030d6 <alloc_block_NF+0x438>
  8030bf:	83 ec 04             	sub    $0x4,%esp
  8030c2:	68 64 46 80 00       	push   $0x804664
  8030c7:	68 14 01 00 00       	push   $0x114
  8030cc:	68 bb 45 80 00       	push   $0x8045bb
  8030d1:	e8 36 d8 ff ff       	call   80090c <_panic>
  8030d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d9:	8b 00                	mov    (%eax),%eax
  8030db:	85 c0                	test   %eax,%eax
  8030dd:	74 10                	je     8030ef <alloc_block_NF+0x451>
  8030df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e2:	8b 00                	mov    (%eax),%eax
  8030e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030e7:	8b 52 04             	mov    0x4(%edx),%edx
  8030ea:	89 50 04             	mov    %edx,0x4(%eax)
  8030ed:	eb 0b                	jmp    8030fa <alloc_block_NF+0x45c>
  8030ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f2:	8b 40 04             	mov    0x4(%eax),%eax
  8030f5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030fd:	8b 40 04             	mov    0x4(%eax),%eax
  803100:	85 c0                	test   %eax,%eax
  803102:	74 0f                	je     803113 <alloc_block_NF+0x475>
  803104:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803107:	8b 40 04             	mov    0x4(%eax),%eax
  80310a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80310d:	8b 12                	mov    (%edx),%edx
  80310f:	89 10                	mov    %edx,(%eax)
  803111:	eb 0a                	jmp    80311d <alloc_block_NF+0x47f>
  803113:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803116:	8b 00                	mov    (%eax),%eax
  803118:	a3 38 51 80 00       	mov    %eax,0x805138
  80311d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803120:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803126:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803129:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803130:	a1 44 51 80 00       	mov    0x805144,%eax
  803135:	48                   	dec    %eax
  803136:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  80313b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80313e:	8b 40 08             	mov    0x8(%eax),%eax
  803141:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   return  point;
  803146:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803149:	e9 1b 01 00 00       	jmp    803269 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  80314e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803151:	8b 40 0c             	mov    0xc(%eax),%eax
  803154:	3b 45 08             	cmp    0x8(%ebp),%eax
  803157:	0f 86 d1 00 00 00    	jbe    80322e <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80315d:	a1 48 51 80 00       	mov    0x805148,%eax
  803162:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  803165:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803168:	8b 50 08             	mov    0x8(%eax),%edx
  80316b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80316e:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  803171:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803174:	8b 55 08             	mov    0x8(%ebp),%edx
  803177:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80317a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80317e:	75 17                	jne    803197 <alloc_block_NF+0x4f9>
  803180:	83 ec 04             	sub    $0x4,%esp
  803183:	68 64 46 80 00       	push   $0x804664
  803188:	68 1c 01 00 00       	push   $0x11c
  80318d:	68 bb 45 80 00       	push   $0x8045bb
  803192:	e8 75 d7 ff ff       	call   80090c <_panic>
  803197:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80319a:	8b 00                	mov    (%eax),%eax
  80319c:	85 c0                	test   %eax,%eax
  80319e:	74 10                	je     8031b0 <alloc_block_NF+0x512>
  8031a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031a3:	8b 00                	mov    (%eax),%eax
  8031a5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8031a8:	8b 52 04             	mov    0x4(%edx),%edx
  8031ab:	89 50 04             	mov    %edx,0x4(%eax)
  8031ae:	eb 0b                	jmp    8031bb <alloc_block_NF+0x51d>
  8031b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031b3:	8b 40 04             	mov    0x4(%eax),%eax
  8031b6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031be:	8b 40 04             	mov    0x4(%eax),%eax
  8031c1:	85 c0                	test   %eax,%eax
  8031c3:	74 0f                	je     8031d4 <alloc_block_NF+0x536>
  8031c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031c8:	8b 40 04             	mov    0x4(%eax),%eax
  8031cb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8031ce:	8b 12                	mov    (%edx),%edx
  8031d0:	89 10                	mov    %edx,(%eax)
  8031d2:	eb 0a                	jmp    8031de <alloc_block_NF+0x540>
  8031d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031d7:	8b 00                	mov    (%eax),%eax
  8031d9:	a3 48 51 80 00       	mov    %eax,0x805148
  8031de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031e1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031ea:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031f1:	a1 54 51 80 00       	mov    0x805154,%eax
  8031f6:	48                   	dec    %eax
  8031f7:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  8031fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031ff:	8b 40 08             	mov    0x8(%eax),%eax
  803202:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   point->sva += size;
  803207:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80320a:	8b 50 08             	mov    0x8(%eax),%edx
  80320d:	8b 45 08             	mov    0x8(%ebp),%eax
  803210:	01 c2                	add    %eax,%edx
  803212:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803215:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803218:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80321b:	8b 40 0c             	mov    0xc(%eax),%eax
  80321e:	2b 45 08             	sub    0x8(%ebp),%eax
  803221:	89 c2                	mov    %eax,%edx
  803223:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803226:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803229:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80322c:	eb 3b                	jmp    803269 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  80322e:	a1 40 51 80 00       	mov    0x805140,%eax
  803233:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803236:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80323a:	74 07                	je     803243 <alloc_block_NF+0x5a5>
  80323c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80323f:	8b 00                	mov    (%eax),%eax
  803241:	eb 05                	jmp    803248 <alloc_block_NF+0x5aa>
  803243:	b8 00 00 00 00       	mov    $0x0,%eax
  803248:	a3 40 51 80 00       	mov    %eax,0x805140
  80324d:	a1 40 51 80 00       	mov    0x805140,%eax
  803252:	85 c0                	test   %eax,%eax
  803254:	0f 85 2e fe ff ff    	jne    803088 <alloc_block_NF+0x3ea>
  80325a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80325e:	0f 85 24 fe ff ff    	jne    803088 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  803264:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803269:	c9                   	leave  
  80326a:	c3                   	ret    

0080326b <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  80326b:	55                   	push   %ebp
  80326c:	89 e5                	mov    %esp,%ebp
  80326e:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  803271:	a1 38 51 80 00       	mov    0x805138,%eax
  803276:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  803279:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80327e:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  803281:	a1 38 51 80 00       	mov    0x805138,%eax
  803286:	85 c0                	test   %eax,%eax
  803288:	74 14                	je     80329e <insert_sorted_with_merge_freeList+0x33>
  80328a:	8b 45 08             	mov    0x8(%ebp),%eax
  80328d:	8b 50 08             	mov    0x8(%eax),%edx
  803290:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803293:	8b 40 08             	mov    0x8(%eax),%eax
  803296:	39 c2                	cmp    %eax,%edx
  803298:	0f 87 9b 01 00 00    	ja     803439 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  80329e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032a2:	75 17                	jne    8032bb <insert_sorted_with_merge_freeList+0x50>
  8032a4:	83 ec 04             	sub    $0x4,%esp
  8032a7:	68 98 45 80 00       	push   $0x804598
  8032ac:	68 38 01 00 00       	push   $0x138
  8032b1:	68 bb 45 80 00       	push   $0x8045bb
  8032b6:	e8 51 d6 ff ff       	call   80090c <_panic>
  8032bb:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8032c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c4:	89 10                	mov    %edx,(%eax)
  8032c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c9:	8b 00                	mov    (%eax),%eax
  8032cb:	85 c0                	test   %eax,%eax
  8032cd:	74 0d                	je     8032dc <insert_sorted_with_merge_freeList+0x71>
  8032cf:	a1 38 51 80 00       	mov    0x805138,%eax
  8032d4:	8b 55 08             	mov    0x8(%ebp),%edx
  8032d7:	89 50 04             	mov    %edx,0x4(%eax)
  8032da:	eb 08                	jmp    8032e4 <insert_sorted_with_merge_freeList+0x79>
  8032dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8032df:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e7:	a3 38 51 80 00       	mov    %eax,0x805138
  8032ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ef:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032f6:	a1 44 51 80 00       	mov    0x805144,%eax
  8032fb:	40                   	inc    %eax
  8032fc:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803301:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803305:	0f 84 a8 06 00 00    	je     8039b3 <insert_sorted_with_merge_freeList+0x748>
  80330b:	8b 45 08             	mov    0x8(%ebp),%eax
  80330e:	8b 50 08             	mov    0x8(%eax),%edx
  803311:	8b 45 08             	mov    0x8(%ebp),%eax
  803314:	8b 40 0c             	mov    0xc(%eax),%eax
  803317:	01 c2                	add    %eax,%edx
  803319:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80331c:	8b 40 08             	mov    0x8(%eax),%eax
  80331f:	39 c2                	cmp    %eax,%edx
  803321:	0f 85 8c 06 00 00    	jne    8039b3 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  803327:	8b 45 08             	mov    0x8(%ebp),%eax
  80332a:	8b 50 0c             	mov    0xc(%eax),%edx
  80332d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803330:	8b 40 0c             	mov    0xc(%eax),%eax
  803333:	01 c2                	add    %eax,%edx
  803335:	8b 45 08             	mov    0x8(%ebp),%eax
  803338:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  80333b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80333f:	75 17                	jne    803358 <insert_sorted_with_merge_freeList+0xed>
  803341:	83 ec 04             	sub    $0x4,%esp
  803344:	68 64 46 80 00       	push   $0x804664
  803349:	68 3c 01 00 00       	push   $0x13c
  80334e:	68 bb 45 80 00       	push   $0x8045bb
  803353:	e8 b4 d5 ff ff       	call   80090c <_panic>
  803358:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80335b:	8b 00                	mov    (%eax),%eax
  80335d:	85 c0                	test   %eax,%eax
  80335f:	74 10                	je     803371 <insert_sorted_with_merge_freeList+0x106>
  803361:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803364:	8b 00                	mov    (%eax),%eax
  803366:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803369:	8b 52 04             	mov    0x4(%edx),%edx
  80336c:	89 50 04             	mov    %edx,0x4(%eax)
  80336f:	eb 0b                	jmp    80337c <insert_sorted_with_merge_freeList+0x111>
  803371:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803374:	8b 40 04             	mov    0x4(%eax),%eax
  803377:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80337c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80337f:	8b 40 04             	mov    0x4(%eax),%eax
  803382:	85 c0                	test   %eax,%eax
  803384:	74 0f                	je     803395 <insert_sorted_with_merge_freeList+0x12a>
  803386:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803389:	8b 40 04             	mov    0x4(%eax),%eax
  80338c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80338f:	8b 12                	mov    (%edx),%edx
  803391:	89 10                	mov    %edx,(%eax)
  803393:	eb 0a                	jmp    80339f <insert_sorted_with_merge_freeList+0x134>
  803395:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803398:	8b 00                	mov    (%eax),%eax
  80339a:	a3 38 51 80 00       	mov    %eax,0x805138
  80339f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033ab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033b2:	a1 44 51 80 00       	mov    0x805144,%eax
  8033b7:	48                   	dec    %eax
  8033b8:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  8033bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033c0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  8033c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033ca:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  8033d1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8033d5:	75 17                	jne    8033ee <insert_sorted_with_merge_freeList+0x183>
  8033d7:	83 ec 04             	sub    $0x4,%esp
  8033da:	68 98 45 80 00       	push   $0x804598
  8033df:	68 3f 01 00 00       	push   $0x13f
  8033e4:	68 bb 45 80 00       	push   $0x8045bb
  8033e9:	e8 1e d5 ff ff       	call   80090c <_panic>
  8033ee:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8033f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033f7:	89 10                	mov    %edx,(%eax)
  8033f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033fc:	8b 00                	mov    (%eax),%eax
  8033fe:	85 c0                	test   %eax,%eax
  803400:	74 0d                	je     80340f <insert_sorted_with_merge_freeList+0x1a4>
  803402:	a1 48 51 80 00       	mov    0x805148,%eax
  803407:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80340a:	89 50 04             	mov    %edx,0x4(%eax)
  80340d:	eb 08                	jmp    803417 <insert_sorted_with_merge_freeList+0x1ac>
  80340f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803412:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803417:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80341a:	a3 48 51 80 00       	mov    %eax,0x805148
  80341f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803422:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803429:	a1 54 51 80 00       	mov    0x805154,%eax
  80342e:	40                   	inc    %eax
  80342f:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803434:	e9 7a 05 00 00       	jmp    8039b3 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  803439:	8b 45 08             	mov    0x8(%ebp),%eax
  80343c:	8b 50 08             	mov    0x8(%eax),%edx
  80343f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803442:	8b 40 08             	mov    0x8(%eax),%eax
  803445:	39 c2                	cmp    %eax,%edx
  803447:	0f 82 14 01 00 00    	jb     803561 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  80344d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803450:	8b 50 08             	mov    0x8(%eax),%edx
  803453:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803456:	8b 40 0c             	mov    0xc(%eax),%eax
  803459:	01 c2                	add    %eax,%edx
  80345b:	8b 45 08             	mov    0x8(%ebp),%eax
  80345e:	8b 40 08             	mov    0x8(%eax),%eax
  803461:	39 c2                	cmp    %eax,%edx
  803463:	0f 85 90 00 00 00    	jne    8034f9 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  803469:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80346c:	8b 50 0c             	mov    0xc(%eax),%edx
  80346f:	8b 45 08             	mov    0x8(%ebp),%eax
  803472:	8b 40 0c             	mov    0xc(%eax),%eax
  803475:	01 c2                	add    %eax,%edx
  803477:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80347a:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  80347d:	8b 45 08             	mov    0x8(%ebp),%eax
  803480:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  803487:	8b 45 08             	mov    0x8(%ebp),%eax
  80348a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803491:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803495:	75 17                	jne    8034ae <insert_sorted_with_merge_freeList+0x243>
  803497:	83 ec 04             	sub    $0x4,%esp
  80349a:	68 98 45 80 00       	push   $0x804598
  80349f:	68 49 01 00 00       	push   $0x149
  8034a4:	68 bb 45 80 00       	push   $0x8045bb
  8034a9:	e8 5e d4 ff ff       	call   80090c <_panic>
  8034ae:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8034b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b7:	89 10                	mov    %edx,(%eax)
  8034b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8034bc:	8b 00                	mov    (%eax),%eax
  8034be:	85 c0                	test   %eax,%eax
  8034c0:	74 0d                	je     8034cf <insert_sorted_with_merge_freeList+0x264>
  8034c2:	a1 48 51 80 00       	mov    0x805148,%eax
  8034c7:	8b 55 08             	mov    0x8(%ebp),%edx
  8034ca:	89 50 04             	mov    %edx,0x4(%eax)
  8034cd:	eb 08                	jmp    8034d7 <insert_sorted_with_merge_freeList+0x26c>
  8034cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8034d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8034da:	a3 48 51 80 00       	mov    %eax,0x805148
  8034df:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034e9:	a1 54 51 80 00       	mov    0x805154,%eax
  8034ee:	40                   	inc    %eax
  8034ef:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8034f4:	e9 bb 04 00 00       	jmp    8039b4 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  8034f9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034fd:	75 17                	jne    803516 <insert_sorted_with_merge_freeList+0x2ab>
  8034ff:	83 ec 04             	sub    $0x4,%esp
  803502:	68 0c 46 80 00       	push   $0x80460c
  803507:	68 4c 01 00 00       	push   $0x14c
  80350c:	68 bb 45 80 00       	push   $0x8045bb
  803511:	e8 f6 d3 ff ff       	call   80090c <_panic>
  803516:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  80351c:	8b 45 08             	mov    0x8(%ebp),%eax
  80351f:	89 50 04             	mov    %edx,0x4(%eax)
  803522:	8b 45 08             	mov    0x8(%ebp),%eax
  803525:	8b 40 04             	mov    0x4(%eax),%eax
  803528:	85 c0                	test   %eax,%eax
  80352a:	74 0c                	je     803538 <insert_sorted_with_merge_freeList+0x2cd>
  80352c:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803531:	8b 55 08             	mov    0x8(%ebp),%edx
  803534:	89 10                	mov    %edx,(%eax)
  803536:	eb 08                	jmp    803540 <insert_sorted_with_merge_freeList+0x2d5>
  803538:	8b 45 08             	mov    0x8(%ebp),%eax
  80353b:	a3 38 51 80 00       	mov    %eax,0x805138
  803540:	8b 45 08             	mov    0x8(%ebp),%eax
  803543:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803548:	8b 45 08             	mov    0x8(%ebp),%eax
  80354b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803551:	a1 44 51 80 00       	mov    0x805144,%eax
  803556:	40                   	inc    %eax
  803557:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80355c:	e9 53 04 00 00       	jmp    8039b4 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803561:	a1 38 51 80 00       	mov    0x805138,%eax
  803566:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803569:	e9 15 04 00 00       	jmp    803983 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  80356e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803571:	8b 00                	mov    (%eax),%eax
  803573:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803576:	8b 45 08             	mov    0x8(%ebp),%eax
  803579:	8b 50 08             	mov    0x8(%eax),%edx
  80357c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80357f:	8b 40 08             	mov    0x8(%eax),%eax
  803582:	39 c2                	cmp    %eax,%edx
  803584:	0f 86 f1 03 00 00    	jbe    80397b <insert_sorted_with_merge_freeList+0x710>
  80358a:	8b 45 08             	mov    0x8(%ebp),%eax
  80358d:	8b 50 08             	mov    0x8(%eax),%edx
  803590:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803593:	8b 40 08             	mov    0x8(%eax),%eax
  803596:	39 c2                	cmp    %eax,%edx
  803598:	0f 83 dd 03 00 00    	jae    80397b <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  80359e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035a1:	8b 50 08             	mov    0x8(%eax),%edx
  8035a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035a7:	8b 40 0c             	mov    0xc(%eax),%eax
  8035aa:	01 c2                	add    %eax,%edx
  8035ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8035af:	8b 40 08             	mov    0x8(%eax),%eax
  8035b2:	39 c2                	cmp    %eax,%edx
  8035b4:	0f 85 b9 01 00 00    	jne    803773 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8035ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8035bd:	8b 50 08             	mov    0x8(%eax),%edx
  8035c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c3:	8b 40 0c             	mov    0xc(%eax),%eax
  8035c6:	01 c2                	add    %eax,%edx
  8035c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035cb:	8b 40 08             	mov    0x8(%eax),%eax
  8035ce:	39 c2                	cmp    %eax,%edx
  8035d0:	0f 85 0d 01 00 00    	jne    8036e3 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  8035d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035d9:	8b 50 0c             	mov    0xc(%eax),%edx
  8035dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035df:	8b 40 0c             	mov    0xc(%eax),%eax
  8035e2:	01 c2                	add    %eax,%edx
  8035e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035e7:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8035ea:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8035ee:	75 17                	jne    803607 <insert_sorted_with_merge_freeList+0x39c>
  8035f0:	83 ec 04             	sub    $0x4,%esp
  8035f3:	68 64 46 80 00       	push   $0x804664
  8035f8:	68 5c 01 00 00       	push   $0x15c
  8035fd:	68 bb 45 80 00       	push   $0x8045bb
  803602:	e8 05 d3 ff ff       	call   80090c <_panic>
  803607:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80360a:	8b 00                	mov    (%eax),%eax
  80360c:	85 c0                	test   %eax,%eax
  80360e:	74 10                	je     803620 <insert_sorted_with_merge_freeList+0x3b5>
  803610:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803613:	8b 00                	mov    (%eax),%eax
  803615:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803618:	8b 52 04             	mov    0x4(%edx),%edx
  80361b:	89 50 04             	mov    %edx,0x4(%eax)
  80361e:	eb 0b                	jmp    80362b <insert_sorted_with_merge_freeList+0x3c0>
  803620:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803623:	8b 40 04             	mov    0x4(%eax),%eax
  803626:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80362b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80362e:	8b 40 04             	mov    0x4(%eax),%eax
  803631:	85 c0                	test   %eax,%eax
  803633:	74 0f                	je     803644 <insert_sorted_with_merge_freeList+0x3d9>
  803635:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803638:	8b 40 04             	mov    0x4(%eax),%eax
  80363b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80363e:	8b 12                	mov    (%edx),%edx
  803640:	89 10                	mov    %edx,(%eax)
  803642:	eb 0a                	jmp    80364e <insert_sorted_with_merge_freeList+0x3e3>
  803644:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803647:	8b 00                	mov    (%eax),%eax
  803649:	a3 38 51 80 00       	mov    %eax,0x805138
  80364e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803651:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803657:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80365a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803661:	a1 44 51 80 00       	mov    0x805144,%eax
  803666:	48                   	dec    %eax
  803667:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  80366c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80366f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803676:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803679:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803680:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803684:	75 17                	jne    80369d <insert_sorted_with_merge_freeList+0x432>
  803686:	83 ec 04             	sub    $0x4,%esp
  803689:	68 98 45 80 00       	push   $0x804598
  80368e:	68 5f 01 00 00       	push   $0x15f
  803693:	68 bb 45 80 00       	push   $0x8045bb
  803698:	e8 6f d2 ff ff       	call   80090c <_panic>
  80369d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8036a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036a6:	89 10                	mov    %edx,(%eax)
  8036a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036ab:	8b 00                	mov    (%eax),%eax
  8036ad:	85 c0                	test   %eax,%eax
  8036af:	74 0d                	je     8036be <insert_sorted_with_merge_freeList+0x453>
  8036b1:	a1 48 51 80 00       	mov    0x805148,%eax
  8036b6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8036b9:	89 50 04             	mov    %edx,0x4(%eax)
  8036bc:	eb 08                	jmp    8036c6 <insert_sorted_with_merge_freeList+0x45b>
  8036be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036c1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8036c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036c9:	a3 48 51 80 00       	mov    %eax,0x805148
  8036ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036d1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036d8:	a1 54 51 80 00       	mov    0x805154,%eax
  8036dd:	40                   	inc    %eax
  8036de:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  8036e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036e6:	8b 50 0c             	mov    0xc(%eax),%edx
  8036e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ec:	8b 40 0c             	mov    0xc(%eax),%eax
  8036ef:	01 c2                	add    %eax,%edx
  8036f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036f4:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8036f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8036fa:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803701:	8b 45 08             	mov    0x8(%ebp),%eax
  803704:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80370b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80370f:	75 17                	jne    803728 <insert_sorted_with_merge_freeList+0x4bd>
  803711:	83 ec 04             	sub    $0x4,%esp
  803714:	68 98 45 80 00       	push   $0x804598
  803719:	68 64 01 00 00       	push   $0x164
  80371e:	68 bb 45 80 00       	push   $0x8045bb
  803723:	e8 e4 d1 ff ff       	call   80090c <_panic>
  803728:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80372e:	8b 45 08             	mov    0x8(%ebp),%eax
  803731:	89 10                	mov    %edx,(%eax)
  803733:	8b 45 08             	mov    0x8(%ebp),%eax
  803736:	8b 00                	mov    (%eax),%eax
  803738:	85 c0                	test   %eax,%eax
  80373a:	74 0d                	je     803749 <insert_sorted_with_merge_freeList+0x4de>
  80373c:	a1 48 51 80 00       	mov    0x805148,%eax
  803741:	8b 55 08             	mov    0x8(%ebp),%edx
  803744:	89 50 04             	mov    %edx,0x4(%eax)
  803747:	eb 08                	jmp    803751 <insert_sorted_with_merge_freeList+0x4e6>
  803749:	8b 45 08             	mov    0x8(%ebp),%eax
  80374c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803751:	8b 45 08             	mov    0x8(%ebp),%eax
  803754:	a3 48 51 80 00       	mov    %eax,0x805148
  803759:	8b 45 08             	mov    0x8(%ebp),%eax
  80375c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803763:	a1 54 51 80 00       	mov    0x805154,%eax
  803768:	40                   	inc    %eax
  803769:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80376e:	e9 41 02 00 00       	jmp    8039b4 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803773:	8b 45 08             	mov    0x8(%ebp),%eax
  803776:	8b 50 08             	mov    0x8(%eax),%edx
  803779:	8b 45 08             	mov    0x8(%ebp),%eax
  80377c:	8b 40 0c             	mov    0xc(%eax),%eax
  80377f:	01 c2                	add    %eax,%edx
  803781:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803784:	8b 40 08             	mov    0x8(%eax),%eax
  803787:	39 c2                	cmp    %eax,%edx
  803789:	0f 85 7c 01 00 00    	jne    80390b <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  80378f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803793:	74 06                	je     80379b <insert_sorted_with_merge_freeList+0x530>
  803795:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803799:	75 17                	jne    8037b2 <insert_sorted_with_merge_freeList+0x547>
  80379b:	83 ec 04             	sub    $0x4,%esp
  80379e:	68 d4 45 80 00       	push   $0x8045d4
  8037a3:	68 69 01 00 00       	push   $0x169
  8037a8:	68 bb 45 80 00       	push   $0x8045bb
  8037ad:	e8 5a d1 ff ff       	call   80090c <_panic>
  8037b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037b5:	8b 50 04             	mov    0x4(%eax),%edx
  8037b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8037bb:	89 50 04             	mov    %edx,0x4(%eax)
  8037be:	8b 45 08             	mov    0x8(%ebp),%eax
  8037c1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8037c4:	89 10                	mov    %edx,(%eax)
  8037c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037c9:	8b 40 04             	mov    0x4(%eax),%eax
  8037cc:	85 c0                	test   %eax,%eax
  8037ce:	74 0d                	je     8037dd <insert_sorted_with_merge_freeList+0x572>
  8037d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037d3:	8b 40 04             	mov    0x4(%eax),%eax
  8037d6:	8b 55 08             	mov    0x8(%ebp),%edx
  8037d9:	89 10                	mov    %edx,(%eax)
  8037db:	eb 08                	jmp    8037e5 <insert_sorted_with_merge_freeList+0x57a>
  8037dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8037e0:	a3 38 51 80 00       	mov    %eax,0x805138
  8037e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8037eb:	89 50 04             	mov    %edx,0x4(%eax)
  8037ee:	a1 44 51 80 00       	mov    0x805144,%eax
  8037f3:	40                   	inc    %eax
  8037f4:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  8037f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8037fc:	8b 50 0c             	mov    0xc(%eax),%edx
  8037ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803802:	8b 40 0c             	mov    0xc(%eax),%eax
  803805:	01 c2                	add    %eax,%edx
  803807:	8b 45 08             	mov    0x8(%ebp),%eax
  80380a:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80380d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803811:	75 17                	jne    80382a <insert_sorted_with_merge_freeList+0x5bf>
  803813:	83 ec 04             	sub    $0x4,%esp
  803816:	68 64 46 80 00       	push   $0x804664
  80381b:	68 6b 01 00 00       	push   $0x16b
  803820:	68 bb 45 80 00       	push   $0x8045bb
  803825:	e8 e2 d0 ff ff       	call   80090c <_panic>
  80382a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80382d:	8b 00                	mov    (%eax),%eax
  80382f:	85 c0                	test   %eax,%eax
  803831:	74 10                	je     803843 <insert_sorted_with_merge_freeList+0x5d8>
  803833:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803836:	8b 00                	mov    (%eax),%eax
  803838:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80383b:	8b 52 04             	mov    0x4(%edx),%edx
  80383e:	89 50 04             	mov    %edx,0x4(%eax)
  803841:	eb 0b                	jmp    80384e <insert_sorted_with_merge_freeList+0x5e3>
  803843:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803846:	8b 40 04             	mov    0x4(%eax),%eax
  803849:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80384e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803851:	8b 40 04             	mov    0x4(%eax),%eax
  803854:	85 c0                	test   %eax,%eax
  803856:	74 0f                	je     803867 <insert_sorted_with_merge_freeList+0x5fc>
  803858:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80385b:	8b 40 04             	mov    0x4(%eax),%eax
  80385e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803861:	8b 12                	mov    (%edx),%edx
  803863:	89 10                	mov    %edx,(%eax)
  803865:	eb 0a                	jmp    803871 <insert_sorted_with_merge_freeList+0x606>
  803867:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80386a:	8b 00                	mov    (%eax),%eax
  80386c:	a3 38 51 80 00       	mov    %eax,0x805138
  803871:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803874:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80387a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80387d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803884:	a1 44 51 80 00       	mov    0x805144,%eax
  803889:	48                   	dec    %eax
  80388a:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  80388f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803892:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803899:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80389c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8038a3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8038a7:	75 17                	jne    8038c0 <insert_sorted_with_merge_freeList+0x655>
  8038a9:	83 ec 04             	sub    $0x4,%esp
  8038ac:	68 98 45 80 00       	push   $0x804598
  8038b1:	68 6e 01 00 00       	push   $0x16e
  8038b6:	68 bb 45 80 00       	push   $0x8045bb
  8038bb:	e8 4c d0 ff ff       	call   80090c <_panic>
  8038c0:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8038c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038c9:	89 10                	mov    %edx,(%eax)
  8038cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038ce:	8b 00                	mov    (%eax),%eax
  8038d0:	85 c0                	test   %eax,%eax
  8038d2:	74 0d                	je     8038e1 <insert_sorted_with_merge_freeList+0x676>
  8038d4:	a1 48 51 80 00       	mov    0x805148,%eax
  8038d9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8038dc:	89 50 04             	mov    %edx,0x4(%eax)
  8038df:	eb 08                	jmp    8038e9 <insert_sorted_with_merge_freeList+0x67e>
  8038e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038e4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8038e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038ec:	a3 48 51 80 00       	mov    %eax,0x805148
  8038f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038f4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038fb:	a1 54 51 80 00       	mov    0x805154,%eax
  803900:	40                   	inc    %eax
  803901:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803906:	e9 a9 00 00 00       	jmp    8039b4 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  80390b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80390f:	74 06                	je     803917 <insert_sorted_with_merge_freeList+0x6ac>
  803911:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803915:	75 17                	jne    80392e <insert_sorted_with_merge_freeList+0x6c3>
  803917:	83 ec 04             	sub    $0x4,%esp
  80391a:	68 30 46 80 00       	push   $0x804630
  80391f:	68 73 01 00 00       	push   $0x173
  803924:	68 bb 45 80 00       	push   $0x8045bb
  803929:	e8 de cf ff ff       	call   80090c <_panic>
  80392e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803931:	8b 10                	mov    (%eax),%edx
  803933:	8b 45 08             	mov    0x8(%ebp),%eax
  803936:	89 10                	mov    %edx,(%eax)
  803938:	8b 45 08             	mov    0x8(%ebp),%eax
  80393b:	8b 00                	mov    (%eax),%eax
  80393d:	85 c0                	test   %eax,%eax
  80393f:	74 0b                	je     80394c <insert_sorted_with_merge_freeList+0x6e1>
  803941:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803944:	8b 00                	mov    (%eax),%eax
  803946:	8b 55 08             	mov    0x8(%ebp),%edx
  803949:	89 50 04             	mov    %edx,0x4(%eax)
  80394c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80394f:	8b 55 08             	mov    0x8(%ebp),%edx
  803952:	89 10                	mov    %edx,(%eax)
  803954:	8b 45 08             	mov    0x8(%ebp),%eax
  803957:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80395a:	89 50 04             	mov    %edx,0x4(%eax)
  80395d:	8b 45 08             	mov    0x8(%ebp),%eax
  803960:	8b 00                	mov    (%eax),%eax
  803962:	85 c0                	test   %eax,%eax
  803964:	75 08                	jne    80396e <insert_sorted_with_merge_freeList+0x703>
  803966:	8b 45 08             	mov    0x8(%ebp),%eax
  803969:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80396e:	a1 44 51 80 00       	mov    0x805144,%eax
  803973:	40                   	inc    %eax
  803974:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803979:	eb 39                	jmp    8039b4 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80397b:	a1 40 51 80 00       	mov    0x805140,%eax
  803980:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803983:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803987:	74 07                	je     803990 <insert_sorted_with_merge_freeList+0x725>
  803989:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80398c:	8b 00                	mov    (%eax),%eax
  80398e:	eb 05                	jmp    803995 <insert_sorted_with_merge_freeList+0x72a>
  803990:	b8 00 00 00 00       	mov    $0x0,%eax
  803995:	a3 40 51 80 00       	mov    %eax,0x805140
  80399a:	a1 40 51 80 00       	mov    0x805140,%eax
  80399f:	85 c0                	test   %eax,%eax
  8039a1:	0f 85 c7 fb ff ff    	jne    80356e <insert_sorted_with_merge_freeList+0x303>
  8039a7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8039ab:	0f 85 bd fb ff ff    	jne    80356e <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8039b1:	eb 01                	jmp    8039b4 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8039b3:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8039b4:	90                   	nop
  8039b5:	c9                   	leave  
  8039b6:	c3                   	ret    
  8039b7:	90                   	nop

008039b8 <__udivdi3>:
  8039b8:	55                   	push   %ebp
  8039b9:	57                   	push   %edi
  8039ba:	56                   	push   %esi
  8039bb:	53                   	push   %ebx
  8039bc:	83 ec 1c             	sub    $0x1c,%esp
  8039bf:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8039c3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8039c7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8039cb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8039cf:	89 ca                	mov    %ecx,%edx
  8039d1:	89 f8                	mov    %edi,%eax
  8039d3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8039d7:	85 f6                	test   %esi,%esi
  8039d9:	75 2d                	jne    803a08 <__udivdi3+0x50>
  8039db:	39 cf                	cmp    %ecx,%edi
  8039dd:	77 65                	ja     803a44 <__udivdi3+0x8c>
  8039df:	89 fd                	mov    %edi,%ebp
  8039e1:	85 ff                	test   %edi,%edi
  8039e3:	75 0b                	jne    8039f0 <__udivdi3+0x38>
  8039e5:	b8 01 00 00 00       	mov    $0x1,%eax
  8039ea:	31 d2                	xor    %edx,%edx
  8039ec:	f7 f7                	div    %edi
  8039ee:	89 c5                	mov    %eax,%ebp
  8039f0:	31 d2                	xor    %edx,%edx
  8039f2:	89 c8                	mov    %ecx,%eax
  8039f4:	f7 f5                	div    %ebp
  8039f6:	89 c1                	mov    %eax,%ecx
  8039f8:	89 d8                	mov    %ebx,%eax
  8039fa:	f7 f5                	div    %ebp
  8039fc:	89 cf                	mov    %ecx,%edi
  8039fe:	89 fa                	mov    %edi,%edx
  803a00:	83 c4 1c             	add    $0x1c,%esp
  803a03:	5b                   	pop    %ebx
  803a04:	5e                   	pop    %esi
  803a05:	5f                   	pop    %edi
  803a06:	5d                   	pop    %ebp
  803a07:	c3                   	ret    
  803a08:	39 ce                	cmp    %ecx,%esi
  803a0a:	77 28                	ja     803a34 <__udivdi3+0x7c>
  803a0c:	0f bd fe             	bsr    %esi,%edi
  803a0f:	83 f7 1f             	xor    $0x1f,%edi
  803a12:	75 40                	jne    803a54 <__udivdi3+0x9c>
  803a14:	39 ce                	cmp    %ecx,%esi
  803a16:	72 0a                	jb     803a22 <__udivdi3+0x6a>
  803a18:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803a1c:	0f 87 9e 00 00 00    	ja     803ac0 <__udivdi3+0x108>
  803a22:	b8 01 00 00 00       	mov    $0x1,%eax
  803a27:	89 fa                	mov    %edi,%edx
  803a29:	83 c4 1c             	add    $0x1c,%esp
  803a2c:	5b                   	pop    %ebx
  803a2d:	5e                   	pop    %esi
  803a2e:	5f                   	pop    %edi
  803a2f:	5d                   	pop    %ebp
  803a30:	c3                   	ret    
  803a31:	8d 76 00             	lea    0x0(%esi),%esi
  803a34:	31 ff                	xor    %edi,%edi
  803a36:	31 c0                	xor    %eax,%eax
  803a38:	89 fa                	mov    %edi,%edx
  803a3a:	83 c4 1c             	add    $0x1c,%esp
  803a3d:	5b                   	pop    %ebx
  803a3e:	5e                   	pop    %esi
  803a3f:	5f                   	pop    %edi
  803a40:	5d                   	pop    %ebp
  803a41:	c3                   	ret    
  803a42:	66 90                	xchg   %ax,%ax
  803a44:	89 d8                	mov    %ebx,%eax
  803a46:	f7 f7                	div    %edi
  803a48:	31 ff                	xor    %edi,%edi
  803a4a:	89 fa                	mov    %edi,%edx
  803a4c:	83 c4 1c             	add    $0x1c,%esp
  803a4f:	5b                   	pop    %ebx
  803a50:	5e                   	pop    %esi
  803a51:	5f                   	pop    %edi
  803a52:	5d                   	pop    %ebp
  803a53:	c3                   	ret    
  803a54:	bd 20 00 00 00       	mov    $0x20,%ebp
  803a59:	89 eb                	mov    %ebp,%ebx
  803a5b:	29 fb                	sub    %edi,%ebx
  803a5d:	89 f9                	mov    %edi,%ecx
  803a5f:	d3 e6                	shl    %cl,%esi
  803a61:	89 c5                	mov    %eax,%ebp
  803a63:	88 d9                	mov    %bl,%cl
  803a65:	d3 ed                	shr    %cl,%ebp
  803a67:	89 e9                	mov    %ebp,%ecx
  803a69:	09 f1                	or     %esi,%ecx
  803a6b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803a6f:	89 f9                	mov    %edi,%ecx
  803a71:	d3 e0                	shl    %cl,%eax
  803a73:	89 c5                	mov    %eax,%ebp
  803a75:	89 d6                	mov    %edx,%esi
  803a77:	88 d9                	mov    %bl,%cl
  803a79:	d3 ee                	shr    %cl,%esi
  803a7b:	89 f9                	mov    %edi,%ecx
  803a7d:	d3 e2                	shl    %cl,%edx
  803a7f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a83:	88 d9                	mov    %bl,%cl
  803a85:	d3 e8                	shr    %cl,%eax
  803a87:	09 c2                	or     %eax,%edx
  803a89:	89 d0                	mov    %edx,%eax
  803a8b:	89 f2                	mov    %esi,%edx
  803a8d:	f7 74 24 0c          	divl   0xc(%esp)
  803a91:	89 d6                	mov    %edx,%esi
  803a93:	89 c3                	mov    %eax,%ebx
  803a95:	f7 e5                	mul    %ebp
  803a97:	39 d6                	cmp    %edx,%esi
  803a99:	72 19                	jb     803ab4 <__udivdi3+0xfc>
  803a9b:	74 0b                	je     803aa8 <__udivdi3+0xf0>
  803a9d:	89 d8                	mov    %ebx,%eax
  803a9f:	31 ff                	xor    %edi,%edi
  803aa1:	e9 58 ff ff ff       	jmp    8039fe <__udivdi3+0x46>
  803aa6:	66 90                	xchg   %ax,%ax
  803aa8:	8b 54 24 08          	mov    0x8(%esp),%edx
  803aac:	89 f9                	mov    %edi,%ecx
  803aae:	d3 e2                	shl    %cl,%edx
  803ab0:	39 c2                	cmp    %eax,%edx
  803ab2:	73 e9                	jae    803a9d <__udivdi3+0xe5>
  803ab4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803ab7:	31 ff                	xor    %edi,%edi
  803ab9:	e9 40 ff ff ff       	jmp    8039fe <__udivdi3+0x46>
  803abe:	66 90                	xchg   %ax,%ax
  803ac0:	31 c0                	xor    %eax,%eax
  803ac2:	e9 37 ff ff ff       	jmp    8039fe <__udivdi3+0x46>
  803ac7:	90                   	nop

00803ac8 <__umoddi3>:
  803ac8:	55                   	push   %ebp
  803ac9:	57                   	push   %edi
  803aca:	56                   	push   %esi
  803acb:	53                   	push   %ebx
  803acc:	83 ec 1c             	sub    $0x1c,%esp
  803acf:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803ad3:	8b 74 24 34          	mov    0x34(%esp),%esi
  803ad7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803adb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803adf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803ae3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803ae7:	89 f3                	mov    %esi,%ebx
  803ae9:	89 fa                	mov    %edi,%edx
  803aeb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803aef:	89 34 24             	mov    %esi,(%esp)
  803af2:	85 c0                	test   %eax,%eax
  803af4:	75 1a                	jne    803b10 <__umoddi3+0x48>
  803af6:	39 f7                	cmp    %esi,%edi
  803af8:	0f 86 a2 00 00 00    	jbe    803ba0 <__umoddi3+0xd8>
  803afe:	89 c8                	mov    %ecx,%eax
  803b00:	89 f2                	mov    %esi,%edx
  803b02:	f7 f7                	div    %edi
  803b04:	89 d0                	mov    %edx,%eax
  803b06:	31 d2                	xor    %edx,%edx
  803b08:	83 c4 1c             	add    $0x1c,%esp
  803b0b:	5b                   	pop    %ebx
  803b0c:	5e                   	pop    %esi
  803b0d:	5f                   	pop    %edi
  803b0e:	5d                   	pop    %ebp
  803b0f:	c3                   	ret    
  803b10:	39 f0                	cmp    %esi,%eax
  803b12:	0f 87 ac 00 00 00    	ja     803bc4 <__umoddi3+0xfc>
  803b18:	0f bd e8             	bsr    %eax,%ebp
  803b1b:	83 f5 1f             	xor    $0x1f,%ebp
  803b1e:	0f 84 ac 00 00 00    	je     803bd0 <__umoddi3+0x108>
  803b24:	bf 20 00 00 00       	mov    $0x20,%edi
  803b29:	29 ef                	sub    %ebp,%edi
  803b2b:	89 fe                	mov    %edi,%esi
  803b2d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803b31:	89 e9                	mov    %ebp,%ecx
  803b33:	d3 e0                	shl    %cl,%eax
  803b35:	89 d7                	mov    %edx,%edi
  803b37:	89 f1                	mov    %esi,%ecx
  803b39:	d3 ef                	shr    %cl,%edi
  803b3b:	09 c7                	or     %eax,%edi
  803b3d:	89 e9                	mov    %ebp,%ecx
  803b3f:	d3 e2                	shl    %cl,%edx
  803b41:	89 14 24             	mov    %edx,(%esp)
  803b44:	89 d8                	mov    %ebx,%eax
  803b46:	d3 e0                	shl    %cl,%eax
  803b48:	89 c2                	mov    %eax,%edx
  803b4a:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b4e:	d3 e0                	shl    %cl,%eax
  803b50:	89 44 24 04          	mov    %eax,0x4(%esp)
  803b54:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b58:	89 f1                	mov    %esi,%ecx
  803b5a:	d3 e8                	shr    %cl,%eax
  803b5c:	09 d0                	or     %edx,%eax
  803b5e:	d3 eb                	shr    %cl,%ebx
  803b60:	89 da                	mov    %ebx,%edx
  803b62:	f7 f7                	div    %edi
  803b64:	89 d3                	mov    %edx,%ebx
  803b66:	f7 24 24             	mull   (%esp)
  803b69:	89 c6                	mov    %eax,%esi
  803b6b:	89 d1                	mov    %edx,%ecx
  803b6d:	39 d3                	cmp    %edx,%ebx
  803b6f:	0f 82 87 00 00 00    	jb     803bfc <__umoddi3+0x134>
  803b75:	0f 84 91 00 00 00    	je     803c0c <__umoddi3+0x144>
  803b7b:	8b 54 24 04          	mov    0x4(%esp),%edx
  803b7f:	29 f2                	sub    %esi,%edx
  803b81:	19 cb                	sbb    %ecx,%ebx
  803b83:	89 d8                	mov    %ebx,%eax
  803b85:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803b89:	d3 e0                	shl    %cl,%eax
  803b8b:	89 e9                	mov    %ebp,%ecx
  803b8d:	d3 ea                	shr    %cl,%edx
  803b8f:	09 d0                	or     %edx,%eax
  803b91:	89 e9                	mov    %ebp,%ecx
  803b93:	d3 eb                	shr    %cl,%ebx
  803b95:	89 da                	mov    %ebx,%edx
  803b97:	83 c4 1c             	add    $0x1c,%esp
  803b9a:	5b                   	pop    %ebx
  803b9b:	5e                   	pop    %esi
  803b9c:	5f                   	pop    %edi
  803b9d:	5d                   	pop    %ebp
  803b9e:	c3                   	ret    
  803b9f:	90                   	nop
  803ba0:	89 fd                	mov    %edi,%ebp
  803ba2:	85 ff                	test   %edi,%edi
  803ba4:	75 0b                	jne    803bb1 <__umoddi3+0xe9>
  803ba6:	b8 01 00 00 00       	mov    $0x1,%eax
  803bab:	31 d2                	xor    %edx,%edx
  803bad:	f7 f7                	div    %edi
  803baf:	89 c5                	mov    %eax,%ebp
  803bb1:	89 f0                	mov    %esi,%eax
  803bb3:	31 d2                	xor    %edx,%edx
  803bb5:	f7 f5                	div    %ebp
  803bb7:	89 c8                	mov    %ecx,%eax
  803bb9:	f7 f5                	div    %ebp
  803bbb:	89 d0                	mov    %edx,%eax
  803bbd:	e9 44 ff ff ff       	jmp    803b06 <__umoddi3+0x3e>
  803bc2:	66 90                	xchg   %ax,%ax
  803bc4:	89 c8                	mov    %ecx,%eax
  803bc6:	89 f2                	mov    %esi,%edx
  803bc8:	83 c4 1c             	add    $0x1c,%esp
  803bcb:	5b                   	pop    %ebx
  803bcc:	5e                   	pop    %esi
  803bcd:	5f                   	pop    %edi
  803bce:	5d                   	pop    %ebp
  803bcf:	c3                   	ret    
  803bd0:	3b 04 24             	cmp    (%esp),%eax
  803bd3:	72 06                	jb     803bdb <__umoddi3+0x113>
  803bd5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803bd9:	77 0f                	ja     803bea <__umoddi3+0x122>
  803bdb:	89 f2                	mov    %esi,%edx
  803bdd:	29 f9                	sub    %edi,%ecx
  803bdf:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803be3:	89 14 24             	mov    %edx,(%esp)
  803be6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803bea:	8b 44 24 04          	mov    0x4(%esp),%eax
  803bee:	8b 14 24             	mov    (%esp),%edx
  803bf1:	83 c4 1c             	add    $0x1c,%esp
  803bf4:	5b                   	pop    %ebx
  803bf5:	5e                   	pop    %esi
  803bf6:	5f                   	pop    %edi
  803bf7:	5d                   	pop    %ebp
  803bf8:	c3                   	ret    
  803bf9:	8d 76 00             	lea    0x0(%esi),%esi
  803bfc:	2b 04 24             	sub    (%esp),%eax
  803bff:	19 fa                	sbb    %edi,%edx
  803c01:	89 d1                	mov    %edx,%ecx
  803c03:	89 c6                	mov    %eax,%esi
  803c05:	e9 71 ff ff ff       	jmp    803b7b <__umoddi3+0xb3>
  803c0a:	66 90                	xchg   %ax,%ax
  803c0c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803c10:	72 ea                	jb     803bfc <__umoddi3+0x134>
  803c12:	89 d9                	mov    %ebx,%ecx
  803c14:	e9 62 ff ff ff       	jmp    803b7b <__umoddi3+0xb3>
