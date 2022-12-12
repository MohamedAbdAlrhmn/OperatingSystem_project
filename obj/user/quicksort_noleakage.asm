
obj/user/quicksort_noleakage:     file format elf32-i386


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
  800031:	e8 0e 06 00 00       	call   800644 <libmain>
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
  800041:	e8 f1 1e 00 00       	call   801f37 <sys_disable_interrupt>
		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 80 3c 80 00       	push   $0x803c80
  80004e:	e8 e1 09 00 00       	call   800a34 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 82 3c 80 00       	push   $0x803c82
  80005e:	e8 d1 09 00 00       	call   800a34 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!   QUICK SORT    !!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 9b 3c 80 00       	push   $0x803c9b
  80006e:	e8 c1 09 00 00       	call   800a34 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 82 3c 80 00       	push   $0x803c82
  80007e:	e8 b1 09 00 00       	call   800a34 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 80 3c 80 00       	push   $0x803c80
  80008e:	e8 a1 09 00 00       	call   800a34 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp

		readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 b4 3c 80 00       	push   $0x803cb4
  8000a5:	e8 0c 10 00 00       	call   8010b6 <readline>
  8000aa:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = strtol(Line, NULL, 10) ;
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	6a 0a                	push   $0xa
  8000b2:	6a 00                	push   $0x0
  8000b4:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  8000ba:	50                   	push   %eax
  8000bb:	e8 5c 15 00 00       	call   80161c <strtol>
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  8000c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000c9:	c1 e0 02             	shl    $0x2,%eax
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	50                   	push   %eax
  8000d0:	e8 ed 1a 00 00       	call   801bc2 <malloc>
  8000d5:	83 c4 10             	add    $0x10,%esp
  8000d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		cprintf("Chose the initialization method:\n") ;
  8000db:	83 ec 0c             	sub    $0xc,%esp
  8000de:	68 d4 3c 80 00       	push   $0x803cd4
  8000e3:	e8 4c 09 00 00       	call   800a34 <cprintf>
  8000e8:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000eb:	83 ec 0c             	sub    $0xc,%esp
  8000ee:	68 f6 3c 80 00       	push   $0x803cf6
  8000f3:	e8 3c 09 00 00       	call   800a34 <cprintf>
  8000f8:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000fb:	83 ec 0c             	sub    $0xc,%esp
  8000fe:	68 04 3d 80 00       	push   $0x803d04
  800103:	e8 2c 09 00 00       	call   800a34 <cprintf>
  800108:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 13 3d 80 00       	push   $0x803d13
  800113:	e8 1c 09 00 00       	call   800a34 <cprintf>
  800118:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	68 23 3d 80 00       	push   $0x803d23
  800123:	e8 0c 09 00 00       	call   800a34 <cprintf>
  800128:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  80012b:	e8 bc 04 00 00       	call   8005ec <getchar>
  800130:	88 45 ef             	mov    %al,-0x11(%ebp)
			cputchar(Chose);
  800133:	0f be 45 ef          	movsbl -0x11(%ebp),%eax
  800137:	83 ec 0c             	sub    $0xc,%esp
  80013a:	50                   	push   %eax
  80013b:	e8 64 04 00 00       	call   8005a4 <cputchar>
  800140:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800143:	83 ec 0c             	sub    $0xc,%esp
  800146:	6a 0a                	push   $0xa
  800148:	e8 57 04 00 00       	call   8005a4 <cputchar>
  80014d:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800150:	80 7d ef 61          	cmpb   $0x61,-0x11(%ebp)
  800154:	74 0c                	je     800162 <_main+0x12a>
  800156:	80 7d ef 62          	cmpb   $0x62,-0x11(%ebp)
  80015a:	74 06                	je     800162 <_main+0x12a>
  80015c:	80 7d ef 63          	cmpb   $0x63,-0x11(%ebp)
  800160:	75 b9                	jne    80011b <_main+0xe3>

		//2012: lock the interrupt
		sys_enable_interrupt();
  800162:	e8 ea 1d 00 00       	call   801f51 <sys_enable_interrupt>

		int  i ;
		switch (Chose)
  800167:	0f be 45 ef          	movsbl -0x11(%ebp),%eax
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
  80017d:	ff 75 f4             	pushl  -0xc(%ebp)
  800180:	ff 75 f0             	pushl  -0x10(%ebp)
  800183:	e8 e4 02 00 00       	call   80046c <InitializeAscending>
  800188:	83 c4 10             	add    $0x10,%esp
			break ;
  80018b:	eb 37                	jmp    8001c4 <_main+0x18c>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  80018d:	83 ec 08             	sub    $0x8,%esp
  800190:	ff 75 f4             	pushl  -0xc(%ebp)
  800193:	ff 75 f0             	pushl  -0x10(%ebp)
  800196:	e8 02 03 00 00       	call   80049d <InitializeDescending>
  80019b:	83 c4 10             	add    $0x10,%esp
			break ;
  80019e:	eb 24                	jmp    8001c4 <_main+0x18c>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001a0:	83 ec 08             	sub    $0x8,%esp
  8001a3:	ff 75 f4             	pushl  -0xc(%ebp)
  8001a6:	ff 75 f0             	pushl  -0x10(%ebp)
  8001a9:	e8 24 03 00 00       	call   8004d2 <InitializeSemiRandom>
  8001ae:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b1:	eb 11                	jmp    8001c4 <_main+0x18c>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001b3:	83 ec 08             	sub    $0x8,%esp
  8001b6:	ff 75 f4             	pushl  -0xc(%ebp)
  8001b9:	ff 75 f0             	pushl  -0x10(%ebp)
  8001bc:	e8 11 03 00 00       	call   8004d2 <InitializeSemiRandom>
  8001c1:	83 c4 10             	add    $0x10,%esp
		}

		QuickSort(Elements, NumOfElements);
  8001c4:	83 ec 08             	sub    $0x8,%esp
  8001c7:	ff 75 f4             	pushl  -0xc(%ebp)
  8001ca:	ff 75 f0             	pushl  -0x10(%ebp)
  8001cd:	e8 df 00 00 00       	call   8002b1 <QuickSort>
  8001d2:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  8001d5:	e8 5d 1d 00 00       	call   801f37 <sys_disable_interrupt>
			cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001da:	83 ec 0c             	sub    $0xc,%esp
  8001dd:	68 2c 3d 80 00       	push   $0x803d2c
  8001e2:	e8 4d 08 00 00       	call   800a34 <cprintf>
  8001e7:	83 c4 10             	add    $0x10,%esp
		//		PrintElements(Elements, NumOfElements);
		sys_enable_interrupt();
  8001ea:	e8 62 1d 00 00       	call   801f51 <sys_enable_interrupt>

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001ef:	83 ec 08             	sub    $0x8,%esp
  8001f2:	ff 75 f4             	pushl  -0xc(%ebp)
  8001f5:	ff 75 f0             	pushl  -0x10(%ebp)
  8001f8:	e8 c5 01 00 00       	call   8003c2 <CheckSorted>
  8001fd:	83 c4 10             	add    $0x10,%esp
  800200:	89 45 e8             	mov    %eax,-0x18(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  800203:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800207:	75 14                	jne    80021d <_main+0x1e5>
  800209:	83 ec 04             	sub    $0x4,%esp
  80020c:	68 60 3d 80 00       	push   $0x803d60
  800211:	6a 49                	push   $0x49
  800213:	68 82 3d 80 00       	push   $0x803d82
  800218:	e8 63 05 00 00       	call   800780 <_panic>
		else
		{
			sys_disable_interrupt();
  80021d:	e8 15 1d 00 00       	call   801f37 <sys_disable_interrupt>
			cprintf("===============================================\n") ;
  800222:	83 ec 0c             	sub    $0xc,%esp
  800225:	68 a0 3d 80 00       	push   $0x803da0
  80022a:	e8 05 08 00 00       	call   800a34 <cprintf>
  80022f:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  800232:	83 ec 0c             	sub    $0xc,%esp
  800235:	68 d4 3d 80 00       	push   $0x803dd4
  80023a:	e8 f5 07 00 00       	call   800a34 <cprintf>
  80023f:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  800242:	83 ec 0c             	sub    $0xc,%esp
  800245:	68 08 3e 80 00       	push   $0x803e08
  80024a:	e8 e5 07 00 00       	call   800a34 <cprintf>
  80024f:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800252:	e8 fa 1c 00 00       	call   801f51 <sys_enable_interrupt>

		}

		free(Elements) ;
  800257:	83 ec 0c             	sub    $0xc,%esp
  80025a:	ff 75 f0             	pushl  -0x10(%ebp)
  80025d:	e8 8e 19 00 00       	call   801bf0 <free>
  800262:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  800265:	e8 cd 1c 00 00       	call   801f37 <sys_disable_interrupt>

		cprintf("Do you want to repeat (y/n): ") ;
  80026a:	83 ec 0c             	sub    $0xc,%esp
  80026d:	68 3a 3e 80 00       	push   $0x803e3a
  800272:	e8 bd 07 00 00       	call   800a34 <cprintf>
  800277:	83 c4 10             	add    $0x10,%esp
		Chose = getchar() ;
  80027a:	e8 6d 03 00 00       	call   8005ec <getchar>
  80027f:	88 45 ef             	mov    %al,-0x11(%ebp)
		cputchar(Chose);
  800282:	0f be 45 ef          	movsbl -0x11(%ebp),%eax
  800286:	83 ec 0c             	sub    $0xc,%esp
  800289:	50                   	push   %eax
  80028a:	e8 15 03 00 00       	call   8005a4 <cputchar>
  80028f:	83 c4 10             	add    $0x10,%esp
		cputchar('\n');
  800292:	83 ec 0c             	sub    $0xc,%esp
  800295:	6a 0a                	push   $0xa
  800297:	e8 08 03 00 00       	call   8005a4 <cputchar>
  80029c:	83 c4 10             	add    $0x10,%esp

		sys_enable_interrupt();
  80029f:	e8 ad 1c 00 00       	call   801f51 <sys_enable_interrupt>

	} while (Chose == 'y');
  8002a4:	80 7d ef 79          	cmpb   $0x79,-0x11(%ebp)
  8002a8:	0f 84 93 fd ff ff    	je     800041 <_main+0x9>

}
  8002ae:	90                   	nop
  8002af:	c9                   	leave  
  8002b0:	c3                   	ret    

008002b1 <QuickSort>:

///Quick sort
void QuickSort(int *Elements, int NumOfElements)
{
  8002b1:	55                   	push   %ebp
  8002b2:	89 e5                	mov    %esp,%ebp
  8002b4:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  8002b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002ba:	48                   	dec    %eax
  8002bb:	50                   	push   %eax
  8002bc:	6a 00                	push   $0x0
  8002be:	ff 75 0c             	pushl  0xc(%ebp)
  8002c1:	ff 75 08             	pushl  0x8(%ebp)
  8002c4:	e8 06 00 00 00       	call   8002cf <QSort>
  8002c9:	83 c4 10             	add    $0x10,%esp
}
  8002cc:	90                   	nop
  8002cd:	c9                   	leave  
  8002ce:	c3                   	ret    

008002cf <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  8002cf:	55                   	push   %ebp
  8002d0:	89 e5                	mov    %esp,%ebp
  8002d2:	83 ec 18             	sub    $0x18,%esp
	if (startIndex >= finalIndex) return;
  8002d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8002d8:	3b 45 14             	cmp    0x14(%ebp),%eax
  8002db:	0f 8d de 00 00 00    	jge    8003bf <QSort+0xf0>

	int i = startIndex+1, j = finalIndex;
  8002e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8002e4:	40                   	inc    %eax
  8002e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8002e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8002eb:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  8002ee:	e9 80 00 00 00       	jmp    800373 <QSort+0xa4>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  8002f3:	ff 45 f4             	incl   -0xc(%ebp)
  8002f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002f9:	3b 45 14             	cmp    0x14(%ebp),%eax
  8002fc:	7f 2b                	jg     800329 <QSort+0x5a>
  8002fe:	8b 45 10             	mov    0x10(%ebp),%eax
  800301:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800308:	8b 45 08             	mov    0x8(%ebp),%eax
  80030b:	01 d0                	add    %edx,%eax
  80030d:	8b 10                	mov    (%eax),%edx
  80030f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800312:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800319:	8b 45 08             	mov    0x8(%ebp),%eax
  80031c:	01 c8                	add    %ecx,%eax
  80031e:	8b 00                	mov    (%eax),%eax
  800320:	39 c2                	cmp    %eax,%edx
  800322:	7d cf                	jge    8002f3 <QSort+0x24>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  800324:	eb 03                	jmp    800329 <QSort+0x5a>
  800326:	ff 4d f0             	decl   -0x10(%ebp)
  800329:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80032c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80032f:	7e 26                	jle    800357 <QSort+0x88>
  800331:	8b 45 10             	mov    0x10(%ebp),%eax
  800334:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80033b:	8b 45 08             	mov    0x8(%ebp),%eax
  80033e:	01 d0                	add    %edx,%eax
  800340:	8b 10                	mov    (%eax),%edx
  800342:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800345:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80034c:	8b 45 08             	mov    0x8(%ebp),%eax
  80034f:	01 c8                	add    %ecx,%eax
  800351:	8b 00                	mov    (%eax),%eax
  800353:	39 c2                	cmp    %eax,%edx
  800355:	7e cf                	jle    800326 <QSort+0x57>

		if (i <= j)
  800357:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80035a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80035d:	7f 14                	jg     800373 <QSort+0xa4>
		{
			Swap(Elements, i, j);
  80035f:	83 ec 04             	sub    $0x4,%esp
  800362:	ff 75 f0             	pushl  -0x10(%ebp)
  800365:	ff 75 f4             	pushl  -0xc(%ebp)
  800368:	ff 75 08             	pushl  0x8(%ebp)
  80036b:	e8 a9 00 00 00       	call   800419 <Swap>
  800370:	83 c4 10             	add    $0x10,%esp
{
	if (startIndex >= finalIndex) return;

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  800373:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800376:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800379:	0f 8e 77 ff ff ff    	jle    8002f6 <QSort+0x27>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  80037f:	83 ec 04             	sub    $0x4,%esp
  800382:	ff 75 f0             	pushl  -0x10(%ebp)
  800385:	ff 75 10             	pushl  0x10(%ebp)
  800388:	ff 75 08             	pushl  0x8(%ebp)
  80038b:	e8 89 00 00 00       	call   800419 <Swap>
  800390:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  800393:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800396:	48                   	dec    %eax
  800397:	50                   	push   %eax
  800398:	ff 75 10             	pushl  0x10(%ebp)
  80039b:	ff 75 0c             	pushl  0xc(%ebp)
  80039e:	ff 75 08             	pushl  0x8(%ebp)
  8003a1:	e8 29 ff ff ff       	call   8002cf <QSort>
  8003a6:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  8003a9:	ff 75 14             	pushl  0x14(%ebp)
  8003ac:	ff 75 f4             	pushl  -0xc(%ebp)
  8003af:	ff 75 0c             	pushl  0xc(%ebp)
  8003b2:	ff 75 08             	pushl  0x8(%ebp)
  8003b5:	e8 15 ff ff ff       	call   8002cf <QSort>
  8003ba:	83 c4 10             	add    $0x10,%esp
  8003bd:	eb 01                	jmp    8003c0 <QSort+0xf1>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  8003bf:	90                   	nop
	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);

	//cprintf("qs,after sorting: start = %d, end = %d\n", startIndex, finalIndex);

}
  8003c0:	c9                   	leave  
  8003c1:	c3                   	ret    

008003c2 <CheckSorted>:

uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8003c2:	55                   	push   %ebp
  8003c3:	89 e5                	mov    %esp,%ebp
  8003c5:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8003c8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8003cf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8003d6:	eb 33                	jmp    80040b <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8003d8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8003db:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e5:	01 d0                	add    %edx,%eax
  8003e7:	8b 10                	mov    (%eax),%edx
  8003e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8003ec:	40                   	inc    %eax
  8003ed:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f7:	01 c8                	add    %ecx,%eax
  8003f9:	8b 00                	mov    (%eax),%eax
  8003fb:	39 c2                	cmp    %eax,%edx
  8003fd:	7e 09                	jle    800408 <CheckSorted+0x46>
		{
			Sorted = 0 ;
  8003ff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800406:	eb 0c                	jmp    800414 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800408:	ff 45 f8             	incl   -0x8(%ebp)
  80040b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80040e:	48                   	dec    %eax
  80040f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800412:	7f c4                	jg     8003d8 <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800414:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800417:	c9                   	leave  
  800418:	c3                   	ret    

00800419 <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  800419:	55                   	push   %ebp
  80041a:	89 e5                	mov    %esp,%ebp
  80041c:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  80041f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800422:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800429:	8b 45 08             	mov    0x8(%ebp),%eax
  80042c:	01 d0                	add    %edx,%eax
  80042e:	8b 00                	mov    (%eax),%eax
  800430:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800433:	8b 45 0c             	mov    0xc(%ebp),%eax
  800436:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80043d:	8b 45 08             	mov    0x8(%ebp),%eax
  800440:	01 c2                	add    %eax,%edx
  800442:	8b 45 10             	mov    0x10(%ebp),%eax
  800445:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80044c:	8b 45 08             	mov    0x8(%ebp),%eax
  80044f:	01 c8                	add    %ecx,%eax
  800451:	8b 00                	mov    (%eax),%eax
  800453:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800455:	8b 45 10             	mov    0x10(%ebp),%eax
  800458:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80045f:	8b 45 08             	mov    0x8(%ebp),%eax
  800462:	01 c2                	add    %eax,%edx
  800464:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800467:	89 02                	mov    %eax,(%edx)
}
  800469:	90                   	nop
  80046a:	c9                   	leave  
  80046b:	c3                   	ret    

0080046c <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  80046c:	55                   	push   %ebp
  80046d:	89 e5                	mov    %esp,%ebp
  80046f:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800472:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800479:	eb 17                	jmp    800492 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  80047b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80047e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800485:	8b 45 08             	mov    0x8(%ebp),%eax
  800488:	01 c2                	add    %eax,%edx
  80048a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80048d:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80048f:	ff 45 fc             	incl   -0x4(%ebp)
  800492:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800495:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800498:	7c e1                	jl     80047b <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  80049a:	90                   	nop
  80049b:	c9                   	leave  
  80049c:	c3                   	ret    

0080049d <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  80049d:	55                   	push   %ebp
  80049e:	89 e5                	mov    %esp,%ebp
  8004a0:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004a3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8004aa:	eb 1b                	jmp    8004c7 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8004ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004af:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b9:	01 c2                	add    %eax,%edx
  8004bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004be:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8004c1:	48                   	dec    %eax
  8004c2:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004c4:	ff 45 fc             	incl   -0x4(%ebp)
  8004c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004ca:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004cd:	7c dd                	jl     8004ac <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8004cf:	90                   	nop
  8004d0:	c9                   	leave  
  8004d1:	c3                   	ret    

008004d2 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8004d2:	55                   	push   %ebp
  8004d3:	89 e5                	mov    %esp,%ebp
  8004d5:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8004d8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004db:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8004e0:	f7 e9                	imul   %ecx
  8004e2:	c1 f9 1f             	sar    $0x1f,%ecx
  8004e5:	89 d0                	mov    %edx,%eax
  8004e7:	29 c8                	sub    %ecx,%eax
  8004e9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  8004ec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8004f3:	eb 1e                	jmp    800513 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  8004f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004f8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800502:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800505:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800508:	99                   	cltd   
  800509:	f7 7d f8             	idivl  -0x8(%ebp)
  80050c:	89 d0                	mov    %edx,%eax
  80050e:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800510:	ff 45 fc             	incl   -0x4(%ebp)
  800513:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800516:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800519:	7c da                	jl     8004f5 <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
		//	cprintf("i=%d\n",i);
	}

}
  80051b:	90                   	nop
  80051c:	c9                   	leave  
  80051d:	c3                   	ret    

0080051e <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  80051e:	55                   	push   %ebp
  80051f:	89 e5                	mov    %esp,%ebp
  800521:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800524:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  80052b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800532:	eb 42                	jmp    800576 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800534:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800537:	99                   	cltd   
  800538:	f7 7d f0             	idivl  -0x10(%ebp)
  80053b:	89 d0                	mov    %edx,%eax
  80053d:	85 c0                	test   %eax,%eax
  80053f:	75 10                	jne    800551 <PrintElements+0x33>
			cprintf("\n");
  800541:	83 ec 0c             	sub    $0xc,%esp
  800544:	68 80 3c 80 00       	push   $0x803c80
  800549:	e8 e6 04 00 00       	call   800a34 <cprintf>
  80054e:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800551:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800554:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80055b:	8b 45 08             	mov    0x8(%ebp),%eax
  80055e:	01 d0                	add    %edx,%eax
  800560:	8b 00                	mov    (%eax),%eax
  800562:	83 ec 08             	sub    $0x8,%esp
  800565:	50                   	push   %eax
  800566:	68 58 3e 80 00       	push   $0x803e58
  80056b:	e8 c4 04 00 00       	call   800a34 <cprintf>
  800570:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800573:	ff 45 f4             	incl   -0xc(%ebp)
  800576:	8b 45 0c             	mov    0xc(%ebp),%eax
  800579:	48                   	dec    %eax
  80057a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80057d:	7f b5                	jg     800534 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  80057f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800582:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800589:	8b 45 08             	mov    0x8(%ebp),%eax
  80058c:	01 d0                	add    %edx,%eax
  80058e:	8b 00                	mov    (%eax),%eax
  800590:	83 ec 08             	sub    $0x8,%esp
  800593:	50                   	push   %eax
  800594:	68 5d 3e 80 00       	push   $0x803e5d
  800599:	e8 96 04 00 00       	call   800a34 <cprintf>
  80059e:	83 c4 10             	add    $0x10,%esp

}
  8005a1:	90                   	nop
  8005a2:	c9                   	leave  
  8005a3:	c3                   	ret    

008005a4 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8005a4:	55                   	push   %ebp
  8005a5:	89 e5                	mov    %esp,%ebp
  8005a7:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8005aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ad:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8005b0:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8005b4:	83 ec 0c             	sub    $0xc,%esp
  8005b7:	50                   	push   %eax
  8005b8:	e8 ae 19 00 00       	call   801f6b <sys_cputc>
  8005bd:	83 c4 10             	add    $0x10,%esp
}
  8005c0:	90                   	nop
  8005c1:	c9                   	leave  
  8005c2:	c3                   	ret    

008005c3 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  8005c3:	55                   	push   %ebp
  8005c4:	89 e5                	mov    %esp,%ebp
  8005c6:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8005c9:	e8 69 19 00 00       	call   801f37 <sys_disable_interrupt>
	char c = ch;
  8005ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d1:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8005d4:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8005d8:	83 ec 0c             	sub    $0xc,%esp
  8005db:	50                   	push   %eax
  8005dc:	e8 8a 19 00 00       	call   801f6b <sys_cputc>
  8005e1:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8005e4:	e8 68 19 00 00       	call   801f51 <sys_enable_interrupt>
}
  8005e9:	90                   	nop
  8005ea:	c9                   	leave  
  8005eb:	c3                   	ret    

008005ec <getchar>:

int
getchar(void)
{
  8005ec:	55                   	push   %ebp
  8005ed:	89 e5                	mov    %esp,%ebp
  8005ef:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  8005f2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8005f9:	eb 08                	jmp    800603 <getchar+0x17>
	{
		c = sys_cgetc();
  8005fb:	e8 b2 17 00 00       	call   801db2 <sys_cgetc>
  800600:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  800603:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800607:	74 f2                	je     8005fb <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  800609:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80060c:	c9                   	leave  
  80060d:	c3                   	ret    

0080060e <atomic_getchar>:

int
atomic_getchar(void)
{
  80060e:	55                   	push   %ebp
  80060f:	89 e5                	mov    %esp,%ebp
  800611:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800614:	e8 1e 19 00 00       	call   801f37 <sys_disable_interrupt>
	int c=0;
  800619:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800620:	eb 08                	jmp    80062a <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  800622:	e8 8b 17 00 00       	call   801db2 <sys_cgetc>
  800627:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  80062a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80062e:	74 f2                	je     800622 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  800630:	e8 1c 19 00 00       	call   801f51 <sys_enable_interrupt>
	return c;
  800635:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800638:	c9                   	leave  
  800639:	c3                   	ret    

0080063a <iscons>:

int iscons(int fdnum)
{
  80063a:	55                   	push   %ebp
  80063b:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  80063d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800642:	5d                   	pop    %ebp
  800643:	c3                   	ret    

00800644 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800644:	55                   	push   %ebp
  800645:	89 e5                	mov    %esp,%ebp
  800647:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80064a:	e8 db 1a 00 00       	call   80212a <sys_getenvindex>
  80064f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800652:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800655:	89 d0                	mov    %edx,%eax
  800657:	c1 e0 03             	shl    $0x3,%eax
  80065a:	01 d0                	add    %edx,%eax
  80065c:	01 c0                	add    %eax,%eax
  80065e:	01 d0                	add    %edx,%eax
  800660:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800667:	01 d0                	add    %edx,%eax
  800669:	c1 e0 04             	shl    $0x4,%eax
  80066c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800671:	a3 24 50 80 00       	mov    %eax,0x805024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800676:	a1 24 50 80 00       	mov    0x805024,%eax
  80067b:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800681:	84 c0                	test   %al,%al
  800683:	74 0f                	je     800694 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800685:	a1 24 50 80 00       	mov    0x805024,%eax
  80068a:	05 5c 05 00 00       	add    $0x55c,%eax
  80068f:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800694:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800698:	7e 0a                	jle    8006a4 <libmain+0x60>
		binaryname = argv[0];
  80069a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80069d:	8b 00                	mov    (%eax),%eax
  80069f:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8006a4:	83 ec 08             	sub    $0x8,%esp
  8006a7:	ff 75 0c             	pushl  0xc(%ebp)
  8006aa:	ff 75 08             	pushl  0x8(%ebp)
  8006ad:	e8 86 f9 ff ff       	call   800038 <_main>
  8006b2:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8006b5:	e8 7d 18 00 00       	call   801f37 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8006ba:	83 ec 0c             	sub    $0xc,%esp
  8006bd:	68 7c 3e 80 00       	push   $0x803e7c
  8006c2:	e8 6d 03 00 00       	call   800a34 <cprintf>
  8006c7:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8006ca:	a1 24 50 80 00       	mov    0x805024,%eax
  8006cf:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8006d5:	a1 24 50 80 00       	mov    0x805024,%eax
  8006da:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8006e0:	83 ec 04             	sub    $0x4,%esp
  8006e3:	52                   	push   %edx
  8006e4:	50                   	push   %eax
  8006e5:	68 a4 3e 80 00       	push   $0x803ea4
  8006ea:	e8 45 03 00 00       	call   800a34 <cprintf>
  8006ef:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8006f2:	a1 24 50 80 00       	mov    0x805024,%eax
  8006f7:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8006fd:	a1 24 50 80 00       	mov    0x805024,%eax
  800702:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800708:	a1 24 50 80 00       	mov    0x805024,%eax
  80070d:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800713:	51                   	push   %ecx
  800714:	52                   	push   %edx
  800715:	50                   	push   %eax
  800716:	68 cc 3e 80 00       	push   $0x803ecc
  80071b:	e8 14 03 00 00       	call   800a34 <cprintf>
  800720:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800723:	a1 24 50 80 00       	mov    0x805024,%eax
  800728:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80072e:	83 ec 08             	sub    $0x8,%esp
  800731:	50                   	push   %eax
  800732:	68 24 3f 80 00       	push   $0x803f24
  800737:	e8 f8 02 00 00       	call   800a34 <cprintf>
  80073c:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80073f:	83 ec 0c             	sub    $0xc,%esp
  800742:	68 7c 3e 80 00       	push   $0x803e7c
  800747:	e8 e8 02 00 00       	call   800a34 <cprintf>
  80074c:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80074f:	e8 fd 17 00 00       	call   801f51 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800754:	e8 19 00 00 00       	call   800772 <exit>
}
  800759:	90                   	nop
  80075a:	c9                   	leave  
  80075b:	c3                   	ret    

0080075c <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80075c:	55                   	push   %ebp
  80075d:	89 e5                	mov    %esp,%ebp
  80075f:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800762:	83 ec 0c             	sub    $0xc,%esp
  800765:	6a 00                	push   $0x0
  800767:	e8 8a 19 00 00       	call   8020f6 <sys_destroy_env>
  80076c:	83 c4 10             	add    $0x10,%esp
}
  80076f:	90                   	nop
  800770:	c9                   	leave  
  800771:	c3                   	ret    

00800772 <exit>:

void
exit(void)
{
  800772:	55                   	push   %ebp
  800773:	89 e5                	mov    %esp,%ebp
  800775:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800778:	e8 df 19 00 00       	call   80215c <sys_exit_env>
}
  80077d:	90                   	nop
  80077e:	c9                   	leave  
  80077f:	c3                   	ret    

00800780 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800780:	55                   	push   %ebp
  800781:	89 e5                	mov    %esp,%ebp
  800783:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800786:	8d 45 10             	lea    0x10(%ebp),%eax
  800789:	83 c0 04             	add    $0x4,%eax
  80078c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80078f:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800794:	85 c0                	test   %eax,%eax
  800796:	74 16                	je     8007ae <_panic+0x2e>
		cprintf("%s: ", argv0);
  800798:	a1 5c 51 80 00       	mov    0x80515c,%eax
  80079d:	83 ec 08             	sub    $0x8,%esp
  8007a0:	50                   	push   %eax
  8007a1:	68 38 3f 80 00       	push   $0x803f38
  8007a6:	e8 89 02 00 00       	call   800a34 <cprintf>
  8007ab:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8007ae:	a1 00 50 80 00       	mov    0x805000,%eax
  8007b3:	ff 75 0c             	pushl  0xc(%ebp)
  8007b6:	ff 75 08             	pushl  0x8(%ebp)
  8007b9:	50                   	push   %eax
  8007ba:	68 3d 3f 80 00       	push   $0x803f3d
  8007bf:	e8 70 02 00 00       	call   800a34 <cprintf>
  8007c4:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8007c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8007ca:	83 ec 08             	sub    $0x8,%esp
  8007cd:	ff 75 f4             	pushl  -0xc(%ebp)
  8007d0:	50                   	push   %eax
  8007d1:	e8 f3 01 00 00       	call   8009c9 <vcprintf>
  8007d6:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8007d9:	83 ec 08             	sub    $0x8,%esp
  8007dc:	6a 00                	push   $0x0
  8007de:	68 59 3f 80 00       	push   $0x803f59
  8007e3:	e8 e1 01 00 00       	call   8009c9 <vcprintf>
  8007e8:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8007eb:	e8 82 ff ff ff       	call   800772 <exit>

	// should not return here
	while (1) ;
  8007f0:	eb fe                	jmp    8007f0 <_panic+0x70>

008007f2 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8007f2:	55                   	push   %ebp
  8007f3:	89 e5                	mov    %esp,%ebp
  8007f5:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8007f8:	a1 24 50 80 00       	mov    0x805024,%eax
  8007fd:	8b 50 74             	mov    0x74(%eax),%edx
  800800:	8b 45 0c             	mov    0xc(%ebp),%eax
  800803:	39 c2                	cmp    %eax,%edx
  800805:	74 14                	je     80081b <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800807:	83 ec 04             	sub    $0x4,%esp
  80080a:	68 5c 3f 80 00       	push   $0x803f5c
  80080f:	6a 26                	push   $0x26
  800811:	68 a8 3f 80 00       	push   $0x803fa8
  800816:	e8 65 ff ff ff       	call   800780 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80081b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800822:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800829:	e9 c2 00 00 00       	jmp    8008f0 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80082e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800831:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800838:	8b 45 08             	mov    0x8(%ebp),%eax
  80083b:	01 d0                	add    %edx,%eax
  80083d:	8b 00                	mov    (%eax),%eax
  80083f:	85 c0                	test   %eax,%eax
  800841:	75 08                	jne    80084b <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800843:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800846:	e9 a2 00 00 00       	jmp    8008ed <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80084b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800852:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800859:	eb 69                	jmp    8008c4 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80085b:	a1 24 50 80 00       	mov    0x805024,%eax
  800860:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800866:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800869:	89 d0                	mov    %edx,%eax
  80086b:	01 c0                	add    %eax,%eax
  80086d:	01 d0                	add    %edx,%eax
  80086f:	c1 e0 03             	shl    $0x3,%eax
  800872:	01 c8                	add    %ecx,%eax
  800874:	8a 40 04             	mov    0x4(%eax),%al
  800877:	84 c0                	test   %al,%al
  800879:	75 46                	jne    8008c1 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80087b:	a1 24 50 80 00       	mov    0x805024,%eax
  800880:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800886:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800889:	89 d0                	mov    %edx,%eax
  80088b:	01 c0                	add    %eax,%eax
  80088d:	01 d0                	add    %edx,%eax
  80088f:	c1 e0 03             	shl    $0x3,%eax
  800892:	01 c8                	add    %ecx,%eax
  800894:	8b 00                	mov    (%eax),%eax
  800896:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800899:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80089c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8008a1:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8008a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008a6:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8008ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b0:	01 c8                	add    %ecx,%eax
  8008b2:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008b4:	39 c2                	cmp    %eax,%edx
  8008b6:	75 09                	jne    8008c1 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8008b8:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8008bf:	eb 12                	jmp    8008d3 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008c1:	ff 45 e8             	incl   -0x18(%ebp)
  8008c4:	a1 24 50 80 00       	mov    0x805024,%eax
  8008c9:	8b 50 74             	mov    0x74(%eax),%edx
  8008cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008cf:	39 c2                	cmp    %eax,%edx
  8008d1:	77 88                	ja     80085b <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8008d3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8008d7:	75 14                	jne    8008ed <CheckWSWithoutLastIndex+0xfb>
			panic(
  8008d9:	83 ec 04             	sub    $0x4,%esp
  8008dc:	68 b4 3f 80 00       	push   $0x803fb4
  8008e1:	6a 3a                	push   $0x3a
  8008e3:	68 a8 3f 80 00       	push   $0x803fa8
  8008e8:	e8 93 fe ff ff       	call   800780 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8008ed:	ff 45 f0             	incl   -0x10(%ebp)
  8008f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008f3:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8008f6:	0f 8c 32 ff ff ff    	jl     80082e <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8008fc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800903:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80090a:	eb 26                	jmp    800932 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80090c:	a1 24 50 80 00       	mov    0x805024,%eax
  800911:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800917:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80091a:	89 d0                	mov    %edx,%eax
  80091c:	01 c0                	add    %eax,%eax
  80091e:	01 d0                	add    %edx,%eax
  800920:	c1 e0 03             	shl    $0x3,%eax
  800923:	01 c8                	add    %ecx,%eax
  800925:	8a 40 04             	mov    0x4(%eax),%al
  800928:	3c 01                	cmp    $0x1,%al
  80092a:	75 03                	jne    80092f <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80092c:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80092f:	ff 45 e0             	incl   -0x20(%ebp)
  800932:	a1 24 50 80 00       	mov    0x805024,%eax
  800937:	8b 50 74             	mov    0x74(%eax),%edx
  80093a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80093d:	39 c2                	cmp    %eax,%edx
  80093f:	77 cb                	ja     80090c <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800941:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800944:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800947:	74 14                	je     80095d <CheckWSWithoutLastIndex+0x16b>
		panic(
  800949:	83 ec 04             	sub    $0x4,%esp
  80094c:	68 08 40 80 00       	push   $0x804008
  800951:	6a 44                	push   $0x44
  800953:	68 a8 3f 80 00       	push   $0x803fa8
  800958:	e8 23 fe ff ff       	call   800780 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80095d:	90                   	nop
  80095e:	c9                   	leave  
  80095f:	c3                   	ret    

00800960 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800960:	55                   	push   %ebp
  800961:	89 e5                	mov    %esp,%ebp
  800963:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800966:	8b 45 0c             	mov    0xc(%ebp),%eax
  800969:	8b 00                	mov    (%eax),%eax
  80096b:	8d 48 01             	lea    0x1(%eax),%ecx
  80096e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800971:	89 0a                	mov    %ecx,(%edx)
  800973:	8b 55 08             	mov    0x8(%ebp),%edx
  800976:	88 d1                	mov    %dl,%cl
  800978:	8b 55 0c             	mov    0xc(%ebp),%edx
  80097b:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80097f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800982:	8b 00                	mov    (%eax),%eax
  800984:	3d ff 00 00 00       	cmp    $0xff,%eax
  800989:	75 2c                	jne    8009b7 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80098b:	a0 28 50 80 00       	mov    0x805028,%al
  800990:	0f b6 c0             	movzbl %al,%eax
  800993:	8b 55 0c             	mov    0xc(%ebp),%edx
  800996:	8b 12                	mov    (%edx),%edx
  800998:	89 d1                	mov    %edx,%ecx
  80099a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80099d:	83 c2 08             	add    $0x8,%edx
  8009a0:	83 ec 04             	sub    $0x4,%esp
  8009a3:	50                   	push   %eax
  8009a4:	51                   	push   %ecx
  8009a5:	52                   	push   %edx
  8009a6:	e8 de 13 00 00       	call   801d89 <sys_cputs>
  8009ab:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8009ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009b1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8009b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ba:	8b 40 04             	mov    0x4(%eax),%eax
  8009bd:	8d 50 01             	lea    0x1(%eax),%edx
  8009c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009c3:	89 50 04             	mov    %edx,0x4(%eax)
}
  8009c6:	90                   	nop
  8009c7:	c9                   	leave  
  8009c8:	c3                   	ret    

008009c9 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8009c9:	55                   	push   %ebp
  8009ca:	89 e5                	mov    %esp,%ebp
  8009cc:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8009d2:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8009d9:	00 00 00 
	b.cnt = 0;
  8009dc:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8009e3:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8009e6:	ff 75 0c             	pushl  0xc(%ebp)
  8009e9:	ff 75 08             	pushl  0x8(%ebp)
  8009ec:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009f2:	50                   	push   %eax
  8009f3:	68 60 09 80 00       	push   $0x800960
  8009f8:	e8 11 02 00 00       	call   800c0e <vprintfmt>
  8009fd:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800a00:	a0 28 50 80 00       	mov    0x805028,%al
  800a05:	0f b6 c0             	movzbl %al,%eax
  800a08:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800a0e:	83 ec 04             	sub    $0x4,%esp
  800a11:	50                   	push   %eax
  800a12:	52                   	push   %edx
  800a13:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a19:	83 c0 08             	add    $0x8,%eax
  800a1c:	50                   	push   %eax
  800a1d:	e8 67 13 00 00       	call   801d89 <sys_cputs>
  800a22:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800a25:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
	return b.cnt;
  800a2c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800a32:	c9                   	leave  
  800a33:	c3                   	ret    

00800a34 <cprintf>:

int cprintf(const char *fmt, ...) {
  800a34:	55                   	push   %ebp
  800a35:	89 e5                	mov    %esp,%ebp
  800a37:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a3a:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
	va_start(ap, fmt);
  800a41:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a44:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a47:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4a:	83 ec 08             	sub    $0x8,%esp
  800a4d:	ff 75 f4             	pushl  -0xc(%ebp)
  800a50:	50                   	push   %eax
  800a51:	e8 73 ff ff ff       	call   8009c9 <vcprintf>
  800a56:	83 c4 10             	add    $0x10,%esp
  800a59:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800a5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a5f:	c9                   	leave  
  800a60:	c3                   	ret    

00800a61 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800a61:	55                   	push   %ebp
  800a62:	89 e5                	mov    %esp,%ebp
  800a64:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800a67:	e8 cb 14 00 00       	call   801f37 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800a6c:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a72:	8b 45 08             	mov    0x8(%ebp),%eax
  800a75:	83 ec 08             	sub    $0x8,%esp
  800a78:	ff 75 f4             	pushl  -0xc(%ebp)
  800a7b:	50                   	push   %eax
  800a7c:	e8 48 ff ff ff       	call   8009c9 <vcprintf>
  800a81:	83 c4 10             	add    $0x10,%esp
  800a84:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800a87:	e8 c5 14 00 00       	call   801f51 <sys_enable_interrupt>
	return cnt;
  800a8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a8f:	c9                   	leave  
  800a90:	c3                   	ret    

00800a91 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a91:	55                   	push   %ebp
  800a92:	89 e5                	mov    %esp,%ebp
  800a94:	53                   	push   %ebx
  800a95:	83 ec 14             	sub    $0x14,%esp
  800a98:	8b 45 10             	mov    0x10(%ebp),%eax
  800a9b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a9e:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800aa4:	8b 45 18             	mov    0x18(%ebp),%eax
  800aa7:	ba 00 00 00 00       	mov    $0x0,%edx
  800aac:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800aaf:	77 55                	ja     800b06 <printnum+0x75>
  800ab1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800ab4:	72 05                	jb     800abb <printnum+0x2a>
  800ab6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800ab9:	77 4b                	ja     800b06 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800abb:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800abe:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800ac1:	8b 45 18             	mov    0x18(%ebp),%eax
  800ac4:	ba 00 00 00 00       	mov    $0x0,%edx
  800ac9:	52                   	push   %edx
  800aca:	50                   	push   %eax
  800acb:	ff 75 f4             	pushl  -0xc(%ebp)
  800ace:	ff 75 f0             	pushl  -0x10(%ebp)
  800ad1:	e8 36 2f 00 00       	call   803a0c <__udivdi3>
  800ad6:	83 c4 10             	add    $0x10,%esp
  800ad9:	83 ec 04             	sub    $0x4,%esp
  800adc:	ff 75 20             	pushl  0x20(%ebp)
  800adf:	53                   	push   %ebx
  800ae0:	ff 75 18             	pushl  0x18(%ebp)
  800ae3:	52                   	push   %edx
  800ae4:	50                   	push   %eax
  800ae5:	ff 75 0c             	pushl  0xc(%ebp)
  800ae8:	ff 75 08             	pushl  0x8(%ebp)
  800aeb:	e8 a1 ff ff ff       	call   800a91 <printnum>
  800af0:	83 c4 20             	add    $0x20,%esp
  800af3:	eb 1a                	jmp    800b0f <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800af5:	83 ec 08             	sub    $0x8,%esp
  800af8:	ff 75 0c             	pushl  0xc(%ebp)
  800afb:	ff 75 20             	pushl  0x20(%ebp)
  800afe:	8b 45 08             	mov    0x8(%ebp),%eax
  800b01:	ff d0                	call   *%eax
  800b03:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800b06:	ff 4d 1c             	decl   0x1c(%ebp)
  800b09:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800b0d:	7f e6                	jg     800af5 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800b0f:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800b12:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b1d:	53                   	push   %ebx
  800b1e:	51                   	push   %ecx
  800b1f:	52                   	push   %edx
  800b20:	50                   	push   %eax
  800b21:	e8 f6 2f 00 00       	call   803b1c <__umoddi3>
  800b26:	83 c4 10             	add    $0x10,%esp
  800b29:	05 74 42 80 00       	add    $0x804274,%eax
  800b2e:	8a 00                	mov    (%eax),%al
  800b30:	0f be c0             	movsbl %al,%eax
  800b33:	83 ec 08             	sub    $0x8,%esp
  800b36:	ff 75 0c             	pushl  0xc(%ebp)
  800b39:	50                   	push   %eax
  800b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3d:	ff d0                	call   *%eax
  800b3f:	83 c4 10             	add    $0x10,%esp
}
  800b42:	90                   	nop
  800b43:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b46:	c9                   	leave  
  800b47:	c3                   	ret    

00800b48 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800b48:	55                   	push   %ebp
  800b49:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b4b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b4f:	7e 1c                	jle    800b6d <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800b51:	8b 45 08             	mov    0x8(%ebp),%eax
  800b54:	8b 00                	mov    (%eax),%eax
  800b56:	8d 50 08             	lea    0x8(%eax),%edx
  800b59:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5c:	89 10                	mov    %edx,(%eax)
  800b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b61:	8b 00                	mov    (%eax),%eax
  800b63:	83 e8 08             	sub    $0x8,%eax
  800b66:	8b 50 04             	mov    0x4(%eax),%edx
  800b69:	8b 00                	mov    (%eax),%eax
  800b6b:	eb 40                	jmp    800bad <getuint+0x65>
	else if (lflag)
  800b6d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b71:	74 1e                	je     800b91 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800b73:	8b 45 08             	mov    0x8(%ebp),%eax
  800b76:	8b 00                	mov    (%eax),%eax
  800b78:	8d 50 04             	lea    0x4(%eax),%edx
  800b7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7e:	89 10                	mov    %edx,(%eax)
  800b80:	8b 45 08             	mov    0x8(%ebp),%eax
  800b83:	8b 00                	mov    (%eax),%eax
  800b85:	83 e8 04             	sub    $0x4,%eax
  800b88:	8b 00                	mov    (%eax),%eax
  800b8a:	ba 00 00 00 00       	mov    $0x0,%edx
  800b8f:	eb 1c                	jmp    800bad <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800b91:	8b 45 08             	mov    0x8(%ebp),%eax
  800b94:	8b 00                	mov    (%eax),%eax
  800b96:	8d 50 04             	lea    0x4(%eax),%edx
  800b99:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9c:	89 10                	mov    %edx,(%eax)
  800b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba1:	8b 00                	mov    (%eax),%eax
  800ba3:	83 e8 04             	sub    $0x4,%eax
  800ba6:	8b 00                	mov    (%eax),%eax
  800ba8:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800bad:	5d                   	pop    %ebp
  800bae:	c3                   	ret    

00800baf <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800baf:	55                   	push   %ebp
  800bb0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800bb2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800bb6:	7e 1c                	jle    800bd4 <getint+0x25>
		return va_arg(*ap, long long);
  800bb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbb:	8b 00                	mov    (%eax),%eax
  800bbd:	8d 50 08             	lea    0x8(%eax),%edx
  800bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc3:	89 10                	mov    %edx,(%eax)
  800bc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc8:	8b 00                	mov    (%eax),%eax
  800bca:	83 e8 08             	sub    $0x8,%eax
  800bcd:	8b 50 04             	mov    0x4(%eax),%edx
  800bd0:	8b 00                	mov    (%eax),%eax
  800bd2:	eb 38                	jmp    800c0c <getint+0x5d>
	else if (lflag)
  800bd4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bd8:	74 1a                	je     800bf4 <getint+0x45>
		return va_arg(*ap, long);
  800bda:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdd:	8b 00                	mov    (%eax),%eax
  800bdf:	8d 50 04             	lea    0x4(%eax),%edx
  800be2:	8b 45 08             	mov    0x8(%ebp),%eax
  800be5:	89 10                	mov    %edx,(%eax)
  800be7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bea:	8b 00                	mov    (%eax),%eax
  800bec:	83 e8 04             	sub    $0x4,%eax
  800bef:	8b 00                	mov    (%eax),%eax
  800bf1:	99                   	cltd   
  800bf2:	eb 18                	jmp    800c0c <getint+0x5d>
	else
		return va_arg(*ap, int);
  800bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf7:	8b 00                	mov    (%eax),%eax
  800bf9:	8d 50 04             	lea    0x4(%eax),%edx
  800bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bff:	89 10                	mov    %edx,(%eax)
  800c01:	8b 45 08             	mov    0x8(%ebp),%eax
  800c04:	8b 00                	mov    (%eax),%eax
  800c06:	83 e8 04             	sub    $0x4,%eax
  800c09:	8b 00                	mov    (%eax),%eax
  800c0b:	99                   	cltd   
}
  800c0c:	5d                   	pop    %ebp
  800c0d:	c3                   	ret    

00800c0e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800c0e:	55                   	push   %ebp
  800c0f:	89 e5                	mov    %esp,%ebp
  800c11:	56                   	push   %esi
  800c12:	53                   	push   %ebx
  800c13:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c16:	eb 17                	jmp    800c2f <vprintfmt+0x21>
			if (ch == '\0')
  800c18:	85 db                	test   %ebx,%ebx
  800c1a:	0f 84 af 03 00 00    	je     800fcf <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800c20:	83 ec 08             	sub    $0x8,%esp
  800c23:	ff 75 0c             	pushl  0xc(%ebp)
  800c26:	53                   	push   %ebx
  800c27:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2a:	ff d0                	call   *%eax
  800c2c:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c2f:	8b 45 10             	mov    0x10(%ebp),%eax
  800c32:	8d 50 01             	lea    0x1(%eax),%edx
  800c35:	89 55 10             	mov    %edx,0x10(%ebp)
  800c38:	8a 00                	mov    (%eax),%al
  800c3a:	0f b6 d8             	movzbl %al,%ebx
  800c3d:	83 fb 25             	cmp    $0x25,%ebx
  800c40:	75 d6                	jne    800c18 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800c42:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800c46:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800c4d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800c54:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800c5b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c62:	8b 45 10             	mov    0x10(%ebp),%eax
  800c65:	8d 50 01             	lea    0x1(%eax),%edx
  800c68:	89 55 10             	mov    %edx,0x10(%ebp)
  800c6b:	8a 00                	mov    (%eax),%al
  800c6d:	0f b6 d8             	movzbl %al,%ebx
  800c70:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800c73:	83 f8 55             	cmp    $0x55,%eax
  800c76:	0f 87 2b 03 00 00    	ja     800fa7 <vprintfmt+0x399>
  800c7c:	8b 04 85 98 42 80 00 	mov    0x804298(,%eax,4),%eax
  800c83:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800c85:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800c89:	eb d7                	jmp    800c62 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c8b:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800c8f:	eb d1                	jmp    800c62 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c91:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800c98:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c9b:	89 d0                	mov    %edx,%eax
  800c9d:	c1 e0 02             	shl    $0x2,%eax
  800ca0:	01 d0                	add    %edx,%eax
  800ca2:	01 c0                	add    %eax,%eax
  800ca4:	01 d8                	add    %ebx,%eax
  800ca6:	83 e8 30             	sub    $0x30,%eax
  800ca9:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800cac:	8b 45 10             	mov    0x10(%ebp),%eax
  800caf:	8a 00                	mov    (%eax),%al
  800cb1:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800cb4:	83 fb 2f             	cmp    $0x2f,%ebx
  800cb7:	7e 3e                	jle    800cf7 <vprintfmt+0xe9>
  800cb9:	83 fb 39             	cmp    $0x39,%ebx
  800cbc:	7f 39                	jg     800cf7 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800cbe:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800cc1:	eb d5                	jmp    800c98 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800cc3:	8b 45 14             	mov    0x14(%ebp),%eax
  800cc6:	83 c0 04             	add    $0x4,%eax
  800cc9:	89 45 14             	mov    %eax,0x14(%ebp)
  800ccc:	8b 45 14             	mov    0x14(%ebp),%eax
  800ccf:	83 e8 04             	sub    $0x4,%eax
  800cd2:	8b 00                	mov    (%eax),%eax
  800cd4:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800cd7:	eb 1f                	jmp    800cf8 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800cd9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cdd:	79 83                	jns    800c62 <vprintfmt+0x54>
				width = 0;
  800cdf:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800ce6:	e9 77 ff ff ff       	jmp    800c62 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800ceb:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800cf2:	e9 6b ff ff ff       	jmp    800c62 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800cf7:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800cf8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cfc:	0f 89 60 ff ff ff    	jns    800c62 <vprintfmt+0x54>
				width = precision, precision = -1;
  800d02:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d05:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d08:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800d0f:	e9 4e ff ff ff       	jmp    800c62 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d14:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800d17:	e9 46 ff ff ff       	jmp    800c62 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800d1c:	8b 45 14             	mov    0x14(%ebp),%eax
  800d1f:	83 c0 04             	add    $0x4,%eax
  800d22:	89 45 14             	mov    %eax,0x14(%ebp)
  800d25:	8b 45 14             	mov    0x14(%ebp),%eax
  800d28:	83 e8 04             	sub    $0x4,%eax
  800d2b:	8b 00                	mov    (%eax),%eax
  800d2d:	83 ec 08             	sub    $0x8,%esp
  800d30:	ff 75 0c             	pushl  0xc(%ebp)
  800d33:	50                   	push   %eax
  800d34:	8b 45 08             	mov    0x8(%ebp),%eax
  800d37:	ff d0                	call   *%eax
  800d39:	83 c4 10             	add    $0x10,%esp
			break;
  800d3c:	e9 89 02 00 00       	jmp    800fca <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800d41:	8b 45 14             	mov    0x14(%ebp),%eax
  800d44:	83 c0 04             	add    $0x4,%eax
  800d47:	89 45 14             	mov    %eax,0x14(%ebp)
  800d4a:	8b 45 14             	mov    0x14(%ebp),%eax
  800d4d:	83 e8 04             	sub    $0x4,%eax
  800d50:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800d52:	85 db                	test   %ebx,%ebx
  800d54:	79 02                	jns    800d58 <vprintfmt+0x14a>
				err = -err;
  800d56:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800d58:	83 fb 64             	cmp    $0x64,%ebx
  800d5b:	7f 0b                	jg     800d68 <vprintfmt+0x15a>
  800d5d:	8b 34 9d e0 40 80 00 	mov    0x8040e0(,%ebx,4),%esi
  800d64:	85 f6                	test   %esi,%esi
  800d66:	75 19                	jne    800d81 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d68:	53                   	push   %ebx
  800d69:	68 85 42 80 00       	push   $0x804285
  800d6e:	ff 75 0c             	pushl  0xc(%ebp)
  800d71:	ff 75 08             	pushl  0x8(%ebp)
  800d74:	e8 5e 02 00 00       	call   800fd7 <printfmt>
  800d79:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d7c:	e9 49 02 00 00       	jmp    800fca <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d81:	56                   	push   %esi
  800d82:	68 8e 42 80 00       	push   $0x80428e
  800d87:	ff 75 0c             	pushl  0xc(%ebp)
  800d8a:	ff 75 08             	pushl  0x8(%ebp)
  800d8d:	e8 45 02 00 00       	call   800fd7 <printfmt>
  800d92:	83 c4 10             	add    $0x10,%esp
			break;
  800d95:	e9 30 02 00 00       	jmp    800fca <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800d9a:	8b 45 14             	mov    0x14(%ebp),%eax
  800d9d:	83 c0 04             	add    $0x4,%eax
  800da0:	89 45 14             	mov    %eax,0x14(%ebp)
  800da3:	8b 45 14             	mov    0x14(%ebp),%eax
  800da6:	83 e8 04             	sub    $0x4,%eax
  800da9:	8b 30                	mov    (%eax),%esi
  800dab:	85 f6                	test   %esi,%esi
  800dad:	75 05                	jne    800db4 <vprintfmt+0x1a6>
				p = "(null)";
  800daf:	be 91 42 80 00       	mov    $0x804291,%esi
			if (width > 0 && padc != '-')
  800db4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800db8:	7e 6d                	jle    800e27 <vprintfmt+0x219>
  800dba:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800dbe:	74 67                	je     800e27 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800dc0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800dc3:	83 ec 08             	sub    $0x8,%esp
  800dc6:	50                   	push   %eax
  800dc7:	56                   	push   %esi
  800dc8:	e8 12 05 00 00       	call   8012df <strnlen>
  800dcd:	83 c4 10             	add    $0x10,%esp
  800dd0:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800dd3:	eb 16                	jmp    800deb <vprintfmt+0x1dd>
					putch(padc, putdat);
  800dd5:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800dd9:	83 ec 08             	sub    $0x8,%esp
  800ddc:	ff 75 0c             	pushl  0xc(%ebp)
  800ddf:	50                   	push   %eax
  800de0:	8b 45 08             	mov    0x8(%ebp),%eax
  800de3:	ff d0                	call   *%eax
  800de5:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800de8:	ff 4d e4             	decl   -0x1c(%ebp)
  800deb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800def:	7f e4                	jg     800dd5 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800df1:	eb 34                	jmp    800e27 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800df3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800df7:	74 1c                	je     800e15 <vprintfmt+0x207>
  800df9:	83 fb 1f             	cmp    $0x1f,%ebx
  800dfc:	7e 05                	jle    800e03 <vprintfmt+0x1f5>
  800dfe:	83 fb 7e             	cmp    $0x7e,%ebx
  800e01:	7e 12                	jle    800e15 <vprintfmt+0x207>
					putch('?', putdat);
  800e03:	83 ec 08             	sub    $0x8,%esp
  800e06:	ff 75 0c             	pushl  0xc(%ebp)
  800e09:	6a 3f                	push   $0x3f
  800e0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0e:	ff d0                	call   *%eax
  800e10:	83 c4 10             	add    $0x10,%esp
  800e13:	eb 0f                	jmp    800e24 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800e15:	83 ec 08             	sub    $0x8,%esp
  800e18:	ff 75 0c             	pushl  0xc(%ebp)
  800e1b:	53                   	push   %ebx
  800e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1f:	ff d0                	call   *%eax
  800e21:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e24:	ff 4d e4             	decl   -0x1c(%ebp)
  800e27:	89 f0                	mov    %esi,%eax
  800e29:	8d 70 01             	lea    0x1(%eax),%esi
  800e2c:	8a 00                	mov    (%eax),%al
  800e2e:	0f be d8             	movsbl %al,%ebx
  800e31:	85 db                	test   %ebx,%ebx
  800e33:	74 24                	je     800e59 <vprintfmt+0x24b>
  800e35:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e39:	78 b8                	js     800df3 <vprintfmt+0x1e5>
  800e3b:	ff 4d e0             	decl   -0x20(%ebp)
  800e3e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e42:	79 af                	jns    800df3 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e44:	eb 13                	jmp    800e59 <vprintfmt+0x24b>
				putch(' ', putdat);
  800e46:	83 ec 08             	sub    $0x8,%esp
  800e49:	ff 75 0c             	pushl  0xc(%ebp)
  800e4c:	6a 20                	push   $0x20
  800e4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e51:	ff d0                	call   *%eax
  800e53:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e56:	ff 4d e4             	decl   -0x1c(%ebp)
  800e59:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e5d:	7f e7                	jg     800e46 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800e5f:	e9 66 01 00 00       	jmp    800fca <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800e64:	83 ec 08             	sub    $0x8,%esp
  800e67:	ff 75 e8             	pushl  -0x18(%ebp)
  800e6a:	8d 45 14             	lea    0x14(%ebp),%eax
  800e6d:	50                   	push   %eax
  800e6e:	e8 3c fd ff ff       	call   800baf <getint>
  800e73:	83 c4 10             	add    $0x10,%esp
  800e76:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e79:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800e7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e7f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e82:	85 d2                	test   %edx,%edx
  800e84:	79 23                	jns    800ea9 <vprintfmt+0x29b>
				putch('-', putdat);
  800e86:	83 ec 08             	sub    $0x8,%esp
  800e89:	ff 75 0c             	pushl  0xc(%ebp)
  800e8c:	6a 2d                	push   $0x2d
  800e8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e91:	ff d0                	call   *%eax
  800e93:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800e96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e99:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e9c:	f7 d8                	neg    %eax
  800e9e:	83 d2 00             	adc    $0x0,%edx
  800ea1:	f7 da                	neg    %edx
  800ea3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ea6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800ea9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800eb0:	e9 bc 00 00 00       	jmp    800f71 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800eb5:	83 ec 08             	sub    $0x8,%esp
  800eb8:	ff 75 e8             	pushl  -0x18(%ebp)
  800ebb:	8d 45 14             	lea    0x14(%ebp),%eax
  800ebe:	50                   	push   %eax
  800ebf:	e8 84 fc ff ff       	call   800b48 <getuint>
  800ec4:	83 c4 10             	add    $0x10,%esp
  800ec7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800eca:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800ecd:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ed4:	e9 98 00 00 00       	jmp    800f71 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ed9:	83 ec 08             	sub    $0x8,%esp
  800edc:	ff 75 0c             	pushl  0xc(%ebp)
  800edf:	6a 58                	push   $0x58
  800ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee4:	ff d0                	call   *%eax
  800ee6:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ee9:	83 ec 08             	sub    $0x8,%esp
  800eec:	ff 75 0c             	pushl  0xc(%ebp)
  800eef:	6a 58                	push   $0x58
  800ef1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef4:	ff d0                	call   *%eax
  800ef6:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ef9:	83 ec 08             	sub    $0x8,%esp
  800efc:	ff 75 0c             	pushl  0xc(%ebp)
  800eff:	6a 58                	push   $0x58
  800f01:	8b 45 08             	mov    0x8(%ebp),%eax
  800f04:	ff d0                	call   *%eax
  800f06:	83 c4 10             	add    $0x10,%esp
			break;
  800f09:	e9 bc 00 00 00       	jmp    800fca <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800f0e:	83 ec 08             	sub    $0x8,%esp
  800f11:	ff 75 0c             	pushl  0xc(%ebp)
  800f14:	6a 30                	push   $0x30
  800f16:	8b 45 08             	mov    0x8(%ebp),%eax
  800f19:	ff d0                	call   *%eax
  800f1b:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800f1e:	83 ec 08             	sub    $0x8,%esp
  800f21:	ff 75 0c             	pushl  0xc(%ebp)
  800f24:	6a 78                	push   $0x78
  800f26:	8b 45 08             	mov    0x8(%ebp),%eax
  800f29:	ff d0                	call   *%eax
  800f2b:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800f2e:	8b 45 14             	mov    0x14(%ebp),%eax
  800f31:	83 c0 04             	add    $0x4,%eax
  800f34:	89 45 14             	mov    %eax,0x14(%ebp)
  800f37:	8b 45 14             	mov    0x14(%ebp),%eax
  800f3a:	83 e8 04             	sub    $0x4,%eax
  800f3d:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f42:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800f49:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800f50:	eb 1f                	jmp    800f71 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800f52:	83 ec 08             	sub    $0x8,%esp
  800f55:	ff 75 e8             	pushl  -0x18(%ebp)
  800f58:	8d 45 14             	lea    0x14(%ebp),%eax
  800f5b:	50                   	push   %eax
  800f5c:	e8 e7 fb ff ff       	call   800b48 <getuint>
  800f61:	83 c4 10             	add    $0x10,%esp
  800f64:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f67:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800f6a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f71:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800f75:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f78:	83 ec 04             	sub    $0x4,%esp
  800f7b:	52                   	push   %edx
  800f7c:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f7f:	50                   	push   %eax
  800f80:	ff 75 f4             	pushl  -0xc(%ebp)
  800f83:	ff 75 f0             	pushl  -0x10(%ebp)
  800f86:	ff 75 0c             	pushl  0xc(%ebp)
  800f89:	ff 75 08             	pushl  0x8(%ebp)
  800f8c:	e8 00 fb ff ff       	call   800a91 <printnum>
  800f91:	83 c4 20             	add    $0x20,%esp
			break;
  800f94:	eb 34                	jmp    800fca <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f96:	83 ec 08             	sub    $0x8,%esp
  800f99:	ff 75 0c             	pushl  0xc(%ebp)
  800f9c:	53                   	push   %ebx
  800f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa0:	ff d0                	call   *%eax
  800fa2:	83 c4 10             	add    $0x10,%esp
			break;
  800fa5:	eb 23                	jmp    800fca <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800fa7:	83 ec 08             	sub    $0x8,%esp
  800faa:	ff 75 0c             	pushl  0xc(%ebp)
  800fad:	6a 25                	push   $0x25
  800faf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb2:	ff d0                	call   *%eax
  800fb4:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800fb7:	ff 4d 10             	decl   0x10(%ebp)
  800fba:	eb 03                	jmp    800fbf <vprintfmt+0x3b1>
  800fbc:	ff 4d 10             	decl   0x10(%ebp)
  800fbf:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc2:	48                   	dec    %eax
  800fc3:	8a 00                	mov    (%eax),%al
  800fc5:	3c 25                	cmp    $0x25,%al
  800fc7:	75 f3                	jne    800fbc <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800fc9:	90                   	nop
		}
	}
  800fca:	e9 47 fc ff ff       	jmp    800c16 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800fcf:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800fd0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800fd3:	5b                   	pop    %ebx
  800fd4:	5e                   	pop    %esi
  800fd5:	5d                   	pop    %ebp
  800fd6:	c3                   	ret    

00800fd7 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800fd7:	55                   	push   %ebp
  800fd8:	89 e5                	mov    %esp,%ebp
  800fda:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800fdd:	8d 45 10             	lea    0x10(%ebp),%eax
  800fe0:	83 c0 04             	add    $0x4,%eax
  800fe3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800fe6:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe9:	ff 75 f4             	pushl  -0xc(%ebp)
  800fec:	50                   	push   %eax
  800fed:	ff 75 0c             	pushl  0xc(%ebp)
  800ff0:	ff 75 08             	pushl  0x8(%ebp)
  800ff3:	e8 16 fc ff ff       	call   800c0e <vprintfmt>
  800ff8:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800ffb:	90                   	nop
  800ffc:	c9                   	leave  
  800ffd:	c3                   	ret    

00800ffe <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800ffe:	55                   	push   %ebp
  800fff:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801001:	8b 45 0c             	mov    0xc(%ebp),%eax
  801004:	8b 40 08             	mov    0x8(%eax),%eax
  801007:	8d 50 01             	lea    0x1(%eax),%edx
  80100a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80100d:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801010:	8b 45 0c             	mov    0xc(%ebp),%eax
  801013:	8b 10                	mov    (%eax),%edx
  801015:	8b 45 0c             	mov    0xc(%ebp),%eax
  801018:	8b 40 04             	mov    0x4(%eax),%eax
  80101b:	39 c2                	cmp    %eax,%edx
  80101d:	73 12                	jae    801031 <sprintputch+0x33>
		*b->buf++ = ch;
  80101f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801022:	8b 00                	mov    (%eax),%eax
  801024:	8d 48 01             	lea    0x1(%eax),%ecx
  801027:	8b 55 0c             	mov    0xc(%ebp),%edx
  80102a:	89 0a                	mov    %ecx,(%edx)
  80102c:	8b 55 08             	mov    0x8(%ebp),%edx
  80102f:	88 10                	mov    %dl,(%eax)
}
  801031:	90                   	nop
  801032:	5d                   	pop    %ebp
  801033:	c3                   	ret    

00801034 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801034:	55                   	push   %ebp
  801035:	89 e5                	mov    %esp,%ebp
  801037:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80103a:	8b 45 08             	mov    0x8(%ebp),%eax
  80103d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801040:	8b 45 0c             	mov    0xc(%ebp),%eax
  801043:	8d 50 ff             	lea    -0x1(%eax),%edx
  801046:	8b 45 08             	mov    0x8(%ebp),%eax
  801049:	01 d0                	add    %edx,%eax
  80104b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80104e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801055:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801059:	74 06                	je     801061 <vsnprintf+0x2d>
  80105b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80105f:	7f 07                	jg     801068 <vsnprintf+0x34>
		return -E_INVAL;
  801061:	b8 03 00 00 00       	mov    $0x3,%eax
  801066:	eb 20                	jmp    801088 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801068:	ff 75 14             	pushl  0x14(%ebp)
  80106b:	ff 75 10             	pushl  0x10(%ebp)
  80106e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801071:	50                   	push   %eax
  801072:	68 fe 0f 80 00       	push   $0x800ffe
  801077:	e8 92 fb ff ff       	call   800c0e <vprintfmt>
  80107c:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80107f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801082:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801085:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801088:	c9                   	leave  
  801089:	c3                   	ret    

0080108a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80108a:	55                   	push   %ebp
  80108b:	89 e5                	mov    %esp,%ebp
  80108d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801090:	8d 45 10             	lea    0x10(%ebp),%eax
  801093:	83 c0 04             	add    $0x4,%eax
  801096:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801099:	8b 45 10             	mov    0x10(%ebp),%eax
  80109c:	ff 75 f4             	pushl  -0xc(%ebp)
  80109f:	50                   	push   %eax
  8010a0:	ff 75 0c             	pushl  0xc(%ebp)
  8010a3:	ff 75 08             	pushl  0x8(%ebp)
  8010a6:	e8 89 ff ff ff       	call   801034 <vsnprintf>
  8010ab:	83 c4 10             	add    $0x10,%esp
  8010ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8010b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8010b4:	c9                   	leave  
  8010b5:	c3                   	ret    

008010b6 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  8010b6:	55                   	push   %ebp
  8010b7:	89 e5                	mov    %esp,%ebp
  8010b9:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  8010bc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010c0:	74 13                	je     8010d5 <readline+0x1f>
		cprintf("%s", prompt);
  8010c2:	83 ec 08             	sub    $0x8,%esp
  8010c5:	ff 75 08             	pushl  0x8(%ebp)
  8010c8:	68 f0 43 80 00       	push   $0x8043f0
  8010cd:	e8 62 f9 ff ff       	call   800a34 <cprintf>
  8010d2:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8010d5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8010dc:	83 ec 0c             	sub    $0xc,%esp
  8010df:	6a 00                	push   $0x0
  8010e1:	e8 54 f5 ff ff       	call   80063a <iscons>
  8010e6:	83 c4 10             	add    $0x10,%esp
  8010e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8010ec:	e8 fb f4 ff ff       	call   8005ec <getchar>
  8010f1:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8010f4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8010f8:	79 22                	jns    80111c <readline+0x66>
			if (c != -E_EOF)
  8010fa:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8010fe:	0f 84 ad 00 00 00    	je     8011b1 <readline+0xfb>
				cprintf("read error: %e\n", c);
  801104:	83 ec 08             	sub    $0x8,%esp
  801107:	ff 75 ec             	pushl  -0x14(%ebp)
  80110a:	68 f3 43 80 00       	push   $0x8043f3
  80110f:	e8 20 f9 ff ff       	call   800a34 <cprintf>
  801114:	83 c4 10             	add    $0x10,%esp
			return;
  801117:	e9 95 00 00 00       	jmp    8011b1 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  80111c:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801120:	7e 34                	jle    801156 <readline+0xa0>
  801122:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801129:	7f 2b                	jg     801156 <readline+0xa0>
			if (echoing)
  80112b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80112f:	74 0e                	je     80113f <readline+0x89>
				cputchar(c);
  801131:	83 ec 0c             	sub    $0xc,%esp
  801134:	ff 75 ec             	pushl  -0x14(%ebp)
  801137:	e8 68 f4 ff ff       	call   8005a4 <cputchar>
  80113c:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  80113f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801142:	8d 50 01             	lea    0x1(%eax),%edx
  801145:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801148:	89 c2                	mov    %eax,%edx
  80114a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114d:	01 d0                	add    %edx,%eax
  80114f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801152:	88 10                	mov    %dl,(%eax)
  801154:	eb 56                	jmp    8011ac <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  801156:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80115a:	75 1f                	jne    80117b <readline+0xc5>
  80115c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801160:	7e 19                	jle    80117b <readline+0xc5>
			if (echoing)
  801162:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801166:	74 0e                	je     801176 <readline+0xc0>
				cputchar(c);
  801168:	83 ec 0c             	sub    $0xc,%esp
  80116b:	ff 75 ec             	pushl  -0x14(%ebp)
  80116e:	e8 31 f4 ff ff       	call   8005a4 <cputchar>
  801173:	83 c4 10             	add    $0x10,%esp

			i--;
  801176:	ff 4d f4             	decl   -0xc(%ebp)
  801179:	eb 31                	jmp    8011ac <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  80117b:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  80117f:	74 0a                	je     80118b <readline+0xd5>
  801181:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801185:	0f 85 61 ff ff ff    	jne    8010ec <readline+0x36>
			if (echoing)
  80118b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80118f:	74 0e                	je     80119f <readline+0xe9>
				cputchar(c);
  801191:	83 ec 0c             	sub    $0xc,%esp
  801194:	ff 75 ec             	pushl  -0x14(%ebp)
  801197:	e8 08 f4 ff ff       	call   8005a4 <cputchar>
  80119c:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  80119f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a5:	01 d0                	add    %edx,%eax
  8011a7:	c6 00 00             	movb   $0x0,(%eax)
			return;
  8011aa:	eb 06                	jmp    8011b2 <readline+0xfc>
		}
	}
  8011ac:	e9 3b ff ff ff       	jmp    8010ec <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  8011b1:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  8011b2:	c9                   	leave  
  8011b3:	c3                   	ret    

008011b4 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  8011b4:	55                   	push   %ebp
  8011b5:	89 e5                	mov    %esp,%ebp
  8011b7:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8011ba:	e8 78 0d 00 00       	call   801f37 <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  8011bf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011c3:	74 13                	je     8011d8 <atomic_readline+0x24>
		cprintf("%s", prompt);
  8011c5:	83 ec 08             	sub    $0x8,%esp
  8011c8:	ff 75 08             	pushl  0x8(%ebp)
  8011cb:	68 f0 43 80 00       	push   $0x8043f0
  8011d0:	e8 5f f8 ff ff       	call   800a34 <cprintf>
  8011d5:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8011d8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8011df:	83 ec 0c             	sub    $0xc,%esp
  8011e2:	6a 00                	push   $0x0
  8011e4:	e8 51 f4 ff ff       	call   80063a <iscons>
  8011e9:	83 c4 10             	add    $0x10,%esp
  8011ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8011ef:	e8 f8 f3 ff ff       	call   8005ec <getchar>
  8011f4:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8011f7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8011fb:	79 23                	jns    801220 <atomic_readline+0x6c>
			if (c != -E_EOF)
  8011fd:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801201:	74 13                	je     801216 <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  801203:	83 ec 08             	sub    $0x8,%esp
  801206:	ff 75 ec             	pushl  -0x14(%ebp)
  801209:	68 f3 43 80 00       	push   $0x8043f3
  80120e:	e8 21 f8 ff ff       	call   800a34 <cprintf>
  801213:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  801216:	e8 36 0d 00 00       	call   801f51 <sys_enable_interrupt>
			return;
  80121b:	e9 9a 00 00 00       	jmp    8012ba <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801220:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801224:	7e 34                	jle    80125a <atomic_readline+0xa6>
  801226:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  80122d:	7f 2b                	jg     80125a <atomic_readline+0xa6>
			if (echoing)
  80122f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801233:	74 0e                	je     801243 <atomic_readline+0x8f>
				cputchar(c);
  801235:	83 ec 0c             	sub    $0xc,%esp
  801238:	ff 75 ec             	pushl  -0x14(%ebp)
  80123b:	e8 64 f3 ff ff       	call   8005a4 <cputchar>
  801240:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801243:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801246:	8d 50 01             	lea    0x1(%eax),%edx
  801249:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80124c:	89 c2                	mov    %eax,%edx
  80124e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801251:	01 d0                	add    %edx,%eax
  801253:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801256:	88 10                	mov    %dl,(%eax)
  801258:	eb 5b                	jmp    8012b5 <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  80125a:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80125e:	75 1f                	jne    80127f <atomic_readline+0xcb>
  801260:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801264:	7e 19                	jle    80127f <atomic_readline+0xcb>
			if (echoing)
  801266:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80126a:	74 0e                	je     80127a <atomic_readline+0xc6>
				cputchar(c);
  80126c:	83 ec 0c             	sub    $0xc,%esp
  80126f:	ff 75 ec             	pushl  -0x14(%ebp)
  801272:	e8 2d f3 ff ff       	call   8005a4 <cputchar>
  801277:	83 c4 10             	add    $0x10,%esp
			i--;
  80127a:	ff 4d f4             	decl   -0xc(%ebp)
  80127d:	eb 36                	jmp    8012b5 <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  80127f:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801283:	74 0a                	je     80128f <atomic_readline+0xdb>
  801285:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801289:	0f 85 60 ff ff ff    	jne    8011ef <atomic_readline+0x3b>
			if (echoing)
  80128f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801293:	74 0e                	je     8012a3 <atomic_readline+0xef>
				cputchar(c);
  801295:	83 ec 0c             	sub    $0xc,%esp
  801298:	ff 75 ec             	pushl  -0x14(%ebp)
  80129b:	e8 04 f3 ff ff       	call   8005a4 <cputchar>
  8012a0:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  8012a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a9:	01 d0                	add    %edx,%eax
  8012ab:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  8012ae:	e8 9e 0c 00 00       	call   801f51 <sys_enable_interrupt>
			return;
  8012b3:	eb 05                	jmp    8012ba <atomic_readline+0x106>
		}
	}
  8012b5:	e9 35 ff ff ff       	jmp    8011ef <atomic_readline+0x3b>
}
  8012ba:	c9                   	leave  
  8012bb:	c3                   	ret    

008012bc <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8012bc:	55                   	push   %ebp
  8012bd:	89 e5                	mov    %esp,%ebp
  8012bf:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8012c2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012c9:	eb 06                	jmp    8012d1 <strlen+0x15>
		n++;
  8012cb:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8012ce:	ff 45 08             	incl   0x8(%ebp)
  8012d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d4:	8a 00                	mov    (%eax),%al
  8012d6:	84 c0                	test   %al,%al
  8012d8:	75 f1                	jne    8012cb <strlen+0xf>
		n++;
	return n;
  8012da:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012dd:	c9                   	leave  
  8012de:	c3                   	ret    

008012df <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8012df:	55                   	push   %ebp
  8012e0:	89 e5                	mov    %esp,%ebp
  8012e2:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012e5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012ec:	eb 09                	jmp    8012f7 <strnlen+0x18>
		n++;
  8012ee:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012f1:	ff 45 08             	incl   0x8(%ebp)
  8012f4:	ff 4d 0c             	decl   0xc(%ebp)
  8012f7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012fb:	74 09                	je     801306 <strnlen+0x27>
  8012fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801300:	8a 00                	mov    (%eax),%al
  801302:	84 c0                	test   %al,%al
  801304:	75 e8                	jne    8012ee <strnlen+0xf>
		n++;
	return n;
  801306:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801309:	c9                   	leave  
  80130a:	c3                   	ret    

0080130b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80130b:	55                   	push   %ebp
  80130c:	89 e5                	mov    %esp,%ebp
  80130e:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801311:	8b 45 08             	mov    0x8(%ebp),%eax
  801314:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801317:	90                   	nop
  801318:	8b 45 08             	mov    0x8(%ebp),%eax
  80131b:	8d 50 01             	lea    0x1(%eax),%edx
  80131e:	89 55 08             	mov    %edx,0x8(%ebp)
  801321:	8b 55 0c             	mov    0xc(%ebp),%edx
  801324:	8d 4a 01             	lea    0x1(%edx),%ecx
  801327:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80132a:	8a 12                	mov    (%edx),%dl
  80132c:	88 10                	mov    %dl,(%eax)
  80132e:	8a 00                	mov    (%eax),%al
  801330:	84 c0                	test   %al,%al
  801332:	75 e4                	jne    801318 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801334:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801337:	c9                   	leave  
  801338:	c3                   	ret    

00801339 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801339:	55                   	push   %ebp
  80133a:	89 e5                	mov    %esp,%ebp
  80133c:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80133f:	8b 45 08             	mov    0x8(%ebp),%eax
  801342:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801345:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80134c:	eb 1f                	jmp    80136d <strncpy+0x34>
		*dst++ = *src;
  80134e:	8b 45 08             	mov    0x8(%ebp),%eax
  801351:	8d 50 01             	lea    0x1(%eax),%edx
  801354:	89 55 08             	mov    %edx,0x8(%ebp)
  801357:	8b 55 0c             	mov    0xc(%ebp),%edx
  80135a:	8a 12                	mov    (%edx),%dl
  80135c:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80135e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801361:	8a 00                	mov    (%eax),%al
  801363:	84 c0                	test   %al,%al
  801365:	74 03                	je     80136a <strncpy+0x31>
			src++;
  801367:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80136a:	ff 45 fc             	incl   -0x4(%ebp)
  80136d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801370:	3b 45 10             	cmp    0x10(%ebp),%eax
  801373:	72 d9                	jb     80134e <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801375:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801378:	c9                   	leave  
  801379:	c3                   	ret    

0080137a <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80137a:	55                   	push   %ebp
  80137b:	89 e5                	mov    %esp,%ebp
  80137d:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801380:	8b 45 08             	mov    0x8(%ebp),%eax
  801383:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801386:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80138a:	74 30                	je     8013bc <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80138c:	eb 16                	jmp    8013a4 <strlcpy+0x2a>
			*dst++ = *src++;
  80138e:	8b 45 08             	mov    0x8(%ebp),%eax
  801391:	8d 50 01             	lea    0x1(%eax),%edx
  801394:	89 55 08             	mov    %edx,0x8(%ebp)
  801397:	8b 55 0c             	mov    0xc(%ebp),%edx
  80139a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80139d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8013a0:	8a 12                	mov    (%edx),%dl
  8013a2:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8013a4:	ff 4d 10             	decl   0x10(%ebp)
  8013a7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013ab:	74 09                	je     8013b6 <strlcpy+0x3c>
  8013ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b0:	8a 00                	mov    (%eax),%al
  8013b2:	84 c0                	test   %al,%al
  8013b4:	75 d8                	jne    80138e <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8013b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b9:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8013bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8013bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013c2:	29 c2                	sub    %eax,%edx
  8013c4:	89 d0                	mov    %edx,%eax
}
  8013c6:	c9                   	leave  
  8013c7:	c3                   	ret    

008013c8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8013c8:	55                   	push   %ebp
  8013c9:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8013cb:	eb 06                	jmp    8013d3 <strcmp+0xb>
		p++, q++;
  8013cd:	ff 45 08             	incl   0x8(%ebp)
  8013d0:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8013d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d6:	8a 00                	mov    (%eax),%al
  8013d8:	84 c0                	test   %al,%al
  8013da:	74 0e                	je     8013ea <strcmp+0x22>
  8013dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013df:	8a 10                	mov    (%eax),%dl
  8013e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e4:	8a 00                	mov    (%eax),%al
  8013e6:	38 c2                	cmp    %al,%dl
  8013e8:	74 e3                	je     8013cd <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8013ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ed:	8a 00                	mov    (%eax),%al
  8013ef:	0f b6 d0             	movzbl %al,%edx
  8013f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f5:	8a 00                	mov    (%eax),%al
  8013f7:	0f b6 c0             	movzbl %al,%eax
  8013fa:	29 c2                	sub    %eax,%edx
  8013fc:	89 d0                	mov    %edx,%eax
}
  8013fe:	5d                   	pop    %ebp
  8013ff:	c3                   	ret    

00801400 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801400:	55                   	push   %ebp
  801401:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801403:	eb 09                	jmp    80140e <strncmp+0xe>
		n--, p++, q++;
  801405:	ff 4d 10             	decl   0x10(%ebp)
  801408:	ff 45 08             	incl   0x8(%ebp)
  80140b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80140e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801412:	74 17                	je     80142b <strncmp+0x2b>
  801414:	8b 45 08             	mov    0x8(%ebp),%eax
  801417:	8a 00                	mov    (%eax),%al
  801419:	84 c0                	test   %al,%al
  80141b:	74 0e                	je     80142b <strncmp+0x2b>
  80141d:	8b 45 08             	mov    0x8(%ebp),%eax
  801420:	8a 10                	mov    (%eax),%dl
  801422:	8b 45 0c             	mov    0xc(%ebp),%eax
  801425:	8a 00                	mov    (%eax),%al
  801427:	38 c2                	cmp    %al,%dl
  801429:	74 da                	je     801405 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80142b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80142f:	75 07                	jne    801438 <strncmp+0x38>
		return 0;
  801431:	b8 00 00 00 00       	mov    $0x0,%eax
  801436:	eb 14                	jmp    80144c <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801438:	8b 45 08             	mov    0x8(%ebp),%eax
  80143b:	8a 00                	mov    (%eax),%al
  80143d:	0f b6 d0             	movzbl %al,%edx
  801440:	8b 45 0c             	mov    0xc(%ebp),%eax
  801443:	8a 00                	mov    (%eax),%al
  801445:	0f b6 c0             	movzbl %al,%eax
  801448:	29 c2                	sub    %eax,%edx
  80144a:	89 d0                	mov    %edx,%eax
}
  80144c:	5d                   	pop    %ebp
  80144d:	c3                   	ret    

0080144e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80144e:	55                   	push   %ebp
  80144f:	89 e5                	mov    %esp,%ebp
  801451:	83 ec 04             	sub    $0x4,%esp
  801454:	8b 45 0c             	mov    0xc(%ebp),%eax
  801457:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80145a:	eb 12                	jmp    80146e <strchr+0x20>
		if (*s == c)
  80145c:	8b 45 08             	mov    0x8(%ebp),%eax
  80145f:	8a 00                	mov    (%eax),%al
  801461:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801464:	75 05                	jne    80146b <strchr+0x1d>
			return (char *) s;
  801466:	8b 45 08             	mov    0x8(%ebp),%eax
  801469:	eb 11                	jmp    80147c <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80146b:	ff 45 08             	incl   0x8(%ebp)
  80146e:	8b 45 08             	mov    0x8(%ebp),%eax
  801471:	8a 00                	mov    (%eax),%al
  801473:	84 c0                	test   %al,%al
  801475:	75 e5                	jne    80145c <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801477:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80147c:	c9                   	leave  
  80147d:	c3                   	ret    

0080147e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80147e:	55                   	push   %ebp
  80147f:	89 e5                	mov    %esp,%ebp
  801481:	83 ec 04             	sub    $0x4,%esp
  801484:	8b 45 0c             	mov    0xc(%ebp),%eax
  801487:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80148a:	eb 0d                	jmp    801499 <strfind+0x1b>
		if (*s == c)
  80148c:	8b 45 08             	mov    0x8(%ebp),%eax
  80148f:	8a 00                	mov    (%eax),%al
  801491:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801494:	74 0e                	je     8014a4 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801496:	ff 45 08             	incl   0x8(%ebp)
  801499:	8b 45 08             	mov    0x8(%ebp),%eax
  80149c:	8a 00                	mov    (%eax),%al
  80149e:	84 c0                	test   %al,%al
  8014a0:	75 ea                	jne    80148c <strfind+0xe>
  8014a2:	eb 01                	jmp    8014a5 <strfind+0x27>
		if (*s == c)
			break;
  8014a4:	90                   	nop
	return (char *) s;
  8014a5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014a8:	c9                   	leave  
  8014a9:	c3                   	ret    

008014aa <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8014aa:	55                   	push   %ebp
  8014ab:	89 e5                	mov    %esp,%ebp
  8014ad:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8014b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8014b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8014b9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8014bc:	eb 0e                	jmp    8014cc <memset+0x22>
		*p++ = c;
  8014be:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014c1:	8d 50 01             	lea    0x1(%eax),%edx
  8014c4:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ca:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8014cc:	ff 4d f8             	decl   -0x8(%ebp)
  8014cf:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8014d3:	79 e9                	jns    8014be <memset+0x14>
		*p++ = c;

	return v;
  8014d5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014d8:	c9                   	leave  
  8014d9:	c3                   	ret    

008014da <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8014da:	55                   	push   %ebp
  8014db:	89 e5                	mov    %esp,%ebp
  8014dd:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8014e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8014e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8014ec:	eb 16                	jmp    801504 <memcpy+0x2a>
		*d++ = *s++;
  8014ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014f1:	8d 50 01             	lea    0x1(%eax),%edx
  8014f4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8014f7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014fa:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014fd:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801500:	8a 12                	mov    (%edx),%dl
  801502:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801504:	8b 45 10             	mov    0x10(%ebp),%eax
  801507:	8d 50 ff             	lea    -0x1(%eax),%edx
  80150a:	89 55 10             	mov    %edx,0x10(%ebp)
  80150d:	85 c0                	test   %eax,%eax
  80150f:	75 dd                	jne    8014ee <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801511:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801514:	c9                   	leave  
  801515:	c3                   	ret    

00801516 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801516:	55                   	push   %ebp
  801517:	89 e5                	mov    %esp,%ebp
  801519:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80151c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80151f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801522:	8b 45 08             	mov    0x8(%ebp),%eax
  801525:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801528:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80152b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80152e:	73 50                	jae    801580 <memmove+0x6a>
  801530:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801533:	8b 45 10             	mov    0x10(%ebp),%eax
  801536:	01 d0                	add    %edx,%eax
  801538:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80153b:	76 43                	jbe    801580 <memmove+0x6a>
		s += n;
  80153d:	8b 45 10             	mov    0x10(%ebp),%eax
  801540:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801543:	8b 45 10             	mov    0x10(%ebp),%eax
  801546:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801549:	eb 10                	jmp    80155b <memmove+0x45>
			*--d = *--s;
  80154b:	ff 4d f8             	decl   -0x8(%ebp)
  80154e:	ff 4d fc             	decl   -0x4(%ebp)
  801551:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801554:	8a 10                	mov    (%eax),%dl
  801556:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801559:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80155b:	8b 45 10             	mov    0x10(%ebp),%eax
  80155e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801561:	89 55 10             	mov    %edx,0x10(%ebp)
  801564:	85 c0                	test   %eax,%eax
  801566:	75 e3                	jne    80154b <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801568:	eb 23                	jmp    80158d <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80156a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80156d:	8d 50 01             	lea    0x1(%eax),%edx
  801570:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801573:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801576:	8d 4a 01             	lea    0x1(%edx),%ecx
  801579:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80157c:	8a 12                	mov    (%edx),%dl
  80157e:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801580:	8b 45 10             	mov    0x10(%ebp),%eax
  801583:	8d 50 ff             	lea    -0x1(%eax),%edx
  801586:	89 55 10             	mov    %edx,0x10(%ebp)
  801589:	85 c0                	test   %eax,%eax
  80158b:	75 dd                	jne    80156a <memmove+0x54>
			*d++ = *s++;

	return dst;
  80158d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801590:	c9                   	leave  
  801591:	c3                   	ret    

00801592 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801592:	55                   	push   %ebp
  801593:	89 e5                	mov    %esp,%ebp
  801595:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801598:	8b 45 08             	mov    0x8(%ebp),%eax
  80159b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80159e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a1:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8015a4:	eb 2a                	jmp    8015d0 <memcmp+0x3e>
		if (*s1 != *s2)
  8015a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015a9:	8a 10                	mov    (%eax),%dl
  8015ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015ae:	8a 00                	mov    (%eax),%al
  8015b0:	38 c2                	cmp    %al,%dl
  8015b2:	74 16                	je     8015ca <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8015b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015b7:	8a 00                	mov    (%eax),%al
  8015b9:	0f b6 d0             	movzbl %al,%edx
  8015bc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015bf:	8a 00                	mov    (%eax),%al
  8015c1:	0f b6 c0             	movzbl %al,%eax
  8015c4:	29 c2                	sub    %eax,%edx
  8015c6:	89 d0                	mov    %edx,%eax
  8015c8:	eb 18                	jmp    8015e2 <memcmp+0x50>
		s1++, s2++;
  8015ca:	ff 45 fc             	incl   -0x4(%ebp)
  8015cd:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8015d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8015d3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015d6:	89 55 10             	mov    %edx,0x10(%ebp)
  8015d9:	85 c0                	test   %eax,%eax
  8015db:	75 c9                	jne    8015a6 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8015dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015e2:	c9                   	leave  
  8015e3:	c3                   	ret    

008015e4 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8015e4:	55                   	push   %ebp
  8015e5:	89 e5                	mov    %esp,%ebp
  8015e7:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8015ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8015ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8015f0:	01 d0                	add    %edx,%eax
  8015f2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8015f5:	eb 15                	jmp    80160c <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8015f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fa:	8a 00                	mov    (%eax),%al
  8015fc:	0f b6 d0             	movzbl %al,%edx
  8015ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801602:	0f b6 c0             	movzbl %al,%eax
  801605:	39 c2                	cmp    %eax,%edx
  801607:	74 0d                	je     801616 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801609:	ff 45 08             	incl   0x8(%ebp)
  80160c:	8b 45 08             	mov    0x8(%ebp),%eax
  80160f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801612:	72 e3                	jb     8015f7 <memfind+0x13>
  801614:	eb 01                	jmp    801617 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801616:	90                   	nop
	return (void *) s;
  801617:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80161a:	c9                   	leave  
  80161b:	c3                   	ret    

0080161c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80161c:	55                   	push   %ebp
  80161d:	89 e5                	mov    %esp,%ebp
  80161f:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801622:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801629:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801630:	eb 03                	jmp    801635 <strtol+0x19>
		s++;
  801632:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801635:	8b 45 08             	mov    0x8(%ebp),%eax
  801638:	8a 00                	mov    (%eax),%al
  80163a:	3c 20                	cmp    $0x20,%al
  80163c:	74 f4                	je     801632 <strtol+0x16>
  80163e:	8b 45 08             	mov    0x8(%ebp),%eax
  801641:	8a 00                	mov    (%eax),%al
  801643:	3c 09                	cmp    $0x9,%al
  801645:	74 eb                	je     801632 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801647:	8b 45 08             	mov    0x8(%ebp),%eax
  80164a:	8a 00                	mov    (%eax),%al
  80164c:	3c 2b                	cmp    $0x2b,%al
  80164e:	75 05                	jne    801655 <strtol+0x39>
		s++;
  801650:	ff 45 08             	incl   0x8(%ebp)
  801653:	eb 13                	jmp    801668 <strtol+0x4c>
	else if (*s == '-')
  801655:	8b 45 08             	mov    0x8(%ebp),%eax
  801658:	8a 00                	mov    (%eax),%al
  80165a:	3c 2d                	cmp    $0x2d,%al
  80165c:	75 0a                	jne    801668 <strtol+0x4c>
		s++, neg = 1;
  80165e:	ff 45 08             	incl   0x8(%ebp)
  801661:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801668:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80166c:	74 06                	je     801674 <strtol+0x58>
  80166e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801672:	75 20                	jne    801694 <strtol+0x78>
  801674:	8b 45 08             	mov    0x8(%ebp),%eax
  801677:	8a 00                	mov    (%eax),%al
  801679:	3c 30                	cmp    $0x30,%al
  80167b:	75 17                	jne    801694 <strtol+0x78>
  80167d:	8b 45 08             	mov    0x8(%ebp),%eax
  801680:	40                   	inc    %eax
  801681:	8a 00                	mov    (%eax),%al
  801683:	3c 78                	cmp    $0x78,%al
  801685:	75 0d                	jne    801694 <strtol+0x78>
		s += 2, base = 16;
  801687:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80168b:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801692:	eb 28                	jmp    8016bc <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801694:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801698:	75 15                	jne    8016af <strtol+0x93>
  80169a:	8b 45 08             	mov    0x8(%ebp),%eax
  80169d:	8a 00                	mov    (%eax),%al
  80169f:	3c 30                	cmp    $0x30,%al
  8016a1:	75 0c                	jne    8016af <strtol+0x93>
		s++, base = 8;
  8016a3:	ff 45 08             	incl   0x8(%ebp)
  8016a6:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8016ad:	eb 0d                	jmp    8016bc <strtol+0xa0>
	else if (base == 0)
  8016af:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016b3:	75 07                	jne    8016bc <strtol+0xa0>
		base = 10;
  8016b5:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8016bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bf:	8a 00                	mov    (%eax),%al
  8016c1:	3c 2f                	cmp    $0x2f,%al
  8016c3:	7e 19                	jle    8016de <strtol+0xc2>
  8016c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c8:	8a 00                	mov    (%eax),%al
  8016ca:	3c 39                	cmp    $0x39,%al
  8016cc:	7f 10                	jg     8016de <strtol+0xc2>
			dig = *s - '0';
  8016ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d1:	8a 00                	mov    (%eax),%al
  8016d3:	0f be c0             	movsbl %al,%eax
  8016d6:	83 e8 30             	sub    $0x30,%eax
  8016d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016dc:	eb 42                	jmp    801720 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8016de:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e1:	8a 00                	mov    (%eax),%al
  8016e3:	3c 60                	cmp    $0x60,%al
  8016e5:	7e 19                	jle    801700 <strtol+0xe4>
  8016e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ea:	8a 00                	mov    (%eax),%al
  8016ec:	3c 7a                	cmp    $0x7a,%al
  8016ee:	7f 10                	jg     801700 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8016f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f3:	8a 00                	mov    (%eax),%al
  8016f5:	0f be c0             	movsbl %al,%eax
  8016f8:	83 e8 57             	sub    $0x57,%eax
  8016fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016fe:	eb 20                	jmp    801720 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801700:	8b 45 08             	mov    0x8(%ebp),%eax
  801703:	8a 00                	mov    (%eax),%al
  801705:	3c 40                	cmp    $0x40,%al
  801707:	7e 39                	jle    801742 <strtol+0x126>
  801709:	8b 45 08             	mov    0x8(%ebp),%eax
  80170c:	8a 00                	mov    (%eax),%al
  80170e:	3c 5a                	cmp    $0x5a,%al
  801710:	7f 30                	jg     801742 <strtol+0x126>
			dig = *s - 'A' + 10;
  801712:	8b 45 08             	mov    0x8(%ebp),%eax
  801715:	8a 00                	mov    (%eax),%al
  801717:	0f be c0             	movsbl %al,%eax
  80171a:	83 e8 37             	sub    $0x37,%eax
  80171d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801720:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801723:	3b 45 10             	cmp    0x10(%ebp),%eax
  801726:	7d 19                	jge    801741 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801728:	ff 45 08             	incl   0x8(%ebp)
  80172b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80172e:	0f af 45 10          	imul   0x10(%ebp),%eax
  801732:	89 c2                	mov    %eax,%edx
  801734:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801737:	01 d0                	add    %edx,%eax
  801739:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80173c:	e9 7b ff ff ff       	jmp    8016bc <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801741:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801742:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801746:	74 08                	je     801750 <strtol+0x134>
		*endptr = (char *) s;
  801748:	8b 45 0c             	mov    0xc(%ebp),%eax
  80174b:	8b 55 08             	mov    0x8(%ebp),%edx
  80174e:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801750:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801754:	74 07                	je     80175d <strtol+0x141>
  801756:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801759:	f7 d8                	neg    %eax
  80175b:	eb 03                	jmp    801760 <strtol+0x144>
  80175d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801760:	c9                   	leave  
  801761:	c3                   	ret    

00801762 <ltostr>:

void
ltostr(long value, char *str)
{
  801762:	55                   	push   %ebp
  801763:	89 e5                	mov    %esp,%ebp
  801765:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801768:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80176f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801776:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80177a:	79 13                	jns    80178f <ltostr+0x2d>
	{
		neg = 1;
  80177c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801783:	8b 45 0c             	mov    0xc(%ebp),%eax
  801786:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801789:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80178c:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80178f:	8b 45 08             	mov    0x8(%ebp),%eax
  801792:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801797:	99                   	cltd   
  801798:	f7 f9                	idiv   %ecx
  80179a:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80179d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017a0:	8d 50 01             	lea    0x1(%eax),%edx
  8017a3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8017a6:	89 c2                	mov    %eax,%edx
  8017a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ab:	01 d0                	add    %edx,%eax
  8017ad:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8017b0:	83 c2 30             	add    $0x30,%edx
  8017b3:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8017b5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017b8:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8017bd:	f7 e9                	imul   %ecx
  8017bf:	c1 fa 02             	sar    $0x2,%edx
  8017c2:	89 c8                	mov    %ecx,%eax
  8017c4:	c1 f8 1f             	sar    $0x1f,%eax
  8017c7:	29 c2                	sub    %eax,%edx
  8017c9:	89 d0                	mov    %edx,%eax
  8017cb:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8017ce:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017d1:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8017d6:	f7 e9                	imul   %ecx
  8017d8:	c1 fa 02             	sar    $0x2,%edx
  8017db:	89 c8                	mov    %ecx,%eax
  8017dd:	c1 f8 1f             	sar    $0x1f,%eax
  8017e0:	29 c2                	sub    %eax,%edx
  8017e2:	89 d0                	mov    %edx,%eax
  8017e4:	c1 e0 02             	shl    $0x2,%eax
  8017e7:	01 d0                	add    %edx,%eax
  8017e9:	01 c0                	add    %eax,%eax
  8017eb:	29 c1                	sub    %eax,%ecx
  8017ed:	89 ca                	mov    %ecx,%edx
  8017ef:	85 d2                	test   %edx,%edx
  8017f1:	75 9c                	jne    80178f <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8017f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8017fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017fd:	48                   	dec    %eax
  8017fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801801:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801805:	74 3d                	je     801844 <ltostr+0xe2>
		start = 1 ;
  801807:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80180e:	eb 34                	jmp    801844 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801810:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801813:	8b 45 0c             	mov    0xc(%ebp),%eax
  801816:	01 d0                	add    %edx,%eax
  801818:	8a 00                	mov    (%eax),%al
  80181a:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80181d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801820:	8b 45 0c             	mov    0xc(%ebp),%eax
  801823:	01 c2                	add    %eax,%edx
  801825:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801828:	8b 45 0c             	mov    0xc(%ebp),%eax
  80182b:	01 c8                	add    %ecx,%eax
  80182d:	8a 00                	mov    (%eax),%al
  80182f:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801831:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801834:	8b 45 0c             	mov    0xc(%ebp),%eax
  801837:	01 c2                	add    %eax,%edx
  801839:	8a 45 eb             	mov    -0x15(%ebp),%al
  80183c:	88 02                	mov    %al,(%edx)
		start++ ;
  80183e:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801841:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801844:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801847:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80184a:	7c c4                	jl     801810 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80184c:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80184f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801852:	01 d0                	add    %edx,%eax
  801854:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801857:	90                   	nop
  801858:	c9                   	leave  
  801859:	c3                   	ret    

0080185a <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80185a:	55                   	push   %ebp
  80185b:	89 e5                	mov    %esp,%ebp
  80185d:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801860:	ff 75 08             	pushl  0x8(%ebp)
  801863:	e8 54 fa ff ff       	call   8012bc <strlen>
  801868:	83 c4 04             	add    $0x4,%esp
  80186b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80186e:	ff 75 0c             	pushl  0xc(%ebp)
  801871:	e8 46 fa ff ff       	call   8012bc <strlen>
  801876:	83 c4 04             	add    $0x4,%esp
  801879:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80187c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801883:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80188a:	eb 17                	jmp    8018a3 <strcconcat+0x49>
		final[s] = str1[s] ;
  80188c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80188f:	8b 45 10             	mov    0x10(%ebp),%eax
  801892:	01 c2                	add    %eax,%edx
  801894:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801897:	8b 45 08             	mov    0x8(%ebp),%eax
  80189a:	01 c8                	add    %ecx,%eax
  80189c:	8a 00                	mov    (%eax),%al
  80189e:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8018a0:	ff 45 fc             	incl   -0x4(%ebp)
  8018a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018a6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8018a9:	7c e1                	jl     80188c <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8018ab:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8018b2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8018b9:	eb 1f                	jmp    8018da <strcconcat+0x80>
		final[s++] = str2[i] ;
  8018bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018be:	8d 50 01             	lea    0x1(%eax),%edx
  8018c1:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8018c4:	89 c2                	mov    %eax,%edx
  8018c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8018c9:	01 c2                	add    %eax,%edx
  8018cb:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8018ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018d1:	01 c8                	add    %ecx,%eax
  8018d3:	8a 00                	mov    (%eax),%al
  8018d5:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8018d7:	ff 45 f8             	incl   -0x8(%ebp)
  8018da:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018dd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8018e0:	7c d9                	jl     8018bb <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8018e2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8018e8:	01 d0                	add    %edx,%eax
  8018ea:	c6 00 00             	movb   $0x0,(%eax)
}
  8018ed:	90                   	nop
  8018ee:	c9                   	leave  
  8018ef:	c3                   	ret    

008018f0 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8018f0:	55                   	push   %ebp
  8018f1:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8018f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8018f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8018fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8018ff:	8b 00                	mov    (%eax),%eax
  801901:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801908:	8b 45 10             	mov    0x10(%ebp),%eax
  80190b:	01 d0                	add    %edx,%eax
  80190d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801913:	eb 0c                	jmp    801921 <strsplit+0x31>
			*string++ = 0;
  801915:	8b 45 08             	mov    0x8(%ebp),%eax
  801918:	8d 50 01             	lea    0x1(%eax),%edx
  80191b:	89 55 08             	mov    %edx,0x8(%ebp)
  80191e:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801921:	8b 45 08             	mov    0x8(%ebp),%eax
  801924:	8a 00                	mov    (%eax),%al
  801926:	84 c0                	test   %al,%al
  801928:	74 18                	je     801942 <strsplit+0x52>
  80192a:	8b 45 08             	mov    0x8(%ebp),%eax
  80192d:	8a 00                	mov    (%eax),%al
  80192f:	0f be c0             	movsbl %al,%eax
  801932:	50                   	push   %eax
  801933:	ff 75 0c             	pushl  0xc(%ebp)
  801936:	e8 13 fb ff ff       	call   80144e <strchr>
  80193b:	83 c4 08             	add    $0x8,%esp
  80193e:	85 c0                	test   %eax,%eax
  801940:	75 d3                	jne    801915 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801942:	8b 45 08             	mov    0x8(%ebp),%eax
  801945:	8a 00                	mov    (%eax),%al
  801947:	84 c0                	test   %al,%al
  801949:	74 5a                	je     8019a5 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80194b:	8b 45 14             	mov    0x14(%ebp),%eax
  80194e:	8b 00                	mov    (%eax),%eax
  801950:	83 f8 0f             	cmp    $0xf,%eax
  801953:	75 07                	jne    80195c <strsplit+0x6c>
		{
			return 0;
  801955:	b8 00 00 00 00       	mov    $0x0,%eax
  80195a:	eb 66                	jmp    8019c2 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80195c:	8b 45 14             	mov    0x14(%ebp),%eax
  80195f:	8b 00                	mov    (%eax),%eax
  801961:	8d 48 01             	lea    0x1(%eax),%ecx
  801964:	8b 55 14             	mov    0x14(%ebp),%edx
  801967:	89 0a                	mov    %ecx,(%edx)
  801969:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801970:	8b 45 10             	mov    0x10(%ebp),%eax
  801973:	01 c2                	add    %eax,%edx
  801975:	8b 45 08             	mov    0x8(%ebp),%eax
  801978:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80197a:	eb 03                	jmp    80197f <strsplit+0x8f>
			string++;
  80197c:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80197f:	8b 45 08             	mov    0x8(%ebp),%eax
  801982:	8a 00                	mov    (%eax),%al
  801984:	84 c0                	test   %al,%al
  801986:	74 8b                	je     801913 <strsplit+0x23>
  801988:	8b 45 08             	mov    0x8(%ebp),%eax
  80198b:	8a 00                	mov    (%eax),%al
  80198d:	0f be c0             	movsbl %al,%eax
  801990:	50                   	push   %eax
  801991:	ff 75 0c             	pushl  0xc(%ebp)
  801994:	e8 b5 fa ff ff       	call   80144e <strchr>
  801999:	83 c4 08             	add    $0x8,%esp
  80199c:	85 c0                	test   %eax,%eax
  80199e:	74 dc                	je     80197c <strsplit+0x8c>
			string++;
	}
  8019a0:	e9 6e ff ff ff       	jmp    801913 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8019a5:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8019a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8019a9:	8b 00                	mov    (%eax),%eax
  8019ab:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8019b5:	01 d0                	add    %edx,%eax
  8019b7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8019bd:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8019c2:	c9                   	leave  
  8019c3:	c3                   	ret    

008019c4 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8019c4:	55                   	push   %ebp
  8019c5:	89 e5                	mov    %esp,%ebp
  8019c7:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8019ca:	a1 04 50 80 00       	mov    0x805004,%eax
  8019cf:	85 c0                	test   %eax,%eax
  8019d1:	74 1f                	je     8019f2 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8019d3:	e8 1d 00 00 00       	call   8019f5 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8019d8:	83 ec 0c             	sub    $0xc,%esp
  8019db:	68 04 44 80 00       	push   $0x804404
  8019e0:	e8 4f f0 ff ff       	call   800a34 <cprintf>
  8019e5:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8019e8:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  8019ef:	00 00 00 
	}
}
  8019f2:	90                   	nop
  8019f3:	c9                   	leave  
  8019f4:	c3                   	ret    

008019f5 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8019f5:	55                   	push   %ebp
  8019f6:	89 e5                	mov    %esp,%ebp
  8019f8:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	LIST_INIT(&AllocMemBlocksList);
  8019fb:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801a02:	00 00 00 
  801a05:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801a0c:	00 00 00 
  801a0f:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801a16:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801a19:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801a20:	00 00 00 
  801a23:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801a2a:	00 00 00 
  801a2d:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801a34:	00 00 00 
	uint32 arr_size = 0;
  801a37:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	MemBlockNodes  =(struct MemBlock*) USER_DYN_BLKS_ARRAY;
  801a3e:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801a45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a48:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801a4d:	2d 00 10 00 00       	sub    $0x1000,%eax
  801a52:	a3 50 50 80 00       	mov    %eax,0x805050
	MAX_MEM_BLOCK_CNT = (USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE;
  801a57:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801a5e:	00 02 00 
	arr_size =  ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock), PAGE_SIZE);
  801a61:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801a68:	a1 20 51 80 00       	mov    0x805120,%eax
  801a6d:	c1 e0 04             	shl    $0x4,%eax
  801a70:	89 c2                	mov    %eax,%edx
  801a72:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a75:	01 d0                	add    %edx,%eax
  801a77:	48                   	dec    %eax
  801a78:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801a7b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a7e:	ba 00 00 00 00       	mov    $0x0,%edx
  801a83:	f7 75 ec             	divl   -0x14(%ebp)
  801a86:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a89:	29 d0                	sub    %edx,%eax
  801a8b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_USER);
  801a8e:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801a95:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a98:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801a9d:	2d 00 10 00 00       	sub    $0x1000,%eax
  801aa2:	83 ec 04             	sub    $0x4,%esp
  801aa5:	6a 06                	push   $0x6
  801aa7:	ff 75 f4             	pushl  -0xc(%ebp)
  801aaa:	50                   	push   %eax
  801aab:	e8 1d 04 00 00       	call   801ecd <sys_allocate_chunk>
  801ab0:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801ab3:	a1 20 51 80 00       	mov    0x805120,%eax
  801ab8:	83 ec 0c             	sub    $0xc,%esp
  801abb:	50                   	push   %eax
  801abc:	e8 92 0a 00 00       	call   802553 <initialize_MemBlocksList>
  801ac1:	83 c4 10             	add    $0x10,%esp
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	struct MemBlock * NewBlock = LIST_FIRST(&AvailableMemBlocksList);
  801ac4:	a1 48 51 80 00       	mov    0x805148,%eax
  801ac9:	89 45 e0             	mov    %eax,-0x20(%ebp)
	NewBlock->sva = USER_HEAP_START;
  801acc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801acf:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	NewBlock->size = (USER_HEAP_MAX-USER_HEAP_START);
  801ad6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ad9:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	LIST_REMOVE(&AvailableMemBlocksList,NewBlock);
  801ae0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801ae4:	75 14                	jne    801afa <initialize_dyn_block_system+0x105>
  801ae6:	83 ec 04             	sub    $0x4,%esp
  801ae9:	68 29 44 80 00       	push   $0x804429
  801aee:	6a 33                	push   $0x33
  801af0:	68 47 44 80 00       	push   $0x804447
  801af5:	e8 86 ec ff ff       	call   800780 <_panic>
  801afa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801afd:	8b 00                	mov    (%eax),%eax
  801aff:	85 c0                	test   %eax,%eax
  801b01:	74 10                	je     801b13 <initialize_dyn_block_system+0x11e>
  801b03:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b06:	8b 00                	mov    (%eax),%eax
  801b08:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b0b:	8b 52 04             	mov    0x4(%edx),%edx
  801b0e:	89 50 04             	mov    %edx,0x4(%eax)
  801b11:	eb 0b                	jmp    801b1e <initialize_dyn_block_system+0x129>
  801b13:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b16:	8b 40 04             	mov    0x4(%eax),%eax
  801b19:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801b1e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b21:	8b 40 04             	mov    0x4(%eax),%eax
  801b24:	85 c0                	test   %eax,%eax
  801b26:	74 0f                	je     801b37 <initialize_dyn_block_system+0x142>
  801b28:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b2b:	8b 40 04             	mov    0x4(%eax),%eax
  801b2e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b31:	8b 12                	mov    (%edx),%edx
  801b33:	89 10                	mov    %edx,(%eax)
  801b35:	eb 0a                	jmp    801b41 <initialize_dyn_block_system+0x14c>
  801b37:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b3a:	8b 00                	mov    (%eax),%eax
  801b3c:	a3 48 51 80 00       	mov    %eax,0x805148
  801b41:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b44:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801b4a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b4d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801b54:	a1 54 51 80 00       	mov    0x805154,%eax
  801b59:	48                   	dec    %eax
  801b5a:	a3 54 51 80 00       	mov    %eax,0x805154
	LIST_INSERT_HEAD(&FreeMemBlocksList, NewBlock);
  801b5f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801b63:	75 14                	jne    801b79 <initialize_dyn_block_system+0x184>
  801b65:	83 ec 04             	sub    $0x4,%esp
  801b68:	68 54 44 80 00       	push   $0x804454
  801b6d:	6a 34                	push   $0x34
  801b6f:	68 47 44 80 00       	push   $0x804447
  801b74:	e8 07 ec ff ff       	call   800780 <_panic>
  801b79:	8b 15 38 51 80 00    	mov    0x805138,%edx
  801b7f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b82:	89 10                	mov    %edx,(%eax)
  801b84:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b87:	8b 00                	mov    (%eax),%eax
  801b89:	85 c0                	test   %eax,%eax
  801b8b:	74 0d                	je     801b9a <initialize_dyn_block_system+0x1a5>
  801b8d:	a1 38 51 80 00       	mov    0x805138,%eax
  801b92:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b95:	89 50 04             	mov    %edx,0x4(%eax)
  801b98:	eb 08                	jmp    801ba2 <initialize_dyn_block_system+0x1ad>
  801b9a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b9d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  801ba2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ba5:	a3 38 51 80 00       	mov    %eax,0x805138
  801baa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bad:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801bb4:	a1 44 51 80 00       	mov    0x805144,%eax
  801bb9:	40                   	inc    %eax
  801bba:	a3 44 51 80 00       	mov    %eax,0x805144
}
  801bbf:	90                   	nop
  801bc0:	c9                   	leave  
  801bc1:	c3                   	ret    

00801bc2 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801bc2:	55                   	push   %ebp
  801bc3:	89 e5                	mov    %esp,%ebp
  801bc5:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801bc8:	e8 f7 fd ff ff       	call   8019c4 <InitializeUHeap>
	if (size == 0) return NULL ;
  801bcd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801bd1:	75 07                	jne    801bda <malloc+0x18>
  801bd3:	b8 00 00 00 00       	mov    $0x0,%eax
  801bd8:	eb 14                	jmp    801bee <malloc+0x2c>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801bda:	83 ec 04             	sub    $0x4,%esp
  801bdd:	68 78 44 80 00       	push   $0x804478
  801be2:	6a 46                	push   $0x46
  801be4:	68 47 44 80 00       	push   $0x804447
  801be9:	e8 92 eb ff ff       	call   800780 <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801bee:	c9                   	leave  
  801bef:	c3                   	ret    

00801bf0 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801bf0:	55                   	push   %ebp
  801bf1:	89 e5                	mov    %esp,%ebp
  801bf3:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801bf6:	83 ec 04             	sub    $0x4,%esp
  801bf9:	68 a0 44 80 00       	push   $0x8044a0
  801bfe:	6a 61                	push   $0x61
  801c00:	68 47 44 80 00       	push   $0x804447
  801c05:	e8 76 eb ff ff       	call   800780 <_panic>

00801c0a <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801c0a:	55                   	push   %ebp
  801c0b:	89 e5                	mov    %esp,%ebp
  801c0d:	83 ec 38             	sub    $0x38,%esp
  801c10:	8b 45 10             	mov    0x10(%ebp),%eax
  801c13:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801c16:	e8 a9 fd ff ff       	call   8019c4 <InitializeUHeap>
	if (size == 0) return NULL ;
  801c1b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801c1f:	75 07                	jne    801c28 <smalloc+0x1e>
  801c21:	b8 00 00 00 00       	mov    $0x0,%eax
  801c26:	eb 7c                	jmp    801ca4 <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801c28:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801c2f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c35:	01 d0                	add    %edx,%eax
  801c37:	48                   	dec    %eax
  801c38:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801c3b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c3e:	ba 00 00 00 00       	mov    $0x0,%edx
  801c43:	f7 75 f0             	divl   -0x10(%ebp)
  801c46:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c49:	29 d0                	sub    %edx,%eax
  801c4b:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801c4e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801c55:	e8 41 06 00 00       	call   80229b <sys_isUHeapPlacementStrategyFIRSTFIT>
  801c5a:	85 c0                	test   %eax,%eax
  801c5c:	74 11                	je     801c6f <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  801c5e:	83 ec 0c             	sub    $0xc,%esp
  801c61:	ff 75 e8             	pushl  -0x18(%ebp)
  801c64:	e8 ac 0c 00 00       	call   802915 <alloc_block_FF>
  801c69:	83 c4 10             	add    $0x10,%esp
  801c6c:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  801c6f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c73:	74 2a                	je     801c9f <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801c75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c78:	8b 40 08             	mov    0x8(%eax),%eax
  801c7b:	89 c2                	mov    %eax,%edx
  801c7d:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801c81:	52                   	push   %edx
  801c82:	50                   	push   %eax
  801c83:	ff 75 0c             	pushl  0xc(%ebp)
  801c86:	ff 75 08             	pushl  0x8(%ebp)
  801c89:	e8 92 03 00 00       	call   802020 <sys_createSharedObject>
  801c8e:	83 c4 10             	add    $0x10,%esp
  801c91:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  801c94:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  801c98:	74 05                	je     801c9f <smalloc+0x95>
			return (void*)virtual_address;
  801c9a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c9d:	eb 05                	jmp    801ca4 <smalloc+0x9a>
	}
	return NULL;
  801c9f:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801ca4:	c9                   	leave  
  801ca5:	c3                   	ret    

00801ca6 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801ca6:	55                   	push   %ebp
  801ca7:	89 e5                	mov    %esp,%ebp
  801ca9:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801cac:	e8 13 fd ff ff       	call   8019c4 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801cb1:	83 ec 04             	sub    $0x4,%esp
  801cb4:	68 c4 44 80 00       	push   $0x8044c4
  801cb9:	68 a2 00 00 00       	push   $0xa2
  801cbe:	68 47 44 80 00       	push   $0x804447
  801cc3:	e8 b8 ea ff ff       	call   800780 <_panic>

00801cc8 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801cc8:	55                   	push   %ebp
  801cc9:	89 e5                	mov    %esp,%ebp
  801ccb:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801cce:	e8 f1 fc ff ff       	call   8019c4 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801cd3:	83 ec 04             	sub    $0x4,%esp
  801cd6:	68 e8 44 80 00       	push   $0x8044e8
  801cdb:	68 e6 00 00 00       	push   $0xe6
  801ce0:	68 47 44 80 00       	push   $0x804447
  801ce5:	e8 96 ea ff ff       	call   800780 <_panic>

00801cea <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801cea:	55                   	push   %ebp
  801ceb:	89 e5                	mov    %esp,%ebp
  801ced:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801cf0:	83 ec 04             	sub    $0x4,%esp
  801cf3:	68 10 45 80 00       	push   $0x804510
  801cf8:	68 fa 00 00 00       	push   $0xfa
  801cfd:	68 47 44 80 00       	push   $0x804447
  801d02:	e8 79 ea ff ff       	call   800780 <_panic>

00801d07 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801d07:	55                   	push   %ebp
  801d08:	89 e5                	mov    %esp,%ebp
  801d0a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801d0d:	83 ec 04             	sub    $0x4,%esp
  801d10:	68 34 45 80 00       	push   $0x804534
  801d15:	68 05 01 00 00       	push   $0x105
  801d1a:	68 47 44 80 00       	push   $0x804447
  801d1f:	e8 5c ea ff ff       	call   800780 <_panic>

00801d24 <shrink>:

}
void shrink(uint32 newSize)
{
  801d24:	55                   	push   %ebp
  801d25:	89 e5                	mov    %esp,%ebp
  801d27:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801d2a:	83 ec 04             	sub    $0x4,%esp
  801d2d:	68 34 45 80 00       	push   $0x804534
  801d32:	68 0a 01 00 00       	push   $0x10a
  801d37:	68 47 44 80 00       	push   $0x804447
  801d3c:	e8 3f ea ff ff       	call   800780 <_panic>

00801d41 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801d41:	55                   	push   %ebp
  801d42:	89 e5                	mov    %esp,%ebp
  801d44:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801d47:	83 ec 04             	sub    $0x4,%esp
  801d4a:	68 34 45 80 00       	push   $0x804534
  801d4f:	68 0f 01 00 00       	push   $0x10f
  801d54:	68 47 44 80 00       	push   $0x804447
  801d59:	e8 22 ea ff ff       	call   800780 <_panic>

00801d5e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801d5e:	55                   	push   %ebp
  801d5f:	89 e5                	mov    %esp,%ebp
  801d61:	57                   	push   %edi
  801d62:	56                   	push   %esi
  801d63:	53                   	push   %ebx
  801d64:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801d67:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d6d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d70:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d73:	8b 7d 18             	mov    0x18(%ebp),%edi
  801d76:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801d79:	cd 30                	int    $0x30
  801d7b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801d7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801d81:	83 c4 10             	add    $0x10,%esp
  801d84:	5b                   	pop    %ebx
  801d85:	5e                   	pop    %esi
  801d86:	5f                   	pop    %edi
  801d87:	5d                   	pop    %ebp
  801d88:	c3                   	ret    

00801d89 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801d89:	55                   	push   %ebp
  801d8a:	89 e5                	mov    %esp,%ebp
  801d8c:	83 ec 04             	sub    $0x4,%esp
  801d8f:	8b 45 10             	mov    0x10(%ebp),%eax
  801d92:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801d95:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d99:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9c:	6a 00                	push   $0x0
  801d9e:	6a 00                	push   $0x0
  801da0:	52                   	push   %edx
  801da1:	ff 75 0c             	pushl  0xc(%ebp)
  801da4:	50                   	push   %eax
  801da5:	6a 00                	push   $0x0
  801da7:	e8 b2 ff ff ff       	call   801d5e <syscall>
  801dac:	83 c4 18             	add    $0x18,%esp
}
  801daf:	90                   	nop
  801db0:	c9                   	leave  
  801db1:	c3                   	ret    

00801db2 <sys_cgetc>:

int
sys_cgetc(void)
{
  801db2:	55                   	push   %ebp
  801db3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801db5:	6a 00                	push   $0x0
  801db7:	6a 00                	push   $0x0
  801db9:	6a 00                	push   $0x0
  801dbb:	6a 00                	push   $0x0
  801dbd:	6a 00                	push   $0x0
  801dbf:	6a 01                	push   $0x1
  801dc1:	e8 98 ff ff ff       	call   801d5e <syscall>
  801dc6:	83 c4 18             	add    $0x18,%esp
}
  801dc9:	c9                   	leave  
  801dca:	c3                   	ret    

00801dcb <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801dcb:	55                   	push   %ebp
  801dcc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801dce:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd4:	6a 00                	push   $0x0
  801dd6:	6a 00                	push   $0x0
  801dd8:	6a 00                	push   $0x0
  801dda:	52                   	push   %edx
  801ddb:	50                   	push   %eax
  801ddc:	6a 05                	push   $0x5
  801dde:	e8 7b ff ff ff       	call   801d5e <syscall>
  801de3:	83 c4 18             	add    $0x18,%esp
}
  801de6:	c9                   	leave  
  801de7:	c3                   	ret    

00801de8 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801de8:	55                   	push   %ebp
  801de9:	89 e5                	mov    %esp,%ebp
  801deb:	56                   	push   %esi
  801dec:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801ded:	8b 75 18             	mov    0x18(%ebp),%esi
  801df0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801df3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801df6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801df9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dfc:	56                   	push   %esi
  801dfd:	53                   	push   %ebx
  801dfe:	51                   	push   %ecx
  801dff:	52                   	push   %edx
  801e00:	50                   	push   %eax
  801e01:	6a 06                	push   $0x6
  801e03:	e8 56 ff ff ff       	call   801d5e <syscall>
  801e08:	83 c4 18             	add    $0x18,%esp
}
  801e0b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e0e:	5b                   	pop    %ebx
  801e0f:	5e                   	pop    %esi
  801e10:	5d                   	pop    %ebp
  801e11:	c3                   	ret    

00801e12 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801e12:	55                   	push   %ebp
  801e13:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801e15:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e18:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1b:	6a 00                	push   $0x0
  801e1d:	6a 00                	push   $0x0
  801e1f:	6a 00                	push   $0x0
  801e21:	52                   	push   %edx
  801e22:	50                   	push   %eax
  801e23:	6a 07                	push   $0x7
  801e25:	e8 34 ff ff ff       	call   801d5e <syscall>
  801e2a:	83 c4 18             	add    $0x18,%esp
}
  801e2d:	c9                   	leave  
  801e2e:	c3                   	ret    

00801e2f <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801e2f:	55                   	push   %ebp
  801e30:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801e32:	6a 00                	push   $0x0
  801e34:	6a 00                	push   $0x0
  801e36:	6a 00                	push   $0x0
  801e38:	ff 75 0c             	pushl  0xc(%ebp)
  801e3b:	ff 75 08             	pushl  0x8(%ebp)
  801e3e:	6a 08                	push   $0x8
  801e40:	e8 19 ff ff ff       	call   801d5e <syscall>
  801e45:	83 c4 18             	add    $0x18,%esp
}
  801e48:	c9                   	leave  
  801e49:	c3                   	ret    

00801e4a <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801e4a:	55                   	push   %ebp
  801e4b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801e4d:	6a 00                	push   $0x0
  801e4f:	6a 00                	push   $0x0
  801e51:	6a 00                	push   $0x0
  801e53:	6a 00                	push   $0x0
  801e55:	6a 00                	push   $0x0
  801e57:	6a 09                	push   $0x9
  801e59:	e8 00 ff ff ff       	call   801d5e <syscall>
  801e5e:	83 c4 18             	add    $0x18,%esp
}
  801e61:	c9                   	leave  
  801e62:	c3                   	ret    

00801e63 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801e63:	55                   	push   %ebp
  801e64:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801e66:	6a 00                	push   $0x0
  801e68:	6a 00                	push   $0x0
  801e6a:	6a 00                	push   $0x0
  801e6c:	6a 00                	push   $0x0
  801e6e:	6a 00                	push   $0x0
  801e70:	6a 0a                	push   $0xa
  801e72:	e8 e7 fe ff ff       	call   801d5e <syscall>
  801e77:	83 c4 18             	add    $0x18,%esp
}
  801e7a:	c9                   	leave  
  801e7b:	c3                   	ret    

00801e7c <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801e7c:	55                   	push   %ebp
  801e7d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801e7f:	6a 00                	push   $0x0
  801e81:	6a 00                	push   $0x0
  801e83:	6a 00                	push   $0x0
  801e85:	6a 00                	push   $0x0
  801e87:	6a 00                	push   $0x0
  801e89:	6a 0b                	push   $0xb
  801e8b:	e8 ce fe ff ff       	call   801d5e <syscall>
  801e90:	83 c4 18             	add    $0x18,%esp
}
  801e93:	c9                   	leave  
  801e94:	c3                   	ret    

00801e95 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801e95:	55                   	push   %ebp
  801e96:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801e98:	6a 00                	push   $0x0
  801e9a:	6a 00                	push   $0x0
  801e9c:	6a 00                	push   $0x0
  801e9e:	ff 75 0c             	pushl  0xc(%ebp)
  801ea1:	ff 75 08             	pushl  0x8(%ebp)
  801ea4:	6a 0f                	push   $0xf
  801ea6:	e8 b3 fe ff ff       	call   801d5e <syscall>
  801eab:	83 c4 18             	add    $0x18,%esp
	return;
  801eae:	90                   	nop
}
  801eaf:	c9                   	leave  
  801eb0:	c3                   	ret    

00801eb1 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801eb1:	55                   	push   %ebp
  801eb2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801eb4:	6a 00                	push   $0x0
  801eb6:	6a 00                	push   $0x0
  801eb8:	6a 00                	push   $0x0
  801eba:	ff 75 0c             	pushl  0xc(%ebp)
  801ebd:	ff 75 08             	pushl  0x8(%ebp)
  801ec0:	6a 10                	push   $0x10
  801ec2:	e8 97 fe ff ff       	call   801d5e <syscall>
  801ec7:	83 c4 18             	add    $0x18,%esp
	return ;
  801eca:	90                   	nop
}
  801ecb:	c9                   	leave  
  801ecc:	c3                   	ret    

00801ecd <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801ecd:	55                   	push   %ebp
  801ece:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801ed0:	6a 00                	push   $0x0
  801ed2:	6a 00                	push   $0x0
  801ed4:	ff 75 10             	pushl  0x10(%ebp)
  801ed7:	ff 75 0c             	pushl  0xc(%ebp)
  801eda:	ff 75 08             	pushl  0x8(%ebp)
  801edd:	6a 11                	push   $0x11
  801edf:	e8 7a fe ff ff       	call   801d5e <syscall>
  801ee4:	83 c4 18             	add    $0x18,%esp
	return ;
  801ee7:	90                   	nop
}
  801ee8:	c9                   	leave  
  801ee9:	c3                   	ret    

00801eea <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801eea:	55                   	push   %ebp
  801eeb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801eed:	6a 00                	push   $0x0
  801eef:	6a 00                	push   $0x0
  801ef1:	6a 00                	push   $0x0
  801ef3:	6a 00                	push   $0x0
  801ef5:	6a 00                	push   $0x0
  801ef7:	6a 0c                	push   $0xc
  801ef9:	e8 60 fe ff ff       	call   801d5e <syscall>
  801efe:	83 c4 18             	add    $0x18,%esp
}
  801f01:	c9                   	leave  
  801f02:	c3                   	ret    

00801f03 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801f03:	55                   	push   %ebp
  801f04:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801f06:	6a 00                	push   $0x0
  801f08:	6a 00                	push   $0x0
  801f0a:	6a 00                	push   $0x0
  801f0c:	6a 00                	push   $0x0
  801f0e:	ff 75 08             	pushl  0x8(%ebp)
  801f11:	6a 0d                	push   $0xd
  801f13:	e8 46 fe ff ff       	call   801d5e <syscall>
  801f18:	83 c4 18             	add    $0x18,%esp
}
  801f1b:	c9                   	leave  
  801f1c:	c3                   	ret    

00801f1d <sys_scarce_memory>:

void sys_scarce_memory()
{
  801f1d:	55                   	push   %ebp
  801f1e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801f20:	6a 00                	push   $0x0
  801f22:	6a 00                	push   $0x0
  801f24:	6a 00                	push   $0x0
  801f26:	6a 00                	push   $0x0
  801f28:	6a 00                	push   $0x0
  801f2a:	6a 0e                	push   $0xe
  801f2c:	e8 2d fe ff ff       	call   801d5e <syscall>
  801f31:	83 c4 18             	add    $0x18,%esp
}
  801f34:	90                   	nop
  801f35:	c9                   	leave  
  801f36:	c3                   	ret    

00801f37 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801f37:	55                   	push   %ebp
  801f38:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801f3a:	6a 00                	push   $0x0
  801f3c:	6a 00                	push   $0x0
  801f3e:	6a 00                	push   $0x0
  801f40:	6a 00                	push   $0x0
  801f42:	6a 00                	push   $0x0
  801f44:	6a 13                	push   $0x13
  801f46:	e8 13 fe ff ff       	call   801d5e <syscall>
  801f4b:	83 c4 18             	add    $0x18,%esp
}
  801f4e:	90                   	nop
  801f4f:	c9                   	leave  
  801f50:	c3                   	ret    

00801f51 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801f51:	55                   	push   %ebp
  801f52:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801f54:	6a 00                	push   $0x0
  801f56:	6a 00                	push   $0x0
  801f58:	6a 00                	push   $0x0
  801f5a:	6a 00                	push   $0x0
  801f5c:	6a 00                	push   $0x0
  801f5e:	6a 14                	push   $0x14
  801f60:	e8 f9 fd ff ff       	call   801d5e <syscall>
  801f65:	83 c4 18             	add    $0x18,%esp
}
  801f68:	90                   	nop
  801f69:	c9                   	leave  
  801f6a:	c3                   	ret    

00801f6b <sys_cputc>:


void
sys_cputc(const char c)
{
  801f6b:	55                   	push   %ebp
  801f6c:	89 e5                	mov    %esp,%ebp
  801f6e:	83 ec 04             	sub    $0x4,%esp
  801f71:	8b 45 08             	mov    0x8(%ebp),%eax
  801f74:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801f77:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f7b:	6a 00                	push   $0x0
  801f7d:	6a 00                	push   $0x0
  801f7f:	6a 00                	push   $0x0
  801f81:	6a 00                	push   $0x0
  801f83:	50                   	push   %eax
  801f84:	6a 15                	push   $0x15
  801f86:	e8 d3 fd ff ff       	call   801d5e <syscall>
  801f8b:	83 c4 18             	add    $0x18,%esp
}
  801f8e:	90                   	nop
  801f8f:	c9                   	leave  
  801f90:	c3                   	ret    

00801f91 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801f91:	55                   	push   %ebp
  801f92:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801f94:	6a 00                	push   $0x0
  801f96:	6a 00                	push   $0x0
  801f98:	6a 00                	push   $0x0
  801f9a:	6a 00                	push   $0x0
  801f9c:	6a 00                	push   $0x0
  801f9e:	6a 16                	push   $0x16
  801fa0:	e8 b9 fd ff ff       	call   801d5e <syscall>
  801fa5:	83 c4 18             	add    $0x18,%esp
}
  801fa8:	90                   	nop
  801fa9:	c9                   	leave  
  801faa:	c3                   	ret    

00801fab <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801fab:	55                   	push   %ebp
  801fac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801fae:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb1:	6a 00                	push   $0x0
  801fb3:	6a 00                	push   $0x0
  801fb5:	6a 00                	push   $0x0
  801fb7:	ff 75 0c             	pushl  0xc(%ebp)
  801fba:	50                   	push   %eax
  801fbb:	6a 17                	push   $0x17
  801fbd:	e8 9c fd ff ff       	call   801d5e <syscall>
  801fc2:	83 c4 18             	add    $0x18,%esp
}
  801fc5:	c9                   	leave  
  801fc6:	c3                   	ret    

00801fc7 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801fc7:	55                   	push   %ebp
  801fc8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801fca:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fcd:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd0:	6a 00                	push   $0x0
  801fd2:	6a 00                	push   $0x0
  801fd4:	6a 00                	push   $0x0
  801fd6:	52                   	push   %edx
  801fd7:	50                   	push   %eax
  801fd8:	6a 1a                	push   $0x1a
  801fda:	e8 7f fd ff ff       	call   801d5e <syscall>
  801fdf:	83 c4 18             	add    $0x18,%esp
}
  801fe2:	c9                   	leave  
  801fe3:	c3                   	ret    

00801fe4 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801fe4:	55                   	push   %ebp
  801fe5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801fe7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fea:	8b 45 08             	mov    0x8(%ebp),%eax
  801fed:	6a 00                	push   $0x0
  801fef:	6a 00                	push   $0x0
  801ff1:	6a 00                	push   $0x0
  801ff3:	52                   	push   %edx
  801ff4:	50                   	push   %eax
  801ff5:	6a 18                	push   $0x18
  801ff7:	e8 62 fd ff ff       	call   801d5e <syscall>
  801ffc:	83 c4 18             	add    $0x18,%esp
}
  801fff:	90                   	nop
  802000:	c9                   	leave  
  802001:	c3                   	ret    

00802002 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802002:	55                   	push   %ebp
  802003:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802005:	8b 55 0c             	mov    0xc(%ebp),%edx
  802008:	8b 45 08             	mov    0x8(%ebp),%eax
  80200b:	6a 00                	push   $0x0
  80200d:	6a 00                	push   $0x0
  80200f:	6a 00                	push   $0x0
  802011:	52                   	push   %edx
  802012:	50                   	push   %eax
  802013:	6a 19                	push   $0x19
  802015:	e8 44 fd ff ff       	call   801d5e <syscall>
  80201a:	83 c4 18             	add    $0x18,%esp
}
  80201d:	90                   	nop
  80201e:	c9                   	leave  
  80201f:	c3                   	ret    

00802020 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802020:	55                   	push   %ebp
  802021:	89 e5                	mov    %esp,%ebp
  802023:	83 ec 04             	sub    $0x4,%esp
  802026:	8b 45 10             	mov    0x10(%ebp),%eax
  802029:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80202c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80202f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802033:	8b 45 08             	mov    0x8(%ebp),%eax
  802036:	6a 00                	push   $0x0
  802038:	51                   	push   %ecx
  802039:	52                   	push   %edx
  80203a:	ff 75 0c             	pushl  0xc(%ebp)
  80203d:	50                   	push   %eax
  80203e:	6a 1b                	push   $0x1b
  802040:	e8 19 fd ff ff       	call   801d5e <syscall>
  802045:	83 c4 18             	add    $0x18,%esp
}
  802048:	c9                   	leave  
  802049:	c3                   	ret    

0080204a <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80204a:	55                   	push   %ebp
  80204b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80204d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802050:	8b 45 08             	mov    0x8(%ebp),%eax
  802053:	6a 00                	push   $0x0
  802055:	6a 00                	push   $0x0
  802057:	6a 00                	push   $0x0
  802059:	52                   	push   %edx
  80205a:	50                   	push   %eax
  80205b:	6a 1c                	push   $0x1c
  80205d:	e8 fc fc ff ff       	call   801d5e <syscall>
  802062:	83 c4 18             	add    $0x18,%esp
}
  802065:	c9                   	leave  
  802066:	c3                   	ret    

00802067 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802067:	55                   	push   %ebp
  802068:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80206a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80206d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802070:	8b 45 08             	mov    0x8(%ebp),%eax
  802073:	6a 00                	push   $0x0
  802075:	6a 00                	push   $0x0
  802077:	51                   	push   %ecx
  802078:	52                   	push   %edx
  802079:	50                   	push   %eax
  80207a:	6a 1d                	push   $0x1d
  80207c:	e8 dd fc ff ff       	call   801d5e <syscall>
  802081:	83 c4 18             	add    $0x18,%esp
}
  802084:	c9                   	leave  
  802085:	c3                   	ret    

00802086 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802086:	55                   	push   %ebp
  802087:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802089:	8b 55 0c             	mov    0xc(%ebp),%edx
  80208c:	8b 45 08             	mov    0x8(%ebp),%eax
  80208f:	6a 00                	push   $0x0
  802091:	6a 00                	push   $0x0
  802093:	6a 00                	push   $0x0
  802095:	52                   	push   %edx
  802096:	50                   	push   %eax
  802097:	6a 1e                	push   $0x1e
  802099:	e8 c0 fc ff ff       	call   801d5e <syscall>
  80209e:	83 c4 18             	add    $0x18,%esp
}
  8020a1:	c9                   	leave  
  8020a2:	c3                   	ret    

008020a3 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8020a3:	55                   	push   %ebp
  8020a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8020a6:	6a 00                	push   $0x0
  8020a8:	6a 00                	push   $0x0
  8020aa:	6a 00                	push   $0x0
  8020ac:	6a 00                	push   $0x0
  8020ae:	6a 00                	push   $0x0
  8020b0:	6a 1f                	push   $0x1f
  8020b2:	e8 a7 fc ff ff       	call   801d5e <syscall>
  8020b7:	83 c4 18             	add    $0x18,%esp
}
  8020ba:	c9                   	leave  
  8020bb:	c3                   	ret    

008020bc <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8020bc:	55                   	push   %ebp
  8020bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8020bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c2:	6a 00                	push   $0x0
  8020c4:	ff 75 14             	pushl  0x14(%ebp)
  8020c7:	ff 75 10             	pushl  0x10(%ebp)
  8020ca:	ff 75 0c             	pushl  0xc(%ebp)
  8020cd:	50                   	push   %eax
  8020ce:	6a 20                	push   $0x20
  8020d0:	e8 89 fc ff ff       	call   801d5e <syscall>
  8020d5:	83 c4 18             	add    $0x18,%esp
}
  8020d8:	c9                   	leave  
  8020d9:	c3                   	ret    

008020da <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8020da:	55                   	push   %ebp
  8020db:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8020dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e0:	6a 00                	push   $0x0
  8020e2:	6a 00                	push   $0x0
  8020e4:	6a 00                	push   $0x0
  8020e6:	6a 00                	push   $0x0
  8020e8:	50                   	push   %eax
  8020e9:	6a 21                	push   $0x21
  8020eb:	e8 6e fc ff ff       	call   801d5e <syscall>
  8020f0:	83 c4 18             	add    $0x18,%esp
}
  8020f3:	90                   	nop
  8020f4:	c9                   	leave  
  8020f5:	c3                   	ret    

008020f6 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8020f6:	55                   	push   %ebp
  8020f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8020f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fc:	6a 00                	push   $0x0
  8020fe:	6a 00                	push   $0x0
  802100:	6a 00                	push   $0x0
  802102:	6a 00                	push   $0x0
  802104:	50                   	push   %eax
  802105:	6a 22                	push   $0x22
  802107:	e8 52 fc ff ff       	call   801d5e <syscall>
  80210c:	83 c4 18             	add    $0x18,%esp
}
  80210f:	c9                   	leave  
  802110:	c3                   	ret    

00802111 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802111:	55                   	push   %ebp
  802112:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802114:	6a 00                	push   $0x0
  802116:	6a 00                	push   $0x0
  802118:	6a 00                	push   $0x0
  80211a:	6a 00                	push   $0x0
  80211c:	6a 00                	push   $0x0
  80211e:	6a 02                	push   $0x2
  802120:	e8 39 fc ff ff       	call   801d5e <syscall>
  802125:	83 c4 18             	add    $0x18,%esp
}
  802128:	c9                   	leave  
  802129:	c3                   	ret    

0080212a <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80212a:	55                   	push   %ebp
  80212b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80212d:	6a 00                	push   $0x0
  80212f:	6a 00                	push   $0x0
  802131:	6a 00                	push   $0x0
  802133:	6a 00                	push   $0x0
  802135:	6a 00                	push   $0x0
  802137:	6a 03                	push   $0x3
  802139:	e8 20 fc ff ff       	call   801d5e <syscall>
  80213e:	83 c4 18             	add    $0x18,%esp
}
  802141:	c9                   	leave  
  802142:	c3                   	ret    

00802143 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802143:	55                   	push   %ebp
  802144:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802146:	6a 00                	push   $0x0
  802148:	6a 00                	push   $0x0
  80214a:	6a 00                	push   $0x0
  80214c:	6a 00                	push   $0x0
  80214e:	6a 00                	push   $0x0
  802150:	6a 04                	push   $0x4
  802152:	e8 07 fc ff ff       	call   801d5e <syscall>
  802157:	83 c4 18             	add    $0x18,%esp
}
  80215a:	c9                   	leave  
  80215b:	c3                   	ret    

0080215c <sys_exit_env>:


void sys_exit_env(void)
{
  80215c:	55                   	push   %ebp
  80215d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80215f:	6a 00                	push   $0x0
  802161:	6a 00                	push   $0x0
  802163:	6a 00                	push   $0x0
  802165:	6a 00                	push   $0x0
  802167:	6a 00                	push   $0x0
  802169:	6a 23                	push   $0x23
  80216b:	e8 ee fb ff ff       	call   801d5e <syscall>
  802170:	83 c4 18             	add    $0x18,%esp
}
  802173:	90                   	nop
  802174:	c9                   	leave  
  802175:	c3                   	ret    

00802176 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802176:	55                   	push   %ebp
  802177:	89 e5                	mov    %esp,%ebp
  802179:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80217c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80217f:	8d 50 04             	lea    0x4(%eax),%edx
  802182:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802185:	6a 00                	push   $0x0
  802187:	6a 00                	push   $0x0
  802189:	6a 00                	push   $0x0
  80218b:	52                   	push   %edx
  80218c:	50                   	push   %eax
  80218d:	6a 24                	push   $0x24
  80218f:	e8 ca fb ff ff       	call   801d5e <syscall>
  802194:	83 c4 18             	add    $0x18,%esp
	return result;
  802197:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80219a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80219d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8021a0:	89 01                	mov    %eax,(%ecx)
  8021a2:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8021a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a8:	c9                   	leave  
  8021a9:	c2 04 00             	ret    $0x4

008021ac <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8021ac:	55                   	push   %ebp
  8021ad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8021af:	6a 00                	push   $0x0
  8021b1:	6a 00                	push   $0x0
  8021b3:	ff 75 10             	pushl  0x10(%ebp)
  8021b6:	ff 75 0c             	pushl  0xc(%ebp)
  8021b9:	ff 75 08             	pushl  0x8(%ebp)
  8021bc:	6a 12                	push   $0x12
  8021be:	e8 9b fb ff ff       	call   801d5e <syscall>
  8021c3:	83 c4 18             	add    $0x18,%esp
	return ;
  8021c6:	90                   	nop
}
  8021c7:	c9                   	leave  
  8021c8:	c3                   	ret    

008021c9 <sys_rcr2>:
uint32 sys_rcr2()
{
  8021c9:	55                   	push   %ebp
  8021ca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8021cc:	6a 00                	push   $0x0
  8021ce:	6a 00                	push   $0x0
  8021d0:	6a 00                	push   $0x0
  8021d2:	6a 00                	push   $0x0
  8021d4:	6a 00                	push   $0x0
  8021d6:	6a 25                	push   $0x25
  8021d8:	e8 81 fb ff ff       	call   801d5e <syscall>
  8021dd:	83 c4 18             	add    $0x18,%esp
}
  8021e0:	c9                   	leave  
  8021e1:	c3                   	ret    

008021e2 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8021e2:	55                   	push   %ebp
  8021e3:	89 e5                	mov    %esp,%ebp
  8021e5:	83 ec 04             	sub    $0x4,%esp
  8021e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021eb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8021ee:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8021f2:	6a 00                	push   $0x0
  8021f4:	6a 00                	push   $0x0
  8021f6:	6a 00                	push   $0x0
  8021f8:	6a 00                	push   $0x0
  8021fa:	50                   	push   %eax
  8021fb:	6a 26                	push   $0x26
  8021fd:	e8 5c fb ff ff       	call   801d5e <syscall>
  802202:	83 c4 18             	add    $0x18,%esp
	return ;
  802205:	90                   	nop
}
  802206:	c9                   	leave  
  802207:	c3                   	ret    

00802208 <rsttst>:
void rsttst()
{
  802208:	55                   	push   %ebp
  802209:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80220b:	6a 00                	push   $0x0
  80220d:	6a 00                	push   $0x0
  80220f:	6a 00                	push   $0x0
  802211:	6a 00                	push   $0x0
  802213:	6a 00                	push   $0x0
  802215:	6a 28                	push   $0x28
  802217:	e8 42 fb ff ff       	call   801d5e <syscall>
  80221c:	83 c4 18             	add    $0x18,%esp
	return ;
  80221f:	90                   	nop
}
  802220:	c9                   	leave  
  802221:	c3                   	ret    

00802222 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802222:	55                   	push   %ebp
  802223:	89 e5                	mov    %esp,%ebp
  802225:	83 ec 04             	sub    $0x4,%esp
  802228:	8b 45 14             	mov    0x14(%ebp),%eax
  80222b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80222e:	8b 55 18             	mov    0x18(%ebp),%edx
  802231:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802235:	52                   	push   %edx
  802236:	50                   	push   %eax
  802237:	ff 75 10             	pushl  0x10(%ebp)
  80223a:	ff 75 0c             	pushl  0xc(%ebp)
  80223d:	ff 75 08             	pushl  0x8(%ebp)
  802240:	6a 27                	push   $0x27
  802242:	e8 17 fb ff ff       	call   801d5e <syscall>
  802247:	83 c4 18             	add    $0x18,%esp
	return ;
  80224a:	90                   	nop
}
  80224b:	c9                   	leave  
  80224c:	c3                   	ret    

0080224d <chktst>:
void chktst(uint32 n)
{
  80224d:	55                   	push   %ebp
  80224e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802250:	6a 00                	push   $0x0
  802252:	6a 00                	push   $0x0
  802254:	6a 00                	push   $0x0
  802256:	6a 00                	push   $0x0
  802258:	ff 75 08             	pushl  0x8(%ebp)
  80225b:	6a 29                	push   $0x29
  80225d:	e8 fc fa ff ff       	call   801d5e <syscall>
  802262:	83 c4 18             	add    $0x18,%esp
	return ;
  802265:	90                   	nop
}
  802266:	c9                   	leave  
  802267:	c3                   	ret    

00802268 <inctst>:

void inctst()
{
  802268:	55                   	push   %ebp
  802269:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80226b:	6a 00                	push   $0x0
  80226d:	6a 00                	push   $0x0
  80226f:	6a 00                	push   $0x0
  802271:	6a 00                	push   $0x0
  802273:	6a 00                	push   $0x0
  802275:	6a 2a                	push   $0x2a
  802277:	e8 e2 fa ff ff       	call   801d5e <syscall>
  80227c:	83 c4 18             	add    $0x18,%esp
	return ;
  80227f:	90                   	nop
}
  802280:	c9                   	leave  
  802281:	c3                   	ret    

00802282 <gettst>:
uint32 gettst()
{
  802282:	55                   	push   %ebp
  802283:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802285:	6a 00                	push   $0x0
  802287:	6a 00                	push   $0x0
  802289:	6a 00                	push   $0x0
  80228b:	6a 00                	push   $0x0
  80228d:	6a 00                	push   $0x0
  80228f:	6a 2b                	push   $0x2b
  802291:	e8 c8 fa ff ff       	call   801d5e <syscall>
  802296:	83 c4 18             	add    $0x18,%esp
}
  802299:	c9                   	leave  
  80229a:	c3                   	ret    

0080229b <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80229b:	55                   	push   %ebp
  80229c:	89 e5                	mov    %esp,%ebp
  80229e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8022a1:	6a 00                	push   $0x0
  8022a3:	6a 00                	push   $0x0
  8022a5:	6a 00                	push   $0x0
  8022a7:	6a 00                	push   $0x0
  8022a9:	6a 00                	push   $0x0
  8022ab:	6a 2c                	push   $0x2c
  8022ad:	e8 ac fa ff ff       	call   801d5e <syscall>
  8022b2:	83 c4 18             	add    $0x18,%esp
  8022b5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8022b8:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8022bc:	75 07                	jne    8022c5 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8022be:	b8 01 00 00 00       	mov    $0x1,%eax
  8022c3:	eb 05                	jmp    8022ca <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8022c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022ca:	c9                   	leave  
  8022cb:	c3                   	ret    

008022cc <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8022cc:	55                   	push   %ebp
  8022cd:	89 e5                	mov    %esp,%ebp
  8022cf:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8022d2:	6a 00                	push   $0x0
  8022d4:	6a 00                	push   $0x0
  8022d6:	6a 00                	push   $0x0
  8022d8:	6a 00                	push   $0x0
  8022da:	6a 00                	push   $0x0
  8022dc:	6a 2c                	push   $0x2c
  8022de:	e8 7b fa ff ff       	call   801d5e <syscall>
  8022e3:	83 c4 18             	add    $0x18,%esp
  8022e6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8022e9:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8022ed:	75 07                	jne    8022f6 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8022ef:	b8 01 00 00 00       	mov    $0x1,%eax
  8022f4:	eb 05                	jmp    8022fb <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8022f6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022fb:	c9                   	leave  
  8022fc:	c3                   	ret    

008022fd <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8022fd:	55                   	push   %ebp
  8022fe:	89 e5                	mov    %esp,%ebp
  802300:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802303:	6a 00                	push   $0x0
  802305:	6a 00                	push   $0x0
  802307:	6a 00                	push   $0x0
  802309:	6a 00                	push   $0x0
  80230b:	6a 00                	push   $0x0
  80230d:	6a 2c                	push   $0x2c
  80230f:	e8 4a fa ff ff       	call   801d5e <syscall>
  802314:	83 c4 18             	add    $0x18,%esp
  802317:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80231a:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80231e:	75 07                	jne    802327 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802320:	b8 01 00 00 00       	mov    $0x1,%eax
  802325:	eb 05                	jmp    80232c <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802327:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80232c:	c9                   	leave  
  80232d:	c3                   	ret    

0080232e <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80232e:	55                   	push   %ebp
  80232f:	89 e5                	mov    %esp,%ebp
  802331:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802334:	6a 00                	push   $0x0
  802336:	6a 00                	push   $0x0
  802338:	6a 00                	push   $0x0
  80233a:	6a 00                	push   $0x0
  80233c:	6a 00                	push   $0x0
  80233e:	6a 2c                	push   $0x2c
  802340:	e8 19 fa ff ff       	call   801d5e <syscall>
  802345:	83 c4 18             	add    $0x18,%esp
  802348:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80234b:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80234f:	75 07                	jne    802358 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802351:	b8 01 00 00 00       	mov    $0x1,%eax
  802356:	eb 05                	jmp    80235d <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802358:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80235d:	c9                   	leave  
  80235e:	c3                   	ret    

0080235f <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80235f:	55                   	push   %ebp
  802360:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802362:	6a 00                	push   $0x0
  802364:	6a 00                	push   $0x0
  802366:	6a 00                	push   $0x0
  802368:	6a 00                	push   $0x0
  80236a:	ff 75 08             	pushl  0x8(%ebp)
  80236d:	6a 2d                	push   $0x2d
  80236f:	e8 ea f9 ff ff       	call   801d5e <syscall>
  802374:	83 c4 18             	add    $0x18,%esp
	return ;
  802377:	90                   	nop
}
  802378:	c9                   	leave  
  802379:	c3                   	ret    

0080237a <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80237a:	55                   	push   %ebp
  80237b:	89 e5                	mov    %esp,%ebp
  80237d:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80237e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802381:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802384:	8b 55 0c             	mov    0xc(%ebp),%edx
  802387:	8b 45 08             	mov    0x8(%ebp),%eax
  80238a:	6a 00                	push   $0x0
  80238c:	53                   	push   %ebx
  80238d:	51                   	push   %ecx
  80238e:	52                   	push   %edx
  80238f:	50                   	push   %eax
  802390:	6a 2e                	push   $0x2e
  802392:	e8 c7 f9 ff ff       	call   801d5e <syscall>
  802397:	83 c4 18             	add    $0x18,%esp
}
  80239a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80239d:	c9                   	leave  
  80239e:	c3                   	ret    

0080239f <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80239f:	55                   	push   %ebp
  8023a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8023a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a8:	6a 00                	push   $0x0
  8023aa:	6a 00                	push   $0x0
  8023ac:	6a 00                	push   $0x0
  8023ae:	52                   	push   %edx
  8023af:	50                   	push   %eax
  8023b0:	6a 2f                	push   $0x2f
  8023b2:	e8 a7 f9 ff ff       	call   801d5e <syscall>
  8023b7:	83 c4 18             	add    $0x18,%esp
}
  8023ba:	c9                   	leave  
  8023bb:	c3                   	ret    

008023bc <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8023bc:	55                   	push   %ebp
  8023bd:	89 e5                	mov    %esp,%ebp
  8023bf:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8023c2:	83 ec 0c             	sub    $0xc,%esp
  8023c5:	68 44 45 80 00       	push   $0x804544
  8023ca:	e8 65 e6 ff ff       	call   800a34 <cprintf>
  8023cf:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8023d2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8023d9:	83 ec 0c             	sub    $0xc,%esp
  8023dc:	68 70 45 80 00       	push   $0x804570
  8023e1:	e8 4e e6 ff ff       	call   800a34 <cprintf>
  8023e6:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8023e9:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8023ed:	a1 38 51 80 00       	mov    0x805138,%eax
  8023f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023f5:	eb 56                	jmp    80244d <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8023f7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023fb:	74 1c                	je     802419 <print_mem_block_lists+0x5d>
  8023fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802400:	8b 50 08             	mov    0x8(%eax),%edx
  802403:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802406:	8b 48 08             	mov    0x8(%eax),%ecx
  802409:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80240c:	8b 40 0c             	mov    0xc(%eax),%eax
  80240f:	01 c8                	add    %ecx,%eax
  802411:	39 c2                	cmp    %eax,%edx
  802413:	73 04                	jae    802419 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802415:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802419:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241c:	8b 50 08             	mov    0x8(%eax),%edx
  80241f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802422:	8b 40 0c             	mov    0xc(%eax),%eax
  802425:	01 c2                	add    %eax,%edx
  802427:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242a:	8b 40 08             	mov    0x8(%eax),%eax
  80242d:	83 ec 04             	sub    $0x4,%esp
  802430:	52                   	push   %edx
  802431:	50                   	push   %eax
  802432:	68 85 45 80 00       	push   $0x804585
  802437:	e8 f8 e5 ff ff       	call   800a34 <cprintf>
  80243c:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80243f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802442:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802445:	a1 40 51 80 00       	mov    0x805140,%eax
  80244a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80244d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802451:	74 07                	je     80245a <print_mem_block_lists+0x9e>
  802453:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802456:	8b 00                	mov    (%eax),%eax
  802458:	eb 05                	jmp    80245f <print_mem_block_lists+0xa3>
  80245a:	b8 00 00 00 00       	mov    $0x0,%eax
  80245f:	a3 40 51 80 00       	mov    %eax,0x805140
  802464:	a1 40 51 80 00       	mov    0x805140,%eax
  802469:	85 c0                	test   %eax,%eax
  80246b:	75 8a                	jne    8023f7 <print_mem_block_lists+0x3b>
  80246d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802471:	75 84                	jne    8023f7 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802473:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802477:	75 10                	jne    802489 <print_mem_block_lists+0xcd>
  802479:	83 ec 0c             	sub    $0xc,%esp
  80247c:	68 94 45 80 00       	push   $0x804594
  802481:	e8 ae e5 ff ff       	call   800a34 <cprintf>
  802486:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802489:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802490:	83 ec 0c             	sub    $0xc,%esp
  802493:	68 b8 45 80 00       	push   $0x8045b8
  802498:	e8 97 e5 ff ff       	call   800a34 <cprintf>
  80249d:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8024a0:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8024a4:	a1 40 50 80 00       	mov    0x805040,%eax
  8024a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024ac:	eb 56                	jmp    802504 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8024ae:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024b2:	74 1c                	je     8024d0 <print_mem_block_lists+0x114>
  8024b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b7:	8b 50 08             	mov    0x8(%eax),%edx
  8024ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024bd:	8b 48 08             	mov    0x8(%eax),%ecx
  8024c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024c3:	8b 40 0c             	mov    0xc(%eax),%eax
  8024c6:	01 c8                	add    %ecx,%eax
  8024c8:	39 c2                	cmp    %eax,%edx
  8024ca:	73 04                	jae    8024d0 <print_mem_block_lists+0x114>
			sorted = 0 ;
  8024cc:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8024d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d3:	8b 50 08             	mov    0x8(%eax),%edx
  8024d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d9:	8b 40 0c             	mov    0xc(%eax),%eax
  8024dc:	01 c2                	add    %eax,%edx
  8024de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e1:	8b 40 08             	mov    0x8(%eax),%eax
  8024e4:	83 ec 04             	sub    $0x4,%esp
  8024e7:	52                   	push   %edx
  8024e8:	50                   	push   %eax
  8024e9:	68 85 45 80 00       	push   $0x804585
  8024ee:	e8 41 e5 ff ff       	call   800a34 <cprintf>
  8024f3:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8024f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8024fc:	a1 48 50 80 00       	mov    0x805048,%eax
  802501:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802504:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802508:	74 07                	je     802511 <print_mem_block_lists+0x155>
  80250a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250d:	8b 00                	mov    (%eax),%eax
  80250f:	eb 05                	jmp    802516 <print_mem_block_lists+0x15a>
  802511:	b8 00 00 00 00       	mov    $0x0,%eax
  802516:	a3 48 50 80 00       	mov    %eax,0x805048
  80251b:	a1 48 50 80 00       	mov    0x805048,%eax
  802520:	85 c0                	test   %eax,%eax
  802522:	75 8a                	jne    8024ae <print_mem_block_lists+0xf2>
  802524:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802528:	75 84                	jne    8024ae <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80252a:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80252e:	75 10                	jne    802540 <print_mem_block_lists+0x184>
  802530:	83 ec 0c             	sub    $0xc,%esp
  802533:	68 d0 45 80 00       	push   $0x8045d0
  802538:	e8 f7 e4 ff ff       	call   800a34 <cprintf>
  80253d:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802540:	83 ec 0c             	sub    $0xc,%esp
  802543:	68 44 45 80 00       	push   $0x804544
  802548:	e8 e7 e4 ff ff       	call   800a34 <cprintf>
  80254d:	83 c4 10             	add    $0x10,%esp

}
  802550:	90                   	nop
  802551:	c9                   	leave  
  802552:	c3                   	ret    

00802553 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802553:	55                   	push   %ebp
  802554:	89 e5                	mov    %esp,%ebp
  802556:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  802559:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802560:	00 00 00 
  802563:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80256a:	00 00 00 
  80256d:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802574:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  802577:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80257e:	e9 9e 00 00 00       	jmp    802621 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802583:	a1 50 50 80 00       	mov    0x805050,%eax
  802588:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80258b:	c1 e2 04             	shl    $0x4,%edx
  80258e:	01 d0                	add    %edx,%eax
  802590:	85 c0                	test   %eax,%eax
  802592:	75 14                	jne    8025a8 <initialize_MemBlocksList+0x55>
  802594:	83 ec 04             	sub    $0x4,%esp
  802597:	68 f8 45 80 00       	push   $0x8045f8
  80259c:	6a 46                	push   $0x46
  80259e:	68 1b 46 80 00       	push   $0x80461b
  8025a3:	e8 d8 e1 ff ff       	call   800780 <_panic>
  8025a8:	a1 50 50 80 00       	mov    0x805050,%eax
  8025ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025b0:	c1 e2 04             	shl    $0x4,%edx
  8025b3:	01 d0                	add    %edx,%eax
  8025b5:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8025bb:	89 10                	mov    %edx,(%eax)
  8025bd:	8b 00                	mov    (%eax),%eax
  8025bf:	85 c0                	test   %eax,%eax
  8025c1:	74 18                	je     8025db <initialize_MemBlocksList+0x88>
  8025c3:	a1 48 51 80 00       	mov    0x805148,%eax
  8025c8:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8025ce:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8025d1:	c1 e1 04             	shl    $0x4,%ecx
  8025d4:	01 ca                	add    %ecx,%edx
  8025d6:	89 50 04             	mov    %edx,0x4(%eax)
  8025d9:	eb 12                	jmp    8025ed <initialize_MemBlocksList+0x9a>
  8025db:	a1 50 50 80 00       	mov    0x805050,%eax
  8025e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025e3:	c1 e2 04             	shl    $0x4,%edx
  8025e6:	01 d0                	add    %edx,%eax
  8025e8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8025ed:	a1 50 50 80 00       	mov    0x805050,%eax
  8025f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025f5:	c1 e2 04             	shl    $0x4,%edx
  8025f8:	01 d0                	add    %edx,%eax
  8025fa:	a3 48 51 80 00       	mov    %eax,0x805148
  8025ff:	a1 50 50 80 00       	mov    0x805050,%eax
  802604:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802607:	c1 e2 04             	shl    $0x4,%edx
  80260a:	01 d0                	add    %edx,%eax
  80260c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802613:	a1 54 51 80 00       	mov    0x805154,%eax
  802618:	40                   	inc    %eax
  802619:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  80261e:	ff 45 f4             	incl   -0xc(%ebp)
  802621:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802624:	3b 45 08             	cmp    0x8(%ebp),%eax
  802627:	0f 82 56 ff ff ff    	jb     802583 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  80262d:	90                   	nop
  80262e:	c9                   	leave  
  80262f:	c3                   	ret    

00802630 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802630:	55                   	push   %ebp
  802631:	89 e5                	mov    %esp,%ebp
  802633:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802636:	8b 45 08             	mov    0x8(%ebp),%eax
  802639:	8b 00                	mov    (%eax),%eax
  80263b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80263e:	eb 19                	jmp    802659 <find_block+0x29>
	{
		if(va==point->sva)
  802640:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802643:	8b 40 08             	mov    0x8(%eax),%eax
  802646:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802649:	75 05                	jne    802650 <find_block+0x20>
		   return point;
  80264b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80264e:	eb 36                	jmp    802686 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802650:	8b 45 08             	mov    0x8(%ebp),%eax
  802653:	8b 40 08             	mov    0x8(%eax),%eax
  802656:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802659:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80265d:	74 07                	je     802666 <find_block+0x36>
  80265f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802662:	8b 00                	mov    (%eax),%eax
  802664:	eb 05                	jmp    80266b <find_block+0x3b>
  802666:	b8 00 00 00 00       	mov    $0x0,%eax
  80266b:	8b 55 08             	mov    0x8(%ebp),%edx
  80266e:	89 42 08             	mov    %eax,0x8(%edx)
  802671:	8b 45 08             	mov    0x8(%ebp),%eax
  802674:	8b 40 08             	mov    0x8(%eax),%eax
  802677:	85 c0                	test   %eax,%eax
  802679:	75 c5                	jne    802640 <find_block+0x10>
  80267b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80267f:	75 bf                	jne    802640 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802681:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802686:	c9                   	leave  
  802687:	c3                   	ret    

00802688 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802688:	55                   	push   %ebp
  802689:	89 e5                	mov    %esp,%ebp
  80268b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  80268e:	a1 40 50 80 00       	mov    0x805040,%eax
  802693:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802696:	a1 44 50 80 00       	mov    0x805044,%eax
  80269b:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  80269e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026a1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8026a4:	74 24                	je     8026ca <insert_sorted_allocList+0x42>
  8026a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a9:	8b 50 08             	mov    0x8(%eax),%edx
  8026ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026af:	8b 40 08             	mov    0x8(%eax),%eax
  8026b2:	39 c2                	cmp    %eax,%edx
  8026b4:	76 14                	jbe    8026ca <insert_sorted_allocList+0x42>
  8026b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b9:	8b 50 08             	mov    0x8(%eax),%edx
  8026bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026bf:	8b 40 08             	mov    0x8(%eax),%eax
  8026c2:	39 c2                	cmp    %eax,%edx
  8026c4:	0f 82 60 01 00 00    	jb     80282a <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8026ca:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026ce:	75 65                	jne    802735 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8026d0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8026d4:	75 14                	jne    8026ea <insert_sorted_allocList+0x62>
  8026d6:	83 ec 04             	sub    $0x4,%esp
  8026d9:	68 f8 45 80 00       	push   $0x8045f8
  8026de:	6a 6b                	push   $0x6b
  8026e0:	68 1b 46 80 00       	push   $0x80461b
  8026e5:	e8 96 e0 ff ff       	call   800780 <_panic>
  8026ea:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8026f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f3:	89 10                	mov    %edx,(%eax)
  8026f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f8:	8b 00                	mov    (%eax),%eax
  8026fa:	85 c0                	test   %eax,%eax
  8026fc:	74 0d                	je     80270b <insert_sorted_allocList+0x83>
  8026fe:	a1 40 50 80 00       	mov    0x805040,%eax
  802703:	8b 55 08             	mov    0x8(%ebp),%edx
  802706:	89 50 04             	mov    %edx,0x4(%eax)
  802709:	eb 08                	jmp    802713 <insert_sorted_allocList+0x8b>
  80270b:	8b 45 08             	mov    0x8(%ebp),%eax
  80270e:	a3 44 50 80 00       	mov    %eax,0x805044
  802713:	8b 45 08             	mov    0x8(%ebp),%eax
  802716:	a3 40 50 80 00       	mov    %eax,0x805040
  80271b:	8b 45 08             	mov    0x8(%ebp),%eax
  80271e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802725:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80272a:	40                   	inc    %eax
  80272b:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802730:	e9 dc 01 00 00       	jmp    802911 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802735:	8b 45 08             	mov    0x8(%ebp),%eax
  802738:	8b 50 08             	mov    0x8(%eax),%edx
  80273b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80273e:	8b 40 08             	mov    0x8(%eax),%eax
  802741:	39 c2                	cmp    %eax,%edx
  802743:	77 6c                	ja     8027b1 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802745:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802749:	74 06                	je     802751 <insert_sorted_allocList+0xc9>
  80274b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80274f:	75 14                	jne    802765 <insert_sorted_allocList+0xdd>
  802751:	83 ec 04             	sub    $0x4,%esp
  802754:	68 34 46 80 00       	push   $0x804634
  802759:	6a 6f                	push   $0x6f
  80275b:	68 1b 46 80 00       	push   $0x80461b
  802760:	e8 1b e0 ff ff       	call   800780 <_panic>
  802765:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802768:	8b 50 04             	mov    0x4(%eax),%edx
  80276b:	8b 45 08             	mov    0x8(%ebp),%eax
  80276e:	89 50 04             	mov    %edx,0x4(%eax)
  802771:	8b 45 08             	mov    0x8(%ebp),%eax
  802774:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802777:	89 10                	mov    %edx,(%eax)
  802779:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80277c:	8b 40 04             	mov    0x4(%eax),%eax
  80277f:	85 c0                	test   %eax,%eax
  802781:	74 0d                	je     802790 <insert_sorted_allocList+0x108>
  802783:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802786:	8b 40 04             	mov    0x4(%eax),%eax
  802789:	8b 55 08             	mov    0x8(%ebp),%edx
  80278c:	89 10                	mov    %edx,(%eax)
  80278e:	eb 08                	jmp    802798 <insert_sorted_allocList+0x110>
  802790:	8b 45 08             	mov    0x8(%ebp),%eax
  802793:	a3 40 50 80 00       	mov    %eax,0x805040
  802798:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80279b:	8b 55 08             	mov    0x8(%ebp),%edx
  80279e:	89 50 04             	mov    %edx,0x4(%eax)
  8027a1:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8027a6:	40                   	inc    %eax
  8027a7:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8027ac:	e9 60 01 00 00       	jmp    802911 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8027b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b4:	8b 50 08             	mov    0x8(%eax),%edx
  8027b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027ba:	8b 40 08             	mov    0x8(%eax),%eax
  8027bd:	39 c2                	cmp    %eax,%edx
  8027bf:	0f 82 4c 01 00 00    	jb     802911 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8027c5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8027c9:	75 14                	jne    8027df <insert_sorted_allocList+0x157>
  8027cb:	83 ec 04             	sub    $0x4,%esp
  8027ce:	68 6c 46 80 00       	push   $0x80466c
  8027d3:	6a 73                	push   $0x73
  8027d5:	68 1b 46 80 00       	push   $0x80461b
  8027da:	e8 a1 df ff ff       	call   800780 <_panic>
  8027df:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8027e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e8:	89 50 04             	mov    %edx,0x4(%eax)
  8027eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ee:	8b 40 04             	mov    0x4(%eax),%eax
  8027f1:	85 c0                	test   %eax,%eax
  8027f3:	74 0c                	je     802801 <insert_sorted_allocList+0x179>
  8027f5:	a1 44 50 80 00       	mov    0x805044,%eax
  8027fa:	8b 55 08             	mov    0x8(%ebp),%edx
  8027fd:	89 10                	mov    %edx,(%eax)
  8027ff:	eb 08                	jmp    802809 <insert_sorted_allocList+0x181>
  802801:	8b 45 08             	mov    0x8(%ebp),%eax
  802804:	a3 40 50 80 00       	mov    %eax,0x805040
  802809:	8b 45 08             	mov    0x8(%ebp),%eax
  80280c:	a3 44 50 80 00       	mov    %eax,0x805044
  802811:	8b 45 08             	mov    0x8(%ebp),%eax
  802814:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80281a:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80281f:	40                   	inc    %eax
  802820:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802825:	e9 e7 00 00 00       	jmp    802911 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  80282a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80282d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802830:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802837:	a1 40 50 80 00       	mov    0x805040,%eax
  80283c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80283f:	e9 9d 00 00 00       	jmp    8028e1 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802844:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802847:	8b 00                	mov    (%eax),%eax
  802849:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  80284c:	8b 45 08             	mov    0x8(%ebp),%eax
  80284f:	8b 50 08             	mov    0x8(%eax),%edx
  802852:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802855:	8b 40 08             	mov    0x8(%eax),%eax
  802858:	39 c2                	cmp    %eax,%edx
  80285a:	76 7d                	jbe    8028d9 <insert_sorted_allocList+0x251>
  80285c:	8b 45 08             	mov    0x8(%ebp),%eax
  80285f:	8b 50 08             	mov    0x8(%eax),%edx
  802862:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802865:	8b 40 08             	mov    0x8(%eax),%eax
  802868:	39 c2                	cmp    %eax,%edx
  80286a:	73 6d                	jae    8028d9 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  80286c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802870:	74 06                	je     802878 <insert_sorted_allocList+0x1f0>
  802872:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802876:	75 14                	jne    80288c <insert_sorted_allocList+0x204>
  802878:	83 ec 04             	sub    $0x4,%esp
  80287b:	68 90 46 80 00       	push   $0x804690
  802880:	6a 7f                	push   $0x7f
  802882:	68 1b 46 80 00       	push   $0x80461b
  802887:	e8 f4 de ff ff       	call   800780 <_panic>
  80288c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288f:	8b 10                	mov    (%eax),%edx
  802891:	8b 45 08             	mov    0x8(%ebp),%eax
  802894:	89 10                	mov    %edx,(%eax)
  802896:	8b 45 08             	mov    0x8(%ebp),%eax
  802899:	8b 00                	mov    (%eax),%eax
  80289b:	85 c0                	test   %eax,%eax
  80289d:	74 0b                	je     8028aa <insert_sorted_allocList+0x222>
  80289f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a2:	8b 00                	mov    (%eax),%eax
  8028a4:	8b 55 08             	mov    0x8(%ebp),%edx
  8028a7:	89 50 04             	mov    %edx,0x4(%eax)
  8028aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8028b0:	89 10                	mov    %edx,(%eax)
  8028b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028b8:	89 50 04             	mov    %edx,0x4(%eax)
  8028bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8028be:	8b 00                	mov    (%eax),%eax
  8028c0:	85 c0                	test   %eax,%eax
  8028c2:	75 08                	jne    8028cc <insert_sorted_allocList+0x244>
  8028c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c7:	a3 44 50 80 00       	mov    %eax,0x805044
  8028cc:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8028d1:	40                   	inc    %eax
  8028d2:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8028d7:	eb 39                	jmp    802912 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8028d9:	a1 48 50 80 00       	mov    0x805048,%eax
  8028de:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028e5:	74 07                	je     8028ee <insert_sorted_allocList+0x266>
  8028e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ea:	8b 00                	mov    (%eax),%eax
  8028ec:	eb 05                	jmp    8028f3 <insert_sorted_allocList+0x26b>
  8028ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8028f3:	a3 48 50 80 00       	mov    %eax,0x805048
  8028f8:	a1 48 50 80 00       	mov    0x805048,%eax
  8028fd:	85 c0                	test   %eax,%eax
  8028ff:	0f 85 3f ff ff ff    	jne    802844 <insert_sorted_allocList+0x1bc>
  802905:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802909:	0f 85 35 ff ff ff    	jne    802844 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80290f:	eb 01                	jmp    802912 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802911:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802912:	90                   	nop
  802913:	c9                   	leave  
  802914:	c3                   	ret    

00802915 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802915:	55                   	push   %ebp
  802916:	89 e5                	mov    %esp,%ebp
  802918:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80291b:	a1 38 51 80 00       	mov    0x805138,%eax
  802920:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802923:	e9 85 01 00 00       	jmp    802aad <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802928:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292b:	8b 40 0c             	mov    0xc(%eax),%eax
  80292e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802931:	0f 82 6e 01 00 00    	jb     802aa5 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802937:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293a:	8b 40 0c             	mov    0xc(%eax),%eax
  80293d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802940:	0f 85 8a 00 00 00    	jne    8029d0 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802946:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80294a:	75 17                	jne    802963 <alloc_block_FF+0x4e>
  80294c:	83 ec 04             	sub    $0x4,%esp
  80294f:	68 c4 46 80 00       	push   $0x8046c4
  802954:	68 93 00 00 00       	push   $0x93
  802959:	68 1b 46 80 00       	push   $0x80461b
  80295e:	e8 1d de ff ff       	call   800780 <_panic>
  802963:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802966:	8b 00                	mov    (%eax),%eax
  802968:	85 c0                	test   %eax,%eax
  80296a:	74 10                	je     80297c <alloc_block_FF+0x67>
  80296c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296f:	8b 00                	mov    (%eax),%eax
  802971:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802974:	8b 52 04             	mov    0x4(%edx),%edx
  802977:	89 50 04             	mov    %edx,0x4(%eax)
  80297a:	eb 0b                	jmp    802987 <alloc_block_FF+0x72>
  80297c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297f:	8b 40 04             	mov    0x4(%eax),%eax
  802982:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802987:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298a:	8b 40 04             	mov    0x4(%eax),%eax
  80298d:	85 c0                	test   %eax,%eax
  80298f:	74 0f                	je     8029a0 <alloc_block_FF+0x8b>
  802991:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802994:	8b 40 04             	mov    0x4(%eax),%eax
  802997:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80299a:	8b 12                	mov    (%edx),%edx
  80299c:	89 10                	mov    %edx,(%eax)
  80299e:	eb 0a                	jmp    8029aa <alloc_block_FF+0x95>
  8029a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a3:	8b 00                	mov    (%eax),%eax
  8029a5:	a3 38 51 80 00       	mov    %eax,0x805138
  8029aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029bd:	a1 44 51 80 00       	mov    0x805144,%eax
  8029c2:	48                   	dec    %eax
  8029c3:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  8029c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029cb:	e9 10 01 00 00       	jmp    802ae0 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8029d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d3:	8b 40 0c             	mov    0xc(%eax),%eax
  8029d6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029d9:	0f 86 c6 00 00 00    	jbe    802aa5 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8029df:	a1 48 51 80 00       	mov    0x805148,%eax
  8029e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8029e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ea:	8b 50 08             	mov    0x8(%eax),%edx
  8029ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f0:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8029f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8029f9:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8029fc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a00:	75 17                	jne    802a19 <alloc_block_FF+0x104>
  802a02:	83 ec 04             	sub    $0x4,%esp
  802a05:	68 c4 46 80 00       	push   $0x8046c4
  802a0a:	68 9b 00 00 00       	push   $0x9b
  802a0f:	68 1b 46 80 00       	push   $0x80461b
  802a14:	e8 67 dd ff ff       	call   800780 <_panic>
  802a19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a1c:	8b 00                	mov    (%eax),%eax
  802a1e:	85 c0                	test   %eax,%eax
  802a20:	74 10                	je     802a32 <alloc_block_FF+0x11d>
  802a22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a25:	8b 00                	mov    (%eax),%eax
  802a27:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a2a:	8b 52 04             	mov    0x4(%edx),%edx
  802a2d:	89 50 04             	mov    %edx,0x4(%eax)
  802a30:	eb 0b                	jmp    802a3d <alloc_block_FF+0x128>
  802a32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a35:	8b 40 04             	mov    0x4(%eax),%eax
  802a38:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a40:	8b 40 04             	mov    0x4(%eax),%eax
  802a43:	85 c0                	test   %eax,%eax
  802a45:	74 0f                	je     802a56 <alloc_block_FF+0x141>
  802a47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a4a:	8b 40 04             	mov    0x4(%eax),%eax
  802a4d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a50:	8b 12                	mov    (%edx),%edx
  802a52:	89 10                	mov    %edx,(%eax)
  802a54:	eb 0a                	jmp    802a60 <alloc_block_FF+0x14b>
  802a56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a59:	8b 00                	mov    (%eax),%eax
  802a5b:	a3 48 51 80 00       	mov    %eax,0x805148
  802a60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a63:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a6c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a73:	a1 54 51 80 00       	mov    0x805154,%eax
  802a78:	48                   	dec    %eax
  802a79:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802a7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a81:	8b 50 08             	mov    0x8(%eax),%edx
  802a84:	8b 45 08             	mov    0x8(%ebp),%eax
  802a87:	01 c2                	add    %eax,%edx
  802a89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8c:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802a8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a92:	8b 40 0c             	mov    0xc(%eax),%eax
  802a95:	2b 45 08             	sub    0x8(%ebp),%eax
  802a98:	89 c2                	mov    %eax,%edx
  802a9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9d:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802aa0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aa3:	eb 3b                	jmp    802ae0 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802aa5:	a1 40 51 80 00       	mov    0x805140,%eax
  802aaa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802aad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ab1:	74 07                	je     802aba <alloc_block_FF+0x1a5>
  802ab3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab6:	8b 00                	mov    (%eax),%eax
  802ab8:	eb 05                	jmp    802abf <alloc_block_FF+0x1aa>
  802aba:	b8 00 00 00 00       	mov    $0x0,%eax
  802abf:	a3 40 51 80 00       	mov    %eax,0x805140
  802ac4:	a1 40 51 80 00       	mov    0x805140,%eax
  802ac9:	85 c0                	test   %eax,%eax
  802acb:	0f 85 57 fe ff ff    	jne    802928 <alloc_block_FF+0x13>
  802ad1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ad5:	0f 85 4d fe ff ff    	jne    802928 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802adb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ae0:	c9                   	leave  
  802ae1:	c3                   	ret    

00802ae2 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802ae2:	55                   	push   %ebp
  802ae3:	89 e5                	mov    %esp,%ebp
  802ae5:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802ae8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802aef:	a1 38 51 80 00       	mov    0x805138,%eax
  802af4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802af7:	e9 df 00 00 00       	jmp    802bdb <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802afc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aff:	8b 40 0c             	mov    0xc(%eax),%eax
  802b02:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b05:	0f 82 c8 00 00 00    	jb     802bd3 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802b0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0e:	8b 40 0c             	mov    0xc(%eax),%eax
  802b11:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b14:	0f 85 8a 00 00 00    	jne    802ba4 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802b1a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b1e:	75 17                	jne    802b37 <alloc_block_BF+0x55>
  802b20:	83 ec 04             	sub    $0x4,%esp
  802b23:	68 c4 46 80 00       	push   $0x8046c4
  802b28:	68 b7 00 00 00       	push   $0xb7
  802b2d:	68 1b 46 80 00       	push   $0x80461b
  802b32:	e8 49 dc ff ff       	call   800780 <_panic>
  802b37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3a:	8b 00                	mov    (%eax),%eax
  802b3c:	85 c0                	test   %eax,%eax
  802b3e:	74 10                	je     802b50 <alloc_block_BF+0x6e>
  802b40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b43:	8b 00                	mov    (%eax),%eax
  802b45:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b48:	8b 52 04             	mov    0x4(%edx),%edx
  802b4b:	89 50 04             	mov    %edx,0x4(%eax)
  802b4e:	eb 0b                	jmp    802b5b <alloc_block_BF+0x79>
  802b50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b53:	8b 40 04             	mov    0x4(%eax),%eax
  802b56:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5e:	8b 40 04             	mov    0x4(%eax),%eax
  802b61:	85 c0                	test   %eax,%eax
  802b63:	74 0f                	je     802b74 <alloc_block_BF+0x92>
  802b65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b68:	8b 40 04             	mov    0x4(%eax),%eax
  802b6b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b6e:	8b 12                	mov    (%edx),%edx
  802b70:	89 10                	mov    %edx,(%eax)
  802b72:	eb 0a                	jmp    802b7e <alloc_block_BF+0x9c>
  802b74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b77:	8b 00                	mov    (%eax),%eax
  802b79:	a3 38 51 80 00       	mov    %eax,0x805138
  802b7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b81:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b91:	a1 44 51 80 00       	mov    0x805144,%eax
  802b96:	48                   	dec    %eax
  802b97:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802b9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9f:	e9 4d 01 00 00       	jmp    802cf1 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802ba4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba7:	8b 40 0c             	mov    0xc(%eax),%eax
  802baa:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bad:	76 24                	jbe    802bd3 <alloc_block_BF+0xf1>
  802baf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb2:	8b 40 0c             	mov    0xc(%eax),%eax
  802bb5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802bb8:	73 19                	jae    802bd3 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802bba:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802bc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc4:	8b 40 0c             	mov    0xc(%eax),%eax
  802bc7:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802bca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bcd:	8b 40 08             	mov    0x8(%eax),%eax
  802bd0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802bd3:	a1 40 51 80 00       	mov    0x805140,%eax
  802bd8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bdb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bdf:	74 07                	je     802be8 <alloc_block_BF+0x106>
  802be1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be4:	8b 00                	mov    (%eax),%eax
  802be6:	eb 05                	jmp    802bed <alloc_block_BF+0x10b>
  802be8:	b8 00 00 00 00       	mov    $0x0,%eax
  802bed:	a3 40 51 80 00       	mov    %eax,0x805140
  802bf2:	a1 40 51 80 00       	mov    0x805140,%eax
  802bf7:	85 c0                	test   %eax,%eax
  802bf9:	0f 85 fd fe ff ff    	jne    802afc <alloc_block_BF+0x1a>
  802bff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c03:	0f 85 f3 fe ff ff    	jne    802afc <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802c09:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802c0d:	0f 84 d9 00 00 00    	je     802cec <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802c13:	a1 48 51 80 00       	mov    0x805148,%eax
  802c18:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802c1b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c1e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c21:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802c24:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c27:	8b 55 08             	mov    0x8(%ebp),%edx
  802c2a:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802c2d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802c31:	75 17                	jne    802c4a <alloc_block_BF+0x168>
  802c33:	83 ec 04             	sub    $0x4,%esp
  802c36:	68 c4 46 80 00       	push   $0x8046c4
  802c3b:	68 c7 00 00 00       	push   $0xc7
  802c40:	68 1b 46 80 00       	push   $0x80461b
  802c45:	e8 36 db ff ff       	call   800780 <_panic>
  802c4a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c4d:	8b 00                	mov    (%eax),%eax
  802c4f:	85 c0                	test   %eax,%eax
  802c51:	74 10                	je     802c63 <alloc_block_BF+0x181>
  802c53:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c56:	8b 00                	mov    (%eax),%eax
  802c58:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c5b:	8b 52 04             	mov    0x4(%edx),%edx
  802c5e:	89 50 04             	mov    %edx,0x4(%eax)
  802c61:	eb 0b                	jmp    802c6e <alloc_block_BF+0x18c>
  802c63:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c66:	8b 40 04             	mov    0x4(%eax),%eax
  802c69:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c6e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c71:	8b 40 04             	mov    0x4(%eax),%eax
  802c74:	85 c0                	test   %eax,%eax
  802c76:	74 0f                	je     802c87 <alloc_block_BF+0x1a5>
  802c78:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c7b:	8b 40 04             	mov    0x4(%eax),%eax
  802c7e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c81:	8b 12                	mov    (%edx),%edx
  802c83:	89 10                	mov    %edx,(%eax)
  802c85:	eb 0a                	jmp    802c91 <alloc_block_BF+0x1af>
  802c87:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c8a:	8b 00                	mov    (%eax),%eax
  802c8c:	a3 48 51 80 00       	mov    %eax,0x805148
  802c91:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c94:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c9a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c9d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ca4:	a1 54 51 80 00       	mov    0x805154,%eax
  802ca9:	48                   	dec    %eax
  802caa:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802caf:	83 ec 08             	sub    $0x8,%esp
  802cb2:	ff 75 ec             	pushl  -0x14(%ebp)
  802cb5:	68 38 51 80 00       	push   $0x805138
  802cba:	e8 71 f9 ff ff       	call   802630 <find_block>
  802cbf:	83 c4 10             	add    $0x10,%esp
  802cc2:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802cc5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cc8:	8b 50 08             	mov    0x8(%eax),%edx
  802ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  802cce:	01 c2                	add    %eax,%edx
  802cd0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cd3:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802cd6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cd9:	8b 40 0c             	mov    0xc(%eax),%eax
  802cdc:	2b 45 08             	sub    0x8(%ebp),%eax
  802cdf:	89 c2                	mov    %eax,%edx
  802ce1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ce4:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802ce7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cea:	eb 05                	jmp    802cf1 <alloc_block_BF+0x20f>
	}
	return NULL;
  802cec:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802cf1:	c9                   	leave  
  802cf2:	c3                   	ret    

00802cf3 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802cf3:	55                   	push   %ebp
  802cf4:	89 e5                	mov    %esp,%ebp
  802cf6:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802cf9:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802cfe:	85 c0                	test   %eax,%eax
  802d00:	0f 85 de 01 00 00    	jne    802ee4 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802d06:	a1 38 51 80 00       	mov    0x805138,%eax
  802d0b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d0e:	e9 9e 01 00 00       	jmp    802eb1 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802d13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d16:	8b 40 0c             	mov    0xc(%eax),%eax
  802d19:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d1c:	0f 82 87 01 00 00    	jb     802ea9 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802d22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d25:	8b 40 0c             	mov    0xc(%eax),%eax
  802d28:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d2b:	0f 85 95 00 00 00    	jne    802dc6 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802d31:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d35:	75 17                	jne    802d4e <alloc_block_NF+0x5b>
  802d37:	83 ec 04             	sub    $0x4,%esp
  802d3a:	68 c4 46 80 00       	push   $0x8046c4
  802d3f:	68 e0 00 00 00       	push   $0xe0
  802d44:	68 1b 46 80 00       	push   $0x80461b
  802d49:	e8 32 da ff ff       	call   800780 <_panic>
  802d4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d51:	8b 00                	mov    (%eax),%eax
  802d53:	85 c0                	test   %eax,%eax
  802d55:	74 10                	je     802d67 <alloc_block_NF+0x74>
  802d57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5a:	8b 00                	mov    (%eax),%eax
  802d5c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d5f:	8b 52 04             	mov    0x4(%edx),%edx
  802d62:	89 50 04             	mov    %edx,0x4(%eax)
  802d65:	eb 0b                	jmp    802d72 <alloc_block_NF+0x7f>
  802d67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6a:	8b 40 04             	mov    0x4(%eax),%eax
  802d6d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d75:	8b 40 04             	mov    0x4(%eax),%eax
  802d78:	85 c0                	test   %eax,%eax
  802d7a:	74 0f                	je     802d8b <alloc_block_NF+0x98>
  802d7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7f:	8b 40 04             	mov    0x4(%eax),%eax
  802d82:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d85:	8b 12                	mov    (%edx),%edx
  802d87:	89 10                	mov    %edx,(%eax)
  802d89:	eb 0a                	jmp    802d95 <alloc_block_NF+0xa2>
  802d8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8e:	8b 00                	mov    (%eax),%eax
  802d90:	a3 38 51 80 00       	mov    %eax,0x805138
  802d95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d98:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802da8:	a1 44 51 80 00       	mov    0x805144,%eax
  802dad:	48                   	dec    %eax
  802dae:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802db3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db6:	8b 40 08             	mov    0x8(%eax),%eax
  802db9:	a3 2c 50 80 00       	mov    %eax,0x80502c
				   return  point;
  802dbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc1:	e9 f8 04 00 00       	jmp    8032be <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802dc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc9:	8b 40 0c             	mov    0xc(%eax),%eax
  802dcc:	3b 45 08             	cmp    0x8(%ebp),%eax
  802dcf:	0f 86 d4 00 00 00    	jbe    802ea9 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802dd5:	a1 48 51 80 00       	mov    0x805148,%eax
  802dda:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802ddd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de0:	8b 50 08             	mov    0x8(%eax),%edx
  802de3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de6:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802de9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dec:	8b 55 08             	mov    0x8(%ebp),%edx
  802def:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802df2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802df6:	75 17                	jne    802e0f <alloc_block_NF+0x11c>
  802df8:	83 ec 04             	sub    $0x4,%esp
  802dfb:	68 c4 46 80 00       	push   $0x8046c4
  802e00:	68 e9 00 00 00       	push   $0xe9
  802e05:	68 1b 46 80 00       	push   $0x80461b
  802e0a:	e8 71 d9 ff ff       	call   800780 <_panic>
  802e0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e12:	8b 00                	mov    (%eax),%eax
  802e14:	85 c0                	test   %eax,%eax
  802e16:	74 10                	je     802e28 <alloc_block_NF+0x135>
  802e18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e1b:	8b 00                	mov    (%eax),%eax
  802e1d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e20:	8b 52 04             	mov    0x4(%edx),%edx
  802e23:	89 50 04             	mov    %edx,0x4(%eax)
  802e26:	eb 0b                	jmp    802e33 <alloc_block_NF+0x140>
  802e28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e2b:	8b 40 04             	mov    0x4(%eax),%eax
  802e2e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e36:	8b 40 04             	mov    0x4(%eax),%eax
  802e39:	85 c0                	test   %eax,%eax
  802e3b:	74 0f                	je     802e4c <alloc_block_NF+0x159>
  802e3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e40:	8b 40 04             	mov    0x4(%eax),%eax
  802e43:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e46:	8b 12                	mov    (%edx),%edx
  802e48:	89 10                	mov    %edx,(%eax)
  802e4a:	eb 0a                	jmp    802e56 <alloc_block_NF+0x163>
  802e4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e4f:	8b 00                	mov    (%eax),%eax
  802e51:	a3 48 51 80 00       	mov    %eax,0x805148
  802e56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e59:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e62:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e69:	a1 54 51 80 00       	mov    0x805154,%eax
  802e6e:	48                   	dec    %eax
  802e6f:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802e74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e77:	8b 40 08             	mov    0x8(%eax),%eax
  802e7a:	a3 2c 50 80 00       	mov    %eax,0x80502c
				   point->sva += size;
  802e7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e82:	8b 50 08             	mov    0x8(%eax),%edx
  802e85:	8b 45 08             	mov    0x8(%ebp),%eax
  802e88:	01 c2                	add    %eax,%edx
  802e8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8d:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802e90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e93:	8b 40 0c             	mov    0xc(%eax),%eax
  802e96:	2b 45 08             	sub    0x8(%ebp),%eax
  802e99:	89 c2                	mov    %eax,%edx
  802e9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9e:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802ea1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ea4:	e9 15 04 00 00       	jmp    8032be <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802ea9:	a1 40 51 80 00       	mov    0x805140,%eax
  802eae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802eb1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802eb5:	74 07                	je     802ebe <alloc_block_NF+0x1cb>
  802eb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eba:	8b 00                	mov    (%eax),%eax
  802ebc:	eb 05                	jmp    802ec3 <alloc_block_NF+0x1d0>
  802ebe:	b8 00 00 00 00       	mov    $0x0,%eax
  802ec3:	a3 40 51 80 00       	mov    %eax,0x805140
  802ec8:	a1 40 51 80 00       	mov    0x805140,%eax
  802ecd:	85 c0                	test   %eax,%eax
  802ecf:	0f 85 3e fe ff ff    	jne    802d13 <alloc_block_NF+0x20>
  802ed5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ed9:	0f 85 34 fe ff ff    	jne    802d13 <alloc_block_NF+0x20>
  802edf:	e9 d5 03 00 00       	jmp    8032b9 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802ee4:	a1 38 51 80 00       	mov    0x805138,%eax
  802ee9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802eec:	e9 b1 01 00 00       	jmp    8030a2 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802ef1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef4:	8b 50 08             	mov    0x8(%eax),%edx
  802ef7:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802efc:	39 c2                	cmp    %eax,%edx
  802efe:	0f 82 96 01 00 00    	jb     80309a <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802f04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f07:	8b 40 0c             	mov    0xc(%eax),%eax
  802f0a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f0d:	0f 82 87 01 00 00    	jb     80309a <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802f13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f16:	8b 40 0c             	mov    0xc(%eax),%eax
  802f19:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f1c:	0f 85 95 00 00 00    	jne    802fb7 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802f22:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f26:	75 17                	jne    802f3f <alloc_block_NF+0x24c>
  802f28:	83 ec 04             	sub    $0x4,%esp
  802f2b:	68 c4 46 80 00       	push   $0x8046c4
  802f30:	68 fc 00 00 00       	push   $0xfc
  802f35:	68 1b 46 80 00       	push   $0x80461b
  802f3a:	e8 41 d8 ff ff       	call   800780 <_panic>
  802f3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f42:	8b 00                	mov    (%eax),%eax
  802f44:	85 c0                	test   %eax,%eax
  802f46:	74 10                	je     802f58 <alloc_block_NF+0x265>
  802f48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4b:	8b 00                	mov    (%eax),%eax
  802f4d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f50:	8b 52 04             	mov    0x4(%edx),%edx
  802f53:	89 50 04             	mov    %edx,0x4(%eax)
  802f56:	eb 0b                	jmp    802f63 <alloc_block_NF+0x270>
  802f58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5b:	8b 40 04             	mov    0x4(%eax),%eax
  802f5e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f66:	8b 40 04             	mov    0x4(%eax),%eax
  802f69:	85 c0                	test   %eax,%eax
  802f6b:	74 0f                	je     802f7c <alloc_block_NF+0x289>
  802f6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f70:	8b 40 04             	mov    0x4(%eax),%eax
  802f73:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f76:	8b 12                	mov    (%edx),%edx
  802f78:	89 10                	mov    %edx,(%eax)
  802f7a:	eb 0a                	jmp    802f86 <alloc_block_NF+0x293>
  802f7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7f:	8b 00                	mov    (%eax),%eax
  802f81:	a3 38 51 80 00       	mov    %eax,0x805138
  802f86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f89:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f92:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f99:	a1 44 51 80 00       	mov    0x805144,%eax
  802f9e:	48                   	dec    %eax
  802f9f:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802fa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa7:	8b 40 08             	mov    0x8(%eax),%eax
  802faa:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   return  point;
  802faf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb2:	e9 07 03 00 00       	jmp    8032be <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802fb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fba:	8b 40 0c             	mov    0xc(%eax),%eax
  802fbd:	3b 45 08             	cmp    0x8(%ebp),%eax
  802fc0:	0f 86 d4 00 00 00    	jbe    80309a <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802fc6:	a1 48 51 80 00       	mov    0x805148,%eax
  802fcb:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802fce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd1:	8b 50 08             	mov    0x8(%eax),%edx
  802fd4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fd7:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802fda:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fdd:	8b 55 08             	mov    0x8(%ebp),%edx
  802fe0:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802fe3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802fe7:	75 17                	jne    803000 <alloc_block_NF+0x30d>
  802fe9:	83 ec 04             	sub    $0x4,%esp
  802fec:	68 c4 46 80 00       	push   $0x8046c4
  802ff1:	68 04 01 00 00       	push   $0x104
  802ff6:	68 1b 46 80 00       	push   $0x80461b
  802ffb:	e8 80 d7 ff ff       	call   800780 <_panic>
  803000:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803003:	8b 00                	mov    (%eax),%eax
  803005:	85 c0                	test   %eax,%eax
  803007:	74 10                	je     803019 <alloc_block_NF+0x326>
  803009:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80300c:	8b 00                	mov    (%eax),%eax
  80300e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803011:	8b 52 04             	mov    0x4(%edx),%edx
  803014:	89 50 04             	mov    %edx,0x4(%eax)
  803017:	eb 0b                	jmp    803024 <alloc_block_NF+0x331>
  803019:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80301c:	8b 40 04             	mov    0x4(%eax),%eax
  80301f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803024:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803027:	8b 40 04             	mov    0x4(%eax),%eax
  80302a:	85 c0                	test   %eax,%eax
  80302c:	74 0f                	je     80303d <alloc_block_NF+0x34a>
  80302e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803031:	8b 40 04             	mov    0x4(%eax),%eax
  803034:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803037:	8b 12                	mov    (%edx),%edx
  803039:	89 10                	mov    %edx,(%eax)
  80303b:	eb 0a                	jmp    803047 <alloc_block_NF+0x354>
  80303d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803040:	8b 00                	mov    (%eax),%eax
  803042:	a3 48 51 80 00       	mov    %eax,0x805148
  803047:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80304a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803050:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803053:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80305a:	a1 54 51 80 00       	mov    0x805154,%eax
  80305f:	48                   	dec    %eax
  803060:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  803065:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803068:	8b 40 08             	mov    0x8(%eax),%eax
  80306b:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   point->sva += size;
  803070:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803073:	8b 50 08             	mov    0x8(%eax),%edx
  803076:	8b 45 08             	mov    0x8(%ebp),%eax
  803079:	01 c2                	add    %eax,%edx
  80307b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80307e:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803081:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803084:	8b 40 0c             	mov    0xc(%eax),%eax
  803087:	2b 45 08             	sub    0x8(%ebp),%eax
  80308a:	89 c2                	mov    %eax,%edx
  80308c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80308f:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803092:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803095:	e9 24 02 00 00       	jmp    8032be <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  80309a:	a1 40 51 80 00       	mov    0x805140,%eax
  80309f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030a6:	74 07                	je     8030af <alloc_block_NF+0x3bc>
  8030a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ab:	8b 00                	mov    (%eax),%eax
  8030ad:	eb 05                	jmp    8030b4 <alloc_block_NF+0x3c1>
  8030af:	b8 00 00 00 00       	mov    $0x0,%eax
  8030b4:	a3 40 51 80 00       	mov    %eax,0x805140
  8030b9:	a1 40 51 80 00       	mov    0x805140,%eax
  8030be:	85 c0                	test   %eax,%eax
  8030c0:	0f 85 2b fe ff ff    	jne    802ef1 <alloc_block_NF+0x1fe>
  8030c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030ca:	0f 85 21 fe ff ff    	jne    802ef1 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8030d0:	a1 38 51 80 00       	mov    0x805138,%eax
  8030d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030d8:	e9 ae 01 00 00       	jmp    80328b <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  8030dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e0:	8b 50 08             	mov    0x8(%eax),%edx
  8030e3:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8030e8:	39 c2                	cmp    %eax,%edx
  8030ea:	0f 83 93 01 00 00    	jae    803283 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  8030f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f3:	8b 40 0c             	mov    0xc(%eax),%eax
  8030f6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030f9:	0f 82 84 01 00 00    	jb     803283 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  8030ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803102:	8b 40 0c             	mov    0xc(%eax),%eax
  803105:	3b 45 08             	cmp    0x8(%ebp),%eax
  803108:	0f 85 95 00 00 00    	jne    8031a3 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  80310e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803112:	75 17                	jne    80312b <alloc_block_NF+0x438>
  803114:	83 ec 04             	sub    $0x4,%esp
  803117:	68 c4 46 80 00       	push   $0x8046c4
  80311c:	68 14 01 00 00       	push   $0x114
  803121:	68 1b 46 80 00       	push   $0x80461b
  803126:	e8 55 d6 ff ff       	call   800780 <_panic>
  80312b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80312e:	8b 00                	mov    (%eax),%eax
  803130:	85 c0                	test   %eax,%eax
  803132:	74 10                	je     803144 <alloc_block_NF+0x451>
  803134:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803137:	8b 00                	mov    (%eax),%eax
  803139:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80313c:	8b 52 04             	mov    0x4(%edx),%edx
  80313f:	89 50 04             	mov    %edx,0x4(%eax)
  803142:	eb 0b                	jmp    80314f <alloc_block_NF+0x45c>
  803144:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803147:	8b 40 04             	mov    0x4(%eax),%eax
  80314a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80314f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803152:	8b 40 04             	mov    0x4(%eax),%eax
  803155:	85 c0                	test   %eax,%eax
  803157:	74 0f                	je     803168 <alloc_block_NF+0x475>
  803159:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80315c:	8b 40 04             	mov    0x4(%eax),%eax
  80315f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803162:	8b 12                	mov    (%edx),%edx
  803164:	89 10                	mov    %edx,(%eax)
  803166:	eb 0a                	jmp    803172 <alloc_block_NF+0x47f>
  803168:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80316b:	8b 00                	mov    (%eax),%eax
  80316d:	a3 38 51 80 00       	mov    %eax,0x805138
  803172:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803175:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80317b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80317e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803185:	a1 44 51 80 00       	mov    0x805144,%eax
  80318a:	48                   	dec    %eax
  80318b:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  803190:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803193:	8b 40 08             	mov    0x8(%eax),%eax
  803196:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   return  point;
  80319b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80319e:	e9 1b 01 00 00       	jmp    8032be <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8031a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a6:	8b 40 0c             	mov    0xc(%eax),%eax
  8031a9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031ac:	0f 86 d1 00 00 00    	jbe    803283 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8031b2:	a1 48 51 80 00       	mov    0x805148,%eax
  8031b7:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  8031ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031bd:	8b 50 08             	mov    0x8(%eax),%edx
  8031c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031c3:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8031c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031c9:	8b 55 08             	mov    0x8(%ebp),%edx
  8031cc:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8031cf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8031d3:	75 17                	jne    8031ec <alloc_block_NF+0x4f9>
  8031d5:	83 ec 04             	sub    $0x4,%esp
  8031d8:	68 c4 46 80 00       	push   $0x8046c4
  8031dd:	68 1c 01 00 00       	push   $0x11c
  8031e2:	68 1b 46 80 00       	push   $0x80461b
  8031e7:	e8 94 d5 ff ff       	call   800780 <_panic>
  8031ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031ef:	8b 00                	mov    (%eax),%eax
  8031f1:	85 c0                	test   %eax,%eax
  8031f3:	74 10                	je     803205 <alloc_block_NF+0x512>
  8031f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031f8:	8b 00                	mov    (%eax),%eax
  8031fa:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8031fd:	8b 52 04             	mov    0x4(%edx),%edx
  803200:	89 50 04             	mov    %edx,0x4(%eax)
  803203:	eb 0b                	jmp    803210 <alloc_block_NF+0x51d>
  803205:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803208:	8b 40 04             	mov    0x4(%eax),%eax
  80320b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803210:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803213:	8b 40 04             	mov    0x4(%eax),%eax
  803216:	85 c0                	test   %eax,%eax
  803218:	74 0f                	je     803229 <alloc_block_NF+0x536>
  80321a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80321d:	8b 40 04             	mov    0x4(%eax),%eax
  803220:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803223:	8b 12                	mov    (%edx),%edx
  803225:	89 10                	mov    %edx,(%eax)
  803227:	eb 0a                	jmp    803233 <alloc_block_NF+0x540>
  803229:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80322c:	8b 00                	mov    (%eax),%eax
  80322e:	a3 48 51 80 00       	mov    %eax,0x805148
  803233:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803236:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80323c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80323f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803246:	a1 54 51 80 00       	mov    0x805154,%eax
  80324b:	48                   	dec    %eax
  80324c:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  803251:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803254:	8b 40 08             	mov    0x8(%eax),%eax
  803257:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   point->sva += size;
  80325c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80325f:	8b 50 08             	mov    0x8(%eax),%edx
  803262:	8b 45 08             	mov    0x8(%ebp),%eax
  803265:	01 c2                	add    %eax,%edx
  803267:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80326a:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  80326d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803270:	8b 40 0c             	mov    0xc(%eax),%eax
  803273:	2b 45 08             	sub    0x8(%ebp),%eax
  803276:	89 c2                	mov    %eax,%edx
  803278:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80327b:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  80327e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803281:	eb 3b                	jmp    8032be <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803283:	a1 40 51 80 00       	mov    0x805140,%eax
  803288:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80328b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80328f:	74 07                	je     803298 <alloc_block_NF+0x5a5>
  803291:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803294:	8b 00                	mov    (%eax),%eax
  803296:	eb 05                	jmp    80329d <alloc_block_NF+0x5aa>
  803298:	b8 00 00 00 00       	mov    $0x0,%eax
  80329d:	a3 40 51 80 00       	mov    %eax,0x805140
  8032a2:	a1 40 51 80 00       	mov    0x805140,%eax
  8032a7:	85 c0                	test   %eax,%eax
  8032a9:	0f 85 2e fe ff ff    	jne    8030dd <alloc_block_NF+0x3ea>
  8032af:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032b3:	0f 85 24 fe ff ff    	jne    8030dd <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  8032b9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8032be:	c9                   	leave  
  8032bf:	c3                   	ret    

008032c0 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8032c0:	55                   	push   %ebp
  8032c1:	89 e5                	mov    %esp,%ebp
  8032c3:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  8032c6:	a1 38 51 80 00       	mov    0x805138,%eax
  8032cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  8032ce:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8032d3:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  8032d6:	a1 38 51 80 00       	mov    0x805138,%eax
  8032db:	85 c0                	test   %eax,%eax
  8032dd:	74 14                	je     8032f3 <insert_sorted_with_merge_freeList+0x33>
  8032df:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e2:	8b 50 08             	mov    0x8(%eax),%edx
  8032e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032e8:	8b 40 08             	mov    0x8(%eax),%eax
  8032eb:	39 c2                	cmp    %eax,%edx
  8032ed:	0f 87 9b 01 00 00    	ja     80348e <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  8032f3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032f7:	75 17                	jne    803310 <insert_sorted_with_merge_freeList+0x50>
  8032f9:	83 ec 04             	sub    $0x4,%esp
  8032fc:	68 f8 45 80 00       	push   $0x8045f8
  803301:	68 38 01 00 00       	push   $0x138
  803306:	68 1b 46 80 00       	push   $0x80461b
  80330b:	e8 70 d4 ff ff       	call   800780 <_panic>
  803310:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803316:	8b 45 08             	mov    0x8(%ebp),%eax
  803319:	89 10                	mov    %edx,(%eax)
  80331b:	8b 45 08             	mov    0x8(%ebp),%eax
  80331e:	8b 00                	mov    (%eax),%eax
  803320:	85 c0                	test   %eax,%eax
  803322:	74 0d                	je     803331 <insert_sorted_with_merge_freeList+0x71>
  803324:	a1 38 51 80 00       	mov    0x805138,%eax
  803329:	8b 55 08             	mov    0x8(%ebp),%edx
  80332c:	89 50 04             	mov    %edx,0x4(%eax)
  80332f:	eb 08                	jmp    803339 <insert_sorted_with_merge_freeList+0x79>
  803331:	8b 45 08             	mov    0x8(%ebp),%eax
  803334:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803339:	8b 45 08             	mov    0x8(%ebp),%eax
  80333c:	a3 38 51 80 00       	mov    %eax,0x805138
  803341:	8b 45 08             	mov    0x8(%ebp),%eax
  803344:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80334b:	a1 44 51 80 00       	mov    0x805144,%eax
  803350:	40                   	inc    %eax
  803351:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803356:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80335a:	0f 84 a8 06 00 00    	je     803a08 <insert_sorted_with_merge_freeList+0x748>
  803360:	8b 45 08             	mov    0x8(%ebp),%eax
  803363:	8b 50 08             	mov    0x8(%eax),%edx
  803366:	8b 45 08             	mov    0x8(%ebp),%eax
  803369:	8b 40 0c             	mov    0xc(%eax),%eax
  80336c:	01 c2                	add    %eax,%edx
  80336e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803371:	8b 40 08             	mov    0x8(%eax),%eax
  803374:	39 c2                	cmp    %eax,%edx
  803376:	0f 85 8c 06 00 00    	jne    803a08 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  80337c:	8b 45 08             	mov    0x8(%ebp),%eax
  80337f:	8b 50 0c             	mov    0xc(%eax),%edx
  803382:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803385:	8b 40 0c             	mov    0xc(%eax),%eax
  803388:	01 c2                	add    %eax,%edx
  80338a:	8b 45 08             	mov    0x8(%ebp),%eax
  80338d:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  803390:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803394:	75 17                	jne    8033ad <insert_sorted_with_merge_freeList+0xed>
  803396:	83 ec 04             	sub    $0x4,%esp
  803399:	68 c4 46 80 00       	push   $0x8046c4
  80339e:	68 3c 01 00 00       	push   $0x13c
  8033a3:	68 1b 46 80 00       	push   $0x80461b
  8033a8:	e8 d3 d3 ff ff       	call   800780 <_panic>
  8033ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033b0:	8b 00                	mov    (%eax),%eax
  8033b2:	85 c0                	test   %eax,%eax
  8033b4:	74 10                	je     8033c6 <insert_sorted_with_merge_freeList+0x106>
  8033b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033b9:	8b 00                	mov    (%eax),%eax
  8033bb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8033be:	8b 52 04             	mov    0x4(%edx),%edx
  8033c1:	89 50 04             	mov    %edx,0x4(%eax)
  8033c4:	eb 0b                	jmp    8033d1 <insert_sorted_with_merge_freeList+0x111>
  8033c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033c9:	8b 40 04             	mov    0x4(%eax),%eax
  8033cc:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8033d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033d4:	8b 40 04             	mov    0x4(%eax),%eax
  8033d7:	85 c0                	test   %eax,%eax
  8033d9:	74 0f                	je     8033ea <insert_sorted_with_merge_freeList+0x12a>
  8033db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033de:	8b 40 04             	mov    0x4(%eax),%eax
  8033e1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8033e4:	8b 12                	mov    (%edx),%edx
  8033e6:	89 10                	mov    %edx,(%eax)
  8033e8:	eb 0a                	jmp    8033f4 <insert_sorted_with_merge_freeList+0x134>
  8033ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033ed:	8b 00                	mov    (%eax),%eax
  8033ef:	a3 38 51 80 00       	mov    %eax,0x805138
  8033f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033f7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803400:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803407:	a1 44 51 80 00       	mov    0x805144,%eax
  80340c:	48                   	dec    %eax
  80340d:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  803412:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803415:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  80341c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80341f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  803426:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80342a:	75 17                	jne    803443 <insert_sorted_with_merge_freeList+0x183>
  80342c:	83 ec 04             	sub    $0x4,%esp
  80342f:	68 f8 45 80 00       	push   $0x8045f8
  803434:	68 3f 01 00 00       	push   $0x13f
  803439:	68 1b 46 80 00       	push   $0x80461b
  80343e:	e8 3d d3 ff ff       	call   800780 <_panic>
  803443:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803449:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80344c:	89 10                	mov    %edx,(%eax)
  80344e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803451:	8b 00                	mov    (%eax),%eax
  803453:	85 c0                	test   %eax,%eax
  803455:	74 0d                	je     803464 <insert_sorted_with_merge_freeList+0x1a4>
  803457:	a1 48 51 80 00       	mov    0x805148,%eax
  80345c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80345f:	89 50 04             	mov    %edx,0x4(%eax)
  803462:	eb 08                	jmp    80346c <insert_sorted_with_merge_freeList+0x1ac>
  803464:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803467:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80346c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80346f:	a3 48 51 80 00       	mov    %eax,0x805148
  803474:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803477:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80347e:	a1 54 51 80 00       	mov    0x805154,%eax
  803483:	40                   	inc    %eax
  803484:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803489:	e9 7a 05 00 00       	jmp    803a08 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  80348e:	8b 45 08             	mov    0x8(%ebp),%eax
  803491:	8b 50 08             	mov    0x8(%eax),%edx
  803494:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803497:	8b 40 08             	mov    0x8(%eax),%eax
  80349a:	39 c2                	cmp    %eax,%edx
  80349c:	0f 82 14 01 00 00    	jb     8035b6 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  8034a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034a5:	8b 50 08             	mov    0x8(%eax),%edx
  8034a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034ab:	8b 40 0c             	mov    0xc(%eax),%eax
  8034ae:	01 c2                	add    %eax,%edx
  8034b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b3:	8b 40 08             	mov    0x8(%eax),%eax
  8034b6:	39 c2                	cmp    %eax,%edx
  8034b8:	0f 85 90 00 00 00    	jne    80354e <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  8034be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034c1:	8b 50 0c             	mov    0xc(%eax),%edx
  8034c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c7:	8b 40 0c             	mov    0xc(%eax),%eax
  8034ca:	01 c2                	add    %eax,%edx
  8034cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034cf:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  8034d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  8034dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8034df:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8034e6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034ea:	75 17                	jne    803503 <insert_sorted_with_merge_freeList+0x243>
  8034ec:	83 ec 04             	sub    $0x4,%esp
  8034ef:	68 f8 45 80 00       	push   $0x8045f8
  8034f4:	68 49 01 00 00       	push   $0x149
  8034f9:	68 1b 46 80 00       	push   $0x80461b
  8034fe:	e8 7d d2 ff ff       	call   800780 <_panic>
  803503:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803509:	8b 45 08             	mov    0x8(%ebp),%eax
  80350c:	89 10                	mov    %edx,(%eax)
  80350e:	8b 45 08             	mov    0x8(%ebp),%eax
  803511:	8b 00                	mov    (%eax),%eax
  803513:	85 c0                	test   %eax,%eax
  803515:	74 0d                	je     803524 <insert_sorted_with_merge_freeList+0x264>
  803517:	a1 48 51 80 00       	mov    0x805148,%eax
  80351c:	8b 55 08             	mov    0x8(%ebp),%edx
  80351f:	89 50 04             	mov    %edx,0x4(%eax)
  803522:	eb 08                	jmp    80352c <insert_sorted_with_merge_freeList+0x26c>
  803524:	8b 45 08             	mov    0x8(%ebp),%eax
  803527:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80352c:	8b 45 08             	mov    0x8(%ebp),%eax
  80352f:	a3 48 51 80 00       	mov    %eax,0x805148
  803534:	8b 45 08             	mov    0x8(%ebp),%eax
  803537:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80353e:	a1 54 51 80 00       	mov    0x805154,%eax
  803543:	40                   	inc    %eax
  803544:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803549:	e9 bb 04 00 00       	jmp    803a09 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  80354e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803552:	75 17                	jne    80356b <insert_sorted_with_merge_freeList+0x2ab>
  803554:	83 ec 04             	sub    $0x4,%esp
  803557:	68 6c 46 80 00       	push   $0x80466c
  80355c:	68 4c 01 00 00       	push   $0x14c
  803561:	68 1b 46 80 00       	push   $0x80461b
  803566:	e8 15 d2 ff ff       	call   800780 <_panic>
  80356b:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803571:	8b 45 08             	mov    0x8(%ebp),%eax
  803574:	89 50 04             	mov    %edx,0x4(%eax)
  803577:	8b 45 08             	mov    0x8(%ebp),%eax
  80357a:	8b 40 04             	mov    0x4(%eax),%eax
  80357d:	85 c0                	test   %eax,%eax
  80357f:	74 0c                	je     80358d <insert_sorted_with_merge_freeList+0x2cd>
  803581:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803586:	8b 55 08             	mov    0x8(%ebp),%edx
  803589:	89 10                	mov    %edx,(%eax)
  80358b:	eb 08                	jmp    803595 <insert_sorted_with_merge_freeList+0x2d5>
  80358d:	8b 45 08             	mov    0x8(%ebp),%eax
  803590:	a3 38 51 80 00       	mov    %eax,0x805138
  803595:	8b 45 08             	mov    0x8(%ebp),%eax
  803598:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80359d:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035a6:	a1 44 51 80 00       	mov    0x805144,%eax
  8035ab:	40                   	inc    %eax
  8035ac:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8035b1:	e9 53 04 00 00       	jmp    803a09 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8035b6:	a1 38 51 80 00       	mov    0x805138,%eax
  8035bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8035be:	e9 15 04 00 00       	jmp    8039d8 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  8035c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035c6:	8b 00                	mov    (%eax),%eax
  8035c8:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  8035cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ce:	8b 50 08             	mov    0x8(%eax),%edx
  8035d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035d4:	8b 40 08             	mov    0x8(%eax),%eax
  8035d7:	39 c2                	cmp    %eax,%edx
  8035d9:	0f 86 f1 03 00 00    	jbe    8039d0 <insert_sorted_with_merge_freeList+0x710>
  8035df:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e2:	8b 50 08             	mov    0x8(%eax),%edx
  8035e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035e8:	8b 40 08             	mov    0x8(%eax),%eax
  8035eb:	39 c2                	cmp    %eax,%edx
  8035ed:	0f 83 dd 03 00 00    	jae    8039d0 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  8035f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035f6:	8b 50 08             	mov    0x8(%eax),%edx
  8035f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035fc:	8b 40 0c             	mov    0xc(%eax),%eax
  8035ff:	01 c2                	add    %eax,%edx
  803601:	8b 45 08             	mov    0x8(%ebp),%eax
  803604:	8b 40 08             	mov    0x8(%eax),%eax
  803607:	39 c2                	cmp    %eax,%edx
  803609:	0f 85 b9 01 00 00    	jne    8037c8 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80360f:	8b 45 08             	mov    0x8(%ebp),%eax
  803612:	8b 50 08             	mov    0x8(%eax),%edx
  803615:	8b 45 08             	mov    0x8(%ebp),%eax
  803618:	8b 40 0c             	mov    0xc(%eax),%eax
  80361b:	01 c2                	add    %eax,%edx
  80361d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803620:	8b 40 08             	mov    0x8(%eax),%eax
  803623:	39 c2                	cmp    %eax,%edx
  803625:	0f 85 0d 01 00 00    	jne    803738 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  80362b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80362e:	8b 50 0c             	mov    0xc(%eax),%edx
  803631:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803634:	8b 40 0c             	mov    0xc(%eax),%eax
  803637:	01 c2                	add    %eax,%edx
  803639:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80363c:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80363f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803643:	75 17                	jne    80365c <insert_sorted_with_merge_freeList+0x39c>
  803645:	83 ec 04             	sub    $0x4,%esp
  803648:	68 c4 46 80 00       	push   $0x8046c4
  80364d:	68 5c 01 00 00       	push   $0x15c
  803652:	68 1b 46 80 00       	push   $0x80461b
  803657:	e8 24 d1 ff ff       	call   800780 <_panic>
  80365c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80365f:	8b 00                	mov    (%eax),%eax
  803661:	85 c0                	test   %eax,%eax
  803663:	74 10                	je     803675 <insert_sorted_with_merge_freeList+0x3b5>
  803665:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803668:	8b 00                	mov    (%eax),%eax
  80366a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80366d:	8b 52 04             	mov    0x4(%edx),%edx
  803670:	89 50 04             	mov    %edx,0x4(%eax)
  803673:	eb 0b                	jmp    803680 <insert_sorted_with_merge_freeList+0x3c0>
  803675:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803678:	8b 40 04             	mov    0x4(%eax),%eax
  80367b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803680:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803683:	8b 40 04             	mov    0x4(%eax),%eax
  803686:	85 c0                	test   %eax,%eax
  803688:	74 0f                	je     803699 <insert_sorted_with_merge_freeList+0x3d9>
  80368a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80368d:	8b 40 04             	mov    0x4(%eax),%eax
  803690:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803693:	8b 12                	mov    (%edx),%edx
  803695:	89 10                	mov    %edx,(%eax)
  803697:	eb 0a                	jmp    8036a3 <insert_sorted_with_merge_freeList+0x3e3>
  803699:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80369c:	8b 00                	mov    (%eax),%eax
  80369e:	a3 38 51 80 00       	mov    %eax,0x805138
  8036a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036a6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036af:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036b6:	a1 44 51 80 00       	mov    0x805144,%eax
  8036bb:	48                   	dec    %eax
  8036bc:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  8036c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036c4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8036cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036ce:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8036d5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8036d9:	75 17                	jne    8036f2 <insert_sorted_with_merge_freeList+0x432>
  8036db:	83 ec 04             	sub    $0x4,%esp
  8036de:	68 f8 45 80 00       	push   $0x8045f8
  8036e3:	68 5f 01 00 00       	push   $0x15f
  8036e8:	68 1b 46 80 00       	push   $0x80461b
  8036ed:	e8 8e d0 ff ff       	call   800780 <_panic>
  8036f2:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8036f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036fb:	89 10                	mov    %edx,(%eax)
  8036fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803700:	8b 00                	mov    (%eax),%eax
  803702:	85 c0                	test   %eax,%eax
  803704:	74 0d                	je     803713 <insert_sorted_with_merge_freeList+0x453>
  803706:	a1 48 51 80 00       	mov    0x805148,%eax
  80370b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80370e:	89 50 04             	mov    %edx,0x4(%eax)
  803711:	eb 08                	jmp    80371b <insert_sorted_with_merge_freeList+0x45b>
  803713:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803716:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80371b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80371e:	a3 48 51 80 00       	mov    %eax,0x805148
  803723:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803726:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80372d:	a1 54 51 80 00       	mov    0x805154,%eax
  803732:	40                   	inc    %eax
  803733:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803738:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80373b:	8b 50 0c             	mov    0xc(%eax),%edx
  80373e:	8b 45 08             	mov    0x8(%ebp),%eax
  803741:	8b 40 0c             	mov    0xc(%eax),%eax
  803744:	01 c2                	add    %eax,%edx
  803746:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803749:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  80374c:	8b 45 08             	mov    0x8(%ebp),%eax
  80374f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803756:	8b 45 08             	mov    0x8(%ebp),%eax
  803759:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803760:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803764:	75 17                	jne    80377d <insert_sorted_with_merge_freeList+0x4bd>
  803766:	83 ec 04             	sub    $0x4,%esp
  803769:	68 f8 45 80 00       	push   $0x8045f8
  80376e:	68 64 01 00 00       	push   $0x164
  803773:	68 1b 46 80 00       	push   $0x80461b
  803778:	e8 03 d0 ff ff       	call   800780 <_panic>
  80377d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803783:	8b 45 08             	mov    0x8(%ebp),%eax
  803786:	89 10                	mov    %edx,(%eax)
  803788:	8b 45 08             	mov    0x8(%ebp),%eax
  80378b:	8b 00                	mov    (%eax),%eax
  80378d:	85 c0                	test   %eax,%eax
  80378f:	74 0d                	je     80379e <insert_sorted_with_merge_freeList+0x4de>
  803791:	a1 48 51 80 00       	mov    0x805148,%eax
  803796:	8b 55 08             	mov    0x8(%ebp),%edx
  803799:	89 50 04             	mov    %edx,0x4(%eax)
  80379c:	eb 08                	jmp    8037a6 <insert_sorted_with_merge_freeList+0x4e6>
  80379e:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8037a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a9:	a3 48 51 80 00       	mov    %eax,0x805148
  8037ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8037b1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037b8:	a1 54 51 80 00       	mov    0x805154,%eax
  8037bd:	40                   	inc    %eax
  8037be:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8037c3:	e9 41 02 00 00       	jmp    803a09 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8037c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8037cb:	8b 50 08             	mov    0x8(%eax),%edx
  8037ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8037d1:	8b 40 0c             	mov    0xc(%eax),%eax
  8037d4:	01 c2                	add    %eax,%edx
  8037d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037d9:	8b 40 08             	mov    0x8(%eax),%eax
  8037dc:	39 c2                	cmp    %eax,%edx
  8037de:	0f 85 7c 01 00 00    	jne    803960 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8037e4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8037e8:	74 06                	je     8037f0 <insert_sorted_with_merge_freeList+0x530>
  8037ea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037ee:	75 17                	jne    803807 <insert_sorted_with_merge_freeList+0x547>
  8037f0:	83 ec 04             	sub    $0x4,%esp
  8037f3:	68 34 46 80 00       	push   $0x804634
  8037f8:	68 69 01 00 00       	push   $0x169
  8037fd:	68 1b 46 80 00       	push   $0x80461b
  803802:	e8 79 cf ff ff       	call   800780 <_panic>
  803807:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80380a:	8b 50 04             	mov    0x4(%eax),%edx
  80380d:	8b 45 08             	mov    0x8(%ebp),%eax
  803810:	89 50 04             	mov    %edx,0x4(%eax)
  803813:	8b 45 08             	mov    0x8(%ebp),%eax
  803816:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803819:	89 10                	mov    %edx,(%eax)
  80381b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80381e:	8b 40 04             	mov    0x4(%eax),%eax
  803821:	85 c0                	test   %eax,%eax
  803823:	74 0d                	je     803832 <insert_sorted_with_merge_freeList+0x572>
  803825:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803828:	8b 40 04             	mov    0x4(%eax),%eax
  80382b:	8b 55 08             	mov    0x8(%ebp),%edx
  80382e:	89 10                	mov    %edx,(%eax)
  803830:	eb 08                	jmp    80383a <insert_sorted_with_merge_freeList+0x57a>
  803832:	8b 45 08             	mov    0x8(%ebp),%eax
  803835:	a3 38 51 80 00       	mov    %eax,0x805138
  80383a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80383d:	8b 55 08             	mov    0x8(%ebp),%edx
  803840:	89 50 04             	mov    %edx,0x4(%eax)
  803843:	a1 44 51 80 00       	mov    0x805144,%eax
  803848:	40                   	inc    %eax
  803849:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  80384e:	8b 45 08             	mov    0x8(%ebp),%eax
  803851:	8b 50 0c             	mov    0xc(%eax),%edx
  803854:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803857:	8b 40 0c             	mov    0xc(%eax),%eax
  80385a:	01 c2                	add    %eax,%edx
  80385c:	8b 45 08             	mov    0x8(%ebp),%eax
  80385f:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803862:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803866:	75 17                	jne    80387f <insert_sorted_with_merge_freeList+0x5bf>
  803868:	83 ec 04             	sub    $0x4,%esp
  80386b:	68 c4 46 80 00       	push   $0x8046c4
  803870:	68 6b 01 00 00       	push   $0x16b
  803875:	68 1b 46 80 00       	push   $0x80461b
  80387a:	e8 01 cf ff ff       	call   800780 <_panic>
  80387f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803882:	8b 00                	mov    (%eax),%eax
  803884:	85 c0                	test   %eax,%eax
  803886:	74 10                	je     803898 <insert_sorted_with_merge_freeList+0x5d8>
  803888:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80388b:	8b 00                	mov    (%eax),%eax
  80388d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803890:	8b 52 04             	mov    0x4(%edx),%edx
  803893:	89 50 04             	mov    %edx,0x4(%eax)
  803896:	eb 0b                	jmp    8038a3 <insert_sorted_with_merge_freeList+0x5e3>
  803898:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80389b:	8b 40 04             	mov    0x4(%eax),%eax
  80389e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8038a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038a6:	8b 40 04             	mov    0x4(%eax),%eax
  8038a9:	85 c0                	test   %eax,%eax
  8038ab:	74 0f                	je     8038bc <insert_sorted_with_merge_freeList+0x5fc>
  8038ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038b0:	8b 40 04             	mov    0x4(%eax),%eax
  8038b3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8038b6:	8b 12                	mov    (%edx),%edx
  8038b8:	89 10                	mov    %edx,(%eax)
  8038ba:	eb 0a                	jmp    8038c6 <insert_sorted_with_merge_freeList+0x606>
  8038bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038bf:	8b 00                	mov    (%eax),%eax
  8038c1:	a3 38 51 80 00       	mov    %eax,0x805138
  8038c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038d2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038d9:	a1 44 51 80 00       	mov    0x805144,%eax
  8038de:	48                   	dec    %eax
  8038df:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  8038e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038e7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8038ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038f1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8038f8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8038fc:	75 17                	jne    803915 <insert_sorted_with_merge_freeList+0x655>
  8038fe:	83 ec 04             	sub    $0x4,%esp
  803901:	68 f8 45 80 00       	push   $0x8045f8
  803906:	68 6e 01 00 00       	push   $0x16e
  80390b:	68 1b 46 80 00       	push   $0x80461b
  803910:	e8 6b ce ff ff       	call   800780 <_panic>
  803915:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80391b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80391e:	89 10                	mov    %edx,(%eax)
  803920:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803923:	8b 00                	mov    (%eax),%eax
  803925:	85 c0                	test   %eax,%eax
  803927:	74 0d                	je     803936 <insert_sorted_with_merge_freeList+0x676>
  803929:	a1 48 51 80 00       	mov    0x805148,%eax
  80392e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803931:	89 50 04             	mov    %edx,0x4(%eax)
  803934:	eb 08                	jmp    80393e <insert_sorted_with_merge_freeList+0x67e>
  803936:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803939:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80393e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803941:	a3 48 51 80 00       	mov    %eax,0x805148
  803946:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803949:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803950:	a1 54 51 80 00       	mov    0x805154,%eax
  803955:	40                   	inc    %eax
  803956:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80395b:	e9 a9 00 00 00       	jmp    803a09 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803960:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803964:	74 06                	je     80396c <insert_sorted_with_merge_freeList+0x6ac>
  803966:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80396a:	75 17                	jne    803983 <insert_sorted_with_merge_freeList+0x6c3>
  80396c:	83 ec 04             	sub    $0x4,%esp
  80396f:	68 90 46 80 00       	push   $0x804690
  803974:	68 73 01 00 00       	push   $0x173
  803979:	68 1b 46 80 00       	push   $0x80461b
  80397e:	e8 fd cd ff ff       	call   800780 <_panic>
  803983:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803986:	8b 10                	mov    (%eax),%edx
  803988:	8b 45 08             	mov    0x8(%ebp),%eax
  80398b:	89 10                	mov    %edx,(%eax)
  80398d:	8b 45 08             	mov    0x8(%ebp),%eax
  803990:	8b 00                	mov    (%eax),%eax
  803992:	85 c0                	test   %eax,%eax
  803994:	74 0b                	je     8039a1 <insert_sorted_with_merge_freeList+0x6e1>
  803996:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803999:	8b 00                	mov    (%eax),%eax
  80399b:	8b 55 08             	mov    0x8(%ebp),%edx
  80399e:	89 50 04             	mov    %edx,0x4(%eax)
  8039a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039a4:	8b 55 08             	mov    0x8(%ebp),%edx
  8039a7:	89 10                	mov    %edx,(%eax)
  8039a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8039ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8039af:	89 50 04             	mov    %edx,0x4(%eax)
  8039b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8039b5:	8b 00                	mov    (%eax),%eax
  8039b7:	85 c0                	test   %eax,%eax
  8039b9:	75 08                	jne    8039c3 <insert_sorted_with_merge_freeList+0x703>
  8039bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8039be:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8039c3:	a1 44 51 80 00       	mov    0x805144,%eax
  8039c8:	40                   	inc    %eax
  8039c9:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  8039ce:	eb 39                	jmp    803a09 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8039d0:	a1 40 51 80 00       	mov    0x805140,%eax
  8039d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8039d8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8039dc:	74 07                	je     8039e5 <insert_sorted_with_merge_freeList+0x725>
  8039de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039e1:	8b 00                	mov    (%eax),%eax
  8039e3:	eb 05                	jmp    8039ea <insert_sorted_with_merge_freeList+0x72a>
  8039e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8039ea:	a3 40 51 80 00       	mov    %eax,0x805140
  8039ef:	a1 40 51 80 00       	mov    0x805140,%eax
  8039f4:	85 c0                	test   %eax,%eax
  8039f6:	0f 85 c7 fb ff ff    	jne    8035c3 <insert_sorted_with_merge_freeList+0x303>
  8039fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a00:	0f 85 bd fb ff ff    	jne    8035c3 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803a06:	eb 01                	jmp    803a09 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803a08:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803a09:	90                   	nop
  803a0a:	c9                   	leave  
  803a0b:	c3                   	ret    

00803a0c <__udivdi3>:
  803a0c:	55                   	push   %ebp
  803a0d:	57                   	push   %edi
  803a0e:	56                   	push   %esi
  803a0f:	53                   	push   %ebx
  803a10:	83 ec 1c             	sub    $0x1c,%esp
  803a13:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803a17:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803a1b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803a1f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803a23:	89 ca                	mov    %ecx,%edx
  803a25:	89 f8                	mov    %edi,%eax
  803a27:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803a2b:	85 f6                	test   %esi,%esi
  803a2d:	75 2d                	jne    803a5c <__udivdi3+0x50>
  803a2f:	39 cf                	cmp    %ecx,%edi
  803a31:	77 65                	ja     803a98 <__udivdi3+0x8c>
  803a33:	89 fd                	mov    %edi,%ebp
  803a35:	85 ff                	test   %edi,%edi
  803a37:	75 0b                	jne    803a44 <__udivdi3+0x38>
  803a39:	b8 01 00 00 00       	mov    $0x1,%eax
  803a3e:	31 d2                	xor    %edx,%edx
  803a40:	f7 f7                	div    %edi
  803a42:	89 c5                	mov    %eax,%ebp
  803a44:	31 d2                	xor    %edx,%edx
  803a46:	89 c8                	mov    %ecx,%eax
  803a48:	f7 f5                	div    %ebp
  803a4a:	89 c1                	mov    %eax,%ecx
  803a4c:	89 d8                	mov    %ebx,%eax
  803a4e:	f7 f5                	div    %ebp
  803a50:	89 cf                	mov    %ecx,%edi
  803a52:	89 fa                	mov    %edi,%edx
  803a54:	83 c4 1c             	add    $0x1c,%esp
  803a57:	5b                   	pop    %ebx
  803a58:	5e                   	pop    %esi
  803a59:	5f                   	pop    %edi
  803a5a:	5d                   	pop    %ebp
  803a5b:	c3                   	ret    
  803a5c:	39 ce                	cmp    %ecx,%esi
  803a5e:	77 28                	ja     803a88 <__udivdi3+0x7c>
  803a60:	0f bd fe             	bsr    %esi,%edi
  803a63:	83 f7 1f             	xor    $0x1f,%edi
  803a66:	75 40                	jne    803aa8 <__udivdi3+0x9c>
  803a68:	39 ce                	cmp    %ecx,%esi
  803a6a:	72 0a                	jb     803a76 <__udivdi3+0x6a>
  803a6c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803a70:	0f 87 9e 00 00 00    	ja     803b14 <__udivdi3+0x108>
  803a76:	b8 01 00 00 00       	mov    $0x1,%eax
  803a7b:	89 fa                	mov    %edi,%edx
  803a7d:	83 c4 1c             	add    $0x1c,%esp
  803a80:	5b                   	pop    %ebx
  803a81:	5e                   	pop    %esi
  803a82:	5f                   	pop    %edi
  803a83:	5d                   	pop    %ebp
  803a84:	c3                   	ret    
  803a85:	8d 76 00             	lea    0x0(%esi),%esi
  803a88:	31 ff                	xor    %edi,%edi
  803a8a:	31 c0                	xor    %eax,%eax
  803a8c:	89 fa                	mov    %edi,%edx
  803a8e:	83 c4 1c             	add    $0x1c,%esp
  803a91:	5b                   	pop    %ebx
  803a92:	5e                   	pop    %esi
  803a93:	5f                   	pop    %edi
  803a94:	5d                   	pop    %ebp
  803a95:	c3                   	ret    
  803a96:	66 90                	xchg   %ax,%ax
  803a98:	89 d8                	mov    %ebx,%eax
  803a9a:	f7 f7                	div    %edi
  803a9c:	31 ff                	xor    %edi,%edi
  803a9e:	89 fa                	mov    %edi,%edx
  803aa0:	83 c4 1c             	add    $0x1c,%esp
  803aa3:	5b                   	pop    %ebx
  803aa4:	5e                   	pop    %esi
  803aa5:	5f                   	pop    %edi
  803aa6:	5d                   	pop    %ebp
  803aa7:	c3                   	ret    
  803aa8:	bd 20 00 00 00       	mov    $0x20,%ebp
  803aad:	89 eb                	mov    %ebp,%ebx
  803aaf:	29 fb                	sub    %edi,%ebx
  803ab1:	89 f9                	mov    %edi,%ecx
  803ab3:	d3 e6                	shl    %cl,%esi
  803ab5:	89 c5                	mov    %eax,%ebp
  803ab7:	88 d9                	mov    %bl,%cl
  803ab9:	d3 ed                	shr    %cl,%ebp
  803abb:	89 e9                	mov    %ebp,%ecx
  803abd:	09 f1                	or     %esi,%ecx
  803abf:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803ac3:	89 f9                	mov    %edi,%ecx
  803ac5:	d3 e0                	shl    %cl,%eax
  803ac7:	89 c5                	mov    %eax,%ebp
  803ac9:	89 d6                	mov    %edx,%esi
  803acb:	88 d9                	mov    %bl,%cl
  803acd:	d3 ee                	shr    %cl,%esi
  803acf:	89 f9                	mov    %edi,%ecx
  803ad1:	d3 e2                	shl    %cl,%edx
  803ad3:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ad7:	88 d9                	mov    %bl,%cl
  803ad9:	d3 e8                	shr    %cl,%eax
  803adb:	09 c2                	or     %eax,%edx
  803add:	89 d0                	mov    %edx,%eax
  803adf:	89 f2                	mov    %esi,%edx
  803ae1:	f7 74 24 0c          	divl   0xc(%esp)
  803ae5:	89 d6                	mov    %edx,%esi
  803ae7:	89 c3                	mov    %eax,%ebx
  803ae9:	f7 e5                	mul    %ebp
  803aeb:	39 d6                	cmp    %edx,%esi
  803aed:	72 19                	jb     803b08 <__udivdi3+0xfc>
  803aef:	74 0b                	je     803afc <__udivdi3+0xf0>
  803af1:	89 d8                	mov    %ebx,%eax
  803af3:	31 ff                	xor    %edi,%edi
  803af5:	e9 58 ff ff ff       	jmp    803a52 <__udivdi3+0x46>
  803afa:	66 90                	xchg   %ax,%ax
  803afc:	8b 54 24 08          	mov    0x8(%esp),%edx
  803b00:	89 f9                	mov    %edi,%ecx
  803b02:	d3 e2                	shl    %cl,%edx
  803b04:	39 c2                	cmp    %eax,%edx
  803b06:	73 e9                	jae    803af1 <__udivdi3+0xe5>
  803b08:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803b0b:	31 ff                	xor    %edi,%edi
  803b0d:	e9 40 ff ff ff       	jmp    803a52 <__udivdi3+0x46>
  803b12:	66 90                	xchg   %ax,%ax
  803b14:	31 c0                	xor    %eax,%eax
  803b16:	e9 37 ff ff ff       	jmp    803a52 <__udivdi3+0x46>
  803b1b:	90                   	nop

00803b1c <__umoddi3>:
  803b1c:	55                   	push   %ebp
  803b1d:	57                   	push   %edi
  803b1e:	56                   	push   %esi
  803b1f:	53                   	push   %ebx
  803b20:	83 ec 1c             	sub    $0x1c,%esp
  803b23:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803b27:	8b 74 24 34          	mov    0x34(%esp),%esi
  803b2b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b2f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803b33:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803b37:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803b3b:	89 f3                	mov    %esi,%ebx
  803b3d:	89 fa                	mov    %edi,%edx
  803b3f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803b43:	89 34 24             	mov    %esi,(%esp)
  803b46:	85 c0                	test   %eax,%eax
  803b48:	75 1a                	jne    803b64 <__umoddi3+0x48>
  803b4a:	39 f7                	cmp    %esi,%edi
  803b4c:	0f 86 a2 00 00 00    	jbe    803bf4 <__umoddi3+0xd8>
  803b52:	89 c8                	mov    %ecx,%eax
  803b54:	89 f2                	mov    %esi,%edx
  803b56:	f7 f7                	div    %edi
  803b58:	89 d0                	mov    %edx,%eax
  803b5a:	31 d2                	xor    %edx,%edx
  803b5c:	83 c4 1c             	add    $0x1c,%esp
  803b5f:	5b                   	pop    %ebx
  803b60:	5e                   	pop    %esi
  803b61:	5f                   	pop    %edi
  803b62:	5d                   	pop    %ebp
  803b63:	c3                   	ret    
  803b64:	39 f0                	cmp    %esi,%eax
  803b66:	0f 87 ac 00 00 00    	ja     803c18 <__umoddi3+0xfc>
  803b6c:	0f bd e8             	bsr    %eax,%ebp
  803b6f:	83 f5 1f             	xor    $0x1f,%ebp
  803b72:	0f 84 ac 00 00 00    	je     803c24 <__umoddi3+0x108>
  803b78:	bf 20 00 00 00       	mov    $0x20,%edi
  803b7d:	29 ef                	sub    %ebp,%edi
  803b7f:	89 fe                	mov    %edi,%esi
  803b81:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803b85:	89 e9                	mov    %ebp,%ecx
  803b87:	d3 e0                	shl    %cl,%eax
  803b89:	89 d7                	mov    %edx,%edi
  803b8b:	89 f1                	mov    %esi,%ecx
  803b8d:	d3 ef                	shr    %cl,%edi
  803b8f:	09 c7                	or     %eax,%edi
  803b91:	89 e9                	mov    %ebp,%ecx
  803b93:	d3 e2                	shl    %cl,%edx
  803b95:	89 14 24             	mov    %edx,(%esp)
  803b98:	89 d8                	mov    %ebx,%eax
  803b9a:	d3 e0                	shl    %cl,%eax
  803b9c:	89 c2                	mov    %eax,%edx
  803b9e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ba2:	d3 e0                	shl    %cl,%eax
  803ba4:	89 44 24 04          	mov    %eax,0x4(%esp)
  803ba8:	8b 44 24 08          	mov    0x8(%esp),%eax
  803bac:	89 f1                	mov    %esi,%ecx
  803bae:	d3 e8                	shr    %cl,%eax
  803bb0:	09 d0                	or     %edx,%eax
  803bb2:	d3 eb                	shr    %cl,%ebx
  803bb4:	89 da                	mov    %ebx,%edx
  803bb6:	f7 f7                	div    %edi
  803bb8:	89 d3                	mov    %edx,%ebx
  803bba:	f7 24 24             	mull   (%esp)
  803bbd:	89 c6                	mov    %eax,%esi
  803bbf:	89 d1                	mov    %edx,%ecx
  803bc1:	39 d3                	cmp    %edx,%ebx
  803bc3:	0f 82 87 00 00 00    	jb     803c50 <__umoddi3+0x134>
  803bc9:	0f 84 91 00 00 00    	je     803c60 <__umoddi3+0x144>
  803bcf:	8b 54 24 04          	mov    0x4(%esp),%edx
  803bd3:	29 f2                	sub    %esi,%edx
  803bd5:	19 cb                	sbb    %ecx,%ebx
  803bd7:	89 d8                	mov    %ebx,%eax
  803bd9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803bdd:	d3 e0                	shl    %cl,%eax
  803bdf:	89 e9                	mov    %ebp,%ecx
  803be1:	d3 ea                	shr    %cl,%edx
  803be3:	09 d0                	or     %edx,%eax
  803be5:	89 e9                	mov    %ebp,%ecx
  803be7:	d3 eb                	shr    %cl,%ebx
  803be9:	89 da                	mov    %ebx,%edx
  803beb:	83 c4 1c             	add    $0x1c,%esp
  803bee:	5b                   	pop    %ebx
  803bef:	5e                   	pop    %esi
  803bf0:	5f                   	pop    %edi
  803bf1:	5d                   	pop    %ebp
  803bf2:	c3                   	ret    
  803bf3:	90                   	nop
  803bf4:	89 fd                	mov    %edi,%ebp
  803bf6:	85 ff                	test   %edi,%edi
  803bf8:	75 0b                	jne    803c05 <__umoddi3+0xe9>
  803bfa:	b8 01 00 00 00       	mov    $0x1,%eax
  803bff:	31 d2                	xor    %edx,%edx
  803c01:	f7 f7                	div    %edi
  803c03:	89 c5                	mov    %eax,%ebp
  803c05:	89 f0                	mov    %esi,%eax
  803c07:	31 d2                	xor    %edx,%edx
  803c09:	f7 f5                	div    %ebp
  803c0b:	89 c8                	mov    %ecx,%eax
  803c0d:	f7 f5                	div    %ebp
  803c0f:	89 d0                	mov    %edx,%eax
  803c11:	e9 44 ff ff ff       	jmp    803b5a <__umoddi3+0x3e>
  803c16:	66 90                	xchg   %ax,%ax
  803c18:	89 c8                	mov    %ecx,%eax
  803c1a:	89 f2                	mov    %esi,%edx
  803c1c:	83 c4 1c             	add    $0x1c,%esp
  803c1f:	5b                   	pop    %ebx
  803c20:	5e                   	pop    %esi
  803c21:	5f                   	pop    %edi
  803c22:	5d                   	pop    %ebp
  803c23:	c3                   	ret    
  803c24:	3b 04 24             	cmp    (%esp),%eax
  803c27:	72 06                	jb     803c2f <__umoddi3+0x113>
  803c29:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803c2d:	77 0f                	ja     803c3e <__umoddi3+0x122>
  803c2f:	89 f2                	mov    %esi,%edx
  803c31:	29 f9                	sub    %edi,%ecx
  803c33:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803c37:	89 14 24             	mov    %edx,(%esp)
  803c3a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c3e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803c42:	8b 14 24             	mov    (%esp),%edx
  803c45:	83 c4 1c             	add    $0x1c,%esp
  803c48:	5b                   	pop    %ebx
  803c49:	5e                   	pop    %esi
  803c4a:	5f                   	pop    %edi
  803c4b:	5d                   	pop    %ebp
  803c4c:	c3                   	ret    
  803c4d:	8d 76 00             	lea    0x0(%esi),%esi
  803c50:	2b 04 24             	sub    (%esp),%eax
  803c53:	19 fa                	sbb    %edi,%edx
  803c55:	89 d1                	mov    %edx,%ecx
  803c57:	89 c6                	mov    %eax,%esi
  803c59:	e9 71 ff ff ff       	jmp    803bcf <__umoddi3+0xb3>
  803c5e:	66 90                	xchg   %ax,%ax
  803c60:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803c64:	72 ea                	jb     803c50 <__umoddi3+0x134>
  803c66:	89 d9                	mov    %ebx,%ecx
  803c68:	e9 62 ff ff ff       	jmp    803bcf <__umoddi3+0xb3>
