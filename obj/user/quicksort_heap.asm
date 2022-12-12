
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
  800041:	e8 02 1f 00 00       	call   801f48 <sys_disable_interrupt>
		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 a0 3c 80 00       	push   $0x803ca0
  80004e:	e8 f2 09 00 00       	call   800a45 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 a2 3c 80 00       	push   $0x803ca2
  80005e:	e8 e2 09 00 00       	call   800a45 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!   QUICK SORT   !!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 bb 3c 80 00       	push   $0x803cbb
  80006e:	e8 d2 09 00 00       	call   800a45 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 a2 3c 80 00       	push   $0x803ca2
  80007e:	e8 c2 09 00 00       	call   800a45 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 a0 3c 80 00       	push   $0x803ca0
  80008e:	e8 b2 09 00 00       	call   800a45 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp

		readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 d4 3c 80 00       	push   $0x803cd4
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
  8000d0:	e8 fe 1a 00 00       	call   801bd3 <malloc>
  8000d5:	83 c4 10             	add    $0x10,%esp
  8000d8:	89 45 ec             	mov    %eax,-0x14(%ebp)
		cprintf("Chose the initialization method:\n") ;
  8000db:	83 ec 0c             	sub    $0xc,%esp
  8000de:	68 f4 3c 80 00       	push   $0x803cf4
  8000e3:	e8 5d 09 00 00       	call   800a45 <cprintf>
  8000e8:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000eb:	83 ec 0c             	sub    $0xc,%esp
  8000ee:	68 16 3d 80 00       	push   $0x803d16
  8000f3:	e8 4d 09 00 00       	call   800a45 <cprintf>
  8000f8:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000fb:	83 ec 0c             	sub    $0xc,%esp
  8000fe:	68 24 3d 80 00       	push   $0x803d24
  800103:	e8 3d 09 00 00       	call   800a45 <cprintf>
  800108:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 33 3d 80 00       	push   $0x803d33
  800113:	e8 2d 09 00 00       	call   800a45 <cprintf>
  800118:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	68 43 3d 80 00       	push   $0x803d43
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
  800162:	e8 fb 1d 00 00       	call   801f62 <sys_enable_interrupt>

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
  8001d5:	e8 6e 1d 00 00       	call   801f48 <sys_disable_interrupt>
			cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001da:	83 ec 0c             	sub    $0xc,%esp
  8001dd:	68 4c 3d 80 00       	push   $0x803d4c
  8001e2:	e8 5e 08 00 00       	call   800a45 <cprintf>
  8001e7:	83 c4 10             	add    $0x10,%esp
		//		PrintElements(Elements, NumOfElements);
		sys_enable_interrupt();
  8001ea:	e8 73 1d 00 00       	call   801f62 <sys_enable_interrupt>

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
  80020c:	68 80 3d 80 00       	push   $0x803d80
  800211:	6a 48                	push   $0x48
  800213:	68 a2 3d 80 00       	push   $0x803da2
  800218:	e8 74 05 00 00       	call   800791 <_panic>
		else
		{
			sys_disable_interrupt();
  80021d:	e8 26 1d 00 00       	call   801f48 <sys_disable_interrupt>
			cprintf("\n===============================================\n") ;
  800222:	83 ec 0c             	sub    $0xc,%esp
  800225:	68 b8 3d 80 00       	push   $0x803db8
  80022a:	e8 16 08 00 00       	call   800a45 <cprintf>
  80022f:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  800232:	83 ec 0c             	sub    $0xc,%esp
  800235:	68 ec 3d 80 00       	push   $0x803dec
  80023a:	e8 06 08 00 00       	call   800a45 <cprintf>
  80023f:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  800242:	83 ec 0c             	sub    $0xc,%esp
  800245:	68 20 3e 80 00       	push   $0x803e20
  80024a:	e8 f6 07 00 00       	call   800a45 <cprintf>
  80024f:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800252:	e8 0b 1d 00 00       	call   801f62 <sys_enable_interrupt>
		}

		sys_disable_interrupt();
  800257:	e8 ec 1c 00 00       	call   801f48 <sys_disable_interrupt>
			Chose = 0 ;
  80025c:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800260:	eb 42                	jmp    8002a4 <_main+0x26c>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800262:	83 ec 0c             	sub    $0xc,%esp
  800265:	68 52 3e 80 00       	push   $0x803e52
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
  8002b0:	e8 ad 1c 00 00       	call   801f62 <sys_enable_interrupt>

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
  800555:	68 a0 3c 80 00       	push   $0x803ca0
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
  800577:	68 70 3e 80 00       	push   $0x803e70
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
  8005a5:	68 75 3e 80 00       	push   $0x803e75
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
  8005c9:	e8 ae 19 00 00       	call   801f7c <sys_cputc>
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
  8005da:	e8 69 19 00 00       	call   801f48 <sys_disable_interrupt>
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
  8005ed:	e8 8a 19 00 00       	call   801f7c <sys_cputc>
  8005f2:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8005f5:	e8 68 19 00 00       	call   801f62 <sys_enable_interrupt>
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
  80060c:	e8 b2 17 00 00       	call   801dc3 <sys_cgetc>
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
  800625:	e8 1e 19 00 00       	call   801f48 <sys_disable_interrupt>
	int c=0;
  80062a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800631:	eb 08                	jmp    80063b <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  800633:	e8 8b 17 00 00       	call   801dc3 <sys_cgetc>
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
  800641:	e8 1c 19 00 00       	call   801f62 <sys_enable_interrupt>
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
  80065b:	e8 db 1a 00 00       	call   80213b <sys_getenvindex>
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
  800682:	a3 24 50 80 00       	mov    %eax,0x805024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800687:	a1 24 50 80 00       	mov    0x805024,%eax
  80068c:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800692:	84 c0                	test   %al,%al
  800694:	74 0f                	je     8006a5 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800696:	a1 24 50 80 00       	mov    0x805024,%eax
  80069b:	05 5c 05 00 00       	add    $0x55c,%eax
  8006a0:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8006a5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8006a9:	7e 0a                	jle    8006b5 <libmain+0x60>
		binaryname = argv[0];
  8006ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006ae:	8b 00                	mov    (%eax),%eax
  8006b0:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8006b5:	83 ec 08             	sub    $0x8,%esp
  8006b8:	ff 75 0c             	pushl  0xc(%ebp)
  8006bb:	ff 75 08             	pushl  0x8(%ebp)
  8006be:	e8 75 f9 ff ff       	call   800038 <_main>
  8006c3:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8006c6:	e8 7d 18 00 00       	call   801f48 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8006cb:	83 ec 0c             	sub    $0xc,%esp
  8006ce:	68 94 3e 80 00       	push   $0x803e94
  8006d3:	e8 6d 03 00 00       	call   800a45 <cprintf>
  8006d8:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8006db:	a1 24 50 80 00       	mov    0x805024,%eax
  8006e0:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8006e6:	a1 24 50 80 00       	mov    0x805024,%eax
  8006eb:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8006f1:	83 ec 04             	sub    $0x4,%esp
  8006f4:	52                   	push   %edx
  8006f5:	50                   	push   %eax
  8006f6:	68 bc 3e 80 00       	push   $0x803ebc
  8006fb:	e8 45 03 00 00       	call   800a45 <cprintf>
  800700:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800703:	a1 24 50 80 00       	mov    0x805024,%eax
  800708:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80070e:	a1 24 50 80 00       	mov    0x805024,%eax
  800713:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800719:	a1 24 50 80 00       	mov    0x805024,%eax
  80071e:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800724:	51                   	push   %ecx
  800725:	52                   	push   %edx
  800726:	50                   	push   %eax
  800727:	68 e4 3e 80 00       	push   $0x803ee4
  80072c:	e8 14 03 00 00       	call   800a45 <cprintf>
  800731:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800734:	a1 24 50 80 00       	mov    0x805024,%eax
  800739:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80073f:	83 ec 08             	sub    $0x8,%esp
  800742:	50                   	push   %eax
  800743:	68 3c 3f 80 00       	push   $0x803f3c
  800748:	e8 f8 02 00 00       	call   800a45 <cprintf>
  80074d:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800750:	83 ec 0c             	sub    $0xc,%esp
  800753:	68 94 3e 80 00       	push   $0x803e94
  800758:	e8 e8 02 00 00       	call   800a45 <cprintf>
  80075d:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800760:	e8 fd 17 00 00       	call   801f62 <sys_enable_interrupt>

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
  800778:	e8 8a 19 00 00       	call   802107 <sys_destroy_env>
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
  800789:	e8 df 19 00 00       	call   80216d <sys_exit_env>
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
  8007a0:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8007a5:	85 c0                	test   %eax,%eax
  8007a7:	74 16                	je     8007bf <_panic+0x2e>
		cprintf("%s: ", argv0);
  8007a9:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8007ae:	83 ec 08             	sub    $0x8,%esp
  8007b1:	50                   	push   %eax
  8007b2:	68 50 3f 80 00       	push   $0x803f50
  8007b7:	e8 89 02 00 00       	call   800a45 <cprintf>
  8007bc:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8007bf:	a1 00 50 80 00       	mov    0x805000,%eax
  8007c4:	ff 75 0c             	pushl  0xc(%ebp)
  8007c7:	ff 75 08             	pushl  0x8(%ebp)
  8007ca:	50                   	push   %eax
  8007cb:	68 55 3f 80 00       	push   $0x803f55
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
  8007ef:	68 71 3f 80 00       	push   $0x803f71
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
  800809:	a1 24 50 80 00       	mov    0x805024,%eax
  80080e:	8b 50 74             	mov    0x74(%eax),%edx
  800811:	8b 45 0c             	mov    0xc(%ebp),%eax
  800814:	39 c2                	cmp    %eax,%edx
  800816:	74 14                	je     80082c <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800818:	83 ec 04             	sub    $0x4,%esp
  80081b:	68 74 3f 80 00       	push   $0x803f74
  800820:	6a 26                	push   $0x26
  800822:	68 c0 3f 80 00       	push   $0x803fc0
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
  80086c:	a1 24 50 80 00       	mov    0x805024,%eax
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
  80088c:	a1 24 50 80 00       	mov    0x805024,%eax
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
  8008d5:	a1 24 50 80 00       	mov    0x805024,%eax
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
  8008ed:	68 cc 3f 80 00       	push   $0x803fcc
  8008f2:	6a 3a                	push   $0x3a
  8008f4:	68 c0 3f 80 00       	push   $0x803fc0
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
  80091d:	a1 24 50 80 00       	mov    0x805024,%eax
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
  800943:	a1 24 50 80 00       	mov    0x805024,%eax
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
  80095d:	68 20 40 80 00       	push   $0x804020
  800962:	6a 44                	push   $0x44
  800964:	68 c0 3f 80 00       	push   $0x803fc0
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
  80099c:	a0 28 50 80 00       	mov    0x805028,%al
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
  8009b7:	e8 de 13 00 00       	call   801d9a <sys_cputs>
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
  800a11:	a0 28 50 80 00       	mov    0x805028,%al
  800a16:	0f b6 c0             	movzbl %al,%eax
  800a19:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800a1f:	83 ec 04             	sub    $0x4,%esp
  800a22:	50                   	push   %eax
  800a23:	52                   	push   %edx
  800a24:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a2a:	83 c0 08             	add    $0x8,%eax
  800a2d:	50                   	push   %eax
  800a2e:	e8 67 13 00 00       	call   801d9a <sys_cputs>
  800a33:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800a36:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
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
  800a4b:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
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
  800a78:	e8 cb 14 00 00       	call   801f48 <sys_disable_interrupt>
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
  800a98:	e8 c5 14 00 00       	call   801f62 <sys_enable_interrupt>
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
  800ae2:	e8 39 2f 00 00       	call   803a20 <__udivdi3>
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
  800b32:	e8 f9 2f 00 00       	call   803b30 <__umoddi3>
  800b37:	83 c4 10             	add    $0x10,%esp
  800b3a:	05 94 42 80 00       	add    $0x804294,%eax
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
  800c8d:	8b 04 85 b8 42 80 00 	mov    0x8042b8(,%eax,4),%eax
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
  800d6e:	8b 34 9d 00 41 80 00 	mov    0x804100(,%ebx,4),%esi
  800d75:	85 f6                	test   %esi,%esi
  800d77:	75 19                	jne    800d92 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d79:	53                   	push   %ebx
  800d7a:	68 a5 42 80 00       	push   $0x8042a5
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
  800d93:	68 ae 42 80 00       	push   $0x8042ae
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
  800dc0:	be b1 42 80 00       	mov    $0x8042b1,%esi
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
  8010d9:	68 10 44 80 00       	push   $0x804410
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
  80111b:	68 13 44 80 00       	push   $0x804413
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
  8011cb:	e8 78 0d 00 00       	call   801f48 <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  8011d0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011d4:	74 13                	je     8011e9 <atomic_readline+0x24>
		cprintf("%s", prompt);
  8011d6:	83 ec 08             	sub    $0x8,%esp
  8011d9:	ff 75 08             	pushl  0x8(%ebp)
  8011dc:	68 10 44 80 00       	push   $0x804410
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
  80121a:	68 13 44 80 00       	push   $0x804413
  80121f:	e8 21 f8 ff ff       	call   800a45 <cprintf>
  801224:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  801227:	e8 36 0d 00 00       	call   801f62 <sys_enable_interrupt>
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
  8012bf:	e8 9e 0c 00 00       	call   801f62 <sys_enable_interrupt>
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
  8019db:	a1 04 50 80 00       	mov    0x805004,%eax
  8019e0:	85 c0                	test   %eax,%eax
  8019e2:	74 1f                	je     801a03 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8019e4:	e8 1d 00 00 00       	call   801a06 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8019e9:	83 ec 0c             	sub    $0xc,%esp
  8019ec:	68 24 44 80 00       	push   $0x804424
  8019f1:	e8 4f f0 ff ff       	call   800a45 <cprintf>
  8019f6:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8019f9:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
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
  801a09:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	LIST_INIT(&AllocMemBlocksList);
  801a0c:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801a13:	00 00 00 
  801a16:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801a1d:	00 00 00 
  801a20:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801a27:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801a2a:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801a31:	00 00 00 
  801a34:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801a3b:	00 00 00 
  801a3e:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801a45:	00 00 00 
	uint32 arr_size = 0;
  801a48:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	MemBlockNodes  =(struct MemBlock*) USER_DYN_BLKS_ARRAY;
  801a4f:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801a56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a59:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801a5e:	2d 00 10 00 00       	sub    $0x1000,%eax
  801a63:	a3 50 50 80 00       	mov    %eax,0x805050
	MAX_MEM_BLOCK_CNT = (USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE;
  801a68:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801a6f:	00 02 00 
	arr_size =  ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock), PAGE_SIZE);
  801a72:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801a79:	a1 20 51 80 00       	mov    0x805120,%eax
  801a7e:	c1 e0 04             	shl    $0x4,%eax
  801a81:	89 c2                	mov    %eax,%edx
  801a83:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a86:	01 d0                	add    %edx,%eax
  801a88:	48                   	dec    %eax
  801a89:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801a8c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a8f:	ba 00 00 00 00       	mov    $0x0,%edx
  801a94:	f7 75 ec             	divl   -0x14(%ebp)
  801a97:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a9a:	29 d0                	sub    %edx,%eax
  801a9c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_USER);
  801a9f:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801aa6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801aa9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801aae:	2d 00 10 00 00       	sub    $0x1000,%eax
  801ab3:	83 ec 04             	sub    $0x4,%esp
  801ab6:	6a 06                	push   $0x6
  801ab8:	ff 75 f4             	pushl  -0xc(%ebp)
  801abb:	50                   	push   %eax
  801abc:	e8 1d 04 00 00       	call   801ede <sys_allocate_chunk>
  801ac1:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801ac4:	a1 20 51 80 00       	mov    0x805120,%eax
  801ac9:	83 ec 0c             	sub    $0xc,%esp
  801acc:	50                   	push   %eax
  801acd:	e8 92 0a 00 00       	call   802564 <initialize_MemBlocksList>
  801ad2:	83 c4 10             	add    $0x10,%esp
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	struct MemBlock * NewBlock = LIST_FIRST(&AvailableMemBlocksList);
  801ad5:	a1 48 51 80 00       	mov    0x805148,%eax
  801ada:	89 45 e0             	mov    %eax,-0x20(%ebp)
	NewBlock->sva = USER_HEAP_START;
  801add:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ae0:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	NewBlock->size = (USER_HEAP_MAX-USER_HEAP_START);
  801ae7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801aea:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	LIST_REMOVE(&AvailableMemBlocksList,NewBlock);
  801af1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801af5:	75 14                	jne    801b0b <initialize_dyn_block_system+0x105>
  801af7:	83 ec 04             	sub    $0x4,%esp
  801afa:	68 49 44 80 00       	push   $0x804449
  801aff:	6a 33                	push   $0x33
  801b01:	68 67 44 80 00       	push   $0x804467
  801b06:	e8 86 ec ff ff       	call   800791 <_panic>
  801b0b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b0e:	8b 00                	mov    (%eax),%eax
  801b10:	85 c0                	test   %eax,%eax
  801b12:	74 10                	je     801b24 <initialize_dyn_block_system+0x11e>
  801b14:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b17:	8b 00                	mov    (%eax),%eax
  801b19:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b1c:	8b 52 04             	mov    0x4(%edx),%edx
  801b1f:	89 50 04             	mov    %edx,0x4(%eax)
  801b22:	eb 0b                	jmp    801b2f <initialize_dyn_block_system+0x129>
  801b24:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b27:	8b 40 04             	mov    0x4(%eax),%eax
  801b2a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801b2f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b32:	8b 40 04             	mov    0x4(%eax),%eax
  801b35:	85 c0                	test   %eax,%eax
  801b37:	74 0f                	je     801b48 <initialize_dyn_block_system+0x142>
  801b39:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b3c:	8b 40 04             	mov    0x4(%eax),%eax
  801b3f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b42:	8b 12                	mov    (%edx),%edx
  801b44:	89 10                	mov    %edx,(%eax)
  801b46:	eb 0a                	jmp    801b52 <initialize_dyn_block_system+0x14c>
  801b48:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b4b:	8b 00                	mov    (%eax),%eax
  801b4d:	a3 48 51 80 00       	mov    %eax,0x805148
  801b52:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b55:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801b5b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b5e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801b65:	a1 54 51 80 00       	mov    0x805154,%eax
  801b6a:	48                   	dec    %eax
  801b6b:	a3 54 51 80 00       	mov    %eax,0x805154
	LIST_INSERT_HEAD(&FreeMemBlocksList, NewBlock);
  801b70:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801b74:	75 14                	jne    801b8a <initialize_dyn_block_system+0x184>
  801b76:	83 ec 04             	sub    $0x4,%esp
  801b79:	68 74 44 80 00       	push   $0x804474
  801b7e:	6a 34                	push   $0x34
  801b80:	68 67 44 80 00       	push   $0x804467
  801b85:	e8 07 ec ff ff       	call   800791 <_panic>
  801b8a:	8b 15 38 51 80 00    	mov    0x805138,%edx
  801b90:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b93:	89 10                	mov    %edx,(%eax)
  801b95:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b98:	8b 00                	mov    (%eax),%eax
  801b9a:	85 c0                	test   %eax,%eax
  801b9c:	74 0d                	je     801bab <initialize_dyn_block_system+0x1a5>
  801b9e:	a1 38 51 80 00       	mov    0x805138,%eax
  801ba3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ba6:	89 50 04             	mov    %edx,0x4(%eax)
  801ba9:	eb 08                	jmp    801bb3 <initialize_dyn_block_system+0x1ad>
  801bab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bae:	a3 3c 51 80 00       	mov    %eax,0x80513c
  801bb3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bb6:	a3 38 51 80 00       	mov    %eax,0x805138
  801bbb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bbe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801bc5:	a1 44 51 80 00       	mov    0x805144,%eax
  801bca:	40                   	inc    %eax
  801bcb:	a3 44 51 80 00       	mov    %eax,0x805144
}
  801bd0:	90                   	nop
  801bd1:	c9                   	leave  
  801bd2:	c3                   	ret    

00801bd3 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801bd3:	55                   	push   %ebp
  801bd4:	89 e5                	mov    %esp,%ebp
  801bd6:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801bd9:	e8 f7 fd ff ff       	call   8019d5 <InitializeUHeap>
	if (size == 0) return NULL ;
  801bde:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801be2:	75 07                	jne    801beb <malloc+0x18>
  801be4:	b8 00 00 00 00       	mov    $0x0,%eax
  801be9:	eb 14                	jmp    801bff <malloc+0x2c>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801beb:	83 ec 04             	sub    $0x4,%esp
  801bee:	68 98 44 80 00       	push   $0x804498
  801bf3:	6a 46                	push   $0x46
  801bf5:	68 67 44 80 00       	push   $0x804467
  801bfa:	e8 92 eb ff ff       	call   800791 <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801bff:	c9                   	leave  
  801c00:	c3                   	ret    

00801c01 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801c01:	55                   	push   %ebp
  801c02:	89 e5                	mov    %esp,%ebp
  801c04:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801c07:	83 ec 04             	sub    $0x4,%esp
  801c0a:	68 c0 44 80 00       	push   $0x8044c0
  801c0f:	6a 61                	push   $0x61
  801c11:	68 67 44 80 00       	push   $0x804467
  801c16:	e8 76 eb ff ff       	call   800791 <_panic>

00801c1b <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801c1b:	55                   	push   %ebp
  801c1c:	89 e5                	mov    %esp,%ebp
  801c1e:	83 ec 38             	sub    $0x38,%esp
  801c21:	8b 45 10             	mov    0x10(%ebp),%eax
  801c24:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801c27:	e8 a9 fd ff ff       	call   8019d5 <InitializeUHeap>
	if (size == 0) return NULL ;
  801c2c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801c30:	75 07                	jne    801c39 <smalloc+0x1e>
  801c32:	b8 00 00 00 00       	mov    $0x0,%eax
  801c37:	eb 7c                	jmp    801cb5 <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801c39:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801c40:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c46:	01 d0                	add    %edx,%eax
  801c48:	48                   	dec    %eax
  801c49:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801c4c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c4f:	ba 00 00 00 00       	mov    $0x0,%edx
  801c54:	f7 75 f0             	divl   -0x10(%ebp)
  801c57:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c5a:	29 d0                	sub    %edx,%eax
  801c5c:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801c5f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801c66:	e8 41 06 00 00       	call   8022ac <sys_isUHeapPlacementStrategyFIRSTFIT>
  801c6b:	85 c0                	test   %eax,%eax
  801c6d:	74 11                	je     801c80 <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  801c6f:	83 ec 0c             	sub    $0xc,%esp
  801c72:	ff 75 e8             	pushl  -0x18(%ebp)
  801c75:	e8 ac 0c 00 00       	call   802926 <alloc_block_FF>
  801c7a:	83 c4 10             	add    $0x10,%esp
  801c7d:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  801c80:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c84:	74 2a                	je     801cb0 <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801c86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c89:	8b 40 08             	mov    0x8(%eax),%eax
  801c8c:	89 c2                	mov    %eax,%edx
  801c8e:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801c92:	52                   	push   %edx
  801c93:	50                   	push   %eax
  801c94:	ff 75 0c             	pushl  0xc(%ebp)
  801c97:	ff 75 08             	pushl  0x8(%ebp)
  801c9a:	e8 92 03 00 00       	call   802031 <sys_createSharedObject>
  801c9f:	83 c4 10             	add    $0x10,%esp
  801ca2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  801ca5:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  801ca9:	74 05                	je     801cb0 <smalloc+0x95>
			return (void*)virtual_address;
  801cab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801cae:	eb 05                	jmp    801cb5 <smalloc+0x9a>
	}
	return NULL;
  801cb0:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801cb5:	c9                   	leave  
  801cb6:	c3                   	ret    

00801cb7 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801cb7:	55                   	push   %ebp
  801cb8:	89 e5                	mov    %esp,%ebp
  801cba:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801cbd:	e8 13 fd ff ff       	call   8019d5 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801cc2:	83 ec 04             	sub    $0x4,%esp
  801cc5:	68 e4 44 80 00       	push   $0x8044e4
  801cca:	68 a2 00 00 00       	push   $0xa2
  801ccf:	68 67 44 80 00       	push   $0x804467
  801cd4:	e8 b8 ea ff ff       	call   800791 <_panic>

00801cd9 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801cd9:	55                   	push   %ebp
  801cda:	89 e5                	mov    %esp,%ebp
  801cdc:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801cdf:	e8 f1 fc ff ff       	call   8019d5 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801ce4:	83 ec 04             	sub    $0x4,%esp
  801ce7:	68 08 45 80 00       	push   $0x804508
  801cec:	68 e6 00 00 00       	push   $0xe6
  801cf1:	68 67 44 80 00       	push   $0x804467
  801cf6:	e8 96 ea ff ff       	call   800791 <_panic>

00801cfb <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801cfb:	55                   	push   %ebp
  801cfc:	89 e5                	mov    %esp,%ebp
  801cfe:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801d01:	83 ec 04             	sub    $0x4,%esp
  801d04:	68 30 45 80 00       	push   $0x804530
  801d09:	68 fa 00 00 00       	push   $0xfa
  801d0e:	68 67 44 80 00       	push   $0x804467
  801d13:	e8 79 ea ff ff       	call   800791 <_panic>

00801d18 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801d18:	55                   	push   %ebp
  801d19:	89 e5                	mov    %esp,%ebp
  801d1b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801d1e:	83 ec 04             	sub    $0x4,%esp
  801d21:	68 54 45 80 00       	push   $0x804554
  801d26:	68 05 01 00 00       	push   $0x105
  801d2b:	68 67 44 80 00       	push   $0x804467
  801d30:	e8 5c ea ff ff       	call   800791 <_panic>

00801d35 <shrink>:

}
void shrink(uint32 newSize)
{
  801d35:	55                   	push   %ebp
  801d36:	89 e5                	mov    %esp,%ebp
  801d38:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801d3b:	83 ec 04             	sub    $0x4,%esp
  801d3e:	68 54 45 80 00       	push   $0x804554
  801d43:	68 0a 01 00 00       	push   $0x10a
  801d48:	68 67 44 80 00       	push   $0x804467
  801d4d:	e8 3f ea ff ff       	call   800791 <_panic>

00801d52 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801d52:	55                   	push   %ebp
  801d53:	89 e5                	mov    %esp,%ebp
  801d55:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801d58:	83 ec 04             	sub    $0x4,%esp
  801d5b:	68 54 45 80 00       	push   $0x804554
  801d60:	68 0f 01 00 00       	push   $0x10f
  801d65:	68 67 44 80 00       	push   $0x804467
  801d6a:	e8 22 ea ff ff       	call   800791 <_panic>

00801d6f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801d6f:	55                   	push   %ebp
  801d70:	89 e5                	mov    %esp,%ebp
  801d72:	57                   	push   %edi
  801d73:	56                   	push   %esi
  801d74:	53                   	push   %ebx
  801d75:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801d78:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d7e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d81:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d84:	8b 7d 18             	mov    0x18(%ebp),%edi
  801d87:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801d8a:	cd 30                	int    $0x30
  801d8c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801d8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801d92:	83 c4 10             	add    $0x10,%esp
  801d95:	5b                   	pop    %ebx
  801d96:	5e                   	pop    %esi
  801d97:	5f                   	pop    %edi
  801d98:	5d                   	pop    %ebp
  801d99:	c3                   	ret    

00801d9a <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801d9a:	55                   	push   %ebp
  801d9b:	89 e5                	mov    %esp,%ebp
  801d9d:	83 ec 04             	sub    $0x4,%esp
  801da0:	8b 45 10             	mov    0x10(%ebp),%eax
  801da3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801da6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801daa:	8b 45 08             	mov    0x8(%ebp),%eax
  801dad:	6a 00                	push   $0x0
  801daf:	6a 00                	push   $0x0
  801db1:	52                   	push   %edx
  801db2:	ff 75 0c             	pushl  0xc(%ebp)
  801db5:	50                   	push   %eax
  801db6:	6a 00                	push   $0x0
  801db8:	e8 b2 ff ff ff       	call   801d6f <syscall>
  801dbd:	83 c4 18             	add    $0x18,%esp
}
  801dc0:	90                   	nop
  801dc1:	c9                   	leave  
  801dc2:	c3                   	ret    

00801dc3 <sys_cgetc>:

int
sys_cgetc(void)
{
  801dc3:	55                   	push   %ebp
  801dc4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801dc6:	6a 00                	push   $0x0
  801dc8:	6a 00                	push   $0x0
  801dca:	6a 00                	push   $0x0
  801dcc:	6a 00                	push   $0x0
  801dce:	6a 00                	push   $0x0
  801dd0:	6a 01                	push   $0x1
  801dd2:	e8 98 ff ff ff       	call   801d6f <syscall>
  801dd7:	83 c4 18             	add    $0x18,%esp
}
  801dda:	c9                   	leave  
  801ddb:	c3                   	ret    

00801ddc <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801ddc:	55                   	push   %ebp
  801ddd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801ddf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801de2:	8b 45 08             	mov    0x8(%ebp),%eax
  801de5:	6a 00                	push   $0x0
  801de7:	6a 00                	push   $0x0
  801de9:	6a 00                	push   $0x0
  801deb:	52                   	push   %edx
  801dec:	50                   	push   %eax
  801ded:	6a 05                	push   $0x5
  801def:	e8 7b ff ff ff       	call   801d6f <syscall>
  801df4:	83 c4 18             	add    $0x18,%esp
}
  801df7:	c9                   	leave  
  801df8:	c3                   	ret    

00801df9 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801df9:	55                   	push   %ebp
  801dfa:	89 e5                	mov    %esp,%ebp
  801dfc:	56                   	push   %esi
  801dfd:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801dfe:	8b 75 18             	mov    0x18(%ebp),%esi
  801e01:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e04:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e07:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0d:	56                   	push   %esi
  801e0e:	53                   	push   %ebx
  801e0f:	51                   	push   %ecx
  801e10:	52                   	push   %edx
  801e11:	50                   	push   %eax
  801e12:	6a 06                	push   $0x6
  801e14:	e8 56 ff ff ff       	call   801d6f <syscall>
  801e19:	83 c4 18             	add    $0x18,%esp
}
  801e1c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e1f:	5b                   	pop    %ebx
  801e20:	5e                   	pop    %esi
  801e21:	5d                   	pop    %ebp
  801e22:	c3                   	ret    

00801e23 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801e23:	55                   	push   %ebp
  801e24:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801e26:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e29:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2c:	6a 00                	push   $0x0
  801e2e:	6a 00                	push   $0x0
  801e30:	6a 00                	push   $0x0
  801e32:	52                   	push   %edx
  801e33:	50                   	push   %eax
  801e34:	6a 07                	push   $0x7
  801e36:	e8 34 ff ff ff       	call   801d6f <syscall>
  801e3b:	83 c4 18             	add    $0x18,%esp
}
  801e3e:	c9                   	leave  
  801e3f:	c3                   	ret    

00801e40 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801e40:	55                   	push   %ebp
  801e41:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801e43:	6a 00                	push   $0x0
  801e45:	6a 00                	push   $0x0
  801e47:	6a 00                	push   $0x0
  801e49:	ff 75 0c             	pushl  0xc(%ebp)
  801e4c:	ff 75 08             	pushl  0x8(%ebp)
  801e4f:	6a 08                	push   $0x8
  801e51:	e8 19 ff ff ff       	call   801d6f <syscall>
  801e56:	83 c4 18             	add    $0x18,%esp
}
  801e59:	c9                   	leave  
  801e5a:	c3                   	ret    

00801e5b <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801e5b:	55                   	push   %ebp
  801e5c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801e5e:	6a 00                	push   $0x0
  801e60:	6a 00                	push   $0x0
  801e62:	6a 00                	push   $0x0
  801e64:	6a 00                	push   $0x0
  801e66:	6a 00                	push   $0x0
  801e68:	6a 09                	push   $0x9
  801e6a:	e8 00 ff ff ff       	call   801d6f <syscall>
  801e6f:	83 c4 18             	add    $0x18,%esp
}
  801e72:	c9                   	leave  
  801e73:	c3                   	ret    

00801e74 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801e74:	55                   	push   %ebp
  801e75:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801e77:	6a 00                	push   $0x0
  801e79:	6a 00                	push   $0x0
  801e7b:	6a 00                	push   $0x0
  801e7d:	6a 00                	push   $0x0
  801e7f:	6a 00                	push   $0x0
  801e81:	6a 0a                	push   $0xa
  801e83:	e8 e7 fe ff ff       	call   801d6f <syscall>
  801e88:	83 c4 18             	add    $0x18,%esp
}
  801e8b:	c9                   	leave  
  801e8c:	c3                   	ret    

00801e8d <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801e8d:	55                   	push   %ebp
  801e8e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801e90:	6a 00                	push   $0x0
  801e92:	6a 00                	push   $0x0
  801e94:	6a 00                	push   $0x0
  801e96:	6a 00                	push   $0x0
  801e98:	6a 00                	push   $0x0
  801e9a:	6a 0b                	push   $0xb
  801e9c:	e8 ce fe ff ff       	call   801d6f <syscall>
  801ea1:	83 c4 18             	add    $0x18,%esp
}
  801ea4:	c9                   	leave  
  801ea5:	c3                   	ret    

00801ea6 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801ea6:	55                   	push   %ebp
  801ea7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801ea9:	6a 00                	push   $0x0
  801eab:	6a 00                	push   $0x0
  801ead:	6a 00                	push   $0x0
  801eaf:	ff 75 0c             	pushl  0xc(%ebp)
  801eb2:	ff 75 08             	pushl  0x8(%ebp)
  801eb5:	6a 0f                	push   $0xf
  801eb7:	e8 b3 fe ff ff       	call   801d6f <syscall>
  801ebc:	83 c4 18             	add    $0x18,%esp
	return;
  801ebf:	90                   	nop
}
  801ec0:	c9                   	leave  
  801ec1:	c3                   	ret    

00801ec2 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801ec2:	55                   	push   %ebp
  801ec3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801ec5:	6a 00                	push   $0x0
  801ec7:	6a 00                	push   $0x0
  801ec9:	6a 00                	push   $0x0
  801ecb:	ff 75 0c             	pushl  0xc(%ebp)
  801ece:	ff 75 08             	pushl  0x8(%ebp)
  801ed1:	6a 10                	push   $0x10
  801ed3:	e8 97 fe ff ff       	call   801d6f <syscall>
  801ed8:	83 c4 18             	add    $0x18,%esp
	return ;
  801edb:	90                   	nop
}
  801edc:	c9                   	leave  
  801edd:	c3                   	ret    

00801ede <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801ede:	55                   	push   %ebp
  801edf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801ee1:	6a 00                	push   $0x0
  801ee3:	6a 00                	push   $0x0
  801ee5:	ff 75 10             	pushl  0x10(%ebp)
  801ee8:	ff 75 0c             	pushl  0xc(%ebp)
  801eeb:	ff 75 08             	pushl  0x8(%ebp)
  801eee:	6a 11                	push   $0x11
  801ef0:	e8 7a fe ff ff       	call   801d6f <syscall>
  801ef5:	83 c4 18             	add    $0x18,%esp
	return ;
  801ef8:	90                   	nop
}
  801ef9:	c9                   	leave  
  801efa:	c3                   	ret    

00801efb <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801efb:	55                   	push   %ebp
  801efc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801efe:	6a 00                	push   $0x0
  801f00:	6a 00                	push   $0x0
  801f02:	6a 00                	push   $0x0
  801f04:	6a 00                	push   $0x0
  801f06:	6a 00                	push   $0x0
  801f08:	6a 0c                	push   $0xc
  801f0a:	e8 60 fe ff ff       	call   801d6f <syscall>
  801f0f:	83 c4 18             	add    $0x18,%esp
}
  801f12:	c9                   	leave  
  801f13:	c3                   	ret    

00801f14 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801f14:	55                   	push   %ebp
  801f15:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801f17:	6a 00                	push   $0x0
  801f19:	6a 00                	push   $0x0
  801f1b:	6a 00                	push   $0x0
  801f1d:	6a 00                	push   $0x0
  801f1f:	ff 75 08             	pushl  0x8(%ebp)
  801f22:	6a 0d                	push   $0xd
  801f24:	e8 46 fe ff ff       	call   801d6f <syscall>
  801f29:	83 c4 18             	add    $0x18,%esp
}
  801f2c:	c9                   	leave  
  801f2d:	c3                   	ret    

00801f2e <sys_scarce_memory>:

void sys_scarce_memory()
{
  801f2e:	55                   	push   %ebp
  801f2f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801f31:	6a 00                	push   $0x0
  801f33:	6a 00                	push   $0x0
  801f35:	6a 00                	push   $0x0
  801f37:	6a 00                	push   $0x0
  801f39:	6a 00                	push   $0x0
  801f3b:	6a 0e                	push   $0xe
  801f3d:	e8 2d fe ff ff       	call   801d6f <syscall>
  801f42:	83 c4 18             	add    $0x18,%esp
}
  801f45:	90                   	nop
  801f46:	c9                   	leave  
  801f47:	c3                   	ret    

00801f48 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801f48:	55                   	push   %ebp
  801f49:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801f4b:	6a 00                	push   $0x0
  801f4d:	6a 00                	push   $0x0
  801f4f:	6a 00                	push   $0x0
  801f51:	6a 00                	push   $0x0
  801f53:	6a 00                	push   $0x0
  801f55:	6a 13                	push   $0x13
  801f57:	e8 13 fe ff ff       	call   801d6f <syscall>
  801f5c:	83 c4 18             	add    $0x18,%esp
}
  801f5f:	90                   	nop
  801f60:	c9                   	leave  
  801f61:	c3                   	ret    

00801f62 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801f62:	55                   	push   %ebp
  801f63:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801f65:	6a 00                	push   $0x0
  801f67:	6a 00                	push   $0x0
  801f69:	6a 00                	push   $0x0
  801f6b:	6a 00                	push   $0x0
  801f6d:	6a 00                	push   $0x0
  801f6f:	6a 14                	push   $0x14
  801f71:	e8 f9 fd ff ff       	call   801d6f <syscall>
  801f76:	83 c4 18             	add    $0x18,%esp
}
  801f79:	90                   	nop
  801f7a:	c9                   	leave  
  801f7b:	c3                   	ret    

00801f7c <sys_cputc>:


void
sys_cputc(const char c)
{
  801f7c:	55                   	push   %ebp
  801f7d:	89 e5                	mov    %esp,%ebp
  801f7f:	83 ec 04             	sub    $0x4,%esp
  801f82:	8b 45 08             	mov    0x8(%ebp),%eax
  801f85:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801f88:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f8c:	6a 00                	push   $0x0
  801f8e:	6a 00                	push   $0x0
  801f90:	6a 00                	push   $0x0
  801f92:	6a 00                	push   $0x0
  801f94:	50                   	push   %eax
  801f95:	6a 15                	push   $0x15
  801f97:	e8 d3 fd ff ff       	call   801d6f <syscall>
  801f9c:	83 c4 18             	add    $0x18,%esp
}
  801f9f:	90                   	nop
  801fa0:	c9                   	leave  
  801fa1:	c3                   	ret    

00801fa2 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801fa2:	55                   	push   %ebp
  801fa3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801fa5:	6a 00                	push   $0x0
  801fa7:	6a 00                	push   $0x0
  801fa9:	6a 00                	push   $0x0
  801fab:	6a 00                	push   $0x0
  801fad:	6a 00                	push   $0x0
  801faf:	6a 16                	push   $0x16
  801fb1:	e8 b9 fd ff ff       	call   801d6f <syscall>
  801fb6:	83 c4 18             	add    $0x18,%esp
}
  801fb9:	90                   	nop
  801fba:	c9                   	leave  
  801fbb:	c3                   	ret    

00801fbc <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801fbc:	55                   	push   %ebp
  801fbd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801fbf:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc2:	6a 00                	push   $0x0
  801fc4:	6a 00                	push   $0x0
  801fc6:	6a 00                	push   $0x0
  801fc8:	ff 75 0c             	pushl  0xc(%ebp)
  801fcb:	50                   	push   %eax
  801fcc:	6a 17                	push   $0x17
  801fce:	e8 9c fd ff ff       	call   801d6f <syscall>
  801fd3:	83 c4 18             	add    $0x18,%esp
}
  801fd6:	c9                   	leave  
  801fd7:	c3                   	ret    

00801fd8 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801fd8:	55                   	push   %ebp
  801fd9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801fdb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fde:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe1:	6a 00                	push   $0x0
  801fe3:	6a 00                	push   $0x0
  801fe5:	6a 00                	push   $0x0
  801fe7:	52                   	push   %edx
  801fe8:	50                   	push   %eax
  801fe9:	6a 1a                	push   $0x1a
  801feb:	e8 7f fd ff ff       	call   801d6f <syscall>
  801ff0:	83 c4 18             	add    $0x18,%esp
}
  801ff3:	c9                   	leave  
  801ff4:	c3                   	ret    

00801ff5 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ff5:	55                   	push   %ebp
  801ff6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ff8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ffb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffe:	6a 00                	push   $0x0
  802000:	6a 00                	push   $0x0
  802002:	6a 00                	push   $0x0
  802004:	52                   	push   %edx
  802005:	50                   	push   %eax
  802006:	6a 18                	push   $0x18
  802008:	e8 62 fd ff ff       	call   801d6f <syscall>
  80200d:	83 c4 18             	add    $0x18,%esp
}
  802010:	90                   	nop
  802011:	c9                   	leave  
  802012:	c3                   	ret    

00802013 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802013:	55                   	push   %ebp
  802014:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802016:	8b 55 0c             	mov    0xc(%ebp),%edx
  802019:	8b 45 08             	mov    0x8(%ebp),%eax
  80201c:	6a 00                	push   $0x0
  80201e:	6a 00                	push   $0x0
  802020:	6a 00                	push   $0x0
  802022:	52                   	push   %edx
  802023:	50                   	push   %eax
  802024:	6a 19                	push   $0x19
  802026:	e8 44 fd ff ff       	call   801d6f <syscall>
  80202b:	83 c4 18             	add    $0x18,%esp
}
  80202e:	90                   	nop
  80202f:	c9                   	leave  
  802030:	c3                   	ret    

00802031 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802031:	55                   	push   %ebp
  802032:	89 e5                	mov    %esp,%ebp
  802034:	83 ec 04             	sub    $0x4,%esp
  802037:	8b 45 10             	mov    0x10(%ebp),%eax
  80203a:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80203d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802040:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802044:	8b 45 08             	mov    0x8(%ebp),%eax
  802047:	6a 00                	push   $0x0
  802049:	51                   	push   %ecx
  80204a:	52                   	push   %edx
  80204b:	ff 75 0c             	pushl  0xc(%ebp)
  80204e:	50                   	push   %eax
  80204f:	6a 1b                	push   $0x1b
  802051:	e8 19 fd ff ff       	call   801d6f <syscall>
  802056:	83 c4 18             	add    $0x18,%esp
}
  802059:	c9                   	leave  
  80205a:	c3                   	ret    

0080205b <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80205b:	55                   	push   %ebp
  80205c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80205e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802061:	8b 45 08             	mov    0x8(%ebp),%eax
  802064:	6a 00                	push   $0x0
  802066:	6a 00                	push   $0x0
  802068:	6a 00                	push   $0x0
  80206a:	52                   	push   %edx
  80206b:	50                   	push   %eax
  80206c:	6a 1c                	push   $0x1c
  80206e:	e8 fc fc ff ff       	call   801d6f <syscall>
  802073:	83 c4 18             	add    $0x18,%esp
}
  802076:	c9                   	leave  
  802077:	c3                   	ret    

00802078 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802078:	55                   	push   %ebp
  802079:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80207b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80207e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802081:	8b 45 08             	mov    0x8(%ebp),%eax
  802084:	6a 00                	push   $0x0
  802086:	6a 00                	push   $0x0
  802088:	51                   	push   %ecx
  802089:	52                   	push   %edx
  80208a:	50                   	push   %eax
  80208b:	6a 1d                	push   $0x1d
  80208d:	e8 dd fc ff ff       	call   801d6f <syscall>
  802092:	83 c4 18             	add    $0x18,%esp
}
  802095:	c9                   	leave  
  802096:	c3                   	ret    

00802097 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802097:	55                   	push   %ebp
  802098:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80209a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80209d:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a0:	6a 00                	push   $0x0
  8020a2:	6a 00                	push   $0x0
  8020a4:	6a 00                	push   $0x0
  8020a6:	52                   	push   %edx
  8020a7:	50                   	push   %eax
  8020a8:	6a 1e                	push   $0x1e
  8020aa:	e8 c0 fc ff ff       	call   801d6f <syscall>
  8020af:	83 c4 18             	add    $0x18,%esp
}
  8020b2:	c9                   	leave  
  8020b3:	c3                   	ret    

008020b4 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8020b4:	55                   	push   %ebp
  8020b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8020b7:	6a 00                	push   $0x0
  8020b9:	6a 00                	push   $0x0
  8020bb:	6a 00                	push   $0x0
  8020bd:	6a 00                	push   $0x0
  8020bf:	6a 00                	push   $0x0
  8020c1:	6a 1f                	push   $0x1f
  8020c3:	e8 a7 fc ff ff       	call   801d6f <syscall>
  8020c8:	83 c4 18             	add    $0x18,%esp
}
  8020cb:	c9                   	leave  
  8020cc:	c3                   	ret    

008020cd <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8020cd:	55                   	push   %ebp
  8020ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8020d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d3:	6a 00                	push   $0x0
  8020d5:	ff 75 14             	pushl  0x14(%ebp)
  8020d8:	ff 75 10             	pushl  0x10(%ebp)
  8020db:	ff 75 0c             	pushl  0xc(%ebp)
  8020de:	50                   	push   %eax
  8020df:	6a 20                	push   $0x20
  8020e1:	e8 89 fc ff ff       	call   801d6f <syscall>
  8020e6:	83 c4 18             	add    $0x18,%esp
}
  8020e9:	c9                   	leave  
  8020ea:	c3                   	ret    

008020eb <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8020eb:	55                   	push   %ebp
  8020ec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8020ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f1:	6a 00                	push   $0x0
  8020f3:	6a 00                	push   $0x0
  8020f5:	6a 00                	push   $0x0
  8020f7:	6a 00                	push   $0x0
  8020f9:	50                   	push   %eax
  8020fa:	6a 21                	push   $0x21
  8020fc:	e8 6e fc ff ff       	call   801d6f <syscall>
  802101:	83 c4 18             	add    $0x18,%esp
}
  802104:	90                   	nop
  802105:	c9                   	leave  
  802106:	c3                   	ret    

00802107 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802107:	55                   	push   %ebp
  802108:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80210a:	8b 45 08             	mov    0x8(%ebp),%eax
  80210d:	6a 00                	push   $0x0
  80210f:	6a 00                	push   $0x0
  802111:	6a 00                	push   $0x0
  802113:	6a 00                	push   $0x0
  802115:	50                   	push   %eax
  802116:	6a 22                	push   $0x22
  802118:	e8 52 fc ff ff       	call   801d6f <syscall>
  80211d:	83 c4 18             	add    $0x18,%esp
}
  802120:	c9                   	leave  
  802121:	c3                   	ret    

00802122 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802122:	55                   	push   %ebp
  802123:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802125:	6a 00                	push   $0x0
  802127:	6a 00                	push   $0x0
  802129:	6a 00                	push   $0x0
  80212b:	6a 00                	push   $0x0
  80212d:	6a 00                	push   $0x0
  80212f:	6a 02                	push   $0x2
  802131:	e8 39 fc ff ff       	call   801d6f <syscall>
  802136:	83 c4 18             	add    $0x18,%esp
}
  802139:	c9                   	leave  
  80213a:	c3                   	ret    

0080213b <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80213b:	55                   	push   %ebp
  80213c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80213e:	6a 00                	push   $0x0
  802140:	6a 00                	push   $0x0
  802142:	6a 00                	push   $0x0
  802144:	6a 00                	push   $0x0
  802146:	6a 00                	push   $0x0
  802148:	6a 03                	push   $0x3
  80214a:	e8 20 fc ff ff       	call   801d6f <syscall>
  80214f:	83 c4 18             	add    $0x18,%esp
}
  802152:	c9                   	leave  
  802153:	c3                   	ret    

00802154 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802154:	55                   	push   %ebp
  802155:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802157:	6a 00                	push   $0x0
  802159:	6a 00                	push   $0x0
  80215b:	6a 00                	push   $0x0
  80215d:	6a 00                	push   $0x0
  80215f:	6a 00                	push   $0x0
  802161:	6a 04                	push   $0x4
  802163:	e8 07 fc ff ff       	call   801d6f <syscall>
  802168:	83 c4 18             	add    $0x18,%esp
}
  80216b:	c9                   	leave  
  80216c:	c3                   	ret    

0080216d <sys_exit_env>:


void sys_exit_env(void)
{
  80216d:	55                   	push   %ebp
  80216e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802170:	6a 00                	push   $0x0
  802172:	6a 00                	push   $0x0
  802174:	6a 00                	push   $0x0
  802176:	6a 00                	push   $0x0
  802178:	6a 00                	push   $0x0
  80217a:	6a 23                	push   $0x23
  80217c:	e8 ee fb ff ff       	call   801d6f <syscall>
  802181:	83 c4 18             	add    $0x18,%esp
}
  802184:	90                   	nop
  802185:	c9                   	leave  
  802186:	c3                   	ret    

00802187 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802187:	55                   	push   %ebp
  802188:	89 e5                	mov    %esp,%ebp
  80218a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80218d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802190:	8d 50 04             	lea    0x4(%eax),%edx
  802193:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802196:	6a 00                	push   $0x0
  802198:	6a 00                	push   $0x0
  80219a:	6a 00                	push   $0x0
  80219c:	52                   	push   %edx
  80219d:	50                   	push   %eax
  80219e:	6a 24                	push   $0x24
  8021a0:	e8 ca fb ff ff       	call   801d6f <syscall>
  8021a5:	83 c4 18             	add    $0x18,%esp
	return result;
  8021a8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8021ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021ae:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8021b1:	89 01                	mov    %eax,(%ecx)
  8021b3:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8021b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b9:	c9                   	leave  
  8021ba:	c2 04 00             	ret    $0x4

008021bd <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8021bd:	55                   	push   %ebp
  8021be:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8021c0:	6a 00                	push   $0x0
  8021c2:	6a 00                	push   $0x0
  8021c4:	ff 75 10             	pushl  0x10(%ebp)
  8021c7:	ff 75 0c             	pushl  0xc(%ebp)
  8021ca:	ff 75 08             	pushl  0x8(%ebp)
  8021cd:	6a 12                	push   $0x12
  8021cf:	e8 9b fb ff ff       	call   801d6f <syscall>
  8021d4:	83 c4 18             	add    $0x18,%esp
	return ;
  8021d7:	90                   	nop
}
  8021d8:	c9                   	leave  
  8021d9:	c3                   	ret    

008021da <sys_rcr2>:
uint32 sys_rcr2()
{
  8021da:	55                   	push   %ebp
  8021db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8021dd:	6a 00                	push   $0x0
  8021df:	6a 00                	push   $0x0
  8021e1:	6a 00                	push   $0x0
  8021e3:	6a 00                	push   $0x0
  8021e5:	6a 00                	push   $0x0
  8021e7:	6a 25                	push   $0x25
  8021e9:	e8 81 fb ff ff       	call   801d6f <syscall>
  8021ee:	83 c4 18             	add    $0x18,%esp
}
  8021f1:	c9                   	leave  
  8021f2:	c3                   	ret    

008021f3 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8021f3:	55                   	push   %ebp
  8021f4:	89 e5                	mov    %esp,%ebp
  8021f6:	83 ec 04             	sub    $0x4,%esp
  8021f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8021ff:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802203:	6a 00                	push   $0x0
  802205:	6a 00                	push   $0x0
  802207:	6a 00                	push   $0x0
  802209:	6a 00                	push   $0x0
  80220b:	50                   	push   %eax
  80220c:	6a 26                	push   $0x26
  80220e:	e8 5c fb ff ff       	call   801d6f <syscall>
  802213:	83 c4 18             	add    $0x18,%esp
	return ;
  802216:	90                   	nop
}
  802217:	c9                   	leave  
  802218:	c3                   	ret    

00802219 <rsttst>:
void rsttst()
{
  802219:	55                   	push   %ebp
  80221a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80221c:	6a 00                	push   $0x0
  80221e:	6a 00                	push   $0x0
  802220:	6a 00                	push   $0x0
  802222:	6a 00                	push   $0x0
  802224:	6a 00                	push   $0x0
  802226:	6a 28                	push   $0x28
  802228:	e8 42 fb ff ff       	call   801d6f <syscall>
  80222d:	83 c4 18             	add    $0x18,%esp
	return ;
  802230:	90                   	nop
}
  802231:	c9                   	leave  
  802232:	c3                   	ret    

00802233 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802233:	55                   	push   %ebp
  802234:	89 e5                	mov    %esp,%ebp
  802236:	83 ec 04             	sub    $0x4,%esp
  802239:	8b 45 14             	mov    0x14(%ebp),%eax
  80223c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80223f:	8b 55 18             	mov    0x18(%ebp),%edx
  802242:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802246:	52                   	push   %edx
  802247:	50                   	push   %eax
  802248:	ff 75 10             	pushl  0x10(%ebp)
  80224b:	ff 75 0c             	pushl  0xc(%ebp)
  80224e:	ff 75 08             	pushl  0x8(%ebp)
  802251:	6a 27                	push   $0x27
  802253:	e8 17 fb ff ff       	call   801d6f <syscall>
  802258:	83 c4 18             	add    $0x18,%esp
	return ;
  80225b:	90                   	nop
}
  80225c:	c9                   	leave  
  80225d:	c3                   	ret    

0080225e <chktst>:
void chktst(uint32 n)
{
  80225e:	55                   	push   %ebp
  80225f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802261:	6a 00                	push   $0x0
  802263:	6a 00                	push   $0x0
  802265:	6a 00                	push   $0x0
  802267:	6a 00                	push   $0x0
  802269:	ff 75 08             	pushl  0x8(%ebp)
  80226c:	6a 29                	push   $0x29
  80226e:	e8 fc fa ff ff       	call   801d6f <syscall>
  802273:	83 c4 18             	add    $0x18,%esp
	return ;
  802276:	90                   	nop
}
  802277:	c9                   	leave  
  802278:	c3                   	ret    

00802279 <inctst>:

void inctst()
{
  802279:	55                   	push   %ebp
  80227a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80227c:	6a 00                	push   $0x0
  80227e:	6a 00                	push   $0x0
  802280:	6a 00                	push   $0x0
  802282:	6a 00                	push   $0x0
  802284:	6a 00                	push   $0x0
  802286:	6a 2a                	push   $0x2a
  802288:	e8 e2 fa ff ff       	call   801d6f <syscall>
  80228d:	83 c4 18             	add    $0x18,%esp
	return ;
  802290:	90                   	nop
}
  802291:	c9                   	leave  
  802292:	c3                   	ret    

00802293 <gettst>:
uint32 gettst()
{
  802293:	55                   	push   %ebp
  802294:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802296:	6a 00                	push   $0x0
  802298:	6a 00                	push   $0x0
  80229a:	6a 00                	push   $0x0
  80229c:	6a 00                	push   $0x0
  80229e:	6a 00                	push   $0x0
  8022a0:	6a 2b                	push   $0x2b
  8022a2:	e8 c8 fa ff ff       	call   801d6f <syscall>
  8022a7:	83 c4 18             	add    $0x18,%esp
}
  8022aa:	c9                   	leave  
  8022ab:	c3                   	ret    

008022ac <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8022ac:	55                   	push   %ebp
  8022ad:	89 e5                	mov    %esp,%ebp
  8022af:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8022b2:	6a 00                	push   $0x0
  8022b4:	6a 00                	push   $0x0
  8022b6:	6a 00                	push   $0x0
  8022b8:	6a 00                	push   $0x0
  8022ba:	6a 00                	push   $0x0
  8022bc:	6a 2c                	push   $0x2c
  8022be:	e8 ac fa ff ff       	call   801d6f <syscall>
  8022c3:	83 c4 18             	add    $0x18,%esp
  8022c6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8022c9:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8022cd:	75 07                	jne    8022d6 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8022cf:	b8 01 00 00 00       	mov    $0x1,%eax
  8022d4:	eb 05                	jmp    8022db <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8022d6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022db:	c9                   	leave  
  8022dc:	c3                   	ret    

008022dd <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8022dd:	55                   	push   %ebp
  8022de:	89 e5                	mov    %esp,%ebp
  8022e0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8022e3:	6a 00                	push   $0x0
  8022e5:	6a 00                	push   $0x0
  8022e7:	6a 00                	push   $0x0
  8022e9:	6a 00                	push   $0x0
  8022eb:	6a 00                	push   $0x0
  8022ed:	6a 2c                	push   $0x2c
  8022ef:	e8 7b fa ff ff       	call   801d6f <syscall>
  8022f4:	83 c4 18             	add    $0x18,%esp
  8022f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8022fa:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8022fe:	75 07                	jne    802307 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802300:	b8 01 00 00 00       	mov    $0x1,%eax
  802305:	eb 05                	jmp    80230c <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802307:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80230c:	c9                   	leave  
  80230d:	c3                   	ret    

0080230e <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80230e:	55                   	push   %ebp
  80230f:	89 e5                	mov    %esp,%ebp
  802311:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802314:	6a 00                	push   $0x0
  802316:	6a 00                	push   $0x0
  802318:	6a 00                	push   $0x0
  80231a:	6a 00                	push   $0x0
  80231c:	6a 00                	push   $0x0
  80231e:	6a 2c                	push   $0x2c
  802320:	e8 4a fa ff ff       	call   801d6f <syscall>
  802325:	83 c4 18             	add    $0x18,%esp
  802328:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80232b:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80232f:	75 07                	jne    802338 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802331:	b8 01 00 00 00       	mov    $0x1,%eax
  802336:	eb 05                	jmp    80233d <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802338:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80233d:	c9                   	leave  
  80233e:	c3                   	ret    

0080233f <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80233f:	55                   	push   %ebp
  802340:	89 e5                	mov    %esp,%ebp
  802342:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802345:	6a 00                	push   $0x0
  802347:	6a 00                	push   $0x0
  802349:	6a 00                	push   $0x0
  80234b:	6a 00                	push   $0x0
  80234d:	6a 00                	push   $0x0
  80234f:	6a 2c                	push   $0x2c
  802351:	e8 19 fa ff ff       	call   801d6f <syscall>
  802356:	83 c4 18             	add    $0x18,%esp
  802359:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80235c:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802360:	75 07                	jne    802369 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802362:	b8 01 00 00 00       	mov    $0x1,%eax
  802367:	eb 05                	jmp    80236e <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802369:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80236e:	c9                   	leave  
  80236f:	c3                   	ret    

00802370 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802370:	55                   	push   %ebp
  802371:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802373:	6a 00                	push   $0x0
  802375:	6a 00                	push   $0x0
  802377:	6a 00                	push   $0x0
  802379:	6a 00                	push   $0x0
  80237b:	ff 75 08             	pushl  0x8(%ebp)
  80237e:	6a 2d                	push   $0x2d
  802380:	e8 ea f9 ff ff       	call   801d6f <syscall>
  802385:	83 c4 18             	add    $0x18,%esp
	return ;
  802388:	90                   	nop
}
  802389:	c9                   	leave  
  80238a:	c3                   	ret    

0080238b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80238b:	55                   	push   %ebp
  80238c:	89 e5                	mov    %esp,%ebp
  80238e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80238f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802392:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802395:	8b 55 0c             	mov    0xc(%ebp),%edx
  802398:	8b 45 08             	mov    0x8(%ebp),%eax
  80239b:	6a 00                	push   $0x0
  80239d:	53                   	push   %ebx
  80239e:	51                   	push   %ecx
  80239f:	52                   	push   %edx
  8023a0:	50                   	push   %eax
  8023a1:	6a 2e                	push   $0x2e
  8023a3:	e8 c7 f9 ff ff       	call   801d6f <syscall>
  8023a8:	83 c4 18             	add    $0x18,%esp
}
  8023ab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023ae:	c9                   	leave  
  8023af:	c3                   	ret    

008023b0 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8023b0:	55                   	push   %ebp
  8023b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8023b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b9:	6a 00                	push   $0x0
  8023bb:	6a 00                	push   $0x0
  8023bd:	6a 00                	push   $0x0
  8023bf:	52                   	push   %edx
  8023c0:	50                   	push   %eax
  8023c1:	6a 2f                	push   $0x2f
  8023c3:	e8 a7 f9 ff ff       	call   801d6f <syscall>
  8023c8:	83 c4 18             	add    $0x18,%esp
}
  8023cb:	c9                   	leave  
  8023cc:	c3                   	ret    

008023cd <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8023cd:	55                   	push   %ebp
  8023ce:	89 e5                	mov    %esp,%ebp
  8023d0:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8023d3:	83 ec 0c             	sub    $0xc,%esp
  8023d6:	68 64 45 80 00       	push   $0x804564
  8023db:	e8 65 e6 ff ff       	call   800a45 <cprintf>
  8023e0:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8023e3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8023ea:	83 ec 0c             	sub    $0xc,%esp
  8023ed:	68 90 45 80 00       	push   $0x804590
  8023f2:	e8 4e e6 ff ff       	call   800a45 <cprintf>
  8023f7:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8023fa:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8023fe:	a1 38 51 80 00       	mov    0x805138,%eax
  802403:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802406:	eb 56                	jmp    80245e <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802408:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80240c:	74 1c                	je     80242a <print_mem_block_lists+0x5d>
  80240e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802411:	8b 50 08             	mov    0x8(%eax),%edx
  802414:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802417:	8b 48 08             	mov    0x8(%eax),%ecx
  80241a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80241d:	8b 40 0c             	mov    0xc(%eax),%eax
  802420:	01 c8                	add    %ecx,%eax
  802422:	39 c2                	cmp    %eax,%edx
  802424:	73 04                	jae    80242a <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802426:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80242a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242d:	8b 50 08             	mov    0x8(%eax),%edx
  802430:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802433:	8b 40 0c             	mov    0xc(%eax),%eax
  802436:	01 c2                	add    %eax,%edx
  802438:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243b:	8b 40 08             	mov    0x8(%eax),%eax
  80243e:	83 ec 04             	sub    $0x4,%esp
  802441:	52                   	push   %edx
  802442:	50                   	push   %eax
  802443:	68 a5 45 80 00       	push   $0x8045a5
  802448:	e8 f8 e5 ff ff       	call   800a45 <cprintf>
  80244d:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802450:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802453:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802456:	a1 40 51 80 00       	mov    0x805140,%eax
  80245b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80245e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802462:	74 07                	je     80246b <print_mem_block_lists+0x9e>
  802464:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802467:	8b 00                	mov    (%eax),%eax
  802469:	eb 05                	jmp    802470 <print_mem_block_lists+0xa3>
  80246b:	b8 00 00 00 00       	mov    $0x0,%eax
  802470:	a3 40 51 80 00       	mov    %eax,0x805140
  802475:	a1 40 51 80 00       	mov    0x805140,%eax
  80247a:	85 c0                	test   %eax,%eax
  80247c:	75 8a                	jne    802408 <print_mem_block_lists+0x3b>
  80247e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802482:	75 84                	jne    802408 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802484:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802488:	75 10                	jne    80249a <print_mem_block_lists+0xcd>
  80248a:	83 ec 0c             	sub    $0xc,%esp
  80248d:	68 b4 45 80 00       	push   $0x8045b4
  802492:	e8 ae e5 ff ff       	call   800a45 <cprintf>
  802497:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80249a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8024a1:	83 ec 0c             	sub    $0xc,%esp
  8024a4:	68 d8 45 80 00       	push   $0x8045d8
  8024a9:	e8 97 e5 ff ff       	call   800a45 <cprintf>
  8024ae:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8024b1:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8024b5:	a1 40 50 80 00       	mov    0x805040,%eax
  8024ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024bd:	eb 56                	jmp    802515 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8024bf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024c3:	74 1c                	je     8024e1 <print_mem_block_lists+0x114>
  8024c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c8:	8b 50 08             	mov    0x8(%eax),%edx
  8024cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024ce:	8b 48 08             	mov    0x8(%eax),%ecx
  8024d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024d4:	8b 40 0c             	mov    0xc(%eax),%eax
  8024d7:	01 c8                	add    %ecx,%eax
  8024d9:	39 c2                	cmp    %eax,%edx
  8024db:	73 04                	jae    8024e1 <print_mem_block_lists+0x114>
			sorted = 0 ;
  8024dd:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8024e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e4:	8b 50 08             	mov    0x8(%eax),%edx
  8024e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ea:	8b 40 0c             	mov    0xc(%eax),%eax
  8024ed:	01 c2                	add    %eax,%edx
  8024ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f2:	8b 40 08             	mov    0x8(%eax),%eax
  8024f5:	83 ec 04             	sub    $0x4,%esp
  8024f8:	52                   	push   %edx
  8024f9:	50                   	push   %eax
  8024fa:	68 a5 45 80 00       	push   $0x8045a5
  8024ff:	e8 41 e5 ff ff       	call   800a45 <cprintf>
  802504:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802507:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80250d:	a1 48 50 80 00       	mov    0x805048,%eax
  802512:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802515:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802519:	74 07                	je     802522 <print_mem_block_lists+0x155>
  80251b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251e:	8b 00                	mov    (%eax),%eax
  802520:	eb 05                	jmp    802527 <print_mem_block_lists+0x15a>
  802522:	b8 00 00 00 00       	mov    $0x0,%eax
  802527:	a3 48 50 80 00       	mov    %eax,0x805048
  80252c:	a1 48 50 80 00       	mov    0x805048,%eax
  802531:	85 c0                	test   %eax,%eax
  802533:	75 8a                	jne    8024bf <print_mem_block_lists+0xf2>
  802535:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802539:	75 84                	jne    8024bf <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80253b:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80253f:	75 10                	jne    802551 <print_mem_block_lists+0x184>
  802541:	83 ec 0c             	sub    $0xc,%esp
  802544:	68 f0 45 80 00       	push   $0x8045f0
  802549:	e8 f7 e4 ff ff       	call   800a45 <cprintf>
  80254e:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802551:	83 ec 0c             	sub    $0xc,%esp
  802554:	68 64 45 80 00       	push   $0x804564
  802559:	e8 e7 e4 ff ff       	call   800a45 <cprintf>
  80255e:	83 c4 10             	add    $0x10,%esp

}
  802561:	90                   	nop
  802562:	c9                   	leave  
  802563:	c3                   	ret    

00802564 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802564:	55                   	push   %ebp
  802565:	89 e5                	mov    %esp,%ebp
  802567:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  80256a:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802571:	00 00 00 
  802574:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80257b:	00 00 00 
  80257e:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802585:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  802588:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80258f:	e9 9e 00 00 00       	jmp    802632 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802594:	a1 50 50 80 00       	mov    0x805050,%eax
  802599:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80259c:	c1 e2 04             	shl    $0x4,%edx
  80259f:	01 d0                	add    %edx,%eax
  8025a1:	85 c0                	test   %eax,%eax
  8025a3:	75 14                	jne    8025b9 <initialize_MemBlocksList+0x55>
  8025a5:	83 ec 04             	sub    $0x4,%esp
  8025a8:	68 18 46 80 00       	push   $0x804618
  8025ad:	6a 46                	push   $0x46
  8025af:	68 3b 46 80 00       	push   $0x80463b
  8025b4:	e8 d8 e1 ff ff       	call   800791 <_panic>
  8025b9:	a1 50 50 80 00       	mov    0x805050,%eax
  8025be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025c1:	c1 e2 04             	shl    $0x4,%edx
  8025c4:	01 d0                	add    %edx,%eax
  8025c6:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8025cc:	89 10                	mov    %edx,(%eax)
  8025ce:	8b 00                	mov    (%eax),%eax
  8025d0:	85 c0                	test   %eax,%eax
  8025d2:	74 18                	je     8025ec <initialize_MemBlocksList+0x88>
  8025d4:	a1 48 51 80 00       	mov    0x805148,%eax
  8025d9:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8025df:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8025e2:	c1 e1 04             	shl    $0x4,%ecx
  8025e5:	01 ca                	add    %ecx,%edx
  8025e7:	89 50 04             	mov    %edx,0x4(%eax)
  8025ea:	eb 12                	jmp    8025fe <initialize_MemBlocksList+0x9a>
  8025ec:	a1 50 50 80 00       	mov    0x805050,%eax
  8025f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025f4:	c1 e2 04             	shl    $0x4,%edx
  8025f7:	01 d0                	add    %edx,%eax
  8025f9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8025fe:	a1 50 50 80 00       	mov    0x805050,%eax
  802603:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802606:	c1 e2 04             	shl    $0x4,%edx
  802609:	01 d0                	add    %edx,%eax
  80260b:	a3 48 51 80 00       	mov    %eax,0x805148
  802610:	a1 50 50 80 00       	mov    0x805050,%eax
  802615:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802618:	c1 e2 04             	shl    $0x4,%edx
  80261b:	01 d0                	add    %edx,%eax
  80261d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802624:	a1 54 51 80 00       	mov    0x805154,%eax
  802629:	40                   	inc    %eax
  80262a:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  80262f:	ff 45 f4             	incl   -0xc(%ebp)
  802632:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802635:	3b 45 08             	cmp    0x8(%ebp),%eax
  802638:	0f 82 56 ff ff ff    	jb     802594 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  80263e:	90                   	nop
  80263f:	c9                   	leave  
  802640:	c3                   	ret    

00802641 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802641:	55                   	push   %ebp
  802642:	89 e5                	mov    %esp,%ebp
  802644:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802647:	8b 45 08             	mov    0x8(%ebp),%eax
  80264a:	8b 00                	mov    (%eax),%eax
  80264c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80264f:	eb 19                	jmp    80266a <find_block+0x29>
	{
		if(va==point->sva)
  802651:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802654:	8b 40 08             	mov    0x8(%eax),%eax
  802657:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80265a:	75 05                	jne    802661 <find_block+0x20>
		   return point;
  80265c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80265f:	eb 36                	jmp    802697 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802661:	8b 45 08             	mov    0x8(%ebp),%eax
  802664:	8b 40 08             	mov    0x8(%eax),%eax
  802667:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80266a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80266e:	74 07                	je     802677 <find_block+0x36>
  802670:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802673:	8b 00                	mov    (%eax),%eax
  802675:	eb 05                	jmp    80267c <find_block+0x3b>
  802677:	b8 00 00 00 00       	mov    $0x0,%eax
  80267c:	8b 55 08             	mov    0x8(%ebp),%edx
  80267f:	89 42 08             	mov    %eax,0x8(%edx)
  802682:	8b 45 08             	mov    0x8(%ebp),%eax
  802685:	8b 40 08             	mov    0x8(%eax),%eax
  802688:	85 c0                	test   %eax,%eax
  80268a:	75 c5                	jne    802651 <find_block+0x10>
  80268c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802690:	75 bf                	jne    802651 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802692:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802697:	c9                   	leave  
  802698:	c3                   	ret    

00802699 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802699:	55                   	push   %ebp
  80269a:	89 e5                	mov    %esp,%ebp
  80269c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  80269f:	a1 40 50 80 00       	mov    0x805040,%eax
  8026a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  8026a7:	a1 44 50 80 00       	mov    0x805044,%eax
  8026ac:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8026af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026b2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8026b5:	74 24                	je     8026db <insert_sorted_allocList+0x42>
  8026b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ba:	8b 50 08             	mov    0x8(%eax),%edx
  8026bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026c0:	8b 40 08             	mov    0x8(%eax),%eax
  8026c3:	39 c2                	cmp    %eax,%edx
  8026c5:	76 14                	jbe    8026db <insert_sorted_allocList+0x42>
  8026c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ca:	8b 50 08             	mov    0x8(%eax),%edx
  8026cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026d0:	8b 40 08             	mov    0x8(%eax),%eax
  8026d3:	39 c2                	cmp    %eax,%edx
  8026d5:	0f 82 60 01 00 00    	jb     80283b <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8026db:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026df:	75 65                	jne    802746 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8026e1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8026e5:	75 14                	jne    8026fb <insert_sorted_allocList+0x62>
  8026e7:	83 ec 04             	sub    $0x4,%esp
  8026ea:	68 18 46 80 00       	push   $0x804618
  8026ef:	6a 6b                	push   $0x6b
  8026f1:	68 3b 46 80 00       	push   $0x80463b
  8026f6:	e8 96 e0 ff ff       	call   800791 <_panic>
  8026fb:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802701:	8b 45 08             	mov    0x8(%ebp),%eax
  802704:	89 10                	mov    %edx,(%eax)
  802706:	8b 45 08             	mov    0x8(%ebp),%eax
  802709:	8b 00                	mov    (%eax),%eax
  80270b:	85 c0                	test   %eax,%eax
  80270d:	74 0d                	je     80271c <insert_sorted_allocList+0x83>
  80270f:	a1 40 50 80 00       	mov    0x805040,%eax
  802714:	8b 55 08             	mov    0x8(%ebp),%edx
  802717:	89 50 04             	mov    %edx,0x4(%eax)
  80271a:	eb 08                	jmp    802724 <insert_sorted_allocList+0x8b>
  80271c:	8b 45 08             	mov    0x8(%ebp),%eax
  80271f:	a3 44 50 80 00       	mov    %eax,0x805044
  802724:	8b 45 08             	mov    0x8(%ebp),%eax
  802727:	a3 40 50 80 00       	mov    %eax,0x805040
  80272c:	8b 45 08             	mov    0x8(%ebp),%eax
  80272f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802736:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80273b:	40                   	inc    %eax
  80273c:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802741:	e9 dc 01 00 00       	jmp    802922 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802746:	8b 45 08             	mov    0x8(%ebp),%eax
  802749:	8b 50 08             	mov    0x8(%eax),%edx
  80274c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80274f:	8b 40 08             	mov    0x8(%eax),%eax
  802752:	39 c2                	cmp    %eax,%edx
  802754:	77 6c                	ja     8027c2 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802756:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80275a:	74 06                	je     802762 <insert_sorted_allocList+0xc9>
  80275c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802760:	75 14                	jne    802776 <insert_sorted_allocList+0xdd>
  802762:	83 ec 04             	sub    $0x4,%esp
  802765:	68 54 46 80 00       	push   $0x804654
  80276a:	6a 6f                	push   $0x6f
  80276c:	68 3b 46 80 00       	push   $0x80463b
  802771:	e8 1b e0 ff ff       	call   800791 <_panic>
  802776:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802779:	8b 50 04             	mov    0x4(%eax),%edx
  80277c:	8b 45 08             	mov    0x8(%ebp),%eax
  80277f:	89 50 04             	mov    %edx,0x4(%eax)
  802782:	8b 45 08             	mov    0x8(%ebp),%eax
  802785:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802788:	89 10                	mov    %edx,(%eax)
  80278a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80278d:	8b 40 04             	mov    0x4(%eax),%eax
  802790:	85 c0                	test   %eax,%eax
  802792:	74 0d                	je     8027a1 <insert_sorted_allocList+0x108>
  802794:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802797:	8b 40 04             	mov    0x4(%eax),%eax
  80279a:	8b 55 08             	mov    0x8(%ebp),%edx
  80279d:	89 10                	mov    %edx,(%eax)
  80279f:	eb 08                	jmp    8027a9 <insert_sorted_allocList+0x110>
  8027a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a4:	a3 40 50 80 00       	mov    %eax,0x805040
  8027a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ac:	8b 55 08             	mov    0x8(%ebp),%edx
  8027af:	89 50 04             	mov    %edx,0x4(%eax)
  8027b2:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8027b7:	40                   	inc    %eax
  8027b8:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8027bd:	e9 60 01 00 00       	jmp    802922 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8027c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c5:	8b 50 08             	mov    0x8(%eax),%edx
  8027c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027cb:	8b 40 08             	mov    0x8(%eax),%eax
  8027ce:	39 c2                	cmp    %eax,%edx
  8027d0:	0f 82 4c 01 00 00    	jb     802922 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8027d6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8027da:	75 14                	jne    8027f0 <insert_sorted_allocList+0x157>
  8027dc:	83 ec 04             	sub    $0x4,%esp
  8027df:	68 8c 46 80 00       	push   $0x80468c
  8027e4:	6a 73                	push   $0x73
  8027e6:	68 3b 46 80 00       	push   $0x80463b
  8027eb:	e8 a1 df ff ff       	call   800791 <_panic>
  8027f0:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8027f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f9:	89 50 04             	mov    %edx,0x4(%eax)
  8027fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ff:	8b 40 04             	mov    0x4(%eax),%eax
  802802:	85 c0                	test   %eax,%eax
  802804:	74 0c                	je     802812 <insert_sorted_allocList+0x179>
  802806:	a1 44 50 80 00       	mov    0x805044,%eax
  80280b:	8b 55 08             	mov    0x8(%ebp),%edx
  80280e:	89 10                	mov    %edx,(%eax)
  802810:	eb 08                	jmp    80281a <insert_sorted_allocList+0x181>
  802812:	8b 45 08             	mov    0x8(%ebp),%eax
  802815:	a3 40 50 80 00       	mov    %eax,0x805040
  80281a:	8b 45 08             	mov    0x8(%ebp),%eax
  80281d:	a3 44 50 80 00       	mov    %eax,0x805044
  802822:	8b 45 08             	mov    0x8(%ebp),%eax
  802825:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80282b:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802830:	40                   	inc    %eax
  802831:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802836:	e9 e7 00 00 00       	jmp    802922 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  80283b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80283e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802841:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802848:	a1 40 50 80 00       	mov    0x805040,%eax
  80284d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802850:	e9 9d 00 00 00       	jmp    8028f2 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802855:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802858:	8b 00                	mov    (%eax),%eax
  80285a:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  80285d:	8b 45 08             	mov    0x8(%ebp),%eax
  802860:	8b 50 08             	mov    0x8(%eax),%edx
  802863:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802866:	8b 40 08             	mov    0x8(%eax),%eax
  802869:	39 c2                	cmp    %eax,%edx
  80286b:	76 7d                	jbe    8028ea <insert_sorted_allocList+0x251>
  80286d:	8b 45 08             	mov    0x8(%ebp),%eax
  802870:	8b 50 08             	mov    0x8(%eax),%edx
  802873:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802876:	8b 40 08             	mov    0x8(%eax),%eax
  802879:	39 c2                	cmp    %eax,%edx
  80287b:	73 6d                	jae    8028ea <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  80287d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802881:	74 06                	je     802889 <insert_sorted_allocList+0x1f0>
  802883:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802887:	75 14                	jne    80289d <insert_sorted_allocList+0x204>
  802889:	83 ec 04             	sub    $0x4,%esp
  80288c:	68 b0 46 80 00       	push   $0x8046b0
  802891:	6a 7f                	push   $0x7f
  802893:	68 3b 46 80 00       	push   $0x80463b
  802898:	e8 f4 de ff ff       	call   800791 <_panic>
  80289d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a0:	8b 10                	mov    (%eax),%edx
  8028a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a5:	89 10                	mov    %edx,(%eax)
  8028a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8028aa:	8b 00                	mov    (%eax),%eax
  8028ac:	85 c0                	test   %eax,%eax
  8028ae:	74 0b                	je     8028bb <insert_sorted_allocList+0x222>
  8028b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b3:	8b 00                	mov    (%eax),%eax
  8028b5:	8b 55 08             	mov    0x8(%ebp),%edx
  8028b8:	89 50 04             	mov    %edx,0x4(%eax)
  8028bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028be:	8b 55 08             	mov    0x8(%ebp),%edx
  8028c1:	89 10                	mov    %edx,(%eax)
  8028c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028c9:	89 50 04             	mov    %edx,0x4(%eax)
  8028cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8028cf:	8b 00                	mov    (%eax),%eax
  8028d1:	85 c0                	test   %eax,%eax
  8028d3:	75 08                	jne    8028dd <insert_sorted_allocList+0x244>
  8028d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d8:	a3 44 50 80 00       	mov    %eax,0x805044
  8028dd:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8028e2:	40                   	inc    %eax
  8028e3:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8028e8:	eb 39                	jmp    802923 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8028ea:	a1 48 50 80 00       	mov    0x805048,%eax
  8028ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028f6:	74 07                	je     8028ff <insert_sorted_allocList+0x266>
  8028f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fb:	8b 00                	mov    (%eax),%eax
  8028fd:	eb 05                	jmp    802904 <insert_sorted_allocList+0x26b>
  8028ff:	b8 00 00 00 00       	mov    $0x0,%eax
  802904:	a3 48 50 80 00       	mov    %eax,0x805048
  802909:	a1 48 50 80 00       	mov    0x805048,%eax
  80290e:	85 c0                	test   %eax,%eax
  802910:	0f 85 3f ff ff ff    	jne    802855 <insert_sorted_allocList+0x1bc>
  802916:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80291a:	0f 85 35 ff ff ff    	jne    802855 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802920:	eb 01                	jmp    802923 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802922:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802923:	90                   	nop
  802924:	c9                   	leave  
  802925:	c3                   	ret    

00802926 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802926:	55                   	push   %ebp
  802927:	89 e5                	mov    %esp,%ebp
  802929:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80292c:	a1 38 51 80 00       	mov    0x805138,%eax
  802931:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802934:	e9 85 01 00 00       	jmp    802abe <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802939:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293c:	8b 40 0c             	mov    0xc(%eax),%eax
  80293f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802942:	0f 82 6e 01 00 00    	jb     802ab6 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802948:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294b:	8b 40 0c             	mov    0xc(%eax),%eax
  80294e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802951:	0f 85 8a 00 00 00    	jne    8029e1 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802957:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80295b:	75 17                	jne    802974 <alloc_block_FF+0x4e>
  80295d:	83 ec 04             	sub    $0x4,%esp
  802960:	68 e4 46 80 00       	push   $0x8046e4
  802965:	68 93 00 00 00       	push   $0x93
  80296a:	68 3b 46 80 00       	push   $0x80463b
  80296f:	e8 1d de ff ff       	call   800791 <_panic>
  802974:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802977:	8b 00                	mov    (%eax),%eax
  802979:	85 c0                	test   %eax,%eax
  80297b:	74 10                	je     80298d <alloc_block_FF+0x67>
  80297d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802980:	8b 00                	mov    (%eax),%eax
  802982:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802985:	8b 52 04             	mov    0x4(%edx),%edx
  802988:	89 50 04             	mov    %edx,0x4(%eax)
  80298b:	eb 0b                	jmp    802998 <alloc_block_FF+0x72>
  80298d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802990:	8b 40 04             	mov    0x4(%eax),%eax
  802993:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802998:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299b:	8b 40 04             	mov    0x4(%eax),%eax
  80299e:	85 c0                	test   %eax,%eax
  8029a0:	74 0f                	je     8029b1 <alloc_block_FF+0x8b>
  8029a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a5:	8b 40 04             	mov    0x4(%eax),%eax
  8029a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029ab:	8b 12                	mov    (%edx),%edx
  8029ad:	89 10                	mov    %edx,(%eax)
  8029af:	eb 0a                	jmp    8029bb <alloc_block_FF+0x95>
  8029b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b4:	8b 00                	mov    (%eax),%eax
  8029b6:	a3 38 51 80 00       	mov    %eax,0x805138
  8029bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029be:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029ce:	a1 44 51 80 00       	mov    0x805144,%eax
  8029d3:	48                   	dec    %eax
  8029d4:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  8029d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029dc:	e9 10 01 00 00       	jmp    802af1 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8029e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e4:	8b 40 0c             	mov    0xc(%eax),%eax
  8029e7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029ea:	0f 86 c6 00 00 00    	jbe    802ab6 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8029f0:	a1 48 51 80 00       	mov    0x805148,%eax
  8029f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8029f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fb:	8b 50 08             	mov    0x8(%eax),%edx
  8029fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a01:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802a04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a07:	8b 55 08             	mov    0x8(%ebp),%edx
  802a0a:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802a0d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a11:	75 17                	jne    802a2a <alloc_block_FF+0x104>
  802a13:	83 ec 04             	sub    $0x4,%esp
  802a16:	68 e4 46 80 00       	push   $0x8046e4
  802a1b:	68 9b 00 00 00       	push   $0x9b
  802a20:	68 3b 46 80 00       	push   $0x80463b
  802a25:	e8 67 dd ff ff       	call   800791 <_panic>
  802a2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a2d:	8b 00                	mov    (%eax),%eax
  802a2f:	85 c0                	test   %eax,%eax
  802a31:	74 10                	je     802a43 <alloc_block_FF+0x11d>
  802a33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a36:	8b 00                	mov    (%eax),%eax
  802a38:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a3b:	8b 52 04             	mov    0x4(%edx),%edx
  802a3e:	89 50 04             	mov    %edx,0x4(%eax)
  802a41:	eb 0b                	jmp    802a4e <alloc_block_FF+0x128>
  802a43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a46:	8b 40 04             	mov    0x4(%eax),%eax
  802a49:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a51:	8b 40 04             	mov    0x4(%eax),%eax
  802a54:	85 c0                	test   %eax,%eax
  802a56:	74 0f                	je     802a67 <alloc_block_FF+0x141>
  802a58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a5b:	8b 40 04             	mov    0x4(%eax),%eax
  802a5e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a61:	8b 12                	mov    (%edx),%edx
  802a63:	89 10                	mov    %edx,(%eax)
  802a65:	eb 0a                	jmp    802a71 <alloc_block_FF+0x14b>
  802a67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a6a:	8b 00                	mov    (%eax),%eax
  802a6c:	a3 48 51 80 00       	mov    %eax,0x805148
  802a71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a74:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a7d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a84:	a1 54 51 80 00       	mov    0x805154,%eax
  802a89:	48                   	dec    %eax
  802a8a:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802a8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a92:	8b 50 08             	mov    0x8(%eax),%edx
  802a95:	8b 45 08             	mov    0x8(%ebp),%eax
  802a98:	01 c2                	add    %eax,%edx
  802a9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9d:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802aa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa3:	8b 40 0c             	mov    0xc(%eax),%eax
  802aa6:	2b 45 08             	sub    0x8(%ebp),%eax
  802aa9:	89 c2                	mov    %eax,%edx
  802aab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aae:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802ab1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ab4:	eb 3b                	jmp    802af1 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802ab6:	a1 40 51 80 00       	mov    0x805140,%eax
  802abb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802abe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ac2:	74 07                	je     802acb <alloc_block_FF+0x1a5>
  802ac4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac7:	8b 00                	mov    (%eax),%eax
  802ac9:	eb 05                	jmp    802ad0 <alloc_block_FF+0x1aa>
  802acb:	b8 00 00 00 00       	mov    $0x0,%eax
  802ad0:	a3 40 51 80 00       	mov    %eax,0x805140
  802ad5:	a1 40 51 80 00       	mov    0x805140,%eax
  802ada:	85 c0                	test   %eax,%eax
  802adc:	0f 85 57 fe ff ff    	jne    802939 <alloc_block_FF+0x13>
  802ae2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ae6:	0f 85 4d fe ff ff    	jne    802939 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802aec:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802af1:	c9                   	leave  
  802af2:	c3                   	ret    

00802af3 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802af3:	55                   	push   %ebp
  802af4:	89 e5                	mov    %esp,%ebp
  802af6:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802af9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802b00:	a1 38 51 80 00       	mov    0x805138,%eax
  802b05:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b08:	e9 df 00 00 00       	jmp    802bec <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802b0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b10:	8b 40 0c             	mov    0xc(%eax),%eax
  802b13:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b16:	0f 82 c8 00 00 00    	jb     802be4 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802b1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1f:	8b 40 0c             	mov    0xc(%eax),%eax
  802b22:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b25:	0f 85 8a 00 00 00    	jne    802bb5 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802b2b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b2f:	75 17                	jne    802b48 <alloc_block_BF+0x55>
  802b31:	83 ec 04             	sub    $0x4,%esp
  802b34:	68 e4 46 80 00       	push   $0x8046e4
  802b39:	68 b7 00 00 00       	push   $0xb7
  802b3e:	68 3b 46 80 00       	push   $0x80463b
  802b43:	e8 49 dc ff ff       	call   800791 <_panic>
  802b48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4b:	8b 00                	mov    (%eax),%eax
  802b4d:	85 c0                	test   %eax,%eax
  802b4f:	74 10                	je     802b61 <alloc_block_BF+0x6e>
  802b51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b54:	8b 00                	mov    (%eax),%eax
  802b56:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b59:	8b 52 04             	mov    0x4(%edx),%edx
  802b5c:	89 50 04             	mov    %edx,0x4(%eax)
  802b5f:	eb 0b                	jmp    802b6c <alloc_block_BF+0x79>
  802b61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b64:	8b 40 04             	mov    0x4(%eax),%eax
  802b67:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6f:	8b 40 04             	mov    0x4(%eax),%eax
  802b72:	85 c0                	test   %eax,%eax
  802b74:	74 0f                	je     802b85 <alloc_block_BF+0x92>
  802b76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b79:	8b 40 04             	mov    0x4(%eax),%eax
  802b7c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b7f:	8b 12                	mov    (%edx),%edx
  802b81:	89 10                	mov    %edx,(%eax)
  802b83:	eb 0a                	jmp    802b8f <alloc_block_BF+0x9c>
  802b85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b88:	8b 00                	mov    (%eax),%eax
  802b8a:	a3 38 51 80 00       	mov    %eax,0x805138
  802b8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b92:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ba2:	a1 44 51 80 00       	mov    0x805144,%eax
  802ba7:	48                   	dec    %eax
  802ba8:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802bad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb0:	e9 4d 01 00 00       	jmp    802d02 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802bb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb8:	8b 40 0c             	mov    0xc(%eax),%eax
  802bbb:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bbe:	76 24                	jbe    802be4 <alloc_block_BF+0xf1>
  802bc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc3:	8b 40 0c             	mov    0xc(%eax),%eax
  802bc6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802bc9:	73 19                	jae    802be4 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802bcb:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802bd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd5:	8b 40 0c             	mov    0xc(%eax),%eax
  802bd8:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802bdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bde:	8b 40 08             	mov    0x8(%eax),%eax
  802be1:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802be4:	a1 40 51 80 00       	mov    0x805140,%eax
  802be9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bf0:	74 07                	je     802bf9 <alloc_block_BF+0x106>
  802bf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf5:	8b 00                	mov    (%eax),%eax
  802bf7:	eb 05                	jmp    802bfe <alloc_block_BF+0x10b>
  802bf9:	b8 00 00 00 00       	mov    $0x0,%eax
  802bfe:	a3 40 51 80 00       	mov    %eax,0x805140
  802c03:	a1 40 51 80 00       	mov    0x805140,%eax
  802c08:	85 c0                	test   %eax,%eax
  802c0a:	0f 85 fd fe ff ff    	jne    802b0d <alloc_block_BF+0x1a>
  802c10:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c14:	0f 85 f3 fe ff ff    	jne    802b0d <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802c1a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802c1e:	0f 84 d9 00 00 00    	je     802cfd <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802c24:	a1 48 51 80 00       	mov    0x805148,%eax
  802c29:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802c2c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c2f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c32:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802c35:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c38:	8b 55 08             	mov    0x8(%ebp),%edx
  802c3b:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802c3e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802c42:	75 17                	jne    802c5b <alloc_block_BF+0x168>
  802c44:	83 ec 04             	sub    $0x4,%esp
  802c47:	68 e4 46 80 00       	push   $0x8046e4
  802c4c:	68 c7 00 00 00       	push   $0xc7
  802c51:	68 3b 46 80 00       	push   $0x80463b
  802c56:	e8 36 db ff ff       	call   800791 <_panic>
  802c5b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c5e:	8b 00                	mov    (%eax),%eax
  802c60:	85 c0                	test   %eax,%eax
  802c62:	74 10                	je     802c74 <alloc_block_BF+0x181>
  802c64:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c67:	8b 00                	mov    (%eax),%eax
  802c69:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c6c:	8b 52 04             	mov    0x4(%edx),%edx
  802c6f:	89 50 04             	mov    %edx,0x4(%eax)
  802c72:	eb 0b                	jmp    802c7f <alloc_block_BF+0x18c>
  802c74:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c77:	8b 40 04             	mov    0x4(%eax),%eax
  802c7a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c7f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c82:	8b 40 04             	mov    0x4(%eax),%eax
  802c85:	85 c0                	test   %eax,%eax
  802c87:	74 0f                	je     802c98 <alloc_block_BF+0x1a5>
  802c89:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c8c:	8b 40 04             	mov    0x4(%eax),%eax
  802c8f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c92:	8b 12                	mov    (%edx),%edx
  802c94:	89 10                	mov    %edx,(%eax)
  802c96:	eb 0a                	jmp    802ca2 <alloc_block_BF+0x1af>
  802c98:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c9b:	8b 00                	mov    (%eax),%eax
  802c9d:	a3 48 51 80 00       	mov    %eax,0x805148
  802ca2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ca5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cb5:	a1 54 51 80 00       	mov    0x805154,%eax
  802cba:	48                   	dec    %eax
  802cbb:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802cc0:	83 ec 08             	sub    $0x8,%esp
  802cc3:	ff 75 ec             	pushl  -0x14(%ebp)
  802cc6:	68 38 51 80 00       	push   $0x805138
  802ccb:	e8 71 f9 ff ff       	call   802641 <find_block>
  802cd0:	83 c4 10             	add    $0x10,%esp
  802cd3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802cd6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cd9:	8b 50 08             	mov    0x8(%eax),%edx
  802cdc:	8b 45 08             	mov    0x8(%ebp),%eax
  802cdf:	01 c2                	add    %eax,%edx
  802ce1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ce4:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802ce7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cea:	8b 40 0c             	mov    0xc(%eax),%eax
  802ced:	2b 45 08             	sub    0x8(%ebp),%eax
  802cf0:	89 c2                	mov    %eax,%edx
  802cf2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cf5:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802cf8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cfb:	eb 05                	jmp    802d02 <alloc_block_BF+0x20f>
	}
	return NULL;
  802cfd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d02:	c9                   	leave  
  802d03:	c3                   	ret    

00802d04 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802d04:	55                   	push   %ebp
  802d05:	89 e5                	mov    %esp,%ebp
  802d07:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802d0a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802d0f:	85 c0                	test   %eax,%eax
  802d11:	0f 85 de 01 00 00    	jne    802ef5 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802d17:	a1 38 51 80 00       	mov    0x805138,%eax
  802d1c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d1f:	e9 9e 01 00 00       	jmp    802ec2 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802d24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d27:	8b 40 0c             	mov    0xc(%eax),%eax
  802d2a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d2d:	0f 82 87 01 00 00    	jb     802eba <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802d33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d36:	8b 40 0c             	mov    0xc(%eax),%eax
  802d39:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d3c:	0f 85 95 00 00 00    	jne    802dd7 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802d42:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d46:	75 17                	jne    802d5f <alloc_block_NF+0x5b>
  802d48:	83 ec 04             	sub    $0x4,%esp
  802d4b:	68 e4 46 80 00       	push   $0x8046e4
  802d50:	68 e0 00 00 00       	push   $0xe0
  802d55:	68 3b 46 80 00       	push   $0x80463b
  802d5a:	e8 32 da ff ff       	call   800791 <_panic>
  802d5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d62:	8b 00                	mov    (%eax),%eax
  802d64:	85 c0                	test   %eax,%eax
  802d66:	74 10                	je     802d78 <alloc_block_NF+0x74>
  802d68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6b:	8b 00                	mov    (%eax),%eax
  802d6d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d70:	8b 52 04             	mov    0x4(%edx),%edx
  802d73:	89 50 04             	mov    %edx,0x4(%eax)
  802d76:	eb 0b                	jmp    802d83 <alloc_block_NF+0x7f>
  802d78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7b:	8b 40 04             	mov    0x4(%eax),%eax
  802d7e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d86:	8b 40 04             	mov    0x4(%eax),%eax
  802d89:	85 c0                	test   %eax,%eax
  802d8b:	74 0f                	je     802d9c <alloc_block_NF+0x98>
  802d8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d90:	8b 40 04             	mov    0x4(%eax),%eax
  802d93:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d96:	8b 12                	mov    (%edx),%edx
  802d98:	89 10                	mov    %edx,(%eax)
  802d9a:	eb 0a                	jmp    802da6 <alloc_block_NF+0xa2>
  802d9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9f:	8b 00                	mov    (%eax),%eax
  802da1:	a3 38 51 80 00       	mov    %eax,0x805138
  802da6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802daf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802db9:	a1 44 51 80 00       	mov    0x805144,%eax
  802dbe:	48                   	dec    %eax
  802dbf:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802dc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc7:	8b 40 08             	mov    0x8(%eax),%eax
  802dca:	a3 2c 50 80 00       	mov    %eax,0x80502c
				   return  point;
  802dcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd2:	e9 f8 04 00 00       	jmp    8032cf <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802dd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dda:	8b 40 0c             	mov    0xc(%eax),%eax
  802ddd:	3b 45 08             	cmp    0x8(%ebp),%eax
  802de0:	0f 86 d4 00 00 00    	jbe    802eba <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802de6:	a1 48 51 80 00       	mov    0x805148,%eax
  802deb:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802dee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df1:	8b 50 08             	mov    0x8(%eax),%edx
  802df4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802df7:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802dfa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dfd:	8b 55 08             	mov    0x8(%ebp),%edx
  802e00:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802e03:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e07:	75 17                	jne    802e20 <alloc_block_NF+0x11c>
  802e09:	83 ec 04             	sub    $0x4,%esp
  802e0c:	68 e4 46 80 00       	push   $0x8046e4
  802e11:	68 e9 00 00 00       	push   $0xe9
  802e16:	68 3b 46 80 00       	push   $0x80463b
  802e1b:	e8 71 d9 ff ff       	call   800791 <_panic>
  802e20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e23:	8b 00                	mov    (%eax),%eax
  802e25:	85 c0                	test   %eax,%eax
  802e27:	74 10                	je     802e39 <alloc_block_NF+0x135>
  802e29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e2c:	8b 00                	mov    (%eax),%eax
  802e2e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e31:	8b 52 04             	mov    0x4(%edx),%edx
  802e34:	89 50 04             	mov    %edx,0x4(%eax)
  802e37:	eb 0b                	jmp    802e44 <alloc_block_NF+0x140>
  802e39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e3c:	8b 40 04             	mov    0x4(%eax),%eax
  802e3f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e47:	8b 40 04             	mov    0x4(%eax),%eax
  802e4a:	85 c0                	test   %eax,%eax
  802e4c:	74 0f                	je     802e5d <alloc_block_NF+0x159>
  802e4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e51:	8b 40 04             	mov    0x4(%eax),%eax
  802e54:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e57:	8b 12                	mov    (%edx),%edx
  802e59:	89 10                	mov    %edx,(%eax)
  802e5b:	eb 0a                	jmp    802e67 <alloc_block_NF+0x163>
  802e5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e60:	8b 00                	mov    (%eax),%eax
  802e62:	a3 48 51 80 00       	mov    %eax,0x805148
  802e67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e6a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e73:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e7a:	a1 54 51 80 00       	mov    0x805154,%eax
  802e7f:	48                   	dec    %eax
  802e80:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802e85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e88:	8b 40 08             	mov    0x8(%eax),%eax
  802e8b:	a3 2c 50 80 00       	mov    %eax,0x80502c
				   point->sva += size;
  802e90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e93:	8b 50 08             	mov    0x8(%eax),%edx
  802e96:	8b 45 08             	mov    0x8(%ebp),%eax
  802e99:	01 c2                	add    %eax,%edx
  802e9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9e:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802ea1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea4:	8b 40 0c             	mov    0xc(%eax),%eax
  802ea7:	2b 45 08             	sub    0x8(%ebp),%eax
  802eaa:	89 c2                	mov    %eax,%edx
  802eac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eaf:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802eb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eb5:	e9 15 04 00 00       	jmp    8032cf <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802eba:	a1 40 51 80 00       	mov    0x805140,%eax
  802ebf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ec2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ec6:	74 07                	je     802ecf <alloc_block_NF+0x1cb>
  802ec8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ecb:	8b 00                	mov    (%eax),%eax
  802ecd:	eb 05                	jmp    802ed4 <alloc_block_NF+0x1d0>
  802ecf:	b8 00 00 00 00       	mov    $0x0,%eax
  802ed4:	a3 40 51 80 00       	mov    %eax,0x805140
  802ed9:	a1 40 51 80 00       	mov    0x805140,%eax
  802ede:	85 c0                	test   %eax,%eax
  802ee0:	0f 85 3e fe ff ff    	jne    802d24 <alloc_block_NF+0x20>
  802ee6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802eea:	0f 85 34 fe ff ff    	jne    802d24 <alloc_block_NF+0x20>
  802ef0:	e9 d5 03 00 00       	jmp    8032ca <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802ef5:	a1 38 51 80 00       	mov    0x805138,%eax
  802efa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802efd:	e9 b1 01 00 00       	jmp    8030b3 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802f02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f05:	8b 50 08             	mov    0x8(%eax),%edx
  802f08:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802f0d:	39 c2                	cmp    %eax,%edx
  802f0f:	0f 82 96 01 00 00    	jb     8030ab <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802f15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f18:	8b 40 0c             	mov    0xc(%eax),%eax
  802f1b:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f1e:	0f 82 87 01 00 00    	jb     8030ab <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802f24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f27:	8b 40 0c             	mov    0xc(%eax),%eax
  802f2a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f2d:	0f 85 95 00 00 00    	jne    802fc8 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802f33:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f37:	75 17                	jne    802f50 <alloc_block_NF+0x24c>
  802f39:	83 ec 04             	sub    $0x4,%esp
  802f3c:	68 e4 46 80 00       	push   $0x8046e4
  802f41:	68 fc 00 00 00       	push   $0xfc
  802f46:	68 3b 46 80 00       	push   $0x80463b
  802f4b:	e8 41 d8 ff ff       	call   800791 <_panic>
  802f50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f53:	8b 00                	mov    (%eax),%eax
  802f55:	85 c0                	test   %eax,%eax
  802f57:	74 10                	je     802f69 <alloc_block_NF+0x265>
  802f59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5c:	8b 00                	mov    (%eax),%eax
  802f5e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f61:	8b 52 04             	mov    0x4(%edx),%edx
  802f64:	89 50 04             	mov    %edx,0x4(%eax)
  802f67:	eb 0b                	jmp    802f74 <alloc_block_NF+0x270>
  802f69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6c:	8b 40 04             	mov    0x4(%eax),%eax
  802f6f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f77:	8b 40 04             	mov    0x4(%eax),%eax
  802f7a:	85 c0                	test   %eax,%eax
  802f7c:	74 0f                	je     802f8d <alloc_block_NF+0x289>
  802f7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f81:	8b 40 04             	mov    0x4(%eax),%eax
  802f84:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f87:	8b 12                	mov    (%edx),%edx
  802f89:	89 10                	mov    %edx,(%eax)
  802f8b:	eb 0a                	jmp    802f97 <alloc_block_NF+0x293>
  802f8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f90:	8b 00                	mov    (%eax),%eax
  802f92:	a3 38 51 80 00       	mov    %eax,0x805138
  802f97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f9a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802faa:	a1 44 51 80 00       	mov    0x805144,%eax
  802faf:	48                   	dec    %eax
  802fb0:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802fb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb8:	8b 40 08             	mov    0x8(%eax),%eax
  802fbb:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   return  point;
  802fc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc3:	e9 07 03 00 00       	jmp    8032cf <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802fc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fcb:	8b 40 0c             	mov    0xc(%eax),%eax
  802fce:	3b 45 08             	cmp    0x8(%ebp),%eax
  802fd1:	0f 86 d4 00 00 00    	jbe    8030ab <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802fd7:	a1 48 51 80 00       	mov    0x805148,%eax
  802fdc:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802fdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe2:	8b 50 08             	mov    0x8(%eax),%edx
  802fe5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fe8:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802feb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fee:	8b 55 08             	mov    0x8(%ebp),%edx
  802ff1:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802ff4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ff8:	75 17                	jne    803011 <alloc_block_NF+0x30d>
  802ffa:	83 ec 04             	sub    $0x4,%esp
  802ffd:	68 e4 46 80 00       	push   $0x8046e4
  803002:	68 04 01 00 00       	push   $0x104
  803007:	68 3b 46 80 00       	push   $0x80463b
  80300c:	e8 80 d7 ff ff       	call   800791 <_panic>
  803011:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803014:	8b 00                	mov    (%eax),%eax
  803016:	85 c0                	test   %eax,%eax
  803018:	74 10                	je     80302a <alloc_block_NF+0x326>
  80301a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80301d:	8b 00                	mov    (%eax),%eax
  80301f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803022:	8b 52 04             	mov    0x4(%edx),%edx
  803025:	89 50 04             	mov    %edx,0x4(%eax)
  803028:	eb 0b                	jmp    803035 <alloc_block_NF+0x331>
  80302a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80302d:	8b 40 04             	mov    0x4(%eax),%eax
  803030:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803035:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803038:	8b 40 04             	mov    0x4(%eax),%eax
  80303b:	85 c0                	test   %eax,%eax
  80303d:	74 0f                	je     80304e <alloc_block_NF+0x34a>
  80303f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803042:	8b 40 04             	mov    0x4(%eax),%eax
  803045:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803048:	8b 12                	mov    (%edx),%edx
  80304a:	89 10                	mov    %edx,(%eax)
  80304c:	eb 0a                	jmp    803058 <alloc_block_NF+0x354>
  80304e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803051:	8b 00                	mov    (%eax),%eax
  803053:	a3 48 51 80 00       	mov    %eax,0x805148
  803058:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80305b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803061:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803064:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80306b:	a1 54 51 80 00       	mov    0x805154,%eax
  803070:	48                   	dec    %eax
  803071:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  803076:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803079:	8b 40 08             	mov    0x8(%eax),%eax
  80307c:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   point->sva += size;
  803081:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803084:	8b 50 08             	mov    0x8(%eax),%edx
  803087:	8b 45 08             	mov    0x8(%ebp),%eax
  80308a:	01 c2                	add    %eax,%edx
  80308c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80308f:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803092:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803095:	8b 40 0c             	mov    0xc(%eax),%eax
  803098:	2b 45 08             	sub    0x8(%ebp),%eax
  80309b:	89 c2                	mov    %eax,%edx
  80309d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a0:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8030a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030a6:	e9 24 02 00 00       	jmp    8032cf <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8030ab:	a1 40 51 80 00       	mov    0x805140,%eax
  8030b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030b7:	74 07                	je     8030c0 <alloc_block_NF+0x3bc>
  8030b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030bc:	8b 00                	mov    (%eax),%eax
  8030be:	eb 05                	jmp    8030c5 <alloc_block_NF+0x3c1>
  8030c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8030c5:	a3 40 51 80 00       	mov    %eax,0x805140
  8030ca:	a1 40 51 80 00       	mov    0x805140,%eax
  8030cf:	85 c0                	test   %eax,%eax
  8030d1:	0f 85 2b fe ff ff    	jne    802f02 <alloc_block_NF+0x1fe>
  8030d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030db:	0f 85 21 fe ff ff    	jne    802f02 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8030e1:	a1 38 51 80 00       	mov    0x805138,%eax
  8030e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030e9:	e9 ae 01 00 00       	jmp    80329c <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  8030ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f1:	8b 50 08             	mov    0x8(%eax),%edx
  8030f4:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8030f9:	39 c2                	cmp    %eax,%edx
  8030fb:	0f 83 93 01 00 00    	jae    803294 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  803101:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803104:	8b 40 0c             	mov    0xc(%eax),%eax
  803107:	3b 45 08             	cmp    0x8(%ebp),%eax
  80310a:	0f 82 84 01 00 00    	jb     803294 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  803110:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803113:	8b 40 0c             	mov    0xc(%eax),%eax
  803116:	3b 45 08             	cmp    0x8(%ebp),%eax
  803119:	0f 85 95 00 00 00    	jne    8031b4 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  80311f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803123:	75 17                	jne    80313c <alloc_block_NF+0x438>
  803125:	83 ec 04             	sub    $0x4,%esp
  803128:	68 e4 46 80 00       	push   $0x8046e4
  80312d:	68 14 01 00 00       	push   $0x114
  803132:	68 3b 46 80 00       	push   $0x80463b
  803137:	e8 55 d6 ff ff       	call   800791 <_panic>
  80313c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80313f:	8b 00                	mov    (%eax),%eax
  803141:	85 c0                	test   %eax,%eax
  803143:	74 10                	je     803155 <alloc_block_NF+0x451>
  803145:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803148:	8b 00                	mov    (%eax),%eax
  80314a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80314d:	8b 52 04             	mov    0x4(%edx),%edx
  803150:	89 50 04             	mov    %edx,0x4(%eax)
  803153:	eb 0b                	jmp    803160 <alloc_block_NF+0x45c>
  803155:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803158:	8b 40 04             	mov    0x4(%eax),%eax
  80315b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803160:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803163:	8b 40 04             	mov    0x4(%eax),%eax
  803166:	85 c0                	test   %eax,%eax
  803168:	74 0f                	je     803179 <alloc_block_NF+0x475>
  80316a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80316d:	8b 40 04             	mov    0x4(%eax),%eax
  803170:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803173:	8b 12                	mov    (%edx),%edx
  803175:	89 10                	mov    %edx,(%eax)
  803177:	eb 0a                	jmp    803183 <alloc_block_NF+0x47f>
  803179:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80317c:	8b 00                	mov    (%eax),%eax
  80317e:	a3 38 51 80 00       	mov    %eax,0x805138
  803183:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803186:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80318c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80318f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803196:	a1 44 51 80 00       	mov    0x805144,%eax
  80319b:	48                   	dec    %eax
  80319c:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8031a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a4:	8b 40 08             	mov    0x8(%eax),%eax
  8031a7:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   return  point;
  8031ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031af:	e9 1b 01 00 00       	jmp    8032cf <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8031b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b7:	8b 40 0c             	mov    0xc(%eax),%eax
  8031ba:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031bd:	0f 86 d1 00 00 00    	jbe    803294 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8031c3:	a1 48 51 80 00       	mov    0x805148,%eax
  8031c8:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  8031cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ce:	8b 50 08             	mov    0x8(%eax),%edx
  8031d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031d4:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8031d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031da:	8b 55 08             	mov    0x8(%ebp),%edx
  8031dd:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8031e0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8031e4:	75 17                	jne    8031fd <alloc_block_NF+0x4f9>
  8031e6:	83 ec 04             	sub    $0x4,%esp
  8031e9:	68 e4 46 80 00       	push   $0x8046e4
  8031ee:	68 1c 01 00 00       	push   $0x11c
  8031f3:	68 3b 46 80 00       	push   $0x80463b
  8031f8:	e8 94 d5 ff ff       	call   800791 <_panic>
  8031fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803200:	8b 00                	mov    (%eax),%eax
  803202:	85 c0                	test   %eax,%eax
  803204:	74 10                	je     803216 <alloc_block_NF+0x512>
  803206:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803209:	8b 00                	mov    (%eax),%eax
  80320b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80320e:	8b 52 04             	mov    0x4(%edx),%edx
  803211:	89 50 04             	mov    %edx,0x4(%eax)
  803214:	eb 0b                	jmp    803221 <alloc_block_NF+0x51d>
  803216:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803219:	8b 40 04             	mov    0x4(%eax),%eax
  80321c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803221:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803224:	8b 40 04             	mov    0x4(%eax),%eax
  803227:	85 c0                	test   %eax,%eax
  803229:	74 0f                	je     80323a <alloc_block_NF+0x536>
  80322b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80322e:	8b 40 04             	mov    0x4(%eax),%eax
  803231:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803234:	8b 12                	mov    (%edx),%edx
  803236:	89 10                	mov    %edx,(%eax)
  803238:	eb 0a                	jmp    803244 <alloc_block_NF+0x540>
  80323a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80323d:	8b 00                	mov    (%eax),%eax
  80323f:	a3 48 51 80 00       	mov    %eax,0x805148
  803244:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803247:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80324d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803250:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803257:	a1 54 51 80 00       	mov    0x805154,%eax
  80325c:	48                   	dec    %eax
  80325d:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  803262:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803265:	8b 40 08             	mov    0x8(%eax),%eax
  803268:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   point->sva += size;
  80326d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803270:	8b 50 08             	mov    0x8(%eax),%edx
  803273:	8b 45 08             	mov    0x8(%ebp),%eax
  803276:	01 c2                	add    %eax,%edx
  803278:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80327b:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  80327e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803281:	8b 40 0c             	mov    0xc(%eax),%eax
  803284:	2b 45 08             	sub    0x8(%ebp),%eax
  803287:	89 c2                	mov    %eax,%edx
  803289:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80328c:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  80328f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803292:	eb 3b                	jmp    8032cf <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803294:	a1 40 51 80 00       	mov    0x805140,%eax
  803299:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80329c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032a0:	74 07                	je     8032a9 <alloc_block_NF+0x5a5>
  8032a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a5:	8b 00                	mov    (%eax),%eax
  8032a7:	eb 05                	jmp    8032ae <alloc_block_NF+0x5aa>
  8032a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8032ae:	a3 40 51 80 00       	mov    %eax,0x805140
  8032b3:	a1 40 51 80 00       	mov    0x805140,%eax
  8032b8:	85 c0                	test   %eax,%eax
  8032ba:	0f 85 2e fe ff ff    	jne    8030ee <alloc_block_NF+0x3ea>
  8032c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032c4:	0f 85 24 fe ff ff    	jne    8030ee <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  8032ca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8032cf:	c9                   	leave  
  8032d0:	c3                   	ret    

008032d1 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8032d1:	55                   	push   %ebp
  8032d2:	89 e5                	mov    %esp,%ebp
  8032d4:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  8032d7:	a1 38 51 80 00       	mov    0x805138,%eax
  8032dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  8032df:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8032e4:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  8032e7:	a1 38 51 80 00       	mov    0x805138,%eax
  8032ec:	85 c0                	test   %eax,%eax
  8032ee:	74 14                	je     803304 <insert_sorted_with_merge_freeList+0x33>
  8032f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f3:	8b 50 08             	mov    0x8(%eax),%edx
  8032f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032f9:	8b 40 08             	mov    0x8(%eax),%eax
  8032fc:	39 c2                	cmp    %eax,%edx
  8032fe:	0f 87 9b 01 00 00    	ja     80349f <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  803304:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803308:	75 17                	jne    803321 <insert_sorted_with_merge_freeList+0x50>
  80330a:	83 ec 04             	sub    $0x4,%esp
  80330d:	68 18 46 80 00       	push   $0x804618
  803312:	68 38 01 00 00       	push   $0x138
  803317:	68 3b 46 80 00       	push   $0x80463b
  80331c:	e8 70 d4 ff ff       	call   800791 <_panic>
  803321:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803327:	8b 45 08             	mov    0x8(%ebp),%eax
  80332a:	89 10                	mov    %edx,(%eax)
  80332c:	8b 45 08             	mov    0x8(%ebp),%eax
  80332f:	8b 00                	mov    (%eax),%eax
  803331:	85 c0                	test   %eax,%eax
  803333:	74 0d                	je     803342 <insert_sorted_with_merge_freeList+0x71>
  803335:	a1 38 51 80 00       	mov    0x805138,%eax
  80333a:	8b 55 08             	mov    0x8(%ebp),%edx
  80333d:	89 50 04             	mov    %edx,0x4(%eax)
  803340:	eb 08                	jmp    80334a <insert_sorted_with_merge_freeList+0x79>
  803342:	8b 45 08             	mov    0x8(%ebp),%eax
  803345:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80334a:	8b 45 08             	mov    0x8(%ebp),%eax
  80334d:	a3 38 51 80 00       	mov    %eax,0x805138
  803352:	8b 45 08             	mov    0x8(%ebp),%eax
  803355:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80335c:	a1 44 51 80 00       	mov    0x805144,%eax
  803361:	40                   	inc    %eax
  803362:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803367:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80336b:	0f 84 a8 06 00 00    	je     803a19 <insert_sorted_with_merge_freeList+0x748>
  803371:	8b 45 08             	mov    0x8(%ebp),%eax
  803374:	8b 50 08             	mov    0x8(%eax),%edx
  803377:	8b 45 08             	mov    0x8(%ebp),%eax
  80337a:	8b 40 0c             	mov    0xc(%eax),%eax
  80337d:	01 c2                	add    %eax,%edx
  80337f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803382:	8b 40 08             	mov    0x8(%eax),%eax
  803385:	39 c2                	cmp    %eax,%edx
  803387:	0f 85 8c 06 00 00    	jne    803a19 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  80338d:	8b 45 08             	mov    0x8(%ebp),%eax
  803390:	8b 50 0c             	mov    0xc(%eax),%edx
  803393:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803396:	8b 40 0c             	mov    0xc(%eax),%eax
  803399:	01 c2                	add    %eax,%edx
  80339b:	8b 45 08             	mov    0x8(%ebp),%eax
  80339e:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  8033a1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8033a5:	75 17                	jne    8033be <insert_sorted_with_merge_freeList+0xed>
  8033a7:	83 ec 04             	sub    $0x4,%esp
  8033aa:	68 e4 46 80 00       	push   $0x8046e4
  8033af:	68 3c 01 00 00       	push   $0x13c
  8033b4:	68 3b 46 80 00       	push   $0x80463b
  8033b9:	e8 d3 d3 ff ff       	call   800791 <_panic>
  8033be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033c1:	8b 00                	mov    (%eax),%eax
  8033c3:	85 c0                	test   %eax,%eax
  8033c5:	74 10                	je     8033d7 <insert_sorted_with_merge_freeList+0x106>
  8033c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033ca:	8b 00                	mov    (%eax),%eax
  8033cc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8033cf:	8b 52 04             	mov    0x4(%edx),%edx
  8033d2:	89 50 04             	mov    %edx,0x4(%eax)
  8033d5:	eb 0b                	jmp    8033e2 <insert_sorted_with_merge_freeList+0x111>
  8033d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033da:	8b 40 04             	mov    0x4(%eax),%eax
  8033dd:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8033e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033e5:	8b 40 04             	mov    0x4(%eax),%eax
  8033e8:	85 c0                	test   %eax,%eax
  8033ea:	74 0f                	je     8033fb <insert_sorted_with_merge_freeList+0x12a>
  8033ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033ef:	8b 40 04             	mov    0x4(%eax),%eax
  8033f2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8033f5:	8b 12                	mov    (%edx),%edx
  8033f7:	89 10                	mov    %edx,(%eax)
  8033f9:	eb 0a                	jmp    803405 <insert_sorted_with_merge_freeList+0x134>
  8033fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033fe:	8b 00                	mov    (%eax),%eax
  803400:	a3 38 51 80 00       	mov    %eax,0x805138
  803405:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803408:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80340e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803411:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803418:	a1 44 51 80 00       	mov    0x805144,%eax
  80341d:	48                   	dec    %eax
  80341e:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  803423:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803426:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  80342d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803430:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  803437:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80343b:	75 17                	jne    803454 <insert_sorted_with_merge_freeList+0x183>
  80343d:	83 ec 04             	sub    $0x4,%esp
  803440:	68 18 46 80 00       	push   $0x804618
  803445:	68 3f 01 00 00       	push   $0x13f
  80344a:	68 3b 46 80 00       	push   $0x80463b
  80344f:	e8 3d d3 ff ff       	call   800791 <_panic>
  803454:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80345a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80345d:	89 10                	mov    %edx,(%eax)
  80345f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803462:	8b 00                	mov    (%eax),%eax
  803464:	85 c0                	test   %eax,%eax
  803466:	74 0d                	je     803475 <insert_sorted_with_merge_freeList+0x1a4>
  803468:	a1 48 51 80 00       	mov    0x805148,%eax
  80346d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803470:	89 50 04             	mov    %edx,0x4(%eax)
  803473:	eb 08                	jmp    80347d <insert_sorted_with_merge_freeList+0x1ac>
  803475:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803478:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80347d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803480:	a3 48 51 80 00       	mov    %eax,0x805148
  803485:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803488:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80348f:	a1 54 51 80 00       	mov    0x805154,%eax
  803494:	40                   	inc    %eax
  803495:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80349a:	e9 7a 05 00 00       	jmp    803a19 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  80349f:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a2:	8b 50 08             	mov    0x8(%eax),%edx
  8034a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034a8:	8b 40 08             	mov    0x8(%eax),%eax
  8034ab:	39 c2                	cmp    %eax,%edx
  8034ad:	0f 82 14 01 00 00    	jb     8035c7 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  8034b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034b6:	8b 50 08             	mov    0x8(%eax),%edx
  8034b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034bc:	8b 40 0c             	mov    0xc(%eax),%eax
  8034bf:	01 c2                	add    %eax,%edx
  8034c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c4:	8b 40 08             	mov    0x8(%eax),%eax
  8034c7:	39 c2                	cmp    %eax,%edx
  8034c9:	0f 85 90 00 00 00    	jne    80355f <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  8034cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034d2:	8b 50 0c             	mov    0xc(%eax),%edx
  8034d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d8:	8b 40 0c             	mov    0xc(%eax),%eax
  8034db:	01 c2                	add    %eax,%edx
  8034dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034e0:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  8034e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  8034ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8034f7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034fb:	75 17                	jne    803514 <insert_sorted_with_merge_freeList+0x243>
  8034fd:	83 ec 04             	sub    $0x4,%esp
  803500:	68 18 46 80 00       	push   $0x804618
  803505:	68 49 01 00 00       	push   $0x149
  80350a:	68 3b 46 80 00       	push   $0x80463b
  80350f:	e8 7d d2 ff ff       	call   800791 <_panic>
  803514:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80351a:	8b 45 08             	mov    0x8(%ebp),%eax
  80351d:	89 10                	mov    %edx,(%eax)
  80351f:	8b 45 08             	mov    0x8(%ebp),%eax
  803522:	8b 00                	mov    (%eax),%eax
  803524:	85 c0                	test   %eax,%eax
  803526:	74 0d                	je     803535 <insert_sorted_with_merge_freeList+0x264>
  803528:	a1 48 51 80 00       	mov    0x805148,%eax
  80352d:	8b 55 08             	mov    0x8(%ebp),%edx
  803530:	89 50 04             	mov    %edx,0x4(%eax)
  803533:	eb 08                	jmp    80353d <insert_sorted_with_merge_freeList+0x26c>
  803535:	8b 45 08             	mov    0x8(%ebp),%eax
  803538:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80353d:	8b 45 08             	mov    0x8(%ebp),%eax
  803540:	a3 48 51 80 00       	mov    %eax,0x805148
  803545:	8b 45 08             	mov    0x8(%ebp),%eax
  803548:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80354f:	a1 54 51 80 00       	mov    0x805154,%eax
  803554:	40                   	inc    %eax
  803555:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80355a:	e9 bb 04 00 00       	jmp    803a1a <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  80355f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803563:	75 17                	jne    80357c <insert_sorted_with_merge_freeList+0x2ab>
  803565:	83 ec 04             	sub    $0x4,%esp
  803568:	68 8c 46 80 00       	push   $0x80468c
  80356d:	68 4c 01 00 00       	push   $0x14c
  803572:	68 3b 46 80 00       	push   $0x80463b
  803577:	e8 15 d2 ff ff       	call   800791 <_panic>
  80357c:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803582:	8b 45 08             	mov    0x8(%ebp),%eax
  803585:	89 50 04             	mov    %edx,0x4(%eax)
  803588:	8b 45 08             	mov    0x8(%ebp),%eax
  80358b:	8b 40 04             	mov    0x4(%eax),%eax
  80358e:	85 c0                	test   %eax,%eax
  803590:	74 0c                	je     80359e <insert_sorted_with_merge_freeList+0x2cd>
  803592:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803597:	8b 55 08             	mov    0x8(%ebp),%edx
  80359a:	89 10                	mov    %edx,(%eax)
  80359c:	eb 08                	jmp    8035a6 <insert_sorted_with_merge_freeList+0x2d5>
  80359e:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a1:	a3 38 51 80 00       	mov    %eax,0x805138
  8035a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8035ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035b7:	a1 44 51 80 00       	mov    0x805144,%eax
  8035bc:	40                   	inc    %eax
  8035bd:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8035c2:	e9 53 04 00 00       	jmp    803a1a <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8035c7:	a1 38 51 80 00       	mov    0x805138,%eax
  8035cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8035cf:	e9 15 04 00 00       	jmp    8039e9 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  8035d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035d7:	8b 00                	mov    (%eax),%eax
  8035d9:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  8035dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8035df:	8b 50 08             	mov    0x8(%eax),%edx
  8035e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035e5:	8b 40 08             	mov    0x8(%eax),%eax
  8035e8:	39 c2                	cmp    %eax,%edx
  8035ea:	0f 86 f1 03 00 00    	jbe    8039e1 <insert_sorted_with_merge_freeList+0x710>
  8035f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f3:	8b 50 08             	mov    0x8(%eax),%edx
  8035f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035f9:	8b 40 08             	mov    0x8(%eax),%eax
  8035fc:	39 c2                	cmp    %eax,%edx
  8035fe:	0f 83 dd 03 00 00    	jae    8039e1 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803604:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803607:	8b 50 08             	mov    0x8(%eax),%edx
  80360a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80360d:	8b 40 0c             	mov    0xc(%eax),%eax
  803610:	01 c2                	add    %eax,%edx
  803612:	8b 45 08             	mov    0x8(%ebp),%eax
  803615:	8b 40 08             	mov    0x8(%eax),%eax
  803618:	39 c2                	cmp    %eax,%edx
  80361a:	0f 85 b9 01 00 00    	jne    8037d9 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803620:	8b 45 08             	mov    0x8(%ebp),%eax
  803623:	8b 50 08             	mov    0x8(%eax),%edx
  803626:	8b 45 08             	mov    0x8(%ebp),%eax
  803629:	8b 40 0c             	mov    0xc(%eax),%eax
  80362c:	01 c2                	add    %eax,%edx
  80362e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803631:	8b 40 08             	mov    0x8(%eax),%eax
  803634:	39 c2                	cmp    %eax,%edx
  803636:	0f 85 0d 01 00 00    	jne    803749 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  80363c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80363f:	8b 50 0c             	mov    0xc(%eax),%edx
  803642:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803645:	8b 40 0c             	mov    0xc(%eax),%eax
  803648:	01 c2                	add    %eax,%edx
  80364a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80364d:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803650:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803654:	75 17                	jne    80366d <insert_sorted_with_merge_freeList+0x39c>
  803656:	83 ec 04             	sub    $0x4,%esp
  803659:	68 e4 46 80 00       	push   $0x8046e4
  80365e:	68 5c 01 00 00       	push   $0x15c
  803663:	68 3b 46 80 00       	push   $0x80463b
  803668:	e8 24 d1 ff ff       	call   800791 <_panic>
  80366d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803670:	8b 00                	mov    (%eax),%eax
  803672:	85 c0                	test   %eax,%eax
  803674:	74 10                	je     803686 <insert_sorted_with_merge_freeList+0x3b5>
  803676:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803679:	8b 00                	mov    (%eax),%eax
  80367b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80367e:	8b 52 04             	mov    0x4(%edx),%edx
  803681:	89 50 04             	mov    %edx,0x4(%eax)
  803684:	eb 0b                	jmp    803691 <insert_sorted_with_merge_freeList+0x3c0>
  803686:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803689:	8b 40 04             	mov    0x4(%eax),%eax
  80368c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803691:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803694:	8b 40 04             	mov    0x4(%eax),%eax
  803697:	85 c0                	test   %eax,%eax
  803699:	74 0f                	je     8036aa <insert_sorted_with_merge_freeList+0x3d9>
  80369b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80369e:	8b 40 04             	mov    0x4(%eax),%eax
  8036a1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8036a4:	8b 12                	mov    (%edx),%edx
  8036a6:	89 10                	mov    %edx,(%eax)
  8036a8:	eb 0a                	jmp    8036b4 <insert_sorted_with_merge_freeList+0x3e3>
  8036aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036ad:	8b 00                	mov    (%eax),%eax
  8036af:	a3 38 51 80 00       	mov    %eax,0x805138
  8036b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036b7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036c0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036c7:	a1 44 51 80 00       	mov    0x805144,%eax
  8036cc:	48                   	dec    %eax
  8036cd:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  8036d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036d5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8036dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036df:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8036e6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8036ea:	75 17                	jne    803703 <insert_sorted_with_merge_freeList+0x432>
  8036ec:	83 ec 04             	sub    $0x4,%esp
  8036ef:	68 18 46 80 00       	push   $0x804618
  8036f4:	68 5f 01 00 00       	push   $0x15f
  8036f9:	68 3b 46 80 00       	push   $0x80463b
  8036fe:	e8 8e d0 ff ff       	call   800791 <_panic>
  803703:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803709:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80370c:	89 10                	mov    %edx,(%eax)
  80370e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803711:	8b 00                	mov    (%eax),%eax
  803713:	85 c0                	test   %eax,%eax
  803715:	74 0d                	je     803724 <insert_sorted_with_merge_freeList+0x453>
  803717:	a1 48 51 80 00       	mov    0x805148,%eax
  80371c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80371f:	89 50 04             	mov    %edx,0x4(%eax)
  803722:	eb 08                	jmp    80372c <insert_sorted_with_merge_freeList+0x45b>
  803724:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803727:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80372c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80372f:	a3 48 51 80 00       	mov    %eax,0x805148
  803734:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803737:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80373e:	a1 54 51 80 00       	mov    0x805154,%eax
  803743:	40                   	inc    %eax
  803744:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803749:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80374c:	8b 50 0c             	mov    0xc(%eax),%edx
  80374f:	8b 45 08             	mov    0x8(%ebp),%eax
  803752:	8b 40 0c             	mov    0xc(%eax),%eax
  803755:	01 c2                	add    %eax,%edx
  803757:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80375a:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  80375d:	8b 45 08             	mov    0x8(%ebp),%eax
  803760:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803767:	8b 45 08             	mov    0x8(%ebp),%eax
  80376a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803771:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803775:	75 17                	jne    80378e <insert_sorted_with_merge_freeList+0x4bd>
  803777:	83 ec 04             	sub    $0x4,%esp
  80377a:	68 18 46 80 00       	push   $0x804618
  80377f:	68 64 01 00 00       	push   $0x164
  803784:	68 3b 46 80 00       	push   $0x80463b
  803789:	e8 03 d0 ff ff       	call   800791 <_panic>
  80378e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803794:	8b 45 08             	mov    0x8(%ebp),%eax
  803797:	89 10                	mov    %edx,(%eax)
  803799:	8b 45 08             	mov    0x8(%ebp),%eax
  80379c:	8b 00                	mov    (%eax),%eax
  80379e:	85 c0                	test   %eax,%eax
  8037a0:	74 0d                	je     8037af <insert_sorted_with_merge_freeList+0x4de>
  8037a2:	a1 48 51 80 00       	mov    0x805148,%eax
  8037a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8037aa:	89 50 04             	mov    %edx,0x4(%eax)
  8037ad:	eb 08                	jmp    8037b7 <insert_sorted_with_merge_freeList+0x4e6>
  8037af:	8b 45 08             	mov    0x8(%ebp),%eax
  8037b2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8037b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ba:	a3 48 51 80 00       	mov    %eax,0x805148
  8037bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8037c2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037c9:	a1 54 51 80 00       	mov    0x805154,%eax
  8037ce:	40                   	inc    %eax
  8037cf:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8037d4:	e9 41 02 00 00       	jmp    803a1a <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8037d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8037dc:	8b 50 08             	mov    0x8(%eax),%edx
  8037df:	8b 45 08             	mov    0x8(%ebp),%eax
  8037e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8037e5:	01 c2                	add    %eax,%edx
  8037e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037ea:	8b 40 08             	mov    0x8(%eax),%eax
  8037ed:	39 c2                	cmp    %eax,%edx
  8037ef:	0f 85 7c 01 00 00    	jne    803971 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8037f5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8037f9:	74 06                	je     803801 <insert_sorted_with_merge_freeList+0x530>
  8037fb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037ff:	75 17                	jne    803818 <insert_sorted_with_merge_freeList+0x547>
  803801:	83 ec 04             	sub    $0x4,%esp
  803804:	68 54 46 80 00       	push   $0x804654
  803809:	68 69 01 00 00       	push   $0x169
  80380e:	68 3b 46 80 00       	push   $0x80463b
  803813:	e8 79 cf ff ff       	call   800791 <_panic>
  803818:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80381b:	8b 50 04             	mov    0x4(%eax),%edx
  80381e:	8b 45 08             	mov    0x8(%ebp),%eax
  803821:	89 50 04             	mov    %edx,0x4(%eax)
  803824:	8b 45 08             	mov    0x8(%ebp),%eax
  803827:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80382a:	89 10                	mov    %edx,(%eax)
  80382c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80382f:	8b 40 04             	mov    0x4(%eax),%eax
  803832:	85 c0                	test   %eax,%eax
  803834:	74 0d                	je     803843 <insert_sorted_with_merge_freeList+0x572>
  803836:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803839:	8b 40 04             	mov    0x4(%eax),%eax
  80383c:	8b 55 08             	mov    0x8(%ebp),%edx
  80383f:	89 10                	mov    %edx,(%eax)
  803841:	eb 08                	jmp    80384b <insert_sorted_with_merge_freeList+0x57a>
  803843:	8b 45 08             	mov    0x8(%ebp),%eax
  803846:	a3 38 51 80 00       	mov    %eax,0x805138
  80384b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80384e:	8b 55 08             	mov    0x8(%ebp),%edx
  803851:	89 50 04             	mov    %edx,0x4(%eax)
  803854:	a1 44 51 80 00       	mov    0x805144,%eax
  803859:	40                   	inc    %eax
  80385a:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  80385f:	8b 45 08             	mov    0x8(%ebp),%eax
  803862:	8b 50 0c             	mov    0xc(%eax),%edx
  803865:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803868:	8b 40 0c             	mov    0xc(%eax),%eax
  80386b:	01 c2                	add    %eax,%edx
  80386d:	8b 45 08             	mov    0x8(%ebp),%eax
  803870:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803873:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803877:	75 17                	jne    803890 <insert_sorted_with_merge_freeList+0x5bf>
  803879:	83 ec 04             	sub    $0x4,%esp
  80387c:	68 e4 46 80 00       	push   $0x8046e4
  803881:	68 6b 01 00 00       	push   $0x16b
  803886:	68 3b 46 80 00       	push   $0x80463b
  80388b:	e8 01 cf ff ff       	call   800791 <_panic>
  803890:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803893:	8b 00                	mov    (%eax),%eax
  803895:	85 c0                	test   %eax,%eax
  803897:	74 10                	je     8038a9 <insert_sorted_with_merge_freeList+0x5d8>
  803899:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80389c:	8b 00                	mov    (%eax),%eax
  80389e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8038a1:	8b 52 04             	mov    0x4(%edx),%edx
  8038a4:	89 50 04             	mov    %edx,0x4(%eax)
  8038a7:	eb 0b                	jmp    8038b4 <insert_sorted_with_merge_freeList+0x5e3>
  8038a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038ac:	8b 40 04             	mov    0x4(%eax),%eax
  8038af:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8038b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038b7:	8b 40 04             	mov    0x4(%eax),%eax
  8038ba:	85 c0                	test   %eax,%eax
  8038bc:	74 0f                	je     8038cd <insert_sorted_with_merge_freeList+0x5fc>
  8038be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038c1:	8b 40 04             	mov    0x4(%eax),%eax
  8038c4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8038c7:	8b 12                	mov    (%edx),%edx
  8038c9:	89 10                	mov    %edx,(%eax)
  8038cb:	eb 0a                	jmp    8038d7 <insert_sorted_with_merge_freeList+0x606>
  8038cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038d0:	8b 00                	mov    (%eax),%eax
  8038d2:	a3 38 51 80 00       	mov    %eax,0x805138
  8038d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038da:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038e3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038ea:	a1 44 51 80 00       	mov    0x805144,%eax
  8038ef:	48                   	dec    %eax
  8038f0:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  8038f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038f8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8038ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803902:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803909:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80390d:	75 17                	jne    803926 <insert_sorted_with_merge_freeList+0x655>
  80390f:	83 ec 04             	sub    $0x4,%esp
  803912:	68 18 46 80 00       	push   $0x804618
  803917:	68 6e 01 00 00       	push   $0x16e
  80391c:	68 3b 46 80 00       	push   $0x80463b
  803921:	e8 6b ce ff ff       	call   800791 <_panic>
  803926:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80392c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80392f:	89 10                	mov    %edx,(%eax)
  803931:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803934:	8b 00                	mov    (%eax),%eax
  803936:	85 c0                	test   %eax,%eax
  803938:	74 0d                	je     803947 <insert_sorted_with_merge_freeList+0x676>
  80393a:	a1 48 51 80 00       	mov    0x805148,%eax
  80393f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803942:	89 50 04             	mov    %edx,0x4(%eax)
  803945:	eb 08                	jmp    80394f <insert_sorted_with_merge_freeList+0x67e>
  803947:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80394a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80394f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803952:	a3 48 51 80 00       	mov    %eax,0x805148
  803957:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80395a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803961:	a1 54 51 80 00       	mov    0x805154,%eax
  803966:	40                   	inc    %eax
  803967:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80396c:	e9 a9 00 00 00       	jmp    803a1a <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803971:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803975:	74 06                	je     80397d <insert_sorted_with_merge_freeList+0x6ac>
  803977:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80397b:	75 17                	jne    803994 <insert_sorted_with_merge_freeList+0x6c3>
  80397d:	83 ec 04             	sub    $0x4,%esp
  803980:	68 b0 46 80 00       	push   $0x8046b0
  803985:	68 73 01 00 00       	push   $0x173
  80398a:	68 3b 46 80 00       	push   $0x80463b
  80398f:	e8 fd cd ff ff       	call   800791 <_panic>
  803994:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803997:	8b 10                	mov    (%eax),%edx
  803999:	8b 45 08             	mov    0x8(%ebp),%eax
  80399c:	89 10                	mov    %edx,(%eax)
  80399e:	8b 45 08             	mov    0x8(%ebp),%eax
  8039a1:	8b 00                	mov    (%eax),%eax
  8039a3:	85 c0                	test   %eax,%eax
  8039a5:	74 0b                	je     8039b2 <insert_sorted_with_merge_freeList+0x6e1>
  8039a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039aa:	8b 00                	mov    (%eax),%eax
  8039ac:	8b 55 08             	mov    0x8(%ebp),%edx
  8039af:	89 50 04             	mov    %edx,0x4(%eax)
  8039b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039b5:	8b 55 08             	mov    0x8(%ebp),%edx
  8039b8:	89 10                	mov    %edx,(%eax)
  8039ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8039bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8039c0:	89 50 04             	mov    %edx,0x4(%eax)
  8039c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8039c6:	8b 00                	mov    (%eax),%eax
  8039c8:	85 c0                	test   %eax,%eax
  8039ca:	75 08                	jne    8039d4 <insert_sorted_with_merge_freeList+0x703>
  8039cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8039cf:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8039d4:	a1 44 51 80 00       	mov    0x805144,%eax
  8039d9:	40                   	inc    %eax
  8039da:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  8039df:	eb 39                	jmp    803a1a <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8039e1:	a1 40 51 80 00       	mov    0x805140,%eax
  8039e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8039e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8039ed:	74 07                	je     8039f6 <insert_sorted_with_merge_freeList+0x725>
  8039ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039f2:	8b 00                	mov    (%eax),%eax
  8039f4:	eb 05                	jmp    8039fb <insert_sorted_with_merge_freeList+0x72a>
  8039f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8039fb:	a3 40 51 80 00       	mov    %eax,0x805140
  803a00:	a1 40 51 80 00       	mov    0x805140,%eax
  803a05:	85 c0                	test   %eax,%eax
  803a07:	0f 85 c7 fb ff ff    	jne    8035d4 <insert_sorted_with_merge_freeList+0x303>
  803a0d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a11:	0f 85 bd fb ff ff    	jne    8035d4 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803a17:	eb 01                	jmp    803a1a <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803a19:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803a1a:	90                   	nop
  803a1b:	c9                   	leave  
  803a1c:	c3                   	ret    
  803a1d:	66 90                	xchg   %ax,%ax
  803a1f:	90                   	nop

00803a20 <__udivdi3>:
  803a20:	55                   	push   %ebp
  803a21:	57                   	push   %edi
  803a22:	56                   	push   %esi
  803a23:	53                   	push   %ebx
  803a24:	83 ec 1c             	sub    $0x1c,%esp
  803a27:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803a2b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803a2f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803a33:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803a37:	89 ca                	mov    %ecx,%edx
  803a39:	89 f8                	mov    %edi,%eax
  803a3b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803a3f:	85 f6                	test   %esi,%esi
  803a41:	75 2d                	jne    803a70 <__udivdi3+0x50>
  803a43:	39 cf                	cmp    %ecx,%edi
  803a45:	77 65                	ja     803aac <__udivdi3+0x8c>
  803a47:	89 fd                	mov    %edi,%ebp
  803a49:	85 ff                	test   %edi,%edi
  803a4b:	75 0b                	jne    803a58 <__udivdi3+0x38>
  803a4d:	b8 01 00 00 00       	mov    $0x1,%eax
  803a52:	31 d2                	xor    %edx,%edx
  803a54:	f7 f7                	div    %edi
  803a56:	89 c5                	mov    %eax,%ebp
  803a58:	31 d2                	xor    %edx,%edx
  803a5a:	89 c8                	mov    %ecx,%eax
  803a5c:	f7 f5                	div    %ebp
  803a5e:	89 c1                	mov    %eax,%ecx
  803a60:	89 d8                	mov    %ebx,%eax
  803a62:	f7 f5                	div    %ebp
  803a64:	89 cf                	mov    %ecx,%edi
  803a66:	89 fa                	mov    %edi,%edx
  803a68:	83 c4 1c             	add    $0x1c,%esp
  803a6b:	5b                   	pop    %ebx
  803a6c:	5e                   	pop    %esi
  803a6d:	5f                   	pop    %edi
  803a6e:	5d                   	pop    %ebp
  803a6f:	c3                   	ret    
  803a70:	39 ce                	cmp    %ecx,%esi
  803a72:	77 28                	ja     803a9c <__udivdi3+0x7c>
  803a74:	0f bd fe             	bsr    %esi,%edi
  803a77:	83 f7 1f             	xor    $0x1f,%edi
  803a7a:	75 40                	jne    803abc <__udivdi3+0x9c>
  803a7c:	39 ce                	cmp    %ecx,%esi
  803a7e:	72 0a                	jb     803a8a <__udivdi3+0x6a>
  803a80:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803a84:	0f 87 9e 00 00 00    	ja     803b28 <__udivdi3+0x108>
  803a8a:	b8 01 00 00 00       	mov    $0x1,%eax
  803a8f:	89 fa                	mov    %edi,%edx
  803a91:	83 c4 1c             	add    $0x1c,%esp
  803a94:	5b                   	pop    %ebx
  803a95:	5e                   	pop    %esi
  803a96:	5f                   	pop    %edi
  803a97:	5d                   	pop    %ebp
  803a98:	c3                   	ret    
  803a99:	8d 76 00             	lea    0x0(%esi),%esi
  803a9c:	31 ff                	xor    %edi,%edi
  803a9e:	31 c0                	xor    %eax,%eax
  803aa0:	89 fa                	mov    %edi,%edx
  803aa2:	83 c4 1c             	add    $0x1c,%esp
  803aa5:	5b                   	pop    %ebx
  803aa6:	5e                   	pop    %esi
  803aa7:	5f                   	pop    %edi
  803aa8:	5d                   	pop    %ebp
  803aa9:	c3                   	ret    
  803aaa:	66 90                	xchg   %ax,%ax
  803aac:	89 d8                	mov    %ebx,%eax
  803aae:	f7 f7                	div    %edi
  803ab0:	31 ff                	xor    %edi,%edi
  803ab2:	89 fa                	mov    %edi,%edx
  803ab4:	83 c4 1c             	add    $0x1c,%esp
  803ab7:	5b                   	pop    %ebx
  803ab8:	5e                   	pop    %esi
  803ab9:	5f                   	pop    %edi
  803aba:	5d                   	pop    %ebp
  803abb:	c3                   	ret    
  803abc:	bd 20 00 00 00       	mov    $0x20,%ebp
  803ac1:	89 eb                	mov    %ebp,%ebx
  803ac3:	29 fb                	sub    %edi,%ebx
  803ac5:	89 f9                	mov    %edi,%ecx
  803ac7:	d3 e6                	shl    %cl,%esi
  803ac9:	89 c5                	mov    %eax,%ebp
  803acb:	88 d9                	mov    %bl,%cl
  803acd:	d3 ed                	shr    %cl,%ebp
  803acf:	89 e9                	mov    %ebp,%ecx
  803ad1:	09 f1                	or     %esi,%ecx
  803ad3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803ad7:	89 f9                	mov    %edi,%ecx
  803ad9:	d3 e0                	shl    %cl,%eax
  803adb:	89 c5                	mov    %eax,%ebp
  803add:	89 d6                	mov    %edx,%esi
  803adf:	88 d9                	mov    %bl,%cl
  803ae1:	d3 ee                	shr    %cl,%esi
  803ae3:	89 f9                	mov    %edi,%ecx
  803ae5:	d3 e2                	shl    %cl,%edx
  803ae7:	8b 44 24 08          	mov    0x8(%esp),%eax
  803aeb:	88 d9                	mov    %bl,%cl
  803aed:	d3 e8                	shr    %cl,%eax
  803aef:	09 c2                	or     %eax,%edx
  803af1:	89 d0                	mov    %edx,%eax
  803af3:	89 f2                	mov    %esi,%edx
  803af5:	f7 74 24 0c          	divl   0xc(%esp)
  803af9:	89 d6                	mov    %edx,%esi
  803afb:	89 c3                	mov    %eax,%ebx
  803afd:	f7 e5                	mul    %ebp
  803aff:	39 d6                	cmp    %edx,%esi
  803b01:	72 19                	jb     803b1c <__udivdi3+0xfc>
  803b03:	74 0b                	je     803b10 <__udivdi3+0xf0>
  803b05:	89 d8                	mov    %ebx,%eax
  803b07:	31 ff                	xor    %edi,%edi
  803b09:	e9 58 ff ff ff       	jmp    803a66 <__udivdi3+0x46>
  803b0e:	66 90                	xchg   %ax,%ax
  803b10:	8b 54 24 08          	mov    0x8(%esp),%edx
  803b14:	89 f9                	mov    %edi,%ecx
  803b16:	d3 e2                	shl    %cl,%edx
  803b18:	39 c2                	cmp    %eax,%edx
  803b1a:	73 e9                	jae    803b05 <__udivdi3+0xe5>
  803b1c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803b1f:	31 ff                	xor    %edi,%edi
  803b21:	e9 40 ff ff ff       	jmp    803a66 <__udivdi3+0x46>
  803b26:	66 90                	xchg   %ax,%ax
  803b28:	31 c0                	xor    %eax,%eax
  803b2a:	e9 37 ff ff ff       	jmp    803a66 <__udivdi3+0x46>
  803b2f:	90                   	nop

00803b30 <__umoddi3>:
  803b30:	55                   	push   %ebp
  803b31:	57                   	push   %edi
  803b32:	56                   	push   %esi
  803b33:	53                   	push   %ebx
  803b34:	83 ec 1c             	sub    $0x1c,%esp
  803b37:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803b3b:	8b 74 24 34          	mov    0x34(%esp),%esi
  803b3f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b43:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803b47:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803b4b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803b4f:	89 f3                	mov    %esi,%ebx
  803b51:	89 fa                	mov    %edi,%edx
  803b53:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803b57:	89 34 24             	mov    %esi,(%esp)
  803b5a:	85 c0                	test   %eax,%eax
  803b5c:	75 1a                	jne    803b78 <__umoddi3+0x48>
  803b5e:	39 f7                	cmp    %esi,%edi
  803b60:	0f 86 a2 00 00 00    	jbe    803c08 <__umoddi3+0xd8>
  803b66:	89 c8                	mov    %ecx,%eax
  803b68:	89 f2                	mov    %esi,%edx
  803b6a:	f7 f7                	div    %edi
  803b6c:	89 d0                	mov    %edx,%eax
  803b6e:	31 d2                	xor    %edx,%edx
  803b70:	83 c4 1c             	add    $0x1c,%esp
  803b73:	5b                   	pop    %ebx
  803b74:	5e                   	pop    %esi
  803b75:	5f                   	pop    %edi
  803b76:	5d                   	pop    %ebp
  803b77:	c3                   	ret    
  803b78:	39 f0                	cmp    %esi,%eax
  803b7a:	0f 87 ac 00 00 00    	ja     803c2c <__umoddi3+0xfc>
  803b80:	0f bd e8             	bsr    %eax,%ebp
  803b83:	83 f5 1f             	xor    $0x1f,%ebp
  803b86:	0f 84 ac 00 00 00    	je     803c38 <__umoddi3+0x108>
  803b8c:	bf 20 00 00 00       	mov    $0x20,%edi
  803b91:	29 ef                	sub    %ebp,%edi
  803b93:	89 fe                	mov    %edi,%esi
  803b95:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803b99:	89 e9                	mov    %ebp,%ecx
  803b9b:	d3 e0                	shl    %cl,%eax
  803b9d:	89 d7                	mov    %edx,%edi
  803b9f:	89 f1                	mov    %esi,%ecx
  803ba1:	d3 ef                	shr    %cl,%edi
  803ba3:	09 c7                	or     %eax,%edi
  803ba5:	89 e9                	mov    %ebp,%ecx
  803ba7:	d3 e2                	shl    %cl,%edx
  803ba9:	89 14 24             	mov    %edx,(%esp)
  803bac:	89 d8                	mov    %ebx,%eax
  803bae:	d3 e0                	shl    %cl,%eax
  803bb0:	89 c2                	mov    %eax,%edx
  803bb2:	8b 44 24 08          	mov    0x8(%esp),%eax
  803bb6:	d3 e0                	shl    %cl,%eax
  803bb8:	89 44 24 04          	mov    %eax,0x4(%esp)
  803bbc:	8b 44 24 08          	mov    0x8(%esp),%eax
  803bc0:	89 f1                	mov    %esi,%ecx
  803bc2:	d3 e8                	shr    %cl,%eax
  803bc4:	09 d0                	or     %edx,%eax
  803bc6:	d3 eb                	shr    %cl,%ebx
  803bc8:	89 da                	mov    %ebx,%edx
  803bca:	f7 f7                	div    %edi
  803bcc:	89 d3                	mov    %edx,%ebx
  803bce:	f7 24 24             	mull   (%esp)
  803bd1:	89 c6                	mov    %eax,%esi
  803bd3:	89 d1                	mov    %edx,%ecx
  803bd5:	39 d3                	cmp    %edx,%ebx
  803bd7:	0f 82 87 00 00 00    	jb     803c64 <__umoddi3+0x134>
  803bdd:	0f 84 91 00 00 00    	je     803c74 <__umoddi3+0x144>
  803be3:	8b 54 24 04          	mov    0x4(%esp),%edx
  803be7:	29 f2                	sub    %esi,%edx
  803be9:	19 cb                	sbb    %ecx,%ebx
  803beb:	89 d8                	mov    %ebx,%eax
  803bed:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803bf1:	d3 e0                	shl    %cl,%eax
  803bf3:	89 e9                	mov    %ebp,%ecx
  803bf5:	d3 ea                	shr    %cl,%edx
  803bf7:	09 d0                	or     %edx,%eax
  803bf9:	89 e9                	mov    %ebp,%ecx
  803bfb:	d3 eb                	shr    %cl,%ebx
  803bfd:	89 da                	mov    %ebx,%edx
  803bff:	83 c4 1c             	add    $0x1c,%esp
  803c02:	5b                   	pop    %ebx
  803c03:	5e                   	pop    %esi
  803c04:	5f                   	pop    %edi
  803c05:	5d                   	pop    %ebp
  803c06:	c3                   	ret    
  803c07:	90                   	nop
  803c08:	89 fd                	mov    %edi,%ebp
  803c0a:	85 ff                	test   %edi,%edi
  803c0c:	75 0b                	jne    803c19 <__umoddi3+0xe9>
  803c0e:	b8 01 00 00 00       	mov    $0x1,%eax
  803c13:	31 d2                	xor    %edx,%edx
  803c15:	f7 f7                	div    %edi
  803c17:	89 c5                	mov    %eax,%ebp
  803c19:	89 f0                	mov    %esi,%eax
  803c1b:	31 d2                	xor    %edx,%edx
  803c1d:	f7 f5                	div    %ebp
  803c1f:	89 c8                	mov    %ecx,%eax
  803c21:	f7 f5                	div    %ebp
  803c23:	89 d0                	mov    %edx,%eax
  803c25:	e9 44 ff ff ff       	jmp    803b6e <__umoddi3+0x3e>
  803c2a:	66 90                	xchg   %ax,%ax
  803c2c:	89 c8                	mov    %ecx,%eax
  803c2e:	89 f2                	mov    %esi,%edx
  803c30:	83 c4 1c             	add    $0x1c,%esp
  803c33:	5b                   	pop    %ebx
  803c34:	5e                   	pop    %esi
  803c35:	5f                   	pop    %edi
  803c36:	5d                   	pop    %ebp
  803c37:	c3                   	ret    
  803c38:	3b 04 24             	cmp    (%esp),%eax
  803c3b:	72 06                	jb     803c43 <__umoddi3+0x113>
  803c3d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803c41:	77 0f                	ja     803c52 <__umoddi3+0x122>
  803c43:	89 f2                	mov    %esi,%edx
  803c45:	29 f9                	sub    %edi,%ecx
  803c47:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803c4b:	89 14 24             	mov    %edx,(%esp)
  803c4e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c52:	8b 44 24 04          	mov    0x4(%esp),%eax
  803c56:	8b 14 24             	mov    (%esp),%edx
  803c59:	83 c4 1c             	add    $0x1c,%esp
  803c5c:	5b                   	pop    %ebx
  803c5d:	5e                   	pop    %esi
  803c5e:	5f                   	pop    %edi
  803c5f:	5d                   	pop    %ebp
  803c60:	c3                   	ret    
  803c61:	8d 76 00             	lea    0x0(%esi),%esi
  803c64:	2b 04 24             	sub    (%esp),%eax
  803c67:	19 fa                	sbb    %edi,%edx
  803c69:	89 d1                	mov    %edx,%ecx
  803c6b:	89 c6                	mov    %eax,%esi
  803c6d:	e9 71 ff ff ff       	jmp    803be3 <__umoddi3+0xb3>
  803c72:	66 90                	xchg   %ax,%ax
  803c74:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803c78:	72 ea                	jb     803c64 <__umoddi3+0x134>
  803c7a:	89 d9                	mov    %ebx,%ecx
  803c7c:	e9 62 ff ff ff       	jmp    803be3 <__umoddi3+0xb3>
