
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
  800041:	e8 3e 1f 00 00       	call   801f84 <sys_disable_interrupt>
		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 c0 3c 80 00       	push   $0x803cc0
  80004e:	e8 e1 09 00 00       	call   800a34 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 c2 3c 80 00       	push   $0x803cc2
  80005e:	e8 d1 09 00 00       	call   800a34 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!   QUICK SORT    !!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 db 3c 80 00       	push   $0x803cdb
  80006e:	e8 c1 09 00 00       	call   800a34 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 c2 3c 80 00       	push   $0x803cc2
  80007e:	e8 b1 09 00 00       	call   800a34 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 c0 3c 80 00       	push   $0x803cc0
  80008e:	e8 a1 09 00 00       	call   800a34 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp

		readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 f4 3c 80 00       	push   $0x803cf4
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
  8000de:	68 14 3d 80 00       	push   $0x803d14
  8000e3:	e8 4c 09 00 00       	call   800a34 <cprintf>
  8000e8:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000eb:	83 ec 0c             	sub    $0xc,%esp
  8000ee:	68 36 3d 80 00       	push   $0x803d36
  8000f3:	e8 3c 09 00 00       	call   800a34 <cprintf>
  8000f8:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000fb:	83 ec 0c             	sub    $0xc,%esp
  8000fe:	68 44 3d 80 00       	push   $0x803d44
  800103:	e8 2c 09 00 00       	call   800a34 <cprintf>
  800108:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 53 3d 80 00       	push   $0x803d53
  800113:	e8 1c 09 00 00       	call   800a34 <cprintf>
  800118:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	68 63 3d 80 00       	push   $0x803d63
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
  800162:	e8 37 1e 00 00       	call   801f9e <sys_enable_interrupt>

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
  8001d5:	e8 aa 1d 00 00       	call   801f84 <sys_disable_interrupt>
			cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001da:	83 ec 0c             	sub    $0xc,%esp
  8001dd:	68 6c 3d 80 00       	push   $0x803d6c
  8001e2:	e8 4d 08 00 00       	call   800a34 <cprintf>
  8001e7:	83 c4 10             	add    $0x10,%esp
		//		PrintElements(Elements, NumOfElements);
		sys_enable_interrupt();
  8001ea:	e8 af 1d 00 00       	call   801f9e <sys_enable_interrupt>

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
  80020c:	68 a0 3d 80 00       	push   $0x803da0
  800211:	6a 49                	push   $0x49
  800213:	68 c2 3d 80 00       	push   $0x803dc2
  800218:	e8 63 05 00 00       	call   800780 <_panic>
		else
		{
			sys_disable_interrupt();
  80021d:	e8 62 1d 00 00       	call   801f84 <sys_disable_interrupt>
			cprintf("===============================================\n") ;
  800222:	83 ec 0c             	sub    $0xc,%esp
  800225:	68 e0 3d 80 00       	push   $0x803de0
  80022a:	e8 05 08 00 00       	call   800a34 <cprintf>
  80022f:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  800232:	83 ec 0c             	sub    $0xc,%esp
  800235:	68 14 3e 80 00       	push   $0x803e14
  80023a:	e8 f5 07 00 00       	call   800a34 <cprintf>
  80023f:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  800242:	83 ec 0c             	sub    $0xc,%esp
  800245:	68 48 3e 80 00       	push   $0x803e48
  80024a:	e8 e5 07 00 00       	call   800a34 <cprintf>
  80024f:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800252:	e8 47 1d 00 00       	call   801f9e <sys_enable_interrupt>

		}

		free(Elements) ;
  800257:	83 ec 0c             	sub    $0xc,%esp
  80025a:	ff 75 f0             	pushl  -0x10(%ebp)
  80025d:	e8 db 19 00 00       	call   801c3d <free>
  800262:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  800265:	e8 1a 1d 00 00       	call   801f84 <sys_disable_interrupt>

		cprintf("Do you want to repeat (y/n): ") ;
  80026a:	83 ec 0c             	sub    $0xc,%esp
  80026d:	68 7a 3e 80 00       	push   $0x803e7a
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
  80029f:	e8 fa 1c 00 00       	call   801f9e <sys_enable_interrupt>

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
  800544:	68 c0 3c 80 00       	push   $0x803cc0
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
  800566:	68 98 3e 80 00       	push   $0x803e98
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
  800594:	68 9d 3e 80 00       	push   $0x803e9d
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
  8005b8:	e8 fb 19 00 00       	call   801fb8 <sys_cputc>
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
  8005c9:	e8 b6 19 00 00       	call   801f84 <sys_disable_interrupt>
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
  8005dc:	e8 d7 19 00 00       	call   801fb8 <sys_cputc>
  8005e1:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8005e4:	e8 b5 19 00 00       	call   801f9e <sys_enable_interrupt>
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
  8005fb:	e8 ff 17 00 00       	call   801dff <sys_cgetc>
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
  800614:	e8 6b 19 00 00       	call   801f84 <sys_disable_interrupt>
	int c=0;
  800619:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800620:	eb 08                	jmp    80062a <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  800622:	e8 d8 17 00 00       	call   801dff <sys_cgetc>
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
  800630:	e8 69 19 00 00       	call   801f9e <sys_enable_interrupt>
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
  80064a:	e8 28 1b 00 00       	call   802177 <sys_getenvindex>
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
  8006b5:	e8 ca 18 00 00       	call   801f84 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8006ba:	83 ec 0c             	sub    $0xc,%esp
  8006bd:	68 bc 3e 80 00       	push   $0x803ebc
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
  8006e5:	68 e4 3e 80 00       	push   $0x803ee4
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
  800716:	68 0c 3f 80 00       	push   $0x803f0c
  80071b:	e8 14 03 00 00       	call   800a34 <cprintf>
  800720:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800723:	a1 24 50 80 00       	mov    0x805024,%eax
  800728:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80072e:	83 ec 08             	sub    $0x8,%esp
  800731:	50                   	push   %eax
  800732:	68 64 3f 80 00       	push   $0x803f64
  800737:	e8 f8 02 00 00       	call   800a34 <cprintf>
  80073c:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80073f:	83 ec 0c             	sub    $0xc,%esp
  800742:	68 bc 3e 80 00       	push   $0x803ebc
  800747:	e8 e8 02 00 00       	call   800a34 <cprintf>
  80074c:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80074f:	e8 4a 18 00 00       	call   801f9e <sys_enable_interrupt>

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
  800767:	e8 d7 19 00 00       	call   802143 <sys_destroy_env>
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
  800778:	e8 2c 1a 00 00       	call   8021a9 <sys_exit_env>
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
  8007a1:	68 78 3f 80 00       	push   $0x803f78
  8007a6:	e8 89 02 00 00       	call   800a34 <cprintf>
  8007ab:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8007ae:	a1 00 50 80 00       	mov    0x805000,%eax
  8007b3:	ff 75 0c             	pushl  0xc(%ebp)
  8007b6:	ff 75 08             	pushl  0x8(%ebp)
  8007b9:	50                   	push   %eax
  8007ba:	68 7d 3f 80 00       	push   $0x803f7d
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
  8007de:	68 99 3f 80 00       	push   $0x803f99
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
  80080a:	68 9c 3f 80 00       	push   $0x803f9c
  80080f:	6a 26                	push   $0x26
  800811:	68 e8 3f 80 00       	push   $0x803fe8
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
  8008dc:	68 f4 3f 80 00       	push   $0x803ff4
  8008e1:	6a 3a                	push   $0x3a
  8008e3:	68 e8 3f 80 00       	push   $0x803fe8
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
  80094c:	68 48 40 80 00       	push   $0x804048
  800951:	6a 44                	push   $0x44
  800953:	68 e8 3f 80 00       	push   $0x803fe8
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
  8009a6:	e8 2b 14 00 00       	call   801dd6 <sys_cputs>
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
  800a1d:	e8 b4 13 00 00       	call   801dd6 <sys_cputs>
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
  800a67:	e8 18 15 00 00       	call   801f84 <sys_disable_interrupt>
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
  800a87:	e8 12 15 00 00       	call   801f9e <sys_enable_interrupt>
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
  800ad1:	e8 86 2f 00 00       	call   803a5c <__udivdi3>
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
  800b21:	e8 46 30 00 00       	call   803b6c <__umoddi3>
  800b26:	83 c4 10             	add    $0x10,%esp
  800b29:	05 b4 42 80 00       	add    $0x8042b4,%eax
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
  800c7c:	8b 04 85 d8 42 80 00 	mov    0x8042d8(,%eax,4),%eax
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
  800d5d:	8b 34 9d 20 41 80 00 	mov    0x804120(,%ebx,4),%esi
  800d64:	85 f6                	test   %esi,%esi
  800d66:	75 19                	jne    800d81 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d68:	53                   	push   %ebx
  800d69:	68 c5 42 80 00       	push   $0x8042c5
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
  800d82:	68 ce 42 80 00       	push   $0x8042ce
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
  800daf:	be d1 42 80 00       	mov    $0x8042d1,%esi
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
  8010c8:	68 30 44 80 00       	push   $0x804430
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
  80110a:	68 33 44 80 00       	push   $0x804433
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
  8011ba:	e8 c5 0d 00 00       	call   801f84 <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  8011bf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011c3:	74 13                	je     8011d8 <atomic_readline+0x24>
		cprintf("%s", prompt);
  8011c5:	83 ec 08             	sub    $0x8,%esp
  8011c8:	ff 75 08             	pushl  0x8(%ebp)
  8011cb:	68 30 44 80 00       	push   $0x804430
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
  801209:	68 33 44 80 00       	push   $0x804433
  80120e:	e8 21 f8 ff ff       	call   800a34 <cprintf>
  801213:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  801216:	e8 83 0d 00 00       	call   801f9e <sys_enable_interrupt>
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
  8012ae:	e8 eb 0c 00 00       	call   801f9e <sys_enable_interrupt>
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
  8019db:	68 44 44 80 00       	push   $0x804444
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
  801aab:	e8 6a 04 00 00       	call   801f1a <sys_allocate_chunk>
  801ab0:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801ab3:	a1 20 51 80 00       	mov    0x805120,%eax
  801ab8:	83 ec 0c             	sub    $0xc,%esp
  801abb:	50                   	push   %eax
  801abc:	e8 df 0a 00 00       	call   8025a0 <initialize_MemBlocksList>
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
  801ae9:	68 69 44 80 00       	push   $0x804469
  801aee:	6a 33                	push   $0x33
  801af0:	68 87 44 80 00       	push   $0x804487
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
  801b68:	68 94 44 80 00       	push   $0x804494
  801b6d:	6a 34                	push   $0x34
  801b6f:	68 87 44 80 00       	push   $0x804487
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
  801c00:	e8 e3 06 00 00       	call   8022e8 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801c05:	85 c0                	test   %eax,%eax
  801c07:	74 11                	je     801c1a <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801c09:	83 ec 0c             	sub    $0xc,%esp
  801c0c:	ff 75 e8             	pushl  -0x18(%ebp)
  801c0f:	e8 4e 0d 00 00       	call   802962 <alloc_block_FF>
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
  801c26:	e8 aa 0a 00 00       	call   8026d5 <insert_sorted_allocList>
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
  801c46:	68 b8 44 80 00       	push   $0x8044b8
  801c4b:	6a 6f                	push   $0x6f
  801c4d:	68 87 44 80 00       	push   $0x804487
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
  801c6c:	75 07                	jne    801c75 <smalloc+0x1e>
  801c6e:	b8 00 00 00 00       	mov    $0x0,%eax
  801c73:	eb 7c                	jmp    801cf1 <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801c75:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801c7c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c82:	01 d0                	add    %edx,%eax
  801c84:	48                   	dec    %eax
  801c85:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801c88:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c8b:	ba 00 00 00 00       	mov    $0x0,%edx
  801c90:	f7 75 f0             	divl   -0x10(%ebp)
  801c93:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c96:	29 d0                	sub    %edx,%eax
  801c98:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801c9b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801ca2:	e8 41 06 00 00       	call   8022e8 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801ca7:	85 c0                	test   %eax,%eax
  801ca9:	74 11                	je     801cbc <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  801cab:	83 ec 0c             	sub    $0xc,%esp
  801cae:	ff 75 e8             	pushl  -0x18(%ebp)
  801cb1:	e8 ac 0c 00 00       	call   802962 <alloc_block_FF>
  801cb6:	83 c4 10             	add    $0x10,%esp
  801cb9:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  801cbc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801cc0:	74 2a                	je     801cec <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801cc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cc5:	8b 40 08             	mov    0x8(%eax),%eax
  801cc8:	89 c2                	mov    %eax,%edx
  801cca:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801cce:	52                   	push   %edx
  801ccf:	50                   	push   %eax
  801cd0:	ff 75 0c             	pushl  0xc(%ebp)
  801cd3:	ff 75 08             	pushl  0x8(%ebp)
  801cd6:	e8 92 03 00 00       	call   80206d <sys_createSharedObject>
  801cdb:	83 c4 10             	add    $0x10,%esp
  801cde:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  801ce1:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  801ce5:	74 05                	je     801cec <smalloc+0x95>
			return (void*)virtual_address;
  801ce7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801cea:	eb 05                	jmp    801cf1 <smalloc+0x9a>
	}
	return NULL;
  801cec:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801cf1:	c9                   	leave  
  801cf2:	c3                   	ret    

00801cf3 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801cf3:	55                   	push   %ebp
  801cf4:	89 e5                	mov    %esp,%ebp
  801cf6:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801cf9:	e8 c6 fc ff ff       	call   8019c4 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801cfe:	83 ec 04             	sub    $0x4,%esp
  801d01:	68 dc 44 80 00       	push   $0x8044dc
  801d06:	68 b0 00 00 00       	push   $0xb0
  801d0b:	68 87 44 80 00       	push   $0x804487
  801d10:	e8 6b ea ff ff       	call   800780 <_panic>

00801d15 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801d15:	55                   	push   %ebp
  801d16:	89 e5                	mov    %esp,%ebp
  801d18:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801d1b:	e8 a4 fc ff ff       	call   8019c4 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801d20:	83 ec 04             	sub    $0x4,%esp
  801d23:	68 00 45 80 00       	push   $0x804500
  801d28:	68 f4 00 00 00       	push   $0xf4
  801d2d:	68 87 44 80 00       	push   $0x804487
  801d32:	e8 49 ea ff ff       	call   800780 <_panic>

00801d37 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801d37:	55                   	push   %ebp
  801d38:	89 e5                	mov    %esp,%ebp
  801d3a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801d3d:	83 ec 04             	sub    $0x4,%esp
  801d40:	68 28 45 80 00       	push   $0x804528
  801d45:	68 08 01 00 00       	push   $0x108
  801d4a:	68 87 44 80 00       	push   $0x804487
  801d4f:	e8 2c ea ff ff       	call   800780 <_panic>

00801d54 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801d54:	55                   	push   %ebp
  801d55:	89 e5                	mov    %esp,%ebp
  801d57:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801d5a:	83 ec 04             	sub    $0x4,%esp
  801d5d:	68 4c 45 80 00       	push   $0x80454c
  801d62:	68 13 01 00 00       	push   $0x113
  801d67:	68 87 44 80 00       	push   $0x804487
  801d6c:	e8 0f ea ff ff       	call   800780 <_panic>

00801d71 <shrink>:

}
void shrink(uint32 newSize)
{
  801d71:	55                   	push   %ebp
  801d72:	89 e5                	mov    %esp,%ebp
  801d74:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801d77:	83 ec 04             	sub    $0x4,%esp
  801d7a:	68 4c 45 80 00       	push   $0x80454c
  801d7f:	68 18 01 00 00       	push   $0x118
  801d84:	68 87 44 80 00       	push   $0x804487
  801d89:	e8 f2 e9 ff ff       	call   800780 <_panic>

00801d8e <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801d8e:	55                   	push   %ebp
  801d8f:	89 e5                	mov    %esp,%ebp
  801d91:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801d94:	83 ec 04             	sub    $0x4,%esp
  801d97:	68 4c 45 80 00       	push   $0x80454c
  801d9c:	68 1d 01 00 00       	push   $0x11d
  801da1:	68 87 44 80 00       	push   $0x804487
  801da6:	e8 d5 e9 ff ff       	call   800780 <_panic>

00801dab <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801dab:	55                   	push   %ebp
  801dac:	89 e5                	mov    %esp,%ebp
  801dae:	57                   	push   %edi
  801daf:	56                   	push   %esi
  801db0:	53                   	push   %ebx
  801db1:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801db4:	8b 45 08             	mov    0x8(%ebp),%eax
  801db7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dba:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801dbd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801dc0:	8b 7d 18             	mov    0x18(%ebp),%edi
  801dc3:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801dc6:	cd 30                	int    $0x30
  801dc8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801dcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801dce:	83 c4 10             	add    $0x10,%esp
  801dd1:	5b                   	pop    %ebx
  801dd2:	5e                   	pop    %esi
  801dd3:	5f                   	pop    %edi
  801dd4:	5d                   	pop    %ebp
  801dd5:	c3                   	ret    

00801dd6 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801dd6:	55                   	push   %ebp
  801dd7:	89 e5                	mov    %esp,%ebp
  801dd9:	83 ec 04             	sub    $0x4,%esp
  801ddc:	8b 45 10             	mov    0x10(%ebp),%eax
  801ddf:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801de2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801de6:	8b 45 08             	mov    0x8(%ebp),%eax
  801de9:	6a 00                	push   $0x0
  801deb:	6a 00                	push   $0x0
  801ded:	52                   	push   %edx
  801dee:	ff 75 0c             	pushl  0xc(%ebp)
  801df1:	50                   	push   %eax
  801df2:	6a 00                	push   $0x0
  801df4:	e8 b2 ff ff ff       	call   801dab <syscall>
  801df9:	83 c4 18             	add    $0x18,%esp
}
  801dfc:	90                   	nop
  801dfd:	c9                   	leave  
  801dfe:	c3                   	ret    

00801dff <sys_cgetc>:

int
sys_cgetc(void)
{
  801dff:	55                   	push   %ebp
  801e00:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801e02:	6a 00                	push   $0x0
  801e04:	6a 00                	push   $0x0
  801e06:	6a 00                	push   $0x0
  801e08:	6a 00                	push   $0x0
  801e0a:	6a 00                	push   $0x0
  801e0c:	6a 01                	push   $0x1
  801e0e:	e8 98 ff ff ff       	call   801dab <syscall>
  801e13:	83 c4 18             	add    $0x18,%esp
}
  801e16:	c9                   	leave  
  801e17:	c3                   	ret    

00801e18 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801e18:	55                   	push   %ebp
  801e19:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801e1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e21:	6a 00                	push   $0x0
  801e23:	6a 00                	push   $0x0
  801e25:	6a 00                	push   $0x0
  801e27:	52                   	push   %edx
  801e28:	50                   	push   %eax
  801e29:	6a 05                	push   $0x5
  801e2b:	e8 7b ff ff ff       	call   801dab <syscall>
  801e30:	83 c4 18             	add    $0x18,%esp
}
  801e33:	c9                   	leave  
  801e34:	c3                   	ret    

00801e35 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801e35:	55                   	push   %ebp
  801e36:	89 e5                	mov    %esp,%ebp
  801e38:	56                   	push   %esi
  801e39:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801e3a:	8b 75 18             	mov    0x18(%ebp),%esi
  801e3d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e40:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e43:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e46:	8b 45 08             	mov    0x8(%ebp),%eax
  801e49:	56                   	push   %esi
  801e4a:	53                   	push   %ebx
  801e4b:	51                   	push   %ecx
  801e4c:	52                   	push   %edx
  801e4d:	50                   	push   %eax
  801e4e:	6a 06                	push   $0x6
  801e50:	e8 56 ff ff ff       	call   801dab <syscall>
  801e55:	83 c4 18             	add    $0x18,%esp
}
  801e58:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e5b:	5b                   	pop    %ebx
  801e5c:	5e                   	pop    %esi
  801e5d:	5d                   	pop    %ebp
  801e5e:	c3                   	ret    

00801e5f <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801e5f:	55                   	push   %ebp
  801e60:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801e62:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e65:	8b 45 08             	mov    0x8(%ebp),%eax
  801e68:	6a 00                	push   $0x0
  801e6a:	6a 00                	push   $0x0
  801e6c:	6a 00                	push   $0x0
  801e6e:	52                   	push   %edx
  801e6f:	50                   	push   %eax
  801e70:	6a 07                	push   $0x7
  801e72:	e8 34 ff ff ff       	call   801dab <syscall>
  801e77:	83 c4 18             	add    $0x18,%esp
}
  801e7a:	c9                   	leave  
  801e7b:	c3                   	ret    

00801e7c <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801e7c:	55                   	push   %ebp
  801e7d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801e7f:	6a 00                	push   $0x0
  801e81:	6a 00                	push   $0x0
  801e83:	6a 00                	push   $0x0
  801e85:	ff 75 0c             	pushl  0xc(%ebp)
  801e88:	ff 75 08             	pushl  0x8(%ebp)
  801e8b:	6a 08                	push   $0x8
  801e8d:	e8 19 ff ff ff       	call   801dab <syscall>
  801e92:	83 c4 18             	add    $0x18,%esp
}
  801e95:	c9                   	leave  
  801e96:	c3                   	ret    

00801e97 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801e97:	55                   	push   %ebp
  801e98:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801e9a:	6a 00                	push   $0x0
  801e9c:	6a 00                	push   $0x0
  801e9e:	6a 00                	push   $0x0
  801ea0:	6a 00                	push   $0x0
  801ea2:	6a 00                	push   $0x0
  801ea4:	6a 09                	push   $0x9
  801ea6:	e8 00 ff ff ff       	call   801dab <syscall>
  801eab:	83 c4 18             	add    $0x18,%esp
}
  801eae:	c9                   	leave  
  801eaf:	c3                   	ret    

00801eb0 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801eb0:	55                   	push   %ebp
  801eb1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801eb3:	6a 00                	push   $0x0
  801eb5:	6a 00                	push   $0x0
  801eb7:	6a 00                	push   $0x0
  801eb9:	6a 00                	push   $0x0
  801ebb:	6a 00                	push   $0x0
  801ebd:	6a 0a                	push   $0xa
  801ebf:	e8 e7 fe ff ff       	call   801dab <syscall>
  801ec4:	83 c4 18             	add    $0x18,%esp
}
  801ec7:	c9                   	leave  
  801ec8:	c3                   	ret    

00801ec9 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801ec9:	55                   	push   %ebp
  801eca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801ecc:	6a 00                	push   $0x0
  801ece:	6a 00                	push   $0x0
  801ed0:	6a 00                	push   $0x0
  801ed2:	6a 00                	push   $0x0
  801ed4:	6a 00                	push   $0x0
  801ed6:	6a 0b                	push   $0xb
  801ed8:	e8 ce fe ff ff       	call   801dab <syscall>
  801edd:	83 c4 18             	add    $0x18,%esp
}
  801ee0:	c9                   	leave  
  801ee1:	c3                   	ret    

00801ee2 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801ee2:	55                   	push   %ebp
  801ee3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801ee5:	6a 00                	push   $0x0
  801ee7:	6a 00                	push   $0x0
  801ee9:	6a 00                	push   $0x0
  801eeb:	ff 75 0c             	pushl  0xc(%ebp)
  801eee:	ff 75 08             	pushl  0x8(%ebp)
  801ef1:	6a 0f                	push   $0xf
  801ef3:	e8 b3 fe ff ff       	call   801dab <syscall>
  801ef8:	83 c4 18             	add    $0x18,%esp
	return;
  801efb:	90                   	nop
}
  801efc:	c9                   	leave  
  801efd:	c3                   	ret    

00801efe <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801efe:	55                   	push   %ebp
  801eff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801f01:	6a 00                	push   $0x0
  801f03:	6a 00                	push   $0x0
  801f05:	6a 00                	push   $0x0
  801f07:	ff 75 0c             	pushl  0xc(%ebp)
  801f0a:	ff 75 08             	pushl  0x8(%ebp)
  801f0d:	6a 10                	push   $0x10
  801f0f:	e8 97 fe ff ff       	call   801dab <syscall>
  801f14:	83 c4 18             	add    $0x18,%esp
	return ;
  801f17:	90                   	nop
}
  801f18:	c9                   	leave  
  801f19:	c3                   	ret    

00801f1a <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801f1a:	55                   	push   %ebp
  801f1b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801f1d:	6a 00                	push   $0x0
  801f1f:	6a 00                	push   $0x0
  801f21:	ff 75 10             	pushl  0x10(%ebp)
  801f24:	ff 75 0c             	pushl  0xc(%ebp)
  801f27:	ff 75 08             	pushl  0x8(%ebp)
  801f2a:	6a 11                	push   $0x11
  801f2c:	e8 7a fe ff ff       	call   801dab <syscall>
  801f31:	83 c4 18             	add    $0x18,%esp
	return ;
  801f34:	90                   	nop
}
  801f35:	c9                   	leave  
  801f36:	c3                   	ret    

00801f37 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801f37:	55                   	push   %ebp
  801f38:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801f3a:	6a 00                	push   $0x0
  801f3c:	6a 00                	push   $0x0
  801f3e:	6a 00                	push   $0x0
  801f40:	6a 00                	push   $0x0
  801f42:	6a 00                	push   $0x0
  801f44:	6a 0c                	push   $0xc
  801f46:	e8 60 fe ff ff       	call   801dab <syscall>
  801f4b:	83 c4 18             	add    $0x18,%esp
}
  801f4e:	c9                   	leave  
  801f4f:	c3                   	ret    

00801f50 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801f50:	55                   	push   %ebp
  801f51:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801f53:	6a 00                	push   $0x0
  801f55:	6a 00                	push   $0x0
  801f57:	6a 00                	push   $0x0
  801f59:	6a 00                	push   $0x0
  801f5b:	ff 75 08             	pushl  0x8(%ebp)
  801f5e:	6a 0d                	push   $0xd
  801f60:	e8 46 fe ff ff       	call   801dab <syscall>
  801f65:	83 c4 18             	add    $0x18,%esp
}
  801f68:	c9                   	leave  
  801f69:	c3                   	ret    

00801f6a <sys_scarce_memory>:

void sys_scarce_memory()
{
  801f6a:	55                   	push   %ebp
  801f6b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801f6d:	6a 00                	push   $0x0
  801f6f:	6a 00                	push   $0x0
  801f71:	6a 00                	push   $0x0
  801f73:	6a 00                	push   $0x0
  801f75:	6a 00                	push   $0x0
  801f77:	6a 0e                	push   $0xe
  801f79:	e8 2d fe ff ff       	call   801dab <syscall>
  801f7e:	83 c4 18             	add    $0x18,%esp
}
  801f81:	90                   	nop
  801f82:	c9                   	leave  
  801f83:	c3                   	ret    

00801f84 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801f84:	55                   	push   %ebp
  801f85:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801f87:	6a 00                	push   $0x0
  801f89:	6a 00                	push   $0x0
  801f8b:	6a 00                	push   $0x0
  801f8d:	6a 00                	push   $0x0
  801f8f:	6a 00                	push   $0x0
  801f91:	6a 13                	push   $0x13
  801f93:	e8 13 fe ff ff       	call   801dab <syscall>
  801f98:	83 c4 18             	add    $0x18,%esp
}
  801f9b:	90                   	nop
  801f9c:	c9                   	leave  
  801f9d:	c3                   	ret    

00801f9e <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801f9e:	55                   	push   %ebp
  801f9f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801fa1:	6a 00                	push   $0x0
  801fa3:	6a 00                	push   $0x0
  801fa5:	6a 00                	push   $0x0
  801fa7:	6a 00                	push   $0x0
  801fa9:	6a 00                	push   $0x0
  801fab:	6a 14                	push   $0x14
  801fad:	e8 f9 fd ff ff       	call   801dab <syscall>
  801fb2:	83 c4 18             	add    $0x18,%esp
}
  801fb5:	90                   	nop
  801fb6:	c9                   	leave  
  801fb7:	c3                   	ret    

00801fb8 <sys_cputc>:


void
sys_cputc(const char c)
{
  801fb8:	55                   	push   %ebp
  801fb9:	89 e5                	mov    %esp,%ebp
  801fbb:	83 ec 04             	sub    $0x4,%esp
  801fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801fc4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801fc8:	6a 00                	push   $0x0
  801fca:	6a 00                	push   $0x0
  801fcc:	6a 00                	push   $0x0
  801fce:	6a 00                	push   $0x0
  801fd0:	50                   	push   %eax
  801fd1:	6a 15                	push   $0x15
  801fd3:	e8 d3 fd ff ff       	call   801dab <syscall>
  801fd8:	83 c4 18             	add    $0x18,%esp
}
  801fdb:	90                   	nop
  801fdc:	c9                   	leave  
  801fdd:	c3                   	ret    

00801fde <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801fde:	55                   	push   %ebp
  801fdf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801fe1:	6a 00                	push   $0x0
  801fe3:	6a 00                	push   $0x0
  801fe5:	6a 00                	push   $0x0
  801fe7:	6a 00                	push   $0x0
  801fe9:	6a 00                	push   $0x0
  801feb:	6a 16                	push   $0x16
  801fed:	e8 b9 fd ff ff       	call   801dab <syscall>
  801ff2:	83 c4 18             	add    $0x18,%esp
}
  801ff5:	90                   	nop
  801ff6:	c9                   	leave  
  801ff7:	c3                   	ret    

00801ff8 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801ff8:	55                   	push   %ebp
  801ff9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801ffb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffe:	6a 00                	push   $0x0
  802000:	6a 00                	push   $0x0
  802002:	6a 00                	push   $0x0
  802004:	ff 75 0c             	pushl  0xc(%ebp)
  802007:	50                   	push   %eax
  802008:	6a 17                	push   $0x17
  80200a:	e8 9c fd ff ff       	call   801dab <syscall>
  80200f:	83 c4 18             	add    $0x18,%esp
}
  802012:	c9                   	leave  
  802013:	c3                   	ret    

00802014 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802014:	55                   	push   %ebp
  802015:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802017:	8b 55 0c             	mov    0xc(%ebp),%edx
  80201a:	8b 45 08             	mov    0x8(%ebp),%eax
  80201d:	6a 00                	push   $0x0
  80201f:	6a 00                	push   $0x0
  802021:	6a 00                	push   $0x0
  802023:	52                   	push   %edx
  802024:	50                   	push   %eax
  802025:	6a 1a                	push   $0x1a
  802027:	e8 7f fd ff ff       	call   801dab <syscall>
  80202c:	83 c4 18             	add    $0x18,%esp
}
  80202f:	c9                   	leave  
  802030:	c3                   	ret    

00802031 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802031:	55                   	push   %ebp
  802032:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802034:	8b 55 0c             	mov    0xc(%ebp),%edx
  802037:	8b 45 08             	mov    0x8(%ebp),%eax
  80203a:	6a 00                	push   $0x0
  80203c:	6a 00                	push   $0x0
  80203e:	6a 00                	push   $0x0
  802040:	52                   	push   %edx
  802041:	50                   	push   %eax
  802042:	6a 18                	push   $0x18
  802044:	e8 62 fd ff ff       	call   801dab <syscall>
  802049:	83 c4 18             	add    $0x18,%esp
}
  80204c:	90                   	nop
  80204d:	c9                   	leave  
  80204e:	c3                   	ret    

0080204f <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80204f:	55                   	push   %ebp
  802050:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802052:	8b 55 0c             	mov    0xc(%ebp),%edx
  802055:	8b 45 08             	mov    0x8(%ebp),%eax
  802058:	6a 00                	push   $0x0
  80205a:	6a 00                	push   $0x0
  80205c:	6a 00                	push   $0x0
  80205e:	52                   	push   %edx
  80205f:	50                   	push   %eax
  802060:	6a 19                	push   $0x19
  802062:	e8 44 fd ff ff       	call   801dab <syscall>
  802067:	83 c4 18             	add    $0x18,%esp
}
  80206a:	90                   	nop
  80206b:	c9                   	leave  
  80206c:	c3                   	ret    

0080206d <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80206d:	55                   	push   %ebp
  80206e:	89 e5                	mov    %esp,%ebp
  802070:	83 ec 04             	sub    $0x4,%esp
  802073:	8b 45 10             	mov    0x10(%ebp),%eax
  802076:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802079:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80207c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802080:	8b 45 08             	mov    0x8(%ebp),%eax
  802083:	6a 00                	push   $0x0
  802085:	51                   	push   %ecx
  802086:	52                   	push   %edx
  802087:	ff 75 0c             	pushl  0xc(%ebp)
  80208a:	50                   	push   %eax
  80208b:	6a 1b                	push   $0x1b
  80208d:	e8 19 fd ff ff       	call   801dab <syscall>
  802092:	83 c4 18             	add    $0x18,%esp
}
  802095:	c9                   	leave  
  802096:	c3                   	ret    

00802097 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802097:	55                   	push   %ebp
  802098:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80209a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80209d:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a0:	6a 00                	push   $0x0
  8020a2:	6a 00                	push   $0x0
  8020a4:	6a 00                	push   $0x0
  8020a6:	52                   	push   %edx
  8020a7:	50                   	push   %eax
  8020a8:	6a 1c                	push   $0x1c
  8020aa:	e8 fc fc ff ff       	call   801dab <syscall>
  8020af:	83 c4 18             	add    $0x18,%esp
}
  8020b2:	c9                   	leave  
  8020b3:	c3                   	ret    

008020b4 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8020b4:	55                   	push   %ebp
  8020b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8020b7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c0:	6a 00                	push   $0x0
  8020c2:	6a 00                	push   $0x0
  8020c4:	51                   	push   %ecx
  8020c5:	52                   	push   %edx
  8020c6:	50                   	push   %eax
  8020c7:	6a 1d                	push   $0x1d
  8020c9:	e8 dd fc ff ff       	call   801dab <syscall>
  8020ce:	83 c4 18             	add    $0x18,%esp
}
  8020d1:	c9                   	leave  
  8020d2:	c3                   	ret    

008020d3 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8020d3:	55                   	push   %ebp
  8020d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8020d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020dc:	6a 00                	push   $0x0
  8020de:	6a 00                	push   $0x0
  8020e0:	6a 00                	push   $0x0
  8020e2:	52                   	push   %edx
  8020e3:	50                   	push   %eax
  8020e4:	6a 1e                	push   $0x1e
  8020e6:	e8 c0 fc ff ff       	call   801dab <syscall>
  8020eb:	83 c4 18             	add    $0x18,%esp
}
  8020ee:	c9                   	leave  
  8020ef:	c3                   	ret    

008020f0 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8020f0:	55                   	push   %ebp
  8020f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8020f3:	6a 00                	push   $0x0
  8020f5:	6a 00                	push   $0x0
  8020f7:	6a 00                	push   $0x0
  8020f9:	6a 00                	push   $0x0
  8020fb:	6a 00                	push   $0x0
  8020fd:	6a 1f                	push   $0x1f
  8020ff:	e8 a7 fc ff ff       	call   801dab <syscall>
  802104:	83 c4 18             	add    $0x18,%esp
}
  802107:	c9                   	leave  
  802108:	c3                   	ret    

00802109 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802109:	55                   	push   %ebp
  80210a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80210c:	8b 45 08             	mov    0x8(%ebp),%eax
  80210f:	6a 00                	push   $0x0
  802111:	ff 75 14             	pushl  0x14(%ebp)
  802114:	ff 75 10             	pushl  0x10(%ebp)
  802117:	ff 75 0c             	pushl  0xc(%ebp)
  80211a:	50                   	push   %eax
  80211b:	6a 20                	push   $0x20
  80211d:	e8 89 fc ff ff       	call   801dab <syscall>
  802122:	83 c4 18             	add    $0x18,%esp
}
  802125:	c9                   	leave  
  802126:	c3                   	ret    

00802127 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802127:	55                   	push   %ebp
  802128:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80212a:	8b 45 08             	mov    0x8(%ebp),%eax
  80212d:	6a 00                	push   $0x0
  80212f:	6a 00                	push   $0x0
  802131:	6a 00                	push   $0x0
  802133:	6a 00                	push   $0x0
  802135:	50                   	push   %eax
  802136:	6a 21                	push   $0x21
  802138:	e8 6e fc ff ff       	call   801dab <syscall>
  80213d:	83 c4 18             	add    $0x18,%esp
}
  802140:	90                   	nop
  802141:	c9                   	leave  
  802142:	c3                   	ret    

00802143 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802143:	55                   	push   %ebp
  802144:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802146:	8b 45 08             	mov    0x8(%ebp),%eax
  802149:	6a 00                	push   $0x0
  80214b:	6a 00                	push   $0x0
  80214d:	6a 00                	push   $0x0
  80214f:	6a 00                	push   $0x0
  802151:	50                   	push   %eax
  802152:	6a 22                	push   $0x22
  802154:	e8 52 fc ff ff       	call   801dab <syscall>
  802159:	83 c4 18             	add    $0x18,%esp
}
  80215c:	c9                   	leave  
  80215d:	c3                   	ret    

0080215e <sys_getenvid>:

int32 sys_getenvid(void)
{
  80215e:	55                   	push   %ebp
  80215f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802161:	6a 00                	push   $0x0
  802163:	6a 00                	push   $0x0
  802165:	6a 00                	push   $0x0
  802167:	6a 00                	push   $0x0
  802169:	6a 00                	push   $0x0
  80216b:	6a 02                	push   $0x2
  80216d:	e8 39 fc ff ff       	call   801dab <syscall>
  802172:	83 c4 18             	add    $0x18,%esp
}
  802175:	c9                   	leave  
  802176:	c3                   	ret    

00802177 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802177:	55                   	push   %ebp
  802178:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80217a:	6a 00                	push   $0x0
  80217c:	6a 00                	push   $0x0
  80217e:	6a 00                	push   $0x0
  802180:	6a 00                	push   $0x0
  802182:	6a 00                	push   $0x0
  802184:	6a 03                	push   $0x3
  802186:	e8 20 fc ff ff       	call   801dab <syscall>
  80218b:	83 c4 18             	add    $0x18,%esp
}
  80218e:	c9                   	leave  
  80218f:	c3                   	ret    

00802190 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802190:	55                   	push   %ebp
  802191:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802193:	6a 00                	push   $0x0
  802195:	6a 00                	push   $0x0
  802197:	6a 00                	push   $0x0
  802199:	6a 00                	push   $0x0
  80219b:	6a 00                	push   $0x0
  80219d:	6a 04                	push   $0x4
  80219f:	e8 07 fc ff ff       	call   801dab <syscall>
  8021a4:	83 c4 18             	add    $0x18,%esp
}
  8021a7:	c9                   	leave  
  8021a8:	c3                   	ret    

008021a9 <sys_exit_env>:


void sys_exit_env(void)
{
  8021a9:	55                   	push   %ebp
  8021aa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8021ac:	6a 00                	push   $0x0
  8021ae:	6a 00                	push   $0x0
  8021b0:	6a 00                	push   $0x0
  8021b2:	6a 00                	push   $0x0
  8021b4:	6a 00                	push   $0x0
  8021b6:	6a 23                	push   $0x23
  8021b8:	e8 ee fb ff ff       	call   801dab <syscall>
  8021bd:	83 c4 18             	add    $0x18,%esp
}
  8021c0:	90                   	nop
  8021c1:	c9                   	leave  
  8021c2:	c3                   	ret    

008021c3 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8021c3:	55                   	push   %ebp
  8021c4:	89 e5                	mov    %esp,%ebp
  8021c6:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8021c9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8021cc:	8d 50 04             	lea    0x4(%eax),%edx
  8021cf:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8021d2:	6a 00                	push   $0x0
  8021d4:	6a 00                	push   $0x0
  8021d6:	6a 00                	push   $0x0
  8021d8:	52                   	push   %edx
  8021d9:	50                   	push   %eax
  8021da:	6a 24                	push   $0x24
  8021dc:	e8 ca fb ff ff       	call   801dab <syscall>
  8021e1:	83 c4 18             	add    $0x18,%esp
	return result;
  8021e4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8021e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021ea:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8021ed:	89 01                	mov    %eax,(%ecx)
  8021ef:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8021f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f5:	c9                   	leave  
  8021f6:	c2 04 00             	ret    $0x4

008021f9 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8021f9:	55                   	push   %ebp
  8021fa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8021fc:	6a 00                	push   $0x0
  8021fe:	6a 00                	push   $0x0
  802200:	ff 75 10             	pushl  0x10(%ebp)
  802203:	ff 75 0c             	pushl  0xc(%ebp)
  802206:	ff 75 08             	pushl  0x8(%ebp)
  802209:	6a 12                	push   $0x12
  80220b:	e8 9b fb ff ff       	call   801dab <syscall>
  802210:	83 c4 18             	add    $0x18,%esp
	return ;
  802213:	90                   	nop
}
  802214:	c9                   	leave  
  802215:	c3                   	ret    

00802216 <sys_rcr2>:
uint32 sys_rcr2()
{
  802216:	55                   	push   %ebp
  802217:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802219:	6a 00                	push   $0x0
  80221b:	6a 00                	push   $0x0
  80221d:	6a 00                	push   $0x0
  80221f:	6a 00                	push   $0x0
  802221:	6a 00                	push   $0x0
  802223:	6a 25                	push   $0x25
  802225:	e8 81 fb ff ff       	call   801dab <syscall>
  80222a:	83 c4 18             	add    $0x18,%esp
}
  80222d:	c9                   	leave  
  80222e:	c3                   	ret    

0080222f <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80222f:	55                   	push   %ebp
  802230:	89 e5                	mov    %esp,%ebp
  802232:	83 ec 04             	sub    $0x4,%esp
  802235:	8b 45 08             	mov    0x8(%ebp),%eax
  802238:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80223b:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80223f:	6a 00                	push   $0x0
  802241:	6a 00                	push   $0x0
  802243:	6a 00                	push   $0x0
  802245:	6a 00                	push   $0x0
  802247:	50                   	push   %eax
  802248:	6a 26                	push   $0x26
  80224a:	e8 5c fb ff ff       	call   801dab <syscall>
  80224f:	83 c4 18             	add    $0x18,%esp
	return ;
  802252:	90                   	nop
}
  802253:	c9                   	leave  
  802254:	c3                   	ret    

00802255 <rsttst>:
void rsttst()
{
  802255:	55                   	push   %ebp
  802256:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802258:	6a 00                	push   $0x0
  80225a:	6a 00                	push   $0x0
  80225c:	6a 00                	push   $0x0
  80225e:	6a 00                	push   $0x0
  802260:	6a 00                	push   $0x0
  802262:	6a 28                	push   $0x28
  802264:	e8 42 fb ff ff       	call   801dab <syscall>
  802269:	83 c4 18             	add    $0x18,%esp
	return ;
  80226c:	90                   	nop
}
  80226d:	c9                   	leave  
  80226e:	c3                   	ret    

0080226f <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80226f:	55                   	push   %ebp
  802270:	89 e5                	mov    %esp,%ebp
  802272:	83 ec 04             	sub    $0x4,%esp
  802275:	8b 45 14             	mov    0x14(%ebp),%eax
  802278:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80227b:	8b 55 18             	mov    0x18(%ebp),%edx
  80227e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802282:	52                   	push   %edx
  802283:	50                   	push   %eax
  802284:	ff 75 10             	pushl  0x10(%ebp)
  802287:	ff 75 0c             	pushl  0xc(%ebp)
  80228a:	ff 75 08             	pushl  0x8(%ebp)
  80228d:	6a 27                	push   $0x27
  80228f:	e8 17 fb ff ff       	call   801dab <syscall>
  802294:	83 c4 18             	add    $0x18,%esp
	return ;
  802297:	90                   	nop
}
  802298:	c9                   	leave  
  802299:	c3                   	ret    

0080229a <chktst>:
void chktst(uint32 n)
{
  80229a:	55                   	push   %ebp
  80229b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80229d:	6a 00                	push   $0x0
  80229f:	6a 00                	push   $0x0
  8022a1:	6a 00                	push   $0x0
  8022a3:	6a 00                	push   $0x0
  8022a5:	ff 75 08             	pushl  0x8(%ebp)
  8022a8:	6a 29                	push   $0x29
  8022aa:	e8 fc fa ff ff       	call   801dab <syscall>
  8022af:	83 c4 18             	add    $0x18,%esp
	return ;
  8022b2:	90                   	nop
}
  8022b3:	c9                   	leave  
  8022b4:	c3                   	ret    

008022b5 <inctst>:

void inctst()
{
  8022b5:	55                   	push   %ebp
  8022b6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8022b8:	6a 00                	push   $0x0
  8022ba:	6a 00                	push   $0x0
  8022bc:	6a 00                	push   $0x0
  8022be:	6a 00                	push   $0x0
  8022c0:	6a 00                	push   $0x0
  8022c2:	6a 2a                	push   $0x2a
  8022c4:	e8 e2 fa ff ff       	call   801dab <syscall>
  8022c9:	83 c4 18             	add    $0x18,%esp
	return ;
  8022cc:	90                   	nop
}
  8022cd:	c9                   	leave  
  8022ce:	c3                   	ret    

008022cf <gettst>:
uint32 gettst()
{
  8022cf:	55                   	push   %ebp
  8022d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8022d2:	6a 00                	push   $0x0
  8022d4:	6a 00                	push   $0x0
  8022d6:	6a 00                	push   $0x0
  8022d8:	6a 00                	push   $0x0
  8022da:	6a 00                	push   $0x0
  8022dc:	6a 2b                	push   $0x2b
  8022de:	e8 c8 fa ff ff       	call   801dab <syscall>
  8022e3:	83 c4 18             	add    $0x18,%esp
}
  8022e6:	c9                   	leave  
  8022e7:	c3                   	ret    

008022e8 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8022e8:	55                   	push   %ebp
  8022e9:	89 e5                	mov    %esp,%ebp
  8022eb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8022ee:	6a 00                	push   $0x0
  8022f0:	6a 00                	push   $0x0
  8022f2:	6a 00                	push   $0x0
  8022f4:	6a 00                	push   $0x0
  8022f6:	6a 00                	push   $0x0
  8022f8:	6a 2c                	push   $0x2c
  8022fa:	e8 ac fa ff ff       	call   801dab <syscall>
  8022ff:	83 c4 18             	add    $0x18,%esp
  802302:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802305:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802309:	75 07                	jne    802312 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80230b:	b8 01 00 00 00       	mov    $0x1,%eax
  802310:	eb 05                	jmp    802317 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802312:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802317:	c9                   	leave  
  802318:	c3                   	ret    

00802319 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802319:	55                   	push   %ebp
  80231a:	89 e5                	mov    %esp,%ebp
  80231c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80231f:	6a 00                	push   $0x0
  802321:	6a 00                	push   $0x0
  802323:	6a 00                	push   $0x0
  802325:	6a 00                	push   $0x0
  802327:	6a 00                	push   $0x0
  802329:	6a 2c                	push   $0x2c
  80232b:	e8 7b fa ff ff       	call   801dab <syscall>
  802330:	83 c4 18             	add    $0x18,%esp
  802333:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802336:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80233a:	75 07                	jne    802343 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80233c:	b8 01 00 00 00       	mov    $0x1,%eax
  802341:	eb 05                	jmp    802348 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802343:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802348:	c9                   	leave  
  802349:	c3                   	ret    

0080234a <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80234a:	55                   	push   %ebp
  80234b:	89 e5                	mov    %esp,%ebp
  80234d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802350:	6a 00                	push   $0x0
  802352:	6a 00                	push   $0x0
  802354:	6a 00                	push   $0x0
  802356:	6a 00                	push   $0x0
  802358:	6a 00                	push   $0x0
  80235a:	6a 2c                	push   $0x2c
  80235c:	e8 4a fa ff ff       	call   801dab <syscall>
  802361:	83 c4 18             	add    $0x18,%esp
  802364:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802367:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80236b:	75 07                	jne    802374 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80236d:	b8 01 00 00 00       	mov    $0x1,%eax
  802372:	eb 05                	jmp    802379 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802374:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802379:	c9                   	leave  
  80237a:	c3                   	ret    

0080237b <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80237b:	55                   	push   %ebp
  80237c:	89 e5                	mov    %esp,%ebp
  80237e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802381:	6a 00                	push   $0x0
  802383:	6a 00                	push   $0x0
  802385:	6a 00                	push   $0x0
  802387:	6a 00                	push   $0x0
  802389:	6a 00                	push   $0x0
  80238b:	6a 2c                	push   $0x2c
  80238d:	e8 19 fa ff ff       	call   801dab <syscall>
  802392:	83 c4 18             	add    $0x18,%esp
  802395:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802398:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80239c:	75 07                	jne    8023a5 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80239e:	b8 01 00 00 00       	mov    $0x1,%eax
  8023a3:	eb 05                	jmp    8023aa <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8023a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023aa:	c9                   	leave  
  8023ab:	c3                   	ret    

008023ac <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8023ac:	55                   	push   %ebp
  8023ad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8023af:	6a 00                	push   $0x0
  8023b1:	6a 00                	push   $0x0
  8023b3:	6a 00                	push   $0x0
  8023b5:	6a 00                	push   $0x0
  8023b7:	ff 75 08             	pushl  0x8(%ebp)
  8023ba:	6a 2d                	push   $0x2d
  8023bc:	e8 ea f9 ff ff       	call   801dab <syscall>
  8023c1:	83 c4 18             	add    $0x18,%esp
	return ;
  8023c4:	90                   	nop
}
  8023c5:	c9                   	leave  
  8023c6:	c3                   	ret    

008023c7 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8023c7:	55                   	push   %ebp
  8023c8:	89 e5                	mov    %esp,%ebp
  8023ca:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8023cb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8023ce:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8023d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d7:	6a 00                	push   $0x0
  8023d9:	53                   	push   %ebx
  8023da:	51                   	push   %ecx
  8023db:	52                   	push   %edx
  8023dc:	50                   	push   %eax
  8023dd:	6a 2e                	push   $0x2e
  8023df:	e8 c7 f9 ff ff       	call   801dab <syscall>
  8023e4:	83 c4 18             	add    $0x18,%esp
}
  8023e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023ea:	c9                   	leave  
  8023eb:	c3                   	ret    

008023ec <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8023ec:	55                   	push   %ebp
  8023ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8023ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f5:	6a 00                	push   $0x0
  8023f7:	6a 00                	push   $0x0
  8023f9:	6a 00                	push   $0x0
  8023fb:	52                   	push   %edx
  8023fc:	50                   	push   %eax
  8023fd:	6a 2f                	push   $0x2f
  8023ff:	e8 a7 f9 ff ff       	call   801dab <syscall>
  802404:	83 c4 18             	add    $0x18,%esp
}
  802407:	c9                   	leave  
  802408:	c3                   	ret    

00802409 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802409:	55                   	push   %ebp
  80240a:	89 e5                	mov    %esp,%ebp
  80240c:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  80240f:	83 ec 0c             	sub    $0xc,%esp
  802412:	68 5c 45 80 00       	push   $0x80455c
  802417:	e8 18 e6 ff ff       	call   800a34 <cprintf>
  80241c:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80241f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802426:	83 ec 0c             	sub    $0xc,%esp
  802429:	68 88 45 80 00       	push   $0x804588
  80242e:	e8 01 e6 ff ff       	call   800a34 <cprintf>
  802433:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802436:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80243a:	a1 38 51 80 00       	mov    0x805138,%eax
  80243f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802442:	eb 56                	jmp    80249a <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802444:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802448:	74 1c                	je     802466 <print_mem_block_lists+0x5d>
  80244a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244d:	8b 50 08             	mov    0x8(%eax),%edx
  802450:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802453:	8b 48 08             	mov    0x8(%eax),%ecx
  802456:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802459:	8b 40 0c             	mov    0xc(%eax),%eax
  80245c:	01 c8                	add    %ecx,%eax
  80245e:	39 c2                	cmp    %eax,%edx
  802460:	73 04                	jae    802466 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802462:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802466:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802469:	8b 50 08             	mov    0x8(%eax),%edx
  80246c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246f:	8b 40 0c             	mov    0xc(%eax),%eax
  802472:	01 c2                	add    %eax,%edx
  802474:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802477:	8b 40 08             	mov    0x8(%eax),%eax
  80247a:	83 ec 04             	sub    $0x4,%esp
  80247d:	52                   	push   %edx
  80247e:	50                   	push   %eax
  80247f:	68 9d 45 80 00       	push   $0x80459d
  802484:	e8 ab e5 ff ff       	call   800a34 <cprintf>
  802489:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80248c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802492:	a1 40 51 80 00       	mov    0x805140,%eax
  802497:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80249a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80249e:	74 07                	je     8024a7 <print_mem_block_lists+0x9e>
  8024a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a3:	8b 00                	mov    (%eax),%eax
  8024a5:	eb 05                	jmp    8024ac <print_mem_block_lists+0xa3>
  8024a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8024ac:	a3 40 51 80 00       	mov    %eax,0x805140
  8024b1:	a1 40 51 80 00       	mov    0x805140,%eax
  8024b6:	85 c0                	test   %eax,%eax
  8024b8:	75 8a                	jne    802444 <print_mem_block_lists+0x3b>
  8024ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024be:	75 84                	jne    802444 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8024c0:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8024c4:	75 10                	jne    8024d6 <print_mem_block_lists+0xcd>
  8024c6:	83 ec 0c             	sub    $0xc,%esp
  8024c9:	68 ac 45 80 00       	push   $0x8045ac
  8024ce:	e8 61 e5 ff ff       	call   800a34 <cprintf>
  8024d3:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8024d6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8024dd:	83 ec 0c             	sub    $0xc,%esp
  8024e0:	68 d0 45 80 00       	push   $0x8045d0
  8024e5:	e8 4a e5 ff ff       	call   800a34 <cprintf>
  8024ea:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8024ed:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8024f1:	a1 40 50 80 00       	mov    0x805040,%eax
  8024f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024f9:	eb 56                	jmp    802551 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8024fb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024ff:	74 1c                	je     80251d <print_mem_block_lists+0x114>
  802501:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802504:	8b 50 08             	mov    0x8(%eax),%edx
  802507:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80250a:	8b 48 08             	mov    0x8(%eax),%ecx
  80250d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802510:	8b 40 0c             	mov    0xc(%eax),%eax
  802513:	01 c8                	add    %ecx,%eax
  802515:	39 c2                	cmp    %eax,%edx
  802517:	73 04                	jae    80251d <print_mem_block_lists+0x114>
			sorted = 0 ;
  802519:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80251d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802520:	8b 50 08             	mov    0x8(%eax),%edx
  802523:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802526:	8b 40 0c             	mov    0xc(%eax),%eax
  802529:	01 c2                	add    %eax,%edx
  80252b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252e:	8b 40 08             	mov    0x8(%eax),%eax
  802531:	83 ec 04             	sub    $0x4,%esp
  802534:	52                   	push   %edx
  802535:	50                   	push   %eax
  802536:	68 9d 45 80 00       	push   $0x80459d
  80253b:	e8 f4 e4 ff ff       	call   800a34 <cprintf>
  802540:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802543:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802546:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802549:	a1 48 50 80 00       	mov    0x805048,%eax
  80254e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802551:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802555:	74 07                	je     80255e <print_mem_block_lists+0x155>
  802557:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255a:	8b 00                	mov    (%eax),%eax
  80255c:	eb 05                	jmp    802563 <print_mem_block_lists+0x15a>
  80255e:	b8 00 00 00 00       	mov    $0x0,%eax
  802563:	a3 48 50 80 00       	mov    %eax,0x805048
  802568:	a1 48 50 80 00       	mov    0x805048,%eax
  80256d:	85 c0                	test   %eax,%eax
  80256f:	75 8a                	jne    8024fb <print_mem_block_lists+0xf2>
  802571:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802575:	75 84                	jne    8024fb <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802577:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80257b:	75 10                	jne    80258d <print_mem_block_lists+0x184>
  80257d:	83 ec 0c             	sub    $0xc,%esp
  802580:	68 e8 45 80 00       	push   $0x8045e8
  802585:	e8 aa e4 ff ff       	call   800a34 <cprintf>
  80258a:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80258d:	83 ec 0c             	sub    $0xc,%esp
  802590:	68 5c 45 80 00       	push   $0x80455c
  802595:	e8 9a e4 ff ff       	call   800a34 <cprintf>
  80259a:	83 c4 10             	add    $0x10,%esp

}
  80259d:	90                   	nop
  80259e:	c9                   	leave  
  80259f:	c3                   	ret    

008025a0 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8025a0:	55                   	push   %ebp
  8025a1:	89 e5                	mov    %esp,%ebp
  8025a3:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  8025a6:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8025ad:	00 00 00 
  8025b0:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8025b7:	00 00 00 
  8025ba:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8025c1:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  8025c4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8025cb:	e9 9e 00 00 00       	jmp    80266e <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  8025d0:	a1 50 50 80 00       	mov    0x805050,%eax
  8025d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025d8:	c1 e2 04             	shl    $0x4,%edx
  8025db:	01 d0                	add    %edx,%eax
  8025dd:	85 c0                	test   %eax,%eax
  8025df:	75 14                	jne    8025f5 <initialize_MemBlocksList+0x55>
  8025e1:	83 ec 04             	sub    $0x4,%esp
  8025e4:	68 10 46 80 00       	push   $0x804610
  8025e9:	6a 46                	push   $0x46
  8025eb:	68 33 46 80 00       	push   $0x804633
  8025f0:	e8 8b e1 ff ff       	call   800780 <_panic>
  8025f5:	a1 50 50 80 00       	mov    0x805050,%eax
  8025fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025fd:	c1 e2 04             	shl    $0x4,%edx
  802600:	01 d0                	add    %edx,%eax
  802602:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802608:	89 10                	mov    %edx,(%eax)
  80260a:	8b 00                	mov    (%eax),%eax
  80260c:	85 c0                	test   %eax,%eax
  80260e:	74 18                	je     802628 <initialize_MemBlocksList+0x88>
  802610:	a1 48 51 80 00       	mov    0x805148,%eax
  802615:	8b 15 50 50 80 00    	mov    0x805050,%edx
  80261b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80261e:	c1 e1 04             	shl    $0x4,%ecx
  802621:	01 ca                	add    %ecx,%edx
  802623:	89 50 04             	mov    %edx,0x4(%eax)
  802626:	eb 12                	jmp    80263a <initialize_MemBlocksList+0x9a>
  802628:	a1 50 50 80 00       	mov    0x805050,%eax
  80262d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802630:	c1 e2 04             	shl    $0x4,%edx
  802633:	01 d0                	add    %edx,%eax
  802635:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80263a:	a1 50 50 80 00       	mov    0x805050,%eax
  80263f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802642:	c1 e2 04             	shl    $0x4,%edx
  802645:	01 d0                	add    %edx,%eax
  802647:	a3 48 51 80 00       	mov    %eax,0x805148
  80264c:	a1 50 50 80 00       	mov    0x805050,%eax
  802651:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802654:	c1 e2 04             	shl    $0x4,%edx
  802657:	01 d0                	add    %edx,%eax
  802659:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802660:	a1 54 51 80 00       	mov    0x805154,%eax
  802665:	40                   	inc    %eax
  802666:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  80266b:	ff 45 f4             	incl   -0xc(%ebp)
  80266e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802671:	3b 45 08             	cmp    0x8(%ebp),%eax
  802674:	0f 82 56 ff ff ff    	jb     8025d0 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  80267a:	90                   	nop
  80267b:	c9                   	leave  
  80267c:	c3                   	ret    

0080267d <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80267d:	55                   	push   %ebp
  80267e:	89 e5                	mov    %esp,%ebp
  802680:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802683:	8b 45 08             	mov    0x8(%ebp),%eax
  802686:	8b 00                	mov    (%eax),%eax
  802688:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80268b:	eb 19                	jmp    8026a6 <find_block+0x29>
	{
		if(va==point->sva)
  80268d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802690:	8b 40 08             	mov    0x8(%eax),%eax
  802693:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802696:	75 05                	jne    80269d <find_block+0x20>
		   return point;
  802698:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80269b:	eb 36                	jmp    8026d3 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80269d:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a0:	8b 40 08             	mov    0x8(%eax),%eax
  8026a3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8026a6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8026aa:	74 07                	je     8026b3 <find_block+0x36>
  8026ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8026af:	8b 00                	mov    (%eax),%eax
  8026b1:	eb 05                	jmp    8026b8 <find_block+0x3b>
  8026b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8026b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8026bb:	89 42 08             	mov    %eax,0x8(%edx)
  8026be:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c1:	8b 40 08             	mov    0x8(%eax),%eax
  8026c4:	85 c0                	test   %eax,%eax
  8026c6:	75 c5                	jne    80268d <find_block+0x10>
  8026c8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8026cc:	75 bf                	jne    80268d <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  8026ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026d3:	c9                   	leave  
  8026d4:	c3                   	ret    

008026d5 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8026d5:	55                   	push   %ebp
  8026d6:	89 e5                	mov    %esp,%ebp
  8026d8:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  8026db:	a1 40 50 80 00       	mov    0x805040,%eax
  8026e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  8026e3:	a1 44 50 80 00       	mov    0x805044,%eax
  8026e8:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8026eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026ee:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8026f1:	74 24                	je     802717 <insert_sorted_allocList+0x42>
  8026f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f6:	8b 50 08             	mov    0x8(%eax),%edx
  8026f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026fc:	8b 40 08             	mov    0x8(%eax),%eax
  8026ff:	39 c2                	cmp    %eax,%edx
  802701:	76 14                	jbe    802717 <insert_sorted_allocList+0x42>
  802703:	8b 45 08             	mov    0x8(%ebp),%eax
  802706:	8b 50 08             	mov    0x8(%eax),%edx
  802709:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80270c:	8b 40 08             	mov    0x8(%eax),%eax
  80270f:	39 c2                	cmp    %eax,%edx
  802711:	0f 82 60 01 00 00    	jb     802877 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802717:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80271b:	75 65                	jne    802782 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  80271d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802721:	75 14                	jne    802737 <insert_sorted_allocList+0x62>
  802723:	83 ec 04             	sub    $0x4,%esp
  802726:	68 10 46 80 00       	push   $0x804610
  80272b:	6a 6b                	push   $0x6b
  80272d:	68 33 46 80 00       	push   $0x804633
  802732:	e8 49 e0 ff ff       	call   800780 <_panic>
  802737:	8b 15 40 50 80 00    	mov    0x805040,%edx
  80273d:	8b 45 08             	mov    0x8(%ebp),%eax
  802740:	89 10                	mov    %edx,(%eax)
  802742:	8b 45 08             	mov    0x8(%ebp),%eax
  802745:	8b 00                	mov    (%eax),%eax
  802747:	85 c0                	test   %eax,%eax
  802749:	74 0d                	je     802758 <insert_sorted_allocList+0x83>
  80274b:	a1 40 50 80 00       	mov    0x805040,%eax
  802750:	8b 55 08             	mov    0x8(%ebp),%edx
  802753:	89 50 04             	mov    %edx,0x4(%eax)
  802756:	eb 08                	jmp    802760 <insert_sorted_allocList+0x8b>
  802758:	8b 45 08             	mov    0x8(%ebp),%eax
  80275b:	a3 44 50 80 00       	mov    %eax,0x805044
  802760:	8b 45 08             	mov    0x8(%ebp),%eax
  802763:	a3 40 50 80 00       	mov    %eax,0x805040
  802768:	8b 45 08             	mov    0x8(%ebp),%eax
  80276b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802772:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802777:	40                   	inc    %eax
  802778:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80277d:	e9 dc 01 00 00       	jmp    80295e <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802782:	8b 45 08             	mov    0x8(%ebp),%eax
  802785:	8b 50 08             	mov    0x8(%eax),%edx
  802788:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80278b:	8b 40 08             	mov    0x8(%eax),%eax
  80278e:	39 c2                	cmp    %eax,%edx
  802790:	77 6c                	ja     8027fe <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802792:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802796:	74 06                	je     80279e <insert_sorted_allocList+0xc9>
  802798:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80279c:	75 14                	jne    8027b2 <insert_sorted_allocList+0xdd>
  80279e:	83 ec 04             	sub    $0x4,%esp
  8027a1:	68 4c 46 80 00       	push   $0x80464c
  8027a6:	6a 6f                	push   $0x6f
  8027a8:	68 33 46 80 00       	push   $0x804633
  8027ad:	e8 ce df ff ff       	call   800780 <_panic>
  8027b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027b5:	8b 50 04             	mov    0x4(%eax),%edx
  8027b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8027bb:	89 50 04             	mov    %edx,0x4(%eax)
  8027be:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027c4:	89 10                	mov    %edx,(%eax)
  8027c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027c9:	8b 40 04             	mov    0x4(%eax),%eax
  8027cc:	85 c0                	test   %eax,%eax
  8027ce:	74 0d                	je     8027dd <insert_sorted_allocList+0x108>
  8027d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027d3:	8b 40 04             	mov    0x4(%eax),%eax
  8027d6:	8b 55 08             	mov    0x8(%ebp),%edx
  8027d9:	89 10                	mov    %edx,(%eax)
  8027db:	eb 08                	jmp    8027e5 <insert_sorted_allocList+0x110>
  8027dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e0:	a3 40 50 80 00       	mov    %eax,0x805040
  8027e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8027eb:	89 50 04             	mov    %edx,0x4(%eax)
  8027ee:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8027f3:	40                   	inc    %eax
  8027f4:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8027f9:	e9 60 01 00 00       	jmp    80295e <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8027fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802801:	8b 50 08             	mov    0x8(%eax),%edx
  802804:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802807:	8b 40 08             	mov    0x8(%eax),%eax
  80280a:	39 c2                	cmp    %eax,%edx
  80280c:	0f 82 4c 01 00 00    	jb     80295e <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802812:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802816:	75 14                	jne    80282c <insert_sorted_allocList+0x157>
  802818:	83 ec 04             	sub    $0x4,%esp
  80281b:	68 84 46 80 00       	push   $0x804684
  802820:	6a 73                	push   $0x73
  802822:	68 33 46 80 00       	push   $0x804633
  802827:	e8 54 df ff ff       	call   800780 <_panic>
  80282c:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802832:	8b 45 08             	mov    0x8(%ebp),%eax
  802835:	89 50 04             	mov    %edx,0x4(%eax)
  802838:	8b 45 08             	mov    0x8(%ebp),%eax
  80283b:	8b 40 04             	mov    0x4(%eax),%eax
  80283e:	85 c0                	test   %eax,%eax
  802840:	74 0c                	je     80284e <insert_sorted_allocList+0x179>
  802842:	a1 44 50 80 00       	mov    0x805044,%eax
  802847:	8b 55 08             	mov    0x8(%ebp),%edx
  80284a:	89 10                	mov    %edx,(%eax)
  80284c:	eb 08                	jmp    802856 <insert_sorted_allocList+0x181>
  80284e:	8b 45 08             	mov    0x8(%ebp),%eax
  802851:	a3 40 50 80 00       	mov    %eax,0x805040
  802856:	8b 45 08             	mov    0x8(%ebp),%eax
  802859:	a3 44 50 80 00       	mov    %eax,0x805044
  80285e:	8b 45 08             	mov    0x8(%ebp),%eax
  802861:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802867:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80286c:	40                   	inc    %eax
  80286d:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802872:	e9 e7 00 00 00       	jmp    80295e <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802877:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80287a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  80287d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802884:	a1 40 50 80 00       	mov    0x805040,%eax
  802889:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80288c:	e9 9d 00 00 00       	jmp    80292e <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802891:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802894:	8b 00                	mov    (%eax),%eax
  802896:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802899:	8b 45 08             	mov    0x8(%ebp),%eax
  80289c:	8b 50 08             	mov    0x8(%eax),%edx
  80289f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a2:	8b 40 08             	mov    0x8(%eax),%eax
  8028a5:	39 c2                	cmp    %eax,%edx
  8028a7:	76 7d                	jbe    802926 <insert_sorted_allocList+0x251>
  8028a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ac:	8b 50 08             	mov    0x8(%eax),%edx
  8028af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028b2:	8b 40 08             	mov    0x8(%eax),%eax
  8028b5:	39 c2                	cmp    %eax,%edx
  8028b7:	73 6d                	jae    802926 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8028b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028bd:	74 06                	je     8028c5 <insert_sorted_allocList+0x1f0>
  8028bf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028c3:	75 14                	jne    8028d9 <insert_sorted_allocList+0x204>
  8028c5:	83 ec 04             	sub    $0x4,%esp
  8028c8:	68 a8 46 80 00       	push   $0x8046a8
  8028cd:	6a 7f                	push   $0x7f
  8028cf:	68 33 46 80 00       	push   $0x804633
  8028d4:	e8 a7 de ff ff       	call   800780 <_panic>
  8028d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028dc:	8b 10                	mov    (%eax),%edx
  8028de:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e1:	89 10                	mov    %edx,(%eax)
  8028e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e6:	8b 00                	mov    (%eax),%eax
  8028e8:	85 c0                	test   %eax,%eax
  8028ea:	74 0b                	je     8028f7 <insert_sorted_allocList+0x222>
  8028ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ef:	8b 00                	mov    (%eax),%eax
  8028f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8028f4:	89 50 04             	mov    %edx,0x4(%eax)
  8028f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fa:	8b 55 08             	mov    0x8(%ebp),%edx
  8028fd:	89 10                	mov    %edx,(%eax)
  8028ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802902:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802905:	89 50 04             	mov    %edx,0x4(%eax)
  802908:	8b 45 08             	mov    0x8(%ebp),%eax
  80290b:	8b 00                	mov    (%eax),%eax
  80290d:	85 c0                	test   %eax,%eax
  80290f:	75 08                	jne    802919 <insert_sorted_allocList+0x244>
  802911:	8b 45 08             	mov    0x8(%ebp),%eax
  802914:	a3 44 50 80 00       	mov    %eax,0x805044
  802919:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80291e:	40                   	inc    %eax
  80291f:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802924:	eb 39                	jmp    80295f <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802926:	a1 48 50 80 00       	mov    0x805048,%eax
  80292b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80292e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802932:	74 07                	je     80293b <insert_sorted_allocList+0x266>
  802934:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802937:	8b 00                	mov    (%eax),%eax
  802939:	eb 05                	jmp    802940 <insert_sorted_allocList+0x26b>
  80293b:	b8 00 00 00 00       	mov    $0x0,%eax
  802940:	a3 48 50 80 00       	mov    %eax,0x805048
  802945:	a1 48 50 80 00       	mov    0x805048,%eax
  80294a:	85 c0                	test   %eax,%eax
  80294c:	0f 85 3f ff ff ff    	jne    802891 <insert_sorted_allocList+0x1bc>
  802952:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802956:	0f 85 35 ff ff ff    	jne    802891 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80295c:	eb 01                	jmp    80295f <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80295e:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80295f:	90                   	nop
  802960:	c9                   	leave  
  802961:	c3                   	ret    

00802962 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802962:	55                   	push   %ebp
  802963:	89 e5                	mov    %esp,%ebp
  802965:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802968:	a1 38 51 80 00       	mov    0x805138,%eax
  80296d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802970:	e9 85 01 00 00       	jmp    802afa <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802975:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802978:	8b 40 0c             	mov    0xc(%eax),%eax
  80297b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80297e:	0f 82 6e 01 00 00    	jb     802af2 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802984:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802987:	8b 40 0c             	mov    0xc(%eax),%eax
  80298a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80298d:	0f 85 8a 00 00 00    	jne    802a1d <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802993:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802997:	75 17                	jne    8029b0 <alloc_block_FF+0x4e>
  802999:	83 ec 04             	sub    $0x4,%esp
  80299c:	68 dc 46 80 00       	push   $0x8046dc
  8029a1:	68 93 00 00 00       	push   $0x93
  8029a6:	68 33 46 80 00       	push   $0x804633
  8029ab:	e8 d0 dd ff ff       	call   800780 <_panic>
  8029b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b3:	8b 00                	mov    (%eax),%eax
  8029b5:	85 c0                	test   %eax,%eax
  8029b7:	74 10                	je     8029c9 <alloc_block_FF+0x67>
  8029b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bc:	8b 00                	mov    (%eax),%eax
  8029be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029c1:	8b 52 04             	mov    0x4(%edx),%edx
  8029c4:	89 50 04             	mov    %edx,0x4(%eax)
  8029c7:	eb 0b                	jmp    8029d4 <alloc_block_FF+0x72>
  8029c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029cc:	8b 40 04             	mov    0x4(%eax),%eax
  8029cf:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8029d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d7:	8b 40 04             	mov    0x4(%eax),%eax
  8029da:	85 c0                	test   %eax,%eax
  8029dc:	74 0f                	je     8029ed <alloc_block_FF+0x8b>
  8029de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e1:	8b 40 04             	mov    0x4(%eax),%eax
  8029e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029e7:	8b 12                	mov    (%edx),%edx
  8029e9:	89 10                	mov    %edx,(%eax)
  8029eb:	eb 0a                	jmp    8029f7 <alloc_block_FF+0x95>
  8029ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f0:	8b 00                	mov    (%eax),%eax
  8029f2:	a3 38 51 80 00       	mov    %eax,0x805138
  8029f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a03:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a0a:	a1 44 51 80 00       	mov    0x805144,%eax
  802a0f:	48                   	dec    %eax
  802a10:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802a15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a18:	e9 10 01 00 00       	jmp    802b2d <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802a1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a20:	8b 40 0c             	mov    0xc(%eax),%eax
  802a23:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a26:	0f 86 c6 00 00 00    	jbe    802af2 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802a2c:	a1 48 51 80 00       	mov    0x805148,%eax
  802a31:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802a34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a37:	8b 50 08             	mov    0x8(%eax),%edx
  802a3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a3d:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802a40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a43:	8b 55 08             	mov    0x8(%ebp),%edx
  802a46:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802a49:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a4d:	75 17                	jne    802a66 <alloc_block_FF+0x104>
  802a4f:	83 ec 04             	sub    $0x4,%esp
  802a52:	68 dc 46 80 00       	push   $0x8046dc
  802a57:	68 9b 00 00 00       	push   $0x9b
  802a5c:	68 33 46 80 00       	push   $0x804633
  802a61:	e8 1a dd ff ff       	call   800780 <_panic>
  802a66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a69:	8b 00                	mov    (%eax),%eax
  802a6b:	85 c0                	test   %eax,%eax
  802a6d:	74 10                	je     802a7f <alloc_block_FF+0x11d>
  802a6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a72:	8b 00                	mov    (%eax),%eax
  802a74:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a77:	8b 52 04             	mov    0x4(%edx),%edx
  802a7a:	89 50 04             	mov    %edx,0x4(%eax)
  802a7d:	eb 0b                	jmp    802a8a <alloc_block_FF+0x128>
  802a7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a82:	8b 40 04             	mov    0x4(%eax),%eax
  802a85:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a8d:	8b 40 04             	mov    0x4(%eax),%eax
  802a90:	85 c0                	test   %eax,%eax
  802a92:	74 0f                	je     802aa3 <alloc_block_FF+0x141>
  802a94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a97:	8b 40 04             	mov    0x4(%eax),%eax
  802a9a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a9d:	8b 12                	mov    (%edx),%edx
  802a9f:	89 10                	mov    %edx,(%eax)
  802aa1:	eb 0a                	jmp    802aad <alloc_block_FF+0x14b>
  802aa3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aa6:	8b 00                	mov    (%eax),%eax
  802aa8:	a3 48 51 80 00       	mov    %eax,0x805148
  802aad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ab0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ab6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ab9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ac0:	a1 54 51 80 00       	mov    0x805154,%eax
  802ac5:	48                   	dec    %eax
  802ac6:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802acb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ace:	8b 50 08             	mov    0x8(%eax),%edx
  802ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad4:	01 c2                	add    %eax,%edx
  802ad6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad9:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802adc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802adf:	8b 40 0c             	mov    0xc(%eax),%eax
  802ae2:	2b 45 08             	sub    0x8(%ebp),%eax
  802ae5:	89 c2                	mov    %eax,%edx
  802ae7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aea:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802aed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802af0:	eb 3b                	jmp    802b2d <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802af2:	a1 40 51 80 00       	mov    0x805140,%eax
  802af7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802afa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802afe:	74 07                	je     802b07 <alloc_block_FF+0x1a5>
  802b00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b03:	8b 00                	mov    (%eax),%eax
  802b05:	eb 05                	jmp    802b0c <alloc_block_FF+0x1aa>
  802b07:	b8 00 00 00 00       	mov    $0x0,%eax
  802b0c:	a3 40 51 80 00       	mov    %eax,0x805140
  802b11:	a1 40 51 80 00       	mov    0x805140,%eax
  802b16:	85 c0                	test   %eax,%eax
  802b18:	0f 85 57 fe ff ff    	jne    802975 <alloc_block_FF+0x13>
  802b1e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b22:	0f 85 4d fe ff ff    	jne    802975 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802b28:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b2d:	c9                   	leave  
  802b2e:	c3                   	ret    

00802b2f <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802b2f:	55                   	push   %ebp
  802b30:	89 e5                	mov    %esp,%ebp
  802b32:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802b35:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802b3c:	a1 38 51 80 00       	mov    0x805138,%eax
  802b41:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b44:	e9 df 00 00 00       	jmp    802c28 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802b49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4c:	8b 40 0c             	mov    0xc(%eax),%eax
  802b4f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b52:	0f 82 c8 00 00 00    	jb     802c20 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802b58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5b:	8b 40 0c             	mov    0xc(%eax),%eax
  802b5e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b61:	0f 85 8a 00 00 00    	jne    802bf1 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802b67:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b6b:	75 17                	jne    802b84 <alloc_block_BF+0x55>
  802b6d:	83 ec 04             	sub    $0x4,%esp
  802b70:	68 dc 46 80 00       	push   $0x8046dc
  802b75:	68 b7 00 00 00       	push   $0xb7
  802b7a:	68 33 46 80 00       	push   $0x804633
  802b7f:	e8 fc db ff ff       	call   800780 <_panic>
  802b84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b87:	8b 00                	mov    (%eax),%eax
  802b89:	85 c0                	test   %eax,%eax
  802b8b:	74 10                	je     802b9d <alloc_block_BF+0x6e>
  802b8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b90:	8b 00                	mov    (%eax),%eax
  802b92:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b95:	8b 52 04             	mov    0x4(%edx),%edx
  802b98:	89 50 04             	mov    %edx,0x4(%eax)
  802b9b:	eb 0b                	jmp    802ba8 <alloc_block_BF+0x79>
  802b9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba0:	8b 40 04             	mov    0x4(%eax),%eax
  802ba3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ba8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bab:	8b 40 04             	mov    0x4(%eax),%eax
  802bae:	85 c0                	test   %eax,%eax
  802bb0:	74 0f                	je     802bc1 <alloc_block_BF+0x92>
  802bb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb5:	8b 40 04             	mov    0x4(%eax),%eax
  802bb8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bbb:	8b 12                	mov    (%edx),%edx
  802bbd:	89 10                	mov    %edx,(%eax)
  802bbf:	eb 0a                	jmp    802bcb <alloc_block_BF+0x9c>
  802bc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc4:	8b 00                	mov    (%eax),%eax
  802bc6:	a3 38 51 80 00       	mov    %eax,0x805138
  802bcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bde:	a1 44 51 80 00       	mov    0x805144,%eax
  802be3:	48                   	dec    %eax
  802be4:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802be9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bec:	e9 4d 01 00 00       	jmp    802d3e <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802bf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf4:	8b 40 0c             	mov    0xc(%eax),%eax
  802bf7:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bfa:	76 24                	jbe    802c20 <alloc_block_BF+0xf1>
  802bfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bff:	8b 40 0c             	mov    0xc(%eax),%eax
  802c02:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802c05:	73 19                	jae    802c20 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802c07:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802c0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c11:	8b 40 0c             	mov    0xc(%eax),%eax
  802c14:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802c17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1a:	8b 40 08             	mov    0x8(%eax),%eax
  802c1d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802c20:	a1 40 51 80 00       	mov    0x805140,%eax
  802c25:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c28:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c2c:	74 07                	je     802c35 <alloc_block_BF+0x106>
  802c2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c31:	8b 00                	mov    (%eax),%eax
  802c33:	eb 05                	jmp    802c3a <alloc_block_BF+0x10b>
  802c35:	b8 00 00 00 00       	mov    $0x0,%eax
  802c3a:	a3 40 51 80 00       	mov    %eax,0x805140
  802c3f:	a1 40 51 80 00       	mov    0x805140,%eax
  802c44:	85 c0                	test   %eax,%eax
  802c46:	0f 85 fd fe ff ff    	jne    802b49 <alloc_block_BF+0x1a>
  802c4c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c50:	0f 85 f3 fe ff ff    	jne    802b49 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802c56:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802c5a:	0f 84 d9 00 00 00    	je     802d39 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802c60:	a1 48 51 80 00       	mov    0x805148,%eax
  802c65:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802c68:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c6b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c6e:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802c71:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c74:	8b 55 08             	mov    0x8(%ebp),%edx
  802c77:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802c7a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802c7e:	75 17                	jne    802c97 <alloc_block_BF+0x168>
  802c80:	83 ec 04             	sub    $0x4,%esp
  802c83:	68 dc 46 80 00       	push   $0x8046dc
  802c88:	68 c7 00 00 00       	push   $0xc7
  802c8d:	68 33 46 80 00       	push   $0x804633
  802c92:	e8 e9 da ff ff       	call   800780 <_panic>
  802c97:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c9a:	8b 00                	mov    (%eax),%eax
  802c9c:	85 c0                	test   %eax,%eax
  802c9e:	74 10                	je     802cb0 <alloc_block_BF+0x181>
  802ca0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ca3:	8b 00                	mov    (%eax),%eax
  802ca5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802ca8:	8b 52 04             	mov    0x4(%edx),%edx
  802cab:	89 50 04             	mov    %edx,0x4(%eax)
  802cae:	eb 0b                	jmp    802cbb <alloc_block_BF+0x18c>
  802cb0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cb3:	8b 40 04             	mov    0x4(%eax),%eax
  802cb6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802cbb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cbe:	8b 40 04             	mov    0x4(%eax),%eax
  802cc1:	85 c0                	test   %eax,%eax
  802cc3:	74 0f                	je     802cd4 <alloc_block_BF+0x1a5>
  802cc5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cc8:	8b 40 04             	mov    0x4(%eax),%eax
  802ccb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802cce:	8b 12                	mov    (%edx),%edx
  802cd0:	89 10                	mov    %edx,(%eax)
  802cd2:	eb 0a                	jmp    802cde <alloc_block_BF+0x1af>
  802cd4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cd7:	8b 00                	mov    (%eax),%eax
  802cd9:	a3 48 51 80 00       	mov    %eax,0x805148
  802cde:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ce1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ce7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cea:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cf1:	a1 54 51 80 00       	mov    0x805154,%eax
  802cf6:	48                   	dec    %eax
  802cf7:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802cfc:	83 ec 08             	sub    $0x8,%esp
  802cff:	ff 75 ec             	pushl  -0x14(%ebp)
  802d02:	68 38 51 80 00       	push   $0x805138
  802d07:	e8 71 f9 ff ff       	call   80267d <find_block>
  802d0c:	83 c4 10             	add    $0x10,%esp
  802d0f:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802d12:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d15:	8b 50 08             	mov    0x8(%eax),%edx
  802d18:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1b:	01 c2                	add    %eax,%edx
  802d1d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d20:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802d23:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d26:	8b 40 0c             	mov    0xc(%eax),%eax
  802d29:	2b 45 08             	sub    0x8(%ebp),%eax
  802d2c:	89 c2                	mov    %eax,%edx
  802d2e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d31:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802d34:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d37:	eb 05                	jmp    802d3e <alloc_block_BF+0x20f>
	}
	return NULL;
  802d39:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d3e:	c9                   	leave  
  802d3f:	c3                   	ret    

00802d40 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802d40:	55                   	push   %ebp
  802d41:	89 e5                	mov    %esp,%ebp
  802d43:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802d46:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802d4b:	85 c0                	test   %eax,%eax
  802d4d:	0f 85 de 01 00 00    	jne    802f31 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802d53:	a1 38 51 80 00       	mov    0x805138,%eax
  802d58:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d5b:	e9 9e 01 00 00       	jmp    802efe <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802d60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d63:	8b 40 0c             	mov    0xc(%eax),%eax
  802d66:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d69:	0f 82 87 01 00 00    	jb     802ef6 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802d6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d72:	8b 40 0c             	mov    0xc(%eax),%eax
  802d75:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d78:	0f 85 95 00 00 00    	jne    802e13 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802d7e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d82:	75 17                	jne    802d9b <alloc_block_NF+0x5b>
  802d84:	83 ec 04             	sub    $0x4,%esp
  802d87:	68 dc 46 80 00       	push   $0x8046dc
  802d8c:	68 e0 00 00 00       	push   $0xe0
  802d91:	68 33 46 80 00       	push   $0x804633
  802d96:	e8 e5 d9 ff ff       	call   800780 <_panic>
  802d9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9e:	8b 00                	mov    (%eax),%eax
  802da0:	85 c0                	test   %eax,%eax
  802da2:	74 10                	je     802db4 <alloc_block_NF+0x74>
  802da4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da7:	8b 00                	mov    (%eax),%eax
  802da9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dac:	8b 52 04             	mov    0x4(%edx),%edx
  802daf:	89 50 04             	mov    %edx,0x4(%eax)
  802db2:	eb 0b                	jmp    802dbf <alloc_block_NF+0x7f>
  802db4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db7:	8b 40 04             	mov    0x4(%eax),%eax
  802dba:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802dbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc2:	8b 40 04             	mov    0x4(%eax),%eax
  802dc5:	85 c0                	test   %eax,%eax
  802dc7:	74 0f                	je     802dd8 <alloc_block_NF+0x98>
  802dc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dcc:	8b 40 04             	mov    0x4(%eax),%eax
  802dcf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dd2:	8b 12                	mov    (%edx),%edx
  802dd4:	89 10                	mov    %edx,(%eax)
  802dd6:	eb 0a                	jmp    802de2 <alloc_block_NF+0xa2>
  802dd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ddb:	8b 00                	mov    (%eax),%eax
  802ddd:	a3 38 51 80 00       	mov    %eax,0x805138
  802de2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802deb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dee:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802df5:	a1 44 51 80 00       	mov    0x805144,%eax
  802dfa:	48                   	dec    %eax
  802dfb:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802e00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e03:	8b 40 08             	mov    0x8(%eax),%eax
  802e06:	a3 2c 50 80 00       	mov    %eax,0x80502c
				   return  point;
  802e0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0e:	e9 f8 04 00 00       	jmp    80330b <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802e13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e16:	8b 40 0c             	mov    0xc(%eax),%eax
  802e19:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e1c:	0f 86 d4 00 00 00    	jbe    802ef6 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802e22:	a1 48 51 80 00       	mov    0x805148,%eax
  802e27:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802e2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2d:	8b 50 08             	mov    0x8(%eax),%edx
  802e30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e33:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802e36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e39:	8b 55 08             	mov    0x8(%ebp),%edx
  802e3c:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802e3f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e43:	75 17                	jne    802e5c <alloc_block_NF+0x11c>
  802e45:	83 ec 04             	sub    $0x4,%esp
  802e48:	68 dc 46 80 00       	push   $0x8046dc
  802e4d:	68 e9 00 00 00       	push   $0xe9
  802e52:	68 33 46 80 00       	push   $0x804633
  802e57:	e8 24 d9 ff ff       	call   800780 <_panic>
  802e5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e5f:	8b 00                	mov    (%eax),%eax
  802e61:	85 c0                	test   %eax,%eax
  802e63:	74 10                	je     802e75 <alloc_block_NF+0x135>
  802e65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e68:	8b 00                	mov    (%eax),%eax
  802e6a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e6d:	8b 52 04             	mov    0x4(%edx),%edx
  802e70:	89 50 04             	mov    %edx,0x4(%eax)
  802e73:	eb 0b                	jmp    802e80 <alloc_block_NF+0x140>
  802e75:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e78:	8b 40 04             	mov    0x4(%eax),%eax
  802e7b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e83:	8b 40 04             	mov    0x4(%eax),%eax
  802e86:	85 c0                	test   %eax,%eax
  802e88:	74 0f                	je     802e99 <alloc_block_NF+0x159>
  802e8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e8d:	8b 40 04             	mov    0x4(%eax),%eax
  802e90:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e93:	8b 12                	mov    (%edx),%edx
  802e95:	89 10                	mov    %edx,(%eax)
  802e97:	eb 0a                	jmp    802ea3 <alloc_block_NF+0x163>
  802e99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e9c:	8b 00                	mov    (%eax),%eax
  802e9e:	a3 48 51 80 00       	mov    %eax,0x805148
  802ea3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ea6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802eac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eaf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eb6:	a1 54 51 80 00       	mov    0x805154,%eax
  802ebb:	48                   	dec    %eax
  802ebc:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802ec1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ec4:	8b 40 08             	mov    0x8(%eax),%eax
  802ec7:	a3 2c 50 80 00       	mov    %eax,0x80502c
				   point->sva += size;
  802ecc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ecf:	8b 50 08             	mov    0x8(%eax),%edx
  802ed2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed5:	01 c2                	add    %eax,%edx
  802ed7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eda:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802edd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee0:	8b 40 0c             	mov    0xc(%eax),%eax
  802ee3:	2b 45 08             	sub    0x8(%ebp),%eax
  802ee6:	89 c2                	mov    %eax,%edx
  802ee8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eeb:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802eee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ef1:	e9 15 04 00 00       	jmp    80330b <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802ef6:	a1 40 51 80 00       	mov    0x805140,%eax
  802efb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802efe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f02:	74 07                	je     802f0b <alloc_block_NF+0x1cb>
  802f04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f07:	8b 00                	mov    (%eax),%eax
  802f09:	eb 05                	jmp    802f10 <alloc_block_NF+0x1d0>
  802f0b:	b8 00 00 00 00       	mov    $0x0,%eax
  802f10:	a3 40 51 80 00       	mov    %eax,0x805140
  802f15:	a1 40 51 80 00       	mov    0x805140,%eax
  802f1a:	85 c0                	test   %eax,%eax
  802f1c:	0f 85 3e fe ff ff    	jne    802d60 <alloc_block_NF+0x20>
  802f22:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f26:	0f 85 34 fe ff ff    	jne    802d60 <alloc_block_NF+0x20>
  802f2c:	e9 d5 03 00 00       	jmp    803306 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802f31:	a1 38 51 80 00       	mov    0x805138,%eax
  802f36:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f39:	e9 b1 01 00 00       	jmp    8030ef <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802f3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f41:	8b 50 08             	mov    0x8(%eax),%edx
  802f44:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802f49:	39 c2                	cmp    %eax,%edx
  802f4b:	0f 82 96 01 00 00    	jb     8030e7 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802f51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f54:	8b 40 0c             	mov    0xc(%eax),%eax
  802f57:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f5a:	0f 82 87 01 00 00    	jb     8030e7 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802f60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f63:	8b 40 0c             	mov    0xc(%eax),%eax
  802f66:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f69:	0f 85 95 00 00 00    	jne    803004 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802f6f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f73:	75 17                	jne    802f8c <alloc_block_NF+0x24c>
  802f75:	83 ec 04             	sub    $0x4,%esp
  802f78:	68 dc 46 80 00       	push   $0x8046dc
  802f7d:	68 fc 00 00 00       	push   $0xfc
  802f82:	68 33 46 80 00       	push   $0x804633
  802f87:	e8 f4 d7 ff ff       	call   800780 <_panic>
  802f8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8f:	8b 00                	mov    (%eax),%eax
  802f91:	85 c0                	test   %eax,%eax
  802f93:	74 10                	je     802fa5 <alloc_block_NF+0x265>
  802f95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f98:	8b 00                	mov    (%eax),%eax
  802f9a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f9d:	8b 52 04             	mov    0x4(%edx),%edx
  802fa0:	89 50 04             	mov    %edx,0x4(%eax)
  802fa3:	eb 0b                	jmp    802fb0 <alloc_block_NF+0x270>
  802fa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa8:	8b 40 04             	mov    0x4(%eax),%eax
  802fab:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb3:	8b 40 04             	mov    0x4(%eax),%eax
  802fb6:	85 c0                	test   %eax,%eax
  802fb8:	74 0f                	je     802fc9 <alloc_block_NF+0x289>
  802fba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fbd:	8b 40 04             	mov    0x4(%eax),%eax
  802fc0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fc3:	8b 12                	mov    (%edx),%edx
  802fc5:	89 10                	mov    %edx,(%eax)
  802fc7:	eb 0a                	jmp    802fd3 <alloc_block_NF+0x293>
  802fc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fcc:	8b 00                	mov    (%eax),%eax
  802fce:	a3 38 51 80 00       	mov    %eax,0x805138
  802fd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fdf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fe6:	a1 44 51 80 00       	mov    0x805144,%eax
  802feb:	48                   	dec    %eax
  802fec:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802ff1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff4:	8b 40 08             	mov    0x8(%eax),%eax
  802ff7:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   return  point;
  802ffc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fff:	e9 07 03 00 00       	jmp    80330b <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  803004:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803007:	8b 40 0c             	mov    0xc(%eax),%eax
  80300a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80300d:	0f 86 d4 00 00 00    	jbe    8030e7 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803013:	a1 48 51 80 00       	mov    0x805148,%eax
  803018:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  80301b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80301e:	8b 50 08             	mov    0x8(%eax),%edx
  803021:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803024:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  803027:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80302a:	8b 55 08             	mov    0x8(%ebp),%edx
  80302d:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803030:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803034:	75 17                	jne    80304d <alloc_block_NF+0x30d>
  803036:	83 ec 04             	sub    $0x4,%esp
  803039:	68 dc 46 80 00       	push   $0x8046dc
  80303e:	68 04 01 00 00       	push   $0x104
  803043:	68 33 46 80 00       	push   $0x804633
  803048:	e8 33 d7 ff ff       	call   800780 <_panic>
  80304d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803050:	8b 00                	mov    (%eax),%eax
  803052:	85 c0                	test   %eax,%eax
  803054:	74 10                	je     803066 <alloc_block_NF+0x326>
  803056:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803059:	8b 00                	mov    (%eax),%eax
  80305b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80305e:	8b 52 04             	mov    0x4(%edx),%edx
  803061:	89 50 04             	mov    %edx,0x4(%eax)
  803064:	eb 0b                	jmp    803071 <alloc_block_NF+0x331>
  803066:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803069:	8b 40 04             	mov    0x4(%eax),%eax
  80306c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803071:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803074:	8b 40 04             	mov    0x4(%eax),%eax
  803077:	85 c0                	test   %eax,%eax
  803079:	74 0f                	je     80308a <alloc_block_NF+0x34a>
  80307b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80307e:	8b 40 04             	mov    0x4(%eax),%eax
  803081:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803084:	8b 12                	mov    (%edx),%edx
  803086:	89 10                	mov    %edx,(%eax)
  803088:	eb 0a                	jmp    803094 <alloc_block_NF+0x354>
  80308a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80308d:	8b 00                	mov    (%eax),%eax
  80308f:	a3 48 51 80 00       	mov    %eax,0x805148
  803094:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803097:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80309d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030a0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030a7:	a1 54 51 80 00       	mov    0x805154,%eax
  8030ac:	48                   	dec    %eax
  8030ad:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  8030b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030b5:	8b 40 08             	mov    0x8(%eax),%eax
  8030b8:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   point->sva += size;
  8030bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c0:	8b 50 08             	mov    0x8(%eax),%edx
  8030c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c6:	01 c2                	add    %eax,%edx
  8030c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030cb:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8030ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d1:	8b 40 0c             	mov    0xc(%eax),%eax
  8030d4:	2b 45 08             	sub    0x8(%ebp),%eax
  8030d7:	89 c2                	mov    %eax,%edx
  8030d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030dc:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8030df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030e2:	e9 24 02 00 00       	jmp    80330b <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8030e7:	a1 40 51 80 00       	mov    0x805140,%eax
  8030ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030f3:	74 07                	je     8030fc <alloc_block_NF+0x3bc>
  8030f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f8:	8b 00                	mov    (%eax),%eax
  8030fa:	eb 05                	jmp    803101 <alloc_block_NF+0x3c1>
  8030fc:	b8 00 00 00 00       	mov    $0x0,%eax
  803101:	a3 40 51 80 00       	mov    %eax,0x805140
  803106:	a1 40 51 80 00       	mov    0x805140,%eax
  80310b:	85 c0                	test   %eax,%eax
  80310d:	0f 85 2b fe ff ff    	jne    802f3e <alloc_block_NF+0x1fe>
  803113:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803117:	0f 85 21 fe ff ff    	jne    802f3e <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  80311d:	a1 38 51 80 00       	mov    0x805138,%eax
  803122:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803125:	e9 ae 01 00 00       	jmp    8032d8 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  80312a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80312d:	8b 50 08             	mov    0x8(%eax),%edx
  803130:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803135:	39 c2                	cmp    %eax,%edx
  803137:	0f 83 93 01 00 00    	jae    8032d0 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  80313d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803140:	8b 40 0c             	mov    0xc(%eax),%eax
  803143:	3b 45 08             	cmp    0x8(%ebp),%eax
  803146:	0f 82 84 01 00 00    	jb     8032d0 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  80314c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80314f:	8b 40 0c             	mov    0xc(%eax),%eax
  803152:	3b 45 08             	cmp    0x8(%ebp),%eax
  803155:	0f 85 95 00 00 00    	jne    8031f0 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  80315b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80315f:	75 17                	jne    803178 <alloc_block_NF+0x438>
  803161:	83 ec 04             	sub    $0x4,%esp
  803164:	68 dc 46 80 00       	push   $0x8046dc
  803169:	68 14 01 00 00       	push   $0x114
  80316e:	68 33 46 80 00       	push   $0x804633
  803173:	e8 08 d6 ff ff       	call   800780 <_panic>
  803178:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80317b:	8b 00                	mov    (%eax),%eax
  80317d:	85 c0                	test   %eax,%eax
  80317f:	74 10                	je     803191 <alloc_block_NF+0x451>
  803181:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803184:	8b 00                	mov    (%eax),%eax
  803186:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803189:	8b 52 04             	mov    0x4(%edx),%edx
  80318c:	89 50 04             	mov    %edx,0x4(%eax)
  80318f:	eb 0b                	jmp    80319c <alloc_block_NF+0x45c>
  803191:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803194:	8b 40 04             	mov    0x4(%eax),%eax
  803197:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80319c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80319f:	8b 40 04             	mov    0x4(%eax),%eax
  8031a2:	85 c0                	test   %eax,%eax
  8031a4:	74 0f                	je     8031b5 <alloc_block_NF+0x475>
  8031a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a9:	8b 40 04             	mov    0x4(%eax),%eax
  8031ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031af:	8b 12                	mov    (%edx),%edx
  8031b1:	89 10                	mov    %edx,(%eax)
  8031b3:	eb 0a                	jmp    8031bf <alloc_block_NF+0x47f>
  8031b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b8:	8b 00                	mov    (%eax),%eax
  8031ba:	a3 38 51 80 00       	mov    %eax,0x805138
  8031bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031cb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031d2:	a1 44 51 80 00       	mov    0x805144,%eax
  8031d7:	48                   	dec    %eax
  8031d8:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8031dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e0:	8b 40 08             	mov    0x8(%eax),%eax
  8031e3:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   return  point;
  8031e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031eb:	e9 1b 01 00 00       	jmp    80330b <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8031f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f3:	8b 40 0c             	mov    0xc(%eax),%eax
  8031f6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031f9:	0f 86 d1 00 00 00    	jbe    8032d0 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8031ff:	a1 48 51 80 00       	mov    0x805148,%eax
  803204:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  803207:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80320a:	8b 50 08             	mov    0x8(%eax),%edx
  80320d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803210:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  803213:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803216:	8b 55 08             	mov    0x8(%ebp),%edx
  803219:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80321c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803220:	75 17                	jne    803239 <alloc_block_NF+0x4f9>
  803222:	83 ec 04             	sub    $0x4,%esp
  803225:	68 dc 46 80 00       	push   $0x8046dc
  80322a:	68 1c 01 00 00       	push   $0x11c
  80322f:	68 33 46 80 00       	push   $0x804633
  803234:	e8 47 d5 ff ff       	call   800780 <_panic>
  803239:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80323c:	8b 00                	mov    (%eax),%eax
  80323e:	85 c0                	test   %eax,%eax
  803240:	74 10                	je     803252 <alloc_block_NF+0x512>
  803242:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803245:	8b 00                	mov    (%eax),%eax
  803247:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80324a:	8b 52 04             	mov    0x4(%edx),%edx
  80324d:	89 50 04             	mov    %edx,0x4(%eax)
  803250:	eb 0b                	jmp    80325d <alloc_block_NF+0x51d>
  803252:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803255:	8b 40 04             	mov    0x4(%eax),%eax
  803258:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80325d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803260:	8b 40 04             	mov    0x4(%eax),%eax
  803263:	85 c0                	test   %eax,%eax
  803265:	74 0f                	je     803276 <alloc_block_NF+0x536>
  803267:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80326a:	8b 40 04             	mov    0x4(%eax),%eax
  80326d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803270:	8b 12                	mov    (%edx),%edx
  803272:	89 10                	mov    %edx,(%eax)
  803274:	eb 0a                	jmp    803280 <alloc_block_NF+0x540>
  803276:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803279:	8b 00                	mov    (%eax),%eax
  80327b:	a3 48 51 80 00       	mov    %eax,0x805148
  803280:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803283:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803289:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80328c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803293:	a1 54 51 80 00       	mov    0x805154,%eax
  803298:	48                   	dec    %eax
  803299:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  80329e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032a1:	8b 40 08             	mov    0x8(%eax),%eax
  8032a4:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   point->sva += size;
  8032a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ac:	8b 50 08             	mov    0x8(%eax),%edx
  8032af:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b2:	01 c2                	add    %eax,%edx
  8032b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b7:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8032ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032bd:	8b 40 0c             	mov    0xc(%eax),%eax
  8032c0:	2b 45 08             	sub    0x8(%ebp),%eax
  8032c3:	89 c2                	mov    %eax,%edx
  8032c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c8:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8032cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032ce:	eb 3b                	jmp    80330b <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8032d0:	a1 40 51 80 00       	mov    0x805140,%eax
  8032d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032d8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032dc:	74 07                	je     8032e5 <alloc_block_NF+0x5a5>
  8032de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032e1:	8b 00                	mov    (%eax),%eax
  8032e3:	eb 05                	jmp    8032ea <alloc_block_NF+0x5aa>
  8032e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8032ea:	a3 40 51 80 00       	mov    %eax,0x805140
  8032ef:	a1 40 51 80 00       	mov    0x805140,%eax
  8032f4:	85 c0                	test   %eax,%eax
  8032f6:	0f 85 2e fe ff ff    	jne    80312a <alloc_block_NF+0x3ea>
  8032fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803300:	0f 85 24 fe ff ff    	jne    80312a <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  803306:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80330b:	c9                   	leave  
  80330c:	c3                   	ret    

0080330d <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  80330d:	55                   	push   %ebp
  80330e:	89 e5                	mov    %esp,%ebp
  803310:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  803313:	a1 38 51 80 00       	mov    0x805138,%eax
  803318:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  80331b:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803320:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  803323:	a1 38 51 80 00       	mov    0x805138,%eax
  803328:	85 c0                	test   %eax,%eax
  80332a:	74 14                	je     803340 <insert_sorted_with_merge_freeList+0x33>
  80332c:	8b 45 08             	mov    0x8(%ebp),%eax
  80332f:	8b 50 08             	mov    0x8(%eax),%edx
  803332:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803335:	8b 40 08             	mov    0x8(%eax),%eax
  803338:	39 c2                	cmp    %eax,%edx
  80333a:	0f 87 9b 01 00 00    	ja     8034db <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  803340:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803344:	75 17                	jne    80335d <insert_sorted_with_merge_freeList+0x50>
  803346:	83 ec 04             	sub    $0x4,%esp
  803349:	68 10 46 80 00       	push   $0x804610
  80334e:	68 38 01 00 00       	push   $0x138
  803353:	68 33 46 80 00       	push   $0x804633
  803358:	e8 23 d4 ff ff       	call   800780 <_panic>
  80335d:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803363:	8b 45 08             	mov    0x8(%ebp),%eax
  803366:	89 10                	mov    %edx,(%eax)
  803368:	8b 45 08             	mov    0x8(%ebp),%eax
  80336b:	8b 00                	mov    (%eax),%eax
  80336d:	85 c0                	test   %eax,%eax
  80336f:	74 0d                	je     80337e <insert_sorted_with_merge_freeList+0x71>
  803371:	a1 38 51 80 00       	mov    0x805138,%eax
  803376:	8b 55 08             	mov    0x8(%ebp),%edx
  803379:	89 50 04             	mov    %edx,0x4(%eax)
  80337c:	eb 08                	jmp    803386 <insert_sorted_with_merge_freeList+0x79>
  80337e:	8b 45 08             	mov    0x8(%ebp),%eax
  803381:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803386:	8b 45 08             	mov    0x8(%ebp),%eax
  803389:	a3 38 51 80 00       	mov    %eax,0x805138
  80338e:	8b 45 08             	mov    0x8(%ebp),%eax
  803391:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803398:	a1 44 51 80 00       	mov    0x805144,%eax
  80339d:	40                   	inc    %eax
  80339e:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8033a3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8033a7:	0f 84 a8 06 00 00    	je     803a55 <insert_sorted_with_merge_freeList+0x748>
  8033ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b0:	8b 50 08             	mov    0x8(%eax),%edx
  8033b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b6:	8b 40 0c             	mov    0xc(%eax),%eax
  8033b9:	01 c2                	add    %eax,%edx
  8033bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033be:	8b 40 08             	mov    0x8(%eax),%eax
  8033c1:	39 c2                	cmp    %eax,%edx
  8033c3:	0f 85 8c 06 00 00    	jne    803a55 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  8033c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8033cc:	8b 50 0c             	mov    0xc(%eax),%edx
  8033cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033d2:	8b 40 0c             	mov    0xc(%eax),%eax
  8033d5:	01 c2                	add    %eax,%edx
  8033d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8033da:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  8033dd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8033e1:	75 17                	jne    8033fa <insert_sorted_with_merge_freeList+0xed>
  8033e3:	83 ec 04             	sub    $0x4,%esp
  8033e6:	68 dc 46 80 00       	push   $0x8046dc
  8033eb:	68 3c 01 00 00       	push   $0x13c
  8033f0:	68 33 46 80 00       	push   $0x804633
  8033f5:	e8 86 d3 ff ff       	call   800780 <_panic>
  8033fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033fd:	8b 00                	mov    (%eax),%eax
  8033ff:	85 c0                	test   %eax,%eax
  803401:	74 10                	je     803413 <insert_sorted_with_merge_freeList+0x106>
  803403:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803406:	8b 00                	mov    (%eax),%eax
  803408:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80340b:	8b 52 04             	mov    0x4(%edx),%edx
  80340e:	89 50 04             	mov    %edx,0x4(%eax)
  803411:	eb 0b                	jmp    80341e <insert_sorted_with_merge_freeList+0x111>
  803413:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803416:	8b 40 04             	mov    0x4(%eax),%eax
  803419:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80341e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803421:	8b 40 04             	mov    0x4(%eax),%eax
  803424:	85 c0                	test   %eax,%eax
  803426:	74 0f                	je     803437 <insert_sorted_with_merge_freeList+0x12a>
  803428:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80342b:	8b 40 04             	mov    0x4(%eax),%eax
  80342e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803431:	8b 12                	mov    (%edx),%edx
  803433:	89 10                	mov    %edx,(%eax)
  803435:	eb 0a                	jmp    803441 <insert_sorted_with_merge_freeList+0x134>
  803437:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80343a:	8b 00                	mov    (%eax),%eax
  80343c:	a3 38 51 80 00       	mov    %eax,0x805138
  803441:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803444:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80344a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80344d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803454:	a1 44 51 80 00       	mov    0x805144,%eax
  803459:	48                   	dec    %eax
  80345a:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  80345f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803462:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  803469:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80346c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  803473:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803477:	75 17                	jne    803490 <insert_sorted_with_merge_freeList+0x183>
  803479:	83 ec 04             	sub    $0x4,%esp
  80347c:	68 10 46 80 00       	push   $0x804610
  803481:	68 3f 01 00 00       	push   $0x13f
  803486:	68 33 46 80 00       	push   $0x804633
  80348b:	e8 f0 d2 ff ff       	call   800780 <_panic>
  803490:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803496:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803499:	89 10                	mov    %edx,(%eax)
  80349b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80349e:	8b 00                	mov    (%eax),%eax
  8034a0:	85 c0                	test   %eax,%eax
  8034a2:	74 0d                	je     8034b1 <insert_sorted_with_merge_freeList+0x1a4>
  8034a4:	a1 48 51 80 00       	mov    0x805148,%eax
  8034a9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034ac:	89 50 04             	mov    %edx,0x4(%eax)
  8034af:	eb 08                	jmp    8034b9 <insert_sorted_with_merge_freeList+0x1ac>
  8034b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034b4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8034b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034bc:	a3 48 51 80 00       	mov    %eax,0x805148
  8034c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034c4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034cb:	a1 54 51 80 00       	mov    0x805154,%eax
  8034d0:	40                   	inc    %eax
  8034d1:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8034d6:	e9 7a 05 00 00       	jmp    803a55 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  8034db:	8b 45 08             	mov    0x8(%ebp),%eax
  8034de:	8b 50 08             	mov    0x8(%eax),%edx
  8034e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034e4:	8b 40 08             	mov    0x8(%eax),%eax
  8034e7:	39 c2                	cmp    %eax,%edx
  8034e9:	0f 82 14 01 00 00    	jb     803603 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  8034ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034f2:	8b 50 08             	mov    0x8(%eax),%edx
  8034f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034f8:	8b 40 0c             	mov    0xc(%eax),%eax
  8034fb:	01 c2                	add    %eax,%edx
  8034fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803500:	8b 40 08             	mov    0x8(%eax),%eax
  803503:	39 c2                	cmp    %eax,%edx
  803505:	0f 85 90 00 00 00    	jne    80359b <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  80350b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80350e:	8b 50 0c             	mov    0xc(%eax),%edx
  803511:	8b 45 08             	mov    0x8(%ebp),%eax
  803514:	8b 40 0c             	mov    0xc(%eax),%eax
  803517:	01 c2                	add    %eax,%edx
  803519:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80351c:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  80351f:	8b 45 08             	mov    0x8(%ebp),%eax
  803522:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  803529:	8b 45 08             	mov    0x8(%ebp),%eax
  80352c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803533:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803537:	75 17                	jne    803550 <insert_sorted_with_merge_freeList+0x243>
  803539:	83 ec 04             	sub    $0x4,%esp
  80353c:	68 10 46 80 00       	push   $0x804610
  803541:	68 49 01 00 00       	push   $0x149
  803546:	68 33 46 80 00       	push   $0x804633
  80354b:	e8 30 d2 ff ff       	call   800780 <_panic>
  803550:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803556:	8b 45 08             	mov    0x8(%ebp),%eax
  803559:	89 10                	mov    %edx,(%eax)
  80355b:	8b 45 08             	mov    0x8(%ebp),%eax
  80355e:	8b 00                	mov    (%eax),%eax
  803560:	85 c0                	test   %eax,%eax
  803562:	74 0d                	je     803571 <insert_sorted_with_merge_freeList+0x264>
  803564:	a1 48 51 80 00       	mov    0x805148,%eax
  803569:	8b 55 08             	mov    0x8(%ebp),%edx
  80356c:	89 50 04             	mov    %edx,0x4(%eax)
  80356f:	eb 08                	jmp    803579 <insert_sorted_with_merge_freeList+0x26c>
  803571:	8b 45 08             	mov    0x8(%ebp),%eax
  803574:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803579:	8b 45 08             	mov    0x8(%ebp),%eax
  80357c:	a3 48 51 80 00       	mov    %eax,0x805148
  803581:	8b 45 08             	mov    0x8(%ebp),%eax
  803584:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80358b:	a1 54 51 80 00       	mov    0x805154,%eax
  803590:	40                   	inc    %eax
  803591:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803596:	e9 bb 04 00 00       	jmp    803a56 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  80359b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80359f:	75 17                	jne    8035b8 <insert_sorted_with_merge_freeList+0x2ab>
  8035a1:	83 ec 04             	sub    $0x4,%esp
  8035a4:	68 84 46 80 00       	push   $0x804684
  8035a9:	68 4c 01 00 00       	push   $0x14c
  8035ae:	68 33 46 80 00       	push   $0x804633
  8035b3:	e8 c8 d1 ff ff       	call   800780 <_panic>
  8035b8:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8035be:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c1:	89 50 04             	mov    %edx,0x4(%eax)
  8035c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c7:	8b 40 04             	mov    0x4(%eax),%eax
  8035ca:	85 c0                	test   %eax,%eax
  8035cc:	74 0c                	je     8035da <insert_sorted_with_merge_freeList+0x2cd>
  8035ce:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8035d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8035d6:	89 10                	mov    %edx,(%eax)
  8035d8:	eb 08                	jmp    8035e2 <insert_sorted_with_merge_freeList+0x2d5>
  8035da:	8b 45 08             	mov    0x8(%ebp),%eax
  8035dd:	a3 38 51 80 00       	mov    %eax,0x805138
  8035e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8035ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035f3:	a1 44 51 80 00       	mov    0x805144,%eax
  8035f8:	40                   	inc    %eax
  8035f9:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8035fe:	e9 53 04 00 00       	jmp    803a56 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803603:	a1 38 51 80 00       	mov    0x805138,%eax
  803608:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80360b:	e9 15 04 00 00       	jmp    803a25 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  803610:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803613:	8b 00                	mov    (%eax),%eax
  803615:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803618:	8b 45 08             	mov    0x8(%ebp),%eax
  80361b:	8b 50 08             	mov    0x8(%eax),%edx
  80361e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803621:	8b 40 08             	mov    0x8(%eax),%eax
  803624:	39 c2                	cmp    %eax,%edx
  803626:	0f 86 f1 03 00 00    	jbe    803a1d <insert_sorted_with_merge_freeList+0x710>
  80362c:	8b 45 08             	mov    0x8(%ebp),%eax
  80362f:	8b 50 08             	mov    0x8(%eax),%edx
  803632:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803635:	8b 40 08             	mov    0x8(%eax),%eax
  803638:	39 c2                	cmp    %eax,%edx
  80363a:	0f 83 dd 03 00 00    	jae    803a1d <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803640:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803643:	8b 50 08             	mov    0x8(%eax),%edx
  803646:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803649:	8b 40 0c             	mov    0xc(%eax),%eax
  80364c:	01 c2                	add    %eax,%edx
  80364e:	8b 45 08             	mov    0x8(%ebp),%eax
  803651:	8b 40 08             	mov    0x8(%eax),%eax
  803654:	39 c2                	cmp    %eax,%edx
  803656:	0f 85 b9 01 00 00    	jne    803815 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80365c:	8b 45 08             	mov    0x8(%ebp),%eax
  80365f:	8b 50 08             	mov    0x8(%eax),%edx
  803662:	8b 45 08             	mov    0x8(%ebp),%eax
  803665:	8b 40 0c             	mov    0xc(%eax),%eax
  803668:	01 c2                	add    %eax,%edx
  80366a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80366d:	8b 40 08             	mov    0x8(%eax),%eax
  803670:	39 c2                	cmp    %eax,%edx
  803672:	0f 85 0d 01 00 00    	jne    803785 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803678:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80367b:	8b 50 0c             	mov    0xc(%eax),%edx
  80367e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803681:	8b 40 0c             	mov    0xc(%eax),%eax
  803684:	01 c2                	add    %eax,%edx
  803686:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803689:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80368c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803690:	75 17                	jne    8036a9 <insert_sorted_with_merge_freeList+0x39c>
  803692:	83 ec 04             	sub    $0x4,%esp
  803695:	68 dc 46 80 00       	push   $0x8046dc
  80369a:	68 5c 01 00 00       	push   $0x15c
  80369f:	68 33 46 80 00       	push   $0x804633
  8036a4:	e8 d7 d0 ff ff       	call   800780 <_panic>
  8036a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036ac:	8b 00                	mov    (%eax),%eax
  8036ae:	85 c0                	test   %eax,%eax
  8036b0:	74 10                	je     8036c2 <insert_sorted_with_merge_freeList+0x3b5>
  8036b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036b5:	8b 00                	mov    (%eax),%eax
  8036b7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8036ba:	8b 52 04             	mov    0x4(%edx),%edx
  8036bd:	89 50 04             	mov    %edx,0x4(%eax)
  8036c0:	eb 0b                	jmp    8036cd <insert_sorted_with_merge_freeList+0x3c0>
  8036c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036c5:	8b 40 04             	mov    0x4(%eax),%eax
  8036c8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8036cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036d0:	8b 40 04             	mov    0x4(%eax),%eax
  8036d3:	85 c0                	test   %eax,%eax
  8036d5:	74 0f                	je     8036e6 <insert_sorted_with_merge_freeList+0x3d9>
  8036d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036da:	8b 40 04             	mov    0x4(%eax),%eax
  8036dd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8036e0:	8b 12                	mov    (%edx),%edx
  8036e2:	89 10                	mov    %edx,(%eax)
  8036e4:	eb 0a                	jmp    8036f0 <insert_sorted_with_merge_freeList+0x3e3>
  8036e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036e9:	8b 00                	mov    (%eax),%eax
  8036eb:	a3 38 51 80 00       	mov    %eax,0x805138
  8036f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036f3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036fc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803703:	a1 44 51 80 00       	mov    0x805144,%eax
  803708:	48                   	dec    %eax
  803709:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  80370e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803711:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803718:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80371b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803722:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803726:	75 17                	jne    80373f <insert_sorted_with_merge_freeList+0x432>
  803728:	83 ec 04             	sub    $0x4,%esp
  80372b:	68 10 46 80 00       	push   $0x804610
  803730:	68 5f 01 00 00       	push   $0x15f
  803735:	68 33 46 80 00       	push   $0x804633
  80373a:	e8 41 d0 ff ff       	call   800780 <_panic>
  80373f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803745:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803748:	89 10                	mov    %edx,(%eax)
  80374a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80374d:	8b 00                	mov    (%eax),%eax
  80374f:	85 c0                	test   %eax,%eax
  803751:	74 0d                	je     803760 <insert_sorted_with_merge_freeList+0x453>
  803753:	a1 48 51 80 00       	mov    0x805148,%eax
  803758:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80375b:	89 50 04             	mov    %edx,0x4(%eax)
  80375e:	eb 08                	jmp    803768 <insert_sorted_with_merge_freeList+0x45b>
  803760:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803763:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803768:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80376b:	a3 48 51 80 00       	mov    %eax,0x805148
  803770:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803773:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80377a:	a1 54 51 80 00       	mov    0x805154,%eax
  80377f:	40                   	inc    %eax
  803780:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803785:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803788:	8b 50 0c             	mov    0xc(%eax),%edx
  80378b:	8b 45 08             	mov    0x8(%ebp),%eax
  80378e:	8b 40 0c             	mov    0xc(%eax),%eax
  803791:	01 c2                	add    %eax,%edx
  803793:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803796:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803799:	8b 45 08             	mov    0x8(%ebp),%eax
  80379c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8037a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8037ad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037b1:	75 17                	jne    8037ca <insert_sorted_with_merge_freeList+0x4bd>
  8037b3:	83 ec 04             	sub    $0x4,%esp
  8037b6:	68 10 46 80 00       	push   $0x804610
  8037bb:	68 64 01 00 00       	push   $0x164
  8037c0:	68 33 46 80 00       	push   $0x804633
  8037c5:	e8 b6 cf ff ff       	call   800780 <_panic>
  8037ca:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8037d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8037d3:	89 10                	mov    %edx,(%eax)
  8037d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8037d8:	8b 00                	mov    (%eax),%eax
  8037da:	85 c0                	test   %eax,%eax
  8037dc:	74 0d                	je     8037eb <insert_sorted_with_merge_freeList+0x4de>
  8037de:	a1 48 51 80 00       	mov    0x805148,%eax
  8037e3:	8b 55 08             	mov    0x8(%ebp),%edx
  8037e6:	89 50 04             	mov    %edx,0x4(%eax)
  8037e9:	eb 08                	jmp    8037f3 <insert_sorted_with_merge_freeList+0x4e6>
  8037eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ee:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8037f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8037f6:	a3 48 51 80 00       	mov    %eax,0x805148
  8037fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8037fe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803805:	a1 54 51 80 00       	mov    0x805154,%eax
  80380a:	40                   	inc    %eax
  80380b:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803810:	e9 41 02 00 00       	jmp    803a56 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803815:	8b 45 08             	mov    0x8(%ebp),%eax
  803818:	8b 50 08             	mov    0x8(%eax),%edx
  80381b:	8b 45 08             	mov    0x8(%ebp),%eax
  80381e:	8b 40 0c             	mov    0xc(%eax),%eax
  803821:	01 c2                	add    %eax,%edx
  803823:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803826:	8b 40 08             	mov    0x8(%eax),%eax
  803829:	39 c2                	cmp    %eax,%edx
  80382b:	0f 85 7c 01 00 00    	jne    8039ad <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803831:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803835:	74 06                	je     80383d <insert_sorted_with_merge_freeList+0x530>
  803837:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80383b:	75 17                	jne    803854 <insert_sorted_with_merge_freeList+0x547>
  80383d:	83 ec 04             	sub    $0x4,%esp
  803840:	68 4c 46 80 00       	push   $0x80464c
  803845:	68 69 01 00 00       	push   $0x169
  80384a:	68 33 46 80 00       	push   $0x804633
  80384f:	e8 2c cf ff ff       	call   800780 <_panic>
  803854:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803857:	8b 50 04             	mov    0x4(%eax),%edx
  80385a:	8b 45 08             	mov    0x8(%ebp),%eax
  80385d:	89 50 04             	mov    %edx,0x4(%eax)
  803860:	8b 45 08             	mov    0x8(%ebp),%eax
  803863:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803866:	89 10                	mov    %edx,(%eax)
  803868:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80386b:	8b 40 04             	mov    0x4(%eax),%eax
  80386e:	85 c0                	test   %eax,%eax
  803870:	74 0d                	je     80387f <insert_sorted_with_merge_freeList+0x572>
  803872:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803875:	8b 40 04             	mov    0x4(%eax),%eax
  803878:	8b 55 08             	mov    0x8(%ebp),%edx
  80387b:	89 10                	mov    %edx,(%eax)
  80387d:	eb 08                	jmp    803887 <insert_sorted_with_merge_freeList+0x57a>
  80387f:	8b 45 08             	mov    0x8(%ebp),%eax
  803882:	a3 38 51 80 00       	mov    %eax,0x805138
  803887:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80388a:	8b 55 08             	mov    0x8(%ebp),%edx
  80388d:	89 50 04             	mov    %edx,0x4(%eax)
  803890:	a1 44 51 80 00       	mov    0x805144,%eax
  803895:	40                   	inc    %eax
  803896:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  80389b:	8b 45 08             	mov    0x8(%ebp),%eax
  80389e:	8b 50 0c             	mov    0xc(%eax),%edx
  8038a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038a4:	8b 40 0c             	mov    0xc(%eax),%eax
  8038a7:	01 c2                	add    %eax,%edx
  8038a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ac:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8038af:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8038b3:	75 17                	jne    8038cc <insert_sorted_with_merge_freeList+0x5bf>
  8038b5:	83 ec 04             	sub    $0x4,%esp
  8038b8:	68 dc 46 80 00       	push   $0x8046dc
  8038bd:	68 6b 01 00 00       	push   $0x16b
  8038c2:	68 33 46 80 00       	push   $0x804633
  8038c7:	e8 b4 ce ff ff       	call   800780 <_panic>
  8038cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038cf:	8b 00                	mov    (%eax),%eax
  8038d1:	85 c0                	test   %eax,%eax
  8038d3:	74 10                	je     8038e5 <insert_sorted_with_merge_freeList+0x5d8>
  8038d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038d8:	8b 00                	mov    (%eax),%eax
  8038da:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8038dd:	8b 52 04             	mov    0x4(%edx),%edx
  8038e0:	89 50 04             	mov    %edx,0x4(%eax)
  8038e3:	eb 0b                	jmp    8038f0 <insert_sorted_with_merge_freeList+0x5e3>
  8038e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038e8:	8b 40 04             	mov    0x4(%eax),%eax
  8038eb:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8038f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038f3:	8b 40 04             	mov    0x4(%eax),%eax
  8038f6:	85 c0                	test   %eax,%eax
  8038f8:	74 0f                	je     803909 <insert_sorted_with_merge_freeList+0x5fc>
  8038fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038fd:	8b 40 04             	mov    0x4(%eax),%eax
  803900:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803903:	8b 12                	mov    (%edx),%edx
  803905:	89 10                	mov    %edx,(%eax)
  803907:	eb 0a                	jmp    803913 <insert_sorted_with_merge_freeList+0x606>
  803909:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80390c:	8b 00                	mov    (%eax),%eax
  80390e:	a3 38 51 80 00       	mov    %eax,0x805138
  803913:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803916:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80391c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80391f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803926:	a1 44 51 80 00       	mov    0x805144,%eax
  80392b:	48                   	dec    %eax
  80392c:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803931:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803934:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  80393b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80393e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803945:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803949:	75 17                	jne    803962 <insert_sorted_with_merge_freeList+0x655>
  80394b:	83 ec 04             	sub    $0x4,%esp
  80394e:	68 10 46 80 00       	push   $0x804610
  803953:	68 6e 01 00 00       	push   $0x16e
  803958:	68 33 46 80 00       	push   $0x804633
  80395d:	e8 1e ce ff ff       	call   800780 <_panic>
  803962:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803968:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80396b:	89 10                	mov    %edx,(%eax)
  80396d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803970:	8b 00                	mov    (%eax),%eax
  803972:	85 c0                	test   %eax,%eax
  803974:	74 0d                	je     803983 <insert_sorted_with_merge_freeList+0x676>
  803976:	a1 48 51 80 00       	mov    0x805148,%eax
  80397b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80397e:	89 50 04             	mov    %edx,0x4(%eax)
  803981:	eb 08                	jmp    80398b <insert_sorted_with_merge_freeList+0x67e>
  803983:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803986:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80398b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80398e:	a3 48 51 80 00       	mov    %eax,0x805148
  803993:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803996:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80399d:	a1 54 51 80 00       	mov    0x805154,%eax
  8039a2:	40                   	inc    %eax
  8039a3:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8039a8:	e9 a9 00 00 00       	jmp    803a56 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8039ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8039b1:	74 06                	je     8039b9 <insert_sorted_with_merge_freeList+0x6ac>
  8039b3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8039b7:	75 17                	jne    8039d0 <insert_sorted_with_merge_freeList+0x6c3>
  8039b9:	83 ec 04             	sub    $0x4,%esp
  8039bc:	68 a8 46 80 00       	push   $0x8046a8
  8039c1:	68 73 01 00 00       	push   $0x173
  8039c6:	68 33 46 80 00       	push   $0x804633
  8039cb:	e8 b0 cd ff ff       	call   800780 <_panic>
  8039d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039d3:	8b 10                	mov    (%eax),%edx
  8039d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8039d8:	89 10                	mov    %edx,(%eax)
  8039da:	8b 45 08             	mov    0x8(%ebp),%eax
  8039dd:	8b 00                	mov    (%eax),%eax
  8039df:	85 c0                	test   %eax,%eax
  8039e1:	74 0b                	je     8039ee <insert_sorted_with_merge_freeList+0x6e1>
  8039e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039e6:	8b 00                	mov    (%eax),%eax
  8039e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8039eb:	89 50 04             	mov    %edx,0x4(%eax)
  8039ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8039f4:	89 10                	mov    %edx,(%eax)
  8039f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8039f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8039fc:	89 50 04             	mov    %edx,0x4(%eax)
  8039ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803a02:	8b 00                	mov    (%eax),%eax
  803a04:	85 c0                	test   %eax,%eax
  803a06:	75 08                	jne    803a10 <insert_sorted_with_merge_freeList+0x703>
  803a08:	8b 45 08             	mov    0x8(%ebp),%eax
  803a0b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803a10:	a1 44 51 80 00       	mov    0x805144,%eax
  803a15:	40                   	inc    %eax
  803a16:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803a1b:	eb 39                	jmp    803a56 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803a1d:	a1 40 51 80 00       	mov    0x805140,%eax
  803a22:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803a25:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a29:	74 07                	je     803a32 <insert_sorted_with_merge_freeList+0x725>
  803a2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a2e:	8b 00                	mov    (%eax),%eax
  803a30:	eb 05                	jmp    803a37 <insert_sorted_with_merge_freeList+0x72a>
  803a32:	b8 00 00 00 00       	mov    $0x0,%eax
  803a37:	a3 40 51 80 00       	mov    %eax,0x805140
  803a3c:	a1 40 51 80 00       	mov    0x805140,%eax
  803a41:	85 c0                	test   %eax,%eax
  803a43:	0f 85 c7 fb ff ff    	jne    803610 <insert_sorted_with_merge_freeList+0x303>
  803a49:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a4d:	0f 85 bd fb ff ff    	jne    803610 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803a53:	eb 01                	jmp    803a56 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803a55:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803a56:	90                   	nop
  803a57:	c9                   	leave  
  803a58:	c3                   	ret    
  803a59:	66 90                	xchg   %ax,%ax
  803a5b:	90                   	nop

00803a5c <__udivdi3>:
  803a5c:	55                   	push   %ebp
  803a5d:	57                   	push   %edi
  803a5e:	56                   	push   %esi
  803a5f:	53                   	push   %ebx
  803a60:	83 ec 1c             	sub    $0x1c,%esp
  803a63:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803a67:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803a6b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803a6f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803a73:	89 ca                	mov    %ecx,%edx
  803a75:	89 f8                	mov    %edi,%eax
  803a77:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803a7b:	85 f6                	test   %esi,%esi
  803a7d:	75 2d                	jne    803aac <__udivdi3+0x50>
  803a7f:	39 cf                	cmp    %ecx,%edi
  803a81:	77 65                	ja     803ae8 <__udivdi3+0x8c>
  803a83:	89 fd                	mov    %edi,%ebp
  803a85:	85 ff                	test   %edi,%edi
  803a87:	75 0b                	jne    803a94 <__udivdi3+0x38>
  803a89:	b8 01 00 00 00       	mov    $0x1,%eax
  803a8e:	31 d2                	xor    %edx,%edx
  803a90:	f7 f7                	div    %edi
  803a92:	89 c5                	mov    %eax,%ebp
  803a94:	31 d2                	xor    %edx,%edx
  803a96:	89 c8                	mov    %ecx,%eax
  803a98:	f7 f5                	div    %ebp
  803a9a:	89 c1                	mov    %eax,%ecx
  803a9c:	89 d8                	mov    %ebx,%eax
  803a9e:	f7 f5                	div    %ebp
  803aa0:	89 cf                	mov    %ecx,%edi
  803aa2:	89 fa                	mov    %edi,%edx
  803aa4:	83 c4 1c             	add    $0x1c,%esp
  803aa7:	5b                   	pop    %ebx
  803aa8:	5e                   	pop    %esi
  803aa9:	5f                   	pop    %edi
  803aaa:	5d                   	pop    %ebp
  803aab:	c3                   	ret    
  803aac:	39 ce                	cmp    %ecx,%esi
  803aae:	77 28                	ja     803ad8 <__udivdi3+0x7c>
  803ab0:	0f bd fe             	bsr    %esi,%edi
  803ab3:	83 f7 1f             	xor    $0x1f,%edi
  803ab6:	75 40                	jne    803af8 <__udivdi3+0x9c>
  803ab8:	39 ce                	cmp    %ecx,%esi
  803aba:	72 0a                	jb     803ac6 <__udivdi3+0x6a>
  803abc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803ac0:	0f 87 9e 00 00 00    	ja     803b64 <__udivdi3+0x108>
  803ac6:	b8 01 00 00 00       	mov    $0x1,%eax
  803acb:	89 fa                	mov    %edi,%edx
  803acd:	83 c4 1c             	add    $0x1c,%esp
  803ad0:	5b                   	pop    %ebx
  803ad1:	5e                   	pop    %esi
  803ad2:	5f                   	pop    %edi
  803ad3:	5d                   	pop    %ebp
  803ad4:	c3                   	ret    
  803ad5:	8d 76 00             	lea    0x0(%esi),%esi
  803ad8:	31 ff                	xor    %edi,%edi
  803ada:	31 c0                	xor    %eax,%eax
  803adc:	89 fa                	mov    %edi,%edx
  803ade:	83 c4 1c             	add    $0x1c,%esp
  803ae1:	5b                   	pop    %ebx
  803ae2:	5e                   	pop    %esi
  803ae3:	5f                   	pop    %edi
  803ae4:	5d                   	pop    %ebp
  803ae5:	c3                   	ret    
  803ae6:	66 90                	xchg   %ax,%ax
  803ae8:	89 d8                	mov    %ebx,%eax
  803aea:	f7 f7                	div    %edi
  803aec:	31 ff                	xor    %edi,%edi
  803aee:	89 fa                	mov    %edi,%edx
  803af0:	83 c4 1c             	add    $0x1c,%esp
  803af3:	5b                   	pop    %ebx
  803af4:	5e                   	pop    %esi
  803af5:	5f                   	pop    %edi
  803af6:	5d                   	pop    %ebp
  803af7:	c3                   	ret    
  803af8:	bd 20 00 00 00       	mov    $0x20,%ebp
  803afd:	89 eb                	mov    %ebp,%ebx
  803aff:	29 fb                	sub    %edi,%ebx
  803b01:	89 f9                	mov    %edi,%ecx
  803b03:	d3 e6                	shl    %cl,%esi
  803b05:	89 c5                	mov    %eax,%ebp
  803b07:	88 d9                	mov    %bl,%cl
  803b09:	d3 ed                	shr    %cl,%ebp
  803b0b:	89 e9                	mov    %ebp,%ecx
  803b0d:	09 f1                	or     %esi,%ecx
  803b0f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803b13:	89 f9                	mov    %edi,%ecx
  803b15:	d3 e0                	shl    %cl,%eax
  803b17:	89 c5                	mov    %eax,%ebp
  803b19:	89 d6                	mov    %edx,%esi
  803b1b:	88 d9                	mov    %bl,%cl
  803b1d:	d3 ee                	shr    %cl,%esi
  803b1f:	89 f9                	mov    %edi,%ecx
  803b21:	d3 e2                	shl    %cl,%edx
  803b23:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b27:	88 d9                	mov    %bl,%cl
  803b29:	d3 e8                	shr    %cl,%eax
  803b2b:	09 c2                	or     %eax,%edx
  803b2d:	89 d0                	mov    %edx,%eax
  803b2f:	89 f2                	mov    %esi,%edx
  803b31:	f7 74 24 0c          	divl   0xc(%esp)
  803b35:	89 d6                	mov    %edx,%esi
  803b37:	89 c3                	mov    %eax,%ebx
  803b39:	f7 e5                	mul    %ebp
  803b3b:	39 d6                	cmp    %edx,%esi
  803b3d:	72 19                	jb     803b58 <__udivdi3+0xfc>
  803b3f:	74 0b                	je     803b4c <__udivdi3+0xf0>
  803b41:	89 d8                	mov    %ebx,%eax
  803b43:	31 ff                	xor    %edi,%edi
  803b45:	e9 58 ff ff ff       	jmp    803aa2 <__udivdi3+0x46>
  803b4a:	66 90                	xchg   %ax,%ax
  803b4c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803b50:	89 f9                	mov    %edi,%ecx
  803b52:	d3 e2                	shl    %cl,%edx
  803b54:	39 c2                	cmp    %eax,%edx
  803b56:	73 e9                	jae    803b41 <__udivdi3+0xe5>
  803b58:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803b5b:	31 ff                	xor    %edi,%edi
  803b5d:	e9 40 ff ff ff       	jmp    803aa2 <__udivdi3+0x46>
  803b62:	66 90                	xchg   %ax,%ax
  803b64:	31 c0                	xor    %eax,%eax
  803b66:	e9 37 ff ff ff       	jmp    803aa2 <__udivdi3+0x46>
  803b6b:	90                   	nop

00803b6c <__umoddi3>:
  803b6c:	55                   	push   %ebp
  803b6d:	57                   	push   %edi
  803b6e:	56                   	push   %esi
  803b6f:	53                   	push   %ebx
  803b70:	83 ec 1c             	sub    $0x1c,%esp
  803b73:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803b77:	8b 74 24 34          	mov    0x34(%esp),%esi
  803b7b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b7f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803b83:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803b87:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803b8b:	89 f3                	mov    %esi,%ebx
  803b8d:	89 fa                	mov    %edi,%edx
  803b8f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803b93:	89 34 24             	mov    %esi,(%esp)
  803b96:	85 c0                	test   %eax,%eax
  803b98:	75 1a                	jne    803bb4 <__umoddi3+0x48>
  803b9a:	39 f7                	cmp    %esi,%edi
  803b9c:	0f 86 a2 00 00 00    	jbe    803c44 <__umoddi3+0xd8>
  803ba2:	89 c8                	mov    %ecx,%eax
  803ba4:	89 f2                	mov    %esi,%edx
  803ba6:	f7 f7                	div    %edi
  803ba8:	89 d0                	mov    %edx,%eax
  803baa:	31 d2                	xor    %edx,%edx
  803bac:	83 c4 1c             	add    $0x1c,%esp
  803baf:	5b                   	pop    %ebx
  803bb0:	5e                   	pop    %esi
  803bb1:	5f                   	pop    %edi
  803bb2:	5d                   	pop    %ebp
  803bb3:	c3                   	ret    
  803bb4:	39 f0                	cmp    %esi,%eax
  803bb6:	0f 87 ac 00 00 00    	ja     803c68 <__umoddi3+0xfc>
  803bbc:	0f bd e8             	bsr    %eax,%ebp
  803bbf:	83 f5 1f             	xor    $0x1f,%ebp
  803bc2:	0f 84 ac 00 00 00    	je     803c74 <__umoddi3+0x108>
  803bc8:	bf 20 00 00 00       	mov    $0x20,%edi
  803bcd:	29 ef                	sub    %ebp,%edi
  803bcf:	89 fe                	mov    %edi,%esi
  803bd1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803bd5:	89 e9                	mov    %ebp,%ecx
  803bd7:	d3 e0                	shl    %cl,%eax
  803bd9:	89 d7                	mov    %edx,%edi
  803bdb:	89 f1                	mov    %esi,%ecx
  803bdd:	d3 ef                	shr    %cl,%edi
  803bdf:	09 c7                	or     %eax,%edi
  803be1:	89 e9                	mov    %ebp,%ecx
  803be3:	d3 e2                	shl    %cl,%edx
  803be5:	89 14 24             	mov    %edx,(%esp)
  803be8:	89 d8                	mov    %ebx,%eax
  803bea:	d3 e0                	shl    %cl,%eax
  803bec:	89 c2                	mov    %eax,%edx
  803bee:	8b 44 24 08          	mov    0x8(%esp),%eax
  803bf2:	d3 e0                	shl    %cl,%eax
  803bf4:	89 44 24 04          	mov    %eax,0x4(%esp)
  803bf8:	8b 44 24 08          	mov    0x8(%esp),%eax
  803bfc:	89 f1                	mov    %esi,%ecx
  803bfe:	d3 e8                	shr    %cl,%eax
  803c00:	09 d0                	or     %edx,%eax
  803c02:	d3 eb                	shr    %cl,%ebx
  803c04:	89 da                	mov    %ebx,%edx
  803c06:	f7 f7                	div    %edi
  803c08:	89 d3                	mov    %edx,%ebx
  803c0a:	f7 24 24             	mull   (%esp)
  803c0d:	89 c6                	mov    %eax,%esi
  803c0f:	89 d1                	mov    %edx,%ecx
  803c11:	39 d3                	cmp    %edx,%ebx
  803c13:	0f 82 87 00 00 00    	jb     803ca0 <__umoddi3+0x134>
  803c19:	0f 84 91 00 00 00    	je     803cb0 <__umoddi3+0x144>
  803c1f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803c23:	29 f2                	sub    %esi,%edx
  803c25:	19 cb                	sbb    %ecx,%ebx
  803c27:	89 d8                	mov    %ebx,%eax
  803c29:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803c2d:	d3 e0                	shl    %cl,%eax
  803c2f:	89 e9                	mov    %ebp,%ecx
  803c31:	d3 ea                	shr    %cl,%edx
  803c33:	09 d0                	or     %edx,%eax
  803c35:	89 e9                	mov    %ebp,%ecx
  803c37:	d3 eb                	shr    %cl,%ebx
  803c39:	89 da                	mov    %ebx,%edx
  803c3b:	83 c4 1c             	add    $0x1c,%esp
  803c3e:	5b                   	pop    %ebx
  803c3f:	5e                   	pop    %esi
  803c40:	5f                   	pop    %edi
  803c41:	5d                   	pop    %ebp
  803c42:	c3                   	ret    
  803c43:	90                   	nop
  803c44:	89 fd                	mov    %edi,%ebp
  803c46:	85 ff                	test   %edi,%edi
  803c48:	75 0b                	jne    803c55 <__umoddi3+0xe9>
  803c4a:	b8 01 00 00 00       	mov    $0x1,%eax
  803c4f:	31 d2                	xor    %edx,%edx
  803c51:	f7 f7                	div    %edi
  803c53:	89 c5                	mov    %eax,%ebp
  803c55:	89 f0                	mov    %esi,%eax
  803c57:	31 d2                	xor    %edx,%edx
  803c59:	f7 f5                	div    %ebp
  803c5b:	89 c8                	mov    %ecx,%eax
  803c5d:	f7 f5                	div    %ebp
  803c5f:	89 d0                	mov    %edx,%eax
  803c61:	e9 44 ff ff ff       	jmp    803baa <__umoddi3+0x3e>
  803c66:	66 90                	xchg   %ax,%ax
  803c68:	89 c8                	mov    %ecx,%eax
  803c6a:	89 f2                	mov    %esi,%edx
  803c6c:	83 c4 1c             	add    $0x1c,%esp
  803c6f:	5b                   	pop    %ebx
  803c70:	5e                   	pop    %esi
  803c71:	5f                   	pop    %edi
  803c72:	5d                   	pop    %ebp
  803c73:	c3                   	ret    
  803c74:	3b 04 24             	cmp    (%esp),%eax
  803c77:	72 06                	jb     803c7f <__umoddi3+0x113>
  803c79:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803c7d:	77 0f                	ja     803c8e <__umoddi3+0x122>
  803c7f:	89 f2                	mov    %esi,%edx
  803c81:	29 f9                	sub    %edi,%ecx
  803c83:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803c87:	89 14 24             	mov    %edx,(%esp)
  803c8a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c8e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803c92:	8b 14 24             	mov    (%esp),%edx
  803c95:	83 c4 1c             	add    $0x1c,%esp
  803c98:	5b                   	pop    %ebx
  803c99:	5e                   	pop    %esi
  803c9a:	5f                   	pop    %edi
  803c9b:	5d                   	pop    %ebp
  803c9c:	c3                   	ret    
  803c9d:	8d 76 00             	lea    0x0(%esi),%esi
  803ca0:	2b 04 24             	sub    (%esp),%eax
  803ca3:	19 fa                	sbb    %edi,%edx
  803ca5:	89 d1                	mov    %edx,%ecx
  803ca7:	89 c6                	mov    %eax,%esi
  803ca9:	e9 71 ff ff ff       	jmp    803c1f <__umoddi3+0xb3>
  803cae:	66 90                	xchg   %ax,%ax
  803cb0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803cb4:	72 ea                	jb     803ca0 <__umoddi3+0x134>
  803cb6:	89 d9                	mov    %ebx,%ecx
  803cb8:	e9 62 ff ff ff       	jmp    803c1f <__umoddi3+0xb3>
