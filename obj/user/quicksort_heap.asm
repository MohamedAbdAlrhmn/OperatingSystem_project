
obj/user/quicksort_heap:     file format elf32-i386


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
  800031:	e8 1f 06 00 00       	call   800655 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
void QuickSort(int *Elements, int NumOfElements);
void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex);
uint32 CheckSorted(int *Elements, int NumOfElements);

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	char Line[255] ;
	char Chose ;
	do
	{
		//2012: lock the interrupt
		sys_disable_interrupt();
  800041:	e8 e7 1c 00 00       	call   801d2d <sys_disable_interrupt>
		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 20 24 80 00       	push   $0x802420
  80004e:	e8 f2 09 00 00       	call   800a45 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 22 24 80 00       	push   $0x802422
  80005e:	e8 e2 09 00 00       	call   800a45 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!   QUICK SORT   !!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 3b 24 80 00       	push   $0x80243b
  80006e:	e8 d2 09 00 00       	call   800a45 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 22 24 80 00       	push   $0x802422
  80007e:	e8 c2 09 00 00       	call   800a45 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 20 24 80 00       	push   $0x802420
  80008e:	e8 b2 09 00 00       	call   800a45 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp

		readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 54 24 80 00       	push   $0x802454
  8000a5:	e8 1d 10 00 00       	call   8010c7 <readline>
  8000aa:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = strtol(Line, NULL, 10) ;
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	6a 0a                	push   $0xa
  8000b2:	6a 00                	push   $0x0
  8000b4:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  8000ba:	50                   	push   %eax
  8000bb:	e8 6d 15 00 00       	call   80162d <strtol>
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  8000c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000c9:	c1 e0 02             	shl    $0x2,%eax
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	50                   	push   %eax
  8000d0:	e8 4b 19 00 00       	call   801a20 <malloc>
  8000d5:	83 c4 10             	add    $0x10,%esp
  8000d8:	89 45 ec             	mov    %eax,-0x14(%ebp)
		cprintf("Chose the initialization method:\n") ;
  8000db:	83 ec 0c             	sub    $0xc,%esp
  8000de:	68 74 24 80 00       	push   $0x802474
  8000e3:	e8 5d 09 00 00       	call   800a45 <cprintf>
  8000e8:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000eb:	83 ec 0c             	sub    $0xc,%esp
  8000ee:	68 96 24 80 00       	push   $0x802496
  8000f3:	e8 4d 09 00 00       	call   800a45 <cprintf>
  8000f8:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000fb:	83 ec 0c             	sub    $0xc,%esp
  8000fe:	68 a4 24 80 00       	push   $0x8024a4
  800103:	e8 3d 09 00 00       	call   800a45 <cprintf>
  800108:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 b3 24 80 00       	push   $0x8024b3
  800113:	e8 2d 09 00 00       	call   800a45 <cprintf>
  800118:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	68 c3 24 80 00       	push   $0x8024c3
  800123:	e8 1d 09 00 00       	call   800a45 <cprintf>
  800128:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  80012b:	e8 cd 04 00 00       	call   8005fd <getchar>
  800130:	88 45 f7             	mov    %al,-0x9(%ebp)
			cputchar(Chose);
  800133:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800137:	83 ec 0c             	sub    $0xc,%esp
  80013a:	50                   	push   %eax
  80013b:	e8 75 04 00 00       	call   8005b5 <cputchar>
  800140:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800143:	83 ec 0c             	sub    $0xc,%esp
  800146:	6a 0a                	push   $0xa
  800148:	e8 68 04 00 00       	call   8005b5 <cputchar>
  80014d:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800150:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  800154:	74 0c                	je     800162 <_main+0x12a>
  800156:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  80015a:	74 06                	je     800162 <_main+0x12a>
  80015c:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  800160:	75 b9                	jne    80011b <_main+0xe3>
		//2012: lock the interrupt
		sys_enable_interrupt();
  800162:	e8 e0 1b 00 00       	call   801d47 <sys_enable_interrupt>

		int  i ;
		switch (Chose)
  800167:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80016b:	83 f8 62             	cmp    $0x62,%eax
  80016e:	74 1d                	je     80018d <_main+0x155>
  800170:	83 f8 63             	cmp    $0x63,%eax
  800173:	74 2b                	je     8001a0 <_main+0x168>
  800175:	83 f8 61             	cmp    $0x61,%eax
  800178:	75 39                	jne    8001b3 <_main+0x17b>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  80017a:	83 ec 08             	sub    $0x8,%esp
  80017d:	ff 75 f0             	pushl  -0x10(%ebp)
  800180:	ff 75 ec             	pushl  -0x14(%ebp)
  800183:	e8 f5 02 00 00       	call   80047d <InitializeAscending>
  800188:	83 c4 10             	add    $0x10,%esp
			break ;
  80018b:	eb 37                	jmp    8001c4 <_main+0x18c>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  80018d:	83 ec 08             	sub    $0x8,%esp
  800190:	ff 75 f0             	pushl  -0x10(%ebp)
  800193:	ff 75 ec             	pushl  -0x14(%ebp)
  800196:	e8 13 03 00 00       	call   8004ae <InitializeDescending>
  80019b:	83 c4 10             	add    $0x10,%esp
			break ;
  80019e:	eb 24                	jmp    8001c4 <_main+0x18c>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001a0:	83 ec 08             	sub    $0x8,%esp
  8001a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8001a6:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a9:	e8 35 03 00 00       	call   8004e3 <InitializeSemiRandom>
  8001ae:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b1:	eb 11                	jmp    8001c4 <_main+0x18c>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001b3:	83 ec 08             	sub    $0x8,%esp
  8001b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8001b9:	ff 75 ec             	pushl  -0x14(%ebp)
  8001bc:	e8 22 03 00 00       	call   8004e3 <InitializeSemiRandom>
  8001c1:	83 c4 10             	add    $0x10,%esp
		}

		QuickSort(Elements, NumOfElements);
  8001c4:	83 ec 08             	sub    $0x8,%esp
  8001c7:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ca:	ff 75 ec             	pushl  -0x14(%ebp)
  8001cd:	e8 f0 00 00 00       	call   8002c2 <QuickSort>
  8001d2:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  8001d5:	e8 53 1b 00 00       	call   801d2d <sys_disable_interrupt>
			cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001da:	83 ec 0c             	sub    $0xc,%esp
  8001dd:	68 cc 24 80 00       	push   $0x8024cc
  8001e2:	e8 5e 08 00 00       	call   800a45 <cprintf>
  8001e7:	83 c4 10             	add    $0x10,%esp
		//		PrintElements(Elements, NumOfElements);
		sys_enable_interrupt();
  8001ea:	e8 58 1b 00 00       	call   801d47 <sys_enable_interrupt>

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001ef:	83 ec 08             	sub    $0x8,%esp
  8001f2:	ff 75 f0             	pushl  -0x10(%ebp)
  8001f5:	ff 75 ec             	pushl  -0x14(%ebp)
  8001f8:	e8 d6 01 00 00       	call   8003d3 <CheckSorted>
  8001fd:	83 c4 10             	add    $0x10,%esp
  800200:	89 45 e8             	mov    %eax,-0x18(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  800203:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800207:	75 14                	jne    80021d <_main+0x1e5>
  800209:	83 ec 04             	sub    $0x4,%esp
  80020c:	68 00 25 80 00       	push   $0x802500
  800211:	6a 48                	push   $0x48
  800213:	68 22 25 80 00       	push   $0x802522
  800218:	e8 74 05 00 00       	call   800791 <_panic>
		else
		{
			sys_disable_interrupt();
  80021d:	e8 0b 1b 00 00       	call   801d2d <sys_disable_interrupt>
			cprintf("\n===============================================\n") ;
  800222:	83 ec 0c             	sub    $0xc,%esp
  800225:	68 38 25 80 00       	push   $0x802538
  80022a:	e8 16 08 00 00       	call   800a45 <cprintf>
  80022f:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  800232:	83 ec 0c             	sub    $0xc,%esp
  800235:	68 6c 25 80 00       	push   $0x80256c
  80023a:	e8 06 08 00 00       	call   800a45 <cprintf>
  80023f:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  800242:	83 ec 0c             	sub    $0xc,%esp
  800245:	68 a0 25 80 00       	push   $0x8025a0
  80024a:	e8 f6 07 00 00       	call   800a45 <cprintf>
  80024f:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800252:	e8 f0 1a 00 00       	call   801d47 <sys_enable_interrupt>
		}

		sys_disable_interrupt();
  800257:	e8 d1 1a 00 00       	call   801d2d <sys_disable_interrupt>
			Chose = 0 ;
  80025c:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800260:	eb 42                	jmp    8002a4 <_main+0x26c>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800262:	83 ec 0c             	sub    $0xc,%esp
  800265:	68 d2 25 80 00       	push   $0x8025d2
  80026a:	e8 d6 07 00 00       	call   800a45 <cprintf>
  80026f:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  800272:	e8 86 03 00 00       	call   8005fd <getchar>
  800277:	88 45 f7             	mov    %al,-0x9(%ebp)
				cputchar(Chose);
  80027a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80027e:	83 ec 0c             	sub    $0xc,%esp
  800281:	50                   	push   %eax
  800282:	e8 2e 03 00 00       	call   8005b5 <cputchar>
  800287:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  80028a:	83 ec 0c             	sub    $0xc,%esp
  80028d:	6a 0a                	push   $0xa
  80028f:	e8 21 03 00 00       	call   8005b5 <cputchar>
  800294:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  800297:	83 ec 0c             	sub    $0xc,%esp
  80029a:	6a 0a                	push   $0xa
  80029c:	e8 14 03 00 00       	call   8005b5 <cputchar>
  8002a1:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
		}

		sys_disable_interrupt();
			Chose = 0 ;
			while (Chose != 'y' && Chose != 'n')
  8002a4:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002a8:	74 06                	je     8002b0 <_main+0x278>
  8002aa:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  8002ae:	75 b2                	jne    800262 <_main+0x22a>
				Chose = getchar() ;
				cputchar(Chose);
				cputchar('\n');
				cputchar('\n');
			}
		sys_enable_interrupt();
  8002b0:	e8 92 1a 00 00       	call   801d47 <sys_enable_interrupt>

	} while (Chose == 'y');
  8002b5:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002b9:	0f 84 82 fd ff ff    	je     800041 <_main+0x9>

}
  8002bf:	90                   	nop
  8002c0:	c9                   	leave  
  8002c1:	c3                   	ret    

008002c2 <QuickSort>:

///Quick sort
void QuickSort(int *Elements, int NumOfElements)
{
  8002c2:	55                   	push   %ebp
  8002c3:	89 e5                	mov    %esp,%ebp
  8002c5:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  8002c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002cb:	48                   	dec    %eax
  8002cc:	50                   	push   %eax
  8002cd:	6a 00                	push   $0x0
  8002cf:	ff 75 0c             	pushl  0xc(%ebp)
  8002d2:	ff 75 08             	pushl  0x8(%ebp)
  8002d5:	e8 06 00 00 00       	call   8002e0 <QSort>
  8002da:	83 c4 10             	add    $0x10,%esp
}
  8002dd:	90                   	nop
  8002de:	c9                   	leave  
  8002df:	c3                   	ret    

008002e0 <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  8002e0:	55                   	push   %ebp
  8002e1:	89 e5                	mov    %esp,%ebp
  8002e3:	83 ec 18             	sub    $0x18,%esp
	if (startIndex >= finalIndex) return;
  8002e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8002e9:	3b 45 14             	cmp    0x14(%ebp),%eax
  8002ec:	0f 8d de 00 00 00    	jge    8003d0 <QSort+0xf0>

	int i = startIndex+1, j = finalIndex;
  8002f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8002f5:	40                   	inc    %eax
  8002f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8002f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8002fc:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  8002ff:	e9 80 00 00 00       	jmp    800384 <QSort+0xa4>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  800304:	ff 45 f4             	incl   -0xc(%ebp)
  800307:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80030a:	3b 45 14             	cmp    0x14(%ebp),%eax
  80030d:	7f 2b                	jg     80033a <QSort+0x5a>
  80030f:	8b 45 10             	mov    0x10(%ebp),%eax
  800312:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800319:	8b 45 08             	mov    0x8(%ebp),%eax
  80031c:	01 d0                	add    %edx,%eax
  80031e:	8b 10                	mov    (%eax),%edx
  800320:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800323:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80032a:	8b 45 08             	mov    0x8(%ebp),%eax
  80032d:	01 c8                	add    %ecx,%eax
  80032f:	8b 00                	mov    (%eax),%eax
  800331:	39 c2                	cmp    %eax,%edx
  800333:	7d cf                	jge    800304 <QSort+0x24>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  800335:	eb 03                	jmp    80033a <QSort+0x5a>
  800337:	ff 4d f0             	decl   -0x10(%ebp)
  80033a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80033d:	3b 45 10             	cmp    0x10(%ebp),%eax
  800340:	7e 26                	jle    800368 <QSort+0x88>
  800342:	8b 45 10             	mov    0x10(%ebp),%eax
  800345:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80034c:	8b 45 08             	mov    0x8(%ebp),%eax
  80034f:	01 d0                	add    %edx,%eax
  800351:	8b 10                	mov    (%eax),%edx
  800353:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800356:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80035d:	8b 45 08             	mov    0x8(%ebp),%eax
  800360:	01 c8                	add    %ecx,%eax
  800362:	8b 00                	mov    (%eax),%eax
  800364:	39 c2                	cmp    %eax,%edx
  800366:	7e cf                	jle    800337 <QSort+0x57>

		if (i <= j)
  800368:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80036b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80036e:	7f 14                	jg     800384 <QSort+0xa4>
		{
			Swap(Elements, i, j);
  800370:	83 ec 04             	sub    $0x4,%esp
  800373:	ff 75 f0             	pushl  -0x10(%ebp)
  800376:	ff 75 f4             	pushl  -0xc(%ebp)
  800379:	ff 75 08             	pushl  0x8(%ebp)
  80037c:	e8 a9 00 00 00       	call   80042a <Swap>
  800381:	83 c4 10             	add    $0x10,%esp
{
	if (startIndex >= finalIndex) return;

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  800384:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800387:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80038a:	0f 8e 77 ff ff ff    	jle    800307 <QSort+0x27>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  800390:	83 ec 04             	sub    $0x4,%esp
  800393:	ff 75 f0             	pushl  -0x10(%ebp)
  800396:	ff 75 10             	pushl  0x10(%ebp)
  800399:	ff 75 08             	pushl  0x8(%ebp)
  80039c:	e8 89 00 00 00       	call   80042a <Swap>
  8003a1:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  8003a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003a7:	48                   	dec    %eax
  8003a8:	50                   	push   %eax
  8003a9:	ff 75 10             	pushl  0x10(%ebp)
  8003ac:	ff 75 0c             	pushl  0xc(%ebp)
  8003af:	ff 75 08             	pushl  0x8(%ebp)
  8003b2:	e8 29 ff ff ff       	call   8002e0 <QSort>
  8003b7:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  8003ba:	ff 75 14             	pushl  0x14(%ebp)
  8003bd:	ff 75 f4             	pushl  -0xc(%ebp)
  8003c0:	ff 75 0c             	pushl  0xc(%ebp)
  8003c3:	ff 75 08             	pushl  0x8(%ebp)
  8003c6:	e8 15 ff ff ff       	call   8002e0 <QSort>
  8003cb:	83 c4 10             	add    $0x10,%esp
  8003ce:	eb 01                	jmp    8003d1 <QSort+0xf1>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  8003d0:	90                   	nop
	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);

	//cprintf("qs,after sorting: start = %d, end = %d\n", startIndex, finalIndex);

}
  8003d1:	c9                   	leave  
  8003d2:	c3                   	ret    

008003d3 <CheckSorted>:

uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8003d3:	55                   	push   %ebp
  8003d4:	89 e5                	mov    %esp,%ebp
  8003d6:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8003d9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8003e0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8003e7:	eb 33                	jmp    80041c <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8003e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8003ec:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f6:	01 d0                	add    %edx,%eax
  8003f8:	8b 10                	mov    (%eax),%edx
  8003fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8003fd:	40                   	inc    %eax
  8003fe:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800405:	8b 45 08             	mov    0x8(%ebp),%eax
  800408:	01 c8                	add    %ecx,%eax
  80040a:	8b 00                	mov    (%eax),%eax
  80040c:	39 c2                	cmp    %eax,%edx
  80040e:	7e 09                	jle    800419 <CheckSorted+0x46>
		{
			Sorted = 0 ;
  800410:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800417:	eb 0c                	jmp    800425 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800419:	ff 45 f8             	incl   -0x8(%ebp)
  80041c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80041f:	48                   	dec    %eax
  800420:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800423:	7f c4                	jg     8003e9 <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800425:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800428:	c9                   	leave  
  800429:	c3                   	ret    

0080042a <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  80042a:	55                   	push   %ebp
  80042b:	89 e5                	mov    %esp,%ebp
  80042d:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  800430:	8b 45 0c             	mov    0xc(%ebp),%eax
  800433:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80043a:	8b 45 08             	mov    0x8(%ebp),%eax
  80043d:	01 d0                	add    %edx,%eax
  80043f:	8b 00                	mov    (%eax),%eax
  800441:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800444:	8b 45 0c             	mov    0xc(%ebp),%eax
  800447:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80044e:	8b 45 08             	mov    0x8(%ebp),%eax
  800451:	01 c2                	add    %eax,%edx
  800453:	8b 45 10             	mov    0x10(%ebp),%eax
  800456:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80045d:	8b 45 08             	mov    0x8(%ebp),%eax
  800460:	01 c8                	add    %ecx,%eax
  800462:	8b 00                	mov    (%eax),%eax
  800464:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800466:	8b 45 10             	mov    0x10(%ebp),%eax
  800469:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800470:	8b 45 08             	mov    0x8(%ebp),%eax
  800473:	01 c2                	add    %eax,%edx
  800475:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800478:	89 02                	mov    %eax,(%edx)
}
  80047a:	90                   	nop
  80047b:	c9                   	leave  
  80047c:	c3                   	ret    

0080047d <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  80047d:	55                   	push   %ebp
  80047e:	89 e5                	mov    %esp,%ebp
  800480:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800483:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80048a:	eb 17                	jmp    8004a3 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  80048c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80048f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800496:	8b 45 08             	mov    0x8(%ebp),%eax
  800499:	01 c2                	add    %eax,%edx
  80049b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80049e:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004a0:	ff 45 fc             	incl   -0x4(%ebp)
  8004a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004a6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004a9:	7c e1                	jl     80048c <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  8004ab:	90                   	nop
  8004ac:	c9                   	leave  
  8004ad:	c3                   	ret    

008004ae <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  8004ae:	55                   	push   %ebp
  8004af:	89 e5                	mov    %esp,%ebp
  8004b1:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004b4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8004bb:	eb 1b                	jmp    8004d8 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8004bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004c0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ca:	01 c2                	add    %eax,%edx
  8004cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004cf:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8004d2:	48                   	dec    %eax
  8004d3:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004d5:	ff 45 fc             	incl   -0x4(%ebp)
  8004d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004db:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004de:	7c dd                	jl     8004bd <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8004e0:	90                   	nop
  8004e1:	c9                   	leave  
  8004e2:	c3                   	ret    

008004e3 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8004e3:	55                   	push   %ebp
  8004e4:	89 e5                	mov    %esp,%ebp
  8004e6:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8004e9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004ec:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8004f1:	f7 e9                	imul   %ecx
  8004f3:	c1 f9 1f             	sar    $0x1f,%ecx
  8004f6:	89 d0                	mov    %edx,%eax
  8004f8:	29 c8                	sub    %ecx,%eax
  8004fa:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  8004fd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800504:	eb 1e                	jmp    800524 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  800506:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800509:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800510:	8b 45 08             	mov    0x8(%ebp),%eax
  800513:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800516:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800519:	99                   	cltd   
  80051a:	f7 7d f8             	idivl  -0x8(%ebp)
  80051d:	89 d0                	mov    %edx,%eax
  80051f:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800521:	ff 45 fc             	incl   -0x4(%ebp)
  800524:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800527:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80052a:	7c da                	jl     800506 <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
		//	cprintf("i=%d\n",i);
	}

}
  80052c:	90                   	nop
  80052d:	c9                   	leave  
  80052e:	c3                   	ret    

0080052f <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  80052f:	55                   	push   %ebp
  800530:	89 e5                	mov    %esp,%ebp
  800532:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800535:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  80053c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800543:	eb 42                	jmp    800587 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800545:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800548:	99                   	cltd   
  800549:	f7 7d f0             	idivl  -0x10(%ebp)
  80054c:	89 d0                	mov    %edx,%eax
  80054e:	85 c0                	test   %eax,%eax
  800550:	75 10                	jne    800562 <PrintElements+0x33>
			cprintf("\n");
  800552:	83 ec 0c             	sub    $0xc,%esp
  800555:	68 20 24 80 00       	push   $0x802420
  80055a:	e8 e6 04 00 00       	call   800a45 <cprintf>
  80055f:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800562:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800565:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80056c:	8b 45 08             	mov    0x8(%ebp),%eax
  80056f:	01 d0                	add    %edx,%eax
  800571:	8b 00                	mov    (%eax),%eax
  800573:	83 ec 08             	sub    $0x8,%esp
  800576:	50                   	push   %eax
  800577:	68 f0 25 80 00       	push   $0x8025f0
  80057c:	e8 c4 04 00 00       	call   800a45 <cprintf>
  800581:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800584:	ff 45 f4             	incl   -0xc(%ebp)
  800587:	8b 45 0c             	mov    0xc(%ebp),%eax
  80058a:	48                   	dec    %eax
  80058b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80058e:	7f b5                	jg     800545 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  800590:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800593:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80059a:	8b 45 08             	mov    0x8(%ebp),%eax
  80059d:	01 d0                	add    %edx,%eax
  80059f:	8b 00                	mov    (%eax),%eax
  8005a1:	83 ec 08             	sub    $0x8,%esp
  8005a4:	50                   	push   %eax
  8005a5:	68 f5 25 80 00       	push   $0x8025f5
  8005aa:	e8 96 04 00 00       	call   800a45 <cprintf>
  8005af:	83 c4 10             	add    $0x10,%esp

}
  8005b2:	90                   	nop
  8005b3:	c9                   	leave  
  8005b4:	c3                   	ret    

008005b5 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8005b5:	55                   	push   %ebp
  8005b6:	89 e5                	mov    %esp,%ebp
  8005b8:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8005bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8005be:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8005c1:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8005c5:	83 ec 0c             	sub    $0xc,%esp
  8005c8:	50                   	push   %eax
  8005c9:	e8 93 17 00 00       	call   801d61 <sys_cputc>
  8005ce:	83 c4 10             	add    $0x10,%esp
}
  8005d1:	90                   	nop
  8005d2:	c9                   	leave  
  8005d3:	c3                   	ret    

008005d4 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  8005d4:	55                   	push   %ebp
  8005d5:	89 e5                	mov    %esp,%ebp
  8005d7:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8005da:	e8 4e 17 00 00       	call   801d2d <sys_disable_interrupt>
	char c = ch;
  8005df:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e2:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8005e5:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8005e9:	83 ec 0c             	sub    $0xc,%esp
  8005ec:	50                   	push   %eax
  8005ed:	e8 6f 17 00 00       	call   801d61 <sys_cputc>
  8005f2:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8005f5:	e8 4d 17 00 00       	call   801d47 <sys_enable_interrupt>
}
  8005fa:	90                   	nop
  8005fb:	c9                   	leave  
  8005fc:	c3                   	ret    

008005fd <getchar>:

int
getchar(void)
{
  8005fd:	55                   	push   %ebp
  8005fe:	89 e5                	mov    %esp,%ebp
  800600:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  800603:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  80060a:	eb 08                	jmp    800614 <getchar+0x17>
	{
		c = sys_cgetc();
  80060c:	e8 97 15 00 00       	call   801ba8 <sys_cgetc>
  800611:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  800614:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800618:	74 f2                	je     80060c <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  80061a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80061d:	c9                   	leave  
  80061e:	c3                   	ret    

0080061f <atomic_getchar>:

int
atomic_getchar(void)
{
  80061f:	55                   	push   %ebp
  800620:	89 e5                	mov    %esp,%ebp
  800622:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800625:	e8 03 17 00 00       	call   801d2d <sys_disable_interrupt>
	int c=0;
  80062a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800631:	eb 08                	jmp    80063b <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  800633:	e8 70 15 00 00       	call   801ba8 <sys_cgetc>
  800638:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  80063b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80063f:	74 f2                	je     800633 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  800641:	e8 01 17 00 00       	call   801d47 <sys_enable_interrupt>
	return c;
  800646:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800649:	c9                   	leave  
  80064a:	c3                   	ret    

0080064b <iscons>:

int iscons(int fdnum)
{
  80064b:	55                   	push   %ebp
  80064c:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  80064e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800653:	5d                   	pop    %ebp
  800654:	c3                   	ret    

00800655 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800655:	55                   	push   %ebp
  800656:	89 e5                	mov    %esp,%ebp
  800658:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80065b:	e8 c0 18 00 00       	call   801f20 <sys_getenvindex>
  800660:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800663:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800666:	89 d0                	mov    %edx,%eax
  800668:	c1 e0 03             	shl    $0x3,%eax
  80066b:	01 d0                	add    %edx,%eax
  80066d:	01 c0                	add    %eax,%eax
  80066f:	01 d0                	add    %edx,%eax
  800671:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800678:	01 d0                	add    %edx,%eax
  80067a:	c1 e0 04             	shl    $0x4,%eax
  80067d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800682:	a3 24 30 80 00       	mov    %eax,0x803024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800687:	a1 24 30 80 00       	mov    0x803024,%eax
  80068c:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800692:	84 c0                	test   %al,%al
  800694:	74 0f                	je     8006a5 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800696:	a1 24 30 80 00       	mov    0x803024,%eax
  80069b:	05 5c 05 00 00       	add    $0x55c,%eax
  8006a0:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8006a5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8006a9:	7e 0a                	jle    8006b5 <libmain+0x60>
		binaryname = argv[0];
  8006ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006ae:	8b 00                	mov    (%eax),%eax
  8006b0:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8006b5:	83 ec 08             	sub    $0x8,%esp
  8006b8:	ff 75 0c             	pushl  0xc(%ebp)
  8006bb:	ff 75 08             	pushl  0x8(%ebp)
  8006be:	e8 75 f9 ff ff       	call   800038 <_main>
  8006c3:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8006c6:	e8 62 16 00 00       	call   801d2d <sys_disable_interrupt>
	cprintf("**************************************\n");
  8006cb:	83 ec 0c             	sub    $0xc,%esp
  8006ce:	68 14 26 80 00       	push   $0x802614
  8006d3:	e8 6d 03 00 00       	call   800a45 <cprintf>
  8006d8:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8006db:	a1 24 30 80 00       	mov    0x803024,%eax
  8006e0:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8006e6:	a1 24 30 80 00       	mov    0x803024,%eax
  8006eb:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8006f1:	83 ec 04             	sub    $0x4,%esp
  8006f4:	52                   	push   %edx
  8006f5:	50                   	push   %eax
  8006f6:	68 3c 26 80 00       	push   $0x80263c
  8006fb:	e8 45 03 00 00       	call   800a45 <cprintf>
  800700:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800703:	a1 24 30 80 00       	mov    0x803024,%eax
  800708:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80070e:	a1 24 30 80 00       	mov    0x803024,%eax
  800713:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800719:	a1 24 30 80 00       	mov    0x803024,%eax
  80071e:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800724:	51                   	push   %ecx
  800725:	52                   	push   %edx
  800726:	50                   	push   %eax
  800727:	68 64 26 80 00       	push   $0x802664
  80072c:	e8 14 03 00 00       	call   800a45 <cprintf>
  800731:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800734:	a1 24 30 80 00       	mov    0x803024,%eax
  800739:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80073f:	83 ec 08             	sub    $0x8,%esp
  800742:	50                   	push   %eax
  800743:	68 bc 26 80 00       	push   $0x8026bc
  800748:	e8 f8 02 00 00       	call   800a45 <cprintf>
  80074d:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800750:	83 ec 0c             	sub    $0xc,%esp
  800753:	68 14 26 80 00       	push   $0x802614
  800758:	e8 e8 02 00 00       	call   800a45 <cprintf>
  80075d:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800760:	e8 e2 15 00 00       	call   801d47 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800765:	e8 19 00 00 00       	call   800783 <exit>
}
  80076a:	90                   	nop
  80076b:	c9                   	leave  
  80076c:	c3                   	ret    

0080076d <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80076d:	55                   	push   %ebp
  80076e:	89 e5                	mov    %esp,%ebp
  800770:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800773:	83 ec 0c             	sub    $0xc,%esp
  800776:	6a 00                	push   $0x0
  800778:	e8 6f 17 00 00       	call   801eec <sys_destroy_env>
  80077d:	83 c4 10             	add    $0x10,%esp
}
  800780:	90                   	nop
  800781:	c9                   	leave  
  800782:	c3                   	ret    

00800783 <exit>:

void
exit(void)
{
  800783:	55                   	push   %ebp
  800784:	89 e5                	mov    %esp,%ebp
  800786:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800789:	e8 c4 17 00 00       	call   801f52 <sys_exit_env>
}
  80078e:	90                   	nop
  80078f:	c9                   	leave  
  800790:	c3                   	ret    

00800791 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800791:	55                   	push   %ebp
  800792:	89 e5                	mov    %esp,%ebp
  800794:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800797:	8d 45 10             	lea    0x10(%ebp),%eax
  80079a:	83 c0 04             	add    $0x4,%eax
  80079d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8007a0:	a1 5c 31 80 00       	mov    0x80315c,%eax
  8007a5:	85 c0                	test   %eax,%eax
  8007a7:	74 16                	je     8007bf <_panic+0x2e>
		cprintf("%s: ", argv0);
  8007a9:	a1 5c 31 80 00       	mov    0x80315c,%eax
  8007ae:	83 ec 08             	sub    $0x8,%esp
  8007b1:	50                   	push   %eax
  8007b2:	68 d0 26 80 00       	push   $0x8026d0
  8007b7:	e8 89 02 00 00       	call   800a45 <cprintf>
  8007bc:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8007bf:	a1 00 30 80 00       	mov    0x803000,%eax
  8007c4:	ff 75 0c             	pushl  0xc(%ebp)
  8007c7:	ff 75 08             	pushl  0x8(%ebp)
  8007ca:	50                   	push   %eax
  8007cb:	68 d5 26 80 00       	push   $0x8026d5
  8007d0:	e8 70 02 00 00       	call   800a45 <cprintf>
  8007d5:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8007d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8007db:	83 ec 08             	sub    $0x8,%esp
  8007de:	ff 75 f4             	pushl  -0xc(%ebp)
  8007e1:	50                   	push   %eax
  8007e2:	e8 f3 01 00 00       	call   8009da <vcprintf>
  8007e7:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8007ea:	83 ec 08             	sub    $0x8,%esp
  8007ed:	6a 00                	push   $0x0
  8007ef:	68 f1 26 80 00       	push   $0x8026f1
  8007f4:	e8 e1 01 00 00       	call   8009da <vcprintf>
  8007f9:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8007fc:	e8 82 ff ff ff       	call   800783 <exit>

	// should not return here
	while (1) ;
  800801:	eb fe                	jmp    800801 <_panic+0x70>

00800803 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800803:	55                   	push   %ebp
  800804:	89 e5                	mov    %esp,%ebp
  800806:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800809:	a1 24 30 80 00       	mov    0x803024,%eax
  80080e:	8b 50 74             	mov    0x74(%eax),%edx
  800811:	8b 45 0c             	mov    0xc(%ebp),%eax
  800814:	39 c2                	cmp    %eax,%edx
  800816:	74 14                	je     80082c <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800818:	83 ec 04             	sub    $0x4,%esp
  80081b:	68 f4 26 80 00       	push   $0x8026f4
  800820:	6a 26                	push   $0x26
  800822:	68 40 27 80 00       	push   $0x802740
  800827:	e8 65 ff ff ff       	call   800791 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80082c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800833:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80083a:	e9 c2 00 00 00       	jmp    800901 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80083f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800842:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800849:	8b 45 08             	mov    0x8(%ebp),%eax
  80084c:	01 d0                	add    %edx,%eax
  80084e:	8b 00                	mov    (%eax),%eax
  800850:	85 c0                	test   %eax,%eax
  800852:	75 08                	jne    80085c <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800854:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800857:	e9 a2 00 00 00       	jmp    8008fe <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80085c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800863:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80086a:	eb 69                	jmp    8008d5 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80086c:	a1 24 30 80 00       	mov    0x803024,%eax
  800871:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800877:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80087a:	89 d0                	mov    %edx,%eax
  80087c:	01 c0                	add    %eax,%eax
  80087e:	01 d0                	add    %edx,%eax
  800880:	c1 e0 03             	shl    $0x3,%eax
  800883:	01 c8                	add    %ecx,%eax
  800885:	8a 40 04             	mov    0x4(%eax),%al
  800888:	84 c0                	test   %al,%al
  80088a:	75 46                	jne    8008d2 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80088c:	a1 24 30 80 00       	mov    0x803024,%eax
  800891:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800897:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80089a:	89 d0                	mov    %edx,%eax
  80089c:	01 c0                	add    %eax,%eax
  80089e:	01 d0                	add    %edx,%eax
  8008a0:	c1 e0 03             	shl    $0x3,%eax
  8008a3:	01 c8                	add    %ecx,%eax
  8008a5:	8b 00                	mov    (%eax),%eax
  8008a7:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8008aa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8008ad:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8008b2:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8008b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008b7:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8008be:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c1:	01 c8                	add    %ecx,%eax
  8008c3:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008c5:	39 c2                	cmp    %eax,%edx
  8008c7:	75 09                	jne    8008d2 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8008c9:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8008d0:	eb 12                	jmp    8008e4 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008d2:	ff 45 e8             	incl   -0x18(%ebp)
  8008d5:	a1 24 30 80 00       	mov    0x803024,%eax
  8008da:	8b 50 74             	mov    0x74(%eax),%edx
  8008dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008e0:	39 c2                	cmp    %eax,%edx
  8008e2:	77 88                	ja     80086c <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8008e4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8008e8:	75 14                	jne    8008fe <CheckWSWithoutLastIndex+0xfb>
			panic(
  8008ea:	83 ec 04             	sub    $0x4,%esp
  8008ed:	68 4c 27 80 00       	push   $0x80274c
  8008f2:	6a 3a                	push   $0x3a
  8008f4:	68 40 27 80 00       	push   $0x802740
  8008f9:	e8 93 fe ff ff       	call   800791 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8008fe:	ff 45 f0             	incl   -0x10(%ebp)
  800901:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800904:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800907:	0f 8c 32 ff ff ff    	jl     80083f <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80090d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800914:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80091b:	eb 26                	jmp    800943 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80091d:	a1 24 30 80 00       	mov    0x803024,%eax
  800922:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800928:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80092b:	89 d0                	mov    %edx,%eax
  80092d:	01 c0                	add    %eax,%eax
  80092f:	01 d0                	add    %edx,%eax
  800931:	c1 e0 03             	shl    $0x3,%eax
  800934:	01 c8                	add    %ecx,%eax
  800936:	8a 40 04             	mov    0x4(%eax),%al
  800939:	3c 01                	cmp    $0x1,%al
  80093b:	75 03                	jne    800940 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80093d:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800940:	ff 45 e0             	incl   -0x20(%ebp)
  800943:	a1 24 30 80 00       	mov    0x803024,%eax
  800948:	8b 50 74             	mov    0x74(%eax),%edx
  80094b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80094e:	39 c2                	cmp    %eax,%edx
  800950:	77 cb                	ja     80091d <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800952:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800955:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800958:	74 14                	je     80096e <CheckWSWithoutLastIndex+0x16b>
		panic(
  80095a:	83 ec 04             	sub    $0x4,%esp
  80095d:	68 a0 27 80 00       	push   $0x8027a0
  800962:	6a 44                	push   $0x44
  800964:	68 40 27 80 00       	push   $0x802740
  800969:	e8 23 fe ff ff       	call   800791 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80096e:	90                   	nop
  80096f:	c9                   	leave  
  800970:	c3                   	ret    

00800971 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800971:	55                   	push   %ebp
  800972:	89 e5                	mov    %esp,%ebp
  800974:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800977:	8b 45 0c             	mov    0xc(%ebp),%eax
  80097a:	8b 00                	mov    (%eax),%eax
  80097c:	8d 48 01             	lea    0x1(%eax),%ecx
  80097f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800982:	89 0a                	mov    %ecx,(%edx)
  800984:	8b 55 08             	mov    0x8(%ebp),%edx
  800987:	88 d1                	mov    %dl,%cl
  800989:	8b 55 0c             	mov    0xc(%ebp),%edx
  80098c:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800990:	8b 45 0c             	mov    0xc(%ebp),%eax
  800993:	8b 00                	mov    (%eax),%eax
  800995:	3d ff 00 00 00       	cmp    $0xff,%eax
  80099a:	75 2c                	jne    8009c8 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80099c:	a0 28 30 80 00       	mov    0x803028,%al
  8009a1:	0f b6 c0             	movzbl %al,%eax
  8009a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009a7:	8b 12                	mov    (%edx),%edx
  8009a9:	89 d1                	mov    %edx,%ecx
  8009ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009ae:	83 c2 08             	add    $0x8,%edx
  8009b1:	83 ec 04             	sub    $0x4,%esp
  8009b4:	50                   	push   %eax
  8009b5:	51                   	push   %ecx
  8009b6:	52                   	push   %edx
  8009b7:	e8 c3 11 00 00       	call   801b7f <sys_cputs>
  8009bc:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8009bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009c2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8009c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009cb:	8b 40 04             	mov    0x4(%eax),%eax
  8009ce:	8d 50 01             	lea    0x1(%eax),%edx
  8009d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009d4:	89 50 04             	mov    %edx,0x4(%eax)
}
  8009d7:	90                   	nop
  8009d8:	c9                   	leave  
  8009d9:	c3                   	ret    

008009da <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8009da:	55                   	push   %ebp
  8009db:	89 e5                	mov    %esp,%ebp
  8009dd:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8009e3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8009ea:	00 00 00 
	b.cnt = 0;
  8009ed:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8009f4:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8009f7:	ff 75 0c             	pushl  0xc(%ebp)
  8009fa:	ff 75 08             	pushl  0x8(%ebp)
  8009fd:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a03:	50                   	push   %eax
  800a04:	68 71 09 80 00       	push   $0x800971
  800a09:	e8 11 02 00 00       	call   800c1f <vprintfmt>
  800a0e:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800a11:	a0 28 30 80 00       	mov    0x803028,%al
  800a16:	0f b6 c0             	movzbl %al,%eax
  800a19:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800a1f:	83 ec 04             	sub    $0x4,%esp
  800a22:	50                   	push   %eax
  800a23:	52                   	push   %edx
  800a24:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a2a:	83 c0 08             	add    $0x8,%eax
  800a2d:	50                   	push   %eax
  800a2e:	e8 4c 11 00 00       	call   801b7f <sys_cputs>
  800a33:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800a36:	c6 05 28 30 80 00 00 	movb   $0x0,0x803028
	return b.cnt;
  800a3d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800a43:	c9                   	leave  
  800a44:	c3                   	ret    

00800a45 <cprintf>:

int cprintf(const char *fmt, ...) {
  800a45:	55                   	push   %ebp
  800a46:	89 e5                	mov    %esp,%ebp
  800a48:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a4b:	c6 05 28 30 80 00 01 	movb   $0x1,0x803028
	va_start(ap, fmt);
  800a52:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a55:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a58:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5b:	83 ec 08             	sub    $0x8,%esp
  800a5e:	ff 75 f4             	pushl  -0xc(%ebp)
  800a61:	50                   	push   %eax
  800a62:	e8 73 ff ff ff       	call   8009da <vcprintf>
  800a67:	83 c4 10             	add    $0x10,%esp
  800a6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800a6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a70:	c9                   	leave  
  800a71:	c3                   	ret    

00800a72 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800a72:	55                   	push   %ebp
  800a73:	89 e5                	mov    %esp,%ebp
  800a75:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800a78:	e8 b0 12 00 00       	call   801d2d <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800a7d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a80:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a83:	8b 45 08             	mov    0x8(%ebp),%eax
  800a86:	83 ec 08             	sub    $0x8,%esp
  800a89:	ff 75 f4             	pushl  -0xc(%ebp)
  800a8c:	50                   	push   %eax
  800a8d:	e8 48 ff ff ff       	call   8009da <vcprintf>
  800a92:	83 c4 10             	add    $0x10,%esp
  800a95:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800a98:	e8 aa 12 00 00       	call   801d47 <sys_enable_interrupt>
	return cnt;
  800a9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800aa0:	c9                   	leave  
  800aa1:	c3                   	ret    

00800aa2 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800aa2:	55                   	push   %ebp
  800aa3:	89 e5                	mov    %esp,%ebp
  800aa5:	53                   	push   %ebx
  800aa6:	83 ec 14             	sub    $0x14,%esp
  800aa9:	8b 45 10             	mov    0x10(%ebp),%eax
  800aac:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aaf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800ab5:	8b 45 18             	mov    0x18(%ebp),%eax
  800ab8:	ba 00 00 00 00       	mov    $0x0,%edx
  800abd:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800ac0:	77 55                	ja     800b17 <printnum+0x75>
  800ac2:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800ac5:	72 05                	jb     800acc <printnum+0x2a>
  800ac7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800aca:	77 4b                	ja     800b17 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800acc:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800acf:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800ad2:	8b 45 18             	mov    0x18(%ebp),%eax
  800ad5:	ba 00 00 00 00       	mov    $0x0,%edx
  800ada:	52                   	push   %edx
  800adb:	50                   	push   %eax
  800adc:	ff 75 f4             	pushl  -0xc(%ebp)
  800adf:	ff 75 f0             	pushl  -0x10(%ebp)
  800ae2:	e8 cd 16 00 00       	call   8021b4 <__udivdi3>
  800ae7:	83 c4 10             	add    $0x10,%esp
  800aea:	83 ec 04             	sub    $0x4,%esp
  800aed:	ff 75 20             	pushl  0x20(%ebp)
  800af0:	53                   	push   %ebx
  800af1:	ff 75 18             	pushl  0x18(%ebp)
  800af4:	52                   	push   %edx
  800af5:	50                   	push   %eax
  800af6:	ff 75 0c             	pushl  0xc(%ebp)
  800af9:	ff 75 08             	pushl  0x8(%ebp)
  800afc:	e8 a1 ff ff ff       	call   800aa2 <printnum>
  800b01:	83 c4 20             	add    $0x20,%esp
  800b04:	eb 1a                	jmp    800b20 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800b06:	83 ec 08             	sub    $0x8,%esp
  800b09:	ff 75 0c             	pushl  0xc(%ebp)
  800b0c:	ff 75 20             	pushl  0x20(%ebp)
  800b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b12:	ff d0                	call   *%eax
  800b14:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800b17:	ff 4d 1c             	decl   0x1c(%ebp)
  800b1a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800b1e:	7f e6                	jg     800b06 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800b20:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800b23:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b2b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b2e:	53                   	push   %ebx
  800b2f:	51                   	push   %ecx
  800b30:	52                   	push   %edx
  800b31:	50                   	push   %eax
  800b32:	e8 8d 17 00 00       	call   8022c4 <__umoddi3>
  800b37:	83 c4 10             	add    $0x10,%esp
  800b3a:	05 14 2a 80 00       	add    $0x802a14,%eax
  800b3f:	8a 00                	mov    (%eax),%al
  800b41:	0f be c0             	movsbl %al,%eax
  800b44:	83 ec 08             	sub    $0x8,%esp
  800b47:	ff 75 0c             	pushl  0xc(%ebp)
  800b4a:	50                   	push   %eax
  800b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4e:	ff d0                	call   *%eax
  800b50:	83 c4 10             	add    $0x10,%esp
}
  800b53:	90                   	nop
  800b54:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b57:	c9                   	leave  
  800b58:	c3                   	ret    

00800b59 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800b59:	55                   	push   %ebp
  800b5a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b5c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b60:	7e 1c                	jle    800b7e <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800b62:	8b 45 08             	mov    0x8(%ebp),%eax
  800b65:	8b 00                	mov    (%eax),%eax
  800b67:	8d 50 08             	lea    0x8(%eax),%edx
  800b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6d:	89 10                	mov    %edx,(%eax)
  800b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b72:	8b 00                	mov    (%eax),%eax
  800b74:	83 e8 08             	sub    $0x8,%eax
  800b77:	8b 50 04             	mov    0x4(%eax),%edx
  800b7a:	8b 00                	mov    (%eax),%eax
  800b7c:	eb 40                	jmp    800bbe <getuint+0x65>
	else if (lflag)
  800b7e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b82:	74 1e                	je     800ba2 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800b84:	8b 45 08             	mov    0x8(%ebp),%eax
  800b87:	8b 00                	mov    (%eax),%eax
  800b89:	8d 50 04             	lea    0x4(%eax),%edx
  800b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8f:	89 10                	mov    %edx,(%eax)
  800b91:	8b 45 08             	mov    0x8(%ebp),%eax
  800b94:	8b 00                	mov    (%eax),%eax
  800b96:	83 e8 04             	sub    $0x4,%eax
  800b99:	8b 00                	mov    (%eax),%eax
  800b9b:	ba 00 00 00 00       	mov    $0x0,%edx
  800ba0:	eb 1c                	jmp    800bbe <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba5:	8b 00                	mov    (%eax),%eax
  800ba7:	8d 50 04             	lea    0x4(%eax),%edx
  800baa:	8b 45 08             	mov    0x8(%ebp),%eax
  800bad:	89 10                	mov    %edx,(%eax)
  800baf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb2:	8b 00                	mov    (%eax),%eax
  800bb4:	83 e8 04             	sub    $0x4,%eax
  800bb7:	8b 00                	mov    (%eax),%eax
  800bb9:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800bbe:	5d                   	pop    %ebp
  800bbf:	c3                   	ret    

00800bc0 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800bc0:	55                   	push   %ebp
  800bc1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800bc3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800bc7:	7e 1c                	jle    800be5 <getint+0x25>
		return va_arg(*ap, long long);
  800bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcc:	8b 00                	mov    (%eax),%eax
  800bce:	8d 50 08             	lea    0x8(%eax),%edx
  800bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd4:	89 10                	mov    %edx,(%eax)
  800bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd9:	8b 00                	mov    (%eax),%eax
  800bdb:	83 e8 08             	sub    $0x8,%eax
  800bde:	8b 50 04             	mov    0x4(%eax),%edx
  800be1:	8b 00                	mov    (%eax),%eax
  800be3:	eb 38                	jmp    800c1d <getint+0x5d>
	else if (lflag)
  800be5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800be9:	74 1a                	je     800c05 <getint+0x45>
		return va_arg(*ap, long);
  800beb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bee:	8b 00                	mov    (%eax),%eax
  800bf0:	8d 50 04             	lea    0x4(%eax),%edx
  800bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf6:	89 10                	mov    %edx,(%eax)
  800bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfb:	8b 00                	mov    (%eax),%eax
  800bfd:	83 e8 04             	sub    $0x4,%eax
  800c00:	8b 00                	mov    (%eax),%eax
  800c02:	99                   	cltd   
  800c03:	eb 18                	jmp    800c1d <getint+0x5d>
	else
		return va_arg(*ap, int);
  800c05:	8b 45 08             	mov    0x8(%ebp),%eax
  800c08:	8b 00                	mov    (%eax),%eax
  800c0a:	8d 50 04             	lea    0x4(%eax),%edx
  800c0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c10:	89 10                	mov    %edx,(%eax)
  800c12:	8b 45 08             	mov    0x8(%ebp),%eax
  800c15:	8b 00                	mov    (%eax),%eax
  800c17:	83 e8 04             	sub    $0x4,%eax
  800c1a:	8b 00                	mov    (%eax),%eax
  800c1c:	99                   	cltd   
}
  800c1d:	5d                   	pop    %ebp
  800c1e:	c3                   	ret    

00800c1f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800c1f:	55                   	push   %ebp
  800c20:	89 e5                	mov    %esp,%ebp
  800c22:	56                   	push   %esi
  800c23:	53                   	push   %ebx
  800c24:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c27:	eb 17                	jmp    800c40 <vprintfmt+0x21>
			if (ch == '\0')
  800c29:	85 db                	test   %ebx,%ebx
  800c2b:	0f 84 af 03 00 00    	je     800fe0 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800c31:	83 ec 08             	sub    $0x8,%esp
  800c34:	ff 75 0c             	pushl  0xc(%ebp)
  800c37:	53                   	push   %ebx
  800c38:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3b:	ff d0                	call   *%eax
  800c3d:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c40:	8b 45 10             	mov    0x10(%ebp),%eax
  800c43:	8d 50 01             	lea    0x1(%eax),%edx
  800c46:	89 55 10             	mov    %edx,0x10(%ebp)
  800c49:	8a 00                	mov    (%eax),%al
  800c4b:	0f b6 d8             	movzbl %al,%ebx
  800c4e:	83 fb 25             	cmp    $0x25,%ebx
  800c51:	75 d6                	jne    800c29 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800c53:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800c57:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800c5e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800c65:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800c6c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c73:	8b 45 10             	mov    0x10(%ebp),%eax
  800c76:	8d 50 01             	lea    0x1(%eax),%edx
  800c79:	89 55 10             	mov    %edx,0x10(%ebp)
  800c7c:	8a 00                	mov    (%eax),%al
  800c7e:	0f b6 d8             	movzbl %al,%ebx
  800c81:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800c84:	83 f8 55             	cmp    $0x55,%eax
  800c87:	0f 87 2b 03 00 00    	ja     800fb8 <vprintfmt+0x399>
  800c8d:	8b 04 85 38 2a 80 00 	mov    0x802a38(,%eax,4),%eax
  800c94:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800c96:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800c9a:	eb d7                	jmp    800c73 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c9c:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800ca0:	eb d1                	jmp    800c73 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ca2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800ca9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800cac:	89 d0                	mov    %edx,%eax
  800cae:	c1 e0 02             	shl    $0x2,%eax
  800cb1:	01 d0                	add    %edx,%eax
  800cb3:	01 c0                	add    %eax,%eax
  800cb5:	01 d8                	add    %ebx,%eax
  800cb7:	83 e8 30             	sub    $0x30,%eax
  800cba:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800cbd:	8b 45 10             	mov    0x10(%ebp),%eax
  800cc0:	8a 00                	mov    (%eax),%al
  800cc2:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800cc5:	83 fb 2f             	cmp    $0x2f,%ebx
  800cc8:	7e 3e                	jle    800d08 <vprintfmt+0xe9>
  800cca:	83 fb 39             	cmp    $0x39,%ebx
  800ccd:	7f 39                	jg     800d08 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ccf:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800cd2:	eb d5                	jmp    800ca9 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800cd4:	8b 45 14             	mov    0x14(%ebp),%eax
  800cd7:	83 c0 04             	add    $0x4,%eax
  800cda:	89 45 14             	mov    %eax,0x14(%ebp)
  800cdd:	8b 45 14             	mov    0x14(%ebp),%eax
  800ce0:	83 e8 04             	sub    $0x4,%eax
  800ce3:	8b 00                	mov    (%eax),%eax
  800ce5:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800ce8:	eb 1f                	jmp    800d09 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800cea:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cee:	79 83                	jns    800c73 <vprintfmt+0x54>
				width = 0;
  800cf0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800cf7:	e9 77 ff ff ff       	jmp    800c73 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800cfc:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800d03:	e9 6b ff ff ff       	jmp    800c73 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800d08:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800d09:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d0d:	0f 89 60 ff ff ff    	jns    800c73 <vprintfmt+0x54>
				width = precision, precision = -1;
  800d13:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d16:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d19:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800d20:	e9 4e ff ff ff       	jmp    800c73 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d25:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800d28:	e9 46 ff ff ff       	jmp    800c73 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800d2d:	8b 45 14             	mov    0x14(%ebp),%eax
  800d30:	83 c0 04             	add    $0x4,%eax
  800d33:	89 45 14             	mov    %eax,0x14(%ebp)
  800d36:	8b 45 14             	mov    0x14(%ebp),%eax
  800d39:	83 e8 04             	sub    $0x4,%eax
  800d3c:	8b 00                	mov    (%eax),%eax
  800d3e:	83 ec 08             	sub    $0x8,%esp
  800d41:	ff 75 0c             	pushl  0xc(%ebp)
  800d44:	50                   	push   %eax
  800d45:	8b 45 08             	mov    0x8(%ebp),%eax
  800d48:	ff d0                	call   *%eax
  800d4a:	83 c4 10             	add    $0x10,%esp
			break;
  800d4d:	e9 89 02 00 00       	jmp    800fdb <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800d52:	8b 45 14             	mov    0x14(%ebp),%eax
  800d55:	83 c0 04             	add    $0x4,%eax
  800d58:	89 45 14             	mov    %eax,0x14(%ebp)
  800d5b:	8b 45 14             	mov    0x14(%ebp),%eax
  800d5e:	83 e8 04             	sub    $0x4,%eax
  800d61:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800d63:	85 db                	test   %ebx,%ebx
  800d65:	79 02                	jns    800d69 <vprintfmt+0x14a>
				err = -err;
  800d67:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800d69:	83 fb 64             	cmp    $0x64,%ebx
  800d6c:	7f 0b                	jg     800d79 <vprintfmt+0x15a>
  800d6e:	8b 34 9d 80 28 80 00 	mov    0x802880(,%ebx,4),%esi
  800d75:	85 f6                	test   %esi,%esi
  800d77:	75 19                	jne    800d92 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d79:	53                   	push   %ebx
  800d7a:	68 25 2a 80 00       	push   $0x802a25
  800d7f:	ff 75 0c             	pushl  0xc(%ebp)
  800d82:	ff 75 08             	pushl  0x8(%ebp)
  800d85:	e8 5e 02 00 00       	call   800fe8 <printfmt>
  800d8a:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d8d:	e9 49 02 00 00       	jmp    800fdb <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d92:	56                   	push   %esi
  800d93:	68 2e 2a 80 00       	push   $0x802a2e
  800d98:	ff 75 0c             	pushl  0xc(%ebp)
  800d9b:	ff 75 08             	pushl  0x8(%ebp)
  800d9e:	e8 45 02 00 00       	call   800fe8 <printfmt>
  800da3:	83 c4 10             	add    $0x10,%esp
			break;
  800da6:	e9 30 02 00 00       	jmp    800fdb <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800dab:	8b 45 14             	mov    0x14(%ebp),%eax
  800dae:	83 c0 04             	add    $0x4,%eax
  800db1:	89 45 14             	mov    %eax,0x14(%ebp)
  800db4:	8b 45 14             	mov    0x14(%ebp),%eax
  800db7:	83 e8 04             	sub    $0x4,%eax
  800dba:	8b 30                	mov    (%eax),%esi
  800dbc:	85 f6                	test   %esi,%esi
  800dbe:	75 05                	jne    800dc5 <vprintfmt+0x1a6>
				p = "(null)";
  800dc0:	be 31 2a 80 00       	mov    $0x802a31,%esi
			if (width > 0 && padc != '-')
  800dc5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dc9:	7e 6d                	jle    800e38 <vprintfmt+0x219>
  800dcb:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800dcf:	74 67                	je     800e38 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800dd1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800dd4:	83 ec 08             	sub    $0x8,%esp
  800dd7:	50                   	push   %eax
  800dd8:	56                   	push   %esi
  800dd9:	e8 12 05 00 00       	call   8012f0 <strnlen>
  800dde:	83 c4 10             	add    $0x10,%esp
  800de1:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800de4:	eb 16                	jmp    800dfc <vprintfmt+0x1dd>
					putch(padc, putdat);
  800de6:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800dea:	83 ec 08             	sub    $0x8,%esp
  800ded:	ff 75 0c             	pushl  0xc(%ebp)
  800df0:	50                   	push   %eax
  800df1:	8b 45 08             	mov    0x8(%ebp),%eax
  800df4:	ff d0                	call   *%eax
  800df6:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800df9:	ff 4d e4             	decl   -0x1c(%ebp)
  800dfc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e00:	7f e4                	jg     800de6 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e02:	eb 34                	jmp    800e38 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800e04:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800e08:	74 1c                	je     800e26 <vprintfmt+0x207>
  800e0a:	83 fb 1f             	cmp    $0x1f,%ebx
  800e0d:	7e 05                	jle    800e14 <vprintfmt+0x1f5>
  800e0f:	83 fb 7e             	cmp    $0x7e,%ebx
  800e12:	7e 12                	jle    800e26 <vprintfmt+0x207>
					putch('?', putdat);
  800e14:	83 ec 08             	sub    $0x8,%esp
  800e17:	ff 75 0c             	pushl  0xc(%ebp)
  800e1a:	6a 3f                	push   $0x3f
  800e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1f:	ff d0                	call   *%eax
  800e21:	83 c4 10             	add    $0x10,%esp
  800e24:	eb 0f                	jmp    800e35 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800e26:	83 ec 08             	sub    $0x8,%esp
  800e29:	ff 75 0c             	pushl  0xc(%ebp)
  800e2c:	53                   	push   %ebx
  800e2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e30:	ff d0                	call   *%eax
  800e32:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e35:	ff 4d e4             	decl   -0x1c(%ebp)
  800e38:	89 f0                	mov    %esi,%eax
  800e3a:	8d 70 01             	lea    0x1(%eax),%esi
  800e3d:	8a 00                	mov    (%eax),%al
  800e3f:	0f be d8             	movsbl %al,%ebx
  800e42:	85 db                	test   %ebx,%ebx
  800e44:	74 24                	je     800e6a <vprintfmt+0x24b>
  800e46:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e4a:	78 b8                	js     800e04 <vprintfmt+0x1e5>
  800e4c:	ff 4d e0             	decl   -0x20(%ebp)
  800e4f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e53:	79 af                	jns    800e04 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e55:	eb 13                	jmp    800e6a <vprintfmt+0x24b>
				putch(' ', putdat);
  800e57:	83 ec 08             	sub    $0x8,%esp
  800e5a:	ff 75 0c             	pushl  0xc(%ebp)
  800e5d:	6a 20                	push   $0x20
  800e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e62:	ff d0                	call   *%eax
  800e64:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e67:	ff 4d e4             	decl   -0x1c(%ebp)
  800e6a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e6e:	7f e7                	jg     800e57 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800e70:	e9 66 01 00 00       	jmp    800fdb <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800e75:	83 ec 08             	sub    $0x8,%esp
  800e78:	ff 75 e8             	pushl  -0x18(%ebp)
  800e7b:	8d 45 14             	lea    0x14(%ebp),%eax
  800e7e:	50                   	push   %eax
  800e7f:	e8 3c fd ff ff       	call   800bc0 <getint>
  800e84:	83 c4 10             	add    $0x10,%esp
  800e87:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e8a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800e8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e90:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e93:	85 d2                	test   %edx,%edx
  800e95:	79 23                	jns    800eba <vprintfmt+0x29b>
				putch('-', putdat);
  800e97:	83 ec 08             	sub    $0x8,%esp
  800e9a:	ff 75 0c             	pushl  0xc(%ebp)
  800e9d:	6a 2d                	push   $0x2d
  800e9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea2:	ff d0                	call   *%eax
  800ea4:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800ea7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800eaa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ead:	f7 d8                	neg    %eax
  800eaf:	83 d2 00             	adc    $0x0,%edx
  800eb2:	f7 da                	neg    %edx
  800eb4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800eb7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800eba:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ec1:	e9 bc 00 00 00       	jmp    800f82 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ec6:	83 ec 08             	sub    $0x8,%esp
  800ec9:	ff 75 e8             	pushl  -0x18(%ebp)
  800ecc:	8d 45 14             	lea    0x14(%ebp),%eax
  800ecf:	50                   	push   %eax
  800ed0:	e8 84 fc ff ff       	call   800b59 <getuint>
  800ed5:	83 c4 10             	add    $0x10,%esp
  800ed8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800edb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800ede:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ee5:	e9 98 00 00 00       	jmp    800f82 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800eea:	83 ec 08             	sub    $0x8,%esp
  800eed:	ff 75 0c             	pushl  0xc(%ebp)
  800ef0:	6a 58                	push   $0x58
  800ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef5:	ff d0                	call   *%eax
  800ef7:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800efa:	83 ec 08             	sub    $0x8,%esp
  800efd:	ff 75 0c             	pushl  0xc(%ebp)
  800f00:	6a 58                	push   $0x58
  800f02:	8b 45 08             	mov    0x8(%ebp),%eax
  800f05:	ff d0                	call   *%eax
  800f07:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f0a:	83 ec 08             	sub    $0x8,%esp
  800f0d:	ff 75 0c             	pushl  0xc(%ebp)
  800f10:	6a 58                	push   $0x58
  800f12:	8b 45 08             	mov    0x8(%ebp),%eax
  800f15:	ff d0                	call   *%eax
  800f17:	83 c4 10             	add    $0x10,%esp
			break;
  800f1a:	e9 bc 00 00 00       	jmp    800fdb <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800f1f:	83 ec 08             	sub    $0x8,%esp
  800f22:	ff 75 0c             	pushl  0xc(%ebp)
  800f25:	6a 30                	push   $0x30
  800f27:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2a:	ff d0                	call   *%eax
  800f2c:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800f2f:	83 ec 08             	sub    $0x8,%esp
  800f32:	ff 75 0c             	pushl  0xc(%ebp)
  800f35:	6a 78                	push   $0x78
  800f37:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3a:	ff d0                	call   *%eax
  800f3c:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800f3f:	8b 45 14             	mov    0x14(%ebp),%eax
  800f42:	83 c0 04             	add    $0x4,%eax
  800f45:	89 45 14             	mov    %eax,0x14(%ebp)
  800f48:	8b 45 14             	mov    0x14(%ebp),%eax
  800f4b:	83 e8 04             	sub    $0x4,%eax
  800f4e:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f50:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f53:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800f5a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800f61:	eb 1f                	jmp    800f82 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800f63:	83 ec 08             	sub    $0x8,%esp
  800f66:	ff 75 e8             	pushl  -0x18(%ebp)
  800f69:	8d 45 14             	lea    0x14(%ebp),%eax
  800f6c:	50                   	push   %eax
  800f6d:	e8 e7 fb ff ff       	call   800b59 <getuint>
  800f72:	83 c4 10             	add    $0x10,%esp
  800f75:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f78:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800f7b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f82:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800f86:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f89:	83 ec 04             	sub    $0x4,%esp
  800f8c:	52                   	push   %edx
  800f8d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f90:	50                   	push   %eax
  800f91:	ff 75 f4             	pushl  -0xc(%ebp)
  800f94:	ff 75 f0             	pushl  -0x10(%ebp)
  800f97:	ff 75 0c             	pushl  0xc(%ebp)
  800f9a:	ff 75 08             	pushl  0x8(%ebp)
  800f9d:	e8 00 fb ff ff       	call   800aa2 <printnum>
  800fa2:	83 c4 20             	add    $0x20,%esp
			break;
  800fa5:	eb 34                	jmp    800fdb <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800fa7:	83 ec 08             	sub    $0x8,%esp
  800faa:	ff 75 0c             	pushl  0xc(%ebp)
  800fad:	53                   	push   %ebx
  800fae:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb1:	ff d0                	call   *%eax
  800fb3:	83 c4 10             	add    $0x10,%esp
			break;
  800fb6:	eb 23                	jmp    800fdb <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800fb8:	83 ec 08             	sub    $0x8,%esp
  800fbb:	ff 75 0c             	pushl  0xc(%ebp)
  800fbe:	6a 25                	push   $0x25
  800fc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc3:	ff d0                	call   *%eax
  800fc5:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800fc8:	ff 4d 10             	decl   0x10(%ebp)
  800fcb:	eb 03                	jmp    800fd0 <vprintfmt+0x3b1>
  800fcd:	ff 4d 10             	decl   0x10(%ebp)
  800fd0:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd3:	48                   	dec    %eax
  800fd4:	8a 00                	mov    (%eax),%al
  800fd6:	3c 25                	cmp    $0x25,%al
  800fd8:	75 f3                	jne    800fcd <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800fda:	90                   	nop
		}
	}
  800fdb:	e9 47 fc ff ff       	jmp    800c27 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800fe0:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800fe1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800fe4:	5b                   	pop    %ebx
  800fe5:	5e                   	pop    %esi
  800fe6:	5d                   	pop    %ebp
  800fe7:	c3                   	ret    

00800fe8 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800fe8:	55                   	push   %ebp
  800fe9:	89 e5                	mov    %esp,%ebp
  800feb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800fee:	8d 45 10             	lea    0x10(%ebp),%eax
  800ff1:	83 c0 04             	add    $0x4,%eax
  800ff4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800ff7:	8b 45 10             	mov    0x10(%ebp),%eax
  800ffa:	ff 75 f4             	pushl  -0xc(%ebp)
  800ffd:	50                   	push   %eax
  800ffe:	ff 75 0c             	pushl  0xc(%ebp)
  801001:	ff 75 08             	pushl  0x8(%ebp)
  801004:	e8 16 fc ff ff       	call   800c1f <vprintfmt>
  801009:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80100c:	90                   	nop
  80100d:	c9                   	leave  
  80100e:	c3                   	ret    

0080100f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80100f:	55                   	push   %ebp
  801010:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801012:	8b 45 0c             	mov    0xc(%ebp),%eax
  801015:	8b 40 08             	mov    0x8(%eax),%eax
  801018:	8d 50 01             	lea    0x1(%eax),%edx
  80101b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101e:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801021:	8b 45 0c             	mov    0xc(%ebp),%eax
  801024:	8b 10                	mov    (%eax),%edx
  801026:	8b 45 0c             	mov    0xc(%ebp),%eax
  801029:	8b 40 04             	mov    0x4(%eax),%eax
  80102c:	39 c2                	cmp    %eax,%edx
  80102e:	73 12                	jae    801042 <sprintputch+0x33>
		*b->buf++ = ch;
  801030:	8b 45 0c             	mov    0xc(%ebp),%eax
  801033:	8b 00                	mov    (%eax),%eax
  801035:	8d 48 01             	lea    0x1(%eax),%ecx
  801038:	8b 55 0c             	mov    0xc(%ebp),%edx
  80103b:	89 0a                	mov    %ecx,(%edx)
  80103d:	8b 55 08             	mov    0x8(%ebp),%edx
  801040:	88 10                	mov    %dl,(%eax)
}
  801042:	90                   	nop
  801043:	5d                   	pop    %ebp
  801044:	c3                   	ret    

00801045 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801045:	55                   	push   %ebp
  801046:	89 e5                	mov    %esp,%ebp
  801048:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80104b:	8b 45 08             	mov    0x8(%ebp),%eax
  80104e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801051:	8b 45 0c             	mov    0xc(%ebp),%eax
  801054:	8d 50 ff             	lea    -0x1(%eax),%edx
  801057:	8b 45 08             	mov    0x8(%ebp),%eax
  80105a:	01 d0                	add    %edx,%eax
  80105c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80105f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801066:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80106a:	74 06                	je     801072 <vsnprintf+0x2d>
  80106c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801070:	7f 07                	jg     801079 <vsnprintf+0x34>
		return -E_INVAL;
  801072:	b8 03 00 00 00       	mov    $0x3,%eax
  801077:	eb 20                	jmp    801099 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801079:	ff 75 14             	pushl  0x14(%ebp)
  80107c:	ff 75 10             	pushl  0x10(%ebp)
  80107f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801082:	50                   	push   %eax
  801083:	68 0f 10 80 00       	push   $0x80100f
  801088:	e8 92 fb ff ff       	call   800c1f <vprintfmt>
  80108d:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801090:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801093:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801096:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801099:	c9                   	leave  
  80109a:	c3                   	ret    

0080109b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80109b:	55                   	push   %ebp
  80109c:	89 e5                	mov    %esp,%ebp
  80109e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8010a1:	8d 45 10             	lea    0x10(%ebp),%eax
  8010a4:	83 c0 04             	add    $0x4,%eax
  8010a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8010aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ad:	ff 75 f4             	pushl  -0xc(%ebp)
  8010b0:	50                   	push   %eax
  8010b1:	ff 75 0c             	pushl  0xc(%ebp)
  8010b4:	ff 75 08             	pushl  0x8(%ebp)
  8010b7:	e8 89 ff ff ff       	call   801045 <vsnprintf>
  8010bc:	83 c4 10             	add    $0x10,%esp
  8010bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8010c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8010c5:	c9                   	leave  
  8010c6:	c3                   	ret    

008010c7 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  8010c7:	55                   	push   %ebp
  8010c8:	89 e5                	mov    %esp,%ebp
  8010ca:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  8010cd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010d1:	74 13                	je     8010e6 <readline+0x1f>
		cprintf("%s", prompt);
  8010d3:	83 ec 08             	sub    $0x8,%esp
  8010d6:	ff 75 08             	pushl  0x8(%ebp)
  8010d9:	68 90 2b 80 00       	push   $0x802b90
  8010de:	e8 62 f9 ff ff       	call   800a45 <cprintf>
  8010e3:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8010e6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8010ed:	83 ec 0c             	sub    $0xc,%esp
  8010f0:	6a 00                	push   $0x0
  8010f2:	e8 54 f5 ff ff       	call   80064b <iscons>
  8010f7:	83 c4 10             	add    $0x10,%esp
  8010fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8010fd:	e8 fb f4 ff ff       	call   8005fd <getchar>
  801102:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801105:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801109:	79 22                	jns    80112d <readline+0x66>
			if (c != -E_EOF)
  80110b:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  80110f:	0f 84 ad 00 00 00    	je     8011c2 <readline+0xfb>
				cprintf("read error: %e\n", c);
  801115:	83 ec 08             	sub    $0x8,%esp
  801118:	ff 75 ec             	pushl  -0x14(%ebp)
  80111b:	68 93 2b 80 00       	push   $0x802b93
  801120:	e8 20 f9 ff ff       	call   800a45 <cprintf>
  801125:	83 c4 10             	add    $0x10,%esp
			return;
  801128:	e9 95 00 00 00       	jmp    8011c2 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  80112d:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801131:	7e 34                	jle    801167 <readline+0xa0>
  801133:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  80113a:	7f 2b                	jg     801167 <readline+0xa0>
			if (echoing)
  80113c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801140:	74 0e                	je     801150 <readline+0x89>
				cputchar(c);
  801142:	83 ec 0c             	sub    $0xc,%esp
  801145:	ff 75 ec             	pushl  -0x14(%ebp)
  801148:	e8 68 f4 ff ff       	call   8005b5 <cputchar>
  80114d:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801150:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801153:	8d 50 01             	lea    0x1(%eax),%edx
  801156:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801159:	89 c2                	mov    %eax,%edx
  80115b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115e:	01 d0                	add    %edx,%eax
  801160:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801163:	88 10                	mov    %dl,(%eax)
  801165:	eb 56                	jmp    8011bd <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  801167:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80116b:	75 1f                	jne    80118c <readline+0xc5>
  80116d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801171:	7e 19                	jle    80118c <readline+0xc5>
			if (echoing)
  801173:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801177:	74 0e                	je     801187 <readline+0xc0>
				cputchar(c);
  801179:	83 ec 0c             	sub    $0xc,%esp
  80117c:	ff 75 ec             	pushl  -0x14(%ebp)
  80117f:	e8 31 f4 ff ff       	call   8005b5 <cputchar>
  801184:	83 c4 10             	add    $0x10,%esp

			i--;
  801187:	ff 4d f4             	decl   -0xc(%ebp)
  80118a:	eb 31                	jmp    8011bd <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  80118c:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801190:	74 0a                	je     80119c <readline+0xd5>
  801192:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801196:	0f 85 61 ff ff ff    	jne    8010fd <readline+0x36>
			if (echoing)
  80119c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8011a0:	74 0e                	je     8011b0 <readline+0xe9>
				cputchar(c);
  8011a2:	83 ec 0c             	sub    $0xc,%esp
  8011a5:	ff 75 ec             	pushl  -0x14(%ebp)
  8011a8:	e8 08 f4 ff ff       	call   8005b5 <cputchar>
  8011ad:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  8011b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b6:	01 d0                	add    %edx,%eax
  8011b8:	c6 00 00             	movb   $0x0,(%eax)
			return;
  8011bb:	eb 06                	jmp    8011c3 <readline+0xfc>
		}
	}
  8011bd:	e9 3b ff ff ff       	jmp    8010fd <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  8011c2:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  8011c3:	c9                   	leave  
  8011c4:	c3                   	ret    

008011c5 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  8011c5:	55                   	push   %ebp
  8011c6:	89 e5                	mov    %esp,%ebp
  8011c8:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8011cb:	e8 5d 0b 00 00       	call   801d2d <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  8011d0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011d4:	74 13                	je     8011e9 <atomic_readline+0x24>
		cprintf("%s", prompt);
  8011d6:	83 ec 08             	sub    $0x8,%esp
  8011d9:	ff 75 08             	pushl  0x8(%ebp)
  8011dc:	68 90 2b 80 00       	push   $0x802b90
  8011e1:	e8 5f f8 ff ff       	call   800a45 <cprintf>
  8011e6:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8011e9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8011f0:	83 ec 0c             	sub    $0xc,%esp
  8011f3:	6a 00                	push   $0x0
  8011f5:	e8 51 f4 ff ff       	call   80064b <iscons>
  8011fa:	83 c4 10             	add    $0x10,%esp
  8011fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801200:	e8 f8 f3 ff ff       	call   8005fd <getchar>
  801205:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801208:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80120c:	79 23                	jns    801231 <atomic_readline+0x6c>
			if (c != -E_EOF)
  80120e:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801212:	74 13                	je     801227 <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  801214:	83 ec 08             	sub    $0x8,%esp
  801217:	ff 75 ec             	pushl  -0x14(%ebp)
  80121a:	68 93 2b 80 00       	push   $0x802b93
  80121f:	e8 21 f8 ff ff       	call   800a45 <cprintf>
  801224:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  801227:	e8 1b 0b 00 00       	call   801d47 <sys_enable_interrupt>
			return;
  80122c:	e9 9a 00 00 00       	jmp    8012cb <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801231:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801235:	7e 34                	jle    80126b <atomic_readline+0xa6>
  801237:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  80123e:	7f 2b                	jg     80126b <atomic_readline+0xa6>
			if (echoing)
  801240:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801244:	74 0e                	je     801254 <atomic_readline+0x8f>
				cputchar(c);
  801246:	83 ec 0c             	sub    $0xc,%esp
  801249:	ff 75 ec             	pushl  -0x14(%ebp)
  80124c:	e8 64 f3 ff ff       	call   8005b5 <cputchar>
  801251:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801254:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801257:	8d 50 01             	lea    0x1(%eax),%edx
  80125a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80125d:	89 c2                	mov    %eax,%edx
  80125f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801262:	01 d0                	add    %edx,%eax
  801264:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801267:	88 10                	mov    %dl,(%eax)
  801269:	eb 5b                	jmp    8012c6 <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  80126b:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80126f:	75 1f                	jne    801290 <atomic_readline+0xcb>
  801271:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801275:	7e 19                	jle    801290 <atomic_readline+0xcb>
			if (echoing)
  801277:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80127b:	74 0e                	je     80128b <atomic_readline+0xc6>
				cputchar(c);
  80127d:	83 ec 0c             	sub    $0xc,%esp
  801280:	ff 75 ec             	pushl  -0x14(%ebp)
  801283:	e8 2d f3 ff ff       	call   8005b5 <cputchar>
  801288:	83 c4 10             	add    $0x10,%esp
			i--;
  80128b:	ff 4d f4             	decl   -0xc(%ebp)
  80128e:	eb 36                	jmp    8012c6 <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  801290:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801294:	74 0a                	je     8012a0 <atomic_readline+0xdb>
  801296:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  80129a:	0f 85 60 ff ff ff    	jne    801200 <atomic_readline+0x3b>
			if (echoing)
  8012a0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012a4:	74 0e                	je     8012b4 <atomic_readline+0xef>
				cputchar(c);
  8012a6:	83 ec 0c             	sub    $0xc,%esp
  8012a9:	ff 75 ec             	pushl  -0x14(%ebp)
  8012ac:	e8 04 f3 ff ff       	call   8005b5 <cputchar>
  8012b1:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  8012b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ba:	01 d0                	add    %edx,%eax
  8012bc:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  8012bf:	e8 83 0a 00 00       	call   801d47 <sys_enable_interrupt>
			return;
  8012c4:	eb 05                	jmp    8012cb <atomic_readline+0x106>
		}
	}
  8012c6:	e9 35 ff ff ff       	jmp    801200 <atomic_readline+0x3b>
}
  8012cb:	c9                   	leave  
  8012cc:	c3                   	ret    

008012cd <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8012cd:	55                   	push   %ebp
  8012ce:	89 e5                	mov    %esp,%ebp
  8012d0:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8012d3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012da:	eb 06                	jmp    8012e2 <strlen+0x15>
		n++;
  8012dc:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8012df:	ff 45 08             	incl   0x8(%ebp)
  8012e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e5:	8a 00                	mov    (%eax),%al
  8012e7:	84 c0                	test   %al,%al
  8012e9:	75 f1                	jne    8012dc <strlen+0xf>
		n++;
	return n;
  8012eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012ee:	c9                   	leave  
  8012ef:	c3                   	ret    

008012f0 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8012f0:	55                   	push   %ebp
  8012f1:	89 e5                	mov    %esp,%ebp
  8012f3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012f6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012fd:	eb 09                	jmp    801308 <strnlen+0x18>
		n++;
  8012ff:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801302:	ff 45 08             	incl   0x8(%ebp)
  801305:	ff 4d 0c             	decl   0xc(%ebp)
  801308:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80130c:	74 09                	je     801317 <strnlen+0x27>
  80130e:	8b 45 08             	mov    0x8(%ebp),%eax
  801311:	8a 00                	mov    (%eax),%al
  801313:	84 c0                	test   %al,%al
  801315:	75 e8                	jne    8012ff <strnlen+0xf>
		n++;
	return n;
  801317:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80131a:	c9                   	leave  
  80131b:	c3                   	ret    

0080131c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80131c:	55                   	push   %ebp
  80131d:	89 e5                	mov    %esp,%ebp
  80131f:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801322:	8b 45 08             	mov    0x8(%ebp),%eax
  801325:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801328:	90                   	nop
  801329:	8b 45 08             	mov    0x8(%ebp),%eax
  80132c:	8d 50 01             	lea    0x1(%eax),%edx
  80132f:	89 55 08             	mov    %edx,0x8(%ebp)
  801332:	8b 55 0c             	mov    0xc(%ebp),%edx
  801335:	8d 4a 01             	lea    0x1(%edx),%ecx
  801338:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80133b:	8a 12                	mov    (%edx),%dl
  80133d:	88 10                	mov    %dl,(%eax)
  80133f:	8a 00                	mov    (%eax),%al
  801341:	84 c0                	test   %al,%al
  801343:	75 e4                	jne    801329 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801345:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801348:	c9                   	leave  
  801349:	c3                   	ret    

0080134a <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80134a:	55                   	push   %ebp
  80134b:	89 e5                	mov    %esp,%ebp
  80134d:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801350:	8b 45 08             	mov    0x8(%ebp),%eax
  801353:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801356:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80135d:	eb 1f                	jmp    80137e <strncpy+0x34>
		*dst++ = *src;
  80135f:	8b 45 08             	mov    0x8(%ebp),%eax
  801362:	8d 50 01             	lea    0x1(%eax),%edx
  801365:	89 55 08             	mov    %edx,0x8(%ebp)
  801368:	8b 55 0c             	mov    0xc(%ebp),%edx
  80136b:	8a 12                	mov    (%edx),%dl
  80136d:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80136f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801372:	8a 00                	mov    (%eax),%al
  801374:	84 c0                	test   %al,%al
  801376:	74 03                	je     80137b <strncpy+0x31>
			src++;
  801378:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80137b:	ff 45 fc             	incl   -0x4(%ebp)
  80137e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801381:	3b 45 10             	cmp    0x10(%ebp),%eax
  801384:	72 d9                	jb     80135f <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801386:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801389:	c9                   	leave  
  80138a:	c3                   	ret    

0080138b <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80138b:	55                   	push   %ebp
  80138c:	89 e5                	mov    %esp,%ebp
  80138e:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801391:	8b 45 08             	mov    0x8(%ebp),%eax
  801394:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801397:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80139b:	74 30                	je     8013cd <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80139d:	eb 16                	jmp    8013b5 <strlcpy+0x2a>
			*dst++ = *src++;
  80139f:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a2:	8d 50 01             	lea    0x1(%eax),%edx
  8013a5:	89 55 08             	mov    %edx,0x8(%ebp)
  8013a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013ab:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013ae:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8013b1:	8a 12                	mov    (%edx),%dl
  8013b3:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8013b5:	ff 4d 10             	decl   0x10(%ebp)
  8013b8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013bc:	74 09                	je     8013c7 <strlcpy+0x3c>
  8013be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c1:	8a 00                	mov    (%eax),%al
  8013c3:	84 c0                	test   %al,%al
  8013c5:	75 d8                	jne    80139f <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8013c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ca:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8013cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8013d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013d3:	29 c2                	sub    %eax,%edx
  8013d5:	89 d0                	mov    %edx,%eax
}
  8013d7:	c9                   	leave  
  8013d8:	c3                   	ret    

008013d9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8013d9:	55                   	push   %ebp
  8013da:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8013dc:	eb 06                	jmp    8013e4 <strcmp+0xb>
		p++, q++;
  8013de:	ff 45 08             	incl   0x8(%ebp)
  8013e1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8013e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e7:	8a 00                	mov    (%eax),%al
  8013e9:	84 c0                	test   %al,%al
  8013eb:	74 0e                	je     8013fb <strcmp+0x22>
  8013ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f0:	8a 10                	mov    (%eax),%dl
  8013f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f5:	8a 00                	mov    (%eax),%al
  8013f7:	38 c2                	cmp    %al,%dl
  8013f9:	74 e3                	je     8013de <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8013fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fe:	8a 00                	mov    (%eax),%al
  801400:	0f b6 d0             	movzbl %al,%edx
  801403:	8b 45 0c             	mov    0xc(%ebp),%eax
  801406:	8a 00                	mov    (%eax),%al
  801408:	0f b6 c0             	movzbl %al,%eax
  80140b:	29 c2                	sub    %eax,%edx
  80140d:	89 d0                	mov    %edx,%eax
}
  80140f:	5d                   	pop    %ebp
  801410:	c3                   	ret    

00801411 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801411:	55                   	push   %ebp
  801412:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801414:	eb 09                	jmp    80141f <strncmp+0xe>
		n--, p++, q++;
  801416:	ff 4d 10             	decl   0x10(%ebp)
  801419:	ff 45 08             	incl   0x8(%ebp)
  80141c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80141f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801423:	74 17                	je     80143c <strncmp+0x2b>
  801425:	8b 45 08             	mov    0x8(%ebp),%eax
  801428:	8a 00                	mov    (%eax),%al
  80142a:	84 c0                	test   %al,%al
  80142c:	74 0e                	je     80143c <strncmp+0x2b>
  80142e:	8b 45 08             	mov    0x8(%ebp),%eax
  801431:	8a 10                	mov    (%eax),%dl
  801433:	8b 45 0c             	mov    0xc(%ebp),%eax
  801436:	8a 00                	mov    (%eax),%al
  801438:	38 c2                	cmp    %al,%dl
  80143a:	74 da                	je     801416 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80143c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801440:	75 07                	jne    801449 <strncmp+0x38>
		return 0;
  801442:	b8 00 00 00 00       	mov    $0x0,%eax
  801447:	eb 14                	jmp    80145d <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801449:	8b 45 08             	mov    0x8(%ebp),%eax
  80144c:	8a 00                	mov    (%eax),%al
  80144e:	0f b6 d0             	movzbl %al,%edx
  801451:	8b 45 0c             	mov    0xc(%ebp),%eax
  801454:	8a 00                	mov    (%eax),%al
  801456:	0f b6 c0             	movzbl %al,%eax
  801459:	29 c2                	sub    %eax,%edx
  80145b:	89 d0                	mov    %edx,%eax
}
  80145d:	5d                   	pop    %ebp
  80145e:	c3                   	ret    

0080145f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80145f:	55                   	push   %ebp
  801460:	89 e5                	mov    %esp,%ebp
  801462:	83 ec 04             	sub    $0x4,%esp
  801465:	8b 45 0c             	mov    0xc(%ebp),%eax
  801468:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80146b:	eb 12                	jmp    80147f <strchr+0x20>
		if (*s == c)
  80146d:	8b 45 08             	mov    0x8(%ebp),%eax
  801470:	8a 00                	mov    (%eax),%al
  801472:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801475:	75 05                	jne    80147c <strchr+0x1d>
			return (char *) s;
  801477:	8b 45 08             	mov    0x8(%ebp),%eax
  80147a:	eb 11                	jmp    80148d <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80147c:	ff 45 08             	incl   0x8(%ebp)
  80147f:	8b 45 08             	mov    0x8(%ebp),%eax
  801482:	8a 00                	mov    (%eax),%al
  801484:	84 c0                	test   %al,%al
  801486:	75 e5                	jne    80146d <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801488:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80148d:	c9                   	leave  
  80148e:	c3                   	ret    

0080148f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80148f:	55                   	push   %ebp
  801490:	89 e5                	mov    %esp,%ebp
  801492:	83 ec 04             	sub    $0x4,%esp
  801495:	8b 45 0c             	mov    0xc(%ebp),%eax
  801498:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80149b:	eb 0d                	jmp    8014aa <strfind+0x1b>
		if (*s == c)
  80149d:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a0:	8a 00                	mov    (%eax),%al
  8014a2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8014a5:	74 0e                	je     8014b5 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8014a7:	ff 45 08             	incl   0x8(%ebp)
  8014aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ad:	8a 00                	mov    (%eax),%al
  8014af:	84 c0                	test   %al,%al
  8014b1:	75 ea                	jne    80149d <strfind+0xe>
  8014b3:	eb 01                	jmp    8014b6 <strfind+0x27>
		if (*s == c)
			break;
  8014b5:	90                   	nop
	return (char *) s;
  8014b6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014b9:	c9                   	leave  
  8014ba:	c3                   	ret    

008014bb <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8014bb:	55                   	push   %ebp
  8014bc:	89 e5                	mov    %esp,%ebp
  8014be:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8014c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8014c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ca:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8014cd:	eb 0e                	jmp    8014dd <memset+0x22>
		*p++ = c;
  8014cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014d2:	8d 50 01             	lea    0x1(%eax),%edx
  8014d5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014db:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8014dd:	ff 4d f8             	decl   -0x8(%ebp)
  8014e0:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8014e4:	79 e9                	jns    8014cf <memset+0x14>
		*p++ = c;

	return v;
  8014e6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014e9:	c9                   	leave  
  8014ea:	c3                   	ret    

008014eb <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8014eb:	55                   	push   %ebp
  8014ec:	89 e5                	mov    %esp,%ebp
  8014ee:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8014f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8014f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fa:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8014fd:	eb 16                	jmp    801515 <memcpy+0x2a>
		*d++ = *s++;
  8014ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801502:	8d 50 01             	lea    0x1(%eax),%edx
  801505:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801508:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80150b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80150e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801511:	8a 12                	mov    (%edx),%dl
  801513:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801515:	8b 45 10             	mov    0x10(%ebp),%eax
  801518:	8d 50 ff             	lea    -0x1(%eax),%edx
  80151b:	89 55 10             	mov    %edx,0x10(%ebp)
  80151e:	85 c0                	test   %eax,%eax
  801520:	75 dd                	jne    8014ff <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801522:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801525:	c9                   	leave  
  801526:	c3                   	ret    

00801527 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801527:	55                   	push   %ebp
  801528:	89 e5                	mov    %esp,%ebp
  80152a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80152d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801530:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801533:	8b 45 08             	mov    0x8(%ebp),%eax
  801536:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801539:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80153c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80153f:	73 50                	jae    801591 <memmove+0x6a>
  801541:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801544:	8b 45 10             	mov    0x10(%ebp),%eax
  801547:	01 d0                	add    %edx,%eax
  801549:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80154c:	76 43                	jbe    801591 <memmove+0x6a>
		s += n;
  80154e:	8b 45 10             	mov    0x10(%ebp),%eax
  801551:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801554:	8b 45 10             	mov    0x10(%ebp),%eax
  801557:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80155a:	eb 10                	jmp    80156c <memmove+0x45>
			*--d = *--s;
  80155c:	ff 4d f8             	decl   -0x8(%ebp)
  80155f:	ff 4d fc             	decl   -0x4(%ebp)
  801562:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801565:	8a 10                	mov    (%eax),%dl
  801567:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80156a:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80156c:	8b 45 10             	mov    0x10(%ebp),%eax
  80156f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801572:	89 55 10             	mov    %edx,0x10(%ebp)
  801575:	85 c0                	test   %eax,%eax
  801577:	75 e3                	jne    80155c <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801579:	eb 23                	jmp    80159e <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80157b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80157e:	8d 50 01             	lea    0x1(%eax),%edx
  801581:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801584:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801587:	8d 4a 01             	lea    0x1(%edx),%ecx
  80158a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80158d:	8a 12                	mov    (%edx),%dl
  80158f:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801591:	8b 45 10             	mov    0x10(%ebp),%eax
  801594:	8d 50 ff             	lea    -0x1(%eax),%edx
  801597:	89 55 10             	mov    %edx,0x10(%ebp)
  80159a:	85 c0                	test   %eax,%eax
  80159c:	75 dd                	jne    80157b <memmove+0x54>
			*d++ = *s++;

	return dst;
  80159e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015a1:	c9                   	leave  
  8015a2:	c3                   	ret    

008015a3 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8015a3:	55                   	push   %ebp
  8015a4:	89 e5                	mov    %esp,%ebp
  8015a6:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8015a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ac:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8015af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015b2:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8015b5:	eb 2a                	jmp    8015e1 <memcmp+0x3e>
		if (*s1 != *s2)
  8015b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015ba:	8a 10                	mov    (%eax),%dl
  8015bc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015bf:	8a 00                	mov    (%eax),%al
  8015c1:	38 c2                	cmp    %al,%dl
  8015c3:	74 16                	je     8015db <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8015c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015c8:	8a 00                	mov    (%eax),%al
  8015ca:	0f b6 d0             	movzbl %al,%edx
  8015cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015d0:	8a 00                	mov    (%eax),%al
  8015d2:	0f b6 c0             	movzbl %al,%eax
  8015d5:	29 c2                	sub    %eax,%edx
  8015d7:	89 d0                	mov    %edx,%eax
  8015d9:	eb 18                	jmp    8015f3 <memcmp+0x50>
		s1++, s2++;
  8015db:	ff 45 fc             	incl   -0x4(%ebp)
  8015de:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8015e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8015e4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015e7:	89 55 10             	mov    %edx,0x10(%ebp)
  8015ea:	85 c0                	test   %eax,%eax
  8015ec:	75 c9                	jne    8015b7 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8015ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015f3:	c9                   	leave  
  8015f4:	c3                   	ret    

008015f5 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8015f5:	55                   	push   %ebp
  8015f6:	89 e5                	mov    %esp,%ebp
  8015f8:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8015fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8015fe:	8b 45 10             	mov    0x10(%ebp),%eax
  801601:	01 d0                	add    %edx,%eax
  801603:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801606:	eb 15                	jmp    80161d <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801608:	8b 45 08             	mov    0x8(%ebp),%eax
  80160b:	8a 00                	mov    (%eax),%al
  80160d:	0f b6 d0             	movzbl %al,%edx
  801610:	8b 45 0c             	mov    0xc(%ebp),%eax
  801613:	0f b6 c0             	movzbl %al,%eax
  801616:	39 c2                	cmp    %eax,%edx
  801618:	74 0d                	je     801627 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80161a:	ff 45 08             	incl   0x8(%ebp)
  80161d:	8b 45 08             	mov    0x8(%ebp),%eax
  801620:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801623:	72 e3                	jb     801608 <memfind+0x13>
  801625:	eb 01                	jmp    801628 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801627:	90                   	nop
	return (void *) s;
  801628:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80162b:	c9                   	leave  
  80162c:	c3                   	ret    

0080162d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80162d:	55                   	push   %ebp
  80162e:	89 e5                	mov    %esp,%ebp
  801630:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801633:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80163a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801641:	eb 03                	jmp    801646 <strtol+0x19>
		s++;
  801643:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801646:	8b 45 08             	mov    0x8(%ebp),%eax
  801649:	8a 00                	mov    (%eax),%al
  80164b:	3c 20                	cmp    $0x20,%al
  80164d:	74 f4                	je     801643 <strtol+0x16>
  80164f:	8b 45 08             	mov    0x8(%ebp),%eax
  801652:	8a 00                	mov    (%eax),%al
  801654:	3c 09                	cmp    $0x9,%al
  801656:	74 eb                	je     801643 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801658:	8b 45 08             	mov    0x8(%ebp),%eax
  80165b:	8a 00                	mov    (%eax),%al
  80165d:	3c 2b                	cmp    $0x2b,%al
  80165f:	75 05                	jne    801666 <strtol+0x39>
		s++;
  801661:	ff 45 08             	incl   0x8(%ebp)
  801664:	eb 13                	jmp    801679 <strtol+0x4c>
	else if (*s == '-')
  801666:	8b 45 08             	mov    0x8(%ebp),%eax
  801669:	8a 00                	mov    (%eax),%al
  80166b:	3c 2d                	cmp    $0x2d,%al
  80166d:	75 0a                	jne    801679 <strtol+0x4c>
		s++, neg = 1;
  80166f:	ff 45 08             	incl   0x8(%ebp)
  801672:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801679:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80167d:	74 06                	je     801685 <strtol+0x58>
  80167f:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801683:	75 20                	jne    8016a5 <strtol+0x78>
  801685:	8b 45 08             	mov    0x8(%ebp),%eax
  801688:	8a 00                	mov    (%eax),%al
  80168a:	3c 30                	cmp    $0x30,%al
  80168c:	75 17                	jne    8016a5 <strtol+0x78>
  80168e:	8b 45 08             	mov    0x8(%ebp),%eax
  801691:	40                   	inc    %eax
  801692:	8a 00                	mov    (%eax),%al
  801694:	3c 78                	cmp    $0x78,%al
  801696:	75 0d                	jne    8016a5 <strtol+0x78>
		s += 2, base = 16;
  801698:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80169c:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8016a3:	eb 28                	jmp    8016cd <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8016a5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016a9:	75 15                	jne    8016c0 <strtol+0x93>
  8016ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ae:	8a 00                	mov    (%eax),%al
  8016b0:	3c 30                	cmp    $0x30,%al
  8016b2:	75 0c                	jne    8016c0 <strtol+0x93>
		s++, base = 8;
  8016b4:	ff 45 08             	incl   0x8(%ebp)
  8016b7:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8016be:	eb 0d                	jmp    8016cd <strtol+0xa0>
	else if (base == 0)
  8016c0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016c4:	75 07                	jne    8016cd <strtol+0xa0>
		base = 10;
  8016c6:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8016cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d0:	8a 00                	mov    (%eax),%al
  8016d2:	3c 2f                	cmp    $0x2f,%al
  8016d4:	7e 19                	jle    8016ef <strtol+0xc2>
  8016d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d9:	8a 00                	mov    (%eax),%al
  8016db:	3c 39                	cmp    $0x39,%al
  8016dd:	7f 10                	jg     8016ef <strtol+0xc2>
			dig = *s - '0';
  8016df:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e2:	8a 00                	mov    (%eax),%al
  8016e4:	0f be c0             	movsbl %al,%eax
  8016e7:	83 e8 30             	sub    $0x30,%eax
  8016ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016ed:	eb 42                	jmp    801731 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8016ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f2:	8a 00                	mov    (%eax),%al
  8016f4:	3c 60                	cmp    $0x60,%al
  8016f6:	7e 19                	jle    801711 <strtol+0xe4>
  8016f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fb:	8a 00                	mov    (%eax),%al
  8016fd:	3c 7a                	cmp    $0x7a,%al
  8016ff:	7f 10                	jg     801711 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801701:	8b 45 08             	mov    0x8(%ebp),%eax
  801704:	8a 00                	mov    (%eax),%al
  801706:	0f be c0             	movsbl %al,%eax
  801709:	83 e8 57             	sub    $0x57,%eax
  80170c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80170f:	eb 20                	jmp    801731 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801711:	8b 45 08             	mov    0x8(%ebp),%eax
  801714:	8a 00                	mov    (%eax),%al
  801716:	3c 40                	cmp    $0x40,%al
  801718:	7e 39                	jle    801753 <strtol+0x126>
  80171a:	8b 45 08             	mov    0x8(%ebp),%eax
  80171d:	8a 00                	mov    (%eax),%al
  80171f:	3c 5a                	cmp    $0x5a,%al
  801721:	7f 30                	jg     801753 <strtol+0x126>
			dig = *s - 'A' + 10;
  801723:	8b 45 08             	mov    0x8(%ebp),%eax
  801726:	8a 00                	mov    (%eax),%al
  801728:	0f be c0             	movsbl %al,%eax
  80172b:	83 e8 37             	sub    $0x37,%eax
  80172e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801731:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801734:	3b 45 10             	cmp    0x10(%ebp),%eax
  801737:	7d 19                	jge    801752 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801739:	ff 45 08             	incl   0x8(%ebp)
  80173c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80173f:	0f af 45 10          	imul   0x10(%ebp),%eax
  801743:	89 c2                	mov    %eax,%edx
  801745:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801748:	01 d0                	add    %edx,%eax
  80174a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80174d:	e9 7b ff ff ff       	jmp    8016cd <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801752:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801753:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801757:	74 08                	je     801761 <strtol+0x134>
		*endptr = (char *) s;
  801759:	8b 45 0c             	mov    0xc(%ebp),%eax
  80175c:	8b 55 08             	mov    0x8(%ebp),%edx
  80175f:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801761:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801765:	74 07                	je     80176e <strtol+0x141>
  801767:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80176a:	f7 d8                	neg    %eax
  80176c:	eb 03                	jmp    801771 <strtol+0x144>
  80176e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801771:	c9                   	leave  
  801772:	c3                   	ret    

00801773 <ltostr>:

void
ltostr(long value, char *str)
{
  801773:	55                   	push   %ebp
  801774:	89 e5                	mov    %esp,%ebp
  801776:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801779:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801780:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801787:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80178b:	79 13                	jns    8017a0 <ltostr+0x2d>
	{
		neg = 1;
  80178d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801794:	8b 45 0c             	mov    0xc(%ebp),%eax
  801797:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80179a:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80179d:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8017a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a3:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8017a8:	99                   	cltd   
  8017a9:	f7 f9                	idiv   %ecx
  8017ab:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8017ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017b1:	8d 50 01             	lea    0x1(%eax),%edx
  8017b4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8017b7:	89 c2                	mov    %eax,%edx
  8017b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017bc:	01 d0                	add    %edx,%eax
  8017be:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8017c1:	83 c2 30             	add    $0x30,%edx
  8017c4:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8017c6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017c9:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8017ce:	f7 e9                	imul   %ecx
  8017d0:	c1 fa 02             	sar    $0x2,%edx
  8017d3:	89 c8                	mov    %ecx,%eax
  8017d5:	c1 f8 1f             	sar    $0x1f,%eax
  8017d8:	29 c2                	sub    %eax,%edx
  8017da:	89 d0                	mov    %edx,%eax
  8017dc:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8017df:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017e2:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8017e7:	f7 e9                	imul   %ecx
  8017e9:	c1 fa 02             	sar    $0x2,%edx
  8017ec:	89 c8                	mov    %ecx,%eax
  8017ee:	c1 f8 1f             	sar    $0x1f,%eax
  8017f1:	29 c2                	sub    %eax,%edx
  8017f3:	89 d0                	mov    %edx,%eax
  8017f5:	c1 e0 02             	shl    $0x2,%eax
  8017f8:	01 d0                	add    %edx,%eax
  8017fa:	01 c0                	add    %eax,%eax
  8017fc:	29 c1                	sub    %eax,%ecx
  8017fe:	89 ca                	mov    %ecx,%edx
  801800:	85 d2                	test   %edx,%edx
  801802:	75 9c                	jne    8017a0 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801804:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80180b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80180e:	48                   	dec    %eax
  80180f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801812:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801816:	74 3d                	je     801855 <ltostr+0xe2>
		start = 1 ;
  801818:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80181f:	eb 34                	jmp    801855 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801821:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801824:	8b 45 0c             	mov    0xc(%ebp),%eax
  801827:	01 d0                	add    %edx,%eax
  801829:	8a 00                	mov    (%eax),%al
  80182b:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80182e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801831:	8b 45 0c             	mov    0xc(%ebp),%eax
  801834:	01 c2                	add    %eax,%edx
  801836:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801839:	8b 45 0c             	mov    0xc(%ebp),%eax
  80183c:	01 c8                	add    %ecx,%eax
  80183e:	8a 00                	mov    (%eax),%al
  801840:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801842:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801845:	8b 45 0c             	mov    0xc(%ebp),%eax
  801848:	01 c2                	add    %eax,%edx
  80184a:	8a 45 eb             	mov    -0x15(%ebp),%al
  80184d:	88 02                	mov    %al,(%edx)
		start++ ;
  80184f:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801852:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801855:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801858:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80185b:	7c c4                	jl     801821 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80185d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801860:	8b 45 0c             	mov    0xc(%ebp),%eax
  801863:	01 d0                	add    %edx,%eax
  801865:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801868:	90                   	nop
  801869:	c9                   	leave  
  80186a:	c3                   	ret    

0080186b <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80186b:	55                   	push   %ebp
  80186c:	89 e5                	mov    %esp,%ebp
  80186e:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801871:	ff 75 08             	pushl  0x8(%ebp)
  801874:	e8 54 fa ff ff       	call   8012cd <strlen>
  801879:	83 c4 04             	add    $0x4,%esp
  80187c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80187f:	ff 75 0c             	pushl  0xc(%ebp)
  801882:	e8 46 fa ff ff       	call   8012cd <strlen>
  801887:	83 c4 04             	add    $0x4,%esp
  80188a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80188d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801894:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80189b:	eb 17                	jmp    8018b4 <strcconcat+0x49>
		final[s] = str1[s] ;
  80189d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8018a3:	01 c2                	add    %eax,%edx
  8018a5:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8018a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ab:	01 c8                	add    %ecx,%eax
  8018ad:	8a 00                	mov    (%eax),%al
  8018af:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8018b1:	ff 45 fc             	incl   -0x4(%ebp)
  8018b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018b7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8018ba:	7c e1                	jl     80189d <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8018bc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8018c3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8018ca:	eb 1f                	jmp    8018eb <strcconcat+0x80>
		final[s++] = str2[i] ;
  8018cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018cf:	8d 50 01             	lea    0x1(%eax),%edx
  8018d2:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8018d5:	89 c2                	mov    %eax,%edx
  8018d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8018da:	01 c2                	add    %eax,%edx
  8018dc:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8018df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018e2:	01 c8                	add    %ecx,%eax
  8018e4:	8a 00                	mov    (%eax),%al
  8018e6:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8018e8:	ff 45 f8             	incl   -0x8(%ebp)
  8018eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018ee:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8018f1:	7c d9                	jl     8018cc <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8018f3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8018f9:	01 d0                	add    %edx,%eax
  8018fb:	c6 00 00             	movb   $0x0,(%eax)
}
  8018fe:	90                   	nop
  8018ff:	c9                   	leave  
  801900:	c3                   	ret    

00801901 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801901:	55                   	push   %ebp
  801902:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801904:	8b 45 14             	mov    0x14(%ebp),%eax
  801907:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80190d:	8b 45 14             	mov    0x14(%ebp),%eax
  801910:	8b 00                	mov    (%eax),%eax
  801912:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801919:	8b 45 10             	mov    0x10(%ebp),%eax
  80191c:	01 d0                	add    %edx,%eax
  80191e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801924:	eb 0c                	jmp    801932 <strsplit+0x31>
			*string++ = 0;
  801926:	8b 45 08             	mov    0x8(%ebp),%eax
  801929:	8d 50 01             	lea    0x1(%eax),%edx
  80192c:	89 55 08             	mov    %edx,0x8(%ebp)
  80192f:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801932:	8b 45 08             	mov    0x8(%ebp),%eax
  801935:	8a 00                	mov    (%eax),%al
  801937:	84 c0                	test   %al,%al
  801939:	74 18                	je     801953 <strsplit+0x52>
  80193b:	8b 45 08             	mov    0x8(%ebp),%eax
  80193e:	8a 00                	mov    (%eax),%al
  801940:	0f be c0             	movsbl %al,%eax
  801943:	50                   	push   %eax
  801944:	ff 75 0c             	pushl  0xc(%ebp)
  801947:	e8 13 fb ff ff       	call   80145f <strchr>
  80194c:	83 c4 08             	add    $0x8,%esp
  80194f:	85 c0                	test   %eax,%eax
  801951:	75 d3                	jne    801926 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801953:	8b 45 08             	mov    0x8(%ebp),%eax
  801956:	8a 00                	mov    (%eax),%al
  801958:	84 c0                	test   %al,%al
  80195a:	74 5a                	je     8019b6 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80195c:	8b 45 14             	mov    0x14(%ebp),%eax
  80195f:	8b 00                	mov    (%eax),%eax
  801961:	83 f8 0f             	cmp    $0xf,%eax
  801964:	75 07                	jne    80196d <strsplit+0x6c>
		{
			return 0;
  801966:	b8 00 00 00 00       	mov    $0x0,%eax
  80196b:	eb 66                	jmp    8019d3 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80196d:	8b 45 14             	mov    0x14(%ebp),%eax
  801970:	8b 00                	mov    (%eax),%eax
  801972:	8d 48 01             	lea    0x1(%eax),%ecx
  801975:	8b 55 14             	mov    0x14(%ebp),%edx
  801978:	89 0a                	mov    %ecx,(%edx)
  80197a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801981:	8b 45 10             	mov    0x10(%ebp),%eax
  801984:	01 c2                	add    %eax,%edx
  801986:	8b 45 08             	mov    0x8(%ebp),%eax
  801989:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80198b:	eb 03                	jmp    801990 <strsplit+0x8f>
			string++;
  80198d:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801990:	8b 45 08             	mov    0x8(%ebp),%eax
  801993:	8a 00                	mov    (%eax),%al
  801995:	84 c0                	test   %al,%al
  801997:	74 8b                	je     801924 <strsplit+0x23>
  801999:	8b 45 08             	mov    0x8(%ebp),%eax
  80199c:	8a 00                	mov    (%eax),%al
  80199e:	0f be c0             	movsbl %al,%eax
  8019a1:	50                   	push   %eax
  8019a2:	ff 75 0c             	pushl  0xc(%ebp)
  8019a5:	e8 b5 fa ff ff       	call   80145f <strchr>
  8019aa:	83 c4 08             	add    $0x8,%esp
  8019ad:	85 c0                	test   %eax,%eax
  8019af:	74 dc                	je     80198d <strsplit+0x8c>
			string++;
	}
  8019b1:	e9 6e ff ff ff       	jmp    801924 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8019b6:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8019b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8019ba:	8b 00                	mov    (%eax),%eax
  8019bc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8019c6:	01 d0                	add    %edx,%eax
  8019c8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8019ce:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8019d3:	c9                   	leave  
  8019d4:	c3                   	ret    

008019d5 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8019d5:	55                   	push   %ebp
  8019d6:	89 e5                	mov    %esp,%ebp
  8019d8:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8019db:	a1 04 30 80 00       	mov    0x803004,%eax
  8019e0:	85 c0                	test   %eax,%eax
  8019e2:	74 1f                	je     801a03 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8019e4:	e8 1d 00 00 00       	call   801a06 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8019e9:	83 ec 0c             	sub    $0xc,%esp
  8019ec:	68 a4 2b 80 00       	push   $0x802ba4
  8019f1:	e8 4f f0 ff ff       	call   800a45 <cprintf>
  8019f6:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8019f9:	c7 05 04 30 80 00 00 	movl   $0x0,0x803004
  801a00:	00 00 00 
	}
}
  801a03:	90                   	nop
  801a04:	c9                   	leave  
  801a05:	c3                   	ret    

00801a06 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801a06:	55                   	push   %ebp
  801a07:	89 e5                	mov    %esp,%ebp
  801a09:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	panic("initialize_dyn_block_system() is not implemented yet...!!");
  801a0c:	83 ec 04             	sub    $0x4,%esp
  801a0f:	68 cc 2b 80 00       	push   $0x802bcc
  801a14:	6a 21                	push   $0x21
  801a16:	68 06 2c 80 00       	push   $0x802c06
  801a1b:	e8 71 ed ff ff       	call   800791 <_panic>

00801a20 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801a20:	55                   	push   %ebp
  801a21:	89 e5                	mov    %esp,%ebp
  801a23:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801a26:	e8 aa ff ff ff       	call   8019d5 <InitializeUHeap>
	if (size == 0) return NULL ;
  801a2b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a2f:	75 07                	jne    801a38 <malloc+0x18>
  801a31:	b8 00 00 00 00       	mov    $0x0,%eax
  801a36:	eb 14                	jmp    801a4c <malloc+0x2c>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801a38:	83 ec 04             	sub    $0x4,%esp
  801a3b:	68 14 2c 80 00       	push   $0x802c14
  801a40:	6a 39                	push   $0x39
  801a42:	68 06 2c 80 00       	push   $0x802c06
  801a47:	e8 45 ed ff ff       	call   800791 <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801a4c:	c9                   	leave  
  801a4d:	c3                   	ret    

00801a4e <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801a4e:	55                   	push   %ebp
  801a4f:	89 e5                	mov    %esp,%ebp
  801a51:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801a54:	83 ec 04             	sub    $0x4,%esp
  801a57:	68 3c 2c 80 00       	push   $0x802c3c
  801a5c:	6a 54                	push   $0x54
  801a5e:	68 06 2c 80 00       	push   $0x802c06
  801a63:	e8 29 ed ff ff       	call   800791 <_panic>

00801a68 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801a68:	55                   	push   %ebp
  801a69:	89 e5                	mov    %esp,%ebp
  801a6b:	83 ec 18             	sub    $0x18,%esp
  801a6e:	8b 45 10             	mov    0x10(%ebp),%eax
  801a71:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801a74:	e8 5c ff ff ff       	call   8019d5 <InitializeUHeap>
	if (size == 0) return NULL ;
  801a79:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a7d:	75 07                	jne    801a86 <smalloc+0x1e>
  801a7f:	b8 00 00 00 00       	mov    $0x0,%eax
  801a84:	eb 14                	jmp    801a9a <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801a86:	83 ec 04             	sub    $0x4,%esp
  801a89:	68 60 2c 80 00       	push   $0x802c60
  801a8e:	6a 69                	push   $0x69
  801a90:	68 06 2c 80 00       	push   $0x802c06
  801a95:	e8 f7 ec ff ff       	call   800791 <_panic>

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801a9a:	c9                   	leave  
  801a9b:	c3                   	ret    

00801a9c <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801a9c:	55                   	push   %ebp
  801a9d:	89 e5                	mov    %esp,%ebp
  801a9f:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801aa2:	e8 2e ff ff ff       	call   8019d5 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801aa7:	83 ec 04             	sub    $0x4,%esp
  801aaa:	68 88 2c 80 00       	push   $0x802c88
  801aaf:	68 86 00 00 00       	push   $0x86
  801ab4:	68 06 2c 80 00       	push   $0x802c06
  801ab9:	e8 d3 ec ff ff       	call   800791 <_panic>

00801abe <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801abe:	55                   	push   %ebp
  801abf:	89 e5                	mov    %esp,%ebp
  801ac1:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801ac4:	e8 0c ff ff ff       	call   8019d5 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801ac9:	83 ec 04             	sub    $0x4,%esp
  801acc:	68 ac 2c 80 00       	push   $0x802cac
  801ad1:	68 b8 00 00 00       	push   $0xb8
  801ad6:	68 06 2c 80 00       	push   $0x802c06
  801adb:	e8 b1 ec ff ff       	call   800791 <_panic>

00801ae0 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801ae0:	55                   	push   %ebp
  801ae1:	89 e5                	mov    %esp,%ebp
  801ae3:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801ae6:	83 ec 04             	sub    $0x4,%esp
  801ae9:	68 d4 2c 80 00       	push   $0x802cd4
  801aee:	68 cc 00 00 00       	push   $0xcc
  801af3:	68 06 2c 80 00       	push   $0x802c06
  801af8:	e8 94 ec ff ff       	call   800791 <_panic>

00801afd <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801afd:	55                   	push   %ebp
  801afe:	89 e5                	mov    %esp,%ebp
  801b00:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801b03:	83 ec 04             	sub    $0x4,%esp
  801b06:	68 f8 2c 80 00       	push   $0x802cf8
  801b0b:	68 d7 00 00 00       	push   $0xd7
  801b10:	68 06 2c 80 00       	push   $0x802c06
  801b15:	e8 77 ec ff ff       	call   800791 <_panic>

00801b1a <shrink>:

}
void shrink(uint32 newSize)
{
  801b1a:	55                   	push   %ebp
  801b1b:	89 e5                	mov    %esp,%ebp
  801b1d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801b20:	83 ec 04             	sub    $0x4,%esp
  801b23:	68 f8 2c 80 00       	push   $0x802cf8
  801b28:	68 dc 00 00 00       	push   $0xdc
  801b2d:	68 06 2c 80 00       	push   $0x802c06
  801b32:	e8 5a ec ff ff       	call   800791 <_panic>

00801b37 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801b37:	55                   	push   %ebp
  801b38:	89 e5                	mov    %esp,%ebp
  801b3a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801b3d:	83 ec 04             	sub    $0x4,%esp
  801b40:	68 f8 2c 80 00       	push   $0x802cf8
  801b45:	68 e1 00 00 00       	push   $0xe1
  801b4a:	68 06 2c 80 00       	push   $0x802c06
  801b4f:	e8 3d ec ff ff       	call   800791 <_panic>

00801b54 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801b54:	55                   	push   %ebp
  801b55:	89 e5                	mov    %esp,%ebp
  801b57:	57                   	push   %edi
  801b58:	56                   	push   %esi
  801b59:	53                   	push   %ebx
  801b5a:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b60:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b63:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b66:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b69:	8b 7d 18             	mov    0x18(%ebp),%edi
  801b6c:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801b6f:	cd 30                	int    $0x30
  801b71:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801b74:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801b77:	83 c4 10             	add    $0x10,%esp
  801b7a:	5b                   	pop    %ebx
  801b7b:	5e                   	pop    %esi
  801b7c:	5f                   	pop    %edi
  801b7d:	5d                   	pop    %ebp
  801b7e:	c3                   	ret    

00801b7f <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801b7f:	55                   	push   %ebp
  801b80:	89 e5                	mov    %esp,%ebp
  801b82:	83 ec 04             	sub    $0x4,%esp
  801b85:	8b 45 10             	mov    0x10(%ebp),%eax
  801b88:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801b8b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b92:	6a 00                	push   $0x0
  801b94:	6a 00                	push   $0x0
  801b96:	52                   	push   %edx
  801b97:	ff 75 0c             	pushl  0xc(%ebp)
  801b9a:	50                   	push   %eax
  801b9b:	6a 00                	push   $0x0
  801b9d:	e8 b2 ff ff ff       	call   801b54 <syscall>
  801ba2:	83 c4 18             	add    $0x18,%esp
}
  801ba5:	90                   	nop
  801ba6:	c9                   	leave  
  801ba7:	c3                   	ret    

00801ba8 <sys_cgetc>:

int
sys_cgetc(void)
{
  801ba8:	55                   	push   %ebp
  801ba9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801bab:	6a 00                	push   $0x0
  801bad:	6a 00                	push   $0x0
  801baf:	6a 00                	push   $0x0
  801bb1:	6a 00                	push   $0x0
  801bb3:	6a 00                	push   $0x0
  801bb5:	6a 01                	push   $0x1
  801bb7:	e8 98 ff ff ff       	call   801b54 <syscall>
  801bbc:	83 c4 18             	add    $0x18,%esp
}
  801bbf:	c9                   	leave  
  801bc0:	c3                   	ret    

00801bc1 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801bc1:	55                   	push   %ebp
  801bc2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801bc4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bc7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bca:	6a 00                	push   $0x0
  801bcc:	6a 00                	push   $0x0
  801bce:	6a 00                	push   $0x0
  801bd0:	52                   	push   %edx
  801bd1:	50                   	push   %eax
  801bd2:	6a 05                	push   $0x5
  801bd4:	e8 7b ff ff ff       	call   801b54 <syscall>
  801bd9:	83 c4 18             	add    $0x18,%esp
}
  801bdc:	c9                   	leave  
  801bdd:	c3                   	ret    

00801bde <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801bde:	55                   	push   %ebp
  801bdf:	89 e5                	mov    %esp,%ebp
  801be1:	56                   	push   %esi
  801be2:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801be3:	8b 75 18             	mov    0x18(%ebp),%esi
  801be6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801be9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bec:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bef:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf2:	56                   	push   %esi
  801bf3:	53                   	push   %ebx
  801bf4:	51                   	push   %ecx
  801bf5:	52                   	push   %edx
  801bf6:	50                   	push   %eax
  801bf7:	6a 06                	push   $0x6
  801bf9:	e8 56 ff ff ff       	call   801b54 <syscall>
  801bfe:	83 c4 18             	add    $0x18,%esp
}
  801c01:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c04:	5b                   	pop    %ebx
  801c05:	5e                   	pop    %esi
  801c06:	5d                   	pop    %ebp
  801c07:	c3                   	ret    

00801c08 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801c08:	55                   	push   %ebp
  801c09:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801c0b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c11:	6a 00                	push   $0x0
  801c13:	6a 00                	push   $0x0
  801c15:	6a 00                	push   $0x0
  801c17:	52                   	push   %edx
  801c18:	50                   	push   %eax
  801c19:	6a 07                	push   $0x7
  801c1b:	e8 34 ff ff ff       	call   801b54 <syscall>
  801c20:	83 c4 18             	add    $0x18,%esp
}
  801c23:	c9                   	leave  
  801c24:	c3                   	ret    

00801c25 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801c25:	55                   	push   %ebp
  801c26:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801c28:	6a 00                	push   $0x0
  801c2a:	6a 00                	push   $0x0
  801c2c:	6a 00                	push   $0x0
  801c2e:	ff 75 0c             	pushl  0xc(%ebp)
  801c31:	ff 75 08             	pushl  0x8(%ebp)
  801c34:	6a 08                	push   $0x8
  801c36:	e8 19 ff ff ff       	call   801b54 <syscall>
  801c3b:	83 c4 18             	add    $0x18,%esp
}
  801c3e:	c9                   	leave  
  801c3f:	c3                   	ret    

00801c40 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801c40:	55                   	push   %ebp
  801c41:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801c43:	6a 00                	push   $0x0
  801c45:	6a 00                	push   $0x0
  801c47:	6a 00                	push   $0x0
  801c49:	6a 00                	push   $0x0
  801c4b:	6a 00                	push   $0x0
  801c4d:	6a 09                	push   $0x9
  801c4f:	e8 00 ff ff ff       	call   801b54 <syscall>
  801c54:	83 c4 18             	add    $0x18,%esp
}
  801c57:	c9                   	leave  
  801c58:	c3                   	ret    

00801c59 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801c59:	55                   	push   %ebp
  801c5a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801c5c:	6a 00                	push   $0x0
  801c5e:	6a 00                	push   $0x0
  801c60:	6a 00                	push   $0x0
  801c62:	6a 00                	push   $0x0
  801c64:	6a 00                	push   $0x0
  801c66:	6a 0a                	push   $0xa
  801c68:	e8 e7 fe ff ff       	call   801b54 <syscall>
  801c6d:	83 c4 18             	add    $0x18,%esp
}
  801c70:	c9                   	leave  
  801c71:	c3                   	ret    

00801c72 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801c72:	55                   	push   %ebp
  801c73:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801c75:	6a 00                	push   $0x0
  801c77:	6a 00                	push   $0x0
  801c79:	6a 00                	push   $0x0
  801c7b:	6a 00                	push   $0x0
  801c7d:	6a 00                	push   $0x0
  801c7f:	6a 0b                	push   $0xb
  801c81:	e8 ce fe ff ff       	call   801b54 <syscall>
  801c86:	83 c4 18             	add    $0x18,%esp
}
  801c89:	c9                   	leave  
  801c8a:	c3                   	ret    

00801c8b <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801c8b:	55                   	push   %ebp
  801c8c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801c8e:	6a 00                	push   $0x0
  801c90:	6a 00                	push   $0x0
  801c92:	6a 00                	push   $0x0
  801c94:	ff 75 0c             	pushl  0xc(%ebp)
  801c97:	ff 75 08             	pushl  0x8(%ebp)
  801c9a:	6a 0f                	push   $0xf
  801c9c:	e8 b3 fe ff ff       	call   801b54 <syscall>
  801ca1:	83 c4 18             	add    $0x18,%esp
	return;
  801ca4:	90                   	nop
}
  801ca5:	c9                   	leave  
  801ca6:	c3                   	ret    

00801ca7 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801ca7:	55                   	push   %ebp
  801ca8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801caa:	6a 00                	push   $0x0
  801cac:	6a 00                	push   $0x0
  801cae:	6a 00                	push   $0x0
  801cb0:	ff 75 0c             	pushl  0xc(%ebp)
  801cb3:	ff 75 08             	pushl  0x8(%ebp)
  801cb6:	6a 10                	push   $0x10
  801cb8:	e8 97 fe ff ff       	call   801b54 <syscall>
  801cbd:	83 c4 18             	add    $0x18,%esp
	return ;
  801cc0:	90                   	nop
}
  801cc1:	c9                   	leave  
  801cc2:	c3                   	ret    

00801cc3 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801cc3:	55                   	push   %ebp
  801cc4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801cc6:	6a 00                	push   $0x0
  801cc8:	6a 00                	push   $0x0
  801cca:	ff 75 10             	pushl  0x10(%ebp)
  801ccd:	ff 75 0c             	pushl  0xc(%ebp)
  801cd0:	ff 75 08             	pushl  0x8(%ebp)
  801cd3:	6a 11                	push   $0x11
  801cd5:	e8 7a fe ff ff       	call   801b54 <syscall>
  801cda:	83 c4 18             	add    $0x18,%esp
	return ;
  801cdd:	90                   	nop
}
  801cde:	c9                   	leave  
  801cdf:	c3                   	ret    

00801ce0 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801ce0:	55                   	push   %ebp
  801ce1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801ce3:	6a 00                	push   $0x0
  801ce5:	6a 00                	push   $0x0
  801ce7:	6a 00                	push   $0x0
  801ce9:	6a 00                	push   $0x0
  801ceb:	6a 00                	push   $0x0
  801ced:	6a 0c                	push   $0xc
  801cef:	e8 60 fe ff ff       	call   801b54 <syscall>
  801cf4:	83 c4 18             	add    $0x18,%esp
}
  801cf7:	c9                   	leave  
  801cf8:	c3                   	ret    

00801cf9 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801cf9:	55                   	push   %ebp
  801cfa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801cfc:	6a 00                	push   $0x0
  801cfe:	6a 00                	push   $0x0
  801d00:	6a 00                	push   $0x0
  801d02:	6a 00                	push   $0x0
  801d04:	ff 75 08             	pushl  0x8(%ebp)
  801d07:	6a 0d                	push   $0xd
  801d09:	e8 46 fe ff ff       	call   801b54 <syscall>
  801d0e:	83 c4 18             	add    $0x18,%esp
}
  801d11:	c9                   	leave  
  801d12:	c3                   	ret    

00801d13 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801d13:	55                   	push   %ebp
  801d14:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801d16:	6a 00                	push   $0x0
  801d18:	6a 00                	push   $0x0
  801d1a:	6a 00                	push   $0x0
  801d1c:	6a 00                	push   $0x0
  801d1e:	6a 00                	push   $0x0
  801d20:	6a 0e                	push   $0xe
  801d22:	e8 2d fe ff ff       	call   801b54 <syscall>
  801d27:	83 c4 18             	add    $0x18,%esp
}
  801d2a:	90                   	nop
  801d2b:	c9                   	leave  
  801d2c:	c3                   	ret    

00801d2d <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801d2d:	55                   	push   %ebp
  801d2e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801d30:	6a 00                	push   $0x0
  801d32:	6a 00                	push   $0x0
  801d34:	6a 00                	push   $0x0
  801d36:	6a 00                	push   $0x0
  801d38:	6a 00                	push   $0x0
  801d3a:	6a 13                	push   $0x13
  801d3c:	e8 13 fe ff ff       	call   801b54 <syscall>
  801d41:	83 c4 18             	add    $0x18,%esp
}
  801d44:	90                   	nop
  801d45:	c9                   	leave  
  801d46:	c3                   	ret    

00801d47 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801d47:	55                   	push   %ebp
  801d48:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801d4a:	6a 00                	push   $0x0
  801d4c:	6a 00                	push   $0x0
  801d4e:	6a 00                	push   $0x0
  801d50:	6a 00                	push   $0x0
  801d52:	6a 00                	push   $0x0
  801d54:	6a 14                	push   $0x14
  801d56:	e8 f9 fd ff ff       	call   801b54 <syscall>
  801d5b:	83 c4 18             	add    $0x18,%esp
}
  801d5e:	90                   	nop
  801d5f:	c9                   	leave  
  801d60:	c3                   	ret    

00801d61 <sys_cputc>:


void
sys_cputc(const char c)
{
  801d61:	55                   	push   %ebp
  801d62:	89 e5                	mov    %esp,%ebp
  801d64:	83 ec 04             	sub    $0x4,%esp
  801d67:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801d6d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d71:	6a 00                	push   $0x0
  801d73:	6a 00                	push   $0x0
  801d75:	6a 00                	push   $0x0
  801d77:	6a 00                	push   $0x0
  801d79:	50                   	push   %eax
  801d7a:	6a 15                	push   $0x15
  801d7c:	e8 d3 fd ff ff       	call   801b54 <syscall>
  801d81:	83 c4 18             	add    $0x18,%esp
}
  801d84:	90                   	nop
  801d85:	c9                   	leave  
  801d86:	c3                   	ret    

00801d87 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801d87:	55                   	push   %ebp
  801d88:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801d8a:	6a 00                	push   $0x0
  801d8c:	6a 00                	push   $0x0
  801d8e:	6a 00                	push   $0x0
  801d90:	6a 00                	push   $0x0
  801d92:	6a 00                	push   $0x0
  801d94:	6a 16                	push   $0x16
  801d96:	e8 b9 fd ff ff       	call   801b54 <syscall>
  801d9b:	83 c4 18             	add    $0x18,%esp
}
  801d9e:	90                   	nop
  801d9f:	c9                   	leave  
  801da0:	c3                   	ret    

00801da1 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801da1:	55                   	push   %ebp
  801da2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801da4:	8b 45 08             	mov    0x8(%ebp),%eax
  801da7:	6a 00                	push   $0x0
  801da9:	6a 00                	push   $0x0
  801dab:	6a 00                	push   $0x0
  801dad:	ff 75 0c             	pushl  0xc(%ebp)
  801db0:	50                   	push   %eax
  801db1:	6a 17                	push   $0x17
  801db3:	e8 9c fd ff ff       	call   801b54 <syscall>
  801db8:	83 c4 18             	add    $0x18,%esp
}
  801dbb:	c9                   	leave  
  801dbc:	c3                   	ret    

00801dbd <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801dbd:	55                   	push   %ebp
  801dbe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801dc0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc6:	6a 00                	push   $0x0
  801dc8:	6a 00                	push   $0x0
  801dca:	6a 00                	push   $0x0
  801dcc:	52                   	push   %edx
  801dcd:	50                   	push   %eax
  801dce:	6a 1a                	push   $0x1a
  801dd0:	e8 7f fd ff ff       	call   801b54 <syscall>
  801dd5:	83 c4 18             	add    $0x18,%esp
}
  801dd8:	c9                   	leave  
  801dd9:	c3                   	ret    

00801dda <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801dda:	55                   	push   %ebp
  801ddb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ddd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801de0:	8b 45 08             	mov    0x8(%ebp),%eax
  801de3:	6a 00                	push   $0x0
  801de5:	6a 00                	push   $0x0
  801de7:	6a 00                	push   $0x0
  801de9:	52                   	push   %edx
  801dea:	50                   	push   %eax
  801deb:	6a 18                	push   $0x18
  801ded:	e8 62 fd ff ff       	call   801b54 <syscall>
  801df2:	83 c4 18             	add    $0x18,%esp
}
  801df5:	90                   	nop
  801df6:	c9                   	leave  
  801df7:	c3                   	ret    

00801df8 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801df8:	55                   	push   %ebp
  801df9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801dfb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  801e01:	6a 00                	push   $0x0
  801e03:	6a 00                	push   $0x0
  801e05:	6a 00                	push   $0x0
  801e07:	52                   	push   %edx
  801e08:	50                   	push   %eax
  801e09:	6a 19                	push   $0x19
  801e0b:	e8 44 fd ff ff       	call   801b54 <syscall>
  801e10:	83 c4 18             	add    $0x18,%esp
}
  801e13:	90                   	nop
  801e14:	c9                   	leave  
  801e15:	c3                   	ret    

00801e16 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801e16:	55                   	push   %ebp
  801e17:	89 e5                	mov    %esp,%ebp
  801e19:	83 ec 04             	sub    $0x4,%esp
  801e1c:	8b 45 10             	mov    0x10(%ebp),%eax
  801e1f:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801e22:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801e25:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801e29:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2c:	6a 00                	push   $0x0
  801e2e:	51                   	push   %ecx
  801e2f:	52                   	push   %edx
  801e30:	ff 75 0c             	pushl  0xc(%ebp)
  801e33:	50                   	push   %eax
  801e34:	6a 1b                	push   $0x1b
  801e36:	e8 19 fd ff ff       	call   801b54 <syscall>
  801e3b:	83 c4 18             	add    $0x18,%esp
}
  801e3e:	c9                   	leave  
  801e3f:	c3                   	ret    

00801e40 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801e40:	55                   	push   %ebp
  801e41:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801e43:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e46:	8b 45 08             	mov    0x8(%ebp),%eax
  801e49:	6a 00                	push   $0x0
  801e4b:	6a 00                	push   $0x0
  801e4d:	6a 00                	push   $0x0
  801e4f:	52                   	push   %edx
  801e50:	50                   	push   %eax
  801e51:	6a 1c                	push   $0x1c
  801e53:	e8 fc fc ff ff       	call   801b54 <syscall>
  801e58:	83 c4 18             	add    $0x18,%esp
}
  801e5b:	c9                   	leave  
  801e5c:	c3                   	ret    

00801e5d <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801e5d:	55                   	push   %ebp
  801e5e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801e60:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e63:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e66:	8b 45 08             	mov    0x8(%ebp),%eax
  801e69:	6a 00                	push   $0x0
  801e6b:	6a 00                	push   $0x0
  801e6d:	51                   	push   %ecx
  801e6e:	52                   	push   %edx
  801e6f:	50                   	push   %eax
  801e70:	6a 1d                	push   $0x1d
  801e72:	e8 dd fc ff ff       	call   801b54 <syscall>
  801e77:	83 c4 18             	add    $0x18,%esp
}
  801e7a:	c9                   	leave  
  801e7b:	c3                   	ret    

00801e7c <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801e7c:	55                   	push   %ebp
  801e7d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801e7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e82:	8b 45 08             	mov    0x8(%ebp),%eax
  801e85:	6a 00                	push   $0x0
  801e87:	6a 00                	push   $0x0
  801e89:	6a 00                	push   $0x0
  801e8b:	52                   	push   %edx
  801e8c:	50                   	push   %eax
  801e8d:	6a 1e                	push   $0x1e
  801e8f:	e8 c0 fc ff ff       	call   801b54 <syscall>
  801e94:	83 c4 18             	add    $0x18,%esp
}
  801e97:	c9                   	leave  
  801e98:	c3                   	ret    

00801e99 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801e99:	55                   	push   %ebp
  801e9a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801e9c:	6a 00                	push   $0x0
  801e9e:	6a 00                	push   $0x0
  801ea0:	6a 00                	push   $0x0
  801ea2:	6a 00                	push   $0x0
  801ea4:	6a 00                	push   $0x0
  801ea6:	6a 1f                	push   $0x1f
  801ea8:	e8 a7 fc ff ff       	call   801b54 <syscall>
  801ead:	83 c4 18             	add    $0x18,%esp
}
  801eb0:	c9                   	leave  
  801eb1:	c3                   	ret    

00801eb2 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801eb2:	55                   	push   %ebp
  801eb3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb8:	6a 00                	push   $0x0
  801eba:	ff 75 14             	pushl  0x14(%ebp)
  801ebd:	ff 75 10             	pushl  0x10(%ebp)
  801ec0:	ff 75 0c             	pushl  0xc(%ebp)
  801ec3:	50                   	push   %eax
  801ec4:	6a 20                	push   $0x20
  801ec6:	e8 89 fc ff ff       	call   801b54 <syscall>
  801ecb:	83 c4 18             	add    $0x18,%esp
}
  801ece:	c9                   	leave  
  801ecf:	c3                   	ret    

00801ed0 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801ed0:	55                   	push   %ebp
  801ed1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801ed3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed6:	6a 00                	push   $0x0
  801ed8:	6a 00                	push   $0x0
  801eda:	6a 00                	push   $0x0
  801edc:	6a 00                	push   $0x0
  801ede:	50                   	push   %eax
  801edf:	6a 21                	push   $0x21
  801ee1:	e8 6e fc ff ff       	call   801b54 <syscall>
  801ee6:	83 c4 18             	add    $0x18,%esp
}
  801ee9:	90                   	nop
  801eea:	c9                   	leave  
  801eeb:	c3                   	ret    

00801eec <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801eec:	55                   	push   %ebp
  801eed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801eef:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef2:	6a 00                	push   $0x0
  801ef4:	6a 00                	push   $0x0
  801ef6:	6a 00                	push   $0x0
  801ef8:	6a 00                	push   $0x0
  801efa:	50                   	push   %eax
  801efb:	6a 22                	push   $0x22
  801efd:	e8 52 fc ff ff       	call   801b54 <syscall>
  801f02:	83 c4 18             	add    $0x18,%esp
}
  801f05:	c9                   	leave  
  801f06:	c3                   	ret    

00801f07 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801f07:	55                   	push   %ebp
  801f08:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801f0a:	6a 00                	push   $0x0
  801f0c:	6a 00                	push   $0x0
  801f0e:	6a 00                	push   $0x0
  801f10:	6a 00                	push   $0x0
  801f12:	6a 00                	push   $0x0
  801f14:	6a 02                	push   $0x2
  801f16:	e8 39 fc ff ff       	call   801b54 <syscall>
  801f1b:	83 c4 18             	add    $0x18,%esp
}
  801f1e:	c9                   	leave  
  801f1f:	c3                   	ret    

00801f20 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801f20:	55                   	push   %ebp
  801f21:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801f23:	6a 00                	push   $0x0
  801f25:	6a 00                	push   $0x0
  801f27:	6a 00                	push   $0x0
  801f29:	6a 00                	push   $0x0
  801f2b:	6a 00                	push   $0x0
  801f2d:	6a 03                	push   $0x3
  801f2f:	e8 20 fc ff ff       	call   801b54 <syscall>
  801f34:	83 c4 18             	add    $0x18,%esp
}
  801f37:	c9                   	leave  
  801f38:	c3                   	ret    

00801f39 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801f39:	55                   	push   %ebp
  801f3a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801f3c:	6a 00                	push   $0x0
  801f3e:	6a 00                	push   $0x0
  801f40:	6a 00                	push   $0x0
  801f42:	6a 00                	push   $0x0
  801f44:	6a 00                	push   $0x0
  801f46:	6a 04                	push   $0x4
  801f48:	e8 07 fc ff ff       	call   801b54 <syscall>
  801f4d:	83 c4 18             	add    $0x18,%esp
}
  801f50:	c9                   	leave  
  801f51:	c3                   	ret    

00801f52 <sys_exit_env>:


void sys_exit_env(void)
{
  801f52:	55                   	push   %ebp
  801f53:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801f55:	6a 00                	push   $0x0
  801f57:	6a 00                	push   $0x0
  801f59:	6a 00                	push   $0x0
  801f5b:	6a 00                	push   $0x0
  801f5d:	6a 00                	push   $0x0
  801f5f:	6a 23                	push   $0x23
  801f61:	e8 ee fb ff ff       	call   801b54 <syscall>
  801f66:	83 c4 18             	add    $0x18,%esp
}
  801f69:	90                   	nop
  801f6a:	c9                   	leave  
  801f6b:	c3                   	ret    

00801f6c <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801f6c:	55                   	push   %ebp
  801f6d:	89 e5                	mov    %esp,%ebp
  801f6f:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801f72:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f75:	8d 50 04             	lea    0x4(%eax),%edx
  801f78:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f7b:	6a 00                	push   $0x0
  801f7d:	6a 00                	push   $0x0
  801f7f:	6a 00                	push   $0x0
  801f81:	52                   	push   %edx
  801f82:	50                   	push   %eax
  801f83:	6a 24                	push   $0x24
  801f85:	e8 ca fb ff ff       	call   801b54 <syscall>
  801f8a:	83 c4 18             	add    $0x18,%esp
	return result;
  801f8d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f90:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f93:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801f96:	89 01                	mov    %eax,(%ecx)
  801f98:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9e:	c9                   	leave  
  801f9f:	c2 04 00             	ret    $0x4

00801fa2 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801fa2:	55                   	push   %ebp
  801fa3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801fa5:	6a 00                	push   $0x0
  801fa7:	6a 00                	push   $0x0
  801fa9:	ff 75 10             	pushl  0x10(%ebp)
  801fac:	ff 75 0c             	pushl  0xc(%ebp)
  801faf:	ff 75 08             	pushl  0x8(%ebp)
  801fb2:	6a 12                	push   $0x12
  801fb4:	e8 9b fb ff ff       	call   801b54 <syscall>
  801fb9:	83 c4 18             	add    $0x18,%esp
	return ;
  801fbc:	90                   	nop
}
  801fbd:	c9                   	leave  
  801fbe:	c3                   	ret    

00801fbf <sys_rcr2>:
uint32 sys_rcr2()
{
  801fbf:	55                   	push   %ebp
  801fc0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801fc2:	6a 00                	push   $0x0
  801fc4:	6a 00                	push   $0x0
  801fc6:	6a 00                	push   $0x0
  801fc8:	6a 00                	push   $0x0
  801fca:	6a 00                	push   $0x0
  801fcc:	6a 25                	push   $0x25
  801fce:	e8 81 fb ff ff       	call   801b54 <syscall>
  801fd3:	83 c4 18             	add    $0x18,%esp
}
  801fd6:	c9                   	leave  
  801fd7:	c3                   	ret    

00801fd8 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801fd8:	55                   	push   %ebp
  801fd9:	89 e5                	mov    %esp,%ebp
  801fdb:	83 ec 04             	sub    $0x4,%esp
  801fde:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801fe4:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801fe8:	6a 00                	push   $0x0
  801fea:	6a 00                	push   $0x0
  801fec:	6a 00                	push   $0x0
  801fee:	6a 00                	push   $0x0
  801ff0:	50                   	push   %eax
  801ff1:	6a 26                	push   $0x26
  801ff3:	e8 5c fb ff ff       	call   801b54 <syscall>
  801ff8:	83 c4 18             	add    $0x18,%esp
	return ;
  801ffb:	90                   	nop
}
  801ffc:	c9                   	leave  
  801ffd:	c3                   	ret    

00801ffe <rsttst>:
void rsttst()
{
  801ffe:	55                   	push   %ebp
  801fff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802001:	6a 00                	push   $0x0
  802003:	6a 00                	push   $0x0
  802005:	6a 00                	push   $0x0
  802007:	6a 00                	push   $0x0
  802009:	6a 00                	push   $0x0
  80200b:	6a 28                	push   $0x28
  80200d:	e8 42 fb ff ff       	call   801b54 <syscall>
  802012:	83 c4 18             	add    $0x18,%esp
	return ;
  802015:	90                   	nop
}
  802016:	c9                   	leave  
  802017:	c3                   	ret    

00802018 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802018:	55                   	push   %ebp
  802019:	89 e5                	mov    %esp,%ebp
  80201b:	83 ec 04             	sub    $0x4,%esp
  80201e:	8b 45 14             	mov    0x14(%ebp),%eax
  802021:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802024:	8b 55 18             	mov    0x18(%ebp),%edx
  802027:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80202b:	52                   	push   %edx
  80202c:	50                   	push   %eax
  80202d:	ff 75 10             	pushl  0x10(%ebp)
  802030:	ff 75 0c             	pushl  0xc(%ebp)
  802033:	ff 75 08             	pushl  0x8(%ebp)
  802036:	6a 27                	push   $0x27
  802038:	e8 17 fb ff ff       	call   801b54 <syscall>
  80203d:	83 c4 18             	add    $0x18,%esp
	return ;
  802040:	90                   	nop
}
  802041:	c9                   	leave  
  802042:	c3                   	ret    

00802043 <chktst>:
void chktst(uint32 n)
{
  802043:	55                   	push   %ebp
  802044:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802046:	6a 00                	push   $0x0
  802048:	6a 00                	push   $0x0
  80204a:	6a 00                	push   $0x0
  80204c:	6a 00                	push   $0x0
  80204e:	ff 75 08             	pushl  0x8(%ebp)
  802051:	6a 29                	push   $0x29
  802053:	e8 fc fa ff ff       	call   801b54 <syscall>
  802058:	83 c4 18             	add    $0x18,%esp
	return ;
  80205b:	90                   	nop
}
  80205c:	c9                   	leave  
  80205d:	c3                   	ret    

0080205e <inctst>:

void inctst()
{
  80205e:	55                   	push   %ebp
  80205f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802061:	6a 00                	push   $0x0
  802063:	6a 00                	push   $0x0
  802065:	6a 00                	push   $0x0
  802067:	6a 00                	push   $0x0
  802069:	6a 00                	push   $0x0
  80206b:	6a 2a                	push   $0x2a
  80206d:	e8 e2 fa ff ff       	call   801b54 <syscall>
  802072:	83 c4 18             	add    $0x18,%esp
	return ;
  802075:	90                   	nop
}
  802076:	c9                   	leave  
  802077:	c3                   	ret    

00802078 <gettst>:
uint32 gettst()
{
  802078:	55                   	push   %ebp
  802079:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80207b:	6a 00                	push   $0x0
  80207d:	6a 00                	push   $0x0
  80207f:	6a 00                	push   $0x0
  802081:	6a 00                	push   $0x0
  802083:	6a 00                	push   $0x0
  802085:	6a 2b                	push   $0x2b
  802087:	e8 c8 fa ff ff       	call   801b54 <syscall>
  80208c:	83 c4 18             	add    $0x18,%esp
}
  80208f:	c9                   	leave  
  802090:	c3                   	ret    

00802091 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802091:	55                   	push   %ebp
  802092:	89 e5                	mov    %esp,%ebp
  802094:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802097:	6a 00                	push   $0x0
  802099:	6a 00                	push   $0x0
  80209b:	6a 00                	push   $0x0
  80209d:	6a 00                	push   $0x0
  80209f:	6a 00                	push   $0x0
  8020a1:	6a 2c                	push   $0x2c
  8020a3:	e8 ac fa ff ff       	call   801b54 <syscall>
  8020a8:	83 c4 18             	add    $0x18,%esp
  8020ab:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8020ae:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8020b2:	75 07                	jne    8020bb <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8020b4:	b8 01 00 00 00       	mov    $0x1,%eax
  8020b9:	eb 05                	jmp    8020c0 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8020bb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020c0:	c9                   	leave  
  8020c1:	c3                   	ret    

008020c2 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8020c2:	55                   	push   %ebp
  8020c3:	89 e5                	mov    %esp,%ebp
  8020c5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020c8:	6a 00                	push   $0x0
  8020ca:	6a 00                	push   $0x0
  8020cc:	6a 00                	push   $0x0
  8020ce:	6a 00                	push   $0x0
  8020d0:	6a 00                	push   $0x0
  8020d2:	6a 2c                	push   $0x2c
  8020d4:	e8 7b fa ff ff       	call   801b54 <syscall>
  8020d9:	83 c4 18             	add    $0x18,%esp
  8020dc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8020df:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8020e3:	75 07                	jne    8020ec <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8020e5:	b8 01 00 00 00       	mov    $0x1,%eax
  8020ea:	eb 05                	jmp    8020f1 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8020ec:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020f1:	c9                   	leave  
  8020f2:	c3                   	ret    

008020f3 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8020f3:	55                   	push   %ebp
  8020f4:	89 e5                	mov    %esp,%ebp
  8020f6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020f9:	6a 00                	push   $0x0
  8020fb:	6a 00                	push   $0x0
  8020fd:	6a 00                	push   $0x0
  8020ff:	6a 00                	push   $0x0
  802101:	6a 00                	push   $0x0
  802103:	6a 2c                	push   $0x2c
  802105:	e8 4a fa ff ff       	call   801b54 <syscall>
  80210a:	83 c4 18             	add    $0x18,%esp
  80210d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802110:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802114:	75 07                	jne    80211d <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802116:	b8 01 00 00 00       	mov    $0x1,%eax
  80211b:	eb 05                	jmp    802122 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80211d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802122:	c9                   	leave  
  802123:	c3                   	ret    

00802124 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802124:	55                   	push   %ebp
  802125:	89 e5                	mov    %esp,%ebp
  802127:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80212a:	6a 00                	push   $0x0
  80212c:	6a 00                	push   $0x0
  80212e:	6a 00                	push   $0x0
  802130:	6a 00                	push   $0x0
  802132:	6a 00                	push   $0x0
  802134:	6a 2c                	push   $0x2c
  802136:	e8 19 fa ff ff       	call   801b54 <syscall>
  80213b:	83 c4 18             	add    $0x18,%esp
  80213e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802141:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802145:	75 07                	jne    80214e <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802147:	b8 01 00 00 00       	mov    $0x1,%eax
  80214c:	eb 05                	jmp    802153 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80214e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802153:	c9                   	leave  
  802154:	c3                   	ret    

00802155 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802155:	55                   	push   %ebp
  802156:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802158:	6a 00                	push   $0x0
  80215a:	6a 00                	push   $0x0
  80215c:	6a 00                	push   $0x0
  80215e:	6a 00                	push   $0x0
  802160:	ff 75 08             	pushl  0x8(%ebp)
  802163:	6a 2d                	push   $0x2d
  802165:	e8 ea f9 ff ff       	call   801b54 <syscall>
  80216a:	83 c4 18             	add    $0x18,%esp
	return ;
  80216d:	90                   	nop
}
  80216e:	c9                   	leave  
  80216f:	c3                   	ret    

00802170 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802170:	55                   	push   %ebp
  802171:	89 e5                	mov    %esp,%ebp
  802173:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802174:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802177:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80217a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80217d:	8b 45 08             	mov    0x8(%ebp),%eax
  802180:	6a 00                	push   $0x0
  802182:	53                   	push   %ebx
  802183:	51                   	push   %ecx
  802184:	52                   	push   %edx
  802185:	50                   	push   %eax
  802186:	6a 2e                	push   $0x2e
  802188:	e8 c7 f9 ff ff       	call   801b54 <syscall>
  80218d:	83 c4 18             	add    $0x18,%esp
}
  802190:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802193:	c9                   	leave  
  802194:	c3                   	ret    

00802195 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802195:	55                   	push   %ebp
  802196:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802198:	8b 55 0c             	mov    0xc(%ebp),%edx
  80219b:	8b 45 08             	mov    0x8(%ebp),%eax
  80219e:	6a 00                	push   $0x0
  8021a0:	6a 00                	push   $0x0
  8021a2:	6a 00                	push   $0x0
  8021a4:	52                   	push   %edx
  8021a5:	50                   	push   %eax
  8021a6:	6a 2f                	push   $0x2f
  8021a8:	e8 a7 f9 ff ff       	call   801b54 <syscall>
  8021ad:	83 c4 18             	add    $0x18,%esp
}
  8021b0:	c9                   	leave  
  8021b1:	c3                   	ret    
  8021b2:	66 90                	xchg   %ax,%ax

008021b4 <__udivdi3>:
  8021b4:	55                   	push   %ebp
  8021b5:	57                   	push   %edi
  8021b6:	56                   	push   %esi
  8021b7:	53                   	push   %ebx
  8021b8:	83 ec 1c             	sub    $0x1c,%esp
  8021bb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8021bf:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8021c3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8021c7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8021cb:	89 ca                	mov    %ecx,%edx
  8021cd:	89 f8                	mov    %edi,%eax
  8021cf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8021d3:	85 f6                	test   %esi,%esi
  8021d5:	75 2d                	jne    802204 <__udivdi3+0x50>
  8021d7:	39 cf                	cmp    %ecx,%edi
  8021d9:	77 65                	ja     802240 <__udivdi3+0x8c>
  8021db:	89 fd                	mov    %edi,%ebp
  8021dd:	85 ff                	test   %edi,%edi
  8021df:	75 0b                	jne    8021ec <__udivdi3+0x38>
  8021e1:	b8 01 00 00 00       	mov    $0x1,%eax
  8021e6:	31 d2                	xor    %edx,%edx
  8021e8:	f7 f7                	div    %edi
  8021ea:	89 c5                	mov    %eax,%ebp
  8021ec:	31 d2                	xor    %edx,%edx
  8021ee:	89 c8                	mov    %ecx,%eax
  8021f0:	f7 f5                	div    %ebp
  8021f2:	89 c1                	mov    %eax,%ecx
  8021f4:	89 d8                	mov    %ebx,%eax
  8021f6:	f7 f5                	div    %ebp
  8021f8:	89 cf                	mov    %ecx,%edi
  8021fa:	89 fa                	mov    %edi,%edx
  8021fc:	83 c4 1c             	add    $0x1c,%esp
  8021ff:	5b                   	pop    %ebx
  802200:	5e                   	pop    %esi
  802201:	5f                   	pop    %edi
  802202:	5d                   	pop    %ebp
  802203:	c3                   	ret    
  802204:	39 ce                	cmp    %ecx,%esi
  802206:	77 28                	ja     802230 <__udivdi3+0x7c>
  802208:	0f bd fe             	bsr    %esi,%edi
  80220b:	83 f7 1f             	xor    $0x1f,%edi
  80220e:	75 40                	jne    802250 <__udivdi3+0x9c>
  802210:	39 ce                	cmp    %ecx,%esi
  802212:	72 0a                	jb     80221e <__udivdi3+0x6a>
  802214:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802218:	0f 87 9e 00 00 00    	ja     8022bc <__udivdi3+0x108>
  80221e:	b8 01 00 00 00       	mov    $0x1,%eax
  802223:	89 fa                	mov    %edi,%edx
  802225:	83 c4 1c             	add    $0x1c,%esp
  802228:	5b                   	pop    %ebx
  802229:	5e                   	pop    %esi
  80222a:	5f                   	pop    %edi
  80222b:	5d                   	pop    %ebp
  80222c:	c3                   	ret    
  80222d:	8d 76 00             	lea    0x0(%esi),%esi
  802230:	31 ff                	xor    %edi,%edi
  802232:	31 c0                	xor    %eax,%eax
  802234:	89 fa                	mov    %edi,%edx
  802236:	83 c4 1c             	add    $0x1c,%esp
  802239:	5b                   	pop    %ebx
  80223a:	5e                   	pop    %esi
  80223b:	5f                   	pop    %edi
  80223c:	5d                   	pop    %ebp
  80223d:	c3                   	ret    
  80223e:	66 90                	xchg   %ax,%ax
  802240:	89 d8                	mov    %ebx,%eax
  802242:	f7 f7                	div    %edi
  802244:	31 ff                	xor    %edi,%edi
  802246:	89 fa                	mov    %edi,%edx
  802248:	83 c4 1c             	add    $0x1c,%esp
  80224b:	5b                   	pop    %ebx
  80224c:	5e                   	pop    %esi
  80224d:	5f                   	pop    %edi
  80224e:	5d                   	pop    %ebp
  80224f:	c3                   	ret    
  802250:	bd 20 00 00 00       	mov    $0x20,%ebp
  802255:	89 eb                	mov    %ebp,%ebx
  802257:	29 fb                	sub    %edi,%ebx
  802259:	89 f9                	mov    %edi,%ecx
  80225b:	d3 e6                	shl    %cl,%esi
  80225d:	89 c5                	mov    %eax,%ebp
  80225f:	88 d9                	mov    %bl,%cl
  802261:	d3 ed                	shr    %cl,%ebp
  802263:	89 e9                	mov    %ebp,%ecx
  802265:	09 f1                	or     %esi,%ecx
  802267:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80226b:	89 f9                	mov    %edi,%ecx
  80226d:	d3 e0                	shl    %cl,%eax
  80226f:	89 c5                	mov    %eax,%ebp
  802271:	89 d6                	mov    %edx,%esi
  802273:	88 d9                	mov    %bl,%cl
  802275:	d3 ee                	shr    %cl,%esi
  802277:	89 f9                	mov    %edi,%ecx
  802279:	d3 e2                	shl    %cl,%edx
  80227b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80227f:	88 d9                	mov    %bl,%cl
  802281:	d3 e8                	shr    %cl,%eax
  802283:	09 c2                	or     %eax,%edx
  802285:	89 d0                	mov    %edx,%eax
  802287:	89 f2                	mov    %esi,%edx
  802289:	f7 74 24 0c          	divl   0xc(%esp)
  80228d:	89 d6                	mov    %edx,%esi
  80228f:	89 c3                	mov    %eax,%ebx
  802291:	f7 e5                	mul    %ebp
  802293:	39 d6                	cmp    %edx,%esi
  802295:	72 19                	jb     8022b0 <__udivdi3+0xfc>
  802297:	74 0b                	je     8022a4 <__udivdi3+0xf0>
  802299:	89 d8                	mov    %ebx,%eax
  80229b:	31 ff                	xor    %edi,%edi
  80229d:	e9 58 ff ff ff       	jmp    8021fa <__udivdi3+0x46>
  8022a2:	66 90                	xchg   %ax,%ax
  8022a4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8022a8:	89 f9                	mov    %edi,%ecx
  8022aa:	d3 e2                	shl    %cl,%edx
  8022ac:	39 c2                	cmp    %eax,%edx
  8022ae:	73 e9                	jae    802299 <__udivdi3+0xe5>
  8022b0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8022b3:	31 ff                	xor    %edi,%edi
  8022b5:	e9 40 ff ff ff       	jmp    8021fa <__udivdi3+0x46>
  8022ba:	66 90                	xchg   %ax,%ax
  8022bc:	31 c0                	xor    %eax,%eax
  8022be:	e9 37 ff ff ff       	jmp    8021fa <__udivdi3+0x46>
  8022c3:	90                   	nop

008022c4 <__umoddi3>:
  8022c4:	55                   	push   %ebp
  8022c5:	57                   	push   %edi
  8022c6:	56                   	push   %esi
  8022c7:	53                   	push   %ebx
  8022c8:	83 ec 1c             	sub    $0x1c,%esp
  8022cb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8022cf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8022d3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8022d7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8022db:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8022df:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8022e3:	89 f3                	mov    %esi,%ebx
  8022e5:	89 fa                	mov    %edi,%edx
  8022e7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8022eb:	89 34 24             	mov    %esi,(%esp)
  8022ee:	85 c0                	test   %eax,%eax
  8022f0:	75 1a                	jne    80230c <__umoddi3+0x48>
  8022f2:	39 f7                	cmp    %esi,%edi
  8022f4:	0f 86 a2 00 00 00    	jbe    80239c <__umoddi3+0xd8>
  8022fa:	89 c8                	mov    %ecx,%eax
  8022fc:	89 f2                	mov    %esi,%edx
  8022fe:	f7 f7                	div    %edi
  802300:	89 d0                	mov    %edx,%eax
  802302:	31 d2                	xor    %edx,%edx
  802304:	83 c4 1c             	add    $0x1c,%esp
  802307:	5b                   	pop    %ebx
  802308:	5e                   	pop    %esi
  802309:	5f                   	pop    %edi
  80230a:	5d                   	pop    %ebp
  80230b:	c3                   	ret    
  80230c:	39 f0                	cmp    %esi,%eax
  80230e:	0f 87 ac 00 00 00    	ja     8023c0 <__umoddi3+0xfc>
  802314:	0f bd e8             	bsr    %eax,%ebp
  802317:	83 f5 1f             	xor    $0x1f,%ebp
  80231a:	0f 84 ac 00 00 00    	je     8023cc <__umoddi3+0x108>
  802320:	bf 20 00 00 00       	mov    $0x20,%edi
  802325:	29 ef                	sub    %ebp,%edi
  802327:	89 fe                	mov    %edi,%esi
  802329:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80232d:	89 e9                	mov    %ebp,%ecx
  80232f:	d3 e0                	shl    %cl,%eax
  802331:	89 d7                	mov    %edx,%edi
  802333:	89 f1                	mov    %esi,%ecx
  802335:	d3 ef                	shr    %cl,%edi
  802337:	09 c7                	or     %eax,%edi
  802339:	89 e9                	mov    %ebp,%ecx
  80233b:	d3 e2                	shl    %cl,%edx
  80233d:	89 14 24             	mov    %edx,(%esp)
  802340:	89 d8                	mov    %ebx,%eax
  802342:	d3 e0                	shl    %cl,%eax
  802344:	89 c2                	mov    %eax,%edx
  802346:	8b 44 24 08          	mov    0x8(%esp),%eax
  80234a:	d3 e0                	shl    %cl,%eax
  80234c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802350:	8b 44 24 08          	mov    0x8(%esp),%eax
  802354:	89 f1                	mov    %esi,%ecx
  802356:	d3 e8                	shr    %cl,%eax
  802358:	09 d0                	or     %edx,%eax
  80235a:	d3 eb                	shr    %cl,%ebx
  80235c:	89 da                	mov    %ebx,%edx
  80235e:	f7 f7                	div    %edi
  802360:	89 d3                	mov    %edx,%ebx
  802362:	f7 24 24             	mull   (%esp)
  802365:	89 c6                	mov    %eax,%esi
  802367:	89 d1                	mov    %edx,%ecx
  802369:	39 d3                	cmp    %edx,%ebx
  80236b:	0f 82 87 00 00 00    	jb     8023f8 <__umoddi3+0x134>
  802371:	0f 84 91 00 00 00    	je     802408 <__umoddi3+0x144>
  802377:	8b 54 24 04          	mov    0x4(%esp),%edx
  80237b:	29 f2                	sub    %esi,%edx
  80237d:	19 cb                	sbb    %ecx,%ebx
  80237f:	89 d8                	mov    %ebx,%eax
  802381:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802385:	d3 e0                	shl    %cl,%eax
  802387:	89 e9                	mov    %ebp,%ecx
  802389:	d3 ea                	shr    %cl,%edx
  80238b:	09 d0                	or     %edx,%eax
  80238d:	89 e9                	mov    %ebp,%ecx
  80238f:	d3 eb                	shr    %cl,%ebx
  802391:	89 da                	mov    %ebx,%edx
  802393:	83 c4 1c             	add    $0x1c,%esp
  802396:	5b                   	pop    %ebx
  802397:	5e                   	pop    %esi
  802398:	5f                   	pop    %edi
  802399:	5d                   	pop    %ebp
  80239a:	c3                   	ret    
  80239b:	90                   	nop
  80239c:	89 fd                	mov    %edi,%ebp
  80239e:	85 ff                	test   %edi,%edi
  8023a0:	75 0b                	jne    8023ad <__umoddi3+0xe9>
  8023a2:	b8 01 00 00 00       	mov    $0x1,%eax
  8023a7:	31 d2                	xor    %edx,%edx
  8023a9:	f7 f7                	div    %edi
  8023ab:	89 c5                	mov    %eax,%ebp
  8023ad:	89 f0                	mov    %esi,%eax
  8023af:	31 d2                	xor    %edx,%edx
  8023b1:	f7 f5                	div    %ebp
  8023b3:	89 c8                	mov    %ecx,%eax
  8023b5:	f7 f5                	div    %ebp
  8023b7:	89 d0                	mov    %edx,%eax
  8023b9:	e9 44 ff ff ff       	jmp    802302 <__umoddi3+0x3e>
  8023be:	66 90                	xchg   %ax,%ax
  8023c0:	89 c8                	mov    %ecx,%eax
  8023c2:	89 f2                	mov    %esi,%edx
  8023c4:	83 c4 1c             	add    $0x1c,%esp
  8023c7:	5b                   	pop    %ebx
  8023c8:	5e                   	pop    %esi
  8023c9:	5f                   	pop    %edi
  8023ca:	5d                   	pop    %ebp
  8023cb:	c3                   	ret    
  8023cc:	3b 04 24             	cmp    (%esp),%eax
  8023cf:	72 06                	jb     8023d7 <__umoddi3+0x113>
  8023d1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8023d5:	77 0f                	ja     8023e6 <__umoddi3+0x122>
  8023d7:	89 f2                	mov    %esi,%edx
  8023d9:	29 f9                	sub    %edi,%ecx
  8023db:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8023df:	89 14 24             	mov    %edx,(%esp)
  8023e2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8023e6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8023ea:	8b 14 24             	mov    (%esp),%edx
  8023ed:	83 c4 1c             	add    $0x1c,%esp
  8023f0:	5b                   	pop    %ebx
  8023f1:	5e                   	pop    %esi
  8023f2:	5f                   	pop    %edi
  8023f3:	5d                   	pop    %ebp
  8023f4:	c3                   	ret    
  8023f5:	8d 76 00             	lea    0x0(%esi),%esi
  8023f8:	2b 04 24             	sub    (%esp),%eax
  8023fb:	19 fa                	sbb    %edi,%edx
  8023fd:	89 d1                	mov    %edx,%ecx
  8023ff:	89 c6                	mov    %eax,%esi
  802401:	e9 71 ff ff ff       	jmp    802377 <__umoddi3+0xb3>
  802406:	66 90                	xchg   %ax,%ax
  802408:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80240c:	72 ea                	jb     8023f8 <__umoddi3+0x134>
  80240e:	89 d9                	mov    %ebx,%ecx
  802410:	e9 62 ff ff ff       	jmp    802377 <__umoddi3+0xb3>
