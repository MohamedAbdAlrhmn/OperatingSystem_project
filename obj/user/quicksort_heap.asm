
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
  800041:	e8 27 1f 00 00       	call   801f6d <sys_disable_interrupt>
		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 c0 3c 80 00       	push   $0x803cc0
  80004e:	e8 f2 09 00 00       	call   800a45 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 c2 3c 80 00       	push   $0x803cc2
  80005e:	e8 e2 09 00 00       	call   800a45 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!   QUICK SORT   !!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 db 3c 80 00       	push   $0x803cdb
  80006e:	e8 d2 09 00 00       	call   800a45 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 c2 3c 80 00       	push   $0x803cc2
  80007e:	e8 c2 09 00 00       	call   800a45 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 c0 3c 80 00       	push   $0x803cc0
  80008e:	e8 b2 09 00 00       	call   800a45 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp

		readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 f4 3c 80 00       	push   $0x803cf4
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
  8000de:	68 14 3d 80 00       	push   $0x803d14
  8000e3:	e8 5d 09 00 00       	call   800a45 <cprintf>
  8000e8:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000eb:	83 ec 0c             	sub    $0xc,%esp
  8000ee:	68 36 3d 80 00       	push   $0x803d36
  8000f3:	e8 4d 09 00 00       	call   800a45 <cprintf>
  8000f8:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000fb:	83 ec 0c             	sub    $0xc,%esp
  8000fe:	68 44 3d 80 00       	push   $0x803d44
  800103:	e8 3d 09 00 00       	call   800a45 <cprintf>
  800108:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 53 3d 80 00       	push   $0x803d53
  800113:	e8 2d 09 00 00       	call   800a45 <cprintf>
  800118:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	68 63 3d 80 00       	push   $0x803d63
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
  800162:	e8 20 1e 00 00       	call   801f87 <sys_enable_interrupt>

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
  8001d5:	e8 93 1d 00 00       	call   801f6d <sys_disable_interrupt>
			cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001da:	83 ec 0c             	sub    $0xc,%esp
  8001dd:	68 6c 3d 80 00       	push   $0x803d6c
  8001e2:	e8 5e 08 00 00       	call   800a45 <cprintf>
  8001e7:	83 c4 10             	add    $0x10,%esp
		//		PrintElements(Elements, NumOfElements);
		sys_enable_interrupt();
  8001ea:	e8 98 1d 00 00       	call   801f87 <sys_enable_interrupt>

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
  80020c:	68 a0 3d 80 00       	push   $0x803da0
  800211:	6a 48                	push   $0x48
  800213:	68 c2 3d 80 00       	push   $0x803dc2
  800218:	e8 74 05 00 00       	call   800791 <_panic>
		else
		{
			sys_disable_interrupt();
  80021d:	e8 4b 1d 00 00       	call   801f6d <sys_disable_interrupt>
			cprintf("\n===============================================\n") ;
  800222:	83 ec 0c             	sub    $0xc,%esp
  800225:	68 d8 3d 80 00       	push   $0x803dd8
  80022a:	e8 16 08 00 00       	call   800a45 <cprintf>
  80022f:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  800232:	83 ec 0c             	sub    $0xc,%esp
  800235:	68 0c 3e 80 00       	push   $0x803e0c
  80023a:	e8 06 08 00 00       	call   800a45 <cprintf>
  80023f:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  800242:	83 ec 0c             	sub    $0xc,%esp
  800245:	68 40 3e 80 00       	push   $0x803e40
  80024a:	e8 f6 07 00 00       	call   800a45 <cprintf>
  80024f:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800252:	e8 30 1d 00 00       	call   801f87 <sys_enable_interrupt>
		}

		sys_disable_interrupt();
  800257:	e8 11 1d 00 00       	call   801f6d <sys_disable_interrupt>
			Chose = 0 ;
  80025c:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800260:	eb 42                	jmp    8002a4 <_main+0x26c>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800262:	83 ec 0c             	sub    $0xc,%esp
  800265:	68 72 3e 80 00       	push   $0x803e72
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
  8002b0:	e8 d2 1c 00 00       	call   801f87 <sys_enable_interrupt>

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
  800555:	68 c0 3c 80 00       	push   $0x803cc0
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
  800577:	68 90 3e 80 00       	push   $0x803e90
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
  8005a5:	68 95 3e 80 00       	push   $0x803e95
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
  8005c9:	e8 d3 19 00 00       	call   801fa1 <sys_cputc>
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
  8005da:	e8 8e 19 00 00       	call   801f6d <sys_disable_interrupt>
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
  8005ed:	e8 af 19 00 00       	call   801fa1 <sys_cputc>
  8005f2:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8005f5:	e8 8d 19 00 00       	call   801f87 <sys_enable_interrupt>
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
  80060c:	e8 d7 17 00 00       	call   801de8 <sys_cgetc>
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
  800625:	e8 43 19 00 00       	call   801f6d <sys_disable_interrupt>
	int c=0;
  80062a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800631:	eb 08                	jmp    80063b <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  800633:	e8 b0 17 00 00       	call   801de8 <sys_cgetc>
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
  800641:	e8 41 19 00 00       	call   801f87 <sys_enable_interrupt>
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
  80065b:	e8 00 1b 00 00       	call   802160 <sys_getenvindex>
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
  8006c6:	e8 a2 18 00 00       	call   801f6d <sys_disable_interrupt>
	cprintf("**************************************\n");
  8006cb:	83 ec 0c             	sub    $0xc,%esp
  8006ce:	68 b4 3e 80 00       	push   $0x803eb4
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
  8006f6:	68 dc 3e 80 00       	push   $0x803edc
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
  800727:	68 04 3f 80 00       	push   $0x803f04
  80072c:	e8 14 03 00 00       	call   800a45 <cprintf>
  800731:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800734:	a1 24 50 80 00       	mov    0x805024,%eax
  800739:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80073f:	83 ec 08             	sub    $0x8,%esp
  800742:	50                   	push   %eax
  800743:	68 5c 3f 80 00       	push   $0x803f5c
  800748:	e8 f8 02 00 00       	call   800a45 <cprintf>
  80074d:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800750:	83 ec 0c             	sub    $0xc,%esp
  800753:	68 b4 3e 80 00       	push   $0x803eb4
  800758:	e8 e8 02 00 00       	call   800a45 <cprintf>
  80075d:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800760:	e8 22 18 00 00       	call   801f87 <sys_enable_interrupt>

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
  800778:	e8 af 19 00 00       	call   80212c <sys_destroy_env>
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
  800789:	e8 04 1a 00 00       	call   802192 <sys_exit_env>
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
  8007b2:	68 70 3f 80 00       	push   $0x803f70
  8007b7:	e8 89 02 00 00       	call   800a45 <cprintf>
  8007bc:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8007bf:	a1 00 50 80 00       	mov    0x805000,%eax
  8007c4:	ff 75 0c             	pushl  0xc(%ebp)
  8007c7:	ff 75 08             	pushl  0x8(%ebp)
  8007ca:	50                   	push   %eax
  8007cb:	68 75 3f 80 00       	push   $0x803f75
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
  8007ef:	68 91 3f 80 00       	push   $0x803f91
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
  80081b:	68 94 3f 80 00       	push   $0x803f94
  800820:	6a 26                	push   $0x26
  800822:	68 e0 3f 80 00       	push   $0x803fe0
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
  8008ed:	68 ec 3f 80 00       	push   $0x803fec
  8008f2:	6a 3a                	push   $0x3a
  8008f4:	68 e0 3f 80 00       	push   $0x803fe0
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
  80095d:	68 40 40 80 00       	push   $0x804040
  800962:	6a 44                	push   $0x44
  800964:	68 e0 3f 80 00       	push   $0x803fe0
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
  8009b7:	e8 03 14 00 00       	call   801dbf <sys_cputs>
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
  800a2e:	e8 8c 13 00 00       	call   801dbf <sys_cputs>
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
  800a78:	e8 f0 14 00 00       	call   801f6d <sys_disable_interrupt>
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
  800a98:	e8 ea 14 00 00       	call   801f87 <sys_enable_interrupt>
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
  800ae2:	e8 5d 2f 00 00       	call   803a44 <__udivdi3>
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
  800b32:	e8 1d 30 00 00       	call   803b54 <__umoddi3>
  800b37:	83 c4 10             	add    $0x10,%esp
  800b3a:	05 b4 42 80 00       	add    $0x8042b4,%eax
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
  800c8d:	8b 04 85 d8 42 80 00 	mov    0x8042d8(,%eax,4),%eax
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
  800d6e:	8b 34 9d 20 41 80 00 	mov    0x804120(,%ebx,4),%esi
  800d75:	85 f6                	test   %esi,%esi
  800d77:	75 19                	jne    800d92 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d79:	53                   	push   %ebx
  800d7a:	68 c5 42 80 00       	push   $0x8042c5
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
  800d93:	68 ce 42 80 00       	push   $0x8042ce
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
  800dc0:	be d1 42 80 00       	mov    $0x8042d1,%esi
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
  8010d9:	68 30 44 80 00       	push   $0x804430
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
  80111b:	68 33 44 80 00       	push   $0x804433
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
  8011cb:	e8 9d 0d 00 00       	call   801f6d <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  8011d0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011d4:	74 13                	je     8011e9 <atomic_readline+0x24>
		cprintf("%s", prompt);
  8011d6:	83 ec 08             	sub    $0x8,%esp
  8011d9:	ff 75 08             	pushl  0x8(%ebp)
  8011dc:	68 30 44 80 00       	push   $0x804430
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
  80121a:	68 33 44 80 00       	push   $0x804433
  80121f:	e8 21 f8 ff ff       	call   800a45 <cprintf>
  801224:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  801227:	e8 5b 0d 00 00       	call   801f87 <sys_enable_interrupt>
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
  8012bf:	e8 c3 0c 00 00       	call   801f87 <sys_enable_interrupt>
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
  8019ec:	68 44 44 80 00       	push   $0x804444
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
  801abc:	e8 42 04 00 00       	call   801f03 <sys_allocate_chunk>
  801ac1:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801ac4:	a1 20 51 80 00       	mov    0x805120,%eax
  801ac9:	83 ec 0c             	sub    $0xc,%esp
  801acc:	50                   	push   %eax
  801acd:	e8 b7 0a 00 00       	call   802589 <initialize_MemBlocksList>
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
  801afa:	68 69 44 80 00       	push   $0x804469
  801aff:	6a 33                	push   $0x33
  801b01:	68 87 44 80 00       	push   $0x804487
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
  801b79:	68 94 44 80 00       	push   $0x804494
  801b7e:	6a 34                	push   $0x34
  801b80:	68 87 44 80 00       	push   $0x804487
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
  801bee:	68 b8 44 80 00       	push   $0x8044b8
  801bf3:	6a 46                	push   $0x46
  801bf5:	68 87 44 80 00       	push   $0x804487
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
  801c0a:	68 e0 44 80 00       	push   $0x8044e0
  801c0f:	6a 61                	push   $0x61
  801c11:	68 87 44 80 00       	push   $0x804487
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
  801c30:	75 0a                	jne    801c3c <smalloc+0x21>
  801c32:	b8 00 00 00 00       	mov    $0x0,%eax
  801c37:	e9 9e 00 00 00       	jmp    801cda <smalloc+0xbf>
	//3-If the Kernel successfully creates the shared variable, return its virtual address
	//4-Else, return NULL



	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801c3c:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801c43:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c49:	01 d0                	add    %edx,%eax
  801c4b:	48                   	dec    %eax
  801c4c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801c4f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c52:	ba 00 00 00 00       	mov    $0x0,%edx
  801c57:	f7 75 f0             	divl   -0x10(%ebp)
  801c5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c5d:	29 d0                	sub    %edx,%eax
  801c5f:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801c62:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801c69:	e8 63 06 00 00       	call   8022d1 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801c6e:	85 c0                	test   %eax,%eax
  801c70:	74 11                	je     801c83 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  801c72:	83 ec 0c             	sub    $0xc,%esp
  801c75:	ff 75 e8             	pushl  -0x18(%ebp)
  801c78:	e8 ce 0c 00 00       	call   80294b <alloc_block_FF>
  801c7d:	83 c4 10             	add    $0x10,%esp
  801c80:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  801c83:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c87:	74 4c                	je     801cd5 <smalloc+0xba>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801c89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c8c:	8b 40 08             	mov    0x8(%eax),%eax
  801c8f:	89 c2                	mov    %eax,%edx
  801c91:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801c95:	52                   	push   %edx
  801c96:	50                   	push   %eax
  801c97:	ff 75 0c             	pushl  0xc(%ebp)
  801c9a:	ff 75 08             	pushl  0x8(%ebp)
  801c9d:	e8 b4 03 00 00       	call   802056 <sys_createSharedObject>
  801ca2:	83 c4 10             	add    $0x10,%esp
  801ca5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cprintf("Output is :  %d \n" , result);
  801ca8:	83 ec 08             	sub    $0x8,%esp
  801cab:	ff 75 e0             	pushl  -0x20(%ebp)
  801cae:	68 03 45 80 00       	push   $0x804503
  801cb3:	e8 8d ed ff ff       	call   800a45 <cprintf>
  801cb8:	83 c4 10             	add    $0x10,%esp
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  801cbb:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  801cbf:	74 14                	je     801cd5 <smalloc+0xba>
  801cc1:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  801cc5:	74 0e                	je     801cd5 <smalloc+0xba>
  801cc7:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  801ccb:	74 08                	je     801cd5 <smalloc+0xba>
			return (void*) mem_block->sva;
  801ccd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cd0:	8b 40 08             	mov    0x8(%eax),%eax
  801cd3:	eb 05                	jmp    801cda <smalloc+0xbf>
	}
	return NULL;
  801cd5:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801cda:	c9                   	leave  
  801cdb:	c3                   	ret    

00801cdc <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801cdc:	55                   	push   %ebp
  801cdd:	89 e5                	mov    %esp,%ebp
  801cdf:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801ce2:	e8 ee fc ff ff       	call   8019d5 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801ce7:	83 ec 04             	sub    $0x4,%esp
  801cea:	68 18 45 80 00       	push   $0x804518
  801cef:	68 ab 00 00 00       	push   $0xab
  801cf4:	68 87 44 80 00       	push   $0x804487
  801cf9:	e8 93 ea ff ff       	call   800791 <_panic>

00801cfe <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801cfe:	55                   	push   %ebp
  801cff:	89 e5                	mov    %esp,%ebp
  801d01:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801d04:	e8 cc fc ff ff       	call   8019d5 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801d09:	83 ec 04             	sub    $0x4,%esp
  801d0c:	68 3c 45 80 00       	push   $0x80453c
  801d11:	68 ef 00 00 00       	push   $0xef
  801d16:	68 87 44 80 00       	push   $0x804487
  801d1b:	e8 71 ea ff ff       	call   800791 <_panic>

00801d20 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801d20:	55                   	push   %ebp
  801d21:	89 e5                	mov    %esp,%ebp
  801d23:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801d26:	83 ec 04             	sub    $0x4,%esp
  801d29:	68 64 45 80 00       	push   $0x804564
  801d2e:	68 03 01 00 00       	push   $0x103
  801d33:	68 87 44 80 00       	push   $0x804487
  801d38:	e8 54 ea ff ff       	call   800791 <_panic>

00801d3d <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801d3d:	55                   	push   %ebp
  801d3e:	89 e5                	mov    %esp,%ebp
  801d40:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801d43:	83 ec 04             	sub    $0x4,%esp
  801d46:	68 88 45 80 00       	push   $0x804588
  801d4b:	68 0e 01 00 00       	push   $0x10e
  801d50:	68 87 44 80 00       	push   $0x804487
  801d55:	e8 37 ea ff ff       	call   800791 <_panic>

00801d5a <shrink>:

}
void shrink(uint32 newSize)
{
  801d5a:	55                   	push   %ebp
  801d5b:	89 e5                	mov    %esp,%ebp
  801d5d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801d60:	83 ec 04             	sub    $0x4,%esp
  801d63:	68 88 45 80 00       	push   $0x804588
  801d68:	68 13 01 00 00       	push   $0x113
  801d6d:	68 87 44 80 00       	push   $0x804487
  801d72:	e8 1a ea ff ff       	call   800791 <_panic>

00801d77 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801d77:	55                   	push   %ebp
  801d78:	89 e5                	mov    %esp,%ebp
  801d7a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801d7d:	83 ec 04             	sub    $0x4,%esp
  801d80:	68 88 45 80 00       	push   $0x804588
  801d85:	68 18 01 00 00       	push   $0x118
  801d8a:	68 87 44 80 00       	push   $0x804487
  801d8f:	e8 fd e9 ff ff       	call   800791 <_panic>

00801d94 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801d94:	55                   	push   %ebp
  801d95:	89 e5                	mov    %esp,%ebp
  801d97:	57                   	push   %edi
  801d98:	56                   	push   %esi
  801d99:	53                   	push   %ebx
  801d9a:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801da0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801da3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801da6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801da9:	8b 7d 18             	mov    0x18(%ebp),%edi
  801dac:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801daf:	cd 30                	int    $0x30
  801db1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801db4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801db7:	83 c4 10             	add    $0x10,%esp
  801dba:	5b                   	pop    %ebx
  801dbb:	5e                   	pop    %esi
  801dbc:	5f                   	pop    %edi
  801dbd:	5d                   	pop    %ebp
  801dbe:	c3                   	ret    

00801dbf <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801dbf:	55                   	push   %ebp
  801dc0:	89 e5                	mov    %esp,%ebp
  801dc2:	83 ec 04             	sub    $0x4,%esp
  801dc5:	8b 45 10             	mov    0x10(%ebp),%eax
  801dc8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801dcb:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801dcf:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd2:	6a 00                	push   $0x0
  801dd4:	6a 00                	push   $0x0
  801dd6:	52                   	push   %edx
  801dd7:	ff 75 0c             	pushl  0xc(%ebp)
  801dda:	50                   	push   %eax
  801ddb:	6a 00                	push   $0x0
  801ddd:	e8 b2 ff ff ff       	call   801d94 <syscall>
  801de2:	83 c4 18             	add    $0x18,%esp
}
  801de5:	90                   	nop
  801de6:	c9                   	leave  
  801de7:	c3                   	ret    

00801de8 <sys_cgetc>:

int
sys_cgetc(void)
{
  801de8:	55                   	push   %ebp
  801de9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801deb:	6a 00                	push   $0x0
  801ded:	6a 00                	push   $0x0
  801def:	6a 00                	push   $0x0
  801df1:	6a 00                	push   $0x0
  801df3:	6a 00                	push   $0x0
  801df5:	6a 01                	push   $0x1
  801df7:	e8 98 ff ff ff       	call   801d94 <syscall>
  801dfc:	83 c4 18             	add    $0x18,%esp
}
  801dff:	c9                   	leave  
  801e00:	c3                   	ret    

00801e01 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801e01:	55                   	push   %ebp
  801e02:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801e04:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e07:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0a:	6a 00                	push   $0x0
  801e0c:	6a 00                	push   $0x0
  801e0e:	6a 00                	push   $0x0
  801e10:	52                   	push   %edx
  801e11:	50                   	push   %eax
  801e12:	6a 05                	push   $0x5
  801e14:	e8 7b ff ff ff       	call   801d94 <syscall>
  801e19:	83 c4 18             	add    $0x18,%esp
}
  801e1c:	c9                   	leave  
  801e1d:	c3                   	ret    

00801e1e <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801e1e:	55                   	push   %ebp
  801e1f:	89 e5                	mov    %esp,%ebp
  801e21:	56                   	push   %esi
  801e22:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801e23:	8b 75 18             	mov    0x18(%ebp),%esi
  801e26:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e29:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e2c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e32:	56                   	push   %esi
  801e33:	53                   	push   %ebx
  801e34:	51                   	push   %ecx
  801e35:	52                   	push   %edx
  801e36:	50                   	push   %eax
  801e37:	6a 06                	push   $0x6
  801e39:	e8 56 ff ff ff       	call   801d94 <syscall>
  801e3e:	83 c4 18             	add    $0x18,%esp
}
  801e41:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e44:	5b                   	pop    %ebx
  801e45:	5e                   	pop    %esi
  801e46:	5d                   	pop    %ebp
  801e47:	c3                   	ret    

00801e48 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801e48:	55                   	push   %ebp
  801e49:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801e4b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e51:	6a 00                	push   $0x0
  801e53:	6a 00                	push   $0x0
  801e55:	6a 00                	push   $0x0
  801e57:	52                   	push   %edx
  801e58:	50                   	push   %eax
  801e59:	6a 07                	push   $0x7
  801e5b:	e8 34 ff ff ff       	call   801d94 <syscall>
  801e60:	83 c4 18             	add    $0x18,%esp
}
  801e63:	c9                   	leave  
  801e64:	c3                   	ret    

00801e65 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801e65:	55                   	push   %ebp
  801e66:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801e68:	6a 00                	push   $0x0
  801e6a:	6a 00                	push   $0x0
  801e6c:	6a 00                	push   $0x0
  801e6e:	ff 75 0c             	pushl  0xc(%ebp)
  801e71:	ff 75 08             	pushl  0x8(%ebp)
  801e74:	6a 08                	push   $0x8
  801e76:	e8 19 ff ff ff       	call   801d94 <syscall>
  801e7b:	83 c4 18             	add    $0x18,%esp
}
  801e7e:	c9                   	leave  
  801e7f:	c3                   	ret    

00801e80 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801e80:	55                   	push   %ebp
  801e81:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801e83:	6a 00                	push   $0x0
  801e85:	6a 00                	push   $0x0
  801e87:	6a 00                	push   $0x0
  801e89:	6a 00                	push   $0x0
  801e8b:	6a 00                	push   $0x0
  801e8d:	6a 09                	push   $0x9
  801e8f:	e8 00 ff ff ff       	call   801d94 <syscall>
  801e94:	83 c4 18             	add    $0x18,%esp
}
  801e97:	c9                   	leave  
  801e98:	c3                   	ret    

00801e99 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801e99:	55                   	push   %ebp
  801e9a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801e9c:	6a 00                	push   $0x0
  801e9e:	6a 00                	push   $0x0
  801ea0:	6a 00                	push   $0x0
  801ea2:	6a 00                	push   $0x0
  801ea4:	6a 00                	push   $0x0
  801ea6:	6a 0a                	push   $0xa
  801ea8:	e8 e7 fe ff ff       	call   801d94 <syscall>
  801ead:	83 c4 18             	add    $0x18,%esp
}
  801eb0:	c9                   	leave  
  801eb1:	c3                   	ret    

00801eb2 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801eb2:	55                   	push   %ebp
  801eb3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801eb5:	6a 00                	push   $0x0
  801eb7:	6a 00                	push   $0x0
  801eb9:	6a 00                	push   $0x0
  801ebb:	6a 00                	push   $0x0
  801ebd:	6a 00                	push   $0x0
  801ebf:	6a 0b                	push   $0xb
  801ec1:	e8 ce fe ff ff       	call   801d94 <syscall>
  801ec6:	83 c4 18             	add    $0x18,%esp
}
  801ec9:	c9                   	leave  
  801eca:	c3                   	ret    

00801ecb <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801ecb:	55                   	push   %ebp
  801ecc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801ece:	6a 00                	push   $0x0
  801ed0:	6a 00                	push   $0x0
  801ed2:	6a 00                	push   $0x0
  801ed4:	ff 75 0c             	pushl  0xc(%ebp)
  801ed7:	ff 75 08             	pushl  0x8(%ebp)
  801eda:	6a 0f                	push   $0xf
  801edc:	e8 b3 fe ff ff       	call   801d94 <syscall>
  801ee1:	83 c4 18             	add    $0x18,%esp
	return;
  801ee4:	90                   	nop
}
  801ee5:	c9                   	leave  
  801ee6:	c3                   	ret    

00801ee7 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801ee7:	55                   	push   %ebp
  801ee8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801eea:	6a 00                	push   $0x0
  801eec:	6a 00                	push   $0x0
  801eee:	6a 00                	push   $0x0
  801ef0:	ff 75 0c             	pushl  0xc(%ebp)
  801ef3:	ff 75 08             	pushl  0x8(%ebp)
  801ef6:	6a 10                	push   $0x10
  801ef8:	e8 97 fe ff ff       	call   801d94 <syscall>
  801efd:	83 c4 18             	add    $0x18,%esp
	return ;
  801f00:	90                   	nop
}
  801f01:	c9                   	leave  
  801f02:	c3                   	ret    

00801f03 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801f03:	55                   	push   %ebp
  801f04:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801f06:	6a 00                	push   $0x0
  801f08:	6a 00                	push   $0x0
  801f0a:	ff 75 10             	pushl  0x10(%ebp)
  801f0d:	ff 75 0c             	pushl  0xc(%ebp)
  801f10:	ff 75 08             	pushl  0x8(%ebp)
  801f13:	6a 11                	push   $0x11
  801f15:	e8 7a fe ff ff       	call   801d94 <syscall>
  801f1a:	83 c4 18             	add    $0x18,%esp
	return ;
  801f1d:	90                   	nop
}
  801f1e:	c9                   	leave  
  801f1f:	c3                   	ret    

00801f20 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801f20:	55                   	push   %ebp
  801f21:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801f23:	6a 00                	push   $0x0
  801f25:	6a 00                	push   $0x0
  801f27:	6a 00                	push   $0x0
  801f29:	6a 00                	push   $0x0
  801f2b:	6a 00                	push   $0x0
  801f2d:	6a 0c                	push   $0xc
  801f2f:	e8 60 fe ff ff       	call   801d94 <syscall>
  801f34:	83 c4 18             	add    $0x18,%esp
}
  801f37:	c9                   	leave  
  801f38:	c3                   	ret    

00801f39 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801f39:	55                   	push   %ebp
  801f3a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801f3c:	6a 00                	push   $0x0
  801f3e:	6a 00                	push   $0x0
  801f40:	6a 00                	push   $0x0
  801f42:	6a 00                	push   $0x0
  801f44:	ff 75 08             	pushl  0x8(%ebp)
  801f47:	6a 0d                	push   $0xd
  801f49:	e8 46 fe ff ff       	call   801d94 <syscall>
  801f4e:	83 c4 18             	add    $0x18,%esp
}
  801f51:	c9                   	leave  
  801f52:	c3                   	ret    

00801f53 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801f53:	55                   	push   %ebp
  801f54:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801f56:	6a 00                	push   $0x0
  801f58:	6a 00                	push   $0x0
  801f5a:	6a 00                	push   $0x0
  801f5c:	6a 00                	push   $0x0
  801f5e:	6a 00                	push   $0x0
  801f60:	6a 0e                	push   $0xe
  801f62:	e8 2d fe ff ff       	call   801d94 <syscall>
  801f67:	83 c4 18             	add    $0x18,%esp
}
  801f6a:	90                   	nop
  801f6b:	c9                   	leave  
  801f6c:	c3                   	ret    

00801f6d <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801f6d:	55                   	push   %ebp
  801f6e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801f70:	6a 00                	push   $0x0
  801f72:	6a 00                	push   $0x0
  801f74:	6a 00                	push   $0x0
  801f76:	6a 00                	push   $0x0
  801f78:	6a 00                	push   $0x0
  801f7a:	6a 13                	push   $0x13
  801f7c:	e8 13 fe ff ff       	call   801d94 <syscall>
  801f81:	83 c4 18             	add    $0x18,%esp
}
  801f84:	90                   	nop
  801f85:	c9                   	leave  
  801f86:	c3                   	ret    

00801f87 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801f87:	55                   	push   %ebp
  801f88:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801f8a:	6a 00                	push   $0x0
  801f8c:	6a 00                	push   $0x0
  801f8e:	6a 00                	push   $0x0
  801f90:	6a 00                	push   $0x0
  801f92:	6a 00                	push   $0x0
  801f94:	6a 14                	push   $0x14
  801f96:	e8 f9 fd ff ff       	call   801d94 <syscall>
  801f9b:	83 c4 18             	add    $0x18,%esp
}
  801f9e:	90                   	nop
  801f9f:	c9                   	leave  
  801fa0:	c3                   	ret    

00801fa1 <sys_cputc>:


void
sys_cputc(const char c)
{
  801fa1:	55                   	push   %ebp
  801fa2:	89 e5                	mov    %esp,%ebp
  801fa4:	83 ec 04             	sub    $0x4,%esp
  801fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  801faa:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801fad:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801fb1:	6a 00                	push   $0x0
  801fb3:	6a 00                	push   $0x0
  801fb5:	6a 00                	push   $0x0
  801fb7:	6a 00                	push   $0x0
  801fb9:	50                   	push   %eax
  801fba:	6a 15                	push   $0x15
  801fbc:	e8 d3 fd ff ff       	call   801d94 <syscall>
  801fc1:	83 c4 18             	add    $0x18,%esp
}
  801fc4:	90                   	nop
  801fc5:	c9                   	leave  
  801fc6:	c3                   	ret    

00801fc7 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801fc7:	55                   	push   %ebp
  801fc8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801fca:	6a 00                	push   $0x0
  801fcc:	6a 00                	push   $0x0
  801fce:	6a 00                	push   $0x0
  801fd0:	6a 00                	push   $0x0
  801fd2:	6a 00                	push   $0x0
  801fd4:	6a 16                	push   $0x16
  801fd6:	e8 b9 fd ff ff       	call   801d94 <syscall>
  801fdb:	83 c4 18             	add    $0x18,%esp
}
  801fde:	90                   	nop
  801fdf:	c9                   	leave  
  801fe0:	c3                   	ret    

00801fe1 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801fe1:	55                   	push   %ebp
  801fe2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801fe4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe7:	6a 00                	push   $0x0
  801fe9:	6a 00                	push   $0x0
  801feb:	6a 00                	push   $0x0
  801fed:	ff 75 0c             	pushl  0xc(%ebp)
  801ff0:	50                   	push   %eax
  801ff1:	6a 17                	push   $0x17
  801ff3:	e8 9c fd ff ff       	call   801d94 <syscall>
  801ff8:	83 c4 18             	add    $0x18,%esp
}
  801ffb:	c9                   	leave  
  801ffc:	c3                   	ret    

00801ffd <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801ffd:	55                   	push   %ebp
  801ffe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802000:	8b 55 0c             	mov    0xc(%ebp),%edx
  802003:	8b 45 08             	mov    0x8(%ebp),%eax
  802006:	6a 00                	push   $0x0
  802008:	6a 00                	push   $0x0
  80200a:	6a 00                	push   $0x0
  80200c:	52                   	push   %edx
  80200d:	50                   	push   %eax
  80200e:	6a 1a                	push   $0x1a
  802010:	e8 7f fd ff ff       	call   801d94 <syscall>
  802015:	83 c4 18             	add    $0x18,%esp
}
  802018:	c9                   	leave  
  802019:	c3                   	ret    

0080201a <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80201a:	55                   	push   %ebp
  80201b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80201d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802020:	8b 45 08             	mov    0x8(%ebp),%eax
  802023:	6a 00                	push   $0x0
  802025:	6a 00                	push   $0x0
  802027:	6a 00                	push   $0x0
  802029:	52                   	push   %edx
  80202a:	50                   	push   %eax
  80202b:	6a 18                	push   $0x18
  80202d:	e8 62 fd ff ff       	call   801d94 <syscall>
  802032:	83 c4 18             	add    $0x18,%esp
}
  802035:	90                   	nop
  802036:	c9                   	leave  
  802037:	c3                   	ret    

00802038 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802038:	55                   	push   %ebp
  802039:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80203b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80203e:	8b 45 08             	mov    0x8(%ebp),%eax
  802041:	6a 00                	push   $0x0
  802043:	6a 00                	push   $0x0
  802045:	6a 00                	push   $0x0
  802047:	52                   	push   %edx
  802048:	50                   	push   %eax
  802049:	6a 19                	push   $0x19
  80204b:	e8 44 fd ff ff       	call   801d94 <syscall>
  802050:	83 c4 18             	add    $0x18,%esp
}
  802053:	90                   	nop
  802054:	c9                   	leave  
  802055:	c3                   	ret    

00802056 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802056:	55                   	push   %ebp
  802057:	89 e5                	mov    %esp,%ebp
  802059:	83 ec 04             	sub    $0x4,%esp
  80205c:	8b 45 10             	mov    0x10(%ebp),%eax
  80205f:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802062:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802065:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802069:	8b 45 08             	mov    0x8(%ebp),%eax
  80206c:	6a 00                	push   $0x0
  80206e:	51                   	push   %ecx
  80206f:	52                   	push   %edx
  802070:	ff 75 0c             	pushl  0xc(%ebp)
  802073:	50                   	push   %eax
  802074:	6a 1b                	push   $0x1b
  802076:	e8 19 fd ff ff       	call   801d94 <syscall>
  80207b:	83 c4 18             	add    $0x18,%esp
}
  80207e:	c9                   	leave  
  80207f:	c3                   	ret    

00802080 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802080:	55                   	push   %ebp
  802081:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802083:	8b 55 0c             	mov    0xc(%ebp),%edx
  802086:	8b 45 08             	mov    0x8(%ebp),%eax
  802089:	6a 00                	push   $0x0
  80208b:	6a 00                	push   $0x0
  80208d:	6a 00                	push   $0x0
  80208f:	52                   	push   %edx
  802090:	50                   	push   %eax
  802091:	6a 1c                	push   $0x1c
  802093:	e8 fc fc ff ff       	call   801d94 <syscall>
  802098:	83 c4 18             	add    $0x18,%esp
}
  80209b:	c9                   	leave  
  80209c:	c3                   	ret    

0080209d <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80209d:	55                   	push   %ebp
  80209e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8020a0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a9:	6a 00                	push   $0x0
  8020ab:	6a 00                	push   $0x0
  8020ad:	51                   	push   %ecx
  8020ae:	52                   	push   %edx
  8020af:	50                   	push   %eax
  8020b0:	6a 1d                	push   $0x1d
  8020b2:	e8 dd fc ff ff       	call   801d94 <syscall>
  8020b7:	83 c4 18             	add    $0x18,%esp
}
  8020ba:	c9                   	leave  
  8020bb:	c3                   	ret    

008020bc <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8020bc:	55                   	push   %ebp
  8020bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8020bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c5:	6a 00                	push   $0x0
  8020c7:	6a 00                	push   $0x0
  8020c9:	6a 00                	push   $0x0
  8020cb:	52                   	push   %edx
  8020cc:	50                   	push   %eax
  8020cd:	6a 1e                	push   $0x1e
  8020cf:	e8 c0 fc ff ff       	call   801d94 <syscall>
  8020d4:	83 c4 18             	add    $0x18,%esp
}
  8020d7:	c9                   	leave  
  8020d8:	c3                   	ret    

008020d9 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8020d9:	55                   	push   %ebp
  8020da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8020dc:	6a 00                	push   $0x0
  8020de:	6a 00                	push   $0x0
  8020e0:	6a 00                	push   $0x0
  8020e2:	6a 00                	push   $0x0
  8020e4:	6a 00                	push   $0x0
  8020e6:	6a 1f                	push   $0x1f
  8020e8:	e8 a7 fc ff ff       	call   801d94 <syscall>
  8020ed:	83 c4 18             	add    $0x18,%esp
}
  8020f0:	c9                   	leave  
  8020f1:	c3                   	ret    

008020f2 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8020f2:	55                   	push   %ebp
  8020f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8020f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f8:	6a 00                	push   $0x0
  8020fa:	ff 75 14             	pushl  0x14(%ebp)
  8020fd:	ff 75 10             	pushl  0x10(%ebp)
  802100:	ff 75 0c             	pushl  0xc(%ebp)
  802103:	50                   	push   %eax
  802104:	6a 20                	push   $0x20
  802106:	e8 89 fc ff ff       	call   801d94 <syscall>
  80210b:	83 c4 18             	add    $0x18,%esp
}
  80210e:	c9                   	leave  
  80210f:	c3                   	ret    

00802110 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802110:	55                   	push   %ebp
  802111:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802113:	8b 45 08             	mov    0x8(%ebp),%eax
  802116:	6a 00                	push   $0x0
  802118:	6a 00                	push   $0x0
  80211a:	6a 00                	push   $0x0
  80211c:	6a 00                	push   $0x0
  80211e:	50                   	push   %eax
  80211f:	6a 21                	push   $0x21
  802121:	e8 6e fc ff ff       	call   801d94 <syscall>
  802126:	83 c4 18             	add    $0x18,%esp
}
  802129:	90                   	nop
  80212a:	c9                   	leave  
  80212b:	c3                   	ret    

0080212c <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80212c:	55                   	push   %ebp
  80212d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80212f:	8b 45 08             	mov    0x8(%ebp),%eax
  802132:	6a 00                	push   $0x0
  802134:	6a 00                	push   $0x0
  802136:	6a 00                	push   $0x0
  802138:	6a 00                	push   $0x0
  80213a:	50                   	push   %eax
  80213b:	6a 22                	push   $0x22
  80213d:	e8 52 fc ff ff       	call   801d94 <syscall>
  802142:	83 c4 18             	add    $0x18,%esp
}
  802145:	c9                   	leave  
  802146:	c3                   	ret    

00802147 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802147:	55                   	push   %ebp
  802148:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80214a:	6a 00                	push   $0x0
  80214c:	6a 00                	push   $0x0
  80214e:	6a 00                	push   $0x0
  802150:	6a 00                	push   $0x0
  802152:	6a 00                	push   $0x0
  802154:	6a 02                	push   $0x2
  802156:	e8 39 fc ff ff       	call   801d94 <syscall>
  80215b:	83 c4 18             	add    $0x18,%esp
}
  80215e:	c9                   	leave  
  80215f:	c3                   	ret    

00802160 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802160:	55                   	push   %ebp
  802161:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802163:	6a 00                	push   $0x0
  802165:	6a 00                	push   $0x0
  802167:	6a 00                	push   $0x0
  802169:	6a 00                	push   $0x0
  80216b:	6a 00                	push   $0x0
  80216d:	6a 03                	push   $0x3
  80216f:	e8 20 fc ff ff       	call   801d94 <syscall>
  802174:	83 c4 18             	add    $0x18,%esp
}
  802177:	c9                   	leave  
  802178:	c3                   	ret    

00802179 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802179:	55                   	push   %ebp
  80217a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80217c:	6a 00                	push   $0x0
  80217e:	6a 00                	push   $0x0
  802180:	6a 00                	push   $0x0
  802182:	6a 00                	push   $0x0
  802184:	6a 00                	push   $0x0
  802186:	6a 04                	push   $0x4
  802188:	e8 07 fc ff ff       	call   801d94 <syscall>
  80218d:	83 c4 18             	add    $0x18,%esp
}
  802190:	c9                   	leave  
  802191:	c3                   	ret    

00802192 <sys_exit_env>:


void sys_exit_env(void)
{
  802192:	55                   	push   %ebp
  802193:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802195:	6a 00                	push   $0x0
  802197:	6a 00                	push   $0x0
  802199:	6a 00                	push   $0x0
  80219b:	6a 00                	push   $0x0
  80219d:	6a 00                	push   $0x0
  80219f:	6a 23                	push   $0x23
  8021a1:	e8 ee fb ff ff       	call   801d94 <syscall>
  8021a6:	83 c4 18             	add    $0x18,%esp
}
  8021a9:	90                   	nop
  8021aa:	c9                   	leave  
  8021ab:	c3                   	ret    

008021ac <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8021ac:	55                   	push   %ebp
  8021ad:	89 e5                	mov    %esp,%ebp
  8021af:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8021b2:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8021b5:	8d 50 04             	lea    0x4(%eax),%edx
  8021b8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8021bb:	6a 00                	push   $0x0
  8021bd:	6a 00                	push   $0x0
  8021bf:	6a 00                	push   $0x0
  8021c1:	52                   	push   %edx
  8021c2:	50                   	push   %eax
  8021c3:	6a 24                	push   $0x24
  8021c5:	e8 ca fb ff ff       	call   801d94 <syscall>
  8021ca:	83 c4 18             	add    $0x18,%esp
	return result;
  8021cd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8021d0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021d3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8021d6:	89 01                	mov    %eax,(%ecx)
  8021d8:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8021db:	8b 45 08             	mov    0x8(%ebp),%eax
  8021de:	c9                   	leave  
  8021df:	c2 04 00             	ret    $0x4

008021e2 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8021e2:	55                   	push   %ebp
  8021e3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8021e5:	6a 00                	push   $0x0
  8021e7:	6a 00                	push   $0x0
  8021e9:	ff 75 10             	pushl  0x10(%ebp)
  8021ec:	ff 75 0c             	pushl  0xc(%ebp)
  8021ef:	ff 75 08             	pushl  0x8(%ebp)
  8021f2:	6a 12                	push   $0x12
  8021f4:	e8 9b fb ff ff       	call   801d94 <syscall>
  8021f9:	83 c4 18             	add    $0x18,%esp
	return ;
  8021fc:	90                   	nop
}
  8021fd:	c9                   	leave  
  8021fe:	c3                   	ret    

008021ff <sys_rcr2>:
uint32 sys_rcr2()
{
  8021ff:	55                   	push   %ebp
  802200:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802202:	6a 00                	push   $0x0
  802204:	6a 00                	push   $0x0
  802206:	6a 00                	push   $0x0
  802208:	6a 00                	push   $0x0
  80220a:	6a 00                	push   $0x0
  80220c:	6a 25                	push   $0x25
  80220e:	e8 81 fb ff ff       	call   801d94 <syscall>
  802213:	83 c4 18             	add    $0x18,%esp
}
  802216:	c9                   	leave  
  802217:	c3                   	ret    

00802218 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802218:	55                   	push   %ebp
  802219:	89 e5                	mov    %esp,%ebp
  80221b:	83 ec 04             	sub    $0x4,%esp
  80221e:	8b 45 08             	mov    0x8(%ebp),%eax
  802221:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802224:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802228:	6a 00                	push   $0x0
  80222a:	6a 00                	push   $0x0
  80222c:	6a 00                	push   $0x0
  80222e:	6a 00                	push   $0x0
  802230:	50                   	push   %eax
  802231:	6a 26                	push   $0x26
  802233:	e8 5c fb ff ff       	call   801d94 <syscall>
  802238:	83 c4 18             	add    $0x18,%esp
	return ;
  80223b:	90                   	nop
}
  80223c:	c9                   	leave  
  80223d:	c3                   	ret    

0080223e <rsttst>:
void rsttst()
{
  80223e:	55                   	push   %ebp
  80223f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802241:	6a 00                	push   $0x0
  802243:	6a 00                	push   $0x0
  802245:	6a 00                	push   $0x0
  802247:	6a 00                	push   $0x0
  802249:	6a 00                	push   $0x0
  80224b:	6a 28                	push   $0x28
  80224d:	e8 42 fb ff ff       	call   801d94 <syscall>
  802252:	83 c4 18             	add    $0x18,%esp
	return ;
  802255:	90                   	nop
}
  802256:	c9                   	leave  
  802257:	c3                   	ret    

00802258 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802258:	55                   	push   %ebp
  802259:	89 e5                	mov    %esp,%ebp
  80225b:	83 ec 04             	sub    $0x4,%esp
  80225e:	8b 45 14             	mov    0x14(%ebp),%eax
  802261:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802264:	8b 55 18             	mov    0x18(%ebp),%edx
  802267:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80226b:	52                   	push   %edx
  80226c:	50                   	push   %eax
  80226d:	ff 75 10             	pushl  0x10(%ebp)
  802270:	ff 75 0c             	pushl  0xc(%ebp)
  802273:	ff 75 08             	pushl  0x8(%ebp)
  802276:	6a 27                	push   $0x27
  802278:	e8 17 fb ff ff       	call   801d94 <syscall>
  80227d:	83 c4 18             	add    $0x18,%esp
	return ;
  802280:	90                   	nop
}
  802281:	c9                   	leave  
  802282:	c3                   	ret    

00802283 <chktst>:
void chktst(uint32 n)
{
  802283:	55                   	push   %ebp
  802284:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802286:	6a 00                	push   $0x0
  802288:	6a 00                	push   $0x0
  80228a:	6a 00                	push   $0x0
  80228c:	6a 00                	push   $0x0
  80228e:	ff 75 08             	pushl  0x8(%ebp)
  802291:	6a 29                	push   $0x29
  802293:	e8 fc fa ff ff       	call   801d94 <syscall>
  802298:	83 c4 18             	add    $0x18,%esp
	return ;
  80229b:	90                   	nop
}
  80229c:	c9                   	leave  
  80229d:	c3                   	ret    

0080229e <inctst>:

void inctst()
{
  80229e:	55                   	push   %ebp
  80229f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8022a1:	6a 00                	push   $0x0
  8022a3:	6a 00                	push   $0x0
  8022a5:	6a 00                	push   $0x0
  8022a7:	6a 00                	push   $0x0
  8022a9:	6a 00                	push   $0x0
  8022ab:	6a 2a                	push   $0x2a
  8022ad:	e8 e2 fa ff ff       	call   801d94 <syscall>
  8022b2:	83 c4 18             	add    $0x18,%esp
	return ;
  8022b5:	90                   	nop
}
  8022b6:	c9                   	leave  
  8022b7:	c3                   	ret    

008022b8 <gettst>:
uint32 gettst()
{
  8022b8:	55                   	push   %ebp
  8022b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8022bb:	6a 00                	push   $0x0
  8022bd:	6a 00                	push   $0x0
  8022bf:	6a 00                	push   $0x0
  8022c1:	6a 00                	push   $0x0
  8022c3:	6a 00                	push   $0x0
  8022c5:	6a 2b                	push   $0x2b
  8022c7:	e8 c8 fa ff ff       	call   801d94 <syscall>
  8022cc:	83 c4 18             	add    $0x18,%esp
}
  8022cf:	c9                   	leave  
  8022d0:	c3                   	ret    

008022d1 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8022d1:	55                   	push   %ebp
  8022d2:	89 e5                	mov    %esp,%ebp
  8022d4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8022d7:	6a 00                	push   $0x0
  8022d9:	6a 00                	push   $0x0
  8022db:	6a 00                	push   $0x0
  8022dd:	6a 00                	push   $0x0
  8022df:	6a 00                	push   $0x0
  8022e1:	6a 2c                	push   $0x2c
  8022e3:	e8 ac fa ff ff       	call   801d94 <syscall>
  8022e8:	83 c4 18             	add    $0x18,%esp
  8022eb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8022ee:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8022f2:	75 07                	jne    8022fb <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8022f4:	b8 01 00 00 00       	mov    $0x1,%eax
  8022f9:	eb 05                	jmp    802300 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8022fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802300:	c9                   	leave  
  802301:	c3                   	ret    

00802302 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802302:	55                   	push   %ebp
  802303:	89 e5                	mov    %esp,%ebp
  802305:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802308:	6a 00                	push   $0x0
  80230a:	6a 00                	push   $0x0
  80230c:	6a 00                	push   $0x0
  80230e:	6a 00                	push   $0x0
  802310:	6a 00                	push   $0x0
  802312:	6a 2c                	push   $0x2c
  802314:	e8 7b fa ff ff       	call   801d94 <syscall>
  802319:	83 c4 18             	add    $0x18,%esp
  80231c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80231f:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802323:	75 07                	jne    80232c <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802325:	b8 01 00 00 00       	mov    $0x1,%eax
  80232a:	eb 05                	jmp    802331 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80232c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802331:	c9                   	leave  
  802332:	c3                   	ret    

00802333 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802333:	55                   	push   %ebp
  802334:	89 e5                	mov    %esp,%ebp
  802336:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802339:	6a 00                	push   $0x0
  80233b:	6a 00                	push   $0x0
  80233d:	6a 00                	push   $0x0
  80233f:	6a 00                	push   $0x0
  802341:	6a 00                	push   $0x0
  802343:	6a 2c                	push   $0x2c
  802345:	e8 4a fa ff ff       	call   801d94 <syscall>
  80234a:	83 c4 18             	add    $0x18,%esp
  80234d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802350:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802354:	75 07                	jne    80235d <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802356:	b8 01 00 00 00       	mov    $0x1,%eax
  80235b:	eb 05                	jmp    802362 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80235d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802362:	c9                   	leave  
  802363:	c3                   	ret    

00802364 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802364:	55                   	push   %ebp
  802365:	89 e5                	mov    %esp,%ebp
  802367:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80236a:	6a 00                	push   $0x0
  80236c:	6a 00                	push   $0x0
  80236e:	6a 00                	push   $0x0
  802370:	6a 00                	push   $0x0
  802372:	6a 00                	push   $0x0
  802374:	6a 2c                	push   $0x2c
  802376:	e8 19 fa ff ff       	call   801d94 <syscall>
  80237b:	83 c4 18             	add    $0x18,%esp
  80237e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802381:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802385:	75 07                	jne    80238e <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802387:	b8 01 00 00 00       	mov    $0x1,%eax
  80238c:	eb 05                	jmp    802393 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80238e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802393:	c9                   	leave  
  802394:	c3                   	ret    

00802395 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802395:	55                   	push   %ebp
  802396:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802398:	6a 00                	push   $0x0
  80239a:	6a 00                	push   $0x0
  80239c:	6a 00                	push   $0x0
  80239e:	6a 00                	push   $0x0
  8023a0:	ff 75 08             	pushl  0x8(%ebp)
  8023a3:	6a 2d                	push   $0x2d
  8023a5:	e8 ea f9 ff ff       	call   801d94 <syscall>
  8023aa:	83 c4 18             	add    $0x18,%esp
	return ;
  8023ad:	90                   	nop
}
  8023ae:	c9                   	leave  
  8023af:	c3                   	ret    

008023b0 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8023b0:	55                   	push   %ebp
  8023b1:	89 e5                	mov    %esp,%ebp
  8023b3:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8023b4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8023b7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8023ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c0:	6a 00                	push   $0x0
  8023c2:	53                   	push   %ebx
  8023c3:	51                   	push   %ecx
  8023c4:	52                   	push   %edx
  8023c5:	50                   	push   %eax
  8023c6:	6a 2e                	push   $0x2e
  8023c8:	e8 c7 f9 ff ff       	call   801d94 <syscall>
  8023cd:	83 c4 18             	add    $0x18,%esp
}
  8023d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023d3:	c9                   	leave  
  8023d4:	c3                   	ret    

008023d5 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8023d5:	55                   	push   %ebp
  8023d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8023d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023db:	8b 45 08             	mov    0x8(%ebp),%eax
  8023de:	6a 00                	push   $0x0
  8023e0:	6a 00                	push   $0x0
  8023e2:	6a 00                	push   $0x0
  8023e4:	52                   	push   %edx
  8023e5:	50                   	push   %eax
  8023e6:	6a 2f                	push   $0x2f
  8023e8:	e8 a7 f9 ff ff       	call   801d94 <syscall>
  8023ed:	83 c4 18             	add    $0x18,%esp
}
  8023f0:	c9                   	leave  
  8023f1:	c3                   	ret    

008023f2 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8023f2:	55                   	push   %ebp
  8023f3:	89 e5                	mov    %esp,%ebp
  8023f5:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8023f8:	83 ec 0c             	sub    $0xc,%esp
  8023fb:	68 98 45 80 00       	push   $0x804598
  802400:	e8 40 e6 ff ff       	call   800a45 <cprintf>
  802405:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802408:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  80240f:	83 ec 0c             	sub    $0xc,%esp
  802412:	68 c4 45 80 00       	push   $0x8045c4
  802417:	e8 29 e6 ff ff       	call   800a45 <cprintf>
  80241c:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  80241f:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802423:	a1 38 51 80 00       	mov    0x805138,%eax
  802428:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80242b:	eb 56                	jmp    802483 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80242d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802431:	74 1c                	je     80244f <print_mem_block_lists+0x5d>
  802433:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802436:	8b 50 08             	mov    0x8(%eax),%edx
  802439:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80243c:	8b 48 08             	mov    0x8(%eax),%ecx
  80243f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802442:	8b 40 0c             	mov    0xc(%eax),%eax
  802445:	01 c8                	add    %ecx,%eax
  802447:	39 c2                	cmp    %eax,%edx
  802449:	73 04                	jae    80244f <print_mem_block_lists+0x5d>
			sorted = 0 ;
  80244b:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80244f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802452:	8b 50 08             	mov    0x8(%eax),%edx
  802455:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802458:	8b 40 0c             	mov    0xc(%eax),%eax
  80245b:	01 c2                	add    %eax,%edx
  80245d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802460:	8b 40 08             	mov    0x8(%eax),%eax
  802463:	83 ec 04             	sub    $0x4,%esp
  802466:	52                   	push   %edx
  802467:	50                   	push   %eax
  802468:	68 d9 45 80 00       	push   $0x8045d9
  80246d:	e8 d3 e5 ff ff       	call   800a45 <cprintf>
  802472:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802475:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802478:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80247b:	a1 40 51 80 00       	mov    0x805140,%eax
  802480:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802483:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802487:	74 07                	je     802490 <print_mem_block_lists+0x9e>
  802489:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248c:	8b 00                	mov    (%eax),%eax
  80248e:	eb 05                	jmp    802495 <print_mem_block_lists+0xa3>
  802490:	b8 00 00 00 00       	mov    $0x0,%eax
  802495:	a3 40 51 80 00       	mov    %eax,0x805140
  80249a:	a1 40 51 80 00       	mov    0x805140,%eax
  80249f:	85 c0                	test   %eax,%eax
  8024a1:	75 8a                	jne    80242d <print_mem_block_lists+0x3b>
  8024a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024a7:	75 84                	jne    80242d <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8024a9:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8024ad:	75 10                	jne    8024bf <print_mem_block_lists+0xcd>
  8024af:	83 ec 0c             	sub    $0xc,%esp
  8024b2:	68 e8 45 80 00       	push   $0x8045e8
  8024b7:	e8 89 e5 ff ff       	call   800a45 <cprintf>
  8024bc:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8024bf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8024c6:	83 ec 0c             	sub    $0xc,%esp
  8024c9:	68 0c 46 80 00       	push   $0x80460c
  8024ce:	e8 72 e5 ff ff       	call   800a45 <cprintf>
  8024d3:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8024d6:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8024da:	a1 40 50 80 00       	mov    0x805040,%eax
  8024df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024e2:	eb 56                	jmp    80253a <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8024e4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024e8:	74 1c                	je     802506 <print_mem_block_lists+0x114>
  8024ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ed:	8b 50 08             	mov    0x8(%eax),%edx
  8024f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024f3:	8b 48 08             	mov    0x8(%eax),%ecx
  8024f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024f9:	8b 40 0c             	mov    0xc(%eax),%eax
  8024fc:	01 c8                	add    %ecx,%eax
  8024fe:	39 c2                	cmp    %eax,%edx
  802500:	73 04                	jae    802506 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802502:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802506:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802509:	8b 50 08             	mov    0x8(%eax),%edx
  80250c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250f:	8b 40 0c             	mov    0xc(%eax),%eax
  802512:	01 c2                	add    %eax,%edx
  802514:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802517:	8b 40 08             	mov    0x8(%eax),%eax
  80251a:	83 ec 04             	sub    $0x4,%esp
  80251d:	52                   	push   %edx
  80251e:	50                   	push   %eax
  80251f:	68 d9 45 80 00       	push   $0x8045d9
  802524:	e8 1c e5 ff ff       	call   800a45 <cprintf>
  802529:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80252c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802532:	a1 48 50 80 00       	mov    0x805048,%eax
  802537:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80253a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80253e:	74 07                	je     802547 <print_mem_block_lists+0x155>
  802540:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802543:	8b 00                	mov    (%eax),%eax
  802545:	eb 05                	jmp    80254c <print_mem_block_lists+0x15a>
  802547:	b8 00 00 00 00       	mov    $0x0,%eax
  80254c:	a3 48 50 80 00       	mov    %eax,0x805048
  802551:	a1 48 50 80 00       	mov    0x805048,%eax
  802556:	85 c0                	test   %eax,%eax
  802558:	75 8a                	jne    8024e4 <print_mem_block_lists+0xf2>
  80255a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80255e:	75 84                	jne    8024e4 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802560:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802564:	75 10                	jne    802576 <print_mem_block_lists+0x184>
  802566:	83 ec 0c             	sub    $0xc,%esp
  802569:	68 24 46 80 00       	push   $0x804624
  80256e:	e8 d2 e4 ff ff       	call   800a45 <cprintf>
  802573:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802576:	83 ec 0c             	sub    $0xc,%esp
  802579:	68 98 45 80 00       	push   $0x804598
  80257e:	e8 c2 e4 ff ff       	call   800a45 <cprintf>
  802583:	83 c4 10             	add    $0x10,%esp

}
  802586:	90                   	nop
  802587:	c9                   	leave  
  802588:	c3                   	ret    

00802589 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802589:	55                   	push   %ebp
  80258a:	89 e5                	mov    %esp,%ebp
  80258c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  80258f:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802596:	00 00 00 
  802599:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8025a0:	00 00 00 
  8025a3:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8025aa:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  8025ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8025b4:	e9 9e 00 00 00       	jmp    802657 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  8025b9:	a1 50 50 80 00       	mov    0x805050,%eax
  8025be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025c1:	c1 e2 04             	shl    $0x4,%edx
  8025c4:	01 d0                	add    %edx,%eax
  8025c6:	85 c0                	test   %eax,%eax
  8025c8:	75 14                	jne    8025de <initialize_MemBlocksList+0x55>
  8025ca:	83 ec 04             	sub    $0x4,%esp
  8025cd:	68 4c 46 80 00       	push   $0x80464c
  8025d2:	6a 46                	push   $0x46
  8025d4:	68 6f 46 80 00       	push   $0x80466f
  8025d9:	e8 b3 e1 ff ff       	call   800791 <_panic>
  8025de:	a1 50 50 80 00       	mov    0x805050,%eax
  8025e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025e6:	c1 e2 04             	shl    $0x4,%edx
  8025e9:	01 d0                	add    %edx,%eax
  8025eb:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8025f1:	89 10                	mov    %edx,(%eax)
  8025f3:	8b 00                	mov    (%eax),%eax
  8025f5:	85 c0                	test   %eax,%eax
  8025f7:	74 18                	je     802611 <initialize_MemBlocksList+0x88>
  8025f9:	a1 48 51 80 00       	mov    0x805148,%eax
  8025fe:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802604:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802607:	c1 e1 04             	shl    $0x4,%ecx
  80260a:	01 ca                	add    %ecx,%edx
  80260c:	89 50 04             	mov    %edx,0x4(%eax)
  80260f:	eb 12                	jmp    802623 <initialize_MemBlocksList+0x9a>
  802611:	a1 50 50 80 00       	mov    0x805050,%eax
  802616:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802619:	c1 e2 04             	shl    $0x4,%edx
  80261c:	01 d0                	add    %edx,%eax
  80261e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802623:	a1 50 50 80 00       	mov    0x805050,%eax
  802628:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80262b:	c1 e2 04             	shl    $0x4,%edx
  80262e:	01 d0                	add    %edx,%eax
  802630:	a3 48 51 80 00       	mov    %eax,0x805148
  802635:	a1 50 50 80 00       	mov    0x805050,%eax
  80263a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80263d:	c1 e2 04             	shl    $0x4,%edx
  802640:	01 d0                	add    %edx,%eax
  802642:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802649:	a1 54 51 80 00       	mov    0x805154,%eax
  80264e:	40                   	inc    %eax
  80264f:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802654:	ff 45 f4             	incl   -0xc(%ebp)
  802657:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80265d:	0f 82 56 ff ff ff    	jb     8025b9 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802663:	90                   	nop
  802664:	c9                   	leave  
  802665:	c3                   	ret    

00802666 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802666:	55                   	push   %ebp
  802667:	89 e5                	mov    %esp,%ebp
  802669:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80266c:	8b 45 08             	mov    0x8(%ebp),%eax
  80266f:	8b 00                	mov    (%eax),%eax
  802671:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802674:	eb 19                	jmp    80268f <find_block+0x29>
	{
		if(va==point->sva)
  802676:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802679:	8b 40 08             	mov    0x8(%eax),%eax
  80267c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80267f:	75 05                	jne    802686 <find_block+0x20>
		   return point;
  802681:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802684:	eb 36                	jmp    8026bc <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802686:	8b 45 08             	mov    0x8(%ebp),%eax
  802689:	8b 40 08             	mov    0x8(%eax),%eax
  80268c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80268f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802693:	74 07                	je     80269c <find_block+0x36>
  802695:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802698:	8b 00                	mov    (%eax),%eax
  80269a:	eb 05                	jmp    8026a1 <find_block+0x3b>
  80269c:	b8 00 00 00 00       	mov    $0x0,%eax
  8026a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8026a4:	89 42 08             	mov    %eax,0x8(%edx)
  8026a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8026aa:	8b 40 08             	mov    0x8(%eax),%eax
  8026ad:	85 c0                	test   %eax,%eax
  8026af:	75 c5                	jne    802676 <find_block+0x10>
  8026b1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8026b5:	75 bf                	jne    802676 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  8026b7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026bc:	c9                   	leave  
  8026bd:	c3                   	ret    

008026be <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8026be:	55                   	push   %ebp
  8026bf:	89 e5                	mov    %esp,%ebp
  8026c1:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  8026c4:	a1 40 50 80 00       	mov    0x805040,%eax
  8026c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  8026cc:	a1 44 50 80 00       	mov    0x805044,%eax
  8026d1:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8026d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026d7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8026da:	74 24                	je     802700 <insert_sorted_allocList+0x42>
  8026dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8026df:	8b 50 08             	mov    0x8(%eax),%edx
  8026e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026e5:	8b 40 08             	mov    0x8(%eax),%eax
  8026e8:	39 c2                	cmp    %eax,%edx
  8026ea:	76 14                	jbe    802700 <insert_sorted_allocList+0x42>
  8026ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ef:	8b 50 08             	mov    0x8(%eax),%edx
  8026f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026f5:	8b 40 08             	mov    0x8(%eax),%eax
  8026f8:	39 c2                	cmp    %eax,%edx
  8026fa:	0f 82 60 01 00 00    	jb     802860 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802700:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802704:	75 65                	jne    80276b <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802706:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80270a:	75 14                	jne    802720 <insert_sorted_allocList+0x62>
  80270c:	83 ec 04             	sub    $0x4,%esp
  80270f:	68 4c 46 80 00       	push   $0x80464c
  802714:	6a 6b                	push   $0x6b
  802716:	68 6f 46 80 00       	push   $0x80466f
  80271b:	e8 71 e0 ff ff       	call   800791 <_panic>
  802720:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802726:	8b 45 08             	mov    0x8(%ebp),%eax
  802729:	89 10                	mov    %edx,(%eax)
  80272b:	8b 45 08             	mov    0x8(%ebp),%eax
  80272e:	8b 00                	mov    (%eax),%eax
  802730:	85 c0                	test   %eax,%eax
  802732:	74 0d                	je     802741 <insert_sorted_allocList+0x83>
  802734:	a1 40 50 80 00       	mov    0x805040,%eax
  802739:	8b 55 08             	mov    0x8(%ebp),%edx
  80273c:	89 50 04             	mov    %edx,0x4(%eax)
  80273f:	eb 08                	jmp    802749 <insert_sorted_allocList+0x8b>
  802741:	8b 45 08             	mov    0x8(%ebp),%eax
  802744:	a3 44 50 80 00       	mov    %eax,0x805044
  802749:	8b 45 08             	mov    0x8(%ebp),%eax
  80274c:	a3 40 50 80 00       	mov    %eax,0x805040
  802751:	8b 45 08             	mov    0x8(%ebp),%eax
  802754:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80275b:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802760:	40                   	inc    %eax
  802761:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802766:	e9 dc 01 00 00       	jmp    802947 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  80276b:	8b 45 08             	mov    0x8(%ebp),%eax
  80276e:	8b 50 08             	mov    0x8(%eax),%edx
  802771:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802774:	8b 40 08             	mov    0x8(%eax),%eax
  802777:	39 c2                	cmp    %eax,%edx
  802779:	77 6c                	ja     8027e7 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  80277b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80277f:	74 06                	je     802787 <insert_sorted_allocList+0xc9>
  802781:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802785:	75 14                	jne    80279b <insert_sorted_allocList+0xdd>
  802787:	83 ec 04             	sub    $0x4,%esp
  80278a:	68 88 46 80 00       	push   $0x804688
  80278f:	6a 6f                	push   $0x6f
  802791:	68 6f 46 80 00       	push   $0x80466f
  802796:	e8 f6 df ff ff       	call   800791 <_panic>
  80279b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80279e:	8b 50 04             	mov    0x4(%eax),%edx
  8027a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a4:	89 50 04             	mov    %edx,0x4(%eax)
  8027a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8027aa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027ad:	89 10                	mov    %edx,(%eax)
  8027af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027b2:	8b 40 04             	mov    0x4(%eax),%eax
  8027b5:	85 c0                	test   %eax,%eax
  8027b7:	74 0d                	je     8027c6 <insert_sorted_allocList+0x108>
  8027b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027bc:	8b 40 04             	mov    0x4(%eax),%eax
  8027bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8027c2:	89 10                	mov    %edx,(%eax)
  8027c4:	eb 08                	jmp    8027ce <insert_sorted_allocList+0x110>
  8027c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c9:	a3 40 50 80 00       	mov    %eax,0x805040
  8027ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8027d4:	89 50 04             	mov    %edx,0x4(%eax)
  8027d7:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8027dc:	40                   	inc    %eax
  8027dd:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8027e2:	e9 60 01 00 00       	jmp    802947 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8027e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ea:	8b 50 08             	mov    0x8(%eax),%edx
  8027ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027f0:	8b 40 08             	mov    0x8(%eax),%eax
  8027f3:	39 c2                	cmp    %eax,%edx
  8027f5:	0f 82 4c 01 00 00    	jb     802947 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8027fb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8027ff:	75 14                	jne    802815 <insert_sorted_allocList+0x157>
  802801:	83 ec 04             	sub    $0x4,%esp
  802804:	68 c0 46 80 00       	push   $0x8046c0
  802809:	6a 73                	push   $0x73
  80280b:	68 6f 46 80 00       	push   $0x80466f
  802810:	e8 7c df ff ff       	call   800791 <_panic>
  802815:	8b 15 44 50 80 00    	mov    0x805044,%edx
  80281b:	8b 45 08             	mov    0x8(%ebp),%eax
  80281e:	89 50 04             	mov    %edx,0x4(%eax)
  802821:	8b 45 08             	mov    0x8(%ebp),%eax
  802824:	8b 40 04             	mov    0x4(%eax),%eax
  802827:	85 c0                	test   %eax,%eax
  802829:	74 0c                	je     802837 <insert_sorted_allocList+0x179>
  80282b:	a1 44 50 80 00       	mov    0x805044,%eax
  802830:	8b 55 08             	mov    0x8(%ebp),%edx
  802833:	89 10                	mov    %edx,(%eax)
  802835:	eb 08                	jmp    80283f <insert_sorted_allocList+0x181>
  802837:	8b 45 08             	mov    0x8(%ebp),%eax
  80283a:	a3 40 50 80 00       	mov    %eax,0x805040
  80283f:	8b 45 08             	mov    0x8(%ebp),%eax
  802842:	a3 44 50 80 00       	mov    %eax,0x805044
  802847:	8b 45 08             	mov    0x8(%ebp),%eax
  80284a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802850:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802855:	40                   	inc    %eax
  802856:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80285b:	e9 e7 00 00 00       	jmp    802947 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802860:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802863:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802866:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80286d:	a1 40 50 80 00       	mov    0x805040,%eax
  802872:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802875:	e9 9d 00 00 00       	jmp    802917 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  80287a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287d:	8b 00                	mov    (%eax),%eax
  80287f:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802882:	8b 45 08             	mov    0x8(%ebp),%eax
  802885:	8b 50 08             	mov    0x8(%eax),%edx
  802888:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288b:	8b 40 08             	mov    0x8(%eax),%eax
  80288e:	39 c2                	cmp    %eax,%edx
  802890:	76 7d                	jbe    80290f <insert_sorted_allocList+0x251>
  802892:	8b 45 08             	mov    0x8(%ebp),%eax
  802895:	8b 50 08             	mov    0x8(%eax),%edx
  802898:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80289b:	8b 40 08             	mov    0x8(%eax),%eax
  80289e:	39 c2                	cmp    %eax,%edx
  8028a0:	73 6d                	jae    80290f <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8028a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028a6:	74 06                	je     8028ae <insert_sorted_allocList+0x1f0>
  8028a8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028ac:	75 14                	jne    8028c2 <insert_sorted_allocList+0x204>
  8028ae:	83 ec 04             	sub    $0x4,%esp
  8028b1:	68 e4 46 80 00       	push   $0x8046e4
  8028b6:	6a 7f                	push   $0x7f
  8028b8:	68 6f 46 80 00       	push   $0x80466f
  8028bd:	e8 cf de ff ff       	call   800791 <_panic>
  8028c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c5:	8b 10                	mov    (%eax),%edx
  8028c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ca:	89 10                	mov    %edx,(%eax)
  8028cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8028cf:	8b 00                	mov    (%eax),%eax
  8028d1:	85 c0                	test   %eax,%eax
  8028d3:	74 0b                	je     8028e0 <insert_sorted_allocList+0x222>
  8028d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d8:	8b 00                	mov    (%eax),%eax
  8028da:	8b 55 08             	mov    0x8(%ebp),%edx
  8028dd:	89 50 04             	mov    %edx,0x4(%eax)
  8028e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e3:	8b 55 08             	mov    0x8(%ebp),%edx
  8028e6:	89 10                	mov    %edx,(%eax)
  8028e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8028eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028ee:	89 50 04             	mov    %edx,0x4(%eax)
  8028f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f4:	8b 00                	mov    (%eax),%eax
  8028f6:	85 c0                	test   %eax,%eax
  8028f8:	75 08                	jne    802902 <insert_sorted_allocList+0x244>
  8028fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8028fd:	a3 44 50 80 00       	mov    %eax,0x805044
  802902:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802907:	40                   	inc    %eax
  802908:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  80290d:	eb 39                	jmp    802948 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80290f:	a1 48 50 80 00       	mov    0x805048,%eax
  802914:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802917:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80291b:	74 07                	je     802924 <insert_sorted_allocList+0x266>
  80291d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802920:	8b 00                	mov    (%eax),%eax
  802922:	eb 05                	jmp    802929 <insert_sorted_allocList+0x26b>
  802924:	b8 00 00 00 00       	mov    $0x0,%eax
  802929:	a3 48 50 80 00       	mov    %eax,0x805048
  80292e:	a1 48 50 80 00       	mov    0x805048,%eax
  802933:	85 c0                	test   %eax,%eax
  802935:	0f 85 3f ff ff ff    	jne    80287a <insert_sorted_allocList+0x1bc>
  80293b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80293f:	0f 85 35 ff ff ff    	jne    80287a <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802945:	eb 01                	jmp    802948 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802947:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802948:	90                   	nop
  802949:	c9                   	leave  
  80294a:	c3                   	ret    

0080294b <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80294b:	55                   	push   %ebp
  80294c:	89 e5                	mov    %esp,%ebp
  80294e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802951:	a1 38 51 80 00       	mov    0x805138,%eax
  802956:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802959:	e9 85 01 00 00       	jmp    802ae3 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  80295e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802961:	8b 40 0c             	mov    0xc(%eax),%eax
  802964:	3b 45 08             	cmp    0x8(%ebp),%eax
  802967:	0f 82 6e 01 00 00    	jb     802adb <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  80296d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802970:	8b 40 0c             	mov    0xc(%eax),%eax
  802973:	3b 45 08             	cmp    0x8(%ebp),%eax
  802976:	0f 85 8a 00 00 00    	jne    802a06 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  80297c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802980:	75 17                	jne    802999 <alloc_block_FF+0x4e>
  802982:	83 ec 04             	sub    $0x4,%esp
  802985:	68 18 47 80 00       	push   $0x804718
  80298a:	68 93 00 00 00       	push   $0x93
  80298f:	68 6f 46 80 00       	push   $0x80466f
  802994:	e8 f8 dd ff ff       	call   800791 <_panic>
  802999:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299c:	8b 00                	mov    (%eax),%eax
  80299e:	85 c0                	test   %eax,%eax
  8029a0:	74 10                	je     8029b2 <alloc_block_FF+0x67>
  8029a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a5:	8b 00                	mov    (%eax),%eax
  8029a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029aa:	8b 52 04             	mov    0x4(%edx),%edx
  8029ad:	89 50 04             	mov    %edx,0x4(%eax)
  8029b0:	eb 0b                	jmp    8029bd <alloc_block_FF+0x72>
  8029b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b5:	8b 40 04             	mov    0x4(%eax),%eax
  8029b8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8029bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c0:	8b 40 04             	mov    0x4(%eax),%eax
  8029c3:	85 c0                	test   %eax,%eax
  8029c5:	74 0f                	je     8029d6 <alloc_block_FF+0x8b>
  8029c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ca:	8b 40 04             	mov    0x4(%eax),%eax
  8029cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029d0:	8b 12                	mov    (%edx),%edx
  8029d2:	89 10                	mov    %edx,(%eax)
  8029d4:	eb 0a                	jmp    8029e0 <alloc_block_FF+0x95>
  8029d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d9:	8b 00                	mov    (%eax),%eax
  8029db:	a3 38 51 80 00       	mov    %eax,0x805138
  8029e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ec:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029f3:	a1 44 51 80 00       	mov    0x805144,%eax
  8029f8:	48                   	dec    %eax
  8029f9:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  8029fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a01:	e9 10 01 00 00       	jmp    802b16 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802a06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a09:	8b 40 0c             	mov    0xc(%eax),%eax
  802a0c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a0f:	0f 86 c6 00 00 00    	jbe    802adb <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802a15:	a1 48 51 80 00       	mov    0x805148,%eax
  802a1a:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802a1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a20:	8b 50 08             	mov    0x8(%eax),%edx
  802a23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a26:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802a29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a2c:	8b 55 08             	mov    0x8(%ebp),%edx
  802a2f:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802a32:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a36:	75 17                	jne    802a4f <alloc_block_FF+0x104>
  802a38:	83 ec 04             	sub    $0x4,%esp
  802a3b:	68 18 47 80 00       	push   $0x804718
  802a40:	68 9b 00 00 00       	push   $0x9b
  802a45:	68 6f 46 80 00       	push   $0x80466f
  802a4a:	e8 42 dd ff ff       	call   800791 <_panic>
  802a4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a52:	8b 00                	mov    (%eax),%eax
  802a54:	85 c0                	test   %eax,%eax
  802a56:	74 10                	je     802a68 <alloc_block_FF+0x11d>
  802a58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a5b:	8b 00                	mov    (%eax),%eax
  802a5d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a60:	8b 52 04             	mov    0x4(%edx),%edx
  802a63:	89 50 04             	mov    %edx,0x4(%eax)
  802a66:	eb 0b                	jmp    802a73 <alloc_block_FF+0x128>
  802a68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a6b:	8b 40 04             	mov    0x4(%eax),%eax
  802a6e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a76:	8b 40 04             	mov    0x4(%eax),%eax
  802a79:	85 c0                	test   %eax,%eax
  802a7b:	74 0f                	je     802a8c <alloc_block_FF+0x141>
  802a7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a80:	8b 40 04             	mov    0x4(%eax),%eax
  802a83:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a86:	8b 12                	mov    (%edx),%edx
  802a88:	89 10                	mov    %edx,(%eax)
  802a8a:	eb 0a                	jmp    802a96 <alloc_block_FF+0x14b>
  802a8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a8f:	8b 00                	mov    (%eax),%eax
  802a91:	a3 48 51 80 00       	mov    %eax,0x805148
  802a96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a99:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aa2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802aa9:	a1 54 51 80 00       	mov    0x805154,%eax
  802aae:	48                   	dec    %eax
  802aaf:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802ab4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab7:	8b 50 08             	mov    0x8(%eax),%edx
  802aba:	8b 45 08             	mov    0x8(%ebp),%eax
  802abd:	01 c2                	add    %eax,%edx
  802abf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac2:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802ac5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac8:	8b 40 0c             	mov    0xc(%eax),%eax
  802acb:	2b 45 08             	sub    0x8(%ebp),%eax
  802ace:	89 c2                	mov    %eax,%edx
  802ad0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad3:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802ad6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ad9:	eb 3b                	jmp    802b16 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802adb:	a1 40 51 80 00       	mov    0x805140,%eax
  802ae0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ae3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ae7:	74 07                	je     802af0 <alloc_block_FF+0x1a5>
  802ae9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aec:	8b 00                	mov    (%eax),%eax
  802aee:	eb 05                	jmp    802af5 <alloc_block_FF+0x1aa>
  802af0:	b8 00 00 00 00       	mov    $0x0,%eax
  802af5:	a3 40 51 80 00       	mov    %eax,0x805140
  802afa:	a1 40 51 80 00       	mov    0x805140,%eax
  802aff:	85 c0                	test   %eax,%eax
  802b01:	0f 85 57 fe ff ff    	jne    80295e <alloc_block_FF+0x13>
  802b07:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b0b:	0f 85 4d fe ff ff    	jne    80295e <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802b11:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b16:	c9                   	leave  
  802b17:	c3                   	ret    

00802b18 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802b18:	55                   	push   %ebp
  802b19:	89 e5                	mov    %esp,%ebp
  802b1b:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802b1e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802b25:	a1 38 51 80 00       	mov    0x805138,%eax
  802b2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b2d:	e9 df 00 00 00       	jmp    802c11 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802b32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b35:	8b 40 0c             	mov    0xc(%eax),%eax
  802b38:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b3b:	0f 82 c8 00 00 00    	jb     802c09 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802b41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b44:	8b 40 0c             	mov    0xc(%eax),%eax
  802b47:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b4a:	0f 85 8a 00 00 00    	jne    802bda <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802b50:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b54:	75 17                	jne    802b6d <alloc_block_BF+0x55>
  802b56:	83 ec 04             	sub    $0x4,%esp
  802b59:	68 18 47 80 00       	push   $0x804718
  802b5e:	68 b7 00 00 00       	push   $0xb7
  802b63:	68 6f 46 80 00       	push   $0x80466f
  802b68:	e8 24 dc ff ff       	call   800791 <_panic>
  802b6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b70:	8b 00                	mov    (%eax),%eax
  802b72:	85 c0                	test   %eax,%eax
  802b74:	74 10                	je     802b86 <alloc_block_BF+0x6e>
  802b76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b79:	8b 00                	mov    (%eax),%eax
  802b7b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b7e:	8b 52 04             	mov    0x4(%edx),%edx
  802b81:	89 50 04             	mov    %edx,0x4(%eax)
  802b84:	eb 0b                	jmp    802b91 <alloc_block_BF+0x79>
  802b86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b89:	8b 40 04             	mov    0x4(%eax),%eax
  802b8c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b94:	8b 40 04             	mov    0x4(%eax),%eax
  802b97:	85 c0                	test   %eax,%eax
  802b99:	74 0f                	je     802baa <alloc_block_BF+0x92>
  802b9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9e:	8b 40 04             	mov    0x4(%eax),%eax
  802ba1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ba4:	8b 12                	mov    (%edx),%edx
  802ba6:	89 10                	mov    %edx,(%eax)
  802ba8:	eb 0a                	jmp    802bb4 <alloc_block_BF+0x9c>
  802baa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bad:	8b 00                	mov    (%eax),%eax
  802baf:	a3 38 51 80 00       	mov    %eax,0x805138
  802bb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bc7:	a1 44 51 80 00       	mov    0x805144,%eax
  802bcc:	48                   	dec    %eax
  802bcd:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802bd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd5:	e9 4d 01 00 00       	jmp    802d27 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802bda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bdd:	8b 40 0c             	mov    0xc(%eax),%eax
  802be0:	3b 45 08             	cmp    0x8(%ebp),%eax
  802be3:	76 24                	jbe    802c09 <alloc_block_BF+0xf1>
  802be5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be8:	8b 40 0c             	mov    0xc(%eax),%eax
  802beb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802bee:	73 19                	jae    802c09 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802bf0:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802bf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfa:	8b 40 0c             	mov    0xc(%eax),%eax
  802bfd:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802c00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c03:	8b 40 08             	mov    0x8(%eax),%eax
  802c06:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802c09:	a1 40 51 80 00       	mov    0x805140,%eax
  802c0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c11:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c15:	74 07                	je     802c1e <alloc_block_BF+0x106>
  802c17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1a:	8b 00                	mov    (%eax),%eax
  802c1c:	eb 05                	jmp    802c23 <alloc_block_BF+0x10b>
  802c1e:	b8 00 00 00 00       	mov    $0x0,%eax
  802c23:	a3 40 51 80 00       	mov    %eax,0x805140
  802c28:	a1 40 51 80 00       	mov    0x805140,%eax
  802c2d:	85 c0                	test   %eax,%eax
  802c2f:	0f 85 fd fe ff ff    	jne    802b32 <alloc_block_BF+0x1a>
  802c35:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c39:	0f 85 f3 fe ff ff    	jne    802b32 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802c3f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802c43:	0f 84 d9 00 00 00    	je     802d22 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802c49:	a1 48 51 80 00       	mov    0x805148,%eax
  802c4e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802c51:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c54:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c57:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802c5a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c5d:	8b 55 08             	mov    0x8(%ebp),%edx
  802c60:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802c63:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802c67:	75 17                	jne    802c80 <alloc_block_BF+0x168>
  802c69:	83 ec 04             	sub    $0x4,%esp
  802c6c:	68 18 47 80 00       	push   $0x804718
  802c71:	68 c7 00 00 00       	push   $0xc7
  802c76:	68 6f 46 80 00       	push   $0x80466f
  802c7b:	e8 11 db ff ff       	call   800791 <_panic>
  802c80:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c83:	8b 00                	mov    (%eax),%eax
  802c85:	85 c0                	test   %eax,%eax
  802c87:	74 10                	je     802c99 <alloc_block_BF+0x181>
  802c89:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c8c:	8b 00                	mov    (%eax),%eax
  802c8e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c91:	8b 52 04             	mov    0x4(%edx),%edx
  802c94:	89 50 04             	mov    %edx,0x4(%eax)
  802c97:	eb 0b                	jmp    802ca4 <alloc_block_BF+0x18c>
  802c99:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c9c:	8b 40 04             	mov    0x4(%eax),%eax
  802c9f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ca4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ca7:	8b 40 04             	mov    0x4(%eax),%eax
  802caa:	85 c0                	test   %eax,%eax
  802cac:	74 0f                	je     802cbd <alloc_block_BF+0x1a5>
  802cae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cb1:	8b 40 04             	mov    0x4(%eax),%eax
  802cb4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802cb7:	8b 12                	mov    (%edx),%edx
  802cb9:	89 10                	mov    %edx,(%eax)
  802cbb:	eb 0a                	jmp    802cc7 <alloc_block_BF+0x1af>
  802cbd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cc0:	8b 00                	mov    (%eax),%eax
  802cc2:	a3 48 51 80 00       	mov    %eax,0x805148
  802cc7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cd0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cd3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cda:	a1 54 51 80 00       	mov    0x805154,%eax
  802cdf:	48                   	dec    %eax
  802ce0:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802ce5:	83 ec 08             	sub    $0x8,%esp
  802ce8:	ff 75 ec             	pushl  -0x14(%ebp)
  802ceb:	68 38 51 80 00       	push   $0x805138
  802cf0:	e8 71 f9 ff ff       	call   802666 <find_block>
  802cf5:	83 c4 10             	add    $0x10,%esp
  802cf8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802cfb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cfe:	8b 50 08             	mov    0x8(%eax),%edx
  802d01:	8b 45 08             	mov    0x8(%ebp),%eax
  802d04:	01 c2                	add    %eax,%edx
  802d06:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d09:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802d0c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d0f:	8b 40 0c             	mov    0xc(%eax),%eax
  802d12:	2b 45 08             	sub    0x8(%ebp),%eax
  802d15:	89 c2                	mov    %eax,%edx
  802d17:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d1a:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802d1d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d20:	eb 05                	jmp    802d27 <alloc_block_BF+0x20f>
	}
	return NULL;
  802d22:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d27:	c9                   	leave  
  802d28:	c3                   	ret    

00802d29 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802d29:	55                   	push   %ebp
  802d2a:	89 e5                	mov    %esp,%ebp
  802d2c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802d2f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802d34:	85 c0                	test   %eax,%eax
  802d36:	0f 85 de 01 00 00    	jne    802f1a <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802d3c:	a1 38 51 80 00       	mov    0x805138,%eax
  802d41:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d44:	e9 9e 01 00 00       	jmp    802ee7 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802d49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4c:	8b 40 0c             	mov    0xc(%eax),%eax
  802d4f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d52:	0f 82 87 01 00 00    	jb     802edf <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802d58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5b:	8b 40 0c             	mov    0xc(%eax),%eax
  802d5e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d61:	0f 85 95 00 00 00    	jne    802dfc <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802d67:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d6b:	75 17                	jne    802d84 <alloc_block_NF+0x5b>
  802d6d:	83 ec 04             	sub    $0x4,%esp
  802d70:	68 18 47 80 00       	push   $0x804718
  802d75:	68 e0 00 00 00       	push   $0xe0
  802d7a:	68 6f 46 80 00       	push   $0x80466f
  802d7f:	e8 0d da ff ff       	call   800791 <_panic>
  802d84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d87:	8b 00                	mov    (%eax),%eax
  802d89:	85 c0                	test   %eax,%eax
  802d8b:	74 10                	je     802d9d <alloc_block_NF+0x74>
  802d8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d90:	8b 00                	mov    (%eax),%eax
  802d92:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d95:	8b 52 04             	mov    0x4(%edx),%edx
  802d98:	89 50 04             	mov    %edx,0x4(%eax)
  802d9b:	eb 0b                	jmp    802da8 <alloc_block_NF+0x7f>
  802d9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da0:	8b 40 04             	mov    0x4(%eax),%eax
  802da3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802da8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dab:	8b 40 04             	mov    0x4(%eax),%eax
  802dae:	85 c0                	test   %eax,%eax
  802db0:	74 0f                	je     802dc1 <alloc_block_NF+0x98>
  802db2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db5:	8b 40 04             	mov    0x4(%eax),%eax
  802db8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dbb:	8b 12                	mov    (%edx),%edx
  802dbd:	89 10                	mov    %edx,(%eax)
  802dbf:	eb 0a                	jmp    802dcb <alloc_block_NF+0xa2>
  802dc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc4:	8b 00                	mov    (%eax),%eax
  802dc6:	a3 38 51 80 00       	mov    %eax,0x805138
  802dcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dde:	a1 44 51 80 00       	mov    0x805144,%eax
  802de3:	48                   	dec    %eax
  802de4:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802de9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dec:	8b 40 08             	mov    0x8(%eax),%eax
  802def:	a3 2c 50 80 00       	mov    %eax,0x80502c
				   return  point;
  802df4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df7:	e9 f8 04 00 00       	jmp    8032f4 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802dfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dff:	8b 40 0c             	mov    0xc(%eax),%eax
  802e02:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e05:	0f 86 d4 00 00 00    	jbe    802edf <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802e0b:	a1 48 51 80 00       	mov    0x805148,%eax
  802e10:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802e13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e16:	8b 50 08             	mov    0x8(%eax),%edx
  802e19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e1c:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802e1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e22:	8b 55 08             	mov    0x8(%ebp),%edx
  802e25:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802e28:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e2c:	75 17                	jne    802e45 <alloc_block_NF+0x11c>
  802e2e:	83 ec 04             	sub    $0x4,%esp
  802e31:	68 18 47 80 00       	push   $0x804718
  802e36:	68 e9 00 00 00       	push   $0xe9
  802e3b:	68 6f 46 80 00       	push   $0x80466f
  802e40:	e8 4c d9 ff ff       	call   800791 <_panic>
  802e45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e48:	8b 00                	mov    (%eax),%eax
  802e4a:	85 c0                	test   %eax,%eax
  802e4c:	74 10                	je     802e5e <alloc_block_NF+0x135>
  802e4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e51:	8b 00                	mov    (%eax),%eax
  802e53:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e56:	8b 52 04             	mov    0x4(%edx),%edx
  802e59:	89 50 04             	mov    %edx,0x4(%eax)
  802e5c:	eb 0b                	jmp    802e69 <alloc_block_NF+0x140>
  802e5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e61:	8b 40 04             	mov    0x4(%eax),%eax
  802e64:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e6c:	8b 40 04             	mov    0x4(%eax),%eax
  802e6f:	85 c0                	test   %eax,%eax
  802e71:	74 0f                	je     802e82 <alloc_block_NF+0x159>
  802e73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e76:	8b 40 04             	mov    0x4(%eax),%eax
  802e79:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e7c:	8b 12                	mov    (%edx),%edx
  802e7e:	89 10                	mov    %edx,(%eax)
  802e80:	eb 0a                	jmp    802e8c <alloc_block_NF+0x163>
  802e82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e85:	8b 00                	mov    (%eax),%eax
  802e87:	a3 48 51 80 00       	mov    %eax,0x805148
  802e8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e8f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e98:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e9f:	a1 54 51 80 00       	mov    0x805154,%eax
  802ea4:	48                   	dec    %eax
  802ea5:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802eaa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ead:	8b 40 08             	mov    0x8(%eax),%eax
  802eb0:	a3 2c 50 80 00       	mov    %eax,0x80502c
				   point->sva += size;
  802eb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb8:	8b 50 08             	mov    0x8(%eax),%edx
  802ebb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebe:	01 c2                	add    %eax,%edx
  802ec0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec3:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802ec6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec9:	8b 40 0c             	mov    0xc(%eax),%eax
  802ecc:	2b 45 08             	sub    0x8(%ebp),%eax
  802ecf:	89 c2                	mov    %eax,%edx
  802ed1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed4:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802ed7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eda:	e9 15 04 00 00       	jmp    8032f4 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802edf:	a1 40 51 80 00       	mov    0x805140,%eax
  802ee4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ee7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802eeb:	74 07                	je     802ef4 <alloc_block_NF+0x1cb>
  802eed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef0:	8b 00                	mov    (%eax),%eax
  802ef2:	eb 05                	jmp    802ef9 <alloc_block_NF+0x1d0>
  802ef4:	b8 00 00 00 00       	mov    $0x0,%eax
  802ef9:	a3 40 51 80 00       	mov    %eax,0x805140
  802efe:	a1 40 51 80 00       	mov    0x805140,%eax
  802f03:	85 c0                	test   %eax,%eax
  802f05:	0f 85 3e fe ff ff    	jne    802d49 <alloc_block_NF+0x20>
  802f0b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f0f:	0f 85 34 fe ff ff    	jne    802d49 <alloc_block_NF+0x20>
  802f15:	e9 d5 03 00 00       	jmp    8032ef <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802f1a:	a1 38 51 80 00       	mov    0x805138,%eax
  802f1f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f22:	e9 b1 01 00 00       	jmp    8030d8 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802f27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2a:	8b 50 08             	mov    0x8(%eax),%edx
  802f2d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802f32:	39 c2                	cmp    %eax,%edx
  802f34:	0f 82 96 01 00 00    	jb     8030d0 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802f3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3d:	8b 40 0c             	mov    0xc(%eax),%eax
  802f40:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f43:	0f 82 87 01 00 00    	jb     8030d0 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802f49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4c:	8b 40 0c             	mov    0xc(%eax),%eax
  802f4f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f52:	0f 85 95 00 00 00    	jne    802fed <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802f58:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f5c:	75 17                	jne    802f75 <alloc_block_NF+0x24c>
  802f5e:	83 ec 04             	sub    $0x4,%esp
  802f61:	68 18 47 80 00       	push   $0x804718
  802f66:	68 fc 00 00 00       	push   $0xfc
  802f6b:	68 6f 46 80 00       	push   $0x80466f
  802f70:	e8 1c d8 ff ff       	call   800791 <_panic>
  802f75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f78:	8b 00                	mov    (%eax),%eax
  802f7a:	85 c0                	test   %eax,%eax
  802f7c:	74 10                	je     802f8e <alloc_block_NF+0x265>
  802f7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f81:	8b 00                	mov    (%eax),%eax
  802f83:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f86:	8b 52 04             	mov    0x4(%edx),%edx
  802f89:	89 50 04             	mov    %edx,0x4(%eax)
  802f8c:	eb 0b                	jmp    802f99 <alloc_block_NF+0x270>
  802f8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f91:	8b 40 04             	mov    0x4(%eax),%eax
  802f94:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f9c:	8b 40 04             	mov    0x4(%eax),%eax
  802f9f:	85 c0                	test   %eax,%eax
  802fa1:	74 0f                	je     802fb2 <alloc_block_NF+0x289>
  802fa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa6:	8b 40 04             	mov    0x4(%eax),%eax
  802fa9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fac:	8b 12                	mov    (%edx),%edx
  802fae:	89 10                	mov    %edx,(%eax)
  802fb0:	eb 0a                	jmp    802fbc <alloc_block_NF+0x293>
  802fb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb5:	8b 00                	mov    (%eax),%eax
  802fb7:	a3 38 51 80 00       	mov    %eax,0x805138
  802fbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fbf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fcf:	a1 44 51 80 00       	mov    0x805144,%eax
  802fd4:	48                   	dec    %eax
  802fd5:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802fda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fdd:	8b 40 08             	mov    0x8(%eax),%eax
  802fe0:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   return  point;
  802fe5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe8:	e9 07 03 00 00       	jmp    8032f4 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802fed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff0:	8b 40 0c             	mov    0xc(%eax),%eax
  802ff3:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ff6:	0f 86 d4 00 00 00    	jbe    8030d0 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802ffc:	a1 48 51 80 00       	mov    0x805148,%eax
  803001:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  803004:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803007:	8b 50 08             	mov    0x8(%eax),%edx
  80300a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80300d:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  803010:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803013:	8b 55 08             	mov    0x8(%ebp),%edx
  803016:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803019:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80301d:	75 17                	jne    803036 <alloc_block_NF+0x30d>
  80301f:	83 ec 04             	sub    $0x4,%esp
  803022:	68 18 47 80 00       	push   $0x804718
  803027:	68 04 01 00 00       	push   $0x104
  80302c:	68 6f 46 80 00       	push   $0x80466f
  803031:	e8 5b d7 ff ff       	call   800791 <_panic>
  803036:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803039:	8b 00                	mov    (%eax),%eax
  80303b:	85 c0                	test   %eax,%eax
  80303d:	74 10                	je     80304f <alloc_block_NF+0x326>
  80303f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803042:	8b 00                	mov    (%eax),%eax
  803044:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803047:	8b 52 04             	mov    0x4(%edx),%edx
  80304a:	89 50 04             	mov    %edx,0x4(%eax)
  80304d:	eb 0b                	jmp    80305a <alloc_block_NF+0x331>
  80304f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803052:	8b 40 04             	mov    0x4(%eax),%eax
  803055:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80305a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80305d:	8b 40 04             	mov    0x4(%eax),%eax
  803060:	85 c0                	test   %eax,%eax
  803062:	74 0f                	je     803073 <alloc_block_NF+0x34a>
  803064:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803067:	8b 40 04             	mov    0x4(%eax),%eax
  80306a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80306d:	8b 12                	mov    (%edx),%edx
  80306f:	89 10                	mov    %edx,(%eax)
  803071:	eb 0a                	jmp    80307d <alloc_block_NF+0x354>
  803073:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803076:	8b 00                	mov    (%eax),%eax
  803078:	a3 48 51 80 00       	mov    %eax,0x805148
  80307d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803080:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803086:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803089:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803090:	a1 54 51 80 00       	mov    0x805154,%eax
  803095:	48                   	dec    %eax
  803096:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  80309b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80309e:	8b 40 08             	mov    0x8(%eax),%eax
  8030a1:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   point->sva += size;
  8030a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a9:	8b 50 08             	mov    0x8(%eax),%edx
  8030ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8030af:	01 c2                	add    %eax,%edx
  8030b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b4:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8030b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ba:	8b 40 0c             	mov    0xc(%eax),%eax
  8030bd:	2b 45 08             	sub    0x8(%ebp),%eax
  8030c0:	89 c2                	mov    %eax,%edx
  8030c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c5:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8030c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030cb:	e9 24 02 00 00       	jmp    8032f4 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8030d0:	a1 40 51 80 00       	mov    0x805140,%eax
  8030d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030d8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030dc:	74 07                	je     8030e5 <alloc_block_NF+0x3bc>
  8030de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e1:	8b 00                	mov    (%eax),%eax
  8030e3:	eb 05                	jmp    8030ea <alloc_block_NF+0x3c1>
  8030e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8030ea:	a3 40 51 80 00       	mov    %eax,0x805140
  8030ef:	a1 40 51 80 00       	mov    0x805140,%eax
  8030f4:	85 c0                	test   %eax,%eax
  8030f6:	0f 85 2b fe ff ff    	jne    802f27 <alloc_block_NF+0x1fe>
  8030fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803100:	0f 85 21 fe ff ff    	jne    802f27 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803106:	a1 38 51 80 00       	mov    0x805138,%eax
  80310b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80310e:	e9 ae 01 00 00       	jmp    8032c1 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  803113:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803116:	8b 50 08             	mov    0x8(%eax),%edx
  803119:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80311e:	39 c2                	cmp    %eax,%edx
  803120:	0f 83 93 01 00 00    	jae    8032b9 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  803126:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803129:	8b 40 0c             	mov    0xc(%eax),%eax
  80312c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80312f:	0f 82 84 01 00 00    	jb     8032b9 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  803135:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803138:	8b 40 0c             	mov    0xc(%eax),%eax
  80313b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80313e:	0f 85 95 00 00 00    	jne    8031d9 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  803144:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803148:	75 17                	jne    803161 <alloc_block_NF+0x438>
  80314a:	83 ec 04             	sub    $0x4,%esp
  80314d:	68 18 47 80 00       	push   $0x804718
  803152:	68 14 01 00 00       	push   $0x114
  803157:	68 6f 46 80 00       	push   $0x80466f
  80315c:	e8 30 d6 ff ff       	call   800791 <_panic>
  803161:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803164:	8b 00                	mov    (%eax),%eax
  803166:	85 c0                	test   %eax,%eax
  803168:	74 10                	je     80317a <alloc_block_NF+0x451>
  80316a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80316d:	8b 00                	mov    (%eax),%eax
  80316f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803172:	8b 52 04             	mov    0x4(%edx),%edx
  803175:	89 50 04             	mov    %edx,0x4(%eax)
  803178:	eb 0b                	jmp    803185 <alloc_block_NF+0x45c>
  80317a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80317d:	8b 40 04             	mov    0x4(%eax),%eax
  803180:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803185:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803188:	8b 40 04             	mov    0x4(%eax),%eax
  80318b:	85 c0                	test   %eax,%eax
  80318d:	74 0f                	je     80319e <alloc_block_NF+0x475>
  80318f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803192:	8b 40 04             	mov    0x4(%eax),%eax
  803195:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803198:	8b 12                	mov    (%edx),%edx
  80319a:	89 10                	mov    %edx,(%eax)
  80319c:	eb 0a                	jmp    8031a8 <alloc_block_NF+0x47f>
  80319e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a1:	8b 00                	mov    (%eax),%eax
  8031a3:	a3 38 51 80 00       	mov    %eax,0x805138
  8031a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031bb:	a1 44 51 80 00       	mov    0x805144,%eax
  8031c0:	48                   	dec    %eax
  8031c1:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8031c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c9:	8b 40 08             	mov    0x8(%eax),%eax
  8031cc:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   return  point;
  8031d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d4:	e9 1b 01 00 00       	jmp    8032f4 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8031d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031dc:	8b 40 0c             	mov    0xc(%eax),%eax
  8031df:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031e2:	0f 86 d1 00 00 00    	jbe    8032b9 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8031e8:	a1 48 51 80 00       	mov    0x805148,%eax
  8031ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  8031f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f3:	8b 50 08             	mov    0x8(%eax),%edx
  8031f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031f9:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8031fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031ff:	8b 55 08             	mov    0x8(%ebp),%edx
  803202:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803205:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803209:	75 17                	jne    803222 <alloc_block_NF+0x4f9>
  80320b:	83 ec 04             	sub    $0x4,%esp
  80320e:	68 18 47 80 00       	push   $0x804718
  803213:	68 1c 01 00 00       	push   $0x11c
  803218:	68 6f 46 80 00       	push   $0x80466f
  80321d:	e8 6f d5 ff ff       	call   800791 <_panic>
  803222:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803225:	8b 00                	mov    (%eax),%eax
  803227:	85 c0                	test   %eax,%eax
  803229:	74 10                	je     80323b <alloc_block_NF+0x512>
  80322b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80322e:	8b 00                	mov    (%eax),%eax
  803230:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803233:	8b 52 04             	mov    0x4(%edx),%edx
  803236:	89 50 04             	mov    %edx,0x4(%eax)
  803239:	eb 0b                	jmp    803246 <alloc_block_NF+0x51d>
  80323b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80323e:	8b 40 04             	mov    0x4(%eax),%eax
  803241:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803246:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803249:	8b 40 04             	mov    0x4(%eax),%eax
  80324c:	85 c0                	test   %eax,%eax
  80324e:	74 0f                	je     80325f <alloc_block_NF+0x536>
  803250:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803253:	8b 40 04             	mov    0x4(%eax),%eax
  803256:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803259:	8b 12                	mov    (%edx),%edx
  80325b:	89 10                	mov    %edx,(%eax)
  80325d:	eb 0a                	jmp    803269 <alloc_block_NF+0x540>
  80325f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803262:	8b 00                	mov    (%eax),%eax
  803264:	a3 48 51 80 00       	mov    %eax,0x805148
  803269:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80326c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803272:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803275:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80327c:	a1 54 51 80 00       	mov    0x805154,%eax
  803281:	48                   	dec    %eax
  803282:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  803287:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80328a:	8b 40 08             	mov    0x8(%eax),%eax
  80328d:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   point->sva += size;
  803292:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803295:	8b 50 08             	mov    0x8(%eax),%edx
  803298:	8b 45 08             	mov    0x8(%ebp),%eax
  80329b:	01 c2                	add    %eax,%edx
  80329d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a0:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8032a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a6:	8b 40 0c             	mov    0xc(%eax),%eax
  8032a9:	2b 45 08             	sub    0x8(%ebp),%eax
  8032ac:	89 c2                	mov    %eax,%edx
  8032ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b1:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8032b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032b7:	eb 3b                	jmp    8032f4 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8032b9:	a1 40 51 80 00       	mov    0x805140,%eax
  8032be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032c5:	74 07                	je     8032ce <alloc_block_NF+0x5a5>
  8032c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ca:	8b 00                	mov    (%eax),%eax
  8032cc:	eb 05                	jmp    8032d3 <alloc_block_NF+0x5aa>
  8032ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8032d3:	a3 40 51 80 00       	mov    %eax,0x805140
  8032d8:	a1 40 51 80 00       	mov    0x805140,%eax
  8032dd:	85 c0                	test   %eax,%eax
  8032df:	0f 85 2e fe ff ff    	jne    803113 <alloc_block_NF+0x3ea>
  8032e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032e9:	0f 85 24 fe ff ff    	jne    803113 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  8032ef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8032f4:	c9                   	leave  
  8032f5:	c3                   	ret    

008032f6 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8032f6:	55                   	push   %ebp
  8032f7:	89 e5                	mov    %esp,%ebp
  8032f9:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  8032fc:	a1 38 51 80 00       	mov    0x805138,%eax
  803301:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  803304:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803309:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  80330c:	a1 38 51 80 00       	mov    0x805138,%eax
  803311:	85 c0                	test   %eax,%eax
  803313:	74 14                	je     803329 <insert_sorted_with_merge_freeList+0x33>
  803315:	8b 45 08             	mov    0x8(%ebp),%eax
  803318:	8b 50 08             	mov    0x8(%eax),%edx
  80331b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80331e:	8b 40 08             	mov    0x8(%eax),%eax
  803321:	39 c2                	cmp    %eax,%edx
  803323:	0f 87 9b 01 00 00    	ja     8034c4 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  803329:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80332d:	75 17                	jne    803346 <insert_sorted_with_merge_freeList+0x50>
  80332f:	83 ec 04             	sub    $0x4,%esp
  803332:	68 4c 46 80 00       	push   $0x80464c
  803337:	68 38 01 00 00       	push   $0x138
  80333c:	68 6f 46 80 00       	push   $0x80466f
  803341:	e8 4b d4 ff ff       	call   800791 <_panic>
  803346:	8b 15 38 51 80 00    	mov    0x805138,%edx
  80334c:	8b 45 08             	mov    0x8(%ebp),%eax
  80334f:	89 10                	mov    %edx,(%eax)
  803351:	8b 45 08             	mov    0x8(%ebp),%eax
  803354:	8b 00                	mov    (%eax),%eax
  803356:	85 c0                	test   %eax,%eax
  803358:	74 0d                	je     803367 <insert_sorted_with_merge_freeList+0x71>
  80335a:	a1 38 51 80 00       	mov    0x805138,%eax
  80335f:	8b 55 08             	mov    0x8(%ebp),%edx
  803362:	89 50 04             	mov    %edx,0x4(%eax)
  803365:	eb 08                	jmp    80336f <insert_sorted_with_merge_freeList+0x79>
  803367:	8b 45 08             	mov    0x8(%ebp),%eax
  80336a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80336f:	8b 45 08             	mov    0x8(%ebp),%eax
  803372:	a3 38 51 80 00       	mov    %eax,0x805138
  803377:	8b 45 08             	mov    0x8(%ebp),%eax
  80337a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803381:	a1 44 51 80 00       	mov    0x805144,%eax
  803386:	40                   	inc    %eax
  803387:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80338c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803390:	0f 84 a8 06 00 00    	je     803a3e <insert_sorted_with_merge_freeList+0x748>
  803396:	8b 45 08             	mov    0x8(%ebp),%eax
  803399:	8b 50 08             	mov    0x8(%eax),%edx
  80339c:	8b 45 08             	mov    0x8(%ebp),%eax
  80339f:	8b 40 0c             	mov    0xc(%eax),%eax
  8033a2:	01 c2                	add    %eax,%edx
  8033a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033a7:	8b 40 08             	mov    0x8(%eax),%eax
  8033aa:	39 c2                	cmp    %eax,%edx
  8033ac:	0f 85 8c 06 00 00    	jne    803a3e <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  8033b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b5:	8b 50 0c             	mov    0xc(%eax),%edx
  8033b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033bb:	8b 40 0c             	mov    0xc(%eax),%eax
  8033be:	01 c2                	add    %eax,%edx
  8033c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c3:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  8033c6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8033ca:	75 17                	jne    8033e3 <insert_sorted_with_merge_freeList+0xed>
  8033cc:	83 ec 04             	sub    $0x4,%esp
  8033cf:	68 18 47 80 00       	push   $0x804718
  8033d4:	68 3c 01 00 00       	push   $0x13c
  8033d9:	68 6f 46 80 00       	push   $0x80466f
  8033de:	e8 ae d3 ff ff       	call   800791 <_panic>
  8033e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033e6:	8b 00                	mov    (%eax),%eax
  8033e8:	85 c0                	test   %eax,%eax
  8033ea:	74 10                	je     8033fc <insert_sorted_with_merge_freeList+0x106>
  8033ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033ef:	8b 00                	mov    (%eax),%eax
  8033f1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8033f4:	8b 52 04             	mov    0x4(%edx),%edx
  8033f7:	89 50 04             	mov    %edx,0x4(%eax)
  8033fa:	eb 0b                	jmp    803407 <insert_sorted_with_merge_freeList+0x111>
  8033fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033ff:	8b 40 04             	mov    0x4(%eax),%eax
  803402:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803407:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80340a:	8b 40 04             	mov    0x4(%eax),%eax
  80340d:	85 c0                	test   %eax,%eax
  80340f:	74 0f                	je     803420 <insert_sorted_with_merge_freeList+0x12a>
  803411:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803414:	8b 40 04             	mov    0x4(%eax),%eax
  803417:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80341a:	8b 12                	mov    (%edx),%edx
  80341c:	89 10                	mov    %edx,(%eax)
  80341e:	eb 0a                	jmp    80342a <insert_sorted_with_merge_freeList+0x134>
  803420:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803423:	8b 00                	mov    (%eax),%eax
  803425:	a3 38 51 80 00       	mov    %eax,0x805138
  80342a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80342d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803433:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803436:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80343d:	a1 44 51 80 00       	mov    0x805144,%eax
  803442:	48                   	dec    %eax
  803443:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  803448:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80344b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  803452:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803455:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  80345c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803460:	75 17                	jne    803479 <insert_sorted_with_merge_freeList+0x183>
  803462:	83 ec 04             	sub    $0x4,%esp
  803465:	68 4c 46 80 00       	push   $0x80464c
  80346a:	68 3f 01 00 00       	push   $0x13f
  80346f:	68 6f 46 80 00       	push   $0x80466f
  803474:	e8 18 d3 ff ff       	call   800791 <_panic>
  803479:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80347f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803482:	89 10                	mov    %edx,(%eax)
  803484:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803487:	8b 00                	mov    (%eax),%eax
  803489:	85 c0                	test   %eax,%eax
  80348b:	74 0d                	je     80349a <insert_sorted_with_merge_freeList+0x1a4>
  80348d:	a1 48 51 80 00       	mov    0x805148,%eax
  803492:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803495:	89 50 04             	mov    %edx,0x4(%eax)
  803498:	eb 08                	jmp    8034a2 <insert_sorted_with_merge_freeList+0x1ac>
  80349a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80349d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8034a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034a5:	a3 48 51 80 00       	mov    %eax,0x805148
  8034aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034ad:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034b4:	a1 54 51 80 00       	mov    0x805154,%eax
  8034b9:	40                   	inc    %eax
  8034ba:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8034bf:	e9 7a 05 00 00       	jmp    803a3e <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  8034c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c7:	8b 50 08             	mov    0x8(%eax),%edx
  8034ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034cd:	8b 40 08             	mov    0x8(%eax),%eax
  8034d0:	39 c2                	cmp    %eax,%edx
  8034d2:	0f 82 14 01 00 00    	jb     8035ec <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  8034d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034db:	8b 50 08             	mov    0x8(%eax),%edx
  8034de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034e1:	8b 40 0c             	mov    0xc(%eax),%eax
  8034e4:	01 c2                	add    %eax,%edx
  8034e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e9:	8b 40 08             	mov    0x8(%eax),%eax
  8034ec:	39 c2                	cmp    %eax,%edx
  8034ee:	0f 85 90 00 00 00    	jne    803584 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  8034f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034f7:	8b 50 0c             	mov    0xc(%eax),%edx
  8034fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8034fd:	8b 40 0c             	mov    0xc(%eax),%eax
  803500:	01 c2                	add    %eax,%edx
  803502:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803505:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  803508:	8b 45 08             	mov    0x8(%ebp),%eax
  80350b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  803512:	8b 45 08             	mov    0x8(%ebp),%eax
  803515:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80351c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803520:	75 17                	jne    803539 <insert_sorted_with_merge_freeList+0x243>
  803522:	83 ec 04             	sub    $0x4,%esp
  803525:	68 4c 46 80 00       	push   $0x80464c
  80352a:	68 49 01 00 00       	push   $0x149
  80352f:	68 6f 46 80 00       	push   $0x80466f
  803534:	e8 58 d2 ff ff       	call   800791 <_panic>
  803539:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80353f:	8b 45 08             	mov    0x8(%ebp),%eax
  803542:	89 10                	mov    %edx,(%eax)
  803544:	8b 45 08             	mov    0x8(%ebp),%eax
  803547:	8b 00                	mov    (%eax),%eax
  803549:	85 c0                	test   %eax,%eax
  80354b:	74 0d                	je     80355a <insert_sorted_with_merge_freeList+0x264>
  80354d:	a1 48 51 80 00       	mov    0x805148,%eax
  803552:	8b 55 08             	mov    0x8(%ebp),%edx
  803555:	89 50 04             	mov    %edx,0x4(%eax)
  803558:	eb 08                	jmp    803562 <insert_sorted_with_merge_freeList+0x26c>
  80355a:	8b 45 08             	mov    0x8(%ebp),%eax
  80355d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803562:	8b 45 08             	mov    0x8(%ebp),%eax
  803565:	a3 48 51 80 00       	mov    %eax,0x805148
  80356a:	8b 45 08             	mov    0x8(%ebp),%eax
  80356d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803574:	a1 54 51 80 00       	mov    0x805154,%eax
  803579:	40                   	inc    %eax
  80357a:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80357f:	e9 bb 04 00 00       	jmp    803a3f <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803584:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803588:	75 17                	jne    8035a1 <insert_sorted_with_merge_freeList+0x2ab>
  80358a:	83 ec 04             	sub    $0x4,%esp
  80358d:	68 c0 46 80 00       	push   $0x8046c0
  803592:	68 4c 01 00 00       	push   $0x14c
  803597:	68 6f 46 80 00       	push   $0x80466f
  80359c:	e8 f0 d1 ff ff       	call   800791 <_panic>
  8035a1:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8035a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8035aa:	89 50 04             	mov    %edx,0x4(%eax)
  8035ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b0:	8b 40 04             	mov    0x4(%eax),%eax
  8035b3:	85 c0                	test   %eax,%eax
  8035b5:	74 0c                	je     8035c3 <insert_sorted_with_merge_freeList+0x2cd>
  8035b7:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8035bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8035bf:	89 10                	mov    %edx,(%eax)
  8035c1:	eb 08                	jmp    8035cb <insert_sorted_with_merge_freeList+0x2d5>
  8035c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c6:	a3 38 51 80 00       	mov    %eax,0x805138
  8035cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ce:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8035d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035dc:	a1 44 51 80 00       	mov    0x805144,%eax
  8035e1:	40                   	inc    %eax
  8035e2:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8035e7:	e9 53 04 00 00       	jmp    803a3f <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8035ec:	a1 38 51 80 00       	mov    0x805138,%eax
  8035f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8035f4:	e9 15 04 00 00       	jmp    803a0e <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  8035f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035fc:	8b 00                	mov    (%eax),%eax
  8035fe:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803601:	8b 45 08             	mov    0x8(%ebp),%eax
  803604:	8b 50 08             	mov    0x8(%eax),%edx
  803607:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80360a:	8b 40 08             	mov    0x8(%eax),%eax
  80360d:	39 c2                	cmp    %eax,%edx
  80360f:	0f 86 f1 03 00 00    	jbe    803a06 <insert_sorted_with_merge_freeList+0x710>
  803615:	8b 45 08             	mov    0x8(%ebp),%eax
  803618:	8b 50 08             	mov    0x8(%eax),%edx
  80361b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80361e:	8b 40 08             	mov    0x8(%eax),%eax
  803621:	39 c2                	cmp    %eax,%edx
  803623:	0f 83 dd 03 00 00    	jae    803a06 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803629:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80362c:	8b 50 08             	mov    0x8(%eax),%edx
  80362f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803632:	8b 40 0c             	mov    0xc(%eax),%eax
  803635:	01 c2                	add    %eax,%edx
  803637:	8b 45 08             	mov    0x8(%ebp),%eax
  80363a:	8b 40 08             	mov    0x8(%eax),%eax
  80363d:	39 c2                	cmp    %eax,%edx
  80363f:	0f 85 b9 01 00 00    	jne    8037fe <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803645:	8b 45 08             	mov    0x8(%ebp),%eax
  803648:	8b 50 08             	mov    0x8(%eax),%edx
  80364b:	8b 45 08             	mov    0x8(%ebp),%eax
  80364e:	8b 40 0c             	mov    0xc(%eax),%eax
  803651:	01 c2                	add    %eax,%edx
  803653:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803656:	8b 40 08             	mov    0x8(%eax),%eax
  803659:	39 c2                	cmp    %eax,%edx
  80365b:	0f 85 0d 01 00 00    	jne    80376e <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803661:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803664:	8b 50 0c             	mov    0xc(%eax),%edx
  803667:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80366a:	8b 40 0c             	mov    0xc(%eax),%eax
  80366d:	01 c2                	add    %eax,%edx
  80366f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803672:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803675:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803679:	75 17                	jne    803692 <insert_sorted_with_merge_freeList+0x39c>
  80367b:	83 ec 04             	sub    $0x4,%esp
  80367e:	68 18 47 80 00       	push   $0x804718
  803683:	68 5c 01 00 00       	push   $0x15c
  803688:	68 6f 46 80 00       	push   $0x80466f
  80368d:	e8 ff d0 ff ff       	call   800791 <_panic>
  803692:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803695:	8b 00                	mov    (%eax),%eax
  803697:	85 c0                	test   %eax,%eax
  803699:	74 10                	je     8036ab <insert_sorted_with_merge_freeList+0x3b5>
  80369b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80369e:	8b 00                	mov    (%eax),%eax
  8036a0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8036a3:	8b 52 04             	mov    0x4(%edx),%edx
  8036a6:	89 50 04             	mov    %edx,0x4(%eax)
  8036a9:	eb 0b                	jmp    8036b6 <insert_sorted_with_merge_freeList+0x3c0>
  8036ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036ae:	8b 40 04             	mov    0x4(%eax),%eax
  8036b1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8036b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036b9:	8b 40 04             	mov    0x4(%eax),%eax
  8036bc:	85 c0                	test   %eax,%eax
  8036be:	74 0f                	je     8036cf <insert_sorted_with_merge_freeList+0x3d9>
  8036c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036c3:	8b 40 04             	mov    0x4(%eax),%eax
  8036c6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8036c9:	8b 12                	mov    (%edx),%edx
  8036cb:	89 10                	mov    %edx,(%eax)
  8036cd:	eb 0a                	jmp    8036d9 <insert_sorted_with_merge_freeList+0x3e3>
  8036cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036d2:	8b 00                	mov    (%eax),%eax
  8036d4:	a3 38 51 80 00       	mov    %eax,0x805138
  8036d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036dc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036e5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036ec:	a1 44 51 80 00       	mov    0x805144,%eax
  8036f1:	48                   	dec    %eax
  8036f2:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  8036f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036fa:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803701:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803704:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80370b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80370f:	75 17                	jne    803728 <insert_sorted_with_merge_freeList+0x432>
  803711:	83 ec 04             	sub    $0x4,%esp
  803714:	68 4c 46 80 00       	push   $0x80464c
  803719:	68 5f 01 00 00       	push   $0x15f
  80371e:	68 6f 46 80 00       	push   $0x80466f
  803723:	e8 69 d0 ff ff       	call   800791 <_panic>
  803728:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80372e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803731:	89 10                	mov    %edx,(%eax)
  803733:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803736:	8b 00                	mov    (%eax),%eax
  803738:	85 c0                	test   %eax,%eax
  80373a:	74 0d                	je     803749 <insert_sorted_with_merge_freeList+0x453>
  80373c:	a1 48 51 80 00       	mov    0x805148,%eax
  803741:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803744:	89 50 04             	mov    %edx,0x4(%eax)
  803747:	eb 08                	jmp    803751 <insert_sorted_with_merge_freeList+0x45b>
  803749:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80374c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803751:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803754:	a3 48 51 80 00       	mov    %eax,0x805148
  803759:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80375c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803763:	a1 54 51 80 00       	mov    0x805154,%eax
  803768:	40                   	inc    %eax
  803769:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  80376e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803771:	8b 50 0c             	mov    0xc(%eax),%edx
  803774:	8b 45 08             	mov    0x8(%ebp),%eax
  803777:	8b 40 0c             	mov    0xc(%eax),%eax
  80377a:	01 c2                	add    %eax,%edx
  80377c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80377f:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803782:	8b 45 08             	mov    0x8(%ebp),%eax
  803785:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  80378c:	8b 45 08             	mov    0x8(%ebp),%eax
  80378f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803796:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80379a:	75 17                	jne    8037b3 <insert_sorted_with_merge_freeList+0x4bd>
  80379c:	83 ec 04             	sub    $0x4,%esp
  80379f:	68 4c 46 80 00       	push   $0x80464c
  8037a4:	68 64 01 00 00       	push   $0x164
  8037a9:	68 6f 46 80 00       	push   $0x80466f
  8037ae:	e8 de cf ff ff       	call   800791 <_panic>
  8037b3:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8037b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8037bc:	89 10                	mov    %edx,(%eax)
  8037be:	8b 45 08             	mov    0x8(%ebp),%eax
  8037c1:	8b 00                	mov    (%eax),%eax
  8037c3:	85 c0                	test   %eax,%eax
  8037c5:	74 0d                	je     8037d4 <insert_sorted_with_merge_freeList+0x4de>
  8037c7:	a1 48 51 80 00       	mov    0x805148,%eax
  8037cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8037cf:	89 50 04             	mov    %edx,0x4(%eax)
  8037d2:	eb 08                	jmp    8037dc <insert_sorted_with_merge_freeList+0x4e6>
  8037d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8037d7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8037dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8037df:	a3 48 51 80 00       	mov    %eax,0x805148
  8037e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8037e7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037ee:	a1 54 51 80 00       	mov    0x805154,%eax
  8037f3:	40                   	inc    %eax
  8037f4:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8037f9:	e9 41 02 00 00       	jmp    803a3f <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8037fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803801:	8b 50 08             	mov    0x8(%eax),%edx
  803804:	8b 45 08             	mov    0x8(%ebp),%eax
  803807:	8b 40 0c             	mov    0xc(%eax),%eax
  80380a:	01 c2                	add    %eax,%edx
  80380c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80380f:	8b 40 08             	mov    0x8(%eax),%eax
  803812:	39 c2                	cmp    %eax,%edx
  803814:	0f 85 7c 01 00 00    	jne    803996 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  80381a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80381e:	74 06                	je     803826 <insert_sorted_with_merge_freeList+0x530>
  803820:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803824:	75 17                	jne    80383d <insert_sorted_with_merge_freeList+0x547>
  803826:	83 ec 04             	sub    $0x4,%esp
  803829:	68 88 46 80 00       	push   $0x804688
  80382e:	68 69 01 00 00       	push   $0x169
  803833:	68 6f 46 80 00       	push   $0x80466f
  803838:	e8 54 cf ff ff       	call   800791 <_panic>
  80383d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803840:	8b 50 04             	mov    0x4(%eax),%edx
  803843:	8b 45 08             	mov    0x8(%ebp),%eax
  803846:	89 50 04             	mov    %edx,0x4(%eax)
  803849:	8b 45 08             	mov    0x8(%ebp),%eax
  80384c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80384f:	89 10                	mov    %edx,(%eax)
  803851:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803854:	8b 40 04             	mov    0x4(%eax),%eax
  803857:	85 c0                	test   %eax,%eax
  803859:	74 0d                	je     803868 <insert_sorted_with_merge_freeList+0x572>
  80385b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80385e:	8b 40 04             	mov    0x4(%eax),%eax
  803861:	8b 55 08             	mov    0x8(%ebp),%edx
  803864:	89 10                	mov    %edx,(%eax)
  803866:	eb 08                	jmp    803870 <insert_sorted_with_merge_freeList+0x57a>
  803868:	8b 45 08             	mov    0x8(%ebp),%eax
  80386b:	a3 38 51 80 00       	mov    %eax,0x805138
  803870:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803873:	8b 55 08             	mov    0x8(%ebp),%edx
  803876:	89 50 04             	mov    %edx,0x4(%eax)
  803879:	a1 44 51 80 00       	mov    0x805144,%eax
  80387e:	40                   	inc    %eax
  80387f:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803884:	8b 45 08             	mov    0x8(%ebp),%eax
  803887:	8b 50 0c             	mov    0xc(%eax),%edx
  80388a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80388d:	8b 40 0c             	mov    0xc(%eax),%eax
  803890:	01 c2                	add    %eax,%edx
  803892:	8b 45 08             	mov    0x8(%ebp),%eax
  803895:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803898:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80389c:	75 17                	jne    8038b5 <insert_sorted_with_merge_freeList+0x5bf>
  80389e:	83 ec 04             	sub    $0x4,%esp
  8038a1:	68 18 47 80 00       	push   $0x804718
  8038a6:	68 6b 01 00 00       	push   $0x16b
  8038ab:	68 6f 46 80 00       	push   $0x80466f
  8038b0:	e8 dc ce ff ff       	call   800791 <_panic>
  8038b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038b8:	8b 00                	mov    (%eax),%eax
  8038ba:	85 c0                	test   %eax,%eax
  8038bc:	74 10                	je     8038ce <insert_sorted_with_merge_freeList+0x5d8>
  8038be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038c1:	8b 00                	mov    (%eax),%eax
  8038c3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8038c6:	8b 52 04             	mov    0x4(%edx),%edx
  8038c9:	89 50 04             	mov    %edx,0x4(%eax)
  8038cc:	eb 0b                	jmp    8038d9 <insert_sorted_with_merge_freeList+0x5e3>
  8038ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038d1:	8b 40 04             	mov    0x4(%eax),%eax
  8038d4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8038d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038dc:	8b 40 04             	mov    0x4(%eax),%eax
  8038df:	85 c0                	test   %eax,%eax
  8038e1:	74 0f                	je     8038f2 <insert_sorted_with_merge_freeList+0x5fc>
  8038e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038e6:	8b 40 04             	mov    0x4(%eax),%eax
  8038e9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8038ec:	8b 12                	mov    (%edx),%edx
  8038ee:	89 10                	mov    %edx,(%eax)
  8038f0:	eb 0a                	jmp    8038fc <insert_sorted_with_merge_freeList+0x606>
  8038f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038f5:	8b 00                	mov    (%eax),%eax
  8038f7:	a3 38 51 80 00       	mov    %eax,0x805138
  8038fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038ff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803905:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803908:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80390f:	a1 44 51 80 00       	mov    0x805144,%eax
  803914:	48                   	dec    %eax
  803915:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  80391a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80391d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803924:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803927:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80392e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803932:	75 17                	jne    80394b <insert_sorted_with_merge_freeList+0x655>
  803934:	83 ec 04             	sub    $0x4,%esp
  803937:	68 4c 46 80 00       	push   $0x80464c
  80393c:	68 6e 01 00 00       	push   $0x16e
  803941:	68 6f 46 80 00       	push   $0x80466f
  803946:	e8 46 ce ff ff       	call   800791 <_panic>
  80394b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803951:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803954:	89 10                	mov    %edx,(%eax)
  803956:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803959:	8b 00                	mov    (%eax),%eax
  80395b:	85 c0                	test   %eax,%eax
  80395d:	74 0d                	je     80396c <insert_sorted_with_merge_freeList+0x676>
  80395f:	a1 48 51 80 00       	mov    0x805148,%eax
  803964:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803967:	89 50 04             	mov    %edx,0x4(%eax)
  80396a:	eb 08                	jmp    803974 <insert_sorted_with_merge_freeList+0x67e>
  80396c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80396f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803974:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803977:	a3 48 51 80 00       	mov    %eax,0x805148
  80397c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80397f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803986:	a1 54 51 80 00       	mov    0x805154,%eax
  80398b:	40                   	inc    %eax
  80398c:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803991:	e9 a9 00 00 00       	jmp    803a3f <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803996:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80399a:	74 06                	je     8039a2 <insert_sorted_with_merge_freeList+0x6ac>
  80399c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8039a0:	75 17                	jne    8039b9 <insert_sorted_with_merge_freeList+0x6c3>
  8039a2:	83 ec 04             	sub    $0x4,%esp
  8039a5:	68 e4 46 80 00       	push   $0x8046e4
  8039aa:	68 73 01 00 00       	push   $0x173
  8039af:	68 6f 46 80 00       	push   $0x80466f
  8039b4:	e8 d8 cd ff ff       	call   800791 <_panic>
  8039b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039bc:	8b 10                	mov    (%eax),%edx
  8039be:	8b 45 08             	mov    0x8(%ebp),%eax
  8039c1:	89 10                	mov    %edx,(%eax)
  8039c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8039c6:	8b 00                	mov    (%eax),%eax
  8039c8:	85 c0                	test   %eax,%eax
  8039ca:	74 0b                	je     8039d7 <insert_sorted_with_merge_freeList+0x6e1>
  8039cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039cf:	8b 00                	mov    (%eax),%eax
  8039d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8039d4:	89 50 04             	mov    %edx,0x4(%eax)
  8039d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039da:	8b 55 08             	mov    0x8(%ebp),%edx
  8039dd:	89 10                	mov    %edx,(%eax)
  8039df:	8b 45 08             	mov    0x8(%ebp),%eax
  8039e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8039e5:	89 50 04             	mov    %edx,0x4(%eax)
  8039e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8039eb:	8b 00                	mov    (%eax),%eax
  8039ed:	85 c0                	test   %eax,%eax
  8039ef:	75 08                	jne    8039f9 <insert_sorted_with_merge_freeList+0x703>
  8039f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8039f4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8039f9:	a1 44 51 80 00       	mov    0x805144,%eax
  8039fe:	40                   	inc    %eax
  8039ff:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803a04:	eb 39                	jmp    803a3f <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803a06:	a1 40 51 80 00       	mov    0x805140,%eax
  803a0b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803a0e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a12:	74 07                	je     803a1b <insert_sorted_with_merge_freeList+0x725>
  803a14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a17:	8b 00                	mov    (%eax),%eax
  803a19:	eb 05                	jmp    803a20 <insert_sorted_with_merge_freeList+0x72a>
  803a1b:	b8 00 00 00 00       	mov    $0x0,%eax
  803a20:	a3 40 51 80 00       	mov    %eax,0x805140
  803a25:	a1 40 51 80 00       	mov    0x805140,%eax
  803a2a:	85 c0                	test   %eax,%eax
  803a2c:	0f 85 c7 fb ff ff    	jne    8035f9 <insert_sorted_with_merge_freeList+0x303>
  803a32:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a36:	0f 85 bd fb ff ff    	jne    8035f9 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803a3c:	eb 01                	jmp    803a3f <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803a3e:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803a3f:	90                   	nop
  803a40:	c9                   	leave  
  803a41:	c3                   	ret    
  803a42:	66 90                	xchg   %ax,%ax

00803a44 <__udivdi3>:
  803a44:	55                   	push   %ebp
  803a45:	57                   	push   %edi
  803a46:	56                   	push   %esi
  803a47:	53                   	push   %ebx
  803a48:	83 ec 1c             	sub    $0x1c,%esp
  803a4b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803a4f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803a53:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803a57:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803a5b:	89 ca                	mov    %ecx,%edx
  803a5d:	89 f8                	mov    %edi,%eax
  803a5f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803a63:	85 f6                	test   %esi,%esi
  803a65:	75 2d                	jne    803a94 <__udivdi3+0x50>
  803a67:	39 cf                	cmp    %ecx,%edi
  803a69:	77 65                	ja     803ad0 <__udivdi3+0x8c>
  803a6b:	89 fd                	mov    %edi,%ebp
  803a6d:	85 ff                	test   %edi,%edi
  803a6f:	75 0b                	jne    803a7c <__udivdi3+0x38>
  803a71:	b8 01 00 00 00       	mov    $0x1,%eax
  803a76:	31 d2                	xor    %edx,%edx
  803a78:	f7 f7                	div    %edi
  803a7a:	89 c5                	mov    %eax,%ebp
  803a7c:	31 d2                	xor    %edx,%edx
  803a7e:	89 c8                	mov    %ecx,%eax
  803a80:	f7 f5                	div    %ebp
  803a82:	89 c1                	mov    %eax,%ecx
  803a84:	89 d8                	mov    %ebx,%eax
  803a86:	f7 f5                	div    %ebp
  803a88:	89 cf                	mov    %ecx,%edi
  803a8a:	89 fa                	mov    %edi,%edx
  803a8c:	83 c4 1c             	add    $0x1c,%esp
  803a8f:	5b                   	pop    %ebx
  803a90:	5e                   	pop    %esi
  803a91:	5f                   	pop    %edi
  803a92:	5d                   	pop    %ebp
  803a93:	c3                   	ret    
  803a94:	39 ce                	cmp    %ecx,%esi
  803a96:	77 28                	ja     803ac0 <__udivdi3+0x7c>
  803a98:	0f bd fe             	bsr    %esi,%edi
  803a9b:	83 f7 1f             	xor    $0x1f,%edi
  803a9e:	75 40                	jne    803ae0 <__udivdi3+0x9c>
  803aa0:	39 ce                	cmp    %ecx,%esi
  803aa2:	72 0a                	jb     803aae <__udivdi3+0x6a>
  803aa4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803aa8:	0f 87 9e 00 00 00    	ja     803b4c <__udivdi3+0x108>
  803aae:	b8 01 00 00 00       	mov    $0x1,%eax
  803ab3:	89 fa                	mov    %edi,%edx
  803ab5:	83 c4 1c             	add    $0x1c,%esp
  803ab8:	5b                   	pop    %ebx
  803ab9:	5e                   	pop    %esi
  803aba:	5f                   	pop    %edi
  803abb:	5d                   	pop    %ebp
  803abc:	c3                   	ret    
  803abd:	8d 76 00             	lea    0x0(%esi),%esi
  803ac0:	31 ff                	xor    %edi,%edi
  803ac2:	31 c0                	xor    %eax,%eax
  803ac4:	89 fa                	mov    %edi,%edx
  803ac6:	83 c4 1c             	add    $0x1c,%esp
  803ac9:	5b                   	pop    %ebx
  803aca:	5e                   	pop    %esi
  803acb:	5f                   	pop    %edi
  803acc:	5d                   	pop    %ebp
  803acd:	c3                   	ret    
  803ace:	66 90                	xchg   %ax,%ax
  803ad0:	89 d8                	mov    %ebx,%eax
  803ad2:	f7 f7                	div    %edi
  803ad4:	31 ff                	xor    %edi,%edi
  803ad6:	89 fa                	mov    %edi,%edx
  803ad8:	83 c4 1c             	add    $0x1c,%esp
  803adb:	5b                   	pop    %ebx
  803adc:	5e                   	pop    %esi
  803add:	5f                   	pop    %edi
  803ade:	5d                   	pop    %ebp
  803adf:	c3                   	ret    
  803ae0:	bd 20 00 00 00       	mov    $0x20,%ebp
  803ae5:	89 eb                	mov    %ebp,%ebx
  803ae7:	29 fb                	sub    %edi,%ebx
  803ae9:	89 f9                	mov    %edi,%ecx
  803aeb:	d3 e6                	shl    %cl,%esi
  803aed:	89 c5                	mov    %eax,%ebp
  803aef:	88 d9                	mov    %bl,%cl
  803af1:	d3 ed                	shr    %cl,%ebp
  803af3:	89 e9                	mov    %ebp,%ecx
  803af5:	09 f1                	or     %esi,%ecx
  803af7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803afb:	89 f9                	mov    %edi,%ecx
  803afd:	d3 e0                	shl    %cl,%eax
  803aff:	89 c5                	mov    %eax,%ebp
  803b01:	89 d6                	mov    %edx,%esi
  803b03:	88 d9                	mov    %bl,%cl
  803b05:	d3 ee                	shr    %cl,%esi
  803b07:	89 f9                	mov    %edi,%ecx
  803b09:	d3 e2                	shl    %cl,%edx
  803b0b:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b0f:	88 d9                	mov    %bl,%cl
  803b11:	d3 e8                	shr    %cl,%eax
  803b13:	09 c2                	or     %eax,%edx
  803b15:	89 d0                	mov    %edx,%eax
  803b17:	89 f2                	mov    %esi,%edx
  803b19:	f7 74 24 0c          	divl   0xc(%esp)
  803b1d:	89 d6                	mov    %edx,%esi
  803b1f:	89 c3                	mov    %eax,%ebx
  803b21:	f7 e5                	mul    %ebp
  803b23:	39 d6                	cmp    %edx,%esi
  803b25:	72 19                	jb     803b40 <__udivdi3+0xfc>
  803b27:	74 0b                	je     803b34 <__udivdi3+0xf0>
  803b29:	89 d8                	mov    %ebx,%eax
  803b2b:	31 ff                	xor    %edi,%edi
  803b2d:	e9 58 ff ff ff       	jmp    803a8a <__udivdi3+0x46>
  803b32:	66 90                	xchg   %ax,%ax
  803b34:	8b 54 24 08          	mov    0x8(%esp),%edx
  803b38:	89 f9                	mov    %edi,%ecx
  803b3a:	d3 e2                	shl    %cl,%edx
  803b3c:	39 c2                	cmp    %eax,%edx
  803b3e:	73 e9                	jae    803b29 <__udivdi3+0xe5>
  803b40:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803b43:	31 ff                	xor    %edi,%edi
  803b45:	e9 40 ff ff ff       	jmp    803a8a <__udivdi3+0x46>
  803b4a:	66 90                	xchg   %ax,%ax
  803b4c:	31 c0                	xor    %eax,%eax
  803b4e:	e9 37 ff ff ff       	jmp    803a8a <__udivdi3+0x46>
  803b53:	90                   	nop

00803b54 <__umoddi3>:
  803b54:	55                   	push   %ebp
  803b55:	57                   	push   %edi
  803b56:	56                   	push   %esi
  803b57:	53                   	push   %ebx
  803b58:	83 ec 1c             	sub    $0x1c,%esp
  803b5b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803b5f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803b63:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b67:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803b6b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803b6f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803b73:	89 f3                	mov    %esi,%ebx
  803b75:	89 fa                	mov    %edi,%edx
  803b77:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803b7b:	89 34 24             	mov    %esi,(%esp)
  803b7e:	85 c0                	test   %eax,%eax
  803b80:	75 1a                	jne    803b9c <__umoddi3+0x48>
  803b82:	39 f7                	cmp    %esi,%edi
  803b84:	0f 86 a2 00 00 00    	jbe    803c2c <__umoddi3+0xd8>
  803b8a:	89 c8                	mov    %ecx,%eax
  803b8c:	89 f2                	mov    %esi,%edx
  803b8e:	f7 f7                	div    %edi
  803b90:	89 d0                	mov    %edx,%eax
  803b92:	31 d2                	xor    %edx,%edx
  803b94:	83 c4 1c             	add    $0x1c,%esp
  803b97:	5b                   	pop    %ebx
  803b98:	5e                   	pop    %esi
  803b99:	5f                   	pop    %edi
  803b9a:	5d                   	pop    %ebp
  803b9b:	c3                   	ret    
  803b9c:	39 f0                	cmp    %esi,%eax
  803b9e:	0f 87 ac 00 00 00    	ja     803c50 <__umoddi3+0xfc>
  803ba4:	0f bd e8             	bsr    %eax,%ebp
  803ba7:	83 f5 1f             	xor    $0x1f,%ebp
  803baa:	0f 84 ac 00 00 00    	je     803c5c <__umoddi3+0x108>
  803bb0:	bf 20 00 00 00       	mov    $0x20,%edi
  803bb5:	29 ef                	sub    %ebp,%edi
  803bb7:	89 fe                	mov    %edi,%esi
  803bb9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803bbd:	89 e9                	mov    %ebp,%ecx
  803bbf:	d3 e0                	shl    %cl,%eax
  803bc1:	89 d7                	mov    %edx,%edi
  803bc3:	89 f1                	mov    %esi,%ecx
  803bc5:	d3 ef                	shr    %cl,%edi
  803bc7:	09 c7                	or     %eax,%edi
  803bc9:	89 e9                	mov    %ebp,%ecx
  803bcb:	d3 e2                	shl    %cl,%edx
  803bcd:	89 14 24             	mov    %edx,(%esp)
  803bd0:	89 d8                	mov    %ebx,%eax
  803bd2:	d3 e0                	shl    %cl,%eax
  803bd4:	89 c2                	mov    %eax,%edx
  803bd6:	8b 44 24 08          	mov    0x8(%esp),%eax
  803bda:	d3 e0                	shl    %cl,%eax
  803bdc:	89 44 24 04          	mov    %eax,0x4(%esp)
  803be0:	8b 44 24 08          	mov    0x8(%esp),%eax
  803be4:	89 f1                	mov    %esi,%ecx
  803be6:	d3 e8                	shr    %cl,%eax
  803be8:	09 d0                	or     %edx,%eax
  803bea:	d3 eb                	shr    %cl,%ebx
  803bec:	89 da                	mov    %ebx,%edx
  803bee:	f7 f7                	div    %edi
  803bf0:	89 d3                	mov    %edx,%ebx
  803bf2:	f7 24 24             	mull   (%esp)
  803bf5:	89 c6                	mov    %eax,%esi
  803bf7:	89 d1                	mov    %edx,%ecx
  803bf9:	39 d3                	cmp    %edx,%ebx
  803bfb:	0f 82 87 00 00 00    	jb     803c88 <__umoddi3+0x134>
  803c01:	0f 84 91 00 00 00    	je     803c98 <__umoddi3+0x144>
  803c07:	8b 54 24 04          	mov    0x4(%esp),%edx
  803c0b:	29 f2                	sub    %esi,%edx
  803c0d:	19 cb                	sbb    %ecx,%ebx
  803c0f:	89 d8                	mov    %ebx,%eax
  803c11:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803c15:	d3 e0                	shl    %cl,%eax
  803c17:	89 e9                	mov    %ebp,%ecx
  803c19:	d3 ea                	shr    %cl,%edx
  803c1b:	09 d0                	or     %edx,%eax
  803c1d:	89 e9                	mov    %ebp,%ecx
  803c1f:	d3 eb                	shr    %cl,%ebx
  803c21:	89 da                	mov    %ebx,%edx
  803c23:	83 c4 1c             	add    $0x1c,%esp
  803c26:	5b                   	pop    %ebx
  803c27:	5e                   	pop    %esi
  803c28:	5f                   	pop    %edi
  803c29:	5d                   	pop    %ebp
  803c2a:	c3                   	ret    
  803c2b:	90                   	nop
  803c2c:	89 fd                	mov    %edi,%ebp
  803c2e:	85 ff                	test   %edi,%edi
  803c30:	75 0b                	jne    803c3d <__umoddi3+0xe9>
  803c32:	b8 01 00 00 00       	mov    $0x1,%eax
  803c37:	31 d2                	xor    %edx,%edx
  803c39:	f7 f7                	div    %edi
  803c3b:	89 c5                	mov    %eax,%ebp
  803c3d:	89 f0                	mov    %esi,%eax
  803c3f:	31 d2                	xor    %edx,%edx
  803c41:	f7 f5                	div    %ebp
  803c43:	89 c8                	mov    %ecx,%eax
  803c45:	f7 f5                	div    %ebp
  803c47:	89 d0                	mov    %edx,%eax
  803c49:	e9 44 ff ff ff       	jmp    803b92 <__umoddi3+0x3e>
  803c4e:	66 90                	xchg   %ax,%ax
  803c50:	89 c8                	mov    %ecx,%eax
  803c52:	89 f2                	mov    %esi,%edx
  803c54:	83 c4 1c             	add    $0x1c,%esp
  803c57:	5b                   	pop    %ebx
  803c58:	5e                   	pop    %esi
  803c59:	5f                   	pop    %edi
  803c5a:	5d                   	pop    %ebp
  803c5b:	c3                   	ret    
  803c5c:	3b 04 24             	cmp    (%esp),%eax
  803c5f:	72 06                	jb     803c67 <__umoddi3+0x113>
  803c61:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803c65:	77 0f                	ja     803c76 <__umoddi3+0x122>
  803c67:	89 f2                	mov    %esi,%edx
  803c69:	29 f9                	sub    %edi,%ecx
  803c6b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803c6f:	89 14 24             	mov    %edx,(%esp)
  803c72:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c76:	8b 44 24 04          	mov    0x4(%esp),%eax
  803c7a:	8b 14 24             	mov    (%esp),%edx
  803c7d:	83 c4 1c             	add    $0x1c,%esp
  803c80:	5b                   	pop    %ebx
  803c81:	5e                   	pop    %esi
  803c82:	5f                   	pop    %edi
  803c83:	5d                   	pop    %ebp
  803c84:	c3                   	ret    
  803c85:	8d 76 00             	lea    0x0(%esi),%esi
  803c88:	2b 04 24             	sub    (%esp),%eax
  803c8b:	19 fa                	sbb    %edi,%edx
  803c8d:	89 d1                	mov    %edx,%ecx
  803c8f:	89 c6                	mov    %eax,%esi
  803c91:	e9 71 ff ff ff       	jmp    803c07 <__umoddi3+0xb3>
  803c96:	66 90                	xchg   %ax,%ax
  803c98:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803c9c:	72 ea                	jb     803c88 <__umoddi3+0x134>
  803c9e:	89 d9                	mov    %ebx,%ecx
  803ca0:	e9 62 ff ff ff       	jmp    803c07 <__umoddi3+0xb3>
