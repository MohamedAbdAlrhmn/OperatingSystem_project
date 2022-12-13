
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
  800041:	e8 d0 1f 00 00       	call   802016 <sys_disable_interrupt>
		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 60 3d 80 00       	push   $0x803d60
  80004e:	e8 e1 09 00 00       	call   800a34 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 62 3d 80 00       	push   $0x803d62
  80005e:	e8 d1 09 00 00       	call   800a34 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!   QUICK SORT    !!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 7b 3d 80 00       	push   $0x803d7b
  80006e:	e8 c1 09 00 00       	call   800a34 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 62 3d 80 00       	push   $0x803d62
  80007e:	e8 b1 09 00 00       	call   800a34 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 60 3d 80 00       	push   $0x803d60
  80008e:	e8 a1 09 00 00       	call   800a34 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp

		readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 94 3d 80 00       	push   $0x803d94
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
  8000de:	68 b4 3d 80 00       	push   $0x803db4
  8000e3:	e8 4c 09 00 00       	call   800a34 <cprintf>
  8000e8:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000eb:	83 ec 0c             	sub    $0xc,%esp
  8000ee:	68 d6 3d 80 00       	push   $0x803dd6
  8000f3:	e8 3c 09 00 00       	call   800a34 <cprintf>
  8000f8:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000fb:	83 ec 0c             	sub    $0xc,%esp
  8000fe:	68 e4 3d 80 00       	push   $0x803de4
  800103:	e8 2c 09 00 00       	call   800a34 <cprintf>
  800108:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 f3 3d 80 00       	push   $0x803df3
  800113:	e8 1c 09 00 00       	call   800a34 <cprintf>
  800118:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	68 03 3e 80 00       	push   $0x803e03
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
  800162:	e8 c9 1e 00 00       	call   802030 <sys_enable_interrupt>

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
  8001d5:	e8 3c 1e 00 00       	call   802016 <sys_disable_interrupt>
			cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001da:	83 ec 0c             	sub    $0xc,%esp
  8001dd:	68 0c 3e 80 00       	push   $0x803e0c
  8001e2:	e8 4d 08 00 00       	call   800a34 <cprintf>
  8001e7:	83 c4 10             	add    $0x10,%esp
		//		PrintElements(Elements, NumOfElements);
		sys_enable_interrupt();
  8001ea:	e8 41 1e 00 00       	call   802030 <sys_enable_interrupt>

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
  80020c:	68 40 3e 80 00       	push   $0x803e40
  800211:	6a 49                	push   $0x49
  800213:	68 62 3e 80 00       	push   $0x803e62
  800218:	e8 63 05 00 00       	call   800780 <_panic>
		else
		{
			sys_disable_interrupt();
  80021d:	e8 f4 1d 00 00       	call   802016 <sys_disable_interrupt>
			cprintf("===============================================\n") ;
  800222:	83 ec 0c             	sub    $0xc,%esp
  800225:	68 80 3e 80 00       	push   $0x803e80
  80022a:	e8 05 08 00 00       	call   800a34 <cprintf>
  80022f:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  800232:	83 ec 0c             	sub    $0xc,%esp
  800235:	68 b4 3e 80 00       	push   $0x803eb4
  80023a:	e8 f5 07 00 00       	call   800a34 <cprintf>
  80023f:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  800242:	83 ec 0c             	sub    $0xc,%esp
  800245:	68 e8 3e 80 00       	push   $0x803ee8
  80024a:	e8 e5 07 00 00       	call   800a34 <cprintf>
  80024f:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800252:	e8 d9 1d 00 00       	call   802030 <sys_enable_interrupt>

		}

		free(Elements) ;
  800257:	83 ec 0c             	sub    $0xc,%esp
  80025a:	ff 75 f0             	pushl  -0x10(%ebp)
  80025d:	e8 db 19 00 00       	call   801c3d <free>
  800262:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  800265:	e8 ac 1d 00 00       	call   802016 <sys_disable_interrupt>

		cprintf("Do you want to repeat (y/n): ") ;
  80026a:	83 ec 0c             	sub    $0xc,%esp
  80026d:	68 1a 3f 80 00       	push   $0x803f1a
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
  80029f:	e8 8c 1d 00 00       	call   802030 <sys_enable_interrupt>

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
  800544:	68 60 3d 80 00       	push   $0x803d60
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
  800566:	68 38 3f 80 00       	push   $0x803f38
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
  800594:	68 3d 3f 80 00       	push   $0x803f3d
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
  8005b8:	e8 8d 1a 00 00       	call   80204a <sys_cputc>
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
  8005c9:	e8 48 1a 00 00       	call   802016 <sys_disable_interrupt>
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
  8005dc:	e8 69 1a 00 00       	call   80204a <sys_cputc>
  8005e1:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8005e4:	e8 47 1a 00 00       	call   802030 <sys_enable_interrupt>
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
  8005fb:	e8 91 18 00 00       	call   801e91 <sys_cgetc>
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
  800614:	e8 fd 19 00 00       	call   802016 <sys_disable_interrupt>
	int c=0;
  800619:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800620:	eb 08                	jmp    80062a <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  800622:	e8 6a 18 00 00       	call   801e91 <sys_cgetc>
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
  800630:	e8 fb 19 00 00       	call   802030 <sys_enable_interrupt>
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
  80064a:	e8 ba 1b 00 00       	call   802209 <sys_getenvindex>
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
  8006b5:	e8 5c 19 00 00       	call   802016 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8006ba:	83 ec 0c             	sub    $0xc,%esp
  8006bd:	68 5c 3f 80 00       	push   $0x803f5c
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
  8006e5:	68 84 3f 80 00       	push   $0x803f84
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
  800716:	68 ac 3f 80 00       	push   $0x803fac
  80071b:	e8 14 03 00 00       	call   800a34 <cprintf>
  800720:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800723:	a1 24 50 80 00       	mov    0x805024,%eax
  800728:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80072e:	83 ec 08             	sub    $0x8,%esp
  800731:	50                   	push   %eax
  800732:	68 04 40 80 00       	push   $0x804004
  800737:	e8 f8 02 00 00       	call   800a34 <cprintf>
  80073c:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80073f:	83 ec 0c             	sub    $0xc,%esp
  800742:	68 5c 3f 80 00       	push   $0x803f5c
  800747:	e8 e8 02 00 00       	call   800a34 <cprintf>
  80074c:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80074f:	e8 dc 18 00 00       	call   802030 <sys_enable_interrupt>

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
  800767:	e8 69 1a 00 00       	call   8021d5 <sys_destroy_env>
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
  800778:	e8 be 1a 00 00       	call   80223b <sys_exit_env>
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
  8007a1:	68 18 40 80 00       	push   $0x804018
  8007a6:	e8 89 02 00 00       	call   800a34 <cprintf>
  8007ab:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8007ae:	a1 00 50 80 00       	mov    0x805000,%eax
  8007b3:	ff 75 0c             	pushl  0xc(%ebp)
  8007b6:	ff 75 08             	pushl  0x8(%ebp)
  8007b9:	50                   	push   %eax
  8007ba:	68 1d 40 80 00       	push   $0x80401d
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
  8007de:	68 39 40 80 00       	push   $0x804039
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
  80080a:	68 3c 40 80 00       	push   $0x80403c
  80080f:	6a 26                	push   $0x26
  800811:	68 88 40 80 00       	push   $0x804088
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
  8008dc:	68 94 40 80 00       	push   $0x804094
  8008e1:	6a 3a                	push   $0x3a
  8008e3:	68 88 40 80 00       	push   $0x804088
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
  80094c:	68 e8 40 80 00       	push   $0x8040e8
  800951:	6a 44                	push   $0x44
  800953:	68 88 40 80 00       	push   $0x804088
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
  8009a6:	e8 bd 14 00 00       	call   801e68 <sys_cputs>
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
  800a1d:	e8 46 14 00 00       	call   801e68 <sys_cputs>
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
  800a67:	e8 aa 15 00 00       	call   802016 <sys_disable_interrupt>
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
  800a87:	e8 a4 15 00 00       	call   802030 <sys_enable_interrupt>
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
  800ad1:	e8 16 30 00 00       	call   803aec <__udivdi3>
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
  800b21:	e8 d6 30 00 00       	call   803bfc <__umoddi3>
  800b26:	83 c4 10             	add    $0x10,%esp
  800b29:	05 54 43 80 00       	add    $0x804354,%eax
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
  800c7c:	8b 04 85 78 43 80 00 	mov    0x804378(,%eax,4),%eax
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
  800d5d:	8b 34 9d c0 41 80 00 	mov    0x8041c0(,%ebx,4),%esi
  800d64:	85 f6                	test   %esi,%esi
  800d66:	75 19                	jne    800d81 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d68:	53                   	push   %ebx
  800d69:	68 65 43 80 00       	push   $0x804365
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
  800d82:	68 6e 43 80 00       	push   $0x80436e
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
  800daf:	be 71 43 80 00       	mov    $0x804371,%esi
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
  8010c8:	68 d0 44 80 00       	push   $0x8044d0
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
  80110a:	68 d3 44 80 00       	push   $0x8044d3
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
  8011ba:	e8 57 0e 00 00       	call   802016 <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  8011bf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011c3:	74 13                	je     8011d8 <atomic_readline+0x24>
		cprintf("%s", prompt);
  8011c5:	83 ec 08             	sub    $0x8,%esp
  8011c8:	ff 75 08             	pushl  0x8(%ebp)
  8011cb:	68 d0 44 80 00       	push   $0x8044d0
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
  801209:	68 d3 44 80 00       	push   $0x8044d3
  80120e:	e8 21 f8 ff ff       	call   800a34 <cprintf>
  801213:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  801216:	e8 15 0e 00 00       	call   802030 <sys_enable_interrupt>
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
  8012ae:	e8 7d 0d 00 00       	call   802030 <sys_enable_interrupt>
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
  8019db:	68 e4 44 80 00       	push   $0x8044e4
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
  801aab:	e8 fc 04 00 00       	call   801fac <sys_allocate_chunk>
  801ab0:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801ab3:	a1 20 51 80 00       	mov    0x805120,%eax
  801ab8:	83 ec 0c             	sub    $0xc,%esp
  801abb:	50                   	push   %eax
  801abc:	e8 71 0b 00 00       	call   802632 <initialize_MemBlocksList>
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
  801ae9:	68 09 45 80 00       	push   $0x804509
  801aee:	6a 33                	push   $0x33
  801af0:	68 27 45 80 00       	push   $0x804527
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
  801b68:	68 34 45 80 00       	push   $0x804534
  801b6d:	6a 34                	push   $0x34
  801b6f:	68 27 45 80 00       	push   $0x804527
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
  801bc5:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801bc8:	e8 f7 fd ff ff       	call   8019c4 <InitializeUHeap>
	if (size == 0) return NULL ;
  801bcd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801bd1:	75 07                	jne    801bda <malloc+0x18>
  801bd3:	b8 00 00 00 00       	mov    $0x0,%eax
  801bd8:	eb 61                	jmp    801c3b <malloc+0x79>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
	uint32 malloc_allocsize=ROUNDUP(size,PAGE_SIZE);
  801bda:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801be1:	8b 55 08             	mov    0x8(%ebp),%edx
  801be4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801be7:	01 d0                	add    %edx,%eax
  801be9:	48                   	dec    %eax
  801bea:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801bed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bf0:	ba 00 00 00 00       	mov    $0x0,%edx
  801bf5:	f7 75 f0             	divl   -0x10(%ebp)
  801bf8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bfb:	29 d0                	sub    %edx,%eax
  801bfd:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 //int ret=0;
	struct MemBlock * user_block;
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801c00:	e8 75 07 00 00       	call   80237a <sys_isUHeapPlacementStrategyFIRSTFIT>
  801c05:	85 c0                	test   %eax,%eax
  801c07:	74 11                	je     801c1a <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801c09:	83 ec 0c             	sub    $0xc,%esp
  801c0c:	ff 75 e8             	pushl  -0x18(%ebp)
  801c0f:	e8 e0 0d 00 00       	call   8029f4 <alloc_block_FF>
  801c14:	83 c4 10             	add    $0x10,%esp
  801c17:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(user_block!=NULL)
  801c1a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c1e:	74 16                	je     801c36 <malloc+0x74>
	{
		//sys_allocate_chunk(user_block->sva,malloc_allocsize,PERM_WRITEABLE| PERM_PRESENT);
		insert_sorted_allocList(user_block);
  801c20:	83 ec 0c             	sub    $0xc,%esp
  801c23:	ff 75 f4             	pushl  -0xc(%ebp)
  801c26:	e8 3c 0b 00 00       	call   802767 <insert_sorted_allocList>
  801c2b:	83 c4 10             	add    $0x10,%esp
		return (uint32 *)user_block->sva;
  801c2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c31:	8b 40 08             	mov    0x8(%eax),%eax
  801c34:	eb 05                	jmp    801c3b <malloc+0x79>
	}

    return NULL;
  801c36:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c3b:	c9                   	leave  
  801c3c:	c3                   	ret    

00801c3d <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801c3d:	55                   	push   %ebp
  801c3e:	89 e5                	mov    %esp,%ebp
  801c40:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801c43:	83 ec 04             	sub    $0x4,%esp
  801c46:	68 58 45 80 00       	push   $0x804558
  801c4b:	6a 6f                	push   $0x6f
  801c4d:	68 27 45 80 00       	push   $0x804527
  801c52:	e8 29 eb ff ff       	call   800780 <_panic>

00801c57 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801c57:	55                   	push   %ebp
  801c58:	89 e5                	mov    %esp,%ebp
  801c5a:	83 ec 38             	sub    $0x38,%esp
  801c5d:	8b 45 10             	mov    0x10(%ebp),%eax
  801c60:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801c63:	e8 5c fd ff ff       	call   8019c4 <InitializeUHeap>
	if (size == 0) return NULL ;
  801c68:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801c6c:	75 0a                	jne    801c78 <smalloc+0x21>
  801c6e:	b8 00 00 00 00       	mov    $0x0,%eax
  801c73:	e9 8b 00 00 00       	jmp    801d03 <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801c78:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801c7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c85:	01 d0                	add    %edx,%eax
  801c87:	48                   	dec    %eax
  801c88:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801c8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c8e:	ba 00 00 00 00       	mov    $0x0,%edx
  801c93:	f7 75 f0             	divl   -0x10(%ebp)
  801c96:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c99:	29 d0                	sub    %edx,%eax
  801c9b:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801c9e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801ca5:	e8 d0 06 00 00       	call   80237a <sys_isUHeapPlacementStrategyFIRSTFIT>
  801caa:	85 c0                	test   %eax,%eax
  801cac:	74 11                	je     801cbf <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  801cae:	83 ec 0c             	sub    $0xc,%esp
  801cb1:	ff 75 e8             	pushl  -0x18(%ebp)
  801cb4:	e8 3b 0d 00 00       	call   8029f4 <alloc_block_FF>
  801cb9:	83 c4 10             	add    $0x10,%esp
  801cbc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  801cbf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801cc3:	74 39                	je     801cfe <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801cc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cc8:	8b 40 08             	mov    0x8(%eax),%eax
  801ccb:	89 c2                	mov    %eax,%edx
  801ccd:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801cd1:	52                   	push   %edx
  801cd2:	50                   	push   %eax
  801cd3:	ff 75 0c             	pushl  0xc(%ebp)
  801cd6:	ff 75 08             	pushl  0x8(%ebp)
  801cd9:	e8 21 04 00 00       	call   8020ff <sys_createSharedObject>
  801cde:	83 c4 10             	add    $0x10,%esp
  801ce1:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  801ce4:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  801ce8:	74 14                	je     801cfe <smalloc+0xa7>
  801cea:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  801cee:	74 0e                	je     801cfe <smalloc+0xa7>
  801cf0:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  801cf4:	74 08                	je     801cfe <smalloc+0xa7>
			return (void*) mem_block->sva;
  801cf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cf9:	8b 40 08             	mov    0x8(%eax),%eax
  801cfc:	eb 05                	jmp    801d03 <smalloc+0xac>
	}
	return NULL;
  801cfe:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801d03:	c9                   	leave  
  801d04:	c3                   	ret    

00801d05 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801d05:	55                   	push   %ebp
  801d06:	89 e5                	mov    %esp,%ebp
  801d08:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801d0b:	e8 b4 fc ff ff       	call   8019c4 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801d10:	83 ec 08             	sub    $0x8,%esp
  801d13:	ff 75 0c             	pushl  0xc(%ebp)
  801d16:	ff 75 08             	pushl  0x8(%ebp)
  801d19:	e8 0b 04 00 00       	call   802129 <sys_getSizeOfSharedObject>
  801d1e:	83 c4 10             	add    $0x10,%esp
  801d21:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  801d24:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  801d28:	74 76                	je     801da0 <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801d2a:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801d31:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d34:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d37:	01 d0                	add    %edx,%eax
  801d39:	48                   	dec    %eax
  801d3a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801d3d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d40:	ba 00 00 00 00       	mov    $0x0,%edx
  801d45:	f7 75 ec             	divl   -0x14(%ebp)
  801d48:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d4b:	29 d0                	sub    %edx,%eax
  801d4d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  801d50:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801d57:	e8 1e 06 00 00       	call   80237a <sys_isUHeapPlacementStrategyFIRSTFIT>
  801d5c:	85 c0                	test   %eax,%eax
  801d5e:	74 11                	je     801d71 <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  801d60:	83 ec 0c             	sub    $0xc,%esp
  801d63:	ff 75 e4             	pushl  -0x1c(%ebp)
  801d66:	e8 89 0c 00 00       	call   8029f4 <alloc_block_FF>
  801d6b:	83 c4 10             	add    $0x10,%esp
  801d6e:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  801d71:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d75:	74 29                	je     801da0 <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  801d77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d7a:	8b 40 08             	mov    0x8(%eax),%eax
  801d7d:	83 ec 04             	sub    $0x4,%esp
  801d80:	50                   	push   %eax
  801d81:	ff 75 0c             	pushl  0xc(%ebp)
  801d84:	ff 75 08             	pushl  0x8(%ebp)
  801d87:	e8 ba 03 00 00       	call   802146 <sys_getSharedObject>
  801d8c:	83 c4 10             	add    $0x10,%esp
  801d8f:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  801d92:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  801d96:	74 08                	je     801da0 <sget+0x9b>
				return (void *)mem_block->sva;
  801d98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d9b:	8b 40 08             	mov    0x8(%eax),%eax
  801d9e:	eb 05                	jmp    801da5 <sget+0xa0>
		}
	}
	return (void *)NULL;
  801da0:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801da5:	c9                   	leave  
  801da6:	c3                   	ret    

00801da7 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801da7:	55                   	push   %ebp
  801da8:	89 e5                	mov    %esp,%ebp
  801daa:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801dad:	e8 12 fc ff ff       	call   8019c4 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801db2:	83 ec 04             	sub    $0x4,%esp
  801db5:	68 7c 45 80 00       	push   $0x80457c
  801dba:	68 f1 00 00 00       	push   $0xf1
  801dbf:	68 27 45 80 00       	push   $0x804527
  801dc4:	e8 b7 e9 ff ff       	call   800780 <_panic>

00801dc9 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801dc9:	55                   	push   %ebp
  801dca:	89 e5                	mov    %esp,%ebp
  801dcc:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801dcf:	83 ec 04             	sub    $0x4,%esp
  801dd2:	68 a4 45 80 00       	push   $0x8045a4
  801dd7:	68 05 01 00 00       	push   $0x105
  801ddc:	68 27 45 80 00       	push   $0x804527
  801de1:	e8 9a e9 ff ff       	call   800780 <_panic>

00801de6 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801de6:	55                   	push   %ebp
  801de7:	89 e5                	mov    %esp,%ebp
  801de9:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801dec:	83 ec 04             	sub    $0x4,%esp
  801def:	68 c8 45 80 00       	push   $0x8045c8
  801df4:	68 10 01 00 00       	push   $0x110
  801df9:	68 27 45 80 00       	push   $0x804527
  801dfe:	e8 7d e9 ff ff       	call   800780 <_panic>

00801e03 <shrink>:

}
void shrink(uint32 newSize)
{
  801e03:	55                   	push   %ebp
  801e04:	89 e5                	mov    %esp,%ebp
  801e06:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e09:	83 ec 04             	sub    $0x4,%esp
  801e0c:	68 c8 45 80 00       	push   $0x8045c8
  801e11:	68 15 01 00 00       	push   $0x115
  801e16:	68 27 45 80 00       	push   $0x804527
  801e1b:	e8 60 e9 ff ff       	call   800780 <_panic>

00801e20 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801e20:	55                   	push   %ebp
  801e21:	89 e5                	mov    %esp,%ebp
  801e23:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e26:	83 ec 04             	sub    $0x4,%esp
  801e29:	68 c8 45 80 00       	push   $0x8045c8
  801e2e:	68 1a 01 00 00       	push   $0x11a
  801e33:	68 27 45 80 00       	push   $0x804527
  801e38:	e8 43 e9 ff ff       	call   800780 <_panic>

00801e3d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801e3d:	55                   	push   %ebp
  801e3e:	89 e5                	mov    %esp,%ebp
  801e40:	57                   	push   %edi
  801e41:	56                   	push   %esi
  801e42:	53                   	push   %ebx
  801e43:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801e46:	8b 45 08             	mov    0x8(%ebp),%eax
  801e49:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e4c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e4f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e52:	8b 7d 18             	mov    0x18(%ebp),%edi
  801e55:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801e58:	cd 30                	int    $0x30
  801e5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801e5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801e60:	83 c4 10             	add    $0x10,%esp
  801e63:	5b                   	pop    %ebx
  801e64:	5e                   	pop    %esi
  801e65:	5f                   	pop    %edi
  801e66:	5d                   	pop    %ebp
  801e67:	c3                   	ret    

00801e68 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801e68:	55                   	push   %ebp
  801e69:	89 e5                	mov    %esp,%ebp
  801e6b:	83 ec 04             	sub    $0x4,%esp
  801e6e:	8b 45 10             	mov    0x10(%ebp),%eax
  801e71:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801e74:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801e78:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7b:	6a 00                	push   $0x0
  801e7d:	6a 00                	push   $0x0
  801e7f:	52                   	push   %edx
  801e80:	ff 75 0c             	pushl  0xc(%ebp)
  801e83:	50                   	push   %eax
  801e84:	6a 00                	push   $0x0
  801e86:	e8 b2 ff ff ff       	call   801e3d <syscall>
  801e8b:	83 c4 18             	add    $0x18,%esp
}
  801e8e:	90                   	nop
  801e8f:	c9                   	leave  
  801e90:	c3                   	ret    

00801e91 <sys_cgetc>:

int
sys_cgetc(void)
{
  801e91:	55                   	push   %ebp
  801e92:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801e94:	6a 00                	push   $0x0
  801e96:	6a 00                	push   $0x0
  801e98:	6a 00                	push   $0x0
  801e9a:	6a 00                	push   $0x0
  801e9c:	6a 00                	push   $0x0
  801e9e:	6a 01                	push   $0x1
  801ea0:	e8 98 ff ff ff       	call   801e3d <syscall>
  801ea5:	83 c4 18             	add    $0x18,%esp
}
  801ea8:	c9                   	leave  
  801ea9:	c3                   	ret    

00801eaa <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801eaa:	55                   	push   %ebp
  801eab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801ead:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb3:	6a 00                	push   $0x0
  801eb5:	6a 00                	push   $0x0
  801eb7:	6a 00                	push   $0x0
  801eb9:	52                   	push   %edx
  801eba:	50                   	push   %eax
  801ebb:	6a 05                	push   $0x5
  801ebd:	e8 7b ff ff ff       	call   801e3d <syscall>
  801ec2:	83 c4 18             	add    $0x18,%esp
}
  801ec5:	c9                   	leave  
  801ec6:	c3                   	ret    

00801ec7 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801ec7:	55                   	push   %ebp
  801ec8:	89 e5                	mov    %esp,%ebp
  801eca:	56                   	push   %esi
  801ecb:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801ecc:	8b 75 18             	mov    0x18(%ebp),%esi
  801ecf:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ed2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ed5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  801edb:	56                   	push   %esi
  801edc:	53                   	push   %ebx
  801edd:	51                   	push   %ecx
  801ede:	52                   	push   %edx
  801edf:	50                   	push   %eax
  801ee0:	6a 06                	push   $0x6
  801ee2:	e8 56 ff ff ff       	call   801e3d <syscall>
  801ee7:	83 c4 18             	add    $0x18,%esp
}
  801eea:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801eed:	5b                   	pop    %ebx
  801eee:	5e                   	pop    %esi
  801eef:	5d                   	pop    %ebp
  801ef0:	c3                   	ret    

00801ef1 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801ef1:	55                   	push   %ebp
  801ef2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801ef4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ef7:	8b 45 08             	mov    0x8(%ebp),%eax
  801efa:	6a 00                	push   $0x0
  801efc:	6a 00                	push   $0x0
  801efe:	6a 00                	push   $0x0
  801f00:	52                   	push   %edx
  801f01:	50                   	push   %eax
  801f02:	6a 07                	push   $0x7
  801f04:	e8 34 ff ff ff       	call   801e3d <syscall>
  801f09:	83 c4 18             	add    $0x18,%esp
}
  801f0c:	c9                   	leave  
  801f0d:	c3                   	ret    

00801f0e <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801f0e:	55                   	push   %ebp
  801f0f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801f11:	6a 00                	push   $0x0
  801f13:	6a 00                	push   $0x0
  801f15:	6a 00                	push   $0x0
  801f17:	ff 75 0c             	pushl  0xc(%ebp)
  801f1a:	ff 75 08             	pushl  0x8(%ebp)
  801f1d:	6a 08                	push   $0x8
  801f1f:	e8 19 ff ff ff       	call   801e3d <syscall>
  801f24:	83 c4 18             	add    $0x18,%esp
}
  801f27:	c9                   	leave  
  801f28:	c3                   	ret    

00801f29 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801f29:	55                   	push   %ebp
  801f2a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801f2c:	6a 00                	push   $0x0
  801f2e:	6a 00                	push   $0x0
  801f30:	6a 00                	push   $0x0
  801f32:	6a 00                	push   $0x0
  801f34:	6a 00                	push   $0x0
  801f36:	6a 09                	push   $0x9
  801f38:	e8 00 ff ff ff       	call   801e3d <syscall>
  801f3d:	83 c4 18             	add    $0x18,%esp
}
  801f40:	c9                   	leave  
  801f41:	c3                   	ret    

00801f42 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801f42:	55                   	push   %ebp
  801f43:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801f45:	6a 00                	push   $0x0
  801f47:	6a 00                	push   $0x0
  801f49:	6a 00                	push   $0x0
  801f4b:	6a 00                	push   $0x0
  801f4d:	6a 00                	push   $0x0
  801f4f:	6a 0a                	push   $0xa
  801f51:	e8 e7 fe ff ff       	call   801e3d <syscall>
  801f56:	83 c4 18             	add    $0x18,%esp
}
  801f59:	c9                   	leave  
  801f5a:	c3                   	ret    

00801f5b <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801f5b:	55                   	push   %ebp
  801f5c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801f5e:	6a 00                	push   $0x0
  801f60:	6a 00                	push   $0x0
  801f62:	6a 00                	push   $0x0
  801f64:	6a 00                	push   $0x0
  801f66:	6a 00                	push   $0x0
  801f68:	6a 0b                	push   $0xb
  801f6a:	e8 ce fe ff ff       	call   801e3d <syscall>
  801f6f:	83 c4 18             	add    $0x18,%esp
}
  801f72:	c9                   	leave  
  801f73:	c3                   	ret    

00801f74 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801f74:	55                   	push   %ebp
  801f75:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801f77:	6a 00                	push   $0x0
  801f79:	6a 00                	push   $0x0
  801f7b:	6a 00                	push   $0x0
  801f7d:	ff 75 0c             	pushl  0xc(%ebp)
  801f80:	ff 75 08             	pushl  0x8(%ebp)
  801f83:	6a 0f                	push   $0xf
  801f85:	e8 b3 fe ff ff       	call   801e3d <syscall>
  801f8a:	83 c4 18             	add    $0x18,%esp
	return;
  801f8d:	90                   	nop
}
  801f8e:	c9                   	leave  
  801f8f:	c3                   	ret    

00801f90 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801f90:	55                   	push   %ebp
  801f91:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801f93:	6a 00                	push   $0x0
  801f95:	6a 00                	push   $0x0
  801f97:	6a 00                	push   $0x0
  801f99:	ff 75 0c             	pushl  0xc(%ebp)
  801f9c:	ff 75 08             	pushl  0x8(%ebp)
  801f9f:	6a 10                	push   $0x10
  801fa1:	e8 97 fe ff ff       	call   801e3d <syscall>
  801fa6:	83 c4 18             	add    $0x18,%esp
	return ;
  801fa9:	90                   	nop
}
  801faa:	c9                   	leave  
  801fab:	c3                   	ret    

00801fac <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801fac:	55                   	push   %ebp
  801fad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801faf:	6a 00                	push   $0x0
  801fb1:	6a 00                	push   $0x0
  801fb3:	ff 75 10             	pushl  0x10(%ebp)
  801fb6:	ff 75 0c             	pushl  0xc(%ebp)
  801fb9:	ff 75 08             	pushl  0x8(%ebp)
  801fbc:	6a 11                	push   $0x11
  801fbe:	e8 7a fe ff ff       	call   801e3d <syscall>
  801fc3:	83 c4 18             	add    $0x18,%esp
	return ;
  801fc6:	90                   	nop
}
  801fc7:	c9                   	leave  
  801fc8:	c3                   	ret    

00801fc9 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801fc9:	55                   	push   %ebp
  801fca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801fcc:	6a 00                	push   $0x0
  801fce:	6a 00                	push   $0x0
  801fd0:	6a 00                	push   $0x0
  801fd2:	6a 00                	push   $0x0
  801fd4:	6a 00                	push   $0x0
  801fd6:	6a 0c                	push   $0xc
  801fd8:	e8 60 fe ff ff       	call   801e3d <syscall>
  801fdd:	83 c4 18             	add    $0x18,%esp
}
  801fe0:	c9                   	leave  
  801fe1:	c3                   	ret    

00801fe2 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801fe2:	55                   	push   %ebp
  801fe3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801fe5:	6a 00                	push   $0x0
  801fe7:	6a 00                	push   $0x0
  801fe9:	6a 00                	push   $0x0
  801feb:	6a 00                	push   $0x0
  801fed:	ff 75 08             	pushl  0x8(%ebp)
  801ff0:	6a 0d                	push   $0xd
  801ff2:	e8 46 fe ff ff       	call   801e3d <syscall>
  801ff7:	83 c4 18             	add    $0x18,%esp
}
  801ffa:	c9                   	leave  
  801ffb:	c3                   	ret    

00801ffc <sys_scarce_memory>:

void sys_scarce_memory()
{
  801ffc:	55                   	push   %ebp
  801ffd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801fff:	6a 00                	push   $0x0
  802001:	6a 00                	push   $0x0
  802003:	6a 00                	push   $0x0
  802005:	6a 00                	push   $0x0
  802007:	6a 00                	push   $0x0
  802009:	6a 0e                	push   $0xe
  80200b:	e8 2d fe ff ff       	call   801e3d <syscall>
  802010:	83 c4 18             	add    $0x18,%esp
}
  802013:	90                   	nop
  802014:	c9                   	leave  
  802015:	c3                   	ret    

00802016 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802016:	55                   	push   %ebp
  802017:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802019:	6a 00                	push   $0x0
  80201b:	6a 00                	push   $0x0
  80201d:	6a 00                	push   $0x0
  80201f:	6a 00                	push   $0x0
  802021:	6a 00                	push   $0x0
  802023:	6a 13                	push   $0x13
  802025:	e8 13 fe ff ff       	call   801e3d <syscall>
  80202a:	83 c4 18             	add    $0x18,%esp
}
  80202d:	90                   	nop
  80202e:	c9                   	leave  
  80202f:	c3                   	ret    

00802030 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802030:	55                   	push   %ebp
  802031:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802033:	6a 00                	push   $0x0
  802035:	6a 00                	push   $0x0
  802037:	6a 00                	push   $0x0
  802039:	6a 00                	push   $0x0
  80203b:	6a 00                	push   $0x0
  80203d:	6a 14                	push   $0x14
  80203f:	e8 f9 fd ff ff       	call   801e3d <syscall>
  802044:	83 c4 18             	add    $0x18,%esp
}
  802047:	90                   	nop
  802048:	c9                   	leave  
  802049:	c3                   	ret    

0080204a <sys_cputc>:


void
sys_cputc(const char c)
{
  80204a:	55                   	push   %ebp
  80204b:	89 e5                	mov    %esp,%ebp
  80204d:	83 ec 04             	sub    $0x4,%esp
  802050:	8b 45 08             	mov    0x8(%ebp),%eax
  802053:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802056:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80205a:	6a 00                	push   $0x0
  80205c:	6a 00                	push   $0x0
  80205e:	6a 00                	push   $0x0
  802060:	6a 00                	push   $0x0
  802062:	50                   	push   %eax
  802063:	6a 15                	push   $0x15
  802065:	e8 d3 fd ff ff       	call   801e3d <syscall>
  80206a:	83 c4 18             	add    $0x18,%esp
}
  80206d:	90                   	nop
  80206e:	c9                   	leave  
  80206f:	c3                   	ret    

00802070 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802070:	55                   	push   %ebp
  802071:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802073:	6a 00                	push   $0x0
  802075:	6a 00                	push   $0x0
  802077:	6a 00                	push   $0x0
  802079:	6a 00                	push   $0x0
  80207b:	6a 00                	push   $0x0
  80207d:	6a 16                	push   $0x16
  80207f:	e8 b9 fd ff ff       	call   801e3d <syscall>
  802084:	83 c4 18             	add    $0x18,%esp
}
  802087:	90                   	nop
  802088:	c9                   	leave  
  802089:	c3                   	ret    

0080208a <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80208a:	55                   	push   %ebp
  80208b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80208d:	8b 45 08             	mov    0x8(%ebp),%eax
  802090:	6a 00                	push   $0x0
  802092:	6a 00                	push   $0x0
  802094:	6a 00                	push   $0x0
  802096:	ff 75 0c             	pushl  0xc(%ebp)
  802099:	50                   	push   %eax
  80209a:	6a 17                	push   $0x17
  80209c:	e8 9c fd ff ff       	call   801e3d <syscall>
  8020a1:	83 c4 18             	add    $0x18,%esp
}
  8020a4:	c9                   	leave  
  8020a5:	c3                   	ret    

008020a6 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8020a6:	55                   	push   %ebp
  8020a7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8020a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8020af:	6a 00                	push   $0x0
  8020b1:	6a 00                	push   $0x0
  8020b3:	6a 00                	push   $0x0
  8020b5:	52                   	push   %edx
  8020b6:	50                   	push   %eax
  8020b7:	6a 1a                	push   $0x1a
  8020b9:	e8 7f fd ff ff       	call   801e3d <syscall>
  8020be:	83 c4 18             	add    $0x18,%esp
}
  8020c1:	c9                   	leave  
  8020c2:	c3                   	ret    

008020c3 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8020c3:	55                   	push   %ebp
  8020c4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8020c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020cc:	6a 00                	push   $0x0
  8020ce:	6a 00                	push   $0x0
  8020d0:	6a 00                	push   $0x0
  8020d2:	52                   	push   %edx
  8020d3:	50                   	push   %eax
  8020d4:	6a 18                	push   $0x18
  8020d6:	e8 62 fd ff ff       	call   801e3d <syscall>
  8020db:	83 c4 18             	add    $0x18,%esp
}
  8020de:	90                   	nop
  8020df:	c9                   	leave  
  8020e0:	c3                   	ret    

008020e1 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8020e1:	55                   	push   %ebp
  8020e2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8020e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ea:	6a 00                	push   $0x0
  8020ec:	6a 00                	push   $0x0
  8020ee:	6a 00                	push   $0x0
  8020f0:	52                   	push   %edx
  8020f1:	50                   	push   %eax
  8020f2:	6a 19                	push   $0x19
  8020f4:	e8 44 fd ff ff       	call   801e3d <syscall>
  8020f9:	83 c4 18             	add    $0x18,%esp
}
  8020fc:	90                   	nop
  8020fd:	c9                   	leave  
  8020fe:	c3                   	ret    

008020ff <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8020ff:	55                   	push   %ebp
  802100:	89 e5                	mov    %esp,%ebp
  802102:	83 ec 04             	sub    $0x4,%esp
  802105:	8b 45 10             	mov    0x10(%ebp),%eax
  802108:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80210b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80210e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802112:	8b 45 08             	mov    0x8(%ebp),%eax
  802115:	6a 00                	push   $0x0
  802117:	51                   	push   %ecx
  802118:	52                   	push   %edx
  802119:	ff 75 0c             	pushl  0xc(%ebp)
  80211c:	50                   	push   %eax
  80211d:	6a 1b                	push   $0x1b
  80211f:	e8 19 fd ff ff       	call   801e3d <syscall>
  802124:	83 c4 18             	add    $0x18,%esp
}
  802127:	c9                   	leave  
  802128:	c3                   	ret    

00802129 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802129:	55                   	push   %ebp
  80212a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80212c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80212f:	8b 45 08             	mov    0x8(%ebp),%eax
  802132:	6a 00                	push   $0x0
  802134:	6a 00                	push   $0x0
  802136:	6a 00                	push   $0x0
  802138:	52                   	push   %edx
  802139:	50                   	push   %eax
  80213a:	6a 1c                	push   $0x1c
  80213c:	e8 fc fc ff ff       	call   801e3d <syscall>
  802141:	83 c4 18             	add    $0x18,%esp
}
  802144:	c9                   	leave  
  802145:	c3                   	ret    

00802146 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802146:	55                   	push   %ebp
  802147:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802149:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80214c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80214f:	8b 45 08             	mov    0x8(%ebp),%eax
  802152:	6a 00                	push   $0x0
  802154:	6a 00                	push   $0x0
  802156:	51                   	push   %ecx
  802157:	52                   	push   %edx
  802158:	50                   	push   %eax
  802159:	6a 1d                	push   $0x1d
  80215b:	e8 dd fc ff ff       	call   801e3d <syscall>
  802160:	83 c4 18             	add    $0x18,%esp
}
  802163:	c9                   	leave  
  802164:	c3                   	ret    

00802165 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802165:	55                   	push   %ebp
  802166:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802168:	8b 55 0c             	mov    0xc(%ebp),%edx
  80216b:	8b 45 08             	mov    0x8(%ebp),%eax
  80216e:	6a 00                	push   $0x0
  802170:	6a 00                	push   $0x0
  802172:	6a 00                	push   $0x0
  802174:	52                   	push   %edx
  802175:	50                   	push   %eax
  802176:	6a 1e                	push   $0x1e
  802178:	e8 c0 fc ff ff       	call   801e3d <syscall>
  80217d:	83 c4 18             	add    $0x18,%esp
}
  802180:	c9                   	leave  
  802181:	c3                   	ret    

00802182 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802182:	55                   	push   %ebp
  802183:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802185:	6a 00                	push   $0x0
  802187:	6a 00                	push   $0x0
  802189:	6a 00                	push   $0x0
  80218b:	6a 00                	push   $0x0
  80218d:	6a 00                	push   $0x0
  80218f:	6a 1f                	push   $0x1f
  802191:	e8 a7 fc ff ff       	call   801e3d <syscall>
  802196:	83 c4 18             	add    $0x18,%esp
}
  802199:	c9                   	leave  
  80219a:	c3                   	ret    

0080219b <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80219b:	55                   	push   %ebp
  80219c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80219e:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a1:	6a 00                	push   $0x0
  8021a3:	ff 75 14             	pushl  0x14(%ebp)
  8021a6:	ff 75 10             	pushl  0x10(%ebp)
  8021a9:	ff 75 0c             	pushl  0xc(%ebp)
  8021ac:	50                   	push   %eax
  8021ad:	6a 20                	push   $0x20
  8021af:	e8 89 fc ff ff       	call   801e3d <syscall>
  8021b4:	83 c4 18             	add    $0x18,%esp
}
  8021b7:	c9                   	leave  
  8021b8:	c3                   	ret    

008021b9 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8021b9:	55                   	push   %ebp
  8021ba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8021bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bf:	6a 00                	push   $0x0
  8021c1:	6a 00                	push   $0x0
  8021c3:	6a 00                	push   $0x0
  8021c5:	6a 00                	push   $0x0
  8021c7:	50                   	push   %eax
  8021c8:	6a 21                	push   $0x21
  8021ca:	e8 6e fc ff ff       	call   801e3d <syscall>
  8021cf:	83 c4 18             	add    $0x18,%esp
}
  8021d2:	90                   	nop
  8021d3:	c9                   	leave  
  8021d4:	c3                   	ret    

008021d5 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8021d5:	55                   	push   %ebp
  8021d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8021d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021db:	6a 00                	push   $0x0
  8021dd:	6a 00                	push   $0x0
  8021df:	6a 00                	push   $0x0
  8021e1:	6a 00                	push   $0x0
  8021e3:	50                   	push   %eax
  8021e4:	6a 22                	push   $0x22
  8021e6:	e8 52 fc ff ff       	call   801e3d <syscall>
  8021eb:	83 c4 18             	add    $0x18,%esp
}
  8021ee:	c9                   	leave  
  8021ef:	c3                   	ret    

008021f0 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8021f0:	55                   	push   %ebp
  8021f1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8021f3:	6a 00                	push   $0x0
  8021f5:	6a 00                	push   $0x0
  8021f7:	6a 00                	push   $0x0
  8021f9:	6a 00                	push   $0x0
  8021fb:	6a 00                	push   $0x0
  8021fd:	6a 02                	push   $0x2
  8021ff:	e8 39 fc ff ff       	call   801e3d <syscall>
  802204:	83 c4 18             	add    $0x18,%esp
}
  802207:	c9                   	leave  
  802208:	c3                   	ret    

00802209 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802209:	55                   	push   %ebp
  80220a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80220c:	6a 00                	push   $0x0
  80220e:	6a 00                	push   $0x0
  802210:	6a 00                	push   $0x0
  802212:	6a 00                	push   $0x0
  802214:	6a 00                	push   $0x0
  802216:	6a 03                	push   $0x3
  802218:	e8 20 fc ff ff       	call   801e3d <syscall>
  80221d:	83 c4 18             	add    $0x18,%esp
}
  802220:	c9                   	leave  
  802221:	c3                   	ret    

00802222 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802222:	55                   	push   %ebp
  802223:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802225:	6a 00                	push   $0x0
  802227:	6a 00                	push   $0x0
  802229:	6a 00                	push   $0x0
  80222b:	6a 00                	push   $0x0
  80222d:	6a 00                	push   $0x0
  80222f:	6a 04                	push   $0x4
  802231:	e8 07 fc ff ff       	call   801e3d <syscall>
  802236:	83 c4 18             	add    $0x18,%esp
}
  802239:	c9                   	leave  
  80223a:	c3                   	ret    

0080223b <sys_exit_env>:


void sys_exit_env(void)
{
  80223b:	55                   	push   %ebp
  80223c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80223e:	6a 00                	push   $0x0
  802240:	6a 00                	push   $0x0
  802242:	6a 00                	push   $0x0
  802244:	6a 00                	push   $0x0
  802246:	6a 00                	push   $0x0
  802248:	6a 23                	push   $0x23
  80224a:	e8 ee fb ff ff       	call   801e3d <syscall>
  80224f:	83 c4 18             	add    $0x18,%esp
}
  802252:	90                   	nop
  802253:	c9                   	leave  
  802254:	c3                   	ret    

00802255 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802255:	55                   	push   %ebp
  802256:	89 e5                	mov    %esp,%ebp
  802258:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80225b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80225e:	8d 50 04             	lea    0x4(%eax),%edx
  802261:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802264:	6a 00                	push   $0x0
  802266:	6a 00                	push   $0x0
  802268:	6a 00                	push   $0x0
  80226a:	52                   	push   %edx
  80226b:	50                   	push   %eax
  80226c:	6a 24                	push   $0x24
  80226e:	e8 ca fb ff ff       	call   801e3d <syscall>
  802273:	83 c4 18             	add    $0x18,%esp
	return result;
  802276:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802279:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80227c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80227f:	89 01                	mov    %eax,(%ecx)
  802281:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802284:	8b 45 08             	mov    0x8(%ebp),%eax
  802287:	c9                   	leave  
  802288:	c2 04 00             	ret    $0x4

0080228b <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80228b:	55                   	push   %ebp
  80228c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80228e:	6a 00                	push   $0x0
  802290:	6a 00                	push   $0x0
  802292:	ff 75 10             	pushl  0x10(%ebp)
  802295:	ff 75 0c             	pushl  0xc(%ebp)
  802298:	ff 75 08             	pushl  0x8(%ebp)
  80229b:	6a 12                	push   $0x12
  80229d:	e8 9b fb ff ff       	call   801e3d <syscall>
  8022a2:	83 c4 18             	add    $0x18,%esp
	return ;
  8022a5:	90                   	nop
}
  8022a6:	c9                   	leave  
  8022a7:	c3                   	ret    

008022a8 <sys_rcr2>:
uint32 sys_rcr2()
{
  8022a8:	55                   	push   %ebp
  8022a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8022ab:	6a 00                	push   $0x0
  8022ad:	6a 00                	push   $0x0
  8022af:	6a 00                	push   $0x0
  8022b1:	6a 00                	push   $0x0
  8022b3:	6a 00                	push   $0x0
  8022b5:	6a 25                	push   $0x25
  8022b7:	e8 81 fb ff ff       	call   801e3d <syscall>
  8022bc:	83 c4 18             	add    $0x18,%esp
}
  8022bf:	c9                   	leave  
  8022c0:	c3                   	ret    

008022c1 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8022c1:	55                   	push   %ebp
  8022c2:	89 e5                	mov    %esp,%ebp
  8022c4:	83 ec 04             	sub    $0x4,%esp
  8022c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ca:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8022cd:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8022d1:	6a 00                	push   $0x0
  8022d3:	6a 00                	push   $0x0
  8022d5:	6a 00                	push   $0x0
  8022d7:	6a 00                	push   $0x0
  8022d9:	50                   	push   %eax
  8022da:	6a 26                	push   $0x26
  8022dc:	e8 5c fb ff ff       	call   801e3d <syscall>
  8022e1:	83 c4 18             	add    $0x18,%esp
	return ;
  8022e4:	90                   	nop
}
  8022e5:	c9                   	leave  
  8022e6:	c3                   	ret    

008022e7 <rsttst>:
void rsttst()
{
  8022e7:	55                   	push   %ebp
  8022e8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8022ea:	6a 00                	push   $0x0
  8022ec:	6a 00                	push   $0x0
  8022ee:	6a 00                	push   $0x0
  8022f0:	6a 00                	push   $0x0
  8022f2:	6a 00                	push   $0x0
  8022f4:	6a 28                	push   $0x28
  8022f6:	e8 42 fb ff ff       	call   801e3d <syscall>
  8022fb:	83 c4 18             	add    $0x18,%esp
	return ;
  8022fe:	90                   	nop
}
  8022ff:	c9                   	leave  
  802300:	c3                   	ret    

00802301 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802301:	55                   	push   %ebp
  802302:	89 e5                	mov    %esp,%ebp
  802304:	83 ec 04             	sub    $0x4,%esp
  802307:	8b 45 14             	mov    0x14(%ebp),%eax
  80230a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80230d:	8b 55 18             	mov    0x18(%ebp),%edx
  802310:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802314:	52                   	push   %edx
  802315:	50                   	push   %eax
  802316:	ff 75 10             	pushl  0x10(%ebp)
  802319:	ff 75 0c             	pushl  0xc(%ebp)
  80231c:	ff 75 08             	pushl  0x8(%ebp)
  80231f:	6a 27                	push   $0x27
  802321:	e8 17 fb ff ff       	call   801e3d <syscall>
  802326:	83 c4 18             	add    $0x18,%esp
	return ;
  802329:	90                   	nop
}
  80232a:	c9                   	leave  
  80232b:	c3                   	ret    

0080232c <chktst>:
void chktst(uint32 n)
{
  80232c:	55                   	push   %ebp
  80232d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80232f:	6a 00                	push   $0x0
  802331:	6a 00                	push   $0x0
  802333:	6a 00                	push   $0x0
  802335:	6a 00                	push   $0x0
  802337:	ff 75 08             	pushl  0x8(%ebp)
  80233a:	6a 29                	push   $0x29
  80233c:	e8 fc fa ff ff       	call   801e3d <syscall>
  802341:	83 c4 18             	add    $0x18,%esp
	return ;
  802344:	90                   	nop
}
  802345:	c9                   	leave  
  802346:	c3                   	ret    

00802347 <inctst>:

void inctst()
{
  802347:	55                   	push   %ebp
  802348:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80234a:	6a 00                	push   $0x0
  80234c:	6a 00                	push   $0x0
  80234e:	6a 00                	push   $0x0
  802350:	6a 00                	push   $0x0
  802352:	6a 00                	push   $0x0
  802354:	6a 2a                	push   $0x2a
  802356:	e8 e2 fa ff ff       	call   801e3d <syscall>
  80235b:	83 c4 18             	add    $0x18,%esp
	return ;
  80235e:	90                   	nop
}
  80235f:	c9                   	leave  
  802360:	c3                   	ret    

00802361 <gettst>:
uint32 gettst()
{
  802361:	55                   	push   %ebp
  802362:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802364:	6a 00                	push   $0x0
  802366:	6a 00                	push   $0x0
  802368:	6a 00                	push   $0x0
  80236a:	6a 00                	push   $0x0
  80236c:	6a 00                	push   $0x0
  80236e:	6a 2b                	push   $0x2b
  802370:	e8 c8 fa ff ff       	call   801e3d <syscall>
  802375:	83 c4 18             	add    $0x18,%esp
}
  802378:	c9                   	leave  
  802379:	c3                   	ret    

0080237a <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80237a:	55                   	push   %ebp
  80237b:	89 e5                	mov    %esp,%ebp
  80237d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802380:	6a 00                	push   $0x0
  802382:	6a 00                	push   $0x0
  802384:	6a 00                	push   $0x0
  802386:	6a 00                	push   $0x0
  802388:	6a 00                	push   $0x0
  80238a:	6a 2c                	push   $0x2c
  80238c:	e8 ac fa ff ff       	call   801e3d <syscall>
  802391:	83 c4 18             	add    $0x18,%esp
  802394:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802397:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80239b:	75 07                	jne    8023a4 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80239d:	b8 01 00 00 00       	mov    $0x1,%eax
  8023a2:	eb 05                	jmp    8023a9 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8023a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023a9:	c9                   	leave  
  8023aa:	c3                   	ret    

008023ab <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8023ab:	55                   	push   %ebp
  8023ac:	89 e5                	mov    %esp,%ebp
  8023ae:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023b1:	6a 00                	push   $0x0
  8023b3:	6a 00                	push   $0x0
  8023b5:	6a 00                	push   $0x0
  8023b7:	6a 00                	push   $0x0
  8023b9:	6a 00                	push   $0x0
  8023bb:	6a 2c                	push   $0x2c
  8023bd:	e8 7b fa ff ff       	call   801e3d <syscall>
  8023c2:	83 c4 18             	add    $0x18,%esp
  8023c5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8023c8:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8023cc:	75 07                	jne    8023d5 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8023ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8023d3:	eb 05                	jmp    8023da <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8023d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023da:	c9                   	leave  
  8023db:	c3                   	ret    

008023dc <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8023dc:	55                   	push   %ebp
  8023dd:	89 e5                	mov    %esp,%ebp
  8023df:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023e2:	6a 00                	push   $0x0
  8023e4:	6a 00                	push   $0x0
  8023e6:	6a 00                	push   $0x0
  8023e8:	6a 00                	push   $0x0
  8023ea:	6a 00                	push   $0x0
  8023ec:	6a 2c                	push   $0x2c
  8023ee:	e8 4a fa ff ff       	call   801e3d <syscall>
  8023f3:	83 c4 18             	add    $0x18,%esp
  8023f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8023f9:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8023fd:	75 07                	jne    802406 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8023ff:	b8 01 00 00 00       	mov    $0x1,%eax
  802404:	eb 05                	jmp    80240b <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802406:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80240b:	c9                   	leave  
  80240c:	c3                   	ret    

0080240d <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80240d:	55                   	push   %ebp
  80240e:	89 e5                	mov    %esp,%ebp
  802410:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802413:	6a 00                	push   $0x0
  802415:	6a 00                	push   $0x0
  802417:	6a 00                	push   $0x0
  802419:	6a 00                	push   $0x0
  80241b:	6a 00                	push   $0x0
  80241d:	6a 2c                	push   $0x2c
  80241f:	e8 19 fa ff ff       	call   801e3d <syscall>
  802424:	83 c4 18             	add    $0x18,%esp
  802427:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80242a:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80242e:	75 07                	jne    802437 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802430:	b8 01 00 00 00       	mov    $0x1,%eax
  802435:	eb 05                	jmp    80243c <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802437:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80243c:	c9                   	leave  
  80243d:	c3                   	ret    

0080243e <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80243e:	55                   	push   %ebp
  80243f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802441:	6a 00                	push   $0x0
  802443:	6a 00                	push   $0x0
  802445:	6a 00                	push   $0x0
  802447:	6a 00                	push   $0x0
  802449:	ff 75 08             	pushl  0x8(%ebp)
  80244c:	6a 2d                	push   $0x2d
  80244e:	e8 ea f9 ff ff       	call   801e3d <syscall>
  802453:	83 c4 18             	add    $0x18,%esp
	return ;
  802456:	90                   	nop
}
  802457:	c9                   	leave  
  802458:	c3                   	ret    

00802459 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802459:	55                   	push   %ebp
  80245a:	89 e5                	mov    %esp,%ebp
  80245c:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80245d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802460:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802463:	8b 55 0c             	mov    0xc(%ebp),%edx
  802466:	8b 45 08             	mov    0x8(%ebp),%eax
  802469:	6a 00                	push   $0x0
  80246b:	53                   	push   %ebx
  80246c:	51                   	push   %ecx
  80246d:	52                   	push   %edx
  80246e:	50                   	push   %eax
  80246f:	6a 2e                	push   $0x2e
  802471:	e8 c7 f9 ff ff       	call   801e3d <syscall>
  802476:	83 c4 18             	add    $0x18,%esp
}
  802479:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80247c:	c9                   	leave  
  80247d:	c3                   	ret    

0080247e <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80247e:	55                   	push   %ebp
  80247f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802481:	8b 55 0c             	mov    0xc(%ebp),%edx
  802484:	8b 45 08             	mov    0x8(%ebp),%eax
  802487:	6a 00                	push   $0x0
  802489:	6a 00                	push   $0x0
  80248b:	6a 00                	push   $0x0
  80248d:	52                   	push   %edx
  80248e:	50                   	push   %eax
  80248f:	6a 2f                	push   $0x2f
  802491:	e8 a7 f9 ff ff       	call   801e3d <syscall>
  802496:	83 c4 18             	add    $0x18,%esp
}
  802499:	c9                   	leave  
  80249a:	c3                   	ret    

0080249b <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  80249b:	55                   	push   %ebp
  80249c:	89 e5                	mov    %esp,%ebp
  80249e:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8024a1:	83 ec 0c             	sub    $0xc,%esp
  8024a4:	68 d8 45 80 00       	push   $0x8045d8
  8024a9:	e8 86 e5 ff ff       	call   800a34 <cprintf>
  8024ae:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8024b1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8024b8:	83 ec 0c             	sub    $0xc,%esp
  8024bb:	68 04 46 80 00       	push   $0x804604
  8024c0:	e8 6f e5 ff ff       	call   800a34 <cprintf>
  8024c5:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8024c8:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8024cc:	a1 38 51 80 00       	mov    0x805138,%eax
  8024d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024d4:	eb 56                	jmp    80252c <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8024d6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024da:	74 1c                	je     8024f8 <print_mem_block_lists+0x5d>
  8024dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024df:	8b 50 08             	mov    0x8(%eax),%edx
  8024e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024e5:	8b 48 08             	mov    0x8(%eax),%ecx
  8024e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024eb:	8b 40 0c             	mov    0xc(%eax),%eax
  8024ee:	01 c8                	add    %ecx,%eax
  8024f0:	39 c2                	cmp    %eax,%edx
  8024f2:	73 04                	jae    8024f8 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8024f4:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8024f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fb:	8b 50 08             	mov    0x8(%eax),%edx
  8024fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802501:	8b 40 0c             	mov    0xc(%eax),%eax
  802504:	01 c2                	add    %eax,%edx
  802506:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802509:	8b 40 08             	mov    0x8(%eax),%eax
  80250c:	83 ec 04             	sub    $0x4,%esp
  80250f:	52                   	push   %edx
  802510:	50                   	push   %eax
  802511:	68 19 46 80 00       	push   $0x804619
  802516:	e8 19 e5 ff ff       	call   800a34 <cprintf>
  80251b:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80251e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802521:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802524:	a1 40 51 80 00       	mov    0x805140,%eax
  802529:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80252c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802530:	74 07                	je     802539 <print_mem_block_lists+0x9e>
  802532:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802535:	8b 00                	mov    (%eax),%eax
  802537:	eb 05                	jmp    80253e <print_mem_block_lists+0xa3>
  802539:	b8 00 00 00 00       	mov    $0x0,%eax
  80253e:	a3 40 51 80 00       	mov    %eax,0x805140
  802543:	a1 40 51 80 00       	mov    0x805140,%eax
  802548:	85 c0                	test   %eax,%eax
  80254a:	75 8a                	jne    8024d6 <print_mem_block_lists+0x3b>
  80254c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802550:	75 84                	jne    8024d6 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802552:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802556:	75 10                	jne    802568 <print_mem_block_lists+0xcd>
  802558:	83 ec 0c             	sub    $0xc,%esp
  80255b:	68 28 46 80 00       	push   $0x804628
  802560:	e8 cf e4 ff ff       	call   800a34 <cprintf>
  802565:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802568:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80256f:	83 ec 0c             	sub    $0xc,%esp
  802572:	68 4c 46 80 00       	push   $0x80464c
  802577:	e8 b8 e4 ff ff       	call   800a34 <cprintf>
  80257c:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80257f:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802583:	a1 40 50 80 00       	mov    0x805040,%eax
  802588:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80258b:	eb 56                	jmp    8025e3 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80258d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802591:	74 1c                	je     8025af <print_mem_block_lists+0x114>
  802593:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802596:	8b 50 08             	mov    0x8(%eax),%edx
  802599:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80259c:	8b 48 08             	mov    0x8(%eax),%ecx
  80259f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025a2:	8b 40 0c             	mov    0xc(%eax),%eax
  8025a5:	01 c8                	add    %ecx,%eax
  8025a7:	39 c2                	cmp    %eax,%edx
  8025a9:	73 04                	jae    8025af <print_mem_block_lists+0x114>
			sorted = 0 ;
  8025ab:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8025af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b2:	8b 50 08             	mov    0x8(%eax),%edx
  8025b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b8:	8b 40 0c             	mov    0xc(%eax),%eax
  8025bb:	01 c2                	add    %eax,%edx
  8025bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c0:	8b 40 08             	mov    0x8(%eax),%eax
  8025c3:	83 ec 04             	sub    $0x4,%esp
  8025c6:	52                   	push   %edx
  8025c7:	50                   	push   %eax
  8025c8:	68 19 46 80 00       	push   $0x804619
  8025cd:	e8 62 e4 ff ff       	call   800a34 <cprintf>
  8025d2:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8025d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8025db:	a1 48 50 80 00       	mov    0x805048,%eax
  8025e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025e7:	74 07                	je     8025f0 <print_mem_block_lists+0x155>
  8025e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ec:	8b 00                	mov    (%eax),%eax
  8025ee:	eb 05                	jmp    8025f5 <print_mem_block_lists+0x15a>
  8025f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8025f5:	a3 48 50 80 00       	mov    %eax,0x805048
  8025fa:	a1 48 50 80 00       	mov    0x805048,%eax
  8025ff:	85 c0                	test   %eax,%eax
  802601:	75 8a                	jne    80258d <print_mem_block_lists+0xf2>
  802603:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802607:	75 84                	jne    80258d <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802609:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80260d:	75 10                	jne    80261f <print_mem_block_lists+0x184>
  80260f:	83 ec 0c             	sub    $0xc,%esp
  802612:	68 64 46 80 00       	push   $0x804664
  802617:	e8 18 e4 ff ff       	call   800a34 <cprintf>
  80261c:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80261f:	83 ec 0c             	sub    $0xc,%esp
  802622:	68 d8 45 80 00       	push   $0x8045d8
  802627:	e8 08 e4 ff ff       	call   800a34 <cprintf>
  80262c:	83 c4 10             	add    $0x10,%esp

}
  80262f:	90                   	nop
  802630:	c9                   	leave  
  802631:	c3                   	ret    

00802632 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802632:	55                   	push   %ebp
  802633:	89 e5                	mov    %esp,%ebp
  802635:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  802638:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  80263f:	00 00 00 
  802642:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802649:	00 00 00 
  80264c:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802653:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  802656:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80265d:	e9 9e 00 00 00       	jmp    802700 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802662:	a1 50 50 80 00       	mov    0x805050,%eax
  802667:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80266a:	c1 e2 04             	shl    $0x4,%edx
  80266d:	01 d0                	add    %edx,%eax
  80266f:	85 c0                	test   %eax,%eax
  802671:	75 14                	jne    802687 <initialize_MemBlocksList+0x55>
  802673:	83 ec 04             	sub    $0x4,%esp
  802676:	68 8c 46 80 00       	push   $0x80468c
  80267b:	6a 46                	push   $0x46
  80267d:	68 af 46 80 00       	push   $0x8046af
  802682:	e8 f9 e0 ff ff       	call   800780 <_panic>
  802687:	a1 50 50 80 00       	mov    0x805050,%eax
  80268c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80268f:	c1 e2 04             	shl    $0x4,%edx
  802692:	01 d0                	add    %edx,%eax
  802694:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80269a:	89 10                	mov    %edx,(%eax)
  80269c:	8b 00                	mov    (%eax),%eax
  80269e:	85 c0                	test   %eax,%eax
  8026a0:	74 18                	je     8026ba <initialize_MemBlocksList+0x88>
  8026a2:	a1 48 51 80 00       	mov    0x805148,%eax
  8026a7:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8026ad:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8026b0:	c1 e1 04             	shl    $0x4,%ecx
  8026b3:	01 ca                	add    %ecx,%edx
  8026b5:	89 50 04             	mov    %edx,0x4(%eax)
  8026b8:	eb 12                	jmp    8026cc <initialize_MemBlocksList+0x9a>
  8026ba:	a1 50 50 80 00       	mov    0x805050,%eax
  8026bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026c2:	c1 e2 04             	shl    $0x4,%edx
  8026c5:	01 d0                	add    %edx,%eax
  8026c7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8026cc:	a1 50 50 80 00       	mov    0x805050,%eax
  8026d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026d4:	c1 e2 04             	shl    $0x4,%edx
  8026d7:	01 d0                	add    %edx,%eax
  8026d9:	a3 48 51 80 00       	mov    %eax,0x805148
  8026de:	a1 50 50 80 00       	mov    0x805050,%eax
  8026e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026e6:	c1 e2 04             	shl    $0x4,%edx
  8026e9:	01 d0                	add    %edx,%eax
  8026eb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026f2:	a1 54 51 80 00       	mov    0x805154,%eax
  8026f7:	40                   	inc    %eax
  8026f8:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  8026fd:	ff 45 f4             	incl   -0xc(%ebp)
  802700:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802703:	3b 45 08             	cmp    0x8(%ebp),%eax
  802706:	0f 82 56 ff ff ff    	jb     802662 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  80270c:	90                   	nop
  80270d:	c9                   	leave  
  80270e:	c3                   	ret    

0080270f <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80270f:	55                   	push   %ebp
  802710:	89 e5                	mov    %esp,%ebp
  802712:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802715:	8b 45 08             	mov    0x8(%ebp),%eax
  802718:	8b 00                	mov    (%eax),%eax
  80271a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80271d:	eb 19                	jmp    802738 <find_block+0x29>
	{
		if(va==point->sva)
  80271f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802722:	8b 40 08             	mov    0x8(%eax),%eax
  802725:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802728:	75 05                	jne    80272f <find_block+0x20>
		   return point;
  80272a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80272d:	eb 36                	jmp    802765 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80272f:	8b 45 08             	mov    0x8(%ebp),%eax
  802732:	8b 40 08             	mov    0x8(%eax),%eax
  802735:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802738:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80273c:	74 07                	je     802745 <find_block+0x36>
  80273e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802741:	8b 00                	mov    (%eax),%eax
  802743:	eb 05                	jmp    80274a <find_block+0x3b>
  802745:	b8 00 00 00 00       	mov    $0x0,%eax
  80274a:	8b 55 08             	mov    0x8(%ebp),%edx
  80274d:	89 42 08             	mov    %eax,0x8(%edx)
  802750:	8b 45 08             	mov    0x8(%ebp),%eax
  802753:	8b 40 08             	mov    0x8(%eax),%eax
  802756:	85 c0                	test   %eax,%eax
  802758:	75 c5                	jne    80271f <find_block+0x10>
  80275a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80275e:	75 bf                	jne    80271f <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802760:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802765:	c9                   	leave  
  802766:	c3                   	ret    

00802767 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802767:	55                   	push   %ebp
  802768:	89 e5                	mov    %esp,%ebp
  80276a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  80276d:	a1 40 50 80 00       	mov    0x805040,%eax
  802772:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802775:	a1 44 50 80 00       	mov    0x805044,%eax
  80277a:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  80277d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802780:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802783:	74 24                	je     8027a9 <insert_sorted_allocList+0x42>
  802785:	8b 45 08             	mov    0x8(%ebp),%eax
  802788:	8b 50 08             	mov    0x8(%eax),%edx
  80278b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80278e:	8b 40 08             	mov    0x8(%eax),%eax
  802791:	39 c2                	cmp    %eax,%edx
  802793:	76 14                	jbe    8027a9 <insert_sorted_allocList+0x42>
  802795:	8b 45 08             	mov    0x8(%ebp),%eax
  802798:	8b 50 08             	mov    0x8(%eax),%edx
  80279b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80279e:	8b 40 08             	mov    0x8(%eax),%eax
  8027a1:	39 c2                	cmp    %eax,%edx
  8027a3:	0f 82 60 01 00 00    	jb     802909 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8027a9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027ad:	75 65                	jne    802814 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8027af:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8027b3:	75 14                	jne    8027c9 <insert_sorted_allocList+0x62>
  8027b5:	83 ec 04             	sub    $0x4,%esp
  8027b8:	68 8c 46 80 00       	push   $0x80468c
  8027bd:	6a 6b                	push   $0x6b
  8027bf:	68 af 46 80 00       	push   $0x8046af
  8027c4:	e8 b7 df ff ff       	call   800780 <_panic>
  8027c9:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8027cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d2:	89 10                	mov    %edx,(%eax)
  8027d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d7:	8b 00                	mov    (%eax),%eax
  8027d9:	85 c0                	test   %eax,%eax
  8027db:	74 0d                	je     8027ea <insert_sorted_allocList+0x83>
  8027dd:	a1 40 50 80 00       	mov    0x805040,%eax
  8027e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8027e5:	89 50 04             	mov    %edx,0x4(%eax)
  8027e8:	eb 08                	jmp    8027f2 <insert_sorted_allocList+0x8b>
  8027ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ed:	a3 44 50 80 00       	mov    %eax,0x805044
  8027f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f5:	a3 40 50 80 00       	mov    %eax,0x805040
  8027fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8027fd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802804:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802809:	40                   	inc    %eax
  80280a:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80280f:	e9 dc 01 00 00       	jmp    8029f0 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802814:	8b 45 08             	mov    0x8(%ebp),%eax
  802817:	8b 50 08             	mov    0x8(%eax),%edx
  80281a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80281d:	8b 40 08             	mov    0x8(%eax),%eax
  802820:	39 c2                	cmp    %eax,%edx
  802822:	77 6c                	ja     802890 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802824:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802828:	74 06                	je     802830 <insert_sorted_allocList+0xc9>
  80282a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80282e:	75 14                	jne    802844 <insert_sorted_allocList+0xdd>
  802830:	83 ec 04             	sub    $0x4,%esp
  802833:	68 c8 46 80 00       	push   $0x8046c8
  802838:	6a 6f                	push   $0x6f
  80283a:	68 af 46 80 00       	push   $0x8046af
  80283f:	e8 3c df ff ff       	call   800780 <_panic>
  802844:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802847:	8b 50 04             	mov    0x4(%eax),%edx
  80284a:	8b 45 08             	mov    0x8(%ebp),%eax
  80284d:	89 50 04             	mov    %edx,0x4(%eax)
  802850:	8b 45 08             	mov    0x8(%ebp),%eax
  802853:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802856:	89 10                	mov    %edx,(%eax)
  802858:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80285b:	8b 40 04             	mov    0x4(%eax),%eax
  80285e:	85 c0                	test   %eax,%eax
  802860:	74 0d                	je     80286f <insert_sorted_allocList+0x108>
  802862:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802865:	8b 40 04             	mov    0x4(%eax),%eax
  802868:	8b 55 08             	mov    0x8(%ebp),%edx
  80286b:	89 10                	mov    %edx,(%eax)
  80286d:	eb 08                	jmp    802877 <insert_sorted_allocList+0x110>
  80286f:	8b 45 08             	mov    0x8(%ebp),%eax
  802872:	a3 40 50 80 00       	mov    %eax,0x805040
  802877:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80287a:	8b 55 08             	mov    0x8(%ebp),%edx
  80287d:	89 50 04             	mov    %edx,0x4(%eax)
  802880:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802885:	40                   	inc    %eax
  802886:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80288b:	e9 60 01 00 00       	jmp    8029f0 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802890:	8b 45 08             	mov    0x8(%ebp),%eax
  802893:	8b 50 08             	mov    0x8(%eax),%edx
  802896:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802899:	8b 40 08             	mov    0x8(%eax),%eax
  80289c:	39 c2                	cmp    %eax,%edx
  80289e:	0f 82 4c 01 00 00    	jb     8029f0 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8028a4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028a8:	75 14                	jne    8028be <insert_sorted_allocList+0x157>
  8028aa:	83 ec 04             	sub    $0x4,%esp
  8028ad:	68 00 47 80 00       	push   $0x804700
  8028b2:	6a 73                	push   $0x73
  8028b4:	68 af 46 80 00       	push   $0x8046af
  8028b9:	e8 c2 de ff ff       	call   800780 <_panic>
  8028be:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8028c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c7:	89 50 04             	mov    %edx,0x4(%eax)
  8028ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8028cd:	8b 40 04             	mov    0x4(%eax),%eax
  8028d0:	85 c0                	test   %eax,%eax
  8028d2:	74 0c                	je     8028e0 <insert_sorted_allocList+0x179>
  8028d4:	a1 44 50 80 00       	mov    0x805044,%eax
  8028d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8028dc:	89 10                	mov    %edx,(%eax)
  8028de:	eb 08                	jmp    8028e8 <insert_sorted_allocList+0x181>
  8028e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e3:	a3 40 50 80 00       	mov    %eax,0x805040
  8028e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8028eb:	a3 44 50 80 00       	mov    %eax,0x805044
  8028f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028f9:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8028fe:	40                   	inc    %eax
  8028ff:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802904:	e9 e7 00 00 00       	jmp    8029f0 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802909:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80290c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  80290f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802916:	a1 40 50 80 00       	mov    0x805040,%eax
  80291b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80291e:	e9 9d 00 00 00       	jmp    8029c0 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802923:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802926:	8b 00                	mov    (%eax),%eax
  802928:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  80292b:	8b 45 08             	mov    0x8(%ebp),%eax
  80292e:	8b 50 08             	mov    0x8(%eax),%edx
  802931:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802934:	8b 40 08             	mov    0x8(%eax),%eax
  802937:	39 c2                	cmp    %eax,%edx
  802939:	76 7d                	jbe    8029b8 <insert_sorted_allocList+0x251>
  80293b:	8b 45 08             	mov    0x8(%ebp),%eax
  80293e:	8b 50 08             	mov    0x8(%eax),%edx
  802941:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802944:	8b 40 08             	mov    0x8(%eax),%eax
  802947:	39 c2                	cmp    %eax,%edx
  802949:	73 6d                	jae    8029b8 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  80294b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80294f:	74 06                	je     802957 <insert_sorted_allocList+0x1f0>
  802951:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802955:	75 14                	jne    80296b <insert_sorted_allocList+0x204>
  802957:	83 ec 04             	sub    $0x4,%esp
  80295a:	68 24 47 80 00       	push   $0x804724
  80295f:	6a 7f                	push   $0x7f
  802961:	68 af 46 80 00       	push   $0x8046af
  802966:	e8 15 de ff ff       	call   800780 <_panic>
  80296b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296e:	8b 10                	mov    (%eax),%edx
  802970:	8b 45 08             	mov    0x8(%ebp),%eax
  802973:	89 10                	mov    %edx,(%eax)
  802975:	8b 45 08             	mov    0x8(%ebp),%eax
  802978:	8b 00                	mov    (%eax),%eax
  80297a:	85 c0                	test   %eax,%eax
  80297c:	74 0b                	je     802989 <insert_sorted_allocList+0x222>
  80297e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802981:	8b 00                	mov    (%eax),%eax
  802983:	8b 55 08             	mov    0x8(%ebp),%edx
  802986:	89 50 04             	mov    %edx,0x4(%eax)
  802989:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298c:	8b 55 08             	mov    0x8(%ebp),%edx
  80298f:	89 10                	mov    %edx,(%eax)
  802991:	8b 45 08             	mov    0x8(%ebp),%eax
  802994:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802997:	89 50 04             	mov    %edx,0x4(%eax)
  80299a:	8b 45 08             	mov    0x8(%ebp),%eax
  80299d:	8b 00                	mov    (%eax),%eax
  80299f:	85 c0                	test   %eax,%eax
  8029a1:	75 08                	jne    8029ab <insert_sorted_allocList+0x244>
  8029a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a6:	a3 44 50 80 00       	mov    %eax,0x805044
  8029ab:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8029b0:	40                   	inc    %eax
  8029b1:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8029b6:	eb 39                	jmp    8029f1 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8029b8:	a1 48 50 80 00       	mov    0x805048,%eax
  8029bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029c4:	74 07                	je     8029cd <insert_sorted_allocList+0x266>
  8029c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c9:	8b 00                	mov    (%eax),%eax
  8029cb:	eb 05                	jmp    8029d2 <insert_sorted_allocList+0x26b>
  8029cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8029d2:	a3 48 50 80 00       	mov    %eax,0x805048
  8029d7:	a1 48 50 80 00       	mov    0x805048,%eax
  8029dc:	85 c0                	test   %eax,%eax
  8029de:	0f 85 3f ff ff ff    	jne    802923 <insert_sorted_allocList+0x1bc>
  8029e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029e8:	0f 85 35 ff ff ff    	jne    802923 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8029ee:	eb 01                	jmp    8029f1 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8029f0:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8029f1:	90                   	nop
  8029f2:	c9                   	leave  
  8029f3:	c3                   	ret    

008029f4 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8029f4:	55                   	push   %ebp
  8029f5:	89 e5                	mov    %esp,%ebp
  8029f7:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8029fa:	a1 38 51 80 00       	mov    0x805138,%eax
  8029ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a02:	e9 85 01 00 00       	jmp    802b8c <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802a07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0a:	8b 40 0c             	mov    0xc(%eax),%eax
  802a0d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a10:	0f 82 6e 01 00 00    	jb     802b84 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802a16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a19:	8b 40 0c             	mov    0xc(%eax),%eax
  802a1c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a1f:	0f 85 8a 00 00 00    	jne    802aaf <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802a25:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a29:	75 17                	jne    802a42 <alloc_block_FF+0x4e>
  802a2b:	83 ec 04             	sub    $0x4,%esp
  802a2e:	68 58 47 80 00       	push   $0x804758
  802a33:	68 93 00 00 00       	push   $0x93
  802a38:	68 af 46 80 00       	push   $0x8046af
  802a3d:	e8 3e dd ff ff       	call   800780 <_panic>
  802a42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a45:	8b 00                	mov    (%eax),%eax
  802a47:	85 c0                	test   %eax,%eax
  802a49:	74 10                	je     802a5b <alloc_block_FF+0x67>
  802a4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4e:	8b 00                	mov    (%eax),%eax
  802a50:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a53:	8b 52 04             	mov    0x4(%edx),%edx
  802a56:	89 50 04             	mov    %edx,0x4(%eax)
  802a59:	eb 0b                	jmp    802a66 <alloc_block_FF+0x72>
  802a5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5e:	8b 40 04             	mov    0x4(%eax),%eax
  802a61:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a69:	8b 40 04             	mov    0x4(%eax),%eax
  802a6c:	85 c0                	test   %eax,%eax
  802a6e:	74 0f                	je     802a7f <alloc_block_FF+0x8b>
  802a70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a73:	8b 40 04             	mov    0x4(%eax),%eax
  802a76:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a79:	8b 12                	mov    (%edx),%edx
  802a7b:	89 10                	mov    %edx,(%eax)
  802a7d:	eb 0a                	jmp    802a89 <alloc_block_FF+0x95>
  802a7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a82:	8b 00                	mov    (%eax),%eax
  802a84:	a3 38 51 80 00       	mov    %eax,0x805138
  802a89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a95:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a9c:	a1 44 51 80 00       	mov    0x805144,%eax
  802aa1:	48                   	dec    %eax
  802aa2:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802aa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aaa:	e9 10 01 00 00       	jmp    802bbf <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802aaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab2:	8b 40 0c             	mov    0xc(%eax),%eax
  802ab5:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ab8:	0f 86 c6 00 00 00    	jbe    802b84 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802abe:	a1 48 51 80 00       	mov    0x805148,%eax
  802ac3:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802ac6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac9:	8b 50 08             	mov    0x8(%eax),%edx
  802acc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802acf:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802ad2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ad5:	8b 55 08             	mov    0x8(%ebp),%edx
  802ad8:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802adb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802adf:	75 17                	jne    802af8 <alloc_block_FF+0x104>
  802ae1:	83 ec 04             	sub    $0x4,%esp
  802ae4:	68 58 47 80 00       	push   $0x804758
  802ae9:	68 9b 00 00 00       	push   $0x9b
  802aee:	68 af 46 80 00       	push   $0x8046af
  802af3:	e8 88 dc ff ff       	call   800780 <_panic>
  802af8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802afb:	8b 00                	mov    (%eax),%eax
  802afd:	85 c0                	test   %eax,%eax
  802aff:	74 10                	je     802b11 <alloc_block_FF+0x11d>
  802b01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b04:	8b 00                	mov    (%eax),%eax
  802b06:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b09:	8b 52 04             	mov    0x4(%edx),%edx
  802b0c:	89 50 04             	mov    %edx,0x4(%eax)
  802b0f:	eb 0b                	jmp    802b1c <alloc_block_FF+0x128>
  802b11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b14:	8b 40 04             	mov    0x4(%eax),%eax
  802b17:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b1f:	8b 40 04             	mov    0x4(%eax),%eax
  802b22:	85 c0                	test   %eax,%eax
  802b24:	74 0f                	je     802b35 <alloc_block_FF+0x141>
  802b26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b29:	8b 40 04             	mov    0x4(%eax),%eax
  802b2c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b2f:	8b 12                	mov    (%edx),%edx
  802b31:	89 10                	mov    %edx,(%eax)
  802b33:	eb 0a                	jmp    802b3f <alloc_block_FF+0x14b>
  802b35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b38:	8b 00                	mov    (%eax),%eax
  802b3a:	a3 48 51 80 00       	mov    %eax,0x805148
  802b3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b42:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b4b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b52:	a1 54 51 80 00       	mov    0x805154,%eax
  802b57:	48                   	dec    %eax
  802b58:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802b5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b60:	8b 50 08             	mov    0x8(%eax),%edx
  802b63:	8b 45 08             	mov    0x8(%ebp),%eax
  802b66:	01 c2                	add    %eax,%edx
  802b68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6b:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802b6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b71:	8b 40 0c             	mov    0xc(%eax),%eax
  802b74:	2b 45 08             	sub    0x8(%ebp),%eax
  802b77:	89 c2                	mov    %eax,%edx
  802b79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7c:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802b7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b82:	eb 3b                	jmp    802bbf <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802b84:	a1 40 51 80 00       	mov    0x805140,%eax
  802b89:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b8c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b90:	74 07                	je     802b99 <alloc_block_FF+0x1a5>
  802b92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b95:	8b 00                	mov    (%eax),%eax
  802b97:	eb 05                	jmp    802b9e <alloc_block_FF+0x1aa>
  802b99:	b8 00 00 00 00       	mov    $0x0,%eax
  802b9e:	a3 40 51 80 00       	mov    %eax,0x805140
  802ba3:	a1 40 51 80 00       	mov    0x805140,%eax
  802ba8:	85 c0                	test   %eax,%eax
  802baa:	0f 85 57 fe ff ff    	jne    802a07 <alloc_block_FF+0x13>
  802bb0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bb4:	0f 85 4d fe ff ff    	jne    802a07 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802bba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bbf:	c9                   	leave  
  802bc0:	c3                   	ret    

00802bc1 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802bc1:	55                   	push   %ebp
  802bc2:	89 e5                	mov    %esp,%ebp
  802bc4:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802bc7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802bce:	a1 38 51 80 00       	mov    0x805138,%eax
  802bd3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bd6:	e9 df 00 00 00       	jmp    802cba <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802bdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bde:	8b 40 0c             	mov    0xc(%eax),%eax
  802be1:	3b 45 08             	cmp    0x8(%ebp),%eax
  802be4:	0f 82 c8 00 00 00    	jb     802cb2 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802bea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bed:	8b 40 0c             	mov    0xc(%eax),%eax
  802bf0:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bf3:	0f 85 8a 00 00 00    	jne    802c83 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802bf9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bfd:	75 17                	jne    802c16 <alloc_block_BF+0x55>
  802bff:	83 ec 04             	sub    $0x4,%esp
  802c02:	68 58 47 80 00       	push   $0x804758
  802c07:	68 b7 00 00 00       	push   $0xb7
  802c0c:	68 af 46 80 00       	push   $0x8046af
  802c11:	e8 6a db ff ff       	call   800780 <_panic>
  802c16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c19:	8b 00                	mov    (%eax),%eax
  802c1b:	85 c0                	test   %eax,%eax
  802c1d:	74 10                	je     802c2f <alloc_block_BF+0x6e>
  802c1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c22:	8b 00                	mov    (%eax),%eax
  802c24:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c27:	8b 52 04             	mov    0x4(%edx),%edx
  802c2a:	89 50 04             	mov    %edx,0x4(%eax)
  802c2d:	eb 0b                	jmp    802c3a <alloc_block_BF+0x79>
  802c2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c32:	8b 40 04             	mov    0x4(%eax),%eax
  802c35:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3d:	8b 40 04             	mov    0x4(%eax),%eax
  802c40:	85 c0                	test   %eax,%eax
  802c42:	74 0f                	je     802c53 <alloc_block_BF+0x92>
  802c44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c47:	8b 40 04             	mov    0x4(%eax),%eax
  802c4a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c4d:	8b 12                	mov    (%edx),%edx
  802c4f:	89 10                	mov    %edx,(%eax)
  802c51:	eb 0a                	jmp    802c5d <alloc_block_BF+0x9c>
  802c53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c56:	8b 00                	mov    (%eax),%eax
  802c58:	a3 38 51 80 00       	mov    %eax,0x805138
  802c5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c60:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c69:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c70:	a1 44 51 80 00       	mov    0x805144,%eax
  802c75:	48                   	dec    %eax
  802c76:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802c7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7e:	e9 4d 01 00 00       	jmp    802dd0 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802c83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c86:	8b 40 0c             	mov    0xc(%eax),%eax
  802c89:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c8c:	76 24                	jbe    802cb2 <alloc_block_BF+0xf1>
  802c8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c91:	8b 40 0c             	mov    0xc(%eax),%eax
  802c94:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802c97:	73 19                	jae    802cb2 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802c99:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802ca0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca3:	8b 40 0c             	mov    0xc(%eax),%eax
  802ca6:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802ca9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cac:	8b 40 08             	mov    0x8(%eax),%eax
  802caf:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802cb2:	a1 40 51 80 00       	mov    0x805140,%eax
  802cb7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cbe:	74 07                	je     802cc7 <alloc_block_BF+0x106>
  802cc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc3:	8b 00                	mov    (%eax),%eax
  802cc5:	eb 05                	jmp    802ccc <alloc_block_BF+0x10b>
  802cc7:	b8 00 00 00 00       	mov    $0x0,%eax
  802ccc:	a3 40 51 80 00       	mov    %eax,0x805140
  802cd1:	a1 40 51 80 00       	mov    0x805140,%eax
  802cd6:	85 c0                	test   %eax,%eax
  802cd8:	0f 85 fd fe ff ff    	jne    802bdb <alloc_block_BF+0x1a>
  802cde:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ce2:	0f 85 f3 fe ff ff    	jne    802bdb <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802ce8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802cec:	0f 84 d9 00 00 00    	je     802dcb <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802cf2:	a1 48 51 80 00       	mov    0x805148,%eax
  802cf7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802cfa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cfd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d00:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802d03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d06:	8b 55 08             	mov    0x8(%ebp),%edx
  802d09:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802d0c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802d10:	75 17                	jne    802d29 <alloc_block_BF+0x168>
  802d12:	83 ec 04             	sub    $0x4,%esp
  802d15:	68 58 47 80 00       	push   $0x804758
  802d1a:	68 c7 00 00 00       	push   $0xc7
  802d1f:	68 af 46 80 00       	push   $0x8046af
  802d24:	e8 57 da ff ff       	call   800780 <_panic>
  802d29:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d2c:	8b 00                	mov    (%eax),%eax
  802d2e:	85 c0                	test   %eax,%eax
  802d30:	74 10                	je     802d42 <alloc_block_BF+0x181>
  802d32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d35:	8b 00                	mov    (%eax),%eax
  802d37:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d3a:	8b 52 04             	mov    0x4(%edx),%edx
  802d3d:	89 50 04             	mov    %edx,0x4(%eax)
  802d40:	eb 0b                	jmp    802d4d <alloc_block_BF+0x18c>
  802d42:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d45:	8b 40 04             	mov    0x4(%eax),%eax
  802d48:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d4d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d50:	8b 40 04             	mov    0x4(%eax),%eax
  802d53:	85 c0                	test   %eax,%eax
  802d55:	74 0f                	je     802d66 <alloc_block_BF+0x1a5>
  802d57:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d5a:	8b 40 04             	mov    0x4(%eax),%eax
  802d5d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d60:	8b 12                	mov    (%edx),%edx
  802d62:	89 10                	mov    %edx,(%eax)
  802d64:	eb 0a                	jmp    802d70 <alloc_block_BF+0x1af>
  802d66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d69:	8b 00                	mov    (%eax),%eax
  802d6b:	a3 48 51 80 00       	mov    %eax,0x805148
  802d70:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d73:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d79:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d7c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d83:	a1 54 51 80 00       	mov    0x805154,%eax
  802d88:	48                   	dec    %eax
  802d89:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802d8e:	83 ec 08             	sub    $0x8,%esp
  802d91:	ff 75 ec             	pushl  -0x14(%ebp)
  802d94:	68 38 51 80 00       	push   $0x805138
  802d99:	e8 71 f9 ff ff       	call   80270f <find_block>
  802d9e:	83 c4 10             	add    $0x10,%esp
  802da1:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802da4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802da7:	8b 50 08             	mov    0x8(%eax),%edx
  802daa:	8b 45 08             	mov    0x8(%ebp),%eax
  802dad:	01 c2                	add    %eax,%edx
  802daf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802db2:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802db5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802db8:	8b 40 0c             	mov    0xc(%eax),%eax
  802dbb:	2b 45 08             	sub    0x8(%ebp),%eax
  802dbe:	89 c2                	mov    %eax,%edx
  802dc0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802dc3:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802dc6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dc9:	eb 05                	jmp    802dd0 <alloc_block_BF+0x20f>
	}
	return NULL;
  802dcb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802dd0:	c9                   	leave  
  802dd1:	c3                   	ret    

00802dd2 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802dd2:	55                   	push   %ebp
  802dd3:	89 e5                	mov    %esp,%ebp
  802dd5:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802dd8:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802ddd:	85 c0                	test   %eax,%eax
  802ddf:	0f 85 de 01 00 00    	jne    802fc3 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802de5:	a1 38 51 80 00       	mov    0x805138,%eax
  802dea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ded:	e9 9e 01 00 00       	jmp    802f90 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802df2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df5:	8b 40 0c             	mov    0xc(%eax),%eax
  802df8:	3b 45 08             	cmp    0x8(%ebp),%eax
  802dfb:	0f 82 87 01 00 00    	jb     802f88 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802e01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e04:	8b 40 0c             	mov    0xc(%eax),%eax
  802e07:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e0a:	0f 85 95 00 00 00    	jne    802ea5 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802e10:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e14:	75 17                	jne    802e2d <alloc_block_NF+0x5b>
  802e16:	83 ec 04             	sub    $0x4,%esp
  802e19:	68 58 47 80 00       	push   $0x804758
  802e1e:	68 e0 00 00 00       	push   $0xe0
  802e23:	68 af 46 80 00       	push   $0x8046af
  802e28:	e8 53 d9 ff ff       	call   800780 <_panic>
  802e2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e30:	8b 00                	mov    (%eax),%eax
  802e32:	85 c0                	test   %eax,%eax
  802e34:	74 10                	je     802e46 <alloc_block_NF+0x74>
  802e36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e39:	8b 00                	mov    (%eax),%eax
  802e3b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e3e:	8b 52 04             	mov    0x4(%edx),%edx
  802e41:	89 50 04             	mov    %edx,0x4(%eax)
  802e44:	eb 0b                	jmp    802e51 <alloc_block_NF+0x7f>
  802e46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e49:	8b 40 04             	mov    0x4(%eax),%eax
  802e4c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e54:	8b 40 04             	mov    0x4(%eax),%eax
  802e57:	85 c0                	test   %eax,%eax
  802e59:	74 0f                	je     802e6a <alloc_block_NF+0x98>
  802e5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5e:	8b 40 04             	mov    0x4(%eax),%eax
  802e61:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e64:	8b 12                	mov    (%edx),%edx
  802e66:	89 10                	mov    %edx,(%eax)
  802e68:	eb 0a                	jmp    802e74 <alloc_block_NF+0xa2>
  802e6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6d:	8b 00                	mov    (%eax),%eax
  802e6f:	a3 38 51 80 00       	mov    %eax,0x805138
  802e74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e77:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e80:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e87:	a1 44 51 80 00       	mov    0x805144,%eax
  802e8c:	48                   	dec    %eax
  802e8d:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802e92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e95:	8b 40 08             	mov    0x8(%eax),%eax
  802e98:	a3 2c 50 80 00       	mov    %eax,0x80502c
				   return  point;
  802e9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea0:	e9 f8 04 00 00       	jmp    80339d <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802ea5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea8:	8b 40 0c             	mov    0xc(%eax),%eax
  802eab:	3b 45 08             	cmp    0x8(%ebp),%eax
  802eae:	0f 86 d4 00 00 00    	jbe    802f88 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802eb4:	a1 48 51 80 00       	mov    0x805148,%eax
  802eb9:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802ebc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebf:	8b 50 08             	mov    0x8(%eax),%edx
  802ec2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ec5:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802ec8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ecb:	8b 55 08             	mov    0x8(%ebp),%edx
  802ece:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802ed1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ed5:	75 17                	jne    802eee <alloc_block_NF+0x11c>
  802ed7:	83 ec 04             	sub    $0x4,%esp
  802eda:	68 58 47 80 00       	push   $0x804758
  802edf:	68 e9 00 00 00       	push   $0xe9
  802ee4:	68 af 46 80 00       	push   $0x8046af
  802ee9:	e8 92 d8 ff ff       	call   800780 <_panic>
  802eee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ef1:	8b 00                	mov    (%eax),%eax
  802ef3:	85 c0                	test   %eax,%eax
  802ef5:	74 10                	je     802f07 <alloc_block_NF+0x135>
  802ef7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802efa:	8b 00                	mov    (%eax),%eax
  802efc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802eff:	8b 52 04             	mov    0x4(%edx),%edx
  802f02:	89 50 04             	mov    %edx,0x4(%eax)
  802f05:	eb 0b                	jmp    802f12 <alloc_block_NF+0x140>
  802f07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f0a:	8b 40 04             	mov    0x4(%eax),%eax
  802f0d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f15:	8b 40 04             	mov    0x4(%eax),%eax
  802f18:	85 c0                	test   %eax,%eax
  802f1a:	74 0f                	je     802f2b <alloc_block_NF+0x159>
  802f1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f1f:	8b 40 04             	mov    0x4(%eax),%eax
  802f22:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f25:	8b 12                	mov    (%edx),%edx
  802f27:	89 10                	mov    %edx,(%eax)
  802f29:	eb 0a                	jmp    802f35 <alloc_block_NF+0x163>
  802f2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f2e:	8b 00                	mov    (%eax),%eax
  802f30:	a3 48 51 80 00       	mov    %eax,0x805148
  802f35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f38:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f41:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f48:	a1 54 51 80 00       	mov    0x805154,%eax
  802f4d:	48                   	dec    %eax
  802f4e:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802f53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f56:	8b 40 08             	mov    0x8(%eax),%eax
  802f59:	a3 2c 50 80 00       	mov    %eax,0x80502c
				   point->sva += size;
  802f5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f61:	8b 50 08             	mov    0x8(%eax),%edx
  802f64:	8b 45 08             	mov    0x8(%ebp),%eax
  802f67:	01 c2                	add    %eax,%edx
  802f69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6c:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802f6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f72:	8b 40 0c             	mov    0xc(%eax),%eax
  802f75:	2b 45 08             	sub    0x8(%ebp),%eax
  802f78:	89 c2                	mov    %eax,%edx
  802f7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7d:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802f80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f83:	e9 15 04 00 00       	jmp    80339d <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802f88:	a1 40 51 80 00       	mov    0x805140,%eax
  802f8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f90:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f94:	74 07                	je     802f9d <alloc_block_NF+0x1cb>
  802f96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f99:	8b 00                	mov    (%eax),%eax
  802f9b:	eb 05                	jmp    802fa2 <alloc_block_NF+0x1d0>
  802f9d:	b8 00 00 00 00       	mov    $0x0,%eax
  802fa2:	a3 40 51 80 00       	mov    %eax,0x805140
  802fa7:	a1 40 51 80 00       	mov    0x805140,%eax
  802fac:	85 c0                	test   %eax,%eax
  802fae:	0f 85 3e fe ff ff    	jne    802df2 <alloc_block_NF+0x20>
  802fb4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fb8:	0f 85 34 fe ff ff    	jne    802df2 <alloc_block_NF+0x20>
  802fbe:	e9 d5 03 00 00       	jmp    803398 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802fc3:	a1 38 51 80 00       	mov    0x805138,%eax
  802fc8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fcb:	e9 b1 01 00 00       	jmp    803181 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802fd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd3:	8b 50 08             	mov    0x8(%eax),%edx
  802fd6:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802fdb:	39 c2                	cmp    %eax,%edx
  802fdd:	0f 82 96 01 00 00    	jb     803179 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802fe3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe6:	8b 40 0c             	mov    0xc(%eax),%eax
  802fe9:	3b 45 08             	cmp    0x8(%ebp),%eax
  802fec:	0f 82 87 01 00 00    	jb     803179 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802ff2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff5:	8b 40 0c             	mov    0xc(%eax),%eax
  802ff8:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ffb:	0f 85 95 00 00 00    	jne    803096 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  803001:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803005:	75 17                	jne    80301e <alloc_block_NF+0x24c>
  803007:	83 ec 04             	sub    $0x4,%esp
  80300a:	68 58 47 80 00       	push   $0x804758
  80300f:	68 fc 00 00 00       	push   $0xfc
  803014:	68 af 46 80 00       	push   $0x8046af
  803019:	e8 62 d7 ff ff       	call   800780 <_panic>
  80301e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803021:	8b 00                	mov    (%eax),%eax
  803023:	85 c0                	test   %eax,%eax
  803025:	74 10                	je     803037 <alloc_block_NF+0x265>
  803027:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80302a:	8b 00                	mov    (%eax),%eax
  80302c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80302f:	8b 52 04             	mov    0x4(%edx),%edx
  803032:	89 50 04             	mov    %edx,0x4(%eax)
  803035:	eb 0b                	jmp    803042 <alloc_block_NF+0x270>
  803037:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80303a:	8b 40 04             	mov    0x4(%eax),%eax
  80303d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803042:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803045:	8b 40 04             	mov    0x4(%eax),%eax
  803048:	85 c0                	test   %eax,%eax
  80304a:	74 0f                	je     80305b <alloc_block_NF+0x289>
  80304c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80304f:	8b 40 04             	mov    0x4(%eax),%eax
  803052:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803055:	8b 12                	mov    (%edx),%edx
  803057:	89 10                	mov    %edx,(%eax)
  803059:	eb 0a                	jmp    803065 <alloc_block_NF+0x293>
  80305b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305e:	8b 00                	mov    (%eax),%eax
  803060:	a3 38 51 80 00       	mov    %eax,0x805138
  803065:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803068:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80306e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803071:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803078:	a1 44 51 80 00       	mov    0x805144,%eax
  80307d:	48                   	dec    %eax
  80307e:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  803083:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803086:	8b 40 08             	mov    0x8(%eax),%eax
  803089:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   return  point;
  80308e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803091:	e9 07 03 00 00       	jmp    80339d <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  803096:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803099:	8b 40 0c             	mov    0xc(%eax),%eax
  80309c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80309f:	0f 86 d4 00 00 00    	jbe    803179 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8030a5:	a1 48 51 80 00       	mov    0x805148,%eax
  8030aa:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  8030ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b0:	8b 50 08             	mov    0x8(%eax),%edx
  8030b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030b6:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8030b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8030bf:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8030c2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030c6:	75 17                	jne    8030df <alloc_block_NF+0x30d>
  8030c8:	83 ec 04             	sub    $0x4,%esp
  8030cb:	68 58 47 80 00       	push   $0x804758
  8030d0:	68 04 01 00 00       	push   $0x104
  8030d5:	68 af 46 80 00       	push   $0x8046af
  8030da:	e8 a1 d6 ff ff       	call   800780 <_panic>
  8030df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030e2:	8b 00                	mov    (%eax),%eax
  8030e4:	85 c0                	test   %eax,%eax
  8030e6:	74 10                	je     8030f8 <alloc_block_NF+0x326>
  8030e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030eb:	8b 00                	mov    (%eax),%eax
  8030ed:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030f0:	8b 52 04             	mov    0x4(%edx),%edx
  8030f3:	89 50 04             	mov    %edx,0x4(%eax)
  8030f6:	eb 0b                	jmp    803103 <alloc_block_NF+0x331>
  8030f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030fb:	8b 40 04             	mov    0x4(%eax),%eax
  8030fe:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803103:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803106:	8b 40 04             	mov    0x4(%eax),%eax
  803109:	85 c0                	test   %eax,%eax
  80310b:	74 0f                	je     80311c <alloc_block_NF+0x34a>
  80310d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803110:	8b 40 04             	mov    0x4(%eax),%eax
  803113:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803116:	8b 12                	mov    (%edx),%edx
  803118:	89 10                	mov    %edx,(%eax)
  80311a:	eb 0a                	jmp    803126 <alloc_block_NF+0x354>
  80311c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80311f:	8b 00                	mov    (%eax),%eax
  803121:	a3 48 51 80 00       	mov    %eax,0x805148
  803126:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803129:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80312f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803132:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803139:	a1 54 51 80 00       	mov    0x805154,%eax
  80313e:	48                   	dec    %eax
  80313f:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  803144:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803147:	8b 40 08             	mov    0x8(%eax),%eax
  80314a:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   point->sva += size;
  80314f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803152:	8b 50 08             	mov    0x8(%eax),%edx
  803155:	8b 45 08             	mov    0x8(%ebp),%eax
  803158:	01 c2                	add    %eax,%edx
  80315a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80315d:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803160:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803163:	8b 40 0c             	mov    0xc(%eax),%eax
  803166:	2b 45 08             	sub    0x8(%ebp),%eax
  803169:	89 c2                	mov    %eax,%edx
  80316b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80316e:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803171:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803174:	e9 24 02 00 00       	jmp    80339d <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  803179:	a1 40 51 80 00       	mov    0x805140,%eax
  80317e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803181:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803185:	74 07                	je     80318e <alloc_block_NF+0x3bc>
  803187:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80318a:	8b 00                	mov    (%eax),%eax
  80318c:	eb 05                	jmp    803193 <alloc_block_NF+0x3c1>
  80318e:	b8 00 00 00 00       	mov    $0x0,%eax
  803193:	a3 40 51 80 00       	mov    %eax,0x805140
  803198:	a1 40 51 80 00       	mov    0x805140,%eax
  80319d:	85 c0                	test   %eax,%eax
  80319f:	0f 85 2b fe ff ff    	jne    802fd0 <alloc_block_NF+0x1fe>
  8031a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031a9:	0f 85 21 fe ff ff    	jne    802fd0 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8031af:	a1 38 51 80 00       	mov    0x805138,%eax
  8031b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031b7:	e9 ae 01 00 00       	jmp    80336a <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  8031bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031bf:	8b 50 08             	mov    0x8(%eax),%edx
  8031c2:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8031c7:	39 c2                	cmp    %eax,%edx
  8031c9:	0f 83 93 01 00 00    	jae    803362 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  8031cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d2:	8b 40 0c             	mov    0xc(%eax),%eax
  8031d5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031d8:	0f 82 84 01 00 00    	jb     803362 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  8031de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e1:	8b 40 0c             	mov    0xc(%eax),%eax
  8031e4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031e7:	0f 85 95 00 00 00    	jne    803282 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8031ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031f1:	75 17                	jne    80320a <alloc_block_NF+0x438>
  8031f3:	83 ec 04             	sub    $0x4,%esp
  8031f6:	68 58 47 80 00       	push   $0x804758
  8031fb:	68 14 01 00 00       	push   $0x114
  803200:	68 af 46 80 00       	push   $0x8046af
  803205:	e8 76 d5 ff ff       	call   800780 <_panic>
  80320a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80320d:	8b 00                	mov    (%eax),%eax
  80320f:	85 c0                	test   %eax,%eax
  803211:	74 10                	je     803223 <alloc_block_NF+0x451>
  803213:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803216:	8b 00                	mov    (%eax),%eax
  803218:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80321b:	8b 52 04             	mov    0x4(%edx),%edx
  80321e:	89 50 04             	mov    %edx,0x4(%eax)
  803221:	eb 0b                	jmp    80322e <alloc_block_NF+0x45c>
  803223:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803226:	8b 40 04             	mov    0x4(%eax),%eax
  803229:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80322e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803231:	8b 40 04             	mov    0x4(%eax),%eax
  803234:	85 c0                	test   %eax,%eax
  803236:	74 0f                	je     803247 <alloc_block_NF+0x475>
  803238:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80323b:	8b 40 04             	mov    0x4(%eax),%eax
  80323e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803241:	8b 12                	mov    (%edx),%edx
  803243:	89 10                	mov    %edx,(%eax)
  803245:	eb 0a                	jmp    803251 <alloc_block_NF+0x47f>
  803247:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80324a:	8b 00                	mov    (%eax),%eax
  80324c:	a3 38 51 80 00       	mov    %eax,0x805138
  803251:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803254:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80325a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80325d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803264:	a1 44 51 80 00       	mov    0x805144,%eax
  803269:	48                   	dec    %eax
  80326a:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  80326f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803272:	8b 40 08             	mov    0x8(%eax),%eax
  803275:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   return  point;
  80327a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80327d:	e9 1b 01 00 00       	jmp    80339d <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  803282:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803285:	8b 40 0c             	mov    0xc(%eax),%eax
  803288:	3b 45 08             	cmp    0x8(%ebp),%eax
  80328b:	0f 86 d1 00 00 00    	jbe    803362 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803291:	a1 48 51 80 00       	mov    0x805148,%eax
  803296:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  803299:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80329c:	8b 50 08             	mov    0x8(%eax),%edx
  80329f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032a2:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8032a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8032ab:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8032ae:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8032b2:	75 17                	jne    8032cb <alloc_block_NF+0x4f9>
  8032b4:	83 ec 04             	sub    $0x4,%esp
  8032b7:	68 58 47 80 00       	push   $0x804758
  8032bc:	68 1c 01 00 00       	push   $0x11c
  8032c1:	68 af 46 80 00       	push   $0x8046af
  8032c6:	e8 b5 d4 ff ff       	call   800780 <_panic>
  8032cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032ce:	8b 00                	mov    (%eax),%eax
  8032d0:	85 c0                	test   %eax,%eax
  8032d2:	74 10                	je     8032e4 <alloc_block_NF+0x512>
  8032d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032d7:	8b 00                	mov    (%eax),%eax
  8032d9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8032dc:	8b 52 04             	mov    0x4(%edx),%edx
  8032df:	89 50 04             	mov    %edx,0x4(%eax)
  8032e2:	eb 0b                	jmp    8032ef <alloc_block_NF+0x51d>
  8032e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032e7:	8b 40 04             	mov    0x4(%eax),%eax
  8032ea:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032f2:	8b 40 04             	mov    0x4(%eax),%eax
  8032f5:	85 c0                	test   %eax,%eax
  8032f7:	74 0f                	je     803308 <alloc_block_NF+0x536>
  8032f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032fc:	8b 40 04             	mov    0x4(%eax),%eax
  8032ff:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803302:	8b 12                	mov    (%edx),%edx
  803304:	89 10                	mov    %edx,(%eax)
  803306:	eb 0a                	jmp    803312 <alloc_block_NF+0x540>
  803308:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80330b:	8b 00                	mov    (%eax),%eax
  80330d:	a3 48 51 80 00       	mov    %eax,0x805148
  803312:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803315:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80331b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80331e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803325:	a1 54 51 80 00       	mov    0x805154,%eax
  80332a:	48                   	dec    %eax
  80332b:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  803330:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803333:	8b 40 08             	mov    0x8(%eax),%eax
  803336:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   point->sva += size;
  80333b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80333e:	8b 50 08             	mov    0x8(%eax),%edx
  803341:	8b 45 08             	mov    0x8(%ebp),%eax
  803344:	01 c2                	add    %eax,%edx
  803346:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803349:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  80334c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80334f:	8b 40 0c             	mov    0xc(%eax),%eax
  803352:	2b 45 08             	sub    0x8(%ebp),%eax
  803355:	89 c2                	mov    %eax,%edx
  803357:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80335a:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  80335d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803360:	eb 3b                	jmp    80339d <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803362:	a1 40 51 80 00       	mov    0x805140,%eax
  803367:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80336a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80336e:	74 07                	je     803377 <alloc_block_NF+0x5a5>
  803370:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803373:	8b 00                	mov    (%eax),%eax
  803375:	eb 05                	jmp    80337c <alloc_block_NF+0x5aa>
  803377:	b8 00 00 00 00       	mov    $0x0,%eax
  80337c:	a3 40 51 80 00       	mov    %eax,0x805140
  803381:	a1 40 51 80 00       	mov    0x805140,%eax
  803386:	85 c0                	test   %eax,%eax
  803388:	0f 85 2e fe ff ff    	jne    8031bc <alloc_block_NF+0x3ea>
  80338e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803392:	0f 85 24 fe ff ff    	jne    8031bc <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  803398:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80339d:	c9                   	leave  
  80339e:	c3                   	ret    

0080339f <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  80339f:	55                   	push   %ebp
  8033a0:	89 e5                	mov    %esp,%ebp
  8033a2:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  8033a5:	a1 38 51 80 00       	mov    0x805138,%eax
  8033aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  8033ad:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8033b2:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  8033b5:	a1 38 51 80 00       	mov    0x805138,%eax
  8033ba:	85 c0                	test   %eax,%eax
  8033bc:	74 14                	je     8033d2 <insert_sorted_with_merge_freeList+0x33>
  8033be:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c1:	8b 50 08             	mov    0x8(%eax),%edx
  8033c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033c7:	8b 40 08             	mov    0x8(%eax),%eax
  8033ca:	39 c2                	cmp    %eax,%edx
  8033cc:	0f 87 9b 01 00 00    	ja     80356d <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  8033d2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033d6:	75 17                	jne    8033ef <insert_sorted_with_merge_freeList+0x50>
  8033d8:	83 ec 04             	sub    $0x4,%esp
  8033db:	68 8c 46 80 00       	push   $0x80468c
  8033e0:	68 38 01 00 00       	push   $0x138
  8033e5:	68 af 46 80 00       	push   $0x8046af
  8033ea:	e8 91 d3 ff ff       	call   800780 <_panic>
  8033ef:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8033f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f8:	89 10                	mov    %edx,(%eax)
  8033fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8033fd:	8b 00                	mov    (%eax),%eax
  8033ff:	85 c0                	test   %eax,%eax
  803401:	74 0d                	je     803410 <insert_sorted_with_merge_freeList+0x71>
  803403:	a1 38 51 80 00       	mov    0x805138,%eax
  803408:	8b 55 08             	mov    0x8(%ebp),%edx
  80340b:	89 50 04             	mov    %edx,0x4(%eax)
  80340e:	eb 08                	jmp    803418 <insert_sorted_with_merge_freeList+0x79>
  803410:	8b 45 08             	mov    0x8(%ebp),%eax
  803413:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803418:	8b 45 08             	mov    0x8(%ebp),%eax
  80341b:	a3 38 51 80 00       	mov    %eax,0x805138
  803420:	8b 45 08             	mov    0x8(%ebp),%eax
  803423:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80342a:	a1 44 51 80 00       	mov    0x805144,%eax
  80342f:	40                   	inc    %eax
  803430:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803435:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803439:	0f 84 a8 06 00 00    	je     803ae7 <insert_sorted_with_merge_freeList+0x748>
  80343f:	8b 45 08             	mov    0x8(%ebp),%eax
  803442:	8b 50 08             	mov    0x8(%eax),%edx
  803445:	8b 45 08             	mov    0x8(%ebp),%eax
  803448:	8b 40 0c             	mov    0xc(%eax),%eax
  80344b:	01 c2                	add    %eax,%edx
  80344d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803450:	8b 40 08             	mov    0x8(%eax),%eax
  803453:	39 c2                	cmp    %eax,%edx
  803455:	0f 85 8c 06 00 00    	jne    803ae7 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  80345b:	8b 45 08             	mov    0x8(%ebp),%eax
  80345e:	8b 50 0c             	mov    0xc(%eax),%edx
  803461:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803464:	8b 40 0c             	mov    0xc(%eax),%eax
  803467:	01 c2                	add    %eax,%edx
  803469:	8b 45 08             	mov    0x8(%ebp),%eax
  80346c:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  80346f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803473:	75 17                	jne    80348c <insert_sorted_with_merge_freeList+0xed>
  803475:	83 ec 04             	sub    $0x4,%esp
  803478:	68 58 47 80 00       	push   $0x804758
  80347d:	68 3c 01 00 00       	push   $0x13c
  803482:	68 af 46 80 00       	push   $0x8046af
  803487:	e8 f4 d2 ff ff       	call   800780 <_panic>
  80348c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80348f:	8b 00                	mov    (%eax),%eax
  803491:	85 c0                	test   %eax,%eax
  803493:	74 10                	je     8034a5 <insert_sorted_with_merge_freeList+0x106>
  803495:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803498:	8b 00                	mov    (%eax),%eax
  80349a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80349d:	8b 52 04             	mov    0x4(%edx),%edx
  8034a0:	89 50 04             	mov    %edx,0x4(%eax)
  8034a3:	eb 0b                	jmp    8034b0 <insert_sorted_with_merge_freeList+0x111>
  8034a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034a8:	8b 40 04             	mov    0x4(%eax),%eax
  8034ab:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8034b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034b3:	8b 40 04             	mov    0x4(%eax),%eax
  8034b6:	85 c0                	test   %eax,%eax
  8034b8:	74 0f                	je     8034c9 <insert_sorted_with_merge_freeList+0x12a>
  8034ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034bd:	8b 40 04             	mov    0x4(%eax),%eax
  8034c0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034c3:	8b 12                	mov    (%edx),%edx
  8034c5:	89 10                	mov    %edx,(%eax)
  8034c7:	eb 0a                	jmp    8034d3 <insert_sorted_with_merge_freeList+0x134>
  8034c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034cc:	8b 00                	mov    (%eax),%eax
  8034ce:	a3 38 51 80 00       	mov    %eax,0x805138
  8034d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034df:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034e6:	a1 44 51 80 00       	mov    0x805144,%eax
  8034eb:	48                   	dec    %eax
  8034ec:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  8034f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034f4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  8034fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034fe:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  803505:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803509:	75 17                	jne    803522 <insert_sorted_with_merge_freeList+0x183>
  80350b:	83 ec 04             	sub    $0x4,%esp
  80350e:	68 8c 46 80 00       	push   $0x80468c
  803513:	68 3f 01 00 00       	push   $0x13f
  803518:	68 af 46 80 00       	push   $0x8046af
  80351d:	e8 5e d2 ff ff       	call   800780 <_panic>
  803522:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803528:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80352b:	89 10                	mov    %edx,(%eax)
  80352d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803530:	8b 00                	mov    (%eax),%eax
  803532:	85 c0                	test   %eax,%eax
  803534:	74 0d                	je     803543 <insert_sorted_with_merge_freeList+0x1a4>
  803536:	a1 48 51 80 00       	mov    0x805148,%eax
  80353b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80353e:	89 50 04             	mov    %edx,0x4(%eax)
  803541:	eb 08                	jmp    80354b <insert_sorted_with_merge_freeList+0x1ac>
  803543:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803546:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80354b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80354e:	a3 48 51 80 00       	mov    %eax,0x805148
  803553:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803556:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80355d:	a1 54 51 80 00       	mov    0x805154,%eax
  803562:	40                   	inc    %eax
  803563:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803568:	e9 7a 05 00 00       	jmp    803ae7 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  80356d:	8b 45 08             	mov    0x8(%ebp),%eax
  803570:	8b 50 08             	mov    0x8(%eax),%edx
  803573:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803576:	8b 40 08             	mov    0x8(%eax),%eax
  803579:	39 c2                	cmp    %eax,%edx
  80357b:	0f 82 14 01 00 00    	jb     803695 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  803581:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803584:	8b 50 08             	mov    0x8(%eax),%edx
  803587:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80358a:	8b 40 0c             	mov    0xc(%eax),%eax
  80358d:	01 c2                	add    %eax,%edx
  80358f:	8b 45 08             	mov    0x8(%ebp),%eax
  803592:	8b 40 08             	mov    0x8(%eax),%eax
  803595:	39 c2                	cmp    %eax,%edx
  803597:	0f 85 90 00 00 00    	jne    80362d <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  80359d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035a0:	8b 50 0c             	mov    0xc(%eax),%edx
  8035a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a6:	8b 40 0c             	mov    0xc(%eax),%eax
  8035a9:	01 c2                	add    %eax,%edx
  8035ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035ae:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  8035b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  8035bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8035be:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8035c5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035c9:	75 17                	jne    8035e2 <insert_sorted_with_merge_freeList+0x243>
  8035cb:	83 ec 04             	sub    $0x4,%esp
  8035ce:	68 8c 46 80 00       	push   $0x80468c
  8035d3:	68 49 01 00 00       	push   $0x149
  8035d8:	68 af 46 80 00       	push   $0x8046af
  8035dd:	e8 9e d1 ff ff       	call   800780 <_panic>
  8035e2:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8035e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8035eb:	89 10                	mov    %edx,(%eax)
  8035ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f0:	8b 00                	mov    (%eax),%eax
  8035f2:	85 c0                	test   %eax,%eax
  8035f4:	74 0d                	je     803603 <insert_sorted_with_merge_freeList+0x264>
  8035f6:	a1 48 51 80 00       	mov    0x805148,%eax
  8035fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8035fe:	89 50 04             	mov    %edx,0x4(%eax)
  803601:	eb 08                	jmp    80360b <insert_sorted_with_merge_freeList+0x26c>
  803603:	8b 45 08             	mov    0x8(%ebp),%eax
  803606:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80360b:	8b 45 08             	mov    0x8(%ebp),%eax
  80360e:	a3 48 51 80 00       	mov    %eax,0x805148
  803613:	8b 45 08             	mov    0x8(%ebp),%eax
  803616:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80361d:	a1 54 51 80 00       	mov    0x805154,%eax
  803622:	40                   	inc    %eax
  803623:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803628:	e9 bb 04 00 00       	jmp    803ae8 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  80362d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803631:	75 17                	jne    80364a <insert_sorted_with_merge_freeList+0x2ab>
  803633:	83 ec 04             	sub    $0x4,%esp
  803636:	68 00 47 80 00       	push   $0x804700
  80363b:	68 4c 01 00 00       	push   $0x14c
  803640:	68 af 46 80 00       	push   $0x8046af
  803645:	e8 36 d1 ff ff       	call   800780 <_panic>
  80364a:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803650:	8b 45 08             	mov    0x8(%ebp),%eax
  803653:	89 50 04             	mov    %edx,0x4(%eax)
  803656:	8b 45 08             	mov    0x8(%ebp),%eax
  803659:	8b 40 04             	mov    0x4(%eax),%eax
  80365c:	85 c0                	test   %eax,%eax
  80365e:	74 0c                	je     80366c <insert_sorted_with_merge_freeList+0x2cd>
  803660:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803665:	8b 55 08             	mov    0x8(%ebp),%edx
  803668:	89 10                	mov    %edx,(%eax)
  80366a:	eb 08                	jmp    803674 <insert_sorted_with_merge_freeList+0x2d5>
  80366c:	8b 45 08             	mov    0x8(%ebp),%eax
  80366f:	a3 38 51 80 00       	mov    %eax,0x805138
  803674:	8b 45 08             	mov    0x8(%ebp),%eax
  803677:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80367c:	8b 45 08             	mov    0x8(%ebp),%eax
  80367f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803685:	a1 44 51 80 00       	mov    0x805144,%eax
  80368a:	40                   	inc    %eax
  80368b:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803690:	e9 53 04 00 00       	jmp    803ae8 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803695:	a1 38 51 80 00       	mov    0x805138,%eax
  80369a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80369d:	e9 15 04 00 00       	jmp    803ab7 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  8036a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036a5:	8b 00                	mov    (%eax),%eax
  8036a7:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  8036aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ad:	8b 50 08             	mov    0x8(%eax),%edx
  8036b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036b3:	8b 40 08             	mov    0x8(%eax),%eax
  8036b6:	39 c2                	cmp    %eax,%edx
  8036b8:	0f 86 f1 03 00 00    	jbe    803aaf <insert_sorted_with_merge_freeList+0x710>
  8036be:	8b 45 08             	mov    0x8(%ebp),%eax
  8036c1:	8b 50 08             	mov    0x8(%eax),%edx
  8036c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036c7:	8b 40 08             	mov    0x8(%eax),%eax
  8036ca:	39 c2                	cmp    %eax,%edx
  8036cc:	0f 83 dd 03 00 00    	jae    803aaf <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  8036d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036d5:	8b 50 08             	mov    0x8(%eax),%edx
  8036d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036db:	8b 40 0c             	mov    0xc(%eax),%eax
  8036de:	01 c2                	add    %eax,%edx
  8036e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e3:	8b 40 08             	mov    0x8(%eax),%eax
  8036e6:	39 c2                	cmp    %eax,%edx
  8036e8:	0f 85 b9 01 00 00    	jne    8038a7 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8036ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8036f1:	8b 50 08             	mov    0x8(%eax),%edx
  8036f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8036f7:	8b 40 0c             	mov    0xc(%eax),%eax
  8036fa:	01 c2                	add    %eax,%edx
  8036fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036ff:	8b 40 08             	mov    0x8(%eax),%eax
  803702:	39 c2                	cmp    %eax,%edx
  803704:	0f 85 0d 01 00 00    	jne    803817 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  80370a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80370d:	8b 50 0c             	mov    0xc(%eax),%edx
  803710:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803713:	8b 40 0c             	mov    0xc(%eax),%eax
  803716:	01 c2                	add    %eax,%edx
  803718:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80371b:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80371e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803722:	75 17                	jne    80373b <insert_sorted_with_merge_freeList+0x39c>
  803724:	83 ec 04             	sub    $0x4,%esp
  803727:	68 58 47 80 00       	push   $0x804758
  80372c:	68 5c 01 00 00       	push   $0x15c
  803731:	68 af 46 80 00       	push   $0x8046af
  803736:	e8 45 d0 ff ff       	call   800780 <_panic>
  80373b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80373e:	8b 00                	mov    (%eax),%eax
  803740:	85 c0                	test   %eax,%eax
  803742:	74 10                	je     803754 <insert_sorted_with_merge_freeList+0x3b5>
  803744:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803747:	8b 00                	mov    (%eax),%eax
  803749:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80374c:	8b 52 04             	mov    0x4(%edx),%edx
  80374f:	89 50 04             	mov    %edx,0x4(%eax)
  803752:	eb 0b                	jmp    80375f <insert_sorted_with_merge_freeList+0x3c0>
  803754:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803757:	8b 40 04             	mov    0x4(%eax),%eax
  80375a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80375f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803762:	8b 40 04             	mov    0x4(%eax),%eax
  803765:	85 c0                	test   %eax,%eax
  803767:	74 0f                	je     803778 <insert_sorted_with_merge_freeList+0x3d9>
  803769:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80376c:	8b 40 04             	mov    0x4(%eax),%eax
  80376f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803772:	8b 12                	mov    (%edx),%edx
  803774:	89 10                	mov    %edx,(%eax)
  803776:	eb 0a                	jmp    803782 <insert_sorted_with_merge_freeList+0x3e3>
  803778:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80377b:	8b 00                	mov    (%eax),%eax
  80377d:	a3 38 51 80 00       	mov    %eax,0x805138
  803782:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803785:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80378b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80378e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803795:	a1 44 51 80 00       	mov    0x805144,%eax
  80379a:	48                   	dec    %eax
  80379b:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  8037a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037a3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8037aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037ad:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8037b4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8037b8:	75 17                	jne    8037d1 <insert_sorted_with_merge_freeList+0x432>
  8037ba:	83 ec 04             	sub    $0x4,%esp
  8037bd:	68 8c 46 80 00       	push   $0x80468c
  8037c2:	68 5f 01 00 00       	push   $0x15f
  8037c7:	68 af 46 80 00       	push   $0x8046af
  8037cc:	e8 af cf ff ff       	call   800780 <_panic>
  8037d1:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8037d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037da:	89 10                	mov    %edx,(%eax)
  8037dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037df:	8b 00                	mov    (%eax),%eax
  8037e1:	85 c0                	test   %eax,%eax
  8037e3:	74 0d                	je     8037f2 <insert_sorted_with_merge_freeList+0x453>
  8037e5:	a1 48 51 80 00       	mov    0x805148,%eax
  8037ea:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8037ed:	89 50 04             	mov    %edx,0x4(%eax)
  8037f0:	eb 08                	jmp    8037fa <insert_sorted_with_merge_freeList+0x45b>
  8037f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037f5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8037fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037fd:	a3 48 51 80 00       	mov    %eax,0x805148
  803802:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803805:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80380c:	a1 54 51 80 00       	mov    0x805154,%eax
  803811:	40                   	inc    %eax
  803812:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803817:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80381a:	8b 50 0c             	mov    0xc(%eax),%edx
  80381d:	8b 45 08             	mov    0x8(%ebp),%eax
  803820:	8b 40 0c             	mov    0xc(%eax),%eax
  803823:	01 c2                	add    %eax,%edx
  803825:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803828:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  80382b:	8b 45 08             	mov    0x8(%ebp),%eax
  80382e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803835:	8b 45 08             	mov    0x8(%ebp),%eax
  803838:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80383f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803843:	75 17                	jne    80385c <insert_sorted_with_merge_freeList+0x4bd>
  803845:	83 ec 04             	sub    $0x4,%esp
  803848:	68 8c 46 80 00       	push   $0x80468c
  80384d:	68 64 01 00 00       	push   $0x164
  803852:	68 af 46 80 00       	push   $0x8046af
  803857:	e8 24 cf ff ff       	call   800780 <_panic>
  80385c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803862:	8b 45 08             	mov    0x8(%ebp),%eax
  803865:	89 10                	mov    %edx,(%eax)
  803867:	8b 45 08             	mov    0x8(%ebp),%eax
  80386a:	8b 00                	mov    (%eax),%eax
  80386c:	85 c0                	test   %eax,%eax
  80386e:	74 0d                	je     80387d <insert_sorted_with_merge_freeList+0x4de>
  803870:	a1 48 51 80 00       	mov    0x805148,%eax
  803875:	8b 55 08             	mov    0x8(%ebp),%edx
  803878:	89 50 04             	mov    %edx,0x4(%eax)
  80387b:	eb 08                	jmp    803885 <insert_sorted_with_merge_freeList+0x4e6>
  80387d:	8b 45 08             	mov    0x8(%ebp),%eax
  803880:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803885:	8b 45 08             	mov    0x8(%ebp),%eax
  803888:	a3 48 51 80 00       	mov    %eax,0x805148
  80388d:	8b 45 08             	mov    0x8(%ebp),%eax
  803890:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803897:	a1 54 51 80 00       	mov    0x805154,%eax
  80389c:	40                   	inc    %eax
  80389d:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8038a2:	e9 41 02 00 00       	jmp    803ae8 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8038a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8038aa:	8b 50 08             	mov    0x8(%eax),%edx
  8038ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8038b0:	8b 40 0c             	mov    0xc(%eax),%eax
  8038b3:	01 c2                	add    %eax,%edx
  8038b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038b8:	8b 40 08             	mov    0x8(%eax),%eax
  8038bb:	39 c2                	cmp    %eax,%edx
  8038bd:	0f 85 7c 01 00 00    	jne    803a3f <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8038c3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8038c7:	74 06                	je     8038cf <insert_sorted_with_merge_freeList+0x530>
  8038c9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8038cd:	75 17                	jne    8038e6 <insert_sorted_with_merge_freeList+0x547>
  8038cf:	83 ec 04             	sub    $0x4,%esp
  8038d2:	68 c8 46 80 00       	push   $0x8046c8
  8038d7:	68 69 01 00 00       	push   $0x169
  8038dc:	68 af 46 80 00       	push   $0x8046af
  8038e1:	e8 9a ce ff ff       	call   800780 <_panic>
  8038e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038e9:	8b 50 04             	mov    0x4(%eax),%edx
  8038ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ef:	89 50 04             	mov    %edx,0x4(%eax)
  8038f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8038f5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8038f8:	89 10                	mov    %edx,(%eax)
  8038fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038fd:	8b 40 04             	mov    0x4(%eax),%eax
  803900:	85 c0                	test   %eax,%eax
  803902:	74 0d                	je     803911 <insert_sorted_with_merge_freeList+0x572>
  803904:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803907:	8b 40 04             	mov    0x4(%eax),%eax
  80390a:	8b 55 08             	mov    0x8(%ebp),%edx
  80390d:	89 10                	mov    %edx,(%eax)
  80390f:	eb 08                	jmp    803919 <insert_sorted_with_merge_freeList+0x57a>
  803911:	8b 45 08             	mov    0x8(%ebp),%eax
  803914:	a3 38 51 80 00       	mov    %eax,0x805138
  803919:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80391c:	8b 55 08             	mov    0x8(%ebp),%edx
  80391f:	89 50 04             	mov    %edx,0x4(%eax)
  803922:	a1 44 51 80 00       	mov    0x805144,%eax
  803927:	40                   	inc    %eax
  803928:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  80392d:	8b 45 08             	mov    0x8(%ebp),%eax
  803930:	8b 50 0c             	mov    0xc(%eax),%edx
  803933:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803936:	8b 40 0c             	mov    0xc(%eax),%eax
  803939:	01 c2                	add    %eax,%edx
  80393b:	8b 45 08             	mov    0x8(%ebp),%eax
  80393e:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803941:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803945:	75 17                	jne    80395e <insert_sorted_with_merge_freeList+0x5bf>
  803947:	83 ec 04             	sub    $0x4,%esp
  80394a:	68 58 47 80 00       	push   $0x804758
  80394f:	68 6b 01 00 00       	push   $0x16b
  803954:	68 af 46 80 00       	push   $0x8046af
  803959:	e8 22 ce ff ff       	call   800780 <_panic>
  80395e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803961:	8b 00                	mov    (%eax),%eax
  803963:	85 c0                	test   %eax,%eax
  803965:	74 10                	je     803977 <insert_sorted_with_merge_freeList+0x5d8>
  803967:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80396a:	8b 00                	mov    (%eax),%eax
  80396c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80396f:	8b 52 04             	mov    0x4(%edx),%edx
  803972:	89 50 04             	mov    %edx,0x4(%eax)
  803975:	eb 0b                	jmp    803982 <insert_sorted_with_merge_freeList+0x5e3>
  803977:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80397a:	8b 40 04             	mov    0x4(%eax),%eax
  80397d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803982:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803985:	8b 40 04             	mov    0x4(%eax),%eax
  803988:	85 c0                	test   %eax,%eax
  80398a:	74 0f                	je     80399b <insert_sorted_with_merge_freeList+0x5fc>
  80398c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80398f:	8b 40 04             	mov    0x4(%eax),%eax
  803992:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803995:	8b 12                	mov    (%edx),%edx
  803997:	89 10                	mov    %edx,(%eax)
  803999:	eb 0a                	jmp    8039a5 <insert_sorted_with_merge_freeList+0x606>
  80399b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80399e:	8b 00                	mov    (%eax),%eax
  8039a0:	a3 38 51 80 00       	mov    %eax,0x805138
  8039a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039a8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039b1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039b8:	a1 44 51 80 00       	mov    0x805144,%eax
  8039bd:	48                   	dec    %eax
  8039be:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  8039c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039c6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8039cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039d0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8039d7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8039db:	75 17                	jne    8039f4 <insert_sorted_with_merge_freeList+0x655>
  8039dd:	83 ec 04             	sub    $0x4,%esp
  8039e0:	68 8c 46 80 00       	push   $0x80468c
  8039e5:	68 6e 01 00 00       	push   $0x16e
  8039ea:	68 af 46 80 00       	push   $0x8046af
  8039ef:	e8 8c cd ff ff       	call   800780 <_panic>
  8039f4:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8039fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039fd:	89 10                	mov    %edx,(%eax)
  8039ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a02:	8b 00                	mov    (%eax),%eax
  803a04:	85 c0                	test   %eax,%eax
  803a06:	74 0d                	je     803a15 <insert_sorted_with_merge_freeList+0x676>
  803a08:	a1 48 51 80 00       	mov    0x805148,%eax
  803a0d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803a10:	89 50 04             	mov    %edx,0x4(%eax)
  803a13:	eb 08                	jmp    803a1d <insert_sorted_with_merge_freeList+0x67e>
  803a15:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a18:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803a1d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a20:	a3 48 51 80 00       	mov    %eax,0x805148
  803a25:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a28:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a2f:	a1 54 51 80 00       	mov    0x805154,%eax
  803a34:	40                   	inc    %eax
  803a35:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803a3a:	e9 a9 00 00 00       	jmp    803ae8 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803a3f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a43:	74 06                	je     803a4b <insert_sorted_with_merge_freeList+0x6ac>
  803a45:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803a49:	75 17                	jne    803a62 <insert_sorted_with_merge_freeList+0x6c3>
  803a4b:	83 ec 04             	sub    $0x4,%esp
  803a4e:	68 24 47 80 00       	push   $0x804724
  803a53:	68 73 01 00 00       	push   $0x173
  803a58:	68 af 46 80 00       	push   $0x8046af
  803a5d:	e8 1e cd ff ff       	call   800780 <_panic>
  803a62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a65:	8b 10                	mov    (%eax),%edx
  803a67:	8b 45 08             	mov    0x8(%ebp),%eax
  803a6a:	89 10                	mov    %edx,(%eax)
  803a6c:	8b 45 08             	mov    0x8(%ebp),%eax
  803a6f:	8b 00                	mov    (%eax),%eax
  803a71:	85 c0                	test   %eax,%eax
  803a73:	74 0b                	je     803a80 <insert_sorted_with_merge_freeList+0x6e1>
  803a75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a78:	8b 00                	mov    (%eax),%eax
  803a7a:	8b 55 08             	mov    0x8(%ebp),%edx
  803a7d:	89 50 04             	mov    %edx,0x4(%eax)
  803a80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a83:	8b 55 08             	mov    0x8(%ebp),%edx
  803a86:	89 10                	mov    %edx,(%eax)
  803a88:	8b 45 08             	mov    0x8(%ebp),%eax
  803a8b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803a8e:	89 50 04             	mov    %edx,0x4(%eax)
  803a91:	8b 45 08             	mov    0x8(%ebp),%eax
  803a94:	8b 00                	mov    (%eax),%eax
  803a96:	85 c0                	test   %eax,%eax
  803a98:	75 08                	jne    803aa2 <insert_sorted_with_merge_freeList+0x703>
  803a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  803a9d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803aa2:	a1 44 51 80 00       	mov    0x805144,%eax
  803aa7:	40                   	inc    %eax
  803aa8:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803aad:	eb 39                	jmp    803ae8 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803aaf:	a1 40 51 80 00       	mov    0x805140,%eax
  803ab4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803ab7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803abb:	74 07                	je     803ac4 <insert_sorted_with_merge_freeList+0x725>
  803abd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ac0:	8b 00                	mov    (%eax),%eax
  803ac2:	eb 05                	jmp    803ac9 <insert_sorted_with_merge_freeList+0x72a>
  803ac4:	b8 00 00 00 00       	mov    $0x0,%eax
  803ac9:	a3 40 51 80 00       	mov    %eax,0x805140
  803ace:	a1 40 51 80 00       	mov    0x805140,%eax
  803ad3:	85 c0                	test   %eax,%eax
  803ad5:	0f 85 c7 fb ff ff    	jne    8036a2 <insert_sorted_with_merge_freeList+0x303>
  803adb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803adf:	0f 85 bd fb ff ff    	jne    8036a2 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803ae5:	eb 01                	jmp    803ae8 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803ae7:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803ae8:	90                   	nop
  803ae9:	c9                   	leave  
  803aea:	c3                   	ret    
  803aeb:	90                   	nop

00803aec <__udivdi3>:
  803aec:	55                   	push   %ebp
  803aed:	57                   	push   %edi
  803aee:	56                   	push   %esi
  803aef:	53                   	push   %ebx
  803af0:	83 ec 1c             	sub    $0x1c,%esp
  803af3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803af7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803afb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803aff:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803b03:	89 ca                	mov    %ecx,%edx
  803b05:	89 f8                	mov    %edi,%eax
  803b07:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803b0b:	85 f6                	test   %esi,%esi
  803b0d:	75 2d                	jne    803b3c <__udivdi3+0x50>
  803b0f:	39 cf                	cmp    %ecx,%edi
  803b11:	77 65                	ja     803b78 <__udivdi3+0x8c>
  803b13:	89 fd                	mov    %edi,%ebp
  803b15:	85 ff                	test   %edi,%edi
  803b17:	75 0b                	jne    803b24 <__udivdi3+0x38>
  803b19:	b8 01 00 00 00       	mov    $0x1,%eax
  803b1e:	31 d2                	xor    %edx,%edx
  803b20:	f7 f7                	div    %edi
  803b22:	89 c5                	mov    %eax,%ebp
  803b24:	31 d2                	xor    %edx,%edx
  803b26:	89 c8                	mov    %ecx,%eax
  803b28:	f7 f5                	div    %ebp
  803b2a:	89 c1                	mov    %eax,%ecx
  803b2c:	89 d8                	mov    %ebx,%eax
  803b2e:	f7 f5                	div    %ebp
  803b30:	89 cf                	mov    %ecx,%edi
  803b32:	89 fa                	mov    %edi,%edx
  803b34:	83 c4 1c             	add    $0x1c,%esp
  803b37:	5b                   	pop    %ebx
  803b38:	5e                   	pop    %esi
  803b39:	5f                   	pop    %edi
  803b3a:	5d                   	pop    %ebp
  803b3b:	c3                   	ret    
  803b3c:	39 ce                	cmp    %ecx,%esi
  803b3e:	77 28                	ja     803b68 <__udivdi3+0x7c>
  803b40:	0f bd fe             	bsr    %esi,%edi
  803b43:	83 f7 1f             	xor    $0x1f,%edi
  803b46:	75 40                	jne    803b88 <__udivdi3+0x9c>
  803b48:	39 ce                	cmp    %ecx,%esi
  803b4a:	72 0a                	jb     803b56 <__udivdi3+0x6a>
  803b4c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803b50:	0f 87 9e 00 00 00    	ja     803bf4 <__udivdi3+0x108>
  803b56:	b8 01 00 00 00       	mov    $0x1,%eax
  803b5b:	89 fa                	mov    %edi,%edx
  803b5d:	83 c4 1c             	add    $0x1c,%esp
  803b60:	5b                   	pop    %ebx
  803b61:	5e                   	pop    %esi
  803b62:	5f                   	pop    %edi
  803b63:	5d                   	pop    %ebp
  803b64:	c3                   	ret    
  803b65:	8d 76 00             	lea    0x0(%esi),%esi
  803b68:	31 ff                	xor    %edi,%edi
  803b6a:	31 c0                	xor    %eax,%eax
  803b6c:	89 fa                	mov    %edi,%edx
  803b6e:	83 c4 1c             	add    $0x1c,%esp
  803b71:	5b                   	pop    %ebx
  803b72:	5e                   	pop    %esi
  803b73:	5f                   	pop    %edi
  803b74:	5d                   	pop    %ebp
  803b75:	c3                   	ret    
  803b76:	66 90                	xchg   %ax,%ax
  803b78:	89 d8                	mov    %ebx,%eax
  803b7a:	f7 f7                	div    %edi
  803b7c:	31 ff                	xor    %edi,%edi
  803b7e:	89 fa                	mov    %edi,%edx
  803b80:	83 c4 1c             	add    $0x1c,%esp
  803b83:	5b                   	pop    %ebx
  803b84:	5e                   	pop    %esi
  803b85:	5f                   	pop    %edi
  803b86:	5d                   	pop    %ebp
  803b87:	c3                   	ret    
  803b88:	bd 20 00 00 00       	mov    $0x20,%ebp
  803b8d:	89 eb                	mov    %ebp,%ebx
  803b8f:	29 fb                	sub    %edi,%ebx
  803b91:	89 f9                	mov    %edi,%ecx
  803b93:	d3 e6                	shl    %cl,%esi
  803b95:	89 c5                	mov    %eax,%ebp
  803b97:	88 d9                	mov    %bl,%cl
  803b99:	d3 ed                	shr    %cl,%ebp
  803b9b:	89 e9                	mov    %ebp,%ecx
  803b9d:	09 f1                	or     %esi,%ecx
  803b9f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803ba3:	89 f9                	mov    %edi,%ecx
  803ba5:	d3 e0                	shl    %cl,%eax
  803ba7:	89 c5                	mov    %eax,%ebp
  803ba9:	89 d6                	mov    %edx,%esi
  803bab:	88 d9                	mov    %bl,%cl
  803bad:	d3 ee                	shr    %cl,%esi
  803baf:	89 f9                	mov    %edi,%ecx
  803bb1:	d3 e2                	shl    %cl,%edx
  803bb3:	8b 44 24 08          	mov    0x8(%esp),%eax
  803bb7:	88 d9                	mov    %bl,%cl
  803bb9:	d3 e8                	shr    %cl,%eax
  803bbb:	09 c2                	or     %eax,%edx
  803bbd:	89 d0                	mov    %edx,%eax
  803bbf:	89 f2                	mov    %esi,%edx
  803bc1:	f7 74 24 0c          	divl   0xc(%esp)
  803bc5:	89 d6                	mov    %edx,%esi
  803bc7:	89 c3                	mov    %eax,%ebx
  803bc9:	f7 e5                	mul    %ebp
  803bcb:	39 d6                	cmp    %edx,%esi
  803bcd:	72 19                	jb     803be8 <__udivdi3+0xfc>
  803bcf:	74 0b                	je     803bdc <__udivdi3+0xf0>
  803bd1:	89 d8                	mov    %ebx,%eax
  803bd3:	31 ff                	xor    %edi,%edi
  803bd5:	e9 58 ff ff ff       	jmp    803b32 <__udivdi3+0x46>
  803bda:	66 90                	xchg   %ax,%ax
  803bdc:	8b 54 24 08          	mov    0x8(%esp),%edx
  803be0:	89 f9                	mov    %edi,%ecx
  803be2:	d3 e2                	shl    %cl,%edx
  803be4:	39 c2                	cmp    %eax,%edx
  803be6:	73 e9                	jae    803bd1 <__udivdi3+0xe5>
  803be8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803beb:	31 ff                	xor    %edi,%edi
  803bed:	e9 40 ff ff ff       	jmp    803b32 <__udivdi3+0x46>
  803bf2:	66 90                	xchg   %ax,%ax
  803bf4:	31 c0                	xor    %eax,%eax
  803bf6:	e9 37 ff ff ff       	jmp    803b32 <__udivdi3+0x46>
  803bfb:	90                   	nop

00803bfc <__umoddi3>:
  803bfc:	55                   	push   %ebp
  803bfd:	57                   	push   %edi
  803bfe:	56                   	push   %esi
  803bff:	53                   	push   %ebx
  803c00:	83 ec 1c             	sub    $0x1c,%esp
  803c03:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803c07:	8b 74 24 34          	mov    0x34(%esp),%esi
  803c0b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803c0f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803c13:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803c17:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803c1b:	89 f3                	mov    %esi,%ebx
  803c1d:	89 fa                	mov    %edi,%edx
  803c1f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c23:	89 34 24             	mov    %esi,(%esp)
  803c26:	85 c0                	test   %eax,%eax
  803c28:	75 1a                	jne    803c44 <__umoddi3+0x48>
  803c2a:	39 f7                	cmp    %esi,%edi
  803c2c:	0f 86 a2 00 00 00    	jbe    803cd4 <__umoddi3+0xd8>
  803c32:	89 c8                	mov    %ecx,%eax
  803c34:	89 f2                	mov    %esi,%edx
  803c36:	f7 f7                	div    %edi
  803c38:	89 d0                	mov    %edx,%eax
  803c3a:	31 d2                	xor    %edx,%edx
  803c3c:	83 c4 1c             	add    $0x1c,%esp
  803c3f:	5b                   	pop    %ebx
  803c40:	5e                   	pop    %esi
  803c41:	5f                   	pop    %edi
  803c42:	5d                   	pop    %ebp
  803c43:	c3                   	ret    
  803c44:	39 f0                	cmp    %esi,%eax
  803c46:	0f 87 ac 00 00 00    	ja     803cf8 <__umoddi3+0xfc>
  803c4c:	0f bd e8             	bsr    %eax,%ebp
  803c4f:	83 f5 1f             	xor    $0x1f,%ebp
  803c52:	0f 84 ac 00 00 00    	je     803d04 <__umoddi3+0x108>
  803c58:	bf 20 00 00 00       	mov    $0x20,%edi
  803c5d:	29 ef                	sub    %ebp,%edi
  803c5f:	89 fe                	mov    %edi,%esi
  803c61:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803c65:	89 e9                	mov    %ebp,%ecx
  803c67:	d3 e0                	shl    %cl,%eax
  803c69:	89 d7                	mov    %edx,%edi
  803c6b:	89 f1                	mov    %esi,%ecx
  803c6d:	d3 ef                	shr    %cl,%edi
  803c6f:	09 c7                	or     %eax,%edi
  803c71:	89 e9                	mov    %ebp,%ecx
  803c73:	d3 e2                	shl    %cl,%edx
  803c75:	89 14 24             	mov    %edx,(%esp)
  803c78:	89 d8                	mov    %ebx,%eax
  803c7a:	d3 e0                	shl    %cl,%eax
  803c7c:	89 c2                	mov    %eax,%edx
  803c7e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c82:	d3 e0                	shl    %cl,%eax
  803c84:	89 44 24 04          	mov    %eax,0x4(%esp)
  803c88:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c8c:	89 f1                	mov    %esi,%ecx
  803c8e:	d3 e8                	shr    %cl,%eax
  803c90:	09 d0                	or     %edx,%eax
  803c92:	d3 eb                	shr    %cl,%ebx
  803c94:	89 da                	mov    %ebx,%edx
  803c96:	f7 f7                	div    %edi
  803c98:	89 d3                	mov    %edx,%ebx
  803c9a:	f7 24 24             	mull   (%esp)
  803c9d:	89 c6                	mov    %eax,%esi
  803c9f:	89 d1                	mov    %edx,%ecx
  803ca1:	39 d3                	cmp    %edx,%ebx
  803ca3:	0f 82 87 00 00 00    	jb     803d30 <__umoddi3+0x134>
  803ca9:	0f 84 91 00 00 00    	je     803d40 <__umoddi3+0x144>
  803caf:	8b 54 24 04          	mov    0x4(%esp),%edx
  803cb3:	29 f2                	sub    %esi,%edx
  803cb5:	19 cb                	sbb    %ecx,%ebx
  803cb7:	89 d8                	mov    %ebx,%eax
  803cb9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803cbd:	d3 e0                	shl    %cl,%eax
  803cbf:	89 e9                	mov    %ebp,%ecx
  803cc1:	d3 ea                	shr    %cl,%edx
  803cc3:	09 d0                	or     %edx,%eax
  803cc5:	89 e9                	mov    %ebp,%ecx
  803cc7:	d3 eb                	shr    %cl,%ebx
  803cc9:	89 da                	mov    %ebx,%edx
  803ccb:	83 c4 1c             	add    $0x1c,%esp
  803cce:	5b                   	pop    %ebx
  803ccf:	5e                   	pop    %esi
  803cd0:	5f                   	pop    %edi
  803cd1:	5d                   	pop    %ebp
  803cd2:	c3                   	ret    
  803cd3:	90                   	nop
  803cd4:	89 fd                	mov    %edi,%ebp
  803cd6:	85 ff                	test   %edi,%edi
  803cd8:	75 0b                	jne    803ce5 <__umoddi3+0xe9>
  803cda:	b8 01 00 00 00       	mov    $0x1,%eax
  803cdf:	31 d2                	xor    %edx,%edx
  803ce1:	f7 f7                	div    %edi
  803ce3:	89 c5                	mov    %eax,%ebp
  803ce5:	89 f0                	mov    %esi,%eax
  803ce7:	31 d2                	xor    %edx,%edx
  803ce9:	f7 f5                	div    %ebp
  803ceb:	89 c8                	mov    %ecx,%eax
  803ced:	f7 f5                	div    %ebp
  803cef:	89 d0                	mov    %edx,%eax
  803cf1:	e9 44 ff ff ff       	jmp    803c3a <__umoddi3+0x3e>
  803cf6:	66 90                	xchg   %ax,%ax
  803cf8:	89 c8                	mov    %ecx,%eax
  803cfa:	89 f2                	mov    %esi,%edx
  803cfc:	83 c4 1c             	add    $0x1c,%esp
  803cff:	5b                   	pop    %ebx
  803d00:	5e                   	pop    %esi
  803d01:	5f                   	pop    %edi
  803d02:	5d                   	pop    %ebp
  803d03:	c3                   	ret    
  803d04:	3b 04 24             	cmp    (%esp),%eax
  803d07:	72 06                	jb     803d0f <__umoddi3+0x113>
  803d09:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803d0d:	77 0f                	ja     803d1e <__umoddi3+0x122>
  803d0f:	89 f2                	mov    %esi,%edx
  803d11:	29 f9                	sub    %edi,%ecx
  803d13:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803d17:	89 14 24             	mov    %edx,(%esp)
  803d1a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d1e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803d22:	8b 14 24             	mov    (%esp),%edx
  803d25:	83 c4 1c             	add    $0x1c,%esp
  803d28:	5b                   	pop    %ebx
  803d29:	5e                   	pop    %esi
  803d2a:	5f                   	pop    %edi
  803d2b:	5d                   	pop    %ebp
  803d2c:	c3                   	ret    
  803d2d:	8d 76 00             	lea    0x0(%esi),%esi
  803d30:	2b 04 24             	sub    (%esp),%eax
  803d33:	19 fa                	sbb    %edi,%edx
  803d35:	89 d1                	mov    %edx,%ecx
  803d37:	89 c6                	mov    %eax,%esi
  803d39:	e9 71 ff ff ff       	jmp    803caf <__umoddi3+0xb3>
  803d3e:	66 90                	xchg   %ax,%ax
  803d40:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803d44:	72 ea                	jb     803d30 <__umoddi3+0x134>
  803d46:	89 d9                	mov    %ebx,%ecx
  803d48:	e9 62 ff ff ff       	jmp    803caf <__umoddi3+0xb3>
