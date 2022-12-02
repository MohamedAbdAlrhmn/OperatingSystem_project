
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
  800041:	e8 89 1e 00 00       	call   801ecf <sys_disable_interrupt>
		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 20 3c 80 00       	push   $0x803c20
  80004e:	e8 e1 09 00 00       	call   800a34 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 22 3c 80 00       	push   $0x803c22
  80005e:	e8 d1 09 00 00       	call   800a34 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!   QUICK SORT    !!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 3b 3c 80 00       	push   $0x803c3b
  80006e:	e8 c1 09 00 00       	call   800a34 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 22 3c 80 00       	push   $0x803c22
  80007e:	e8 b1 09 00 00       	call   800a34 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 20 3c 80 00       	push   $0x803c20
  80008e:	e8 a1 09 00 00       	call   800a34 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp

		readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 54 3c 80 00       	push   $0x803c54
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
  8000de:	68 74 3c 80 00       	push   $0x803c74
  8000e3:	e8 4c 09 00 00       	call   800a34 <cprintf>
  8000e8:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000eb:	83 ec 0c             	sub    $0xc,%esp
  8000ee:	68 96 3c 80 00       	push   $0x803c96
  8000f3:	e8 3c 09 00 00       	call   800a34 <cprintf>
  8000f8:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000fb:	83 ec 0c             	sub    $0xc,%esp
  8000fe:	68 a4 3c 80 00       	push   $0x803ca4
  800103:	e8 2c 09 00 00       	call   800a34 <cprintf>
  800108:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 b3 3c 80 00       	push   $0x803cb3
  800113:	e8 1c 09 00 00       	call   800a34 <cprintf>
  800118:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	68 c3 3c 80 00       	push   $0x803cc3
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
  800162:	e8 82 1d 00 00       	call   801ee9 <sys_enable_interrupt>

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
  8001d5:	e8 f5 1c 00 00       	call   801ecf <sys_disable_interrupt>
			cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001da:	83 ec 0c             	sub    $0xc,%esp
  8001dd:	68 cc 3c 80 00       	push   $0x803ccc
  8001e2:	e8 4d 08 00 00       	call   800a34 <cprintf>
  8001e7:	83 c4 10             	add    $0x10,%esp
		//		PrintElements(Elements, NumOfElements);
		sys_enable_interrupt();
  8001ea:	e8 fa 1c 00 00       	call   801ee9 <sys_enable_interrupt>

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
  80020c:	68 00 3d 80 00       	push   $0x803d00
  800211:	6a 49                	push   $0x49
  800213:	68 22 3d 80 00       	push   $0x803d22
  800218:	e8 63 05 00 00       	call   800780 <_panic>
		else
		{
			sys_disable_interrupt();
  80021d:	e8 ad 1c 00 00       	call   801ecf <sys_disable_interrupt>
			cprintf("===============================================\n") ;
  800222:	83 ec 0c             	sub    $0xc,%esp
  800225:	68 40 3d 80 00       	push   $0x803d40
  80022a:	e8 05 08 00 00       	call   800a34 <cprintf>
  80022f:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  800232:	83 ec 0c             	sub    $0xc,%esp
  800235:	68 74 3d 80 00       	push   $0x803d74
  80023a:	e8 f5 07 00 00       	call   800a34 <cprintf>
  80023f:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  800242:	83 ec 0c             	sub    $0xc,%esp
  800245:	68 a8 3d 80 00       	push   $0x803da8
  80024a:	e8 e5 07 00 00       	call   800a34 <cprintf>
  80024f:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800252:	e8 92 1c 00 00       	call   801ee9 <sys_enable_interrupt>

		}

		free(Elements) ;
  800257:	83 ec 0c             	sub    $0xc,%esp
  80025a:	ff 75 f0             	pushl  -0x10(%ebp)
  80025d:	e8 8e 19 00 00       	call   801bf0 <free>
  800262:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  800265:	e8 65 1c 00 00       	call   801ecf <sys_disable_interrupt>

		cprintf("Do you want to repeat (y/n): ") ;
  80026a:	83 ec 0c             	sub    $0xc,%esp
  80026d:	68 da 3d 80 00       	push   $0x803dda
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
  80029f:	e8 45 1c 00 00       	call   801ee9 <sys_enable_interrupt>

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
  800544:	68 20 3c 80 00       	push   $0x803c20
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
  800566:	68 f8 3d 80 00       	push   $0x803df8
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
  800594:	68 fd 3d 80 00       	push   $0x803dfd
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
  8005b8:	e8 46 19 00 00       	call   801f03 <sys_cputc>
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
  8005c9:	e8 01 19 00 00       	call   801ecf <sys_disable_interrupt>
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
  8005dc:	e8 22 19 00 00       	call   801f03 <sys_cputc>
  8005e1:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8005e4:	e8 00 19 00 00       	call   801ee9 <sys_enable_interrupt>
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
  8005fb:	e8 4a 17 00 00       	call   801d4a <sys_cgetc>
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
  800614:	e8 b6 18 00 00       	call   801ecf <sys_disable_interrupt>
	int c=0;
  800619:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800620:	eb 08                	jmp    80062a <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  800622:	e8 23 17 00 00       	call   801d4a <sys_cgetc>
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
  800630:	e8 b4 18 00 00       	call   801ee9 <sys_enable_interrupt>
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
  80064a:	e8 73 1a 00 00       	call   8020c2 <sys_getenvindex>
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
  8006b5:	e8 15 18 00 00       	call   801ecf <sys_disable_interrupt>
	cprintf("**************************************\n");
  8006ba:	83 ec 0c             	sub    $0xc,%esp
  8006bd:	68 1c 3e 80 00       	push   $0x803e1c
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
  8006e5:	68 44 3e 80 00       	push   $0x803e44
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
  800716:	68 6c 3e 80 00       	push   $0x803e6c
  80071b:	e8 14 03 00 00       	call   800a34 <cprintf>
  800720:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800723:	a1 24 50 80 00       	mov    0x805024,%eax
  800728:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80072e:	83 ec 08             	sub    $0x8,%esp
  800731:	50                   	push   %eax
  800732:	68 c4 3e 80 00       	push   $0x803ec4
  800737:	e8 f8 02 00 00       	call   800a34 <cprintf>
  80073c:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80073f:	83 ec 0c             	sub    $0xc,%esp
  800742:	68 1c 3e 80 00       	push   $0x803e1c
  800747:	e8 e8 02 00 00       	call   800a34 <cprintf>
  80074c:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80074f:	e8 95 17 00 00       	call   801ee9 <sys_enable_interrupt>

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
  800767:	e8 22 19 00 00       	call   80208e <sys_destroy_env>
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
  800778:	e8 77 19 00 00       	call   8020f4 <sys_exit_env>
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
  8007a1:	68 d8 3e 80 00       	push   $0x803ed8
  8007a6:	e8 89 02 00 00       	call   800a34 <cprintf>
  8007ab:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8007ae:	a1 00 50 80 00       	mov    0x805000,%eax
  8007b3:	ff 75 0c             	pushl  0xc(%ebp)
  8007b6:	ff 75 08             	pushl  0x8(%ebp)
  8007b9:	50                   	push   %eax
  8007ba:	68 dd 3e 80 00       	push   $0x803edd
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
  8007de:	68 f9 3e 80 00       	push   $0x803ef9
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
  80080a:	68 fc 3e 80 00       	push   $0x803efc
  80080f:	6a 26                	push   $0x26
  800811:	68 48 3f 80 00       	push   $0x803f48
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
  8008dc:	68 54 3f 80 00       	push   $0x803f54
  8008e1:	6a 3a                	push   $0x3a
  8008e3:	68 48 3f 80 00       	push   $0x803f48
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
  80094c:	68 a8 3f 80 00       	push   $0x803fa8
  800951:	6a 44                	push   $0x44
  800953:	68 48 3f 80 00       	push   $0x803f48
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
  8009a6:	e8 76 13 00 00       	call   801d21 <sys_cputs>
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
  800a1d:	e8 ff 12 00 00       	call   801d21 <sys_cputs>
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
  800a67:	e8 63 14 00 00       	call   801ecf <sys_disable_interrupt>
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
  800a87:	e8 5d 14 00 00       	call   801ee9 <sys_enable_interrupt>
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
  800ad1:	e8 ce 2e 00 00       	call   8039a4 <__udivdi3>
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
  800b21:	e8 8e 2f 00 00       	call   803ab4 <__umoddi3>
  800b26:	83 c4 10             	add    $0x10,%esp
  800b29:	05 14 42 80 00       	add    $0x804214,%eax
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
  800c7c:	8b 04 85 38 42 80 00 	mov    0x804238(,%eax,4),%eax
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
  800d5d:	8b 34 9d 80 40 80 00 	mov    0x804080(,%ebx,4),%esi
  800d64:	85 f6                	test   %esi,%esi
  800d66:	75 19                	jne    800d81 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d68:	53                   	push   %ebx
  800d69:	68 25 42 80 00       	push   $0x804225
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
  800d82:	68 2e 42 80 00       	push   $0x80422e
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
  800daf:	be 31 42 80 00       	mov    $0x804231,%esi
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
  8010c8:	68 90 43 80 00       	push   $0x804390
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
  80110a:	68 93 43 80 00       	push   $0x804393
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
  8011ba:	e8 10 0d 00 00       	call   801ecf <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  8011bf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011c3:	74 13                	je     8011d8 <atomic_readline+0x24>
		cprintf("%s", prompt);
  8011c5:	83 ec 08             	sub    $0x8,%esp
  8011c8:	ff 75 08             	pushl  0x8(%ebp)
  8011cb:	68 90 43 80 00       	push   $0x804390
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
  801209:	68 93 43 80 00       	push   $0x804393
  80120e:	e8 21 f8 ff ff       	call   800a34 <cprintf>
  801213:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  801216:	e8 ce 0c 00 00       	call   801ee9 <sys_enable_interrupt>
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
  8012ae:	e8 36 0c 00 00       	call   801ee9 <sys_enable_interrupt>
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
  8019db:	68 a4 43 80 00       	push   $0x8043a4
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
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_PRESENT);
  801a8e:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801a95:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a98:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801a9d:	2d 00 10 00 00       	sub    $0x1000,%eax
  801aa2:	83 ec 04             	sub    $0x4,%esp
  801aa5:	6a 03                	push   $0x3
  801aa7:	ff 75 f4             	pushl  -0xc(%ebp)
  801aaa:	50                   	push   %eax
  801aab:	e8 b5 03 00 00       	call   801e65 <sys_allocate_chunk>
  801ab0:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801ab3:	a1 20 51 80 00       	mov    0x805120,%eax
  801ab8:	83 ec 0c             	sub    $0xc,%esp
  801abb:	50                   	push   %eax
  801abc:	e8 2a 0a 00 00       	call   8024eb <initialize_MemBlocksList>
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
  801ae9:	68 c9 43 80 00       	push   $0x8043c9
  801aee:	6a 33                	push   $0x33
  801af0:	68 e7 43 80 00       	push   $0x8043e7
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
  801b68:	68 f4 43 80 00       	push   $0x8043f4
  801b6d:	6a 34                	push   $0x34
  801b6f:	68 e7 43 80 00       	push   $0x8043e7
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
  801bdd:	68 18 44 80 00       	push   $0x804418
  801be2:	6a 46                	push   $0x46
  801be4:	68 e7 43 80 00       	push   $0x8043e7
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
  801bf9:	68 40 44 80 00       	push   $0x804440
  801bfe:	6a 61                	push   $0x61
  801c00:	68 e7 43 80 00       	push   $0x8043e7
  801c05:	e8 76 eb ff ff       	call   800780 <_panic>

00801c0a <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801c0a:	55                   	push   %ebp
  801c0b:	89 e5                	mov    %esp,%ebp
  801c0d:	83 ec 18             	sub    $0x18,%esp
  801c10:	8b 45 10             	mov    0x10(%ebp),%eax
  801c13:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801c16:	e8 a9 fd ff ff       	call   8019c4 <InitializeUHeap>
	if (size == 0) return NULL ;
  801c1b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801c1f:	75 07                	jne    801c28 <smalloc+0x1e>
  801c21:	b8 00 00 00 00       	mov    $0x0,%eax
  801c26:	eb 14                	jmp    801c3c <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801c28:	83 ec 04             	sub    $0x4,%esp
  801c2b:	68 64 44 80 00       	push   $0x804464
  801c30:	6a 76                	push   $0x76
  801c32:	68 e7 43 80 00       	push   $0x8043e7
  801c37:	e8 44 eb ff ff       	call   800780 <_panic>

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801c3c:	c9                   	leave  
  801c3d:	c3                   	ret    

00801c3e <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801c3e:	55                   	push   %ebp
  801c3f:	89 e5                	mov    %esp,%ebp
  801c41:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801c44:	e8 7b fd ff ff       	call   8019c4 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801c49:	83 ec 04             	sub    $0x4,%esp
  801c4c:	68 8c 44 80 00       	push   $0x80448c
  801c51:	68 93 00 00 00       	push   $0x93
  801c56:	68 e7 43 80 00       	push   $0x8043e7
  801c5b:	e8 20 eb ff ff       	call   800780 <_panic>

00801c60 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801c60:	55                   	push   %ebp
  801c61:	89 e5                	mov    %esp,%ebp
  801c63:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801c66:	e8 59 fd ff ff       	call   8019c4 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801c6b:	83 ec 04             	sub    $0x4,%esp
  801c6e:	68 b0 44 80 00       	push   $0x8044b0
  801c73:	68 c5 00 00 00       	push   $0xc5
  801c78:	68 e7 43 80 00       	push   $0x8043e7
  801c7d:	e8 fe ea ff ff       	call   800780 <_panic>

00801c82 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801c82:	55                   	push   %ebp
  801c83:	89 e5                	mov    %esp,%ebp
  801c85:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801c88:	83 ec 04             	sub    $0x4,%esp
  801c8b:	68 d8 44 80 00       	push   $0x8044d8
  801c90:	68 d9 00 00 00       	push   $0xd9
  801c95:	68 e7 43 80 00       	push   $0x8043e7
  801c9a:	e8 e1 ea ff ff       	call   800780 <_panic>

00801c9f <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801c9f:	55                   	push   %ebp
  801ca0:	89 e5                	mov    %esp,%ebp
  801ca2:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ca5:	83 ec 04             	sub    $0x4,%esp
  801ca8:	68 fc 44 80 00       	push   $0x8044fc
  801cad:	68 e4 00 00 00       	push   $0xe4
  801cb2:	68 e7 43 80 00       	push   $0x8043e7
  801cb7:	e8 c4 ea ff ff       	call   800780 <_panic>

00801cbc <shrink>:

}
void shrink(uint32 newSize)
{
  801cbc:	55                   	push   %ebp
  801cbd:	89 e5                	mov    %esp,%ebp
  801cbf:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801cc2:	83 ec 04             	sub    $0x4,%esp
  801cc5:	68 fc 44 80 00       	push   $0x8044fc
  801cca:	68 e9 00 00 00       	push   $0xe9
  801ccf:	68 e7 43 80 00       	push   $0x8043e7
  801cd4:	e8 a7 ea ff ff       	call   800780 <_panic>

00801cd9 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801cd9:	55                   	push   %ebp
  801cda:	89 e5                	mov    %esp,%ebp
  801cdc:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801cdf:	83 ec 04             	sub    $0x4,%esp
  801ce2:	68 fc 44 80 00       	push   $0x8044fc
  801ce7:	68 ee 00 00 00       	push   $0xee
  801cec:	68 e7 43 80 00       	push   $0x8043e7
  801cf1:	e8 8a ea ff ff       	call   800780 <_panic>

00801cf6 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801cf6:	55                   	push   %ebp
  801cf7:	89 e5                	mov    %esp,%ebp
  801cf9:	57                   	push   %edi
  801cfa:	56                   	push   %esi
  801cfb:	53                   	push   %ebx
  801cfc:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801cff:	8b 45 08             	mov    0x8(%ebp),%eax
  801d02:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d05:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d08:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d0b:	8b 7d 18             	mov    0x18(%ebp),%edi
  801d0e:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801d11:	cd 30                	int    $0x30
  801d13:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801d16:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801d19:	83 c4 10             	add    $0x10,%esp
  801d1c:	5b                   	pop    %ebx
  801d1d:	5e                   	pop    %esi
  801d1e:	5f                   	pop    %edi
  801d1f:	5d                   	pop    %ebp
  801d20:	c3                   	ret    

00801d21 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801d21:	55                   	push   %ebp
  801d22:	89 e5                	mov    %esp,%ebp
  801d24:	83 ec 04             	sub    $0x4,%esp
  801d27:	8b 45 10             	mov    0x10(%ebp),%eax
  801d2a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801d2d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d31:	8b 45 08             	mov    0x8(%ebp),%eax
  801d34:	6a 00                	push   $0x0
  801d36:	6a 00                	push   $0x0
  801d38:	52                   	push   %edx
  801d39:	ff 75 0c             	pushl  0xc(%ebp)
  801d3c:	50                   	push   %eax
  801d3d:	6a 00                	push   $0x0
  801d3f:	e8 b2 ff ff ff       	call   801cf6 <syscall>
  801d44:	83 c4 18             	add    $0x18,%esp
}
  801d47:	90                   	nop
  801d48:	c9                   	leave  
  801d49:	c3                   	ret    

00801d4a <sys_cgetc>:

int
sys_cgetc(void)
{
  801d4a:	55                   	push   %ebp
  801d4b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801d4d:	6a 00                	push   $0x0
  801d4f:	6a 00                	push   $0x0
  801d51:	6a 00                	push   $0x0
  801d53:	6a 00                	push   $0x0
  801d55:	6a 00                	push   $0x0
  801d57:	6a 01                	push   $0x1
  801d59:	e8 98 ff ff ff       	call   801cf6 <syscall>
  801d5e:	83 c4 18             	add    $0x18,%esp
}
  801d61:	c9                   	leave  
  801d62:	c3                   	ret    

00801d63 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801d63:	55                   	push   %ebp
  801d64:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801d66:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d69:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6c:	6a 00                	push   $0x0
  801d6e:	6a 00                	push   $0x0
  801d70:	6a 00                	push   $0x0
  801d72:	52                   	push   %edx
  801d73:	50                   	push   %eax
  801d74:	6a 05                	push   $0x5
  801d76:	e8 7b ff ff ff       	call   801cf6 <syscall>
  801d7b:	83 c4 18             	add    $0x18,%esp
}
  801d7e:	c9                   	leave  
  801d7f:	c3                   	ret    

00801d80 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801d80:	55                   	push   %ebp
  801d81:	89 e5                	mov    %esp,%ebp
  801d83:	56                   	push   %esi
  801d84:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801d85:	8b 75 18             	mov    0x18(%ebp),%esi
  801d88:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d8b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d8e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d91:	8b 45 08             	mov    0x8(%ebp),%eax
  801d94:	56                   	push   %esi
  801d95:	53                   	push   %ebx
  801d96:	51                   	push   %ecx
  801d97:	52                   	push   %edx
  801d98:	50                   	push   %eax
  801d99:	6a 06                	push   $0x6
  801d9b:	e8 56 ff ff ff       	call   801cf6 <syscall>
  801da0:	83 c4 18             	add    $0x18,%esp
}
  801da3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801da6:	5b                   	pop    %ebx
  801da7:	5e                   	pop    %esi
  801da8:	5d                   	pop    %ebp
  801da9:	c3                   	ret    

00801daa <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801daa:	55                   	push   %ebp
  801dab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801dad:	8b 55 0c             	mov    0xc(%ebp),%edx
  801db0:	8b 45 08             	mov    0x8(%ebp),%eax
  801db3:	6a 00                	push   $0x0
  801db5:	6a 00                	push   $0x0
  801db7:	6a 00                	push   $0x0
  801db9:	52                   	push   %edx
  801dba:	50                   	push   %eax
  801dbb:	6a 07                	push   $0x7
  801dbd:	e8 34 ff ff ff       	call   801cf6 <syscall>
  801dc2:	83 c4 18             	add    $0x18,%esp
}
  801dc5:	c9                   	leave  
  801dc6:	c3                   	ret    

00801dc7 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801dc7:	55                   	push   %ebp
  801dc8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801dca:	6a 00                	push   $0x0
  801dcc:	6a 00                	push   $0x0
  801dce:	6a 00                	push   $0x0
  801dd0:	ff 75 0c             	pushl  0xc(%ebp)
  801dd3:	ff 75 08             	pushl  0x8(%ebp)
  801dd6:	6a 08                	push   $0x8
  801dd8:	e8 19 ff ff ff       	call   801cf6 <syscall>
  801ddd:	83 c4 18             	add    $0x18,%esp
}
  801de0:	c9                   	leave  
  801de1:	c3                   	ret    

00801de2 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801de2:	55                   	push   %ebp
  801de3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801de5:	6a 00                	push   $0x0
  801de7:	6a 00                	push   $0x0
  801de9:	6a 00                	push   $0x0
  801deb:	6a 00                	push   $0x0
  801ded:	6a 00                	push   $0x0
  801def:	6a 09                	push   $0x9
  801df1:	e8 00 ff ff ff       	call   801cf6 <syscall>
  801df6:	83 c4 18             	add    $0x18,%esp
}
  801df9:	c9                   	leave  
  801dfa:	c3                   	ret    

00801dfb <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801dfb:	55                   	push   %ebp
  801dfc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801dfe:	6a 00                	push   $0x0
  801e00:	6a 00                	push   $0x0
  801e02:	6a 00                	push   $0x0
  801e04:	6a 00                	push   $0x0
  801e06:	6a 00                	push   $0x0
  801e08:	6a 0a                	push   $0xa
  801e0a:	e8 e7 fe ff ff       	call   801cf6 <syscall>
  801e0f:	83 c4 18             	add    $0x18,%esp
}
  801e12:	c9                   	leave  
  801e13:	c3                   	ret    

00801e14 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801e14:	55                   	push   %ebp
  801e15:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801e17:	6a 00                	push   $0x0
  801e19:	6a 00                	push   $0x0
  801e1b:	6a 00                	push   $0x0
  801e1d:	6a 00                	push   $0x0
  801e1f:	6a 00                	push   $0x0
  801e21:	6a 0b                	push   $0xb
  801e23:	e8 ce fe ff ff       	call   801cf6 <syscall>
  801e28:	83 c4 18             	add    $0x18,%esp
}
  801e2b:	c9                   	leave  
  801e2c:	c3                   	ret    

00801e2d <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801e2d:	55                   	push   %ebp
  801e2e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801e30:	6a 00                	push   $0x0
  801e32:	6a 00                	push   $0x0
  801e34:	6a 00                	push   $0x0
  801e36:	ff 75 0c             	pushl  0xc(%ebp)
  801e39:	ff 75 08             	pushl  0x8(%ebp)
  801e3c:	6a 0f                	push   $0xf
  801e3e:	e8 b3 fe ff ff       	call   801cf6 <syscall>
  801e43:	83 c4 18             	add    $0x18,%esp
	return;
  801e46:	90                   	nop
}
  801e47:	c9                   	leave  
  801e48:	c3                   	ret    

00801e49 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801e49:	55                   	push   %ebp
  801e4a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801e4c:	6a 00                	push   $0x0
  801e4e:	6a 00                	push   $0x0
  801e50:	6a 00                	push   $0x0
  801e52:	ff 75 0c             	pushl  0xc(%ebp)
  801e55:	ff 75 08             	pushl  0x8(%ebp)
  801e58:	6a 10                	push   $0x10
  801e5a:	e8 97 fe ff ff       	call   801cf6 <syscall>
  801e5f:	83 c4 18             	add    $0x18,%esp
	return ;
  801e62:	90                   	nop
}
  801e63:	c9                   	leave  
  801e64:	c3                   	ret    

00801e65 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801e65:	55                   	push   %ebp
  801e66:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801e68:	6a 00                	push   $0x0
  801e6a:	6a 00                	push   $0x0
  801e6c:	ff 75 10             	pushl  0x10(%ebp)
  801e6f:	ff 75 0c             	pushl  0xc(%ebp)
  801e72:	ff 75 08             	pushl  0x8(%ebp)
  801e75:	6a 11                	push   $0x11
  801e77:	e8 7a fe ff ff       	call   801cf6 <syscall>
  801e7c:	83 c4 18             	add    $0x18,%esp
	return ;
  801e7f:	90                   	nop
}
  801e80:	c9                   	leave  
  801e81:	c3                   	ret    

00801e82 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801e82:	55                   	push   %ebp
  801e83:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801e85:	6a 00                	push   $0x0
  801e87:	6a 00                	push   $0x0
  801e89:	6a 00                	push   $0x0
  801e8b:	6a 00                	push   $0x0
  801e8d:	6a 00                	push   $0x0
  801e8f:	6a 0c                	push   $0xc
  801e91:	e8 60 fe ff ff       	call   801cf6 <syscall>
  801e96:	83 c4 18             	add    $0x18,%esp
}
  801e99:	c9                   	leave  
  801e9a:	c3                   	ret    

00801e9b <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801e9b:	55                   	push   %ebp
  801e9c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801e9e:	6a 00                	push   $0x0
  801ea0:	6a 00                	push   $0x0
  801ea2:	6a 00                	push   $0x0
  801ea4:	6a 00                	push   $0x0
  801ea6:	ff 75 08             	pushl  0x8(%ebp)
  801ea9:	6a 0d                	push   $0xd
  801eab:	e8 46 fe ff ff       	call   801cf6 <syscall>
  801eb0:	83 c4 18             	add    $0x18,%esp
}
  801eb3:	c9                   	leave  
  801eb4:	c3                   	ret    

00801eb5 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801eb5:	55                   	push   %ebp
  801eb6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801eb8:	6a 00                	push   $0x0
  801eba:	6a 00                	push   $0x0
  801ebc:	6a 00                	push   $0x0
  801ebe:	6a 00                	push   $0x0
  801ec0:	6a 00                	push   $0x0
  801ec2:	6a 0e                	push   $0xe
  801ec4:	e8 2d fe ff ff       	call   801cf6 <syscall>
  801ec9:	83 c4 18             	add    $0x18,%esp
}
  801ecc:	90                   	nop
  801ecd:	c9                   	leave  
  801ece:	c3                   	ret    

00801ecf <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801ecf:	55                   	push   %ebp
  801ed0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801ed2:	6a 00                	push   $0x0
  801ed4:	6a 00                	push   $0x0
  801ed6:	6a 00                	push   $0x0
  801ed8:	6a 00                	push   $0x0
  801eda:	6a 00                	push   $0x0
  801edc:	6a 13                	push   $0x13
  801ede:	e8 13 fe ff ff       	call   801cf6 <syscall>
  801ee3:	83 c4 18             	add    $0x18,%esp
}
  801ee6:	90                   	nop
  801ee7:	c9                   	leave  
  801ee8:	c3                   	ret    

00801ee9 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801ee9:	55                   	push   %ebp
  801eea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801eec:	6a 00                	push   $0x0
  801eee:	6a 00                	push   $0x0
  801ef0:	6a 00                	push   $0x0
  801ef2:	6a 00                	push   $0x0
  801ef4:	6a 00                	push   $0x0
  801ef6:	6a 14                	push   $0x14
  801ef8:	e8 f9 fd ff ff       	call   801cf6 <syscall>
  801efd:	83 c4 18             	add    $0x18,%esp
}
  801f00:	90                   	nop
  801f01:	c9                   	leave  
  801f02:	c3                   	ret    

00801f03 <sys_cputc>:


void
sys_cputc(const char c)
{
  801f03:	55                   	push   %ebp
  801f04:	89 e5                	mov    %esp,%ebp
  801f06:	83 ec 04             	sub    $0x4,%esp
  801f09:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801f0f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f13:	6a 00                	push   $0x0
  801f15:	6a 00                	push   $0x0
  801f17:	6a 00                	push   $0x0
  801f19:	6a 00                	push   $0x0
  801f1b:	50                   	push   %eax
  801f1c:	6a 15                	push   $0x15
  801f1e:	e8 d3 fd ff ff       	call   801cf6 <syscall>
  801f23:	83 c4 18             	add    $0x18,%esp
}
  801f26:	90                   	nop
  801f27:	c9                   	leave  
  801f28:	c3                   	ret    

00801f29 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801f29:	55                   	push   %ebp
  801f2a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801f2c:	6a 00                	push   $0x0
  801f2e:	6a 00                	push   $0x0
  801f30:	6a 00                	push   $0x0
  801f32:	6a 00                	push   $0x0
  801f34:	6a 00                	push   $0x0
  801f36:	6a 16                	push   $0x16
  801f38:	e8 b9 fd ff ff       	call   801cf6 <syscall>
  801f3d:	83 c4 18             	add    $0x18,%esp
}
  801f40:	90                   	nop
  801f41:	c9                   	leave  
  801f42:	c3                   	ret    

00801f43 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801f43:	55                   	push   %ebp
  801f44:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801f46:	8b 45 08             	mov    0x8(%ebp),%eax
  801f49:	6a 00                	push   $0x0
  801f4b:	6a 00                	push   $0x0
  801f4d:	6a 00                	push   $0x0
  801f4f:	ff 75 0c             	pushl  0xc(%ebp)
  801f52:	50                   	push   %eax
  801f53:	6a 17                	push   $0x17
  801f55:	e8 9c fd ff ff       	call   801cf6 <syscall>
  801f5a:	83 c4 18             	add    $0x18,%esp
}
  801f5d:	c9                   	leave  
  801f5e:	c3                   	ret    

00801f5f <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801f5f:	55                   	push   %ebp
  801f60:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f62:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f65:	8b 45 08             	mov    0x8(%ebp),%eax
  801f68:	6a 00                	push   $0x0
  801f6a:	6a 00                	push   $0x0
  801f6c:	6a 00                	push   $0x0
  801f6e:	52                   	push   %edx
  801f6f:	50                   	push   %eax
  801f70:	6a 1a                	push   $0x1a
  801f72:	e8 7f fd ff ff       	call   801cf6 <syscall>
  801f77:	83 c4 18             	add    $0x18,%esp
}
  801f7a:	c9                   	leave  
  801f7b:	c3                   	ret    

00801f7c <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801f7c:	55                   	push   %ebp
  801f7d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f82:	8b 45 08             	mov    0x8(%ebp),%eax
  801f85:	6a 00                	push   $0x0
  801f87:	6a 00                	push   $0x0
  801f89:	6a 00                	push   $0x0
  801f8b:	52                   	push   %edx
  801f8c:	50                   	push   %eax
  801f8d:	6a 18                	push   $0x18
  801f8f:	e8 62 fd ff ff       	call   801cf6 <syscall>
  801f94:	83 c4 18             	add    $0x18,%esp
}
  801f97:	90                   	nop
  801f98:	c9                   	leave  
  801f99:	c3                   	ret    

00801f9a <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801f9a:	55                   	push   %ebp
  801f9b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f9d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa3:	6a 00                	push   $0x0
  801fa5:	6a 00                	push   $0x0
  801fa7:	6a 00                	push   $0x0
  801fa9:	52                   	push   %edx
  801faa:	50                   	push   %eax
  801fab:	6a 19                	push   $0x19
  801fad:	e8 44 fd ff ff       	call   801cf6 <syscall>
  801fb2:	83 c4 18             	add    $0x18,%esp
}
  801fb5:	90                   	nop
  801fb6:	c9                   	leave  
  801fb7:	c3                   	ret    

00801fb8 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801fb8:	55                   	push   %ebp
  801fb9:	89 e5                	mov    %esp,%ebp
  801fbb:	83 ec 04             	sub    $0x4,%esp
  801fbe:	8b 45 10             	mov    0x10(%ebp),%eax
  801fc1:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801fc4:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801fc7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801fcb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fce:	6a 00                	push   $0x0
  801fd0:	51                   	push   %ecx
  801fd1:	52                   	push   %edx
  801fd2:	ff 75 0c             	pushl  0xc(%ebp)
  801fd5:	50                   	push   %eax
  801fd6:	6a 1b                	push   $0x1b
  801fd8:	e8 19 fd ff ff       	call   801cf6 <syscall>
  801fdd:	83 c4 18             	add    $0x18,%esp
}
  801fe0:	c9                   	leave  
  801fe1:	c3                   	ret    

00801fe2 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801fe2:	55                   	push   %ebp
  801fe3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801fe5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fe8:	8b 45 08             	mov    0x8(%ebp),%eax
  801feb:	6a 00                	push   $0x0
  801fed:	6a 00                	push   $0x0
  801fef:	6a 00                	push   $0x0
  801ff1:	52                   	push   %edx
  801ff2:	50                   	push   %eax
  801ff3:	6a 1c                	push   $0x1c
  801ff5:	e8 fc fc ff ff       	call   801cf6 <syscall>
  801ffa:	83 c4 18             	add    $0x18,%esp
}
  801ffd:	c9                   	leave  
  801ffe:	c3                   	ret    

00801fff <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801fff:	55                   	push   %ebp
  802000:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802002:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802005:	8b 55 0c             	mov    0xc(%ebp),%edx
  802008:	8b 45 08             	mov    0x8(%ebp),%eax
  80200b:	6a 00                	push   $0x0
  80200d:	6a 00                	push   $0x0
  80200f:	51                   	push   %ecx
  802010:	52                   	push   %edx
  802011:	50                   	push   %eax
  802012:	6a 1d                	push   $0x1d
  802014:	e8 dd fc ff ff       	call   801cf6 <syscall>
  802019:	83 c4 18             	add    $0x18,%esp
}
  80201c:	c9                   	leave  
  80201d:	c3                   	ret    

0080201e <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80201e:	55                   	push   %ebp
  80201f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802021:	8b 55 0c             	mov    0xc(%ebp),%edx
  802024:	8b 45 08             	mov    0x8(%ebp),%eax
  802027:	6a 00                	push   $0x0
  802029:	6a 00                	push   $0x0
  80202b:	6a 00                	push   $0x0
  80202d:	52                   	push   %edx
  80202e:	50                   	push   %eax
  80202f:	6a 1e                	push   $0x1e
  802031:	e8 c0 fc ff ff       	call   801cf6 <syscall>
  802036:	83 c4 18             	add    $0x18,%esp
}
  802039:	c9                   	leave  
  80203a:	c3                   	ret    

0080203b <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80203b:	55                   	push   %ebp
  80203c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80203e:	6a 00                	push   $0x0
  802040:	6a 00                	push   $0x0
  802042:	6a 00                	push   $0x0
  802044:	6a 00                	push   $0x0
  802046:	6a 00                	push   $0x0
  802048:	6a 1f                	push   $0x1f
  80204a:	e8 a7 fc ff ff       	call   801cf6 <syscall>
  80204f:	83 c4 18             	add    $0x18,%esp
}
  802052:	c9                   	leave  
  802053:	c3                   	ret    

00802054 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802054:	55                   	push   %ebp
  802055:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802057:	8b 45 08             	mov    0x8(%ebp),%eax
  80205a:	6a 00                	push   $0x0
  80205c:	ff 75 14             	pushl  0x14(%ebp)
  80205f:	ff 75 10             	pushl  0x10(%ebp)
  802062:	ff 75 0c             	pushl  0xc(%ebp)
  802065:	50                   	push   %eax
  802066:	6a 20                	push   $0x20
  802068:	e8 89 fc ff ff       	call   801cf6 <syscall>
  80206d:	83 c4 18             	add    $0x18,%esp
}
  802070:	c9                   	leave  
  802071:	c3                   	ret    

00802072 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802072:	55                   	push   %ebp
  802073:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802075:	8b 45 08             	mov    0x8(%ebp),%eax
  802078:	6a 00                	push   $0x0
  80207a:	6a 00                	push   $0x0
  80207c:	6a 00                	push   $0x0
  80207e:	6a 00                	push   $0x0
  802080:	50                   	push   %eax
  802081:	6a 21                	push   $0x21
  802083:	e8 6e fc ff ff       	call   801cf6 <syscall>
  802088:	83 c4 18             	add    $0x18,%esp
}
  80208b:	90                   	nop
  80208c:	c9                   	leave  
  80208d:	c3                   	ret    

0080208e <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80208e:	55                   	push   %ebp
  80208f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802091:	8b 45 08             	mov    0x8(%ebp),%eax
  802094:	6a 00                	push   $0x0
  802096:	6a 00                	push   $0x0
  802098:	6a 00                	push   $0x0
  80209a:	6a 00                	push   $0x0
  80209c:	50                   	push   %eax
  80209d:	6a 22                	push   $0x22
  80209f:	e8 52 fc ff ff       	call   801cf6 <syscall>
  8020a4:	83 c4 18             	add    $0x18,%esp
}
  8020a7:	c9                   	leave  
  8020a8:	c3                   	ret    

008020a9 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8020a9:	55                   	push   %ebp
  8020aa:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8020ac:	6a 00                	push   $0x0
  8020ae:	6a 00                	push   $0x0
  8020b0:	6a 00                	push   $0x0
  8020b2:	6a 00                	push   $0x0
  8020b4:	6a 00                	push   $0x0
  8020b6:	6a 02                	push   $0x2
  8020b8:	e8 39 fc ff ff       	call   801cf6 <syscall>
  8020bd:	83 c4 18             	add    $0x18,%esp
}
  8020c0:	c9                   	leave  
  8020c1:	c3                   	ret    

008020c2 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8020c2:	55                   	push   %ebp
  8020c3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8020c5:	6a 00                	push   $0x0
  8020c7:	6a 00                	push   $0x0
  8020c9:	6a 00                	push   $0x0
  8020cb:	6a 00                	push   $0x0
  8020cd:	6a 00                	push   $0x0
  8020cf:	6a 03                	push   $0x3
  8020d1:	e8 20 fc ff ff       	call   801cf6 <syscall>
  8020d6:	83 c4 18             	add    $0x18,%esp
}
  8020d9:	c9                   	leave  
  8020da:	c3                   	ret    

008020db <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8020db:	55                   	push   %ebp
  8020dc:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8020de:	6a 00                	push   $0x0
  8020e0:	6a 00                	push   $0x0
  8020e2:	6a 00                	push   $0x0
  8020e4:	6a 00                	push   $0x0
  8020e6:	6a 00                	push   $0x0
  8020e8:	6a 04                	push   $0x4
  8020ea:	e8 07 fc ff ff       	call   801cf6 <syscall>
  8020ef:	83 c4 18             	add    $0x18,%esp
}
  8020f2:	c9                   	leave  
  8020f3:	c3                   	ret    

008020f4 <sys_exit_env>:


void sys_exit_env(void)
{
  8020f4:	55                   	push   %ebp
  8020f5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8020f7:	6a 00                	push   $0x0
  8020f9:	6a 00                	push   $0x0
  8020fb:	6a 00                	push   $0x0
  8020fd:	6a 00                	push   $0x0
  8020ff:	6a 00                	push   $0x0
  802101:	6a 23                	push   $0x23
  802103:	e8 ee fb ff ff       	call   801cf6 <syscall>
  802108:	83 c4 18             	add    $0x18,%esp
}
  80210b:	90                   	nop
  80210c:	c9                   	leave  
  80210d:	c3                   	ret    

0080210e <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80210e:	55                   	push   %ebp
  80210f:	89 e5                	mov    %esp,%ebp
  802111:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802114:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802117:	8d 50 04             	lea    0x4(%eax),%edx
  80211a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80211d:	6a 00                	push   $0x0
  80211f:	6a 00                	push   $0x0
  802121:	6a 00                	push   $0x0
  802123:	52                   	push   %edx
  802124:	50                   	push   %eax
  802125:	6a 24                	push   $0x24
  802127:	e8 ca fb ff ff       	call   801cf6 <syscall>
  80212c:	83 c4 18             	add    $0x18,%esp
	return result;
  80212f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802132:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802135:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802138:	89 01                	mov    %eax,(%ecx)
  80213a:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80213d:	8b 45 08             	mov    0x8(%ebp),%eax
  802140:	c9                   	leave  
  802141:	c2 04 00             	ret    $0x4

00802144 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802144:	55                   	push   %ebp
  802145:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802147:	6a 00                	push   $0x0
  802149:	6a 00                	push   $0x0
  80214b:	ff 75 10             	pushl  0x10(%ebp)
  80214e:	ff 75 0c             	pushl  0xc(%ebp)
  802151:	ff 75 08             	pushl  0x8(%ebp)
  802154:	6a 12                	push   $0x12
  802156:	e8 9b fb ff ff       	call   801cf6 <syscall>
  80215b:	83 c4 18             	add    $0x18,%esp
	return ;
  80215e:	90                   	nop
}
  80215f:	c9                   	leave  
  802160:	c3                   	ret    

00802161 <sys_rcr2>:
uint32 sys_rcr2()
{
  802161:	55                   	push   %ebp
  802162:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802164:	6a 00                	push   $0x0
  802166:	6a 00                	push   $0x0
  802168:	6a 00                	push   $0x0
  80216a:	6a 00                	push   $0x0
  80216c:	6a 00                	push   $0x0
  80216e:	6a 25                	push   $0x25
  802170:	e8 81 fb ff ff       	call   801cf6 <syscall>
  802175:	83 c4 18             	add    $0x18,%esp
}
  802178:	c9                   	leave  
  802179:	c3                   	ret    

0080217a <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80217a:	55                   	push   %ebp
  80217b:	89 e5                	mov    %esp,%ebp
  80217d:	83 ec 04             	sub    $0x4,%esp
  802180:	8b 45 08             	mov    0x8(%ebp),%eax
  802183:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802186:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80218a:	6a 00                	push   $0x0
  80218c:	6a 00                	push   $0x0
  80218e:	6a 00                	push   $0x0
  802190:	6a 00                	push   $0x0
  802192:	50                   	push   %eax
  802193:	6a 26                	push   $0x26
  802195:	e8 5c fb ff ff       	call   801cf6 <syscall>
  80219a:	83 c4 18             	add    $0x18,%esp
	return ;
  80219d:	90                   	nop
}
  80219e:	c9                   	leave  
  80219f:	c3                   	ret    

008021a0 <rsttst>:
void rsttst()
{
  8021a0:	55                   	push   %ebp
  8021a1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8021a3:	6a 00                	push   $0x0
  8021a5:	6a 00                	push   $0x0
  8021a7:	6a 00                	push   $0x0
  8021a9:	6a 00                	push   $0x0
  8021ab:	6a 00                	push   $0x0
  8021ad:	6a 28                	push   $0x28
  8021af:	e8 42 fb ff ff       	call   801cf6 <syscall>
  8021b4:	83 c4 18             	add    $0x18,%esp
	return ;
  8021b7:	90                   	nop
}
  8021b8:	c9                   	leave  
  8021b9:	c3                   	ret    

008021ba <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8021ba:	55                   	push   %ebp
  8021bb:	89 e5                	mov    %esp,%ebp
  8021bd:	83 ec 04             	sub    $0x4,%esp
  8021c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8021c3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8021c6:	8b 55 18             	mov    0x18(%ebp),%edx
  8021c9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8021cd:	52                   	push   %edx
  8021ce:	50                   	push   %eax
  8021cf:	ff 75 10             	pushl  0x10(%ebp)
  8021d2:	ff 75 0c             	pushl  0xc(%ebp)
  8021d5:	ff 75 08             	pushl  0x8(%ebp)
  8021d8:	6a 27                	push   $0x27
  8021da:	e8 17 fb ff ff       	call   801cf6 <syscall>
  8021df:	83 c4 18             	add    $0x18,%esp
	return ;
  8021e2:	90                   	nop
}
  8021e3:	c9                   	leave  
  8021e4:	c3                   	ret    

008021e5 <chktst>:
void chktst(uint32 n)
{
  8021e5:	55                   	push   %ebp
  8021e6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8021e8:	6a 00                	push   $0x0
  8021ea:	6a 00                	push   $0x0
  8021ec:	6a 00                	push   $0x0
  8021ee:	6a 00                	push   $0x0
  8021f0:	ff 75 08             	pushl  0x8(%ebp)
  8021f3:	6a 29                	push   $0x29
  8021f5:	e8 fc fa ff ff       	call   801cf6 <syscall>
  8021fa:	83 c4 18             	add    $0x18,%esp
	return ;
  8021fd:	90                   	nop
}
  8021fe:	c9                   	leave  
  8021ff:	c3                   	ret    

00802200 <inctst>:

void inctst()
{
  802200:	55                   	push   %ebp
  802201:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802203:	6a 00                	push   $0x0
  802205:	6a 00                	push   $0x0
  802207:	6a 00                	push   $0x0
  802209:	6a 00                	push   $0x0
  80220b:	6a 00                	push   $0x0
  80220d:	6a 2a                	push   $0x2a
  80220f:	e8 e2 fa ff ff       	call   801cf6 <syscall>
  802214:	83 c4 18             	add    $0x18,%esp
	return ;
  802217:	90                   	nop
}
  802218:	c9                   	leave  
  802219:	c3                   	ret    

0080221a <gettst>:
uint32 gettst()
{
  80221a:	55                   	push   %ebp
  80221b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80221d:	6a 00                	push   $0x0
  80221f:	6a 00                	push   $0x0
  802221:	6a 00                	push   $0x0
  802223:	6a 00                	push   $0x0
  802225:	6a 00                	push   $0x0
  802227:	6a 2b                	push   $0x2b
  802229:	e8 c8 fa ff ff       	call   801cf6 <syscall>
  80222e:	83 c4 18             	add    $0x18,%esp
}
  802231:	c9                   	leave  
  802232:	c3                   	ret    

00802233 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802233:	55                   	push   %ebp
  802234:	89 e5                	mov    %esp,%ebp
  802236:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802239:	6a 00                	push   $0x0
  80223b:	6a 00                	push   $0x0
  80223d:	6a 00                	push   $0x0
  80223f:	6a 00                	push   $0x0
  802241:	6a 00                	push   $0x0
  802243:	6a 2c                	push   $0x2c
  802245:	e8 ac fa ff ff       	call   801cf6 <syscall>
  80224a:	83 c4 18             	add    $0x18,%esp
  80224d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802250:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802254:	75 07                	jne    80225d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802256:	b8 01 00 00 00       	mov    $0x1,%eax
  80225b:	eb 05                	jmp    802262 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80225d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802262:	c9                   	leave  
  802263:	c3                   	ret    

00802264 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802264:	55                   	push   %ebp
  802265:	89 e5                	mov    %esp,%ebp
  802267:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80226a:	6a 00                	push   $0x0
  80226c:	6a 00                	push   $0x0
  80226e:	6a 00                	push   $0x0
  802270:	6a 00                	push   $0x0
  802272:	6a 00                	push   $0x0
  802274:	6a 2c                	push   $0x2c
  802276:	e8 7b fa ff ff       	call   801cf6 <syscall>
  80227b:	83 c4 18             	add    $0x18,%esp
  80227e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802281:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802285:	75 07                	jne    80228e <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802287:	b8 01 00 00 00       	mov    $0x1,%eax
  80228c:	eb 05                	jmp    802293 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80228e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802293:	c9                   	leave  
  802294:	c3                   	ret    

00802295 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802295:	55                   	push   %ebp
  802296:	89 e5                	mov    %esp,%ebp
  802298:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80229b:	6a 00                	push   $0x0
  80229d:	6a 00                	push   $0x0
  80229f:	6a 00                	push   $0x0
  8022a1:	6a 00                	push   $0x0
  8022a3:	6a 00                	push   $0x0
  8022a5:	6a 2c                	push   $0x2c
  8022a7:	e8 4a fa ff ff       	call   801cf6 <syscall>
  8022ac:	83 c4 18             	add    $0x18,%esp
  8022af:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8022b2:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8022b6:	75 07                	jne    8022bf <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8022b8:	b8 01 00 00 00       	mov    $0x1,%eax
  8022bd:	eb 05                	jmp    8022c4 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8022bf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022c4:	c9                   	leave  
  8022c5:	c3                   	ret    

008022c6 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8022c6:	55                   	push   %ebp
  8022c7:	89 e5                	mov    %esp,%ebp
  8022c9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8022cc:	6a 00                	push   $0x0
  8022ce:	6a 00                	push   $0x0
  8022d0:	6a 00                	push   $0x0
  8022d2:	6a 00                	push   $0x0
  8022d4:	6a 00                	push   $0x0
  8022d6:	6a 2c                	push   $0x2c
  8022d8:	e8 19 fa ff ff       	call   801cf6 <syscall>
  8022dd:	83 c4 18             	add    $0x18,%esp
  8022e0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8022e3:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8022e7:	75 07                	jne    8022f0 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8022e9:	b8 01 00 00 00       	mov    $0x1,%eax
  8022ee:	eb 05                	jmp    8022f5 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8022f0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022f5:	c9                   	leave  
  8022f6:	c3                   	ret    

008022f7 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8022f7:	55                   	push   %ebp
  8022f8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8022fa:	6a 00                	push   $0x0
  8022fc:	6a 00                	push   $0x0
  8022fe:	6a 00                	push   $0x0
  802300:	6a 00                	push   $0x0
  802302:	ff 75 08             	pushl  0x8(%ebp)
  802305:	6a 2d                	push   $0x2d
  802307:	e8 ea f9 ff ff       	call   801cf6 <syscall>
  80230c:	83 c4 18             	add    $0x18,%esp
	return ;
  80230f:	90                   	nop
}
  802310:	c9                   	leave  
  802311:	c3                   	ret    

00802312 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802312:	55                   	push   %ebp
  802313:	89 e5                	mov    %esp,%ebp
  802315:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802316:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802319:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80231c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80231f:	8b 45 08             	mov    0x8(%ebp),%eax
  802322:	6a 00                	push   $0x0
  802324:	53                   	push   %ebx
  802325:	51                   	push   %ecx
  802326:	52                   	push   %edx
  802327:	50                   	push   %eax
  802328:	6a 2e                	push   $0x2e
  80232a:	e8 c7 f9 ff ff       	call   801cf6 <syscall>
  80232f:	83 c4 18             	add    $0x18,%esp
}
  802332:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802335:	c9                   	leave  
  802336:	c3                   	ret    

00802337 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802337:	55                   	push   %ebp
  802338:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80233a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80233d:	8b 45 08             	mov    0x8(%ebp),%eax
  802340:	6a 00                	push   $0x0
  802342:	6a 00                	push   $0x0
  802344:	6a 00                	push   $0x0
  802346:	52                   	push   %edx
  802347:	50                   	push   %eax
  802348:	6a 2f                	push   $0x2f
  80234a:	e8 a7 f9 ff ff       	call   801cf6 <syscall>
  80234f:	83 c4 18             	add    $0x18,%esp
}
  802352:	c9                   	leave  
  802353:	c3                   	ret    

00802354 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802354:	55                   	push   %ebp
  802355:	89 e5                	mov    %esp,%ebp
  802357:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  80235a:	83 ec 0c             	sub    $0xc,%esp
  80235d:	68 0c 45 80 00       	push   $0x80450c
  802362:	e8 cd e6 ff ff       	call   800a34 <cprintf>
  802367:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80236a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802371:	83 ec 0c             	sub    $0xc,%esp
  802374:	68 38 45 80 00       	push   $0x804538
  802379:	e8 b6 e6 ff ff       	call   800a34 <cprintf>
  80237e:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802381:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802385:	a1 38 51 80 00       	mov    0x805138,%eax
  80238a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80238d:	eb 56                	jmp    8023e5 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80238f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802393:	74 1c                	je     8023b1 <print_mem_block_lists+0x5d>
  802395:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802398:	8b 50 08             	mov    0x8(%eax),%edx
  80239b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80239e:	8b 48 08             	mov    0x8(%eax),%ecx
  8023a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023a4:	8b 40 0c             	mov    0xc(%eax),%eax
  8023a7:	01 c8                	add    %ecx,%eax
  8023a9:	39 c2                	cmp    %eax,%edx
  8023ab:	73 04                	jae    8023b1 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8023ad:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8023b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b4:	8b 50 08             	mov    0x8(%eax),%edx
  8023b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ba:	8b 40 0c             	mov    0xc(%eax),%eax
  8023bd:	01 c2                	add    %eax,%edx
  8023bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c2:	8b 40 08             	mov    0x8(%eax),%eax
  8023c5:	83 ec 04             	sub    $0x4,%esp
  8023c8:	52                   	push   %edx
  8023c9:	50                   	push   %eax
  8023ca:	68 4d 45 80 00       	push   $0x80454d
  8023cf:	e8 60 e6 ff ff       	call   800a34 <cprintf>
  8023d4:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8023d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023da:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8023dd:	a1 40 51 80 00       	mov    0x805140,%eax
  8023e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023e9:	74 07                	je     8023f2 <print_mem_block_lists+0x9e>
  8023eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ee:	8b 00                	mov    (%eax),%eax
  8023f0:	eb 05                	jmp    8023f7 <print_mem_block_lists+0xa3>
  8023f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8023f7:	a3 40 51 80 00       	mov    %eax,0x805140
  8023fc:	a1 40 51 80 00       	mov    0x805140,%eax
  802401:	85 c0                	test   %eax,%eax
  802403:	75 8a                	jne    80238f <print_mem_block_lists+0x3b>
  802405:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802409:	75 84                	jne    80238f <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  80240b:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80240f:	75 10                	jne    802421 <print_mem_block_lists+0xcd>
  802411:	83 ec 0c             	sub    $0xc,%esp
  802414:	68 5c 45 80 00       	push   $0x80455c
  802419:	e8 16 e6 ff ff       	call   800a34 <cprintf>
  80241e:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802421:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802428:	83 ec 0c             	sub    $0xc,%esp
  80242b:	68 80 45 80 00       	push   $0x804580
  802430:	e8 ff e5 ff ff       	call   800a34 <cprintf>
  802435:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802438:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80243c:	a1 40 50 80 00       	mov    0x805040,%eax
  802441:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802444:	eb 56                	jmp    80249c <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802446:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80244a:	74 1c                	je     802468 <print_mem_block_lists+0x114>
  80244c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244f:	8b 50 08             	mov    0x8(%eax),%edx
  802452:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802455:	8b 48 08             	mov    0x8(%eax),%ecx
  802458:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80245b:	8b 40 0c             	mov    0xc(%eax),%eax
  80245e:	01 c8                	add    %ecx,%eax
  802460:	39 c2                	cmp    %eax,%edx
  802462:	73 04                	jae    802468 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802464:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802468:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246b:	8b 50 08             	mov    0x8(%eax),%edx
  80246e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802471:	8b 40 0c             	mov    0xc(%eax),%eax
  802474:	01 c2                	add    %eax,%edx
  802476:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802479:	8b 40 08             	mov    0x8(%eax),%eax
  80247c:	83 ec 04             	sub    $0x4,%esp
  80247f:	52                   	push   %edx
  802480:	50                   	push   %eax
  802481:	68 4d 45 80 00       	push   $0x80454d
  802486:	e8 a9 e5 ff ff       	call   800a34 <cprintf>
  80248b:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80248e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802491:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802494:	a1 48 50 80 00       	mov    0x805048,%eax
  802499:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80249c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024a0:	74 07                	je     8024a9 <print_mem_block_lists+0x155>
  8024a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a5:	8b 00                	mov    (%eax),%eax
  8024a7:	eb 05                	jmp    8024ae <print_mem_block_lists+0x15a>
  8024a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8024ae:	a3 48 50 80 00       	mov    %eax,0x805048
  8024b3:	a1 48 50 80 00       	mov    0x805048,%eax
  8024b8:	85 c0                	test   %eax,%eax
  8024ba:	75 8a                	jne    802446 <print_mem_block_lists+0xf2>
  8024bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024c0:	75 84                	jne    802446 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8024c2:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8024c6:	75 10                	jne    8024d8 <print_mem_block_lists+0x184>
  8024c8:	83 ec 0c             	sub    $0xc,%esp
  8024cb:	68 98 45 80 00       	push   $0x804598
  8024d0:	e8 5f e5 ff ff       	call   800a34 <cprintf>
  8024d5:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8024d8:	83 ec 0c             	sub    $0xc,%esp
  8024db:	68 0c 45 80 00       	push   $0x80450c
  8024e0:	e8 4f e5 ff ff       	call   800a34 <cprintf>
  8024e5:	83 c4 10             	add    $0x10,%esp

}
  8024e8:	90                   	nop
  8024e9:	c9                   	leave  
  8024ea:	c3                   	ret    

008024eb <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8024eb:	55                   	push   %ebp
  8024ec:	89 e5                	mov    %esp,%ebp
  8024ee:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  8024f1:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8024f8:	00 00 00 
  8024fb:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802502:	00 00 00 
  802505:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  80250c:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  80250f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802516:	e9 9e 00 00 00       	jmp    8025b9 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  80251b:	a1 50 50 80 00       	mov    0x805050,%eax
  802520:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802523:	c1 e2 04             	shl    $0x4,%edx
  802526:	01 d0                	add    %edx,%eax
  802528:	85 c0                	test   %eax,%eax
  80252a:	75 14                	jne    802540 <initialize_MemBlocksList+0x55>
  80252c:	83 ec 04             	sub    $0x4,%esp
  80252f:	68 c0 45 80 00       	push   $0x8045c0
  802534:	6a 46                	push   $0x46
  802536:	68 e3 45 80 00       	push   $0x8045e3
  80253b:	e8 40 e2 ff ff       	call   800780 <_panic>
  802540:	a1 50 50 80 00       	mov    0x805050,%eax
  802545:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802548:	c1 e2 04             	shl    $0x4,%edx
  80254b:	01 d0                	add    %edx,%eax
  80254d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802553:	89 10                	mov    %edx,(%eax)
  802555:	8b 00                	mov    (%eax),%eax
  802557:	85 c0                	test   %eax,%eax
  802559:	74 18                	je     802573 <initialize_MemBlocksList+0x88>
  80255b:	a1 48 51 80 00       	mov    0x805148,%eax
  802560:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802566:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802569:	c1 e1 04             	shl    $0x4,%ecx
  80256c:	01 ca                	add    %ecx,%edx
  80256e:	89 50 04             	mov    %edx,0x4(%eax)
  802571:	eb 12                	jmp    802585 <initialize_MemBlocksList+0x9a>
  802573:	a1 50 50 80 00       	mov    0x805050,%eax
  802578:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80257b:	c1 e2 04             	shl    $0x4,%edx
  80257e:	01 d0                	add    %edx,%eax
  802580:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802585:	a1 50 50 80 00       	mov    0x805050,%eax
  80258a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80258d:	c1 e2 04             	shl    $0x4,%edx
  802590:	01 d0                	add    %edx,%eax
  802592:	a3 48 51 80 00       	mov    %eax,0x805148
  802597:	a1 50 50 80 00       	mov    0x805050,%eax
  80259c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80259f:	c1 e2 04             	shl    $0x4,%edx
  8025a2:	01 d0                	add    %edx,%eax
  8025a4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025ab:	a1 54 51 80 00       	mov    0x805154,%eax
  8025b0:	40                   	inc    %eax
  8025b1:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  8025b6:	ff 45 f4             	incl   -0xc(%ebp)
  8025b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025bf:	0f 82 56 ff ff ff    	jb     80251b <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  8025c5:	90                   	nop
  8025c6:	c9                   	leave  
  8025c7:	c3                   	ret    

008025c8 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8025c8:	55                   	push   %ebp
  8025c9:	89 e5                	mov    %esp,%ebp
  8025cb:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8025ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d1:	8b 00                	mov    (%eax),%eax
  8025d3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8025d6:	eb 19                	jmp    8025f1 <find_block+0x29>
	{
		if(va==point->sva)
  8025d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025db:	8b 40 08             	mov    0x8(%eax),%eax
  8025de:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8025e1:	75 05                	jne    8025e8 <find_block+0x20>
		   return point;
  8025e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025e6:	eb 36                	jmp    80261e <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8025e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8025eb:	8b 40 08             	mov    0x8(%eax),%eax
  8025ee:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8025f1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8025f5:	74 07                	je     8025fe <find_block+0x36>
  8025f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025fa:	8b 00                	mov    (%eax),%eax
  8025fc:	eb 05                	jmp    802603 <find_block+0x3b>
  8025fe:	b8 00 00 00 00       	mov    $0x0,%eax
  802603:	8b 55 08             	mov    0x8(%ebp),%edx
  802606:	89 42 08             	mov    %eax,0x8(%edx)
  802609:	8b 45 08             	mov    0x8(%ebp),%eax
  80260c:	8b 40 08             	mov    0x8(%eax),%eax
  80260f:	85 c0                	test   %eax,%eax
  802611:	75 c5                	jne    8025d8 <find_block+0x10>
  802613:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802617:	75 bf                	jne    8025d8 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802619:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80261e:	c9                   	leave  
  80261f:	c3                   	ret    

00802620 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802620:	55                   	push   %ebp
  802621:	89 e5                	mov    %esp,%ebp
  802623:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802626:	a1 40 50 80 00       	mov    0x805040,%eax
  80262b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  80262e:	a1 44 50 80 00       	mov    0x805044,%eax
  802633:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802636:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802639:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80263c:	74 24                	je     802662 <insert_sorted_allocList+0x42>
  80263e:	8b 45 08             	mov    0x8(%ebp),%eax
  802641:	8b 50 08             	mov    0x8(%eax),%edx
  802644:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802647:	8b 40 08             	mov    0x8(%eax),%eax
  80264a:	39 c2                	cmp    %eax,%edx
  80264c:	76 14                	jbe    802662 <insert_sorted_allocList+0x42>
  80264e:	8b 45 08             	mov    0x8(%ebp),%eax
  802651:	8b 50 08             	mov    0x8(%eax),%edx
  802654:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802657:	8b 40 08             	mov    0x8(%eax),%eax
  80265a:	39 c2                	cmp    %eax,%edx
  80265c:	0f 82 60 01 00 00    	jb     8027c2 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802662:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802666:	75 65                	jne    8026cd <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802668:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80266c:	75 14                	jne    802682 <insert_sorted_allocList+0x62>
  80266e:	83 ec 04             	sub    $0x4,%esp
  802671:	68 c0 45 80 00       	push   $0x8045c0
  802676:	6a 6b                	push   $0x6b
  802678:	68 e3 45 80 00       	push   $0x8045e3
  80267d:	e8 fe e0 ff ff       	call   800780 <_panic>
  802682:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802688:	8b 45 08             	mov    0x8(%ebp),%eax
  80268b:	89 10                	mov    %edx,(%eax)
  80268d:	8b 45 08             	mov    0x8(%ebp),%eax
  802690:	8b 00                	mov    (%eax),%eax
  802692:	85 c0                	test   %eax,%eax
  802694:	74 0d                	je     8026a3 <insert_sorted_allocList+0x83>
  802696:	a1 40 50 80 00       	mov    0x805040,%eax
  80269b:	8b 55 08             	mov    0x8(%ebp),%edx
  80269e:	89 50 04             	mov    %edx,0x4(%eax)
  8026a1:	eb 08                	jmp    8026ab <insert_sorted_allocList+0x8b>
  8026a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a6:	a3 44 50 80 00       	mov    %eax,0x805044
  8026ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ae:	a3 40 50 80 00       	mov    %eax,0x805040
  8026b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026bd:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8026c2:	40                   	inc    %eax
  8026c3:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8026c8:	e9 dc 01 00 00       	jmp    8028a9 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8026cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d0:	8b 50 08             	mov    0x8(%eax),%edx
  8026d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026d6:	8b 40 08             	mov    0x8(%eax),%eax
  8026d9:	39 c2                	cmp    %eax,%edx
  8026db:	77 6c                	ja     802749 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8026dd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026e1:	74 06                	je     8026e9 <insert_sorted_allocList+0xc9>
  8026e3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8026e7:	75 14                	jne    8026fd <insert_sorted_allocList+0xdd>
  8026e9:	83 ec 04             	sub    $0x4,%esp
  8026ec:	68 fc 45 80 00       	push   $0x8045fc
  8026f1:	6a 6f                	push   $0x6f
  8026f3:	68 e3 45 80 00       	push   $0x8045e3
  8026f8:	e8 83 e0 ff ff       	call   800780 <_panic>
  8026fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802700:	8b 50 04             	mov    0x4(%eax),%edx
  802703:	8b 45 08             	mov    0x8(%ebp),%eax
  802706:	89 50 04             	mov    %edx,0x4(%eax)
  802709:	8b 45 08             	mov    0x8(%ebp),%eax
  80270c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80270f:	89 10                	mov    %edx,(%eax)
  802711:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802714:	8b 40 04             	mov    0x4(%eax),%eax
  802717:	85 c0                	test   %eax,%eax
  802719:	74 0d                	je     802728 <insert_sorted_allocList+0x108>
  80271b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80271e:	8b 40 04             	mov    0x4(%eax),%eax
  802721:	8b 55 08             	mov    0x8(%ebp),%edx
  802724:	89 10                	mov    %edx,(%eax)
  802726:	eb 08                	jmp    802730 <insert_sorted_allocList+0x110>
  802728:	8b 45 08             	mov    0x8(%ebp),%eax
  80272b:	a3 40 50 80 00       	mov    %eax,0x805040
  802730:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802733:	8b 55 08             	mov    0x8(%ebp),%edx
  802736:	89 50 04             	mov    %edx,0x4(%eax)
  802739:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80273e:	40                   	inc    %eax
  80273f:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802744:	e9 60 01 00 00       	jmp    8028a9 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802749:	8b 45 08             	mov    0x8(%ebp),%eax
  80274c:	8b 50 08             	mov    0x8(%eax),%edx
  80274f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802752:	8b 40 08             	mov    0x8(%eax),%eax
  802755:	39 c2                	cmp    %eax,%edx
  802757:	0f 82 4c 01 00 00    	jb     8028a9 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  80275d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802761:	75 14                	jne    802777 <insert_sorted_allocList+0x157>
  802763:	83 ec 04             	sub    $0x4,%esp
  802766:	68 34 46 80 00       	push   $0x804634
  80276b:	6a 73                	push   $0x73
  80276d:	68 e3 45 80 00       	push   $0x8045e3
  802772:	e8 09 e0 ff ff       	call   800780 <_panic>
  802777:	8b 15 44 50 80 00    	mov    0x805044,%edx
  80277d:	8b 45 08             	mov    0x8(%ebp),%eax
  802780:	89 50 04             	mov    %edx,0x4(%eax)
  802783:	8b 45 08             	mov    0x8(%ebp),%eax
  802786:	8b 40 04             	mov    0x4(%eax),%eax
  802789:	85 c0                	test   %eax,%eax
  80278b:	74 0c                	je     802799 <insert_sorted_allocList+0x179>
  80278d:	a1 44 50 80 00       	mov    0x805044,%eax
  802792:	8b 55 08             	mov    0x8(%ebp),%edx
  802795:	89 10                	mov    %edx,(%eax)
  802797:	eb 08                	jmp    8027a1 <insert_sorted_allocList+0x181>
  802799:	8b 45 08             	mov    0x8(%ebp),%eax
  80279c:	a3 40 50 80 00       	mov    %eax,0x805040
  8027a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a4:	a3 44 50 80 00       	mov    %eax,0x805044
  8027a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027b2:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8027b7:	40                   	inc    %eax
  8027b8:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8027bd:	e9 e7 00 00 00       	jmp    8028a9 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8027c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8027c8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8027cf:	a1 40 50 80 00       	mov    0x805040,%eax
  8027d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027d7:	e9 9d 00 00 00       	jmp    802879 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8027dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027df:	8b 00                	mov    (%eax),%eax
  8027e1:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8027e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e7:	8b 50 08             	mov    0x8(%eax),%edx
  8027ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ed:	8b 40 08             	mov    0x8(%eax),%eax
  8027f0:	39 c2                	cmp    %eax,%edx
  8027f2:	76 7d                	jbe    802871 <insert_sorted_allocList+0x251>
  8027f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f7:	8b 50 08             	mov    0x8(%eax),%edx
  8027fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027fd:	8b 40 08             	mov    0x8(%eax),%eax
  802800:	39 c2                	cmp    %eax,%edx
  802802:	73 6d                	jae    802871 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802804:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802808:	74 06                	je     802810 <insert_sorted_allocList+0x1f0>
  80280a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80280e:	75 14                	jne    802824 <insert_sorted_allocList+0x204>
  802810:	83 ec 04             	sub    $0x4,%esp
  802813:	68 58 46 80 00       	push   $0x804658
  802818:	6a 7f                	push   $0x7f
  80281a:	68 e3 45 80 00       	push   $0x8045e3
  80281f:	e8 5c df ff ff       	call   800780 <_panic>
  802824:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802827:	8b 10                	mov    (%eax),%edx
  802829:	8b 45 08             	mov    0x8(%ebp),%eax
  80282c:	89 10                	mov    %edx,(%eax)
  80282e:	8b 45 08             	mov    0x8(%ebp),%eax
  802831:	8b 00                	mov    (%eax),%eax
  802833:	85 c0                	test   %eax,%eax
  802835:	74 0b                	je     802842 <insert_sorted_allocList+0x222>
  802837:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283a:	8b 00                	mov    (%eax),%eax
  80283c:	8b 55 08             	mov    0x8(%ebp),%edx
  80283f:	89 50 04             	mov    %edx,0x4(%eax)
  802842:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802845:	8b 55 08             	mov    0x8(%ebp),%edx
  802848:	89 10                	mov    %edx,(%eax)
  80284a:	8b 45 08             	mov    0x8(%ebp),%eax
  80284d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802850:	89 50 04             	mov    %edx,0x4(%eax)
  802853:	8b 45 08             	mov    0x8(%ebp),%eax
  802856:	8b 00                	mov    (%eax),%eax
  802858:	85 c0                	test   %eax,%eax
  80285a:	75 08                	jne    802864 <insert_sorted_allocList+0x244>
  80285c:	8b 45 08             	mov    0x8(%ebp),%eax
  80285f:	a3 44 50 80 00       	mov    %eax,0x805044
  802864:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802869:	40                   	inc    %eax
  80286a:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  80286f:	eb 39                	jmp    8028aa <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802871:	a1 48 50 80 00       	mov    0x805048,%eax
  802876:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802879:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80287d:	74 07                	je     802886 <insert_sorted_allocList+0x266>
  80287f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802882:	8b 00                	mov    (%eax),%eax
  802884:	eb 05                	jmp    80288b <insert_sorted_allocList+0x26b>
  802886:	b8 00 00 00 00       	mov    $0x0,%eax
  80288b:	a3 48 50 80 00       	mov    %eax,0x805048
  802890:	a1 48 50 80 00       	mov    0x805048,%eax
  802895:	85 c0                	test   %eax,%eax
  802897:	0f 85 3f ff ff ff    	jne    8027dc <insert_sorted_allocList+0x1bc>
  80289d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028a1:	0f 85 35 ff ff ff    	jne    8027dc <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8028a7:	eb 01                	jmp    8028aa <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8028a9:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8028aa:	90                   	nop
  8028ab:	c9                   	leave  
  8028ac:	c3                   	ret    

008028ad <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8028ad:	55                   	push   %ebp
  8028ae:	89 e5                	mov    %esp,%ebp
  8028b0:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8028b3:	a1 38 51 80 00       	mov    0x805138,%eax
  8028b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028bb:	e9 85 01 00 00       	jmp    802a45 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8028c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c3:	8b 40 0c             	mov    0xc(%eax),%eax
  8028c6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028c9:	0f 82 6e 01 00 00    	jb     802a3d <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8028cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d2:	8b 40 0c             	mov    0xc(%eax),%eax
  8028d5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028d8:	0f 85 8a 00 00 00    	jne    802968 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8028de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028e2:	75 17                	jne    8028fb <alloc_block_FF+0x4e>
  8028e4:	83 ec 04             	sub    $0x4,%esp
  8028e7:	68 8c 46 80 00       	push   $0x80468c
  8028ec:	68 93 00 00 00       	push   $0x93
  8028f1:	68 e3 45 80 00       	push   $0x8045e3
  8028f6:	e8 85 de ff ff       	call   800780 <_panic>
  8028fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fe:	8b 00                	mov    (%eax),%eax
  802900:	85 c0                	test   %eax,%eax
  802902:	74 10                	je     802914 <alloc_block_FF+0x67>
  802904:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802907:	8b 00                	mov    (%eax),%eax
  802909:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80290c:	8b 52 04             	mov    0x4(%edx),%edx
  80290f:	89 50 04             	mov    %edx,0x4(%eax)
  802912:	eb 0b                	jmp    80291f <alloc_block_FF+0x72>
  802914:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802917:	8b 40 04             	mov    0x4(%eax),%eax
  80291a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80291f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802922:	8b 40 04             	mov    0x4(%eax),%eax
  802925:	85 c0                	test   %eax,%eax
  802927:	74 0f                	je     802938 <alloc_block_FF+0x8b>
  802929:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292c:	8b 40 04             	mov    0x4(%eax),%eax
  80292f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802932:	8b 12                	mov    (%edx),%edx
  802934:	89 10                	mov    %edx,(%eax)
  802936:	eb 0a                	jmp    802942 <alloc_block_FF+0x95>
  802938:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293b:	8b 00                	mov    (%eax),%eax
  80293d:	a3 38 51 80 00       	mov    %eax,0x805138
  802942:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802945:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80294b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802955:	a1 44 51 80 00       	mov    0x805144,%eax
  80295a:	48                   	dec    %eax
  80295b:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802960:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802963:	e9 10 01 00 00       	jmp    802a78 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802968:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296b:	8b 40 0c             	mov    0xc(%eax),%eax
  80296e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802971:	0f 86 c6 00 00 00    	jbe    802a3d <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802977:	a1 48 51 80 00       	mov    0x805148,%eax
  80297c:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  80297f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802982:	8b 50 08             	mov    0x8(%eax),%edx
  802985:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802988:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  80298b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80298e:	8b 55 08             	mov    0x8(%ebp),%edx
  802991:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802994:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802998:	75 17                	jne    8029b1 <alloc_block_FF+0x104>
  80299a:	83 ec 04             	sub    $0x4,%esp
  80299d:	68 8c 46 80 00       	push   $0x80468c
  8029a2:	68 9b 00 00 00       	push   $0x9b
  8029a7:	68 e3 45 80 00       	push   $0x8045e3
  8029ac:	e8 cf dd ff ff       	call   800780 <_panic>
  8029b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029b4:	8b 00                	mov    (%eax),%eax
  8029b6:	85 c0                	test   %eax,%eax
  8029b8:	74 10                	je     8029ca <alloc_block_FF+0x11d>
  8029ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029bd:	8b 00                	mov    (%eax),%eax
  8029bf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029c2:	8b 52 04             	mov    0x4(%edx),%edx
  8029c5:	89 50 04             	mov    %edx,0x4(%eax)
  8029c8:	eb 0b                	jmp    8029d5 <alloc_block_FF+0x128>
  8029ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029cd:	8b 40 04             	mov    0x4(%eax),%eax
  8029d0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8029d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029d8:	8b 40 04             	mov    0x4(%eax),%eax
  8029db:	85 c0                	test   %eax,%eax
  8029dd:	74 0f                	je     8029ee <alloc_block_FF+0x141>
  8029df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029e2:	8b 40 04             	mov    0x4(%eax),%eax
  8029e5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029e8:	8b 12                	mov    (%edx),%edx
  8029ea:	89 10                	mov    %edx,(%eax)
  8029ec:	eb 0a                	jmp    8029f8 <alloc_block_FF+0x14b>
  8029ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f1:	8b 00                	mov    (%eax),%eax
  8029f3:	a3 48 51 80 00       	mov    %eax,0x805148
  8029f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029fb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a04:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a0b:	a1 54 51 80 00       	mov    0x805154,%eax
  802a10:	48                   	dec    %eax
  802a11:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802a16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a19:	8b 50 08             	mov    0x8(%eax),%edx
  802a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a1f:	01 c2                	add    %eax,%edx
  802a21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a24:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802a27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2a:	8b 40 0c             	mov    0xc(%eax),%eax
  802a2d:	2b 45 08             	sub    0x8(%ebp),%eax
  802a30:	89 c2                	mov    %eax,%edx
  802a32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a35:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802a38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a3b:	eb 3b                	jmp    802a78 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802a3d:	a1 40 51 80 00       	mov    0x805140,%eax
  802a42:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a45:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a49:	74 07                	je     802a52 <alloc_block_FF+0x1a5>
  802a4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4e:	8b 00                	mov    (%eax),%eax
  802a50:	eb 05                	jmp    802a57 <alloc_block_FF+0x1aa>
  802a52:	b8 00 00 00 00       	mov    $0x0,%eax
  802a57:	a3 40 51 80 00       	mov    %eax,0x805140
  802a5c:	a1 40 51 80 00       	mov    0x805140,%eax
  802a61:	85 c0                	test   %eax,%eax
  802a63:	0f 85 57 fe ff ff    	jne    8028c0 <alloc_block_FF+0x13>
  802a69:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a6d:	0f 85 4d fe ff ff    	jne    8028c0 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802a73:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a78:	c9                   	leave  
  802a79:	c3                   	ret    

00802a7a <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802a7a:	55                   	push   %ebp
  802a7b:	89 e5                	mov    %esp,%ebp
  802a7d:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802a80:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802a87:	a1 38 51 80 00       	mov    0x805138,%eax
  802a8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a8f:	e9 df 00 00 00       	jmp    802b73 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802a94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a97:	8b 40 0c             	mov    0xc(%eax),%eax
  802a9a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a9d:	0f 82 c8 00 00 00    	jb     802b6b <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802aa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa6:	8b 40 0c             	mov    0xc(%eax),%eax
  802aa9:	3b 45 08             	cmp    0x8(%ebp),%eax
  802aac:	0f 85 8a 00 00 00    	jne    802b3c <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802ab2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ab6:	75 17                	jne    802acf <alloc_block_BF+0x55>
  802ab8:	83 ec 04             	sub    $0x4,%esp
  802abb:	68 8c 46 80 00       	push   $0x80468c
  802ac0:	68 b7 00 00 00       	push   $0xb7
  802ac5:	68 e3 45 80 00       	push   $0x8045e3
  802aca:	e8 b1 dc ff ff       	call   800780 <_panic>
  802acf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad2:	8b 00                	mov    (%eax),%eax
  802ad4:	85 c0                	test   %eax,%eax
  802ad6:	74 10                	je     802ae8 <alloc_block_BF+0x6e>
  802ad8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802adb:	8b 00                	mov    (%eax),%eax
  802add:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ae0:	8b 52 04             	mov    0x4(%edx),%edx
  802ae3:	89 50 04             	mov    %edx,0x4(%eax)
  802ae6:	eb 0b                	jmp    802af3 <alloc_block_BF+0x79>
  802ae8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aeb:	8b 40 04             	mov    0x4(%eax),%eax
  802aee:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802af3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af6:	8b 40 04             	mov    0x4(%eax),%eax
  802af9:	85 c0                	test   %eax,%eax
  802afb:	74 0f                	je     802b0c <alloc_block_BF+0x92>
  802afd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b00:	8b 40 04             	mov    0x4(%eax),%eax
  802b03:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b06:	8b 12                	mov    (%edx),%edx
  802b08:	89 10                	mov    %edx,(%eax)
  802b0a:	eb 0a                	jmp    802b16 <alloc_block_BF+0x9c>
  802b0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0f:	8b 00                	mov    (%eax),%eax
  802b11:	a3 38 51 80 00       	mov    %eax,0x805138
  802b16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b19:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b22:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b29:	a1 44 51 80 00       	mov    0x805144,%eax
  802b2e:	48                   	dec    %eax
  802b2f:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802b34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b37:	e9 4d 01 00 00       	jmp    802c89 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802b3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3f:	8b 40 0c             	mov    0xc(%eax),%eax
  802b42:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b45:	76 24                	jbe    802b6b <alloc_block_BF+0xf1>
  802b47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4a:	8b 40 0c             	mov    0xc(%eax),%eax
  802b4d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802b50:	73 19                	jae    802b6b <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802b52:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802b59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5c:	8b 40 0c             	mov    0xc(%eax),%eax
  802b5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802b62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b65:	8b 40 08             	mov    0x8(%eax),%eax
  802b68:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802b6b:	a1 40 51 80 00       	mov    0x805140,%eax
  802b70:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b73:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b77:	74 07                	je     802b80 <alloc_block_BF+0x106>
  802b79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7c:	8b 00                	mov    (%eax),%eax
  802b7e:	eb 05                	jmp    802b85 <alloc_block_BF+0x10b>
  802b80:	b8 00 00 00 00       	mov    $0x0,%eax
  802b85:	a3 40 51 80 00       	mov    %eax,0x805140
  802b8a:	a1 40 51 80 00       	mov    0x805140,%eax
  802b8f:	85 c0                	test   %eax,%eax
  802b91:	0f 85 fd fe ff ff    	jne    802a94 <alloc_block_BF+0x1a>
  802b97:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b9b:	0f 85 f3 fe ff ff    	jne    802a94 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802ba1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ba5:	0f 84 d9 00 00 00    	je     802c84 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802bab:	a1 48 51 80 00       	mov    0x805148,%eax
  802bb0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802bb3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bb6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802bb9:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802bbc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bbf:	8b 55 08             	mov    0x8(%ebp),%edx
  802bc2:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802bc5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802bc9:	75 17                	jne    802be2 <alloc_block_BF+0x168>
  802bcb:	83 ec 04             	sub    $0x4,%esp
  802bce:	68 8c 46 80 00       	push   $0x80468c
  802bd3:	68 c7 00 00 00       	push   $0xc7
  802bd8:	68 e3 45 80 00       	push   $0x8045e3
  802bdd:	e8 9e db ff ff       	call   800780 <_panic>
  802be2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802be5:	8b 00                	mov    (%eax),%eax
  802be7:	85 c0                	test   %eax,%eax
  802be9:	74 10                	je     802bfb <alloc_block_BF+0x181>
  802beb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bee:	8b 00                	mov    (%eax),%eax
  802bf0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802bf3:	8b 52 04             	mov    0x4(%edx),%edx
  802bf6:	89 50 04             	mov    %edx,0x4(%eax)
  802bf9:	eb 0b                	jmp    802c06 <alloc_block_BF+0x18c>
  802bfb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bfe:	8b 40 04             	mov    0x4(%eax),%eax
  802c01:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c06:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c09:	8b 40 04             	mov    0x4(%eax),%eax
  802c0c:	85 c0                	test   %eax,%eax
  802c0e:	74 0f                	je     802c1f <alloc_block_BF+0x1a5>
  802c10:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c13:	8b 40 04             	mov    0x4(%eax),%eax
  802c16:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c19:	8b 12                	mov    (%edx),%edx
  802c1b:	89 10                	mov    %edx,(%eax)
  802c1d:	eb 0a                	jmp    802c29 <alloc_block_BF+0x1af>
  802c1f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c22:	8b 00                	mov    (%eax),%eax
  802c24:	a3 48 51 80 00       	mov    %eax,0x805148
  802c29:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c2c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c35:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c3c:	a1 54 51 80 00       	mov    0x805154,%eax
  802c41:	48                   	dec    %eax
  802c42:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802c47:	83 ec 08             	sub    $0x8,%esp
  802c4a:	ff 75 ec             	pushl  -0x14(%ebp)
  802c4d:	68 38 51 80 00       	push   $0x805138
  802c52:	e8 71 f9 ff ff       	call   8025c8 <find_block>
  802c57:	83 c4 10             	add    $0x10,%esp
  802c5a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802c5d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c60:	8b 50 08             	mov    0x8(%eax),%edx
  802c63:	8b 45 08             	mov    0x8(%ebp),%eax
  802c66:	01 c2                	add    %eax,%edx
  802c68:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c6b:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802c6e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c71:	8b 40 0c             	mov    0xc(%eax),%eax
  802c74:	2b 45 08             	sub    0x8(%ebp),%eax
  802c77:	89 c2                	mov    %eax,%edx
  802c79:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c7c:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802c7f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c82:	eb 05                	jmp    802c89 <alloc_block_BF+0x20f>
	}
	return NULL;
  802c84:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c89:	c9                   	leave  
  802c8a:	c3                   	ret    

00802c8b <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802c8b:	55                   	push   %ebp
  802c8c:	89 e5                	mov    %esp,%ebp
  802c8e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802c91:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802c96:	85 c0                	test   %eax,%eax
  802c98:	0f 85 de 01 00 00    	jne    802e7c <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802c9e:	a1 38 51 80 00       	mov    0x805138,%eax
  802ca3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ca6:	e9 9e 01 00 00       	jmp    802e49 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802cab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cae:	8b 40 0c             	mov    0xc(%eax),%eax
  802cb1:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cb4:	0f 82 87 01 00 00    	jb     802e41 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802cba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbd:	8b 40 0c             	mov    0xc(%eax),%eax
  802cc0:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cc3:	0f 85 95 00 00 00    	jne    802d5e <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802cc9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ccd:	75 17                	jne    802ce6 <alloc_block_NF+0x5b>
  802ccf:	83 ec 04             	sub    $0x4,%esp
  802cd2:	68 8c 46 80 00       	push   $0x80468c
  802cd7:	68 e0 00 00 00       	push   $0xe0
  802cdc:	68 e3 45 80 00       	push   $0x8045e3
  802ce1:	e8 9a da ff ff       	call   800780 <_panic>
  802ce6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce9:	8b 00                	mov    (%eax),%eax
  802ceb:	85 c0                	test   %eax,%eax
  802ced:	74 10                	je     802cff <alloc_block_NF+0x74>
  802cef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf2:	8b 00                	mov    (%eax),%eax
  802cf4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cf7:	8b 52 04             	mov    0x4(%edx),%edx
  802cfa:	89 50 04             	mov    %edx,0x4(%eax)
  802cfd:	eb 0b                	jmp    802d0a <alloc_block_NF+0x7f>
  802cff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d02:	8b 40 04             	mov    0x4(%eax),%eax
  802d05:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0d:	8b 40 04             	mov    0x4(%eax),%eax
  802d10:	85 c0                	test   %eax,%eax
  802d12:	74 0f                	je     802d23 <alloc_block_NF+0x98>
  802d14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d17:	8b 40 04             	mov    0x4(%eax),%eax
  802d1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d1d:	8b 12                	mov    (%edx),%edx
  802d1f:	89 10                	mov    %edx,(%eax)
  802d21:	eb 0a                	jmp    802d2d <alloc_block_NF+0xa2>
  802d23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d26:	8b 00                	mov    (%eax),%eax
  802d28:	a3 38 51 80 00       	mov    %eax,0x805138
  802d2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d30:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d39:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d40:	a1 44 51 80 00       	mov    0x805144,%eax
  802d45:	48                   	dec    %eax
  802d46:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802d4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4e:	8b 40 08             	mov    0x8(%eax),%eax
  802d51:	a3 2c 50 80 00       	mov    %eax,0x80502c
				   return  point;
  802d56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d59:	e9 f8 04 00 00       	jmp    803256 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802d5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d61:	8b 40 0c             	mov    0xc(%eax),%eax
  802d64:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d67:	0f 86 d4 00 00 00    	jbe    802e41 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802d6d:	a1 48 51 80 00       	mov    0x805148,%eax
  802d72:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802d75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d78:	8b 50 08             	mov    0x8(%eax),%edx
  802d7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d7e:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802d81:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d84:	8b 55 08             	mov    0x8(%ebp),%edx
  802d87:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802d8a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d8e:	75 17                	jne    802da7 <alloc_block_NF+0x11c>
  802d90:	83 ec 04             	sub    $0x4,%esp
  802d93:	68 8c 46 80 00       	push   $0x80468c
  802d98:	68 e9 00 00 00       	push   $0xe9
  802d9d:	68 e3 45 80 00       	push   $0x8045e3
  802da2:	e8 d9 d9 ff ff       	call   800780 <_panic>
  802da7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802daa:	8b 00                	mov    (%eax),%eax
  802dac:	85 c0                	test   %eax,%eax
  802dae:	74 10                	je     802dc0 <alloc_block_NF+0x135>
  802db0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802db3:	8b 00                	mov    (%eax),%eax
  802db5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802db8:	8b 52 04             	mov    0x4(%edx),%edx
  802dbb:	89 50 04             	mov    %edx,0x4(%eax)
  802dbe:	eb 0b                	jmp    802dcb <alloc_block_NF+0x140>
  802dc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc3:	8b 40 04             	mov    0x4(%eax),%eax
  802dc6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802dcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dce:	8b 40 04             	mov    0x4(%eax),%eax
  802dd1:	85 c0                	test   %eax,%eax
  802dd3:	74 0f                	je     802de4 <alloc_block_NF+0x159>
  802dd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dd8:	8b 40 04             	mov    0x4(%eax),%eax
  802ddb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802dde:	8b 12                	mov    (%edx),%edx
  802de0:	89 10                	mov    %edx,(%eax)
  802de2:	eb 0a                	jmp    802dee <alloc_block_NF+0x163>
  802de4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de7:	8b 00                	mov    (%eax),%eax
  802de9:	a3 48 51 80 00       	mov    %eax,0x805148
  802dee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802df1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802df7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dfa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e01:	a1 54 51 80 00       	mov    0x805154,%eax
  802e06:	48                   	dec    %eax
  802e07:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802e0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e0f:	8b 40 08             	mov    0x8(%eax),%eax
  802e12:	a3 2c 50 80 00       	mov    %eax,0x80502c
				   point->sva += size;
  802e17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1a:	8b 50 08             	mov    0x8(%eax),%edx
  802e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e20:	01 c2                	add    %eax,%edx
  802e22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e25:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802e28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2b:	8b 40 0c             	mov    0xc(%eax),%eax
  802e2e:	2b 45 08             	sub    0x8(%ebp),%eax
  802e31:	89 c2                	mov    %eax,%edx
  802e33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e36:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802e39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e3c:	e9 15 04 00 00       	jmp    803256 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802e41:	a1 40 51 80 00       	mov    0x805140,%eax
  802e46:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e49:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e4d:	74 07                	je     802e56 <alloc_block_NF+0x1cb>
  802e4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e52:	8b 00                	mov    (%eax),%eax
  802e54:	eb 05                	jmp    802e5b <alloc_block_NF+0x1d0>
  802e56:	b8 00 00 00 00       	mov    $0x0,%eax
  802e5b:	a3 40 51 80 00       	mov    %eax,0x805140
  802e60:	a1 40 51 80 00       	mov    0x805140,%eax
  802e65:	85 c0                	test   %eax,%eax
  802e67:	0f 85 3e fe ff ff    	jne    802cab <alloc_block_NF+0x20>
  802e6d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e71:	0f 85 34 fe ff ff    	jne    802cab <alloc_block_NF+0x20>
  802e77:	e9 d5 03 00 00       	jmp    803251 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802e7c:	a1 38 51 80 00       	mov    0x805138,%eax
  802e81:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e84:	e9 b1 01 00 00       	jmp    80303a <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802e89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8c:	8b 50 08             	mov    0x8(%eax),%edx
  802e8f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802e94:	39 c2                	cmp    %eax,%edx
  802e96:	0f 82 96 01 00 00    	jb     803032 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802e9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9f:	8b 40 0c             	mov    0xc(%eax),%eax
  802ea2:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ea5:	0f 82 87 01 00 00    	jb     803032 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802eab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eae:	8b 40 0c             	mov    0xc(%eax),%eax
  802eb1:	3b 45 08             	cmp    0x8(%ebp),%eax
  802eb4:	0f 85 95 00 00 00    	jne    802f4f <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802eba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ebe:	75 17                	jne    802ed7 <alloc_block_NF+0x24c>
  802ec0:	83 ec 04             	sub    $0x4,%esp
  802ec3:	68 8c 46 80 00       	push   $0x80468c
  802ec8:	68 fc 00 00 00       	push   $0xfc
  802ecd:	68 e3 45 80 00       	push   $0x8045e3
  802ed2:	e8 a9 d8 ff ff       	call   800780 <_panic>
  802ed7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eda:	8b 00                	mov    (%eax),%eax
  802edc:	85 c0                	test   %eax,%eax
  802ede:	74 10                	je     802ef0 <alloc_block_NF+0x265>
  802ee0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee3:	8b 00                	mov    (%eax),%eax
  802ee5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ee8:	8b 52 04             	mov    0x4(%edx),%edx
  802eeb:	89 50 04             	mov    %edx,0x4(%eax)
  802eee:	eb 0b                	jmp    802efb <alloc_block_NF+0x270>
  802ef0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef3:	8b 40 04             	mov    0x4(%eax),%eax
  802ef6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802efb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802efe:	8b 40 04             	mov    0x4(%eax),%eax
  802f01:	85 c0                	test   %eax,%eax
  802f03:	74 0f                	je     802f14 <alloc_block_NF+0x289>
  802f05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f08:	8b 40 04             	mov    0x4(%eax),%eax
  802f0b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f0e:	8b 12                	mov    (%edx),%edx
  802f10:	89 10                	mov    %edx,(%eax)
  802f12:	eb 0a                	jmp    802f1e <alloc_block_NF+0x293>
  802f14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f17:	8b 00                	mov    (%eax),%eax
  802f19:	a3 38 51 80 00       	mov    %eax,0x805138
  802f1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f21:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f31:	a1 44 51 80 00       	mov    0x805144,%eax
  802f36:	48                   	dec    %eax
  802f37:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802f3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3f:	8b 40 08             	mov    0x8(%eax),%eax
  802f42:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   return  point;
  802f47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4a:	e9 07 03 00 00       	jmp    803256 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802f4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f52:	8b 40 0c             	mov    0xc(%eax),%eax
  802f55:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f58:	0f 86 d4 00 00 00    	jbe    803032 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802f5e:	a1 48 51 80 00       	mov    0x805148,%eax
  802f63:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802f66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f69:	8b 50 08             	mov    0x8(%eax),%edx
  802f6c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f6f:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802f72:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f75:	8b 55 08             	mov    0x8(%ebp),%edx
  802f78:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802f7b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f7f:	75 17                	jne    802f98 <alloc_block_NF+0x30d>
  802f81:	83 ec 04             	sub    $0x4,%esp
  802f84:	68 8c 46 80 00       	push   $0x80468c
  802f89:	68 04 01 00 00       	push   $0x104
  802f8e:	68 e3 45 80 00       	push   $0x8045e3
  802f93:	e8 e8 d7 ff ff       	call   800780 <_panic>
  802f98:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f9b:	8b 00                	mov    (%eax),%eax
  802f9d:	85 c0                	test   %eax,%eax
  802f9f:	74 10                	je     802fb1 <alloc_block_NF+0x326>
  802fa1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fa4:	8b 00                	mov    (%eax),%eax
  802fa6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fa9:	8b 52 04             	mov    0x4(%edx),%edx
  802fac:	89 50 04             	mov    %edx,0x4(%eax)
  802faf:	eb 0b                	jmp    802fbc <alloc_block_NF+0x331>
  802fb1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fb4:	8b 40 04             	mov    0x4(%eax),%eax
  802fb7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802fbc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fbf:	8b 40 04             	mov    0x4(%eax),%eax
  802fc2:	85 c0                	test   %eax,%eax
  802fc4:	74 0f                	je     802fd5 <alloc_block_NF+0x34a>
  802fc6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fc9:	8b 40 04             	mov    0x4(%eax),%eax
  802fcc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fcf:	8b 12                	mov    (%edx),%edx
  802fd1:	89 10                	mov    %edx,(%eax)
  802fd3:	eb 0a                	jmp    802fdf <alloc_block_NF+0x354>
  802fd5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fd8:	8b 00                	mov    (%eax),%eax
  802fda:	a3 48 51 80 00       	mov    %eax,0x805148
  802fdf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fe2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fe8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802feb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ff2:	a1 54 51 80 00       	mov    0x805154,%eax
  802ff7:	48                   	dec    %eax
  802ff8:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802ffd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803000:	8b 40 08             	mov    0x8(%eax),%eax
  803003:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   point->sva += size;
  803008:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80300b:	8b 50 08             	mov    0x8(%eax),%edx
  80300e:	8b 45 08             	mov    0x8(%ebp),%eax
  803011:	01 c2                	add    %eax,%edx
  803013:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803016:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803019:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80301c:	8b 40 0c             	mov    0xc(%eax),%eax
  80301f:	2b 45 08             	sub    0x8(%ebp),%eax
  803022:	89 c2                	mov    %eax,%edx
  803024:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803027:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  80302a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80302d:	e9 24 02 00 00       	jmp    803256 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  803032:	a1 40 51 80 00       	mov    0x805140,%eax
  803037:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80303a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80303e:	74 07                	je     803047 <alloc_block_NF+0x3bc>
  803040:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803043:	8b 00                	mov    (%eax),%eax
  803045:	eb 05                	jmp    80304c <alloc_block_NF+0x3c1>
  803047:	b8 00 00 00 00       	mov    $0x0,%eax
  80304c:	a3 40 51 80 00       	mov    %eax,0x805140
  803051:	a1 40 51 80 00       	mov    0x805140,%eax
  803056:	85 c0                	test   %eax,%eax
  803058:	0f 85 2b fe ff ff    	jne    802e89 <alloc_block_NF+0x1fe>
  80305e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803062:	0f 85 21 fe ff ff    	jne    802e89 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803068:	a1 38 51 80 00       	mov    0x805138,%eax
  80306d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803070:	e9 ae 01 00 00       	jmp    803223 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  803075:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803078:	8b 50 08             	mov    0x8(%eax),%edx
  80307b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803080:	39 c2                	cmp    %eax,%edx
  803082:	0f 83 93 01 00 00    	jae    80321b <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  803088:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80308b:	8b 40 0c             	mov    0xc(%eax),%eax
  80308e:	3b 45 08             	cmp    0x8(%ebp),%eax
  803091:	0f 82 84 01 00 00    	jb     80321b <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  803097:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80309a:	8b 40 0c             	mov    0xc(%eax),%eax
  80309d:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030a0:	0f 85 95 00 00 00    	jne    80313b <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8030a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030aa:	75 17                	jne    8030c3 <alloc_block_NF+0x438>
  8030ac:	83 ec 04             	sub    $0x4,%esp
  8030af:	68 8c 46 80 00       	push   $0x80468c
  8030b4:	68 14 01 00 00       	push   $0x114
  8030b9:	68 e3 45 80 00       	push   $0x8045e3
  8030be:	e8 bd d6 ff ff       	call   800780 <_panic>
  8030c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c6:	8b 00                	mov    (%eax),%eax
  8030c8:	85 c0                	test   %eax,%eax
  8030ca:	74 10                	je     8030dc <alloc_block_NF+0x451>
  8030cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030cf:	8b 00                	mov    (%eax),%eax
  8030d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030d4:	8b 52 04             	mov    0x4(%edx),%edx
  8030d7:	89 50 04             	mov    %edx,0x4(%eax)
  8030da:	eb 0b                	jmp    8030e7 <alloc_block_NF+0x45c>
  8030dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030df:	8b 40 04             	mov    0x4(%eax),%eax
  8030e2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ea:	8b 40 04             	mov    0x4(%eax),%eax
  8030ed:	85 c0                	test   %eax,%eax
  8030ef:	74 0f                	je     803100 <alloc_block_NF+0x475>
  8030f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f4:	8b 40 04             	mov    0x4(%eax),%eax
  8030f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030fa:	8b 12                	mov    (%edx),%edx
  8030fc:	89 10                	mov    %edx,(%eax)
  8030fe:	eb 0a                	jmp    80310a <alloc_block_NF+0x47f>
  803100:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803103:	8b 00                	mov    (%eax),%eax
  803105:	a3 38 51 80 00       	mov    %eax,0x805138
  80310a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80310d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803113:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803116:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80311d:	a1 44 51 80 00       	mov    0x805144,%eax
  803122:	48                   	dec    %eax
  803123:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  803128:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80312b:	8b 40 08             	mov    0x8(%eax),%eax
  80312e:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   return  point;
  803133:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803136:	e9 1b 01 00 00       	jmp    803256 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  80313b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80313e:	8b 40 0c             	mov    0xc(%eax),%eax
  803141:	3b 45 08             	cmp    0x8(%ebp),%eax
  803144:	0f 86 d1 00 00 00    	jbe    80321b <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80314a:	a1 48 51 80 00       	mov    0x805148,%eax
  80314f:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  803152:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803155:	8b 50 08             	mov    0x8(%eax),%edx
  803158:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80315b:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  80315e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803161:	8b 55 08             	mov    0x8(%ebp),%edx
  803164:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803167:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80316b:	75 17                	jne    803184 <alloc_block_NF+0x4f9>
  80316d:	83 ec 04             	sub    $0x4,%esp
  803170:	68 8c 46 80 00       	push   $0x80468c
  803175:	68 1c 01 00 00       	push   $0x11c
  80317a:	68 e3 45 80 00       	push   $0x8045e3
  80317f:	e8 fc d5 ff ff       	call   800780 <_panic>
  803184:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803187:	8b 00                	mov    (%eax),%eax
  803189:	85 c0                	test   %eax,%eax
  80318b:	74 10                	je     80319d <alloc_block_NF+0x512>
  80318d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803190:	8b 00                	mov    (%eax),%eax
  803192:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803195:	8b 52 04             	mov    0x4(%edx),%edx
  803198:	89 50 04             	mov    %edx,0x4(%eax)
  80319b:	eb 0b                	jmp    8031a8 <alloc_block_NF+0x51d>
  80319d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031a0:	8b 40 04             	mov    0x4(%eax),%eax
  8031a3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031ab:	8b 40 04             	mov    0x4(%eax),%eax
  8031ae:	85 c0                	test   %eax,%eax
  8031b0:	74 0f                	je     8031c1 <alloc_block_NF+0x536>
  8031b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031b5:	8b 40 04             	mov    0x4(%eax),%eax
  8031b8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8031bb:	8b 12                	mov    (%edx),%edx
  8031bd:	89 10                	mov    %edx,(%eax)
  8031bf:	eb 0a                	jmp    8031cb <alloc_block_NF+0x540>
  8031c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031c4:	8b 00                	mov    (%eax),%eax
  8031c6:	a3 48 51 80 00       	mov    %eax,0x805148
  8031cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031d7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031de:	a1 54 51 80 00       	mov    0x805154,%eax
  8031e3:	48                   	dec    %eax
  8031e4:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  8031e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031ec:	8b 40 08             	mov    0x8(%eax),%eax
  8031ef:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   point->sva += size;
  8031f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f7:	8b 50 08             	mov    0x8(%eax),%edx
  8031fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8031fd:	01 c2                	add    %eax,%edx
  8031ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803202:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803205:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803208:	8b 40 0c             	mov    0xc(%eax),%eax
  80320b:	2b 45 08             	sub    0x8(%ebp),%eax
  80320e:	89 c2                	mov    %eax,%edx
  803210:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803213:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803216:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803219:	eb 3b                	jmp    803256 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  80321b:	a1 40 51 80 00       	mov    0x805140,%eax
  803220:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803223:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803227:	74 07                	je     803230 <alloc_block_NF+0x5a5>
  803229:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80322c:	8b 00                	mov    (%eax),%eax
  80322e:	eb 05                	jmp    803235 <alloc_block_NF+0x5aa>
  803230:	b8 00 00 00 00       	mov    $0x0,%eax
  803235:	a3 40 51 80 00       	mov    %eax,0x805140
  80323a:	a1 40 51 80 00       	mov    0x805140,%eax
  80323f:	85 c0                	test   %eax,%eax
  803241:	0f 85 2e fe ff ff    	jne    803075 <alloc_block_NF+0x3ea>
  803247:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80324b:	0f 85 24 fe ff ff    	jne    803075 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  803251:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803256:	c9                   	leave  
  803257:	c3                   	ret    

00803258 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803258:	55                   	push   %ebp
  803259:	89 e5                	mov    %esp,%ebp
  80325b:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  80325e:	a1 38 51 80 00       	mov    0x805138,%eax
  803263:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  803266:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80326b:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  80326e:	a1 38 51 80 00       	mov    0x805138,%eax
  803273:	85 c0                	test   %eax,%eax
  803275:	74 14                	je     80328b <insert_sorted_with_merge_freeList+0x33>
  803277:	8b 45 08             	mov    0x8(%ebp),%eax
  80327a:	8b 50 08             	mov    0x8(%eax),%edx
  80327d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803280:	8b 40 08             	mov    0x8(%eax),%eax
  803283:	39 c2                	cmp    %eax,%edx
  803285:	0f 87 9b 01 00 00    	ja     803426 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  80328b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80328f:	75 17                	jne    8032a8 <insert_sorted_with_merge_freeList+0x50>
  803291:	83 ec 04             	sub    $0x4,%esp
  803294:	68 c0 45 80 00       	push   $0x8045c0
  803299:	68 38 01 00 00       	push   $0x138
  80329e:	68 e3 45 80 00       	push   $0x8045e3
  8032a3:	e8 d8 d4 ff ff       	call   800780 <_panic>
  8032a8:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8032ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b1:	89 10                	mov    %edx,(%eax)
  8032b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b6:	8b 00                	mov    (%eax),%eax
  8032b8:	85 c0                	test   %eax,%eax
  8032ba:	74 0d                	je     8032c9 <insert_sorted_with_merge_freeList+0x71>
  8032bc:	a1 38 51 80 00       	mov    0x805138,%eax
  8032c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8032c4:	89 50 04             	mov    %edx,0x4(%eax)
  8032c7:	eb 08                	jmp    8032d1 <insert_sorted_with_merge_freeList+0x79>
  8032c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032cc:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d4:	a3 38 51 80 00       	mov    %eax,0x805138
  8032d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032dc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032e3:	a1 44 51 80 00       	mov    0x805144,%eax
  8032e8:	40                   	inc    %eax
  8032e9:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8032ee:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8032f2:	0f 84 a8 06 00 00    	je     8039a0 <insert_sorted_with_merge_freeList+0x748>
  8032f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fb:	8b 50 08             	mov    0x8(%eax),%edx
  8032fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803301:	8b 40 0c             	mov    0xc(%eax),%eax
  803304:	01 c2                	add    %eax,%edx
  803306:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803309:	8b 40 08             	mov    0x8(%eax),%eax
  80330c:	39 c2                	cmp    %eax,%edx
  80330e:	0f 85 8c 06 00 00    	jne    8039a0 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  803314:	8b 45 08             	mov    0x8(%ebp),%eax
  803317:	8b 50 0c             	mov    0xc(%eax),%edx
  80331a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80331d:	8b 40 0c             	mov    0xc(%eax),%eax
  803320:	01 c2                	add    %eax,%edx
  803322:	8b 45 08             	mov    0x8(%ebp),%eax
  803325:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  803328:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80332c:	75 17                	jne    803345 <insert_sorted_with_merge_freeList+0xed>
  80332e:	83 ec 04             	sub    $0x4,%esp
  803331:	68 8c 46 80 00       	push   $0x80468c
  803336:	68 3c 01 00 00       	push   $0x13c
  80333b:	68 e3 45 80 00       	push   $0x8045e3
  803340:	e8 3b d4 ff ff       	call   800780 <_panic>
  803345:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803348:	8b 00                	mov    (%eax),%eax
  80334a:	85 c0                	test   %eax,%eax
  80334c:	74 10                	je     80335e <insert_sorted_with_merge_freeList+0x106>
  80334e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803351:	8b 00                	mov    (%eax),%eax
  803353:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803356:	8b 52 04             	mov    0x4(%edx),%edx
  803359:	89 50 04             	mov    %edx,0x4(%eax)
  80335c:	eb 0b                	jmp    803369 <insert_sorted_with_merge_freeList+0x111>
  80335e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803361:	8b 40 04             	mov    0x4(%eax),%eax
  803364:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803369:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80336c:	8b 40 04             	mov    0x4(%eax),%eax
  80336f:	85 c0                	test   %eax,%eax
  803371:	74 0f                	je     803382 <insert_sorted_with_merge_freeList+0x12a>
  803373:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803376:	8b 40 04             	mov    0x4(%eax),%eax
  803379:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80337c:	8b 12                	mov    (%edx),%edx
  80337e:	89 10                	mov    %edx,(%eax)
  803380:	eb 0a                	jmp    80338c <insert_sorted_with_merge_freeList+0x134>
  803382:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803385:	8b 00                	mov    (%eax),%eax
  803387:	a3 38 51 80 00       	mov    %eax,0x805138
  80338c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80338f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803395:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803398:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80339f:	a1 44 51 80 00       	mov    0x805144,%eax
  8033a4:	48                   	dec    %eax
  8033a5:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  8033aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033ad:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  8033b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033b7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  8033be:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8033c2:	75 17                	jne    8033db <insert_sorted_with_merge_freeList+0x183>
  8033c4:	83 ec 04             	sub    $0x4,%esp
  8033c7:	68 c0 45 80 00       	push   $0x8045c0
  8033cc:	68 3f 01 00 00       	push   $0x13f
  8033d1:	68 e3 45 80 00       	push   $0x8045e3
  8033d6:	e8 a5 d3 ff ff       	call   800780 <_panic>
  8033db:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8033e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033e4:	89 10                	mov    %edx,(%eax)
  8033e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033e9:	8b 00                	mov    (%eax),%eax
  8033eb:	85 c0                	test   %eax,%eax
  8033ed:	74 0d                	je     8033fc <insert_sorted_with_merge_freeList+0x1a4>
  8033ef:	a1 48 51 80 00       	mov    0x805148,%eax
  8033f4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8033f7:	89 50 04             	mov    %edx,0x4(%eax)
  8033fa:	eb 08                	jmp    803404 <insert_sorted_with_merge_freeList+0x1ac>
  8033fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033ff:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803404:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803407:	a3 48 51 80 00       	mov    %eax,0x805148
  80340c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80340f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803416:	a1 54 51 80 00       	mov    0x805154,%eax
  80341b:	40                   	inc    %eax
  80341c:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803421:	e9 7a 05 00 00       	jmp    8039a0 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  803426:	8b 45 08             	mov    0x8(%ebp),%eax
  803429:	8b 50 08             	mov    0x8(%eax),%edx
  80342c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80342f:	8b 40 08             	mov    0x8(%eax),%eax
  803432:	39 c2                	cmp    %eax,%edx
  803434:	0f 82 14 01 00 00    	jb     80354e <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  80343a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80343d:	8b 50 08             	mov    0x8(%eax),%edx
  803440:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803443:	8b 40 0c             	mov    0xc(%eax),%eax
  803446:	01 c2                	add    %eax,%edx
  803448:	8b 45 08             	mov    0x8(%ebp),%eax
  80344b:	8b 40 08             	mov    0x8(%eax),%eax
  80344e:	39 c2                	cmp    %eax,%edx
  803450:	0f 85 90 00 00 00    	jne    8034e6 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  803456:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803459:	8b 50 0c             	mov    0xc(%eax),%edx
  80345c:	8b 45 08             	mov    0x8(%ebp),%eax
  80345f:	8b 40 0c             	mov    0xc(%eax),%eax
  803462:	01 c2                	add    %eax,%edx
  803464:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803467:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  80346a:	8b 45 08             	mov    0x8(%ebp),%eax
  80346d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  803474:	8b 45 08             	mov    0x8(%ebp),%eax
  803477:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80347e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803482:	75 17                	jne    80349b <insert_sorted_with_merge_freeList+0x243>
  803484:	83 ec 04             	sub    $0x4,%esp
  803487:	68 c0 45 80 00       	push   $0x8045c0
  80348c:	68 49 01 00 00       	push   $0x149
  803491:	68 e3 45 80 00       	push   $0x8045e3
  803496:	e8 e5 d2 ff ff       	call   800780 <_panic>
  80349b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8034a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a4:	89 10                	mov    %edx,(%eax)
  8034a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a9:	8b 00                	mov    (%eax),%eax
  8034ab:	85 c0                	test   %eax,%eax
  8034ad:	74 0d                	je     8034bc <insert_sorted_with_merge_freeList+0x264>
  8034af:	a1 48 51 80 00       	mov    0x805148,%eax
  8034b4:	8b 55 08             	mov    0x8(%ebp),%edx
  8034b7:	89 50 04             	mov    %edx,0x4(%eax)
  8034ba:	eb 08                	jmp    8034c4 <insert_sorted_with_merge_freeList+0x26c>
  8034bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8034bf:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8034c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c7:	a3 48 51 80 00       	mov    %eax,0x805148
  8034cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8034cf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034d6:	a1 54 51 80 00       	mov    0x805154,%eax
  8034db:	40                   	inc    %eax
  8034dc:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8034e1:	e9 bb 04 00 00       	jmp    8039a1 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  8034e6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034ea:	75 17                	jne    803503 <insert_sorted_with_merge_freeList+0x2ab>
  8034ec:	83 ec 04             	sub    $0x4,%esp
  8034ef:	68 34 46 80 00       	push   $0x804634
  8034f4:	68 4c 01 00 00       	push   $0x14c
  8034f9:	68 e3 45 80 00       	push   $0x8045e3
  8034fe:	e8 7d d2 ff ff       	call   800780 <_panic>
  803503:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803509:	8b 45 08             	mov    0x8(%ebp),%eax
  80350c:	89 50 04             	mov    %edx,0x4(%eax)
  80350f:	8b 45 08             	mov    0x8(%ebp),%eax
  803512:	8b 40 04             	mov    0x4(%eax),%eax
  803515:	85 c0                	test   %eax,%eax
  803517:	74 0c                	je     803525 <insert_sorted_with_merge_freeList+0x2cd>
  803519:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80351e:	8b 55 08             	mov    0x8(%ebp),%edx
  803521:	89 10                	mov    %edx,(%eax)
  803523:	eb 08                	jmp    80352d <insert_sorted_with_merge_freeList+0x2d5>
  803525:	8b 45 08             	mov    0x8(%ebp),%eax
  803528:	a3 38 51 80 00       	mov    %eax,0x805138
  80352d:	8b 45 08             	mov    0x8(%ebp),%eax
  803530:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803535:	8b 45 08             	mov    0x8(%ebp),%eax
  803538:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80353e:	a1 44 51 80 00       	mov    0x805144,%eax
  803543:	40                   	inc    %eax
  803544:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803549:	e9 53 04 00 00       	jmp    8039a1 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80354e:	a1 38 51 80 00       	mov    0x805138,%eax
  803553:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803556:	e9 15 04 00 00       	jmp    803970 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  80355b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80355e:	8b 00                	mov    (%eax),%eax
  803560:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803563:	8b 45 08             	mov    0x8(%ebp),%eax
  803566:	8b 50 08             	mov    0x8(%eax),%edx
  803569:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80356c:	8b 40 08             	mov    0x8(%eax),%eax
  80356f:	39 c2                	cmp    %eax,%edx
  803571:	0f 86 f1 03 00 00    	jbe    803968 <insert_sorted_with_merge_freeList+0x710>
  803577:	8b 45 08             	mov    0x8(%ebp),%eax
  80357a:	8b 50 08             	mov    0x8(%eax),%edx
  80357d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803580:	8b 40 08             	mov    0x8(%eax),%eax
  803583:	39 c2                	cmp    %eax,%edx
  803585:	0f 83 dd 03 00 00    	jae    803968 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  80358b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80358e:	8b 50 08             	mov    0x8(%eax),%edx
  803591:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803594:	8b 40 0c             	mov    0xc(%eax),%eax
  803597:	01 c2                	add    %eax,%edx
  803599:	8b 45 08             	mov    0x8(%ebp),%eax
  80359c:	8b 40 08             	mov    0x8(%eax),%eax
  80359f:	39 c2                	cmp    %eax,%edx
  8035a1:	0f 85 b9 01 00 00    	jne    803760 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8035a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8035aa:	8b 50 08             	mov    0x8(%eax),%edx
  8035ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b0:	8b 40 0c             	mov    0xc(%eax),%eax
  8035b3:	01 c2                	add    %eax,%edx
  8035b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035b8:	8b 40 08             	mov    0x8(%eax),%eax
  8035bb:	39 c2                	cmp    %eax,%edx
  8035bd:	0f 85 0d 01 00 00    	jne    8036d0 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  8035c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035c6:	8b 50 0c             	mov    0xc(%eax),%edx
  8035c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035cc:	8b 40 0c             	mov    0xc(%eax),%eax
  8035cf:	01 c2                	add    %eax,%edx
  8035d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035d4:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8035d7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8035db:	75 17                	jne    8035f4 <insert_sorted_with_merge_freeList+0x39c>
  8035dd:	83 ec 04             	sub    $0x4,%esp
  8035e0:	68 8c 46 80 00       	push   $0x80468c
  8035e5:	68 5c 01 00 00       	push   $0x15c
  8035ea:	68 e3 45 80 00       	push   $0x8045e3
  8035ef:	e8 8c d1 ff ff       	call   800780 <_panic>
  8035f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035f7:	8b 00                	mov    (%eax),%eax
  8035f9:	85 c0                	test   %eax,%eax
  8035fb:	74 10                	je     80360d <insert_sorted_with_merge_freeList+0x3b5>
  8035fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803600:	8b 00                	mov    (%eax),%eax
  803602:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803605:	8b 52 04             	mov    0x4(%edx),%edx
  803608:	89 50 04             	mov    %edx,0x4(%eax)
  80360b:	eb 0b                	jmp    803618 <insert_sorted_with_merge_freeList+0x3c0>
  80360d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803610:	8b 40 04             	mov    0x4(%eax),%eax
  803613:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803618:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80361b:	8b 40 04             	mov    0x4(%eax),%eax
  80361e:	85 c0                	test   %eax,%eax
  803620:	74 0f                	je     803631 <insert_sorted_with_merge_freeList+0x3d9>
  803622:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803625:	8b 40 04             	mov    0x4(%eax),%eax
  803628:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80362b:	8b 12                	mov    (%edx),%edx
  80362d:	89 10                	mov    %edx,(%eax)
  80362f:	eb 0a                	jmp    80363b <insert_sorted_with_merge_freeList+0x3e3>
  803631:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803634:	8b 00                	mov    (%eax),%eax
  803636:	a3 38 51 80 00       	mov    %eax,0x805138
  80363b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80363e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803644:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803647:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80364e:	a1 44 51 80 00       	mov    0x805144,%eax
  803653:	48                   	dec    %eax
  803654:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803659:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80365c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803663:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803666:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80366d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803671:	75 17                	jne    80368a <insert_sorted_with_merge_freeList+0x432>
  803673:	83 ec 04             	sub    $0x4,%esp
  803676:	68 c0 45 80 00       	push   $0x8045c0
  80367b:	68 5f 01 00 00       	push   $0x15f
  803680:	68 e3 45 80 00       	push   $0x8045e3
  803685:	e8 f6 d0 ff ff       	call   800780 <_panic>
  80368a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803690:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803693:	89 10                	mov    %edx,(%eax)
  803695:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803698:	8b 00                	mov    (%eax),%eax
  80369a:	85 c0                	test   %eax,%eax
  80369c:	74 0d                	je     8036ab <insert_sorted_with_merge_freeList+0x453>
  80369e:	a1 48 51 80 00       	mov    0x805148,%eax
  8036a3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8036a6:	89 50 04             	mov    %edx,0x4(%eax)
  8036a9:	eb 08                	jmp    8036b3 <insert_sorted_with_merge_freeList+0x45b>
  8036ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036ae:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8036b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036b6:	a3 48 51 80 00       	mov    %eax,0x805148
  8036bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036be:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036c5:	a1 54 51 80 00       	mov    0x805154,%eax
  8036ca:	40                   	inc    %eax
  8036cb:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  8036d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036d3:	8b 50 0c             	mov    0xc(%eax),%edx
  8036d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d9:	8b 40 0c             	mov    0xc(%eax),%eax
  8036dc:	01 c2                	add    %eax,%edx
  8036de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036e1:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8036e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8036ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8036f1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8036f8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036fc:	75 17                	jne    803715 <insert_sorted_with_merge_freeList+0x4bd>
  8036fe:	83 ec 04             	sub    $0x4,%esp
  803701:	68 c0 45 80 00       	push   $0x8045c0
  803706:	68 64 01 00 00       	push   $0x164
  80370b:	68 e3 45 80 00       	push   $0x8045e3
  803710:	e8 6b d0 ff ff       	call   800780 <_panic>
  803715:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80371b:	8b 45 08             	mov    0x8(%ebp),%eax
  80371e:	89 10                	mov    %edx,(%eax)
  803720:	8b 45 08             	mov    0x8(%ebp),%eax
  803723:	8b 00                	mov    (%eax),%eax
  803725:	85 c0                	test   %eax,%eax
  803727:	74 0d                	je     803736 <insert_sorted_with_merge_freeList+0x4de>
  803729:	a1 48 51 80 00       	mov    0x805148,%eax
  80372e:	8b 55 08             	mov    0x8(%ebp),%edx
  803731:	89 50 04             	mov    %edx,0x4(%eax)
  803734:	eb 08                	jmp    80373e <insert_sorted_with_merge_freeList+0x4e6>
  803736:	8b 45 08             	mov    0x8(%ebp),%eax
  803739:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80373e:	8b 45 08             	mov    0x8(%ebp),%eax
  803741:	a3 48 51 80 00       	mov    %eax,0x805148
  803746:	8b 45 08             	mov    0x8(%ebp),%eax
  803749:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803750:	a1 54 51 80 00       	mov    0x805154,%eax
  803755:	40                   	inc    %eax
  803756:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80375b:	e9 41 02 00 00       	jmp    8039a1 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803760:	8b 45 08             	mov    0x8(%ebp),%eax
  803763:	8b 50 08             	mov    0x8(%eax),%edx
  803766:	8b 45 08             	mov    0x8(%ebp),%eax
  803769:	8b 40 0c             	mov    0xc(%eax),%eax
  80376c:	01 c2                	add    %eax,%edx
  80376e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803771:	8b 40 08             	mov    0x8(%eax),%eax
  803774:	39 c2                	cmp    %eax,%edx
  803776:	0f 85 7c 01 00 00    	jne    8038f8 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  80377c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803780:	74 06                	je     803788 <insert_sorted_with_merge_freeList+0x530>
  803782:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803786:	75 17                	jne    80379f <insert_sorted_with_merge_freeList+0x547>
  803788:	83 ec 04             	sub    $0x4,%esp
  80378b:	68 fc 45 80 00       	push   $0x8045fc
  803790:	68 69 01 00 00       	push   $0x169
  803795:	68 e3 45 80 00       	push   $0x8045e3
  80379a:	e8 e1 cf ff ff       	call   800780 <_panic>
  80379f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037a2:	8b 50 04             	mov    0x4(%eax),%edx
  8037a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a8:	89 50 04             	mov    %edx,0x4(%eax)
  8037ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ae:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8037b1:	89 10                	mov    %edx,(%eax)
  8037b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037b6:	8b 40 04             	mov    0x4(%eax),%eax
  8037b9:	85 c0                	test   %eax,%eax
  8037bb:	74 0d                	je     8037ca <insert_sorted_with_merge_freeList+0x572>
  8037bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037c0:	8b 40 04             	mov    0x4(%eax),%eax
  8037c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8037c6:	89 10                	mov    %edx,(%eax)
  8037c8:	eb 08                	jmp    8037d2 <insert_sorted_with_merge_freeList+0x57a>
  8037ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8037cd:	a3 38 51 80 00       	mov    %eax,0x805138
  8037d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037d5:	8b 55 08             	mov    0x8(%ebp),%edx
  8037d8:	89 50 04             	mov    %edx,0x4(%eax)
  8037db:	a1 44 51 80 00       	mov    0x805144,%eax
  8037e0:	40                   	inc    %eax
  8037e1:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  8037e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8037e9:	8b 50 0c             	mov    0xc(%eax),%edx
  8037ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037ef:	8b 40 0c             	mov    0xc(%eax),%eax
  8037f2:	01 c2                	add    %eax,%edx
  8037f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8037f7:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8037fa:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8037fe:	75 17                	jne    803817 <insert_sorted_with_merge_freeList+0x5bf>
  803800:	83 ec 04             	sub    $0x4,%esp
  803803:	68 8c 46 80 00       	push   $0x80468c
  803808:	68 6b 01 00 00       	push   $0x16b
  80380d:	68 e3 45 80 00       	push   $0x8045e3
  803812:	e8 69 cf ff ff       	call   800780 <_panic>
  803817:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80381a:	8b 00                	mov    (%eax),%eax
  80381c:	85 c0                	test   %eax,%eax
  80381e:	74 10                	je     803830 <insert_sorted_with_merge_freeList+0x5d8>
  803820:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803823:	8b 00                	mov    (%eax),%eax
  803825:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803828:	8b 52 04             	mov    0x4(%edx),%edx
  80382b:	89 50 04             	mov    %edx,0x4(%eax)
  80382e:	eb 0b                	jmp    80383b <insert_sorted_with_merge_freeList+0x5e3>
  803830:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803833:	8b 40 04             	mov    0x4(%eax),%eax
  803836:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80383b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80383e:	8b 40 04             	mov    0x4(%eax),%eax
  803841:	85 c0                	test   %eax,%eax
  803843:	74 0f                	je     803854 <insert_sorted_with_merge_freeList+0x5fc>
  803845:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803848:	8b 40 04             	mov    0x4(%eax),%eax
  80384b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80384e:	8b 12                	mov    (%edx),%edx
  803850:	89 10                	mov    %edx,(%eax)
  803852:	eb 0a                	jmp    80385e <insert_sorted_with_merge_freeList+0x606>
  803854:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803857:	8b 00                	mov    (%eax),%eax
  803859:	a3 38 51 80 00       	mov    %eax,0x805138
  80385e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803861:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803867:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80386a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803871:	a1 44 51 80 00       	mov    0x805144,%eax
  803876:	48                   	dec    %eax
  803877:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  80387c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80387f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803886:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803889:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803890:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803894:	75 17                	jne    8038ad <insert_sorted_with_merge_freeList+0x655>
  803896:	83 ec 04             	sub    $0x4,%esp
  803899:	68 c0 45 80 00       	push   $0x8045c0
  80389e:	68 6e 01 00 00       	push   $0x16e
  8038a3:	68 e3 45 80 00       	push   $0x8045e3
  8038a8:	e8 d3 ce ff ff       	call   800780 <_panic>
  8038ad:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8038b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038b6:	89 10                	mov    %edx,(%eax)
  8038b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038bb:	8b 00                	mov    (%eax),%eax
  8038bd:	85 c0                	test   %eax,%eax
  8038bf:	74 0d                	je     8038ce <insert_sorted_with_merge_freeList+0x676>
  8038c1:	a1 48 51 80 00       	mov    0x805148,%eax
  8038c6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8038c9:	89 50 04             	mov    %edx,0x4(%eax)
  8038cc:	eb 08                	jmp    8038d6 <insert_sorted_with_merge_freeList+0x67e>
  8038ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038d1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8038d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038d9:	a3 48 51 80 00       	mov    %eax,0x805148
  8038de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038e1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038e8:	a1 54 51 80 00       	mov    0x805154,%eax
  8038ed:	40                   	inc    %eax
  8038ee:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8038f3:	e9 a9 00 00 00       	jmp    8039a1 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8038f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038fc:	74 06                	je     803904 <insert_sorted_with_merge_freeList+0x6ac>
  8038fe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803902:	75 17                	jne    80391b <insert_sorted_with_merge_freeList+0x6c3>
  803904:	83 ec 04             	sub    $0x4,%esp
  803907:	68 58 46 80 00       	push   $0x804658
  80390c:	68 73 01 00 00       	push   $0x173
  803911:	68 e3 45 80 00       	push   $0x8045e3
  803916:	e8 65 ce ff ff       	call   800780 <_panic>
  80391b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80391e:	8b 10                	mov    (%eax),%edx
  803920:	8b 45 08             	mov    0x8(%ebp),%eax
  803923:	89 10                	mov    %edx,(%eax)
  803925:	8b 45 08             	mov    0x8(%ebp),%eax
  803928:	8b 00                	mov    (%eax),%eax
  80392a:	85 c0                	test   %eax,%eax
  80392c:	74 0b                	je     803939 <insert_sorted_with_merge_freeList+0x6e1>
  80392e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803931:	8b 00                	mov    (%eax),%eax
  803933:	8b 55 08             	mov    0x8(%ebp),%edx
  803936:	89 50 04             	mov    %edx,0x4(%eax)
  803939:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80393c:	8b 55 08             	mov    0x8(%ebp),%edx
  80393f:	89 10                	mov    %edx,(%eax)
  803941:	8b 45 08             	mov    0x8(%ebp),%eax
  803944:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803947:	89 50 04             	mov    %edx,0x4(%eax)
  80394a:	8b 45 08             	mov    0x8(%ebp),%eax
  80394d:	8b 00                	mov    (%eax),%eax
  80394f:	85 c0                	test   %eax,%eax
  803951:	75 08                	jne    80395b <insert_sorted_with_merge_freeList+0x703>
  803953:	8b 45 08             	mov    0x8(%ebp),%eax
  803956:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80395b:	a1 44 51 80 00       	mov    0x805144,%eax
  803960:	40                   	inc    %eax
  803961:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803966:	eb 39                	jmp    8039a1 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803968:	a1 40 51 80 00       	mov    0x805140,%eax
  80396d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803970:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803974:	74 07                	je     80397d <insert_sorted_with_merge_freeList+0x725>
  803976:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803979:	8b 00                	mov    (%eax),%eax
  80397b:	eb 05                	jmp    803982 <insert_sorted_with_merge_freeList+0x72a>
  80397d:	b8 00 00 00 00       	mov    $0x0,%eax
  803982:	a3 40 51 80 00       	mov    %eax,0x805140
  803987:	a1 40 51 80 00       	mov    0x805140,%eax
  80398c:	85 c0                	test   %eax,%eax
  80398e:	0f 85 c7 fb ff ff    	jne    80355b <insert_sorted_with_merge_freeList+0x303>
  803994:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803998:	0f 85 bd fb ff ff    	jne    80355b <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80399e:	eb 01                	jmp    8039a1 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8039a0:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8039a1:	90                   	nop
  8039a2:	c9                   	leave  
  8039a3:	c3                   	ret    

008039a4 <__udivdi3>:
  8039a4:	55                   	push   %ebp
  8039a5:	57                   	push   %edi
  8039a6:	56                   	push   %esi
  8039a7:	53                   	push   %ebx
  8039a8:	83 ec 1c             	sub    $0x1c,%esp
  8039ab:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8039af:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8039b3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8039b7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8039bb:	89 ca                	mov    %ecx,%edx
  8039bd:	89 f8                	mov    %edi,%eax
  8039bf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8039c3:	85 f6                	test   %esi,%esi
  8039c5:	75 2d                	jne    8039f4 <__udivdi3+0x50>
  8039c7:	39 cf                	cmp    %ecx,%edi
  8039c9:	77 65                	ja     803a30 <__udivdi3+0x8c>
  8039cb:	89 fd                	mov    %edi,%ebp
  8039cd:	85 ff                	test   %edi,%edi
  8039cf:	75 0b                	jne    8039dc <__udivdi3+0x38>
  8039d1:	b8 01 00 00 00       	mov    $0x1,%eax
  8039d6:	31 d2                	xor    %edx,%edx
  8039d8:	f7 f7                	div    %edi
  8039da:	89 c5                	mov    %eax,%ebp
  8039dc:	31 d2                	xor    %edx,%edx
  8039de:	89 c8                	mov    %ecx,%eax
  8039e0:	f7 f5                	div    %ebp
  8039e2:	89 c1                	mov    %eax,%ecx
  8039e4:	89 d8                	mov    %ebx,%eax
  8039e6:	f7 f5                	div    %ebp
  8039e8:	89 cf                	mov    %ecx,%edi
  8039ea:	89 fa                	mov    %edi,%edx
  8039ec:	83 c4 1c             	add    $0x1c,%esp
  8039ef:	5b                   	pop    %ebx
  8039f0:	5e                   	pop    %esi
  8039f1:	5f                   	pop    %edi
  8039f2:	5d                   	pop    %ebp
  8039f3:	c3                   	ret    
  8039f4:	39 ce                	cmp    %ecx,%esi
  8039f6:	77 28                	ja     803a20 <__udivdi3+0x7c>
  8039f8:	0f bd fe             	bsr    %esi,%edi
  8039fb:	83 f7 1f             	xor    $0x1f,%edi
  8039fe:	75 40                	jne    803a40 <__udivdi3+0x9c>
  803a00:	39 ce                	cmp    %ecx,%esi
  803a02:	72 0a                	jb     803a0e <__udivdi3+0x6a>
  803a04:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803a08:	0f 87 9e 00 00 00    	ja     803aac <__udivdi3+0x108>
  803a0e:	b8 01 00 00 00       	mov    $0x1,%eax
  803a13:	89 fa                	mov    %edi,%edx
  803a15:	83 c4 1c             	add    $0x1c,%esp
  803a18:	5b                   	pop    %ebx
  803a19:	5e                   	pop    %esi
  803a1a:	5f                   	pop    %edi
  803a1b:	5d                   	pop    %ebp
  803a1c:	c3                   	ret    
  803a1d:	8d 76 00             	lea    0x0(%esi),%esi
  803a20:	31 ff                	xor    %edi,%edi
  803a22:	31 c0                	xor    %eax,%eax
  803a24:	89 fa                	mov    %edi,%edx
  803a26:	83 c4 1c             	add    $0x1c,%esp
  803a29:	5b                   	pop    %ebx
  803a2a:	5e                   	pop    %esi
  803a2b:	5f                   	pop    %edi
  803a2c:	5d                   	pop    %ebp
  803a2d:	c3                   	ret    
  803a2e:	66 90                	xchg   %ax,%ax
  803a30:	89 d8                	mov    %ebx,%eax
  803a32:	f7 f7                	div    %edi
  803a34:	31 ff                	xor    %edi,%edi
  803a36:	89 fa                	mov    %edi,%edx
  803a38:	83 c4 1c             	add    $0x1c,%esp
  803a3b:	5b                   	pop    %ebx
  803a3c:	5e                   	pop    %esi
  803a3d:	5f                   	pop    %edi
  803a3e:	5d                   	pop    %ebp
  803a3f:	c3                   	ret    
  803a40:	bd 20 00 00 00       	mov    $0x20,%ebp
  803a45:	89 eb                	mov    %ebp,%ebx
  803a47:	29 fb                	sub    %edi,%ebx
  803a49:	89 f9                	mov    %edi,%ecx
  803a4b:	d3 e6                	shl    %cl,%esi
  803a4d:	89 c5                	mov    %eax,%ebp
  803a4f:	88 d9                	mov    %bl,%cl
  803a51:	d3 ed                	shr    %cl,%ebp
  803a53:	89 e9                	mov    %ebp,%ecx
  803a55:	09 f1                	or     %esi,%ecx
  803a57:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803a5b:	89 f9                	mov    %edi,%ecx
  803a5d:	d3 e0                	shl    %cl,%eax
  803a5f:	89 c5                	mov    %eax,%ebp
  803a61:	89 d6                	mov    %edx,%esi
  803a63:	88 d9                	mov    %bl,%cl
  803a65:	d3 ee                	shr    %cl,%esi
  803a67:	89 f9                	mov    %edi,%ecx
  803a69:	d3 e2                	shl    %cl,%edx
  803a6b:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a6f:	88 d9                	mov    %bl,%cl
  803a71:	d3 e8                	shr    %cl,%eax
  803a73:	09 c2                	or     %eax,%edx
  803a75:	89 d0                	mov    %edx,%eax
  803a77:	89 f2                	mov    %esi,%edx
  803a79:	f7 74 24 0c          	divl   0xc(%esp)
  803a7d:	89 d6                	mov    %edx,%esi
  803a7f:	89 c3                	mov    %eax,%ebx
  803a81:	f7 e5                	mul    %ebp
  803a83:	39 d6                	cmp    %edx,%esi
  803a85:	72 19                	jb     803aa0 <__udivdi3+0xfc>
  803a87:	74 0b                	je     803a94 <__udivdi3+0xf0>
  803a89:	89 d8                	mov    %ebx,%eax
  803a8b:	31 ff                	xor    %edi,%edi
  803a8d:	e9 58 ff ff ff       	jmp    8039ea <__udivdi3+0x46>
  803a92:	66 90                	xchg   %ax,%ax
  803a94:	8b 54 24 08          	mov    0x8(%esp),%edx
  803a98:	89 f9                	mov    %edi,%ecx
  803a9a:	d3 e2                	shl    %cl,%edx
  803a9c:	39 c2                	cmp    %eax,%edx
  803a9e:	73 e9                	jae    803a89 <__udivdi3+0xe5>
  803aa0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803aa3:	31 ff                	xor    %edi,%edi
  803aa5:	e9 40 ff ff ff       	jmp    8039ea <__udivdi3+0x46>
  803aaa:	66 90                	xchg   %ax,%ax
  803aac:	31 c0                	xor    %eax,%eax
  803aae:	e9 37 ff ff ff       	jmp    8039ea <__udivdi3+0x46>
  803ab3:	90                   	nop

00803ab4 <__umoddi3>:
  803ab4:	55                   	push   %ebp
  803ab5:	57                   	push   %edi
  803ab6:	56                   	push   %esi
  803ab7:	53                   	push   %ebx
  803ab8:	83 ec 1c             	sub    $0x1c,%esp
  803abb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803abf:	8b 74 24 34          	mov    0x34(%esp),%esi
  803ac3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803ac7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803acb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803acf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803ad3:	89 f3                	mov    %esi,%ebx
  803ad5:	89 fa                	mov    %edi,%edx
  803ad7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803adb:	89 34 24             	mov    %esi,(%esp)
  803ade:	85 c0                	test   %eax,%eax
  803ae0:	75 1a                	jne    803afc <__umoddi3+0x48>
  803ae2:	39 f7                	cmp    %esi,%edi
  803ae4:	0f 86 a2 00 00 00    	jbe    803b8c <__umoddi3+0xd8>
  803aea:	89 c8                	mov    %ecx,%eax
  803aec:	89 f2                	mov    %esi,%edx
  803aee:	f7 f7                	div    %edi
  803af0:	89 d0                	mov    %edx,%eax
  803af2:	31 d2                	xor    %edx,%edx
  803af4:	83 c4 1c             	add    $0x1c,%esp
  803af7:	5b                   	pop    %ebx
  803af8:	5e                   	pop    %esi
  803af9:	5f                   	pop    %edi
  803afa:	5d                   	pop    %ebp
  803afb:	c3                   	ret    
  803afc:	39 f0                	cmp    %esi,%eax
  803afe:	0f 87 ac 00 00 00    	ja     803bb0 <__umoddi3+0xfc>
  803b04:	0f bd e8             	bsr    %eax,%ebp
  803b07:	83 f5 1f             	xor    $0x1f,%ebp
  803b0a:	0f 84 ac 00 00 00    	je     803bbc <__umoddi3+0x108>
  803b10:	bf 20 00 00 00       	mov    $0x20,%edi
  803b15:	29 ef                	sub    %ebp,%edi
  803b17:	89 fe                	mov    %edi,%esi
  803b19:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803b1d:	89 e9                	mov    %ebp,%ecx
  803b1f:	d3 e0                	shl    %cl,%eax
  803b21:	89 d7                	mov    %edx,%edi
  803b23:	89 f1                	mov    %esi,%ecx
  803b25:	d3 ef                	shr    %cl,%edi
  803b27:	09 c7                	or     %eax,%edi
  803b29:	89 e9                	mov    %ebp,%ecx
  803b2b:	d3 e2                	shl    %cl,%edx
  803b2d:	89 14 24             	mov    %edx,(%esp)
  803b30:	89 d8                	mov    %ebx,%eax
  803b32:	d3 e0                	shl    %cl,%eax
  803b34:	89 c2                	mov    %eax,%edx
  803b36:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b3a:	d3 e0                	shl    %cl,%eax
  803b3c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803b40:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b44:	89 f1                	mov    %esi,%ecx
  803b46:	d3 e8                	shr    %cl,%eax
  803b48:	09 d0                	or     %edx,%eax
  803b4a:	d3 eb                	shr    %cl,%ebx
  803b4c:	89 da                	mov    %ebx,%edx
  803b4e:	f7 f7                	div    %edi
  803b50:	89 d3                	mov    %edx,%ebx
  803b52:	f7 24 24             	mull   (%esp)
  803b55:	89 c6                	mov    %eax,%esi
  803b57:	89 d1                	mov    %edx,%ecx
  803b59:	39 d3                	cmp    %edx,%ebx
  803b5b:	0f 82 87 00 00 00    	jb     803be8 <__umoddi3+0x134>
  803b61:	0f 84 91 00 00 00    	je     803bf8 <__umoddi3+0x144>
  803b67:	8b 54 24 04          	mov    0x4(%esp),%edx
  803b6b:	29 f2                	sub    %esi,%edx
  803b6d:	19 cb                	sbb    %ecx,%ebx
  803b6f:	89 d8                	mov    %ebx,%eax
  803b71:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803b75:	d3 e0                	shl    %cl,%eax
  803b77:	89 e9                	mov    %ebp,%ecx
  803b79:	d3 ea                	shr    %cl,%edx
  803b7b:	09 d0                	or     %edx,%eax
  803b7d:	89 e9                	mov    %ebp,%ecx
  803b7f:	d3 eb                	shr    %cl,%ebx
  803b81:	89 da                	mov    %ebx,%edx
  803b83:	83 c4 1c             	add    $0x1c,%esp
  803b86:	5b                   	pop    %ebx
  803b87:	5e                   	pop    %esi
  803b88:	5f                   	pop    %edi
  803b89:	5d                   	pop    %ebp
  803b8a:	c3                   	ret    
  803b8b:	90                   	nop
  803b8c:	89 fd                	mov    %edi,%ebp
  803b8e:	85 ff                	test   %edi,%edi
  803b90:	75 0b                	jne    803b9d <__umoddi3+0xe9>
  803b92:	b8 01 00 00 00       	mov    $0x1,%eax
  803b97:	31 d2                	xor    %edx,%edx
  803b99:	f7 f7                	div    %edi
  803b9b:	89 c5                	mov    %eax,%ebp
  803b9d:	89 f0                	mov    %esi,%eax
  803b9f:	31 d2                	xor    %edx,%edx
  803ba1:	f7 f5                	div    %ebp
  803ba3:	89 c8                	mov    %ecx,%eax
  803ba5:	f7 f5                	div    %ebp
  803ba7:	89 d0                	mov    %edx,%eax
  803ba9:	e9 44 ff ff ff       	jmp    803af2 <__umoddi3+0x3e>
  803bae:	66 90                	xchg   %ax,%ax
  803bb0:	89 c8                	mov    %ecx,%eax
  803bb2:	89 f2                	mov    %esi,%edx
  803bb4:	83 c4 1c             	add    $0x1c,%esp
  803bb7:	5b                   	pop    %ebx
  803bb8:	5e                   	pop    %esi
  803bb9:	5f                   	pop    %edi
  803bba:	5d                   	pop    %ebp
  803bbb:	c3                   	ret    
  803bbc:	3b 04 24             	cmp    (%esp),%eax
  803bbf:	72 06                	jb     803bc7 <__umoddi3+0x113>
  803bc1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803bc5:	77 0f                	ja     803bd6 <__umoddi3+0x122>
  803bc7:	89 f2                	mov    %esi,%edx
  803bc9:	29 f9                	sub    %edi,%ecx
  803bcb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803bcf:	89 14 24             	mov    %edx,(%esp)
  803bd2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803bd6:	8b 44 24 04          	mov    0x4(%esp),%eax
  803bda:	8b 14 24             	mov    (%esp),%edx
  803bdd:	83 c4 1c             	add    $0x1c,%esp
  803be0:	5b                   	pop    %ebx
  803be1:	5e                   	pop    %esi
  803be2:	5f                   	pop    %edi
  803be3:	5d                   	pop    %ebp
  803be4:	c3                   	ret    
  803be5:	8d 76 00             	lea    0x0(%esi),%esi
  803be8:	2b 04 24             	sub    (%esp),%eax
  803beb:	19 fa                	sbb    %edi,%edx
  803bed:	89 d1                	mov    %edx,%ecx
  803bef:	89 c6                	mov    %eax,%esi
  803bf1:	e9 71 ff ff ff       	jmp    803b67 <__umoddi3+0xb3>
  803bf6:	66 90                	xchg   %ax,%ax
  803bf8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803bfc:	72 ea                	jb     803be8 <__umoddi3+0x134>
  803bfe:	89 d9                	mov    %ebx,%ecx
  803c00:	e9 62 ff ff ff       	jmp    803b67 <__umoddi3+0xb3>
