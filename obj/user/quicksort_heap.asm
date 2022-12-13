
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
  800041:	e8 e1 1f 00 00       	call   802027 <sys_disable_interrupt>
		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 60 3d 80 00       	push   $0x803d60
  80004e:	e8 f2 09 00 00       	call   800a45 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 62 3d 80 00       	push   $0x803d62
  80005e:	e8 e2 09 00 00       	call   800a45 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!   QUICK SORT   !!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 7b 3d 80 00       	push   $0x803d7b
  80006e:	e8 d2 09 00 00       	call   800a45 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 62 3d 80 00       	push   $0x803d62
  80007e:	e8 c2 09 00 00       	call   800a45 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 60 3d 80 00       	push   $0x803d60
  80008e:	e8 b2 09 00 00       	call   800a45 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp

		readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 94 3d 80 00       	push   $0x803d94
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
  8000de:	68 b4 3d 80 00       	push   $0x803db4
  8000e3:	e8 5d 09 00 00       	call   800a45 <cprintf>
  8000e8:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000eb:	83 ec 0c             	sub    $0xc,%esp
  8000ee:	68 d6 3d 80 00       	push   $0x803dd6
  8000f3:	e8 4d 09 00 00       	call   800a45 <cprintf>
  8000f8:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000fb:	83 ec 0c             	sub    $0xc,%esp
  8000fe:	68 e4 3d 80 00       	push   $0x803de4
  800103:	e8 3d 09 00 00       	call   800a45 <cprintf>
  800108:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 f3 3d 80 00       	push   $0x803df3
  800113:	e8 2d 09 00 00       	call   800a45 <cprintf>
  800118:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	68 03 3e 80 00       	push   $0x803e03
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
  800162:	e8 da 1e 00 00       	call   802041 <sys_enable_interrupt>

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
  8001d5:	e8 4d 1e 00 00       	call   802027 <sys_disable_interrupt>
			cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001da:	83 ec 0c             	sub    $0xc,%esp
  8001dd:	68 0c 3e 80 00       	push   $0x803e0c
  8001e2:	e8 5e 08 00 00       	call   800a45 <cprintf>
  8001e7:	83 c4 10             	add    $0x10,%esp
		//		PrintElements(Elements, NumOfElements);
		sys_enable_interrupt();
  8001ea:	e8 52 1e 00 00       	call   802041 <sys_enable_interrupt>

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
  80020c:	68 40 3e 80 00       	push   $0x803e40
  800211:	6a 48                	push   $0x48
  800213:	68 62 3e 80 00       	push   $0x803e62
  800218:	e8 74 05 00 00       	call   800791 <_panic>
		else
		{
			sys_disable_interrupt();
  80021d:	e8 05 1e 00 00       	call   802027 <sys_disable_interrupt>
			cprintf("\n===============================================\n") ;
  800222:	83 ec 0c             	sub    $0xc,%esp
  800225:	68 78 3e 80 00       	push   $0x803e78
  80022a:	e8 16 08 00 00       	call   800a45 <cprintf>
  80022f:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  800232:	83 ec 0c             	sub    $0xc,%esp
  800235:	68 ac 3e 80 00       	push   $0x803eac
  80023a:	e8 06 08 00 00       	call   800a45 <cprintf>
  80023f:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  800242:	83 ec 0c             	sub    $0xc,%esp
  800245:	68 e0 3e 80 00       	push   $0x803ee0
  80024a:	e8 f6 07 00 00       	call   800a45 <cprintf>
  80024f:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800252:	e8 ea 1d 00 00       	call   802041 <sys_enable_interrupt>
		}

		sys_disable_interrupt();
  800257:	e8 cb 1d 00 00       	call   802027 <sys_disable_interrupt>
			Chose = 0 ;
  80025c:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800260:	eb 42                	jmp    8002a4 <_main+0x26c>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800262:	83 ec 0c             	sub    $0xc,%esp
  800265:	68 12 3f 80 00       	push   $0x803f12
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
  8002b0:	e8 8c 1d 00 00       	call   802041 <sys_enable_interrupt>

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
  800555:	68 60 3d 80 00       	push   $0x803d60
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
  800577:	68 30 3f 80 00       	push   $0x803f30
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
  8005a5:	68 35 3f 80 00       	push   $0x803f35
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
  8005c9:	e8 8d 1a 00 00       	call   80205b <sys_cputc>
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
  8005da:	e8 48 1a 00 00       	call   802027 <sys_disable_interrupt>
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
  8005ed:	e8 69 1a 00 00       	call   80205b <sys_cputc>
  8005f2:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8005f5:	e8 47 1a 00 00       	call   802041 <sys_enable_interrupt>
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
  80060c:	e8 91 18 00 00       	call   801ea2 <sys_cgetc>
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
  800625:	e8 fd 19 00 00       	call   802027 <sys_disable_interrupt>
	int c=0;
  80062a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800631:	eb 08                	jmp    80063b <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  800633:	e8 6a 18 00 00       	call   801ea2 <sys_cgetc>
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
  800641:	e8 fb 19 00 00       	call   802041 <sys_enable_interrupt>
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
  80065b:	e8 ba 1b 00 00       	call   80221a <sys_getenvindex>
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
  8006c6:	e8 5c 19 00 00       	call   802027 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8006cb:	83 ec 0c             	sub    $0xc,%esp
  8006ce:	68 54 3f 80 00       	push   $0x803f54
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
  8006f6:	68 7c 3f 80 00       	push   $0x803f7c
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
  800727:	68 a4 3f 80 00       	push   $0x803fa4
  80072c:	e8 14 03 00 00       	call   800a45 <cprintf>
  800731:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800734:	a1 24 50 80 00       	mov    0x805024,%eax
  800739:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80073f:	83 ec 08             	sub    $0x8,%esp
  800742:	50                   	push   %eax
  800743:	68 fc 3f 80 00       	push   $0x803ffc
  800748:	e8 f8 02 00 00       	call   800a45 <cprintf>
  80074d:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800750:	83 ec 0c             	sub    $0xc,%esp
  800753:	68 54 3f 80 00       	push   $0x803f54
  800758:	e8 e8 02 00 00       	call   800a45 <cprintf>
  80075d:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800760:	e8 dc 18 00 00       	call   802041 <sys_enable_interrupt>

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
  800778:	e8 69 1a 00 00       	call   8021e6 <sys_destroy_env>
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
  800789:	e8 be 1a 00 00       	call   80224c <sys_exit_env>
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
  8007b2:	68 10 40 80 00       	push   $0x804010
  8007b7:	e8 89 02 00 00       	call   800a45 <cprintf>
  8007bc:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8007bf:	a1 00 50 80 00       	mov    0x805000,%eax
  8007c4:	ff 75 0c             	pushl  0xc(%ebp)
  8007c7:	ff 75 08             	pushl  0x8(%ebp)
  8007ca:	50                   	push   %eax
  8007cb:	68 15 40 80 00       	push   $0x804015
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
  8007ef:	68 31 40 80 00       	push   $0x804031
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
  80081b:	68 34 40 80 00       	push   $0x804034
  800820:	6a 26                	push   $0x26
  800822:	68 80 40 80 00       	push   $0x804080
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
  8008ed:	68 8c 40 80 00       	push   $0x80408c
  8008f2:	6a 3a                	push   $0x3a
  8008f4:	68 80 40 80 00       	push   $0x804080
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
  80095d:	68 e0 40 80 00       	push   $0x8040e0
  800962:	6a 44                	push   $0x44
  800964:	68 80 40 80 00       	push   $0x804080
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
  8009b7:	e8 bd 14 00 00       	call   801e79 <sys_cputs>
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
  800a2e:	e8 46 14 00 00       	call   801e79 <sys_cputs>
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
  800a78:	e8 aa 15 00 00       	call   802027 <sys_disable_interrupt>
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
  800a98:	e8 a4 15 00 00       	call   802041 <sys_enable_interrupt>
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
  800ae2:	e8 15 30 00 00       	call   803afc <__udivdi3>
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
  800b32:	e8 d5 30 00 00       	call   803c0c <__umoddi3>
  800b37:	83 c4 10             	add    $0x10,%esp
  800b3a:	05 54 43 80 00       	add    $0x804354,%eax
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
  800c8d:	8b 04 85 78 43 80 00 	mov    0x804378(,%eax,4),%eax
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
  800d6e:	8b 34 9d c0 41 80 00 	mov    0x8041c0(,%ebx,4),%esi
  800d75:	85 f6                	test   %esi,%esi
  800d77:	75 19                	jne    800d92 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d79:	53                   	push   %ebx
  800d7a:	68 65 43 80 00       	push   $0x804365
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
  800d93:	68 6e 43 80 00       	push   $0x80436e
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
  800dc0:	be 71 43 80 00       	mov    $0x804371,%esi
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
  8010d9:	68 d0 44 80 00       	push   $0x8044d0
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
  80111b:	68 d3 44 80 00       	push   $0x8044d3
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
  8011cb:	e8 57 0e 00 00       	call   802027 <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  8011d0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011d4:	74 13                	je     8011e9 <atomic_readline+0x24>
		cprintf("%s", prompt);
  8011d6:	83 ec 08             	sub    $0x8,%esp
  8011d9:	ff 75 08             	pushl  0x8(%ebp)
  8011dc:	68 d0 44 80 00       	push   $0x8044d0
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
  80121a:	68 d3 44 80 00       	push   $0x8044d3
  80121f:	e8 21 f8 ff ff       	call   800a45 <cprintf>
  801224:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  801227:	e8 15 0e 00 00       	call   802041 <sys_enable_interrupt>
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
  8012bf:	e8 7d 0d 00 00       	call   802041 <sys_enable_interrupt>
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
  8019ec:	68 e4 44 80 00       	push   $0x8044e4
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
  801abc:	e8 fc 04 00 00       	call   801fbd <sys_allocate_chunk>
  801ac1:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801ac4:	a1 20 51 80 00       	mov    0x805120,%eax
  801ac9:	83 ec 0c             	sub    $0xc,%esp
  801acc:	50                   	push   %eax
  801acd:	e8 71 0b 00 00       	call   802643 <initialize_MemBlocksList>
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
  801afa:	68 09 45 80 00       	push   $0x804509
  801aff:	6a 33                	push   $0x33
  801b01:	68 27 45 80 00       	push   $0x804527
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
  801b79:	68 34 45 80 00       	push   $0x804534
  801b7e:	6a 34                	push   $0x34
  801b80:	68 27 45 80 00       	push   $0x804527
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
  801bd6:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801bd9:	e8 f7 fd ff ff       	call   8019d5 <InitializeUHeap>
	if (size == 0) return NULL ;
  801bde:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801be2:	75 07                	jne    801beb <malloc+0x18>
  801be4:	b8 00 00 00 00       	mov    $0x0,%eax
  801be9:	eb 61                	jmp    801c4c <malloc+0x79>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
	uint32 malloc_allocsize=ROUNDUP(size,PAGE_SIZE);
  801beb:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801bf2:	8b 55 08             	mov    0x8(%ebp),%edx
  801bf5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bf8:	01 d0                	add    %edx,%eax
  801bfa:	48                   	dec    %eax
  801bfb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801bfe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c01:	ba 00 00 00 00       	mov    $0x0,%edx
  801c06:	f7 75 f0             	divl   -0x10(%ebp)
  801c09:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c0c:	29 d0                	sub    %edx,%eax
  801c0e:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 //int ret=0;
	struct MemBlock * user_block;
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801c11:	e8 75 07 00 00       	call   80238b <sys_isUHeapPlacementStrategyFIRSTFIT>
  801c16:	85 c0                	test   %eax,%eax
  801c18:	74 11                	je     801c2b <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801c1a:	83 ec 0c             	sub    $0xc,%esp
  801c1d:	ff 75 e8             	pushl  -0x18(%ebp)
  801c20:	e8 e0 0d 00 00       	call   802a05 <alloc_block_FF>
  801c25:	83 c4 10             	add    $0x10,%esp
  801c28:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(user_block!=NULL)
  801c2b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c2f:	74 16                	je     801c47 <malloc+0x74>
	{
		//sys_allocate_chunk(user_block->sva,malloc_allocsize,PERM_WRITEABLE| PERM_PRESENT);
		insert_sorted_allocList(user_block);
  801c31:	83 ec 0c             	sub    $0xc,%esp
  801c34:	ff 75 f4             	pushl  -0xc(%ebp)
  801c37:	e8 3c 0b 00 00       	call   802778 <insert_sorted_allocList>
  801c3c:	83 c4 10             	add    $0x10,%esp
		return (uint32 *)user_block->sva;
  801c3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c42:	8b 40 08             	mov    0x8(%eax),%eax
  801c45:	eb 05                	jmp    801c4c <malloc+0x79>
	}

    return NULL;
  801c47:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c4c:	c9                   	leave  
  801c4d:	c3                   	ret    

00801c4e <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801c4e:	55                   	push   %ebp
  801c4f:	89 e5                	mov    %esp,%ebp
  801c51:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801c54:	83 ec 04             	sub    $0x4,%esp
  801c57:	68 58 45 80 00       	push   $0x804558
  801c5c:	6a 6f                	push   $0x6f
  801c5e:	68 27 45 80 00       	push   $0x804527
  801c63:	e8 29 eb ff ff       	call   800791 <_panic>

00801c68 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801c68:	55                   	push   %ebp
  801c69:	89 e5                	mov    %esp,%ebp
  801c6b:	83 ec 38             	sub    $0x38,%esp
  801c6e:	8b 45 10             	mov    0x10(%ebp),%eax
  801c71:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801c74:	e8 5c fd ff ff       	call   8019d5 <InitializeUHeap>
	if (size == 0) return NULL ;
  801c79:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801c7d:	75 0a                	jne    801c89 <smalloc+0x21>
  801c7f:	b8 00 00 00 00       	mov    $0x0,%eax
  801c84:	e9 8b 00 00 00       	jmp    801d14 <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801c89:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801c90:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c96:	01 d0                	add    %edx,%eax
  801c98:	48                   	dec    %eax
  801c99:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801c9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c9f:	ba 00 00 00 00       	mov    $0x0,%edx
  801ca4:	f7 75 f0             	divl   -0x10(%ebp)
  801ca7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801caa:	29 d0                	sub    %edx,%eax
  801cac:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801caf:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801cb6:	e8 d0 06 00 00       	call   80238b <sys_isUHeapPlacementStrategyFIRSTFIT>
  801cbb:	85 c0                	test   %eax,%eax
  801cbd:	74 11                	je     801cd0 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  801cbf:	83 ec 0c             	sub    $0xc,%esp
  801cc2:	ff 75 e8             	pushl  -0x18(%ebp)
  801cc5:	e8 3b 0d 00 00       	call   802a05 <alloc_block_FF>
  801cca:	83 c4 10             	add    $0x10,%esp
  801ccd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  801cd0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801cd4:	74 39                	je     801d0f <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801cd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cd9:	8b 40 08             	mov    0x8(%eax),%eax
  801cdc:	89 c2                	mov    %eax,%edx
  801cde:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801ce2:	52                   	push   %edx
  801ce3:	50                   	push   %eax
  801ce4:	ff 75 0c             	pushl  0xc(%ebp)
  801ce7:	ff 75 08             	pushl  0x8(%ebp)
  801cea:	e8 21 04 00 00       	call   802110 <sys_createSharedObject>
  801cef:	83 c4 10             	add    $0x10,%esp
  801cf2:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  801cf5:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  801cf9:	74 14                	je     801d0f <smalloc+0xa7>
  801cfb:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  801cff:	74 0e                	je     801d0f <smalloc+0xa7>
  801d01:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  801d05:	74 08                	je     801d0f <smalloc+0xa7>
			return (void*) mem_block->sva;
  801d07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d0a:	8b 40 08             	mov    0x8(%eax),%eax
  801d0d:	eb 05                	jmp    801d14 <smalloc+0xac>
	}
	return NULL;
  801d0f:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801d14:	c9                   	leave  
  801d15:	c3                   	ret    

00801d16 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801d16:	55                   	push   %ebp
  801d17:	89 e5                	mov    %esp,%ebp
  801d19:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801d1c:	e8 b4 fc ff ff       	call   8019d5 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801d21:	83 ec 08             	sub    $0x8,%esp
  801d24:	ff 75 0c             	pushl  0xc(%ebp)
  801d27:	ff 75 08             	pushl  0x8(%ebp)
  801d2a:	e8 0b 04 00 00       	call   80213a <sys_getSizeOfSharedObject>
  801d2f:	83 c4 10             	add    $0x10,%esp
  801d32:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  801d35:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  801d39:	74 76                	je     801db1 <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801d3b:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801d42:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d45:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d48:	01 d0                	add    %edx,%eax
  801d4a:	48                   	dec    %eax
  801d4b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801d4e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d51:	ba 00 00 00 00       	mov    $0x0,%edx
  801d56:	f7 75 ec             	divl   -0x14(%ebp)
  801d59:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d5c:	29 d0                	sub    %edx,%eax
  801d5e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  801d61:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801d68:	e8 1e 06 00 00       	call   80238b <sys_isUHeapPlacementStrategyFIRSTFIT>
  801d6d:	85 c0                	test   %eax,%eax
  801d6f:	74 11                	je     801d82 <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  801d71:	83 ec 0c             	sub    $0xc,%esp
  801d74:	ff 75 e4             	pushl  -0x1c(%ebp)
  801d77:	e8 89 0c 00 00       	call   802a05 <alloc_block_FF>
  801d7c:	83 c4 10             	add    $0x10,%esp
  801d7f:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  801d82:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d86:	74 29                	je     801db1 <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  801d88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d8b:	8b 40 08             	mov    0x8(%eax),%eax
  801d8e:	83 ec 04             	sub    $0x4,%esp
  801d91:	50                   	push   %eax
  801d92:	ff 75 0c             	pushl  0xc(%ebp)
  801d95:	ff 75 08             	pushl  0x8(%ebp)
  801d98:	e8 ba 03 00 00       	call   802157 <sys_getSharedObject>
  801d9d:	83 c4 10             	add    $0x10,%esp
  801da0:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  801da3:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  801da7:	74 08                	je     801db1 <sget+0x9b>
				return (void *)mem_block->sva;
  801da9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dac:	8b 40 08             	mov    0x8(%eax),%eax
  801daf:	eb 05                	jmp    801db6 <sget+0xa0>
		}
	}
	return (void *)NULL;
  801db1:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801db6:	c9                   	leave  
  801db7:	c3                   	ret    

00801db8 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801db8:	55                   	push   %ebp
  801db9:	89 e5                	mov    %esp,%ebp
  801dbb:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801dbe:	e8 12 fc ff ff       	call   8019d5 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801dc3:	83 ec 04             	sub    $0x4,%esp
  801dc6:	68 7c 45 80 00       	push   $0x80457c
  801dcb:	68 f1 00 00 00       	push   $0xf1
  801dd0:	68 27 45 80 00       	push   $0x804527
  801dd5:	e8 b7 e9 ff ff       	call   800791 <_panic>

00801dda <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801dda:	55                   	push   %ebp
  801ddb:	89 e5                	mov    %esp,%ebp
  801ddd:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801de0:	83 ec 04             	sub    $0x4,%esp
  801de3:	68 a4 45 80 00       	push   $0x8045a4
  801de8:	68 05 01 00 00       	push   $0x105
  801ded:	68 27 45 80 00       	push   $0x804527
  801df2:	e8 9a e9 ff ff       	call   800791 <_panic>

00801df7 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801df7:	55                   	push   %ebp
  801df8:	89 e5                	mov    %esp,%ebp
  801dfa:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801dfd:	83 ec 04             	sub    $0x4,%esp
  801e00:	68 c8 45 80 00       	push   $0x8045c8
  801e05:	68 10 01 00 00       	push   $0x110
  801e0a:	68 27 45 80 00       	push   $0x804527
  801e0f:	e8 7d e9 ff ff       	call   800791 <_panic>

00801e14 <shrink>:

}
void shrink(uint32 newSize)
{
  801e14:	55                   	push   %ebp
  801e15:	89 e5                	mov    %esp,%ebp
  801e17:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e1a:	83 ec 04             	sub    $0x4,%esp
  801e1d:	68 c8 45 80 00       	push   $0x8045c8
  801e22:	68 15 01 00 00       	push   $0x115
  801e27:	68 27 45 80 00       	push   $0x804527
  801e2c:	e8 60 e9 ff ff       	call   800791 <_panic>

00801e31 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801e31:	55                   	push   %ebp
  801e32:	89 e5                	mov    %esp,%ebp
  801e34:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e37:	83 ec 04             	sub    $0x4,%esp
  801e3a:	68 c8 45 80 00       	push   $0x8045c8
  801e3f:	68 1a 01 00 00       	push   $0x11a
  801e44:	68 27 45 80 00       	push   $0x804527
  801e49:	e8 43 e9 ff ff       	call   800791 <_panic>

00801e4e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801e4e:	55                   	push   %ebp
  801e4f:	89 e5                	mov    %esp,%ebp
  801e51:	57                   	push   %edi
  801e52:	56                   	push   %esi
  801e53:	53                   	push   %ebx
  801e54:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801e57:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e5d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e60:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e63:	8b 7d 18             	mov    0x18(%ebp),%edi
  801e66:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801e69:	cd 30                	int    $0x30
  801e6b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801e6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801e71:	83 c4 10             	add    $0x10,%esp
  801e74:	5b                   	pop    %ebx
  801e75:	5e                   	pop    %esi
  801e76:	5f                   	pop    %edi
  801e77:	5d                   	pop    %ebp
  801e78:	c3                   	ret    

00801e79 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801e79:	55                   	push   %ebp
  801e7a:	89 e5                	mov    %esp,%ebp
  801e7c:	83 ec 04             	sub    $0x4,%esp
  801e7f:	8b 45 10             	mov    0x10(%ebp),%eax
  801e82:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801e85:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801e89:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8c:	6a 00                	push   $0x0
  801e8e:	6a 00                	push   $0x0
  801e90:	52                   	push   %edx
  801e91:	ff 75 0c             	pushl  0xc(%ebp)
  801e94:	50                   	push   %eax
  801e95:	6a 00                	push   $0x0
  801e97:	e8 b2 ff ff ff       	call   801e4e <syscall>
  801e9c:	83 c4 18             	add    $0x18,%esp
}
  801e9f:	90                   	nop
  801ea0:	c9                   	leave  
  801ea1:	c3                   	ret    

00801ea2 <sys_cgetc>:

int
sys_cgetc(void)
{
  801ea2:	55                   	push   %ebp
  801ea3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801ea5:	6a 00                	push   $0x0
  801ea7:	6a 00                	push   $0x0
  801ea9:	6a 00                	push   $0x0
  801eab:	6a 00                	push   $0x0
  801ead:	6a 00                	push   $0x0
  801eaf:	6a 01                	push   $0x1
  801eb1:	e8 98 ff ff ff       	call   801e4e <syscall>
  801eb6:	83 c4 18             	add    $0x18,%esp
}
  801eb9:	c9                   	leave  
  801eba:	c3                   	ret    

00801ebb <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801ebb:	55                   	push   %ebp
  801ebc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801ebe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ec1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec4:	6a 00                	push   $0x0
  801ec6:	6a 00                	push   $0x0
  801ec8:	6a 00                	push   $0x0
  801eca:	52                   	push   %edx
  801ecb:	50                   	push   %eax
  801ecc:	6a 05                	push   $0x5
  801ece:	e8 7b ff ff ff       	call   801e4e <syscall>
  801ed3:	83 c4 18             	add    $0x18,%esp
}
  801ed6:	c9                   	leave  
  801ed7:	c3                   	ret    

00801ed8 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801ed8:	55                   	push   %ebp
  801ed9:	89 e5                	mov    %esp,%ebp
  801edb:	56                   	push   %esi
  801edc:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801edd:	8b 75 18             	mov    0x18(%ebp),%esi
  801ee0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ee3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ee6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ee9:	8b 45 08             	mov    0x8(%ebp),%eax
  801eec:	56                   	push   %esi
  801eed:	53                   	push   %ebx
  801eee:	51                   	push   %ecx
  801eef:	52                   	push   %edx
  801ef0:	50                   	push   %eax
  801ef1:	6a 06                	push   $0x6
  801ef3:	e8 56 ff ff ff       	call   801e4e <syscall>
  801ef8:	83 c4 18             	add    $0x18,%esp
}
  801efb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801efe:	5b                   	pop    %ebx
  801eff:	5e                   	pop    %esi
  801f00:	5d                   	pop    %ebp
  801f01:	c3                   	ret    

00801f02 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801f02:	55                   	push   %ebp
  801f03:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801f05:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f08:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0b:	6a 00                	push   $0x0
  801f0d:	6a 00                	push   $0x0
  801f0f:	6a 00                	push   $0x0
  801f11:	52                   	push   %edx
  801f12:	50                   	push   %eax
  801f13:	6a 07                	push   $0x7
  801f15:	e8 34 ff ff ff       	call   801e4e <syscall>
  801f1a:	83 c4 18             	add    $0x18,%esp
}
  801f1d:	c9                   	leave  
  801f1e:	c3                   	ret    

00801f1f <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801f1f:	55                   	push   %ebp
  801f20:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801f22:	6a 00                	push   $0x0
  801f24:	6a 00                	push   $0x0
  801f26:	6a 00                	push   $0x0
  801f28:	ff 75 0c             	pushl  0xc(%ebp)
  801f2b:	ff 75 08             	pushl  0x8(%ebp)
  801f2e:	6a 08                	push   $0x8
  801f30:	e8 19 ff ff ff       	call   801e4e <syscall>
  801f35:	83 c4 18             	add    $0x18,%esp
}
  801f38:	c9                   	leave  
  801f39:	c3                   	ret    

00801f3a <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801f3a:	55                   	push   %ebp
  801f3b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801f3d:	6a 00                	push   $0x0
  801f3f:	6a 00                	push   $0x0
  801f41:	6a 00                	push   $0x0
  801f43:	6a 00                	push   $0x0
  801f45:	6a 00                	push   $0x0
  801f47:	6a 09                	push   $0x9
  801f49:	e8 00 ff ff ff       	call   801e4e <syscall>
  801f4e:	83 c4 18             	add    $0x18,%esp
}
  801f51:	c9                   	leave  
  801f52:	c3                   	ret    

00801f53 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801f53:	55                   	push   %ebp
  801f54:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801f56:	6a 00                	push   $0x0
  801f58:	6a 00                	push   $0x0
  801f5a:	6a 00                	push   $0x0
  801f5c:	6a 00                	push   $0x0
  801f5e:	6a 00                	push   $0x0
  801f60:	6a 0a                	push   $0xa
  801f62:	e8 e7 fe ff ff       	call   801e4e <syscall>
  801f67:	83 c4 18             	add    $0x18,%esp
}
  801f6a:	c9                   	leave  
  801f6b:	c3                   	ret    

00801f6c <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801f6c:	55                   	push   %ebp
  801f6d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801f6f:	6a 00                	push   $0x0
  801f71:	6a 00                	push   $0x0
  801f73:	6a 00                	push   $0x0
  801f75:	6a 00                	push   $0x0
  801f77:	6a 00                	push   $0x0
  801f79:	6a 0b                	push   $0xb
  801f7b:	e8 ce fe ff ff       	call   801e4e <syscall>
  801f80:	83 c4 18             	add    $0x18,%esp
}
  801f83:	c9                   	leave  
  801f84:	c3                   	ret    

00801f85 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801f85:	55                   	push   %ebp
  801f86:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801f88:	6a 00                	push   $0x0
  801f8a:	6a 00                	push   $0x0
  801f8c:	6a 00                	push   $0x0
  801f8e:	ff 75 0c             	pushl  0xc(%ebp)
  801f91:	ff 75 08             	pushl  0x8(%ebp)
  801f94:	6a 0f                	push   $0xf
  801f96:	e8 b3 fe ff ff       	call   801e4e <syscall>
  801f9b:	83 c4 18             	add    $0x18,%esp
	return;
  801f9e:	90                   	nop
}
  801f9f:	c9                   	leave  
  801fa0:	c3                   	ret    

00801fa1 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801fa1:	55                   	push   %ebp
  801fa2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801fa4:	6a 00                	push   $0x0
  801fa6:	6a 00                	push   $0x0
  801fa8:	6a 00                	push   $0x0
  801faa:	ff 75 0c             	pushl  0xc(%ebp)
  801fad:	ff 75 08             	pushl  0x8(%ebp)
  801fb0:	6a 10                	push   $0x10
  801fb2:	e8 97 fe ff ff       	call   801e4e <syscall>
  801fb7:	83 c4 18             	add    $0x18,%esp
	return ;
  801fba:	90                   	nop
}
  801fbb:	c9                   	leave  
  801fbc:	c3                   	ret    

00801fbd <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801fbd:	55                   	push   %ebp
  801fbe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801fc0:	6a 00                	push   $0x0
  801fc2:	6a 00                	push   $0x0
  801fc4:	ff 75 10             	pushl  0x10(%ebp)
  801fc7:	ff 75 0c             	pushl  0xc(%ebp)
  801fca:	ff 75 08             	pushl  0x8(%ebp)
  801fcd:	6a 11                	push   $0x11
  801fcf:	e8 7a fe ff ff       	call   801e4e <syscall>
  801fd4:	83 c4 18             	add    $0x18,%esp
	return ;
  801fd7:	90                   	nop
}
  801fd8:	c9                   	leave  
  801fd9:	c3                   	ret    

00801fda <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801fda:	55                   	push   %ebp
  801fdb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801fdd:	6a 00                	push   $0x0
  801fdf:	6a 00                	push   $0x0
  801fe1:	6a 00                	push   $0x0
  801fe3:	6a 00                	push   $0x0
  801fe5:	6a 00                	push   $0x0
  801fe7:	6a 0c                	push   $0xc
  801fe9:	e8 60 fe ff ff       	call   801e4e <syscall>
  801fee:	83 c4 18             	add    $0x18,%esp
}
  801ff1:	c9                   	leave  
  801ff2:	c3                   	ret    

00801ff3 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801ff3:	55                   	push   %ebp
  801ff4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801ff6:	6a 00                	push   $0x0
  801ff8:	6a 00                	push   $0x0
  801ffa:	6a 00                	push   $0x0
  801ffc:	6a 00                	push   $0x0
  801ffe:	ff 75 08             	pushl  0x8(%ebp)
  802001:	6a 0d                	push   $0xd
  802003:	e8 46 fe ff ff       	call   801e4e <syscall>
  802008:	83 c4 18             	add    $0x18,%esp
}
  80200b:	c9                   	leave  
  80200c:	c3                   	ret    

0080200d <sys_scarce_memory>:

void sys_scarce_memory()
{
  80200d:	55                   	push   %ebp
  80200e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802010:	6a 00                	push   $0x0
  802012:	6a 00                	push   $0x0
  802014:	6a 00                	push   $0x0
  802016:	6a 00                	push   $0x0
  802018:	6a 00                	push   $0x0
  80201a:	6a 0e                	push   $0xe
  80201c:	e8 2d fe ff ff       	call   801e4e <syscall>
  802021:	83 c4 18             	add    $0x18,%esp
}
  802024:	90                   	nop
  802025:	c9                   	leave  
  802026:	c3                   	ret    

00802027 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802027:	55                   	push   %ebp
  802028:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80202a:	6a 00                	push   $0x0
  80202c:	6a 00                	push   $0x0
  80202e:	6a 00                	push   $0x0
  802030:	6a 00                	push   $0x0
  802032:	6a 00                	push   $0x0
  802034:	6a 13                	push   $0x13
  802036:	e8 13 fe ff ff       	call   801e4e <syscall>
  80203b:	83 c4 18             	add    $0x18,%esp
}
  80203e:	90                   	nop
  80203f:	c9                   	leave  
  802040:	c3                   	ret    

00802041 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802041:	55                   	push   %ebp
  802042:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802044:	6a 00                	push   $0x0
  802046:	6a 00                	push   $0x0
  802048:	6a 00                	push   $0x0
  80204a:	6a 00                	push   $0x0
  80204c:	6a 00                	push   $0x0
  80204e:	6a 14                	push   $0x14
  802050:	e8 f9 fd ff ff       	call   801e4e <syscall>
  802055:	83 c4 18             	add    $0x18,%esp
}
  802058:	90                   	nop
  802059:	c9                   	leave  
  80205a:	c3                   	ret    

0080205b <sys_cputc>:


void
sys_cputc(const char c)
{
  80205b:	55                   	push   %ebp
  80205c:	89 e5                	mov    %esp,%ebp
  80205e:	83 ec 04             	sub    $0x4,%esp
  802061:	8b 45 08             	mov    0x8(%ebp),%eax
  802064:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802067:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80206b:	6a 00                	push   $0x0
  80206d:	6a 00                	push   $0x0
  80206f:	6a 00                	push   $0x0
  802071:	6a 00                	push   $0x0
  802073:	50                   	push   %eax
  802074:	6a 15                	push   $0x15
  802076:	e8 d3 fd ff ff       	call   801e4e <syscall>
  80207b:	83 c4 18             	add    $0x18,%esp
}
  80207e:	90                   	nop
  80207f:	c9                   	leave  
  802080:	c3                   	ret    

00802081 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802081:	55                   	push   %ebp
  802082:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802084:	6a 00                	push   $0x0
  802086:	6a 00                	push   $0x0
  802088:	6a 00                	push   $0x0
  80208a:	6a 00                	push   $0x0
  80208c:	6a 00                	push   $0x0
  80208e:	6a 16                	push   $0x16
  802090:	e8 b9 fd ff ff       	call   801e4e <syscall>
  802095:	83 c4 18             	add    $0x18,%esp
}
  802098:	90                   	nop
  802099:	c9                   	leave  
  80209a:	c3                   	ret    

0080209b <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80209b:	55                   	push   %ebp
  80209c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80209e:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a1:	6a 00                	push   $0x0
  8020a3:	6a 00                	push   $0x0
  8020a5:	6a 00                	push   $0x0
  8020a7:	ff 75 0c             	pushl  0xc(%ebp)
  8020aa:	50                   	push   %eax
  8020ab:	6a 17                	push   $0x17
  8020ad:	e8 9c fd ff ff       	call   801e4e <syscall>
  8020b2:	83 c4 18             	add    $0x18,%esp
}
  8020b5:	c9                   	leave  
  8020b6:	c3                   	ret    

008020b7 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8020b7:	55                   	push   %ebp
  8020b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8020ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c0:	6a 00                	push   $0x0
  8020c2:	6a 00                	push   $0x0
  8020c4:	6a 00                	push   $0x0
  8020c6:	52                   	push   %edx
  8020c7:	50                   	push   %eax
  8020c8:	6a 1a                	push   $0x1a
  8020ca:	e8 7f fd ff ff       	call   801e4e <syscall>
  8020cf:	83 c4 18             	add    $0x18,%esp
}
  8020d2:	c9                   	leave  
  8020d3:	c3                   	ret    

008020d4 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8020d4:	55                   	push   %ebp
  8020d5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8020d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020da:	8b 45 08             	mov    0x8(%ebp),%eax
  8020dd:	6a 00                	push   $0x0
  8020df:	6a 00                	push   $0x0
  8020e1:	6a 00                	push   $0x0
  8020e3:	52                   	push   %edx
  8020e4:	50                   	push   %eax
  8020e5:	6a 18                	push   $0x18
  8020e7:	e8 62 fd ff ff       	call   801e4e <syscall>
  8020ec:	83 c4 18             	add    $0x18,%esp
}
  8020ef:	90                   	nop
  8020f0:	c9                   	leave  
  8020f1:	c3                   	ret    

008020f2 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8020f2:	55                   	push   %ebp
  8020f3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8020f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fb:	6a 00                	push   $0x0
  8020fd:	6a 00                	push   $0x0
  8020ff:	6a 00                	push   $0x0
  802101:	52                   	push   %edx
  802102:	50                   	push   %eax
  802103:	6a 19                	push   $0x19
  802105:	e8 44 fd ff ff       	call   801e4e <syscall>
  80210a:	83 c4 18             	add    $0x18,%esp
}
  80210d:	90                   	nop
  80210e:	c9                   	leave  
  80210f:	c3                   	ret    

00802110 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802110:	55                   	push   %ebp
  802111:	89 e5                	mov    %esp,%ebp
  802113:	83 ec 04             	sub    $0x4,%esp
  802116:	8b 45 10             	mov    0x10(%ebp),%eax
  802119:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80211c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80211f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802123:	8b 45 08             	mov    0x8(%ebp),%eax
  802126:	6a 00                	push   $0x0
  802128:	51                   	push   %ecx
  802129:	52                   	push   %edx
  80212a:	ff 75 0c             	pushl  0xc(%ebp)
  80212d:	50                   	push   %eax
  80212e:	6a 1b                	push   $0x1b
  802130:	e8 19 fd ff ff       	call   801e4e <syscall>
  802135:	83 c4 18             	add    $0x18,%esp
}
  802138:	c9                   	leave  
  802139:	c3                   	ret    

0080213a <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80213a:	55                   	push   %ebp
  80213b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80213d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802140:	8b 45 08             	mov    0x8(%ebp),%eax
  802143:	6a 00                	push   $0x0
  802145:	6a 00                	push   $0x0
  802147:	6a 00                	push   $0x0
  802149:	52                   	push   %edx
  80214a:	50                   	push   %eax
  80214b:	6a 1c                	push   $0x1c
  80214d:	e8 fc fc ff ff       	call   801e4e <syscall>
  802152:	83 c4 18             	add    $0x18,%esp
}
  802155:	c9                   	leave  
  802156:	c3                   	ret    

00802157 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802157:	55                   	push   %ebp
  802158:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80215a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80215d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802160:	8b 45 08             	mov    0x8(%ebp),%eax
  802163:	6a 00                	push   $0x0
  802165:	6a 00                	push   $0x0
  802167:	51                   	push   %ecx
  802168:	52                   	push   %edx
  802169:	50                   	push   %eax
  80216a:	6a 1d                	push   $0x1d
  80216c:	e8 dd fc ff ff       	call   801e4e <syscall>
  802171:	83 c4 18             	add    $0x18,%esp
}
  802174:	c9                   	leave  
  802175:	c3                   	ret    

00802176 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802176:	55                   	push   %ebp
  802177:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802179:	8b 55 0c             	mov    0xc(%ebp),%edx
  80217c:	8b 45 08             	mov    0x8(%ebp),%eax
  80217f:	6a 00                	push   $0x0
  802181:	6a 00                	push   $0x0
  802183:	6a 00                	push   $0x0
  802185:	52                   	push   %edx
  802186:	50                   	push   %eax
  802187:	6a 1e                	push   $0x1e
  802189:	e8 c0 fc ff ff       	call   801e4e <syscall>
  80218e:	83 c4 18             	add    $0x18,%esp
}
  802191:	c9                   	leave  
  802192:	c3                   	ret    

00802193 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802193:	55                   	push   %ebp
  802194:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802196:	6a 00                	push   $0x0
  802198:	6a 00                	push   $0x0
  80219a:	6a 00                	push   $0x0
  80219c:	6a 00                	push   $0x0
  80219e:	6a 00                	push   $0x0
  8021a0:	6a 1f                	push   $0x1f
  8021a2:	e8 a7 fc ff ff       	call   801e4e <syscall>
  8021a7:	83 c4 18             	add    $0x18,%esp
}
  8021aa:	c9                   	leave  
  8021ab:	c3                   	ret    

008021ac <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8021ac:	55                   	push   %ebp
  8021ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8021af:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b2:	6a 00                	push   $0x0
  8021b4:	ff 75 14             	pushl  0x14(%ebp)
  8021b7:	ff 75 10             	pushl  0x10(%ebp)
  8021ba:	ff 75 0c             	pushl  0xc(%ebp)
  8021bd:	50                   	push   %eax
  8021be:	6a 20                	push   $0x20
  8021c0:	e8 89 fc ff ff       	call   801e4e <syscall>
  8021c5:	83 c4 18             	add    $0x18,%esp
}
  8021c8:	c9                   	leave  
  8021c9:	c3                   	ret    

008021ca <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8021ca:	55                   	push   %ebp
  8021cb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8021cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d0:	6a 00                	push   $0x0
  8021d2:	6a 00                	push   $0x0
  8021d4:	6a 00                	push   $0x0
  8021d6:	6a 00                	push   $0x0
  8021d8:	50                   	push   %eax
  8021d9:	6a 21                	push   $0x21
  8021db:	e8 6e fc ff ff       	call   801e4e <syscall>
  8021e0:	83 c4 18             	add    $0x18,%esp
}
  8021e3:	90                   	nop
  8021e4:	c9                   	leave  
  8021e5:	c3                   	ret    

008021e6 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8021e6:	55                   	push   %ebp
  8021e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8021e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ec:	6a 00                	push   $0x0
  8021ee:	6a 00                	push   $0x0
  8021f0:	6a 00                	push   $0x0
  8021f2:	6a 00                	push   $0x0
  8021f4:	50                   	push   %eax
  8021f5:	6a 22                	push   $0x22
  8021f7:	e8 52 fc ff ff       	call   801e4e <syscall>
  8021fc:	83 c4 18             	add    $0x18,%esp
}
  8021ff:	c9                   	leave  
  802200:	c3                   	ret    

00802201 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802201:	55                   	push   %ebp
  802202:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802204:	6a 00                	push   $0x0
  802206:	6a 00                	push   $0x0
  802208:	6a 00                	push   $0x0
  80220a:	6a 00                	push   $0x0
  80220c:	6a 00                	push   $0x0
  80220e:	6a 02                	push   $0x2
  802210:	e8 39 fc ff ff       	call   801e4e <syscall>
  802215:	83 c4 18             	add    $0x18,%esp
}
  802218:	c9                   	leave  
  802219:	c3                   	ret    

0080221a <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80221a:	55                   	push   %ebp
  80221b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80221d:	6a 00                	push   $0x0
  80221f:	6a 00                	push   $0x0
  802221:	6a 00                	push   $0x0
  802223:	6a 00                	push   $0x0
  802225:	6a 00                	push   $0x0
  802227:	6a 03                	push   $0x3
  802229:	e8 20 fc ff ff       	call   801e4e <syscall>
  80222e:	83 c4 18             	add    $0x18,%esp
}
  802231:	c9                   	leave  
  802232:	c3                   	ret    

00802233 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802233:	55                   	push   %ebp
  802234:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802236:	6a 00                	push   $0x0
  802238:	6a 00                	push   $0x0
  80223a:	6a 00                	push   $0x0
  80223c:	6a 00                	push   $0x0
  80223e:	6a 00                	push   $0x0
  802240:	6a 04                	push   $0x4
  802242:	e8 07 fc ff ff       	call   801e4e <syscall>
  802247:	83 c4 18             	add    $0x18,%esp
}
  80224a:	c9                   	leave  
  80224b:	c3                   	ret    

0080224c <sys_exit_env>:


void sys_exit_env(void)
{
  80224c:	55                   	push   %ebp
  80224d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80224f:	6a 00                	push   $0x0
  802251:	6a 00                	push   $0x0
  802253:	6a 00                	push   $0x0
  802255:	6a 00                	push   $0x0
  802257:	6a 00                	push   $0x0
  802259:	6a 23                	push   $0x23
  80225b:	e8 ee fb ff ff       	call   801e4e <syscall>
  802260:	83 c4 18             	add    $0x18,%esp
}
  802263:	90                   	nop
  802264:	c9                   	leave  
  802265:	c3                   	ret    

00802266 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802266:	55                   	push   %ebp
  802267:	89 e5                	mov    %esp,%ebp
  802269:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80226c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80226f:	8d 50 04             	lea    0x4(%eax),%edx
  802272:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802275:	6a 00                	push   $0x0
  802277:	6a 00                	push   $0x0
  802279:	6a 00                	push   $0x0
  80227b:	52                   	push   %edx
  80227c:	50                   	push   %eax
  80227d:	6a 24                	push   $0x24
  80227f:	e8 ca fb ff ff       	call   801e4e <syscall>
  802284:	83 c4 18             	add    $0x18,%esp
	return result;
  802287:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80228a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80228d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802290:	89 01                	mov    %eax,(%ecx)
  802292:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802295:	8b 45 08             	mov    0x8(%ebp),%eax
  802298:	c9                   	leave  
  802299:	c2 04 00             	ret    $0x4

0080229c <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80229c:	55                   	push   %ebp
  80229d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80229f:	6a 00                	push   $0x0
  8022a1:	6a 00                	push   $0x0
  8022a3:	ff 75 10             	pushl  0x10(%ebp)
  8022a6:	ff 75 0c             	pushl  0xc(%ebp)
  8022a9:	ff 75 08             	pushl  0x8(%ebp)
  8022ac:	6a 12                	push   $0x12
  8022ae:	e8 9b fb ff ff       	call   801e4e <syscall>
  8022b3:	83 c4 18             	add    $0x18,%esp
	return ;
  8022b6:	90                   	nop
}
  8022b7:	c9                   	leave  
  8022b8:	c3                   	ret    

008022b9 <sys_rcr2>:
uint32 sys_rcr2()
{
  8022b9:	55                   	push   %ebp
  8022ba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8022bc:	6a 00                	push   $0x0
  8022be:	6a 00                	push   $0x0
  8022c0:	6a 00                	push   $0x0
  8022c2:	6a 00                	push   $0x0
  8022c4:	6a 00                	push   $0x0
  8022c6:	6a 25                	push   $0x25
  8022c8:	e8 81 fb ff ff       	call   801e4e <syscall>
  8022cd:	83 c4 18             	add    $0x18,%esp
}
  8022d0:	c9                   	leave  
  8022d1:	c3                   	ret    

008022d2 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8022d2:	55                   	push   %ebp
  8022d3:	89 e5                	mov    %esp,%ebp
  8022d5:	83 ec 04             	sub    $0x4,%esp
  8022d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022db:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8022de:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8022e2:	6a 00                	push   $0x0
  8022e4:	6a 00                	push   $0x0
  8022e6:	6a 00                	push   $0x0
  8022e8:	6a 00                	push   $0x0
  8022ea:	50                   	push   %eax
  8022eb:	6a 26                	push   $0x26
  8022ed:	e8 5c fb ff ff       	call   801e4e <syscall>
  8022f2:	83 c4 18             	add    $0x18,%esp
	return ;
  8022f5:	90                   	nop
}
  8022f6:	c9                   	leave  
  8022f7:	c3                   	ret    

008022f8 <rsttst>:
void rsttst()
{
  8022f8:	55                   	push   %ebp
  8022f9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8022fb:	6a 00                	push   $0x0
  8022fd:	6a 00                	push   $0x0
  8022ff:	6a 00                	push   $0x0
  802301:	6a 00                	push   $0x0
  802303:	6a 00                	push   $0x0
  802305:	6a 28                	push   $0x28
  802307:	e8 42 fb ff ff       	call   801e4e <syscall>
  80230c:	83 c4 18             	add    $0x18,%esp
	return ;
  80230f:	90                   	nop
}
  802310:	c9                   	leave  
  802311:	c3                   	ret    

00802312 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802312:	55                   	push   %ebp
  802313:	89 e5                	mov    %esp,%ebp
  802315:	83 ec 04             	sub    $0x4,%esp
  802318:	8b 45 14             	mov    0x14(%ebp),%eax
  80231b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80231e:	8b 55 18             	mov    0x18(%ebp),%edx
  802321:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802325:	52                   	push   %edx
  802326:	50                   	push   %eax
  802327:	ff 75 10             	pushl  0x10(%ebp)
  80232a:	ff 75 0c             	pushl  0xc(%ebp)
  80232d:	ff 75 08             	pushl  0x8(%ebp)
  802330:	6a 27                	push   $0x27
  802332:	e8 17 fb ff ff       	call   801e4e <syscall>
  802337:	83 c4 18             	add    $0x18,%esp
	return ;
  80233a:	90                   	nop
}
  80233b:	c9                   	leave  
  80233c:	c3                   	ret    

0080233d <chktst>:
void chktst(uint32 n)
{
  80233d:	55                   	push   %ebp
  80233e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802340:	6a 00                	push   $0x0
  802342:	6a 00                	push   $0x0
  802344:	6a 00                	push   $0x0
  802346:	6a 00                	push   $0x0
  802348:	ff 75 08             	pushl  0x8(%ebp)
  80234b:	6a 29                	push   $0x29
  80234d:	e8 fc fa ff ff       	call   801e4e <syscall>
  802352:	83 c4 18             	add    $0x18,%esp
	return ;
  802355:	90                   	nop
}
  802356:	c9                   	leave  
  802357:	c3                   	ret    

00802358 <inctst>:

void inctst()
{
  802358:	55                   	push   %ebp
  802359:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80235b:	6a 00                	push   $0x0
  80235d:	6a 00                	push   $0x0
  80235f:	6a 00                	push   $0x0
  802361:	6a 00                	push   $0x0
  802363:	6a 00                	push   $0x0
  802365:	6a 2a                	push   $0x2a
  802367:	e8 e2 fa ff ff       	call   801e4e <syscall>
  80236c:	83 c4 18             	add    $0x18,%esp
	return ;
  80236f:	90                   	nop
}
  802370:	c9                   	leave  
  802371:	c3                   	ret    

00802372 <gettst>:
uint32 gettst()
{
  802372:	55                   	push   %ebp
  802373:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802375:	6a 00                	push   $0x0
  802377:	6a 00                	push   $0x0
  802379:	6a 00                	push   $0x0
  80237b:	6a 00                	push   $0x0
  80237d:	6a 00                	push   $0x0
  80237f:	6a 2b                	push   $0x2b
  802381:	e8 c8 fa ff ff       	call   801e4e <syscall>
  802386:	83 c4 18             	add    $0x18,%esp
}
  802389:	c9                   	leave  
  80238a:	c3                   	ret    

0080238b <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80238b:	55                   	push   %ebp
  80238c:	89 e5                	mov    %esp,%ebp
  80238e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802391:	6a 00                	push   $0x0
  802393:	6a 00                	push   $0x0
  802395:	6a 00                	push   $0x0
  802397:	6a 00                	push   $0x0
  802399:	6a 00                	push   $0x0
  80239b:	6a 2c                	push   $0x2c
  80239d:	e8 ac fa ff ff       	call   801e4e <syscall>
  8023a2:	83 c4 18             	add    $0x18,%esp
  8023a5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8023a8:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8023ac:	75 07                	jne    8023b5 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8023ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8023b3:	eb 05                	jmp    8023ba <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8023b5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023ba:	c9                   	leave  
  8023bb:	c3                   	ret    

008023bc <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8023bc:	55                   	push   %ebp
  8023bd:	89 e5                	mov    %esp,%ebp
  8023bf:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023c2:	6a 00                	push   $0x0
  8023c4:	6a 00                	push   $0x0
  8023c6:	6a 00                	push   $0x0
  8023c8:	6a 00                	push   $0x0
  8023ca:	6a 00                	push   $0x0
  8023cc:	6a 2c                	push   $0x2c
  8023ce:	e8 7b fa ff ff       	call   801e4e <syscall>
  8023d3:	83 c4 18             	add    $0x18,%esp
  8023d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8023d9:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8023dd:	75 07                	jne    8023e6 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8023df:	b8 01 00 00 00       	mov    $0x1,%eax
  8023e4:	eb 05                	jmp    8023eb <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8023e6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023eb:	c9                   	leave  
  8023ec:	c3                   	ret    

008023ed <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8023ed:	55                   	push   %ebp
  8023ee:	89 e5                	mov    %esp,%ebp
  8023f0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023f3:	6a 00                	push   $0x0
  8023f5:	6a 00                	push   $0x0
  8023f7:	6a 00                	push   $0x0
  8023f9:	6a 00                	push   $0x0
  8023fb:	6a 00                	push   $0x0
  8023fd:	6a 2c                	push   $0x2c
  8023ff:	e8 4a fa ff ff       	call   801e4e <syscall>
  802404:	83 c4 18             	add    $0x18,%esp
  802407:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80240a:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80240e:	75 07                	jne    802417 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802410:	b8 01 00 00 00       	mov    $0x1,%eax
  802415:	eb 05                	jmp    80241c <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802417:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80241c:	c9                   	leave  
  80241d:	c3                   	ret    

0080241e <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80241e:	55                   	push   %ebp
  80241f:	89 e5                	mov    %esp,%ebp
  802421:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802424:	6a 00                	push   $0x0
  802426:	6a 00                	push   $0x0
  802428:	6a 00                	push   $0x0
  80242a:	6a 00                	push   $0x0
  80242c:	6a 00                	push   $0x0
  80242e:	6a 2c                	push   $0x2c
  802430:	e8 19 fa ff ff       	call   801e4e <syscall>
  802435:	83 c4 18             	add    $0x18,%esp
  802438:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80243b:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80243f:	75 07                	jne    802448 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802441:	b8 01 00 00 00       	mov    $0x1,%eax
  802446:	eb 05                	jmp    80244d <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802448:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80244d:	c9                   	leave  
  80244e:	c3                   	ret    

0080244f <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80244f:	55                   	push   %ebp
  802450:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802452:	6a 00                	push   $0x0
  802454:	6a 00                	push   $0x0
  802456:	6a 00                	push   $0x0
  802458:	6a 00                	push   $0x0
  80245a:	ff 75 08             	pushl  0x8(%ebp)
  80245d:	6a 2d                	push   $0x2d
  80245f:	e8 ea f9 ff ff       	call   801e4e <syscall>
  802464:	83 c4 18             	add    $0x18,%esp
	return ;
  802467:	90                   	nop
}
  802468:	c9                   	leave  
  802469:	c3                   	ret    

0080246a <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80246a:	55                   	push   %ebp
  80246b:	89 e5                	mov    %esp,%ebp
  80246d:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80246e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802471:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802474:	8b 55 0c             	mov    0xc(%ebp),%edx
  802477:	8b 45 08             	mov    0x8(%ebp),%eax
  80247a:	6a 00                	push   $0x0
  80247c:	53                   	push   %ebx
  80247d:	51                   	push   %ecx
  80247e:	52                   	push   %edx
  80247f:	50                   	push   %eax
  802480:	6a 2e                	push   $0x2e
  802482:	e8 c7 f9 ff ff       	call   801e4e <syscall>
  802487:	83 c4 18             	add    $0x18,%esp
}
  80248a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80248d:	c9                   	leave  
  80248e:	c3                   	ret    

0080248f <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80248f:	55                   	push   %ebp
  802490:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802492:	8b 55 0c             	mov    0xc(%ebp),%edx
  802495:	8b 45 08             	mov    0x8(%ebp),%eax
  802498:	6a 00                	push   $0x0
  80249a:	6a 00                	push   $0x0
  80249c:	6a 00                	push   $0x0
  80249e:	52                   	push   %edx
  80249f:	50                   	push   %eax
  8024a0:	6a 2f                	push   $0x2f
  8024a2:	e8 a7 f9 ff ff       	call   801e4e <syscall>
  8024a7:	83 c4 18             	add    $0x18,%esp
}
  8024aa:	c9                   	leave  
  8024ab:	c3                   	ret    

008024ac <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8024ac:	55                   	push   %ebp
  8024ad:	89 e5                	mov    %esp,%ebp
  8024af:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8024b2:	83 ec 0c             	sub    $0xc,%esp
  8024b5:	68 d8 45 80 00       	push   $0x8045d8
  8024ba:	e8 86 e5 ff ff       	call   800a45 <cprintf>
  8024bf:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8024c2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8024c9:	83 ec 0c             	sub    $0xc,%esp
  8024cc:	68 04 46 80 00       	push   $0x804604
  8024d1:	e8 6f e5 ff ff       	call   800a45 <cprintf>
  8024d6:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8024d9:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8024dd:	a1 38 51 80 00       	mov    0x805138,%eax
  8024e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024e5:	eb 56                	jmp    80253d <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8024e7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024eb:	74 1c                	je     802509 <print_mem_block_lists+0x5d>
  8024ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f0:	8b 50 08             	mov    0x8(%eax),%edx
  8024f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024f6:	8b 48 08             	mov    0x8(%eax),%ecx
  8024f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024fc:	8b 40 0c             	mov    0xc(%eax),%eax
  8024ff:	01 c8                	add    %ecx,%eax
  802501:	39 c2                	cmp    %eax,%edx
  802503:	73 04                	jae    802509 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802505:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802509:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250c:	8b 50 08             	mov    0x8(%eax),%edx
  80250f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802512:	8b 40 0c             	mov    0xc(%eax),%eax
  802515:	01 c2                	add    %eax,%edx
  802517:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251a:	8b 40 08             	mov    0x8(%eax),%eax
  80251d:	83 ec 04             	sub    $0x4,%esp
  802520:	52                   	push   %edx
  802521:	50                   	push   %eax
  802522:	68 19 46 80 00       	push   $0x804619
  802527:	e8 19 e5 ff ff       	call   800a45 <cprintf>
  80252c:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80252f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802532:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802535:	a1 40 51 80 00       	mov    0x805140,%eax
  80253a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80253d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802541:	74 07                	je     80254a <print_mem_block_lists+0x9e>
  802543:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802546:	8b 00                	mov    (%eax),%eax
  802548:	eb 05                	jmp    80254f <print_mem_block_lists+0xa3>
  80254a:	b8 00 00 00 00       	mov    $0x0,%eax
  80254f:	a3 40 51 80 00       	mov    %eax,0x805140
  802554:	a1 40 51 80 00       	mov    0x805140,%eax
  802559:	85 c0                	test   %eax,%eax
  80255b:	75 8a                	jne    8024e7 <print_mem_block_lists+0x3b>
  80255d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802561:	75 84                	jne    8024e7 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802563:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802567:	75 10                	jne    802579 <print_mem_block_lists+0xcd>
  802569:	83 ec 0c             	sub    $0xc,%esp
  80256c:	68 28 46 80 00       	push   $0x804628
  802571:	e8 cf e4 ff ff       	call   800a45 <cprintf>
  802576:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802579:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802580:	83 ec 0c             	sub    $0xc,%esp
  802583:	68 4c 46 80 00       	push   $0x80464c
  802588:	e8 b8 e4 ff ff       	call   800a45 <cprintf>
  80258d:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802590:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802594:	a1 40 50 80 00       	mov    0x805040,%eax
  802599:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80259c:	eb 56                	jmp    8025f4 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80259e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025a2:	74 1c                	je     8025c0 <print_mem_block_lists+0x114>
  8025a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a7:	8b 50 08             	mov    0x8(%eax),%edx
  8025aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025ad:	8b 48 08             	mov    0x8(%eax),%ecx
  8025b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025b3:	8b 40 0c             	mov    0xc(%eax),%eax
  8025b6:	01 c8                	add    %ecx,%eax
  8025b8:	39 c2                	cmp    %eax,%edx
  8025ba:	73 04                	jae    8025c0 <print_mem_block_lists+0x114>
			sorted = 0 ;
  8025bc:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8025c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c3:	8b 50 08             	mov    0x8(%eax),%edx
  8025c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c9:	8b 40 0c             	mov    0xc(%eax),%eax
  8025cc:	01 c2                	add    %eax,%edx
  8025ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d1:	8b 40 08             	mov    0x8(%eax),%eax
  8025d4:	83 ec 04             	sub    $0x4,%esp
  8025d7:	52                   	push   %edx
  8025d8:	50                   	push   %eax
  8025d9:	68 19 46 80 00       	push   $0x804619
  8025de:	e8 62 e4 ff ff       	call   800a45 <cprintf>
  8025e3:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8025e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8025ec:	a1 48 50 80 00       	mov    0x805048,%eax
  8025f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025f8:	74 07                	je     802601 <print_mem_block_lists+0x155>
  8025fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fd:	8b 00                	mov    (%eax),%eax
  8025ff:	eb 05                	jmp    802606 <print_mem_block_lists+0x15a>
  802601:	b8 00 00 00 00       	mov    $0x0,%eax
  802606:	a3 48 50 80 00       	mov    %eax,0x805048
  80260b:	a1 48 50 80 00       	mov    0x805048,%eax
  802610:	85 c0                	test   %eax,%eax
  802612:	75 8a                	jne    80259e <print_mem_block_lists+0xf2>
  802614:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802618:	75 84                	jne    80259e <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80261a:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80261e:	75 10                	jne    802630 <print_mem_block_lists+0x184>
  802620:	83 ec 0c             	sub    $0xc,%esp
  802623:	68 64 46 80 00       	push   $0x804664
  802628:	e8 18 e4 ff ff       	call   800a45 <cprintf>
  80262d:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802630:	83 ec 0c             	sub    $0xc,%esp
  802633:	68 d8 45 80 00       	push   $0x8045d8
  802638:	e8 08 e4 ff ff       	call   800a45 <cprintf>
  80263d:	83 c4 10             	add    $0x10,%esp

}
  802640:	90                   	nop
  802641:	c9                   	leave  
  802642:	c3                   	ret    

00802643 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802643:	55                   	push   %ebp
  802644:	89 e5                	mov    %esp,%ebp
  802646:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  802649:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802650:	00 00 00 
  802653:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80265a:	00 00 00 
  80265d:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802664:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  802667:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80266e:	e9 9e 00 00 00       	jmp    802711 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802673:	a1 50 50 80 00       	mov    0x805050,%eax
  802678:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80267b:	c1 e2 04             	shl    $0x4,%edx
  80267e:	01 d0                	add    %edx,%eax
  802680:	85 c0                	test   %eax,%eax
  802682:	75 14                	jne    802698 <initialize_MemBlocksList+0x55>
  802684:	83 ec 04             	sub    $0x4,%esp
  802687:	68 8c 46 80 00       	push   $0x80468c
  80268c:	6a 46                	push   $0x46
  80268e:	68 af 46 80 00       	push   $0x8046af
  802693:	e8 f9 e0 ff ff       	call   800791 <_panic>
  802698:	a1 50 50 80 00       	mov    0x805050,%eax
  80269d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026a0:	c1 e2 04             	shl    $0x4,%edx
  8026a3:	01 d0                	add    %edx,%eax
  8026a5:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8026ab:	89 10                	mov    %edx,(%eax)
  8026ad:	8b 00                	mov    (%eax),%eax
  8026af:	85 c0                	test   %eax,%eax
  8026b1:	74 18                	je     8026cb <initialize_MemBlocksList+0x88>
  8026b3:	a1 48 51 80 00       	mov    0x805148,%eax
  8026b8:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8026be:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8026c1:	c1 e1 04             	shl    $0x4,%ecx
  8026c4:	01 ca                	add    %ecx,%edx
  8026c6:	89 50 04             	mov    %edx,0x4(%eax)
  8026c9:	eb 12                	jmp    8026dd <initialize_MemBlocksList+0x9a>
  8026cb:	a1 50 50 80 00       	mov    0x805050,%eax
  8026d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026d3:	c1 e2 04             	shl    $0x4,%edx
  8026d6:	01 d0                	add    %edx,%eax
  8026d8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8026dd:	a1 50 50 80 00       	mov    0x805050,%eax
  8026e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026e5:	c1 e2 04             	shl    $0x4,%edx
  8026e8:	01 d0                	add    %edx,%eax
  8026ea:	a3 48 51 80 00       	mov    %eax,0x805148
  8026ef:	a1 50 50 80 00       	mov    0x805050,%eax
  8026f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026f7:	c1 e2 04             	shl    $0x4,%edx
  8026fa:	01 d0                	add    %edx,%eax
  8026fc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802703:	a1 54 51 80 00       	mov    0x805154,%eax
  802708:	40                   	inc    %eax
  802709:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  80270e:	ff 45 f4             	incl   -0xc(%ebp)
  802711:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802714:	3b 45 08             	cmp    0x8(%ebp),%eax
  802717:	0f 82 56 ff ff ff    	jb     802673 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  80271d:	90                   	nop
  80271e:	c9                   	leave  
  80271f:	c3                   	ret    

00802720 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802720:	55                   	push   %ebp
  802721:	89 e5                	mov    %esp,%ebp
  802723:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802726:	8b 45 08             	mov    0x8(%ebp),%eax
  802729:	8b 00                	mov    (%eax),%eax
  80272b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80272e:	eb 19                	jmp    802749 <find_block+0x29>
	{
		if(va==point->sva)
  802730:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802733:	8b 40 08             	mov    0x8(%eax),%eax
  802736:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802739:	75 05                	jne    802740 <find_block+0x20>
		   return point;
  80273b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80273e:	eb 36                	jmp    802776 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802740:	8b 45 08             	mov    0x8(%ebp),%eax
  802743:	8b 40 08             	mov    0x8(%eax),%eax
  802746:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802749:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80274d:	74 07                	je     802756 <find_block+0x36>
  80274f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802752:	8b 00                	mov    (%eax),%eax
  802754:	eb 05                	jmp    80275b <find_block+0x3b>
  802756:	b8 00 00 00 00       	mov    $0x0,%eax
  80275b:	8b 55 08             	mov    0x8(%ebp),%edx
  80275e:	89 42 08             	mov    %eax,0x8(%edx)
  802761:	8b 45 08             	mov    0x8(%ebp),%eax
  802764:	8b 40 08             	mov    0x8(%eax),%eax
  802767:	85 c0                	test   %eax,%eax
  802769:	75 c5                	jne    802730 <find_block+0x10>
  80276b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80276f:	75 bf                	jne    802730 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802771:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802776:	c9                   	leave  
  802777:	c3                   	ret    

00802778 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802778:	55                   	push   %ebp
  802779:	89 e5                	mov    %esp,%ebp
  80277b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  80277e:	a1 40 50 80 00       	mov    0x805040,%eax
  802783:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802786:	a1 44 50 80 00       	mov    0x805044,%eax
  80278b:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  80278e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802791:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802794:	74 24                	je     8027ba <insert_sorted_allocList+0x42>
  802796:	8b 45 08             	mov    0x8(%ebp),%eax
  802799:	8b 50 08             	mov    0x8(%eax),%edx
  80279c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80279f:	8b 40 08             	mov    0x8(%eax),%eax
  8027a2:	39 c2                	cmp    %eax,%edx
  8027a4:	76 14                	jbe    8027ba <insert_sorted_allocList+0x42>
  8027a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a9:	8b 50 08             	mov    0x8(%eax),%edx
  8027ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027af:	8b 40 08             	mov    0x8(%eax),%eax
  8027b2:	39 c2                	cmp    %eax,%edx
  8027b4:	0f 82 60 01 00 00    	jb     80291a <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8027ba:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027be:	75 65                	jne    802825 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8027c0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8027c4:	75 14                	jne    8027da <insert_sorted_allocList+0x62>
  8027c6:	83 ec 04             	sub    $0x4,%esp
  8027c9:	68 8c 46 80 00       	push   $0x80468c
  8027ce:	6a 6b                	push   $0x6b
  8027d0:	68 af 46 80 00       	push   $0x8046af
  8027d5:	e8 b7 df ff ff       	call   800791 <_panic>
  8027da:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8027e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e3:	89 10                	mov    %edx,(%eax)
  8027e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e8:	8b 00                	mov    (%eax),%eax
  8027ea:	85 c0                	test   %eax,%eax
  8027ec:	74 0d                	je     8027fb <insert_sorted_allocList+0x83>
  8027ee:	a1 40 50 80 00       	mov    0x805040,%eax
  8027f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8027f6:	89 50 04             	mov    %edx,0x4(%eax)
  8027f9:	eb 08                	jmp    802803 <insert_sorted_allocList+0x8b>
  8027fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8027fe:	a3 44 50 80 00       	mov    %eax,0x805044
  802803:	8b 45 08             	mov    0x8(%ebp),%eax
  802806:	a3 40 50 80 00       	mov    %eax,0x805040
  80280b:	8b 45 08             	mov    0x8(%ebp),%eax
  80280e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802815:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80281a:	40                   	inc    %eax
  80281b:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802820:	e9 dc 01 00 00       	jmp    802a01 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802825:	8b 45 08             	mov    0x8(%ebp),%eax
  802828:	8b 50 08             	mov    0x8(%eax),%edx
  80282b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80282e:	8b 40 08             	mov    0x8(%eax),%eax
  802831:	39 c2                	cmp    %eax,%edx
  802833:	77 6c                	ja     8028a1 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802835:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802839:	74 06                	je     802841 <insert_sorted_allocList+0xc9>
  80283b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80283f:	75 14                	jne    802855 <insert_sorted_allocList+0xdd>
  802841:	83 ec 04             	sub    $0x4,%esp
  802844:	68 c8 46 80 00       	push   $0x8046c8
  802849:	6a 6f                	push   $0x6f
  80284b:	68 af 46 80 00       	push   $0x8046af
  802850:	e8 3c df ff ff       	call   800791 <_panic>
  802855:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802858:	8b 50 04             	mov    0x4(%eax),%edx
  80285b:	8b 45 08             	mov    0x8(%ebp),%eax
  80285e:	89 50 04             	mov    %edx,0x4(%eax)
  802861:	8b 45 08             	mov    0x8(%ebp),%eax
  802864:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802867:	89 10                	mov    %edx,(%eax)
  802869:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80286c:	8b 40 04             	mov    0x4(%eax),%eax
  80286f:	85 c0                	test   %eax,%eax
  802871:	74 0d                	je     802880 <insert_sorted_allocList+0x108>
  802873:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802876:	8b 40 04             	mov    0x4(%eax),%eax
  802879:	8b 55 08             	mov    0x8(%ebp),%edx
  80287c:	89 10                	mov    %edx,(%eax)
  80287e:	eb 08                	jmp    802888 <insert_sorted_allocList+0x110>
  802880:	8b 45 08             	mov    0x8(%ebp),%eax
  802883:	a3 40 50 80 00       	mov    %eax,0x805040
  802888:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80288b:	8b 55 08             	mov    0x8(%ebp),%edx
  80288e:	89 50 04             	mov    %edx,0x4(%eax)
  802891:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802896:	40                   	inc    %eax
  802897:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80289c:	e9 60 01 00 00       	jmp    802a01 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8028a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a4:	8b 50 08             	mov    0x8(%eax),%edx
  8028a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028aa:	8b 40 08             	mov    0x8(%eax),%eax
  8028ad:	39 c2                	cmp    %eax,%edx
  8028af:	0f 82 4c 01 00 00    	jb     802a01 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8028b5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028b9:	75 14                	jne    8028cf <insert_sorted_allocList+0x157>
  8028bb:	83 ec 04             	sub    $0x4,%esp
  8028be:	68 00 47 80 00       	push   $0x804700
  8028c3:	6a 73                	push   $0x73
  8028c5:	68 af 46 80 00       	push   $0x8046af
  8028ca:	e8 c2 de ff ff       	call   800791 <_panic>
  8028cf:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8028d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d8:	89 50 04             	mov    %edx,0x4(%eax)
  8028db:	8b 45 08             	mov    0x8(%ebp),%eax
  8028de:	8b 40 04             	mov    0x4(%eax),%eax
  8028e1:	85 c0                	test   %eax,%eax
  8028e3:	74 0c                	je     8028f1 <insert_sorted_allocList+0x179>
  8028e5:	a1 44 50 80 00       	mov    0x805044,%eax
  8028ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8028ed:	89 10                	mov    %edx,(%eax)
  8028ef:	eb 08                	jmp    8028f9 <insert_sorted_allocList+0x181>
  8028f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f4:	a3 40 50 80 00       	mov    %eax,0x805040
  8028f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8028fc:	a3 44 50 80 00       	mov    %eax,0x805044
  802901:	8b 45 08             	mov    0x8(%ebp),%eax
  802904:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80290a:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80290f:	40                   	inc    %eax
  802910:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802915:	e9 e7 00 00 00       	jmp    802a01 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  80291a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80291d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802920:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802927:	a1 40 50 80 00       	mov    0x805040,%eax
  80292c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80292f:	e9 9d 00 00 00       	jmp    8029d1 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802934:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802937:	8b 00                	mov    (%eax),%eax
  802939:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  80293c:	8b 45 08             	mov    0x8(%ebp),%eax
  80293f:	8b 50 08             	mov    0x8(%eax),%edx
  802942:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802945:	8b 40 08             	mov    0x8(%eax),%eax
  802948:	39 c2                	cmp    %eax,%edx
  80294a:	76 7d                	jbe    8029c9 <insert_sorted_allocList+0x251>
  80294c:	8b 45 08             	mov    0x8(%ebp),%eax
  80294f:	8b 50 08             	mov    0x8(%eax),%edx
  802952:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802955:	8b 40 08             	mov    0x8(%eax),%eax
  802958:	39 c2                	cmp    %eax,%edx
  80295a:	73 6d                	jae    8029c9 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  80295c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802960:	74 06                	je     802968 <insert_sorted_allocList+0x1f0>
  802962:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802966:	75 14                	jne    80297c <insert_sorted_allocList+0x204>
  802968:	83 ec 04             	sub    $0x4,%esp
  80296b:	68 24 47 80 00       	push   $0x804724
  802970:	6a 7f                	push   $0x7f
  802972:	68 af 46 80 00       	push   $0x8046af
  802977:	e8 15 de ff ff       	call   800791 <_panic>
  80297c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297f:	8b 10                	mov    (%eax),%edx
  802981:	8b 45 08             	mov    0x8(%ebp),%eax
  802984:	89 10                	mov    %edx,(%eax)
  802986:	8b 45 08             	mov    0x8(%ebp),%eax
  802989:	8b 00                	mov    (%eax),%eax
  80298b:	85 c0                	test   %eax,%eax
  80298d:	74 0b                	je     80299a <insert_sorted_allocList+0x222>
  80298f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802992:	8b 00                	mov    (%eax),%eax
  802994:	8b 55 08             	mov    0x8(%ebp),%edx
  802997:	89 50 04             	mov    %edx,0x4(%eax)
  80299a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299d:	8b 55 08             	mov    0x8(%ebp),%edx
  8029a0:	89 10                	mov    %edx,(%eax)
  8029a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029a8:	89 50 04             	mov    %edx,0x4(%eax)
  8029ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ae:	8b 00                	mov    (%eax),%eax
  8029b0:	85 c0                	test   %eax,%eax
  8029b2:	75 08                	jne    8029bc <insert_sorted_allocList+0x244>
  8029b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b7:	a3 44 50 80 00       	mov    %eax,0x805044
  8029bc:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8029c1:	40                   	inc    %eax
  8029c2:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8029c7:	eb 39                	jmp    802a02 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8029c9:	a1 48 50 80 00       	mov    0x805048,%eax
  8029ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029d5:	74 07                	je     8029de <insert_sorted_allocList+0x266>
  8029d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029da:	8b 00                	mov    (%eax),%eax
  8029dc:	eb 05                	jmp    8029e3 <insert_sorted_allocList+0x26b>
  8029de:	b8 00 00 00 00       	mov    $0x0,%eax
  8029e3:	a3 48 50 80 00       	mov    %eax,0x805048
  8029e8:	a1 48 50 80 00       	mov    0x805048,%eax
  8029ed:	85 c0                	test   %eax,%eax
  8029ef:	0f 85 3f ff ff ff    	jne    802934 <insert_sorted_allocList+0x1bc>
  8029f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029f9:	0f 85 35 ff ff ff    	jne    802934 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8029ff:	eb 01                	jmp    802a02 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802a01:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802a02:	90                   	nop
  802a03:	c9                   	leave  
  802a04:	c3                   	ret    

00802a05 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802a05:	55                   	push   %ebp
  802a06:	89 e5                	mov    %esp,%ebp
  802a08:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802a0b:	a1 38 51 80 00       	mov    0x805138,%eax
  802a10:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a13:	e9 85 01 00 00       	jmp    802b9d <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802a18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1b:	8b 40 0c             	mov    0xc(%eax),%eax
  802a1e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a21:	0f 82 6e 01 00 00    	jb     802b95 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802a27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2a:	8b 40 0c             	mov    0xc(%eax),%eax
  802a2d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a30:	0f 85 8a 00 00 00    	jne    802ac0 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802a36:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a3a:	75 17                	jne    802a53 <alloc_block_FF+0x4e>
  802a3c:	83 ec 04             	sub    $0x4,%esp
  802a3f:	68 58 47 80 00       	push   $0x804758
  802a44:	68 93 00 00 00       	push   $0x93
  802a49:	68 af 46 80 00       	push   $0x8046af
  802a4e:	e8 3e dd ff ff       	call   800791 <_panic>
  802a53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a56:	8b 00                	mov    (%eax),%eax
  802a58:	85 c0                	test   %eax,%eax
  802a5a:	74 10                	je     802a6c <alloc_block_FF+0x67>
  802a5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5f:	8b 00                	mov    (%eax),%eax
  802a61:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a64:	8b 52 04             	mov    0x4(%edx),%edx
  802a67:	89 50 04             	mov    %edx,0x4(%eax)
  802a6a:	eb 0b                	jmp    802a77 <alloc_block_FF+0x72>
  802a6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6f:	8b 40 04             	mov    0x4(%eax),%eax
  802a72:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7a:	8b 40 04             	mov    0x4(%eax),%eax
  802a7d:	85 c0                	test   %eax,%eax
  802a7f:	74 0f                	je     802a90 <alloc_block_FF+0x8b>
  802a81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a84:	8b 40 04             	mov    0x4(%eax),%eax
  802a87:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a8a:	8b 12                	mov    (%edx),%edx
  802a8c:	89 10                	mov    %edx,(%eax)
  802a8e:	eb 0a                	jmp    802a9a <alloc_block_FF+0x95>
  802a90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a93:	8b 00                	mov    (%eax),%eax
  802a95:	a3 38 51 80 00       	mov    %eax,0x805138
  802a9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802aa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802aad:	a1 44 51 80 00       	mov    0x805144,%eax
  802ab2:	48                   	dec    %eax
  802ab3:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802ab8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802abb:	e9 10 01 00 00       	jmp    802bd0 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802ac0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac3:	8b 40 0c             	mov    0xc(%eax),%eax
  802ac6:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ac9:	0f 86 c6 00 00 00    	jbe    802b95 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802acf:	a1 48 51 80 00       	mov    0x805148,%eax
  802ad4:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802ad7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ada:	8b 50 08             	mov    0x8(%eax),%edx
  802add:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae0:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802ae3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae6:	8b 55 08             	mov    0x8(%ebp),%edx
  802ae9:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802aec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802af0:	75 17                	jne    802b09 <alloc_block_FF+0x104>
  802af2:	83 ec 04             	sub    $0x4,%esp
  802af5:	68 58 47 80 00       	push   $0x804758
  802afa:	68 9b 00 00 00       	push   $0x9b
  802aff:	68 af 46 80 00       	push   $0x8046af
  802b04:	e8 88 dc ff ff       	call   800791 <_panic>
  802b09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b0c:	8b 00                	mov    (%eax),%eax
  802b0e:	85 c0                	test   %eax,%eax
  802b10:	74 10                	je     802b22 <alloc_block_FF+0x11d>
  802b12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b15:	8b 00                	mov    (%eax),%eax
  802b17:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b1a:	8b 52 04             	mov    0x4(%edx),%edx
  802b1d:	89 50 04             	mov    %edx,0x4(%eax)
  802b20:	eb 0b                	jmp    802b2d <alloc_block_FF+0x128>
  802b22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b25:	8b 40 04             	mov    0x4(%eax),%eax
  802b28:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b30:	8b 40 04             	mov    0x4(%eax),%eax
  802b33:	85 c0                	test   %eax,%eax
  802b35:	74 0f                	je     802b46 <alloc_block_FF+0x141>
  802b37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b3a:	8b 40 04             	mov    0x4(%eax),%eax
  802b3d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b40:	8b 12                	mov    (%edx),%edx
  802b42:	89 10                	mov    %edx,(%eax)
  802b44:	eb 0a                	jmp    802b50 <alloc_block_FF+0x14b>
  802b46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b49:	8b 00                	mov    (%eax),%eax
  802b4b:	a3 48 51 80 00       	mov    %eax,0x805148
  802b50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b53:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b5c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b63:	a1 54 51 80 00       	mov    0x805154,%eax
  802b68:	48                   	dec    %eax
  802b69:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802b6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b71:	8b 50 08             	mov    0x8(%eax),%edx
  802b74:	8b 45 08             	mov    0x8(%ebp),%eax
  802b77:	01 c2                	add    %eax,%edx
  802b79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7c:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802b7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b82:	8b 40 0c             	mov    0xc(%eax),%eax
  802b85:	2b 45 08             	sub    0x8(%ebp),%eax
  802b88:	89 c2                	mov    %eax,%edx
  802b8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8d:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802b90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b93:	eb 3b                	jmp    802bd0 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802b95:	a1 40 51 80 00       	mov    0x805140,%eax
  802b9a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b9d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ba1:	74 07                	je     802baa <alloc_block_FF+0x1a5>
  802ba3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba6:	8b 00                	mov    (%eax),%eax
  802ba8:	eb 05                	jmp    802baf <alloc_block_FF+0x1aa>
  802baa:	b8 00 00 00 00       	mov    $0x0,%eax
  802baf:	a3 40 51 80 00       	mov    %eax,0x805140
  802bb4:	a1 40 51 80 00       	mov    0x805140,%eax
  802bb9:	85 c0                	test   %eax,%eax
  802bbb:	0f 85 57 fe ff ff    	jne    802a18 <alloc_block_FF+0x13>
  802bc1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bc5:	0f 85 4d fe ff ff    	jne    802a18 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802bcb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bd0:	c9                   	leave  
  802bd1:	c3                   	ret    

00802bd2 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802bd2:	55                   	push   %ebp
  802bd3:	89 e5                	mov    %esp,%ebp
  802bd5:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802bd8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802bdf:	a1 38 51 80 00       	mov    0x805138,%eax
  802be4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802be7:	e9 df 00 00 00       	jmp    802ccb <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802bec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bef:	8b 40 0c             	mov    0xc(%eax),%eax
  802bf2:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bf5:	0f 82 c8 00 00 00    	jb     802cc3 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802bfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfe:	8b 40 0c             	mov    0xc(%eax),%eax
  802c01:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c04:	0f 85 8a 00 00 00    	jne    802c94 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802c0a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c0e:	75 17                	jne    802c27 <alloc_block_BF+0x55>
  802c10:	83 ec 04             	sub    $0x4,%esp
  802c13:	68 58 47 80 00       	push   $0x804758
  802c18:	68 b7 00 00 00       	push   $0xb7
  802c1d:	68 af 46 80 00       	push   $0x8046af
  802c22:	e8 6a db ff ff       	call   800791 <_panic>
  802c27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2a:	8b 00                	mov    (%eax),%eax
  802c2c:	85 c0                	test   %eax,%eax
  802c2e:	74 10                	je     802c40 <alloc_block_BF+0x6e>
  802c30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c33:	8b 00                	mov    (%eax),%eax
  802c35:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c38:	8b 52 04             	mov    0x4(%edx),%edx
  802c3b:	89 50 04             	mov    %edx,0x4(%eax)
  802c3e:	eb 0b                	jmp    802c4b <alloc_block_BF+0x79>
  802c40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c43:	8b 40 04             	mov    0x4(%eax),%eax
  802c46:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4e:	8b 40 04             	mov    0x4(%eax),%eax
  802c51:	85 c0                	test   %eax,%eax
  802c53:	74 0f                	je     802c64 <alloc_block_BF+0x92>
  802c55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c58:	8b 40 04             	mov    0x4(%eax),%eax
  802c5b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c5e:	8b 12                	mov    (%edx),%edx
  802c60:	89 10                	mov    %edx,(%eax)
  802c62:	eb 0a                	jmp    802c6e <alloc_block_BF+0x9c>
  802c64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c67:	8b 00                	mov    (%eax),%eax
  802c69:	a3 38 51 80 00       	mov    %eax,0x805138
  802c6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c71:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c81:	a1 44 51 80 00       	mov    0x805144,%eax
  802c86:	48                   	dec    %eax
  802c87:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802c8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8f:	e9 4d 01 00 00       	jmp    802de1 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802c94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c97:	8b 40 0c             	mov    0xc(%eax),%eax
  802c9a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c9d:	76 24                	jbe    802cc3 <alloc_block_BF+0xf1>
  802c9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca2:	8b 40 0c             	mov    0xc(%eax),%eax
  802ca5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802ca8:	73 19                	jae    802cc3 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802caa:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802cb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb4:	8b 40 0c             	mov    0xc(%eax),%eax
  802cb7:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802cba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbd:	8b 40 08             	mov    0x8(%eax),%eax
  802cc0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802cc3:	a1 40 51 80 00       	mov    0x805140,%eax
  802cc8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ccb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ccf:	74 07                	je     802cd8 <alloc_block_BF+0x106>
  802cd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd4:	8b 00                	mov    (%eax),%eax
  802cd6:	eb 05                	jmp    802cdd <alloc_block_BF+0x10b>
  802cd8:	b8 00 00 00 00       	mov    $0x0,%eax
  802cdd:	a3 40 51 80 00       	mov    %eax,0x805140
  802ce2:	a1 40 51 80 00       	mov    0x805140,%eax
  802ce7:	85 c0                	test   %eax,%eax
  802ce9:	0f 85 fd fe ff ff    	jne    802bec <alloc_block_BF+0x1a>
  802cef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cf3:	0f 85 f3 fe ff ff    	jne    802bec <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802cf9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802cfd:	0f 84 d9 00 00 00    	je     802ddc <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802d03:	a1 48 51 80 00       	mov    0x805148,%eax
  802d08:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802d0b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d0e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d11:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802d14:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d17:	8b 55 08             	mov    0x8(%ebp),%edx
  802d1a:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802d1d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802d21:	75 17                	jne    802d3a <alloc_block_BF+0x168>
  802d23:	83 ec 04             	sub    $0x4,%esp
  802d26:	68 58 47 80 00       	push   $0x804758
  802d2b:	68 c7 00 00 00       	push   $0xc7
  802d30:	68 af 46 80 00       	push   $0x8046af
  802d35:	e8 57 da ff ff       	call   800791 <_panic>
  802d3a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d3d:	8b 00                	mov    (%eax),%eax
  802d3f:	85 c0                	test   %eax,%eax
  802d41:	74 10                	je     802d53 <alloc_block_BF+0x181>
  802d43:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d46:	8b 00                	mov    (%eax),%eax
  802d48:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d4b:	8b 52 04             	mov    0x4(%edx),%edx
  802d4e:	89 50 04             	mov    %edx,0x4(%eax)
  802d51:	eb 0b                	jmp    802d5e <alloc_block_BF+0x18c>
  802d53:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d56:	8b 40 04             	mov    0x4(%eax),%eax
  802d59:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d5e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d61:	8b 40 04             	mov    0x4(%eax),%eax
  802d64:	85 c0                	test   %eax,%eax
  802d66:	74 0f                	je     802d77 <alloc_block_BF+0x1a5>
  802d68:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d6b:	8b 40 04             	mov    0x4(%eax),%eax
  802d6e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d71:	8b 12                	mov    (%edx),%edx
  802d73:	89 10                	mov    %edx,(%eax)
  802d75:	eb 0a                	jmp    802d81 <alloc_block_BF+0x1af>
  802d77:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d7a:	8b 00                	mov    (%eax),%eax
  802d7c:	a3 48 51 80 00       	mov    %eax,0x805148
  802d81:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d84:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d8a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d8d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d94:	a1 54 51 80 00       	mov    0x805154,%eax
  802d99:	48                   	dec    %eax
  802d9a:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802d9f:	83 ec 08             	sub    $0x8,%esp
  802da2:	ff 75 ec             	pushl  -0x14(%ebp)
  802da5:	68 38 51 80 00       	push   $0x805138
  802daa:	e8 71 f9 ff ff       	call   802720 <find_block>
  802daf:	83 c4 10             	add    $0x10,%esp
  802db2:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802db5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802db8:	8b 50 08             	mov    0x8(%eax),%edx
  802dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbe:	01 c2                	add    %eax,%edx
  802dc0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802dc3:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802dc6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802dc9:	8b 40 0c             	mov    0xc(%eax),%eax
  802dcc:	2b 45 08             	sub    0x8(%ebp),%eax
  802dcf:	89 c2                	mov    %eax,%edx
  802dd1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802dd4:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802dd7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dda:	eb 05                	jmp    802de1 <alloc_block_BF+0x20f>
	}
	return NULL;
  802ddc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802de1:	c9                   	leave  
  802de2:	c3                   	ret    

00802de3 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802de3:	55                   	push   %ebp
  802de4:	89 e5                	mov    %esp,%ebp
  802de6:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802de9:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802dee:	85 c0                	test   %eax,%eax
  802df0:	0f 85 de 01 00 00    	jne    802fd4 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802df6:	a1 38 51 80 00       	mov    0x805138,%eax
  802dfb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802dfe:	e9 9e 01 00 00       	jmp    802fa1 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802e03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e06:	8b 40 0c             	mov    0xc(%eax),%eax
  802e09:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e0c:	0f 82 87 01 00 00    	jb     802f99 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802e12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e15:	8b 40 0c             	mov    0xc(%eax),%eax
  802e18:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e1b:	0f 85 95 00 00 00    	jne    802eb6 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802e21:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e25:	75 17                	jne    802e3e <alloc_block_NF+0x5b>
  802e27:	83 ec 04             	sub    $0x4,%esp
  802e2a:	68 58 47 80 00       	push   $0x804758
  802e2f:	68 e0 00 00 00       	push   $0xe0
  802e34:	68 af 46 80 00       	push   $0x8046af
  802e39:	e8 53 d9 ff ff       	call   800791 <_panic>
  802e3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e41:	8b 00                	mov    (%eax),%eax
  802e43:	85 c0                	test   %eax,%eax
  802e45:	74 10                	je     802e57 <alloc_block_NF+0x74>
  802e47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4a:	8b 00                	mov    (%eax),%eax
  802e4c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e4f:	8b 52 04             	mov    0x4(%edx),%edx
  802e52:	89 50 04             	mov    %edx,0x4(%eax)
  802e55:	eb 0b                	jmp    802e62 <alloc_block_NF+0x7f>
  802e57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5a:	8b 40 04             	mov    0x4(%eax),%eax
  802e5d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e65:	8b 40 04             	mov    0x4(%eax),%eax
  802e68:	85 c0                	test   %eax,%eax
  802e6a:	74 0f                	je     802e7b <alloc_block_NF+0x98>
  802e6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6f:	8b 40 04             	mov    0x4(%eax),%eax
  802e72:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e75:	8b 12                	mov    (%edx),%edx
  802e77:	89 10                	mov    %edx,(%eax)
  802e79:	eb 0a                	jmp    802e85 <alloc_block_NF+0xa2>
  802e7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7e:	8b 00                	mov    (%eax),%eax
  802e80:	a3 38 51 80 00       	mov    %eax,0x805138
  802e85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e88:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e91:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e98:	a1 44 51 80 00       	mov    0x805144,%eax
  802e9d:	48                   	dec    %eax
  802e9e:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802ea3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea6:	8b 40 08             	mov    0x8(%eax),%eax
  802ea9:	a3 2c 50 80 00       	mov    %eax,0x80502c
				   return  point;
  802eae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb1:	e9 f8 04 00 00       	jmp    8033ae <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802eb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb9:	8b 40 0c             	mov    0xc(%eax),%eax
  802ebc:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ebf:	0f 86 d4 00 00 00    	jbe    802f99 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802ec5:	a1 48 51 80 00       	mov    0x805148,%eax
  802eca:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802ecd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed0:	8b 50 08             	mov    0x8(%eax),%edx
  802ed3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ed6:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802ed9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802edc:	8b 55 08             	mov    0x8(%ebp),%edx
  802edf:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802ee2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ee6:	75 17                	jne    802eff <alloc_block_NF+0x11c>
  802ee8:	83 ec 04             	sub    $0x4,%esp
  802eeb:	68 58 47 80 00       	push   $0x804758
  802ef0:	68 e9 00 00 00       	push   $0xe9
  802ef5:	68 af 46 80 00       	push   $0x8046af
  802efa:	e8 92 d8 ff ff       	call   800791 <_panic>
  802eff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f02:	8b 00                	mov    (%eax),%eax
  802f04:	85 c0                	test   %eax,%eax
  802f06:	74 10                	je     802f18 <alloc_block_NF+0x135>
  802f08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f0b:	8b 00                	mov    (%eax),%eax
  802f0d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f10:	8b 52 04             	mov    0x4(%edx),%edx
  802f13:	89 50 04             	mov    %edx,0x4(%eax)
  802f16:	eb 0b                	jmp    802f23 <alloc_block_NF+0x140>
  802f18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f1b:	8b 40 04             	mov    0x4(%eax),%eax
  802f1e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f26:	8b 40 04             	mov    0x4(%eax),%eax
  802f29:	85 c0                	test   %eax,%eax
  802f2b:	74 0f                	je     802f3c <alloc_block_NF+0x159>
  802f2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f30:	8b 40 04             	mov    0x4(%eax),%eax
  802f33:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f36:	8b 12                	mov    (%edx),%edx
  802f38:	89 10                	mov    %edx,(%eax)
  802f3a:	eb 0a                	jmp    802f46 <alloc_block_NF+0x163>
  802f3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f3f:	8b 00                	mov    (%eax),%eax
  802f41:	a3 48 51 80 00       	mov    %eax,0x805148
  802f46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f49:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f52:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f59:	a1 54 51 80 00       	mov    0x805154,%eax
  802f5e:	48                   	dec    %eax
  802f5f:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802f64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f67:	8b 40 08             	mov    0x8(%eax),%eax
  802f6a:	a3 2c 50 80 00       	mov    %eax,0x80502c
				   point->sva += size;
  802f6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f72:	8b 50 08             	mov    0x8(%eax),%edx
  802f75:	8b 45 08             	mov    0x8(%ebp),%eax
  802f78:	01 c2                	add    %eax,%edx
  802f7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7d:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802f80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f83:	8b 40 0c             	mov    0xc(%eax),%eax
  802f86:	2b 45 08             	sub    0x8(%ebp),%eax
  802f89:	89 c2                	mov    %eax,%edx
  802f8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8e:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802f91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f94:	e9 15 04 00 00       	jmp    8033ae <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802f99:	a1 40 51 80 00       	mov    0x805140,%eax
  802f9e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fa1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fa5:	74 07                	je     802fae <alloc_block_NF+0x1cb>
  802fa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802faa:	8b 00                	mov    (%eax),%eax
  802fac:	eb 05                	jmp    802fb3 <alloc_block_NF+0x1d0>
  802fae:	b8 00 00 00 00       	mov    $0x0,%eax
  802fb3:	a3 40 51 80 00       	mov    %eax,0x805140
  802fb8:	a1 40 51 80 00       	mov    0x805140,%eax
  802fbd:	85 c0                	test   %eax,%eax
  802fbf:	0f 85 3e fe ff ff    	jne    802e03 <alloc_block_NF+0x20>
  802fc5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fc9:	0f 85 34 fe ff ff    	jne    802e03 <alloc_block_NF+0x20>
  802fcf:	e9 d5 03 00 00       	jmp    8033a9 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802fd4:	a1 38 51 80 00       	mov    0x805138,%eax
  802fd9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fdc:	e9 b1 01 00 00       	jmp    803192 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802fe1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe4:	8b 50 08             	mov    0x8(%eax),%edx
  802fe7:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802fec:	39 c2                	cmp    %eax,%edx
  802fee:	0f 82 96 01 00 00    	jb     80318a <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802ff4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff7:	8b 40 0c             	mov    0xc(%eax),%eax
  802ffa:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ffd:	0f 82 87 01 00 00    	jb     80318a <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  803003:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803006:	8b 40 0c             	mov    0xc(%eax),%eax
  803009:	3b 45 08             	cmp    0x8(%ebp),%eax
  80300c:	0f 85 95 00 00 00    	jne    8030a7 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  803012:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803016:	75 17                	jne    80302f <alloc_block_NF+0x24c>
  803018:	83 ec 04             	sub    $0x4,%esp
  80301b:	68 58 47 80 00       	push   $0x804758
  803020:	68 fc 00 00 00       	push   $0xfc
  803025:	68 af 46 80 00       	push   $0x8046af
  80302a:	e8 62 d7 ff ff       	call   800791 <_panic>
  80302f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803032:	8b 00                	mov    (%eax),%eax
  803034:	85 c0                	test   %eax,%eax
  803036:	74 10                	je     803048 <alloc_block_NF+0x265>
  803038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80303b:	8b 00                	mov    (%eax),%eax
  80303d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803040:	8b 52 04             	mov    0x4(%edx),%edx
  803043:	89 50 04             	mov    %edx,0x4(%eax)
  803046:	eb 0b                	jmp    803053 <alloc_block_NF+0x270>
  803048:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80304b:	8b 40 04             	mov    0x4(%eax),%eax
  80304e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803053:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803056:	8b 40 04             	mov    0x4(%eax),%eax
  803059:	85 c0                	test   %eax,%eax
  80305b:	74 0f                	je     80306c <alloc_block_NF+0x289>
  80305d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803060:	8b 40 04             	mov    0x4(%eax),%eax
  803063:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803066:	8b 12                	mov    (%edx),%edx
  803068:	89 10                	mov    %edx,(%eax)
  80306a:	eb 0a                	jmp    803076 <alloc_block_NF+0x293>
  80306c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80306f:	8b 00                	mov    (%eax),%eax
  803071:	a3 38 51 80 00       	mov    %eax,0x805138
  803076:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803079:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80307f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803082:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803089:	a1 44 51 80 00       	mov    0x805144,%eax
  80308e:	48                   	dec    %eax
  80308f:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  803094:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803097:	8b 40 08             	mov    0x8(%eax),%eax
  80309a:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   return  point;
  80309f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a2:	e9 07 03 00 00       	jmp    8033ae <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8030a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030aa:	8b 40 0c             	mov    0xc(%eax),%eax
  8030ad:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030b0:	0f 86 d4 00 00 00    	jbe    80318a <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8030b6:	a1 48 51 80 00       	mov    0x805148,%eax
  8030bb:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  8030be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c1:	8b 50 08             	mov    0x8(%eax),%edx
  8030c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030c7:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8030ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8030d0:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8030d3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030d7:	75 17                	jne    8030f0 <alloc_block_NF+0x30d>
  8030d9:	83 ec 04             	sub    $0x4,%esp
  8030dc:	68 58 47 80 00       	push   $0x804758
  8030e1:	68 04 01 00 00       	push   $0x104
  8030e6:	68 af 46 80 00       	push   $0x8046af
  8030eb:	e8 a1 d6 ff ff       	call   800791 <_panic>
  8030f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030f3:	8b 00                	mov    (%eax),%eax
  8030f5:	85 c0                	test   %eax,%eax
  8030f7:	74 10                	je     803109 <alloc_block_NF+0x326>
  8030f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030fc:	8b 00                	mov    (%eax),%eax
  8030fe:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803101:	8b 52 04             	mov    0x4(%edx),%edx
  803104:	89 50 04             	mov    %edx,0x4(%eax)
  803107:	eb 0b                	jmp    803114 <alloc_block_NF+0x331>
  803109:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80310c:	8b 40 04             	mov    0x4(%eax),%eax
  80310f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803114:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803117:	8b 40 04             	mov    0x4(%eax),%eax
  80311a:	85 c0                	test   %eax,%eax
  80311c:	74 0f                	je     80312d <alloc_block_NF+0x34a>
  80311e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803121:	8b 40 04             	mov    0x4(%eax),%eax
  803124:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803127:	8b 12                	mov    (%edx),%edx
  803129:	89 10                	mov    %edx,(%eax)
  80312b:	eb 0a                	jmp    803137 <alloc_block_NF+0x354>
  80312d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803130:	8b 00                	mov    (%eax),%eax
  803132:	a3 48 51 80 00       	mov    %eax,0x805148
  803137:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80313a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803140:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803143:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80314a:	a1 54 51 80 00       	mov    0x805154,%eax
  80314f:	48                   	dec    %eax
  803150:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  803155:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803158:	8b 40 08             	mov    0x8(%eax),%eax
  80315b:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   point->sva += size;
  803160:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803163:	8b 50 08             	mov    0x8(%eax),%edx
  803166:	8b 45 08             	mov    0x8(%ebp),%eax
  803169:	01 c2                	add    %eax,%edx
  80316b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80316e:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803171:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803174:	8b 40 0c             	mov    0xc(%eax),%eax
  803177:	2b 45 08             	sub    0x8(%ebp),%eax
  80317a:	89 c2                	mov    %eax,%edx
  80317c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80317f:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803182:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803185:	e9 24 02 00 00       	jmp    8033ae <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  80318a:	a1 40 51 80 00       	mov    0x805140,%eax
  80318f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803192:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803196:	74 07                	je     80319f <alloc_block_NF+0x3bc>
  803198:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80319b:	8b 00                	mov    (%eax),%eax
  80319d:	eb 05                	jmp    8031a4 <alloc_block_NF+0x3c1>
  80319f:	b8 00 00 00 00       	mov    $0x0,%eax
  8031a4:	a3 40 51 80 00       	mov    %eax,0x805140
  8031a9:	a1 40 51 80 00       	mov    0x805140,%eax
  8031ae:	85 c0                	test   %eax,%eax
  8031b0:	0f 85 2b fe ff ff    	jne    802fe1 <alloc_block_NF+0x1fe>
  8031b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031ba:	0f 85 21 fe ff ff    	jne    802fe1 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8031c0:	a1 38 51 80 00       	mov    0x805138,%eax
  8031c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031c8:	e9 ae 01 00 00       	jmp    80337b <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  8031cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d0:	8b 50 08             	mov    0x8(%eax),%edx
  8031d3:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8031d8:	39 c2                	cmp    %eax,%edx
  8031da:	0f 83 93 01 00 00    	jae    803373 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  8031e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e3:	8b 40 0c             	mov    0xc(%eax),%eax
  8031e6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031e9:	0f 82 84 01 00 00    	jb     803373 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  8031ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f2:	8b 40 0c             	mov    0xc(%eax),%eax
  8031f5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031f8:	0f 85 95 00 00 00    	jne    803293 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8031fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803202:	75 17                	jne    80321b <alloc_block_NF+0x438>
  803204:	83 ec 04             	sub    $0x4,%esp
  803207:	68 58 47 80 00       	push   $0x804758
  80320c:	68 14 01 00 00       	push   $0x114
  803211:	68 af 46 80 00       	push   $0x8046af
  803216:	e8 76 d5 ff ff       	call   800791 <_panic>
  80321b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80321e:	8b 00                	mov    (%eax),%eax
  803220:	85 c0                	test   %eax,%eax
  803222:	74 10                	je     803234 <alloc_block_NF+0x451>
  803224:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803227:	8b 00                	mov    (%eax),%eax
  803229:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80322c:	8b 52 04             	mov    0x4(%edx),%edx
  80322f:	89 50 04             	mov    %edx,0x4(%eax)
  803232:	eb 0b                	jmp    80323f <alloc_block_NF+0x45c>
  803234:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803237:	8b 40 04             	mov    0x4(%eax),%eax
  80323a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80323f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803242:	8b 40 04             	mov    0x4(%eax),%eax
  803245:	85 c0                	test   %eax,%eax
  803247:	74 0f                	je     803258 <alloc_block_NF+0x475>
  803249:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80324c:	8b 40 04             	mov    0x4(%eax),%eax
  80324f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803252:	8b 12                	mov    (%edx),%edx
  803254:	89 10                	mov    %edx,(%eax)
  803256:	eb 0a                	jmp    803262 <alloc_block_NF+0x47f>
  803258:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80325b:	8b 00                	mov    (%eax),%eax
  80325d:	a3 38 51 80 00       	mov    %eax,0x805138
  803262:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803265:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80326b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80326e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803275:	a1 44 51 80 00       	mov    0x805144,%eax
  80327a:	48                   	dec    %eax
  80327b:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  803280:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803283:	8b 40 08             	mov    0x8(%eax),%eax
  803286:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   return  point;
  80328b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80328e:	e9 1b 01 00 00       	jmp    8033ae <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  803293:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803296:	8b 40 0c             	mov    0xc(%eax),%eax
  803299:	3b 45 08             	cmp    0x8(%ebp),%eax
  80329c:	0f 86 d1 00 00 00    	jbe    803373 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8032a2:	a1 48 51 80 00       	mov    0x805148,%eax
  8032a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  8032aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ad:	8b 50 08             	mov    0x8(%eax),%edx
  8032b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032b3:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8032b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8032bc:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8032bf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8032c3:	75 17                	jne    8032dc <alloc_block_NF+0x4f9>
  8032c5:	83 ec 04             	sub    $0x4,%esp
  8032c8:	68 58 47 80 00       	push   $0x804758
  8032cd:	68 1c 01 00 00       	push   $0x11c
  8032d2:	68 af 46 80 00       	push   $0x8046af
  8032d7:	e8 b5 d4 ff ff       	call   800791 <_panic>
  8032dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032df:	8b 00                	mov    (%eax),%eax
  8032e1:	85 c0                	test   %eax,%eax
  8032e3:	74 10                	je     8032f5 <alloc_block_NF+0x512>
  8032e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032e8:	8b 00                	mov    (%eax),%eax
  8032ea:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8032ed:	8b 52 04             	mov    0x4(%edx),%edx
  8032f0:	89 50 04             	mov    %edx,0x4(%eax)
  8032f3:	eb 0b                	jmp    803300 <alloc_block_NF+0x51d>
  8032f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032f8:	8b 40 04             	mov    0x4(%eax),%eax
  8032fb:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803300:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803303:	8b 40 04             	mov    0x4(%eax),%eax
  803306:	85 c0                	test   %eax,%eax
  803308:	74 0f                	je     803319 <alloc_block_NF+0x536>
  80330a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80330d:	8b 40 04             	mov    0x4(%eax),%eax
  803310:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803313:	8b 12                	mov    (%edx),%edx
  803315:	89 10                	mov    %edx,(%eax)
  803317:	eb 0a                	jmp    803323 <alloc_block_NF+0x540>
  803319:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80331c:	8b 00                	mov    (%eax),%eax
  80331e:	a3 48 51 80 00       	mov    %eax,0x805148
  803323:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803326:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80332c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80332f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803336:	a1 54 51 80 00       	mov    0x805154,%eax
  80333b:	48                   	dec    %eax
  80333c:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  803341:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803344:	8b 40 08             	mov    0x8(%eax),%eax
  803347:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   point->sva += size;
  80334c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80334f:	8b 50 08             	mov    0x8(%eax),%edx
  803352:	8b 45 08             	mov    0x8(%ebp),%eax
  803355:	01 c2                	add    %eax,%edx
  803357:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80335a:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  80335d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803360:	8b 40 0c             	mov    0xc(%eax),%eax
  803363:	2b 45 08             	sub    0x8(%ebp),%eax
  803366:	89 c2                	mov    %eax,%edx
  803368:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80336b:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  80336e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803371:	eb 3b                	jmp    8033ae <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803373:	a1 40 51 80 00       	mov    0x805140,%eax
  803378:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80337b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80337f:	74 07                	je     803388 <alloc_block_NF+0x5a5>
  803381:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803384:	8b 00                	mov    (%eax),%eax
  803386:	eb 05                	jmp    80338d <alloc_block_NF+0x5aa>
  803388:	b8 00 00 00 00       	mov    $0x0,%eax
  80338d:	a3 40 51 80 00       	mov    %eax,0x805140
  803392:	a1 40 51 80 00       	mov    0x805140,%eax
  803397:	85 c0                	test   %eax,%eax
  803399:	0f 85 2e fe ff ff    	jne    8031cd <alloc_block_NF+0x3ea>
  80339f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033a3:	0f 85 24 fe ff ff    	jne    8031cd <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  8033a9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8033ae:	c9                   	leave  
  8033af:	c3                   	ret    

008033b0 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8033b0:	55                   	push   %ebp
  8033b1:	89 e5                	mov    %esp,%ebp
  8033b3:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  8033b6:	a1 38 51 80 00       	mov    0x805138,%eax
  8033bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  8033be:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8033c3:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  8033c6:	a1 38 51 80 00       	mov    0x805138,%eax
  8033cb:	85 c0                	test   %eax,%eax
  8033cd:	74 14                	je     8033e3 <insert_sorted_with_merge_freeList+0x33>
  8033cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d2:	8b 50 08             	mov    0x8(%eax),%edx
  8033d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033d8:	8b 40 08             	mov    0x8(%eax),%eax
  8033db:	39 c2                	cmp    %eax,%edx
  8033dd:	0f 87 9b 01 00 00    	ja     80357e <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  8033e3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033e7:	75 17                	jne    803400 <insert_sorted_with_merge_freeList+0x50>
  8033e9:	83 ec 04             	sub    $0x4,%esp
  8033ec:	68 8c 46 80 00       	push   $0x80468c
  8033f1:	68 38 01 00 00       	push   $0x138
  8033f6:	68 af 46 80 00       	push   $0x8046af
  8033fb:	e8 91 d3 ff ff       	call   800791 <_panic>
  803400:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803406:	8b 45 08             	mov    0x8(%ebp),%eax
  803409:	89 10                	mov    %edx,(%eax)
  80340b:	8b 45 08             	mov    0x8(%ebp),%eax
  80340e:	8b 00                	mov    (%eax),%eax
  803410:	85 c0                	test   %eax,%eax
  803412:	74 0d                	je     803421 <insert_sorted_with_merge_freeList+0x71>
  803414:	a1 38 51 80 00       	mov    0x805138,%eax
  803419:	8b 55 08             	mov    0x8(%ebp),%edx
  80341c:	89 50 04             	mov    %edx,0x4(%eax)
  80341f:	eb 08                	jmp    803429 <insert_sorted_with_merge_freeList+0x79>
  803421:	8b 45 08             	mov    0x8(%ebp),%eax
  803424:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803429:	8b 45 08             	mov    0x8(%ebp),%eax
  80342c:	a3 38 51 80 00       	mov    %eax,0x805138
  803431:	8b 45 08             	mov    0x8(%ebp),%eax
  803434:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80343b:	a1 44 51 80 00       	mov    0x805144,%eax
  803440:	40                   	inc    %eax
  803441:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803446:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80344a:	0f 84 a8 06 00 00    	je     803af8 <insert_sorted_with_merge_freeList+0x748>
  803450:	8b 45 08             	mov    0x8(%ebp),%eax
  803453:	8b 50 08             	mov    0x8(%eax),%edx
  803456:	8b 45 08             	mov    0x8(%ebp),%eax
  803459:	8b 40 0c             	mov    0xc(%eax),%eax
  80345c:	01 c2                	add    %eax,%edx
  80345e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803461:	8b 40 08             	mov    0x8(%eax),%eax
  803464:	39 c2                	cmp    %eax,%edx
  803466:	0f 85 8c 06 00 00    	jne    803af8 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  80346c:	8b 45 08             	mov    0x8(%ebp),%eax
  80346f:	8b 50 0c             	mov    0xc(%eax),%edx
  803472:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803475:	8b 40 0c             	mov    0xc(%eax),%eax
  803478:	01 c2                	add    %eax,%edx
  80347a:	8b 45 08             	mov    0x8(%ebp),%eax
  80347d:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  803480:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803484:	75 17                	jne    80349d <insert_sorted_with_merge_freeList+0xed>
  803486:	83 ec 04             	sub    $0x4,%esp
  803489:	68 58 47 80 00       	push   $0x804758
  80348e:	68 3c 01 00 00       	push   $0x13c
  803493:	68 af 46 80 00       	push   $0x8046af
  803498:	e8 f4 d2 ff ff       	call   800791 <_panic>
  80349d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034a0:	8b 00                	mov    (%eax),%eax
  8034a2:	85 c0                	test   %eax,%eax
  8034a4:	74 10                	je     8034b6 <insert_sorted_with_merge_freeList+0x106>
  8034a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034a9:	8b 00                	mov    (%eax),%eax
  8034ab:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034ae:	8b 52 04             	mov    0x4(%edx),%edx
  8034b1:	89 50 04             	mov    %edx,0x4(%eax)
  8034b4:	eb 0b                	jmp    8034c1 <insert_sorted_with_merge_freeList+0x111>
  8034b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034b9:	8b 40 04             	mov    0x4(%eax),%eax
  8034bc:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8034c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034c4:	8b 40 04             	mov    0x4(%eax),%eax
  8034c7:	85 c0                	test   %eax,%eax
  8034c9:	74 0f                	je     8034da <insert_sorted_with_merge_freeList+0x12a>
  8034cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034ce:	8b 40 04             	mov    0x4(%eax),%eax
  8034d1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034d4:	8b 12                	mov    (%edx),%edx
  8034d6:	89 10                	mov    %edx,(%eax)
  8034d8:	eb 0a                	jmp    8034e4 <insert_sorted_with_merge_freeList+0x134>
  8034da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034dd:	8b 00                	mov    (%eax),%eax
  8034df:	a3 38 51 80 00       	mov    %eax,0x805138
  8034e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034f0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034f7:	a1 44 51 80 00       	mov    0x805144,%eax
  8034fc:	48                   	dec    %eax
  8034fd:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  803502:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803505:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  80350c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80350f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  803516:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80351a:	75 17                	jne    803533 <insert_sorted_with_merge_freeList+0x183>
  80351c:	83 ec 04             	sub    $0x4,%esp
  80351f:	68 8c 46 80 00       	push   $0x80468c
  803524:	68 3f 01 00 00       	push   $0x13f
  803529:	68 af 46 80 00       	push   $0x8046af
  80352e:	e8 5e d2 ff ff       	call   800791 <_panic>
  803533:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803539:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80353c:	89 10                	mov    %edx,(%eax)
  80353e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803541:	8b 00                	mov    (%eax),%eax
  803543:	85 c0                	test   %eax,%eax
  803545:	74 0d                	je     803554 <insert_sorted_with_merge_freeList+0x1a4>
  803547:	a1 48 51 80 00       	mov    0x805148,%eax
  80354c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80354f:	89 50 04             	mov    %edx,0x4(%eax)
  803552:	eb 08                	jmp    80355c <insert_sorted_with_merge_freeList+0x1ac>
  803554:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803557:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80355c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80355f:	a3 48 51 80 00       	mov    %eax,0x805148
  803564:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803567:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80356e:	a1 54 51 80 00       	mov    0x805154,%eax
  803573:	40                   	inc    %eax
  803574:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803579:	e9 7a 05 00 00       	jmp    803af8 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  80357e:	8b 45 08             	mov    0x8(%ebp),%eax
  803581:	8b 50 08             	mov    0x8(%eax),%edx
  803584:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803587:	8b 40 08             	mov    0x8(%eax),%eax
  80358a:	39 c2                	cmp    %eax,%edx
  80358c:	0f 82 14 01 00 00    	jb     8036a6 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  803592:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803595:	8b 50 08             	mov    0x8(%eax),%edx
  803598:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80359b:	8b 40 0c             	mov    0xc(%eax),%eax
  80359e:	01 c2                	add    %eax,%edx
  8035a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a3:	8b 40 08             	mov    0x8(%eax),%eax
  8035a6:	39 c2                	cmp    %eax,%edx
  8035a8:	0f 85 90 00 00 00    	jne    80363e <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  8035ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035b1:	8b 50 0c             	mov    0xc(%eax),%edx
  8035b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b7:	8b 40 0c             	mov    0xc(%eax),%eax
  8035ba:	01 c2                	add    %eax,%edx
  8035bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035bf:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  8035c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  8035cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8035cf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8035d6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035da:	75 17                	jne    8035f3 <insert_sorted_with_merge_freeList+0x243>
  8035dc:	83 ec 04             	sub    $0x4,%esp
  8035df:	68 8c 46 80 00       	push   $0x80468c
  8035e4:	68 49 01 00 00       	push   $0x149
  8035e9:	68 af 46 80 00       	push   $0x8046af
  8035ee:	e8 9e d1 ff ff       	call   800791 <_panic>
  8035f3:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8035f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8035fc:	89 10                	mov    %edx,(%eax)
  8035fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803601:	8b 00                	mov    (%eax),%eax
  803603:	85 c0                	test   %eax,%eax
  803605:	74 0d                	je     803614 <insert_sorted_with_merge_freeList+0x264>
  803607:	a1 48 51 80 00       	mov    0x805148,%eax
  80360c:	8b 55 08             	mov    0x8(%ebp),%edx
  80360f:	89 50 04             	mov    %edx,0x4(%eax)
  803612:	eb 08                	jmp    80361c <insert_sorted_with_merge_freeList+0x26c>
  803614:	8b 45 08             	mov    0x8(%ebp),%eax
  803617:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80361c:	8b 45 08             	mov    0x8(%ebp),%eax
  80361f:	a3 48 51 80 00       	mov    %eax,0x805148
  803624:	8b 45 08             	mov    0x8(%ebp),%eax
  803627:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80362e:	a1 54 51 80 00       	mov    0x805154,%eax
  803633:	40                   	inc    %eax
  803634:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803639:	e9 bb 04 00 00       	jmp    803af9 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  80363e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803642:	75 17                	jne    80365b <insert_sorted_with_merge_freeList+0x2ab>
  803644:	83 ec 04             	sub    $0x4,%esp
  803647:	68 00 47 80 00       	push   $0x804700
  80364c:	68 4c 01 00 00       	push   $0x14c
  803651:	68 af 46 80 00       	push   $0x8046af
  803656:	e8 36 d1 ff ff       	call   800791 <_panic>
  80365b:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803661:	8b 45 08             	mov    0x8(%ebp),%eax
  803664:	89 50 04             	mov    %edx,0x4(%eax)
  803667:	8b 45 08             	mov    0x8(%ebp),%eax
  80366a:	8b 40 04             	mov    0x4(%eax),%eax
  80366d:	85 c0                	test   %eax,%eax
  80366f:	74 0c                	je     80367d <insert_sorted_with_merge_freeList+0x2cd>
  803671:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803676:	8b 55 08             	mov    0x8(%ebp),%edx
  803679:	89 10                	mov    %edx,(%eax)
  80367b:	eb 08                	jmp    803685 <insert_sorted_with_merge_freeList+0x2d5>
  80367d:	8b 45 08             	mov    0x8(%ebp),%eax
  803680:	a3 38 51 80 00       	mov    %eax,0x805138
  803685:	8b 45 08             	mov    0x8(%ebp),%eax
  803688:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80368d:	8b 45 08             	mov    0x8(%ebp),%eax
  803690:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803696:	a1 44 51 80 00       	mov    0x805144,%eax
  80369b:	40                   	inc    %eax
  80369c:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8036a1:	e9 53 04 00 00       	jmp    803af9 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8036a6:	a1 38 51 80 00       	mov    0x805138,%eax
  8036ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8036ae:	e9 15 04 00 00       	jmp    803ac8 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  8036b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036b6:	8b 00                	mov    (%eax),%eax
  8036b8:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  8036bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8036be:	8b 50 08             	mov    0x8(%eax),%edx
  8036c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036c4:	8b 40 08             	mov    0x8(%eax),%eax
  8036c7:	39 c2                	cmp    %eax,%edx
  8036c9:	0f 86 f1 03 00 00    	jbe    803ac0 <insert_sorted_with_merge_freeList+0x710>
  8036cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d2:	8b 50 08             	mov    0x8(%eax),%edx
  8036d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036d8:	8b 40 08             	mov    0x8(%eax),%eax
  8036db:	39 c2                	cmp    %eax,%edx
  8036dd:	0f 83 dd 03 00 00    	jae    803ac0 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  8036e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036e6:	8b 50 08             	mov    0x8(%eax),%edx
  8036e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036ec:	8b 40 0c             	mov    0xc(%eax),%eax
  8036ef:	01 c2                	add    %eax,%edx
  8036f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8036f4:	8b 40 08             	mov    0x8(%eax),%eax
  8036f7:	39 c2                	cmp    %eax,%edx
  8036f9:	0f 85 b9 01 00 00    	jne    8038b8 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8036ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803702:	8b 50 08             	mov    0x8(%eax),%edx
  803705:	8b 45 08             	mov    0x8(%ebp),%eax
  803708:	8b 40 0c             	mov    0xc(%eax),%eax
  80370b:	01 c2                	add    %eax,%edx
  80370d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803710:	8b 40 08             	mov    0x8(%eax),%eax
  803713:	39 c2                	cmp    %eax,%edx
  803715:	0f 85 0d 01 00 00    	jne    803828 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  80371b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80371e:	8b 50 0c             	mov    0xc(%eax),%edx
  803721:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803724:	8b 40 0c             	mov    0xc(%eax),%eax
  803727:	01 c2                	add    %eax,%edx
  803729:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80372c:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80372f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803733:	75 17                	jne    80374c <insert_sorted_with_merge_freeList+0x39c>
  803735:	83 ec 04             	sub    $0x4,%esp
  803738:	68 58 47 80 00       	push   $0x804758
  80373d:	68 5c 01 00 00       	push   $0x15c
  803742:	68 af 46 80 00       	push   $0x8046af
  803747:	e8 45 d0 ff ff       	call   800791 <_panic>
  80374c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80374f:	8b 00                	mov    (%eax),%eax
  803751:	85 c0                	test   %eax,%eax
  803753:	74 10                	je     803765 <insert_sorted_with_merge_freeList+0x3b5>
  803755:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803758:	8b 00                	mov    (%eax),%eax
  80375a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80375d:	8b 52 04             	mov    0x4(%edx),%edx
  803760:	89 50 04             	mov    %edx,0x4(%eax)
  803763:	eb 0b                	jmp    803770 <insert_sorted_with_merge_freeList+0x3c0>
  803765:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803768:	8b 40 04             	mov    0x4(%eax),%eax
  80376b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803770:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803773:	8b 40 04             	mov    0x4(%eax),%eax
  803776:	85 c0                	test   %eax,%eax
  803778:	74 0f                	je     803789 <insert_sorted_with_merge_freeList+0x3d9>
  80377a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80377d:	8b 40 04             	mov    0x4(%eax),%eax
  803780:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803783:	8b 12                	mov    (%edx),%edx
  803785:	89 10                	mov    %edx,(%eax)
  803787:	eb 0a                	jmp    803793 <insert_sorted_with_merge_freeList+0x3e3>
  803789:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80378c:	8b 00                	mov    (%eax),%eax
  80378e:	a3 38 51 80 00       	mov    %eax,0x805138
  803793:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803796:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80379c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80379f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037a6:	a1 44 51 80 00       	mov    0x805144,%eax
  8037ab:	48                   	dec    %eax
  8037ac:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  8037b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037b4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8037bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037be:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8037c5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8037c9:	75 17                	jne    8037e2 <insert_sorted_with_merge_freeList+0x432>
  8037cb:	83 ec 04             	sub    $0x4,%esp
  8037ce:	68 8c 46 80 00       	push   $0x80468c
  8037d3:	68 5f 01 00 00       	push   $0x15f
  8037d8:	68 af 46 80 00       	push   $0x8046af
  8037dd:	e8 af cf ff ff       	call   800791 <_panic>
  8037e2:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8037e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037eb:	89 10                	mov    %edx,(%eax)
  8037ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037f0:	8b 00                	mov    (%eax),%eax
  8037f2:	85 c0                	test   %eax,%eax
  8037f4:	74 0d                	je     803803 <insert_sorted_with_merge_freeList+0x453>
  8037f6:	a1 48 51 80 00       	mov    0x805148,%eax
  8037fb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8037fe:	89 50 04             	mov    %edx,0x4(%eax)
  803801:	eb 08                	jmp    80380b <insert_sorted_with_merge_freeList+0x45b>
  803803:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803806:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80380b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80380e:	a3 48 51 80 00       	mov    %eax,0x805148
  803813:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803816:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80381d:	a1 54 51 80 00       	mov    0x805154,%eax
  803822:	40                   	inc    %eax
  803823:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803828:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80382b:	8b 50 0c             	mov    0xc(%eax),%edx
  80382e:	8b 45 08             	mov    0x8(%ebp),%eax
  803831:	8b 40 0c             	mov    0xc(%eax),%eax
  803834:	01 c2                	add    %eax,%edx
  803836:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803839:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  80383c:	8b 45 08             	mov    0x8(%ebp),%eax
  80383f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803846:	8b 45 08             	mov    0x8(%ebp),%eax
  803849:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803850:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803854:	75 17                	jne    80386d <insert_sorted_with_merge_freeList+0x4bd>
  803856:	83 ec 04             	sub    $0x4,%esp
  803859:	68 8c 46 80 00       	push   $0x80468c
  80385e:	68 64 01 00 00       	push   $0x164
  803863:	68 af 46 80 00       	push   $0x8046af
  803868:	e8 24 cf ff ff       	call   800791 <_panic>
  80386d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803873:	8b 45 08             	mov    0x8(%ebp),%eax
  803876:	89 10                	mov    %edx,(%eax)
  803878:	8b 45 08             	mov    0x8(%ebp),%eax
  80387b:	8b 00                	mov    (%eax),%eax
  80387d:	85 c0                	test   %eax,%eax
  80387f:	74 0d                	je     80388e <insert_sorted_with_merge_freeList+0x4de>
  803881:	a1 48 51 80 00       	mov    0x805148,%eax
  803886:	8b 55 08             	mov    0x8(%ebp),%edx
  803889:	89 50 04             	mov    %edx,0x4(%eax)
  80388c:	eb 08                	jmp    803896 <insert_sorted_with_merge_freeList+0x4e6>
  80388e:	8b 45 08             	mov    0x8(%ebp),%eax
  803891:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803896:	8b 45 08             	mov    0x8(%ebp),%eax
  803899:	a3 48 51 80 00       	mov    %eax,0x805148
  80389e:	8b 45 08             	mov    0x8(%ebp),%eax
  8038a1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038a8:	a1 54 51 80 00       	mov    0x805154,%eax
  8038ad:	40                   	inc    %eax
  8038ae:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8038b3:	e9 41 02 00 00       	jmp    803af9 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8038b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8038bb:	8b 50 08             	mov    0x8(%eax),%edx
  8038be:	8b 45 08             	mov    0x8(%ebp),%eax
  8038c1:	8b 40 0c             	mov    0xc(%eax),%eax
  8038c4:	01 c2                	add    %eax,%edx
  8038c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038c9:	8b 40 08             	mov    0x8(%eax),%eax
  8038cc:	39 c2                	cmp    %eax,%edx
  8038ce:	0f 85 7c 01 00 00    	jne    803a50 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8038d4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8038d8:	74 06                	je     8038e0 <insert_sorted_with_merge_freeList+0x530>
  8038da:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8038de:	75 17                	jne    8038f7 <insert_sorted_with_merge_freeList+0x547>
  8038e0:	83 ec 04             	sub    $0x4,%esp
  8038e3:	68 c8 46 80 00       	push   $0x8046c8
  8038e8:	68 69 01 00 00       	push   $0x169
  8038ed:	68 af 46 80 00       	push   $0x8046af
  8038f2:	e8 9a ce ff ff       	call   800791 <_panic>
  8038f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038fa:	8b 50 04             	mov    0x4(%eax),%edx
  8038fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803900:	89 50 04             	mov    %edx,0x4(%eax)
  803903:	8b 45 08             	mov    0x8(%ebp),%eax
  803906:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803909:	89 10                	mov    %edx,(%eax)
  80390b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80390e:	8b 40 04             	mov    0x4(%eax),%eax
  803911:	85 c0                	test   %eax,%eax
  803913:	74 0d                	je     803922 <insert_sorted_with_merge_freeList+0x572>
  803915:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803918:	8b 40 04             	mov    0x4(%eax),%eax
  80391b:	8b 55 08             	mov    0x8(%ebp),%edx
  80391e:	89 10                	mov    %edx,(%eax)
  803920:	eb 08                	jmp    80392a <insert_sorted_with_merge_freeList+0x57a>
  803922:	8b 45 08             	mov    0x8(%ebp),%eax
  803925:	a3 38 51 80 00       	mov    %eax,0x805138
  80392a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80392d:	8b 55 08             	mov    0x8(%ebp),%edx
  803930:	89 50 04             	mov    %edx,0x4(%eax)
  803933:	a1 44 51 80 00       	mov    0x805144,%eax
  803938:	40                   	inc    %eax
  803939:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  80393e:	8b 45 08             	mov    0x8(%ebp),%eax
  803941:	8b 50 0c             	mov    0xc(%eax),%edx
  803944:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803947:	8b 40 0c             	mov    0xc(%eax),%eax
  80394a:	01 c2                	add    %eax,%edx
  80394c:	8b 45 08             	mov    0x8(%ebp),%eax
  80394f:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803952:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803956:	75 17                	jne    80396f <insert_sorted_with_merge_freeList+0x5bf>
  803958:	83 ec 04             	sub    $0x4,%esp
  80395b:	68 58 47 80 00       	push   $0x804758
  803960:	68 6b 01 00 00       	push   $0x16b
  803965:	68 af 46 80 00       	push   $0x8046af
  80396a:	e8 22 ce ff ff       	call   800791 <_panic>
  80396f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803972:	8b 00                	mov    (%eax),%eax
  803974:	85 c0                	test   %eax,%eax
  803976:	74 10                	je     803988 <insert_sorted_with_merge_freeList+0x5d8>
  803978:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80397b:	8b 00                	mov    (%eax),%eax
  80397d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803980:	8b 52 04             	mov    0x4(%edx),%edx
  803983:	89 50 04             	mov    %edx,0x4(%eax)
  803986:	eb 0b                	jmp    803993 <insert_sorted_with_merge_freeList+0x5e3>
  803988:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80398b:	8b 40 04             	mov    0x4(%eax),%eax
  80398e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803993:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803996:	8b 40 04             	mov    0x4(%eax),%eax
  803999:	85 c0                	test   %eax,%eax
  80399b:	74 0f                	je     8039ac <insert_sorted_with_merge_freeList+0x5fc>
  80399d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039a0:	8b 40 04             	mov    0x4(%eax),%eax
  8039a3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8039a6:	8b 12                	mov    (%edx),%edx
  8039a8:	89 10                	mov    %edx,(%eax)
  8039aa:	eb 0a                	jmp    8039b6 <insert_sorted_with_merge_freeList+0x606>
  8039ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039af:	8b 00                	mov    (%eax),%eax
  8039b1:	a3 38 51 80 00       	mov    %eax,0x805138
  8039b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039c2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039c9:	a1 44 51 80 00       	mov    0x805144,%eax
  8039ce:	48                   	dec    %eax
  8039cf:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  8039d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039d7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8039de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039e1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8039e8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8039ec:	75 17                	jne    803a05 <insert_sorted_with_merge_freeList+0x655>
  8039ee:	83 ec 04             	sub    $0x4,%esp
  8039f1:	68 8c 46 80 00       	push   $0x80468c
  8039f6:	68 6e 01 00 00       	push   $0x16e
  8039fb:	68 af 46 80 00       	push   $0x8046af
  803a00:	e8 8c cd ff ff       	call   800791 <_panic>
  803a05:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803a0b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a0e:	89 10                	mov    %edx,(%eax)
  803a10:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a13:	8b 00                	mov    (%eax),%eax
  803a15:	85 c0                	test   %eax,%eax
  803a17:	74 0d                	je     803a26 <insert_sorted_with_merge_freeList+0x676>
  803a19:	a1 48 51 80 00       	mov    0x805148,%eax
  803a1e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803a21:	89 50 04             	mov    %edx,0x4(%eax)
  803a24:	eb 08                	jmp    803a2e <insert_sorted_with_merge_freeList+0x67e>
  803a26:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a29:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803a2e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a31:	a3 48 51 80 00       	mov    %eax,0x805148
  803a36:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a39:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a40:	a1 54 51 80 00       	mov    0x805154,%eax
  803a45:	40                   	inc    %eax
  803a46:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803a4b:	e9 a9 00 00 00       	jmp    803af9 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803a50:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a54:	74 06                	je     803a5c <insert_sorted_with_merge_freeList+0x6ac>
  803a56:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803a5a:	75 17                	jne    803a73 <insert_sorted_with_merge_freeList+0x6c3>
  803a5c:	83 ec 04             	sub    $0x4,%esp
  803a5f:	68 24 47 80 00       	push   $0x804724
  803a64:	68 73 01 00 00       	push   $0x173
  803a69:	68 af 46 80 00       	push   $0x8046af
  803a6e:	e8 1e cd ff ff       	call   800791 <_panic>
  803a73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a76:	8b 10                	mov    (%eax),%edx
  803a78:	8b 45 08             	mov    0x8(%ebp),%eax
  803a7b:	89 10                	mov    %edx,(%eax)
  803a7d:	8b 45 08             	mov    0x8(%ebp),%eax
  803a80:	8b 00                	mov    (%eax),%eax
  803a82:	85 c0                	test   %eax,%eax
  803a84:	74 0b                	je     803a91 <insert_sorted_with_merge_freeList+0x6e1>
  803a86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a89:	8b 00                	mov    (%eax),%eax
  803a8b:	8b 55 08             	mov    0x8(%ebp),%edx
  803a8e:	89 50 04             	mov    %edx,0x4(%eax)
  803a91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a94:	8b 55 08             	mov    0x8(%ebp),%edx
  803a97:	89 10                	mov    %edx,(%eax)
  803a99:	8b 45 08             	mov    0x8(%ebp),%eax
  803a9c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803a9f:	89 50 04             	mov    %edx,0x4(%eax)
  803aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  803aa5:	8b 00                	mov    (%eax),%eax
  803aa7:	85 c0                	test   %eax,%eax
  803aa9:	75 08                	jne    803ab3 <insert_sorted_with_merge_freeList+0x703>
  803aab:	8b 45 08             	mov    0x8(%ebp),%eax
  803aae:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803ab3:	a1 44 51 80 00       	mov    0x805144,%eax
  803ab8:	40                   	inc    %eax
  803ab9:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803abe:	eb 39                	jmp    803af9 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803ac0:	a1 40 51 80 00       	mov    0x805140,%eax
  803ac5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803ac8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803acc:	74 07                	je     803ad5 <insert_sorted_with_merge_freeList+0x725>
  803ace:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ad1:	8b 00                	mov    (%eax),%eax
  803ad3:	eb 05                	jmp    803ada <insert_sorted_with_merge_freeList+0x72a>
  803ad5:	b8 00 00 00 00       	mov    $0x0,%eax
  803ada:	a3 40 51 80 00       	mov    %eax,0x805140
  803adf:	a1 40 51 80 00       	mov    0x805140,%eax
  803ae4:	85 c0                	test   %eax,%eax
  803ae6:	0f 85 c7 fb ff ff    	jne    8036b3 <insert_sorted_with_merge_freeList+0x303>
  803aec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803af0:	0f 85 bd fb ff ff    	jne    8036b3 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803af6:	eb 01                	jmp    803af9 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803af8:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803af9:	90                   	nop
  803afa:	c9                   	leave  
  803afb:	c3                   	ret    

00803afc <__udivdi3>:
  803afc:	55                   	push   %ebp
  803afd:	57                   	push   %edi
  803afe:	56                   	push   %esi
  803aff:	53                   	push   %ebx
  803b00:	83 ec 1c             	sub    $0x1c,%esp
  803b03:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803b07:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803b0b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b0f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803b13:	89 ca                	mov    %ecx,%edx
  803b15:	89 f8                	mov    %edi,%eax
  803b17:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803b1b:	85 f6                	test   %esi,%esi
  803b1d:	75 2d                	jne    803b4c <__udivdi3+0x50>
  803b1f:	39 cf                	cmp    %ecx,%edi
  803b21:	77 65                	ja     803b88 <__udivdi3+0x8c>
  803b23:	89 fd                	mov    %edi,%ebp
  803b25:	85 ff                	test   %edi,%edi
  803b27:	75 0b                	jne    803b34 <__udivdi3+0x38>
  803b29:	b8 01 00 00 00       	mov    $0x1,%eax
  803b2e:	31 d2                	xor    %edx,%edx
  803b30:	f7 f7                	div    %edi
  803b32:	89 c5                	mov    %eax,%ebp
  803b34:	31 d2                	xor    %edx,%edx
  803b36:	89 c8                	mov    %ecx,%eax
  803b38:	f7 f5                	div    %ebp
  803b3a:	89 c1                	mov    %eax,%ecx
  803b3c:	89 d8                	mov    %ebx,%eax
  803b3e:	f7 f5                	div    %ebp
  803b40:	89 cf                	mov    %ecx,%edi
  803b42:	89 fa                	mov    %edi,%edx
  803b44:	83 c4 1c             	add    $0x1c,%esp
  803b47:	5b                   	pop    %ebx
  803b48:	5e                   	pop    %esi
  803b49:	5f                   	pop    %edi
  803b4a:	5d                   	pop    %ebp
  803b4b:	c3                   	ret    
  803b4c:	39 ce                	cmp    %ecx,%esi
  803b4e:	77 28                	ja     803b78 <__udivdi3+0x7c>
  803b50:	0f bd fe             	bsr    %esi,%edi
  803b53:	83 f7 1f             	xor    $0x1f,%edi
  803b56:	75 40                	jne    803b98 <__udivdi3+0x9c>
  803b58:	39 ce                	cmp    %ecx,%esi
  803b5a:	72 0a                	jb     803b66 <__udivdi3+0x6a>
  803b5c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803b60:	0f 87 9e 00 00 00    	ja     803c04 <__udivdi3+0x108>
  803b66:	b8 01 00 00 00       	mov    $0x1,%eax
  803b6b:	89 fa                	mov    %edi,%edx
  803b6d:	83 c4 1c             	add    $0x1c,%esp
  803b70:	5b                   	pop    %ebx
  803b71:	5e                   	pop    %esi
  803b72:	5f                   	pop    %edi
  803b73:	5d                   	pop    %ebp
  803b74:	c3                   	ret    
  803b75:	8d 76 00             	lea    0x0(%esi),%esi
  803b78:	31 ff                	xor    %edi,%edi
  803b7a:	31 c0                	xor    %eax,%eax
  803b7c:	89 fa                	mov    %edi,%edx
  803b7e:	83 c4 1c             	add    $0x1c,%esp
  803b81:	5b                   	pop    %ebx
  803b82:	5e                   	pop    %esi
  803b83:	5f                   	pop    %edi
  803b84:	5d                   	pop    %ebp
  803b85:	c3                   	ret    
  803b86:	66 90                	xchg   %ax,%ax
  803b88:	89 d8                	mov    %ebx,%eax
  803b8a:	f7 f7                	div    %edi
  803b8c:	31 ff                	xor    %edi,%edi
  803b8e:	89 fa                	mov    %edi,%edx
  803b90:	83 c4 1c             	add    $0x1c,%esp
  803b93:	5b                   	pop    %ebx
  803b94:	5e                   	pop    %esi
  803b95:	5f                   	pop    %edi
  803b96:	5d                   	pop    %ebp
  803b97:	c3                   	ret    
  803b98:	bd 20 00 00 00       	mov    $0x20,%ebp
  803b9d:	89 eb                	mov    %ebp,%ebx
  803b9f:	29 fb                	sub    %edi,%ebx
  803ba1:	89 f9                	mov    %edi,%ecx
  803ba3:	d3 e6                	shl    %cl,%esi
  803ba5:	89 c5                	mov    %eax,%ebp
  803ba7:	88 d9                	mov    %bl,%cl
  803ba9:	d3 ed                	shr    %cl,%ebp
  803bab:	89 e9                	mov    %ebp,%ecx
  803bad:	09 f1                	or     %esi,%ecx
  803baf:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803bb3:	89 f9                	mov    %edi,%ecx
  803bb5:	d3 e0                	shl    %cl,%eax
  803bb7:	89 c5                	mov    %eax,%ebp
  803bb9:	89 d6                	mov    %edx,%esi
  803bbb:	88 d9                	mov    %bl,%cl
  803bbd:	d3 ee                	shr    %cl,%esi
  803bbf:	89 f9                	mov    %edi,%ecx
  803bc1:	d3 e2                	shl    %cl,%edx
  803bc3:	8b 44 24 08          	mov    0x8(%esp),%eax
  803bc7:	88 d9                	mov    %bl,%cl
  803bc9:	d3 e8                	shr    %cl,%eax
  803bcb:	09 c2                	or     %eax,%edx
  803bcd:	89 d0                	mov    %edx,%eax
  803bcf:	89 f2                	mov    %esi,%edx
  803bd1:	f7 74 24 0c          	divl   0xc(%esp)
  803bd5:	89 d6                	mov    %edx,%esi
  803bd7:	89 c3                	mov    %eax,%ebx
  803bd9:	f7 e5                	mul    %ebp
  803bdb:	39 d6                	cmp    %edx,%esi
  803bdd:	72 19                	jb     803bf8 <__udivdi3+0xfc>
  803bdf:	74 0b                	je     803bec <__udivdi3+0xf0>
  803be1:	89 d8                	mov    %ebx,%eax
  803be3:	31 ff                	xor    %edi,%edi
  803be5:	e9 58 ff ff ff       	jmp    803b42 <__udivdi3+0x46>
  803bea:	66 90                	xchg   %ax,%ax
  803bec:	8b 54 24 08          	mov    0x8(%esp),%edx
  803bf0:	89 f9                	mov    %edi,%ecx
  803bf2:	d3 e2                	shl    %cl,%edx
  803bf4:	39 c2                	cmp    %eax,%edx
  803bf6:	73 e9                	jae    803be1 <__udivdi3+0xe5>
  803bf8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803bfb:	31 ff                	xor    %edi,%edi
  803bfd:	e9 40 ff ff ff       	jmp    803b42 <__udivdi3+0x46>
  803c02:	66 90                	xchg   %ax,%ax
  803c04:	31 c0                	xor    %eax,%eax
  803c06:	e9 37 ff ff ff       	jmp    803b42 <__udivdi3+0x46>
  803c0b:	90                   	nop

00803c0c <__umoddi3>:
  803c0c:	55                   	push   %ebp
  803c0d:	57                   	push   %edi
  803c0e:	56                   	push   %esi
  803c0f:	53                   	push   %ebx
  803c10:	83 ec 1c             	sub    $0x1c,%esp
  803c13:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803c17:	8b 74 24 34          	mov    0x34(%esp),%esi
  803c1b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803c1f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803c23:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803c27:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803c2b:	89 f3                	mov    %esi,%ebx
  803c2d:	89 fa                	mov    %edi,%edx
  803c2f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c33:	89 34 24             	mov    %esi,(%esp)
  803c36:	85 c0                	test   %eax,%eax
  803c38:	75 1a                	jne    803c54 <__umoddi3+0x48>
  803c3a:	39 f7                	cmp    %esi,%edi
  803c3c:	0f 86 a2 00 00 00    	jbe    803ce4 <__umoddi3+0xd8>
  803c42:	89 c8                	mov    %ecx,%eax
  803c44:	89 f2                	mov    %esi,%edx
  803c46:	f7 f7                	div    %edi
  803c48:	89 d0                	mov    %edx,%eax
  803c4a:	31 d2                	xor    %edx,%edx
  803c4c:	83 c4 1c             	add    $0x1c,%esp
  803c4f:	5b                   	pop    %ebx
  803c50:	5e                   	pop    %esi
  803c51:	5f                   	pop    %edi
  803c52:	5d                   	pop    %ebp
  803c53:	c3                   	ret    
  803c54:	39 f0                	cmp    %esi,%eax
  803c56:	0f 87 ac 00 00 00    	ja     803d08 <__umoddi3+0xfc>
  803c5c:	0f bd e8             	bsr    %eax,%ebp
  803c5f:	83 f5 1f             	xor    $0x1f,%ebp
  803c62:	0f 84 ac 00 00 00    	je     803d14 <__umoddi3+0x108>
  803c68:	bf 20 00 00 00       	mov    $0x20,%edi
  803c6d:	29 ef                	sub    %ebp,%edi
  803c6f:	89 fe                	mov    %edi,%esi
  803c71:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803c75:	89 e9                	mov    %ebp,%ecx
  803c77:	d3 e0                	shl    %cl,%eax
  803c79:	89 d7                	mov    %edx,%edi
  803c7b:	89 f1                	mov    %esi,%ecx
  803c7d:	d3 ef                	shr    %cl,%edi
  803c7f:	09 c7                	or     %eax,%edi
  803c81:	89 e9                	mov    %ebp,%ecx
  803c83:	d3 e2                	shl    %cl,%edx
  803c85:	89 14 24             	mov    %edx,(%esp)
  803c88:	89 d8                	mov    %ebx,%eax
  803c8a:	d3 e0                	shl    %cl,%eax
  803c8c:	89 c2                	mov    %eax,%edx
  803c8e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c92:	d3 e0                	shl    %cl,%eax
  803c94:	89 44 24 04          	mov    %eax,0x4(%esp)
  803c98:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c9c:	89 f1                	mov    %esi,%ecx
  803c9e:	d3 e8                	shr    %cl,%eax
  803ca0:	09 d0                	or     %edx,%eax
  803ca2:	d3 eb                	shr    %cl,%ebx
  803ca4:	89 da                	mov    %ebx,%edx
  803ca6:	f7 f7                	div    %edi
  803ca8:	89 d3                	mov    %edx,%ebx
  803caa:	f7 24 24             	mull   (%esp)
  803cad:	89 c6                	mov    %eax,%esi
  803caf:	89 d1                	mov    %edx,%ecx
  803cb1:	39 d3                	cmp    %edx,%ebx
  803cb3:	0f 82 87 00 00 00    	jb     803d40 <__umoddi3+0x134>
  803cb9:	0f 84 91 00 00 00    	je     803d50 <__umoddi3+0x144>
  803cbf:	8b 54 24 04          	mov    0x4(%esp),%edx
  803cc3:	29 f2                	sub    %esi,%edx
  803cc5:	19 cb                	sbb    %ecx,%ebx
  803cc7:	89 d8                	mov    %ebx,%eax
  803cc9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803ccd:	d3 e0                	shl    %cl,%eax
  803ccf:	89 e9                	mov    %ebp,%ecx
  803cd1:	d3 ea                	shr    %cl,%edx
  803cd3:	09 d0                	or     %edx,%eax
  803cd5:	89 e9                	mov    %ebp,%ecx
  803cd7:	d3 eb                	shr    %cl,%ebx
  803cd9:	89 da                	mov    %ebx,%edx
  803cdb:	83 c4 1c             	add    $0x1c,%esp
  803cde:	5b                   	pop    %ebx
  803cdf:	5e                   	pop    %esi
  803ce0:	5f                   	pop    %edi
  803ce1:	5d                   	pop    %ebp
  803ce2:	c3                   	ret    
  803ce3:	90                   	nop
  803ce4:	89 fd                	mov    %edi,%ebp
  803ce6:	85 ff                	test   %edi,%edi
  803ce8:	75 0b                	jne    803cf5 <__umoddi3+0xe9>
  803cea:	b8 01 00 00 00       	mov    $0x1,%eax
  803cef:	31 d2                	xor    %edx,%edx
  803cf1:	f7 f7                	div    %edi
  803cf3:	89 c5                	mov    %eax,%ebp
  803cf5:	89 f0                	mov    %esi,%eax
  803cf7:	31 d2                	xor    %edx,%edx
  803cf9:	f7 f5                	div    %ebp
  803cfb:	89 c8                	mov    %ecx,%eax
  803cfd:	f7 f5                	div    %ebp
  803cff:	89 d0                	mov    %edx,%eax
  803d01:	e9 44 ff ff ff       	jmp    803c4a <__umoddi3+0x3e>
  803d06:	66 90                	xchg   %ax,%ax
  803d08:	89 c8                	mov    %ecx,%eax
  803d0a:	89 f2                	mov    %esi,%edx
  803d0c:	83 c4 1c             	add    $0x1c,%esp
  803d0f:	5b                   	pop    %ebx
  803d10:	5e                   	pop    %esi
  803d11:	5f                   	pop    %edi
  803d12:	5d                   	pop    %ebp
  803d13:	c3                   	ret    
  803d14:	3b 04 24             	cmp    (%esp),%eax
  803d17:	72 06                	jb     803d1f <__umoddi3+0x113>
  803d19:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803d1d:	77 0f                	ja     803d2e <__umoddi3+0x122>
  803d1f:	89 f2                	mov    %esi,%edx
  803d21:	29 f9                	sub    %edi,%ecx
  803d23:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803d27:	89 14 24             	mov    %edx,(%esp)
  803d2a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d2e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803d32:	8b 14 24             	mov    (%esp),%edx
  803d35:	83 c4 1c             	add    $0x1c,%esp
  803d38:	5b                   	pop    %ebx
  803d39:	5e                   	pop    %esi
  803d3a:	5f                   	pop    %edi
  803d3b:	5d                   	pop    %ebp
  803d3c:	c3                   	ret    
  803d3d:	8d 76 00             	lea    0x0(%esi),%esi
  803d40:	2b 04 24             	sub    (%esp),%eax
  803d43:	19 fa                	sbb    %edi,%edx
  803d45:	89 d1                	mov    %edx,%ecx
  803d47:	89 c6                	mov    %eax,%esi
  803d49:	e9 71 ff ff ff       	jmp    803cbf <__umoddi3+0xb3>
  803d4e:	66 90                	xchg   %ax,%ax
  803d50:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803d54:	72 ea                	jb     803d40 <__umoddi3+0x134>
  803d56:	89 d9                	mov    %ebx,%ecx
  803d58:	e9 62 ff ff ff       	jmp    803cbf <__umoddi3+0xb3>
